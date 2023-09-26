Import sqluser

/// creator: 	QianHuanjuan
/// createdate:	2018-05-29
/// description:处方点评不合理查询
Class web.DHCSTCNTS.FindForDoctor Extends %RegisteredObject
{

/// description: 点评不合理查询医嘱(仅输出)
/// w ##class(web.DHCSTCNTS.FindForDoctor).JsGetOrdDataForDoctor("50","0","2018-07-16^2018-07-16^4634^0")
ClassMethod JsGetOrdDataForDoctor(rows, page, inputStr = "")
{
	s ^TMPDHCSTPARAMS("web.DHCSTCNTS.FindForDoctor","JsGetOrdDataForDoctor")=$lb(rows,page, inputStr)
	i +page=0 s page=1
	s collRet=..GetOrdDataForDoctor(rows,page, inputStr)
	s pid=$p(collRet,"^",1)
	s total=$p(collRet,"^",2)
	q:(pid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s title1="oeoriDateTime^incDesc^qty^uomDesc^dosage"
	s title2="instrucDesc^freqDesc^duraDesc^spec^priDesc"
	s title3="docName^remark^mOeori^oeoriSign"
	s title=title1_"^"_title2_"^"_title3
	s outputI="",count=0
	f  s outputI=$o(^TMP("DHCST",$ClassName(),"GetOrdDataForDoctor",pid,outputI)) q:outputI=""  d
	.q:+outputI=0
	.s ordNum=^TMP("DHCST",$ClassName(),"GetOrdDataForDoctor","OrdNum",pid,outputI)
	.s ouputJ="",oeoriNum=0
	.f  s ouputJ=$o(^TMP("DHCST",$ClassName(),"GetOrdDataForDoctor",pid,outputI,ouputJ)) q:ouputJ=""  d
	..q:+outputI=0
	..s outputData=^TMP("DHCST",$ClassName(),"GetOrdDataForDoctor",pid,outputI,ouputJ)
	..s oeoriNum=oeoriNum+1
	..s oeoriSign=""
	..i oeoriNum'=1 d
	...s oeoriSign="0"
	..i oeoriNum=1 s oeoriSign="-1"
	..i oeoriNum=ordNum s oeoriSign="1"
	..i ordNum=1 s oeoriSign=""
	..s $p(outputData,"^",14)=oeoriSign
	..s count=count+1
	..i count=1 d
	...w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	...w ##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	..e  d
	...w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	i count>0   w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	k ^TMP("DHCST",$ClassName(),"GetOrdDataForDoctor",pid)
	k ^TMP("DHCST",$ClassName(),"GetOrdDataForDoctor","OrdNum",pid)
	q ""
}

/// description: 点评不合理查询(取明细数据)
/// w ##class(web.DHCSTCNTS.FindForDoctor).GetOrdDataForDoctor("50","1","28/05/2016^28/05/2018^298")
ClassMethod GetOrdDataForDoctor(rows, page, inputStr)
{
	s pid=..CollectOrdDataForDoctor(inputStr)
	q:pid="" ""
	s EndRow=page*rows  
	s StartRow=((page-1)*rows)+1 
	s recordCnt=0,total=0
	s sortIndex=""
	f  s sortIndex=$o(^TMP("DHCST",$ClassName(),"CollectOrdDataForDoctor",pid,sortIndex)) q:sortIndex=""  d
	.s ctablId=""
	.//f  s ctablId=$o(^TMP("DHCST",$ClassName(),"CollectOrdDataForDoctor",pid,sortIndex,ctablId)) q:ctablId=""  d
	.//一个点评单中一组医嘱仅显示一次 modified by MaYuqiang 20180806
	.s ctablId=$o(^TMP("DHCST",$ClassName(),"CollectOrdDataForDoctor",pid,sortIndex,ctablId),-1)
	.i ctablId'="" d
	..// 主信息
	..s recordCnt=recordCnt+1
	..s total=total+1
	..q:total<StartRow
    ..q:total>EndRow
    ..s mOeori=$p(^DHCPCTABL(ctablId),"^",3)
    ..s mOrd=+mOeori,mOrdItm=$p(mOeori,"||",2)
    ..s prescNo=$p($g(^OEORD(mOrd,"I",mOrdItm,1)),"^",14)
    ..s logRowId=$p(^DHCPCTABL(ctablId),"^",2)
    ..s logId=$p(logRowId,"||",1)
	..s logChl=$p(logRowId,"||",2)
	..s logSub=$p(logRowId,"||",3)
	..s admId=$p(^OEORD(mOrd),"^",1)
	..s admType=$p($g(^PAADM(admId)),"^",2)
	..i admType="I" d
	...// 住院按关联医嘱
	...s oeori=mOeori
	...d GetOeoriData
	...s ordItm=""
	...f  s ordItm=$o(^OEORDi(0,"OEORI",mOrd,mOeori,ordItm)) q:ordItm=""  d
	....q:+ordItm=0
	....s oeori=ordId_"||"_ordItm
	....d GetOeoriData
	..e  d
	...// 门诊按处方
	...s ordItm=""
	...f  s ordItm=$o(^OEORD(0,"PrescNo",prescNo,mOrd,ordItm)) q:ordItm=""  d
	....s oeori=mOrd_"||"_ordItm
	....d GetOeoriData
	k ^TMP("DHCST",$ClassName(),"CollectOrdDataForDoctor",pid)
	q pid_"^"_recordCnt
GetOeoriData
	s ordId=+oeori,ordItmId=$p(oeori,"||",2)
	s arcItmId=$p($g(^OEORD(ordId,"I",ordItmId,1)),"^",2)
	q:arcItmId=""
	s arcSub=+$p(arcItmId,"||",1)
	s arcVer=+$p(arcItmId,"||",2)
	s arcItmCatId=$p($g(^ARCIM(arcSub,arcVer,1)),"^",10)
	q:$P(^ARC("IC",+arcItmCatId),"^",7)'="R"
	s incId=$o(^INCI(0,"ARCIM_DR",arcSub,"") ) 
	q:incId="" 
	s incDesc=$p(^INCI(incId,1),"^",2)
	s arcItmDesc=$p(^ARCIM(arcSub,arcVer,1),"^",2)
	s incDesc=arcItmDesc
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	q:dspId=""
	s qty=$p(^DHCOEDISQTY(dspId),"^",2)
	// 医嘱改造,打包表数量为药学基本单位数量
    s uomDesc=""
    s phcdfId=$p(^ARCIM(arcSub,arcVer,1),"^",12)
    i phcdfId'="" d
    .s uomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
    .s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2) 
	s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(oeori)
	s freqDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(oeori),"^",4)
	s instrucDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriInstruc(oeori),"^",2)
	s duraDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriDuration(oeori),"^",2)
	s priDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriPriority(oeori),"^",3)
	s docName=$p(##class(web.DHCSTCOMMONORDER).OeoriDoctor(oeori),"^",2)
	s skinTest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(oeori)  ;皮试
	s incDesc=skinTest_incDesc
	s spec="" //##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",incId)
	s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(oeori)
	s oeoriDateTime=##class(web.DHCSTCOMMONORDER).OeoriDateTime(oeori)
	s oeoriSign=""
    s data1=oeoriDateTime_"^"_incDesc_"^"_qty_"^"_uomDesc_"^"_dosage
    s data2=instrucDesc_"^"_freqDesc_"^"_duraDesc_"^"_spec_"^"_priDesc
    s data3=docName_"^"_remark_"^"_mOeori_"^"_oeoriSign
	s data=data1_"^"_data2_"^"_data3
	s ^TMP("DHCST",$ClassName(),"GetOrdDataForDoctor",pid,recordCnt,oeori)=data
	s ^TMP("DHCST",$ClassName(),"GetOrdDataForDoctor","OrdNum",pid,recordCnt)=1+$g(^TMP("DHCST",$ClassName(),"GetOrdDataForDoctor","OrdNum",pid,recordCnt))	
	q
}

