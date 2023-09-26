///zhouli
/// 主要功能:医生诊断级别维护
/// DHCPEDiagnosisLevel.js
/// 对应表	


var CurRow=0
var CurrentSel=0
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("Update");
	if (obj){obj.onclick=Update_click;}

	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }

	obj=document.getElementById("Add");
	if (obj){ obj.onclick=Add_click; }
	


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

function Add_click() {
	var iLevel="", iDesc="",iRowId="",iWarnFlag="";
	
	//var obj=document.getElementById("RowID");
	//if (obj){iRowId=obj.value; } 
	//等级 
	var obj=document.getElementById("Level");
	if (obj){iLevel=obj.value; } 

    //描述
	var obj=document.getElementById("Desc");
	if (obj){iDesc=obj.value; } 
    
    var obj=document.getElementById("WarnFlag");
	if (obj && obj.checked) { iWarnFlag="Y"; }
	else { iWarnFlag="N"; }
 
 	if (""==iLevel) {
		obj=document.getElementById("Level")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("级别不能为空");
		return false;
	}

  	if (""==iDesc) {
		obj=document.getElementById("Desc")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("描述不能为空");
		return false;
	}

     /*//输入数据验证
	if ((iLevel=="")||(iDesc=="")) {
		alert("Please entry all information.");
		
	}  */
	var Instring=trim(iLevel)		
				+"^"+trim(iDesc)
				+"^"+trim(iWarnFlag)		
				

	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
    if (flag==0)  
    
	{  window.location.reload();   
	
		 
	}
	else
	{
		alert(t["Err"]);
	}
    }  
    
function Update_click()
{   
    var iLevel="", iDesc="",iRowId="",iWarnFlag="";
	
	var obj=document.getElementById("RowID");
	if (obj){iRowId=obj.value; } 
	//等级 
	var obj=document.getElementById("Level");
	if (obj){iLevel=obj.value; } 

    //描述
	var obj=document.getElementById("Desc");
	if (obj){iDesc=obj.value; } 
	
    var obj=document.getElementById("WarnFlag");
	if (obj && obj.checked) { iWarnFlag="Y"; }
	else { iWarnFlag="N"; }
	
	if (""==iLevel) {
		obj=document.getElementById("Level")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("级别不能为空");
		return false;
	}

  	if (""==iDesc) {
		obj=document.getElementById("Desc")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("描述不能为空");
		return false;
	}

     /*//输入数据验证
	if ((iLevel=="")||(iDesc=="")) {
		alert("Please entry all information.");
		
	}  */
	var Instring=trim(iRowId)
	            +"^"+trim(iLevel)		
				+"^"+trim(iDesc)
				+"^"+trim(iWarnFlag)		
				

	var Ins=document.getElementById('UpdateBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
    if (flag==0)  
    
	{  window.location.reload();   
	
		 
	}
	else
	{
		alert(t["Err"]);
	}
    
 

 }

function Delete_click()

{ 
    var ID=""
	if (CurRow==0)
	{
	alert("请先选择要删除的记录");
	 return;
	}
	var obj=document.getElementById("TRowIDz"+CurRow)
	
	if (obj) var ID=obj.value;
	var string=trim(ID)
	var encmeth="";
	var encmethobj=document.getElementById("DeleteBox");
	if (encmethobj) var encmeth=encmethobj.value;
	else encmeth="";
	var flag=cspRunServerMethod(encmeth,string);
	
	if (flag==0)
	{  
		window.location.reload();
	}
	
	else
	{    
		alert(t["Err"]);
	}
	}
	
	
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	
	var objtbl=document.getElementById('tDHCPEDiagnosisLevel');	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	if (Row==CurRow)
	{
		CurRow=0      
	
	}
	else
	{
		CurRow=Row;
	}
	
   var obj=document.getElementById("TRowIDz"+CurRow)
	var objRowID=document.getElementById("RowID")
	if (objRowID)  objRowID.value=obj.value;

    var obj=document.getElementById("TLevelz"+CurRow)
	var objLevel=document.getElementById("Level")
	if (objLevel)  objLevel.value=obj.innerText;

    var obj=document.getElementById("TDescz"+CurRow)
    var objDesc=document.getElementById("Desc")
	if (objDesc)  objDesc.value=obj.innerText;
   
   var obj=document.getElementById("TWarnFlagz"+CurRow)
    var objFlag=document.getElementById("WarnFlag")
	if (objFlag)  objFlag.checked=obj.checked;
	

}	


document.body.onload = BodyLoadHandler;
