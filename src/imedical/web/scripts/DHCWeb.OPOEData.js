/// DHCWeb.OPOEData.js

var aryEN=new Array();
aryEN[0]="OPOrdItemDesc" ;
aryEN[1]="OPOrdItemRowID" ;
aryEN[2]="OPOrdUnit" ;
aryEN[3]="OPOrdPrice" ;
aryEN[4]="OPOrdQty" ;
aryEN[5]="OPOrdBillSum" ;
aryEN[6]="OPOrdConFac" ;
aryEN[7]="OPOrdDiscPrice" ;
aryEN[8]="OPOrdInsPrice" ;
aryEN[9]="OPOrdPatPrice";
aryEN[10]="OPOrdItemRecLoc";
aryEN[11]="OPOrdItemRecLocRID";
aryEN[12]="OPOrdBillFlag";
aryEN[13]="OPOrdARCType";
aryEN[14]="OPOrdType";
aryEN[15]="OrdRowId"
aryEN[16]="OPOrdInsType"
aryEN[17]="OPOrdInsRowId"
aryEN[18]="OPOrdEnt"
aryEN[19]="OPOrdPrescNo";
aryEN[20]="DiscAmt"
aryEN[21]="PayorAmt";


function DHCWebD_OrdNumConv(){
	var myOEList=parent.frames["DHCOPOEList"];
	var myOEInput=parent.frames["DHCOPOEOrdInput"];
	var Sobj=myOEList.document.getElementById("OPMultNum");
	var Tobj=myOEInput.document.getElementById("OPMultNum");
	
	///Set INPUT Ord Num
	DHCWebD_SetObjValueTrans(Sobj, Tobj);
	///var myOPMultNum=DHCWebD_GetObjValueA(Sobj);
	
}

function DHCWebD_WrtOSItmListByStr(OELIstStr,DListFramObj)
{
	//var tablistOPOE=new Object;
	//Translate OrdSets to OrdList   
	//f
	//
	//udhcOPPatOrder;DHCOPOEOrdInput
	
	var myFAry=DListFramObj.name.split(".");
	var myfname=myFAry.join("_");
	var DtablistOPOE=DListFramObj.document.getElementById("t" + myfname);
	var DbodylistOPOE=DListFramObj.document.body;
	var DdoclistOPOE=DListFramObj.document;
	
	var myOEListAry=OELIstStr.split(String.fromCharCode(2));
	var myOELen=myOEListAry.length;
	for (var i=0;i<myOELen;i++){
		var myOEItemStr=myOEListAry[i];
		var myItemAry=myOEItemStr.split("^");
		
		DHCWebD_AddTabRowForOrdSet(DtablistOPOE);
		
		var Row=DtablistOPOE.rows.length-2;
		for (j=0; j<aryEN.length;j++) {
			///var SObj=SInfoDocObj.getElementById(aryEN[i]+"z"+idx);
			var DObj=DdoclistOPOE.getElementById(aryEN[j]+"z"+Row);
			if ((DObj)) {
				///var SValue=DHCWebD_GetCellValue(SObj);
				var SValue=myItemAry[j];
				DHCWebD_SetListValueA(DObj,SValue);
			}
		}
		
		DbodylistOPOE.scrollTop=DbodylistOPOE.scrollHeight-DbodylistOPOE.clientHeight-35;
		
	}
	//DbodylistOPOE.scrollTop=DbodylistOPOE.scrollHeight-DbodylistOPOE.clientHeight-35;
	DHCWebD_ResetRowItems(DtablistOPOE);
	DHCWebD_CalAdm();
	return true;
}


function DHCWebD_WrtOSItmList(SInfoDocObj,DListFramObj)
{
	//var tablistOPOE=new Object;
	//Translate OrdSets to OrdList   
	//f
	//
	//udhcOPPatOrder;DHCOPOEOrdInput
	
	var SInfoTabObj=SInfoDocObj.getElementById("tDHCOPOEOrdSets");
	
	var myFAry=DListFramObj.name.split(".");
	var myfname=myFAry.join("_");
	var DtablistOPOE=DListFramObj.document.getElementById("t" + myfname);
	var DbodylistOPOE=DListFramObj.document.body;
	var DdoclistOPOE=DListFramObj.document;
	
	for (var idx=1;idx<SInfoTabObj.rows.length;idx++){
		var AddFlagObj=SInfoDocObj.getElementById("AddItemz"+idx);
		var AddFlag=DHCWebD_GetCellValue(AddFlagObj);
		if (AddFlag){
		DHCWebD_AddTabRow(DtablistOPOE);
		var Row=DtablistOPOE.rows.length-2;
		var i=0;
		for (i=0; i<aryEN.length;i++) {
			var SObj=SInfoDocObj.getElementById(aryEN[i]+"z"+idx);
			var DObj=DdoclistOPOE.getElementById(aryEN[i]+"z"+Row);
			if ((SObj)&&(DObj)) {
				var SValue=DHCWebD_GetCellValue(SObj);
				DHCWebD_SetListValueA(DObj,SValue);
				////DHCWebD_SetListValue(SObj,DObj);
			}
		}
		
		DbodylistOPOE.scrollTop=DbodylistOPOE.scrollHeight-DbodylistOPOE.clientHeight-35;
		}
	}
	DHCWebD_CalAdm();
	return true;	
}

function DHCWebD_WrtItmList(ListFramObj,InfoFramObj,elestr,vSelIdx)
{
	//fsdfsdfds
	//
	//
	//
	//udhcOPPatOrder;DHCOPOEOrdInput
	var tablistOPOE=ListFramObj.document.getElementById("t" + ListFramObj.name);
	var bodylistOPOE=ListFramObj.document.body;
	var doclistOPOE=ListFramObj.document;
	
	var doctxtOPOE=InfoFramObj.document;
		
	var mystr=elestr.split("^");
	if ((vSelIdx=="")||isNaN(vSelIdx)){
		DHCWebD_AddTabRow(tablistOPOE);
		var Row=tablistOPOE.rows.length-2;
	}else{
		var Row=vSelIdx;
	}
	var i=0	;
	for (i=0; i<mystr.length;i++) {
		var listobj=doclistOPOE.getElementById(mystr[i]+"z"+Row);
		var txtobj=doctxtOPOE.getElementById(mystr[i]);
		///alert(mystr[i]+":::"+DHCWebD_GetObjValue(mystr[i]));
		if ((txtobj)&&(listobj)) {
			DHCWebD_SetListValue(txtobj,listobj);
		}
	}
	var tblDivObj=doclistOPOE.getElementById("tblDiv");
	if(tblDivObj){
		//document.getElementById("divid").scrollTop=document.getElementById("divid").scrollHeight;
		tblDivObj.scrollTop=tblDivObj.scrollHeight;
	}
	DHCWebD_CalAdm();
	
	bodylistOPOE.scrollTop=bodylistOPOE.scrollHeight-bodylistOPOE.clientHeight-35;
	return true;	
}

