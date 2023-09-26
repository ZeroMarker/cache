document.body.onload = BodyLoadHandler;
var SelectedRow=0;
var sttDate="";
var OrdsttDate="";
var OrdendDate="";
var ShowAllOrd="";
var DayLimit="";
var wardid="";
var j;
var colorodd=0;
var OrdColorSign;
var reOrdColorSign;
var myCombAry=new Array();
var EncryptObj=new Object();
var HospitalCode="";
var disflag;
function BodyLoadHandler() {
	EncryptObj=new DHCBodyLoadInitEncrypt();
	EncryptObj.GetAllEncrypt("web.DHCBodyLoadInitEncrypt.GetAllEncryptStr");
	var obj=document.getElementById("Find");
	if(obj) obj.onclick=findHandler;
	var obj=document.getElementById("PAPMINoItem");
	if(obj) obj.onkeydown=PAPMINoItemCheck;
	var obj=document.getElementById("CardNo");
	if(obj) obj.onkeydown=CardNoclick;
	var obj=document.getElementById("Name");
	if(obj) obj.onkeydown=Nameclick;
	var obj=document.getElementById("Insert");
	if(obj) obj.onclick=Insert;
	var obj=document.getElementById("Print");
	if(obj) obj.onclick=ContinuousOrderPrint;
	var obj=document.getElementById("SelectAll");
	if(obj) obj.onclick=SelectAllHandler;
	
	var orderFobj=document.getElementById('orderF');
	if (orderFobj) {
		orderFobj.onkeydown=orderlookF;
		orderFobj.onkeyup=clearorderidF;
	}
	var orderSobj=document.getElementById('orderS');
	if (orderSobj) {
		orderSobj.onkeydown=orderlookS;
		orderSobj.onkeyup=clearorderidS;
	}
	var orderTobj=document.getElementById('orderT');
	if (orderTobj) {
		orderTobj.onkeydown=orderlookT;
		orderTobj.onkeyup=clearorderidT;
	}

	var PackQtyFobj=document.getElementById('PackQtyF');
	if (PackQtyFobj){
		PackQtyFobj.onkeyup=DisablePackQtyTabEdit;
	}
	var PackQtySobj=document.getElementById('PackQtyS');
	if (PackQtySobj){
		PackQtySobj.onkeyup=DisablePackQtyTabEdit;
	}
	var PackQtyTobj=document.getElementById('PackQtyT');
	if (PackQtyTobj){
		PackQtyTobj.onkeyup=DisablePackQtyTabEdit;
	}
	
	var obj=document.getElementById('RecDep');
	if (obj){
		var DepStr=DHCC_GetElementData('DepStr');
		ComboRecDep=dhtmlXComboFromStr("RecDep",DepStr);
		ComboRecDep.enableFilteringMode(true);
		ComboRecDep.selectHandle=ComboRecDepselectHandle;
	}
	
	var DefDept=session['LOGON.CTLOCID'];
	
	var DepRowidobj=document.getElementById('DepRowid');
	if (DepRowidobj){
		//DepRowidobj.value=DefDept;
	}
	
	//如果没有选择过病区,则默认当前病区
	var wardid=DHCC_GetElementData("wardid");
	if (wardid=="") {
		var wardstr=GetWard(DefDept);
		if(wardstr!=""){
		   var wardstrArr=wardstr.split('^');
			document.getElementById('wardid').value=wardstrArr[0];
			document.getElementById('ward').value=wardstrArr[1];
		}
	}
	//ComboRecDep.setComboValue(DefDept);
	
	//DHCP_GetXMLConfig("InvPrintEncrypt","ContinuousOrderPrint");

	
	var Objtbl=document.getElementById('tDHCDocOrdRecDepPatientList');
	var Rows=Objtbl.rows.length;
	if (Rows>=2){
		for (var i=2;i<Rows;i++){
			OrdColorSign=document.getElementById('PatientIDz'+i).value;
			j=i-1;
			reOrdColorSign=document.getElementById('PatientIDz'+j).value;
			if (OrdColorSign!=reOrdColorSign){
				colorodd=colorodd+1;
				if (colorodd%2==1){
					Objtbl.rows(i).style.backgroundColor="#ffeeaa";  //ffeeaa  淡黄
				}
			}else{
				Objtbl.rows(i).style.backgroundColor=Objtbl.rows(j).style.backgroundColor;  
			}
			
		}
	}

	HospitalCode=DHCC_GetElementData('HospitalCode');
	
	//add by zhouzq 2010.12.16控制输入数字
	var obj=document.getElementById('PackQtyS');
	if (obj) {
		obj.onkeypress=Packqtykeypresshandler;
		obj.style.imeMode= "disabled";
	}
	var obj=document.getElementById('PackQtyT');
	if (obj) {
		obj.onkeypress=Packqtykeypresshandler;
		obj.style.imeMode= "disabled";
	}	
	var obj=document.getElementById('PackQtyF');
	if (obj) {
		obj.onkeypress=Packqtykeypresshandler;
		obj.style.imeMode= "disabled";
	}
	/*
	? 这一段是做什么的,不理解
	var obj=document.getElementById('TSRT');
	if (obj) {
		if (obj.value!=0){
			findHandler()
		}
	}
	*/
}
function Packqtykeypresshandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==45){window.event.keyCode=0;return websys_cancel();}
	if (((keycode>47)&&(keycode<58))||(keycode==46)){
		//add by zhouzq 2010.12.16  如果输入金额过长导致溢出计算有误
		var obj=websys_getSrcElement(e);
		if (obj.value.length>11) {
			window.event.keyCode=0;return websys_cancel();
		}
	}else{
		window.event.keyCode=0;return websys_cancel();
	}
}

