Import SQLUser

Class web.DHCDocDoOper Extends %RegisteredObject
{

// 科室相应医生

// d ##class(%ResultSet).RunQuery("web.DHCDocDoOper","FindCtcp","","","")

Query FindCtcp(OpDeptId As %String = "", name As %String = "", WorkNo As %String = "", OperId As %String = "") As %Query(ROWSPEC = "ctlocId,ctlocDesc,ctcpId,ctcpDesc,ctcpWorkNo")
{
}

ClassMethod FindCtcpExecute(ByRef qHandle As %Binary, OpDeptId As %String = "", name As %String = "", WorkNo As %String = "", OperId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    k ^TMPOPCTCP($j)
    s ctlocIdList=""
    i OpDeptId'="" d
        .i OpDeptId=+OpDeptId s ctlocIdList=OpDeptId
        .e  d
            ..s locDesc=$$ALPHAUP^SSUTIL4(OpDeptId)
            ..s ctlocIdList=$o(^CTLOC(0,"Desc",locDesc,""))
    i OperId'=""  d
    .s ctlocIdList=##class(web.DHCCLCom).GetLocIdByLocListCode("INOPDEPT^OUTOPDEPT^EMOPDEPT")
    i ctlocIdList="" s ind=1 s qHandle=$lb(0,repid,0) 
    s ifDoctor="Y"
    f i=1:1:$l(ctlocIdList) d
        .s ctlocId=$p(ctlocIdList,"^",i)
        .q:ctlocId=""
        .s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
        .i $l(ctlocDesc,"-")>1 s ctlocDesc=$p(ctlocDesc,"-",2)
        .s resId=""
        .f  s resId=$O(^RB("RES",0,"CTLOC",ctlocId,resId))  q:resId=""  d
            ..s ctcpId=$P(^RB("RES",resId),"^",2)
            ..q:ctcpId=""
            ..s opstr=$g(^CTPCP(ctcpId,"DHCAN","OperId"))
            ..q:(opstr="")&(OperId'="")
            ..q:(("^"_opstr_"^")'[("^"_OperId_"^"))&(OperId'="")
            ..s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
            ..q:ctcptId=""
            ..s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",4)
            ..q:ctcptType'="DOCTOR"
            ..s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpId)
            ..s ctcpAlias=$p($g(^CTPCP(ctcpId,3)),"^",28)
            ..s ctcpWorkNo=..GetWorkNoById(ctcpId)
            ..;s ctcpWorkNo=$p($g(^CTPCP(ctcpId,1)),"^",1)
            ..s ^TMPOPCTCP($j,1,ctcpId)=$lb(ctlocId,ctlocDesc,ctcpId,ctcpDesc,ctcpWorkNo)
        .s ctcptOtherId = ""
    s ctcpId="",ctcptId=""
    i (name'="")||(WorkNo'="")  d 
      .f  s ctcpId=$o(^CTPCP(ctcpId)) q:ctcpId=""  d
          ..;s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
          ..;q:ctcptId=""
          ..s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpId)
          ..s ctcpAlias=$p($g(^CTPCP(ctcpId,3)),"^",28)
          ..s ctlocId=$o(^RB("RES",0,"CTPCP",ctcpId,""))
          ..s ctcpWorkNo=..GetWorkNoById(ctcpId)
          ..q:ctlocId=""
          ..;w ctcpDesc," ",name,"   ",ctcpWorkNo,"  ",WorkNo,!
          ..;b "5"
          ..q:((ctcpDesc'[name)&(name'=""))||((ctcpWorkNo'=WorkNo)&(WorkNo'=""))
          ..;w ctcpDesc," ",name,"   ",ctcpWorkNo,"  ",WorkNo,!
          ..s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
          ..s ctlocDesc=$p(ctlocDesc,"-",2)
          ..s ^TMPOPCTCP($j,1,ctcpId)=$lb(ctlocId,ctlocDesc,ctcpId,ctcpDesc,ctcpWorkNo)
        s n="" 
        f  s n=$o(^TMPOPCTCP($j,n)) q:n=""  d
            .s ctcptId=""  f  s ctcptId=$o(^TMPOPCTCP($j,n,ctcptId)) q:ctcptId=""  d
                ..d Outputcpt
        
    
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

Outputcpt
 set Data=$lb(ctlocId,ctlocDesc,ctcpId,ctcpDesc,ctcpWorkNo)
 Set ^CacheTemp(repid,ind)=^TMPOPCTCP($j,n,ctcptId)
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

// w ##class(web.DHCDocDoOper).GetOpByFenJi(6)  获取科室分级手术

ClassMethod GetOpByFenJi(FenJi As %String) As %Status
{
    q:FenJi="" ""
   s tOperId="",retStr=""
   f  s tOperId=$o(^ORC("OPER",tOperId)) q:tOperId=""  d
      .q:$d(^ORC("OPER",tOperId))<1
      .s tOperCode=$p(^ORC("OPER",tOperId),"^",1)
      .s tOperDesc=$p($g(^ORC("OPER",tOperId)),"^",2)
      .s tDengJi=$p($g(^ORC("OPER",tOperId)),"^",7)
      .q:tDengJi'[FenJi
      .s tOperDesc=$$ALPHAUP^SSUTIL4(tOperDesc)
      .s operStr=tOperDesc_"^"_tOperId
      .;w tDengJi_"^"_tOperDesc,!
      .i retStr'="" s retStr=retStr_"|"_operStr
      .e  s retStr=operStr
 
    q retStr
}

// w ##class(web.DylTongRenTest).GetOpByDocId(62)

// 2014+05+dyl+医生关联手术

ClassMethod GetOpByDocId(opDocId As %String = "") As %Status
{
    s tOperId=0,i=0
    s retStr=""
    if opDocId'=""
    {
        s operStr=$g(^CTPCP(opDocId,"DHCAN","OperId"))
        i operStr'="" s operlength=$l(operStr,"^")
        e  s operlength=0
        ;w operlength
        f i=1:1:operlength d
            .s tOperId=$p(operStr,"^",i)
            .q:tOperId=""
            .q:$d(^ORC("OPER",tOperId))<1
            .s tOperDesc=$p($g(^ORC("OPER",tOperId)),"^",2)
            .s operStr2=tOperDesc_"|"_tOperId
            .i retStr'="" s retStr=retStr_"^"_operStr2
            .e  s retStr=operStr2   
    }
    q retStr
}

ClassMethod DeleteMultiCtcpOper(ctcpIdStr As %String) As %String
{
	s dnum=$length(ctcpIdStr,"^")
	f i=1:1:dnum d
        .s ctcpId=$p(ctcpIdStr,"^",i)
        .k ^CTPCP(ctcpId,"DHCAN","OperId")
	q 0
}

ClassMethod SaveMultiCtcpOper(opDocIdStr As %String, DefItemStr As %String)
{
	s newlen=$l(opDocIdStr,"^")
	f j=1:1:newlen d
		.s opDocId=$p(opDocIdStr,"^",j)
	    .s oldDefItemStr=$g(^CTPCP(opDocId,"DHCAN","OperId"))
	    .s newCount=$length(DefItemStr,"^")
	    .s oldCount=$length(oldDefItemStr,"^")
	    .s newDefItemStr=""
	    .s num=""
	    .f i=1:1:oldCount d
	        ..s oldItemId=$p(oldDefItemStr,"^",i)
	        ..s num=$p(oldDefItemStr,"^",i)
	        ..i num="" s num=0
	        ..s j=1 f j=1:1:newCount d
	            ...s newItemId=$p(DefItemStr,"^",j)
	            ...q:newItemId'=oldItemId
	            ...s itemStr=$p(DefItemStr,"^",j)
	            ...s $p(DefItemStr,"^",j)=itemStr    
	    .s ^CTPCP(opDocId,"DHCAN","OperId")=DefItemStr
   
    q 0
}

// 保存个人手术

ClassMethod SaveSelOper(opDocId As %String, DefItemStr As %String)
{
    s oldDefItemStr=$g(^CTPCP(opDocId,"DHCAN","OperId"))
    s newCount=$length(DefItemStr,"^")
    s oldCount=$length(oldDefItemStr,"^")
    s newDefItemStr=""
    s num=""
    s i=1 f i=1:1:oldCount d
        .s oldItemId=$p(oldDefItemStr,"^",i)
        .s num=$p(oldDefItemStr,"^",i)
        .i num="" s num=0
        .s j=1 f j=1:1:newCount d
            ..s newItemId=$p(DefItemStr,"^",j)
            ..q:newItemId'=oldItemId
            ..s itemStr=$p(DefItemStr,"^",j)
            ..s $p(DefItemStr,"^",j)=itemStr
         
    s ^CTPCP(opDocId,"DHCAN","OperId")=DefItemStr
   
    q 0
}

/// d ##class(%ResultSet).RunQuery("web.DylTongRenTest","FindOrcDocOper","64")
/// d ##class(%ResultSet).RunQuery("web.DHCDocDoOper","FindOrcDocOper","64")
/// 获取医生相应手术
Query FindOrcDocOper(OpDocId As %String = "") As %Query(ROWSPEC = "tOpDoc,tOpDocId,tOperId,tOperDesc")
{
}

ClassMethod FindOrcDocOperExecute(ByRef qHandle As %Binary, OpDocId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s tOperId=0,i=0
    i OpDocId="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
    e  d
        .s operStr=$g(^CTPCP(OpDocId,"DHCAN","OperId"))
        .i operStr'="" s operlength=$l(operStr,"^")
        .e  s operlength=0
        .f i=1:1:operlength d
            ..s tOperId=$p(operStr,"^",i)
            ..q:tOperId=""
            ..q:$d(^ORC("OPER",tOperId))<1
            ..s tOperCode=$p(^ORC("OPER",tOperId),"^",1)
            ..s tOperDesc=$p($g(^ORC("OPER",tOperId)),"^",2)
            ..s tOperDesc=$$ALPHAUP^SSUTIL4(tOperDesc)
            ..s ctlocId=$p($g(^ORC("OPER",tOperId,"OperDeptAndDoc")),"^",1)
            ..i ctlocId'="" s tDept=$p($g(^CTLOC(ctlocId)),"^",2)
            ..e  s tDept=""
            ..s opDoc=$p(^CTPCP(OpDocId,1),"^",2)
            ..d OutRowD
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutRowD
    set Data=$lb(opDoc,OpDocId,tOperId,tOperDesc)
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

/// 查找某个手术是由哪些医生可以操作
/// 2015.3.26 by wll
/// w ##class(%ResultSet).RunQuery("web.DHCDocDoOper","FindDocByOper","") 
Query FindDocByOper(OperId As %String = "") As %Query(ROWSPEC = "ctlocId,ctlocDesc,ctcpId,ctcpDesc,ctcpWorkNo")
{
}

ClassMethod FindDocByOperExecute(ByRef qHandle As %Binary, OperId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    q:OperId=""
    k ^TMPOPCTCP($j)
    s ctlocIdList=##class(web.DHCCLCom).GetLocIdByLocListCode("INOPDEPT^OUTOPDEPT^EMOPDEPT")
    f i=1:1:$l(ctlocIdList) d
        .s ctlocId=$p(ctlocIdList,"^",i)
        .q:ctlocId=""
        .s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
        .s ctlocDesc=$p(ctlocDesc,"-",2)
        .s resId=""
        .f  s resId=$O(^RB("RES",0,"CTLOC",ctlocId,resId))  q:resId=""  d
            ..s ctcpId=$P(^RB("RES",resId),"^",2)
            ..q:ctcpId=""
            ..s opstr=$g(^CTPCP(ctcpId,"DHCAN","OperId"))
            ..q:opstr=""
            ..q:("^"_opstr_"^")'[("^"_OperId_"^")
            ..s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
            ..q:ctcptId=""
            ..s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",4)
            ..s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpId)
            ..s ctcpAlias=$p($g(^CTPCP(ctcpId,3)),"^",28)
            ..s ctcpWorkNo=##Class(web.DHCClinicCom).GetWorkNoById(ctcpId)
            ..s ^TMPOPCTCP($j,1,ctcpId)=$lb(ctlocId,ctlocDesc,ctcpId,ctcpDesc,ctcpWorkNo)
        s n="" 
        f  s n=$o(^TMPOPCTCP($j,n)) q:n=""  d
            .s ctcptId=""  f  s ctcptId=$o(^TMPOPCTCP($j,n,ctcptId)) q:ctcptId=""  d
                ..d Outputcpt           
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

Outputcpt
    set Data=$lb(ctlocId,ctlocDesc,ctcpId,ctcpDesc,ctcpWorkNo)
    Set ^CacheTemp(repid,ind)=^TMPOPCTCP($j,n,ctcptId)
    Set ind=ind+1
    quit
}

ClassMethod FindDocByOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocByOperExecute ]
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

