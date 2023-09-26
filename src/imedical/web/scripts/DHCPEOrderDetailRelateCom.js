/// DHCPEOrderDetailRelateCom.js
/// 创建时间		2006.03.20
/// 创建人		xuwm 
/// 主要功能		编辑大项和细项组合关系对照
/// 对应表		DHC_PE_OrderDetailRelate
/// 最后修改时间	
/// 最后修改人	

var CurrentSel=0;

function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	 
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }

	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	// 输入层次时?判断是否是顶层
	//obj=document.getElementById("Cascade");
	//if (obj){ obj.onchange=Cascade_change; }
	
	// 导入LIS项目
	obj=document.getElementById("ImportLabItems");
	if (obj){
		obj.onclick=ImportLabItems_click;
		stObj=document.getElementById("StationTypeBox");
		//if (stObj && "Lab"==stObj.value) { obj.style.display="inline"; }
		var flag=tkMakeServerCall("web.DHCPE.TransOrderDetail","GetLisInterface")
		if (stObj && "Lab"==stObj.value&& "N"==flag) { obj.style.display="inline"; }

	}

	iniForm();
	ShowCurRecord(1);

	}  

function iniForm(){

	var SelRowObj;
	var obj;

	//当前页面的父项 组合项目编码
	SelRowObj=document.getElementById('ParARCIMDR');
	obj=document.getElementById("ARCIM_DR");	
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	
	if (''==SelRowObj.value) {
	    obj=document.getElementById("ARCIM_DR_Name");
	    if (obj) { obj.value="当前站点没有医嘱项目"; }
	}
	else{
	    obj=document.getElementById("ARCIM_DR_Name");
	    if (obj) { obj.value="当前医嘱项目没有子项"; }
		ShowCurRecord(1); 
	}
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}	
 
//搜索组合项目(医嘱)  
function SearchArcItmmast(value){

	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;
		//组合项目编码
		obj=document.getElementById("ARCIM_DR");
		obj.value=aiList[2];
		//组合项目名称
		obj=document.getElementById("ARCIM_DR_Name");
		obj.value=aiList[1];
  	}
}


function SearchParentOrderDetailRelate(value) {
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;

		obj=document.getElementById("Parent_DR");
		obj.value=aiList[1];

		obj=document.getElementById("Parent_DR_Name");
		obj.value=aiList[0];
  	}	
}
function ImportLabItems_click(){
	var obj=document.getElementById('ImportLabItemsBox');
	ARCIMDr=GetCtlValueById("ARCIM_DR", true);
	
	if (obj) {var encmeth=obj.value; } 
	else {var encmeth=''; }
	var flag=cspRunServerMethod(encmeth,ARCIMDr);
	
	location.reload();
}
// 输入层次时?判断是否是顶层,是则将父项变为可使用
function Cascade_change () {
	var Src=window.event.srcElement;
	
	obj=document.getElementById("Parent_DR_Name");
	if ("1"==Src.value) { if (obj) { obj.disabled=false; } }
	else{if (obj) { obj.disabled=true; } } 
}

//搜索子项
function SearchDetailList(value){
	
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
		Clear_click();
		//子项编码
		obj=document.getElementById("OD_DR");
		obj.value=aiList[2];

		//子项名称
		obj=document.getElementById("OD_DR_Name");
		obj.value=aiList[0];

	}
}
 
