#!/bin/sh
#
#$ -cwd
#$ -o /lbc/lbc1/derivatives/GB/Finalsample_youngCornell_FC-MSSD_Groupatlas/morphometric_similarity_groupatlas/output/out.txt
#$ -e /lbc/lbc1/derivatives/GB/Finalsample_youngCornell_FC-MSSD_Groupatlas/morphometric_similarity_groupatlas/output/err.txt
#$ -m e
export FSLDIR=/export01/local/fsl
export FREESURFER_HOME=/export01/local/freesurfer
source $FREESURFER_HOME/FreeSurferEnv.sh
export SUBJECTS_DIR=/lbc/lbc1/derivatives/freesurfer

for dir in sub*; do

    mris_anatomical_stats -a /lbc/lbc1/derivatives/freesurfer/$dir/label/rh.${dir}.Schaefer2018_200Parcels_7Networks_order.annot -f /lbc/lbc1/derivatives/GB/Finalsample_youngCornell_FC-MSSD_Groupatlas/morphometric_similarity_groupatlas/$dir/rh_${dir}_thickness_perparcel_Schaefer200_7.csv -b ${dir} rh
    
done
