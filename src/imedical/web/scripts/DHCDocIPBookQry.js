var m_CardNoLength=0;
var UDHCJFFlag=document.getElementById('UDHCJFFlag').value
function LookupLoc(str) {
    var arryTmp = str.split(CHR_Up);
    setElementValue("txtCtLoc", arryTmp[2]);
    setElementValue("txtCtLocDr", arryTmp[0]);
}
function txtCtLoc_lookuphandler(e) {
	if (evtName=='txtCtLoc') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var url='websys.lookup.csp';
		url += '?ID=d54222itxtCtLoc&CONTEXT=Kweb.UDHCJFIPReg:admdeplookup&TLUDESC='+encodeURI(t['txtCtLoc']);
		url += "&TLUJSF=LookUpadmdep";
		var obj=document.getElementById('txtCtLoc');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('CTLocID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		websys_lu(url,0,'');
		return websys_cancel();
	}
}

function btnQueryOnclick() {
	//增加查询输入条件
	var Regno=document.getElementById("Regno").value;
	var FromDate=getElementValue("txtFromDate");
	var ToDate=getElementValue("txtToDate");
	if (Regno!="")
	{
	if(UDHCJFFlag=="Y"){
		var FromDate="";
		var ToDate="";
		}
	else{
		var vaild = window.confirm("是否仅按照病人Id进行查询，不需要日期条件！");
		if(vaild)
		{
		var FromDate="";
		var ToDate="";
		}
	 }
	}
	var DocCreateBook=document.getElementById("DocCreateBook").value;
	var DocCreateBookId=document.getElementById("DocCreateBookId").value;
	if(DocCreateBook==""){var DocCreateBookId=""};
	var OrderOrCreateDate=document.getElementById("OrderOrCreateDate").checked;
	if (OrderOrCreateDate==false){var OrderOrCreateDate=1}else{var OrderOrCreateDate=2}
	if(getElementValue("txtPacWard")!="") var txtPacWardId=getElementValue("txtPacWardId")
	else var txtPacWardId=""
	if(getElementValue("txtCtLoc")!="") var txtAdmDepID=getElementValue("txtAdmDepID")
	else var txtAdmDepID=""
    var strURL = "./websys.default.csp?WEBSYS.TCOMPONENT=DHCDocIPBookList" + 
        "&FromDate=" + FromDate+
        "&ToDate="  + ToDate+
        "&CtLoc="  + txtAdmDepID+
        "&State=" + getElementValue("cboState")+
        "&RegNo=" + Regno+
        "&CtLocId=" + txtAdmDepID+
        "&PacWardId=" + txtPacWardId+
        "&DocCreateBookId=" + DocCreateBookId+
        "&OrderOrCreateDate=" + OrderOrCreateDate;
    window.parent.frames["RPList"].location.href = strURL;
    ///getElementValue("txtCtLocDr") +
}
function LookUpadmdep(str) {
    var obj = document.getElementById('txtAdmDepID');
    var tem = str.split("^");
    //alert(str)
    obj.value = tem[1];
    setElementValue("txtCtLoc", tem[0]);
    setElementValue("txtCtLocDr", tem[1]);
    setElementValue("txtPacWard", ""); 
    setElementValue("txtPacWardId", ""); 
}