function Update_click() {

	var iRowId="";
	var iARCIMDR="", iODDR="", iSequence="", iRequired="",iParentDR="", iCascade="",iHistory="0";
	var obj;
	// 0 
	obj=document.getElementById("RowId");  
	if (obj){ iRowId=obj.value; }  

	// 1 组合项目编码
	obj=document.getElementById("ARCIM_DR");
	if (obj){ iARCIMDR=obj.value; }  

	// 2 子项编码
	obj=document.getElementById("OD_DR");
	if (obj){ iODDR=obj.value; }  

	// 3 顺序号 ODR_Sequence
	obj=document.getElementById("Sequence");
	if (obj){ iSequence=obj.value; }
	
     if (""==iODDR) {
		obj=document.getElementById("OD_DR")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("子项名称不能为空");
		return false;
	}

	if (""==iSequence) {
		obj=document.getElementById("Sequence")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("顺序号不能为空");
		return false;
	}

	// 4 是否必填项 ODR_Required
	obj=document.getElementById("Required");
	if (obj){
		if (obj.checked==true){ iRequired="Y"; }
		else{ iRequired="N"; }
	}
	
	// 5 大类指针 ODR_Parent_DR
	obj=document.getElementById("Parent_DR");  
	if (obj){ 
		iParentDR=obj.value;
		if (""!=iParentDR) {
			obj=document.getElementById("Parent_DR_Name");
			if (obj && ""==obj.value) { iParentDR=""; }
		}
	}
	
	// 6 层次 ODR_Cascade
	obj=document.getElementById("Cascade");  
	if (obj){ 
		iCascade=obj.value;
		if ("1"==iCascade) { iParentDR=""; }
	}  
	// 6 层次 HistoryFlag
	obj=document.getElementById("HistoryFlag");  
	if (obj){ 
		if (obj.checked) { iHistory="1"; }
	}  
	
	/*
	//输入数据验证
	if ((""==iARCIMDR)||(""==iODDR)){
		//alert("Please entry all information.");
		alert(t['01']);
		return false;
	}
*/
	var Instring=trim(iRowId)			// 0
				+"^"+trim(iARCIMDR)		// 1 组合项目编码
				+"^"+trim(iODDR)		// 2 子项编码
				+"^"+trim(iSequence)	// 3 顺序号 ODR_Sequence
				+"^"+trim(iRequired)	// 4 是否必填项 ODR_Required
				+"^"+trim(iParentDR)	// 5 大类指针 ODR_Parent_DR
				+"^"+trim(iCascade)		// 6 层次 ODR_Cascade
				+"^"+trim(iHistory)		// 6 报告中比对
				;
	
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } 
	else {var encmeth=''; }
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	if (flag=='-104') {
		alert('所引用的父表记录不存在');}
	else{
		if (flag=='0') {
		}else if (flag=='Err 01') {
			alert(t['Err 01']);
		}else{
			//alert("Insert error.ErrNo="+flag)
			alert(t['02']+flag);
		}
	} 
	//刷新当前页面
	location.reload();

}

function Delete_click() {

	var iRowId="";
	var obj;

	//记录编号
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }

	//组合项目编码
	obj=document.getElementById("ARCIM_DR");
	if (obj){ iARCIM_DR=obj.value; }

	//子项编码
	obj=document.getElementById("OD_DR");
	if (obj){ iOD_DR=obj.value; }
	  
	if ((""==iARCIM_DR)||(""==iOD_DR)){
		//alert("Please select the row to be deleted.");
		alert(t['03']);
		return false;
	} 
	else{ 
		//if (confirm("Are you sure delete it?")){
		if (confirm(t['04'])){
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value} 
			else {var encmeth=''; };
			var flag=cspRunServerMethod(encmeth,'','',iRowId)
			if (flag=='0') {}
			else{ 
				//alert("Delete error.ErrNo="+flag);
				alert(t['05']+flag);
			}
	     
			location.reload();
		}
	}

}
//清除
function Clear_click() {
	var obj;
	
	//不清除父节点
	/*	
	//组合项目编码
	obj=document.getElementById("ARCIM_DR");
	obj.value="";

	//组合项目名称
	obj=document.getElementById("ARCIM_DR_Name");
	obj.value="";
	*/
	

	// 子项编码
	obj=document.getElementById("OD_DR");
	if (obj) { obj.value=""; }

	// 子项名称
	obj=document.getElementById("OD_DR_Name");
	if (obj) { obj.value=""; }


	// 3 顺序号 ODR_Sequence
	var obj=document.getElementById("Sequence");
	if (obj) { obj.value=""; }

	// 4 是否必填项 ODR_Required
	var obj=document.getElementById("Required");
	if (obj){ obj.checked=false; }
	
	// 5.1 大类指针 ODR_Parent_DR
	var obj=document.getElementById("Parent_DR");  
	if (obj) { obj.value=""; }
	
	// 5 大类指针 ODR_Parent_DR
	var obj=document.getElementById("Parent_DR_Name");  
	if (obj) { obj.value=""; }
	
	// 6 层次 ODR_Cascade
	var obj=document.getElementById("Cascade");  
	if (obj) { obj.value=""; }

   
	//记录编号
	obj=document.getElementById("RowId");
	if (obj) { obj.value=""; }
	//记录编号
	obj=document.getElementById("HistoryFlag");
	if (obj) { obj.checked=false; }
}

