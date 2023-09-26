/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.StatusInfoB.Qry

AUTHOR: ZhuFei , Microsoft
DATE  : 2007-4


========================================================================= */
function BodyLoadHandler()
{
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=Query_click;}
	iniForm();
}
function iniForm()
{
	////////////////add by liuxuefeng 2009-06-11/////////////////////
	var MrTypeDr=document.getElementById("MrType").value;
	objMrType = GetDHCWMRDictionaryByID("MethodGetDicItem", MrTypeDr);
	if(objMrType != null)
	{
		setElementValue("MrTypeDesc", objMrType.Description);
	}
	/////////////////////////////////////////////////////////////////
	var SysDate=new Date();
	var SysMonth=SysDate.getMonth()+1;
	var DateStr=SysDate.getDate()+"/"+SysMonth+"/"+SysDate.getFullYear();
	var obj=document.getElementById("txtDateFrom");
	if (obj){
		obj.value=DateStr;
	}
	var obj=document.getElementById("txtDateTo");
	if (obj){
		obj.value=DateStr;
	}
	
	var obj=document.getElementById("cboWorkItem");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		
		var oOption = document.createElement("OPTION");
        oOption.text=t["WorkItemAll"];
        oOption.value=0;
        obj.add(oOption);
        obj.selectedIndex=-1;
	}
}

function Query_click()
{
	var cFlg="",cDateFrom="",cDateTo="",cWorkItem="",cUserFrom="",cUserTo="",cWardID="";
	var MrTypeDr=document.getElementById("MrType").value;	//add by liuxuefeng 2009-06-12
	var obj=document.getElementById("txtDateFrom");
	if (obj){
		cDateFrom=obj.value;
	}
	
	var obj=document.getElementById("txtDateTo");
	if (obj){
		cDateTo=obj.value;
	}
	
	var obj=document.getElementById("cboWorkItem");
	if (obj){
		var Idx=obj.options.selectedIndex;
		if (Idx>-1){
			cWorkItem=obj.options[Idx].value;
			if (cWorkItem<1){cWorkItem=""}
		}
	}
	
	var obj=document.getElementById("txtUserFrom");
	if (obj){
		if (Trim(obj.value)!=""){
			obj=document.getElementById("txtUserFromId");
			if (obj){
				cUserFrom=obj.value;
			}
		}
	}
	
	var obj=document.getElementById("txtUserTo");
	if (obj){
		if (Trim(obj.value)!=""){
			obj=document.getElementById("txtUserToId");
			if (obj){
				cUserTo=obj.value;
			}
		}
	}
	//add by liuxuefeng 2009-07-14
	var obj=document.getElementById("txtWard");
	if (Trim(obj.value)!=""){
				cWardID=document.getElementById("txtWardID").value;
	}

	if (cDateFrom==""){alert(t['DateFromFalse']);return;}
	if (cDateTo==""){alert(t['DateToFalse']);return;}
	if (CompareDate(cDateFrom,cDateTo)){alert(t['CompareDate']);return;}
  //add MrType by liuxuefeng 2009-06-12,add cWardID 2009-07-14
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.StatusInfoB.List"+"&DateFrom="+cDateFrom+"&DateTo="+cDateTo+"&UserFrom="+cUserFrom+"&UserTo="+cUserTo+"&WorkItem="+cWorkItem+"&Flg=2"+"&MrType="+MrTypeDr+"&DisWardID="+cWardID;
  parent.RPbottom.location.href=lnk;
}

function LookUpUserFrom(str)
{
	var objUserFromId=document.getElementById('txtUserFromId');
	var objUserFrom=document.getElementById('txtUserFrom');
	var tem=str.split("^");
	objUserFromId.value=tem[0];
	//objUserFrom.value=tem[2]+" "+tem[1];
	objUserFrom.value=tem[2];
}

function LookUpUserTo(str)
{
	var objUserToId=document.getElementById('txtUserToId');
	var objUserTo=document.getElementById('txtUserTo');
	var tem=str.split("^");
	objUserToId.value=tem[0];
	//objUserTo.value=tem[2]+" "+tem[1];
	objUserTo.value=tem[2];
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
	//add by liuxuefeng 2009-07-14
	function LookupWard(str)
{
	var objWardID=document.getElementById('txtWardID');
	var tem=str.split("^");
	objWardID.value=tem[1];
}