Class web.DHCDISFailReason Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      yuliping
/// CreatDate：    2017-01-07
/// Description:   分页显示 陪送未完成原因字典维护
/// Table：        DHC_EmUpdLevReson
/// Input：	       page：当前页数
///                rows：每页条数 
/// Return：     
/// w ##class(web.DHCDISFailReason).ListFailReason("1","10","","")
ClassMethod ListFailReason(page = 1, rows = 10, FRCode, FRDesc)
{
	
	
	 s start=(page-1)*rows+1
	 s end=page*rows
	 s count=0
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 w "{""rows"":["
	 s frid=""
	 f  s frid=$o(^DHCDISFR(frid))  q:frid=""  d
	 .q:frid=0
	 .s msg=$g(^DHCDISFR(frid))
	 .q:msg=""
	 .s code=$p(msg,"^",1)
	 .s desc=$p(msg,"^",2)
	 .s ActiveFlag=$p(msg,"^",3)
	 .s HosptId=$p(msg,"^",4)
	 .s HosptDesc=""
	 .i HosptId '="" s HosptDesc=$P(^CT("HOSP",HosptId),"^",2)
	 .s tmp=frid_"^"_code_"^"_desc_"^"_ActiveFlag_"^"_HosptDesc_"^"_HosptId
	 .q:(FRCode'="")&(code'[(FRCode))
	 .q:(FRDesc'="")&(desc'[(FRDesc))
	 .s count=count+1
	 .q:count<start
	 .q:count>end
	 .w $case(count,start:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^FRCode^FRDesc^FRActiveFlag^FRHospDr^FRHospDrID",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-01-07
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCDISFailReason).listIsActive()
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
/// CreatDate：    2017-01-07
/// Description:   保存或者新增 陪送未完成原因字典
/// Table：        DHCDisFailReason
/// Input：	       FRCode：代码
///                FRDesc：描述
///                FRActiveFlag：是否可用             
///                FRHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
  		 s FRCode=$p(str,"^",1)
		 s FRDesc=$p(str,"^",2)
		 s FRActiveFlag=$p(str,"^",3)
		 s FRHospDr=$p(str,"^",4)
		 s FRHospDrID=$p(str,"^",5)
		 s ID=$p(str,"^",6)

		 i +ID=0 
		 {
			 s obj=##class(User.DHCDisFailReason).%New()
			 s obj.FRHospDr=##class(User.CTHospital).%OpenId(FRHospDr)
			 Q:$d(^DHCDISFR(0,"Code",FRCode)) 1
			 
		 }else{
			 s obj=##class(User.DHCDisFailReason).%OpenId(ID)
			 i +FRHospDr=0 d
			 .s obj.FRHospDr=##class(User.CTHospital).%OpenId(FRHospDrID)
			 e  d
			 .s obj.FRHospDr=##class(User.CTHospital).%OpenId(FRHospDr)
			 
			 s isIN=0
			 i $d(^DHCDISFR(0,"Code",FRCode)) d
			 .s PHIDUP=$O(^DHCDISFR(0,"Code",FRCode,""))
			 .q:PHIDUP=ID
			 .s isIN=1
			 q:isIN=1 1
		 }
		
		 s obj.FRCode=FRCode
		 s obj.FRDesc=FRDesc
		 s obj.FRActiveFlag=FRActiveFlag
	 	 
	 	
	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

/// Creator：      yuliping
/// CreatDate：    2017-01-07
/// Description:： 删除更改陪送未完成原因字典
/// Table：        DHC_EmUpdLevReson
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveUpdLevReson(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCDisFailReason).%DeleteId(Id)
	  q 0
}

}
