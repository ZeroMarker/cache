/// 名称			DHCPETree.js
/// 创建时间		2006.09.21
/// 创建人			xuwm
/// 主要功能		实现与树型结构有关得操作
/// 对应表		
/// 最后修改时间	
/// 最后修改人	
/// 完成


// 当前点击打开的节点
var CurExpand;

//当树打开显示的图片
var imageOpen="../images/websys/find.gif";
//当树点击关闭显示的图片
var image="../images/websys/edit.gif";

var xslFile="tree.xsl";

// 树型菜单
var TreeName="DivTree";



function swapClass(obj, cls) {
  	obj.className = cls
}

// 创建树型结构 
function CreateTreeFromXMLObject(obj, xmlobj) {
  //if (""!=xslobj) { load_xmln2(obj,xmlobj,xslobj); }
  //else { 
	//alert("CreateTree:"+xmlobj.innerHTML+";");
	if (""!=xmlobj.innerHTML) {
		// 此函数在DHCPECommon.xml.js
  		load_xmlnFromXMLObject(obj,xmlobj,xslFile); 
  		CurExpand=null;
	}
  	
 // }
}

// /////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////
// 树型结构操作
function expandAll(entity) {
	var oImage;
	var iLLoop=0;

	expand(entity, false);

	// expand children
	for(iLLoop=0; iLLoop < entity.childNodes.length; iLLoop++) {
		if(entity.childNodes(iLLoop).tagName == "DIV") {
			expandAll(entity.childNodes(iLLoop));
		}
	}
}

function clickOnEntity(entity) {

	if (!(entity))
	{
		window.event.cancelBubble = true;
		return;
	} 
	
	if(entity.open == "false")
	{
		expand(entity, true);
	}
	else
	{
		collapse(entity)
	}
	
	window.event.cancelBubble = true;
}

function expand(entity) {
	var oImage;
	var iLLoop=0;
	
	oImage = entity.childNodes(0).all["image"]
	if (oImage) {oImage.src = imageOpen; }

	if (CurExpand)
	{ 
		oImage=CurExpand.childNodes(0).all["image"]
		if (oImage) { oImage.src = image; }
	}
  
	CurExpand=entity;
	for(iLLoop=0; iLLoop < entity.childNodes.length; iLLoop++)
	{
		if(entity.childNodes(iLLoop).tagName == "DIV")
		{
			entity.childNodes(iLLoop).style.display = "block";
		}
	}
	
	entity.open = "true"
  
}

function collapse(entity) {
	var oImage;
	var iLLoop=0;
	//				table
	oImage = entity.childNodes(0).all["image"];
	if (oImage) { oImage.src = image; }

	// collapse and hide children
	for(iLLoop=0; iLLoop < entity.childNodes.length; iLLoop++)
	{
      if(entity.childNodes(iLLoop).tagName == "DIV")
      {
		if(entity.id != TreeName) entity.childNodes(iLLoop).style.display = "none"
		collapse(entity.childNodes(iLLoop))
      }
	}

	entity.open = "false"
}

function checkedOnEntity(entity) {
	var src=window.event.srcElement;
	var parentName=entity.id.substr(1);
	var parentTree=document.getElementById("D"+parentName);
	if (parentTree) {
		//alert("点击 checkedOnEntity:"+parentTree.id);
		SelectOnEntity(parentTree, src.checked);
		
	}
	window.event.cancelBubble = true;
}

function SelectOnEntity(entity, select) {
	//alert("选择 checkedOnEntity 节点:"+entity.id+"  "+select+" 数目:"+entity.ChildCount);
	var strName=entity.id.substr(1);
	var iLLoop=0; //如果不声明变量?Javascript就会把变量作为全局变量使用
	var obj=document.getElementById("C"+strName);
	if (obj) { obj.checked=select; }
	else { return; }
	
	if (1>entity.ChildCount) { return; }
	
	if (select) { expand(entity); }
	else { collapse(entity); }
	
	for(iLLoop=0; iLLoop<entity.ChildCount; iLLoop++) {
		obj=document.getElementById("D"+strName+(iLLoop+1));
		if (obj) {
			//alert("选择 checkedOnEntity Begin 节点:"+entity.id+"  循环:"+iLLoop+"  子节点:"+obj.id);
			SelectOnEntity(obj,select);
			//alert("选择 checkedOnEntity end 节点:"+entity.id+"  循环:"+iLLoop+"  子节点:"+obj.id);
		}
	}
}
