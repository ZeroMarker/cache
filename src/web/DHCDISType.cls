Class web.DHCDISType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      lvpeng
/// CreatDate：    2017-01-05
/// Description:   保存或者新增 陪送类型字典
/// Table：        DHC_DisType
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
			
		 i +ID=0 //新增
		 {
			 s obj=##class(User.DHCDisType).%New()
			 s obj.DTHospDr=##class(User.CTHospital).%OpenId(DTHospDr)
			 ;Q:$d(^DHCDISTY(0,"Code",DTCode)) 1
			 
		 }else{	
			 s obj=##class(User.DHCDisType).%OpenId(ID)	//修改
			 i +DTHospDr=0 d
			 .s obj.DTHospDr=##class(User.CTHospital).%OpenId(DTHospDrID)
			 e  d
			 .s obj.DTHospDr=##class(User.CTHospital).%OpenId(DTHospDr)
			 
			 /*s isIN=0
			 i $d(^DHCDISTY(0,"Code",DTCode)) d
			 .s PHIDUP=$O(^DHCDISTY(0,"Code",DTCode,""))
			 .;q:PHIDUP=ID
			 .;s isIN=1
			 ;q:isIN=1 1*/
			 }

		 s obj.DTCode=DTCode
		 s obj.DTDesc=DTDesc
		 s obj.DTActiveFlag=DTActiveFlag
	 	 
	 	 
	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

/// w ##class(web.DHCDISType).SaveDisType("1^1^Y^2^0^0")
ClassMethod SaveDisType(params)
{
	s ^tempsufan("111")=params
	//s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret'=0
  	.s str=$p(params,"$$",i)
  	.s ret=..CheckRepeat(str)   	/// 重复性判断
	.q:ret'=0
  	.s ret=..SaveOrUpdate(str)
	i ret'=0 TRollback
	i ret=0 TCOMMIT
	q ret
Err
	TRollback
	q ret
}

/// Creator：  sufan
/// CreatDate: 2017-07-06
/// Descript:  检查代码、描述是否重复
/// Table：    DHC_DisType
/// Others：   w ##class(web.DHCDISType).CheckRepeat("1^1^Y^2^3^5")
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	s ret=0
	s ID=$p(ItmTempStr,"^",6)   	 ///ID
	s APCode=$p(ItmTempStr,"^",1)  	 ///代码
	s APDesc=$p(ItmTempStr,"^",2) 	 ///描述
	s HospID=$p(ItmTempStr,"^",4)	 ///医院ID
	/// 新记录
	if ID="0"  d
	.i $d(^DHCDISTY(0,"Code",(APCode)))   d
	..s APID=""
	..for  s APID=$o(^DHCDISTY(0,"Code",APCode,APID)) q:(APID="")||(ret'=0)  d
	...s HospDr=$p(^DHCDISTY(APID),"^",4)
	...q:HospDr'=HospID
	...s ret=1
	.. //hxy 2019-07-22
	.
	/// 修改记录
	else  d
	.s DtHospID=$p(ItmTempStr,"^",5)	 ///医院ID //hxy 2019-07-22 st 修改时能重复
	.i +HospID=0 s HospID=DtHospID //ed
	.s Code=$p($g(^DHCDISTY(ID)),"^",1)    //代码
	.s Desc=$p($g(^DHCDISTY(ID)),"^",2)    //描述
	.i ($d(^DHCDISTY(0,"Code",APCode)))  d //(Code'=APCode)&($d(^DHCDISTY(0,"Code",APCode)))  d //hxy 2019-07-22 code一样也要判断
	..s APID=""
	..f  s APID=$o(^DHCDISTY(0,"Code",APCode,APID)) q:(APID="")||(ret'=0)  d
	...s HospDr=$p(^DHCDISTY(APID),"^",4)
	...s:(APID'=ID)&(HospDr=HospID) ret=1 //hxy 2019-07-23 st
	...;q:HospDr'=HospID
	...;s ret=1 //ed
	.. //hxy 2019-07-22
	.
	
	q ret
}

/// Creator：      lvpeng
/// CreatDate：    2017-01-05
/// Description:： 分页显示陪送类型字典
/// Table：        DHC_DisType
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCDISType).ListDisType(,,"","","")
ClassMethod ListDisType(page = 1, rows = 10, DTCode, DTDesc, HospDrID, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s DtId=""
		f  s DtId=$o(^DHCDISTY(DtId)) q:DtId=""  d
		.q:DtId=0
		.s code=$p(^DHCDISTY(DtId),"^",1)
		.s desc=$p(^DHCDISTY(DtId),"^",2)
		.s DTActiveFlag=$p(^DHCDISTY(DtId),"^",3)
		.s DTHospDr=$p(^DHCDISTY(DtId),"^",4)
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
/// Description:： 查找一条病人来源字典,以json形式返回
/// Table：        DHC_DisType
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCDISType).FindDisType(1)
ClassMethod FindDisType(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCDisType).%OpenId(Id)).Json()
	  q ""
}

/// Creator：      lvpeng
/// CreatDate：    2017-01-05
/// Description:： 删除陪送类型字典
/// Table：        DHC_DisType
/// Input：	       Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod RemoveDisType(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCDisType).%DeleteId(Id)
	  q 0
}

/// Creator：      lvpeng
/// CreatDate：    2017-01-05
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCDISType).listIsActive()
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
