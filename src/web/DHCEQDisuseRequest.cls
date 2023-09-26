Import SQLUser

/// -------------------------------
/// 修改：zy 2009-07-16   zy0006
/// 修改方法：GetDisuseRequestByID
/// 描述:设备报废审批通过后，打印审批表，增加了设备和审批流程的信息数据
/// -------------------------------
Class web.DHCEQDisuseRequest Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 327;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DR_RowID";

Parameter SQLDESCRIPTION = "DR_RowID";

Parameter SQLROWID = "DR_RowID";

Parameter GlobalLen = 49;

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", user As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	&SQL(Delete From SQLUSER.DHC_EQDisuseRequest where DR_RowID = :rowid and DR_Status<2)
 	if (SQLCODE=100)  q -2022
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(1) = $p(val,"^",1)	;RowID
 s PLIST(2) = $p(val,"^",2)	;EquipDR
 s PLIST(3) = $p(val,"^",3)	;GroupDR
 s PLIST(4) = $p(val,"^",4)	;RequestLocDR
 s PLIST(5) = $p(val,"^",5)	;RequestDate
 i $p(val,"^",5)'=""  s PLIST(5) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date")	;RequestDate
 s PLIST(6) = $p(val,"^",6)	;UseState
 s PLIST(7) = $p(val,"^",7)	;DisuseTypeDR
 s PLIST(8) = $p(val,"^",8)	;ChangeReason
 s PLIST(9) = $p(val,"^",9)	;DisureDate
 i $p(val,"^",9)'=""  s PLIST(9) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",9),"date")	;DisureDate
 s PLIST(10) = $p(val,"^",10)	;Remark
 s PLIST(11) = 0 //$p(val,"^",11)	;Status
 s PLIST(34) = $p(val,"^",34)
 k PLIST(1)
 if (rowid'="") 
 {
	 s PLIST(15) = user
	 s PLIST(16) = +$H
	 s PLIST(17) = $P($H,",",2)
	 &SQL(Select DR_RowID from SQLUSER.DHC_EQDisuseRequest Where DR_EquipDR=:PLIST(2) and DR_RowID <> :rowid)
	 if (%ROWCOUNT>0)  q -1003
	 &SQL(Update SQLUSER.DHC_EQDisuseRequest Values :PLIST() where DR_RowID = :rowid) 	 
 }
 else
 {
	 s PLIST(12) = user
	 s PLIST(13) = +$H
	 s PLIST(14) = $P($H,",",2)
	 &SQL(Select DR_RowID from SQLUSER.DHC_EQDisuseRequest Where DR_EquipDR=:PLIST(2))
	 if (%ROWCOUNT>0)  q -1003
	 i PLIST(34)="" s PLIST(34)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQDisuseRequest",PLIST(13))
	 &SQL(Insert Into SQLUSER.DHC_EQDisuseRequest Values :PLIST())
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

ClassMethod AuditSPData(val, changetype)
{
	new PLIST
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
	s DRRowID=$p(val,"^",1)
	if (changetype'="")  s changetype=$o(^DHCEQCCode("DHCEQCChangeType",0,"CTType",changetype,0))
	s PLIST(32)=$p(val,"^",2)  //Role
	s PLIST(31)=$p(val,"^",3)  //Step
	s Opinion=$p(val,"^",4)  //Opinion
	s Remark=$p(val,"^",5)
	s ApproveSet=$P(^DHCEQDisuseRequest(DRRowID),"^",27)
	s NextApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, DRRowID, PLIST(31), PLIST(32))
 	s LastFlag=$p(NextApproveFlow,"^",1)
 	s PLIST(30)=$p(NextApproveFlow,"^",2)  //NextStep
 	s PLIST(29)=$p(NextApproveFlow,"^",3)  //NextRole
 	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9) 	
 	TSTART
 	i AutoAuditFlag="Y"
	{
	 	i PLIST(30)="" s PLIST(11)="2"
	 	i LastFlag="Y" s PLIST(11)="2"
	 	i (PLIST(30)="")||(LastFlag="Y")
	 	{		 
		 	s SQLCODE=..AuditData("","",DRRowID,User,changetype,"N")
		 	if (SQLCODE'=DRRowID)
 			{
				TRollback
			 	q SQLCODE
 			}
	 	}
	}
	&SQL(update sqluser.DHC_EQDisuseRequest values :PLIST() where DR_RowID=:DRRowID)			 	
	i SQLCODE
	{
		TROLLBACK
	 	q SQLCODE
	}
	/// 报废分步：  (0:正常  1：报废院内审批  2：报废主管局审批)
 	s specialRole=##class(web.DHCEQCommon).GetSysInfo("601003")
 	i ((specialRole'="")&&(specialRole=PLIST(32)))
 		{s SQLCODE=..DisuseEquipList(DRRowID,"1")}
 			
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, DRRowID, Opinion, Remark, PLIST(32), PLIST(31))
	if SQLCODE
	{
	 	TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q DRRowID
}

ClassMethod AuditData(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "", user As %Library.String = "", changetype As %Library.String = "", usetrans As %Library.String = "")
{
	new updDate,updTime,eqstatus,equipdr,status,DRRowID
	new month,depresetid,syssetdepre
	
 	s updDate=+$H
 	s updTime=$P($H,",",2)
 	if (changetype'="")  s changetype=$o(^DHCEQCCode("DHCEQCChangeType",0,"CTType",changetype,0))
 	i usetrans="Y"	{TStart}
 	&sql(Select %INTERNAL(DR_EquipDR->EQ_Status),%INTERNAL(DR_Status),DR_EquipDR
 		into :eqstatus,:status,:equipdr
 		from SQLUSER.DHC_EQDisuseRequest Where DR_RowID=:rowid)
 	if (eqstatus=3)  q -2005
 	if (status=2) q -2023
 	
 	s syssetdepre=##class(web.DHCEQCommon).GetSysInfo("601001")
 	i syssetdepre=1
 	{
 		///一次性计提剩余折旧
 		s month=##class(web.DHCEQImportDataTool).GetCurMonthStr()
 		//s month=""
 		s depresetid=$o(^DHCEQDepreSet(0,"EquipMain",equipdr,"Y",0))
		i depresetid=""
		{
			i usetrans="Y"	{TROLLBACK} 
			q -1002
		}
 		s SQLCODE=##class(web.DHCEQMonthDepreset).GenerateMonthDepre(equipdr, month, depresetid,"N","1","")
		i SQLCODE'=0
		{	i usetrans="Y"	{TROLLBACK}
			q SQLCODE
		}
 	}
 	&SQL(Update SQLUSER.DHC_EQDisuseRequest set DR_Status=2,DR_AuditUserDR=:user,DR_AuditDate=:updDate,DR_AuditTime=:updTime where DR_RowID = :rowid)
 	
 	if SQLCODE 
 	{
	 	i usetrans="Y"	{TRollback}
	 	q SQLCODE
 	} 	
 	
 	/*  From V4.0 JDL20150827  DHC_EQChangeInfo 旧表已经无效，变动信息记在LifeInfo里，DHC_EQChangeInfo新表用于设备启用、停用等变动记录。
	if (equipdr'="")
 	{	
 	&SQL(Insert Into SQLUSER.DHC_EQChangeInfo 
 			(CI_EquipDR,CI_GroupDR,CI_ChangeTypeDR,CI_ChangeReason,CI_ChangeDate,CI_MainID,CI_Remark,CI_AuditFlag,CI_ChangeDesc,CI_InvalidFlag,CI_AddUserDR,CI_AddDate,CI_AddTime,CI_AuditUserDR,CI_AuditDate,CI_AuditTime)
 		 Select DR_EquipDR,DR_GroupDR,:changetype,DR_ChangeReason,DR_DisureDate,:rowid,DR_Remark,'Y','','N',DR_AddUserDR,DR_AddDate,DR_AddTime,DR_AuditUserDR,DR_AuditDate,DR_AuditTime
 		 from SQLUSER.DHC_EQDisuseRequest where DR_RowID=:rowid)
 	}
 	else
 	{
	 &SQL(Insert Into SQLUSER.DHC_EQChangeInfo 
 			(CI_EquipDR,CI_GroupDR,CI_ChangeTypeDR,CI_ChangeReason,CI_ChangeDate,CI_MainID,CI_Remark,CI_AuditFlag,CI_ChangeDesc,CI_InvalidFlag,CI_AddUserDR,CI_AddDate,CI_AddTime,CI_AuditUserDR,CI_AuditDate,CI_AuditTime)
 		Select DRL_EquipDR,DRL_DisuseRequestDR->DR_GroupDR,:changetype,DRL_ChangeReason,DRL_DisuseRequestDR->DR_DisureDate,:rowid,DRL_Remark,'Y','','N',DRL_DisuseRequestDR->DR_AddUserDR,DRL_DisuseRequestDR->DR_AddDate,DRL_DisuseRequestDR->DR_AddTime,DRL_DisuseRequestDR->DR_AuditUserDR,DRL_DisuseRequestDR->DR_AuditDate,DRL_DisuseRequestDR->DR_AuditTime
 		from SQLUSER.DHC_EQDisuseRequestList where DRL_DisuseRequestDR=:rowid)
	 }
 	if SQLCODE 
 	{
	 	i usetrans="Y"	{TRollback}
	 	q SQLCODE
 	}
 	*/
 	
 	if (equipdr'="")
 	{
 		&SQL(Update SQLUSER.DHC_EQEquip set EQ_Status=3 where EQ_RowID = :equipdr)}
 	else
 	{
	 	s SQLCODE=..DisuseEquipList(rowid)}
 	if SQLCODE 
 	{
	 	i usetrans="Y"	{TRollback}
	 	q SQLCODE
 	}
 	i usetrans="Y"	{TCommit}
 	q rowid
}

ClassMethod SubmitData(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "", user As %Library.String = "", iscancel As %Library.String = 0, changetype, RejectReason)
{
	new updDate,updTime,eqstatus,equipdr,status,DRRowID
 	s updDate=+$H
 	s updTime=$P($H,",",2)
 	s User=user
 	s DRRowID=rowid
 	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
 	TStart
 	&sql(Select %INTERNAL(DR_EquipDR->EQ_Status),%INTERNAL(DR_Status),DR_EquipDR,DR_NextRoleDR
 		into :eqstatus,:status,:equipdr,:curNextRole
 		from SQLUSER.DHC_EQDisuseRequest Where DR_RowID=:DRRowID)
 	if (eqstatus=3)  q -2005
 	if (iscancel=0)
 		{if (status'=0) q -2013
 		s PLIST(11)="1"
 		s PLIST(18)=User
 		s PLIST(19)=updDate
 		s PLIST(20)=updTime
 		s EQRowID=$P(^DHCEQDisuseRequest(DRRowID),"^",1)
 		//s EquipType=$P(^DHCEQEquip(EQRowID),"^",63)
	 	//s PurchaseType=$P(^DHCEQEquip(EQRowID),"^",64)
	 	//s YearFlag=""
	 	//s MaxPrice=$P(^DHCEQEquip(EQRowID),"^",27)
	 	//s SpecialType=..GetSpecialType(EQRowID)
	 	//i SpecialType<0 q -4006
	 	
	 	s YearFlag=""
	 	s (EquipType,PurchaseType,MaxPrice,SpecialType)=""
	 	d ..GetApproveInfo(DRRowID,.EquipType,.PurchaseType,.MaxPrice,.SpecialType)
	 	i SpecialType<0 q -4006
	 	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag)
	 	i ApproveSet="" q -4007
	 	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,DRRowID,"5",User)
	 	i SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
 		
	 	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, DRRowID, 0, "")
	 	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	 	s LastFlag=$P(ApproveFlow,"^",1)
	 	s NextStep=$P(ApproveFlow,"^",2)
	 	s NextRole=$P(ApproveFlow,"^",3)
	 	i AutoAuditFlag="Y"
	 	{
		 	i NextStep="" s PLIST(11)="2"
		 	i LastFlag="Y" s PLIST(11)="2"
		 	i (NextStep="")||(LastFlag="Y")
		 	{
		 		s PLIST(21)=User
	 			s PLIST(22)=updDate
	 			s PLIST(23)=updTime
	 			
	 			/*  From V4.0 JDL20150827  DHC_EQChangeInfo 旧表已经无效，变动信息记在LifeInfo里，DHC_EQChangeInfo新表用于设备启用、停用等变动记录。
	 			if (changetype'="") s changetype=$o(^DHCEQCCode("DHCEQCChangeType",0,"CTType",changetype,0))
	 			
	 			if (EQRowID'="")
	 			{
	 				&SQL(Insert Into SQLUSER.DHC_EQChangeInfo 
 					(CI_EquipDR,CI_GroupDR,CI_ChangeTypeDR,CI_ChangeReason,CI_ChangeDate,CI_MainID,CI_Remark,CI_AuditFlag,CI_ChangeDesc,CI_InvalidFlag,CI_AddUserDR,CI_AddDate,CI_AddTime,CI_AuditUserDR,CI_AuditDate,CI_AuditTime)
 		 			Select DR_EquipDR,DR_GroupDR,:changetype,DR_ChangeReason,DR_DisureDate,:DRRowID,DR_Remark,'Y','','N',DR_AddUserDR,DR_AddDate,DR_AddTime,DR_AuditUserDR,DR_AuditDate,DR_AuditTime
 		 			from SQLUSER.DHC_EQDisuseRequest where DR_RowID=:DRRowID)
	 			}
	 			else
	 			{
		 			&SQL(Insert Into SQLUSER.DHC_EQChangeInfo 
 					(CI_EquipDR,CI_GroupDR,CI_ChangeTypeDR,CI_ChangeReason,CI_ChangeDate,CI_MainID,CI_Remark,CI_AuditFlag,CI_ChangeDesc,CI_InvalidFlag,CI_AddUserDR,CI_AddDate,CI_AddTime,CI_AuditUserDR,CI_AuditDate,CI_AuditTime)
 		 			Select DRL_EquipDR,DRL_DisuseRequestDR->DR_GroupDR,:changetype,DRL_ChangeReason,DRL_DisuseRequestDR->DR_DisureDate,:DRRowID,DRL_Remark,'Y','','N',DRL_DisuseRequestDR->DR_AddUserDR,DRL_DisuseRequestDR->DR_AddDate,DRL_DisuseRequestDR->DR_AddTime,DRL_DisuseRequestDR->DR_AuditUserDR,DRL_DisuseRequestDR->DR_AuditDate,DRL_DisuseRequestDR->DR_AuditTime
 		 			from SQLUSER.DHC_EQDisuseRequestList where DRL_DisuseRequestDR=:DRRowID)
		 		}
 				if SQLCODE 
 				{
				 	TRollback
				 	q SQLCODE
 				}
 				*/
 				
 				if EQRowID'=""
 				{
 					&SQL(Update SQLUSER.DHC_EQEquip set EQ_Status=3 where EQ_RowID = :EQRowID)}
 				else
 				{
	 				s SQLCODE=..DisuseEquipList(DRRowID)}
 				if SQLCODE 
 				{
				 	TRollback
	 				q SQLCODE
 				}
		 	}
	 	}
	 	s PLIST(28)=ApproveSet
	 	s PLIST(29)=NextRole
	 	s PLIST(30)=NextStep
	 	s PLIST(31)=""
	 	s PLIST(32)=""
	 	if EQRowID'=""
	 	{
 			&SQL(Update SQLUSER.DHC_EQDisuseRequest values :PLIST() 
 			where DR_RowID = :DRRowID and %INTERNAL(DR_EquipDR->EQ_Status)<3 and %INTERNAL(DR_Status)=0 )
	 	}
	 	else
	 	{
		 	&SQL(Select count(*) into :disusedcount from SQLUSER.DHC_EQDisuseRequestList where DRL_DisuseRequestDR = :DRRowID and %INTERNAL(DRL_EquipDR->EQ_Status)=3)
		 	if +disusedcount>0 
		 	{ s SQLCODE=100 }
		 	else
		 	{
		 	&SQL(Update SQLUSER.DHC_EQDisuseRequest values :PLIST() 
 			where DR_RowID = :DRRowID and %INTERNAL(DR_Status)=0 )	
 			/// 报废分步：  (0:正常  1：报废院内审批  2：报废主管局审批)
 			i SQLCODE=0
 				{
 				s specialRole=##class(web.DHCEQCommon).GetSysInfo("601003")
 				i ((specialRole'="")&&(specialRole=curNextRole))
 					{s SQLCODE=..DisuseEquipList(DRRowID,"1")}
 				} 
 			}
		 }
 		}
 	if (iscancel=1)
 		{if (status'=1) q -2014
 		&SQL(Update SQLUSER.DHC_EQDisuseRequest set DR_Status=0,DR_SubmitUserDR=:user,DR_SubmitDate=:updDate,DR_SubmitTime=:updTime,DR_RejectReason=:RejectReason 
 		where DR_RowID = :DRRowID  and %INTERNAL(DR_Status)=1 )
 		if (SQLCODE=0)&&(equipdr="")
 		{
	 		s SQLCODE=..DisuseEquipList(DRRowID,"0")
	 	}
 		}
 	if SQLCODE 
 	{
	 	TRollback
	 	if (SQLCODE=100) q -2101
	 	q SQLCODE
 	}
 	TCommit
 	q DRRowID
}

ClassMethod GetApproveInfo(disuseRequestid, EquipType, PurchaseType, MaxPrice, SpecialType)
{
	s EQRowID=$P(^DHCEQDisuseRequest(disuseRequestid),"^",1)
	if EQRowID'=""
	{
 		s EquipType=$P(^DHCEQEquip(EQRowID),"^",63)
	 	s PurchaseType=$P(^DHCEQEquip(EQRowID),"^",64)
	 	s MaxPrice=$P(^DHCEQEquip(EQRowID),"^",27)
	 	s SpecialType=..GetSpecialType(EQRowID)	 	
	}
	else
	{
		s EquipType=""
	 	s PurchaseType=""
	 	&SQL(Select Max(DRL_EquipDR->EQ_OriginalFee) into :MaxPrice from SQLUSER.DHC_EQDisuseRequestList Where DRL_DisuseRequestDR=:disuseRequestid)
	 	s SpecialType=""
	}
	q
}

ClassMethod DisuseEquipList(disuseRequestid, flag As %Library.String = "2")
{
	if disuseRequestid="" q 0
	s listerr=0
	s listrowid=0
	f  s listrowid=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",disuseRequestid,listrowid))  quit:((listrowid="")||(listerr'=0))  d
	.s listequipid=$p($g(^DHCEQDisuseRequestList(listrowid)),"^",2)
	.q:listequipid=""
	.i flag="2" d
	..&SQL(Update SQLUSER.DHC_EQEquip set EQ_Status=3,EQ_Hold1=2 where EQ_RowID =:listequipid and EQ_Status<>3)
	.e  i flag="1"  d
	..&SQL(Update SQLUSER.DHC_EQEquip set EQ_Hold1=1 where EQ_RowID =:listequipid and EQ_Status<>3)
	.e  i flag="0"
	..&SQL(Update SQLUSER.DHC_EQEquip set EQ_Hold1=0 where EQ_RowID =:listequipid and EQ_Status<>3)
	.i SQLCODE s listerr=SQLCODE
	q listerr
}

ClassMethod GetSpecialType(EQRowID)
{
	s SpecialType=""
	s EquipCat=$P(^DHCEQEquip(EQRowID),"^",4)
	i EquipCat'="" s SpecialType=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCat),"^",5)
	q SpecialType
}

ClassMethod GetApproveSet(EQRowID)
{
	i EQRowID="" q ""
	s DRRowID=""
	&SQL(Select DR_RowID into :DRRowID from SQLUSER.DHC_EQDisuseRequest Where DR_EquipDR=:EQRowID)
	i DRRowID="" q ""
	q $P(^DHCEQDisuseRequest(DRRowID),"^",27)
}

/// 修改：zy 2009-07-16   zy0006
/// 描述：增加报表中需要的设备基本信息
/// 输入：val：报废申请单号rowid
/// w ##Class(web.DHCEQDisuseRequest).GetDisuseRequestByID( , , rowid, )
ClassMethod GetDisuseRequestByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "", equipdr As %Library.String = "")
{
	new result,resultex,i,count
	s (result,resultex)=""
	if ((rowid="")&&(equipdr'="")) d
	.s rowid=0
	.s rowid=$o(^DHCEQDisuseRequest(0,"Equip",equipdr,rowid))
	if (rowid=0)||(rowid="")  q ""
	s result= $g(^DHCEQDisuseRequest(rowid))
	if result="" q ""
	set count=..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}	
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;GroupDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQGroup($p(result,"^",2))),"^",1)
	s resultex=resultex_"^"	;RequestLocDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))
	s $p(result,"^",4)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",4),"date")	;RequestDate
	s resultex=resultex_"^"	;DisuseTypeDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDisuseType",$p(result,"^",6))),"^",2)
	s $p(result,"^",8)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"date")	;DisureDate
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",11))
	s $p(result,"^",12)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",14))
	s $p(result,"^",15)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",15),"date")	;UpdateDate
	s resultex=resultex_"^"	;SubmitUserDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",17))
	s $p(result,"^",18)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",18),"date")	;SubmitDate
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",20))
	s $p(result,"^",21)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",21),"date")	;AuditDate
	s resultex=resultex_"^"	;RejectUserDR
	i $p(result,"^",24)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",24))
	s $p(result,"^",25)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",25),"date")	;RejectDate
	s resultex=resultex_"^"	;ApproveSetDR
	//i $p(result,"^",27)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQCApproveSet($p(result,"^",27))),"^",1)
	s resultex=resultex_"^"	;NextRoleDR
	//i $p(result,"^",28)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQCApproveRole($p(result,"^",28))),"^",1)
	s resultex=resultex_"^"	;ApproveRoleDR
	//i $p(result,"^",31)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQCApproveRole($p(result,"^",31))),"^",1)
	
	//s resultex=resultex_"^"_##Class(web.DHCEQCommon).GetEditStatusDisplay($p(result,"^",10))
	s resultex=resultex_"^"_rowid
	
	///****add by zy  2009-7-16  zy0006************************************///
	s resultex=resultex_"^"	;设备信息
	i rowid'=""  d
	.s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",rowid,0))
	.i DRLRowID'="" d
	..s DRLEquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	..i DRLEquipDR'="" d
	...s resultex=resultex_$p($g(^DHCEQEquip(DRLEquipDR)),"^",1)_"^"  //设备名
	...s resultex=resultex_$p($g(^DHCEQEquip(DRLEquipDR)),"^",71)_"^"  //设备编号
	...i $p($g(^DHCEQEquip(DRLEquipDR)),"^",26)'="" d                 //生产厂家
	....s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",($p($g(^DHCEQEquip(DRLEquipDR)),"^",26)))),"^",1)_"^" 
	...i $p($g(^DHCEQEquip(DRLEquipDR)),"^",26)="" d
	....s resultex=resultex_""_"^"

	...i $p($g(^DHCEQEquip(DRLEquipDR)),"^",16)'="" d                 //国别
	....s resultex=resultex_$p($g(^CT("COU",($p($g(^DHCEQEquip(DRLEquipDR)),"^",16)))),"^",2)_"^" 
	...i $p($g(^DHCEQEquip(DRLEquipDR)),"^",16)="" d
	....s resultex=resultex_""_"^"

	...i $p($g(^DHCEQEquip(DRLEquipDR)),"^",25)'="" d                 //供应商
	....s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCVendor",($p($g(^DHCEQEquip(DRLEquipDR)),"^",25)))),"^",2)_"^" 
	...i $p($g(^DHCEQEquip(DRLEquipDR)),"^",25)="" d
	....s resultex=resultex_""_"^"

	...i $p($g(^DHCEQEquip(DRLEquipDR)),"^",3)'="" d 					//规格型号
	....s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",($p($g(^DHCEQEquip(DRLEquipDR)),"^",3)))),"^",2)_"^"  
	...i $p($g(^DHCEQEquip(DRLEquipDR)),"^",3)="" d
	....s resultex=resultex_""_"^"

	...s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(DRLEquipDR)),"^",11),"date")_"^" ;出厂日期
	...s resultex=resultex_$p($g(^DHCEQEquip(DRLEquipDR)),"^",10)_"^" //出厂编号
	...s resultex=resultex_$p($g(^DHCEQEquip(DRLEquipDR)),"^",27)_"^" //价格
	
	...i $p($g(^DHCEQEquip(DRLEquipDR)),"^",19)'="" d 				//使用科室
	....s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("deptcode",$p($g(^DHCEQEquip(DRLEquipDR)),"^",19))
	...i $p($g(^DHCEQEquip(DRLEquipDR)),"^",19)="" d
	....s resultex=resultex_""_"^"
	
	...s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(DRLEquipDR)),"^",44),"date")_"^" ;起用日期
	
	...i $p($g(^DHCEQEquip(DRLEquipDR)),"^",66)'="" d 				//操作者
	....s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",($p($g(^DHCEQEquip(DRLEquipDR)),"^",66)))_"^" 
	...i $p($g(^DHCEQEquip(DRLEquipDR)),"^",66)="" d
	....s resultex=resultex_""_"^"
	
	...s resultex=resultex_$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",3)_"^"  //使用状态
	...s resultex=resultex_$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",5)  //报废原因
	...s list=0   
	...f  s list=$o(^DHCEQApproveList(0,"Source",5,DRLRowID,list)) q:list=""  d
	....s ApproveRole=$p(^DHCEQCCode("DHCEQCApproveRole",($p(^DHCEQApproveList(list),"^",5))),"^",2)
	....s Opinion=$p(^DHCEQApproveList(list),"^",3)
	....s ApproveUser=##class(web.DHCEQCommon).GetTrakNameByID("user",($p(^DHCEQApproveList(list),"^",8)))
	....s ApproeeUserDate=##class(web.DHCEQCommon).TransValueToPage($p(^DHCEQApproveList(list),"^",7),"date")
	....s resultex=resultex_"^"_ApproveRole_"^"_Opinion_"^"_ApproveUser_"^"_ApproeeUserDate

	///****end   2009-7-16  zy0006*********************************
	
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

