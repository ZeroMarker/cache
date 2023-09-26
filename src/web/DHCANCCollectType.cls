Import SQLUser

Class web.DHCANCCollectType Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// D ##class(%ResultSet).RunQuery("web.DHCANCCollectType","FindDHCANCCollectType")
Query FindDHCANCCollectType(fltStr As %String = "", bedRowId As %String = "", Source As %String = "") As %Query(ROWSPEC = "trowid,tCode,tDesc,tANCCTActive,tSource")
{
}

ClassMethod FindDHCANCCollectTypeExecute(ByRef qHandle As %Binary, fltStr As %String = "", bedRowId As %String = "", Source As %String = "") As %Status
{
	s ^TMPDEBUG("FindDHCANCCollectType",$h)=fltStr_bedRowId_Source
	s source=Source
	i source="" s source=$g(^TMPANICU("Source"))
	e  s ^TMPANICU("Source")=source
	
	s devs=""
	S cld=""
	i bedRowId'="" d
	.f  s cld=$o(^DHCICUBedEquip(0,"Bed",bedRowId,cld)) q:cld=""  d
	..s devs=devs_$p(^DHCICUBedEquip(cld),"^",5)_"^"
	..
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s trowid=0
	f  s trowid=$o(^DHCANC("CType",trowid))  q:trowid=""  d
	.s tCode=$p(^DHCANC("CType",trowid),"^",1)
	.s tDesc =$p(^DHCANC("CType",trowid),"^",2)
    .s tANCCTActive =$p(^DHCANC("CType",trowid),"^",3)
    .s tSource =$p(^DHCANC("CType",trowid),"^",4)
    .
    .q:(source'="")&&(source'=tSource)&&(source'="ALL")
    .
    .s cfltStr=$$UPPER^SSUTIL4(fltStr)
    .s ctDesc=$$UPPER^SSUTIL4(tDesc)
    .i +cfltStr=ctDesc i +fltStr=trowid d OutputRow 
    .e  i ctDesc[cfltStr d
	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	s hpDeves=$g(^DHCCLSet("devs"))
	i devs[trowid_"^"||(hpDeves'=""&&(hpDeves'[tCode)) q
	set Data=$lb(trowid,tCode,tDesc,tANCCTActive,tSource) 
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindDHCANCCollectTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDHCANCCollectTypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindDHCANCCollectTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDHCANCCollectTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindCollectTypeItem(MDIRowid As %String = "") As %Query(ROWSPEC = "trowid,tCode,tANCCTIComOrdDr,tANCCTIChannelNo,tANCCTIActive,tANCCTIComOrdDrDesc,tANCCTIComCode")
{
}

ClassMethod FindCollectTypeItemExecute(ByRef qHandle As %Binary, MDIRowid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tCode="",rowid=MDIRowid
	i +rowid=0 Set qHandle=$lb(0,repid,0) Quit $$$OK
	s source=$p(^DHCANC("CType",MDIRowid),"^",4)
	f  s tCode=$o(^DHCANC("CType",rowid,"I",tCode))  q:tCode=""  d
	.s tANCCTIComOrdDr=$p(^DHCANC("CType",rowid,"I",tCode),"^",1)
	.s tANCCTIChannelNo =$p(^DHCANC("CType",rowid,"I",tCode),"^",2)
	.s trowid=rowid_"||"_tCode
	.s tANCCTIActive =$p(^DHCANC("CType",rowid,"I",tCode),"^",3)
	.;s ComDes=$p(^DHCANC("ComOrd",rowid),"^",2)
	.s ^tmpandebug("tANCCTIComOrdDr")=source
	.i source="A" d AN
	.e  i source="I" d ICU
	.e  i source="B" d BP
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
AN
	s tANCCTIComCode=$p($g(^DHCANC("ComOrd",+tANCCTIComOrdDr)),"^",1)
	s tANCCTIComOrdDrDesc=$p($g(^DHCANC("ComOrd",+tANCCTIComOrdDr)),"^",2)
	s ^tmpandebug("tANCCTIComOrdDr")=tANCCTIComOrdDr
	Q
ICU
	s tANCCTIComCode=$p($g(^DHCICUC("RecordItem",+tANCCTIComOrdDr)),"^",1)
	s tANCCTIComOrdDrDesc=$p($g(^DHCICUC("RecordItem",+tANCCTIComOrdDr)),"^",2)
BP
	s tANCCTIComCode=$LIST($g(^DHCBPC("RecordItem",+tANCCTIComOrdDr)),1)
	s tANCCTIComOrdDrDesc=$LIST($g(^DHCBPC("RecordItem",+tANCCTIComOrdDr)),2)
	quit
	Q
OutputRow
	set Data=$lb(trowid,tCode,tANCCTIComOrdDr,tANCCTIChannelNo,tANCCTIActive,tANCCTIComOrdDrDesc,tANCCTIComCode) 
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCollectTypeItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCollectTypeItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindCollectTypeItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCollectTypeItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod InsertDHCANCCollectType(ANCCTCode As %String, ANCCTDesc As %String, ANCCTActive As %String, source As %String = "")
{
	
	k PLIST  
	TSTART
	s PLIST(2)=ANCCTCode
	s PLIST(3)=ANCCTDesc
	s PLIST(4)=ANCCTActive
	s PLIST(5)=source
	&SQL(insert into DHC_ANC_CollectType Values :PLIST())
	i SQLCODE
	{	
	  TROLLBACK
	  q SQLCODE
	}
	else
	{
		TCOMMIT
	}
	 q SQLCODE
}

ClassMethod UPDATEDHCANCCollectType(Rowid As %String, ANCCTCode As %String, ANCCTDesc As %String, ANCCTActive As %String)
{
	s ^TMPDTJ("ANCCTActive")=ANCCTCode_ANCCTDesc_ANCCTActive
	k PLIST  
	TSTART
	s PLIST(2)=ANCCTCode
	s PLIST(3)=ANCCTDesc
	s PLIST(4)=ANCCTActive
	&SQL(update  DHC_ANC_CollectType Values :PLIST() where ANCCT_RowId=:Rowid)
	i SQLCODE
	{	
	  TROLLBACK
	  q SQLCODE
	}
	else
	{
		TCOMMIT
	}
	 q SQLCODE
}

ClassMethod DeleteDHCANCCollectType(Rowid As %String)
{
	i Rowid'="" d
	.&SQL(delete from DHC_ANC_CollectType where ANCCT_RowId=:Rowid)
	q SQLCODE
}

ClassMethod InsertDHCANCCollectTypeitem(Code As %String, ANCCTIChannelNo As %String, ANCCTActive As %String, ANCCTIParref As %String, ANCCTIComOrdDr As %String)
{
	TSTART
	if ANCCTActive="" s ANCCTActive="Y"
	&SQL(insert into DHC_ANC_CollectTypeItem (ANCCTI_Parref,ANCCTI_ChildSub,ANCCTI_ComOrd_Dr,ANCCTI_ChannelNo,ANCCTI_Active) Values (:ANCCTIParref,:Code,:ANCCTIComOrdDr,:ANCCTIChannelNo,:ANCCTActive)) 
	i SQLCODE
	{	
	  TROLLBACK
	  q SQLCODE
	}
	else
	{
		TCOMMIT
	}
	 q SQLCODE
}

ClassMethod UPDATEDHCANCCollectTypeitem(RowId As %String, Code As %String, ANCCTIChannelNo As %String, ANCCTActive As %String, ANCCTIParref As %String, ANCCTIComOrdDr As %String)
{
	k PLIST  
	TSTART
	if ANCCTActive="" s ANCCTActive="Y"
    &sql(update DHC_ANC_CollectTypeItem set ANCCTI_ChildSub=:Code,ANCCTI_ComOrd_Dr=:ANCCTIComOrdDr,ANCCTI_ChannelNo=:ANCCTIChannelNo,ANCCTI_Active=:ANCCTActive where ANCCTI_RowId=:RowId)
	i SQLCODE
	{	
	  TROLLBACK
	  q SQLCODE
	}
	else
	{
		TCOMMIT
	}
	 q SQLCODE
}

ClassMethod DeleteDHCANCCollectTypeitem(Rowid As %String)
{
	i Rowid'="" d
	.&SQL(delete from DHC_ANC_CollectTypeItem where ANCCTI_RowId=:Rowid)
	q SQLCODE
}

Query FindDevPort(fltStr As %String = "", bedRowId As %String = "", source As %String = "") As %Query(ROWSPEC = "tPort,tDesc")
{
}

ClassMethod FindDevPortExecute(ByRef qHandle As %Binary, fltStr As %String = "", bedRowId As %String = "", source As %String = "") As %Status
{
	s fltStr=##class(web.DHCClinicCom).Replace(fltStr,"端口","")
	s fltStr=+fltStr
	s ^TMPDEBUG("dtj")=fltStr
	s ports=""
	S cld=""
	s bPort=4000
	s pCount=8
	i bedRowId'="" d
	.f  s cld=$o(^DHCICUBedEquip(0,"Bed",bedRowId,cld)) q:cld=""  d
	..s ports=ports_$p(^DHCICUBedEquip(cld),"^",4)_"^"
	..
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
 	f i=1:1:8 d
 	.s tPort=bPort+i
	.d OutputRow
	s tPort="24105"
	d OutputRow
	s tPort="950|4"
	d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow	
	i fltStr'=0  i (+fltStr'=tPort)&&(+fltStr'=i) q
	i ports[tPort_"^" q
	s tDesc="端口"_i
	set Data=$lb(tPort,tPort) 
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindDevPortFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDevPortExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindDevPortClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDevPortExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod SetHPDeves(devesStr As %String = "")
{
	s ^DHCCLSet("devs")=devesStr
	q 0
}

ClassMethod GetHPDeves()
{
	s deves=$g(^DHCCLSet("devs")) ;="PB840;Maquet;EVitaXL;Hamiltom;PhlipsV60;PhilipsMP;PhilipsIIC;Prismaflex;PICCO;ABL800;GEM3000"
	q deves
}

ClassMethod GetQueryStr(cName As %String, mName As %String, num1 As %String = 1, num2 As %String = 2, fltStr As %String = "", bedRowId As %String = "", source As %String = "") As %String
{
	b
	;w ##class(web.UDHCANOPArrange).GetAllOperRoomStr()
	s rset=##class(%ResultSet).%New(cName_":"_mName)
	s ret=""
	do rset.Execute(fltStr,bedRowId,source)
	while (rset.Next()) {
		s ret=ret_rset.GetData(num1)_"$c(2)"_rset.GetData(num2)_"$c(1)"
	}	
	d rset.Close()
	q ret
}

ClassMethod SetMSrvIP(mSrvIPStr As %String = "")
{
	s ^DHCCLSet("MSrvIP")=mSrvIPStr
	q 0
}

ClassMethod GetMSrvIP()
{
	s mSrvIP=$g(^DHCCLSet("MSrvIP")) 
	s sysType=$g(^TMPANICU("Source")) 
	q mSrvIP_"^"_sysType
}

/// 维护代码：复制DHC_ANC_CollectTypeItem表中的内容
/// w ##class(web.DHCANCCollectType).Copy()
ClassMethod Copy()
{
	s sub=""
	s count=^DHCANC("CType",0)
	f i=1:1:count d
	.s devInfo=^DHCANC("CType",i)
	.//插入设备类型
	.s devCode=$p(devInfo,"^",1)
	.s devDesc=$p(devInfo,"^",2)
	.s active=$p(devInfo,"^",3)
	.d ..InsertDHCANCCollectType(devCode,devDesc,active,"A")
	.// 插入设备类型所对应的通道号
	.
	.f  s sub=$O(^DHCANC("CType",i,"I",sub)) q:sub=""  d
	..s itemStr=^DHCANC("CType",i,"I",sub)
	..
	..s channelNo=$p(itemStr,"^",2)
	..s ative=$p(itemStr,"^",3)
	..s ccOrdDr=$p(itemStr,"^",1)
	..s parRef=0
	..s parRef=^DHCANC("CType",0)
	..
	..w ..InsertDHCANCCollectTypeitem(sub,channelNo,ative,parRef,ccOrdDr) 
	// InsertDHCANCCollectTypeitem(Code, ANCCTIChannelNo, ANCCTActive, ANCCTIParref, ANCCTIComOrdDr)
	q "0"
}

/// 维护代码：复制设备的通道信息到另一个设备
/// from:源设备Id，to:目的设备Id
/// w ##class(web.DHCANCCollectType).CopyTo(from , to)
ClassMethod CopyTo(from, to)
{
	s sub=""
	f  s sub=$O(^DHCANC("CType",from,"I",sub)) q:sub=""  d
	.s itemStr=^DHCANC("CType",from,"I",sub)
	.
	.s channelNo=$p(itemStr,"^",2)
	.s ative=$p(itemStr,"^",3)
	.s ccOrdDr=$p(itemStr,"^",1)
	.s parRef=0
	.s parRef=^DHCANC("CType",0)
	.
	.w ..InsertDHCANCCollectTypeitem(sub,channelNo,ative,to,ccOrdDr) 
	q 0
}

Query FindRecordItem(filter As %String, devTypeId As %String = "") As %Query(ROWSPEC = "MDIDesc:%String,MDIRowid:%String,code")
{
}

ClassMethod FindRecordItemExecute(ByRef qHandle As %Binary, filter As %String, devTypeId As %String = "") As %Status
{
	s ^tmpdebug("dtj")=filter_","_devTypeId
	s source=$p($g(^DHCANC("CType",devTypeId)),"^",4)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i source="I" d ICU
	e  i source="A" d AN
	e  i source="B" d BP
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ICU
	s id=0
	f  s id=$o(^DHCICUC("RecordItem",id)) q:id=""  d
	.s str=$g(^DHCICUC("RecordItem",id))
	.q:str=""
	.s rowid=$p(str,"^",5)
	.s desc=$p(str,"^",2)
	.s code=$p(str,"^",1)
	.s desc=$$UPPER^SSUTIL4(desc)
	.s filter=$$UPPER^SSUTIL4(filter)
	.i desc[filter d OutputRow
	.e  i code[filter d OutputRow	
	q 
AN 
	s id=0
	f  s id=$o(^DHCANC("ComOrd",id)) q:id=""  d
	.s str=$g(^DHCANC("ComOrd",id))
	.q:str=""
	.s rowid=$p(str,"^",5)
	.s desc=$p(str,"^",2)
	.s code=$p(str,"^",1)
	.s anapply=$p(str,"^",9)
	.q:(anapply'="")&(anapply'="Y")
	.s desc=$$UPPER^SSUTIL4(desc)
	.s filter=$$UPPER^SSUTIL4(filter)
	.i desc[filter d OutputRow b
	.e  i code[filter d OutputRow	
	q
BP
	s id=0
	f  s id=$o(^DHCBPC("RecordItem",id)) q:id=""  d
	.s str=$g(^DHCBPC("RecordItem",id))
	.q:str=""
	.s rowid=id
	.s desc=$LIST(str,2)
	.s code=$LIST(str,1)
	.s desc=$$UPPER^SSUTIL4(desc)
	.s filter=$$UPPER^SSUTIL4(filter)
	.i desc[filter d OutputRow
	.e  i code[filter d OutputRow	
	q
OutputRow
	set Data=$lb(desc,id,code)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindRecordItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRecordItemExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindRecordItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRecordItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CopyDevChNo(from, to) As %String
{
	// w ##class(web.DHCANCCollectType).CopyDevChNo(58,75)
	s sub=0 
	s ret="0"
	&SQL(delete from DHC_ANC_CollectTypeItem where ANCCTI_Parref=:to)
	f  s sub=$o(^DHCANC("CType",from,"I",sub)) q:sub=""  d
	.s item=$g(^DHCANC("CType",from,"I",sub))
	.q:((item="")||(ret'=0))
	.s ANCCTIComOrdDr=$p(item,"^",1)
	.s ANCCTIChannelNo=$p(item,"^",2)
	.s ANCCTActive=$p(item,"^",3)
	.s ret=..InsertDHCANCCollectTypeitem(sub, ANCCTIChannelNo, ANCCTActive, to, ANCCTIComOrdDr)

	q ret
}

Query FindMoniDataItem(filter As %String) As %Query(ROWSPEC = "MDIDesc:%String,MDIRowid:%String,MDICode:%String")
{
}

ClassMethod FindMoniDataItemExecute(ByRef qHandle As %Binary, filter As %String) As %Status
{
	k ^TMPDEBUG
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s MDIRowid=0
	f  s MDIRowid=$o(^DHCANC("ComOrd",MDIRowid)) q:MDIRowid=""  d
	   .;q:$p(^DHCANC("RecordItem",MDIRowid),"^",3)'="V"
	   .s str=$g(^DHCANC("RecordItem",MDIRowid))
	   .q:str=""
	   .s rowid=$p(str,"^",5)
	   .s MDIDesc=$p(str,"^",2)
	   .s MDICode=$p(str,"^",1)
	   .
	   .s isIcuApply="Y",isAnApply="Y"
	   .s isAnApply=$p(str,"^",9)
	   .
	   .s isIcuApply=$p(str,"^",10)
	   .q:(isIcuApply'="Y")
	   .s MDIDesc=$$UPPER^SSUTIL4(MDIDesc)
	   .s filter=$$UPPER^SSUTIL4(filter)
	   .i MDIDesc[filter d OutputRow1	
	   .e  i MDICode[filter d OutputRow1	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(MDIDesc,MDIRowid,MDICode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMoniDataItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMoniDataItemExecute ]
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
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMoniDataItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMoniDataItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##class(web.DHCANCCollectType).CompareCollectType("Dash4k","")

ClassMethod CompareCollectType(ANCCTCode As %String, rowId As %String) As %String
{
	s trowid=0,ret=0
	f  s trowid=$o(^DHCANC("CType",trowid))  q:trowid=""  d
		.s tCode=$p(^DHCANC("CType",trowid),"^",1)
		.i (tCode=ANCCTCode)&(rowId'=trowid) s ret=1
		.e  s ret=0
	q ret
}

}
