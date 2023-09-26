//DHCMedBaseSysDicFun.js
//Add onDblClick Handler
//ref:DHCMed_CommonFunc.js,DHCMed_CommonFunction.js 
var objGol 
function CommonSysDic()
{
	//alert("DblClick");
	objGol=event.srcElement;
	//if(objGol)tmpVal1=objGol.name;
	var paras="DicRowid,Code,Desc";
	var Code=objGol.value;
	var Desc=objGol.value;
	paras="2,"+Code+","+Desc 
	LookUp("dDHCMedCReportTempSub","web.DHCMedBaseSysDicCtl:QuerySysDicValues","SetSysDic",paras);
}

function LookUp(id,method,jsfunction,paras)
{
	var url='websys.lookup.csp';
	url += "?ID="+id;
	url += "&CONTEXT=K"+method;
	url += "&TLUJSF="+jsfunction;	
	if (paras!="")
	{
		var list=paras.split(",");
		var i=0;
		for(i=0;i<list.length;i++)
		{
			//var obj=document.getElementById(list[i]);
			//if (obj) url += "&P"+(i+1)+"=" + websys_escape(obj.value);
			url += "&P"+(i+1)+"=" + websys_escape(list[i]);
		}
	}
  //alert(url);
	websys_lu(url,1,'');
	return websys_cancel();
}
function SetSysDic(value){
	var TempPlist=value.split(CHR_Up);
	objGol.valueTempPlist[2]
	//gSetObjValue(tmpVal1,TempPlist[2]);
	//gSetObjValue("AreaCode",TempPlist[1]);
	//alert(tmpVal2);
	//alert(TempPlist);
	}