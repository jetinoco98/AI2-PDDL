(define (domain robot)

    (:requirements :strips :negative-preconditions)
    
    (:predicates
    
        ;; Predicates
        (ROBOT ?r)
        (LOCATION ?l)
        (TOOL ?t)
        (EE-CONFIG ?c)
        
        ;; Fluents
        
        ; Robot ?r is located in location ?l
        (at_robot ?r ?l)
        ; Robot ?r has the tool ?t
        (has_tool ?r ?t)
        ; Location ?from is connected to location ?to (edge)
        (connected ?from ?to)
        ; The robot ?r is firmly positioned in the ground
        (is_positioned ?r)
        ; The robot ?r has its manipulator arm extended
        (has_arm_extended ?r)
        ; The tool ?t can be used with end-effector configuration ?c
        (tool_compatible_with_config ?t ?c)
        ; The robot ?r has its manipulator end-effector positioned in configuration ?c
        (has_end_effector_positioned_to_config ?r ?c)
        ; The robot ?r has its tool ?t active
        (active_tool ?r ?t)
        ; Data acquired of location ?l with tool ?t
        (acquired_data_of_loc_with_tool ?l ?t)
        ; Initial end-effector configuration
        (init_config ?c)
        ; The robot ?r has any of its tools active
        (has_any_active_tool ?r)
        
    )

    ; ACTIONS: Navigation, positioning, inspection and data collection
    ; (+) Activation

    (:action move
        ; Move the robot ?r from location ?from to ?to
        :parameters (?r ?from ?to)
        :precondition (and (ROBOT ?r)(LOCATION ?from) (LOCATION ?to) 
        (at_robot ?r ?from) (connected ?from ?to) 
        (not (is_positioned ?r))
        (not (has_arm_extended ?r))
        (not (has_any_active_tool ?r)) 
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
        :parameters (?r ?l ?t ?c)
        :precondition (and (ROBOT ?r) (LOCATION ?l) (TOOL ?t) (EE-CONFIG ?c)
        (at_robot ?r ?l)
        (has_tool ?r ?t)
        (is_positioned ?r)
        (has_arm_extended ?r)
        (has_end_effector_positioned_to_config ?r ?c)
        (tool_compatible_with_config ?t ?c)
        (active_tool ?r ?t)
        )
        :effect (and (acquired_data_of_loc_with_tool ?l ?t))
    )
    
    ; ACTIONS: Navigation, positioning, inspection and data collection
    ; (+) Deactivation

    (:action deactivate_tool
        :parameters (?r ?t ?c_init)
        :precondition (and (ROBOT ?r) (TOOL ?t)
        (has_tool ?r ?t)
        (has_arm_extended ?r)
        (init_config ?c_init)
        (has_end_effector_positioned_to_config ?r ?c_init)
        )
        :effect (and (not(active_tool ?r ?t))
        (not(has_any_active_tool ?r))
        )
    )

    (:action unextend-arm
        ; Un-extends the manipulator arm of robot ?r
        :parameters (?r)
        :precondition (and (ROBOT ?r) (has_arm_extended ?r)
        (not(has_any_active_tool ?r))
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

    
)
