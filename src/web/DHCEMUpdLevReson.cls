Class web.DHCEMUpdLevReson Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-25
/// Description:   保存或者新增 更改分级原因字典
/// Table：        DHC_EmUpdLevReson
/// Input：	       ULRCode：代码
///                ULRDesc：描述
///                ULRActiveFlag：是否可用             
///                ULRHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
  		 s ULRCode=$p(str,"^",1)
		 s ULRDesc=$p(str,"^",2)
		 s ULRActiveFlag=$p(str,"^",3)
		 s ULRHospDr=$p(str,"^",4)
		 s ULRHospDrID=$p(str,"^",5)
		 s ID=$p(str,"^",6)

		 i +ID=0 
		 {
			 s obj=##class(User.DHCEmUpdLevReson).%New()
			 s obj.ULRHospDr=##class(User.CTHospital).%OpenId(ULRHospDr,0)
			 Q:$d(^DHCEMULR(0,"Code",ULRCode)) 1
			 
		 }else{
			 s obj=##class(User.DHCEmUpdLevReson).%OpenId(ID)
			 i +ULRHospDr=0 d
			 .s obj.ULRHospDr=##class(User.CTHospital).%OpenId(ULRHospDrID,0)
			 e  d
			 .s obj.ULRHospDr=##class(User.CTHospital).%OpenId(ULRHospDr,0)
			 
			 s isIN=0
			 i $d(^DHCEMULR(0,"Code",ULRCode)) d
			 .s PHIDUP=$O(^DHCEMULR(0,"Code",ULRCode,""))
			 .q:PHIDUP=ID
			 .s isIN=1
			 q:isIN=1 1
		 }
		
		 s obj.ULRCode=ULRCode
		 s obj.ULRDesc=ULRDesc
		 s obj.ULRActiveFlag=ULRActiveFlag
	 	 
	 	
	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
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

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-25
/// Description:： 分页显示 更改分级原因字典
/// Table：        DHC_EmUpdLevReson
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCEMUpdLevReson).ListUpdLevReson(,,"","","")
ClassMethod ListUpdLevReson(page = 1, rows = 10, ULRCode, ULRDesc, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMULR(phId)) q:phId=""  d
		.q:phId=0
		.s code=$p(^DHCEMULR(phId),"^",1)
		.s desc=$p(^DHCEMULR(phId),"^",2)
		.s ULRActiveFlag=$p(^DHCEMULR(phId),"^",3)
		.s ULRHospDr=$p(^DHCEMULR(phId),"^",4)
		.s HospDesc="" //2019-12-25
		.s:ULRHospDr'="" HospDesc=$P(^CT("HOSP",ULRHospDr),"^",2)
		.s tmp=phId_"^"_code_"^"_desc_"^"_ULRActiveFlag_"^"_HospDesc_"^"_ULRHospDr
		.q:(ULRCode'="")&(code'[ULRCode)
		.q:(ULRDesc'="")&(desc'[ULRDesc)
		.q:(q'="")&(desc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEmUpdLevReson).%OpenId(phId)).Json()
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^ULRCode^ULRDesc^ULRActiveFlag^ULRHospDr^ULRHospDrID",tmp)
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-25
/// Description:： 查找一条更改分级原因,以json形式返回
/// Table：        DHC_EmUpdLevReson
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCEMUpdLevReson).FindUpdLevReson(1)
ClassMethod FindUpdLevReson(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCEmUpdLevReson).%OpenId(Id,0)).Json()
	  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-25
/// Description:： 删除更改分级原因字典
/// Table：        DHC_EmUpdLevReson
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveUpdLevReson(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmUpdLevReson).%DeleteId(Id)
	  q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-25
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMUpdLevReson).listIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是")) //2018-10-16 Y
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否")) //2018-10-16 N
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

}
