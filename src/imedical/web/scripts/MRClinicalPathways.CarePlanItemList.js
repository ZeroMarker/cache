// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var currItems='';
var obj=document.getElementById('currItems');
if (obj) currItems=obj.value;

var hidItemCnt=0;
function dumpObject(obj) {
	objlst='<HTML><BODY><TABLE cellpadding="2" cellspacing="0" border="1">';
	for (x in obj) {
		objlst+='<tr><td align="right"><b>' + x + '</b></td><td>' + obj[x] + '</td></tr>';
	}
	objlst+='</table></BODY></HTML>';
	var dumpwin=window.open('','DUMP');
	dumpwin.document.open();
	dumpwin.document.write(objlst);
	dumpwin.document.close;
}
//used instead of the calling order item TransferData function
//data collected in expected order in case of hidden or rearranged fields
function TransferDataMain(frm) {
	//alert("custom "+frm.name);
	var strData = "";
	var arrElem = new Array("ID","EpisodeID","OEORIItmMastDR","ORDERSETID","OECPRDesc","OSTATDesc","CTLOCDesc","OEORISttDat","OEORISttTim","OEORIItemGroup","OEORIQty","OEORIRemarks","OEORIDepProcNotes","OEORIDoseQty","CTUOMDesc","PHCFRDesc1","PHCINDesc1","PHCDUDesc1","OEORIMaxNumberOfRepeats","OEORILabEpisodeNo","OEORILab1","OEORILab2","TestSetCode","DeptDesc","CTPCPDesc","CONSDesc","OEORIWhoGoWhere","OEORIPrice","Doctor","RMFrequency","RMDuration","OEORIBillDesc","BillPrice","OrderTypeCode","MealType","RiceType","Volume","Energy","Protein","Fat","Carbohydrate","DelayMeal","SteriliseUtensils","PasteurisedFood","CoveredByMainInsur","PortableEquiptRequired","AdmAfterSkinTest","ContactCareProv","AlertReason","CareProvList","NeedleGauge","NeedleType","BodySite","QuantityUnit","FlowQuantity","FlowTimeUnit","FlowTime","FlowRateDescr","FlowRateUnit","Interval","Linked","OEORIVarianceReasonDR","Modifiers","teeth","ColDate","ColTime","SpecCollected");
	//,"ColDate","ColTime","SpecCollected");
	var arrData = new Array(arrElem.length);
	var arrDefaultData = new Array(arrElem.length);
	
	//alert(arrElem.length);
	//initialise
	for (var i=0; i<arrData.length; i++) {
		arrData[i] = "";
	}
	
	//collect Data
	for (i=0; i<arrElem.length; i++) {
		var el = frm.elements[arrElem[i]];
		
		if (el) {
			if (el.type=="select-multiple") {
				for (var j=0; j<el.options.length; j++) {
					if (el.name=="CareProvList") {
						arrData[i] += "^" + el.options[j].text;
					}
					if ((el.name=="MealType") && (el.options[j].selected)) {
						arrData[i] += "^" + el.options[j].text;
					}
					if ((el.name=="Modifiers") && (el.options[j].selected)) {
						//alert("transfer="+el.options[j].text);
						arrData[i] += "^" + el.options[j].text;
					}
					if ((el.options[j].selected) && (el.name!="Modifiers")) {					
						arrData[i] += "^" + el.options[j].value ; 
					}
				}		
				
			} else {
				if ((el.type=="checkbox") && (el.checked==false)) {	
					arrData[i]="";
				} else {
					arrData[i] = el.value;
					//alert(el.name+"++"+el.value);
				}
			}
		}
	}

	strData = arrData.join(String.fromCharCode(1));
	strData = escape(strData);
	return strData;
}


