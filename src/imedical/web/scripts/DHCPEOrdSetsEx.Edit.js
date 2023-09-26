/// DHCPEPreGBaseInfo.Edit.js
/// 创建时间		2006.06.07
/// 创建人		xuwm
/// 主要功能		医嘱套功能扩展表
/// 对应表		DHC_PE_OrdSetsEx
/// 最后修改时间	
/// 最后修改人	
/// 完成
var TFORM="";
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("OrdSets_DR_Name");
	//if (obj){obj.onfocus=txtfocus;}

	//更新
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	//清除
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }

	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }

	iniForm();


}
function txtfocus()
{
    var obj;
	obj=document.getElementById("OrdSets_DR_Name");
	/*active 代表输入法为中文
	inactive 代表输入法为英文
	auto 代表打开输入法 (默认)
	disable 代表关闭输入法
	*/
if(obj.style.imeMode ==  "disabled")
{                       
	//obj.style.imeMode   =   "active"; 
//	alert(1);
//	obj.value   =   "";                      
 }
else
{                      
	//alert(2);
	obj.style.imeMode   =   "disabled";    
	//obj.value   =   "";             
}      
   alert(obj.style.imeMode);


}
function iniForm(){
	var ID=""
	var obj;
	obj=document.getElementById('TFORM');
	if (obj) { TFORM=obj.value; }
	obj=document.getElementById('ID');
	
	if (obj && ""!=obj.value) { 
		ID=obj.value;
		FindPatDetail(ID);
				
	}	

}
function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
}

function FindPatDetail(ID){
	var Instring=ID;
	var Ins=document.getElementById('GetDetail');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetPatient_Sel','',Instring);
	if (flag=='0') {
		return websys_cancel();
	}

}

//
function SetPatient_Sel(value) {
	var obj;
	Clear_click();
  
	var Data=value.split("^");
	var iLLoop=0;
	
	var iRowId=Data[iLLoop];	

	obj=document.getElementById('RowId');
	if (obj) { obj.value=iRowId; }		

	iLLoop=iLLoop+1;
	//OSE_OrdSets_DR	医嘱套
	obj=document.getElementById('OrdSets_DR');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//
	obj=document.getElementById('OrdSets_DR_Name');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	//OSE_Break	可否拆分
	obj=document.getElementById('Break');
	if (obj && "Y"==Data[iLLoop]) { obj.checked=true; }
	else { obj.checked=false; }
	iLLoop=iLLoop+1;
   	obj=document.getElementById('ShowOEItemName');
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	obj=document.getElementById('ShowBarName');
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	obj=document.getElementById('PrintOrdSets');
	if (obj && "Y"==Data[iLLoop]) { obj.checked=true; }
	else { obj.checked=false; }
	
	iLLoop=iLLoop+1;
	
	obj=document.getElementById('PatFeeType_DR_Name');
	if (obj) { obj.value=Data[iLLoop]; }
	iLLoop=iLLoop+1;
	
	obj=document.getElementById('Sex_DR_Name');
	if (obj) { obj.value=Data[iLLoop]; }
	
	iLLoop=iLLoop+1;
	
	 obj=document.getElementById('IFOLD');
	//obj=document.getElementById('IfOLD');
	if (obj && "Y"==Data[iLLoop]) { obj.checked=true; }
	else { obj.checked=false; }
			iLLoop=iLLoop+1;

	obj=document.getElementById('TarItemId');
	if (obj) { obj.value=Data[iLLoop]; }
		iLLoop=iLLoop+1;
	obj=document.getElementById('TarItem');
	if (obj) { obj.value=Data[iLLoop]; }

	return true;
}

