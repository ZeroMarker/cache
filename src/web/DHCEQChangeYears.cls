/// 该类已作废  JDL 20150828 V4.0
Class web.DHCEQChangeYears Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 36;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CY_RowID";

Parameter SQLDESCRIPTION = "CY_RowID";

Parameter SQLROWID = "CY_RowID";

ClassMethod UpdateChangeYears(itms As %Library.String = "", itmsex As %Library.String = "", val, AppType, RowID, EquipDR, User)
{
	//+AppType=0 插入
	//+AppType=4 更新
	//+AppType=1 提交
	//+AppType=2 审核
	//+AppType=3 删除
	//RowID 为ChangeYears的ID
	//EquipDR 为Equip的ID
	//User 为操作员ID
 	if +AppType=0 
 	{
	 	s PLIST(1) = $p(val,"^",1)	;RowID
 		s PLIST(2) = $p(val,"^",2)	;EquipDR
 		s PLIST(3) = $p(val,"^",3)	;FromYearsNum
 		s PLIST(4) = $p(val,"^",4)	;ToYearsNum
 		s PLIST(5) = $p(val,"^",5)	;ChangeReason
 		s PLIST(6) = $p(val,"^",6)	;ChangeDate
 		i $p(val,"^",6)'=""  s PLIST(6) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"date")	;ChangeDate
 		s PLIST(7) = $p(val,"^",7)	;Remark
 		s PLIST(8) = "0" //$p(val,"^",8)	;Status
 		/*s PLIST(9) = $p(val,"^",9)	;AddUserDR
 		s PLIST(10) = $p(val,"^",10)	;AddDate
 		i $p(val,"^",10)'=""  s PLIST(10) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"date")	;AddDate
 		s PLIST(11) = $p(val,"^",11)	;AddTime
 		s PLIST(12) = $p(val,"^",12)	;UpdateUserDR
 		s PLIST(13) = $p(val,"^",13)	;UpdateDate
 		i $p(val,"^",13)'=""  s PLIST(13) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",13),"date")	;UpdateDate
 		s PLIST(14) = $p(val,"^",14)	;UpdateTime
 		s PLIST(15) = $p(val,"^",15)	;AuditUserDR
 		s PLIST(16) = $p(val,"^",16)	;AuditDate
 		i $p(val,"^",16)'=""  s PLIST(16) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",16),"date")	;AuditDate
 		s PLIST(17) = $p(val,"^",17)	;AuditTime*/
 		k PLIST(1)
 		
 		s PLIST(9)=User
	 	s PLIST(10)=+$H
	 	s PLIST(11)=$P($H,",",2)
	 	TSTART
	 	&sql(insert into sqluser.DHC_EQChangeYears values :PLIST())
	 	if SQLCODE
	 	{
			TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
 		TCOMMIT
	 	q ID
 	}
 	if +AppType=1
 	{
	 	s PLIST(8)=AppType
	 	s PLIST(12)=User
	 	s PLIST(13)=+$H
	 	s PLIST(14)=$P($H,",",2)
	 	TSTART
	 	&sql(update sqluser.DHC_EQChangeYears values :PLIST() where CY_RowID=:RowID)
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
 		s PLIST(8)=AppType
	 	s PLIST(15)=User
	 	s PLIST(16)=+$H
	 	s PLIST(17)=$P($H,",",2)
	 	s PI(32)=$p(val,"^",4)
	 	s PI(56)=User
	 	s PI(57)=PLIST(16)
	 	s PI(58)=PLIST(17)
	 	s PIS(2)=$p(val,"^",2)
	 	s PIS(4)=$o(^DHCEQCCode("DHCEQCChangeType",0,"CTType",$p(val,"^",15),0)) //$p(val,"^",15) changetype
	 	s PIS(5)=$p(val,"^",5)
	 	s PIS(6)=$p(val,"^",6)
	 	i $p(val,"^",6)'=""  s PIS(6) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"date")
	 	s PIS(7)=$p(val,"^",1)
	 	s PIS(8)=$p(val,"^",7)
	 	s PIS(9)="Y"
	 	s PIS(11)="N"
	 	s PIS(12)=$p(val,"^",9)
	 	s PIS(13)=$p(val,"^",10)
	 	i $p(val,"^",10)'=""  s PIS(13) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"date")
	 	s PIS(14)=$p(val,"^",11)
	 	s PIS(15)=$p(val,"^",12)
	 	s PIS(16)=$p(val,"^",13)
	 	i $p(val,"^",13)'="" s PIS(16) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",13),"date")	;UpdateDate
	 	s PIS(17)=$p(val,"^",14)
	 	s PIS(18)=User
	 	s PIS(19)=+$H
	 	s PIS(20)=$P($H,",",2)
	 	TSTART
	 	&sql(update sqluser.DHC_EQChangeYears values :PLIST() where CY_ROWID=:RowID)
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
	 	
	 	/*  From V4.0 JDL20150827  DHC_EQChangeInfo 旧表已经无效，变动信息记在LifeInfo里，DHC_EQChangeInfo新表用于设备启用、停用等变动记录。
	 	&sql(insert into sqluser.DHC_EQChangeInfo values :PIS())
 		if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	*/
	 	TCOMMIT
	 	q ID
 	}
 	if +AppType=3
 	{
	 	TSTART
	 	&sql(delete from  sqluser.DHC_EQChangeYears  where CY_ROWID=:RowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
	 	TCOMMIT
	 	q ID
 	}
 	if +AppType=4 
 	{
	 	s PLIST(1) = $p(val,"^",1)	;RowID
 		s PLIST(2) = $p(val,"^",2)	;EquipDR
 		s PLIST(3) = $p(val,"^",3)	;FromYearsNum
 		s PLIST(4) = $p(val,"^",4)	;ToYearsNum
 		s PLIST(5) = $p(val,"^",5)	;ChangeReason
 		s PLIST(6) = $p(val,"^",6)	;ChangeDate
 		i $p(val,"^",6)'=""  s PLIST(6) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",6),"date")	;ChangeDate
 		s PLIST(7) = $p(val,"^",7)	;Remark
 		s PLIST(8) = "0" //$p(val,"^",8)	;Status
 		k PLIST(1)		
 		s PLIST(12)=User
	 	s PLIST(13)=+$H
	 	s PLIST(14)=$P($H,",",2)
	 	TSTART
	 	&sql(update sqluser.DHC_EQChangeYears values :PLIST() where CY_RowID=:RowID)
	 	if SQLCODE
	 	{
			TROLLBACK
			q SQLCODE
	 	}
	 	s ID=$G(%ROWID)
 		TCOMMIT
	 	q ID
 	}
}

ClassMethod GetFromYears(EquipDR)
{
	s FromYears=""
	&sql(select EQ_LimitYearsNum into :FromYears from sqluser.DHC_EQEquip where EQ_RowID=:EquipDR)
	q FromYears
}

Query GetChangeYears(EquipDR) As %Query(ROWSPEC = "TManuFactoryDR:%String,TManuFactory:%String,TModelDR:%String,TModel:%String,TRowID:%String,TEquipDR:%String,TFromYearsNum:%String,TToYearsNum:%String,TChangeReason:%String,TChangeDate:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TEquip:%String,TAddUser:%String,TUpdateUser:%String,TAuditUser:%String")
{
}

ClassMethod GetChangeYearsExecute(ByRef qHandle As %Binary, EquipDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetChangeYears
	Quit $$$OK
BuildDataGetChangeYears
	f  s rowid=$o(^DHCEQChangeYears(rowid))  quit:rowid=""  d
	.d ResetVariablesGetChangeYears
	.s TRowID = rowid
	.s TEquipDR = $p($g(^DHCEQChangeYears(rowid)),"^",1)
	.q:(EquipDR="")||(EquipDR'=TEquipDR)
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TModelDR = $p($g(^DHCEQEquip(TEquipDR)),"^",3)
	..i TModelDR '= "" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..s TManuFactoryDR = $p($g(^DHCEQEquip(TEquipDR)),"^",26)
	..i TManuFactoryDR '= "" s TManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	.s TFromYearsNum = $p($g(^DHCEQChangeYears(rowid)),"^",2)
	.s TToYearsNum = $p($g(^DHCEQChangeYears(rowid)),"^",3)
	.s TChangeReason = $p($g(^DHCEQChangeYears(rowid)),"^",4)
	.s TChangeDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeYears(rowid)),"^",5),"date")
	.s TRemark = $p($g(^DHCEQChangeYears(rowid)),"^",6)
	.s TStatus = $p($g(^DHCEQChangeYears(rowid)),"^",7)
	.s TStatus = ##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.s TAddUserDR = $p($g(^DHCEQChangeYears(rowid)),"^",8)
	.i TAddUserDR '=""  d
	..s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeYears(rowid)),"^",9),"date")
	.s TAddTime = $p($g(^DHCEQChangeYears(rowid)),"^",10)
	.s TUpdateUserDR = $p($g(^DHCEQChangeYears(rowid)),"^",11)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeYears(rowid)),"^",12),"date")
	.s TUpdateTime = $p($g(^DHCEQChangeYears(rowid)),"^",13)
	.s TAuditUserDR = $p($g(^DHCEQChangeYears(rowid)),"^",14)
	.i TAuditUserDR '=""  d
	..s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.s TAuditDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeYears(rowid)),"^",15),"date")
	.s TAuditTime = $p($g(^DHCEQChangeYears(rowid)),"^",16)
	.d OutputRowGetChangeYears
	quit
OutputRowGetChangeYears
	s Data=$lb(TManuFactoryDR,TManuFactory,TModelDR,TModel,TRowID,TEquipDR,TFromYearsNum,TToYearsNum,TChangeReason,TChangeDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TEquip,TAddUser,TUpdateUser,TAuditUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetChangeYears
	s (TManuFactoryDR,TManuFactory,TModelDR,TModel,TRowID,TEquipDR,TFromYearsNum,TToYearsNum,TChangeReason,TChangeDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TEquip,TAddUser,TUpdateUser,TAuditUser)=""
	quit
}

ClassMethod GetChangeYearsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChangeYearsExecute ]
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

ClassMethod GetChangeYearsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChangeYearsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
