var photoPath="D:\\DHCPE\\"
    
function ButtonDisabled(ButtonName){
    obj=document.getElementById(ButtonName);
    obj.disabled=true;
    obj.onclick= function(){return false};
}
function ButtonEnabled(ButtonName){
    obj=document.getElementById(ButtonName);
    obj.disabled=false;
    //obj.onclick=ButtonName+"_Click";
}
function TextboxDisabled(TextboxName){
    obj=document.getElementById(TextboxName);
    obj.disabled=true;
    //obj.onclick= function(){return false};
}
function TextboxEnabled(TextboxName){
    obj=document.getElementById(TextboxName);
    obj.disabled=false;
}
///�س�������ѡ�񴰿�
function Muilt_LookUp(Value)
{
    var value=Value.split("^")
    var i=0;
    for (i=0;i<value.length;i++)
    {
        var obj=document.getElementById(value[i]);
        if (obj) obj.onkeydown=KeyDown_LookUp;
    }
}
function KeyDown_LookUp()
{
    if (event.keyCode==13)
    { 
        var eSrc=window.event.srcElement;
        var lobj=document.getElementById(GetLookupName(eSrc.name));
        if (lobj) lobj.click();
    }
}
function GetLookupName(name)
{
    return "ld"+GetElementValue("GetComponentID")+"i"+name
}
function GetElementValue(ename)
{
    var obj,evalue;
    evalue="";
    obj=document.getElementById(ename);
    if (obj)
    {
        evalue=obj.value;
        //if (evalue==null)  evalue=obj.innerText;
    }
    return evalue;
}


function ReadCardApp(RegNoElementName,FunctionName,CardElementName)
{
    /*
    var rtn=DHCACC_GetAccInfo()
    var ReturnArr=rtn.split("^");
    if (ReturnArr[0]=="-200")
    {
         var rtn=DHCACC_ReadMagCard();
         obj=document.getElementById(CardElementName);
         if (obj) obj.value=rtn.split("^")[1];
         return false;
    }*/
    ////������ע��?����ſ�����
    
    var myoptval=combo_CardType.getSelectedValue(); 
    var rtn=DHCACC_GetAccInfo(m_SelectCardTypeRowID,myoptval);     //������Ŀ����ȡ������Ϣ?����Ϣ?�˻���Ϣ

    var ReturnArr=rtn.split("^");
    if (ReturnArr[0]=="-200")
    {
         obj=document.getElementById(CardElementName);
         if (obj) obj.value=rtn.split("^")[1];
         return false;
    }
    
    
    var obj=document.getElementById(RegNoElementName)
    if (obj)
    {
         obj.value=ReturnArr[5];
         eval(FunctionName);
         obj=document.getElementById(CardElementName);
         if (obj) obj.value=ReturnArr[1];
        
    }
    
}
function CardNo_KeyDown()
{   var key=websys_getKey(e);
    if (13==key) {
        CardNo_Change();
        
    }
}
function CardNoChangeApp(RegNoElement,CardElement,AppFunction,AppFunctionClear,ClearFlag)
{
    var obj;
    var CardNo="",encmeth;
    obj=document.getElementById(CardElement);
    if (obj) CardNo=obj.value;
    if (CardNo=="") return;
    if (ClearFlag=="1") eval(AppFunctionClear);
    obj.value=CardNo;
    obj=document.getElementById("GetRegNoByCardNo");
    if (obj) encmeth=obj.value;
    if (encmeth=="") return;
    CardNo=CardNo+"$"+m_SelectCardTypeRowID;
    //alert(CardNo)
    RegNo=cspRunServerMethod(encmeth,CardNo,"C");
    if (RegNo=="") return;
    obj=document.getElementById(RegNoElement);
    if (obj)
    {
        obj.value=RegNo;
        eval(AppFunction);
    }
}
///����?������
///ʱ��?2009-02-19
///����˵��?/��ʼ��������ť?���������Ϊ^DHCPESetting("DHCPE","CardRelate")=yes?��ť��ʾΪno������

