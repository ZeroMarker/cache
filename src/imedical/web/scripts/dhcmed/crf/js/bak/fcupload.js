




function upload_addrow(tb){
var oTr=tb.insertRow(tb.rows.length-1);
oTr.style.borderBottom="1px solid";
var oTd;

oTd=oTr.insertCell();
oTd.style.width="20";
oTd.style.borderBottom="1px solid";


oTd=oTr.insertCell();
oTd.style.width="60%";
oTd.style.borderBottom="1px solid";

oTd=oTr.insertCell();
oTd.style.width="30%";
oTd.style.borderBottom="1px solid";

oTd=oTr.insertCell();
oTd.style.display="none";
oTd=oTr.insertCell();
oTd.style.display="none";

oTd=oTr.insertCell();
oTd.style.width="40";
oTd.style.borderBottom="1px solid";

oTd=oTr.insertCell();
oTd.style.display="none";
oTr.style.height=20;

return oTr;
}

function upload_onload(){
if(HaveUpload() == false ) return;

var sRet="";
try{
if(isSpace(fcpubdata.keyValue)) {return;}
}catch(E){}
var tmpdjbh=fcpubdata.keyValue;
if(IsSpace(fcpubdata.uploadForm)) fcpubdata.uploadForm = fcpubdata.area.dj_sn ;
    var retX=new Eapi.RunAjax().sendHttp(location.protocol+"//"+location.host+ fcpubdata.servletPath + "/uploaddoc"+fcpubdata.dotnetVersion+"?key=readimage&sTablename=FC_ATTACH&sImgname=attach&sKeyvalue="+tmpdjbh+"&sKeyvalue1="+fcpubdata.uploadForm+"&subPath="+escape(fcpubdata.path),"");


if(isSpace(retX)==false){
var oXml=new ActiveXObject("Microsoft.XMLDOM");
oXml.async=false;
oXml.loadXML (retX);
if(oXml.documentElement == null) return ;
var tb=upload1.children[0];
for(var i=0;i<oXml.documentElement.childNodes.length;i++){
if(isSpace(oXml.documentElement.childNodes(i).childNodes(0).text)==false){
var oTr=upload_addrow(tb);

var extName=oXml.documentElement.childNodes(i).childNodes(3).text;
var tmp_extname = extName.substring(1,extName.length) ;
if (tmp_extname != "avi" && tmp_extname != "css" && tmp_extname != "doc" && tmp_extname != "gif" && tmp_extname != "htm" && tmp_extname != "jpg" && tmp_extname != "js" && tmp_extname != "mid" && tmp_extname != "psd" && tmp_extname != "rar" && tmp_extname != "txt" && tmp_extname != "wav" && tmp_extname != "xml" && tmp_extname != "xsl" && tmp_extname != "zip" && tmp_extname != "asf" && tmp_extname != "mpeg" && tmp_extname != "mpg" && tmp_extname != "pdf" && tmp_extname != "ppt" && tmp_extname != "swf" && tmp_extname != "au" && tmp_extname != "bmp" && tmp_extname != "ini" && tmp_extname != "mdb" && tmp_extname != "midi" && tmp_extname != "mov" && tmp_extname != "mp3" && tmp_extname !="xls"){
tmp_extname = "other" ;
}
var fileName1=tmp_extname+".gif";
var gifPath=fcpubdata.path+'/DHCForm/images/filetype/';
tb.rows(i).cells(0).innerHTML="<img src='"+gifPath+fileName1+"'></img>";

tb.rows(i).cells(3).innerText = oXml.documentElement.childNodes(i).childNodes(2).text;
tb.rows(i).cells(2).innerText = oXml.documentElement.childNodes(i).childNodes(4).text;
var tmpPath = fcpubdata.path
tb.rows(i).cells(1).innerHTML = "<a target='_blank' href='"+location.protocol+"//"+location.host+tmpPath+oXml.documentElement.childNodes(i).childNodes(0).text +"'>"+sepFile(oXml.documentElement.childNodes(i).childNodes(1).text)+"</a>";
tb.rows(i).cells(5).innerHTML = "<span style='cursor:hand;color:blue;text-decoration:underline;width:70px' onclick='uploadDelFile("+i+")'  >删除</span>";
tb.rows(i).cells(6).innerText = oXml.documentElement.childNodes(i).childNodes(0).text;
}
}
}
}

