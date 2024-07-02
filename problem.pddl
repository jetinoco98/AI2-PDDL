(define (problem robot-problem)

    (:domain robot)

    (:objects
        ; Robots
        robot-x - ROBOT
        ; Locations
        node-a node-b node-c node-d - LOCATION
        node-e node-f node-g node-h - LOCATION
        ; Tools
        camera lidar thermal-sensor - TOOL
        ; End-Effector Configurations
        default camera-config lidar-config thermal-config - EE-CONFIG
        ; Data
        image-data point-cloud thermal-data - DATA
        worker-activity structural-integrity temperature-variation - DATA
    )

    (:init
        
        ; *************************
        ; DECLARATION OF FLUENTS
        ; *************************
        
        ; Initial locations
        (at_robot robot-x node-a)

        ; Initial robots with reports
        (is_free_of_reports robot-x)

        ; The tools carried by the robots
        (has_tool robot-x camera)
        (has_tool robot-x lidar)
        (has_tool robot-x thermal-sensor)

        ; Connections
        (connected node-a node-b) (connected node-b node-a)

        (connected node-b node-c) (connected node-c node-b)

        (connected node-c node-d) (connected node-d node-c)
        (connected node-c node-e) (connected node-e node-c)
        (connected node-c node-f) (connected node-f node-c)

        (connected node-d node-e) (connected node-e node-d)

        (connected node-e node-f) (connected node-f node-e)

        (connected node-f node-g) (connected node-g node-h)

        (connected node-g node-h) (connected node-h node-g)
        
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

        ; Location must be inspected with tool
        (inspection_with_tool node-a camera)
        (inspection_with_tool node-a lidar)
        (inspection_with_tool node-a thermal-sensor)
        
        (inspection_with_tool node-b lidar)
        (inspection_with_tool node-c camera)
        (inspection_with_tool node-d lidar)
        (inspection_with_tool node-e camera)

        (inspection_with_tool node-f thermal-sensor)
        (inspection_with_tool node-f lidar)
        
        (inspection_with_tool node-g camera)
        (inspection_with_tool node-h camera)

        ; Locations that must be inspected
        (location_must_be_inspected node-a)
        (location_must_be_inspected node-b)
        (location_must_be_inspected node-c)
        ;(location_must_be_inspected node-d)
        (location_must_be_inspected node-e)
        (location_must_be_inspected node-f)
        (location_must_be_inspected node-g)
        ;(location_must_be_inspected node-h)

        ; Data Collection/Processing counters initialization
        (= (acquired_data image-data node-a) 0)
        (= (acquired_data worker-activity node-a) 0)
        (= (acquired_data point-cloud node-a) 0)
        (= (acquired_data structural-integrity node-a) 0)
        (= (acquired_data thermal-data node-a) 0)
        (= (acquired_data temperature-variation node-a) 0)

        (= (acquired_data point-cloud node-b) 0)
        (= (acquired_data structural-integrity node-b) 0)

        (= (acquired_data image-data node-c) 0)
        (= (acquired_data worker-activity node-c) 0)

        (= (acquired_data point-cloud node-d) 0)
        (= (acquired_data structural-integrity node-d) 0)

        (= (acquired_data image-data node-e) 0)
        (= (acquired_data worker-activity node-e) 0)
        
        (= (acquired_data thermal-data node-f) 0)
        (= (acquired_data temperature-variation node-f) 0)
        (= (acquired_data point-cloud node-f) 0)
        (= (acquired_data structural-integrity node-f) 0)
        
        (= (acquired_data image-data node-g) 0)
        (= (acquired_data worker-activity node-g) 0)
        
        (= (acquired_data image-data node-h) 0)
        (= (acquired_data worker-activity node-h) 0)
        
    )


    (:goal
        (and 
            ; Data Collection
            (= (acquired_data image-data node-a) 3)
            (= (acquired_data point-cloud node-a) 2)
            (= (acquired_data thermal-data node-a) 1)
            (= (acquired_data point-cloud node-b) 1)
            (= (acquired_data image-data node-c) 1)
            (= (acquired_data image-data node-e) 1)
            (= (acquired_data point-cloud node-f) 1)
            (= (acquired_data thermal-data node-f) 1)
            (= (acquired_data image-data node-g) 1)
            ; Reporting
            (is_free_of_reports robot-x)
        )
    )

)
