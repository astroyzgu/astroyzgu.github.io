# desispec 

```
# download the packages from fileServer


# create a new env for desispec 
conda create -n desispec python=3.10

```


# desispec on nersc 

```
    module use /global/common/${NERSC_HOST}/contrib/desi/modulefiles

    module load desispec

    source /global/cfs/cdirs/desi/software/desi_environment.sh 23.1
    ${DESIMODULES}/install_jupyter_kernel.sh 23.1  
```

# howto

https://desi.lbl.gov/trac/wiki/Pipeline/HowTo 