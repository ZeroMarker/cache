Class web.DHCEMSys Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-07
/// Description:   保存或者新增 产品表
/// Table：        DHC_EmSys
/// Input：	       SYCode：代码
///                SYDesc：描述
///                SYGroupName:标识
///                SYActiveFlag：是否可用             
///                SYHospDr:医院id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
        
  		 s SYCode=$p(str,"^",1)
		 s SYDesc=$p(str,"^",2)
		 s SYGroupName=$p(str,"^",3)
		 s SYActiveFlag=$p(str,"^",4)
		 s SYHospDr=$p(str,"^",5)
		 s SYHospDrID=$p(str,"^",6)
		 s ID=$p(str,"^",7)

		 i +ID=0 
		 {
			 s obj=##class(User.DHCEmSys).%New()
			 Q:$d(^DHCEMS(0,"Code",SYCode)) 1
			 s obj.SYHospDr=##class(User.CTHospital).%OpenId(SYHospDr,0)
			 
		 }else{
			 s obj=##class(User.DHCEmSys).%OpenId(ID)
			 
			 i +SYHospDr=0 d
			 .s obj.SYHospDr=##class(User.CTHospital).%OpenId(SYHospDrID,0)
			 e  d
			 .s obj.SYHospDr=##class(User.CTHospital).%OpenId(SYHospDr,0)
			 
			 s isIN=0
			 i $d(^DHCEMS(0,"Code",SYCode)) d
			 .s PHIDUP=$O(^DHCEMS(0,"Code",SYCode,""))
			 .q:PHIDUP=ID
			 .s isIN=1
			 q:isIN=1 1
			 
			 s child=""
			 f  s child=$o(^DHCEMS(ID,"I",child)) quit:child=""  d 
			 .s childsub=""
			 .f  s childsub=$o(^DHCEMS(ID,"I",child,"A",childsub)) quit:childsub=""  d 
			 ..s childsubID=ID_"||"_child_"||"_childsub
			 ..s subsubobj=##class(User.DHCEmSysItmAut).%OpenId(childsubID,0)
			 ..;q:'$IsObject(obj)
			 ..i +SYHospDr=0 d
			 ...s subsubobj.SAHospDr=##class(User.CTHospital).%OpenId(SYHospDrID,0)
			 ..e  d
			 ...s subsubobj.SAHospDr=##class(User.CTHospital).%OpenId(SYHospDr,0)
			 ..s sc=subsubobj.%Save()   
			 }

		 s obj.SYCode=SYCode
		 s obj.SYDesc=SYDesc
		 s obj.SYGroupName=SYGroupName
		 s obj.SYActiveFlag=SYActiveFlag
	 	 ;s obj.SYHospDr=##class(User.CTHospital).%OpenId(%session.Get("LOGON.HOSPID"))
	 	 
	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

ClassMethod SaveSys(params)
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
/// CreatDate：    2016-06-07
/// Description：  分页显示产品表
/// Table：        DHC_EmSys
/// Input：	      page：当前页数
///               rows：每页条数
/// 				  SYGroupName: 产品表标识，多个数据时用英文逗号分隔，例如：DHCEM1,DHCEMCHK
/// Return：       
/// w ##class(web.DHCEMSys).ListSys("1","10","DHCEM","","DHCEM1,DHCGUA,DHCEMCHK,DHCEMDOC,DHCEMSTAT")
ClassMethod ListSys(page = 1, rows = 10, SYGroupName, q, SYGroupNameFlag)
{
	    s ^TMP("DHCEMSYs")=$lb(SYGroupName, q, SYGroupNameFlag)
	    S len=$L(SYGroupNameFlag,",")
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMS(phId)) q:phId=""  d
		.q:phId=0
		.s code=$p(^DHCEMS(phId),"^",1)
		.s desc=$p(^DHCEMS(phId),"^",2)
		.s GroupName=$p(^DHCEMS(phId),"^",3)
		.s SYActiveFlag=$p(^DHCEMS(phId),"^",4)
		.s SYHospDr=$p(^DHCEMS(phId),"^",5)
		.s SYHospDesc="" //hxy 2019-06-21 去掉父表的医院（因为用不到）
		.s:SYHospDr'="" SYHospDesc=$P(^CT("HOSP",SYHospDr),"^",2)
		.s tmp=phId_"^"_code_"^"_desc_"^"_GroupName_"^"_SYActiveFlag_"^"_SYHospDesc_"^"_SYHospDr
		.s Flag=""
		.F i=1:1:len Q:Flag="Y"  D ; 此处是为了模糊检索菜单维护中的产品标识代码
		..S SYFlag=$p(SYGroupNameFlag,",",i)
		..S:GroupName[SYFlag Flag="Y"
		..Q:Flag="Y"
		.q:(SYGroupNameFlag'="")&(Flag'="Y") ; 此处是为了模糊检索菜单维护中的产品标识代码 
		.q:(SYGroupName'="")&(GroupName'[SYGroupName)  ; 此处是为了模糊检索产品维护界面输入的产品标识
		.q:(q'="")&(desc'[q)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",") 
	    .;w jsonObj.FromObject(##class(User.DHCEmSys).%OpenId(phId)).Json()
	    .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^SYCode^SYDesc^SYGroupName^SYActiveFlag^SYHospDr^SYHospDrID",tmp)
		.
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-07
/// Description：  查找一条产品表,以json形式返回
/// Table：        DHC_EmSys
/// Input：	      Id：rowid
/// Return
/// d ##class(web.DHCEMSys).FindSys(1)
ClassMethod FindSys(Id)
{
  
	  q:+Id=0 ""
   
	  s obj=##class(web.DHCAPPJsonObject).%New()
	  w obj.FromObject(##class(User.DHCEmSys).%OpenId(Id,0)).Json()
	  q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-07
/// Description：  删除产品表
/// Table：        DHC_EmSys
/// Input：	      Id：rowid
/// Return：      操作成功 0，其他 失败
ClassMethod RemoveSys(Id)
{
  
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmSys).%DeleteId(Id)
	  s child=""
	  f  s child=$o(^DHCEMS(Id,"I",child)) quit:child=""  d
	  .s childId=Id_"||"_child
	  .s obj=##class(User.DHCEmSysItm).%DeleteId(childId) 
	  .s childsub=""
	  .f  s childsub=$o(^DHCEMS(Id,"I",child,"A",childsub)) quit:childsub=""  d
	  ..s childsubId=Id_"||"_child_"||"_childsub
	  ..s obj=##class(User.DHCEmSysItmAut).%DeleteId(childsubId)
	  q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-07
/// Description：  下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMSys).listIsActive()
ClassMethod ListIsActive()
{
  
	  s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  s listObj=##class(%ListOfObjects).%New()
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","是")) //hxy 2018-10-17 Y 是
	  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","否")) //hxy 2018-10-17 N 否
	  w jsonObj.ListToJson(listObj)	
	  q ""
}

}