function DHCWebD_AddTabRow(objtbl)
{
	DHCWebD_ResetRowItems(objtbl);
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	var oldrowitems=objlastrow.all;	//IE only
	
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	if (!oldrowitems) oldrowitems=objlastrow.getElementsByTagName("*"); //N6
	
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=row;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value="";
			////
			if (arrId[0]=="OPOrdNo"){
				///alert(arrId[0]+"|||"+row-2);
				oldrowitems[j].innerText=row-1;
			}
			///alert(rowitems[j].name);
		}
	}
	
	///alert(row-1);	
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}	
	//DHCWebD_ResetRowItems(objtbl);
}


function DHCWebD_AddTabRowForOrdSet(objtbl)
{
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	var oldrowitems=objlastrow.all;	//IE only
	
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	if (!oldrowitems) oldrowitems=objlastrow.getElementsByTagName("*"); //N6
	
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=row;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value="";
			////
			if (arrId[0]=="OPOrdNo"){
				///alert(arrId[0]+"|||"+row-2);
				oldrowitems[j].innerText=row-1;
			}
			///alert(rowitems[j].name);
		}
	}
	
	///alert(row-1);	
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}	
	//DHCWebD_ResetRowItems(objtbl);
}

function DHCWebD_ResetRowItems(objtbl) {
	//alert(objtbl.rows.length);
	//check the header by z; zhaocz;
	var firstrow=objtbl.rows[0];
	var firstitems=firstrow.all;
	if (!firstitems) firstitems=firstrow.getElementsByTagName("*"); //N6
	var myaryid=firstitems[1].id.split("z");
	if (myaryid.length==2){
		//no header
			fIdx=0
		}else{
			fIdx=1
		}
	for (var i=fIdx;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		{if ((i+1)%2==0) {objrow.className="RowEven";} else {objrow.className="RowOdd";}}
		var rowitems=objrow.all; //IE only
		if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
		for (var j=0;j<rowitems.length;j++) {
			//alert(i+":"+j+":"+rowitems[j].type);
			if (rowitems[j].id) {
				var arrId=rowitems[j].id.split("z");
				arrId[arrId.length-1]=i;
				rowitems[j].id=arrId.join("z");
				rowitems[j].name=arrId.join("z");
			}
		}
	}
}

function DHCWebD_DelSelTabRow(ListFramObj,selectidx,OrdItemRowId,SOrdInfo)
{
	//alert(OrdItemRowId+":"+SOrdInfo);
	var rtn=true;
	if (OrdItemRowId!=""){
		rtn=DHCWebD_StopOrdItem(OrdItemRowId,SOrdInfo);
	}
	if (!rtn) {return false;}
	try{
		var tablistobj=ListFramObj.document.getElementById("t" + ListFramObj.name);
		tablistobj.deleteRow(selectidx);
		DHCWebD_ResetRowItems(tablistobj);
	}catch(e){return false;}
	
	DHCWebD_CalAdm();
	
	return true;
}

function DHCWebD_StopOrdItem(OrdItemRowId,SOrdInfo)
{
	var obj=document.getElementById("OPOrdStopItemEncrypt");
	if (obj){
		try{
			var encmeth=obj.value;
			var rtnvalue=(cspRunServerMethod(encmeth,OrdItemRowId,SOrdInfo));
			if (rtnvalue!=0){
				throw DHCWebD_GetErrObj("停医嘱失败."+rtnvalue+"::"+OrdItemRowId+":::"+SOrdInfo);
			}
		}catch(e){
			alert(e.message);
			return false;
		}
		return true;
	}
	return false;
}

function DHCWebD_WrtItemInfo(ListFramObj,InfoFramObj,elestr,rowIdx)
{
	//sdafsdfdsfds
	//
	//dfasdfdsfdsfdsf
	var tablistOPOE=ListFramObj.document.getElementById("t" + ListFramObj.name);
	var bodylistOPOE=ListFramObj.document.body;
	var doclistOPOE=ListFramObj.document;
	var doctxtOPOE=InfoFramObj.document;
	
	var mystr=elestr.split("^");
	var i=0
	for (i=0; i<mystr.length;i++){
		var listobj=doclistOPOE.getElementById(mystr[i]+"z"+rowIdx);
		var txtobj=doctxtOPOE.getElementById(mystr[i]);
		if ((txtobj)&&(listobj)) {
			DHCWebD_SetObjValue(listobj,txtobj);
		}
	}
	//DHCWebD_CalListCol(ListFramObj,mystr[5]);
	
	return true;
}


function DHCWebD_SetObjValue(Sobj,Tobj)
{	
	var transval="";
	switch (Sobj.type)
	{
		case "checkbox":
			transval=Sobj.checked;
			break;
		case "text":
			transval=Sobj.innerText;
			break;
		case "hidden":
			transval=Sobj.value;
			break;
		default:
			transval=Sobj.innerText;
	}
	switch (Tobj.type)
	{
		case "select-one":
			DHCWebD_ClearAllList(Tobj);
			var myrows=Tobj.options.length;
			Tobj.options[myrows]=new Option(transval,"");
			Tobj.selectedIndex=0;
			break;
		case "checkbox":
			Tobj.checked=transval;
			break;
		case "text":
			Tobj.value=transval;		//txtobj.value;
			break;
		default:
			Tobj.value=transval;
			break;		
	}
}

function DHCWebD_SetListValue(Sobj,Tobj)
{
	var transval=""
	switch (Sobj.type)
	{
		case "select-one":
			myidx=Sobj.selectedIndex;
			transval=Sobj.options[myidx].text;
			break;
		case "checkbox":
			transval=Sobj.checked;
			break;
		case "hidden":
			transval=Sobj.value;
			break;
		default:
			transval=Sobj.value;
			break;
	}
	switch (Tobj.type)
	{
		case "select-one":
			var myrows=Tobj.options.length;
			Tobj.options[myrows] = new Option(transval,"");	//,aryval[i]	
			break;
		case "checkbox":
			Tobj.checked=Sobj.checked;	//txtobj.checked;
			break;
		case "text":
			Tobj.innerText=transval;		//txtobj.value;
			break;
		case "hidden":
			Tobj.value=transval;
			break;
		default:
			Tobj.innerText=transval;		//txtobj.value;
			break;
	}
}