function xTransferDataMain(frm) {
	//alert("from CarePlanItem");
	var strData = "";
	//ID^EpisodeID^ordID^ordSetID^pri^stat^recvloc^date^time^group^quantity^ordNotes^procNotes^dosage^UOM^freq^instruct^duration^maxrepeat^labspecs
	var arrElem = new Array("ID","EpisodeID","OEORIItmMastDR","ORDERSETID","OECPRDesc","OSTATDesc","CTLOCDesc","OEORISttDat","OEORISttTim","OEORIItemGroup","OEORIQty","OEORIRemarks","OEORIDepProcNotes","OEORIDoseQty","CTUOMDesc","PHCFRDesc1","PHCINDesc1","PHCDUDesc1","OEORIMaxNumberOfRepeats","OEORILabEpisodeNo","OEORILab1","OEORILab2","TestSetCode","DeptDesc","CTPCPDesc","CONSDesc","OEORIWhoGoWhere","OEORIPrice","Doctor","RMFrequency","RMDuration","OEORIBillDesc","BillPrice","OrderTypeCode","MealType","RiceType","Volume","Energy","Protein","Fat","Carbohydrate","DelayMeal","SteriliseUtensils","PasteurisedFood","CoveredByMainInsur","PortableEquiptRequired","AdmAfterSkinTest","ContactCareProv","AlertReason","CareProvList","NeedleGauge","NeedleType","BodySite","QuantityUnit","FlowQuantity","FlowTimeUnit","FlowTime","FlowRateDescr","FlowRateUnit","Interval","Linked","OEORIVarianceReasonDR","Modifiers");
	var arrData = new Array(arrElem.length);	
	for (var i=0; i<arrData.length; i++) {
		arrData[i] = "";
	}
	//collect Data
	for (i=0; i<arrElem.length; i++) {
		var el = frm.elements[arrElem[i]];
		
		if (el) {
			if (el.type=="select-multiple") {
				for (var j=0; j<el.options.length; j++) {
					if (el.name=="CareProvList") {
						arrData[i] += "^" + el.options[j].text;
					}
					if ((el.name=="MealType") && (el.options[j].selected)) {
						arrData[i] += "^" + el.options[j].text;
					}
					if ((el.name=="Modifiers") && (el.options[j].selected)) {
						//alert("transfer="+el.options[j].text);
						arrData[i] += "^" + el.options[j].text;
					}
					if ((el.options[j].selected) && (el.name!="Modifiers")) {					
						//alert("value "+el.options[j].value);
						arrData[i] += "^" + el.options[j].value ; 
					}				
				}		
				
			} else {
				if ((el.type=="checkbox") && (el.checked==false)) {
					arrData[i]="";
				} else {
					arrData[i] = el.value;					
				}
			}
		}
	}	
	strData = arrData.join(String.fromCharCode(1));
	return strData;
}

function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];		
    }
}

function CollectedFields(DataFields) {

	var obj=document.getElementById("ItemDataz"+rowsel);
	if (obj) {
		obj.value=DataFields;
		//alert("collect: "+obj.value);
	}

}
function OrderDetails(e){

	CheckMultipleOrders();
	var src=websys_getSrcElement(e);
	var oeoriID="";

	if (src.tagName != "A") return;
	//Gets the selected row
	if (src.id.substring(0,5)!="descz") return;
	var arry=src.id.split("z");
	rowsel=arry[arry.length-1];
	//Adds ItemData to link expression
	var DataField=document.getElementById("ItemDataz"+rowsel);
	var LinkField=document.getElementById("descz"+rowsel);
	var oeObj=document.getElementById("OEORIROWIDz"+rowsel);
	if (oeObj) oeoriID=oeObj.value;
	
	if (DataField) {

		var idata="";
		if (DataField.value!="") idata=DataField.value;
		var i=0;
		var lnk=LinkField.href.split("&");
		//Log 48858 PeterC 22/04/05
		if ((lnk[i+6]).indexOf("EpisodeID")!=-1)
		{
			lnk[i+5]=lnk[i+6]
		}
		LinkField.href=lnk[i]+"&"+lnk[i+1]+"&"+"TWKFL=&TWKFLI=&"+lnk[i+4]+"&"+lnk[i+5]+"&ID="+oeoriID+"&"+lnk[i+7]+"&"+lnk[i+8]+"&"+lnk[i+9]+"&itemdata="+idata;

		websys_lu(LinkField.href,false,"");
		return false;
	}
}

