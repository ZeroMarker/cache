Class DHCDoc.DHCDocConfig.ItemOrderQtyLimit Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query ItemOrderQtyLimitList(ArcimRowid As %String, HospId As %String = "") As %Query(ROWSPEC = "DARCIMRowid:%String,DARCIMARCIMDR:%String,ARCIMDesc:%String,DARCIMMinQty:%String,DARCIMMaxQty:%String,DARCIMShowOEMessage:%String,DARCIMRequireNote:%String,DARCIMNeedSkinTest:%String,DARCIMAlertStockQty:%String,DARCIMIPNeedBillQty:%String,DARCIMPartialValue:%String,DARCIMPartial:%String,DARCIMSttCanCrossDay:%String,AllowOnlyOnce:%String,DARCIMConflictTypeValue:%String,DARCIMConflictType:%String,AutoInsertONEOrd:%String,SameFreqDifferentDoses:%String,CustomDescOrd:%String,DARCIMOrdDateCanCrossDay:%String,LabOrdDayAllowRepeat:%String,DARCIMCountInButNotOutFlag:%String,DARCIMCountInButNotOutIPLongOrdRollSttTime:%String,NotLimitQty:%String")
{
}

ClassMethod ItemOrderQtyLimitListExecute(ByRef qHandle As %Binary, ArcimRowid As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemOrderQtyLimit","ItemOrderQtyLimitList")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	k ^TempItemOrderQtyLimitList
	s num=0
	i ArcimRowid'="" d
	.s DARCIMRowid=0
	.f  s DARCIMRowid=$O(^DHCItmMast("0","ARCIM",ArcimRowid,DARCIMRowid)) Q:DARCIMRowid=""  d
	..d GetOutPutData(DARCIMRowid)
	e  d
	.s DARCIMRowid=0
    .f  s DARCIMRowid=$O(^DHCItmMast(DARCIMRowid)) Q:DARCIMRowid=""  d
    ..d GetOutPutData(DARCIMRowid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowItemOrderQtyLimitList
	Set ^TempItemOrderQtyLimitList(ind)=DARCIMRowid_"^"_DARCIMARCIMDR_"^"_ARCIMDesc_"^"_DARCIMShowOEMessage
					_"^"_DARCIMRequireNote_"^"_DARCIMAlertStockQty_"^"_DARCIMIPNeedBillQty
					_"^"_DARCIMPartial_"^"_DARCIMCanCrossDay_"^"_DARCIMAllowOnlyOnce_"^"_DARCIMConflictType
					_"^"_AutoInsertONEOrd_"^"_SameFreqDifferentDoses_"^"_OrdDateCanCrossDay
					_"^"_LabOrdDayAllowRepeat_"^"_DARCIMCountInButNotOutFlag
					_"^"_DARCIMCountInButNotOutIPLongOrdRollSttTime
	Set Data=$lb(DARCIMRowid,DARCIMARCIMDR,ARCIMDesc,DARCIMMinQty,DARCIMMaxQty,DARCIMShowOEMessage,DARCIMRequireNote,DARCIMNeedSkinTest,DARCIMAlertStockQty,DARCIMIPNeedBillQty,DARCIMPartialValue,DARCIMPartial,DARCIMCanCrossDay,DARCIMAllowOnlyOnce,DARCIMConflictTypeValue,DARCIMConflictType,AutoInsertONEOrd,SameFreqDifferentDoses,CustomDescOrd,OrdDateCanCrossDay,LabOrdDayAllowRepeat,DARCIMCountInButNotOutFlag,DARCIMCountInButNotOutIPLongOrdRollSttTime,NotLimitQty)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
GetOutPutData(DARCIMRowid)
     s num=num+1
     set DARCIMARCIMDR=$P(^DHCItmMast(DARCIMRowid),"^",1)
     q:'$d(^ARCIM(+DARCIMARCIMDR,$p(DARCIMARCIMDR,"||",2),1))
     Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",DARCIMARCIMDR,HospId)="N"
     set ARCIMDesc=$p(^ARCIM(+DARCIMARCIMDR,$p(DARCIMARCIMDR,"||",2),1),"^",2)
	 Set ARCIMDesc=##class(web.DHCDocUtil).EvalJSON(ARCIMDesc)
     set DARCIMMinQty=$P(^DHCItmMast(DARCIMRowid),"^",2)
     set DARCIMMaxQty=$P(^DHCItmMast(DARCIMRowid),"^",3)
     set DARCIMShowOEMessage=$P(^DHCItmMast(DARCIMRowid),"^",4)
     i DARCIMShowOEMessage="" s DARCIMShowOEMessage="N"
     set DARCIMRequireNote=$P(^DHCItmMast(DARCIMRowid),"^",5)
     i DARCIMRequireNote="" s DARCIMRequireNote="N"
     set DARCIMNeedSkinTest=$P(^DHCItmMast(DARCIMRowid),"^",6)
     i DARCIMNeedSkinTest="" s DARCIMNeedSkinTest="N"
     set DARCIMAlertStockQty=$P(^DHCItmMast(DARCIMRowid),"^",7)
     set DARCIMIPNeedBillQty=$P(^DHCItmMast(DARCIMRowid),"^",8)
     i DARCIMIPNeedBillQty="" s DARCIMIPNeedBillQty="N"
     set DARCIMPartialValue=$P(^DHCItmMast(DARCIMRowid),"^",9)
     s DARCIMPartial=""
     i DARCIMPartialValue="A" s DARCIMPartial="按实际单次剂量计算"
     i DARCIMPartialValue="H" s DARCIMPartial="偏好取半(即不足一半取半,足够一半取整)"
     i DARCIMPartialValue="FD" s DARCIMPartial="偏好向下取整(即不为整数则向下取整，最小值不低于1)"
     i DARCIMPartialValue="FU" s DARCIMPartial="偏好向上取整(即不为整数则向上取整)"
     set DARCIMCanCrossDay=$P(^DHCItmMast(DARCIMRowid),"^",11)
     //i DARCIMCanCrossDay="" s DARCIMCanCrossDay="N"
     s DARCIMAllowOnlyOnce=$P(^DHCItmMast(DARCIMRowid),"^",13)
     i DARCIMAllowOnlyOnce="" s DARCIMAllowOnlyOnce="N"
     s DARCIMConflictTypeValue=$P(^DHCItmMast(DARCIMRowid),"^",14)
     i DARCIMConflictTypeValue="" s DARCIMConflictTypeValue="TW"
     s DARCIMConflictType=$case(DARCIMConflictTypeValue,"OW":"单向","TW":"双向")
     s AutoInsertONEOrd=$P(^DHCItmMast(DARCIMRowid),"^",15)
     s SameFreqDifferentDoses=$P(^DHCItmMast(DARCIMRowid),"^",22)
     s CustomDescOrd=$P(^DHCItmMast(DARCIMRowid),"^",24)
     s OrdDateCanCrossDay=$P(^DHCItmMast(DARCIMRowid),"^",25)
     s LabOrdDayAllowRepeat=$P(^DHCItmMast(DARCIMRowid),"^",26)
     s DARCIMCountInButNotOutFlag=$P(^DHCItmMast(DARCIMRowid),"^",27)
     s DARCIMCountInButNotOutIPLongOrdRollSttTime=$P(^DHCItmMast(DARCIMRowid),"^",28)
     s NotLimitQty=$P(^DHCItmMast(DARCIMRowid),"^",30)
     //q:num>=219
     d OutputRowItemOrderQtyLimitList
}

ClassMethod ItemOrderQtyLimitListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ItemOrderQtyLimitListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ItemOrderQtyLimitListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItemOrderQtyLimitListExecute ]
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

