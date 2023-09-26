Class web.DHCEQIUsedRecord Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// *******************************************************************
/// *******************************************************************
/// 效益分析系统接口采集数据
/// *******************************************************************
/// *******************************************************************
/// 采集设备使用记录接口
/// 按天定时采集，采集前一天的使用记录
ClassMethod GatherAll()
{
	s GatherDate=+$H-1
	d ..GatherDHCLIS(GatherDate)
}

/// 采集DHC-Lis的相关使用记录,获取某一天的检验设备使用信息，存放在websource下的
/// ^DHCEQTemp("GatherUseRecord",ExType,$j,Item,Device,Row)
/// 其中ExType为"DHC-LIS","DHC-RIS"等，Item为医嘱项，Device为设备
/// 存储数据为StartDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_TotalFee_"^"_Price_"^"_ExID
/// 		  开始日期，开始时间，结束日期，结束时间，工作量，工作量单位，使用科室，患者信息，总费用，单价，医嘱id(检验为报告id)	
/// w ##Class(web.DHCEQIUsedRecord).GatherDHCLIS(61193)
ClassMethod GatherDHCLIS(GatherDate)
{
	n (GatherDate)
	
	s ExType="DHC-LIS"
	s SourceType=1	;类型为设备
	
	s tmpDate=$ZD(GatherDate,3)
	s Year=$p(tmpDate,"-",1)
	s Month=$p(tmpDate,"-",2)		
	s IsInputFlag="N"	;系统采集,非手工录入
	//Modefied by zc 2018-12-21 zc0047  将Status修改为LIStatus，避免任务挂起
	s LIStatus=2		;系统自动采集的自动置为审核状态
	s InvalidFlag="N"
	s Remark=""
	
	;记录采集结果开始时间
	s Count=0
	s Version=$o(^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,""),-1)
	s Version=1+Version
	s ErrCode=""
	s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"BeginTime")=$H
	
	s Job=$j
	
	s Info=##Class(web.DHCEQIUsedRecord).GetLISUseRecord(GatherDate)
	
	;取做的项目
	s Item=0
	f  s Item=$o(^DHCEQTemp("GatherUseRecord",ExType,Job,Item))  quit:(Item="")  d 
	.;s ServiceItemDR=$o(^DHCEQCCode("DHCEQCServiceItem",0,"ExID",ExType,Item,0))
	.s ServiceItemDR=..GetServiceByExID(ExType,Item)
	.
	.;取设备
	.s Device=""
	.f  s Device=$o(^DHCEQTemp("GatherUseRecord",ExType,Job,Item,Device))  quit:(Device="")  d
	..s ErrCode=""
	..
	..s SourceID=..GetEquipByDevice(ExType,Device)
	..
	..i SourceID="" s ErrCode="DeviceNoMap"
	..
	..;如果未定义服务项,则需自动生成服务项目
	..i ((ServiceItemDR="")&&(ErrCode=""))  d
	...
	...s ServiceItemDR=##Class(web.DHCEQIUsedRecord).AutoSaveServiceItem(ExType,Item,GatherDate)
	...i ServiceItemDR=""  s ErrCode="NoServiceItem"
	..
	..
	..i SourceID'="" s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)	
	..s Row=0
	..f  s Row=$o(^DHCEQTemp("GatherUseRecord",ExType,Job,Item,Device,Row))  quit:(Row="")  d 
	...s Val=^DHCEQTemp("GatherUseRecord",ExType,Job,Item,Device,Row)
	...
	...
	...;SourceType
	...;SourceID
	...s UseDate=$p(Val,"^",1)
	...i UseDate'="" s UseDate=$ZD(UseDate,4)
	...s StartTime=$p(Val,"^",2)
	...i StartTime'="" s StartTime=$zt(StartTime)
	...s EndDate=$p(Val,"^",3)
	...i EndDate'="" s EndDate=$ZD(EndDate,4)
	...s EndTime=$p(Val,"^",4)
	...i EndTime'="" s EndTime=$zt(EndTime)
	...s WorkLoadNum=$p(Val,"^",5)
	...s WorkLoadUnitDR=""
	...i ServiceItemDR'="" s WorkLoadUnitDR=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",3)
	...s UseLocDR=$p(Val,"^",7)
	...i ((UseLocDR="")&&(SourceID'="")) s UseLocDR=$p($g(^DHCEQEquip(SourceID)),"^",19)
	...s PatientInfo=$p(Val,"^",8)
	...s TotalFee=$p(Val,"^",9)
	...s Price=$p(Val,"^",10)
	...i Price=""  d
	....;s Price=##class(web.UDHCJFPRICE).GetOrderPrice("", "",Item, GatherDate, "", "", "", "")
	....;s Price=$p(Price,"^",1)
	....s Price=..GetServicePriceByExID(ExType,Item, GatherDate)
	....i TotalFee="" s TotalFee=Price
	...;s Year=
	...;s Month=
	...;s ServiceItemDR
	...;s ExType
	...s ExID=$p(Val,"^",11)
	...;s IsInputFlag
	...;s Status=2
	...;s InvalidFlag="N"
	...;s Remark=""
	...;
	...s ModelDR=""
	...i SourceID'="" s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
	...;//Modefied by zc 2018-12-21 zc0047  将Status修改为LIStatus，避免任务挂起
	...s Val=SourceType_"^"_SourceID_"^"_UseDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_Price_"^"_TotalFee_"^"_Year_"^"_Month_"^"_ServiceItemDR_"^"_ExType_"^"_ExID_"^"_IsInputFlag_"^"_LIStatus_"^"_InvalidFlag_"^"_Remark_"^^^^^^^"_ModelDR
	...
	...;记录结果
	...s Count=Count+1
	...i ErrCode'="" s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,ErrCode,Count)=ErrCode_"^"_Item_"^"_Device_"^"_Val
	...q:ErrCode'=""
	...
	...s Result=##Class(web.DHCEQUseRecord).SaveUseRecord("",IsInputFlag,"",Val)
	...;b
	...;记录采集结果
	...s Node="Error"
	...i Result>0 s Node="Success"
	...s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=Result_"^"_Item_"^"_Device_"^"_Val
	...
	...
	
	;记录采集结束时间
	s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"EndTime")=$H
	
	k ^DHCEQTemp("GatherUseRecord",ExType,Job)
	q 0
}

/// add by zy 20181028 B/S  LIS系统接口  ZY0173
/// 采集DHC-Lis的相关使用记录,获取某一天的检验设备使用信息，存放在websource下的
/// ^DHCEQTemp("GatherUseRecord",ExType,$j,Item,Device,Row)
/// 其中ExType为"DHC-LIS","DHC-RIS"等，Item为医嘱项，Device为设备
/// 存储数据为StartDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_TotalFee_"^"_Price_"^"_ExID
/// 		  开始日期，开始时间，结束日期，结束时间，工作量，工作量单位，使用科室，患者信息，总费用，单价，医嘱id(检验为报告id)	
/// w ##Class(web.DHCEQIUsedRecord).GatherDHCLISNew(64506)
ClassMethod GatherDHCLISNew(GatherDate)
{
	n (GatherDate)
	
	s ExType="DHC-LIS"
	s SourceType=1	;类型为设备
	
	s tmpDate=$ZD(GatherDate,3)
	s SDate=$ZD(GatherDate,8)
	s EDate=$ZD(GatherDate,8)
	s Year=$p(tmpDate,"-",1)
	s Month=$p(tmpDate,"-",2)		
	s IsInputFlag="N"	;系统采集,非手工录入
	//Modefied by zc 2018-12-21 zc0047  将Status修改为LNStatus，避免任务挂起
	s LNStatus=2		;系统自动采集的自动置为审核状态
	s InvalidFlag="N"
	s Remark=""
	
	;记录采集结果开始时间
	s Count=0
	s Version=$o(^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,""),-1)
	s Version=1+Version
	s ErrCode=""
	s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"BeginTime")=$H
	
	s Job=$j
	
	s SourceID=0
	f  s SourceID=$o(^DHCEQDeviceMap(0,"Equip",SourceID)) quit:SourceID=""  d
	.//q:(EquipID'="")&(EquipID'=SourceID)
	.i SourceID'="" s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
	.s DMRowID=0
	.f  s DMRowID=$o(^DHCEQDeviceMap(0,"Equip",SourceID,ExType,DMRowID)) quit:DMRowID=""  d
	..s DeviceMap=$g(^DHCEQDeviceMap(DMRowID))
	..q:$p(DeviceMap,"^",5)="Y"
	..s DeviceID=$p(DeviceMap,"^",3)
	..//s DateType="Report"	//Study
	..s ds =##class(%Library.ResultSet).%New("web.DHCEQ.Interface.Inner.DHCEQLISFrom:GetLISUseRecord")
	..d ds.Execute(DeviceID,SDate,EDate,"","","","","","","","","","","","","")
	..f  q:'ds.Next()  d
	...s Item=ds.Item
	...q:Item=""
	...s ServiceItemDR=##Class(web.DHCEQIUsedRecord).GetServiceByExID(ExType,Item)
	...i ServiceItemDR="" s ServiceItemDR=##Class(web.DHCEQIUsedRecord).AutoSaveServiceItem(ExType,Item,GatherDate)
	...i ServiceItemDR=""  s ErrCode="NoServiceItem"
	...s RegDate=ds.RegDate
	...s RegTime=ds.RegTime
	...s UseDate=ds.StartDate
	...i UseDate'=""  d
	....s UseDate=$ZDH(UseDate,3)
	....s UseDate=$ZD(UseDate,4)
	...s StartTime=ds.StartTime
	...s EndDate=ds.EndDate
	...i EndDate'=""  d
	....s EndDate=$ZDH(EndDate,3)
	....s EndDate=$ZD(EndDate,4)
	...s EndTime=ds.EndTime
	...s WorkLoadNum=ds.WorkLoadNum	//接口中统计的是一个项目需要做几个细项目的检查数量,例如血常规有20多个指标,统计结果就是20多。
	...s WorkLoadNum=1
	...s WorkLoadUnitDR=ds.WorkLoadUnitDR
	...i WorkLoadUnitDR=""&ServiceItemDR'="" s WorkLoadUnitDR=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",3)
	...s UseLocDR=ds.UseLocDR
	...i ((UseLocDR="")&&(SourceID'="")) s UseLocDR=$p($g(^DHCEQEquip(SourceID)),"^",19)
	...s PatientID=ds.PatientID
	...s PatientSex=ds.PatientSex
	...s PatientName=ds.PatientName
	...s PatientAge=ds.PatientAge
	...s PatientInfo=PatientID_"&"_PatientName_"&"_PatientAge_"&"_PatientSex
	...s Price=ds.Price
	...i Price=""  s Price=##Class(web.DHCEQIUsedRecord).GetServicePriceByExID(ExType,Item, GatherDate)
	...s ReceivableFee=ds.ReceivableFee
	...s TotalFee=ds.TotalFee
	...i TotalFee="" s TotalFee=Price
	...s ExID=ds.ExID
	...q:ExID=""
	...s PositiveFlag=ds.PositiveFlag
	...s ReportType=ds.ReportType
	...s Operator=ds.Operator
	...s WaitingTime=ds.WaitingTime
	...
	...;//Modefied by zc 2018-12-21 zc0047  将Status修改为LNStatus，避免任务挂起
	...s Val=SourceType_"^"_SourceID_"^"_UseDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_Price_"^"_TotalFee_"^"_Year_"^"_Month_"^"_ServiceItemDR_"^"_ExType_"^"_ExID_"^"_IsInputFlag_"^"_LNStatus_"^"_InvalidFlag_"^"_Remark_"^^^^^^^"_ModelDR
	...
	...;记录结果
	...s Count=Count+1
	...i ErrCode'="" s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,ErrCode,Count)=ErrCode_"^"_Item_"^"_DeviceID_"^"_Val
	...q:ErrCode'=""
	...
	...s Result=##Class(web.DHCEQUseRecord).SaveUseRecord("",IsInputFlag,"",Val)
	...;b
	...;记录采集结果
	...s Node="Error"
	...i Result>0 s Node="Success"
	...s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=Result_"^"_Item_"^"_DeviceID_"^"_Val
	...
	...
	
	;记录采集结束时间
	s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"EndTime")=$H
	
	k ^DHCEQTemp("GatherUseRecord",ExType,Job)
	q 0
}

