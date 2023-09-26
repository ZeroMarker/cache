/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.No.List

AUTHOR: ZhuFei , Microsoft
DATE  : 2007-5

COMMENT: DHC.WMR.MainInfo.Qry event handler

========================================================================= */
function BodyLoadHandler()
{
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=Query_click;}
	iniForm();
}
function iniForm()
{
	var obj=document.getElementById("cboMrType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.selectedIndex=-1;
		}
	
	var obj=document.getElementById("chkIsActive");
	if (obj){
		obj.checked=true;
	}
}
function Query_click()
{
	var cMrType="",cPatientNo="",cMrNO="",cIsActive=""
	var obj=document.getElementById("cboMrType");
	if (obj){
		var Idx=obj.options.selectedIndex;
		if (Idx>-1){
			cMrType=obj.options[Idx].value;
		}
	}
	var obj=document.getElementById("txtPatNo");
	if (obj){
		cPatientNo=FormatRegNo(Trim(obj.value));
		if (Trim(obj.value)==""){cPatientNo=""}
		}
	var obj=document.getElementById("txtMrNo");
	if (obj){var cMrNO=Trim(obj.value);}
	
	var obj=document.getElementById("chkIsActive");
	if (obj){
		if (obj.checked){
			cIsActive="Y";
		}
		else{
			cIsActive="N";
		}
	}
    
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MainInfoByNo.List" + "&MrTypeDR=" +cMrType+"&PatientNo="+cPatientNo+"&MrNO="+cMrNO+"&IsActive="+cIsActive;
    parent.RPMain.location.href=lnk;
}

document.body.onload = BodyLoadHandler;


//javascript remove space
function LTrim(str){ //remove leading space of a string
		var i;
		for(i=0;i < str.length; i ++)
		{
			 if(str.charAt(i)!=" "&&str.charAt(i)!=" ") 
				break;
		}
		str = str.substring(i,str.length);
		return str;
}
	
function RTrim(str){
		var i;
		for(i = str.length - 1; i>=0; i--)
		{
			if(str.charAt(i)!=" "&&str.charAt(i)!=" ") 
				break;
		}
		str = str.substring(0,i+1);
		return str;
}
	
function Trim(str){
		return LTrim(RTrim(str));
}


	//Format Registration No
	function FormatRegNo(str)
	{
		tmp = str;
		while(tmp.length <8)
		{
			tmp = "0" + tmp;
		}
		return tmp;
	}