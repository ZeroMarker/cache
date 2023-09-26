//DHCPEPreIADM.Edit.js
document.write("<OBJECT ID='Photo2' CLASSID='CLSID:3B5FF267-69BD-41DB-BA9E-6F6F94551840' CODEBASE='../addins/client/Photo.CAB#version=2,1,0,1'></OBJECT>");
document.write("<object ID='ClsIDCode' WIDTH=0 HEIGHT=0 CLASSID='CLSID:299F3F4E-EEAA-4E8C-937A-C709111AECDC' CODEBASE='../addins/client/ReadPersonInfo.CAB#version=1,0,0,8' VIEWASTEXT>");
document.write("</object>");
var TFORM="";
var IDCardSave="";
var picType=".jpg"
var PicFilePath="D:\\"
var IDCardPicture = "c:\\"
var myItemNameAry=new Array();
var myCombAry=new Array();  ///Add by wangkai
myItemNameAry[1]="PAPMINo";
myItemNameAry[3]="Sex_DR_Name";
myItemNameAry[4]="PatType_DR_Name";
myItemNameAry[5]="Vocation";
myItemNameAry[6]="Blood_DR_Name";
myItemNameAry[7]="Married_DR_Name";
myItemNameAry[8]="DOB";
//myItemNameAry[9]="VIPLevel";
myItemNameAry[10]="MobilePhone";
myItemNameAry[11]="Age";
myItemNameAry[12]="IDCard";
myItemNameAry[2]="Name";
myItemNameAry[13]="CardNo";
myItemNameAry[14]="Tel1";
myItemNameAry[15]="Nation"
myItemNameAry[16]="PEDateBegin"
myItemNameAry[17]="PEDateEnd"
myItemNameAry[18]="VIPLevel"
myItemNameAry[19]="GetReportDate"
myItemNameAry[20]="Update"
myItemNameAry[21]="Address"
myItemNameAry[22]="PatFeeType_DR_Name"
myItemNameAry[23]="PEDateBegin"
function Doc_OnKeyDown()
   {   
       //alert(event.keyCode+"5123")
	   if (event.keyCode==115)
       {
	    ReadCard_Click();
		
       }
       if (event.keyCode==120)
       {
	   	ReadRegInfo_OnClick();
	   }
   }
function ReadRegInfo_OnClick()
  { 
   // alert('2')
   var myInfo=ClsIDCode.ReadPersonInfo();
   var myary=myInfo.split("^");
    
     if (myary[0]=="0")
    { 
      SetPatInfoByXML(myary[1]); 
      var mySexobj=document.getElementById("Sex");
	  var mySex_DR_Nameobj=document.getElementById('Sex_DR_Name');
		if ((mySexobj)&&(mySex_DR_Nameobj)){
			mySex_DR_Nameobj.value=mySexobj.value;   
		}
	  var myBirobj=document.getElementById("Birth");
	  var myDOBobj=document.getElementById('DOB');   	
	
		if ((myBirobj)&&(myDOBobj)){
			myDOBobj.value=myBirobj.value;   
		}
	  var mycredobj=document.getElementById("CredNo");
	  var myidobj=document.getElementById('IDCard');
		if ((mycredobj)&&(myidobj)){
			myidobj.value=mycredobj.value;
		}	
     }
     IDReadControlDisable(true);
	 IDCardOnChange();
	 ShowPicBySrc(IDCardPicture+mycredobj.value+".bmp","imgPic")
   }
function IDReadControlDisable(bFlag)
{ 
	var myobj=document.getElementById("IDCard");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Name");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Sex_DR_Name");
	if (myobj){
		myobj.readOnly=bFlag;
	}

	var myobj=document.getElementById("DOB");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Address");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Age");
	if (myobj){
		myobj.readOnly=bFlag;
	} 
}

function SetPatInfoByXML(XMLStr)
{
	///XMLStr ="<PatInfo>"+XMLStr;
	///XMLStr +="</PatInfo>";
	XMLStr ="<?xml version='1.0' encoding='gb2312'?>"+XMLStr
	
	var xmlDoc=DHCDOM_CreateXMLDOM();
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if(xmlDoc.parseError.errorCode != 0) 
	{    
		alert(xmlDoc.parseError.reason); 
		return; 
	}

	var nodes = xmlDoc.documentElement.childNodes; 
	for(var i=0; i<nodes.length; i++) 
	{
		
		var myItemName=nodes(i).nodeName;
		var myItemValue= nodes(i).text;
		if (myCombAry[myItemName]){
			myCombAry[myItemName].setComboValue(myItemValue);

		}else{
			DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		}
	}
	delete(xmlDoc);
}
//end 
//////the function of reading Medical insurance card added by wangkai


	
function ReadInsuCard_Click()
{
	var CardType=1;
	var rtnInsuCardInfo=ReadINSUCard("",CardType);
	if(rtnInsuCardInfo==""){alert("读取医保卡失败?"); return;}
	//var rtnInsuCardInfo="0|3990003311^3990004522^^离休测试^1^^^130302193302020021^39901101^^^离休^80^QHDA^0^0^0|^^^|"
	var InsuArr=rtnInsuCardInfo.split("|");
	if(InsuArr[0]!=0){alert("读取医保卡失败?");return;}
	var InsuArr1=InsuArr[1].split("^");
	//if(InsuArr1[7]=="") 
	var BirthDay=InsuArr1[6].split(" ")[0];
	if (InsuArr1[7].length==18){
		var BirthDay=InsuArr1[7].substring(6,10)+"-"+InsuArr1[7].substring(10,12)+"-"+InsuArr1[7].substring(12,14);
	} else if(InsuArr1[7].length==15) {
		var BirthDay="19"+InsuArr1[7].substring(6,8)+"-"+InsuArr1[7].substring(8,10)+"-"+InsuArr1[7].substring(10,12);
	}
	
	DHCWebD_SetObjValueC("DOB",BirthDay);
	var myAge=DHCWeb_GetAgeFromBirthDay("DOB");
	DHCWebD_SetObjValueA("Age",myAge);
	
	var PatYBCode,Name,Sex,Birth,Age,CredNo,EmployeeCompany,PatType;
	//转换
	if (InsuArr1[4]==2){
		Sex=1;
	}else if (InsuArr1[4]==1){
		Sex=2;
	}else{
		Sex=4;
	}
	Obj=document.getElementById('Sex_DR_Name');
	if(Obj)
	{
		Obj.value=Sex;
		}
		
	
	if (InsuArr1[12]==50){PatType=2;}
	if (InsuArr1[12]==60){PatType=3;}
	if (InsuArr1[12]==80){PatType=4;}
	if (InsuArr1[12]==70){PatType=4;}
	DHCWebD_SetObjValueA("Name",InsuArr1[3]);
	Obj=document.getElementById('PatType_DR_Name');
	if(Obj)
	{
		Obj.value=PatType;
		}
    DHCWebD_SetObjValueA("Company",InsuArr1[8]);		
	DHCWebD_SetObjValueA("IDCard",InsuArr1[7]);	
	DHCWebD_SetObjValueA("MedicareCode",InsuArr1[0]);	
	

}
///end
function SetDiet()
{
	var eSrc=window.event.srcElement;
	if (eSrc&&eSrc.checked)	{
			obj=document.getElementById("DietFlag");
		if (obj){ obj.checked=false; } 
		}
}
function BodyLoadHandler() { 
	
	var obj;
	obj=document.getElementById("ReCheckFlag");
	if (obj){ obj.onclick=SetDiet; } 
	obj=document.getElementById("BPrintRZ");
	if (obj){ obj.onclick=PrintReportRJ; } 
	//更新
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	obj=document.getElementById('PEDateBegin')
	if (obj) {obj.onchange=change}
	//清除
	obj=document.getElementById("BClear");
	if (obj){ obj.onclick=Clear_click; }
	//预约项目
	obj=document.getElementById("BNewItem");
	if (obj){ 
		obj.onclick=BNewItem_click; 
		obj.disabled=true;
	}


	//add by wangkai
	var myobj=document.getElementById("ReadRegInfo");
	if (myobj)
	{ 
		myobj.onclick=ReadRegInfo_OnClick; 
		myobj.onkeydown=Doc_OnKeyDown;  	 
	}
	var Obj=document.getElementById('ReadInsuCard');
	if (Obj) {Obj.onclick = ReadInsuCard_Click;}
	
	obj=document.getElementById("BItemPrint");
	if (obj){ 
		obj.onclick=BItemPrint_click; 
		//obj.disabled=true;
	}
	
	//预约完成
	obj=document.getElementById("BPreOver");
	if (obj){ obj.onclick=PreOver_click; }
	//登记号
	obj=document.getElementById('PAPMINo');
	if (obj) { obj.onchange = RegNoOnChange;
	obj.onkeydown=RegNo_keydown; }
	//姓名
	obj=document.getElementById('Name');
	if (obj) { //obj.onchange = NameChange;
	obj.onkeydown=Name_keydown; }
	//身份证号
	obj=document.getElementById('IDCard');
	if (obj) { obj.onchange = IDCardOnChange;
	obj.onkeydown=IDCard_keydown; }
	// 默认体检截至日期与开始日期相同
	obj=document.getElementById('PEDateBegin');
	if (obj) { obj.onblur=PEDateBegin_blur; }
 	obj=document.getElementById("BPhoto");
	if (obj){ obj.onclick=BPhoto_click; }
    obj=document.getElementById('DOB');
	if (obj){
		obj.onblur=DOB_OnBlur;
	}
	//登记
	obj=document.getElementById("BRegister");
	if (obj){ 
		obj.onclick=Register; 
		obj.disabled=true;
	}
	 
	//登记
	obj=document.getElementById("BRegArrivePrint");
	if (obj){ 
		obj.onclick=BRegArrivePrint; 
		obj.disabled=true;
	}
	obj=document.getElementById("BRegisterPrint");
	if (obj){ 
		obj.onclick=RegisterPrint_Click; 
		obj.disabled=true;
	}

	//到达
	obj=document.getElementById("BArrived");
	if (obj){ 
		obj.onclick=Arrived; 
		obj.disabled=true;
	}
	//登记并到达                                          //add by zl 20100317 start
	obj=document.getElementById("BRegAndArrived");
	if (obj){ 
		obj.onclick=RegAndArrived_click; 
		obj.disabled=true;}                              //add by zl 20100317 end
	obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		obj.onkeydown=CardNo_KeyDown;}
	 
	obj=document.getElementById("BReadCard");
	if (obj) 
	{obj.onclick=ReadCard_Click;
	obj.onkeydown=Doc_OnKeyDown;
	}
	
	obj=document.getElementById("Age");
	if (obj){obj.onchange=Age_Change;}
	
	obj=document.getElementById("VIPLevel");
	if (obj){obj.onchange=VIPLevel_Change;}
	
	
	SetDefault();

	intKeydown()
	initialReadCardButton()
	 
	iniForm();
	
	//websys_setfocus('PAPMINo')	
	obj=document.getElementById("HospitalCode");
	if (obj){ HospitalCode=obj.value;}
      
	if ((HospitalCode!="NBMZ")&&(HospitalCode!="LZEY")) {
    var RowID=GetCtlValueById("ID")
  	if (RowID=="")
          { websys_setfocus('Name')
	  }
	else
        { websys_setfocus('BNewItem')}}
    else if(HospitalCode="LZEY"){websys_setfocus('CardNo')}
	else {websys_setfocus('IDCard')}
	 
	PAPMINoFind()
	InitPicture()
	websys_setfocus("RegNo");
	//document.onkeydown=Doc_OnKeyDown;
}


function VIPLevel_Change()
{
	obj=document.getElementById("VIPLevel");
	if (obj){
		var VIPLevel=obj.value;
		if (VIPLevel=="") return false;
		var PatType=tkMakeServerCall("web.DHCPE.VIPLevel","GetPatFeeType",VIPLevel)
		if (PatType!=""){
			var obj=document.getElementById("PatFeeType_DR_Name");
			if (obj) obj.value=PatType;
		}
	}
}
function BPhoto_click()
{   
    var PAPMINo ="" 
    var obj=document.getElementById('PAPMINo');
    if(obj){PAPMINo=obj.value}
	//保存为jpg文件
	var Ins=document.getElementById('GetPatientID');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
	var PatientID=cspRunServerMethod(encmeth,PAPMINo);
	if(PatientID==""){
		alert("基本信息ID不能为空.");
		return;
	}

	//服务器信息以及ftp信息保存在一个ini文件中
	Photo2.FileName=PicFilePath+PAPMINo+picType; //保存图片的名称包括后缀
	Photo2.AppName="picture/" //ftp目录
	Photo2.DBFlag="0"  //是否保存到数据库  0  1
	Photo2.FTPFlag="1" //是否上传到ftp服务器  0  1 
	Photo2.PatientID=PatientID //PA_PatMas表的ID
	//Photo2.PatientID=PAPMINo
	Photo2.ShowWin()
	InitPicture()
}
function InitPicture()
{
	
    var PAPMINo ="" 
    var obj=document.getElementById('PAPMINo');
    if(obj){PAPMINo=obj.value}
	//保存为jpg文件
	var Ins=document.getElementById('GetPatientID');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
	var PatientID=cspRunServerMethod(encmeth,PAPMINo);
	//var src=PicFilePath+PAPMINo+picType

	ShowPicByPatientID(PatientID,"imgPic")  //DHCPECommon.js
	
	//document.getElementById("imgPic").innerHTML='<img SRC='+src+' BORDER="0" width=110 height=160>&nbsp;'
  
}



