Class web.DHCANPara Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// 主表

ClassMethod AddDHCANPara(itmjs As %Library.String = "", itm As %Library.String = "", Str As %String)
{

 s retcode=..InsertDHCANPara(Str)
 s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
 i itm'="""" s retval=retval_itm_"('"_$ZCVT(retcode,"O","JS")_"');"
 &javascript<#(retval)#>
 q retcode
}

ClassMethod InsertDHCANPara(val As %String)
{
    set Inter=$p(val,"^",1)
	set ArrDr=$p(val,"^",2)
	set anpIbpFlag=$p(val,"^",3)
	//编译报错
    //&sql(INSERT INTO sqluser.DHC_AN_Para(ANP_OPA_Dr,ANP_Interval,ANP_IBPFlag) Values (:ArrDr,:Inter,:anpIbpFlag))
    	    i SQLCODE=0 d   s retcode=0
	    e  s retcode=100
	    q retcode
}

ClassMethod DeleteDHCANPara(itmjs As %Library.String = "", itm As %Library.String = "", ID As %String)
{
    &sql(Delete From sqluser.DHC_AN_Para Where ANP_RowId=:ID)
            set retcode=SQLCODE
     s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
 i itm'="""" s retval=retval_itm_"('"_$ZCVT(retcode,"O","JS")_"');"
 &javascript<#(retval)#>
    quit SQLCODE
}

ClassMethod GetDHCANParaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDHCANParaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDHCANParaExecute(ByRef qHandle As %Binary, opaId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	i opaId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	//w $d(^DHCANPara(ANPOPADr,"I")),!  //ypz begin
    s anpId=##Class(web.DHCANCom).GetAnpId(opaId)
    
	s AnRowID=$p(^DHCANPara(anpId),"^",1)
	s Name=""
	s ANPInterval=$p(^DHCANPara(anpId),"^",2)
	s rowid0=anpId
 	Do OutputRow5	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	set Data=$lb(AnRowID,ANPInterval,rowid0,Name)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDHCANParaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDHCANParaExecute ]
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

Query GetDHCANPara(ANPOPADr As %String) As %Query(ROWSPEC = "AnRowID:%String,ANPInterval:%String,rowid0:%String,Name:%String")
{
}

ClassMethod UpdateDHCANCPara(itmjs As %Library.String = "", itm As %Library.String = "", val As %String)
{
   ;ANPInterval ANPFixedItems
    set ANPInterval=$p(val,"^",1)
    set anpIbpFlag=$p(val,"^",2)
    set ID=$p(val,"^",3)
   //编译报错
   // &sql(Update sqluser.DHC_AN_Para set ANP_Interval=:ANPInterval,ANP_IBPFlag=:anpIbpFlag Where ANP_RowId=:ID)
    set retcode=SQLCODE
    s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
    i itm'="""" s retval=retval_itm_"('"_$ZCVT(retcode,"O","JS")_"');"
    &javascript<#(retval)#>
    quit SQLCODE
}

ClassMethod GetParaInfo(ID As %String) As %String
{
	;ANPInterval ANPFixedItems
	set ANPInterval=$p(^DHCANPara(ID),"^",2)
	set ANPFixedItems=$p(^DHCANPara(ID),"^",3)
    set Ret=ANPInterval_"^"_ANPFixedItems
    quit Ret
}

// 子表

ClassMethod AddDHCANParaItem(itmjs As %Library.String = "", itm As %Library.String = "", Str As %String)
{

 s retcode=..InsertDHCANParaItem(Str)
 s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
 i itm'="""" s retval=retval_itm_"('"_$ZCVT(retcode,"O","JS")_"');"
 &javascript<#(retval)#>
 q retcode
}

ClassMethod InsertDHCANParaItem(val As %String)
{
    
    s ANPIParref=$p(val,"^",1)
    s ancmdiId=$p(val,"^",2)
    s ancvscId=$p(val,"^",3)
    s ANPIArcimDr=$p(val,"^",4)
    s ANPIAnOrdDr=$p(val,"^",5)
    s ANPIFlag=$p(val,"^",6)
    s ANPISource=$p(val,"^",7)
    s ANPIIconDr=$p(val,"^",8)
 
    s ANPISeqNo=$p(val,"^",9)
    s ANPIColor=$p(val,"^",10)
    s ANPIScaleDr=$p(val,"^",11)
    s ancvcId=$p(val,"^",12)
    s ANPIUomDr=$p(val,"^",13)
    &sql(INSERT INTO sqluser.DHC_AN_ParaItem(ANPI_Parref,ANPI_Type,ANPI_ViewSuperCat_Dr,ANPI_Arcim_Dr,ANPI_AnOrd_Dr,ANPI_Flag,ANPI_Source,ANPI_Icon_Dr,ANPI_SeqNo,ANPI_Color,ANPI_Scale_Dr,ANPI_ViewCat_Dr,ANPI_Uom_Dr) Values (:ANPIParref,:ancmdiId,:ancvscId,:ANPIArcimDr,:ANPIAnOrdDr,:ANPIFlag,:ANPISource,:ANPIIconDr,:ANPISeqNo,:ANPIColor,:ANPIScaleDr,:ancvcId,:ANPIUomDr))
    i SQLCODE=0 d   s retcode=0
    e  s retcode=100
    q retcode
}

ClassMethod DeletetDHCANParaItem(itmjs As %Library.String = "", itm As %Library.String = "", ID As %String)
{
    &sql(Delete From sqluser.DHC_AN_ParaItem Where ANPI_RowId=:ID)
            s retcode=SQLCODE
     s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
 i itm'="""" s retval=retval_itm_"('"_$ZCVT(retcode,"O","JS")_"');"
 &javascript<#(retval)#>
    quit SQLCODE
}

Query GetDHCANParaItem(ANPIParref As %String) As %Query(ROWSPEC = "ancmdiDesc:%String,ANPIEventDr:%String,ANPIArcimDr:%String,ANPIAnOrdDr:%String,ANPIFlag:%String,ANPISource:%String,ANPIIconDr:%String,tAncViewCat:%String,tSeqNo:%String,rowid0:%String")
{
}

