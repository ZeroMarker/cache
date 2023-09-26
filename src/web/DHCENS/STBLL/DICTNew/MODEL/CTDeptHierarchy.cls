Class web.DHCENS.STBLL.DICTNew.MODEL.CTDeptHierarchy Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_DeptHierarchy";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 科室类别
Property CTDHClass As %Library.String(MAXLEN = 50, XMLNAME = "CTDH_Class");

/// 科室代码
Property CTDHCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDH_Code");

/// 上级科室代码
Property CTDHParentCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDH_ParentCode");

/// 科室描述
Property CTDHDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTDH_Desc");

/// 科室类型
Property CTDHCategoryCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDH_CategoryCode");

/// 拼音
Property CTDHPhonetic As %Library.String(MAXLEN = 50, XMLNAME = "CTDH_Phonetic");

/// 病区标识
Property CTDHWardFlag As %Library.String(MAXLEN = 50, XMLNAME = "CTDH_WardFlag");

/// 创建日期
Property CTDHCreatDate As %Library.Date(XMLNAME = "CTDH_CreatDate");

/// 创建时间
Property CTDHCreatTime As %Library.Time(XMLNAME = "CTDH_CreatTime");

/// 更新日期
Property CTDHUpdateDate As %Library.Date(XMLNAME = "CTDH_UpdateDate");

/// 更新时间
Property CTDHUpdateTime As %Library.Time(XMLNAME = "CTDH_UpdateTime");

/// 原代码
Property CTDHOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDH_OriginalCode");

/// 原描述
Property CTDHOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTDH_OriginalDesc");

/// 科室备注
Property CTDHRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDH_Remarks");

/// 有效开始日期
Property CTDHStartDate As %Library.Date(XMLNAME = "CTDH_StartDate");

/// 有效结束日期
Property CTDHEndDate As %Library.Date(XMLNAME = "CTDH_EndDate");

/// 代码表类型
Property CTDHCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDH_CodesystemCode");

/// 工作地址
Property CTDHOfficeAddress As %Library.String(MAXLEN = 200, XMLNAME = "CTDH_OfficeAddress");

/// 工作联系电话
Property CTDHOfficePhone As %Library.String(MAXLEN = 50, XMLNAME = "CTDH_OfficePhone");

/// 最后更新人编码
Property CTDHUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDH_UpdateUserCode");

/// 医院代码
Property CTDHHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDH_HosCode");

/// 科室部门组代码
Property CTDHDepartmentGroup As %Library.String(MAXLEN = 50, XMLNAME = "CTDH_DepartmentGroup");

/// 科室按就诊分类
Property CTDHAdmType As %Library.String(MAXLEN = 50, XMLNAME = "CTDH_AdmType");

/// 状态
Property CTDHStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDH_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
