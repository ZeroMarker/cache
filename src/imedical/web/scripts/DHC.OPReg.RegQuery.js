//DHC.OPReg.RegQuery.js
var SelectedRow=0;
var Status;
var comb_CardTypeDefine;
var combo_CardType;

function BodyLoadHandler() {
	var Obj=document.getElementById('Export');
	if (Obj) Obj.onclick = Export_click;	
	var Obj=document.getElementById('Bclear');
	if (Obj) Obj.onclick = Clear_click;
	var Obj=document.getElementById('Reprint');
	if (Obj) Obj.onclick = ReprintClickHandler;
	
	var Obj=document.getElementById('CardNo');
	if (Obj) Obj.onkeydown=CardNokeydownHander;
	var Obj=document.getElementById('RegNo');
	if (Obj) {Obj.onkeydown=RegNoKeyDownHandler;}
	var staobj=document.getElementById("status")
	//alert(staobj)
	if (staobj){Status=staobj.value;
	   if (Status==""){
			var tmp=document.getElementById("Ghuse");
			tmp.value=session['LOGON.USERNAME'];
			//tmp.Disabled=true;
			//tmp.readOnly=true;
			var Myobj=document.getElementById('Myid');	
			var imgname="ld"+Myobj.value+"i"+"Ghuse"
			var tmp1=document.getElementById(imgname);
			//tmp1.style.display="none";
			var tmp=document.getElementById("SuseID");
		   tmp.value=session['LOGON.USERID'];
		}
	}
	var GhuseObj=document.getElementById("Ghuse");
	if (GhuseObj) GhuseObj.onchange = GhuseObj_Changed

	var myobj=document.getElementById('RLocdesc');
	var myobjH=document.getElementById('RLoc');
	if(myobj.value==""){
		myobjH.value=""
	}
	var myobj=document.getElementById('RDocdesc');
	var myobjH=document.getElementById('RDoc');
	if(myobj.value==""){
	myobjH.value=""
	}
	ReadCardType();
	//卡类型
	var obj=document.getElementById('CardType');
	//因为dhtmlXComboFromSelect要判断isDefualt属性,
	if (obj) obj.setAttribute("isDefualt","true");
	combo_CardType=dhtmlXComboFromSelect("CardType");
	
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
	}
	
	combo_CardTypeKeydownHandler();
	ShowTotal()
	ChangeCss()
	//GetUserLocation()
	//姓名回车自动查询 2017-4-24 LX
	var obj=document.getElementById("PatName");
	if(obj) {obj.onkeydown=PatNameKeyDownHandler;}
	
	var obj=document.getElementById('PayMode');
	if(obj){
		obj.multiple=false;;
		obj.size=1;
		if (obj) obj.setAttribute("isDefualt","true");
		//obj.onclick=combo_PayModeKeydownHandler;
	}
	ReadPayMode();
	
}
function ReadPayMode(){
	DHCC_ClearList("PayMode");
	var encmeth=DHCWebD_GetObjValue("PayModeEncrypt");
	var mygLoc=session['LOGON.GROUPID'];
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PayMode");
	}
}
function Export_click() 
{

	var path=tkMakeServerCall("web.UDHCJFCOMMON","getpath");
	var Template=path+"DHCOPRegRegQuery.xls";
	try{
		var oXL = new ActiveXObject("Excel.Application"); 
		var oWB = oXL.Workbooks.Add(Template); 
		var oSheet = oWB.ActiveSheet; 
		var UserID=session['LOGON.USERID'];
		var mainrows=tkMakeServerCall("web.DHCOPRegReports","getRegQueryNum",UserID,"");
		for (i=0;i<mainrows;i++){
			var PrintSet=tkMakeServerCall("web.DHCOPRegReports","getRegQueryNum",UserID,i+1);
			//alert(i+"PrintSet="+PrintSet)
			var sstr=PrintSet.split("^")
			for (j=0;j<sstr.length;j++) {
				oSheet.Cells(i+2,j+1).value =sstr[j];
			}
		}
		//oXL.Visible = true; 
		//oXL.UserControl = true;
        alert("文件将保存在您的E盘根目录下");		
		var savePath="E:\\挂号查询明细.xls";
		oSheet.saveas(savePath);
		oWB.Close (savechanges=false);
		oXL.Quit();
		oXL=null;
		oSheet=null;
	}
	catch(e) {
		alert( "要打印该表?A您必须安装Excel电子表格软件,同时浏览器须使用'ActiveX 控件',您的浏览器须允许执行控件?C 请点击?i帮助?j了解浏览器设置方法?I");
		return "";
	}
	
}
function GetCardEqRowId(){
	var CardEqRowId="";
	var CardTypeValue=combo_CardType.getSelectedValue();
	
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardEqRowId=CardTypeArr[14];
	}
	return CardEqRowId;
}

