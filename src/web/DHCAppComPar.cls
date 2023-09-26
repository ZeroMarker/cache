Class web.DHCAppComPar Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Descript:查询应用程序参数配置属性
/// CreateDate：2016-06-29
/// Creater：zhouxin
/// Table：DHC_EmSys,DHC_EmSysItm,DHC_EmSysItmAut
/// Input:AppCode DHC_EmSys 的code
/// FunCode DHC_EmSysItm 的code
/// Hosp:医院id
/// Loc:科室id
/// User:用户id
/// Group:安全组
/// Return:属性值
/// w ##class(web.DHCAppComPar).GetAppPropValue(2,2,2)
ClassMethod GetAppPropValue(AppCode = "", FunCode = "", Hosp = "", Loc = "", User = "", Group = "") As %Library.String
{

	s ret=""
	q:AppCode="" ret
	q:FunCode="" ret
	
	i Loc'="" d
	.s:Hosp="" Hosp=$p(^CTLOC(Loc),"^",22)
	
	
	q:Hosp="" ret
	//b ;1
	s appId="",tmpAppId=0
	f  s tmpAppId=$o(^DHCEMS(0,"Code",AppCode,tmpAppId)) q:(tmpAppId="")||(appId'="")  d
	.s flag=$p(^DHCEMS(tmpAppId),"^",4)
	.q:flag'="Y"
	.s appHosp=$p(^DHCEMS(tmpAppId),"^",5)
	.//q:appHosp'=Hosp
	.s appId=tmpAppId
	q:appId="" ret
	//b
	//b ;2
	s funcId=$o(^DHCEMS(0,"SYCode",appId,$$ALPHAUP^SSUTIL4(FunCode),0))
	q:funcId="" ret
	
	//
	//b
	s priorityStr="U^G^L^D"
	
	f i=1:1:4 d
	.q:ret'=""
	.s type=$p(priorityStr,"^",i)
	.SET pointer=$SELECT(type="G":Group,type="L":Loc,type="U":User,type="D":"DHC")
	.//w "pointer:"_pointer,!
	.q:pointer=""
	.s priorityId=""
	.//f  s priorityId=$o(^DHCEMS(0,"TypePointer",type,pointer,appId,funcId,priorityId)) q:(priorityId="")||(ret'="")  d
	.f  s priorityId=$o(^DHCEMS(appId,"I",funcId,"A",priorityId)) q:(priorityId="")||(ret'="")  d
	..s code=$p(^DHCEMS(appId,"I",funcId,"A",priorityId),"^",1)
	..q:type'=code
	..s tmpPointer=$p(^DHCEMS(appId,"I",funcId,"A",priorityId),"^",2)
	..q:tmpPointer'=pointer
	..s priorityHop=$p(^DHCEMS(appId,"I",funcId,"A",priorityId),"^",4)
	..;b
	..q:priorityHop'=Hosp
	..s ret=$p(^DHCEMS(appId,"I",funcId,"A",priorityId),"^",3)
	..//w "ret:"_ret,!
	q ret
}

}
