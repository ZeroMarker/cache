// DHCEQCLocation.js
// Mozy0034
// 2010-12-2
var SelectedRow = -1;  //hisui改造：修改开始行号  add by wy 2018-09-01
var rowid=0;
var HospFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051")
//装载页面  函数名称固定
function BodyLoadHandler()
{
	$("body").parent().css("overflow-y","hidden");  //add by wy 2018-10-11 hiui-改造 去掉y轴 滚动条
	$("#tDHCEQCLocation").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //add by wy 2018-10-12 hisui改造：隐藏翻页条内容
	InitUserInfo(); //系统参数
	InitEvent();
	disabled(true);
	initButtonWidth();  //hisui改造 add by wy 2018-09-01
	//add by lmm 2021-06-25 begin
	KeyUp("Hospital^Loc^Building^BuildingUnit");
	Muilt_LookUp("Hospital^Loc^Building^BuildingUnit"); 
	initBDPHospComponent("DHC_EQCLocation");	//CZF0138 多院区改造
	if (HospFlag=="2") DisableElement("Hospital",true);
	//modify by lmm 2021-07-09
	if (GetElementValue("SpaceFlag")=="2")
	{
		setRequiredElements("Building^BuildingUnit")
	}
	else if (GetElementValue("SpaceFlag")=="0")
	{
		HiddenObj("cBuilding","1")
		HiddenObj("Building","1")
		HiddenObj("cBuildingUnit","1")
		HiddenObj("BuildingUnit","1")
		
	}
	//add by lmm 2021-06-25 begin
	//add by lmm 2021-07-09
	$('input#BuildingUnit').on('keyup',function(){
		disableElement("Loc",false);
	})
}

//CZF0138 平台医院组件选择事件
function onBDPHospSelectHandler()
{
	BClear_Click();
	SetElement("Hospital",GetElementValue("_HospList"));	//czf 2021-11-2
	SetElement("HospitalDR",GetBDPHospValue("_HospList"));
	initLocationGrid();
}

//CZF0138
function initLocationGrid()
{
	var HospDR=GetBDPHospValue("_HospList");
	$("#tDHCEQCLocation").datagrid( {
		url:$URL,
		queryParams:{
			ComponentID:GetElementValue("GetComponentID"),
			gHospId:curSSHospitalID,
			BDPHospId:HospDR
		},
		showRefresh:false,
		showPageList:false,
		afterPageText:'',
		beforePageText:''
	})
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
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	//Add by ZY 2015-4-9 ZY0125
	var obj=document.getElementById("Hold1Desc");
	if (obj) obj.onkeyup=Hold1Desc_KeyUp;
	var obj=document.getElementById("Hold2Desc");
	if (obj) obj.onkeyup=Hold2Desc_KeyUp;
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("Code");
  	combindata=combindata+"^"+GetElementValue("Desc");
  	combindata=combindata+"^"+GetElementValue("Type");
  	//modify by lmm 2021-06-25 begin
  	combindata=combindata+"^"+GetElementValue("HospitalDR");
  	combindata=combindata+"^"+GetElementValue("LocDR");
  	combindata=combindata+"^"+GetElementValue("BuildingDR");
  	combindata=combindata+"^"+GetElementValue("BuildingUnitDR");
  	combindata=combindata+"^"+GetElementValue("Place");
  	combindata=combindata+"^"+GetElementValue("DateActiveFrom");
  	combindata=combindata+"^"+GetElementValue("DateActiveTo");
  	combindata=combindata+"^"+GetElementValue("Remark");
  	combindata=combindata+"^"+GetElementValue("Hold1");
  	combindata=combindata+"^"+GetElementValue("Hold2");
  	combindata=combindata+"^"+GetElementValue("Hold3");
  	combindata=combindata+"^"+GetElementValue("Hold4");
  	combindata=combindata+"^"+GetElementValue("Hold5");
  	//modify by lmm 2021-06-25 end
  	return combindata;
}
function BAdd_Click() //添加
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist,'0',curSSHospitalID,GetBDPHospValue("_HospList"));
	result=result.replace(/\\n/g,"\n");
	if(result=="")
	{
		alertShow("当前记录已存在,操作失败!");
		return
	}
	if (result>0)
	{
		alertShow("新增成功!")
		location.reload();
	}	
}
function BUpdate_Click() //修改
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist,'0',curSSHospitalID,GetBDPHospValue("_HospList"));
	result=result.replace(/\\n/g,"\n");
	if(result=="") 
	{
		alertShow("当前记录已存在,操作失败!");
		return;
	}
	if (result>0)
	{
		alertShow("更新成功!")
		location.reload();
	}
}
function BDelete_Click() //删除
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm("确定删除该记录?");
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	var result=cspRunServerMethod(encmeth,'','',rowid,'1',curSSHospitalID,GetBDPHospValue("_HospList"));
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("删除成功!")
		location.reload();
	}	
}
function BFind_Click()
{
	var val="&Code="+GetElementValue("Code");
	val=val+"&Desc="+GetElementValue("Desc");
	val=val+"&HospitalDR="+GetElementValue("HospitalDR");
	val=val+"&LocDR="+GetElementValue("LocDR");
	val=val+"&Hospital="+GetElementValue("Hospital");
	val=val+"&Loc="+GetElementValue("Loc");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCLocation" +val;
}

