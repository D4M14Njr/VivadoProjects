set project_name prac_4-tcl
set project_found [llength [get_projects $project_name] ]
if {$project_found > 0} close_project

set origin_dir [file dirname [info script]]
cd $origin_dir
set path $origin_dir/$project_name/$project_name

# Создание проекта
create_project $project_name $project_name -force -part xc7a100tcsg324-1

# Добавление файлов дизайна
file mkdir $path.srcs/designs
set design_file_list [list clk_div.v counter.v debouncer.v fsm.v main.v seven_segment_led.v vio_main.v]
foreach s $design_file_list {
	file copy $origin_dir/${s} ${path}.srcs/designs/${s}
	add_files -fileset sources_1 -norecurse ${path}.srcs/designs/${s}
}

# Добавление файлов тестового окружения
file mkdir $path.srcs/testbenches
set test_name_list [list test_clk_div test_debouncer test_fsm test_main test_seven_segment_led]

# Формирование ассоциативного массива формата (тестовый модуль - список файлов дизайнов для тестирования)
set test_set_designs(test_clk_div) [list clk_div.v counter.v]
set test_set_designs(test_seven_segment_led) [list seven_segment_led.v]
set test_set_designs(test_fsm) [list fsm.v]
set test_set_designs(test_debouncer) [list debouncer.v]
set test_set_designs(test_main) [list main.v clk_div.v debouncer.v fsm.v seven_segment_led.v counter.v]

# Создание и настройка сета симуляции для каждого тестового модуля
foreach s $test_name_list {

    # Создание сета симуляции
    set set_name ${s}_set
    file mkdir ${path}.srcs/testbenches/${set_name}
    create_fileset -simset $set_name
    set_property SOURCE_SET {} [ get_filesets $set_name ]

    # Добавления модулей дизайна в сет
    set designs $test_set_designs(${s})
    foreach design $designs {
        add_files -fileset $set_name -norecurse ${path}.srcs/designs/$design
    }

    # Добавление тестового модуля в сет
    file copy $origin_dir/${s}.v ${path}.srcs/testbenches/${set_name}/${s}.v
    add_files -fileset $set_name ${path}.srcs/testbenches/${set_name}/${s}.v
    set_property TOP ${s} [get_filesets ${set_name}]
}

# Удаление сета симуляции по умолчанию
current_fileset -simset [get_filesets test_seven_segment_led_set]
delete_fileset [ get_filesets sim_1 ]
file delete -force $path.srcs/sim_1

# Создание сетов для файлов проектных ограничений
create_fileset -constrset constr_100_mhz_set
create_fileset -constrset constr_200_mhz_set
create_fileset -constrset constr_100_mhz_vio_set
create_fileset -constrset constr_200_mhz_vio_set

# Ассоциативный массив с указанием модуля верхнего уровня
# для каждого сета проектных ограничений
array set constrset_upper_module {
    constr_100_mhz_set main
    constr_200_mhz_set main
    constr_100_mhz_vio_set vio_main
    constr_200_mhz_vio_set vio_main
}

# Удаление сета проектных ограничений по умолчанию
set_property constrset constr_100_mhz_set [get_runs synth_1]
set_property constrset constr_100_mhz_set [get_runs impl_1]
delete_fileset [ get_filesets constrs_1 ]
file delete -force $path.srcs/constrs_1

# Добавление файлов проектных ограничений в проект
file mkdir $path.srcs/constrs/main
file mkdir $path.srcs/constrs/vio_main
file copy $origin_dir/constr_100_mhz.xdc $path.srcs/constrs/main/constr_100_mhz.xdc
file copy $origin_dir/constr_200_mhz.xdc $path.srcs/constrs/main/constr_200_mhz.xdc
file copy $origin_dir/constr_100_mhz_vio.xdc $path.srcs/constrs/vio_main/constr_100_mhz_vio.xdc
file copy $origin_dir/constr_200_mhz_vio.xdc $path.srcs/constrs/vio_main/constr_200_mhz_vio.xdc
add_files -fileset constr_100_mhz_set -norecurse $path.srcs/constrs/main/constr_100_mhz.xdc
add_files -fileset constr_200_mhz_set -norecurse $path.srcs/constrs/main/constr_200_mhz.xdc
add_files -fileset constr_100_mhz_vio_set -norecurse $path.srcs/constrs/vio_main/constr_100_mhz_vio.xdc
add_files -fileset constr_200_mhz_vio_set -norecurse $path.srcs/constrs/vio_main/constr_200_mhz_vio.xdc

# Создание IP-ядра VIO
create_ip -name vio -vendor xilinx.com -library ip -version 3.0 -module_name vio_0
set_property -dict [list \
  CONFIG.C_NUM_PROBE_IN {2} \
  CONFIG.C_NUM_PROBE_OUT {3} \
  CONFIG.C_PROBE_IN0_WIDTH {8} \
  CONFIG.C_PROBE_IN1_WIDTH {7} \
  CONFIG.C_PROBE_OUT2_WIDTH {16} \
] [get_ips vio_0]

generate_target {instantiation_template} [get_files "$path.srcs/sources_1/ip/vio_0/vio_0.xci"]

update_compile_order -fileset sources_1
generate_target all [get_files  "$path.srcs/sources_1/ip/vio_0/vio_0.xci"]

catch { config_ip_cache -export [get_ips -all vio_0] }
export_ip_user_files -of_objects [get_files "$path.srcs/sources_1/ip/vio_0/vio_0.xci"] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] "$path.srcs/sources_1/ip/vio_0/vio_0.xci"]
launch_runs vio_0_synth_1 -jobs 16
wait_on_runs vio_0_synth_1
export_simulation -of_objects [get_files "$path.srcs/sources_1/ip/vio_0/vio_0.xci"] -directory "$path.ip_user_files/sim_scripts" -ip_user_files_dir "$path.ip_user_files" -ipstatic_source_dir "$path.ip_user_files/ipstatic" -lib_map_path [list {modelsim="$path.cache/compile_simlib/modelsim"} {questa="$path.cache/compile_simlib/questa"} {riviera="$path.cache/compile_simlib/riviera"} {activehdl="$path.cache/compile_simlib/activehdl"}] -use_ip_compiled_libs -force -quiet

# Симуляция на разных наборах (simulation sets)
foreach t_set [ get_filesets test* ] {
    current_fileset -simset $t_set
    file mkdir $origin_dir/$project_name/sim_output/${t_set}

# Команда сбрасывает время симуляции
   set_property -name xsim.simulate.runtime -value 0 -objects [get_filesets ${t_set}]

   launch_simulation

# Запуск симуляции на 100000ns и перенаправление вывода из TCL-консоли в файл
   restart
   run 100000ns > "$origin_dir/$project_name/sim_output/${t_set}/sim_output.txt"

   close_sim
}

# Имплементация на разных наборах (constraints set)
foreach c_set [ get_filesets constr* ] {
    set_property constrset $c_set [get_runs synth_1]
    set_property constrset $c_set [get_runs impl_1]
    set_property TOP $constrset_upper_module($c_set) [get_fileset sources_1]
    reset_run synth_1
    launch_runs synth_1 -jobs 16
    wait_on_run synth_1
    reset_run impl_1
    launch_runs impl_1 -jobs 16

    wait_on_run impl_1
    open_run impl_1
    report_timing_summary -file "$origin_dir/$project_name/timing_summary_${c_set}"
}

