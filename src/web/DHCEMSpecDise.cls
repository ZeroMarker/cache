Class web.DHCEMSpecDise Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      yangyongtao
/// CreatDate：    2017-10-25
/// Description:   保存或者新增 急诊特病字典
/// Table：        DHC_EMSpecDise
/// Input：	       SDICode：代码
///                SDIDesc：描述
///                SDIActiveFlag：是否可用             
///                SDIHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
  		 s SDICode=$p(str,"^",1)
		 s SDIDesc=$p(str,"^",2)
		 s SDIActiveFlag=$p(str,"^",3)
		 s SDIHospDr=$p(str,"^",4)
		 s SDIHospDrID=$p(str,"^",5)
		 s ID=$p(str,"^",6)
		 s HospDr=$p(str,"^",7) //hxy 2020-05-21

		 i +ID=0 
		 {
			 s obj=##class(User.DHCEmSpecDise).%New()
			 s obj.SDIHospDr=##class(User.CTHospital).%OpenId(SDIHospDr,0)
			 Q:$d(^DHCEMSPD(0,"Code",SDICode)) 1 //hxy 2020-05-21 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
		 	 ;Q:..CheckExist(SDICode,HospDr) 1 //hxy 2020-05-21 //2023-01-18 注释
			 
		 }else{
			 s obj=##class(User.DHCEmSpecDise).%OpenId(ID)
			 i +SDIHospDr=0 d
			 .s obj.SDIHospDr=##class(User.CTHospital).%OpenId(SDIHospDrID,0)
			 e  d
			 .s obj.SDIHospDr=##class(User.CTHospital).%OpenId(SDIHospDr,0)
			 
			 s isIN=0
			 i $d(^DHCEMSPD(0,"Code",SDICode)) d
			 .s PHIDUP=$O(^DHCEMSPD(0,"Code",SDICode,""))
			 .q:PHIDUP=ID
			 .s isIN=1
			 q:isIN=1 1 //hxy 2020-05-21 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
			 ;s PHIDUP=..CheckExist(SDICode,HospDr) //hxy 2020-05-21 st //2023-01-18 注释
			 ;Q:(PHIDUP'=0)&(ID'=PHIDUP) 1 //ed
		 }
		
		 s obj.SDICode=SDICode
		 s obj.SDIDesc=SDIDesc
		 s obj.SDIActiveFlag=SDIActiveFlag
	 	 
	 	
	     s sc=obj.%Save() 
	     d obj.%Close() //hxy 2020-05-21 st
	     s ret=""
	     s:+ID=0 ret=##Class(web.DHCEMCommonUtil).SaveHOSP("DHC_EmSpecDise",obj.%Id(),HospDr)
         q:ret<0 ret //ed  
		 ;i $$$ISERR(sc) q -2
		 q 0
}

ClassMethod SaveSpecDise(params)
{
    S ^tmp("yyt123")=params
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

/// Creator：      yangyongtao
/// CreatDate：    2017-10-25
/// Description:： 分页显示 急诊特病字典
/// Table：        DHC_EMSpecDise
/// Input：	       page：当前页数
///                rows：每页条数
/// Return：       
/// d ##class(web.DHCEMSpecDise).ListSpecDise(,,"","","")
ClassMethod ListSpecDise(page = 1, rows = 10, SDICode, SDIDesc, HospDr, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMSPD(phId)) q:phId=""  d
		.q:phId=0
		.s code=$p(^DHCEMSPD(phId),"^",1)
		.s desc=$p(^DHCEMSPD(phId),"^",2)
		.s SDIActiveFlag=$p(^DHCEMSPD(phId),"^",3)
		.s SDIHospDr=$p(^DHCEMSPD(phId),"^",4)
		.s HospDesc="" //hxy 2019-09-18
		.s:SDIHospDr'="" HospDesc=$P(^CT("HOSP",SDIHospDr),"^",2)
		.s tmp=phId_"^"_code_"^"_desc_"^"_SDIActiveFlag_"^"_HospDesc_"^"_SDIHospDr_"^"_HospDr //hxy 2020-05-21 HospDr
		.q:(SDICode'="")&(code'[SDICode)
		.q:(SDIDesc'="")&(desc'[SDIDesc)
		.q:(q'="")&(desc'[q)
		.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmSpecDise",phId,HospDr)'="Y" //hxy 2020-05-21
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^SDICode^SDIDesc^SDIActiveFlag^SDIHospDr^SDIHospDrID^HospDr",tmp) //hxy 2020-05-12 HospDr
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      yangyongtao
/// CreatDate：    2017-10-25
/// Description:： 删除急诊特病字典
/// Table：        DHC_EMSpecDise
/// Input：	       Id：rowid
/// Return：       操作成功 0，其他 失败
ClassMethod RemoveSpecDise(Id)
{
  
	q:+Id=0 -1
	s $Zt="Err" //hxy 2020-05-21 加事务和删除关联表 st
  	TStart
  	s obj=##class(User.DHCEmSpecDise).%DeleteId(Id)
	s ret=##class(web.DHCEMCommonUtil).DeleteHospitals("DHC_EmSpecDise",Id) 
	q:ret<0 ret
	i ret<0 TRollback
	TCOMMIT
Err
	TRollback
	;s obj=##class(User.DHCEmSpecDise).%DeleteId(Id) //ed
	q 0
}

/// Creator：      yangyongtao
/// CreatDate：    2017-10-25
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMSpecDise).ListIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是")) //hxy 2018-10-17 Y 是
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否")) //hxy 2018-10-17 N 否
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// d ##class(web.DHCEMPatHistory).CheckExist("03","2")
ClassMethod CheckExist(PHCode, HospDr)
{
	s ret=0
	s RowID=0
	f  s RowID=$o(^DHCEMSPD(0,"Code",PHCode,RowID)) q:RowID=""  d
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmSpecDise",RowID,HospDr)'="Y"
	.s ret=RowID
	q ret
}

}
