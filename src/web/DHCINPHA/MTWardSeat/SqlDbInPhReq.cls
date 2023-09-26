Import sqluser

/// Description:病区请领表操作相关(采用SQL的形式)
/// Creator:    hulihua
/// CreateDate: 2017-03-21
/// Table:      DHC_InPhReq、DHC_InPhReqItm
Class web.DHCINPHA.MTWardSeat.SqlDbInPhReq Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCINPHAINPHREQ";

/// Description:根据生成的关联单号更新请领单主表
/// Creator:	hulihua
/// CreateDate:	2017-03-21
/// Table:      DHC_InPhReq-病区请领发药主表
/// Input:		SqlStr(请领单ID的串)
/// Output:
/// Return：    
/// Others:
/// w ##class(web.DHCINPHA.MTWardSeat.SqlDbInPhReq).UpdateInPhReqConNo("")
ClassMethod UpdateInPhReqConNo(SqlStr As %String) As %Library.String
{
	
	n (SqlStr)
	s InPhReqIdStr=SqlStr
	q:InPhReqIdStr="" -101
	s ret=##class(web.DHCST.Common.AppCommon).Lock("InPhConNo"_InPhReqIdStr)  
    q:ret'=0 -102				;加锁失败
    s AppName=..%GetParameter("AppName")
    s DispLoc=$p(^DHCINPHREQ($p(InPhReqIdStr,"^")),"^",3)
    s ReqTypeId=$p(^DHCINPHREQ($p(InPhReqIdStr,"^")),"^",7)
    s ReqType=$s(ReqTypeId=1:"送药",1:"取药")
    s InPhReqConNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,"",DispLoc)
    i InPhReqConNo="" d ##class(web.DHCST.Common.AppCommon).UnLock("InPhConNo"_InPhReqIdStr)
    q:InPhReqConNo="" -103   	;生成关联单号失败
    s ReqTypeCode=##class(web.DHCST.Common.AppCommon).GetCNCODE(ReqType)
    s InPhReqConNo=ReqTypeCode_InPhReqConNo
    s len=$l(InPhReqIdStr,"^")
   	s Err=0
    f i=1:1:len d
  	.q:Err<0
  	.s PhrId=$p(InPhReqIdStr,"^",i)
	.&SQL(Update DHC_InPhReq set PHR_ConnectNo=:InPhReqConNo where PHR_RowID=:PhrId)
	.i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_InPhReq",PhrId,SQLCODE_":"_$g(%msg))
    ..s Err=-104
	..q:SQLCODE'=0
	d ##class(web.DHCST.Common.AppCommon).UnLock("InPhConNo"_InPhReqIdStr)
	q:SQLCODE'=0 Err
	q InPhReqConNo
}

Storage Default
{
<Data name="SqlDbInPhReqDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINPHAD931.SqlDbInPhReqD</DataLocation>
<DefaultData>SqlDbInPhReqDefaultData</DefaultData>
<IdLocation>^web.DHCINPHAD931.SqlDbInPhReqD</IdLocation>
<IndexLocation>^web.DHCINPHAD931.SqlDbInPhReqI</IndexLocation>
<StreamLocation>^web.DHCINPHAD931.SqlDbInPhReqS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
