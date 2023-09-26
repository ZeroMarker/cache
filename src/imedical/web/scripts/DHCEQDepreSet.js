/// 修改:zy 2010-07-22    No ZY0026
/// ----------------------------------
var SelectedRow = 0;
function BodyLoadHandler() 
{
	InitUserInfo();
	InitMessage();
	InitEvent();
	FillDepreType();
	//FillData();
	DepreType_Change()
	SetEnabled()
  	KeyUp("DepreMethod^CostAllotType")
  	Muilt_LookUp("DepreMethod^CostAllotType");
}

function InitEvent()
{
	var obj=document.getElementById("BUpdate");//更新
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");//删除
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BAudit");//审核
	if (obj) obj.onclick=BAudit_Click;
	var obj=document.getElementById("DepreType");
	if (obj) obj.onchange=DepreType_Change;
}
function BUpdate_Click() 
{
	if (condition()) return;
	var DepreMethodCode=GetElementValue("DepreMethodCode")
	if (DepreMethodCode=="01")  //平均年限法
	{
		if (GetElementValue("Years")=="")
		{
			alertShow("年限不能为空")
			return
		}
	}
	Type=GetElementValue("Type");
	if (Type=="1")
	{
		var truthBeTold = window.confirm(t[-1000]);
   		if (!truthBeTold) return;
	}
	var AutoAudit=GetElementValue("Audit");
	if (AutoAudit=="Y")
	{
		var truthBeTold = window.confirm(t[-1001]);
   		if (!truthBeTold) return;
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'0',Type);
	result=result.replace(/\\n/g,"\n")
	if(result<0)
	{
		alertShow(t[-3001])
		return
	}
	else if (result>0)
	{
		var link="&PreSourceType="+GetElementValue("PreSourceType");
		link=link+"&PreSourceID="+GetElementValue("PreSourceID");
		link=link+"&Flag="+GetElementValue("Flag");
		link=link+"&DepreTypeDR="+GetElementValue("DepreTypeDR");
		link=link+"&SourceTypeDR="+GetElementValue("SourceTypeDR");
		link=link+"&SourceIDDR="+GetElementValue("SourceIDDR");
		link=link+"&RowID="+result
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSet'+link;
	}
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="")return;
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSet'+"&Flag="+GetElementValue("Flag");
	}
}

function BAudit_Click()
{
	rowid=GetElementValue("RowID");
	if (rowid=="")return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result<0)
	{
		alertShow(t[-3001])
		return
	}
	else if (result>0)
	{
		var link="&PreSourceType="+GetElementValue("PreSourceType");
		link=link+"&PreSourceID="+GetElementValue("PreSourceID");
		link=link+"&Flag="+GetElementValue("Flag");
		link=link+"&DepreTypeDR="+GetElementValue("DepreTypeDR");
		link=link+"&SourceTypeDR="+GetElementValue("SourceTypeDR");
		link=link+"&SourceIDDR="+GetElementValue("SourceIDDR");
		link=link+"&RowID="+result
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSet'+link;
	}
}

function BDetail_Click()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSetDetail&DepreSetDR='+GetElementValue("RowID")+"&Flag="+GetElementValue("Flag");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=500,left=120,top=0')
}

function BDepreAllot_Click()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCostAllot&EquipDR='+GetElementValue("SourceIDDR")+'&Types=1'
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=500,left=120,top=0')
}

function FillDepreType()
{
	var depretypeinfos=GetElementValue("DepreTypeInfos");
	var obj=document.getElementById("DepreType");
	var depretypelist=depretypeinfos.split("&");
	var typeids=GetElementValue("DepreTypeDR");
	if (typeids!="") typeids=","+typeids+",";
	for (var i=0;i<depretypelist.length;i++)
	{
		var list=depretypelist[i].split("^");
		obj.options.add(new Option(list[1],list[4],true,true));		
		if (typeids.indexOf(","+list[4]+",")>-1)
		{
			obj.options[i].selected=true;	
		}
		else
		{	obj.options[i].selected=false;	}
	}
}

