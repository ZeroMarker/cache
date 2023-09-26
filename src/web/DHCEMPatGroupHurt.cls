/// Creator: 	lvpeng	
/// CreateDate: 2017-11-15
/// Descript: 	群伤管理事件维护类
Class web.DHCEMPatGroupHurt Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      lvpeng
/// CreatDate：    2017-11-15
/// Description:： 保存或者新增 群伤管理事件字典
/// Table：        DHC_EmGroupHurt
/// Input：	       GHUCode：代码
///                GHUDesc：描述
///                GHUCreateDate: 事件日期
///                GHUCreateTime: 事件时间
///                GHUGeneralSpec: 概要说明
///                GHUDetailSpec: 详细说明
///                GHUActiveFlag：是否可用             
///                GHUHospDr: 医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
  		 s GHUCode=$p(str,"^",1) //代码
		 s GHUDesc=$p(str,"^",2) //描述 
		 s GHUCreateDateAndTime=$p(str,"^",3)
		 s GHUCreateDate="",GHUCreateTime=""
		 s:GHUCreateDateAndTime'="" GHUCreateDate=$p(GHUCreateDateAndTime," ",1) //事件日期
		 s:GHUCreateDateAndTime'="" GHUCreateTime=$p(GHUCreateDateAndTime," ",2) //事件时间
		 s GHUGeneralSpec=$p(str,"^",4) //概要说明
		 s GHUDetailSpec=$p(str,"^",5) //详细说明
		 s GHUActiveFlag=$p(str,"^",6) 
		 s GHUHospDr=$p(str,"^",7)
		 s GHUHospDrID=$p(str,"^",8)
		 s ID=$p(str,"^",9)

		 i +ID=0 
		 { 
		 	 s obj=##class(User.DHCEmGroupHurt).%New()
		 	 s obj.GHUHospDr=##class(User.CTHospital).%OpenId(GHUHospDr,0)
		 	 Q:$d(^DHCEMGHU(0,"Code",GHUCode)) 1 //hxy 2020-05-22 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
		 	 ;Q:..CheckExist(GHUCode,GHUHospDr) 1 //hxy 2020-05-22 //2023-01-18 注释
		 }else{
			 s obj=##class(User.DHCEmGroupHurt).%OpenId(ID)
			 i +GHUHospDr=0 d
			 .s obj.GHUHospDr=##class(User.CTHospital).%OpenId(GHUHospDrID,0)
			 e  d
			 .s obj.GHUHospDr=##class(User.CTHospital).%OpenId(GHUHospDr,0)
			 
			 s isIN=0
			 i $d(^DHCEMGHU(0,"Code",GHUCode)) d
			 .s GHUIDUP=$O(^DHCEMGHU(0,"Code",GHUCode,""))
			 .q:GHUIDUP=ID
			 .s isIN=1
			 q:isIN=1 1 //hxy 2020-05-25 注释 //hxy 2023-01-18放开注释 私有数据医院组间代码不能重复
			 ;s PHIDUP=..CheckExist(GHUCode,GHUHospDr) //hxy 2020-05-25 st //2023-01-18 注释
			 ;Q:(PHIDUP'=0)&(ID'=PHIDUP) 1 //ed
			  }
		
		 s obj.GHUCode=GHUCode
		 s obj.GHUDesc=GHUDesc
		 s obj.GHUCreateDate=""
		 s obj.GHUCreateTime=""
		 s obj.GHUGeneralSpec=GHUGeneralSpec
		 s obj.GHUDetailSpec=GHUDetailSpec
		 s obj.GHUActiveFlag=GHUActiveFlag

	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

/// w ##class(web.DHCEMPatGroupHurt).SavePatGroupHurt("车祸^车祸^2018-01-22 09:51:51^1^1^Y^2^^")
ClassMethod SavePatGroupHurt(params)
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

