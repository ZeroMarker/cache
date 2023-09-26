
function iniForm()
{
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=Query_click;}
	var obj=document.getElementById("cboDateTp");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		
		obj.length=0;
		var objItm1=document.createElement("OPTION");
		obj.options.add(objItm1);
		objItm1.innerText ="入院日期";
		objItm1.value = 0;
		var objItm2=document.createElement("OPTION");
		obj.options.add(objItm2);
		objItm2.innerText ="出院日期";
		objItm2.value = 1;
		
		obj.selectedIndex=0;
	}
}

function Query_click() {
	
	var cDateTp="",cDateFrom="",cDateTo="";
	var obj=document.getElementById("cboDateTp");
	if (obj){
		cDateTp=obj.options.selectedIndex;
		if (cDateTp<0) return;
	}
	
	var obj=document.getElementById("txtDateFrom");
	if (obj){cDateFrom=obj.value;}
	
	var obj=document.getElementById("txtDateTo");
	if (obj){cDateTo=obj.value;}
	
	if (((cDateTp!==0)&&(cDateTp!==1))||(cDateFrom=="")||(cDateTo=="")) return;
	
	  var MrType=document.getElementById("MrType").value;
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.XVolume.List"+"&DateType="+cDateTp+"&FromDate="+cDateFrom+"&ToDate="+cDateTo+ "&MrType=" +MrType;
	  parent.RPbottom.location.href=lnk;
}

iniForm();