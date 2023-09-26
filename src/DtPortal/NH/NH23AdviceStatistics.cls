/// ClassName:    DtPortal.NH.NH23AdviceStatistics
/// Description:  医嘱床日数统计
/// Creator：     chengpeng
/// CreatDate:    2016-07-22
Class DtPortal.NH.NH23AdviceStatistics Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description	:	ND10.00.01 统计医嘱类型
/// Input		:	年份
/// Return		:	医嘱类型
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.NH.NH23AdviceStatistics","NH230001","8")
Query NH230001(arcIndex As %String = "") As DtPortal.Query(ROWSPEC = "arcRpwID,arcCode,arcDesc")
{
}

ClassMethod NH230001Execute(ByRef qHandle As %Binary, arcIndex As %String = "") As %Status
{
	new (qHandle,arcIndex)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	k ^||NH230001
	
	set indexNo=0
	set arcGro=""
	for
	{
		set arcGro=$o(^DtPortal.Configure.ArcimI("ArcimGroIndex",arcGro))
		quit:arcGro=""
		
		continue:arcGro=" "
		set indexNo=indexNo+1
		continue:((arcIndex'="")&&(indexNo'=arcIndex))
		
		set arcCodeM=""
		set arcDesc=""
		
		set arcConID=""
		for
		{
			set arcConID=$o(^DtPortal.Configure.ArcimI("ArcimGroIndex",arcGro,arcConID))
			quit:arcConID=""
			
			set arcimObj=##class(DtPortal.Configure.arcim).GetObjById(arcConID)
			continue:'$IsObject(arcimObj)
			set ArcimDesc=arcimObj.ArcimDesc
			set ArcimDesc=$tr(ArcimDesc,$c(32),"")
			set:arcDesc'="" arcDesc=arcDesc_"/"_ArcimDesc
			set:arcDesc="" arcDesc=ArcimDesc
			
			set ArcimCode=arcimObj.ArcimCode
			set ArcimCode=$tr(ArcimCode,$c(32),"")
			set:arcCodeM'="" arcCodeM=arcCodeM_"/"_ArcimCode
			set:arcCodeM="" arcCodeM=ArcimCode
		}
		set ^||CacheTemp(repid,ind)=$lb(indexNo,arcCodeM,arcDesc)
		set ind=ind+1
	}
	
	Quit $$$OK
}

/// Description	:	NH23.01.01 统计医嘱床日数趋势
/// Input		:	年份
/// Return		:	月份代号:月份名称:某医嘱床日数
/// ///adateType month,day 按照月或者日出数据
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.NH.NH23AdviceStatistics","NH230101New","1","month","2019-01-01",,"2019-08-09","")
Query NH230101(ArcIndex As %String, adateType As %String, startDate As %String, endDate As %String, wardID As %String = "") As DtPortal.Query(ROWSPEC = "DateDesc,DateCode,SeriesDataArray,dataStr")
{
}

ClassMethod NH230101Execute(ByRef qHandle As %Binary, ArcIndex As %String, adateType As %String, startDate As %String, endDate As %String, wardID As %String = "") As %Status
{
	new (qHandle,ArcIndex,adateType,startDate,endDate,wardID)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^||NH230001
	k ^||NH230002
	set arcCodeStr="",arcDescStr=""
	set arcMObj=##class(%ResultSet).%New("DtPortal.NH.NH23AdviceStatistics:NH230001")
	d arcMObj.Execute(ArcIndex)
	f  Quit:'arcMObj.Next()  d
	.set arcCodeStr= arcMObj.Data("arcCode")
	.set arcDescStr= arcMObj.Data("arcDesc")
	set arcCodeStr1="/"_arcCodeStr_"/"
	d arcMObj.Close()
	
	
	
	set dateType=$CASE(adateType,"month":"byDay","year":"byMonth","quarter":"byMonth","day":"byDay")
	set dateGroupType=$CASE(adateType,"month":"day","year":"month","quarter":"month","day":"day")
	
	set dateObj=##class(%ResultSet).%New("DtPortal.Common.PublicService:getItemDateDetail")
	d dateObj.Execute(dateGroupType,startDate,endDate)
	f  Quit:'dateObj.Next()  d
	.set dateStr= dateObj.Data("dateStr")
	.set date= dateObj.Data("date")
	.set ^||NH230001(dateStr)=0
	.set ^||NH230002(dateStr)=date
	////
	set kpiRule="DtPortal0001"
	set filterRule=""
	set mode="H"
	set contract=""
	set haveData=0
	set rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		set pacWardID=(rs.Data("dimIdCol1"))
		set type=(rs.Data("dimIdCol2"))
		continue:(wardID'="")&&(pacWardID'=wardID)
		continue:arcCodeStr1'[type
		s mDate=rs.Data("month")
		set ^||NH230001(mDate,type)=$g(^||NH230001(mDate,type))+rs.Data("kpiValueCol1")
		set haveData=1
	}
	if (haveData=0){
		k ^||NH230001
	    k ^||NH230002
	    Quit $$$OK
	}
	;b ;122222222
	set Rdate=""
	for
	{
		set Rdate=$o(^||NH230001(Rdate))
		quit:Rdate=""
		
		set DateCode=$g(^||NH230002(Rdate))
		w DateCode,!
		set SeriesDataArray=""
		set dataStr=""
		set value1=0,value2=0,value3=0,value4=0,value5=0,arcDesc1="",arcDesc2="",arcDesc3="",arcDesc4="",arcDesc5=""
		for index=1:1:$l(arcCodeStr,"/")
		{
			set arcCode=$p(arcCodeStr,"/",index)
			set arcDesc=$p(arcDescStr,"/",index)
			s value=0
			set:$d(^||NH230001(Rdate,arcCode)) value=^||NH230001(Rdate,arcCode)
			set arcDesc=$tr(arcDesc,$c(32),"")
			set:index=1 value1=value,arcDesc1=arcDesc
			set:index=2 value2=value,arcDesc2=arcDesc
			set:index=3 value3=value,arcDesc3=arcDesc
			set:index=4 value4=value,arcDesc4=arcDesc
			set:index=5 value5=value,arcDesc5=arcDesc
			
			set tempStr=arcCode_"^"_arcDesc_"^"_value
			if (index=1){
				set dataStr=dataStr_tempStr
				set SeriesDataArray=SeriesDataArray_arcCode
			}else{
				set dataStr=dataStr_"#"_tempStr
				set SeriesDataArray=SeriesDataArray_"^"_arcCode
			}
			
		}
		set ^||CacheTemp(repid,ind)=$lb(Rdate,DateCode,SeriesDataArray,dataStr)
		set ind=ind+1
		
	}
		
	k ^||NH230001
	k ^||NH230002
	Quit $$$OK
}

