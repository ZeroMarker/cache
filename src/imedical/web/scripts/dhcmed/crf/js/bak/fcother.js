



function ShowCalc(){
var s1="";

try{
s1=event.srcElement.value;
}catch(e){};
var sRet = window.showModalDialog(fcpubdata.path + "/" + fcpubdata.root + "/common/caculator.htm", s1, "status:no;scroll:no;dialogHeight:310px;dialogWidth:300px;center:yes ;");
try{
event.srcElement.value=sRet;
}catch(e){}
}


function SendEmail(to,title,body,sip,sfrom,susername,spassword,copyto,sData,sFileName,sBcc) {










if(isSpace(sip)){ sip="smtp.sina.com.cn";}
if(isSpace(sfrom)){ sfrom="82645151@sina.com";}
if(isSpace(susername)) {susername="82645151" ;}
if(isSpace(spassword)) {spassword="8264";}
title=escape(title);
body=escape(body);
sData=escape(sData);
sFileName=escape(sFileName);
var sXml="<no>"+to+"</no>"+"<no>"+title+"</no>"+"<no>"+body+"</no>"
+"<no>"+sip+"</no>"+"<no>"+sfrom+"</no>"+"<no>"+susername+"</no>"+"<no>"+spassword+"</no>"
+"<no>"+copyto+"</no>"+"<no>"+sData+"</no>"+"<no>"+sFileName+"</no>"+"<no>"+sBcc+"</no>";
var retX=new Eapi.RunAjax().sendHttp(location.protocol+"//"+location.host+ fcpubdata.servletPath + "/WebBill"+fcpubdata.dotnetVersion+"?autosendmail",sXml);
return retX;
}

function zl_select(sXml) {
var retX=new Eapi.RunAjax().sendHttp(location.protocol+"//"+location.host+ fcpubdata.servletPath + "/WebBill"+fcpubdata.dotnetVersion+"?zl_select",sXml);
return retX;
}


function SelectZl(fabh,likevalue,ogrid){
if(fabh.indexOf("<") < 0){
fabh="zl_select_"+fabh ;
}
if(typeof likevalue == "undefined") likevalue="";
return zlSelect(fabh,likevalue,1,"",ogrid);
}

function SelectZlSql(sql,sMultiSel,sHideField,sLikeValue,oGrid) {
if(typeof sMultiSel == "undefined") sMultiSel="否";
if(typeof sHideField == "undefined") sHideField="";
if(typeof sLikeValue == "undefined") sLikeValue="";
var s="<root><dialog_cap></dialog_cap><dialog_hei>400</dialog_hei><dialog_wid>400</dialog_wid><displyflds></displyflds>"
+"<filterflds></filterflds><hzcode></hzcode><multisel>"+sMultiSel+"</multisel><editflds></editflds><undispflds>"+sHideField+"</undispflds>"
+"<sql>"+sql+"</sql></root>";
return zlSelect(s,sLikeValue,1,"",oGrid);
}

function zlSelect(zlfabs,zlfield,ipos,zlPara,ogrid){

var sRet,sXml,ooField,j;
new Eapi.Str().showWait('正在装入....');
if(zlfabs.substring(0,10)=="zl_select_"){
if(typeof zlPara == "undefined") zlPara="";
sXml="<no>"+zlfabs+"</no>"+"<no>"+new Eapi.Str().trim(zlfield)+"</no>"+"<no>"+zlPara+"</no>";
sRet=zl_select(sXml);
if(sRet=="<root></root>") return;
}else{
sRet=zlfabs ;
}
var oXml=new ActiveXObject("Microsoft.XMLDOM");
oXml.async=false;
oXml.loadXML (sRet);
var screenHeight=parseInt(oXml.documentElement.childNodes(1).text);
var screenWidth=parseInt(oXml.documentElement.childNodes(2).text);
if(isSpace(screenHeight) || isNaN(screenHeight)){
screenHeight=600;
}
if(isSpace(screenWidth) || isNaN(screenWidth)){
screenWidth=500;
}
var iLeft=(screen.availWidth-screenWidth)/2;
var iTop=(screen.availHeight-screenHeight)/2   ;
var dialogStyle="dialogHeight:314px;dialogWidth:480px;status:no;scroll:no";
var arr=new Array();
arr[0]=window;
arr[1]=oXml.documentElement.childNodes(9).text;
arr[1]=RepOpenSql(arr[1],zlfield);
arr[2]=ogrid;
arr[3]=oXml.documentElement.childNodes(8).text;
arr[4]=oXml.documentElement.childNodes(6).text;
if(IsSpace(arr[4])) arr[4]="否";
arr[5]=getuser() ;
arr[6]=zlfabs;
var sPath="";
if(ipos==1 || typeof ipos =="undefined") { sPath=fcpubdata.path+"/DHCForm/common/" ;}
if(ipos==2) {sPath="DHCForm/common/";}


sXml=dataset_select(arr[1],1,2);
if(sXml == "<root>"){
CopyToPub(arr[1]);
alert("此条SQL语句执行出错! "+arr[1]);
return
}
oXml=new ActiveXObject("Microsoft.XMLDOM");
oXml.async=false;
oXml.loadXML (sXml);
if(oXml.documentElement.childNodes.length==2){
if(typeof ogrid == "undefined" ) {
var odsmain=$id(fcpubdata.dsMain);
if(odsmain != null){
ooField=oXml.documentElement.childNodes(oXml.documentElement.childNodes.length-1).childNodes(1);
for(j=0;j<ooField.childNodes.length;j++){
var tmpFieldName = ooField.childNodes(j).childNodes(0).text;
if(odsmain.isFieldName(tmpFieldName))
odsmain.Field(tmpFieldName).Value = oXml.documentElement.childNodes(0).childNodes(j).text ;
};
odsmain.fset_cont1();
}
}
if(typeof ogrid != "undefined" ) {
ogrid.hide();
var oDs=eval(ogrid.dataset);
ooField=oXml.documentElement.childNodes(oXml.documentElement.childNodes.length-1).childNodes(1);

for(j=0;j<ooField.childNodes.length;j++){
var tmpFieldName1 = ooField.childNodes(j).childNodes(0).text ;
if(oDs.isFieldName(tmpFieldName1))
oDs.Field(tmpFieldName1).Value = oXml.documentElement.childNodes(0).childNodes(j).text ;
}
oDs.bEdit = true;
oDs.Update("不检查")  ;
oDs.LineSum(ogrid,oDs.RecNo);
oDs.fset_cont1();
oDs.fset_cont();
if(ogrid.curTD.parentNode.rowIndex == ogrid.tab.rows.length-1){
ogrid.EndRowState="edit";
}
}
new Eapi.Str().showWait("end");
return;
}else if(oXml.documentElement.childNodes.length==1){
new Eapi.Str().showWait("end");
alert("没有要显示的资料数据!");
return;
}


sRet=window.showModalDialog(sPath+"selectall.htm",arr,dialogStyle);
if(typeof ogrid != "undefined"){
DsToGrid(ogrid,arr[4]);
}
new Eapi.Str().showWait("end");
return sRet;
}

function ZlSelect(zlfabs,zlfield,ipos,zlPara,ogrid){return zlSelect(zlfabs,zlfield,ipos,zlPara,ogrid);}