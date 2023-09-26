/// DHCPEODStandardCom.js
/// 创建时间		2006.03.21
/// 创建人		xuwm 
/// 主要功能		体检标准(DHC_PE_ OrderDetail的子表)
/// 对应表		DHC_PE_ODStandard
/// 最后修改时间	
/// 最后修改人	

var CurrentSel=0
var FOrderDetailType=""	//当前项目类型

function BodyLoadHandler() {
   
	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click;}

	
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}
	
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click;}
	
    obj=document.getElementById("TemplateSet");
	if (obj){ obj.onclick=TemplateSet_click;}
	
	  
	
	//适用性别 
	obj=document.getElementById("Sex_N");
	if (obj){ obj.onclick=Sex_click; }
	obj=document.getElementById("Sex_M");
	if (obj){ obj.onclick=Sex_click; }	
	obj=document.getElementById("Sex_F");
	if (obj){ obj.onclick=Sex_click; }	

	obj=document.getElementById('AgeMin');
	if (obj) {obj.onkeydown = keydown;}

	obj=document.getElementById('AgeMax');
	if (obj) {obj.onkeydown = keydown;}
	
	obj=document.getElementById('Min');
	if (obj) {obj.onkeydown = keydown;}	
	
	obj=document.getElementById('Max');
	if (obj) {obj.onkeydown = keydown;}
	iniForm();
}

