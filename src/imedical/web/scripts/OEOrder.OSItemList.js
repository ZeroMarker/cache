// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var strDefaultData="";
var bContainOrderSet=false;
var Qparam1="";
var Qparam2="";
var Qcheckval="";
var par_win="";

function HiddenQuantityChange_changehandler(encmeth) {
	Qcheckval=cspRunServerMethod(encmeth,Qparam1,Qparam2);
	if(par_win!="")
		par_win.popupWarning(Qcheckval);
}

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

function getDelim(RepeatTimes) {
	var getDelim="";
	if (!RepeatTimes) RepeatTimes=30;
	for (var k=1; k<RepeatTimes; k++) {
		getDelim=getDelim+String.fromCharCode(1);
	}
	return getDelim;
}
function SelectAllClickHandler(){
	var eTABLE=document.getElementById("tOEOrder_OSItemList");
	if (eTABLE){
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			var descObj=document.getElementById("desc"+i);
			if ((AddItemObj)&&(AddItemObj.disabled!=true)) AddItemObj.checked=true;
		}
	}
}
function AddClickHandler() {
	bContainOrderSet=false;
	var NeedToCallUpdateOnAddClick=false;
	var NewQuantitys="";
	var OrderSetGroupNumber="";
	par_win = window.opener;
	var DelItems = "";
	//Log 49059 PeterC 17/02/05: Below code fails because par_win is hidden frame, need to set it to the OE screen
	if(par_win.name!="oeorder_entry") {
		par_win=window.open("","oeorder_entry");
	}
	//var f = document.forms[0];
	var eTABLE=document.getElementById("tOEOrder_OSItemList");
	//var osid=#(%request.Get("ORDERSETID"))#
	//alert("osid="+osid);
	//var lstOrders=window.opener.document.getElementById("cOrders");
	//var list=lstOrders;
	//alert("lstOrders="+lstOrders);
	//alert(document.getElementById("HiddenDelete").value)
	if ((par_win) && (document.getElementById("HiddenDelete").value=="YES")) {
		//par_win.DeleteClickHandler();
		var setObj=document.getElementById("SETIDz1");
		if (setObj && setObj.value!="") OrderSetGroupNumber=par_win.DeleteOrderSetClickHandler(setObj.value);
	}
	var SetRef=0;
	var OrdRowIdString="";
	var OrdRowIdobj=document.getElementById("OSOrderRowIDs");
	if (OrdRowIdobj) OrdRowIdString=OrdRowIdobj.value;

	//rebuilding (OrdRowIdString) string without invisible items so everything is in alignment for insert and delete
	//JPD LOG 56223
	var TempOrdRowIdArr=OrdRowIdString.split("^");
	OrdRowIdString="";
	//SB 06/02/06 (58192): If Temp array is blank then don't loop through array. Should only be
	// blank on auto pop up when category of complaint is entered on triage.
	if (TempOrdRowIdArr!="") {
		for (var i=1; i<eTABLE.rows.length; i++) {
			var CodeObj=document.getElementById("ItemRowidz"+i);
			var code=CodeObj.value;
			var tempID="";
			var j=0;
			for(j=0;j<TempOrdRowIdArr.length;j++) {
				if(TempOrdRowIdArr[j]==null) continue;
				var OrdRowOrdID=TempOrdRowIdArr[j].split("*");
				tempID=OrdRowOrdID[0];
				if(code==tempID) break;
			}
			if (code==tempID) {
				OrdRowIdString=OrdRowIdString+TempOrdRowIdArr[j]+"^";
				TempOrdRowIdArr[j]=null;
			}
		}
	}
	//end log 56223

	for (var i=1; i<eTABLE.rows.length; i++) {
		var AddItemObj=document.getElementById("AddItemz"+i);
		if (AddItemObj.checked) {
			var OrdQty="";
			var OrdTypeCodeObj=document.getElementById("OrderTypeCodez"+i);
			var ItemDataObj=document.getElementById("ItemDataz"+i);
			var CodeObj=document.getElementById("ItemRowidz"+i);
			var setObj=document.getElementById("SETIDz"+i);
			//Log 42773 PeterC 09/03/04: Modified the below line as desc is not in fixed column position.
			//var desc=eTABLE.rows[i].cells[0].innerText;
			var desc="";
			var descobj=document.getElementById("ARCIMDescz"+i);
			if((descobj)&&(descobj.value!="")) desc=descobj.value;
			var dfdurObj=document.getElementById("defdurz"+i);
			var qtyObj=document.getElementById("Quantityz"+i);
			if (qtyObj) NewQuantitys=NewQuantitys+qtyObj.value+"^";
			if (qtyObj) OrdQty=qtyObj.value;
			var subcatobj=document.getElementById("itmSubCatidz"+i);
			var subcatid="";
			if (subcatobj) subcatid=subcatobj.value;
			var match="notfound";
			var defdur="";
			if (dfdurObj) defdur=dfdurObj.value;
			var itmCatid="";
			var itmCatObj=document.getElementById("itmCatidz"+rowsel);
			if (itmCatObj) itmCatid=itmCatObj.value;
			//desc=desc.substring(10,desc.length);
			desc=desc.substring(0,desc.length);
			//desc=desc.substring(1,desc.length);
			var type="ARCIM";
			var SETID="";
			var code="";
			var data="";
			var OrderTypeCode="";
			if (OrdTypeCodeObj) OrderTypeCode=OrdTypeCodeObj.value;
			if (ItemDataObj) data=ItemDataObj.value;
			if (CodeObj) code=CodeObj.value;
			if (setObj) SETID=setObj.value;
			var SetRef=i;
			//var delim=getDelim();
			var delim7=getDelim(7);
			var delim24=getDelim(24);
			//if (data=="") data=String.fromCharCode(1)+String.fromCharCode(1)+code+String.fromCharCode(1)+SETID+String.fromCharCode(1)+"NODETAILS"+delim+OrderTypeCode+delim+SetRef;
			//if (data=="") data=String.fromCharCode(1)+String.fromCharCode(1)+code+String.fromCharCode(1)+String.fromCharCode(1)+"NODETAILS"+delim+OrderTypeCode;
			if (data=="") data=String.fromCharCode(1)+String.fromCharCode(1)+code+String.fromCharCode(1)+String.fromCharCode(1)+"NODETAILS"+delim7+OrdQty+delim24+OrderTypeCode;
			//alert("data = "+mPiece(data,String.fromCharCode(1),33));
			//if (descobj) dumpObject(eTABLE); //desc=obj.rows[1].cells[3].innerText;
			//alert(eTABLE.rows[1].cells[0].innerText);
			//alert("selected desc = "+desc);
			//alert("selected data = "+data);

			if (par_win){
				//alert(code + "*****" + desc);
				//var doAdd=1;
				//doAdd=par_win.ShouldAddItem(code,desc);
				//Log 49059 PeterC 15/02/05: Added the variable "HasAutoPopUp" to pass to AddItemToList to indicate that detail page has already opened.
				var HasAutoPopUp="";
				if ((SETID=="")||(OrdRowIdString=="")) {
					if((data!="")&&(mPiece(data,String.fromCharCode(1),4)!="NODETAILS")) HasAutoPopUp=1;
					par_win.AddItemToList("",code,desc,OrderTypeCode,type,"",data,"",itmCatid,defdur,SetRef,"",subcatid,"",1,HasAutoPopUp);
					//par_win.UpdateOnAddClick();
					NeedToCallUpdateOnAddClick=true;
				} else {
					//if (doAdd) par_win.AddItemToList("",code,desc,"",type,"",data,SETID,"","",SetRef);
					//Log 49182 PeterC 04/07/05
					var ReqSubs="N";
					var REQSubObj=document.getElementById("ReqDrgSubsz"+i);
					if((REQSubObj)&&(REQSubObj.value!="")) {
						par_win.ShowDrgSubs(REQSubObj.value);
						ReqSubs="Y";
						var OrdRowId="";
						if (OrdRowIdString!="") {
							var OrdRowIdArr=OrdRowIdString.split("^");
							if (OrdRowIdArr[i-1-disabledCnt]) OrdRowId=OrdRowIdArr[i-1-disabledCnt]+"^";
						}
						if (OrdRowId!="") par_win.cDeletedOrderItemIDs=par_win.cDeletedOrderItemIDs+OrdRowId;
						var OrdRowOrdID=OrdRowId.split("*");
						var DelItems=DelItems+OrdRowOrdID[1]+"^"
					}
					bContainOrderSet=true;
					var disabledCnt=0;
					for (var b6=1; b6<=i; b6++) {
						var DFobj=document.getElementById("DISABLEDz"+b6);
						//Log 65750 PeterC 03/12/07: Added the SLObj.disabled condition.
						var SLObj=document.getElementById("AddItemz"+b6);
						if (DFobj && DFobj.value=="T") disabledCnt++;
						else if((SLObj)&&(SLObj.disabled)) {
							disabledCnt++;
						}
					}
					var OrdRowId="";
					if (OrdRowIdString!="") {
						var OrdRowIdArr=OrdRowIdString.split("^");
						if (OrdRowIdArr[i-1-disabledCnt]) OrdRowId=OrdRowIdArr[i-1-disabledCnt]+"^";
					}
					//alert("data:"+data+","+desc+","+OrdRowId+","+SETID);
					if (OrderSetGroupNumber!="") desc=desc+"(("+OrderSetGroupNumber+"))";
					if (ReqSubs=="N") par_win.AddIndividualItemInOrderSetToList("",code,desc,"",type,"",data,SETID,"","",SetRef,"",subcatid,OrdRowId);

				}
			}
			//if (par_win) par_win.AgeSexRestrictionCheck(code,desc,OrderTypeCode,defdur,match);
		} else {
			var DFobj=document.getElementById("DISABLEDz"+i);
			if ((DFobj) && (DFobj.value!="T") && (par_win)) {
				var disabledCnt=0;
				for (var b6=1; b6<=i; b6++) {
					var DFobj=document.getElementById("DISABLEDz"+b6);
					//Log 65750 PeterC 03/12/07: Added the SLObj.disabled condition.
					var SLObj=document.getElementById("AddItemz"+b6);
					if (DFobj && DFobj.value=="T") disabledCnt++;
					else if((SLObj)&&(SLObj.disabled)) {
						disabledCnt++;
					}
				}
				var OrdRowId="";
				if (OrdRowIdString!="") {
					var OrdRowIdArr=OrdRowIdString.split("^");
					//if (OrdRowIdArr[i-1]) OrdRowId=mPiece(OrdRowIdArr[i-1],"*",1);
					if (OrdRowIdArr[i-1-disabledCnt]) OrdRowId=OrdRowIdArr[i-1-disabledCnt]+"^";
				}
				//alert(i+","+disabledCnt+" in delete OrdRowId="+OrdRowId);
				if (OrdRowId!="") par_win.cDeletedOrderItemIDs=par_win.cDeletedOrderItemIDs+OrdRowId;
				//JPD Log 50899
				var OrdRowOrdID=OrdRowId.split("*");
				var DelItems=DelItems+OrdRowOrdID[1]+"^"
				//alert(DelItems);
				//var qtyObj=document.getElementById("Quantityz"+i);
				//if (qtyObj) NewQuantitys=NewQuantitys+qtyObj.value+"^";
				//TedT, if item not checked, set the qty to -1, it will be handled specially in broker
				NewQuantitys=NewQuantitys+"-1^";
			}
		}
	}
	if (NeedToCallUpdateOnAddClick==true) par_win.UpdateOnAddClick();
	else {
		if ((par_win)&&(par_win.OrderDetailsOpenCount>0)&&(bContainOrderSet)) par_win.OrderDetailsOpenCount--;
		var quantitysobj=document.getElementById("OSOrderQuantitys");
		//alert("NewQuantitys="+NewQuantitys);
		//alert("OSOrderQuantitys="+OrdRowIdString+"NewQuantitys="+NewQuantitys);
		if ((quantitysobj)&&(quantitysobj.value!=NewQuantitys))	{
			Qparam1=OrdRowIdString;
			Qparam2=NewQuantitys;
			var hqobj=document.getElementById('HiddenQuantityChange');
			if (hqobj) hqobj.onclick=hqobj.onchange;
			if (hqobj) {
				hqobj.click();
			}
		}
	}
	//window.close();
	//JPD Log 50899
	//alert("DelItems:"+DelItems);
	if(DelItems!=""){
		//log 61314 TedT if sessionlist exist, delete the unchecked orders
		if(par_win && par_win.parent.orderlist) {
			par_win.parent.orderlist.DeleteOrder(DelItems);
		}
		var path="oeorder.deleteositems.csp?DelItems="+DelItems;
		window.setTimeout("websys_createWindow('"+path+"','TRAK_hidden');",3000);
	}
	window.setTimeout("Add_click();",3000);
	//websys_createWindow(path,"TRAK_hidden");
	//Add_click();
}

