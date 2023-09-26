Class web.DHCEQCheckUse Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 40;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CU_RowID";

Parameter SQLDESCRIPTION = "CU_RowID";

Parameter SQLROWID = "CU_RowID";

ClassMethod UpdateCheckUse(itms As %Library.String = "", itmsex As %Library.String = "", val, AppType, RowID, EquipDR, User)
{
	//+AppType=0 插入，更新
	//+AppType=1 提交
	//+AppType=2 审核
	//+AppType=3 删除
	//RowID 为Check记录的ID
	//EquipDR 为Equip的ID
	//User 为操作员ID
 	if +AppType=0 
 	{
	    s PLIST(1) = $p(val,"^",1)	;RowID
	    s CURowID=PLIST(1)
 		s PLIST(2) = $p(val,"^",2)	;EquipDR
 		s PLIST(3) = $p(val,"^",3)	;UseDate
 		i $p(val,"^",3)'=""  s PLIST(3) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",3),"date")	;UseDate
 		s PLIST(4) = $p(val,"^",4)	;OriginalFee
 		s PLIST(5) = $p(val,"^",5)	;NetRemainFee
 		s PLIST(6) = $p(val,"^",6)	;LimitYearsNum
 		s PLIST(7) = $p(val,"^",7)	;UseLocDR
 		s PLIST(8) = AppType //$p(val,"^",8)	;Status
 		s PLIST(9) = $p(val,"^",9)	;Remark
 		s PLIST(10) = $p(val,"^",10)	;DepreMethodDR
 		s PLIST(11) = $p(val,"^",11)	;TransAssetDate
 		i $p(val,"^",11)'=""  s PLIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"date")	;TransAssetDate
 		/*s PLIST(12) = $p(val,"^",12)	;AddUserDR
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
 		s PLIST(20) = $p(val,"^",20)	;AuditTime*/
 		k PLIST(1)
 		TSTART
 		if CURowID=""
 		{
	 		s PLIST(12)=User
	 		s PLIST(13)=+$H
	 		s PLIST(14)=$P($H,",",2)
	 		
	 		&sql(insert into sqluser.DHC_EQCheckUse values :PLIST())
	 		if SQLCODE
	 		{
		 		TROLLBACK
		 		q SQLCODE
	 		}
	 		s ID=$G(%ROWID)
 		}
 		else
 		{
	 		s PLIST(15)=User
	 		s PLIST(16)=+$H
	 		s PLIST(17)=$P($H,",",2)
	 		&sql(update sqluser.DHC_EQCheckUse values :PLIST() where CU_ROWID=:CURowID)
	 		if SQLCODE
	 		{
		 		TROLLBACK
		 		q SQLCODE
	 		}
	 		s ID=$G(%ROWID)
 		}
 		TCOMMIT
	 	q ID
 	}
 	if +AppType=1
 	{
	 	s PLIST(8)=AppType
	 	s PLIST(15)=User
	 	s PLIST(16)=+$H
	 	s PLIST(17)=$P($H,",",2)
	 	TSTART
	 	&sql(update sqluser.DHC_EQCheckUse values :PLIST() where CU_ROWID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
	 	TCOMMIT
	 	q ID
 	}
 	if +AppType=2
 	{
	 	s PI(45)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",1),"date") ;UseDate
 		s PI(20)=$P(val,"^",2) ;UseLoc
 		s PI(32)=$P(val,"^",3) ;LimitYears
 		s PI(28)=$P(val,"^",4) ;OriginValue
 		s PI(30)=$P(val,"^",5) ;ReaminValue
 		s PI(34)=$P(val,"^",6) ;DepareMethod
 		s PI(46)=##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",7),"date") ;TranValueDate
 		s PI(56)=User
	 	s PI(57)=+$H
	 	s PI(58)=$P($H,",",2)
	 	s PLIST(8)=AppType
	 	s PLIST(18)=User
	 	s PLIST(19)=PI(57)
	 	s PLIST(20)=PI(58)
	 	TSTART
	 	&sql(update sqluser.DHC_EQCheckUse values :PLIST() where CU_ROWID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
	 	&sql(update sqluser.DHC_EQEquip values :PI() where EQ_RowID=:EquipDR)
 		if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	TCOMMIT
	 	q ID
 	}
 	if +AppType=3
 	{
	 	//s PLIST(24)="Y"
	 	//s PLIST(15)=User
	 	//s PLIST(16)=+$H
	 	//s PLIST(17)=$P($H,",",2)
	 	TSTART
	 	&sql(delete from sqluser.DHC_EQCheckUse where CU_RowID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	TCOMMIT
	 	q ""
 	}
}

Query GetCheckUse(EquipDR, ManageLocDR, UseLocDR, StatusDR, StartDate, EndDate) As %Query(ROWSPEC = "TManuFactoryDR:%String,TManuFactory:%String,TManageLocDR:%String,TManageLoc:%String,TModelDR:%String,TModel:%String,TRowID:%String,TEquipDR:%String,TUseDate:%String,TOriginalFee:%String,TNetRemainFee:%String,TLimitYearsNum:%String,TUseLocDR:%String,TStatus:%String,TRemark:%String,TDepreMethodDR:%String,TTransAssetDate:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TEquip:%String,TUseLoc:%String,TDepreMethod:%String,TAddUser:%String,TUpdateUser:%String,TAuditUser:%String")
{
}

ClassMethod GetCheckUseExecute(ByRef qHandle As %Binary, EquipDR, ManageLocDR, UseLocDR, StatusDR, StartDate, EndDate) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetCheckUse
	Quit $$$OK
BuildDataGetCheckUse
	f  s rowid=$o(^DHCEQCheckUse(rowid))  quit:rowid=""  d
	.d ResetVariablesGetCheckUse
	.s TRowID = rowid
	.q:(EquipDR="")&&(ManageLocDR="")&&(UseLocDR="")&&(StartDate="")&&(EndDate="")&&(StatusDR="")
	.s TEquipDR = $p($g(^DHCEQCheckUse(rowid)),"^",1)
	.q:(EquipDR'="")&&(TEquipDR'=EquipDR)
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	..i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..s TManageLocDR=$p($g(^DHCEQEquip(TEquipDR)),"^",17)
	..i TManageLocDR'="" s TManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	..s TManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
	..i TManuFactoryDR'="" s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	.s TUseDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCheckUse(rowid)),"^",2),"date")
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$H
	.q:($p($g(^DHCEQCheckUse(rowid)),"^",2)>EndDate)||($p($g(^DHCEQCheckUse(rowid)),"^",2)<StartDate)
	.s TOriginalFee = $p($g(^DHCEQCheckUse(rowid)),"^",3)
	.s TNetRemainFee = $p($g(^DHCEQCheckUse(rowid)),"^",4)
	.s TLimitYearsNum = $p($g(^DHCEQCheckUse(rowid)),"^",5)
	.s TUseLocDR = $p($g(^DHCEQCheckUse(rowid)),"^",6)
	.q:(ManageLocDR'="")&&(TManageLocDR'=ManageLocDR)
	.q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
	.i TUseLocDR '=""  d
	..s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.s TStatus = $p($g(^DHCEQCheckUse(rowid)),"^",7)
	.q:(StatusDR'="")&&(TStatus'=StatusDR)
	.s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.s TRemark = $p($g(^DHCEQCheckUse(rowid)),"^",8)
	.s TDepreMethodDR = $p($g(^DHCEQCheckUse(rowid)),"^",9)
	.i TDepreMethodDR '=""  d
	..s TDepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	.s TTransAssetDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCheckUse(rowid)),"^",10),"date")
	.s TAddUserDR = $p($g(^DHCEQCheckUse(rowid)),"^",11)
	.i TAddUserDR '=""  d
	..s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCheckUse(rowid)),"^",12),"date")
	.s TAddTime = $p($g(^DHCEQCheckUse(rowid)),"^",13)
	.s TUpdateUserDR = $p($g(^DHCEQCheckUse(rowid)),"^",14)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCheckUse(rowid)),"^",15),"date")
	.s TUpdateTime = $p($g(^DHCEQCheckUse(rowid)),"^",16)
	.s TAuditUserDR = $p($g(^DHCEQCheckUse(rowid)),"^",17)
	.i TAuditUserDR '=""  d
	..s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.s TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCheckUse(rowid)),"^",18),"date")
	.s TAuditTime = $p($g(^DHCEQCheckUse(rowid)),"^",19)
	.d OutputRowGetCheckUse
	quit