function Update_click() {
	var iRowId="";
	var iOrdSetsDR="", iBreak="",iOEItemName="",iBarPrintName="",iPrintOrdSets="",iSex="";
	var obj;
    var TarItem="";

	//OSE_RowId
	obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }

	//OSE_OrdSets_DR	医嘱套
	obj=document.getElementById("OrdSets_DR");
	if (obj) { iOrdSetsDR=obj.value; }

	//OSE_Break	可否拆分
	obj=document.getElementById("Break");
	if (obj && obj.checked) { iBreak="Y"; }
	else { iBreak="N"; }
	
	//是否老年套餐
	obj=document.getElementById("IFOLD");
	if (obj && obj.checked) { iIFOLD="Y"; }
	else { iIFOLD="N"; }
	
	obj=document.getElementById("PrintOrdSets");
	if (obj && obj.checked) { iPrintOrdSets="Y"; }
	else { iPrintOrdSets="N"; }
      
    obj=document.getElementById("ShowOEItemName");
	if (obj) { iOEItemName=obj.value; }
	 
	obj=document.getElementById("ShowBarName");
	if (obj) { iBarPrintName=obj.value; }

 	var SpecialItem="";
 	obj=document.getElementById("PatFeeType_DR_Name");
	if (obj) { SpecialItem=obj.value; }
 	obj=document.getElementById("Sex_DR_Name");
	if (obj) { iSex=obj.value; }
	//输入数据验证
	if (""==iOrdSetsDR) {
		//alert("Please entry all information.");
		alert(t['XMISSING']);
		return false;
	}  
	obj=document.getElementById("TarItemId");
	if (obj) { TarItem=obj.value; }
 
	var Instring=trim(iRowId)
				+"^"+trim(iOrdSetsDR)	//医嘱套
				+"^"+trim(iBreak)		//可否拆分
				+"^"+trim(iPrintOrdSets)
				+"^"+trim(iOEItemName)	//导检单上显示
				+"^"+trim(iBarPrintName)		//条码打印显示
				+"^"+SpecialItem
				+"^"+iSex
				+"^"+trim(iIFOLD)
				+"^"+trim(TarItem)
				
				;
	//alert(Instring);
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	
	if (flag=='0') {
		if (""==iRowId) { iRowId="-1"; }
		
		/*var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+TFORM
				+"&ID="+iRowId
				;*/
        var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEOrdSetsEx.Edit"
				+"&ID="+iRowId
				; 

		location.href=lnk;
	}
	else if ('-119'==flag) {
		//alert("医嘱套已增加");
		alert(t['Err 01']);
		return false;	}
	else {
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']);
		return false;
	}
	
	//location.reload();
	
	return true;
}
function Delete_click() {

	var iRowID="";

	var obj=document.getElementById("RowId");
	if (obj && ""!=obj.value){ iRowID=obj.value; } else { return false;}

	if (iRowID=="")	{
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

			var flag=cspRunServerMethod(encmeth,'','',iRowID)
			/*if (flag=='0') {
				var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+TFORM
					;
				location.href=lnk;
			}*/
			if (flag=='0') {
				var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEOrdSetsEx.Edit"
					;
				location.href=lnk;
			}

			else{
				//alert("Delete error.ErrNo="+flag)
				alert(t['05']+flag)
			}
		}
	}
}
//清除输入的信息
function Clear_click() {
	var obj;	
	    
	//OSE_RowId
	obj=document.getElementById("RowId");
	if (obj) {obj.value=""; }

	//OSE_OrdSets_DR	医嘱套
	obj=document.getElementById('OrdSets_DR');
	if (obj) { obj.value=''; }

	//
	obj=document.getElementById('OrdSets_DR_Name');
	if (obj) { obj.value=''; }

	//OSE_Break	可否拆分
	obj=document.getElementById('Break');
	if (obj) { obj.checked=false; }
	//OSE_Break	可否拆分
	obj=document.getElementById('SpecialItem');
	if (obj) { obj.checked=false; }
	
	//导检单上显示
	obj=document.getElementById('ShowOEItemName');
	if (obj) { obj.value=''; }
	//条码上显示
	obj=document.getElementById('ShowBarName');
	if (obj) { obj.value=''; }
	//是否打印医嘱套
	obj=document.getElementById('PrintOrdSets');
	if (obj) { obj.checked=false; }
	//是否老年套餐
	obj=document.getElementById('IFOLD');
	if (obj) { obj.checked=false; }
	//收费项
	obj=document.getElementById('TarItem');
	if (obj) { obj.value=''; }
	//费用类型
	obj=document.getElementById('PatFeeType_DR_Name');
	if (obj) { obj.value=""; }
	//性别
	obj=document.getElementById("Sex_DR_Name");
	if (obj) { obj.value=""; }

	
}

//医嘱套
function ARCOrdSetsList(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("OrdSets_DR_Name");
		if (obj) { obj.value=aiList[0]; }


		obj=document.getElementById("OrdSets_DR");
		if (obj) { obj.value=aiList[2]; }

	}
}
function clickTaritem(value)
{
 	var aiList=value.split("^");
 	//alert(aiList);
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("TarItem");
		if (obj) { obj.value=aiList[2]; }


		obj=document.getElementById("TarItemId");
		if (obj) { obj.value=aiList[0]; }

	} 
}
document.body.onload = BodyLoadHandler;