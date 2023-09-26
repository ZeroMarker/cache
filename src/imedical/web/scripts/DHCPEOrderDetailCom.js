/// DHCPEOrderDetailCom.js
/// 创建时间	2006.03.20
/// 创建人	xuwm 
/// 主要功能	细项表信息编辑
/// 对应表	DHC_PE_OrderDetail
/// 最后修改时间	
/// 最后修改人	

var CurrentSel=0;
var FIsValidCode=false;
var FOrderdetaiName="";

function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }		

	obj=document.getElementById("btnEditExpression");
	if (obj){ obj.onclick=EditExpression_click; }
	
	//项目类型
	obj=document.getElementById("Type_T");
	if (obj){ obj.onclick=Type_click; }
	obj=document.getElementById("Type_N");
	if (obj){ obj.onclick=Type_click; }
	obj=document.getElementById("Type_C");
	if (obj){ obj.onclick=Type_click; }
	obj=document.getElementById("Type_S");
	if (obj){ obj.onclick=Type_click; }	
	obj=document.getElementById("Type_A");
	if (obj){ obj.onclick=Type_click; }	
	//性别类型
	obj=document.getElementById("Sex_F");
	if (obj){ obj.onclick=Sex_click; }
	obj=document.getElementById("Sex_M");
	if (obj){ obj.onclick=Sex_click; }
	obj=document.getElementById("Sex_N");
	if (obj){ obj.onclick=Sex_click; }	
	
	obj=document.getElementById("Sex_N");
	if (obj){ obj.onclick=Sex_click; }		

	obj=document.getElementById('Code');
	if (obj) {obj.onkeydown = Code_keydown;}
	
	obj=document.getElementById('Sequence');
	if (obj) {obj.onkeydown = Sequence_keydown;}
		
	iniForm();

	var obj=document.getElementById("OD_Descz1");
	if (obj) {obj.click();}	
}  

// **************  ---------------   ********************
 
function iniForm() {	

	var SelRowObj;
	var obj;

	SelRowObj=document.getElementById('ParRefBox');
	obj=document.getElementById("ParRef");
	obj.value=SelRowObj.value;

	if (''==SelRowObj.value){
	    obj=document.getElementById("ParRefName");
	    //obj.value="未选择站点";
	    obj.value=t["Inf 01"];
	}
	else{
		
		SelRowObj=document.getElementById('ParRefNameBox');
	    obj=document.getElementById("ParRefName");
	    obj.value=SelRowObj.value; 		
		ShowCurRecord(1);
	}
	
	obj=document.getElementById("LabtrakCode");
	if (obj) { obj.disabled=true; }

}
	
function trim(s) {
        var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (null == m) ? "" : m[1];
}

function IsInt(IntValue) 
{ 
	var m,r;     

	IntValue=IntValue.toString();
	if(""==trim(IntValue)) { return false; } 

	//正整数 
    var r=IntValue.match(/^\+?[0-9]*[1-9][0-9]*$/); 
    if(r==null) { return false; } 
    else { return true; } 
} 