function InitForm() {
    var arryStateDic = QueryDicItemByTypeFlag("MethodQueryDicItemByTypeFlag", "IPBookingState", "Y");
    var objDic = null;
    AddListItem("cboState", "", "");
    for (var i = 0; i < arryStateDic.length; i++) {
        objDic = arryStateDic[i];
        AddListItem("cboState", objDic.Desc, objDic.RowID)
    }
    MakeComboBox("cboState");
    InitEvents();
    var objState=document.getElementById("stateIndex")
    var objCboState=document.getElementById("cboState")
    if(objState) objCboState.selectedIndex=objState.value
    //btnQueryOnclick();
    document.getElementById("opcardno").focus();
    //添加医生的放大镜回车事件
    var obj=document.getElementById("DocCreateBook");
    if(obj) obj.onkeydown=DocCreateBookcondition;
    var obj=document.getElementById('ld54222iDocCreateBook');
	if (obj) {
		obj.onclick=DocCreateBookcondition;
		obj.onChange=DocCreateBookChangeHandler;
	}
    CtLocId=session['LOGON.CTLOCID'];
   	var status=document.getElementById("status").value;
    var obj=document.getElementById("CTLocID");
    if (obj){obj.value=CtLocId};
    if (status=="1")
    {Checkloc();}
    var obj=document.getElementById('Regno');
	if (obj) obj.onkeydown = RegnoKeydownHandler;
	
	//门/急诊科室的设置默认登录用户为开住院证医生
	var Rtn=tkMakeServerCall('web.DHCDocIPBookingCtl','IsMZLoc',session['LOGON.CTLOCID']);
	if (Rtn=="Y")
	{
		var ObjDoc=document.getElementById("DocCreateBook")
		if (ObjDoc){
			ObjDoc.value=session['LOGON.USERNAME']
		}
		var ObjDocID=document.getElementById("DocCreateBookId")
		if (ObjDocID){
			ObjDocID.value=session['LOGON.USERID']
		}
	}
    var obj=document.getElementById('txtCtLoc');
	if (obj) obj.onkeydown=txtCtLoc_lookuphandler;
	var obj=document.getElementById('ld54222itxtCtLoc');
	if (obj) obj.onclick=txtCtLoc_lookuphandler;
    var obj=document.getElementById('txtPacWard');
	if (obj) obj.onkeydown=txtPacWard_lookuphandler;
	var obj=document.getElementById('ld54222itxtPacWard');
	if (obj) obj.onclick=txtPacWard_lookuphandler;
	var obj=document.getElementById('txtFromDate');
	if (obj) obj.onkeydown=txtFromDate_lookuphandler;
	var obj=document.getElementById('ld54222itxtFromDate');
	if (obj) obj.onclick=txtFromDate_lookuphandler;
	var obj=document.getElementById('txtToDate');
	if (obj) obj.onkeydown=txtToDate_lookuphandler;
	var obj=document.getElementById('ld54222itxtToDate');
	if (obj) obj.onclick=txtToDate_lookuphandler;
	
	var Obj=document.getElementById("redo")
	if (Obj){
		Obj.onclick=RedoClickHandler;
	}

}
function RedoClickHandler(){
	var logonUserID=session['LOGON.USERID']
	var gnum=tkMakeServerCall("web.DHCDocIPBookingCtl","getnum",logonUserID)
	if((gnum=="")||(gnum=="0")){
		return false	
	}
	var Template,xlApp,xlsheet,xlBook
	var path = tkMakeServerCall("web.DHCDocIPBookingCtl","getpath")
	Template=path+"DHCDocIPBookingCtl.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
	xlsheet.cells(1,1)="登记号"
	xlsheet.cells(1,2)="病人姓名"
	xlsheet.cells(1,3)="性别"
	xlsheet.cells(1,4)="年龄"
	xlsheet.cells(1,5)="证件类型"
	xlsheet.cells(1,6)="证件号码"
	xlsheet.cells(1,7)="工作单位"
	xlsheet.cells(1,8)="家庭住址"
	xlsheet.cells(1,9)="门诊日期"
	xlsheet.cells(1,10)="住院科室"
	xlsheet.cells(1,11)="病房"
	xlsheet.cells(1,12)="医师"
	xlsheet.cells(1,13)="预计住院天数"
	xlsheet.cells(1,14)="门诊诊断"
	xlsheet.cells(1,15)="当前状态"
	xlsheet.cells(1,16)="录入人"
	xlsheet.cells(1,17)="入院病情"
	for (var i=1;i<=gnum;i++){
		
		var str=tkMakeServerCall("web.DHCDocIPBookingCtl","getdata","QueryBookByDateLoc",logonUserID,i)
		myData=str.split("^")    
		xlsheet.cells(i+1,1)=myData[0]
		xlsheet.cells(i+1,2)=myData[1]
		xlsheet.cells(i+1,3)=myData[2]
		xlsheet.cells(i+1,4)=myData[3]
		xlsheet.cells(i+1,5)=myData[15]
		xlsheet.cells(i+1,6)=myData[4]
		xlsheet.cells(i+1,7)=myData[5]
		xlsheet.cells(i+1,8)=myData[6]
		xlsheet.cells(i+1,9)=myData[7]
		xlsheet.cells(i+1,10)=myData[8]
		xlsheet.cells(i+1,11)=myData[9]
		xlsheet.cells(i+1,12)=myData[10]
		xlsheet.cells(i+1,13)=myData[11]
		xlsheet.cells(i+1,14)=myData[12]
		xlsheet.cells(i+1,15)=myData[13]
		xlsheet.cells(i+1,16)=myData[14]
		xlsheet.cells(i+1,17)=myData[16]
	}
	xlApp.Visible=true
	xlBook.Close (savechanges=true);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null
}
function txtToDate_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
     if (this.readOnly){ websys_cancel();}
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var obj=document.getElementById('txtToDate');
		if (!IsValidDate(obj)) return;
		var url='websys.lookupdate.csp?ID=txtToDate&TLUDESC='+t['txtToDate']+'&STARTVAL=';
		url += '&DATEVAL=' + escape(obj.value);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,0,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}

