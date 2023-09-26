//DHCRisEqAddressSet.js
//sunyi 2015-10-22
//var combo_Use

function BodyLoadHandler()
{
	var UpdateObj=document.getElementById("Update");
	if (UpdateObj)
	{
		UpdateObj.onclick=Updateclick;
	}
	
	
    var QueryObj=document.getElementById("Query");
	if(QueryObj)
	{
		QueryObj.onclick=Queryclick;
	}
	
	
	var GetEqRowid=document.getElementById("EqRowid").value;
 	var GetUseMListStr=DHCC_GetElementData('GetEqMethodList');
 	
 	/*
	var UseEqObj=document.getElementById("Eq");
	if(UseEqObj)
	{
		combo_Use=dhtmlXComboFromStr("Eq",GetUseMListStr);
		combo_Use.enableFilteringMode(true);
		
		if (GetEqRowid!="")
		{
			combo_Use.setComboValue(GetEqRowid);
		}
		combo_Use.selectHandle=combo_UseKeydownhandler;
		combo_Use.keyenterHandle=combo_UseKeyenterhandler;
		combo_Use.attachEvent("onKeyPressed",combo_UseKeyenterhandler)
  	}
	*/

}


function seledtEquipment(info)
{
	//alert(info);
	var array=info.split("^");
	document.getElementById("EqRowid").value=array[0];
	document.getElementById("Eq").value=array[2];
}

/*
function combo_UseKeyenterhandler()
{
	
}

function combo_UseKeydownhandler()
{
  var obj=combo_Use;
  var EqRowid=obj.getActualValue();
  document.getElementById("EqRowid").value=EqRowid;
}
*/


function Updateclick()
{
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("未选择记录不能修改!")
		return;
		
	}
	
	var EqDesc=document.getElementById("Eq").value;
	var Adrs=document.getElementById("Address").value
	
    //if((OrdName=="")||(Template==""))
    if(EqDesc=="")
	{
		 var error="设备是否为空!";
		 alert(error);
		 return ;
	}
	
	var Info=SelRowid+"^"+Adrs
	 
	SaveFun(Info)
	
}

function Queryclick()
{
	var EQDR=document.getElementById("EqRowid").value;
	var EqDesc=document.getElementById("Eq").value;
	if (EqDesc=="")
	    document.getElementById("EqRowid").value="";
	    
    return  Query_click();	 
	
}


function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisEqAddressSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

    
 	var SelRowid=document.getElementById("TRowidz"+selectrow).value;
 	var Desc=document.getElementById("TDescz"+selectrow).innerText;
 	
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
		
	}
	
	document.getElementById("EqRowid").value=SelRowid;
	document.getElementById("Eq").value=Desc;
	/*
	var EqIDObj=document.getElementById("EqRowid");
	if(EqIDObj)
	{
		EqIDObj.value=SelRowid;
		if(SelRowid!="")
		{
		  combo_Use.setComboValue(SelRowid);
		}
		else
		{
		  combo_Use.setComboText('');
		}
	}
	*/
	
    if (SelRowid!="")
    {
	    
	    document.getElementById("Address").value=tkMakeServerCall("web.DHCRisCodeTableSet","GetEqAddress",SelRowid);
	}
		
}


function SaveFun(Info)
{
	var value=tkMakeServerCall("web.DHCRisCodeTableSet","EqAddressSet",Info);
	if (value!="0")
	{    
		var Info="保存失败:SQLCODE="+value;
	}
	else
	{   
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisMemoSet";
   		location.href=lnk;*/
   		window.location.reload();
   		
	}
	
}


document.body.onload = BodyLoadHandler;

