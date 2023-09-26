Import sqluser

Class web.DHCAppArcLinkPos Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock, SqlCategory = NUMERIC ]
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-04-18
/// Description:： 保存 检查医嘱项与体位关联
/// Table：        DHC_AppArcLinkPos
/// Input：	       ArcDr:ID：ARC_ItmMast的rowid
///                DispDr:ID：DHC_AppPosition的rowid
/// save：         DHC_AppArcLinkPos                
/// Return：       保存成功 0，其他 失败
/// other：        w ##class(web.DHCAppArcLinkPos).saveOrUpdate("1||1",1)
ClassMethod saveOrUpdate(str)
{

  	 s ArcDr=$p(str,"^",1)
	 s PosDr=$p(str,"^",2)
	 s ID=$p(str,"^",3)
	 s PartID=$p(str,"^",4)  /// 部位ID
	 Q:..isExist(str) -1
	 i +ID=0 d
	 .s obj=##class(User.DHCAppArcLinkPos).%New()
	 .s obj.ALPArcDr=##class(User.ARCItmMast).%OpenId(ArcDr)
	 e  d
	 .s obj=##class(User.DHCAppArcLinkPos).%OpenId(ID)
	 .d obj.%Reload()
	 s obj.ALPPosDr=##class(User.DHCAppPosition).%OpenId(PosDr)
	 i +PartID'=0 s obj.ALPPartDr=##class(User.DHCAppPart).%OpenId(PartID) 
#;	 i $d(^DHCAPARCPO(0,"ArcPos",ArcDr,PosDr)) q 1
#;	 i '$d(^DHCAPARCPO(0,"ArcPos",ArcDr,PosDr)) d
#;	 .s sc=obj.%Save()
	 s sc=obj.%Save()
	 i $$$ISERR(sc) q -2
	 q 0
}

ClassMethod save(params)
{
	s ^BIANSHUAI(2)=params
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
/// Description:： 体位 下拉选择（显示desc）
/// Table：        DHC_AppPosition
/// other:         w ##class(web.DHCAppArcLinkPos).getPos()
ClassMethod getPos(HospID)
{
  if ((HospID="")&&($d(%session))) s HospID=%session.Get("LOGON.HOSPID")
  w "["
  set RowID=0,count=0 
  f  s RowID=$o(^DHCAPPOS(RowID)) q:RowID=""  d
  .s hospdr=$p(^DHCAPPOS(RowID),"^",4)
  .Q:(hospdr'="")&(hospdr'=HospID)
  .Q:$p(^DHCAPPOS(RowID),"^",3)'="Y"
  .i count>0 d
  ..w ","
  .w "{"
  .w """id"":"_RowID_","
  .w """text"":"""_$p(^DHCAPPOS(RowID),"^",2)_""""
  .w "}"
  .s count=count+1
  w "]"
  q ""
}

ClassMethod getPosList(ArcRowId = "")
{
  n (ArcRowId)
  s ^tempqujian("getPosList")=ArcRowId
  w "["
  s partid=0,count=0
  f  s partid=$o(^DHCAPARCPO(0,"Arc",ArcRowId,partid)) q:partid=""  d
  .s a=$p(^DHCAPARCPO(partid),"^",2)
  .q:a=""
  .s ALPPosDr=$p(^DHCAPPOS(a),"^",2)
  .q:($p(^DHCAPARCPO(partid),"^",3)'="")
  .i count>0 d
  ..w ","
  .w "{"
  .w """id"":"_a_","
  .w """text"":"""_ALPPosDr_""""
  .w "}"
  .s count=count+1
  w "]"
  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-04-19
/// Description:： 列出
/// Table：        DHC_AppArcLinkPos 
/// Input：	       Id：rowid
/// other:         w ##class(web.DHCAppArcLinkPos).list("2729||1","2","")
ClassMethod list(ArcRowId = "", HospID = "", PartID = "")
{
  n (ArcRowId, HospID, PartID)
  s ^BIANSHUAI(1)=$LB(ArcRowId, HospID, PartID)
  w "{""rows"":["
  s partid=0,count=0
  f  s partid=$o(^DHCAPARCPO(0,"Arc",ArcRowId,partid)) q:partid=""  d
  .s a=$p(^DHCAPARCPO(partid),"^",2)
  .q:a=""
  .s ALPPosDr=$p($g(^DHCAPPOS(a)),"^",2)
  .q:ALPPosDr=""
  .s ALPArcDr=$p(^DHCAPARCPO(partid),"^",1)
   .s itemHospID=$p(^DHCAPPOS(a),"^",4)      //医院ID
  .Q:(HospID'="")&(itemHospID'=HospID)
  .Q:(PartID'="")&($p(^DHCAPARCPO(partid),"^",3)'=PartID)
  .Q:(PartID="")&($p(^DHCAPARCPO(partid),"^",3)'="")
  .;s obj=##class(User.ARCItmMast).%OpenId(ALPArcDr)
  .;q:'$IsObject(obj)
  .;s desc=obj.ARCIMDesc

  .i count>0 d
  ..w ","
  .s obj=##class(web.DHCAPPJsonObject).%New()
  .d obj.Put("ID",partid)
  .d obj.Put("ArcDr",ALPArcDr)
  .d obj.Put("PosDr",ALPPosDr)
  .w obj.Json()	
  .;w jsonObj.FromObject(##class(User.DHCAppArcLinkDisp).%OpenId(partid)).Json()
  .
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
/// other:         d ##class(web.DHCAppArcLinkPos).remove()
ClassMethod remove(Id As %String) As %String
{
	 q:+Id=0 -1
	 s obj=##class(User.DHCAppArcLinkPos).%DeleteId(Id)
	 q 0
	 ;N (ID)
	 ;&SQL(Delete From DHC_AppArcLinkPos Where ALP_RowID=:ID)
	 ;Q SQLCODE
}

/// Description:： 是否存在
ClassMethod isExist(mListData As %String) As %String
{
	n (mListData)
  	s ArcDr=$p(mListData,"^",1)
	s PosDr=$p(mListData,"^",2)
	s ID=$p(mListData,"^",3)
	s PartID=$p(mListData,"^",4)  /// 部位ID
	s ID="", QuitFlag=0
	F  s ID=$o(^DHCAPARCPO(0,"ArcPos",ArcDr,PosDr,ID)) Q:(ID="")||(QuitFlag'=0)  D
	.Q:(PartID'="")&($p(^DHCAPARCPO(ID),"^",3)'=PartID)
	.s QuitFlag=1
	.
	Q QuitFlag
}

}
