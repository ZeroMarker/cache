Class web.DHCXPTest Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCXPTest).GetDiagnose()
ClassMethod GetDiagnose(mradm As %String) As %Status
{
	S kid=""
	s Childsub=0 f  s Childsub=$o(^MR(mradm,"DIA",Childsub)) q:Childsub=""  d
	.s kid=mradm_"||"_Childsub
	Q kid
}

/// w ##class(web.DHCXPTest).Insert()
ClassMethod Insert() As %String
{
	// w $$InsertMultiple^DHCDocOrderCommonNew(148,"8872||1^N^3^24/04/2012^10:31^^150^1^1^^^^^1^64^^^^^1^N^^Y^^^^^^^N^^^^^^^^^^N^^^^^^24/04/2012^10:31^N^^",600,6,838,"LABDATA")
	//s OrderRtnStr=##class(web.DHCDocService).InsertOrderItem(148,"8872||1^N^3^24/04/2012^10:31^^150^1^1^^^^^1^64^^^^^1^N^^Y^^^^^^^N^^^^^^^^^^N^^^^^^24/04/2012^10:31^N^^",600,6,838)
	s OrderRtnStr=##class(web.DHCDocService).InsertOrderItem(108,"11777||1^200^95^^^^^^"_$c(1),158,"",158)

	q OrderRtnStr
}

Storage Default
{
<Data name="DHCXPTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCXPTestD</DataLocation>
<DefaultData>DHCXPTestDefaultData</DefaultData>
<IdLocation>^web.DHCXPTestD</IdLocation>
<IndexLocation>^web.DHCXPTestI</IndexLocation>
<StreamLocation>^web.DHCXPTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
