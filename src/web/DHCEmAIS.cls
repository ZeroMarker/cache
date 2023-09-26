Class web.DHCEmAIS Extends (%Persistent, %XML.Adaptor)
{

/// Creator：      zhanghailong
/// CreatDate：    2016-09-08
/// Description:   保存或者新增 主表
/// Table：        DHC_EmAIS
/// Input：	       AISItmDesc：描述
///                AIS_ActiveFlag：是否可用             
///                AISHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
///   w ##class(web.DHCEmAIS).SaveOrUpdate("呼吸频率^Y^2^0^0")
ClassMethod SaveOrUpdate(str)
{
  		 s AISItmDesc=$p(str,"^",1)
  		 s AISItmCode=AISItmDesc
		 s AISActiveFlag=$p(str,"^",2)
		 s AISHospDr=$p(str,"^",3)
		 s AISHospDrID=$p(str,"^",4)
		 s ID=$p(str,"^",5)
		 
		 ///2017-06-21 防止重复数据的添加
		 s isHasFlag = 0 
		 i $d(^DHCEMAIS(0,"Code",AISItmDesc))'=0 d
		 .s AisRowId = 0
		 .f  s AisRowId= $o(^DHCEMAIS(0,"Code",AISItmDesc,AisRowId)) q:(AisRowId="")||(isHasFlag=1)  d
		 ..q:AisRowId=ID
		 ..s isHasFlag=1
		 q:isHasFlag=1 "10"
		 
		 i +ID=0 
		 {
			 s isIN=0
			 s obj=##class(User.DHCEmAIS).%New()
			 Q:$d(^DHCEMAIS(0,"CodeHos",AISItmCode,AISHospDr)) 1 
			 ;Q:$d(^DHCEMAIS(0,"Code",AISItmCode)) 1
			 s obj.AISHospDr=##class(User.CTHospital).%OpenId(AISHospDr)
			 
		 }else{
			 s isIN=0
			 s obj=##class(User.DHCEmAIS).%OpenId(ID)
			 i +AISHospDr=0 d
			 .s obj.AISHospDr=##class(User.CTHospital).%OpenId(AISHospDrID)
			 .i $d(^DHCEMAIS(0,"CodeHos",AISItmCode,AISHospDrID)) d
			 ..s PHIDUP=$O(^DHCEMAIS(0,"CodeHos",AISItmCode,AISHospDrID,""))
			 ..q:PHIDUP=ID
			 ..s isIN=1
			 e  d
			 .s obj.AISHospDr=##class(User.CTHospital).%OpenId(AISHospDr)
			 .i $d(^DHCEMAIS(0,"CodeHos",AISItmCode,AISHospDr)) d
			 ..s PHIDUP=$O(^DHCEMAIS(0,"CodeHos",AISItmCode,AISHospDr,""))
			 ..q:PHIDUP=ID
			 ..s isIN=1
			 q:isIN=1 1 
			 }
		 s obj.AISItmDesc=AISItmDesc
		 s obj.AISItmCode=AISItmCode
		 s obj.AISActiveFlag=AISActiveFlag
	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

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

/// Creator：      zhanghailong
/// CreatDate：    2016-09-08
/// Description：  分页显示主表
/// Table：        DHC_EmAIS
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCEmAIS).ListSys(,,"")
ClassMethod ListSys(page = 1, rows = 10, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMAIS(phId)) q:phId=""  d
		.q:phId=0
		.s AISItmDesc=$p(^DHCEMAIS(phId),"^",1)
		.s AISItmCode=$p(^DHCEMAIS(phId),"^",2)
		.s AISActiveFlag=$p(^DHCEMAIS(phId),"^",3)
		.s AISHospDr=$p(^DHCEMAIS(phId),"^",4)
		.s AISHospDesc="" //hxy 2019-09-19
		.s:AISHospDr'="" AISHospDesc=$P(^CT("HOSP",AISHospDr),"^",2)
		.s tmp=phId_"^"_AISItmDesc_"^"_AISItmCode_"^"_AISActiveFlag_"^"_AISHospDesc_"^"_AISHospDr
		.q:(q'="")&(AISItmDesc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
	    .;w jsonObj.FromObject(##class(User.DHCEmSys).%OpenId(phId)).Json()
	    .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^AISItmDesc^AISItmCode^AISActiveFlag^AISHospDr^AISHospDrID",tmp)
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      zhanghailong
/// CreatDate：    2016-09-08
/// Description：  查找一条产品表,以json形式返回
/// Table：        DHC_EmAIS
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCEMSys).FindSys(1)
ClassMethod FindSys(Id)
{
	  q:+Id=0 ""
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCEmAIS).%OpenId(Id)).Json()
	  q ""
}

/// Creator：      zhanghailong
/// CreatDate：    2016-09-08
/// Description：  删除主表
/// Table：        DHC_EmAIS
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveSys(Id)
{
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmAIS).%DeleteId(Id)
	  s child=""
	  f  s child=$o(^DHCEMAIS(Id,child)) quit:child=""  d
	  .s childId=Id_"||"_child
	  .s obj=##class(User.DHCEmAISItem).%DeleteId(childId) 
	  q 0
}

/// Creator：      zhanghailong
/// CreatDate：    2016-09-08
/// Description：  下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEmAIS).listIsActive()
ClassMethod ListIsActive()
{
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是")) //hxy 2018-10-17 Y 是
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否")) //hxy 2018-10-17 N 否
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

Storage Default
{
<Data name="DHCEmAISDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEmAISD</DataLocation>
<DefaultData>DHCEmAISDefaultData</DefaultData>
<IdLocation>^web.DHCEmAISD</IdLocation>
<IndexLocation>^web.DHCEmAISI</IndexLocation>
<StreamLocation>^web.DHCEmAISS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