function DHCWebD_SetListValueA(Tobj,transval){
	if(!Tobj){
		return;
	}
	switch (Tobj.type)
	{
		case "select-one":
			var myrows=Tobj.options.length;
			Tobj.options[myrows] = new Option(transval,"");	//,aryval[i]	
			break;
		case "checkbox":
			Tobj.checked=transval;	//txtobj.checked;
			break;
		case "text":
			Tobj.innerText=transval;		//txtobj.value;
			break;
		case "hidden":
			Tobj.value=transval;
			break;
		default:
			Tobj.innerText=transval;		//txtobj.value;
			break;
	}
}

function DHCWebD_SetObjValueA(TName,transval){
	var Tobj=document.getElementById(TName);
	if(!Tobj){
		return;
	}
	switch (Tobj.type)
	{
		case "select-one":
			var myrows=Tobj.options.length;
			Tobj.options[myrows] = new Option(transval,"");	//,aryval[i]	
			break;
		case "checkbox":
			Tobj.checked=transval;	//txtobj.checked;
			break;
		case "text":
			Tobj.innerText=transval;		//txtobj.value;
			break;
		case "hidden":
			Tobj.value=transval;
			break;
		default:
			Tobj.innerText=transval;		//txtobj.value;
			break;
	}
}

function DHCWebD_SetObjValueB(TName,transval){
	var Tobj=document.getElementById(TName);
	if (!Tobj){
		return;
	}
	switch (Tobj.type)
	{
		case "select-one":
			DHCWebD_ClearAllList(Tobj);
			var myrows=Tobj.options.length;
			Tobj.options[myrows]=new Option(transval,"");
			Tobj.selectedIndex=0;
			break;
		case "checkbox":
			Tobj.checked=transval;
			break;
		case "text":
			Tobj.value=transval;		//txtobj.value;
			break;
		default:
			Tobj.value=transval;
			break;		
	}
}

function DHCWebD_SetObjValueC(TName,transval){
	var Tobj=document.getElementById(TName);
	if (!Tobj){
		return;
	}
	switch (Tobj.type)
	{
		case "select-one":
			DHCWebD_ClearAllList(Tobj);
			var myrows=Tobj.options.length;
			Tobj.options[myrows]=new Option(transval,"");
			Tobj.selectedIndex=0;
			break;
		case "checkbox":
			Tobj.checked=transval;
			break;
		case "text":
			Tobj.value=transval;		//txtobj.value;
			break;
		default:
			Tobj.value=transval;
			break;		
	}
}

///Special for XML Data Stream;
function DHCWebD_SetObjValueXMLTrans(TName,transval){
	var Tobj=document.getElementById(TName);
	if(!Tobj){
		return;
	}
	
	switch (Tobj.type)
	{
		case "select-one":
			
			var myrows=Tobj.options.length;
			for (var i=0;i<myrows;i++){
				var myary=Tobj.options[i].value.split("^");
				if (myary[0]==transval){
					Tobj.selectedIndex= i;
					break;
				}
			}
			break;
		case "select-multiple":
			var myrows=Tobj.options.length;
			for (var i=0;i<myrows;i++){
				var myary=Tobj.options[i].value.split("^");
				if (myary[0]==transval){
					Tobj.selectedIndex= i;
					break;
				}
				
			}
			break;
		case "checkbox":
			if ((transval.toUpperCase()=="TRUE")||(transval=="1")||(transval.toUpperCase()=="ON"))
			{
				Tobj.checked=true;	//txtobj.checked;
			}else
			{
				Tobj.checked=false;	//txtobj.checked;
			}
			break;
		case "text":
			Tobj.innerText=transval;		//txtobj.value;
			break;
		case "hidden":
			Tobj.value=transval;
			break;
		default:
			
			Tobj.innerText=transval;		//txtobj.value;
			break;
	}
}

///Special for XML Data Stream;
function DHCWebD_GetObjValueXMLTrans(TName){
	var Tobj=document.getElementById(TName);
	if(!Tobj){
		return "";
	}
	var myValue="";
	switch (Tobj.type)
	{
		case "select-one":
			var myIdx=Tobj.options.selectedIndex;
			if(myIdx<0){
				return myValue;
			}
			myValue=Tobj.options[myIdx].value;
			break;
		case "checkbox":
			if (Tobj.checked==true)
			{
				myValue="on";
			}else{
				myValue="";
			}
			
			break;
		default:
			myValue = Tobj.value;		//txtobj.value;
			break;
	}
	return myValue;
}

///Special for XML Data Stream;
function DHCWebD_GetObjValueXMLTransA(TName){
	var Tobj=document.getElementById(TName);
	if(!Tobj){
		return "";
	}
	var myValue="";
	
	switch (Tobj.type)
	{
		case "select-one":
			var myIdx=Tobj.options.selectedIndex;
			if(myIdx<0){
				return myValue;
			}
			myValue=Tobj.options[myIdx].value;
			var myary=myValue.split("^");
			myValue = myary[0];
			break;
		case "checkbox":
			if (Tobj.checked==true)
			{
				myValue="on";
			}else{
				myValue="";
			}
			break;
		default:
			myValue = Tobj.value;		//txtobj.value;
			break;
	}
	
	return myValue;
}


function DHCWebD_SetObjValueTrans(SObj,Tobj){
	if ((!Tobj)||(!SObj)){
		return;
	}
	switch (Tobj.type)
	{
		case "select-one":
			DHCWebD_ClearAllList(Tobj);
			var myrows=Tobj.options.length;
			Tobj.options[myrows]=new Option("","");
			Tobj.selectedIndex=0;
			break;
		case "checkbox":
			Tobj.checked=SObj.checked;
			break;
		case "text":
			Tobj.value=SObj.value;		//txtobj.value;
			break;
		default:
			Tobj.value=SObj.value;
			break;		
	}
}


function DHCWebD_ClearAllList(obj) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
}