function CardNo_Change()
{
	CardNoChangeApp("PAPMINo","CardNo","RegNoOnChange()","Clear_click()","0");
}
function ReadCard_Click()
{
	//alert('1')
	ReadCardApp("PAPMINo","RegNoOnChange()","CardNo");
}
function iniForm()
{
	
	var obj,Statusobj;
	var obj=document.getElementById("HospitalCode");   //add by zl
	if (obj){ HospitalCode=obj.value;}
	obj=document.getElementById('DietFlag');
	//if (obj){ obj.checked=true;}
	obj=document.getElementById('AsCharged');
	if (obj) { 
	var Default=document.getElementById("DefaultAsCharged");
	if (Default)
	{
		if ((Default.value==1)||(Default.value==3)){obj.checked=true;}
		else{obj.checked=false;}
		
	}
	}
	obj=document.getElementById('ID');
	if (obj && ""!=obj.value) {
		var ID=obj.value;
		obj=document.getElementById('DataBox');
		if (obj && ""!=obj.value) { SetPatient_Sel(obj.value); }  //Modified by MLH 20071212
		
		obj=document.getElementById("Update");
		if (obj){
			obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>更新(<u>U</u>)";
		}
		
		if (parent.frames("PreItemList")){
				lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList&TargetFrame=PreItemList.Qry&AdmType=PERSON&AdmId="+ID+"&PreOrAdd=PRE";
				parent.frames("PreItemList").location.href=lnk;
		}
		
	}

	if (obj&&obj.value=="")
	{
		PAPMINoFind();
	}
	Statusobj=document.getElementById("Status");
    obj=document.getElementById('BPreOver'); 
		
	if (Statusobj.value=="PREREGED")
	{
		Aobj=document.getElementById('BRegister');
		if (Aobj) Aobj.disabled=false;
		Aobj=document.getElementById('BRegArrivePrint');
		if (Aobj) Aobj.disabled=false;
		Aobj=document.getElementById('BRegAndArrived');
		if (Aobj) Aobj.disabled=false;	
		Aobj=document.getElementById('BRegisterPrint');
		if (Aobj) Aobj.disabled=false;
		
		
	
	
	}
		if (Statusobj.value=="REGISTERED")
	{
	
		
		Aobj=document.getElementById('BArrived');
		if (Aobj) Aobj.disabled=false;

	
	}
	if (!obj) return false;
	if (Statusobj.value!="PREREG")
	{
		
		obj.disabled=true;
		if (Statusobj.value!="")
		{obj=document.getElementById('Update');
		obj.disabled=true;}
		obj=document.getElementById('BNewItem');
		obj.disabled=true;
		return;
	}
	
	obj.disabled=false;
}

/*
function iniForm(){
	var obj,Statusobj;
	obj=document.getElementById('ID');
	if (obj && ""!=obj.value) {
		obj=document.getElementById('DataBox');
		if (obj && ""!=obj.value) { SetPatient_Sel(obj.value); }  //Modified by MLH 20071212
		obj=document.getElementById("Update");
		if (obj){
			obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>更新(<u>U</u>)";
		}	
	}
	if (obj&&obj.value=="")
	{
		PAPMINoFind();
	}
	Statusobj=document.getElementById("Status");
	obj=document.getElementById('BPreOver');
	if (Statusobj.value=="PREREGED")
	{
		Aobj=document.getElementById('BRegister');
		if (Aobj) Aobj.disabled=false;
		Aobj=document.getElementById('BRegArrivePrint');
		if (Aobj) Aobj.disabled=false;
		Aobj=document.getElementById('BRegisterPrint');
		if (Aobj) Aobj.disabled=false;
		
		Aobj=document.getElementById('BArrived');
		if (Aobj) Aobj.disabled=false;
		
	
	
	}

		if (Statusobj.value=="REGISTERED")
	{
	
		
		Aobj=document.getElementById('BArrived');
		if (Aobj) Aobj.disabled=false;
	
	}

	if (Statusobj.value!="PREREG")
	{
		obj.disabled=true;
		if (Statusobj.value!="")
		{obj=document.getElementById('Update');
		obj.disabled=true;}
		obj=document.getElementById('BNewItem');
		obj.disabled=true;
		return;
	}
	alert("18")
	obj.disabled=false;
}
*/
// ///////////////////////////////////////////////////////////////////////////////

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function nextfocus() {
	
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
	
}
///判断移动电话
function isMoveTel(elem){
	
	if (elem=="") return true;
	var pattern=/^1(3|4|5|8)\d{9}$/;
	if(pattern.test(elem)){

		//	PIBI_Tel1	电话号码1	6
		obj=document.getElementById("Tel1");
		if (obj&&obj.value=="") { obj.value=elem; }	
		
		return true;
	}else{
	
  		alert("移动电话号码不正确");
		return false;
 	}
}
function intKeydown()
{	

	
	var myCount=myItemNameAry.length;
	for (var myIdx=0;myIdx<myCount;myIdx++){
		if ((myItemNameAry[myIdx]!="PAPMINo")&&(myItemNameAry[myIdx]!="Name")&&(myItemNameAry[myIdx]!="CardNo")){	
			var myobj=document.getElementById(myItemNameAry[myIdx]);
			if (myobj){
				myobj.onkeydown = nextfocus;
			}
		}
	}	

		
}
// ///////////////////////////////////////////////////////////////////////////////
//登记号
function RegNo_keydown(e) {
	var key=websys_getKey(e);
	if ( 13==key) {
		RegNoOnChange();
	}
}

//登记号
function RegNoOnChange() {
	
	var obj;
	var iPAPMINo="";
	var RegNo="";
	obj=document.getElementById('PAPMINo'); 
	if (obj && ""!=obj.value) {
		iPAPMINo = obj.value;
		iPAPMINo = RegNoMask(iPAPMINo); 
		RegNo=iPAPMINo; 
		
	}
	
	else { return false; } 
	iPAPMINo="^"+iPAPMINo+"^";
	Clear_click();
	
	FindPatDetailByRegNo(iPAPMINo);
	//ShowPicByPatientID(RegNo,"imgPic")  //DHCPECommon.js
	
}
function FindPatDetailByRegNo(ID){
	var Instring=ID;
	var Ins=document.getElementById('GetDetail');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetPatient_Sel','',Instring);
	
}
//////////////////////////////////////////////////////
//身份证
function IDCard_keydown(e) {
	var key=websys_getKey(e);
	if ( 13==key) {
		IDCardOnChange();
	}
}
//身份证
function IDCardOnChange() {
	var obj;
	var iPAPMINo="";
	obj=document.getElementById('IDCard');
	if (obj ) {
		IDCard = obj.value;
		IDCardSave=obj.value;
	}
	else { return false; }		
	
	var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByIDCard",IDCard);
	if (RegNo==""){
		SetDefault();
		isIdCardNo(IDCard);
		return false;
	}
	var obj=document.getElementById("PAPMINo");
	if (obj){
		obj.value=RegNo;
		RegNoOnChange();
	}
	return false;
	
	
	
	IDCard="^^^"+IDCard;
    
	FindPatDetailByIDCard(IDCard);
}
function FindPatDetailByIDCard(ID){
	var Instring=ID;
	var Ins=document.getElementById('GetDetail');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetPatient_Sel','',Instring);
}
//////////////////////////////////////////////////////
//姓名
function Name_keydown(e) {
	var key=websys_getKey(e);
	if (13==key) {
		NameChange();
		nextfocus();
	}
}
function NameChange() {
	var iName="";
	var obj=document.getElementById('Name');
	if (obj && ""!=obj.value) { iName = obj.value; }
	else { return false; }
	var info=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetPersonInfo",iName);
	if (info==0) return;
	FindPatDetailByName(iName);
}
function FindPatDetailByName(iName){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreIBI.List"
			+"&PatName="+iName;
	var wwidth=800;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	var cwin=window.open(lnk,"_blank",nwin)	
}
/////////////////////////////////////////////////////////
function SetPatient_Sel(value) {
	

	//Clear_click();
	var obj;
	var Data=value.split(";");
	var IsShowAlert=Data[2];
	if ("Y"==IsShowAlert) {
		// 客户已经预约
		alert(t["info 02"]);
		return false;
		if (!(confirm(t["info 02"]))){
			return false;
		}else{
			obj=document.getElementById("Update");
			if (obj){
				obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>预约(<u>U</u>)";
			}
		}
	}
	//客户信息
	var PreIBaseInfoData=Data[0];
	if (""!=PreIBaseInfoData)
	{   
		SetPreIBaseInfo(PreIBaseInfoData);   //mlh20071227
		//登记信息
		var PreIADMData=Data[1];
	
		if ((""!=PreIADMData)&&(PreIBaseInfoData!="")){ SetPreIADM(PreIADMData); }
		obj=document.getElementById('ID');
	}
	else
	{    
		var HisInfo=Data[1];
		SetHisInfo(HisInfo)
	}
}

