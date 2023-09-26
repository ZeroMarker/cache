var MealCutOffObj=document.getElementById("MealCutoff");
var curDate;

function UpdateClick_Handler() {
	var AllowToUpdate=true;

	AllowToUpdate=ValidateFields();
	if (AllowToUpdate==true) {
		return Update1_click();
	} else {
		return false;
	}
}

function MealLookUpSelect(str) {
	var lu=str.split("^");
	if (MealCutOffObj) {
		MealCutOffObj.value=lu[4];  // MEALT_CutOffBulkTime
		//alert("MealCutOffObj.value 1= "+MealCutOffObj.value);
	}
}

function OrderItemLookupSelect(txt) { //passed in from the component manager.
	//Add an item to lstOrders when an item is selected from
	//the Lookup, then clears the Item text field.

	var adata=txt.split("^");
	var idesc=adata[0];
	var icode=adata[1];
	var ifreq=adata[2];
	var iordertype=adata[3];
	var ialias=adata[4];
	var isubcatcode=adata[5];
	var iorderCatID=adata[6];
	var iSetID=adata[7];
	var mes=adata[8];
	var irangefrom=adata[9];
	var irangeto=adata[10]
	var iuom=adata[11];
	var idur=adata[12];
	var igeneric=adata[13];
	var match="notfound";
	var SetRef=1;
	window.focus();

}

function DietTypeLookupSelect(txt) {
	var adata=txt.split("^");

	var dtobj=document.getElementById("ORDARCIMDR");
	if (dtobj) dtobj.value=adata[0];

	var atobj=document.getElementById("arcim");
	if (atobj) atobj.value=adata[1];

	var lobj=document.getElementById("ORDCTLOCDR");
	if (lobj) lobj.value="";
	
}

function LocationLookUpSelect(str) {
	var lu=str.split("^");

	var obj=document.getElementById("ORDCTLOCDR");
	if (obj) obj.value=lu[0];
}

function ValidateFields() {
	//alert("validate fields");
	var found=true;
	var mealobj=document.getElementById("ORDMealTypeDR"); //Meal
	var currTobj=document.getElementById("currTime");
	var currDobj=document.getElementById("currDate");
	var dateobj=document.getElementById("ORDDate");
	var IDobj=document.getElementById("ID");
	if(currDobj && dateobj){
		//var dateArr = dateobj.value.split("/");
		//var enteredDate = new Date(dateArr[2],dateArr[1],dateArr[0]);
		//var enteredDateSTR = ""+enteredDate.getYear()+enteredDate.getMonth()+enteredDate.getDate();
		//var currentDateSTR = ""+curDate.getYear()+curDate.getMonth()+curDate.getDate();
		var dateInPast = false;
		var dateToday = false;
		if(DateStringCompare(currDobj.value,dateobj.value)=="1") {
			dateInPast = true;
		}
		else if(DateStringCompare(currDobj.value,dateobj.value)=="0") { 
				dateToday = true;
		}
		if(dateInPast && IDobj.value == "")
		{
				  msg=t['InPast'];
				  alert(msg);
				  var found=false;
		}
		if(dateToday){
			if (mealobj.value!="") {  //Meal
				var index=1;
				var ctarr;    // MEALT_CutOffBulkTime
				var amarr;    // MEALT_Desc
				var tharr;
				var msg=""
				var amobj=document.getElementById("allmeals");
				if (amobj) {
					var x=amobj.value;
					amarr=x.split("|");     //MEALT_Desc  |Breakfast|Morning Tea ...
				}

				var ctobj=document.getElementById("allmealTimes");
				if (ctobj) {
					var x=ctobj.value;
					ctarr=x.split("|");   		 // MEALT_CutOffTime	|21600|28800 ...
				}

				var thobj=document.getElementById("timesHTML");  	//Bulk cut off time. |06:00|08:00 ...
				if (thobj) tharr=thobj.value.split("|");
					if ((MealCutOffObj.value!="")&&(MealCutOffObj.value<currTobj.value)) {    // MEALT_CutOffBulkTime < currTobj = currTime
						while (ctarr[index]<MealCutOffObj.value){
							index=index+1;
						}
					msg=msg+" "+amarr[index]+" (Cut Off: "+tharr[index]+") "+t['CutOff'] ;  //example  Breakfast(Cut Off: 07:00) will not be effective today. xxx
					alert(msg);
					var found=false;
				}
			}
		}
	}
	return found;
}

function BodyLoadHandler() {
	var currDobj=document.getElementById("currDate");
	var dateobj=document.getElementById("ORDDate");
	var IDobj=document.getElementById("ID");
	if(dateobj && currDobj){
		//process date strings into javascript date objects
		var date1Arr = currDobj.value.split("/");
		var date2Arr = dateobj.value.split("/");
		curDate = new Date(date1Arr[2],date1Arr[1],date1Arr[0]);
		var enteredDate = new Date(date2Arr[2],date2Arr[1],date2Arr[0]);
		if(enteredDate.getYear()+enteredDate.getMonth()+enteredDate.getDate() < curDate.getYear()+curDate.getMonth()+curDate.getDate())
		{
			dateobj.disabled=true;
		}
	}
//if is !="" then if date is in past disable that field
}

var uobj=document.getElementById("Update1");
if (uobj) uobj.onclick=UpdateClick_Handler;
document.body.onload=BodyLoadHandler;


