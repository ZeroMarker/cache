


Eapi.Grid = function(){}
Eapi.Grid.prototype =
{
crossTab : CrossTab ,
saveAsExcel : SaveAsExcel ,
gridMultiSel : GridMultiSel ,
dsToGrid : DsToGrid ,
gridMultiDel : GridMultiDel ,
getDsGrid : GetDsGrid ,
gridColNoToFieldName : GridColNoToFieldName ,
isRepeat : function (oGrid,col) {
var slen = oGrid.tab.rows.length;
for(var i=1; i<slen; i++){
var sVal=oGrid.tab.rows(i).cells(col).innerText;
var iCount=0;
for(var j=i+1;j<slen;j++){
if(sVal==oGrid.tab.rows(j).cells(col).innerText){
iCount++;
}
if(iCount>=1){
alert(oGrid.tab.rows(j).cells(col).innerText+"重复！");
return true;
}
}
}
return false;
}

}
Eapi.Grid.registerClass("Eapi.Grid");


function CrossTab(sXml){
var posStart=sXml.indexOf("<sql>");
var posEnd=sXml.indexOf("</sql>");
var sql=sXml.substring(posStart+5,posEnd);
sql = UnSqlPropTrans(sql);
sql=RepOpenSql(sql);
sXml=sXml.substring(0,posStart)+"<sql>"+sql+sXml.substr(posEnd);
return new Eapi.RunAjax().sendHttp(location.protocol+"//"+location.host+ fcpubdata.servletPath + "/WebBill"+fcpubdata.dotnetVersion+"?crosstab",sXml);

}

function bill_ongridclick(sXml){
sXml=RepStr(sXml,":::","'");
LoadMod("noempty","gridclick",sXml);
}

function bill_ongridkeydown(sXml){
sXml=RepStr(sXml,":::","'");
LoadMod("noempty","gridclick",sXml);
}

function bill_ongriddblclick(sXml){
sXml=RepStr(sXml,":::","'");
var o=event.srcElement;
var stag=o.tagName.toUpperCase();
if((stag=="INPUT" && o.id != "txtMyGrid") || stag=="DIV") return;
if(stag=="TD"){
if(o.parentNode.rowIndex<1 || o.cellIndex<1)return;
}
LoadMod("noempty","gridclick",sXml);
}


function SaveAsExcel(){
var odssub1=Getdssub1();
if(odssub1 == null){
alert("界面上没有绑定到数据集的grid控件!");
return;
}
var oSKBILLgrid1=GetDsGrid(odssub1);
if(oSKBILLgrid1 == null){
alert("界面上没有绑定到数据集的grid控件!");
return;
}
var sRet=window.showModalDialog(fcpubdata.path+"/DHCForm/common/saveasexcel.htm",s1,"status:no;dialogHeight:120px;dialogWidth:400px;dialogTop:180;dialogLeft:250px");
if(typeof sRet=="undefined") return;
var s1=sRet+".csv";
oSKBILLgrid1.SaveExcel(s1,oSKBILLgrid1.tab.outerHTML);
}

function GridMultiSel(ogrid){
var grid,dsSel;
if(typeof ogrid =="undefined"){
var odssub1=Getdssub1();
if(odssub1 == null){
alert("界面上没有绑定到数据集的grid控件!");
return;
}
var oSKBILLgrid1=GetDsGrid(odssub1);
if(oSKBILLgrid1 == null){
alert("界面上没有绑定到数据集的grid控件!");
return;
}
grid=oSKBILLgrid1;
}else {
grid = ogrid;
}
dsSel=eval("window."+grid.dataset);
var sok="url("+fcpubdata.path+"/DHCForm/images/ef_run_grid_gou.gif)";
var r=grid.curTD.parentNode.rowIndex;
if(r>0){
if(grid.tab.rows(r).cells(0).style.backgroundImage==sok){
grid.tab.rows(r).cells(0).style.backgroundImage="";
grid.tab.rows(r).cells(0).style.backgroundRepeat="no-repeat";
grid.tab.rows(r).className="";
}else{
grid.tab.rows(r).cells(0).style.backgroundImage=sok;
grid.tab.rows(r).cells(0).style.backgroundRepeat="no-repeat";
grid.tab.rows(r).className="invert";
}
}
if(dsSel.oDom.documentElement.childNodes(dsSel.RecNo).getAttribute("multisel")!="是"){
dsSel.oDom.documentElement.childNodes(dsSel.RecNo).setAttribute("multisel","是");
}else{
dsSel.oDom.documentElement.childNodes(dsSel.RecNo).setAttribute("multisel","");
}
}

function DsToGrid(ogrid,multirow){
var ds=eval(ogrid.dataset);
if( multirow == "否") {
ds.fset_cont();
ogrid.moveedit();
return	;
}
ogrid.Rows=ds.RecordCount+1;
ds.dset_cont();
ogrid.moveedit();
ds.dset_fset();
ds.ReSum("只算fset");
ds.fset_cont1();
ds.bAdd=false;
ds.bEdit=false;
ogrid.EndRowState="edit";
ogrid.SetFocus(ogrid.curTD,"程序给焦点");
ogrid.MoveDataSet();
}

function Print(ogrid) {
alert("需要安装了东华公司的webprint产品才能打印!");
}

function PrintPreview(ogrid) {
alert("需要安装了东华公司的webprint产品才能打印!");

}

function SaveUserQuery(){
var	sRet=window.showModalDialog(fcpubdata.path+"/DHCForm/common/inputmsg.htm","请输入查询名称:","status:no;dialogHeight:105px;dialogWidth:470px;dialogTop:180;dialogLeft:250px");
if(isSpace(sRet)) return;
var sFilter="";
for(var i=0;i<DsMain.FieldCount;i++){
sFilter+="DsMain.Field("+i+").Value='"+DsMain.Field(i).Value+"';";
}
var sInsert="Insert billquery (squeryname,djsn,sfilter) values ('"+sRet+"','"+fcpubdata.area.dj_sn+"','"+escape(sFilter)+"')";
var sR=fc_insert(sInsert);
if(isSpace(sR)){
alert("保存成功!");
}else{
alert(sR);
}
}

function GridMultiDel(ogrid){
var grid,dsSel;
if(typeof ogrid =="undefined"){
grid=SKBILLgrid1;
}else {
grid = ogrid;
}
dsSel=eval("window."+grid.dataset);
for (var i=dsSel.RecordCount-1;i>=0;i--){
if(dsSel.oDom.documentElement.childNodes(i).getAttribute("multisel")=="是")	{
dsSel.RecNo=i;
dsSel.Delete();
}
}
}

function GetDsGrid(ods) {
var o=window.document.all.tags("webgrid");
for(var ii=0;ii<o.length;ii++){
if (o[ii].dataset == ods.id){
return o[ii];
}
}
return null;

}

function GridColNoToFieldName(oGrid,colno) {
colno = ToInt(colno);
var dscolno = oGrid.tab.childNodes[0].childNodes[colno].dsfield ;
dscolno = ToInt(dscolno);
var oDs = $id(oGrid.dataset);
return oDs.FieldNoToName(dscolno) ;
}
