


Eapi.DataSet = function(){}
Eapi.DataSet.prototype =
{
getEditedData : function(oDs){
var oList = oDs.oDom.documentElement.selectNodes("//tr[@rowstate='edit' ]")	;
if(oList == null) return;
var s =new Sys.StringBuilder() ;
for(var i=0;i<oList.length;i++){
s.append(oList.item(i).xml);
}
return s.toString();
},
actionEditedData : function(oDs,callback){
var oList = oDs.oDom.documentElement.selectNodes("//tr[@rowstate='edit' ]")	;
if(oList == null) return;
for(var i=0;i<oList.length;i++){
callback(oList.item(i));
}
},
getChangeData : function (dataset1){
var oList = dataset1.oDom.documentElement.selectNodes("//tr[@rowstate='edit' or @rowstate='add']")	;
if(oList == null) return;
var s =new Sys.StringBuilder() ;
for(var i=0;i<oList.length;i++){
s.append(oList.item(i).xml);
}
return s.toString();
},
actionChangeData : function(oDs,callback){
var oList = oDs.oDom.documentElement.selectNodes("//tr[@rowstate='edit' or @rowstate='add' ]")	;
if(oList == null) return;
for(var i=0;i<oList.length;i++){
callback(oList.item(i));
}
},
copyDataset : copydataset ,
copyDatasetSel : copydatasetsel ,
dsBeforeSave : DsBeforeSave


}
Eapi.DataSet.registerClass("Eapi.DataSet");



function dataset_select(sSql,PageNo,PageSize,sfieldset,callback,context) {
var fsql="";
if(fcpubdata.dbStruDict == "FC_FLDLIST" ){
var  tmpsql1 = "select chnname,fdsize,fddec from FC_FLDLIST where ";
if(fcpubdata.databaseTypeName == "oracle"){
tmpsql1 += "UPPER(fdname)='GET_FIELD_NAME_FLAG' " ;
}else{
tmpsql1 += "fdname='GET_FIELD_NAME_FLAG' " ;
}
fsql = tmpsql1 ;
}else if(fcpubdata.dbStruDict == "FC_DBSTRU"){
fsql = "select chnname,fdsize,fddec from FC_DBSTRU where fdname='GET_FIELD_NAME_FLAG'";
}
var sXml="<sql>"+RepXml(sSql)+"</sql>"+"<pageno>"+PageNo+"</pageno>"+"<pagesize>"+PageSize+"</pagesize>"+"<fset>"+sfieldset+"</fset>"+"<fieldsql>"+fsql+"</fieldsql>";
var retX=new Eapi.RunAjax().sendHttp(location.protocol+"//"+location.host+ fcpubdata.servletPath + "/WebBill"+fcpubdata.dotnetVersion+"?dataset_select",sXml,callback,context);
return retX;
}


function copydataset(dsSour,dsDest){
for(var i=0;i<dsSour.FieldCount;i++){
var s1=dsSour.Field(i).FieldName ;
if(s1!="djbh"){
if(dsDest.isFieldName(s1))
dsDest.Field(s1).Value=dsSour.Field(i).Value;
}
}
}

function copydatasetsel(dsSour,dsDest){
var arrSour=new Array();
var arrDest=new Array();
var k=0,i,j;
for( i=0;i<dsSour.FieldCount;i++){
for( j=0;j<dsDest.FieldCount;j++){
if(dsDest.Field(j).FieldName.toUpperCase()==dsSour.Field(i).FieldName.toUpperCase()){
arrSour[k]=i;
arrDest[k]=j;
k++;
break;
}
}
}
var tmpB=false;
if(k>0){
for( i=0;i<dsSour.RecordCount;i++){
if(dsSour.oDom.documentElement.childNodes(i).getAttribute("multisel")=="是"){
var iTmp=dsDest.RecNo;
if(tmpB){
dsDest.Append("强行加一行");
iTmp=dsDest.oDom.documentElement.childNodes.length-2;
}
for( j=0;j<k;j++){
dsDest.oDom.documentElement.childNodes(iTmp).childNodes(arrDest[j]).text=dsSour.oDom.documentElement.childNodes(i).childNodes(arrSour[j]).text;
}
tmpB=true;
dsDest.LineSum(null,iTmp);
}
}
return true;
}else {return false;}
}

function bill_dsevent(eventname,eventfunction){
LoadMod(eventfunction,"clickmenu");
}

function bill_ondatasetvalid(sXml){


var oXml=new ActiveXObject("Microsoft.XMLDOM");
oXml.async=false;
oXml.loadXML (sXml);
var iLen=oXml.documentElement.childNodes.length;
if(iLen>0){
var curFieldName=event.FieldName;
var oNode = oXml.documentElement.selectSingleNode(curFieldName) ;
if(IsSpace(oNode) == false){
var sKey=oNode.text;
sKey = "try {"+sKey+"}catch (e) {event.returnValue=e.description;}";
eval(sKey);
}
}
}

function bill_ondatasetsettext(sXml){


var oXml=new ActiveXObject("Microsoft.XMLDOM");
oXml.async=false;
oXml.loadXML (sXml);
var iLen=oXml.documentElement.childNodes.length;
if(iLen>0){
if(event.FieldName==""){
for(var i=0;i<iLen;i++){
eval(oXml.documentElement.childNodes(i).text);
}
}else{
var curFieldName=event.FieldName;
var oo = oXml.documentElement.selectSingleNode(curFieldName);
if(oo != null){
var sCommand=oo.text;
eval(sCommand);
}
}
}
}

function EditDs(dssub1,fieldname,fieldvalue){
var colno=dssub1.FieldNameToNo(fieldname);
var ii=dssub1.RecNo ;
dssub1.oDom.documentElement.childNodes(ii).childNodes(colno).text=fieldvalue ;
dssub1.oDom.documentElement.childNodes(ii).setAttribute("rowstate","edit") ;
}

function CopyFieldsToArr(oDs) {
var arr = new Array() ;
var ll = oDs.Fields.Field.length;
for(var i=0;i<ll;i++){
arr[i]=oDs.Field(i).Value ;
}
return arr ;
}

function CopyArrToFields(oDs,arr) {
var ll = oDs.Fields.Field.length;
for(var i=0;i<ll;i++){
oDs.Field(i).Value = arr[i] ;
}
}

function DsBeforeSave(oDs,oGrid1) {
var oGrid = oGrid1;
if(typeof oGrid1 == "undefined"){
oGrid = GetDsGrid(oDs);
}
if(oGrid.txt.style.display != "none" ){
oDs.cont_onDataChange();
}
if(oDs.Update()==1) return true;
return false;
}

