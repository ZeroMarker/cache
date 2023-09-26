function BodyLoadHandler() {
    var obj=document.getElementById("cmdQuery");
	  if (obj) obj.onclick=Query_click;
	}

function List_click() {
    var obj=document.getElementById("ItemDetails");
    //alert(gGetListCodes("WorkDetails"));
	  ///obj.value=gGetListCodes("WorkDetails");
	  ///alert(obj.value);
	}
function Query_click() {
    var obj=document.getElementById("ItemDetails");
    var ItemDetails=gGetListCodes("WorkDetails");
	  if (ItemDetails==""){
	  	alert(t["02"]);
	  	return false;
	  	}
	  obj.value=ItemDetails;
	  var dFrom=gGetObjValue("dFrom");
	  var dTo=gGetObjValue("dTo");
	  if ((dFrom=="")||(dTo=="")){
	  	alert(t["01"]);
	  	return false;
	  	}
	  var MrTypeDr=getElementValue("MrType");//modify by liuxuefeng 2010-02-19
	  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.XDtl.List&ItemDetails="+ItemDetails+"&dFrom="+dFrom+"&dTo="+dTo+"&MrTypeDr="+MrTypeDr;
    location.href=lnk;
	}

document.body.onload = BodyLoadHandler;