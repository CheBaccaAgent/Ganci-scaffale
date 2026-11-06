// V5: perno pieno diametro 25 mm, asse a +10 gradi verso l'alto.
// Incastro e dente identici alla V4. Unita mm.
altezza_profilo=50;
apertura_profilo=44;
profondita_bordo=8;
gioco=0.4;
larghezza=14;
dorso=6;
ponte=5;
ritorno=5;
lunghezza_ritorno=8;
dente=1.2;
quota_sotto_bordo=47;
luce_dente=0.4;
diametro_perno=25;
inclinazione=10; // positiva verso alto, rispetto all'orizzontale in uso
sporgenza=35; // massimo ingombro, inclusa la sezione inclinata
smusso_punta=0.7;
$fn=96;
a=gioco; b=a+dorso; c=-profondita_bordo-gioco; d=c-ritorno;
h=altezza_profilo+gioco;
r=diametro_perno/2;
radice_x=b-3;
radice_y=r+1;
lunghezza_perno=(sporgenza-radice_x-r*sin(inclinazione))/cos(inclinazione);
assert(inclinazione>0 && inclinazione<45);
assert(lunghezza_perno>smusso_punta);
module aggancio(){
 offset(r=0.65) offset(delta=-0.65) polygon([[a,0],[a,h],[c,h],[c,h-lunghezza_ritorno],[d,h-lunghezza_ritorno],[d,h+ponte],[b,h+ponte],[b,0]]);
 // Dente rivolto verso la faccia esterna: si porta sotto la piega interna.
 translate([c-0.35,0]) polygon([[0,quota_sotto_bordo-luce_dente-3],[dente+0.35,quota_sotto_bordo-luce_dente-0.8],[dente+0.35,quota_sotto_bordo-luce_dente],[0,quota_sotto_bordo-luce_dente]]);
}

module perno(){
 // Asse locale Z trasformato nel vettore [cos(angolo),sin(angolo),0].
 translate([radice_x,radice_y,larghezza/2])
 rotate([0,0,inclinazione]) rotate([0,90,0]) union(){
 cylinder(h=lunghezza_perno-smusso_punta,r=r);
 translate([0,0,lunghezza_perno-smusso_punta]) cylinder(h=smusso_punta,r1=r,r2=r-smusso_punta);
 }
}
// Posizione di stampa sul fianco. Supporti necessari sotto incastro e superfici curve.
translate([-d,0,max(0,r-larghezza/2)]) union(){
 linear_extrude(height=larghezza,convexity=10) aggancio();
 perno();
}
echo(diametro=diametro_perno,angolo=inclinazione,lunghezza_assiale=lunghezza_perno);
