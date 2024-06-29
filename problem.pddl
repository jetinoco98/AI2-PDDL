(define (problem robot-problem)

    (:domain robot)

    (:objects
        ; Robots
        robot-x
        ; Locations
        node-a node-b node-c node-d
        node-e node-f node-g node-h
        ; Tools
        camera lidar thermal-sensor
        ; End-Effector Configurations
        default camera-config lidar-config thermal-config
        ; Data
        image-data point-cloud thermal-data 
        worker-activity structural-integrity temperature-variation
    )

    (:init
    
        ; *************************
        ; DECLARATION OF PREDICATES
        ; *************************
        
        ; Robots
        (ROBOT robot-x)
        ; Locations
        (LOCATION node-a)
        (LOCATION node-b)
        (LOCATION node-c)
        (LOCATION node-d)
        (LOCATION node-e)
        (LOCATION node-f)
        (LOCATION node-g)
        (LOCATION node-h)
        ; Tools
        (TOOL camera)
        (TOOL lidar)
        (TOOL thermal-sensor)
        ; Configuration
        (EE-CONFIG default)
        (EE-CONFIG camera-config)
        (EE-CONFIG lidar-config)
        (EE-CONFIG thermal-config)
        ; Data
        (DATA image-data)
        (DATA point-cloud)
        (DATA thermal-data)
        (DATA worker-activity)
        (DATA structural-integrity)
        (DATA temperature-variation)
        
        ; *************************
        ; DECLARATION OF FLUENTS
        ; *************************
        
        ; Initial locations
        (at_robot robot-x node-a)

        ; The tools carried by the robots
        (has_tool robot-x camera)
        (has_tool robot-x lidar)
        (has_tool robot-x thermal-sensor)

        ; Connections
        (connected node-a node-b)
        (connected node-b node-a)

        (connected node-b node-c)
        (connected node-c node-b)

        (connected node-c node-d)
        (connected node-c node-e)
        (connected node-c node-f)
        (connected node-d node-c)
        (connected node-e node-c)
        (connected node-f node-c)

        (connected node-d node-e)
        (connected node-e node-d)

        (connected node-e node-f)
        (connected node-f node-e)

        (connected node-f node-g)
        (connected node-g node-h)

        (connected node-g node-h)
        (connected node-h node-g)
        
        ; Tool and configuration compatibility
        (tool_compatible_with_config camera camera-config)
        (tool_compatible_with_config lidar lidar-config)
        (tool_compatible_with_config thermal-sensor thermal-config)

        ; End-effector initial positioning
        (has_end_effector_positioned_to_config robot-x default)

        ; Default configuration of the end effector
        (init_config default)

        ; Tool to data relationship
        (tool_to_data_relationship camera image-data)
        (tool_to_data_relationship lidar point-cloud)
        (tool_to_data_relationship thermal-sensor thermal-data)

        ; Data Conversion
        (lidar_data_conversion point-cloud structural-integrity) 
        (camera_data_conversion image-data worker-activity) 
        (thermal_data_conversion thermal-data temperature-variation) 

        ; Location must be inspected with tool n times
        (inspection_with_tool node-a camera)
        (inspection_with_tool node-b lidar)
        (inspection_with_tool node-c camera)

        (inspection_with_tool node-d camera)
        (inspection_with_tool node-d lidar)

        (inspection_with_tool node-e camera)
        (inspection_with_tool node-e lidar)
        (inspection_with_tool node-e thermal-sensor)

        (inspection_with_tool node-f thermal-sensor)
        (inspection_with_tool node-g camera)
        (inspection_with_tool node-h lidar)

        ; actions_on_inspection

        ; Data Collection counters
        (= (acquired_data image-data node-a) 0)

        ; Data Processing counters
        (= (acquired_data worker-activity node-a) 0)

    )


    (:goal
        (and 
            ; Data Collection
            (= (acquired_data image-data node-a) 2)

            ; Data Processing
            (= (acquired_data worker-activity node-a) 1)

            ; Reporting
        )
    )

    
)
