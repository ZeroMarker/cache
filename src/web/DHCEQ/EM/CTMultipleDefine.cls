Class web.DHCEQ.EM.CTMultipleDefine Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add by QW 2019-08-29
/// 
ClassMethod SaveData(data, DelIs)
{
	
	s $ZT="ERRORMULTIPLEDEFINE"
	k PLIST,RowID
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	TSTART
	if DelIs=1
	{
		s RowID=data
		&SQL(Update SQLUSER.DHC_EQCMultipleDefine set MD_InvalidFlag='Y' where MD_RowID = :RowID)
		s RowID=""
	}else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s MDPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCMultipleDefine",JsonData,.MDPLIST)
		s RowID=JsonData.MDRowID 
		s MDPLIST(7)="N" ;InvalidFlag
		i RowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQCMultipleDefine Values :MDPLIST() where MD_RowID = :RowID)
		}
		else
		{
				&SQL(insert into SQLUSER.DHC_EQCMultipleDefine Values :MDPLIST())
				s RowID=$g(%ROWID)
		}
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
		TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRORMULTIPLEDEFINE
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

// d ##class(User.DHCEQCMultipleDefine).%BuildIndices()

ClassMethod GetMultipleDefineDRByApproveType(ApproveTypeDR)
{
	q $o(^DHCEQCCode("DHCEQCMultipleDefine",0,"ApproveType",ApproveTypeDR,0))
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.CTMultipleDefine","MultipleDefine","1")
/// Modified by QW20191205 需求号:1124150  多方定义中，来源显示为数字 增加输出 TSourceTypeDesc:%String。//TMultiName,TMultiCode,TSourceType,TRowID,TClearFlag,TApproveTypeDR,TApproveType,TSourceTypeDesc
/// modified by sjh SJH0040 2020-11-26 输出列标题修改
Query MultipleDefine(ApproveTypeDR As %String = "") As %Query(ROWSPEC = "TMultiName:%String:描述,TMultiCode:%String:代码,TSourceType:%String,TRowID:%String,TClearFlag:%String:取消是否清除审批标记,TApproveTypeDR:%String,TApproveType:%String:审批类型,TSourceTypeDesc:%String:来源")
{
}

ClassMethod MultipleDefineExecute(ByRef qHandle As %Binary, ApproveTypeDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1

	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCMultipleDefine",rowid)) quit:rowid=""  d
	.d ResetVariablesGetMultipleDefine
	.s TRowID=rowid
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCMultipleDefine",TRowID)),"^",6)
	.q:TInvalidFlag="Y"
	.s TApproveTypeDR=$p($g(^DHCEQCCode("DHCEQCMultipleDefine",TRowID)),"^",1)
	.q:(ApproveTypeDR'="")&&(TApproveTypeDR'=ApproveTypeDR)
	.i TApproveTypeDR'="" s TApproveType=$p($g(^DHCEQCCode("DHCEQCApproveType",TApproveTypeDR)),"^",2)
	.s TSourceType=$p($g(^DHCEQCCode("DHCEQCMultipleDefine",TRowID)),"^",2)
	.s TSourceTypeDesc=$CASE(TSourceType,"0":"科室","1":"人员","2":"角色","":"") ;Add by QW20191205 需求号:1124150  多方定义中，来源显示为数字。
	.s TMultiCode=$p($g(^DHCEQCCode("DHCEQCMultipleDefine",TRowID)),"^",3)
	.s TMultiName=$p($g(^DHCEQCCode("DHCEQCMultipleDefine",TRowID)),"^",4)
	.s TClearFlag=$p($g(^DHCEQCCode("DHCEQCMultipleDefine",TRowID)),"^",5)
	.d OutputRowGetMultipleDefine
	Quit $$$OK
OutputRowGetMultipleDefine
	s Data=$lb(TMultiName,TMultiCode,TSourceType,TRowID,TClearFlag,TApproveTypeDR,TApproveType,TSourceTypeDesc) ;Modified by QW20191205 需求号:1124150  多方定义中，来源显示为数字。
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetMultipleDefine
	s (TSourceType,TMultiCode,TMultiName,TRowID,TClearFlag,TInvalidFlag,TApproveTypeDR,TApproveType,TSourceTypeDesc)="" ;Modified by QW20191205 需求号:1124150  多方定义中，来源显示为数字。
	quit
}

ClassMethod MultipleDefineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MultipleDefineExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod MultipleDefineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MultipleDefineExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
