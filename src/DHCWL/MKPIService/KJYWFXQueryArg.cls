Import SQLUser

Class DHCWL.MKPIService.KJYWFXQueryArg Extends %RegisteredObject [ Not ProcedureBlock ]
{

// 指标选择查询

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQueryArg","GetKPI")	

ClassMethod GetKPIExecute(ByRef qHandle As %Binary, Medicare As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s mkpiId=""
    f  s mkpiId=$o(^DHCWL.MKPI.MKPIFLD(mkpiId)) q:mkpiId=""  d
    .s mkpiCode=$LIST(^DHCWL.MKPI.MKPIFLD(mkpiId),2)
    .s mkpiName=$LIST(^DHCWL.MKPI.MKPIFLD(mkpiId),3)
    .s kpiId=""
    .f  s kpiId=$o(^DHCWL.MKPI.MKPII("MKPICate",mkpiId,kpiId)) q:kpiId=""  d
    ..s kpiCode=$LIST(^DHCWL.MKPI.MKPID(kpiId),2)
    ..s kpiDesc=$LIST(^DHCWL.MKPI.MKPID(kpiId),3)
	..d OutputRow1
 	q $$$OK	
OutputRow1
    s Data=$lb(mkpiCode,mkpiId,mkpiName,kpiCode,kpiId,kpiDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetKPIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKPIExecute ]
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

ClassMethod GetKPIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKPIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetKPI() As %Query(ROWSPEC = "mkpiCode:%String,mkpiId:%Integer,mkpiName:%String,kpiCode:%String,kpiId:%Integer,kpiDesc:%String") [ SqlProc ]
{
}

// 医院信息获取

Query Hospital() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
select hosp_rowid,hosp_desc from CT_Hospital
}

// 药理分类获取

Query PHCCat() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT PHCC_Desc FROM DHC_PHCCat WHERE PHCC_Level=1
}

// 药品剂型获取

Query DrugForm() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT PHCF_Desc FROM PHC_form
}

// 药品用法获取

Query Instruc() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT PHCIN_RowId,PHCIN_Desc1 FROM PHC_instruc
}

// 医嘱大类获取

Query OEOrdCat() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT ORCAT_RowId,ORCAT_Desc FROM OEC_OrderCategory
}

// 医嘱子类获取

Query ItemCat() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT ARCIC_RowId,ARCIC_Desc FROM ARC_itemCat
}

// 药理学子类获取

Query PHCSubCat() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT PHCC_Desc FROM DHC_PHCCat WHERE PHCC_Level=2
}

// 科室信息获取

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQueryArg","GetCtlocXX")	

ClassMethod GetCtlocXXExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    s flag=0
    f  s flag=$o(^PAC("ADMLOC",0,"AdmType",flag))  q:flag=""   d 
    .s loc=0
    .f  s loc=$o(^PAC("ADMLOC",0,"AdmType",flag,loc))  q:loc=""   d 
    ..i $d(^CTLOC(loc)) d
    ...s desc=$P($G(^CTLOC(loc)),"^",2)  
    ...i desc [ "-" s depDesc=$p(desc,"-",2)
    ...e  s depDesc=desc
    ...d OutputRow2
   
 	q $$$OK	

OutputRow2
    i flag="I" s type="住院科室"
    i flag="O" s type="门诊科室"
    i flag="E" s type="急诊科室"
    s Data=$lb(type,loc,depDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCtlocXXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCtlocXXExecute ]
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

ClassMethod GetCtlocXXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCtlocXXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCtlocXX() As %Query(ROWSPEC = "type:%String,loc:%String,depDesc:%String") [ SqlProc ]
{
}

// 抗菌药物信息获取

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQueryArg","GetAntiDrg")	

ClassMethod GetAntiDrgExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    s drugna=""
    f  s drugna=$o(^PHCD(0,"Name",drugna))  q:drugna=""  d
    .s phcdf=""
    .f  s phcdf=$o(^PHCD(0,"Name",drugna,phcdf))  q:phcdf=""  d
    ..s drgna=$p(^PHCD(+phcdf,1),"^",2)  
    ..s sub=0
    ..f  s sub=$o(^PHCD(+phcdf,"DF",sub))  q:sub=""  d
    ...;q:'$d(^PHCD(+phcdf,"DF",sub,"DHC"))
    ...;s flag=$p($g(^PHCD(+phcdf,"DF",sub,"DHC")),"^",8) q:flag'="Y"  ;值为“Y”为是抗菌药
    ...q:$$IsAntiDrg^DHCWLBuildKPICommon(phcdf)=0
    ...s subcat=$p(^PHCD(+phcdf,1),"^",3)  ;q:+subcat'=16  //抗菌素
    ...s cat="抗菌药物"
    ...s child=$p(subcat,"||",2) q:child="" 
    ...q:'$d(^PHCC(+subcat,"SC",child))
    ...s subcatna=$p(^PHCC(+subcat,"SC",child),"^",2)
    ...d OutputRow3
   
 	q $$$OK	
OutputRow3
  
    s Data=$lb(cat,subcat,subcatna,phcdf,drgna)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetAntiDrgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAntiDrgExecute ]
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

