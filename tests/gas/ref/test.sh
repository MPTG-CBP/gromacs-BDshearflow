GMXDIR=$( echo /home/camilo/workspace/gromacs/gromacs-BDshearflow/gromacs-2020.1/build/bin )

$GMXDIR/gmx grompp -f BD.mdp -c conf.gro -p topol.top -o BD.tpr
$GMXDIR/gmx mdrun  -deffnm BD -v 
