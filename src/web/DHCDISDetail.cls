Import sqluser

Class web.DHCDISDetail Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      lvpeng
/// CreatDate：    2017-01-05
/// Description:   查询陪送详情
/// Table：        DHC_DisRequest、DHC_DisRequestItm、DHC_DisPeople、DHC_DisRequestAsse
/// w ##class(web.DHCDISDetail).FindDisDetail("40","")
ClassMethod FindDisDetail(taskID As %String, typeID As %String) As %String
{
	
	//申请主表、申请明细表取数据
	n (taskID,typeID) //申请单ID
	q:taskID="" ""
	s userName="",curStatusDesc="",dataStr=""
	s dpRowID=""
	f  s dpRowID=$o(^DHCDISRS(0,"TypePointer",typeID,taskID,dpRowID),-1) q:dpRowID=""  d
	.q:dpRowID=0
	.s curStatusID=$p(^DHCDISRS(dpRowID),"^",3)
	.i curStatusID'="" s curStatusDesc=$p(^DHCDISSA(curStatusID),"^",2)
	.s curDate=$p(^DHCDISRS(dpRowID),"^",4)
	.i curDate'="" s curDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(curDate)
	.s curTime=$p(^DHCDISRS(dpRowID),"^",5)
	.i curTime'="" s curTime=$zt(curTime,2)
	.s userDr=$p(^DHCDISRS(dpRowID),"^",6)
	.i userDr'="" s userName=$p(^SSU("SSUSR",userDr),"^",2)
	.s dataStr=dataStr_curDate_"^"_curTime_"^"_curStatusDesc_"^"_userName_"$$"
	q dataStr
	/*s pid=##class(web.DHCDISRequestCom).getPid()
	s REQCreateDate="",REQCreateTime="",REQCreateUser=""
	s REQCreateDate=$p(^DHCDISRE(taskID),"^",13) //创建日期
	s:REQCreateDate'="" REQCreateDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(REQCreateDate) //$zd(REQCreateDate,3)
	s REQCreateTime=$p(^DHCDISRE(taskID),"^",14) //创建时间
	s:REQCreateTime'="" REQCreateTime=$zt(REQCreateTime,2)
	
	s REQCreateUser=$p(^DHCDISRE(taskID),"^",15) //创建人
	s REQSub="",Itemarr=""
	f  s REQSub=$o(^DHCDISRE(taskID,"Itm",REQSub)) q:REQSub=""  d
	.s REQItem=$p(^DHCDISRE(taskID,"Itm",REQSub),"^",1) //项目ID
	.
	.q:REQItem=""
	.s REQItemid=taskID_"||"_REQSub 
	.i REQItem'="" d 
	..s DPRowID="",Userarr=""
	..f  s DPRowID=$O(^DHCDISPE(0,"TypePointer",0,REQItemid,DPRowID)) q:DPRowID=""  d
	...s DPUser=$p(^DHCDISPE(DPRowID),"^",3)
	...s:DPUser'="" DPUser=$p(^SSU("SSUSR",DPUser),"^",2)
	...i Userarr="" s Userarr=DPUser
	...e  s Userarr=Userarr_"^"_DPUser
	.s REQItemType=$p(^DHCDISRE(taskID,"Itm",REQSub),"^",2) //项目类型
	.i (REQItemType'="")&(REQItemType="Ord") d	//项目类型医嘱
	..s REQItem1=$p(REQItem,"||",1),REQItem2=$p(REQItem,"||",2)
	..s arcimId=$p(^OEORD(REQItem1,"I",REQItem2,1),"^",2) //项目描述
	..i arcimId'="" s REQItemDesc=$P($G(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2)
	.i (REQItemType'="")&(REQItemType="Oth") d	//项目类型其他
	..s REQItem=$p(^DHCDISRE(taskID,"Itm",REQSub),"^",1)
	..
	..s REQItemDesc=""
	..q:'$d(^DHCDISLI(REQItem))
	..s REQItemDesc=$p(^DHCDISLI(REQItem),"^",2)
	.i Itemarr="" s Itemarr=REQItemDesc_"#"_Userarr
	.e  s Itemarr=Itemarr_"@"_REQItemDesc_"#"_Userarr
	;d ..killTmpGlobal(pid) //k掉临时global
	;b ;REQCreateDate
 	;i (REQCreateDate'="")&&(REQCreateTime'="") d
 	s ^TMP("DHCDIS","web.DHCDISDetail","FindDisDetail",pid,REQCreateDate,REQCreateTime)="创建陪送申请单"_"^"_Itemarr
 	
 	
	
	// 状态明细表取数据
	s RsRowid=""
	f  s RsRowid=$o(^DHCDISRS(0,"TypePointer",9,taskID,RsRowid)) q:RsRowid=""  d
	.s RSCurStatus=$p(^DHCDISRS(RsRowid),"^",3) //当前状态
	.
	.i RSCurStatus'="" d
	..s SaDesc=$p(^DHCDISSA(RSCurStatus),"^",2) //状态描述
	..s RSCreateDate=$p(^DHCDISRS(RsRowid),"^",4) //创建日期
	..s:RSCreateDate'="" RSCreateDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(RSCreateDate) //$zd(RSCreateDate,3)	
	..s RSCreateTime=$p(^DHCDISRS(RsRowid),"^",5) //创建时间
	..s:RSCreateTime'="" RSCreateTime=$zt(RSCreateTime,2)
	..s RSCreateUser=$p(^DHCDISRS(RsRowid),"^",6) //创建人
	..s ^TMP("DHCDIS","web.DHCDISDetail","FindDisDetail",pid,RSCreateDate,RSCreateTime)=SaDesc
	.. ;RSCreateDate
	
	// 评价取数据
	s RARowid=""
	f  s RARowid=$o(^DHCDISRA(0,"TypePointer",0,taskID,RARowid),-1) q:RARowid=""  d
	.s RACreateDate=$p(^DHCDISRA(RARowid),"^",5) //评价日期
	.s:RACreateDate'="" RACreateDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(RACreateDate) //$zd(RACreateDate,3)
 	.s RACreateTime=$p(^DHCDISRA(RARowid),"^",6) //创建时间
	.s:RACreateTime'="" RACreateTime=$zt(RACreateTime,2)
	.s ^TMP("DHCDIS","web.DHCDISDetail","FindDisDetail",pid,RACreateDate,RACreateTime)="评价打分"
	
 	s statDate = "",dataStr=""
 	f  s statDate = $o(^TMP("DHCDIS","web.DHCDISDetail","FindDisDetail",pid,statDate),-1)  q:statDate=""  d
 	.s statTime = ""
 	.f  s statTime = $o(^TMP("DHCDIS","web.DHCDISDetail","FindDisDetail",pid,statDate,statTime),-1)  q:statTime=""  d
 	..s dataStr = dataStr_statDate_"^"_statTime_"^"_^TMP("DHCDIS","web.DHCDISDetail","FindDisDetail",pid,statDate,statTime)_"$$"
 	d ..killTmpGlobal(pid) //k掉临时global
 	Q dataStr*/
}