/// description:  不合理处方查询(匹配条件)
/// input : 	 开始日期^结束日期^开医嘱医生Id
/// w ##class(web.DHCSTCNTS.FindForDoctor).CollectOrdDataForDoctor("01/05/2013^25/05/2018^298")
ClassMethod CollectOrdDataForDoctor(inputStr) As %String
{
	s StDate=$p(inputStr,"^",1)
	s EdDate=$p(inputStr,"^",2)
	s DoctorId=$p(inputStr,"^",3)
	q:DoctorId="" ""
	s ComResult=$p(inputStr,"^",4)
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate) 
	s EdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EdDate)
	s pid=..NewPid()
	f calcuDate=StDate:1:EdDate d
    .s ctablId=""
	.f  s ctablId=$o(^DHCPCTABL(0,"Doctor",DoctorId,calcuDate,ctablId)) q:ctablId=""  d
	..q:+ctablId=0
    ..s oeori=$p(^DHCPCTABL(ctablId),"^",1)
    ..s logRowId=$p(^DHCPCTABL(ctablId),"^",2)
    ..s logId=+$p(logRowId,"||",1)
	..s logChl=+$p(logRowId,"||",2)
	..s logSub=+$p(logRowId,"||",3)
	..q:'$d(^DHCPHCNTS(logId,"I",logChl,"L",logSub))
	..s curRet=$p(^DHCPHCNTS(logId,"I",logChl),"^",6)
	..q:curRet="Y" // 合格不显示
	..s active=$p(^DHCPHCNTS(logId,"I",logChl,"L",logSub),"^",11)
	..q:active'="Y"
	..s docNotes=$p(^DHCPHCNTS(logId,"I",logChl,"L",logSub),"^",10)
	..s finalResult=""
	..i (curRet="N")&&(docNotes="Accept") s finalResult=1
	..i (curRet="N")&&(docNotes'="Accept") s finalResult=2
	..i (curRet="N")&&(docNotes="") s finalResult=0
	..q:ComResult'=finalResult
	..s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	..q:dspId=""
	..// 排序用
	..//s sortIndex=ctablId
	..s moeori=$p(^DHCPCTABL(ctablId),"^",3)
	..s sortIndex=logId_","_moeori	// add by MaYuqiang 一张点评单中的同一组医嘱仅显示一次
	..s ^TMP("DHCST",$ClassName(),"CollectOrdDataForDoctor",pid,sortIndex,ctablId)=""
	q pid
}