function combo_CardTypeKeydownHandler(){
	var myoptval=combo_CardType.getSelectedValue();
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR=="")	{	return;	}
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj){myobj.readOnly = false;}
		DHCWeb_DisBtnA("ReadCard");
		DHCWeb_setfocus("CardNo");
	}else{
		m_CCMRowID=GetCardEqRowId();
	}
	if (myary[16]=="Handle"){
		//DHCWeb_setfocus("CardNo");
	}else{
		//DHCWeb_setfocus("ReadCard");
	}
	
	if (combo_CardType) websys_nexttab(combo_CardType.tabIndex);
}
function ReadCardType(){
	DHCC_ClearList("CardType");
	var encmeth=DHCC_GetElementData("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardType");
	}
}

function GetCardNoLength(){
	var CardNoLength="";
	var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	return CardNoLength;
}

function CardNokeydownHander(e)
{
	var key=websys_getKey(e);
	if (key==13) {
	var Obj=document.getElementById('CardNo');
	Obj.value=FormatCardNo();
	Bfind_click();
	}
}
function FormatCardNo(){
	var CardNo=document.getElementById('CardNo').value;
	if (CardNo!='') {
		var CardNoLength=GetCardNoLength(); 
		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}
	return CardNo
}

function RegNoKeyDownHandler(e){
	var key=websys_getKey(e);
	if(key==13){
	var RegNo=document.getElementById('RegNo').value;
	if (RegNo!='') {
		var RegNoLength=10;
		if ((RegNo.length<RegNoLength)&&(RegNoLength!=0)) {
			for (var i=(RegNoLength-RegNo.length-1); i>=0; i--) {
				RegNo="0"+RegNo;
			}
		}
	}
	document.getElementById('RegNo').value=RegNo
	Bfind_click();
	}
}
function GetUserLocation(){
	var GetDetail=document.getElementById('GetUserLocMethod');
	if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
		
	var Rtn=cspRunServerMethod(encmeth,session['LOGON.CTLOCID'],session['LOGON.USERID'])
	if (Rtn!=""){
		if (Rtn=="E") {
			 var Obj=document.getElementById('East');
			 if (Obj) Obj.checked=true;
		}
		if (Rtn=="W") {
			 var Obj=document.getElementById('West');
			 if (Obj) Obj.checked=true;
		}

	}
	
	
}

function GhuseObj_Changed(){
	var GhuseObj=document.getElementById("Ghuse");
	var SuseIDObj=document.getElementById("SuseID");
	if (GhuseObj.value==""){
		SuseIDObj.value=""
	}
}
function uselook(str) {
	
	if (Status==""){
		var tmp=document.getElementById("SuseID");
		tmp.value=session['LOGON.USERID'];
	}
	else{	
	var obj=document.getElementById('SuseID');
	var tem=str.split("^");
	obj.value=tem[1];
	}

}

function INVStatusCSS()             //
{
	var mywinname="DHC_OPReg_RegQuery";
	var myTabName="t"+mywinname;
	var myColStr="TAbort";   
	var myValStr="1";
	var myCSSNameStr="OPInvAbort";
	var myExpStr="";
	DHCWebTabCSS_SetRowColorByCol(myTabName,myColStr, myValStr, myCSSNameStr, myExpStr);
}

function ChangeCss(){
	var objtbl=document.getElementById('tDHC_OPReg_RegQuery');
	var myRows=objtbl.rows.length;
	var myCols=objtbl.cols.length;
	
	try{
		for(var i=1;i<myRows;i++){
			var eSrc=objtbl.rows[i];
			var mycurrowobj=getRow(eSrc);
			var mycurobj=document.getElementById("TRefTimez"+i);
			var tmpvalue=mycurobj.innerText
			if (tmpvalue.length>1){	
			   //for (var j=0;j<mycollen;j++){
					//var mycurobj=document.getElementById(ColAry[j]+"z"+i);			
					mycurrowobj.className="OPInvAbort";
			   //}
				//break;
			}
			
			
		}
	}catch(e){
		alert(e.message);
	}
}

function ShowTotal()
{
	var objtbl=document.getElementById('tDHC_OPReg_RegQuery');
	var rows=objtbl.rows.length;
	
	if (rows>1) {
		var index=rows-1
		var TobjTotal=document.getElementById("TTotalz"+1);
    	//alert(TobjTotal.value)
		
		var objTotal=document.getElementById('Total');
    	if (objTotal) objTotal.value=TobjTotal.value;
	}
}

function Clear_click(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.OPReg.RegQuery";
	if(typeof websys_writeMWToken=='function') lnk=websys_writeMWToken(lnk);
	window.location.href=lnk;
}