function initialReadCardButton()
{ 
    CardTypeListInit();
    //��ǩCardRelate�ﱣ����^DHCPESetting("DHCPE","CardRelate")��ֵ
    var obj=document.getElementById("CardRelate");
    var isReadCard="No"
    if (obj) isReadCard=obj.value;
    //alert(isReadCard);
    if(isReadCard!="Yes"){
        //���ؿ��������
        displsyElementById("CardNo");
        //���ؿ��ű���
        displsyElementById("cCardNo");
        //���ض�����ť
        displsyElementById("BReadCard");
        //���ؿ��������
        
        var obj=document.getElementById("CardTypeDefine");
        if(obj){
        obj.style.display="none";
        }
        //displsyElementById("CardTypeDefine");
        //���ؿ��ű���
        displsyElementById("cCardTypeDefine");
        return false;
    }
    
    
}
/*
 function initialReadCardButton()
{


//��ǩCardRelate�ﱣ����^DHCPESetting("DHCPE","CardRelate")��ֵ
var obj=document.getElementById("CardRelate");
var isReadCard="No"
if (obj) isReadCard=obj.value;
if(isReadCard!="Yes"){
//���ؿ��������
displsyElementById("CardNo");
//���ؿ��ű���
displsyElementById("cCardNo");
//���ض�����ť
displsyElementById("BReadCard");
//���ؿ��������
displsyElementById("CardTypeDefine");
//���ؿ��ű���
displsyElementById("cCardTypeDefine");
return false;
}else{
CardTypeListInit();
}


}
*/
///����?������
///ʱ��?2009-02-19
///����˵��?��id���ر�ǩ/Ԫ��
function displsyElementById(id){
    var obj=document.getElementById(id);
    if(obj){
        obj.style.display="none";
    }
}
function RegNoMask(RegNo)
{
    if (RegNo=="") return RegNo;
    var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
    return RegNo;
}
function CardNoMask(CardNo)
{
    var Length=12;
    var ZeroStr='0000000000000000000'.substr(1,Length);
    CardNo=ZeroStr.substr(1,Length-CardNo.length)+CardNo;
    return CardNo;
}



/////////////////////Add

var m_CCMRowID="";
var m_SelectCardTypeRowID="";

function ReadCardType(){
    DHCWebD_ClearAllListA("CardTypeDefine");
    var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
    if (encmeth!=""){
        var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
    }
}
function GetCardTypeRowId(){
    var CardTypeRowId="";
    //var CardTypeValue=DHCC_GetElementData("CardType");
    var CardTypeValue=combo_CardType.getSelectedValue();
    
    if (CardTypeValue!=""){
        var CardTypeArr=CardTypeValue.split("^")
        CardTypeRowId=CardTypeArr[0];
    }
    return CardTypeRowId;
}

function GetCardEqRowId(){
    var CardEqRowId="";
    //var CardTypeValue=DHCC_GetElementData("CardType");
    var CardTypeValue=combo_CardType.getSelectedValue();
    
    if (CardTypeValue!=""){
        var CardTypeArr=CardTypeValue.split("^")
        CardEqRowId=CardTypeArr[14];
    }
    return CardEqRowId;
}


function GetCardNoLength(){
    var CardNoLength="";
    //var CardTypeValue=DHCC_GetElementData("CardType");
    var CardTypeValue=combo_CardType.getSelectedValue();

    if (CardTypeValue!=""){
        var CardTypeArr=CardTypeValue.split("^");
        CardNoLength=CardTypeArr[17];
    }
    return CardNoLength;
}