/// Creator：      lvpeng
/// CreatDate：    2017-11-15
/// Description:： 分页显示群伤事件维护数据
/// Table：        DHC_EmGroupHurt
/// Input：	      page：当前页数
///               rows：每页条数    
/// d ##class(web.DHCEMPatGroupHurt).ListGroupHurt(1,10,"","","")
ClassMethod ListGroupHurt(page = 1, rows = 10, GHUCode, GHUDesc, GHUHospDrID, q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s ghtId=""
		f  s ghtId=$o(^DHCEMGHU(ghtId)) q:ghtId=""  d
		.q:ghtId=0
		.q:$p(^DHCEMGHU(ghtId),"^",9)'="" //hxy 2019-10-21 事件类型有值得退出
		.s code=$p(^DHCEMGHU(ghtId),"^",1)
		.s desc=$p(^DHCEMGHU(ghtId),"^",2)
		.s GHUCreateDate=$p(^DHCEMGHU(ghtId),"^",3)
		.s:GHUCreateDate'="" GHUCreateDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(GHUCreateDate)
		.s GHUCreateTime=$p(^DHCEMGHU(ghtId),"^",4)
		.s:GHUCreateTime'="" GHUCreateTime=$zt(GHUCreateTime,1)
		.s GHUDateAndTime=GHUCreateDate_" "_GHUCreateTime
		.s GHUGeneralSpec=$p(^DHCEMGHU(ghtId),"^",5)
		.s GHUDetailSpec=$p(^DHCEMGHU(ghtId),"^",6)
		.s GHUActiveFlag=$p(^DHCEMGHU(ghtId),"^",7)
		.s GHUHospDr=$p(^DHCEMGHU(ghtId),"^",8)
		.s HospDesc=""
		.i GHUHospDr'="" s HospDesc=$P(^CT("HOSP",GHUHospDr),"^",2)
		.s tmp=ghtId_"^"_code_"^"_desc_"^"_GHUDateAndTime_"^"_GHUGeneralSpec_"^"_GHUDetailSpec_"^"_GHUActiveFlag_"^"_HospDesc_"^"_GHUHospDr
		.q:(GHUCode'="")&(code'[GHUCode)
		.q:(GHUDesc'="")&(desc'[GHUDesc)
		.q:(GHUHospDrID'="")&(GHUHospDr'=GHUHospDrID) //hxy 2019-07-17
		.q:(q'="")&(desc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
		.;w jsonObj.FromObject(##class(User.DHCEmPatHistory).%OpenId(phId)).Json()
		.w ##class(web.DHCAPPJsonCommon).getJsonData("ID^GHUCode^GHUDesc^GHUDateAndTime^GHUGeneralSpec^GHUDetailSpec^GHUActiveFlag^GHUHospDr^GHUHospDrID",tmp)
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      lvpeng
/// CreatDate：    2016-05-09
/// Description:： 查找一条既往史字典,以json形式返回
/// Table：        DHC_EmGroupHurt
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCEMPatGroupHurt).FindGroupHurt(1)
ClassMethod FindGroupHurt(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCEmGroupHurt).%OpenId(Id,0)).Json()
	  q ""
}

/// Creator：      lvpeng
/// CreatDate：    2017-11-15
/// Description:： 删除既往史字典
/// Table：        DHC_EmGroupHurt
/// Input：	      Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod RemoveGroupHurt(ID)
{
  
	q:+ID=0 -1
	s code=0,msg="success"
	d:+ID=0 ##class(web.DHCEMPatGroupHurt).R(code,msg)
	q:+ID=0 ""

	s sc=##class(User.DHCEmGroupHurt).%DeleteId(ID)
	i $SYSTEM.Status.IsError(sc) d
	.s code=$SYSTEM.Status.GetErrorCodes(sc)
	.s msg=$SYSTEM.Status.GetErrorText(sc)
	d ##class(web.DHCEMPatGroupHurt).R(code,msg)
	q ""
}

/// d ##class(web.DHCEMDocGuarantee).R(0,1)
ClassMethod R(code, msg) As %String
{
	s rObj = ##class(web.DHCAPPJsonObject).%New()
	d rObj.Put("code",code).Put("msg",msg)
	w rObj.Json()
	q ""
}

/// Creator：      lvpeng
/// CreatDate：    2016-05-09
/// Description:： 下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMPatGroupHurt).ListIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是"))
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否"))
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

/// w ##class(web.DHCEMPatGroupHurt).CheckExist("1","3")
ClassMethod CheckExist(PHCode, HospDr)
{
	s ret=0
	s RowID=0
	f  s RowID=$o(^DHCEMGHU(0,"Code",PHCode,RowID)) q:RowID=""  d
	.s RLHospDr=$p(^DHCEMGHU(RowID),"^",8)
	.q:HospDr'=RLHospDr
	.s ret=RowID
	q ret
}

}
