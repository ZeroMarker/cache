/// 名称:手术和过程 - 19手术/过程扩展表
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2016-7-8
Class web.DHCBL.CT.ORCOperationExtend Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2016-7-8
/// Description:增加/修改 手术/过程
/// Table:User.ORCOperationExtend
/// Input:web.Entity.CT.ORCOperationExtend
/// Return:成功返回success:'true'和新增或修改的数据的OPERERowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.ORCOperationExtend) As %String
{
	new (eobj,%session)
    s result=""
	s flag= ##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.ORCOperationExtend")
	if (flag=1)
	{	
		if $IsObject(eobj)
		{
		
			s eobj.OPERUpdateDate = +$h
			s eobj.OPERUpdateTime = $p($h,",",2)
			if $d(%session) s eobj.OPERUpdateUserDr=$g(%session.Data("LOGON.USERID"))
			
			//前台js已添加空值判断、重复判断、开始日期是否小于结束日期
			s:eobj.OPERIsKeyOperation="" eobj.OPERIsKeyOperation="N"
			s:eobj.OPERIsUploadCode="" eobj.OPERIsUploadCode="N"
			s:eobj.OPERIsSpecial="" eobj.OPERIsSpecial="N"
			s:eobj.OPERIsHighRisk="" eobj.OPERIsHighRisk="N"
			s:eobj.OPERIsAudit="" eobj.OPERIsAudit="N"
			s:eobj.OPERIsPacs="" eobj.OPERIsPacs="N"
			s:eobj.OPERIsSupplierPreparation="" eobj.OPERIsSupplierPreparation="0"
			s:eobj.OPERIsProtectiveAntibacterial="" eobj.OPERIsProtectiveAntibacterial="0"
			s:eobj.OPERIsMinInvasive="" eobj.OPERIsMinInvasive="N"
			s:eobj.OPERIsSubOperation="" eobj.OPERIsSubOperation="N"  /// 是否子手术
			s:eobj.OPERIsRestrictedTechnology="" eobj.OPERIsRestrictedTechnology="N"  /// 是否限制类技术
			s:eobj.OPERIsNewItem="" eobj.OPERIsNewItem="N"  /// 是否新项目新技术
			
			if (eobj.OPERERowId="")       
			{
				s obj=##class(User.ORCOperationExtend).%New()
			}
			else                           
			{
				s obj=##class(User.ORCOperationExtend).%OpenId(eobj.OPERERowId)
			
				s bobj = ##class(web.Entity.CT.ORCOperationExtend).%New()
				s bobj.OPERERowId = eobj.OPERERowId
				s:obj.OPERClassDr'="" bobj.OPERClassDr=obj.OPERClassDr.%Id()
				s:obj.OPERBladeDr'="" bobj.OPERBladeDr=obj.OPERBladeDr.%Id()
				s:obj.OPERBodySiteDr'="" bobj.OPERBodySiteDr=obj.OPERBodySiteDr.%Id()
				s:obj.OPEROperPositionDr'="" bobj.OPEROperPositionDr=obj.OPEROperPositionDr.%Id()
				s:obj.OPERDefaultOperLocDr'="" bobj.OPERDefaultOperLocDr=obj.OPERDefaultOperLocDr.%Id()
				s:obj.OPERCategoryDr'="" bobj.OPERCategoryDr=obj.OPERCategoryDr.%Id()
			
				s:obj.OPERUpdateUserDr'="" bobj.OPERUpdateUserDr=obj.OPERUpdateUserDr.%Id()
			
				s bobj.OPERSurgeonDeptDr = obj.OPERSurgeonDeptDr  //手术医生科室Id(|分割)
				s bobj.OPERIsKeyOperation = obj.OPERIsKeyOperation
				s bobj.OPERScrubNurseClass = obj.OPERScrubNurseClass
				s bobj.OPERCirculNurseClass = obj.OPERCirculNurseClass
				s bobj.OPERType = obj.OPERType
				s bobj.OPERRegType = obj.OPERRegType
				s bobj.OPERUpdateDate =obj.OPERUpdateDate
				s bobj.OPERUpdateTime =obj.OPERUpdateTime
				s bobj.OPERIsUploadCode = obj.OPERIsUploadCode
				s bobj.OPERTechnique = obj.OPERTechnique
				s bobj.OPERMedicalTechniqueLevel = obj.OPERMedicalTechniqueLevel
				s bobj.OPERIsSpecial = obj.OPERIsSpecial
				s bobj.OPERIsHighRisk = obj.OPERIsHighRisk
				s bobj.OPERIsAudit = obj.OPERIsAudit
				s bobj.OPERIsPacs = obj.OPERIsPacs
				s bobj.OPERIsSupplierPreparation = obj.OPERIsSupplierPreparation
				s bobj.OPERIsProtectiveAntibacterial = obj.OPERIsProtectiveAntibacterial
				s bobj.OPERApplyFeature = obj.OPERApplyFeature
				s bobj.OPERHospitalDr = obj.OPERHospitalDr  //医院Id(|分割)
				s bobj.OPERAbbreviation = obj.OPERAbbreviation
				
				set PropObj=##class(%Dictionary.PropertyDefinition).%OpenId("User.ORCOperationExtend||OPERBDPOperationCategoryDR",0)
				i $IsObject(PropObj)
				{
					s:obj.OPERBDPOperationCategoryDR'="" bobj.OPERBDPOperationCategoryDR=obj.OPERBDPOperationCategoryDR.%Id()
				}
				s bobj.OPERIsMinInvasive = obj.OPERIsMinInvasive
				s bobj.OPERIsSubOperation = obj.OPERIsSubOperation  /// 是否子手术
				s bobj.OPERIsRestrictedTechnology = obj.OPERIsRestrictedTechnology   /// 是否限制类技术
				s bobj.OPERIsNewItem = obj.OPERIsNewItem  /// 是否新项目新技术
				
			}
		
			
			d:eobj.OPERClassDr'="" obj.OPERClassDrSetObjectId(eobj.OPERClassDr)
			d:eobj.OPERClassDr="" obj.OPERClassDrSetObjectId("")
			d:eobj.OPERBladeDr'="" obj.OPERBladeDrSetObjectId(eobj.OPERBladeDr)
			d:eobj.OPERBladeDr="" obj.OPERBladeDrSetObjectId("")
			d:eobj.OPERBodySiteDr'="" obj.OPERBodySiteDrSetObjectId(eobj.OPERBodySiteDr)
			d:eobj.OPERBodySiteDr="" obj.OPERBodySiteDrSetObjectId("")
			d:eobj.OPEROperPositionDr'="" obj.OPEROperPositionDrSetObjectId(eobj.OPEROperPositionDr)
			d:eobj.OPEROperPositionDr="" obj.OPEROperPositionDrSetObjectId("")
			d:eobj.OPERDefaultOperLocDr'="" obj.OPERDefaultOperLocDrSetObjectId(eobj.OPERDefaultOperLocDr)
			d:eobj.OPERDefaultOperLocDr="" obj.OPERDefaultOperLocDrSetObjectId("")
			d:eobj.OPERCategoryDr'="" obj.OPERCategoryDrSetObjectId(eobj.OPERCategoryDr)
			d:eobj.OPERCategoryDr="" obj.OPERCategoryDrSetObjectId("")	
		
			if $d(%session) d obj.OPERUpdateUserDrSetObjectId($g(%session.Data("LOGON.USERID")))
		
			s obj.OPERSurgeonDeptDr = eobj.OPERSurgeonDeptDr  //手术医生科室Id(|分割)
			s obj.OPERIsKeyOperation = eobj.OPERIsKeyOperation
			s obj.OPERScrubNurseClass = eobj.OPERScrubNurseClass
			s obj.OPERCirculNurseClass = eobj.OPERCirculNurseClass
			s obj.OPERType = eobj.OPERType
			s obj.OPERRegType = eobj.OPERRegType
			s obj.OPERUpdateDate = +$h
			s obj.OPERUpdateTime = $p($h,",",2)
			s obj.OPERIsUploadCode = eobj.OPERIsUploadCode
			s obj.OPERTechnique = eobj.OPERTechnique
			s obj.OPERMedicalTechniqueLevel = eobj.OPERMedicalTechniqueLevel
			s obj.OPERIsSpecial = eobj.OPERIsSpecial
			s obj.OPERIsHighRisk = eobj.OPERIsHighRisk
			s obj.OPERIsAudit = eobj.OPERIsAudit
			s obj.OPERIsPacs = eobj.OPERIsPacs
			s obj.OPERIsSupplierPreparation = eobj.OPERIsSupplierPreparation
			s obj.OPERIsProtectiveAntibacterial = eobj.OPERIsProtectiveAntibacterial
			s obj.OPERApplyFeature = eobj.OPERApplyFeature
				
			s obj.OPERHospitalDr = eobj.OPERHospitalDr  //医院Id(|分割)
			s obj.OPERAbbreviation = eobj.OPERAbbreviation
			set PropObj=##class(%Dictionary.PropertyDefinition).%OpenId("User.ORCOperationExtend||OPERBDPOperationCategoryDR",0)
			i $IsObject(PropObj)
			{
				d:eobj.OPERBDPOperationCategoryDR'="" obj.OPERBDPOperationCategoryDRSetObjectId(eobj.OPERBDPOperationCategoryDR)
				d:eobj.OPERBDPOperationCategoryDR="" obj.OPERBDPOperationCategoryDRSetObjectId("")
			}
			s OPERDesc=$p($G(^ORC("OPER",eobj.OPERERowId)),"^",2)
			s obj.OPERIsMinInvasive = eobj.OPERIsMinInvasive  //是否微创手术
			s obj.OPERIsSubOperation = eobj.OPERIsSubOperation  /// 是否子手术
			s obj.OPERIsRestrictedTechnology = eobj.OPERIsRestrictedTechnology   /// 是否限制类技术
			s obj.OPERIsNewItem = eobj.OPERIsNewItem  /// 是否新项目新技术
			Tstart
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc){
				Tcommit
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"
				d:eobj.OPERERowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_OperationExtend","User.ORCOperationExtend","手术/过程扩展表",id,OPERDesc,"A",eobj)
				d:eobj.OPERERowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_OperationExtend","User.ORCOperationExtend","手术/过程扩展表",id,OPERDesc,"U",eobj,bobj)
			}else{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术/过程扩展表","web.DHCBL.CT.ORCOperationExtend","SaveEntity",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		
		}
		else
		{
			s result = "{success:'false',errorinfo:'对象不存在！'}"
		}	
	}
	else
	{
		s result = "{success:'true'}"
	}
	q result
}

