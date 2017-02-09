# FloatingTrain

Voici la nomenclature à utiliser dans le code MATLAB/Simulink:

masseS : masse de la sphère
masseP : masse de la plaque
inertiePx : inertie de la plaque autour de l’axe x
inertiePy : inertie de la plaque autour de l’axe y
XK, YK, ZK : position inertielle des éléments fixes K (K = A, B, C, D, E, F)
Px, Py, Pz : position de la sphère dans le repère inertiel
Vx, Vy, Vz : vitesse de la sphère dans le repère inertiel
Ax, Ay : angle de rotation de la plaque ϕ autour de l’axe ܫԦ
௫ et θ autour de l’axe ܫԦ
௬
Wx, Wy : vitesse angulaire de la plaque Wx autour de l’axe ܫԦ
௫ et Wy autour de l’axe ܫԦ
௬
FA, FB, FC : forces appliquée par les actionneurs sur la plaque (positif vers le bas)
MA, MB, MC : couple appliquée par les actionneurs sur la plaque
VA, VB, VC : tension électrique appliquée aux actionneurs
IA, IB, IC : courant électrique dans les actionneurs
∗ _݉݁ݏ : réfère à des variables mesurées
∗ _݀݁ݏ : réfère aux variables désirées ou commandées
∗ _݅݊݅ : réfère aux variables initiales
∗ _݂݅݊ : réfère aux variables finales
∗ _݁ݍ : réfère aux variables à l’équilibre