
var icon={
root	:'../../DHCForm/images/ef_tree_root.gif',
open	:'../../DHCForm/images/ef_tree_open.png',
close	:'../../DHCForm/images/ef_tree_close.png',
file	:'../../DHCForm/images/ef_tree_file.png',
Rplus	:'../../DHCForm/images/ef_tree_Rplus.gif',
Rminus	:'../../DHCForm/images/ef_tree_Rminus.gif',
join	:'../../DHCForm/images/ef_tree_T.gif',
joinbottom:'../../DHCForm/images/ef_tree_L.gif',
plus	:'../../DHCForm/images/ef_tree_Tplus.gif',
plusbottom:'../../DHCForm/images/ef_tree_Lplus.gif',
minus	:'../../DHCForm/images/ef_tree_Tminus.gif',
minusbottom:'../../DHCForm/images/ef_tree_Lminus.gif',
blank	:'../../DHCForm/images/ef_tree_blank.gif',
line	:'../../DHCForm/images/ef_tree_I.gif'
};
var Global={
id:0,
getId:function(){return this.id++;},
all:[],
selectedItem:null,
defaultText:"treeItem",
defaultAction:"javascript:void(0)",
defaultTarget:"_self",
isCheck:false
}
function preLoadImage(){
for(i in icon){
var tem=icon[i];
icon[i]=new Image()
icon[i].src=tem
}
};preLoadImage();

function treeItem(text,action,target,title,Icon,Check,code)
{
this.id=Global.getId();
this.level=0;
this.text=text?text:Global.defaultText;
this.action=action?action:Global.defaultAction;
this.target=target?target:Global.defaultTarget;
this.title=title?title:this.text;
if (typeof(Check)=="undefined")
{
Check = Global.isCheck;
}
this.Checked = Check;
this.code = code;
this.isLast=true;
this.childNodes=new Array();
this.indent=new Array();
this.parent=null;
var c =0;
this.open=parseInt(c);
this.load=false;
this.setuped=false;
this.JsItem=null;
this.container=document.createElement("div");
this.icon=Icon;
Global.all[Global.all.length]=this;
}

treeItem.prototype.toString = function()
{
var o = this;
var Global=new Object() ;
Global.selectedItem = this ;
var oItem = document.createElement("div");
oItem.id = "treeItem"+this.id;
oItem.code = this.code;
oItem.className = "treeItem";
oItem.noWrap = true;
oItem.onselectstart = function(){ return false;}
oItem.oncontextmenu = function(){ return false;}
this.JsItem = oItem;
this.drawIndents();
var iIcon = document.createElement("img");
iIcon.align = "absmiddle";
iIcon.src = this.childNodes.length>0?(this.open?(this.level>0?(this.isLast?icon.minusbottom.src:icon.minus.src):icon.Rminus.src):(this.level>0?(this.isLast?icon.plusbottom.src:icon.plus.src):icon.Rplus.src)):(this.level>0?(this.isLast?icon.joinbottom.src:icon.join.src):icon.blank.src);
iIcon.id = "treeItem-icon-handle-" + this.id;
iIcon.onclick = function(){ o.toggle();};
oItem.appendChild(iIcon);
var iIcon = document.createElement("img");
iIcon.align = "absmiddle";
iIcon.src = this.icon?this.icon:(this.childNodes.length>0?(this.open?icon.open.src:icon.close.src):icon.file.src);
iIcon.id = "treeItem-icon-folder-" + this.id;
iIcon.onclick = function(){ o.select(o);};
iIcon.ondblclick = function(){ o.toggle();};
oItem.appendChild(iIcon);
var eText = document.createElement("span");
if (o.parent!=null)
{
o.Checked = o.parent.Checked;
}
if (o.Checked)
{
var eCheck = document.createElement("Input");
eCheck.type = "checkbox";
eCheck.id = "chk" + this.id;
eCheck.onclick = function(){o.SubChecked();}
eCheck.onkeydown = function(e){ return o.KeyDown(e);}
eText.appendChild(eCheck);
}
var eA=document.createElement("a");
eA.innerHTML = this.text;
eA.target = this.target;
eA.href = this.action;
eA.onkeydown = function(e){ return o.KeyDown(e);}
if(this.action == Global.defaultAction) {
eA.onclick = function(){ return false;} ;
}else{
var stmp1 = this.action.substring(0,11).toUpperCase() ;
if(stmp1 == "JAVASCRIPT:"){
eA.href = "javascript:void(0)" ;
eA.onclick = function(){ eval(o.action.substring(11,o.action.length));} ;
}
}
eText.appendChild(eA);
eText.id = "treeItem-text-" + this.id;
eText.className = "treeItem-unselect"
eText.onclick = function(){ o.select(1);};
eText.title = this.title;
oItem.appendChild(eText);
this.container.id = "treeItem-container-"+this.id;
this.container.style.display = this.open?"":"none";
oItem.appendChild(this.container);
return oItem;
}

