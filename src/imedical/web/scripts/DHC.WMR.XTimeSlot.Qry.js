/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.XTimeSlot.Qry.JS

AUTHOR: ZhuFei , Microsoft
DATE  : 2007-6
========================================================================= */
function BodyLoadHandler()
{
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=Query_click;}
	iniForm();
}
function iniForm()
{
	var SysDate=new Date();
	var SysMonth=SysDate.getMonth()+1;
	var DateStr=SysDate.getDate()+"/"+SysMonth+"/"+SysDate.getFullYear();
	var obj=document.getElementById("txtFromDate");
	if (obj){
		obj.value=DateStr;
	}
	var obj=document.getElementById("txtToDate");
	if (obj){
		obj.value=DateStr;
	}
	/*
	var obj=document.getElementById("cboMrType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.selectedIndex=-1;
	}
	*/
	var obj=document.getElementById("cboFirstStatus");
	if (obj){
		obj.size=1;
		obj.multiple=false;
        obj.selectedIndex=-1;
	}
	
	var obj=document.getElementById("cboSecondStatus");
	if (obj){
		obj.size=1;
		obj.multiple=false;
        obj.selectedIndex=-1;
	}
	
	MakeComboBox("cboNote");
	AddListItem("cboNote", "<", "<");
	AddListItem("cboNote", ">", ">");
	AddListItem("cboNote", "=", "=");
}

function Query_click()
{
	var cMrType="",cFirstStatus="",cSecondStatus="",cDateFrom="",cDateTo="",cTimeSlot="",cNote="",cCondition=""
	cMrType=GetParam(parent, "MrType")

	var obj=document.getElementById("cboFirstStatus");
	if (obj){
		var Idx=obj.options.selectedIndex;
		if (Idx>-1){
			cFirstStatus=obj.options[Idx].value;
			if (cFirstStatus<1){cFirstStatus=""}
		}else{
			cFirstStatus="";
		}
	}
	
	var obj=document.getElementById("cboSecondStatus");
	if (obj){
		var Idx=obj.options.selectedIndex;
		if (Idx>-1){
			cSecondStatus=obj.options[Idx].value;
			if (cSecondStatus<1){cSecondStatus=""}
		}else{
			cSecondStatus="";
		}
	}
	
	var obj=document.getElementById("txtFromDate");
	if (obj){
		cDateFrom=obj.value;
	}
	
	var obj=document.getElementById("txtToDate");
	if (obj){
		cDateTo=obj.value;
	}
	
	if (cDateFrom==""){return;}
	if (cDateTo==""){return;}
	if (CompareDate(cDateFrom,cDateTo)){alert(t['CompareDate']);return;}
	
	var obj=document.getElementById("txtTimeSlot");
	if (obj){
		cTimeSlot=Trim(obj.value);
	}

	var obj=document.getElementById("cboNote");
	if (obj){
		var Idx=obj.options.selectedIndex;
		if (Idx>-1){
			cNote=obj.options[Idx].value;
		}
	}
	
	
	if ((cFirstStatus!="")&&(cSecondStatus!="")){
		cCondition=cMrType+"^"+cFirstStatus+"^"+cSecondStatus+"^"+cDateFrom+"^"+cDateTo+"^"+cTimeSlot+"^"+cNote;

		var obj=document.getElementById("MethodGetTimeSlot");
    	if (obj) {var encmeth=obj.value} else {var encmeth=''}
    	var ret=cspRunServerMethod(encmeth,cCondition);
		if (ret==""){return;}
	
		//JIndex_"^"_DischargeCount_"^"_VolumeCount_"^"_AccordCount_"^"_AveTimeSlot
		var temp=ret.split("^");
		if (temp.length<5){return;}
		var JIndex=temp[0];
		if (JIndex==""){return;}

		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.XTowItmTimeSlot.List"+"&JIndex="+JIndex+"&DischargeCount="+temp[1]+"&VolumeCount="+temp[2]+"&AccordCount="+temp[3]+"&AveTimeSlot="+temp[4];
	}else{
		if (cFirstStatus!=""){
			cStatus=cFirstStatus;
		}else{
			cStatus=cSecondStatus;
		}
		if (cStatus=="") return;
		cCondition=cMrType+"^"+cStatus+"^"+cDateFrom+"^"+cDateTo+"^"+cTimeSlot+"^"+cNote;
		var obj=document.getElementById("MethodOneItemTimeSlot");
    	if (obj) {var encmeth=obj.value} else {var encmeth=''}
    	var ret=cspRunServerMethod(encmeth,cCondition);
		if (ret==""){return;}
	
		//JIndex_"^"_MainCount_"^"_VolCount_"^"_CountSun_"^"_MainAccordCount_"^"_VolAccordCount_"^"_AccordCountSun_"^"_MainTimeSlot_"^"_VolTimeSlot_"^"_AveTimeSlot
		var temp=ret.split("^");
		if (temp.length<10){return;}
		var JIndex=temp[0];
		if (JIndex==""){return;}
	
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.XOneItmTimeSlot.List"+"&JIndex="+JIndex+"&MainCount="+temp[1]+"&VolCount="+temp[2]+"&CountSun="+temp[3]+"&MainAccordCount="+temp[4]+"&VolAccordCount="+temp[5]+"&AccordCountSun="+temp[6]+"&MainTimeSlot="+temp[7]+"&VolTimeSlot="+temp[8]+"&AveTimeSlot="+temp[9];
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

function CompareDate(d1,d2)
{
	var Tmp1=d1.split("/");
	var Tmp2=d2.split("/");
	d1=Tmp1[2]+"/"+Tmp1[1]+"/"+Tmp1[0]
	d2=Tmp2[2]+"/"+Tmp2[1]+"/"+Tmp2[0]
 	return ((new Date(d1)) > (new Date(d2)));
}

function LTrim(str){
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