//客户信息
function SetPreIBaseInfo(value) {
	var obj;
	var Data=value.split("^");
	var iLLoop=0;	
	iRowId=Data[iLLoop];
	iLLoop=iLLoop+1;
	
	if ("0"==iRowId){
		//	PIBI_PAPMINo	登记号	1
		obj=document.getElementById("PAPMINo");
		if (obj) { obj.value=Data[iLLoop]; var PAPMINo=obj.value;InitPicture()}	

		//	PIBI_Name	姓名	2
		obj=document.getElementById("Name");
		//if (obj) { obj.value="未找到记录"; }
		//if (obj) { obj.value=t["Err 01"]; }
		obj=document.getElementById("IDCard");
		obj.value=IDCardSave;
		IDCard=obj.value;
		SetDefault();
		isIdCardNo(IDCardSave);
		//alert("IDCardSave:"+IDCardSave);

		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreIBaseInfo.Edit"
			+"&PAPMINo="+PAPMINo+"&IDCard="+"&ReturnComponent=DHCPEPreIADM.Edit"
			+IDCardSave+"&ComponentName=DHCPEPreIADM.Edit"
			;

		var wwidth=800;
		var wheight=600; 
		var xposition = (screen.width - wwidth) / 2;
		var yposition = (screen.height - wheight) / 2;
		var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
		//window.open(lnk,"_blank",nwin)	
		return false;
	}
	//	PIBI_RowId	0
	obj=document.getElementById("PIBI_RowId");
	if (obj) { obj.value=iRowId; }
	
	//	PIBI_PAPMINo	登记号	1
	obj=document.getElementById("PAPMINo");
	if (obj) { obj.value=Data[iLLoop]; InitPicture()}
	
	iLLoop=iLLoop+1;
	//	PIBI_Name	姓名	2
	obj=document.getElementById("Name");
	if (obj) { obj.value=Data[iLLoop]; 
	obj.readOnly=true;
	}
	
	iLLoop=iLLoop+1;
	//	PIBI_Sex_DR	性别	3
	obj=document.getElementById("Sex_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	// 性别 3.1
	obj=document.getElementById("Sex_DR_Name");
	if (obj) { obj.value=Data[iLLoop-1]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_DOB	生日	4
	obj=document.getElementById("DOB");
	 if (obj && Data[iLLoop]) {
	if ((Data[iLLoop].split("/")[2].length)==2)             //add by zhouli 处理生日显示格式以及年份为20开头的数据
    {var DOB="19"+Data[iLLoop].split("/")[2]+"-"+Data[iLLoop].split("/")[1]+"-"+Data[iLLoop].split("/")[0]} //add by zhouli
    else {var DOB=Data[iLLoop].split("/")[2]+"-"+Data[iLLoop].split("/")[1]+"-"+Data[iLLoop].split("/")[0]} //add by zhouli
    obj.value=DOB;  }
    
	iLLoop=iLLoop+1;
	//	PIBI_PatType_DR	客人类型	5
	//obj=document.getElementById("PatType_DR");
	//if (obj) { obj.value=Data[iLLoop]; }
	
	//iLLoop=iLLoop+1;
	//	5.1
	//obj=document.getElementById("PatType_DR_Name");
	//if (obj) { obj.value=Data[iLLoop]; }
	
	
	obj=document.getElementById("HospitalCode");  //Modify by zl20100222 start
	if (obj){ HospitalCode=obj.value;}
	obj=document.getElementById("PatType_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	/*
	if (HospitalCode=="SHDF")
	{obj=document.getElementById("PatType_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	}
	else
	{
		obj=document.getElementById("PatType_DR");
		if (obj) { obj.value=Data[iLLoop]; }
		iLLoop=iLLoop+1;
		obj=document.getElementById("PatType_DR_Name");
	    if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	}
	*/
	                                                          //Modify by zl20100222 end
	
	iLLoop=iLLoop+1;
	//	PIBI_Tel1	电话号码1	6
	obj=document.getElementById("MobilePhone");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Tel2	电话号码2	7
	obj=document.getElementById("Tel2");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_MobilePhone	移动电话	8
	obj=document.getElementById("Tel1");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_IDCard	身份证号	9
	obj=document.getElementById("IDCard");
	if (obj) { obj.value=Data[iLLoop];
	obj.readOnly=true;
	}
	
	iLLoop=iLLoop+1;
	//	PIBI_Vocation	职业	10
	obj=document.getElementById("Vocation");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Position	职位	11
	obj=document.getElementById("Position");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Company	公司	12
	obj=document.getElementById("Company");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Postalcode	邮编	13
	obj=document.getElementById("Postalcode");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Address	联系地址	14
	obj=document.getElementById("Address");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Nation	民族	15
	obj=document.getElementById("Nation");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Email	电子邮件	16
	obj=document.getElementById("Email");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Married	婚姻状况	17
	obj=document.getElementById("Married_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	//	17.1
	obj=document.getElementById("Married_DR_Name");
	if (obj) { obj.value=Data[iLLoop-1]; }
	
	iLLoop=iLLoop+1;	
	//	PIBI_Blood	血型	18
	obj=document.getElementById("Blood_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	血型 18.1
	obj=document.getElementById("Blood_DR_Name");
	if (obj) { obj.value=Data[iLLoop-1]; }
	
	iLLoop=iLLoop+1;	
	//	PIBI_UpdateDate	日期	19
	obj=document.getElementById("UpdateDate");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_UpdateUser_DR	更新人	20
	obj=document.getElementById("UpdateUser_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	20.1
	obj=document.getElementById("UpdateUser_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	//	20.1
	obj=document.getElementById("HPNo");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	//	20.1
	obj=document.getElementById("Age");
	if (obj) { obj.value=Data[iLLoop].split("Y")[0]; }
	iLLoop=iLLoop+5;
	//	20.1
	obj=document.getElementById("CardNo");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	obj=document.getElementById("VIPLevel");
	if (obj) {
		obj.value=Data[iLLoop]; 
		VIPLevel_Change();
	}
	
	iLLoop=iLLoop+1;
	obj=document.getElementById("MedicareCode");
	if (obj) { obj.value=Data[iLLoop]; 
	obj.readOnly=true;
	}
	
	var CurDate=""
	obj=document.getElementById("CurDate");
	if (obj) {CurDate=obj.value;}
	obj=document.getElementById("PEDateBegin");
	if (obj) {obj.value=CurDate;}
	obj=document.getElementById("PEDateEnd");
	if (obj) {obj.value=CurDate;}
	return true;
}

function PAPMINoFind()
{
	var obj=document.getElementById('PAPMINo');
	var PAPMINo="";
	
	if (obj) PAPMINo=obj.value;
	var PARowID=""
	obj=document.getElementById("PIADM_RowId");
	if (obj) { PARowID=obj.value; }

	if ((PAPMINo!="")&&(PARowID=="")) {RegNoOnChange();}
}

function change()
{
	objs=document.getElementById('PEDateBegin')
	obje=document.getElementById('PEDateEnd')
	obje.value=objs.value
}

// 默认体检截至日期与开始日期相同
function PEDateBegin_blur() {
	var eSrc=document.getElementById('PEDateBegin');
	var obj=document.getElementById('PEDateEnd');
	if (obj && ""==obj.value) { obj.value=eSrc.value; }
}
//登记信息
function SetPreIADM(value){

	var obj;
	var Data=value.split("^");
	var iLLoop=0;	
	iRowId=Data[iLLoop];
	if ('0'==iRowId) { return false; }
	// 按钮 预约项目
	obj=document.getElementById("BNewItem");
	if (obj){ obj.disabled=false; }		
	obj=document.getElementById("PIADM_RowId");
	if (obj) { obj.value=iRowId; }
	iLLoop=iLLoop+1;
	
	//预登记个人基本信息号 PIADM_PIBI_DR 1
	obj=document.getElementById("PIBI_DR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;	
	// 1.1
	obj=document.getElementById("PIBI_DR_Name");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;

	//对应团体的ADM PIADM_PGADM_DR 2
	obj=document.getElementById("PGADM_DR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 对应团体 2.1
	//obj=document.getElementById("PGADM_DR_Name");
	//	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }	
	iLLoop=iLLoop+1;	

	//对应团体组ADM PIADM_PGTeam_DR 3
	obj=document.getElementById("PGTeam_DR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 对应团体组 3.1
	//obj=document.getElementById("PGTeam_DR_Name");
	//	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }	
	iLLoop=iLLoop+1;	

	//预约体检日期开始 PIADM_PEDateBegin 4
	obj=document.getElementById("PEDateBegin");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 预约体检日期结束 PIADM_PEDateEnd 27
	obj=document.getElementById("PEDateEnd");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	//预约体检时间 PIADM_PETime 5
	obj=document.getElementById("PETime");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 预约接待人员 PIADM_PEDeskClerk_DR 6
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 预约接待人员 6.1
	obj=document.getElementById("PEDeskClerk_DR_Name");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;	

	// PIADM_Status 7
	obj=document.getElementById("Status");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	

	//视同收费 PIADM_AsCharged 8
	obj=document.getElementById("AsCharged");
	if (obj && Data[iLLoop]) {
		if ("Y"==Data[iLLoop]) { obj.checked=true; }
		else { obj.checked=false; }
	}	
	iLLoop=iLLoop+1;
	
	// 允许加项	PIADM_AddOrdItem 19
	obj=document.getElementById("AddOrdItem");
	if (obj && Data[iLLoop]) {
		if ("Y"==Data[iLLoop]) { obj.checked=true; }
		else { obj.checked=false; }
		//AddOrdItem_click();
	}	
	iLLoop=iLLoop+1;
	
	// 加项金额限制	PIADM_AddOrdItemLimit 20 
	obj=document.getElementById("AddOrdItemLimit");
	if (obj && Data[iLLoop]) {
		if ("Y"==Data[iLLoop]) { obj.checked=true; }
		else { obj.checked=false; }
		//AddOrdItemLimit_click();
	}	
	iLLoop=iLLoop+1;
	
	// 允许加项金额	PIADM_AddOrdItemAmount 21
	obj=document.getElementById("AddOrdItemAmount");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 允许加药	PIADM_AddPhcItem 22
	obj=document.getElementById("AddPhcItem");
	if (obj && Data[iLLoop]) {
		if ("Y"==Data[iLLoop]) { obj.checked=true; }
		else { obj.checked=false; }
		//AddPhcItem_click();
	}	
	iLLoop=iLLoop+1;
	
	// 加药金额限制	PIADM_AddPhcItemLimit 23
	obj=document.getElementById("AddPhcItemLimit");
	if (obj && Data[iLLoop]) {
		if ("Y"==Data[iLLoop]) { obj.checked=true; }
		else { obj.checked=false; }
		//AddPhcItemLimit_click();
	}	
	iLLoop=iLLoop+1;
	
	// 允许加药金额	PIADM_AddPhcItemAmount 24
	obj=document.getElementById("AddPhcItemAmount");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 个人报告发送	PIADM_IReportSend 25
	obj=document.getElementById("IReportSend");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 结算方式	PIADM_DisChargedMode 26
	obj=document.getElementById("DisChargedMode");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	//  PIADM_VIPLevel 28
	obj=document.getElementById("VIPLevel");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	iLLoop=iLLoop+1;
	//  PIADM_Remark 28
	obj=document.getElementById("Remark");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }

	
	iLLoop=iLLoop+1;
	// 业务员 PIADM_PEDeskClerk_DR 6
	obj=document.getElementById("Sales_DR");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	// 业务员 6.1
	obj=document.getElementById("Sales");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	//类型
	obj=document.getElementById("Type");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	//取报告日期
	obj=document.getElementById("GetReportDate");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	//取报告时间
	obj=document.getElementById("GetReportTime");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	obj=document.getElementById("PayType");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	obj=document.getElementById("Percent");
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	obj=document.getElementById("InsureUnit");                //add by zl20100207 START
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }       //add by zl20100207 end
	iLLoop=iLLoop+1;
	obj=document.getElementById("PatFeeType_DR_Name");                //
	if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }       //
}

// ///////////////////////////////////////////////////////////////////////////////
// 提供给子页面?项目预约页面?设置金额
function SetAmount(Amount) {
	var iAccountAmount="",iSaleAmount="";
	var obj;
	
	obj=document.getElementById("AccountAmount");
	if (obj) {
		iAccountAmount=obj.value;
		obj.value=Amount;
	}
	
	obj=document.getElementById("DiscountedAmount");
	if (obj) {
		iDiscountedAmount=obj.value;
		if (""==iDiscountedAmount) { obj.value=Amount; }
		if (iAccountAmount==iDiscountedAmount) { obj.value=Amount; }
	}
	
	obj=document.getElementById("SaleAmount");
	if (obj) {
		iSaleAmount=obj.value;
		if (""==iSaleAmount) { obj.value=Amount; }
		if (iAccountAmount==iSaleAmount) { obj.value=Amount; }
	}
}

function Save() {
	
    var obj=document.getElementById("HospitalCode");   //add by zl
	if (obj){ HospitalCode=obj.value;}
	if (HospitalCode=="SHDF")
	{
	var obj=document.getElementById("Amount");
	var Amount=obj.value;
	if (isNaN(Amount))
	{
		alert("输入金额不是数值")
		websys_setfocus("Amount");
		return false;
	}
	}
	
	var obj,DataStr="",OneData="",iRowId
	obj=document.getElementById("PIADM_RowId");
	if (obj) { OneData=obj.value; }
	iRowId=OneData
	DataStr=OneData
	OneData=""
	//预登记个人基本信息号 PIADM_PIBI_DR 1
	obj=document.getElementById("PIBI_RowId");
	if (obj) { OneData=obj.value; 
	}
	//alert(OneData)
	//if (""==OneData) {
		var flag=SaveIBIInfo();
		if (!flag) return false;
	//}
	OneData=obj.value; 
	DataStr=DataStr+"^"+OneData
	OneData=""
	//对应团体的ADM PIADM_PGADM_DR 2
	obj=document.getElementById("PGADM_DR");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	//对应组ADM PIADM_PGTeam_DR 3
	obj=document.getElementById("PGTeam_DR");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	//预约体检日期开始 PIADM_PEDateBegin 4
	obj=document.getElementById("PEDateBegin");
	if (obj) { OneData=obj.value; }
	if (""==OneData) {
		//alert("Please entry all information.");
		alert(t['08']);
		websys_setfocus('PEDateBegin');
		return false;
	}
	DataStr=DataStr+"^"+OneData
	OneData=""

	// 预约体检日期结束 PIADM_PEDateEnd 4
	obj=document.getElementById("PEDateEnd");
	if (obj) { OneData=obj.value; }
	if (""==OneData) {
		//alert("Please entry all information.");
		alert(t['08']);
		websys_setfocus('PEDateEnd');
		return false;
	}
	
	DataStr=DataStr+"^"+OneData
	OneData=""
	//预约体检时间 PIADM_PETime
	obj=document.getElementById("PETime");
	if (obj) {
		if ('clsInvalid'==obj.className) { 
			//alert("无效时间格式");
			alert(t["Err 04"]);
			return false;
		}
		OneData=obj.value;
	}
	DataStr=DataStr+"^"+OneData
	OneData=""
	//预约接待人员 PIADM_PEDeskClerk_DR
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	// PIADM_Status
	//obj=document.getElementById("Status");
	//if (obj) { OneData=obj.value; }
	OneData="PREREG"
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//视同收费 PIADM_AsCharged
	obj=document.getElementById("AsCharged");
	if (obj && obj.checked) { OneData="Y"; }
	else { OneData="N"; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	// 允许加项	PIADM_AddOrdItem
	//obj=document.getElementById("AddOrdItem");
	//if (obj && obj.checked) { iAddOrdItem="Y"; }
	//else { iAddOrdItem="N"; }
	OneData="N";
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 加项金额限制	PIADM_AddOrdItemLimit
	//obj=document.getElementById("AddOrdItemLimit");
	//if (obj && obj.checked) { iAddOrdItemLimit="Y"; }
	//else { iAddOrdItemLimit="N"; }
	OneData="N";
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 允许加项金额	PIADM_AddOrdItemAmount
	//obj=document.getElementById("AddOrdItemAmount");
	//if (obj) { iAddOrdItemAmount=obj.value; }
	OneData="";
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 允许加药	PIADM_AddPhcItem
	//obj=document.getElementById("AddPhcItem");
	//if (obj && obj.checked) { iAddPhcItem="Y"; }
	//else { iAddPhcItem="N"; }
	OneData="N";
	DataStr=DataStr+"^"+OneData
	OneData=""

	// 加药金额限制	PIADM_AddPhcItemLimit
	//obj=document.getElementById("AddPhcItemLimit");
	//if (obj && obj.checked) { iAddPhcItemLimit="Y"; }
	//else { iAddPhcItemLimit="N"; }
	OneData="N";
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 允许加药金额	PIADM_AddPhcItemAmount
	//obj=document.getElementById("AddPhcItemAmount");
	//if (obj) { iAddPhcItemAmount=obj.value; }
	OneData="";
	DataStr=DataStr+"^"+OneData
	OneData=""
	// 个人报告发送	PIADM_IReportSend
	//obj=document.getElementById("IReportSend");
	//if (obj) { iIReportSend=obj.value; }
	OneData="DC";
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 结算方式	PIADM_DisChargedMode
	//obj=document.getElementById("DisChargedMode");
	//if (obj) { iDisChargedMode=obj.value; }
	OneData="ID";
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	// 	PIADM_VIPLevel
	obj=document.getElementById("VIPLevel");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//延期日期 PIADM_DelayDate
	//obj=document.getElementById("DelayDate");
	//if (obj) { iDelayDate=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//备注 PIADM_Remark
	obj=document.getElementById("Remark");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData;
	
	//销售员
	obj=document.getElementById("Sales_DR");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//类型
	obj=document.getElementById("Type");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//取报告日期
	obj=document.getElementById("GetReportDate");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	
	//取报告时间
	obj=document.getElementById("GetReportTime");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	//取报告时间
	obj=document.getElementById("PayType");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData=""
	//取报告时间
	obj=document.getElementById("Percent");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	
	OneData="0"
	//就餐
	obj=document.getElementById("DietFlag");
	if ((obj)&&(obj.checked)) { OneData="1"; }
	DataStr=DataStr+"^"+OneData
	
	OneData="0"
	//赠品
	obj=document.getElementById("GiftFlag");
	if ((obj)&&(obj.checked)) { OneData="1"; }
	DataStr=DataStr+"^"+OneData
	
	OneData=""                                      //add by zl20100207 START
	obj=document.getElementById("InsureUnit");		//	保险公司
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData                      //add by zl20100207 end
	
	OneData=""                                        //add by zl20100222 START
	obj=document.getElementById("PatType_DR_Name");		//	病人类型
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData                         //add by zl20100222 end
	//开单诊室
	OneData=""                                        //add by zl20100222 START
	obj=document.getElementById("CheckRoom");		//	病人类型
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData   
	OneData=""  
	//	PIBI_Position	职位	11
	obj=document.getElementById("Position");
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData
	OneData="" 
	obj=document.getElementById("PatFeeType_DR_Name");	//	列表框时使用
	if (obj) { OneData=obj.value; }
	DataStr=DataStr+"^"+OneData;
	
	OneData="N" ;
	obj=document.getElementById("ReCheckFlag");	//	列表框时使用
	if (obj&&obj.checked) { OneData="Y"; }
	DataStr=DataStr+"^"+OneData
	
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',DataStr)
	if (flag=="Err Date")
	{
		alert(t["Err Date"]);
		return false;
	}
	
	var Rets=flag.split("^");
	flag=Rets[0];
	if ((flag=='0')&&(HospitalCode=="SHDF"))
	{
		if (Amount!="")
		{
			if (iRowId=="")
			{
				var PADM=Rets[1];
			}
			else
			{
				var PADM=iRowId
			}
			var obj=document.getElementById("PAPMINo");
			if (obj) var RegNo=obj.value;
			var sURL="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEAdvancePayment"
				+"&RegNo="+RegNo+"&Fee="+Amount+"&PADM="+PADM+"&Type=R";
			var vReturnValue=window.showModalDialog(sURL,"","dialogWidth=600px;dialogHeight=450px");
		}   
	}
	if (""==iRowId) { 

		//iRowId=Rets[1];
		//var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreIADM.Edit"
		//	+"&ID="+Rets[1];
		//location.href=lnk;
		obj=document.getElementById("PIADM_RowId");
		if (obj) obj.value=Rets[1];
	}
	
	if ('0'==flag) {
		//BarInfoPrint()
		
		//alert("Update Success!");
		if (""==iRowId) {
			//alert(t['info 01']);
		}else { 
			if (parent.frames("PreItemList")){
				lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList&TargetFrame=PreItemList.Qry&AdmType=PERSON&AdmId="+iRowId+"&PreOrAdd=PRE";
				parent.frames("PreItemList").location.href=lnk;
			}
			if (parent.frames("PreItemList.Qry")){
				lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QrySet&TargetFrame=PreItemList&Type=ItemSet&AdmId="+iRowId;
				parent.frames("PreItemList.Qry").location.href=lnk;
			}
			if (parent.frames("PreItemList.Qry2")){
				lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&TargetFrame=PreItemList&Type=Item&PreIADMID="+iRowId;
				parent.frames("PreItemList.Qry2").location.href=lnk;
			}
			if (parent.frames("PreItemList.Qry3")){
				lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&TargetFrame=PreItemList&Type=Lab&PreIADMID="+iRowId;
				parent.frames("PreItemList.Qry3").location.href=lnk;
			}
			alert(t['info 04']); 
		}
		
		if (""==iRowId) {
			if (parent.frames("PreItemList")){
				lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList&TargetFrame=PreItemList.Qry&AdmType=PERSON&AdmId="+Rets[1]+"&PreOrAdd=PRE";
				parent.frames("PreItemList").location.href=lnk;
			}
			if (parent.frames("PreItemList.Qry")){
				lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QrySet&TargetFrame=PreItemList&Type=ItemSet&AdmId="+Rets[1];
				parent.frames("PreItemList.Qry").location.href=lnk;
			}
			if (parent.frames("PreItemList.Qry2")){
				lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&TargetFrame=PreItemList&Type=Item&PreIADMID="+Rets[1];
				parent.frames("PreItemList.Qry2").location.href=lnk;
			}
			if (parent.frames("PreItemList.Qry3")){
				lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&TargetFrame=PreItemList&Type=Lab&PreIADMID="+Rets[1];
				parent.frames("PreItemList.Qry3").location.href=lnk;
			}
			//更新成功?则可以预约项目
			obj=document.getElementById("BNewItem");
			if (obj) { obj.disabled=false; 
				obj.click();
			}
			
			obj=document.getElementById("BPreOver");
            if (obj) { obj.disabled=false; }


			obj=document.getElementById("BSaveAmount");
			if (obj) { obj.disabled=false; }			
			
			obj=document.getElementById("PIADM_RowId");
			if (obj) { obj.value=Rets[1]; }
			
			obj=document.getElementById("Status");
			if (obj) { obj.value="PREREG"; }			
			
		}
	}
	else if ('Err 02'==flag) {
		alert(t['Err 02']);
		return false;		
	}
	else if ('Err 05'==flag) {
		//alert("不是预登记登记状态?不能修改")
		alert(t['Err 05']);
		return false;		
	} else if ('-105'==flag)  {
		//alert("Insert error.ErrNo="+flag);
		alert(t['-105']);
		return false;

	} else {
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
		return false;
	}
	return true;
}
function BarInfoPrint()
{
	//RegNo^Name^Sex^Age^PatLoc$C(1)^
	//String.fromCharCode(1)
	var obj;
	var RegNo="",Name="",Sex="",Age="",SexNV=""
	obj=document.getElementById("PAPMINo");
	if (obj) RegNo=obj.value;
	obj=document.getElementById("Name");
	if (obj) Name=obj.value;
	obj=document.getElementById("Sex_DR_Name");
	if (obj) Sex=obj.value;
	obj=document.getElementById("SexNV");
	if (obj) SexNV=obj.value;
	var SexNVArr=SexNV.split("^");
	if (Sex==SexNVArr[0]){
		Sex="女";
	}else{
		Sex="男";
	}
	obj=document.getElementById("Age");
	if (obj) Age=obj.value;
	//obj=document.getElementById("PIADM_RowId");
	//if (obj) var PIAdmID=obj.value;
	//alert(PIAdmID)
	obj=parent.frames['PreItemList'].document.getElementById('txtAdmId');
	if (obj) var PIAdmId=obj.value;
	//alert(PIAdmId)
	var Amount=tkMakeServerCall("web.DHCPE.HandlerPreOrds","IGetAmount4Person",PIAdmId); 
	var FactAmount=Amount.split('^')[1]+'元';
	//alert(FactAmount)
	//var Info=RegNo+"^"+Name+"^"+""+"^"+""+"^"+Sex+String.fromCharCode(1)+"^"+Age;
	var Info=RegNo+"^"+Name+"  "+FactAmount+"^"+"^"+"^"+"^"+Sex+String.fromCharCode(1)+"^"+Age+"^"+RegNo;
	PrintBarRis(Info)
}
function Update_click() {
	
	var eSrc=window.event.srcElement;
	if (eSrc.disable) {
	}else{
		eSrc.disable=true;
		Save();
		
		var FileName = IDCardPicture + DHCWebD_GetObjValue("CredNo") + ".bmp"
		if (PicFileIsExist(FileName)) {
			
			var PAPMINo ="" 
    		var obj=document.getElementById('PAPMINo');
    		if(obj){PAPMINo=obj.value}
			//保存为jpg文件
			var Ins=document.getElementById('GetPatientID');
			if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
			var PatientID=cspRunServerMethod(encmeth,PAPMINo);
			if(PatientID==""){
				alert("基本信息ID不能为空.");
				return;
			}
			Photo2.FileName = FileName; //保存图片的名称包括后缀
			Photo2.AppName = "picture/" //ftp目录
				Photo2.DBFlag = "1" //是否保存到数据库  0  1
				Photo2.FTPFlag = "1" //是否上传到ftp服务器  0  1
				Photo2.DBConnectString = "CN_IPTCP:10.160.16.90[1972]:DHC-APP" //数据库服务器
				Photo2.FTPString = "10.160.16.112^anonymous^^21" //FTP服务器
				//Photo2.DBConnectString="CN_IPTCP:10.160.16.31[1972]:DHC-APP" //数据库服务器
				//Photo2.FTPString="10.72.16.158^administrator^123456^21" //FTP服务器
				Photo2.PatientID = PatientID//PA_PatMas表的ID
				Photo2.SaveFile() //对于已经存在图片保存到数据库同时上传FTP的标志有效
		}
		
		eSrc.disable=false;
	}
}
function nextfocus() {
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}
// ///////////////////////////////////////////////////////////////////////////////
//清除输入的信息
function Clear_click() {
	
	//预约项目
	obj=document.getElementById("BNewItem");
	if (obj){ obj.disabled=true; }
	
	obj=document.getElementById("BSaveAmount");
	if (obj){ obj.disabled=true; } 
	PreIADM_Clear_click(); 
	PreIBaseInfo_Clear_click(); 
	InitPicture(); 
	SetDefault();
	IDReadControlDisable(false);
	if (parent.frames("PreItemList")){
		lnk="websys.default.csp";
		parent.frames("PreItemList").location.href=lnk;
	}
	if (parent.frames("PreItemList.Qry")){
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QrySet&TargetFrame=PreItemList&Type=ItemSet&AdmId=";
		parent.frames("PreItemList.Qry").location.href=lnk;
	}
	if (parent.frames("PreItemList.Qry2")){
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&TargetFrame=PreItemList&Type=Item&PreIADMID=";
		parent.frames("PreItemList.Qry2").location.href=lnk;
	}
	if (parent.frames("PreItemList.Qry3")){
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&TargetFrame=PreItemList&Type=Lab&PreIADMID=";
		parent.frames("PreItemList.Qry3").location.href=lnk;
	}
}
//登记信息
function PreIADM_Clear_click() {
	
	var obj;
	
	obj=document.getElementById("PIADM_RowId");
	if (obj) { obj.value=""; }

	//预登记个人基本信息号 PIADM_PIBI_DR
	obj=document.getElementById("PIBI_DR");
	if (obj) { obj.value=""; }	
	obj=document.getElementById("PIBI_DR_Name");
	if (obj) { obj.value=""; }
	

	//对应团体的ADM PIADM_PGADM_DR
	obj=document.getElementById("PGADM_DR");
	if (obj) { obj.value=""; }
	//obj=document.getElementById("PGADM_DR_Name");
	//if (obj) { obj.value=""; }	

	//对应组ADM PIADM_PGTeam_DR
	obj=document.getElementById("PGTeam_DR");
	if (obj) { obj.value=""; }
	//obj=document.getElementById("PGTeam_DR_Name");
	//if (obj) { obj.value=""; }	

	//预约体检日期开始 PIADM_PEDateBegin
	obj=document.getElementById("PEDateBegin");
	if (obj) { obj.value=""; }
	
	// 预约体检日期结束 PIADM_PEDateEnd
	obj=document.getElementById("PEDateEnd");
	if (obj) { obj.value=""; }
	
	//预约体检时间 PIADM_PETime
	obj=document.getElementById("PETime");
	if (obj) { obj.value=""; }
	

	//预约接待人员 PIADM_PEDeskClerk_DR
	obj=document.getElementById("PEDeskClerk_DR");
	if (obj) { obj.value=""; }
	obj=document.getElementById("PEDeskClerk_DR_Name");
	if (obj) { obj.value=""; }	

	// PIADM_Status
	obj=document.getElementById("Status");
	if (obj) { obj.value=""; }
	

	//视同收费 PIADM_AsCharged
	obj=document.getElementById("AsCharged");
	if (obj) { 
	var Default=document.getElementById("DefaultAsCharged");
	if (Default)
	{
		if ((Default.value==1)||(Default.value==3)){obj.checked=true;}
		else{obj.checked=false;}
		
	}}
	
	//应收金额 PIADM_AccountAmount
	obj=document.getElementById("AccountAmount");
	if (obj) { obj.value=""; }
	
	//打折后金额 PIADM_DiscountedAmount
	obj=document.getElementById("DiscountedAmount");
	if (obj) { obj.value=""; }
	
	//最终金额 PIADM_FactAmount
	obj=document.getElementById("FactAmount");
	if (obj) { obj.value=""; }
	
	//销售金额 PIADM_SaleAmount
	obj=document.getElementById("SaleAmount");
	if (obj) { obj.value=""; }
	
	//审核人 PIADM_AuditUser_DR
	obj=document.getElementById("AuditUser_DR");
	if (obj) { obj.value=""; }
	//obj=document.getElementById("AuditUser_DR_Name");
	//if (obj) { obj.value=""; }	

	//审核日期 PIADM_AuditDate
	obj=document.getElementById("AuditDate");
	if (obj) { obj.value=""; }
	
	// PIADM_UpdateUser_DR
	obj=document.getElementById("UpdateUser_DR");
	if (obj) { obj.value=""; }
	
	//obj=document.getElementById("UpdateUser_DR_Name");
	//if (obj) { obj.value=""; }	

	// PIADM_UpdateDate
	obj=document.getElementById("UpdateDate");
	if (obj) { obj.value=""; }
	
	// 收费状态	PIADM_ChargedStatus
	obj=document.getElementById("ChargedStatus");
	if (obj) { obj.value=""; }
	
	// 审核状态	PIADM_CheckedStatus
	obj=document.getElementById("CheckedStatus");
	if (obj) { obj.value=""; }
	
	// 允许加项	PIADM_AddOrdItem
	obj=document.getElementById("AddOrdItem");
	if (obj) { obj.checked=false; }
	
	// 加项金额限制	PIADM_AddOrdItemLimit
	obj=document.getElementById("AddOrdItemLimit");
	if (obj) { obj.checked=false; }
	
	// 允许加项金额	PIADM_AddOrdItemAmount
	obj=document.getElementById("AddOrdItemAmount");
	if (obj) { obj.value=""; }
	
	// 允许加药	PIADM_AddPhcItem
	obj=document.getElementById("AddPhcItem");
	if (obj) { obj.checked=false; }
	
	// 加药金额限制	PIADM_AddPhcItemLimit
	obj=document.getElementById("AddPhcItemLimit");
	if (obj) { obj.checked=false; }
	
	// 允许加药金额	PIADM_AddPhcItemAmount
	obj=document.getElementById("AddPhcItemAmount");
	if (obj) { obj.value=""; }
	
	// 个人报告发送	PIADM_IReportSend
	obj=document.getElementById("IReportSend");
	if (obj) { obj.value=""; }
	
	// 结算方式	PIADM_DisChargedMode
	obj=document.getElementById("DisChargedMode");
	if (obj) { obj.value=""; }
	
	//	PIBI_UpdateUser_DR	业务员
	obj=document.getElementById("Sales_DR");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("Sales");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("Type");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("GetReportDate");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("GetReportTime");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("PayType");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("Percent");
	if (obj) { obj.value=""; }
	obj=document.getElementById("ReCheckFlag");
	if (obj) { obj.checked=false; }

}

function PreIBaseInfo_Clear_click() {
	var obj;	
	//	PIBI_RowId
	obj=document.getElementById("Age");
	if (obj) { obj.value=""; }
	//	PIBI_RowId
	obj=document.getElementById("HPNo");
	if (obj) { obj.value=""; }
	//	PIBI_RowId
	obj=document.getElementById("MedicareCode");
	if (obj) { obj.value=""; 
		obj.readOnly=false;
	}
	//	PIBI_RowId
	obj=document.getElementById("InsureUnit");
	if (obj) { obj.value=""; }
	//	PIBI_RowId
	obj=document.getElementById("CardNo");
	if (obj) { obj.value=""; }
	//	PIBI_RowId
	obj=document.getElementById("PIBI_RowId");
	if (obj) { obj.value=""; }

	//	PIBI_PAPMINo	登记号
	obj=document.getElementById("PAPMINo");
	if (obj) { obj.value=""; }

	//	PIBI_Name	姓名
	obj=document.getElementById("Name");
	if (obj) { obj.value=""; 
		obj.readOnly=false;
	}

	//	PIBI_Sex_DR	性别
	obj=document.getElementById("Sex_DR");
	if (obj) { obj.value=""; }

	obj=document.getElementById("Sex_DR_Name");
	if (obj) { obj.value=""; }

	//	PIBI_DOB	生日
	obj=document.getElementById("DOB");
	if (obj) { obj.value=""; }

	//	PIBI_PatType_DR	客人类型
	obj=document.getElementById("PatType_DR");
	if (obj) { obj.value=""; }

	obj=document.getElementById("PatType_DR_Name");
	if (obj) { obj.value=""; }

	//	PIBI_Tel1	电话号码1
	obj=document.getElementById("Tel1");
	if (obj) { obj.value=""; }

	//	PIBI_Tel2	电话号码2
	obj=document.getElementById("Tel2");
	if (obj) { obj.value=""; }

	//	PIBI_MobilePhone	移动电话
	obj=document.getElementById("MobilePhone");
	if (obj) { obj.value=""; }

	//	PIBI_IDCard	身份证号
	obj=document.getElementById("IDCard");
	if (obj) { obj.value=""; 
		obj.readOnly=false;
	}

	//	PIBI_Vocation	职业
	obj=document.getElementById("Vocation");
	if (obj) { obj.value=""; }

	//	PIBI_Position	职位
	obj=document.getElementById("Position");
	if (obj) { obj.value=""; }

	//	PIBI_Company	公司
	obj=document.getElementById("Company");
	if (obj) { obj.value=""; }

	//	PIBI_Postalcode	邮编
	obj=document.getElementById("Postalcode");
	if (obj) { obj.value=""; }

	//	PIBI_Address	联系地址
	obj=document.getElementById("Address");
	if (obj) { obj.value=""; }

	//	PIBI_Nation	民族
	obj=document.getElementById("Nation");
	if (obj) { obj.value=""; }

	//	PIBI_Email	电子邮件
	obj=document.getElementById("Email");
	if (obj) { obj.value=""; }

	//	PIBI_Married	婚姻状况
	obj=document.getElementById("Married_DR");
	if (obj) { obj.value=""; }
	obj=document.getElementById("Married_DR_Name");
	if (obj) { obj.value=""; }
		
	//	PIBI_Blood	血型
	obj=document.getElementById("Blood_DR");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("Blood_DR_Name");
	if (obj) { obj.value=""; }
	
	//	PIBI_UpdateDate	日期
	obj=document.getElementById("UpdateDate");
	if (obj) { obj.value=""; }

	//	PIBI_UpdateUser_DR	更新人
	obj=document.getElementById("UpdateUser_DR");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("UpdateUser_DR_Name");
	if (obj) { obj.value=""; }
	

}


function PreOver_click()
{   
	var Src=window.event.srcElement;
	if (Src.disabled) { return false; }
	var obj;
	
	var iRowId="",iStatus="PREREGED"
	var Instring="";
	obj=document.getElementById("PIADM_RowId");
	if (obj && ""!=obj.value) { iRowId=obj.value; }
	
	Instring=iRowId+"^"+iStatus+"^";
	
	var Ins=document.getElementById('UpdateStatus');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring);
	if ("NoItem"==flag)
	{
		alert(t[flag]);
		return;
	}else if (('Err 01'==flag)||('100'==flag)) {
		alert(t['Err 01']);
	}else if ('Err 02'==flag) {
		alert(t['Err 02']);
	}else if ('Err 03'==flag) {
		alert(t['Err 03']);
	}else if ('Err 04'==flag) {
		alert(t['Err 04']);

	}
	else if ('0'==flag) {                                  //modify  by zl 20100317 start
        location.reload();                                                //modify  by zl 20100317 end
	}
	else{
		alert("发生错误aaa:"+flag);
	}	
}
// ///////////////////////////////////////////////////////////////////////////////
// 
function SearchUser(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("PEDeskClerk_DR_Name");
		if (obj) { obj.value=aiList[0]; }


		obj=document.getElementById("PEDeskClerk_DR");
		if (obj) { obj.value=aiList[1]; }

	}
}
function GetSales(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("Sales");
		if (obj) { obj.value=aiList[0]; }


		obj=document.getElementById("Sales_DR");
		if (obj) { obj.value=aiList[1]; }

	}
}
/// 调用项目预约页面
function BNewItem_click() {
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false;}
	var iRowId="";
	
	var obj=document.getElementById("PIADM_RowId");
	if (obj) { iRowId=obj.value; }
	if (""==iRowId) { return false;}
	var PreOrAdd="PRE"
	var lnk="dhcpepreitemlist.main.csp"+"?AdmType=PERSON"
			+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
			;
	var wwidth=1000;
	var wheight=600;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}

document.body.onload = BodyLoadHandler;


//  允许加项(PGADM_AddOrdItem)
function AddOrdItem_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddOrdItem");
	var obj;

	if (src.checked) {
		// PGADM_AddOrdItemLimit 加项金额限制 
		obj=document.getElementById("AddOrdItemLimit");
		if (obj){
			obj.style.display = "inline" ;
			obj.disabled=false;
			obj.checked=true;
		}
		obj=document.getElementById("cAddOrdItemLimit");
		if (obj){ obj.style.display = "inline" ; }
		
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.style.display="inline";
			obj.disabled=false;
			obj.value="";
		}
		obj=document.getElementById("cAddOrdItemAmount");
		if (obj){ obj.style.display = "inline" ; }
		
		websys_setfocus("AddOrdItemAmount");
	}
	else{
		// PGADM_AddOrdItemLimit 加项金额限制 
		obj=document.getElementById("AddOrdItemLimit");
		if (obj){
			obj.style.display = "none" ;
			obj.disabled=true;
			obj.checked=false;
		}
		obj=document.getElementById("cAddOrdItemLimit");
		if (obj){ obj.style.display = "none" ; }
		
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.style.display = "none" ;
			obj.disable=true;
			obj.value="";
		}
		obj=document.getElementById("cAddOrdItemAmount");
		if (obj){ obj.style.display = "none" ; }
	}

}
// PGADM_AddOrdItemLimit 加项金额限制 
function AddOrdItemLimit_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddOrdItemLimit");
	var obj;
	if (src.checked) {
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.style.display = "inline" ;
			obj.disable=false;
			obj.checked=true;
		}
		obj=document.getElementById("cAddOrdItemAmount");
		if (obj){ obj.style.display = "inline" ; }
		
		websys_setfocus("AddOrdItemAmount");
	}
	else{
		obj=document.getElementById("AddOrdItemAmount");
		if (obj){
			obj.style.display="none";
			obj.value="";
		}
		obj=document.getElementById("cAddOrdItemAmount");
		if (obj){ obj.style.display = "none" ; }
			
	}
	
}
// PGADM_AddPhcItem 允许加药 
function AddPhcItem_click() {
	//var src=window.event.srcElement;
	var src=document.getElementById("AddPhcItem");
	var obj;
	
	if (src.checked) {
		// PGADM_AddPhcItemLimit 加药金额限制 
		obj=document.getElementById("AddPhcItemLimit");
		if (obj){
			obj.style.display = "inline" ;
			obj.disabled=false;
			obj.checked=true;
		}
		obj=document.getElementById("cAddPhcItemLimit");
		if (obj){ obj.style.display = "inline" ; }
		
		// PGADM_AddPhcItemAmount	允许加药金额
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.style.display="inline";
			obj.disabled=false;
			obj.value="";
		}
		obj=document.getElementById("cAddPhcItemAmount");
		if (obj){ obj.style.display = "inline" ; }
		
		websys_setfocus("AddPhcItemAmount");
		
	}
	else{
		// PGADM_AddPhcItemLimit 加药金额限制 
		obj=document.getElementById("AddPhcItemLimit");
		if (obj){
			obj.style.display = "none" ;
			obj.disabled=true;
			obj.checked=false;
		}
		obj=document.getElementById("cAddPhcItemLimit");
		if (obj){ obj.style.display = "none" ; }
		
		// PGADM_AddPhcItemAmount	允许加药金额
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.style.display="none";
			obj.disabled=true;
			obj.value="";
		}
		obj=document.getElementById("cAddPhcItemAmount");
		if (obj){ obj.style.display = "none" ; }	
	}
	
}
function UpdatePreAudit()
{
	var Type="I";
	var obj;
	obj=document.getElementById("PIADM_RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreAudit.Edit"
	//		+"&CRMADM="+ID+"&ADMType="+Type+"&GIADM=";
	var lnk="dhcpepreaudit.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
	var wwidth=800;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}
function ModifyDelayDate()
{
	var Type="Pre";
	var obj;
	obj=document.getElementById("PIADM_RowId");
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreModifyDelayDate"
			+"&ID="+ID+"&Type="+Type;
	
	var wwidth=250;
	var wheight=150;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}
// PGADM_AddPhcItemLimit 加药金额限制 
function AddPhcItemLimit_click() {
	//alert("AddPhcItemLimit_click"+src.id)
	//var src=window.event.srcElement;
	var src=document.getElementById("AddPhcItemLimit");
	var obj;
	
	if (src.checked) {
		// PGADM_AddPhcItemAmount	允许加药金额
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.disabled = false;
			obj.value="";
			obj.style.display = "inline" ;
		}
		obj=document.getElementById("cAddPhcItemAmount");
		if (obj){ obj.style.display = "inline" ; }
		websys_setfocus("AddPhcItemAmount");
	}
	else{
		// PGADM_AddPhcItemAmount	允许加药金额
		obj=document.getElementById("AddPhcItemAmount");
		if (obj){
			obj.disabled = true;
			obj.value="";
			obj.style.display = "none" ;
		}
		obj=document.getElementById("cAddPhcItemAmount");
		if (obj){ obj.style.display = "none" ; }		
	}
}