ClassMethod GetDHCANParaItemExecute(ByRef qHandle As %Binary, ANPIParref As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    i ANPIParref="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	i $g(ind)="" Set ind=1
	s rowid=0
	set ParRef=ANPIParref
	f  s rowid=$o(^DHCANPara(ParRef,"I",rowid)) q:rowid=""  d
        .;s ANPIParref=$p(^DHCANPara(ParRef,"I",rowid),"^",1)
        .s ancmdiId=$p(^DHCANPara(ParRef,"I",rowid),"^",1)
        .s ancmdiDesc=""
        .i ancmdiId'=""  d
        ..s ancmdiDesc=$p($g(^DHCANC("MDataItem",ancmdiId)),"^",2)
        .s ANPIEventDr=""
        .s ANPIEventDrID=$p(^DHCANPara(ParRef,"I",rowid),"^",2)
        .i ANPIEventDrID'=""  d 
        ..s ANPIEventDr=$p(^DHCANC("Event",ANPIEventDrID),"^",2)
        .s ANPIArcimDr=""
        .s ANPIArcimDrID=$p(^DHCANPara(ParRef,"I",rowid),"^",3)
        .i ANPIArcimDrID'=""  d
        ..s ID1=$p(ANPIArcimDrID,"||",1)
        ..s ID2=$p(ANPIArcimDrID,"||",2)
        ..//sjq,add $g here
        ..s ANPIArcimDr=$p($g(^ARCIM(ID1,ID2,1)),"^",2)
        .s ANPIAnOrdDr=$p(^DHCANPara(ParRef,"I",rowid),"^",4)
        .s ANPIFlagID=$p(^DHCANPara(ParRef,"I",rowid),"^",5)
        .s ANPIFlag=$SELECT(ANPIFlagID="D":"显示",ANPIFlagID="H":"隐藏",ANPIFlagID="U":"不采集",1:"")
        .s ANPISourceID=$p(^DHCANPara(ParRef,"I",rowid),"^",6)
        .s ANPISource=$SELECT(ANPISourceID="I":"自动采集",ANPISourceID="M":"手工录入",1:"")
        .s ANPIIconDr=""
        .s ANPIIconDrID=$p(^DHCANPara(ParRef,"I",rowid),"^",7)
        .i ANPIIconDrID'=""  d
        ..s ANPIIconDr=$p(^DHCANC("Icon",ANPIIconDrID),"^",2)
        .s tAncViewCat=""
        .s ancvcId=$p(^DHCANPara(ParRef,"I",rowid),"^",11)
        .i ancvcId'="" s tAncViewCat=$p(^DHCANC("ViewCat",ancvcId),"^",2)
        .s tSeqNo=$p(^DHCANPara(ParRef,"I",rowid),"^",8)
        .s rowid0=ParRef_"||"_rowid
 	.Do OutputRow5	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	set Data=$lb(ancmdiDesc,ANPIEventDr,ANPIArcimDr,ANPIAnOrdDr,ANPIFlag,ANPISource,ANPIIconDr,tAncViewCat,tSeqNo,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDHCANParaItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDHCANParaItemExecute ]
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

ClassMethod GetDHCANParaItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDHCANParaItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetOperMonitorDevClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperMonitorDevExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetOperMonitorDevExecute(ByRef qHandle As %Binary, OperID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	i $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCANC("MDataItem",rowid)) q:rowid=""  d
	.s devname=$p(^DHCANC("MDataItem",rowid),"^",2)
	.s rowid0=rowid
 	.Do OutputRow5	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	set Data=$lb(devname,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOperMonitorDevFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperMonitorDevExecute ]
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

Query GetOperMonitorDev(OperID As %String) As %Query(ROWSPEC = "Name:%String,ID:%String")
{
}

ClassMethod GetIconListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIconListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetIconListExecute(ByRef qHandle As %Binary, OperID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	i $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCANC("Icon",rowid)) q:rowid=""  d
	.s ICONname=$p(^DHCANC("Icon",rowid),"^",2)
	.s rowid0=rowid
 	.Do OutputRow5	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	set Data=$lb(ICONname,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetIconListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIconListExecute ]
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

Query GetIconList(OperID As %String) As %Query(ROWSPEC = "Name:%String,ID:%String")
{
}

ClassMethod GetEventListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEventListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetEventListExecute(ByRef qHandle As %Binary, OperID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	i $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCANC("Event",rowid)) q:rowid=""  d
	.s ICONname=$p(^DHCANC("Event",rowid),"^",2)
	.s rowid0=rowid
 	.Do OutputRow5	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	set Data=$lb(ICONname,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetEventListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEventListExecute ]
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

Query GetEventList(OperID As %String) As %Query(ROWSPEC = "Name:%String,ID:%String")
{
}

ClassMethod GetComOrdListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComOrdListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetComOrdListExecute(ByRef qHandle As %Binary, OperID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	i $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCANC("ComOrd",rowid)) q:rowid=""  d
	.s ICONname=$p(^DHCANC("ComOrd",rowid),"^",2)
	.s rowid0=rowid
 	.Do OutputRow5	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	set Data=$lb(ICONname,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetComOrdListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComOrdListExecute ]
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

ClassMethod UpdateDHCANParaItem(itmjs As %Library.String = "", itm As %Library.String = "", Val As %String)
{
    s anpiType=$p(Val,"^",1)  //!!to be change,js
    s ANPIEventDr="" //$p(Val,"^",2)
    s ANPIArcimDr=$p(Val,"^",3)
    s ANPIAnOrdDr=$p(Val,"^",4)
    s ANPIFlag=$p(Val,"^",5)
    s ANPISource=$p(Val,"^",6)
    s ANPIIconDr=$p(Val,"^",7)
    s ANPISeqNo=$p(Val,"^",8)
    s ANPIColor=$p(Val,"^",9)
    s ANPIScaleDr=$p(Val,"^",10)
    s ancvcId=$p(Val,"^",11)
    s ANPIUomDr=$p(Val,"^",12) 
    
    
    s ID=$p(Val,"^",13)

    &sql(Update sqluser.DHC_AN_ParaItem set ANPI_SeqNo=:ANPISeqNo,ANPI_Color=:ANPIColor,ANPI_Scale_Dr=:ANPIScaleDr,ANPI_ViewCat_Dr=:ancvcId,ANPI_Uom_Dr=:ANPIUomDr, ANPI_Type=:anpiType,ANPI_ViewSuperCat_Dr=:ANPIEventDr,ANPI_Arcim_Dr=:ANPIArcimDr,ANPI_AnOrd_Dr=:ANPIAnOrdDr,ANPI_Flag=:ANPIFlag,ANPI_Source=:ANPISource,ANPI_Icon_Dr=:ANPIIconDr   Where ANPI_Rowid=:ID)
    s retcode=SQLCODE
    s retval=itmjs_"('"_$ZCVT(retcode,"O","JS")_"');"
    i itm'="""" s retval=retval_itm_"('"_$ZCVT(retcode,"O","JS")_"');"
    &javascript<#(retval)#>
    quit SQLCODE
}

Query GetComOrdList(OperID As %String) As %Query(ROWSPEC = "Name:%String,ID:%String")
{
}

// s x=$SELECT(a=1:"Level1",a=2:"Level2",a=3:"Level3")

ClassMethod GetParaInfoItem(ID As %String) As %String
{
	s ParRef=$p(ID,"||",1)
	s ChiSub=$p(ID,"||",2)
	s TempRetVal=^DHCANPara(ParRef,"I",ChiSub)
	s ANPIAnOrdDr=$p(^DHCANPara(ParRef,"I",ChiSub),"^",4)
	s ANPIArcimDr=$p(^DHCANPara(ParRef,"I",ChiSub),"^",3)
	s ANPISourceID=$p(^DHCANPara(ParRef,"I",ChiSub),"^",6) 
	s ANPISource=$SELECT(ANPISourceID="I":"自动采集",ANPISourceID="M":"手工录入",1:"") 
	s ANPIFlagID=$p(^DHCANPara(ParRef,"I",ChiSub),"^",5) 
	s ANPIFlag=$SELECT(ANPIFlagID="D":"显示",ANPIFlagID="H":"隐藏",ANPIFlagID="U":"不采集",1:"")
	s ANPIEventDr=$p(^DHCANPara(ParRef,"I",ChiSub),"^",2) 
	s ANPIIconDr=$p(^DHCANPara(ParRef,"I",ChiSub),"^",7)
	s ancmdiId=$p(^DHCANPara(ParRef,"I",ChiSub),"^",1) 
	s ANPIAnOrdDrName=""
	i ANPIAnOrdDr'="" d 
	 .s ANPIAnOrdDrName=$p(^DHCANC("ComOrd",ANPIAnOrdDr),"^")
	e  d
	 .s ANPIAnOrdDrName=""
    s ANPIArcimDrName=""
	i ANPIArcimDr'=""  d 
	 .s ID1=$p(ANPIArcimDr,"||",1)
	 .s ID2=$p(ANPIArcimDr,"||",2)
	 .s ANPIArcimDrName=$p(^ARCIM(ID1,ID2,1),"^",2)
	e  d
	 .s ANPIArcimDrName=""
	s ANPIEventDrName=""
	i ANPIEventDr'=""  d
	  .s ANPIEventDrName=$p(^DHCANC("Event",ANPIEventDr),"^",2)
	e
	  .s ANPIEventDrName=""
	s ANPIIconDrName=""
	i ANPIIconDr'=""  d
	  .s ANPIIconDrName=$p(^DHCANC("Icon",ANPIIconDr),"^",2)
	e  d
	  .s ANPIIconDrName=""
	i ancmdiId'=""  d 
	  .s OpMonDrName=$p(^DHCANC("MDataItem",ancmdiId),"^",2)
	e  d
	  .s OpMonDrName=""
	s ANPISeqNo=$p(^DHCANPara(ParRef,"I",ChiSub),"^",8) 
	s ANPIColor=$p(^DHCANPara(ParRef,"I",ChiSub),"^",9) 
	s ANPIScaleDr=$p(^DHCANPara(ParRef,"I",ChiSub),"^",10)
	i ANPIScaleDr'="" d 
	  .s ANPIScaleDrName=$p(^DHCANC("Scale",ANPIScaleDr),"^",2)  
	e  d
	  .s ANPIScaleDrName=""
	s ancvcId=+$p(^DHCANPara(ParRef,"I",ChiSub),"^",11)
	s ancvcDesc=""
	i ancvcId'="" s ancvcDesc=$p(^DHCANC("ViewCat",ancvcId),"^",2)
	s ANPIUomDr=$p(^DHCANPara(ParRef,"I",ChiSub),"^",12) 
	s ANPIUomDrName=""
	i ANPIUomDr'=""  d
	  .s ANPIUomDrName=$p($g(^CT("UOM",ANPIUomDr)),"^",2)	
	e  d
	  .s ANPIUomDrName=""
	;ANPIEventDrName_"^"_
	s RetVal=ANPIAnOrdDr_"^"_ANPIArcimDr_"^"_ANPISource_"^"_ANPIFlag_"^"_ANPIEventDr_"^"_ANPIIconDr_"^"_ancmdiId_"^"_ANPIAnOrdDrName_"^"_ANPIArcimDrName_"^"_ANPIEventDrName_"^"_ANPIIconDrName_"^"_OpMonDrName_"^"_ANPISeqNo_"^"_ANPIColor_"^"_ANPIScaleDr_"^"_ANPIScaleDrName_"^"_ancvcId_"^"_ancvcDesc_"^"_ANPIUomDr_"^"_ANPIUomDrName_"^"_ANPIFlagID_"^"_ANPISourceID
	;s RetVal=ANPIAnOrdDr_"^"_ANPIArcimDr_"^"_ANPISource_"^"_ANPIFlag_"^"_ANPIEventDr_"^"_ANPIIconDr_"^"_ancmdiId_"^"_ANPIAnOrdDrName_"^"_ANPIArcimDrName_"^"_ANPIEventDrName_"^"_ANPIIconDrName_"^"_OpMonDrName_"^"_ANPISeqNo_"^"_ANPIColor_"^"_ANPIScaleDr_"^"_ANPIScaleDrName_"^"_ANPIContinueFlag_"^"_ANPIUomDr_"^"_ANPIUomDrName
	quit RetVal
}

ClassMethod GetFlagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFlagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetFlagExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	i $g(ind)="" Set ind=1
	s Str="D^H^U"
	s Str1="显示^隐藏^不采集"
	FOR index=1:1:5  {
	s OperStatus=$p(Str1,"^",index)
    s ID=$p(Str,"^",index)
 	Do OutputRow5
 	}	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	set Data=$lb(ID,OperStatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetFlagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFlagExecute ]
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

Query GetFlag() As %Query(ROWSPEC = "ID:%String,OperStatus:%String")
{
}

ClassMethod GetSrcClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSrcExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetSrcExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	i $g(ind)="" Set ind=1
	s Str="I^M"
	s Str1="自动采集^手工录入"
	FOR index=1:1:5  {
	s OperStatus=$p(Str1,"^",index)
    s ID=$p(Str,"^",index)
 	Do OutputRow5
 	}	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	set Data=$lb(ID,OperStatus)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSrcFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSrcExecute ]
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

