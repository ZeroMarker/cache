Class User.homework1 Extends %RegisteredObject
{

/// Function:获取rowid为3的病人（PA_Person）的生日PAPER_Dob（YYYY-MM-DD）
/// CreateDate:2023-09-11
/// Creator:zhailihong
/// Table:PA_Person
/// Input:rowid
/// Output:PAPERDob(YYYY-MM-DD)
/// Others:w ##class(User.homework1).GetPAPERDob(1)
ClassMethod GetPAPERDob(rowid As %String) As %String
{
	q:rowid="" " rowid不能为空"
	q:$d(^PAPER(rowid,"All"))=0 ""
	s Datastr=$get(^PAPER(rowid,"All"))
	s StDobDate=$p(Datastr,"^",6)
	s:StDobDate'=""  StDobDate=$zdate(stDobDate,3)
	w "出生日期为:"_stDoDate
}

}