treeItem.prototype.root = function()
{
var p = this;
while(p.parent)
p = p.parent;
return p;
}


treeItem.prototype.SubChecked = function()
{
CheckedAll(this);
}

function CheckedAll(sid)
{
if (eval("chk"+sid.id).checked)
{
for (var i=0;i<eval(sid).childNodes.length;i++ )
{
eval("chk"+eval(sid).childNodes[i].id).checked = true;
CheckedAll(eval(sid).childNodes[i]);
}
}
else
{
for (var i=0;i<eval(sid).childNodes.length;i++ )
{
eval("chk"+eval(sid).childNodes[i].id).checked = false;
CheckedAll(eval(sid).childNodes[i]);
}
}
}

treeItem.prototype.setText = function(sText)
{

if(this.root().setuped)
{
var oItem = document.getElementById("treeItem-text-" + this.id);
oItem.childNodes[oItem.childNodes.length-1].innerHTML = sText;
}
this.text = sText;
}

treeItem.prototype.setIndent = function(l,v)
{
for(var i=0;i<this.childNodes.length;i++)
{
this.childNodes[i].indent[l] = v;
this.childNodes[i].setIndent(l,v);
}
}

treeItem.prototype.drawIndents = function()
{
var oItem = this.JsItem;
for(var i=0;i<this.indent.length;i++){
var iIcon = document.createElement("img");
iIcon.align = "absmiddle";
iIcon.id = "treeItem-icon-" + this.id + "-" + i;
iIcon.src = this.indent[i]?icon.blank.src:icon.line.src;
oItem.appendChild(iIcon);
}
}

treeItem.prototype.add = function(oItem)
{
oItem.parent=this;
this.childNodes[this.childNodes.length]=oItem;
oItem.level=this.level+1;
oItem.indent=this.indent.concat();
oItem.indent[oItem.indent.length]=this.isLast;
if(this.childNodes.length>1){
var o=this.childNodes[this.childNodes.length-2];
o.isLast=false;
o.setIndent(o.level,0);
if(this.root().setuped)o.reload(1);
}
else if(this.root().setuped)
this.reload(0);
this.container.appendChild(oItem.toString());
this.container.style.display=this.open?"":"none";
}

treeItem.prototype.insert = function(oItem,bAfter)
{
if(this.parent == null) return;
oItem.parent=this.parent;
var pos = getPos(this.parent.childNodes,this);
if(pos == -1) return;
var offset = 0;
oItem.isLast = false ;
if(bAfter) {
offset = 1 ;
if(pos == this.parent.childNodes.length -1 ){
this.parent.childNodes[pos].isLast = false;
oItem.isLast = true;
}
}
this.parent.childNodes = this.parent.childNodes.addAt(pos+offset,oItem)

oItem.level=this.level;
oItem.indent=this.indent ;
var o = document.getElementById("treeItem"+this.id);
var sPos = "beforeBegin" ;
if(bAfter) sPos = "afterEnd" ;
o.insertAdjacentElement(sPos,oItem.toString());
if(this.parent.childNodes.length>1){
var o=this.parent.childNodes[this.parent.childNodes.length-2];
o.setIndent(o.level,0);
if(this.root().setuped)o.reload(1);
}
this.parent.reload(1);
function getPos(mainArr,o) {
var l = mainArr.length;
for(var i=0;i<l;i++){
if(mainArr[i].id == o.id){
return i ;
}
}
return -1 ;
}
}

