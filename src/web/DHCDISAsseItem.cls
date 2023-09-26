Class web.DHCDISAsseItem Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      yuliping
/// CreatDate：    2017-01-09
/// Description:   分页显示 陪送申请评价项目字典维护
/// Table：        DHC_DisAsseItem
/// Input：	       page：当前页数
///                rows：每页条数 
/// Return：     
/// w ##class(web.DHCDISAsseItem).ListFailReason("1","10","","")
ClassMethod ListFailReason(page = 1, rows = 10, AICode, AIDesc)
{
	
	
	 s start=(page-1)*rows+1
	 s end=page*rows
	 s count=0
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 w "{""rows"":["
	 s aiid=""
	 f  s aiid=$o(^DHCDISAI(aiid))  q:aiid=""  d
	 .q:aiid=0
	 .s msg=$g(^DHCDISAI(aiid))
	 .q:msg=""
	 .s code=$p(msg,"^",1)
	 .s desc=$p(msg,"^",2)
	 .s ActiveFlag=$p(msg,"^",3)
	 .s HosptId=$p(msg,"^",4)
	 .s score=$p(msg,"^",5)
	 .s HosptDesc=""
	 .i HosptId '="" s HosptDesc=$P(^CT("HOSP",HosptId),"^",2)
	 .s tmp=aiid_"^"_code_"^"_desc_"^"_ActiveFlag_"^"_HosptDesc_"^"_HosptId_"^"_score
	 .q:(AICode'="")&(code'[AICode)
	 .q:(AIDesc'="")&(desc'[AIDesc)
	 .s count=count+1
	 .q:count<start
	 .q:count>end
	 .w $case(count,start:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^AICode^AIDesc^AIActiveFlag^AIHospDr^AIHospDrID^AIScore",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-01-07
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCDISAsseItem).listIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","Y"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","N"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

ClassMethod SaveUpdLevReson(params)
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
/// CreatDate：    2017-01-09
/// Description:   保存或者新增 陪送申请评价项目字典
/// Table：        DHC_DisAsseItem
/// Input：	       AICode：代码
///                AIDesc：描述
///                AIActiveFlag：是否可用             
///                AIHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
/// d ##class(web.DHCDISAsseItem).SaveOrUpdate("2^2^Y^2^20^2^0")
ClassMethod SaveOrUpdate(str)
{
  		 s AICode=$p(str,"^",1)
		 s AIDesc=$p(str,"^",2)
		 s AIActiveFlag=$p(str,"^",3)
		 s AIHospDr=$p(str,"^",4)
		 s Score=$p(str,"^",5)
		 s AIHospDrID=$p(str,"^",6)
		 s ID=$p(str,"^",7)
		 i +ID=0 
		 {
			 s obj=##class(User.DHCDisAsseItem).%New()
			 s obj.AIHospDr=##class(User.CTHospital).%OpenId(AIHospDr)
			 Q:$d(^DHCDISAI(0,"Code",Score,AICode)) 1
			 
		 }else{
			 s obj=##class(User.DHCDisAsseItem).%OpenId(ID)
			 i +AIHospDr=0 d
			 .s obj.AIHospDr=##class(User.CTHospital).%OpenId(AIHospDrID)
			 e  d
			 .s obj.AIHospDr=##class(User.CTHospital).%OpenId(AIHospDr)
			 
			 s isIN=0
			 i $d(^DHCDISAI(ID)) d
			 .s CODE=$P(^DHCDISAI(ID),"^",1)
			 .q:CODE=AICode
			 .s isIN=1
			 q:isIN=1 1
		 }
		
		 s obj.AICode=AICode
		 s obj.AIDesc=AIDesc
		 s obj.AIActiveFlag=AIActiveFlag
	 	 s obj.AIScore=Score
	 	
	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

/// Creator：      yuliping
/// CreatDate：    2017-01-09
/// Description:： 删除陪送申请评价项目字典
/// Table：        DHC_DisAsseItem
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveUpdLevReson(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCDisAsseItem).%DeleteId(Id)
	  q 0
}

}
