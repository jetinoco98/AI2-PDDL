(define (domain robot)

   (:requirements :strips :negative-preconditions :existential-preconditions :typing :fluents)

    (:types 
        ROBOT
        LOCATION
        TOOL
        EE-CONFIG
        DATA
    )
    
    (:predicates
    
        ; ******************
        ; Action Effect Fluents
        ; ******************
        
        ; Robot ?r is located in location ?l
        (at_robot ?r - ROBOT ?l - LOCATION)
        ; The robot ?r is firmly positioned in the ground
        (is_positioned ?r - ROBOT)
        ; The robot ?r has its manipulator arm extended
        (has_arm_extended ?r - ROBOT)
        ; The robot ?r has its manipulator end-effector positioned in configuration ?c
        (has_end_effector_positioned_to_config ?r - ROBOT ?c - EE-CONFIG)
        ; The robot ?r has its tool ?t active
        (active_tool ?r - ROBOT ?t - TOOL)
        ; The robot ?r has any of its tools active
        (has_any_active_tool ?r - ROBOT)
        ; Acquired data ?d of location ?l by robot ?r
        (acquired_data_by ?d - DATA ?l - LOCATION ?r - ROBOT)
        ; The inspection was initialized in location ?l by robot ?r
        (initialized_inspection ?l - LOCATION ?r - ROBOT)
        ; The robot ?r has unprocessed data
        (has_unprocessed_data ?r - ROBOT)
        ; The robot ?r is in a wait state where it needs to report all the data from current location
        (reporting_wait_state ?r - ROBOT)
        ; The robot ?r is free of reports
        (is_free_of_reports ?r)
        ; The robot ?r updated the database from location ?l
        (updated_database ?r ?l)
        ; The session was closed by robot ?r on location ?l


        ; ******************
        ; Purely Initial State Fluents 
        ; ******************
    
        ; Robot ?r has the tool ?t
        (has_tool ?r - ROBOT ?t - TOOL)
        ; Location ?from is connected to location ?to (edge)
        (connected ?from ?to - LOCATION)
        ; The tool ?t can be used with end-effector configuration ?c
        (tool_compatible_with_config ?t - TOOL ?c - EE-CONFIG)
        ; Initial end-effector configuration
        (init_config ?c - EE-CONFIG)
        ; The location ?l must be inspected with tool ?t
        (inspection_with_tool ?l - LOCATION ?t - TOOL)
        ; Tool to data relationship
        (tool_to_data_relationship ?t - TOOL ?d - DATA)
        ; Data Conversion
        (lidar_data_conversion ?d_old - DATA ?d_new - DATA)
        (camera_data_conversion ?d_old - DATA ?d_new - DATA)
        (thermal_data_conversion ?d_old - DATA ?d_new - DATA)
        ; Locations that must be inspected
        (location_must_be_inspected ?l - LOCATION)

    )

    (:functions
        ; Acquired data ?d of location ?l
        (acquired_data ?d - DATA ?l - LOCATION)
    )

    ; ACTIONS: Navigation, positioning, inspection and data collection
    ; (+) Activation

    (:action move
        ; Move the robot ?r from location ?from to ?to
        :parameters (?r - ROBOT ?from - LOCATION ?to - LOCATION)
        :precondition (and
            (at_robot ?r ?from) 
            (connected ?from ?to) 
            (not (is_positioned ?r))
            (not (reporting_wait_state ?r))
        )
        :effect (and (at_robot ?r ?to) (not (at_robot ?r ?from)))
    )

    (:action anchor
        ; Position the robot ?r firmly on the ground
        :parameters (?r - ROBOT ?l - LOCATION)
        :precondition (and
            (at_robot ?r ?l)
            (location_must_be_inspected ?l)
            (not (is_positioned ?r))
            (not (initialized_inspection ?l ?r))
        )
        :effect (and (is_positioned ?r)
            (initialized_inspection ?l ?r)
        )
    )

    (:action extend-arm
        ; Extends the manipulator arm of robot ?r
        :parameters (?r - ROBOT)
        :precondition (and
            (not (has_arm_extended ?r))
            (is_positioned ?r)
        )
        :effect (and (has_arm_extended ?r))
    )
    
    (:action position_end_effector
        :parameters (?r - ROBOT ?c_old - EE-CONFIG ?c_new - EE-CONFIG)
        :precondition (and
            (is_positioned ?r)
            (has_arm_extended ?r)
            (has_end_effector_positioned_to_config ?r ?c_old)
            (not(has_any_active_tool ?r))
        )
        :effect (and 
            (has_end_effector_positioned_to_config ?r ?c_new)
            (not(has_end_effector_positioned_to_config ?r ?c_old))
        )
    )

    (:action activate_tool
        :parameters (?r - ROBOT ?t - TOOL ?c - EE-CONFIG)
        :precondition (and
            (has_tool ?r ?t)
            (is_positioned ?r)
            (has_arm_extended ?r)
            (has_end_effector_positioned_to_config ?r ?c)
            (tool_compatible_with_config ?t ?c)
        )
        :effect (and 
            (active_tool ?r ?t)
            (has_any_active_tool ?r)
        )
    )

    (:action acquire_data
        :parameters (?r - ROBOT ?l - LOCATION ?t - TOOL ?d - DATA)
        :precondition (and
            (at_robot ?r ?l)
            (is_positioned ?r)
            (has_arm_extended ?r)
            (active_tool ?r ?t)
            (inspection_with_tool ?l ?t)
            (tool_to_data_relationship ?t ?d)
            (not (has_unprocessed_data ?r))
        )
        :effect (and 
            (increase (acquired_data ?d ?l) 1)
            (acquired_data_by ?d ?l ?r)
            (has_unprocessed_data ?r)
            (not (is_free_of_reports ?r))
        )
    )

    ; ACTIONS: Data Processing
    
    (:action structural_integrity_analysis
        :parameters (?r - ROBOT ?l - LOCATION ?d_old - DATA ?d_new - DATA)
        :precondition (and
            (at_robot ?r ?l)
            (acquired_data_by ?d_old ?l ?r)
            (lidar_data_conversion ?d_old ?d_new)
        )
        :effect (and 
            (increase (acquired_data ?d_new ?l) 1)
            (acquired_data_by ?d_new ?l ?r)
            (not (has_unprocessed_data ?r))
        )
    )
    
    (:action worker_activity_analysis
        :parameters (?r - ROBOT ?l - LOCATION ?d_old - DATA ?d_new - DATA)
        :precondition (and
            (at_robot ?r ?l)
            (acquired_data_by ?d_old ?l ?r)
            (camera_data_conversion ?d_old ?d_new)
        )
        :effect (and 
            (increase (acquired_data ?d_new ?l) 1)
            (acquired_data_by ?d_new ?l ?r)
            (not (has_unprocessed_data ?r))
        )
    )

    (:action temperature_variation_analysis
        :parameters (?r - ROBOT ?l - LOCATION ?d_old - DATA ?d_new - DATA)
        :precondition (and
            (at_robot ?r ?l)
            (acquired_data_by ?d_old ?l ?r)
            (thermal_data_conversion ?d_old ?d_new)
        )
        :effect (and 
            (increase (acquired_data ?d_new ?l) 1)
            (acquired_data_by ?d_new ?l ?r)
            (not (has_unprocessed_data ?r))
        )
    )

    ; ACTIONS: Data Reporting

    (:action format_data
        :parameters (?r - ROBOT ?l - LOCATION ?d - DATA)
        :precondition (and 
            (at_robot ?r ?l)
            (reporting_wait_state ?r)
            (acquired_data_by ?d ?l ?r)
        )
        :effect (and 
            (not (acquired_data_by ?d ?l ?r))
        )
    )

    (:action update_database
        :parameters (?r - ROBOT ?l - LOCATION)
        :precondition (and 
            (at_robot ?r ?l)
            (reporting_wait_state ?r) 
            (not (exists (?d1 - DATA ?l1 - LOCATION ?r1 - ROBOT) (acquired_data_by ?d1 ?l1 ?r1)))             
        )
        :effect (and (updated_database ?r ?l))
    )

    (:action close_session
        :parameters (?r - ROBOT ?l - LOCATION)
        :precondition (and 
            (at_robot ?r ?l)
            (reporting_wait_state ?r)
            (updated_database ?r ?l)
        )
        :effect (and 
            (not(reporting_wait_state ?r))
            (is_free_of_reports ?r)
        )
    )
    
    
    ; ACTIONS: Navigation, positioning, inspection and data collection
    ; (+) Reversal or Deactivation

    (:action deactivate_tool
        :parameters (?r - ROBOT ?t - TOOL)
        :precondition (and
            (has_tool ?r ?t)
            (active_tool ?r ?t)
            (not (has_unprocessed_data ?r))
        )
        :effect (and 
            (not(active_tool ?r ?t))
            (not(has_any_active_tool ?r))
        )
    )

    (:action unextend-arm
        ; Un-extends the manipulator arm of robot ?r
        :parameters (?r - ROBOT ?c - EE-CONFIG)
        :precondition (and
            (not(has_any_active_tool ?r))
            (init_config ?c)
            (has_end_effector_positioned_to_config ?r ?c)
        )
        :effect (and 
            (not(has_arm_extended ?r))
        )
    )

    (:action remove-anchor
        ; Position the robot ?r firmly on the ground
        :parameters (?r - ROBOT)
        :precondition (and
            (is_positioned ?r)
            (not(has_arm_extended ?r))
        )
        :effect (and 
            (not(is_positioned ?r)) 
            (reporting_wait_state ?r)
        )
    ) 
    
)
