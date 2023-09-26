Import SQLUser

/// 配置Query
/// 
Class CIS.AN.BL.ConfigQueries Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-1-8
/// Description： 	查询手术间
/// Table：        	OperRoom
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindOperRoom","29")
/// or (b.Link_RowId is not null) or (:filterOperDeptID is null))
/// /	   and ((:locType[LocType) or (:locType is null)
Query FindOperRoom(filterOperDeptID As %String, locType As %String = "", hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
 
  SELECT RowId,Code,CIS_AN_COM.String_GetTranslationByBDP("CF.AN.Location","Description",RowId) As Description,
  	   OperFloor,OperFloor->Description As OperFloorDesc,
	   OperDeptID,CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",OperDeptID) As OperDeptDesc,
	   UseDeptID,CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",UseDeptID) As UseDeptDesc,
	   Active,%EXTERNAL(Active) As ActiveDesc,UnavailableReason,LocType,%EXTERNAL(LocType) As LocTypeDesc,
	   OPClientIP,ANClientIP,DataAttribution
	   from CF_AN.Location as a
	   left join SQLUser.CT_LocLinkLocation as b on b.LINK_ParRef=:filterOperDeptID and a.OperDeptID=b.link_ctloc_dr
	   where ((OperDeptID=:filterOperDeptID) or (:filterOperDeptID is null) or (b.LINK_Childsub is not null))
	   and ((("^"_:locType_"^") [ STRING('^',LocType,'^')) or (:locType is null))
	   and ((:hospId is null) or (a.DataAttribution is null) or (a.DataAttribution->HospitalID=:hospId))
}

/// Creator：      	钟鸣远
/// CreatDate：    	2021-8-6
/// Description： 	查询手术间（系统配置用）
/// Table：        	OperRoom
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindOperRoomConfig","29")
/// or (b.Link_RowId is not null) or (:filterOperDeptID is null))
/// /	   and ((:locType[LocType) or (:locType is null)
Query FindOperRoomConfig(filterOperDeptID As %String, locType As %String = "", hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
 
  SELECT RowId,Code,Description,OperFloor,OperFloor->Description As OperFloorDesc,
	   OperDeptID,CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",OperDeptID) As OperDeptDesc,
	   UseDeptID,CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",UseDeptID) As UseDeptDesc,
	   Active,%EXTERNAL(Active) As ActiveDesc,UnavailableReason,LocType,%EXTERNAL(LocType) As LocTypeDesc,
	   OPClientIP,ANClientIP,DataAttribution
	   from CF_AN.Location as a
	   left join SQLUser.CT_LocLinkLocation as b on b.LINK_ParRef=:filterOperDeptID and a.OperDeptID=b.link_ctloc_dr
	   where ((OperDeptID=:filterOperDeptID) or (:filterOperDeptID is null) or (b.LINK_Childsub is not null))
	   and ((("^"_:locType_"^") [ STRING('^',LocType,'^')) or (:locType is null)) 
	   and ((:hospId is null) or (a.DataAttribution is null) or (a.DataAttribution->HospitalID=:hospId))
}

/// Creator：      	陈长青
/// CreatDate：    	2017-05-15
/// Description： 	查询检验标准码对照项目
/// Table：        	DHCAN.TestStandardCode
/// Input:			active:是否激活
/// Return：       	DataField:检验标准码对应的手术麻醉数据字段
/// 					TestCode:检验标准代码
/// 					Active:对照项目激活状态代码，ActiveDesc:对照项目激活状态名称
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQuery","FindTestStandardCode","Y")
Query FindTestCode(active As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,DataField,StandardCode,%External(Active) As ActiveDesc,Active 
from CF_AN.TestCode
where (Active=:active) or (:active is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-10
/// Description： 	查询模块授权信息
/// Table：        	ModulePermission
/// Input:			filterGroupID:查询安全组授权的模块信息
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQuery","FindModulePermission","32")
Query FindModulePermission(filterGroupID As %String, needActive As %String = "N") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   GroupID,
	   DataModule,
	   DataModule->Description As DataModuleDesc,
	   DataModule->Code As DataModuleCode,
	   DataModule->URL As Url,
	   DataModule->Icon As Icon,
	   DataModule->ParentModule As ParentModule,
	   DataModule->ParentModule->Description As ParentModuleDesc,
	   Active,
	   %External(Active) As ActiveDesc
	   from CF_AN.ModulePermission 
	   where ((GroupID=:filterGroupID) or (:filterGroupID is null))
	   and ((Active="Y") or (:needActive="N") )
	   and not DataModule->Code is null
	   order by DataModule->SeqNo
}

/// Creator：      	陈长青
/// CreatDate：    	2017-2-21
/// Description： 	手术麻醉系统配置
/// Table：        	DHCAN.DataConfiguration
/// Input:			key:配置项的键值
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindDataConfigurations","IPDefOPDept","")
Query FindDataConfigurations(key As %String, moduleId As %String = "", hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT * 
	   from CF_AN.DataConfig
	   where ((DataKey=:key) or (:key is null))
	   and ((DataModule=:moduleId) or (:moduleId is null))
	   and ((:hospId is null) or (DataAttribution is null) or (DataAttribution->HospitalID=:hospId))
}

/// Creator：      	陈长青
/// CreatDate：    	2017-2-22
/// Description： 	查询医护人员关联手术名称
/// Table：        	DHCAN.CareProviderOperation
/// Input:			deptID:科室ID，careprovID：医护人员ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindSurgeonOperations","53","")
Query FindSurgeonOperations(careprovID As %String = "", deptID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   Surgeon,
	   CIS_AN_COM.String_GetDescByID("User.CTCareProv","CTPCPDesc",Surgeon) As SurgeonDesc,
	   Operation,
	   CIS_AN_COM.String_GetDescBySQL('SQLUser.ORC_Operation','OPER_DefaultCategory_DR->CATEG_Desc',Operation) As OperClassDesc,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperation','OPERDesc',Operation) As OperationDesc,
	   %ODBCOUT(ActiveDate) As ActiveDate,
	   %ODBCOUT(ExpireDate) As ExpireDate,
	   SurgeonDept,
	   CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",SurgeonDept) As SurgeonDeptDesc
	   from CF_AN.SurgeonOperation
	   where ((SurgeonDept=:deptID) or (:deptID is null))
	   and ((Surgeon=:careprovID) or (:careprovID is null))
}

/// Creator：      	陈长青
/// CreatDate：    	2017-2-22
/// Description： 	查询科室关联手术名称
/// Table：        	DHCAN.DeptOperation
/// Input:			deptID:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindDeptOperations","113")
Query FindDeptOperations(deptID As %String, operClass As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   Operation,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperation','OPERDesc',Operation) As OperationDesc,
	   CIS_AN_COM.String_GetDescBySQL('SQLUser.ORC_Operation','OPER_DefaultCategory_DR',Operation) As OperClass,
	   CIS_AN_COM.String_GetDescBySQL('SQLUser.ORC_Operation','OPER_DefaultCategory_DR->CATEG_Desc',Operation) As OperClassDesc,
	   %ODBCOUT(ActiveDate) As ActiveDate,
	   %ODBCOUT(ExpireDate) As ExpireDate,
	   DeptID,
	   CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",DeptID) As DeptDesc
	   from CF_AN.DeptOperation
	   where (((DeptID=:deptID)and ((CIS_AN_COM.String_GetDescBySQL('SQLUser.ORC_Operation','OPER_DefaultCategory_DR->CATEG_Desc',Operation)=:operClass) or (:operClass is null))) or (:deptID is null))
}

/// Creator：      	杨勤
/// CreatDate：    	2017-07-11
/// Description： 	查询手术状态授权
/// Table：        	DHCAN.ActionPermission
/// Input:			filterGroupId:安全组，operStatus:手术状态，needActive:是否激活
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindActionPermission","51","59","Y")
Query FindActionPermission(filterGroupID As %String, dataModuleID As %String = "", needActive As %String = "N", container As %String = "", relateModule As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   GroupID,
	   OperStatus,
	   CIS_AN_COM.String_GetDescByIDStr("CT.AN.OperStatus","Code",OperStatus,",") As OperStatusCode,
	   CIS_AN_COM.String_GetDescByIDStr("CT.AN.OperStatus","Description",OperStatus,",") As OperStatusDesc,
	   OperAction,
	   OperAction->RowId As OperActionRowId,
	   OperAction->Code As OperActionCode,
	   OperAction->Description As OperActionDesc,
	   OperAction->ElementID As ElementID,
	   OperAction->Icon As Icon,
	   OperAction->ExecFunc As ExecFunc,
	   OperAction->DataModule As DataModule,
	   OperAction->DataModule->Description As DataModuleDesc,
	   OperAction->LinkModule As LinkModule,
	   OperAction->LinkModule->Description As LinkModuleDesc,
	   OperAction->LinkModule->URL As LinkModuleUrl,
	   Active,
	   %External(Active) As ActiveDesc   
	   from CF_AN.ActionPermission
	   where ((GroupID=:filterGroupID))
	   and ((Active="Y") or (:needActive="N"))
	   and ((OperAction->DataModule=:dataModuleID) or (OperAction->DataModule=:relateModule) or (:dataModuleID is null) )
	   and ((OperAction->Container=:container) or (:container is null))
	   order by OperAction->Seq
}

/// Creator：      	杨勤
/// CreatDate：    	2017-07-11
/// Description： 	查询手术状态授权
/// Table：        	DHCAN.ActionPermission
/// Input:			filterGroupId:安全组，operStatus:手术状态，needActive:是否激活
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindActionPermission","53","107","Y","actionList")
Query FindActionPermissionNew(filterGroupID As %String, dataModuleID As %String = "", needActive As %String = "N", container As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT b.RowId As RowId,
	   a.RowId As OperAction,
	   a.RowId As OperActionRowId,
	   Code,
	   Description,
	   ElementID,
	   DataModule,
	   DataModule->Description As DataModuleDesc,
	   LinkModule,
	   LinkModule->Description As LinkModuleDesc,
	   LinkModule->URL As LinkModuleUrl,
	   Icon,
	   ExecFunc,
	   GroupID,
	   OperStatus,
	   CIS_AN_COM.String_GetDescByIDStr("CT.AN.OperStatus","Code",OperStatus,",") As OperStatusCode,
	   CIS_AN_COM.String_GetDescByIDStr("CT.AN.OperStatus","Description",OperStatus,",") As OperStatusDesc,
	   OperAction->Code As OperActionCode,
	   OperAction->Description As OperActionDesc,
	   Active,
	   %External(Active) As ActiveDesc   
	   from (select * from CF_AN.ActionPermission where (GroupID=:filterGroupID) and ((Active="Y") or (:needActive="N"))) As b right join CT_AN.OperAction As a  on a.RowId=b.OperAction
	   where ((DataModule=:dataModuleID) or (:dataModuleID is null))
	   and ((Container=:container) or (:container is null))
}

/// Creator：      	chenchangqing
/// CreatDate：    	2018-05-10
/// Description： 	查询科室设备
/// Table：        	DHCAN.DeptEquip
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindDeptEquip","")
Query FindDeptEquip(deptId As %String, loc As %String = "", equipType As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT *,
		   Location->Description As LocDesc,
		   Location->LocType As LocType,
		   EquipModel->Description As EquipModelDesc,
		   EquipModel->Manufacturer->Description As ManufacturerDesc,
		   EquipModel->Manufacturer As Manufacturer,
		   EquipModel->EQType->Description As EquipTypeDesc,
		   EquipModel->EQType As EquipType,
	   	   CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",Dept) As DeptDesc
		   from CF_AN.DeptEquip
		   where (Dept=:deptId or :deptId is null)
		   and (Location=:loc or :loc is null)
		   and (EquipModel->EQType=:equipType or :equipType is null)
		   order by Location->Description
}

/// Creator：      	yongyang
/// CreatDate：    	2018-08-13
/// Description： 	查询科室设备
/// Table：        	CF.AN.DeptEquip,CF.AN.EquipCollection
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindDeptEquipAN","14")
Query FindDeptEquipAN(deptId As %String, loc As %String = "", equipType As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT *,
		   a.RowId As RowId,
		   Location->Description As LocDesc,
		   EquipModel->Description As EquipModelDesc,
		   EquipModel->Manufacturer->Description As ManufacturerDesc,
		   EquipModel->EQType->Description As EquipType,
		   b.RowId As CollectionRowId,
		   Equip As CollectionEquip,
		   Program As Program,
		   ComPort As ComPort,
		   PhysicalPort As PhysicalPort,
		   TcpipAddress As TcpipAddress
		   from CF_AN.DeptEquip As a
		   left join CF_AN.EquipCollection As b
		   on b.Equip = a.RowId
		   where Dept=:deptId
		   and (Location=:loc or :loc is null)
		   and (EquipModel->EQType=:equipType or :equipType is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2017-2-22
/// Description： 	查询职称关联手术分级
/// Table：        	DHCAN.CPTypeOperClass
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindCPTypeOperClass")
Query FindCPTypeOperClass() As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   CPTypeID,
	   CIS_AN_COM.String_GetDescByID("User.CTCarPrvTp","CTCPTDesc",CPTypeID) As CPTypeDesc,
	   OperClass,
	   CIS_AN_COM.String_GetDescByID("User.ORCOperationCategory","CATEGDesc",OperClass) As OperClassDesc
	   from CF_AN.CPTypeOperClass
}

/// Creator：      	雍阳
/// CreatDate：    	2018-8-2
/// Description： 	查询恢复床位
/// Table：        	CF_AN.Location
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindPACUBed")
Query FindPACUBed() As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,Code,Description,OperFloor,OperFloor->Description As OperFloorDesc,
	   OperDeptID,CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCCode",OperDeptID) As OperDeptDesc,
	   UseDeptID,CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCCode",UseDeptID) As UseDeptDesc,
	   Active,%EXTERNAL(Active) As ActiveDesc,UnavailableReason,LocType,%EXTERNAL(LocType) As LocTypeDesc
	   from CF_AN.Location
	   where (LocType="B")
}

/// Creator：      	雍阳
/// CreatDate：    	2018-8-24
/// Description： 	查询自费药品
/// Table：        	CF_AN.SelfPaidDrug
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindSelfPaidDrug","1")
Query FindSelfPaidDrug(deptId As %String, returnAll As %String = "N") As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	Upper(Alias) As Alias,
	%ODBCOUT(StartDate) As StartDate,
	%ODBCOUT(StartTime) As StartTime,
	%ODBCOUT(StartDate)_" "_%ODBCOUT(StartTime) As StartDT,
	%ODBCOUT(EndDate) As EndDate,
	%ODBCOUT(EndTime) As EndTime,
	%ODBCOUT(EndDate)_" "_%ODBCOUT(EndTime) As EndDT
	from CF_AN.SelfPaidDrug
	where (DeptID=:deptId) 
	and ((StartDate<=+$H and (EndDate is null or EndDate >= +$H)) or (:returnAll="Y"))
}

/// Creator：      	雍阳
/// CreatDate：    	2018-8-27
/// Description： 	查询自费材料
/// Table：        	CF_AN.SelfPaidMaterial
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindSelfPaidMaterial","1")
Query FindSelfPaidMaterial(deptId As %String, returnAll As %String = "N") As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	Upper(Alias) As Alias,
	%ODBCOUT(StartDate) As StartDate,
	%ODBCOUT(StartTime) As StartTime,
	%ODBCOUT(StartDate)_" "_%ODBCOUT(StartTime) As StartDT,
	%ODBCOUT(EndDate) As EndDate,
	%ODBCOUT(EndTime) As EndTime,
	%ODBCOUT(EndDate)_" "_%ODBCOUT(EndTime) As EndDT
	from CF_AN.SelfPaidMaterial
	where (DeptID=:deptId)
	and ((StartDate<=+$H and (EndDate is null or EndDate >= +$H)) or (:returnAll="Y"))
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-19
/// Description： 	查询自定义项目
/// Table：        	CF_AN.UserDefDataItem
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindUserDefDataItem","1")
Query FindUserDefDataItem(categoryID As %String, itemCategory As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	a.RowId As RowId,
	Upper(Alias) As Alias,
	CIS_AN_COM.DateTime_AroundOneDay(CreateDate,CreateTime) As AroundOneDay,
	b.Counter As Counter
	from CF_AN.UserDefDataItem As a
	left join CIS_AN.UserDefItemCounter As b on a.RowId = b.UserDefinedItem
	where (DataCategory=:categoryID)
	and (CIS_AN_COM.DateTime_IsDateBeforeNow(ExpireDate)="0")
	and (:itemCategory is null or ItemCategory=:itemCategory)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-19
/// Description： 	查询自定义项目
/// Table：        	CF_AN.UserDefDataItem
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindUserDefDataItem","1")
Query FindAllUserDefDataItem(filterDesc As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	%EXTERNAL(ItemCategory) As ItemCategoryDesc,
	DataCategory->Description As DataCategoryDesc,
	%ODBCOUT(ExpireDate) As ExpireDate
	from CF_AN.UserDefDataItem
	where (Description like '%'_:filterDesc_"%") or :filterDesc is null
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-29
/// Description： 	查询模板
/// Table：        	CF_AN.ModuleTemplate
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindModuleTemplate","1")
Query FindModuleTemplate(deptId As %String, userId As %String, moduleId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *
	from CF_AN.ModuleTemplate
	where (DeptID=:deptId) 
	and ((UserID=:userId) or (Type="Public"))
	and (DataModule=:moduleId)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-29
/// Description： 	查询模板
/// Table：        	CF_AN.ModuleTmplItem
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindModuleTemplateItem","42","274","27")
Query FindModuleTemplateItem(deptId As %String, userId As %String, moduleId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	CIS_AN_COM.String_PatchFloat(Concentration) As Concentration,
	ConcentrationUnit->Description As ConcentrationUnitDesc,
	Unit->Description As UnitDesc,
	CategoryItem->DataItem->ItemCategory As ItemCategory,
	Seq,
	Seq as DataSeq
	from CF_AN.ModuleTmplItem
	where (Template->DeptID=:deptId) 
	and (Template->UserID=:userId) 
	and (Template->DataModule=:moduleId)
	order by DataSeq asc
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-29
/// Description： 	查询模板数据
/// Table：        	CF_AN.ModuleTmplItem
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindModuleTemplateData","42","274","27")
Query FindModuleTemplateData(deptId As %String, userId As %String, moduleId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *
	from CF_AN.UserPreferedData
	where DataModule=:moduleId
	and CreateUserID=:userId
	and Template is not null
	order by Seq
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-30
/// Description： 	查询模板数据药品
/// Table：        	CF.AN.UserPreferedDrug
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindUserPreferedDrug")
Query FindModuleTemplateDrug(deptId As %String, userId As %String, moduleId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	CIS_AN_COM.String_PatchFloat(DoseQty) As DoseQty,
	CIS_AN_COM.String_PatchFloat(Speed) As Speed,
	CIS_AN_COM.String_PatchFloat(Concentration) As Concentration,
	DoseUnit->Description As DoseUnitDesc,
	SpeedUnit->Description As SpeedUnitDesc,
	ConcentrationUnit->Description As ConcentrationUnitDesc,
	CIS_AN_COM.String_GetDescByID('User.PHCInstruc','PHCINDesc1',Instruction) As InstructionDesc
	from CF_AN.UserPreferedDrug
	where UserPreferedData->DataModule=:moduleId
	and UserPreferedData->CreateUserID=:userId
	and UserPreferedData->Template is not null
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-30
/// Description： 	查询模板事件
/// Table：        	CF.AN.UserPreferedDrug
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindUserPreferedDrug")
Query FindModuleTemplateEvent(deptId As %String, userId As %String, moduleId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	EventDetailItem->Description As EventDetailDesc
	from CF_AN.UserPreferedEventDetail
	where UserPreferedData->DataModule=:moduleId
	and UserPreferedData->CreateUserID=:userId
	and UserPreferedData->Template is not null
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-29
/// Description： 	查询模板
/// Table：        	CF_AN.ModuleTmplItem
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","GetModuleTemplateItem","")
Query GetModuleTemplateItem(templateId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	CategoryItem->DataCategory As DataCategory
	from CF_AN.ModuleTmplItem
	where (Template=:templateId)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-29
/// Description： 	查询模板数据
/// Table：        	CF_AN.UserPreferedData
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","GetModuleTemplateItem","")
Query GetModuleTemplateData(templateId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *
	from CF_AN.UserPreferedData
	where Template=:templateId
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-29
/// Description： 	查询模板数据-药品数据
/// Table：        	CF_AN.UserPreferedDrug
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","GetModuleTemplateItem","")
Query GetModuleTemplateDrug(templateId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	CIS_AN_COM.String_PatchFloat(DoseQty) As DoseQty,
	CIS_AN_COM.String_PatchFloat(Speed) As Speed,
	CIS_AN_COM.String_PatchFloat(Concentration) As Concentration,
	DoseUnit->Description As DoseUnitDesc,
	SpeedUnit->Description As SpeedUnitDesc,
	ConcentrationUnit->Description As ConcentrationUnitDesc,
	CIS_AN_COM.String_GetDescByID('User.PHCInstruc','PHCINDesc1',Instruction) As InstructionDesc
	from CF_AN.UserPreferedDrug
	where (UserPreferedData->Template=:templateId)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-29
/// Description： 	查询模板数据-事件明细数据
/// Table：        	CF_AN.UserPreferedEventDetail
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","GetModuleTemplateItem","")
Query GetModuleTemplateEvent(templateId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	EventDetailItem->Description As EventDetailDesc
	from CF_AN.UserPreferedEventDetail
	where (UserPreferedData->Template=:templateId)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-29
/// Description： 	查询记费项目
/// Table：        	CF_AN.ChargeItem
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindChargeItemByCondition","29","")
Query FindChargeItemByCondition(deptId As %String, filterDesc As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT a.RowId As RowId,
	a.Description As Description,
	a.Code As Code,
	Dept,
	Unit,
	a.Price As Price,
	CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",a.Dept) As DeptDesc,
	Upper(a.Alias) As Alias,
	a.Unit -> LocalDesc As UnitDesc
	from CF_AN.ChargeItem As a
	where (a.Dept=:deptId or :deptId is null)
	and ((UPPER(a.Description) [ UPPER(:filterDesc)) or (UPPER(a.Alias) [ UPPER(:filterDesc)))
	and IsActive="Y"
	order by a.SeqNo
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-29
/// Description： 	查询记费项目
/// Table：        	CF_AN.ChargeItem
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindChargeItemFront","29","")
Query FindChargeItemFront(deptId As %String, filterDesc As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",Dept) As DeptDesc,
	Upper(Alias) As Alias,
	Unit -> LocalDesc As UnitDesc,
	ChargeCategory->Description As ChargeCategoryDesc
	from CF_AN.ChargeItem
	where (Dept=:deptId or :deptId is null)
	and ((UPPER(Description) [ UPPER(:filterDesc)) or (UPPER(Alias) [ UPPER(:filterDesc)) or :filterDesc is null)
	and IsActive="Y"
	order by SeqNo
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-29
/// Description： 	查询记费项目
/// Table：        	CF_AN.ChargeItem
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindChargeItem","29","")
Query FindChargeItem(deptId As %String, filterDesc As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",Dept) As DeptDesc,
	Upper(Alias) As Alias,
	Unit -> LocalDesc As UnitDesc,
	ChargeCategory->Description As ChargeCategoryDesc
	from CF_AN.ChargeItem
	where (Dept=:deptId or :deptId is null)
	and ((UPPER(Description) [ UPPER(:filterDesc)) or (UPPER(Alias) [ UPPER(:filterDesc)) or :filterDesc is null)
	order by SeqNo
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-29
/// Description： 	查询记费项目关联
/// Table：        	CF_AN.ChargeItemLink
/// Input:			deptId:科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindChargeItemLink","","")
Query FindChargeItemLink(deptId As %String, filterChargeItem As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	ChargeItem -> Description As ChargeItemDesc,
	DataItem -> Description As DataItemDesc,
	CIS_AN_COM.String_GetDescByID('User.ORCAnaestMethod','ANMETDesc',AnaestMethod) As AnaestMethodDesc
	from CF_AN.ChargeItemLink
	where (ChargeItem -> Dept=:deptId or :deptId is null)
	and (ChargeItem=:filterChargeItem or :filterChargeItem is null)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-30
/// Description： 	查询药品项
/// Table：        	CF.AN.UserPreferedData
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindUserPreferedData","27","11886")
Query FindUserPreferedData(moduleId As %String, userId As %String, permission As %String = "All", deptId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *
	from CF_AN.UserPreferedData
	where DataModule=:moduleId
	and (:userId is null or CreateUserID=:userId or (:permission='All' and Permission='Public'))
	and (:permission='All' or Permission=:permission)
	and (Dept is null or Dept=:deptId)
	and Template is null
	order by Seq
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-30
/// Description： 	查询药品项
/// Table：        	CF.AN.UserPreferedData
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindPreferedDataForTemplate","27","11886")
Query FindPreferedDataForTemplate(templateId As %String, userId As %String, permission As %String = "All", deptId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	a.RowId As RowId,
	a.DataItem As DataItem,
	a.DataItem->ItemCategory As ItemCategory,
	a.DataItem->Description As DataItemDesc,
	b.DoseQty As DoseQty,
	b.DoseUnit As DoseUnit,
	b.DoseUnit->Description As DoseUnitDesc,
	b.Instruction As Instruction,
	CIS_AN_COM.String_GetDescByID("CT.AN.Instruction","Description",Instruction) As InstructionDesc
	from CF_AN.UserPreferedData as a
	left join CF_AN.UserPreferedDrug as b on b.UserPreferedData=a.RowId
	where Template=:templateId
	and (:userId is null or CreateUserID=:userId or (:permission='All' and Permission='Public'))
	and (:permission='All' or Permission=:permission)
	and (Dept is null or :deptId is null or Dept=:deptId)
	order by Seq
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-30
/// Description： 	查询药品项
/// Table：        	CF.AN.UserPreferedData
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindUserPreferedData")
Query FindPreferedDataByDataItem(moduleId As %String, deptId As %String, userId As %String, dataItemId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',CreateUserID) As CreateUserDesc,
	%ODBCOUT(CreateDate)_" "_%ODBCOUT(CreateTime) As CreateDT,
	CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserDesc,
	%External(Permission) As PermissionDesc
	from CF_AN.UserPreferedData
	where DataModule=:moduleId
	and Dept=:deptId
	and CreateUserID=:userId
	and Template is null
	and DataItem=:dataItemId
	order by Seq
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-30
/// Description： 	查询药品项
/// Table：        	CF.AN.UserPreferedDrug
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindUserPreferedDrug")
Query FindUserPreferedDrug(moduleId As %String, userId As %String, permission As %String = "All", deptId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	CIS_AN_COM.String_PatchFloat(DoseQty) As DoseQty,
	CIS_AN_COM.String_PatchFloat(Speed) As Speed,
	CIS_AN_COM.String_PatchFloat(Concentration) As Concentration,
	DoseUnit->Description As DoseUnitDesc,
	SpeedUnit->Description As SpeedUnitDesc,
	ConcentrationUnit->Description As ConcentrationUnitDesc,
	CIS_AN_COM.String_GetDescByID('User.PHCInstruc','PHCINDesc1',Instruction) As InstructionDesc
	from CF_AN.UserPreferedDrug
	where UserPreferedData->DataModule=:moduleId
	and UserPreferedData->Template is null
	and (:userId is null or UserPreferedData->CreateUserID=:userId or (:permission='All' and UserPreferedData->Permission='Public'))
	and (:permission='All' or UserPreferedData->Permission=:permission)
	and (UserPreferedData->Dept is null or UserPreferedData->Dept=:deptId)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-30
/// Description： 	查询模板事件
/// Table：        	CF.AN.UserPreferedDrug
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindUserPreferedEventDetail")
Query FindUserPreferedEventDetail(moduleId As %String, userId As %String, permission As %String = "All", deptId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	EventDetailItem->Description As EventDetailDesc
	from CF_AN.UserPreferedEventDetail
	where UserPreferedData->DataModule=:moduleId
	and UserPreferedData->Template is null
	and (:userId is null or UserPreferedData->CreateUserID=:userId or (:permission='All' and UserPreferedData->Permission='Public'))
	and (:permission='All' or UserPreferedData->Permission=:permission)
	and (UserPreferedData->Dept is null or UserPreferedData->Dept=:deptId)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-30
/// Description： 	查询模板事件
/// Table：        	CF.AN.UserPreferedDrug
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindUserPreferedEventDetail")
Query FindPreferedEventDetail(preferedDataId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *
	from CF_AN.UserPreferedEventDetail
	where UserPreferedData=:preferedDataId
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-17
/// Description： 	查询个人偏好设置
/// Table：        	CF.AN.PersonalSetting
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindPersonalSetting","","")
Query FindPersonalSetting(moduleId As %String, userId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *
	from CF_AN.PersonalSetting
	where DataModule=:moduleId
	and UserID=:userId
}

/// Creator：      	陈长青
/// CreatDate：    	2018-12-17
/// Description： 	查询手术大屏配置
/// Table：        	CF.AN.Screen
/// Input:			operFloorId:手术楼层ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindScreenConfig","1")
Query FindScreenConfig(operFloorId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,Floor,Floor->Description As FloorDesc,ClientIP,Description
	from CF_AN.Screen
	where Floor=:operFloorId or :operFloorId is null
}

/// Creator：      	雍阳
/// CreatDate：    	2019-1-24
/// Description： 	查询科室人员状态
/// Table：        	CF.AN.CrewStatus
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindCrewStatus")
Query FindCrewStatus(deptId As %String, active As %String = "Y", hospId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",Dept) As DeptDesc,
	%EXTERNAL(Type) As TypeDesc
	from CF_AN.CrewStatus
	where (Dept=:deptId or :deptId is null)
	and (:active is NULL or Active=:active)
	and ((:hospId is null) or (DataAttribution is null) or (DataAttribution->HospitalID=:hospId))
}

/// Creator：      	雍阳
/// CreatDate：    	2019-1-24
/// Description： 	查询科室人员班次
/// Table：        	CF.AN.CrewShift
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindCrewShift")
Query FindCrewShift(deptId As %String, active As %String = "Y", hospId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	%ODBCOUT(ShiftStartTime) As ShiftStartTime,
	%ODBCOUT(ShiftEndTime) As ShiftEndTime,
	CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",Dept) As DeptDesc,
	Floor->Description As FloorDesc,
	Location->Description As LocationDesc,
	Status->Code As StatusCode,
	Status->Description As StatusDesc,
	Status->Type As StatusType
	from CF_AN.CrewShift
	where (Dept=:deptId or :deptId is null)
	and (:active is NULL or Active=:active)
	and ((:hospId is null) or (DataAttribution is null) or (DataAttribution->HospitalID=:hospId))
}

/// Creator：        陈长青
/// CreatDate：      2016-12-26
/// Description：    查询手术等级
/// Table：          OperClass
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindOperClass")
Query FindChargeCategory() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT * from CF_AN.ChargeCategory
}

/// Creator：        陈长青
/// CreatDate：      2017-2-22
/// Description：    查询节假日期信息
/// Table：          DHCAN.FindHolidays
/// Input:          startDate:开始日期，endDate:结束日期
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindHolidays")
Query FindHolidays(startDate As %String, endDate As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
       %ODBCOUT(DayDate) As DayDate,
       DayType,
       %EXTERNAL(DayType) As DayTypeDesc
       from CF_AN.Holiday
       where not ((DayDate < %ODBCIN(:startDate)) or (DayDate > %ODBCIN(:endDate)))
}

/// Creator：        钟鸣远
/// CreatDate：      2020-7-6
/// Description：    查询工作日日期信息
/// Table：          DHCAN.Confing.Workday
/// Input:          startDate:开始日期，endDate:结束日期
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindWorkdays","2020-06-29","2020-06-29")
Query FindWorkdays(startDate As %String, endDate As %String) As %Query(ROWSPEC = "RowId,DayDate,DayDateDesc,DayType,DayTypeDesc,Description")
{
}

ClassMethod FindWorkdaysExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
   Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
   s RowId=0
	f RowId=$o(^DHCAN.Config.WorkdayD(RowId)) q:RowId=""  d 
	.s DayDate=$zdh($li(^DHCAN.Config.WorkdayD(RowId),1),3)
	.s DayDateDesc=$li(^DHCAN.Config.WorkdayD(RowId),2)
	.s DayType=$li(^DHCAN.Config.WorkdayD(RowId),3)
	.s DayTypeDesc=$li(^DHCAN.Config.WorkdayD(RowId),4)
	.s Description=$li(^DHCAN.Config.WorkdayD(RowId),5)
	.do outputWorkday
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputWorkday
 set Data=$lb(RowId,DayDate,DayDateDesc,DayType,DayTypeDesc,Description)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindWorkdaysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RHBloodExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWorkdaysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RHBloodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：        陈长青
/// CreatDate：      2017-1-8
/// Description：    查询手术楼层
/// Table：          OperFloor
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindOperFloor")
Query FindOperFloor(hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT * from CF_AN.OperFloor
where ((:hospId is null) or (DataAttribution is null) or (DataAttribution->HospitalID=:hospId))
}

/// Creator：        陈长青
/// CreatDate：      2017-1-8
/// Description：    查询手术楼层
/// Table：          OperFloor
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindMenuPermissions","50")
Query FindMenuPermissions(groupID As %String, active As %String = "A") As %SQLQuery(CONTAINID = 1)
{
SELECT * from CF_AN.MenuPermission 
where RoleGroup=:groupID and 
(active=:active or :active="A") and MenuItem->Description is not null
}

/// Creator：        陈长青
/// CreatDate：      2017-1-8
/// Description：    查询手术楼层
/// Table：          OperFloor
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindMenuItemForGroup","51","OPWSMenu")
Query FindMenuItemForGroup(groupID As %String, menuCode As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RoleGroup,
	   MenuItem,
	   MenuItem->Code As MenuItemCode,
	   MenuItem->Description As MenuItemDesc,
	   CIS_AN_COM.String_GetTranslationByBDP("CT.AN.MenuItem","DisplayName",MenuItem->DisplayName) As DisplayName,
	   MenuItem->Url As Url,
	   MenuItem->Exp As Exp,
	   MenuItem->LinkModule As ModuleID,
	   MenuItem->LinkModule->Code As ModuleCode,
	   MenuItem->Menu As MenuID,
	   MenuItem->Menu->Description As MenuDesc,
	   MenuItem->Menu->Code As MenuCode,
	   MenuItem->MainItem As MainItem,
	   MenuItem->MainItem->Code As MainItemCode,
	   MenuItem->MainItem->Description As MainItemDesc,
	   MenuItem->MainItem->DisplayName As MainItemDisplayName
	   from CF_AN.MenuPermission where RoleGroup=:groupID and MenuItem->Menu->Code=:menuCode
	   and Active="Y"
	   order by MenuItem->MainItem->RowId,MenuItem->Code
}

/// Creator：        陈长青
/// CreatDate：      2017-1-8
/// Description：    查询手术楼层
/// Table：          OperFloor
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindOperFloor")
Query FindDeptLinkBodySite(deptId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   Dept,
	   CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",Dept) As DeptDesc,
	   BodySite,
	   CIS_AN_COM.String_GetDescByID('User.OECBodySite','BODSDesc',BodySite) As BodySiteDesc
	   from CF_AN.DeptLinkBodySite
	   where (Dept=:deptId) or (:deptId is null)
}

/// Creator：      	雍阳
/// CreatDate：    	2019-10-30
/// Description： 	查询所有药品对应医嘱项
/// Table：        	OperRoom
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.BLL.ConfigQueries","FindDrugArcim")
Query FindDrugArcim() As %SQLQuery(CONTAINID = 1)
{
SELECT a.RowId As RowId,
	   a.DrugItem As DataItem,
	   a.DrugItem->Description As DataItemDesc,
	   a.ArcimID As ArcimID,
	   CIS_AN_COM.String_GetDescByID('User.ARCItmMast','ARCIMDesc',a.ArcimID) As ArcimDesc,
	   a.Rule As Rule,
	   a.PackQty As PackQty,
	   a.PackUom As PackUom,
	   CIS_AN_COM.String_GetDescByID('User.CTUOM','CTUOMDesc',a.PackUom) As PackUomDesc,
	   a.DoseQty As DoseQty,
	   a.DoseUom As DoseUom,
	   CIS_AN_COM.String_GetDescByID('User.CTUOM','CTUOMDesc',a.DoseUom) As DoseUomDesc,
	   b.RowId As ANDoseUom,
	   a.Instruction As Instruction,
	   CIS_AN_COM.String_GetDescByID('User.PHCInstruc','PHCINDesc1',a.Instruction) As InstrDesc,
	   a.RecvLoc As RecvLoc,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',a.RecvLoc) As RecvLocDesc,
	   a.AlertQty As AlertQty
	   from CF_AN.DrugArcim as a
	   left join CT_AN.Uom as b on b.ExternalID=a.DoseUom
}

/// Creator：      	陈长青
/// CreatDate：    	2020-02-14
/// Description： 	查询医院信息
/// Table：        	CF_AN.Hospital
/// Input:			needActive:是否判断激活失效日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindHospitals")
Query FindHospitals(hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT HOSP_RowId As HospID,
	   HOSP_Desc As HospDesc,
	   OperDept,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',OperDept) As OperDeptDesc,
	   OutOperDept,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',OutOperDept) As OutOperDeptDesc,
	   EMOperDept,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',EMOperDept) As EMOperDeptDesc,
	   IVTOperDept,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',IVTOperDept) As IVTOperDeptDesc,
	   ANDept,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',ANDept) As ANDeptDesc,
	   OutANDept,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',OutANDept) As OutANDeptDesc,
	   EMANDept,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',EMANDept) As EMANDeptDesc,
	   IVTANDept,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',IVTANDept) As IVTANDeptDesc,
	   b.RowId As RowId
	   from SQLUser.CT_Hospital As a
	   left join CF_AN.Hospital As b
	   on a.HOSP_RowId=b.HospID
	   where (HOSP_DateFrom<=+$h)
	   and ((HOSP_DateTo>=+$h) or (HOSP_DateTo is null))
	   and ((:hospId is null) or (DataAttribution is null) or (DataAttribution->HospitalID=:hospId))
}

/// Creator：      	陈长青
/// CreatDate：    	2020-02-14
/// Description： 	查询科室信息
/// Table：        	CF_AN.Department
/// Input:			needActive:是否判断激活失效日期,hospId:医院ID,filterDesc:筛选字符串
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindDepartments","呼吸","1","Y")
Query FindDepartments(filterDesc As %String, deptId As %String = "", hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT CTLOC_RowId As DeptID,
	CTLOC_Desc As DeptDesc,
	OperDept,
	CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',OperDept) As OperDeptDesc,
	ANDept,
	CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',ANDept) As ANDeptDesc,
	DSAdmDept,
	CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',DSAdmDept) As DSAdmDeptDesc,
	OperApp,
	%external(OperApp) As OperAppDesc,
	AnaApp,
	%external(AnaApp) As AnaAppDesc,
	ProType,
	%external(ProType) As ProTypeDesc,
	b.DataAttribution As DataAttribution,
	RowId
	from SQLUser.CT_Loc As a inner join
	CF_AN.Department As b on a.CTLOC_RowId=b.DeptID
	where (CTLOC_RowId=:deptId or :deptId is null)
	and (CTLOC_DateActiveFrom<=+$h)
	and ((CTLOC_DateActiveTo>=+$h) or (CTLOC_DateActiveTo is null))
	and ((UPPER(CTLOC_Desc) [ UPPER(:filterDesc)) or (UPPER(CTLOC_ContactName) [ UPPER(:filterDesc)) or :filterDesc is null )
	and ((:hospId is null) or (DataAttribution is null) or (DataAttribution->HospitalID=:hospId))
}

/// Creator：      	陈长青
/// CreatDate：    	2020-05-12
/// Description： 	查询安全组配置信息
/// Table：        	CF_AN.SSGroup
/// Input:			groupId:安全组ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindGroupSetting","52")
Query FindGroupSetting(groupId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT *
	from CF_AN.SSGroup
	where GroupID=:groupId
}

/// Creator：      	元琳
/// CreatDate：    	2020-02-26
/// Description： 	查询手术医师组
/// Table：        	CF_AN.SurgeonGroup
/// Input:			filterOperDeptID:科室Id,SurgeonID:医护人员ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindSurgeonGroup","111")
Query FindSurgeonGroup(filterOperDeptID As %String, SurgeonID As %String = "", ACTIVE As %String = "") As %SQLQuery(CONTAINID = 1)
{
	SELECT RowId,
       Dept,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',Dept) As DeptDesc,
       Surgeon,
       CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',Surgeon) As SurgeonDesc,
       Assist1,
       CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',Assist1) As Assist1Desc,
       Assist2,
       CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',Assist2) As Assist2Desc,
       Assist3,
       CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',Assist3) As Assist3Desc,
	   CIS_AN_COM.String_ParseDateFormat(ActiveDate) As ActiveDate,
	   CIS_AN_COM.String_ParseDateFormat(ExpireDate) As ExpireDate,
       Active,%EXTERNAL(Active) As ActiveDesc,
       UpdateUser,
	   %ODBCOUT(UpdateDate) As UpdateDate,
	   %ODBCOUT(UpdateTime) As UpdateTime
       FROM CF_AN.SurgeonGroup
	   WHERE((Dept=:filterOperDeptID) or (:filterOperDeptID is null))
	   AND (Surgeon=:SurgeonID or :SurgeonID is null)
       AND ((Active=:ACTIVE and ActiveDate<=+$h and (ExpireDate>=+$h or ExpireDate is null)) or :ACTIVE is null)
}

/// Creator：      	元琳
/// CreatDate：    	2020-03-18
/// Description： 	查询科室医护人员资源,并根据医生关联手术配置进行进一步筛选
/// Table：        	CF_AN.Resource,CF_AN.SurgeonOperation
/// Input:			filterDesc:筛选字符串,deptId:科室ID,needActive:是否判断激活失效日期,operId:手术Id
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindSurgeonByOper","","93","Y",2,"7")
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindSurgeonByOper","","191","Y",2,"45")
Query FindSurgeonByOper(filterDesc As %String = "", deptId As %String = "", needActive As %String = "N", hospId As %String = "", operId As %String = "", CPType As %String = "") As %Query(ROWSPEC = "resourceId,RowId,Description,ActiveDate,ExpireDate,Dept,DeptDesc,CareProvider,CareProvDesc") [ SqlProc ]
{
}

ClassMethod FindSurgeonByOperExecute(ByRef qHandle As %Binary, filterDesc As %String = "", deptId As %String = "", needActive As %String = "N", hospId As %String = "", operId As %String = "", CPType As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set filterDesc=$System.SQL.ALPHAUP(filterDesc)
	set resourceId=0
	set Code="",Description="",ActiveDate="",ExpireDate="",Dept="",DeptDesc="",CareProvider="",CareProvDesc=""
    set rowId=0
    set CareTypeStr="",CareTypeArr=""
    set CareTypeArr=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("OperQualificationCareType")
    set:CareTypeArr'="" CareTypeStr="^"_$tr(CareTypeArr,",","^")_"^"
    // 获取手术资质管理配置
	s OperQualificationManager=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("OperQualificationManager")
    if ((operId="")||(OperQualificationManager="N"))
	{
		d FindSurgeon("Y")
	}
	else
	{
		if $d(^CF.AN.SurgeonOperationI("IDeptOperation"," "_deptId," "_operId))
	    {
		    for
		    {
			    set rowId=$order(^CF.AN.SurgeonOperationI("IDeptOperation"," "_deptId," "_operId,rowId))
			    quit:(rowId="")
			    set CareProviderId=$list(^CF.AN.SurgeonOperationD(rowId),1)
			    quit:(CareProviderId="")
				set doclist(CareProviderId)=""  //医生去重
		    }
		    set docId=0
		    for 
		    {
			    set docId=$o(doclist(docId))
			    quit:(docId="")
			    for
			    {
				    set resourceId=$order(^RB("RES",0,"CTPCP",docId,deptId,resourceId))
				    quit:(resourceId="")
				    set ResourceInfo=^RB("RES",resourceId)
				    continue:(ResourceInfo="")
				    set Dept=$p(ResourceInfo,"^",1)
				    continue:(Dept'="")&(deptId'="")&(deptId'=Dept)
				    set Code=$p(ResourceInfo,"^",2)
				    continue:(Code="")
				    set Description=$p(ResourceInfo,"^",17)
				    continue:(Description="")
				    set ResExpireDate=$p(ResourceInfo,"^",23)
				    continue:(ResExpireDate'="")&(ResExpireDate<+$h)
				    set DeptDesc=$p(^CTLOC(Dept),"^",2)
				    set CareProvider=$p(^CTPCP(Code,1),"^",1)
				    quit:(CareProvider="")
    				set CareProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",Code)
				    //set CareProvDesc=$p(^CTPCP(Code,1),"^",2)
				    quit:(CareProvDesc="")
				    set Alias=$p(^CTPCP(Code,3),"^",28)
				    set ActiveDate=$p(^CTPCP(Code,2),"^",14)
				    set ExpireDate=$p(^CTPCP(Code,2),"^",15)
				    set CareType=$p(^CTPCP(Code,1),"^",4)
				    continue:CareTypeStr'[CareType
				    set active=$p(^CTPCP(Code,1),"^",9)
				    continue:(active'="")&&(active'="Y")
				    continue:(needActive'="Y")
				    continue:(filterDesc'="")&($System.SQL.ALPHAUP(CareProvDesc)'[filterDesc)
				    continue:(ActiveDate>+$h)
				    continue:(ExpireDate'="")&(ExpireDate<+$h)
				    do OutputRow
				}
			}
	    }
	    else
	    {
		    d FindSurgeon("N")
	    }
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK
FindSurgeon(ifAll)
    for
    {
	    set resourceId=$order(^RB("RES",resourceId))
	    quit:(resourceId="")
	    set ResourceInfo=^RB("RES",resourceId)
	    continue:(ResourceInfo="")
	    set Dept=$p(ResourceInfo,"^",1)
	    continue:(Dept'="")&(deptId'="")&(deptId'=Dept)
	    set Code=$p(ResourceInfo,"^",2)
	    continue:(Code="")
	    set Description=$p(ResourceInfo,"^",17)
	    continue:(Description="")
	    set ResExpireDate=$p(ResourceInfo,"^",23)
	    continue:(ResExpireDate'="")&(ResExpireDate<+$h)
	    set DeptDesc=$p(^CTLOC(Dept),"^",2)
	    set CareProvider=$p(^CTPCP(Code,1),"^",1)
	    quit:(CareProvider="")
    	set CareProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",Code) //多语言改造翻译后台数据 YL 20221101
	    //set CareProvDesc=$p(^CTPCP(Code,1),"^",2)
	    quit:(CareProvDesc="")
	    set Alias=$p(^CTPCP(Code,3),"^",28)
	    set ActiveDate=$p(^CTPCP(Code,2),"^",14)
	    set ExpireDate=$p(^CTPCP(Code,2),"^",15)
		set CareType=$p(^CTPCP(Code,1),"^",4)
		continue:CareTypeStr'[CareType
	    set active=$p(^CTPCP(Code,1),"^",9)
	    continue:(active'="Y")
	    continue:(needActive'="Y")
	    continue:(ifAll'="Y")&($d(^CF.AN.SurgeonOperationI("ISurgeon"," "_Code)))
	    continue:(filterDesc'="")&($System.SQL.ALPHAUP(CareProvDesc)'[filterDesc)&($System.SQL.ALPHAUP(Alias)'[filterDesc)
	    continue:(ActiveDate>+$h)
	    continue:(ExpireDate'="")&(ExpireDate<+$h)
	    do OutputRow
	}
	q
OutputRow
	s ^CacheTemp(repid,ind)=$lb(resourceId,Code,Description,ActiveDate,ExpireDate,Dept,DeptDesc,CareProvider,CareProvDesc)
	s ind=ind+1
	q
}

ClassMethod FindSurgeonByOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSurgeonByOperExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindSurgeonByOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSurgeonByOperExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	元琳
/// CreatDate：    	2020-02-26
/// Description： 	查询手术医师组
/// Table：        	CF_AN.SurgeonGroup
/// Input:			filterOperDeptID:科室Id,SurgeonID:医护人员ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindSurgeonGroup","95")
Query FindTextTemplate(dataModuleID As %String = "", elementID As %String = "") As %SQLQuery(CONTAINID = 1)
{
	SELECT *,
	   DataModule->Description As DataModuleDesc
       FROM CF_AN.TextTemplate
	   WHERE(DataModule=:dataModuleID or :dataModuleID is null)
	   AND (ElementID=:elementID or :elementID is null)
}

/// Creator：      	元琳
/// CreatDate：    	2020-02-26
/// Description： 	查询手术医师组
/// Table：        	CF_AN.SurgeonGroup
/// Input:			filterOperDeptID:科室Id,SurgeonID:医护人员ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindTextTemplateItem","","","","","1")
Query FindTextTemplateItem(filterDesc As %String = "", dataModuleID As %String = "", accessType As %String = "", filterUserId As %String = "", filterTemplateId As %String = "") As %SQLQuery(CONTAINID = 1)
{
	SELECT *,
	   TextTemplate->DataModule->Description As DataModuleDesc
       FROM CF_AN.TextTemplateItem
	   WHERE(TextTemplate->DataModule=:dataModuleID or :dataModuleID is null)
	   AND (AccessType=:accessType or :accessType is null)
	   and (CreateUser=:filterUserId or :filterUserId is null)
	   and (Description [ :filterDesc or :filterDesc is null)
	   and (TextTemplate->RowId=:filterTemplateId or :filterTemplateId is null)
}

/// Creator：      	元琳
/// CreatDate：    	2020-05-08
/// Description： 	查询科室医护人员资源
/// Table：        	RB_Resource
/// Input:			needActive:是否判断激活失效日期,filterDesc:筛选字符串,deptId:科室ID
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindResourceByHIS","","298","Y",2)
Query FindResourceByHIS(filterDesc As %String = "", deptId As %String = "", needActive As %String = "Y", hospId As %String = "", CPType As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT Res_RowId1,
	RES_Code,
	RES_Desc,
	%ODBCOUT(RES_DateActiveFrom) As ActiveDate,
	%ODBCOUT(RES_DateActiveTo) As ExpireDate,
	RES_CTLOC_DR,
	RES_CTLOC_DR->CTLOC_Desc As DeptDesc,
	RES_CTPCP_DR As CareProvider,
	CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',RES_CTPCP_DR) As CareProvDesc
	from SqlUser.RB_Resource
	where (RES_CTPCP_DR->CTPCP_ActiveFlag<>'N')
	and (RES_CTLOC_DR->CTLOC_Hospital_DR=:hospId or :hospId is null)
	and (RES_CTLOC_DR=:deptId or :deptId is null)
	and ((:needActive='Y' and RES_DateActiveFrom<=+$h and (RES_DateActiveTo>=+$h or RES_DateActiveTo is null)) or :needActive='N')
	and ((UPPER(RES_Desc) [ UPPER(:filterDesc)) or (:filterDesc is null) or (UPPER(RES_CTPCP_DR->CTPCP_OtherName) [ UPPER(:filterDesc)))
}

ClassMethod GetAppArcimDesc(AppArcimID As %String) As %String
{
	set AppArcimDesc=""
	set AppArcimDesc=##class(CIS.AN.COM.String).GetDescByID("User.ARCItmMast","ARCIMDesc",AppArcimID)
	quit AppArcimDesc
}

/// w ##class(CIS.AN.BL.ConfigQueries).GetAppArcimIdByDesc("手术申请：")
ClassMethod GetAppArcimIdByDesc(AppArcimDesc As %String, hospId As %String = "") As %String
{
	set rowId="",mainId="",sub=""
	set mainId=$o(^ARCIM(0,"Desc",AppArcimDesc,""))
	if mainId'="" set sub=$o(^ARCIM(0,"Desc",AppArcimDesc,mainId,""))
	if sub'="" set rowId=mainId_"||"_sub
	quit rowId
}

/// Creator：        陈长青
/// CreatDate：      2017-2-22
/// Description：    查询节假日期信息
/// Table：          DHCAN.FindHolidays
/// Input:          startDate:开始日期，endDate:结束日期
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindExtCareProv","","","","298")
Query FindExtCareProv(filterCode As %String, filterFullName As %String, filterMobileNo As %String, filterDeptID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
       Code,
       FullName,
       Alias,
       MobileNo,
       %ODBCOUT(ActiveDate) As ActiveDate,
       %ODBCOUT(ExpireDate) As ExpireDate
       from CF_AN.CareProvider
       where (Dept=:filterDeptID)
       and (Code=:filterCode or :filterCode is null)
       and (FullName [ :filterFullName or :filterFullName is null)
	   and (MobileNo [ :filterMobileNo or :filterMobileNo is null)
}

/// Creator：      	yongyang
/// CreatDate：    	2021-12-13
/// Description： 	查询系统信息
/// Table：        	CF_AN.System
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindSystem")
Query FindSystem() As %SQLQuery(CONTAINID = 1)
{
	SELECT *,
		%ODBCOUT(StartDate) As StartDate
		FROM CF_AN.System
}

/// Creator：      	yongyang
/// CreatDate：    	2021-12-13
/// Description： 	查询数据传输服务
/// Table：        	CF_AN.DataTransService
/// Input:			filterOperDeptID:科室Id,SurgeonID:医护人员ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindDataTransService")
Query FindDataTransService() As %SQLQuery(CONTAINID = 1)
{
	SELECT *,
	   System->Name As SystemName,
	   System->Description As SystemDesc,
	   System->Vendor As SystemVendor,
	   %ODBCOUT(System->StartDate) As SystemStartDate
       FROM CF_AN.DataTransService
}

}
