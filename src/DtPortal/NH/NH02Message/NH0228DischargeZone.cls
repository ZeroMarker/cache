Class DtPortal.NH.NH02Message.NH0228DischargeZone Extends %RegisteredObject [ Not ProcedureBlock ]
{

Query NH022801(userCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,patName:%String,sex:%String,age:%String,MedCareNo:%String,admReason:%String,regNo:%String,ARCIMDesc:%String,DSPStatusDesc:%String,OEORIDateTime:%String,RecLocDesc:%String,OEORIPHFreqDesc:%String,OEORIUnitDesc:%String,OEORIInstrDesc:%String,EpisodeID:%String,oeoreExecId:%String")
{
}

/// NH02.28.01
/// 出院带药服务
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0228DischargeZone","NH022801","2156","1")
ClassMethod NH022801Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String) As %Status
{
	new (qHandle,userCode,wardId)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    s ret=""
   
    Quit:wardId="" $$$OK
    s (bedCode,patName,sex,age,MedCareNo,admReason,regNo,ARCIMDesc,DSPStatusDesc,OEORIDateTime,RecLocDesc,OEORIPHFreqDesc,OEORIUnitDesc,OEORIInstrDesc,EpisodeID)=""
    Set admIdStr=""
    Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",userCode,wardId)
	set days=##Class(DtPortal.Common.PublicService).getValueByCode("DISCHARGEZONEDAYS")
	Quit:admIdStr="" $$$OK
	Set inNum=$l(admIdStr,"^")
    f i=1:1:inNum d
	.s EpisodeID=$p(admIdStr,"^",i)
	.q:EpisodeID=""
	.s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))  
	.q:oeordId=""
    .f date=(+$h-days):1:(+$h) d
	..s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",oeordId,date,ordSttTime)) q:(ordSttTime="")  d
	...s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"Date",oeordId,date,ordSttTime,oeoriSub)) q:(oeoriSub="")  d
	....q:'$d(^OEORD(oeordId,"I",oeoriSub,1))
	....s ordStateDr=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",13) //医嘱状态
	....s orderState=$p(^OEC("OSTAT",ordStateDr),"^",1)
	....q:((orderState="U")||(orderState="C"))   //过滤作废和取消
	....s oeprdr=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8) ;医嘱优先 是否为出院带药
	....q:+oeprdr=0
	....s PriorCode=$p($g(^OECPR(oeprdr)),"^",1)
	....q:PriorCode'="OUT"   //医嘱类型-出院带药code
	....s oeoreSub=0 f  s oeoreSub=$o(^OEORDi(0,"Date",oeordId,date,ordSttTime,oeoriSub,oeoreSub)) q:(oeoreSub="")  d
	.....s execStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16)
    .....i execStatusId'="" s execStat=$p($g(^OEC("STAT",execStatusId)),"^",1)
    .....;s type=1
    .....//发药表
    .....s DSPRowId=$o(^DHCOEDISQTY(0,"OEORE",oeordId_"||"_oeoriSub_"||"_oeoreSub,""),-1)   //倒叙取最后一条记录
	.....s DSPStatus=$p(^DHCOEDISQTY(DSPRowId),"^",7)	//发药状态
	.....q:DSPStatus="R" //退药的退出
	.....s DSPStatusDesc=""
	.....if DSPStatus'="" d
	......set:DSPStatus="C" DSPStatusDesc="已发"
	......set:DSPStatus="TC" DSPStatusDesc="未发" 
	......set:DSPStatus="R" DSPStatusDesc="退回"  
	.....else  set DSPStatusDesc="未知"
	.....set RecLocDr=$p(^DHCOEDISQTY(DSPRowId),"^",24)		//接收科室DR
	.....set:RecLocDr'="" RecLocDesc=$p(^CTLOC(RecLocDr),"^",2)	//接收科室（发药科室）)
	.....set OEORIItmMastDR=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)	//医嘱项DR
	.....q:OEORIItmMastDR=""
	.....set ARCIMSubscript=$p(OEORIItmMastDR,"||",1)
	.....set ARCIMVersion=$p(OEORIItmMastDR,"||",2)
    .....set ARCIMDesc=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)	//医嘱描述
			
	.....set OEORIUnitDR=$p(^OEORD(oeordId,"I",oeoriSub,2),"^",3)		//单位DR
	.....set:OEORIUnitDR'="" OEORIUnitDesc=$p(^CT("UOM",OEORIUnitDR),"^",2)	//单位
	.....set OrdDoseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(oeordId_"||"_oeoriSub)
	.....set OEORIUnitDesc=OrdDoseQty_OEORIUnitDesc
			
	.....set OEORIInstrDR=$p(^OEORD(oeordId,"I",oeoriSub,2),"^",7)	//用法DR
	.....set:OEORIInstrDR'="" OEORIInstrDesc=$p(^PHCIN(OEORIInstrDR),"^",2)					//用法
			
	.....set OEORIPHFreqDR=$p(^OEORD(oeordId,"I",oeoriSub,2),"^",4)	//频次DR
	.....;set:OEORIPHFreqDR'="" OEORIPHFreqDesc=$p(^PHCFR(OEORIPHFreqDR),"^",3)					//频次
	.....set OEORIPHFreqDesc=##class(DtPortal.Common.PublicService).GetOeoriFreq(oeordId_"||"_oeoriSub)
    .....set OEORIDateNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7) ;医嘱日期
	.....set OEORITimeNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",15) ;医嘱时间
	.....set:OEORIDateNo'="" OEORIDate=$zd(OEORIDateNo,3)
	.....set:OEORITimeNo'="" OEORITime=$zt(OEORITimeNo,3)
	.....if OEORITimeNo'="" set OEORIDateTime=OEORIDate_"&nbsp;"_OEORITime
	.....else  set OEORIDateTime=OEORIDate
    .....s oeoreExecId=oeordId_"||"_oeoriSub_"||"_oeoreSub   //执行记录ID
    .....s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
 	.....s bedCode=$p(patInfoStr,"^",1)
 	.....s patName=$p(patInfoStr,"^",2)
 	.....s sex=$p(patInfoStr,"^",3)
 	.....s age=$p(patInfoStr,"^",4)
 	.....s MedCareNo=$p(patInfoStr,"^",5)   //病案号
 	.....s admReason=$p(patInfoStr,"^",6)    //费用类型
 	.....s regNo=$p(patInfoStr,"^",7)    //登记号
 	.....;床号，姓名，性别，年龄，病案号，费用类型，登记号，医嘱描述，发药状态描述，开医嘱时间，接收科室（发药科室），频次，单位，用法，就诊ID，执行记录ID
    .....s ^||CacheTemp(repid,ind)=$lb(bedCode,patName,sex,age,MedCareNo,admReason,regNo,ARCIMDesc,DSPStatusDesc,OEORIDateTime,RecLocDesc,OEORIPHFreqDesc,OEORIUnitDesc,OEORIInstrDesc,EpisodeID,oeoreExecId)
 	.....s ind=ind+1  
	Quit $$$OK
}

}
