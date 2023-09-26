Class DHCMGNUR.MgNurQcModChildSub Extends %Persistent
{

Relationship ParrefSub As DHCMGNUR.MgNurQcModelChild [ Cardinality = parent, Inverse = SunSub, Required ];

Property QualItem As DHCMGNUR.QualCodeItemSub [ SqlColumnNumber = 2, SqlFieldName = Qual_Item ];

Property ItemCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Item_Code ];

Property ItemLevel As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = Item_Level ];

Property ItemDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Item_Desc ];

Property ItemValue As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Item_Value ];

Property MinLevel As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Min_Level ];

Property ChildPar As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Child_Par ];

Property ChildRw As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = Child_Rw ];

ClassMethod SaveSunItms(parr As %String) As %String
{
	s ^TEMP("g06141602001")=parr
	//PRow|3^RowID|6^ItemCode|1.1^ItemDesc|仪器未按时清点记录，无护士长签字^ItemLevel|1^ItemValue|1^MinLevel|Y^sunRowId|^ChildPar|9^ChildRw|2
	s tmp=""
	s aa=##class(web.DHCMgNurQcRestruct).settmp(parr,.tmp)
	s id=$g(tmp("sunRowId"))
	i id="" d
	.s obj=##class(DHCMGNUR.MgNurQcModChildSub).%New()
	.s obj.ParrefSub=##class(DHCMGNUR.MgNurQcModelChild).%OpenId(tmp("PRow")_"||"_tmp("RowID"))
	e  s obj=##class(DHCMGNUR.MgNurQcModChildSub).%OpenId(tmp("PRow")_"||"_tmp("RowID")_"||"_id)
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.MgNurQcModChildSub","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s tmp(p)=$zcvt($tr(tmp(p)," ",""),"U")
	..i p="QualItem" d
	...s tmp(p)=$replace(tmp(p),"!","||")
	...s $ZOBJPROPERTY(obj,p)=##class(DHCMGNUR.QualCodeItemSub).%OpenId(tmp("ChildPar")_"||"_tmp("ChildRw"))
	..e  d
	...s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

ClassMethod isExistRec(parr As %String) As %String
{
	//PRow|3^RowID|6^ItemCode|1.1^ItemDesc|仪器未按时清点记录，无护士长签字^ItemLevel|1^ItemValue|1^MinLevel|Y^sunRowId|^ChildPar|9^ChildRw|2
	s PRow=$P($P(parr,"^",1),"|",2)
	s RowID=$P($P(parr,"^",2),"|",2)
	s ItemDesc=$P($P(parr,"^",4),"|",2)
	s ret=0
	s raw="" f  s raw=$O(^DHCMGNUR.MgNurQcModChildSubD(PRow,RowID,raw)) q:raw=""  d
	.s obj=##class(DHCMGNUR.MgNurQcModChildSub).%OpenId(PRow_"||"_RowID_"||"_raw)
	.i obj.ItemDesc=ItemDesc s ret=1
	q ret
}

ClassMethod delSunData(par, rw, raw) As %String
{
	d ##class(DHCMGNUR.MgNurQcModChildSub).%DeleteId(par_"||"_rw_"||"_raw)
	q 0
}

Storage Default
{
<Data name="MgNurQcModChildSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QualItem</Value>
</Value>
<Value name="3">
<Value>ItemCode</Value>
</Value>
<Value name="4">
<Value>ItemLevel</Value>
</Value>
<Value name="5">
<Value>ItemDesc</Value>
</Value>
<Value name="6">
<Value>ItemValue</Value>
</Value>
<Value name="7">
<Value>MinLevel</Value>
</Value>
<Value name="8">
<Value>ChildPar</Value>
</Value>
<Value name="9">
<Value>ChildRw</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurQcModChildSubD</DataLocation>
<DefaultData>MgNurQcModChildSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("SunSub")</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurQcModChildSubI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurQcModChildSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