Query GetDisuseRequest(ReplacesAD, ApproveRole, Type, StatusDR, EquipDR, RequestLocDR, EquipTypeDR, PurchaseTypeDR, StartDate, EndDate, WaitAD, QXType) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TGroupDR:%String,TRequestLocDR:%String,TRequestDate:%String,TUseState:%String,TDisuseTypeDR:%String,TChangeReason:%String,TDisureDate:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TRejectReason:%String,TRejectUserDR:%String,TRejectDate:%String,TRejectTime:%String,TApproveSetDR:%String,TNextRoleDR:%String,TNextFlowStep:%String,TApproveStatu:%String,TApproveRoleDR:%String,THold1:%String,TRequestNo:%String,TEquip:%String,TGroup:%String,TRequestLoc:%String,TDisuseType:%String,TAddUser:%String,TUpdateUser:%String,TSubmitUser:%String,TAuditUser:%String,TRejectUser:%String,TApproveSet:%String,TNextRole:%String,TApproveRole:%String,TModelDR:%String,TModel:%String,TManuFactoryDR:%String,TManuFactory:%String,TEquipTypeDR:%String,TEquipType:%String,TPurchaseTypeDR:%String,TPurchaseType:%String,TPrice:%String")
{
}

ClassMethod GetDisuseRequestExecute(ByRef qHandle As %Binary, ReplacesAD, ApproveRole, Type, StatusDR, EquipDR, RequestLocDR, EquipTypeDR, PurchaseTypeDR, StartDate, EndDate, WaitAD, QXType) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetDisuseRequest
	Quit $$$OK
