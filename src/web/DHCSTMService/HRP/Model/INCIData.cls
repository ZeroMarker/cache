Class web.DHCSTMService.HRP.Model.INCIData Extends XmlCommon
{

Parameter XMLNAME = "INCIData";

Property HospitalCode As %Library.String(MAXLEN = "", XMLNAME = "HospitalCode");

Property InciCode As %Library.String(MAXLEN = "", XMLNAME = "InciCode");

Property InciDesc As %Library.String(MAXLEN = "", XMLNAME = "InciDesc");

Property Spec As %Library.String(MAXLEN = "", XMLNAME = "Spec");

Property BUom As %Library.String(MAXLEN = "", XMLNAME = "BUom");

Property PUom As %Library.String(MAXLEN = "", XMLNAME = "PUom");

Property PFac As %Integer(XMLNAME = "PFac");

Property IncscDesc As %Library.String(MAXLEN = "", XMLNAME = "IncscDesc");

Property Rp As %Float(XMLNAME = "Rp");

Property Sp As %Float(XMLNAME = "Sp");

Property HVFlag As %Library.String(MAXLEN = "", XMLNAME = "HVFlag");

Property TableFlag As %Library.String(MAXLEN = "", XMLNAME = "TableFlag");

Property RegCertNo As %Library.String(MAXLEN = "", XMLNAME = "RegCertNo");

Property RegCertExpDate As %Date(XMLNAME = "RegCertExpDate");

Property PbVendor As %Library.String(MAXLEN = "", XMLNAME = "PbVendor");

Property Manf As %Library.String(MAXLEN = "", XMLNAME = "Manf");

Property Brand As %Library.String(MAXLEN = "", XMLNAME = "Brand");

Property Model As %Library.String(MAXLEN = "", XMLNAME = "Model");

Property ChargeFlag As %Library.String(MAXLEN = "", XMLNAME = "ChargeFlag");

Property Abbrev As %Library.String(MAXLEN = "", XMLNAME = "Abbrev");

Property UserInitial As %Library.String(MAXLEN = "", XMLNAME = "UserInitial");

Property LocDesc As %Library.String(MAXLEN = "", XMLNAME = "LocDesc");

Property NotUseFlag As %Library.String(MAXLEN = "", XMLNAME = "NotUseFlag");

Property OperationState As %Library.String(MAXLEN = "", XMLNAME = "OperationState");

Property ImpFlag As %Library.String(MAXLEN = "", XMLNAME = "ImpFlag");

Property ZeroStk As %Library.String(MAXLEN = "", XMLNAME = "ZeroStk");

Property InsuPurPlanCode As %Library.String(MAXLEN = "", XMLNAME = "InsuPurPlanCode");

Property ArcimId As %Library.String(MAXLEN = "", XMLNAME = "ArcimId");

Property ArcData As list Of web.DHCSTMService.HRP.Model.ArcData(XMLNAME = "ArcData", XMLPROJECTION = "element");

}