treeItem.prototype.addNodes = function(oItem)
{
var tmp = new treeItem(oItem.text,oItem.action,oItem.target,oItem.title,oItem.icon,oItem.Checked,oItem.code);
this.add(tmp);
if (oItem.childNodes.length>0)
{
addSubNodes(tmp,oItem);
}
}

function addSubNodes(obj,oparent)
{
for(i=0;i<oparent.childNodes.length;i++)
{
var SubNode = new treeItem(oparent.childNodes[i].text,oparent.childNodes[i].action,oparent.childNodes[i].target,oparent.childNodes[i].title,oparent.childNodes[i].icon,oparent.childNodes[i].Checked,oparent.childNodes[i].code);
obj.add(SubNode);
if (oparent.childNodes[i].childNodes.length>0)
{
addSubNodes(SubNode,oparent.childNodes[i]);
}
}
}


treeItem.prototype.FindNode = function(oItem,searchObj,searchText)
{
if (oItem[searchObj] ==searchText)
{
oItem.select(this);
expandOneNode(this);
}
else
{
FindSubNodes(oItem,searchObj,searchText);
}
}
function FindSubNodes(obj,searchObj,searchText)
{
for (var i=0;i<obj.childNodes.length;i++)
{
if (obj.childNodes[i][searchObj] == searchText)
{
obj.childNodes[i].select(this);
expandOneNode(obj);
break;
}
else
{
FindSubNodes(obj.childNodes[i],searchObj,searchText);
}
}
}

function expandOneNode(obj) {
var oRoot = obj.root();
while(oRoot != obj) {
obj.expand();
obj = obj.parent;
}
oRoot.expand();
}

treeItem.cloneNode = function(obj)
{
var newObj = new Object;

if (obj.constructor.toString().indexOf("function Array(") == 1) {
newObj = obj.constructor();
}

if (obj.constructor.toString().indexOf("function Function(") == 1) {
newObj = obj;
}
else for (var n in obj) {
var node = obj[n];
if (typeof node == 'object'){
newObj[n] = treeItem.cloneNode(node);
}
else {
newObj[n] = node;
}
}

return newObj;
}

treeItem.prototype.loadChildren = function()
{
}

treeItem.prototype.remove = function()
{
var tmp = this.getPreviousSibling();
this.removeChildren();
var p = this.parent;
if(!p){ return };
if(p.childNodes.length>0){
var o = p.childNodes[p.childNodes.length-1];
o.isLast = true;
o.setIndent(o.level,1);
if(o.root().setuped)o.reload(1);
}
else
p.reload();
}

treeItem.prototype.removeChildren = function ()
{
if(this == Global.selectedItem){ Global.selectedItem = null;}
for(var i=this.childNodes.length-1;i>=0;i--)
this.childNodes[i].removeChildren();
var o = this;
var p = this.parent;
if (p) { p.childNodes = p.childNodes._remove(o);}
Global.all[this.id] = null
var oItem = document.getElementById("treeItem"+this.id);
if (oItem) { oItem.parentNode.removeChild(oItem); }
}

treeItem.prototype.reload = function(flag)
{
if (flag){
for(var j=0;j<this.childNodes.length;j++){ this.childNodes[j].reload(1);}
for(var i=0;i<this.indent.length;i++)
document.getElementById("treeItem-icon-" +this.id+ "-"+i).src = this.indent[i]?icon.blank.src:icon.line.src;
}
document.getElementById("treeItem-icon-handle-" +this.id).src = this.childNodes.length>0?(this.open?(this.level>0?(this.isLast?icon.minusbottom.src:icon.minus.src):icon.Rminus.src):(this.level>0?(this.isLast?icon.plusbottom.src:icon.plus.src):icon.Rplus.src)):(this.level>0?(this.isLast?icon.joinbottom.src:icon.join.src):icon.blank.src);
if (!this.icon)
document.getElementById("treeItem-icon-folder-"+this.id).src = this.childNodes.length>0?(this.open?icon.open.src:icon.close.src):icon.file.src;
}

