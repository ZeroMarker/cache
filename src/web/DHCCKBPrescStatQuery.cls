Class web.DHCCKBPrescStatQuery Extends %RegisteredObject
{

/// Creator:xww
/// Date:2021-11-04
/// 
/// Debug  w ##class(web.DHCCKBPrescStatQuery).QueryMesterState("1","30","2022-03-30","2022-03-30","^^N^N^N","","")
ClassMethod QueryMesterState(page, rows, params = "", sort = "", order = "")
{
	s ^temptest("31233")=$lb(page,rows,params,sort,order)
	s stdate = $p(params,"^",1)
	s eddate = $p(params,"^",2)
	s HospID = $p(params,"^",3)
	S pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","QueryMesterList",pid)
	k ^TMP("DHCCKB","QueryOrd",pid)
	s end=page*rows
	s start=(page-1)*rows+1
	s:stdate'="" stdate=$zdh(stdate,3)
	s:eddate'="" eddate=$zdh(eddate,3)
	s totalNum=0,errorNum=0,hospNum=0
	s count=0
	s audNum = 0,audErrNum = 0,totenanum = 0,tottipsnum = 0, totwarnum = 0,totfornum = 0
	
	//审查数据
	d ##class(web.DHCCKBPrescStatQuery).QueryAudRiskData(pid,stdate,eddate,HospID,.totalNum,.errorNum,.hospNum,.audNum,.audErrNum,.totenanum,.tottipsnum,.totwarnum,.totfornum,1)
	
	s:sort="" sort="date"
	s ord = $s(order="desc":"-1",order="":"-1",1:1)
	///组织排序节点
	s count = 0
	s index = ""
	for  s index = $o(^TMP("DHCCKB","QueryMesterList",pid,index))  Q:index=""  d
	.s ordAudNum = $p(^TMP("DHCCKB","QueryMesterList",pid,index),"^",1)
	.s ordErrNum = $p(^TMP("DHCCKB","QueryMesterList",pid,index),"^",2)
	.s ordEnaNum = $p(^TMP("DHCCKB","QueryMesterList",pid,index),"^",3)
	.s ordTipNum = $p(^TMP("DHCCKB","QueryMesterList",pid,index),"^",4)
	.s ordWarnNum = $p(^TMP("DHCCKB","QueryMesterList",pid,index),"^",5)
	.s ordForNum = $p(^TMP("DHCCKB","QueryMesterList",pid,index),"^",6)
	.s ordRate = 0
	.s count = count+1
	.i ordAudNum'="0"  d
	..s ordRate = $fn(ordErrNum/ordAudNum*100,"",2)
	.i sort="auditNum"  d
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,ordAudNum,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	.i sort="errNum"  d
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,ordErrNum,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	.i sort="errRate"  d
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,+ordRate,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	.i sort="ordEnaNum"  d
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,ordEnaNum,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	.i sort="ordTipNum"  d
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,ordTipNum,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	.i sort="ordWarnNum"  d
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,ordWarnNum,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	.i sort="ordForNum"  d
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,ordForNum,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	.i sort="date" d
	..s ordDate=$p(index,"^",1)
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,ordDate,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	
	s hospDesc = ""
	i HospID'="" d
	.s hospDesc = $p(^CT("HOSP",HospID),"^",2)
	s areaPoint = "全部"
	s totrate = "0.00%"
	
	i audErrNum'=0  d
	.s totrate = $fn(audErrNum/audNum*100,"",2)_"%"
	w "{""rows"":["
	w "{"
	s count=1
	s titleStr="auditNum^errNum^hosptialNum^date^errRate^ordEnaNum^ordTipNum^ordWarnNum^ordForNum"
	w """auditNum"":"_audNum_",""errNum"":"_audErrNum_",""hosptialNum"":""合计"",""date"":"""",""errRate"":"""_totrate_""",""ordEnaNum"":"""_totenanum_""",""ordTipNum"":"""_tottipsnum_""",""ordWarnNum"":"""_totwarnum_""",""ordForNum"":"""_totfornum_"""}"
	s outidnex = ""
	f  s outidnex = $o(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex),ord) q:outidnex=""  d
	.s ordindex = ""
	.for  s ordindex = $o(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex))  Q:ordindex=""  d
	..s auditNum = +$p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",1)
	..s errNum = +$p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",2)
	..s ordEnaNum = +$p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",3)
	..s ordTipNum = +$p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",4)
	..s ordWarnNum = +$p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",5)
	..s ordForNum = +$p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",6)
	..s errRate = $p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",7)_"%"
	..s date =$zd(+$p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",8),3)
	..s HospCode = $p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",9)
	..s HospDesc=""
	..s inHospId = $o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(HospCode),""))
	..i inHospId'="" d
	...s HospDesc=$p(^CT("HOSP",inHospId),"^",2)
	..s dataStr=auditNum_"^"_errNum_"^"_HospDesc_"^"_date_"^"_errRate_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum
	..s count=count+1
	..q:(count<start)||(count>end)
	..w:count>1 ","
	..w ##class(web.DHCEMJsonCommon).getJsonData(titleStr,dataStr)
	s count=count-1
	w "],""total"":"_count_"}"
	k ^TMP("DHCCKB","QueryMesterList",pid)
	k ^TMP("DHCCKB","QueryOrd",pid)
	q ""
}

/// Descript:安全用药审查统计查询	
/// Creator:huanghongping
/// CreateDate:2021-12-28
/// Input:分页、日期、排序变量
/// Output:查询结果
/// "1","30","2021-12-28","2021-12-29","^^N","",""
/// Debug  w ##class(web.DHCCKBPrescStatQuery).QueryMesSummary("1","30","2022-06-01^2022-06-29^","","")
ClassMethod QueryMesSummary(page, rows, params = "", sort = "", order = "")
{
	s ^temptest("31233")=$lb(page,rows,params,sort,order)
	s stdate = $p(params,"^",1)
	s eddate = $p(params,"^",2)
	s HospID = $p(params,"^",3)
	S pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","QueryMesterList",pid)
	k ^TMP("DHCCKB","QueryOrd",pid)
	
	s end=page*rows
	s start=(page-1)*rows+1
	s:stdate=eddate dateStr=stdate
	s:stdate'=eddate dateStr=stdate_"~"_eddate
	s:stdate'="" stdate=$zdh(stdate,3)
	s:eddate'="" eddate=$zdh(eddate,3)
	s totalNum=0,errorNum=0,hospNum=0
	s count=0
	s audNum = 0,audErrNum = 0,totenanum = 0,tottipsnum = 0, totwarnum = 0,totfornum = 0
	
	d ##class(web.DHCCKBPrescStatQuery).QueryAudRiskData(pid,stdate,eddate,HospID,.totalNum,.errorNum,.hospNum,.audNum,.audErrNum,.totenanum,.tottipsnum,.totwarnum,.totfornum)
	
	s:sort="" sort="errNum"
	s ord = $s(order="desc":"-1",order="":"-1",1:1)
	///组织排序节点
	s count = 0
	s index = ""
	for  s index = $o(^TMP("DHCCKB","QueryMesterList",pid,index))  Q:index=""  d
	.s ordAudNum = $p(^TMP("DHCCKB","QueryMesterList",pid,index),"^",1)
	.s ordErrNum = $p(^TMP("DHCCKB","QueryMesterList",pid,index),"^",2)
	.s ordEnaNum = $p(^TMP("DHCCKB","QueryMesterList",pid,index),"^",3)
	.s ordTipNum = $p(^TMP("DHCCKB","QueryMesterList",pid,index),"^",4)
	.s ordWarnNum = $p(^TMP("DHCCKB","QueryMesterList",pid,index),"^",5)
	.s ordForNum = $p(^TMP("DHCCKB","QueryMesterList",pid,index),"^",6)
	.s ordRate = 0
	.s count = count+1
	.i ordAudNum'="0"  d
	..s ordRate = $fn(ordErrNum/ordAudNum*100,"",2)
	.i sort="auditNum"  d
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,ordAudNum,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	.i sort="errNum"  d
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,ordErrNum,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	.i sort="errRate"  d
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,+ordRate,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	.i sort="ordEnaNum"  d
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,ordEnaNum,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	.i sort="ordTipNum"  d
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,ordTipNum,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	.i sort="ordWarnNum"  d
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,ordWarnNum,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	.i sort="ordForNum"  d
	..s ^TMP("DHCCKB","QueryOrd",pid,sort,ordForNum,count) = ordAudNum_"^"_ordErrNum_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum_"^"_ordRate_"^"_index
	
	s hospDesc = ""
	i HospID'="" d
	.s hospDesc = $p(^CT("HOSP",HospID),"^",2)
	
	s totrate = "0.00%"
	i audErrNum'=0  d
	.s totrate = $fn(audErrNum/audNum*100,"",2)_"%"
	
	w "{""rows"":["
	w "{"
	s count=1
	s titleStr="auditNum^errNum^hosptialNum^date^errRate^ordEnaNum^ordTipNum^ordWarnNum^ordForNum"
	w """auditNum"":"_audNum_",""errNum"":"_audErrNum_",""hosptialNum"":""合计"",""date"":"""",""errRate"":"""_totrate_""",""ordEnaNum"":"""_totenanum_""",""ordTipNum"":"""_tottipsnum_""",""ordWarnNum"":"""_totwarnum_""",""ordForNum"":"""_totfornum_"""}"
	s outidnex = ""
	f  s outidnex = $o(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex),ord) q:outidnex=""  d
	.s ordindex = ""
	.for  s ordindex = $o(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex))  Q:ordindex=""  d
	..s auditNum = +$p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",1)
	..s errNum = +$p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",2)
	..s ordEnaNum = +$p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",3)
	..s ordTipNum = +$p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",4)
	..s ordWarnNum = +$p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",5)
	..s ordForNum = +$p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",6)
	..s errRate = $p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",7)_"%"
	..s date =dateStr
	..s HospCode = $p(^TMP("DHCCKB","QueryOrd",pid,sort,outidnex,ordindex),"^",8)
	..s HospDesc=""
	..s inHospId = $o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(HospCode),""))
	..i inHospId'="" d
	...s HospDesc=$p(^CT("HOSP",inHospId),"^",2)
	..s dataStr=auditNum_"^"_errNum_"^"_HospDesc_"^"_date_"^"_errRate_"^"_ordEnaNum_"^"_ordTipNum_"^"_ordWarnNum_"^"_ordForNum
	..s count=count+1
	..q:(count<start)||(count>end)
	..w:count>1 ","
	..w ##class(web.DHCEMJsonCommon).getJsonData(titleStr,dataStr)
	s count=count-1
	w "],""total"":"_count_"}"
	k ^TMP("DHCCKB","QueryMesterList",pid)
	k ^TMP("DHCCKB","QueryOrd",pid)
	q ""
}

/// Creator:sufan
/// Descript:获取审查的安全用药数据
/// Input：日期
/// w ##class(web.DHCCKBMonMaster).QueryAudRiskData(64304,66207,66207,"^^N^N",0,0,0,0,0,0,0,0,0)
ClassMethod QueryAudRiskData(pid, stdate, eddate, HospID, totalNum, errorNum, hospNum, audNum, audErrNum, totenanum, tottipsnum, totwarnum, totfornum, flag = "")
{
	s ^temptest("ss22") = $lb(pid,stdate,eddate,HospID, totalNum, errorNum, hospNum, audNum, audErrNum, totenanum, tottipsnum, totwarnum, totfornum)
	s date=""
	f i=stdate:1:eddate  d
	.s RowID="" 
	.for  s RowID=$o(^CKB.PDSS.MonMasterI("CreateDate",i,RowID)) q:RowID=""  d
	..q:RowID=""
	..s stiauditNum = 0,stierrNum = 0,enablenum = 0,tipsnum = 0, warnnum = 0,forbidnum = 0
	..s monData = $g(^CKB.PDSS.MonMasterD(RowID))	
	..s HospDesc=$lg(monData,12)
	..s hospId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HospDesc),""))
	..q:hospId=""
	..q:(HospID'="")&&(HospID'=hospId)
	..s HospCode = $p($g(^CT("HOSP",hospId)),"^",1)
	..s CMCreateDate= $lg(monData,3)
	..s CMPassFlag= $lg(monData,7)
	..s audNum = audNum+1
	..s stiauditNum = stiauditNum + 1
	..s levCode = $lg(monData,8) 
	..i (levCode="")||(levCode="enable") d
	...s enablenum  = enablenum + 1 
	...s totenanum = totenanum + 1
	..i levCode="tips"  d
	...s tipsnum  = tipsnum + 1
	...s tottipsnum = tottipsnum + 1
	..i levCode="warn"  d
	...s warnnum  = warnnum + 1
	...s totwarnum = totwarnum + 1
	..i levCode="forbid"  d
	...s forbidnum  = forbidnum + 1
	...s totfornum = totfornum + 1
	..i CMPassFlag=0   d
	...s audErrNum = audErrNum+1
	...s stierrNum = stierrNum+1
	..i flag = 1  d
	...s staindex = i_"^"_HospCode
	..e  d
	...s staindex = HospCode
	..s listData = stiauditNum_"^"_stierrNum_"^"_enablenum_"^"_tipsnum_"^"_warnnum_"^"_forbidnum
	..i '$d(^TMP("DHCCKB","QueryMesterList",pid,staindex)) d	
	...s ^TMP("DHCCKB","QueryMesterList",pid,staindex) = listData
	..e  d
	...s $p(^TMP("DHCCKB","QueryMesterList",pid,staindex),"^",1) = $p(^TMP("DHCCKB","QueryMesterList",pid,staindex),"^",1) + stiauditNum
	...s $p(^TMP("DHCCKB","QueryMesterList",pid,staindex),"^",2) = $p(^TMP("DHCCKB","QueryMesterList",pid,staindex),"^",2) + stierrNum
	...s $p(^TMP("DHCCKB","QueryMesterList",pid,staindex),"^",3) = $p(^TMP("DHCCKB","QueryMesterList",pid,staindex),"^",3) + enablenum
	...s $p(^TMP("DHCCKB","QueryMesterList",pid,staindex),"^",4) = $p(^TMP("DHCCKB","QueryMesterList",pid,staindex),"^",4) + tipsnum
	...s $p(^TMP("DHCCKB","QueryMesterList",pid,staindex),"^",5) = $p(^TMP("DHCCKB","QueryMesterList",pid,staindex),"^",5) + warnnum
	...s $p(^TMP("DHCCKB","QueryMesterList",pid,staindex),"^",6) = $p(^TMP("DHCCKB","QueryMesterList",pid,staindex),"^",6) + forbidnum
	b   //222
	Q ""
}

}
