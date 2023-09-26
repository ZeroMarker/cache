var smobj=document.getElementById("StartMeal");
var emobj=document.getElementById("EndMeal");
var smcobj=document.getElementById("startMealCutoff");
var emcobj=document.getElementById("endMealCutoff");
var DietCode="";
var strmCheck="";
var DietTypeobj="";
var lstOrders;
var hidItemCnt=0;
var assistance;
var PatientDetailsChanged=false;

var strDefaultData="";

var itmidsForQuest="";


//var EpisObj=document.getElementById("EpisodeID");
//if (EpisObj) EpisID=EpisObj.value;
//alert("PeterC:" + EpisID);

function xUpdateClick_Handler() {

	if (InvalidFields()==true) {
		return false;
	}
	
	var WarnMsg="";
	WarnMsg=CheckForAllMendatoryFields();
	if (WarnMsg!="") {
		alert(WarnMsg); 
		return false;
	}

	var Qobj=document.getElementById("OEORIQty");
	if((Qobj)&&(Qobj.value!="")) {
		var DQobj=document.getElementById("defQtyRange");
		if (!CheckQtyRange(Qobj)) {
			return false;
		}
	}

	
	if(!UpdateStatusCheck()) return false;
	var par_win = window.opener;
	if (OrderWindow!="") {
		par_win=window.open('',OrderWindow); 
		if ((OrderWindow=="order_entry")&&(par_win)) par_win.DisableUpdateButton(0);	// LOG 38509 RC 3/12/03 Disable Update Button on Order Entry Screen
	}	
	var MTobj=document.getElementById("MealType");
	var Linkobj=document.getElementById("Link");
	var MealNotAllowed=false;
	var IDobj=document.getElementById("ID")
	var selectedCount=0;
	for(var i=0;i<MTobj.length;i++)
		if(MTobj.options[i].selected==true)
			selectedCount++;
	if ((MTobj) && (MTobj.selectedIndex==-1) && (Linkobj) && (Linkobj.value!="YES")) {
		alert("A meal type MUST be selected.");		
	} 
	else if(IDobj.value!="" && selectedCount>1)
	{
		alert("Only ONE meal type may be selected for an ordered item.");	
	}
	else {				
		var obj=document.getElementById("ID")
		if (obj) {
			MealNotAllowed=CheckMealType(MTobj);
			if (obj.value=="") {				
				if (MealNotAllowed==false){
					var sobj=document.getElementById("OEORISttDat");
					if (sobj && (sobj.value!="")) {
						var dobj=document.getElementById("DischDate");
						var aobj=document.getElementById("AdmDate");
						if (dobj && (dobj.value!="") && aobj && (aobj.value!="")){
                        			var enteredDate = new Date();
						var enteredDate1 = new Date();
						var enteredDate2 = new Date();
						var enteredDate = VerifyDateformat(dobj);
						var enteredDate1 = VerifyDateformat(sobj);
						var enteredDate2 = VerifyDateformat(aobj);

						if (enteredDate1>enteredDate){
						alert(t['STARTDATE_OUT']+" "+aobj.value+" to " + dobj.value);
						sobj.value=""
						return false;				
						}
					
						else if(enteredDate1<enteredDate2) {
							alert(t['STARTDATE_OUT']+" "+aobj.value+" to " + dobj.value);
							sobj.value=""
							return false;
						}
						Updated=1;
						if (OrderWindow!="ORDERFAVPANEL") UpdateFromEPR(); //UpdateFromOrderEntry();
					}
					else{
						var enteredDate1 = new Date();
						var enteredDate2 = new Date();
						var enteredDate1 = VerifyDateformat(sobj);
						var enteredDate2 = VerifyDateformat(aobj);
						if(enteredDate1<enteredDate2) {
						alert(t['STARTDATE_EXCEED']+" "+aobj.value);
						sobj.value=""
						return false;
					}
					Updated=1;
					if (OrderWindow!="ORDERFAVPANEL") UpdateFromEPR(); //UpdateFromOrderEntry();
				}
						
					}
					else {
						var dobj=document.getElementById("DischDate");
						if (dobj && (dobj.value!="")) alert(t['STARTDATE_MAN']);
						else{ 
							Updated=1;
							if (OrderWindow!="ORDERFAVPANEL") UpdateFromEPR(); //UpdateFromOrderEntry();
						}
					}
				}
			//UpdateFromOrderEntry();	
			}else {
				var updatedM=1;
				if (MealNotAllowed==false){
					Updated=1;
				 	//UpdateFromEPR();
					checkDateForEPR();
					//window.opener.treload('websys.csp')
				}
			}
		}			
	}

	var par_win=window.opener;
	var f = document.forms['fOEOrder_Diet'];
	var strData1 = TransferDataMain(f);
	var strData2 = TransferDataSub(f);
	strData2="%01"+strData2;
	var strData=strData1 + strData2;
	par_win.CollectedFields(strData);
	window.close();	
}
function UpdateClick_Handler() {
	var AllowToUpdate=true;
	var StrMods="";
	var StrMods=SelectedModifiers();

	var mobj=document.getElementById("StrModifiers");

	if ((StrMods!="") && (mobj)) mobj.value=StrMods

	GetAllEndMeals();


	AllowToUpdate=ValidateFields();
	if (AllowToUpdate) {
		//cycle through hardware items and enteral items list boxes and call Should Add Item to add each item
		var Obj=document.getElementById("Orders");
		GetOrderData(Obj);
		
		var DTobj=document.getElementById("DietType");
		if((DTobj)&&(DTobj.value!="")) DietType=DTobj.value;
		var Obj=document.getElementById("Standing");
		var SDobj=document.getElementById("StartDate");
		var EDobj=document.getElementById("EndDate");
		
				
		if ((SDobj)&&(SDobj.value!="")&&(EDobj)&&(EDobj.value!="")) {
			var objDate1 = DateStringToDateObj(SDobj.value);
			var objDate2 = DateStringToDateObj(EDobj.value);
			if ((objDate2.getTime() - objDate1.getTime())>(10*24*60*60*1000)) {
				alert(t['EndDateExcess10Days']);
				EDobj.select();
				return false;
			}
			
		}
		
		if ((Obj)&&(Obj.value=="1")&&(DietType!="")&&(EDobj)&&(EDobj.value=="")) {
			alert(t['OPEN_STANDING1']);
			return false;
		}
		var oobj=document.getElementById("OEOrdItemIDs");
		if (oobj) oobj.value="";
		//alert(oobj.value);

		//alert("here");

		
		return Update_click();
	/*	var dobj=document.getElementById("DietType");  //Modifiers  Listbox
		if(dobj)dobj.value="";
		dobj=document.getElementById("StartMeal");  //Modifiers  Listbox
		if(dobj)dobj.value="";
		dobj=document.getElementById("EndMeal");  //Modifiers  Listbox
		if(dobj)dobj.value="";		*/

	}
}