function Clear_click() {     
  
	var obj;
	
	//项目名称
	obj=document.getElementById("Code");
	if (obj) { obj.value=""; }
	if (obj) {obj.className=''; }	
			
	//项目名称
	obj=document.getElementById("Desc");
	if (obj) { obj.value=""; }
		
	//项目类型 1说明型 2数值型 3计算型
	obj=document.getElementById("Type");
	if (obj) { obj.value="T"; }
		SetType("");
		SetType("T");	
		
	//表达式
	obj=document.getElementById("Expression");
	if (obj) { obj.value=""; }	
	obj=document.getElementById("EditExpression");
	if (obj) { obj.value=""; }	
	
	//单位
	obj=document.getElementById("Unit");
	if (obj) { obj.value=""; }
			
	//是否进入小结 数字 1
	obj=document.getElementById("Summary");
	if (obj) { obj.checked="Y"; }
	  	//SetSummary("");
		//SetSummary("Y");
		
	//是否有建议项 数字 1
	obj=document.getElementById("Advice");
	if (obj) { obj.checked=false; }
		
	//说明
	obj=document.getElementById("Explain");
	if (obj) { obj.value=""; }
		
	//顺序号 数字
	//obj=document.getElementById("Sequence");
	//if (obj) { obj.value="0"; }	
	//obj.className="";
	
	//适用性别 M-男,F-女,N-不限
	obj=document.getElementById("Sex");
	if (obj) { obj.value="N"; }
		SetSex("");
		SetSex("N");

	//检验编码 
	obj=document.getElementById("LabtrakCode");
	if (obj) { obj.value=""; }
	
		
	//英文对照
	obj=document.getElementById("ZhToEng");
	if (obj) { obj.value=""; }

	//记录编号
	obj=document.getElementById("ChildSub");
	if (obj) { obj.value=""; }

	/*
		//容许改变当前这站点
		
		//站点编号		    
		obj=document.getElementById("ParRef");
		if (obj) { obj.value=""; }
		
		//站点名称
		obj=document.getElementById("ParRefName");
		if (obj) { obj.value=""; }
	*/
		
	obj=document.getElementById("Delete");
	if (obj){ obj.disabled=false; }
		
	obj=document.getElementById("Update");
	if (obj){ obj.disabled=false; }

}


// *****************************************************************************

function EditExpression_click() {
	var obj;
	var Expression="";
	//表达式
	obj=document.getElementById("EditExpression");
	if (obj){ iExpression=obj.value; }  
	Expression=IsValidExpression(iExpression);
	if (""==Expression) {
		//alert("无效公式");
		alert(t["Err 02"]);
	}else{
		//alert("计算公式验证成功");
		alert(t["Inf 02"]);	
	}
}

