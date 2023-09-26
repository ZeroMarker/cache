Import SQLUSER

/// Description:配液收费规则
Class web.DHCSTPIVAS.FeeRule Extends %RegisteredObject
{

Parameter AppTable [ Final ] = "PHAPIVAS_FeeRule";

Parameter LogSign [ Final ] = "配液中心 - 配置收费规则";

/// Deccription:收费规则
/// Table:      User.PHAPIVASFeeRule
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.FeeRule","PHAPIVASFeeRule")
Query PHAPIVASFeeRule(HospId = "") As websys.Query(ROWSPEC = "ruleID,ruleDesc")
{
}

ClassMethod PHAPIVASFeeRuleExecute(ByRef qHandle As %Binary, HospId = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s ruleID=0
	f  s ruleID=$o(^CF.PHA.PIVAS.FeeRule(ruleID)) q:ruleID=""  d
	.s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,ruleID,HospId) //医院级别授权
	.q:flag="N"
	.s ruleDesc=$p(^CF.PHA.PIVAS.FeeRule(ruleID),"^",1)
	.s ^CacheTemp(repid,ind)=$lb(ruleID,ruleDesc)    
	.s ind=ind+1
	Quit $$$OK
}

/// Deccription:收费规则-判断规则
/// Table:      User.PHAPIVASFeeRuleItm
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.FeeRule","PHAPIVASFeeRuleItm",4)
Query PHAPIVASFeeRuleItm(RuleID = "") As websys.Query(ROWSPEC = "ruleItmID,type,typeDesc,operate,operateDesc,typeVal,typeValDesc")
{
}

ClassMethod PHAPIVASFeeRuleItmExecute(ByRef qHandle As %Binary, RuleID = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:RuleID="" $$$OK
	s ruleItm=0
	f  s ruleItm=$o(^CF.PHA.PIVAS.FeeRule(RuleID,"I",ruleItm)) q:ruleItm=""  d
	.s FeeRuleIData=^CF.PHA.PIVAS.FeeRule(RuleID,"I",ruleItm)
	.s ruleItmID=RuleID_"||"_ruleItm
	.s type=$p(FeeRuleIData,"^",1)
	.s typeDesc=..TypeToDesc(type)
	.s operate=$p(FeeRuleIData,"^",2)
	.s operateDesc=..OperateToDesc(operate)
	.s typeVal=$p(FeeRuleIData,"^",3)
	.s typeValDesc=..TypeValToDesc(type,typeVal)
	.s ^CacheTemp(repid,ind)=$lb(ruleItmID,type,typeDesc,operate,operateDesc,typeVal,typeValDesc)    
	.s ind=ind+1
	Quit $$$OK
}

/// w ##class(web.DHCSTPIVAS.FeeRule).SelectPHAPIVASFeeRuleItm("4||1")
ClassMethod SelectPHAPIVASFeeRuleItm(RuleItmID)
{
	s json={}
	s FeeRuleIData=^CF.PHA.PIVAS.FeeRule(+RuleItmID,"I",+$p(RuleItmID,"||",2))
	s type=$p(FeeRuleIData,"^",1)
	s operate=$p(FeeRuleIData,"^",2)
	s typeVal=$p(FeeRuleIData,"^",3)
	s json.type=type
	s json.operate=operate
	i type="ARCIM" d
	.s typeValDesc=..TypeValToDesc(type,typeVal)
	.s typeValObj={}
	.s typeValObj.RowId=typeVal
	.s typeValObj.Description=typeValDesc
	.s json.typeVal=typeValObj
	.s json.typeValText=""
	e  d
	.s json.typeVal=""
	.s json.typeValText=typeVal
	q json.%ToJSON()
}

/// Deccription:收费规则-收取规则
/// Table:      User.PHAPIVASFeeRuleLink
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.FeeRule","PHAPIVASFeeRuleLink",4)
Query PHAPIVASFeeRuleLink(RuleID = "") As websys.Query(ROWSPEC = "ruleLinkID,arcim,arcimDesc,qty")
{
}

