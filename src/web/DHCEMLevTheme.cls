Class web.DHCEMLevTheme Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-31
/// Description:   保存或者新增 分级指标主题库表
/// Table：        DHC_EmLevTheme
/// Input：	       LTHCode：代码
///                LTHDesc：描述
///                LTHActiveFlag：是否可用
///                LTHRemark:备注
///                LTHHospDrr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
/// w ##class(web.DHCEMLevTheme).SaveOrUpdate("EMLEVEL^测试主题^N^默认主题^东华标准版数字化医院[总院]^2^52")
ClassMethod SaveOrUpdate(str)
{
  		 s LTHCode=$p(str,"^",1)
		 s LTHDesc=$p(str,"^",2)
		 s LTHActiveFlag=$p(str,"^",3)
		 s LTHRemark=$p(str,"^",4)
		 s LTHHospDr=$p(str,"^",5)
		 s LTHHospDrID=$p(str,"^",6)
		 s ID=$p(str,"^",7)
		 s LTHProType=$p(str,"^",8)
		 s:+LTHHospDr=0 LTHHospDr=LTHHospDrID
		 s HospDr=$p(str,"^",9) //hxy 2020-12-25
		 
		 /*s LTHHospID="" //hxy 2019-07-23 st
		 s LTHId = $o(^DHCEMLTH(0,"Code",LTHCode,""),1)
		 s:LTHId'="" LTHHospID = $p(^DHCEMLTH(LTHId),"^",5)
		 b ;err
		 Q:(LTHId'="")&&(LTHId'=ID)&&(LTHHospID=LTHHospDr) 1*/
		 
#;		 s ret=0  //2023-01-18 注释
#;		 i $d(^DHCEMLTH(0,"Code",LTHCode))   d
#;		 .s CurID=""
#;		 .f  s CurID=$o(^DHCEMLTH(0,"Code",LTHCode,CurID)) q:(CurID="")||(ret'=0)  d
#;		 ..;s HospDr=$p($g(^DHCEMLTH(CurID)),"^",5) //hxy 2020-12-25 st
#;		 ..;s:(CurID'=ID)&(HospDr=LTHHospDr) ret=1
#;		 ..q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmLevTheme",CurID,HospDr)'="Y"
#;		 ..s:CurID'=ID ret=1 //ed
#;		 .
#;		 q:ret=1 1 //ed
		 
		 i +ID=0 
		 {
			 s obj=##class(User.DHCEmLevTheme).%New()
			 Q:$d(^DHCEMLTH(0,"Code",LTHCode)) 1 //hxy 2023-01-19 私有数据医院组间代码不能重复
			 
		 }else{
			 s obj=##class(User.DHCEmLevTheme).%OpenId(ID)
			 s isIN=0 //hxy 2023-01-19 私有数据医院组间代码不能重复
			 i $d(^DHCEMLTH(0,"Code",LTHCode)) d
			 .s PHIDUP=$O(^DHCEMLTH(0,"Code",LTHCode,""))
			 .q:PHIDUP=ID
			 .s isIN=1
			 q:isIN=1 1 
		 }
		 s obj.LTHHospDr=##class(User.CTHospital).%OpenId(LTHHospDr,0)
	
		 s obj.LTHCode=LTHCode
		 s obj.LTHDesc=LTHDesc
		 s obj.LTHActiveFlag=LTHActiveFlag
		 s obj.LTHRemark=LTHRemark
	 	 s obj.LTHProType=LTHProType
	 	 
	     s sc=obj.%Save() 
	     s ret="" //hxy 2020-12-25 st
	     s:+ID=0 ret=##Class(web.DHCEMCommonUtil).SaveHOSP("DHC_EmLevTheme",obj.%Id(),HospDr)
         q:ret<0 ret 
         d obj.%Close() //ed
   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

ClassMethod SaveLevTheme(params)
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
	q:ret="-1^没有开启医院级授权" "-11" //hxy 2020-12-25
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-31
/// Description:： 分页显示分级指标主题库表
/// Table：        DHC_EmLevTheme
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCEMLevTheme).ListLevTheme(,,"","","")
ClassMethod ListLevTheme(page = 1, rows = 10, LTHCode, LTHDesc, hospDrID, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMLTH(phId)) q:phId=""  d
		.q:phId=0
		.s code=$p(^DHCEMLTH(phId),"^",1)
		.s desc=$p(^DHCEMLTH(phId),"^",2)
		.s LTHActiveFlag=$p(^DHCEMLTH(phId),"^",3)
		.s LTHRemark=$p(^DHCEMLTH(phId),"^",4)
		.s LTHHospDr=$p(^DHCEMLTH(phId),"^",5)
		.;q:(hospDrID'="")&(hospDrID'=LTHHospDr) //hxy 2019-07-20 //hxy 2020-12-25 注释
		.s LTHHospDesc=$P(^CT("HOSP",LTHHospDr),"^",2)
		.s ProType=$p(^DHCEMLTH(phId),"^",6)
	    .s tmp=phId_"^"_LTHActiveFlag_"^"_code_"^"_desc_"^"_LTHRemark_"^"_LTHHospDesc_"^"_LTHHospDr_"^"_ProType_"^"_hospDrID //hxy 2020-12-25 hospDrID
		.q:(LTHCode'="")&(LTHCode'=code)
		.q:(LTHDesc'="")&(LTHDesc'=desc)
		.q:(q'="")&(desc'[q)
		.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmLevTheme",phId,hospDrID)'="Y" //hxy 2020-12-25
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
	    .;w jsonObj.FromObject(##class(User.DHCEmUpdLevReson).%OpenId(phId)).Json()
	    .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^LTHActiveFlag^LTHCode^LTHDesc^LTHRemark^LTHHospDr^LTHHospDrID^ProType^HospDr",tmp) //hxy 2020-12-25 HospDr
	    .
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-31
/// Description:： 删除分级指标主题库表
/// Table：        DHC_EmLevTheme
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveLevTheme(Id)
{
  
	  q:+Id=0 -1
	  s $Zt="Err" //hxy 2020-12-25 加事务和删除关联表 st
  	  TStart
  	  s obj=##class(User.DHCEmLevTheme).%DeleteId(Id)
	  s ret=##class(web.DHCEMCommonUtil).DeleteHospitals("DHC_EmLevTheme",Id) 
	  q:ret<0 ret
	  i ret<0 TRollback
	  TCOMMIT
Err
	  TRollback
	  ;s obj=##class(User.DHCEmLevTheme).%DeleteId(Id) //ed
	  q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-31
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMLevTheme).listIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是")) //hxy 2018-10-17 Y 是
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否")) //hxy 2018-10-17 N 否
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Creator：      bianshuai
/// CreatDate：    2020-07-30
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMLevTheme).ListProType()
ClassMethod ListProType()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","PCL").Put("text","分级指标"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","EMS").Put("text","急诊统计")) 
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","PUE").Put("text","高危预警")) 
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

}
