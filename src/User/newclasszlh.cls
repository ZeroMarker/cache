Class User.newclasszlh Extends %RegisteredObject
{

/// Function：获取rowid为3的病人(PA_Person)的生日PAPER_Dob(YYYY-MM-DD)
/// CreateDate:2023-09-11
/// Creator:zhailihong
/// Table:PA_Person
/// Input:rowid 入参
/// Output:PAPERDob(YYYY-MM-DD) 出参
/// Others: w ##class(User.newclasszlh).GetPAPERDob(1) 
/// 有返回值的用w 无返回值的用do
/// SELECT PAPER_Dob, * FROM PA_Person WHERE PAPER_RowId=3
ClassMethod GetPAPERDob(rowid As %String) As %String
{
	q:rowid="" "rowid不能为空"
	q:$d(^PAPER(1,"ALL"))=0 "数据不存在"
	s DataStr=$g(^PAPER(rowid,"ALL"))  
	s StDobDate=$p(DataStr,"^",6)
	s:StDobDate'="" StDobDate=$zdate(StDobDate,3) //转换日期
	q "出生日期为："_StDobDate
}

}