function iniForm() {
		
	var SelRowObj;
	var obj;
	
	//项目类型
	SelRowObj=document.getElementById('OrderDetailTypeBox');
	if (SelRowObj) { 
		FOrderDetailType=SelRowObj.value; 
		SetOrderDetailType(FOrderDetailType);
	}

	Clear_click();

	//获取当前页面父项目编号
	//SelRowObj=document.getElementById('ParRefBox');
	//obj=document.getElementById("ParRef");
	//if (SelRowObj && obj) {
	//	obj.value=SelRowObj.value;
	//}

	//if (''==SelRowObj.value){
	//    obj=document.getElementById("ParRef_Name");
	//    obj.value="当前站点没有项目";  	    		
	//}
	//else{

		//SelRowObj=document.getElementById('ParRefNameBox');
	    //obj=document.getElementById("ParRef_Name");
	    //if (SelRowObj && obj) {
		//    obj.value=SelRowObj.value; 
	    //}

		//显示第一条记录	
		//ShowCurRecord(1);
		
	//}

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

//验证是否为正确年龄
function IsValidAge(Value) {
	
	if(""==trim(Value) || "0"==Value) { 
		//容许为空
		return true; 	
	}
	if (!(IsFloat(Value))) { return false; }
	
	if ((Value>0)&&(Value<120)) {
		return true; 
	}
}

// ************************************************************************

function keydown(e) {	

	var key;
	key=websys_getKey(e);
	
	if ((key==13)||(key==9)) {
	}else{
		var eSrc=window.event.srcElement;
		if (eSrc) { eSrc.className=''; }	
	}

}

function TemplateSet_click(){
	var obj;
   obj=document.getElementById("RowId");
	if (obj){var ID=obj.value; }
	else{return false;}
	if (ID=="") 
	{
		alert("请先选择要维护模板的细项选择记录");
		return false;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPETemplateSet&TextValID="+ID;
	var wwidth=300;
	var wheight=700;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	return false;    //LIKE形式的返回值为false
	                 //菜单连接形式的返回值为TRUE        
}
	
	
	
function Update_click() { 
         
	var iParRef="", iRowId="", iChildSub="";
	var iSex="", iAgeMin="", iAgeMax="", iTextVal="",iUnit="",iMin="",iMax="",iNaturalValue=""
		iTemplate="" 
	var iSummary="",iEyeSee=""
	var iHDValue="N";	
	var iNoPrint="N";
	var obj;
	
	obj=document.getElementById("ParRef");  
	if (obj) { iParRef=obj.value; }

	//RowId数据无法传入 不处理 位置预留
	//var obj=document.getElementById("Rowid");  
	//if (obj) { iRowid=obj.value; }
	iRowid="";
	  
	//标准编号
	obj=document.getElementById("ChildSub");  
	if (obj) { iChildSub=obj.value; }
			
	//性别
	//obj=document.getElementById("Sex");  
	//if (obj){ iSex=obj.value; }
	iSex=GetSex(); 
	
	//年龄下限
	obj=document.getElementById("AgeMin");  
	if (obj){ 
		iAgeMin=obj.value; 
		if (IsValidAge(iAgeMin)){}
		else { 
			obj.className='clsInvalid';			
			//alert("年龄下限错误!!!"); 
			alert(t['Err 03']);
			return false;
		}
	}		

	//年龄上限
	obj=document.getElementById("AgeMax");  
	if (obj){ 
		iAgeMax=obj.value; 
		if (IsValidAge(iAgeMax)){}
		else {
			obj.className='clsInvalid'; 			
			//alert("年龄上限错误!!!"); 
			alert(t['Err 04']);
			return false;
		}
	}
		
	//文本值
	obj=document.getElementById("TextVal");  
	if (obj){ iTextVal=obj.value; }	

	//单位编码
	obj=document.getElementById("Unit");
	if (obj) { iUnit=obj.value; } 

	//判断下限
	obj=document.getElementById("Min");
	if (obj) { iMin=obj.value; } 

	if (!(IsFloat(iMin))) {
		obj.className='clsInvalid'; 
		//alert("参考值下限值输入错误");
		alert(t['Err 01']);
		return false;
	}

	//判断上限
	obj=document.getElementById("Max");
	if (obj) { iMax=obj.value; }
	if (!(IsFloat(iMax))) {
		obj.className='clsInvalid';
		//alert("参考值上限值输入错误");
		alert(t['Err 02']);
		return false;
	}

	//是否正常值 1 是正常(对一个项目来说 只有一个正常参考)
	obj=document.getElementById("NatureValue");
	if (obj) {
		if (true==obj.checked){ iNaturalValue="Y"; }
		else{ iNaturalValue="N"; }	
	}  

	// ODS_Template	模版
	obj=document.getElementById("Template");  
	if (obj){ iTemplate=obj.value; }	
	
	
	//是否进入小结 
	
	obj=document.getElementById("Summary");
	if (obj) {
		if (true==obj.checked){ iSummary="Y"; }
		else{ iSummary="N"; }	
	}  
 
	
	if ("T"==FOrderDetailType || "S"==FOrderDetailType) {
	    //输入数据验证
		if (""==iTextVal) {
		obj=document.getElementById("TextVal")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("文本值不能为空");
		return false;
	 }

		
		/*if (""==iTextVal) {
			//alert("Please entry all information.");
			alert(t['01']);
			return false;
		
		}*/
	}
	else{
		
		if ((""==iMax)&&(""==iMin)&&(""==iUnit)) {
			//alert("Please entry all information.");
			//alert(t['01']);
			alert("参考范围一栏不能为空");
			return false;
		}	
	}


  
    	//是否为高危数据
	var iHighRiskFlag=""
	obj=document.getElementById("HighRiskFlag");
	if (obj) {
		if (true==obj.checked){ iHighRiskFlag="Y"; }
		else{ iHighRiskFlag="N"; }	
	} 
	obj=document.getElementById("EyeSee");
	if (obj) iEyeSee=obj.value;
	
	obj=document.getElementById("HDValue");
	if (obj&&obj.checked) {
		iHDValue="Y";	
	}
	
	obj=document.getElementById("NoPrint");
	if (obj&&obj.checked) {
		iNoPrint="Y";	
	}

	var Instring = trim(iParRef)		// 1	
				+"^"+trim(iRowId)		// 2
				+"^"+trim(iChildSub)	// 3 
				+"^"+trim(iTextVal)		// 4 
				+"^"+trim(iUnit)		// 5
				+"^"+trim(iSex)			// 6 
				+"^"+trim(iMin)			// 7 
				+"^"+trim(iMax)			// 8 				
				+"^"+""					// 9 
				+"^"+trim(iNaturalValue)// 10
				+"^"+trim(iAgeMin)		// 11 
				+"^"+trim(iAgeMax)		// 12 
				+"^"+trim(iTemplate)	// 13 
	      		+"^"+trim(iSummary)
				+"^"+trim(iNoPrint)
	      		+"^"+""
	      		+"^"+trim(iHighRiskFlag)    //add
	      		+"^"+trim(iEyeSee)
	      		+"^"+trim(iHDValue)
		;
    
	var obj=document.getElementById("ODS_NatureValuez"+CurrentSel);
	if (obj&&obj.checked){var ODSNatureValue="Y"; } 
	else{var ODSNatureValue="N"; }
	
	var ret=tkMakeServerCall("web.DHCPE.ODStandard","GetODSNatureValue",iParRef,iRowId);
	if((ODSNatureValue=="N")&&(iNaturalValue=="Y")&&(ret=="1"))
	 {
	   alert("正常值已设置,不能重复设置");
	    return false;
    
	}

	var Ins=document.getElementById('ClassBox');
	
	if (Ins) { var encmeth=Ins.value; } 
	else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'','',Instring);
	
	if ('0'==flag) {}
	else{
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
	}
	
	location.reload(); 

}

function Delete_click() {

	var iParRef="", iChildSub="";

	var obj;
	
	//项目编码
	obj=document.getElementById("ParRef");
	if (obj){ iParRef=obj.value; }
	
	//当前标准编码
	obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value; }
	
	if ((""==iParRef)||(""==iChildSub)){
		//alert("Please select the row to be deleted.");
		alert(t['03']);
		return false;
	}
	else{ 
		//if (confirm("Are you sure delete it?")) {
		if (confirm(t['04'])) {	
			var Ins=document.getElementById('DeleteBox');
			if (Ins) { var encmeth=Ins.value; } 
			else { var encmeth=''; }
			var flag=cspRunServerMethod(encmeth,'','',iParRef,iChildSub);
			
			if (flag=='0') {}
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
	
	//取页面参数
	SelRowObj=document.getElementById('ODS_ParRef'+'z'+selectrow);
	obj=document.getElementById("ParRef");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }

	//项目名称
	SelRowObj=document.getElementById('ODS_ParRef_Name'+'z'+selectrow);
	obj=document.getElementById("ParRef_Name");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }

	//当前记录编号
	SelRowObj=document.getElementById('ODS_RowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }

	//当前记录编码
	SelRowObj=document.getElementById('ODS_ChildSub'+'z'+selectrow);
	obj=document.getElementById("ChildSub");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }

	// ----------------------------------------------------------------
	
	//适用性别 M-男,F-女,N-不限
	SelRowObj=document.getElementById('ODS_Sex'+'z'+selectrow);
	obj=document.getElementById("Sex");
	if (SelRowObj && obj) { 
		SetSex("");	
		SetSex(trim(SelRowObj.innerText));	
	}
	
	//年龄下限
	SelRowObj=document.getElementById('ODS_AgeMin'+'z'+selectrow);
	obj=document.getElementById("AgeMin");
	if (SelRowObj && obj) { 
		obj.value=trim(SelRowObj.innerText);	
		obj.className=''; 
	}
	
	//年龄上限
	SelRowObj=document.getElementById('ODS_AgeMax'+'z'+selectrow);
	obj=document.getElementById("AgeMax");
	if (SelRowObj && obj) { 
		obj.value=trim(SelRowObj.innerText);
		obj.className=''; 
	}
	
	//判断结果(结论)
	SelRowObj=document.getElementById('ODS_TextVal'+'z'+selectrow);
	obj=document.getElementById("TextVal");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }

	//单位
	SelRowObj=document.getElementById('ODS_Unit'+'z'+selectrow);
	obj=document.getElementById("Unit");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }

	//结果下限
	SelRowObj=document.getElementById('ODS_Min'+'z'+selectrow);
	obj=document.getElementById("Min");
	if (SelRowObj && obj) { 
		obj.value=trim(SelRowObj.innerText);
		obj.className=''; 
	}

	//结果上限
	SelRowObj=document.getElementById('ODS_Max'+'z'+selectrow);
	obj=document.getElementById("Max");
	if (SelRowObj && obj) {		
		obj.value=trim(SelRowObj.innerText);
		obj.className='';
	}
	
	//是否正常值
	SelRowObj=document.getElementById('ODS_NatureValue'+'z'+selectrow);
	if (SelRowObj && obj) { 
		obj=document.getElementById("NatureValue");
		obj.checked=SelRowObj.checked;	
	}
	
	// ODS_Template	模版
	SelRowObj=document.getElementById('ODS_Template'+'z'+selectrow);
	obj=document.getElementById("Template");
	if (SelRowObj && obj) {		
		obj.value=trim(SelRowObj.innerText);
		obj.className='';
	}	
	// ODS_Summary 是否进入小结
	SelRowObj=document.getElementById('ODS_Summary'+'z'+selectrow);
	if (SelRowObj && obj) {	
	  obj=document.getElementById("Summary");	
		obj.checked=SelRowObj.checked;
	}	
		//HighRiskFlag	
	SelRowObj=document.getElementById('ODS_HighRiskFlag'+'z'+selectrow);
	obj=document.getElementById("HighRiskFlag");
	if (SelRowObj && obj) {		
	  obj.checked=SelRowObj.checked;
	}
	
	//单位
	SelRowObj=document.getElementById('TEyeSee'+'z'+selectrow);
	obj=document.getElementById("EyeSee");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }
	
	SelRowObj=document.getElementById('THDValue'+'z'+selectrow);
	obj=document.getElementById("HDValue");
	if (SelRowObj && obj) {		
	  obj.checked=SelRowObj.checked;
	}
	
	SelRowObj=document.getElementById('TNoPrint'+'z'+selectrow);
	obj=document.getElementById("NoPrint");
	if (SelRowObj && obj) {		
	  obj.checked=SelRowObj.checked;
	}

	
}
	
	
			