/// description: 查询不合理原因(仅输出),不分页
/// w ##class(web.DHCSTCNTS.FindForDoctor).JsGetLogForDoctor("50","1","2647||3")
ClassMethod JsGetLogForDoctor(rows, page, inputStr = "")
{
	i +page=0 s page=1
	s ^TMPDHCSTPARAMS("web.DHCSTCNTS.FindForDoctor","JsGetLogForDoctor")=$lb(rows,page, inputStr)
	s EndRow=page*rows  
	s StartRow=((page-1)*rows)+1 
	s collRet=..GetLogForDoctor(rows,page, inputStr)
	s pid=$p(collRet,"^",1)
	s total=$p(collRet,"^",2)
	q:(pid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s title1="comDate^comTime^comUserName^comResult^comReasonDesc"
	s title2="comFactorDesc^comAdviceDesc^docAdviceDesc^comPhNotes^comDocNotes"
	s title3="comActive^comReaGrpNo^logRowId"
	s title=title1_"^"_title2_"^"_title3
	s outputI="",count=0
	f  s outputI=$o(^TMP("DHCST",$ClassName(),"GetLogForDoctor",pid,outputI)) q:outputI=""  d
	.s outputData=^TMP("DHCST",$ClassName(),"GetLogForDoctor",pid,outputI)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
	i count>0   w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	k ^TMP("DHCST",$ClassName(),"GetLogForDoctor",pid)
	k ^TMP("DHCST",$ClassName(),"GetLogForDoctor","GrpNo",pid)
	k ^TMP("DHCST",$ClassName(),"GetLogForDoctor","OrdItem",pid)
	q ""
}

/// description:查询不合理原因
/// input:		主医嘱Id
/// w ##class(web.DHCSTCNTS.FindForDoctor).GetLogForDoctor("50","1","1102||4")
ClassMethod GetLogForDoctor(rows, page, inputStr) As %String
{
	s oeori=$p(inputStr,"^",1)
    q:oeori="" ""
    s recordCnt=0
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s ordId=+oeori
	s prescNo=$p($g(^OEORD(ordId,"I",+$p(oeori,"||",2),1)),"^",14)
	//门诊,仅门诊有该索引
	s pcntsId=""
	f  s pcntsId=$o(^DHCPHCNTS(0,"OrdItem",oeori,pcntsId)) q:pcntsId=""  d
	.s pcntsItm=""
	.f  s pcntsItm=$o(^DHCPHCNTS(0,"OrdItem",oeori,pcntsId,pcntsItm)) q:pcntsItm=""  d
	..s admId=$p(^DHCPHCNTS(pcntsId,"I",pcntsItm),"^",3)
	..s pcntsLog=""
	..f  s pcntsLog=$o(^DHCPHCNTS(pcntsId,"I",pcntsItm,"L",pcntsLog),-1) q:pcntsLog=""  d
	...s logRowId=pcntsId_"||"_pcntsItm_"||"_pcntsLog
	...d GetCntsLogData
    //住院
    s mOeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(oeori)
    s mOrd=+mOeori
    s oeoriStr=mOeori
    s ordItm=""
 	f  s ordItm=$O(^OEORDi(0,"OEORI",mOrd,mOeori,ordItm)) q:ordItm=""  d
 	.q:+ordItm=0
 	.s oeoriStr=oeoriStr_"^"_mOrd_"||"_ordItm
 	q:recordCnt>0 pid_"^"_recordCnt
 	s oeoriCnt=$l(oeoriStr,"^")
 	s ordI=""
 	f ordI=1:1:oeoriCnt d
    .s oeori=$p(oeoriStr,"^",ordI)
    .q:oeori=""
	.s logRowId=""
	.f  s logRowId=$o(^DHCPCTABL(0,"OrdItm",oeori,logRowId),-1) q:logRowId=""  d
	..q:+logRowId=0 
	..s logId=$p(logRowId,"||",1)
	..s logChl=$p(logRowId,"||",2)
	..s logSub=$p(logRowId,"||",3)
	..q:'$d(^DHCPHCNTS(logId,"I",logChl,"L",logSub))
	..s comGrpNo=$p(^DHCPHCNTS(logId,"I",logChl,"L",logSub),"^",12)
	..s ^TMP("DHCST",$ClassName(),"GetLogForDoctor","GrpNo",pid,comGrpNo)=logRowId
	s comReaGrpNo=""
	f  s comReaGrpNo=$o(^TMP("DHCST",$ClassName(),"GetLogForDoctor","GrpNo",pid,comReaGrpNo),-1) q:comReaGrpNo=""  d
	.s tmpLogRowId=^TMP("DHCST",$ClassName(),"GetLogForDoctor","GrpNo",pid,comGrpNo)
	.s tmpLogId=+tmpLogRowId,tmpLogChl=$p(tmpLogRowId,"||",2)
	.s tmpLogSub=""
	.f  s tmpLogSub=$o(^DHCPHCNTS(tmpLogId,"I",tmpLogChl,"L",tmpLogSub),-1) q:tmpLogSub=""  d
	..q:+tmpLogSub=0
	..s logRowId=tmpLogId_"||"_tmpLogChl_"||"_tmpLogSub
	..s tmpGrpNo=$p(^DHCPHCNTS(tmpLogId,"I",tmpLogChl,"L",tmpLogSub),"^",12)
	..q:'$d(^TMP("DHCST",$ClassName(),"GetLogForDoctor","GrpNo",pid,tmpGrpNo))
	..d GetCntsLogData
	q pid_"^"_recordCnt
GetCntsLogData
	s logId=+logRowId,logChl=$p(logRowId,"||",2),logSub=$p(logRowId,"||",3)
	s logData=^DHCPHCNTS(logId,"I",logChl,"L",logSub)
	q:logData=""
	s comResult=$p(logData,"^",2)
	s pctblId=$o(^DHCPCTABL(0,"LOG",logRowId,""))
	q:(pctblId="")&&(comResult="N")								// 不合理的点评记录只显示和禁忌表关联的那一条
	s comResult=$s(comResult="Y":"合格",1:"不合格")				// 点评结果
	s comDate=$p(logData,"^",3)									// 点评日期
	s comTime=$p(logData,"^",4)									// 点评时间
	s comUserId=$p(logData,"^",5)
	s comUserName=$p($g(^SSU("SSUSR",+comUserId)),"^",2)		// 点评人
	s comReasonDesc=##class(web.DHCSTCNTSMAIN).GetOPCommentReason(logRowId,"","</br>")	// 点评原因
	s comFactor=$p(logData,"^",8)
	s comFactorDesc=$p($g(^DHCPCFACTOR(+comFactor)),"^",2)		// 警示值
	s comAdviceId=$p(logData,"^",6)
	s comAdviceDesc=$p($g(^DHCPCADVICE(+comAdviceId)),"^",2)	// 药师建议
	s docAdviceDesc=$p(logData,"^",7) 							// 医生建议
	s comPhNotes=$p(logData,"^",9) 								// 药师备注
	s comDocNotes=$p(logData,"^",10) 							// 医师备注
	s comActive=$p(logData,"^",11)								// 激活标志
	s comReaGrpNo=$p(logData,"^",12)							// 原因组号
	s comDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(comDate)
	s comTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(comTime)
	s comData1=comDate_"^"_comTime_"^"_comUserName_"^"_comResult_"^"_comReasonDesc
	s comData2=comFactorDesc_"^"_comAdviceDesc_"^"_docAdviceDesc_"^"_comPhNotes_"^"_comDocNotes
	s comData3=comActive_"^"_comReaGrpNo_"^"_logRowId
	s comData=comData1_"^"_comData2_"^"_comData3
	s recordCnt=recordCnt+1
	s ^TMP("DHCST",$ClassName(),"GetLogForDoctor",pid,recordCnt)=comData  // 一次评审
	// 药品禁忌表
	s pctblId=""
	f  s pctblId=$o(^DHCPCTABL(0,"LOG",logRowId,pctblId)) q:pctblId=""  d 
	.s pctblOeori=$p(^DHCPCTABL(pctblId),"^",1)
	.s arcItmId=$p(^OEORD(+pctblOeori,"I",+$p(pctblOeori,"||",2),1),"^",2)
	.s arcSub=$p(arcItmId,"||",1)
	.s arcVer=$p(arcItmId,"||",2)
	.s incId=$o(^INCI(0,"ARCIM_DR",+arcSub,"") ) 
	.q:incId=""
	.s arcItmDesc=$p(^ARCIM(arcSub,arcVer,1),"^",2)
	.s incDesc=arcItmDesc //$p(^INCI(incId,1),"^",2) // 药品名称
	.s incDesc="____"_incDesc
	.s recordCnt=recordCnt+1
	.s $p(comBData,"^",$l(comData,"^"))=""
	.s $p(comBData,"^",5)=incDesc
	.s $p(comBData,"^",11)=""	//$p(comData,"^",11)	// modified by MaYuqiang 医嘱对应的激活状态应该为空
	.s $p(comBData,"^",13)=$p(comData,"^",13)
    .s ^TMP("DHCST",$ClassName(),"GetLogForDoctor",pid,recordCnt)=comBData
    .s ^TMP("DHCST",$ClassName(),"GetLogForDoctor","OrdItem",pid,pctblOeori)=""
  	q
}

/// 提交保存医生申诉备注
/// w ##class(web.DHCSTCNTSMAIN).SaveDocAdvice("1765||1||2^Accept")
ClassMethod SaveDocAdvice(inputStr) As %String
{
	s logRowId=$p(inputStr,"^",1)
	s docNote=$p(inputStr,"^",2)
	q:logRowId="" "-1^获取不到记录Id"
	s chkResult=..CheckComResult(logRowId)
	q:+$p(chkResult,"^",1)<0 chkResult
	&sql(update DHC_PHCOMMENTSLOG set PCNTSL_DocNote=:docNote where PCNTSL_RowID=:logRowId)
	i SQLCODE="-105" q "-1^更新状态失败，申诉内容超长(不能超过100个汉字)"
	q:SQLCODE'=0 "-1^更新状态失败，SQLCODE："_SQLCODE
	s pctOeori=""
	s pctblRowId=$o(^DHCPCTABL(0,"LOG",logRowId,""))	 //DHC_PHCNTSTABOOLIST
	s:pctblRowId'="" pctOeori=$p(^DHCPCTABL(pctblRowId),"^",1)
	s:+$p(pctOeori,"||",2)'="" sendArcItm=$p(^OEORD(+pctOeori,"I",$p(pctOeori,"||",2),1),"^",2)	//医嘱项id
	s ConText="医生申诉:"_$p(^ARCIM(+sendArcItm,$p(sendArcItm,"||",2),1),"^",2)_","_docNote
	s ret1=##class(web.DHCSTInterfaceMessage).SendCommentResult(logRowId,"Exec",pctOeori,ConText)
	s ret2=##class(web.DHCSTInterfaceMessage).SendAppealComment(logRowId,"Send",pctOeori,ConText)	
	q 0
}

/// description: 当前点评状态
ClassMethod CheckComResult(logRowId)
{
	s logData=$g(^DHCPHCNTS(+logRowId,"I",$p(logRowId,"||",2),"L",$p(logRowId,"||",3)))
	q:logData="" ""
	q:$p($g(^DHCPHCNTS(+logRowId,"I",$p(logRowId,"||",2))),"^",6)="Y" "-1^当前状态为合格"
	s active=$p(logData,"^",11)
	q:active'="Y" "-1^原因记录无效"
	s docNotes=$p(logData,"^",10)
	q:$zcvt(docNotes,"U")="ACCEPT" "-1^当前状态为接受"
	q:$zcvt(docNotes,"U")'="" "-1^当前状态为申诉"
	q ""
}

/// description: 进程号
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid("web.DHCSTCNTS.FindForDoctor","CNT")
}

}
