*** Settings ***
Documentation       K8s keywords

Library             ../libs/keywords/k8s_keywords.py
Library             ../libs/keywords/workload_keywords.py
Library             ../libs/keywords/volume_keywords.py
Library             ../libs/keywords/host_keywords.py

*** Variables ***


*** Keywords ***
Stop volume node kubelet of ${workload_kind} ${workload_id} for ${duration} seconds
    ${workload_name} =   generate_name_with_suffix    ${workload_kind}    ${workload_id}
    ${volume_name} =    get_workload_volume_name    ${workload_name}
    ${node_name} =    get_volume_node    ${volume_name}
    restart_kubelet    ${node_name}    ${duration}

Delete volume of ${workload_kind} ${workload_id} volume node
    ${workload_name} =   generate_name_with_suffix    ${workload_kind}    ${workload_id}
    ${volume_name} =    get_workload_volume_name    ${workload_name}
    ${deleted_node} =    delete_volume_node    ${volume_name}
    Set Test Variable    ${deleted_node}

Delete volume of ${workload_kind} ${workload_id} replica node
    ${workload_name} =   generate_name_with_suffix    ${workload_kind}    ${workload_id}
    ${volume_name} =    get_workload_volume_name    ${workload_name}
    ${deleted_node} =    delete_replica_node    ${volume_name}
    Set Test Variable    ${deleted_node}

Add deleted node back
    reboot_node_by_name    ${deleted_node}

Force drain volume of ${workload_kind} ${workload_id} volume node
    ${workload_name} =   generate_name_with_suffix    ${workload_kind}    ${workload_id}
    ${volume_name} =    get_workload_volume_name    ${workload_name}
    ${drained_node} =    get_volume_node    ${volume_name}
    ${last_volume_node} =    get_volume_node    ${volume_name}
    force_drain_node    ${drained_node}
    wait_for_all_pods_evicted    ${drained_node}
    Set Test Variable    ${drained_node}
    Set Test Variable    ${last_volume_node}

Force drain volume of ${workload_kind} ${workload_id} replica node
    ${workload_name} =   generate_name_with_suffix    ${workload_kind}    ${workload_id}
    ${volume_name} =    get_workload_volume_name    ${workload_name}
    ${drained_node} =    get_replica_node    ${volume_name}
    ${last_volume_node} =    get_volume_node    ${volume_name}
    force_drain_node    ${drained_node}
    wait_for_all_pods_evicted    ${drained_node}
    Set Test Variable    ${drained_node}
    Set Test Variable    ${last_volume_node}

Uncordon the drained node
    uncordon_node    ${drained_node}
