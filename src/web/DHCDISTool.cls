Class web.DHCDISTool Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      lvpeng
/// CreatDate：    2017-01-05
/// Description:   保存或者新增 陪送方式/工具字典
/// Table：        DHC_DisTool
/// Input：	       DTCode：代码
///                DTDesc：描述
///                DTActiveFlag：是否可用             
///                DTHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
  		 s DTCode=$p(str,"^",1)
		 s DTDesc=$p(str,"^",2)
		 Q:(DTCode[" ")||(DTDesc[" ") -3
		 s DTActiveFlag=$p(str,"^",3)
		 s DTHospDr=$p(str,"^",4)
		 s DTHospDrID=$p(str,"^",5)
		 s ID=$p(str,"^",6)
			
		 s:+DTHospDr=0 DTHospDr=DTHospDrID //hxy 2019-07-23 st
		 s ret=0 
		 i $d(^DHCDISTO(0,"Code",DTCode))   d
		 .s CurID=""
		 .f  s CurID=$o(^DHCDISTO(0,"Code",DTCode,CurID)) q:(CurID="")||(ret'=0)  d
		 ..s HospDr=$p($g(^DHCDISTO(CurID)),"^",4)
		 ..s:(CurID'=ID)&(HospDr=DTHospDr) ret=1
		 .
		 q:ret=1 1 //ed
		 
		 i +ID=0 //新增
		 {
			 s obj=##class(User.DHCDisTool).%New()
			 s obj.DTHospDr=##class(User.CTHospital).%OpenId(DTHospDr)
			 ;Q:$d(^DHCDISTO(0,"Code",DTCode)) 1 //hxy 2019-07-22 注释
	
		 }else{	
			 s obj=##class(User.DHCDisTool).%OpenId(ID)	//修改
			 i +DTHospDr=0 d
			 .s obj.DTHospDr=##class(User.CTHospital).%OpenId(DTHospDrID)
			 e  d
			 .s obj.DTHospDr=##class(User.CTHospital).%OpenId(DTHospDr)
			 
			 /*s isIN=0  //hxy 2019-07-22 注释
			 i $d(^DHCDISTO(0,"Code",DTCode)) d
			 .s PHIDUP=$O(^DHCDISTO(0,"Code",DTCode,""))
			 .q:PHIDUP=ID
			 .s isIN=1
			 q:isIN=1 1*/
			 }

		 s obj.DTCode=DTCode
		 s obj.DTDesc=DTDesc
		 s obj.DTActiveFlag=DTActiveFlag
	 	 
	 	 
	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

ClassMethod SaveDisTool(params)
{
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret'=0
  	.s str=$p(params,"$$",i)
  	.s ret=..SaveOrUpdate(str)
	i ret'=0 TRollback
	i ret=0 TCOMMIT
	q ret
Err
	TRollback
	q ret
}

/// Creator：      lvpeng
/// CreatDate：    2017-01-05
/// Description:： 分页显示病人来源字典
/// Table：        DHC_DisTool
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCDISTool).ListDisTool(,,"","","")
ClassMethod ListDisTool(page = 1, rows = 10, DTCode, DTDesc, HospDrID, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s DtId=""
		f  s DtId=$o(^DHCDISTO(DtId)) q:DtId=""  d
		.q:DtId=0
		.s code=$p(^DHCDISTO(DtId),"^",1)
		.s desc=$p(^DHCDISTO(DtId),"^",2)
		.s DTActiveFlag=$p(^DHCDISTO(DtId),"^",3)
		.s DTHospDr=$p(^DHCDISTO(DtId),"^",4)
		.s HospDesc=$P(^CT("HOSP",DTHospDr),"^",2)
		.s tmp=DtId_"^"_code_"^"_desc_"^"_DTActiveFlag_"^"_HospDesc_"^"_DTHospDr
		.q:(DTCode'="")&(code'[DTCode)
		.q:(DTDesc'="")&(desc'[DTDesc)
		.q:(HospDrID'="")&(HospDrID'=DTHospDr) //hxy 2019-07-22
		.q:(q'="")&(desc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEmPatSource).%OpenId(DtId)).Json()
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^DTCode^DTDesc^DTActiveFlag^DTHospDr^DTHospDrID",tmp)
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      lvpeng
/// CreatDate：    2017-01-05
/// Description:： 查找一条陪送方式字典,以json形式返回
/// Table：        DHC_DisTool
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCDISTool).FindDisTool(1)
ClassMethod FindDisTool(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCDisTool).%OpenId(Id)).Json()
	  q ""
}

/// Creator：      lvpeng
/// CreatDate：    2017-01-05
/// Description:： 删除陪送方式字典
/// Table：        DHC_DisTool
/// Input：	       Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod RemoveDisTool(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCDisTool).%DeleteId(Id)
	  q 0
}

/// Creator：      lvpeng
/// CreatDate：    2017-01-05
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCDISTool).listIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

}
