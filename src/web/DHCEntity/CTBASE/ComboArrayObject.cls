Class web.DHCEntity.CTBASE.ComboArrayObject Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter ListSplitStr = "$c(1)";

Parameter ValueSplitStr = "$c(2)";

/// 默认标志   0 or 1
Property DefaultFlag As %String(TRUNCATE = 1);

Property ObjectRowID As %String(TRUNCATE = 1);

Property Text As %String(TRUNCATE = 1);

Property AliasStr As %String(TRUNCATE = 1);

Method GetArray() As %String
{
	s myrtn=..ObjectRowID_..#ValueSplitStr_..Text_..#ValueSplitStr_..DefaultFlag_..#ValueSplitStr_..AliasStr
	q myrtn
}

}
