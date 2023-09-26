var DietCode="";
var strmCheck="";
var DietTypeobj="";




function MealLookUpSelect(str) {  


	var lu=str.split("^");
	
	var mobj=document.getElementById("CYCLEMealTypeDR");
	if (mobj) mobj.value=lu[0];

}



function OrderItemLookupSelect(txt) {	
	var adata=txt.split("^");
	
	var dtobj=document.getElementById("DietItem");
	if (dtobj) dtobj.value=adata[0];

	var arcobj=document.getElementById("CYCLEARCIMDR");	
	if (arcobj) arcobj.value=adata[1]; 

	var dtcobj=document.getElementById("ARCIMCode");  //Diet Type Code
	if (dtcobj) dtcobj.value=adata[3]; 
	DietCode=dtcobj.value;

	return DietCode; 	
}

function OrderSetLookupSelect(txt) {	
	var adata=txt.split("^");
	
	var dtobj=document.getElementById("DietSet");
	if (dtobj) dtobj.value=adata[0];

	var arcobj=document.getElementById("CYCLEARCOSDR");	
	if (arcobj) arcobj.value=adata[1];
	
	var dtcobj=document.getElementById("ARCIMCode");  //Diet Type Code
	if (dtcobj) dtcobj.value=adata[3]; 
	DietCode=dtcobj.value;

	return DietCode; 	
}
function BodyLoadHandler() {
}


document.body.onload=BodyLoadHandler;


