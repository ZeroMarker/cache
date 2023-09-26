/// 代码表Query
Class CIS.AN.BL.CodeQueries Extends %RegisteredObject
{

/// Creator：        陈长青
/// CreatDate：      2016-12-26
/// Description：    查询手术等级
/// Table：          OperClass
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindOperClass")
Query FindOperClass() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As RowId,
	CATEG_Code As Code,
	CIS_AN_COM.String_GetDescByID('User.ORCOperationCategory','CATEGDesc',%ID) As Description
    from SQLUser.ORC_OperationCategory 
	where (CATEG_DateFrom<=+$h)
	and ((CATEG_DateTo>=+$h) or (CATEG_DateTo is null))
}

/// Creator：        陈长青
/// CreatDate：      2016-12-26
/// Description：    查询切口类型
/// Table：          BladeType
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindBladeType")
Query FindBladeType() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As RowId,
	   BLDTP_Code As Code,
	   CIS_AN_COM.String_GetDescByID('User.ORCBladeType','BLDTPDesc',%ID) As Description
	   from SQLUser.ORC_BladeType
}

/// Creator：        陈长青
/// CreatDate：      2016-12-26
/// Description：    查询手术部位
/// Table：          BodySite
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindBodySite")
Query FindBodySite() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As RowId,
       BODS_Code As Code,
	   CIS_AN_COM.String_GetDescByID('User.OECBodySite','BODSDesc',%ID) As Description
       from SQLUser.OEC_BodySite
}

/// Creator：        陈长青
/// CreatDate：      2016-12-28
/// Description：    查询手术体位
/// Table：          OperPosition
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindOperPosition")
Query FindOperPosition(needActive As %String = "Y") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As RowId,
	   OPPOS_Code As Code,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperPosition','OPPOSDesc',%ID) As Description
	   from SQLUser.ORC_OperPosition
}

/// Creator：        陈长青
/// CreatDate：      2016-12-28
/// Description：    查询手术名称
/// Table：          DHCAN.Operation
/// Input:          filterDesc:名称(别名)筛选字符串
///                     filterOperClassId:手术分级ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindOperation","lw","")
Query FindOperationold(filterDesc As %String = "", filterOperClassId As %String = "", active = "Y") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
       Description,
       Alias,
       OperClass,
       OperClass->Description As OperClassDesc,
       BladeType,
       BladeType->Description As BladeTypeDesc,
       BodySite,
       BodySite->Description As BodySiteDesc,
       OperPosition,
       OperPosition->Description As OperPosDesc,
       Active,
       %External(Active) As ActiveDesc,
       ICD10,
       STRING('[',ICD10,']',Description) As ICD10Desc,
       Code,
       OperType,
       %External(OperType) As OperTypeDesc,
       ExternalID
       from CT_AN.Operation
       where ((UPPER(Description) like UPPER('%'_:filterDesc_'%')) or (UPPER(Alias) like UPPER('%'_:filterDesc_'%')) or (:filterDesc is null))
       and ((OperClass=:filterOperClassId) or (:filterOperClassId is null))
       and ((Active=:active)or(:active is null))
}

/// Creator：        杨国宾
/// CreatDate：      2020-05-08
/// Description：    查询手术名称
/// Table：          ORC_Operation
/// Input:          filterDesc:名称(别名)筛选字符串
///                     filterOperClassId:手术分级ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindOperation","头,"")
Query FindOperation(filterDesc As %String = "", filterOperClassId As %String = "", active = "Y") As %Query(ROWSPEC = "RowId,Description,Alias,OperClass,OperClassDesc,BladeType,BladeTypeDesc,BodySite,BodySiteDesc,OperPosition,OperPosDesc,Active,ActiveDesc,ICD10,ICD10Desc,Code,OperType,OperTypeDesc,ExternalID") [ SqlProc ]
{
}

