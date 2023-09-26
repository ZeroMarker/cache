Class web.DHCEMPatAware Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-25
/// Description:   保存或者新增 病人意识状态字典
/// Table：        DHC_EmPatAware
/// Input：	       PACode：代码
///                PADesc：描述
///                PAActiveFlag：是否可用             
///                PAHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
  		 s PACode=$p(str,"^",1)
		 s PADesc=$p(str,"^",2)
		 s PAScore = +$p(str,"^",3)
		 s:$p(str,"^",3)="" PAScore="" //hxy 2020-05-13 
		 s PAActiveFlag=$p(str,"^",4)
		 s PAHospDr=$p(str,"^",5)
		 s PAHospDrID=$p(str,"^",6)
		 s ID=$p(str,"^",7)
		 s HospDr=$p(str,"^",8) //hxy 2020-05-13

		 i +ID=0 
		 {
			s obj=##class(User.DHCEmPatAware).%New() 
			s obj.PAHospDr=##class(User.CTHospital).%OpenId(PAHospDr,0)
			Q:$d(^DHCEMPAW(0,"Code",PACode)) 1 //hxy 2020-05-13 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
		 	;Q:..CheckExist(PACode,HospDr) 1 //hxy 2020-05-13 //2023-01-18 注释
		 }else{
			 s obj=##class(User.DHCEmPatAware).%OpenId(ID)
			 i +PAHospDr=0 d
			 .s obj.PAHospDr=##class(User.CTHospital).%OpenId(PAHospDrID,0)
			 e  d
			 .s obj.PAHospDr=##class(User.CTHospital).%OpenId(PAHospDr,0)
			 
			 s isIN=0
			 i $d(^DHCEMPAW(0,"Code",PACode)) d
			 .s PHIDUP=$O(^DHCEMPAW(0,"Code",PACode,""))
			 .q:PHIDUP=ID
			 .s isIN=1
			 q:isIN=1 1 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
			 ;s PHIDUP=..CheckExist(PACode,HospDr) //hxy 2020-05-13 st //2023-01-18 注释
			 ;Q:(PHIDUP'=0)&(ID'=PHIDUP) 1 //ed
		 }
		
		 s obj.PACode=PACode
		 s obj.PADesc=PADesc
		 s obj.PAActiveFlag=PAActiveFlag
	 	 s obj.PAScore=PAScore
	     s sc=obj.%Save()   
	     
	     d obj.%Close() //hxy 2020-05-13 st
	     s ret=""
	     s:+ID=0 ret=##Class(web.DHCEMCommonUtil).SaveHOSP("DHC_EmPatAware",obj.%Id(),HospDr)
         q:ret<0 ret //ed
		 ;i $$$ISERR(sc) q -2
		 q 0
}

ClassMethod SavePatAware(params)
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
/// CreatDate：    2016-05-25
/// Description:   分页显示病人意识状态字典
/// Table：        DHC_EmPatAware
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCEMPatAware).ListPatAware(,,"","","")
ClassMethod ListPatAware(page = 1, rows = 10, PACode, PADesc, HospDr, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMPAW(phId)) q:phId=""  d
		.q:phId=0
		.s code=$p(^DHCEMPAW(phId),"^",1)
		.s desc=$p(^DHCEMPAW(phId),"^",2)
		.s PAActiveFlag=$p(^DHCEMPAW(phId),"^",3)
		.s PAHospDr=$p(^DHCEMPAW(phId),"^",4)
		.s HospDesc="" //2019-12-26
		.s:PAHospDr'="" HospDesc=$P(^CT("HOSP",PAHospDr),"^",2)
		.s PAScore=$p(^DHCEMPAW(phId),"^",5)
		.s tmp=phId_"^"_code_"^"_desc_"^"_PAActiveFlag_"^"_HospDesc_"^"_PAHospDr_"^"_PAScore_"^"_HospDr //hxy 2020-05-13 HospDr
		.q:(PACode'="")&(code'[PACode)
		.q:(PADesc'="")&(desc'[PADesc)
		.q:(q'="")&(desc'[q)
		.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatAware",phId,HospDr)'="Y" //hxy 2020-05-13
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEmPatAware).%OpenId(phId)).Json()
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^PACode^PADesc^PAActiveFlag^PAHospDr^PAHospDrID^PAScore^HospDr",tmp) //hxy 2020-05-13 HospDr
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-25
/// Description：  查找一条病人意识状态字典,以json形式返回
/// Table：        DHC_EmPatAware
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCEMPatAware).FindPatAware(1)
ClassMethod FindPatAware(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCEmPatAware).%OpenId(Id,0)).Json()
	  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-25
/// Description:   删除病人意识状态字典
/// Table：        DHC_EmPatAware
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemovePatAware(Id)
{
  
	q:+Id=0 -1
	s $Zt="Err" //hxy 2020-05-13 加事务和删除关联表 st
  	TStart
  	s obj=##class(User.DHCEmPatHistory).%DeleteId(Id)
	s ret=##class(web.DHCEMCommonUtil).DeleteHospitals("DHC_EmPatAware",Id) 
	q:ret<0 ret
	i ret<0 TRollback
	TCOMMIT
Err
	TRollback
	;s obj=##class(User.DHCEmPatAware).%DeleteId(Id) //ed
	q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-25
/// Description：  下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMPatAware).listIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是")) //2018-10-16 Y
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否")) //2018-10-16 N
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// d ##class(web.DHCEMPatHistory).CheckExist("03","2")
ClassMethod CheckExist(PHCode, HospDr)
{
	s ret=0
	s RowID=0
	f  s RowID=$o(^DHCEMPAW(0,"Code",PHCode,RowID)) q:RowID=""  d
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatAware",RowID,HospDr)'="Y"
	.s ret=RowID
	q ret
}

}