treeItem.prototype.toggle = function()
{
if(this.childNodes.length>0){
if(this.open)
this.collapse();
else
this.expand();
}
}

treeItem.prototype.expand = function()
{
this.open=1;
if(!this.load){
this.load=true;
this.loadChildren();
this.reload(1);
}
else
this.reload(0);
this.container.style.display = "";
}

treeItem.prototype.collapse = function()
{
this.open=0;
this.container.style.display = "none";
this.reload(0);
this.select(1);
}


treeItem.prototype.expandAll = function()
{
if(this.childNodes.length>0 && !this.open)this.expand();
this.expandChildren();
}


treeItem.prototype.collapseAll = function()
{
this.collapseChildren();
if(this.childNodes.length>0 && this.open)this.collapse();
}


treeItem.prototype.expandChildren = function()
{
for(var i=0;i<this.childNodes.length;i++)
this.childNodes[i].expandAll();
}

treeItem.prototype.collapseChildren = function()
{
for(var i=0;i<this.childNodes.length;i++)
this.childNodes[i].collapseAll()
}

treeItem.prototype.openURL=function()
{
if(this.action!=Global.defaultAction){
window.open(this.action,this.target);
}
}

treeItem.prototype.select=function(o)
{
if (Global.selectedItem) Global.selectedItem.unselect();
var oItem = document.getElementById("treeItem-text-" + this.id);
oItem.className = "treeItem-selected";
try{
oItem.firstChild.focus();
}
catch(e){}
Global.selectedItem = this;
if(!o) this.openURL();
}

treeItem.prototype.unselect=function()
{
var oItem = document.getElementById("treeItem-text-" + this.id);
if(oItem != null){
oItem.className = "treeItem-unselect";
try{
oItem.firstChild.blur();
}
catch(e){}
}
Global.selectedItem = null;
}

treeItem.prototype.setup = function(oTaget)
{
oTaget.appendChild(this.toString());
this.setuped = true;
if(this.childNodes.length>0 || this.open) this.expand();
}


treeItem.prototype.getFirstChild = function()
{
if(this.childNodes.length>0 && this.open)
return this.childNodes[0];
return this;
}


treeItem.prototype.getLastChild = function()
{
if(this.childNodes.length>0 && this.open)
return this.childNodes[this.childNodes.length-1].getLastChild();
return this;
}


treeItem.prototype.getPreviousSibling = function()
{
if(!this.parent) return null;
for(var i=0;i<this.parent.childNodes.length;i++)
if(this.parent.childNodes[i] == this)break;
if(i == 0)
return this.parent;
else
return this.parent.childNodes[i-1].getLastChild();
}


treeItem.prototype.getNextSibling = function()
{
if(!this.parent) return null;
for(var i=0;i<this.parent.childNodes.length;i++)
if(this.parent.childNodes[i] == this)break;
if(i == this.parent.childNodes.length-1)
return this.parent.getNextSibling();
else
return this.parent.childNodes[i+1];
}

treeItem.prototype.KeyDown=function(e){
var code,o;
if(!e) e = window.event;
code = e.which ? e.which : e.keyCode;
o = this;
if(code == 37)
{
if(o.open) o.collapse();
else
{
if(o.parent) o.parent.select();
}
return false;
}
else if(code == 38)
{
var tmp = o.getPreviousSibling();
if(tmp) tmp.select();
return false;
}
else if(code == 39)
{
if(o.childNodes.length>0)
{
if(!o.open) o.expand();
else
{
var tmp = o.getFirstChild();
if(tmp) tmp.select();
}
}
return false;
}
else if(code == 40)
{
if(o.open&&o.childNodes.length>0)o.getFirstChild().select();
else
{
var tmp = o.getNextSibling();
if(tmp) tmp.select();
}
return false;
}
else if(code == 13)
{
o.toggle();
o.openURL();
return false;
}
return true;
}


