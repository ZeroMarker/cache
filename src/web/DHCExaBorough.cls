Include webimport

IncludeGenerator webimport

Class web.DHCExaBorough Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod UFindDHCMarkDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UFindDHCMarkDocExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod UFindDHCMarkDocExecute(ByRef qHandle As %Binary, depid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
	s (Tdepnam,Tmarkname,Tdocname,Tdepid,Tmarkid,Tlocid,Tid)=""
	&sql(DECLARE PrescCursor CURSOR FOR
	SELECT MarkddepDr,MarkdMarkDr,MarkdDocDr,ID
	  into :Tdepid,:Tmarkid,:Tlocid,:Tid
 From SQLUser.DHCMarkDoc
 where SQLUser.DHCMarkDoc.MarkddepDr=:depid)
	&sql(OPEN PrescCursor)
 for  &SQL(FETCH PrescCursor) QUIT:SQLCODE  do
 . s Tmarkname=$P($g(^CTPCP(Tmarkid,1)),"^",2)
 . s Tdocname=$P($g(^CTPCP(Tlocid,1)),"^",2)
 . s Tdepname=$P($g(^CTLOC(Tdepid)),"^",2)
 . d OutputRow3
	&sql(CLOSE PrescCursor)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow3
	set Data=$lb(Tdepname,Tmarkname,Tdocname,Tdepid,Tmarkid,Tlocid,Tid)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	Quit
}

