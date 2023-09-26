Class web.AuditWorkStatic Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod GetDep(StrDate)
{
	s UserRowId="",DateRowId="",TimeRowId="",AdmRowId=""	
	f  s UserRowId=$o(^DHCZYJFConfirm("CConfirm",UserRowId)) q:UserRowId=""  d
	.f  s DateRowId=$o(^DHCZYJFConfirm("CConfirm",UserRowId,DateRowId)) q:DateRowId=""  d
	..f  s TimeRowId=$o(^DHCZYJFConfirm("CConfirm",UserRowId,DateRowId,TimeRowId)) q:TimeRowId=""  d
	...f  s AdmRowId=$o(^DHCZYJFConfirm("CConfirm",UserRowId,DateRowId,TimeRowId,AdmRowId)) q:AdmRowId=""  d
	....s upddate=$p(^DHCZYJFConfirm("CConfirm",UserRowId,DateRowId,TimeRowId,AdmRowId),"^",1)
	....q:($zd(upddate,3)'=StrDate)
	....s updtime=$p(^DHCZYJFConfirm("CConfirm",UserRowId,DateRowId,TimeRowId,AdmRowId),"^",2)
	....s admrowid=$p(^DHCZYJFConfirm("CConfirm",UserRowId,DateRowId,TimeRowId,AdmRowId),"^",3)
	....s guser=$p(^DHCZYJFConfirm("CConfirm",UserRowId,DateRowId,TimeRowId,AdmRowId),"^",4)
	....w !,$zd(upddate,3)_"^"_$zt(updtime,1)_"^"_admrowid_"^"_guser
}

Storage Default
{
<Data name="AuditWorkStaticDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.AuditWorkStaticD</DataLocation>
<DefaultData>AuditWorkStaticDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.AuditWorkStaticD</IdLocation>
<IndexLocation>^web.AuditWorkStaticI</IndexLocation>
<StreamLocation>^web.AuditWorkStaticS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
