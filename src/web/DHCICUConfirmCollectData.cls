Import SQLUSer

Class web.DHCICUConfirmCollectData
{

// w ##class(web.DHCICUConfirmCollectData).AsyncData()

ClassMethod AsyncData()
{
	&sql(declare itemCursor Cursor for 
	SELECT ICUA_RowId into :icuaId
	FROM DHC_ICU_Arrange
	WHERE ICUA_Status="M"
	)
	&sql(open itemCursor)
	set lastDataList=[]
	For
	{
		&sql(Fetch itemCursor)
		quit:SQLCODE
		w icuaId,!
		do ..AsyncDataByIcuaId(icuaId)
	}
	&sql(close itemCursor)
	quit 0
}

/// editor:dtj 20210819
/// 按iucaId同步采集数据
///     根据DHC_ICU_CollectDataAdmission表中的数据同步
/// 参数：
///     icuaId:重症Id
///     
///     
/// 返回值： 0
/// w ##class(web.DHCICUConfirmCollectData).AsyncDataByIcuaId(507)
ClassMethod AsyncDataByIcuaId(icuaId)
{
	&sql(select RowId into :rowId from DHC_ICU_CollectDataAdmission
	where ArrangeId=:icuaId)
	quit:rowId="" "该患者未配置步同"
	
	set config=##class(User.DHCICUCollectDataAdmission).%OpenId(rowId)
	set span=config.SetDuration*60
	set count=config.CollectTimes
	
	set arrange=##class(User.DHCICUArrange).%OpenId(icuaId)
	set startDate=arrange.ICUAStartDate
	set startTime=arrange.ICUAStartTime
	// 计算开始时间,如:09:10从09:30开始,09:40从10:00开始
	set startTime=(((startTime+span-1)\span)*span)
	set startDatetime=(startDate*24*3600)+startTime
	set endDatetime=startDatetime+(span*count)
	set curDatetime=(+$h*24*3600)+$p($h,",",2)
	b ///
	if (curDatetime<=endDatetime)
	{ 
	    do ..GenCollectByTime(icuaId, startDate, startTime, count, span)
	}
	quit 0
}

/// editor:dtj 20210603
/// 按开始时间点同步采集数据
///     默认间隔为5分钟
/// 参数：
///     icuaId:重症Id
///     date: 开始日期       time: 开始时间
///     count: 时间点个数    span: 时间间隔(min)
/// 返回值： 0
/// w ##class(web.DHCICUConfirmCollectData).GenCollectByTime(2,"2021-06-08","08:00",4,10)
ClassMethod GenCollectByTime(icuaId, date, time, count = 4, span = 5)
{
	// w ##class(web.DHCICUConfirmCollectData).GenCollectByTime(2,"2021-06-04","14:00",4)
    Set date=##class(web.DHCClinicCom).ConvertToDateH(date)
    Set time=##class(web.DHCClinicCom).ConvertToTimeH(time)
    For i=0:1:count
    {
	    set asycTime=time+((span)*i)
	    w "Async:",##class(web.DHCClinicCom).ConvertToTime(asycTime),!
        Do ..GenCollectByTimePoint(icuaId,date,asycTime ,20*60)
    }
    Quit 0
}

/// 按时间点同步数据
/// date: 日期
/// time: 时间
/// scope: 取值范围
/// 
ClassMethod GenCollectByTimePoint(icuaId, date, time, scope = 120) As %Status
{
    Set date=##class(web.DHCClinicCom).ConvertToDateH(date)
    Set time=##class(web.DHCClinicCom).ConvertToTimeH(time)
    Do Init
    Set isExit=0
    Set curDate=date,curTime=time
	For  Set curTime=$ORDER(^DHCICUArrange(0,"CData",icuaId,curDate,curTime),-1) Quit:(curTime="")!(isExit)  Do
	.If $ZABS(((date*3600*24)+time)-((curDate*3600*24)+curTime))>scope Set isExit=1 Quit //十分钟内数据
	.
	.Set icucdSub=""
	.For  Set icucdSub=$ORDER(^DHCICUArrange(0,"CData",icuaId,curDate,curTime,icucdSub)) Quit:icucdSub=""  Do
	..Quit:'$DATA(^DHCICUArrange(icuaId,"C",icucdSub))
	..Quit:$PIECE(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)=""
	..Quit:$DATA(IcucriList($PIECE(^DHCICUArrange(icuaId,"C",icucdSub),"^",1)))
	..Set recordItemId=$PIECE(^DHCICUArrange(icuaId,"C",icucdSub),"^",1) ;2014-11-11 dtj
	..Set recordItemCode=$PIECE($GET(^DHCICUC("RecordItem",recordItemId)),"^",1)
	..If ((recordItemCode'="NSBP")&&(recordItemCode'="NDBP")&&(recordItemCode'="NMBP")) Do
	...; 非无创血压
	...Set IcucriList(recordItemId)=icucdSub
	b //////////
    Set icucriId=""
	For  Set icucriId=$ORDER(IcucriList(icucriId)) Quit:icucriId=""  Do
	.
	.Set icucdSub=IcucriList(icucriId)
	.Quit:'$DATA(^DHCICUArrange(icuaId,"C",icucdSub))
	.Set txtValue=$PIECE(^DHCICUArrange(icuaId,"C",icucdSub),"^",4) //ICUO_Note
	.Set numValue=$PIECE(^DHCICUArrange(icuaId,"C",icucdSub),"^",5) //ICUO_Qty
	.Do ##class(web.DHCICUDeviceData).AddICUOrder(icuaId,icucriId,date,time,numValue,txtValue)
	.;b "Insert"
	.// 组合项数据收集
	.Set itemName=$PIECE($GET(^DHCICUC("RecordItem",icucriId)),"^",1)
	.Set itemValue="" Set txtValue=""
	.If itemValue="" Set itemValue=numValue
	.Set isub=""
	.For  Set isub=$ORDER(comItems(isub)) Quit:isub=""  Do  
	..Set comItem=comItems(isub)
	..If comItem[itemName Set comItems(isub,icuaId,itemName)=itemValue
	

	// 组合项
	Set txtValue=""
	Set numValue=""
	Set isub=""
	
	For  Set isub=$ORDER(comItems(isub)) Quit:isub=""  Do 
	.Set csub="" Set csub=$ORDER(comItems(isub,icuaId,csub))
	.Quit:csub=""
	.Set icucriId=isub
	.Set txtValue=comItems(isub,"format") ;{0}/{1}({2})
	.Set count=$LENGTH(txtValue,"{")-2
	.Set nullValue=txtValue
	.For j=0:1:count Do
	..Set itemName=$PIECE(comItems(isub),";",j+1)
	..If itemName="" Set aValue=""
	..s fStr=$REPLACE("{N}","N",j)
	..Else  Set aValue=$GET(comItems(isub,icuaId,itemName))
	..Set txtValue=$REPLACE(txtValue,fStr,aValue)
	..Set nullValue=$REPLACE(nullValue,fStr,"")
	.Quit:nullValue=txtValue  
	.Do ##class(web.DHCICUDeviceData).AddICUOrder(icuaId,icucriId,date,time,numValue,txtValue)
	Quit 0
	
Init
	// 组合项初始化
	Set comOrd=""
	For  Set comOrd=$ORDER(^DHCICUC("RecordItem",comOrd)) Quit:comOrd=""  Do
	.Set comItem=$GET(^DHCICUC("RecordItem",comOrd))
	.Set cTypeID=$PIECE(comItem,"^",5)
	.Quit:cTypeID=""
	.Set cTypeCode=$PIECE($GET(^DHCICUC("ViewCat",cTypeID)),"^",1) // 类型:只处理生命体征
	.Quit:cTypeCode=""
	.Set forStr=$PIECE(comItem,"^",25)
	.Set paraStr=$PIECE(comItem,"^",27)
	.If ($PIECE(comItem,"^",24)="Note")&((cTypeCode="VitalSign")||(cTypeCode="ICUBloodAnalysis")||(cTypeCode="ICUBloodAnalysis")||(cTypeCode="RespiratorySupport")||(cTypeCode="HF"))&(forStr["{0}") Do
	..Set comItems(comOrd)=$PIECE(comItem,"^",27) ;NSBP;NDBP;NMBP
	..Set comItems(comOrd,"format")=$PIECE(comItem,"^",25) ; {0}/{1}({2})	
	Merge ^DHCCLSet("ComfirmData","GroupData")=comItems	
	Quit
}

}
