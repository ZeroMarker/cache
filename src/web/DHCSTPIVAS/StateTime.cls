Class web.DHCSTPIVAS.StateTime Extends %RegisteredObject
{

/// Description: 打包的不算,没意义,不考虑跳流程
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.StateTime","QueryStateTime","248^2019-01-29^2019-10-29^^^^3^50^>^^")
Query QueryStateTime(InputStr = "") As websys.Query(ROWSPEC = "wardDesc,patNo,patName,drugs,psStartDT,psTimeRange,psEndDT,ps60DT,ps60ExeRange,exeDT,pogId,doseDT,barCode,psTimeRangeSec:%Double,ps60ExeRangeSec:%Double")
{
}

ClassMethod QueryStateTimeExecute(ByRef qHandle As %Binary, InputStr = "") As %Status
{
	k QueryStateTimeDATA
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:InputStr="" $$$OK
	s PivaLocId=$p(InputStr,"^",1)
	s StDate=$p(InputStr,"^",2)
	s EdDate=$p(InputStr,"^",3)
	s WardId=$p(InputStr,"^",4)
	s PatNo=$p(InputStr,"^",5)
	s Inci=$p(InputStr,"^",6)
	s PSStart=$p(InputStr,"^",7)
	s PSEnd=$p(InputStr,"^",8)
	s Relation=$p(InputStr,"^",9)
	s TimeH=$p(InputStr,"^",10)
	s TimeM=$p(InputStr,"^",11)
	q:(PSStart="")||(PSEnd="") $$$OK
	q:PivaLocId="" $$$OK
	s MinMin=""
	i TimeH'="" s MinMin=+TimeH*3600
	i TimeM'="" s MinMin=MinMin+(TimeM*60)
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EdDate)
	s calcuDate=""
	f calcuDate=StDate:1:EdDate d
	.s pogId=""
	.f  s pogId=$o(^PIVA(0,"LOCORDDATE",PivaLocId,calcuDate,pogId)) q:pogId=""  d
	..q:+pogId=0
	..s dspId=$p(^PIVA(pogId),"^",1)
	..s DHCOEDISQTY=$g(^DHCOEDISQTY(dspId))
    ..s wardLocId=$p(DHCOEDISQTY,"^",22)
    ..q:wardLocId=""
    ..s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
    ..q:(WardId'="")&&(WardId'=wardId)
    ..s wardDesc=$p(^CTLOC(wardLocId),"^",2)
    ..s admId=$p(DHCOEDISQTY,"^",26)
    ..s patId=$p(^PAADM(admId),"^",1)
    ..s patName=$p(^PAPER(patId,"ALL"),"^",1)
    ..s patNo=$p(^PAPER(patId,"PAT",1),"^",1)
    ..q:(PatNo'="")&&(PatNo'=patNo)
    ..s mOeori=$p(DHCOEDISQTY,"^",1)
	..q:(Inci'="")&&(##class(web.DHCSTPIVAS.Common).CheckOeoriIncExist(mOeori,Inci)'=1)
	..s pogsItm=""
	..f  s pogsItm=$o(^PIVA(pogId,"S",pogsItm)) q:pogsItm=""  d
	...q:+pogsItm=0
	...s PIVASDATA=$g(^PIVA(pogId,"S",pogsItm))
	...s psDR=$p(PIVASDATA,"^",2)
	...s psName=$p($g(^PIVAS(psDR)),"^",2)
	...s psNumber=$p($g(^PIVAS(psDR)),"^",1)
	...s pogsDate=$P(PIVASDATA,"^",4)
	...s pogsTime=$P(PIVASDATA,"^",5)
	...s QueryStateTimeDATA("POGDT",pogId,psNumber)=pogsDate_"^"_pogsTime
	..s psStDate=$p($g(QueryStateTimeDATA("POGDT",pogId,PSStart)),"^",1)
	..s psEdDate=$p($g(QueryStateTimeDATA("POGDT",pogId,PSEnd)),"^",1)
	..s psStTime=$p($g(QueryStateTimeDATA("POGDT",pogId,PSStart)),"^",2)
	..s psEdTime=$p($g(QueryStateTimeDATA("POGDT",pogId,PSEnd)),"^",2)
	..q:psStDate=""	// 开始状态日期肯定不能为空
	..// 没有结束算当前
	..i psEdDate'="" s psCalEdDate=psEdDate,psCalEdTime=psEdTime
	..e  s psCalEdDate=+$h,psCalEdTime=$p($h,",",2)
	..i psStDate=psCalEdDate s psTimeRange=psCalEdTime-psStTime // 秒数
	..e  d
	...s psTimeRange=psCalEdTime+(86399-psStTime)+((psCalEdDate-psStDate-1)*86399)
	..// 默认排序,具体排序走hisui默认的
	..q:(MinMin'="")&&(Relation=">")&&(psTimeRange<MinMin) // 关系判断
	..q:(MinMin'="")&&(Relation="<")&&(psTimeRange>=MinMin) 
	..

    ..s ps60Date=$p($g(QueryStateTimeDATA("POGDT",pogId,60)),"^",1)
    ..s ps60Time=$p($g(QueryStateTimeDATA("POGDT",pogId,60)),"^",2)
    ..s doseDate=$p(DHCOEDISQTY,"^",21)
	..s doseTime=$p(DHCOEDISQTY,"^",20)
	..s oeore=$p(DHCOEDISQTY,"^",3)
	..q:##class(web.DHCSTPIVAS.Common).CheckOeoreStat(oeore)'=1    // 执行记录-停
	..s OEORDIX=$g(^OEORD(+oeore,"I",+$p(oeore,"||",2),"X",+$p(oeore,"||",3)))
    ..s exeDate=$p(OEORDIX,"^",19)
    ..s exeTime=$p(OEORDIX,"^",20)
    ..s ps60ExeRange=""
    ..i ps60Date'="" d
	...i exeDate'="" s exeCalEdDate=exeDate,exeCalEdTime=exeTime
	...e  s exeCalEdDate=+$h,exeCalEdTime=$p($h,",",2)
	...i ps60Date=exeCalEdDate s ps60ExeRange=exeCalEdTime-ps60Time // 秒数
	...e  d
	....s ps60ExeDateRange=exeCalEdDate-ps60Date
	....s ps60ExeRange=exeCalEdTime+(86399-ps60Time)+((exeCalEdDate-ps60Date-1)*86399)
    ..s psStDT=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(psStDate)_"</br>"_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(psStTime)
    ..s psEdDT=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(psEdDate)_"</br>"_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(psEdTime)
    ..s ps60DT=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ps60Date)_"</br>"_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ps60Time)
    ..s exeDT=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(exeDate)_"</br>"_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(exeTime)
    ..s doseDT=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(doseDate)_"</br>"_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(doseTime)

    ..s barCode=$replace(oeore,"||","-")
    ..s drugs=""
    ..s sortIndex=-+psTimeRange
    ..s data1=wardDesc_"^"_patNo_"^"_patName_"^"_drugs_"^"_psStDT
    ..s data2=psTimeRange_"^"_psEdDT_"^"_ps60DT_"^"_ps60ExeRange_"^"_exeDT
    ..s data3=pogId_"^"_doseDT_"^"_barCode_"^"_+psTimeRange_"^"_+ps60ExeRange
    ..s QueryStateTimeDATA("Data",sortIndex,pogId)=data1_"^"_data2_"^"_data3
	s index=""
	f  s index=$o(QueryStateTimeDATA("Data",index)) q:index=""  d
	.s pogId=""
	.f  s pogId=$o(QueryStateTimeDATA("Data",index,pogId)) q:pogId=""  d
	..s $p(QueryStateTimeDATA("Data",index,pogId),"^",4)=..GetPOGDrugsHtml(pogId)
	..s $p(QueryStateTimeDATA("Data",index,pogId),"^",6)=..FmtToHM($p(QueryStateTimeDATA("Data",index,pogId),"^",6))
	..s $p(QueryStateTimeDATA("Data",index,pogId),"^",9)=..FmtToHM($p(QueryStateTimeDATA("Data",index,pogId),"^",9))
	..s ^CacheTemp(repid,ind)=$lfs(QueryStateTimeDATA("Data",index,pogId),"^") 
	..s ind=ind+1
	q $$$OK
}

