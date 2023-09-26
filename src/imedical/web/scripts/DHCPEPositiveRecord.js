
/// DHCPEPositiveRecord.js


var CurRow=0
var CurrentSel=0
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("Update");
	if (obj){obj.onclick=Update_click;}

	obj=document.getElementById("Type")
	if(obj){
		var Type=obj.value;
		if (Type=="Q")
		{
			var obj=document.getElementById("cTitle");
			if (obj) obj.innerText="体检结果分析阳性记录维护";
		}
	}

	var obj=document.getElementById("UseRange");
	if(obj){obj.checked=true}
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

    
function Update_click()
{   
    var RowId="",iCode="", iName="", iMSeq="", iFSeq="";
	
	var obj=document.getElementById("Id");
	if (obj){RowId=obj.value; } 
	var iUserID=session['LOGON.USERID'];
	var obj=document.getElementById("Code");
	if (obj){iCode=obj.value; } 
	var obj=document.getElementById("Name");
	if (obj){iName=obj.value; }
	
	if (""==iCode) {
		
		obj=document.getElementById("Code")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("编号不能为空");
		return false;
	}
	if (""==iName) {
		obj=document.getElementById("Name")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("描述不能为空");
		return false;
	}

	
	var obj=document.getElementById("MSeq");
	if (obj){iMSeq=obj.value; }
	var obj=document.getElementById("FSeq");
	if (obj){iFSeq=obj.value; }
	var iUseRange="S";
	var obj=document.getElementById("UseRange")
	if (obj&&!obj.checked) iUseRange="U";
	
	var Instring=trim(RowId)
	            +"^"+trim(iCode)		
				+"^"+trim(iName)
				+"^"+trim(iMSeq)
				+"^"+trim(iFSeq)
	 			+"^"+trim(iUseRange)
	 			+"^"+iUserID;
	 //alert(Instring)
	var Ins=document.getElementById('UpdateBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var Type="P";
	var obj=document.getElementById("Type");
	if (obj) Type=obj.value;
	var flag=cspRunServerMethod(encmeth,Instring,Type)
    if (flag==0)  
	{  
		window.location.reload();  
		//parent.location.reload();
		//self.opener.location.reload();   
		 	 
	}
	else
	{
		alert("ERR");
	}
    

 }

	
	
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	
	var objtbl=document.getElementById('tDHCPEPositiveRecord');	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	if (Row==CurRow)
	{
		CurRow=0;
		var obj=document.getElementById("Id")
		if (obj)  {obj.value="";}
		var obj=document.getElementById("Code")
		if (obj)  {obj.value="";}  
		var obj=document.getElementById("Name")
		if (obj)  {obj.value="";}   
		var obj=document.getElementById("MSeq")
		if (obj) {obj.value="";} 
		var obj=document.getElementById("FSeq")
		if (obj) {obj.value="";}
		var obj=document.getElementById("UseRange")
		if (obj) obj.checked=true;
	}
	else
	{
		CurRow=Row;
	}
	var obj=document.getElementById("IDz"+CurRow)
	if (obj){
		var ParRef=obj.value;
		if (parent.frames["right"]){
			lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEEDConditionNew"
			+"&"+"ParrefRowId"+"="+ParRef+"&"+"Type"+"="+"PR";
			parent.frames["right"].location.href=lnk;
			}
		}
	var objId=document.getElementById("Id")
	if (objId)  {
	objId.value=obj.value;
	}
	var obj=document.getElementById("TCodez"+CurRow)
	var objCode=document.getElementById("Code")
	if (objCode)  objCode.value=obj.innerText;
    var obj=document.getElementById("TNamez"+CurRow)
    var objName=document.getElementById("Name")
	if (objName)  objName.value=obj.innerText;
   
  	var obj=document.getElementById("TMSeqz"+CurRow)
    var objName=document.getElementById("MSeq")
	if (objName)  objName.value=obj.innerText;
	
	var obj=document.getElementById("TFSeqz"+CurRow)
    var objName=document.getElementById("FSeq")
	if (objName)  objName.value=obj.innerText;
	/*
	var obj=document.getElementById("TUseRangez"+CurRow)
    var objName=document.getElementById("UseRange")
	if (objName)  objName.checked=obj.checked;
	*/
	
	var obj=document.getElementById("PRUseRangeDescz"+CurRow)
    var objName=document.getElementById("UseRange")
	if (objName)  {
		if(obj.innerText=="是"){objName.checked=true;}
	    else{objName.checked=false;}
	}

}	




document.body.onload = BodyLoadHandler;
