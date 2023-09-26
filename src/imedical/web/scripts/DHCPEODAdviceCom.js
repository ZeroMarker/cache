/// DHCPEODAdviceCom.js
/// 创建时间		2006.03.20
/// 创建人		xuwm
/// 主要功能		编辑体检建议
/// 对应表		DHC_PE_ODAdvice
/// 最后修改时间	
/// 最后修改人	


var CurrentSel=0;

function BodyLoadHandler() {

	var obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	
	var obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }	

	iniForm();

	}
function iniForm() {	

	var SelRowObj;
	var obj;
	var iParRef="";
	
	//当前父站点	
	SelRowObj=document.getElementById('ParRefBox');
	obj=document.getElementById("ParRef");
	if (obj) { 
		obj.value=SelRowObj.value; 
		iParRef=SelRowObj.value;
	}

	if (''==iParRef) {
	    obj=document.getElementById("ParRef_Name");
	    if (obj) { obj.value="未选择项目";}
	}
	else{ 
		SelRowObj=document.getElementById('ParRefNameBox');
	    obj=document.getElementById("ParRef_Name");
	    if (SelRowObj) { obj.value=SelRowObj.value; }
	    else { obj.value="当前项目下没有录入建议"; }
	    ShowCurRecord(1); 
	}
	
	
	SelRowObj=document.getElementById('ODSDRBox');
	obj=document.getElementById("ODS_DR");
	if (SelRowObj) { obj.value=SelRowObj.value; }
}
	

function trim(s) {
        var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
}

function Update_click() {
	
	var iParRef="", iRowI="", iChildSub="";
	var iODS_DR,iDiagnoseConclusion="", iAdviceDetail="", iUserUpdate_DR="", iDateUpdate="", iIllness="", iCommonIllness="";
    
  
	//站点编码 不为空
	var obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; } 

	var obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; } 

	var obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value; } 
	
	//对应标准
	var obj=document.getElementById("ODS_DR");
	if (obj) { iODS_DR=obj.value; }

	//诊断结论 不为空
	var obj=document.getElementById("DiagnoseConclusion");
	if (obj) { iDiagnoseConclusion=trim(obj.value); } 
  
	//建议内容
	var obj=document.getElementById("AdviceDetail");
	if (obj) { iAdviceDetail=obj.value; } 
  
	//最后修改用户编码 取页面会话参数
	//var obj=document.getElementById("UserUpdate_DR");
	//if (obj) { iUserUpdate_DR=obj.value; } 
	iUserUpdate_DR=session['LOGON.USERID'];
  
	//日期 取服务器时间
	//var obj=document.getElementById("DateUpdate");
	//if (obj){ iDateUpdate=obj.value; } 
	iDateUpdate="";
  
	//是否疾病
	var obj=document.getElementById("Illness");
	if (obj){
		if (true==obj.checked) { iIllness="1"; }
		else { iIllness="0"; }
	}  
	
	//是否常见病
	var obj=document.getElementById("CommonIllness");
	if (obj){
		if (true==obj.checked) { iCommonIllness="1"; }
		else{ iCommonIllness="0"; }
	}
	
	//输入数据验证
	if ((""==iParRef)||(""==iAdviceDetail)){
		alert("Please entry all information.");
		//alert(t['01']);
		return false;
	}  

	var Instring=trim(iParRef)+"^"+trim(iRowId)+"^"+trim(iChildSub)
				+"^"+trim(iODS_DR)+"^"+trim(iDiagnoseConclusion)+"^"+trim(iAdviceDetail)+"^"+trim(iUserUpdate_DR)+"^"+trim(iDateUpdate)+"^"+trim(iIllness)+"^"+trim(iCommonIllness);
	var Ins=document.getElementById('ClassBox');
	if (Ins) { var encmeth=Ins.value; } 
	else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	
	if ('0'==flag) {}
	else{
		alert("Insert error.ErrNo="+flag)
		//alert(t['02']+flag);
	}
	
	location.reload(); 
}

function Delete_click() {

	var iParRef="",iChildSub="";
	var obj;
	obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; }
	
	obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value; }
	
	if ((""==iParRef)||(""==iChildSub)) {
		alert("Please select the row to be deleted.");
		return false;
	} 
	else{ 
		if (confirm("Are you sure delete it?")) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) { var encmeth=Ins.value; } 
			else {var encmeth=''; };
			var flag=cspRunServerMethod(encmeth,'','',iParRef,iChildSub)
			if (flag=='0') {}
			else{ 
				alert("Delete error.ErrNo="+flag); 
			}
			
			location.reload();
		}
	}

}

