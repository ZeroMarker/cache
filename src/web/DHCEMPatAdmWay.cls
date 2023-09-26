Class web.DHCEMPatAdmWay Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-12
/// Description:   保存或者新增 来诊方式字典
/// Table：        DHC_EmPatAdmWay
/// Input：	       PAWCode：代码
///                PAWDesc：描述
///                PAWActiveFlag：是否可用             
///                PAWHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
        
		 
  		 s PAWCode=$p(str,"^",1)
		 s PAWDesc=$p(str,"^",2)
		 s PAWActiveFlag=$p(str,"^",3)
		 s PAWHospDr=$p(str,"^",4)
		 s PAWHospDrId=$p(str,"^",5)
		 s ID=$p(str,"^",6)
		 s HospDr=$p(str,"^",7) //hxy 2020-05-13

		 i +ID=0 
		 {
			 s obj=##class(User.DHCEmPatAdmWay).%New()
			 s obj.PAWHospDr=##class(User.CTHospital).%OpenId(PAWHospDr,0)
			 Q:$d(^DHCEMPADW(0,"code",PAWCode)) 1 //hxy 2020-05-13 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
		 	 ;Q:..CheckExist(PAWCode,HospDr) 1 //hxy 2020-05-13 //2023-01-18 注释
			 
		 }else{
			 s obj=##class(User.DHCEmPatAdmWay).%OpenId(ID)
			 i +PAWHospDr=0 d
			 .s obj.PAWHospDr=##class(User.CTHospital).%OpenId(PAWHospDrId,0)
			 e  d
			 .s obj.PAWHospDr=##class(User.CTHospital).%OpenId(PAWHospDr,0)
			 
			 s isIN=0
			 i $d(^DHCEMPADW(0,"code",PAWCode)) d
			 .s PHIDUP=$O(^DHCEMPADW(0,"code",PAWCode,""))
			 .q:PHIDUP=ID
			 .s isIN=1
			 q:isIN=1 1 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
			 ;s PHIDUP=..CheckExist(PAWCode,HospDr) //hxy 2020-05-13 st //2023-01-18 注释
			 ;Q:(PHIDUP'=0)&(ID'=PHIDUP) 1 //ed
		 }
		 
		 s obj.PAWCode=PAWCode
		 s obj.PAWDesc=PAWDesc
		 s obj.PAWActiveFlag=PAWActiveFlag
	 	 
	     s sc=obj.%Save()   
	     
	     d obj.%Close() //hxy 2020-05-13 st
	     s ret=""
	     s:+ID=0 ret=##Class(web.DHCEMCommonUtil).SaveHOSP("DHC_EmPatAdmWay",obj.%Id(),HospDr)
         q:ret<0 ret //ed
		 ;i $$$ISERR(sc) q -2
		 q 0
}

ClassMethod SavePatAdmWay(params)
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
/// CreatDate：    2016-05-12
/// Description:： 分页显示来诊方式字典
/// Table：        DHC_EmPatAdmWay
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCEMPatAdmWay).ListPatAdmWay(,,"","","")
ClassMethod ListPatAdmWay(page = 1, rows = 10, PAWCode, PAWDesc, HospDr, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMPADW(phId)) q:phId=""  d
		.q:phId=0
		.s code=$p(^DHCEMPADW(phId),"^",1)
		.s desc=$p(^DHCEMPADW(phId),"^",2)
		.s PAWActiveFlag=$p(^DHCEMPADW(phId),"^",3)
		.s PAWHospDr=$p(^DHCEMPADW(phId),"^",4)
		.s HospDesc="" //2019-12-25
		.s:PAWHospDr'="" HospDesc=$P(^CT("HOSP",PAWHospDr),"^",2)
		.s tmp=phId_"^"_code_"^"_desc_"^"_PAWActiveFlag_"^"_HospDesc_"^"_PAWHospDr_"^"_HospDr //hxy 2020-05-13 HospDr
		.q:(PAWCode'="")&(code'[PAWCode)
		.q:(PAWDesc'="")&(desc'[PAWDesc)
		.q:(q'="")&(desc'[q)
		.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatAdmWay",phId,HospDr)'="Y" //hxy 2020-05-13
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEmPatAdmWay).%OpenId(phId)).Json()
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^PAWCode^PAWDesc^PAWActiveFlag^PAWHospDr^PAWHospDrId^HospDr",tmp) //hxy 2020-05-13 HospDr
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-12
/// Description:： 查找一条来诊方式字典,以json形式返回
/// Table：        DHC_EmPatAdmWay
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCEMPatAdmWay).FindPatAdmWay(1)
ClassMethod FindPatAdmWay(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCEmPatAdmWay).%OpenId(Id,0)).Json()
	  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-12
/// Description:： 删除来诊方式字典
/// Table：        DHC_EmPatAdmWay
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemovePatAdmWay(Id)
{
  
	q:+Id=0 -1
	s $Zt="Err" //hxy 2020-05-13 加事务和删除关联表 st
  	TStart
  	s obj=##class(User.DHCEmPatHistory).%DeleteId(Id)
	s ret=##class(web.DHCEMCommonUtil).DeleteHospitals("DHC_EmPatAdmWay",Id) 
	q:ret<0 ret
	i ret<0 TRollback
	TCOMMIT
Err
	TRollback
	;s obj=##class(User.DHCEmPatAdmWay).%DeleteId(Id) //ed
	q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-12
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMPatAdmWay).listIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是")) //hxy 2018-09-14 因ui规范：Y->是
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// d ##class(web.DHCEMPatHistory).CheckExist("03","2")
ClassMethod CheckExist(PHCode, HospDr)
{
	s ret=0
	s RowID=0
	f  s RowID=$o(^DHCEMPADW(0,"code",PHCode,RowID)) q:RowID=""  d
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatAdmWay",RowID,HospDr)'="Y"
	.s ret=RowID
	q ret
}

}
