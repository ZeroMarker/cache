/// DHCPEODStdNumCom.js
/// 创建时间		2006.03.21
/// 创建人		xuwm 
/// 主要功能		体检标准?数值? DHC_PE_ OrderDetail的子表
/// 对应表		DHC_PE_ODStdNum
/// 最后修改时间	
/// 最后修改人	

var CurrentSel=0
function BodyLoadHandler() {

	var obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click;}
	
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}
	
	var obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click;}

	//适用性别 
	var obj=document.getElementById("Sex_N");
	if (obj){ obj.onclick=Sex_click; }
	var obj=document.getElementById("Sex_M");
	if (obj){ obj.onclick=Sex_click; }	
	var obj=document.getElementById("Sex_F");
	if (obj){ obj.onclick=Sex_click; }	
	
	iniForm();

	}

function iniForm() {	
	var SelRowObj;
	var obj;
	
	Clear_click();
	
	//获取页面父项目编码
	SelRowObj=document.getElementById('ParRefBox');
	obj=document.getElementById("ParRef");
	obj.value=SelRowObj.value;
	
	if (''==SelRowObj.value){
	    obj=document.getElementById("ParRef_Name");
	    obj.value="未选择站点";  	    		
	}else{		
	    //显示默认(第一条)记录
		ShowCurRecord(1);
	}		
}

function trim(s) {
        var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
}
 
//获取细项表
function SearchDetailList(value){
	//当选择一个项目时 默认要增加一个新的参考
	
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
		
		Clear_click();	
		
		//获取新的项目编号
		obj=document.getElementById("ParRef");
		obj.value=aiList[0];
		
		//获取新的项目名称
		obj=document.getElementById("ParRef_Name");
		obj.value=aiList[1];

	}
}

function Update_click(){
	 
	var iParRef="", iRowId="", iChildSub="";
	var iMin="",iMax="", iValue="", iNaturalValue="", iSex="", iUnitDR="";
  
	var obj;
	
	obj=document.getElementById("ParRef");  
	if (obj) { iParRef=obj.value; }

	//RowId数据无法传入 不处理 位置预留
	//var obj=document.getElementById("Rowid");  
	//if (obj){ iRowid=obj.value; }
	iRowid="";  
  
	obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value; } 
	
	//判断下限
	obj=document.getElementById("Min");
	if (obj) { iMin=obj.value; } 
	
	//判断上限
	obj=document.getElementById("Max");
	if (obj) { iMax=obj.value; } 
	
	//判断结果(结论)
	obj=document.getElementById("Value");
	if (obj) { iValue=obj.value; }  
	
	//是否正常值 1 是正常(对一个项目来说 只有一个正常参考)
	obj=document.getElementById("NaturalValue");
	if (obj) {
		if (true==obj.checked){ iNaturalValue="1"; }
		else{ iNaturalValue="0"; }
	}   
	
	//适用性别
	//obj=document.getElementById("Sex");  
	//if (obj){ iSex=obj.value; }
		iSex=GetSex(); 
	
	//单位编码
	obj=document.getElementById("Unit_DR_Name"); 
	//obj=document.getElementById("Unit_DR");
	if (obj){ iUnitDR=obj.value; } 
  
	//数据验证
	if (""==iParRef) {
		alert("Please entry all information.");
		//alert(t['01']);
		return false;
	}  

	var Instring=trim(iParRef)+"^"+trim(iRowId)+"^"+trim(iChildSub)+"^"+trim(iMin)+"^"+trim(iMax)+"^"+trim(iValue)+"^"+trim(iNaturalValue)+"^"+trim(iSex)+"^"+trim(iUnitDR);

	var Ins=document.getElementById('ClassBox');
	if (Ins) { var encmeth=Ins.value; } 
	else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring);
	
	if ('0'==flag) {}
	else{
		alert("Insert error.ErrNo="+flag)
		//alert(t['02']+flag);
	}
	
	location.reload(); 
}

function Delete_click() {
	
	var iParRef="", iChildSub="";
	var obj;
	
	//项目编码
	obj=document.getElementById("ParRef");
	if (obj){ iParRef=obj.value; }
	
	//当前记录编码
	obj=document.getElementById("ChildSub");
	if (obj){ iChildSub=obj.value; }

	if ((""==iParRef)||(""==iChildSub)){
		alert("Please select the row to be deleted.");
		return false
	}
	else { 
		if (confirm("Are you sure delete it?")){
			var Ins=document.getElementById('DeleteBox');
			
			if (Ins) {var encmeth=Ins.value} 
			else { var encmeth=''; };
			var flag=cspRunServerMethod(encmeth,'','',iParRef,iChildSub);
			
			if (flag=='0') {}
			else{
				alert("Delete error.ErrNo="+flag)
			}
			
			location.reload();
		}
	}
   
}