function OrderDeleteClick_Handler() {
	RemoveFromList(document.fOEOrder_DietOrders,lstOrders)

}


function GetAllEndMeals() {
	var EndMeal="";
	var allmeals="";
	var EndMeals="";

	if (emobj) EndMeal=emobj.value;
	var aemobj=document.getElementById("EndMeals");
	var amobj=document.getElementById("allmeals");

	if (amobj) allmeals=amobj.value;
	if ((EndMeal!="") && (allmeals!="")) {
		EndMeals=allmeals.substring(0,allmeals.lastIndexOf(EndMeal))+EndMeal+"|";
		if (aemobj) aemobj.value=EndMeals;
	}

}

function RemoveFromList(f,obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}
//Log 66227 PeterC 31/01/08
function MRADMDietComments_keydownhandler(encmeth) {
	var obj=document.getElementById("MRADMDietComments");
	//LocateCode(obj,encmeth);
	LocateCode(obj,encmeth,false,"Kweb.MRCWordResultCode:LookUpByCode","MRCWordResultCode_lookupSelect");
	PatientDetailsChanged=true;
}
function ValidateFields() {
	var NewStartMeal=9999;
	var found=true;
	var dtobj=document.getElementById("DietType");
	var currTobj=document.getElementById("currTime");
	var currobj=document.getElementById("currDate");
	var sddobj=document.getElementById("StartDate");
	var edobj=document.getElementById("EndDate");
	var copyobj=document.getElementById("CopyOrder");
	var assistFlag=false;
	var mealFlag=false;

	//check that is there is a enteral order there is also a hardware order
	var enteral=false,hardware=false;
	if (lstOrders) {
		for (var i=0; i<lstOrders.length; i++) {
			var code = lstOrders.options[i].subcatcode;
			if(code=="E")
				enteral=true;
			if(code=="H")
			{
				hardware=true
				break;
			}
		}
	}

	//Log 32984 PeterC 19/02/2003 The below lines have been uncommented
	//Log 29590 PeterC 05/11/2002 Diet Enteral Feed no longer requires to be ordered with hardware.
	if(enteral && !hardware){
		found=false;
		alert(t['EnteralHardware']);
	}

	if ((copyobj) && (copyobj.checked)) return true;

	//Log 29590 PeterC 05/11/2002 Diet Type is no longer a mandatory field since we no longer link
	//an item order to a meal order.
	//if ((dtobj) && (dtobj.value=="") && (PatientDetailsChanged==false)) {
	//	alert(t['Select_DietType']);
	//	return false;
	//}else if((dtobj) && (dtobj.value!=""))
	mealFlag=true;

	if (sddobj) { //StartDate
		if (sddobj.value=="" && mealFlag) {
			alert(t['Select_StartDate']);
			return false;
		}  else {
			if(validateDate(sddobj,currobj)=="2"){
				alert(t['Invalid_Date']);
				return false;
			}
		}
	}
	if (edobj) {  //EndDate
		if (edobj.value=="" & mealFlag) {
			//alert(t['Select_EndDate']);
			//return false;
		} else {
			if(validateDate(edobj,currobj)=="2"){
				alert(t['Invalid_Date']);
			return false;
			}
		}
	}

	if ((sddobj)&&(edobj)&&(sddobj.value!="")&&(edobj.value!="")&&mealFlag) {
		if(validateDate(edobj,sddobj)=="2") {
			alert(t['Invalid_Range']);
			return false;
		}
	}

	if ((sddobj)&&(edobj)&&(smcobj)&&(currobj)&&mealFlag) {  //sddobj=StartDate  smobj=StartMeal
		if (((validateDate(edobj,sddobj)=="1")||(validateDate(edobj,sddobj)=="0"))&&(smcobj.value<currTobj.value)&&(validateDate(sddobj,currobj)=="0")){
			var index=1;
			var ctarr;
			var amarr;
			var tharr;
			var msg="";
			var CutOffMeals="";
			var amobj=document.getElementById("allmeals");
			if (amobj) {
				var x=amobj.value;
				amarr=x.split("|");   //MEALT_Desc  Breakfast ...
			}
			var ctobj=document.getElementById("allmealTimes");
			if (ctobj) {
				var x=ctobj.value;
				ctarr=x.split("|");    // MEALT_CutOffTime	32400 ....
			}
			var thobj=document.getElementById("timesHTML");  	//09:00 ....
			if (thobj) tharr=thobj.value.split("|");

			while(ctarr[index]<currTobj.value) {    //MEALT_CutOffTime < currTobj = currTime

				if (ctarr[index]>=smcobj.value) {   //smcobj   = startMealCutoff
					msg=msg+" "+amarr[index]+"(Cut Off: "+tharr[index]+")";
					CutOffMeals=CutOffMeals+amarr[index]+"|";
					//example  Breakfast(Cut Off: 07:00) will not be effective today. xxx
				}
				index=index+1;
			}
			var NewStartMeal=index;	//used for custom script  STRM restriction
			//Log 29590 PeterC 05/11/2002 Do not alert if the order is an order item and not a meal order
			var DTObj=document.getElementById("DietType");
			if (DTObj && DTObj.value!="") {
				alert(msg+" will not be effective today.");
			}
		}
	}

	var comObj=document.getElementById("CutOffMeals");
	//alert(comObj);
	//alert("enddate: "+edobj.value);
	if (comObj) {
		if ((edobj)&&(edobj.value=="")) {
			//alert("cut");
		 	comObj.value=CutOffMeals;
			//alert(comObj.value);
		}
	}

	var ModRequireObj=document.getElementById("ARCIMModifiersRequired");   //; *****  Log# 29922; AmiN ; 06/Nov/2002   Some Diet Codes have required Modifiers.*****
	var modifyobj=document.getElementById("Modifiers");
	//alert("ARCIMModifiersRequired = "+ModRequireObj.value);
	//alert("Modifiers = "+modifyobj.value);

	if ( (ModRequireObj) &&  (ModRequireObj.value=="Y" ) ){
		if ( (modifyobj)  && (modifyobj.value=="") ) {
				alert(t['Modifier_Required']);
				return false;
		}
	}
	return found;  //to check the true occurrence.
}

