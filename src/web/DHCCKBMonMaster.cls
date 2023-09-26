Class web.DHCCKBMonMaster Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Debug  w ##class(web.DHCCKBMonMaster).QueryMesterList("1","20","2023-02-27","2023-02-27")
ClassMethod QueryMesterList(page = 1, rows = 20, stdate = "", eddate = "", hosp = "")
{
	n (page,rows,stdate,eddate,hosp)

	s end=page*rows
	s start=(page-1)*rows+1
	;s:stdate'="" stdate=$zdh(stdate,3)
	;s:eddate'="" eddate=$zdh(eddate,3)
	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s eddate=##class(websys.Conversions).DateHtmlToLogical(eddate)
	s count=0
	w "{""rows"":["
	s date=""
	//创建日期 CMCreateDate 创建时间 CMCreateTime 创建人  CMCreateUser 
	//科室 CMLocDesc 审查结果 CMPassFlag 管理级别 CMManLevDr IP地址 CMIp
	
	;f  s date=$o(^CKB.PDSS.MonMasterI("CreateDate",date)) q:date=""  d
	;.q:date=""
	;.q:((stdate'="")&&(date<stdate))
	;.q:((eddate'="")&&(date>eddate))
	f i=stdate:1:eddate  d
	.s RowID="" f  s RowID=$o(^CKB.PDSS.MonMasterI("CreateDate",i,RowID)) q:RowID=""  d
	..q:RowID=""
	..s createHosp = $lg(^CKB.PDSS.MonMasterD(RowID),12)
	..q:(hosp'="")&&(hosp'=createHosp)
	..s MonData = $g(^CKB.PDSS.MonMasterD(RowID))
	..s CMCreateDate= $lg(MonData,3)
	..s:CMCreateDate'="" CMCreateDate=$zd(+CMCreateDate,3)
	..s CMCreateTime= $lg(MonData,4) 
	..s:CMCreateTime'="" CMCreateTime=$zt(+CMCreateTime,1)
	..s CMCreateUser= $p($lg(MonData,5),$c(5),1) ;$$lg(MonData,5)
	..s CMLocDesc=$p($lg(MonData,6),$c(5),1) ;$lg(MonData,6)
	..s CMPassFlag= $lg(MonData,7) 
	..s CMPassFlag = $case(CMPassFlag,"0":"不通过",:"通过")
	..s CMManLevDr= $lg(MonData,8)
	..s CMManLevDr = $case(CMManLevDr,"normal":"提示","tips":"提醒","warn":"警示","forbid":"禁止",:"正常")
	..s CMIp= $lg(MonData,11) 
	..s dataStr=RowID_"^"_CMIp_"^"_CMCreateDate_"^"_CMCreateTime_"^"_CMCreateUser_"^"_CMLocDesc_"^"_CMPassFlag_"^"_CMManLevDr
	..s titleStr="RowID^CMIp^CMCreateDate^CMCreateTime^CMCreateUser^CMLocDesc^CMPassFlag^CMManLevDr"
	..s count=count+1
	..q:(count<start)||(count>end)
	..w $case(count,start:"",:",")
	..w ##class(web.DHCAPPJsonCommon).getJsonData(titleStr,dataStr)
	w "],""total"":"_count_"}"
	q ""
}

/// Debug  w ##class(web.DHCCKBMonMaster).QueryMesterList(page, rows, query)
ClassMethod QueryCheckDetail(id)
{
	n (id)
	q:+id=0 ""
	s checkDetail= $lg(^CKB.PDSS.MonMasterD(id),9)
	w checkDetail
	q ""
}

/// Debug  w ##class(web.DHCCKBMonMaster).QueryMesterList(page, rows, query)
ClassMethod QueryCheckResult(id)
{
	n (id)
	q:+id=0 ""
	s checkResult= $lg(^CKB.PDSS.MonMasterD(id),10) 
	w checkResult
	q ""
}

/// Debug  w ##class(web.DHCCKBMonMaster).QueryMonQueList("1","20","19/05/2023","19/05/2023","","东华标准版数字化医院[总院]")
ClassMethod QueryMonQueList(page, rows, stdate = "", eddate = "", library = "", hosp = "")
{
	n (page,rows,stdate,eddate,library,hosp)
	
	s end=page*rows
	s start=(page-1)*rows+1
	
	;s:stdate'="" stdate=$zdh(stdate,3)
	;s:eddate'="" eddate=$zdh(eddate,3)
	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s eddate=##class(websys.Conversions).DateHtmlToLogical(eddate)

	s count=0
	w "{""rows"":["
	s date=""
	//创建日期 CMCreateDate 创建时间 CMCreateTime 创建人  CMCreateUser 
	//科室 CMLocDesc 审查结果 CMPassFlag 管理级别 CMManLevDr IP地址 CMIp
		
	f i=stdate:1:eddate  d
	.s parref="" f  s parref=$o(^CKB.PDSS.MonMasterI("CreateDate",i,parref)) q:parref=""  d
	..q:parref=""
	..s createHosp = $lg(^CKB.PDSS.MonMasterD(parref),12)
	..q:(hosp'="")&&(hosp'=createHosp)
	..
	..;s parref="" f  s parref=$o(^CKB.PDSS.MonQueListI("Parref",parref)) q:parref=""  d
	..;q:parref=""
	..s RowID="" f  s RowID=$o(^CKB.PDSS.MonQueListI("Parref",parref,RowID)) q:RowID=""  d
	...q:RowID=""
	...s MqlData = $g(^CKB.PDSS.MonQueListD(RowID))
	...s CMParrfDr= $lg(MqlData,2)
	...s CMItemDr=$lg(MqlData,3)
	...s:CMItemDr'="" CMItemDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(CMItemDr)),3)
	...s CMProDr=$lg(MqlData,4)
	...s CMProCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+CMProDr)),3)		// 目录
	...s:CMProDr'="" CMProDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(CMProDr)),3)
	...q:(library'="")&(library'=CMProCode)
	...s CMFunDr=$lg(MqlData,5)
	...s:CMFunDr'="" CMFunDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(CMFunDr)),3)
	...s CMTipsMsg=$lg(MqlData,6)
	...s CMManLevDr=$lg(MqlData,7)
	...s:CMManLevDr'="" CMManLevDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(CMManLevDr)),3)
	...s CMOrderDr=$lg(MqlData,8)
	...s dataStr=RowID_"^"_CMParrfDr_"^"_CMItemDr_"^"_CMProDr_"^"_CMFunDr_"^"_CMTipsMsg_"^"_CMManLevDr_"^"_CMOrderDr
	...s titleStr="RowID^CMParrfDr^CMItemDr^CMProDr^CMFunDr^CMTipsMsg^CMManLevDr^CMOrderDr"
	...s count=count+1
	...q:(count<start)||(count>end)
	...w $case(count,start:"",:",")
	...w ##class(web.DHCAPPJsonCommon).getJsonData(titleStr,dataStr)

	w "],""total"":"_count_"}"
	q ""
}

}
