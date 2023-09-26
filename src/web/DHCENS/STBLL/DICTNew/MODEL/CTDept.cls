Class web.DHCENS.STBLL.DICTNew.MODEL.CTDept Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Dept";

/// 代码
Property CTDCode As %Library.String(MAXLEN = 50, XMLNAME = "CTD_Code");

/// 描述
Property CTDDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTD_Desc");

/// 标识分类代码
Property CTDCategoryCode As %Library.String(MAXLEN = 50, XMLNAME = "CTD_CategoryCode");

/// 工作地址
Property CTDOfficeAddress As %Library.String(MAXLEN = 200, XMLNAME = "CTD_OfficeAddress");

/// 工作联系电话
Property CTDOfficePhone As %Library.String(MAXLEN = 50, XMLNAME = "CTD_OfficePhone");

/// 上级科室代码 CT_Dept.CTDCode
Property CTDParentDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "CTD_ParentDeptCode");

/// 上级科室代码 CT_Dept.CTDCode
Property CTDParentDeptDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTD_ParentDeptDesc");

/// 代码表类型 
Property CTDCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTD_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTDStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTD_Status");

/// 最后更新人编码
Property CTDUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTD_UpdateUserCode");

/// 最后更新日期
Property CTDUpdateDate As %Library.Date(XMLNAME = "CTD_UpdateDate");

/// 最后更新时间
Property CTDUpdateTime As %Library.Time(XMLNAME = "CTD_UpdateTime");

/// 备注
Property CTDRemarks As %Library.String(MAXLEN = 1000, XMLNAME = "CTD_Remarks");

/// 医院编号
Property CTDHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTD_HosCode");

/// 拼音
Property CTDSpell As %Library.String(MAXLEN = 50, XMLNAME = "CTD_Spell");

/// 科室类别
Property CTDCategory As %Library.String(MAXLEN = 50, XMLNAME = "CTD_Category");

/// 科室部门组代码
Property CTDGroupCode As %Library.String(MAXLEN = 50, XMLNAME = "CTD_GroupCode");

/// 科室部门组描述
Property CTDGroupDesc As %Library.String(MAXLEN = 50, XMLNAME = "CTD_GroupDesc");

/// 科室性质
Property CTDProperty As %Library.String(MAXLEN = 50, XMLNAME = "CTD_Property");

/// 部门属性
Property CTDDepartNature As %Library.String(MAXLEN = 50, XMLNAME = "CTD_DepartNature");

/// 科室级次
Property CTDRank As %Library.String(MAXLEN = 50, XMLNAME = "CTD_Rank");

/// 顶级科室代码
Property CTDSuperDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "CTD_SuperDeptCode");

/// 顶级科室描述
Property CTDSuperDeptDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTD_SuperDeptDesc");

/// 一级科室类型  展示 核算 （核算类型数据不发送给预约平台和自助机）
Property CTDParentDeptType As %Library.String(MAXLEN = 50, XMLNAME = "CTD_ParentDeptType");

/// 拼音码
Property CTDPhonetic As %Library.String(MAXLEN = 50, XMLNAME = "CTD_Phonetic");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTDOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTD_OriginalCode");

/// 原描述
Property CTDOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTD_OriginalDesc");

/// 有效开始日期
Property CTDStartDate As %Library.Date(XMLNAME = "CTD_StartDate");

/// 有效结束日期
Property CTDEndDate As %Library.Date(XMLNAME = "CTD_EndDate");

/// 创建日期
Property CTDCreatDate As %Library.Date(XMLNAME = "CTD_CreatDate");

/// 创建时间
Property CTDCreatTime As %Library.Time(XMLNAME = "CTD_CreatTime");

/// id
Property CTDRowId As %Library.String(MAXLEN = 50, XMLNAME = "CTD_RowId");

/// 科室部门组代码
Property CTDDepartmentGroup As %Library.String(MAXLEN = 50, XMLNAME = "CTD_DepartmentGroup");

/// 科室按就诊分类
Property CTDAdmType As %Library.String(MAXLEN = 50, XMLNAME = "CTD_AdmType");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
