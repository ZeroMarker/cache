var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //系统参数
	InitEvent();	
	KeyUp("BussType");	//清空选择
	Muilt_LookUp("BussType");
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
	var obj=document.getElementById("BFind")
	if (obj) obj.onclick=BFind_Click;
}
function BFind_Click()
{
	var val="&BussTypeDR="+GetElementValue("BussTypeDR");
	val=val+"&Code="+GetElementValue("Code");
	val=val+"&Desc="+GetElementValue("Desc");
	val=val+"&IsNomalFlag="+GetElementValue("IsNomalFlag");
	val=val+"&Remark="+GetElementValue("Remark")
	val=val+"&InvalidFlag="+GetElementValue("InvalidFlag")
	val=val+"&Hold1="+GetElementValue("Hold1")
	val=val+"&Hold2="+GetElementValue("Hold2")
	val=val+"&Hold3="+GetElementValue("Hold3")
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCModel"+val;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BAdd_Click() //增加
{
	if (condition()) return;
	var encmeth=GetElementValue("upd");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,0,plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow(t[-3001])
		return
		}
	if (result>0)location.reload();	
}	
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("BussTypeDR") ;//
	combindata=combindata+"^"+GetElementValue("Code") ;//
  	combindata=combindata+"^"+GetElementValue("Desc") ; //
	combindata=combindata+"^"+GetChkElementValue("IsNomalFlag") ;//
  	combindata=combindata+"^"+GetElementValue("Remark") ; //
	combindata=combindata+"^"+GetChkElementValue("InvalidFlag") ;//
  	combindata=combindata+"^"+GetElementValue("Hold1") ; //
  	combindata=combindata+"^"+GetElementValue("Hold2") ; //
  	combindata=combindata+"^"+GetElementValue("Hold3") ; //
  	  	
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("upd");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,1,plist);
	result=result.replace(/\\n/g,"\n")
	//alertShow("result"+result)
	if(result=="") 
	{
		alertShow(t[-3001]);
		return
	}
	if (result>0) location.reload();	
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("upd");
	if (encmeth=="") 
	{
	alertShow(t[-3001])
	return;
	}
	var result=cspRunServerMethod(encmeth,2,rowid);
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCMessagesResult');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	
	{
		Clear();
		disabled(true);//灰化	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",rowid);
		SetData(rowid);//调用函数
		disabled(false);//反灰化
	}
}
function Clear()
{
	SetElement("RowID","")
	SetElement("BussType",""); 
	SetElement("BussTypeDR",""); 
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("IsNomalFlag","");
	SetElement("Remark","");
	SetElement("InvalidFlag","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("BussType",list[9]); //
	SetElement("BussTypeDR",list[0]); //
	SetElement("Code",list[1]);//
	SetElement("Desc",list[2]);//
	SetChkElement("IsNomalFlag",list[3]);//
	SetElement("Remark",list[4]); 
	SetChkElement("InvalidFlag",list[5]); 
	SetElement("Hold1",list[6]); 
	SetElement("Hold2",list[7]);
	SetElement("Hold3",list[8]);
	
}
function GetBussTypeID(value) // ItemDR
{
    GetLookUpID("BussTypeDR",value);
}
function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}	
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
document.body.onload = BodyLoadHandler;