function DHCWebD_ClearAllListA(ListName) {
	var obj=document.getElementById(ListName);
	if (obj){
		for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}

function DHCWebD_GetObjValue(objname)
{
	var obj=document.getElementById(objname);
	var transval="";
	if (obj){
		switch (obj.type)
		{
			case "select-one":
				myidx=obj.selectedIndex;
				transval=obj.options[myidx].text;
				break;
			case "checkbox":
				transval=obj.checked;
				break;
			case "dhtmlXCombo":
				transval=obj.getSelectedValue();
				
				break;
			default:
				transval=obj.value;
				break;
		}
	}
	return transval;
}

function DHCWebD_GetObjValueA(obj)
{
	var transval="";
	if (obj){
		switch (obj.type)
		{
			case "select-one":
				myidx=obj.selectedIndex;
				transval=obj.options[myidx].text;
				break;
			case "checkbox":
				transval=obj.checked;
				break;
			case "dhtmlXCombo":
				transval=obj.getActualValue();
				break;
			default:
				transval=obj.value;
				break;
		}
	}
	return transval;
}


function DHCWebD_GetCellValue(ListCellObj){
	var transval="";
	switch (ListCellObj.type)
	{
		case "checkbox":
			transval=ListCellObj.checked;
			break;
		case "text":
			if (ListCellObj.disabled)
			{
			transval=ListCellObj.innerText;}
			else
			{
			transval=ListCellObj.value;}

			break;
		case "hidden":
			transval=ListCellObj.value;
			break;
		case "select-one":
			var myidx=ListCellObj.selectedIndex;
			transval=ListCellObj.options[myidx].text;
			break;
		default:
			transval=ListCellObj.innerText;
	}
	return transval;
}

function DHCWebD_GetCellValueA(ListCellObj){
	var transval="";
	switch (ListCellObj.type)
	{
		case "checkbox":
			transval=ListCellObj.checked;
			break;
		case "text":
			transval=ListCellObj.value;
			break;
		case "hidden":
			transval=ListCellObj.value;
			break;
		case "select-one":
			var myidx=ListCellObj.selectedIndex;
			transval=ListCellObj.options[myidx].text;
			break;
		default:
			transval=ListCellObj.innerText;
	}
	return transval;
}

///check Trans 0  1 string
function DHCWebD_GetCellValueB(ListCellObj){
	var transval="";
	switch (ListCellObj.type)
	{
		case "checkbox":
			if (ListCellObj.checked)
			{
				transval="1";
			}else
			{
				transval="0";
			}
			break;
		case "text":
			transval=ListCellObj.innerText;
			break;
		case "hidden":
			transval=ListCellObj.value;
			break;
		case "select-one":
			var myidx=ListCellObj.selectedIndex;
			transval=ListCellObj.options[myidx].text;
			break;
		default:
			transval=ListCellObj.innerText;
	}
	return transval;
}

function DHCWebD_SaveOrderCheck(OERows){
	///Check Order Property	
	var myrtn=true;
	var mydoc=parent.frames["udhcOPPatinfo"].document;
	var myVersion="";
	if (mydoc){
		var obj=mydoc.getElementById("DHCVersion");
		if (obj){
			myVersion=obj.value;
		}
	}
	switch(myVersion){
		case "3":
			//SXDT  Three Hosp
			var obj=mydoc.getElementById("AdmDocUserId");
			if((obj)&&(OERows>2)){
				var myAdmDoc=obj.value;
				if (myAdmDoc==""){
					myrtn=false;
				}
			}
			if (window.parent.ifCashierHJ()) {
				var obj=mydoc.getElementById("AdmDocUserId");
				if((obj)&&(OERows>2)){
					var myAdmDoc=obj.value;
					if (myAdmDoc==""){
						myrtn=false;
					}
				}
			}
				
			break;
		default:
		
	}
	return myrtn;
}

function DHCWebD_SaveOrder(){
	// save the Order to Cache;
	var listframe=parent.frames["DHCOPOEList"];
	var inputframe=parent.frames["DHCOPOEOrdInput"];

	var tablistOPOE=listframe.document.getElementById("tDHCOPOEList");
	var listdoc=listframe.document;
	
	var inputdoc=inputframe.document;
	
	var admrowid="";
	var admobj=inputdoc.getElementById("Adm");
	if (admobj){
		admrowid=admobj.value;
	}
	var mydocuserid=""
	var docobj=inputdoc.getElementById("DocUserId");
	if (docobj){
		var udhcOPPatinfo=parent.frames['udhcOPPatinfo'].document;	
		var AdmDocUserId=udhcOPPatinfo.getElementById('AdmDocUserId');
	    
		if (AdmDocUserId.value!=""&&docobj.value=="") docobj.value=AdmDocUserId.value;
		mydocuserid=docobj.value;
	}
	var encobj=inputdoc.getElementById("OPOrdSaveEncrypt");
	var encpreobj=inputdoc.getElementById("OPOrdPresNoEncrypt");
	if ((encobj)&&(encpreobj)){
		var encmeth=encobj.value;
		var presencmeth=encpreobj.value;
		var rtn=DHCWebD_SaveOrdToServer(encmeth,tablistOPOE,aryEN,admrowid,session['LOGON.USERID'],session['LOGON.CTLOCID'],mydocuserid,presencmeth);	
	}
	
	return rtn;
}

function DHCWebD_SaveOrdToServer(encmeth,objtbl,elestr,admrowid,UserID,LocID,DocUserId,preencmeth) {
	var myOERows=objtbl.rows.length;
	var myrtn=DHCWebD_SaveOrderCheck(myOERows);
	if (!myrtn){
		alert(t["NoDocTip"]);
		return false;
	}
	
	var DHCOPOEListDoc=parent.frames["DHCOPOEList"].document;
	
	var firstrow=objtbl.rows[0];
	var firstitems=firstrow.all;
	if (!firstitems) firstitems=firstrow.getElementsByTagName("*"); //N6
	var myaryid=firstitems[1].id.split("z");
	if (myaryid.length==2){
		//no header
		fIdx=0;
	}else{
		fIdx=1;
	}
	var unbillary=new Array();
	//for Row
	try {
		var saveflag=false;
		var orditemAry=new Array();
		var ordRowIndexAry=new Array();
		for (var i=fIdx;i<objtbl.rows.length-1; i++) {
			var objrow=objtbl.rows[i];
			{if ((i+1)%2==0) {objrow.className="RowEven";} else {objrow.className="RowOdd";}}
			var rowitems=objrow.all; //IE only
			if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
			if (rowitems){
				var myordrowid="";
				//alert(rowitems[elestr[15]+"z"+i].value+":"+elestr[15]);
				if (DHCOPOEListDoc.getElementById(elestr[15]+"z"+i).value==""){    //rowitems[elestr[15]+"z"+i].value
					//save info to server
					saveflag=true;
					var orditem="";
					//orditem=rowitems[elestr[1]+"z"+i].value+"^";
					orditem=DHCOPOEListDoc.getElementById(elestr[1]+"z"+i).value+"^";
					
					orditem +=rowitems[elestr[4]+"z"+i].innerText+"^";
					//orditem +=rowitems[elestr[11]+"z"+i].value+"^";
					orditem+=DHCOPOEListDoc.getElementById(elestr[11]+"z"+i).value+"^";
					orditem +=""+rowitems[elestr[3]+"z"+i].innerText+"^";
					orditem +=""+rowitems[elestr[2]+"z"+i].innerText+"^";
					//orditem +=""+rowitems[elestr[17]+"z"+i].value;
					orditem+=DHCOPOEListDoc.getElementById(elestr[17]+"z"+i).value+"^";
					//var OSRid=rowitems[elestr[18]+"z"+i].value;
					var OSRid=DHCOPOEListDoc.getElementById(elestr[18]+"z"+i).value;
					orditem+=OSRid+"^";
					//orditem格式：医嘱项指针(ARC_ItmMast)^医嘱数量^接收科室指针(CT_Loc)^单价^空值^费别指针(PAC_AdmReason)^医嘱套指针
					orditemAry.push(orditem);
					ordRowIndexAry.push(i);
					/*
					var rtnvalue="";
					rtnvalue=(cspRunServerMethod(encmeth,admrowid,orditem,UserID,LocID,DocUserId,OSRid));
					//alert(rtnvalue);
					if (rtnvalue.charAt(0)!="0"){
						throw DHCWebD_GetErrObj("Run Error at Cache Err=" +rtnvalue);
					}else{
						myary=rtnvalue.split("^");
						myordrowid=myary[1];
						//rowitems[elestr[15]+"z"+i].value=myordrowid;
						DHCOPOEListDoc.getElementById(elestr[15]+"z"+i).value=myordrowid;
						//alert(myordrowid);
					}
					*/
					
				}
                if (DHCOPOEListDoc.getElementById(elestr[12]+"z"+i).checked==false){
	                unbillary[unbillary.length]=DHCOPOEListDoc.getElementById(elestr[15]+"z"+i).value;
				}
			}
		}
		if(orditemAry.length>0){
			var orditemStr=orditemAry.join(String.fromCharCode(1));
			var rtnvalue=(cspRunServerMethod(encmeth,admrowid,orditemStr,UserID,LocID,DocUserId));
			//医生站接口返回0或100说明保存医嘱失败
			if ((rtnvalue!="0")&&(rtnvalue!="100")){
				//DHCWebD_ReloadOrderList();
				var myary=rtnvalue.split("^");
				var ordCount=myary.length;
				for(var k=0;k<ordCount;k++){
					if(myary[k]=="")continue;
					var tmpAry=myary[k].split("*");
					var myordrowid=tmpAry[1];
					var rowIndex=ordRowIndexAry[k];	//默认顺序号没有变化，即传给医生站什么顺序，传出来还是什么顺序
					var tmpObj=DHCOPOEListDoc.getElementById(elestr[15]+"z"+rowIndex);
					if(tmpObj) {
						tmpObj.value = myordrowid;
						//alert(DHCOPOEListDoc.getElementById(elestr[15]+"z"+rowIndex).value);
						if (DHCOPOEListDoc.getElementById(elestr[12]+"z"+rowIndex).checked==false){
							unbillary[unbillary.length]=tmpObj.value;
						}	
					}
				}
			}else{
				throw DHCWebD_GetErrObj("Run Error at Cache Err=" +rtnvalue);
			}				
		}
		DHCWebD_BuildStr(unbillary, admrowid);
		if (saveflag==true){
			var rtnvalue=(cspRunServerMethod(preencmeth,admrowid,UserID,LocID));
			if (rtnvalue!=0){
				throw DHCWebD_GetErrObj("Run Error at Cache: General PresNo");
			}
		}
	}
	catch(e){
		alert(e.message+",error Row in:"+ i);
		return false;
	} 
	return true;
}

function DHCWebD_ReloadOrderList(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPOEList";
	var OEList=parent.frames['DHCOPOEList'];
	OEList.location.href=OEList.location.href;
}

function DHCWebD_BuildStr(myaryStr,myadmrowid){
	var udhcOPPatinfo=parent.frames['udhcOPPatinfo'];
	//var OrdItemStr=udhcOPPatinfo.OrdItemStr;
	var patdoc=udhcOPPatinfo.document;
	
	var sobj=patdoc.getElementById("OrdItemStr");
	var mystr=String.fromCharCode(2);
	mystr=mystr+ "" +myadmrowid;
	mystr=mystr+ "" +String.fromCharCode(2);	
	//alert(myadmrowid);
	var myarystr=sobj.value.split(mystr);
	if (myarystr.length==1){
		var curstr=mystr+"^"+myaryStr.join("^")+"^"+mystr;
		sobj.value=sobj.value+""+curstr;
	}else{
		myarystr[1]="^"+myaryStr.join("^")+"^";
		sobj.value=myarystr.join(mystr);
	}
}

function DHCWebD_GetUnBillStr(){
	var udhcOPPatinfo=parent.frames['udhcOPPatinfo'];
	var patdoc=udhcOPPatinfo.document;
	
	var sobj=patdoc.getElementById("OrdItemStr");
	var rtnvalue=sobj.value;
	return rtnvalue;
}

function DHCWebD_SetUnBillList(){
	var udhcOPPatinfo=parent.frames['udhcOPPatinfo'];
	var OrdItemStr=udhcOPPatinfo.OrdItemStr;
	patdoc=udhcOPPatinfo.document;
	var obj_PAADMList=patdoc.getElementById('PAADMList');
	if (obj_PAADMList) {
		var selectidx=obj_PAADMList.selectedIndex;
	   	var myunbillary=OrdItemStr[selectidx].split("^");
	}
	if (myunbillary.length>0){
		
	}

}


function  DHCWebD_GetErrObj(msg)
{
	//throw an Error Object;
	var err=new Error(msg);
	return err;
}

function DHCWebD_CalAdm(){
	var mylistframe=parent.frames["DHCOPOEList"];    /////parent.frames["DHCOPOEList"];
	var mytmp=parent.frames["DHCOPOEList"];
	var patframe=parent.frames["udhcOPPatinfo"];
	var chargeframe=parent.frames["udhcOPCharge"];
	if (chargeframe){
		///
		///
	}else{
		///return;
	}
	
	if (!(mylistframe&&patframe)){
		var par_win=window.opener;
		var mylistframe=par_win.parent.frames["DHCOPOEList"];
		var patframe=par_win.parent.frames["udhcOPPatinfo"];
		var chargeframe=par_win.parent.frames["udhcOPCharge"];
	}	
	var patdoc=patframe.document;
	//sf
	//calculate patent pay for the doc.
	var patpaysum=DHCWebD_CalListCol(mylistframe,"OPOrdBillSum","OPOrdBillFlag")
	var Payorsum=DHCWebD_CalListCol(mylistframe,"PayorAmt","OPOrdBillFlag");
	var DiscAmtsum=DHCWebD_CalListCol(mylistframe,"DiscAmt","OPOrdBillFlag");
	//calculate total Charge
	var paysum=DHCWebD_CalListColProduct(mylistframe,"OPOrdQty","OPOrdPrice","OPOrdBillFlag");
	
	//change for the udhcOPPatinfo compoent;
	//change for the ADMListBox
	var obj_PAADMList=patdoc.getElementById('PAADMList');
	if (obj_PAADMList) {
	   	//sf
		var selectidx=obj_PAADMList.selectedIndex;
		if (selectidx<0) return;
	   	var aryvalue=obj_PAADMList.options[selectidx].value;
	   	var AdmStrArry=aryvalue.split("^");
	   	AdmStrArry[7]=paysum;		//TotalSum=TotalSum+eval(AdmStrArry[7]);
	   	AdmStrArry[8]=patpaysum;    ////PatShare=PatShare+eval(AdmStrArry[8])		
		AdmStrArry[9]=DiscAmtsum;
	   	AdmStrArry[10]=Payorsum;	
	   	obj_PAADMList.options[selectidx].value=AdmStrArry.join("^");     ///AdmStrArry[0]+"^"+AdmStrArry[1]+"^"+AdmStrArry[2]+"^"+AdmStrArry[3]+"^"+AdmStrArry[4]+"^"+AdmStrArry[5]+"^"+AdmStrArry[6]+"^"+AdmStrArry[7]+"^"+AdmStrArry[8];
	}
	
	if (chargeframe){
		var chargedoc=chargeframe.document;
		
		var obj=chargedoc.getElementById("RoundNum");
		var myRoundNum=DHCWebD_GetObjValueA(obj);
		if ((isNaN(myRoundNum))||(myRoundNum=="")){
			myRoundNum=0;
		}
		myRoundNum=parseFloat(myRoundNum);
		
		var tobj=chargedoc.getElementById("CurDeptShare");
		if (tobj){
			tobj.value=patpaysum.toFixed(2);
		}
		var obj=chargedoc.getElementById("CurDeptTotal");
		if (obj){
			obj.value=paysum.toFixed(2);
		}
		
		var obj=chargedoc.getElementById("CurDepRoundShare");
		if (obj){
			///obj.value=patpaysum.toFixed(1);
			if (myRoundNum!=0){
				obj.value=patpaysum.toRound(1,myRoundNum).toFixed(2);
			}else{
				obj.value=patpaysum.toFixed(2);
			}
		}
		var tobj=chargedoc.getElementById("CurDeptDiscAmt");
		if (tobj){
			tobj.value=DiscAmtsum.toFixed(2);
		}
		var obj=chargedoc.getElementById("CurDeptPayorAmt");
		if (obj){
			obj.value=Payorsum.toFixed(2);
		}
		
	}
	
	//Actualmoney
	//alert(patpaysum);
	//change for the udhcOPCharge component;
	if (obj_PAADMList){
		var listRows=obj_PAADMList.options.length;
		var TotalSum=0;
		var PatShare=0;
		var DiscAmtSum=0;
		var PayorAmtSum=0;
		for (var i=0;i<listRows;i++){
			var myaryvalue=obj_PAADMList.options[i].value.split("^");
			var mytotnum=parseFloat(myaryvalue[7]);
			if (isNaN(mytotnum)){mytotnum=0;}
			var mypatnum=parseFloat(myaryvalue[8])
			if (isNaN(mypatnum)){mypatnum=0;}
			var mydiscamtnum=parseFloat(myaryvalue[9])
			if (isNaN(mydiscamtnum)){mydiscamtnum=0;}
			var mypayoramtnum=parseFloat(myaryvalue[10])
			if (isNaN(mypayoramtnum)){mypayoramtnum=0;}
			TotalSum+=mytotnum;
			PatShare+=mypatnum;
			DiscAmtSum+=mydiscamtnum;
			PayorAmtSum+=mypayoramtnum;
		}
		//Total
		///alert(PatShare);
		if (chargeframe){
			var chargedoc=chargeframe.document;
			
			var obj=chargedoc.getElementById("RoundNum");
			var myRoundNum=DHCWebD_GetObjValueA(obj);
			if ((isNaN(myRoundNum))||(myRoundNum=="")){
				myRoundNum=0;
			}
			myRoundNum=parseFloat(myRoundNum);
			
			var tobj=chargedoc.getElementById("PatShareSum");
			if (tobj){
				tobj.value=PatShare.toFixed(2);
				obj.readOnly=true;
			}
			var obj=chargedoc.getElementById("Total");
			if (obj){
				obj.value=TotalSum.toFixed(2);
				obj.readOnly=true;
			}
			
			var obj=chargedoc.getElementById("PatRoundSum");
			if (obj){
				if(myRoundNum!=0){
					obj.value=PatShare.toRound(1,myRoundNum).toFixed(2);
				}else{
					obj.value=PatShare.toFixed(2);
				}
				obj.readOnly=true;
			}
			var obj=chargedoc.getElementById("DiscAmt");
			if (obj){
				obj.value=DiscAmtSum.toFixed(2);
				obj.readOnly=true;
			}
			var obj=chargedoc.getElementById("PayorAmt");
			if (obj){
				obj.value=PayorAmtSum.toFixed(2);
				obj.readOnly=true;
			}
		}
	}
}

function DHCWebD_CalListCol(ListFramObj,colname,colfname)
{
	var tablistOPOE=ListFramObj.document.getElementById("t" + ListFramObj.name);
	var firstrow=tablistOPOE.rows[0];
	var firstitems=firstrow.all;
	if (!firstitems) firstitems=firstrow.getElementsByTagName("*"); //N6
	var myaryid=firstitems[1].id.split("z");
	if (myaryid.length==2){
		//no header
			fIdx=0
		}else{
			fIdx=1
		}
	var rtnres=0;
	var i=0
	var tablistobj=ListFramObj.document.getElementById("t" + ListFramObj.name);
	var doclistobj=ListFramObj.document;
	var rowidxs=tablistobj.rows.length;  ///-1
	for (var i=fIdx;i<rowidxs;i++)
	{
		var fobj=doclistobj.getElementById(colfname+"z"+i);
		if (fobj){
			if (fobj.checked){
				var listobj=doclistobj.getElementById(colname+"z"+i);	////.innerText
				if (listobj) var mynum=parseFloat(DHCWebD_GetCellValue(listobj));
				if (isNaN(mynum)) {var mynum=0}
				rtnres+=mynum;
			}
		}
	}
	rtnres=rtnres.toFixed(2);   //
	return rtnres;
}

function DHCWebD_CalListColProduct(ListFramObj,cola,colb,colfname)
{
	//
	//
	var tablistOPOE=ListFramObj.document.getElementById("t" + ListFramObj.name);
	var firstrow=tablistOPOE.rows[0];
	var firstitems=firstrow.all;
	if (!firstitems) firstitems=firstrow.getElementsByTagName("*"); //N6
	var myaryid=firstitems[1].id.split("z");
	if (myaryid.length==2){
		//no header
			fIdx=0
		}else{
			fIdx=1
		}
	
	var rtnres=0;
	var i=0
	var tablistobj=ListFramObj.document.getElementById("t" + ListFramObj.name);
	var doclistobj=ListFramObj.document;
	var rowidxs=tablistobj.rows.length-1;
	//alert(rowidxs);
	var mynum=0;
	for (var i=fIdx;i<rowidxs;i++)
	{
		var fobj=doclistobj.getElementById(colfname+"z"+i);
		if (fobj){
			if (fobj.checked){
				var lista=doclistobj.getElementById(cola+"z"+i);
				var listb=doclistobj.getElementById(colb+"z"+i);
				var numa=0;
				var numb=0;
				if (lista) {
					var numa=DHCWebD_GetCellValue(lista);
					numa=parseFloat(numa);
				}
				if (listb){
					var numb=DHCWebD_GetCellValue(listb);
					numb=parseFloat(numb);
				}
				if (isNaN(numa)) {var numa=0};
				if (isNaN(numb)) {var numb=0};
				//each orderitem
				var myColSum=(numa*numb)+0.00001;
				mynum=(myColSum).toFixed(2);
				mynum=parseFloat(mynum);
				rtnres+=mynum;
			}
		}
	}
	rtnres=rtnres.toFixed(2);
	//alert(rtnres);
	return rtnres;
}

function DHCWebD_CalListColProductA(ListFramObj,cola,colb,colfname)
{
	//
	//
	var tablistOPOE=ListFramObj.document.getElementById("t" + ListFramObj.name);
	var firstrow=tablistOPOE.rows[0];
	var firstitems=firstrow.all;
	if (!firstitems) firstitems=firstrow.getElementsByTagName("*"); //N6
	var myaryid=firstitems[1].id.split("z");
	if (myaryid.length==2){
		//no header
			fIdx=0
		}else{
			fIdx=1
		}
	
	var rtnres=0;
	var i=0
	var tablistobj=ListFramObj.document.getElementById("t" + ListFramObj.name);
	var doclistobj=ListFramObj.document;
	var rowidxs=tablistobj.rows.length-1;
	//alert(rowidxs);
	var mynum=0;
	for (var i=fIdx;i<rowidxs;i++)
	{
		var fobj=doclistobj.getElementById(colfname+"z"+i);
		if (fobj){
			if (fobj.checked){
				var lista=doclistobj.getElementById(cola+"z"+i);
				var listb=doclistobj.getElementById(colb+"z"+i);
				var numa=0;
				var numb=0;
				if (lista) {
					var numa=DHCWebD_GetCellValue(lista);
					numa=parseFloat(numa);
				}
				if (listb){
					var numb=DHCWebD_GetCellValue(listb);
					numb=parseFloat(numb);
				}
				if (isNaN(numa)) {var numa=0};
				if (isNaN(numb)) {var numb=0};
				//each orderitem
				mynum=(numa*numb).toFixed(2);
				mynum=parseFloat(mynum);
				rtnres+=mynum;
			}
		}
	}
	rtnres=rtnres.toFixed(2);
	//alert(rtnres);
	return rtnres;
}

function DHCWebD_SetTabNo(vIdx){
	////
	
	
}

function DHCWebD_IntDocument(curframe){
	//ss
	//ss
	var curdoc=curframe.document;	//
	var curbody=curdoc.body;
	
	var bodynode=curdoc.childNodes[2];
	var parnode=curdoc.childNodes[2];
	var mynode=parnode.childNodes[1]
	
	DHCWebD_IntNode(mynode);
}

function DHCWebD_IntNode(curNode){
	var rtn=curNode.hasChildNodes();
	if (rtn==true){
		for (var i=0;i<curNode.childNodes.length;i++){
			var childnode=curNode.childNodes[i];
			if ((childnode)){
				DHCWebD_IntNode(childnode);
			}
		}
	}else{
		//
		switch (curNode.nodeName){
		case "INPUT":
			var myid=curNode.id;
			//alert(curNode.value+"::"+curNode.id+":::"+ curNode.nodeType+":"+curNode.nodeValue+":"+curNode.nodeName+":"+curNode.tagName);
			
			break;
		case "SELECT":
			alert(curNode.options.length +"::"+curNode.id+":::"+ curNode.nodeType+":"+curNode.nodeValue+":"+curNode.nodeName+":"+curNode.tagName);
			//curNode.options[0].value +
			break;	
		}
		if (curNode.id==""){
			alert("::"+curNode.id+":::"+ curNode.nodeType+":"+curNode.nodeValue+":"+curNode.nodeName+":"+curNode.tagName);
		}
	}
}

function DHCWebD_IntFeeDoc(){
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPOEList&PAADMRowid=&AdmInsType=&unBillStr=";
	//var OEList=parent.frames['DHCOPOEList'];
	//OEList.location.href=lnk;

	var patframe=parent.frames["udhcOPPatinfo"];
	if (patframe){
		var patdoc=patframe.window;
		patdoc.SelectAdmInsList();
	}
	
	
	return;
	
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPOEList&PAADMRowid=''&AdmInsType=''&unBillStr=''";
	//var OEList=parent.frames['DHCOPOEList'];
	//OEList.location.href=lnk;
	
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPOEOrdInput&Adm=''"+"&AdmBillType=''";
	//var ordframe=parent.frames["DHCOPOEOrdInput"];
	//ordframe.location.href=lnk;

	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCharge&PaadmRowid=''"+"&PatientID=''"
	//lnk=lnk+"&Total=0"+"&PatShareSum=0"+"&CurrentInsType=''";
	//lnk=lnk+"&CurDeptTotal=0"+"&CurDeptShare=0";
	//var chargeframe=parent.frames['udhcOPCharge'];
	//chargeframe.location.href=lnk;
		
}

function DHCWebD_IntFeeAll(){
	////fg
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPPatinfo";
	var patframe=parent.frames["udhcOPPatinfo"];
	patframe.location.href=lnk;
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPOEList&PAADMRowid=&AdmInsType=&unBillStr=";
	var OEList=parent.frames['DHCOPOEList'];
	OEList.location.href=lnk;
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPOEOrdInput&Adm="+"&AdmBillType=";
	var ordframe=parent.frames["DHCOPOEOrdInput"];
	ordframe.location.href=lnk;

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCharge&PaadmRowid="+"&PatientID="
	lnk=lnk+"&Total=0"+"&PatShareSum=0"+"&CurrentInsType=";
	lnk=lnk+"&CurDeptTotal=0"+"&CurDeptShare=0";
	var chargeframe=parent.frames['udhcOPCharge'];
	if (chargeframe){
		chargeframe.location.href=lnk;
	}
	
	patobj=patframe.document.getElementById("PatientID");
	///if (patobj){
	///	patobj.setfocus;
	///	patobj.select;
	///}
	
	if (patframe){
		var patd1=patframe.document;
		if (patd1){
			var obj=patd1.getElementById("DelCalEncrypt");
			if (obj){
				var myUser=session['LOGON.USERID'];
				var encmeth=obj.value;
				rtnvalue=(cspRunServerMethod(encmeth,myUser));
			}
		}
	}
	
}

function DHCWeb_DocumentOnKeydown(e) { //ALT-* PGUP PGDN
	DHCWeb_EStopSpaceKey();
	var keycode;
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==115){                     //F4	  
		var myOPPatinfo=parent.frames["udhcOPPatinfo"];	   
		if (myOPPatinfo) myOPPatinfo.ReadHFMagCard_Click();
		
	}
	if (keycode==117){                    //F6	//zfb-add 2014.9.19
		var myOPCharge=parent.frames["udhcOPCharge"];
		var Billobj=myOPCharge.document.getElementById("GoToGH");
		if (Billobj) {myOPCharge.GH_Click();}
	}
	if (keycode==118){                     //F7
	  	DHCWebD_IntFeeAll();
	}
	if (keycode==119){                    //F8
  		var myOPPatinfo=parent.frames["udhcOPPatinfo"];
		var BAdmQueryobj=myOPPatinfo.document.getElementById("BAdmQuery");
		if (BAdmQueryobj) myOPPatinfo.SelectOneAdm();
	}
	if (keycode==120){                    //F9
   		var myOPCharge=parent.frames["udhcOPCharge"];
		var Billobj=myOPCharge.document.getElementById("Bill");
		//+2018-05-02 ZhYW 结算按钮disabled时,快捷键也不能使用
		if ((Billobj)&&(!Billobj.disabled)) {
			myOPCharge.Bill_Click();
		}
	}
	if (keycode==121){                    //F10
		//+2018-05-02 ZhYW 保存按钮disabled时,快捷键也不能使用
		var inputDoc = parent.frames["DHCOPOEOrdInput"].document;
		if (!inputDoc.getElementById("OPOrdSave").disabled) {
			var rtn = DHCWebD_SaveOrder();
			if (!rtn) {
				alert("医嘱保存失败.");
	  		}else  {
	  			alert("医嘱保存成功.");
	  	 		RefreshOrderList();
			}
		}
	}
	if (keycode==123){                    //F12
     	var myOEInput=parent.frames["DHCOPOEOrdInput"];
		var HjPrintobj=myOEInput.document.getElementById("HjPrint");
		if (HjPrintobj) myOEInput.HjPrint_Click();
	}
}

