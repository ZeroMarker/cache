///DHCOPBillLocSortingDefine.js
///Lid
///2012-07-12
///科室分类定义
var m_LocSortingDR="";
var m_SelectedRow="-1";
function BodyLoadHandler(){
	InitDoc();
}
function InitDoc(){
	var obj=websys_$("Add");
	if(obj){
		obj.onclick=Add_OnClick;
	}
	var obj=websys_$("Delete");
	if(obj){
		obj.onclick=Delete_OnClick;
	}
	var obj=websys_$("Update");
	if(obj){
		obj.onclick=Update_OnClick;
	}
	var obj=websys_$("Clear");
	if(obj){
		obj.onclick=Clear_OnClick;
	}
	var cookieOrderType=DHCBILL.getCookie("DHCOPBillLocSortingDefineOrderTypeSelectIdx");
	var obj=document.getElementById("OrdType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=OrdType_OnChange;
		if(cookieOrderType!=""){
			obj.selectedIndex=cookieOrderType;
		}else{
			obj.selectedIndex=0;
		}
		//alert(obj.value+"^"+obj.options[obj.selectedIndex].text);
	}
}
function OrdType_OnChange(){
	DHCBILL.setCookie("DHCOPBillLocSortingDefineOrderTypeSelectIdx",this.selectedIndex,30);
}
function Add_OnClick(){
	var Guser=session['LOGON.USERID'];

	var PYM=websys_$V("PYM");
	if(DHCWeb_Trim(PYM)==""){
		alert("编码不能为空");
		return;
	}
	var LocSorting=websys_$V("LocSorting");
	if(DHCWeb_Trim(LocSorting)==""){
		alert("科室分类名称不能为空");
		return;
	}
	var truthBeTold = window.confirm("是否新增科室分类?");
   	if (!truthBeTold){return;}
	var OrderType=websys_$V("OrdType");
	var myrtn=tkMakeServerCall("web.DHCOPBillLocSortingDefine","InsertLocSorting",LocSorting,PYM,Guser,OrderType);
	if(myrtn==0){
		alert(myrtn+":添加成功.");
		DHCWebD_SetObjValueB("LocSorting","");
		DHCWebD_SetObjValueB("PYM","");
		Find_click();
	}else if(myrtn=="-1001"){
		alert(myrtn+":编码不能重复");
	}else if(myrtn=="-1002"){
		alert(myrtn+":科室分类名称不能重复");
	}else{
		alert(myrtn+":添加失败.");
	}
}

function Delete_OnClick(){
	
	var LocSortingDR=m_LocSortingDR;
	if(LocSortingDR==""){
		alert("请选择要删除的科室分类");
		return;
	}
	if(m_LocSortingDR=="")return;
	var truthBeTold = window.confirm("是否删除科室分类?");
   	if (!truthBeTold){return;}
	
	var myrtn=tkMakeServerCall("web.DHCOPBillLocSortingDefine","DeleteLocSorting",LocSortingDR);
	if(myrtn==0){
		alert(myrtn+":删除成功.");
		DHCWebD_SetObjValueB("LocSorting","");
		DHCWebD_SetObjValueB("PYM","");
		Find_click();
	}else if(myrtn=="-1003"){
		alert(myrtn+":该分类已维护数据,不能删除.");
	}else{
		alert(myrtn+":删除失败.");
	}
}

function Update_OnClick(){
	var LocSortingDR=m_LocSortingDR;
	if(LocSortingDR==""){
		alert("请选择要删除的科室分类");
		return;
	}
	var Guser=session['LOGON.USERID'];
	var PYM=websys_$V("PYM");
	if(DHCWeb_Trim(PYM)==""){
		alert("编码不能为空");
		return;
	}
	var LocSorting=websys_$V("LocSorting");
	if(DHCWeb_Trim(LocSorting)==""){
		alert("科室分类名称不能为空");
		return;
	}

		if(m_LocSortingDR=="")return;
	var truthBeTold = window.confirm("是否修改科室分类名称?");
   	if (!truthBeTold){return;}
	
	var OrderType=websys_$V("OrdType");
	var myrtn=tkMakeServerCall("web.DHCOPBillLocSortingDefine","UpdateLocSorting",LocSortingDR,LocSorting,PYM,Guser,OrderType);
	if(myrtn==0){
		alert(myrtn+":更新成功.");
		DHCWebD_SetObjValueB("LocSorting","");
		DHCWebD_SetObjValueB("PYM","");
		Find_click();
	}else if(myrtn=="-1004"){
		alert(myrtn+":编码不能修改");
	}else if(myrtn=="-1002"){
		alert(myrtn+":科室分类名称不能重复");
	}else{
		alert(myrtn+":更新失败.");
	}
}

function Clear_OnClick(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillLocSortingDefine";
	window.location.href=lnk;
}
function SelectRowHandler()	{   
	var eSrc=window.event.srcElement;
	var rowobj=getRow(eSrc);
	Objtbl=document.getElementById('tDHCOPBillLocSortingDefine');
	var Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=m_SelectedRow) {
		var SelRowObj=document.getElementById('TLocSortiingDescz'+selectrow);
		var LocSortingDesc=SelRowObj.innerText;
		DHCWebD_SetObjValueB("LocSorting",LocSortingDesc);
		var SelRowObj=document.getElementById('TLocSortingCodez'+selectrow);
		var LocSortingCode=SelRowObj.innerText;
		DHCWebD_SetObjValueB("PYM",LocSortingCode);
		var SelRowObj=document.getElementById('TLocSortingDRz'+selectrow);
		m_LocSortingDR=SelRowObj.innerText; 
		//
		m_SelectedRow = selectrow;
	}else{
		
	}
}

function DHCWeb_Trim(str){   
	 return str.replace(/(^\s*)|(\s*$)/g, "");  
}  
//删除左边的空格
function DHCWeb_LTrim(str){   
	return str.replace(/(^\s*)/g,"");  
}  
//删除右边的空格
function DHCWeb_RTrim(str){   
	return str.replace(/(\s*$)/g,"");  
}  
document.body.onload = BodyLoadHandler;