treeItem.prototype.getNodeXml = function (m_target,m_action) {
var oNode = this;
var l = oNode.childNodes.length ;
var sXml = '<TreeNode id="'+oNode.id+'" text="'+oNode.text+'" ';
if(typeof m_target != "undefined") sXml += 'roottarget="'+m_target+'" ';
if(typeof m_action != "undefined") sXml += 'rootaction="'+m_action+'" ';
if(typeof oNode.href != "undefined"){
sXml += 'href="'+oNode.href+'" ';
}
if(typeof oNode.target != "undefined") {
sXml += ' target="'+oNode.target+'" ';
}
if(typeof oNode.title != "undefined") {
sXml += 'title="'+oNode.title+'" ';
}
if(typeof oNode.icon != "undefined") {
sXml += ' icon="'+oNode.icon+'" ';
}
sXml += ' check="'+oNode.check+'" ';
if(typeof oNode.code != "undefined") {
sXml += 'code="'+oNode.code+'"' ;
}
if(l == 0){
sXml += '/>' ;
}else{
sXml += '>';
for(var i=0;i<l;i++){
sXml += oNode.childNodes[i].getNodeXml() ;
}
sXml += '</TreeNode>' ;
}
return sXml ;
}

Array.prototype.indexOf=function(o){
for(var i=0;i<this.length;i++)
if(this[i]==o)return i;
return -1;
}

Array.prototype.removeAt=function(i){
return this.slice(0,i).concat(this.slice(i+1));
}
Array.prototype.addAt=function(i,o){
var arr = new Array(1);
arr[0] = o ;
var oRet = null ;
if(i == this.length) {
oRet = this.slice(0).concat(arr) ;
}else{
oRet = this.slice(0,i).concat(arr,this.slice(i)) ;
}
return oRet ;
}

Array.prototype._remove=function(o){
var i=this.indexOf(o);
if(i!= -1) return this.removeAt(i)
return this
}






function xtreeItem(uid,text,action,target,title,Icon,Check,code,xml){
this.uid=uid;
this.base=treeItem;
this.base(text,action,target,title,Icon,Check,code);
this.Xml=xml;

}
xtreeItem.prototype=new treeItem;

xtreeItem.prototype.parseElement=function(dom){
if(IsSpace(dom) == false){
return dom.selectSingleNode("/TreeNode");
}
}

xtreeItem.prototype.addNodesLoop = function(oItem,m_target,m_action)
{
for(var i=0;i<oItem.childNodes.length;i++)
{
var o = oItem.childNodes[i];
var m_target1 = m_target;
var m_action1 = m_action;
if(typeof m_target == "undefined") m_target1 = o.getAttribute("target") ;
if(typeof m_action == "undefined") m_action1 = o.getAttribute("href") ;
var tmp = new xtreeItem(o.getAttribute("id"),o.getAttribute("text"),m_action1,m_target1,o.getAttribute("title"),o.getAttribute("icon"),o.getAttribute("check"),o.getAttribute("code"),o.getAttribute('xml'));
this.add(tmp);
if(o.getAttribute("xml") ) {
tmp.add(new treeItem("Loading..."));
}
else
{
tmp.load=true;
tmp.addNodesLoop(o,m_target,m_action);
}
}
}

xtreeItem.prototype.loadXmlFile = function(xmlfile)
{
if(this.childNodes.length == 0){
this.add(new treeItem("Loading..."));
}else{
this.childNodes[0].insert(new treeItem("Loading..."));
}
this.loadChildren(xmlfile);
}


