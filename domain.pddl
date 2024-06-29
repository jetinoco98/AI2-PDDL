(define (domain robot)

    (:requirements :strips :negative-preconditions :fluents)
    
    (:predicates
    
        ; ******************
        ; Predicates
        ; ******************
        (ROBOT ?r)
        (LOCATION ?l)
        (TOOL ?t)
        (EE-CONFIG ?c)
        (DATA ?d)
        
        ; ******************
        ; Action Effect Fluents
        ; ******************
        
        ; Robot ?r is located in location ?l
        (at_robot ?r ?l)
        ; The robot ?r is firmly positioned in the ground
        (is_positioned ?r)
        ; The robot ?r has its manipulator arm extended
        (has_arm_extended ?r)
        ; The robot ?r has its manipulator end-effector positioned in configuration ?c
        (has_end_effector_positioned_to_config ?r ?c)
        ; The robot ?r has its tool ?t active
        (active_tool ?r ?t)
        ; The robot ?r has any of its tools active
        (has_any_active_tool ?r)

        ; ******************
        ; Purely Initial State Fluents 
        ; ******************
    
        ; Robot ?r has the tool ?t
        (has_tool ?r ?t)
        ; Location ?from is connected to location ?to (edge)
        (connected ?from ?to)
        ; The tool ?t can be used with end-effector configuration ?c
        (tool_compatible_with_config ?t ?c)
        ; Initial end-effector configuration
        (init_config ?c)
        ; The location ?l must be inspected with tool ?t
        (inspection_with_tool ?l ?t)
        ; Tool to data relationship
        (tool_to_data_relationship ?t ?d)
        ; Data Conversion
        (lidar_data_conversion ?d_old ?d_new)
        (camera_data_conversion ?d_old ?d_new)
        (thermal_data_conversion ?d_old ?d_new)
        ; Acquired data ?d of location ?l by robot ?r
        (acquired_data_by ?d ?l ?r)
    )

    (:functions
        ; Acquired data ?d of location ?l
        (acquired_data ?d ?l)
    )

    ; ACTIONS: Navigation, positioning, inspection and data collection
    ; (+) Activation

    (:action move
        ; Move the robot ?r from location ?from to ?to
        :parameters (?r ?from ?to)
        :precondition (and (ROBOT ?r)(LOCATION ?from) (LOCATION ?to) 
        (at_robot ?r ?from) (connected ?from ?to) 
        (not (is_positioned ?r))
        )
        :effect (and (at_robot ?r ?to) (not (at_robot ?r ?from)))
    )

    (:action anchor
        ; Position the robot ?r firmly on the ground
        :parameters (?r)
        :precondition (and (ROBOT ?r) (not (is_positioned ?r)))
        :effect (and (is_positioned ?r))
    )

    (:action extend-arm
        ; Extends the manipulator arm of robot ?r
        :parameters (?r)
        :precondition (and (ROBOT ?r) (not (has_arm_extended ?r))
        (is_positioned ?r)
        )
        :effect (and (has_arm_extended ?r))
    )
    
    (:action position_end_effector
        :parameters (?r ?c_old ?c_new)
        :precondition (and (ROBOT ?r) (EE-CONFIG ?c_old) (EE-CONFIG ?c_new)
        (is_positioned ?r)
        (has_arm_extended ?r)
        (has_end_effector_positioned_to_config ?r ?c_old)
        (not(has_any_active_tool ?r))
        )
        :effect (and (has_end_effector_positioned_to_config ?r ?c_new)
        (not(has_end_effector_positioned_to_config ?r ?c_old))
        )
    )

    (:action activate_tool
        :parameters (?r ?t ?c)
        :precondition (and (ROBOT ?r) (TOOL ?t) (EE-CONFIG ?c)
        (has_tool ?r ?t)
        (is_positioned ?r)
        (has_arm_extended ?r)
        (has_end_effector_positioned_to_config ?r ?c)
        (tool_compatible_with_config ?t ?c)
        )
        :effect (and (active_tool ?r ?t)
        (has_any_active_tool ?r)
        )
    )

    (:action acquire_data
        :parameters (?r ?l ?t ?d)
        :precondition (and (ROBOT ?r) (LOCATION ?l) (TOOL ?t) (DATA ?d)
        (at_robot ?r ?l)
        (is_positioned ?r)
        (has_arm_extended ?r)
        (active_tool ?r ?t)
        (inspection_with_tool ?l ?t)
        (tool_to_data_relationship ?t ?d)
        )
        :effect (and 
            (increase (acquired_data ?d ?l) 1)
            (acquired_data_by ?d ?l ?r)
        )
    )

    ; ACTIONS: Data Processing
    
    (:action structural_integrity_analysis
        :parameters (?r ?l ?d_old ?d_new)
        :precondition (and (ROBOT ?r) (LOCATION ?l) (DATA ?d_old) (DATA ?d_new)
        (at_robot ?r ?l)
        (acquired_data_by ?d_old ?l ?r)
        (lidar_data_conversion ?d_old ?d_new)
        )
        :effect (and 
            (increase (acquired_data ?d_new ?l) 1)
            (acquired_data_by ?d_new ?l ?r)
        )
    )
    
    (:action worker_activity_analysis
        :parameters (?r ?l ?d_old ?d_new)
        :precondition (and (ROBOT ?r) (LOCATION ?l) (DATA ?d_old) (DATA ?d_new)
        (at_robot ?r ?l)
        (acquired_data_by ?d_old ?l ?r)
        (camera_data_conversion ?d_old ?d_new)
        )
        :effect (and 
            (increase (acquired_data ?d_new ?l) 1)
            (acquired_data_by ?d_new ?l ?r)
        )
    )

    (:action temperature_variation_analysis
        :parameters (?r ?l ?d_old ?d_new)
        :precondition (and (ROBOT ?r) (LOCATION ?l) (DATA ?d_old) (DATA ?d_new)
        (at_robot ?r ?l)
        (acquired_data_by ?d_old ?l ?r)
        (thermal_data_conversion ?d_old ?d_new)
        )
        :effect (and 
            (increase (acquired_data ?d_new ?l) 1)
            (acquired_data_by ?d_new ?l ?r)
        )
    )
    
    ; ACTIONS: Navigation, positioning, inspection and data collection
    ; (+) Deactivation

    (:action deactivate_tool
        :parameters (?r ?t)
        :precondition (and (ROBOT ?r) (TOOL ?t) (has_tool ?r ?t)
        (active_tool ?r ?t))
        :effect (and (not(active_tool ?r ?t))
        (not(has_any_active_tool ?r))
        )
    )

    (:action unextend-arm
        ; Un-extends the manipulator arm of robot ?r
        :parameters (?r ?c)
        :precondition (and (ROBOT ?r) (has_arm_extended ?r) (EE-CONFIG ?c)
        (not(has_any_active_tool ?r))
        (init_config ?c)
        (has_end_effector_positioned_to_config ?r ?c)
        )
        :effect (and (not(has_arm_extended ?r)))
    )

    (:action remove-anchor
        ; Position the robot ?r firmly on the ground
        :parameters (?r)
        :precondition (and (ROBOT ?r) (is_positioned ?r)
        (not(has_arm_extended ?r))
        )
        :effect (and (not(is_positioned ?r)))
    )
    

    ; ACTIONS: Data Reporting


    
    

)
