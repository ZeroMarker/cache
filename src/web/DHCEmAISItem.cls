Class web.DHCEmAISItem Extends (%Persistent, %XML.Adaptor)
{

/// Creator：      zhanghailong
/// CreatDate：    2016-09-08
/// Description:   保存或者新增  子表
/// Table：        DHC_EmAIS
/// Input：	       AISScore：分数
///                AISItmDesc：描述
///                SYActiveFlag：是否可用              
/// Return：       保存成功 0，其他 失败
/// d ##class(web.DHCEmAISItem).SaveOrUpdate("9^3^6^Y^")
ClassMethod SaveOrUpdate(str)
{
  		 s AISParRefDr=$p(str,"^",1)
  		 s AISItmDesc=$p(str,"^",2)
  		 s AISItmCode=AISItmDesc
  		 s AISScore=$p(str,"^",3)
		 s AISActiveFlag=$p(str,"^",4)
		 s ID=$p(str,"^",5)
		 i +ID=0 
		 {
			 s obj=##class(User.DHCEmAISItem).%New()
			 Q:$d(^DHCEMAIS(0,"Code",AISParRefDr,AISItmCode)) 1
			 
		 }else{
			 s obj=##class(User.DHCEmAISItem).%OpenId(ID)
			 s isIN=0
			 i $d(^DHCEMAIS(0,"Code",AISParRefDr,AISItmCode)) d
			 .s PHIDUP=$O(^DHCEMAIS(0,"Code",AISParRefDr,AISItmCode,""))
			 .q:AISParRefDr_"||"_PHIDUP=ID
			 .s isIN=1
			 q:isIN=1 1
			 }
         i +ID=0 
		 {
		 s AISChlidSub=$o(^DHCEMAIS(AISParRefDr,""),-1)+1
		 }else{
			 s AISChlidSub=$p(ID,"||",2)
			 } 
         s obj.AISParRefDr=##class(User.DHCEmAIS).%OpenId(AISParRefDr)
         s obj.AISChlidSub=AISChlidSub
		 s obj.AISItmDesc=AISItmDesc
		 s obj.AISItmCode=AISItmCode
		 s obj.AISScore=AISScore
		 s obj.AISActiveFlag=AISActiveFlag
	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

/// d ##class(web.DHCEmAISItem).SaveSysItm()
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

/// Creator：      zhanghailong
/// CreatDate：    2016-09-08
/// Description：  分页显示 子表
/// Table：        DHC_EmAISItem
/// Input：	       page：当前页数
///                rows：每页条数
/// Return：       
/// d ##class(web.DHCEmAISItem).ListSysItm(,,"","","1","")
ClassMethod ListSysItm(page = 1, rows = 10, AISItmDesc, SAId, q)
{
	   
	    s start=(page-1)*rows+1
	    s end=page*rows
	    w:+SAId=0 "{""rows"":[],""total"":0}"
	    q:+SAId=0 ""
	    
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMAIS(phId)) q:phId=""  d
		.q:phId=0
		.q:SAId'=phId&SAId'=0
		.s child=""
		.f  s child=$o(^DHCEMAIS(phId,child)) quit:child=""  d 
		..s desc=$p(^DHCEMAIS(phId,child),"^",4)
		..s score=$p(^DHCEMAIS(phId,child),"^",5)
		..s flag=$p(^DHCEMAIS(phId,child),"^",6)
		..q:(AISItmDesc'="")&(AISItmDesc'=desc)
		..q:(q'="")&(desc'[q)
		..s Id=phId_"||"_child
		..s count=count+1
		..q:count<start
		..q:count>end
		..s tmp=Id_"^"_desc_"^"_score_"^"_flag_"^"_phId
	    ..w $case(count,start:"",:",")
	    ..w ##class(web.DHCAPPJsonCommon).getJsonData("ID^AISItmDesc^AISScore^AISActiveFlag^AISParRefDr",tmp)
	    ..;w jsonObj.FromObject(##class(User.DHCEmSysItm).%OpenId(Id)).Json() 
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      zhanghailong
/// CreatDate：    2016-09-08
/// Description：  删除 子表
/// Table：        DHC_EmAISItem
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveSysItm(Id)
{
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmAISItem).%DeleteId(Id)
	  q 0
}

Storage Default
{
<Data name="DHCEmAISItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEmAISItemD</DataLocation>
<DefaultData>DHCEmAISItemDefaultData</DefaultData>
<IdLocation>^web.DHCEmAISItemD</IdLocation>
<IndexLocation>^web.DHCEmAISItemI</IndexLocation>
<StreamLocation>^web.DHCEmAISItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
