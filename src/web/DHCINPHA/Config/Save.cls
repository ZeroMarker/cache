Import SQLUSER

/// description: 保存-住院药房客户端配置
Class web.DHCINPHA.Config.Save Extends %RegisteredObject
{

Parameter TableName [ Final ] = "DHC_PhaLocConfig";

Parameter TableClassName [ Final ] = "User.DHCPhaLocConfig";

Parameter PriTableName [ Final ] = "DHC_PhaPriority";

Parameter PriTableClassName [ Final ] = "User.DHCPhaPriority";

Parameter PriDisTypeTableName [ Final ] = "DHC_PhaPriorDisType";

Parameter PriDisTypeTableClassName [ Final ] = "User.DHCPhaPriorDisType";

Parameter LogSign [ Final ] = "住院药房 - 医嘱优先级与发药类别设置";

/// description: 保存用户与Mac
ClassMethod SaveConfig(InputStr)
{
	s PLCId=$p(InputStr,"^",1)
	s LocId=$p(InputStr,"^",2)
	s ConfigDesc=$p(InputStr,"^",3)
	s UserId=$p(InputStr,"^",4)
	s Mac=$p(InputStr,"^",5)	
	q:ConfigDesc="" "-1^配置名称为空"
	q:LocId="" "-1^药房为空"
	q:(UserId="")&&(Mac="") "-1^用户与MAC地址均为空"
	q:(UserId'="")&&(Mac'="") "-1^用户与MAC地址同时存在数据"
	// 判断存在
	s errInfo=""
	s plcId=0
	f  s plcId=$o(^DHCPHLC(plcId)) q:(plcId="")||(errInfo'="")  d
	.s plcData=^DHCPHLC(plcId)
	.s locId=$p(plcData,"^",1)
	.q:(LocId'="")&&(LocId'=locId)
	.s plcDesc=$p(plcData,"^",2)
	.s mac=$p(plcData,"^",3)
	.s userId=$p(plcData,"^",6)
	.q:(PLCId'="")&&(PLCId=plcId)
	.i ConfigDesc=plcDesc s errInfo="-1^已存在该配置名称" q
	.i (UserId'="")&&(UserId=userId) s errInfo="-1^已存在该用户" q
	.i (Mac'="")&&(Mac=mac) s errInfo="-1^已存在该MAC地址" q
	q:errInfo'="" errInfo
	i PLCId="" d
	.&SQL(
		INSERT INTO DHC_PhaLocConfig 
		(PLC_Loc_DR, PLC_Desc, PLC_MAC, PLC_DispCat_Dr, PLC_Priority, PLC_SSUSR_DR)
		VALUES
		(:LocId,:ConfigDesc,:Mac,NULL,NULL,:UserId)
	 )
	.i SQLCODE'=0 s errInfo="-1^增加失败,SQLCODE:"_SQLCODE_","_$g(%msg)
	e  d
    .s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, PLCId)
	.&SQL(
		UPDATE DHC_PhaLocConfig 
		SET PLC_Loc_DR=:LocId, PLC_Desc=:ConfigDesc, PLC_MAC=:Mac, PLC_SSUSR_DR=:UserId
		WHERE PLC_ROWID=:PLCId
	 )
	.i SQLCODE'=0 s errInfo="-1^修改失败,SQLCODE:"_SQLCODE_","_$g(%msg)
	q:errInfo'="" errInfo
    #; 日志
    s rowID = $g(%ROWID) 
	s logSignDesc=..GetDataLogSignDesc(rowID)
	s newJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, rowID)
	s logType = $s(PLCId = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#TableName, ..#TableClassName, ..#LogSign, %ROWID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))

	q 0
}

/// description: 删除配置
ClassMethod DeleteConfig(PLCId)
{
	q:+PLCId=0 "-1^Id为空"
    s logSignDesc=..GetDataLogSignDesc(PLCId)
    s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, PLCId)

	ts	
	&SQL(DELETE FROM DHC_PhaPriority WHERE PP_Code=:PLCId)
	&SQL(DELETE FROM DHC_PhaLocConfig WHERE PLC_ROWID=:PLCId)
	i SQLCODE'=0 tro  q "-2^删除配置失败"
	tc
	
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#TableName, ..#TableClassName, ..#LogSign, PLCId, logSignDesc, "D", delJsonStr)
	q 0
}

/// description: 保存优先级
ClassMethod SavePri(PLCId, PriIdStr)
{
	q:+PLCId=0 "-1^配置Id为空"
	s priLen=$l(PriIdStr,"^")
	s PriIdList=$lfs(PriIdStr,"^")
	s errInfo=""
	ts
	// 删除没选择的
	s ppId=0
	f  s ppId=$o(^DHCPPRIOR(ppId)) q:ppId=""  d
	.s ppData=^DHCPPRIOR(ppId)
	.s plcId=$p(ppData,"^",1)
	.q:PLCId'=plcId
	.s priId=$p(ppData,"^",2)
	.q:priId=""
	.i $lf(PriIdList,priId)=0 d
	..s priOldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#PriTableName, ppId)
    ..s priSignDesc = ..GetDataLogSignDesc4Priority(ppId)
    ..&SQL(DELETE FROM DHC_PhaPriority WHERE PP_RowId=:ppId)
	..i SQLCODE'=0 s errInfo="-1^删除未选择数据失败,"_$p($g(^OECPR(priId)),"^",2)_",SQLCODE:"_SQLCODE_","_$g(%msg) q 
	..d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#PriTableName, ..#PriTableClassName, ..#LogSign, ppId, priSignDesc, "D", priOldJsonStr)
	.s SavePriData(priId)=""
	f priI=1:1:priLen q:errInfo'=""  d
	.s priId=$p(PriIdStr,"^",priI)
	.q:+priId=0
	.q:$d(SavePriData(priId))
	.&SQL(
		INSERT INTO DHC_PhaPriority
		(PP_Code,PP_Desc)
		VALUES
		(:PLCId,:priId)
	 )
	.i SQLCODE'=0 s errInfo="-1^保存失败,"_$p($g(^OECPR(priId)),"^",2)_",SQLCODE:"_SQLCODE_","_$g(%msg) q
    .s rowID = $g(%ROWID)
    .s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue(..#PriTableName, rowID)
    .s logSignDesc = ..GetDataLogSignDesc4Priority(rowID)
 	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#PriTableName, ..#PriTableClassName, ..#LogSign, rowID, logSignDesc, "A", newJsonStr, "")
	i errInfo'="" tro  q errInfo
	tc
	q 0
}

/// description: 保存优先级对应的发药类别
ClassMethod SavePriDisType(PPId, DisTypeIdStr)
{
	q:PPId="" "-1^配置优先级Id为空"
	&SQL(DELETE FROM DHC_PhaPriorDisType WHERE PPDP_ParRef=:PPId)
	s typeLen=$l(DisTypeIdStr,"^")
	s errInfo=""
	ts
	f typeI=1:1:typeLen q:errInfo'=""  d
	.s disTypeId=$p(DisTypeIdStr,"^",typeI)
	.q:+disTypeId=0
	.s maxChild=+$o(^DHCPPRIOR(PPId,"PRIOR",""),-1)+1
	.&SQL(
		INSERT INTO DHC_PhaPriorDisType
		(PPDP_ParRef, PPDP_ChildSub, PPDP_DispCat_Dr)
		VALUES
		(:PPId,:maxChild,:disTypeId)
	 )
	.i SQLCODE'=0 s errInfo="-1^保存失败,"_$p($g(^DHCSTDRUGGRP(disTypeId)),"^",2)_",SQLCODE:"_SQLCODE_","_$g(%msg)
	.
    .s rowID = $g(%ROWID)
    .s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue(..#PriDisTypeTableName, rowID)
    .s logSignDesc = ..GetDataLogSignDesc4DispType(rowID)
 	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#PriDisTypeTableName, ..#PriDisTypeTableClassName, ..#LogSign, rowID, logSignDesc, "A", newJsonStr, "")

    i errInfo'="" tro  q errInfo
    i $tl=0 q "-1^日志错误"
	tc
	q 0
}

ClassMethod GetDataLogSignDesc(rowID)
{
    &SQL(
		SELECT PLC_Desc INTO :ret
		FROM SQLUSER.DHC_PhaLocConfig  
		WHERE %ID = :rowID
	)
	q $g(ret)
}

ClassMethod GetDataLogSignDesc4Priority(rowID)
{
    &SQL(
		SELECT PP_Desc INTO :pri
		FROM SQLUSER.DHC_PhaPriority  
		WHERE %ID = :rowID
	)
    q:($g(pri) = "") "医嘱优先级"    
    q $p($g(^OECPR(+$g(pri))),"^",2)
}

ClassMethod GetDataLogSignDesc4DispType(rowID)
{
    &SQL(
		SELECT 
        PPDP_DispCat_Dr INTO :ret
		FROM SQLUSER.DHC_PhaPriorDisType
		WHERE %ID = :rowID
	)
    q:($g(ret) = "") "发药类别"    
    q $p($g(^DHCSTDRUGGRP(+$g(ret))),"^",2)
}

}