function FormatCardNo(){
    var CardNo=DHCC_GetElementData("CardNo");
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

function combo_CardTypeKeydownHandler(){
    //var myoptval=combo_CardType.getActualValue();
    var myoptval=combo_CardType.getSelectedValue();
    var myary=myoptval.split("^");
    var myCardTypeDR=myary[0];
    m_SelectCardTypeRowID=myCardTypeDR
    if (myCardTypeDR=="")   {   return; }
    m_CCMRowID=myary[14];
    ///Read Card Mode
    if (myary[16]=="Handle"){
        var myobj=document.getElementById("CardNo");
        if (myobj){myobj.readOnly = false;}
        //DHCWeb_DisBtnA("BReadCard");
        
    }   else{
        //m_CCMRowID=GetCardEqRowId();
        
        var myobj=document.getElementById("CardNo");
        //if (myobj){myobj.readOnly = true;}
        var obj=document.getElementById("BReadCard");
        if (obj){
            obj.disabled=false;
            obj.onclick=ReadCard_Click;
        }
    }
    
    //Set Focus
    if (myary[16]=="Handle"){
        //DHCWeb_setfocus("CardNo");
    }else{
        //DHCWeb_setfocus("CardNo");
        //DHCWeb_setfocus("BReadCard");
    }
    if (combo_CardType) websys_nexttab(combo_CardType.tabIndex);
}

function CardTypeListInit()
{
    var obj=document.getElementById('CardTypeDefine'); 
    if (obj) {
              ReadCardType();  
              obj.setAttribute("isDefualt","true");
              combo_CardType=dhtmlXComboFromSelect("CardTypeDefine");
              }
    
    if (combo_CardType) {
        combo_CardType.enableFilteringMode(true);
        combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
    } 
    combo_CardTypeKeydownHandler(); 
}
function UploadFile(regno)
{
    var st
    try{
        st = new ActiveXObject("ADODB.Stream");
        st.Type = 1;
        st.Open(); 
        st.LoadFromFile("D:\\DHCPE\\"+regno+".bmp");
        var db = st.Read()
        st.write(db);
        st.saveToFile(photoPath+regno+'.bmp',2);
        st.close()
    }
    catch(e){
        alert(e.message)
        return false;
    }
    
}

document.write("<OBJECT ID='PEPhoto' CLASSID='CLSID:6939ADA2-0045-453B-946F-44F0D6424D8A' CODEBASE='../addins/client/PEPhoto.CAB#version=2,0,0,58'></OBJECT>");
//var PEPhoto= new ActiveXObject("PhotoProject.Photo");
var PhotoFtpInfo=tkMakeServerCall("web.DHCPE.DHCPECommon","GetPhotoFTP");
//alert(PhotoFtpInfo)

function PEShowPicByPatientID(PAPMINo,PicElementName)
{   
    var BaseInfo=tkMakeServerCall("web.DHCPE.PreIBIUpdate","GetPhoto",PAPMINo,"PAPMIID");
    
    if (BaseInfo!=""){
        
        document.getElementById("imgPic").innerHTML='<img SRC=data:image/png;base64,'+BaseInfo+' BORDER="0" width=120 height=140>'
        
    }else{
    var picType=".jpg"
    if (PhotoFtpInfo=="") return false;
    var FTPArr=PhotoFtpInfo.split("^");
    var FTPSrc="ftp://"+FTPArr[1]+":"+FTPArr[2]+"@"+FTPArr[0]+":"+FTPArr[3]+"/"+FTPArr[4]+"/"
    var NoExistSrc=FTPSrc+"NoExist.jpg"
    var src=FTPSrc+PAPMINo+picType;
    
    //document.getElementById("imgPic").innerHTML='<img SRC='+src+' BORDER="0" width=120 height=140>'
    PEShowPicBySrc(src,PicElementName);
    }
}


function PEShowPicByPatientIDForDoc(PAPMINo,PicElementName)
{   
    var BaseInfo=tkMakeServerCall("web.DHCPE.PreIBIUpdate","GetPhoto",PAPMINo,"PAPMIID");
    //alert("BaseInfo="+BaseInfo)
    if (BaseInfo!=""){
        
        document.getElementById("sex").innerHTML='<img SRC=data:image/png;base64,'+BaseInfo+' BORDER="0" width=50 height=46>'
        
    }else{
    var picType=".jpg"
    if (PhotoFtpInfo=="") return false;
    var FTPArr=PhotoFtpInfo.split("^");
    var FTPSrc="ftp://"+FTPArr[1]+":"+FTPArr[2]+"@"+FTPArr[0]+":"+FTPArr[3]+"/"+FTPArr[4]+"/"
    var NoExistSrc=FTPSrc+"NoExist.jpg"
    var src=FTPSrc+PAPMINo+picType
    //alert(src)
    ShowPicBySrcForDoc(src,NoExistSrc,PicElementName);
    }
}
function ShowPicBySrcForDoc(src,NoExistSrc,PicElementName)
{   
    
    var src="../images/uiimages/patdefault.png"; // //û�б�����Ƭʱ��ʾ��ͼƬ
    document.getElementById("sex").innerHTML='<img SRC='+src+' BORDER="0" width=50 height=46 onerror=this.src="'+NoExistSrc+'">'
    //<img src="../images/uiimages/patdefault.png" border="0" width=20 height=20>
  
}

//����ͼƬ·������ʾͼƬ��ťID
function PEShowPicBySrc(src,PicElementName)
{
    var NoExistSrc="../images/uiimages/patdefault.png";
   
    var obj=document.getElementById(PicElementName);
    
    if (obj) obj.innerHTML='<img SRC='+src+' BORDER="0" width=120 height=120 onerror=this.src="'+NoExistSrc+'">'
}

/*
//����ͼƬ·������ʾͼƬ��ťID
function PEShowPicBySrc(src,NoExistSrc,PicElementName)
{   
    
    //var NoExistSrc="ftp://root:root@192.168.100.51:21/picture/blank.jpg"; // //û�б�����Ƭʱ��ʾ��ͼƬ
    document.getElementById(PicElementName).innerHTML='<img SRC='+src+' BORDER="0" width=120 height=140 onerror=this.src="'+NoExistSrc+'">'

  
}
*/

/*
//�ж��ļ��Ƿ����
function PicFileIsExist(filespec) 
{ 
      var   fso,   s   =   filespec; 
      fso   =   new   ActiveXObject( "Scripting.FileSystemObject"); 
      if   (fso.FileExists(filespec)) 
           return true;
      else   
           return false; 
}
document.write("<OBJECT ID='Photo' CLASSID='CLSID:3B5FF267-69BD-41DB-BA9E-6F6F94551840' CODEBASE='../addins/client/Photo.CAB#version=2,1,0,1'></OBJECT>");
//document.write("<OBJECT ID='Photo' CLASSID='CLSID:9FB3C86F-D98D-4848-BD55-223BE1323A0D' CODEBASE='../addins/client/Photo.CAB#version=2,0,0,7'></OBJECT>");
//ת������Base64�Ĵ�ΪͼƬ

function ChangeStrToPhoto(PAPMIDR)
{
    try{
        //var Photo= new ActiveXObject("PhotoProject.Photo");
        var FileName="c:\\"+PAPMIDR+".bmp"
        Photo.FileName=FileName; //����ͼƬ�����ư�����׺
        Photo.PatientID=PAPMIDR //PA_PatMas���ID
        //Photo.DBConnectString="CN_IPTCP:10.160.16.90[1972]:DHC-APP" //���ݿ������
        //Photo.FTPString="10.160.16.112^anonymous^^21" //FTP������
        Photo.DBConnectString="CN_IPTCP:10.160.16.31[1972]:DHC-APP" //���ݿ������
        Photo.FTPString="10.72.16.158^administrator^123456^21" //FTP������
        Photo.ChangePicture()
        if (PicFileIsExist(FileName)){
            Photo.AppName="picture/" //ftpĿ¼
            Photo.DBFlag="1"  //�Ƿ񱣴浽���ݿ�  0  1
            Photo.FTPFlag="1" //�Ƿ��ϴ���ftp������  0  1 
            Photo.SaveFile() //�����Ѿ�����ͼƬ���浽���ݿ�ͬʱ�ϴ�FTP�ı�־��Ч
        }
    }catch(e){}
}
*/
function GetComputeInfo(InfoType)
{
    var Info="";
    if (InfoType=="IP")
    {
        //var oSetting = new ActiveXObject( "rcbdyctl.Setting" ); 
        //Info = oSetting.GetIPAddress; 
        Info = tkMakeServerCall("ext.util.String","ClientIP");
    }else{
        //var WshNetwork = new ActiveXObject("WScript.Network"); 
        /*ComputerName=WshNetwork.ComputerName+"/"+WshNetwork.UserName; */
        //Info=WshNetwork.ComputerName;
        Info = tkMakeServerCall("web.DHCPE.HISUICommon","GetClientName");
    }
    return Info;
}
function PrintBChaoReport(PAADM,OEID)
{
    var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
    var Templatefilepath=prnpath+"DHCPEBChaoResultNew.xlsx";
    var obj;
    var iOEOriId="";
    var PrintFlag=1;
    var Infos=tkMakeServerCall("web.DHCPE.CardMonthReport","GetBchaoInfo",PAADM,OEID);
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Templatefilepath);
    xlsheet = xlBook.WorkSheets("Sheet1");
    
    var HosName=""
    var HosName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
    xlsheet.cells(4,3).Value=HosName;

    var Info=Infos.split("&&");
    var Name="",Sex="",Age="",Tel="",GName="",PAPMINo=""
    var BaseInfo=Info[0].split("^");
    PAPMINo=BaseInfo[0];
    Name=BaseInfo[1];       
    Sex=BaseInfo[3];
    Age=BaseInfo[2];
    Tel=BaseInfo[4];
    GName=BaseInfo[5];
    var MedicalNo=BaseInfo[6];
    var DepDesc=BaseInfo[7];
    var CurrDate=BaseInfo[8];
    var DocName=BaseInfo[9];
    var ReportDate=BaseInfo[10];
    var HPNo=BaseInfo[11];
    var OEORItemStatDR=BaseInfo[12];
    var OSTATDesc=BaseInfo[14];
    if(OEORItemStatDR=="4"){
        alert("��ҽ����ֹͣ");
        return false;
    }
    if(OSTATDesc=="1"){
        alert("��ҽ����л�����");
        return false;
    }


    xlsheet.cells(12,2).Value=Name;
    xlsheet.cells(12,8).Value=Age;
    xlsheet.cells(12,6).Value=Sex;
    xlsheet.cells(13,8).Value=PAPMINo;
    xlsheet.cells(13,2).Value=DepDesc;
    xlsheet.cells(14,8).Value=HPNo;
    //xlsheet.cells(50,9).Value=CurrDate;
    xlsheet.cells(45,1).Value=ReportDate;
    xlsheet.cells(45,9).Value=DocName;
    xlsheet.cells(14,2).Value=BaseInfo[13];
    ///�����ǽ����Ϣ
    var ResultInfo=Info[1].split("%");
    var k=ResultInfo.length;
    for (var i=0;i<k;i++)
    {
        var OneData=ResultInfo[i];
        var ResultArr=OneData.split("^");
        //xlsheet.cells(14,2).Value=ResultArr[0];
        xlsheet.cells(17+i*6,1).Value=ResultArr[1];
    }
    
    xlsheet.printout;
    xlBook.Close (savechanges=false);
    xlApp.Quit();
}
//�ж��ļ��Ƿ����
function PicFileIsExist(filespec) 
{ 

     if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
      var   fso,   s   =   filespec; 
      fso   =   new   ActiveXObject( "Scripting.FileSystemObject"); 
      if(fso.FileExists(filespec)){
        return true;}
      else{
        return false;}   
     }
     else
     {
        return  PicFileIsExistNew(filespec) 
         }
}
function PicFileIsExistNew(filespec) 
{
    //alert(filespec+"filespec")
    filespec=filespec.replace(/\\/g,"\\\\")
    //alert(filespec+"filespec")
    var Str = "(function test(x){"+
    "var   fso,   s   =   '"+filespec+"';"+
    "fso   =   new   ActiveXObject( 'Scripting.FileSystemObject');"+
    "if(fso.FileExists('"+filespec+"')){"+
    "return true;}"+
    "else{"+
    "return false;}"+
    "}());";
     CmdShell.notReturn = 0;
    // alert(Str+"Str")
     var rtn = CmdShell.EvalJs(Str);
    
     return rtn.rtn;
    
    }
function TestNNN()
{
    var   fso,   s   =   'D:\dongmai\1.jpg';
    fso   =   new   ActiveXObject( 'Scripting.FileSystemObject');
    if(fso.FileExists('D:\dongmai\1.jpg')){return true;}
    else{return false;}
    
    
    }
//��������
function  IsPostalcode(elem){
    
if (elem=="") return true;
 var pattern=/[0-9]\d{5}(?!\d)/;
 if(pattern.test(elem)){
  return true;
 }else{
   $.messager.alert("��ʾ","���������ʽ����ȷ","info");
  return false;
 }
}


//�������� 
function  IsEMail(elem){
if (elem=="") return true;
 var pattern=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
 if(pattern.test(elem)){
  return true;
 }else{
     $.messager.alert("��ʾ","���������ʽ����ȷ","info");
  return false;
 }
}


//�绰����(�ƶ��������绰)
function  IsTel(elem){
if (elem=="") return true;
 var pattern=/^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/;
 if(pattern.test(elem)){
  return true;
 }else{
      $.messager.alert("��ʾ","�绰�����ʽ����ȷ","info");
  return false;
 }
}