function Clear()
{
    SetElement("EquipName",""); 
	SetElement("DepreMethodDR","");
	SetElement("DepreMethod","");
	SetElement("MainFlag","");
	SetElement("AutoFlag","");
	SetElement("PreDepreMonth","");
	SetElement("CostAllotTypeDR","");
	SetElement("CostAllotType","");
	SetElement("CostAllotDR","");
	SetElement("CostAllot","");
	SetElement("Remark","");
	SetElement("Status","");
	SetElement("DepreTotalFee","");
	SetElement("Years","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	SetElement("DepreMethodCode","")
}
function FillData()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="")return;
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")return;
	var Ret=cspRunServerMethod(encmeth,RowID);
	Ret=Ret.replace(/\\n/g,"\n");
	list=Ret.split("^");
	var sort=29
	SetElement("EquipNameDR",list[0]);
	SetElement("EquipName",list[sort]);
	SetElement("DepreMethodDR",list[1]);
	SetElement("DepreMethod",list[sort+1]);
	SetChkElement("MainFlag",list[sort+2]);
	SetChkElement("AutoFlag",list[sort+3]);
	SetElement("PreDepreMonth",list[4]);
	SetElement("CostAllotTypeDR",list[5]);
	SetElement("CostAllotType",list[sort+4]);
	SetElement("CostAllotDR",list[6]);
	SetElement("Remark",list[7]);
	SetElement("Status",list[8]);
	SetElement("DepreTypeDR",list[18]);
	//SetElement("DepreType",list[sort+3]);
	SetElement("SourceTypeDR",list[19]);
	SetElement("SourceType",list[sort+6]);
	SetElement("SourceIDDR",list[20]);
	SetElement("SourceID",list[sort+7]);	
	SetElement("DepreTotalFee",list[22]);
	SetElement("Years",list[23]);
	SetElement("Hold1",list[24]);
	SetElement("Hold2",list[25]);
	SetElement("Hold3",list[26]);
	SetElement("Hold4",list[27]);
	SetElement("Hold5",list[28]);
	SetElement("DepreMethodCode",list[sort+8]);
}
function CombinData()
{
	var combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("EquipNameDR") ;		//2设备名称
  	combindata=combindata+"^"+GetElementValue("DepreMethodDR") ; 	//3折旧方法
  	combindata=combindata+"^"+GetChkElementValue("MainFlag") ; 		//4主标志
  	combindata=combindata+"^"+GetChkElementValue("AutoFlag") ; 		//5自动记入折旧标志
  	combindata=combindata+"^"+GetElementValue("PreDepreMonth") ; 	//6上次折旧月份
  	combindata=combindata+"^"+GetElementValue("CostAllotTypeDR") ; 	//7成本分配类型
  	combindata=combindata+"^"+GetElementValue("Remark") ;		 	//8备注
   	combindata=combindata+"^"+curUserID;			 	//9审核人
  	combindata=combindata+"^"+GetElementValue("DepreTypeDR") ;		//10
  	combindata=combindata+"^"+GetElementValue("SourceTypeDR") ;		//11
  	combindata=combindata+"^"+GetElementValue("SourceIDDR") ;		//12
  	combindata=combindata+"^"+GetElementValue("DepreTotal") ;		//13
  	combindata=combindata+"^"+GetElementValue("DepreTotalFee") ;	//14
  	combindata=combindata+"^"+GetElementValue("Years") ;		 	//15
  	combindata=combindata+"^"+GetElementValue("Hold1") ;		 	//16
  	combindata=combindata+"^"+GetElementValue("Hold2") ;		 	//17
  	combindata=combindata+"^"+GetElementValue("Hold3") ;		 	//18
  	combindata=combindata+"^"+GetElementValue("Hold4") ;		 	//19
  	combindata=combindata+"^"+GetElementValue("Hold5") ;		 	//20
  	combindata=combindata+"^"+GetElementValue("Audit") ;		 	//是否自动审核
  	return combindata;
}