function DeleteAllHiddenItems() {
	for (i=1; i<=hidItemCnt; i++) {
		var id="hiddenitem"+hidItemCnt;
		var objhid=document.getElementById(id);
		if (objhid) objhid.outerText='';		
	}
	hidItemCnt=0;
}
/*function reSizeT(e) {
	var w=0;var f=this.document.body.all;
	for (var i=0;i<f.length;i++) {
		if (f[i].tagName=="TABLE") if (f[i].offsetWidth>w) w=f[i].offsetWidth;
	}
	if (w>eval(window.screen.Width-window.screenLeft)) w=eval(window.screen.Width-window.screenLeft)-40;
	if (w<282) w=282;
	this.resizeTo(w+30,450);
}
*/
//counter for the number of INPUT boxes
function AddInputCP(value) {
	//alert(value);
	var uobj=document.getElementById("Update");
	//var u1obj=document.getElementById("Update1");

	hidItemCnt++;
	//Create a new element
	var NewElement=document.createElement("INPUT");
	//set the properties
	NewElement.id = 'hiddenitem' + hidItemCnt;
	NewElement.name = 'hiddenitem' + hidItemCnt;
	//NewElement.value = escape(value);
	NewElement.value = value;
	NewElement.type = "HIDDEN";
	
	if (uobj) document.fMRClinicalPathways_CarePlanItemList.dummy.insertAdjacentElement("afterEnd",NewElement);
	//if (u1obj) document.fMRClinicalPathways_CarePlanItemListAll.dummy.insertAdjacentElement("afterEnd",NewElement);
}

function getDelim(val) {
	var delim="";
	if (val>0) {
		for (i=1;i<val;i++) {
			delim=delim+String.fromCharCode(1);
		}
		return delim;
	}
}

function AddAllClickHandler() {
	var uobj=document.getElementById("Update");
	//var u1obj=document.getElementById("Update1");
	if (uobj) eTABLE=document.getElementById("tMRClinicalPathways_CarePlanItemList");
	//if (u1obj) eTABLE=document.getElementById("tMRClinicalPathways_ItemListAll");
	if (eTABLE) {
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			if (AddItemObj) AddItemObj.checked=true;			
		}
	}
}
function GetOrderData() {
	var ItemData="";
	var itmLinked="";
	var parrefs="";
	var uobj=document.getElementById("Update");
	var missingLoc="";
	
	//var u1obj=document.getElementById("Update1");
	if (uobj) eTABLE=document.getElementById("tMRClinicalPathways_CarePlanItemList");
	//if (u1obj) eTABLE=document.getElementById("tMRClinicalPathways_ItemListAll");
	if (eTABLE) {
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			if ((AddItemObj.checked)&&(!AddItemObj.disabled)) {
				//var OrdTypeCodeObj=document.getElementById("OrderTypeCodez"+i);
				var ItemDataObj=document.getElementById("ItemDataz"+i);
				var CodeObj=document.getElementById("ItemRowidz"+i);
				var setObj=document.getElementById("SETIDz"+i);
				var prObj=document.getElementById("OSParRefz"+i);
				var OEORIROWID="";
				var OEORIROWIDObj=document.getElementById("OEORIROWIDz"+i);
				if (OEORIROWIDObj) OEORIROWID=OEORIROWIDObj.value;
				if (prObj) {
					parrefs=parrefs+prObj.value+"^";
				}
				var type="ARCIM";
				//if (OrdTypeCodeObj) OrderTypeCode=OrdTypeCodeObj.value;
				if (ItemDataObj) ItemData=ItemDataObj.value;
				if (CodeObj) code=CodeObj.value;
				if (setObj) SETID=setObj.value;

				var descObj=document.getElementById("descz"+i);
				if (descObj) desc=descObj.innerText;
				else return t['PleaseAddIntervention'];
				//log 64138 BoC: don't need to set and add the item details if the item belongs to free text goals because it has been ordered already.
				if (OEORIROWID!="") continue;

				var sdObj=document.getElementById("SetDefDetailsz"+i);
				if (sdObj) {
					var str=sdObj.value;
					var osdur="";
					var osfreq="";
					var osinstr="";
					var osUOM="";
					var osDoseQty="";
					//alert(str);
					if (str!="") {
						var setdef=str.split(String.fromCharCode(1));
						if (setdef[0]!="") osdur=setdef[0];
						if (setdef[1]!="") osfreq=setdef[1];
						if (setdef[2]!="") osinstr=setdef[2];
						if (setdef[3]!="") osUOM=setdef[3];
						if (setdef[4]!="") osDoseQty=setdef[4];
					}
				}

				var lnkObj=document.getElementById("itmLinkedz"+i);
				if (lnkObj) itmLinked=lnkObj.value;

				//var delim=getDelim(12);
				var delim=getDelim(10);
				var delim2=getDelim(44);
				data=String.fromCharCode(1)+String.fromCharCode(1)+code+String.fromCharCode(1)+SETID+String.fromCharCode(1)+delim+osDoseQty+String.fromCharCode(1)+osUOM+String.fromCharCode(1)+osfreq+String.fromCharCode(1)+String.fromCharCode(1)+osdur+delim2+itmLinked;
				var hidItemValue=desc+String.fromCharCode(1)+data;
				//alert(hidItemValue);
				//log59415 tedt unescape ItemDataObj.value before concat
				if ((ItemDataObj)&&(ItemDataObj.value!="") && (ItemDataObj.value!=null)) hidItemValue=desc+String.fromCharCode(1)+unescape(ItemDataObj.value);
				else {
					//log59873 TedT check if rec loc exist
					var locObj=document.getElementById("itemLocz"+i);
					if(locObj && locObj.value!="") 
						missingLoc=missingLoc+"\n"+locObj.value;
				}
				AddInputCP(hidItemValue);
			}
		}
		//log59873 TedT if some items are missing rec loc, give warning
		if (missingLoc!="") return t['REC_LOC_MISSING']+missingLoc;
		var parRefsObj=document.getElementById("OSParRefs");
		if (parrefs!="") {
			if (parRefsObj) parRefsObj.value=parrefs;
		}
	}
	if (uobj) {
		document.fMRClinicalPathways_CarePlanItemList.kCounter.value = hidItemCnt;
	}
	return "";
}