Query GetSrc() As %Query(ROWSPEC = "ID:%String,OperStatus:%String")
{
}

ClassMethod GetUOMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUOMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetUOMExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	i $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^CT("UOM",rowid)) q:rowid=""  d
	.s UomName=$p(^CT("UOM",rowid),"^",2)
	.s rowid0=rowid
	.//i rowid0>813  d
 	.//.Do OutputRow5
 	.Do OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	set Data=$lb(UomName,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetUOMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUOMExecute ]
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

Query GetUOM() As %Query(ROWSPEC = "Name:%String,ID:%String")
{
}

ClassMethod GetScaleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScaleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetScaleExecute(ByRef qHandle As %Binary, OperID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    ;i type="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i type="I" s ssgroup=11
    ;i type="O" s ssgroup=7
 	i $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCANC("Scale",rowid)) q:rowid=""  d
	.s devname=$p(^DHCANC("Scale",rowid),"^",2)
	.s rowid0=rowid
 	.Do OutputRow5	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	set Data=$lb(devname,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetScaleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScaleExecute ]
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

Query GetScale(OperID As %String) As %Query(ROWSPEC = "Name:%String,ID:%String")
{
}

/// 取显示分类
Query GetAncViewCat() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ANCVC_RowId:%Integer,ANCVC_Code:%String,ANCVC_Desc:%String")
{
    select ANCVC_RowId,ANCVC_Code,ANCVC_Desc from sqluser.DHC_ANC_ViewCat
}