function KeepPriority() {
	var obj=document.getElementById("OECFKeepPriorDateSession");
	if (obj) {
		if (obj.value=="Y") {
			return true;
		} else {
			return false;
		}
	}
	return false
}
/*
function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    var delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}
*/
function CollectedFields(DataFields){
	var obj=document.getElementById("ItemDataz"+rowsel)
	if (obj) {
		obj.value=DataFields;
		//alert("objvalue="+obj.value);
	}

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
function BodyLoadHandler() {
	//if (self==top) websys_reSizeT();
	//if (self==top) reSizeT();
	//alert("doc");
	//document.getElementById("AddItemz").onclick = displayDetails();
	//websys_firstfocus();
	var DisabledItemsCount=0;
	var Deselect="";
	var ConfigUnselObj=document.getElementById("OECFDefaultCheckBsUnselect")
	if (ConfigUnselObj) Deselect=ConfigUnselObj.value;
	var OSOrdObj=document.getElementById("OSOrderRowIDs");
	var OSOrderRowIDs=OSOrdObj.value;
	var OSItmtbl=document.getElementById("tOEOrder_OSItemList");
	// rebuilding (OSOrderRowIDs) string without invisible items so desc is in alignment with corresponding hidden ID's
	// below loop assigning OEORIRowID to desc link was mismatching ID's when hidden items appear in parent set.
	// JPD LOG 56447
	var TempOrdRowIdArr=OSOrderRowIDs.split("^");
	OSOrderRowIDs="";
	var j=0;
	for (var i=1; i<OSItmtbl.rows.length; i++) {
		var CodeObj=document.getElementById("ItemRowidz"+i);
		var code=CodeObj.value;
		var tempID="";
		do {
			if (TempOrdRowIdArr[j]) {
				var OrdRowOrdID=TempOrdRowIdArr[j].split("*");
				tempID=OrdRowOrdID[0]
				j++;
			}
		} while (code!=tempID && TempOrdRowIdArr[j])
		if (code==tempID) {
			OSOrderRowIDs=OSOrderRowIDs+TempOrdRowIdArr[j-1]+"^";
		}
	}
	var ReStrObj=document.getElementById("RebuiltString");
	if (ReStrObj) ReStrObj.value=OSOrderRowIDs;

	var OSAry="";
	if ((OSOrdObj)&&(OSOrdObj.value!="")) OSAry=OSOrderRowIDs.split("^");

	self.focus();
	document.onclick=OrderDetails;
	document.getElementById("Add").onclick = AddClickHandler;

	// JPD added try/catch as 'LabOrderWithoutExternalCode' undefined on multiple page orderset
	try {
		if (OSItmtbl){
			LabOrderWithoutExternalCode
			//alert(OSItmtbl.rows.length);
			for (var c=1; c<=OSItmtbl.rows.length-1; c++) {
				var DFobj=OSItmtbl.document.getElementById("DISABLEDz"+c);
				var SCobj=OSItmtbl.document.getElementById("AddItemz"+c);
				var ItmRowobj=OSItmtbl.document.getElementById("ItemRowidz"+c);
				var DescObj=OSItmtbl.document.getElementById("descz"+c);
				//log60520 TedT if item has no stock, disable the input fields
				var stock=document.getElementById("StockAvailablez"+c);
				var ava=document.getElementById("availablez"+c);
				if(stock) stock.onclick=returnFalse;
				if (ItmRowobj&&SCobj) {
					if (LabOrderWithoutExternalCode.split(ItmRowobj.value).length>1) SCobj.disabled=true;
				}
				if (SCobj && ((DFobj&&(DFobj.value=="T"))||(ava && (ava.value!="") && (ava.value!=1)))) {
					SCobj.disabled=true;
					// 61894
					if (DescObj) {
						DescObj.onclick=LinkDisable;
						DescObj.disabled=true;
					}
					DisabledItemsCount=DisabledItemsCount+1;
				}
				//log61100 TedT
				var episode=document.getElementById("EpisodeID");
				if(episode) episode=episode.value;
				//Log 42321 PeterC 18/02/04
				if((DescObj)&&(OSAry[c-1-DisabledItemsCount])) {
					DescObj.href=DescObj.href+"&ID="+mPiece(OSAry[c-1-DisabledItemsCount],"*",1)+"&EpisodeID="+episode+"&itemdata=MustBeTheLastLinkExpression"
				}
				else if (DescObj) {
					DescObj.href=DescObj.href+"&ID="+"&EpisodeID="+episode+"&itemdata=MustBeTheLastLinkExpression"
				}
			}
		}
	} catch(e) {}
	if (Deselect!="Y") SelectAllClickHandler();
	var idsobj=document.getElementById("OSOrderRowIDs");
	if ((idsobj)&&(idsobj.value=="")) {
		var win=window.open('','oeorder_entry');
		var cusids=win.document.getElementById("NewOrders");
		if (cusids) idsobj.value=cusids.value
	}

	var quantitysobj=document.getElementById("OSOrderQuantitys");
	if ((idsobj)&&(quantitysobj)) {
		var OrdRowIdString=idsobj.value;
		var OrdQuantityString=quantitysobj.value;
		var OrdRowIdArr=OrdRowIdString.split("^");
		var OrdQuantityArr=OrdQuantityString.split("^");
		var eTABLE=document.getElementById("tOEOrder_OSItemList");
		for (var i=1; i<eTABLE.rows.length; i++) {
			var CodeObj=document.getElementById("ItemRowidz"+i);
			var QuantityObj=document.getElementById("Quantityz"+i);
			var AddItemObj=document.getElementById("AddItemz"+i);
			if ((AddItemObj)&&(AddItemObj.disabled)&&(QuantityObj)) {
				QuantityObj.value="";
				QuantityObj.disabled=true;
			}
			else if ((CodeObj)&&(QuantityObj)) {
				var CodeId=CodeObj.value;
				for (var j=0; j<OrdRowIdArr.length; j++) {
					if (OrdRowIdArr[j] && mPiece(OrdRowIdArr[j],"*",0)==CodeId) {
						//log60059 TedT
						OrdRowIdArr[j]=null;
						if (OrdQuantityArr[j]!="") QuantityObj.value=OrdQuantityArr[j];
						break;
					}
				}
			}
		}
	}
	//63649 BoC 28-05-2007: force window to focus when focus is lost
	//window.focus();
	var HasSessList=document.getElementById("HasSessionList");
	if((HasSessList)&&(HasSessList.value==1)) window.onblur=windowfocus;

}

function windowfocus() {
	window.focus();
}

function BodyUnLoadHandler() {
	//If there is any mandatory field left unfilled, alert the user and delete the order item from the list.
	var par_win = window.opener;
	if (par_win.name=="TRAK_hidden") par_win=window.open('',OrderWindow); //par_win=par_win.top.frames[1];
	//Go to the details page of the next order item
	if ((par_win)&&(par_win.document.fOEOrder_Custom)&&(bContainOrderSet)) par_win.OrderDetailsShowing(par_win.document.fOEOrder_Custom);

}
function OrderDetailsOpen(sItemDesc,sitemdata,sitemvalue,sOSRowid,sOrderTypeCode) {
		//var url = "oeorder.mainloop.csp?ARCIMDesc="+sItemDesc+"&EpisodeID="+document.forms['fOEOrder_Custom'].EpisodeID.value+"&itemdata="+sitemdata+"&OEORIItmMastDR="+sitemvalue+"&ORDERSETID="+sOSRowid+"&OrderTypeCode"+sOrderTypeCode;
		//Loads default values - if default carry to every item - log 22982
		var PatientID="";
		var pobj=document.getElementById("PatientID");
		if(pobj)
			PatientID=pobj.value;

		if (sitemdata=="") sitemdata=strDefaultData;
		var EpisodeID="";
		var eobj=document.getElementById("EpisodeID");
		if (eobj) EpisodeID=eobj.value;

		//sitemdata=escape(sitemdata);
		var url = "oeorder.mainloop.csp?ARCIMDesc="+sItemDesc+"&EpisodeID="+EpisodeID+"&itemdata="+sitemdata+"&OEORIItmMastDR="+sitemvalue+"&ORDERSETID="+sOSRowid+"&OrderTypeCode="+sOrderTypeCode+"&PatientID="+PatientID;
		//alert("url="+url);
		//websys_lu(url,false,"width=600,height=500,top=10");
		//window.open(url,"details");
		websys_lu(url,false);
}
function DisplayMessages(desc) {
	//display Order Entry Message against ItemMast
	//desc=desc.substring(5,desc.length);
	var mesObj=document.getElementById("OEMessagez"+rowsel);
	if (mesObj) {
		mes=mesObj.value;

		var smes=mes.split("|");
		mes=smes.join("\n");

		//Please DO NOT comment this alert line out, it's not part of debugging.
		if (mes!="") alert("ORDER ENTRY MESSAGE:"+desc+String.fromCharCode(10)+mes);
	}

	//display quantity ranges against ItemMast
	var rFromObj=document.getElementById("RangeFromz"+rowsel);
	if (rFromObj) RangeFrom=rFromObj.value;
	var rToObj=document.getElementById("RangeToz"+rowsel);
	if (rToObj) RangeTo=rToObj.value;
	var uObj=document.getElementById("UOMz"+rowsel);
	if (uObj) UOM=uObj.value;
	if ((RangeFrom!=null) || (RangeTo!=null)) {
		if ((RangeFrom!="") || (RangeTo!="")) {
			alert("WARNING:  The quantity for this order item is out of range."+String.fromCharCode(10)+"The set quantity range is between "+RangeFrom+" to "+RangeTo+" "+UOM);
		}
	}
}
function getCheckedValue(val) {
//	alert(val);
}
function OpenCheckedItem(src) {

	var par_win = window.opener;
	//Log 49059 PeterC 17/02/05: Below code fails becasue par_win is hidden frame, need to set it to the OE screen
	if(par_win.name!="oeorder_entry") {
		par_win=window.open("","oeorder_entry");
	}
	//document.tOEOrder_OSItemList.target
	if (src.id.substring(0,8)=="AddItemz")	{
		var arry=src.id.split("z");
		rowsel=arry[arry.length-1];
		var obj=document.getElementById("AddItemz"+rowsel);

		if (obj) {
			if (obj.checked) {
				var eTABLE=document.getElementById("tOEOrder_OSItemList");
				var desc=eTABLE.rows[rowsel].cells[0].innerText;
				desc.substring(5,desc.length);
				var itemRowidObj=document.getElementById("ItemRowidz"+rowsel);
				if (itemRowidObj) itemid=itemRowidObj.value;

				var durObj=document.getElementById("defdurz"+rowsel);
				if (durObj) dur=durObj.value;

				var allergy="";
				var allergyObj=document.getElementById("allergyz"+rowsel);
				if (allergyObj) allergy=allergyObj.value;
				if (allergy=="1")
				{
					var desc="";
					var descObj=document.getElementById("ARCIMDescz"+rowsel);
					if (descObj) desc=descObj.value;
					var choice=confirm("Allergy: "+desc);
					if(choice==false)
					{
						obj.checked=false;
						return;
					}
				}

				if (itemRowidObj) itemid=itemRowidObj.value;
				//Log 49059 PeterC 22/03/05 Commented out the below line to avoid dubling up of OE message
				//DisplayMessages(desc);
				par_win.DrugInteractionCheck(itemid,desc,dur,"OS");
				var itmCatObj=document.getElementById("itmCatidz"+rowsel);
 				var itmSubCatObj=document.getElementById("itmSubCatidz"+rowsel);
				var itmCatid,itmSubCatid="";
 				//alert("clicking away outside itmcat obj = " + itmCatObj);
 				//var match="notfound";
				if ((itmCatObj)||(itmSubCatObj)) {
					if (itmCatObj)itmCatid=itmCatObj.value;
					if (itmSubCatObj)itmSubCatid=itmSubCatObj.value;
					//alert("itmCatid"+itmCatid);
					//Log 49059 PeterC 22/03/05 Added "itemid" to the below line
					if (par_win.matchCategory(ItemCat,itmCatid,itmSubCatid,itemid)) {
						match="found";
						var par_win = window.opener;
						//Log 49059 PeterC 17/02/05: Below code fails becasue par_win is hidden frame, need to set it to the OE screen
						if(par_win.name!="oeorder_entry") {
							par_win=window.open("","oeorder_entry");
						}

						var setidObj=document.getElementById("SETIDz"+rowsel);
						if (setidObj) setid=setidObj.value;
						var idataObj=document.getElementById("ItemDataz"+rowsel);
						if (idataObj) idata=idataObj.value;
						var iOTCodeObj=document.getElementById("OrderTypeCodez"+rowsel);
						if (iOTCodeObj) iOrderTypeCode=iOTCodeObj.value;
						// change to launch new window from component link setup.
						// JPD 56447
						var OELink=document.getElementById("descz"+rowsel);
						if (OELink) OELink.click();
						//OrderDetailsOpen(desc,idata,itemid,setid,iOrderTypeCode);
					}
				}
				//if (par_win) par_win.AgeSexRestrictionCheck(itemid,desc,iOrderTypeCode,dur,match,obj);
				//alert(obj.checked);
				//alert("clicking");

			}
		}
	}

}

function SetDefaultData(sDefaultData) {
	strDefaultData=sDefaultData;
	//alert(strDefaultData);
}

function OrderDetails(e){
	//var obj=document.getElementById("AddItemz1");
	//alert(obj.checked);
	var src=websys_getSrcElement(e);
	//alert("details");
	OpenCheckedItem(src);
	//alert(src.tagName);
	if (src.tagName != "A") return;
	//Gets the selected row
	var arry=src.id.split("z");
	rowsel=arry[arry.length-1];
	var DataField=document.getElementById("ItemDataz"+rowsel);
	var LinkField=document.getElementById("descz"+rowsel);
	if (src.id.substring(0,5)!="descz") return;
	//Adds ItemData to link expression
	// if link disabled - do not launch! 61894
	if (DataField && (LinkField && LinkField.disabled==false)) {
		//Replaces ItemData with DefaultData - log 22982
		if (DataField.value=="") {
			LinkField.href = LinkField.href.substring(0,LinkField.href.lastIndexOf("&")) + "&itemdata=" + strDefaultData;
			websys_lu(LinkField.href,false,"width=600,height=500,top=10");
			return false;
		} else {
			LinkField.href = LinkField.href.substring(0,LinkField.href.lastIndexOf("&")) + "&itemdata=" + DataField.value;
			websys_lu(LinkField.href,false,"width=600,height=500,top=10");
			return false;
		}
	}
}

function returnFalse(){
	return false;
}

var rowsel=0;
var iOrderTypeCode;
document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
var SelAllObj=document.getElementById("SelectAll");
if (SelAllObj) SelAllObj.onclick=SelectAllClickHandler;
var ItemCat=""; var obj=document.getElementById("GroupItmCat"); if (obj) ItemCat=obj.value;
var SetCat=""; var obj=document.getElementById("GroupSetCat"); if (obj) SetCat=obj.value;