BuildDataGetDisuseRequest
	if WaitAD'="on"
	{
		if ReplacesAD="on"
		{
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
			s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
			s ALRowID=0
			f  s ALRowID=$o(^DHCEQApproveList(0,"Role",ApproveType,ApproveRole,ALRowID)) q:ALRowID=""  d
			.s ADUser=$p(^DHCEQApproveList(ALRowID),"^",6)
			.q:ADUser=CurUser
			.s rowid=$p(^DHCEQApproveList(ALRowID),"^",2)
			.d ResetVariablesGetDisuseRequest
			.d GetOneDisuseRequest
		}
		else
		{
			f  s rowid=$o(^DHCEQDisuseRequest(rowid))  quit:rowid=""  d
			.d ResetVariablesGetDisuseRequest
			.d GetOneDisuseRequest
		}
	}
	else
	{
		if Type="1"
		{
			f  s rowid=$o(^DHCEQDisuseRequest(0,"ApproveRole",1,ApproveRole,rowid))  quit:rowid=""  d
			.d ResetVariablesGetDisuseRequest
			.d GetOneDisuseRequest
			s rowid=0
			s ApproveSet=0
			s ApproveFlow=0
			s ApproveFlowStep=""
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("5")
			f  s ApproveSet=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveType,ApproveSet))  quit:ApproveSet=""  d
			.f   s ApproveFlow=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,ApproveRole,ApproveFlow))  quit:ApproveFlow=""  d
			..s ApproveFowStep=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlow),"^",3)
			..f   s rowid=$o(^DHCEQDisuseRequest(0,"ApproveSet",1,ApproveSet,ApproveFowStep,rowid))  quit:rowid=""  d
			...s Role=$p(^DHCEQDisuseRequest(rowid),"^",28)
			...q:Role'=""
			...s Approved=##class(web.DHCEQCApproveSet).HasApprove(ApproveType, rowid, ApproveFowStep, ApproveRole)
			...q:Approved>0
			...d ResetVariablesGetDisuseRequest
			...d GetOneDisuseRequest
		}
		if Type="2"
		{
			s rowid=0
			s NextStep=""
			f  s rowid=$o(^DHCEQDisuseRequest(0,"Status",1,rowid))  quit:rowid=""  d
			.s NextStep=$p($G(^DHCEQDisuseRequest(rowid)),"^",29)
			.q:NextStep'=""
			.d ResetVariablesGetDisuseRequest
			.d GetOneDisuseRequest
		}
	}
	quit