ClassMethod GetPOGDrugsHtml(POGId)
{
	
	q:POGId="" ""
	s drugs=""
	s pogItm=0
	f  s pogItm=$o(^PIVA(POGId,"I",pogItm)) q:pogItm=""  d
	.s dspId=$p(^PIVA(POGId,"I",pogItm),"^",1)
	.s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
	.s incStr=##class(web.DHCSTPIVAS.Common).GetIncItmByOeori(oeori)
	.s incDesc=$p(incStr,"^",3)
	.s dosage=##class(web.DHCSTPIVAS.Common).OeoriDosage(oeori)
	.s leftColor="#019BC1"
	.s incDesc="<div style='width:200px;overflow:hidden;float:left;border-left:5px solid "_leftColor_";padding-left:5px;'>"_incDesc_"</div>"
	.s dosage="<div style=width:50px;overflow:hidden;float:left;padding-left:10px>"_dosage_"</div>"
	.s iDrug="<div style=float:left;margin:3px;>"_incDesc_dosage_"</div>"
	.i drugs="" s drugs=iDrug
	.e  s drugs=drugs_iDrug
	q drugs
}

ClassMethod FmtToHM(Second)
{
	q:Second="" ""
	s minute=$fn(Second/60,"",0)
	q:minute<60 minute_"min"
	s ret=""
	s hour=minute\60
	s remMin=minute#60
	i hour>0 s ret=hour_"h "
	i remMin>0 d
	.i remMin<10 s remMin="0"_remMin
	.s ret=ret_remMin_"min"
	e  d
	.s ret=ret_"00min"
	q ret
}

}