ClassMethod FindOperationExecute(ByRef qHandle As %Binary, filterDesc As %String = "", filterOperClassId As %String = "", active = "Y") As %Status
{
	
	//s ^tempzmy(15)=filterDesc
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	s result=""
	s operId=0
	f  s operId=$O(^ORC("OPER",operId)) q:operId=""  d
        .quit:operId=""
		.set objoper=##class(User.ORCOperation).%OpenId(operId)
		.set objoperExtend=##class(User.ORCOperationExtend).%OpenId(operId)
		.set RowId=operId
		.set Description=objoper.OPERDesc
		.set Alias=$$ALPHAUP^SSUTIL4($g(^ORC("OPER",operId,"ALIAS",1)))
		.quit:((filterDesc'="")&&(Description'[filterDesc))&&((filterDesc'="")&&(Alias'[$$ALPHAUP^SSUTIL4(filterDesc)))
		.set OperClass=$p(^ORC("OPER",operId),"^",7)  ;objoperExtend.OPERClassDr
		.b:operId=1
		.quit:(filterOperClassId'="")&&(filterOperClassId'=OperClass)
		.set Active=objoper.OPERValid
		.set datato=objoper.OPERActiveDateTo
		.quit:(active'="")&&(active'=Active)
		.quit:(active'="")&&(datato'="")&&(datato<+$H)
		.set ActiveDesc=""
		.set Alias=^ORC("OPER",operId,"ALIAS",1)
		.set OperClassDesc=""
		.if OperClass'="" set OperClassDesc=$P($G(^ORC("CATEG",OperClass)),"^",2)
		.set BladeType=objoperExtend.OPERBladeDr
		.set BladeTypeDesc=""
		.if BladeType'="" set BladeTypeDesc=$P($G(^ORC("BLDTP",BladeType)),"^",2)
		.set BodySite=""
		.set BodySiteDesc=""
		.set OperPosition=objoperExtend.OPEROperPositionDr
		.set OperPosDesc=""
		.if OperPosition'="" set OperPosDesc=$P($G(^ORC("OPPOS",OperPosition)),"^",2)
		.set ICD10=objoper.OPERICD10
		.set ICD10Desc=ICD10
		.set Code=objoper.OPERCode
		.set OperType=""
		.set OperTypeDesc=""
		.set ExternalID=""
		.set result=$lb(RowId,Description,Alias,OperClass,OperClassDesc,BladeType,BladeTypeDesc,BodySite,BodySiteDesc,OperPosition,OperPosDesc,Active,ActiveDesc,ICD10,ICD10Desc,Code,OperType,OperTypeDesc,ExternalID)
		.do OutputRow
	
	

	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=result
	s ind=ind+1
	q
}

ClassMethod FindOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationExecute ]
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

ClassMethod FindOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：        陈长青
/// CreatDate：      2016-12-28
/// Description：    查询ASA分级
/// Table：          ASAClass
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindASAClass")
Query FindASAClass() As %SQLQuery(CONTAINID = 1)
{
select %ID As RowId,ORASA_Code As Code,ORASA_Desc As Description from SQLUser.ORC_ASA_ClassPhActiv
}

/// Creator：        陈长青
/// CreatDate：      2016-12-28
/// Description：    查询麻醉类型
/// Table：          AnaestType
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindAnaestType")
Query FindAnaestType() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   ANTYPE_Code As Code,
	   ANTYPE_Desc As Description,
	   ANTYPE_DateFrom As ActiveDate,
	   ANTYPE_DateTo As ExpireDate 
	   from SQLUser.ORC_AnaestType
	   where (ANTYPE_DateFrom<=+$h)
	   and ((ANTYPE_DateTo>=+$h) or (ANTYPE_DateTo is null))
}