GetOneDisuseRequest
	s TRowID = rowid
	s TEquipDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",1)
	q:(EquipDR'="")&&(EquipDR'=TEquipDR)
	i TEquipDR '=""  d
	.s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	.i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
	.i TManuFactoryDR'="" s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	.s TEquipTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",63)
	.i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.s TPurchaseTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",64)
	.i TPurchaseTypeDR'="" s TPurchaseType=$p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	.s TPrice=$p($g(^DHCEQEquip(TEquipDR)),"^",27)
	q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	q:(PurchaseTypeDR'="")&&(PurchaseTypeDR'=TPurchaseTypeDR)
	s TGroupDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",2)
	i TGroupDR '=""  d
	.s TGroup = $p($g(^DHCEQGroup(TGroupDR)),"^",2)
	s TRequestLocDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",3)
	q:(RequestLocDR'="")&&(RequestLocDR'=TRequestLocDR)
	i TRequestLocDR '=""  d
	.s TRequestLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	q:($p($g(^DHCEQDisuseRequest(rowid)),"^",4)>EndDate)||($p($g(^DHCEQDisuseRequest(rowid)),"^",4)<StartDate)
	s TRequestDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(rowid)),"^",4),"date")
	s TUseState = $p($g(^DHCEQDisuseRequest(rowid)),"^",5)
	s TDisuseTypeDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",6)
	i TDisuseTypeDR '=""  d
	.s TDisuseType = $p($g(^DHCEQCCode("DHCEQCDisuseType",TDisuseTypeDR)),"^",2)
	s TChangeReason = $p($g(^DHCEQDisuseRequest(rowid)),"^",7)
	s TDisureDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(rowid)),"^",8),"date")
	s TRemark = $p($g(^DHCEQDisuseRequest(rowid)),"^",9)
	s TStatus = $p($g(^DHCEQDisuseRequest(rowid)),"^",10)
	q:(StatusDR'="")&&(StatusDR'=TStatus)
	i ((Type'=0)&&(TStatus="0")) q
	s TStatus=##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	s TAddUserDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",11)
	i TAddUserDR '=""  d
	.s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	s TAddDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(rowid)),"^",12),"date")
	s TAddTime = $p($g(^DHCEQDisuseRequest(rowid)),"^",13)
	s TUpdateUserDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",14)
	i TUpdateUserDR '=""  d
	.s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	s TUpdateDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(rowid)),"^",15),"date")
	s TUpdateTime = $p($g(^DHCEQDisuseRequest(rowid)),"^",16)
	s TSubmitUserDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",17)
	i TSubmitUserDR '=""  d
	.s TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	s TSubmitDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(rowid)),"^",18),"date")
	s TSubmitTime = $p($g(^DHCEQDisuseRequest(rowid)),"^",19)
	s TAuditUserDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",20)
	i TAuditUserDR '=""  d
	.s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	s TAuditDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(rowid)),"^",21),"date")
	s TAuditTime = $p($g(^DHCEQDisuseRequest(rowid)),"^",22)
	s TRejectReason = $p($g(^DHCEQDisuseRequest(rowid)),"^",23)
	s TRejectUserDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",24)
	i TRejectUserDR '=""  d
	.s TRejectUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TRejectUserDR)
	s TRejectDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(rowid)),"^",25),"date")
	s TRejectTime = $p($g(^DHCEQDisuseRequest(rowid)),"^",26)
	s TApproveSetDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",27)
	//i TApproveSetDR '=""  d
	//.s TApproveSet = $p($g(^DHCEQCApproveSet(TApproveSetDR)),"^",1)
	s TNextRoleDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",28)
	//i TNextRoleDR '=""  d
	//.s TNextRole = $p($g(^DHCEQCApproveRole(TNextRoleDR)),"^",2)
	s TNextFlowStep = $p($g(^DHCEQDisuseRequest(rowid)),"^",29)
	s TApproveStatu = $p($g(^DHCEQDisuseRequest(rowid)),"^",30)
	s TApproveRoleDR = $p($g(^DHCEQDisuseRequest(rowid)),"^",31)
	//i TApproveRoleDR '=""  d
	//.s TApproveRole = $p($g(^DHCEQCApproveRole(TApproveRoleDR)),"^",2)
	s THold1 = $p($g(^DHCEQDisuseRequest(rowid)),"^",32)
	s TRequestNo = $p($g(^DHCEQDisuseRequest(rowid)),"^",33)
	
	s TUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TRequestLocDR)))  ;&&("N"=..GetUserLoc(TUserID,TRequestLocDR,""))
	d OutputRowGetDisuseRequest
	quit
