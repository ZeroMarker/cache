Class web.wangwang.WWClass Extends %Persistent
{

/// Function:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述
/// CreateDate:2023-09-11
/// Creator:王旺
/// Table:PA_Adm，PA_PatMas,CT_SEX
/// Input:rowid
/// Output:性别描述 SexDesc
/// Others:w ##class(User.OneDay).GetPAAdmSexDesc(1)
ClassMethod GetPAAdmSexDesc(AdmRowId As %String) As %String
{
	q:AdmRowId="" ""
	s (PAADMPAPMIDR,PAPMISexDR,SexDesc)=""
	s PAADMPAPMIDR=$p($g(^PAADM(AdmRowId)),"^",1)
	s PAPMISexDR=$p($g(^PAPER(PAADMPAPMIDR,"ALL")),"^",7)
	s SexDesc=$p($g(^CT("SEX",PAPMISexDR)),"^",2)
	//w SexDesc,!
	q SexDesc
}

Storage Default
{
<Data name="WWClassDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.wangwang.WWClassD</DataLocation>
<DefaultData>WWClassDefaultData</DefaultData>
<IdLocation>^web.wangwang.WWClassD</IdLocation>
<IndexLocation>^web.wangwang.WWClassI</IndexLocation>
<StreamLocation>^web.wangwang.WWClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
