Class web.DHCENS.STBLL.DICTNew.MODEL.CTObservationItem Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_ObservationItem";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 项目代码
Property CTOICode As %String(MAXLEN = 50, XMLNAME = "CTOI_Code");

/// 项目名称
Property CTOIDesc As %String(MAXLEN = 100, XMLNAME = "CTOI_Desc");

/// 代码表类型
Property CTOICodesystemCode As %String(MAXLEN = 50, XMLNAME = "CTOI_CodesystemCode");

/// 备注
Property CTOIRemarks As %String(MAXLEN = 100, XMLNAME = "CTOI_Remarks");

/// 状态
Property CTOIStatus As %String(MAXLEN = 2, XMLNAME = "CTOI_Status");

/// 值类型
Property CTOIInputType As %String(MAXLEN = 50, XMLNAME = "CTOI_InputType");

/// 值单位
Property CTOIInputUnit As %String(MAXLEN = 50, XMLNAME = "CTOI_InputUnit");

/// 输出类型
Property CTOIValueType As %String(MAXLEN = 50, XMLNAME = "CTOI_ValueType");

/// 最后更新日期
Property CTOIUpdateDate As %Date(XMLNAME = "CTOI_UpdateDate");

/// 最后更新时间
Property CTOIUpdateTime As %Time(XMLNAME = "CTOI_UpdateTime");

/// 最后更新人编码
Property CTOIUpdateUserCode As %String(MAXLEN = 50, XMLNAME = "CTOI_UpdateUserCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