ClassMethod PHAPIVASFeeRuleLinkExecute(ByRef qHandle As %Binary, RuleID = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:RuleID="" $$$OK
	s ruleLink=0
	f  s ruleLink=$o(^CF.PHA.PIVAS.FeeRule(RuleID,"L",ruleLink)) q:ruleLink=""  d
	.s FeeRuleLData=^CF.PHA.PIVAS.FeeRule(RuleID,"L",ruleLink)
	.s ruleLinkID=RuleID_"||"_ruleLink
	.s arcim=$p(FeeRuleLData,"^",1)
	.s arcimDesc=##class(PHA.COM.Data.Base).ArcimDesc(arcim)
	.s qty=$p(FeeRuleLData,"^",2)
	.s ^CacheTemp(repid,ind)=$lb(ruleLinkID,arcim,arcimDesc,qty)    
	.s ind=ind+1
	Quit $$$OK
}

/// Description: 批量保存规则
ClassMethod SaveRuleMulti(inputData, HospId = "")
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SaveRule(iData, HospId)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// Description: 保存规则
/// Input:		 inputStr
/// 			 	^1:Id
/// 			 	^2:名称
/// Return:		 +ret=0 成功
/// w ##class(web.DHCSTPIVAS.FeeRule).SaveRule("测试")
ClassMethod SaveRule(inputStr, HospId = "")
{
	s ruleID=$p(inputStr,"^",1)
	s ruleDesc=$p(inputStr,"^",2)
  	q:ruleDesc="" "-1^名称不能为空"
  	s tmpId=..DescToID(ruleDesc,HospId)  	
	q:(tmpId'="")&&(tmpId'=ruleID) "-1^名称已存在"
  	if (ruleID=""){	
	  	&SQL(
	  		INSERT INTO PHAPIVAS_FeeRule (PFR_Desc)
	  		VALUES (:ruleDesc) 
	  	)
	  	if (SQLCODE=0) {
	    	s Rowid=$p(%ROWID,$c(1))
	    	i HospId'="" d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,Rowid,HospId)
		}
	}else{
		s oldJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PHAPIVAS_FeeRule", ruleID)
		&SQL(
			UPDATE PHAPIVAS_FeeRule 
			SET PFR_Desc=:ruleDesc
			WHERE PFR_RowID=:ruleID
		)
	}
	q:SQLCODE'=0 "-1^保存失败"_$g(%msg)
 	s rowID = %ROWID
	s logSignDesc = ruleDesc
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PHAPIVAS_FeeRule", rowID)
	s logType = $s(ruleID = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHAPIVAS_FeeRule","User.PHAPIVASFeeRule", ..#LogSign, rowID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))	
	q 0
}

/// Description: 批量保存规则
ClassMethod SaveRuleItmMulti(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SaveRuleItm(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// Description: 保存规则子表-判断规则
/// Table:		 User.PHAPIVASFeeRuleItm
/// Return:		 +ret=0 成功
/// w ##class(web.DHCSTPIVAS.FeeRule).SaveRuleItm("^4^ARCIM^[^21||1")
ClassMethod SaveRuleItm(inputStr)
{
	s ruleItmID=$p(inputStr,"^",1)
	s ruleID=$p(inputStr,"^",2)
	s type=$p(inputStr,"^",3)
	s operate=$p(inputStr,"^",4)
	s typeVal=$p(inputStr,"^",5)
	q:ruleID="" "-1^收费规则没空"
  	q:type="" "-1^类型不能为空"
  	q:operate="" "-1^关系不能为空"
  	q:typeVal="" "-1^值不能为空"
  	s ruleDesc = $p(^CF.PHA.PIVAS.FeeRule(ruleID), "^", 1)
  	s chkInfo=""
  	if (ruleItmID="" ){
	  	if (type="ARCIM"){
		  	&SQL(
		  		SELECT * FROM PHAPIVAS_FeeRuleItm 
		  		WHERE PFRI_PFR_ParRef=:ruleID AND PFRI_Type=:type AND PFRI_Operate=:operate AND PFRI_TypeValue=:typeVal
		  	)
	  	}else{
			&SQL(
		  		SELECT * FROM PHAPIVAS_FeeRuleItm 
		  		WHERE PFRI_PFR_ParRef=:ruleID AND PFRI_Type=:type AND PFRI_Operate=:operate
		  	)	
		}
	  	i SQLCODE=0 s chkInfo="-1^已存在相同规则"
  	}else {
	  	if (type="ARCIM"){
		  	&SQL(
		  		SELECT * FROM PHAPIVAS_FeeRuleItm 
		  		WHERE PFRI_PFR_ParRef=:ruleID AND PFRI_Type=:type AND PFRI_Operate=:operate AND PFRI_TypeValue=:typeVal
		  		AND PFRI_RowID!=:ruleItmID
		  	)
	  	}else{
			&SQL(
		  		SELECT * FROM PHAPIVAS_FeeRuleItm 
		  		WHERE PFRI_PFR_ParRef=:ruleID AND PFRI_Type=:type AND PFRI_Operate=:operate
		  		AND PFRI_RowID!=:ruleItmID
		  	)	
		}
		i SQLCODE=0 s chkInfo="-1^已存在相同规则"
	}	
  	q:chkInfo'="" chkInfo
  	if (ruleItmID=""){
	  	s maxSub=$o(^CF.PHA.PIVAS.FeeRule(ruleID,"I",""),-1)+1
	  	&SQL(
	  		INSERT INTO PHAPIVAS_FeeRuleItm 
	  		(PFRI_PFR_ParRef,PFRI_ChildSub,PFRI_Type,PFRI_Operate,PFRI_TypeValue)
	  		VALUES 
	  		(:ruleID,:maxSub,:type,:operate,:typeVal) 
	  	)
	}else{
		s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PHAPIVAS_FeeRuleItm", ruleItmID)
		&SQL(
			UPDATE PHAPIVAS_FeeRuleItm 
			SET PFRI_Type=:type,PFRI_Operate=:operate,PFRI_TypeValue=:typeVal
			WHERE PFRI_RowID=:ruleItmID
		)
	}
	q:SQLCODE'=0 "-1^保存失败"_$g(%msg)
 	s rowID = %ROWID
	s logSignDesc = "关联关系:" _ ruleDesc
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PHAPIVAS_FeeRuleItm", rowID)
	s logType = $s(ruleItmID = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHAPIVAS_FeeRuleItm","User.PHAPIVASFeeRuleItm", ..#LogSign, rowID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))
	q 0
}

/// Description: 批量保存规则
ClassMethod SaveRuleLinkMulti(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SaveRuleLink(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// Description: 保存规则子表-收取规则
/// Table:		 User.PHAPIVASFeeRuleLink
/// Return:		 +ret=0 成功
/// w ##class(web.DHCSTPIVAS.FeeRule).SaveRuleLink("^4^1||1^3")
ClassMethod SaveRuleLink(inputStr)
{
	s ruleLinkID=$p(inputStr,"^",1)	// 空,没有修改
	s ruleID=$p(inputStr,"^",2)
	s arcim=$p(inputStr,"^",3)
	s qty=$p(inputStr,"^",4)
	q:ruleID="" "-1^收费规则没空"
  	q:arcim="" "-1^医嘱项不能为空"
  	q:+qty=0 "-1^数量不能为空或为0"
  	q:qty["." "-1^数量不能为小数"
  	&SQL(
  		SELECT * FROM PHAPIVAS_FeeRuleLink 
  		WHERE PFRL_PFR_ParRef=:ruleID and PFRL_Arcim_DR=:arcim
  	)
  	q:SQLCODE=0 0
  	if (ruleLinkID=""){
	  	s maxSub=$o(^CF.PHA.PIVAS.FeeRule(ruleID,"L",""),-1)+1
	  	&SQL(
	  		INSERT INTO PHAPIVAS_FeeRuleLink 
	  		(PFRL_PFR_ParRef,PFRL_ChildSub,PFRL_Arcim_DR,PFRL_Qty)
	  		VALUES 
	  		(:ruleID,:maxSub,:arcim,:qty) 
	  	)
	}else{
		s oldJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PHAPIVAS_FeeRuleLink", ruleLinkID)
		&SQL(
			UPDATE PHAPIVAS_FeeRuleLink 
			SET PFRL_Arcim_DR=:arcim,PFRL_Qty=:qty
			WHERE PFRL_RowID=:ruleLinkID
		)
	}
	q:SQLCODE'=0 "-1^保存失败"_$g(%msg)
	s ruleDesc = $p(^CF.PHA.PIVAS.FeeRule(ruleID), "^", 1)
 	s rowID = %ROWID
	s logSignDesc = "关联收费医嘱项:" _ ruleDesc
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PHAPIVAS_FeeRuleLink", rowID)
	s logType = $s(ruleLinkID = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHAPIVAS_FeeRuleLink","User.PHAPIVASFeeRuleLink", ..#LogSign, rowID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))

	q 0
}

/// Description: 删除规则
/// w ##class(web.DHCSTPIVAS.FeeRule).DeleteRule("1")
ClassMethod DeleteRule(RowID, HospId = "")
{
	q:RowID="" "-1^ID为空"
	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PHAPIVAS_FeeRule", RowID)
	s logSignDesc = $p(^CF.PHA.PIVAS.FeeRule(RowID), "^", 1)
	&SQL(
		DELETE FROM PHAPIVAS_FeeRule 
		WHERE PFR_RowID=:RowID
	)
	if (SQLCODE=0){
		i HospId'="" d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#AppTable,RowID,HospId)
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHAPIVAS_FeeRule","User.PHAPIVASFeeRule", ..#LogSign, RowID, logSignDesc, "D", delJsonStr)	
	}
	q SQLCODE
}

/// Description: 删除规则子表-判断条件
ClassMethod DeleteRuleItm(RowID)
{
	q:RowID="" "-1^ID为空"
	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PHAPIVAS_FeeRuleItm", RowID)
	s logSignDesc = "关联关系: "_$p(^CF.PHA.PIVAS.FeeRule(+RowID), "^", 1)
	&SQL(
		DELETE FROM PHAPIVAS_FeeRuleItm 
		WHERE PFRI_RowID=:RowID
	)
	if (SQLCODE = 0){
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHAPIVAS_FeeRuleItm","User.PHAPIVASFeeRuleItm", ..#LogSign, RowID, logSignDesc, "D", delJsonStr)	
	}
	q SQLCODE
}

/// Description: 删除规则子表-收费条件
ClassMethod DeleteRuleLink(RowID)
{
	q:RowID="" "-1^ID为空"
	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PHAPIVAS_FeeRuleLink", RowID)
	s logSignDesc = "关联收费医嘱项: "_$p(^CF.PHA.PIVAS.FeeRule(+RowID), "^", 1)	
	&SQL(
		DELETE FROM PHAPIVAS_FeeRuleLink 
		WHERE PFRL_RowID=:RowID
	)
	if (SQLCODE = 0){
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHAPIVAS_FeeRuleLink","User.PHAPIVASFeeRuleLink", ..#LogSign, RowID, logSignDesc, "D", delJsonStr)	
	}
	q SQLCODE
}

/// w ##class(web.DHCSTPIVAS.FeeRule).TypeToDesc("ARCIM")
ClassMethod TypeToDesc(Type)
{
	q $case(Type,
			"ARCIM":"药品",
			"MLSPECMIN":"规格[ML]下限",
			"MLSPECMAX":"规格[ML]上限",
			"MLLIQUIDMIN":"液体总量下限",
			"MLLIQUIDMAX":"液体总量上限",
			:"")
}

/// w ##class(web.DHCSTPIVAS.FeeRule).OperateToDesc("ARCIM")
ClassMethod OperateToDesc(Operate)
{
	q $case(Operate,"[":"包含","]":"不包含",">=":"大于等于","<":"小于",:"")
}

/// w ##class(web.DHCSTPIVAS.FeeRule).TypeValToDesc("ARCIM")
ClassMethod TypeValToDesc(Type, TypeValue)
{
	q:Type'="ARCIM" TypeValue
	q $p($g(^ARCIM(+TypeValue,+$p(TypeValue,"||",2),1)),"^",2)
}

ClassMethod DescToID(desc, HospId)
{
	s RetRowID=""
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
	s Rowid=0
	f  s Rowid=$o(^CF.PHA.PIVAS.FeeRule(Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s tmpDesc=$p(^CF.PHA.PIVAS.FeeRule(Rowid),"^",1)
	.q:tmpDesc'=desc
	.s RetRowID=Rowid
	q $g(RetRowID)
}

}