Query GetANPara(opaId As %String) As %SQLQuery(CONTAINID = 1)
{
	Select %ID As Id,
		   ANP_OPA_Dr As OpaId
		   From SQLUser.DHC_AN_Para
		   Where ANP_OPA_Dr=:opaId
}

Query GetANParaItem(paraId As %String) As %SQLQuery(CONTAINID = 1)
{
	Select %ID As Id,
		   ANPI_Parref As paraId,
		   ANPI_Type As ItemType,
		   ANPI_ViewSuperCat_Dr As RecordCategoryId,
		   ANPI_Arcim_Dr As ArcimId,
		   ANPI_AnOrd_Dr As RecordItemId,
		   ANPI_Flag As Flag,
		   ANPI_Source As Source,
		   ANPI_Icon_Dr As IconId,
		   ANPI_SeqNo As SeqNo,
		   ANPI_Color As Color,
		   ANPI_ViewCat_Dr As RecordSubCategoryId,
		   ANPI_Uom_Dr As UomId,
		   ANPI_DisplayName As DisplayName,
		   ANPI_TempType As TempType
		   From SQLUser.DHC_AN_ParaItem	
		   Where ANPI_Parref=:paraId
}

// 获取科室模板项目whl20140926

Query GetANDispalyParaItembak(paraId As %String) As %SQLQuery(CONTAINID = 1)
{
	
	
	
	Select %ID As Id,
		   ANPI_Parref As paraId,
		   ANPI_Type As ItemType,
		   ANPI_ViewSuperCat_Dr As RecordCategoryId,
		   ANPI_Arcim_Dr As ArcimId,
		   ANPI_AnOrd_Dr As RecordItemId,
		   ANPI_Flag As Flag,
		   ANPI_Source As Source,
		   ANPI_Icon_Dr As IconId,
		   ANPI_SeqNo As SeqNo,
		   ANPI_Color As Color,
		   ANPI_ViewCat_Dr As RecordSubCategoryId,
		   ANPI_Uom_Dr As UomId,
		   ANPI_DisplayName As DisplayName,
		   ANPI_TempType As TempType,
		   ANPI_Instr_Dr   As   InstrId,
		   ANPI_Concentration  As Concentration,
		   ANPI_ConcentrationUnit_Dr As ConcentrationUnitId,
		   ANPI_Speed As Speed,
		   ANPI_SpeedUnit_Dr As SpeedUnitId,
		   ANPI_Dose As Dose,
		   ANPI_DoseUom_Dr As DoseUomId
		   From SQLUser.DHC_AN_ParaItem	
		   Where ANPI_Parref=:paraId and ANPI_Type="D"  order by RecordSubCategoryId desc
}

// 获取科室模板项目whl20140926

/// d ##class(%ResultSet).RunQuery("web.DHCANPara","GetANDispalyParaItem",73,"D")
Query GetANDispalyParaItem(paraId As %String, ItemType As %String) As %SQLQuery(CONTAINID = 1)
{
	Select %ID As Id,
		   ANPI_Parref As paraId,
		   ANPI_Type As ItemType,
		   ANPI_ViewSuperCat_Dr As RecordCategoryId,
		   ANPI_Arcim_Dr As ArcimId,
		   ANPI_AnOrd_Dr As RecordItemId,
		   ANPI_Flag As Flag,
		   ANPI_Source As Source,
		   ANPI_Icon_Dr As IconId,
		   ANPI_SeqNo As SeqNo,
		   ANPI_Color As Color,
		   ANPI_ViewCat_Dr As RecordSubCategoryId,
		   ANPI_Uom_Dr As UomId,
		   ANPI_DisplayName As DisplayName,
		   ANPI_TempType As TempType,
		   ANPI_Instr_Dr   As   InstrId,
		   ANPI_Concentration  As Concentration,
		   ANPI_ConcentrationUnit_Dr As ConcentrationUnitId,
		   ANPI_Speed As Speed,
		   ANPI_SpeedUnit_Dr As SpeedUnitId,
		   ANPI_Dose As Dose,
		   ANPI_DoseUom_Dr As DoseUomId
		   From SQLUser.DHC_AN_ParaItem	
		    Where ANPI_Parref=:paraId order by RecordSubCategoryId desc
}

ClassMethod GetParaId(opaId As %String) As %String
{
	s paraId=$o(^DHCANPara(0,+opaId,""))
	
	;i paraId=""  d
	;.s para=##class(User.DHCANPara).%New()
	;.s para.ANPOPADr=##class(User.DHCANOPArrange).%OpenId(opaId)
	;.Do para.%Save()
	;.s paraId=para.%Id()
	
	q paraId
}

// 获取模板ID 如果存在返回值 如果没有创建20140925whl w ##class(web.DHCANPara).GetDispalyParaId("200","","mzk","麻醉科")20140926whl

ClassMethod GetDispalyParaId(locId As %String, UseId As %String, code As %String, desc As %String) As %String
{
	s paraId=""
	i locId'="" d 
	 .s paraId=..IfExistyLocParaId(locId,code,desc)
	 .i paraId="" s paraId=..InsertDHCANDisplayPara(locId,UseId,code,desc)
	i UseId'="" d 
	 .s paraId=..IfExistyUserParaId(UseId,code,desc)
	 .i paraId="" s paraId=..InsertDHCANDisplayPara(locId,UseId,code,desc)
	q paraId
}

// 获取模板存在否对应科室ID w ##class(web.DHCANPara).IfExistyLocParaId("200","code","5555")   20140926whl

ClassMethod IfExistyLocParaId(locId As %String, code As %String, desc As %String) As %String
{
	s paraId="",loc="",codedesc="",ret=""
	f  s loc=$o(^DHCANPara(0,"Ctloc",loc)) q:loc=""  d
	    .q:loc'=locId
        .f  s paraId=$o(^DHCANPara(0,"Ctloc",loc,paraId)) q:paraId=""  d
        ..s codedesc=$p(^DHCANPara(paraId),"^",5)
        ..q:desc'=codedesc
        ..s ret=paraId
	q ret
}

// 获取模板存在否对应科室ID w ##class(web.DHCANPara).IfExistyUserParaId("1111","code1","6666")   20140926whl

ClassMethod IfExistyUserParaId(UserId As %String, code As %String, desc As %String) As %String
{
	s paraId="",userid="",codedesc="",ret=""
	f  s userid=$o(^DHCANPara(0,"User",userid)) q:userid=""  d
	    .q:userid'=UserId
        .f  s paraId=$o(^DHCANPara(0,"User",userid,paraId)) q:paraId=""  d
        ..s codedesc=$p(^DHCANPara(paraId),"^",5)
        ..q:desc'=codedesc
        ..s ret=paraId
	q ret
}