//显示当前记录属性
function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;
	
	// --------------------------------------------------------------
	
	//项目名称
	SelRowObj=document.getElementById('ODSN_ParRef_Name'+'z'+selectrow);
	obj=document.getElementById("ParRef_Name");
	obj.value=SelRowObj.value;   
	 
	//项目编码
	SelRowObj=document.getElementById('ODSN_ParRef'+'z'+selectrow);
	obj=document.getElementById("ParRef");
	obj.value=SelRowObj.value;
	
	// --------------------------------------------------------------
		
	//结果下限
	SelRowObj=document.getElementById('ODSN_Min'+'z'+selectrow);
	obj=document.getElementById("Min");
	obj.value=trim(SelRowObj.innerText);
	
	//结果上限
	SelRowObj=document.getElementById('ODSN_Max'+'z'+selectrow);
	obj=document.getElementById("Max");
	obj.value=trim(SelRowObj.innerText);

	//判断结果(结论)
	SelRowObj=document.getElementById('ODSN_Value'+'z'+selectrow);
	obj=document.getElementById("Value");
	obj.value=trim(SelRowObj.innerText);

	//是否正常值
	SelRowObj=document.getElementById('ODSN_NaturalValue'+'z'+selectrow);
	obj=document.getElementById("NaturalValue");
	obj.checked=SelRowObj.checked;

	//适用性别
	SelRowObj=document.getElementById('ODSN_Sex'+'z'+selectrow);
	obj=document.getElementById("Sex");
	obj.value=trim(SelRowObj.innerText);
		SetSex("");	
		SetSex(trim(SelRowObj.innerText));
			
	//单位编码
	SelRowObj=document.getElementById('ODSN_Unit_DR'+'z'+selectrow);
	obj=document.getElementById("Unit_DR");
	obj.value=trim(SelRowObj.innerText);
	
	//单位名称
	SelRowObj=document.getElementById('ODSN_Unit_DR_Name'+'z'+selectrow);
	obj=document.getElementById("Unit_DR_Name");
	obj.value=trim(SelRowObj.innerText);

	//记录编码
	SelRowObj=document.getElementById('ODSN_RowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	obj.value=SelRowObj.value;

	//记录编号
	SelRowObj=document.getElementById('ODSN_ChildSub'+'z'+selectrow);
	obj=document.getElementById("ChildSub");
	obj.value=SelRowObj.value;

}
			

function Clear_click() {
	var obj="";
	
	/*
	//项目编码
	obj=document.getElementById("ParRef");
	obj.value="";
	
	//项目名称
	obj=document.getElementById("ParRef_Name");
	obj.value="";
	*/
	
	//记录编码
	obj=document.getElementById("Rowid");
	obj.value="";

	//记录编号
	obj=document.getElementById("ChildSub");
	obj.value="";

	//结果下限	
	obj=document.getElementById("Min");
	obj.value="";
	
	//结果上限
	obj=document.getElementById("Max");
	obj.value="";	
	
	//判断结果(结论)	    
	obj=document.getElementById("Value");
	obj.value="";	   
	
	//是否正常值
	obj=document.getElementById("NaturalValue");
	obj.checked=false;
	
	//适用性别
	//obj=document.getElementById("Sex");
	//obj.value="N";	
		SetSex("");
		SetSex("N");	
	
	//单位编码	
	obj=document.getElementById("Unit_DR");
	obj.value="";
	
	//单位名称	
	obj=document.getElementById("Unit_DR_Name");
	obj.value="";	    
	    
}
function SelectRowHandler() {
	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);	
	//var objtbl=document.getElementById('tDHCPEODStdNumCom');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	
	if (selectrow==CurrentSel) {	    

	    Clear_click();     
	    CurrentSel=0;
	    return;
	}

	CurrentSel=selectrow;
	
	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;

// **************  对性别特殊处理   ********************
function GetSex() {	
	var obj;

	obj=document.getElementById("Sex_M");
	if (obj){ if (obj.checked) { return "M"; } }
	
	obj=document.getElementById("Sex_F");
	if (obj){ if (obj.checked) { return "F"; } }
	
	obj=document.getElementById("Sex_N");
	if (obj){ if (obj.checked) { return "N"; } }
	
}

function SetSex(value) {
	
	var obj;
	
	if (""==value) {		 		
		obj=document.getElementById("Sex_N");
		if (obj){ obj.checked=false; }
		obj=document.getElementById("Sex_M");
		if (obj){ obj.checked=false; } 
		obj=document.getElementById("Sex_F");
		if (obj){ obj.checked=false; } 
		return false;				
	}	
	if ("M"==value) {
		
		obj=document.getElementById("Sex_M");
		if (obj){ obj.checked=true; }  
	}
	else {
		if ("F"==value) {
		obj=document.getElementById("Sex_F");
		if (obj){ obj.checked=true; }  
		}
		else {
			if ("N"==value) {
				obj=document.getElementById("Sex_N");
				if (obj){ obj.checked=true; } 
			}
			else{
				obj=document.getElementById("Sex_N");
				if (obj){ obj.checked=true; }  			
			}
		}
	}  
}
function Sex_click() {
	var obj;

	srcElement = window.event.srcElement;
	
	SetSex("");
	
	obj=srcElement;
	obj.checked=true;
}
