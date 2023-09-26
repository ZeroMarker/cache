









var btnList={
newempty: ["新建空表单", "../images/ef_design_newempty.gif", false, 'Add("newempty")'],
newdj: ["带向导新建表单", "../images/ef_design_new.gif", false, 'Add("new")'],
opendj: ["打开数据库中的表单", "../images/ef_design_open.gif", false, 'Add("opendj")'],
opendjfile: ["打开表单文件", "../images/ef_design_openfile.gif", false, 'Add("opendjfile")'],
billtype: ["表单分类维护", "../images/ef_design_billtype.gif", false, 'Add("billtype")'],
djpreview: ["表单预览", "../images/ef_design_preview.gif", false, 'Add("djpreview")'],
directrun: ["直接运行表单", "../images/ef_design_directrun.gif", false, 'Add("directrun")'],
save: ["保存表单", "../images/ef_design_save.gif", false, 'Add("save")'],
saveas: ["另存表单", "../images/ef_design_saveas.gif", false, 'Add("saveas")'],
cut: ["剪切", "../images/ef_design_cut.gif", false, 'Add("cut")'],
copy: ["复制", "../images/ef_design_copy.gif", false, 'Add("copy")'],
paste: ["粘贴", "../images/ef_design_paste.gif", false, 'Add("paste")'],
undo: ["撤消", "../images/ef_design_undo.gif", false, 'Add("undo")'],
redo: ["重做", "../images/ef_design_redo.gif", false, 'Add("redo")'],
align: ["对齐面板", "../images/ef_design_align.gif", false, 'Add("align")'],
focus: ["焦点次序", "../images/ef_design_tabbtn.gif", false, 'Add("focus")'],
front: ["前置", "../images/ef_design_qianzhi.gif", false, 'Add("front")'],
behind: ["后置", "../images/ef_design_houzhi.gif", false, 'Add("behind")'],
form: ["表单属性", "../images/ef_design_shuxing.gif", false, 'Add("form")'],
userfunction: ["自定义函数", "../images/ef_design_function.gif", false, 'Add("userfunction")'],
userfunction1: ["能变色的自定义函数", "../images/ef_design_userfunction.gif", false, 'Add("userfunction1")'],
addhtml: ["附加页面元素", "../images/ef_design_addobj.gif", false, 'Add("addhtml")'],
execute: ["立即窗口", "../images/ef_design_command.gif", false, 'RunCommand()'],
showlist: ["显示/隐藏控件列表", "../images/ef_design_left.gif", false, 'showobjlist()'],
listconfig: ["列出配置信息", "../images/ef_design_help.gif", false, 'Add("listconfig")'],
eformhelp: ["帮助", "../images/ef_design_help.gif", false,  'openHelp()'],
cbozoom: ["放缩编辑区", "", false, 'cboZoom_onchange()'],
button: ["button控件", "../images/ef_design_button.gif", false, 'Add("button")'],
label: ["label控件", "../images/ef_design_label.gif", false, 'Add("label")'],
img: ["img控件", "../images/ef_design_image.gif", false, 'Add("img")'],
div: ["div控件", "../images/ef_design_div.gif", false, 'Add("div")'],
ebshow: ["显示e表结果控件", "../images/eb_control.gif", false, 'Add("ebshow")'],
shape: ["shape控件", "../images/ef_design_shape.gif", false, 'Add("shape")'],
tab: ["tab页签控件", "../images/ef_design_pagecontrol.gif", false, 'Add("tab")'],
treeview: ["treeView控件", "../images/ef_design_tree.gif", false, 'Add("SKDBTreeView")'],
a: ["超级链接控件", "../images/ef_design_href.gif", false, 'Add("a")'],
spin: ["spin控件", "../images/ef_design_numedit.gif", false, 'Add("spin")'],
checkboxlist: ["checkboxlist控件", "../images/ef_design_divcheckbox.gif", false, 'Add("checkboxlist")'],
radiolist: ["radiolist控件", "../images/ef_design_divradio.gif", false, 'Add("radiolist")'],
dataset: ["dataset数据集控件", "../images/ef_design_dataset.gif", false, 'Add("dataset")'],
grid: ["grid表格控件", "../images/ef_design_webgrid.gif", false, 'Add("grid")'],
htmltable: ["HTML table控件", "../images/ef_design_htmltab.gif", false, 'Add("HtmlTab")'],
formattab: ["版式和表格向导", "../images/ef_design_formattab.gif", false, 'Add("formatTab")'],
text: ["text控件", "../images/ef_design_edit.gif", false, 'Add("text")'],
checkbox: ["checkbox控件", "../images/ef_design_chk.gif", false, 'Add("checkbox")'],
radio: ["radio控件", "../images/ef_design_radio.gif", false, 'Add("radio")'],
listbox: ["listbox控件", "../images/ef_design_list.gif", false, 'Add("listbox")'],
dropdownlist: ["dropdownlist控件", "../images/ef_design_fccode.gif", false, 'Add("dropdownlist")'],
combobox: ["combobox控件", "../images/ef_design_combo.gif", false, 'Add("combobox")'],
textarea: ["textarea控件", "../images/ef_design_area.gif", false, 'Add("textarea")'],
dbimg: ["dbimg控件", "../images/ef_design_dbmage.gif", false, 'Add("dbimg")'],
chart: ["chart控件", "../images/ef_design_chart.gif", false, 'Add("chart")'],
upload: ["upload多附件上传控件", "../images/ef_design_filed.gif", false, 'Add("upload")'],
excel: ["excel控件", "../images/ef_design_excel.gif", false, 'Add("excel")'],
setPosition: ["切换定位类型(static/absolute)", "../images/ef_design_position.gif", false, 'setPosition()'],
menu: ["常用工具", "../images/ef_design_designmenu.gif", false, 'Add("menu")'],
ebiaoform: ["表单属性", "../images/ef_design_shuxing.gif", false, 'Add("ebiaoform")'],
ebiaobind: ["绑定报表参数", "../images/ef_design_dataset.gif", false, 'Add("ebiaobind")'],
ebiao: ["e表控件", "../images/eb_control.gif", false, 'Add("ebiao")'],
tree: ["tree控件", "../images/ef_design_tree.gif", false, 'Add("tree")']
};



