Class web.DHCEmPatType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description: 保存或者新增 特殊人群字典
/// Creator:     congyue
/// CreateDate:  2016-09-02
/// Table:       DHC_EmPatType
/// Input:  	 PHCode:代码 , PHDesc:描述, ID:rowid 
/// Output:   	 保存成功 0, 其他 失败
/// Others:		 w ##class(web.DHCEmPatType).SaveOrUpdate("人群^人群")
ClassMethod SaveOrUpdate(str)
{
	s PTCode=$p(str,"^",1)
	s PTDesc=$p(str,"^",2)
	s PTActiveFlag=$p(str,"^",3) //hxy 2019-06-20
	s PTHospDr=$p(str,"^",4) //hxy 2019-06-20
	s PTHospDrID=$p(str,"^",5) //hxy 2019-06-20
	s ID=$p(str,"^",6)
	s HospDr=$p(str,"^",7) //hxy 2020-05-20

	i +ID=0 
	{ 
		s obj=##class(User.DHCEmPatType).%New()
		s obj.PTHospDr=##class(User.CTHospital).%OpenId(PTHospDr) //hxy 2019-06-20 add
		;Q:$d(^DHCEMPT(0,"Code",$$ALPHAUP^SSUTIL4(PTCode))) 1 //hxy 2020-05-20 注释
	    Q:..CheckExist(PTCode,HospDr) 1 //hxy 2020-05-20

	}else{
		s obj=##class(User.DHCEmPatType).%OpenId(ID)
		
		i +PTHospDr=0 d //2019-06-20 st
		.s obj.PTHospDr=##class(User.CTHospital).%OpenId(PTHospDrID)
		e  d
		.s obj.PTHospDr=##class(User.CTHospital).%OpenId(PTHospDr) //ed
			 
		/*s isIN=0
		i $d(^DHCEMPT(0,"Code",$$ALPHAUP^SSUTIL4(PTCode))) d
		.s PTIDUP=$O(^DHCEMPT(0,"Code",$$ALPHAUP^SSUTIL4(PTCode),""))
		.q:PTIDUP=ID
		.s isIN=1
		q:isIN=1 1*/ //hxy 2020-05-20 注释
		s PHIDUP=..CheckExist(PTCode,HospDr) //hxy 2020-05-20 st
		Q:(PHIDUP'=0)&(ID'=PHIDUP) 1 //ed
	}
	;s obj=##class(User.DHCEmPatType).%OpenId(ID)
	s obj.PTCode=PTCode
	s obj.PTDesc=PTDesc
	s obj.PTActiveFlag=PTActiveFlag //2019-06-20

	s sc=obj.%Save()   
	d obj.%Close() //hxy 2020-05-20 st
	s ret=""
	s:+ID=0 ret=##Class(web.DHCEMCommonUtil).SaveHOSP("DHC_EmPatType",obj.%Id(),HospDr)
	q:ret<0 ret //ed
	;i $$$ISERR(sc) q -2
	q 0
}

/// Description: 保存特殊人群字典
/// Creator:     congyue
/// CreateDate:  2016-09-02
/// Table:       DHC_EmPatType
/// Input:  	 params:PHCode:代码^PHDesc:描述^ID:rowid $$ PHCode:代码^PHDesc:描述^ID:rowid
/// Output:   	 保存成功 0, 其他 失败
/// Others:		 w ##class(web.DHCEmPatType)SaveOrUpdate("")
ClassMethod SavePatType(params)
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

/// Description: 分页显示特殊人群字典
/// Creator:     congyue
/// CreateDate:  2016-09-02
/// Table:       DHC_EmPatType
/// Input:  	 page:当前页数 rows:每页条数
/// Output:   	 
/// Others:		 w ##class(web.DHCEmPatType).ListPatHis(,,"","","")
ClassMethod ListPatType(page = 1, rows = 10, HospDr)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s ptId=""
		f  s ptId=$o(^DHCEMPT(ptId)) q:ptId=""  d
		.q:ptId=0
		.s code=$p(^DHCEMPT(ptId),"^",1)
		.s desc=$p(^DHCEMPT(ptId),"^",2)
		.s PTActiveFlag=$p(^DHCEMPT(ptId),"^",3)
		.s PTHospDr=$p(^DHCEMPT(ptId),"^",4)
		.s HospDesc=""
		.i PTHospDr'="" s HospDesc=$P(^CT("HOSP",PTHospDr),"^",2)
		.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatType",ptId,HospDr)'="Y" //hxy 2020-05-20
		.s tmp=ptId_"^"_code_"^"_desc_"^"_PTActiveFlag_"^"_HospDesc_"^"_PTHospDr_"^"_HospDr //hxy 2020-05-20 HospDr
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEmPatHistory).%OpenId(phId)).Json()
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^PTCode^PTDesc^PTActiveFlag^PTHospDr^PTHospDrID^HospDr",tmp) //hxy 2020-05-20 HospDr
		w "],""total"":"_count_"}"
		q ""
}

/// Description: 查找一条特殊人群字典,以json形式返回
/// Creator:     congyue
/// CreateDate:  2016-09-02
/// Table:       DHC_EmPatType
/// Input:  	 Id:rowid
/// Output:   	 
/// Others:		 w ##class(web.DHCEmPatType).FindPatType(1)
ClassMethod FindPatType(Id)
{
  
	  q:+Id=0 ""
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCEmPatType).%OpenId(Id)).Json()
	  q ""
}

/// Description: 删除特殊人群字典
/// Creator:     congyue
/// CreateDate:  2016-09-02
/// Table:       DHC_EmPatType
/// Input:  	 Id:rowid
/// Output:   	 操作成功 0, 其他 失败
/// Others:		 w ##class(web.DHCEmPatType).RemovePatType(1)
ClassMethod RemovePatType(Id)
{
  
	q:+Id=0 -1
	s $Zt="Erro" //hxy 2020-05-20 加事务和删除关联表 st
  	TStart
  	s obj=##class(User.DHCEmPatType).%DeleteId(Id)
	s ret=##class(web.DHCEMCommonUtil).DeleteHospitals("DHC_EmPatType",Id) 
	q:ret<0 ret
	i ret<0 TRollback
	TCOMMIT
Erro
	TRollback
	s obj=##class(User.DHCEmPatType).%DeleteId(Id) //ed
	q 0
}

/// d ##class(web.DHCEMPatHistory).CheckExist("03","2")
ClassMethod CheckExist(PHCode, HospDr)
{
	s ret=0
	s RowID=0
	f  s RowID=$o(^DHCEMPT(0,"Code",PHCode,RowID)) q:RowID=""  d
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatType",RowID,HospDr)'="Y"
	.s ret=RowID
	q ret
}

}
