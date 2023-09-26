Import sqluser

/// creator: 	yunhaibao
/// createdate: 2018-08-27
/// description:班次岗位日历
Class web.DHCSTPIVAS.DutyScheDetail Extends %RegisteredObject
{

/// deccription:班次列表
/// table:      User.PIVASchedulType
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.DutyScheDetail","PIVASchedul",101)
Query PIVASchedul(inputStr = "") As websys.Query(ROWSPEC = "psId,psCode,psDesc,colorFlag")
{
}

ClassMethod PIVASchedulExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PivaLocId=$p(inputStr,"^",1)
	q:+PivaLocId=0 $$$OK
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT * FROM PIVA_Schedul where PS_RowId>0"
    i PivaLocId'="" s sqlStr=sqlStr_" and PS_Loc_Dr="_"'"_PivaLocId_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s psId= result.Data("PS_RowId") 
	   	s psCode= result.Data("PS_Code") 
	    s psDesc= result.Data("PS_Desc")
        d outputPIVASchedul
    }
    d result.Close()
	Quit $$$OK
outputPIVASchedul
	s colorFlag=""
	s Data=$lb(psId,psCode,psDesc,colorFlag)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// deccription:按日期输出排班明细
/// table:      
/// input:		^1:开始日期,^2:结束日期,^3:配液中心,^4:用户Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.DutyScheDetail","DutyCalenSche","2018-07-29^2018-09-09^101^9")
Query DutyCalenSche(inputStr = "") As websys.Query(ROWSPEC = "start,title")
{
}

ClassMethod DutyCalenScheExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	//s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.DutyScheDetail","DutyCalenSche")=inputStr
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s StartDate=$p(inputStr,"^",1)
	s EndDate=$p(inputStr,"^",2)
	s LocId=$p(inputStr,"^",3)
	q:LocId="" $$$OK
	s ScheId=$p(inputStr,"^",4)
	q:ScheId="" $$$OK 
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	// 上月,本月,下月
	s StartMonth=$p($zd(StartDate,3),"-",1,2)_"-01"
	s EndMonth=$p($zd(EndDate,3),"-",1,2)_"-01"
	s StartMonth=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartMonth)
	s StPreMonth=$p($zd(StartMonth-1,3),"-",1,2)_"-01"
	s StPreMonth=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StPreMonth)
	s EndMonth=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndMonth)
	s psaMonth=StPreMonth
	f  s psaMonth=$o(^Busi.PIVA.ScheArrange(0,"LocMon",LocId,psaMonth)) q:(psaMonth="")||(psaMonth>EndMonth)  d
	.q:+psaMonth=0
	.s psaId=""
	.f  s psaId=$o(^Busi.PIVA.ScheArrange(0,"LocMon",LocId,psaMonth,psaId)) q:psaId=""  d
	..q:+psaId=0
	..s psaItm=""
	..f  s psaItm=$o(^Busi.PIVA.ScheArrange(psaId,"I",psaItm)) q:psaItm=""  d
	...q:+psaItm=0
	...s pasItmData=^Busi.PIVA.ScheArrange(psaId,"I",psaItm)
	...s scheId=$p(pasItmData,"^",3)
	...s scheDate=$p(pasItmData,"^",1)
	...q:(ScheId'="")&&(ScheId'=scheId)
	...s dutyId=$p(pasItmData,"^",4)
	...s dutyObj=##class(User.PIVADuty).%OpenId(dutyId,0)
	...q:dutyObj=""
	...s dutyDesc=dutyObj.PDDesc
	...s scheDateHtml=$zd(scheDate,3)
	...i '$d(DutyCalenScheData(scheDate,dutyId)) d
	....s DutyCalenScheData(scheDate,dutyId)=scheDateHtml_"^"_dutyDesc_"^"_1 // 3节点,记录人数
	...e  d
	....s $p(DutyCalenScheData(scheDate,dutyId),"^",3)=1+$p(DutyCalenScheData(scheDate,dutyId),"^",3)
	s scheDate=""
	f  s scheDate=$o(DutyCalenScheData(scheDate)) q:scheDate=""  d
	.s dutyId=""
	.f  s dutyId=$o(DutyCalenScheData(scheDate,dutyId)) q:dutyId=""  d
	..s data=DutyCalenScheData(scheDate,dutyId)
	..s scheDateHtml=$p(data,"^",1)
	..s dutyInfo=$p(data,"^",2)_" ("_$p(data,"^",3)_"人)"
	..s outputDate=scheDateHtml_"^"_dutyInfo
	..s ^CacheTemp(repid,ind)=$lfs(outputDate,"^")    
	..s ind=ind+1
	q $$$OK
}

}
