function BodyLoadHandler()
{
	SetElement("SourceType",GetElementValue("SourceTypeDR"))
	InitPage();
	initButtonWidth()  //hisui改造:修改界面按钮长度不一致 add by lmm 2018-08-20
	// MZY0075	1905653		2021-05-20
	//ui改造 add by hyy 2023-1-31
	initPanelHeaderStyle();
	initButtonColor();
	singlelookup("SourceID","PLAT.L.EquipType",[{name:"Desc",type:1,value:"SourceID"},{name:"GroupID",type:2,value:session['LOGON.GROUPID']},{name:"Flag",type:2,value:'0'},{name:"FacilityFlag",type:2,value:'2'}],"")
	if (GetElementValue("CancelFlag")=="Y")
	{
		DisableBElement("BAdd1",true);
		DisableBElement("BCreate",true);	// MZY0111	2411187		2022-01-14
		HiddenTblColumn("tDHCEQMaintPlanFind","TModify");	// MZY0112	2434107		2022-01-21
	}
	//add by lmm 2020-07-28 1435885
	SetElement("cEQTitle","设备计量计划")
	if ((GetElementValue("MaintTypeDR")=="5")&&(GetElementValue("CancelFlag")=="Y"))
	{
		SetElement("cEQTitle","已作废计量计划查询")
	}
	if (jQuery("#BAdd1").length>0)
	{
		if ((typeof(HISUIStyleCode)!='undefined')&&(HISUIStyleCode=="lite")){
			// 极简版
			if (($("#BAdd1").attr('class')).indexOf("l-btn-disabled")==-1){
				$("#BAdd1").css({"background-color":"#28ba05","color":"#ffffff"})
			}else{
				$("#BAdd1").css({'background-color':'#E5E5E5','color':'#999'})
			}
		}
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
	//add by lmm 2020-12-02
	var obj=document.getElementById("BImport");
	if (obj) obj.onclick=BImport_Click;
	// MZY0076	2021-05-25
	var obj=document.getElementById("BCreate");
	if (obj) obj.onclick=BCreate_Click;
}
//add by lmm 2020-12-02
function BImport_Click()
{
	BImport_IE();
}
//add by lmm 2020-12-02
function BImport_IE()
{
	MaintPlanIDs=""
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets("维护计划单");
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var PlanType=trim(xlsheet.cells(Row,Col++).text);  //计划类型
		var PlanName=trim(xlsheet.cells(Row,Col++).text);  //计划名称
		var FromDate=trim(xlsheet.cells(Row,Col++).text);	//计划开始日期
		var CycleNumDesc=trim(xlsheet.cells(Row,Col++).text);	//维护周期
		var CycleUnit=trim(xlsheet.cells(Row,Col++).text);	//周期单位
		var PreWarnDaysNum=trim(xlsheet.cells(Row,Col++).text);	//提前预警天数
		var EquipRange=trim(xlsheet.cells(Row,Col++).text); //计划范围 设备或设备项
		var EquipRangeList=trim(xlsheet.cells(Row,Col++).text); //指定范围明细
		var CycleType=trim(xlsheet.cells(Row,Col++).text);	//周期类型 1:固定周期,2:固定时间,3:临时计划,4:风险等级 //CZF0134 2021-02-23
		var SDate=trim(xlsheet.cells(Row,Col++).text);	//固定开始日期
		var EDate=trim(xlsheet.cells(Row,Col++).text); 	//固定结束日期
		var MaintFee=trim(xlsheet.cells(Row,Col++).text);  //单台维护费用
		var MeasureDept=trim(xlsheet.cells(Row,Col++).text); //计量部门
		var MeasureHandler=trim(xlsheet.cells(Row,Col++).text); //计量联系人
		var MeasureTel=trim(xlsheet.cells(Row,Col++).text);	//计量联系电话
		
		var CycleTypeID=""		//CZF0134 2021-02-23 begin
		if (CycleType=="固定周期") CycleTypeID=1
		else if (CycleType=="固定时间") CycleTypeID=2
		else if (CycleType=="临时计划") CycleTypeID=3
		else if (CycleType=="风险等级") CycleTypeID=4
		else CycleTypeID=""
		if (CycleTypeID="")
		{
			alertShow("周期类型不能为空!");
		    return 0;
		}
		/*
		if (FixTimeflag=="") var FixTimeflag="N"
		if (FixTimeflag=="是") var FixTimeflag="Y"
		if (FixTimeflag=="否") var FixTimeflag="N"
		*/		//CZF0134 2021-02-23 end

		if (PlanType=="")
		{
			alertShow("计划类型不能为空!");
		    return 0;
		}
		if (PlanName=="")
		{
			alertShow("计划名称不能为空!");
		    return 0;
		}
		if (EquipRange=="")
		{
			alertShow("指定范围类型不能为空!");
		    return 0;
		}
		if (EquipRangeList=="")
		{
			alertShow("指定范围明细不能为空!");
		    return 0;
		}
		if (CycleNumDesc=="")
		{
			alertShow("维护周期不能为空!");
		    return 0;
		}
		if (CycleUnit=="")
		{
			alertShow("维护周期单位不能为空!");
		    return 0;
		}
		if (PreWarnDaysNum=="")
		{
			alertShow("提前预警天数不能为空!");
		    return 0;
		}
		if (FromDate=="")
		{
			alertShow("检测开始日期不能为空!");
		    return 0;
		}
		if (CycleTypeID=="2")		//CZF0134 2021-02-23
		{
			
			if (SDate=="")
			{
				alertShow("固定开始日期不能为空!");
			    return 0;
			}
			if (EDate=="")
			{
				alertShow("固定结束日期不能为空!");
			    return 0;
			}
			if (SDate>EDate)
			{
				alertShow("固定时间范围开始日期大于结束日期,请修正.");
				return 0;
			}
		}
		
		var EquipTypeFlag="N"
		var StatCatFlag="N"
		var LocFlag="N"
		var EquipFlag="N"
		var ItemFlag="N"		
		
		
	 	if (EquipRange="设备")
	 	{
		 	var EQNo=EquipRangeList //设备编号
		 	var EquipRange=5
			var EquipFlag="Y"
		}
		else if (EquipRange="科室")
		{
			var EQUseLoc=EquipRangeList  //使用科室
		 	var EquipRange=4 
			var LocFlag="Y"
		}
		else if (EquipRange="设备项")
		{
			var EQEquipType=$p(EquipRangeList,"&&",1)  //类组
			var EQMasterItem=$p(EquipRangeList,"&&",2)  //设备项
		 	var EquipRange=6 
			var ItemFlag="Y"		
		}
	 	if (PlanType=="计量") {  var PlanTypeDR=2;var MaintTypeDR=5;  }
	 	else if(PlanType=="保养")  {  var PlanTypeDR=1;var MaintTypeDR="";   }
	 	else if(PlanType=="巡检")  {  var PlanTypeDR=2;var MaintTypeDR=4;   }
		var EQMeasureFlag=""
		if ((PlanTypeDR==2)&&(MaintTypeDR==5))
		{
			var EQMeasureFlag="Y"
		}

		var CycleUnitDR=tkMakeServerCall("web.DHCEQImportDataTool","GetCycleUnitID",CycleUnit);
		if (CycleUnitDR=="")
		{
			alertShow("第"+Row+"行 周期单位信息不正确:"+CycleUnit);
			return 0;
		}
		var MeasureDeptDR=""
		if (MeasureDept!="")
		{
			var MeasureDeptDR=tkMakeServerCall("web.DHCEQImportDataTool","GetMeasureDeptID",MeasureDept);
			if (MeasureDeptDR=="")
			{
				alertShow("第"+Row+"行 计量部门信息不正确:"+MeasureDept);
				return 0;
			}
		}
		if (EquipRange==4)
		{
			var EQUseLocDR=tkMakeServerCall("web.DHCEQImportDataTool","GetUseLocID",EQUseLoc);
			if (EQUseLocDR=="")
			{
				alertShow("第"+Row+"行 使用科室信息不正确:"+EQUseLoc);
				return 0;
			}
			var ValueDR=EQUseLocDR
		}
		if (EquipRange==5)
		{
			var EquipDR=tkMakeServerCall("web.DHCEQImportDataTool","GetEquipID",EQNo);
			if (EquipDR=="")
			{
				alertShow("第"+Row+"行 编号设备不存在:"+EQNo);
				return 0;
			}
			var ValueDR=EquipDR
		}
		if ((PlanTypeDR==2)&&(MaintTypeDR=5))
		{
			
			var MeterageFlag=tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute","CheckEquipHaveAttribute","3",EquipDR,"11");
			if (MeterageFlag=="0")
			{
				alertShow("第"+Row+"行 非计量设备:"+EQNo);
				return 0;
			}
			
		}
		
		if (EquipRange==6)
		{
			var EQEquipTypeDR=tkMakeServerCall("web.DHCEQImportDataTool","GetEquipTypeID",EQEquipType);
			if (EQEquipTypeDR=="")
			{
				alertShow("第"+Row+"行 类组信息不正确:"+EQEquipType);
				return 0;
			}
			var ItemDR=tkMakeServerCall("web.DHCEQImportDataTool","GetItemID",EQMasterItem,EQEquipType);
			if (ItemDR=="")
			{
				alertShow("第"+Row+"行 设备项信息不正确:"+EQMasterItem);
				return 0;
			}
			var ValueDR=EQEquipTypeDR
		}
		
		var combindata="";
	  	combindata=""; 
		combindata=combindata+"^"+PlanName ; 
		combindata=combindata+"^"+PlanTypeDR ; 
		combindata=combindata+"^"; 
		combindata=combindata+"^"; 
		combindata=combindata+"^"; 
		combindata=combindata+"^"+"";  //modify by lmm 2018-11-08 743473
		combindata=combindata+"^"+CycleNumDesc; 
		combindata=combindata+"^"+CycleUnitDR; 
		combindata=combindata+"^"+MaintTypeDR; 
		combindata=combindata+"^"+FromDate; 
		combindata=combindata+"^"; //+getElementValue("EndDate") 
		combindata=combindata+"^"+PreWarnDaysNum; 
		combindata=combindata+"^"+MaintFee; 
		combindata=combindata+"^";  //MaintLocDR
		combindata=combindata+"^";  //+getElementValue("MaintUserDR") 
		combindata=combindata+"^";  //+getElementValue("MaintModeDR") 
		combindata=combindata+"^"; //+getElementValue("ContractDR")
		combindata=combindata+"^"; //+getElementValue("MeasureFlag") 
		combindata=combindata+"^"+MeasureDeptDR ; 
		combindata=combindata+"^"+MeasureHandler ; 
		combindata=combindata+"^"+MeasureTel; 
		combindata=combindata+"^";   //+getElementValue("ServiceDR")
		combindata=combindata+"^";  //+getElementValue("ServiceHandler") 
		combindata=combindata+"^";  //+getElementValue("ServiceTel") 
		combindata=combindata+"^";  //+getElementValue("Remark") 
		combindata=combindata+"^"+"2"; //getElementValue("Status") 
		combindata=combindata+"^"+"N";  //getElementValue("InvalidFlag") 
		combindata=combindata+"^"+"" //getElementValue("Hold1"); 
		combindata=combindata+"^"+"" //getElementValue("Hold2"); 
		combindata=combindata+"^"+"" //getElementValue("Hold3"); 
		combindata=combindata+"^"+"" //getElementValue("Hold4"); 
		combindata=combindata+"^"+"" //getElementValue("Hold5"); 
		combindata=combindata+"^"+"" //getElementValue("TotalFee"); 
		combindata=combindata+"^"+"" //getElementValue("TempPlanflag");   //modify by lmm 2019-01-10 802911
		combindata=combindata+"^"+CycleTypeID;   //CZF0134 2021-02-23

		combindata=combindata+"^"+SDate; 
		combindata=combindata+"^"+EDate; 		
			
		EquipRangeval=""
		var EquipRangeval="";
	  	EquipRangeval=""; //getElementValue("EquipRangeDR")
		EquipRangeval=EquipRangeval+"^"  //+getElementValue("RangeDesc"); 
		EquipRangeval=EquipRangeval+"^"+"2"  //getElementValue("SourceType"); 
		EquipRangeval=EquipRangeval+"^"+""     //getElementValue("RowID") ; 
		EquipRangeval=EquipRangeval+"^"+EquipTypeFlag; 
		EquipRangeval=EquipRangeval+"^"+StatCatFlag; 
		EquipRangeval=EquipRangeval+"^N"; 
		EquipRangeval=EquipRangeval+"^"+LocFlag; 
		EquipRangeval=EquipRangeval+"^"+EquipFlag ;
		EquipRangeval=EquipRangeval+"^"+ItemFlag ;
		
		var MaintPlaninfo = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "GetMaintPlanID",combindata,EquipRangeval);
		if (MaintPlaninfo=="")
		{
			//EquipRangevalList=rowData.TRowID+"^"+rowData.TTypeDR+"^"+rowData.TValueDR+"^"+rowData.TAccessFlag
			EquipRangevalList="^"+EquipRange+"^"+ValueDR+"^"+"Y"
			var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "SaveData",combindata,EquipRangeval,EquipRangevalList);
			if (Rtn<0) alertShow("第"+Row+"行 <"+xlsheet.cells(Row,8).text+"> 信息导入失败!!!dddd请载剪该行信息重新整理后再次导入该行信息.");;
			MaintPlanID=Rtn.split("^")[1]
		}
		else
		{
			MaintPlanID=MaintPlaninfo.split("^")[0]
			EquipRangeID=MaintPlaninfo.split("^")[1]
			EquipRangevalList="^"+EquipRange+"^"+ValueDR+"^"+"Y"
			var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSEquipRange", "SaveEquipRangeList",EquipRangeID,EquipRangevalList);
			if (Rtn<0) alertShow("第"+Row+"行 <"+xlsheet.cells(Row,8).text+"> 信息导入失败!!!请载剪该行信息重新整理后再次导入该行信息.");;
		}
		if (MaintPlanIDs=="")
		{
			MaintPlanIDs=MaintPlanID
		}
		else if ((","+MaintPlanIDs+",").indexOf(","+MaintPlanID+",")==-1)
		{
			MaintPlanIDs=MaintPlanIDs+","+MaintPlanID
		}
	}
		messageShow("confirm","","","导入计划单是否审核?","",function(){
			var len=MaintPlanIDs.split(",").length
			for (i=0;i<len;i++)
			{
				var RowID=MaintPlanIDs.split(",")[i]
				var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "SubmitData",RowID);
				if (Rtn<0)
				{
					alertShow("维护计划id："+RowID+" 提交失败:"+Rtn);
					return 0;
				}
				
			}
			xlsheet.Quit;
			xlsheet=null;
			xlBook.Close (savechanges=false);
			xlApp=null;
			alertShow("导入计划信息操作完成!请核对相关信息.");
			window.location.reload();
			return;
		},function(MaintPlanIDs){
			xlsheet.Quit;
			xlsheet=null;
			xlBook.Close (savechanges=false);
			xlApp=null;
			alertShow("导入计划信息操作完成!请核对相关信息.");
			window.location.reload();
			return;
		});	