xtreeItem.prototype.loadXmlStr = function(sXml)
{
var oXml=new ActiveXObject("Microsoft.XMLDOM");
oXml.async=false;
oXml.loadXML (sXml);
if(oXml.documentElement != null){
var s1=oXml.documentElement.text;
if(IsSpace(s1) == false){
alert(s1);
}else{
var XmlItem=this.parseElement(oXml.documentElement);
var m_target = oXml.documentElement.getAttribute("roottarget");
var m_action ;
var tmp = oXml.documentElement.getAttribute("rootaction") ;
if(IsSpace(tmp) == false){
m_action = "javascript:"+unescape(tmp);
}
this.addNodesLoop(XmlItem,m_target,m_action);
}
}
}
xtreeItem.prototype.loadChildren=function(xmlfile)
{
var thisXml = this.Xml ;
if (thisXml == "" || thisXml == null || typeof thisXml == "undefined") {
if(typeof xmlfile == "undefined"){
return;
}else{
thisXml = xmlfile ;
}
}
var oItem = this;
var oLoad = oItem.childNodes[0];
var XmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
XmlHttp.onreadystatechange=function(){
if(XmlHttp.readyState==4){
if(XmlHttp.status==200){
if(XmlHttp.responseXML.xml == ""){ oLoad.setText("unavaible1");return;}
var XmlItem=oItem.parseElement(XmlHttp.responseXML.documentElement);
if(XmlItem.childNodes.length == 0){ oLoad.setText("unavaible") }
else
{
oItem.addNodesLoop(XmlItem, null, oItem.action);
if(Global.selectedItem == oItem.childNodes[0])oItem.select();
try{
oLoad.remove();
}
catch(e){}
}
}
else{
oLoad.setText("unavaible");
}
XmlHttp = null;
oItem.select(1);
}
}
try{
XmlHttp.open("get",thisXml+(/\?/g.test(thisXml)?"&":"?")+"temp="+Math.random(),true);
XmlHttp.send();
}catch(e){ oLoad.setText("unavaible");}
}
xtreeItem.prototype.setup=function(oTarget){
if(this.Xml != "" && this.Xml != null && typeof this.Xml != "undefined")	this.add(new treeItem("Loading..."));
oTarget.appendChild(this.toString());
this.setuped=true;
if(this.childNodes.length>0 || this.open) this.expand();
}


xtreeItem.prototype.sqlToTreeData =function (sql,strConn)
{
var sXml="<No>"+RepXml(sql)+"</No>";
var strX=new Eapi.RunAjax().sendHttp(location.protocol+"//"+location.host + fcpubdata.servletPath + "/WebBill"+fcpubdata.dotnetVersion+"?key=sqltotreedata&connectstring="+escape(strConn),sXml);
var oXml=SetDom(strX);
if(oXml.documentElement == null ){
alert(strX);
return "";
}
var sid = "";
var NewXml = new Sys.StringBuilder() ;
var ss = oXml.selectNodes("//fathercode[. = '' || . = '0' ]");
for (var i = 0;i < ss.length;i++)
{
var oo = ss(i).parentNode.childNodes(3) ;
if(oo != null)	var sid = " code=\""+oo.text+"\" ";
var name = ss(i).parentNode.childNodes(2).text;
var code = ss(i).parentNode.childNodes(0).text;
var fathercode = ss(i).parentNode.childNodes(1).text;
NewXml.append( "<TreeNode text=\""+name+"\" "+sid+" >");
XmlTree(code,oXml);
}
return NewXml.toString();
function XmlTree(code,obj)
{
var ss = eval(obj.selectNodes("//fathercode[. = '"+code+"']"));
if (ss.length>0)
{
for (var j = 0;j<ss.length;j++)
{
var sid = "";
var oo = ss(j).parentNode.childNodes(3) ;
if(oo != null)	sid = " code=\""+oo.text+"\" ";
var name = ss(j).parentNode.childNodes(2).text;
var code = ss(j).parentNode.childNodes(0).text;
var fathercode = ss(j).parentNode.childNodes(1).text;
NewXml.append("<TreeNode text=\""+name+"\" "+sid+" >");
XmlTree(code,obj);
}
NewXml.append( "</TreeNode>");
}
else
{
NewXml.append("</TreeNode>");
}
}
}