function SelectAllHandler() {
	var chkobj=document.getElementById('SelectAll');
	var objtbl=document.getElementById('tDHCDocOrdRecDepPatientList');
	var rows=objtbl.rows.length;
	for (var i=1;i<=rows-1;i++){
  		var selobj=document.getElementById("Selectz"+i);
  		if (selobj){selobj.checked=chkobj.checked;}
  	}
	
}

//医嘱数量限制
function DisablePackQtyTabEdit(){
	if (disflag!=true){
		var Objtbl=document.getElementById('tDHCDocOrdRecDepPatientList');
		var Rows=Objtbl.rows.length;
		for (var j=1;j<Rows;j++){
			var CellObj=document.getElementById("Hours"+"z"+j);
			if (CellObj){
				CellObj.disabled=true;
				
			}
		}
		disflag=true;
	}
	
}
function findHandler() {
		var DepRowidobj=document.getElementById('DepRowid');
		var LocID=DepRowidobj.value;
    var obj=document.getElementById('sttDate');
    if (obj) {
    	sttDate=obj.value;
    	sttDate=sttDate.replace(/-/g,"");
  	}
  	var obj=document.getElementById('OrdsttDate');
    if (obj) {
    	OrdsttDate=obj.value;
    	//OrdsttDate=TransDate(OrdsttDate,"");
  	}
  	var obj=document.getElementById('OrdendDate');
    if (obj) {
    	OrdendDate=obj.value;
    	//OrdendDate=TransDate(OrdendDate,"");
  	}
  	var PAPMINoItem=DHCC_FormatPatNo("PAPMINoItem");
    var PatName=document.getElementById('Name').value;
    var CardNo=document.getElementById('CardNo');
    var DayLimitobj=document.getElementById('DayLimit');
    if (DayLimitobj){
    	DayLimit=DayLimitobj.value;;
  	}
    var ShowAllOrdobj=document.getElementById('ShowAllOrd');
    if ((ShowAllOrdobj)&&(ShowAllOrdobj.checked)){
    	ShowAllOrd="on";
  	}else{
  		ShowAllOrd="";
  	}
	var wardid="";
	var ward=DHCC_GetElementData("ward");
	if (ward!="") {
		var wardidobj=document.getElementById('wardid');
		if (wardidobj){
			wardid=wardidobj.value;
		}
	}
  	var LogonDep="",LogonUser="";
  	var obj=document.getElementById('LogonDep');
  	if(obj){if(obj.checked)LogonDep="on";}
	var obj=document.getElementById('LogonUser');
	if(obj){if(obj.checked)LogonUser="on";}
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocOrdRecDepPatientList&DepRowid="+LocID+"&sttDate="+sttDate+"&PAPMINoItem="+PAPMINoItem+"&Name="+PatName+"&CardNo="+CardNo.value+"&DayLimit="+DayLimit+"&OrdsttDate="+OrdsttDate+"&OrdendDate="+OrdendDate+"&ShowAllOrd="+ShowAllOrd+"&wardid="+wardid+"&ward="+ward+"&LogonDep="+LogonDep+"&LogonUser="+LogonUser+"&TSRT=0";
		window.location=lnk;
}
function ComboRecDepselectHandle(){
	try {
		
		var LocID=ComboRecDep.getSelectedValue();
    document.getElementById('DepRowid').value=LocID;
    findHandler();
	}catch(e){
		alert(e.message);
	}	
}
function PAPMINoItemCheck(e)	{
	//
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keydown')&&(key==9)) {
		var PAPMINoItem=document.getElementById('PAPMINoItem');
		DHCC_FormatPatNo("PAPMINoItem");
		websys_nextfocusElement(PAPMINoItem);
	}
	if ((type=='keydown')&&(key==13)) {
		var PAPMINoItem=document.getElementById('PAPMINoItem');
		DHCC_FormatPatNo("PAPMINoItem");
		findHandler();

	}

	
}
//卡号多少位需要修改
function CardNoclick(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keydown')&&(key==9)) {
		var CardNo=document.getElementById('CardNo');
		if (CardNo.value.length<12) {
			for (var i=(12-CardNo.value.length-1); i>=0; i--) {
				CardNo.value="0"+CardNo.value
			}
		}
		websys_nextfocusElement(CardNo);
	}
	if ((type=='keydown')&&(key==13)) {
		var CardNo=document.getElementById('CardNo');
		if (CardNo.value.length<12) {
			for (var i=(12-CardNo.value.length-1); i>=0; i--) {
				CardNo.value="0"+CardNo.value
			}
		}
		
		findHandler();
	}
}
function Nameclick(e){
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keydown')&&(key==13)) {
		findHandler();
	}
}

