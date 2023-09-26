Class web.DHCEMGCS Extends (%Persistent, %XML.Adaptor)
{

/// Creator：      guoguomin
/// CreatDate：    2016-09-08
/// Description:   保存或者新增 主表
/// Table：        DHC_EmGCS
/// Input：	       GCSItmDesc：描述
///                AIS_ActiveFlag：是否可用             
///                GCSHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
///   d ##class(web.DHCEMGCS).SaveOrUpdate("20^1^Y^2^0^0")
ClassMethod SaveOrUpdate(str)
{
         s GCSItmCode=$p(str,"^",1)
  		 s GCSItmDesc=$p(str,"^",1)
		 s GCSActiveFlag=$p(str,"^",2)
		 s GCSHospDr=$p(str,"^",3)
		 s GCSHospDrID=$p(str,"^",4)
		 s ID=$p(str,"^",5)
		 
		 /* ///2017-06-23 防止重复数据的添加
		 s isHasFlag = 0 
		 i $d(^DHCEMGCS(0,"Code",GCSItmDesc))'=0 d
		 .s GcsRowId = 0
		 .f  s GcsRowId= $o(^DHCEMGCS(0,"Code",GCSItmDesc,GcsRowId)) q:(GcsRowId="")||(isHasFlag=1)  d
		 ..q:$p(^DHCEMGCS(GcsRowId),"^",4)'=GCSHospDr
		 ..s isHasFlag=1
		 q:isHasFlag=1 "10" */  //hxy 2019-09-19 注释，/斜眼笑
		 
		 
		 i +ID=0 
		 {
			 s isIN=0
			 s obj=##class(User.DHCEmGCS).%New()
			 Q:$d(^DHCEMGCS(0,"Code",GCSItmCode)) 1 //hxy 2019-09-19 st
			 ;Q:$d(^DHCEMGCS(0,"CodeHos",GCSItmCode,GCSHospDr)) 1 //ed
			 ;s PHIDUP=$O(^DHCEMGCS(0,"Code",GCSItmCode,""))
			 s obj.GCSHospDr=##class(User.CTHospital).%OpenId(GCSHospDr,0)
			 
		 }else{
			 s isIN=0
			 s obj=##class(User.DHCEmGCS).%OpenId(ID)
			 i +GCSHospDr=0 d //hxy 2019-09-19 st
			 .s obj.GCSHospDr=##class(User.CTHospital).%OpenId(GCSHospDrID,0)
			 e  d
			 .s obj.GCSHospDr=##class(User.CTHospital).%OpenId(GCSHospDr,0)
			 
			 s isIN=0
			 i $d(^DHCEMGCS(0,"Code",GCSItmCode)) d
			 .s PHIDUP=$O(^DHCEMGCS(0,"Code",GCSItmCode,""))
			 .q:PHIDUP=ID
			 .s isIN=1
			 
			 /*i +GCSHospDr=0 d
			 .s obj.GCSHospDr=##class(User.CTHospital).%OpenId(GCSHospDrID)
			 .i $d(^DHCEMGCS(0,"CodeHos",GCSItmCode,GCSHospDrID)) d
			 ..s PHIDUP=$O(^DHCEMGCS(0,"CodeHos",GCSItmCode,GCSHospDrID,""))
			 ..q:PHIDUP=ID
			 ..s isIN=1
			 e  d
			 .s obj.GCSHospDr=##class(User.CTHospital).%OpenId(GCSHospDr)
			 .i $d(^DHCEMGCS(0,"CodeHos",GCSItmCode,GCSHospDr)) d
			 ..s PHIDUP=$O(^DHCEMGCS(0,"CodeHos",GCSItmCode,GCSHospDr,""))
			 ..q:PHIDUP=ID
			 ..s isIN=1 */ //hxy ed
			 
			 q:isIN=1 1 
			 }
		 s obj.GCSItmCode=GCSItmCode	 
		 s obj.GCSItmDesc=GCSItmDesc
		 s obj.GCSActiveFlag=GCSActiveFlag
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

/// Creator：      guoguomin
/// CreatDate：    2016-09-08
/// Description：  分页显示主表
/// Table：        DHC_EmGCS
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCEMGCS).ListSys(,,"")
ClassMethod ListSys(page = 1, rows = 10, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMGCS(phId)) q:phId=""  d
		.q:phId=0
		.s GCSItmDesc=$p(^DHCEMGCS(phId),"^",1)
		.s GCSItmCode=$p(^DHCEMGCS(phId),"^",2)
		.s GCSActiveFlag=$p(^DHCEMGCS(phId),"^",3)
		.s GCSHospDr=$p(^DHCEMGCS(phId),"^",4)
		.s GCSHospDesc="" //hxy 2019-09-19
		.s:GCSHospDr'="" GCSHospDesc=$P(^CT("HOSP",GCSHospDr),"^",2)
		.s tmp=phId_"^"_GCSItmCode_"^"_GCSItmDesc_"^"_GCSActiveFlag_"^"_GCSHospDesc_"^"_GCSHospDr
		.q:(q'="")&(GCSItmDesc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
	    .;w jsonObj.FromObject(##class(User.DHCEmSys).%OpenId(phId)).Json()
	    .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^GCSItmCode^GCSItmDesc^GCSActiveFlag^GCSHospDr^GCSHospDrID",tmp)
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      guoguomin
/// CreatDate：    2016-09-08
/// Description：  查找一条产品表,以json形式返回
/// Table：        DHC_EmGCS
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCEMSys).FindSys(1)
ClassMethod FindSys(Id)
{
	  q:+Id=0 ""
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCEmGCS).%OpenId(Id,0)).Json()
	  q ""
}

/// Creator：      guoguomin
/// CreatDate：    2016-09-08
/// Description：  删除主表
/// Table：        DHC_EmGCS
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveSys(Id)
{
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmGCS).%DeleteId(Id)
	  s child=""
	  f  s child=$o(^DHCEMGCS(Id,child)) quit:child=""  d
	  .s childId=Id_"||"_child
	  .s obj=##class(User.DHCEmGCSItem).%DeleteId(childId) 
	  q 0
}

/// Creator：      guoguomin
/// CreatDate：    2016-09-08
/// Description：  下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMGCS).listIsActive()
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
<Data name="DHCEMGCSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMGCSD</DataLocation>
<DefaultData>DHCEMGCSDefaultData</DefaultData>
<IdLocation>^web.DHCEMGCSD</IdLocation>
<IndexLocation>^web.DHCEMGCSI</IndexLocation>
<StreamLocation>^web.DHCEMGCSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