/// Creator:陈莹
/// CreatDate:2016-7-11
/// Description:为combobox查询取数据
/// Table:User.DHCANCOperationCat
/// Input:code,desc
/// Return:ID,ANCOCCode,ANCOCDesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperationExtend","GetDataForANCOperCat","","","")
Query GetDataForANCOperCat(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ANCOCRowId:%String,ANCOCCode:%String,ANCOCDesc:%String")
{
}

ClassMethod GetDataForANCOperCatExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s ANCOCRowId=rowid
		s ANCOCCode=$LISTGET($G(^DHCANC("OperationCat",ANCOCRowId)),1)
		s ANCOCDesc=$LISTGET($G(^DHCANC("OperationCat",ANCOCRowId)),2)	
		d OutputRowCat
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s AuStr="" ;##class(web.DHCBL.Authorize.DHCANCOperationCat).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s ANCOCRowId=0
		for
		{
			s ANCOCRowId=$o(^DHCANC("OperationCat",ANCOCRowId)) q:ANCOCRowId=""
			s strRowId="{ID:"_ANCOCRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				s ANCOCCode=$LISTGET($G(^DHCANC("OperationCat",ANCOCRowId)),1)
				s ANCOCDesc=$LISTGET($G(^DHCANC("OperationCat",ANCOCRowId)),2)
				s PINYIN=""
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(ANCOCDesc)
				i ($ZCONVERT(ANCOCCode,"U")[code)&(($ZCONVERT(ANCOCDesc,"U")[desc)||(PINYIN[desc))
				{
					d OutputRowCat
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCat
    set Data=$lb(ANCOCRowId,ANCOCCode,ANCOCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForANCOperCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForANCOperCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataForANCOperCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForANCOperCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2016-7-11
/// Description:双击修改时,从后台取数据
/// Table:User.ORCOperationExtend
/// Input:id（OPERERowId）
/// Return:Json格式的字符串str={list:[CTCITCode,CTCITDesc,CTCITProvinceDR,CTCITDateFrom,CTCITDateTo,CTCITRowId]}
/// Other:w ##class(web.DHCBL.CT.ORCOperationExtend).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	
	q:id="" ""	
	s str=""
	s flag= ##class(web.DHCBL.CT.ORCOperationExtend).IsValidClassName("User.ORCOperationExtend")
	if (flag=1)
	{
		s pobj = ##class(User.ORCOperationExtend).%OpenId(id)
		s eobj = ##class(web.Entity.CT.ORCOperationExtend).%New()
	
		s eobj.OPERERowId = id
		if $IsObject(pobj.OPERClassDr){
			s eobj.OPERClassDr = pobj.OPERClassDr.%Id() 
		}	
		if $IsObject(pobj.OPERBladeDr){
			s eobj.OPERBladeDr = pobj.OPERBladeDr.%Id() 
		}
		if $IsObject(pobj.OPERBodySiteDr){
			s eobj.OPERBodySiteDr = pobj.OPERBodySiteDr.%Id() 
		}
		if $IsObject(pobj.OPEROperPositionDr){
			s eobj.OPEROperPositionDr = pobj.OPEROperPositionDr.%Id() 
		}
		if $IsObject(pobj.OPERDefaultOperLocDr){
			s eobj.OPERDefaultOperLocDr = pobj.OPERDefaultOperLocDr.%Id() 
		}
		if $IsObject(pobj.OPERCategoryDr){
			s eobj.OPERCategoryDr = pobj.OPERCategoryDr.%Id() 
		}
	
		s eobj.OPERSurgeonDeptDr = pobj.OPERSurgeonDeptDr  //手术医生科室Id(|分割)
		
		
		
		
		S OPERSurgeonDeptDrDesc=""
		if (pobj.OPERSurgeonDeptDr'="")
		{
			s Length=$l(pobj.OPERSurgeonDeptDr,"|")
			if Length>0
			{
				for i=1:1:Length
				{
					s LocID=$P(pobj.OPERSurgeonDeptDr,"|",i)
					s LocDesc=""
					if LocID'="" s LocDesc=$p($G(^CTLOC(LocID)),"^",2)
					
					if OPERSurgeonDeptDrDesc'="" 
					{
						S OPERSurgeonDeptDrDesc=OPERSurgeonDeptDrDesc_","_LocDesc
					}
					else
					{
						S OPERSurgeonDeptDrDesc=LocDesc
					}
					
				}
			}
			
		}
		s eobj.OPERSurgeonDeptDrDesc =OPERSurgeonDeptDrDesc
		
		s eobj.OPERIsKeyOperation = pobj.OPERIsKeyOperation
		s eobj.OPERScrubNurseClass = pobj.OPERScrubNurseClass
		s eobj.OPERCirculNurseClass = pobj.OPERCirculNurseClass
		s eobj.OPERType = pobj.OPERType
		s eobj.OPERRegType = pobj.OPERRegType
		s eobj.OPERIsUploadCode = pobj.OPERIsUploadCode
		s eobj.OPERTechnique = pobj.OPERTechnique
		s eobj.OPERMedicalTechniqueLevel = pobj.OPERMedicalTechniqueLevel
		s eobj.OPERIsSpecial = pobj.OPERIsSpecial
		s eobj.OPERIsHighRisk = pobj.OPERIsHighRisk
		s eobj.OPERIsAudit = pobj.OPERIsAudit
		s eobj.OPERIsPacs = pobj.OPERIsPacs
		s eobj.OPERIsSupplierPreparation =pobj.OPERIsSupplierPreparation
		s eobj.OPERIsProtectiveAntibacterial = pobj.OPERIsProtectiveAntibacterial
		s eobj.OPERApplyFeature = pobj.OPERApplyFeature
		s eobj.OPERHospitalDr = pobj.OPERHospitalDr  //医院Id(|分割)
		s eobj.OPERIsMinInvasive = pobj.OPERIsMinInvasive
		s eobj.OPERIsSubOperation = pobj.OPERIsSubOperation  /// 是否子手术
		s eobj.OPERIsRestrictedTechnology = pobj.OPERIsRestrictedTechnology   /// 是否限制类技术
		s eobj.OPERIsNewItem = pobj.OPERIsNewItem  /// 是否新项目新技术
		S OPERHospitalDrDesc=""
		if (pobj.OPERHospitalDr'="")
		{
			s Length=$l(pobj.OPERHospitalDr,"|")
			if Length>0
			{
				for i=1:1:Length
				{
					s HOSPID=$P(pobj.OPERHospitalDr,"|",i)
					s HOSPDesc=""
					if HOSPID'="" s HOSPDesc=$p($g(^CT("HOSP",HOSPID)),"^",2)
					
					if OPERHospitalDrDesc'="" 
					{
						S OPERHospitalDrDesc=OPERHospitalDrDesc_","_HOSPDesc
					}
					else
					{
						S OPERHospitalDrDesc=HOSPDesc
					}
					
				}
			}
			
		}
		s eobj.OPERHospitalDrDesc =OPERHospitalDrDesc		
		s eobj.OPERAbbreviation = pobj.OPERAbbreviation
		s:pobj.OPERIsKeyOperation="Y" eobj.OPERIsKeyOperation="true"
		s:pobj.OPERIsUploadCode="Y" eobj.OPERIsUploadCode="true"
		s:pobj.OPERIsSpecial="Y" eobj.OPERIsSpecial="true"
		s:pobj.OPERIsHighRisk="Y" eobj.OPERIsHighRisk="true"
		s:pobj.OPERIsAudit="Y" eobj.OPERIsAudit="true"
		s:pobj.OPERIsPacs="Y" eobj.OPERIsPacs="true"
		s:pobj.OPERIsSupplierPreparation="Y" eobj.OPERIsSupplierPreparation="true"
		s:pobj.OPERIsProtectiveAntibacterial="Y" eobj.OPERIsProtectiveAntibacterial="true"
		s:pobj2.OPERIsSupplierPreparation="1" eobj2.OPERIsSupplierPreparation="true"
		s:pobj2.OPERIsProtectiveAntibacterial="1" eobj2.OPERIsProtectiveAntibacterial="true"
		s:pobj.OPERIsMinInvasive="Y" eobj.OPERIsMinInvasive="true"
		s:pobj.OPERIsSubOperation="Y" eobj.OPERIsSubOperation="true"  /// 是否子手术
		s:pobj.OPERIsRestrictedTechnology="Y" eobj.OPERIsRestrictedTechnology="true"   /// 是否限制类技术
		s:pobj.OPERIsNewItem="Y" eobj.OPERIsNewItem="true"  /// 是否新项目新技术
		s eobj.OPERApplyFeature = pobj.OPERApplyFeature
		d pobj.%Close()
		k pobj
		s str = eobj.JsonS()
		s str = "{list:["_str_"]}"
	}
	q str
}

/// Creator:chenying
/// Date:2016-7-17
/// Description：查询未选科室的列表内容
/// Table：User.CTLoc
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperationExtend","GetUnSelCTLocList","34")
Query GetUnSelCTLocList(operrowid As %String, LocStr As %String, desc As %String) As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,SaveFlag")
{
}

ClassMethod GetUnSelCTLocListExecute(ByRef qHandle As %Binary, operrowid As %String, LocStr As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	S:desc'="" desc=$zcvt(desc,"U")
	if (operrowid'="")
	{
		s OPERSurgeonDeptDr=$p($g(^ORC("OPER",operrowid,"DHC")),"^",6)  //手术医生科室Id(|分割)
		S Length=0
		if OPERSurgeonDeptDr'="" S Length=$l(OPERSurgeonDeptDr,"|")
		if Length>0
		{
			for i=1:1:Length
			{
				s rowid=$p(OPERSurgeonDeptDr,"|",i)
				s arrCTLOC(rowid)=i
			}
		}
		//s AuStr=""
		//获取授权Json
		s AuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
		s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		s AuRBCDepartmentGroupStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
		s AuCTHospitalStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
	
	
		;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
		;假设未授权情况下默认全部显示数据
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s AuRBCDepartmentGroupFlag=0
		if (AuRBCDepartmentGroupStr="")||(AuRBCDepartmentGroupStr["limited:0") s AuRBCDepartmentGroupFlag=1
		s AuCTHospitalFlag=0
		if (AuCTHospitalStr="")||(AuCTHospitalStr["limited:0") s AuCTHospitalFlag=1
	
		s CTLOCRowID=0
		for  
		{
			s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
			s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期
            continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
                
			///判断是否已选 已选则跳过
			if $d(arrCTLOC(CTLOCRowID))=1 continue
			s SaveFlag="N"
			
			
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22) 	//医院
			s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)		//科室部分组 
			
			s strRowId = "{ID:"_CTLOCRowID_"}"
			s strCTLOCDepDR = "{ID:"_CTLOCDepDR_"}"
			s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
			i ((AuStr[strRowId)||(AuFlag=1))&&((AuRBCDepartmentGroupStr[strCTLOCDepDR)||(AuRBCDepartmentGroupFlag=1))&&((AuCTHospitalStr[strHospitalID)||(AuCTHospitalFlag=1))&&((AuHospStr="off")||(AuHospStr[strHospitalID)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)   ;_"【北京地坛医院】" "<font color=""#FF0000""> 北京地坛医院</font>"      //用户名
				s CTLOCDescB=$ZCONVERT(CTLOCDesc,"U")
				s Desc="<"_CTLOCDesc_">"
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Loc",CTLOCRowID,AliasRowId))
					q:AliasRowId=""
					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN=""
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDescB)
				i ((CTLOCDescB[desc)||(PINYIN[desc)||(ALIASText1[desc))&('(LocStr[Desc))
				{
					d OutputRowUn
				}
			}
		}
	
	}
	else
	{
		//s AuStr=""
		//获取授权Json
		s AuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
		s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		s AuRBCDepartmentGroupStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
		s AuCTHospitalStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
	
	
		;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
		;假设未授权情况下默认全部显示数据
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s AuRBCDepartmentGroupFlag=0
		if (AuRBCDepartmentGroupStr="")||(AuRBCDepartmentGroupStr["limited:0") s AuRBCDepartmentGroupFlag=1
		s AuCTHospitalFlag=0
		if (AuCTHospitalStr="")||(AuCTHospitalStr["limited:0") s AuCTHospitalFlag=1
	
		s CTLOCRowID=0
		for  
		{
			s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
			s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期
            continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
                
			s SaveFlag="N"	
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22) 	//医院
			s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)		//科室部分组 
			
			s strRowId = "{ID:"_CTLOCRowID_"}"
			s strCTLOCDepDR = "{ID:"_CTLOCDepDR_"}"
			s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
			i ((AuStr[strRowId)||(AuFlag=1))&&((AuRBCDepartmentGroupStr[strCTLOCDepDR)||(AuRBCDepartmentGroupFlag=1))&&((AuCTHospitalStr[strHospitalID)||(AuCTHospitalFlag=1))&&((AuHospStr="off")||(AuHospStr[strHospitalID)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)   ;_"【北京地坛医院】" "<font color=""#FF0000""> 北京地坛医院</font>"      //用户名
				s CTLOCDescB=$ZCONVERT(CTLOCDesc,"U")
				s Desc="<"_CTLOCDesc_">"
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Loc",CTLOCRowID,AliasRowId))
					q:AliasRowId=""
					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN=""
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDescB)
				i ((CTLOCDescB[desc)||(PINYIN[desc)||(ALIASText1[desc))&('(LocStr[Desc))
				{
					d OutputRowUn
				}
			}
		}
		
		
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUn
    set Data=$lb(CTLOCRowID,CTLOCDesc,SaveFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelCTLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelCTLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUnSelCTLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelCTLocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:chenying
/// Date:2016-7-17
/// 查询手术扩展表里科室已选列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperationExtend","GetSelCTLocList","37")
Query GetSelCTLocList(operrowid, desc) As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,SaveFlag")
{
}

ClassMethod GetSelCTLocListExecute(ByRef qHandle As %Binary, operrowid, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	S:desc'="" desc=$zcvt(desc,"U")
	if (operrowid'="")
	{
		s OPERSurgeonDeptDr=$p($g(^ORC("OPER",operrowid,"DHC")),"^",6)  //手术医生科室Id(|分割)
		S Length=0
		if OPERSurgeonDeptDr'="" S Length=$l(OPERSurgeonDeptDr,"|")
		if Length>0
		{
			for i=1:1:Length
			{
				s rowid=$p(OPERSurgeonDeptDr,"|",i)
				s arrCTLOC(rowid)=i
			}
		}
		//s AuStr=""
		//获取授权Json
		s AuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
		s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		s AuRBCDepartmentGroupStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
		s AuCTHospitalStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
	
	
		;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
		;假设未授权情况下默认全部显示数据
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s AuRBCDepartmentGroupFlag=0
		if (AuRBCDepartmentGroupStr="")||(AuRBCDepartmentGroupStr["limited:0") s AuRBCDepartmentGroupFlag=1
		s AuCTHospitalFlag=0
		if (AuCTHospitalStr="")||(AuCTHospitalStr["limited:0") s AuCTHospitalFlag=1
	
		s CTLOCRowID=0
		for  
		{
			s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
			s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期
            continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
                
			
			//判断是否未选  未选则跳过
			if $d(arrCTLOC(CTLOCRowID))=0 continue
			S SaveFlag="Y"
			
			s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22) 	//医院
			s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)		//科室部分组 
			
			s strRowId = "{ID:"_CTLOCRowID_"}"
			s strCTLOCDepDR = "{ID:"_CTLOCDepDR_"}"
			s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
			i ((AuStr[strRowId)||(AuFlag=1))&&((AuRBCDepartmentGroupStr[strCTLOCDepDR)||(AuRBCDepartmentGroupFlag=1))&&((AuCTHospitalStr[strHospitalID)||(AuCTHospitalFlag=1))&&((AuHospStr="off")||(AuHospStr[strHospitalID)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)   ;_"【北京地坛医院】" "<font color=""#FF0000""> 北京地坛医院</font>"      //用户名
				s CTLOCDescB=$ZCONVERT(CTLOCDesc,"U")
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Loc",CTLOCRowID,AliasRowId))
					q:AliasRowId=""
					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				
				s PINYIN=""
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDescB)
				i ((CTLOCDescB[desc)||(PINYIN[desc)||(ALIASText1[desc))
				{
					d OutputRowCTLoc
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCTLoc
    set Data=$lb(CTLOCRowID,CTLOCDesc,SaveFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSelCTLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSelCTLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSelCTLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSelCTLocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:chenying
/// Date:2016-7-17
/// Description：查询医院字典的列表内容
/// Table：User.CTHospital
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperationExtend","GetUnSelHOSPList","34","","")
Query GetUnSelHOSPList(operrowid As %String, HospStr, desc As %String) As %Query(ROWSPEC = "HOSPRowId:%String,HOSPDesc:%String,SaveFlag")
{
}

ClassMethod GetUnSelHOSPListExecute(ByRef qHandle As %Binary, operrowid As %String, HospStr, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	S:desc'="" desc=$zcvt(desc,"U")
	if (operrowid'="")
	{
		s OPERHospitalDr=$p($g(^ORC("OPER",operrowid,"DHC")),"^",24)  //医院Id(|分割)
		S Length=0
		if OPERHospitalDr'="" S Length=$l(OPERHospitalDr,"|")
		if Length>0
		{
			for i=1:1:Length
			{
				s rowid=$p(OPERHospitalDr,"|",i)
				s arrHOSP(rowid)=i
			}
		}
		
		//获取授权Json
		s AuStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
		;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
		;假设未授权情况下默认全部显示数据
		s AuFlag=0
		if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
		s HOSPRowId=0
		for  
		{	
			s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""
			s HOSPDateTo=$p($g(^CT("HOSP",HOSPRowId)),"^",10)
			continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h)
			//判断是否已选 已选则跳过
			if $d(arrHOSP(HOSPRowId))=1 continue
			S SaveFlag="N"
			
			s strRowId = "{ID:"_HOSPRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
				s Desc="<"_HOSPDesc_">"
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Hospital",HOSPRowId,AliasRowId))
					q:AliasRowId=""
					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN=""
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(HOSPDesc)
				i (($zcvt(HOSPDesc,"U")[desc)||(ALIASText1[desc)||(PINYIN[desc))&('(HospStr[Desc))
				{
					d OutputRowUnHOSP
					
				}
			}
		}
	
	}
	else
	{
		
		//获取授权Json
		s AuStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
		;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
		;假设未授权情况下默认全部显示数据
		s AuFlag=0
		if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
		s HOSPRowId=0
		for  
		{	
			s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""
			s HOSPDateTo=$p($g(^CT("HOSP",HOSPRowId)),"^",10)
			continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h)
			S SaveFlag="N"
			
			s strRowId = "{ID:"_HOSPRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
				s Desc="<"_HOSPDesc_">"
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Hospital",HOSPRowId,AliasRowId))
					q:AliasRowId=""
					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN=""
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(HOSPDesc)
				i (($zcvt(HOSPDesc,"U")[desc)||(ALIASText1[desc)||(PINYIN[desc))&('(HospStr[Desc))
				{
					d OutputRowUnHOSP
					
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUnHOSP
    set Data=$lb(HOSPRowId,HOSPDesc,SaveFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelHOSPListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelHOSPListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUnSelHOSPListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelHOSPListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:chenying
/// Date:2016-7-17
/// 查询扩展表中 医院已选列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperationExtend","GetSelHOSPList","37")
Query GetSelHOSPList(operrowid As %String, desc As %String) As %Query(ROWSPEC = "HOSPRowId:%String,HOSPDesc:%String,SaveFlag")
{
}

ClassMethod GetSelHOSPListExecute(ByRef qHandle As %Binary, operrowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	S:desc'="" desc=$zcvt(desc,"U")
	
	if operrowid'=""
	{
		s OPERHospitalDr=$p($g(^ORC("OPER",operrowid,"DHC")),"^",24)  //医院Id(|分割)
		S Length=0
		if OPERHospitalDr'="" S Length=$l(OPERHospitalDr,"|")
		if Length>0
		{
			for i=1:1:Length
			{
				s rowid=$p(OPERHospitalDr,"|",i)
				s arrHOSP(rowid)=i
			}
		}
		
		//获取授权Json
		s AuStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
		;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
		;假设未授权情况下默认全部显示数据
		s AuFlag=0
		if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
	
		s HOSPRowId=0
		for  
		{	
			s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""
			s HOSPDateTo=$p($g(^CT("HOSP",HOSPRowId)),"^",10)
			continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h)
			//判断是否未选 未选则跳过
			if $d(arrHOSP(HOSPRowId))=0 continue
			S SaveFlag="Y"
			
			s strRowId = "{ID:"_HOSPRowId_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Hospital",HOSPRowId,AliasRowId))
					q:AliasRowId=""
					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}
				s PINYIN=""
				s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(HOSPDesc)
				i (($zcvt(HOSPDesc,"U")[desc)||(ALIASText1[desc)||(PINYIN[desc))
				{
					d OutputRowHOSP
					
				}
			}
		}
	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowHOSP
    set Data=$lb(HOSPRowId,HOSPDesc,SaveFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSelHOSPListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSelHOSPListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSelHOSPListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSelHOSPListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2016-8-11
/// Description:根据科室删除手术/过程扩展表里 手术医生科室里的这个科室值
/// Table:User.ORCOperationExtend 
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.ORCOperationExtend).DeleteLocData("1","12")
ClassMethod DeleteLocData(operrowid As %String, ctlocrowid) As %String
{
	s result=""
	if operrowid'=""
	{
		s OPERHospitalDr=$p($g(^ORC("OPER",operrowid,"DHC")),"^",6)  //医生手术科室Id(|分割)
		s newOPERHospitalDr=""
		s length=$l(OPERHospitalDr,"|")
		for i=1:1:length
		{
		
			s loc=$P(OPERHospitalDr,"|",i)
			if (loc'=ctlocrowid)
			{
				if newOPERHospitalDr="" s newOPERHospitalDr=loc
				else  s newOPERHospitalDr=newOPERHospitalDr_"|"_loc
			
			}
		
		}
		s $p(^ORC("OPER",operrowid,"DHC"),"^",6)=newOPERHospitalDr
		s result="{success:'true',info:'删除成功！'}"
	}
	else
	{
		s result="{success:'false',info:'删除失败！'}"
		
	}
	q result
}

/// Creator:陈莹
/// CreatDate:2016-8-11
/// Description:根据医院删除手术/过程扩展表里 医院里的这个值
/// Table:User.ORCOperationExtend 
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.ORCOperationExtend).DeleteHospData("1","12")
ClassMethod DeleteHospData(operrowid As %String, hosprowid) As %String
{
	s result=""
	if operrowid'=""
	{
		s OPERHospitalDr=$p($g(^ORC("OPER",operrowid,"DHC")),"^",24)  //医院(|分割)
		s newOPERHospitalDr=""
		s length=$l(OPERHospitalDr,"|")
		for i=1:1:length
		{
		
			s hosp=$P(OPERHospitalDr,"|",i)
			if (hosp'=hosprowid)
			{
				if newOPERHospitalDr="" s newOPERHospitalDr=hosp
				else  s newOPERHospitalDr=newOPERHospitalDr_"|"_hosp
			
			}
		
		}
		s $p(^ORC("OPER",operrowid,"DHC"),"^",24)=newOPERHospitalDr
		s result="{success:'true',info:'删除成功！'}"
	}
	else
	{
		s result="{success:'false',info:'删除失败！'}"
		
	}
	q result
}

}
