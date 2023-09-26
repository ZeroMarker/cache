// fileName: DHCPEPreItemList.QrySet.JS
//Created by SongDeBo 2006/06/12
//Description: Component script.

function IniMe(){
	//alert('z');
	var tbl=document.getElementById("tDHCPEPreItemList_QrySet"); 
	if(tbl) tbl.ondblclick=table_onDBClick;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	var obj=document.getElementById("Set");
	if (obj) obj.onkeydown=Set_KeyDown;
	init();
}
function init()
{
	//alert('z')
	var frameName=GetCtlValueById("TargetFrame");
	var myFrame=parent.frames[frameName];
	if (myFrame){
		var obj=document.getElementById("Set");
		//obj.disabled=true;
		var obj=document.getElementById("BFind");
		//obj.disabled=true;
	}
	var myFrame=parent.frames['PreItemList'];
	//if (myFrame) myFrame.SetFocus();
	if(myFrame.document.readyState=='complete')
	{  
		SetItemBackColor();
	}else{
		timeIframe=setTimeout("init()",5);
	}
}
function SetItemBackColor()
{
	var objtbl=document.getElementById('tDHCPEPreItemList_QrySet');	
	if (objtbl) { var Rows=objtbl.rows.length; }
	var frameName=GetCtlValueById("TargetFrame");
	var myFrame=parent.frames[frameName];
	if (!myFrame.SetMap) return false;
	for (var j=1;j<Rows;j++) {
		var obj=document.getElementById('TOrderSetDescz'+j);
		if (obj) ItemDesc=obj.innerText;
		if (myFrame){
			if (myFrame.SetMap.get(ItemDesc)!=null) objtbl.rows[j].style.background="#AABBAA";
		}
	}
}
function Set_KeyDown()
{
	if (event.keyCode==13)
	{
		BFind_click();
		return false;
	}
	
}
function BFind_click()
{
	var obj=document.getElementById("Set");
	var Item="",Type="";
	if (obj) Item=obj.value;
	var obj=document.getElementById("Type");
	if (obj) Type=obj.value;
	var obj=document.getElementById("AdmId");
	if (obj) AdmId=obj.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QrySet&Set="+Item+"&TargetFrame=PreItemList&Type="+Type+"&AdmId="+AdmId;
	window.location.href=lnk;
	
}
function table_onDBClick(){
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEPreItemList_QrySet');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	
	var rowObj=getRow(eSrc);
	var rowIndex=rowObj.rowIndex;
	
	if (rowIndex<=0) {return false;}
	
	var ItemId=GetCtlValueById("TOrderSetIdz"+rowIndex);
	var ItemType="ITEMSET";
	
	var obj=document.getElementById("TOrderSetPricez"+rowIndex);
	var AddAmount=""
	if (obj) AddAmount=obj.innerText;
	var myFrame=parent.frames['PreItemList'];
	myFrame.IAdd(ItemType, ItemId,AddAmount);
	objtbl.rows[rowIndex].style.background="#AABBAA";
	//SetItemBackColor();
	var myFrame=parent.frames['PreItemList.Qry2'];
	if (myFrame) myFrame.init();
	var myFrame=parent.frames['PreItemList.Qry3'];
	if (myFrame) myFrame.init();
	//doc.IAdd(ItemType, ItemId);
}

document.body.onload = IniMe;