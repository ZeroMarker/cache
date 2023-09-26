Class web.DHCClinic.DHCClinicQuery Extends %RegisteredObject
{

Query FindRecordCategory() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   ANCVSC_Code As Code,
	   ANCVSC_Desc As Description
	   from SQLUser.DHC_ANC_ViewSuperCat
}

/// 查找手术楼层
Query FindOperFloor() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   ANCF_Code As Code,
	   ANCF_Desc As Description
	   from SQLUser.DHC_ANC_Floor
}

/// 采集设备型号
Query FindAvailableCollType(production As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   ANCCT_Code As Code,
	   ANCCT_Desc As Description,
	   ANCCT_Active As Active,
	   ANCCT_Type As ProdCode,
	   %EXTERNAL(ANCCT_Type) As ProdDesc
	   from SQLUser.DHC_ANC_CollectType
	   where ANCCT_Active="Y" and ANCCT_Type=:production
}

/// 查找手术级别
Query FindOperLevel() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   ANCOPL_Code As Code,
	   ANCOPL_Desc As Description
	   from SQLUser.DHC_ANC_OPLevel
}

/// 查找手术分类
Query FindOperCategory() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   CATEG_Code As Code,
	   CATEG_Desc As Description
	   from SQLUser.ORC_OperationCategory
}

/// 查找切口类型
Query FindBladeType() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   BLDTP_Code As Code,
	   BLDTP_Desc As Description
	   from SQLUser.ORC_BladeType
}

/// 查找手术体位
Query FindOperPosition() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   OPPOS_Code As Code,
	   OPPOS_Desc As Description
	   from SQLUser.ORC_OperPosition
}

/// 查找身体部位
Query FindBodySite() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   BODS_Code As Code,
	   BODS_Desc As Description
	   from SQLUser.OEC_BodySite
}

/// 查找医院名称
Query FindHospital() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   HOSP_Code As Code,
	   HOSP_Desc As Description
	   from SQLUser.DHC_CL_Hospital
}

/// 查找ASA分级
Query FindASAClass() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   ORASA_Code As Code,
	   ORASA_Desc As Description
	   from SQLUser.ORC_ASA_ClassPhActiv
}

/// 查找麻醉类型
Query FindAnaestType() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   ANTYPE_Code As Code,
	   ANTYPE_Desc As Description,
	   %ODBCOUT(ANTYPE_DateFrom) As DateFrom,
	   %ODBCOUT(ANTYPE_DateTo) As DateTo
	   from SQLUser.ORC_AnaestType
}

/// 查找麻醉方法
Query FindAnaestMethod() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   ANMET_Code As Code,
	   ANMET_Desc As Description,
	   %ODBCOUT(ANMET_DateFrom) As DateFrom,
	   %ODBCOUT(ANMET_DateTo) As DateTo,
	   ANMET_Type_DR As AnaestTypeId,
	   ANMET_Type_DR->ANTYPE_Desc As AnaestType
	   from SQLUser.ORC_AnaestMethod
}

/// 查找麻醉分级
Query FindAnaestClass() As %SQLQuery(CONTAINID = 1)
{
SELECT * from SQLUser.DHC_ANC_AnaestClass where %ID>0
}

/// 查找麻醉图例
Query FindAnaestIcon() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   ANI_Code As Code,
	   ANI_Desc As Description,
	   ANI_Count As DotCount,
	   ANI_Height As Height,
	   ANI_Width As Width,
	   ANI_PositionX As PosX,
	   ANI_PositionY As PosY,
	   ANI_LineWidth As LineWidth,
	   ANI_Shape As Shape,
	   ANI_Data As PathData
	   from SQLUser.DHC_ANC_Icon
}

/// 查找手术清点类型
Query FindOPCountType() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   ANCOPCT_Code As Code,
	   ANCOPCT_Desc As Description,
	   ANCOPCT_ParentType As _parentId,
	   ANCOPCT_ParentType->ANCOPCT_Desc As ParentType
	   from SQLUser.DHC_ANC_OPCountType
}

/// 查找手术清点项
Query FindOPCount() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As RowId,
	   ANCOPC_Code As Code,
	   ANCOPC_Desc As Description
	   from SQLUser.DHC_ANC_OPCount
}

}
