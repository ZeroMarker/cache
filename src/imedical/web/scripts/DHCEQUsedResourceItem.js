var SelectedRow = 0;
var parentId="";	

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQUsedResourceItem');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	Selected(selectrow);
}

function Selected(selectrow)
{	
	InitPage();		
	if (SelectedRow==selectrow)	{			
		SelectedRow=0;		
		Clear()	
		//取消选取记录后:添加 可用 
		if(parentId!="")
		{
			DisableBElement("BAdd",false);
			DisableBElement("BUpdate",true);
			DisableBElement("BDelete",true);						
		}
	}
	else
	{		
		//选取记录后:新增不可用
		if(parentId!="")
		{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",false);
		DisableBElement("BDelete",false);		
		}	
		SelectedRow=selectrow;		
		SetData(SelectedRow);		
	}
	if (GetElementValue("GetStatus")=="1")
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BAdd",true);
			//DisableBElement("Bdetail",false);
			DisableBElement("BDelete",true);
		}				
}

function SetData(index)
{	
	var rowidstr=GetElementValue("TRowIDz"+SelectedRow);
	var feestr=GetCElementValue("TUsedFeez"+SelectedRow);
	var resourceTypestr=GetCElementValue("TResourceTypez"+SelectedRow);
	var resourceTypeDrstr=GetElementValue("TResourceTypeDRz"+SelectedRow);
	var remarkstr=GetCElementValue("TRemarkz"+SelectedRow);
	SetElement("RowID",rowidstr);
	SetElement("ResourceType",resourceTypestr);
	SetElement("ResourceTypeDR",resourceTypeDrstr);
	SetElement("UsedFee",feestr);
	SetElement("Remark",remarkstr);	
}

function BodyLoadHandler() 
{	
	//主表ID
	parentId=GetElementValue("UsedResourceDR");	
	InitUserInfo();	
	Clear();
	InitPage();
	KeyUp("ResourceType");
	Muilt_LookUp("ResourceType");
	if(parentId=="")
		{	//全部不可用		
			DisableBElement("BAdd",true);
			DisableBElement("BUpdate",true);
			DisableBElement("BDelete",true);
		}
		else
		{
			//add 可用 			
			DisableBElement("BAdd",false);
			DisableBElement("BUpdate",true);
			DisableBElement("BDelete",true);			
		}
	if (GetElementValue("GetStatus")=="1")
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BAdd",true);
			//DisableBElement("Bdetail",false);
			DisableBElement("BDelete",true);
		}	
}
///初始化页面
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(1,"ResourceType")) return true;
	if (CheckItemNull(2,"UsedFee")) return true;
	*/
	return false;
}
function InitPage()
{		
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
}
function BClose_Click()
{
	window.close();
}
//==========Clice Star
function BAdd_Click() 
{
	if (CheckNull()) return;	
	var encmeth=GetElementValue("GetExecMethod");
	var sqlVal="";
	var result="";
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}		
	//URI_UsedResourceDR,URI_ResourceTypeDR,URI_UsedFee,URI_Remark
	sqlVal=parentId + "^" + GetElementValue("ResourceTypeDR") + "^" + GetElementValue("UsedFee") + "^" + GetElementValue("Remark");
	result=cspRunServerMethod(encmeth,"0",GetElementValue("RowID"),sqlVal);
	
	if (result=="0")
	{
		location.reload();
	}
	else
	{
		alertShow(result);
	}
}
	     
function BUpdate_Click() 
{
	if (CheckNull()) return;	
	var encmeth=GetElementValue("GetExecMethod");
	var sqlVal="";
	var result="";
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}		
	if(GetElementValue("RowID")!="")
	{		
		//URI_ResourceTypeDR,URI_UsedFee,URI_Remark
		sqlVal=GetElementValue("ResourceTypeDR") + "^" + GetElementValue("UsedFee") + "^" + GetElementValue("Remark");
		result=cspRunServerMethod(encmeth,"1",GetElementValue("RowID"),sqlVal);
	}	
	if (result=="0")
	{
		location.reload();
	}
	else
	{
		alertShow(result);
	}
}

function BDelete_Click()
{
	var sqlStr="";	
	if (GetElementValue("RowID")=="")	{
		alertShow(t['04']);
		return;
	}
	var truthBeTold = window.confirm(t['03']);
    if (truthBeTold) {	    
	    var encmeth=GetElementValue("GetExecMethod");
		if (encmeth=="")
		{
			alertShow(t[-4001]);
			return;
		}		
		var result=cspRunServerMethod(encmeth,"2",GetElementValue("RowID"),"");
		if (result=="0")
		{
			location.reload();
		}
		else
		{
			alertShow('删除失败!');			
		}
    }
}
//==========Clice end

function Clear()
{	
	SetElement("RowID","");
	SetElement("ResourceType","");
	SetElement("ResourceTypeDR","");
	SetElement("UsedFee","");
	SetElement("Remark","");	
}
function GetResourceTypeID(value)
{
	GetLookUpID("ResourceTypeDR",value)
}

document.body.onload = BodyLoadHandler;