function splitMeal(str){
	var arr;
	arr=str.split("|")
	return arr;
}
function getDateStr(obj) {
	// ANA 03-FEB-03 dtseparator & dtformat are set in the Generated Scripts.
	//alert("hello ")
	var date="";
	date=obj.value;

	var dateArr = date.split(dtseparator);

	if(dtformat=="YMD")	date = new Date(dateArr[0],dateArr[1],dateArr[2]);
	else if(dtformat=="MDY") date = new Date(dateArr[2],dateArr[0],dateArr[1]);
	else date = new Date(dateArr[2],dateArr[1],dateArr[0]);
	//alert("date "+date);
	return date;
}
/*function getDateStr(dateStr){
	// ANA 30-04-02 This assumes the date format to be in dd/mm/yyyy format.
	alert("dateStr"+dateStr)
	var str=dateStr.split("/");
	var dd=str[0];
	var mm=str[1];
	var yyyy=str[2];
	var dt=new Date(yyyy,mm,dd);
	alert("date "+dt)
	return dt;
}*/

//Log 66260 PeterC 01/02/08: Commented out and replaced with below.
/*
function validateDate(stDate,endDate) {

	var date1=getDateStr(stDate);
	var date2=getDateStr(endDate);
	var flag=date1-date2;
	//if (flag==0) return ("0");
	///else if (flag>0) return ("1");
	//else if (flag<0) return ("2");

	if (date1>date2) return ("1");
	else if (date1<date2) return ("2");
	else return ("0");
}
*/

