Import sqluser

/// Descript:Grid列设置
/// Creater:    ZhangHaiLong
/// CreateDate: 2012-11-17
Class web.DHCEmSysGridSet Extends %RegisteredObject [ ProcedureBlock ]
{

/// Descript:删除grid 列设置
/// Creater:    ZhangHaiLong
/// CreateDate: 2011-11-17
/// Table:DHC_EmSysGridSet
/// Input:
/// Output:     
/// Return：	
/// w ##class(web.DHCEmSysGridSet).ListSys()
ClassMethod ListSys(page = 1, rows = 10, q)
{
	 s start=(page-1)*rows+1
	 s end=page*rows
	 s count=0
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
     w "{""rows"":["
	 s cspname=""
	 f  s cspname=$o(^DHCEMSGS(0,"Grid",cspname)) q:cspname=""  d
	 .s gridId=""
	 .f  s gridId=$o(^DHCEMSGS(0,"Grid",cspname,gridId)) q:gridId=""  d 
	 ..s savefor=""
	 ..f  s savefor=$o(^DHCEMSGS(0,"Grid",cspname,gridId,savefor))  q:savefor=""  d
	 ...s SGSCspName=cspname
	 ...s SGSGridID=gridId
	 ...s SGSSaveFor=savefor
	 ...s SGSReference=""
	 ...f  s SGSReference=$o(^DHCEMSGS(0,"Grid",cspname,gridId,savefor,SGSReference)) q:SGSReference=""  d
	 ....s tmp=SGSGridID_"^"_SGSCspName_"^"_SGSSaveFor_"^"_SGSReference
	 ....s count=count+1
	 ....q:count<start
	 ....q:count>end
	 ....w $case(count,start:"",:",")
	 ....w ##class(web.DHCAPPJsonCommon).getJsonData("SGSGridID^SGSCspName^SGSSaveFor^SGSReference",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Descript:删除grid 列设置
/// Creater:    ZhangHaiLong
/// CreateDate: 2011-11-17
/// Table:DHC_EmSysGridSet
/// Input:SGSGridID,SGSCspName，SGSSaveFor，SGSReference
/// Output:     
/// Return：成功：0;
/// w ##class(web.DHCEmSysGridSet).GetColumnInfo(1,"zhl.csp","USER",590,,,)
ClassMethod GetColumnInfo(SGSGridID As %String, SGSCspName As %String, SGSSaveFor As %String, SGSReference As %String, page = 1, rows = 10, q)
{
	q:SGSGridID="" -1
	q:SGSCspName="" -1
	q:SGSSaveFor="" -1
	q:SGSReference="" -1
	s start=(page-1)*rows+1
	s end=page*rows
    s count=0
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
    w "{""rows"":["
    s SGSCspName=$$ALPHAUP^SSUTIL4(SGSCspName)
	s SGSRowId=""
	f  s SGSRowId=$o(^DHCEMSGS(0,"Grid",SGSCspName,SGSGridID,SGSSaveFor,SGSReference,SGSRowId))  q:SGSRowId=""  d
	.s SGSGridID=$p(^DHCEMSGS(SGSRowId),"^",1)
	.s SGSCspName=$$ALPHAUP^SSUTIL4($p(^DHCEMSGS(SGSRowId),"^",2))
	.s SGSSaveFor=$p(^DHCEMSGS(SGSRowId),"^",3)
	.s SGSReference=$p(^DHCEMSGS(SGSRowId),"^",4)
	.s SGSKey=$p(^DHCEMSGS(SGSRowId),"^",5)
	.s SGSName=$p(^DHCEMSGS(SGSRowId),"^",6)
	.s SGSHeader=$p(^DHCEMSGS(SGSRowId),"^",7)
	.s SGSWidth=$p(^DHCEMSGS(SGSRowId),"^",8)
	.s SGSAlignment=$p(^DHCEMSGS(SGSRowId),"^",9)
	.s SGSHidden=$p(^DHCEMSGS(SGSRowId),"^",10)
	.s SGSOrderNum=$p(^DHCEMSGS(SGSRowId),"^",11)
	.s tmp=SGSGridID_"^"_SGSCspName_"^"_SGSSaveFor_"^"_SGSReference_"^"_SGSKey_"^"_SGSName_"^"_SGSHeader_"^"_SGSWidth_"^"_SGSAlignment_"^"_SGSHidden_"^"_SGSOrderNum_"^"_SGSRowId
	.s count=count+1
	.q:count<start
    .q:count>end
	.w $case(count,start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("SGSGridID^SGSCspName^SGSSaveFor^SGSReference^SGSKey^SGSName^SGSHeader^SGSWidth^SGSAlignment^SGSHidden^SGSOrderNum^SGSRowId",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：      zhanghailong
/// CreatDate：    2016-09-08
/// Description：  下拉列表显示
/// Return
/// w ##class(web.DHCEmSysGridSet).GetAlign()	
ClassMethod GetAlign()
{
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","left").Put("text","left"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","center").Put("text","center"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","right").Put("text","right"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Creator：      zhanghailong
/// CreatDate：    2016-09-08
/// Description：  下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEmSysGridSet).ListIsActive()
ClassMethod ListIsActive()
{
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 s listObj=##class(%ListOfObjects).%New()
	 d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","Y"))
	 d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","N"))
	 w jsonObj.ListToJson(listObj)	
	 q ""
}

/// Descript:删除grid 列设置
/// Creater:    ZhangHaiLong
/// CreateDate: 2011-11-17
/// Table:DHC_EmSysGridSet
/// Input:rowid,
/// 顺序号^列id^列标题^宽度^对齐方式^是否排序^是否隐藏^名称^显示格式^数据类型
/// Output:     
/// Return：成功：0;
/// w ##class(web.DHCEmSysGridSet).Delete(1,"zhl.csp","USER",590)
ClassMethod Delete(SGSGridID As %String, SGSCspName As %String, SGSSaveFor As %String, SGSReference As %String)
{
	n (SGSGridID,SGSCspName,SGSSaveFor,SGSReference)
	q:SGSGridID="" -1
	q:SGSCspName="" -1
	q:SGSSaveFor="" -1
	q:SGSReference="" -1
	s Err=0
	&sql(Delete from DHC_EmSysGridSet where SGS_GridID=:SGSGridID and SGS_SaveFor=:SGSSaveFor 
    and SGS_Reference=:SGSReference and SGS_CspName=:SGSCspName)
    i SQLCODE'=0  d
    .s Err=-1
    q Err
}

/// Descript:保存修改grid 列设置
/// Creater:    ZhangHaiLong
/// CreateDate: 2011-11-17
/// Table:DHC_EmSysGridSet
/// Input:str
/// Output:     
/// Return：成功：0;
/// w ##class(web.DHCEmSysGridSet).SaveOrUpdate("3^ZHASLCSP^ITE^590^27^12^1^1^center^Y^1^1")
ClassMethod SaveOrUpdate(str)
{
  	s SGSRowId=$p(str,"^",5)
    s SGSGridID=$p(str,"^",1)
    s SGSCspName=$$ALPHAUP^SSUTIL4($p(str,"^",2))
    s SGSSaveFor=$p(str,"^",3)
    s SGSReference=$p(str,"^",4)
    s SGSName=$p(str,"^",6)
    s SGSHeader=$p(str,"^",7)
	s SGSWidth=$p(str,"^",8)
	s SGSAlignment=$p(str,"^",9)
	s SGSHidden=$p(str,"^",10)
    s SGSOrderNum=$p(str,"^",11)
	s SGSKey=$p(str,"^",12)
	s Err=0
    i +SGSRowId=0 
	 {
	   &sql(Insert into DHC_EmSysGridSet (SGS_GridID,SGS_CspName,SGS_SaveFor,SGS_Reference,SGS_Name,SGS_Header
	   ,SGS_Width,SGS_Alignment,SGS_Hidden,SGS_OrderNum,SGS_Key)
       values(:SGSGridID,:SGSCspName,:SGSSaveFor,:SGSReference,:SGSName,:SGSHeader,:SGSWidth,:SGSAlignment,
       :SGSHidden,:SGSOrderNum,:SGSKey))
        i SQLCODE'=0  d
         .s Err=-1	 
		  }else{
	    s Err=0
	  &sql(Update DHC_EmSysGridSet set SGS_Name=:SGSName,SGS_Header=:SGSHeader,
      SGS_Width=:SGSWidth,SGS_Alignment=:SGSAlignment,SGS_Hidden=:SGSHidden,
      SGS_OrderNum=:SGSOrderNum,SGS_Key=:SGSKey where SGS_RowId=:SGSRowId)
        i SQLCODE'=0  d
        .s Err=-1
	 }
	 q Err
}

/// Descript:保存修改grid 列设置
/// Creater:    ZhangHaiLong
/// CreateDate: 2011-11-17
/// Table:DHC_EmSysGridSet
/// Input:str
/// Output:     
/// Return：成功：0;
ClassMethod SaveSys(params)
{
  s $Zt="Err"
  TStart
  s ret=0
  s len=$l(params,"$$")
  for i=1:1:len d
   .q:ret<0
   .s str=$p(params,"$$",i)
   .s ret=..SaveOrUpdate(str)
  i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// w ##class(web.DHCEmSysGridSet).Test()
ClassMethod Test()
{
	s cc=1
	d ..TestSub()
	w cc,!
}

ClassMethod TestSub()
{
	 
	s cc=2
}

}