function Clear_click() {
	
	var obj;
	
	/*
	obj=document.getElementById("ParRef");
	obj.value="";
	
	obj=document.getElementById("ParRef_Name");
	obj.value="";	
	*/


	obj=document.getElementById("Rowid");
	if (obj) { obj.value=""; }

	obj=document.getElementById("ChildSub");
	if (obj) { obj.value=""; }
	
	//适用性别
	//obj=document.getElementById("Sex");
	//obj.value="N";	
		SetSex("");
		SetSex("N");

	//年龄下限 
	obj=document.getElementById("AgeMin");
	if (obj) { 
		obj.value=""; 
		obj.className=''; 
	}

	//年龄上限   
	obj=document.getElementById("AgeMax");
	if (
		obj) { obj.value=""; 
		obj.className=''; 
	}

	//文本值   
	obj=document.getElementById("TextVal");
	if (obj) { obj.value=""; }
	
	//单位	
	obj=document.getElementById("Unit");
	if (obj) { obj.value=""; }
	
	//结果下限	
	obj=document.getElementById("Min");
	if (obj) { 
		obj.value=""; 
		obj.className=''; 
	}
	
	//结果上限
	obj=document.getElementById("Max");
	if (obj) { 
		obj.value=""; 
		obj.className=''; 
	}
	
	//是否正常值                   
	obj=document.getElementById("NatureValue");
	if (obj) { obj.checked=false; }
	
	
	// ODS_Template	模版
	obj=document.getElementById("Template");
	if (obj) { 
		obj.value=""; 
		obj.className=''; 
	}
	obj=document.getElementById("EyeSee");
	if (obj) obj.value="";
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
	    
	if (selectrow==CurrentSel) {	    

		Clear_click();     
		CurrentSel=0;
		return;
	}
	
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;

// ***********************************************************
//根据项目类型 设置显示元素
function SetOrderDetailType(OrderDetailType) {

	//结果类型 说明型
	if ('T'==OrderDetailType) {
/*		
		document.all["Max"].disabled=true;
		//document.all["cMax"].disabled=true; 
		document.all["Min"].disabled=true; 
		//document.all["CMin"].disabled=true; 
		document.all["Unit"].disabled=true; 		
		//document.all["cUnit"].disabled=true; 
		document.all["cLabel_2"].disabled=true; 
		document.all["cLabel_3"].disabled=true; 
*/
		//结果上限
		obj=document.getElementById("Max");
		if (obj) { obj.style.display = "none"; }
		obj=document.getElementById("cMax");
		if (obj) { obj.style.display = "none"; }
		
		//结果下限
		obj=document.getElementById("Min");
		if (obj) { obj.style.display = "none"; }
		obj=document.getElementById("cMin");
		if (obj) { obj.style.display = "none"; }
		
		//单位
		obj=document.getElementById("Unit");
		if (obj) { obj.style.display = "none"; }
		obj=document.getElementById("cUnit");
		if (obj) { obj.style.display = "none"; }

		//obj=document.getElementById("cLabel_1");
		//if (obj) { obj.style.display = "none"; }

		obj=document.getElementById("cLabel_2");
		if (obj) { obj.style.display = "none"; }
		
		obj=document.getElementById("cLabel_3");
		if (obj) { obj.style.display = "none"; }

	}
	
	else{//结果类型 数值型
	
/*
		document.all["Max"].disabled=false; 
		//document.all["cMax"].disabled=false; 
		document.all["Min"].disabled=false; 
		//document.all["CMin"].disabled=false; 
		document.all["Unit"].disabled=false; 
		//document.all["cUnit"].disabled=false; 
		document.all["cLabel_2"].disabled=false; 
		document.all["cLabel_3"].disabled=false; 


*/
		//结果上限
		obj=document.getElementById("Max");
		if (obj) { obj.style.display = "inline"; }
		obj=document.getElementById("cMax");
		if (obj) { obj.style.display = "inline"; }
		
		//结果下限
		obj=document.getElementById("Min");
		if (obj) { obj.style.display = "inline"; }
		obj=document.getElementById("cMin");
		if (obj) { obj.style.display = "inline"; }
		
		//单位
		obj=document.getElementById("Unit");
		if (obj) { obj.style.display = "inline"; }
		obj=document.getElementById("cUnit");
		if (obj) { obj.style.display = "inline"; }

		//obj=document.getElementById("cLabel_1");
		//if (obj) { obj.style.display = "inline"; }
		
		obj=document.getElementById("cLabel_2");
		if (obj) { obj.style.display = "inline"; }
		
		obj=document.getElementById("cLabel_3");
		if (obj) { obj.style.display = "inline"; }	

	}
}

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
/*
// ********************************************************************
// 编辑 标本的建议
function AdviceEdit_click() { 
	var lnk="";
	var iParRef="";
	var iODSDR="";	
	var iODSDRName="";
	var obj;
	
	obj=document.getElementById("ParRef");
	iParRef=obj.value;
	
	obj=document.getElementById("Rowid");
	iODSDR=obj.value;
	
	obj=document.getElementById("ParRef_Name");
	iODSDRName=obj.value;
	    	
	lnk = "websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEODAdviceCom"
			+"&ParRef="+iParRef
			+"&ODSDR="+iODSDR
			+"&ParRefName="+iODSDRName					
			;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0';

	window.open(lnk,"_blank",nwin)

}

*/


/*
// ***********************************************************************
// 获取单位
function SearchUOM(value) {
		
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
	
		//项目编码
		obj=document.getElementById("Unit_DR_Name");
		obj.value=aiList[0];
		
		//项目名称
		obj=document.getElementById("Unit_DR");
		obj.value=aiList[2];

	}
}
*/


/*
//获取细项表
function SearchOrderDetail(value) {

	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
		//当选择一个项目时?默认是要增加一个新的参考
		Clear_click();	
		//项目编码
		obj=document.getElementById("ParRef");
		obj.value=aiList[1];
		
		//项目名称
		obj=document.getElementById("ParRef_Name");
		obj.value=aiList[0];

	}
}

//获取细项表
function SearchDetailList(value) {
	
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
		//当选择一个项目时?默认是要增加一个新的参考
		Clear_click();	
		//项目编码
		obj=document.getElementById("ParRef");
		obj.value=aiList[0];
		
		//项目名称
		obj=document.getElementById("ParRef_Name");
		obj.value=aiList[1];

	}

}
*/