# data i/o 

### JIUTIAN simulation 

##### Fortran interface

<details><summary> <b> Library installation </b> </summary>
<p>

```
cd libcsstmock

# if running on Gravity: 
module load anaconda
module load compiler/intel-2018

python build.py # 生成静态链接库 
ifort -fPIC -shared -o libcsstmock.so io_dummy.f io_jiutian.f io_jiutian_lightcone.f libcsstplugin.a # 合并为动态链接库

echo "# <<< env csstmock <<<" >> ~/.bash_profile  
echo "export PYTHONPATH=$PYTHONPATH:$(pwd)" >> ~/.bash_profile  
echo "export LIBRARY_PATH=$LIBRARY_PATH:$(pwd)" >> ~/.bash_profile  
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)" >> ~/.bash_profile  
echo "export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$(pwd)" >> ~/.bash_profile  
echo "# >>> env csstmock >>>" >> ~/.bash_profile  

```

</p>
</details>


<details><summary> <b> subhalo/group of jiutian (to be updated) </b> </summary>
<p> 

```
	call subhalo_filenum_jiutian(snapnum, filenum)
	call subhalo_jiutian(snapnum, ifile) 
	call group_filenum_jiutian(snapnum, filenum)
	call group_jiutian(  snapnum, ifile) 
```

</p>
</details>


<details><summary> <b> isin_survey (to be updated) </b> </summary>
<p> 

* subroutine description

``` Fortran
	subroutine isin_survey(ra, dec, w, survey, Ngalmax, Ngal)
        !> Description 
        !> -----------
        !> isin_survey
        !> 
        !> Syntax
        !> -----------
        !> call fullsky_z2_filenum_jiutian(127, filenum)
        !>  
        !> Argument(s)
        !> -----------
        !> snapnum(in):  integer(4), the given snapshot number [127-65]
        !>   
        !> filenum(out): integer(4), the number of divided files
        !> 
```

</p>
</details>




<details><summary> <b> fullsky_z2 lightcone of jiutian </b> </summary>
<p>

* example 

``` 
	ifort  -o test4 test4.f  -lcsstmock
	./test4
```


``` Fortran 
! ========== test4.f, to read the fullsky_z2 lightcone ================
        PROGRAM test4 
        use, intrinsic :: iso_c_binding ! 和C语言类型互通的模块iso_c_binding
        implicit none
        integer(4)  :: snapnum, ifile, filenum
        integer(8)  :: nmax, nsub
        integer(c_long), allocatable :: larr(:,:)
        real(c_float),   allocatable :: darr(:,:)
        nmax    = 500000000
        allocate( larr( 5, nmax) )
        allocate( darr(20, nmax) )
        do snapnum = 127, 120, -1

!>>>    to know how many files at the given snapshot number. 
            call fullsky_z2_filenum_jiutian(snapnum, filenum)

            do ifile = 1,filenum
               nsub    = nmax
!>>>    to read the brach file one by one. 
               call fullsky_z2_jiutian(snapnum, ifile-1,
     &                                 larr, darr, nsub)

               !>>> operation herein <<<!
               print*, snapnum, ifile, filenum, nsub

            end do
        end do
        END
```

* subroutine description

``` Fortran
c------------------------------------------------------------------------------
        subroutine fullsky_z2_filenum_jiutian(
     &             snapnum, filenum)
c------------------------------------------------------------------------------
        !> Description 
        !> -----------
        !> the file number of fullsky_z2 lightcone at the given snapshot 
        !> 
        !> Syntax
        !> -----------
        !> call fullsky_z2_filenum_jiutian(127, filenum)
        !>  
        !> Argument(s)
        !> -----------
        !> snapnum(in):  integer(4), the given snapshot number [127-65]
        !>   
        !> filenum(out): integer(4), the number of divided files
        !> 

c------------------------------------------------------------------------------
        subroutine fullsky_z2_jiutian(
     &             snapnum, ifile, larr, darr, nmax)
c------------------------------------------------------------------------------
        !> Description 
        !> -----------
        !> read the fullsky_z2 lightcone of jiutian simulation
        !> 
        !> Syntax
        !> -----------
        !> call fullsky_z2_jiutian(127, larr, darr, nsub)
        !> 
        !> Argument(s)
        !> -----------
        !> snapnum(in): integer(4), the given snapshot number [127-65]
        !> 
        !> larr(out): integer(8), long type data
        !>      (1-5) 'trackID', 'hosthaloID', 'rank', 'snapNum','group_nr'
        !>
        !> darr(out): real(4), float type data
        !>      ( 1-7 ) 'posx', 'posy', 'posz', 'velx', 'vely', 'velz', 'v_lfs', 
        !>      ( 8-14) 'shMbound', 'd_comoving', 'ra', 'dec', 'vmax', 'PeakMass', 'PeakVmax',
        !>      (15-18) 'shBoundM200Crit', 'redshift_true', 'redshift_obs', 'shMbound_at_ac',
        !>      (19-20) 'group_mass', 'group_m_mean200'
        !> 
        !> nmax(inout): integer(8), max number of subhalos
        !> 

```

</p>
</details> 

