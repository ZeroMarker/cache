Import SQLUser

Class web.DHCEQOperateLog Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// DHC_EQOperateLog
/// w ##class(web.DHCEQOperateLog).SaveData("^52^24407^1^")
ClassMethod SaveData(val, OperateFlag As %String = "1")
{
	new RowID,Date,Time,ID
	Set $ZT="ERRORSave"
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	Kill PLIST
	
	Set RowID=$Piece(val,"^",1)
	;OL_SourceType	11:开箱验收 12:安装调试验收 21:入库 22:转移 23:减少 31:维修 32保养 33检查 34报废 35折旧
	;41使用 51设备调帐 52设备台帐 61工程管理 91采购申请 92采购计划 93采购招标 94采购合同
	Set PLIST(2) = $Piece(val,"^",2)
 	Set PLIST(3) = $Piece(val,"^",3)	;OL_SourceID
 	Set PLIST(4) = OperateFlag	;OL_OperateFlag		1:单据打印 2:条码打印
 	Set PLIST(5) = 1					;OL_Times			操作次数
 	Set ID=$Order(^DHCEQOperateLog(0,"Source",OperateFlag,PLIST(2),PLIST(3),""),-1)
 	If ID'="" Set PLIST(5) = PLIST(5) + $Piece($Get(^DHCEQOperateLog(ID)),"^",4)
 	Set PLIST(6) = Date
 	Set PLIST(7) = Time
 	Set PLIST(8) = $Piece(val,"^",4)	;OL_User
 	If PLIST(8)="" Set PLIST(8)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	Set PLIST(9) = $Piece(val,"^",5)	;OL_Remark
 	;Set PLIST(10) = ""	;OL_Hold1
 	;Set PLIST(11) = ""	;OL_Hold2
 	;Set PLIST(12) = ""	;OL_Hold3
 	;Set PLIST(13) = ""	;OL_Hold4
 	;Set PLIST(14) = ""	;OL_Hold5
	
	TSTART	
 	If RowID=""
 	{
		&SQL(insert into sqluser.DHC_EQOperateLog values :PLIST())
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		Set RowID=$Get(%ROWID)
 	}
 	Else
 	{
	 	k PLIST(5)	;OL_Times
		&SQL(update sqluser.DHC_EQOperateLog values :PLIST() where OL_RowID=:RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
 	}
 	
	TCOMMIT
 	Set ID=RowID
 	Quit ID
ERRORSave 
	TRollBack
	Set ErrorMsg=$ZE
 	Quit "<ERRORSave>"_ErrorMsg
}

/// w ##class(web.DHCEQOperateLog).GetOperateLogInfo(52,24407,2)
ClassMethod GetOperateLogInfo(SourceType As %String = "", SourceID As %String = "", OperateFlag As %String = "1")
{
	If (SourceType="")||(SourceID="") Quit ""
	new rowid,result,resultex
	Set result=""
	Set resultex=""
	
	Set rowid=""
	For  Set rowid=$Order(^DHCEQOperateLog(0,"Source",OperateFlag,SourceType,SourceID,rowid)) Quit:rowid=""  Do
	.If resultex'="" Set resultex=resultex_"&"
	.Set result=$Get(^DHCEQOperateLog(rowid))
	.Set resultex=resultex_rowid_"^"_result
	.Set resultex=resultex_"^"
	.If $Piece(result,"^",5)'=""  Do  //OL_Date
	..Set resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",5),"date")
	.Set resultex=resultex_"^"
	.If $Piece(result,"^",6)'=""  Do  //OL_Time
	..Set resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",6),"time")
	.Set resultex=resultex_"^"
	.If $Piece(result,"^",7)'=""  Do  //OL_User
	..Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$Piece(result,"^",7))
	
	Set resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	Quit resultex
}

/// w ##class(web.DHCEQOperateLog).GetOperateTimes(52,24407)
ClassMethod GetOperateTimes(SourceType As %String = "", SourceID As %String = "", OperateFlag As %String = "1")
{
    new rowid,result,resultex
    If (SourceType="")||(SourceID="") Quit 0
    Set rowid=$Order(^DHCEQOperateLog(0,"Source",OperateFlag,SourceType,SourceID,""),-1)
    If rowid="" Quit 0
    ///modified by ZY 20220926  2962933
    Quit $Piece($Get(^DHCEQOperateLog(rowid)),"^",4,7)
}

}
