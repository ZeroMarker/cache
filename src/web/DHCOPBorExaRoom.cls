Include webimport

IncludeGenerator webimport

Class web.DHCOPBorExaRoom Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod DeleteDHCBorExaRoom(itmjs As %Library.String = "", itmjsex As %Library.String = "", ID As %Library.String = "")
{
 set Rtn=100
 if ID'="" {
	 &sql(delete from  SQLUser.DHCBorExaRoom where ID=:ID)
	 set Rtn=SQLCODE
 } 

 q Rtn
}

/// w ##class(web.DHCOPBorExaRoom).UpdateDHCBorExaRoom("","","",1,523,"")
ClassMethod UpdateDHCBorExaRoom(itmjs As %Library.String = "", itmjsex As %Library.String = "", ID As %Library.String = "", BorDr As %Library.String = "", BorExaRoomDr As %Library.String = "", Memo As %Library.String = "", BorExaRoomForOne As %Library.String = "")
{
 set Rtn=100
 &sql(select ID into :FindID from DHCBorExaRoom 
 where BorExaRoomDr=:BorExaRoomDr) 
 if FindID'=ID{
 	set Rtn=1
 }else{
	 if ID'="" {
		 &sql(Update SQLUser.DHCBorExaRoom set BorDr=:BorDr,BorExaRoomDr=:BorExaRoomDr,Memo=:Memo ,BorExaRoomForOne=:BorExaRoomForOne  where ID=:ID)
		 set Rtn=SQLCODE
	 }else{
		 &sql(insert into SQLUser.DHCBorExaRoom set BorDr=:BorDr,BorExaRoomDr=:BorExaRoomDr,Memo=:Memo,BorExaRoomForOne=:BorExaRoomForOne)
		 set Rtn=SQLCODE
	 }
 }
 q Rtn
}

ClassMethod insertDHCBorExaRoom(itmjs As %Library.String = "", itmjsex As %Library.String = "", BorDr As %Library.String = "", ExaRoomDr As %Library.String = "", comm As %Library.String = "", BorExaRoomForOne As %Library.String = "")
{
 s ccode = ""
 &sql(SELECT id into :ccode FROM SQLUser.DHCBorExaRoom where BorExaRoomDr=:ExaRoomDr )
 if ccode="" {
	 &sql(insert into SQLUser.DHCBorExaRoom
     (BorExaRoomDr,BorDr,Memo,BorExaRoomForOne)
     values(:ExaRoomDr,:BorDr,:comm,:BorExaRoomForOne))
 } 
 if (itmjs'=""){
	 ;i SQLCODE  q 0 ;i SQLCODE  q 0
	 s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
	 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q SQLCODE
 }else{
	 q:ccode'="" ccode
	 q SQLCODE
 }
}

Query Find(BordBorDr, ExaRoomDr, HospID, Desc) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,BorDr:%String,BorDesc:%String,BorExaRoomDr:%String,BorExaRoomDesc:%String,Memo:%String,BorExaRoomForOne:%String")
{
 select ID,BorDr,BorDr->exabname BorDesc,BorExaRoomDr,b.ctloc_desc BorExaRoomDesc,Memo,BorExaRoomForOne from DHCBorExaRoom a,ct_loc b
 where a.BorExaRoomDr=b.ctloc_rowid
 and BorDr=:BordBorDr and ((b.ctloc_desc like '%'_:Desc_'%' or :Desc is null) or ((b.CTLOC_ContactName like '%'_:Desc_'%' or :Desc is null)))
 
union
 select ID,BorDr,BorDr->exabname,BorExaRoomDr,b.ctloc_desc,Memo,BorExaRoomForOne from DHCBorExaRoom a,ct_loc b
 where a.BorExaRoomDr=b.ctloc_rowid
 and BorExaRoomDr=:ExaRoomDr
 and b.CTLOC_Hospital_DR=:HospID
 and ((b.ctloc_desc  like '%'_:Desc_'%'  or :Desc is null)or ((b.CTLOC_ContactName like '%'_:Desc_'%' or :Desc is null)))
union
 select ID,BorDr,BorDr->exabname,BorExaRoomDr,b.ctloc_desc,Memo,BorExaRoomForOne from DHCBorExaRoom a,ct_loc b
 where a.BorExaRoomDr=b.ctloc_rowid
 and (:BordBorDr is null and :ExaRoomDr is null)
 and b.CTLOC_Hospital_DR=:HospID
 and ((b.ctloc_desc  like '%'_:Desc_'%'  or :Desc is null) or ((b.CTLOC_ContactName like '%'_:Desc_'%' or :Desc is null)))
}

Query FindDHCExaRoom(room, HospId) As %SQLQuery(CONTAINID = 1, ROWSPEC = "name:%String,rid:%String,code:%String")
{
SELECT ctloc_desc,ctloc_rowid,ctloc_code From SQLUser.CT_LOC where ctloc_type='OR' and ((:room is null) or(ctloc_desc like '%'_:room_'%') or(ctloc_code like '%'_:room_'%'))
and ((CTLOC_DateActiveFrom is null) or((CTLOC_DateActiveFrom is not null) and (CTLOC_DateActiveFrom<=+$h)))
	and ((CTLOC_DateActiveTo is null) or((CTLOC_DateActiveTo is not null) and (CTLOC_DateActiveTo>+$h)))
	and (CTLOC_Hospital_DR=:HospId) and (CTLOC_ActiveFlag='Y')
}

}
