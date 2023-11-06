
#! /bin/bash
 
region='ap-south-1'
 
# Find all gp2 volumes within the given region
volume_ids=$(aws ec2 describe-volumes --region "${region}" --filters Name=volume-type,Values=gp2 | jq -r '.Volumes[].VolumeId')
#volume_ids="vol-0ded7a2c035a0bf65"
# Iterate all gp2 volumes and change its type to gp3
for volume_id in ${volume_ids};do
    result=$(aws ec2 modify-volume --region "${region}" --volume-type=gp3 --volume-id "${volume_id}" | jq '.VolumeModification.ModificationState' | sed 's/"//g')
    echo $result
    if [ $? -eq 0 ] && [ "${result}" == "modifying" ];then
        echo "OK: volume ${volume_id} changed to state 'modifying'"
    else
        echo "ERROR: couldn't change volume ${volume_id} type to gp3!"
    fi
done
