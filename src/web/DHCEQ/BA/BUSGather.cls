/// modified by ZY0279 20210907  修改了表结构，增加值保存
Class web.DHCEQ.BA.BUSGather Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 根据扩展ID取消对应的使用记录,目前主要是HIS取消医嘱和RIS接口有取消的情况
/// ExType:
/// ExID:医嘱ID
/// w ##Class(web.DHCEQ.BA.BUSGather).CancelUseRecordByExID("DHC-RIS","",61251)
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

/// modified by ZY0299 增加采集记录
/// 不计费耗材，打包收费耗材，单独计费耗材(不用统计)
/// add by zx 2020-03-13 BUG ZX0079
/// 通过综合查询WorkLoad获取效益分析数据
/// w ##Class(web.DHCEQ.BA.BUSGather).GatherDHCHISNew("65226")
ClassMethod GatherDHCHISNew(GatherDate, EquipID As %String = "", GRowID As %String = "")
{
	n (GatherDate,EquipID,GRowID)
	
	s ExType="DHC-HIS"
	s SourceType=1	;类型为设备
	s vJob=$J
	
	;i GatherDate'="" s GatherDate=GatherDate+1
	s tmpDate=$ZD(GatherDate,3)
	s Year=$p(tmpDate,"-",1)
	s Month=$p(tmpDate,"-",2)		
	s IsInputFlag="N"	;系统采集,非手工录入
	s IUStatus=2		;系统自动采集的自动置为审核状态
	s InvalidFlag="N"
	s Remark=""
	
	k ^TempDHCEQ("GetEquipByService",vJob)
	/// modified by ZY0299
	s BeginTime=$H
	
	;记录采集结果开始时间
	s Count=0
	/// modified by ZY0299
	i GRowID=""
	{
		s Version=$o(^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,""),-1)
	}else
	{
		s Version=$o(^DHCEQGatherList(0,"Version",GRowID,ExType,GatherDate,""),-1)
	}
	s Version=1+Version
	s ErrCode=""
	/// modified by ZY0299
	//s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"BeginTime")=$H
	//0,"BussService",BussType,ServiceDR,SourceType,SourceID
	
	s ServiceItemDR=0
	f  s ServiceItemDR=$o(^DHCEQEquipService(0,"BussService",0,ServiceItemDR))  q:ServiceItemDR=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",12)="Y"
	.q:$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",5)'=ExType
	.///先判断设备是否有当前服务项的对照信息
	.q:(EquipID'="")&&(##Class(web.DHCEQ.BA.CTEquipService).CheckEquipByService(0,ServiceItemDR,EquipID)=0)
	.s ItemOrdID=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",6)
	.
	.q:$Data(^DHCWorkLoad(0,"DateItemOrd",GatherDate,ItemOrdID))=0
	.s WorkLoadRowid=""
	.f  s WorkLoadRowid=$o(^DHCWorkLoad(0,"DateItemOrd",GatherDate,ItemOrdID,WorkLoadRowid)) q:WorkLoadRowid=""  d
	..///modified by ZY 20211012
	..///补采逻辑修改：医嘱没有采集过的记录；轮询过的设备，不能参与轮询，剩下的设备参与轮询
	..///ExID 存医嘱ID,避免通过不同系统重复采集了收入数据.
 	..s ExID=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",21)
	..s ExitFlag=0
	..i ExID'="" d
	...s vExType=""
	...f  s vExType=$o(^DHCEQUseRecord(0,"ExID",vExType))  q:(vExType="")||(ExitFlag=1)  d
	....i $o(^DHCEQUseRecord(0,"ExID",vExType,ExID,0))'="" s ExitFlag=1
	..q:ExitFlag=1
	..
	..s OriRecDept=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",1)
 	..s SourceID=##Class(web.DHCEQ.BA.CTEquipService).GetEquipByService(ServiceItemDR,OriRecDept,vJob,GatherDate)
 	..s ErrCode=""
 	..i SourceID="" s ErrCode="NoEquip"
 	..q:ErrCode'=""
	..s ModelDR=""
 	..i SourceID'="" s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
 	..;记录本次轮询到的设备ID
 	..s ^DHCEQEquipService(0,"EX","Rotate",ServiceItemDR,OriRecDept)=SourceID
 	..//放在轮询之后,这样不影响轮询的记录,避免把所有的数据记到一个设备上
 	..q:(EquipID'="")&&(EquipID'=SourceID)
 	..
	..s AdmID=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",12)
	..s NeedPayed=0
	..s AdmType=$p($g(^PAADM(AdmID)),"^",2)
	..i AdmType="O" s NeedPayed=1
	..;患者类型，门诊患者则只取付费的，住院则取核实或执行的
	..q:(($p($g(^DHCWorkLoad(WorkLoadRowid)),"^",17)'="P")&&(NeedPayed=1))
	../// modified by ZY0299
 	..s ExID=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",21)
 	..s UseDate=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",5)	;OEORI_SttDat
	..s StartTime=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",6)	;OEORI_SttTim
	..i UseDate'="" s UseDate=$ZD(UseDate,4)
	..i StartTime'="" s StartTime=$zt(StartTime)
	..s EndDate=""
	..s EndTime=""
	..s WorkLoadUnitDR=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",3)
	..s PatientID=$p(^PAADM(AdmID),"^",1)
	..s Quantity=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",15)
	..s Price=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",14)
	..s Operator=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",18)
	..s DoctorOrderID=$p($g(^DHCWorkLoad(WorkLoadRowid)),"^",21)
	..s WorkLoadNum=Quantity
 	..s Amount=Price*Quantity
	..s UseLocDR=OriRecDept
	..s Price=Price
	..s TotalFee=Amount
	..
	..s PatientID=$p(^PAADM(AdmID),"^",1)
	..s (PatientName,PatientSex,PatientAge)=""
	..i PatientID'="" d
	...s PatientName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	...s PatientSex= $p($g(^PAPER(PatientID,"ALL")),"^",7)
	...i PatientSex'="" s PatientSex= $p($g(^CT("SEX",PatientSex)),"^",2)
	...s PatientSex=""	//$Case(PatientSex,"":"","1":"M","2":"F","3":"","4":"")	//modified by ZY0279 20210907
	...s PatientAge=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	..
	..s objUseRecord=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	..d objUseRecord.%Set("URSourceType",SourceType)
	..d objUseRecord.%Set("URSourceID",SourceID)
	..d objUseRecord.%Set("URUseDate",UseDate)
	..d objUseRecord.%Set("URStartTime",StartTime)
	..d objUseRecord.%Set("UREndDate",EndDate)
	..d objUseRecord.%Set("UREndTime",EndTime)
	..d objUseRecord.%Set("URWorkLoadNum",WorkLoadNum)
	..d objUseRecord.%Set("URWorkLoadUnitDR",WorkLoadUnitDR)
	..d objUseRecord.%Set("URUseLocDR",UseLocDR)
	..d objUseRecord.%Set("URPatientID",PatientID)
	..d objUseRecord.%Set("URPrice",Price)
	..d objUseRecord.%Set("URTotalFee",TotalFee)
	..d objUseRecord.%Set("URYear",Year)
	..d objUseRecord.%Set("URMonth",Month)
	..d objUseRecord.%Set("URServiceItemDR",ServiceItemDR)
	..d objUseRecord.%Set("URExType",ExType)
	..d objUseRecord.%Set("URExID",ExID)
	..d objUseRecord.%Set("URIsInputFlag",IsInputFlag)
	..d objUseRecord.%Set("URStatus",IUStatus)
	..d objUseRecord.%Set("URInvalidFlag",InvalidFlag)
	..d objUseRecord.%Set("URRemark",Remark)
	..d objUseRecord.%Set("URModelDR",ModelDR)
	..
	..d objUseRecord.%Set("URDoctorOrderID",DoctorOrderID)
	..d objUseRecord.%Set("UROperator",Operator)
	..;d objUseRecord.%Set("URPositiveFlag",PositiveFlag)
	..;d objUseRecord.%Set("URSampleNo",SampleNo)
	..;d objUseRecord.%Set("URExposureNum",ExposureNum)
	..d objUseRecord.%Set("URStartDate",UseDate)
	..d objUseRecord.%Set("URPatientSex",PatientSex)
	..d objUseRecord.%Set("URPatientAge",PatientAge)
	..d objUseRecord.%Set("URPatientName",PatientName)
	..d objUseRecord.%Set("URExecDeptDR",OriRecDept)
	..d objUseRecord.%Set("URAdmissionType",AdmType)
	..d objUseRecord.%Set("UROrdDate",UseDate)
	..d objUseRecord.%Set("UROrdTime",StartTime)
	..;d objUseRecord.%Set("URRegDate",RegDate)
	..;d objUseRecord.%Set("URRegTIme",RegTIme)
	..;d objUseRecord.%Set("URArriveDate",ArriveDate)
	..;d objUseRecord.%Set("URArriveTime",ArriveTime)
	..;d objUseRecord.%Set("URReportDate",ReportDate)
	..;d objUseRecord.%Set("URReportTime",ReportTime)
	..;d objUseRecord.%Set("URSubKey",SubKey)
	..
	..;s Val=SourceType_"^"_SourceID_"^"_UseDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_Price_"^"_TotalFee_"^"_Year_"^"_Month_"^"_ServiceItemDR_"^"_ExType_"^"_ExID_"^"_IsInputFlag_"^"_IUStatus_"^"_InvalidFlag_"^"_Remark_"^^^^^^^"_ModelDR
	..///modified by ZY0277 20210819 变量错误
	..;记录结果
	..s Count=Count+1
	..i ErrCode'="" s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,ErrCode,Count)=ErrCode_"^"_ServiceItemDR_"^"_SourceID
	..q:ErrCode'=""
	..
	..s Result=##Class(web.DHCEQ.BA.BUSUseRecord).SaveUseRecord(objUseRecord)
	..
	..;记录采集结果
	..s Node="Error"
	..i Result>0 s Node="Success"
	..s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=Result_"^"_ServiceItemDR_"^"_SourceID
 	/// modified by ZY0299
	s EndTime=$H
	
	i GRowID'="" d
	.s GatherListInfo=##class(web.DHCEQ.Plat.JsonObject).%New() 
	.d GatherListInfo.%Set("GLGatherDR",GRowID)
	.d GatherListInfo.%Set("GLExType",ExType)
	.d GatherListInfo.%Set("GLUseDate",##class(web.DHCEQCommon).TransValueToPage(GatherDate,"date"))
	.d GatherListInfo.%Set("GLBeginTime",##class(web.DHCEQCommon).TransValueToPage($p(BeginTime,",",2),"time"))
	.d GatherListInfo.%Set("GLEndTime",##class(web.DHCEQCommon).TransValueToPage($p(EndTime,",",2),"time"))
	.d GatherListInfo.%Set("GLStatus",0)
	.d GatherListInfo.%Set("GLVersion",Version)
 	.s GatherListInfo=GatherListInfo.%ToJSON()
	.s GatherInfo=##class(web.DHCEQ.BA.BUSGather).SaveDataList(GatherListInfo)
 	
	k ^TempDHCEQ("GetEquipByService",vJob)
	/// modified by ZY0299
 	;记录采集结束时间
	//s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"EndTime")=$H
	q 0
}

/// modified by ZY0299
/// 修改费用取值：通过医嘱ID获取医嘱记录的费用
/// add by zy 20181028 B/S  LIS系统接口  ZY0173
/// 采集DHC-Lis的相关使用记录,获取某一天的检验设备使用信息，存放在websource下的
/// ^TempDHCEQ("GatherUseRecord",ExType,$j,Item,Device,Row)
/// 其中ExType为"DHC-LIS","DHC-RIS"等，Item为医嘱项，Device为设备
/// 存储数据为StartDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_TotalFee_"^"_Price_"^"_ExID
/// 		  开始日期，开始时间，结束日期，结束时间，工作量，工作量单位，使用科室，患者信息，总费用，单价，医嘱id(检验为报告id)	
/// w ##Class(web.DHCEQIUsedRecord).GatherDHCLISNew(64506)
ClassMethod GatherDHCLISNew(GatherDate, EquipID As %String = "", GRowID As %String = "")
{
	n (GatherDate,EquipID,GRowID)
	
	s ExType="DHC-LIS"
	s SourceType=1	;类型为设备
	
	s tmpDate=$ZD(GatherDate,3)
	s SDate=$ZD(GatherDate,8)
	s EDate=$ZD(GatherDate,8)
	s Year=$p(tmpDate,"-",1)
	s Month=$p(tmpDate,"-",2)		
	s IsInputFlag="N"	;系统采集,非手工录入
	//Modefied by zc 2018-12-21 zc0047  将Status修改为LNStatus，避免任务挂起
	//s LNStatus=2		;系统自动采集的自动置为审核状态
	//s InvalidFlag="N"
	//s Remark=""
	s HospID=""	/// modified by zy 20211108
	/// modified by ZY0299
	s BeginTime=$H
	;记录采集结果开始时间
	s Count=0
	i GRowID=""
	{
		s Version=$o(^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,""),-1)
	}else
	{
		s Version=$o(^DHCEQGatherList(0,"Version",GRowID,ExType,GatherDate,""),-1)
	}
	s Version=1+Version
	s ErrCode=""
	/// modified by ZY0299
	//s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"BeginTime")=$H
	
	s Job=$j
	
	s SourceID=0
	f  s SourceID=$o(^DHCEQDeviceMap(0,"Equip",SourceID)) quit:SourceID=""  d
	.q:(EquipID'="")&(EquipID'=SourceID)
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
	...s ServiceItemDR=##Class(web.DHCEQ.BA.CTServiceItem).GetServiceByExID(ExType,Item)
	...i ServiceItemDR="" s ServiceItemDR=##Class(web.DHCEQ.BA.CTServiceItem).AutoSaveServiceItem(ExType,Item,GatherDate)
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
	...s PatientSex=$Case(ds.PatientSex,"":"","1":"M","2":"F")
	...s PatientName=ds.PatientName
	...s PatientAge=ds.PatientAge
	...s PatientInfo=PatientID_"&"_PatientName_"&"_PatientAge_"&"_PatientSex
	.../// modified by cjt 20221226 需求号2888051
	...s Price=ds.Price
	...//i Price="" s Price=##Class(web.DHCEQ.BA.CTServiceItem).GetServicePriceByExID(ExType,Item, GatherDate)
	...s ReceivableFee=ds.ReceivableFee
	...s TotalFee=ds.TotalFee
	...s ExID=ds.ExID
	...q:ExID=""
	.../// modified by ZY0282 20211108
	...s ExpStr="^"_ExID
	.../// modified by cjt 20221226 需求号2888051
	...//i Price="" s Price=##Class(web.DHCEQ.BA.CTServiceItem).GetServicePriceByExID(ExType,Item, GatherDate,HospID,ExpStr)
	...i TotalFee="" s TotalFee=Price
	...//根据医嘱ID取病人类型
	...s OEOrderID=$p(ExID,"||",1)
	...s AdmID=$p($g(^OEORD(OEOrderID)),"^",1)
	...s AdmType=$p($g(^PAADM(AdmID)),"^",2)
	...
	...s PositiveFlag=ds.PositiveFlag
	...s ReportType=ds.ReportType
	...s Operator=ds.Operator
	...;s WaitingTime=ds.WaitingTime
	...
	...s objUseRecord=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	...d objUseRecord.%Set("URSourceType",SourceType)
	...d objUseRecord.%Set("URSourceID",SourceID)
	...d objUseRecord.%Set("URUseDate",UseDate)
	...d objUseRecord.%Set("URStartTime",StartTime)
	...d objUseRecord.%Set("UREndDate",EndDate)
	...d objUseRecord.%Set("UREndTime",EndTime)
	...d objUseRecord.%Set("URWorkLoadNum",WorkLoadNum)
	...d objUseRecord.%Set("URWorkLoadUnitDR",WorkLoadUnitDR)
	...d objUseRecord.%Set("URUseLocDR",UseLocDR)
	...d objUseRecord.%Set("URPatientID",PatientID)
	...d objUseRecord.%Set("URPrice",Price)
	...d objUseRecord.%Set("URTotalFee",TotalFee)
	...d objUseRecord.%Set("URYear",Year)
	...d objUseRecord.%Set("URMonth",Month)
	...d objUseRecord.%Set("URServiceItemDR",ServiceItemDR)
	...d objUseRecord.%Set("URExType",ExType)
	...d objUseRecord.%Set("URExID",ExID)
	...d objUseRecord.%Set("URIsInputFlag",IsInputFlag)
	...d objUseRecord.%Set("URStatus",2)
	...d objUseRecord.%Set("URInvalidFlag","N")
	...d objUseRecord.%Set("URRemark","")
	...d objUseRecord.%Set("URModelDR",ModelDR)
	...
	...d objUseRecord.%Set("URDoctorOrderID",OEOrderID)
	...d objUseRecord.%Set("UROperator",Operator)
	...d objUseRecord.%Set("URPositiveFlag",PositiveFlag)
	...;d objUseRecord.%Set("URSampleNo",SampleNo)
	...;d objUseRecord.%Set("URExposureNum",ExposureNum)
	...d objUseRecord.%Set("URStartDate",UseDate)
	...d objUseRecord.%Set("URPatientSex",PatientSex)
	...d objUseRecord.%Set("URPatientAge",PatientAge)
	...d objUseRecord.%Set("URPatientName",PatientName)
	...d objUseRecord.%Set("URExecDeptDR",UseLocDR)
	...d objUseRecord.%Set("URAdmissionType",AdmType)
	...d objUseRecord.%Set("UROrdDate",UseDate)
	...d objUseRecord.%Set("UROrdTime",StartTime)
	...d objUseRecord.%Set("URPreOccurDate","")
	...d objUseRecord.%Set("URPreOccurTime","")
	...d objUseRecord.%Set("URPreDate","")
	...d objUseRecord.%Set("URPreTime","")
	...d objUseRecord.%Set("URRegDate",UseDate)
	...d objUseRecord.%Set("URRegTime",StartTime)
	...d objUseRecord.%Set("URReportDate",EndDate)     	//Modefied by zc0120 2022-7-26  修正报告日期取值
	...d objUseRecord.%Set("URReportTime",EndTime)		//Modefied by zc0120 2022-7-26 修正报告时间取值
	...d objUseRecord.%Set("URCheckPart","")
	...d objUseRecord.%Set("URDoctorID","")
	...d objUseRecord.%Set("URRequestDeptDR","")
	...d objUseRecord.%Set("URReportDoctorDR","")
	...d objUseRecord.%Set("URTWorkLoadNum","")
	...d objUseRecord.%Set("URHold1","")
	...d objUseRecord.%Set("URHold2","")
	...d objUseRecord.%Set("URHold3","")
	...d objUseRecord.%Set("URHold4","")
	...d objUseRecord.%Set("URHold5","")
	...
	...;//Modefied by zc 2018-12-21 zc0047  将Status修改为LNStatus，避免任务挂起
	...;s Val=SourceType_"^"_SourceID_"^"_UseDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_Price_"^"_TotalFee_"^"_Year_"^"_Month_"^"_ServiceItemDR_"^"_ExType_"^"_ExID_"^"_IsInputFlag_"^"_LNStatus_"^"_InvalidFlag_"^"_Remark_"^^^^^^^"_ModelDR
	...
	...;记录结果
	...s Count=Count+1
	...i ErrCode'="" s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,ErrCode,Count)=ErrCode_"^"_Item_"^"_DeviceID
	...q:ErrCode'=""
	...
	...s Result=##Class(web.DHCEQ.BA.BUSUseRecord).SaveUseRecord(objUseRecord)
	...
	...;记录采集结果
	...s Node="Error"
	...i Result>0 s Node="Success"
	...s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=Result_"^"_Item_"^"_DeviceID
	...
	...
	/// modified by ZY0299
	s EndTime=$H
	
	i GRowID'="" d
	.s GatherListInfo=##class(web.DHCEQ.Plat.JsonObject).%New() 
	.d GatherListInfo.%Set("GLGatherDR",GRowID)
	.d GatherListInfo.%Set("GLExType",ExType)
	.d GatherListInfo.%Set("GLUseDate",##class(web.DHCEQCommon).TransValueToPage(GatherDate,"date"))
	.d GatherListInfo.%Set("GLBeginTime",##class(web.DHCEQCommon).TransValueToPage($p(BeginTime,",",2),"time"))
	.d GatherListInfo.%Set("GLEndTime",##class(web.DHCEQCommon).TransValueToPage($p(EndTime,",",2),"time"))
	.d GatherListInfo.%Set("GLStatus",0)
	.d GatherListInfo.%Set("GLVersion",Version)
 	.s GatherListInfo=GatherListInfo.%ToJSON()
	.s GatherInfo=##class(web.DHCEQ.BA.BUSGather).SaveDataList(GatherListInfo)
	;记录采集结束时间
	//s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"EndTime")=$H
	
	k ^TempDHCEQ("GatherUseRecord",ExType,Job)
	q 0
}

/// modified by ZY0299
/// 修改费用取值：通过医嘱ID获取医嘱记录的费用
/// DHCRIS获取使用记录信息   2014-11
/// 根据登记日期获取
/// w ##Class(web.DHCEQ.BA.BUSGather).GatherDHCRISNew(64510)
/// RIS新版系统STUDYINFO,MODALITY
ClassMethod GatherDHCRISNew(GatherDate, EquipID As %String = "", GRowID As %String = "") As %String
{
	s ExType="DHC-RIS"
	s SourceType=1	;类型为设备
	s tmpDate=$ZD(GatherDate,3)
	s Year=$p(tmpDate,"-",1)
	s Month=$p(tmpDate,"-",2)
	s IsInputFlag="N"	;系统采集,非手工录入
	//Modefied by zc 2018-12-21 zc0047  将Status修改为RINStatus，避免任务挂起
	//s RINStatus=2		;系统自动采集的自动置为审核状态
	//s InvalidFlag="N"
	//s Remark=""
	s HospID=""	/// modified by zy 20211108
	/// modified by ZY0299
	s BeginTime=$H
	;记录采集结果开始时间
	s Count=0
	i GRowID=""
	{
		s Version=$o(^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,""),-1)
	}else
	{
		s Version=$o(^DHCEQGatherList(0,"Version",GRowID,ExType,GatherDate,""),-1)
	}
	s Version=1+Version
	s ErrCode=""
	//s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"BeginTime")=$H
	
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
	..d ##Class(web.DHCEQ.Interface.Inner.DHCEQPACSFrom).GatherDHCRISByDeviceID(ExType,GatherDate,DeviceID,DateType)
	..
	..s ModelDR=$p($g(^DHCEQEquip(SourceID)),"^",3)
	..s StudyNo=""
	..f  s StudyNo=$o(^TempDHCEQ("Gather","Result","DHC-RIS",tmpDate,DeviceID,StudyNo)) quit:StudyNo=""  d
	...//q:(DeviceID=83)&&(StudyNo'["MR")
	...s TempData=$G(^TempDHCEQ("Gather","Result","DHC-RIS",tmpDate,DeviceID,StudyNo))
	...//modified by cjt 20221226 需求号2888051
	...//修改UseDate、StartTime、EndDate、EndTime处理逻辑
	...s UseDate=$p(TempData,"^",7)
	...i UseDate="1901-01-01 00:00:00" s UseDate=""
	...s StartTime=$p(UseDate," ",2)
	...s EndDate=$p(TempData,"^",8)
	...i EndDate="1901-01-01 00:00:00" s EndDate=""
	...s EndTime=$p(EndDate," ",2)
	...i UseDate="" s UseDate=EndDate
	...i UseDate="" s UseDate=tmpDate
	...i EndDate="" s EndDate=UseDate
	...i EndDate="" s EndDate=tmpDate
	...//i DateType="Report" d
	....//s UseDate=$p(TempData,"^",8)
	...//e  d
	....//s UseDate=$p(TempData,"^",7)
	...//i ((UseDate="")||(UseDate="1901-01-01 00:00:00")) d
	....//s UseDate=$ZD($ZDH(tmpDate,3),4)
	...//e  d
	....//s UseDate=$ZD($ZDH($e(UseDate,1,10),3),4)
	...//s StartTime=""
	...//s EndDate=UseDate
	...//s EndTime=""
	...s WorkLoadNum=1
	...s WorkLoadUnitDR=""
	...s UseLocDR=$p(TempData,"^",6)
	...s PatientID=$p(TempData,"^",9)
	...s PatientInfo=$p(TempData,"^",10)
	...i PatientID'="" s PatientInfo=##Class(web.DHCEQIUsedRecord).GetPatientInfo("DHC-HIS",PatientID)
	...s PatientName=$p(PatientInfo,"&",2)
	...//modified by cjt 20230129 需求号2888051 逻辑错误 "4"改为"3",第三个位置是患者性别
	...s PatientSex=$p(PatientInfo,"&",3)
	...//modified by cjt 20221226 需求号2888051
	...//PatientSex一共有四种情况(男、女、未知性别、未说明性别)
	...//PatientSex在数据库中是varchar(1),无法插入中文
	...i PatientSex="男" s PatientSex="M"
	...i PatientSex="女" s PatientSex="F"
	...//modified by cjt 20230129 需求号2888051 逻辑错误 "男"改为"M","女"改为"F"
	...i (PatientSex'="M")&&(PatientSex'="F") s PatientSex=""
	...//modified by cjt 20221226 需求号2888051
	...//modified by cjt 20230129 需求号2888051 逻辑错误 "3"改为"4",第四个位置是出生日期
	...//$p(PatientInfo,"&",4)指的是患者出生日期,不是患者年龄
	...s PatientDOB=$p(PatientInfo,"&",4)
	...s PatientAge=(+$h-PatientDOB)\365_"岁"
	...s Price=$p(TempData,"^",3)
	...s Item=$p(TempData,"^",2)
	...i Item="" d
	....//modified by cjt 20221205 需求号2888051 语法错误,"PACS"改为"DHC-PACS"
	....zn "DHC-PACS"
	....s ID=$o(^User.STUDYITEMVALUEI("STACCNUMIndex"," "_StudyNo,0))
	....s Item=$LIST($g(^User.STUDYITEMVALUED(ID)),1)
	....zn "DHC-APP"
	...quit:Item=""
	.../// modified by ZY0282 20211108
	...s oeorowid=$p(TempData,"^",5)
	...//modified by cjt 20221226 需求号2888051 程序报错,"$p"改为"+$p"
	...s OEOrderID=+$p(oeorowid,"||",1)
	...s ExpStr="^"_OEOrderID
	...//modified by cjt 20221205 修改Price代码逻辑
	...i Price="" d
	....s Price=##Class(web.DHCEQ.BA.CTServiceItem).GetServicePriceByExID(ExType,Item, GatherDate,HospID,ExpStr)
	....s Price=##Class(web.DHCEQCommon).FormatNumber(Price,"",2)
	...s TotalFee=Price
	...s OperatorID=$p(TempData,"^",11)
	...s YinYang=$p(TempData,"^",13)
	...s ExID=StudyNo
	...//根据医嘱ID取病人类型
	...s AdmID=$p($g(^OEORD(OEOrderID)),"^",1)
	...s AdmType="I"
	...i AdmID'="" s AdmType=$p($g(^PAADM(AdmID)),"^",2)
	...
	...;modify by lmm 2018-05-29 begin
	...s ExIDInfo=""
	...if (oeorowid'="")  d
	....s ExIDInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQPACSFrom).GetZeroFeeExID(ExType, GatherDate,oeorowid)
	...if ($p(ExIDInfo,"^",1)=0)  d
	....s Item=$p(ExIDInfo,"^",2)
	...;modify by lmm 2018-05-29 end
	...s ServiceItemDR=##Class(web.DHCEQ.BA.CTServiceItem).GetServiceByExID(ExType,Item)
	...;如果未定义服务项,则需自动生成服务项目
	...i ServiceItemDR="" s ServiceItemDR=##Class(web.DHCEQ.BA.CTServiceItem).AutoSaveServiceItem(ExType,Item,GatherDate)
	...i ServiceItemDR="" s ErrCode="NoServiceItem"
	...
	...i ServiceItemDR'="" s WorkLoadUnitDR=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",3)
	...
	...s objUseRecord=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	...d objUseRecord.%Set("URSourceType",SourceType)
	...d objUseRecord.%Set("URSourceID",SourceID)
	...d objUseRecord.%Set("URUseDate",UseDate)
	...d objUseRecord.%Set("URStartTime",StartTime)
	...d objUseRecord.%Set("UREndDate",EndDate)
	...d objUseRecord.%Set("UREndTime",EndTime)
	...d objUseRecord.%Set("URWorkLoadNum",WorkLoadNum)
	...d objUseRecord.%Set("URWorkLoadUnitDR",WorkLoadUnitDR)
	...d objUseRecord.%Set("URUseLocDR",UseLocDR)
	...d objUseRecord.%Set("URPatientID",PatientID)
	...d objUseRecord.%Set("URPrice",Price)
	...d objUseRecord.%Set("URTotalFee",TotalFee)
	...d objUseRecord.%Set("URYear",Year)
	...d objUseRecord.%Set("URMonth",Month)
	...d objUseRecord.%Set("URServiceItemDR",ServiceItemDR)
	...d objUseRecord.%Set("URExType",ExType)
	...d objUseRecord.%Set("URExID",ExID)
	...d objUseRecord.%Set("URIsInputFlag","N")
	...d objUseRecord.%Set("URStatus",2)
	...d objUseRecord.%Set("URInvalidFlag","N")
	...d objUseRecord.%Set("URRemark","")
	...d objUseRecord.%Set("URModelDR",ModelDR)
	...
	...d objUseRecord.%Set("URDoctorOrderID",oeorowid)
	...d objUseRecord.%Set("UROperator",OperatorID)
	...d objUseRecord.%Set("URPositiveFlag",YinYang)
	...d objUseRecord.%Set("URSampleNo",StudyNo)
	...;d objUseRecord.%Set("URExposureNum",ExposureNum)
	...d objUseRecord.%Set("URStartDate",UseDate)
	...d objUseRecord.%Set("URPatientSex",PatientSex)
	...d objUseRecord.%Set("URPatientAge",PatientAge)
	...d objUseRecord.%Set("URPatientName",PatientName)
	...d objUseRecord.%Set("URExecDeptDR",UseLocDR)
	...d objUseRecord.%Set("URAdmissionType",AdmType)
	...d objUseRecord.%Set("UROrdDate",UseDate)
	...d objUseRecord.%Set("UROrdTime",StartTime)
	...d objUseRecord.%Set("URPreOccurDate","")
	...d objUseRecord.%Set("URPreOccurTime","")
	...d objUseRecord.%Set("URPreDate","")
	...d objUseRecord.%Set("URPreTime","")
	...d objUseRecord.%Set("URRegDate","")
	...d objUseRecord.%Set("URRegTime","")
	...d objUseRecord.%Set("URReportDate","")
	...d objUseRecord.%Set("URReportTime","")
	...d objUseRecord.%Set("URCheckPart",ExIDInfo)
	...d objUseRecord.%Set("URDoctorID","")
	...d objUseRecord.%Set("URRequestDeptDR","")
	...d objUseRecord.%Set("URReportDoctorDR","")
	...d objUseRecord.%Set("URTWorkLoadNum","")
	...d objUseRecord.%Set("URHold1","")
	...d objUseRecord.%Set("URHold2","")
	...d objUseRecord.%Set("URHold3","")
	...d objUseRecord.%Set("URHold4","")
	...d objUseRecord.%Set("URHold5","")
	...
	...
	...;//Modefied by zc 2018-12-21 zc0047  将Status修改为RINStatus，避免任务挂起
	...;s Val=SourceType_"^"_SourceID_"^"_UseDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_Price_"^"_TotalFee_"^"_Year_"^"_Month_"^"_ServiceItemDR_"^"_ExType_"^"_ExID_"^"_IsInputFlag_"^"_RINStatus_"^"_InvalidFlag_"^"_Remark_"^^^^^^^"_ModelDR_"^"_OperatorID_"^"_YinYang_"^^^"
	...
	...;记录没有存下的数据信息
	...s Count=Count+1
	...i ErrCode'="" s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,ErrCode,Count)=ErrCode_"^"_Item_"^"_DeviceID
	...q:ErrCode'=""
	...
	...s Result=##Class(web.DHCEQ.BA.BUSUseRecord).SaveUseRecord(objUseRecord)
	...;记录采集结果
	...s Node="Error"
	...i Result>0 s Node="Success"
	...s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=Result_"^"_Item_"^"_DeviceID
	
	//s ^TempDHCEQ("Gather","Result","DHC-RIS",date,"Cancel",StudyNo)=""
	;DHCRB_ReturnFee
	;获取该日取消检查ID
	s StudyNo=""
	f  s StudyNo=$o(^TempDHCEQ("Gather","Result","DHC-RIS",tmpDate,"Cancel",StudyNo))  quit:(StudyNo="")  d
	.s ExID=StudyNo
	.s ErrCode=##Class(web.DHCEQ.BA.BUSGather).CancelUseRecordByExID(ExType,ExID,GatherDate)
	.s Count=Count+1
	.
	.s Node="CancelError"
	.i ErrCode=0 s Node="CancelSuccess"
	.s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=ErrCode_"^"_ExID
	/// modified by ZY0299
	s EndTime=$H
	
	i GRowID'="" d
	.s GatherListInfo=##class(web.DHCEQ.Plat.JsonObject).%New() 
	.d GatherListInfo.%Set("GLGatherDR",GRowID)
	.d GatherListInfo.%Set("GLExType",ExType)
	.d GatherListInfo.%Set("GLUseDate",##class(web.DHCEQCommon).TransValueToPage(GatherDate,"date"))
	.d GatherListInfo.%Set("GLBeginTime",##class(web.DHCEQCommon).TransValueToPage($p(BeginTime,",",2),"time"))
	.d GatherListInfo.%Set("GLEndTime",##class(web.DHCEQCommon).TransValueToPage($p(EndTime,",",2),"time"))
	.d GatherListInfo.%Set("GLStatus",0)
	.d GatherListInfo.%Set("GLVersion",Version)
 	.s GatherListInfo=GatherListInfo.%ToJSON()
	.s GatherInfo=##class(web.DHCEQ.BA.BUSGather).SaveDataList(GatherListInfo)
	
	;记录采集结束时间
	//s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"EndTime")=$H
	q 0
}

/// modified by ZY0299
/// 把中间队列表DHC_EQIUseRecordQueue表的数据写到使用记录中
/// w ##Class(web.DHCEQ.BA.BUSGather).GatherThirdParty(65380,"RIS","",1)
ClassMethod GatherThirdParty(GatherDate, vType, EquipID As %String = "", GRowID As %String = "")
{
	n (GatherDate,vType,EquipID,GRowID)
	
	;s ExType="Pacs"
	s ExType=vType
	s SourceType=1	;类型为设备
	
	s tmpDate=$ZD(GatherDate,3)
	s Year=$p(tmpDate,"-",1)
	s Month=$p(tmpDate,"-",2)		
	s IsInputFlag="N"	;系统采集,非手工录入
	s IUStatus=2		;系统自动采集的自动置为审核状态
	s InvalidFlag="N"
	s Remark=""
	/// modified by ZY0299
	s BeginTime=$H
	;记录采集结果开始时间
	s Count=0
	i GRowID=""
	{
		s Version=$o(^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,""),-1)
	}else
	{
		s Version=$o(^DHCEQGatherList(0,"Version",GRowID,ExType,GatherDate,""),-1)
	}
	s Version=1+Version
	s ErrCode=""
	/// modified by ZY0299
	//s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"BeginTime")=$H
	
	s Job=$j
	
	;取做的项目
	s Item=0
	f  s Item=$o(^DHCEQIUseRecordQueue(0,"ExTypeItem",ExType,GatherDate,Item))  quit:(Item="")  d 
	.
	.s (ServiceItemDR,WorkLoadUnitDR)=""
	.s Price=0
	.s ServiceItemDR=##Class(web.DHCEQ.BA.CTServiceItem).GetServiceByExID(ExType,Item)
	.;如果未定义服务项,则需自动生成服务项目
	.i (ServiceItemDR="")  d
	..s ServiceItemDR=##Class(web.DHCEQ.BA.CTServiceItem).AutoSaveServiceItem(ExType,Item,GatherDate)
	..i ServiceItemDR=""  s ErrCode="NoServiceItem"
	..s ErrCode="NoServiceItem"
	.q:ErrCode'=""
	.i ServiceItemDR'=""  d
	..s WorkLoadUnitDR=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",3)
	..s Price=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",4)
	.s RowID=0
	.f  s RowID=$o(^DHCEQIUseRecordQueue(0,"ExTypeItem",ExType,GatherDate,Item,RowID))  quit:(RowID="")  d 
	..s (CancelFlag,Status,ExID,Device,SourceID,ModelDR,StartDate,StartTime,EndDate,EndTime)=""
	..s (WorkLoadNum,UseLocDR,UseDate,PatientInfo,TotalFee,ErrCode)=""
	..s CancelFlag=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",17)
	..q:CancelFlag="Y"
	..s Status=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",32)
	..;q:Status'="0"		//只更新新增的数据
	..s ExID=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",4)
	..if ExID'="" s ExID=##class(web.DHCEQCommon).Replace(ExID,"_","||")  //add by wy 2021-11-08 转换医嘱ID
	..q:ExID=""
	..s Device=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",2)
	..s SourceID=##Class(web.DHCEQ.BA.BUSDeviceMap).GetEquipByDevice(ExType,Device)
	..q:(EquipID'="")&&(EquipID'=SourceID)
	..i SourceID="" s ErrCode="DeviceNoMap"
	..q:ErrCode'=""
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
	..s OEOrderID=$p($g(^DHCEQCCode("DHCEQCServiceItem",ServiceItemDR)),"^",6)  //$p(oeorowid,"||",1)
	..s ExpStr="^"_ExID
	..;s Price=##Class(web.DHCEQ.BA.CTServiceItem).GetServicePriceByExID("DHC-HIS",OEOrderID, GatherDate,"",ExpStr)
	..;s Price=##Class(web.DHCEQCommon).FormatNumber(Price,"",2)
	..;s TotalFee=Price
	..s Price=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",8)		//费用无效
	..s Price=##Class(web.DHCEQCommon).FormatNumber(Price,"",2)
	..s TotalFee=Price
	..;s TotalFee=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",9)
	..s Operator=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",15)		//操作员
	..s OtherInfo=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",16)					//Add By DJ 2015-09-29 DJ0169 begin
	..s DoctorOrderID=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",19)		//医嘱ID
	..s PositiveFlag=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",20)		//阳性标志  0阴性1阳性2未知 modified by wy 2021-10-15
	..i PositiveFlag=1 d
	...s PositiveFlag="Y"
	..e  d
	...s PositiveFlag="N"
	..s SampleNo=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",21)		//医技流水号
	..s ExposureNum=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",22)		//曝光次数
	..s PatientSex=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",23)		//患者性别
	..s PatientAge=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",24)		//患者年龄
	..s PatientName=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",33)		//患者姓名
	..s OriRecDept=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",34)
	..s URQHold2=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",35)
	..s URQHold3=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",36)
	..s URQHold4=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",37)
	..s AdmType=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",38)
	..s OrdDate=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",39)
	..s OrdTime=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",40)
	..s PreOccurDate=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",41)
	..s PreOccurTime=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",42)
	..s PreDate=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",43)
	..s PreTime=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",44)
	..s RegDate=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",45)
	..s RegTime=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",46)	
	..s ReportDate=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",47)
	..s ReportTime=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",48)
	..s CheckPart=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",49)
	..s DoctorID=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",50)
	..s RequestDeptDR=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",51)
	..s ReportDoctorDR=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",52)
	..s TWorkLoadNum=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",53)
	..s Hold1=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",54)
	..s Hold2=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",55)
	..s Hold3=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",56)
	..s Hold4=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",57)
	..s Hold5=$p($g(^DHCEQIUseRecordQueue(RowID)),"^",58)
	..
	..s objUseRecord=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	..d objUseRecord.%Set("URSourceType",SourceType)
	..d objUseRecord.%Set("URSourceID",SourceID)
	..d objUseRecord.%Set("URUseDate",UseDate)
	..d objUseRecord.%Set("URStartTime",StartTime)
	..d objUseRecord.%Set("UREndDate",EndDate)
	..d objUseRecord.%Set("UREndTime",EndTime)
	..d objUseRecord.%Set("URWorkLoadNum",WorkLoadNum)
	..d objUseRecord.%Set("URWorkLoadUnitDR",WorkLoadUnitDR)
	..d objUseRecord.%Set("URUseLocDR",UseLocDR)
	..d objUseRecord.%Set("URPatientID",PatientID)
	..d objUseRecord.%Set("URPrice",Price)
	..d objUseRecord.%Set("URTotalFee",TotalFee)
	..d objUseRecord.%Set("URYear",Year)
	..d objUseRecord.%Set("URMonth",Month)
	..d objUseRecord.%Set("URServiceItemDR",ServiceItemDR)
	..d objUseRecord.%Set("URExType",ExType)
	..d objUseRecord.%Set("URExID",ExID)
	..d objUseRecord.%Set("URIsInputFlag",IsInputFlag)
	..d objUseRecord.%Set("URStatus",IUStatus)
	..d objUseRecord.%Set("URInvalidFlag",InvalidFlag)
	..d objUseRecord.%Set("URRemark",Remark)
	..d objUseRecord.%Set("URModelDR",ModelDR)
	..
	..d objUseRecord.%Set("URDoctorOrderID",DoctorOrderID)
	..d objUseRecord.%Set("UROperator",Operator)
	..d objUseRecord.%Set("URPositiveFlag",PositiveFlag)
	..d objUseRecord.%Set("URSampleNo",SampleNo)
	..d objUseRecord.%Set("URExposureNum",ExposureNum)
	..d objUseRecord.%Set("URStartDate",UseDate)
	..s PatientSex=$CASE(PatientSex,"1":"F","0":"M",:"")  

	..d objUseRecord.%Set("URPatientSex",PatientSex)
	..d objUseRecord.%Set("URPatientAge",PatientAge)
	..d objUseRecord.%Set("URPatientName",PatientName)
	..d objUseRecord.%Set("URExecDeptDR",OriRecDept)
	..d objUseRecord.%Set("URAdmissionType",AdmType)
	..d objUseRecord.%Set("UROrdDate",UseDate)
	..d objUseRecord.%Set("UROrdTime",StartTime)
	..d objUseRecord.%Set("URPreOccurDate",PreOccurDate)
	..d objUseRecord.%Set("URPreOccurTime",PreOccurTime)
	..d objUseRecord.%Set("URPreDate",PreDate)
	..d objUseRecord.%Set("URPreTime",PreTime)
	..d objUseRecord.%Set("URRegDate",RegDate)
	..d objUseRecord.%Set("URRegTime",RegTime)
	..d objUseRecord.%Set("URReportDate",ReportDate)
	..d objUseRecord.%Set("URReportTime",ReportTime)
	..d objUseRecord.%Set("URCheckPart",CheckPart)
	..d objUseRecord.%Set("URDoctorID",DoctorID)
	..d objUseRecord.%Set("URRequestDeptDR",RequestDeptDR)
	..d objUseRecord.%Set("URReportDoctorDR",ReportDoctorDR)
	..d objUseRecord.%Set("URTWorkLoadNum",TWorkLoadNum)
	..d objUseRecord.%Set("URHold1",Hold1)
	..d objUseRecord.%Set("URHold2",Hold2)
	..d objUseRecord.%Set("URHold3",Hold3)
	..d objUseRecord.%Set("URHold4",Hold4)
	..d objUseRecord.%Set("URHold5",Hold5)
	..
	..;s Val=SourceType_"^"_SourceID_"^"_UseDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientID_"^"_Price_"^"_TotalFee_"^"_Year_"^"_Month_"^"_ServiceItemDR_"^"_ExType_"^"_ExID_"^"_IsInputFlag_"^"_Status_"^"_InvalidFlag_"^"_Remark_"^^^^^^^"_ModelDR_"^^^^^^^^^^"_DoctorOrderID_"^"_Operator_"^"_PositiveFlag_"^"_SampleNo_"^"_ExposureNum_"^"_PatientSex_"^"_PatientAge_"^"_PatientName_"^"_OtherInfo_"^"_URQHold1_"^"_URQHold2_"^"_URQHold3_"^"_URQHold4_"^"_URQHold5
	..;记录结果
	..s Count=Count+1
	..i ErrCode'="" s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,ErrCode,Count)=ErrCode_"^"_Item_"^"_SourceID
	..q:ErrCode'=""
	..
	..s Result=##Class(web.DHCEQ.BA.BUSUseRecord).SaveUseRecord(objUseRecord)
	..;记录采集结果
	..s Node="Error"
	..i Result>0  d
	...s Node="Success"
	...s Result=##Class(web.DHCEQ.BA.BUSUseRecordQueue).SaveData(RowID,"2","1")
	..e  d
	...s Result=##Class(web.DHCEQ.BA.BUSUseRecordQueue).SaveData(RowID,"1","1")
	..i Result'=0 s Node="UpdateIUseRecordQueueFail"
	..
	..s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,Node,Count)=Result_"^"_Item_"^"_RowID
	/// modified by ZY0299
	s EndTime=$H
	
	i GRowID'="" d
	.s GatherListInfo=##class(web.DHCEQ.Plat.JsonObject).%New() 
	.d GatherListInfo.%Set("GLGatherDR",GRowID)
	.d GatherListInfo.%Set("GLExType",ExType)
	.d GatherListInfo.%Set("GLUseDate",##class(web.DHCEQCommon).TransValueToPage(GatherDate,"date"))
	.d GatherListInfo.%Set("GLBeginTime",##class(web.DHCEQCommon).TransValueToPage($p(BeginTime,",",2),"time"))
	.d GatherListInfo.%Set("GLEndTime",##class(web.DHCEQCommon).TransValueToPage($p(EndTime,",",2),"time"))
	.d GatherListInfo.%Set("GLStatus",0)
	.d GatherListInfo.%Set("GLVersion",Version)
 	.s GatherListInfo=GatherListInfo.%ToJSON()
	.s GatherInfo=##class(web.DHCEQ.BA.BUSGather).SaveDataList(GatherListInfo)
	
	;记录采集结束时间
	//s ^DHCEQIUsedRecord("Gather","Result",ExType,GatherDate,Version,"EndTime")=$H
	q 0
}

/// modified by ZY0299
/// w ##Class(web.DHCEQ.BA.BUSGather).SaveData(data)
ClassMethod SaveData(data, DelIs)
{
	new GRowID,User,Time,JsonData,SQLCODE
	s SQLCODE=0
	k PLIST,GRowID
	if DelIs=1
	{
		s GRowID=data
		&SQL(Update SQLUSER.DHC_EQGather set G_InvalidFlag='Y' where G_RowID = :GRowID)
		s RowID=""
	}
	else
	{
		s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
		s Date=$H
	 	s Time=$Piece($H,",",2)
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQGather",JsonData,.PLIST)
		s GRowID = JsonData.GRowID
		//s APMonth = JsonData.APMonth
		//s tmp=""
		//&SQL(select AP_RowID into :tmp from SQLUSER.User.DHCEQGather where AP_Year=:APYear and AP_Month=:APMonth and AP_InvalidFlag<>'Y')
		//if tmp'="" q "-9200^tmp"
		//s EquipTypeIDs = ##Class(web.DHCEQCommon).GetEquipTypesByGroup()
		//s PLIST(10)=##class(web.DHCEQCommon).Replace(EquipTypeIDs,"^",",")
	 	s PLIST(6) = User	;UserDR
	 	s PLIST(7) = +Date	;Date
		s PLIST(8) = Time	;Time
		s PLIST(9) = "N"
		i GRowID=""
		{
			&SQL(insert into SQLUSER.DHC_EQGather Values :PLIST())
			s GRowID=$g(%ROWID)
		}
		else
		{
			&SQL(update SQLUSER.DHC_EQGather Values :PLIST() where G_RowID = :GRowID)
		}
		
		i SQLCODE
		{
			q SQLCODE
		}
	}
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,GRowID)
}

/// modified by ZY0299
/// w ##Class(web.DHCEQ.BA.BUSGather).SaveData(data)
ClassMethod SaveDataList(data)
{
	new GLRowID,JsonData,SQLCODE
	s SQLCODE=0
	k PLIST,GLRowID
	//s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	//s Date=$H
 	//s Time=$Piece($H,",",2)
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQGatherList",JsonData,.PLIST)
	s GLRowID = JsonData.GLRowID
	i GLRowID=""
	{
		&SQL(insert into SQLUSER.DHC_EQGatherList Values :PLIST())
		s GLRowID=$g(%ROWID)
	}
	else
	{
		&SQL(update SQLUSER.DHC_EQGatherList Values :PLIST() where GL_RowID = :GLRowID)
	}
	
	q SQLCODE
}

/// modified by ZY0299
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSGather","Gather",0)
Query Gather(Type) As %Query(ROWSPEC = "GRowID:%String,GStartDate:%String,GEndDate:%String,GStatus:%String,GStatusDesc:%String,GType:%String,GTypeDesc:%String,GAddUser:%String,GAddDate:%String,GAddTime:%String,GHold1:%String,GHold2:%String,GHold3:%String,GHold4:%String,GHold5:%String")
{
}

ClassMethod GatherExecute(ByRef qHandle As %Binary, Type) As %Status
{
 	New repid, index,rowid,CurRole
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=""
	f  s rowid=$o(^DHCEQGather(rowid),-1)  q:rowid=0  Do
	.Do BuildDataGather
	Quit $$$OK
BuildDataGather
    Do ResetVariablesGather
	s Datalist=$Get(^DHCEQGather(rowid))
	q:$p(Datalist,"^",8)="Y"
	q:$p(Datalist,"^",4)'=Type
	Set GRowID=rowid
	Set GStartDate=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",1),"date")
	Set GEndDate=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",2),"date")
	Set GStatus=$p(Datalist,"^",3)
	Set GStatusDesc=$Case($p(Datalist,"^",3),0:"新增",1:"执行",2:"异常",3:"完成","":"")
	Set GType=$p(Datalist,"^",4)
	Set GTypeDesc=$Case($p(Datalist,"^",4),0:"补采记录",1:"正常任务记录","":"")
	Set GAddUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", $p(Datalist,"^",5))
	Set GAddDate=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",6),"date")
	Set GAddTime=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",7),"time")
	Set GHold1=$p(Datalist,"^",9)
	Set GHold2=$p(Datalist,"^",10)
	Set GHold3=$p(Datalist,"^",11)
	Set GHold4=$p(Datalist,"^",12)
	Set GHold5=$p(Datalist,"^",13)
	d OutputRowGather
 	
	Quit
OutputRowGather
	Set Data=$ListBuild(GRowID,GStartDate,GEndDate,GStatus,GStatusDesc,GType,GTypeDesc,GAddUser,GAddDate,GAddTime,GHold1,GHold2,GHold3,GHold4,GHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGather
	Set (Datalist,GRowID,GStartDate,GEndDate,GStatus,GStatusDesc,GType,GTypeDesc,GAddUser,GAddDate,GAddTime,GHold1,GHold2,GHold3,GHold4,GHold5)=""
	Quit
}

ClassMethod GatherFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GatherExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$ListBuild(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GatherClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GatherExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modified by ZY0299
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSGather","GatherList",0)
Query GatherList(GatherDR) As %Query(ROWSPEC = "GLRowID:%String,GLUseDate:%String,GLExType:%String,GLBeginTime:%String,GLEndTime:%String,GLStatus:%String,GLVersion:%String,GLHold1:%String,GLHold2:%String,GLHold3:%String,GLHold4:%String,GLHold5:%String")
{
}

ClassMethod GatherListExecute(ByRef qHandle As %Binary, GatherDR) As %Status
{
 	New repid, index,rowid,CurRole
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	i GatherDR="" Quit $$$OK
	Set rowid=""
	f  s rowid=$o(^DHCEQGatherList(0,"Gather",GatherDR,rowid))  q:rowid=0  Do
	.Do BuildDataGatherList
	Quit $$$OK
BuildDataGatherList
    Do ResetVariablesGatherList
	s Datalist=$Get(^DHCEQGatherList(rowid))
	Set GLRowID=rowid
	Set GLUseDate=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",2),"date")
	Set GLExType=$p(Datalist,"^",3)
	Set GLBeginTime=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",4),"time")
	Set GLEndTime=##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",5),"time")
	Set GLStatus=$Case($p(Datalist,"^",6),0:"失败",1:"成功","":"")
	Set GLVersion=$p(Datalist,"^",7)
	Set GLHold1=$p(Datalist,"^",8)
	Set GLHold2=$p(Datalist,"^",9)
	Set GLHold3=$p(Datalist,"^",10)
	Set GLHold4=$p(Datalist,"^",11)
	Set GLHold5=$p(Datalist,"^",12)
	d OutputRowGatherList
 	
	Quit
OutputRowGatherList
	Set Data=$ListBuild(GLRowID,GLUseDate,GLExType,GLBeginTime,GLEndTime,GLStatus,GLVersion,GLHold1,GLHold2,GLHold3,GLHold4,GLHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGatherList
	Set (Datalist,GLRowID,GLUseDate,GLExType,GLBeginTime,GLEndTime,GLStatus,GLVersion,GLHold1,GLHold2,GLHold3,GLHold4,GLHold5)=""
	Quit
}

ClassMethod GatherListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GatherListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$ListBuild(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GatherListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GatherListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