//			xlsheet.Quit;
//			xlsheet=null;
//			xlBook.Close (savechanges=false);
//			xlApp=null;
//			alertShow("导入计划信息操作完成!请核对相关信息.");
//			window.location.reload();
}



//hisui改造 add by lmm 2018-08-17 begin  切换下拉列表重新定义来源下拉框
///modify by lmm 2018-12-04
$("#SourceType").combobox({
    onChange: function () {
	SourceType_Click()
	var SourceType=$("#SourceType").combobox('getValue')
	if (SourceType==1){    //1:设备类组
		// MZY0075	1905653		2021-05-20
		singlelookup("SourceID","PLAT.L.EquipType",[{name:"Desc",type:1,value:"SourceID"},{name:"GroupID",type:2,value:session['LOGON.GROUPID']},{name:"Flag",type:2,value:'0'},{name:"FacilityFlag",type:2,value:'2'}],"")
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
	var height="710px"  //Modefied by zc0132 2023-03-15 初始化弹窗高度
	if (GetElementValue("MaintTypeDR")=="4")
	{
		url="dhceq.em.inspectplan.csp?"+val
		var title="设备巡检计划"
		height="560px"  //Modefied by zc0132 2023-03-15 巡检重定义弹窗高度
	}
	if (BussType=="1")
	{
		url="dhceq.em.maintplan.csp?"+val
		var title="设备保养计划"
	}
	showWindow(url,title,"",height,"icon-w-paper","modal","","","large");   //Modefied by zc0132 2023-03-15 修改弹窗高度
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
// MZY0076	2021-05-25
function BCreate_Click()
{
	var url="dhceq.em.createmaintplan.csp";
	var title="设备保养计划";	// MZY0099	2198140		2021-11-13
	showWindow(url,title,"","","icon-w-paper","modal","","","large");
}
//add by LMH 20221220 3117341 元素参数重新获取值
function getParam(ID)
{
	if (ID=="EquipTypeDR"){return ''}
}
document.body.onload = BodyLoadHandler;
