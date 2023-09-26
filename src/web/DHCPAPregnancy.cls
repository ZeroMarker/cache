Import SQLUser

Class web.DHCPAPregnancy Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetPregnancy(EpisodeID As %String, UserID As %String) As %String
{
	s ^ypzTmp("preg")="null"

	Quit:$G(EpisodeID)="" ""
	If $G(UserID)="" Set UserID=%session.Get("LOGON.USERID")
	Set Preg=$P($G(^PAADM(EpisodeID,2)),"^",81)
	s motherid=$P($G(^PAADM(EpisodeID)),"^",75)
	i motherid="" d
	.If Preg="" Set Preg=..InsertPregnancy(EpisodeID, UserID)
	e  s Preg=""
	Quit Preg
}

ClassMethod InsertPregnancy(EpisodeID As %String, UserID As %String) As %String
{
	Quit:$G(EpisodeID)="" ""
	Set PatientID=$P($G(^PAADM(EpisodeID)),"^",1)
	Quit:$G(PatientID)="" ""
	KILL PLIST
	Set PLIST(2)=PatientID			    ;PREG_Person_DR
	Set PregStatus=$O(^PAC("PREGST",0,"Code","O",""))
	If PregStatus'="" Set PLIST(3)=+PregStatus	;PREG_Status		"OPEN"
	Set PLIST(33)="Medtrak"			    ;PREG_PregType
	Set PLIST(44)=+$H
	Set PLIST(46)=$P($H,",",2)
	If $G(UserID)'="" Set PLIST(47)=UserID
	&SQL(INSERT INTO PA_Pregnancy Values PLIST())
	If SQLCODE Quit ""
	Set PregId= %ROWID
	&SQL(Update PA_Adm Set PAADM_Pregnancy_DR= :PregId Where PAADM_RowId= :EpisodeID)
	Quit PregId
}

ClassMethod GetPregDelivery(EpisodeID As %String, UserID As %String) As %String
{
	;^PAPRGi("DEL_Adm_DR",{DEL_Adm_DR},{PA_Pregnancy.PREG_RowId},"DEL",{DEL_Childsub})
	Quit:$G(EpisodeID)="" ""
	If $G(UserID)="" Set UserID=%session.Get("LOGON.USERID")
	Set Preg=..GetPregnancy(EpisodeID,UserID)
	Quit:Preg="" ""
	Set Deliv=$O(^PAPRGi("DEL_Adm_DR",EpisodeID,Preg,"DEL",""))
	Quit:Deliv'="" Preg_"||"_Deliv
	Set Delivery=..InsertNullDelivery(Preg,EpisodeID,UserID)
	Quit Delivery
}

ClassMethod InsertNullDelivery(Pregnancy As %String, EpisodeID As %String, UserID As %String) As %String
{
	Quit:$G(EpisodeID)="" ""
	Quit:$G(Pregnancy)="" ""
	KILL PLIST
	Set PLIST(0)=Pregnancy
	Set PLIST(3)=EpisodeID			    ;DEL_Adm_DR
	Set PLIST(23)="N"
	Set PLIST(31)="Delivery"
	Set PLIST(40)="N"
	Set PLIST(47)=+$H
	Set PLIST(46)=$P($H,",",2)
	If $G(UserID)'="" Set PLIST(48)=UserID
	&SQL(INSERT INTO PA_PregDelivery Values PLIST())
	If SQLCODE Quit ""
	Quit %ROWID
}

