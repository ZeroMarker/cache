Class web.YCZ.YCZ005 Extends %RegisteredObject
{

/// Function:获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述.
/// CreateDate:2023-09-11
/// Creator:俞长志
/// Table:PA_PatMas
/// Input:rowid
/// Output:PAPMISexDR(男\女\未知\未说明性别)
/// Others:d ##class(web.YCZ.YCZ005).GetPAPMISexDR(1)
ClassMethod GetPAPMISexDR(rowid As %String) As %String
{
		
	q:rowid="" ""
	q:$d(^PAPER(rowid,"ALL"))=0 ""
	s DataStr=$get(^PAPER(rowid,"ALL"))
	s StDRSex=$P(DataStr,"^",7)
	s y=StDRSex
	IF y#4=2
	{
	w "性别为：女"
	}
	ELSEIF y#4=1
	{
	w "性别为：男"
	}
	ELSEIF y#4=3
	{
	w "性别为：未知"
	}
	ELSE
	{
	w "性别为：未说明性别"
	}
}

}