function RefreshOrderList()
{
	var OPOEListDocObj=parent.frames["DHCOPOEList"].document
	if (OPOEListDocObj){
		OPOEListDocObj.location.reload();
	}
}

function DHCWebD_GetColInfo(ListFramObj,colname,colfname) {
	var tablistOPOE=ListFramObj.document.getElementById("t" + ListFramObj.name);
	var firstrow=tablistOPOE.rows[0];
	var firstitems=firstrow.all;
	if (!firstitems) firstitems=firstrow.getElementsByTagName("*"); //N6
	var myaryid=firstitems[1].id.split("z");
	if (myaryid.length==2){
		//no header
		fIdx=0;
	}else{
		fIdx=1;
	}
	var rtnres=0;
	var i=0;
	var tablistobj=ListFramObj.document.getElementById("t" + ListFramObj.name);
	var doclistobj=ListFramObj.document;
	var rowidxs=tablistobj.rows.length;  ///-1
	var tmpStr="";
	for (var i=fIdx;i<rowidxs;i++)
	{
		var fobj=doclistobj.getElementById(colfname+"z"+i);
		if (fobj){
			if (fobj.checked){
				var listobj=doclistobj.getElementById(colname+"z"+i);	////.innerText
				if (listobj){
					if(tmpStr==""){
					    tmpStr=DHCWebD_GetCellValue(listobj);
					    	
					}else{
						tmpStr=tmpStr+"^"+DHCWebD_GetCellValue(listobj);
					
					}
						
				} 
			    
			}
		}
	}
	return tmpStr;	
}

