// fileName: DHCPEPreItemList.QryItm.JS
//Created by SongDeBo 2006/06/12
//Description: Component script.
var AlertFlag=0;
function IniMe(){
	var tbl=document.getElementById("tDHCPEPreItemList_QryItm"); 
	if(tbl) tbl.ondblclick=table_onDBClick;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	var obj=document.getElementById("Item");
	if (obj) obj.onkeydown=Item_KeyDown;
	var obj=document.getElementById("StationID");
	if (obj) obj.onchange=StationID_change;
	var obj=document.getElementById("BAddItem");
	if (obj) obj.onclick=BAddItem_click;

	init();
}

function init()
{
	var frameName=GetCtlValueById("TargetFrame");
	var myFrame=parent.frames[frameName];
	if (myFrame){
		var obj=document.getElementById("Item");
		//obj.disabled=true;
		var obj=document.getElementById("BFind");
		//obj.disabled=true;
	}

	//var myFrame=parent.frames['PreItemList'];
	var myFrame=parent.frames['frameName'];
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
	var objtbl=document.getElementById('tDHCPEPreItemList_QryItm');	
	if (objtbl) { var Rows=objtbl.rows.length; }
	var frameName=GetCtlValueById("TargetFrame");
	var myFrame=parent.frames[frameName];
	if (!myFrame.ItemMap) return false;
	
	for (var j=1;j<Rows;j++) {
		var TItemId="";
		var obj=document.getElementById('TItemIdz'+j);
		if (obj) TItemId=obj.value;
		if (TItemId=="") objtbl.rows[j].style.background="lightgreen";
		var obj=document.getElementById('TItemDescz'+j);
		if (obj) ItemDesc=obj.innerText;
		if (myFrame){
			//alert(myFrame.ItemMap.get(ItemDesc))
			if (myFrame.ItemMap.get(ItemDesc)==0) objtbl.rows[j].style.background="lightgreen";
			if (myFrame.ItemMap.get(ItemDesc)==1) objtbl.rows[j].style.background="#AABBAA";
		}
	}
}
function Item_KeyDown()
{
	if (event.keyCode==13)
	{
		BFind_click();
		return false;
	}
	
}

function StationID_change()
{
	BFind_click();
	return false;
}

function BFind_click()
{
	var obj=document.getElementById("Item");
	var Item="",Type="",StationID="";
	if (obj) Item=obj.value;
	var obj=document.getElementById("Type");
	if (obj) Type=obj.value;
	
	var obj=document.getElementById("PreIADMID");
	if (obj) PreIADMID=obj.value;
	
	var obj=document.getElementById("StationID");
	if (obj) StationID=obj.value;
    
	var obj=document.getElementById("TargetFrame");
	if (obj) TargetFrame=obj.value;
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&Item="+Item+"&TargetFrame=PreItemList&Type="+Type+"&PreIADMID="+PreIADMID+"&StationID="+StationID;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&Item="+Item+"&TargetFrame="+TargetFrame+"&Type="+Type+"&PreIADMID="+PreIADMID+"&StationID="+StationID;
	window.location.href=lnk;
	return false;
}
function BAddItem_click()
{
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEPreItemList_QryItm');	//取表格元素?名称
	var rows=objtbl.rows.length;
	var frameName=GetCtlValueById("TargetFrame");
	var myFrame=parent.frames[frameName];
	var ItemType="ITEM";
	for (var i=1;i<=rows;i++)
	{
		var obj=document.getElementById("TSelectz"+i);
		if (obj&&obj.checked){
			var ItemId=GetCtlValueById("TItemIdz"+i);
			var obj=document.getElementById("TItemPricez"+i);
			var AddAmount=""
			if (obj) AddAmount=obj.innerText;
			
			var ret=myFrame.IAdd(ItemType, ItemId,AddAmount);
			//alert(ItemId+"^"+ret+"^"+i)
			//if (false==ret) return false;
			objtbl.rows[i].style.background="lightgreen";
		}
	}
	for (var i=1;i<=rows;i++)
	{
		var obj=document.getElementById("TSelectz"+i);
		if (obj&&obj.checked){	
			obj.checked=false;
		}
	}

}