ClassMethod GetAntiDrgClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAntiDrgExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetAntiDrg() As %Query(ROWSPEC = "cat:%String,subcat:%String,subcatna:%String,drgid:%String,drgna:%String") [ SqlProc ]
{
}

Query GetGzfl() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
select '管制分类',phcpo_rowid,phcpo_desc from PHC_Poison
}

// 区间选择查询

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQueryArg","GetKPIMonth","5")	

ClassMethod GetKPIMonthExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    s sectionId=""
    f  s sectionId=$o(^DHCWL.MKPI.SectionD(sectionId)) q:sectionId=""  d
    .q:$F(","_type_",",","_sectionId_",")=0  
    .s secName=$LIST(^DHCWL.MKPI.SectionD(sectionId),4)
    .s monthId=""
    .f  s monthId=$o(^DHCWL.MKPI.MonthsI("SectionFlag",sectionId,monthId)) q:monthId=""  d
    ..s monDesc=$LIST(^DHCWL.MKPI.MonthsD(monthId),3)
	..d OutputRow4
 	q $$$OK	
OutputRow4
    s fl=$E(monDesc,1,4)
    s Data=$lb(fl,sectionId,secName,monthId,monDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetKPIMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKPIMonthExecute ]
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

ClassMethod GetKPIMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKPIMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetKPIMonth(type As %String) As %Query(ROWSPEC = "fl:%String,sectionId:%Integer,secName:%String,monthId:%Integer,monDesc:%String") [ SqlProc ]
{
}

// 获取月份的头一天和最后一天

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQueryArg","GetLastDayOfMonth","2012-02")	

ClassMethod GetLastDayOfMonthExecute(ByRef qHandle As %Binary, month As %String) As %Status
{
	n (qHandle,month)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    q:month="" $$$OK
    
    s lastday=##class(DHCWL.MKPIService.ComputerDate).GetLastDayOfMonth(month)
    s firstday1=$zdh(month_"-01",3)
  	s firstday=$zd(firstday1,3)
    
	d OutputRow5
 	q $$$OK	
OutputRow5

    s Data=$lb(firstday,lastday)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetLastDayOfMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLastDayOfMonthExecute ]
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

ClassMethod GetLastDayOfMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLastDayOfMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetLastDayOfMonth(month As %String) As %Query(ROWSPEC = "firstday:%String,lastday:%String") [ SqlProc ]
{
}

// 通过姓名,进行医护人员信息获取

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQueryArg","GetCtpcp","孙凤霞")	

