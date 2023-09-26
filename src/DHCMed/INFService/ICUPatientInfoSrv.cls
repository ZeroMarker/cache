/// 名称: DHCMed.INFService.ICUPatientInfoSrv
/// 描述: DHCMed.INF.ICUPatientInfo ICU日常监测记录
/// 编写者：LYH
/// 编写日期: 2011-05-03
Class DHCMed.INFService.ICUPatientInfoSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     LYH
/// CreatDate：   2011-05-03
/// Description:  查询ICU日常监测记录信息
/// Table：       DHCMed.INF.ICUPatientInfo
/// Input
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.ICUPatientInfoSrv","QryICUInfo","ICU","2010-01-01","2012-01-01","")
Query QryICUInfo(typeDr As %String, strDate As %String, endDate As %String, ctloc As %String) As %Query(ROWSPEC = "ctloc:%String,SameTimeICUNo:%String,InfPatNo:%String,PatRate:%String,InfPatPerNo:%String,PerRate:%String,SameTimeInICUDayNo:%String,PatPerRate:%String,PerDayRate:%String,UTIPerNo:%String,SameTimeUTIDayNo:%String,UTIRate:%String,LRespiratory:%String,SameTimeLRespiratory:%String,LRespiratoryRate:%String,InfBloodNo:%String,SameTimeArteryVeinDay:%String,BloodRate:%String,WindpipeNo:%String,SameTimeWindpipeDay:%String,WindpipeRate:%String,WindPipeCutNo:%String,SameTimeWindpipeCutDay:%String,WindpipeCutRate:%String,UTIPipeRate:%String,TotalVentilatorUserRate:%String,ArteryVeinUserRate:%String,WindPipeCutUserRate:%String,WindPipeSpileUserRate:%String")
{
}