function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
function GetEquipNameID(value)//设备名称
{
	GetLookUpID('EquipNameDR',value);
}
function GetDepreMethodDR(value)//折旧方法
{
	var val=value.split("^");
	var obj=document.getElementById("DepreMethodDR");
	if (obj)	{	obj.value=val[1];}
	else {alertShow("DepreMethodDR");}
	var obj=document.getElementById("DepreMethodCode");
	if (obj)	{	obj.value=val[2];}
	else {alertShow("DepreMethodCode");}
	ChangeStlyeByDepreMethodCode('')
}
function GetCostAllotTypeID(value)
{
	GetLookUpID('CostAllotTypeDR',value);
}
function DepreType_Change()
{
	var SourceTypeDR=GetElementValue("SourceTypeDR");	//来源类型和来源ID
	var PreSourceType=GetElementValue("PreSourceType");
	var SourceIDDR=GetElementValue("SourceIDDR");
	var PreSourceID=GetElementValue("PreSourceID");
	var list=""
	var RowID=GetElementValue("RowID");
	
	var value=GetSelectedElementValue("DepreType",1);	//折旧类型
	SetElement("DepreTypeDR",value);
	var DepreTypeDR=GetElementValue("DepreTypeDR");
	//alertShow(DepreTypeDR+"^"+SourceTypeDR+"^"+SourceIDDR)
	if ((DepreTypeDR=="")||(SourceTypeDR=="")||(SourceIDDR==""))return;
	var Str=DepreTypeDR+"^"+SourceTypeDR+"^"+SourceIDDR
	var encmeth=GetElementValue("GetRowID");
	if (encmeth=="")return;
	var Ret=cspRunServerMethod(encmeth,Str);			//取折旧设置
	var list=Ret.split("^");
	//alertShow(list)
	SetElement("RowID",list[0]);
	SetElement("Type",list[1]);
		
	FillData();
	if (list!="")
	{
		if (list[1]==1)
		{
			SetElement("SourceTypeDR",SourceTypeDR);
			SetElement("SourceIDDR",SourceIDDR);
			SetElement("Status","");
		}
		else if (list[1]=="")
		{
			SetElement("SourceType",PreSourceType);
			SetElement("SourceID",PreSourceID);
			Clear();
		}
	}
	ChangeStlyeByDepreMethodCode(1)  //折旧方法的变化
	ChangeStlyeByDepreType()  //折旧设置类型的变化
}
function ChangeStlyeByDepreMethodCode(flag)
{
	ReadOnlyElement("CostAllotType",true);
	ReadOnlyElement("Years",true);
	DisableBElement("BDetail",true);
	var DepreMethodCode=GetElementValue("DepreMethodCode")
	if (DepreMethodCode=="01")  //平均年限法
	{
		ReadOnlyElement("Years",false);
	}
	else if (DepreMethodCode=="02") //不计提折旧
	{
	}
	else if (DepreMethodCode=="03")  //折旧率折旧
	{
		ReadOnlyElement("CostAllotType",false);
		ReadOnlyElement("Years",false);
	}
	else if (DepreMethodCode=="04") //一次性折旧
	{
	}
	if (flag=="")
	{
		SetElement("CostAllotTypeDR","");
		SetElement("CostAllotType","");
		SetElement("Years","");
	}
	
}
function ChangeStlyeByDepreType()
{
	var Status=GetElementValue("Status")
	if (Status=="1") 
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BAudit",true);
	}
	else 
	{
		DisableBElement("BUpdate",false);
		DisableBElement("BAudit",false);
		var obj=document.getElementById("BUpdate");
		if (obj) obj.onclick=BUpdate_Click;
		var obj=document.getElementById("BAudit");
		if (obj) obj.onclick=BAudit_Click;
	}
}
function SetEnabled()
{
	ButtonDisable()
	var Status=GetElementValue("Status")
	var CanUpdate=GetElementValue("CanUpdate")
	if (Status=="1")
	{
		if (CanUpdate=="N")
		{
			DisableBElement("BDetail",true);
			DisableBElement("BDepreAllot",true);
		}
		DisableBElement("BUpdate",true);
		DisableBElement("BAudit",true);
	}
	var Flag=GetElementValue("Flag")		//更新和审核按钮的显示
	if (Flag=="0")
	{
		EQCommon_HiddenElement("BAudit");
	}
	else if (Flag=="1")
	{
		EQCommon_HiddenElement("BUpdate");
	}
	var SourceTypeDR=GetElementValue("SourceTypeDR")	//设备分类的折旧设置界面显示
	if (SourceTypeDR=="1")  //分类
	{
		EQCommon_HiddenElement("CostAllotType");
		EQCommon_HiddenElement("cCostAllotType");
		EQCommon_HiddenElement("ld50718iCostAllotType");
		EQCommon_HiddenElement("BDepreAllot");
		SetElement("CostAllotTypeDR",0);
	}
}
function ButtonDisable()
{
	var CostAllotTypeDR=GetElementValue("CostAllotTypeDR") 	//成本分配方案的变化
	if (CostAllotTypeDR=="2")
	{
		DisableBElement("BDepreAllot",false);
		var obj=document.getElementById("BDepreAllot");
		if (obj) obj.onclick=BDepreAllot_Click;
	}
	else
	{
		DisableBElement("BDepreAllot",true);
	}
	var DepreMethodCode=GetElementValue("DepreMethodCode") 	//折旧方法的变化
	if (DepreMethodCode=="03")
	{
		if (GetElementValue("Type")==0) DisableBElement("BDetail",false);
		var obj=document.getElementById("BDetail");
		if (obj) obj.onclick=BDetail_Click;
	}
	else
	{
		DisableBElement("BDetail",true);
	}
}

document.body.onload = BodyLoadHandler;