ClassMethod UFindDHCMarkDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UFindDHCMarkDocExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
 }
 Else  {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod delDepMark(itmjs As %Library.String = "", itmjsex As %Library.String = "", rid As %Library.String = "")
{
 &sql(delete From SQLUser.DHCDepMark where id=:rid)
 if (itmjs'=""){
	s retval=itmjs_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
    &javascript<#(retval)#>
	q SQLCODE
 }else{
	 q SQLCODE
 }
}

ClassMethod delExaB(itmjs As %Library.String = "", itmjsex As %Library.String = "", rid As %Library.String = "")
{
 s DepID=$O(^User.DHCExaBorDepI("BordBorDrIndex",rid,""))
 if (DepID'=""){
	 q "分诊区科室已对照！"
 }

 s MarkID=$O(^User.DHCDepMarkI("DepmBorDrIndex",rid,""))
 if (MarkID'=""){
	 q "分诊区号别已对照！"
 }
 s ExaRoomID=$O(^User.DHCBorExaRoomI("BordBorDrIndex",rid,""))
 if (ExaRoomID'=""){
	 q "分诊区诊室已对照！"
 }
 &sql(delete From SQLUser.DHCExaBorough where id=:rid)
 &sql(delete From SQLUser.DHCExaBoroughFilePath where ExabDr=:rid)
 if (itmjs'=""){
	s retval=itmjs_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
	 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
	 &javascript<#(retval)#>
	q SQLCODE
 }else{
	 q SQLCODE
 }
}

ClassMethod delExaRoom(itmjs As %Library.String = "", itmjsex As %Library.String = "", rid As %Library.String = "")
{
 &sql(delete From SQLUser.DHCExaRoom where id=:rid)
	s retval=itmjs_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
 &javascript<#(retval)#>
	q SQLCODE
}

ClassMethod delRoomComp(itmjs As %Library.String = "", itmjsex As %Library.String = "", rid As %Library.String = "")
{
 &sql(delete From SQLUser.DHCRoomComp where id=:rid)
	s retval=itmjs_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
 &javascript<#(retval)#>
	q SQLCODE
}

ClassMethod deluse(itmjs As %Library.String = "", itmjsex As %Library.String = "", rid As %Library.String = "")
{
 &sql(delete From SQLUser.DHCBorUser where id=:rid)
 if (itmjs'=""){
	 s retval=itmjs_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
	 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
	 &javascript<#(retval)#>
	q SQLCODE
 }else{
	 q SQLCODE
 }
}

/*
ClassMethod fbeforeno(itmjs As %Library.String = "", itmjsex As %Library.String = "", dep As %Library.String = "", doc As %Library.String = "", bno As %Library.String = "")
{
 s ccode=""
 s sno=""
 s da=..%SysDate()
 &sql(select ID into :sno from SQLUser.DHCBeforeReg where
 BefregDep=:dep and  BefregDoc=:doc and BefregDate=:da and BefregNo=:bno and Befregflag='0')
 //if ccode="" d inbor
 i SQLCODE=0 d  s ccode=sno
 s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}   */
ClassMethod insertBorUser(itmjs As %Library.String = "", itmjsex As %Library.String = "", useDr As %Library.String = "", borDr As %Library.String = "", isDefault As %String = "")
{
 s ccode=""
 &sql(SELECT id into :ccode FROM SQLUser.DHCBorUser 
 where BoruUseDr=:useDr and BoruBorDr=:borDr)
 if SQLCODE {
	 if (isDefault="Y"){
		&SQL(UPDATE SQLUser.DHCBorUser set BoruUdefault="N" WHERE BoruUseDr=:useDr)
	 }
	 d inbor
 }else{
	 s ccode="-1"
 }
 if (itmjs'=""){
	 s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
	 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q ccode
 }else{
	 q:ccode'="-1" SQLCODE
	 q ccode
 }
inbor
 &sql(insert into SQLUser.DHCBorUser
 (BoruUseDr,BoruBorDr,BoruUdefault)
 values(:useDr,:borDr,:isDefault))
 q SQLCODE
}

/// 判断分诊区号别对照是否有重复的记录
/// w ##class(web.DHCExaBorough).CheckDepMark(1215,3,4,136,"N")
ClassMethod CheckDepMark(RowId As %String, ExaBorId As %String, DeptRowId As %String, MarkDr As %String, ActiveFlag As %String)
{
	s ValidRepeatFlag="N" //是否存在有效对照记录
	s RepeatFlag="N" //诊区是否存在重复记录(对照无效重复/对照有效重复)
	s RepeatExaBor=""
	s ID=0
	for {
		s ID=$o(^User.DHCDepMarkI("DempDepDrMarkDrIndex"," "_DeptRowId,MarkDr,ID)) Q:(ID="")||((ValidRepeatFlag="Y")&&(RepeatFlag="Y"))
		s DepmBorDr=$lg(^User.DHCDepMarkD(ID),7)
		//^User.DHCDepMarkD(1215)=$lb("","","136","","N","1",3,"4",,"N")
		//"","",DepmMarkDr,DepmRoomDr,DepmSign,DepmState,DepmBorDr,DepmDepDr,Checkin,DepmCheckin
		s DepmMarkDr=$lg(^User.DHCDepMarkD(ID),3)
		s DepmSign=$lg(^User.DHCDepMarkD(ID),5)
		if (RowId="")||((RowId'="")&&(RowId'=ID)) {
			s RepeatExaBor=$lg(^User.DHCExaBoroughD(DepmBorDr),5)
			if (DepmMarkDr=MarkDr){
				if (DepmSign="Y") {
					s ValidRepeatFlag="Y"
				}else{
					if (DepmBorDr=ExaBorId) s RepeatFlag="Y"
				}
			}
		}
	}
	if (ValidRepeatFlag="Y") {
		Q RepeatExaBor_" 已存在有效的号别对照记录!"
	}
	if (RepeatFlag="Y") {
		Q RepeatExaBor_" 已存在重复记录!"
	}
	
	s RESRowId=$o(^RB("RES",0,"CTPCP",MarkDr,DeptRowId,""))
	if (RESRowId=""){
		s DeptDesc=$P(^CTLOC(DeptRowId),"^",2)
		s MarkDesc=$P(^CTPCP(MarkDr,1),"^",2)
		Q DeptDesc_" 该科室未关联医护人员"_" "_MarkDesc
	}
	Q ""
}

// w ##class(web.DHCExaBorough).insertDepMark("","",2,4,136,1,"Y","N")

ClassMethod insertDepMark(itmjs As %Library.String = "", itmjsex As %Library.String = "", RoomDr As %Library.String = "", CompDr As %Library.String = "", MarkDr As %Library.String = "", st As %Library.String = "", si As %Library.String = "", Checkin As %Library.String = "")
{
	 s RepeatInfo=..CheckDepMark("",RoomDr,CompDr,MarkDr,si)
	 Q:RepeatInfo'="" RepeatInfo
	 d inbor
	 if (itmjs'=""){
		 s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
		 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
		 &javascript<#(retval)#>
		 q 1
	 }else{
		 //q:ccode'="" ccode
		 q SQLCODE
	 }
	 
inbor
 &sql(insert into SQLUser.DHCDepMark
 (DepmborDr,DepmdepDr,DepmMarkDr,DepmState,DepmSign,DepmCheckin)
 values(:RoomDr,:CompDr,:MarkDr,:st,:si,:Checkin))
}

ClassMethod insertExaB(itmjs As %Library.String = "", itmjsex As %Library.String = "", code As %Library.String = "", name As %Library.String = "", memo As %Library.String = "", Checkin As %Library.String = "", ExabSubCallFilePath As %Library.String = "", ExabSubWaitFilePath As %Library.String = "", ExabAutoReport As %Library.String = "", FristReson As %Library.String = "", NoCheckinDocCanRecAdm As %Library.String = "", OtherStr As %String)
{
 s ccode = ""
 s CreatQueueNo=$P(OtherStr,"^",1)
 s DelayQueueNo=$P(OtherStr,"^",2)
 s CallDelayQueueNo=$P(OtherStr,"^",3)
 s HospID=$P(OtherStr,"^",4)
 &sql(SELECT id into :ccode FROM SQLUser.DHCExaBorough where ExabCode=:code and ExabHospitalDr=:HospID)
 if ccode="" d inbor
 if (itmjs'=""){
	 s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
	 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q 1
 }else{
	 Q:ccode'="" ccode
	 Q SQLCODE
 }
 
inbor
 &sql(insert into SQLUser.DHCExaBorough
 (ExabCode,ExabName,ExabMemo,ExabTem,ExabAutoReport,ExabFristReson,ExabNoCheckinDocCanRecAdm,ExabCreatQueueNo,ExabDelayQueueNo,ExabCallDelayQueueNo,ExabHospitalDr)
 values(:code,:name,:memo,:Checkin,:ExabAutoReport,:FristReson,:NoCheckinDocCanRecAdm,:CreatQueueNo,:DelayQueueNo,:CallDelayQueueNo,:HospID))
 set ExabDr=$g(%ROWID)

 &sql(insert into DHCExaBoroughFilePath(ExabDr,ExabSubCallFilePath,ExabSubWaitFilePath)
 values(:ExabDr,:ExabSubCallFilePath,:ExabSubWaitFilePath))
}

ClassMethod insertExaRoom(itmjs As %Library.String = "", itmjsex As %Library.String = "", code As %Library.String = "", name As %Library.String = "", bor As %Library.String = "", memo As %Library.String = "")
{
 s ccode = ""
 ///ct_loc
 &sql(SELECT id into :ccode FROM SQLUser.DHCExaRoom where ExarCode=:code)
 if ccode="" d inbor
 ;i SQLCODE  q 0 ;i SQLCODE  q 0
 s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
inbor
 &sql(insert into SQLUser.DHCExaRoom
 (ExarCode,ExarName,ExarBorDr,ExarMemo)
 values(:code,:name,:bor,:memo))
}

ClassMethod insertFirstCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", code As %Library.String = "", name As %Library.String = "", memo As %Library.String = "")
{
 s ccode = ""
 &sql(SELECT id into :ccode FROM SQLUser.DHCFirstCode where FirstcCode=:code)
 if ccode="" d inbor
 if (itmjs'=""){
	 ;i SQLCODE  q 0 ;i SQLCODE  q 0
	 s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
	 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q 1
 }else{
	 q:ccode'="" ccode
	 q SQLCODE
 }
inbor
 &sql(insert into SQLUser.DHCFirstCode
 (FirstcCode,FirstcName,FirstcMemo)
 values(:code,:name,:memo))
}

ClassMethod insertMarkDoc(itmjs As %Library.String = "", itmjsex As %Library.String = "", depDr As %Library.String = "", markDr As %Library.String = "", docDr As %Library.String = "")
{
 s ccode = ""
 &sql(SELECT id into :ccode FROM SQLUser.DHCMarkDoc 
 where MarkdMarkDr=:markDr and MarkdDocDr=:docDr and MarkddepDr=:depDr)

 if SQLCODE=0 d  s ccode="1"
 if SQLCODE=100 d inbor

 s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
inbor
 &sql(insert into SQLUser.DHCMarkDoc
 (Markddepdr,MarkdMarkDr,MarkdDocDr)
 values(:depDr,:markDr,:docDr))
}

ClassMethod insertPerState(itmjs As %Library.String = "", itmjsex As %Library.String = "", code As %Library.String = "", name As %Library.String = "", memo As %Library.String = "", showname As %Library.String = "")
{
 s ccode = ""
 &sql(SELECT id into :ccode FROM SQLUser.DHCPerState where PersCode=:code)
 if ccode="" d inbor
 if (itmjs'=""){
	 ;i SQLCODE  q 0 ;i SQLCODE  q 0
	 s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
	 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q 1
 }else{
	 q:ccode'="" ccode
	 q SQLCODE
 }
inbor
 &sql(insert into SQLUser.DHCPerState
 (PersCode,PersName,PersMemo,PersShowName)
 values(:code,:name,:memo,:showname))
}

/// w ##class(web.DHCExaBorough).insertRoomComp("","","10.10.141.10","ee","10.10.141.10",434)
ClassMethod insertRoomComp(itmjs As %Library.String = "", itmjsex As %Library.String = "", code As %Library.String = "", name As %Library.String = "", ip As %Library.String = "", roomdr As %Library.String = "")
{
 s RoomHospDr=$p(^CTLOC(roomdr),"^",22)
 s count = 0
 &sql(SELECT count(id) into :count FROM SQLUser.DHCRoomComp where (RoomcRoomDr->CTLOC_Hospital_DR=:RoomHospDr) and (RoomcCode=:code or RoomcName=:name or RoomcIp=:ip))
 if count=0 d inbor
 b //12
 ;i SQLCODE  q 0 ;i SQLCODE  q 0
 s retval=itmjs_"('"_$ZCVT(count,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(count,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
inbor
 &sql(insert into SQLUser.DHCRoomComp
 (RoomcCode,RoomcName,RoomcIp,RoomcRoomDr)
 values(:code,:name,:ip,:roomdr))
}

ClassMethod updateBorUser(itmjs As %Library.String = "", itmjsex As %Library.String = "", useDr As %Library.String = "", borDr As %Library.String = "", rowid As %Library.String = "", isDefault As %String)
{
 s ccode = ""
 &sql(SELECT id into :ccode FROM SQLUser.DHCBorUser where BoruUseDr=:useDr and BoruBorDr=:borDr and id <>:rowid)
  if (ccode=""){
	   if (isDefault="Y"){
		 &SQL(UPDATE SQLUser.DHCBorUser set BoruUdefault="N" WHERE BoruUseDr=:useDr)
	   }
	   &sql(update SQLUser.DHCBorUser
		 set BoruUseDr=:useDr,BoruBorDr=:borDr,BoruUdefault=:isDefault
		 where id=:rowid)
  }
 if (itmjs'=""){
	 i SQLCODE=0 d
	 .s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
	 .i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
	 .&javascript<#(retval)#>
	 q 1
 }else{
	 q:ccode'="" ccode
	 Q SQLCODE
 }
}

ClassMethod updateDepMark(itmjs As %Library.String = "", itmjsex As %Library.String = "", RoomDr As %Library.String = "", CompDr As %Library.String = "", MarkDr As %Library.String = "", st As %Library.String = "", si As %Library.String = "", rowid As %Library.String = "", Checkin As %Library.String = "")
{
 /*s ccode = ""
 &sql(SELECT id into :ccode FROM SQLUser.DHCDepMark where DepmDepDr=:CompDr and DepmMarkDr=:MarkDr and id <> :rowid)
 if (ccode="") d inbor*/
 s RepeatInfo=..CheckDepMark(rowid,RoomDr,CompDr,MarkDr,si)
 Q:RepeatInfo'="" RepeatInfo
 d inbor
 if (itmjs'=""){
	 s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
	 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q 1
 }else{
	 //q:ccode'="" ccode
	 q SQLCODE
 }
inbor
 &sql(update SQLUser.DHCDepMark
 set DepmborDr=:RoomDr,DepmdepDr=:CompDr,DepmMarkDr=:MarkDr,DepmState=:st,DepmSign=:si,DepmCheckin=:Checkin
 where id=:rowid)
}

ClassMethod updateExaB(itmjs As %Library.String = "", itmjsex As %Library.String = "", code As %Library.String = "", name As %Library.String = "", memo As %Library.String = "", rowid As %Library.String = "", Checkin As %Library.String = "", ExabSubCallFilePath As %Library.String = "", ExabSubWaitFilePath As %Library.String = "", ExabAutoReport As %Library.String = "", ExabFristReson As %Library.String = "", NoCheckinDocCanRecAdm As %Library.String = "", OtherStr As %Library.String = "")
{
 /*s ccode = ""
 &sql(update SQLUser.DHCExaBorough
 set ExabCode=:code,ExabName=:name,ExabMemo=:memo,ExabTem=:Checkin
 where id=:rowid)
 &sql(update SQLUser.DHCExaBoroughFilePath 
 	set ExabSubCallFilePath=:ExabSubCallFilePath,ExabSubWaitFilePath=:ExabSubWaitFilePath
 	where ExabDr=:rowid)
 i SQLCODE=0 d
 .s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
 .i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
 .&javascript<#(retval)#>
 q 1*/
 
  s ccode = ""
  s CreatQueueNo=$P(OtherStr,"^",1)
 s DelayQueueNo=$P(OtherStr,"^",2)
 s CallDelayQueueNo=$P(OtherStr,"^",3)
 s HospID=$P(OtherStr,"^",4)
 &sql(SELECT ID into :ccode FROM SQLUser.DHCExaBorough where ExabCode=:code and  ExabHospitalDr=:HospID and ID <>:rowid)
 if ccode="" d inbor
 if (itmjs'=""){
	 s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
	 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q 1
 }else{
	 Q:ccode'="" ccode
	 Q SQLCODE
 }
inbor
 &sql(update SQLUser.DHCExaBorough
 set ExabCode=:code,ExabName=:name,ExabMemo=:memo,ExabTem=:Checkin,ExabAutoReport=:ExabAutoReport,ExabFristReson=:ExabFristReson,ExabNoCheckinDocCanRecAdm=:NoCheckinDocCanRecAdm,
 ExabCreatQueueNo=:CreatQueueNo,ExabDelayQueueNo=:DelayQueueNo,ExabCallDelayQueueNo=:CallDelayQueueNo,ExabHospitalDr=:HospID
 where id=:rowid)
 &sql(update SQLUser.DHCExaBoroughFilePath 
 	set ExabSubCallFilePath=:ExabSubCallFilePath,ExabSubWaitFilePath=:ExabSubWaitFilePath
 	where ExabDr=:rowid)
}

ClassMethod updateExaRoom(itmjs As %Library.String = "", itmjsex As %Library.String = "", code As %Library.String = "", name As %Library.String = "", bor As %Library.String = "", memo As %Library.String = "", rowid As %Library.String = "")
{
 s ccode = ""
 &sql(update SQLUser.DHCExaRoom
 set ExarCode=:code,ExarName=:name, ExarBorDr=:bor,ExarMemo=:memo
 where id=:rowid)
 i SQLCODE=0 d
 .s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
 .i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
 .&javascript<#(retval)#>
 q 1
}

ClassMethod updateFirstCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", code As %Library.String = "", name As %Library.String = "", memo As %Library.String = "", rowid As %Library.String = "")
{
	  s ccode = ""
	  &sql(SELECT id into :ccode FROM SQLUser.DHCFirstCode where FirstcCode=:code and id <>:rowid)
	  
	 i ccode'="",itmjs'="" d
	 .s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
	 .i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT("代码重复!","O","JS")_"');"
	 .&javascript<#(retval)#>
	 i ccode'="" q 1

	 &sql(update SQLUser.DHCFirstCode
	 set FirstcCode=:code,FirstcName=:name,FirstcMemo=:memo
	 where id=:rowid)
	 if (itmjs'=""){
	 i SQLCODE=0 d
		 .s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
		 .i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
		 .&javascript<#(retval)#>
		 q 1
	 }else{
		 q SQLCODE
	 }
}

ClassMethod updateMarkDoc(itmjs As %Library.String = "", itmjsex As %Library.String = "", deoDr As %Library.String = "", markDr As %Library.String = "", docDr As %Library.String = "", rowid As %Library.String = "")
{
 s ccode = ""
 &sql(update SQLUser.DHCMarkDoc
 set MarkdMarkDr=:markDr,MarkdDocDr=:docDr,Markddepdr=:deoDr
 where id=:rowid)
 i SQLCODE=0 d
 .s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
 .i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
 .&javascript<#(retval)#>
 q 1
}

ClassMethod deleteMarkDoc(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	s ccode=""
	&sql(delete from SQLUser.DHCMarkDoc where id=:rowid)
	i SQLCODE=0 D
	.Set ccode="delete"
	.s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
	.i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
	.&javascript<#(retval)#>
	q 1
}

ClassMethod updatePerState(itmjs As %Library.String = "", itmjsex As %Library.String = "", code As %Library.String = "", name As %Library.String = "", memo As %Library.String = "", rowid As %Library.String = "", showname As %Library.String = "")
{
 s ccode = ""
 &sql(SELECT id into :ccode FROM SQLUser.DHCPerState where PersCode=:code and id<>:rowid)
 if ccode="" d inbor
  if (itmjs'=""){
	 s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
	 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q 1
 }else{
	 q:ccode'="" ccode
	 q SQLCODE
 }
 
inbor
 &sql(update SQLUser.DHCPerState
 set PersCode=:code,PersName=:name,PersMemo=:memo,PersShowName=:showname
 where id=:rowid)
 /*i SQLCODE=0 d
 .s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
 .i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
 .&javascript<#(retval)#>
 q 1*/
}

ClassMethod updateRoomComp(itmjs As %Library.String = "", itmjsex As %Library.String = "", code As %Library.String = "", name As %Library.String = "", ip As %Library.String = "", roomdr As %Library.String = "", rowid As %Library.String = "")
{
	s RoomHospDr=$p(^CTLOC(roomdr),"^",22)
	
	s count = 0
	 &sql(SELECT count(id) into :count FROM SQLUser.DHCRoomComp where  id<>:rowid and (RoomcCode=:code or RoomcName=:name or RoomcIp=:ip) and RoomcRoomDr->CTLOC_Hospital_DR=:RoomHospDr)
	 if count=0 d inbor

	 s retval=itmjs_"('"_$ZCVT(count,"O","JS")_"');"
	 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(count,"O","JS")_"');"
	 &javascript<#(retval)#>
	 q 1
inbor
	&sql(update SQLUser.DHCRoomComp
	 set RoomcCode=:code,RoomcName=:name,RoomcIp=:ip,RoomcRoomDr=:roomdr
	 where id=:rowid)
 /*s ccode = ""
 s SQLCODE="更新失败"
 
 &sql(update SQLUser.DHCRoomComp
 set RoomcCode=:code,RoomcName=:name,RoomcIp=:ip,RoomcRoomDr=:roomdr
 where id=:rowid)
 i SQLCODE=0 d
 .s retval=itmjs_"('"_$ZCVT(ccode,"O","JS")_"');"
 .i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(ccode,"O","JS")_"');"
 .&javascript<#(retval)#>
 q SQLCODE*/
}

Query FindARC() As %SQLQuery(CONTAINID = 1, ROWSPEC = "name:%String,id:%String")
{
select ARCIM_Desc,ARCIM_RowId from SQLUser.ARC_ItmMast where 
ARCIM_ItemCat_DR->ARCIC_Desc='挂号费'
}

Query FindDHCExaRoom(HospId) As %SQLQuery(CONTAINID = 1, ROWSPEC = "name:%String,rid:%String")
{
SELECT ctloc_desc,ctloc_rowid From SQLUser.CT_LOC where ctloc_type='OR' And CTLOC_Hospital_DR=:HospId And CTLOC_ActiveFlag='Y'
}

Query FindExaBorough(borname As %String = "", HospId) As %SQLQuery(CONTAINID = 1, ROWSPEC = "name:%String,rid:%String")
{
SELECT ExabName,id From SQLUser.DHCExaBorough where ((:borname is null)  or (ExabName like '%'_:borname_'%')) And ExabHospitalDr=:HospId
}

Query FindExaRoom() As %SQLQuery(CONTAINID = 1, ROWSPEC = "name:%String,rid:%String,depid:%String")
{
SELECT ExarName,id,ExarBorDr->ExabDepDr FROM SQLUser.DHCExaRoom
}

Query FindRoomComp() As %SQLQuery(CONTAINID = 1, ROWSPEC = "name:%String,rid:%String")
{
SELECT RoomcName,id FROM SQLUser.DHCRoomComp
}

Query Findcare(depid) As %SQLQuery(CONTAINID = 1, ROWSPEC = "name:%String,rid:%String")
{
SELECT RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR 
FROM SQLUser.RB_RESOURCE
WHERE (RES_CTLOC_DR = :depid 
and (res_schedulerequired='No' or res_schedulerequired='N'))
}

Query Finddep() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Desc:%Integer,RowID:%String")
{
SELECT CTLOC_Desc,CTLOC_RowID  FROM SQLUser.CT_LOC
}

/*

SELECT RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR,RES_CTPCP_DR->CTPCP_OtherName
FROM SQLUser.RB_RESOURCE
WHERE (RES_CTLOC_DR = :depid) 
and (res_schedulerequired='Yes' or res_schedulerequired='Y')
and (:markname is null or %ALPHAUP RES_CTPCP_DR->CTPCP_Desc [ %ALPHAUP :markname)
and (RES_CTPCP_DR->CTPCP_ActiveFlag='Y')
*/
/// d ##class(%ResultSet).RunQuery("web.DHCExaBorough","Findloc","30","j")
Query Findloc(depid, markname As %String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "Desc:%String,RowID:%String,code:%String")
{
}

ClassMethod FindlocExecute(ByRef qHandle As %Binary, depid, markname As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (depid=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s RESRowId=""
	for {
		s RESRowId=$O(^RB("RES",0,"CTLOC",depid,RESRowId))
		q:(RESRowId="")
		s DateActiveFrom=$P(^RB("RES",RESRowId),"^",22)
		continue:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
		s DateActiveTo=$P(^RB("RES",RESRowId),"^",23)
		continue:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
		s ScheduleRequired=$P(^RB("RES",RESRowId),"^",6)
		continue:(ScheduleRequired'="Y")
		s CTPCPDR=$P(^RB("RES",RESRowId),"^",2)
		continue:(CTPCPDR="")
		continue:'$D(^CTPCP(CTPCPDR,1))
		
		s ActiveFlag=$P(^CTPCP(CTPCPDR,1),"^",9)
		continue:(ActiveFlag'="Y")
		s CTPCPDesc=$P(^CTPCP(CTPCPDR,1),"^",2)
		continue:0=##Class(web.DHCExaBorough).CheckDocAlias(CTPCPDR,markname)
		Set OtherName=$p(^CTPCP(CTPCPDR,3),"^",28)
		d OutputRow3
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow3
	Set ^CacheTemp(repid,ind)=$LB(CTPCPDesc,CTPCPDR,OtherName)
	Set ind=ind+1
	quit
}

Query Findloc1() As %SQLQuery(CONTAINID = 1, ROWSPEC = "name:%Integer,id:%String")
{
SELECT CTLOC_Desc,CTLOC_RowID FROM SQLUser.CT_Loc
where CTLOC_Type='OR'
}

/*
OR
  ((%ALPHAUP DataAlias [ %ALPHAUP:depname)and(TableName='CT_Loc') and (DataReference=CTLOC_RowID))
*/

/*Query Findyndep(id, depname As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "name:%String,rid:%String")
{
SELECT ctloc_desc,borddepdr FROM SQLUser.DHCexabordep,SQLUser.ct_loc
 where CTLOC_RowID=borddepdr and bordbordr=:id
 and ((%ALPHAUP ctloc_desc [ %ALPHAUP :depname) OR(:depname IS NULL) OR (%ALPHAUP CTLOC_ContactName [ %ALPHAUP :depname) 
 )
}*/
Query UFindDHCBorUser(borid As %String, userid As %String, HospId As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Tborname:%String,Tusename:%String,Tborid:%String,Tuseid:%String,Tid:%String,isDefault:%String")
{
SELECT BoruBorDr->ExabName,ssusr_name,BoruBorDr,BoruUseDr,ID,BoruUdefault
 From SQLUser.DHCBorUser, SQLUser.SS_USER
 where SQLUser.SS_USER.ssusr_ROWID=SQLUser.DHCBorUser.BoruUseDr 
 and BoruBorDr=:borid and :userid is null and BoruBorDr->ExabHospitalDr=:HospId
 
 union
 SELECT BoruBorDr->ExabName,ssusr_name,BoruBorDr,BoruUseDr,ID,BoruUdefault
 From SQLUser.DHCBorUser, SQLUser.SS_USER
 where SQLUser.SS_USER.ssusr_ROWID=SQLUser.DHCBorUser.BoruUseDr 
 and BoruUseDr=:userid and :borid is null and BoruBorDr->ExabHospitalDr=:HospId
 
 union
 SELECT BoruBorDr->ExabName,ssusr_name,BoruBorDr,BoruUseDr,ID,BoruUdefault
 From SQLUser.DHCBorUser, SQLUser.SS_USER
 where SQLUser.SS_USER.ssusr_ROWID=SQLUser.DHCBorUser.BoruUseDr 
 and (:borid is null and :userid is null and BoruBorDr->ExabHospitalDr=:HospId )
 
 union
 SELECT BoruBorDr->ExabName,ssusr_name,BoruBorDr,BoruUseDr,ID,BoruUdefault
 From SQLUser.DHCBorUser, SQLUser.SS_USER
 where SQLUser.SS_USER.ssusr_ROWID=SQLUser.DHCBorUser.BoruUseDr 
 and (:borid is not null and :userid is not null)
 and (BoruBorDr=:borid  and BoruUseDr=:userid)
  and (BoruBorDr->ExabHospitalDr=:HospId)
}

Query UFindDHCExaRoom(borid) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Tcode:%String,Tname:%String,Tbor:%String,Tmemo:%String,Tbordr:%String,Tid:%String")
{
SELECT ExarCode,ExarName,ExarBorDr->ExabName,ExarMemo,ExarBorDr,ID
 From SQLUser.DHCExaRoom where SQLUser.DHCExaRoom.ExarBorDr %startswith :borid
}

Query UFindDHCFirstCode() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Tcode:%String,Tname:%String,Tmemo:%String,Tid:%String")
{
SELECT FirstcCode,FirstcName,FirstcMemo,ID
 From SQLUser.DHCFirstCode
}

Query UFindDHCMarkDoc(depid) As %Query(CONTAINID = 1, ROWSPEC = "Tdepname:%String,Tmarkname:%String,Tdocname:%String,Tdepid:%String,Tmarkid:%String,Tlocid:%String,Tid:%String")
{
}

Query UFindDHCMarkDoc1(depid) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Tdepname:%String,Tmarkname:%String,Tdocname:%String,Tdepid:%String,Tmarkid:%String,Tlocid:%String,Tid:%String")
{
SELECT CTLOC_DESC,RES_Desc,CTPCP_DESC,MarkddepDr,MarkdMarkDr,MarkdDocDr,ID
 From SQLUser.DHCMarkDoc, SQLUser.CT_LOC, SQLUser.CT_CareProv, SQLUser.rb_resource
 where SQLUser.rb_resource.RES_CTPCP_DR=SQLUser.DHCMarkDoc.MarkdMarkDr and
 SQLUser.CT_CareProv.CTPCP_ROWID = SQLUser.DHCMarkDoc.MarkdDocDr and 
 SQLUser.DHCMarkDoc.MarkddepDr=SQLUser.CT_loc.CTLOC_rowid
 and SQLUser.DHCMarkDoc.MarkddepDr %startswith :depid
}

Query UFindDHCPerState() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Tcode:%String,Tname:%String,Tmemo:%String,Tid:%String,Tshowname:%String")
{
SELECT PersCode,PersName,PersMemo,ID,PersShowName
 From SQLUser.DHCPerState
 order by PersCode
}

Query UFindDHCRoomComp(roomid, HospId) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Tcode:%String,Tname:%String,Tip:%String,Troom:%String,Troomid:%String,Tid:%String")
{
SELECT RoomcCode,RoomcName,RoomcIp,RoomcRoomDr->CTLOC_Desc,RoomcRoomDr,ID
 From SQLUser.DHCRoomComp where RoomcRoomDr %startswith :roomid and RoomcRoomDr->CTLOC_Hospital_DR=:HospId
}

Query UFindDepMark() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Troomname:%String,Tcomname:%String,Tmarkname:%String,Tst:%String,Tsi:%String,Troomid:%String,Tcomid:%String,Tmarkid:%String,Tid:%String")
{
SELECT DepmRoomDr->ExarName,DepmCompDr->RoomcName,CTLOC_DESC,DepmState,DepmSign,DepmRoomDr,DepmCompDr,DepmMarkDr,ID
 From SQLUser.DHCDepMark, SQLUser.CT_LOC
 Where SQLUser.CT_LOC.CTLOC_ROWID = SQLUser.DHCDepMark.DepmMarkDr
}

/*and (:docname is null or RES_CTPCP_DR->CTPCP_Desc like '%'_:docname_'%')  BordBordesc and b.exabname %startswith :BordBordesc*/
Query UFindExaBorDep(BordBorDr, BordDepDr As %String = "", HospId, Desc) As %SQLQuery(CONTAINID = 1, ROWSPEC = "TBordBordesc:%String,TBordDepdesc:%String,TBordMemo:%String,TID:%String,TBordDepDr:%String,TBordBorDr:%String")
{
 SELECT b.exabname ,ctloc_desc,a.BordMemo,a.ID ,a.BordDepDr,a.BordBorDr
 From SQLUser.DHCExaBorDep a,SQLUser.ct_loc,SQLUser.DHCExaBorough b
 where a.BordDepDr=ctloc_rowid and a.BordBorDr=b.id and (b.id = :BordBorDr or :BordBorDr is null) and ( ctloc_rowid=:BordDepDr or :BordDepDr is null) 
 and b.ExabHospitalDr=:HospId and ((ctloc_desc like '%'_:Desc_'%' or :Desc is null)or (CTLOC_ContactName like '%'_:Desc_'%' or :Desc is null))
}

Query UFindExaBorough(depid, HospId) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Tcode:%String,Tname:%String,Tmemo:%String,Tid:%String,TCheckin:%String,TCallFilePath:%String,TWaitFilePath:%String,TAutoCheckin:%String,TFristReson:%String,TNoCheckinDocCanRecAdm:%String,TCreatQueueNo,TDelayQueueNo,TCallDelayQueueNo,THospital:%String")
{
SELECT a.ExabCode,a.ExabName,a.ExabMemo,a.ID,a.ExabTem,b.ExabSubCallFilePath,b.ExabSubWaitFilePath,a.ExabAutoReport,a.ExabFristReson,a.ExabNoCheckinDocCanRecAdm,a.ExabCreatQueueNo,a.ExabDelayQueueNo,a.ExabCallDelayQueueNo,a.ExabHospitalDr->HOSP_Desc
 From SQLUser.DHCExaBorough a,DHCExaBoroughFilePath b
where a.ID=b.ExabDr and a.ExabHospitalDr=:HospId
}

Query UFindState() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Tname:%String,Tid:%String")
{
SELECT PersName,ID
 From SQLUser.DHCPerState
}

Query UFindUser(username) As %SQLQuery(CONTAINID = 1, ROWSPEC = "name:%String,id:%String")
{
 SELECT ssusr_name,ssusr_rowid
 From SQLUser.SS_USER
 where SQLUser.SS_USER.ssusr_group->ssgrp_desc like '%Triage%' or SQLUser.SS_USER.ssusr_group->ssgrp_desc like '%分诊%' and (:username is null or ssusr_name like '%'_:username_'%')
 
 union
 select othll_parref->ssusr_name ssusr_name,othll_parref->ssusr_rowid ssusr_rowid
 from SS_UserOtherLogonLoc
 where othll_usergroup_dr->ssgrp_desc like '%分诊%' or othll_usergroup_dr->ssgrp_desc like '%Triage%' and (:username is null or othll_parref->ssusr_name like '%'_:username_'%')
}

/// d ##class(%ResultSet).RunQuery("web.DHCExaBorough","FindDoc","30","")
Query FindDoc(depid, docname As %String = "", HospID = "", Type = "") As websys.Query(CONTAINID = 0, ROWSPEC = "Desc:%String,RowID:%String,code:%String")
{
}

ClassMethod FindDocExecute(ByRef qHandle As %Binary, depid, docname As %String = "", HospID = "", Type = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (depid=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s RESRowId=""
	for {
		s RESRowId=$O(^RB("RES",0,"CTLOC",depid,RESRowId))
		q:(RESRowId="")
		s ScheduleRequired=$P(^RB("RES",RESRowId),"^",6)
		continue:(ScheduleRequired'="Y")&&(Type="MarkToDoc")
		s DateActiveFrom=$P(^RB("RES",RESRowId),"^",22)
		continue:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
		s DateActiveTo=$P(^RB("RES",RESRowId),"^",23)
		continue:(DateActiveTo'="")&&(DateActiveTo<+$h)
		s CTPCPDR=$P(^RB("RES",RESRowId),"^",2)
		continue:(CTPCPDR="")
		continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_CareProv",CTPCPDR,HospID)
		continue:'$D(^CTPCP(CTPCPDR,1))
		s ActiveFlag=$P(^CTPCP(CTPCPDR,1),"^",9)
		continue:(ActiveFlag'="Y")
		s CTPCPDesc=$P(^CTPCP(CTPCPDR,1),"^",2)
		continue:0=##Class(web.DHCExaBorough).CheckDocAlias(CTPCPDR,docname)
		Set OtherName=$p(^CTPCP(CTPCPDR,3),"^",28)
		d OutputRow2
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow2
	Set ^CacheTemp(repid,ind)=$LB(CTPCPDesc,CTPCPDR,OtherName)
	Set ind=ind+1
	quit
}

ClassMethod FindDocBroker(depid, HospID = "")
{
	s ^tempqujian("FindDocBroker")=depid
	Set rset = ##class(%ResultSet).%New("web.DHCExaBorough:FindDoc")
	Set columns = rset.GetColumnCount()
	// Execute the query
	Set rs = rset.Execute(depid,"",HospID)
	s str=""
	While (rset.Next()) {
		s Desc=$g(rset.Data("Desc"))
		s RowID=$g(rset.Data("RowID"))
		if str="" s str=RowID_$c(2)_Desc
		else  s str=str_$C(1)_RowID_$c(2)_Desc
		}
	d rset.Close()
	q str
}

/// Findloc
ClassMethod FindlocBroker(depid)
{
	s ^tempqujian("FindDocBroker")=depid
	Set rset = ##class(%ResultSet).%New("web.DHCExaBorough:Findloc")
	Set columns = rset.GetColumnCount()
	// Execute the query
	Set rs = rset.Execute(depid)
	s str=""
	While (rset.Next()) {
		s Desc=$g(rset.Data("Desc"))
		s RowID=$g(rset.Data("RowID"))
		if str="" s str=RowID_$c(2)_Desc
		else  s str=str_$C(1)_RowID_$c(2)_Desc
		}
	d rset.Close()
	q str
}

Query Findyndep(id, depname As %String = "", HospID As %String = "") As %Query(ROWSPEC = "name:%String,rid:%String,code:%String")
{
}

ClassMethod FindyndepExecute(ByRef qHandle As %Binary, id, depname As %String = "", HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	/*if (id="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}*/
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	if (id="") {
		s AdmType="O^E"
		for loop=1:1:$l(AdmType,"^"){
			s aAdmType=$p(AdmType,"^",loop)
			set myrowid=0
			for  {
				s myrowid=$o(^PAC("ADMLOC",0,"AdmType",aAdmType,myrowid)) q:myrowid=""  
				s BordDepDr=myrowid
				s LocHospDr=$P(^CTLOC(myrowid),"^",22)
				;continue:LocHospDr'=HospID
				continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",myrowid,HospID)
				s code=$P(^CTLOC(myrowid),"^",43) 
				s CTLocDesc=$p($g(^CTLOC(myrowid)),"^",2)
				s StartDate=$P(^CTLOC(myrowid),"^",24)
				s EndDate=$P(^CTLOC(myrowid),"^",25)
				continue:(StartDate'="")&&(StartDate>+$h)
				continue:(EndDate'="")&&(EndDate<+$h)
				continue:##class(web.DHCOPAdmReg).CheckLocDesc(myrowid,depname)'=1 
				continue:($P(^CTLOC(myrowid),"^",14)'="Y")
				d OutputRow1
			}
		}
	}else{
		s exabordepid=0
		for {
			s exabordepid=$o(^User.DHCExaBorDepI("BordBorDrIndex",id,exabordepid)) q:exabordepid=""  
			s BordDepDr=$list(^User.DHCExaBorDepD(exabordepid),7)
			continue:BordDepDr=""
			continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",BordDepDr,HospID)
			s CTLocDesc=$P(^CTLOC(BordDepDr),"^",2)
			s code=$P(^CTLOC(BordDepDr),"^",43)
			s StartDate=$P(^CTLOC(BordDepDr),"^",24)
			s EndDate=$P(^CTLOC(BordDepDr),"^",25)
			continue:(StartDate'="")&&(StartDate>+$h)
			continue:(EndDate'="")&&(EndDate<+$h)
			continue:##class(web.DHCOPAdmReg).CheckLocDesc(BordDepDr,depname)'=1 
			continue:($P(^CTLOC(BordDepDr),"^",14)'="Y")
			d OutputRow1
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow1
	set Data=$lb(CTLocDesc,BordDepDr,code)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	quit
}

ClassMethod FindyndepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindyndepExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	 }
	 Else      {				// fetch row
		 Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod FindyndepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindyndepExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCExaBorough).FindGroupListBroker()
ClassMethod FindGroupListBroker(HospID)
{
	s qstr=""
	s AudiNotLimitedGroupStr=..%GetConfig("ExaBoroughGroupUser",HospID)
	Set rset=##Class(%ResultSet).%New("web.DHCOPRegConfig:GetGroupAll")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute("",HospID)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s GroupRowID=rset.Data("GroupRowID")
			i GroupRowID="" continue
			s GroupDesc=rset.Data("GroupDesc")
			s selected=0
	 		s:("^"_AudiNotLimitedGroupStr_"^")[("^"_GroupRowID_"^") selected=1
			
			if qstr="" s qstr=GroupRowID_$c(2)_GroupDesc_$c(2)_selected
			else  s qstr=qstr_$c(1)_GroupRowID_$c(2)_GroupDesc_$c(2)_selected
		}
	}
	q qstr
}

ClassMethod InsertExaBoroughGroupUser(Str As %String, HospID = "")
{
	;q:Str="" ""
	s ret=##class(web.DHCDocConfig).SaveConfig2("ExaBoroughGroupUser",Str,HospID)
	q ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCExaBorough","UFindUserNew","")
Query UFindUserNew(username As %String = "", HospID = "") As %Query(ROWSPEC = "name:%String,id:%String")
{
}

ClassMethod UFindUserNewExecute(ByRef qHandle As %Binary, username As %String = "", HospID = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s username=$$ALPHAUP^SSUTIL4(username)
	if HospID="" s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s AudiNotLimitedGroupStr=..%GetConfig("ExaBoroughGroupUser",HospID)
	s Rowid=""
	for{
		s Rowid=$O(^SSU("SSUSR",Rowid))
		q:Rowid=""
		continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",Rowid,HospID)
		s ssusrname=$P(^SSU("SSUSR",Rowid),"^",2)
		s USRInitials=$p(^SSU("SSUSR",Rowid),"^",1)
		s FindFlag=##class(DHCDoc.Util.Base).CheckAliasByTableName("SS_User",Rowid,username)
	    continue:(username'="")&($$ALPHAUP^SSUTIL4(ssusrname)'[username)&($$ALPHAUP^SSUTIL4(USRInitials)'[username)&(FindFlag=0)
		s ssusrgroup=$P(^SSU("SSUSR",Rowid),"^",5)
		s flag=0
		s longrowid=""
		for{
			s longrowid=$o(^SSU("SSUSR",Rowid,"OTHLL",longrowid))
			q:longrowid=""
			s longGroup=$P(^SSU("SSUSR",Rowid,"OTHLL",longrowid),"^",2)
			if ("^"_AudiNotLimitedGroupStr_"^")[("^"_longGroup_"^") s flag=1
		}
		continue:((flag=0)&&(("^"_AudiNotLimitedGroupStr_"^")'[("^"_ssusrgroup_"^")))
		set Data=$lb(ssusrname,Rowid)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod UFindUserNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UFindUserNewExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	 }
	 Else      {				// fetch row
		 Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod UFindUserNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UFindUserNewExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 校验医生的别名数据
ClassMethod CheckDocAlias(CTPCPDR As %String, docname As %String) As %String
{
	s docname=$$ALPHAUP^SSUTIL4(docname)
	if (docname=""){
		q 1
	}
	Set OtherName=$p(^CTPCP(CTPCPDR,3),"^",28)
	s OtherName=$$ALPHAUP^SSUTIL4(OtherName)
	if ($e(OtherName,1,$l(docname))=docname){
		q 1
	}
	s IsSelect=0
	Set ChildSub=0
	For {
		Set ChildSub=$o(^CTPCP(CTPCPDR,"KEYW",ChildSub))
		Quit:ChildSub=""
		Set Alias=$p($g(^CTPCP(CTPCPDR,"KEYW",ChildSub)),"^",1)
		s Alias=$$ALPHAUP^SSUTIL4(Alias)
		Continue:$e(Alias,1,$l(docname))'=docname
		Set IsSelect=1
	}
	q IsSelect
}

/// d ##class(%ResultSet).RunQuery("web.DHCExaBorough","QueryMarkGranted","238","","")
Query QueryMarkGranted(GroupId As %String, LocId As %String, MarkId As %String) As websys.Query(CONTAINID = 0, ROWSPEC = "index:%String,groupId:%String,GroupDesc:%String,ResRowId:%String,CTLocDesc:%String,ResCTPCPDesc:%String,MarkId:%String,LocId:%String")
{
}

ClassMethod QueryMarkGrantedExecute(ByRef qHandle As %Binary, GroupId As %String, LocId As %String, MarkId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (GroupId="")&&(LocId="")&&(MarkId=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	if (GroupId'="") {
		d GetOutPutData(GroupId)
	}else{
		s groupId=0
		for {
			s groupId=$o(^SSU("SSGRP",groupId)) Q:groupId=""
			d GetOutPutData(groupId)
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow21
	Set ^CacheTemp(repid,ind)=$LB(ind,groupId,GroupDesc,ResRowId,CTLocDesc,ResCTPCPDesc,ResCTPCPDr,ResCTLocDr)
	Set ind=ind+1
	quit
GetOutPutData(groupId)
  s GrantedMarkStr=$P($g(^SSU("SSGRP",groupId,"DHC")),"^",1)
  Q:GrantedMarkStr=""
  for i=1:1:$l(GrantedMarkStr,"!") {
	  s ResRowId=$p(GrantedMarkStr,"!",i)
	  continue:'$d(^RB("RES",ResRowId))
	  s ResCTLocDr=$p($G(^RB("RES",ResRowId)),"^",1)
	  continue:ResCTLocDr=""
	  continue:(ResCTLocDr'=LocId)&&(LocId'="")
	  s ResCTPCPDr=$p($G(^RB("RES",ResRowId)),"^",2)
	  continue:'$d(^CTPCP(ResCTPCPDr))
	  continue:(ResCTPCPDr'=MarkId)&&(MarkId'="")
	  s ResCTPCPDesc=$p(^CTPCP(ResCTPCPDr,1),"^",2)
	  s CTLocDesc=$p(^CTLOC(ResCTLocDr),"^",2)
	  s GroupDesc=$p(^SSU("SSGRP",groupId),"^",1)
	  d OutputRow21
  }
  Q
}

/// 诊区号别对照->挂号授权
/// w ##class(web.DHCExaBorough).SaveGroupRes("163","",528)
ClassMethod SaveGroupRes(GroupId As %String, LocId As %String, MarkId As %String, type As %String) As %String
{
	s ResRowId=$o(^RB("RES",0,"CTPCP",MarkId,LocId,""))
	Q:ResRowId="" "-1"
	s RePeatFlag=0
	s osPara=$P($g(^SSU("SSGRP",GroupId,"DHC")),"^",1)
	if (type="Add")&&(osPara="") {
		s $P(^SSU("SSGRP",GroupId,"DHC"),"^",1)=ResRowId
	}else{
		s resPara=""
		s osLen=$l(osPara,"!")
		f i=1:1:osLen {
			s curValue=$p(osPara,"!",i)
			i ("!"_ResRowId_"!")'[("!"_curValue_"!") {
				i resPara="" s resPara=curValue
				e  s resPara=resPara_"!"_curValue
			}else{
				s RePeatFlag=1
			}
		}
		Q:(RePeatFlag=1)&&(type="Add") "-2"
		if (type="Add") s resPara=resPara_"!"_ResRowId
		s $P(^SSU("SSGRP",GroupId,"DHC"),"^",1)=resPara
   }
   Q 0
}

/// 获取分诊区号别对照列表
/// d ##class(%ResultSet).RunQuery("web.DHCExaBorough","FindDoc","30","")
Query FindExaDoc(ExaId As %String, depstr, docname As %String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "Desc:%String,RowID:%String,ResRowId:%String,PoweredFlag:%String,code:%String")
{
}

ClassMethod FindExaDocExecute(ByRef qHandle As %Binary, ExaId As %String, depstr, docname As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (depstr="")||(ExaId=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	for i=1:1:$l(depstr,"^") {
		s depid=$p(depstr,"^",i)
		s locDesc=$p(^CTLOC(depid),"^",2)
		s count=1
		s RESRowId=""
		for {
			s RESRowId=$O(^RB("RES",0,"CTLOC",depid,RESRowId))
			q:(RESRowId="")
			s DateActiveFrom=$P(^RB("RES",RESRowId),"^",22)
			continue:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
			s DateActiveTo=$P(^RB("RES",RESRowId),"^",23)
			continue:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
			s CTPCPDR=$P(^RB("RES",RESRowId),"^",2)
			continue:(CTPCPDR="")
			continue:'$D(^CTPCP(CTPCPDR,1))
			s CTPCPDesc=$P(^CTPCP(CTPCPDR,1),"^",2)
			continue:0=##Class(web.DHCExaBorough).CheckDocAlias(CTPCPDR,docname)
			Set OtherName=$p(^CTPCP(CTPCPDR,3),"^",28)
			if (count=1) s CTPCPDesc=CTPCPDesc_"<span style='color:red;'>---"_locDesc_"</span>"
			s PoweredFlag="N"
			//分诊区科室对照存在一个科室对应多个诊区,分诊区号别对照是一对一
			s ID=0
			for {
				s ID=$o(^User.DHCDepMarkI("DempDepDrMarkDrIndex"," "_depid,CTPCPDR,ID)) Q:(ID="")||(PoweredFlag="Y")
				s DepmBorDr=$lg(^User.DHCDepMarkD(ID),7)
				continue:(DepmBorDr'=ExaId)
				s PoweredFlag="Y"
			}
			//if ($d(^User.DHCDepMarkI("DempDepDrMarkDrIndex"," "_depid,CTPCPDR))) s PoweredFlag="Y"
			s count=count+1
			d OutputRow2
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow2
	Set ^CacheTemp(repid,ind)=$LB(CTPCPDesc,CTPCPDR,RESRowId,PoweredFlag,OtherName)
	Set ind=ind+1
	quit
}

/// 分诊区号别对照批量授权
/// w ##class(web.DHCExaBorough).SaveExaBorMark(3,"1131!1160!1851!2333!2587!2760!3014!3367","1058!2989")
ClassMethod SaveExaBorMark(ExaId As %String, inPara As %String, subPara As %String) As %String
{
	for i=1:1:$l(inPara,"!") {
		s ResRowId=$p(inPara,"!",i)
		continue:ResRowId=""
		s LocId=$p(^RB("RES",ResRowId),"^",1)
		s DocId=$p(^RB("RES",ResRowId),"^",2)
		s Id=$o(^User.DHCDepMarkI("DempDepDrMarkDrIndex"," "_LocId,DocId,""))
		if (Id=""){
			d ..insertDepMark("","",ExaId,LocId,DocId,1,"Y","N")
		}
	}
	for i=1:1:$l(subPara,"!") {
		s ResRowId=$p(subPara,"!",i)
		continue:ResRowId=""
		s LocId=$p(^RB("RES",ResRowId),"^",1)
		s DocId=$p(^RB("RES",ResRowId),"^",2)
		s Id=0
		for {
			s Id=$o(^User.DHCDepMarkI("DempDepDrMarkDrIndex"," "_LocId,DocId,Id)) Q:Id=""
			s DepmBorDr=$lg(^User.DHCDepMarkD(Id),7)
			if (ExaId=DepmBorDr) {
				d ..delDepMark("","",Id)
			}
		}
		
	}
	Q 0
}

/// 获取医生号别对照列表
/// d ##class(%ResultSet).RunQuery("web.DHCExaBorough","FindMarkDoc","30","")
Query FindMarkDoc(depid, DocId, docname As %String = "", Type As %String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "Desc:%String,RowID:%String,code:%String,PoweredFlag:%String")
{
}

ClassMethod FindMarkDocExecute(ByRef qHandle As %Binary, depid, DocId, docname As %String = "", Type As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (depid="")||(DocId=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s RESRowId=""
	for {
		s RESRowId=$O(^RB("RES",0,"CTLOC",depid,RESRowId))
		q:(RESRowId="")
		s ScheduleRequired=$P(^RB("RES",RESRowId),"^",6)
		continue:(ScheduleRequired'="Y")&&(Type'="MarkToDoc")
		s DateActiveFrom=$P(^RB("RES",RESRowId),"^",22)
		continue:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
		s DateActiveTo=$P(^RB("RES",RESRowId),"^",23)
		continue:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
		s CTPCPDR=$P(^RB("RES",RESRowId),"^",2)
		continue:(CTPCPDR="")
		continue:'$D(^CTPCP(CTPCPDR,1))
		s CTPCPDesc=$P(^CTPCP(CTPCPDR,1),"^",2)
		continue:0=##Class(web.DHCExaBorough).CheckDocAlias(CTPCPDR,docname)
		Set OtherName=$p(^CTPCP(CTPCPDR,3),"^",28)
		s PoweredFlag="N"
		s id="",flag=0
		for {
			s id=$o(^User.DHCMarkDocI("MarkddepDrIndex",depid,id)) q:(id="")||(flag=1)  d
			s docid=$lg(^User.DHCMarkDocD(id),2)
			s regid=$lg(^User.DHCMarkDocD(id),3)
			s locid=$lg(^User.DHCMarkDocD(id),4)
			if (Type="MarkToDoc") {
				//根据号别查对照医生
				i ((regid=DocId)&&(docid=CTPCPDR)&&(locid=depid)) s flag=1
			}else{
				i ((docid=DocId)&&(regid=CTPCPDR)&&(locid=depid)) s flag=1
			}
		}
		if (flag=1) s PoweredFlag="Y"
		d OutputRow5
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow5
	Set ^CacheTemp(repid,ind)=$LB(CTPCPDesc,CTPCPDR,OtherName,PoweredFlag)
	Set ind=ind+1
	quit
}

/// 批量保存医生号别对照--医生对号别
ClassMethod SaveMarkDoc(Loc As %String, DocId As %String, inPara As %String, subPara As %String) As %String
{
	if (inPara'="") {
		d ##class(DHCDoc.DHCDocConfig.CommonFunction).insertMarkDocMulit(Loc,inPara,DocId)
	}
	for i=1:1:$l(subPara,"^") {
		s MarkId=$p(subPara,"^",i)
		s id="",FindID=""
		for {
			s id=$o(^User.DHCMarkDocI("MarkddepDrIndex",Loc,id)) q:(id="")||(FindID'="")
			s docid=$lg(^User.DHCMarkDocD(id),2)
			s regid=$lg(^User.DHCMarkDocD(id),3)
			s locid=$lg(^User.DHCMarkDocD(id),4)
			i ((docid=DocId)&&(regid=MarkId)&&(locid=Loc)) s FindID=id
		}
		if (FindID'="") d ##class(DHCDoc.DHCDocConfig.CommonFunction).deleteMarkDoc(FindID)
	}
	Q 0
}

/// 批量保存医生号别对照--号别对医生
ClassMethod SaveDocMark(Loc As %String, MarkId As %String, inPara As %String, subPara As %String) As %String
{
	if (inPara'="") {
		for i=1:1:$l(inPara,"^"){
			s DocID=$P(inPara,"^",i)
			s insertrtn=##class(DHCDoc.DHCDocConfig.CommonFunction).insertMarkDoc("",Loc,MarkId,DocID,"","add")
		}
	}
	for i=1:1:$l(subPara,"^") {
		s DocId=$p(subPara,"^",i)
		s id="",FindID=""
		for {
			s id=$o(^User.DHCMarkDocI("MarkddepDrIndex",Loc,id)) q:(id="")||(FindID'="")
			s docid=$lg(^User.DHCMarkDocD(id),2)
			s regid=$lg(^User.DHCMarkDocD(id),3)
			s locid=$lg(^User.DHCMarkDocD(id),4)
			if ((DocId=docid)&&(regid=MarkId)&&(locid=Loc)) s FindID=id
		}
		if (FindID'="") d ##class(DHCDoc.DHCDocConfig.CommonFunction).deleteMarkDoc(FindID)
	}
	Q 0
}

}
