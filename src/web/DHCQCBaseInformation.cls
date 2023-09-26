Class web.DHCQCBaseInformation Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator：      DaiYi
/// CreatDate：    20110524
/// Description:： 手工导入数据
/// Table：        DHCQC_TmpResult
/// Input：        仪器结果 
/// Output：       仪器结果。
/// Return：       0
/// Others：
/// d ##class(web.DHCQCCreatData).AddMachineQCData()
ClassMethod QueryHosptalInfmation(Hospital As %String) As %String
{
	Set HosptalName=""
	If $Data(^CF("SM",1)) Do
	.Set HosptalName=$Piece($Get(^CF("SM",1)),"^",5)
	Quit HosptalName
}

Storage Default
{
<Data name="DHCQCBaseInformationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCBaseInformationD</DataLocation>
<DefaultData>DHCQCBaseInformationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCBaseInformationD</IdLocation>
<IndexLocation>^web.DHCQCBaseInformationI</IndexLocation>
<StreamLocation>^web.DHCQCBaseInformationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