/// Description	:	NH23.01.02 统计某月/日全院/某病区医嘱床日数趋势
/// Input		:	dateType 按照月份出数据
/// Return		:	月份代号:月份名称:医嘱床日数
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.NH.NH23AdviceStatistics","NH230102New",2,"month","2017-08-10","")
Query NH230102(arcType As %String, dateType As %String, startDate As %String, endDate As %String, wardID As %String = "") As DtPortal.Query(ROWSPEC = "wardDesc,SeriesDataArray,dataStr")
{
}

ClassMethod NH230102Execute(ByRef qHandle As %Binary, arcType As %String, dateType As %String, startDate As %String, endDate As %String, wardID As %String = "") As %Status
{
	new (qHandle,arcType,dateType,startDate,endDate,wardID)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	k ^||NH230102
	set arcCodeStr="",arcDescStr=""
	set arcMObj=##class(%ResultSet).%New("DtPortal.NH.NH23AdviceStatistics:NH230001")
	d arcMObj.Execute(arcType)
	f  Quit:'arcMObj.Next()  d
	.set arcCodeStr= arcMObj.Data("arcCode")
	.set arcDescStr= arcMObj.Data("arcDesc")
	set arcCodeStr1="/"_arcCodeStr_"/"
	d arcMObj.Close()
		
	if (dateType="year")||(dateType="month")||(dateType="quarter")
	{	
		set dateType="byMonth"
	}else
	{      
		set dateType="byDay"
	}
	
	
	set kpiRule="DtPortal0001"
	set filterRule=""
	set mode="H"
	set contract=""
	set rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,contract)
	While rs.Next(.sc) {
			If $$$ISERR(sc) Quit
			set pacWardID=(rs.Data("dimIdCol1"))
			set type=(rs.Data("dimIdCol2"))
			continue:arcCodeStr1'[type
			continue:(wardID'="")&&(pacWardID'=wardID)
			s mDate=rs.Data("month")
			s mDate=$p($p(mDate,"年",2),"月",1)
			i mDate<10 s mDate=$p(mDate,"0",2)
			set ^||NH230102(pacWardID,type)=$g(^||NH230102(pacWardID,type))+rs.Data("kpiValueCol1")
		}
		
	set ward=""
	for
	{
		set ward=$o(^||NH230102(ward))
		quit:ward=""
		
		set wardDesc=$p(^PAWARD(ward),"^",2)
		set:wardDesc["-" wardDesc=$P(wardDesc,"-",2)
		set SeriesDataArray=""
		set dataStr=""
		set value1=0,value2=0,value3=0,value4=0,value5=0
		for index=1:1:$l(arcCodeStr,"/"){
			set arcCode=$p(arcCodeStr,"/",index)
			set arcDesc=$p(arcDescStr,"/",index)
			s value=0
			set:$d(^||NH230102(ward,arcCode)) value=^||NH230102(ward,arcCode)
			set arcDesc=$tr(arcDesc,$c(32),"")
			set:index=1 value1=value
			set:index=2 value2=value
			set:index=3 value3=value
			set:index=4 value4=value
			set:index=5 value5=value
		    set tempStr=arcCode_"^"_arcDesc_"^"_value
			if (index=1){
				set dataStr=dataStr_tempStr
				set SeriesDataArray=SeriesDataArray_arcCode
			}else{
				set dataStr=dataStr_"#"_tempStr
				set SeriesDataArray=SeriesDataArray_"^"_arcCode
			}
			
	    }
		
		set ^||CacheTemp(repid,ind)=$lb(wardDesc,SeriesDataArray,dataStr)
		set ind=ind+1
	}
	k ^||NH230102
	Quit $$$OK
}

ClassMethod GetJidu(mounth As %String) As %String
{
	
	New (mounth)
	set return=""
	set:mounth<4 return=1
	set:(mounth>3)&&(mounth<7) return=2
	set:(mounth>6)&&(mounth<10) return=3
	set:mounth>9 return=4
	Quit return
}

}