function UpdateClickHandler() {
//submit all the details and inserts all the orders into the database.

	var PatientID=""; 	var mradm="";	var EpisodeID="";
	//var obj=document.getElementById("Update");
	//if (obj) obj.disabled=true;
	//log57856 TedT 
	var CLPODescObj=document.getElementById("CLPODesc");
	var obj=document.getElementById("cCLPODesc");
	if (obj && CLPODescObj && obj.className=="clsRequired" && CLPODescObj.value=="") {
		alert(t["OUTCOME"]);
		return false;
	}
	
	DeleteAllHiddenItems();
	var ret=GetOrderData();
	if (ret!="") {
		alert(ret);
		return false;
	}
	var StepEpIDs=getSelected_StepEpIDs();
	var arsep0=StepEpIDs.split("**")
	var ar1=arsep0[0];
	var arsep=ar1.split("$$");
	var sobj=document.getElementById("StepIDs");
	if (sobj) sobj.value=arsep[0];
	var PEobj=document.getElementById("PathEpIDs");
	if (PEobj) PEobj.value=arsep[1];
	var PDRobj=document.getElementById("CPWRowIds")
	if (PDRobj) PDRobj.value=arsep[2];
	//alert(arsep[0]+"   "+arsep[1])
	var ar2=arsep0[1];
	var arsep2=ar2.split("$$");
	var sobj=document.getElementById("CPWStepIDs");
	if (sobj) sobj.value=arsep2[0];
	var CPWEobj=document.getElementById("CPWPathEpIDs");
	if (CPWEobj) CPWEobj.value=arsep2[1];
	var CPWPDRobj=document.getElementById("CPWPathwayDRs")
	if (CPWPDRobj) CPWPDRobj.value=arsep2[2];
	//alert("CPWStepIDs "+sobj.value+" CPWPathEpIDs "+CPWEobj.value+" CPWPathwayDRs "+CPWPDRobj.value)
	//
	var mObj=document.getElementById("mradm");
	if (mObj) mradm=mObj.value;
	var pobj=document.getElementById("PatientID");
	if (pobj) PatientID=pobj.value;
	var epobj=document.getElementById("EpisodeID");
	if (epobj) EpisodeID=epobj.value;
	var CONobj=document.getElementById("CONTEXT");
	if (CONobj) CONTEXT=CONobj.value;
	return Update_click();
	
}
function DeleteClickHandler(){
}
function getSelected_StepEpIDs() {
	var PathEpID="";
	var StepID="";
	var CPWRowId=""
	var CPWPathEpID="";
	var CPWStepID="";
	var CPWPathwayDR=""
	
	var eTABLE=document.getElementById("tMRClinicalPathways_CarePlanItemList");
	//if (u1obj) eTABLE=document.getElementById("tMRClinicalPathways_ItemListAll");
	if (eTABLE) {
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			var PathEpIDobj=document.getElementById("PathEpIDz"+i);
			var StepIDobj=document.getElementById("StepIDz"+i);
			var GoalTextObj=document.getElementById("CPWGoalTextz"+i);
			var CPWRowIdObj=document.getElementById("CPWRowIdz"+i);			
			if ((AddItemObj)&&(AddItemObj.checked==true)) {
				if ((StepIDobj.value!="")&&(!AddItemObj.disabled)) {
					if (PathEpID!="") PathEpID=PathEpID+"^";
					PathEpID=PathEpID+PathEpIDobj.value;
					if (StepID!="") StepID=StepID+"^";
					StepID=StepID+StepIDobj.value;
					if (CPWRowId!="") CPWRowId=CPWRowId+"^";
					CPWRowId=CPWRowId+CPWRowIdObj.value;
				} else if (GoalTextObj.value!="") {
					if (CPWPathEpID!="") CPWPathEpID=CPWPathEpID+"^";
					CPWPathEpID=CPWPathEpID+PathEpIDobj.value;
					if (CPWStepID!="") CPWStepID=CPWStepID+"^";
					CPWStepID=CPWStepID+GoalTextObj.value;
					if (CPWPathwayDR!="") CPWPathwayDR=CPWPathwayDR+"^";
					CPWPathwayDR=CPWPathwayDR+CPWRowIdObj.value;
				}
			}
		}
	}
	var StepEpIDs=StepID+"$$"+PathEpID+"$$"+CPWRowId+"**"+CPWStepID+"$$"+CPWPathEpID+"$$"+CPWPathwayDR;
	return StepEpIDs;
}
function LookUpOutcomeStatus(str){
	var strArry=str.split("^");
	var CLPSDescObj=document.getElementById("CLPSDesc");
	if (CLPSDescObj) CLPSDescObj.value=strArry[0];
	var CLPSIdObj=document.getElementById("CLPSId");
	if (CLPSIdObj) CLPSIdObj.value=strArry[1];
	//log57856 TedT make outcome field mandatory if outcome status is closed
	var CLPODescObj=document.getElementById("cCLPODesc");
	if(CLPODescObj) {
		if (strArry[2]=="CLS") {
			CLPODescObj.className="clsRequired";
			var dcall=document.getElementById("DiscontinueAll");
			var dcflag=document.getElementById("DCFlag");
			//open warning window
			var url="websys.default.csp?WEBSYS.TCOMPONENT=MRClinicalPathways.DiscontinueAll";
			if(dcflag) url+="&DCFlag="+dcflag.value;
			if(dcall && dcall.value=="Y") 
				websys_createWindow(url,"","scrollbars=yes,toolbar=no,resizable=yes,width=400,height=200");
		}
		else
			CLPODescObj.className="";
	}
}