function Update_click() {
	
	var eSrc=window.event.srcElement;
	if (eSrc && eSrc.disabled) { return false; }	
	
	var iParRef="", iRowId="", iChildSub="";
	var iCode="", iDesc="", iType="", iExpression="", iUnit="", iSummary="", iAdvice="", iExplain="", iSequence="", iSex="",iZhToEng=""
	var iSpecialNature="";
	var obj;
	
	//项目编码
	obj=document.getElementById("Code");
	if (obj){ iCode=obj.value; }	
	
	//项目名称
	obj=document.getElementById("Desc");
	if (obj){ iDesc=obj.value; }  
  
	//项目类型 1说明型 2数值型 3计算型
	//obj=document.getElementById("Type");
	//if (obj){ iType=obj.value; }  
	iType = GetType();

	//表达式
	obj=document.getElementById("EditExpression");
	if (obj){ iExpression=IsValidExpression(obj.value); }  

	//单位
	obj=document.getElementById("Unit");
	if (obj){ iUnit=obj.value; }  
	
	//是否进入小结 数字 1
	obj=document.getElementById("Summary");
	if (obj){
		if (obj.checked==true){ iSummary="Y"; }
		else{ iSummary="N"; }
	}
    
	//是否有建议项 数字 1
	obj=document.getElementById("Advice");
	if (obj) {
		if (obj.checked==true) { iAdvice="Y"; }
		else{ iAdvice="N"; }
	}

	//说明
	obj=document.getElementById("Explain");
	if (obj){ iExplain=obj.value; }  
	
	//顺序号 数字
	obj=document.getElementById("Sequence");  
	if (obj){ iSequence=obj.value; }  
	if (!(IsSequence(iSequence))) { return false; }

	//适用性别 M-男,F-女,N-不限 
	//obj=document.getElementById("Sex");  
	//if (obj){ iSex=obj.value; }
		iSex=GetSex(); 
    obj=document.getElementById("NoPrint");    //add by zl 20100120 start
     if (obj){
		if (obj.checked==true){ iNoPrint="Y"; }
		else{ iNoPrint="N"; }
	} 
	// 英文对照 
	obj=document.getElementById("ZhToEng");
	if (obj){ iZhToEng=obj.value; }
	
	//站点编号
	obj=document.getElementById("ParRef");  
	if (obj){ iParRef=obj.value; }
  	
  	//记录编号
	//obj=document.getElementById("Rowid");  
	//if (obj){iRowid=obj.value}
	iRowid=""
	
	//站点编号
	obj=document.getElementById("ChildSub");  
	if (obj){ iChildSub=obj.value; }
	
	//验证?编码是否有效
	//if (!(IsValidCode())) { return false };	
	
	//项目名称、细项编码不为空
	if ((""==iDesc)||(""==iCode)){
		alert(t['01']);
		//websys_setfoucs(Desc);
		return false;
	} 

	/*//名称不为空
	if (""==iDesc){
		//alert("Please entry all information.");
		alert(t['01']);
		websys_setfoucs(Desc);
		return false;
	}  */
	
	//当类型是计算时?要有公式
	if ("C"==iType) {
		if (";"==iExpression) { 
			//alert("无效公式");
			alert(t["Err 02"]);
			return false; 
		}
	}
  
	if (""==iParRef){ 
		//alert("无效站点");
		//alert(t['Err 01']);
		return false;
	}
	
	obj=document.getElementById("SpecialNature");
	if (obj) {
		iSpecialNature=obj.value;	
	}
	
	var Instring = trim(iParRef)
				+"^"+trim(iRowId)
				+"^"+trim(iChildSub)
				+"^"+trim(iCode)
				+"^"+trim(iDesc)
				+"^"+trim(iType)
				+"^"+trim(iExpression)
				+"^"+trim(iUnit)
				+"^"+trim(iSummary)
				+"^"+trim(iAdvice)
				+"^"+trim(iExplain)
				+"^"+trim(iSequence)
				+"^"+trim(iSex)
				+"^"+trim(iNoPrint)  
				+"^"+trim(iZhToEng) 
				+"^"+trim(iSpecialNature)
				;
	//alert(Instring)
	var Ins=document.getElementById('ClassBox');
	if (Ins) { var encmeth=Ins.value; } 
	else { var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring);

		if ('0'==flag) { location.reload(); }
		else if ('Err 03'==flag) {
			// 编码已被其他项目使用
			alert(t['Err 03']);
		}		
		else{
			//alert("Insert error.ErrNo="+flag)
			alert(t['02']+flag);
		}	

}