function TreeRefresh(obj,newsql,strConn) {
if(typeof strConn == "undefined") strConn = "";
var sAttachEnd = "";
sAttachEnd += ' '+obj.id+'=new xtreeItem('
sAttachEnd += '"","'+obj.roottext+'","","'+""+'","",'
if(obj.ischecked == "是" ) {
sAttachEnd += 'icon.root.src,true'
}else{
sAttachEnd += '"",""'
}
sAttachEnd += ',"",'
sAttachEnd += '""'
sAttachEnd += '); '+obj.id+'.setup(document.getElementById("'+obj.id+'"));';
eval(sAttachEnd);
var objJs = eval(obj.id);

if(fcpubdata.area.djsn != "tree") {
var itmp = parseInt(obj.sourcetype) ;
switch(itmp){
case 0 :
var tmpxml = unescape(obj.xml);
if(IsSpace(tmpxml) == false ) {
objJs.loadXmlStr(tmpxml);
}
break ;
case 1 :
if(IsSpace( newsql) ){
var sql = UnSqlPropTrans(obj.sql) ;
}else{
var sql = newsql ;
}
if(IsSpace(sql) == false){
var s1 ="";
if(IsSpace(obj.clicknode) == false) s1 = ' roottarget="'+obj.opentb+'" rootaction="' + obj.clicknode + '"' ;
var tmp1 = new Eapi.RunAjax().sendHttp(location.protocol+"//"+location.host + fcpubdata.servletPath +"/uploaddoc"+fcpubdata.dotnetVersion+"?key=getTreeXml&sTablename="+escape(RepOpenSql(sql))+"&connectstring="+escape(strConn)) ;
objJs.loadXmlStr('<TreeNode ' + s1 + '>' + tmp1 + '</TreeNode>');
}
break ;
case 2 :
var tmpxml = unescape(obj.xmlpath);
if(IsSpace(tmpxml) == false ) {
objJs.loadXmlFile(tmpxml);
}
break ;
case 3 :
if(IsSpace( newsql) ){
var sql = UnSqlPropTrans(obj.sql2) ;
}else{
var sql = newsql ;
}
if(IsSpace(sql) == false){
var s1 ="";
if(IsSpace(obj.clicknode) == false) s1 = ' roottarget="'+obj.opentb+'" rootaction="' + obj.clicknode + '"' ;
var tmp1 = objJs.sqlToTreeData( RepOpenSql(sql),strConn) ;
objJs.loadXmlStr('<TreeNode ' + s1 + '>' + tmp1 + '</TreeNode>');
}
break ;
}
if(obj.isAll == "是"){
objJs.expandAll();
}else{
objJs.collapseAll();
}
}

}

function TreeGetMultiValue(obj){
var arr = new Array();
var j=0;
var oList = obj.all.tags("input");
for(var i=0;i<oList.length;i++){

if(oList[i].checked){
arr[j] = new Object();
var scode = oList[i].parentNode.parentNode.code;
if(scode==null)scode="";
arr[j].code = scode ;
arr[j].text = oList[i].nextSibling.innerText ;
arr[j].href = oList[i].nextSibling.href ;
arr[j].target = oList[i].nextSibling.target ;
j++;
}
}
if(j == 0) return null ;
return arr;
}

function TreeSetMultiValue(obj,svalue){
if(IsSpace(svalue)) return ;
var arrSel = svalue.split(",");
var ll = arrSel.length ;
var arr = new Array();
var j=0;
var oList = obj.all.tags("input");
for(var i=0;i<oList.length;i++){
var scode = oList[i].parentNode.parentNode.code;
for(var j=0;j<ll;j++){
if(scode == arrSel[j]){
oList[i].checked = true ;
}
}
}
}


function setCookie(name,value)
{
var Days = 7;
var exp  = new Date();
exp.setTime(exp.getTime() + Days*24*60*60*1000);
document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
}
function getCookie(name)
{
var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
if(arr != null) return unescape(arr[2]); return null;
}
function delCookie(name)
{
var exp = new Date();
exp.setTime(exp.getTime() - 1);
var cval=getCookie(name);
if(cval!=null) document.cookie= name + "="+cval+";expires="+exp.toGMTString();
}