/// w ##class(DHCDoc.DHCDocConfig.ItemOrderQtyLimit).delete("240")
ClassMethod delete(Rowid) [ ProcedureBlock = 0 ]
{
	&sql(delete from SQLUser.DHC_ItmMast where DARCIM_Rowid=:Rowid)
    Q SQLCODE
}

// w ##class(DHCDoc.DHCDocConfig.ItemOrderQtyLimit).save("1^10338||1^^^N^N^N^^N^^N")

ClassMethod save(str As %String) As %String [ ProcedureBlock = 0 ]
{
	s ^tempsave("save")=str
	k PLIST
	s Rowid=$p(str,"^",1)
    s ArcimRowid=$p(str,"^",2)
    s count=0
    if (Rowid="") {
	    &sql(select count(*) into :count from SQLUser.DHC_ItmMast where DARCIM_ARCIM_DR=:ArcimRowid)
	}else{
		&sql(select count(*) into :count from SQLUser.DHC_ItmMast where DARCIM_ARCIM_DR=:ArcimRowid and DARCIM_Rowid<>:Rowid)
	}
	Q:count'=0 "-1"
	s PLIST(2)=$p(str,"^",2)
    s PLIST(3)=$p(str,"^",3)
    s PLIST(4)=$p(str,"^",4)
    s PLIST(5)=$p(str,"^",5)
    s PLIST(6)=$p(str,"^",6)
    s PLIST(7)=$p(str,"^",7)
    s PLIST(8)=$p(str,"^",8)
    s PLIST(9)=$p(str,"^",9)
    s PLIST(10)=$p(str,"^",10)
    s PLIST(12)=$p(str,"^",11)
    s PLIST(14)=$p(str,"^",12)
    s PLIST(15)=$p(str,"^",13)
    s PLIST(16)=$p(str,"^",14)
    s PLIST(23)=$p(str,"^",15)
    s PLIST(25)=$p(str,"^",16)
    s PLIST(26)=$p(str,"^",17)
    s PLIST(27)=$p(str,"^",18)
    s PLIST(28)=$p(str,"^",19)
    s PLIST(29)=$p(str,"^",20)
    s PLIST(31)=$p(str,"^",21)
	if (Rowid=""){
		&sql(insert into SQLUser.DHC_ItmMast values PLIST())
		if SQLCODE=0 q 0
        e  q SQLCODE
	}else{
		s arcim=PLIST(2)
	    s minqty=PLIST(3)
	    s maxqty=PLIST(4)
	    s ShowOEMessage=PLIST(5)
	    s RequireNote=PLIST(6)
	    s NeedSkinTest=PLIST(7)
	    s AlertStockQty=PLIST(8)
	    s IPNeedBillQty=PLIST(9)
	    s PartialValue=PLIST(10)
	    s DARCIMCanCrossDay=PLIST(12)
	    s AllowOnlyOnce=PLIST(14)
	    s DARCIMConflictType=PLIST(15)
	    s AutoInsertONEOrd=PLIST(16)
	    s SameFreqDifferentDoses=PLIST(23)
	    s CustomDescOrd=PLIST(25)
	    s OrdDateCanCrossDay=PLIST(26)
	    s LabOrdDayAllowRepeat=PLIST(27)
	    s DARCIMCountInButNotOutFlag=PLIST(28)
    	s DARCIMCountInButNotOutIPLongOrdRollSttTime=PLIST(29)
    	s DARCIMNotLimitQty=PLIST(31)
		//s rtn=$$update^DHCItmMast(Rowid)
		&sql(update SQLUser.DHC_ItmMast
		 set DARCIM_ARCIM_DR=:arcim,DARCIM_MinQty=:minqty,DARCIM_MaxQty=:maxqty,DARCIM_ShowOEMessage=:ShowOEMessage,DARCIM_RequireNote=:RequireNote,DARCIM_NeedSkinTest=:NeedSkinTest,DARCIM_AlertStockQty=:AlertStockQty,DARCIM_IPNeedBillQty=:IPNeedBillQty,DARCIM_PartialValue=:PartialValue
		 ,DARCIM_CanCrossDay=:DARCIMCanCrossDay,DARCIM_AllowOnlyOnce=:AllowOnlyOnce,DARCIM_ConflictType=:DARCIMConflictType,DARCIM_AutoInsertONEOrd=:AutoInsertONEOrd,DARCIM_SameFreqDifferentDosesFlag=:SameFreqDifferentDoses
		 ,DARCIM_CustomDescOrd=:CustomDescOrd,DARCIM_OrdDateCanCrossDay=:OrdDateCanCrossDay,DARCIM_LabOrdDayAllowRepeat=:LabOrdDayAllowRepeat
		 ,DARCIM_CountInButNotOutFlag=:DARCIMCountInButNotOutFlag,DARCIM_CountInButNotOutIPLongOrdRollSttTime=:DARCIMCountInButNotOutIPLongOrdRollSttTime,DARCIM_NotLimitQty=:DARCIMNotLimitQty
		 where DARCIM_Rowid=:Rowid )
		q SQLCODE
	}
	q rtn
}

