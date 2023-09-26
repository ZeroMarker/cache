Import SQLUser

Class web.DHCEQCheckDoc Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 48;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DOC_RowID";

Parameter SQLDESCRIPTION = "DOC_DocName";

Parameter SQLROWID = "DOC_RowID";

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", user As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	&SQL(Delete From SQLUSER.DHC_EQCheckDoc where DOC_RowID = :rowid)
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 i $p(val,"^",1)'=""  s PLIST(1) = $p(val,"^",1)	;RowID
 i $p(val,"^",2)'=""  s PLIST(2) = $p(val,"^",2)	;DocOriginalDR
 i $p(val,"^",3)'=""  s PLIST(3) = $p(val,"^",3)	;DocName
 i $p(val,"^",4)'=""  s PLIST(4) = $p(val,"^",4)	;LocDR
 i $p(val,"^",5)'=""  s PLIST(5) = $p(val,"^",5)	;ManagerDR
 i $p(val,"^",6)'=""  s PLIST(6) = $p(val,"^",6)	;ShareNum
 i $p(val,"^",7)'=""  s PLIST(7) = $p(val,"^",7)	;PagesNum
 i $p(val,"^",8)'=""  s PLIST(8) = $p(val,"^",8)	;Remark
 /*
 i $p(val,"^",9)'=""  s PLIST(9) = $p(val,"^",9)	;AddUserDR
 i $p(val,"^",10)'=""  s PLIST(10) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"date")	;AddDate
 i $p(val,"^",11)'=""  s PLIST(11) = $p(val,"^",11)	;AddTime
 i $p(val,"^",12)'=""  s PLIST(12) = $p(val,"^",12)	;UpdateUserDR
 i $p(val,"^",13)'=""  s PLIST(13) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",13),"date")	;UpdateDate
 i $p(val,"^",14)'=""  s PLIST(14) = $p(val,"^",14)	;UpdateTime
 */
 i $p(val,"^",15)'=""  s PLIST(15) = $p(val,"^",15)	;EquipDR
 s PLIST(16) = $p(val,"^",16)   ;DocTypeDR
 k PLIST(1) 
 if (rowid'="") 
 {
	 s PLIST(12) = user
	 s PLIST(13) = +$H
	 s PLIST(14) = $P($H,",",2)
	 &SQL(Update SQLUSER.DHC_EQCheckDoc Values :PLIST() where DOC_RowID = :rowid) 	 
 }
 else
 {	 
  	 s PLIST(9) = user
	 s PLIST(10) = +$H
	 s PLIST(11) = $P($H,",",2)
	 &SQL(Insert Into SQLUSER.DHC_EQCheckDoc Values :PLIST())
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCheckDoc(rowid)
	s resultex=resultex_"^"	;DocOriginalDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDocOriginal",$p(result,"^",1))),"^",2)
	s resultex=resultex_"^"	;LocDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))
	s resultex=resultex_"^"	;ManagerDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",4))
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",8))
	s $p(result,"^",9)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",11))
	s $p(result,"^",12)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")	;UpdateDate
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",14))),"^",1)
	s resultex=resultex_"^"	;DocTypeDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDocType",$p(result,"^",15))),"^",2)
	s result=result_resultex
	s result=##Class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

Query GetDoc(EquipDR As %String) As %Query(ROWSPEC = "TRowID:%String,TDocOriginalDR:%String,TDocName:%String,TLocDR:%String,TManagerDR:%String,TShareNum:%String,TPagesNum:%String,TRemark:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TEquipDR:%String,TDocOriginal:%String,TLoc:%String,TManager:%String,TAddUser:%String,TUpdateUser:%String,TEquip:%String,TDocTypeDR:%String,TDocType:%String")
{
}

ClassMethod GetDocExecute(ByRef qHandle As %Binary, EquipDR As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetDoc
	Quit $$$OK
BuildDataGetDoc
	f  s rowid=$o(^DHCEQCheckDoc(rowid))  quit:rowid=""  d
	.d ResetVariablesGetDoc
	.s TRowID = rowid
	.s TDocOriginalDR = $p($g(^DHCEQCheckDoc(rowid)),"^",1)
	.i TDocOriginalDR '=""  d
	..s TDocOriginal = $p($g(^DHCEQCCode("DHCEQCDocOriginal",TDocOriginalDR)),"^",2)
	.s TDocName = $p($g(^DHCEQCheckDoc(rowid)),"^",2)
	.s TLocDR = $p($g(^DHCEQCheckDoc(rowid)),"^",3)
	.i TLocDR '=""  d
	..s TLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.s TManagerDR = $p($g(^DHCEQCheckDoc(rowid)),"^",4)
	.i TManagerDR '=""  d
	..s TManager = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TManagerDR)
	.s TShareNum = $p($g(^DHCEQCheckDoc(rowid)),"^",5)
	.s TPagesNum = $p($g(^DHCEQCheckDoc(rowid)),"^",6)
	.s TRemark = $p($g(^DHCEQCheckDoc(rowid)),"^",7)
	.s TAddUserDR = $p($g(^DHCEQCheckDoc(rowid)),"^",8)
	.i TAddUserDR '=""  d
	..s TAddUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	.s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCheckDoc(rowid)),"^",9),"date")
	.s TAddTime = $p($g(^DHCEQCheckDoc(rowid)),"^",10)
	.s TUpdateUserDR = $p($g(^DHCEQCheckDoc(rowid)),"^",11)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCheckDoc(rowid)),"^",12),"date")
	.s TUpdateTime = $p($g(^DHCEQCheckDoc(rowid)),"^",13)
	.s TEquipDR = $p($g(^DHCEQCheckDoc(rowid)),"^",14)
	.q:(TEquipDR'=EquipDR)||(EquipDR="")
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TDocTypeDR = $p($g(^DHCEQCheckDoc(rowid)),"^",15)
	.i TDocTypeDR '=""  d
	..s TDocType = $p($g(^DHCEQCCode("DHCEQCDocType",TDocTypeDR)),"^",2)
	.d OutputRowGetDoc
	quit
OutputRowGetDoc
	s Data=$lb(TRowID,TDocOriginalDR,TDocName,TLocDR,TManagerDR,TShareNum,TPagesNum,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TEquipDR,TDocOriginal,TLoc,TManager,TAddUser,TUpdateUser,TEquip,TDocTypeDR,TDocType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDoc
	s (TRowID,TDocOriginalDR,TDocName,TLocDR,TManagerDR,TShareNum,TPagesNum,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TEquipDR,TDocOriginal,TLoc,TManager,TAddUser,TUpdateUser,TEquip,TDocTypeDR,TDocType)=""
	quit
}

ClassMethod GetDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocExecute ]
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

ClassMethod GetDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
