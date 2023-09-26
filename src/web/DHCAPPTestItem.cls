Class web.DHCAPPTestItem Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      yuliping
/// CreatDate：    2017-07-07
/// Description:   分页显示 7.3.病理检测项目字典表
/// Table：        DHC_APPTestItem
/// Input：	       page：当前页数
///                rows：每页条数 
/// Return：       json
/// w ##class(web.DHCAPPTestItem).ListAPPTestItem("1","10","","")
ClassMethod ListAPPTestItem(page = 1, rows = 10, ATICode, ATIDesc)
{
	
	n (page,rows,ATICode,ATIDesc)
	
	s start=(page-1)*rows+1
	 s end=page*rows
	 s count=0
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 w "{""rows"":["
	 s ATIid=""
	 f  s ATIid=$o(^DHCAPPTI(ATIid))  q:ATIid=""  d
	 .q:ATIid=0
	 .s msg=$g(^DHCAPPTI(ATIid))
	 .q:msg=""
	 .s code=$p(msg,"^",1)			//项目代码
	 .s desc=$p(msg,"^",2)			//项目描述
	 .s ArcDr=$p(msg,"^",3)     	//项目关联医嘱项
	 .s HospDr=$p(msg,"^",4)		//医院标识
	 .s ActiveFlag=$p(msg,"^",5)	//是否可用
	 .s CatDr=$p(msg,"^",7)			//检查分类
	 .s ArcDesc=""
	 .s HospDesc=""
	 .s CatDesc=""
	 .i +ArcDr'=0 s ArcDesc=$p(^ARCIM($p(ArcDr,"||",1),$p(ArcDr,"||",2),1),"^",3)  //项目关联医嘱项描述
	 .i +HospDr'=0 s HospDesc=$P(^CT("HOSP",HospDr),"^",2)
	 .i +CatDr'=0 s CatDesc=$p(^DHCAPPTC(CatDr),"^",2)								   //检查分类描述
	 
	 .s tmp=code_"^"_desc_"^"_ArcDesc_"^"_HospDesc_"^"_ActiveFlag_"^"_CatDesc_"^"_ArcDr_"^"_HospDr_"^"_CatDr_"^"_ATIid
	 .q:(ATICode'="")&(code'[ATICode)
	 .q:(ATIDesc'="")&(desc'[ATIDesc)
	 .s count=count+1
	 .q:count<start
	 .q:count>end
	 .w $case(count,start:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("ATICode^ATIDesc^ArcDesc^HospDesc^ActiveFlag^CatDesc^ArcDr^HospDr^CatDr^ATIid",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-07-07
/// Description:   分页显示 医嘱项
/// Table：        ARC_ItmMast
/// Input：	       page：当前页数
///                rows：每页条数 
/// Return：       json
/// w ##class(web.DHCAPPTestItem).getARCItmMast(1,10)
ClassMethod getARCItmMast(page = 1, rows = 10, q = "")
{
	
	n (page,rows,q)
	
	s start=(page-1)*rows+1
	s end=page*rows
	s count=0
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	
	s EntryAlias1="%"_q_"%" 
	s EntryAlias="%"_$$ALPHAUP^SSUTIL4(q)_"%"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr ="select distinct alias_arcim_dr from arc_alias where %ALPHAUP(alias_text) like '"_EntryAlias_"' or ALIAS_Desc like '"_EntryAlias1_"' "  
	;s sqlStr ="select distinct alias_arcim_dr from arc_alias where %ALPHAUP(alias_text) like '"_EntryAlias_"'"  
    
    D result.Prepare(sqlStr)
    s SC=result.Execute()
    i $$$ISERR(SC) Q ""
    
 	w "{""rows"":["
    While(result.Next()){
	
	s arcimid = result.Data("ALIAS_ARCIM_DR")
	
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	Continue:+itmmastver=0
    Continue:'$d(^ARCIM(itmmastid,itmmastver))
	s arcimdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",3)
	//s arcimR=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
	s arcimrcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)
	s tmp=arcimid_"^"_arcimrcode_"^"_arcimdesc
	s count = count+1
	Continue:count<start
	Continue:count>end
	w $case(count,start:"",:",") 
	w ##class(web.DHCAPPJsonCommon).getJsonData("value^code^text",tmp)
	}
	
	
	w "],""total"":"_count_"}"
	
	q ""
}

ClassMethod SaveUpdTestItem(params)
{
    n (params)
	s ^SF(11)=params
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
/// CreatDate：    2017-07-07
/// Description:   保存或者新增 病理检测项目字典表
/// Table：        DHC_APPTestItem
/// Input：	      
///                
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败 
/// d ##class(web.DHCAPPTestItem).SaveOrUpdate("Code^coddd^液状石蜡外用液体剂^东华标准版数字化医院^Y^超声^5||1^2^2^4")
ClassMethod SaveOrUpdate(str)
{
		 n (str)
		
		 s ValueFlag=0,isIN=0,isINC=0
  		 s Code=$p(str,"^",1)				//项目代码
		 s Desc=$p(str,"^",2)				//项目描述
		 s ArcDesc=$p(str,"^",3) 			//项目关联医嘱项描述
		 s HospDesc=$p(str,"^",4)			//医院标识
		 s ActiveFlag=$p(str,"^",5)			//是否可用
		 s CatDesc=$p(str,"^",6)			//检查分类   
		 s ArcDr=$p(str,"^",7)
		 s HospDr=$p(str,"^",8)
		 s CatDr=$p(str,"^",9)
		 s ID=$p(str,"^",10)
		 //ATICode^ATIDesc^ArcDesc^HospDesc^ActiveFlag^CatDesc^ArcDr^HospDr^CatDr^ATIid
		 i ((+CatDesc=0)&&(CatDesc'=0)) s CatDesc=CatDr				
		 i ((+HospDesc=0)&&(HospDesc'=0)) s HospDesc=HospDr
		 i ((+ArcDesc=0)&&(ArcDesc'=0)) s ArcDesc=ArcDr
		 i +ID=0  d							//ID为空，新建对象
		 .s obj=##class(User.DHCAppTestItem).%New()										
		 .i $d(^DHCAPPTI(0,"Code",$$ALPHAUP^SSUTIL4(Code))) s ValueFlag=1	 //判断代码或描述是否存在
		 .i $d(^DHCAPPTI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))) s ValueFlag=1
		 q:(ValueFlag=1) 1
		 e  d								//ID不为空，打开对象
		 .s obj=##class(User.DHCAppTestItem).%OpenId(ID)
		 .s isIN=0							//判断代码或描述是否存在
		 .i $d(^DHCAPPTI(0,"Code",$$ALPHAUP^SSUTIL4(Code))) d
		 ..s newid=$o(^DHCAPPTI(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
		 ..q:newid=ID
		 ..s isIN=1
		 .i $d(^DHCAPPTI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))) d
		 ..s newid=$o(^DHCAPPTI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),""))
		 ..q:newid=ID
		 ..s isINC=1
		 
		 q:(isIN=1) 1
		 q:(isINC=1) 2
		 s obj.ATIHospDr=##class(User.CTHospital).%OpenId(HospDesc)
		 s obj.ATICode=Code
		 
		 s obj.ATIDesc=Desc
		 s obj.ATIArcDr=##class(User.ARCItmMast).%OpenId(ArcDesc)
		 
	 	 s obj.ATITestCatDr=##class(User.DHCAppTestCat).%OpenId(CatDesc)   //sufan 修改为检测项目
	 	 s obj.ATIActiveFlag=ActiveFlag
	 	 
	     s sc=obj.%Save()  
	     
		 ;i $$$ISERR(sc) q -2
		 q 0
}

/// CreatDate:2017-07-07
/// Descript:检查分类列表
/// w ##Class(web.DHCAPPTestItem).QueryArcCatList()
/// yuliping
ClassMethod QueryArcCatList()
{
	
    s count=0
   
    w "["
	s cat=0
	f  s cat=$o(^DHCAPPTC(cat)) q:cat=""  d
	.q:+cat=0
	.s tmpdesc=$p(^DHCAPPTC(cat),"^",2)
	.s tmp=cat_"^"_tmpdesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Creator：      yuliping
/// CreatDate：    2017-07-07
/// Description:   删除 病理检测项目字典表
/// Table：        DHC_APPTestItem
/// Input：	      
///                
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败 
/// d ##class(web.DHCAPPTestItem).RemoveTestItem("")
ClassMethod RemoveTestItem(Id)
{
	n (Id)
  
	q:+Id=0 -1
	s obj=##class(User.DHCAppTestItem).%DeleteId(Id)
	q 0
}

/// Creator：      yuliping
/// CreatDate：    2017-07-10
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCAPPTestItem).listIsActive()
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
