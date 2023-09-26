Class CIS.AN.BL.Workstation Extends %RegisteredObject
{

ClassMethod GetOperRoomIdByIP(IPAddress As %String) As %String
{
	set operRoomId=""
	&sql(select RowId into :operRoomId from CF_AN.Location where (OPClientIP [ :IPAddress) or (ANClientIP [ :IPAddress))
	quit operRoomId
}

}
