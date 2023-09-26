Class web.DHCDISStatusAdd Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      yuliping
/// CreatDate：    2017-01-07
/// Description:   分页显示 配送状态字典维护
/// Table：        DHC_DisStatusAdd
/// Input：	       page：当前页数
///                rows：每页条数 
/// Return：     
/// w ##class(web.DHCDISStatusAdd).ListSStatusAdd("1","10","","")
ClassMethod ListSStatusAdd(page = 1, rows = 10, SACode, SADesc, HospDrID)
{
	
	 s start=(page-1)*rows+1
	 s end=page*rows
	 s count=0
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 w "{""rows"":["
	 s SAid=""
	 f  s SAid=$o(^DHCDISSA(SAid))  q:SAid=""  d
	 .q:SAid=0
	 .s msg=$g(^DHCDISSA(SAid))
	 .q:msg=""
	 .s code=$p(msg,"^",1)
	 .s desc=$p(msg,"^",2)
	 .s ActiveFlag=$p(msg,"^",3)
	 .s MustFlag=$p(msg,"^",4)
	 .s SALocDr=$p(msg,"^",5)
	 .s SAType=$p(msg,"^",6)
	 .q:SAType=9                                    //过滤陪送类型 yuliping 2017-05-02
	 .s SATypeDesc="",SALocDesc=""
	 .i (+SALocDr'=0)&&($d(^DHCDISNL(SALocDr))) s SALocDesc=$p(^DHCDISNL(SALocDr),"^",2)
	 .i (+SAType'=0)&&($d(^DHCDISTA(SAType))) s SATypeDesc=$p(^DHCDISTA(SAType),"^",2)
	 .s SAHospDr=$p(^DHCDISSA(SAid),"^",7) //hxy 2019-07-01 st
	 .s HospDesc=""
	 .i SAHospDr'="" s HospDesc=$P(^CT("HOSP",SAHospDr),"^",2)
	 .s tmp=SAid_"^"_code_"^"_desc_"^"_ActiveFlag_"^"_MustFlag_"^"_SALocDesc_"^"_SAType_"^"_SALocDr_"^"_$g(SATypeDesc)_"^"_SAHospDr_"^"_HospDesc //hxy ed
	 .q:(SACode'="")&(code'[(SACode))
	 .q:(SADesc'="")&(desc'[(SADesc))
	 .q:(HospDrID'="")&(HospDrID'=SAHospDr) //hxy 2019-07-22
	 .s count=count+1
	 .q:count<start
	 .q:count>end
	 .w $case(count,start:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^SACode^SADesc^SAActiveFlag^SAMustFlag^SALocDr^SAType^LocDrId^SATypeDesc^SAHospDrID^SAHospDr",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// w ##class(web.DHCDISStatusAdd).SaveUpdStatusAdd("101^接受^Y^Y^^1^0^0")
ClassMethod SaveUpdStatusAdd(params)
{
	//s $Zt="Err"
	s ^tempsufan("params")=params
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

/// Creator：      yuliping
/// CreatDate：    2017-01-07
/// Description:   保存或者新增 配送状态字典
/// Table：        DHC_DisStatusAdd
/// Input：	       SACode：代码
///                SADesc：描述
///                SAActiveFlag：激活标志
/// 				   SAMustFlag  ；必须流程       
///                SALocDr:科室
/// 			   SAType：类型
/// Return：       保存成功 0，其他 失败 14^3^Y^0^0^0^0
/// W ##Class(web.DHCDISStatusAdd).SaveOrUpdate("10^待处理^Y^Y^^2^^1^2^")
ClassMethod SaveOrUpdate(str)
{
		
  		 s SACode=$p(str,"^",1)
		 s SADesc=$p(str,"^",2)
		 Q:(SACode[" ")||(SADesc[" ") -3
		 s SAActiveFlag=$p(str,"^",3)
		 i SAActiveFlag="" s SAActiveFlag="Y"
		 i SAActiveFlag=0 s SAActiveFlag="N"
		 s SAMustFlag=$p(str,"^",4)
		 i SAMustFlag="" s SAMustFlag="Y"
		 i SAMustFlag=0 s SAMustFlag="N"
		 s SALocDr=$p(str,"^",5)
		 s SAType=$p(str,"^",6)
		 s LocDrId=$p(str,"^",7)
		 s ID=$p(str,"^",8)
		 s SAHospDr=$p(str,"^",9) //hxy 2019-07-01 
		 s SAHospDrID=$p(str,"^",10) //hxy 2019-07-01 
		 i +SAHospDr=0 s SAHospDr=SAHospDrID //hxy 2019-07-08
		 i +SALocDr=0 s SALocDr=LocDrId 
		 s isIN=0,isNew=0,rtn=0
	
		
		 i +ID=0 d
		 .s obj=##class(User.DHCDisStatusAdd).%New()
		 .i SALocDr'="" d  s rtn=..alreadyIn(SALocDr,SAType,SACode,SADesc,0) 
		 .s:$d(^DHCDISSA(0,"CodeTypeHosp",SACode,SAType,SAHospDr)) rtn=1 //hxy 2019-07-01
		 e  d
		 .s obj=##class(User.DHCDisStatusAdd).%OpenId(ID)
		 .i SALocDr'="" d  s rtn=..alreadyIn(SALocDr,SAType,SACode,SADesc,1) 
		 .s isIN=0 //hxy 2019-07-01 st
		 .i $d(^DHCDISSA(0,"CodeTypeHosp",SACode,SAType,SAHospDr)) d
		 ..s SAID=$O(^DHCDISSA(0,"CodeTypeHosp",SACode,SAType,SAHospDr,""))
		 ..q:SAID=ID
		 ..s isIN=1
		 .S:isIN=1 rtn=1 //hxy ed
		 
		 q:rtn=1 1
		 
		 s obj.SACode=SACode
		 s obj.SADesc=SADesc
		 s obj.SAActiveFlag=SAActiveFlag
		 s obj.SAMustFlag=SAMustFlag
		 s:+SALocDr'=0 obj.SALocDr=##class(User.DHCDisNodeLoc).%OpenId(SALocDr)
		 s:SAType'=0 obj.SAType=##class(User.DHCDisTypeAdd).%OpenId(SAType)
		 s:+SAHospDr'=0 obj.SAHospDr=##class(User.CTHospital).%OpenId(SAHospDr)  //hxy 2019-07-01
	     s sc=obj.%Save()   
		 i $$$ISERR(sc) q -2
		 q 0
}

/// Creator：      yuliping
/// CreatDate：    2017-01-18
/// Description:： 下拉列表显示 已激活/未激活
ClassMethod ListStatActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-01-18
/// Description:： 下拉列表显示 必须/非必须
ClassMethod ListMustActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-01-18
/// Description:： 下拉列表显示 配送/陪送
ClassMethod ListTypeActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","1").Put("text","配送"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","0").Put("text","陪送"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-01-10
/// Description:： 配送状态字典表字典
/// Table：       DHC_DisStatusAdd
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveStatusAdd(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCDisStatusAdd).%DeleteId(Id)
	  q 0
}

/// W ##Class(web.DHCDISStatusAdd).alreadyIn("1","1","11")
ClassMethod alreadyIn(LocId, SaType, Code, Desc, IsNew)
{
	
	s saRowId="",flag=0

	f  s saRowId=$o(^DHCDISSA(0,"Loc",LocId,SaType,saRowId)) q:saRowId=""  d
	.i $d(^DHCDISSA(saRowId)) s msg=^DHCDISSA(saRowId)
	.s code=$p(msg,"^",1)
	.s desc=$p(msg,"^",2)
	.i ((code=Code)&&(IsNew=0)) s flag=1
	.i ((desc=Desc)&&(IsNew=1))  s flag=1
	q flag
}

/// Creator:    yuliping
/// CreateDate: 2017-05-02
/// Descript: 配送类型，过滤陪送
/// w ##class(web.DHCDISStatusAdd).TypeAddLocCombo()
ClassMethod TypeAddLocCombo()
{
	
	s End = 10
	s Start=1
	s Count=0
	w "["
	s type=0
	f  s type = $o(^DHCDISTA(type)) q:type=""  d
	.s name=$p(^DHCDISTA(type),"^",2)
	.s flag=$p(^DHCDISTA(type),"^",3)
	.q:flag'="Y"
	.s Hosp=$p(^DHCDISTA(type),"^",4)
	.s name=$ZCONVERT(name,"U")
	.q:type=9
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",type_"^"_name)
	w "]"
	q ""
}

/// Creator:    huaxiaoying
/// CreateDate: 2019-09-19
/// Descript:   根据类型ID取医院ID
/// w ##class(web.DHCDISStatusAdd).GetHospByType()
ClassMethod GetHospByType(ID)
{
	
	q:ID="" ""
	s Hosp=$p(^DHCDISTA(ID),"^",4)
	q Hosp
}

}
