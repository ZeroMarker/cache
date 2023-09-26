/* ======================================================================
AUTHOR: wuqk , Microsoft
DATE  : 2007-7
========================================================================= */
function BodyLoadHandler()
{
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=Query_click;}
	iniForm();
}
function iniForm()
{	
	var MrTypeDr=""
	
	var obj=document.getElementById("MrType");
	if (obj){
				MrTypeDr=obj.value;
		}
		
	objMrType = GetDHCWMRDictionaryByID("MethodGetDicItem", MrTypeDr);
	if(objMrType != null)
	{
		setElementValue("txtMrType", objMrType.Description);
	}
	
}

function Query_click()
{
	var MrType="",ItemDr="",DateFrom="",DateTo=""
	
	
	var obj=document.getElementById("MrType");
	if (obj){
		MrType=obj.value;
	}
	var obj=document.getElementById("ItemDr");
	if (obj){
		ItemDr=obj.value;
	}
	var obj=document.getElementById("DateFrom");
	if (obj){
		DateFrom=obj.value;
	}
	var obj=document.getElementById("DateTo");
	if (obj){
		DateTo=obj.value;
	}
		
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.XRecpt.List"+"&MrType=" +MrType+ "&ItemDr=" +ItemDr+ "&DateFrom=" +DateFrom+ "&DateTo=" +DateTo
    parent.RPbottom.location.href=lnk;
}


document.body.onload = BodyLoadHandler;
