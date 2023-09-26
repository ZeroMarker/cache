Class web.CSSD.YCZ004 Extends %RegisteredObject
{

/// Function:获取rowid为3的病人(PA_Person)的生日PAPER_Dob  (YYYY-MM-DD)
/// CreateDate:2023-09-11
/// Creator:yuchangzhi
/// Table:PA_Person
/// Input:rowid
/// Output:PAPERDob  (YYYY-MM-DD)
/// Others:w ##class(web.CSSD.YCZ004).GetPAPERDob()
ClassMethod GetPAPERDob(rowid As %String) As %String
{
	q:rowid="" ""
	q:$d(^PAPER(rowid,"ALL"))=0 ""
	s DataStr=$get(^PAPER(rowid,"ALL"))
	s StDobDate=$P(DataStr,"^",6)
	s:StDobDate'="" StDobDate=$zdate(StDobDate,3) //日期转换
	q StDobDate
}

}
