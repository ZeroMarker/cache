Class web.DHCEMRentList Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      liyarong
/// CreatDate：    2016-10-26
/// Description:： 保存或者新增 出租物品
/// Table：        DHC_EmRentList
/// Input：	       RLCode：出租物品代码
///                RLDesc：出租物品描述
///                RLActiveFlag：是否可用             
///                RLHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
  		 s RLCode=$p(str,"^",1)
		 s RLDesc=$p(str,"^",2)
		 s RLActiveFlag=$p(str,"^",3)
		 s RLHospDr=$p(str,"^",4)
		 s RLHospDrID=$p(str,"^",5)
		 s ID=$p(str,"^",6)
		 s:$l(RLHospDr)>2 RLHospDr=RLHospDrID
		 i +ID=0 
		 { 
		 	 s obj=##class(User.DHCEmRentList).%New()
		 	 s obj.RLHospDr=##class(User.CTHospital).%OpenId(RLHospDr)
		 	 Q:$d(^DHCEMRLI(0,"code",RLCode)) 1 //hxy 2020-05-21 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
		 	 ;Q:..CheckExist(RLCode,RLHospDr) 1 //hxy 2020-05-21 //2023-01-18 注释
		 }else{
			 s obj=##class(User.DHCEmRentList).%OpenId(ID)
			 i +RLHospDr=0 d
			 .s obj.RLHospDr=##class(User.CTHospital).%OpenId(RLHospDrID)
			 e  d
			 .s obj.RLHospDr=##class(User.CTHospital).%OpenId(RLHospDr)
			 
			 s isIN=0
			 i $d(^DHCEMRLI(0,"code",RLCode)) d
			 .s RLIDUP=$O(^DHCEMRLI(0,"code",RLCode,""))
			 .q:RLIDUP=ID
			 .s isIN=1
			 q:isIN=1 1 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
			 ;s PHIDUP=..CheckExist(RLCode,RLHospDrID) //hxy 2020-05-21 st //2023-01-18 注释
			 ;Q:(PHIDUP'=0)&(ID'=PHIDUP) 1 //ed
			  }
	
		 s obj.RLCode=RLCode
		 s obj.RLDesc=RLDesc
		 s obj.RLActiveFlag=RLActiveFlag

	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

ClassMethod SaveRentList(params)
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

/// Creator：      liyarong
/// CreatDate：    2016-10-26
/// Description:： 分页显示出租物品
/// Table：        DHC_EmRentList
/// Input：	      page：当前页数
///               rows：每页条数    
/// d ##class(web.DHCEMRentList).ListRent(,,"","","")
ClassMethod ListRent(page = 1, rows = 10, RLCode, RLDesc, HospDr, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s RLId=""
		f  s RLId=$o(^DHCEMRL(RLId)) q:RLId=""  d
		.q:RLId=0
		.s code=$p(^DHCEMRL(RLId),"^",1)
		.s desc=$p(^DHCEMRL(RLId),"^",2)
		.s RLActiveFlag=$p(^DHCEMRL(RLId),"^",3)
		.s RLHospDr=$p(^DHCEMRL(RLId),"^",4)
		.s HospDesc=""
		.i RLHospDr'="" s HospDesc=$P(^CT("HOSP",RLHospDr),"^",2)
		.s tmp=RLId_"^"_code_"^"_desc_"^"_RLActiveFlag_"^"_HospDesc_"^"_RLHospDr
		.q:(RLCode'="")&(code'[RLCode)
		.q:(RLDesc'="")&(desc'[RLDesc)
		.q:(q'="")&(desc'[q)
		.q:RLHospDr'=HospDr //hxy 2020-05-24
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEMRentList).%OpenId(RLId)).Json()
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^RLCode^RLDesc^RLActiveFlag^RLHospDr^RLHospDrID",tmp)
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      liyarong
/// CreatDate：    2016-10-26
/// Description:： 查找一条出租物品,以json形式返回
/// Table：        DHC_EmRentList
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCEMRentList).FindRentList(1)
ClassMethod FindRentList(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCEmRentList).%OpenId(Id)).Json()
	  q ""
}

/// Creator：      liyarong
/// CreatDate：    2016-10-26
/// Description:： 删除出租物品
/// Table：        DHC_EmRentList
/// Input：	      Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod RemoveRentList(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmRentList).%DeleteId(Id)
	  q 0
}

/// Creator：      liyarong
/// CreatDate：    2016-10-26
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMRentList).ListIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是")) //hxy 2018-10-17 Y 是
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否")) //hxy 2018-10-17 N 否
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// w ##class(web.DHCEMRentList).CheckExist("1","2")
ClassMethod CheckExist(PHCode, HospDr)
{
	s ret=0
	s RowID=0
	f  s RowID=$o(^DHCEMRLI(0,"code",PHCode,RowID)) q:RowID=""  d
	.s RLHospDr=$p(^DHCEMRL(RowID),"^",4)
	.q:HospDr'=RLHospDr
	.s ret=RowID
	q ret
}

}