OutputRowGetDisuseRequest
	s Data=$lb(TRowID,TEquipDR,TGroupDR,TRequestLocDR,TRequestDate,TUseState,TDisuseTypeDR,TChangeReason,TDisureDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatu,TApproveRoleDR,THold1,TRequestNo,TEquip,TGroup,TRequestLoc,TDisuseType,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TRejectUser,TApproveSet,TNextRole,TApproveRole,TModelDR,TModel,TManuFactoryDR,TManuFactory,TEquipTypeDR,TEquipType,TPurchaseTypeDR,TPurchaseType,TPrice)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDisuseRequest
	s (TRowID,TEquipDR,TGroupDR,TRequestLocDR,TRequestDate,TUseState,TDisuseTypeDR,TChangeReason,TDisureDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TRejectReason,TRejectUserDR,TRejectDate,TRejectTime,TApproveSetDR,TNextRoleDR,TNextFlowStep,TApproveStatu,TApproveRoleDR,THold1,TRequestNo,TEquip,TGroup,TRequestLoc,TDisuseType,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TRejectUser,TApproveSet,TNextRole,TApproveRole,TModelDR,TModel,TManuFactoryDR,TManuFactory,TEquipTypeDR,TEquipType,TPurchaseTypeDR,TPurchaseType,TPrice)=""
	quit
}

