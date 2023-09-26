//设备变动信息 

function BodyLoadHandler() 
{
	KeyUp("EquipName^ChangeType")	//清空选择
	Muilt_LookUp("EquipName^ChangeType");
	SetLink();
	//ChangeTypelnk();
//var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQLifeFeeFind'	
//var obj=document.getElementById('tDHCEQChangeInfoFind');
//	if (obj) {obj.ondblclick=DB_Clicked;}//双击
 //var obj=document.getElementById('tDHCEQChangeInfoFind');
	//if (obj) obj.onclick=ChangeTypelnk;//单击	
	
}

function KeyUp1(Value)
{
	var value=Value.split("^")
	var i=0;
	for (i=0;i<value.length;i++)
	{
		var obj=document.getElementById(value[i]);
		if (obj) {obj.onchange=Standard_KeyUp1;}
		else{
		alertShow(value[i])}
	}
}
function Standard_KeyUp1()
{
	var eSrc=window.event.srcElement;
	var objDR=document.getElementById(eSrc.id+"DR");
	var obj=document.getElementById(eSrc.id);
	objDR.value="";	
	obj.value="";

}
function SetLink()
{
	var SelRowObj;
	var objtbl=document.getElementById('tDHCEQChangeInfoFind');
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		SelRowObj=document.getElementById('TChangeTypez'+i);
		SelRowObj.onclick=lnk_Click;//调用
		SelRowObj.href="#";
	}	
}
function lnk_Click()
{
	var eSrc=window.event.srcElement;	//获取事件源头
	var row=GetRowByColName(eSrc.id);//调用
	var lnk=GetHref(row);//调用
	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}
function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}
function GetHref(row)//TChangeTypez TRowIDz
{
	var SelRowObj=document.getElementById('TEquipDRz'+row);
	var TypeObj=document.getElementById('TEquipNameDRz'+row);
	var TypeObjid=document.getElementById('TChangeTypeidDRz'+row);
	var para="RowID"
	var lnk="";
	if(TypeObjid.value==1)//启用DHCEQStart
	{ComponentName="DHCEQStart"}
	else if(TypeObjid.value==2)//封存DHCEQStop
	{ComponentName="DHCEQStop"}
	else if(TypeObjid.value==3)//调配DHCEQMove
	{ComponentName="DHCEQMove"}
	else if(TypeObjid.value==4)//调拨DHCEQMoveOut
	{ComponentName="DHCEQMoveOut"}
 	else if(TypeObjid.value==5)//调帐DHCEQChangeAccount
	{ComponentName="DHCEQChangeAccount"	}
 	else if(TypeObjid.value==6)//报废DHCEQDisuseRequest
	{ComponentName="DHCEQDisuseRequest"	;
	 para="EquipDR";	}
 	else if(TypeObjid.value==7)//年限变更
	{ComponentName="DHCEQChangeYears"	}
	
	lnk=ComponentName+'.csp?'+'&'+para+'='+SelRowObj.value;//+'&ChangeType='+ChangeType+'&EquipNameDR='+EquipNameDR;
	return lnk;
}
/*
function ChangeTypelnk()
{
	alertShow("33");
	var eSrc=window.event.srcElement;
	alertShow("eSrc"+"/"+eSrc);
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var obj=document.getElementById('TEquipNameDRz'+selectrow);//变动类型代码
	alertShow("obj.value"+"/"+obj.value);
	var EquipNameDR=obj.value;//隐藏
	alertShow("EquipNameDR"+"/"+EquipNameDR);
	var obj=document.getElementById('TEquipDRz'+selectrow);//设备名称代码
	var EquipDR=obj.value;//隐藏
	if(EquipNameDR==1)//启用DHCEQStart
	{
	ComponentName="DHCEQStart"
	}
	else if(EquipNameDR==2)//封存DHCEQStop
	{
		ComponentName="DHCEQStop"
	}
	else if(EquipNameDR==3)//调配DHCEQMove
	{
		ComponentName="DHCEQMove"
		}
	else if(EquipNameDR==4)//调拨DHCEQMoveOut
	{
		ComponentName="DHCEQMoveOut"
		}
 	else if(EquipNameDR==5)//调帐DHCEQChangeAccount
	{
		ComponentName="DHCEQChangeAccount"
		}
 	else if(EquipNameDR==6)//报废DHCEQDisuseRequest
	{
		ComponentName="DHCEQDisuseRequest"
		}
 	else if(EquipNameDR==7)//年限变更
	{
		ComponentName="DHCEQChangeYears"
		}
		
	alertShow("ComponentName"+ComponentName);
var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+omponentName
        +"&EquipDR="+iEquipDR
 window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=680,left=130,top=0');

	}
/*
function DB_Clicked()
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var obj=document.getElementById('TEquipNameDRz'+selectrow);
	var EquipNameDR=obj.value;//隐藏
	var obj=document.getElementById('TChangeTypez'+selectrow);//变动类型
	var ChangeType=obj.innerText;//显示
	var obj=document.getElementById('TEquipNameDRz'+selectrow);//变动类型代码
	var EquipNameDR=obj.value;//隐藏
	var obj=document.getElementById('TEquipDRz'+selectrow);//设备名称代码
	var EquipDR=obj.value;//隐藏
	if(EquipNameDR==1)//启用DHCEQStart
	{ComponentName="DHCEQStart"	}
	else if(EquipNameDR==2)//封存DHCEQStop
	{	ComponentName="DHCEQStop"	}
	else if(EquipNameDR==3)//调配DHCEQMove
	{	ComponentName="DHCEQMove"		}
	else if(EquipNameDR==4)//调拨DHCEQMoveOut
	{	ComponentName="DHCEQMoveOut"		}
 	else if(EquipNameDR==5)//调帐DHCEQChangeAccount
	{	ComponentName="DHCEQChangeAccount"		}
 	else if(EquipNameDR==6)//报废DHCEQDisuseRequest
	{	ComponentName="DHCEQDisuseRequest"		}
 	else if(EquipNameDR==7)//年限变更
	{	ComponentName="DHCEQChangeYears"	}
 	var str='websys.default.csp?WEBSYS.TCOMPONENT='+ComponentName+'&EquipDR='+EquipDR;//+'&ChangeType='+ChangeType+'&EquipNameDR='+EquipNameDR;
     window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=680,left=130,top=0');
}
*/
function ChangeTypeDR(value) // 变动类型
{
	//alertShow(value);
	var obj=document.getElementById("ChangeTypeDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
}
function EquipNameDR(value) // 变动类型
{
	//alertShow(value);
	var obj=document.getElementById("EquipNameDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
}
document.body.onload = BodyLoadHandler;