/// 采集DHC-His的相关使用记录
/// select oeori_itmmast_dr,oeori_itmmast_dr->arcim_desc,count(*) from oe_orditem group by oeori_itmmast_dr having count(*)>100
/// w ##Class(web.DHCEQIUsedRecord).GatherDHCHIS(+$H)
ClassMethod GatherDHCHIS(GatherDate)
{
	n (GatherDate)
	
	s ExType="DHC-HIS"
	s SourceType=1	;类型为设备
	
	s tmpDate=$ZD(GatherDate,3)
	s Year=$p(tmpDate,"-",1)
	s Month=$p(tmpDate,"-",2)		
	s IsInputFlag="N"	;系统采集,非手工录入
	//Modefied by zc 2018-12-21 zc0047  将Status修改为IUStatus，避免任务挂起
	s IUStatus=2		;系统自动采集的自动置为审核状态
	s InvalidFlag="N"
	s Remark=""

	;记录采集结果开始时间
	s Count=0
	s Version=$o(^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,""),-1)
	s Version=1+Version
	s ErrCode=""
	s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"BeginTime")=$H
	
	k ^DHCEQTemp("GatherDHCHIS","ItemPrice",$j)
	s OEORIItemStat=""
	f  s OEORIItemStat=$o(^OEORDi(0,"StDtStat",GatherDate,OEORIItemStat))  quit:(OEORIItemStat="")  d
	.;过滤掉未核实且未执行的医嘱
	.q:(($p(^OEC("OSTAT",OEORIItemStat),"^",1)'="V")&&($p(^OEC("OSTAT",OEORIItemStat),"^",1)'="E"))
	.s OEOrderID=0
	.f  s OEOrderID=$o(^OEORDi(0,"StDtStat",GatherDate,OEORIItemStat,OEOrderID))  quit:(OEOrderID="")  d
	..s ChildSub=0
	..f  s ChildSub=$o(^OEORDi(0,"StDtStat",GatherDate,OEORIItemStat,OEOrderID,ChildSub))  quit:(ChildSub="")  d
	...;医嘱项
	...s Item=$p($g(^OEORD(OEOrderID,"I",ChildSub,1)),"^",2)
	...q:Item=""
	...s ServiceItemDR=0
	...f  s ServiceItemDR=$o(^DHCEQCCode("DHCEQCServiceItem",0,"ExID",ExType,Item,ServiceItemDR))  quit:(ServiceItemDR="")  d 
	....q:$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",12)'="N"
	....;只获取一次价格
	....s Price=$g(^DHCEQTemp("GatherDHCHIS","ItemPrice",$j,Item))
	....i '$d(^DHCEQTemp("GatherDHCHIS","ItemPrice",$j,Item))  d
	.....s Price=..GetServicePriceByExID(ExType,Item, GatherDate)
	.....s ^DHCEQTemp("GatherDHCHIS","ItemPrice",$j,Item)=Price
	....s ErrCode=""
	....
	....;判断是否已经付费
	....s AdmID=$p(^OEORD(OEOrderID),"^",1)
	....s NeedPayed=0
	....s AdmType=$p($g(^PAADM(AdmID)),"^",2)
	....i AdmType="O" s NeedPayed=1
	....;患者类型，门诊患者则只取付费的，住院则取核实或执行的
	....q:(($p(^OEORD(OEOrderID,"I",ChildSub,3),"^",5)'="P")&&(NeedPayed=1))
	....s PatientID=$p(^PAADM(AdmID),"^",1)
	....s PatientInfo=##Class(web.DHCEQIUsedRecord).GetPatientInfo("DHC-HIS",PatientID)
 	....s Quantity=$p(^OEORD(OEOrderID,"I",ChildSub,1),"^",12)
 	....s ExID=OEOrderID_"||"_ChildSub
 	....s Amount=Price*Quantity
 	....
 	....s OriUOMDR=$p(^OEORD(OEOrderID,"I",ChildSub,2),"^",3)
 	....s OriRecDept=$p(^OEORD(OEOrderID,"I",ChildSub,3),"^",6)
 	....;定位设备
 	....;b
 	....s SourceID=..GetEquipByService(ServiceItemDR,OriRecDept)
 	....i SourceID="" s ErrCode="NoEquip"
 	....q:ErrCode'=""
	....s ModelDR=""
 	....i SourceID'="" s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
 	....
 	....;记录本次轮询到的设备ID
 	....s ^DHCEQEquipService(0,"EX","Rotate",ServiceItemDR,OriRecDept)=SourceID
 	....
 	....s UseDate=$p(^OEORD(OEOrderID,"I",ChildSub,1),"^",9)	;OEORI_SttDat
	....s StartTime=$p(^OEORD(OEOrderID,"I",ChildSub,1),"^",10)	;OEORI_SttTim
	....i UseDate'="" s UseDate=$ZD(UseDate,4)
	....i StartTime'="" s StartTime=$zt(StartTime)
	....s EndDate=""
	....s EndTime=""
	....s WorkLoadNum=Quantity
	....s WorkLoadUnitDR=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",3)
	....s UseLocDR=OriRecDept
	....s Price=Price
	....s TotalFee=Amount
	....
	....s Val=SourceType_"^"_SourceID_"^"_UseDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_Price_"^"_TotalFee_"^"_Year_"^"_Month_"^"_ServiceItemDR_"^"_ExType_"^"_ExID_"^"_IsInputFlag_"^"_IUStatus_"^"_InvalidFlag_"^"_Remark_"^^^^^^^"_ModelDR
	....
	....;记录结果
	....s Count=Count+1
	....i ErrCode'="" s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,ErrCode,Count)=ErrCode_"^"_Item_"^"_SourceID_"^"_Val
	....q:ErrCode'=""
	....
	....s Result=##Class(web.DHCEQUseRecord).SaveUseRecord("",IsInputFlag,"",Val)
	....;记录采集结果
	....s Node="Error"
	....i Result>0 s Node="Success"
	....s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=Result_"^"_Item_"^"_SourceID_"^"_Val
	
	;获取该日停止医嘱信息
	s OEOrderID=0
	f  s OEOrderID=$o(^OEORDi(0,"DHCXDate",GatherDate,OEOrderID))  quit:(OEOrderID="")  d
	.s ChildSub=0
	.f  s ChildSub=$o(^OEORDi(0,"DHCXDate",GatherDate,OEOrderID,ChildSub))  quit:(ChildSub="")  d
	..s ExID=OEOrderID_"||"_ChildSub
	..s ErrCode=..CancelUseRecordByExID(ExType,ExID,GatherDate)
	..s Count=Count+1
	..
	..s Node="CancelError"
	..i ErrCode=0 s Node="CancelSuccess"
	..s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=ErrCode_"^"_ExID
	
	k ^DHCEQTemp("GatherDHCHIS","ItemPrice",$j)
	;
	;记录采集结束时间
	s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"EndTime")=$H
	q 0
}

ClassMethod GetServicePriceByExID(ExType, ExID, OccDate)
{
	n (ExType, ExID, OccDate)
	s Info=""

	i ExType="DHC-LIS"
	{
		s Info=##class(web.UDHCJFPRICE).GetOrderPrice("", "",ExID, OccDate, "", "", "", "")
		s Info=$p(Info,"^",1)
	}
	elseif ExType="DHC-RIS"
	{
		s Info=##class(web.UDHCJFPRICE).GetOrderPrice("", "",ExID, OccDate, "", "", "", "")
		s Info=$p(Info,"^",1)
	}
	elseif ExType="DHC-HIS"
	{
		s Info=##class(web.UDHCJFPRICE).GetOrderPrice("", "",ExID, OccDate, "", "", "", "")
		s Info=$p(Info,"^",1)
	}
	q Info
}

