
function BodyLoadHandler()
{
	SetElement("SourceType",GetElementValue("SourceTypeDR"))
	InitPage();
	initButtonWidth()  //hisui改造:修改界面按钮长度不一致 add by lmm 2018-08-20
	singlelookup("SourceID","PLAT.L.EquipType","","")  //hisui改造:初始化来源下拉框 add by lmm 2018-08-17   //modify by lmm 2018-12-04
	//add by lmm 2020-05-19 1324470
	if (GetElementValue("CancelFlag")=="Y")
	{
		DisableBElement("BAdd1",true);
	}

}
function InitPage()
{
	
	if (GetElementValue("BussType")==2)
	{
		KeyUp("Name^MaintLoc^SourceID","N");
		Muilt_LookUp("Name^MaintLoc^SourceID","N");
	}
	else
	{
		KeyUp("Name^MaintType^MaintLoc^SourceID","N");
		Muilt_LookUp("Name^MaintType^MaintLoc^SourceID","N");
	}
	
	var obj=document.getElementById("BAdd1");;
	if (obj) obj.onclick=BAdd1_Click;
	
}


//hisui改造 add by lmm 2018-08-17 begin  切换下拉列表重新定义来源下拉框
///modify by lmm 2018-12-04
$("#SourceType").combobox({
    onChange: function () {
	SourceType_Click()
	var SourceType=$("#SourceType").combobox('getValue')
	if (SourceType==1){    //1:设备分类 
		singlelookup("SourceID","PLAT.L.EquipType","","")  
	}
	else if (SourceType==2)
	{    
		singlelookup("SourceID","PLAT.L.StatCat",[{name:"SourceID",type:1,value:"SourceID"},{name:"EquipTypeDR",type:2,value:''},{name:"EquipTypeFlag",type:2,value:'Y'}],"")   //modify by lmm 2019-08-29 990959

	}
	else if (SourceType==4)
	{    
		singlelookup("SourceID","PLAT.L.Loc","","")

	}
	else if (SourceType==6)
	{    
		singlelookup("SourceID","EM.L.GetMasterItem","","")

	}
	else if (SourceType==5) //3:设备
	{
		singlelookup("SourceID","EM.L.Equip","","")
	
	}
  }
})
//hisui改造 add by lmm 2018-08-17 end 
function SourceType_Click()
{    
	SetElement("SourceTypeDR",GetElementValue("SourceType"))
	SetElement('SourceID',"");
	SetElement('SourceIDDR',"");
}

///add by lmm 2018-08-17
///描述：hisui改造 下拉框赋值
///入参：item 选中行json数据
function GetSourceID(item) 
{
	SetElement('SourceIDDR',item.EQRowID);
}

function GetNameID(value)
{
	GetLookUpID('NameDR',value);
}
function GetMaintType(value)
{
	GetLookUpID('MaintTypeDR',value);
}
function GetMaintLoc(value)
{
	GetLookUpID('MaintLocDR',value);
}
function SetEquipCat(id,text)
{
	SetElement('SourceID',text);
	SetElement('SourceIDDR',id);
}
///add by lmm 2018-08-17
///描述：hisui改造 下拉框赋值
///入参：item 选中行json数据
function GetCatID(item) 
{
	SetElement('SourceIDDR',item.ECRowID);
}
///add by lmm 2018-08-17
///描述：hisui改造 下拉框赋值
///入参：item 选中行json数据
function GetMasterItemID(item) 
{
	SetElement('SourceIDDR',item.MIRowID);
}
///add by lmm 2018-10-31 hisui改造：弹窗界面添加
function BAdd1_Click() //GR0026 点击新增后新窗口打开模态窗口
{
	var BussType=GetElementValue("BussType");
	var QXType=GetElementValue("QXType"); 
	var MaintTypeDR=GetElementValue("MaintTypeDR");
	var val="&BussType="+BussType+"&QXType="+QXType+"&MaintTypeDR="+MaintTypeDR;
	url="dhceq.em.meterageplan.csp?"+val
	//add by lmm 2018-01-18 begin
	var title="设备计量计划"
	if (GetElementValue("MaintTypeDR")=="4")
	{
		url="dhceq.em.inspectplan.csp?"+val
		var title="设备巡检计划"
	}
	if (BussType=="1")
	{
		url="dhceq.em.maintplan.csp?"+val
		var title="设备保养计划"
	}
	showWindow(url,title,"","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-05 UI
}
///add by lmm 2019-1-12 804471
///描述：下拉框赋值事件
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	
}
///add by lmm 2019-1-12 804471
///描述：下拉框清除事件
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
		
}

document.body.onload = BodyLoadHandler;