function AddToolbarButton(TbStyle, Tb) {
var sPosition = LoadPubData("eformPosition");
if(sPosition == "absolute"){
btnList['setPosition'][1]="../images/ef_design_position.gif";
pubPositionChange = "是";
}
var arr = fcpubdata.toolbar.split(",");
var str = new Sys.StringBuilder() ;
var hrefstyle = "<link rel='stylesheet' type='text/css' href='../css/skins/" ;
var docstyle = "/style/Editor.css'>";
str.append(  hrefstyle +	fcpubdata.toolbarStyle + docstyle );
str.append( "<table id='Toolbar' class='Toolbar' cellSpacing='0' cellPadding='0' border='0' style='LEFT:5px;POSITION:absolute;TOP:0px'  ondrag='tb_ondrag()'><tr>");
if(fcpubdata.toolbarStyle == "coolblue") {
str.append( "<td><img src='../images/ef_design_ToolbarLeft.gif'></td>");
}
for(var j=0; j<arr.length; j++){
var btn = btnList[arr[j]];
if(arr[j] == "|") {
str.append( "<td><img src='../images/ef_design_menuline.gif'></td>");
}else{
if(arr[j] == "br") {
str.append( "<td width='10px' height='22px'></td></tr></table><table id='Toolbar1' class='Toolbar' cellSpacing='0' cellPadding='0' border='0' style='LEFT:5px;POSITION:absolute;TOP:25px'  ondrag='tb_ondrag()'><tr>");
if(fcpubdata.toolbarStyle == "coolblue") {
str.append( "<td><img src='../images/ef_design_ToolbarLeft.gif'></td>");
}
}else{
if(arr[j] == "cbozoom"){
str.append( "<td>&nbsp;<select id='cboZoom' onchange='cboZoom_onchange()'><option selected>10%</option><option>25%</option><option>50%</option><option>75%</option><option selected>100%</option><option>150%</option><option>200%</option><option>300%</option><option>500%</option></select></td>");
}else{
str.append( "<td width='22px' height='22px' onmouseover='tbr1_onmouseover()' onmouseout='tbr1_onmouseout()' onmousedown='tbr1_onmousedown()' onmouseup='tbr1_onmouseup()'><img class='aFilter' title='"+btn[0]+"' onclick='"+btn[3]+"' src='"+btn[1]+"' width='20px' height='20px'></td>");
}
}
}
}
str.append( "<td width='10px' height='22px'></td></tr></table>"	);
document.write(str.toString());

}


function setPosition() {
if(parent.topic.fcpubdata.position == "absolute"){
parent.topic.fcpubdata.position = "static" ;
event.srcElement.src="../images/ef_design_static.gif" ;
}else{
parent.topic.fcpubdata.position = "absolute" ;
event.srcElement.src="../images/ef_design_position.gif" ;
}
SavePubData("eformPosition",parent.topic.fcpubdata.position);
}
function DjOpenHtm() {
var Htm = DjOpen('menu','','展现',"有模式窗口","直接","") ;
htmltocont(Htm);
blnChange=true ;
}

function RegButton() {
for(var i in btnListAdd){
var objid = btnListAdd[i] ;
if(typeof btnList[objid] != "undefined"){
continue;
}
btnList[i] = [objid[0], objid[1], objid[2], objid[3]] ;
}
}