Query ItemConflictList(DARCIMRowid As %String) As %Query(ROWSPEC = "RowID:%String,ITCConflictItmDR:%String,ARCIMDesc:%String,ConflictType:%String")
{
}

ClassMethod ItemConflictListExecute(ByRef qHandle As %Binary, DARCIMRowid As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemOrderQtyLimit","ItemConflictList")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	s ITCChildsub=0 f  s ITCChildsub=$o(^DHCItmMast(DARCIMRowid,"CF",ITCChildsub)) q:ITCChildsub=""  d
	.s ITCConflictItmDR=$p(^DHCItmMast(DARCIMRowid,"CF",ITCChildsub),"^",1)
	.s ARCIMDesc=$p(^ARCIM(+ITCConflictItmDR,$p(ITCConflictItmDR,"||",2),1),"^",2)
	.s ConflictType=$p(^DHCItmMast(DARCIMRowid,"CF",ITCChildsub),"^",2)
	.i ConflictType="R" s ConflictType="反"
	.i ConflictType="F" s ConflictType="畏"
	.s RowID=DARCIMRowid_"||"_ITCChildsub
    .d OutputRowItemConflictList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowItemConflictList
	Set Data=$lb(RowID,ITCConflictItmDR,ARCIMDesc,ConflictType)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod ItemConflictListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ItemConflictListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ItemConflictListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItemConflictListExecute ]
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

