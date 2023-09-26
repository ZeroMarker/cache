Class web.DHCEMLevKey Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-31
/// Description:   保存或者新增 分级指标关键字库表
/// Table：        DHC_EmLevKey
/// Input：	       LKCode：代码
///                LKDesc：描述
///                LKRemark:备注
///                LKActiveFlag：是否可用             
///                LKHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
/// w ##class(web.DHCEMLevKey).SaveOrUpdate("222^22^N^意识形态清醒^3^3^7")
ClassMethod SaveOrUpdate(str)
{
  		 s LKCode=$p(str,"^",1)
		 s LKDesc=$p(str,"^",2)
		 s LKActiveFlag=$p(str,"^",3)
		 s LKRemark=$p(str,"^",4)
		 s LKHospDr=$p(str,"^",5)
		 s LKHospDrID=$p(str,"^",6)
		 s ID=$p(str,"^",7)
		 s:+LKHospDr=0 LKHospDr=LKHospDrID
		 s HasLKHospID=""
		 s LKRowID = $O(^DHCEMLK(0,"Code",LKCode,""))
		 s:LKRowID'="" HasLKHospID=$p(^DHCEMLK(LKRowID),"^",5)
	
		 ;Q:(LKRowID'="")&&(LKRowID'=ID)&&(HasLKHospID=LKHospDr) 1 //hxy 2020-12-28 st 改为公有
		 Q:(LKRowID'="")&&(LKRowID'=ID) 1 //ed
		 
		 i +ID=0 
		 {
			 s obj=##class(User.DHCEmLevKey).%New()
		 }else{
			 s obj=##class(User.DHCEmLevKey).%OpenId(ID)
			
			
		}
 		 s obj.LKHospDr=##class(User.CTHospital).%OpenId(LKHospDr,0)
		 s obj.LKCode=LKCode
		 s obj.LKDesc=LKDesc
		 s obj.LKActiveFlag=LKActiveFlag
		 s obj.LKRemark=LKRemark
	 	 
	 	 
	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

ClassMethod SaveLevKey(params)
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

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-31
/// Description:： 分页显示分级指标关键字库表
/// Table：        DHC_EmLevKey
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCEMLevKey).ListLevKey(,,"","","")
ClassMethod ListLevKey(page = 1, rows = 10, LKCode, LKDesc, hospDrID, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMLK(phId)) q:phId=""  d
		.q:phId=0
		.s code=$p(^DHCEMLK(phId),"^",1)
		.s desc=$p(^DHCEMLK(phId),"^",2)
		.s LKActiveFlag=$p(^DHCEMLK(phId),"^",3)
		.s LKRemark=$p(^DHCEMLK(phId),"^",4)
		.s LKHospDr=$p(^DHCEMLK(phId),"^",5)
		.q:(hospDrID'="")&(hospDrID'=LKHospDr) //hxy 2019-07-20
		.s HospDesc=$P(^CT("HOSP",LKHospDr),"^",2)
		.s tmp=phId_"^"_code_"^"_desc_"^"_LKActiveFlag_"^"_LKRemark_"^"_HospDesc_"^"_LKHospDr
		.q:(LKCode'="")&(code'[LKCode)
		.q:(LKDesc'="")&(desc'[LKDesc)
		.q:(q'="")&(desc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEmLevKey).%OpenId(phId)).Json()
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^LKCode^LKDesc^LKActiveFlag^LKRemark^LKHospDr^LKHospDrID",tmp)
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-22
/// Description:： 分页显示可用分级指标关键字库表
/// Table：        DHC_EmLevKey
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCEMLevKey).ListLevKeyY(,,"","","")
ClassMethod ListLevKeyY(page = 1, rows = 10, LKCode, LKDesc, themeID, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMLK(phId)) q:phId=""  d
		.q:phId=0
		.s code=$p(^DHCEMLK(phId),"^",1)
		.s desc=$p(^DHCEMLK(phId),"^",2)
		.s LKActiveFlag=$p(^DHCEMLK(phId),"^",3)
		.q:LKActiveFlag="N"
		.s LKRemark=$p(^DHCEMLK(phId),"^",4)
		.s LKHospDr=$p(^DHCEMLK(phId),"^",5)
		.;s LTHHospDr=$p(^DHCEMLTH(themeID),"^",5) //hxy 2020-12-28 改为公有 st
		.;q:LKHospDr'=LTHHospDr //ed
		.s HospDesc=$P(^CT("HOSP",LKHospDr),"^",2)
		.s tmp=phId_"^"_code_"^"_desc_"^"_LKActiveFlag_"^"_LKRemark_"^"_HospDesc_"^"_LKHospDr
		.q:(LKCode'="")&(LKCode'=code)
		.q:(LKDesc'="")&(LKDesc'=desc)
		.q:(q'="")&(desc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEmLevKey).%OpenId(phId)).Json()
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^LKCode^LKDesc^LKActiveFlag^LKRemark^LKHospDr^LKHospDrID",tmp)
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-31
/// Description:： 删除分级指标关键字库表
/// Table：        DHC_EmLevKey
/// Input：	      Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod RemoveLevKey(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmLevKey).%DeleteId(Id)
	  q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-31
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMLevKey).listIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是")) //2018-10-16 Y 是
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否")) //2018-10-16 N 否
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

}