OutputRowGetCheckUse
	s Data=$lb(TManuFactoryDR,TManuFactory,TManageLocDR,TManageLoc,TModelDR,TModel,TRowID,TEquipDR,TUseDate,TOriginalFee,TNetRemainFee,TLimitYearsNum,TUseLocDR,TStatus,TRemark,TDepreMethodDR,TTransAssetDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TEquip,TUseLoc,TDepreMethod,TAddUser,TUpdateUser,TAuditUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCheckUse
	s (TManuFactoryDR,TManuFactory,TManageLocDR,TManageLoc,TModelDR,TModel,TRowID,TEquipDR,TUseDate,TOriginalFee,TNetRemainFee,TLimitYearsNum,TUseLocDR,TStatus,TRemark,TDepreMethodDR,TTransAssetDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TEquip,TUseLoc,TDepreMethod,TAddUser,TUpdateUser,TAuditUser)=""
	quit
}

ClassMethod GetCheckUseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckUseExecute ]
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

ClassMethod GetCheckUseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckUseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetOneCheckUse(itms As %Library.String = "", itmsex As %Library.String = "", rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCheckUse(rowid)
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s $p(result,"^",2)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",2),"date")	;UseDate
	s resultex=resultex_"^"	;UseLocDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",6))
	s resultex=resultex_"^"	;DepreMethodDR
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDepreMethod",$p(result,"^",9))),"^",2)
	s $p(result,"^",10)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date")	;TransAssetDate
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
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

}
