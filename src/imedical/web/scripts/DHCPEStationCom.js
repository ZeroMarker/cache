/// DHCPEStationCom.js
/// 创建时间		2006.03.16
/// 创建人		xuwm
/// 主要功能		编辑站点基本信息
/// 对应表		DHC_PE_Station
/// 最后修改时间	
/// 最后修改人	
/// 完成


var CurrentSel=0
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }

	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	obj=document.getElementById("ImportItem");
	if (obj){obj.onclick=ImportItem_click;}
	iniForm();
   
    var obj=document.getElementById("ST_Codez1");
	if (obj) obj.click();



}
function ImportItem_click()
{
	var obj;
	obj=document.getElementById("RowId");
	if (obj) var StationID=obj.value;
	obj=document.getElementById("ImportItemBox");
	if (obj) var encmeth=obj.value;
	obj=document.getElementById("ArcCatID");
	if (obj) var ArcCatID=obj.value;
	var flag=cspRunServerMethod(encmeth,StationID);
	alert(flag)
}
function iniForm(){
	Clear_click();

	ShowCurRecord(1);
	
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
//验证是否为浮点数
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		//容许为空
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

function Update_click() {
	var iRowId="",iLayoutType="",iButtonType="",iReportSequence="";
	var iCode="", iDesc="", iPlace="", iSequence="", iActive="",iAutoAudit="N",iAllResultShow="";

	//1 记录编码 	  
	var obj=document.getElementById("RowId");
	if (obj){iRowId=obj.value; } 
    
	//2 站点编码
	var obj=document.getElementById("Code");
	if (obj){iCode=obj.value; } 

	//3 站点描述(名称)
	var obj=document.getElementById("Desc");
	if (obj){iDesc=obj.value; } 

	//4 站点所在位置
	var obj=document.getElementById("Place");
	if (obj){iPlace=obj.value; } 

	//5 顺序
	var obj=document.getElementById("Sequence");
	if (obj){
		iSequence=obj.value; 
		if (IsFloat(iSequence)){}
		else {
			//alert("顺序号输入错误!!!");
			alert(t['Err 03']);
			websys_setfocus("Sequence");
			return false;
		}
	} 

	//6 激活
	var obj=document.getElementById("Active");
	if (obj){
		if (obj.checked==true){ iActive="Y"; }
		else{ iActive="N"; }
	}  
	//7 自动提交
	var obj=document.getElementById("AutoAudit");
	if (obj){
		if (obj.checked){ iAutoAudit="Y"; }
		else{ iAutoAudit="N"; }
	}
	//8 iLayoutType=""界面类型
	var obj=document.getElementById("LayoutType");
	if (obj){iLayoutType=obj.value; } 
	//9 iButtonType=""按钮类型
	var obj=document.getElementById("ButtonType");
	if (obj){iButtonType=obj.value; } 
	
	//报告顺序
	
	var obj=document.getElementById("ReportSequence");
	if (obj){
		iReportSequence=obj.value; 
		if(iReportSequence=="")
		{
			alert("报告顺序不能为空")
			websys_setfocus("ReportSequence");
			return false;
		}

	} 
	//输入数据验证
	if ((iDesc=="")||(iCode=="")) {
		//alert("Please entry all information.");
		alert(t['Code']+","+t['Desc']+t['XMISSING']);
		if (""==iDesc) { websys_setfocus("Desc"); }
		if (""==iCode) { websys_setfocus("Code"); }
		return false;
	}  
	
	var obj=document.getElementById("AllResultShow");
	if (obj){
		if (obj.checked){ iAllResultShow="Y"; }
		else{ iAllResultShow="N"; }
	}

	var Instring=trim(iRowId)			// 1 记录编码  
				+"^"+trim(iCode)		// 2 站点编码
				+"^"+trim(iDesc)		// 3 站点描述(名称)
				+"^"+trim(iPlace)		// 4 站点所在位置
				+"^"+trim(iSequence)	// 5 顺序
				+"^"+trim(iActive)		// 6 激活
				+"^"+trim(iAutoAudit)   // 7 自动提交 
				+"^"+trim(iLayoutType)		// 8 界面类型
				+"^"+trim(iButtonType)   // 9 按钮类型 
				+"^"+trim(iReportSequence)   // 9 按钮类型 
				+"^"+trim(iAllResultShow)
				; 
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)

	if (""==iRowId) { //插入操作
		var Data=flag.split("^");
		flag=Data[0];
	}

	if (flag=='0') {}
	else if ('-119'==flag) {
		//alert("'编码'或'描述'重复!!!");
		alert(t['Code']+","+t['Desc']+t['Err 02']);
	}else if ('-120'==flag) {
		
		alert("该编码已存在");
	}else{
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
	}
	
	//刷新页面
	location.reload(); 
}

function Delete_click() {

	var iRowId="";

	var obj=document.getElementById("RowID");
	if (obj){ iRowId=obj.value; }

	if (iRowId=="")	{
		//alert("Please select the row to be deleted.");
		alert(t['03']);
		return false
	} 
	else{ 
		//if (confirm("Are you sure delete it?")){
		if (confirm(t['04'])) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value; } 
			else {var encmeth=''; };

			var flag=cspRunServerMethod(encmeth,'','',iRowId)
			if (flag=='0') {}
			else{
				//alert("Delete error.ErrNo="+flag)
				alert(t['05']+flag)
			}
		location.reload();
		}
	}
}

