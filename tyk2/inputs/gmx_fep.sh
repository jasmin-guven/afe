#! /bin/bash
#
export CUDA_VISIBLE_DEVICES=0

echo "Starting the run on GPU $CUDA_VISIBLE_DEVICES"
echo "setting up runs"

# python /home/anna/Documents/1st_yr/amber_bss_sem2/testing/scripts/fepprep.py ejm42 ejm55
# python /home/anna/Documents/1st_yr/amber_bss_sem2/testing/scripts/fepprep.py ejm55 ejm54
# python /home/anna/Documents/1st_yr/amber_bss_sem2/testing/scripts/fepprep.py ejm54 ejm42
# python /home/anna/Documents/1st_yr/amber_bss_sem2/testing/scripts/fepprep.py ejm31 ejm42

lamvals=( 0.0000 0.1000 0.2000 0.3000 0.4000 0.5000 0.6000 0.7000 0.8000 0.9000 1.0000 )
main=$(pwd)

echo "running the runs"

for transformation in ejm50~ejm49 ; do
for input in gmx2022; do

cd $trans'_'$input

current=$(pwd)
echo $current

# for x in bound free; do
for x in free; do
cd $x
for lam in "${lamvals[@]}" ; do

echo "for " $current
echo "minimising for $x $lam..."

gmx grompp -f min/lambda_$lam/gromacs.mdp -c min/lambda_$lam/gromacs.gro -p min/lambda_$lam/gromacs.top -o min/lambda_$lam/gromacs.tpr

gmx mdrun -deffnm min/lambda_$lam/gromacs ;

echo "equilibrating nvt for $x $lam..."

gmx grompp -f heat/lambda_$lam/gromacs.mdp -c min/lambda_$lam/gromacs.gro -p heat/lambda_$lam/gromacs.top -o heat/lambda_$lam/gromacs.tpr
gmx mdrun -deffnm heat/lambda_$lam/gromacs ;

echo "equilibrating npt for $x $lam..."

gmx grompp -f eq/lambda_$lam/gromacs.mdp -c heat/lambda_$lam/gromacs.gro -p eq/lambda_$lam/gromacs.top -t heat/lambda_$lam/gromacs.cpt  -o eq/lambda_$lam/gromacs.tpr
gmx mdrun -deffnm eq/lambda_$lam/gromacs ;

echo "production run for $x $lam..."

gmx grompp -f lambda_$lam/gromacs.mdp -c eq/lambda_$lam/gromacs.gro -p lambda_$lam/gromacs.top -t eq/lambda_$lam/gromacs.cpt -o lambda_$lam/gromacs.tpr
gmx mdrun -deffnm lambda_$lam/gromacs ;

echo "finished for $x, $lam"
done
cd $current
done
cd $main
done
done
