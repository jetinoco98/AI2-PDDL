(define (problem robot-problem)

    (:domain robot)

    (:objects
        ; Robots
        robot-x
        robot-y
        ; Locations
        node-a node-b node-c node-d
        node-e node-f node-g node-h
        ; Tools
        camera lidar thermal-sensor
        ; End-Effector Configurations
        default camera-config lidar-config thermal-config
    )

    (:init
    
        ; *************************
        ; DECLARATION OF PREDICATES
        ; *************************
        
        ; Robots
        (ROBOT robot-x)
        (ROBOT robot-y)
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
        
        ; *************************
        ; DECLARATION OF FLUENTS
        ; *************************
        
        ; Initial locations
        (at_robot robot-x node-a)
        (at_robot robot-y node-a)

        ; The tools carried by the robots
        (has_tool robot-x camera)
        (has_tool robot-x thermal-sensor)

        (has_tool robot-y camera)
        (has_tool robot-y lidar)

        ; Connections
        (connected node-a node-b)
        (connected node-b node-a)

        (connected node-b node-c)
        (connected node-c node-b)

        (connected node-c node-d)
        (connected node-c node-f)
        (connected node-d node-c)
        (connected node-f node-c)

        (connected node-d node-e)
        (connected node-e node-d)

        (connected node-e node-f)
        (connected node-f node-e)

        (connected node-f node-g)
        (connected node-g node-h)

        (connected node-g node-h)
        (connected node-h node-g)

        ; Robot positioning: None
        ; Arm extension: None
        
        ; Tool and configuration compatibility
        (tool_compatible_with_config camera camera-config)
        (tool_compatible_with_config lidar lidar-config)
        (tool_compatible_with_config thermal-sensor thermal-config)

        ; End-effector initial positioning
        (has_end_effector_positioned_to_config robot-x default)
        (has_end_effector_positioned_to_config robot-y default)

        ; Active tool: None
        ; Acquired data: None

        ; Default configuration of the end effector
        (init_config default)

        ; Robot has active tools: None

    )


    (:goal
        (and (at_robot robot-x node-b)
            (at_robot robot-y node-a)

            (acquired_data_of_loc_with_tool node-e camera)
            (acquired_data_of_loc_with_tool node-e lidar)

            (acquired_data_of_loc_with_tool node-g camera)
            ;(acquired_data_of_loc_with_tool node-g lidar)
            ;(acquired_data_of_loc_with_tool node-g thermal-sensor)
        )
    )

    
)