ClassMethod deleteConflict(Rowid) [ ProcedureBlock = 0 ]
{
    &sql(delete from SQLUser.DHC_ItmConflict where ITC_Rowid=:Rowid)
    q SQLCODE
}

ClassMethod insertConflict(DARCIMRowid As %String, arcim As %String, ConflictType As %String) [ ProcedureBlock = 0 ]
{
	k PLIST
	&sql(SELECT * FROM SQLUser.DHC_ItmConflict WHERE ITC_ConflictItm_DR=:arcim and ITC_Parref=:DARCIMRowid)
	q:(SQLCODE=0) "-1"
	s PLIST(0)=DARCIMRowid
	s PLIST(3)=arcim
	s PLIST(4)=ConflictType
    &sql(insert into SQLUser.DHC_ItmConflict values :PLIST())
    q SQLCODE
}

Query ItemOrderQtyLimitListExport(num As %String) As %Query(ROWSPEC = "DARCIMRowid:%String,DARCIMARCIMDR:%String,ARCIMDesc:%String,DARCIMMinQty:%String,DARCIMMaxQty:%String,DARCIMShowOEMessage:%String,DARCIMRequireNote:%String,DARCIMNeedSkinTest:%String,DARCIMAlertStockQty:%String,DARCIMIPNeedBillQty:%String,DARCIMPartialValue:%String,DARCIMPartial:%String")
{
}