function validateDate(stDate,endDate) {

	var date1=stDate.value;
	var date2=endDate.value;

	if(DateStringCompare(date1,date2)==1) return ("1");
	else if(DateStringCompare(date1,date2)==-1) return ("2");
	else return ("0");
}

function SelectedModifiers() {
	var str="";
	var obj=document.getElementById("Modifiers");
	if (obj) {
		for (var i=0; i<obj.length; i++) {
			if (obj.options[i].selected==true) str+="^"+obj.options[i].text;
		}
	}
	return str;
}
function DeselectListbox(obj)
{
	for(var i=0; i< obj.length; i++)
	{
		obj.options[i].selected=false;
	}
}


function LookUpCatSelect(txt) {

	//ANA 06.03.2002 Function to Return the Category ID

	var adata=txt.split("^");
	var catDesc=adata[0];
	var catID=adata[1];

	var catCode=adata[2];


	//alert(catDesc);
	//alert(catobj.value);
	var cobj=document.getElementById("catID");
	if (cobj) cobj.value=catID;
	//alert("catID: " + catID);
	var scobj=document.getElementById("SubCategory");
	if (scobj) scobj.value="";
	var iobj=document.getElementById("Item");
	if (iobj) iobj.value="";
}

function LookUpSubCatSelect(txt) {
	//alert(txt);
	//SubCatChangeHandler;
	//ANA 06.03.2002 Function to Return the SubCategory ID
	var adata=txt.split("^");
	var subCatDesc=adata[0];
	var subCatID=adata[1];
	var subCatCode=adata[2];
	var subcatobj=document.getElementById("subCatID");
	if (subcatobj) subcatobj.value=subCatID;
	var obj=document.getElementById("SubCategory");
	if (obj) obj.value=subCatDesc;
	//alert("subCatID: " + subCatID);
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

	var Obj=document.getElementById("Orders");

	if (iordertype=="ARCIM") iSetID="";
	if (Obj && ShouldAddItem(icode,idesc,obj)) {
		AddItemToList(lstOrders,icode,idesc,isubcatcode,iordertype,ialias,"",iSetID,iorderCatID,idur,SetRef);
		if (adata[3]=="ARCOS") {
			//alert(SetCat+" setcat in csp ")
			if (matchCategory(SetCat,iorderCatID)) OSItemListOpen(icode,idesc,"YES","");
		}
		else {
			if (matchCategory(ItemCat,iorderCatID))	match="found";
		}
		document.fOEOrder_DietOrders.Item.value="";
		if(match)
		{

			var subcatobj=document.getElementById("subCatID");
			if (subcatobj) subcatobj.value="";
			var cobj=document.getElementById("catID");
			if (cobj) cobj.value="";
			subcatobj=document.getElementById("subCategory");
			if (subcatobj) subcatobj.value="";
			var cobj=document.getElementById("Category");
			if (cobj) cobj.value="";

			var epis=""
			var eobj=document.getElementById("EpisodeID");
			if (eobj) epis=eobj.value;
			return OrderDetailsOpen(idesc,"",icode,"",epis);
			//return OrderDetailsOpen(idesc,"",icode,"");
		}
	}
	return;
}

function FindDietStanding(){

	var EpisodeID="";
	var OEORIItmMastDR="";

	var obj=document.getElementById("EpisodeID");
	if((obj)&&(obj.value!="")) EpisodeID=obj.value;

	var obj=document.getElementById("ARCIMRowId");
	if((obj)&&(obj.value!="")) OEORIItmMastDR=obj.value;

	var path="oeorder.dietorderstanding.csp?EpisodeID="+EpisodeID+"&OEORIItmMastDR="+OEORIItmMastDR+"&WINNAME="+window.name;
	//alert(path);
	websys_createWindow(path,"TRAK_hidden");
}

