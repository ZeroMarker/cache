Import sqluser

Class web.DHCSTMHUI.INCStkBin Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 批量保存货位码记录
/// Author:zhangdongmei
/// Date:2012-08-20
/// Argu:科室rowid,货位id^货位名称,货位id^货位名称
/// Return ：
///  0 - 成功
///  <0 - 插入或更新失败
///  w ##class(web.DHCSTMHUI.INCStkBin).Save(^TMP03,^TMP04)
ClassMethod Save(Loc As %String, Params As %String) As %String
{
	n (Loc,Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Desc=Obj.%Get("Description")
		i (Desc="") s Sc=RtnObj.Err(-2,"","必填项不能为空!","",0)
		q:RtnObj.success'=0
		s RtnObj=..Update(RowId,Loc,Desc)
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// 验证该科室里是否有此货位码
/// Loc - 科室id
/// Desc - 货位码名称
/// Author:zhangxiao
/// Date:2014-02-10
/// Return:
///  0 -存在
///  <0,>0 - 不存在
/// w ##class(web.DHCSTMHUI.INCStkBin).CheckStkBin("7",2)
ClassMethod CheckStkBin(Loc As %String, Desc As %String) As %String
{
	n (Loc,Desc)
	s match=Loc_"P"_"%"
	&sql(select INCSB_RowId into :rowid from inc_stkbin  where incsb_desc=:Desc and incsb_code like :match)
	q SQLCODE
}

/// 验证该科室里是否有此货位码
/// Loc - 科室id
/// Desc - 货位码名称
/// Author:zhangxiao
/// Date:2014-02-10
/// Return:
/// 货位码id -存在
/// 空-不存在
/// w ##class(web.DHCSTMHUI.INCStkBin).GetStkBinByDesc(7,1)
ClassMethod GetStkBinByDesc(Loc As %String, Desc As %String) As %String
{
	n (Loc,Desc)
	q:Desc="" ""
	s rowid=""
	s match=Loc_"P"_"%"
	&sql(select INCSB_RowId into :rowid from inc_stkbin  where incsb_desc=:Desc and incsb_code like :match)
	q rowid
}

/// 插入或更新1条货位代码记录
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///   sb - 货位代码表rowid
///   Loc - 科室rowid
///   sbDesc -货位名称
/// Return ：
///  >0 - 货位码记录rowid
///  <0 - 插入或更新失败
///  w ##class(web.DHCSTMHUI.INCStkBin).Update()
ClassMethod Update(RowId As %String, Loc As %String, Desc As %String) As RtnObj
{
	n (RowId,Loc,Desc,%session)
	s RtnObj=##class(RtnObj).%New()
	i Loc=""  s Sc= RtnObj.Err(-100,"","科室不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s id=..GetStkBinByDesc(Loc,Desc)
	i (id'="")&&(id'=RowId) s Sc=RtnObj.Err(-101,"","名称不能重复!","",0)
	q:RtnObj.success'=0 RtnObj
	i ##class(web.DHCSTMHUI.Common.AppCommon).Lock("User.INCStkBin")<0 
	.s Sc=RtnObj.Err(-99,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj
	ts
	i RowId="" d
	.s sbCode=..GetNextCode(Loc)  //自动生成代码(代码包含“科室”信息)
	.i sbCode="" s Sc=RtnObj.Err(-99,"","自动生成代码失败!") q
	.&sql(insert into inc_stkbin (incsb_code,incsb_desc) values (:sbCode,:Desc))
	.i SQLCODE'=0 s Sc=RtnObj.Err(-1,"","插入数据失败!") q
	.s RtnObj=##class(Log).SaveLog("INC_StkBin","User.INCStkBin","货位码信息",$SYSTEM.SQL.GetROWID(),Desc,"A")
	e  d
	.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("inc_stkbin",RowId)
	.&sql(update inc_stkbin set incsb_desc=:Desc where %ID=:RowId)
	.i SQLCODE'=0 s Sc=RtnObj.Err(-2,"","更新失败!") q
	.s RtnObj=##class(Log).SaveLog("INC_StkBin","User.INCStkBin","货位码信息",RowId,Desc,"U","",OldJsonStr)
	i RtnObj.success'=0 d
	.tro
	.d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("User.INCStkBin")
	q:RtnObj.success'=0 RtnObj
	
	i RtnObj.success=0 d
	.tc
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("User.INCStkBin") 
	q RtnObj
}

/// 删除一条货位代码
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///   sb - 货位代码表rowid
/// Return
///  0 - success
///  <0 - failure
/// w ##class(web.DHCSTMHUI.INCStkBin).Delete()
ClassMethod Delete(StkBRowId As %String) As %String
{
	n (StkBRowId,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	i StkBRowId="" d RtnObj.Err(-1,"","入参为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	i ##class(web.DHCSTMHUI.Common.AppCommon).Lock("User.INCStkBin"_StkBRowId)<0 d
	.d RtnObj.Err(-1,"","加锁失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	i ..AllowDel(sb)<0 d
	.d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("User.INCStkBin"_StkBRowId) 
	.d RtnObj.Err(-2,"","不允许删除!")
	q:RtnObj.success'=0 RtnObj
	s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("inc_stkbin",StkBRowId)   
	ts
	&sql(delete from inc_stkbin where %ID=:StkBRowId)
	i SQLCODE'=0 d
	.tro
	.d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("User.INCStkBin"_StkBRowId) 
	.d RtnObj.Err(-3,"","删除失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s RtnObj=##class(Log).SaveLog("INC_StkBin","User.INCStkBin","货位码信息",StkBRowId,"","D",JsonStr)
	i RtnObj.success'=0 d
	.tro
	.d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("User.INCStkBin"_StkBRowId) 
	.d RtnObj.Err(-3,"","删除失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	i RtnObj.success=0 d
	.tc
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("User.INCStkBin"_StkBRowId)
	q:RtnObj.success'=0 RtnObj
	q RtnObj.Json()
}

/// 检测是否允许删除
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///   sb - 货位代码表rowid
/// Return
///  0 - 允许
///  <0 - 不允许
ClassMethod AllowDel(sb As %String) As %String
{
	n (sb)
	q:sb="" -1
	s cnt=0
	&sql(select count(*) into :cnt from inc_itmloc where incil_incsb_dr=:sb )
	q:cnt>0 -2
	q 0
}

/// 检索某科室的所有货位码
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///  Loc - 科室rowid
///  sbDesc - 货位名称
///  d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INCStkBin","LocINCStkBin",^TMPLH(02))
Query LocINCStkBin(Params As %String) As Query(ROWSPEC = "RowId,Code,Description")
{
}

ClassMethod LocINCStkBinExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s qHandle=$lb(0,repid,0) 
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s Loc=PJobj.%Get("StkBinLoc")
	q:Loc="" $$$OK
	s sbDesc=""
	s xcode=Loc_"P"_"%"
	s sql="select %ID sb,incsb_code code,incsb_desc description from inc_stkbin where incsb_code like "_"'"_xcode_"'"
	i sbDesc'="" d
	.s sql=sql_" and incsb_desc like "_"'"_sbDesc_"%"_"'"
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("sb")
		s Code=xrs.Data("code")
		s Description=xrs.Data("description")
		d OutPutRow
	}
 
 Quit $$$OK
OutPutRow
 s Data=$lb(RowId,Code,Description)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// 自动生成某科室新的货位代码
/// Author:zhwh
/// Date:2012-07-25
/// Argu:
///   Loc  - 科室rowid
/// Return:  
///   货位代码字符串 
ClassMethod GetNextCode(Loc As %String) As %String
{
	n (Loc)
	s ch=+Loc_"P"
	s max=0
	&sql(select  max(to_number($PIECE(incsb_code,:ch,2))) into :max from inc_stkbin  where incsb_code %STARTSWITH :ch)
	s max=max+1
	q ch_max
}

}
