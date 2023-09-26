Import SQLUser

/// Description: 配液流程状态维护
Class web.DHCSTPIVAS.ParaState Extends web.DHCSTPIVAS.Common
{

Parameter LogSign [ Final ] = "配液中心 - 流程定制";

/// description: 查询配液状态
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.ParaState","PIVAState",102)		
Query PIVAState(inputStr = "") As websys.Query(ROWSPEC = "psRowId:%String,psNumber:%Integer,psName:%String,psFlag:%String,psSysFlag:%String,psRetFlag:%String,psDispFlag:%String,psSingleFlag:%String,psLocDesc:%String,psType:%String,psLocId:%String,psTypeDesc:%String,psPackIgnore:%String,psPackDisp:%String,psFeeFlag:%String")
{
}

ClassMethod PIVAStateExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	s group=$s($d(%session):$g(%session.Data("LOGON.GROUPID")),1:"")
	s PivaLocId=$p(inputStr,"^",1)
	s ioType=$p(inputStr,"^",2)
	i PivaLocId'="" s group=""
	S ind=1
	S psNumberIndex=0
	F  S psNumberIndex=$o(^PIVAS(0,"NUMBER",psNumberIndex)) Q:psNumberIndex=""  D
	.s psRowId=""
	.f  S psRowId=$o(^PIVAS(0,"NUMBER",psNumberIndex,psRowId)) q:psRowId=""  d 
	..Q:'$D(^PIVAS(psRowId))
 	..S psNumber=$P(^PIVAS(psRowId),"^",1)
 	..S psName=##class(PHA.COM.Data.Base).PIVASStateName(psRowId)
 	..S psFlag=$P(^PIVAS(psRowId),"^",3)
 	..S psSysFlag=$P(^PIVAS(psRowId),"^",4)
 	..S psRetFlag=$P(^PIVAS(psRowId),"^",5)
 	..S psDispFlag=$P(^PIVAS(psRowId),"^",6)
 	..S psSingleFlag=$P(^PIVAS(psRowId),"^",8)
 	..S psLocDr=$P(^PIVAS(psRowId),"^",7)
 	..q:(PivaLocId'="")&&(PivaLocId'=psLocDr)
 	..q:(group'="")&&('$d(^SSU("SSGRP",group,"ST",0,"Loc",psLocDr))) ; yunhaibao20170122,按登录安全组过滤
 	..s psLocDesc=""
 	..i psLocDr'="" d
 	...S psLocDesc=##class(PHA.COM.Data.Base).LocDesc(psLocDr)
 	..S psType=$P(^PIVAS(psRowId),"^",9)
 	..q:(psType'=ioType)
 	..s psTypeDesc=psType
 	..i psType="I" s psTypeDesc=..Translate("住院", "dhcpha.pivas.parastate.csp")
 	..i psType="O" s psTypeDesc=..Translate("门诊", "dhcpha.pivas.parastate.csp")
 	..s psPackIgnore=$P(^PIVAS(psRowId),"^",10)
 	..s psPackDisp=$P(^PIVAS(psRowId),"^",11)
 	..s psFeeFlag=$P(^PIVAS(psRowId),"^",12)
 	..s tmpNum=1000-psNumber
 	..S index=psType_"^"_psLocDr_"^"_tmpNum
 	..S GetStateArr(index)=psRowId_"^"_psNumber_"^"_psName_"^"_psFlag_"^"_psSysFlag_"^"_psRetFlag_"^"_psDispFlag_"^"_psSingleFlag_"^"_psLocDesc_"^"_psType_"^"_psLocDr_"^"_psTypeDesc_"^"_psPackIgnore_"^"_psPackDisp _ "^" _ psFeeFlag	
 	s index=""
 	f  s index=$o(GetStateArr(index),-1) q:index=""  d
 	.s data=GetStateArr(index)
	.D OutputRow
 	Q $$$OK
OutputRow
	S Data=$lfs(data,"^")
 	S ^CacheTemp(repid,ind)=Data	
 	S ind=ind+1
 	Q
}

/// description: 流程状态下拉列表
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.ParaState","StateNum")
Query StateNum() As websys.Query(ROWSPEC = "psName:%String,psRowId:%String,psNumber:%String,psFlag:%String")
{
}

ClassMethod StateNumExecute(ByRef qHandle As %Binary) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	S psRowId=""
	F  S psRowId=$o(^PIVASN(psRowId)) Q:(psRowId="")||(psRowId=0)  D
 	.S psNumber=$P(^PIVASN(psRowId),"^",1)
 	#; .S psName=$P(^PIVASN(psRowId),"^",2)
    .s psName=##class(PHA.COM.Data.Base).PIVASStateNumberName(psRowId)
 	.S psFlag=$P(^PIVASN(psRowId),"^",3)
 	.Q:psFlag'="Y"
	.D OutputNumRow
 	Q $$$OK
OutputNumRow
	S Data=$lb(psName,psRowId,psNumber,psFlag)
 	S ^CacheTemp(repid,ind)=Data	
 	S ind=ind+1
 	Q
}