function DietTypeLookupSelect(txt) {
	ClearField;
	//info from web.ARCItemCat  FindDietOrders  ARCIMDesc,ARCIMRowID,Modifiers,ARCIMCode,ARCIMModifiersRequired  vvv
	var adata=txt.split("^");

	var dtobj=document.getElementById("DietType");
	if (dtobj) dtobj.value=adata[0];

	var arcobj=document.getElementById("ARCIMRowId");
	if (arcobj) arcobj.value=adata[1];

	var modObj=document.getElementById("Modifiers");
	var s=adata[2].split(",");
	if (modObj) AddModifiers(modObj,s);

	var dtcobj=document.getElementById("ARCIMCode");  //Diet Type Code
	if (dtcobj) dtcobj.value=adata[3];
	DietCode=dtcobj.value;

	var ModRequireObj=document.getElementById("ARCIMModifiersRequired");   //; *****  Log# 29922; AmiN ; 06/Nov/2002   Some Diet Codes have required Modifiers.*****
	if (ModRequireObj) {
		ModRequireObj.value=adata[4];
		//alert ("ARCIMModifiersRequired = "+ModRequireObj.value);
	}
	FindDietStanding();
	return DietCode;
}

function matchCategory(grpCat,orderCat) {
	var grpCatArray=grpCat.split(",")
	for (i=0;i<grpCatArray.length;i++) {
		if (orderCat==mPiece(grpCat,",",i)) {
			return true;
		}
	}
}
function OSItemListOpen(id,OSdesc,del,itemtext) {

	var obj=document.getElementById("DefaultData");
	var patobj=document.getElementById("PatientID");
	var Patient = "";
	OSdesc=escape(OSdesc);
	if (patobj) Patient=patobj.value;
	//alert("custom.js OSItemListOpen "+itemtext)
	if (itemtext!="") {
		itemtext=escape(itemtext);
		//alert("in if itemtext escape "+itemtext)
		var url="oeorder.ositemlist.csp?TEVENT=d128iHideButton"+"&HiddenDelete="+del+"&itemtext="+itemtext+"&PatientID="+Patient;
	} else {
		var url="oeorder.ositemlist.csp?TEVENT=d128iHideButton"+"&HiddenDelete="+del+"&ORDERSETID="+id+"&ARCIMDesc="+OSdesc+"&PatientID="+Patient;
	}
	//Adds default data to the url - log 22982
	if (obj) {
		//alert(obj.value);
		url=url+"&DefaultData="+obj.value;
	}

	//alert(url);
        //Log 59598 - BC - 30-06-2006 : Change statusbar variable (status=) to display the status bar (=yes).
	//window.open(url,"OSLIST","left=100,width=400,height=480,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
     //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
    //websys_createWindow(url,"frmOSList","left=100,width=400,height=480,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
	websys_createWindow(url,"frmOSList","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
	//websys_lu(url,false);
}


function StartMealLookUpSelect(str) {  //MEALT_Desc, MEALT_Code, MEALT_Time, MEALT_RowId, MEALT_CutOffTime
	var lu=str.split("^");
	//alert(str);
	if (smobj) smobj.value=lu[0];
	var smtobj=document.getElementById("StartMealTime");
	if (smtobj) smtobj.value=lu[2];
	if (smcobj) smcobj.value=lu[4];
}

function EndMealLookUpSelect(str) {
	var index=1;
	var lu=str.split("^");

	if (emobj) emobj.value=lu[0]; 		//MEALT_Desc

	var emtobj=document.getElementById("EndMealTime");
	if (emtobj) emtobj.value=lu[2];  //MEALT_Time

	if (emcobj) emcobj.value=lu[4];  //MEALT_CutOffTime
}

function StrmCount(){
	strmCheck=0;
	return strmCheck;
}

function ClearField() {
	var ModObj=document.getElementById("Modifiers");  //Modifiers  Listbox
		if (ModObj) {
			for (var i=ModObj.options.length-1; i>=0; i--){
				 ModObj.options[i] = null;   //Removes ALL the options from a listbox(obj)
			}
		}
}

function LoadHandler() {
	//var DietTypeobj=document.getElementById("DietType");
	//if (DietTypeobj) DietTypeobj.onchange=ClearField;

	var HEDobj=document.getElementById("hidEndDate");
	var EDobj=document.getElementById("EndDate");

	if(HEDobj && EDobj && (EDobj.value=="") && (HEDobj.value!="")) EDobj.value=HEDobj.value
	try{
		CustomLoadHandler();
	}catch(e){}
}


function AddModifiers(list,arr){//,ordertype,alias,setid,ordcatID,) {
	if (list!="") {
		for (var i=(list.length-1); i>=0; i--) {
			list.options[i]=null;
			}
		for(var j=0; j<=arr.length; j++)
		{
			list.options[list.length] = new Option(arr[j],arr[j]);
		}
	}
}
function AddItemToList(list,code,desc,subcatcode,ordertype,alias,data,setid,ordcatID,dur,setref) {
//	alert("data = " + data);
	//Add an item to a listbox
	if (list=="") list=lstOrders;
	var obj=document.getElementById("DefaultData");
	if ((obj)&&(data=="")) data=obj.value;
	//alert("data = " + data);
	lstOrders.selectedIndex = -1;
	list.options[list.length] = new Option(desc,code);
	list.options[list.length-1].id=subcatcode+String.fromCharCode(4)+dur+String.fromCharCode(4)+setref+String.fromCharCode(4);
	list.options[list.length-1].itype=ordertype+String.fromCharCode(4)+alias+String.fromCharCode(4)+setid+String.fromCharCode(4)+ordcatID+String.fromCharCode(4);
	list.options[list.length-1].selected=true;
	list.options[list.length-1].idata=data;
	list.options[list.length-1].subcatcode=subcatcode;
}
function OrderModifiers_ClickHandler(){
	//displays new page where the user can edit some of the fields.
	OrderDetailsPage(document.fOEOrder_DietOrders);
	return false;
}

function CollectedFields(DataFields){
	//alert("DataFields: "+DataFields);
	try {
		//Log 08/11/2006 PeterC
		DataFields=unescape(DataFields);
		var selItem=lstOrders.options[lstOrders.selectedIndex];
		selItem.idata=DataFields;
	} catch(e) { }
}

function OrderDetailsPage(f) {
	if (lstOrders) {
		if (lstOrders.selectedIndex == -1) {
			alert("Please select an item");
			return;
		}
		var ItemDesc = lstOrders.options[lstOrders.selectedIndex].text;
		var itemdata=lstOrders.options[lstOrders.selectedIndex].idata;
		var itemvalue=lstOrders.options[lstOrders.selectedIndex].value;  // OrderSetRowid
		var itype=lstOrders.options[lstOrders.selectedIndex].itype;

		var OSRowid=itemvalue;
		var OSRowidFromitype = mPiece(itype,String.fromCharCode(4),2);
		if (!OSRowidFromitype) {
			OSRowidFromitype="";
		}
		if (mPiece(itype,String.fromCharCode(4),0)=="ARCOS") {
			OSItemListOpen(OSRowid,ItemDesc,"YES","");
		} else if (OSRowid.indexOf("||")<0) {
			OSItemListOpen(OSRowid,ItemDesc,"YES","");
		} else {
			if (!itemdata) itemdata="";
			if (OSRowidFromitype!="") OSRowid=OSRowidFromitype;

			if (mPiece(itemdata,String.fromCharCode(1),4)=="NODETAILS") itemdata="";
			var EpisObj=document.getElementById("EpisodeID");
			if (EpisObj) EpisID=EpisObj.value;
			//alert("ItemDesc/itemdata/itemvalue/OSRowid/EpisID="+ItemDesc+"/"+itemdata+"/"+itemvalue+"/"+OSRowid+"/"+EpisID);
			OrderDetailsOpen(ItemDesc,itemdata,itemvalue,OSRowid,EpisID); //xxx itemvalue from item selected in Selected Orders
		}
	}
}

function OrderDetailsOpen(sItemDesc,sitemdata,sitemvalue,sOSRowid,sEpisodeID) {
	//alert("sItemDesc,sitemdata,sitemvalue,sOSRowid,sEpisodeID = "+sItemDesc+"^^^"+sitemdata+"^^^"+sitemvalue+"^^^"+sOSRowid+"^^^"+sEpisodeID);

		var StartMeal, EndMeal, StartDate, EndDate, OEORIEndDate, Link
		Link="";
		var PatObj=document.getElementById("PatientID");
		if (PatObj) PatientID=PatObj.value;
		var SMObj=document.getElementById("StartMeal");
		if (SMObj) StartMeal=SMObj.value;
		var EMObj=document.getElementById("EndMeal");
		if (EMObj) EndMeal=EMObj.value;
		var STObj=document.getElementById("StartDate");
		if (STObj) StartDate=STObj.value;
		var ETObj=document.getElementById("EndDate");
		if (ETObj) EndDate=ETObj.value;
		var ETObj=document.getElementById("Link");
		if (ETObj && ETObj.checked) Link="YES";

		//Loads default values - if default carry to every item - log 22982
		if (sitemdata=="") sitemdata=strDefaultData;
		//PeterC 10/10/05 Need to escape sitemdata
		sitemdata=escape(sitemdata);
		var url = "oeorder.mainloop.csp?ARCIMDesc="+sItemDesc+"&EpisodeID="+sEpisodeID+"&itemdata="+sitemdata+"&OEORIItmMastDR="+sitemvalue+"&ORDERSETID="+sOSRowid+"&PatientID="+PatientID+"&StartMeal="+StartMeal+"&EndMeal="+EndMeal+"&StartDate="+StartDate+"&EndDate="+EndDate+"&Link="+Link+"&MealOrder=Y"+"&OrderingFrom=oeorder.dietorders";
		//alert("url="+url);
                //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
		///websys_createWindow(url, "frmOrderDetails","left=200,width=450,height=300,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
		websys_createWindow(url, "frmOrderDetails","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")

}

function mPiece(s1,sep,n) {
	var delimarray;
	//Getting wanted piece, passing (string,separator,piece number)
	//First piece starts from 0
	//Split the array with the passed delimeter
	delimArray = s1.split(sep);
	//If out of range, return a blank string
	if ((n <= delimArray.length-1) && (n >= 0)) return delimArray[n];
}

function GetOrderData(listobj) {
	if (listobj) var selList = listobj;
	if (selList) var length = selList.length;
	var freqItems="";
	var DataFound=false;
	var freqItems="";
	var idData="";
	var listData="";
	if (selList) {
		for (var i=0; i<length; i++) {
			var listItem = selList.options[i].text;
			//var freq = selList.options[i].id;
			var listData = selList.options[i].idata;
			var listValue = selList.options[i].value;
			AddHiddenItem(listData,listItem,listValue);
		}
	}
	document.fOEOrder_DietOrders.kCounter.value = hidItemCnt;
}

function AddHiddenItem(listData,listItem,listValue)
{
	var DataFound=false;
	if (listData!="" && listData!=null) {
		//Find if using default values - log 22982
		var arrData=listData.split(String.fromCharCode(1));
		var fields=UpdateFields(listData,"");
		var hidItemValue=listItem+String.fromCharCode(1)+fields;
		//alert(hidItemValue);
		AddInputDO(hidItemValue);
		DataFound=true;
	}
	if (DataFound==false) {
		var fields=UpdateFields(String.fromCharCode(1)+String.fromCharCode(1)+listValue,"");
		AddInputDO(listItem+String.fromCharCode(1)+fields);
	}
}
/*
function SplitOrderIntoDays(listData,listItem,listValue)
{
	var arrElem = new Array("ID","EpisodeID","OEORIItmMastDR","ID","OECPRDesc","OSTATDesc","CTLOCDesc","OEORISttDat","OEORISttTim","OEORIItemGroup","OEORIQty","OEORIRemarks","OEORIDepProcNotes","OEORIDoseQty","CTUOMDesc","PHCFRDesc1","PHCINDesc1","PHCDUDesc1","OEORIMaxNumberOfRepeats","OEORILabEpisodeNo","OEORILab1","OEORILab2","TestSetCode","DeptDesc","CTPCPDesc","CONSDesc","OEORIWhoGoWhere","OEORIPrice","Doctor","RMFrequency","RMDuration","OEORIBillDesc","BillPrice","OrderTypeCode","MealType","RiceType","Volume","Energy","Protein","Fat","Carbohydrate","DelayMeal","SteriliseUtensils","PasteurisedFood","CoveredByMainInsur","PortableEquiptRequired","AdmAfterSkinTest","ContactCareProv","AlertReason","CareProvList","NeedleGauge","NeedleType","BodySite","QuantityUnit","FlowQuantity","FlowTimeUnit","FlowTime","FlowRateDescr","FlowRateUnit","Interval","Linked","OEORIVarianceReasonDR","Modifiers","teeth","ColDate","ColTime","SpecCollected","OEORIReasOrdCMVNegBlood","OEORICompXMatchReq","OEORIAutologousBloodReq","OEORIPatConsentObtained","OEORIBBTAG1","OEORIBBTAG2","OEORIBBTAG3","OEORIBBTAG4","OEORIBBTAG5","ORNCDesc","OEORINoOrderedBags","OEORIBagsAvailFrLastOrder","SpecSites","OEORIEndDat");
	var StartDate,EndDate,Meals = "";
	var arrData=listData.split(String.fromCharCode(1));
	for(var i=0; i<arrElem.length; i++)
	{
		if(arrElem[i]=="OEORISttDat")
			StartDate=arrData[i];
		if(arrElem[i]=="OEORIEndDat")
			EndDate=arrData[i];
		if(arrElem[i]=="MealType")
			Meals=arrData[i];
	}
	//if enddate is blank or equals startdate then just do startdate
		var dateArr =StartDate.split("/");
		var tempDate = new Date(dateArr[2],dateArr[1],dateArr[0]);
		var SD = ""+tempDate.getYear()+tempDate.getMonth()+tempDate.getDate();

		dateArr =EndDate.split("/");
		tempDate = new Date(dateArr[2],dateArr[1],dateArr[0]);
		var ED = ""+tempDate.getYear()+tempDate.getMonth()+tempDate.getDate();

		if((ED-SD)>=1)//more then one day
		else{
			//just one day so no processing
			AddHiddenItem(listData,listItem,listValue)
		}

}	*/

function DeleteClickHandler(txt)
{

}
//counter for the number of INPUT boxes
function AddInputDO(value) {
	hidItemCnt++;
	//Create a new element
	var NewElement=document.createElement("INPUT");
	//set the properties
	NewElement.id = 'hiddenitem' + hidItemCnt;
	NewElement.name = 'hiddenitem' + hidItemCnt;
	//NewElement.value = escape(value);
	NewElement.value = value;
	NewElement.type = "HIDDEN";
	//alert(value);
	//add the element to the document order doesn't matter
	//aslong as its within the form tags
	//document.fOEOrder_Custom.insertBefore(NewElement,document.fOEOrder_Custom.dummy);
	document.fOEOrder_DietOrders.dummy.insertAdjacentElement("afterEnd",NewElement);
}

function UpdateFields(idata,text) {
	var arrElem = new Array("ID","EpisodeID","OEORIItmMastDR","ORDERSETID","OECPRDesc","OSTATDesc","CTLOCDesc","OEORISttDat","OEORISttTim","OEORIItemGroup","OEORIQty","OEORIRemarks","OEORIDepProcNotes","OEORIDoseQty","CTUOMDesc","PHCFRDesc1","PHCINDesc1","PHCDUDesc1","OEORIMaxNumberOfRepeats","OEORILabEpisodeNo","OEORILab1","OEORILab2","TestSetCode","DeptDesc","CTPCPDesc","CONSDesc","OEORIWhoGoWhere","OEORIPrice","Doctor","RMFrequency","RMDuration","OEORIBillDesc","BillPrice","OrderTypeCode","MealType","RiceType","Volume","Energy","Protein","Fat","Carbohydrate","DelayMeal","SteriliseUtensils","PasteurisedFood","CoveredByMainInsur","PortableEquiptRequired","AdmAfterSkinTest","ContactCareProv","AlertReason","CareProvList","NeedleGauge","NeedleType","BodySite","QuantityUnit","FlowQuantity","FlowTimeUnit","FlowTime","FlowRateDescr","FlowRateUnit","Interval","teeth","ColDate","ColTime","freeText");
	var arrData = new Array(arrElem.length);
	var gobj=document.getElementById("OEORIItemGroup");
	var ProcNotes="";
	var Doctor="";
	var Group=""

	if (gobj) Group=gobj.value;

	arrData=idata.split(String.fromCharCode(1));
	for (var i=0; i<arrElem.length; i++) {
		if (arrElem[i]=="OEORIDepProcNotes" && ProcNotes!="") {
			if (arrData[i]!=null) {
				arrData[i]=arrData[i]+String.fromCharCode(13)+String.fromCharCode(10)+String.fromCharCode(13)+String.fromCharCode(10)+ProcNotes;
			}
		}
		if (text!=="" && arrElem[i]=="freeText") arrData[i]=String.fromCharCode(1)+text;
	}
	var str=arrData.join(String.fromCharCode(1));
	return str;
}


function SetDefaultData(sDefaultData) {
	var obj=document.getElementById("DefaultData");
	strDefaultData=sDefaultData;
	if (obj) obj.value=sDefaultData
}

function Assistance_ClickHandler()
{
	PatientDetailsChanged=true;
}

//var scobj=document.getElementById("SubCategory");
//if (scobj) scobj.onchange=SubCatChangeHandler;

function SubCatChangeHandler() {
	if ((scobj) && (scobj.value=="")) {
		var subcatobj=document.getElementById("subCatID");
		if (subcatobj) subcatobj.value="";
	}
}

function DelayUpdateClick_Handler() {
	window.setTimeout(UpdateClick_Handler,200)
}

document.body.onload=LoadHandler;
var uobj=document.getElementById("Update");
if (uobj) uobj.onclick=DelayUpdateClick_Handler;

var odobj=document.getElementById("OrderDelete");
if(odobj) odobj.onclick=OrderDeleteClick_Handler;
var omobj=document.getElementById("OrderModifiers");
if(omobj) omobj.onclick=OrderModifiers_ClickHandler;
var assistmealobj=document.getElementById("ALGRequireAssistanceMeal");
if(assistmealobj) assistmealobj.onclick=Assistance_ClickHandler;
var assistmenuobj=document.getElementById("ALGRequireAssistanceMenu");
if(assistmenuobj) assistmenuobj.onclick=Assistance_ClickHandler;
