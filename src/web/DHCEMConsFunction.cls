/// Creator：      sunhuiyong
/// CreatDate：    2019-12-09
/// Description:   会诊函数表达式维护
/// Table：    	   DHC_EmConsFunction
Class web.DHCEMConsFunction Extends %RegisteredObject
{

/// Function：查询/加载列表信息
/// Debugger： d ##class(web.DHCEmConsFunction).ListConEpData(,,"","","")
ClassMethod ListConEpData(page = 1, rows = 10, ECCode, ECName, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s ECId=""
		f  s ECId=$o(^DHCEMCONF(ECId)) q:ECId=""  d
		.q:ECId=0
		.s code=$p(^DHCEMCONF(ECId),"^",1)
		.s desc=$p(^DHCEMCONF(ECId),"^",2)
		.s ECExpress=$p(^DHCEMCONF(ECId),"^",3)
		.s ECActiveFlag=$p(^DHCEMCONF(ECId),"^",4)
		.s ECHospDr="" ;$p(^DHCEMCONF(ECId),"^",5)
		.s HospDesc="" ;$P(^CT("HOSP",ECHospDr),"^",2)
		.s tmp=ECId_"^"_code_"^"_desc_"^"_ECExpress_"^"_ECActiveFlag_"^"_HospDesc_"^"_ECHospDr
		.q:(ECCode'="")&(code'[ECCode)
		.q:(ECName'="")&(desc'[ECName)
		.q:(q'="")&(desc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEmPatAware).%OpenId(phId)).Json()
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^ECCode^ECName^ECExpress^ECActiveFlag^ECHospDr^ECHospDrID",tmp)
		w "],""total"":"_count_"}"
		q ""
}

ClassMethod SaveConData(params)
{
   s ^BIANSHUAI(123)=params
	//s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..SaveOrUpdate(str)
	i ret<0 TRollback
	Q:ret="-3" -3 //hxy 2020-09-24
	Q:ret<0 -2
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      sunhuiyong
/// CreatDate：    2019-12-09
/// Description:   保存或者新增 会诊表达式数据
/// Return：       保存成功 0，其他 失败
/// w ##class(web.DHCEMConsFunction).SaveOrUpdate("住院病人^住院病人^isInHosPat^Y^3^2^11")
ClassMethod SaveOrUpdate(str)
{
  		 s ECCode=$p(str,"^",1)
		 s ECName=$p(str,"^",2)
		 s ECExpress=$p(str,"^",3)
		 s ECActiveFlag=$p(str,"^",4)
		 s ECHospDr="" ;$p(str,"^",5)
		 s ECHospDrID="" ;$p(str,"^",6)
		 s ID=$p(str,"^",7)
		 q:$l(str,"^")>7 "-3" //hxy 2020-09-24
		  
		 i +ID=0 
		 {
			s obj=##class(User.DHCEmConsFunction).%New() 
			s obj.ECHospDr=##class(User.CTHospital).%OpenId(ECHospDr,0)
			s isIN=0,hasID=""
			f  s hasID= $o(^DHCEMCONF(0,"Code",ECCode,hasID)) q:(hasID="")||(isIN=1)  d
			.;s hasHospID=$p(^DHCEMCONF(hasID),"^",5)
			.;q:ECHospDr'=hasHospID
			.s isIN=1
			Q:isIN 1
			
		 }else{
			 s obj=##class(User.DHCEmConsFunction).%OpenId(ID)
			 i +ECHospDr=0 d
			 .s obj.ECHospDr=##class(User.CTHospital).%OpenId(ECHospDrID,0)
			 e  d
			 .s obj.ECHospDr=##class(User.CTHospital).%OpenId(ECHospDr,0)
			 s isIN=0,hasID=""
			 f  s hasID= $o(^DHCEMCONF(0,"Code",ECCode,hasID)) q:(hasID="")||(isIN=1)  d
			 .;s hasHospID=$p(^DHCEMCONF(hasID),"^",5)
			 .;q:ECHospDr'=hasHospID
			 .q:hasID=ID
			 .s isIN=1
			 q:isIN=1 1
			 
		 }
		 b ;shy3
		 s obj.ECCode=ECCode
		 s obj.ECName=ECName
		 s obj.ECExpress=ECExpress
		 s obj.ECActiveFlag=ECActiveFlag
	     s sc=obj.%Save()
	     b ///www
	     b ; shy4 
	     i $$$ISERR(sc) q -2 
	     b ///mmm
		 q 0
}

/// Creator：      shy
/// CreatDate：    2019-12-09
/// Description：  下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEmConsFunction).listIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是")) //2018-10-16 Y
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否")) //2018-10-16 N
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// shy
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemovePatAware(Id)
{
  
	  q:+Id=0 -1
	  q:$d(^DHCEMCONPC(0,"FunWorkFlow",Id)) -2 //hxy 2020-08-10
	  s obj=##class(User.DHCEmConsFunction).%DeleteId(Id)
	  q 0
}

}
