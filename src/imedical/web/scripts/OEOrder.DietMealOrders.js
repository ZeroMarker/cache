function LookUpDietTypeSelect(str) {
	//alert("str: "+str);
 	var lu = str.split("^");
	var obj=document.getElementById("DietID");
	if (obj) obj.value = lu[2];
	//var obj=document.getElementById("DietType");
	//if (obj) obj.value = lu[1];

}

function TestDateRange() {
	var STDate="";
	var EDate="";
	var AltMsg="";
	var CurTime="";

	var STObj=document.getElementById("StartDate");
	if (STObj) STDate=STObj.value;

	var EDObj=document.getElementById("EndDate");
	if (EDObj) EDate=EDObj.value;

	if((DateStringCompareToday(STDate)<0)||(DateStringCompareToday(EDate)<0)) {
		AltMsg=t['MEAL_PAST'];
		return AltMsg;
	}

	return AltMsg;
}

function TestCutOff() {
	var STDate="";
	var EDate="";
	var AltMsg="";
	var CurTime="";

	var CTObj=document.getElementById("CurrTime");
	if((CTObj)&&(CTObj.value!="")) CurTime=CTObj.value;

	var STObj=document.getElementById("StartDate");
	if (STObj) STDate=STObj.value;

	var EDObj=document.getElementById("EndDate");
	if (EDObj) EDate=EDObj.value;

	if((DateStringCompareToday(STDate)==0)||(DateStringCompareToday(EDate)==0)) {		
		var ListObj=document.getElementById("MealType");
		if(ListObj) {
			for (var i = 0; i < ListObj.length; i++) {
				if(ListObj.options[i].selected) {
					var Meal=ListObj.options[i].text;
					var MealTime=ListObj.options[i].value;

					if((MealTime!="")&&(CurTime!="")&&(TimeStringCompare(MealTime,CurTime)==-1)) {
						AltMsg=AltMsg+Meal+" ("+t['CUT_OFF']+MealTime+")";
					}
				}
			}
			if(AltMsg!="") AltMsg=AltMsg+t['NOT_EFFECTIVE'];
		}		
	}
	return AltMsg;

}

function UpdateClickHandler() {

	var DCid="";
	var DietType="";
 	var StartDate="";
 	var EndDate="";
	var MealTypeStr="";
	var PatientID="";
	var EpisodeID="";
	var ALGRequireAssistanceMenu="";
	var ALGRequireAssistanceMeal="";
	var Boarder="";
	var Message="";
	var MultiEpisodeID="";
	var AltMsg="";
	var CutOffMsg="";

	var ListObj=document.getElementById("MealType");
	var RtnArr= new Array();
	var InsertStr="";
	if(ListObj) RtnArr=getSelectedListItems(ListObj);
	InsertStr=RtnArr.join("^");

	var ISObj=document.getElementById("InsertStr");
	if((ISObj)&&(InsertStr!="")) ISObj.value=InsertStr;

	var DTObj=document.getElementById("DietType");
	if (DTObj) DietType=DTObj.value;

	var STObj=document.getElementById("StartDate");
	if (STObj) StartDate=STObj.value;

	var EDObj=document.getElementById("EndDate");
	if (EDObj) EndDate=EDObj.value;

	var GObj=document.getElementById("Generate");
	if (GObj) GObj.value="Y";

	if(StartDate=="") Message=Message+t['StartDate']+" "+t['XMISSING']+"\n";
	if(EndDate=="") Message=Message+t['EndDate']+" "+t['XMISSING']+"\n";
	if (DietType=="") Message=Message+t['DietType']+" "+t['XMISSING']+"\n";

	if(Message!="") {
		alert(Message);
		return false;
	}

	AltMsg=TestDateRange();
	if(AltMsg!="") {
 		alert(AltMsg);
		return false;
	}

	CutOffMsg=TestCutOff();
	if(CutOffMsg!="") alert(CutOffMsg);

	return Update_click();
}

function getSelectedListItems(listBox)
{
	var selArr = new Array();
	var count = 0;
	for (var i = 0; i < listBox.length; i++) {
		if(listBox.options[i].selected) {
			selArr[count] = listBox.options[i].text;
			count++;
		}
	}
	return selArr;
}


