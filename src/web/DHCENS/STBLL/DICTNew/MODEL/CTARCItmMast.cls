Class web.DHCENS.STBLL.DICTNew.MODEL.CTARCItmMast Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_ARCItmMast";

/// 代码
Property CTARCIMCode As %Library.String(MAXLEN = 50, XMLNAME = "CTARCIM_Code");

/// 描述
Property CTARCIMDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTARCIM_Desc");

/// 单位
Property CTARCIMUnit As %Library.String(MAXLEN = 50, XMLNAME = "CTARCIM_Unit");

/// 医嘱子类代码
Property CTARCIMChildCategory As %Library.String(MAXLEN = 50, XMLNAME = "CTARCIM_ChildCategory");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTARCIMCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTARCIM_CodesystemCode");

/// 状态（1启用,0停用,-1删除）
Property CTARCIMStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTARCIM_Status");

/// 最后更新人编码
Property CTARCIMUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTARCIM_UpdateUserCode");

/// 最后更新日期
Property CTARCIMUpdateDate As %Library.Date(XMLNAME = "CTARCIM_UpdateDate");

/// 最后更新时间
Property CTARCIMUpdateTime As %Library.Time(XMLNAME = "CTARCIM_UpdateTime");

/// 备注
Property CTARCIMRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTARCIM_Remarks");

/// 有效开始日期
Property CTARCIMStartDate As %Library.Date(XMLNAME = "CTARCIM_StartDate");

/// 有效结束日期
Property CTARCIMEndDate As %Library.Date(XMLNAME = "CTARCIM_EndDate");

/// 别名
Property CTARCIMAnoName As %Library.String(MAXLEN = 100, XMLNAME = "CTARCIM_AnoName");

/// 账单子类代码
Property CTARCIMBillSubCat As %Library.String(MAXLEN = 100, XMLNAME = "CTARCIM_BillSubCat");

/// 药品标识
Property CTARCIMDrugFlag As %Library.String(MAXLEN = 100, XMLNAME = "CTARCIM_DrugFlag");

/// 耗材标识
Property CTARCIMConsumFlag As %Library.String(MAXLEN = 100, XMLNAME = "CTARCIM_ConsumFlag");

/// 医院代码
Property CTARCIMHosCode As %Library.String(MAXLEN = 100, XMLNAME = "CTARCIM_HosCode");

/// 创建日期
Property CTARCIMCreatDate As %Library.Date(XMLNAME = "CTARCIM_CreatDate");

/// 创建时间
Property CTARCIMCreatTime As %Library.Time(XMLNAME = "CTARCIM_CreatTime");

/// 原代码
Property CTARCIMOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTARCIM_OriginalCode");

/// 原描述
Property CTARCIMOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTARCIM_OriginalDesc");

/// 价格
Property CTARCIMPrice As %Library.String(XMLNAME = "CTARCIM_Price");

/// 是否可自主定价
Property CTARCIMAutoDecidePriceFlag As %Library.String(XMLNAME = "CTARCIM_AutoDecidePriceFlag");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
