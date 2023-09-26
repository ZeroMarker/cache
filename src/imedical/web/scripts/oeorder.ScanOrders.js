// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var objBarcode=document.getElementById("Barcode");
var objBarcodeList=document.getElementById("BarcodeList");
var objDisplayAlerts=document.getElementById("DisplayAlerts");
var objHiddenBarcode=document.getElementById("hiddenBarcode");
var objAdd=document.getElementById("Add");
var objHiddenAdd=document.getElementById("hiddenAdd");
var objClear=document.getElementById("Clear");
var objDelete=document.getElementById("Delete");
var BParam="";
var hidItemCnt=0;

function hiddenBarcode_changehandler(encmeth) {
	var AQuoteStr="";
	AQuoteStr=cspRunServerMethod(encmeth,BParam);
	if (AQuoteStr!="") BarcodeAdd(AQuoteStr);
}
function BodyLoadHandler() {
	if (objAdd) objAdd.onclick=AddClickHandler;
	if (objBarcode) objBarcode.onchange=AddOrderschangehandler;
	if (objClear) objClear.onclick=ClearClickHandler;
	if (objDelete) objDelete.onclick=DeleteClickHandler;
}

function ClearClickHandler() {
	if (objBarcodeList) {
		var length = objBarcodeList.length;
		for (var i=0; i<length; i++) {
			objBarcodeList.options[i]=null;
		}
	}
	if (objBarcode) objBarcode.value="";
	if (objBarcode) websys_setfocus('Barcode');
}

function DeleteClickHandler() {
	if (objBarcodeList) {
		var length = objBarcodeList.length;
		for (var i=length; i>0; i--) {
			if (objBarcodeList.options[i-1].selected) objBarcodeList.options[i-1]=null;
		}
	}
	if (objBarcode) websys_setfocus('Barcode');
}

function DeleteAllHiddenItems() {
	var id="";
	var objhid="";
	
	for (i=1; i<=hidItemCnt; i++) {
		id="hiddenitem"+hidItemCnt;
		objhid=document.getElementById(id);
		if (objhid) objhid.outerText='';
	}
	hidItemCnt=0;
}
function GetOrderDataOnAdd() {
	var selList = objBarcodeList;
	var length = selList.length;
	var freqItems="";
	var DataFound=false;
	var idData="";
	var listData="";
	var ORIRowId="";
	var listItem="";
	var listValue="";
	var listIType="";
	var arrData="";
	var fields="";
	var hidItemValue="";
	
	for (var i=0; i<length; i++) {
		ORIRowId="";
		listItem = mPiece(selList.options[i].text,"((",0);
		//var freq = selList.options[i].id;
		listData = selList.options[i].idata;
		listValue = selList.options[i].value;
		idData = selList.options[i].id;
		listIType=selList.options[i].itype;
		if (listIType!="" && listIType!=null) {
			if (listData!="" && listData!=null) {
				//Find if using default values - log 22982
				arrData=listData.split(String.fromCharCode(1));
				hidItemValue=listItem+String.fromCharCode(1)+listData;
				AddInputCust(selList,i,hidItemValue);
				DataFound=true;
			}
			if (DataFound==false) {
				AddInputCust(selList,i,listItem+String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1)+listValue);
			}
		}
		DataFound=false;
	}
	
	document.foeorder_ScanOrders.kCounter.value = hidItemCnt;
}
function AddInputCust(selList,i,value) {
	// This is called to add hidden items when the item is added into the list box.
	// These items are accessed in ##Clas(web.OEOrdItem).InsertItems(X,X).
	var ORIRowId="";
	if (selList) ORIRowId=selList.options[i].ORIRowId;
	hidItemCnt++;
	var NewElement=document.createElement("INPUT");
	NewElement.id = 'hiddenitem' + hidItemCnt;
	NewElement.name = 'hiddenitem' + hidItemCnt;
	NewElement.value = value;
	NewElement.type = "HIDDEN";
	document.foeorder_ScanOrders.dummy.insertAdjacentElement("afterEnd",NewElement);
}

