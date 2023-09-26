
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo();
	InitEvent();	
	KeyUp("Model^ManuFactory","N");
	Muilt_LookUp("Model^ManuFactory","N");
	disabled(true);//灰化
}
function InitEvent()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function CombinData()
{
	var combindata="";
	combindata=combindata+GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("BuyReqListDR");
	combindata=combindata+"^"+GetElementValue("Name");
	combindata=combindata+"^"+GetElementValue("ModelDR");
	combindata=combindata+"^"+GetElementValue("Model");
	combindata=combindata+"^"+GetElementValue("ManuFactoryDR");
	combindata=combindata+"^"+GetElementValue("ManuFactory");
	combindata=combindata+"^"+GetChkElementValue("FirstFlag");
	combindata=combindata+"^"+GetElementValue("Hold1");
	combindata=combindata+"^"+GetElementValue("Hold2");
	combindata=combindata+"^"+GetElementValue("Hold3");
	combindata=combindata+"^"+GetElementValue("Hold4");
	combindata=combindata+"^"+GetElementValue("Hold5");
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("SaveData");
	if (encmeth=="") return;
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,plist,GetElementValue("BuyReqListDR"),"0");
	result=result.replace(/\\n/g,"\n")
	if(result==0) 
	{
		location.reload();	
	}
	else
	{
		alertShow(t[-3001]);
		return
	}
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("SaveData");
	if (encmeth=="") 
	{
		alertShow(t[-3001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'','1');
	result=result.replace(/\\n/g,"\n")
	if (result==0) location.reload();	
}

function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQBuyReqListAlter');//+组件名 就是你的组件显示 Query 结果的部分
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
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false);//反灰化
		}
}
function Clear()
{
	SetElement("RowID","")
	SetElement("Name",""); 
	SetElement("ModelDR","");
	SetElement("Model","");
	SetElement("ManuFactoryDR","");
	SetElement("ManuFactory","");
	SetElement("FirstFlag","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("RowID",rowid); //rowid
	SetElement("Name",list[1]); //
	SetElement("ModelDR",list[2]); //
	SetElement("Model",list[3]);//
	SetElement("ManuFactoryDR",list[4]);//
	SetElement("ManuFactory",list[5]);//
	SetElement("FirstFlag",list[6]);//
	SetElement("Hold1",list[7]);//
	SetElement("Hold2",list[8]);//
	SetElement("Hold3",list[9]);//
	SetElement("Hold4",list[10]);//
	SetElement("Hold5",list[11]);//
}
function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BDelete",value)
	if (GetElementValue("ReadOnly")!=0)
	{
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)
	}
}	
function condition()//条件
{
	if (CheckMustItemNull("ManuFactory^Model")) return true;
	var obj=document.getElementById("cModel");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetModelOperMethod")==0)
		{
			if (CheckItemNull(1,"Model")==true) return true;
		}
		else
		{
			if (CheckItemNull("","Model")==true) return true;
		}
	}
	var obj=document.getElementById("cManuFactory");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetManuFactoryOperMethod")==0)
		{
			if (CheckItemNull(1,"ManuFactory")==true) return true;
		}
		else
		{
			if (CheckItemNull("","ManuFactory")==true) return true;
		}		
	} 
	return false;
}
document.body.onload = BodyLoadHandler;
