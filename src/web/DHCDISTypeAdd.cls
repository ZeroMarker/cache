Class web.DHCDISTypeAdd Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：  zhouxin
/// CreatDate：    2017-01-05
/// Description:   保存或者新增 配送类型
/// Table：        DHC_DisType
/// Input：	       DTCode：代码
///                DTDesc：描述
///                DTActiveFlag：是否可用             
///                DTHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
/// w ##class(web.DHCDISTypeAdd).SaveOrUpdate("陪送^陪送^Y^2^0^0")
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
			 s obj=##class(User.DHCDisTypeAdd).%New()
			 s obj.TAHospDr=##class(User.CTHospital).%OpenId(DTHospDr)
			 ;Q:$d(^DHCDISTA(0,"Code",DTCode)) 1
			 
		 }else{	
			 s obj=##class(User.DHCDisTypeAdd).%OpenId(ID)	//修改
			 i +DTHospDr=0 d
			 .s obj.TAHospDr=##class(User.CTHospital).%OpenId(DTHospDrID)
			 e  d
			 .s obj.TAHospDr=##class(User.CTHospital).%OpenId(DTHospDr)
			 
			 /*s isIN=0
			 i $d(^DHCDISTA(0,"Code",DTCode)) d
			 .s PHIDUP=$O(^DHCDISTA(0,"Code",DTCode,""))
			 .q:PHIDUP=ID
			 .s isIN=1
			 q:isIN=1 1*/
			 }

		 s obj.DACode=DTCode
		 s obj.TADesc=DTDesc
		 s obj.TAActiveFlag=DTActiveFlag
	 	 
	 	 
	     s sc=obj.%Save()   
		 i $$$ISERR(sc) q $SYSTEM.Status.DisplayError(sc)
		 q 0
}

/// w ##class(web.DHCDISTypeAdd).SaveDisType("陪送^陪送^Y^2^0^0")
ClassMethod SaveDisType(params)
{
	
	s $Zt="Err"
	s ^sufan(11)=params
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret'=0
  	.s str=$p(params,"$$",i)
  	.b   //str
  	.s ret=..CheckRepeat(str)
  	.b   //ret
  	.q:ret'=0
  	.b    ///111
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
/// Table：    
/// Others：   w ##class(web.DHCDISTypeAdd).CheckRepeat("陪送^陪送^Y^2^0^0")
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	s ret=0
	s ID=$p(ItmTempStr,"^",6)   	 ///ID
	s APCode=$p(ItmTempStr,"^",1)  	 ///代码
	s APDesc=$p(ItmTempStr,"^",2) 	 ///描述
	
	/// 新记录
	if +ID="0"  d
	.s HospID=$p(ItmTempStr,"^",4)	 ///医院ID
	.i $d(^DHCDISTA(0,"Code",APCode))   d
	..s APID="0"
	..for  s APID=$o(^DHCDISTA(0,"Code",APCode,APID)) q:(APID="")||(ret'=0)  d
	...s HospDr=$p($g(^DHCDISTA(APID)),"^",4)
	...q:HospDr'=HospID
	...s ret=1
	..
	.
	/// 修改记录
	else  d
	.s HospDr=$p(ItmTempStr,"^",4)	 ///医院ID
	.s DtHospID=$p(ItmTempStr,"^",5)	 ///医院ID
	.i +HospDr=0 s HospID=DtHospID
	.e  s HospID=HospDr
	.s Code=$p($g(^DHCDISTA(ID)),"^",1)    //代码
	.i ($d(^DHCDISTA(0,"Code",APCode)))  d //(Code'=APCode)&($d(^DHCDISTA(0,"Code",APCode)))  d //hxy 2019-07-22 code一样也要判断
	..s APID="0"
	..f  s APID=$o(^DHCDISTA(0,"Code",APCode,APID)) q:(APID="")||(ret'=0)  d
	...s APHospDr=$p($g(^DHCDISTA(APID)),"^",4)
	...s:(APID'=ID)&(APHospDr=HospID) ret=1 //hxy 2019-07-23 st
	...;q:APHospDr'=HospID
	...;s ret=1 //ed
	..
	.
	
	q ret
}

/// Creator：      周鑫
/// CreatDate：    2017-01-05
/// Description:： 分页显示陪送类型字典
/// Table：        DHC_DisType
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCDISTypeAdd).ListDisTypeAdd(,,"","","")
ClassMethod ListDisTypeAdd(page = 1, rows = 10, DTCode, DTDesc, HospDrID, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    w "{""rows"":["
		s DtId=""
		f  s DtId=$o(^DHCDISTA(DtId)) q:DtId=""  d
		.q:DtId=0
		.s code=$p(^DHCDISTA(DtId),"^",1)
		.s desc=$p(^DHCDISTA(DtId),"^",2)
		.s DTActiveFlag=$p(^DHCDISTA(DtId),"^",3)
		.s DTHospDr=$p(^DHCDISTA(DtId),"^",4)
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
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^DTCode^DTDesc^DTActiveFlag^DTHospDr^DTHospDrID",tmp)
		w "],""total"":"_count_"}"
		q ""
}

ClassMethod RemoveDisType(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCDisTypeAdd).%DeleteId(Id)
	  q 0
}

}
