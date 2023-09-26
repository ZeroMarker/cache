var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //系统参数
	InitEvent();	
	disabled(true);//灰化
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	
	if (opener)
	{
		var obj=document.getElementById("BClose")
		if (obj) obj.onclick=CloseWindow;
	}
	else
	{
		EQCommon_HiddenElement("BClose")
	}
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BAdd_Click() //增加
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow(t[-3001])
		return
	}
	else
	{
	   location.reload();
	}	
}	
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("MTIRowID") ;
	combindata=combindata+"^"+GetElementValue("MTIMaintDR") ;
  	combindata=combindata+"^"+GetElementValue("MTIMaintPartDR") ; 
  	combindata=combindata+"^"+GetElementValue("MTIMaintItemDR") ;
  	combindata=combindata+"^"+GetElementValue("MTIMaintUserDR") ;
  	combindata=combindata+"^"+GetElementValue("MTIMaintState") ;
  	combindata=combindata+"^"+GetElementValue("MTIRemark") ; 
  	combindata=combindata+"^"+GetElementValue("MaintRequestDR") ;
  	combindata=combindata+"^"+GetElementValue("MTIHold2") ;
  	combindata=combindata+"^"+GetElementValue("MTIHold3") ;
  	combindata=combindata+"^"+GetElementValue("MTIHold4") ;
  	combindata=combindata+"^"+GetElementValue("MTINormalFlag") ;
  	combindata=combindata+"^"+GetElementValue("MTIMaintContent") ;
  	combindata=combindata+"^"+GetElementValue("MTIResult") ;
  	combindata=combindata+"^"+GetElementValue("MTIProviderDR") ;
  	combindata=combindata+"^"+GetElementValue("MTIStep") ;
  	combindata=combindata+"^"+GetElementValue("MTIHold5") ;
  	combindata=combindata+"^"+GetElementValue("MTIMaintFee") ;
  	combindata=combindata+"^"+GetElementValue("MTITotalFee") ;
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
	alertShow(t[-3001]);
	return
	}
	else 
	{
		location.reload();	
	}
}
function BDelete_Click() 
{
	var rowid=GetElementValue("MTIRowID");
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	alertShow(t[-3001])
	return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n");
	if (result==0) 
	{
		location.reload();	
	}
}
///选择表格行触发此方法
function SelectRowHandler()
	{
	var Status=GetElementValue("Status");
	if (Status!=1) return;
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQMMaintItem');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		Clear();
		disabled(true);//灰化	
		SelectedRow=0;
		rowid=0;
		SetElement("MTIRowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TMTIRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false);//反灰化
		}
}
function Clear()
{
	SetElement("MTIRowID","")
	SetElement("MTIMaintPart",""); 
	SetElement("MTIMaintItem","");
	SetElement("MTIMaintContent","");
	SetElement("MTIResult","");
	SetElement("MTIMaintFee","");
	SetElement("MTIRemark","");
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");

	var sort=21;
	SetElement("MTIRowID",list[0]); 
	SetElement("MTIMaintDR",list[1]); 
	SetElement("MTIMaintPartDR",list[2]); 
	SetElement("MTIMaintPart",list[sort+0]);
	SetElement("MTIMaintItemDR",list[3]);
	SetElement("MTIMaintItem",list[sort+1]);
	SetElement("MTIMaintUserDR",list[4]);
	SetElement("MTIMaintState",list[5]);
	SetElement("MTIRemark",list[6]);
	SetElement("MTIMaintRequestDR",list[7]);
	SetElement("MTIHold2",list[8]);
	SetElement("MTIHold3",list[9]);
	SetElement("MTIHold4",list[10]);
	SetElement("MTINormalFlag",list[11]);
	SetElement("MTIMaintContent",list[12]);
	SetElement("MTIResult",list[13]);
	SetElement("MTIProviderDR",list[14]);
	SetElement("MTIProvider",list[sort+2]);
	SetElement("MTIStep",list[15]);
	SetElement("MTIHold5",list[16]);
	SetElement("MTIMaintFee",list[17]);
	SetElement("MTITotalFee",list[18]);
}
function disabled(value)//灰化
{
	InitEvent();
	var Status=GetElementValue("Status");
	if (Status==1)
	{
		DisableBElement("BUpdate",value);
	    DisableBElement("BDelete",value);	
	    DisableBElement("BAdd",!value);
	}
	else
	{
		DisableBElement("BUpdate",value);
	    DisableBElement("BDelete",value);	
	    DisableBElement("BAdd",value);
	}	

}	
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
function GetMaintPart(value)
{
	GetLookUpID('MTIMaintPartDR',value);
}
function GetMaintItem(value)
{
	GetLookUpID('MTIMaintItemDR',value);
}

document.body.onload = BodyLoadHandler;


