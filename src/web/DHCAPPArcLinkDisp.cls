/// Import sqluser
Class web.DHCAPPArcLinkDisp Extends %RegisteredObject [ ClassType = "", ProcedureBlock, SqlCategory = NUMERIC ]
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-04-18
/// Description:： 保存 检查医嘱项与后处理关联
/// Table：        DHC_AppArcLinkDisp
/// Input：	       ArcDr:ID：ARC_ItmMast的rowid
///                DispDr:ID：DHC_RisDispMedthod的rowid
/// save：         DHC_AppArcLinkDisp                
/// Return：       保存成功 0，其他 失败
/// other：        w ##class(web.DHCAPPArcLinkDisp).Save("1||1",1)
ClassMethod saveOrUpdate(str)
{
    
  	 s ArcDr=$p(str,"^",1)
	 s DispDr=$p(str,"^",2)
	 s ID=$p(str,"^",3)
		 
	 i +ID=0 d
	 .s obj=##class(User.DHCAppArcLinkDisp).%New()
	 .s obj.ALDArcDr=##class(User.ARCItmMast).%OpenId(ArcDr)
	 e  d
	 .s obj=##class(User.DHCAppArcLinkDisp).%OpenId(ID)
	 .d obj.%Reload()
	 s obj.ALDDispDr=##class(User.DHCAppDispMedthod).%OpenId(DispDr) 
	 i $d(^DHCAPARCDI(0,"ArcDisp",ArcDr,DispDr)) q 1
	 i '$d(^DHCAPARCDI(0,"ArcDisp",ArcDr,DispDr)) d
	 .s sc=obj.%Save()
	 i $$$ISERR(sc) q -2
	 q 0
}

ClassMethod save(params)
{
  
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..saveOrUpdate(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-04-19
/// Description:： 后处理 下拉选择（显示desc）
/// Table：        DHC_AppDispMedthod
/// other:         w ##class(web.DHCAPPArcLinkDisp).getDisp()
ClassMethod getDisp(HospID)
{
  if ((HospID="")&&($d(%session))) s HospID=%session.Get("LOGON.HOSPID")
  w "["
  set RowID=0,count=0 
  f  s RowID=$o(^DHCAPDIM(RowID)) q:RowID=""  d
  .s hospdr=$p(^DHCAPDIM(RowID),"^",4)
  .Q:(hospdr'="")&(hospdr'=HospID)
  .Q:$p(^DHCAPDIM(RowID),"^",3)'="Y"
  .i count>0 d
  ..w ","
  .w "{"
  .w """id"":"_RowID_","
  .w """text"":"""_$p(^DHCAPDIM(RowID),"^",2)_""""
  .w "}"
  .s count=count+1
  w "]"
  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-04-19
/// Description:： 列出
/// Table：        DHC_AppArcLinkDisp
/// d ##class(web.DHCAPPArcLinkDisp).list("11207||1")
ClassMethod list(ArcRowId = "", HospID = "")
{
  w "{""rows"":["
  s partid=0,count=0
  f  s partid=$o(^DHCAPARCDI(0,"Arc",ArcRowId,partid)) q:partid=""  d
  .s DispDr=$p(^DHCAPARCDI(partid),"^",2)
  .q:DispDr=""
  .s ALDDispDr=$p(^DHCAPDIM(DispDr),"^",2)
  .s ALDArcDr=$p(^DHCAPARCDI(partid),"^",1)
  .s itemHospID=$p(^DHCAPDIM(DispDr),"^",4)      //医院ID
  .Q:(HospID'="")&(itemHospID'=HospID)
  .;s obj=##class(User.ARCItmMast).%OpenId(ALDArcDr)
  .;s desc=obj.ARCIMDesc
  
  .i count>0 d
  ..w ","
  .s obj=##class(web.DHCAPPJsonObject).%New()
  .d obj.Put("ID",partid)
  .d obj.Put("ArcDr",ALDArcDr)
  .d obj.Put("DispDr",ALDDispDr)
  .w obj.Json()	
  .s count=count+1
  w "],""total"":"_count_"}"
  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-04-18
/// Description:： 删除
/// Table：        DHC_AppArcLinkDisp 
/// Input：	       Id：rowid
/// Return：       操作成功 0，其他 失败
/// other:         d ##class(web.DHCAPPArcLinkDisp).remove()
ClassMethod remove(Id As %String) As %String
{
	q:+Id=0 -1
	s obj=##class(User.DHCAppArcLinkDisp).%DeleteId(Id)
	q 0
	;N (ID)
	;&SQL(Delete From DHC_AppArcLinkDisp Where ALD_RowID=:ID) 
	;Q SQLCODE
}

}