function BRegArrivePrint()
{
	var obj=document.getElementById("BRegArrivePrint");
	if (obj.disabled) return;
	var UserId=session['LOGON.USERID'];
	var Status=document.getElementById("Status");
	if (Status) Status=Status.value;
	if (Status!="PREREGED") return;
	var encmeth=document.getElementById('GetDataBox');
	if (encmeth) encmeth=encmeth.value;
	var CRMId=document.getElementById('ID');
	if (CRMId) CRMId=CRMId.value;
	if (CRMId=="") return;
	var flag=cspRunServerMethod(encmeth,CRMId,UserId);
			
	if (flag!='') {
    	alert(t['FailsTrans']+"  error="+flag);
    	return false
    }
    encmeth=document.getElementById('IAdmArrivedBox');        
	if (encmeth) encmeth=encmeth.value;
	var flag=cspRunServerMethod(encmeth,CRMId);///////////
    if (flag!='0') {
    	alert(t['FailsArrived']+"  error="+flag);
    	return false
    }
    PatItemPrint();
    //PrintLisRis(CRMId)
    //BarCodePrintByCrm(CRMId);
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreIADM.Edit";
    window.location.href=lnk;
}

function Register()
{
	var obj=document.getElementById("HospitalCode");
	if (obj){ HospitalCode=obj.value;}
	var obj=document.getElementById("BRegister");
	if (obj.disabled) return;
	var UserId=session['LOGON.USERID'];
	var Status=document.getElementById("Status");
	if (Status) Status=Status.value;
	if (Status!="PREREGED") return;
	var encmeth=document.getElementById('GetDataBox');
	if (encmeth) encmeth=encmeth.value;
	var CRMId=document.getElementById('ID');
	if (CRMId) CRMId=CRMId.value;
	if (CRMId=="") return;
	var flag=cspRunServerMethod(encmeth,CRMId,UserId);
			
	if (flag!='') {
    	alert(t['FailsTrans']+"  error="+flag);
    	return false
    }
    else {
	    
	    alert("登记成功!");
	    //if (HospitalCode=="SHDF")            //add by zl 20100322 start
		//{
	   PatItemPrint()
		//BarCodePrint(CRMId);  
		//}          //add by zl 20100322 end
	    location.reload();
	    //return true;
    }
    
    /*encmeth=document.getElementById('IAdmArrivedBox');        
	if (encmeth) encmeth=encmeth.value;
	var flag=cspRunServerMethod(encmeth,CRMId);///////////
    if (flag!='0') {
    	alert(t['FailsArrived']+"  error="+flag);
    	return false
    }
    */
    //?? var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreIADM.Edit";
    //?? window.location.href=lnk;
}
function RegisterPrint_Click()
{
	var obj=document.getElementById("BRegisterPrint");
	if (obj.disabled) return;
	var CRMId=document.getElementById('ID');
	if (CRMId) CRMId=CRMId.value;
	if (CRMId=="") return;
	var rtn=Register();
	if (rtn==true)
	{
		PatItemPrint()
		//PrintLisRis(CRMId)
		//BarCodePrintByCrm(CRMId);
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreIADM.Edit";
    	window.location.href=lnk;
	}
}
function Arrived()
{
	var CRMId=document.getElementById('ID');
 
	if (CRMId) CRMId=CRMId.value;
	if (CRMId=="") return;
	//Status=GetCtlValueById('TStatus'+'z'+i,1);
	//if (Status=="REGISTERED") {	
	//设置到达状态
	
	encmeth=GetCtlValueById('BArrivedBox',1);        
    var flag=cspRunServerMethod(encmeth,CRMId);///////////
    if (flag!='0') {
    	alert(t['FailsArrived']+"  error="+flag);
    	return false
    }
    
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreIADM.Edit";
    window.location.href=lnk;
}
function RegAndArrived_click()
{  
	
    var obj=document.getElementById("HospitalCode");
	if (obj){ HospitalCode=obj.value;}
	var UserId=session['LOGON.USERID'];
	var Status=document.getElementById("Status");
	if (Status) Status=Status.value;
	if (Status!="PREREGED") return;
	var encmeth=document.getElementById('GetDataBox');
	if (encmeth) encmeth=encmeth.value;
	var CRMId=document.getElementById('ID');
	if (CRMId) CRMId=CRMId.value;
	
	if (CRMId=="") return;
	var flag=cspRunServerMethod(encmeth,CRMId,UserId);
	if (flag!='') {
    	alert(t['FailsTrans']+"  error="+flag);
    	return false
    }
    encmeth=document.getElementById('IAdmArrivedBox');        
	if (encmeth) encmeth=encmeth.value;
	var flag=cspRunServerMethod(encmeth,CRMId);///////////
	if (flag==0){    
	    //if (HospitalCode=="SHDF")            //add by zl 20100322 start
		//{
			 PatItemPrintA4()
		//BarCodePrint(CRMId);  
		//}  
		}
    if (flag!='0') {
    	alert(t['FailsArrived']+"  error="+flag);
    	return false
    }
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreIADM.Edit";
    window.location.href=lnk;
}
// 打印导检单
function PatItemPrint() {
	// 打印 打印单

	DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrint");
	var CRMId=document.getElementById('PIADM_RowId');
	if (CRMId) CRMId=CRMId.value;
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	var Instring=CRMId+"^"+DietFlag+"^CRM"+"^";
	var Ins=document.getElementById('GetOEOrdItemBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'','',Instring);
	Print(value);
		
}
// 打印导检单A4
function PatItemPrintA4()  
{ 
	DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrintA4");
	var Page="A4"
	obj=document.getElementById("ID");  
	
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	var Instring=CRMId+"^"+DietFlag+"^CRM"+"^"+Page;
    var Ins=document.getElementById('GetOEOrdItemBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'','',Instring);
    //alert(value)
	 Print(value,Page);
}

function BarCodePrint(CRMId)

{	
    var obj=document.getElementById('GetIADMIDBox');
	if (obj) {var encmeth=obj.value; } else {var encmeth=''; }
	var PAADM=cspRunServerMethod(encmeth,CRMId); 
    var Ins=document.getElementById("PatOrdItemInfo");
	if (Ins) {var encmeth1=Ins.value; } else {var encmeth1=''; };
	var flag=cspRunServerMethod(encmeth1,"BarPrint","",PAADM,"Y","N");
	BarPrint(flag);
}


//个人基本信息打印
function PrintPatBaseInfo(CRMId)
{	 
	var obj=document.getElementById('GetIADMIDBox');
	if (obj) {var encmeth=obj.value; } else {var encmeth=''; }
	var PAADMId=cspRunServerMethod(encmeth,CRMId); 
	if(PAADMId=="")	return;
	PrintStation(PAADMId); 
}

//入职入户招调体检内部条码打印
function PrintPatBaseInfoForSpecial(CRMId)
{	  
	var obj=document.getElementById('GetIADMIDBox');
	if (obj) {var encmeth=obj.value; } else {var encmeth=''; }
	
	var PAADMId=cspRunServerMethod(encmeth,CRMId); 
	if(PAADMId=="")	return;  
	PrintStationForSpecial(PAADMId); 
}

function BarPrint(value) {
 	
    if (""==value) {
		//alert("未找到检验项目");
		return false;
	}
	/*
	if (value=="NoPayed")
	{
		alert(t["NoPayed"])
		return false;
	}
	*/
	var ArrStr=value.split("$$");
	var Num=0
	if (ArrStr.length>1) Num=ArrStr[1];
	value=ArrStr[0];
	PrintBarApp(value,"")
	return;	
}

function PrintOld(value)
{	
	var TxtInfo="",ListInfo="";
	var Char_2=String.fromCharCode(2);
	var vals=value.split("#");
	
	// 患者信息
	PatInfos=vals[0].split(";");
	
	var PatTag=PatInfos[0].split("^"); // 标签
	var PatInf=PatInfos[1].split("^"); // 值

	for (var iLLoop=0;iLLoop<PatTag.length;iLLoop++){
		TxtInfo=TxtInfo+PatTag[iLLoop]+Char_2+PatInf[iLLoop]+"^";
	}	
	
	// 检验项目
	ListInfo="";
	var OEItems=vals[1].split(";");
	var ShortLine="_____________";
	var NullLine="             ";
	var Line1="__________________________"
	var Line2="_______________________________________";
	var Line3="______"
	var LineStr="";
	for (var iLLoop=0;iLLoop<OEItems.length-1;iLLoop++){
		OEItem=OEItems[iLLoop].split("^");
		if (""!=OEItem[0]) var ItemName=OEItem[0]
		
		if (OEItem[0]==""){LineStr=NullLine+"^"+Line1+"^"+Line2+"^"+Line3;}
		if (OEItem[0]!=""){LineStr=ShortLine+"^"+Line1+"^"+Line2+"^"+Line3;}
		if (iLLoop!=OEItems.length-1)
		{
			var NextItem=OEItems[iLLoop+1].split("^")[0];
			if (NextItem!=""){LineStr=ShortLine+"^"+Line1+"^"+Line2+"^"+Line3;}
			if (NextItem==""){LineStr=NullLine+"^"+Line1+"^"+Line2+"^"+Line3;}
			if (OEItem[4]==OEItems[iLLoop+1].split("^")[4]){LineStr="^^^";}
		}
		if (0==(iLLoop+1) % 31) {LineStr="^^^";}   //如果是本页最后以行去掉横线
		if (1==(iLLoop+1) % 31) {OEItem[0]=ItemName;} //如果是后续页打印出来类别与流程
		 				 // 横线	      类别流程 1	项目 2		注意事项 3
		ListInfo=ListInfo+LineStr+"^"+OEItem[0]+"^"+OEItem[1]+"^"+OEItem[2]+Char_2;  //
		//分页 每页24行
		
		if ((0==(iLLoop+1) % 31)) {
			var myobj=document.getElementById("ClsBillPrint");
			DHCP_PrintFun(myobj,TxtInfo,ListInfo);
			//if (!DHCP_PrintFun(myobj,TxtInfo,ListInfo)) return false;
			//alert(ListInfo);
			ListInfo="";
		}
	}
	if (ListInfo!=""){
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);}
	
	//alert("导检单打印完毕");
	/*
	TxtInfo="RegNo"+c+"000109"+"^"+
			"PatName"+c+"赵君"+"^"+
			"amt"+c+"ddddd"+"^"+
			"amtdx"+c+"sssssssss"+"^";
	ListInfo="一般检查^空腹项目^一般检查"
			+c+"内科^餐后项目^内科查体"
			+c+"检验室^^尿常规"
			;	
	alert(ListInfo);
	*/
}

function UpdateAsCharged()
{
	var Type="I";
	var obj;
	obj=document.getElementById("PIADM_RowId");
	
	if (obj){ var ID=obj.value;}
	else{return false;}
	if (ID=="") return false;
	obj=document.getElementById("UpdateAsCharged");
	if (obj) var encmeth=obj.value;
	var Return=cspRunServerMethod(encmeth,ID,Type)
	if (Return==""){alert("Status Err");}
	else if (Return=="SQLErr"){alert("Update Err");}
	else{alert("Update Success!");}
}
	
//Create by MLH 20071213
function TransRegNo(RegNo){
	var obj=document.getElementById("PAPMINo");
	obj.value=RegNo;
	RegNoOnChange();
}

function SetHisInfo(value)
{
	var obj;
	var Data=value.split("^");
	var iLLoop=1
	//	PIBI_PAPMINo	登记号	1
	obj=document.getElementById("PAPMINo");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Name	姓名	2
	obj=document.getElementById("Name");
	if (obj) { obj.value=Data[iLLoop]; 
	obj.readOnly=true;
	}
	
	iLLoop=iLLoop+1;
	//	PIBI_Sex_DR	性别	3
	obj=document.getElementById("Sex_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	// 性别 3.1
	obj=document.getElementById("Sex_DR_Name");
	if (obj) { obj.value=Data[iLLoop-1]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_DOB	生日	4
	obj=document.getElementById("DOB");
	 if (obj && Data[iLLoop]) {
	if ((Data[iLLoop].split("/")[2].length)==2)             //add by zhouli 处理生日显示格式以及年份为20开头的数据
    {var DOB="19"+Data[iLLoop].split("/")[2]+"-"+Data[iLLoop].split("/")[1]+"-"+Data[iLLoop].split("/")[0]} //add by zhouli
    else {var DOB=Data[iLLoop].split("/")[2]+"-"+Data[iLLoop].split("/")[1]+"-"+Data[iLLoop].split("/")[0]} //add by zhouli
    obj.value=DOB;  }
	
	iLLoop=iLLoop+1;
	//	PIBI_PatType_DR	客人类型	5
	//obj=document.getElementById("PatType_DR");
	//if (obj) { obj.value=Data[iLLoop]; }
	
	//iLLoop=iLLoop+1;
	//	5.1
	//obj=document.getElementById("PatType_DR_Name");
	//if (obj) { obj.value=Data[iLLoop]; }
	
	
	obj=document.getElementById("HospitalCode");  //Modify by zl20100222 start
	if (obj){ HospitalCode=obj.value;}
	obj=document.getElementById("PatType_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	/*
	if (HospitalCode=="SHDF")
	{obj=document.getElementById("PatType_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	}
	else
	{
		obj=document.getElementById("PatType_DR");
		if (obj) { obj.value=Data[iLLoop]; }
		iLLoop=iLLoop+1;
		obj=document.getElementById("PatType_DR_Name");
	    if (obj && Data[iLLoop]) { obj.value=Data[iLLoop]; }
	}
	*/
	                                                          //Modify by zl20100222 end
	
	iLLoop=iLLoop+1;
	//	PIBI_Tel1	电话号码1	6
	obj=document.getElementById("MobilePhone");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Tel2	电话号码2	7
	obj=document.getElementById("Tel2");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_MobilePhone	移动电话	8
	obj=document.getElementById("Tel1");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_IDCard	身份证号	9
	obj=document.getElementById("IDCard");
	if (obj) { obj.value=Data[iLLoop]; 
		obj.readOnly=true;
	}
	
	iLLoop=iLLoop+1;
	//	PIBI_Vocation	职业	10
	obj=document.getElementById("Vocation");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Position	职位	11
	obj=document.getElementById("Position");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Company	公司	12
	obj=document.getElementById("Company");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Postalcode	邮编	13
	obj=document.getElementById("Postalcode");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Address	联系地址	14
	obj=document.getElementById("Address");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Nation	民族	15
	obj=document.getElementById("Nation");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Email	电子邮件	16
	obj=document.getElementById("Email");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_Married	婚姻状况	17
	obj=document.getElementById("Married_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	//	17.1
	obj=document.getElementById("Married_DR_Name");
	if (obj) { obj.value=Data[iLLoop-1]; }
	
	iLLoop=iLLoop+1;	
	//	PIBI_Blood	血型	18
	obj=document.getElementById("Blood_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	血型 18.1
	obj=document.getElementById("Blood_DR_Name");
	if (obj) { obj.value=Data[iLLoop-1]; }
	
	iLLoop=iLLoop+1;	
	//	PIBI_UpdateDate	日期	19
	obj=document.getElementById("UpdateDate");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	PIBI_UpdateUser_DR	更新人	20
	obj=document.getElementById("UpdateUser_DR");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//	20.1
	obj=document.getElementById("UpdateUser_DR_Name");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	//	20.1
	obj=document.getElementById("HPNo");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	//	20.1
	obj=document.getElementById("Age");
	if (obj) { obj.value=Data[iLLoop].split("Y")[0]; }

	iLLoop=iLLoop+5;
	//	20.1
	obj=document.getElementById("CardNo");
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	obj=document.getElementById("VIPLevel");
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	obj=document.getElementById("MedicareCode");
	if (obj) { obj.value=Data[iLLoop]; 
		obj.readOnly=true;
	}
	
	var CurDate=""
	obj=document.getElementById("CurDate");
	if (obj) {CurDate=obj.value;}
	obj=document.getElementById("PEDateBegin");
	if (obj) {obj.value=CurDate;}
	obj=document.getElementById("PEDateEnd");
	if (obj) {obj.value=CurDate;}
	return true;
}
function Age_Change()
{   
	//年龄
	obj=document.getElementById("Age");
	if (obj){iAge=obj.value;}
	if (iAge=="") return false;
	if (!(isNaN(iAge)))
	{
		var obj=document.getElementById("DOB");
		if (iAge=="") {iAge=0}
		if (obj.value!="") return;
		iAge=parseInt(iAge)
		var D   =   new   Date();
	    var Year=D.getFullYear();
	    var Year=Year-iAge
	    obj.value=Year+"-01"+"-01"
	    //obj.value="01/01/"+Year;

	}
}
function SetDefault()
{
	var SexNV="",ADMFeeType="",VIPNV=""
	var obj=document.getElementById("SexNV");
	if (obj) SexNV=obj.value;
	SexNV=SexNV.split("^");
	obj=document.getElementById("Sex_DR_Name");	//	列表框时使用
	if (obj) { obj.value=SexNV[1]; }
	obj=document.getElementById("PatType_DR_Name");		//	列表框时使用
	if (obj) { obj.value=SexNV[0]; }
	var CurDate="";
	var obj=document.getElementById("CurDate");
	if (obj) CurDate=obj.value;
	var obj=document.getElementById("PEDateBegin");
	if (obj) obj.value=CurDate;
	var obj=document.getElementById("PEDateEnd");
	if (obj) obj.value=CurDate;
	var obj=document.getElementById("GetADMFeeType");
	if (obj) {ADMFeeType=obj.value;}
	var obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) {obj.value=ADMFeeType;}
	var obj=document.getElementById("GetVIP");
	if (obj) VIPNV=obj.value;  
	obj=document.getElementById("VIPLevel");	//	列表框时使用
	if (obj) { obj.value=VIPNV; }
	obj=document.getElementById('DietFlag');
	if (obj){ obj.checked=true;}
}
function SaveIBIInfo()
{
	var iRowId="",iHPNo="",iHCPDR="",iCardNo,iVIPLevel="";
	var iPAPMINo="", iName="", iSex_DR="", iDOB="", iPatType_DR="", iTel1="", iTel2="", iMobilePhone="", iIDCard="", iVocation="", iPosition="", iCompany="", iPostalcode="", iAddress="", iNation="", iEmail="", iMarriedDR="", iBloodDR="", iUpdateDate="", iUpdateUserDR="",iHCADR="";	  
	var obj;
     obj=document.getElementById("HospitalCode");
	if (obj){ HospitalCode=obj.value;}
	//	PIBI_RowId	21
	obj=document.getElementById("PIBI_RowId");
	if (obj) { iRowId=obj.value; }
	
	//	PIBI_PAPMINo	登记号	1	不能修改
	obj=document.getElementById("PAPMINo");
	if (obj) { iPAPMINo=obj.value; }
	//	PIBI_Name	姓名	2
	obj=document.getElementById("Name");
	if (obj) { iName=obj.value; }
	if (iName==""){
		alert("病人姓名不能为空");
		websys_setfocus("Name");
		return false;
	}
	//	PIBI_Sex_DR	性别	3
	//obj=document.getElementById("Sex_DR");	//	文本框时使用
	obj=document.getElementById("Sex_DR_Name");	//	列表框时使用
	if (obj) { iSex_DR=obj.value; }
	if (iSex_DR==""){
		alert("病人性别不能为空");
		websys_setfocus("Sex_DR_Name");
		return false;
	}
	//	PIBI_IDCard	身份证号	9
	obj=document.getElementById("IDCard");
	if (obj) { iIDCard=obj.value; }
	iIDCard=trim(iIDCard)
	if (!isIdCardNo(iIDCard)) return;
	
	 
	//	PIBI_DOB	生日	4
	obj=document.getElementById("DOB");
	if(obj.value==""){Age_Change()}
	obj=document.getElementById("DOB");
	if (obj) { iDOB=obj.value; }
	if (iDOB==""){
		alert("病人生日不能为空");
		websys_setfocus("DOB");
		return false;
	}
	if (iDOB!="") {var iDOB=iDOB.split("-")[2]+"/"+iDOB.split("-")[1]+"/"+iDOB.split("-")[0]}  //add by zhouli
	//	PIBI_PatType_DR	客人类型	5
	
	//obj=document.getElementById("PatType_DR");	//	文本框时使用
	iPatType_DR="1";
	obj=document.getElementById("PatType_DR_Name");		//	列表框时使用
	if (obj) { iPatType_DR=obj.value; }

	
	//	PIBI_Tel2	电话号码2	7
	obj=document.getElementById("Tel2");
	if (obj) { iTel2=obj.value; }

	//	PIBI_MobilePhone	移动电话	8
	obj=document.getElementById("MobilePhone");
	if (obj) { iMobilePhone=obj.value; }
	//iMobilePhone=trim(iMobilePhone);
	if (!isMoveTel(iMobilePhone))
	{
		websys_setfocus(obj.id);
		return;
	}
	if (iMobilePhone==""){
		alert("客人移动电话不能为空");
		websys_setfocus("MobilePhone");
		return false;
	}
	
	//	PIBI_Tel1	电话号码1	6
	obj=document.getElementById("Tel1");
	if (obj) { iTel1=obj.value; }

	
	//	PIBI_Vocation	职业	10
	obj=document.getElementById("Vocation");
	if (obj) { iVocation=obj.value; }
  
	//	PIBI_Position	职位	11
	obj=document.getElementById("Position");
	if (obj) { iPosition=obj.value; }
    
    //VIP等级
	obj=document.getElementById("VIPLevel");
	if (obj) { iVIPLevel=obj.value; }
  
    
	//	PIBI_Company	公司	12
	obj=document.getElementById("Company");
	if (obj) { iCompany=obj.value; }

	//	PIBI_Postalcode	邮编	13
	obj=document.getElementById("Postalcode");
	if (obj) { iPostalcode=obj.value; }

	//	PIBI_Address	联系地址	14
	obj=document.getElementById("Address");
	if (obj) { iAddress=obj.value; }

	//	PIBI_Nation	民族	15
	obj=document.getElementById("Nation");
	if (obj) { iNation=obj.value; }

	//	PIBI_Email	电子邮件	16
	obj=document.getElementById("Email");
	if (obj) { iEmail=obj.value; }

	//	PIBI_Married	婚姻状况	17
	//obj=document.getElementById("Married_DR");	//	文本框时使用
	obj=document.getElementById("Married_DR_Name");		//	列表框时使用
	if (obj) { iMarriedDR=obj.value; }
	
	//	PIBI_Blood	血型	18
	//obj=document.getElementById("Blood_DR");	//	文本框时使用
	obj=document.getElementById("Blood_DR_Name");	//	列表框时使用
	if (obj && ""!=obj.value) { iBloodDR=obj.value; }
	//	PIBI_UpdateDate	日期	19
	//obj=document.getElementById("UpdateDate");
	//if (obj) { iUpdateDate=obj.value; }
	iUpdateDate='';

	//	PIBI_UpdateUser_DR	更新人	20
	//obj=document.getElementById("UpdateUser_DR");
	//if (obj) { iUpdateUser_DR=obj.value; }
	iUpdateUserDR=session['LOGON.USERID'];
	
	
	// /////////////////////       数据验证          ////////////////////////////////////
	//根据流程的不同?处理登记号
	obj=document.getElementById("IBIUpdateModel");
	var FIBIUpdateModel=obj.value;
	//
	if (obj && "NoGen"==obj.value) {}

	//
	if (obj && "Gen"==obj.value) {
		// 登记号必须
		if (""==iPAPMINo) {
			//alert("Please entry all information.");
			obj=document.getElementById("PAPMINo")
			if (obj) {
				obj.value="";
				websys_setfocus(obj.id);
				obj.className='clsInvalid';
			}
			alert(t['01']);
			return false;
		} 
	}
	if (obj && "FreeCreate"==obj.value) {
		// 登记号必须
		if (""==iPAPMINo) {
			//alert("Please entry all information.");
			obj=document.getElementById("PAPMINo")
			if (obj) {
				obj.value="";
				websys_setfocus(obj.id);
				obj.className='clsInvalid';
			}
			alert(t['01']);
			return false;
		}
		if (isNaN(iPAPMINo)){
			//alert("Please entry all information.");
			obj=document.getElementById("PAPMINo")
			if (obj) {
				websys_setfocus(obj.id);
				obj.className='clsInvalid';
			} 
			alert('登记号不是数字');
			return false;
		}
	}
	// 患者类型必须
	if (""==iPatType_DR) {
		//alert("Please entry all information.");
		
		obj=document.getElementById("PatType_DR_Name")
		if (obj) {
			obj.value="";
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert(t['01']);
		return false;
	}

	// 姓名必须
	if (""==iName) {
		//alert("Please entry all information.");
		
		obj=document.getElementById("Name")
		if (obj) {
			obj.value="";
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert(t['01']);
		return false;
	}
    
     	 //年龄不能为空
	if (HospitalCode=="LZEY") {
	obj=document.getElementById("Age")
	if (""==obj.value) 
	{	alert("年龄不能为空");
	     return false
	websys_setfocus(obj.id);
	obj.className='clsInvalid'
		alert(t['01']);
		return false;
	}
	}
	// 性别必须
	if (""==iSex_DR) {
		//alert("Please entry all information.");
		
		obj=document.getElementById("Sex_DR_Name")
		if (obj) {
			obj.value="";
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert(t['01']);
		return false;
	}
	// 生日必须

	if (""==iDOB) {
		//alert("Please entry all information.");
		
		obj=document.getElementById("DOB")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		
		alert(t['01']);
		return false;
	}
	/*
	// 婚姻状况必须
	if (""==iMarriedDR) {
		//alert("Please entry all information.");
		alert(t['01']);
		obj=document.getElementById("Married_DR_Name")
		if (obj) {
			obj.value="";
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		return false;
	}
	*/
	var HPNo=document.getElementById("HPNo");
	if (HPNo) iHPNo=HPNo.value;
	var HCPDR=document.getElementById("hcpdr");
	if (HCPDR) iHCPDR=HCPDR.value;
	
	var HCADR=document.getElementById("HCADR");
	if (HCADR) iHCADR=HCADR.value;
	
	var CardNo=document.getElementById("CardNo");
	if (CardNo) iCardNo=CardNo.value;
	if (iCardNo!="") iCardNo=iCardNo+"$"+m_SelectCardTypeRowID;
	var iHospitalCode=""
	var HospitalCode=document.getElementById("HospitalCode");
	if (HospitalCode) iHospitalCode=HospitalCode.value;
	
	var CardRelate=document.getElementById("CardRelate");
	/*
	if (CardRelate)
	{
		if ((CardRelate.value=="Yes")&&(iCardNo=="")&&(iHospitalCode!="SHDF"))  
		{
			alert("卡号不能为空")
			websys_setfocus("BReadCard");
			return;
		}
	}
	*/

	if ((iHospitalCode=="FX")&(iHCADR==""))
	{
		alert(t["01"])
		var obj=document.getElementById("HCADesc");
		websys_setfocus("HCADesc");
		obj.className='clsInvalid';
		return false;
	}
	
	var iMedicareCode=""
	var MedicareCode=document.getElementById("MedicareCode");
	if (MedicareCode) iMedicareCode=MedicareCode.value;
	var Instring=	trim(iRowId)			//			1 
				+"^"+trim(iPAPMINo)			//登记号    2
				+"^"+trim(iName)			//姓名		3
				+"^"+trim(iSex_DR)			//性别		4
				+"^"+trim(iDOB)				//生日		5
				+"^"+trim(iPatType_DR)		//客人类型	6
				+"^"+trim(iTel1)			//电话号码1	7
				+"^"+trim(iTel2)			//电话号码2	8
				+"^"+trim(iMobilePhone)		//移动电话	9
				+"^"+trim(iIDCard)			//身份证号	10
				+"^"+trim(iVocation)		//职业		11
				+"^"+trim(iPosition)		//职位		12
				+"^"+trim(iCompany)			//公司		13
				+"^"+trim(iPostalcode)		//邮编		14
				+"^"+trim(iAddress)			//联系地址	15
				+"^"+trim(iNation)			//民族		16
				+"^"+trim(iEmail)			//电子邮件	17
				+"^"+trim(iMarriedDR)		//婚姻状况	18
				+"^"+trim(iBloodDR)			//血型		19
				+"^"+trim(iUpdateDate)		//日期		20
				+"^"+trim(iUpdateUserDR)	//更新人	21
				+"^"+trim(iHPNo)
				+"^"+trim(iHCPDR)
				+"^"+trim(iHCADR)
				+"^"+trim(iCardNo)
				+"^"+trim(iVIPLevel)
				+"^"+trim(iMedicareCode)
				+";"+FIBIUpdateModel
				

	var Ins=document.getElementById('IBIClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	//obj=document.getElementById("PIBI_RowId");
	if (iRowId!=""){
		return true;
	}
	//if (""==iRowId) { //插入操作
		var Data=flag.split("^");
		flag=Data[0];
		iRowId=Data[1];
		iRegNo=Data[2];
	//}
	if (flag=='0') {
		obj=document.getElementById("PIBI_RowId");
		if ((obj)&&(obj.value=="")) { obj.value=iRowId; }
		obj=document.getElementById("PAPMINo");
		if (obj) { obj.value=iRegNo; }
		return true;
	}
	return false;
}
///判断身份证号?并且如果生日为空自动填上生日
function isIdCardNo(num) {
	if (num=="") return true;
	var ShortNum=num.substr(0,num.length-1)
	if (isNaN(ShortNum))
	{
		//alert("输入的不是数字?");
		return true;
	}
	var len = num.length;
	var re;
	if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{3})$/);
	else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
	else {//alert("身份证号输入的数字位数不对?");
	//websys_setfocus("IDCard");
	return true;}
	var ShortNum=ShortNum+"1"
	var a = (ShortNum).match(re);
	if (a != null)
	{
		if (len==15)
		{
			var D = new Date("19"+a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
		}
		else
		{
			var D = new Date(a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
		}
		if (!B)
		{
			alert("输入的身份证号 "+ a[0] +" 里出生日期不对?");
			websys_setfocus("IDCard"); //DGV2DGV2
			return false;
		}
		var obj=document.getElementById("DOB");
		//if ((obj)&&(obj.value=="")) obj.value=a[5]+"/"+a[4]+"/"+a[3];
		//if (obj) obj.value=a[5]+"/"+a[4]+"/"+a[3];
		if (obj) obj.value=a[3]+"-"+a[4]+"-"+a[5];     //modify by zhouli
		var Dateinit=new Date           //add by zhouli start	输入身份证号后按tab键可以自动生成年龄	
        var Yearinit=Dateinit.getYear()
	    var Year=Yearinit-a[3]
		var obj=document.getElementById("Age");
		if (obj) obj.value=Year;       //add by zhouli end 
		if (len==15)
		{
			var SexFlag=num.substr(14,1);
		}
		else
		{
			var SexFlag=num.substr(16,1);
		}
		var SexNV=""
		var obj=document.getElementById("SexNV");
		if (obj) SexNV=obj.value;
		SexNV=SexNV.split("^");
		var obj=document.getElementById("Sex_DR_Name");
		if (SexFlag%2==1)
		{
			obj.value=SexNV[2];
		}
		else
		{
			obj.value=SexNV[3];
		}
		
	}
	return true;
}
function DOB_OnBlur()
{
	var mybirth=DHCWebD_GetObjValue("DOB");
	
	if ((mybirth!="")&&((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("DOB");
		alert("请输入正确的日期");
		websys_setfocus("DOB");
		return websys_cancel();
	}else{
		var obj=document.getElementById("DOB");
		obj.className='clsvalid';
	}	
	if ((mybirth.length==8)){
		var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
	
		DHCWebD_SetObjValueA("DOB",mybirth);
		
	}
    if (mybirth!="") {
	var myrtn=DHCWeb_IsDate(mybirth,"-")
	if (!myrtn){
		var obj=document.getElementById("DOB");
 
		alert("请输入正确的日期");
		//websys_setfocus("DOB");
		return websys_cancel();
	}else{
		var myAge=tkMakeServerCall("web.DHCPE.DHCPECommon","GetCurAge",mybirth);
		
		//var myAge=DHCWeb_GetAgeFromBirthDay("DOB");
		DHCWebD_SetObjValueA("Age",myAge);
	}
	}
	var mybirth1=DHCWebD_GetObjValue("DOB");
	var Checkrtn=CheckBirth(mybirth1);
	if(Checkrtn==false){
		alert('出生日期不能大于今天!');
		websys_setfocus("DOB");
		return websys_cancel();
	}


}
function CheckBirth(Birth)
{
	var Year,Mon,Day,Str;
	Str=Birth.split("-")
	Year=Str[0];
	Mon=Str[1];
	Day=Str[2];
	
	var Today,ToYear,ToMon,ToDay;
	Today=new Date();
	ToYear=Today.getYear();
	ToMon=(Today.getMonth()+1);
	ToDay=Today.getDate();
	if((Year > ToYear)){
		return false;
	}
	else if((Year==ToYear)&&(Mon>ToMon)){
		return false;
	}
	else if((Year==ToYear)&&(Mon==ToMon)&&(Day>ToDay)){
		return false;
	}
	else return true;
}

//预约到达日期
function AppointArrivedDate()

{
	
	var obj;
	var obj=document.getElementById("PIADM_RowId");
	if (obj) { var ID=obj.value; }
	if (""==ID) { return false;}
	var Type="I"
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEAppointArrivedDate"
			+"&ID="+ID+"&Type="+Type
	
		var wwidth=350;
	var wheight=200;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
	}
	
function PrintRisRequestPre()
{   
	var obj=document.getElementById("PIADM_RowId");  
	if (obj){ PreIADMDR=obj.value; }
	
	PrintRisRequestApp(PreIADMDR,"","PreIADM");

	return false;
}
function PrintReportRJ()
{
	var obj=document.getElementById("PIADM_RowId");  
	if (obj){ PreIADMDR=obj.value; }
	Clear_click();
	PrintReportRJApp(PreIADMDR,"PreIADM");
}
///入职体检预约固定套餐1882
function BItemPrint_click()
{
	var PreIADMDR="",UserID="";
	var obj=document.getElementById("PIADM_RowId");  
	if (obj){ PreIADMDR=obj.value; }
	if (PreIADMDR==""){
		alert("没有预约信息")
		return false;
	}
	UserID=session['LOGON.USERID'];
	var flag=tkMakeServerCall("web.DHCPE.PreItemList","IInsertItem",PreIADMDR,"PERSON","PRE","","1882",UserID);
	if (flag=="Notice"){
		alert("已审核,加人加项需取消审核!");
		return false;
	}
    	if (flag!="") {
	   	alert(t['ErrSave']+":"+flag);
	   	return false;
    	}
    	flag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","UpdateIADMInfo",PreIADMDR,"3");
    	if (flag!='0') {
    		alert(t['FailsTrans']+"  error="+flag);
    		return false
	}
	PatItemPrint();
	PrintRisRequest();
	Clear_click();
	PrintReportRJApp(PreIADMDR,"PreIADM");
}
