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
				}
			}
		}
	}	
	strData = arrData.join(String.fromCharCode(1));
	strData = escape(strData);
	return strData;
}

function mPiece(s1,sep,n) {   
    delimArray = s1.split(sep);  //Split the array with the passed delimiter  
	
    if ((n <= delimArray.length-1) && (n >= 0)) {   //If out of range, return a blank string
        return delimArray[n];		
    }
}

function CollectedFields(DataFields){
	var obj=document.getElementById("ItemDataz"+rowsel)
	//alert(rowsel+","+DataFields);
	if (obj) {
		obj.value=DataFields;
		//alert(obj.value);
	}	
}

function OrderDetails(e){ /// AmiN log 27569  In ICP Steps allows the Order detail for the Order Item to display. 

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
	
	var PatObj=document.getElementById("PatientID");  //Extra fields needed
		if (PatObj) PatientID=PatObj.value;
		
		var EpIDObj=document.getElementById("EpisodeID");   //Extra fields needed
		if (EpIDObj) EpisodeID=EpIDObj.value;
	
	if (DataField) {

		var idata="";
		if (DataField.value!="") idata=DataField.value;
		var i=0;
		var lnk=LinkField.href.split("&");
		//Blank out so that link is followed and not the workflow  TWKFL=&TWKFLI=&
		LinkField.href=lnk[i]+"&"+lnk[i+1]+"&"+"TWKFL=&TWKFLI=&"+lnk[i+4]+"&"+lnk[i+5]+"&ID="+oeoriID+"&"+lnk[i+7]+"&"+lnk[i+8]+"&"+lnk[i+9]+"&itemdata="+idata+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID;
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
/* function reSizeT(e) {
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
function AddInput(value) {	
	var uobj=document.getElementById("Update");
	var u1obj=document.getElementById("Update1");

	hidItemCnt++;
	//Create a new element
	var NewElement=document.createElement("INPUT");
	//set the properties
	NewElement.id = 'hiddenitem' + hidItemCnt;
	NewElement.name = 'hiddenitem' + hidItemCnt;
	//NewElement.value = escape(value);
	NewElement.value = value;
	NewElement.type = "HIDDEN";
	
	if (uobj) document.fMRClinicalPathways_ItemList.dummy.insertAdjacentElement("afterEnd",NewElement);
	if (u1obj) document.fMRClinicalPathways_ItemListAll.dummy.insertAdjacentElement("afterEnd",NewElement);
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
	var u1obj=document.getElementById("Update1");
	if (uobj) eTABLE=document.getElementById("tMRClinicalPathways_ItemList");
	if (u1obj) eTABLE=document.getElementById("tMRClinicalPathways_ItemListAll");
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
	var u1obj=document.getElementById("Update1");
	var missingLoc="";
	
	if (uobj) eTABLE=document.getElementById("tMRClinicalPathways_ItemList");
	if (u1obj) eTABLE=document.getElementById("tMRClinicalPathways_ItemListAll");
	
	if (eTABLE) {
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			if (AddItemObj.checked) {				
				var ItemDataObj=document.getElementById("ItemDataz"+i);
				var CodeObj=document.getElementById("ItemRowidz"+i);
				var setObj=document.getElementById("SETIDz"+i);
				var prObj=document.getElementById("OSParRefz"+i);
				if (prObj) {
					parrefs=parrefs+prObj.value+"^";
				}				
				var type="ARCIM";
				
				if (ItemDataObj) ItemData=ItemDataObj.value;
				if (CodeObj) code=CodeObj.value;
				if (setObj) SETID=setObj.value;

				var descObj=document.getElementById("descz"+i);
				if (descObj) desc=descObj.innerText;

				var sdObj=document.getElementById("SetDefDetailsz"+i);
				if (sdObj) {
					var str=sdObj.value;
					var osdur="";
					var osfreq="";
					var osinstr="";
					var osUOM="";
					var osDoseQty="";
					
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
				
				var delim=getDelim(10);
				var delim2=getDelim(44);
				data=String.fromCharCode(1)+String.fromCharCode(1)+code+String.fromCharCode(1)+SETID+String.fromCharCode(1)+delim+osDoseQty+String.fromCharCode(1)+osUOM+String.fromCharCode(1)+osfreq+String.fromCharCode(1)+String.fromCharCode(1)+osdur+delim2+itmLinked;			
				//String.fromCharCode(1) is an unprintable character.  Shows up as a box. 
					
				var hidItemValue=desc+String.fromCharCode(1)+data;
				//log59415 tedt unescape ItemDataObj.value before concat
				if ((ItemDataObj.value!="") && (ItemDataObj.value!=null)) hidItemValue=desc+String.fromCharCode(1)+unescape(ItemDataObj.value);
				else {
					//log59873 TedT check if rec loc exist
					var locObj=document.getElementById("itemLocz"+i);
					if(locObj && locObj.value!="") 
						missingLoc=missingLoc+"\n"+locObj.value;
				}
				AddInput(hidItemValue);				
			}
		}
		//log59873 TedT if some items are missing rec loc, give warning
		if (missingLoc!="") return t['REC_LOC_MISSING']+missingLoc;
		var parRefsObj=document.getElementById("OSParRefs");
		if (parrefs!="") {
			if (parRefsObj) parRefsObj.value=parrefs;			
		}
	}	
	if (uobj) document.fMRClinicalPathways_ItemList.kCounter.value = hidItemCnt;
	if (u1obj) document.fMRClinicalPathways_ItemListAll.kCounter.value = hidItemCnt;
	return "";
}

function UpdateClickHandler() { //submit all the details and inserts all the orders into the database.

	var PatientID=""; 	var mradm="";
	var obj=document.getElementById("Update");
	if (obj) obj.disabled=true;
	DeleteAllHiddenItems();
	//log59873 TedT stop update if some items are missing rec loc
	var ret=GetOrderData();
	if (ret!="") {
		alert(ret);
		if (obj) obj.disabled=false;
		return false;
	}
	var mObj=document.getElementById("mradm");
	if (mObj) mradm=mObj.value;
	var pobj=document.getElementById("PatientID");
	if (pobj) PatientID=pobj.value;
	return Update_click();  	
}

function ShouldAddItem(ID,desc) { //4

	var match=-1;
	var additem=1;
	var date="";
	var careprov="";
	var time="";
	var testepisno="";
	var DetailedMessage="N";
	var ordertype="";

	var currItemsArray=currItems.split("^");	

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
	if (match >= 0) {  
		if (DetailedMessage=="Y") {
			if ((ordertype=="L") || (ordertype=="N")) {
				additem=confirm(t['MultipleOrder_Desc']+desc+"\n"+t['MultipleOrder_Date']+date+"\n"+t['MultipleOrder_Time']+time+"\n"+t['MultipleOrder_CareProv']+careprov+"\n"+t['MultipleOrder_TestEpisodeNo']+testepisno+"\n"+t['MultipleOrder_WantToAdd']);
			} else {
				additem=confirm(t['MultipleOrder_Desc']+desc+"\n"+t['MultipleOrder_Date']+date+"\n"+t['MultipleOrder_Time']+time+"\n"+t['MultipleOrder_CareProv']+careprov+"\n"+t['MultipleOrder_WantToAdd']);	
			}
		} else {			
			additem=confirm(t['MultipleOrder_Desc']+desc+"\n"+t['MultipleOrder_WantToAdd']);
		}
	}

	return additem;
}

function CheckedSelectedItem(src) { //3
//alert(src);
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

				if ((!ShouldAddItem(SelItemRowid,SelItemDesc)) && (SelItemRowid!="")) {
					obj.checked=false;
				}
			}
		}
	}

}

function CheckMultipleOrders(e) {  //2
	var src=websys_getSrcElement(e);

	CheckedSelectedItem(src);	
}

function BodyLoadHandler() {

	//if (self==top) reSizeT();
	
	document.onclick=OrderDetails;
	
	var uObj=document.getElementById("Update");
	if (uObj) uObj.onclick=UpdateClickHandler;

	var AddAllObj=document.getElementById("AddAll");
	if (AddAllObj)  AddAllObj.onclick=AddAllClickHandler;
	// 63039
	var flag=false;
	eTABLE=document.getElementById("tMRClinicalPathways_ItemList");
	if (eTABLE) {
		for (var i=1; i<eTABLE.rows.length; i++) {
			var TypeObj=document.getElementById("OrdTypez"+i);
			if ((TypeObj)&&((TypeObj.value=="R")||(TypeObj.value=="I"))) { flag=true; }
		}
	}
	if (flag==true) { alert(t['INVALORDTYPE'] + "\n" + t['USEORDENT']); }	
}

document.body.onload = BodyLoadHandler;
var rowsel=0;
