/// creator:	 QianHuanjuan
/// createdate:	 2018-03-19
/// description: 配液排批规则
Class web.DHCSTPIVAS.BatchRules Extends web.DHCSTPIVAS.Common
{

Parameter LogSign [ Final ] = "配液中心 - 排批规则定义";

/// description:查询时间规则列表
/// others:		
/// input:		inputStr^1:配液中心Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.BatchRules","QueryPIVABatTime","248")
Query QueryPIVABatTime(inputStr = "") As websys.Query(ROWSPEC = "pbtId,wardId,locId,startTime,endTime,batNo,seqFlag,priId,locDesc,wardDesc,priId,priDesc,pyTime,batRemark,packFlag")
{
}

ClassMethod QueryPIVABatTimeExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s PivaLocId=$p(inputStr,"^",1)
	q:PivaLocId="" $$$OK
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT "_
			   "PBT_RowID as pbtId,PBT_Ward_Dr as wardId,PBT_Ctloc_Dr as locId,"_
			   "PBT_TimeFrom as startTime,PBT_TimeTo as endTime,PBT_BatNo as batNo,"_
			   "PBT_SeqFlag as seqFlag,PBT_Priority_Dr as priId,PBT_PYTime as pyTime,"_
			   "PBT_Remark as batRemark,PBT_AutoPack as packFlag "_
			   "FROM PIVA_BatTime where PBT_Ctloc_Dr="_PivaLocId_" "_
			   "order by PBT_Ward_Dr,PBT_BatNo"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s pbtId= result.Data("pbtId") 
	    s wardId= result.Data("wardId") 
	    s locId= result.Data("locId") 
	    s startTime= result.Data("startTime")
	    s endTime= result.Data("endTime") 
	    s batNo= result.Data("batNo")
	    s seqFlag= result.Data("seqFlag")
	    s priId=result.Data("priId")
	    s pyTime=result.Data("pyTime")
	    s batRemark=result.Data("batRemark")
	    s packFlag=result.Data("packFlag")
	    s locDesc=##class(PHA.COM.Data.Base).LocDesc(locId)
	    i wardId'="" s wardDesc=$p($g(^PAWARD(wardId)),"^",2)
	    e  s wardDesc=""
	    i priId'="" s priDesc=##class(PHA.COM.Data.Base).OrdPriDesc(priId)
	    e  s priDesc=""
		s startTime=$zt(startTime,1)
		s endTime=$zt(endTime,1)
		i pyTime'="" s pyTime=$zt(pyTime,1)
		s Data=$lb(pbtId,wardId,locId,startTime,endTime,batNo,seqFlag,priId,locDesc,wardDesc,priId,priDesc,pyTime,batRemark,packFlag)
		s ^CacheTemp(repid,ind)=Data    
		s ind=ind+1
    }
    d result.Close()
	Quit $$$OK
}

/// description: 保存时间规则信息
/// input:		 inputStr^1:时间规则id,inputStr^2:病区id,inputStr^3:配液中心id,inputStr^4:开始时间,inputStr^5:截止时间
/// 			 inputStr^6:批次,inputStr^7:关联医嘱,inputStr^8:医嘱优先级,inputStr^8:要求配送时间
/// return:		 +ret=0 成功
/// w ##class(web.DHCSTPIVAS.BatchRules).SavePIVABatTime("^^102^01:00:00^23:00:00^11^Y^^01:00:00")
ClassMethod SavePIVABatTime(inputStr)
{
	s $zt="ThrowSavePIVABatTime"
	s pbtId=$p(inputStr,"^",1)
	q:(pbtId'="")&&(+pbtId'=pbtId) "-1^请刷新后重试"
	s wardid=$p(inputStr,"^",2)
	s locId=$p(inputStr,"^",3)
	s startTime=$p(inputStr,"^",4)
	s endTime=$p(inputStr,"^",5)
	s batNo=$p(inputStr,"^",6)
	s seqFlag=$p(inputStr,"^",7)
	s priId=$p(inputStr,"^",8)
	s pyTime=$p(inputStr,"^",9)
	s batRemark=$p(inputStr,"^",10)
	s packFlag=$p(inputStr,"^",11)
	q:locId="" "-1^配液中心为空"
	q:startTime="" "-1^开始时间为空"
	q:endTime="" "-1^结束时间为空"
	q:batNo="" "-1^批次为空"
	s startTime=$zth(startTime,1)
	s endTime=$zth(endTime,1)
	q:startTime>=endTime "-1^用药结束时间应大于开始时间"
	i pyTime'="" s pyTime=$zth(pyTime,1)
	s errCode=""
	i pbtId="" {
		&SQL(
			INSERT INTO PIVA_BatTime (PBT_TimeFrom, PBT_TimeTo, PBT_BatNo, PBT_Ctloc_Dr, PBT_SeqFlag, PBT_Ward_Dr, PBT_PYTime,
                          PBT_Priority_Dr, PBT_Remark, PBT_AutoPack)
			VALUES (:startTime, :endTime, :batNo, :locId, :seqFlag, :wardId, :pyTime, :priId, :batRemark, :packFlag)
		)
	}else {
		s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_BatTime", pbtId)
		&SQL(
			UPDATE PIVA_BatTime
			SET PBT_TimeFrom=:startTime,
			    PBT_TimeTo=:endTime,
			    PBT_BatNo=:batNo,
			    PBT_Ctloc_Dr=:locId,
			    PBT_SeqFlag=:seqFlag,
			    PBT_Ward_Dr=:wardId,
			    PBT_PYTime=:pyTime,
			    PBT_Priority_Dr=:priId,
			    PBT_Remark=:batRemark,
			    PBT_AutoPack = :packFlag
			WHERE PBT_RowID = :pbtId
		)
		
	}
	i SQLCODE'=0 {
		s errCode=$$$pivasError4Sql(%msg)
		d ErrorRecord^DHCSTERROR("Insert:User.PIVABatTime","插入失败",$g(%msg))
	}
	q:errCode'="" errCode

	s rowID = $p(%ROWID,$c(1))
	s logSignDesc = ..GetPIVABatTimeLogSignDesc(rowID)
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_BatTime", rowID)
	s logType = $s(pbtId = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_BatTime","User.PIVABatTime", ..#LogSign, rowID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))	

	q rowID
ThrowSavePIVABatTime
	d ErrorRecord^DHCSTERROR("Insert:User.PIVABatTime","插入失败",$ze)
	q "-2^"_$tr($ze,"^","")
}