function TransDate(Datetem,Format){
	var tkClass='web.DHCDocOrdRecDepPatientList';
  var tkMethod='TransDate';
  var ret=tkMakeServerCall(tkClass,tkMethod,Datetem,Format);
  return ret;
}
function getwardid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('wardid');
	obj.value=val[1];

}
//插入持续吸氧医嘱

function Insert(){
	var paadmrowid="";
	var qty="";
	var ordrowidF="";
	var ordrowidS="";
	var ordrowidT="";
	var PackQtyF='';
	var PackQtyS='';
	var PackQtyT='';
	var ordidstr="";
  	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCDocOrdRecDepPatientList');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
  	if (lastrowindex=='0') {
  		return websys_cancel();
  	}
  	
  	var obj=document.getElementById('getorderidF');
  	if (obj){
	  	ordrowidF=DHCC_GetElementData("getorderidF");
		var PackQtyFObj=document.getElementById('PackQtyF');
	  	if (PackQtyFObj){PackQtyF=PackQtyFObj.value;}
	  	ordidstr=ordrowidF+String.fromCharCode(2)+PackQtyF;
	}
	var obj=document.getElementById('getorderidS');
  	if (obj){
	  	ordrowidS=DHCC_GetElementData("getorderidS");
  		var PackQtySObj=document.getElementById('PackQtyS');
  		if (PackQtySObj){PackQtyS=PackQtySObj.value;}
  		ordidstr=ordidstr+String.fromCharCode(1)+ordrowidS+String.fromCharCode(2)+PackQtyS;
  	}
  	var obj=document.getElementById('getorderidT');
  	if (obj){
	  	ordrowidT=DHCC_GetElementData("getorderidT");
  		var PackQtyTObj=document.getElementById('PackQtyT');
  		if (PackQtyTObj){PackQtyT=PackQtyTObj.value;}
  		ordidstr=ordidstr+String.fromCharCode(1)+ordrowidT+String.fromCharCode(2)+PackQtyT;
  	}
	//alert(ordidstr);
  	if(ordidstr=="")return;
  	var UserAddRowid=session['LOGON.USERID'];
  	var CTLOCRowid=session['LOGON.CTLOCID'];
	var flag=0;
	var admstr='';
	var beselected='';
  	for (var i=1;i<=lastrowindex;i++){
  		paadmrowid=document.getElementById("EpisodeIDz"+i).value;
  		qty=document.getElementById("Hoursz"+i).value;
  		var selobj=document.getElementById("Selectz"+i);
	  	if ((selobj)&&(selobj.checked==true)){
	  		beselected='on';
			if((+qty==0)&&(+PackQtyF==0)&&(+PackQtyS==0)&&(+PackQtyT==0)){
				alert("请先填写医嘱数量")
				return false;
			}
			if((+qty==0)&&(+PackQtyF==0)&&(ordrowidF!="")){
				alert("请先填写补录的第一条医嘱的数量")
				return false;
			}
			if((+qty==0)&&(+PackQtyS==0)&&(ordrowidS!="")){
				alert("请先填写补录的第二条医嘱的数量")
				return false;
			}
			if((+qty==0)&&(+PackQtyT==0)&&(ordrowidT!="")){
				alert("请先填写补录的第三条医嘱的数量")
				return false;
			}
	  	}else{
	  		beselected='';
	  	}
		//alert(paadmrowid+"^"+qty)
  		var CheckOrgStrRet=CheckIfOrgStr(paadmrowid,qty,beselected);
	  	if (CheckOrgStrRet==true){
	  		if (admstr==''){
	  			admstr=paadmrowid+String.fromCharCode(2)+qty;
	  		}else{
	  			admstr=admstr+String.fromCharCode(1)+paadmrowid+String.fromCharCode(2)+qty;
	  		}
	  	}
  	}
  	//alert(paadmrowid+","+CheckOrgStrRet+","+admstr)
  	if (admstr==''){
  		alert(t['NoPat']);
  		return;
  	}
  
  	var Insertret=cspRunServerMethod(EncryptObj.InsertContinuousOrder,admstr,UserAddRowid,CTLOCRowid,ordidstr);
  	if (Insertret=='0'){
  		alert(t['InsertOrdOK'])
  	}else{
  		alert("操作失败");
  	}
  
}

