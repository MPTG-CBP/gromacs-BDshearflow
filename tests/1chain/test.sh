GMXDIR=$( echo /home/camilo/workspace/gromacs/gromacs-BDshearflow/gromacs-2020.1/build/bin )

$GMXDIR/gmx grompp -f BD.mdp -c conf.gro -p topol.top -o BD.tpr
#$GMXDIR/gmx mdrun  -deffnm BD -v 

echo 0 | gmx trjconv -f BD.xtc -s BD.tpr -pbc nojump -o tmp.xtc
echo 0 0 | gmx trjconv -f tmp.xtc -s BD.tpr -fit translation -o BD_fit.xtc
rm -f tmp.xtc
