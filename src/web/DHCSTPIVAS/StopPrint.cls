Import sqluser

/// description: 停止签打印记录
Class web.DHCSTPIVAS.StopPrint Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// description: 仅供显示停止签明细
/// w ##class(web.DHCSTPIVAS.StopPrint).JsGetStopOeQueryDetail(50,1,"1550")
ClassMethod JsGetStopOeQueryDetail(rows, page, inputStr)
{
	n (rows, page, inputStr)
	s $zt="JsonErrorRecord^DHCSTERROR"
	s retData=..GetStopOeQueryDetail(rows, page, inputStr)
	s pid=$p(retData,"^",1)
	s total=+$p(retData,"^",2)
	q:(total=0)||(pid="") ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s count=0
	s title1="doseDateTime^wardDesc^bedNo^patNo^patName"
	s title2="batNo^oeoriSign^incDesc^incSpec^dosage"
	s title3="freqDesc^instrucDesc^priDesc^qty^bUomDesc"
	s title4="docName^colColor^pogId"
	s titleStr=title1_"^"_title2_"^"_title3_"^"_title4
	s outputI=""
	f  s outputI=$o(^TMP("DHCST","web.DHCSTPIVAS.StopPrint","GetStopOeQueryDetail",pid,outputI)) q:outputI=""  d
	.s outputData=^TMP("DHCST","web.DHCSTPIVAS.StopPrint","GetStopOeQueryDetail",pid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(titleStr,outputData,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(titleStr,outputData,"^")
	i count>0   w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	d ..ClearTMPGetStopOeQueryDetail(pid)
	q ""
}

/// creator:	dinghongying
/// createdate: 2018-03-07
/// description:获取停止签医嘱明细
/// w ##class(web.DHCSTPIVAS.StopPrint).GetStopOeQueryDetail(50,1,"1448")
ClassMethod GetStopOeQueryDetail(rows, page, inputStr)
{
	n (rows, page, inputStr)
    s EndRow=page*rows  
	s StartRow=((page-1)*rows)+1 
	s cPrtId=$p(inputStr,"^",1)
	q:cPrtId="" ""
	s WardId=$p(inputStr,"^",2)
	s PatNo=$p(inputStr,"^",3)
	s pid=..NewPid()
	s total=0
	s pogId=""
	f  s pogId=$o(^PIVA(0,"PCP",cPrtId,pogId)) q:pogId=""  d
	.q:+pogId=0
	.// 直接过滤行号
	.s mDsp=$p(^PIVA(pogId),"^",1)
	.s mOeori=$p(^DHCOEDISQTY(mDsp),"^",1)
	.s mOrd=+mOeori
	.s admId=$p(^OEORD(mOrd),"^",1)
	.s grpNo=$p(^PIVA(pogId),"^",2)
	.s batNo=$p(^PIVA(pogId),"^",3)
 	.s doseDate=$p(^DHCOEDISQTY(mDsp),"^",21)
	.s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
    .s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
    .q:(WardId'="")&&(WardId'=wardId)
    .s wardDesc=$p(^PAWARD(wardId),"^",2)
    .s admId=$p(^DHCOEDISQTY(mDsp),"^",22)
 	.s patId=$p(^PAADM(admId),"^",1)
	.s patNo=$P(^PAPER(patId,"PAT",1),"^",1)
	.q:(PatNo'="")&&(PatNo'=patNo)
 	.s bedId=$P(^PAADM(admId),"^",73)
 	.s bedNo="*"
 	.i bedId'="" s bedNo=$P($g(^PAWARD(+bedId,"BED",$p(bedId,"||",2))),"^",1)
 	.s patId=$p(^PAADM(admId),"^",1)
    .s sortIndex=doseDate_"||"_wardDesc_"||"_bedNo_"||"_patId_"||"_batNo_"||"_mDsp_"||"_pogId
    .// 排序
    .s GetStopOeQueryDetailData(sortIndex)=""
    q:'$d(GetStopOeQueryDetailData) ""
    s record=0,colColor=0,lastPatId=""
    s sortIndex=""
    f  s sortIndex=$o(GetStopOeQueryDetailData(sortIndex)) q:sortIndex=""  d
	.s total=total+1
	.q:total<StartRow
    .q:total>EndRow
    .s pogId=$p(sortIndex,"||",7)
    .s mDsp=$p(sortIndex,"||",6)
    .s mOeori=$p(^DHCOEDISQTY(mDsp),"^",1)
	.s admId=$p(^OEORD(mOrd),"^",1)
	.s grpNo=$p(^PIVA(pogId),"^",2)
	.s batNo=$p(^PIVA(pogId),"^",3)
 	.s doseDate=$p(^DHCOEDISQTY(mDsp),"^",21)
 	.s doseTime=$p(^DHCOEDISQTY(mDsp),"^",20)
 	.s:doseTime'="" doseTime=$zt(doseTime,2)
 	.s doseDateTime=$p($zd(doseDate,3),"-",2,3)_" "_doseTime
	.s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
    .s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
    .s wardDesc=$p(^PAWARD(wardId),"^",2)
    .s admId=$p(^DHCOEDISQTY(mDsp),"^",22)
 	.s bedId=$P(^PAADM(admId),"^",73)
 	.s bedNo="*"
 	.i bedId'="" s bedNo=$P($g(^PAWARD(+bedId,"BED",$p(bedId,"||",2))),"^",1)
 	.s patId=$p(^PAADM(admId),"^",1)
    .i lastPatId'=patId s colColor=colColor+1
    .s lastPatId=patId
	.s patNo=$P(^PAPER(patId,"PAT",1),"^",1)
	.S patName=$P(^PAPER(patId,"ALL"),"^",1)
	.s instrucDesc=##class(web.DHCSTPIVA).GetInstruc(mOeori)
	.s freqDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(mOeori),"^",3)							           	
	.s docName=##class(web.DHCSTPIVA).GetDoctor(mOeori)
	.&SQL(SELECT count(*) into :pogItmCnt FROM PIVA_OrdGrpItm WHERE POGI_POG_Parref=:pogId)
	.// pogItmCnt-一组液体明细个数
	.s oeoriSign="",pogNum=0
	.s pogItm=""
	.f  s pogItm=$o(^PIVA(pogId,"I",pogItm)) q:pogItm=""  d
	..s pogNum=pogNum+1
	..i pogItmCnt=1 s oeoriSign=""
	..e  d
	...i pogNum=1 s oeoriSign="┍"
	...e  d
	....i pogNum=pogItmCnt s oeoriSign="┕"
	....e  s oeoriSign="│"
	..s dspId=$p(^PIVA(pogId,"I",pogItm),"^",1)
	..s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
	..s incStr=##class(web.DHCSTPIVA).GetIncItm(oeori)
	..s incDesc=$p(incStr,"^",3)
	..s incId=$p(incStr,"^",1)
	..q:incId=""
 	..s incSpec=##class(web.DHCSTCOMINC).GetSpec(incId)	
 	..s dosage=##class(web.DHCSTPIVA).GetDosage(oeori)	
 	..s priDesc=$p(##class(web.DHCSTPIVA).GetOePriority(oeori),"^",3)
	..s qty=$P(^DHCOEDISQTY(dspId),"^",11)
 	..s bUomId=$P(^DHCOEDISQTY(dspId),"^",6)
 	..s bUomDesc=$P($g(^CT("UOM",+bUomId)),"^",2)
 	..i pogNum>1 s (doseDateTime,wardDesc,bedNo,patNo,patName,batNo)=""
 	..s data1=doseDateTime_"^"_wardDesc_"^"_bedNo_"^"_patNo_"^"_patName
	..s data2=batNo_"^"_oeoriSign_"^"_incDesc_"^"_incSpec_"^"_dosage
	..s data3=freqDesc_"^"_instrucDesc_"^"_priDesc_"^"_qty_"^"_bUomDesc
	..s data4=docName_"^"_colColor_"^"_pogId
	..s data=data1_"^"_data2_"^"_data3_"^"_data4
	..s record=record+1
	..s ^TMP("DHCST","web.DHCSTPIVAS.StopPrint","GetStopOeQueryDetail",pid,record)=data
	q pid_"^"_total
}

/// creator:	yunhaibao
/// createdate: 2018-03-15
/// description:获取停止签打印记录
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.StopPrint","CPrintList","101^^2018-03-15^2018-03-15^01:00:00^01:00:00")
Query CPrintList(inputStr = "") As websys.Query(ROWSPEC = "cPrtId,cPrtNo,cPrtDateTime,cPrtUserName")
{
}

ClassMethod CPrintListExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	n (qHandle,inputStr)
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
	q:(PivaLocId="")||(StartDate="")||(EndDate="") $$$OK
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s quitFlag=""
	s cPrtId=""
	f  s cPrtId=$o(^PIVACP(cPrtId),-1) q:(cPrtId="")||(quitFlag'="")  d
	.q:+cPrtId=0
	.s cPrtNo=$p($g(^PIVACP(cPrtId)),"^",1)
	.s cPrtDate=$p($g(^PIVACP(cPrtId)),"^",3) 
	.i cPrtDate<StartDate s quitFlag=1
	.q:(cPrtDate<StartDate)||(cPrtDate>EndDate)
	.s cPrtTime=$p($g(^PIVACP(cPrtId)),"^",4)
	.// 过滤条件-停止签打印时间
	.q:(StartTime'="")&&(cPrtDate=StartDate)&&(cPrtTime<StartTime)
	.q:(EndTime'="")&&(cPrtDate=EndDate)&&(cPrtTime>EndTime)
	.s pogId=$o(^PIVA(0,"PCP",cPrtId,"")) 
	.q:+pogId=0
	.s mDsp=$p(^PIVA(pogId),"^",1)
	.s mOeori=$p(^DHCOEDISQTY(mDsp),"^",1)
	.s mOrd=+mOeori
	.s admId=$p(^OEORD(mOrd),"^",1)
	.s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
    .s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
    .// 过滤条件-病区
    .q:(WardId'="")&&(WardId'=wardId)
 	.s patId=$p(^PAADM(admId),"^",1)
	.s patNo=$P(^PAPER(patId,"PAT",1),"^",1)
	.// 过滤条件-登记号
	.q:(PatNo'="")&&(PatNo'=patNo)
	.s cPrtDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(cPrtDate)
	.s cPrtTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(cPrtTime)
	.s cPrtUserId=$p($g(^PIVACP(cPrtId)),"^",2)
	.s cPrtUserName=$p($g(^SSU("SSUSR",+cPrtUserId)),"^",2)
	.s cPrtDateTime=cPrtDate_" "_cPrtTime
	.s Data=$lb(cPrtId,cPrtNo,cPrtDateTime,cPrtUserName)
	.s ^CacheTemp(repid,ind)=Data 
	.s ind=ind+1
	q $$$OK
}

ClassMethod ClearTMPGetStopOeQueryDetail(pid)
{
	n (pid)
	q:pid="" ""
	k ^TMP("DHCST","web.DHCSTPIVAS.StopPrint","GetStopOeQueryDetail","OutPut",pid)
	q ""
}

/// creator:    yunhaibao
/// createdate: 2018-04-25
/// description:打印停止签前存数据处理配液表
/// input:		pogId数据串
/// return:		0成功,否则失败
/// w ##class(web.DHCSTPIVAS.StopPrint).SaveCPrint("262","1")
ClassMethod SaveCPrint(pogStr, userId)
{
	n (pogStr,userId)
	s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.StopPrint","SaveCPrint")=$lb(pogStr,userId)
	s $zt="ThrowSaveCPrint"
	q:pogStr="" "-1^未选择停止的执行记录"
	q:userId="" "-2^用户Id为空"
	ts
	s cpId=..InsertCPrint(userId)
	i cpId<0 tro  q cpId
	s errCode=""
	s pogLen=$l(pogStr,"^")
	s pogI=0,pogCnt=0
	f pogI=1:1:pogLen q:+errCode<0  d
	.s pogId=$p(pogStr,"^",pogI)
	.q:pogId=""
   	.s lockRet=##class(web.DHCSTPIVAS.Common).Lock("PIVAOrdGrp",pogId)
	.q:lockRet'=0 
	.s pogCnt=pogCnt+1
	.s pogRet=..SavePogCPrint(pogId,cpId,pogCnt,userId)
	.d ##class(web.DHCSTPIVAS.Common).UnLock("PIVAOrdGrp",pogId)
	.i +pogRet<0  d
	..tro
	..s errCode="-1^更新配液状态失败,"_$p(pogRet,"^",2)
	q:errCode'="" errCode
	tc
	q 0
ThrowSaveCPrint
	s errMsgInfo="##class(web.DHCSTPIVAS.StopPrint).SaveCPrint"
	d ErrorRecord^DHCSTERROR("DHCSTINPIVA",errMsgInfo,$ze)	
	q "-2^"_$tr($ze,"^","-")
}

/// description: 插入停止签打印表
/// table:		 PIVACPrint
/// w ##class(web.DHCSTPIVAS.StopPrint).InsertCPrint(1)
ClassMethod InsertCPrint(userId) As %String
{
	n (userId)
	s errCode=""
	s cpNo=..NewCPrintNo()
	q:$p(cpNo,"^",1)<0 cpNo
	s curDate=+$h
	s curTime=$p($h,",",2)
	&SQL(
		INSERT INTO PIVA_CPrint
		(PCP_PrintNo,PCP_SSUSR_Dr,PCP_Date,PCP_Time)
		VALUES
		(:cpNo,:userId,:curDate,:curTime)
	)
	i SQLCODE'=0 d
	.s errCode="-2^插入PIVACPrint失败,"_SQLCODE_":"_%msg 
	.s errMsgInfo="##class(web.DHCSTPIVAS.StopPrint).InsertCPrint"
	.d ErrorRecord^DHCSTERROR("DHCSTINPIVA",errMsgInfo,SQLCODE_":"_%msg)
	q:errCode'="" errCode
	q $P(%ROWID,$C(1))
}

/// description: 生成停止签单号
/// w ##class(web.DHCSTPIVAS.StopPrint).NewCPrintNo()
ClassMethod NewCPrintNo() As %String
{
   	s lockRet=##class(web.DHCSTPIVAS.Common).Lock("PIVACPrint","NewCPrintNo")
	q:lockRet'=0 "-1^生成单号加锁失败"
	s noPre="C"_$e($zd(+$H,8),3,8)
	S maxNo=""
	S curDate=+$H
	&sql(Select Max(PCP_PrintNo) Into :maxNo From  PIVA_CPrint Where PCP_Date=:curDate And %ALPHAUP(PCP_PrintNo) %STARTSWITH :noPre)
	s maxNo=$e(maxNo,10,12)+1
	s maxNo=$j(maxNo,3)
	s maxNo=$tr(maxNo," ","0")
	s cpNo=noPre_maxNo
	d ##class(web.DHCSTPIVAS.Common).UnLock("PIVACPrint","NewCPrintNo")
	q cpNo
}

/// description: 打印停止签时更新PIVA_OrdGrp,如设置为打印停止签退药则同时处理退药
/// w ##class(web.DHCSTPIVAS.StopPrint).SavePogCPrint(100000026,100000005,1)
ClassMethod SavePogCPrint(pogId As %String, cpId As %String, cpNo As %String, userId As %String) As %String
{
	n (pogId,cpId,cpNo,userId)
	s errCode=""
	s mDsp=$P(^PIVA(pogId),"^",1)
    s mOeore=$p(^DHCOEDISQTY(mDsp),"^",3)
    s mOeori=$p(^DHCOEDISQTY(mDsp),"^",1)
    S oeoreStat=##class(web.DHCSTPIVAS.Common).CheckOeoreStat(mOeore)
    q:oeoreStat'=0 0
    s recLocId=$p(^DHCOEDISQTY(mDsp),"^",24)
    /// 判断是否退过
	s dispFlag = ##class(web.DHCSTPIVAS.Common).IsOrderDisped(pogId)
	s returnFlag = ##class(web.DHCSTPIVAS.Common).IsOrderReturned(pogId)
	i (dispFlag="Y")&&(returnFlag'="Y") d
    ./// 判断是否打印停止签退药
    .s retOnPrt=##class(web.DHCSTPIVAS.Common).ExeRetOnPrt(recLocId)
	.i retOnPrt="Y" d
	..s reasonId=""
	..s exeRet=##class(web.DHCSTPIVAS.Return).ReturnByBarCode($replace(mOeore,"||","-"), userId, recLocId,reasonId,"","")
	..i $p(exeRet,"|$|",1)<0  s errCode=$replace(exeRet,"|$|","^")
	q:errCode'="" errCode
    &SQL(
    	UPDATE PIVA_OrdGrp SET POG_PCP_Dr=:cpId ,POG_CPNo=:cpNo WHERE POG_RowId=:pogId
    )
	q 0
}

/// description: 获取最后记录的停止签信息
/// w ##class(web.DHCSTPIVAS.StopPrint).GetCPrtJsonByPog(59)
ClassMethod GetCPrtJsonByPog(PogId)
{
	n (PogId)
	s retJson={}
	q:+PogId=0 retJson.%ToJSON()
	s cPrintId=$P(^PIVA(+PogId),"^",15)
	q:cPrintId="" retJson.%ToJSON()
	s cPrintDate=$P(^PIVACP(cPrintId),"^",3)
 	s cPrintTime=$P(^PIVACP(cPrintId),"^",4)
 	s cPrintDate=##class(web.DHCSTPIVAS.Common).DateShortFormat(cPrintDate)
 	s cPrtDateTime=cPrintDate_" "_$zt(cPrintTime,1)
 	s cUser= $P(^PIVACP(cPrintId),"^",2)
 	s cUserName=$p($g(^SSU("SSUSR",+cUser)),"^",2)
 	s retJson = {
		"cPrtDateTime": (cPrtDateTime),
		"cPrtUser": (cUserName)
	}
 	q retJson.%ToJSON()
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($this,"PIVA")
}

}
