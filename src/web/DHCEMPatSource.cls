Class web.DHCEMPatSource Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-11
/// Description:   保存或者新增 病人来源字典
/// Table：        DHC_EmPatSource
/// Input：	       PSCode：代码
///                PSDesc：描述
///                PSActiveFlag：是否可用             
///                PSHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
  		 s PSCode=$p(str,"^",1)
		 s PSDesc=$p(str,"^",2)
		 s PSActiveFlag=$p(str,"^",3)
		 s PSHospDr=$p(str,"^",4)
		 s PSHospDrID=$p(str,"^",5)
		 s ID=$p(str,"^",6)
		 s HospDr=$p(str,"^",7) //hxy 2020-05-12

		 i +ID=0 
		 {
			 s obj=##class(User.DHCEmPatSource).%New()
			 s obj.PSHospDr=##class(User.CTHospital).%OpenId(PSHospDr)
			 Q:$d(^DHCEMPSO(0,"code",PSCode)) 1 //hxy 2020-05-12 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
			 ;Q:..CheckExist(PSCode,HospDr) 1 //hxy 2020-05-12 //2023-01-18 注释
			 
		 }else{
			 s obj=##class(User.DHCEmPatSource).%OpenId(ID)
			 i +PSHospDr=0 d
			 .s obj.PSHospDr=##class(User.CTHospital).%OpenId(PSHospDrID)
			 e  d
			 .s obj.PSHospDr=##class(User.CTHospital).%OpenId(PSHospDr)
			 
			 s isIN=0
			 i $d(^DHCEMPSO(0,"code",PSCode)) d
			 .s PHIDUP=$O(^DHCEMPSO(0,"code",PSCode,""))
			 .q:PHIDUP=ID
			 .s isIN=1
			 q:isIN=1 1 //hxy 2020-05-12 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
			 ;s PHIDUP=..CheckExist(PSCode,HospDr) //hxy 2020-05-12 st //2023-01-18 注释
			 ;Q:(PHIDUP'=0)&(ID'=PHIDUP) 1 //ed
			 }

		 s obj.PSCode=PSCode
		 s obj.PSDesc=PSDesc
		 s obj.PSActiveFlag=PSActiveFlag
	 	 
	     s sc=obj.%Save() 
	     d obj.%Close() //hxy 2020-05-12 st
	     s ret=""
	     s:+ID=0 ret=##Class(web.DHCEMCommonUtil).SaveHOSP("DHC_EmPatSource",obj.%Id(),HospDr)
         q:ret<0 ret //ed  
		 ;i $$$ISERR(sc) q -2
		 q 0
}

ClassMethod SavePatSource(params)
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
/// CreatDate：    2016-05-11
/// Description:： 分页显示病人来源字典
/// Table：        DHC_EmPatSource
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCEMPatSource).ListPatSource(,,"","","")
ClassMethod ListPatSource(page = 1, rows = 10, PSCode, PSDesc, HospDr, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMPSO(phId)) q:phId=""  d
		.q:phId=0
		.s code=$p(^DHCEMPSO(phId),"^",1)
		.s desc=$p(^DHCEMPSO(phId),"^",2)
		.s PSActiveFlag=$p(^DHCEMPSO(phId),"^",3)
		.s PSHospDr=$p(^DHCEMPSO(phId),"^",4)
		.s HospDesc="" //2019-12-25
		.s:PSHospDr'="" HospDesc=$P(^CT("HOSP",PSHospDr),"^",2)
		.s tmp=phId_"^"_code_"^"_desc_"^"_PSActiveFlag_"^"_HospDesc_"^"_PSHospDr_"^"_HospDr //hxy 2020-05-12 HospDr
		.q:(PSCode'="")&(code'[PSCode)
		.q:(PSDesc'="")&(desc'[PSDesc)
		.q:(q'="")&(desc'[q)
		.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatSource",phId,HospDr)'="Y" //hxy 2020-05-12
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEmPatSource).%OpenId(phId)).Json()
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^PSCode^PSDesc^PSActiveFlag^PSHospDr^PSHospDrID^HospDr",tmp) //hxy 2020-05-12 HospDr
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-11
/// Description:： 查找一条病人来源字典,以json形式返回
/// Table：        DHC_EmPatSource
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCEMPatSource).FindPatSource(1)
ClassMethod FindPatSource(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCEmPatSource).%OpenId(Id)).Json()
	  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-11
/// Description:： 删除病人来源字典
/// Table：        DHC_EmPatSource
/// Input：	      Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod RemovePatSource(Id)
{
  
	q:+Id=0 -1
	s $Zt="Err" //hxy 2020-05-12 加事务和删除关联表 st
  	TStart
  	s obj=##class(User.DHCEmPatSource).%DeleteId(Id)
	s ret=##class(web.DHCEMCommonUtil).DeleteHospitals("DHC_EmPatSource",Id)
	q:ret<0 ret
	i ret<0 TRollback
	TCOMMIT
Err
	TRollback
	;s obj=##class(User.DHCEmPatSource).%DeleteId(Id) //ed
	q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-11
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMPatSource).listIsActive()
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
	f  s RowID=$o(^DHCEMPSO(0,"code",PHCode,RowID)) q:RowID=""  d
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatSource",RowID,HospDr)'="Y"
	.s ret=RowID
	q ret
}

}