ClassMethod CutString(str) As %String [ SqlProc ]
{
    s ret=str
    s:ret["-" ret=$p(ret,"-",2)
    q ret
}

/// Creator：        陈长青
/// CreatDate：      2016-12-28
/// Description：    查询麻醉方法
/// Table：          DHCAN.AnaestMethod
/// Input:          filterAnaTypeId:麻醉类型ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindAnaestMethod","1")
Query FindAnaestMethod(filterAnaTypeId As %String, active As %String = "", filterDesc As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT a.%ID As RowId,
	   a.ANMET_Code As Code,
	   CIS_AN_COM.String_GetDescByID('User.ORCAnaestMethod','ANMETDesc',a.%ID) As Description,
	   a.ANMET_DateFrom As ActiveDate,
	   a.ANMET_DateTo As ExpireDate,
	   a.ANMET_Type_DR As AnaType,
	   a.ANMET_Type_DR->ANTYPE_Desc As AnaTypeDesc,
	   b.Catheter As Catheter,
	   b.CatheterType As CatheterType,
	   b.CatheterPath As CatheterPath,
	   b.CatheterTool As CatheterTool,
	   b.CatheterDirection As CatheterDirection,
	   b.PunctureSpace As PunctureSpace,
	   b.PositionMethod As PositionMethod,
	   b.CatheterDepth As CatheterDepth,
	   b.NerveBlockSite As NerveBlockSite
	   from SQLUser.ORC_AnaestMethod as a
	   left join CT_AN.AnaMethodPermission as b on (b.AnaMethod=a.%ID)
       where ((ANMET_Type_DR=:filterAnaTypeId) or (:filterAnaTypeId is null))
       and (ANMET_DateFrom<=+$h)
       and ((ANMET_DateTo>=+$h) or (ANMET_DateTo is null))
       and ((UPPER(ANMET_Desc) [ UPPER(:filterDesc)) or (:filterDesc is null))
}

/// Creator：        雍阳
/// CreatDate：      2021-05-14
/// Description：    查询麻醉方法对应插管项目的可见性配置
/// Table：          CT.AN.AnaMethodPermission
/// Input:           
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindAnaestMethod","1")
Query FindAnaMethodPermission() As %SQLQuery(CONTAINID = 1)
{
	SELECT a.%ID As AnaMethod,
	   a.ANMET_Desc As AnaMethodDesc,
	   a.ANMET_Type_DR As AnaType,
	   a.ANMET_Type_DR->ANTYPE_Desc As AnaTypeDesc,
	   b.RowId As RowId,
	   b.Catheter As Catheter,
	   b.CatheterType As CatheterType,
	   b.CatheterPath As CatheterPath,
	   b.CatheterTool As CatheterTool,
	   b.CatheterDirection As CatheterDirection,
	   b.PunctureSpace As PunctureSpace,
	   b.PositionMethod As PositionMethod,
	   b.CatheterDepth As CatheterDepth,
	   b.NerveBlockSite As NerveBlockSite
	   from SQLUser.ORC_AnaestMethod as a
	   left join CT_AN.AnaMethodPermission as b on (b.AnaMethod=a.%ID)
       where (ANMET_DateFrom<=+$h)
       and ((ANMET_DateTo>=+$h) or (ANMET_DateTo is null))
}

/// Creator：        陈长青
/// CreatDate：      2016-12-29
/// Description：    查询手术状态
/// Table：          OperStatus
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindOperStatus","Application")
Query FindOperStatus(statusCode As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,Code,CIS_AN_COM.String_GetTranslationByBDP("CT.AN.OperStatus","Description",RowId) As Description,
       BGColor from CT_AN.OperStatus where (Code=:statusCode) or (:statusCode is null)
}

/// Creator：        陈长青
/// CreatDate：      2016-12-29
/// Description：    查询数据模块
/// Table：          DHCAN.DataModule
/// Input:          filterDesc:数据模块名称筛选字符串，parentModuleId:父模块ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindDataModule","1","1")
Query FindDataModule(filterDesc As %String, parentModuleId As %String, moduleCode As %String = "", needActive As %String = "N") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
       Code,
       Description,
       ParentModule,
       ParentModule As _parentId,
       ParentModule->Description As ParentModuleDesc,
       URL,
       Icon,
       MenuModule,
       %External(MenuModule) As MenuModuleDesc,
       Active,
       %External(Active) As ActiveDesc,
       CASign,
       %External(CASign) As CASignDesc,
       Archive,
       %External(Archive) As ArchiveDesc,
       ArchiveCode,
       DetailUrl,
       SeqNo,
       EditStatus,
       RelateModule,
       RelateModule->Description As RelateModuleDesc,
       CIS_AN_COM.String_GetDescByIDStr("CT.AN.OperStatus","Description",EditStatus,",") As EditStatusDesc
       from CT_AN.DataModule
       where ((Description [ :filterDesc) or (:filterDesc is null))
       and ((ParentModule=:parentModuleId) or ((not :parentModuleId is null) and (ParentModule is null) and (RowId=:parentModuleId)) or (:parentModuleId is null))
       and ((Code=:moduleCode) or (:moduleCode is null))
       --and ((:needActive='Y') and (Active='Y'))
       order by SeqNo
}

/// Creator：        陈长青
/// CreatDate：      2017-1-10
/// Description：    查询数据项
/// Table：          DHCAN.DataItem
/// Input:          filterDesc:筛选字符串，filterItemCategory:数据项分类
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindDataItem","","")
Query FindDataItem(filterDesc As %String, filterItemCategory As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
       Code,
       Description,
       Options,
       ChannelNo,
       ItemCategory,
       %EXTERNAL(ItemCategory) As ItemCategoryDesc,
       DataType,
       %EXTERNAL(DataType) As DataTypeDesc,
       Alias
       from CT_AN.DataItem 
       where ((Description [ :filterDesc) or (:filterDesc is null))
       and ((ItemCategory=:filterItemCategory) or (:filterItemCategory is null))
}

/// Creator：        陈长青
/// CreatDate：      2017-2-10
/// Description：    查询数据项分类
/// Table：          DHCAN.DataCategory
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindDataCategory","","")
Query FindDataCategory() As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
       Code,
       Description,
       STRING(Description,'[',Code,']') As DescCode,
       MainCategory,
       MainCategory->Description As MainCategoryDesc,
       MainCategory As _parentId
       from CT_AN.DataCategory
}

/// Creator：        陈长青
/// CreatDate：      2017-2-10
/// Description：    查询数据项分类关联的数据项
/// Table：          DHCAN.DataCategoryItem
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindCategoryItem","","")
Query FindCategoryItem(filterDesc As %String, filterDataCategory As %String, hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT a.RowId As RowId,
	   a.DataCategory->MainCategory As MainCategory,
       a.DataCategory As DataCategory,
       a.DataCategory->Code As CategoryCode,
       a.DataCategory->Description As CategoryDesc,
       a.DataItem As DataItem,
       a.DataItem->Code As ItemCode,
       a.DataItem->Description As ItemDesc,
       a.DataItem->DataType As DataType,
       a.DataItem->Alias As Alias,
       %EXTERNAL(a.DataItem->DataType) As DataTypeDesc,
       a.DataItem->Options As Options,
       a.DataItem->ItemCategory As ItemCategory,
       %EXTERNAL(a.DataItem->ItemCategory) As ItemCategoryDesc,
       a.DataItem->ChannelNo As ChannelNo,
       a.SeqNo As SeqNo,
       b.Counter As Counter
       from CT_AN.DataCateItem As a
       left join CIS_AN.DataItemCounter As b On a.DataItem = b.DataItem
       where ((a.DataItem->Description [ :filterDesc) or (:filterDesc is null))
       and ((a.DataCategory=:filterDataCategory) or (:filterDataCategory is null))
       and ((:hospId is null) or (a.DataAttribution is null) or (a.DataAttribution->HospitalID=:hospId))
       order by ItemCategoryDesc,CategoryDesc,SeqNo
}

/// Creator：        陈长青
/// CreatDate：      2017-03-01
/// Description：    查询手术麻醉原因
/// Table：          DHCAN.Reason
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindReason","")
Query FindReason(reasonType As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   Code,
       Description,
       ReasonType,
       %EXTERNAL(ReasonType) As ReasonTypeDesc
       from CT_AN.Reason
       where (ReasonType=:reasonType) or (:reasonType is null)
}

/// Creator：        陈长青
/// CreatDate：      2017-4-6
/// Description：    获取手术麻醉单位
/// Table：          DHCAN.Unit
/// Input:          filterDesc:筛选字符串
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindUnits")
Query FindUom(filterDesc As %String, unitType As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT *,
       CIS_AN_COM.String_GetDescByID("User.CTUOM","CTUOMDesc",ExternalID) As UomDesc,
       %EXTERNAL(UnitType) As UnitTypeDesc
       from CT_AN.Uom
       where ((Description [ :filterDesc) or (:filterDesc is null))
       and ((UnitType=:unitType) or (:unitType is null))
}

/// Creator：        雍阳
/// CreatDate：      2019-10-23
/// Description：    获取手术麻醉单位转换数据
/// Table：          CT.AN.UomConversion
/// Input:           filterDesc:筛选字符串
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindUomConversion")
Query FindUomConversion(sourceDesc As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT *,
       Source->Description As SourceDesc,
	   Target->Description As TargetDesc
	   from CT_AN.UomConversion
	   where (UPPER(Source->Description) [ UPPER(:sourceDesc))or (:sourceDesc is null)
}

/// Creator：        陈长青
/// CreatDate：      2017-04-18
/// Description：    查询手术麻醉图例
/// Table：          DHCAN.Legend
/// Input:          fitlerDesc:描述筛选字符串
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindLegends","")
Query FindLegends(filterDesc As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
       %EXTERNAL(FillShape) As FillShapeDesc
       from CT_AN.Legend where (Description [ :filterDesc) or (:filterDesc is null)
}

/// Creator：        陈长青
/// CreatDate：      2017-04-18
/// Description：    查询手术麻醉图例数据
/// Table：          DHCAN.LegendData
/// Input:          legendID:图例ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindLegendData","")
Query FindLegendData(legendID As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
       %EXTERNAL(ShapeType) As ShapeTypeDesc
       from CT_AN.LegendData where (Legend=:legendID) or (:legendID="All")
}

/// Creator：        陈长青
/// CreatDate：      2017-04-21
/// Description：    查询数据项的生命体征信息
/// Table：          DHCAN.VitalSign
/// Input:          dataItemID:数据项ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindVitalSign","")
Query FindVitalSign(dataItemID As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
       DataItem -> Code As Code
       from CT_AN.VitalSign where ((DataItem=:dataItemID) or (:dataItemID is null))
}

/// Creator：        陈长青
/// CreatDate：      2017-04-21
/// Description：    查询数据项的药品信息
/// Table：          DHCAN.DrugItem
/// Input:          dataItemID:数据项ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQuery","FindDrugItem","11")
Query FindDrugItem(dataItemID As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
       DoseUnit -> Description As DoseUnitDesc,
       ConcentrationUnit -> Description As ConcentrationUnitDesc,
       CIS_AN_COM.String_GetDescByID("User.ARCItmMast","ARCIMDesc",ArcimID) As ArcimDesc,
       CIS_AN_COM.String_GetDescByID("User.ARCItmMast","ARCIMPHCDFDR",ArcimID) As DrgFormID,
       Instruction->Description As InstructionDesc,
       CIS_AN_COM.String_PatchFloat(DoseQty) As DoseQty
       from CT_AN.DrugItem where (DataItem=:dataItemID) or (:dataItemID is null)
}

/// Creator：        陈长青
/// CreatDate：      2017-07-14
/// Description：    查询手术麻醉操作功能
/// Table：          DHCAN.OperAction
/// Input:          moduleId:模块ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQuery","FindOperActions","10")
Query FindOperActions(moduleId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
       RowId As OperAction,
       Code,
       Description,
       DataModule,
       DataModule->Description As DataModuleDesc,
       ElementID,
       Icon,
       ExecFunc,
       LinkModule,
       LinkModule->Description As LinkModuleDesc,
       LinkModule->URL As LinkModuleURL,
       Container,
       Seq
       from CT_AN.OperAction
       where (DataModule=:moduleId) or (:moduleId is null)
       order by Seq
}

/// Creator：        陈长青
/// CreatDate：      2017-11-17
/// Description：    查询事件明细项目
/// Table：          DHCAN.EventDetailItem
/// Input:          dataItemID:数据项ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindEventDetailItems","")
Query FindEventOptions(dataItemID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *,
       %EXTERNAL(DataType) As DataTypeDesc,
       %External(OptType) As OptTypeDesc,
       Code,
       DataItem->Code As DataItemCode,
       DataItem->Description As DataItemDesc
       from CT_AN.EventOptions where DataItem=:dataItemID or :dataItemID is null
       order by SeqNo
}

/// Creator：        陈长青
/// CreatDate：      2017-11-20
/// Description：    查询事件项
/// Table：          DHCAN.EventItem
/// Input:          dataItemID:数据项ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindEventItem","")
Query FindEventItem(dataItemID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *,
       DataItem->Code As DataItemCode,
       DataItem->Description As DataItemDesc,
       Legend->Description As LegendDesc,
       %EXTERNAL(ShowDetail) As ShowDetailDesc
       from CT_AN.EventItem where DataItem=:dataItemID or :dataItemID is null
}

/// Creator：        杨勤
/// CreatDate：      2017-10-12
/// Description：    查询设备类型
/// Table：          DHCAN.DeviceType
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQuery","FindDeviceType")
Query FindEquipType() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    select * from CT_AN.EQType
}

/// Creator：        杨勤
/// CreatDate：      2017-10-12
/// Description：    查询设备厂家
/// Table：          DHCAN.DeviceFactory
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQuery","FindDeviceFactory")
Query FindEquipMFR() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    select * from CT_AN.EQManufacturer
}

/// Creator：        杨勤
/// CreatDate：      2017-10-12
/// Description：    查询设备型号
/// Table：          DHCAN.DeviceModel
/// Input:          Factory:设备厂家,InterfaceType:接口类型,DeviceType:设备类型,CollectType:采集类型
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindEquipModel","","","","")
Query FindEquipModel(EquipMFRID As %String = "", filterDesc As %String = "") As %SQLQuery(CONTAINID = 1)
{
    SELECT RowId,
           Code,
           Description,
           DocUrl,
           Manufacturer,
           Manufacturer->Description As ManufacturerDesc,
           EQType,
           EQType->Description As EQTypeDesc
           from CT_AN.EQModel
           where Manufacturer=:EquipMFRID or :EquipMFRID is null
           and ((UPPER(Description) [ UPPER(:filterDesc)) or (UPPER(Manufacturer->Description) [ UPPER(:filterDesc)) or (UPPER(EQType->Description) [ UPPER(:filterDesc)) or :filterDesc is null)
}

/// Creator：        杨勤
/// CreatDate：      2017-08-22
/// Description：    查询手术包
/// Table：          DHCAN.SurgicalKits
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindSurgicalKits")
Query FindSurgicalKits(onlyMainKits As %String = "N", onlySubKits As %String = "N", filterDesc As %String = "", active As %String = "", hospId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT RowId,
           Code,
           Description,
           MainKit,
           MainKit As _parentId,
           MainKit->Description As MainKitDesc,
           Active,
           %External(Active) As ActiveDesc,
    	   Alias
           from CT_AN.SurgicalKit
           where (:onlyMainKits='N' or ((:onlyMainKits='Y') and (MainKit is null)))
           and (:onlySubKits='N' or ((:onlySubKits='Y') and (not MainKit is null)))
           and ((UPPER(Code) [ UPPER(:filterDesc)) or (UPPER(Description) [ UPPER(:filterDesc)) or (UPPER(Alias) [ UPPER(:filterDesc)) or (:filterDesc is null) or (MainKit is null))
           and ((Active=:active)  or (:active is null))
           and ((:hospId is null) or (DataAttribution is null) or (DataAttribution->HospitalID=:hospId))
           order by Code
}

/// Creator：        杨勤
/// CreatDate：      2017-08-23
/// Description：    查询手术包的手术物品
/// Table：          DHCAN.SurKitMaterial
/// Input:          SurgicalKits:手术包
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindSurKitMaterial","1")
Query FindSurKitMaterial(SurgicalKits As %String) As %SQLQuery(CONTAINID = 1)
{
    select RowId,
           SurgicalKit,
           SurgicalKit->Description As SurgicalKitDesc,
           SurgicalMaterial,
           SurgicalMaterial->Description As SurgicalMaterialDesc,
           SurgicalMaterial->Unit As Unit,
           DefaultQty,
           PericardialCut,
           Seq
           from CT_AN.SurgicalKitMat
           where (SurgicalKit=:SurgicalKits)
           order by Seq
}

/// Creator：        陈长青
/// CreatDate：      2018-5-28
/// Description：    查询模块数据选项
/// Table：          CT_AN.DataOptions
/// Input:          moduleID:数据模块ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindModDataOptions")
Query FindDataOptions(optsType As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT * 
       from CT_AN.DataOptions 
       where (OptsType=:optsType or :optsType is null)
}

/// Creator：        雍阳
/// CreatDate：      2018-5-30
/// Description：    查询用药途径
/// Table：          CT.AN.Instruction
/// Input:          null
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindInstruction")
Query FindInstruction(filterDesc As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT *,
    CIS_AN_COM.String_GetDescByID("User.PHCInstruc","PHCINDesc1",ExternalID) As ExternalDesc
    from CT_AN.Instruction
    where (UPPER(Description) [ UPPER(:filterDesc))
    or (UPPER(EnglishDesc) [ UPPER(:filterDesc))
    or (UPPER(Abbreviation) [ UPPER(:filterDesc))
    or (:filterDesc is null)
}

/// Creator：        雍阳
/// CreatDate：      2018-6-21
/// Description：    查询药物组
/// Table：          CT.AN.DrugGroup
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindDrugGroup")
Query FindDrugGroup(dataItemID As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT *
    from CT_AN.DrugGroup
    where (DataItem=:dataItemID) or (:dataItemID is null)
}

/// Creator：        雍阳
/// CreatDate：      2018-6-21
/// Description：    查询药物组项目
/// Table：          CT.AN.DrugGroup
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindDrugGroupItems")
Query FindDrugGroupItems(dataItemID As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT *,
           DoseUnit->Description As DoseUnitDesc,
           SpeedUnit->Description As SpeedUnitDesc,
           CIS_AN_COM.String_GetDescByID("User.ARCItmMast","ARCIMDesc",ArcimID) As ArcimDesc,
           CIS_AN_COM.String_GetDescByID("User.ARCItmMast","ARCIMPHCDFDR",ArcimID) As DrgFormID
    from CT_AN.DrugGroupItem
    where (DataItem=:dataItemID) or (:dataItemID is null)
}

/// Creator：        雍阳
/// CreatDate：      2018-8-14
/// Description：    查询速度单位
/// Table：          CT.AN.SpeedUnit
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindDrugGroup")
Query FindSpeedUnits(filterDesc As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT *,
    Uom -> Description As UnitDesc,
    DoseUom -> Description As DoseUnitDesc,
    TimeUom -> Description As TimeUnitDesc,
    WeightUom -> Description As WeightUnitDesc
    from CT_AN.SpeedUom
    where ((Uom -> Description [ :filterDesc) or (:filterDesc is null))
}

/// Creator：        雍阳
/// CreatDate：      2021-5-14
/// Description：    查询浓度单位
/// Table：          CT.AN.ConcentrationUom
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindConcentrationUom")
Query FindConcentrationUom(filterDesc As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT *,
    Uom -> Description As UomDesc,
    SoluteUom -> Description As SoluteUomDesc,
    SolventUom -> Description As SolventUomDesc
    from CT_AN.ConcentrationUom
    where ((Uom -> Description [ :filterDesc) or (:filterDesc is null))
}

/// Creator：        雍阳
/// CreatDate：      2017-12-25
/// Description：    查询麻醉插管
/// Table：          DHCAN.Catheter
/// Input:          null
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQuery","FindCatheter")
Query FindCatheter(anaestTypeID, anaestMethodID) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT *,
    %ID As RowId,
    CIS_AN_COM.String_GetDescByID('User.ORCAnaestMethod','ANMETDesc',AnaMethod) As AnaMethodDesc,
    CIS_AN_COM.String_GetDescByID('User.ORCAnaestType','ANTYPEDesc',AnaType) As AnaTypeDesc
    from CT_AN.Catheter
    where ((:anaestTypeID is null) and (:anaestMethodID is null)) 
    or ((AnaMethod=:anaestMethodID) or (AnaType=:anaestTypeID))
}

/// Creator：        雍阳
/// CreatDate：      2017-12-25
/// Description：    查询置管方向
/// Table：          DHCAN.CatheterDirection
/// Input:          null
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQuery","FindCatheterDirection")
Query FindCatheterDirection() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT *
    from CT_AN.CatheterDirection
}

/// Creator：        雍阳
/// CreatDate：      2017-12-25
/// Description：    查询置管工具
/// Table：          DHCAN.CatheterTool
/// Input:          null
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQuery","FindCatheterTool")
Query FindCatheterTool() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT *
    from CT_AN.CatheterTool
}

/// Creator：        雍阳
/// CreatDate：      2017-12-25
/// Description：    查询插管途径
/// Table：          DHCAN.CatheterPath
/// Input:          catheterID: 麻醉插管ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQuery","FindCatheterPath","1")
Query FindCatheterPath(catheterID As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT *,
    Catheter -> Description As CatheterDesc
    from CT_AN.CatheterPath
    where Catheter=:catheterID or Catheter is null
}

/// Creator：        雍阳
/// CreatDate：      2017-12-25
/// Description：    查询导管型号
/// Table：          DHCAN.CatheterType
/// Input:          catheterID: 麻醉插管ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindCatheterType","")
Query FindCatheterType(catheterID As %String, active As %String = "Y") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT *
    from CT_AN.CatheterType
    where (Catheter[:catheterID or :catheterID is null)
    and (Active=:active or :active is null)
    Order by SeqNo
}

/// Creator：        雍阳
/// CreatDate：      2017-12-25
/// Description：    查询置管深度
/// Table：          DHCAN.CatheterDepth
/// Input:          catheterID: 麻醉插管ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQuery","FindCatheterDepth","1")
Query FindCatheterDepth(catheterID As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT *,
    Catheter -> Description As CatheterDesc
    from CT_AN.CatheterDepth
    where Catheter=:catheterID or Catheter is null
}

/// Creator：        雍阳
/// CreatDate：      2017-12-25
/// Description：    查询穿刺间隙
/// Table：          DHCAN.PunctureSpace
/// Input:          null
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQuery","FindPunctureSpace")
Query FindPunctureSpace() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT *
    from CT_AN.PunctureSpace
}

/// Creator：        雍阳
/// CreatDate：      2017-12-25
/// Description：    查询定位方法
/// Table：          DHCAN.PositionMethod
/// Input:          null
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQuery","FindPositionMethod")
Query FindPositionMethod() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT *
    from CT_AN.PositionMethod
}

/// Creator：        雍阳
/// CreatDate：      2017-12-25
/// Description：    查询神经阻滞入路
/// Table：          CT.AN.NerveBlockSite
/// Input:          null
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindNerveBlockSite")
Query FindNerveBlockSite() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT *
    from CT_AN.NerveBlockSite
}

/// Creator：        陈长青
/// CreatDate：      2017-1-8
/// Description：    查询菜单
/// Table：          CT_AN.Menu
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindMenus")
Query FindMenus() As %SQLQuery(CONTAINID = 1)
{
SELECT * from CT_AN.Menu
}

/// Creator：        陈长青
/// CreatDate：      2017-1-8
/// Description：    查询菜单
/// Table：          CT_AN.Menu
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindMenuItems","","1")
Query FindMenuItems(filterDesc As %String = "", menuId As %String, mainMenu As %String = "N", hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT *,Menu->Description As MenuDesc,MainItem->Description As MainItemDesc,LinkModule->Description As LinkModuleDesc,MainItem As _parentId
	   from CT_AN.MenuItem
	   where ((UPPER(Description) [ UPPER(:filterDesc)) or (:filterDesc is null))
	   and (Menu=:menuId or (:menuId is null))
	   and ((MainItem is null) or :mainMenu='N')
	   and ((:hospId is null) or (DataAttribution is null) or (DataAttribution->HospitalID=:hospId))
	   order by Code
}

/// Creator：        陈长青
/// CreatDate：      2017-1-8
/// Description：    查询手术楼层
/// Table：          OperFloor
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindOperFloor")
Query FindOperLinkBodySite(bodySiteId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   Operation,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperation','OPERDesc',Operation) As OperDesc,
	   BodySite,
	   CIS_AN_COM.String_GetDescByID('User.OECBodySite','BODSDesc',BodySite) As BodySiteDesc
	   from CT_AN.OperLinkBodySite
	   where (BodySite=:bodySiteId) or (:bodySiteId is null)
}

/// Creator：        陈长青
/// CreatDate：      2017-1-8
/// Description：    查询手术楼层
/// Table：          OperFloor
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindOperRiskControl")
Query FindOperRiskControl(itemType As %String = "", Triggertiming As %String = "", hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	   %External(ControlType) As ControlTypeDesc,
	   %External(ItemType) As ItemTypeDesc,
	   %External(Emergency) As EmergencyDesc,
	   %External(LocalAnesthesia) As LocalAnesthesiaDesc,
	   %External(SecondCategory) As SecondCategoryDesc,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperation','OPERDesc',Operation) As OperDesc,
	   TriggerTiming->Description As TriggerTimingDesc,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperationCategory','CATEGDesc',OperCategoryControl) As OperCategoryControlDesc
	   from CT_AN.OperRiskControl
	   where (ItemType=:itemType) or (:itemType is null)
	   and (TriggerTiming=:Triggertiming or (:Triggertiming is null))
	   and ((:hospId is null) or (DataAttribution is null) or (DataAttribution->HospitalID=:hospId))
}

/// Creator：        杨国宾
/// CreatDate：      2020-02-04
/// Description：    查询医院名称
/// Table：          SQLUSER.ct.hospital
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindHospitalDesc")
Query FindHospitalDesc(hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
	SELECT hosp_desc from SQLUSER.ct_hospital where (HOSP_RowId=:hospId) or (:hospId is null)
}

/// Creator：        杨国宾
/// CreatDate：      2020-02-04
/// Description：    查询医院名称
/// Table：          SQLUSER.ct.hospital
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindHospitalDesc")
Query FindCFHospitalDesc(hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
	SELECT * from CF_AN.Hospital where (RowId=:hospId) or (:hospId is null)
}

/// Creator：        杨国宾
/// CreatDate：      2020-02-20
/// Description：    查询手术关联的手术部位
/// Table：          CT.AN.OperLinkBodySite
/// Input:          operId:手术名称Id
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindOperBodySite","1")
Query FindOperBodySite(operId As %String) As %SQLQuery(CONTAINID = 1)
{
    select RowId,
           Operation,
           CIS_AN_COM.String_GetDescByID('User.OECBodySite','BODSDesc',BodySite) As BodySiteDesc,
           BodySite
           from CT_AN.OperLinkBodySite
           where (Operation=:operId)
}

/// Creator：      	杨国宾
/// CreatDate：    	2020-02-21
/// Description： 	查询手术申请手术部位
/// Table：        	CT_AN.BodySite, CT_AN.OperLinkBodySite
/// Input:			operId:手术Id
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindBodySiteByOper","","z")
Query FindBodySiteByOper(operId As %String, filterDesc As %String = "") As %Query(ROWSPEC = "RowId,Code,Description,Note,ExternalID") [ SqlProc ]
{
}

ClassMethod FindBodySiteByOperExecute(ByRef qHandle As %Binary, operId As %String, filterDesc As %String = "") As %Status
{
	
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	s result=""
	s operBodyId="",BodySiteId=0
	s filterDesc=$System.SQL.ALPHAUP(filterDesc)
	if ((operId="")||($O(^CT.AN.OperLinkBodySiteI("IOperation"," "_operId,""))=""))
	{
		for{
				set BodySiteId=$O(^OEC("BODS",BodySiteId))
				quit:BodySiteId=""
				set RowId="",Code="",Description="",Note="",ExternalID="",Active=""
				set BodySite=##class(User.OECBodySite).%OpenId(BodySiteId)
				;set Active=BodySite.Active
				;continue:Active'="Y"
				set RowId=BodySiteId
				set Code=BodySite.BODSCode
				//set Description=BodySite.BODSDesc
    			set Description=##class(CIS.AN.COM.String).GetDescByID("User.OECBodySite","BODSDesc",RowId) //多语言改造翻译后台数据 YL 20221101
				set Note=""    ;BodySite.Note
				set ExternalID=""  ;BodySite.ExternalID
				set DescAlis=##class(web.DHCClinicCom).GetChinaChar(Description)
				continue:(filterDesc'="")&($System.SQL.ALPHAUP(Description)'[filterDesc)&($System.SQL.ALPHAUP(DescAlis)'[filterDesc)
				set result=$lb(RowId,Code,Description,Note,ExternalID)
				do OutputRow
			}
	}
	else{
		for{
				set operBodyId=$O(^CT.AN.OperLinkBodySiteI("IOperation"," "_operId,operBodyId))
				quit:operBodyId=""
				set RowId="",Code="",Description="",Note="",ExternalID="",Active=""
				set operBody=##class(CT.AN.OperLinkBodySite).%OpenId(operBodyId)
				set RowId=operBody.BodySite
				set BodySite=##class(User.OECBodySite).%OpenId(RowId)
				;set RowId=BodySiteId
				set Code=BodySite.BODSCode
				set Description=BodySite.BODSDesc
				set Note=""
				set ExternalID=""
				set DescAlis=##class(web.DHCClinicCom).GetChinaChar(Description)
				continue:(filterDesc'="")&($System.SQL.ALPHAUP(Description)'[filterDesc)&($System.SQL.ALPHAUP(DescAlis)'[filterDesc)
				set result=$lb(RowId,Code,Description,Note,ExternalID)
				do OutputRow
			}
	}

	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=result
	s ind=ind+1
	q
}

ClassMethod FindBodySiteByOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBodySiteByOperExecute ]
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

ClassMethod FindBodySiteByOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBodySiteByOperExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：        杨国宾
/// CreatDate：      2020-06-15
/// Description：    查询错误日志
/// Table：          CT.AN.ErrorLog
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindANErrorLog","2020-06-12","2020-06-12","")
Query FindANErrorLog(sDate As %String, eDate As %String, DateModule As %String) As %SQLQuery(CONTAINID = 1)
{
    select RowId,
    	   DataModule,
    	   DataModule ->Description As DataModuleDesc,
           ClientIP,
           %ODBCOUT(LogDate) As LogDate,
           %ODBCOUT(LogTime) As LogTime,
           UserID,
           CIS_AN_COM.String_GetDescByID("User.SSUser","SSUSRName",UserID) As UserDesc,
           GroupID,
           CIS_AN_COM.String_GetDescByID("User.SSGroup","SSGRPDesc",GroupID) As GroupDesc,
           DeptID,
           CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",DeptID) As CTLOCDesc
    	   from CIS_AN.Errorlog where LogDate>=%ODBCIN(:sDate) and LogDate<=%ODBCIN(:eDate)
    	   and ((DataModule=:DateModule) or (:DateModule is null))
}

/// w ##class(CIS.AN.BL.CodeQueries).GetErrotLogInfo("RequestData",1800)
ClassMethod GetErrotLogInfo(field As %String, rowId As %String)
{
	quit:rowId="" ""
	set retError="",RequestData="",ret=""
	&sql(SELECT ErrorMsg,RequestData into:retError,:RequestData FROM sqluser.CIS_AN.Errorlog WHERE RowId=:rowId)
	if field="ErrorMsg" set ret=retError
	if field="RequestData" set ret=RequestData
	quit ret
}

/// Creator：        杨国宾
/// CreatDate：      2020-08-14
/// Description：    查询手术物品
/// Table：          CT.AN.SurgicalMaterial
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindSurgicalMaterials")
Query FindSurgicalMaterials(filterDesc As %String = "", hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
    select * from CT_AN.SurgicalMaterial
    where ((Description [ :filterDesc) or (:filterDesc is null) or (UPPER(Note) like UPPER('%'_:filterDesc_'%')))
    	and ((:hospId is null) or (DataAttribution is null) or (DataAttribution->HospitalID=:hospId))
}

/// Creator：        陈长青
/// CreatDate：      2020-09-02
/// Description：    查询数据字典
/// Table：          CT.AN.Dictionary
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindDictionary")
Query FindDictionary() As %SQLQuery(CONTAINID = 1)
{
    select * from CT_AN.Dictionary
}

/// Creator：        陈长青
/// CreatDate：      2020-09-02
/// Description：    查询字典数据
/// Table：          CT.AN.Dictionary
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindDictionary")
Query FindDictData(dictId As %String) As %SQLQuery(CONTAINID = 1)
{
    select * from CT_AN.DictData where Dictionary=:dictId
}

/// Creator：        陈长青
/// CreatDate：      2020-09-02
/// Description：    根据字典代码查询字典数据
/// Table：          CT.AN.Dictionary
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindDictDataByCode","ABO")
Query FindDictDataByCode(dictCode As %String) As %SQLQuery(CONTAINID = 1)
{
    select * from CT_AN.DictData where Dictionary->Code=:dictCode order by RowId
}

/// Creator：        杨国宾
/// CreatDate：      2020-09-11
/// Description：    查询手术交接节点
/// Table：          CIS.AN.PatTransLocation
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindPatTransLocation","输血交接")
Query FindPatTransLocation(Type As %String = "", hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
   select * from CT_AN.PatTransLocation 
   where (Type [ :Type) or (:Type is null) 
   and ((:hospId is null) or (DataAttribution is null) or (DataAttribution->HospitalID=:hospId))
   order BY Type,order
}

/// Creator：        yongyang
/// CreatDate：      2020-11-16
/// Description：    查询输液通路
/// Table：          CT.AN.InjectionSite
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQuery","FindInjectionSite","")
Query FindInjectionSite(filterDesc As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    select *,
    		Legend->Description As LegendDesc
     from CT_AN.InjectionSite
     where (:filterDesc is null) or (Description [:filterDesc)
}

/// Creator：        yongyang
/// CreatDate：      2021-07-19
/// Description：    查询基础数据表的多院区权限类型
/// Table：          CT.AN.TablePermission
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindTablePermission")
Query FindTablePermission() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select *,
    	%External(Permission) As PermissionDesc
     from CT_AN.TablePermission
}

/// Creator：        杨国宾
/// CreatDate：      2022-05-31
/// Description：    查询麻醉事件控制表
/// Table：          CF.AN.EvevtContral
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CodeQueries","FindTablePermission")
Query FindEventControl() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select *,
	Event->Code As EventCode,
	Event->Description As EventDesc
     from CF_AN.EventControl order by Order
}

}
