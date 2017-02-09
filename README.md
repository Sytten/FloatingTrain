# FloatingTrain

## Voici la nomenclature à utiliser dans le code MATLAB/Simulink:
1. masseS : masse de la sphère
2. masseP : masse de la plaque
3. inertiePx : inertie de la plaque autour de l’axe x
4. inertiePy : inertie de la plaque autour de l’axe y
5. XK, YK, ZK : position inertielle des éléments fixes K (K = A, B, C, D, E, F)
6. Px, Py, Pz : position de la sphère dans le repère inertiel
7. Vx, Vy, Vz : vitesse de la sphère dans le repère inertiel
8. Ax, Ay : angle de rotation de la plaque ϕ autour de l’axe Ix et θ autour de l’axe Iy
9. Wx, Wy : vitesse angulaire de la plaque Wx autour de l’axe Ix et Wy autour de l’axe Iy
10. FA, FB, FC : forces appliquée par les actionneurs sur la plaque (positif vers le bas)
11. MA, MB, MC : couple appliquée par les actionneurs sur la plaque
12. VA, VB, VC : tension électrique appliquée aux actionneurs
13. IA, IB, IC : courant électrique dans les actionneurs
14. ∗_mes: réfère à des variables mesurées
15. ∗_des: réfère aux variables désirées ou commandées
16. ∗_ini : réfère aux variables initiales
17. ∗_fin : réfère aux variables finales
18. ∗_eq: réfère aux variables à l’équilibre