function UpdateMonthlyMenu_ClickHandler() {
	var DCid="";
	var DietType="";
 	var StartDate="";
 	var EndDate="";
	var MealTypeStr="";
	var PatientID="";
	var EpisodeID="";
	var ALGRequireAssistanceMenu="";
	var ALGRequireAssistanceMeal="";
	var Boarder="";
	var Message="";
	var AltMsg="";
	var CutOffMsg="";

	var ListObj=document.getElementById("MealType");
	var RtnArr= new Array();
	var InsertStr="";
	if(ListObj) RtnArr=getSelectedListItems(ListObj);
	InsertStr=RtnArr.join("^");
	var ISObj=document.getElementById("InsertStr");
	if((ISObj)&&(InsertStr!="")) ISObj.value=InsertStr;

	var DCidObj=document.getElementById("DietID");
	if (DCidObj) DCid=DCidObj.value;

	var DTObj=document.getElementById("DietType");
	if (DTObj) DietType=DTObj.value;

	var STObj=document.getElementById("StartDate");
	if (STObj) StartDate=STObj.value;

	var EDObj=document.getElementById("EndDate");
	if (EDObj) EndDate=EDObj.value;

	var PObj=document.getElementById("PatientID");
	if (PObj) PatientID=PObj.value;

	var EPObj=document.getElementById("EpisodeID");
	if (EPObj) EpisodeID=EPObj.value;

	var AMenuObj=document.getElementById("ALGRequireAssistanceMenu");
	if ((AMenuObj)&&(AMenuObj.checked)) ALGRequireAssistanceMenu="Y";

	var AMealObj=document.getElementById("ALGRequireAssistanceMeal");
	if ((AMealObj)&&(AMealObj.checked)) ALGRequireAssistanceMeal="Y";

	var BObj=document.getElementById("Boarder");
	if ((BObj)&&(BObj.checked)) Boarder="Y";

	if(StartDate=="") Message=Message+t['StartDate']+" "+t['XMISSING']+"\n";
	if(EndDate=="") Message=Message+t['EndDate']+" "+t['XMISSING']+"\n";
	if (DietType=="") Message=Message+t['DietType']+" "+t['XMISSING']+"\n";

	if(Message!="") {
		alert(Message);
		return false;
	}

	AltMsg=TestDateRange();
	if(AltMsg!="") {
 		alert(AltMsg);
		return false;
	}

	CutOffMsg=TestCutOff();
	if(CutOffMsg!="") alert(CutOffMsg);

	//var url = "oeorder.dietmealcalendar.csp?DietID="+DCid+"&DietType="+DietType+"&StartDate="+StartDate+"&EndDate="+EndDate+"&MealType="+InsertStr+"&PatientBanner=1"+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&ALGRequireAssistanceMenu="+ALGRequireAssistanceMenu+"&ALGRequireAssistanceMeal="+ALGRequireAssistanceMeal+"&Boarder="+Boarder+"&Reset=Y";
	//alert("url="+url);
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	//websys_createWindow(url, "frmDietMealOrders","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")

	return UpdateMonthlyMenu_click();
}

function BodyLoadHandler() {
	var IsBulk="";
	var IsMulti="";
	var IBObj=document.getElementById("IsBulkEdit");
	if ((IBObj)&&(IBObj.value!="")) IsBulk="Y";

	if (IsBulk=="Y") {
		var UpdateMMObj=document.getElementById("UpdateMonthlyMenu");
		if (UpdateMMObj) {
			UpdateMMObj.onclick = BlankClickHandler;
			UpdateMMObj.disabled=true;
		}
		var MEObj=document.getElementById("MultiEpisodeID");
		if ((MEObj)&&(MEObj.value!="")) {
			if(MEObj.value.indexOf("^")!=-1) IsMulti="Y";
		}
		if(IsMulti=="Y") {
			var AMenuObj=document.getElementById("ALGRequireAssistanceMenu");
			if (AMenuObj) {
					AMenuObj.disabled=true;
					AMenuObj.checked=false;
			}
			var AMealObj=document.getElementById("ALGRequireAssistanceMeal");
			if (AMealObj) {
				AMealObj.disabled=true;
				AMealObj.checked=false;
			}
		}
		if (tsc['Update']) {
			websys_sckeys[tsc['UpdateMonthlyMenu']]=BlankClickHandler;
		}
	}
	else {
		var UpdateMMObj=document.getElementById("UpdateMonthlyMenu");
		if (UpdateMMObj) UpdateMMObj.onclick = UpdateMonthlyMenu_ClickHandler;
		if (tsc['Update']) {
			websys_sckeys[tsc['UpdateMonthlyMenu']]=UpdateMonthlyMenu_ClickHandler;
		}
		var MEObj=document.getElementById("MultiEpisodeID");
		if ((MEObj)&&(MEObj.value!="")) MEObj.value="";

	}
	var UpdateObj=document.getElementById("Update");
	if (UpdateObj) UpdateObj.onclick = UpdateClickHandler;
	if (tsc['Update']) {
		websys_sckeys[tsc['Update']]=UpdateClickHandler;
	}
}

function BlankClickHandler() {
	return false;
}

document.body.onload = BodyLoadHandler;

