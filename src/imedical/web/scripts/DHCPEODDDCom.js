/// DHCPEODDDCom.js
/// 创建时间		2006.03.21
/// 创建人		xuwm 
/// 主要功能		细项数据字典(细项的子表)
/// 对应表		DHC_PE_ODDD
/// 最后修改时间	
/// 最后修改人	

var CurrentSel=0
var IsChangeParRef="1";  //是否更改当前项目
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
	
	ShowCurRecord(1);
	
	}
function trim(s) {
        var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
}

//获取细项表
function SearchOrderDetail(value) {

	if ("1"==IsChangeParRef) {	 
		//容许改变当前项目
		var aiList=value.split("^");
		if (""==value){ return false; }
		else{
			var obj;
		
			Clear_click();
		
			//项目(细)编码
			obj=document.getElementById("ParRef");
			obj.value=aiList[1];
		
			//项目(细)名称
			obj=document.getElementById("ParRef_Name");
			obj.value=aiList[0];
  		}
	}
	else {
		//不容许改变当前项目
		//do nothing
	}

}

function Update_click(){
	 
	var iParRef="", iRowId="", iChildSub="";
	var iDesc="", iUserUpdateDR="", iDateUpdate="";

	//项目(细)编码
	var obj=document.getElementById("ParRef");  
	if (obj) { iParRef=obj.value; }

	//RowId数据无法传入 不处理 位置预留
	//var obj=document.getElementById("Rowid");  
	//if (obj){iRowid=obj.value}
	iRowid="";
  
	//细项数据字典编码  
	var obj=document.getElementById("ChildSub");  
	if (obj) { iChildSub=obj.value; }
  
	//数据字典内容
	var obj=document.getElementById("Desc");
	if (obj) { iDesc=obj.value; } 

	//最后修改用户编码	取网页上的(会话 session )用户编码 
	//var obj=document.getElementById("UserUpdateDR");
	//if (obj){iUserUpdateDR=obj.value} 
	iUserUpdateDR=session['LOGON.USERID'];
  
	//最后修改日期	取服务器日期
	//var obj=document.getElementById("DateUpdate");
	//if (obj){iDateUpdate=obj.value} 
	iDateUpdate='';
  
	//输入数据验证
 	if (""==iDesc){
		alert("Please entry all information.");
		//alert(t['01']);
		return false
	}  

	var Instring=trim(iParRef)+"^"+trim(iRowId)+"^"+trim(iChildSub)+"^"+trim(iDesc)+"^"+trim(iUserUpdateDR)+"^"+trim(iDateUpdate);
	
	var Ins=document.getElementById('ClassBox');
	if (Ins) { var encmeth=Ins.value; } 
	else { var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring);

 	if ('0'==flag) {}
	else{
		alert("Insert error.ErrNo="+flag)
		//alert(t['02']+flag);
	}
	
	location.reload(); 
}

function Delete_click(){

	var iParRef="", iChildSub="";
	var obj;
	
	//项目(细)编码
	obj=document.getElementById("ParRef");
	if (obj) { iParRef=obj.value; }
	
	//细项数据字典编码  
	obj=document.getElementById("ChildSub");
	if (obj) { iChildSub=obj.value; }
	if ((""==iParRef)||(""==iChildSub)) {
		alert("Please select the row to be deleted.");
		return false;
	}
	else { 
		if (confirm("Are you sure delete it?")){
			var Ins=document.getElementById('DeleteBox');
			if (Ins) { var encmeth=Ins.value; } 
			else { var encmeth=''; };
			var flag=cspRunServerMethod(encmeth,'','',iParRef,iChildSub)
			if ('0'==flag) {}
			else{ alert("Delete error.ErrNo="+flag); }
			location.reload();
		}
	}
   
}


function ShowCurRecord(CurRecord) {

	var selectrow=CurRecord;
	
	var SelRowObj;
	var obj;

	//数据字典内容
	SelRowObj=document.getElementById('DD_Desc'+'z'+selectrow);
	obj=document.getElementById("Desc");
	obj.value=trim(SelRowObj.innerText);
	

	//最后修改用户名称
	SelRowObj=document.getElementById('DD_UserUpdate_DR_Name'+'z'+selectrow);
	obj=document.getElementById("UserUpdate_DR_Name");
	obj.value=trim(SelRowObj.Value);		
  
	//最后修改用户编码
	SelRowObj=document.getElementById('DD_UserUpdate_DR'+'z'+selectrow);	
	obj=document.getElementById("UserUpdate_DR");	
	obj.value=SelRowObj.Value;
	
		
	//项目编码	
	SelRowObj=document.getElementById('DD_ParRef'+'z'+selectrow);
	obj=document.getElementById("ParRef");
	obj.value=SelRowObj.value;  

	//项目名称
	SelRowObj=document.getElementById('DD_ParRef_Name'+'z'+selectrow);
	obj=document.getElementById("ParRef_Name");
	obj.value=trim(SelRowObj.innerText);		


	//最后修改日期
	SelRowObj=document.getElementById('DD_DateUpdate'+'z'+selectrow);
	obj=document.getElementById("DateUpdate");
	obj.value=SelRowObj.value;

	//字典编号
	SelRowObj=document.getElementById('DD_RowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	obj.value=SelRowObj.value;

	//字典编码
	SelRowObj=document.getElementById('DD_ChildSub'+'z'+selectrow);
	obj=document.getElementById("ChildSub");
	obj.value=SelRowObj.value;
	
	SearchOrderDetailCom_click();
}
			
function Clear_click() {
		
	var obj;
	
	obj=document.getElementById("Rowid");
	obj.value="";

	//项目编码	
	obj=document.getElementById("ParRef");
	obj.value="";

	//项目名称	    			    
	obj=document.getElementById("ParRef_Name");
	obj.value="";	
	
	//字典编号
	obj=document.getElementById("ChildSub");
	obj.value="";

	//数据字典内容
	obj=document.getElementById("Desc");
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
	 	
	    
}


function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);	
	//var objtbl=document.getElementById('tDHCPEODDDCom');
	
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
}

document.body.onload = BodyLoadHandler;