function txtFromDate_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
     if (this.readOnly){ websys_cancel();}
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var obj=document.getElementById('txtFromDate');
		if (!IsValidDate(obj)) return;
		var url='websys.lookupdate.csp?ID=txtFromDate&TLUDESC='+t['txtFromDate']+'&STARTVAL=';
		url += '&DATEVAL=' + escape(obj.value);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,0,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}
function txtPacWard_lookuphandler(e) {
	if (evtName=='txtPacWard') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var url='websys.lookup.csp';
		url += '?ID=d54222itxtPacWard&CONTEXT=Kweb.DHCDocIPBookingCtl:admwardlookup&TLUDESC='+encodeURI(t['txtPacWard']);
		url += "&TLUJSF=LookUpPacWard";
		var obj=document.getElementById('txtAdmDepID');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('txtPacWard');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		websys_lu(url,0,'');
		return websys_cancel();
	}
}
function RegnoKeydownHandler(e) {
	var key=websys_getKey(e);
	if (key==13) {
		var PatientNo=DHCC_GetElementData("Regno");
		if (PatientNo!='') {
			if (PatientNo.length<10) {
				for (var i=(10-PatientNo.length-1); i>=0; i--) {
					PatientNo="0"+PatientNo;
				}
			}
		}
		DHCC_SetElementData("Regno",PatientNo);
	}
	
}
//对科室进行检测并根据登录科室写死值
function Checkloc()
{	
	var CTLocID=document.getElementById('CTLocID').value;
	var obj=document.getElementById('CheckLoc');
 	if(obj) {var encmeth=obj.value} else {var encmeth=''};
	var ReturnValue=cspRunServerMethod(encmeth,CTLocID);
	if (ReturnValue!="")
	{
	var Str=ReturnValue.split("^");
	var LOCDesc=Str[1];
	var obj=document.getElementById('txtCtLoc');
	obj.value=LOCDesc;obj.disabled=true;  
	var obj=document.getElementById('ld53339itxtCtLoc');
	obj.disabled=true;
	var obj=document.getElementById('txtAdmDepID');
	obj.value=CTLocID;
	}
}