function FromTableToItem(Dobj,Sobj,selectrow) {

	var SelRowObj;
	var obj;
	var LabelValue="";

	SelRowObj=document.getElementById(Sobj+'z'+selectrow);
	if (!(SelRowObj)) { return null; }
	LabelValue=SelRowObj.tagName.toUpperCase();
   	obj=document.getElementById(Dobj);
   	if (!(obj)) { return null; }
   	
   	if ("LABEL"==LabelValue) {		
		obj.value=trim(SelRowObj.innerText);
		return obj;
	}
	
	if ("INPUT"==LabelValue) {
		LabelValue=SelRowObj.type.toUpperCase();
		
		if ("CHECKBOX"==LabelValue) {
			obj.checked=SelRowObj.checked;
			return obj;
		}
		
		if ("HIDDEN"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}
		
		if ("TEXT"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}

		obj.value=SelRowObj.type+trim(SelRowObj.value);
		return obj;
	}

}

function ShowCurRecord(CurRecord) {
	var selectrow=CurRecord;
	//站点编码 显示
	FromTableToItem("Code","ST_Code",selectrow);  
	//站点描述(名称) 显示
	FromTableToItem("Desc","ST_Desc",selectrow);  
	//站点所在位置 显示
	FromTableToItem("Place","ST_Place",selectrow);  
	//顺序 显示
	FromTableToItem("Sequence","ST_Sequence",selectrow);  
	//激活 显示 单选框
	FromTableToItem("Active","ST_Active",selectrow);
	//自动提交 显示 单选框
	FromTableToItem("AutoAudit","ST_AutoAudit",selectrow);
	//记录编码 不显示
	FromTableToItem("RowId","ST_RowId",selectrow);
	var LayoutType="",ButtonType="",TabObj,obj;
	TabObj=document.getElementById("ST_LayoutTypez"+selectrow);
	if (TabObj) LayoutType=TabObj.innerText.split(":")[0];
	obj=document.getElementById("LayoutType");
	if (obj) obj.value=LayoutType;
	TabObj=document.getElementById("ST_ButtonTypez"+selectrow);
	if (TabObj) ButtonType=TabObj.innerText.split(":")[0];
	obj=document.getElementById("ButtonType");
	if (obj) obj.value=ButtonType;
	//报告顺序 显示
	FromTableToItem("ReportSequence","ST_ReportSequence",selectrow); 
	//总检显示所有结果
	FromTableToItem("AllResultShow","ST_AllResultShow",selectrow);

}

/*
function ShowCurRecord(CurRecord) {
	
	var selectrow=CurRecord;
	var SelRowObj;
	var obj;
	    
	//站点编码 显示	    
	SelRowObj=document.getElementById('ST_Code'+'z'+selectrow);
	obj=document.getElementById("Code");
	obj.value=trim(SelRowObj.innerText);

	//站点描述(名称) 显示
	SelRowObj=document.getElementById('ST_Desc'+'z'+selectrow);
	obj=document.getElementById("Desc");
	obj.value=trim(SelRowObj.innerText);

	//站点所在位置 显示
	SelRowObj=document.getElementById('ST_Place'+'z'+selectrow);
	obj=document.getElementById("Place");
	obj.value=trim(SelRowObj.innerText);

	//顺序 显示
	SelRowObj=document.getElementById('ST_Sequence'+'z'+selectrow);
	obj=document.getElementById("Sequence");
	obj.value=trim(SelRowObj.innerText);

	//激活 显示 单选框
	SelRowObj=document.getElementById('ST_Active'+'z'+selectrow);
	obj=document.getElementById("Active");
	obj.checked=SelRowObj.checked;

	//记录编码 不显示
	SelRowObj=document.getElementById('ST_RowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	obj.value=trim(SelRowObj.value);
}
*/

function Clear_click() {
	var obj;
	
	//站点编码 
	obj=document.getElementById("Code");
	obj.value="";

	//站点描述(名称)
	obj=document.getElementById("Desc");
	obj.value="";

	//站点所在位置
	obj=document.getElementById("Place");
	obj.value="";

	//顺序
	obj=document.getElementById("Sequence");
	obj.value="";

	//激活
	obj=document.getElementById("Active");
	obj.checked=false;

	//记录编码
	obj=document.getElementById("RowId");
	obj.value="";
	
	//报告顺序
	//obj=document.getElementById("ReportSequence");
	//obj.value="";
	
	//界面类型
	obj=document.getElementById("LayoutType");
	obj.value="";
	
	//按钮类型
	obj=document.getElementById("ButtonType");
	obj.value="";

	//总检显示所有结果
   	obj=document.getElementById("AllResultShow");
	obj.checked=false;

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
	    
	if (selectrow==CurrentSel)
	{	    
	    Clear_click();
	    CurrentSel=0;
	    return;
	}

	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);
	var obj=document.getElementById("ST_RowIdz"+CurrentSel);
	var Parref=obj.value;
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEStationLoc&ParRef="+Parref;
	parent.frames["stationloc"].location.href=lnk;
}

document.body.onload = BodyLoadHandler;