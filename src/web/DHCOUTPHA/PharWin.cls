/// creator: 	yunhaibao
/// createdate: 2018-12-13
/// description:中间表处理
Class web.DHCOUTPHA.PharWin Extends %RegisteredObject
{

/// description: 插入中间表数据
/// input:		 PrescNo(处方号),PrtId(发票Id),RecLocId(接收科室Id)
/// w ##class(web.DHCOUTPHA.PharWin).InsertPharWin("O181217000012","",309,"")
ClassMethod InsertPharWin(PrescNo, PrtId, RecLocId, PhwId = "")
{
	s $zt="ErrorInsertPharWin"
	s errCode=""
	s lockName="DHCPHARWIN"_PrescNo
	q:PrescNo="" "-1^处方号为空"
	q:RecLocId="" "-1^接收科室为空"
	s phlId=$o(^DHCPHLOCi("LOC",RecLocId,""),-1)
	q:phlId="" "-1^接收科室未在门诊药房科室维护"
	s curDate=+$h
	s curTime=$p($h,",",1)
	s lockRet=##class(web.DHCST.Common.AppCommon).Lock(lockName)
	q:lockRet'=0 "-1^插入中间表加锁处方号失败" 
	s chkRet=..CheckCanInsert(PrescNo)
	i $p(chkRet,"^",1)<0 d UnLock q 0
	i $d(^DHCPHARi("PRESCNO",PrescNo)) d
	.// 更新为作废
	.&SQL(UPDATE SQLUSER.DHC_PHARWIN SET PHA_NOUSER=1 where PHA_PrescNo=:PrescNo)
	s ordId=$o(^OEORD(0,"PrescNo",PrescNo,""))
	s admId=$p(^OEORD(ordId),"^",1)
	s patId=$p(^PAADM(admId),"^",1)
	s PrtId=""
	i PhwId'="" s phwId=PhwId
	e  d
	.s phlPhwStr=##class(web.DHCMZYFXTYW02).GetCurrWinNew(PrescNo)
	.s phlPhw=$p(phlPhwStr,$c(1),1)
	.s phwId=$p(phlPhwStr,"^",2)
	s noUse=""
	s retFlag=1
	&SQL(
		INSERT INTO SQLUSER.DHC_PHARWIN 
		(
			PHA_PRT_DR,PHA_DATE,PHA_TIME,PHA_PHW_DR,PHA_PHL_DR,Pha_PrescNo,PHA_RETFLAG
		)
		VALUES
		(
			:PrtId,:curDate,:curTime,:phwId,:phlId,:PrescNo,:retFlag
		)
	)
	d UnLock
	q:SQLCODE'=0 "-1^插入中间表失败,SQLCODE:"_SQLCODE_","_$g(%msg)
	q $p(%ROWID,$c(1))
UnLock
	d ##class(web.DHCST.Common.AppCommon).UnLock(lockName)
	q
ErrorInsertPharWin
	d UnLock
	q -1_"^"_$replace($ze,"^","")
}

/// description: 验证是否需要重新插入中间表
/// return:		 $p(ret,"^",1)>=0 可插入
/// w ##class(web.DHCOUTPHA.PharWin).CheckCanInsert("O181217000012")
ClassMethod CheckCanInsert(PrescNo)
{
	s pharId=$o(^DHCPHARi("PRESCNO",PrescNo,""),-1)
	q:pharId="" 0
	s phdId=$o(^DHCPHDISPi("PRESCNO",PrescNo,""),-1)
	q:(phdId'="")&&($p($g(^DHCPHDISP(phdId)),"^",4)=1) "-1^已发药"
	s changeFlag=""
	s phdItm=0
	f  s phdItm=$o(^DHCPHDI(phdId,"PHDI",phdItm)) q:phdItm=""  d
	.s oeori=$p(^DHCPHDI(phdId,"PHDI",phdItm),"^",5)
	.s oeStateId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",13)
	.q:oeStateId=""
	.s oeStateCode=$P($g(^OEC("OSTAT",+oeStateId)),"^",1)
	.s billFlag=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),3),"^",5)
	.i (billFlag'="P")&&(oeStateCode'="V")&&(oeStateCode'="E") d	// 未发处于此状态
	..s changeFlag="1"
	// 发药子表存在数据了1,2,3
	// 医嘱子表有效数据  1,2
	q:changeFlag'="" 0
	q "-1^医嘱未发生变化"
}

}
