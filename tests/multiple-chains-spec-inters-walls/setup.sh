#script to setup a BD simulation of a system of polymers in a flow and walls
GMXDIR=$( echo /home/camilo/workspace/gromacs/gromacs-BDshearflow/gromacs-2020.1/build/bin )

# generate initial conformation
N1=200
N2=0
n1=120
n2=200 # >0 but it does not matter as there will be N2=0 polymers of type 2
d0=3.2
radius=3.2
Pspec=0.0 
out=conf0.gro
~/cross-linked-polymers/get_conf0.sh $N1 $N2 $n1 $n2 '800 800 800' $d0 $radius $Pspec $out




# generate topology
np1=1 # number of beads persistence length polymer type 1 
np2=1 # number of beads persistence length polymer type 2 (it does not matter)
kBT=2.5
bond=7
~/cross-linked-polymers/get_topol.sh $out ./toppar/polymer.itp $d0  $np1 $np2 $kBT $bond topol.top



# equilibrium deformation simulation to accommodate the polymers in the box 


# set the box to the maximum value polymers occupy plus a bit of buffer distance
gmx editconf -f conf0.gro -d 10 -o conf0_expanded.gro 

# deformation velocity (nm/ps in the deform in mdp) is chosen such that the final box size is the desired one (300 x 300 x 300) given the box size of conf0_expanded.gro


# deform to attain a 1.2 Volume of the total beads micrometer box (LF)
ndeform_steps=10000
nstxout=100
box=$( tail -n 1 conf0_expanded.gro )
dt_deform=0.1
LF=300 # final box size 

vdeform=($( echo ${box[*]}  | awk  ' { 
x0[0]=$1 ; x0[1]=$2 ; x0[2]=$3 ; 
lf='$LF' 
for(i=0;i<3;i++) {
v[i]=(lf-x0[i])/('$dt_deform'*'$ndeform_steps') ; 
print v[i] 
}
  } ' ))


echo initial box dimensions: ${box[*]}
echo final box dimensions: $LF "^3"
echo vdeform: ${vdeform[*]}


# mdp parameter file
awk ' 
{
if($1=="nsteps") { print $1,$2,'$ndeform_steps'}
else{
if($1=="dt") { print $1,$2,'$dt_deform'}
else{
if($1=="nstxout-compressed") { print $1,$2, '$nstxout' }
else{
if($1=="deform") { print $1,$2, '${vdeform[0]}', '${vdeform[1]}', '${vdeform[2]}', 0 , 0 ,0 
   }
else{
print $0
}
}
}
}
}
' BD_equil.mdp > deform.mdp


#$GMXDIR/gmx grompp -f deform.mdp -c conf0_expanded.gro -p topol.top -o deform.tpr
#$GMXDIR/gmx mdrun  -deffnm deform -v 


# flow
$GMXDIR/gmx grompp -f BD_flow.mdp -c deform.gro -p topol.top -o BD_flow.tpr
$GMXDIR/gmx mdrun  -deffnm BD_flow -v 

rm -f \#*\#