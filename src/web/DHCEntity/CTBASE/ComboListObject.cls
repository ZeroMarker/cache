Class web.DHCEntity.CTBASE.ComboListObject Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter ListSplitStr = "$c(1)";

Property ListValues As list Of web.DHCEntity.CTBASE.ComboArrayObject;

Method GetListValue() As %String
{
	s myrtnval=""
	s myCount=..ListValues.Count()
	f myIdx=1:1:myCount {
		s myval=..ListValues.GetAt(myIdx).GetArray()
		i myrtnval="" {
			s myrtnval=myval
		}else{
			s myrtnval=myrtnval_..#ListSplitStr_myval
		}
	}
	q myrtnval
}

Method Put(RowID As %String, Text As %String, DefaultFlag As %String, AliasStr As %String = "") As %String
{
	s myobj=##class(web.DHCEntity.CTBASE.ComboArrayObject).%New()
	s myobj.ObjectRowID=RowID
	s myobj.Text=Text
	;w myobj.Text,!
	s myobj.DefaultFlag=DefaultFlag
	s myobj.AliasStr=AliasStr
	d ..ListValues.Insert(myobj)
	q ""
}

}