ClassMethod GetDisuseRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisuseRequestExecute ]
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

ClassMethod GetDisuseRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisuseRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetList(disuseid)
{
	s listids=""
	s rowid=0
	f  s rowid=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",disuseid,rowid))  quit:rowid=""  d
	.if listids'="" s listids=listids_"^"
	.s listids=listids_rowid
	q listids
}

/// w ##Class(web.DHCEQDisuseRequest).GetDisuseFeeByRequest(1)
ClassMethod GetDisuseFeeByRequest(disuseRequestid)
{
	new disusefee,listrowid,disuseEquipDR
	s disusefee=0
	if disuseRequestid="" q disusefee
	
	s disuseEquipDR=$p($g(^DHCEQDisuseRequest(disuseRequestid)),"^",1)
	i disuseEquipDR'="" q +$p($g(^DHCEQEquip(disuseEquipDR)),"^",27)
	
	s listrowid=0
	f  s listrowid=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",disuseRequestid,listrowid))  quit:(listrowid="")  d
	.s disuseEquipDR=$p($g(^DHCEQDisuseRequestList(listrowid)),"^",2)
	.q:disuseEquipDR=""
	.s disusefee=disusefee+$p($g(^DHCEQEquip(disuseEquipDR)),"^",27)
	
	q disusefee
}

