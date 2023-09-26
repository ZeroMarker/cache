/// creater			郭荣勇
/// desc			插入DHCDocIPBooking子表DHCDocIPBookingStateChange相关方法(含触发器调用方法)
/// date			2018.06.07
Class web.DHCDocIPBookingStateChange Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// D ##CLASS(web.DHCDocIPBookingStateChange).TestSQL(1)
ClassMethod TestSQL(parref As %String)
{
	kill PLIST
    &SQL(UPDATE SQLUser.DHCDocIPBooking SET CurrentStateID=17 WHERE RowID=1)

	Q SQLCODE
}

/// creater			guorongyong
/// desc			插入/更新DHCDocIPBooking表CurrentStateID字段,调用的触发程序
/// date			2018.06.07
ClassMethod OnTrigger(parref As %String, type As %String) As %Status
{
	
	;s $zt="StatusErr"
	s rtn=1
	s ParObj=##class(User.DHCDocIPBooking).%OpenId(parref)
	if $ISOBJECT(ParObj) {
		if type="TAfterIns" {
			s Status=ParObj.CurrentStateIDGetObjectId()
			s UpUserID=ParObj.UpdateUserGetObjectId()
			s param=parref_"^"_Status_"^"_UpUserID
			s rtn=..InsertChangeStatus(param)
			i rtn=0 s rtn=1
			else  s rtn="ERROR"_rtn
		}
		if type="TAfterUpd" {
			i $g(%e(9)) {
				s OldStatus=$g(%e(9))
				s NewStatus=$g(%d(9))
			}else{
				s OldStatus=-1
				s NewStatus=ParObj.CurrentStateIDGetObjectId()
			}
			i OldStatus-NewStatus {
				s Status=ParObj.CurrentStateIDGetObjectId()
				s UpUserID=ParObj.UpdateUserGetObjectId()
				s param=parref_"^"_Status_"^"_UpUserID
				s rtn=..InsertChangeStatus(param)
				i rtn=0 s rtn=1
				else  s rtn="ERROR"_rtn
			}
		}
	}

	Q rtn
StatusErr
	Q 0
}

/// creater			郭荣勇
/// desc			插入DHCDocIPBooking子表记录队列状态改变
/// date			2018.06.07
/// w ##class(web.DHCDocIPBookingStateChange).InsertChangeStatus("8^9^8^7")
ClassMethod InsertChangeStatus(insertinfo)
{
 s ParRef=$p(insertinfo,"^",1)
 i ParRef="" Q -1
 s Status=$p(insertinfo,"^",2)
 s UpUserID=$p(insertinfo,"^",3)
 s Date=$P($H,",",1)
 s Time=$P($H,",",2)
 TStart
   &sql(insert into sqluser.DHCDocIPBookingStateChange(IPBSC_ParRef,IPBSC_Date,IPBSC_Time,IPBSC_Status_DR,IPBSC_UpUser_DR) 
   values(:ParRef,:Date,:Time,:Status,:UpUserID))
   i SQLCODE=0 D
	.TCommit  
   e  d
	.Trollback
   q SQLCODE
}

}
