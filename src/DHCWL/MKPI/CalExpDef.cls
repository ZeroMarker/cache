/// DHCWL_MKPI.CalExpDef   d ##class(DHCWL.MKPI.CalExpDef).%BuildIndices()
Class DHCWL.MKPI.CalExpDef Extends %Persistent [ SqlTableName = CalExpDef ]
{

Property CalExp As %String(MAXLEN = 250) [ SqlColumnNumber = 2, SqlFieldName = CalExp_Exp ];

Property SumDim As %String(MAXLEN = 250) [ SqlColumnNumber = 3, SqlFieldName = CalExp_SumDim ];

Property KpiCode As %String(COLLATION = "EXACT") [ SqlColumnNumber = 4, SqlFieldName = CalExp_KpiCode ];

Index KPICODE On KpiCode;

ClassMethod DelCalExpByKPIIDs(kpiIDs As %String) As %String
{
	s ret="ok"
	s happedErr=0
	s kpiLen=$l(kpiIDs,",")
	f i=1:1:kpiLen {
		q:happedErr=1
		s kpiID=$p(kpiIDs,",",i)
		s kpiCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(kpiID,"DHCWL.MKPI.MKPI")	
		continue:kpiCode=""
		
		continue:'$d(^DHCWL.MKPI.CalExpDefI("KPICODE",kpiCode))
		s ID=$o(^DHCWL.MKPI.CalExpDefI("KPICODE",kpiCode,""))
		continue:ID=""

		s sc=##class(DHCWL.MKPI.CalExpDef).%DeleteId(ID)
		If $$$ISERR(sc) {
			s ret=$System.Status.GetErrorText(sc)
			s happedErr=1
		}
		
	}
	q ret
}

Storage Default
{
<Data name="CalExpDefDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CalExp</Value>
</Value>
<Value name="3">
<Value>SumDim</Value>
</Value>
<Value name="4">
<Value>KpiCode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.CalExpDefD</DataLocation>
<DefaultData>CalExpDefDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.CalExpDefD</IdLocation>
<IndexLocation>^DHCWL.MKPI.CalExpDefI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.CalExpDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