function DocCreateBookcondition(e)
{  
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		return DocCreateBook_lookuphandler();
	}
}
function DocCreateBook_lookuphandler() {
		var url='websys.lookup.csp';
		url += "?ID=d53339iDocCreateBook";
		url += "&CONTEXT=Kweb.UDHCJFIPReg:GetDocCreateBookInfo";
		url += "&TLUJSF=GetDocCreateBookInfoSelect";
		var obj=document.getElementById('DocCreateBook');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		websys_lu(url,0,'');
		return websys_cancel();
		
	
}
function DocCreateBookChangeHandler(){
	var obj=document.getElementById('DocCreateBook');
	if ((obj)&&(obj.value="")){
		var obj=document.getElementById("DocCreateBookId");
		if (obj) obj.value="";
	}
}
function GetDocCreateBookInfoSelect(Str)
{
		var Str=Str.split("^");
		var DocCreateBookId=document.getElementById("DocCreateBookId")
		DocCreateBookId.value=Str[1];
		
	
	}

function InitEvents() {
    document.getElementById("btnQuery").onclick = btnQueryOnclick;
	var readcard=document.getElementById('readcard');
	if (readcard) readcard.onclick=readcard_click; 
	var obj=document.getElementById('OPCardType');
	if (obj){
		obj.size=1
		obj.multiple=false;
		loadCardType()
		obj.onchange=OPCardType_OnChange;
	}

	var obj=document.getElementById('opcardno');
	if (obj) obj.onkeydown = CardNoKeydownHandler  //; CardNoKeydownHandler CardNo_KeyDown
	var obj=document.getElementById('Regno');
	if (obj) obj.onkeydown =RegNoKeydownHandler;
	websys_setfocus('opcardno');
	
	if(UDHCJFFlag=="Y"){
		var obj=document.getElementById('CanChange');
		var CanChange=obj.value
		var obj=document.getElementById('Regno');
		if (obj){
			if (CanChange=="N"){
				obj.disabled=true
			}
			if (obj.value!=""){
				window.parent.FindNum=(window.parent.FindNum+1)
				if (window.parent.FindNum==1){
					btnQueryOnclick();
				}
				}
		}
	 }
	
	
	
}
function loadCardType(){
	DHCWebD_ClearAllListA("OPCardType");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","OPCardType");	
	}
	OPCardType_OnChange()
}
function readcard_click()
{ 
	websys_setfocus('Regno');
	ReadCardClickHandler();  
}
function ReadCardClickHandler(){
	
	var CardTypeRowId=GetCardTypeRowId();
	//var CardEqRowId=GetCardEqRowId();
	//alert(CardEqRowId);
	var myoptval=DHCWeb_GetListBoxValue("OPCardType");
	var papnoobj=document.getElementById('Regno');

	//var myoptval=tempclear
	//通过读卡按钮时调用函数需要这个
	//m_CCMRowID=GetCardEqRowId();
	
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
	
	var myary=myrtn.split("^");
	
	var rtn=myary[0];
	//AccAmount=myary[3];
	switch (rtn){
			
		case "0": //
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				papnoobj.value=PatientNo
				document.getElementById("opcardno").value=CardNo
			break;
		case "-200": //
			alert(t['InvaildCard']);
			websys_setfocus('opcardno');
			break;
		case "-201": //
			//alert(t['21']);
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1];
				papnoobj.value=PatientNo
				document.getElementById("opcardno").value=CardNo								
			break;
		default:
	}
}
function OPCardType_OnChange()
{   var myoptval=DHCWeb_GetListBoxValue("OPCardType");	
	var myary=myoptval.split("^");		
	//myary[16]="Handle"
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR=="")
	{
		return;
	}
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("opcardno");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("readcard");
		
	}
	else
	{
		var myobj=document.getElementById("opcardno");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById("readcard");
		if (obj){
			obj.disabled=false;
			DHCC_AvailabilityBtn(obj)
			obj.onclick=ReadCardClickHandler;
		}
	}
	if (myary[16]=="Handle"){
		 websys_setfocus("opcardno");
	}else{
		 websys_setfocus("readcard");
	}
	
	m_CardNoLength=myary[17];
	
}
function GetCardTypeRowId(){
	var CardTypeRowId="";
	var CardTypeValue=DHCWeb_GetListBoxValue("OPCardType");
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId
}
/*function CardNoKeydownHandler()
{
	var key=websys_getKey(e);
	if (key==13) {
        var CardNo=DHCC_GetElementData("opcardno");
		for(var i=0; i<CardNo.length; i++)
		{
			if(CardNo.charAt(i)<'0' || CardNo.charAt(i)>'9')
			{
				CardNo=CardNo.replace(CardNo.charAt(i),"")
				i=i-1
			}
		}        
        var objCardNo=document.getElementById("opcardno");
        var cardLen=CardNo.length
        for(var i=0;i<15-cardLen;i++)
        {
	        CardNo="0"+CardNo
        }
        objCardNo.value=CardNo
        if (CardNo=="") return;
        var GetRegNoByCardNo=document.getElementById('GetRegNoByCardNo').value;
		var ret=cspRunServerMethod(GetRegNoByCardNo,CardNo);
		var regNoObj=document.getElementById('Regno');
		if((regNoObj)&&(ret!="")) 
		{
			regNoObj.value=ret;
			websys_setfocus('Regno');
			btnQueryOnclick();
		}
	}
}*/
function CardNoKeydownHandler(e) {
	if (evtName=='opcardno') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		var CardNoobj=document.getElementById("opcardno")
		if(CardNoobj){
		    CardNoobj.value=FormatCardNo();
		}
        var CardNo=DHCC_GetElementData("opcardno");
        var CardTypeRowId=GetCardTypeRowId();
				var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
				var myary=myrtn.split("^");
				var rtn=myary[0];
				var flag=0				
				switch (rtn){
					case "0": //
						var PatientID=myary[4];
						var PatientNo=myary[5];
						var CardNo=myary[1];
						var regNoObj=document.getElementById('Regno');
		        			regNoObj.value=PatientNo;
		        			document.getElementById("opcardno").value=CardNo;
		        			flag=1;			
						break;
					case "-200": //
						alert(t['InvaildCard']);
						websys_setfocus('opcardno');
						flag=0;
						break;
					case "-201": //
						var PatientID=myary[4];
						var PatientNo=myary[5];
						var CardNo=myary[1];
						var regNoObj=document.getElementById('Regno');
		        			regNoObj.value=PatientNo;
		        			document.getElementById("opcardno").value=CardNo;
		        			flag=1;
						break;
					default:
		}
		if(flag) {
			btnQueryOnclick();
		}
	}
}
function RegNoKeydownHandler()
{
	var key=websys_getKey(e);
	if (key==13) {
		var RegNoCon=document.getElementById('RegNoCon');
		var RegNo=document.getElementById('RegNo');
		if((RegNoCon)&&(RegNo.value!=""))
		{
			var ret=cspRunServerMethod(RegNoCon.value,RegNo.value);
			RegNo.value=ret;
			btnQueryOnclick();
		}
		
	}
}
function CardNo_KeyDown()
{    
	if(event.keyCode==13) {
		
	var obj=document.getElementById('HXSpecialCard'); //GetRegNoByCardNo
	if(obj)
	{  
		var oldCardNoObj=document.getElementById('opcardno');
		var cardno=	TranslateCard(obj,oldCardNoObj.value);
		oldCardNoObj.value=cardno;
		CardNoKeydownHandler();
	}
	}
}
function FormatCardNo(){
	var opcardno=document.getElementById('opcardno').value;
	if (opcardno!='') {
		if ((opcardno.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
			for (var i=(m_CardNoLength-opcardno.length-1); i>=0; i--) {
				opcardno="0"+opcardno;
			}
		}
	}
	return opcardno
}
function LookUpPacWard(str)
{
	var obj = document.getElementById('txtPacWard');
    var tem = str.split("^");
    obj.value = tem[1];
    setElementValue("txtPacWard", tem[0]);
    setElementValue("txtPacWardId", tem[1]);
    setElementValue("PacWardId", tem[1]);
    
}
window.onload = InitForm;

