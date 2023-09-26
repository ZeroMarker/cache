Class web.DHCEventLogAudit Extends websys.Abstract
{

//审核只增加不修改

ClassMethod Save(StatusDr, UserDr, Note)
{
	Set Obj =  ##class(User.DHCEventLogAudit).%New()
	Set Obj.AuditDate = +$h
	Set Obj.AuditNote = Note
	Set Obj.AuditTime = $p($h,",",2)
	Do Obj.AuditStatusDrSetObjectId(StatusDr)
	Do Obj.AuditUserDrSetObjectId(UserDr)
	Set sc = Obj.%Save()
	If $$$ISERR(sc) set Obj="" Quit "-100^"_$SYSTEM.Status.GetErrorCodes(sc)
	Set Id = Obj.%Id()
	Quit Id
}

}
