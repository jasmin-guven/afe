#!/bin/bash


# General skeleton for running the FEP

# 1. Set the lambda values
# 2. Loop over transformation folders
# 3. Loop over bound and unbound folders
# 4. Loop over lambda folders
# 5. Do production run in each lambda folder using SOMD


# Select which GPU to run on
export CUDA_VISIBLE_DEVICES=0

# echo prints out the variable
echo "You have selected GPU: $CUDA_VISIBLE_DEVICES"

# Change directory to the Engine folder
cd ../output/somd/

# Save current working directory in a variable called current
current=$(pwd) 

# Create the lambda values
lambda_values=( 0.0000 0.1000 0.2000 0.3000 0.4000 0.5000 0.6000 0.7000 0.8000 0.9000 1.0000 )

# Loop over transformation folders (in this case it's just one folder)
for transformation in 'ejm50~ejm49'; do


# Go into transformation folder
cd $transformation
echo "Transformation: $transformation"
transformation_dir=$(pwd)
	
# Loop over bound and unbound folders
for directory in bound unbound ; do

# Go into bound/unbound directory
cd $directory

# Loop over lambda values
for lambda in "${lambda_values[@]}" ; do 
echo "lambda is: " $lambda "at" $directory " for " $transformation_dir

# Go into lambda directory
cd lambda_$lambda

echo "production run..."
# Do SOMD production run
somd-freenrg -c somd.rst7 -t somd.prm7 -m somd.pert -C somd.cfg -p CUDA

cd ..

done

cd $transformation_directory
done

cd $current
done