function AddClickHandler() {

	DeleteAllHiddenItems();
	GetOrderDataOnAdd();
	var patobj=document.getElementById("PatientID");
	if (patobj) Patient=patobj.value;
	var epobj=document.getElementById("EpisodeID");
	if (epobj) EpisodeID=epobj.value;
	
	var SelectedOrders="";
	for (i=0;i<objBarcodeList.length;i++) {
		if (!objBarcodeList.options[i].selected) {
			SelectedOrders=SelectedOrders+objBarcodeList.options[i].itype.split(String.fromCharCode(4))[0]+"*"+objBarcodeList.options[i].value+"^";
		}
	} 
	//BM Log 45069, 46403 Fix the problem that url is too long
 	var newwin=window.open("","TRAK_hidden");
	var doc = newwin.document;
 	doc.open("text/html");
 	doc.write("<html><head></head><body>\n");
 	doc.writeln('<form name="OrderEntry" id="OrderEntry" method="POST" action="oeorder.updateorders.csp">');
 	doc.writeln('<input name="PatientID" value="'+Patient+'">');
 	doc.writeln('<input name="EpisodeID" value="'+EpisodeID+'">');
 	doc.writeln('<input name="SelectedOrders" value="'+SelectedOrders+'">');
 	doc.writeln('<input name="kCounter" value="'+hidItemCnt+'">');
	var HIobj=""; 
	//SP//
	//SP//var tempval="Adalat%20Oros%20Tablets%2030%20mg%20%3B%20%5B30%5D%2C2959%2C1%2C1%20Tablets%01%01%017144%7C%7C1%01%01%01%01%01%01%01%01%01%01%01%01%01%01%01%01%01%01%01%01%01%01%01%01%01%01Miss%20DemoFN%20DemoSN";
 	//SP//for (i=1; i<=400; i++) {
	var tempval="";
 	for (i=1; i<=hidItemCnt; i++) {
  		HIobj=document.getElementById("hiddenitem"+i);
  		if (HIobj) {
   		// Log 43091 removed the '&' char from HIobj
   		tempval=HIobj.value;
   		tempval=escape(tempval.replace("&",""));
		doc.writeln('<input name="hiddenitem'+i+'" value="'+tempval+'">');
  		}
 	}
	doc.writeln('<input name="OrderWindow" value="'+window.name+'">');
 	doc.writeln("<INPUT TYPE=SUBMIT>");
 	doc.writeln("</form>");

 	doc.writeln("</body></html>");
 	doc.close();

	var frm=doc.getElementById('OrderEntry');
	if (frm) frm.submit();

	if (objAdd) {
		objAdd.disabled=true;
		objAdd.onclick="";
	}
	

}