/// description: 删除时间规则信息
/// w ##class(web.DHCSTPIVAS.BatchRules).DeletePIVABatTime("")
ClassMethod DeletePIVABatTime(pbtId)
{
	q:pbtId="" "-1^时间规则Id为空"
 	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_BatTime", pbtId)
	s logSignDesc = ..GetPIVABatTimeLogSignDesc(pbtId)
	&SQL(
		DELETE
		FROM PIVA_BatTime
		WHERE PBT_RowId = :pbtId
	)
	q:SQLCODE'=0 $$$pivasError4Sql(%msg)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_BatTime","User.PIVABatTime", ..#LogSign, pbtId, logSignDesc, "D", delJsonStr)
	q 0
}

ClassMethod GetPIVABatTimeLogSignDesc(rowID)
{
	&SQL(
		SELECT PBT_Ctloc_Dr->CTLOC_Desc || ' - ' || PBT_BatNo INTO :logSignDesc
		FROM PIVA_BatTime WHERE %ID = :rowID
	)
	q "时间规则: " _ $g(logSignDesc)
}

/// description:频次规则列表
/// others:		
/// input:	
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.BatchRules","QueryPIVAFreqRule","101")
Query QueryPIVAFreqRule(inputStr = "") As websys.Query(ROWSPEC = "pfrId,freqId,freqDesc,ordNum,upFlag,downFlag")
{
}

ClassMethod QueryPIVAFreqRuleExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s PivaLocId=inputStr
	q:PivaLocId="" $$$OK
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT PIVA_RowID,PIVA_Freq_Dr,PIVA_OrderNum, PIVA_UpFlag, PIVA_DownFlag FROM PIVA_FreqRule where PIVA_PhaLocDr="_PivaLocId_" order by PIVA_OrderNum asc"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s pfrId= result.Data("PIVA_RowID") 
	    s freqId= result.Data("PIVA_Freq_Dr")
	    continue:freqId=""
	    s freqDesc=##class(PHA.COM.Data.Base).FreqDesc(freqId)
	    s ordNum= result.Data("PIVA_OrderNum") 
		s Data=$lb(pfrId,freqId,freqDesc,ordNum,result.Data("PIVA_UpFlag"),result.Data("PIVA_DownFlag") )
		s ^CacheTemp(repid,ind)=Data    
		s ind=ind+1
    }
    d result.Close()
	Quit $$$OK
}

