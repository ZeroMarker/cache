Class web.DHCENS.STBLL.DRUG.MODEL.DrugPackageLab Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLNAME = "DrugOrdInfo";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 打印条码号
Property DrugPackageLab As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "DrugPackageLab");

/// 服药日期
Property OccDate As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "OccDate");

/// 服药时间
Property OccTime As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "OccTime");

/// 医嘱RowID
Property OrdRowID As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "OrdRowID");

}