ClassMethod QryICUInfoExecute(ByRef qHandle As %Binary, typeDr As %String, strDate As %String, endDate As %String, ctloc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	k ^CacheTemp($zn,$j)
	s rowid=""
	s:strDate["-" strDate=$zdh(strDate,3)
	s:strDate["/" strDate=$zdh(strDate,1)
	s:endDate["-" endDate=$zdh(endDate,3)
	s:endDate["/" endDate=$zdh(endDate,1)
	f  s rowid=$o(^DHCMed.INF.ICUPatientInfoD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.ICUPatientInfo).%OpenId(rowid)
	.q:'$IsObject(obj)
	.s CtLoc=obj.CtLoc
	.s SurveryDate=obj.SurveryDate
	.s TypesDr=obj.TypesDr
	.q:CtLoc=""
	.q:TypesDr=""
	.q:SurveryDate=""
	.q:((SurveryDate>endDate))||(SurveryDate<strDate)
	.q:((typeDr'="")&(TypesDr'=typeDr))
	.q:((ctloc'="")&(CtLoc'=CtLoc))
	.s ^CacheTemp($zn,$j,CtLoc,rowid)=""
	.k obj
	
	s (TotalSameTimeICUNo,TotalInfPatNo,TotalInfPatPerNo,TotalSameTimeInICUDayNo,TotalUTIPerNo,TotalSameTimeUTIDayNo)=0
	s (TotalLRespiratory,TotalSameTimeLRespiratory,TotalInfBloodNo,TotalSameTimeArteryVeinDay,TotalWindpipeNo,TotalSameTimeWindpipeDay,TotalWindpipeCutNo,TotalSameTimeWindpipeCutDay)=0
	s (TotalPatRate,TotalPerRate,TotalPatPerRate,TotalPerDayRate,TotalUTIRate,TotalLRespiratoryRate,TotalBloodRate,TotalWindpipeRate,TotalWindpipeCutRate,TotalUTIPipeRate,TotalVentilatorUserRate,TotalArteryVeinUserRate,TotalWindPipeCutUserRate,TotalWindPipeSpileUserRate)=""
	
	s ctlocID=""
	f  s ctlocID=$o(^CacheTemp($zn,$j,ctlocID)) q:ctlocID=""  d
	.s (ID,NewInPatNo,OutICUNo,LastMonthStayICUNo,StayICUNo,CatheterNo,ArteryVeinNo,VentilatorNo,WindPipeCutNo,WindPipeSpileNo)=""
	.;同期住在ICU的病人总数、医院感染人次、医院感染例次、同期住在ICU的病人日数、泌尿道感染例次数、同期病人泌尿道插管日数、下呼吸道感染例次数、同期病人使用呼吸机日数、血管相关性感染例次数、同期病人动静脉插管日数、气管插管感染例次数、同期气管插管日数
	.s (SameTimeICUNo,InfPatNo,InfPatPerNo,SameTimeInICUDayNo,UTIPerNo,SameTimeUTIDayNo,LRespiratory,SameTimeLRespiratory,InfBloodNo,SameTimeArteryVeinDay,WindpipeNo,SameTimeWindpipeDay,WindpipeCutNo,SameTimeWindpipeCutDay)=0
	.;人次感染率、例次感染率、病人人次日感染率、病人例次日感染率、下呼吸道感染率、血管相关性感染率、气管插管感染率、泌尿道插管使用率、呼吸机使用率、动静脉插管使用率、气管切开使用率、气管插管使用率
	.s (PatRate,PerRate,PatPerRate,PerDayRate,UTIRate,LRespiratoryRate,BloodRate,WindpipeRate,WindpipeCutRate,UTIPipeRate,VentilatorUserRate,ArteryVeinUserRate,WindPipeCutUserRate,WindPipeSpileUserRate)=""
	.f  s ID=$o(^CacheTemp($zn,$J,ctlocID,ID)) q:ID=""  d
	..s obj=##class(DHCMed.INF.ICUPatientInfo).%OpenId(ID)
	..;**************注意每个项目上对应的顺序可能不一样*********************
	..s str1=obj.Count1		//上月留住在ICU病人数
	..s str2=obj.Count2		//新住进病人数
	..s str3=obj.Count3		//转出ICU病人数
	..s str4=obj.Count4		//住在ICU病人数
	..s str5=obj.Count5		//留置导尿管病人数--CatheterNo
	..s str6=obj.Count6		//动静脉插管病人数--ArteryVeinNo
	..s str7=obj.Count7		//使用呼吸机病人数--VentilatorNo 
	..s str8=obj.Count8		//气管切开病人数--WindPipeCutNo
	..s str9=obj.Count9		//气管插管病人数--WindPipeSpileNo
	..;*********************************************************************
	..s SurveryDate=obj.SurveryDate		//录入日期--调查日期
	..s SameTimeICUNo=SameTimeICUNo+str2	//同期住在ICU的病人总数=新住进病人数+上月留住在ICU人数
	..i +$p($zd(SurveryDate,3),"-",3)=1 d
	...s SameTimeICUNo=SameTimeICUNo+str1		//每个月第一天记录上个月留住ICU人数
	..s InfPatNo=##class(DHCMed.INFService.InfBaseSrv).GetInfPatNo(1,strDate,endDate,ctlocID)
	..s InfPatPerNo=##class(DHCMed.INFService.InfBaseSrv).GetInfPerNo(1,strDate,endDate,ctlocID)
	..s SameTimeInICUDayNo=SameTimeInICUDayNo+str4
	..s SameTimeUTIDayNo=SameTimeUTIDayNo+str5
	..s SameTimeLRespiratory=SameTimeLRespiratory+str7
	..s SameTimeArteryVeinDay=SameTimeArteryVeinDay+str6
	..s SameTimeWindpipeDay=SameTimeWindpipeDay+str9
	..s SameTimeWindpipeCutDay=SameTimeWindpipeCutDay+str8
	
	
	.s TotalSameTimeICUNo=TotalSameTimeICUNo+SameTimeICUNo
	.s TotalInfPatNo=TotalInfPatNo+InfPatNo
	.s:TotalSameTimeICUNo'=0 TotalPatRate=TotalInfPatNo/TotalSameTimeICUNo
	.s TotalInfPatPerNo=TotalInfPatPerNo+InfPatPerNo
	.s TotalSameTimeInICUDayNo=TotalSameTimeInICUDayNo+SameTimeInICUDayNo
	.s:TotalSameTimeInICUDayNo'=0 TotalPatPerRate=TotalInfPatNo/TotalSameTimeInICUDayNo
	.s:TotalSameTimeInICUDayNo'=0 TotalPerDayRate=TotalInfPatPerNo/TotalSameTimeInICUDayNo
	.s TotalSameTimeUTIDayNo=TotalSameTimeUTIDayNo+SameTimeUTIDayNo
	.s:SameTimeICUNo'=0 PatRate=InfPatNo/SameTimeICUNo
	.s:SameTimeICUNo'=0 PerRate=InfPatPerNo/SameTimeICUNo
	.s:SameTimeInICUDayNo'=0 PatPerRate=InfPatNo/SameTimeInICUDayNo
	.s:SameTimeInICUDayNo'=0 PerDayRate=InfPatPerNo/SameTimeInICUDayNo
	
	.s:TotalSameTimeICUNo'=0 TotalPatRate=TotalInfPatNo/TotalSameTimeICUNo
	.s:TotalSameTimeICUNo'=0 TotalPerRate=TotalInfPatPerNo/TotalSameTimeICUNo
	
	.s UTIPerNo=##class(DHCMed.INFService.InfBaseSrv).GetInfPosition(1,strDate,endDate,ctlocID,6)		// 6 泌尿道感染在 感染部位表 DHC_Med.INF.InfPosition ID
	.s TotalUTIPerNo=TotalUTIPerNo+UTIPerNo
	.s:SameTimeUTIDayNo'=0 UTIRate=UTIPerNo/SameTimeUTIDayNo
	.s:TotalSameTimeUTIDayNo'=0 TotalUTIRate=TotalUTIPerNo/TotalSameTimeUTIDayNo
	
	.s LRespiratory=##class(DHCMed.INFService.InfBaseSrv).GetInfPosition(1,strDate,endDate,ctlocID,1)	// 1 下呼吸道感染在 感染部位表 DHC_Med.INF.InfPosition ID
	.s TotalLRespiratory=TotalLRespiratory+LRespiratory
	.s TatalSameTimeLRespiratory=TotalSameTimeLRespiratory+SameTimeLRespiratory
	.s:SameTimeLRespiratory'=0 LRespiratoryRate=LRespiratory/SameTimeLRespiratory
	.s:TatalSameTimeLRespiratory'=0 TotalLRespiratoryRate=TotalLRespiratory/TatalSameTimeLRespiratory
	
	.s InfBloodNo=##class(DHCMed.INFService.InfBaseSrv).GetInfPosition(1,strDate,endDate,ctlocID,3)	// 3 血液在  感染部位表 DHC_Med.INF.InfPosition ID
	.s TotalInfBloodNo=TotalInfBloodNo+InfBloodNo
	.s TotalSameTimeArteryVeinDay=TotalSameTimeArteryVeinDay+SameTimeArteryVeinDay
	.s:SameTimeArteryVeinDay'=0 BloodRate=InfBloodNo/SameTimeArteryVeinDay
	.s:TotalSameTimeArteryVeinDay'=0 TotalBloodRate=TotalInfBloodNo/TotalSameTimeArteryVeinDay
	
	.s WindpipeNo=##class(DHCMed.INFService.InfBaseSrv).GetInfPosition(1,strDate,endDate,ctlocID,1)	// 1 气管插管在  感染部位表 DHC_Med.INF.InfPosition ID
	.s TotalWindpipeNo=TotalWindpipeNo+WindpipeNo
	.s TotalSameTimeWindpipeDay=TotalSameTimeWindpipeDay+SameTimeWindpipeDay
	.s:SameTimeWindpipeDay'=0 WindpipeRate=WindpipeNo/SameTimeWindpipeDay
	.s:TotalSameTimeWindpipeDay'=0 TotalWindpipeRate=TotalWindpipeNo/TotalSameTimeWindpipeDay
	
	.s WindpipeCutNo=##class(DHCMed.INFService.InfBaseSrv).GetInfPosition(1,strDate,endDate,ctlocID,5)	// 5 气管切开在  感染部位表 DHC_Med.INF.InfPosition ID
	.s TotalWindpipeCutNo=TotalWindpipeCutNo+WindpipeCutNo
	.s TotalSameTimeWindpipeCutDay=TotalSameTimeWindpipeCutDay+SameTimeWindpipeCutDay
	.s:SameTimeWindpipeCutDay'=0 WindpipeCutRate=WindPipeCutNo/SameTimeWindpipeCutDay
	.s:TotalSameTimeWindpipeCutDay'=0 TotalWindpipeCutRate=TotalWindpipeCutNo/TotalSameTimeWindpipeCutDay
	
	.;泌尿道插管使用率
	.s:SameTimeICUNo'=0 UTIPipeRate=(SameTimeUTIDayNo/SameTimeICUNo)*1000
	.s:TotalSameTimeICUNo'=0 TotalUTIPipeRate=(TotalSameTimeUTIDayNo/TotalSameTimeICUNo)*1000
	
	.;呼吸机使用率
	.s:SameTimeICUNo'=0 VentilatorUserRate=(SameTimeLRespiratory/SameTimeICUNo)*1000
	.s:TotalSameTimeICUNo'=0 TotalVentilatorUserRate=(TotalSameTimeLRespiratory/TotalSameTimeICUNo)*1000
	
	.;动静脉插管使用率 
	.s:SameTimeICUNo'=0 ArteryVeinUserRate=(SameTimeArteryVeinDay/SameTimeICUNo)*1000
	.s:TotalSameTimeICUNo'=0 TotalArteryVeinUserRate=(TotalSameTimeArteryVeinDay/TotalSameTimeICUNo)*1000
	
	.;气管切开使用率
	.s:SameTimeICUNo'=0 WindPipeCutUserRate=(SameTimeWindpipeCutDay/SameTimeICUNo)*1000
	.s:TotalSameTimeICUNo'=0 TotalWindPipeCutUserRate=(TotalSameTimeWindpipeCutDay/TotalSameTimeICUNo)*1000
	
	.;气管插管使用率
	.s:SameTimeICUNo'=0 WindPipeSpileUserRate=(SameTimeWindpipeDay/SameTimeICUNo)*1000
	.s:TotalSameTimeICUNo'=0 TotalWindPipeSpileUserRate=(TotalSameTimeWindpipeDay/TotalSameTimeICUNo)*1000
	
	.s $li(data,1)=$p($g(^CTLOC(ctlocID)),"^",2)
	.s $li(data,2)=SameTimeICUNo		//同期住在ICU的病人总数
	.s $li(data,3)=InfPatNo				//医院感染人次
	.s $li(data,4)=PatRate				//人次感染率
	.s $li(data,5)=InfPatPerNo			//医院感染例次
	.s $li(data,6)=PerRate				//例次感染率
	.s $li(data,7)=SameTimeInICUDayNo	//同期住在ICU的病人日数
	.s $li(data,8)=PatPerRate			//病人人次日感染率
	.s $li(data,9)=PerDayRate			//病人例次日感染率
	.s $li(data,10)=UTIPerNo			//泌尿道感染例次数
	.s $li(data,11)=SameTimeUTIDayNo	//同期病人泌尿道插管日数=每日留置导尿管病人数之和
    .s $li(data,12)=UTIRate				//泌尿道感染率
    .s $li(data,13)=LRespiratory		//下呼吸道感染例次数
    .s $li(data,14)=SameTimeLRespiratory	//同期病人使用呼吸机日数
    .s $li(data,15)=LRespiratoryRate		//下呼吸道感染率
    .s $li(data,16)=InfBloodNo				//血管相关性感染例次数
    .s $li(data,17)=SameTimeArteryVeinDay	//同期病人动静脉插管日数
    .s $li(data,18)=BloodRate				//血管相关性感染率
    .s $li(data,19)=WindpipeNo				//气管插管感染例次数
    .s $li(data,20)=SameTimeWindpipeDay		//同期气管插管日数
    .s $li(data,21)=WindpipeRate			//气管插管感染率
    .s $li(data,22)=WindpipeCutNo			//气管切开感染例次数
    .s $li(data,23)=SameTimeWindpipeCutDay	//同期气管切开日数
    .s $li(data,24)=WindpipeCutRate			//气管切开感染率
    .s $li(data,25)=UTIPipeRate				//泌尿道插管使用率
    .s $li(data,26)=VentilatorUserRate		//呼吸机使用率
    .s $li(data,27)=ArteryVeinUserRate		//动静脉插管使用率
    .s $li(data,28)=WindPipeCutUserRate		//气管切开使用率
    .s $li(data,29)=WindPipeSpileUserRate	//气管插管使用率
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    
    s $li(data,1)="总计"
    s $li(data,2)=TotalSameTimeICUNo
    s $li(data,3)=TotalInfPatNo
    s $li(data,4)=TotalPatRate
    s $li(data,5)=TotalInfPatPerNo
    s $li(data,6)=TotalPerRate
    s $li(data,7)=TotalSameTimeInICUDayNo
    s $li(data,8)=TotalPatPerRate
    s $li(data,9)=TotalPerDayRate
    s $li(data,10)=TotalUTIPerNo
    s $li(data,11)=TotalSameTimeUTIDayNo
    s $li(data,12)=TotalUTIRate
    s $li(data,13)=TotalLRespiratory
    s $li(data,14)=TatalSameTimeLRespiratory
    s $li(data,15)=TotalLRespiratoryRate
    s $li(data,16)=TotalInfBloodNo
    s $li(data,17)=TotalSameTimeArteryVeinDay
    s $li(data,18)=TotalBloodRate
    s $li(data,19)=TotalWindpipeNo
    s $li(data,20)=TotalSameTimeWindpipeDay
    s $li(data,21)=TotalWindpipeRate
    s $li(data,22)=TotalWindpipeCutNo
    s $li(data,23)=TotalSameTimeWindpipeCutDay
    s $li(data,24)=TotalWindpipeCutRate
    s $li(data,25)=TotalUTIPipeRate
    s $li(data,26)=TotalVentilatorUserRate
    s $li(data,27)=TotalArteryVeinUserRate
    s $li(data,28)=TotalWindPipeCutUserRate
    s $li(data,29)=TotalWindPipeSpileUserRate
    s ^CacheTemp(repid,ind)=data
    s ind=ind+1
	q $$$OK
}

ClassMethod QryICUInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryICUInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