function LookUpOutcome(str){
	var strArry=str.split("^");
	var CLPODescObj=document.getElementById("CLPODesc");
	if (CLPODescObj) CLPODescObj.value=strArry[0];
	var CLPOIdObj=document.getElementById("CLPOId");
	if (CLPOIdObj) CLPOIdObj.value=strArry[1];
}

//log57856 TedT 
function OutcomeStatusOnBlur() {
	if(this.value=="") {
		var CLPSIdObj=document.getElementById("CLPSId");
		var CLPODescObj=document.getElementById("cCLPODesc");
		if (CLPSIdObj) CLPSIdObj.value="";
		if (CLPODescObj) CLPODescObj.className="";
	}
}

//log57856 TedT
function OutcomeOnBlur() {
	if(this.value=="") {
		var CLPOIdObj=document.getElementById("CLPOId");
		if (CLPOIdObj) CLPOIdObj.value="";
	}
}
//log57856 TedT
function SetDCFlag(val) {
	var dcall=document.getElementById("DCFlag");
	if(dcall) {
		if(val) dcall.value="Y";
		else dcall.value="N";
	}
}

function ShouldAddItem(ID,desc) {

	var match=-1;
	var additem=1;
	var date="";
	var careprov="";
	var time="";
	var testepisno="";
	var DetailedMessage="N";
	var ordertype="";

	var currItemsArray=currItems.split("^");
	//alert(currItemsArray[8]);

	for (var i=0;i<currItemsArray.length;i++) {
		if (mPiece(currItemsArray[i],String.fromCharCode(1),0)==ID) {
			match=1;
			careprov=mPiece(currItemsArray[i],String.fromCharCode(1),1);
			date=mPiece(currItemsArray[i],String.fromCharCode(1),2);
			time=mPiece(currItemsArray[i],String.fromCharCode(1),3);
			testepisno=mPiece(currItemsArray[i],String.fromCharCode(1),4);
			ordertype=mPiece(currItemsArray[i],String.fromCharCode(1),5);
			DetailedMessage="Y";
			break;
		}


	}

	//now check for new orders already on list (items to be updated)
	//alert("list match : "+match);
	if (match >= 0) {
		if (DetailedMessage=="Y") {
			if ((ordertype=="L") || (ordertype=="N")) {
				additem=confirm(t['MultipleOrder_Desc']+desc+"\n"+t['MultipleOrder_Date']+date+"\n"+t['MultipleOrder_Time']+time+"\n"+t['MultipleOrder_CareProv']+careprov+"\n"+t['MultipleOrder_TestEpisodeNo']+testepisno+"\n"+t['MultipleOrder_WantToAdd']);
			} else {
				additem=confirm(t['MultipleOrder_Desc']+desc+"\n"+t['MultipleOrder_Date']+date+"\n"+t['MultipleOrder_Time']+time+"\n"+t['MultipleOrder_CareProv']+careprov+"\n"+t['MultipleOrder_WantToAdd']);	
			}
		} else {
			additem=confirm("Mulitple Order: "+desc+"\nDo you still want to add?");
			additem=confirm(t['MultipleOrder_Desc']+desc+"\n"+t['MultipleOrder_WantToAdd']);
		}
	}

	return additem;
}
function CheckedSelectedItem(src) {
	var SelItemRowid="";
	var SelItemDesc="";
	if (src.id.substring(0,8)=="AddItemz")	{
		var arry=src.id.split("z");
		rowsel=arry[arry.length-1];
		var obj=document.getElementById("AddItemz"+rowsel);
		if (obj) {
			if (obj.checked) {
				var iobj=document.getElementById("ItemRowidz"+rowsel);
				if (iobj) SelItemRowid=iobj.value;

				var dobj=document.getElementById("descz"+rowsel);
				if (dobj) SelItemDesc=dobj.innerText;

				/*
				if ((SelItemRowid!="") && (!ShouldAddItem(SelItemRowid,SelItemDesc))) {
					obj.checked=false;
				}
				*/

			}
		}
	}

}
function CheckMultipleOrders(e) {
	var src=websys_getSrcElement(e);
	CheckedSelectedItem(src);
	
}