//获取项目列表
function SearchOrderDetail(value) {

	var aiList=value.split("^");
	if (""==value) { return false; }
	else{
		var obj;
		Clear_click;
		//项目编码 不为空
		obj=document.getElementById("ParRef");
		obj.value=aiList[2];

		//项目名称 不为空
		obj=document.getElementById("ParRef_Name");
		obj.value=aiList[0];
	}
}


function Clear_click() {
	
	var obj;
	
	/*    
	
		//父项 项目编号
		obj=document.getElementById("ParRef");
		obj.value="";
		
		//父项 项目名称
		obj=document.getElementById("ParRef_Name");
		obj.value="";	 
	*/
	
	
	//记录编号
	//obj=document.getElementById("Rowid");
	//obj.value="";	
	
	//记录编码 
	//obj=document.getElementById("Childsub");
	//obj.value="";  
 	
 	/*
 	
	//对应标准	
	obj=document.getElementById("ODS_DR");
	obj.value="";	
		
	*/

	//诊断结论 	
	obj=document.getElementById("DiagnoseConclusion");
	obj.value="";
	
	//建议内容	
	obj=document.getElementById("AdviceDetail");
	obj.value="";		

	//最后修改用户编码	
	obj=document.getElementById("UserUpdate_DR");
	obj.value="";	
	
	//最后修改用户名称	
	obj=document.getElementById("UserUpdate_DR_Name");
	obj.value="";		

	//最后修改日期    
	obj=document.getElementById("DateUpdate");
	obj.value="";	
	
	//是否疾病 
	obj=document.getElementById("Illness");
	obj.checked=false;		
	    
	//是否常见病 
	obj=document.getElementById("CommonIllness");
	obj.checked=false;	
}	


function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;
	
	
	//项目编号
	SelRowObj=document.getElementById('ODA_ParRef'+'z'+selectrow);
	if (SelRowObj) {
		//obj=document.getElementById("ParRef");
		//obj.value=SelRowObj.value;	
	}
	else{
		//当前项目无建议
		return false;
	}
	
	//项目名称
	SelRowObj=document.getElementById('ODA_ParRef_Name'+'z'+selectrow);
	obj=document.getElementById("ParRef_Name");
	obj.value=trim(SelRowObj.innerText);

	
	//RowId数据无法传入 不处理 位置预留
	//var obj=document.getElementById("Rowid");  
	//if (obj) { iRowid=obj.value; }
	iRowid=""
	
	//记录编码
	SelRowObj=document.getElementById('ODA_ChildSub'+'z'+selectrow);
	obj=document.getElementById("ChildSub");  
	obj.value=SelRowObj.value;
	
	//对应标准
	SelRowObj=document.getElementById('ODA_ODS_DR'+'z'+selectrow);
	obj=document.getElementById("ODS_DR");
	obj.value=trim(SelRowObj.value);
         
	//诊断结论 
	SelRowObj=document.getElementById('ODA_DiagnoseConclusion'+'z'+selectrow);
	obj=document.getElementById("DiagnoseConclusion");
	obj.value=trim(SelRowObj.innerText);
    
	//建议内容
	SelRowObj=document.getElementById('ODA_AdviceDetail'+'z'+selectrow);
	obj=document.getElementById("AdviceDetail");
	obj.value=trim(SelRowObj.innerText);
    
	//最后修改用户编码  
	SelRowObj=document.getElementById('ODA_UserUpdate_DR'+'z'+selectrow);
	obj=document.getElementById("UserUpdate_DR");
	obj.value=SelRowObj.value;

	//最后修改用户名称
	SelRowObj=document.getElementById('ODA_UserUpdate_DR_Name'+'z'+selectrow);
	obj=document.getElementById("UserUpdate_DR_Name");
	obj.value=trim(SelRowObj.value);

	//最后修改更新日期
	SelRowObj=document.getElementById('ODA_DateUpdate'+'z'+selectrow);
	obj=document.getElementById("DateUpdate");
	obj.value=trim(SelRowObj.innerText);

	//是否疾病 
	SelRowObj=document.getElementById('ODA_Illness'+'z'+selectrow);
	obj=document.getElementById("Illness");
	obj.checked=SelRowObj.checked;

	//是否常见病
	SelRowObj=document.getElementById('ODA_CommonIllness'+'z'+selectrow);
	obj=document.getElementById("CommonIllness");
	obj.checked=SelRowObj.checked;
 
}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);	
	//var objtbl=document.getElementById('tDHCPEODAdviceCom');
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;

	//if (selectrow==CurrentSel)
	//{	    
	//	Clear_click()
	//	CurrentSel=0
	//	return;
	//}

	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);
}

document.body.onload = BodyLoadHandler;

