Class CIS.AN.BL.OperTransfer Extends %RegisteredObject
{

/// w ##class(CIS.AN.BL.OperTransfer).SaveOperTransfer(1,1)
/// opsId 手术ID
/// TransferInfo=^^^^^^^^^^^^^^^^^^^^
ClassMethod SaveOperTransfer(opsId As %String, TransferInfo As %String) As %String
{
	set $zt="Error"
	set msgId=""
	&sql(select RowId into :msgId from CIS_AN.OperTransfer where OperSchedule=:opsId)
	if (##class(CIS.AN.OperTransfer).%ExistsId(msgId))
	{
		quit "E^该患者的转运已经申请消息已经发送过。"	
	}
	if (msgId="")
	{
	set OperTransfer=##class(CIS.AN.OperTransfer).%New()
	}
	else
	{
	set OperTransfer=##class(CIS.AN.OperTransfer).%OpenId(msgId)
	}
	
	set OperTransfer.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set OperTransfer.receiveAppDate=$p(TransferInfo,"^",1) ;申请接病人日期
	set OperTransfer.receiveAppTime=$p(TransferInfo,"^",2) ;申请接病人时间
	set OperTransfer.receiveAppUser =$p(TransferInfo,"^",3) ;申请接病人申请人
	set OperTransfer.sendAppDate =$p(TransferInfo,"^",4)   ;申请送病人日期
	set OperTransfer.sendAppTime=$p(TransferInfo,"^",5)    ;申请送病人时间
	set OperTransfer.sendAppUser=$p(TransferInfo,"^",6)    ;申请送病人申请人
	set OperTransfer.receiveDate=$p(TransferInfo,"^",7)    ;接病人日期
	set OperTransfer.receiveTime =$p(TransferInfo,"^",8)   ;接病人时间
	set OperTransfer.receiveUser =$p(TransferInfo,"^",9)   ;接病人操作人
	set OperTransfer.sendDate=$p(TransferInfo,"^",10)      ;送病人日期
	set OperTransfer.sendTime=$p(TransferInfo,"^",11)      ;送病人时间
	set OperTransfer.sendUser=$p(TransferInfo,"^",12)      ;送病人操作人
	set OperTransfer.receiveAssDate=$p(TransferInfo,"^",13) ;接病人护工报到日期
	set OperTransfer.receiveAssTime=$p(TransferInfo,"^",14)  ;接病人护工报到时间
	set OperTransfer.receiveBackDate =$p(TransferInfo,"^",15) ;入手术室日期
	set OperTransfer.receiveBackTime=$p(TransferInfo,"^",16)  ;入手术室时间
	set OperTransfer.sendBackDate=$p(TransferInfo,"^",17)     ;送病人护工报到日期
	
	set OperTransfer.sendAssTime  =$p(TransferInfo,"^",18)    ;送病人护工报到时间
	set OperTransfer.sendBackTime =$p(TransferInfo,"^",19)     ; 出手术间时间
	set OperTransfer.UpdateTime =$p(TransferInfo,"^",20)        ;更新时间
	
	set sc=OperTransfer.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"_OperTransfer.%Id()
Error
	quit "E^"_$ze
}

}