function table_onDBClick(){
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEPreItemList_QryItm');	//取表格元素?名称
	var rows=objtbl.rows.length;
	
	var rowObj=getRow(eSrc);
	var rowIndex=rowObj.rowIndex;
	
	if (rowIndex<=0) {return false;}
	
	var ItemId=GetCtlValueById("TItemIdz"+rowIndex);
	var ItemType="ITEM";
	var obj=document.getElementById("TItemPricez"+rowIndex);
	var AddAmount=""
	if (obj) AddAmount=obj.innerText;
	//var AddAmount=GetCtlValueById("TItemPricez"+rowIndex);
	var frameName=GetCtlValueById("TargetFrame");
	var myFrame=parent.frames[frameName];
	var ret=myFrame.IAdd(ItemType, ItemId,AddAmount);
	if (false==ret) return false;
	objtbl.rows[rowIndex].style.background="lightgreen";
	websys_setfocus('Item');
	setTimeout("GetMouseStatus()",600);

	//doc.IAdd(ItemType, ItemId);
}
function GetMouseStatus()
{
	var Type=GetCtlValueById("Type");
	if(Type=="Item"){parent.frames["PreItemList.Qry2"].websys_setfocus('Item');}
	if(Type=="Lab"){parent.frames["PreItemList.Qry3"].websys_setfocus('Item');}
	

}

document.body.onload = IniMe;

