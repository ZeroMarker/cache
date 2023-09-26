Import SQLUser

Class web.DHCOPDocLocAuthorize Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 科室相应医生
/// d ##class(%ResultSet).RunQuery("web.DHCDocDoOper","FindCtcp","","","")
/// 20180313+dyl
Query FindCtcp(OpDeptId As %String = "", name As %String = "", WorkNo As %String = "", OperId As %String = "") As %Query(ROWSPEC = "ctlocId,ctlocDesc,ctcpId,ctcpDesc,ctcpWorkNo,dayAuth")
{
}

ClassMethod FindCtcpExecute(ByRef qHandle As %Binary, OpDeptId As %String = "", name As %String = "", WorkNo As %String = "", OperId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s ctlocIdList=""
    i OpDeptId'="" d
        .i OpDeptId=+OpDeptId s ctlocIdList=OpDeptId
        .e  d
            ..s locDesc=$$ALPHAUP^SSUTIL4(OpDeptId)
            ..s ctlocIdList=$o(^CTLOC(0,"Desc",locDesc,""))
    i (name="")&&(WorkNo="") d
    .f i=1:1:$l(ctlocIdList) d
        ..s ctlocId=$p(ctlocIdList,"^",i)
        ..q:ctlocId=""
        ..s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
        ..s ctlocDesc=$p(ctlocDesc,"-",2)
        ..s resId=""
        ..f  s resId=$O(^RB("RES",0,"CTLOC",ctlocId,resId))  q:resId=""  d
           ...s ctcpId=$P(^RB("RES",resId),"^",2)
            ...q:ctcpId=""
            ...s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
            ...q:ctcptId=""
            ...s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",4)
            ...q:ctcptType'="DOCTOR"
            ...s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpId)
            ...s ctcpAlias=$p($g(^CTPCP(ctcpId,3)),"^",28)
            ...s ctcpWorkNo=..GetWorkNoById(ctcpId)
            ...q:(WorkNo'="")&(ctcpWorkNo'=WorkNo)
            ...s dayAuth=$g(^DHCANOPDaySurgeryAut(ctcpId))
            ...d Outputcpt
    e  d 
      .s ctcpId="" f  s ctcpId=$o(^CTPCP(ctcpId)) q:ctcpId=""  d
          ..s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpId)
          ..s ctcpAlias=$p($g(^CTPCP(ctcpId,3)),"^",28)
          ..s ctlocId=$o(^RB("RES",0,"CTPCP",ctcpId,""))
          ..s ctcpWorkNo=..GetWorkNoById(ctcpId)
          ..q:ctlocId=""
          ..q:(WorkNo'="")&(ctcpWorkNo'=WorkNo)
          ..q:((ctcpDesc'[name)&(name'=""))||((ctcpWorkNo'=WorkNo)&(WorkNo'=""))
          ..s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
          ..s ctlocDesc=$p(ctlocDesc,"-",2)
          ..s dayAuth=$g(^DHCANOPDaySurgeryAut(ctcpId))
          ..d Outputcpt
    
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