ClassMethod ItemOrderQtyLimitListExportExecute(ByRef qHandle As %Binary, num As %String) As %Status
{
	;w ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemOrderQtyLimit","ItemOrderQtyLimitList")
	;w ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemOrderQtyLimit","ItemOrderQtyLimitListExport","2")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	set DARCIMRowid=$p(^TempItemOrderQtyLimitList(num),"^",1)
	set DARCIMARCIMDR=$p(^TempItemOrderQtyLimitList(num),"^",2)
	set ARCIMDesc=$p(^TempItemOrderQtyLimitList(num),"^",3)
	set DARCIMMinQty=$p(^TempItemOrderQtyLimitList(num),"^",4)
	set DARCIMMaxQty=$p(^TempItemOrderQtyLimitList(num),"^",5)
	set DARCIMShowOEMessage=$p(^TempItemOrderQtyLimitList(num),"^",6)
	set DARCIMRequireNote=$p(^TempItemOrderQtyLimitList(num),"^",7)
	set DARCIMNeedSkinTest=$p(^TempItemOrderQtyLimitList(num),"^",8)
	set DARCIMAlertStockQty=$p(^TempItemOrderQtyLimitList(num),"^",9)
	set DARCIMIPNeedBillQty=$p(^TempItemOrderQtyLimitList(num),"^",10)
	set DARCIMPartialValue=$p(^TempItemOrderQtyLimitList(num),"^",11)
	set DARCIMPartial=$p(^TempItemOrderQtyLimitList(num),"^",12)
	d OutputRowItemOrderQtyLimitList1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowItemOrderQtyLimitList1
	Set Data=$lb(DARCIMRowid,DARCIMARCIMDR,ARCIMDesc,DARCIMMinQty,DARCIMMaxQty,DARCIMShowOEMessage,DARCIMRequireNote,DARCIMNeedSkinTest,DARCIMAlertStockQty,DARCIMIPNeedBillQty,DARCIMPartialValue,DARCIMPartial)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod ItemOrderQtyLimitListExportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ItemOrderQtyLimitListExportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ItemOrderQtyLimitListExportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItemOrderQtyLimitListExportExecute ]
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

ClassMethod ItemOrderQtyLimitListExport1(num As %String) As %String
{
	q:num="" "{"_"""result"""_":"_""""_""_""""_"}"
	Set Data=$g(^TempItemOrderQtyLimitList(num))
	s Data="{"_"""result"""_":"_""""_Data_""""_"}"
	q Data
}

Query FindConflictType() As %Query(ROWSPEC = "ConflictTypeRowid:%String,ConflictTypeDesc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemOrderQtyLimit","FindConflictType","2")
ClassMethod FindConflictTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	f TypeSeq=1:1:2 d
	.i TypeSeq=1 s ConflictTypeRowid="R",ConflictTypeDesc="反"
	.i TypeSeq=2 s ConflictTypeRowid="F",ConflictTypeDesc="畏"
	.d OutputConflictType
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputConflictType
	Set Data=$lb(ConflictTypeRowid,ConflictTypeDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindConflictTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindConflictTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindConflictTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindConflictTypeExecute ]
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

ClassMethod deleteItmReplace(Rowid) [ ProcedureBlock = 0 ]
{
    &sql(delete from SQLUser.DHC_ItmReplace where IR_Rowid=:Rowid)
    q SQLCODE
}

/// w ##class(DHCDoc.DHCDocConfig.ItemOrderQtyLimit).saveItmReplace("3||682",3,"3115||1",1)
ClassMethod saveItmReplace(RowID As %String, DARCIMRowid As %String, arcim As %String, Expression As %String) [ ProcedureBlock = 0 ]
{
	s DARCIMARCIMDR=$p(^DHCItmMast(DARCIMRowid),"^",1)
	Q:arcim=DARCIMARCIMDR "-2"
	k PLIST
	s PLIST(3)=arcim
	s PLIST(4)=Expression
	s count=0
	if (RowID="") {
		s PLIST(0)=DARCIMRowid
		&sql(SELECT count(*) into :count FROM SQLUser.DHC_ItmReplace WHERE IR_ReplaceItm_DR=:arcim and IR_Parref=:DARCIMRowid and IR_ReplaceExpress=:Expression and IR_Childsub>0)
		q:(count>0) "-1"
	    &sql(insert into SQLUser.DHC_ItmReplace values :PLIST())
	}else{
		&sql(SELECT count(*) into :count FROM SQLUser.DHC_ItmReplace WHERE IR_ReplaceItm_DR=:arcim and IR_Parref=:DARCIMRowid and IR_ReplaceExpress=:Expression and IR_Rowid<>:RowID and IR_Childsub>0)
		q:(count>0) "-1"
	    &sql(update SQLUser.DHC_ItmReplace values :PLIST() where IR_Rowid=:RowID )
	}
    q SQLCODE
}

Query ItemReplaceList(DARCIMRowid As %String) As %Query(ROWSPEC = "RowID:%String,IRReplaceItmDR:%String,ARCIMDesc:%String,Expression:%String")
{
}