function CheckIfOrgStr(paadmrowid,qty,beselected){
	if (HospitalCode==''){
		if (beselected=='on'){
			return true;
		}else{
			return false;
		}
	}else{
		if ((paadmrowid!="")&&(qty!="")&&(qty!="0")){
			return true;
		}else{
			return false;
		}
	}
	return true;
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCDocOrdRecDepPatientList');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	

	var Excuteobj=document.getElementById("ExecuteFlagz"+selectrow);
	if (Excuteobj.checked==true){
		ExcuteFlag="Y";

		var ExcuCheck=confirm((t['ExcuteOrd']),true);
		if (ExcuCheck==false){
	    return;
		}else{
		  var DHCEpisodeID=document.getElementById("EpisodeIDz"+selectrow).value;
		  var DHCOEORIRowid=document.getElementById("OEORIRowidz"+selectrow).value;
		  var tkClass='web.DHCDocOrdRecDepPatientList';
		  var tkMethod='ExcuteRecDepOrd';
		  var ret=tkMakeServerCall(tkClass,tkMethod,DHCEpisodeID);
		  //逐条执行医嘱
		  //var ret=tkMakeServerCall(tkClass,tkMethod,DHCEpisodeID,DHCOEORIRowid);
		  if(ret==0){
		  	alert(t['success']);
		  	window.treload('websys.csp');
		  }else if(ret=="NoAdm"){
		  	alert(t['NoAdm']);
		  	return;
		  }else if(ret=="NoOrd"){
		  	alert("请选择医嘱");
		  	return;
		  }else if(ret=="F"){
		  	alert(t['Fail']);
		  	return;
		  }else{
		  	alert(ret);
		  	alert(t['Fail']);
		  	window.treload('websys.csp');
		  };
		}
  }
	SelectedRow = selectrow;
}
function ContinuousOrderPrint(){
	var TemplatePath;
	//s val=##Class(%CSP.Page).Encrypt($lb("web.UDHCJFCOMMON.getpath"))
	var tkClassPath='web.UDHCJFCOMMON';
	var tkMethodPath='getpath';
	TemplatePath=tkMakeServerCall(tkClassPath,tkMethodPath,'','');

	
	var xlApp,xlsheet,xlBook
	TemplatePath=TemplatePath+"ContinuousOrderDetail.xls";
	
	//alert("TemplatePath"+":"+TemplatePath);
	
  xlApp = new ActiveXObject("Excel.Application");
  xlBook = xlApp.Workbooks.Add(TemplatePath);
  xlsheet = xlBook.ActiveSheet;
  xlsheet.PageSetup.LeftMargin=0;  
  xlsheet.PageSetup.RightMargin=0;


	var xlsCurcol=1;
	var wardidobj=document.getElementById('wardid');
  if (wardidobj){
  	wardid=wardidobj.value;
	}      
  if (wardid==''){
  	alert("请选择病区!")
  	return;
  }
  
  
	var tkClass='web.DHCDocOrdRecDepPatientList';
	var tkMethod='GetWardPatListStr';
	var WardPatListStr=tkMakeServerCall(tkClass,tkMethod,wardid);
	var SeqNo="";
	var MedNo="";
	var bedID="";
	var PatName="";
	var NumberVal="";
	var Time="";
	var HourInput="";
	var NurseCode="";
	var Doc="";
	
	//alert("WardPatListStr"+":"+WardPatListStr)
	
	var WardPatListStrArr=WardPatListStr.split("!");
	if (WardPatListStrArr[0]){
		var len=WardPatListStrArr.length;
		for (var i=0;i<=len-1;i++){
			//打印len行
			//alert("i"+i+"WardPatListStrArr[i]"+WardPatListStrArr[i])
			var PatListStr1Arr=WardPatListStrArr[i].split("^");
			if (PatListStr1Arr[0]){
				SeqNo=PatListStr1Arr[0];
				MedNo=PatListStr1Arr[1];
				bedID=PatListStr1Arr[2];
				PatName=PatListStr1Arr[3];
				NumberVal=PatListStr1Arr[4];
				Time=PatListStr1Arr[5];
				HourInput=PatListStr1Arr[6];
				NurseCode=PatListStr1Arr[7];
				Doc=PatListStr1Arr[8];
			
				xlsheet.cells(i+1,xlsCurcol)=SeqNo;
				xlsheet.cells(i+1,xlsCurcol+1)=MedNo;
				xlsheet.cells(i+1,xlsCurcol+2)=bedID;
				xlsheet.cells(i+1,xlsCurcol+3)=PatName;
				xlsheet.cells(i+1,xlsCurcol+4)=NumberVal;
				xlsheet.cells(i+1,xlsCurcol+5)=Time;
				xlsheet.cells(i+1,xlsCurcol+6)=HourInput;
				xlsheet.cells(i+1,xlsCurcol+7)=NurseCode;
				xlsheet.cells(i+1,xlsCurcol+8)=Doc;
			}
		}	
	}

	gridlist(xlsheet,1,i,1,9);

	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;	
}
function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr='';
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject('MSXML2.DOMDocument.4.0');
		docobj.async = false;    //close
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)			
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

