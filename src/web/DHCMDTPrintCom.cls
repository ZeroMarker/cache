Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2019-04-15
/// Descript: 	MDT会诊打印公共类
Class web.DHCMDTPrintCom Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Storage Default
{
<Data name="DHCMDTPrintComDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCMDTPrintComD</DataLocation>
<DefaultData>DHCMDTPrintComDefaultData</DefaultData>
<IdLocation>^web.DHCMDTPrintComD</IdLocation>
<IndexLocation>^web.DHCMDTPrintComI</IndexLocation>
<StreamLocation>^web.DHCMDTPrintComS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
