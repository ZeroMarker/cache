Class User.WK Extends %RegisteredObject
{

ClassMethod GetPAAdmSexDesc(RowId As %String) As %String
{
	///Function:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)
	///Creator: 王康
	///other: d ##class(User.WK).GetPAAdmSexDesc("1")
		
	s AdmStr=$g(^PAADM(RowId))
	s PAADMPAPMIDR=$p(AdmStr,"^",1)
	s PAPMISexDR=$P($g(^PAPER(PAADMPAPMIDR,"ALL")),"^",7)
	s CTSEXDesc=$p($g(^CT("SEX",PAPMISexDR)),"^",2)
	///q CTSEXDesc
	w "RowId为"_RowId_"的患者，性别："_CTSEXDesc
}

}
