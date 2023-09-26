Class web.DHCEMPatHistory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-09
/// Description:： 保存或者新增 既往史字典
/// Table：        DHC_EmPatHistory
/// Input：	       PHCode：代码
///                PHDesc：描述
///                PHActiveFlag：是否可用             
///                PHHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
  		 s PHCode=$p(str,"^",1)
		 s PHDesc=$p(str,"^",2)
		 s PHActiveFlag=$p(str,"^",3)
		 s PHHospDr=$p(str,"^",4)
		 s PHHospDrID=$p(str,"^",5)
		 s ID=$p(str,"^",6)
		 s HospDr=$p(str,"^",7) //hxy 2020-05-12

		 i +ID=0 
		 { 
		 	 s obj=##class(User.DHCEmPatHistory).%New()
		 	 s obj.PHHospDr=##class(User.CTHospital).%OpenId(PHHospDr,0)
		 	 Q:$d(^DHCEMPHI(0,"code",PHCode)) 1 //hxy 2020-05-12 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
		 	 ;Q:..CheckExist(PHCode,HospDr) 1 //hxy 2020-05-12 //2023-01-18 注释
		 	
		 }else{
			 s obj=##class(User.DHCEmPatHistory).%OpenId(ID)
			 i +PHHospDr=0 d
			 .s obj.PHHospDr=##class(User.CTHospital).%OpenId(PHHospDrID,0)
			 e  d
			 .s obj.PHHospDr=##class(User.CTHospital).%OpenId(PHHospDr,0)
			 
			 s isIN=0
			 i $d(^DHCEMPHI(0,"code",PHCode)) d
			 .s PHIDUP=$O(^DHCEMPHI(0,"code",PHCode,""))
			 .q:PHIDUP=ID
			 .s isIN=1
			 q:isIN=1 1 //hxy 2020-05-12 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
			 ;s PHIDUP=..CheckExist(PHCode,HospDr) //hxy 2020-05-12 st //2023-01-18 注释
			 ;Q:(PHIDUP'=0)&(ID'=PHIDUP) 1 //ed
		 }
	
		 s obj.PHCode=PHCode
		 s obj.PHDesc=PHDesc
		 s obj.PHActiveFlag=PHActiveFlag

	     s sc=obj.%Save()
	     
	     d obj.%Close() //hxy 2020-05-12 st
	     s ret=""
	     s:+ID=0 ret=##Class(web.DHCEMCommonUtil).SaveHOSP("DHC_EmPatHistory",obj.%Id(),HospDr)
         q:ret<0 ret //ed
		 ;i $$$ISERR(sc) q -2
		 q 0
}

/// w ##class(web.DHCEMPatHistory).SavePatHis("1^1^Y^2^0^0^2")
ClassMethod SavePatHis(params)
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
	q:ret="-1^没有开启医院级授权" "-11" //hxy 2020-05-24
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-09
/// Description:： 分页显示既往史字典
/// Table：        DHC_EmPatHistory
/// Input：	      page：当前页数
///               rows：每页条数    
/// d ##class(web.DHCEMPatHistory).ListPatHis(,,"","","")
ClassMethod ListPatHis(page = 1, rows = 10, PHCode, PHDesc, HospDr, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMPHI(phId)) q:phId=""  d
		.q:phId=0
		.s code=$p(^DHCEMPHI(phId),"^",1)
		.s desc=$p(^DHCEMPHI(phId),"^",2)
		.s PHActiveFlag=$p(^DHCEMPHI(phId),"^",3)
		.s PHHospDr=$p(^DHCEMPHI(phId),"^",4)
		.s HospDesc=""
		.i PHHospDr'="" s HospDesc=$P(^CT("HOSP",PHHospDr),"^",2)
		.s tmp=phId_"^"_code_"^"_desc_"^"_PHActiveFlag_"^"_HospDesc_"^"_PHHospDr_"^"_HospDr //hxy 2020-05-12 HospDr
		.q:(PHCode'="")&(code'[PHCode)
		.q:(PHDesc'="")&(desc'[PHDesc)
		.q:(q'="")&(desc'[q)
		.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatHistory",phId,HospDr)'="Y" //hxy 2020-05-12
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEmPatHistory).%OpenId(phId)).Json()
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^PHCode^PHDesc^PHActiveFlag^PHHospDr^PHHospDrID^HospDr",tmp) //hxy 2020-05-12 HospDr
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-09
/// Description:： 查找一条既往史字典,以json形式返回
/// Table：        DHC_EmPatHistory
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCEMPatHistory).FindPatHis(1)
ClassMethod FindPatHis(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCEmPatHistory).%OpenId(Id,0)).Json()
	  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-09
/// Description:： 删除既往史字典
/// Table：        DHC_EmPatHistory
/// Input：	      Id：rowid
/// /Return：      操作成功 0，其他 失败
/// d ##class(web.DHCEMPatHistory).RemovePatHis()
ClassMethod RemovePatHis(Id)
{
  
	q:+Id=0 -1
	s $Zt="Err" //hxy 2020-05-12 加事务和删除关联表 st
  	TStart
  	s obj=##class(User.DHCEmPatHistory).%DeleteId(Id)
	s ret=##class(web.DHCEMCommonUtil).DeleteHospitals("DHC_EmPatHistory",Id) 
	q:ret<0 ret
	i ret<0 TRollback
	TCOMMIT
Err
	TRollback
	;s obj=##class(User.DHCEmPatHistory).%DeleteId(Id) //ed
	q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-09
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMPatHistory).ListIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是")) //2018-10-16 Y 是
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否")) //2018-10-16 N 否
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// d ##class(web.DHCEMPatHistory).CheckExist("03","2")
ClassMethod CheckExist(PHCode, HospDr)
{
	s ret=0
	s RowID=0
	f  s RowID=$o(^DHCEMPHI(0,"code",PHCode,RowID)) q:RowID=""  d
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatHistory",RowID,HospDr)'="Y"
	.s ret=RowID
	q ret
}

}
