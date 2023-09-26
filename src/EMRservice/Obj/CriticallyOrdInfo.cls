Class EMRservice.Obj.CriticallyOrdInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "CriticallyOrd";

Parameter XMLTYPE = "CriticallyOrd";

Parameter XMLIGNORENULL = 1;

/// 医嘱RowID
Property OrdRowID As %String;

/// 医嘱名称
Property OrdDesc As %String;

}