/// 护士站卡合并
/// 1.PA_Pregnancy,孕妇基本信息PREG_Person_DR
/// 		^PAPRGi("PREG_Person",{PREG_Person_DR},{PREG_RowId})
/// 2.PA_PregDelBaby,婴儿基本信息BABY_Person_DR
/// 		^PAPRGi("BABY_Person_DR",{BABY_Person_DR},{PA_Pregnancy.PREG_RowId},"DEL",{PA_PregDelivery.DEL_Childsub},"BABY",{BABY_Childsub})
ClassMethod UnitePregInfo(OldPAPMIID As %String = "", NewPAPMIID As %String = "", CurUserID As %String = "") As %String
{
	//n (OldPAPMIID, NewPAPMIID,CurUserID)
	//w ##class(web.DHCPAPregnancy).UnitePregInfo("1","2","3878")
	s SQLCODE=0
	q:(OldPAPMIID="")||(NewPAPMIID="") SQLCODE
	s OldBaseId=0 f  s OldBaseId=$o(^PAPRGi("PREG_Person",OldPAPMIID,OldBaseId)) q:OldBaseId=""  d
	.&sql(update PA_Pregnancy set PREG_Person_DR=:NewPAPMIID where PREG_RowId=:OldBaseId)
	.i SQLCODE=0 d //插入日志
	..s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("PAPregnancy",OldPAPMIID,NewPAPMIID,OldBaseId,"",CurUserID)	
	i SQLCODE'=0 q "更新孕妇基本信息错误!"

	s OldPREGRowId=0 f  s OldPREGRowId=$O(^PAPRGi("BABY_Person_DR",OldPAPMIID,OldPREGRowId)) q:OldPREGRowId=""  d
	.s OldDELChildsub=0  f  s OldDELChildsub=$O(^PAPRGi("BABY_Person_DR",OldPAPMIID,OldPREGRowId,"DEL",OldDELChildsub)) q:OldDELChildsub=""  d
	..s OldBABYChildsub=0  f  s OldBABYChildsub=$O(^PAPRGi("BABY_Person_DR",OldPAPMIID,OldPREGRowId,"DEL",OldDELChildsub,"BABY",OldBABYChildsub)) q:OldBABYChildsub=""  d
	...s OldBABYBaseId=OldPREGRowId_"||"_OldDELChildsub_"||"_OldBABYChildsub
	...&sql(update PA_PregDelBaby set BABY_Person_DR=:NewPAPMIID where BABY_RowId=:OldBABYBaseId)
	...i SQLCODE=0 d //插入日志
	....s SQLCODE=##class(User.DHCPATCardUniteLog).InsertLog("PAPregDelBaby",OldPAPMIID,NewPAPMIID,OldBABYBaseId,"",CurUserID)	
	i SQLCODE'=0 q "更新婴儿基本信息错误!"
	
	q ""
}

/// 护士站撤消卡合并
ClassMethod ConversePregInfo(OldPAPMIID As %String = "", NewPAPMIID As %String = "", CurUserID As %String = "") As %String
{
	//n (OldPAPMIID,NewPAPMIID,CurUserID)
	//Index OldNewPAPMI On (CUTableName As AlphaUp, CUActiveFlag, CUOldPAPMIRowid, CUNewPAPMIRowid, CURecordID)[ Data = CUOtherInfo ];
	//w ##class(web.DHCPAPregnancy).ConversePregInfo("1","2","3878")
	s SQLCODE=0
	s TableName=$ZCVT("PAPregnancy","U")
	s UnitID=0
	f  s UnitID=$O(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_OldPAPMIID," "_NewPAPMIID,TableName,UnitID)) q:(UnitID="")||(SQLCODE'=0)  d
	.s obj=##class(User.DHCPATCardUniteLog).%OpenId(UnitID)
	.s RecordID=obj.CURecordID
	.&sql(Update PA_Pregnancy set PREG_Person_DR=:OldPAPMIID where PREG_RowId=:RecordID)
	.q:SQLCODE'=0
	.s SQLCODE=##class(User.DHCPATCardUniteLog).UpdateLog(UnitID,CurUserID)
	i SQLCODE'=0  q "更新孕妇基本信息错误!"
	s TableName=$ZCVT("PAPregDelBaby","U")
	s UnitID=0
	f  s UnitID=$O(^User.DHCPATCardUniteLogI("OldNewPAPMI"," 1"," "_OldPAPMIID," "_NewPAPMIID,TableName,UnitID)) q:(UnitID="")||(SQLCODE'=0)  d
	.s obj=##class(User.DHCPATCardUniteLog).%OpenId(UnitID)
	.s RecordID=obj.CURecordID
	.&sql(update PA_PregDelBaby set BABY_Person_DR=:OldPAPMIID where BABY_RowId=:RecordID)
	.q:SQLCODE'=0
	.s SQLCODE=##class(User.DHCPATCardUniteLog).UpdateLog(UnitID,CurUserID)
	i SQLCODE'=0  q "更新婴儿基本信息错误!"
	q ""
}

}
