/// 名称: 站点分类
/// 编写者：xy
/// 编写日期: 2021-08-10
Class web.DHCPE.CT.StationLoc Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：    xy 
/// CreatDate：  20210812
/// Description: 判断是否已存在该分类或顺序号
/// Table： 	 科室站点分类序号表（DHC_PE_StationOrdCatSort）
/// Input:       OldOrdCat(分类ID),OldLocSort(顺序号),tableName(表名),LocID(科室ID)
/// Return：     0/1(0 不存在,1  存在)
/// Debug: w ##class(web.DHCPE.CT.StationLoc).IsExistStationOrdCat("","9||14","20","DHC_PE_StationOrdCatSort","152")
ClassMethod IsExistStationOrdCat(OldID, OldOrdCat, OldLocSort, tableName, CurLocID)
{
	s ^tempddhcpe("IsExistStationOrdCat")=$lb(OldID,OldOrdCat,OldLocSort,tableName,CurLocID)
	n (OldOrdCat,OldLocSort,OldID,tableName,CurLocID)
	;b ;tableName,CurLocID
	s flag=0
	s SOSID=""
    f  s SOSID=$o(^CF.PE.StationOrdSortD(SOSID))   q:(SOSID="" )||(flag=1)  d
    .s Sort=$lg($g(^CF.PE.StationOrdSortD(SOSID)),3)
    .s OrdCatDR=$lg($g(^CF.PE.StationOrdSortD(SOSID)),2)
    .q:OrdCatDR=""
    .s LocShowDFlag=##class(User.DHCPEStationOrdCatSort).GetLocShowDataFlag(SOSID,CurLocID)
    .q:LocShowDFlag="N"
    .i (((OrdCatDR=OldOrdCat)&&(OldID=""))||((Sort=OldLocSort)&&(+OrdCatDR=+OldOrdCat)&&(OldID=""))) s flag=1
    .i (OldID'="")&&(OldID'=SOSID)&&((OrdCatDR=OldOrdCat)||((Sort=OldLocSort)&&(+OrdCatDR=+OldOrdCat))) s flag=1
   
    q flag
}