ClassMethod FindDocByOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocByOperExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocDoOper","FindOperation","tb","")
Query FindOperation(operDescAlias As %String = "", operCat As %String = "") As %Query(ROWSPEC = "OPTypeDes:%String,rowid:%String")
{
}

ClassMethod FindOperationExecute(ByRef qHandle As %Binary, operDescAlias As %String = "", operCat As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    i operDescAlias'="" d
	    .s operDescAlias=$$ALPHAUP^SSUTIL4(operDescAlias) 
	    .s OpDes=""  
	    .f  s OpDes=$o(^ORC("OPER",0,"ALIAS",OpDes)) q:OpDes=""  d
	    ..i OpDes[operDescAlias d
	    ...s rowid=$o(^ORC("OPER",0,"ALIAS",OpDes,0))
	    ...s OPTypeDes=$p($g(^ORC("OPER",rowid)),"^",2)
	    ...d OutputRow0829
	    .s OpDes=""
		    .f  s OpDes=$o(^ORC("OPER",0,"Desc",OpDes)) q:OpDes=""  d
			    ..i OpDes[operDescAlias d
			    ...s rowid=$o(^ORC("OPER",0,"Desc",OpDes,0))
			    ...s OPTypeDes=$p($g(^ORC("OPER",rowid)),"^",2)
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
      ..d OutputRow0829
    e  d
    .;s rowid=0
    .;f  s rowid=$o(^ORC("OPER",rowid)) q:rowid=""  d
    .;.s OPTypeDes=$p(^ORC("OPER",rowid),"^",2)
    .;.s OPTypeDes=$REPLACE(OPTypeDes,"[","(")
    .;.s OPTypeDes=$REPLACE(OPTypeDes,"]",")")
    .;.s OPTypeDes=$REPLACE(OPTypeDes,"﹜","|")
    .;.d OutputRow
    .s OPTypeDes="",rowid=""

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

/// 查询手术科室对应手术
/// d ##class(%ResultSet).RunQuery("web.DHCDocDoOper","FindLocOperation","16")
Query FindLocOperation(ctlocdr As %String) As %Query(ROWSPEC = "tRowId:%String,tANCLocDr:%String,tANCLoc:%String,tANCOperDr:%String,tANCOper:%String")
{
}

ClassMethod FindLocOperationExecute(ByRef qHandle As %Binary, ctlocdr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	q:ctlocdr=""
	s tRowId=0
	f  s tRowId=$o(^DHCANC("LocOperation",0,"Loc",ctlocdr,tRowId))  q:tRowId=""  d
	.s tANCLocDr=$lg(^DHCANC("LocOperation",tRowId),1)
	.s tANCLoc=""
	.i tANCLocDr'="" s tANCLoc=$p($g(^CTLOC(tANCLocDr)),"^",2)
	.s tANCOper=""
	.s tANCOperDr=$lg(^DHCANC("LocOperation",tRowId),2)
	.i tANCOperDr'="" s tANCOper=$p($g(^ORC("OPER",tANCOperDr)),"^",2)
	.d OutputRowTX
	
	
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

/// 删除
/// w ##class(web.DHCDocDoOper).InsertLocOper(1)
ClassMethod DeleteLocOper(Rowid As %String)
{
	i Rowid'="" d
	.&SQL(delete from SQLUSER.DHC_ANC_LocOperation where ID=:Rowid)
	q SQLCODE
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
	f  s tRowId=$o(^DHCANC("OperCtcp",0,"OperDr",operDr,tRowId))  q:tRowId=""  d
		.s ctcpId=$li(^DHCANC("OperCtcp",tRowId),2)
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

/// w ##class(web.DHCDocDoOper).InsertOperCtcp(226,5602)
/// 20171228+dyl
ClassMethod InsertOperCtcp(ctcpDr As %String, operationDr As %String)
{
	K PLIST
	TSTART
	s PLIST(2)=operationDr
	s PLIST(3)=ctcpDr
	&SQL(insert into SQLUSER.DHC_ANC_OperCtcp Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

/// 20171228+dyl
ClassMethod DeleteOperCtcp(Rowid As %String)
{
	q:Rowid="" "Please select one record!"
	i Rowid'="" d
	.&SQL(delete from SQLUSER.DHC_ANC_OperCtcp where ID=:Rowid)
	q SQLCODE
}

/// 判断添加科室手术是否重复
ClassMethod JudgeIsRepeat(ctlocid As %String, opaid As %String)
{
	q:ctlocid=""
	q:opaid=""
	s flag=0
	s tRowId=0
	f  s tRowId=$o(^DHCANC("LocOperation",0,"Loc",ctlocid,tRowId))  q:tRowId=""  d
	.s tANCOperDr=$lg(^DHCANC("LocOperation",tRowId),2)
	.i (tANCOperDr=opaid) s flag=1	
	q flag
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocDoOper","FindOperationByLocAndDoc","","")
Query FindOperationByLocAndDoc(docId As %String = "", locId As %String = "") As %Query(ROWSPEC = "opTypeDesc:%String,rowId:%String")
{
}

ClassMethod FindOperationByLocAndDocExecute(ByRef qHandle As %Binary, docId As %String = "", locId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    i docId'="" d
    .s opStr=^CTPCP(docId,"DHCAN","OperId")
    .s opLength=$l(opStr,"^")
    .f i=1:1:opLength d
    ..s rowId=$p(opStr,"^",i)
    ..s opTypeDesc=$p($g(^ORC("OPER",rowId)),"^",2)
    ..d OutputRowTX0829
    e  d
    .i locId'="" d
    ..s rowId=""
    ..f  s rowId=$o(^User.DHCANCLocOperationI("ANCLOLocationDrIndex"," "_locId,rowId)) q:rowId=""  d
    ...s opTypeDesc=$p($g(^ORC("OPER",rowId)),"^",2)
	...d OutputRowTX0829
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowTX0829
    set Data=$lb(opTypeDesc,rowId)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindOperationByLocAndDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationExecute ]
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

ClassMethod FindOperationByLocAndDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
