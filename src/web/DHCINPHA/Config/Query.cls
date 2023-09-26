/// description: 查询-住院药房客户端配置
Class web.DHCINPHA.Config.Query Extends %RegisteredObject
{

/// deccription:客户端配置列表
/// table:      User.DHCPhaLocConfig; User.DHCPhaPriority; UserDHCPhaPriorDisType
/// d ##class(%ResultSet).RunQuery("web.DHCINPHA.Config.Query","DHCPhaLocConfig",98)
Query DHCPhaLocConfig(InputStr = "") As websys.Query(ROWSPEC = "plcId,plcDesc,userId,userCode,userName,mac,priDisTypeStr")
{
}

ClassMethod DHCPhaLocConfigExecute(ByRef qHandle As %Binary, InputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s LocId=$p(InputStr,"^",1)
	q:LocId="" $$$OK
	s UserText=$ZCVT($p(InputStr,"^",2),"U")
	s MacText=$ZCVT($p(InputStr,"^",3),"U")
	s plcId=0
	f  s plcId=$o(^DHCPHLC(plcId)) q:plcId=""  d
	.s plcData=^DHCPHLC(plcId)
	.s locId=$p(plcData,"^",1)
	.q:(LocId'="")&&(LocId'=locId)
	.s plcDesc=$p(plcData,"^",2)
	.s mac=$p(plcData,"^",3)
	.s userId=$p(plcData,"^",6)
	.i userId'="" d
	..s userCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	..s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
	.e  s (userCode,userName)=""
	.s existFlag=""
	.i UserText'="" d
	..i $ZCVT(userCode,"U")[UserText s existFlag=1 q
	..i $ZCVT(userName,"U")[UserText s existFlag=1 q
	.q:(UserText'="")&&(existFlag="")
	.i MacText'="" d
	..i $ZCVT(mac,"U")[MacText s existFlag=1 q
	.q:(MacText'="")&&(existFlag="")
	.s priDisTypeStr=..GetPriDisTypeStr(plcId)
	.s Data=$lb(plcId,plcDesc,userId,userCode,userName,mac,priDisTypeStr)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	Quit $$$OK
}

/// description 获取配置对应的优先级发药类别(仅作显示)
/// table:		User.DHCPhaPriority
/// w ##class(web.DHCINPHA.Config.Query).GetPriDisTypeStr(136)
ClassMethod GetPriDisTypeStr(PLCId)
{
	q:PLCId="" ""
	s retStr=""
	s split="<span style=font-weight:bold;color:#cccccc>　/　</span>"
	s ppId=0
	f  s ppId=$o(^DHCPPRIOR(ppId)) q:ppId=""  d
	.s ppData=^DHCPPRIOR(ppId)
	.s plcId=$p(ppData,"^",1)
	.q:PLCId'=plcId
	.s priId=$p(ppData,"^",2)
	.q:priId=""
	.s priDesc=$p($g(^OECPR(priId)),"^",2)
	.s priDisType=""
	.s ppdtId=""
	.f  s ppdtId=$o(^DHCPPRIOR(ppId,"PRIOR",ppdtId)) q:ppdtId=""  d
	..s disTypeId=$p(^DHCPPRIOR(ppId,"PRIOR",ppdtId),"^",2)
	..q:disTypeId=""
	..s disTypeDesc=$p($g(^DHCSTDRUGGRP(disTypeId)),"^",2)
	..i priDisType="" s priDisType=disTypeDesc
	..e  s priDisType=priDisType_" , "_disTypeDesc
	.s priDesc="<span style=font-weight:bold>"_priDesc_"</span>"
	.i retStr="" s retStr=priDesc_" : "_priDisType
	.e  s retStr=retStr_split_priDesc_" : "_priDisType
	q retStr
}

/// deccription:客户端配置优先级列表
/// table:      User.DHCPhaPriority;
/// d ##class(%ResultSet).RunQuery("web.DHCINPHA.Config.Query","DHCPhaPriority",35)
Query DHCPhaPriority(InputStr = "") As websys.Query(ROWSPEC = "ppId,priId,priDesc")
{
}

ClassMethod DHCPhaPriorityExecute(ByRef qHandle As %Binary, InputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PLCId=$p(InputStr,"^",1)
	s priId=0
	f  s priId=$o(^OECPR(priId)) q:priId=""  d
	.q:$p(^OECPR(priId),"^",1)["OM"
	.s DHCPhaPriorityData(priId)=""
	s priId=""
	f  s priId=$o(DHCPhaPriorityData(priId)) q:priId=""  d
	.s ppId=""
	.i PLCId'="" d
	..&SQL(SELECT PP_RowId into :ppId FROM SQLUSER.DHC_PhaPriority WHERE PP_Code=:PLCId AND PP_Desc=:priId)
	.s priDesc=$p(^OECPR(priId),"^",2)
	.s Data=$lb(ppId,priId,priDesc)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	Quit $$$OK
}

/// deccription:客户端配置发药类别列表
/// table:      User.DHCPhaPriorDisType;User.DHCPhaLocDisType
/// d ##class(%ResultSet).RunQuery("web.DHCINPHA.Config.Query","DHCPhaPriorDisType","^98")
Query DHCPhaPriorDisType(InputStr = "") As websys.Query(ROWSPEC = "ppdpId,disTypeId,disTypeDesc")
{
}

ClassMethod DHCPhaPriorDisTypeExecute(ByRef qHandle As %Binary, InputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PPId=$p(InputStr,"^",1)
	s LocId=$p(InputStr,"^",2)
	q:LocId="" $$$OK
	s PLId=$o(^DHCPL(0,"Loc",LocId,""))
	q:PLId="" $$$OK 
	s plDisId=0
	f  s plDisId=$o(^DHCPL(PLId,"DIS",plDisId)) q:plDisId=""  d
	.s disTypeId=$p(^DHCPL(PLId,"DIS",plDisId),"^",1)
	.s DHCPhaPriorDisTypeData(disTypeId)=""
	s disTypeId=""
	f  s disTypeId=$o(DHCPhaPriorDisTypeData(disTypeId)) q:disTypeId=""  d
	.s ppdpId=""
	.i PPId'="" d
	..&SQL(SELECT PPDP_RowId into :ppdpId FROM SQLUSER.DHC_PhaPriorDisType WHERE PPDP_ParRef=:PPId AND PPDP_DispCat_Dr=:disTypeId)
	.s disTypeDesc=$p($g(^DHCSTDRUGGRP(disTypeId)),"^",2)
	.s Data=$lb(ppdpId,disTypeId,disTypeDesc)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	Quit $$$OK
}

}
