/// description: 流程单据记录
Class web.DHCSTPIVAS.PrintRecord Extends web.DHCSTPIVAS.Common
{

/// creator:	yunhaibao
/// createdate: 2018-04-20
/// description:流程单据记录
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.PrintRecord","PrintList","101^^2018-05-01^2018-05-03^^^^^")
Query PogsNoList(inputStr = "") As websys.Query(ROWSPEC = "pogsNo,pogsUserName,pogsDateTime,psName,psNumber,doseDateRange")
{
}

ClassMethod PogsNoListExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:inputStr="" $$$OK
	s PivaLocId=$p(inputStr,"^",1)
	s WardId=$p(inputStr,"^",2)
	s StartDate=$p(inputStr,"^",3)
	s EndDate=$p(inputStr,"^",4)
	s StartTime=$p(inputStr,"^",5)
	s EndTime=$p(inputStr,"^",6)
	s PatNo=$p(inputStr,"^",7)
	s PNo=$p(inputStr,"^",8)
	s WorkTypeId=$p(inputStr,"^",9)
	s PsNumber=$p(inputStr,"^",10)
    s PogsNo=$p(inputStr,"^",11)
	s PNoStart=$p(PNo,"-",1)
	s PNoEnd=$p(PNo,"-",2)
    q:(PNoStart'="")&&(PNoStart'=+PNoStart) $$$OK
    q:(PNoEnd'="")&&(PNoEnd'=+PNoEnd) $$$OK
	q:(PivaLocId="")||(StartDate="")||(EndDate="") $$$OK
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s calcuDate=""
	f calcuDate=StartDate:1:EndDate d
	.s psId=""
	.f  s psId=$o(^PIVA(0,"DATELOC",PivaLocId,calcuDate,psId)) q:psId=""  d
	..q:+psId=0
	..s psData=^PIVAS(psId)
	..s psNumber=$p(psData,"^",1)
	..q:($p(psData,"^",9)'="I")
	..q:(PsNumber'="")&&(PsNumber'=psNumber)
	..s pogId=""
	..f  s pogId=$o(^PIVA(0,"DATELOC",PivaLocId,calcuDate,psId,pogId)) q:pogId=""  d
	...s pogsId=""
	...f  s pogsId=$o(^PIVA(0,"DATELOC",PivaLocId,calcuDate,psId,pogId,pogsId)) q:pogsId=""  d
	....s quitFlag=""
	....s mDsp=$p(^PIVA(pogId),"^",1)
	....s pNo=$p(^PIVA(pogId),"^",11)
	....i PNo'="" d
	.....i (PNoStart'="")&&(pNo<PNoStart) s quitFlag=1 q
	.....i (PNoEnd'="")&&(pNo>PNoEnd) s quitFlag=1 q
	....q:quitFlag'=""
	....s pogsData=$g(^PIVA(pogId,"S",pogsId))
	....s pogsTime=$p(pogsData,"^",5)
	....q:(StartTime'="")&&(calcuDate=StartDate)&&(pogsTime<StartTime)
	....q:(EndTime'="")&&(calcuDate=EndDate)&&(pogsTime>EndTime)
	....s pogsNo=$p(pogsData,"^",7)
	....q:pogsNo=""
    ....q:(PogsNo'="")&&(PogsNo'=pogsNo)
	....q:$d(PogsNoList(pogsNo))
	....s workTypeId=$p(^PIVA(pogId),"^",24)
	....// 过滤条件-集中配置
	....q:(WorkTypeId'="")&&(WorkTypeId'=workTypeId)
	....// 过滤条件-登记号
	....i PatNo'="" d
	.....s mOeori=$p(^DHCOEDISQTY(mDsp),"^",1)
	.....s admId=$P(^OEORD(+mOeori),"^",1)	
	.....s patId=$p(^PAADM(admId),"^",1) 
	.....s patNo=$P(^PAPER(patId,"PAT",1),"^",1)
	.....i PatNo'=patNo s quitFlag=1
	....q:quitFlag'=""
	....// 过滤条件-病区
	....i WardId'="" d
	.....s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
    .....s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
    .....i WardId'=wardId s quitFlag=1
    ....q:quitFlag=1
	....s pogsUser=$p(pogsData,"^",3)
	....s pogsUserName=##class(PHA.PIVAS.Data.Base).UserName(pogsUser)
	....s pogsDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(calcuDate)
	....s pogsTimeHtml=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(pogsTime)
	....s psName=##class(PHA.COM.Data.Base).PIVASStateName(psId)
	....s data=pogsNo_"^"_pogsUserName_"^"_pogsDateHtml_" "_pogsTimeHtml_"^"_psName_"^"_psNumber
	....s PogsNoList(pogsNo)=data
	....s doseDate=$p(^DHCOEDISQTY(mDsp),"^",21)
	....i doseDate'="" s PogsNoListDATA("DoseDate",pogsNo,doseDate)=""
	s pogsNo=""
	f  s pogsNo=$o(PogsNoList(pogsNo)) q:pogsNo=""  d
	.s pogsNoData=PogsNoList(pogsNo)
	.s stDate=$o(PogsNoListDATA("DoseDate",pogsNo,""))
	.s edDate=$o(PogsNoListDATA("DoseDate",pogsNo,""),-1)
	.s stDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(stDate)
	.s edDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(edDate)
	.s doseDateRange=stDate_" ~ "_edDate
	.s pogsNoData=pogsNoData_"^"_doseDateRange
	.s Data=$lfs(pogsNoData,"^")
	.s ^CacheTemp(repid,ind)=Data 
	.s ind=ind+1
	q $$$OK
}

/// description: 获取标签明细
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.PrintRecord","PrintDetail","PIVAS20180418001")
Query PrintDetail(pogsNo = "", inputStr = "") As websys.Query(ROWSPEC = "pid,pogsNo,pNo,pogId,doseDateTime,patInfo,batNo,drugsArr,instrDesc,freqDesc,priDesc,wardDesc,patBedNo,patName,patNo,pivaCatDesc,packFlag")
{
}

ClassMethod PrintDetailExecute(ByRef qHandle As %Binary, pogsNo = "", inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s pid=""
	q:pogsNo="" $$$OK
	s PivaLocId=$p(inputStr,"^",1)
	s WardId=$p(inputStr,"^",2)
	s StartDate=$p(inputStr,"^",3)
	s EndDate=$p(inputStr,"^",4)
	s StartTime=$p(inputStr,"^",5)
	s EndTime=$p(inputStr,"^",6)
	s PatNo=$p(inputStr,"^",7)
	s PNo=$p(inputStr,"^",8)
	s WorkTypeId=$p(inputStr,"^",9)
	s PNoStart=$p(PNo,"-",1)
	s PNoEnd=$p(PNo,"-",2)
	s pogId=""
	f  s pogId=$o(^PIVA(0,"PogsNo",pogsNo,pogId)) q:pogId=""  d
	.// 相关过滤条件
	.s quitFlag=""
	.s pNo=$p(^PIVA(pogId),"^",11)
	.i pNo="" s pNo=99999
	.s workTypeId=$p(^PIVA(pogId),"^",24)
	.// 过滤条件-集中配置
	.q:(WorkTypeId'="")&&(WorkTypeId'=workTypeId)
	.// 过滤条件-打印序号
	.i PNo'="" d
	..i (PNoStart'="")&&(pNo<PNoStart) s quitFlag=1 q
	..i (PNoEnd'="")&&(pNo>PNoEnd) s quitFlag=1 q
	.q:quitFlag'=""
	.s mDsp=$p(^PIVA(pogId),"^",1)
	.q:mDsp=""
	.s mOeori=$P(^DHCOEDISQTY(mDsp),"^",1)
 	.s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
    .s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
    .q:wardId=""
    .q:(WardId'="")&&(WardId'=wardId)
	.s admId=$P(^OEORD(+mOeori),"^",1)	
	.s patId=$p(^PAADM(admId),"^",1) 
	.s patName=$P(^PAPER(patId,"ALL"),"^",1)
	.s patNo=$P(^PAPER(patId,"PAT",1),"^",1)
	.// 过滤条件-登记号
	.q:(PatNo'="")&&(PatNo'=patNo)
	.s bedId=$P(^PAADM(admId),"^",73)
	.s patBedNo="*"
 	.i bedId'="" s patBedNo=$P($g(^PAWARD(+bedId,"BED",+$p(bedId,"||",2))),"^",1)
	.s doseDate=$p(^DHCOEDISQTY(mDsp),"^",21)
	.s doseTime=$p(^DHCOEDISQTY(mDsp),"^",20)
    .s wardDesc=##class(PHA.PIVAS.Data.Base).WardDesc(wardId)
	.s batNo=$p(^PIVA(pogId),"^",3)
	.s phaLocId=$p(^PIVA(pogId),"^",7)
	.s instrDesc=$p(..OeoriInstruc(mOeori),"^",2)
	.s priDesc=$p(..OeoriPriority(mOeori),"^",3)
	.s freqDesc=$p(..OeoriFreq(mOeori),"^",2)
	.i doseDate'="" s doseDate=..DateShortFormat(doseDate)
	.i doseTime'="" s doseTime=..TimeShortFormat(doseTime)
	.s doseDateTime=doseDate_" "_doseTime
	.s patInfo="" 
	.s pivaCatDesc = $p(..GetOrdPivaCat(mOeori), "^", 2)
	.s packFlag=..DspPackFlag(mDsp)
	.s drugsArr = ..GetPogDrugsArr(pogId)
	.s detailData1=pid_"^"_pogsNo_"^"_pNo_"^"_pogId_"^"_doseDateTime
	.s detailData2=patInfo_"^"_batNo_"^"_drugsArr_"^"_instrDesc_"^"_freqDesc
	.s detailData3=priDesc_"^"_wardDesc_"^"_patBedNo_"^"_patName_"^"_patNo
	.s detailData4=pivaCatDesc_"^"_packFlag
	.// 排序
	.s PrintDetailData(pNo,pogId)=detailData1_"^"_detailData2_"^"_detailData3_"^"_detailData4
	s sortIndex=""
	f  s sortIndex=$o(PrintDetailData(sortIndex)) q:sortIndex=""  d
	.s pogId=""
	.f  s pogId=$o(PrintDetailData(sortIndex,pogId)) q:pogId=""  d
	..s ^CacheTemp(repid,ind)=$lfs(PrintDetailData(sortIndex,pogId),"^") 
	..s ind=ind+1
	q $$$OK
}

}