/// Descript： 	删除流程
ClassMethod DeletePIVAState(psdr) As %String
{
	q:psdr="" -1
	q:$d(^PIVA(0,"PS",psdr)) -100	//已使用
	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_State", psdr)
	s logSignDesc = ..GetDataLogSignDesc(psdr)
	&sql(
		DELETE
		FROM PIVA_State
		WHERE PS_RowID = :psdr
	) 
	
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_State","User.PIVAState", ..#LogSign, psdr, logSignDesc, "D", delJsonStr)

	q SQLCODE
}

/// creator:	yunhaibao
/// createdate: 2018-01-09
/// description:保存配液流程定制
/// w ##class(web.DHCSTPIVAS.ParaState).SavePIVAState(params)
ClassMethod SavePIVAState(inputStr)
{
	s psStateId = $p(inputStr, "^", 1)
	s psNumber = $p(inputStr, "^", 2)
	s psUseFlag = $p(inputStr, "^", 3)
	s psDispFlag = $p(inputStr, "^", 4)
	s psSingleFlag = $p(inputStr, "^", 5)
	s psSysFlag = $p(inputStr, "^", 6)
	s psLocId = $p(inputStr, "^", 7)
	s psIOType = $p(inputStr, "^", 8)
	s psPackIgnore = $p(inputStr, "^", 9)
	s psPackDisp = $p(inputStr, "^", 10)
	s psFeeFlag = $p(inputStr, "^", 11)
	q:(psNumber = "") ..Translate("-1^请选择流程名称") // @translate
	q:(psLocId = "") ..Translate("-1^请选择配液中心") // @translate
	q:(psIOType = "") ..Translate("-1^请选择流程类型") // @translate
	&SQL(
		SELECT PSN_Name into :psName FROM PIVA_StateNumber 
		WHERE PSN_Number = :psNumber
	)
	q:(psName = "") ..Translate("-1^请选择流程类型") // @translate
	if psStateId = "" {
		&SQL(
			SELECT * FROM PIVA_State 
			WHERE PS_Number=:psNumber AND PS_Loc_Dr=:psLocId AND PS_TypeFlag=:psIOType
		)
	}else{
		&SQL(
			SELECT * FROM PIVA_State 
			WHERE PS_Number=:psNumber AND PS_Loc_Dr=:psLocId AND PS_TypeFlag=:psIOType and PS_RowID<>:psStateId
		)
	}
	q:(SQLCODE = 0) ..Translate("-1^该配液中心已维护该类型的该流程") // @translate
	
	if psStateId = "" {
		&SQL(
			INSERT INTO PIVA_State (PS_Number, PS_Name, PS_Loc_Dr, PS_TypeFlag, PS_Flag,
			                        PS_SysFlag, PS_DispFlag, PS_SingleFlag, PS_PackIgnore,
			                        PS_RetFlag, PS_PackDisp, PS_FeeFlag)
			VALUES (:psNumber, :psName, :psLocId, :psIOType, :psUseFlag,
			        :psSysFlag, :psDispFlag, :psSingleFlag, :psPackIgnore,
			        'N', :psPackDisp, :psFeeFlag)
					)        
		q:(SQLCODE '= 0) $$$pivasError4Sql(%msg)
		
	}else{
		s oldJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_State", psStateId)
		&SQL(
			UPDATE PIVA_State
			SET PS_TypeFlag=:psIOType,
			    PS_Flag=:psUseFlag,
			    PS_DispFlag=:psDispFlag,
			    PS_SingleFlag=:psSingleFlag,
			    PS_PackIgnore=:psPackIgnore,
			    PS_PackDisp=:psPackDisp,
			    PS_FeeFlag=:psFeeFlag
			WHERE PS_RowID = :psStateId
		)
        q:(SQLCODE '= 0) $$$pivasError4Sql($g(%msg))
	}
	s rowID = %ROWID
	s logSignDesc = ..GetDataLogSignDesc(rowID)
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_State", rowID)
	s logType = $s(psStateId = "" : "A" , 1 : "U")
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_State","User.PIVAState", ..#LogSign, %ROWID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))
	q ..Translate("0^保存成功") // @translate
}

ClassMethod GetDataLogSignDesc(rowID)
{
	&SQL(
		SELECT PS_Loc_Dr -> CTLOC_Desc || ' - ' || PS_Name
		INTO :logSignDesc
		FROM SQLUSER.PIVA_State
		WHERE %ID = :rowID
	)
	q $g(logSignDesc)
}

}
