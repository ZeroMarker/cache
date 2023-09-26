///DHCOPBillHDDCArcim.js
///Lid
///2012-07-12
///特殊项目的采血地点维护
var m_HDDCSRowID="";
var m_SelectedRow=-1;
function BodyLoadHandler() {
	//websys_$j=$.noConflict();	//释放jQuery对$的使用权，并重新定义新的别名.
	InitDoc();
}
function InitDoc(){
	var ADDobj=document.getElementById('Add');
	if (ADDobj) ADDobj.onclick = ADD_Click
	var Modfiyobj=document.getElementById('Update');
	if (Modfiyobj) Modfiyobj.onclick = Modfiy_Click;
	var deleteobj=document.getElementById('Delete');
	if (deleteobj) deleteobj.onclick = Delete_Click;
	var deleteobj=document.getElementById('Clear');
	if (deleteobj) deleteobj.onclick = Clear_Click;
	var deleteobj=document.getElementById('Find');
	if (deleteobj) deleteobj.onclick = Find_OnClick;
}
function SelArcimHandler(value)	{
	var val=value.split("^");
	var obj=document.getElementById('ArcimDR');
	obj.value=val[1];
}
function Find_OnClick(){
	var LocSorting=websys_$V("LocSorting");
	if(DHCWeb_Trim(LocSorting)==""){
		DHCWebD_SetObjValueB("LocSortingDR","");
	}
	var Arcim=websys_$V("Arcim");
	if(DHCWeb_Trim(Arcim)==""){
		DHCWebD_SetObjValueB("ArcimDR","");
	}
	DHCWebD_SetObjValueB("HDDCRowID","");
	Find_click();
}
function ADD_Click(){
	var Guser=session['LOGON.USERID'];
	var HDDCRowID=websys_$V("HDDCRowID");
    var LocSortingDR=websys_$V('LocSortingDR');
	if((DHCWeb_Trim(HDDCRowID)=="")||(DHCWeb_Trim(HDDCRowID)=="")){
		return;
	}
    var Position=websys_$V('Position');
	if((DHCWeb_Trim(Position)=="")){
		alert("采血地点必填");
		return;
	}
	var Arcim=websys_$V("Arcim");
	var ArcimDR=websys_$V("ArcimDR");
	if((DHCWeb_Trim(Arcim)=="")||(DHCWeb_Trim(ArcimDR)=="")){
		alert("项目必填");
		return;
	}
	var truthBeTold = window.confirm("是否确认添加?");
   	if (!truthBeTold){return;}
    var myrtn=tkMakeServerCall("web.DHCOPBillHDDCArcim","AddHDDCArcim",HDDCRowID,ArcimDR,Position,Guser);
    var rtn=myrtn.split("^")[0];
	if(rtn==0){
		websys_$("ArcimDR").value="";
		websys_$("Arcim").value="";
		websys_$("Position").value="";
		//websys_$("LocSortingDR").value="";
		//websys_$("LocSorting").value="";
		Find_click();
		alert("添加成功");
	}else if(rtn=="-1006"){
		alert("该项目已维护采血地点.");
		return;
	}else{
		alert("添加失败");
		return;
	}
}
function Modfiy_Click(){
	var Guser=session['LOGON.USERID'];
	if(m_HDDCSRowID==""){
		alert("请选择要修改的记录.");
		return;
	}
	var HDDCSRowID=m_HDDCSRowID;
    var Position=websys_$V('Position');
	if((DHCWeb_Trim(Position)=="")){
		//alert("采血地点必填");
		//return;
	}
	var Arcim=websys_$V("Arcim");
	var ArcimDR=websys_$V("ArcimDR");
	if((DHCWeb_Trim(Arcim)=="")||(DHCWeb_Trim(ArcimDR)=="")){
		alert("项目必填");
		return;
	}
	var truthBeTold = window.confirm("是否确认修改?");
   	if (!truthBeTold){return;}
    var rtn=tkMakeServerCall("web.DHCOPBillHDDCArcim","UpdateHDDCArcim",HDDCSRowID,Position,Guser);
    if(rtn==0){
		//websys_$("ArcimDR").value="";
		//websys_$("Arcim").value="";
		//websys_$("Position").value="";
		websys_$("LocSortingDR").value="";
		websys_$("LocSorting").value="";
		Find_click();
		alert("修改成功");
	}else if(rtn=="-1006"){
		alert("该项目已维护采血地点.");
		return;
	}else{
		alert("修改失败");
		return;
	}
}
function Delete_Click(){
	var Guser=session['LOGON.USERID'];
	var HDDCSRowID=m_HDDCSRowID;
	if(HDDCSRowID==""){
		alert("请选择要删除的记录.");
		return;
	}
	var truthBeTold = window.confirm("是否确认删除?");
   	if (!truthBeTold){return;}
    var rtn=tkMakeServerCall("web.DHCOPBillHDDCArcim","DeleteHDDCArcim",HDDCSRowID,Guser);
    if(rtn==0){
		websys_$("ArcimDR").value="";
		websys_$("Arcim").value="";
		websys_$("Position").value="";
		Find_click();
		alert("删除成功");
	}else{
		alert("删除失败");
		return;
	}
}
function Clear_Click(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillHDDCArcim";
	window.location.href=lnk;
}
function LocSortingSelHandler(value){
	var obj=document.getElementById('LocSortingDR');
	obj.value=value.split("^")[2];
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var rowobj=getRow(eSrc);
	Objtbl=document.getElementById('tDHCOPBillHDDCArcim');
	var Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=m_SelectedRow) {
		var SelRowObj=document.getElementById('THDDCSRowIDz'+selectrow);
		//alert(SelRowObj.value);
		m_HDDCSRowID=SelRowObj.value;
		var SelRowObj=document.getElementById('THDDCSArcimDRz'+selectrow);
		var HDDCSArcimDR=SelRowObj.value;
		DHCWebD_SetObjValueB("ArcimDR",HDDCSArcimDR);
		var SelRowObj=document.getElementById('THDDCSArcimDescz'+selectrow);
		var HDDCSArcimDesc=SelRowObj.innerText;
		DHCWebD_SetObjValueB("Arcim",HDDCSArcimDesc);
		var SelRowObj=document.getElementById('THDDCSArcimPlacez'+selectrow);
		var HDDCSArcimPlace=SelRowObj.innerText; 
		DHCWebD_SetObjValueB("Position",HDDCSArcimPlace);
		
		var SelRowObj=document.getElementById('TLocSortingDRz'+selectrow);
		var LocSortingDR=SelRowObj.value;
		DHCWebD_SetObjValueB("LocSortingDR",LocSortingDR);
		var SelRowObj=document.getElementById('TLocSortingDescz'+selectrow);
		var LocSortingDesc=SelRowObj.innerText; 
		DHCWebD_SetObjValueB("LocSorting",LocSortingDesc);
		
		//
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