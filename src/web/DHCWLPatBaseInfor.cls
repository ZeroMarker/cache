Class web.DHCWLPatBaseInfor Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Query：病人基础信息表数据导出
/// Input：SDate,EDate,XMClass(选择要输出的元素)
/// Desc: 将时间段的病人，从基础表中，将数据导出
/// OutPut:
/// d ##Class(%ResultSet).RunQuery("web.DHCWLPatBaseInfor","QueryPatBaseInfor","2013-07-01","2013-07-01","1,3,2")
Query QueryPatBaseInfor(SDate As %String, EDate As %String, XMClass As %Text) As %Query(ROWSPEC = "Admid:%String,AdmName:%String,AdmNO:%String,AdmSex:%String,BICCode:%String,BICDesc:%String,Value:%String") [ SqlProc ]
{
}

ClassMethod QueryPatBaseInforExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, XMClass As %Text) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (SDate="")||(EDate="" )||(XMClass="") d
	.Set qHandle=$lb(0,repid,0)
 	i (SDate="")||(EDate="" )||(XMClass="") Quit $$$OK
 	s SDate=$ZDH(SDate,3)
 	s EDate=$ZDH(EDate,3)
	f day=SDate:1:EDate  d
	.s Admid=""
	.f  s Admid=$O(^PAADMi("DischDate",day,Admid)) Q:Admid=""  d
	..s AdmType=$P(^PAADM(Admid),"^",2)
	..Q:AdmType'="I"
	..s AdmMotherdr=$P(^PAADM(Admid),"^",75)
	..Q:AdmMotherdr'=""
	..s Papmidr=$P(^PAADM(Admid),"^",1)
	..s AdmName=$P(^PAPER(Papmidr,"ALL"),"^",1)
	..s AdmNO=$$GetPapmiNo^DHCWLCommon(Papmidr)
	..s AdmSex=$$GetSex^DHCWLCommon(Papmidr)
	..s BICRowid=""
	..s Count=$L(XMClass,",")
	..f i=1:1:Count d
	...s BICRowid=$P(XMClass,",",i)
	...Q:'$D(^DHCWLBIC(BICRowid))
	...s BICCode=$P(^DHCWLBIC(BICRowid),"^",3)
	...s BICDesc=$P(^DHCWLBIC(BICRowid),"^",2)
	...Q:BICCode=""
	...i (BICCode'="")&&$D(^DHCWLPBI(0,"ADMCODE",Admid,BICCode))  d
	....s PBIRowid=$O(^DHCWLPBI(0,"ADMCODE",Admid,BICCode,"")) 
	....s Value=$P(^DHCWLPBI(PBIRowid),"^",4)
	...else  s Value=""
	...s AdmInfor=Admid_" "_AdmName_" "_AdmNO_" "_AdmSex
    ...do QueryPatBaseInfor
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
QueryPatBaseInfor
	s Data=$lb(Admid,AdmName,AdmNO,AdmSex,BICCode,BICDesc,Value)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryPatBaseInforFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatBaseInforExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryPatBaseInforClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatBaseInforExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// / 对DHCWLBaseinforcfg表进行解析，输出BIC_Desc，BIC_Rowid，BIC_DateFlag描述，Rowid，标志
/// d ##Class(%ResultSet).RunQuery("web.DHCWLPatBaseInfor","QueryBICInfor")
ClassMethod QueryBICInforExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
	s BICRowid=0
	f  s BICRowid=$O(^DHCWLBIC(BICRowid)) Q:BICRowid=""  d
	.s BICDesc=$P(^DHCWLBIC(BICRowid),"^",2)
	.s BICCode=$P(^DHCWLBIC(BICRowid),"^",3)
	.s BICDateFlag=$P(^DHCWLBIC(BICRowid),"^",4)
	.Q:(BICDesc="")||(BICCode="")||(BICDateFlag="")
    .d QueryBICInfor
 	q $$$OK	

QueryBICInfor
    i BICDateFlag="EPRDate" s BICDateFlag="编目日期"
    else  i BICDateFlag="AdmDate" s BICDateFlag="入院日期"
    else  i BICDateFlag="DisDate" s BICDateFlag="护士出院日期"
    else  i BICDateFlag="EstDisDate" s BICDateFlag="医生出院日期"
    else  i BICDateFlag="MRIPDate" s BICDateFlag="工作量出院日期"
    else  i BICDateFlag="YGYYDate" s BICDateFlag="阳光用药日期"
    else  s BICDateFlag="其他类型"
    s Data=$lb(BICDateFlag,BICRowid,BICDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryBICInforFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBICInforExecute ]
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

ClassMethod QueryBICInforClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBICInforExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryBICInfor() As %Query(ROWSPEC = "BICDateFlag:%String,BICCode:%String,BICDesc:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCWLPatBaseInforDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCWLPatBaseInforD</DataLocation>
<DefaultData>DHCWLPatBaseInforDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCWLPatBaseInforD</IdLocation>
<IndexLocation>^web.DHCWLPatBaseInforI</IndexLocation>
<StreamLocation>^web.DHCWLPatBaseInforS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