function PopUpQuesSumm(WorkFlowID,ReceivedDateTime,CollectDateTime,NewOrderString,EpisString,DisplayQuestionFlag,OEMessageFlag,AllergyFlag,AllergyItems,PathwayDR,OrderItemsID,NewOrders,ORIRowIDs,InteractFlag,DrugIntString,LabFlag,HasAction,AfterAction,BeforeAction,ActionItemString,NewLabEpisodeNumber,NewLabOrders,NewLabSpecs,NewLabColDate,NewLabColTime,NewLabRecDate,NewLabRecTime,SilentMode,OrderSetID,AgeSexFlag,AgeSexString,AgeSexItem,DosageRange,SubCat,Cat,DupMsg,HasDSSMsg,gotOEMsg,ordSetID,PatientID,WARNING,MaxCumDoseFlag,CreateNewTeethFlag) {
	//alert(WARNING);
	cNewOrders=NewOrders;
	//alert("NewOrders:"+NewOrders);
	var NewOrderCount=NewOrders.split("^").length-1;
	var objNewOrders=document.getElementById("NewOrders");
	if (objNewOrders) objNewOrders.value=objNewOrders.value+NewOrders;
	var DisplayAlert=0;
	
	WARNING=unescape(WARNING);
	var WarningMsg="";
	var OrdRowIDExternalCodeNotExist="^";
	var NonDentalOrder="";
	var WarnMsg="";
	var WarnDetail="";
	var WarnDesc="";
	var WarnItmMastID="";
	var OEORIobj="";
	var NewOrderRowIds="";
	var NewOrderArr="";
	var del="";
	var newNewOrderRowIds="";
	StockInOtherLoc="";
	var DelStockInOtherLoc="";
	var DelOrdRowId="";
	var DefaultRecLoc="";
	for (var i=0;i<WARNING.split("^").length-1;i++) {
		WarnMsg=mPiece(WARNING,"^",i);
		if (WarnMsg!="") {
			if (mPiece(WarnMsg,String.fromCharCode(2),0)!=WarnMsg) {
				DefaultRecLoc=mPiece(WarnMsg,String.fromCharCode(2),4);
				WarnDetail=mPiece(WarnMsg,String.fromCharCode(2),1);
				WarnItmMastID=mPiece(WarnMsg,String.fromCharCode(2),2);
				WarnDesc=mPiece(WarnMsg,String.fromCharCode(2),3);
				WarnMsg=mPiece(WarnMsg,String.fromCharCode(2),0);
				if (WarnMsg=="ExternalCodeNotExist") {
					OrdRowIDExternalCodeNotExist=OrdRowIDExternalCodeNotExist+WarnDetail+"^";
					for (var j6=objBarcodeList.length;j6>0;j6--) {
						if (objBarcodeList.options[j6-1].ORIRowId.split(WarnDetail).length>1) {
							if (objBarcodeList.options[j6-1].ORIRowId.split("^").length==1) objBarcodeList.options[j6-1]=null;	
						}
					}
					OEORIobj=document.getElementById("OEOrdItemIDs");
					if (OEORIobj) {
						NewOrderRowIds=OEORIobj.value;
						
						NewOrderArr=NewOrderRowIds.split("^");
						del=-1;
						for (var b5=0;b5<NewOrderArr.length;b5++) {
							if (mPiece(NewOrderArr[b5],"*",1)==WarnDetail) {
								del=b5;
								break;
							}
						}
						if (del>-1) {
							newNewOrderRowIds="";
							for (var b5=0;b5<NewOrderArr.length;b5++) {
								if (b5!=del) {
									if (newNewOrderRowIds!="") newNewOrderRowIds=newNewOrderRowIds+"^";
									newNewOrderRowIds=newNewOrderRowIds+NewOrderArr[b5];
								}
							}
							OEORIobj.value=newNewOrderRowIds;
						}
					}
					WarnDetail="";
					if (WarningMsg=="") WarningMsg=t[WarnMsg]+": "+WarnDesc;
					else WarningMsg=WarningMsg+", "+WarnDesc;
					LabOrderWithoutExternalCode=LabOrderWithoutExternalCode+WarnItmMastID+"^";
				}
				else if (WarnMsg=="INVALID_TOOTH_AREA") {
					for (var j6=objBarcodeList.length;j6>0;j6--) {
						objBarcodeList.options[j6-1]=null;	
					}
					OEORIobj=document.getElementById("OEOrdItemIDs");
					if (OEORIobj) OEORIobj.value="";
					alert(t[WarnMsg]);
					return false;
				}
				else if (WarnMsg=="DENTAL_ORDER_ONLY") {
					for (var j6=objBarcodeList.length;j6>0;j6--) {
						if (objBarcodeList.options[j6-1].itype.split(WarnItmMastID).length>1) {
							objBarcodeList.options[j6-1]=null;	
							NonDentalOrder=NonDentalOrder+WarnItmMastID+"^";
							alert(t[WarnMsg]+"\n"+WarnDesc);
						}
					}
				}
				else if (WarnMsg=="STOCK_IN_OTHER_LOC") {
					//WarnDetail is the receiving location id that has stock
					//WarnItmMastID is the order ARCIM ID
					//WarnDesc is the desc of the order item
					//DefaultRecLoc is the desc of the default receiving location
					if (!DefaultRecLoc) DefaultRecLoc="Default Receiving Location";
					var choice1=confirm(t[WarnMsg]+' '+DefaultRecLoc+'. '+t['RESELECT_REC_LOC']+'\n'+WarnDesc);
					// Delete the order if user choose not to order those orders has no stock in default receiving location
					if (choice1==false) {
						DelOrdRowId="";
						for (var j6=objBarcodeList.length;j6>0;j6--) {
							//alert("ORIRowId="+lstOrders.options[j6-1].ORIRowId);
							if (objBarcodeList.options[j6-1].ORIRowId.split(WarnItmMastID).length>1) {
								if (objBarcodeList.options[j6-1].ORIRowId.split("^").length==1) {
									DelOrdRowId=mPiece(objBarcodeList.options[j6-1].ORIRowId,"*",1);
									DelStockInOtherLoc=DelStockInOtherLoc+DelOrdRowId+"^";
									objBarcodeList.options[j6-1]=null;	
								}
							}
						}
						OEORIobj=document.getElementById("OEOrdItemIDs");
						if (OEORIobj) {
							NewOrderRowIds=OEORIobj.value;
						
							NewOrderArr=NewOrderRowIds.split("^");
							del=-1;
							for (var b5=0;b5<NewOrderArr.length;b5++) {
								if (mPiece(NewOrderArr[b5],"*",1)==DelOrdRowId) {
									del=b5;
									break;
								}
							}
							if (del>-1) {
								newNewOrderRowIds="";
								for (var b5=0;b5<NewOrderArr.length;b5++) {
									if (b5!=del) {
										if (newNewOrderRowIds!="") newNewOrderRowIds=newNewOrderRowIds+"^";
										newNewOrderRowIds=newNewOrderRowIds+NewOrderArr[b5];
									}
								}
								OEORIobj.value=newNewOrderRowIds;
							}
						}
					}
					else StockInOtherLoc=StockInOtherLoc+WarnItmMastID+"*"+WarnDetail+"^";
				}
			}
			else {
				WarnDetail=mPiece(WarnMsg,"*",1);
				WarnMsg=mPiece(WarnMsg,"*",0);
				if (t[WarnMsg]!="") {
					alert(t[WarnMsg]+"\n"+WarnDetail);
				}
			}
		}
	}
	//alert("WarningMsg="+WarningMsg);
	if (WarningMsg!="") {
		alert(WarningMsg);
	}
	
	if ((objDisplayAlerts)&&(objDisplayAlerts.checked==true)) DisplayAlert=1
	
	OrderDetailsOpenCount=0;
	if ((DisplayAlert==1)&&((DisplayQuestionFlag==1)||(AgeSexFlag==1)||(DosageRange!="")||(DupMsg!="")||(AllergyFlag==1)||(HasDSSMsg==1)||(gotOEMsg==1))) {
		AllergyItems=escape(AllergyItems);
		if (((OrdRowIDExternalCodeNotExist.split("^").length-2)<NewOrderCount)&&((NonDentalOrder.split("^").length-1)<NewOrderCount)) {
			var URL="websys.csp?TWKFL="+WorkFlowID+"&ReceivedDateTime="+ReceivedDateTime+"&CollectDateTime="+CollectDateTime+"&NewOrderString="+NewOrderString+"&EpisString="+EpisString+"&DisplayQuestionFlag="+DisplayQuestionFlag+"&OEMessageFlag="+OEMessageFlag+"&AllergyFlag="+AllergyFlag+"&AllergyItems="+AllergyItems+"&PathwayDR="+PathwayDR+"&OrderItemsID="+OrderItemsID+"&NewOrders="+NewOrders+"&ORIRowIDs="+ORIRowIDs+"&InteractFlag="+InteractFlag+"&MaxCumDoseFlag="+MaxCumDoseFlag+"&DrugIntString="+DrugIntString+"&LabFlag="+LabFlag+"&HasAction="+HasAction+"&AfterAction="+AfterAction+"&BeforeAction="+BeforeAction+"&ActionItemString="+ActionItemString+"&NewLabEpisodeNumber="+NewLabEpisodeNumber+"&NewLabOrders="+NewLabOrders+"&NewLabSpecs="+NewLabSpecs+"&NewLabColDate="+NewLabColDate+"&NewLabColTime="+NewLabColTime+"&NewLabRecDate="+NewLabRecDate+"&NewLabRecTime="+NewLabRecTime+"&SilentMode="+SilentMode+"&DupMsg="+DupMsg+"&OrderSetID="+OrderSetID+"&AgeSexFlag="+AgeSexFlag+"&AgeSexString="+AgeSexString+"&AgeSexItem="+AgeSexItem+"&DosageRange="+DosageRange+"&HasDSSMsg="+HasDSSMsg+"&OrdRowIDExternalCodeNotExist="+OrdRowIDExternalCodeNotExist+"&StockInOtherLoc="+StockInOtherLoc+"&DelStockInOtherLoc="+DelStockInOtherLoc+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&OrderWindow="+window.name;
			URL=URL+"&ShowOrderDetailFlag=1";
			var features="scrollbars=yes,toolbar=no,resizable=yes";
			websys_createWindow(URL,'AlertScreen',features)
		}
		else {
			VerifyOrders();
		}
	}
	else {
		VerifyOrders();
	}
}

