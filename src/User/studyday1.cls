Class User.studyday1 Extends %Persistent
{

/// CreateDate:2022-08-15
/// Creattor:牛慧兰
/// Function: 获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述.
/// Others: w ##class(User.StudyDay1).GetPAAdmSexDesc()
ClassMethod GetPAAdmSexDesc(AdmRowId As %String)
{
	q:AdmRowId="" "AdmRowId为空"
	s PAADMPAPMIDR = $p($g(^PAADM(AdmRowId)),"^",1)
	s PAPMISexDR = $p($g(^PAPER(PAADMPAPMIDR,"ALL")),"^",7)
	s PAPMISexDR = $P($g(^CT("SEX",PAPMISexDR)),"^",2) 
	q PAPMISexDR
}

Storage Default
{
<Data name="studyday1DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^User.studyday1D</DataLocation>
<DefaultData>studyday1DefaultData</DefaultData>
<IdLocation>^User.studyday1D</IdLocation>
<IndexLocation>^User.studyday1I</IndexLocation>
<StreamLocation>^User.studyday1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
