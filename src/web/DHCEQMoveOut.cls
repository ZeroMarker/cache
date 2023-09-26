Import SQLUser

/// 该类已作废  JDL 20150828 V4.0
Class web.DHCEQMoveOut Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MO_RowID";

Parameter SQLDESCRIPTION = "MO_RowID";

Parameter SQLROWID = "MO_RowID";

Parameter GlobalLen = 19;

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", user As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	&SQL(Delete From SQLUSER.DHC_EQMoveOut where MO_RowID = :rowid and MO_Status<2)
 	if (SQLCODE=100)  q -2022
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(1) = $p(val,"^",1)	;RowID
 s PLIST(2) = $p(val,"^",2)	;EquipDR
 s PLIST(3) = $p(val,"^",3)	;GroupDR
 s PLIST(4) = $p(val,"^",4)	;FromLoc
 s PLIST(5) = $p(val,"^",5)	;ToDeptDR
 s PLIST(6) = $p(val,"^",6)	;OutFee
 s PLIST(7) = $p(val,"^",7)	;PayModeDR
 s PLIST(8) = $p(val,"^",8)	;ChangeReason
 s PLIST(9) = $p(val,"^",9)	;ChangeDate
 i $p(val,"^",9)'=""  s PLIST(9) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",9),"date")	;ChangeDate
 s PLIST(10) = $p(val,"^",10)	;Remark
 s PLIST(11) = $p(val,"^",11)	;Status
 if (PLIST(11)="")  s PLIST(11)=0
 /*
 s PLIST(12) = $p(val,"^",12)	;AddUserDR
 s PLIST(13) = $p(val,"^",13)	;AddDate
 i $p(val,"^",13)'=""  s PLIST(13) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",13),"date")	;AddDate
 s PLIST(14) = $p(val,"^",14)	;AddTime
 s PLIST(15) = $p(val,"^",15)	;UpdateUserDR
 s PLIST(16) = $p(val,"^",16)	;UpdateDate
 i $p(val,"^",16)'=""  s PLIST(16) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",16),"date")	;UpdateDate
 s PLIST(17) = $p(val,"^",17)	;UpdateTime
 s PLIST(18) = $p(val,"^",18)	;AuditUserDR
 s PLIST(19) = $p(val,"^",19)	;AuditDate
 i $p(val,"^",19)'=""  s PLIST(19) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",19),"date")	;AuditDate
 s PLIST(20) = $p(val,"^",20)	;AuditTime
 */
 k PLIST(1)
 if (rowid'="") 
 {
	 s PLIST(15) = user
	 s PLIST(16) = +$H
	 s PLIST(17) = $P($H,",",2)
	 &SQL(Update SQLUSER.DHC_EQMoveOut Values :PLIST() where MO_RowID = :rowid and MO_Status<2)
	 if (%ROWCOUNT<1)  q -2021
 }
 else
 {
	 s PLIST(12) = user
	 s PLIST(13) = +$H
	 s PLIST(14) = $P($H,",",2)
	 &SQL(Select MO_RowID from SQLUSER.DHC_EQMoveOut Where MO_EquipDR=:PLIST(2))
	 if (%ROWCOUNT>0)  q -1003
	 &SQL(Insert Into SQLUSER.DHC_EQMoveOut Values :PLIST())
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

ClassMethod AuditData(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "", user As %Library.String = "", changetype As %Library.String = "")
{
	new updDate,updTime,eqstatus,equipdr,status,ManageLocDR,InstallLocDR,UseLocDR
 	s updDate=+$H
 	s updTime=$P($H,",",2)
 	if (changetype'="")  s changetype=$o(^DHCEQCCode("DHCEQCChangeType",0,"CTType",changetype,0))
 	TStart
 	&sql(Select %INTERNAL(MO_EquipDR->EQ_Status),%INTERNAL(MO_Status),MO_EquipDR
 		into :eqstatus,:status,:equipdr
 		from SQLUSER.DHC_EQMoveOut Where MO_RowID=:rowid)
 	if (eqstatus=3)  q -2005
 	if (status=2) q -2023
 	&SQL(Update SQLUSER.DHC_EQMoveOut set MO_Status=2,MO_AuditUserDR=:user,MO_AuditDate=:updDate,MO_AuditTime=:updTime where MO_RowID = :rowid)
 	if SQLCODE 
 	{
	 	TRollback
	 	q SQLCODE
 	}
 	
 	/*  From V4.0 JDL20150827  DHC_EQChangeInfo 旧表已经无效，变动信息记在LifeInfo里，DHC_EQChangeInfo新表用于设备启用、停用等变动记录。
 	&SQL(Insert Into SQLUSER.DHC_EQChangeInfo 
 			(CI_EquipDR,CI_GroupDR,CI_ChangeTypeDR,CI_ChangeReason,CI_ChangeDate,CI_MainID,CI_Remark,CI_AuditFlag,CI_ChangeDesc,CI_InvalidFlag,CI_AddUserDR,CI_AddDate,CI_AddTime,CI_AuditUserDR,CI_AuditDate,CI_AuditTime)
 		 Select MO_EquipDR,MO_GroupDR,:changetype,MO_ChangeReason,MO_ChangeDate,:rowid,MO_Remark,'Y','','N',MO_AddUserDR,MO_AddDate,MO_AddTime,MO_AuditUserDR,MO_AuditDate,MO_AuditTime 
 		 from SQLUSER.DHC_EQMoveOut where MO_RowID=:rowid)
 	if SQLCODE 
 	{
	 	TRollback
	 	q SQLCODE
 	}
 	*/
 	
 	&SQL(Update SQLUSER.DHC_EQEquip set EQ_Status=4 where EQ_RowID = :equipdr)
 	if SQLCODE 
 	{
	 	TRollback
	 	q SQLCODE
 	}
 	TCommit
 	q rowid
}

ClassMethod GetMoveOutByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex,i,count
	s (result,resultex)=""
	s result= ^DHCEQMoveOut(rowid)
	set count=..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}	
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;GroupDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQGroup($p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;ToDeptDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",4))),"^",2)
	s resultex=resultex_"^"	;PayModeDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("ctpm",$p(result,"^",6))
	s $p(result,"^",8)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"date")	;ChangeDate
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",11))
	s $p(result,"^",12)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",14))
	s $p(result,"^",15)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",15),"date")	;UpdateDate
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",17))
	s $p(result,"^",18)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",18),"date")	;AuditDate
	
	s resultex=resultex_"^"_##Class(web.DHCEQCommon).GetEditStatusDisplay($p(result,"^",10))
	s result=result_resultex
	s result=##Class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

Query GetMoveOut(EquipDR As %String) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TGroupDR:%String,TFromLoc:%String,TToDeptDR:%String,TOutFee:%String,TPayModeDR:%String,TChangeReason:%String,TChangeDate:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TEquip:%String,TGroup:%String,TToDept:%String,TPayMode:%String,TAddUser:%String,TUpdateUser:%String,TAuditUser:%String")
{
}

ClassMethod GetMoveOutExecute(ByRef qHandle As %Binary, EquipDR As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetMoveOut
	Quit $$$OK
BuildDataGetMoveOut
	f  s rowid=$o(^DHCEQMoveOut(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetMoveOut
	.s TRowID = rowid
	.s TEquipDR = $p($g(^DHCEQMoveOut(rowid)),"^",1)
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TGroupDR = $p($g(^DHCEQMoveOut(rowid)),"^",2)
	.i TGroupDR '=""  d
	..s TGroup = $p($g(^DHCEQGroup(TGroupDR)),"^",2)
	.s TFromLoc = $p($g(^DHCEQMoveOut(rowid)),"^",3)
	.s TToDeptDR = $p($g(^DHCEQMoveOut(rowid)),"^",4)
	.i TToDeptDR '=""  d
	..s TToDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TToDeptDR)),"^",2)
	.s TOutFee = $p($g(^DHCEQMoveOut(rowid)),"^",5)
	.s TPayModeDR = $p($g(^DHCEQMoveOut(rowid)),"^",6)
	.i TPayModeDR '=""  d
	..s TPayMode = ##Class(web.DHCEQCommon).GetTrakNameByID("ctpm",TPayModeDR)
	.s TChangeReason = $p($g(^DHCEQMoveOut(rowid)),"^",7)
	.s TChangeDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMoveOut(rowid)),"^",8),"date")
	.s TRemark = $p($g(^DHCEQMoveOut(rowid)),"^",9)
	.s TStatus = $p($g(^DHCEQMoveOut(rowid)),"^",10)
	.s TStatus = ##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.s TAddUserDR = $p($g(^DHCEQMoveOut(rowid)),"^",11)
	.i TAddUserDR '=""  d
	..s TAddUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMoveOut(rowid)),"^",12),"date")
	.s TAddTime = $p($g(^DHCEQMoveOut(rowid)),"^",13)
	.s TUpdateUserDR = $p($g(^DHCEQMoveOut(rowid)),"^",14)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMoveOut(rowid)),"^",15),"date")
	.s TUpdateTime = $p($g(^DHCEQMoveOut(rowid)),"^",16)
	.s TAuditUserDR = $p($g(^DHCEQMoveOut(rowid)),"^",17)
	.i TAuditUserDR '=""  d
	..s TAuditUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.s TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQMoveOut(rowid)),"^",18),"date")
	.s TAuditTime = $p($g(^DHCEQMoveOut(rowid)),"^",19)
	.d OutputRowGetMoveOut
	quit
OutputRowGetMoveOut
	s Data=$lb(TRowID,TEquipDR,TGroupDR,TFromLoc,TToDeptDR,TOutFee,TPayModeDR,TChangeReason,TChangeDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TEquip,TGroup,TToDept,TPayMode,TAddUser,TUpdateUser,TAuditUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMoveOut
	s (TRowID,TEquipDR,TGroupDR,TFromLoc,TToDeptDR,TOutFee,TPayModeDR,TChangeReason,TChangeDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TEquip,TGroup,TToDept,TPayMode,TAddUser,TUpdateUser,TAuditUser)=""
	quit
}

ClassMethod GetMoveOutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMoveOutExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMoveOutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMoveOutExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
