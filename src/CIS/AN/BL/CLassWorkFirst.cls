Class CIS.AN.BL.CLassWorkFirst Extends %RegisteredObject
{

/// 许磊2023-9-12
/// input：RowId
/// output:性别
/// w ##class(CIS.AN.BL.CLassWorkFirst).GetPAAdmSexDesc("1")
ClassMethod GetPAAdmSexDesc(AdmRowId As %String)
{
	q:AdmRowId="" "1"
	s SexDesc=""
	s RowIdDesc=$P($g(^PAADM(1059)),"^",1)
	q:RowIdDesc="" "2"
	&sql(SELECT PAPMI_Sex_DR INTO RowId FROM PA_PatMas WHERE PAPMIRowId=:RowIdDesc)
	s RowId=$P($g(^PAPER(RowIdDesc)),"^",15)
	q:RowId=""
	s SexDesc=$P($g(^CT("SEX",RowIdD)),"^",3)
	//w SexDesc,!
	q RowIdDesc
}

}