ClassMethod GetCtpcpExecute(ByRef qHandle As %Binary, bm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:bm="" $$$OK
 	
    s ctprowid=0 f  s ctprowid=$o(^CTPCP(ctprowid)) q:ctprowid=""  d
    .q:'$d(^CTPCP(ctprowid,1))
    .s code=$p(^CTPCP(ctprowid,1),"^",1) 
    .s desc=$p(^CTPCP(ctprowid,1),"^",2) 
    .q:desc'[bm
    .d OutputRow6

 	q $$$OK	

OutputRow6
    
    s Data=$lb(ctprowid,code,desc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCtpcpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCtpcpExecute ]
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

ClassMethod GetCtpcpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCtpcpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCtpcp(bm As %String) As %Query(ROWSPEC = "ctprowid:%Integer,code:%String,desc:%String") [ SqlProc ]
{
}

// 通过别名进行医护人员信息获取

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQueryArg","GetCtpcp1","zh")	

ClassMethod GetCtpcp1Execute(ByRef qHandle As %Binary, bm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:bm="" $$$OK
 	
    s bm=$zcvt(bm,"U")
    s ctprowid="" f  s ctprowid=$o(^CTPCP(ctprowid)) q:ctprowid=""  d
    .s othername=$p($g(^CTPCP(ctprowid,3)),"^",28) q:othername=""
    .q:$zcvt(othername,"U")'[bm
    .q:'$d(^CTPCP(ctprowid,1))
    .s usrcode=$p(^CTPCP(ctprowid,1),"^",3)  q:usrcode=""
    .s code=$p(^CTPCP(ctprowid,1),"^",1) 
    .s desc=$p(^CTPCP(ctprowid,1),"^",2) 
    .d OutputRow66

 	q $$$OK	

OutputRow66
    
    s Data=$lb(ctprowid,code,desc,othername)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCtpcp1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCtpcp1Execute ]
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

ClassMethod GetCtpcp1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCtpcp1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCtpcp1(bm As %String) As %Query(ROWSPEC = "ctprowid:%Integer,code:%String,desc:%String,othername:%String") [ SqlProc ]
{
}

// 根据别名查询药学项目

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQueryArg","GetItmaName","左洛复")	

Query GetItmaName(desc As %Text) As %Query(ROWSPEC = "phid:%String,phname:%String") [ SqlProc ]
{
}

ClassMethod GetItmaNameExecute(ByRef qHandle As %Binary, desc As %Text) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	q:desc="" $$$OK
 
 	s phid=0
 	f  s phid=$o(^PHCD(phid)) q:phid=""  d
    .q:((phid="DF_Form")||(phid="Durat") ||(phid="Freq") || (phid="Instruc") || (phid="OffCode"))
    .q:'$d(^PHCD(phid,1))
	.s phname=$p(^PHCD(phid,1),"^",2)
	.s phname=$TR(phname,"[","(")
	.s phname=$TR(phname,"]",")")
	.s phname=$TR(phname,"%","÷")
	.q:phname'[desc
	.Do OutputRow7
 
	Quit $$$OK
OutputRow7
	set Data=$lb(phid,phname)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetItmaNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItmaNameExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetItmaNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItmaNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 科室归属分院信息获取

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQueryArg","GetCtlocHosp","2,3")	

ClassMethod GetCtlocHospExecute(ByRef qHandle As %Binary, hospidstr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    q:hospidstr="" $$$OK
    s strloc1=0
    s len=$l(hospidstr,",")
    f num=1:1:len d
    .s hospid=$p(hospidstr,",",num)
    .s loc="" f  s loc=$o(^CTLOC(loc))  q:loc=""  d
    ..s hosp=$P($G(^CTLOC(loc)),"^",22)
	..i hosp="" s hosp=$o(^CT("HOSP",hosp),-1)
	..q:hosp'=hospid
	..s strloc1=strloc1_","_loc
    s strloc=strloc1
    d OutputRow8
   
 	q $$$OK	

OutputRow8
    s Data=$lb(hospidstr,strloc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCtlocHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCtlocHospExecute ]
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

ClassMethod GetCtlocHospClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCtlocHospExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCtlocHosp(hospidstr As %String) As %Query(ROWSPEC = "hospidstr:%String,strloc:%Text") [ SqlProc ]
{
}

// 科室信息获取

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQueryArg","GetCtloc","2")	

ClassMethod GetCtlocExecute(ByRef qHandle As %Binary, id As %Text) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
  
    d SplitMulitData9(id,,.idData)
    s loc=0 f  s loc=$o(^CTLOC(loc))  q:loc=""  d
    .//判断科室是否为所选科室
	.q:(id'="")&&(loc="")  
	.q:(id'="")&&('$d(idData(loc)))
    .s depCode=$P($G(^CTLOC(loc)),"^",1)  
    .s desc=$P($G(^CTLOC(loc)),"^",2)  
    .i desc [ "-" s depDesc=$p(desc,"-",2)
    .e  s depDesc=desc
    .d OutputRow9
   
 	q $$$OK	

OutputRow9
    s Data=$lb(loc,depCode,depDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SplitMulitData9(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCtlocExecute ]
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

ClassMethod GetCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCtlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCtloc(id As %Text) As %Query(ROWSPEC = "loc:%String,depCode:%String,depDesc:%String") [ SqlProc ]
{
}

// 通过ID,进行医护人员信息获取

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQueryArg","GetDocById","")	

ClassMethod GetDocByIdExecute(ByRef qHandle As %Binary, id As %Text) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	d SplitMulitData10(id,,.idData)
    s ctprowid=0 f  s ctprowid=$o(^CTPCP(ctprowid)) q:ctprowid=""  d
    .//判断医师是否为所选医师
	.q:(id'="")&&(ctprowid="")  
	.q:(id'="")&&('$d(idData(ctprowid)))
	.q:'$d(^CTPCP(ctprowid,1))
    .s code=$p(^CTPCP(ctprowid,1),"^",1) 
    .s desc=$p(^CTPCP(ctprowid,1),"^",2) 
    .d OutputRow10

 	q $$$OK	

OutputRow10
    
    s Data=$lb(ctprowid,code,desc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SplitMulitData10(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetDocByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocByIdExecute ]
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

ClassMethod GetDocByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDocById(id As %Text) As %Query(ROWSPEC = "ctprowid:%Integer,code:%String,desc:%String") [ SqlProc ]
{
}

// 药物信息获取

// d ##class(%ResultSet).RunQuery("DHCWL.MKPIService.KJYWFXQueryArg","GetDrugInfo","")	

ClassMethod GetDrugInfoExecute(ByRef qHandle As %Binary, id As %Text) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    d SplitMulitData11(id,,.idData)
    s phcdf=""
    f  s phcdf=$o(^PHCD(phcdf))  q:phcdf=""  d
    .q:+phcdf=0
    .//判断药品是否为所选药品
	.q:(id'="")&&(phcdf="")  
	.q:(id'="")&&('$d(idData(phcdf)))
	.q:'$d(^PHCD(+phcdf,1))
	.s drgcode=$p(^PHCD(+phcdf,1),"^",1)  
    .s drgna=$p(^PHCD(+phcdf,1),"^",2)  
    .d OutputRow11
   
 	q $$$OK	
	
OutputRow11
    s UnitDR=$p(^PHCD(phcdf,"DF",1,2),"^",4) 
	i UnitDR'="" s unitdesc=$p(^CT("UOM",UnitDR),"^",2) ;基本单位   CT_UOM
    s Guig=$$Intfaceguigbyphcdf^DHCWLBuildKPICommon(phcdf_"||1")
    s Data=$lb(phcdf,drgcode,drgna,Guig,unitdesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SplitMulitData11(multiStr,detm=",",multiData)
	n (multiStr,detm,multiData)
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s data=$p(multiStr,",",len)
	.q:data=""
	.s multiData(data)=""
 q
}

ClassMethod GetDrugInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDrugInfoExecute ]
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

ClassMethod GetDrugInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDrugInfo(id As %Text) As %Query(ROWSPEC = "phcdf:%String,drgcode:%String,drgna:%String,Guig:%String,unitdesc:%String") [ SqlProc ]
{
}

}
