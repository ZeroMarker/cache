Import sqluser

/// Description:送药科室维护表操作相关
/// Creator:    hulihua
/// CreateDate: 2016-09-08
/// Table:      DHC_PHSendLoc
Class web.DHCINPHA.MTSendLoc.SqlDbSendLoc Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:增加送药科室信息
/// Creator:	hulihua
/// CreateDate:	2016-09-08
/// Table:      DHC_PHSendLoc
/// Input:
/// Output:
/// Return：    成功:rowid, 失败:错误代码, 
/// w ##class(web.DHCINPHA.MTSendLoc.SqlDbSendLoc).Insert("98^102")
ClassMethod Insert(Input As %String) As %Library.String
{
	n (Input)
    s PhLocId=$p(Input,"^",1)
    s WardLocId=$p(Input,"^",2)
    s Err=0
    s $ZT="Error^DHCSTERROR"                        	//增加错误处理
    &sql(Insert into DHC_PHSendLoc(PHSL_PHLoc_Dr,PHSL_WardLoc_Dr)
    values(:PhLocId,:WardLocId))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_PHSendLoc",PhLocId_" "_WardLocId,SQLCODE_":"_%msg)
    .s Err=-4
    q:Err'=0 SQLCODE
    s PhslId=$p(%ROWID,$c(1))
    q PhslId
}

/// Description:修改送药科室信息
/// Creator:	hulihua
/// CreateDate:	2016-09-08
/// Table:      DHC_PHSendLoc
/// Input:
/// Output:
/// Return：    成功:0, 失败:小于0
/// w ##class(web.DHCINPHA.MTSendLoc.SqlDbSendLoc).Update("2^98^104")
ClassMethod Update(PhslId As %String, Input As %String) As %Library.String
{
    n (PhslId,Input)
    s PhLocId=$p(Input,"^",1)
    s WardLocId=$p(Input,"^",2)
    s Err=0
    s $ZT="Error^DHCSTERROR"                        //增加错误处理
    &sql(update DHC_PHSendLoc set PHSL_PHLoc_Dr=:PhLocId,PHSL_WardLoc_Dr=:WardLocId
    where PHSL_RowID=:PhslId)
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_PHSendLoc",PhslId,SQLCODE_":"_%msg)
    ..s Err=-4
    .
    q:Err'=0 SQLCODE
    q 0
}

/// Description:修改关联病区是否送药的标志
/// Creator:	hulihua
/// CreateDate:	2017-04-20
/// Table:      DHC_PHSendLoc
/// Input:		PhslId-送药科室ID,送药标志
/// Output:
/// Return：    成功:0, 失败:小于0
/// w ##class(web.DHCINPHA.MTSendLoc.SqlDbSendLoc).UpdateSendFlag("2^98^104")
ClassMethod UpdateSendFlag(PhslId As %String, Input As %String) As %Library.String
{
    n (PhslId,Input)
    s SendFlag=Input
    s Err=0
    s $ZT="Error^DHCSTERROR"                        //增加错误处理
    &sql(update DHC_PHSendLoc set PHSL_SendFlag=:SendFlag where PHSL_RowID=:PhslId)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("UpdateSendFlag:DHC_PHSendLoc",PhslId,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 SQLCODE
    q 0
}

/// Description:删除送药科室信息
/// Creator:	hulihua
/// CreateDate:	2016-09-08
/// Table:      DHC_PHSendLoc
/// Input:
/// Output:
/// Return：    成功:0, 失败:非0
/// w ##class(web.DHCINPHA.MTSendLoc.SqlDbSendLoc).Delete("1")
ClassMethod Delete(Input) As %Integer
{
	n (Input)
	q:Input="" 0
	s rowid=$p(Input,"^",1)
    q:'$d(^DHCPHSL(rowid)) 0
    s Err=0
    s $ZT="Error^DHCSTERROR"                        //增加错误处理
	&sql(delete from DHC_PHSendLoc where PHSL_RowID=:rowid )
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_PHSendLoc",rowid,SQLCODE_":"_%msg)
    .s Err=-1             
    q:Err'=0 SQLCODE
	q SQLCODE
}

/// Description:修改关联病区送药频率相关信息
/// Creator:	hulihua
/// CreateDate:	2017-08-30
/// Table:      DHC_PHSendLoc
/// Input:		送药科室关联ID,送药频次描述、频次系数
/// Output:
/// Return：    成功:0, 失败:小于0
/// w ##class(web.DHCINPHA.MTSendLoc.SqlDbSendLoc).UpdateSendFreq("2^98^104")
ClassMethod UpdateSendFreq(Input As %String) As %Library.String
{
    n (Input)
    s PhslId=$p(Input,"^",1)
    s SendFreqDesc=$p(Input,"^",2)
    s SendFreqFactor=$p(Input,"^",3)
    s SendFactor=$p(Input,"^",4)
    s WardQue=$p(Input,"^",5)
    i SendFreqDesc="全送" s SendFreqFactor=1000
    s Err=0
    s $ZT="Error^DHCSTERROR"                        //增加错误处理
    &sql(update DHC_PHSendLoc set PHSL_SendFreqDesc=:SendFreqDesc,PHSL_SendFreqFactor=:SendFreqFactor, 
    PHSL_SendFactor=:SendFactor, PHSL_WardQue=:WardQue where PHSL_RowID=:PhslId)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("UpdateSendFreq:DHC_PHSendLoc",PhslId,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 SQLCODE
    q 0
}

}
