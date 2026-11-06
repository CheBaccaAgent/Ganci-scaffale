// Gancio scaffale V4 - mm. Prototipo con uncino interno.
parte="gancio"; // [gancio,campione]
altezza_profilo=50;
apertura_profilo=44;
profondita_bordo=8;
gioco=0.4;
larghezza=14; // incastro invariato
larghezza_stelo=13.5;
sporgenza=35;
dorso=6;
ponte=5;
ritorno=5;
lunghezza_ritorno=8;
dente=1.2;
quota_sotto_bordo=47; // 50-3: ASSUNZIONE sulla faccia inferiore della piega superiore
luce_dente=0.4;
stelo=6.5;
$fn=48;
a=gioco; b=a+dorso; c=-profondita_bordo-gioco; d=c-ritorno;
h=altezza_profilo+gioco;
function bez(t,p0,p1,p2,p3)=(1-t)*(1-t)*(1-t)*p0+3*(1-t)*(1-t)*t*p1+3*(1-t)*t*t*p2+t*t*t*p3;
function centro(t)=bez(t,[b-1,8],[13,-11],[25,-10],[sporgenza-stelo/2,11]);
module aggancio(){
 offset(r=0.65) offset(delta=-0.65) polygon([[a,0],[a,h],[c,h],[c,h-lunghezza_ritorno],[d,h-lunghezza_ritorno],[d,h+ponte],[b,h+ponte],[b,0]]);
 // Dente rivolto verso la faccia esterna: si porta sotto la piega interna.
 translate([c-0.35,0]) polygon([[0,quota_sotto_bordo-luce_dente-3],[dente+0.35,quota_sotto_bordo-luce_dente-0.8],[dente+0.35,quota_sotto_bordo-luce_dente],[0,quota_sotto_bordo-luce_dente]]);
}
module braccio(){
 for(i=[0:39]) hull(){
 translate(centro(i/40)) circle(r=stelo/2+1.2*pow(1-i/40,3));
 translate(centro((i+1)/40)) circle(r=stelo/2+1.2*pow(1-(i+1)/40,3));
 }
}
module sezione(){union(){aggancio();braccio();}}
assert(profondita_bordo>0 && dente<profondita_bordo);
// Faccia di stampa comune a Z=0; il mezzo millimetro e tolto sul lato superiore.
translate([-d,parte=="campione"?-(h-15):10,0])
if(parte=="campione") linear_extrude(height=8,convexity=10)
 intersection(){aggancio();translate([d-1,h-15]) square([b-d+2,22]);}
else union(){
 linear_extrude(height=larghezza,convexity=10) aggancio();
 linear_extrude(height=larghezza_stelo,convexity=10) braccio();
}
