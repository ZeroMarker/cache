/// CTOR: QP
/// DATE: 2017-08-17
/// DESC: 抗菌药物报表-用于处理病人信息表、病人科室信息表数据展现
Class DHCAnt.QRY.RAQ.PatBaseInfor Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2017-05-09
/// Query：病人基础信息表数据导出
/// Input：SDate,EDate,XMClass(选择要输出的元素)
/// Desc: 将时间段的病人，从基础表中，将数据导出
/// OutPut:
/// d ##Class(%ResultSet).RunQuery("DHCAnt.QRY.RAQ.PatBaseInfor","QueryPatBaseInfor","2019-02-01","2019-02-10","1,2,3,8")
Query QueryPatBaseInfor(SDate As %String, EDate As %String, XMClass As %Text, hospid As %String) As %Query(ROWSPEC = "Admid:%String,AdmName:%String,AdmNO:%String,AdmSex:%String,BICCode:%String,BICDesc:%String,Value:%String") [ SqlProc ]
{
}

ClassMethod QueryPatBaseInforExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, XMClass As %Text, hospid As %String) As %Status
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
	.s dcbRowid=""
	.f  s dcbRowid=$o(^DHCWLPADI(0,"DisDate",day,dcbRowid)) q:dcbRowid=""  d
	..s Admid=$p(^DHCWLPADI(dcbRowid),"^",1)
	..q:Admid=""
	..s dept=$p(^PAADM(Admid),"^",4)
	..s hosp=$p(^CTLOC(dept),"^",22)
	..q:(hospid'="")&&($find(","_hospid_",",","_hosp_",")=0)
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
	...q:BICDesc="姓名"
	...q:BICDesc="登记号"  //2019.10.29前三列有姓名和登记号
	...i BICDesc="手术Id号" s BICDesc="手术名称"
	...Q:BICCode=""
	...i (BICCode'="")&&$D(^DHCWLPBI(0,"ADMCODE",Admid,BICCode))  d
	....s PBIRowid=$O(^DHCWLPBI(0,"ADMCODE",Admid,BICCode,"")) 
	....s Value=$P(^DHCWLPBI(PBIRowid),"^",4)
	....i Value["." s Value=$fn(Value,"",2)
	....i BICCode="AdmDoc" d  //就诊医生特殊处理2019.9.25wch
	.....i (Value'="Null")&&(Value'=0) s Value=$p(^CTPCP(Value,1),"^",2)
	.....e  s Value=""
	....i BICCode="DisWard" d  //出院病区特殊处理2019.9.25wch
	.....s Value=$p(^PAWARD(Value),"^",2)
	....i BICCode="DisDep" d  //出院科室特殊处理2019.9.25wch
	.....s Value=$p(^CTLOC(Value),"^",2) //科室
	.....i Value["-" s Value=$p(Value,"-",2)
	.....e  s Value=Value
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

ClassMethod QueryPatBaseInforExecuteOld(ByRef qHandle As %Binary, SDate As %String, EDate As %String, XMClass As %Text) As %Status
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
    ...do QueryPatBaseInfor2
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
QueryPatBaseInfor2
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

/// CTOR: QP
/// DATE: 2017-05-09
/// Query：科室信息表数据导出
/// Input：SDate,EDate,XMClass(选择要输出的元素)
/// Desc: 将时间段的病人，从基础表中，将数据导出
/// OutPut:
/// d ##Class(%ResultSet).RunQuery("DHCAnt.QRY.RAQ.PatBaseInfor","QueryPatDepInfor","2016-06-30","2016-06-30","362,363")
Query QueryPatDepInfor(SDate As %String, EDate As %String, XMClass As %Text, hospid As %String) As %Query(ROWSPEC = "Admid:%String,AdmName:%String,AdmNO:%String,AdmSex:%String,BICCode:%String,BICDesc:%String,Value:%String,Dep:%String") [ SqlProc ]
{
}

ClassMethod QueryPatDepInforExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, XMClass As %Text, hospid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (SDate="")||(EDate="" )||(XMClass="") d
	.Set qHandle=$lb(0,repid,0)
 	i (SDate="")||(EDate="" )||(XMClass="") Quit $$$OK
 	s ^TEMP("dhcqp",1)=XMClass
 	s SDate=$ZDH(SDate,3)
 	s EDate=$ZDH(EDate,3)
	f day=SDate:1:EDate  d
	.s dcbRowid=""
	.f  s dcbRowid=$o(^DHCWLPADI(0,"DisDate",day,dcbRowid)) q:dcbRowid=""  d
	..s Admid=$p(^DHCWLPADI(dcbRowid),"^",1)
	..q:Admid=""
	..s dept=$p(^PAADM(Admid),"^",4)
	..s hosp=$p(^CTLOC(dept),"^",22)
	..q:(hospid'="")&&($find(","_hospid_",",","_hosp_",")=0)
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
	...Q:'$D(^DHCWLPDICFG(BICRowid))
	...s BICCode=$P(^DHCWLPDICFG(BICRowid),"^",3)
	...s BICDesc=$P(^DHCWLPDICFG(BICRowid),"^",2)
	...Q:BICCode=""
	...Q:'$D(^DHCWLPDI(0,"ADMCODE",Admid,BICCode))
	...s PBIRowid=""
	...f  s PBIRowid=$O(^DHCWLPDI(0,"ADMCODE",Admid,BICCode,PBIRowid)) q:PBIRowid=""  d
	....s Value=$P(^DHCWLPDI(PBIRowid),"^",5)
	....i Value["." s Value=$fn(Value,"",2)
	....s Desc=$P(^DHCWLPDI(PBIRowid),"^",4)  //描述,区分是科室还是病区 2019.10.16wch
	....s Dep=$P(^DHCWLPDI(PBIRowid),"^",2)
	....q:Dep=""
	....i Desc["科室" d
	.....s Dep=$P(^CTLOC(Dep),"^",2)
	.....i Dep["-" s Dep=$p(Dep,"-",2)
	....i Desc["病区" d
	.....s Dep=$p(^PAWARD(Dep),"^",2)
 	.....i Dep [ "-" s Dep=$p(Dep,"-",2)
    ....do QueryPatDepInfor
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
QueryPatDepInfor
	s Data=$lb(Admid,AdmName,AdmNO,AdmSex,BICCode,BICDesc,Value,Dep)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryPatDepInforFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatDepInforExecute ]
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

ClassMethod QueryPatDepInforClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatDepInforExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2017-05-09
/// DESC: 对基本信息维护表进行解析
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.QRY.RAQ.PatBaseInfor","QueryBICInfor")
ClassMethod QueryBICInforExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
	s BICRowid=0
	f  s BICRowid=$O(^DHCWLBIC(BICRowid)) Q:BICRowid=""  d
	.s BICDesc=$P(^DHCWLBIC(BICRowid),"^",2)
	.q:BICDesc="登记号"
	.q:BICDesc="姓名"
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
    else  i BICDateFlag="YGYYDate" s BICDateFlag="病人信息数据项"
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

/// CTOR: QP
/// DATE: 2017-05-09
/// DESC: 对科室信息维护表进行解析
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.QRY.RAQ.PatBaseInfor","QueryBICInfor")
ClassMethod QueryDICInforExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
	s BICRowid=0
	f  s BICRowid=$O(^DHCWLPDICFG(BICRowid)) Q:BICRowid=""  d
	.s BICDesc=$P(^DHCWLPDICFG(BICRowid),"^",2)
	.s BICCode=$P(^DHCWLPDICFG(BICRowid),"^",3)
	.s BICDateFlag=$P(^DHCWLPDICFG(BICRowid),"^",4)
	.Q:(BICDesc="")||(BICCode="")||(BICDateFlag="")
    .d QueryDICInfor
 	q $$$OK	

QueryDICInfor
    i BICDateFlag="EPRDate" s BICDateFlag="编目日期"
    else  i BICDateFlag="AdmDate" s BICDateFlag="入院日期"
    else  i BICDateFlag="DisDate" s BICDateFlag="护士出院日期"
    else  i BICDateFlag="EstDisDate" s BICDateFlag="医生出院日期"
    else  i BICDateFlag="MRIPDate" s BICDateFlag="工作量出院日期"
    else  i BICDateFlag="YGYYDate" s BICDateFlag="病人信息数据项"
    else  s BICDateFlag="其他类型"
    s Data=$lb(BICDateFlag,BICRowid,BICDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryDICInforFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDICInforExecute ]
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

ClassMethod QueryDICInforClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDICInforExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryDICInfor() As %Query(ROWSPEC = "BICDateFlag:%String,BICCode:%String,BICDesc:%String") [ SqlProc ]
{
}

}