function VerifyOrders() {
	objHiddenAdd.click();
	/*
	var objNewOrders=document.getElementById("NewOrders");
	if (objNewOrders) VParam1=objNewOrders.value;
	if (objHiddenAdd) objHiddenAdd.click();
	var EpisodeID="";
	var objEpisodeID=document.getElementById("EpisodeID");
	if (objEpisodeID) EpisodeID=objEpisodeID.value;
	var PatientID="";
	var objPatientID=document.getElementById("PatientID");
	if (objPatientID) PatientID=objPatientID.value;
	var url="oeorder.ScanOrders.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID;
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"TRAK_main","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	*/
}

function AddOrderschangehandler() {
	if (objBarcode) BParam=objBarcode.value;
	if (objHiddenBarcode) objHiddenBarcode.onclick=objHiddenBarcode.onchange;
	if (objHiddenBarcode) objHiddenBarcode.click();
}

function BarcodeAdd(txt) {
	//Add an item to lstOrders when an item is selected from the Lookup, then clears the Item text field.
	var bdata=txt.split(String.fromCharCode(1));
	var adata="";
	var idesc="";
	var icode="";
	var iuom="";
	var idur="";
	var ifreq="";
	var Itemids="";
	for (var bm4=0; bm4<bdata.length-1; bm4++) {
		adata=bdata[bm4].split(String.fromCharCode(2));
		idesc=adata[0];
		icode=adata[1];
		iuom=adata[5];
		idur=adata[6];
		ifreq=adata[7];
		SetRef=1;
		window.focus();

		if (!objBarcodeList) objBarcodeList=document.getElementById("BarcodeList");
		AddItemToList(objBarcodeList,icode,idesc,"","","","","","",idur,SetRef,"","");
	}
	if (objBarcode) objBarcode.value="";
	if (objBarcode) websys_setfocus('Barcode');
}

