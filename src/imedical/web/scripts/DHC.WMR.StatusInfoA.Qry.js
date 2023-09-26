/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.StatusInfoA.Qry

AUTHOR: ZhuFei , Microsoft
DATE  : 2007-4

COMMENT: DHC.WMR.StatusInfoA.Qry event handler

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
	var obj=document.getElementById("cboNoType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		var objItm = document.createElement("OPTION");
		obj.options.add(objItm);
		objItm.innerText = t['cboNoType1'];
		objItm.value = 0;
		var objItm = document.createElement("OPTION");
		obj.options.add(objItm);
		objItm.innerText = t['cboNoType2'];
		objItm.value = 1;
		var objItm = document.createElement("OPTION");
		obj.options.add(objItm);
		objItm.innerText = t['cboNoType3'];
		objItm.value = 2;
		obj.selectedIndex=-1;
	}
}

function Query_click()
{
	var cMrType="",cWMRNo="",cFlg="",cNo="",cMainId="",cVolId=""
	
	var obj=document.getElementById("cboMrType");
	if (obj){
		var Idx=obj.options.selectedIndex;
		if (Idx>-1){
			cMrType=obj.options[Idx].value;
		}
	}
	/*
	var obj=document.getElementById("txtMainID");
	if (obj){
		cMainId=obj.value;
	}
	var obj=document.getElementById("txtVolID");
	if (obj){
		cVolId=obj.value;
	}

	var obj=document.getElementById("txtWMRNo");
	if (obj){
		cWMRNo=obj.value;
	}
	
	if (cWMRNo!==""){cFlg=2;cNo=cWMRNo}
	if (cVolId!==""){cFlg=1;cNo=cVolId}
	if (cMainId!==""){cFlg=0;cNo=cMainId}
	*/
	var obj=document.getElementById("cboNoType");
	if (obj){
		var Idx=obj.options.selectedIndex;
		if (Idx>-1){
			cFlg=obj.options[Idx].value;
		}
	}

	var obj=document.getElementById("txtNo");
	if (obj){
		cNo=Trim(obj.value);
	}

	if (cNo=="") {return;}
	if ((cFlg==0)||(cFlg==2)){
		//display mr status list
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.StatusInfoAMain.List" + "&MrType=" +cMrType+"&No="+cNo+"&Flg="+cFlg;
	}
	if (cFlg==1){
		//display mrdical record volume status list
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.StatusInfoAVol.List" + "&MrType=" +cMrType+"&No="+cNo+"&Flg="+cFlg;
	}
    parent.RPbottom.location.href=lnk;
}

function SelectRowHandler()	{
	var txtRowid=""
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow){return};
	var SelRowObj=document.getElementById('Rowidz'+selectrow);
	if (SelRowObj){txtRowid=SelRowObj.innerText;}
	else{txtRowid="";}
}

document.body.onload = BodyLoadHandler;

	//javascript remove space
	function LTrim(str){ //remove leading space
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