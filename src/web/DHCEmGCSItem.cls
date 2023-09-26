Class web.DHCEmGCSItem Extends (%Persistent, %XML.Adaptor)
{

/// Creator：      guoguomin
/// CreatDate：    2016-09-08
/// Description:   保存或者新增  子表
/// Table：        DHC_EmGCS
/// Input：	       GCSScore：分数
///                GCSItmDesc：描述
///                SYActiveFlag：是否可用              
/// Return：       保存成功 0，其他 失败
/// d ##class(web.DHCEmGCSItem).SaveOrUpdate("2^9^3^6^Y^")
ClassMethod SaveOrUpdate(str)
{
	 s GCSParRefDr=$p(str,"^",1)
	 s GCSItmCode=$p(str,"^",2)
	 s GCSItmDesc=$p(str,"^",2)
	 s GCSScore=$p(str,"^",3)
	 s GCSActiveFlag=$p(str,"^",4)
	 s ID=$p(str,"^",5)
	
	  ///2017-06-23 防止重复数据的添加
	 s isHasFlag = 0 
	 //4^搭错话2^4^Y^4||6
	 s GCSParItmSub =""
	 f  s GCSParItmSub =$o(^DHCEMGCS(GCSParRefDr,"I",GCSParItmSub))  q:(GCSParItmSub="")||(isHasFlag'=0)  d
	 .s ItmID = GCSParRefDr_"||"_GCSParItmSub
	 .s ItmCode = $p(^DHCEMGCS(GCSParRefDr,"I",GCSParItmSub),"^",3)
	 .q:ItmCode'=GCSItmCode
	 .q:(ItmCode=GCSItmCode)&&(ID'="")&&(ID=ItmID)
	 .b ;err  
	 .s isHasFlag=1
	 
	 q:isHasFlag=1 10

	 i +ID=0 
	 {
		 s obj=##class(User.DHCEmGCSItem).%New()  //add
		 
	 }else{
		 s obj=##class(User.DHCEmGCSItem).%OpenId(ID) //update
	}

	 i +ID=0 
	 {
	 s GCSChildSub=$o(^DHCEMGCS(GCSParRefDr,"I",""),-1)+1	 
	 }else{
		 s GCSChildSub=$p(ID,"||",2)
		 }
		 
	 s obj.GCSParRefDr=##class(User.DHCEmGCS).%OpenId(GCSParRefDr)
	 s obj.GCSChildSub=GCSChildSub
	 s obj.GCSItmCode=GCSItmCode
	 s obj.GCSScore=GCSScore
	 s obj.GCSItmDesc=GCSItmDesc
	 s obj.GCSActiveFlag=GCSActiveFlag
	 s sc=obj.%Save()   
	 ;i $$$ISERR(sc) q -2
	 q 0
}

/// d ##class(web.DHCEmGCSItem).SaveSysItm()
ClassMethod SaveSysItm(params)
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

/// Creator：      guoguomin
/// CreatDate：    2016-09-08
/// Description：  分页显示 子表
/// Table：        DHC_EmGCSItem
/// Input：	       page：当前页数
///                rows：每页条数
/// Return：       
/// d ##class(web.DHCEmGCSItem).ListSysItm(,,"","","1","")
ClassMethod ListSysItm(page = 1, rows = 10, GCSItmDesc, SAId, q)
{
	   
	    s start=(page-1)*rows+1
	    s end=page*rows
	    w:+SAId=0 "{""rows"":[],""total"":0}"
	    q:+SAId=0 ""
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMGCS(phId)) q:phId=""  d
		.q:phId=0
		.q:SAId'=phId&SAId'=0
		.s child=""
		.f  s child=$o(^DHCEMGCS(phId,"I",child)) quit:child=""  d 
		..s code=$p(^DHCEMGCS(phId,"I",child),"^",3)
		..s desc=$p(^DHCEMGCS(phId,"I",child),"^",4)
		..s score=$p(^DHCEMGCS(phId,"I",child),"^",5)
		..s flag=$p(^DHCEMGCS(phId,"I",child),"^",6)
		..q:(GCSItmDesc'="")&(GCSItmDesc'=desc)
		..q:(GCSItmDesc)&(GCSItmDesc'=code)
		..q:(q'="")&(desc'[q)
		..s Id=phId_"||"_child
		..s count=count+1
		..q:count<start
		..q:count>end
		..s tmp=Id_"^"_code_"^"_desc_"^"_score_"^"_flag_"^"_phId
	    ..w $case(count,start:"",:",")
	    ..w ##class(web.DHCAPPJsonCommon).getJsonData("ID^GCSItmCode^GCSItmDesc^GCSScore^GCSActiveFlag^GCSParRefDr",tmp)
	    ..;w jsonObj.FromObject(##class(User.DHCEmGCSItem).%OpenId(Id)).Json() 
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      guoguomin
/// CreatDate：    2016-09-08
/// Description：  删除 子表
/// Table：        DHC_EmGCSItem
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveSysItm(Id)
{
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmGCSItem).%DeleteId(Id)
	  q 0
}

Storage Default
{
<Data name="DHCEmGCSItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEmGCSItemD</DataLocation>
<DefaultData>DHCEmGCSItemDefaultData</DefaultData>
<IdLocation>^web.DHCEmGCSItemD</IdLocation>
<IndexLocation>^web.DHCEmGCSItemI</IndexLocation>
<StreamLocation>^web.DHCEmGCSItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