function LoclookupSelect(str){
	var lu = str.split("^");
	var obj=document.getElementById("RLocdesc")
	if (obj) obj.value = lu[0];
	var obj=document.getElementById("RLoc")
	if (obj) obj.value = lu[1];
	var obj=document.getElementById("RDocdesc")
	if (obj) obj.value = "";
	var obj=document.getElementById("RDoc")
	if (obj) obj.value = "";
	
}

function DoclookupSelect(str){
	var lu = str.split("^");
	var obj=document.getElementById("RDocdesc")
	if (obj) obj.value = lu[0];
	var obj=document.getElementById("RDoc")
	if (obj) obj.value = lu[1];
}

function RTypelookup(str){
	var lu = str.split("^");
	var obj=document.getElementById("RTypedesc")
	if (obj) obj.value = lu[0];
	var obj=document.getElementById("RType")
	if (obj) obj.value = lu[1];
}
function ReprintClickHandler(e){
  DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
	var obj=document.getElementById('Reprint');
	if (obj.style.display=='none') return;
	
	selectrow=SelectedRow;
	if (selectrow!="0"){
		var RegRowId=DHCC_GetColumnData('TRegisFee',selectrow);
		var userid=session['LOGON.USERID'];	
		var groupid=session['LOGON.GROUPID'];	
		var ctlocid=session['LOGON.CTLOCID'];
		
	  //var encmeth=DHCC_GetElementData('RePrintMethod'); 
	  
	   //web.DHCOPAdmReg.RePrintBroker
		
			var ret=tkMakeServerCall("web.DHCOPAdmReg","GetPrintData",RegRowId,"","Y");
			//var ret=cspRunServerMethod(encmeth,'','',RegRowId,userid,groupid,ctlocid)
				PrintOut(ret);
				alert(t['RePrintOk']);
				
		
	}else{
		alert(t['NotSelectReprintRow']);	
	}	
}
function PrintOut(PrintData) {
	try {
		if (PrintData=="") return;
		var PrintArr=PrintData.split("^");
		var AdmNo=PrintArr[0];
		var PatName=PrintArr[1];
		var RegDep=PrintArr[2];
		var DocDesc=PrintArr[3];
		var SessionType=PrintArr[4];
		var MarkDesc=DocDesc
		
		var AdmDateStr=PrintArr[5];
		var TimeRange=PrintArr[6];
		var AdmDateStr=AdmDateStr+" "+TimeRange;
		
		var SeqNo=PrintArr[7];
		var RoomNo=PrintArr[8];
		var RoomFloor=PrintArr[9];
		var UserCode=PrintArr[10];
		var RegDateYear=PrintArr[12];
		var RegDateMonth=PrintArr[13];
		var RegDateDay=PrintArr[14];
		var TransactionNo=PrintArr[15];
		
		var Total=PrintArr[16];
		var RegFee=PrintArr[17];
		var AppFee=PrintArr[18];
		var OtherFee=PrintArr[19];
		var ClinicGroup=PrintArr[20];
		var RegTime=PrintArr[21];
		var ExabMemo=PrintArr[23];
		var InsuPayCash=PrintArr[24];
		var InsuPayCount=PrintArr[25];
		var InsuPayFund=PrintArr[26];
		var InsuPayOverallPlanning=PrintArr[27];
		var InsuPayOther=PrintArr[28];
		var TotalRMBDX=PrintArr[29];
		var INVPRTNo=PrintArr[30];
		var CardNo=PrintArr[31];
		var Room=PrintArr[32];
		var AdmReason=PrintArr[33];
		var Regitems=PrintArr[34];
		var AccBalance=PrintArr[35];
		var PatNo=PrintArr[36];
		var TimeRangeInfo=PrintArr[37];
		var HospitalDesc=PrintArr[38];
		var PersonPay=PrintArr[39];
		var YBPay=PrintArr[40];
		var DYIPMRN=PrintArr[41];
		var RowID=PrintArr[42];
		var MyList="";
		for (var i=0;i<Regitems.split("!").length-1;i++){
			var tempBillStr=Regitems.split("!")[i];
			if (tempBillStr=="") continue;
			var tempBillDesc=tempBillStr.split("[")[0];
			var tempBillAmount=tempBillStr.split("[")[1];
			if (MyList=="") MyList=tempBillDesc+"   "+tempBillAmount;
			else  MyList = MyList + String.fromCharCode(2)+tempBillDesc+"   "+tempBillAmount;
		}

		//病人自负比例的备注
		var ProportionNote="";
		var ProportionNote1="";
		var ProportionNote2="";
		InsuPayCash="";
		InsuPayCount="";
		InsuPayOverallPlanning="";
		InsuPayOther="";
		ProportionNote="本收据中,"+RegFee+"元"+"不属于医保报销范围";
		ProportionNote1="";
		ProportionNote2="";
		
		var NeedCardFee=DHCC_GetElementData('NeedCardFee');
		var CardFee=DHCC_GetElementData('CardFee');
 		if (NeedCardFee==true){
 			var CardFee="工本费 "+parseFloat(CardFee)+"元";
 		}else{
 			var CardFee="";
 		}
 		
		RegTime=RegDateYear+"-"+RegDateMonth+"-"+RegDateDay+" "+RegTime
		
		if (AccBalance=="") AccBalance=0;
		//重打不显示消费金额。
		//消费后金额
		AccTotal="" //SaveNumbleFaxed(AccBalance);
		//消费前金额
    	AccAmount="" //SaveNumbleFaxed(parseFloat(AccBalance)+parseFloat(Total));
		var cardnoprint=DHCC_GetElementData('CardNo');
		if (cardnoprint=="") cardnoprint=DHCC_GetColumnData('TPatCardNo',SelectedRow); 
		var TimeD=TimeRange;

		if (AppFee!=0){AppFee="预约费:"+AppFee}else{AppFee=""}
		if (OtherFee!=0) {OtherFee="治疗费:"+OtherFee}else{OtherFee=""}
		var PDlime=String.fromCharCode(2);
		var MyPara="AdmNo"+PDlime+AdmNo+"^"+"PatName"+PDlime+PatName+"^"+"TransactionNo"+PDlime+TransactionNo+"^"+"AccTotal"+PDlime+AccTotal+"^"+"AccAmount"+PDlime+AccAmount;
		var MyPara=MyPara+"^"+"MarkDesc"+PDlime+MarkDesc+"^"+"AdmDate"+PDlime+AdmDateStr+"^"+"SeqNo"+PDlime+SeqNo+"^RegDep"+PDlime+RegDep;
		var MyPara=MyPara+"^"+"RoomFloor"+PDlime+RoomFloor+"^"+"UserCode"+PDlime+UserCode;
		var MyPara=MyPara+"^"+"RegDateYear"+PDlime+RegDateYear+"^RegDateMonth"+PDlime+RegDateMonth+"^RegDateDay"+PDlime+RegDateDay;
		var MyPara=MyPara+"^"+"Total"+PDlime+Total+"^RegFee"+PDlime+RegFee+"^AppFee"+PDlime+AppFee+"^OtherFee"+PDlime+OtherFee;
		var MyPara=MyPara+"^"+"RoomNo"+PDlime+RoomNo+"^"+"ClinicGroup"+PDlime+ClinicGroup+"^"+"SessionType"+PDlime+SessionType+"^"+"TimeD"+PDlime+TimeD+"^"+"RegTime"+PDlime+RegTime+"^"+"cardnoprint"+PDlime+cardnoprint;
		var MyPara=MyPara+"^"+"INVPRTNo"+PDlime+INVPRTNo;
		var MyPara=MyPara+"^"+"TimeRangeInfo"+PDlime+TimeRangeInfo;
		var MyPara=MyPara+"^"+"YBPay"+PDlime+YBPay;
		var MyPara=MyPara+"^"+"PersonPay"+PDlime+PersonPay;
		var MyPara=MyPara+"^"+"RowID"+PDlime+RowID;
		var MyPara=MyPara+"^"+"DYIPMRN"+PDlime+Trim(DYIPMRN);
		var MyPara=MyPara+"^"+"ExabMemo"+PDlime+ExabMemo;
		var MyPara=MyPara+"^"+"PatNo"+PDlime+PatNo;       //打印登记号
		var MyPara=MyPara+"^"+"HospName"+PDlime+HospitalDesc;
		var myobj=document.getElementById("ClsBillPrint");
		PrintFun(myobj,MyPara,"");	
	} catch(e) {alert(e.message)};
}

function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
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
function SaveNumbleFaxed(str)
{
	var len,StrTemp;	
	if((str=="")||(!str)) return 0;
	if(parseInt(str)==str){
		str=str+".00";
		}else{
		StrTemp=str.toString().split(".")[1];
		len=StrTemp.length;
		if(len==1){
			str=str+"0";
		}else{
			var myAry=str.toString().split(".");
			str=myAry[0]+"."+myAry[1].substring(0,2);
		}
	}
	
	return str;
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHC_OPReg_RegQuery');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	if (selectrow!=SelectedRow){
	SelectedRow = selectrow;
	}else{SelectedRow=0}
}
function PatNameKeyDownHandler(e)
{
	var key=websys_getKey(e);
	if(key==13){ Bfind_click();}
	return 	
}
function DHCRegConDisLook(str) {
	if (str=="") return false;
	var tem=str.split("^");
	var obj=document.getElementById('DRCDRowid');
	if (obj){obj.value=tem[1];}
	var obj=document.getElementById('DRCDDesc');
	if (obj) {obj.value=tem[0];}	
}
document.body.onload = BodyLoadHandler;