ClassMethod GetParaItemIdByComOrdId(comOrdId As %String, opaId As %String) As %String
{
	// w ##class(web.DHCANPara).GetParaItemIdByComOrdId(1,10949)
	s paraId=$o(^DHCANPara(0,+opaId,""))
	q:(paraId="") "-1"
	s paraItemId="",result=""
	s ancvcId=+$p($g(^DHCANC("ComOrd",comOrdId)),"^",5)
	f  s paraItemId=$o(^DHCANPara(paraId,"I",paraItemId)) q:(paraItemId="")!(result'="")  d
	.s relateComOrdId=$p(^DHCANPara(paraId,"I",paraItemId),"^",4)
	.
	.q:(relateComOrdId'=comOrdId)
	.;b
	.s paraViewCat=$p($g(^DHCANPara(paraId,"I",paraItemId)),"^",11)
	.q:ancvcId'=paraViewCat ;常用医嘱显示分类与模板显示分类不一至，则退出
	.s result=paraId_"||"_paraItemId
	
	q result
}

// w ##class(web.DHCANPara).SaveParaItem(114,"D"_$c(3)_98_$c(3)_"11541||1"_$c(3)_37_$c(3,3)_"M"_$c(3)_0_$c(3)_9_$c(3)_"000000"_$c(3,3)_205_$c(3,3)_"顺式阿曲库铵"_$c(3,3)_"AN"_$c(3))

ClassMethod SaveParaItem(opaId As %String, paraString As %String) As %String
{
	q:(opaId="") "手术申请排班的ID不能为空"
	q:(paraString="") "需保存的数据不能为空"
	s paraId=..GetParaId(opaId)
	s paraItemId=$p(paraString,$c(3),14)
	s maxNum=$o(^DHCANPara(paraId,"I",""),-1)
	s num=$g(^DHCANPara(paraId,"I",0))
	i num<+maxNum d
	.s ^DHCANPara(paraId,"I",0)=+maxNum


	s paraItem=""
	i paraItemId="" d
	.s paraItem=##class(User.DHCANParaItem).%New(paraId)
	e  s paraItem=##class(User.DHCANParaItem).%OpenId(paraItemId)

	s paraItem.ANPIParref=##class(User.DHCANPara).%OpenId(paraId)
	s paraItem.ANPIType=$p(paraString,$c(3),1)
	s viewSuperCatId=$p(paraString,$c(3),2)
	i viewSuperCatId'="" s paraItem.ANPIViewSuperCatDr=##class(User.DHCANCViewSuperCat).%OpenId(viewSuperCatId)
	s paraItem.ANPIArcimDr=$p(paraString,$c(3),3)
	s commonOrdId=$p(paraString,$c(3),4)
	i commonOrdId'="" s paraItem.ANPIAnOrdDr=##class(User.DHCANCCommonOrd).%OpenId(commonOrdId)
	s paraItem.ANPIFlag=$p(paraString,$c(3),5)
	s paraItem.ANPISource=$p(paraString,$c(3),6)
	s iconId=$p(paraString,$c(3),7)
	i iconId'="" s paraItem.ANPIIconDr=##class(User.DHCANCIcon).%OpenId(iconId)
	s paraItem.ANPISeqNo=$p(paraString,$c(3),8)
	s paraItem.ANPIColor=$p(paraString,$c(3),9)
	s scaleId=$p(paraString,$c(3),10)
	i scaleId'="" s paraItem.ANPIScaleDr=##class(User.DHCANCScale).%OpenId(scaleId)
	s viewCatId=$p(paraString,$c(3),11)
	i viewCatId'="" s paraItem.ANPIViewCatDr=##class(User.DHCANCViewCat).%OpenId(viewCatId)
	s paraItem.ANPIUomDr=$p(paraString,$c(3),12)
	s paraItem.ANPIDisplayName=$p(paraString,$c(3),13)
	s paraItem.ANPITempType=$p(paraString,$c(3),15)
	Do paraItem.%Save()
	s result=paraItem.%Id()

	q result
}

ClassMethod DeleteParaItem(paraItemId As %String) As %String
{
	Do ##class(User.DHCANParaItem).%DeleteId(paraItemId)
	
	q "0"
}

ClassMethod GetParaNew(opaId As %String, ctlocId As %String = "") As %String
{
	Q:'$d(^DHCANOPArrange(opaId)) ""
	s result=""
	s type=""
	f  s type=$o(^DHCANC("Para",type)) q:type=""  d
	.q:(type'=(ctlocId_"AN"))&(type'=(ctlocId_"PACU"))&(type'=(ctlocId_"SE"))
	.s ret=##class(web.DHCANCom).GetParaSingle(opaId,ctlocId,$p(type,ctlocId,2))
	.i result="" s result=ret
	.e  s result=result_"^"_ret
	q result
}

ClassMethod SaveDisplayPara(ctlocId As %String, UserID As %String, Code As %String, Desc As %String) As %String
{
	q:(opaId="") "手术申请排班的ID不能为空"
	q:(paraString="") "需保存的数据不能为空"
	s paraId=..GetParaId(opaId)
	s paraItemId=$p(paraString,$c(3),14)
	s maxNum=$o(^DHCANPara(paraId,"I",""),-1)
	s num=$g(^DHCANPara(paraId,"I",0))
	i num<+maxNum d
	.s ^DHCANPara(paraId,"I",0)=+maxNum


	s paraItem=""
	i paraItemId="" d
	.s paraItem=##class(User.DHCANParaItem).%New(paraId)
	e  s paraItem=##class(User.DHCANParaItem).%OpenId(paraItemId)

	s paraItem.ANPIParref=##class(User.DHCANPara).%OpenId(paraId)
	s paraItem.ANPIType=$p(paraString,$c(3),1)
	s viewSuperCatId=$p(paraString,$c(3),2)
	i viewSuperCatId'="" s paraItem.ANPIViewSuperCatDr=##class(User.DHCANCViewSuperCat).%OpenId(viewSuperCatId)
	s paraItem.ANPIArcimDr=$p(paraString,$c(3),3)
	s commonOrdId=$p(paraString,$c(3),4)
	i commonOrdId'="" s paraItem.ANPIAnOrdDr=##class(User.DHCANCCommonOrd).%OpenId(commonOrdId)
	s paraItem.ANPIFlag=$p(paraString,$c(3),5)
	s paraItem.ANPISource=$p(paraString,$c(3),6)
	s iconId=$p(paraString,$c(3),7)
	i iconId'="" s paraItem.ANPIIconDr=##class(User.DHCANCIcon).%OpenId(iconId)
	s paraItem.ANPISeqNo=$p(paraString,$c(3),8)
	s paraItem.ANPIColor=$p(paraString,$c(3),9)
	s scaleId=$p(paraString,$c(3),10)
	i scaleId'="" s paraItem.ANPIScaleDr=##class(User.DHCANCScale).%OpenId(scaleId)
	s viewCatId=$p(paraString,$c(3),11)
	i viewCatId'="" s paraItem.ANPIViewCatDr=##class(User.DHCANCViewCat).%OpenId(viewCatId)
	s paraItem.ANPIUomDr=$p(paraString,$c(3),12)
	s paraItem.ANPIDisplayName=$p(paraString,$c(3),13)
	s paraItem.ANPITempType=$p(paraString,$c(3),15)
	Do paraItem.%Save()
	s result=paraItem.%Id()

	q result
}

// 保存科室和个人模板w ##class(web.DHCANPara).SaveDisplayParaItem(168,"SaveDisplayParaItem")

/*
ClassMethod SaveDisplayParaItem(paraId As %String, paraStringList As %String) As %String
{
    b ;"1111"
    s ^TEMPWHL("SaveDisplayParaItem",paraId)=paraString
    s paraString=""
    s num=$l(paraStringList,"^")
    f i=1:1:num d
    .s paraString=$p(paraStringList,"^",i)
	.q:(paraString="") ; "需保存的数据不能为空"
	.s paraItemId=$p(paraString,$c(3),14)
	.s maxNum=$o(^DHCANPara(paraId,"I",""),-1)
	.s num=$g(^DHCANPara(paraId,"I",0))
	.i num<+maxNum d
	..s ^DHCANPara(paraId,"I",0)=+maxNum


	.s paraItem=""
	.i paraItemId="" d
	..s paraItem=##class(User.DHCANParaItem).%New(paraId)
	.e  s paraItem=##class(User.DHCANParaItem).%OpenId(paraItemId)

	.s paraItem.ANPIParref=##class(User.DHCANPara).%OpenId(paraId)
	
	.s paraItem.ANPIType=$p(paraString,$c(3),1)
	;s paraItem.ANPIViewSuperCatDr=$p(paraString,$c(3),2)
	.s viewSuperCatId=$p(paraString,$c(3),2)
	.i viewSuperCatId'="" s paraItem.ANPIViewSuperCatDr=##class(User.DHCANCViewSuperCat).%OpenId(viewSuperCatId)
	.s paraItem.ANPIArcimDr=$p(paraString,$c(3),3)
	;s paraItem.ANPIAnOrdDr=$p(paraString,$c(3),4)
	.s commonOrdId=$p(paraString,$c(3),4)
	.i commonOrdId'="" s paraItem.ANPIAnOrdDr=##class(User.DHCANCCommonOrd).%OpenId(commonOrdId)
	.s paraItem.ANPIFlag=$p(paraString,$c(3),5)
	.s paraItem.ANPISource=$p(paraString,$c(3),6)
	;s paraItem.ANPIIconDr=$p(paraString,$c(3),7)
	.s iconId=$p(paraString,$c(3),7)
	.i iconId'="" s paraItem.ANPIIconDr=##class(User.DHCANCIcon).%OpenId(iconId)
	.s paraItem.ANPIColor=$p(paraString,$c(3),8)
	;s paraItem.ANPIScaleDr=$p(paraString,$c(3),9)
	.s scaleId=$p(paraString,$c(3),9)
	.i scaleId'="" s paraItem.ANPIScaleDr=##class(User.DHCANCScale).%OpenId(scaleId)
	;s paraItem.ANPIViewCatDr=$p(paraString,$c(3),10)
	.s viewCatId=$p(paraString,$c(3),10)
	.i viewCatId'="" s paraItem.ANPIViewCatDr=##class(User.DHCANCViewCat).%OpenId(viewCatId)
	.;s paraItem.ANPIUomDr=$p(paraString,$c(3),11)
	.s paraItem.ANPIDisplayName=$p(paraString,$c(3),12)
	.s paraItem.ANPITempType=$p(paraString,$c(3),13)
	.s paraItem.ANPIInstrDr=$p(paraString,$c(3),14)
	.s paraItem.ANPIConcentration=$p(paraString,$c(3),15)
	.s paraItem.ANPIConcentrationUnitDr=$p(paraString,$c(3),16)
	.s paraItem.ANPISpeed=$p(paraString,$c(3),17)
	.s paraItem.ANPISpeedUnitDr=$p(paraString,$c(3),18)
	.s paraItem.ANPIDose="" ;$p(paraString,$c(3),19)
	.s paraItem.ANPIDoseUomDr="1" ;$p(paraString,$c(3),20)
	.s paraItem.ANPIType=$p(paraString,$c(3),20)
	
	.Do paraItem.%Save()
	.s result=paraItem.%Id()
	q result
}*/
ClassMethod GetParaSingle(opaId As %String, ctlocId As %String = "", Type As %String = "") As %String
{
	//少了两列
	//q:(+opaId=0) 0
	q:'$d(^DHCANOPArrange(opaId)) ""
	s i=0,resStr="",tmpStr=""
	i (+opaId=0) s anpId="Default"
	e  s anpId=..GetAnpIdNew(opaId,ctlocId,Type)
	
	s anpiSub=0
	f  s anpiSub=$o(^DHCANPara(anpId,"I",anpiSub)) q:anpiSub=""  d
	    .s anpiStr=^DHCANPara(anpId,"I",anpiSub)
	    .//w anpiStr,!
	    .i "DHU"'[$p(anpiStr,"^",5) s $p(anpiStr,"^",5)="D"
	    .i "IM"'[$p(anpiStr,"^",6) s $p(anpiStr,"^",6)="M"
	    .s $p(anpiStr,"^",13)=$p(anpiStr,"^",13) //$p($g(^DHCANC("VPSite",+$p(anpiStr,"^",13))),"^",2)
	    .s anpiStr=$tr(anpiStr,"^","!")
	    .//s tmpStr=$p($g(^DHCANC("MDataItem",+anpiStr)),"^",2) //$p($g(^ORC("OPMON",+anpiStr)),"^",2)
	    .//s tmpStr=tmpStr_"!"_$p($g(^DHCANC("Event",+$p(anpiStr,"!",2))),"^",2)
	    .s tmpOrder=$p($g(^DHCANC("ComOrd",+$p(anpiStr,"!",4))),"^",2)
	    .i tmpOrder="" d
	    ..s tmpOrder=$p($g(^ARCIM(+$p(anpiStr,"!",3),1,1)),"^",2)
	    .//s tmpStr=tmpStr_"!"_tmpOrder
	    .s $p(anpiStr,"!",10)=$p(anpiStr,"!",10)_"!"_$p($g(^DHCANC("Scale",+$p(anpiStr,"!",10))),"^",3)_"!"_$p($g(^DHCANC("Scale",+$p(anpiStr,"!",10))),"^",5)
	    .
	    .//s $p(resStr,"^",$p(anpiStr,"!",8))=anpId_"||"_anpiSub_"!"_tmpOrder_"!"_anpiStr
	    .s TmpList(+(anpiSub_"."_$p(anpiStr,"!",8)))=anpId_"||"_anpiSub_"!"_tmpOrder_"!"_anpiStr
	s tmpSeq=""
	f  s tmpSeq=$o(TmpList(tmpSeq)) q:tmpSeq=""  d
		.i resStr="" s resStr=resStr_"^"
		.s resStr=resStr_"^"_TmpList(tmpSeq)
	q resStr
}

ClassMethod GetAnpIdNew(opaId, ctlocId, Type = "AN")
{
	q:(+opaId=0) 0
	s anpId=$o(^DHCANPara(0,opaId,""))
	s ctlocIdDocType=ctlocId_Type
	i ctlocIdDocType="" s ctlocIdDocType="Default"
	
	i anpId="" d
	.s ^DHCANPara(0)=$g(^DHCANPara(0))+1
	.s ^DHCANPara(0,opaId,^DHCANPara(0))=""
	.i $d(^DHCANC("Para",ctlocIdDocType))<1 m ^DHCANC("Para",ctlocIdDocType)=^DHCANC("Para","Default")
	
	.s anaId=$p($g(^DHCANOPArrange(opaId)),"^",2) //OPA_Anaest_dr
	.q:anaId=""
	.s EpisodeID=+anaId
	.s anaSub=$p(anaId,"||",2)

	.s anMethodId=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)			//ANA_Method
	.s anMethodCode=$P($g(^ORC("ANMET",+anMethodId)),"^",1)		//取第一个
	.i $d(^DHCANC("Para",ctlocIdDocType_"."_anMethodCode))>0 s ctlocIdDocType=ctlocIdDocType_"."_anMethodCode
	.m ^DHCANPara(^DHCANPara(0))=^DHCANC("Para",ctlocIdDocType)
	.s $p(^DHCANPara(^DHCANPara(0)),"^",1)=opaId  //ypz end
	.s anpId=^DHCANPara(0)
	.s num=^DHCANPara(anpId,"I",0)
	.f k=1:1:num d
	..s $p(^DHCANPara(anpId,"I",k),"^",15)=Type
	e  d
	.s num=^DHCANPara(anpId,"I",0)
	.s count=^DHCANC("Para",ctlocIdDocType,"I",0)
	.i count>0 d
	..f i=1:1:count d
	...s ^DHCANPara(^DHCANPara(0),"I",num+i)=^DHCANC("Para",ctlocIdDocType,"I",i)
	...s $p(^DHCANPara(anpId,"I",num+i),"^",15)=Type
	q anpId
}

// 插入科室模板

// w ##class(web.DHCANPara).InsertDHCANDisplayPara(200,1111,"code","麻醉科科室模板")

ClassMethod InsertDHCANDisplayPara(ctloc As %String, userid As %String, code As %String, desc As %String)
{
	//编译报错
    &sql(INSERT INTO sqluser.DHC_AN_Para(ANP_Ctloc_Dr,ANP_User_Dr,ANP_Code,ANP_Desc) Values (:ctloc,:userid,:code,:desc))
    i SQLCODE=0 d   s retcode=0
	    e  s retcode=100
	q %ROWID
}

// 更新科室模板

// w ##class(web.DHCANPara).UpdateDHCANDisplayPara(200,1111,"code","麻醉科科室模板")

ClassMethod UpdateDHCANDisplayPara(ID As %String, ctloc As %String, userid As %String, code As %String, desc As %String)
{
	//编译报错
    &sql(Update sqluser.DHC_AN_Para set ANP_Ctloc_Dr=:ctloc,ANP_User_Dr=:userid,ANP_Code=:code,ANP_Desc=:desc Where ANP_RowId=:ID)
    	    i SQLCODE=0 d   s retcode=0
	    e  s retcode=100
	   q ID
}

// 获取科室模板ID

// w ##class(web.DHCANPara).GetDisplayParaList("364","")

ClassMethod GetDisplayParaList(CTloc As %String, userid As %String) As %String
{
 s DisplayParaList="",userId="",ctloc=""
 s paraid=""
 f  s ctloc=$o(^DHCANPara(0,"Ctloc",ctloc)) q:ctloc=""  d
    .f  s paraid=$o(^DHCANPara(0,"Ctloc",CTloc,paraid)) q:paraid=""  d
    ..s ctloc=$p(^DHCANPara(paraid),"^",2)
    ..s UserId=$p(^DHCANPara(paraid),"^",3)
    ..s code=$p(^DHCANPara(paraid),"^",4)
    ..s Desc=$p(^DHCANPara(paraid),"^",5)
    ..s DisplayParaList=DisplayParaList_"^"_paraid_$c(3)_ctloc_$c(3)_UserId_$c(3)_code_$c(3)_Desc
 
 f  s userId=$o(^DHCANPara(0,"User",userId)) q:userId=""  d
    .f  s paraid=$o(^DHCANPara(0,"User",userId,paraid)) q:paraid=""  d
    ..s ctloc=$p(^DHCANPara(paraid),"^",2)
    ..s UserId=$p(^DHCANPara(paraid),"^",3)
    ..s code=$p(^DHCANPara(paraid),"^",4)
    ..s Desc=$p(^DHCANPara(paraid),"^",5)
    ..s DisplayParaList=DisplayParaList_"^"_paraid_$c(3)_ctloc_$c(3)_UserId_$c(3)_code_$c(3)_Desc
 q DisplayParaList
}

/// d ##class(%ResultSet).RunQuery("web.DHCANPara","GetDisplayParaList")
Query GetDisplayParaList() As %SQLQuery(CONTAINID = 1)
{
Select %ID As Id,
   ANP_OPA_Dr As opaId,
   ANP_Ctloc_Dr As Ctloc,
   ANP_User_Dr As UserId,
   ANP_Code As Code,
   ANP_Desc As Descs,
   ANP_EditFlag As EditFlag
   From SQLUser.DHC_AN_Para	
   where ANP_OPA_Dr is null and ANP_EditFlag is null
}

/// w ##class(web.DHCANPara).SaveSingleDisplayParaItem(69,"V^212^^^^M^0^0^^0^^^失血量(ml)^A^^0^^0^0^10^^")
/// w ##class(web.DHCANPara).SaveSingleDisplayParaItem(69,"D^201^^23^N^M^^0^^^^^咪达唑仑^A^^0^^0^^0^^")
ClassMethod SaveSingleDisplayParaItem(paraId As %String, paraString As %String) As %String
{
	/*s paraItem="",paraItemId=""
	i paraItemId="" d
	.s paraItem=##class(User.DHCANParaItem).%New(paraId)
	e  s paraItem=##class(User.DHCANParaItem).%OpenId(paraItemId)
	s paraItem.ANPIParref=##class(User.DHCANPara).%OpenId(paraId)*/	
	s ANPIParref=paraId
	s ANPIRowId=""
	s ANPIChildSub=""
	s ANPIType=$p(paraString,"^",1)
	s ANPIViewSuperCatDr=$p(paraString,"^",2)
	s ANPIArcimDr=$p(paraString,"^",3)
	s ANPIAnOrdDr=$p(paraString,"^",4)
	s ANPIFlag=$p(paraString,"^",5)
	s ANPISource=$p(paraString,"^",6)
	s ANPIIconDr=$p(paraString,$c(3),7)
	s ANPISeqNo=$p(paraString,"^",8)
	s ANPIColor=$p(paraString,"^",9)
	s ANPIScaleDr=$p(paraString,"^",10)
	s ANPIViewCatDr=$p(paraString,"^",11)
	s ANPIUomDr=$p(paraString,"^",12)
	s ANPIDisplayName=$p(paraString,"^",13)
	s ANPITempType=$p(paraString,"^",14)
	s ANPIInstrDr=$p(paraString,"^",15)
	s ANPIConcentration=$p(paraString,"^",16)
	s ANPIConcentrationUnitDr=$p(paraString,"^",17)
	s ANPISpeed=$p(paraString,"^",18)
	s ANPISpeedUnitDr=$p(paraString,"^",19)
	s ANPIDose=$p(paraString,"^",20)
	s ANPIDoseUomDr=$p(paraString,"^",21)
	b
	&sql(INSERT INTO sqluser.DHC_AN_ParaItem(ANPI_Parref,ANPI_Type,ANPI_ViewSuperCat_Dr,ANPI_Arcim_Dr,ANPI_AnOrd_Dr,ANPI_Flag,ANPI_Source,ANPI_Icon_Dr,ANPI_SeqNo,ANPI_Color,ANPI_Scale_Dr,ANPI_ViewCat_Dr,ANPI_Uom_Dr,ANPI_DisplayName,ANPI_TempType,ANPI_Instr_Dr,ANPI_Concentration,ANPI_ConcentrationUnit_Dr,ANPI_Speed,ANPI_SpeedUnit_Dr,ANPI_Dose,ANPI_DoseUom_Dr
) Values (:ANPIParref,:ANPIType,:ANPIViewSuperCatDr,:ANPIArcimDr,:ANPIAnOrdDr,:ANPIFlag,:ANPISource,:ANPIIconDr,:ANPISeqNo,:ANPIColor,:ANPIScaleDr,:ANPIViewCatDr,:ANPIUomDr,:ANPIDisplayName,:ANPITempType,:ANPIInstrDr,:ANPIConcentration,:ANPIConcentrationUnitDr,:ANPISpeed,:ANPISpeedUnitDr,:ANPIDose,:ANPIDoseUomDr))
    i SQLCODE=0 d   s retcode=0
    e  s retcode=100
    q retcode
}

/// d ##class(web.DHCANPara).ModifySingleDisplayParaItem(56,"V^212^^^^M^0^0^^0^^^失血量(ml)^A^^0^^0^0^10^^")
ClassMethod ModifySingleDisplayParaItem(paraId As %String, paraString As %String) As %String
{
	s ANPIParref=paraId
	s ANPIRowId=""
	s ANPIChildSub=""
	s ANPIType=$p(paraString,"^",1)
	s ANPIViewSuperCatDr=$p(paraString,"^",2)
	s ANPIArcimDr=$p(paraString,"^",3)
	s ANPIAnOrdDr=$p(paraString,"^",4)
	s ANPIFlag=$p(paraString,"^",5)
	s ANPISource=$p(paraString,"^",6)
	s ANPIIconDr=$p(paraString,$c(3),7)
	s ANPISeqNo=$p(paraString,"^",8)
	s ANPIColor=$p(paraString,"^",9)
	s ANPIScaleDr=$p(paraString,"^",10)
	s ANPIViewCatDr=$p(paraString,"^",11)
	s ANPIUomDr=$p(paraString,"^",12)
	s ANPIDisplayName=$p(paraString,"^",13)
	s ANPITempType=$p(paraString,"^",14)
	s ANPIInstrDr=$p(paraString,"^",15)
	s ANPIConcentration=$p(paraString,"^",16)
	s ANPIConcentrationUnitDr=$p(paraString,"^",17)
	s ANPISpeed=$p(paraString,"^",18)
	s ANPISpeedUnitDr=$p(paraString,"^",19)
	s ANPIDose=$p(paraString,"^",20)
	s ANPIDoseUomDr=$p(paraString,"^",21)
	s ANPIRowId=$p(paraString,"^",22)
	&sql(update sqluser.DHC_AN_ParaItem(ANPI_Type,ANPI_ViewSuperCat_Dr,ANPI_Arcim_Dr,ANPI_AnOrd_Dr,ANPI_Flag,ANPI_Source,ANPI_Icon_Dr,ANPI_SeqNo,ANPI_Color,ANPI_Scale_Dr,ANPI_ViewCat_Dr,ANPI_Uom_Dr,ANPI_DisplayName,ANPI_TempType,ANPI_Instr_Dr,ANPI_Concentration,ANPI_ConcentrationUnit_Dr,ANPI_Speed,ANPI_SpeedUnit_Dr,ANPI_Dose,ANPI_DoseUom_Dr
	) Values(:ANPIType,:ANPIViewSuperCatDr,:ANPIArcimDr,:ANPIAnOrdDr,:ANPIFlag,:ANPISource,:ANPIIconDr,:ANPISeqNo,:ANPIColor,:ANPIScaleDr,:ANPIViewCatDr,:ANPIUomDr,:ANPIDisplayName,:ANPITempType,:ANPIInstrDr,:ANPIConcentration,:ANPIConcentrationUnitDr,:ANPISpeed,:ANPISpeedUnitDr,:ANPIDose,:ANPIDoseUomDr) where ANPI_RowId=:ANPIRowId)
	i SQLCODE=0 d   s retcode=0
    e  s retcode=100
    q retcode
}

/// Creator: YuanLin
/// CreatDate: 2017-09-26
/// Description: 将科室模板置标记达到删除效果
/// Table：DHC_AN_Para
/// Input：模板Id
/// Output：0成功,100失败
/// d ##class(web.DHCANPara).DeleteDispalyPara()
ClassMethod DeleteDispalyPara(paraId As %String) As %String
{
	q:paraId="" ""
	s SQLCODE=""
	s retcode=0
	&sql(update sqluser.DHC_AN_Para set ANP_EditFlag="D" where ANP_RowId=:paraId)
	i SQLCODE=0 d   s retcode=0 
	e  s retcode=100
    q retcode
}

/// Creator: YuanLin
/// CreatDate: 2017-09-26
/// Description: 修改科室模板名称
/// Table：DHC_AN_Para
/// Input：模板Id,模板code,模板code
/// Output：0成功,100失败
/// d ##class(web.DHCANPara).ModifyDispalyParaDesc(7,"11","22")
ClassMethod ModifyDispalyParaDesc(paraId As %String, code As %String, desc As %String) As %String
{
	q:paraId="" 100
	q:code="" 100
	q:desc="" 100
	s ret=100
	i $d(^DHCANPara(paraId)) d
    .s $p(^DHCANPara(paraId),"^",4)=code
    .s $p(^DHCANPara(paraId),"^",5)=desc
    .s ret=0
    q ret
}

}
