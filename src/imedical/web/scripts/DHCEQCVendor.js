
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
	var val="&Code="+GetElementValue("Code");
	val=val+"&Name="+GetElementValue("Name")
	val=val+"&ConPerson="+GetElementValue("ConPerson")
	val=val+"&Tel="+GetElementValue("Tel")
	val=val+"&ShName="+GetElementValue("ShName")
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCVendor"+val;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("Code") ;
	if (GetElementValue("Code")=="") combindata=combindata+GetPYCode(GetElementValue("Name"));
  	combindata=combindata+"^"+GetElementValue("Name") ; 
  	combindata=combindata+"^"+GetElementValue("Address") ;
  	combindata=combindata+"^"+GetElementValue("Province") ;
  	combindata=combindata+"^"+GetElementValue("City") ;
  	combindata=combindata+"^"+GetElementValue("State") ;
  	combindata=combindata+"^"+GetElementValue("ZipCode") ;
  	combindata=combindata+"^"+GetElementValue("ConPerson") ;
  	combindata=combindata+"^"+GetElementValue("Tel") ;
  	combindata=combindata+"^"+GetElementValue("Fax") ;
  	combindata=combindata+"^"+GetElementValue("ShName") ;
  	if (GetElementValue("ShName")=="") combindata=combindata+GetPYCode(GetElementValue("Name"));
  	combindata=combindata+"^"+GetElementValue("Grading") ;
  	combindata=combindata+"^"+GetElementValue("Bank") ;
  	combindata=combindata+"^"+GetElementValue("BankNo") ;
  	combindata=combindata+"^"+GetElementValue("RegistrationNo") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ; 
  	combindata=combindata+"^"+GetElementValue("Hold2") ; 
  	combindata=combindata+"^"+GetElementValue("Hold3") ; 
  	combindata=combindata+"^"+GetElementValue("Hold4") ; 
  	combindata=combindata+"^"+GetElementValue("Hold5") ; 
  	combindata=combindata+"^"+GetElementValue("ExDesc") ;	// Mozy0055	2011-7-7
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	if((GetElementValue("EMail")!="")&&( GetElementValue("EMail").indexOf("@") <= -1 )) //2011-10-27 DJ DJ0097
	{
		alertShow("电子邮件地址有误,请正确输入!")
		return
	}
	
	//modified by ZY 2015-4-27 ZY0125
	var encmeth=GetElementValue("CheckVendorUsed");
	var result=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	if (result==1)
	{
		var truthBeTold = window.confirm("供应商在其他院区用到,确认是否要修改?");
		if (!truthBeTold) return;
	}	
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,"");
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
		alertShow(t[-3001]);
		return
	}
	else
	{
		alertShow("保存成功!");
		location.reload();
	}
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	alertShow(t[-3001])
	return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCVendor');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		Clear();
		disabled(true)//灰化		
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		
		SetData(rowid);//调用函数
		disabled(false)//反灰化
		}
}
function Clear()
{
	SetElement("RowID","");
	SetElement("Code",""); 
	SetElement("Name","");
	SetElement("Address",""); 
	SetElement("Province",""); 
	SetElement("City",""); 
	SetElement("State","");
	SetElement("ZipCode","");
	SetElement("ConPerson","");
	SetElement("Tel","");
	SetElement("Fax","");
	SetElement("ShName","");
	SetElement("Grading","");
	SetElement("Bank","");
	SetElement("BankNo","");
	SetElement("RegistrationNo","");
	SetElement("Remark","");	
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	SetElement("ExDesc","");	// Mozy0055	2011-7-7
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("RowID",rowid);
	SetElement("Code",list[0]); 
	SetElement("Name",list[1]);
	SetElement("Address",list[2]); 
	SetElement("Province",list[3]); 
	SetElement("City",list[4]); 
	SetElement("State",list[5]);
	SetElement("ZipCode",list[6]);
	SetElement("ConPerson",list[7]);
	SetElement("Tel",list[8]);
	SetElement("Fax",list[9]);
	SetElement("ShName",list[10]);
	SetElement("Grading",list[11]);
	SetElement("Bank",list[12]);
	SetElement("BankNo",list[13]);
	SetElement("RegistrationNo",list[14]);
	SetElement("Remark",list[15]);	
	SetElement("Hold1",list[19]);
	SetElement("Hold2",list[20]);
	SetElement("Hold3",list[21]);
	SetElement("Hold4",list[22]);
	SetElement("Hold5",list[23]);
	SetElement("ExDesc",list[17]);	// Mozy0055	2011-7-7
}
function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BDelete",value)
}	
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}

document.body.onload = BodyLoadHandler;