/*
//FileName: DHCPEPreItemList.JS
//Created by SongDeBo 2006/6/7
//Description: 预约项目
//
var gMyName="DHCPEPreItemList";
var gUserId=session['LOGON.USERID']
var gAdmId="", gIsGroup="", gAdmType="", gTargetFrame=""
var gRowIndex=""

var IsExec=false; // 是否正在执行操作

function IniMe(){
	//var obj=document.getElementById("btnRefresh");
	//obj.onclick=btnRefresh_Click;
	//var obj=document.getElementById("btnAdd");
	//obj.onclick=btnAdd_Click;	
	var obj=document.getElementById("btnShowItem");
	obj.onclick=btnShowItem_Click;	
	var obj=document.getElementById("btnShowItemSet");
	obj.onclick=btnShowItemSet_Click;	
	var obj=document.getElementById("btnDeleteItem");
	obj.onclick=btnDeleteItem_Click;	
	var obj=document.getElementById("btnDeleteSet");
	obj.onclick=btnDeleteSet_Click;	
	//var obj=document.getElementById("btnSaveFactAmount");
	//obj.onclick=btnSaveFactAmount_onClick;	
	
	gIsGroup=GetCtlValueById("txtIsGroup",1)
	gAdmId=GetCtlValueById("txtAdmId",1)
	gAdmType=(gIsGroup=="1"?"TEAM":"PERSON")
	gTargetFrame=GetCtlValueById("TargetFrame",1)
	
	if (gTargetFrame==""){
		document.getElementById("btnShowItemSet").style.visibility = "hidden";
		document.getElementById("btnShowItem").style.visibility = "hidden";		
	}
	
	if ((gIsGroup=="")||(gAdmId=="")){
		alert("Please tranfer AdmId to this component");
		return;		
	}
}
function btnShowItem_Click(){
	var queryDesc=GetCtlValueById("txtItemDesc",1)
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&Desc="+queryDesc+"&TargetFrame="+window.frameElement.name  ;
    parent.frames[gTargetFrame].location.href=lnk;	
}

function btnShowItemSet_Click(){
	var queryDesc=GetCtlValueById("txtItemSetDesc",1)
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QrySet&orderSetDesc="+queryDesc+"&TargetFrame="+window.frameElement.name  ;
    parent.frames[gTargetFrame].location.href=lnk;	
}


//orderType="ORDERENT/ORDERITEM"
function DeleteOrder(OrderType){
	var ordItemId=GetCtlValueById("TRowIdz"+gRowIndex);
	var ordEntId=GetCtlValueById("TOrderEntIdz"+gRowIndex);
	var isBreakable=GetCtlValueById("TIsBreakablez"+gRowIndex);
	
	if ((gRowIndex<=0)||(ordItemId=="")) {
		alert(t['NoSelected']);
		return false;
	}
	if ((OrderType=="ORDERITEM")&&(isBreakable=="N")&&(ordEntId!="")){
		alert(t['Unbreakable']);
		return false;
	}
	if ((OrderType=="ORDERENT")&&(ordEntId=="")){
		alert(t["NotASet"]);
		return false;
	}
	
	if (OrderType=="ORDERITEM") {ordEntId=""};
	if (OrderType=="ORDERENT") {ordItemId=""};
	
	var encmeth=GetCtlValueById('txtDeleteBox',1);  
    var flag=cspRunServerMethod(encmeth,gAdmId, gAdmType,ordItemId, ordEntId)
    if (flag!="") {
	    alert(t['ErrSave']+"  "+flag);
	    return false;
    }
    
    location.reload();
}

function btnDeleteItem_Click(){
	 DeleteOrder("ORDERITEM");
}

function btnDeleteSet_Click(){
	DeleteOrder("ORDERENT");
}

function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('t'+gMyName);	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	gRowIndex=rowObj.rowIndex;
}

function btnRefresh_Click(){
	
	gIsGroup=GetCtlValueById("txtIsGroup",1)
	gAdmId=GetCtlValueById("txtAdmId",1)	
	gAdmType=(gIsGroup=="1"?"TEAM":"PERSON")
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+gMyName +
			"&AdmId="+gAdmId +"&AdmType=" + gAdmType + 
			"&TargetFrame="+GetCtlValueById("TargetFrame",1);
			
	location.href=lnk;
}
function btnAdd_Click(){
	AddOrder();
}

function AddOrder(){
	var ItemSetId=GetCtlValueById("txtItemSetId",1)
	var ItemId=GetCtlValueById("txtItemId",1)
	if ((ItemId=="")&&(ItemSetId=="")){
		Alert(t['NoSelected']);
		return false;
	}
	
	var encmeth=GetCtlValueById('txtAddBox',1);
    var flag=cspRunServerMethod(encmeth,gAdmId, gAdmType,ItemId, ItemSetId,gUserId)

    if (flag!="") {
	    alert(t['ErrSave']+":"+flag);
	    return false;
    }
    
    location.reload();
    return false;
}

/// AddType= "ITEM/ITEMSET"

function IAdd(AddType, Id){

	if (IsExec) { return false; } 
	else {
		IsExec=true;
		var obj=document.getElementById("btnShowItem");
		if (obj) { obj.disabled=true; }
		var obj=document.getElementById("btnShowItemSet");
		if (obj) { obj.disabled=true; }
	}
		
	SetCtlValueByID("txtItemId","",1);
	SetCtlValueByID("txtItemSetId","",1);
	if (AddType=="ITEM"){SetCtlValueByID("txtItemId",Id,1);}
	else {SetCtlValueByID("txtItemSetId",Id,1);}
	
	AddOrder();
	
	{
		IsExec=false;
		var obj=document.getElementById("btnShowItem");
		if (obj) { obj.disabled=false; }
		var obj=document.getElementById("btnShowItemSet");
		if (obj) { obj.disabled=false; }
	}	
}

function SelectedItem(value){
	var aiList=value.split("^");
	if (""==value){return false}
	
	var ItemId=aiList[2]
	var ItemDesc=aiList[1]
	SetCtlValueByID("txtItemId",ItemId,1)
	SetCtlValueByID("txtItemDesc",ItemDesc,1)
	SetCtlValueByID("txtItemSetId","",1)
	SetCtlValueByID("txtItemSetDesc","",1)
}

function SelectedItemSet(value){
	var aiList=value.split("^");
	if (""==value){return false;}
	
	var ItemSetId=aiList[0];
	var ItemSetDesc=aiList[1];
	SetCtlValueByID("txtItemId","",1);
	SetCtlValueByID("txtItemDesc","",1);
	SetCtlValueByID("txtItemSetId",ItemSetId,1);
	SetCtlValueByID("txtItemSetDesc",ItemSetDesc,1);
}

function btnSaveFactAmount_onClick(){
	DAlert("entered btnSaveFactAmount_onClick");
	var factAmount=GetCtlValueById("txtFactAmount");
	var serveCode=GetCtlValueById("txtSaveFactAmountBox");
	factAmount=Val(factAmount);
	admType=(gAdmType="TEAM"?"GROUP":"PERSON");
	admId=(gAdmType="TEAM"?Val(gAdmId):gAdmId);
    var flag=cspRunServerMethod(serveCode,admId, admType,factAmount)
    if (flag!="") {
	    alert(t['ErrSave']+"  "+flag);
	    return false;
    }
	
}

//this.prototype.Test=myTest();
document.body.onload = IniMe;

*/