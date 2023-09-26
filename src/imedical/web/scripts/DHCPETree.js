/// ����			DHCPETree.js
/// ����ʱ��		2006.09.21
/// ������			xuwm
/// ��Ҫ����		ʵ�������ͽṹ�йصò���
/// ��Ӧ��		
/// ����޸�ʱ��	
/// ����޸���	
/// ���


// ��ǰ����򿪵Ľڵ�
var CurExpand;

//��������ʾ��ͼƬ
var imageOpen="../images/websys/find.gif";
//��������ر���ʾ��ͼƬ
var image="../images/websys/edit.gif";

var xslFile="tree.xsl";

// ���Ͳ˵�
var TreeName="DivTree";



function swapClass(obj, cls) {
  	obj.className = cls
}

// �������ͽṹ 
function CreateTreeFromXMLObject(obj, xmlobj) {
  //if (""!=xslobj) { load_xmln2(obj,xmlobj,xslobj); }
  //else { 
	//alert("CreateTree:"+xmlobj.innerHTML+";");
	if (""!=xmlobj.innerHTML) {
		// �˺�����DHCPECommon.xml.js
  		load_xmlnFromXMLObject(obj,xmlobj,xslFile); 
  		CurExpand=null;
	}
  	
 // }
}

// /////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////
// ���ͽṹ����
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
		//alert("��� checkedOnEntity:"+parentTree.id);
		SelectOnEntity(parentTree, src.checked);
		
	}
	window.event.cancelBubble = true;
}

function SelectOnEntity(entity, select) {
	//alert("ѡ�� checkedOnEntity �ڵ�:"+entity.id+"  "+select+" ��Ŀ:"+entity.ChildCount);
	var strName=entity.id.substr(1);
	var iLLoop=0; //�������������?Javascript�ͻ�ѱ�����Ϊȫ�ֱ���ʹ��
	var obj=document.getElementById("C"+strName);
	if (obj) { obj.checked=select; }
	else { return; }
	
	if (1>entity.ChildCount) { return; }
	
	if (select) { expand(entity); }
	else { collapse(entity); }
	
	for(iLLoop=0; iLLoop<entity.ChildCount; iLLoop++) {
		obj=document.getElementById("D"+strName+(iLLoop+1));
		if (obj) {
			//alert("ѡ�� checkedOnEntity Begin �ڵ�:"+entity.id+"  ѭ��:"+iLLoop+"  �ӽڵ�:"+obj.id);
			SelectOnEntity(obj,select);
			//alert("ѡ�� checkedOnEntity end �ڵ�:"+entity.id+"  ѭ��:"+iLLoop+"  �ӽڵ�:"+obj.id);
		}
	}
}
