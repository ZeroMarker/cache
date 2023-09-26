function BodyLoadHandler()
{
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=Query_click;}
	iniForm();
}
function iniForm()
{	
	var MrType="";
	
	var obj=document.getElementById("MrType");
	if (obj){
		MrType=obj.value;
	}
		
	objMrType = GetDHCWMRDictionaryByID("MethodGetDicItem", MrType);
	if(objMrType != null)
	{
		setElementValue("MrTypeDesc", objMrType.Description);
	}
	
	var obj=document.getElementById("cboItem");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.length=0
		
		var obj1=document.getElementById("ItemStr");
		if (obj1){
			var ItemStr=obj1.value;
			if (ItemStr!==""){
				var xList=ItemStr.split("|");
				var ret="";
				var xSubList;
				var obj2=document.getElementById('MethodGetItem');
			    	if (obj2) {var encmeth=obj2.value} else {var encmeth=''}
			    	for (var i=0;i<xList.length;i++){
			    		ret=cspRunServerMethod(encmeth,xList[i]);
			    		xSubList=ret.split("^");
			    		AddListItem("cboItem",xSubList[2],xSubList[0],i);
			    	}
			    	if (xList.length>0) {obj.selectedIndex=0;}
			}
		}
		
		var ItemId=getElementValue("ItemId",null);
		for (var i=0;i<obj.options.length;i++){
			if (obj.options[i].value==ItemId) obj.selectedIndex=i;
		}
	}
}

function Query_click()
{
	var MrType=getElementValue("MrType",null);
	var ItemStr=getElementValue("ItemStr",null);
	var ItemId=getElementValue("cboItem",null);
	var DateFrom=getElementValue("DateFrom",null);
	var DateTo=getElementValue("DateTo",null);
	var Version=GetParam(window,"Version");
	Version=Version.substr(0,2);//Add by liuxuefeng 2009-06-23 解决Version后会增加"#"的问题
	var QryType=GetParam(window,"QryType");
	
	if (Version=="P5"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.XWorkload.List"+"&MrType=" +MrType+ "&ItemId=" +ItemId+ "&DateFrom=" +DateFrom+ "&DateTo=" +DateTo+ "&QryType=" +QryType+ "&ItemStr=" +ItemStr;
	    	parent.RPbottom.location.href=lnk;
	}else{
		var lnk="dhc.wmr.xworkload.csp?&MrType=" +MrType+ "&ItemId=" +ItemId+ "&DateFrom=" +DateFrom+ "&DateTo=" +DateTo+ "&QryType=" +QryType+ "&ItemStr=" +ItemStr;
	    	location.href=lnk;
	}
}


document.body.onload = BodyLoadHandler;