/// /add by jdl 2009-11-25
Query GetDisuseList(DisuseRequestID) As %Query(ROWSPEC = "TRowID:%String,TDisuseRequestDR:%String,TSourceType:%String,TSourceID:%String,TQty:%String,TUseState:%String,TDisuseReason:%String,TDisuseDate:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TEquipName:%String,TModel:%String,TManufactory:%String,TInStockDate:%String,TLimitYears:%String,ToriginalFee:%String,TEqNo:%String,TFactoryNo:%String,TMaxQty:%String,TIDs:%String")
{
}

ClassMethod GetDisuseListExecute(ByRef qHandle As %Binary, DisuseRequestID) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetDisuseList
	Quit $$$OK
BuildDataGetDisuseList
	if ((DisuseRequestID="")||($o(^DHCEQDisuseList(0,"Request",DisuseRequestID,""))=""))
	{
		d ResetVariablesGetDisuseList
		d OutputRowGetDisuseList
		quit
	}
	s TRowID=0
	f  s TRowID=$o(^DHCEQDisuseList(0,"Request",DisuseRequestID,TRowID))  quit:TRowID=""  d
	.d ResetVariablesGetDisuseList
	.d GetOneDisuseList	
	quit
	
GetOneDisuseList
	s TDisuseRequestDR=$p($g(^DHCEQDisuseList(TRowID)),"^",1)
	s TSourceType=$p($g(^DHCEQDisuseList(TRowID)),"^",2)
	s TSourceID=$p($g(^DHCEQDisuseList(TRowID)),"^",3)
	s TQty=$p($g(^DHCEQDisuseList(TRowID)),"^",4)
	s TUseState=$p($g(^DHCEQDisuseList(TRowID)),"^",5)
	s TDisuseReason=$p($g(^DHCEQDisuseList(TRowID)),"^",6)
	s TDisuseDate=$p($g(^DHCEQDisuseList(TRowID)),"^",7)
	s TRemark=$p($g(^DHCEQDisuseList(TRowID)),"^",8)
	s THold1=$p($g(^DHCEQDisuseList(TRowID)),"^",9)
	s THold2=$p($g(^DHCEQDisuseList(TRowID)),"^",10)
	s THold3=$p($g(^DHCEQDisuseList(TRowID)),"^",11)
	s THold4=$p($g(^DHCEQDisuseList(TRowID)),"^",12)
	s THold5=$p($g(^DHCEQDisuseList(TRowID)),"^",13)
	if TSourceType="1"	//批量
	{
		s TEquipName=$p($g(^DHCEQInStockList(TSourceID)),"^",5)
		s TModel=$p($g(^DHCEQInStockList(TSourceID)),"^",9)
		s TManufactory=$p($g(^DHCEQInStockList(TSourceID)),"^",6)
		s TInStockDate=##Class(web.DHCEQInStockList).GetInStockDate(TSourceID,0)
		s TLimitYears=$p($g(^DHCEQInStockList(TSourceID)),"^",15)
		s ToriginalFee=$p($g(^DHCEQInStockList(TSourceID)),"^",7)
		s id=0		
		f  s id=$o(^DHCEQDisuseList(TRowID,"EX","IDS",id))  quit:id=""  d
		.s TEqNo=TEqNo_","_$p($g(^DHCEQEquip(id)),"^",71)
		.s TFactoryNo=TFactoryNo_","_$p($g(^DHCEQEquip(id)),"^",10)
		.s TIDs=TIDs_","_id
		
		s TMaxQty=0
		s UseLocDR=$p($g(^DHCEQDisuseRequest(DisuseRequestID)),"^",34)
		s id=0
		f  s id=$o(^DHCEQEquip(0,"InStockList",TSourceID,UseLocDR,id))  quit:id=""  d
		.q:$p($g(^DHCEQEquip(id)),"^",38)=3		//Status:0:新增|1:启用|2:封存|3:报废|4:其他
		.q:$p($g(^DHCEQEquip(id)),"^",38)=4		//Status:0:新增|1:启用|2:封存|3:报废|4:其他
		.q:$p($g(^DHCEQEquip(id)),"^",60)'=1	//StockStatus:0:新增|1:入库|2:转移出库|3:出库
		.s TMaxQty=TMaxQty+1		
	}
	else
	{
		s TEquipName=$p($g(^DHCEQEquip(TSourceID)),"^",1)
		s TModel=$p($g(^DHCEQEquip(TSourceID)),"^",3)
		s TManufactory=$p($g(^DHCEQEquip(TSourceID)),"^",26)
		s TInStockDate=##Class(web.DHCEQEquip).GetInStockDate(TSourceID,0)
		s TLimitYears=$p($g(^DHCEQEquip(TSourceID)),"^",31)
		s ToriginalFee=$p($g(^DHCEQEquip(TSourceID)),"^",27)
		
		s TEqNo=$p($g(^DHCEQEquip(TSourceID)),"^",71)
		s TFactoryNo=$p($g(^DHCEQEquip(TSourceID)),"^",10)
		s TMaxQty=1
		s TIDs=TSourceID
	}
	d OutputRowGetDisuseList
	quit