/// Creator：     xy 
/// CreatDate：	 20210812
/// Description: 站点分类序号更新/插入数据
/// Table：      科室站点分类序号表（DHC_PE_StationOrdCatSort）
/// Input:       ID(数据ID),OrdCatID (分类ID), LocSort(分类序号),UserID(当前登陆人ID), 
///              LocID(科室ID), tableName(表名), Empower（是否单独授权） 
/// Return：
/// Debug: d ##class(web.DHCPE.CT.StationLoc).SaveStationOrdCatSort()
ClassMethod SaveStationOrdCatSort(ID, OrdCatID, LocSort, tableName, LocID, UserID, Empower)
{
	s ^tempdhcpe("SaveStationOrdCatSort")=$lb(ID,OrdCatID,LocSort,tableName,LocID,UserID,Empower)
	n (ID,OrdCatID,LocSort,tableName,LocID,UserID,Empower)
    s $ZT="SaveStatOrdCatSortErr"
    s result=1
    
    if ID="" d
	.s obj=##class(User.DHCPEStationOrdCatSort).%New()
	e  d
	.s obj=##class(User.DHCPEStationOrdCatSort).%OpenId(ID)
   
	d obj.SOCSOrdCatDRSetObjectId(OrdCatID)
	s obj.SOCSSort=LocSort
	
	s Flag=##class(web.DHCPE.CT.StationLoc).IsExistStationOrdCat(ID,OrdCatID,LocSort,tableName,LocID)
	i (Flag="1") q "-1^该分类描述或顺序号已存在！"
	
	TSTART
	s sc=obj.%Save()
	d obj.%Close()

	If ($System.Status.IsError(sc))	 
     { 
        s result="-1^保存站点分类顺序号表失败"
        goto SaveStatOrdCatSortErr
		
      }else{
       
   			s RowID=obj.%Id()
   			b ;tableName,RowID,LocID,UserID
   			s ret=##class(User.DHCPEStationOrdCatSort).SaveDataToPowerControl(RowID,LocID,UserID,Empower)
   			//表记录授权插入数据失败
    		If ($p(ret,"^",1)="-1")	 
    		{ 
        		s result="-1^插入记录授权表失败"
        		goto SaveStatOrdCatSortErr
		
   			 }
       	
   		
   	}
	 
	TCommit
        s result="0^保存成功"
        q result  
SaveStatOrdCatSortErr
	
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：		xy 
/// CreatDate：		20210812
/// Description: 	站点分类序号查询
/// Table：			站点分类序号表（DHC_PE_StationOrdCatSort）
/// Input: 
/// Return：
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.StationLoc","FindStatOrdCat","1","DHC_PE_StationOrdCatSort","1")
Query FindStatOrdCat(StationID As %String = "", tableName As %String, LocID As %String) As websys.Query(ROWSPEC = "TSOCSID:%String,TOrdCatDR:%String,TSOCSDesc:%String,TSOCSSort:%String,TEmpower,TEffPowerFlag")
{
}

ClassMethod FindStatOrdCatExecute(ByRef qHandle As %Binary, StationID As %String = "", tableName As %String, LocID As %String) As %Status
{
	s ^tempdhcpe("FindStatOrdCat")=$lb(StationID,tableName,LocID)
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    if (StationID=""){
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
    }
    s ID=""
    f  s ID=$o(^CF.PE.StationOrdSortD(ID))   q:ID=""  d
    .s OrdCatDR=$lg($g(^CF.PE.StationOrdSortD(ID)),2)
    .q:OrdCatDR=""
    .s powerFlg = ##class(User.DHCPEStationLoc).GetLocShowDataFlag(OrdCatDR,LocID)
	.q:powerFlg'="Y"
    .s CatDesc=$p($g(^DHCPEST($p(OrdCatDR,"||",1),"STLOC",$p(OrdCatDR,"||",2))),"^",1)
    .s SOCSSort=$lg($g(^CF.PE.StationOrdSortD(ID)),3)
    .q:($p(OrdCatDR,"||",1)'=StationID)&&(StationID'="")
    .s LocShowDFlag=##class(User.DHCPEStationOrdCatSort).GetLocShowDataFlag(ID,LocID)
    .q:LocShowDFlag="N"
    .s EmpowerStr=##class(User.DHCPEStationOrdCatSort).GetEmpowerFlag(ID,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .;s CatDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStationLoc",CatDesc,"STLLocDesc","cls")
	.s ^CacheTemp(repid,ind)=$lb(ID,OrdCatDR,CatDesc,SOCSSort,Empower,EffPowerFlag)
	.s ind=ind+1
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator：		xy 
/// CreatDate：		20210812
/// Description: 	站点项目序号更新/插入数据
/// Table： 		科室站点项目序号表（DHC_PE_StationOrderSort）
/// Input:  		InputStr(数据ID^父表ID^站点项目组合ID^项目顺序号^表名^当前登陆人ID^科室ID^是否单独授权） 
/// Return：
/// Debug: d ##class(web.DHCPE.CT.StationLoc).SaveStatOrderSort("","7||3536","1","DHC_PE_StationOrderSort","152","12187","N")
ClassMethod SaveStatOrderSort(InputStr)
{
	s ^tempdhcpe("SaveStatOrderSort")=$lb(InputStr)
	n (InputStr)
	S ID=$p(InputStr,"^",1)
	s ParRef=$p(InputStr,"^",2)
	s OrderDR=$p(InputStr,"^",3)
	s SOSSort=$p(InputStr,"^",4)
	s tableName=$p(InputStr,"^",5)
	s LocID=$p(InputStr,"^",6)
	s UserID=$p(InputStr,"^",7)
	s Empower=$p(InputStr,"^",8)
    s $ZT="SaveStatOrderSortErr"
    s result=1
    
    if ID="" d
	.s obj=##class(User.DHCPEStationOrderSort).%New()
	e  d
	.s obj=##class(User.DHCPEStationOrderSort).%OpenId(ID)
	.s OldOrderDR=$lg($g(^CF.PE.StationOrdSortD(+ID,"ORD",$P(ID,"||",2))),2)
    
    d obj.ParRefSetObjectId(ParRef)
	d obj.SOSOrderDRSetObjectId(OrderDR)
	s obj.SOSSort=SOSSort
	
	q:($d(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",OrderDR)))&&(ID="") "-1^医嘱项维护重复!"
	
	TSTART
	s sc=obj.%Save()
	d obj.%Close()
    
	If ($System.Status.IsError(sc))	 
     { 
     
        s result="-1^保存站点项目序号表表失败"
        goto SaveStatOrderSortErr
		
      }else{
   			s RowID=obj.%Id()
   			;b ;tableName,RowID,LocID,UserID
   			s ret=##class(User.DHCPEStationOrderSort).SaveDataToPowerControl(RowID,LocID,UserID,Empower)
   			//表记录授权插入数据失败
    		If ($p(ret,"^",1)="-1")	 
    		{ 
        		s result="-1^插入记录授权表失败"
        		goto SaveStatOrderSortErr
		
   			 }
       	
   		
   	}
	 
	TCommit
        s result="0^保存成功"
        q result  
SaveStatOrderSortErr
	
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：		xy 
/// CreatDate：		20210812
/// Description: 	站点项目序号查询
/// Table：			科室站点项目序号表（DHC_PE_StationOrderSort）
/// Input: 
/// Return：
/// Debug:	d ##class(%ResultSet).RunQuery("web.DHCPE.CT.StationLoc","FindStatOrderSort","3","DHC_PE_StationOrderSort","152")
Query FindStatOrderSort(SOCSID As %String = "", tableName As %String, LocID As %String) As websys.Query(ROWSPEC = "TSOSID,TSOSOrderDR,TARCIMDesc,TSOSSort,TEmpower,TEffPowerFlag")
{
}

ClassMethod FindStatOrderSortExecute(ByRef qHandle As %Binary, SOCSID As %String = "", tableName As %String, LocID As %String) As %Status
{
	s ^tempdhcpe("FindStatOrderSort")=$lb(SOCSID,tableName,LocID)
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    if (SOCSID=""){
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
    }
    
    S Sub=""
    f  s Sub=$o(^CF.PE.StationOrdSortD(SOCSID,"ORD",Sub))   q:Sub=""  d
    .s SOSOrderDR=$lg($g(^CF.PE.StationOrdSortD(SOCSID,"ORD",Sub)),2)
    .q:SOSOrderDR'["||"
    .s ARCIMDR=$p($g(^DHCPEST($P(SOSOrderDR,"||",1),"O",$P(SOSOrderDR,"||",2))),"^",1)
    .q:ARCIMDR'["||"
    .s ARCIMDesc=$p($g(^ARCIM($p(ARCIMDR,"||",1),$p(ARCIMDR,"||",2),1)),"^",2)
    .s SOSSort=$lg($g(^CF.PE.StationOrdSortD(SOCSID,"ORD",Sub)),3)
 	.s ID=SOCSID_"||"_Sub
    .s LocShowDFlag=##class(User.DHCPEStationOrderSort).GetLocShowDataFlag(ID,LocID)
    .q:LocShowDFlag="N"
    .s EmpowerStr=##class(User.DHCPEStationOrderSort).GetEmpowerFlag(ID,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .;s ARCIMDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ARCIMDesc,"ARCIMDesc","cls")
	.s ^CacheTemp(repid,ind)=$lb(ID,SOSOrderDR,ARCIMDesc,SOSSort,Empower,EffPowerFlag)
	.s ind=ind+1
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator：		xy 
/// CreatDate：		20210810
/// Description: 	站点分类更新/插入数据
/// Table：			站点分类表 DHC_PE_StationLoc
/// Input: 			StationID (站点ID), ID(数据ID), LocDesc(分类描述)
/// Return：
/// Debug:	d ##class(web.DHCPE.CT.StationLoc).UpdateStationLoc("","19","一般检查测试分类")
ClassMethod UpdateStationLoc(StationID, ID, LocDesc)
{
	s ^tempdhcpe("UpdateStationLoc")=$lb(StationID, ID, LocDesc)
	i ID="" d
	.&SQL(insert into Sqluser.DHC_PE_StationLoc (STL_ParRef,STL_LocDesc) values (:StationID,:LocDesc))
	e  d
	.&SQL(Update Sqluser.DHC_PE_StationLoc set STL_LocDesc=:LocDesc where STL_RowId=:ID)	
	q SQLCODE
}

ClassMethod UpdateStationLocEx(ID, Code, Desc)
{
    s SQLCODE=0
    &SQL(Update Sqluser.DHC_PE_StationLoc (STL_KBXCode,STL_KBItemCatDesc) values (:Code,:Desc) where STL_RowId=:ID)    
    q SQLCODE
}

/// Creator：	  xy 
/// CreatDate：	  20210810
/// Description:  站点分类查询数据（使用数据，只显示授权科室的数据）
/// Table： 	  站点分类表 DHC_PE_StationLoc
/// Input:        StationID(站点ID),Desc(描述)
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.StationLoc","FindStationLoc","","")
Query FindStationLoc(StationID As %String = "", Desc As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "TSLID:%String,TSLDesc:%String,TEffPowerFlag:%String,TSTKBItemCatDesc:%String")
{
}

ClassMethod FindStationLocExecute(ByRef qHandle As %Binary, StationID As %String = "", Desc As %String = "", LocID As %String = "") As %Status
{
	s ^tempdhcpe("FindStationLoc")=$lb(StationID,Desc,LocID)
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Quit:StationID="" $$$OK
    Quit:'$d(^DHCPEST(StationID,"STLOC")) $$$OK
	
	s ID=0
	f  s ID=$O(^DHCPEST(StationID,"STLOC",ID)) q:ID=""  d
	.d GetStationLoc
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetStationLoc  
	s SLDesc=$p($g(^DHCPEST(StationID,"STLOC",ID)),"^",1)
	q:(Desc'="")&&(SLDesc'[Desc)
	s STKBItemCatDesc=$p($g(^DHCPEST(StationID,"STLOC",ID)),"^",8)
	s STLOCID=StationID_"||"_ID
	s EffPowerFlag = ##class(User.DHCPEStationLoc).GetLocShowDataFlag(STLOCID,LocID)
	q:EffPowerFlag'="Y"
    d FindBuild 
 	q
 	

FindBuild 
	;s SLDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStationLoc",SLDesc,"STLLocDesc","cls")
	set Data=$lb(STLOCID,SLDesc,EffPowerFlag,STKBItemCatDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator：	  xy
/// CreatDate：	  20211111
/// Description:  站点分类查询数据 (维护数据，显示所有数据)
/// Table： 	  站点分类表 DHC_PE_StationLoc
/// Input:        StationID(站点ID),Desc(描述)
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.StationLoc","FindStationLocNew","7","","152")
Query FindStationLocNew(StationID As %String = "", Desc As %String = "", LocID As %String = "") As websys.Query(ROWSPEC = "TSLID:%String,TSLDesc:%String,TEffPowerFlag:%String,TSTKBItemCatDesc:%String")
{
}

ClassMethod FindStationLocNewExecute(ByRef qHandle As %Binary, StationID As %String = "", Desc As %String = "", LocID As %String = "") As %Status
{
	s ^tempdhcpe("FindStationLocNew")=$lb(StationID,Desc,LocID)
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Quit:StationID="" $$$OK
    Quit:'$d(^DHCPEST(StationID,"STLOC")) $$$OK
	
	s ID=0
	f  s ID=$O(^DHCPEST(StationID,"STLOC",ID)) q:ID=""  d
	.d GetStationLocNew
	
	Quit $$$OK
GetStationLocNew  
	s SLDesc=$p($g(^DHCPEST(StationID,"STLOC",ID)),"^",1)
	q:(Desc'="")&&(SLDesc'[Desc)
	s STKBItemCatDesc=$p($g(^DHCPEST(StationID,"STLOC",ID)),"^",8)
	s STLOCID=StationID_"||"_ID
	s EffPowerFlag=##class(User.DHCPEStationLoc).GetLocShowDataFlag(STLOCID,LocID)
	s EffPowerFlag=$s(EffPowerFlag="Y":"Y",1:"N")
    d FindBuildNew
 	q
 	
FindBuildNew 
	;s SLDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStationLoc",SLDesc,"STLLocDesc","cls")
	;s STKBItemCatDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEStationLoc",STKBItemCatDesc,"STLKBItemCatDesc","cls")
	set Data=$lb(STLOCID,SLDesc,EffPowerFlag,STKBItemCatDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator：    xueying
/// CreatDate：  20211107
/// Description: 判断科室组下是否有重复的顺序号
/// Table：      科室站点项目序号表（DHC_PE_StationOrderSort）
/// Input:       SOCSID(分类ID),SOSID(分类项目ID),LocID(科室ID),tableName(科室站点项目序号表),Sort(顺序号)             
/// Return：     0/1
/// Dubug： w ##class(web.DHCPE.CT.StationLoc).IsExsistSort()
ClassMethod IsExsistSort(SOCSID As %String = "", SOSID As %String = "", LocID As %String, tableName As %String, Sort As %String = "")
{
	s ^tempdhcpe("IsExsistSort")=$lb(SOCSID,SOSID,LocID,tableName,Sort)
	s flag=0
	S Sub=""
    f  s Sub=$o(^CF.PE.StationOrdSortD(SOCSID,"ORD",Sub))   q:(Sub="")||(flag=1)  d
    .s SOSOrderDR=$lg($g(^CF.PE.StationOrdSortD(SOCSID,"ORD",Sub)),2)
    .q:SOSOrderDR'["||"
    .s ARCIMDR=$p($g(^DHCPEST($P(SOSOrderDR,"||",1),"O",$P(SOSOrderDR,"||",2))),"^",1)
    .q:ARCIMDR'["||"
    .s ARCIMDesc=$p($g(^ARCIM($p(ARCIMDR,"||",1),$p(ARCIMDR,"||",2),1)),"^",2)
    .s SOSSort=$lg($g(^CF.PE.StationOrdSortD(SOCSID,"ORD",Sub)),3)
 	.s ID=SOCSID_"||"_Sub
    .s LocShowDFlag=##class(User.DHCPEStationOrderSort).GetLocShowDataFlag(ID,LocID)
    .q:LocShowDFlag="N"
    .i (Sort=SOSSort)&&(ID'=SOSID) s flag=1
     q flag
}

}