/// 根据服务项以及发生的科室，来取得相应的设备
/// 根据轮询方式获取
/// w ##Class(web.DHCEQIUsedRecord).GetEquipByService(472,262)
ClassMethod GetEquipByService(ServiceItem, LocDR)
{
	n (ServiceItem,LocDR)
	i ServiceItem="" q ""
	i LocDR="" q ""
	//上次使用的设备
	s PreEquipID=$g(^DHCEQEquipService(0,"EX","Rotate",ServiceItem,LocDR))
	i PreEquipID="" s PreEquipID=0
	s NewEquipID=""
	s SourceType=0
	
	f  s SourceType=$o(^DHCEQEquipService(0,"ServiceSource",ServiceItem,SourceType))  quit:(SourceType="")  d 
	.s SourceID=0
	.f  s SourceID=$o(^DHCEQEquipService(0,"ServiceSource",ServiceItem,SourceType,SourceID))  quit:(SourceID="")  d 
	..s RowID=0
	..f  s RowID=$o(^DHCEQEquipService(0,"ServiceSource",ServiceItem,SourceType,SourceID,RowID))  quit:(RowID="")  d 
	...;Add By DJ 2017-06-22 DJ0189 过滤无效设备服务对照
	...s ESInvalidFlag=$p($g(^DHCEQEquipService(RowID)),"^",9)
	...q:ESInvalidFlag="Y"
	...;如果指定设备,则轮询可以做这个服务的设备
	...i SourceType=1  d
	....s EquipID=SourceID
	....d CheckNearEquip
	...;如果指定设备项,则轮询可以做这个服务的设备项包含的所有设备
	...i SourceType=2  d
	....s ItemDR=SourceID
	....s ModelDR=$p($g(^DHCEQEquipService(RowID)),"^",3)
	....s CIRowID=0
	....f  s CIRowID=$o(^DHCEQCCode("DHCEQCContrastInfo",0,"ExCode",1,LocDR,CIRowID))  q:CIRowID=""  d
	.....s CIInvalidFlag=$p($g(^DHCEQCCode("DHCEQCContrastInfo",CIRowID)),"^",16)
	.....q:CIInvalidFlag="Y"
	.....s CISYSID=$p($g(^DHCEQCCode("DHCEQCContrastInfo",CIRowID)),"^",2)
	.....s EquipID=0
	.....f  s EquipID=$o(^DHCEQEquip(0,"LocItem",CISYSID,ItemDR,EquipID))  quit:(EquipID="")  d
	......;过滤掉机型不一致的
	......q:((ModelDR'="")&&(ModelDR'=$p($g(^DHCEQEquip(EquipID)),"^",3)))
	......s ^DHCEQTemp("GetEquipByService",$J,ServiceItem,LocDR,EquipID)=""
	....s CurEQRowID=0
	....f  s CurEQRowID=$o(^DHCEQTemp("GetEquipByService",$J,ServiceItem,LocDR,CurEQRowID))  q:CurEQRowID=""  d
	.....s EquipID=CurEQRowID
	.....d CheckNearEquip
	....k ^DHCEQTemp("GetEquipByService",$J,ServiceItem,LocDR)
		
	q NewEquipID
CheckNearEquip
	s FindLoc=0
	
	;czf 2021-03-09 1789983 begin
	s (BELRowID,BELHold1)=""
	s BELRowID=$o(^DHCEQBenefitEquipList(0,"Equip",EquipID,BELRowID))
	i BELRowID'="" s BELHold1=$p($g(^DHCEQBenefitEquipList(BELRowID)),"^",10)
	if (BELHold1'="")
	{
		i (","_BELHold1_",")[(","_LocDR_",") s FindLoc=1	//czf 1880419 2021-07-08
	}
	else 
	{
		i $p(^DHCEQEquip(EquipID),"^",19)=LocDR s FindLoc=1
	}
	;czf 2021-03-09 1789983 end
	
	s CIRowID=0
	f  s CIRowID=$o(^DHCEQCCode("DHCEQCContrastInfo",0,"ExCode",1,LocDR,CIRowID))  q:(CIRowID="")||(FindLoc'=0)  d
	.s CIInvalidFlag=$p($g(^DHCEQCCode("DHCEQCContrastInfo",CIRowID)),"^",16)
	.q:CIInvalidFlag="Y"
	.s CISYSID=$p($g(^DHCEQCCode("DHCEQCContrastInfo",CIRowID)),"^",2)
	.i $p(^DHCEQEquip(EquipID),"^",19)=CISYSID s FindLoc=1
	q:FindLoc=0
	;过滤掉无效的
	q:$p($g(^DHCEQEquip(EquipID)),"^",59)'="N"
	;过滤掉非在用的
	q:$p($g(^DHCEQEquip(EquipID)),"^",38)'=1
	;过滤掉非在库
	q:$p($g(^DHCEQEquip(EquipID)),"^",60)'=1
	i NewEquipID=""  d
	.s NewEquipID=EquipID
	e  d
	.i (NewEquipID>PreEquipID)  d
	..i (EquipID<NewEquipID)&&(EquipID>PreEquipID) s NewEquipID=EquipID
	.e  d
	..i (EquipID<NewEquipID)||(EquipID>PreEquipID) s NewEquipID=EquipID
}

/// 根据扩展类型及项目,自动生成服务项
/// w ##Class(web.DHCEQIUsedRecord).AutoSaveServiceItem("DHC-RISNew","ZL0000363","")
ClassMethod AutoSaveServiceItem(ExType, Item, OccDate)
{
	n (ExType, Item, OccDate)
	i Item="" q ""
	if ((ExType="DHC-HIS")||(ExType="DHC-LIS")||(ExType="DHC-RIS")||(ExType="DHC-LIS(B/S)"))
	{
		s RowID=""
		s ItemSubscript=$p(Item,"||",1)
		s ItemVersion=$p(Item,"||",2)
		
		s Desc=$p($G(^ARCIM(ItemSubscript,ItemVersion,1)),"^",2)
		s Code=$p($G(^ARCIM(ItemSubscript,ItemVersion,1)),"^",1)
		s UnitDR=$p($G(^ARCIM(ItemSubscript,ItemVersion,1)),"^",4)
		s ExID=Item
		
		;s Price=##class(web.UDHCJFPRICE).GetOrderPrice("", "",ExID, OccDate, "", "", "", "")
		;s Price=$p(Price,"^",1)
		s Price=..GetServicePriceByExID(ExType,ExID, OccDate)
		s Price=##Class(web.DHCEQCommon).FormatNumber(Price,"",2)
		;s ExType		
		s Remark=""
		s ImportFlag="Y"
		s MinMinutes=""
		s MinutesPerTimes=""
		s MaxMinutes=""
		s InvalidFlag="N"
		s UpdateDate=+$H
		s ExDesc=Desc
	}	
	elseif(ExType="Pacs")	//add by zy 2011-11-11 ZY0085 地坛锐珂Pacs
	{
		set objService=##class(Service1.Service1Soap).%New()
		set objDataSet=objService.GetItemInfo(Item)
		For  Quit:'objDataSet.Next()  Do
		.if $d(objDataSet.Data("Item"))'=0 d
		..s Desc=objDataSet.Data("Item")
		..s Price=objDataSet.Data("Price")
		..s OtherInfo=objDataSet.Data("OtherInfo")
		s RowID=""
		s Code=""
		s UnitDR=""
		s ExID=Item
		s Remark=OtherInfo
		s ImportFlag="Y"
		s MinMinutes=""
		s MinutesPerTimes=""
		s MaxMinutes=""
		s InvalidFlag="N"
		s UpdateDate=+$H
		s ExDesc=Desc
	}
	/*  RIS系统中的检查项目应该和his的医嘱项一样，但是很多地方RIS系统中信息维护不全，所以还是直接从his中取
	elseif(ExType="DHC-RISNew")	//add by zy 2014-11-17 ZY STUDYITEM  RIS新系统中检查项目的Code,取其它信息
	{
		zn "PACS"
		s DataList=$g(^User.STUDYITEMD(Item))
		zn "DHC-APP"
		s Code=$LIST(DataList,3)
		s Desc=$LIST(DataList,4)
		s Price=$LIST(DataList,6)
		s RowID=""
		s Desc=Desc
		s Code=Code
		s UnitDR=""
		s Price=Price
		s ExID=Item
		s Remark=""
		s ImportFlag="Y"
		s MinMinutes=""
		s MinutesPerTimes=""
		s MaxMinutes=""
		s InvalidFlag="N"
		s UpdateDate=+$H
		s ExDesc=Desc
		s ExType="DHC-RIS"
	}
	*/
	s Val=RowID_"^"_Desc_"^"_Code_"^"_UnitDR_"^"_Price_"^"_ExType_"^"_ExID_"^"_Remark_"^"_ImportFlag_"^"_MinMinutes_"^"_MinutesPerTimes_"^"_MaxMinutes_"^"_InvalidFlag_"^"_UpdateDate_"^"_ExDesc
	q ##Class(web.DHCEQCServiceItem).SaveData("","",Val)
}

/// 根据患者ID获取患者信息
/// w ##Class(web.DHCEQIUsedRecord).GetPatientInfo("DHC-HIS",1)
ClassMethod GetPatientInfo(ExType, PatientID)
{
	n (ExType,PatientID)
	s PatientInfo=""
	i PatientID="" q ""
	i (ExType="DHC-HIS")
	{
		;PA_PatMas
		s PatientName= $p($g(^PAPER(PatientID,"ALL")),"^",1)
		s PatientSex= $p($g(^PAPER(PatientID,"ALL")),"^",7)
		s PatientDOB= $p($g(^PAPER(PatientID,"ALL")),"^",6)
		;CT_Sex
		i PatientSex'="" s PatientSex= $p($g(^CT("SEX",PatientSex)),"^",2)
		s PatientInfo=PatientID_"&"_PatientName_"&"_PatientSex_"&"_PatientDOB		
	}
	q PatientInfo
}

/// ***************************************************
/// 
/// ***************************************************
/// 获取DHC-LIS 的数据，根据检验的审核日期
/// 将获取的数据存储在
/// ^DHCEQTemp("GatherUseRecord",ExType,$j,Item,Device,Row)
/// 其中ExType:"DHC-LIS",Item为医嘱项，Device为设备代码，Row为顺序号
/// 
/// 节点存储的数据为StartDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_TotalFee_"^"_Price_"^"_ExID
///    开始日期，开始时间，结束日期，结束时间，工作量，工作量单位，使用科室，患者信息，总费用，单价，医嘱id,阴性/阳性率,预约等待时长。
/// w ##Class(web.DHCEQIUsedRecord).GetLISUseRecord(60816)
ClassMethod GetLISUseRecord(Date As %String) As %String
{
	//^TEPIi("AUTHORISED",60466,"A60466020","A001",1)=
    s ExType="DHC-LIS"
	k ^DHCEQTemp("GatherUseRecord",ExType,$j)
	s labno="" 
	f  s labno=$o(^TEPIi("AUTHORISED",Date,labno)) q:labno=""  d
	.//
	.;w labno,!
	.s OrdId=$o(^OEORD(0,"EpisNo",labno,""))
	.i '$l(OrdId) q
	.s ts="" 
	.f  s ts=$o(^TEPIi("AUTHORISED",Date,labno,ts)) q:ts=""  d
	..s tscnt="" 
	..f  s tscnt=$o(^TEPIi("AUTHORISED",Date,labno,ts,tscnt)) q:tscnt=""  d
	...//^OEORDi(0,"LabTS",2508,"33||A003||1",7)=
	...s TSRow=labno_"||"_ts_"||"_tscnt
	...s MachCode=$p(^TEPI(labno,1,ts,tscnt),"\",27)
	...i '$l(MachCode) q
	...s OrdSubId="" f  s OrdSubId=$o(^OEORDi(0,"LabTS",OrdId,TSRow,OrdSubId)) q:OrdSubId=""  d
	....s ItmMast=$p(^OEORD(OrdId,"I",OrdSubId,1),"^",2)
	....i '$l(ItmMast) q
	....s StartDate=$p(^TEPI(labno,1,ts,tscnt),"\",21)
	....s StartTime=$p(^TEPI(labno,1,ts,tscnt),"\",22)
	....i $l(StartTime) s StartTime=StartTime*60
	....s EndDate=$p(^TEPI(labno,1,ts,tscnt),"\",4)
	....s EndTime=$p(^TEPI(labno,1,ts,tscnt),"\",5)
	....i $l(EndTime) s EndTime=EndTime*60
	....s WorkLoadNum=1
	....s WorkLoadUnitDR=1
	....s UseLocDR=""
	....s PatientInfo=$p(^TEPI(labno),"\",1)_","_$p(^TEPI(labno),"\",3)_","_$p(^TEPI(labno),"\",4)
	....s TotalFee=""
	....i $d(^["labdata"]DHCTestSetDetails(labno,ts)) s TotalFee=$p(^["labdata"]DHCTestSetDetails(labno,ts),"\",2)
	....s Price=TotalFee
	....s ExID=OrdId_"||"_OrdSubId
	....s seq=$o(^DHCEQTemp("GatherUseRecord",ExType,$j,ItmMast,MachCode,""),-1)+1
	....s ^DHCEQTemp("GatherUseRecord",ExType,$j,ItmMast,MachCode,seq)=StartDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_TotalFee_"^"_Price_"^"_ExID
	....;w "b"
	q 0
}

/// DHCRIS获取使用记录信息
/// 根据登记日期获取
/// w ##Class(web.DHCEQIUsedRecord).GatherDHCRIS(61144)
/// RIS相关的Global:^DHCPACRegInfoi,^DHCPACRegInfo,^DHCRBRFi,^DHCRBRF,^RBC("EQ"
ClassMethod GatherDHCRIS(GatherDate As %String) As %String
{
	s ExType="DHC-RIS"
	s SourceType=1	;类型为设备
	
	s tmpDate=$ZD(GatherDate,3)
	s Year=$p(GatherDate,"-",1)
	s Month=$p(GatherDate,"-",2)
	s IsInputFlag="N"	;系统采集,非手工录入
	//Modefied by zc 2018-12-21 zc0047  将Status修改为RIStatus，避免任务挂起
	s RIStatus=2		;系统自动采集的自动置为审核状态
	s InvalidFlag="N"
	s Remark=""
	
	;记录采集结果开始时间
	s Count=0
	s Version=$o(^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,""),-1)
	s Version=1+Version
	s ErrCode=""
	s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"BeginTime")=$H

	;DHCRB_RegInfo
	s RegInfoID=0	
	f  s RegInfoID=$o(^DHCPACRegInfoi("RegDate",GatherDate,RegInfoID)) q:(RegInfoID="")  d
	.s AdmID=$p(^DHCPACRegInfo(RegInfoID),"^",10)
	.s PatientID=$p($g(^PAADM(AdmID)),"^",1)
	.s ExID=$p(^DHCPACRegInfo(RegInfoID),"^",11)
	.;s Item=$p(^DHCPACRegInfo(RegInfoID),"^",12)
	.
	.s Device=$p(^DHCPACRegInfo(RegInfoID),"^",14)
	.q:Device=""
	.s ErrCode=""
	.s SourceID=..GetEquipByDevice(ExType,Device)
	.i SourceID="" s ErrCode="DeviceNoMap"
	.
	.s OEOrderID=$p(ExID,"||",1)
	.s ChildSub=$p(ExID,"||",2)
	.s UseLocDR=$p(^DHCPACRegInfo(RegInfoID),"^",13)
	.
	.s UseDate=$p(^DHCPACRegInfo(RegInfoID),"^",8)
	.i UseDate'="" s UseDate=$ZD(UseDate,4)
	.s StartTime=$p(^DHCPACRegInfo(RegInfoID),"^",9)
	.i StartTime'="" s StartTime=$zt(StartTime)
	.s EndDate=""
	.s EndTime=""
	.s WorkLoadNum=1
	.s WorkLoadUnitDR=""
	.s PatientInfo=##Class(web.DHCEQIUsedRecord).GetPatientInfo("DHC-HIS",PatientID)
	.;b
	.s Item=$p(^OEORD(OEOrderID,"I",ChildSub,1),"^",2)
	.s Price=..GetServicePriceByExID(ExType,Item, GatherDate)
	.s TotalFee=Price
	.
	.s ServiceItemDR=..GetServiceByExID(ExType,Item)
	.s ModelDR=""
	.i SourceID'="" s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
	.
	.;如果未定义服务项,则需自动生成服务项目
	.i ((ServiceItemDR="")&&(ErrCode=""))  d
	..
	..s ServiceItemDR=##Class(web.DHCEQIUsedRecord).AutoSaveServiceItem(ExType,Item,GatherDate)
	..i ServiceItemDR=""  s ErrCode="NoServiceItem"
	.
	.i ServiceItemDR'="" s WorkLoadUnitDR=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",3)
	.;//Modefied by zc 2018-12-21 zc0047  将Status修改为RIStatus，避免任务挂起
	.s Val=SourceType_"^"_SourceID_"^"_UseDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_Price_"^"_TotalFee_"^"_Year_"^"_Month_"^"_ServiceItemDR_"^"_ExType_"^"_ExID_"^"_IsInputFlag_"^"_RIStatus_"^"_InvalidFlag_"^"_Remark_"^^^^^^^"_ModelDR
	.
	.;记录结果
	.s Count=Count+1
	.i ErrCode'="" s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,ErrCode,Count)=ErrCode_"^"_Item_"^"_Device_"^"_Val
	.q:ErrCode'=""
	.
	.s Result=##Class(web.DHCEQUseRecord).SaveUseRecord("",IsInputFlag,"",Val)
	.;记录采集结果
	.s Node="Error"
	.i Result>0 s Node="Success"
	.s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=Result_"^"_Item_"^"_Device_"^"_Val
	.
	
	;DHCRB_ReturnFee
	;获取该日取消医嘱信息	
	s LocDR=0
	f  s LocDR=$o(^DHCRBRFi("LOC-DATE",LocDR))  quit:(LocDR="")  d
	.s ReturnID=0
	.f  s ReturnID=$o(^DHCRBRFi("LOC-DATE",LocDR,GatherDate,ReturnID))  quit:(ReturnID="")  d
	..s ExID=$p($g(^DHCRBRF("Record",ReturnID)),"^",1)
	..s ErrCode=..CancelUseRecordByExID(ExType,ExID,GatherDate)
	..s Count=Count+1
	..
	..s Node="CancelError"
	..i ErrCode=0 s Node="CancelSuccess"
	..s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=ErrCode_"^"_ExID
	
	;记录采集结束时间
	s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"EndTime")=$H
	q 0
}

/// 根据仪器及设备对照表，获取对应的设备系统的设备
/// w ##Class(web.DHCEQIUsedRecord).GetEquipByDevice("DHC-RIS",19)
ClassMethod GetEquipByDevice(ExType, Device)
{
	n (ExType,Device)
	s EquipDR=""
	i ExType="" q ""
	i Device="" q ""
	s MapID=0
	f  s MapID=$o(^DHCEQDeviceMap(0,"Device",ExType,Device,MapID)) q:(MapID="")  d
	.q:$p($g(^DHCEQDeviceMap(MapID)),"^",5)'="N"
	.s EquipDR=$p($g(^DHCEQDeviceMap(MapID)),"^",1)
	
	q EquipDR
}

/// 根据扩展ID获取服务项目
ClassMethod GetServiceByExID(ExType, Item)
{
	n (ExType,Item)
	s ServiceItemDR=""
	s RowID=""
	f  s RowID=$o(^DHCEQCCode("DHCEQCServiceItem",0,"ExID",ExType,Item,RowID)) q:(RowID="")  d
	.q:$p($g(^DHCEQCCode("DHCEQCServiceItem",RowID)),"^",12)'="N"
	.s ServiceItemDR=RowID
	q ServiceItemDR
}

/// 根据扩展ID取消对应的使用记录
/// ExType:
/// ExID:医嘱ID
/// w ##Class(web.DHCEQIUsedRecord).CancelUseRecordByExID("DHC-RIS","",61251)
ClassMethod CancelUseRecordByExID(ExType, ExID, CancelDate)
{
	n (ExType,ExID,CancelDate)
	s UseRecordID=$o(^DHCEQUseRecord(0,"ExID",ExType,ExID,0))
	i UseRecordID="" q 0
	;如果取消日期与记录日期为同一天，则说明是先取消，后又有使用记录，故不操作
	i CancelDate=$p($g(^DHCEQUseRecord(UseRecordID)),"^",3) q 0
	&SQL(Update SQLUSER.DHC_EQUseRecord Set UR_Status=3,UR_CancelDate=:CancelDate Where UR_RowID=:UseRecordID)
	q SQLCODE
}

/// Add by JDL 2010-11-09  JDL0057
/// 根据月消耗的消耗项目量，来倒推各个项目的消耗,并生成使用记录消耗项目
/// 入参：倒推消耗的月份
/// 返回：0操作成功  其他操作失败
/// 一般应定制为每月执行任务。
/// d ##Class(web.DHCEQIUsedRecord).GenUsedConsumableItem(GenYear,GenMonth)
ClassMethod GenUsedConsumableItem(GenYear, GenMonth)
{
	n (GenYear,GenMonth)
	if (GenYear)="" q ""
	if (GenMonth)="" q ""
	
	;转换为该月份的起止日期
	s BeginDate=GenYear_"-"_GenMonth_"-01"
	s BeginDate=$ZDH(BeginDate,3)	
	if (+GenMonth=12)
	{	s EndDate=(GenYear+1)_"-01-01"			}
	else
	{	s EndDate=GenYear_"-"_(GenMonth+1)_"-1"	}			
	s EndDate=$ZDH(EndDate,3)
	s EndDate=EndDate-1
	s flag=##Class(web.DHCEQIUsedRecord).StandardQty(BeginDate,EndDate)
	q flag
}

/// 推算标准量
/// 入参：BeginDate
/// 		 EndDate
/// 		 ExType:扩展类型,如 "DHC-ST"
/// 		 ExID:消耗项目扩展ID，此处用做库存项ID
/// 		 Loc：消耗科室
/// 		 Qty：消耗量
/// 	返回：标准消耗量
/// 	w ##Class(web.DHCEQIUsedRecord).Calculate(+$H,+$H,"DHC-ST","12","123",100)
ClassMethod Calculate(BeginDate, EndDate, ExType, ExID, Loc, Qty)
{
	n (BeginDate,EndDate,ExType,ExID,Loc,Qty)
	s UseDate=BeginDate-1
	s TotalQty=0
	f  s UseDate=$o(^DHCEQUseConsumableItem(0,"UseDateExID",UseDate)) q:((UseDate="")||(UseDate>EndDate))  d
	.;在此只取消耗中，记录相对量的
	.s RowID=0
	.f  s RowID=$o(^DHCEQUseConsumableItem(0,"UseDateExID",UseDate,Loc,ExType,ExID,"2",RowID)) q:((RowID=""))  d
	..s TotalQty=TotalQty+$p(^DHCEQUseConsumableItem(RowID),"^",8)		;RelativeQty
	
	s UseDate=BeginDate-1
	f  s UseDate=$o(^DHCEQUseConsumableItem(0,"CancelDateExID",UseDate)) q:((UseDate="")||(UseDate>EndDate))  d
	.;在此只取消耗中，记录相对量的
	.s RowID=0
	.f  s RowID=$o(^DHCEQUseConsumableItem(0,"CancelDateExID",UseDate,Loc,ExType,ExID,"2",RowID)) q:((RowID=""))  d
	..s TotalQty=TotalQty-$p(^DHCEQUseConsumableItem(RowID),"^",8)		;RelativeQty
	i +TotalQty'>0 q 0
	s StandardQty= Qty/TotalQty
	q StandardQty
}

/// 更新消耗记录表，将相对量转换为绝对量
ClassMethod UpdateRelativeQty(BeginDate, EndDate, ExType, ExID, Loc, StandardQty, Price)
{
	n (BeginDate,EndDate,ExType,ExID,Loc,StandardQty,Price)
	s UseDate=BeginDate-1
	s SQLCODE=0
	f  s UseDate=$o(^DHCEQUseConsumableItem(0,"UseDateExID",UseDate)) q:((UseDate="")||(UseDate>EndDate)||(SQLCODE'=0))  d
	.;在此只取消耗中，记录相对量的
	.s RowID=0
	.f  s RowID=$o(^DHCEQUseConsumableItem(0,"UseDateExID",UseDate,Loc,ExType,ExID,"2",RowID)) q:((RowID="")||(SQLCODE'=0))  d
	..s Qty=$p(^DHCEQUseConsumableItem(RowID),"^",8)*StandardQty
	..s Qty=##Class(web.DHCEQCommon).FormatNumber(Qty,"",2)
	..s Amount=Qty*Price
	..s Amount=##Class(web.DHCEQCommon).FormatNumber(Amount,"",2)
	..&SQL(Update SQLUSER.DHC_EQUseConsumableItem set UCI_Quantity=:Qty,UCI_QuantityType='3',UCI_Price=:Price,UCI_Amount=:Amount Where UCI_RowID=:RowID)
	
	q SQLCODE
}

/// add by zy 20141117 ZY0117
/// 	生成按月消耗耗材的消耗项目（根据服务项、服务细项、设备 对照消耗项目生成）
/// 	ExType:耗材项 来源 如DHC-ST,会从
/// w ##Class(web.DHCEQIUsedRecord).SaveUseConsumableItem("DHC-ST","2014-01")
ClassMethod SaveUseConsumableItem(ExType, Month As %String = "")
{
	n (ExType,MonthStr)
	s Job=$j
	s Date=+$H
	i MonthStr="" s MonthStr=$e($ZD(Date,3),1,7)
	s StartDate=$ZDATEH(##Class(web.DHCEQReport).GetReportDate(MonthStr,"1","4",""),4)
	s EndDate=$ZDATEH(##Class(web.DHCEQReport).GetReportDate(MonthStr,"2","4",""),4)
	//s BeginDate=+##Class(web.DHCEQBenefitAnalyReport).StartDate(Month)+1
	//s EndDate=+##Class(web.DHCEQBenefitAnalyReport).EndDate(Month)+1
	/*
	//扬中人民医院用了DHCEQEquipConsumableItem表来存设备用到的耗材,正式库不采用这种方式
	s (EquipID,SQLCOED)=0
	f  s EquipID=$o(^DHCEQEquipConsumableItem(0,"EquipDR",EquipID))  quit:(EquipID="")||(SQLCOED'=0)  d
	.s UseLocDR=$p($g(^DHCEQEquip(EquipID)),"^",19)
	.q:UseLocDR=""
	.s ConsumableItemID=0
	.f  s ConsumableItemID=$o(^DHCEQEquipConsumableItem(0,"EquipDR",EquipID,ConsumableItemID))  quit:(ConsumableItemID="")||(SQLCOED'=0)  d
	..s ExType=$p($g(^DHCEQCCode("DHCEQCConsumableItem",ConsumableItemID)),"^",5)
	..s ExID=$p($g(^DHCEQCCode("DHCEQCConsumableItem",ConsumableItemID)),"^",6)
	..q:$p($g(^DHCEQCCode("DHCEQCConsumableItem",ConsumableItemID)),"^",7)'="Y"
	..d ##Class(web.DHCEQIUsedRecord).GatherDHCST(BeginDate,EndDate,ExType,ExID,Job,UseLocDR)
	..s Result=$g(^DHCEQTemp("GatherUseRecord",ExType,Job,ExID,UseLocDR))
	..;s Result="72250^0^21^1517250^72250^40"
	..q:Result=""
	..s ECIrowid =$o(^DHCEQEquipConsumableItem(0,"ConsumableItemDR",ConsumableItemID,EquipID,0))
	..s Rate=+$p($g(^DHCEQEquipConsumableItem(ECIrowid)),"^",3)
	..//InQty_"^"_ReturnQty_"^"_Price_"^"_Amount_"^"_Qty_"^"_BaseUom
	*/
	
	//^DHCEQCCode("DHCEQCServiceConsumable",0,"TypeSourceID",{SIC_Type},{SIC_SourceType},{SIC_SourceID},{SIC_ConsumableItemDR},{SIC_RowID}
	//Type=2时,可以按照一定的周期来统计设备对应的耗材成本
	s (EquipID,SQLCOED)=0
	f  s EquipID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"TypeSourceID",2,1,EquipID))  quit:(EquipID="")||(SQLCOED'=0)  d
	.s UseLocDR=$p($g(^DHCEQEquip(EquipID)),"^",19)
	.q:UseLocDR=""
	.s ConsumableItemID=0
	.f  s ConsumableItemID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"TypeSourceID",2,1,EquipID,ConsumableItemID))  quit:(ConsumableItemID="")||(SQLCOED'=0)  d
	..s ExType=$p($g(^DHCEQCCode("DHCEQCConsumableItem",ConsumableItemID)),"^",5)
	..s ExID=$p($g(^DHCEQCCode("DHCEQCConsumableItem",ConsumableItemID)),"^",6)
	..q:$p($g(^DHCEQCCode("DHCEQCConsumableItem",ConsumableItemID)),"^",7)'="Y"
	..s SCIrowid =$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"TypeSourceID",2,1,EquipID,ConsumableItemID,0))
	..quit:SCIrowid=""
	..s Result=$g(^DHCEQCCode("DHCEQCServiceConsumable",SCIrowid))
	..s QuantyType=$p(Result,"^",8)	;数量类型：1:绝对量 2:相对量
	..s CycleNum=$p(Result,"^",11)	;周期数
	..s CycleUnitID=$p(Result,"^",12)	;周期单位
	..s UCIList(3)=ConsumableItemID
	..s Price=$p($g(^DHCEQCCode("DHCEQCConsumableItem",ConsumableItemID)),"^",3)
	..s UCIList(10)=UseLocDR
	..s UCIList(4)=$p(Result,"^",5)	;UOM
	..i QuantyType=1 d
	...s Quanty=$p(Result,"^",6)	;Quanty
	..e  d
	...;相对量的时候根据周期来计算数量  后面根据具体情况添加代码
	...s Quanty=0
	..s UCIList(5)=Quanty
	..s UCIList(5)=$p(Result,"^",6)	;Quanty
	..s UCIList(6)=Price	;Price
	..s UCIList(7)=##Class(web.DHCEQCommon).FormatNumber(Quanty*Price,"",2)	;Amount
	..//i Rate>0 s UCIList(7)=$p(Result,"^",4)*Rate  写的时候把总的费用都写上，在最后取值得时候要按照比例去取
	..s UCIList(8)="1"	//绝对量
	..s UCIList(11)=""	//ExType
	..s UCIList(12)=""	//ExID
	..s UCIList(13)=""	//ServiceItemDR
	..s UCIList(14)=""	//ServDetItem
	..s UCIList(15)=""	//URNum*Modulus
	..s UCIList(16)=+$H
	..s UCIList(17)=+$H
	..s UCIList(19)=MonthStr
	..s UCIList(20)="Y"
	..s UCIList(21)="1"
	..s UCIList(22)=EquipID
	..&SQL(Insert Into SQLUSER.DHC_EQUseConsumableItem values :UCIList())	
	q SQLCOED
}

/// modified by zy 20140915 ZY0117
/// 获取时间段内该消耗项目 在各科室的 领用消耗量
/// 领用-退库
/// 入参：BeginDate
/// 		 EndDate
/// 		 ExType:如 "DHC-ST"
/// 		 Item：库存项
/// 将数据写入到^DHCEQTemp("GatherUseRecord","DHC-ST",$j,Item,Loc)="InQty_"^"_ReturnQty_"^"_Price_"^"_Amount_"^"_Qty_"^"_BaseUom"
/// w ##Class(web.DHCEQIUsedRecord).GatherDHCST("","","DHC-ST","")
ClassMethod GatherDHCST(BeginDate, EndDate, ExType, Item, Job As %String = "", UseLocID As %String = "")
{
	n (BeginDate,EndDate,ExType,Item,Job,UseLocID)
	q:ExType'="DHC-ST"	
	i Job="" s Job=$j
	if BeginDate="" s BeginDate=1
	if EndDate="" s EndDate=+$H
	i EndDate<BeginDate q
	i Item="" q
	
	k ^DHCEQTemp("GatherUseRecord",ExType,Job,Item)
	
	;检测库存项是否信息完整；
	q:'$d(^INCI(Item,1))
 	q:'$d(^INCI(Item,2))
 	q:'$d(^INCI(Item,3))
	
	s BaseUom=$p(^INCI(Item,1),"^",10)	
	
	s Loc=0
	f  s Loc=$o(^INCI("IL_LOC",Loc)) q:(Loc="")  d
	.q:(UseLocID'="")&(UseLocID'=Loc)
	.s (InQty,ReturnQty,Price,Amount,Qty)=0
	.s ILSub=0
	.f  s ILSub=$o(^INCI("IL_LOC",Loc,Item,ILSub)) q:(ILSub="")  d
	..
	..;变动类型：G－入库;T、I－转移出库;K－转移入库;R－退货
	..;	P－住院发药;Y－住院退药;D－报损;C－消耗;A－调整;F—门诊发药;H—门诊退药
	..s INTRType=""
	..f  s INTRType=$o(^DHCINTR(0,"ILTYPEDATE",Item_"||"_ILSub,INTRType)) q:((INTRType=""))  d
	...;TYPE=”K”-领入,TYPE=”T”-退回
	...q:(INTRType'="T")&&(INTRType'="K")
	...s INTRDate=BeginDate-1
	...f  s INTRDate=$o(^DHCINTR(0,"ILTYPEDATE",Item_"||"_ILSub,INTRType,INTRDate)) q:((INTRDate="")||(INTRDate>EndDate))  d
	....s INTRRowID=0
	....f  s INTRRowID=$o(^DHCINTR(0,"ILTYPEDATE",Item_"||"_ILSub,INTRType,INTRDate,INTRRowID)) q:((INTRRowID=""))  d
	.....;获取指针，检测发生改变动的业务单据是否存在
	.....s INTRPointer=$p(^DHCINTR(INTRRowID),"^",9)
	.....s DHCTRF=+INTRPointer,DHCTRFC=$p(INTRPointer,"||",2)
	.....q:'$d(^DHCINIT(DHCTRF,"ITI",DHCTRFC))
	.....;获取科室项目批次，并检测信息是否完整 
	.....s INCLBRowID=$p(^DHCINTR(INTRRowID),"^",7)
	.....s INCLBSub=$p(INCLBRowID,"||",3)
	.....q:'$d(^INCI(Item,"IL",ILSub,"LB",INCLBSub))
	.....;w INTRRowID_"&"_Loc_"&"_INTRType,!
 	.....d AddInTransInfo
 	.q:Qty=0
 	.s Price= Amount/Qty
 	.;s Price=$fn(Price,"",2)
 	.s ^DHCEQTemp("GatherUseRecord",ExType,Job,Item,Loc)=InQty_"^"_ReturnQty_"^"_Price_"^"_Amount_"^"_Qty_"^"_BaseUom
	q
AddInTransInfo	
	s INTRQty=$p(^DHCINTR(INTRRowID),"^",6)
	s INTRUom=$p(^DHCINTR(INTRRowID),"^",10)
	;DHCITI_RPAmount
	;如果单位不同，则转换为库存项基本单位
	i (BaseUom'=INTRUom)
	{
		Set Config=##Class(websys.Configuration).%OpenId(1)
		Set MEDDATA=Config.DataNamespace
		Set CurrentNS=$ZNSPACE
		ZN MEDDATA	
		s Fac=$$UOMFac^DHCSTCOMMONSRV(INTRUom,BaseUom)
		ZN CurrentNS		
 		s INTRQty=INTRQty*Fac
	}
	s Qty=Qty+INTRQty
	;TYPE=”K”-领入,TYPE=”T”-退回
	i INTRType="K"
	{
		s InQty=InQty+INTRQty
		s Amount=Amount+$p($g(^DHCINIT(DHCTRF,"ITI",DHCTRFC)),"^",16)
	}
	elseif INTRType="T"
	{
		s ReturnQty=ReturnQty+INTRQty
		s Amount=Amount-$p($g(^DHCINIT(DHCTRF,"ITI",DHCTRFC)),"^",16)
	}
	q
}

/// Add by jdl 2011-5-31
/// 根据上一次领用耗材的时间段来计算消耗耗材的标准量并更新
/// 入参：BeginDate:开始日期
/// 	  EndDate:结束日期
/// 返回：0：操作正常，更新成功
/// 	  其他:更新失败
/// w ##Class(web.DHCEQIUsedRecord).StandardQty(BeginDate, EndDate)
ClassMethod StandardQty(BeginDate, EndDate)
{
	n UseDate,Loc,ExType,ExID,QuantityType
	n RowID,INTRType,INTRDate,ILSub,INTRRowID,INTRPointer,DHCTRF,DHCTRFC,INCLBRowID,INCLBSub,INTQty
	n TotalQty,ReturnQty,RelativeQty,BaseUom,INTRUom,STInfo,LastDate,PreDate,Amount,Fac
	n i,Times,FindFlag,InFlag
	
	s Times=5

	s SQLCODE=0
	k ^DHCEQTemp("GatherUseRecord","RelativeQty",$j)
	k ^DHCEQTemp("GatherUseRecord","STInfo",$j)
	;整理有哪些耗材需要计算标准量
	s UseDate=BeginDate-1	
	f  s UseDate=$o(^DHCEQUseConsumableItem(0,"UseDateExID",UseDate)) q:((UseDate="")||(UseDate>EndDate))  d
	.s Loc=0
	.f  s Loc=$o(^DHCEQUseConsumableItem(0,"UseDateExID",UseDate,Loc)) q:((Loc="")||(SQLCODE'=0))  d
	..s ExType=""
	..f  s ExType=$o(^DHCEQUseConsumableItem(0,"UseDateExID",UseDate,Loc,ExType)) q:((ExType=""))  d
	...;只取 "DHC-ST"耗材消耗
	...q:ExType'="DHC-ST"
	...s ExID=0
	...f  s ExID=$o(^DHCEQUseConsumableItem(0,"UseDateExID",UseDate,Loc,ExType,ExID)) q:((ExID=""))  d
	....s QuantityType=0
	....f  s QuantityType=$o(^DHCEQUseConsumableItem(0,"UseDateExID",UseDate,Loc,ExType,ExID,QuantityType)) q:((QuantityType=""))  d
	.....;在此只取消耗中，记录相对量的
	.....q:QuantityType'="2"
	.....s TotalQty=0
	.....s RowID=0
	.....f  s RowID=$o(^DHCEQUseConsumableItem(0,"UseDateExID",UseDate,Loc,ExType,ExID,QuantityType,RowID)) q:((RowID="")||(TotalQty>0))  d
	......s TotalQty=TotalQty+$p(^DHCEQUseConsumableItem(RowID),"^",8)
	......s ^DHCEQTemp("GatherUseRecord","RelativeQty",$j,ExType,ExID,Loc)=TotalQty

	;计算标准量
	k ^DHCEQTemp("GatherUseRecord","StandardQty",$j)
	s ExType=""
	f  s ExType=$o(^DHCEQTemp("GatherUseRecord","RelativeQty",$j,ExType)) q:((ExType=""))  d
	.s ExID=0
	.f  s ExID=$o(^DHCEQTemp("GatherUseRecord","RelativeQty",$j,ExType,ExID)) q:((ExID=""))  d
	..d GetSTInfo
	..s Loc=0
	..f  s Loc=$o(^DHCEQTemp("GatherUseRecord","STInfo",$j,ExType,ExID,Loc)) q:((Loc=""))  d
	...s LastDate=$g(^DHCEQTemp("GatherUseRecord","STInfo",$j,ExType,ExID,Loc))
	...s PreDate=+$p(LastDate,"^",2)
	...s TotalQty=+$p(LastDate,"^",3)
	...s Amount=+$p(LastDate,"^",4)
	...s LastDate=+LastDate
	...q:(TotalQty'>0)
	...d GetStandardQty

	k ^DHCEQTemp("GatherUseRecord","RelativeQty",$j)
	k ^DHCEQTemp("GatherUseRecord","STInfo",$j)
	
	TStart
	;根据计算的标准量来更新数据
	s ExType=""
	f  s ExType=$o(^DHCEQTemp("GatherUseRecord","StandardQty",$j,ExType)) q:((ExType="")||(SQLCODE'=0))  d
	.s ExID=0
	.f  s ExID=$o(^DHCEQTemp("GatherUseRecord","StandardQty",$j,ExType,ExID)) q:((ExID="")||(SQLCODE'=0))  d
	..s Loc=0
	..f  s Loc=$o(^DHCEQTemp("GatherUseRecord","StandardQty",$j,ExType,ExID,Loc)) q:((Loc="")||(SQLCODE'=0))  d
	...s StandardQty=$g(^DHCEQTemp("GatherUseRecord","StandardQty",$j,ExType,ExID,Loc))
	...s Price=$p(StandardQty,"^",2)
	...s StandardQty=$p(StandardQty,"^",1)
	...&SQL(Update SQLUSER.DHC_EQUseConsumableItem set UCI_Quantity=UCI_RelativeQty*:StandardQty,UCI_QuantityType='3',UCI_Price=:Price,UCI_Amount=UCI_RelativeQty*:StandardQty*:Price Where UCI_UseDate>=:BeginDate and UCI_UseDate<=:EndDate and UCI_ExType=:ExType and UCI_ExID=:ExID and UCI_UseLocDR=:Loc and UCI_QuantityType='2') 
	k ^DHCEQTemp("GatherUseRecord","StandardQty",$j)
	i SQLCODE
	{
		TRollBack
		q SQLCODE
	}
	TCommit
	q SQLCODE
	
GetSTInfo	
	q:ExType'="DHC-ST"
	
	s STInfo=""
	;检测库存项是否信息完整；
	q:'$d(^INCI(ExID,1))
 	q:'$d(^INCI(ExID,2))
 	q:'$d(^INCI(ExID,3))
 	
	s BaseUom=$p(^INCI(ExID,1),"^",10)
	s FindFlag=0
	
	;只取上一次领用的耗材量，根据上一次领用的量，
	;以及上一次领用日期与最后一次领用日期的日期段，来计算该段时间消耗的标准量
	s INTRDate=EndDate
	f  s INTRDate=$o(^DHCINTR(0,"INCI",ExID,INTRDate),-1) q:((INTRDate="")||(FindFlag=1))  d
	.s INTRRowID=0
	.f  s INTRRowID=$o(^DHCINTR(0,"INCI",ExID,INTRDate,INTRRowID)) q:((INTRRowID="")||(FindFlag=1))  d
	..i '$d(^DHCEQTemp("GatherUseRecord","RelativeQty",$j,ExType,ExID)) s FindFlag=1
	..q:FindFlag=1
	..;变动类型：G－入库;T、I－转移出库;K－转移入库;R－退货
	..;	P－住院发药;Y－住院退药;D－报损;C－消耗;A－调整;F—门诊发药;H—门诊退药
	..s INTRType=$p(^DHCINTR(INTRRowID),"^",1)
	..;只取，TYPE=”K”-领入,TYPE=”T”-退回
	..q:(INTRType'="T")&&(INTRType'="K")
	..
	..;获取指针，检测发生改变动的业务单据是否存在
	..s INTRPointer=$p(^DHCINTR(INTRRowID),"^",9)
	..s DHCTRF=+INTRPointer,DHCTRFC=$p(INTRPointer,"||",2)
	..q:'$d(^DHCINIT(DHCTRF,"ITI",DHCTRFC))
	..
	..;只取 转移出库,TYPE=”T”
	..q:(INTRType'="T")
	..s Loc=$p(^DHCINIT(DHCTRF),"^",5)	;INIT_FrLoc_DR
	..if $d(^DHCEQTemp("GatherUseRecord","RelativeQty",$j,ExType,ExID,Loc))  d
	...;出库的
	...s InFlag=0
	..else  d
	...s Loc=$p(^DHCINIT(DHCTRF),"^",6)	;INIT_ToLoc_DR
	...if $d(^DHCEQTemp("GatherUseRecord","RelativeQty",$j,ExType,ExID,Loc))  d
	....;领用的
	....s InFlag=1
	...e  d
	....;不用的
	....s Loc=0
	..q:Loc=0
	..
	..;该科无消耗则不处理
	..q:'$d(^DHCEQTemp("GatherUseRecord","RelativeQty",$j,ExType,ExID,Loc))
	..i $g(^DHCEQTemp("GatherUseRecord","RelativeQty",$j,ExType,ExID,Loc))'>0 k ^DHCEQTemp("GatherUseRecord","RelativeQty",$j,ExType,ExID,Loc)
	..
	..s LastDate=$g(^DHCEQTemp("GatherUseRecord","STInfo",$j,ExType,ExID,Loc))
	..s PreDate=+$p(LastDate,"^",2)
	..s TotalQty=+$p(LastDate,"^",3)
	..s Amount=+$p(LastDate,"^",4)
	..s LastDate=+LastDate
	..i (PreDate>0)&&(TotalQty>0)  d
	...k ^DHCEQTemp("GatherUseRecord","RelativeQty",$j,ExType,ExID,Loc)
	..q:(PreDate>0)&&(TotalQty>0)
	..
	..;获取科室项目批次，并检测信息是否完整 
	..s INCLBRowID=$p(^DHCINTR(INTRRowID),"^",7)
	..s ILSub=$p(INCLBRowID,"||",2)
	..s INCLBSub=$p(INCLBRowID,"||",3)
	..q:'$d(^INCI(ExID,"IL",ILSub,"LB",INCLBSub))
	..;领用的
	..i InFlag="1"  d
	...i INTRDate>LastDate s LastDate=INTRDate
	...i (INTRDate<LastDate)&&(INTRDate'<PreDate)  d
	....s INTRUom=$p(^DHCINTR(INTRRowID),"^",10)
	....d TransUOM
	....;当领用日期等于 PreDate,则领用量和金额要累计,否则只取本记录的数量与金额
	....i INTRDate>PreDate  d
	.....s PreDate=INTRDate
	.....s TotalQty=-$p(^DHCINTR(INTRRowID),"^",6)*Fac
	.....s Amount=$p($g(^DHCINIT(DHCTRF,"ITI",DHCTRFC)),"^",16)
	....e  d
	.....s TotalQty=TotalQty-$p(^DHCINTR(INTRRowID),"^",6)*Fac
	.....s Amount=Amount+$p($g(^DHCINIT(DHCTRF,"ITI",DHCTRFC)),"^",16)
	..e  d
	...i (INTRDate'<PreDate)&&(INTRDate'>LastDate)  d
	....s ReturnQty=$p(^DHCINTR(INTRRowID),"^",6)
	....s INTRUom=$p(^DHCINTR(INTRRowID),"^",10)
	....s Amount=Amount-$p($g(^DHCINIT(DHCTRF,"ITI",DHCTRFC)),"^",16)
	....d TransUOM
	....s TotalQty=TotalQty+(ReturnQty*Fac)
	..s ^DHCEQTemp("GatherUseRecord","STInfo",$j,ExType,ExID,Loc)=LastDate_"^"_PreDate_"^"_TotalQty_"^"_Amount
	q
GetStandardQty	
	s Price= Amount/TotalQty
	;取该日期段 消耗耗材相对量
	s RelativeQty=0
	s QuantityType="2"
	s UseDate=PreDate-1	
	f  s UseDate=$o(^DHCEQUseConsumableItem(0,"UseDateExID",UseDate)) q:((UseDate="")||(UseDate>LastDate)||(SQLCODE'=0))  d
	.s RowID=0
	.f  s RowID=$o(^DHCEQUseConsumableItem(0,"UseDateExID",UseDate,Loc,ExType,ExID,QuantityType,RowID)) q:((RowID="")||(SQLCODE'=0))  d
	..s RelativeQty=RelativeQty+$p(^DHCEQUseConsumableItem(RowID),"^",8)
	;计算标准消耗
	s StandardQty=0
	i RelativeQty'=0 s StandardQty= TotalQty/RelativeQty
	s StandardQty=##Class(web.DHCEQCommon).FormatNumber(StandardQty,"",4)
	s Price=##Class(web.DHCEQCommon).FormatNumber(Price,"",2)
		
	s ^DHCEQTemp("GatherUseRecord","StandardQty",$j,ExType,ExID,Loc)=StandardQty_"^"_Price_"^"_TotalQty_"^"_RelativeQty
	
	q
TransUOM
	s Fac=1
	i (BaseUom'=INTRUom)  d
	.Set Config=##Class(websys.Configuration).%OpenId(1)
	.Set MEDDATA=Config.DataNamespace
	.Set CurrentNS=$ZNSPACE
	.ZN MEDDATA	
	.s Fac=$$UOMFac^DHCSTCOMMONSRV(INTRUom,BaseUom)
	.ZN CurrentNS
	q
}

/// 定义标准采集数据接口
/// Add by JDL 2011-11-2 JDL0101
/// 入参：	ExType：接口类型，如"DHC-HIS","DHC-LIS","DHC-RIS"等
/// 		ExDeviceID：对应系统内的设备唯一标识
/// 		ExItemDR：对应系统内服务项唯一标识
/// 		ExBussID：对应系统业务的唯一标识
/// 		UseDate:使用日期 格式"YYYY-MM-DD"
/// 		UseLocDR:使用记录发生科室
/// 		WorkLoadNum:工作量
/// 		Price：服务单价
/// 		TotalFee：服务总金额
/// 		PatientInfo：使用设备的患者信息
/// 		OtherInfo：其他信息  StartTime^EndDate^EndTime^Remark
/// 返回：""成功，其他失败
/// 		
ClassMethod GatherRecord(ExType, ExDeviceID, ExItemDR, ExBussID, UseDate, UseLocDR, WorkLoadNum, Price As %Library.String = "", TotalFee As %Library.String = "", PatientInfo As %Library.String = "", OtherInfo As %Library.String = "")
{
	;UseDate,UseLocDR,PatientInfo,WorkLoadNum,Price,TotalFee,ExType,ExBussID
	;IsInputFlag,Status,InvalidFlag,
	n SourceType,SourceID,StartTime,EndDate,EndTime,WorkLoadUnitDR,Year,Month,ServiceItemDR,Remark,ModelDR
	n Val
	
	s ErrCode=""
	
	;均为指定设备
	s SourceType=1
	
	;获取对应的服务项
	s ServiceItemDR=..GetServiceByExID(ExType,ExItemDR)
	i ServiceItemDR="" s ErrCode="NoServiceItem"
	i ErrCode'="" q ErrCode
	
	;如传递有设备信息，则通过设备对照获取设备系统里的设备DR
	if ExDeviceID'=""
	{
		s SourceID=..GetEquipByDevice(ExType,ExDeviceID)
		i SourceID="" s ErrCode="DeviceNoMap"
	}
	else
	{
		;根据服务获取对应的设备
		s SourceID=..GetEquipByService(ServiceItemDR,UseLocDR)
 		i SourceID="" s ErrCode="NoEquip"		
	}
	i ErrCode'="" q ErrCode
	s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)	
	s WorkLoadUnitDR=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",3)
	i WorkLoadNum="" s WorkLoadNum=1
	i Price="" s Price=..GetServicePriceByExID(ExType, ExItemDR, UseDate)
	i TotalFee="" s TotalFee=WorkLoadNum*Price

	s StartTime=$p(OtherInfo,"^",1)
	s EndDate=$p(OtherInfo,"^",2)
	s EndTime=$p(OtherInfo,"^",3)
	s Remark=$p(OtherInfo,"^",4)
	
	
	s Year=$p(UseDate,"-",1)
	s Month=$p(UseDate,"-",2)
	s UseDate=$ZDH(UseDate,3)
	
	
	s IsInputFlag="N"
	s Status=""
	s InvalidFlag="N"
	
	
	s Val=SourceType_"^"_SourceID_"^"_UseDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_Price_"^"_TotalFee_"^"_Year_"^"_Month_"^"_ServiceItemDR_"^"_ExType_"^"_ExBussID_"^"_IsInputFlag_"^"_Status_"^"_InvalidFlag_"^"_Remark_"^^^^^^^"_ModelDR
	s ErrCode=##Class(web.DHCEQUseRecord).SaveUseRecord("",IsInputFlag,"",Val)
	if ErrCode'>0 q "SaveError"
	q ""
}

/// 采集锐珂pacs的相关使用记录 //add by zy 2011-11-11 ZY0085 地坛锐珂Pacs
/// w ##Class(web.DHCEQIUsedRecord).GatherPacs(+$H)
ClassMethod GatherPacs(GatherDate, vType)
{
	n (GatherDate,vType)
	
	;s ExType="Pacs"
	s ExType=vType
	s SourceType=1	;类型为设备
	
	s tmpDate=$ZD(GatherDate,3)
	s Year=$p(tmpDate,"-",1)
	s Month=$p(tmpDate,"-",2)		
	s IsInputFlag="N"	;系统采集,非手工录入
	s Status=2		;系统自动采集的自动置为审核状态
	s InvalidFlag="N"
	s Remark=""
	
	;记录采集结果开始时间
	s Count=0
	s Version=$o(^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,""),-1)
	s Version=1+Version
	s ErrCode=""
	s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"BeginTime")=$H
	
	s Job=$j
	
	;取做的项目
	s Item=0
	f  s Item=$o(^DHCEQIUseRecordQueue(0,"ExTypeItem",ExType,GatherDate,Item))  quit:(Item="")  d 
	.
	.s (ServiceItemDR,WorkLoadUnitDR)=""
	.s Price=0
	.s ServiceItemDR=..GetServiceByExID(ExType,Item)
	.;如果未定义服务项,则需自动生成服务项目
	.i (ServiceItemDR="")  d
	..s ServiceItemDR=##Class(web.DHCEQIUsedRecord).AutoSaveServiceItem(ExType,Item,GatherDate)
	..i ServiceItemDR=""  s ErrCode="NoServiceItem"
	.i ServiceItemDR'=""  d
	..s WorkLoadUnitDR=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",3)
	..s Price=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",4)
	.
	.s RowID=0
	.f  s RowID=$o(^DHCEQIUseRecordQueue(0,"ExTypeItem",ExType,GatherDate,Item,RowID))  quit:(RowID="")  d 
	..s (CancelFlag,Status,ExID,Device,SourceID,ModelDR,StartDate,StartTime,EndDate,EndTime)=""
	..s (WorkLoadNum,WorkLoadUnitDR,UseLocDR,UseDate,PatientInfo,TotalFee,ErrCode)=""
	..
	..s CancelFlag=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",17)
	..q:CancelFlag="Y"
	..s Status=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",32)
	..q:Status'="0"		//只更新新增的数据
	..
	..s ExID=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",4)
	..s Device=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",2)
	..s SourceID=..GetEquipByDevice(ExType,Device)
	..i SourceID="" s ErrCode="DeviceNoMap"
	..i SourceID'="" s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
	..s StartDate=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",11)
	..i StartDate'="" s StartDate=$ZD(StartDate,4)
	..s StartTime=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",12)
	..i StartTime'="" s StartTime=$ZT(StartTime)
	..s EndDate=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",13)
	..i EndDate'="" s EndDate=$ZD(EndDate,4)
	..s EndTime=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",14)
	..i EndTime'="" s EndTime=$ZT(EndTime)
	..s WorkLoadNum=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",7)
	..s UseLocDR=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",5)			///需要做对照
	..i SourceID'="" s UseLocDR=$p($g(^DHCEQEquip(SourceID)),"^",19)	///根据设备对照取科室的使用科室
	..s UseDate=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",6)			///使用日期
	..i UseDate'="" s UseDate=$ZD(UseDate,4)
	..s PatientID=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",10)
	..s Price=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",8)		//费用无效
	..s TotalFee=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",9)
	..s Operator=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",15)		//操作员
	..s OtherInfo=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",16)					//Add By DJ 2015-09-29 DJ0169 begin
	..s DoctorOrderID=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",19)		//医嘱ID
	..s PositiveFlag=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",20)		//阳性标志
	..s SampleNo=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",21)		//医技流水号
	..s ExposureNum=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",22)		//曝光次数
	..s PatientSex=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",23)		//患者性别
	..s PatientAge=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",24)		//患者年龄
	..s PatientName=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",33)		//患者姓名
	..s URQHold1=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",34)
	..s URQHold2=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",35)
	..s URQHold3=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",36)
	..s URQHold4=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",37)
	..s URQHold5=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",38)			//Add By DJ 2015-09-29 DJ0169 end
	..s Val=SourceType_"^"_SourceID_"^"_UseDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientID_"^"_Price_"^"_TotalFee_"^"_Year_"^"_Month_"^"_ServiceItemDR_"^"_ExType_"^"_ExID_"^"_IsInputFlag_"^"_Status_"^"_InvalidFlag_"^"_Remark_"^^^^^^^"_ModelDR_"^^^^^^^^^^"_DoctorOrderID_"^"_Operator_"^"_PositiveFlag_"^"_SampleNo_"^"_ExposureNum_"^"_PatientSex_"^"_PatientAge_"^"_PatientName_"^"_OtherInfo_"^"_URQHold1_"^"_URQHold2_"^"_URQHold3_"^"_URQHold4_"^"_URQHold5
	..
	..;记录结果
	..s Count=Count+1
	..i ErrCode'="" s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,ErrCode,Count)=ErrCode_"^"_Item_"^"_Device_"^"_Val
	..q:ErrCode'=""
	..s Result=##Class(web.DHCEQUseRecord).SaveUseRecord("",IsInputFlag,"",Val)
	..;记录采集结果
	..s Node="Error"
	..i Result>0  d
	...s Node="Success"
	...s Result=##Class(web.DHCEQIUseRecordQueue).SaveData(RowID,"2","1")
	..e  d
	...s Result=##Class(web.DHCEQIUseRecordQueue).SaveData(RowID,"1","1")
	..i Result'=0 s Node="UpdateIUseRecordQueueFail"
	..
	..s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=Result_"^"_Item_"^"_Device_"^"_Val
	
	;记录采集结束时间
	s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"EndTime")=$H
	q 0
}

/// //add by zy 2011-11-11 ZY0085 地坛锐珂Pacs
/// d ##Class(web.DHCEQIUseRecord).ExectWebService()
ClassMethod ExecSoap(Date)
{
	;2011-01-01  62092
	;new objService,objDataSet,Date,BeginTime,EndTime,Node
	;new OrderID,DeviceID,ItemID,BussID,UseLocID,UseDate,WorkLoadNum,Price,TotalFee,PatientInfo,StartDate,StartTime,EndDate,EndTime,Operator
	;i Date="" set Date=+$h	
	set Date=+$h
	set BeginTime=$ZDT(Date-1,3)
	set EndTime=$ZDT(Date,3)
	set Node="GetPacsData"
	set ^DHCEQLog("Job",Node,Date,"Begin")=$H
	set objService=##class(Service1.Service1Soap).%New()
	set objDataSet=objService.GetBussListData(BeginTime,EndTime)
	For  Quit:'objDataSet.Next()  Do
	.if $d(objDataSet.Data("BussID"))'="" d
	..s (OrderID,DeviceID,ItemID,BussID,UseLocID,UseDate,WorkLoadNum,Price,TotalFee,PatientInfo,StartDate,StartTime,EndDate,EndTime,Operator)=""
	..i $D(objDataSet.Data("OrderID")) s OrderID=objDataSet.Data("OrderID")
	..i $D(objDataSet.Data("DeviceID")) s DeviceID=objDataSet.Data("DeviceID")
	..i $D(objDataSet.Data("ItemID")) s ItemID=objDataSet.Data("ItemID")
	..i $D(objDataSet.Data("BussID")) s BussID=objDataSet.Data("BussID")
	..i $D(objDataSet.Data("UseLocID")) s UseLocID=objDataSet.Data("UseLocID")
	..i (UseLocID="")||(UseLocID=$c(0)) s UseLocID="1"
	..i $D(objDataSet.Data("UseDate")) s UseDate=objDataSet.Data("UseDate")
	..i $D(objDataSet.Data("WorkLoadNum")) s WorkLoadNum=objDataSet.Data("WorkLoadNum")
	..i $D(objDataSet.Data("Price")) s Price=objDataSet.Data("Price")
	..i $D(objDataSet.Data("TotalFee")) s TotalFee=objDataSet.Data("TotalFee")
	..i $D(objDataSet.Data("PatientInfo")) s PatientInfo=objDataSet.Data("PatientInfo")
	..i $D(objDataSet.Data("StartDate")) s StartDate=objDataSet.Data("StartDate")
	..i $D(objDataSet.Data("StartTime")) s StartTime=objDataSet.Data("StartTime")
	..i $D(objDataSet.Data("EndDate")) s EndDate=objDataSet.Data("EndDate")
	..i $D(objDataSet.Data("EndTime")) s EndTime=objDataSet.Data("EndTime")
	..i $D(objDataSet.Data("Operator")) s Operator=objDataSet.Data("Operator")
	..s val=OrderID_"^"_DeviceID_"^"_ItemID_"^"_BussID_"^"_UseLocID_"^"_UseDate_"^"_WorkLoadNum_"^"_Price_"^"_TotalFee_"^"_PatientInfo_"^"_StartDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_Operator
	..s Error=0
	..s Error=##Class(web.DHCEQIUseRecordQueue).SaveData("",val,"0")
	..i Error'=0 s ^DHCEQLog("Job",Node,Date,"Result",Error)=val
	
	set ^DHCEQLog("Job",Node,Date,"End")=$H
}

/// DHCRIS获取使用记录信息   2014-11
/// 根据登记日期获取
/// w ##Class(web.DHCEQIUsedRecord).GatherDHCRISNew(64510)
/// RIS新版系统STUDYINFO,MODALITY
ClassMethod GatherDHCRISNew(GatherDate As %String, EquipID As %String = "") As %String
{
	s ExType="DHC-RIS"
	s SourceType=1	;类型为设备
	s tmpDate=$ZD(GatherDate,3)
	s Year=$p(tmpDate,"-",1)
	s Month=$p(tmpDate,"-",2)
	s IsInputFlag="N"	;系统采集,非手工录入
	//Modefied by zc 2018-12-21 zc0047  将Status修改为RINStatus，避免任务挂起
	s RINStatus=2		;系统自动采集的自动置为审核状态
	s InvalidFlag="N"
	s Remark=""
	
	;记录采集结果开始时间
	s Count=0
	s Version=$o(^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,""),-1)
	s Version=1+Version
	s ErrCode=""
	s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"BeginTime")=$H
	
	s SourceID=0
	f  s SourceID=$o(^DHCEQDeviceMap(0,"Equip",SourceID)) quit:SourceID=""  d
	.q:(EquipID'="")&(EquipID'=SourceID)
	.s DMRowID=0
	.f  s DMRowID=$o(^DHCEQDeviceMap(0,"Equip",SourceID,ExType,DMRowID)) quit:DMRowID=""  d
	..s DeviceMap=$g(^DHCEQDeviceMap(DMRowID))
	..q:$p(DeviceMap,"^",5)="Y"
	..s DeviceID=$p(DeviceMap,"^",3)
	..s DateType="Report"	//Study
	..
	..d ##Class(web.DHCEQIUsedRecord).GatherDHCRISByDeviceID(ExType,GatherDate,DeviceID,DateType)
	..
	..s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
	..s StudyNo=""
	..f  s StudyNo=$o(^DHCEQTemp("Gather","Result","DHC-RIS",tmpDate,DeviceID,StudyNo)) quit:StudyNo=""  d
	...//q:(DeviceID=83)&&(StudyNo'["MR")
	...s TempData=$G(^DHCEQTemp("Gather","Result","DHC-RIS",tmpDate,DeviceID,StudyNo))
	...i DateType="Report" d
	....s UseDate=$p(TempData,"^",8)
	...e  d
	....s UseDate=$p(TempData,"^",7)
	...e  d
	...i ((UseDate="")||(UseDate="1901-01-01 00:00:00")) d
	....s UseDate=$ZD($ZDH(tmpDate,3),4)
	...e  d
	....s UseDate=$ZD($ZDH($e(UseDate,1,10),3),4)
	...s StartTime=""
	...s EndDate=UseDate
	...s EndTime=""
	...s WorkLoadNum=1
	...s WorkLoadUnitDR=""
	...s UseLocDR=$p(TempData,"^",6)
	...s PatientID=$p(TempData,"^",9)
	...s PatientInfo=$p(TempData,"^",10)
	...i PatientID'="" s PatientInfo=##Class(web.DHCEQIUsedRecord).GetPatientInfo("DHC-HIS",PatientID)
	...s Price=$p(TempData,"^",3)
	...s Item=$p(TempData,"^",2)
	...i Item="" d
	....zn "PACS"
	....s ID=$o(^User.STUDYITEMVALUEI("STACCNUMIndex"," "_StudyNo,0))
	....s Item=$LIST($g(^User.STUDYITEMVALUED(ID)),1)
	....zn "DHC-APP"
	...quit:Item=""
	...s Price=##Class(web.DHCEQIUsedRecord).GetServicePriceByExID(ExType,Item, GatherDate)
	...s Price=##Class(web.DHCEQCommon).FormatNumber(Price,"",2)
	...s TotalFee=Price
	...s oeorowid=$p(TempData,"^",5)
	...s OperatorID=$p(TempData,"^",11)
	...s YinYang=$p(TempData,"^",13)
	...s ExID=StudyNo
	...
	...s ServiceItemDR=##Class(web.DHCEQIUsedRecord).GetServiceByExID(ExType,Item)
	...;如果未定义服务项,则需自动生成服务项目
	...i ServiceItemDR="" s ServiceItemDR=##Class(web.DHCEQIUsedRecord).AutoSaveServiceItem(ExType,Item,GatherDate)
	...i ServiceItemDR="" s ErrCode="NoServiceItem"
	...
	...i ServiceItemDR'="" s WorkLoadUnitDR=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",3)
	...;//Modefied by zc 2018-12-21 zc0047  将Status修改为RINStatus，避免任务挂起
	...s Val=SourceType_"^"_SourceID_"^"_UseDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_Price_"^"_TotalFee_"^"_Year_"^"_Month_"^"_ServiceItemDR_"^"_ExType_"^"_ExID_"^"_IsInputFlag_"^"_RINStatus_"^"_InvalidFlag_"^"_Remark_"^^^^^^^"_ModelDR_"^"_OperatorID_"^"_YinYang_"^^^"
	...
	...;记录没有存下的数据信息
	...s Count=Count+1
	...i ErrCode'="" s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,ErrCode,Count)=ErrCode_"^"_Item_"^"_DeviceID_"^"_Val
	...q:ErrCode'=""
	...
	...s Result=##Class(web.DHCEQUseRecord).SaveUseRecord("",IsInputFlag,"",Val)
	...;记录采集结果
	...s Node="Error"
	...i Result>0 s Node="Success"
	...s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=Result_"^"_Item_"^"_DeviceID_"^"_Val
	
	//s ^DHCEQTemp("Gather","Result","DHC-RIS",date,"Cancel",StudyNo)=""
	;DHCRB_ReturnFee
	;获取该日取消检查ID
	s StudyNo=""
	f  s StudyNo=$o(^DHCEQTemp("Gather","Result","DHC-RIS",tmpDate,"Cancel",StudyNo))  quit:(StudyNo="")  d
	.s ExID=StudyNo
	.s ErrCode=..CancelUseRecordByExID(ExType,ExID,GatherDate)
	.s Count=Count+1
	.
	.s Node="CancelError"
	.i ErrCode=0 s Node="CancelSuccess"
	.s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=ErrCode_"^"_ExID
	
	;记录采集结束时间
	s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"EndTime")=$H
	q 0
}

/// 获取RIS系统中的使用记录，通过参数日期，查询当天所有的检查记录。
/// 入参：
/// 		SysType:    系统类型（必传）    RIS（放射数据），PIS(病理数据)… 
/// 		GatherDate:  日期（必传）       格式dd/mm/yy
/// 		EquipID：   设备ID（可选）     设备ID不为空时，返回指定设备该日期所作检查，设备ID为空时，返回所有设备该日期所作检查
/// 		DateType	"Study"/"Report"	因为有些医院或某些科室不用“技师工作站”（我们系统里的一个控件），所以查询时要用报告时间（Report）来确定。
/// 		反之可以用真正的检查时间（Study）来确定。
/// 输出：
///       Info= 设备ID_"^"_检查项目ID(医嘱项)_"^"_价格_"^"_费用_"^"_医嘱号ID_"^"_检查科室ID_"^"_检查开始时间_"^"_检查结束时间_"^"_病人ID号_”^”_病人信息(名称，性别)_"^"_操作医生ID(SS_User) _"^"_RIS系统业务号（每一个检查的唯一业务id）_"^"_阴性/阳性 
/// 建议可以将获取的数据以字符串形式存到临时golable中,golable节点如下:
///     ///^DHCEQTemp("Gather","Result","DHC-RIS", GatherDate, Count)= Info
///     ^DHCEQTemp("Gather","Result","DHC-RIS","Cancel",StudyNo)=StudyNo
/// 		去掉了 GatherDate 原因是取消的接口本身确定不了检查时间，且取消的并不多
/// 		
/// DHCRIS获取使用记录信息
/// 根据登记日期获取
/// w ##Class(web.DHCEQIUsedRecord).GatherDHCRISByDeviceID("DHC-RIS","64510","92","Report")
/// RIS相关的Global:^DHCPACRegInfoi,^DHCPACRegInfo,^DHCRBRFi,^DHCRBRF,^RBC("EQ"
ClassMethod GatherDHCRISByDeviceID(SysType As %String, GatherDate As %String, EquipID As %String = "", DateType As %String = "Report") As %String
{
	//Info= 设备ID_"^"_检查项目ID(医嘱项)_"^"_价格_"^"_费用_"^"_医嘱号ID_"^"_检查科室ID
	//_"^"_检查开始时间_"^"_检查结束时间_"^"_病人ID号_”^”_病人信息(名称，性别)_"^"_
	//操作医生ID(SS_User)_"^"_检查号_"^"_阴性/阳性
	s (itemcode,price,oeorowid,loccode)=""
	s (ststarttime,stendtime,patid,name,sex)=""
	s (usercode,staccnum,yinyang)=""
	
	s (mdlid,itemid,price,oeorowid,locid)=""
	s (ststarttime,stendtime,patid,name,sex)=""
	s (userid,staccnum,yinyang)=""
	s mdlid=EquipID
	i (SysType="DHC-RIS")
	{
		s info=""
		//s date=$zd($zdh(GatherDate,4),3)
		s date=$zd(GatherDate,3)
		i EquipID'="" d
		.k ^DHCEQTemp("Gather","Result","DHC-RIS",date,EquipID)
		e  d
		.k ^DHCEQTemp("Gather","Result","DHC-RIS",date)
		
		zn "PACS"
		d ##class(PACS.RISInterface).ModalityBenefitStatistics(date,EquipID,DateType)
		i EquipID'="" d
		.s staccnum="" f  s staccnum=$o(^DHCPACSEQTemp("Gather","Result","DHC-RIS",date,EquipID,staccnum),1,info) q:staccnum=""  d
		..zn "DHC-APP"
		..s dhcinfo=..GatherDHCRISCodetoId(info)
		..q:dhcinfo=""
		..s eqid=+$p(dhcinfo,"^",1)
		..q:eqid=0
		..s ^DHCEQTemp("Gather","Result","DHC-RIS",date,eqid,staccnum)=dhcinfo
		..zn "PACS"
		e  d
		.s mdlid1="" f  s mdlid1=$o(^DHCPACSEQTemp("Gather","Result","DHC-RIS",date,mdlid1)) q:mdlid1=""  d
		..s staccnum="" f  s staccnum=$o(^DHCPACSEQTemp("Gather","Result","DHC-RIS",date,mdlid1,staccnum),1,info) q:staccnum=""  d
		...zn "DHC-APP"
		...s dhcinfo=..GatherDHCRISCodetoId(info)
		...q:dhcinfo=""
		...s eqid=+$p(dhcinfo,"^",1)
		...//q:(eqid=83)&&(staccnum'["MR")
		...q:eqid=0
		...s ^DHCEQTemp("Gather","Result","DHC-RIS",date,eqid,staccnum)=dhcinfo
		...zn "PACS"
		zn "DHC-APP"
		//查询取消检查
		k ^DHCEQTemp("Gather","Result","DHC-RIS",date,"Cancel")
		s eqid=0 f  s eqid=$o(^DHCEQTemp("Gather","Result","DHC-RIS",date,eqid)) q:eqid=""  d
		.s StudyNo="" f  s StudyNo=$o(^DHCPACSEQTemp("Gather","Result","DHC-RIS",date,eqid,StudyNo)) q:StudyNo=""  d
		..s ristemp=""
		..s ristemp=$g(^DHCEQRISTemp("Gather","Result","DHC-RIS","Cancel",StudyNo))
		..i ristemp'="" d
		...s ^DHCEQTemp("Gather","Result","DHC-RIS",date,"Cancel",StudyNo)=""
	}
	q 0
}

// 

/// w ##Class(web.DHCEQIUsedRecord).GatherDHCRISCodetoId("88^A056000002^100^100^4945903||12^骨密度室^1901-01-01 00:00:00^1901-01-01 00:00:00^0002055813^张爱玲,女^^GMD0017646^")
ClassMethod GatherDHCRISCodetoId(info As %String) As %String
{
	q:info="" ""
	s mdlid=$p(info,"^",1)
	q:mdlid="" ""
	s itemcode=$p(info,"^",2)
	q:itemcode="" ""
	s price=$p(info,"^",3)
	s fee=$p(info,"^",4)
	s oeorowid=$p(info,"^",5)
	s loccode=$p(info,"^",6)
	s ststarttime=$p(info,"^",7)
	s stendtime=$p(info,"^",8)
	s patid=""   //病人ID（非登记号）
	s patinfo=$p(info,"^",10)
	s usercode=$p(info,"^",11)
	s studyno=$p(info,"^",12)
	s yinyang=$p(info,"^",13)
	
	s (itemid,locid,patid,userid)=""
	s itemidSubscript=$o(^ARCIM(0,"Code",itemcode,""))
	i itemidSubscript'="" d
	.s itemidVersion=$o(^ARCIM(0,"Code",itemcode,itemidSubscript,""))
	.s itemid=itemidSubscript_"||"_itemidVersion
	i loccode'="" d
	.s locid=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(loccode),""))
	i oeorowid'="" d
	.s orderrowid=$p(oeorowid,"||",1)
	.s paadmdr=$p($g(^OEORD(orderrowid)),"^",1)
	.i paadmdr'="" s patid=$p($g(^PAADM(paadmdr)),"^",1)
	i usercode'="" d
	.s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	
	s drinfo=mdlid_"^"_itemid_"^"_price_"^"_fee_"^"_oeorowid_"^"_locid_"^"_ststarttime_"^"_stendtime_"^"_patid_"^"_patinfo_"^"_userid_"^"_studyno_"^"_yinyang
	q drinfo
}

/// add by zx 2020-03-13 BUG ZX0079
/// 通过综合查询WorkLoad获取效益分析数据
/// w ##Class(web.DHCEQIUsedRecord).GatherDHCHIS("65226")
ClassMethod GatherDHCHISNew(GatherDate)
{
	n (GatherDate)
	
	s ExType="DHC-HIS"
	s SourceType=1	;类型为设备
	
	;i GatherDate'="" s GatherDate=GatherDate+1
	s tmpDate=$ZD(GatherDate,3)
	s Year=$p(tmpDate,"-",1)
	s Month=$p(tmpDate,"-",2)		
	s IsInputFlag="N"	;系统采集,非手工录入
	s IUStatus=2		;系统自动采集的自动置为审核状态
	s InvalidFlag="N"
	s Remark=""
	
	;记录采集结果开始时间
	s Count=0
	s Version=$o(^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,""),-1)
	s Version=1+Version
	s ErrCode=""
	s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"BeginTime")=$H
	
	s WorkLoadRowid=""
	f  s WorkLoadRowid=$o(^DHCWorkLoad(0,"ORDDATE",GatherDate,WorkLoadRowid)) q:WorkLoadRowid=""  d
	.s Item=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",2)
 	.s OriRecDept=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",1)
 	.s ErrCode=""
 	.s ServiceItemDR=0
 	.f  s ServiceItemDR=$o(^DHCEQCCode("DHCEQCServiceItem",0,"ExID",ExType,Item,ServiceItemDR))  quit:ServiceItemDR=""  d 
	..q:$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",12)'="N"
 	..s SourceID=..GetEquipByService(ServiceItemDR,OriRecDept)
 	..i SourceID="" s ErrCode="NoEquip"
 	..q:ErrCode'=""
	..s ModelDR=""
 	..i SourceID'="" s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
 	..;记录本次轮询到的设备ID
 	..s ^DHCEQEquipService(0,"EX","Rotate",ServiceItemDR,OriRecDept)=SourceID
 	..s ExID=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",21)
 	..s UseDate=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",5)	;OEORI_SttDat
	..s StartTime=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",6)	;OEORI_SttTim
	..i UseDate'="" s UseDate=$ZD(UseDate,4)
	..i StartTime'="" s StartTime=$zt(StartTime)
	..s EndDate=""
	..s EndTime=""
	..s WorkLoadUnitDR=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",3)
	..s PatientID=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",13)
	..s PatientInfo=##Class(web.DHCEQIUsedRecord).GetPatientInfo("DHC-HIS",PatientID)
	..s Quantity=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",15)
	..s Price=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",14)
	..s WorkLoadNum=Quantity
 	..s Amount=Price*Quantity
	..s UseLocDR=OriRecDept
	..s Price=Price
	..s TotalFee=Amount
	..
	..s Val=SourceType_"^"_SourceID_"^"_UseDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_Price_"^"_TotalFee_"^"_Year_"^"_Month_"^"_ServiceItemDR_"^"_ExType_"^"_ExID_"^"_IsInputFlag_"^"_IUStatus_"^"_InvalidFlag_"^"_Remark_"^^^^^^^"_ModelDR
	..
	..;记录结果
	..s Count=Count+1
	..i ErrCode'="" s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,ErrCode,Count)=ErrCode_"^"_Item_"^"_SourceID_"^"_Val
	..q:ErrCode'=""
	..
	..s Result=##Class(web.DHCEQUseRecord).SaveUseRecord("",IsInputFlag,"",Val)
	..;记录采集结果
	..s Node="Error"
	..i Result>0 s Node="Success"
	..s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=Result_"^"_Item_"^"_SourceID_"^"_Val
 	
 	;记录采集结束时间
	s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"EndTime")=$H
	q 0
}

}