OutputRowGetDisuseList
	s Data=$lb(TRowID,TDisuseRequestDR,TSourceType,TSourceID,TQty,TUseState,TDisuseReason,TDisuseDate,TRemark,THold1,THold2,THold3,THold4,THold5,TEquipName,TModel,TManufactory,TInStockDate,TLimitYears,ToriginalFee,TEqNo,TFactoryNo,TMaxQty,TIDs)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDisuseList
	s (TRowID,TDisuseRequestDR,TSourceType,TSourceID,TQty,TUseState,TDisuseReason,TDisuseDate,TRemark,THold1,THold2,THold3,THold4,THold5,TEquipName,TModel,TManufactory,TInStockDate,TLimitYears,ToriginalFee,TEqNo,TFactoryNo,TMaxQty,TIDs)=""
	quit
}

ClassMethod GetDisuseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisuseListExecute ]
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

ClassMethod GetDisuseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisuseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 报废恢复
/// Modefied by zc 2015-07-07 zc0026
/// w ##Class(web.DHCEQDisuseRequest).RecDisuse(1507230000008)
ClassMethod RecDisuse(requestno)
{
	new rowid,drowid,kindflag,requestdate,auditdate,disdate,InvalidFlag,dstatus,drowid,reportstartdate,reportenddate
	Set $ZT="ERRORRecDisuse"
	s rowid=""
	s drowid=""
	s InvalidFlag=""
	s dstatus=0
	i requestno="" q ""
	s MonthStr=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	s reportstartdate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"1")
	
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	s reportstartdate=##class(web.DHCEQCommon).TransValueFromPage(reportstartdate,"date")
	s reportendadte=##Class(web.DHCEQReport).GetReportDate(MonthStr,"2")
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	s reportendadte=##class(web.DHCEQCommon).TransValueFromPage(reportendadte,"date")
	i $D(^DHCEQDisuseRequest(0,"RequestNo"," "_requestno)) d
	.s drowid=$o(^DHCEQDisuseRequest(0,"RequestNo"," "_requestno,0))	
	.s InvalidFlag=$p($g(^DHCEQDisuseRequest(drowid)),"^",53)
	.q:InvalidFlag="Y"
	.s dstatus=$p($g(^DHCEQDisuseRequest(drowid)),"^",10)
	.q:dstatus'=2
	.s kindflag=$p($g(^DHCEQDisuseRequest(drowid)),"^",44)
	.s auditdate=$p($g(^DHCEQDisuseRequest(drowid)),"^",21)
	.;q:($e($zd(auditdate,3),1,*-3))'=(($e($zd($h,3),1,*-3)))
	.;q:(auditdate<(reportstartdate-1))||(auditdate>(reportendadte+1))
	.q:(auditdate<reportstartdate)||(auditdate>(reportendadte))
	.s rowid=drowid
	.s disdate=auditdate

	i drowid="" q "当前单据不存在"
	i InvalidFlag="Y" q "当前单据无效"
	i dstatus'=2 q "当前单据未审核完成"
	
	i rowid="" q "当前单据不是这个月的单据"
	TSTART
	i rowid'=""
	{
		i (kindflag=2)
		{
			&SQL(delete from SQLUSER.DHC_EQDisuseList where DL_DisuseRequestDR = :rowid)
	 		i SQLCODE
			{
				TROLLBACK
				q SQLCODE_"^删除多批次报废单明细信息失败!"
			}
		}
		/*i (kindflag=1)
		{
			k ^DHCEQDisuseRequest(rowid,"EX")
		}*/
		s SQLCODE=..DeleteDisuseRequestList(rowid,disdate)
	 	i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^删除报废单明细信息失败!"
		}
		
		&SQL(delete from SQLUSER.DHC_EQDisuseRequest where DR_RequestNo = :requestno)
 		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^删除报废申请信息失败!"
		}
	}
	if (SQLCODE)
	{
		TROLLBACK
	}
	else
	{
		TCOMMIT
	}

	q SQLCODE
ERRORRecDisuse 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORRecDisuse>"_ErrorMsg     //返回错误消息 ;
}

ClassMethod DeleteDisuseRequestList(rowid, disdate)
{
	i rowid="" q 0
	s drlrowid=0
	f  s drlrowid=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",rowid,drlrowid))  quit:drlrowid=""  d
	.s equipdr=$p($g(^DHCEQDisuseRequestList(drlrowid)),"^",2)
	.s hold1=$p($g(^DHCEQDisuseRequestList(drlrowid)),"^",11)
	.&SQL(update sqluser.DHC_EQEquip  set EQ_Status=:hold1,EQ_DisuseDate=NULL,EQ_AdvanceDisFlag=NULL where EQ_RowID=:equipdr)
	.q:SQLCODE'=0
	.&SQL(delete from SQLUSER.DHC_EQLifeInfo where LI_EquipDR = :equipdr and LI_LifeType='C' and LI_ChangeDate=:disdate and LI_SourceType='34')
	.q:SQLCODE'=0
	.&SQL(delete from SQLUSER.DHC_EQDisuseRequestList where DRL_EquipDR = :equipdr and DRL_DisuseRequestDR=:rowid)
	.q:SQLCODE'=0
	
	q SQLCODE
}

}
