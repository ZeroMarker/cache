//设备生命周期费用管理
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	
	InitUserInfo();	
	show();	
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAudit",true);
		return;
	}
	
	if(GetElementValue("LFAuditUserDR")=="")
	{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	}
	else
	{
		var obj=document.getElementById("BUpdate");
	if (obj)obj.onclick=YBUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj)obj.onclick=YDelete_Click;
		}
	var obj=document.getElementById("BAudit"); //审核
	if (obj) obj.onclick=BAudit_Click;
	var RowID=GetElementValue("RowID")
	if (RowID=="")
	{
		DisableBElement("BUpdate",false)
		DisableBElement("BDelete",true)
		DisableBElement("BAudit",true)
	}
	 KeyUp("UseLoc^MangerLoc^FeeType^Equip")
	 Muilt_LookUp("UseLoc^MangerLoc^FeeType^Equip");
}
function YDelete_Click()
{
	alertShow(t[-2022])
	}
	function YBUpdate_Click()
{
	alertShow(t[-2021])
	}
function BUpdate_Click() 
{
	if (condition()) return;
	SaveData();
}
function SaveData()
{
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //函数调用
	//alertShow("plist"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result==-1002)alertShow(t[-2011]);
	if (result>0)
	{	
	//location.reload();	
	parent.frames["DHCEQLifeFee"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQLifeFee&RowID='+result;
	}
}
function CombinData()
{
	var combindata="";
   
	combindata=GetElementValue("RowID") ;
	//combindata=combindata+"^"+GetElementValue("EquipDR") ;//设备代码
  	combindata=combindata+"^"+GetElementValue("EquipDR") ; //设备名称1
  	//combindata=combindata+"^"+GetElementValue("MangerLoc") ; //管理科室2
  	combindata=combindata+"^"+GetElementValue("MangerLocDR") ; //管理科室2
  	//combindata=combindata+"^"+GetElementValue("UseLoc") ; //使用科室3
  	combindata=combindata+"^"+GetElementValue("UseLocDR") ; //使用科室3
  	combindata=combindata+"^"+GetElementValue("FeeDate") ; //费用日期4
  	combindata=combindata+"^"+GetElementValue("FeeTypeDR") ; //费用类型5
  	combindata=combindata+"^"+GetElementValue("UseFee") ; //费用6
  	combindata=combindata+"^"+GetElementValue("InvoiceDate") ; //发票日期7
  	combindata=combindata+"^"+GetElementValue("InvoiceDept") ; //开票单位8
  	combindata=combindata+"^"+GetElementValue("InvoiceNo") ; //发票号9
  	combindata=combindata+"^"+GetElementValue("Remark") ; //备注11
  	combindata=combindata+"^"+curUserID;//审核人12
  	return combindata;
}
//////删除
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if(result==-1002){alertShow(t[-2022]);}
	if (result>0) parent.location.href="dhceqlifefee.csp" //	Clear();
}
function Clear()
{
	SetElement("Equip",""); //设备名称
	SetElement("MangerLoc","");//管理科室
	SetElement("UseLoc","");//使用科室
	SetElement("FeeType","");//费用类型
	SetElement("InvoiceDate","");//发票日期
	SetElement("FeeDate","");//费用日期
	SetElement("InvoiceDept","");//开票单位
	SetElement("InvoiceNo","");//发票号
	SetElement("UseFee","");//费用
	SetElement("Remark","");//备注	
	DisableBElement("BDelete",true)	
	DisableBElement("BAudit",true)
	
}
///选择表格行触发此方法
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQLifeFee');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (SelectedRow==selectrow)	{	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetCElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",rowid);
		SetData(rowid);
		}
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	//alertShow(list);
	var sort=14
	SetElement("Equip",list[1]); //设备名称
	SetElement("MangerLoc",list[2]);//管理科室
	SetElement("UseLoc",list[3]);//使用科室
	SetElement("FeeType",list[4]);//费用类型
	SetElement("InvoiceDate",list[5]);//发票日期
	SetElement("FeeDate",list[6]);//费用日期
	SetElement("InvoiceDept",list[7]);//开票单位
	SetElement("InvoiceNo",list[8]);//发票号
	SetElement("UseFee",list[9]);//费用
	SetElement("Remark",list[10]);//备注
}
function sEquip(value)//设备名称
{
	//alertShow(value);
	var obj=document.getElementById("EquipDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+val[1];
}
function FeeTypeDR(value) // 费用类型
{
	//alertShow(value);
	var obj=document.getElementById("FeeTypeDR");
	var val=value.split("^");	
	if (obj) obj.value=val[2];
	//alertShow(val[2]);
}
function show() 
{
    var encmeth=GetElementValue("GetData");
    if (encmeth=="")return;
    var rowid=GetElementValue("RowID") ;
    if (rowid=="")
	{ 
		//Clear()
		return;
	}
    var gbldata=cspRunServerMethod(encmeth,'','',rowid);
    var list=gbldata.split("^");
    //alertShow("list:"+list)
    SetElement("Equip",list[1]); //设备名称
	SetElement("MangerLoc",list[2]);//管理科室
	SetElement("UseLoc",list[3]);//使用科室
	SetElement("FeeType",list[4]);//费用类型
	SetElement("InvoiceDate",list[5]);//发票日期
	SetElement("FeeDate",list[6]);//费用日期
	SetElement("InvoiceDept",list[7]);//开票单位
	SetElement("InvoiceNo",list[8]);//发票号
	SetElement("UseFee",list[9]);//费用
	SetElement("Remark",list[10]);//备注
	SetElement("FeeTypeDR",list[11]);//类型代码
	SetElement("EquipDR",list[12]);//设备名称代码
	SetElement("UseLocDR",list[13]);//使用科室代码
	SetElement("MangerLocDR",list[14]);//管理科室代码
	SetElement("LFAuditUserDR",list[15]);//审核人
	if(list[15]=="") //审核
	{
		DisableBElement("BUpdate",false)
		DisableBElement("BDelete",false)
		DisableBElement("BAudit",false)
		}
		else{
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)
		DisableBElement("BAudit",true)
			}
	if (list[16]=="N") //是否人工录入 
	{
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)
		DisableBElement("BAudit",true)
		}
}
function BAudit_Click() //审核
{
	var encmeth=GetElementValue("GetUpdate1");
	if (encmeth=="")return;
	//var plist=CombinDataBAudit(); //函数调用
	var plist=GetElementValue("RowID") ;
   plist=plist+"^"+curUserID;
   //alertShow(plist)
   if (plist=="") { alertShow(t[-4005])}
	var result=cspRunServerMethod(encmeth,'','',plist);//plist=var
	if (result==-1003)
	{	
	alertShow(t[-1003])	
	return
	}
	if (result>0)location.reload();
}
function MangerLocDR(value) // 管理科室
{
	//alertShow(value);
	var obj=document.getElementById("MangerLocDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1])
}

function UseLocDR(value) // 使用科室
{
	//alertShow(value);
	var obj=document.getElementById("UseLocDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}
function disabled(value)//反灰化
{
	//InitEvent();
	DisableBElement("BAudit",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BUpdate",value)
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(1,"Equip")) return true;
	if (CheckItemNull(1,"UseLoc")) return true;
	if (CheckItemNull(0,"UseFee")) return true;
	if (CheckItemNull(0,"FeeDate")) return true;
	if (CheckItemNull(1,"FeeType")) return true;
	*/
	return false;
}

document.body.onload = BodyLoadHandler;