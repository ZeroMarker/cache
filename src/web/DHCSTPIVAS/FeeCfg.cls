/// Description: 配液配置费上限设置
/// CreateDate:	 2021-11-08
Class web.DHCSTPIVAS.FeeCfg Extends %RegisteredObject
{

Parameter AppTable [ Final ] = "PHAPIVAS_FeeCfg";

Parameter LogSign [ Final ] = "配液中心 - 配置费用上限";

/// Deccription:查询
/// Table:      User.PHAPIVASFeeCfg
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.FeeCfg","PHAPIVASFeeCfg",3)
Query PHAPIVASFeeCfg(pHosp = "") As websys.Query(ROWSPEC = "arcim,arcimCode,arcimDesc,times,maxAmt")
{
}

ClassMethod PHAPIVASFeeCfgExecute(ByRef qHandle As %Binary, pHosp = "") As %Status
{
	k PHAPIVASFeeCfgDATA
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s poli=0
	f  s poli=$o(^POLI(poli)) q:poli=""  d
	.q:##class(PHA.FACE.IN.Com).GetShowDataFlag(##class(web.DHCSTPIVAS.OrderLink).#AppTable,poli,pHosp)="N" //医院级别授权
	.s poliItm=0
	.f  s poliItm=$o(^POLI(poli,"M",poliItm)) q:poliItm=""  d
	..s arcim=$p(^POLI(poli,"M",poliItm),"^",1)
	..q:arcim'["||"
	..s PHAPIVASFeeCfgDATA(arcim)=""
	s arcim=""
	f  s arcim=$o(PHAPIVASFeeCfgDATA(arcim)) q:arcim=""  d
	.s arcSub=+arcim,arcVer=+$p(arcim,"||",2)
	.s arcimCode=$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)
	.s arcimDesc=$p($g(^ARCIM(arcSub,arcVer,1)),"^",2)
	.s cfgId=$o(^CF.PHA.PIVAS.FeeCfgi("Arcim",arcim,""))
	.s times=$s(cfgId="":"",1:$lg($g(^CF.PHA.PIVAS.FeeCfg(cfgId)),3))
	.s maxAmt=$s(cfgId="":"",1:$lg($g(^CF.PHA.PIVAS.FeeCfg(cfgId)),4))
	.s ^CacheTemp(repid,ind)=$lb(arcim,arcimCode,arcimDesc,times,maxAmt)    
	.s ind=ind+1
	Quit $$$OK
}

/// Description: 批量保存
/// w ##class(web.DHCSTPIVAS.FeeCfg).SaveMulti("4595||1^1^12")
ClassMethod SaveMulti(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	ts
	
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..Save(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	
	i errCode'=""  tro  q errCode
	tc
	q 0
}

/// Description: 保存规则
/// Input:		 inputStr
/// 				 ^1:医嘱项Id
/// 				 ^2:次数
/// Return:		 +ret=0 成功
/// Debugger:	 w ##class(web.DHCSTPIVAS.FeeRule).Save("1416||1^12^^2")
ClassMethod Save(inputStr)
{
	s arcim=$p(inputStr,"^",1)
	s times=$p(inputStr,"^",2)
	s maxAmt=$p(inputStr,"^",3)
	s hosp=$p(inputStr,"^",4)
	q:arcim'["||" "-1^医嘱项为空"
	q:+times<0 "-1^次数不能小于0"
	q:+maxAmt<0 "-1^金额上限不能小于0"
	q:(times'="")&&(+times'=times) "-1^次数不为数字"
	q:times["." "-1^次数不能为小数"
	
	s logSignDesc = ""
	
	s cfgId=$o(^CF.PHA.PIVAS.FeeCfgi("Arcim",arcim,""))
	i cfgId="" d
	.&SQL(
	 	INSERT INTO SQLUSER.PHAPIVAS_FeeCfg 
	 	(PFC_Arcim_DR,PFC_Times,PFC_MaxAmt)
	 	VALUES
	 	(:arcim,:times,:maxAmt)
	 )
	e  d
	.s oldJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PHAPIVAS_FeeCfg", cfgId)
	.&SQL(
	 	UPDATE SQLUSER.PHAPIVAS_FeeCfg 
	 	SET PFC_Times=:times,PFC_MaxAmt=:maxAmt
	 	WHERE PFC_Arcim_DR=:arcim
	 )
	q:SQLCODE'=0 "-1^保存失败"_$g(%msg)
	
	s rowID = $p(%ROWID,$c(1))
    s logSignDesc = ..GetLogSignDesc(rowID)
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PHAPIVAS_FeeCfg", rowID)
	s logType = $s(cfgId = "" : "A" , 1 : "U")
	s newJsonStr=$replace($g(newJsonStr), "PFC_Times", "最大收费次数")
	s oldJsonStr=$replace($g(oldJsonStr), "PFC_Times", "最大收费次数")
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHAPIVAS_FeeCfg","User.PHAPIVASFeeCfg", ..#LogSign, rowID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))
	
	s mapHospRet =  ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,rowID,hosp)
	q:(mapHospRet '= 1) mapHospRet
	// 删除都是空的数据
	&SQL(
		DELETE FROM SQLUSER.PHAPIVAS_FeeCfg 
		WHERE PFC_RowID>0 AND PFC_Times IS NULL AND PFC_MaxAmt IS NULL 
	)
	q 0
}

ClassMethod GetLogSignDesc(rowID)
{
    &SQL(
		SELECT arc.ARCIM_Desc INTO :ret
		FROM SQLUSER.PHAPIVAS_FeeCfg cfg
		         LEFT JOIN SQLUSER.ARC_ItmMast arc ON cfg.PFC_Arcim_DR = arc.ARCIM_RowId
		WHERE PFC_RowID = :rowID
    )
    q $g(ret)
}

}
