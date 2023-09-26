Class web.DHCPHGuiScope Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod SaveUpdGuiScope(params)
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

/// Creator：      yuliping
/// CreatDate：    2017-01-07
/// Description:   保存或修改 临床药学指导范围
/// Table：        DHC_PHGuiScope
/// Input：	       PHGSCode：代码
///                PHGSDesc：描述
///                PHGSModType：  模块         
///                PHGSSubModType：子模块
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
/// w ##class(web.DHCPHGuiScope).SaveOrUpdate("测试1^测试^EDU^N^1")
ClassMethod SaveOrUpdate(str)
{
  		 s PHGSCode=$p(str,"^",1)
		 s PHGSDesc=$p(str,"^",2)
		 s PHGSModType=$p(str,"^",3)
		 s PHGSSubModType=$p(str,"^",4)
		 s ID=$p(str,"^",5)
		 s IsNew=0,isIN=0
		 
		 i +ID=0 d
		 .s obj=##class(User.DHCPHGuiScope).%New()
		 .i $d(^DHCPHGS(0,"ModType",PHGSModType,PHGSSubModType)) d
		 ..s PHIDUP=""
		 ..f  s PHIDUP=$o(^DHCPHGS(0,"ModType",PHGSModType,PHGSSubModType,PHIDUP)) q:PHIDUP=""  d
		 ...s OldCode=$p(^DHCPHGS(PHIDUP),"^",1)
		 ...i OldCode=PHGSCode s IsNew= 1
		 q:IsNew=1 1
		 e  d
		 .s obj=##class(User.DHCPHGuiScope).%OpenId(ID) 
		 .i $d(^DHCPHGS(0,"ModType",PHGSModType,PHGSSubModType)) d
		 ..s PHIDUP=""
		 ..f  s PHIDUP=$O(^DHCPHGS(0,"ModType",PHGSModType,PHGSSubModType,PHIDUP)) q:PHIDUP=""  d
		 ...q:ID=PHIDUP
	     ...s OldCode=$p(^DHCPHGS(PHIDUP),"^",1)
		 ...i OldCode=PHGSCode s isIN=1
	     q:isIN=1 1
		
		
		 s obj.PHGSCode=PHGSCode
		 s obj.PHGSDesc=PHGSDesc
		 s obj.PHGSModType=PHGSModType
	 	 s obj.PHGSSubModType=PHGSSubModType
	 	
	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

/// Creator：      yuliping
/// CreatDate：    2017-01-18
/// Description:   分页显示 临床药学指导范围
/// Table：        DHC_PHGuiScope
/// Input：	       page：当前页数
///                rows：每页条数 
/// Return：     
/// w ##class(web.DHCPHGuiScope).ListGuiScope("1","10","","")
ClassMethod ListGuiScope(page = 1, rows = 10, PHGSCode, PHGSDesc, PHGSModType,  PHGSSubModType)
{
	
	
	 s start=(page-1)*rows+1
	 s end=page*rows
	 s count=0
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 w "{""rows"":["
	 s PHGSid=""
	 f  s PHGSid=$o(^DHCPHGS(PHGSid))  q:PHGSid=""  d
	 .q:PHGSid=0
	 .s msg=$g(^DHCPHGS(PHGSid))
	 .q:msg=""
	 .s code=$p(msg,"^",1)
	 .s desc=$p(msg,"^",2)
	 .s ModType=$p(msg,"^",3)
	 .s SubModType=$p(msg,"^",4)
	 .s tmp=PHGSid_"^"_code_"^"_desc_"^"_ModType_"^"_SubModType
	 .q:(PHGSCode'="")&(code'[(PHGSCode))
	 .q:(PHGSDesc'="")&(desc'[(PHGSDesc))
	 .q:(PHGSModType'="")&(ModType'[(PHGSModType))
	 .q:(PHGSSubModType'="")&(SubModType'[(PHGSSubModType))
	 .s count=count+1
	 .q:count<start
	 .q:count>end
	 .w $case(count,start:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^PHGSCode^PHGSDesc^PHGSModType^PHGSSubModType",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-01-18
/// Description:： 下拉列表显示 用药教育(EDU)/药学查房(WAR)/医学查房(CLI)
/// Return
/// d ##class(web.DHCPHGuiScope).listIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","EDU").Put("text","用药教育"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","WAR").Put("text","药学查房"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","CLI").Put("text","医学查房"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-01-18
/// Description:： 下拉列表显示 入院(N)/在院(I)/出院(O)
/// Return
/// d ##class(web.DHCPHGuiScope).listIsActiveSub()
ClassMethod ListIsActiveSub()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","入院"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","I").Put("text","在院"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","O").Put("text","出院"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-01-07
/// Description:   删除 临床药学指导范围
/// Table：        DHC_PHGuiScope
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveGuiScope(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCPHGuiScope).%DeleteId(Id)
	  q 0
}

}
