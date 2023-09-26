Class DHCDoc.DHCDocConfig.PrescriptType Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->处方类型维护 查询所有处方类型
Query GetPrescriptTypeList(HospId As %String = "") As %Query(ROWSPEC = "PTRowid:%String,PTCode:%String,PTDescription:%String,PTAllowFlag:%String,PTWarnFlag:%String,PTLimitSum:%String,PTLimitCount:%String,PTLimitQty:%String,PTLimitType:%String,PTLimitTypeDesc:%String,PTBillType:%String,PTBillTypeDesc:%String,PTIsSpecDis:%String")
{
}

ClassMethod GetPrescriptTypeListExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PrescriptType","GetPrescriptTypeList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
    s PTRowid=0 f  s PTRowid=$o(^DHCPrescriptType(PTRowid)) q:PTRowid=""  d
    .s PTCode=$p(^DHCPrescriptType(PTRowid),"^",1)
    .s PTDescription=$p(^DHCPrescriptType(PTRowid),"^",2)
    .s PTAllowFlag=$p(^DHCPrescriptType(PTRowid),"^",3)
    .s PTWarnFlag=$p(^DHCPrescriptType(PTRowid),"^",4)
    .s PTLimitSum=$p(^DHCPrescriptType(PTRowid),"^",5)
    .s PTLimitCount=$p(^DHCPrescriptType(PTRowid),"^",6)
    .s PTLimitQty=$p(^DHCPrescriptType(PTRowid),"^",7)
    .s PTLimitType=$p(^DHCPrescriptType(PTRowid),"^",8)
    .i PTLimitType="S" s PTLimitTypeDesc="本科本日"
    .e  s PTLimitTypeDesc="本日"
    .s PTBillType=$p(^DHCPrescriptType(PTRowid),"^",9)
    .s PTBillTypeDesc=$p($g(^PAC("ADMREA",PTBillType)),"^",2)
    .if ('$d(^PAC("ADMREA",PTBillType))) s PTBillTypeDesc=PTBillTypeDesc_"<font color=red> 已失效</font>"
    .e  d
    ..s BillTypeSttDate=$p(^PAC("ADMREA",PTBillType),"^",3)
    ..if (BillTypeSttDate'="")&&(BillTypeSttDate>+$h) s PTBillTypeDesc=PTBillTypeDesc_"<font color=red> 未到生效日期</font>" 
    ..s BillTypeEndDate=$p(^PAC("ADMREA",PTBillType),"^",4)
    ..if (BillTypeEndDate'="")&&(BillTypeEndDate<+$h) s PTBillTypeDesc=PTBillTypeDesc_"<font color=red> 已过截止日期</font>" 
    .s PTIsSpecDis=$p(^DHCPrescriptType(PTRowid),"^",10)
    .i +PTIsSpecDis="0" s PTIsSpecDis="N"
    .e  s PTIsSpecDis="Y"
    .s HospDr=$p(^DHCPrescriptType(PTRowid),"^",11)
    .Q:HospDr'=HospId
	.Do OutputRowGetPrescriptTypeList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetPrescriptTypeList
	set Data=$lb($g(PTRowid),$g(PTCode),$g(PTDescription),$g(PTAllowFlag),$g(PTWarnFlag),$g(PTLimitSum),$g(PTLimitCount),$g(PTLimitQty),$g(PTLimitType),$g(PTLimitTypeDesc),$g(PTBillType),$g(PTBillTypeDesc),$g(PTIsSpecDis))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetPrescriptTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrescriptTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPrescriptTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrescriptTypeListExecute ]
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

Query GetLimitType() As %Query(ROWSPEC = "PTLimitType:%String,PTLimitTypeDesc:%String")
{
}

ClassMethod GetLimitTypeExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PrescriptType","GetLimitType")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s PTLimitTypeStr="S^M"
    For i=1:1:$l(PTLimitTypeStr,"^") d
    .s PTLimitType=$p(PTLimitTypeStr,"^",i)
    .i PTLimitType="S" s PTLimitTypeDesc="本科本日"
    .e  s PTLimitTypeDesc="本日"
	.Do OutputRowGetLimitType
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetLimitType
	set Data=$lb($g(PTLimitType),$g(PTLimitTypeDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetLimitTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLimitTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLimitTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLimitTypeExecute ]
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

/*
PTCode+"^"+PTDescription+"^"+PTAllowFlag+"^"+
PTWarnFlag+"^"+PTLimitSum+"^"+PTLimitCount+"^"+PTLimitQty+"^"+PTLimitType+"^"+PTBillType+"^"+PTIsSpecDis
*/

// w ##class(DHCDoc.DHCDocConfig.PrescriptType).insert("11^ceshi^2^3^4^5^6^S^1^1")

ClassMethod insert(Str As %String, HospId As %String = "") As %String
{
	s ^Tempscl("str")=Str
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s PTCode=$p(Str,"^",1)
	s PTDescription=$p(Str,"^",2)
	s count=0
	&sql(select count(PT_Rowid) into:count from SQLUser.DHC_PrescriptType where (PT_Code=:PTCode or PT_Description=:PTDescription) and PT_Hosp_Dr=:HospId)
	Q:count>0 "repeat"
	k PLIST
	s PLIST(2)=PTCode
	s PLIST(3)=PTDescription
	s PLIST(4)=$p(Str,"^",3)
	s PLIST(5)=$p(Str,"^",4)
	s PLIST(6)=$p(Str,"^",5)
	s PLIST(7)=$p(Str,"^",6)
	s PLIST(8)=$p(Str,"^",7)
	s PLIST(9)=$p(Str,"^",8)
	s PLIST(10)=$p(Str,"^",9)
	s PLIST(11)=$p(Str,"^",10)
	s PLIST(12)=HospId
	&sql(insert into SQLUser.DHC_PrescriptType values :PLIST())
	q SQLCODE
}

ClassMethod delete(Rowid) As %String
{
	s findPrescTypeDr=""
	s AILRowid=0  f  s AILRowid=$o(^DHCPAADMPrescType(AILRowid)) q:(AILRowid="")||(findPrescTypeDr'="")  d
    .s PrescTypeDr=$p(^DHCPAADMPrescType(AILRowid),"^",3)
    .i PrescTypeDr=Rowid s findPrescTypeDr=Rowid
	if (findPrescTypeDr'="") {
		s PrescTypeDesc=$p(^DHCPrescriptType(findPrescTypeDr),"^",2)
		Q PrescTypeDesc_" 已进行费别与处方对照,不能删除!"
	}
	&sql(delete from SQLUser.DHC_PrescriptType where pt_rowid=:Rowid)
    q SQLCODE
}

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->处方类型维护 查询处方类型允许的子类
Query GetAllowItemCatIDList(PTRowid As %String, value As %String, HospId As %String = "") As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod GetAllowItemCatIDListExecute(ByRef qHandle As %Binary, PTRowid As %String, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PrescriptType","GetAllowItemCatIDList","QuickAdmDep")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
    f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
    .s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
    .Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",ARCICRowId,HospId)="N"
    .s selected=0
    .i value'="" d
    ..i ("^"_..%GetConfig1(value,PTRowid,HospId)_"^")[("^"_ARCICRowId_"^")  s selected=1 //$g(^DHCDocConfig(value,PTRowid))
	.Do OutputRowGetAllowItemCatIDList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetAllowItemCatIDList
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAllowItemCatIDListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllowItemCatIDListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllowItemCatIDListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllowItemCatIDListExecute ]
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

ClassMethod Update(Rowid As %String, str As %String) As %String
{
	s Code=$p(str,"^",1)
    s Description=$p(str,"^",2)
    s allowflag=$p(str,"^",3)
    s warnflag=$p(str,"^",4)
    s limitsum=$p(str,"^",5)
    s limitcount=$p(str,"^",6)
    s limitqty=$p(str,"^",7)
    s limittype=$p(str,"^",8)
    s billtype=$p(str,"^",9)
    s isspecdis=$p(str,"^",10)
    s HospId=$p(^DHCPrescriptType(Rowid),"^",11)
	s count=0
	&sql(select count(PT_Rowid) into:count from SQLUser.DHC_PrescriptType where (PT_Code=:Code or PT_Description=:Description) and PT_Hosp_Dr=:HospId and PT_Rowid<>:Rowid)
	Q:count>0 "repeat"
    //s NotRestoreDefalut=$p(Str,"^",11) //,PT_NotRestoreDefalut=:NotRestoreDefalut
	&sql(update SQLUser.DHC_PrescriptType 
           set PT_Code=:Code,PT_Description=:Description,PT_AllowFlag=:allowflag,PT_WarnFlag=:warnflag,
               PT_LimitSum=:limitsum,PT_LimitCount=:limitcount,PT_LimitQty=:limitqty,PT_LimitType=:limittype,
               PT_BillType=:billtype,PT_IsSpecDis=:isspecdis
           where PT_Rowid=:Rowid )
      q SQLCODE
}

ClassMethod GetBillDescByCode(RowID As %String) As %String
{
	s Desc=$p(^PAC("ADMREA",RowID),"^",2)
	s rtn="{"_"""result"""_":"_""""_Desc_""""_"}"
	q rtn
}

}