function BClear_Click() 
{
	Clear();
	disabled(true);
}


///hisui改造： add by wy 2018-09-01
function SelectRowHandler(index,rowdata){
	if (index==SelectedRow){
		Clear();
		SelectedRow= -1;
		disabled(true); 
		$('#tDHCEQCLocation').datagrid('unselectAll'); 
		return;
		}
		
	SetData(rowdata.TRowID); 
	disabled(false)  
    SelectedRow = index;
}

function Clear()
{
	SetElement("RowID","");
	SetElement("Code","");
	SetElement("Desc","");
	SetElement("Type","");
	SetElement("Area","")
	SetElement("Address","");
	SetElement("ManageLocDR","");
	SetElement("ManageLoc","");
	SetElement("ManageUserDR","");
	SetElement("ManageUser","");
	SetElement("PurposeTypeDR","");
	SetElement("PurposeType","");
	SetElement("EquipDR","");
	SetElement("Equip","");
	SetElement("Floor","");
	SetElement("DateActiveFrom","");
	SetElement("DateActiveTo","");
	SetElement("Remark","");
	
	//Add by ZY 2015-4-27 ZY0125
	SetElement("Hold1Desc","");
	SetElement("Hold1","");
	SetElement("Hold2Desc","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
  	//modify by lmm 2021-06-25 begin
	SetElement("LocDR","");
	SetElement("Loc","");
	SetElement("BuildingDR","");
	SetElement("Building","");
	SetElement("BuildingUnitDR","");
	SetElement("BuildingUnit","");
	SetElement("HospitalDR","");
	SetElement("Hospital","");
  	//modify by lmm 2021-06-25 end
	SetElement("Place","");   //modfiy by lmm 2021-08-03 2054181
}

function SetData(RowID)
{
	//modify by lmm 2021-06-25 begin
	SetElement("RowID",RowID);  //hisui改造：RowID赋值 add by wy  2018-09-01
	var sort=17
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',RowID);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	//messageShow("","","",gbldata)
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("Code",list[1]);
	SetElement("Desc",list[2]);
	SetElement("Type",list[3]);
  	
	SetElement("HospitalDR",list[4])
	SetElement("Hospital",list[sort+1]);
	SetElement("LocDR",list[5]);
	SetElement("Loc",list[sort+2]);
	SetElement("BuildingDR",list[6]);
	SetElement("Building",list[sort+3]);
	SetElement("BuildingUnitDR",list[7]);
	SetElement("BuildingUnit",list[sort+4]);
	SetElement("Place",list[8]);
	SetElement("DateActiveFrom",list[9]);
	SetElement("DateActiveTo",list[10]);
	SetElement("Remark",list[12]);
	SetElement("Hold1",list[13]);
	SetElement("Hold2",list[14]);
	SetElement("Hold3",list[15]);
	SetElement("Hold4",list[16]);
	SetElement("Hold5",list[17]);
  	//modify by lmm 2021-06-25 end
}

function GetPurposeType (value)
{
    GetLookUpID("PurposeTypeDR",value);
}
function GetManageUser (value)
{
    GetLookUpID("ManageUserDR",value);
}
function GetEquip(value)
{
	var list=value.split("^");
	var obj=document.getElementById('EquipDR');
	obj.value=list[1];
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
//add by lmm 2021-06-22
function GetHospital(value)
{
	var obj=document.getElementById("HospitalDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
//add by lmm 2021-06-22
function GetBuilding(value)
{
	var obj=document.getElementById("BuildingDR");
	var val=value.split("^");
	//modify by lmm 2021-07-09	
	if (obj) obj.value=val[0];
	var obj=document.getElementById("Building");
	if (obj) obj.value=val[1];
}
//add by lmm 2021-06-22
function GetBuildingUnit(value)
{
	var obj=document.getElementById("BuildingUnitDR");
	var val=value.split("^");	
	if (obj) obj.value=val[0];
	var obj=document.getElementById("BuildingUnit");
	if (obj) obj.value=val[4];
	disableElement("Loc",true);  //add by lmm 2021-07-09
	
}
function Hold1Desc_KeyUp()
{
	var obj=document.getElementById("Hold1");	
	if (obj) obj.value="";
}
//add by lmm 2021-06-22
function GetLocID(value)
{
	var obj=document.getElementById("LocDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}

function Hold2Desc_KeyUp()
{
	var obj=document.getElementById("Hold2");	
	if (obj) obj.value="";
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