function Delete_click() {
	
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false; }	
		
	var iParRef="", iChildSub="";
	var obj;
	
	obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; }
	
	obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value; }
	
	if ((""==iParRef)||(""==iChildSub)) {
		//alert("Please select the row to be deleted.");
		alert(t['03']);
		return false
	} 
	else{
		//if (confirm("Are you sure delete it?")) {
		if (confirm(t['04'])) {
			var Ins=document.getElementById('DeleteBox');
			if (Ins) { var encmeth=Ins.value; } 
			else { var encmeth=''; };
			
			var flag=cspRunServerMethod(encmeth,'','',iParRef,iChildSub)
			
			if ('0'==flag) {}
			else if ('Err 07'==flag){ 
				alert("医嘱和细项有对照关系,请先删除对照关系"); 
				//alert(t['Err 07']);
			}
			else { 
				//alert("Delete error.ErrNo="+flag); 
				alert(t['05']+flag);
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

			obj.value=trim(SelRowObj.value);
			return obj;
	}

}

function ShowCurRecord(CurRecord) {

	var selectrow=CurRecord;
	var obj;

	//细项编码 唯一
	FromTableToItem("Code","OD_Code",selectrow);  

	//项目名称	
	FromTableToItem("Desc","OD_Desc",selectrow); 

    //是否打印
	FromTableToItem("NoPrint","OD_NoPrint",selectrow);      //add by zl 20100120
	FromTableToItem("ZhToEng","OD_ZhToEn",selectrow); 

	//项目类型 1说明型?2数值型?3计算型
	obj=FromTableToItem("Type","OD_Type",selectrow); 
	SetType("");		
	if (obj) { SetType(obj.value); }
		
	//表达式
	obj=FromTableToItem("EditExpression","OD_Expression",selectrow);
	if (obj) { 
		//var aiList=obj.value.split(";");
		//obj.value=trim(aiList[0]); 
		
		var strtmp=obj.value;
		//strtmp=strtmp.replace(/\[/g,"");
		//strtmp=strtmp.replace(/\]/g,"");
		obj.value=strtmp;		
	}

	//单位
	FromTableToItem("Unit","OD_Unit",selectrow); 
 
	//是否进入小结 数字 1
	FromTableToItem("Summary","OD_Summary",selectrow); 

	//是否有建议项 数字 1
	FromTableToItem("Advice","OD_Advice",selectrow);

	//说明
	FromTableToItem("Explain","OD_Explain",selectrow);

	//顺序号 数字
	//obj=FromTableToItem("Sequence","OD_Sequence",selectrow);
	//if (obj) { obj.className=""; }

	//记录编号
	obj=FromTableToItem("LabtrakCode","OD_LabtrakCode",selectrow);
	if (obj) {
		if (""==obj.value) {
			obj=document.getElementById("Delete");
			if (obj){ obj.disabled=false; }
		
			obj=document.getElementById("Update");
			if (obj){ obj.disabled=false; }
		}else {
			obj=document.getElementById("Delete");
			if (obj){ obj.disabled=true; }
		
			obj=document.getElementById("Update");
			//if (obj){ obj.disabled=true; }
		}
	}
	
	//适用性别 M-男,F-女,N-不限
	obj=FromTableToItem("Sex","OD_Sex",selectrow);
	SetSex("");	
	if (obj) { SetSex(trim(obj.value)); }

	//站点编号
	FromTableToItem("ParRef","OD_ParRef",selectrow);
  
	//站点名称
	FromTableToItem("ParRefName","OD_ParRef_Name",selectrow);


	//RowId 数据形式是 OD_ParRef||OD_ChildSub 有双引号无法?此参数无法传 
	//FromTableToItem("RowId","OD_RowId",selectrow);

	//记录编号
	FromTableToItem("ChildSub","OD_ChildSub",selectrow);
	
	//不打印
    FromTableToItem("NoPrint","TNoPrint",selectrow);
    
	//特殊范围
	FromTableToItem("SpecialNature","TSpecialNature",selectrow);

}	

/*
function ShowCurRecord(selectrow) {
	
	var SelRowObj;
	var obj;
	
	//细项编码 唯一
	SelRowObj=document.getElementById('OD_Code'+'z'+selectrow);
	obj=document.getElementById("Code");
	obj.value=trim(SelRowObj.innerText);
	obj.className='';
	
	
	//项目名称	 
	SelRowObj=document.getElementById('OD_Desc'+'z'+selectrow);	
	obj=document.getElementById("Desc");
	obj.value=trim(SelRowObj.innerText);

	//项目类型 1说明型?2数值型?3计算型
	SelRowObj=document.getElementById('OD_Type'+'z'+selectrow);
	obj=document.getElementById("Type");
	obj.value=trim(SelRowObj.innerText);
	
		SetType("");		
		SetType(trim(SelRowObj.innerText));
		
	//表达式
	SelRowObj=document.getElementById('OD_Expression'+'z'+selectrow);
	var aiList=SelRowObj.value.split(";");
	obj=document.getElementById("EditExpression");
	obj.value=trim(aiList[0]);

	//单位
	SelRowObj=document.getElementById('OD_Unit'+'z'+selectrow);
	obj=document.getElementById("Unit");
	obj.value=trim(SelRowObj.innerText);	
		   
	//是否进入小结 数字 1
	SelRowObj=document.getElementById('OD_Summary'+'z'+selectrow);
	obj=document.getElementById("Summary");
	obj.checked=SelRowObj.checked;
    
	//是否有建议项 数字 1
	SelRowObj=document.getElementById('OD_Advice'+'z'+selectrow);
	obj=document.getElementById("Advice");
	obj.checked=SelRowObj.checked;

	//说明
	SelRowObj=document.getElementById('OD_Explain'+'z'+selectrow);
	obj=document.getElementById("Explain");
	obj.value=trim(SelRowObj.innerText);

	//顺序号 数字
	SelRowObj=document.getElementById('OD_Sequence'+'z'+selectrow);
	obj=document.getElementById("Sequence");
	obj.value=trim(SelRowObj.innerText);
	obj.className="";
	
	//适用性别 M-男,F-女,N-不限
	SelRowObj=document.getElementById('OD_Sex'+'z'+selectrow);
	obj=document.getElementById("Sex");
	obj.value=trim(SelRowObj.innerText);
		SetSex("");	
		SetSex(trim(SelRowObj.innerText));

		//站点编号
		SelRowObj=document.getElementById('OD_ParRef'+'z'+selectrow);
		obj=document.getElementById("ParRef");
		obj.value=SelRowObj.value;
  
		//站点名称
		SelRowObj=document.getElementById('OD_ParRef_Name'+'z'+selectrow);
		obj=document.getElementById("ParRefName");
		obj.value=trim(SelRowObj.value);  

	//RowId 数据形式是 OD_ParRef||OD_ChildSub 有双引号无法?此参数无法传 
	//SelRowObj=document.getElementById('OD_RowId'+'z'+selectrow);
	//obj=document.getElementById("RowId");
	//obj.value=SelRowObj.value;

	//记录编号
	SelRowObj=document.getElementById('OD_ChildSub'+'z'+selectrow);
	obj=document.getElementById("ChildSub");
	obj.value=SelRowObj.value;	

}	

*/

function Sequence_keydown(e) {
	var key;
	key=websys_getKey(e);
	if ((key==13)||(key==9)) {
		IsSequence()
	}else{
	obj=document.getElementById('Sequence');
	if (obj) { obj.className=''; }
	}

}

function Code_keydown(e) {
	var key;
	key=websys_getKey(e);
	
	if ((key==13)||(key==9)) {
		IsValidCode()
	}else{
		obj=document.getElementById('Code');
		if (obj) { obj.className=''; }
	}

}
// **********************************************************
//验证顺序号是否正确 
function IsSequence(Sequence) {
	if ((""==Sequence)||("0"==Sequence)) { return true; }
	if (IsInt(Sequence)) { return true; }
	else{		
		obj=document.getElementById("Sequence");
		obj.className='clsInvalid';
		websys_setfocus('Sequence');
		//alert("无效顺序号");
		alert(t["Err 06"]);
		return false;
	}

}
/*
// Code是否有效?未使用?
function IsValidCode() {
	
	var iParRef,iCode,iChildSub;
	var obj;

	obj=document.getElementById('ChildSub');
	if (obj) { iChildSub=obj.value; } else { return false }
			
	obj=document.getElementById('ParRef');
	if (obj) { iParRef=obj.value; } else { return false};
		
	obj=document.getElementById('Code');
	if (obj) { iCode=obj.value } 
	
	if (iCode!='') {		
		var Ins=document.getElementById('IsValidCode');
		if (Ins) {var encmeth=Ins.value} else {var encmeth=''};			
		var flag=cspRunServerMethod(encmeth,'','',iParRef,iCode);

		
		//编码未使用 有效
		if (''==flag) { 
			FIsValidCode=true;
			return true;
		}

		if (iChildSub!=flag) {
			FIsValidCode=false;
			obj.className='clsInvalid';	
			//alert("项目编码已使用");
			alert(t["Err 03"]);
			websys_setfocus('Code');
			return false;
		}else{
			FIsValidCode=true;
			return true;
		}

	}
	else {
		obj.className='clsInvalid';
		FIsValidCode=true;
		//alert("项目编码不容许为空");
		alert(t["Err 04"]);
		websys_setfocus('Code');
		return false;
	}
}
*/
// ********************************************************************
function IsValidExpression(aExpression) {
	return aExpression;
	var strExpression="";
	var strLine="";
	var iLoop=0;
	
	var iValue="",iOperator="",iCode="";	
	
	var ReadStatus=""; //读取类型   V 当前读取变量 O 当前读取到操作符 P 当前读取到括号
	var obj;
	
	strExpression=aExpression+';';

	for (iLoop=0;iLoop<strExpression.length;iLoop++) {
		switch (strExpression.charAt(iLoop)){
			case "+":{
				Operator="+";
				ReadStatus="O";	
				break;				
			}
			case "-":{
				Operator="-";
				ReadStatus="O";	
				break;				
			}
			case "*":{
				Operator="*"
				ReadStatus="O";	
				break;			
			}
			case "/":{
				Operator="/";
				ReadStatus="O";			
				break;
			}
			case "(":{
				Operator="(";
				ReadStatus="PB";			
				break;
			}
			case ")":{
				Operator=")";
				ReadStatus="PE";			
				break;
			}
			
			case ";":{
				ReadStatus="F";
				break;
			}
			
			default: {
				ReadStatus="V";		 
				iValue=iValue+strExpression.charAt(iLoop);
				break;
			}

		}
		//当前字符为操作符
		if ("O"==ReadStatus) {				
			iCode=GetOrderdetailCode(iValue);
			strLine=strLine+iCode+Operator;
			iValue="";	
			Operator="";	
		}
		
		//
		if ("PB"==ReadStatus) {
			strLine=strLine+Operator;
			iValue="";
			Operator="";
		}
		
		//
		if ("PE"==ReadStatus) {

			iCode=GetOrderdetailCode(iValue);
			strLine=strLine+iCode+Operator;
			iValue="";
			Operator="";
		}
		//语句结束		
		if ("F"==ReadStatus) {

			iCode=GetOrderdetailCode(iValue);
			strLine=strLine+iCode;
			
			if (""==strLine) { return ""; }			
			//strLine=strExpression+strLine
		}
	}

	obj=document.getElementById("Expression");
	if (obj){ obj.value=strLine; }

	return strLine;
}

// ******************************************************************
function GetOrderdetailCode(aValue) {
	
 	if (""==aValue) { return aValue;}

	var objtbl;
	var SelRowObj;
	var obj;
	var iCode="";
	var iDesc=""

	objtbl=document.getElementById('tDHCPEOrderDetailCom');
	if (objtbl) { var rows=objtbl.rows.length; }

	for (var iLoop=1;iLoop<rows;iLoop++) {
		iCode="";
		iDesc="";
		FOrderdetaiName="";
		SelRowObj=document.getElementById('OD_Code'+'z'+iLoop);		
		if (SelRowObj && ""!=SelRowObj.value) { iCode=SelRowObj.innerText; }
		else { continue; }

		SelRowObj=document.getElementById('OD_Desc'+'z'+iLoop);		
		if (SelRowObj && ""!=SelRowObj.value) { iDesc=SelRowObj.innerText; }

		if (iCode==aValue) {
			iCode="["+iCode+"]";
			FOrderdetaiName=iDesc;
			return iCode;
		}
	}

	//未找到编码?则退出
	return aValue;		

}

// ***********************************************************************
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
	var iSex="";
	obj=document.getElementById('Sex_M');
	if (obj){ if (obj.checked) { iSex='M'; } }
	
	obj=document.getElementById('Sex_F');
	if (obj){ if (obj.checked) { iSex='F'; } }
	
	obj=document.getElementById('Sex_N');
	if (obj){ if (obj.checked) { iSex='N'; } }
	
	if (''==iSex) { iSex='N'; }
	
	return iSex;
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

// **************  对类型特殊处理   ********************
function GetType() {	
	var obj;
	
	//T说明型 
	obj=document.getElementById("Type_T"); 
	if (obj){ if (obj.checked) { return "T"; } }
	
	//N数值型
	obj=document.getElementById("Type_N");
	if (obj){ if (obj.checked) { return "N"; } }
	
	//C计算型
	obj=document.getElementById("Type_C");
	if (obj){ if (obj.checked) { return "C"; } }
	
	//S选择型
	obj=document.getElementById("Type_S");
	if (obj){ if (obj.checked) { return "S"; } }	
	
	//A多行
	obj=document.getElementById("Type_A");
	if (obj){ if (obj.checked) { return "A"; } }
	
	return "T"; // 默认类型
}

function SetType(value) {
	
	var obj;
	
	//隐藏表达式输入框
	document.all["EditExpression"].disabled=true; 
	document.all["cEditExpression"].disabled=true; 
	document.all["btnEditExpression"].disabled=true; 			
	
	if(document.all["EditExpression"].disabled){
	    document.getElementById("cEditExpression").style.color = "gray";
		document.getElementById("btnEditExpression").style.color = "gray";
	}

	
	if (""==value) {
		// 1 说明型
		obj=document.getElementById("Type_T");
		if (obj){ obj.checked=false; }
		// 2 数值型
		obj=document.getElementById("Type_N");
		if (obj){ obj.checked=false; } 
		// 3 计算型
		obj=document.getElementById("Type_C");
		if (obj){ obj.checked=false; } 
		// 4 选择型
		obj=document.getElementById("Type_S");
		if (obj){ obj.checked=false; } 
		// 4 多行
		obj=document.getElementById("Type_A");
		if (obj){ obj.checked=false; } 
		return false;				
	}
	
	//2数值型 
	obj=document.getElementById("Type_N");	
	if ("N"==value && obj) {		
		obj.checked=true;
		return true;
	}

	//4选择型
	obj=document.getElementById("Type_S");
	if ("S"==value && obj) {
		obj.checked=true; 
		return true;
	}
	//4多行
	obj=document.getElementById("Type_A");
	if ("A"==value && obj) {
		obj.checked=true; 
		return true;
	}
	//1说明型	默认类型
	obj=document.getElementById("Type_T");
	if ("T"==value && obj) {
		obj.checked=true; 
		return true;
	} 
	
	//3计算型
	obj=document.getElementById("Type_C");	
	if ("C"==value && obj) {
		document.all["EditExpression"].disabled=false;
		document.all["cEditExpression"].disabled=false;
		document.all["btnEditExpression"].disabled=false;
		obj.checked=true;
		if(!(document.all["EditExpression"].disabled)){
		document.getElementById("cEditExpression").style.color = "black";
		document.getElementById("btnEditExpression").style.color = "blue";
		}

		
		return true;
	}		
}

function Type_click() {
	var obj;

	srcElement = window.event.srcElement;
	SetType("");
	obj=srcElement;
	obj.checked=true;

	obj=document.getElementById("Type_C");
	if (obj.checked){ 
		SetType("C");
	}	
	
	
}


// *******************   以下是 现未使用的函数   ***********************************
/*
//搜索站点
function SearchStation(value) {
 
		//容许改变当前这站点	
		var aiList=value.split("^");
		if (""==value){ return false; }
		else{	
			var obj;
			
			Clear_click();
			
			//站点编号
			obj=document.getElementById("ParRef");
			obj.value=aiList[2];
			
			//站点名称
			obj=document.getElementById("ParRefName");
			obj.value=aiList[0];
		}
	
}
// 获取单位
function SearchUOM(value) {
		
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;
	
		//项目
		obj=document.getElementById("Unit_DR_Name");
		obj.value=aiList[0];
		
		//项目
		obj=document.getElementById("Unit_DR");
		obj.value=aiList[2];
		
	}
}
*/