function GetWard(locrowid){
	var tkClass='web.DHCDocOrdRecDepPatientList';
  var tkMethod='GetWardStr';
  var ret=tkMakeServerCall(tkClass,tkMethod,locrowid);
  return ret;
}
function orderlookF(){
	if (window.event.keyCode==13){  
		window.event.keyCode=117;
	  orderF_lookuphandler();
	}
}
function orderlookS(){
	if (window.event.keyCode==13){  
		window.event.keyCode=117;
	  orderS_lookuphandler();
	}
}
function orderlookT(){
	if (window.event.keyCode==13){  
		window.event.keyCode=117;
	  orderT_lookuphandler();
	}
}
function getorderidF(value)	{
	var val=value.split("^");
	var OrderType=val[3]
	if(OrderType!="ARCIM"){
		alert("请选择具体的医嘱项目,不能选择医嘱套");
		var obj=document.getElementById('orderF')
		obj.value=""
		websys_setfocus('orderF')
		return false;
	}
	var obj=document.getElementById('getorderidF');
	obj.value=val[1];

}
function getorderidS(value)	{
	var val=value.split("^");
	var OrderType=val[3]
	if(OrderType!="ARCIM"){
		alert("请选择具体的医嘱项目,不能选择医嘱套");
		var obj=document.getElementById('orderS')
		obj.value=""
		websys_setfocus('orderS')
		return false;
	}
	var obj=document.getElementById('getorderidS');
	obj.value=val[1];
}
function getorderidT(value)	{
	var val=value.split("^");
	var OrderType=val[3]
	if(OrderType!="ARCIM"){
		alert("请选择具体的医嘱项目");
		var obj=document.getElementById('orderT')
		obj.value=""
		websys_setfocus('orderT')
		return false;
	}
	var obj=document.getElementById('getorderidT');
	obj.value=val[1];
}
function clearorderidF(){
	var obj=document.getElementById('getorderidF');
	obj.value="";
}
function clearorderidS(){
	var obj=document.getElementById('getorderidS');
	obj.value="";
}
function clearorderidT(){
	var obj=document.getElementById('getorderidT');
	obj.value="";
}