Outputcpt
 set Data=$lb(ctlocId,ctlocDesc,ctcpId,ctcpDesc,ctcpWorkNo,dayAuth)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindCtcpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCtcpExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
    //
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {                // fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindCtcpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCtcpExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

// 总共多少科室

Query ctloclookup(desc As %String) As %Query(ROWSPEC = "OpDeptId:%String,OpDept:%String")
{
}

ClassMethod ctloclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctloclookupExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod ctloclookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    ;s rowid=0
    i $g(desc)'="" s desc=$$ALPHAUP^SSUTIL4(desc)
    s len=$l(desc)
    s ctlocrowid="" f  s ctlocrowid=$o(^CTLOC(ctlocrowid)) q:ctlocrowid=""  d
        .q:'$d(^CTLOC(ctlocrowid))
        .s ctlocdesc=$p(^CTLOC(ctlocrowid),"^",2)
        .s desc1=$$ALPHAUP^SSUTIL4(ctlocdesc)
        .s desc1=$e(desc1,1,len)
        .q:desc1'=desc 
        .Do OutputRow4
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
OutputRow4
    set Data=$lb(ctlocrowid,ctlocdesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod ctloclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctloclookupExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 2014+05+dyl+科室关联手术
/// w ##class(web.DylTongRenTest).GetOpByLocId(6)
/// d ##class(%ResultSet).RunQuery("web.DHCDocDoOper","GetOpByFenJi")
/// 根据手术分类查找手术
Query GetOpByCat(opercat As %String = "") As %Query(ROWSPEC = "OperId:%String,OperCode:%String,OperDesc:%String")
{
}

ClassMethod GetOpByCatExecute(ByRef qHandle As %Binary, opercat As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    q:opercat=""
    s OperId=""
    f  s OperId=$o(^ORC("OPER",OperId)) q:OperId=""  d
      .q:$d(^ORC("OPER",OperId))<1
      .s topercat=$p($g(^ORC("OPER",OperId)),"^",7)
      .q:(topercat'[opercat)&(opercat'="")
      .s OperCode=$p($g(^ORC("OPER",OperId)),"^",1)
      .s OperDesc=$p($g(^ORC("OPER",OperId)),"^",2)
      .s OperDesc=$$ALPHAUP^SSUTIL4(OperDesc)
      .d OutputRowFenJi     
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
OutputRowFenJi
    set Data=$lb(OperId,OperCode,OperDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetOpByCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpByCatExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetOpByCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpByCatExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindOrcDocOper(OpDocId As %String = "") As %Query(ROWSPEC = "tOperId,tOperDesc,tOperLevel,tOperCat,tRowId,tDayOper")
{
}

/// d ##class(%ResultSet).RunQuery("web.DylTongRenTest","FindOrcDocOper","64")
/// d ##class(%ResultSet).RunQuery("web.DHCOPDocLocAuthorize","FindOrcDocOper","688")
/// d ##class(%ResultSet).RunQuery("web.DHCDocDoOper","FindOrcDocOper","64")
/// 获取医生相应手术
ClassMethod FindOrcDocOperExecute(ByRef qHandle As %Binary, OpDocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s tOperId=0,i=0
    i OpDocId="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
    e  d
        .s operDr=0 f  s operDr=$o(^DHCANOPDocOper("DocOper",0,"CtcpOper",OpDocId,operDr)) q:operDr=""  d
            ..s rowid=$o(^DHCANOPDocOper("DocOper",0,"CtcpOper",OpDocId,operDr,""),-1)
            ..
            ..s operDesc=$p(^ORC("OPER",operDr),"^",2)
            ..s tOperLevel=""
            ..s tOperLevelId=$p(^ORC("OPER",operDr),"^",7)
            ..i tOperLevelId>0 s tOperLevel=$p($g(^ORC("CATEG",tOperLevelId)),"^",2)
            ..s operCat=""
            ..s operCatDr=$p($g(^ORC("OPER",operDr,"DHC")),"^",16)
            ..s operCat=""
            ..;i operCatDr'="" s operCat=$li($g(^DHCANC("OperationCat",operCatDr)),2)
            ..s dayOper=$p(^ORC("OPER",operDr),"^",9)
            ..d OutRowD
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutRowD
    set Data=$lb(operDr,operDesc,tOperLevel,operCat,rowid,dayOper)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindOrcDocOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrcDocOperExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindOrcDocOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrcDocOperExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPDocLocAuthorize","FindOperation","","2","")
Query FindOperation(operDescAlias As %String = "", operCat As %String = "", isDayOper As %String = "") As %Query(ROWSPEC = "OPTypeDes:%String,rowid:%String")
{
}

ClassMethod FindOperationExecute(ByRef qHandle As %Binary, operDescAlias As %String = "", operCat As %String = "", isDayOper As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s find=0
    i operDescAlias'="" d
	    .s operDescAlias=$$ALPHAUP^SSUTIL4(operDescAlias) 
	    .s OpDes=""  
	    .f  s OpDes=$o(^ORC("OPER",0,"ALIAS",OpDes)) q:OpDes=""  d
		    ..i OpDes[operDescAlias d
			    ...s rowid=$o(^ORC("OPER",0,"ALIAS",OpDes,0))
			    ...s OPTypeDes=$p($g(^ORC("OPER",rowid)),"^",2)
			    ...s dayFlag=$p($g(^ORC("OPER",rowid)),"^",9)
			    ...q:(isDayOper'="")&(dayFlag'=isDayOper)
			    ...s find=1
			    ...d OutputRow0829
	    .q:find=1
	    .s OpDes=""
		.f  s OpDes=$o(^ORC("OPER",0,"Desc",OpDes)) q:OpDes=""  d
			    ..i OpDes[operDescAlias d
			    ...s rowid=$o(^ORC("OPER",0,"Desc",OpDes,0))
			    ...s OPTypeDes=$p($g(^ORC("OPER",rowid)),"^",2)
			    ...s dayFlag=$p($g(^ORC("OPER",rowid)),"^",9)
			    ...q:(isDayOper'="")&(dayFlag'=isDayOper)
			    ...s find=1
			    ...d OutputRow0829
    e  i operCat'=""  d
    .s OperId=""
    .f  s OperId=$o(^ORC("OPER",OperId)) q:OperId=""  d
      ..q:$d(^ORC("OPER",OperId))<1
      ..s rowid=OperId
      ..s topercat=$p($g(^ORC("OPER",rowid)),"^",7)
      ..q:(topercat'[operCat)&(operCat'="")
      ..s OperCode=$p($g(^ORC("OPER",OperId)),"^",1)
      ..s OPTypeDes=$p($g(^ORC("OPER",OperId)),"^",2)
      ..s OPTypeDes=$$ALPHAUP^SSUTIL4(OPTypeDes)
      ..s dayFlag=$p($g(^ORC("OPER",OperId)),"^",9)
	  ..q:(isDayOper'="")&(dayFlag'=isDayOper)
	  ..s find=1
      ..d OutputRow0829
	e  d
	    .s OperId=""
	    .f  s OperId=$o(^ORC("OPER",OperId)) q:OperId=""  d
	      ..q:$d(^ORC("OPER",OperId))<1
	      ..s rowid=OperId
	      ..s topercat=$p($g(^ORC("OPER",rowid)),"^",7)
	      ..s OperCode=$p($g(^ORC("OPER",OperId)),"^",1)
	      ..s OPTypeDes=$p($g(^ORC("OPER",OperId)),"^",2)
	      ..s OPTypeDes=$$ALPHAUP^SSUTIL4(OPTypeDes)
	      ..s dayFlag=$p($g(^ORC("OPER",OperId)),"^",9)
		  ..q:(isDayOper'="")&(dayFlag'=isDayOper)
		  ..s find=1
	      ..d OutputRow0829
	
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow0829
    set Data=$lb(OPTypeDes,rowid)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetWorkNoById(userId As %String) As %String
{
 q:userId="" "用户有误!"
 s asdocNo=$tr($p($g(^CTPCP(+userId,1)),"^",1)," ","")            ;一助工号
 i asdocNo'="" q asdocNo
 i asdocNo=""  q "工号不存在!"
}

/// 查询手术相关医生
/// d ##class(%ResultSet).RunQuery("web.DHCDocDoOper","FindOperCtcp","")
Query FindOperCtcp(operDr As %String) As %Query(ROWSPEC = "tRowId:%String,CtcpDesc:%String,CtcpId:%String,OperDr:%String")
{
}

ClassMethod FindOperCtcpExecute(ByRef qHandle As %Binary, operDr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	 s ind=1
	If $g(ind)="" Set ind=1
	i operDr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s tRowId=0
	f  s tRowId=$o(^DHCANOPDocOper("DocOper",0,"OperCtcp",operDr,tRowId))  q:tRowId=""  d
		.s ctcpId=tRowId
		.s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
		.d OutputRowCt
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCt
	set Data=$lb(tRowId,ctcpDesc,ctcpId,operDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOperCtcpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperCtcpExecute ]
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

ClassMethod FindOperCtcpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperCtcpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 单个授权
ClassMethod AddAuthOperSingle(ctcpIdStr, operIdStr, UserId) As %String
{
	s ret=0
	s newcount=$l(ctcpIdStr,"^")
	s opercount=$l(operIdStr,"^")
	f cnum=1:1:newcount d
		.s ctcpId=$p(ctcpIdStr,"^",cnum)
		.f onum=1:1:opercount d
			..s operId=$p(operIdStr,"^",onum)
			..s ret=..InsertDocOper(operId,ctcpId,UserId)
	q:ret'=0 ret	
	q "0"
}

// 

ClassMethod InsertDocOper(operId, ctcpIdStr, UserId) As %String
{
	s ret=0
	s userlen=$l(ctcpIdStr,"^")
	f inum=1:1:userlen d
		.s ctcpId=$p(ctcpIdStr,"^",inum)
		.q:$d(^DHCANOPDocOper("DocOper",0,"OperCtcp",operId,ctcpId))>0
		.q:$d(^DHCANOPDocOper("DocOper",0,"CtcpOper",ctcpId,operId))>0
		.k plist
		.s plist(2)=ctcpId
		.s plist(3)=operId
		.s plist(4)=+$h
		.s plist(5)=$p($h,",",2)
		.s plist(6)=UserId
		.&SQL(insert into SQLUSER.DHC_ANOP_DocOper Values :plist())
		.i SQLCODE TROLLBACK 
		.i SQLCODE'=0 d
			..i ret=0 s ret=SQLCODE
			..e  s ret=ret_"/"_SQLCODE
	q ret
}

// 删除单个手术授权

ClassMethod DeleteDocOper(ctcpIdStr) As %String
{
	s ret=0
	s ctcplen=$l(ctcpIdStr,"^")
	f onum=1:1:ctcplen d
		.s ctcpId=$p(ctcpIdStr,"^",onum)
		.i ctcpId'="" d
			..&SQL(delete from SQLUSER.DHC_ANOP_DocOper where AnOp_CtcpId=:ctcpId)
			..i SQLCODE TROLLBACK 
			..i SQLCODE'=0 d
				...i ret=0 s ret=SQLCODE
				...e  s ret=ret_"/"_SQLCODE
	q ret
}

/// 批量删除授权
ClassMethod DeleteAuthOper(rowIdStr) As %String
{
	s ret=0
	s operlen=$l(rowIdStr,"^")
	f onum=1:1:operlen d
		.s rowId=$p(rowIdStr,"^",onum)
		.q:rowId=""
		.i rowId'="" d
			..&SQL(delete from SQLUSER.DHC_ANOP_DocOper where AnOp_RowId=:rowId)
			..i SQLCODE TROLLBACK 
			..i SQLCODE'=0 d
				...i ret=0 s ret=SQLCODE
				...e  s ret=ret_"/"_SQLCODE
	q ret
}

ClassMethod AddDayOperAuth(ctcpIdStr) As %String
{
	s ret=0
	s doclen=$l(ctcpIdStr,"^")
	f num=1:1:doclen d
		.s rowId=$p(ctcpIdStr,"^",num)
		.q:rowId=""
		.i rowId'="" d
		..s ^DHCANOPDaySurgeryAut(rowId)="Y"
		q 0
}

ClassMethod DeleteDayOperAuth(ctcpIdStr) As %String
{
	s ret=0
	s doclen=$l(ctcpIdStr,"^")
	f num=1:1:doclen d
		.s rowId=$p(ctcpIdStr,"^",num)
		.q:rowId=""
		.i rowId'="" d
		..k ^DHCANOPDaySurgeryAut(rowId)
		q 0
}

/// w ##class(web.DHCOPDpcLocAuthorize).ClearOperData()
ClassMethod ClearOperData()
{
	s opDocId=0
	f  s opDocId=$o(^CTPCP(opDocId)) q:opDocId=""  d
	.i $d(^CTPCP(opDocId,"DHCAN","OperId"))>0 d
		..k ^CTPCP(opDocId,"DHCAN","OperId")
	q 0
}

// 科室手术授权开始

/// 查询手术科室对应手术
/// d ##class(%ResultSet).RunQuery("web.DHCOPDocLocAuthorize","FindLocOperation","104")
Query FindLocOperation(ctlocdr As %String) As %Query(ROWSPEC = "tRowId:%String,tANCLocDr:%String,tANCLoc:%String,tOperId:%String,tOperDesc:%String")
{
}

ClassMethod FindLocOperationExecute(ByRef qHandle As %Binary, ctlocdr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i ctlocdr=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
	s operId="" 
	f  s operId=$o(^DHCANC("LocOperation",0,"LocOper",ctlocdr,operId))  q:operId=""  d
	.s tRowId=0
	.f  s tRowId=$o(^DHCANC("LocOperation",0,"LocOper",ctlocdr,operId,tRowId))  q:tRowId=""  d
		..s tANCLocDr=$lg(^DHCANC("LocOperation",tRowId),1)
		..s tANCLoc=""
		..i tANCLocDr'="" s tANCLoc=$p($g(^CTLOC(tANCLocDr)),"^",2)
		..s tANCOper=""
		..s tANCOperDr=$lg(^DHCANC("LocOperation",tRowId),2)
		..i tANCOperDr'="" s tANCOper=$p($g(^ORC("OPER",tANCOperDr)),"^",2)
		..d OutputRowTX
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowTX
	set Data=$lb(tRowId,tANCLocDr,tANCLoc,tANCOperDr,tANCOper)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindLocOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocOperationExecute ]
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

ClassMethod FindLocOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod AddLocOperAuth(ctlocIdStr, operIdStr) As %String
{
	s ret=0
	s newcount=$l(ctlocIdStr,"^")
	s opercount=$l(operIdStr,"^")
	f cnum=1:1:newcount d
		.s ctlocId=$p(ctlocIdStr,"^",cnum)
		.f onum=1:1:opercount d
			..s operId=$p(operIdStr,"^",onum)
			..s ret=..InsertLocOper(ctlocId,operId)
	q:ret'=0 ret	
	q "0"
}

/// 插入
/// w ##class(web.DHCDocDoOper).InsertLocOper(1,3)
ClassMethod InsertLocOper(ANCLOLocationDr As %String, ANCLOOperationDr As %String)
{
	K PLIST
	TSTART
	s PLIST(2)=ANCLOLocationDr
	s PLIST(3)=ANCLOOperationDr
	&SQL(insert into SQLUSER.DHC_ANC_LocOperation Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod DeleteLocAuthOper(rowIdStr) As %String
{
	s ret=0
	s operlen=$l(rowIdStr,"^")
	f onum=1:1:operlen d
		.s rowId=$p(rowIdStr,"^",onum)
		.q:rowId=""
		.i rowId'="" d
			..&SQL(delete from SQLUSER.DHC_ANC_LocOperation where LocOper_Id=:rowId)
			..i SQLCODE TROLLBACK 
			..i SQLCODE'=0 d
				...i ret=0 s ret=SQLCODE
				...e  s ret=ret_"/"_SQLCODE
	q ret
}

}