function BodyLoadHandler() {
	var OrdRowIds=""; //var disableFlag="0";
	var OEORIROWIDS="";
	var flag="false";
	//if (self==top) reSizeT();
	var dfObj=document.getElementById("disableFlag");
	if (dfObj) flag=dfObj.value;
	
	//log57856 TedT
	var cObj=document.getElementById("CLPODesc");
	var dObj=document.getElementById("CLPSDesc");
	if(cObj) cObj.onblur=OutcomeOnBlur;
	if(dObj) dObj.onblur=OutcomeStatusOnBlur;
	
	if (dfObj&&flag=="true") {
		var aObj=document.getElementById("CPWIDDate");
		var a1Obj=document.getElementById("cCPWIDDate");
		var bObj=document.getElementById("CPWIDTime");
		var b1Obj=document.getElementById("cCPWIDTime");
		var cObj=document.getElementById("CLPODesc");
		var c1Obj=document.getElementById("cCLPODesc");
		var dObj=document.getElementById("CLPSDesc");
		var d1Obj=document.getElementById("cCLPSDesc");
		var eObj=document.getElementById("CPWComments");
		var e1Obj=document.getElementById("cCPWComments");
		if (aObj&&bObj&&cObj&&dObj&&eObj&&a1Obj&&b1Obj&&c1Obj&&d1Obj&&e1Obj) {
			aObj.disabled=true;
			a1Obj.disabled=true;
			bObj.disabled=true;
			b1Obj.disabled=true;
			cObj.disabled=true;
			c1Obj.disabled=true;
			dObj.disabled=true;
			d1Obj.disabled=true;
			eObj.disabled=true;
			e1Obj.disabled=true;
		}
			var IMGobj1=document.getElementById("ld1365iCLPODesc");
			if ( IMGobj1) IMGobj1.style.visibility="hidden";
			var IMGobj2=document.getElementById("ld1365iCLPSDesc");
			if (IMGobj2) IMGobj2.style.visibility="hidden";
	}
	//descObj=document.getElementById("desc")
	//if (descObj) descObj.onclick=InterventionClickHandler;

	document.onclick=OrderDetails;
	var uObj=document.getElementById("Update");
	if (uObj) uObj.onclick=UpdateClickHandler;

	var AddAllObj=document.getElementById("AddAll");
	if (AddAllObj)  AddAllObj.onclick=AddAllClickHandler;

	//ANA Disable already updated items.
	var ordObj=document.getElementById("OrdRowIds");
	if (ordObj) OrdRowIds=ordObj.value;

	var oebobj=document.getElementById("oeoribuffer");	
	if (oebobj) OEORIROWIDS=oebobj.value;
	//alert(OrdRowIds+"OrdRowIds");

	if (ordObj) eTABLE=document.getElementById("tMRClinicalPathways_CarePlanItemList");
	//if (u1obj) eTABLE=document.getElementById("tMRClinicalPathways_ItemListAll");



	//log59415 TedT allow repeat orders
	/* put back - JD - 60262 */
	var typeflag=false; // 63039
	if (eTABLE) {
		for (var i=1; i<eTABLE.rows.length; i++) {
			var ItemObj=document.getElementById("ItemRowidz"+i);
			var Addobj=document.getElementById("AddItemz"+i);
			var oeObj=document.getElementById("OEORIROWIDz"+i);
			if (Addobj&&ItemObj&&OrdRowIds!="") {
			 	var arr=OrdRowIds.split(",");
				var oearr=OEORIROWIDS.split(",");
				for (var k=0; k<arr.length; k++) {
					//alert("arr[k] "+arr[k]+" ItemObj.value "+ItemObj.value);
					if (arr[k]==ItemObj.value) {
						Addobj.checked=true;			
						Addobj.disabled = true;
						Addobj.className = "";
						if (oeObj) oeObj.value=oearr[k];
					}
				}
			}
			//63039
			var TypeObj=document.getElementById("OrdTypez"+i);
			if ((TypeObj)&&((TypeObj.value=="R")||(TypeObj.value=="I"))) { typeflag=true; }
		}
	}
	
	if (typeflag==true) { alert(t['INVALORDTYPE'] + "\n" + t['USEORDENT']); }	

	var Deselectobj=document.getElementById("DeselectAll"); //AmiN log 30869
	if (Deselectobj){ Deselectobj.onclick = DeselectAll; } 

	var Selectobj=document.getElementById("SelectAll"); 
	if (Selectobj) { Selectobj.onclick = SelectAll; } //AmiN log 30869
}


function DeselectAll(e) {  //AmiN log 30869	
	var tbl=document.getElementById("tMRClinicalPathways_CarePlanItemList");
	var f=document.getElementById("fMRClinicalPathways_CarePlanItemList");	
	if ((f)&&(tbl)) {
		for (var j=1;j<tbl.rows.length;j++) {
			var obj=document.getElementById('AddItemz'+j);
			if ((obj) && (!obj.disabled)) {
				obj.checked=false;				
			}
		}
	}
	return false;
}

function SelectAll(e) {  //AmiN log 30869	
	var tbl=document.getElementById("tMRClinicalPathways_CarePlanItemList");
	var f=document.getElementById("fMRClinicalPathways_CarePlanItemList");	
	if ((f)&&(tbl)) {
		for (var j=1;j<tbl.rows.length;j++) {
			var obj=document.getElementById('AddItemz'+j);
			if ((obj) && (!obj.disabled)) {
				obj.checked=true;				
			}
		}
	}
	return false;
}

function InterventionClickHandler() {	
	OrderDetailsPage(document.fOEOrder_Custom);
	return false;
}
document.body.onload=BodyLoadHandler;
//var rowsel=0;