/// Description: 批量保存病区规则顺序规则
ClassMethod SavePIVAFreqRuleMulti(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SavePIVAFreqRule(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// Description: 保存顺序规则
/// w ##class(web.DHCSTPIVAS.BatchRules).SaveLocBatSort("^5^2^12")
ClassMethod SavePIVAFreqRule(inputStr) As %String
{
	s $zt = "ThrowSavePIVAFreqRule"
	s loc = $p(inputStr, "^", 1)
	s rowID = $p(inputStr, "^", 2)
	s freq = $p(inputStr, "^", 3)
	s upFlag = +$p(inputStr, "^", 4)
	s downFlag = +$p(inputStr, "^", 5)
	s ordNum = $p(inputStr, "^", 6)
	q:(loc = "") "-1^配液中心为空"
	q:(freq = "") "-1^频次为空"
	q:(ordNum = "") "-1^顺序为空"

	s errCode=""
	
	if (rowID = ""){
		&SQL(
			SELECT 1
			FROM SQLUSER.PIVA_FreqRule WHERE PIVA_PhaLocDr = :loc AND PIVA_Freq_Dr = :freq
		)
		q:(SQLCODE = 0) $$$OK
		&SQL(
			INSERT INTO PIVA_FreqRule (PIVA_PhaLocDr, PIVA_Freq_Dr, PIVA_OrderNum, PIVA_UpFlag, PIVA_DownFlag)
			VALUES (:loc, :freq, :ordNum, :upFlag, :downFlag)
		)
	}else{
		&SQL(
			UPDATE PIVA_FreqRule
			SET PIVA_Freq_Dr = :freq,
			    PIVA_OrderNum = :ordNum,
			    PIVA_UpFlag = :upFlag,
			    PIVA_DownFlag = :downFlag
			WHERE %ID = :rowID
		)
	}

	s rowID = %ROWID
	if (SQLCODE '= 0){
		s errCode=$$$pivasError4Sql(%msg)
		d ErrorRecord^DHCSTERROR("Save:User.PIVAFreqRule", "保存失败", $g(%msg))	
	}	
	q:(errCode '= "") errCode
	q 0
ThrowSavePIVAFreqRule
	d ErrorRecord^DHCSTERROR("Save:User.PIVAFreqRule","保存失败",$ze)
	q "-2^"_$tr($ze,"^","")
}

/// description: 删除频次规则信息
/// w ##class(web.DHCSTPIVAS.BatchRules).DeleteBatFreq("0")
ClassMethod DeletePIVAFreqRule(pfrId)
{
 	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_FreqRule", pfrId)
	s logSignDesc = ..GetPIVAFreqRuleLogSignDesc(pfrId)	
	&SQL(
		DELETE
		FROM PIVA_FreqRule
		WHERE PIVA_RowID = :pfrId
	)
	q:(SQLCODE '= 0) $$$pivasError4Sql(%msg)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_FreqRule","User.PIVAFreqRule", ..#LogSign, pfrId, logSignDesc, "D", delJsonStr)
	q 0
}

ClassMethod GetPIVAFreqRuleLogSignDesc(rowID)
{
	&SQL(
		SELECT PIVA_PhaLocDr->CTLOC_Desc  || ' - ' || PIVA_Freq_Dr->PHCFR_Desc1 INTO :ret
		FROM PIVA_FreqRule WHERE %ID = :rowID
	)
	q "频次规则: " _ $g(ret)
}

/// description: 频次规则上下移动
/// input:		 inputStr^1:选中的Id,移动后位置对应所在id
/// w ##class(web.DHCSTPIVAS.BatchRules).MovePIVAFreqRule("")
ClassMethod MovePIVAFreqRule(inputStr)
{
    s $zt="ThrowMovePIVAFreqRule"
    s errCode=""
	s origPfrId=$p(inputStr,"^",1)
	s pfrId=$p(inputStr,"^",2)
	q:(origPfrId="")||(pfrId="") "-1^数据不全"
    s origOrdNum=$p(^PIVAFREQR(+origPfrId),"^",2)
	s ordNum=$p(^PIVAFREQR(+pfrId),"^",2)
	s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_FreqRule", origPfrId)
	
	tstart
	&sql(update PIVA_FreqRule  set PIVA_OrderNum=:ordNum where PIVA_RowID=:origPfrId)
	i SQLCODE'=0 d
	.s errCode=$$$pivasError4Sql(%msg)
	.d ErrorRecord^DHCSTERROR("Update:User.PIVAFreqRule","更新",SQLCODE_":"_%msg)
	i errCode'="" tro  q errCode
	&sql(update PIVA_FreqRule  set PIVA_OrderNum=:origOrdNum where PIVA_RowID=:pfrId)
	i SQLCODE'=0 d
	.s errCode=$$$pivasError4Sql(%msg)
	.d ErrorRecord^DHCSTERROR("Update:User.PIVAFreqRule","更新",SQLCODE_":"_%msg)
	i errCode'="" tro  q errCode
	tcommit	
	s logSignDesc = ..GetPIVAFreqRuleLogSignDesc(pfrId)	
	s newJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_FreqRule", origPfrId)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_FreqRule","User.PIVAFreqRule", ..#LogSign, origPfrId, logSignDesc, "U", newJsonStr, oldJsonStr)
	q 0
ThrowMovePIVAFreqRule
	d ErrorRecord^DHCSTERROR("Update:User.PIVAFreqRule","更新失败",$ze)
	q "-2^"_$tr($ze,"^","")
}

/// description:查询病区规则列表
/// others:		
/// input:		inputStr^1:配液中心,inputStr^2:病区
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.BatchRules","QueryPIVALocBat","101^")
Query QueryPIVALocBat(inputStr = "") As websys.Query(ROWSPEC = "plbatId,locId,locDesc,wardId,wardDesc")
{
}

ClassMethod QueryPIVALocBatExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s PivaLocId=$p(inputStr,"^",1)
	q:PivaLocId="" $$$OK
	s WardId=$p(inputStr,"^",2)
	s ind=1
	s plbatId=""
	f  s plbatId=$o(^PIVALBAT(plbatId)) q:plbatId=""  d
	.q:+plbatId=0
	.s locId=$p(^PIVALBAT(plbatId),"^",1)
	.s wardId=$p(^PIVALBAT(plbatId),"^",2)
	.q:(PivaLocId'="")&&(PivaLocId'=locId)
	.q:(WardId'="")&&(WardId'=wardId)
	.s locDesc=##class(PHA.COM.Data.Base).LocDesc(PivaLocId)
	.s wardDesc=##class(PHA.COM.Data.Base).WardDesc(wardId)
	.s sortIndex=plbatId
	.i wardId="" s sortIndex=0
	.s data=plbatId_"^"_locId_"^"_locDesc_"^"_wardId_"^"_wardDesc
	.s QueryPIVALocBatData(sortIndex,plbatId)=data
	s sortIndex=""
	f  s sortIndex=$o(QueryPIVALocBatData(sortIndex)) q:sortIndex=""  d
	.s plbatId=""
	.f  s plbatId=$o(QueryPIVALocBatData(sortIndex,plbatId)) q:plbatId=""  d
	..s data=QueryPIVALocBatData(sortIndex,plbatId)
	..s Data=$lfs(data,"^")
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	Quit $$$OK
}

/// description: 保存病区规则主表
/// input:		 inputStr^1:病区规则Id,inputStr^2:病区Id,inputStr^3:配液中心Id
/// w ##class(web.DHCSTPIVAS.BatchRules).SaveBatchrulesWard("^7^101^1")
ClassMethod SavePIVALocBat(inputStr) As %String
{
	s $zt="ThrowSavePIVALocBat"
	s plbatId=$p(inputStr,"^",1)
	s wardId=$p(inputStr,"^",2)
	s locId=$p(inputStr,"^",3)
	q:wardId="" "-1^病区为空"
	q:locId="" "-1^配液中心为空"
	s errCode=""
	s tmpPlbatId=""
	f  s tmpPlbatId=$o(^PIVALBAT(0,"Loc",locId,tmpPlbatId)) q:(tmpPlbatId="")||(errCode'="")  d
	.q:+tmpPlbatId=0
	.q:(plbatId'="")&&(tmpPlbatId=plbatId)
	.s tmpWardId=$p(^PIVALBAT(tmpPlbatId),"^",2)
	.s tmpLocId=$p(^PIVALBAT(tmpPlbatId),"^",1)
	.i (locId=tmpLocId)&&(wardId=tmpWardId) s errCode="-1^已存在该病区规则"
	q:errCode'="" errCode
	i plbatId="" d
	.&SQL(
		INSERT INTO PIVA_LocBat
		(PLBAT_Loc_DR,PLBAT_Ward_DR)
		VALUES
		(:locId,:wardId)
		)
	.i SQLCODE'=0 d
	..s errCode=$$$pivasError4Sql(%msg)
	..d ErrorRecord^DHCSTERROR("Insert:User.PIVALocBat","插入失败",%msg)
	e  d
	.s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_LocBat", plbatId)
	.&SQL(
		Update PIVA_LocBat
		set PLBAT_Loc_DR=:locId,PLBAT_Ward_DR=:wardId
		where PLBAT_RowID=:plbatId
		)
	.i SQLCODE'=0 d
	..s errCode=$$$pivasError4Sql(%msg)
	..d ErrorRecord^DHCSTERROR("Update:User.PIVALocBat","更新失败",%msg)		
	q:errCode'="" errCode
	s rowID = %ROWID
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_LocBat", rowID)
	s logSignDesc = ..GetPIVALocBatLogSignDesc(rowID)
	s logType = $s(plbatId = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_LocBat","User.PIVALocBat", ..#LogSign, rowID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))
	
	// 插入一病区为空记录
	i ..GetNullWardLocBatId(locId)="" d
	.&SQL(
		INSERT INTO PIVA_LocBat (PLBAT_Loc_DR, PLBAT_Ward_DR)
		VALUES (:locId, NULL)
	)
	q 0
ThrowSavePIVALocBat
	d ErrorRecord^DHCSTERROR("Modify:User.PIVALocBat","处理失败",$ze)
	q "-2^"_$tr($ze,"^","")
}

/// description: 批量保存病区规则主表
ClassMethod SavePIVALocBatMulti(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SavePIVALocBat(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// description:删除病区规则主表 
/// others:		todo 同时删除其他关联表
/// w ##class(web.DHCSTPIVAS.BatchRules).DeletePIVALocBat("40")
ClassMethod DeletePIVALocBat(plbatId)
{
	q:plbatId="" "-1^Id为空"
	q:$p($g(^PIVALBAT(plbatId)),"^",2)="" "-1^病区为空不能删除"
	s logSignDesc = ..GetPIVALocBatLogSignDesc(plbatId)
	s delJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_LocBat", plbatId)
	&SQL(
		DELETE
		FROM PIVA_LocBat
		WHERE PLBAT_RowID = :plbatId
	)
	q:SQLCODE'=0 $$$pivasError4Sql(%msg)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_LocBat","User.PIVALocBat", ..#LogSign, plbatId, logSignDesc, "D", delJsonStr)
	q 0
}

ClassMethod GetPIVALocBatLogSignDesc(rowID)
{
	&SQL(
		SELECT PLBAT_Loc_DR->CTLOC_Desc || '-' || PLBAT_Ward_DR->WARD_Desc INTO :ret
		FROM PIVA_LocBat WHERE %ID = :rowID
	)
	q "病区规则: " _ $g(ret)
}

/// description:药品顺序规则列表	
/// input:		inputStr^1:(Inc-药品顺序,IncFix-药品固定,InsFix-用法固定),inputStr^2:病区规则Id
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.BatchRules","QueryLocBatItm","InsFix^57")
Query QueryLocBatItm(inputStr = "") As websys.Query(ROWSPEC = "plbatItmId,incRowId,incDesc,ordNum,batNo,instrucId,instrucDesc,ordLink,ordLinkDesc,inLiquidFlag")
{
}

ClassMethod QueryLocBatItmExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s itmType=$p(inputStr,"^",1)
    s plbatId=$p(inputStr,"^",2)
    q:(itmType="")||(plbatId="") $$$OK
	s plbatItm=""
	f  s plbatItm=$o(^PIVALBAT(plbatId,"Itm",plbatItm)) q:plbatItm=""  d
	.q:+plbatItm=0
	.s plbatItmId=plbatId_"||"_plbatItm
	.s batItmData=$g(^PIVALBAT(plbatId,"Itm",plbatItm))
	.s incId=$p(batItmData,"^",1)
	.s batNo=$p(batItmData,"^",3)
	.s ordNum=$p(batItmData,"^",4)
	.s instrucId=$p(batItmData,"^",8)
	.s ordLink=$p(batItmData,"^",10)
	.s inLiquidFlag=+$p(batItmData,"^",11)
	.s quitFlag=""
	.i itmType="Inc" d			// 药品顺序规则
	..i (incId="")||(batNo'="")||(ordNum="") s quitFlag=1 q
	.e  i itmType="IncFix" d	// 药品固定规则
	..i (incId="")||(batNo="")||(ordNum'="") s quitFlag=1 q
	.e  i itmType="InsFix" d	// 用法固定规则
	..i (instrucId="")||(batNo="")||(ordNum'="") s quitFlag=1 q
	.e  i itmType="OrdLinkFix" d // 配液大类规则
	..i (ordLink="")||(batNo="")||(inLiquidFlag="") s quitFlag=1 q
	.q:quitFlag'=""
	.s instrucDesc=##class(PHA.COM.Data.Base).InstDesc(instrucId)
	.s incDesc=##class(PHA.COM.Data.Base).InciDesc(+incId)
	.s ordLinkDesc=##class(PHA.COM.Data.Base).PIVAOrderLinkDesc(+ordLink)
	.s sortIndex=batNo
	.i itmType="Inc" s sortIndex=ordNum
	.s data1=plbatItmId_"^"_incId_"^"_incDesc_"^"_ordNum_"^"_batNo
	.s data2=instrucId_"^"_instrucDesc_"^"_ordLink_"^"_ordLinkDesc_"^"_inLiquidFlag
	.s data=data1_"^"_data2
	.s QueryLocBatItmData(sortIndex,plbatItm)=data
	s sortIndex=""
	f  s sortIndex=$o(QueryLocBatItmData(sortIndex)) q:sortIndex=""  d
	.s plbatItm=""
	.f  s plbatItm=$o(QueryLocBatItmData(sortIndex,plbatItm)) q:plbatItm=""  d
	..s plbatItmData=QueryLocBatItmData(sortIndex,plbatItm)
	..s Data=$lfs(plbatItmData,"^")
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	Quit $$$OK
}

/// description: 批量保存病区规则子表
/// w ##class(web.DHCSTPIVAS.BatchRules).SavePIVALocBatItmMulti("49","858!!!!")
ClassMethod SavePIVALocBatItmMulti(plbatId, inputData)
{
	q:plbatId="" "-1^病区规则主表Id为空"
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"|@|")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"|@|",inputI)
	.q:iData=""
	.s saveRet=..SavePIVALocBatItm(plbatId,$p(iData,"!!",1),$p(iData,"!!",2),$p(iData,"!!",3),$p(iData,"!!",4))
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// description:保存病区规则子表	
/// input:		plBatId(病区规则主表Id)
/// 		    incParams(^1:药品Id).药品顺序规则
/// 			incFixParams(^1:药品Id,^2:批次).药品固定规则
/// 			insFixParams(^1:用法Id,^2:批次).用法固定规则
/// 			ordLinkFixParams(^1:大类Id,^2:批次,^3:是否参与容积规则)
/// w ##class(web.DHCSTPIVAS.BatchRules).SavePIVALocBatItm("49","","","")
ClassMethod SavePIVALocBatItm(plbatId, incParams, incFixParams, insFixParams, ordLinkFixParams)
{
	s $zt="ThrowSavePIVALocBatItm"
	q:plbatId="" "-1^病区规则主表Id为空"
	q:(incParams="")&&(incFixParams="")&&(insFixParams="")&&(ordLinkFixParams="") "-1^规则参数均为空"
	s errCode=""
	s (batNo,incId,instuctId,ordNum,type,ordLink)=""
	s inLiquid=1
	i incParams'="" d
	.s incId=$p(incParams,"^",1)
	.&SQL(SELECT PLBATI_RowID FROM PIVA_LocBatItm 
		  WHERE PLBATI_LB_Parref=:plbatId AND PLBATI_INCI_DR=:incId AND PLBATI_BatNo is null)
 	.i SQLCODE=0 s errCode="-1^该药品在药品顺序规则中已存在"
 	.&SQL(SELECT PLBATI_Order into :tmpOrdNum FROM PIVA_LocBatItm 
 	      WHERE PLBATI_LB_Parref=:plbatId AND PLBATI_INCI_DR is not null AND PLBATI_Order IS NOT NULL 
 	      ORDER BY PLBATI_Order DESC)
 	.i '$d(tmpOrdNum) s tmpOrdNum=0
 	.s ordNum=(+tmpOrdNum)+1     
 	.s type="ORDER" 
	e  i incFixParams'="" d
	.s incId=$p(incFixParams,"^",1)
	.s batNo=$p(incFixParams,"^",2)
	.&SQL(SELECT PLBATI_RowID FROM PIVA_LocBatItm 
		  WHERE PLBATI_LB_Parref=:plbatId AND PLBATI_INCI_DR=:incId AND PLBATI_BatNo IS NOT NULL)
 	.i SQLCODE=0 s errCode="-1^该药品在药品固定规则中已存在"
 	.s type="FIX" 
	e  i insFixParams'="" d
	.s instuctId=$p(insFixParams,"^",1)
	.s batNo=$p(insFixParams,"^",2)
	.&SQL(SELECT PLBATI_RowID FROM PIVA_LocBatItm 
		  WHERE PLBATI_LB_Parref=:plbatId AND PLBATI_Instr_Dr=:instuctId)
 	.i SQLCODE=0 s errCode="-1^该用法在用法固定规则中已存在"
 	.s type="FIX" 
	e  i ordLinkFixParams'="" d
	.s ordLink=$p(ordLinkFixParams,"^",1)
	.s batNo=$p(ordLinkFixParams,"^",2)
	.s inLiquid=+$p(ordLinkFixParams,"^",3)
	.&SQL(SELECT PLBATI_RowID FROM PIVA_LocBatItm 
		  WHERE PLBATI_LB_Parref=:plbatId AND PLBATI_OrdLink_DR=:ordLink)
 	.i SQLCODE=0 s errCode="-1^该配液大类在规则中已存在"
 	.s type="FIX" 
 	q:errCode'="" errCode
 	s maxSub=$o(^PIVALBAT(plbatId,"Itm",""),-1)+1
 	s plbatItmId=plbatId_"||"_maxSub
 	&SQL(
 		INSERT INTO PIVA_LocBatItm
		(PLBATI_LB_Parref,PLBATI_ChildSub,PLBATI_INCI_DR,PLBATI_Order,PLBATI_BatNo,PLBATI_Instr_Dr,PLBATI_Type,PLBATI_OrdLink_DR,PLBATI_InLiquidFlag)
		VALUES
		(:plbatId,:maxSub,:incId,:ordNum,:batNo,:instuctId,:type,:ordLink,:inLiquid)
 	)
 	s rowID = $g(%ROWID)
	i SQLCODE'=0 d
	.s errCode=$$$pivasError4Sql(%msg)
	..d ErrorRecord^DHCSTERROR("Insert:User.PIVALocBatItm","插入失败",%msg)		
	q:errCode'="" errCode
	
	s newJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_LocBatItm", rowID)
	s logSignDesc = ..GetPIVALocBatItmLogSignDesc(rowID)	
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_LocBatItm","User.PIVALocBatItm", ..#LogSign, rowID, logSignDesc, "A", newJsonStr)
	
	q 0
ThrowSavePIVALocBatItm
	d ErrorRecord^DHCSTERROR("Insert:User.PIVALocBatItm","插入失败",$ze)
	q "-2^"_$tr($ze,"^","")
}

/// description:删除病区规则子表
/// others:		
/// input:	
/// w ##class(web.DHCSTPIVAS.BatchRules).DeletePIVALocBatItm("")
ClassMethod DeletePIVALocBatItm(plbatItmId)
{
	q:plbatItmId="" "-1^病区规则子表Id为空"
	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_LocBatItm", plbatItmId)
	s logSignDesc = ..GetPIVALocBatItmLogSignDesc(plbatItmId)
	&SQL(
		DELETE
		FROM PIVA_LocBatItm
		WHERE PLBATI_RowID = :plbatItmId
	)
	q:SQLCODE'=0 $$$pivasError4Sql(%msg)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_LocBatItm","User.PIVALocBatItm", ..#LogSign, plbatItmId, logSignDesc, "D", delJsonStr)
	q 0
}

ClassMethod GetPIVALocBatItmLogSignDesc(rowID)
{
	&SQL(
		SELECT PLBATI_LB_Parref->PLBAT_Loc_DR->CTLOC_Desc || '-' || PLBATI_LB_Parref->PLBAT_Ward_DR->WARD_Desc INTO :ret
		FROM PIVA_LocBatItm
		WHERE %ID = :rowID
	)
	q "病区规则: " _ $g(ret)
}

/// description:查询容积规则列表
/// others:		
/// input:	
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.BatchRules","QueryLocBatCub",49)
Query QueryLocBatCub(inputStr = "") As websys.Query(ROWSPEC = "plbatCubId,batNo,minCub,maxCub")
{
}

ClassMethod QueryLocBatCubExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s plbatId=$p(inputStr,"^",1)
    q:plbatId="" $$$OK
	s plbatCub=""
	f  s plbatCub=$o(^PIVALBATCU(plbatId,"Cub",plbatCub))	q:plbatCub=""  d
	.q:+plbatCub=0
	.s cubData=^PIVALBATCU(plbatId,"Cub",plbatCub)
	.s maxCub=$p(cubData,"^",1)
	.s batNo=$p(cubData,"^",2)
	.s minCub=$p(cubData,"^",3)
	.s plbatCubId=plbatId_"||"_plbatCub
	.s data=plbatCubId_"^"_batNo_"^"_minCub_"^"_maxCub
	.s QueryLocBatCubData(batNo,plbatCubId)=data
	s batNo=""
	f  s batNo=$o(QueryLocBatCubData(batNo)) q:batNo=""  d
	.s plbatCubId=""
	.f  s plbatCubId=$o(QueryLocBatCubData(batNo,plbatCubId)) q:plbatCubId=""  d
	..s data=QueryLocBatCubData(batNo,plbatCubId)
	..s ^CacheTemp(repid,ind)=$lfs(data,"^")    
	..s ind=ind+1
	Quit $$$OK
}

/// description: 批量保存病区规则容积规则
ClassMethod SaveLocBatCubageMulti(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SaveLocBatCubage(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// Description:插入科室批次容量表
/// w ##class(web.DHCSTPIVAS.BatchRules).SaveLocBatCubage("^5^2^12")
ClassMethod SaveLocBatCubage(inputStr) As %String
{
	s $zt="ThrowSaveLocBatCubage"
	s plbatId=$p(inputStr,"^",1)
	s minCub=$p(inputStr,"^",2)
	s maxCub=$p(inputStr,"^",3)
	s batNo=$p(inputStr,"^",4)
	q:plbatId="" "-1^病区规则主表Id为空"
	q:(minCub="")&&(maxCub="") "-1^批次:"_batNo_",上限下限均为空"
	q:(minCub'="")&&(maxCub'="")&&(minCub>maxCub) "-1^批次:"_batNo_",下限高于上限"
	q:+minCub<0 "-1^批次:"_batNo_",下限小于0"
	q:+maxCub<0 "-1^批次:"_batNo_",上限小于0"
	i minCub'="" s minCub=+minCub
	i maxCub'="" s maxCub=+maxCub
	&SQL(
		SELECT PLBATCU_RowID FROM PIVA_LocBatCubage WHERE PLBATCU_Parref_DR=:plbatId AND PLBATCU_BatNo=:batNo 
	)
	q:SQLCODE=0 "-1^批次:"_batNo_",容量规则已维护"
	s errCode=""
	s maxSub=+$o(^PIVALBATCU(plbatId,"Cub",""),-1)+1
	&SQL(
		insert into PIVA_LocBatCubage
		(PLBATCU_Parref_DR,PLBATCU_ChildSub,PLBATCU_BatNo,PLBATCU_MIN,PLBATCU_MAX)
		values
		(:plbatId,:maxSub,:batNo,:minCub,:maxCub)
	)
	s rowID = %ROWID
	i SQLCODE'=0 d
	.s errCode=$$$pivasError4Sql(%msg)
	..d ErrorRecord^DHCSTERROR("Insert:User.PIVALocBatCubage","插入失败",%msg)		
	q:errCode'="" errCode
	s newJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_LocBatCubage", rowID)
	s logSignDesc = ..GetLocBatCubageLogSignDesc(rowID)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_LocBatCubage","User.PIVALocBatCubage", ..#LogSign, rowID, logSignDesc, "A", newJsonStr)
	q 0
ThrowSaveLocBatCubage
	d ErrorRecord^DHCSTERROR("Insert:User.PIVALocBatCubage","插入失败",$ze)
	q "-2^"_$tr($ze,"^","")
}

/// description:删除容积规则列表
/// w ##class(web.DHCSTPIVAS.BatchRules).DeleteLocBatCubage("49||4")
ClassMethod DeleteLocBatCubage(plbatCubId) As %String
{
	q:plbatCubId="" "-1^容积规则Id为空"
	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_LocBatCubage", plbatCubId)
	s logSignDesc = ..GetLocBatCubageLogSignDesc(plbatCubId)
	&SQL(
		DELETE
		FROM PIVA_LocBatCubage
		WHERE PLBATCU_RowID = :plbatCubId
	)
	q:SQLCODE'=0 $$$pivasError4Sql(%msg)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_LocBatCubage","User.PIVALocBatCubage", ..#LogSign, plbatCubId, logSignDesc, "D", delJsonStr)
	q 0
}

ClassMethod GetLocBatCubageLogSignDesc(rowID)
{
	&SQL(
		SELECT PLBATCU_Parref_DR -> PLBAT_Loc_DR -> CTLOC_Desc || ' - ' || PLBATCU_BatNo INTO :ret
		FROM PIVA_LocBatCubage
		WHERE %ID = :rowID
	)
	q $g(ret)
}

/// description: 保存其他规则
/// input:		 inputStr^1(配液中心Id),inputStr^2(大剂量优先),inputStr^3(持续量优先)
ClassMethod SavePIVAOtherRule(inputStr)
{
	s locId=$p(inputStr,"^",1)
	q:locId="" "-1^配液中心为空"
	s bigFlag=$p(inputStr,"^",2)
	s conFlag=$p(inputStr,"^",3)
	s pothId=$o(^PIVAOTHR(0,"Loc",locId,""),-1)
	s logSignDesc = "其他规则: " _ $p(^CTLOC(locId), "^", 2)
	i pothId="" d
	.&SQL(
		insert PIVA_OtherRule
		(PIVA_CubageFlag,PIVA_ContinueFlag,PIVA_PhaLocDr)
		values
		(:bigFlag,:conFlag,:locId))
	e  d
	.s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_OtherRule", pothId)
	.&sql(
		update PIVA_OtherRule 
		set PIVA_CubageFlag=:bigFlag,PIVA_ContinueFlag=:conFlag
		where PIVA_RowID=:pothId)
	q:SQLCODE'=0 $$$pivasError4Sql(%msg)
	s rowID = %ROWID
	s logType = $s(pothId = "" : "A" , 1 : "U")
	s newJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_OtherRule", rowID)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_OtherRule","User.PIVAOtherRule", ..#LogSign, rowID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))
	q 0
}

/// description: 获取其他规则
ClassMethod GetPIVAOtherRule(locId)
{
	q:locId="" ""
	s pothId=$o(^PIVAOTHR(0,"Loc",locId,""),-1)
	q:pothId="" ""
	s bigFlag=$p(^PIVAOTHR(pothId),"^",1)
	s conFlag=$p(^PIVAOTHR(pothId),"^",2)
	q bigFlag_"^"_conFlag
}

/// description: 增加病区规则时,判断是否在已存在病区为空记录
/// return:		 规则Id,否则为空
/// w ##class(web.DHCSTPIVAS.BatchRules).GetNullWardLocBatId(101)
ClassMethod GetNullWardLocBatId(locId)
{
	q:locId="" ""
	&SQL(SELECT PLBAT_RowID into :plbatId FROM PIVA_LocBat WHERE PLBAT_Loc_DR=:locId AND PLBAT_Ward_DR IS null)
	q plbatId
}

/// description:保存病区规则子表	
/// input:		origPlbItm(选中的病区规则子表Id),plbItm(移动后的病区规则子表Id)
/// w ##class(web.DHCSTPIVAS.BatchRules).MovePIVALocBatItm()
ClassMethod MovePIVALocBatItm(origPlbItm, plbItm)
{
    s $zt="ThrowMovePIVALocBatItm"
    s errCode=""
	q:(origPlbItm="")||(plbItm="") "-1^数据不全"
	s origOrdNum=$P($g(^PIVALBAT(+origPlbItm,"Itm",+$p(origPlbItm,"||",2))),"^",4)
	s ordNum=$P($g(^PIVALBAT(+plbItm,"Itm",$p(plbItm,"||",2))),"^",4)
	q:(+origOrdNum=0)||(+ordNum=0) "-1^获取顺序失败"
	s oldJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_LocBatItm", origPlbItm)

	tstart
	&sql(update PIVA_LocBatItm  set PLBATI_Order=:ordNum where PLBATI_RowID=:origPlbItm)
	i SQLCODE'=0 d
	.s errCode=$$$pivasError4Sql(%msg)
	.d ErrorRecord^DHCSTERROR("Update:User.PIVALocBatItm","更新",SQLCODE_":"_%msg)
	i errCode'="" tro  q errCode
	&sql(update PIVA_LocBatItm  set PLBATI_Order=:origOrdNum where PLBATI_RowID=:plbItm)
	i SQLCODE'=0 d
	.s errCode=$$$pivasError4Sql(%msg)
	.d ErrorRecord^DHCSTERROR("Update:User.PIVALocBatItm","更新",SQLCODE_":"_%msg)
	i errCode'="" tro  q errCode
	tcommit	

	s logSignDesc = ..GetPIVALocBatItmLogSignDesc(plbItm)
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_LocBatItm", origPlbItm)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_LocBatItm","User.PIVALocBatItm", ..#LogSign, %ROWID, logSignDesc, "U", newJsonStr, $g(oldJsonStr))
	q 0
ThrowMovePIVALocBatItm
	d ErrorRecord^DHCSTERROR("Update:User.PIVALocBatItm","更新失败",$ze)
	q "-2^"_$tr($ze,"^","")
}

/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.BatchRules","SortTypePointer","User.DHCPHCPivaCat","89")
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.BatchRules","SortTypePointer","User.INCItm","89","p","p")
Query SortTypePointer(type, loc, q, pointer) As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod SortTypePointerExecute(ByRef qHandle As %Binary, type, loc, q, pointer) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	q:(type = "")||(loc = "") $$$OK
	s q = "%"_$$ALPHAUP^SSUTIL4(q)_"%"
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s hosp = $p(^CTLOC(loc), "^", 22)
    if (type = "User.INCItm"){
		
		if (pointer '= ""){
			s sqlStr = "SELECT %ID, INCI_Desc FROM SQLUSER.INC_Itm WHERE %ID = '" _ pointer _ "' UNION "
		}
		s sqlStr = sqlStr _ "select distinct top 100 inca_inci_dr, inca_inci_dr->inci_desc from inc_alias "_
						    "where %ALPHAUP(inca_text) like '"_q_"' and inca_inci_dr->inci_incsc_dr in "_ 
						    "(Select scgr_stkcat_dr from dhc_stkcatgrprelations Where scgr_scg_parref->SCG_Type='G')"
	}elseif (type = "User.DHCPHCPivaCat"){
		s sqlStr = "SELECT %ID, PHCPivaCat_Desc FROM SQLUSER.DHC_PHCPivaCat"
	}

    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    { 
    	d GetHospShowFlag
    	continue:($g(showFlag) '= "Y")
    	s rowID = result.GetData(1) 
    	s description = result.GetData(2) 
    	if (type = "User.INCItm"){
	    	s description = ##class(PHA.COM.Data.Base).InciDesc(rowID)
    	}
        if (type = "User.DHCPHCPivaCat"){
	    	s description = ##class(PHA.COM.Data.Base).PHCPivaCatDesc(rowID)
    	}
		s ^CacheTemp(repid,ind) = $lb(rowID, description)    
		s ind=ind+1
    }
    d result.Close()
	Quit $$$OK
GetHospShowFlag
	s tableName = $case(type,
					"User.DHCPHCPivaCat": "DHC_PHCPivaCat",
					"User.INCItm": "INC_Itm",
					:"Something")
	
	s showFlag = ##class(PHA.FACE.IN.Com).GetShowDataFlag(tableName, result.GetData(1), hosp) 
	q
}

/// description:删除顺序规则规则列表
/// w ##class(web.DHCSTPIVAS.BatchRules).DeleteLocBatSort("68||2")
ClassMethod DeleteLocBatSort(rowID) As %String
{
	q:rowID="" "-1^顺序规则Id为空"
	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_LocBatSort", rowID)
	s logSignDesc = ..GetLocBatSortLogSignDesc(rowID)
	&SQL(
		DELETE
		FROM SQLUSER.PIVA_LocBatSort
		WHERE %ID = :rowID
	)
	q:SQLCODE'=0 $$$pivasError4Sql(%msg)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_LocBatSort","User.PIVALocBatSort", ..#LogSign, rowID, logSignDesc, "D", delJsonStr)
	q 0
}

ClassMethod GetLocBatSortLogSignDesc(rowID)
{
	q "顺序规则"
}

/// Description: 批量保存病区规则顺序规则
ClassMethod SaveLocBatSortMulti(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SaveLocBatSort(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// Description: 保存顺序规则
/// w ##class(web.DHCSTPIVAS.BatchRules).SaveLocBatSort("^5^2^12")
ClassMethod SaveLocBatSort(inputStr) As %String
{
	s $zt = "ThrowSaveLocBatCubage"
	s plbatId = $p(inputStr, "^", 1)
	s rowID = $p(inputStr, "^", 2)
	s type = $p(inputStr, "^", 3)
	s pointer = $p(inputStr, "^", 4)
	s sortCode = $p(inputStr, "^", 5)
	q:(plbatId = "") "-1^病区规则主表Id为空"
	q:(type = "") "-1^类型为空"
	q:(plbatId = "") "-1^类型指向为空"
	q:(sortCode = "") "-1^顺序为空"

	s errCode=""
	
	if (rowID = ""){
		&SQL(
			INSERT INTO PIVA_LocBatSort (PLBATS_LB_Parref, PLBATS_Type, PLBATS_Pointer, PLBATS_SortCode)
			VALUES (:plbatId, :type, :pointer, :sortCode)
		)
	}else{
		&SQL(
			UPDATE PIVA_LocBatSort
			SET PLBATS_Type = :type,
			    PLBATS_Pointer = :pointer,
			    PLBATS_SortCode = :sortCode
			WHERE %ID = :rowID
		)
	}

	s rowID = %ROWID
	if (SQLCODE '= 0){
		s errCode=$$$pivasError4Sql(%msg)
		d ErrorRecord^DHCSTERROR("Save:User.PIVALocBatSort", "保存失败", $g(%msg))	
	}	
	q:(errCode '= "") errCode
	s newJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_LocBatSort", rowID)
	s logSignDesc = ..GetLocBatSortLogSignDesc(rowID)
	//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_LocBatSort","User.PIVALocBatSort", ..#LogSign, rowID, logSignDesc, "A", newJsonStr)
	q 0
ThrowSaveLocBatCubage
	d ErrorRecord^DHCSTERROR("Save:User.PIVALocBatSort","插入失败",$ze)
	q "-2^"_$tr($ze,"^","")
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.BatchRules","QueryLocBatSort","68")
Query QueryLocBatSort(inputStr = "") As websys.Query(ROWSPEC = "rowID, type, typeDesc, pointer, pointerDesc, sortCode")
{
}

ClassMethod QueryLocBatSortExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid = $i(^CacheTemp)
	s qHandle = $lb(0, repid, 0)
	s ind = 1
    s plbat = $p(inputStr, "^", 1)
    q:(plbat = "") $$$OK
	s itm = ""
	for {
		s itm = $o(^PIVALBAT(plbat, "Sort", itm), 1, sortData) q:(itm = "")
		s rowID = plbat _ "||" _ itm
		s type = $p(sortData, "^", 1)

		s pointer = $p(sortData, "^", 2)
		if (type = "User.INCItm"){
			s typeDesc = ..Translate("药品") // @translate
			s pointerDesc = ##class(PHA.COM.Data.Base).InciDesc(pointer)
		}elseif (type = "User.DHCPHCPivaCat"){
			s typeDesc = ..Translate("配液小类") // @translate
			s pointerDesc = ##class(PHA.COM.Data.Base).PHCPivaCatDesc(pointer)
		}
		s sortCode = $p(sortData, "^", 3)
		s calcData(sortCode) = $lb(rowID, type, typeDesc, pointer, pointerDesc, sortCode)	
	}
	s sortIndex = ""
	for {
		s sortIndex = $o(calcData(sortIndex), 1, data) q:(sortIndex = "")
		s ^CacheTemp(repid,ind) = data    
		s ind=ind+1
	}
	Quit $$$OK
}

}