/// Creator：      lvpeng
/// CreatDate：    2017-01-05
/// Description:   查询配送详情
/// Table：        DHC_DisRequest、DHC_DisRequestItm、DHC_DisPeople、DHC_DisRequestAsse
/// w ##class(web.DHCDISDetail).FindDisDetailaop("297")
ClassMethod FindDisDetailaop(taskID As %String) As %String
{
	n (taskID) //申请单ID
	q:taskID="" ""
	s typeID=$p(^DHCDISGRE(taskID),"^",12)
	s userName="",curStatusDesc="",dataStr=""
	s dpRowID=""
	f  s dpRowID=$o(^DHCDISRS(0,"TypePointer",typeID,taskID,dpRowID),-1) q:dpRowID=""  d
	.q:dpRowID=0
	.s curStatusID=$p(^DHCDISRS(dpRowID),"^",3)
	.i curStatusID'="" s curStatusDesc=$p(^DHCDISSA(curStatusID),"^",2)
	.s curDate=$p(^DHCDISRS(dpRowID),"^",4)
	.i curDate'="" s curDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(curDate)
	.s curTime=$p(^DHCDISRS(dpRowID),"^",5)
	.i curTime'="" s curTime=$zt(curTime,2)
	.s userDr=$p(^DHCDISRS(dpRowID),"^",6)
	.i userDr'="" s userName=$p(^SSU("SSUSR",userDr),"^",2)
	.s dataStr=dataStr_curDate_"^"_curTime_"^"_curStatusDesc_"^"_userName_"$$"
	q dataStr
	/*
	//申请主表、申请明细表取数据
	n (taskID) //申请单ID
	q:taskID="" ""
	s pid=##class(web.DHCDISRequestCom).getPid()
	s REQCreateDate="",REQCreateTime="",REQCreateUser=""
	s REQCreateDate=$p(^DHCDISGRE(taskID),"^",7) //创建日期
	s:REQCreateDate'="" REQCreateDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(REQCreateDate) //hxy 2017-03-29 $zd(REQCreateDate,3)
	s REQCreateTime=$p(^DHCDISGRE(taskID),"^",8) //创建时间
	s:REQCreateTime'="" REQCreateTime=$zt(REQCreateTime,2)
	
	s REQCreateUser=$p(^DHCDISGRE(taskID),"^",9) //创建人
	s REQSub="",Itemarr=""
	f  s REQSub=$o(^DHCDISGRE(taskID,"ITM",REQSub)) q:REQSub=""  d
	.s REQItem=$p(^DHCDISGRE(taskID,"ITM",REQSub),"^",1) //项目ID
	.q:REQItem=""
	.s REQItemid=taskID_"||"_REQSub 
	.i REQItem'="" d 
	..s DPRowID="",Userarr=""
	..f  s DPRowID=$O(^DHCDISPE(0,"TypePointer",1,REQItemid,DPRowID)) q:DPRowID=""  d
	...s DPUser=$p(^DHCDISPE(DPRowID),"^",3)
	...s:DPUser'="" DPUser=$p(^SSU("SSUSR",DPUser),"^",2)
	...i Userarr="" s Userarr=DPUser
	...e  s Userarr=Userarr_"^"_DPUser
	.s REQItemDesc=$p(^DHCDISLI(REQItem),"^",2)
	.i Itemarr="" s Itemarr=REQItemDesc_"#"_Userarr
	.e  s Itemarr=Itemarr_"@"_REQItemDesc_"#"_Userarr
	;d ..killTmpGlobal(pid) //k掉临时global
 	i (REQCreateDate'="")&(REQCreateTime'="") s ^TMP("DHCDIS","web.DHCDISDetail","FindDisDetailaop",pid,REQCreateDate,REQCreateTime)="创建配送申请单"_"^"_Itemarr
 	
 	
	
	// 状态明细表取数据
	s RsRowid=""
	f  s RsRowid=$o(^DHCDISRS(0,"TypePointer",1,taskID,RsRowid)) q:RsRowid=""  d
	.s RSCurStatus=$p(^DHCDISRS(RsRowid),"^",3) //当前状态
	.i RSCurStatus'="" d
	..s SaDesc=$p(^DHCDISSA(RSCurStatus),"^",2) //状态描述
	..s RSCreateDate=$p(^DHCDISRS(RsRowid),"^",4) //创建日期
	..s:RSCreateDate'="" RSCreateDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(RSCreateDate) //$zd(RSCreateDate,3)	
	..s RSCreateTime=$p(^DHCDISRS(RsRowid),"^",5) //创建时间
	..s:RSCreateTime'="" RSCreateTime=$zt(RSCreateTime,2)
	..s RSCreateUser=$p(^DHCDISRS(RsRowid),"^",6) //创建人
	..s ^TMP("DHCDIS","web.DHCDISDetail","FindDisDetailaop",pid,RSCreateDate,RSCreateTime)=SaDesc
	
	
	// 评价取数据
	s RARowid=""
	f  s RARowid=$o(^DHCDISRA(0,"TypePointer",1,taskID,RARowid),-1) q:RARowid=""  d
	.s RACreateDate=$p(^DHCDISRA(RARowid),"^",5) //评价日期
	.s:RACreateDate'="" RACreateDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(RACreateDate) //$zd(RACreateDate,3)
 	.s RACreateTime=$p(^DHCDISRA(RARowid),"^",6) //创建时间
	.s:RACreateTime'="" RACreateTime=$zt(RACreateTime,2)
	.s ^TMP("DHCDIS","web.DHCDISDetail","FindDisDetailaop",pid,RACreateDate,RACreateTime)="评价打分"
	
 	s statDate = "",dataStr=""
 	f  s statDate = $o(^TMP("DHCDIS","web.DHCDISDetail","FindDisDetailaop",pid,statDate),-1)  q:statDate=""  d
 	.s statTime = ""
 	.f  s statTime = $o(^TMP("DHCDIS","web.DHCDISDetail","FindDisDetailaop",pid,statDate,statTime),-1)  q:statTime=""  d
 	..s dataStr = dataStr_statDate_"^"_statTime_"^"_^TMP("DHCDIS","web.DHCDISDetail","FindDisDetailaop",pid,statDate,statTime)_"$$"
 	d ..killTmpGlobal(pid) //k掉临时global
 	Q dataStr
 	*/
}

/// Description:返回病人信息
/// w ##class(web.DHCDISDetail).GetPatInfo("0000000011")
ClassMethod GetPatInfo(curId, transLocNum = "") As %String
{
	q:curId="" ""
	s trestr=##class(web.DHCCLCom).PatInfo(curId,transLocNum)
	q trestr
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	K ^TMP("DHCDIS","web.DHCDISDetail","FindDisDetail",pid)
	K ^TMP("DHCDIS","web.DHCDISDetail","FindDisDetailaop",pid)
}

}
