/// DHCPEStationWaitCom.js
/// 创建时间		2006.03.22
/// 创建人		xuwm 
/// 主要功能		站点等候客户排队表(DHC_PE_Station的子表)
/// 对应表		DHC_PE_StationWait
/// 最后修改时间	
/// 最后修改人	

var CurrentSel=0
var StationWaitADMCount=0;  //站点等候人数
function BodyLoadHandler() {

	var obj=document.getElementById("Update");
	if (obj) { obj.onclick=Update_click; }
	
	var obj=document.getElementById("Delete");
	if (obj) { obj.onclick=Delete_click; }
	
	var obj=document.getElementById("Clear");
	if (obj) { obj.onclick=Clear_click; }		

	iniForm();
}  

function iniForm(){

	var SelRowObj;
	var obj;
	ShowStationWaitADMCount();
	
	SelRowObj=document.getElementById('ParRefBox');
	if (SelRowObj) {
		obj=document.getElementById("ParRef");
		if (obj) { obj.value=SelRowObj.value; }
	}
	// 测试站点
	if (""==obj.value) { obj.value="16"; }
	
	if (''==SelRowObj.value) {
		obj=document.getElementById("ParRef_Name");
		//if (obj) { obj.value="未选择站点"; }
		if (obj) { obj.value=t["06"]; }
	}else{ 
	    obj=document.getElementById("ParRef_Name");
	    //if (obj) { obj.value="当前站点没有等候人员"; }
	    if (obj) { obj.value=t["07"]; 
	    }
	    
		ShowCurRecord(1); 
	}
	
}

function Clear_click()
{       
	var obj;

	//等候人员编码
	obj=document.getElementById("IADM_DR");
	obj.value="";
	    
	//等候人员姓名
	obj=document.getElementById("IADM_DR_Name");
	obj.value="";

	/*
	//当前站点编码
	obj=document.getElementById("ParRef");
	obj.value="";	 
	       
	//当前站点名称	    
	obj=document.getElementById("ParRef_Name");
	obj.value="";
	*/
	    
	//当前记录编码
	obj=document.getElementById("ChildSub");
	obj.value="";
}
	
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (null == m) ? "" : m[1];
}	
// *******************************************************
function Update_click() {
	
	var iParRef="", iRowId="", iChildSub="";
	var iIADMDR="";
	var obj;

	//等候人员编码
	obj=document.getElementById("IADM_DR");
	if (obj){iIADMDR=obj.value; } 
 
  	//当前站点编码
	obj=document.getElementById("ParRef");  
	if (obj){iParRef=obj.value; }
  
	//RowId数据无法传入 不处理 位置预留
	//var obj=document.getElementById("Rowid");  
	//if (obj){iRowid=obj.value; }
	iRowid=""
   
	obj=document.getElementById("ChildSub");  
	if (obj){iChildSub=obj.value; }

	if (""==iIADMDR){
		alert("Please entry all information.");
		//alert(t['01']);
		return false;
	}  
  
	if (""==iParRef){ alert("无效站点"); }

	if (""!=iChildSub){
		//alert("对不起,不能修改等候人员列表");
		alert(t["Err 06"]);
		return false;
	}
	
	var Instring=trim(iParRef)+"^"+trim(iRowId)+"^"+trim(iChildSub)+"^"+trim(iIADMDR);
	
	var Ins=document.getElementById('ClassBox');
	if (Ins) { var encmeth=Ins.value; } 
	else{ var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	
	if ('0'==flag) {
		location.reload();
	}
	else if ('-104'==flag) {
		//alert('所引用的父表记录不存在');
		alert(t["Err 07"]);
	}
	else if ('Err 05'==flag) {
		//alert('受检人已在当前站点等候');
		alert(t["Err 05"]);
	}		
	else{
		//alert("Insert error.ErrNo="+flag)
		alert(t['02']+flag);
	}

	
}

function Delete_click(){

	var iParRef="", iChildSub=""
	var obj;

	obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; }

	obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value }

	if ((""==iParRef)||(""==iChildSub)){
		//alert("Please select the row to be deleted.");
		alert(t['03']);
		return false;
	} 
	else{ 
		//if (confirm("Are you sure delete it?")) {
		if (confirm(t['04'])) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) {var encmeth=Ins.value; } 
			else { var encmeth=''; }
			var flag=cspRunServerMethod(encmeth,'','',iParRef,iChildSub)
			if ('0'==flag) {}
			else{
				//alert("Delete error.ErrNo="+flag)
				alert(t['05']+flag);
			}
			location.reload();
		}
	}
}

function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;	

	//等候人员编码	 
	SelRowObj=document.getElementById('STW_IADM_DR'+'z'+selectrow);	
	obj=document.getElementById("IADM_DR");
	obj.value=SelRowObj.value;

	//等候人员姓名
	SelRowObj=document.getElementById('STW_IADM_DR_Name'+'z'+selectrow);
	obj=document.getElementById("IADM_DR_Name");
	obj.value=trim(SelRowObj.innerText);
	
	//当前站点编码
	SelRowObj=document.getElementById('STW_ParRef'+'z'+selectrow);	
	obj=document.getElementById("ParRef");
	obj.value=trim(SelRowObj.value);

	//当前站点名称	 
	SelRowObj=document.getElementById('STW_ParRef_Name'+'z'+selectrow);
	obj=document.getElementById("ParRef_Name");
	obj.value=trim(SelRowObj.value);	
	
   
	//RowId 数据形式是 OD_ParRef||OD_ChildSub 有双引号无法?此参数无法传 
	//SelRowObj=document.getElementById('OD_RowId'+'z'+selectrow);
	//obj=document.getElementById("RowId");
	//obj.value=SelRowObj.value;

	SelRowObj=document.getElementById('STW_Childsub'+'z'+selectrow);
	obj=document.getElementById("ChildSub");
	obj.value=SelRowObj.value;	
}
	
// 显示当前站点的等候人数
function ShowStationWaitADMCount() {

	var obj=document.getElementById("TFORM");
	if (obj){ tForm="t"+obj.value; }

	var objtbl=document.getElementById(tForm);

	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;

	StationWaitADMCount=lastrowindex;

	var obj=document.getElementById("cStationWaitConut");
	if (obj){ obj.innerText=StationWaitADMCount; }
	
}
	
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm="t"+obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;

		
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	
	if (selectrow==CurrentSel){

	    Clear_click()  
	    CurrentSel=0
	    return;
	}
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;
// /////////////////////////////////////////////////////////////////////////////
//容许更改要更新?插入?的站点 
function SearchStation(value){
	
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
		
		Clear_click();
		
		//当前站点编码
		obj=document.getElementById("ParRef");
		obj.value=aiList[2];

		//当前站点名称	    
		obj=document.getElementById("ParRef_Name");
		obj.value=aiList[0];
	}
}

// ***************************************************
//获取体检人员
function SearchIADM(value){

	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
		Clear_click();
	
		//患者体检编码
		obj=document.getElementById("IADM_DR");
		if (obj) { obj.value=aiList[2]; }

		//患者名称	    
		obj=document.getElementById("IADM_DR_Name");
		if (obj) { obj.value=aiList[0]; }
		
		//登记号    
		obj=document.getElementById("RegNo");
		if (obj) { obj.value=aiList[1]; }
		
		//登记号    
		obj=document.getElementById("PatName");
		if (obj) { obj.value=aiList[0]; }		
		
	}
}