function AddItemToList(list,code,desc,subcatcode,ordertype,alias,data,setid,ordcatID,dur,setref,OSItemIDs,ordersubcatID,CopyOrdRowId,DoNotClearSelection) {	  //Add an item to a listbox
	if (list=="") list=objBarcodeList;
	var obj=document.getElementById("DefaultData");
	if ((obj)&&(data=="")) data=obj.value;
	if ((DoNotClearSelection!=1) && (list.length>0)) list.selectedIndex = -1;
	//Log 46424 add the order group number in listbox text
	list.options[list.length] = new Option(desc,code);
	list.options[list.length-1].id=subcatcode+String.fromCharCode(4)+dur+String.fromCharCode(4)+setref+String.fromCharCode(4);
	list.options[list.length-1].itype=ordertype+String.fromCharCode(4)+alias+String.fromCharCode(4)+setid+String.fromCharCode(4)+ordcatID+String.fromCharCode(4)+OSItemIDs+String.fromCharCode(4)+ordersubcatID+String.fromCharCode(4);
	list.options[list.length-1].idata=data;
	list.options[list.length-1].idata=data;
	list.options[list.length-1].ORIRowId="";
}

document.body.onload=BodyLoadHandler;

//Log 57678 PeterC 23/01/06
document.body.onkeydown=BarCodeEnt;

function BarCodeEnt()
{
	if (event.keyCode == 13) {
		var eSrc = websys_getSrcElement(e);
		if((eSrc)&&(eSrc.id=="Barcode")) return false;
	}
}