ClassMethod ItemReplaceListExecute(ByRef qHandle As %Binary, DARCIMRowid As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemOrderQtyLimit","ItemReplaceList",2)
	Set repid=$I(^CacheTemp)	
	Set ind=1
	s IRChildsub=0 f  s IRChildsub=$o(^DHCItmMast(DARCIMRowid,"CR",IRChildsub)) q:IRChildsub=""  d
	.s IRReplaceItmDR=$p(^DHCItmMast(DARCIMRowid,"CR",IRChildsub),"^",1)
	.s ARCIMDesc=$p(^ARCIM(+IRReplaceItmDR,$p(IRReplaceItmDR,"||",2),1),"^",2)
	.s Expression=$p(^DHCItmMast(DARCIMRowid,"CR",IRChildsub),"^",2)
	.s RowID=DARCIMRowid_"||"_IRChildsub
    .d OutputRowItemReplaceList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowItemReplaceList
	Set Data=$lb(RowID,IRReplaceItmDR,ARCIMDesc,Expression)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod ItemReplaceListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ItemReplaceListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ItemReplaceListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItemReplaceListExecute ]
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

/// 根据就诊ID、医嘱项ID获取符合条件的替换医嘱项ID
/// 须设置ProcedureBlock属性为0，否则该方法内部X Expression获取不到 result
/// w ##class(DHCDoc.DHCDocConfig.ItemOrderQtyLimit).GetReplaceItm(760,"5505||1")
ClassMethod GetReplaceItm(EpisodeID As %String, ARCIMRowId As %String) As %String [ ProcedureBlock = 0 ]
{
	s DHCARCIMRowid=$O(^DHCItmMast("0","ARCIM",ARCIMRowId,0))
	Q:DHCARCIMRowid="" ""
	s ReplaceItmRowId=""
	s IRChildsub=0 
	for  {
		s IRChildsub=$o(^DHCItmMast(DHCARCIMRowid,"CR",IRChildsub)) Q:(IRChildsub="")||(ReplaceItmRowId'="")
		s IRReplaceItmDR=$p(^DHCItmMast(DHCARCIMRowid,"CR",IRChildsub),"^",1)
		continue:IRReplaceItmDR=""
		s Expression=$p(^DHCItmMast(DHCARCIMRowid,"CR",IRChildsub),"^",2)
		continue:Expression=""
		s Expression="s result="_Expression
		try{
			X Expression
		}catch{
			s result=0
		}
		continue:result=0
		s ReplaceItmRowId=IRReplaceItmDR
	}
	Q ReplaceItmRowId
}

// ##class(DHCDoc.DHCDocConfig.ItemOrderQtyLimit).ReplaceItmTest($g(EpisodeID))

ClassMethod ReplaceItmTest(EpisodeID As %String) As %String
{
	Q 1
}

Query FindItem(Alias As %String, HospId As %String = "") As websys.Query(ROWSPEC = "ArcimRowID:%String,ArcimDesc:%String")
{
}

ClassMethod FindItemExecute(ByRef qHandle As %Binary, Alias As %String, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if (Alias=""){
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	s GroupID=%session.Data("LOGON.GROUPID")
	s UserID=%session.Data("LOGON.USERID")
	s LocId=%session.Get("LOGON.CTLOCID")
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	Set rs2=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.ArcItemConfig:FindAllItem")
	d rs2.Execute(Alias,"","","","","","",HospId)
	while(rs2.Next()){
		s ArcimID = rs2.GetData(1)
		continue:ArcimID=""
		s ArcimDesc=rs2.GetData(2)
		d OutputRowFindItem
	}
	Set rs1=##Class(%ResultSet).%New("web.DHCDocOrderEntryCM:LookUpItem")
	d rs1.Execute(Alias,GroupID,"","","","ALL","","","","",UserID,"","",LocId_$C(3)_HospId,"","^1")
	while(rs1.Next()){
		s ArcimDesc=rs1.GetData(1)
		s ArcimID = rs1.GetData(2)
		continue:ArcimID=""
		s ARCIMType=rs1.GetData(4)
		continue:ARCIMType="ARCOS"
		s ArcimDesc=##class(web.DHCDocUtil).EvalJSON(ArcimDesc)
		d OutputRowFindItem
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindItem
	Set Data=$lb(ArcimID,ArcimDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

}