/**
* Creator: ZhYW
* CreatDate: 2018-12-26
* Description: 判断医嘱是否已保存
*/
function DHCWebD_CheckSaveOrder() {
	var listFrame = parent.frames["DHCOPOEList"];
	var objtbl = listFrame.document.getElementById("tDHCOPOEList");
	var myOERows = objtbl.rows.length;
	var firstRow = objtbl.rows[0];
	var firstItems = firstRow.all;
	if (!firstItems) {
		firstItems = firstRow.getElementsByTagName("*");
	}
	var myaryid = firstItems[1].id.split("z");
	var fIdx = 1;
	if (myaryid.length == 2) {
		fIdx = 0;
	}
	var saveFlag = true;
	try {
		for (var i = objtbl.rows.length - 2; i >= fIdx; i--) {
			var objRow = objtbl.rows[i];
			var rowItems = objRow.all;    //IE only
			if (!rowItems) {
				rowItems = objRow.getElementsByTagName("*");
			}
			if (rowItems) {
				if (listFrame.document.getElementById(aryEN[15] + "z" + i).value == "") {
					saveFlag = false;
					//var arcim = listFrame.document.getElementById(aryEN[1] + "z" + i).value;
				}
			}
			if (!saveFlag) {
				break;
			}
		}
	} catch (e) {
		alert(e.message + ",error Row in:" + i);
		return false;
	}
	return saveFlag;
}