function upload_save(djbh){
if(HaveUpload() == false ) return;
if(IsSpace(fcpubdata.uploadForm)) fcpubdata.uploadForm = fcpubdata.area.dj_sn ;
var sDelXml="";
var sql=new Sys.StringBuilder();
var tb=upload1.children[0];
for(var i=0;i<tb.rows.length-1;i++){
var sTag = tb.rows(i).cells(4).innerText;
if(sTag == "新增" ){
var filename = tb.rows(i).cells(1).innerText;
if(isSpace(filename)==false){
filename=new Eapi.Str().trim(filename);
var extname=filename.substring(filename.length-4,filename.length);
extname=extname.toLowerCase();
filename=tb.rows(i).cells(1).title;
var m_attachid = tb.rows(i).cells(3).innerText;
var sBz = tb.rows(i).cells(2).innerText;
var sFilepos = tb.rows(i).cells(6).innerText;
sql.append( "<no>Delete FC_ATTACH where attachid='" + m_attachid + "' and djbh='"+djbh+"' and djsn='"+fcpubdata.uploadForm+"' </no>");
sql.append( "<no>insert into FC_ATTACH (attachid,djbh,filename,extend,bz,djsn,filepos) values ('"+m_attachid+"','"+djbh+"','"+filename+"','"+extname+"','"+sBz+"','"+fcpubdata.uploadForm+ "','" + sFilepos+"') </no>");
}
}else if(sTag == "删除"){
var m_attachid = tb.rows(i).cells(3).innerText;
if(isSpace(m_attachid)==false){
sql.append("<no>delete from FC_ATTACH where attachid='"+m_attachid+"' </no>");
}
}
if(sTag == "删除" || sTag == "增加后删除"){
sDelXml += "<file>" + tb.rows(i).cells(6).innerText + "</file>";

}
}
if(sDelXml!=""){
sDelXml = "<path>"+fcpubdata.path+"</path>" + sDelXml  ;
var retX=new Eapi.RunAjax().sendHttp(location.protocol+"//"+location.host + fcpubdata.servletPath + "/WebBill"+fcpubdata.dotnetVersion+"?DelUploadFile",sDelXml);
if(IsSpace(retX) == false){
alert(retX);
}
}
if(sql.isEmpty() == false){

var sRet1=inserts(sql.toString());
if(isSpace(sRet1)==false){
alert(sRet1);
return;
}
}

}

function uploadAddFile(){
if(upload1.disabled)return;
var arrPara = new Array();


arrPara[0] = upload1.setpath ;
if(typeof upload1.setpath == "undefined") arrPara[0] ="/DHCFormExt/res/";
arrPara[1] = upload1.extfiles ;
if(typeof upload1.extfiles == "undefined") arrPara[1] = "";
var arr = window.showModalDialog(fcpubdata.path+"/DHCForm/common/uploadfilemain.htm",arrPara,"scroll:no;status:no;dialogHeight:200px;dialogWidth:350px;dialogTop:180;dialogLeft:250px") ;
fcpubdata.isEdit=true;
if(isSpace(arr)==false) {
var sRet = arr[0];
var tb=upload1.children[0];

var oTr=upload_addrow(tb);
var expName=sRet.substring(sRet.length-3,sRet.length);
var tmp_extname=expName.toLowerCase();
if (tmp_extname != "avi" && tmp_extname != "css" && tmp_extname != "doc" && tmp_extname != "gif" && tmp_extname != "htm" && tmp_extname != "jpg" && tmp_extname != "js" && tmp_extname != "mid" && tmp_extname != "psd" && tmp_extname != "rar" && tmp_extname != "txt" && tmp_extname != "wav" && tmp_extname != "xml" && tmp_extname != "xsl" && tmp_extname != "zip" && tmp_extname != "asf" && tmp_extname != "mpeg" && tmp_extname != "mpg" && tmp_extname != "pdf" && tmp_extname != "ppt" && tmp_extname != "swf" && tmp_extname != "au" && tmp_extname != "bmp" && tmp_extname != "ini" && tmp_extname != "mdb" && tmp_extname != "midi" && tmp_extname != "mov" && tmp_extname != "mp3" && tmp_extname !="xls"){
tmp_extname = "other" ;
}
var fileName1=tmp_extname+".gif";
var gifPath=fcpubdata.path+'/DHCForm/images/filetype/';
oTr.cells(0).innerHTML="<img src='"+gifPath+fileName1+"'></img>";
oTr.cells(1).innerText=sepFile(sRet);
oTr.cells(1).title=sRet;
oTr.cells(2).innerText = arr[1] ;
oTr.cells(3).innerText=getMaxNo("UPF",fcpubdata.area.mkbh);
oTr.cells(4).innerText="新增";

oTr.cells(5).innerHTML="<span style='cursor:hand;color:blue;text-decoration:underline;width:70px;' onclick='uploadDelFile("+oTr.rowIndex+")'>删除</span>";
oTr.cells(6).innerText=arr[2];
}
}

function uploadDelFile(iRow){
if(upload1.disabled)return;

var tb=upload1.children[0];
var o=tb.rows(iRow).cells(2);

var s1=o.parentNode.cells(4).innerText;
if(isSpace(s1)){
o.parentNode.cells(4).innerText="删除";
o.parentNode.cells(1).innerHTML="<font color=red>已删除</font>";
}else if(s1=="删除" || s1==="增加后删除"){
alert("此行已做删除标志!");
}else {
o.parentNode.cells(4).innerText="增加后删除";
o.parentNode.cells(1).innerHTML="<font color=red>已删除</font>";
}
fcpubdata.isEdit=true;

}

function sepFile(sPath){
if(isSpace(sPath)){ return "";}
for(var i=sPath.length;i>0;i--){
var s1=sPath.substring(i-1,i);
if ( escape(s1)=="%5C" || s1=="/" || s1==":" ) {
return sPath.substring(i,sPath.length);
}
}
}




if ( typeof window.attachEvent != "undefined" ) {
window.attachEvent( "onload", upload_onload );
}
