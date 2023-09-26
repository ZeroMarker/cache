/// modified by ZY0247 20201222 
/// LIS 系统采集数据方法放这里
/// add by zy 20181028 ZY0173
/// LIS系统B/S版本的仪器与仪器记录接口程序
/// 
Class web.DHCEQ.Interface.Inner.DHCEQLISFrom Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：      dongzhenshuai
/// CreatDate：    20170808
/// Description:： 
/// Table：        
/// Input：        Desc   //仪器名称
/// Output：       仪器名称，仪器ID
/// Return：       
/// Others：       
Query Device(Desc As %String) As %Query(ROWSPEC = "LName,LTRowID")
{
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Inner.DHCEQLISFrom","Device","","","","","","","","","","","","","","","","")
ClassMethod DeviceExecute(ByRef qHandle As %Binary, Desc As %String, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	
	s Desc=$g(Desc)
	S Rowid=""
	for  s Rowid=$o(^dbo.BTMIMachineParameterD(Rowid)) q:Rowid=""  d
	.s strData=$g(^dbo.BTMIMachineParameterD(Rowid))
	.s Lname=$lg(strData,5)
	.s Sname=$lg(strData,3)
	.i $lg(strData,24)'=1 q
	.i (Lname[Desc)!(Sname[Desc)!(Desc="")  d
	..s LName=Lname
	..s LTRowID=Rowid
	..d OutputRow
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(LName,LTRowID)
    Set ColFields="LName,LTRowID"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	quit
}

ClassMethod DeviceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeviceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DeviceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeviceExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      dongzhenshuai
/// CreatDate：    20170808
/// Description:： 
/// Table：        
/// Input：        DeviceID 仪器ID, Date日期
/// Output：        Item:医嘱项ID,RegDate:预约记录日期,RegTime:预约记录时间,StartDate:开始日期,标本上机时间
/// 				StartTime:开始时间,EndDate:结束日期, 检验结果时间,EndTime:结束时间,
/// 				WorkLoadNum:工作量, WorkLoadUnitDR:工作量单位,UseLocDR:执行科室,（可以为空）,
///                 PatientID:患者ID,PatientSex:性别(0:未知 1:男 2:女),PatientName:患者姓名,PatientAge:患者年龄,
/// 				Price:单价,ReceivableFee:应收总费用,TotalFee:实收总费用,ExID:医嘱ID,
/// 				PositiveFlag:阳性标记,ReportType:报告类型( Y住院,N门诊,P急诊,O体检,W外院,S手工,F药理,B新生儿,K科研,Q其他),Operator:操作操作人,WaitingTime预约等待时间,
/// Return：       
/// Others：       
Query GetLISUseRecord(DeviceID As %String, SDate As %Integer, EDate As %Integer) As %Query(ROWSPEC = "Item,RegDate,RegTime,StartDate,StartTime,EndDate,EndTime,WorkLoadNum,WorkLoadUnitDR,UseLocDR,PatientID,PatientSex,PatientName,PatientAge,Price,ReceivableFee,TotalFee,ExID,PositiveFlag,ReportType,Operator,WaitingTime")
{
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Inner.DHCEQLISFrom","GetLISUseRecord","51","20170811","20170811","","","","","","","","","","","","","","","")
ClassMethod GetLISUseRecordExecute(ByRef qHandle As %Binary, DeviceID As %String, SDate As %Integer, EDate As %Integer, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	
	s (EndTime,EndDate,StartTime,StartDate,RegTime,RegDate,Item,WorkLoadNum,UseLocDR,PatientID,PatientSex,PatientName,PatientAge,Price,ReceivableFee,TotalFee,ExID,ReportType,Operator,WaitingTime,WorkLoadUnitDR)=""
    s DeviceID=$g(DeviceID)
    s SDate=$g(SDate)
    s EDate=$g(EDate)
    i EDate="" d 
    .s EDate=SDate
    
	s Date=SDate
	s strMachineData=$g(^dbo.BTMIMachineParameterD(DeviceID))
	s WorkGroupMachineDR=$lg(strMachineData,6)	
	s ReportRowid=""
	s Date = Date-1  f  s Date=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",WorkGroupMachineDR,Date)) q:(Date>EDate)||(Date="")  d
	.f  s ReportRowid=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",WorkGroupMachineDR,Date,ReportRowid)) q:ReportRowid=""  d
	..s strReportData=$g(^dbo.RPVisitNumberReportD(ReportRowid))
	..s VisitNumberDR=$lg(strReportData,2)
	..q:VisitNumberDR=""
	..s StartDate=$lg(strReportData,9)
	..s StartTime=$lg(strReportData,10)
	..s EndDate=$lg(strReportData,19)
	..S EndTime=$lg(strReportData,20)
	..s AcceptUserDR=$lg(strReportData,11)
	..s AcceptUserData=""
	..s Operator=""
	..i AcceptUserDR'=""  d
	...s AcceptUserData=$g(^dbo.SYSUserD(AcceptUserDR))
	...s Operator=$lg(AcceptUserData,3)
	..s WorkLoadNum=0
	..s PositiveFlag="N"   //Modefied by zc0120 2022-7-26  修正检验阳性取值标识
	..s TestCodeDR="" ///用于统计 工作量
	..f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportRowid,TestCodeDR)) q:TestCodeDR=""  d
	...s Resultrowid=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportRowid,TestCodeDR,""))
	...s WorkLoadNum=WorkLoadNum+1
	...s ResultData=$g(^dbo.RPVisitNumberReportResultD(Resultrowid))
	...s AbFlag=$lg(ResultData,9)
	...i (AbFlag'="")&&(AbFlag'="N") d     	//Modefied by zc0120 2022-7-26  修正检验阳性取值标识
	....s PositiveFlag="Y"					//Modefied by zc0120 2022-7-26  修正检验阳性取值标识
	..s VisitNmData=$g(^dbo.RPVisitNumberD(VisitNumberDR))
	..s PatientID=$lg(VisitNmData,3) ///$o(^dbo.RQPatientI("IndexRegNo",$lg(VisitNmData,3),""))
	..s PatientName=$lg(VisitNmData,13)
	..s PatientAge=$lg(VisitNmData,18) ///_$lg($g(^dbo.BTAgeUnitD($lg(VisitNmData,19))),3)
	..i PatientAge'="" d
	...s Unit=$lg(VisitNmData,19)
	...i Unit'="" d
	....s PatientAge=$lg(VisitNmData,18)_$lg($g(^dbo.BTAgeUnitD($lg(VisitNmData,19))),3)
	..q:$lg(VisitNmData,15)=""
	..s PatientSexCondition=$lg(^dbo.BTSpeciesD($lg(VisitNmData,15)),3)
	..s PatientSex=0
	..i PatientSexCondition="男" s PatientSex=1
	..else  i PatientSexCondition="女" s PatientSex=2
	..s RegDate=$lg(VisitNmData,24)
	..s RegTime=$lg(VisitNmData,25)
	..s AdmissionTypeDR=$lg(VisitNmData,4)
	..q:AdmissionTypeDR=""
	..s AdmissionData=$g(^dbo.BTAdmissionTypeD(AdmissionTypeDR))
	..s ReportTypeCondition=$lg(AdmissionData,3)
	..///Y住院,N门诊,P急诊,O体检,W外院,S手工,F药理,B新生儿,K科研,Q其他
	..i ReportTypeCondition="门诊" s ReportType="N"
	..else  i ReportTypeCondition="住院" s ReportType="Y"
	..else  i ReportTypeCondition="急诊" s ReportType="P"
	..else  i ReportTypeCondition="体检" s ReportType="O"
	..else  i ReportTypeCondition="外院" s ReportType="W"
	..else  i ReportTypeCondition="手工" s ReportType="S"
	..else  i ReportTypeCondition="药理" s ReportType="F"
	..else  i ReportTypeCondition="新生儿" s ReportType="B"
	..else  i ReportTypeCondition="科研" s ReportType="K"
	..else  i ReportTypeCondition="其他" s ReportType="Q"
	..s ReceivableFee=0
	..s TestSetDR=""
	..f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexWGMachineDR",VisitNumberDR,WorkGroupMachineDR,TestSetDR)) q:TestSetDR=""  d
	...s VisitNumberTestsetRowid=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR,""))
	...s VisitNumberTestSetData=$g(^dbo.RPVisitNumberTestSetD(VisitNumberTestsetRowid))
	...s ExID=$lg(VisitNumberTestSetData,10)
	...q:ExID=""
	...s OEOrderID=$p(ExID,"||",1)
	...s ChildSub=$p(ExID,"||",2)
	...q:(OEOrderID="")||(ChildSub="")
	...s Item=$p($g(^OEORD(OEOrderID,"I",ChildSub,1)),"^",2)
	...q:Item=""
	...//s subscript=$p(Item,"||",1)
	...//s version=$p(Item,"||",2)
	...//S Item=$p($g(^ARCIM(subscript,version,1)),"^",2)
	...s ReceivableFee=ReceivableFee+$lg(VisitNumberTestSetData,8)
	..s Price=ReceivableFee
	..s TotalFee=ReceivableFee
	..q:ExID=""
	..;s i=i+1
	..d Output
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
Output
    Set Data=$lb(Item,RegDate,RegTime,StartDate,StartTime,EndDate,EndTime,WorkLoadNum,WorkLoadUnitDR,UseLocDR,PatientID,PatientSex,PatientName,PatientAge,Price,ReceivableFee,TotalFee,ExID,PositiveFlag,ReportType,Operator,WaitingTime)
    Set ColFields="Item,RegDate,RegTime,StartDate,StartTime,EndDate,EndTime,WorkLoadNum,WorkLoadUnitDR,UseLocDR,PatientID,PatientSex,PatientName,PatientAge,Price,ReceivableFee,TotalFee,ExID,PositiveFlag,ReportType,Operator,WaitingTime"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	quit
}

ClassMethod GetLISUseRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLISUseRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLISUseRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLISUseRecordExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// modified by ZY0247 20201222 
/// ***************************************************
/// 旧版C/S  的检验系统通过这个方法采集数据.
/// ***************************************************
/// 获取DHC-LIS 的数据，根据检验的审核日期
/// 将获取的数据存储在
/// ^DHCEQTemp("GatherUseRecord",ExType,$j,Item,Device,Row)
/// 其中ExType:"DHC-LIS",Item为医嘱项，Device为设备代码，Row为顺序号
/// 
/// 节点存储的数据为StartDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_UseLocDR_"^"_PatientInfo_"^"_TotalFee_"^"_Price_"^"_ExID
///    开始日期，开始时间，结束日期，结束时间，工作量，工作量单位，使用科室，患者信息，总费用，单价，医嘱id,阴性/阳性率,预约等待时长。
/// w ##Class(web.DHCEQ.Interface.Inner.DHCEQLISFrom).GetLISUseRecord(60816)
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

}
