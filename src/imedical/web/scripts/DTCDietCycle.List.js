

function UpdateClick_Handler() {
	//return Update_click();

}



function MealLookUpSelect(str) {  


	var lu=str.split("^");
	
	var mobj=document.getElementById("SearchMeal");
	if (mobj) mobj.value=lu[0];

}

function OrderItemLookupSelect(txt) {	
	var adata=txt.split("^");
	var DietCode;
	
	var dtobj=document.getElementById("DietType");
	if (dtobj) dtobj.value=adata[0];
	
	var arcobj=document.getElementById("ARCIMRowId");	
	if (arcobj) arcobj.value=adata[1];
	
	var modObj=document.getElementById("Modifiers");	
	var s=adata[2].split(",");
	if (modObj) AddItemToList(modObj,s,"");
	
	var dtcobj=document.getElementById("ARCIMCode");  //Diet Type Code
	if (dtcobj) dtcobj.value=adata[3]; 
	DietCode=dtcobj.value;

	return DietCode; 	
}

function BodyLoadHandler() {
}


document.body.onload=BodyLoadHandler;