//显示当前记录
function ShowCurRecord(CurRecord) {
	var selectrow=CurRecord;
	
	var SelRowObj;
	var obj;
	
	//组合项目编码
	SelRowObj=document.getElementById('ODR_ARCIM_DR'+'z'+selectrow);
	obj=document.getElementById("ARCIM_DR");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }

	//组合项目名称
	SelRowObj=document.getElementById('ODR_ARCIM_DR_Name'+'z'+selectrow);
	obj=document.getElementById("ARCIM_DR_Name");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }


	// 3 顺序号 ODR_Sequence
	SelRowObj=document.getElementById('ODR_Sequence'+'z'+selectrow);
	obj=document.getElementById("Sequence");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }

	
	// 5 大类指针 ODR_Parent_DR
	SelRowObj=document.getElementById('ODR_Parent_DR'+'z'+selectrow);
	obj=document.getElementById("Parent_DR");  
	if (SelRowObj && obj) { obj.value=SelRowObj.value; } 
	
	// 5.1 大类指针 ODR_Parent_DR
	SelRowObj=document.getElementById('ODR_Parent_DR_Name'+'z'+selectrow);
	obj=document.getElementById("Parent_DR_Name");  
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); } 
	
	// 6 层次 ODR_Cascade
	SelRowObj=document.getElementById('ODR_Cascade'+'z'+selectrow);
	obj=document.getElementById("Cascade");  
	if (SelRowObj && obj) {
		var iCascade=trim(SelRowObj.innerText);
		obj.value=iCascade;
		
		//obj=document.getElementById("Parent_DR_Name");
		//if ("1"==iCascade) { if (obj) { obj.disabled=false; } }
		//else{if (obj) { obj.disabled=true; } } 
	} 

	// 4 是否必填项 ODR_Required
	SelRowObj=document.getElementById('ODR_Required'+'z'+selectrow);
	obj=document.getElementById("Required");
	if (SelRowObj && obj) { obj.checked=SelRowObj.checked; }

	//子项编码
	SelRowObj=document.getElementById('ODR_OD_DR'+'z'+selectrow);
	obj=document.getElementById("OD_DR");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }

	//子项名称
	SelRowObj=document.getElementById('ODR_OD_DR_Name'+'z'+selectrow);
	obj=document.getElementById("OD_DR_Name");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }
    
	//记录编码
	SelRowObj=document.getElementById('ODR_RowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }
	//历史比对
	SelRowObj=document.getElementById('HistoryFlag'+'z'+selectrow);
	obj=document.getElementById("HistoryFlag");
	if (SelRowObj && obj) { obj.checked=SelRowObj.checked; }
}

function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);		
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	
	if (selectrow==CurrentSel){
	    
	    Clear_click(); 	    
	    CurrentSel=0
	    return;
	}

	CurrentSel=selectrow;
	ShowCurRecord(CurrentSel);
    
}

// **********************************************************
////////                以下未经测试           ///////////
//显示组合项目的子项 关联到 DHCPEOrderDetailRelateShowOrderDetail 组件上
function ShowArcItmmastDetailList(ARCIMDR){
    return false;
    var GetCodeVar=document.getElementById("OrderDetailAllBox").value;

    var str=cspRunServerMethod(GetCodeVar,"");

    var selbox=parent.parent.frames['DHCPEOrderDetailRelateShowOrderDetail'].document.getElementById("DisplayItem");

    addlistoption(selbox,str);


}

function addlistoption(selobj,resStr) {
	var resList=new Array();
	var tmpList=new Array();
	selobj.options.length=0;
	resList=resStr.split("!")
//	alert (selobj.length);
	for (i=1;i<resList.length;i++) {
		tmpList=resList[i].split("^")
		selobj.add(new Option(tmpList[1],tmpList[0]));
	}
}
function moveout_Click() {
	var surlist=document.getElementById("DisplayItem");
	var dlist=document.getElementById("DisplayAll");
	moveout(surlist,dlist);
	savevar(surlist);
}

function movein_Click() {
	var surlist=document.getElementById("AisplayAll");
	var dlist=document.getElementById("DisplayItem");
	movein(surlist,dlist);
	savevar(dlist);
	
}

document.body.onload = BodyLoadHandler;