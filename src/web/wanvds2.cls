Class web.wanvds2 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      yu
/// CreatDate：    2013-02-20
/// Description:   科室出院情况统计
/// Table：        DHCWL_MKPI.DHCWLKPIMonths DHCWL_MKPI.DHCWLMKPI
/// Input：        startDate:开始区间,endDate:结束区间
/// Output：       科室情况：科室名称，出院人数总计，三日确诊人次，手术人次，抢救次数，抢救成功次数，医嘱离院，医嘱转院，医嘱转社区，非医嘱离院，死亡，其他
///                年龄段（5岁以下，5-14岁，15-44岁，45-59岁，60岁以上），门诊入院诊断（符合，不符，疑诊），出入院诊断（符合，不符，疑诊），术前术后诊断（符合，不符，疑诊）
///                临床病理诊断（符合，不符，疑诊），放射病理诊断（符合，不符，疑诊），院内感染人数
/// Return：      
/// Others：      按照时间段查找,按照科室维汇总
///               kpiCodeStr字符串里面的指标Code，应该和ROWSPEC返回的串一一对应
/// d ##class(%ResultSet).RunQuery("web.wanvds2","QueryEPRMRDeptInfo","2009-09-01","2009-09-20")
Query QueryEPRMRDeptInfo(startDate As %String, endDate As %String) As %Query(ROWSPEC = "kPIDesc:%String,AllPatNums:%Float,In3Days:%Float,OperNums:%Float,ResNums:%Float,SucResNums:%Float,OrdLyNums:%Float,OrdZyNums:%Float,OrdZsqNums:%Float,NOrdZyNums:%Float,OrdSwNums:%Float,OrdQtNums:%Float,Un5Nums:%Float,Un15Nums:%Float,Un45Nums:%Float,Un60Nums:%Float,Up60Nums:%Float,MzryzdfhNums:%Float,MzryzdbfNums:%Float,MzryzdyzNums:%Float,CryzdfhNums:%Float,CryzdbfNums:%Float,CryzdyzNums:%Float,SqshzdfhNums:%Float,SqshzdbfNums:%Float,SqshzdyzNums:%Float,LcblzdfhNums:%Float,LcblzdbfNums:%Float,LcblzdyzNums:%Float,FsblzdfhNums:%Float,FsblzdbfNums:%Float,FsblzdyzNums:%Float,YngrNums:%Float") [ SqlProc ]
{
}

ClassMethod QueryEPRMRDeptInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	n (qHandle,startDate,endDate,type)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s kpiCodeStr="EPRMRDepAllPatNums,EPRMRDepIn3Days,EPRMRDepOperNums,EPRMRDepResNums,EPRMRDepSucResNums,EPRMRDepOrdLyNums,EPRMRDepOrdZyNums,EPRMRDepOrdZsqNums,EPRMRDepNOrdZyNums,EPRMRDepOrdSwNums,EPRMRDepOrdQtNums,EPRMRDepUn5Nums,EPRMRDepUn15Nums,EPRMRDepUn45Nums,EPRMRDepUn60Nums,EPRMRDepUp60Nums,EPRMRDepMzryzdfhNums,EPRMRDepMzryzdbfNums,EPRMRDepMzryzdyzNums,EPRMRDepCryzdfhNums,EPRMRDepCryzdbfNums,EPRMRDepCryzdyzNums,EPRMRDepSqshzdfhNums,EPRMRDepSqshzdbfNums,EPRMRDepSqshzdyzNums,EPRMRDepLcblzdfhNums,EPRMRDepLcblzdbfNums,EPRMRDepLcblzdyzNums,EPRMRDepFsblzdfhNums,EPRMRDepFsblzdbfNums,EPRMRDepFsblzdyzNums,EPRMRDepYngrNums"
    k ^tempDHCWL($j)
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	q:kpiCodeStr="" $$$OK
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	q:monNameStr="" 1
 	Set rset = ##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMutiMonKPIDataByGen")
	Set columns = rset.GetColumnCount()
	Set sc = rset.Execute(monNameStr,kpiCodeStr)
	While (rset.Next())
	{
      s mkpiId=rset.GetData(3)
      s mkpiIdDesc=rset.GetData(4)
      s mdimId=rset.GetData(5)
      s mdimIdDesc=rset.GetData(6)
      s mValue=rset.GetData(7)
      s ^tempDHCWL($j,mdimId,mkpiId)=$G(^tempDHCWL($j,mdimId,mkpiId))+$G(mValue)
	  s ^tempDHCWL($j,"Desc",mdimId)=mdimIdDesc
	}
	Do rset.Close()	
	k mlist
	k plist
	s ind=1
	s kpiIdStr=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStr)
	s kpilen=$L(kpiIdStr,",")
	for i=1:1:kpilen  do
	.s mlist(i)=$P(kpiIdStr,",",i)
	s dimID="" for  s dimID=$O(^tempDHCWL($j,dimID))  Q:dimID=""  do
	.s plist(0)=$G(^tempDHCWL($j,"Desc",dimID))
	.Q:plist(0)=""
	.for i=1:1:kpilen  do
	..s plist(i)=+$g(^tempDHCWL($j,dimID,mlist(i)))
	.do OutPutRowTest
	k ^tempDHCWL($j)
	Set qHandle=$lb(0,repid,0)
    quit $$$OK
OutPutRowTest
	s Data=$lb(plist(0),plist(1),plist(2),plist(3),plist(4),plist(5),plist(6),plist(7),plist(8),plist(9),plist(10),plist(11),plist(12),plist(13),plist(14),plist(15),plist(16),plist(17),plist(18),plist(19),plist(20),plist(21),plist(22),plist(23),plist(24),plist(25),plist(26),plist(27),plist(28),plist(29),plist(30),plist(31),plist(32)) 
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod QueryEPRMRDeptInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEPRMRDeptInfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryEPRMRDeptInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEPRMRDeptInfoExecute ]
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

/// Creator：      yu
/// CreatDate：    2013-02-20
/// Description:   住院病人手术情况统计表
/// Table：        DHCWL_MKPI.DHCWLKPIMonths DHCWL_MKPI.DHCWLMKPI
/// Input：        startDate:开始区间,endDate:结束区间
/// Output：       科室手术情况：科室名称，手术人数总计，术前住院日，平均术前住院日，I类手术总人数，I类手术甲级人数，I类手术乙级人数，I类手术丙级人数，II类手术总人数，III类手术甲级人数，II类手术乙级人数，II类手术丙级人数
///                III类手术总人数，III类手术甲级人数，III类手术乙级人数，III类手术丙级人数，急诊手术总人次，择期手术总人次，三日内手术，择期手术术前住院日，住院总费用，术前术后诊断符合，手术死亡人数
/// Return：      
/// Others：      按照时间段查找,按照科室维汇总
///               kpiCodeStr字符串里面的指标Code，应该和ROWSPEC返回的串一一对应
/// d ##class(%ResultSet).RunQuery("web.wanvds2","QueryEPRMRDeptOperInfo","2009-09-01","2009-09-20")
Query QueryEPRMRDeptOperInfo(startDate As %String, endDate As %String) As %Query(ROWSPEC = "kPIDesc:%String,OperNums:%Float,PreOpDays:%Float,ILeveAllNums:%Float,ILeveANums:%Float,ILeveBNums:%Float,ILeveCNums:%Float,IILeveAllNums:%Float,IILeveANums:%Float,IILeveBNums:%Float,IILeveCNums:%Float,IIILeveAllNums:%Float,IIILeveANums:%Float,IIILeveBNums:%Float,IIILeveCNums:%Float,EpOperNums:%Float,ZqOperNums:%Float,3DaysNums:%Float,ZqPreOperDays:%Float,AllFee:%Float,SqshzdfhNums:%Float,OperDNums:%Float,PerPJOpDays:%Float") [ SqlProc ]
{
}

ClassMethod QueryEPRMRDeptOperInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	n (qHandle,startDate,endDate,type)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s kpiCodeStr="EPRMRDepOperNums,EPRMRDepPreOpDays,EPRMRDepILeveAllNums,EPRMRDepILeveANums,EPRMRDepILeveBNums,EPRMRDepILeveCNums,EPRMRDepIILeveAllNums,EPRMRDepIILeveANums,EPRMRDepIILeveBNums,EPRMRDepIILeveCNums,EPRMRDepIIILeveAllNums,EPRMRDepIIILeveANums,EPRMRDepIIILeveBNums,EPRMRDepIIILeveCNums,EPRMRDepEpOperNums,EPRMRDepZqOperNums,EPRMRDep3DaysNums,EPRMRDepZqPreOperDays,EPRMRDepAllFee,EPRMRDepSqshzdfhNums,EPRMRDepInOperDNums,EPRMRDepAfOperDNums"
    k ^tempDHCWL($j)
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	q:kpiCodeStr="" $$$OK
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	q:monNameStr="" 1
 	Set rset = ##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMutiMonKPIDataByGen")
	Set columns = rset.GetColumnCount()
	Set sc = rset.Execute(monNameStr,kpiCodeStr)
	While (rset.Next())
	{
      s mkpiId=rset.GetData(3)
      s mkpiIdDesc=rset.GetData(4)
      s mdimId=rset.GetData(5)
      s mdimIdDesc=rset.GetData(6)
      s mValue=rset.GetData(7)
      s ^tempDHCWL($j,mdimId,mkpiId)=$G(^tempDHCWL($j,mdimId,mkpiId))+$G(mValue)
	  s ^tempDHCWL($j,"Desc",mdimId)=mdimIdDesc
	}
	Do rset.Close()	
	k mlist
	k plist
	s ind=1
	s kpiIdStr=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStr)
	s kpilen=$L(kpiIdStr,",")
	for i=1:1:kpilen  do
	.s mlist(i)=$P(kpiIdStr,",",i)
	s dimID="" for  s dimID=$O(^tempDHCWL($j,dimID))  Q:dimID=""  do
	.s plist(0)=$G(^tempDHCWL($j,"Desc",dimID))
	.Q:plist(0)=""
	.for i=1:1:kpilen  do
	..s plist(i)=+$g(^tempDHCWL($j,dimID,mlist(i)))
	.s i=kpilen-1
	.s plist(i)=plist(i)+plist(i+1)
	.s plist(i+1)=0
	.if +$g(plist(1))'=0 s plist(i+1)=$fn(plist(2)/plist(1),"",2)
	.do OutPutDeptOperInfo
	k ^tempDHCWL($j)
	Set qHandle=$lb(0,repid,0)
    quit $$$OK
OutPutDeptOperInfo
	s Data=$lb(plist(0),plist(1),plist(2),plist(3),plist(4),plist(5),plist(6),plist(7),plist(8),plist(9),plist(10),plist(11),plist(12),plist(13),plist(14),plist(15),plist(16),plist(17),plist(18),plist(19),plist(20),plist(21),plist(22)) 
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod QueryEPRMRDeptOperInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEPRMRDeptOperInfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryEPRMRDeptOperInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEPRMRDeptOperInfoExecute ]
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

/// Creator：      yu
/// CreatDate：    2013-02-21
/// Description:   住院病人费用统计
/// Table：        DHCWL_MKPI.DHCWLKPIMonths DHCWL_MKPI.DHCWLMKPI
/// Input：        startDate:开始区间,endDate:结束区间
/// Output：       科室病人费用情况：科室名称，离院方式（总人数，医嘱离院，医嘱转院，医嘱转社区，非医嘱离院，死亡，其他），年龄段（5岁以下，5-14岁，15-44岁，45-59岁，60岁以上）
///                出院病人住院总天数，出院病人平均住院天数，病人费用（总计，中成药，中草药，西药，手术费，抗菌药），出院病人平均费用
/// Return：      
/// Others：      按照时间段查找,按照科室维汇总
///               kpiCodeStr字符串里面的指标Code，应该和ROWSPEC返回的串一一对应
/// d ##class(%ResultSet).RunQuery("web.wanvds2","QueryEPRMRDeptFees","2009-09-01","2009-09-20")
Query QueryEPRMRDeptFees(startDate As %String, endDate As %String) As %Query(ROWSPEC = "kPIDese:%String,AllPatNums:%Float,OrdLyNums:%Float,OrdZyNums:%Float,OrdZsqNums:%Float,NOrdZyNums:%Float,OrdSwNums:%Float,OrdQtNums:%Float,Un5Nums:%Float,Un15Nums:%Float,Un45Nums:%Float,Un60Nums:%Float,Up60Nums:%Float,InsDays:%Float,AllFee:%Float,ZylZcyAFee:%Float,ZylZcyBFee:%Float,XylXyFee:%Float,ZllSsFee:%Float,XylKjywFee:%Float,PjInsDays:%Float,PjAllFee:%Float") [ SqlProc ]
{
}

ClassMethod QueryEPRMRDeptFeesExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	n (qHandle,startDate,endDate,type)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s kpiCodeStr="EPRMRDepAllPatNums,EPRMRDepOrdLyNums,EPRMRDepOrdZyNums,EPRMRDepOrdZsqNums,EPRMRDepNOrdZyNums,EPRMRDepOrdSwNums,EPRMRDepOrdQtNums,EPRMRDepUn5Nums,EPRMRDepUn15Nums,EPRMRDepUn45Nums,EPRMRDepUn60Nums,EPRMRDepUp60Nums,EPRMRDepInsDays,EPRMRDepAllFee,EPRMRDepZylZcyAFee,EPRMRDepZylZcyBFee,EPRMRDepXylXyFee,EPRMRDepZllSsFee,EPRMRDepXylKjywFee"
    k ^tempDHCWL($j)
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	q:kpiCodeStr="" $$$OK
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	q:monNameStr="" 1
 	Set rset = ##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMutiMonKPIDataByGen")
	Set columns = rset.GetColumnCount()
	Set sc = rset.Execute(monNameStr,kpiCodeStr)
	While (rset.Next())
	{
      s mkpiId=rset.GetData(3)
      s mkpiIdDesc=rset.GetData(4)
      s mdimId=rset.GetData(5)
      s mdimIdDesc=rset.GetData(6)
      s mValue=rset.GetData(7)
      s ^tempDHCWL($j,mdimId,mkpiId)=$G(^tempDHCWL($j,mdimId,mkpiId))+$G(mValue)
	  s ^tempDHCWL($j,"Desc",mdimId)=mdimIdDesc
	}
	Do rset.Close()	
	k mlist
	k plist
	s ind=1
	s kpiIdStr=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStr)
	s kpilen=$L(kpiIdStr,",")
	for i=1:1:kpilen  do
	.s mlist(i)=$P(kpiIdStr,",",i)
	s dimID="" for  s dimID=$O(^tempDHCWL($j,dimID))  Q:dimID=""  do
	.s plist(0)=$G(^tempDHCWL($j,"Desc",dimID))
	.Q:plist(0)=""
	.for i=1:1:kpilen  do
	..s plist(i)=+$g(^tempDHCWL($j,dimID,mlist(i)))
	.s i=kpilen+1
	.s plist(i)=0
	.s plist(i+1)=0
	.if +$g(plist(1))'=0  do
	..s plist(i)=$fn(plist(13)/plist(1),"",2)  // 平均住院天数
	..s plist(i+1)=$fn(plist(14)/plist(1),"",2) //平均住院费用
	.do QueryEPRMRDeptFees
	k ^tempDHCWL($j)
	Set qHandle=$lb(0,repid,0)
    quit $$$OK
QueryEPRMRDeptFees
	s Data=$lb(plist(0),plist(1),plist(2),plist(3),plist(4),plist(5),plist(6),plist(7),plist(8),plist(9),plist(10),plist(11),plist(12),plist(13),plist(14),plist(15),plist(16),plist(17),plist(18),plist(19),plist(20),plist(21)) 
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod QueryEPRMRDeptFeesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEPRMRDeptFeesExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryEPRMRDeptFeesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEPRMRDeptFeesExecute ]
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

/// Creator：      yu
/// CreatDate：    2013-02-21
/// Description:   医院工作量动态总表
/// Table：        DHCWL_MKPI.DHCWLKPIMonths DHCWL_MKPI.DHCWLMKPI
/// Input：        startDate:开始区间,endDate:结束区间
/// Output：       科室名称，门急诊总人数，门诊人次，急诊人次，急诊死亡，收容人数，收容死亡人数，健康检查人数，期末实有病床，期初留有人数，期内入院人数，期内转入人数
///                离院方式（总计，医嘱离院，医嘱转院，医嘱转社区，非医嘱离院，死亡，其他），转往他科人数，期末留院人数，实际开放总床日数，实际占用总床日数，出院者占用总床日数，平均住院日，人均费用，手术人数
/// Return：      
/// Others：      按照时间段查找,按照科室维汇总
///               kpiCodeStr字符串里面的指标Code，应该和ROWSPEC返回的串一一对应
/// d ##class(%ResultSet).RunQuery("web.wanvds2","QueryMRDynaALLData","2009-09-01","2009-09-20")
Query QueryMRDynaALLData(startDate As %String, endDate As %String) As %Query(ROWSPEC = "kPIDese:%String,OpNums:%Float,EpNums:%Float,EpSWNums:%Float,SRNums:%Float,SRSWNums:%Float,HpNums:%Float,QmsyBeds:%Float,QclyRS:%Float,QnryRS:%Float,QnzrRS:%Float,AllPatNums:%Float,OrdLyNums:%Float,OrdZyNums:%Float,OrdZsqNums:%Float,NOrdZyNums:%Float,OrdSwNums:%Float,OrdQtNums:%Float,ZwtkRS:%Float,QmlyRS:%Float,SjkfBedDays:%Float,SjzyBedDays:%Float,CyBedDays:%Float,PjInsDays:%Float,AllFee:%Float,OperNums:%Float,MJAllNums:%Float") [ SqlProc ]
{
}

ClassMethod QueryMRDynaALLDataExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	n (qHandle,startDate,endDate,type)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s kpiCodeStr="EPRMRDepOpNums,EPRMRDepEpNums,EPRMRDepEpSWNums,EPRMRDepSRNums,EPRMRDepSRSWNums,EPRMRDepHpNums,EPRMRDepQmsyBeds,EPRMRDepQclyRS,EPRMRDepQnryRS,EPRMRDepQnzrRS,EPRMRDepAllPatNums,EPRMRDepOrdLyNums,EPRMRDepOrdZyNums,EPRMRDepOrdZsqNums,EPRMRDepNOrdZyNums,EPRMRDepOrdSwNums,EPRMRDepOrdQtNums,EPRMRDepZwtkRS,EPRMRDepQmlyRS,EPRMRDepSjkfBedDays,EPRMRDepSjzyBedDays,EPRMRDepCyBedDays,EPRMRDepInsDays,EPRMRDepAllFee,EPRMRDepOperNums"
    k ^tempDHCWL($j)
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	q:kpiCodeStr="" $$$OK
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	q:monNameStr="" 1
 	Set rset = ##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMutiMonKPIDataByGen")
	Set columns = rset.GetColumnCount()
	Set sc = rset.Execute(monNameStr,kpiCodeStr)
	While (rset.Next())
	{
      s mkpiId=rset.GetData(3)
      s mkpiIdDesc=rset.GetData(4)
      s mdimId=rset.GetData(5)
      s mdimIdDesc=rset.GetData(6)
      s mValue=rset.GetData(7)
      s ^tempDHCWL($j,mdimId,mkpiId)=$G(^tempDHCWL($j,mdimId,mkpiId))+$G(mValue)
	  s ^tempDHCWL($j,"Desc",mdimId)=mdimIdDesc
	}
	Do rset.Close()	
	k mlist
	k plist
	s ind=1
	s kpiIdStr=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStr)
	s kpilen=$L(kpiIdStr,",")
	for i=1:1:kpilen  do
	.s mlist(i)=$P(kpiIdStr,",",i)
	s dimID="" for  s dimID=$O(^tempDHCWL($j,dimID))  Q:dimID=""  do
	.s plist(0)=$G(^tempDHCWL($j,"Desc",dimID))
	.Q:plist(0)=""
	.for i=1:1:kpilen  do
	..s plist(i)=+$g(^tempDHCWL($j,dimID,mlist(i)))
	.s i=kpilen+1
	.s plist(i)=plist(1)+plist(2)
	.if plist(11)'=0 do
	..s plist(23)=$fn(plist(23)/plist(11),"",2)  //平均住院日
	..s plist(24)=$fn(plist(24)/plist(11),"",2)  //人均费用
	.do QueryMRDynaALLData
	k ^tempDHCWL($j)
	Set qHandle=$lb(0,repid,0)
    quit $$$OK
QueryMRDynaALLData
	s Data=$lb(plist(0),plist(1),plist(2),plist(3),plist(4),plist(5),plist(6),plist(7),plist(8),plist(9),plist(10),plist(11),plist(12),plist(13),plist(14),plist(15),plist(16),plist(17),plist(18),plist(19),plist(20),plist(21),plist(22),plist(23),plist(24),plist(25),plist(26)) 
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod QueryMRDynaALLDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMRDynaALLDataExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMRDynaALLDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMRDynaALLDataExecute ]
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

/// Creator：      yu
/// CreatDate：    2013-02-22
/// Description:   30个病种出院情况
/// Table：        DHCWL_MKPI.DHCWLKPIMonths DHCWL_MKPI.DHCWLMKPI
/// Input：        startDate:开始区间,endDate:结束区间
/// Output：       病种名称，出院人数，三日内确诊人数，医嘱离院，医嘱转院，医嘱转社区，非医嘱离院，死亡，其他，手术人数，术后10日死亡人数，术前诊断符合人数，术前疑诊，术前住院日，住院总费用
///                治疗费（非手术治疗项目费，临床物理治疗费，手术治疗费，麻醉费，手术费），药费（西药费，抗菌药费，中成药费，中草药费），出院总住院日，平均住院日
/// Return：      
/// Others：      按照时间段查找,按照疾病维汇总
///               kpiCodeStr字符串里面的指标Code，应该和ROWSPEC返回的串一一对应
/// d ##class(%ResultSet).RunQuery("web.wanvds2","QueryMRDiag30Data","2009-09-01","2009-09-20")
Query QueryMRDiag30Data(startDate As %String, endDate As %String) As %Query(ROWSPEC = "kPIDese:%String,AllPatNums:%Float,In3Days:%Float,OrdLyNums:%Float,OrdZyNums:%Float,OrdZsqNums:%Float,NOrdZyNums:%Float,OrdSwNums:%Float,OrdQtNums:%Float,OperNums:%Float,10DDShswNums:%Float,SqshzdfhNums:%Float,SqshzdyzNums:%Float,PreOpDays:%Float,AllFee:%Float,ZllFsszlxmFee:%Float,ZllLcwlzlFee:%Float,ZllSszlFee:%Float,ZllMzFee:%Float,ZllSsFee:%Float,XylXyFee:%Float,XylKjywFee:%Float,ZylZcyAFee:%Float,ZylZcyBFee:%Float,InsDays:%Float,PjInsDays:%Float") [ SqlProc ]
{
}

ClassMethod QueryMRDiag30DataExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	n (qHandle,startDate,endDate,type)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s kpiCodeStr="EPRMRDiagAllPatNums,EPRMRDiagIn3Days,EPRMRDiagOrdLyNums,EPRMRDiagOrdZyNums,EPRMRDiagOrdZsqNums,EPRMRDiagNOrdZyNums,EPRMRDiagOrdSwNums,EPRMRDiagOrdQtNums,EPRMRDiagOperNums,EPRMRDiag10DDShswNums,EPRMRDiagSqshzdfhNums,EPRMRDiagSqshzdyzNums,EPRMRDiagPreOpDays,EPRMRDiagAllFee,EPRMRDiagZllFsszlxmFee,EPRMRDiagZllLcwlzlFee,EPRMRDiagZllSszlFee,EPRMRDiagZllMzFee,EPRMRDiagZllSsFee,EPRMRDiagXylXyFee,EPRMRDiagXylKjywFee,EPRMRDiagZylZcyAFee,EPRMRDiagZylZcyBFee,EPRMRDiagInsDays"
    k ^tempDHCWL($j)
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	q:kpiCodeStr="" $$$OK
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	q:monNameStr="" 1
 	Set rset = ##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMutiMonKPIDataByGen")
	Set columns = rset.GetColumnCount()
	Set sc = rset.Execute(monNameStr,kpiCodeStr)
	While (rset.Next())
	{
      s mkpiId=rset.GetData(3)
      s mkpiIdDesc=rset.GetData(4)
      s mdimId=rset.GetData(5)
      s mdimIdDesc=rset.GetData(6)
      s mValue=rset.GetData(7)
      s ^tempDHCWL($j,mdimId,mkpiId)=$G(^tempDHCWL($j,mdimId,mkpiId))+$G(mValue)
	  s ^tempDHCWL($j,"Desc",mdimId)=mdimIdDesc
	}
	Do rset.Close()	
	k mlist
	k plist
	s ind=1
	s kpiIdStr=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStr)
	s kpilen=$L(kpiIdStr,",")
	for i=1:1:kpilen  do
	.s mlist(i)=$P(kpiIdStr,",",i)
	s dimID="" for  s dimID=$O(^tempDHCWL($j,dimID))  Q:dimID=""  do
	.s plist(0)=$G(^tempDHCWL($j,"Desc",dimID))
	.Q:plist(0)=""
	.for i=1:1:kpilen  do
	..s plist(i)=+$g(^tempDHCWL($j,dimID,mlist(i)))
	.s i=kpilen+1
	.s plist(i)=0
	.if plist(1)'=0 do
	..s plist(i)=$fn(plist(i-1)/plist(1),"",2)  //平均住院日
	.do QueryMRDiag30Data
	k ^tempDHCWL($j)
	Set qHandle=$lb(0,repid,0)
    quit $$$OK
QueryMRDiag30Data
	s Data=$lb(plist(0),plist(1),plist(2),plist(3),plist(4),plist(5),plist(6),plist(7),plist(8),plist(9),plist(10),plist(11),plist(12),plist(13),plist(14),plist(15),plist(16),plist(17),plist(18),plist(19),plist(20),plist(21),plist(22),plist(23),plist(24),plist(25)) 
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod QueryMRDiag30DataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMRDiag30DataExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMRDiag30DataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMRDiag30DataExecute ]
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

/// Creator：      yu
/// CreatDate：    2013-02-22
/// Description:   疾病分类转归情况
/// Table：        DHCWL_MKPI.DHCWLKPIMonths DHCWL_MKPI.DHCWLMKPI
/// Input：        startDate:开始区间,endDate:结束区间
/// Output：       病种名称，出院人数，手术人数，术前住院日，医嘱离院，医嘱转院，医嘱转社区，非医嘱离院，死亡，其他，
///                年龄段（5岁以下，5-14岁，15-44岁，45-59岁，60岁以上），出院者占用总床日数，住院总费用
/// Return：      
/// Others：      按照时间段查找,按照疾病维汇总
///               kpiCodeStr字符串里面的指标Code，应该和ROWSPEC返回的串一一对应
/// d ##class(%ResultSet).RunQuery("web.wanvds2","QueryMRDiagData","2009-09-01","2009-09-20")
Query QueryMRDiagData(startDate As %String, endDate As %String) As %Query(ROWSPEC = "kPIDese:%String,AllPatNums:%Float,OperNums:%Float,PreOpDays:%Float,OrdLyNums:%Float,OrdZyNums:%Float,OrdZsqNums:%Float,NOrdZyNums:%Float,OrdSwNums:%Float,OrdQtNums:%Float,Un5Nums:%Float,Un15Nums:%Float,Un45Nums:%Float,Un60Nums:%Float,Up60Nums:%Float,InsDays:%Float,AllFee:%Float") [ SqlProc ]
{
}

ClassMethod QueryMRDiagDataExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	n (qHandle,startDate,endDate,type)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s kpiCodeStr="EPRMRDiagAllPatNums,EPRMRDiagOperNums,EPRMRDiagPreOpDays,EPRMRDiagOrdLyNums,EPRMRDiagOrdZyNums,EPRMRDiagOrdZsqNums,EPRMRDiagNOrdZyNums,EPRMRDiagOrdSwNums,EPRMRDiagOrdQtNums,EPRMRDiagUn5Nums,EPRMRDiagUn15Nums,EPRMRDiagUn45Nums,EPRMRDiagUn60Nums,EPRMRDiagUp60Nums,EPRMRDiagInsDays,EPRMRDiagAllFee"
    k ^tempDHCWL($j)
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	q:kpiCodeStr="" $$$OK
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	q:monNameStr="" 1
 	Set rset = ##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMutiMonKPIDataByGen")
	Set columns = rset.GetColumnCount()
	Set sc = rset.Execute(monNameStr,kpiCodeStr)
	While (rset.Next())
	{
      s mkpiId=rset.GetData(3)
      s mkpiIdDesc=rset.GetData(4)
      s mdimId=rset.GetData(5)
      s mdimIdDesc=rset.GetData(6)
      s mValue=rset.GetData(7)
      s ^tempDHCWL($j,mdimId,mkpiId)=$G(^tempDHCWL($j,mdimId,mkpiId))+$G(mValue)
	  s ^tempDHCWL($j,"Desc",mdimId)=mdimIdDesc
	}
	Do rset.Close()	
	k mlist
	k plist
	s ind=1
	s kpiIdStr=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStr)
	s kpilen=$L(kpiIdStr,",")
	for i=1:1:kpilen  do
	.s mlist(i)=$P(kpiIdStr,",",i)
	s dimID="" for  s dimID=$O(^tempDHCWL($j,dimID))  Q:dimID=""  do
	.s plist(0)=$G(^tempDHCWL($j,"Desc",dimID))
	.Q:plist(0)=""
	.for i=1:1:kpilen  do
	..s plist(i)=+$g(^tempDHCWL($j,dimID,mlist(i)))
	.do QueryMRDiagData
	k ^tempDHCWL($j)
	Set qHandle=$lb(0,repid,0)
    quit $$$OK
QueryMRDiagData
	s Data=$lb(plist(0),plist(1),plist(2),plist(3),plist(4),plist(5),plist(6),plist(7),plist(8),plist(9),plist(10),plist(11),plist(12),plist(13),plist(14),plist(15),plist(16)) 
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod QueryMRDiagDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMRDiagDataExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMRDiagDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMRDiagDataExecute ]
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

/// Creator：      yu
/// CreatDate：    2013-02-22
/// Description:   损伤中毒转归情况
/// Table：        DHCWL_MKPI.DHCWLKPIMonths DHCWL_MKPI.DHCWLMKPI
/// Input：        startDate:开始区间,endDate:结束区间
/// Output：       病种名称，出院人数，手术人数，术前住院日，医嘱离院，医嘱转院，医嘱转社区，非医嘱离院，死亡，其他，
///                年龄段（5岁以下，5-14岁，15-44岁，45-59岁，60岁以上），出院者占用总床日数，住院总费用
/// Return：      
/// Others：      按照时间段查找,按照疾病维汇总
///               kpiCodeStr字符串里面的指标Code，应该和ROWSPEC返回的串一一对应
/// d ##class(%ResultSet).RunQuery("web.wanvds2","QueryMRPoisonData","2009-09-01","2009-09-20")
Query QueryMRPoisonData(startDate As %String, endDate As %String) As %Query(ROWSPEC = "kPIDese:%String,AllPatNums:%Float,OperNums:%Float,PreOpDays:%Float,OrdLyNums:%Float,OrdZyNums:%Float,OrdZsqNums:%Float,NOrdZyNums:%Float,OrdSwNums:%Float,OrdQtNums:%Float,Un5Nums:%Float,Un15Nums:%Float,Un45Nums:%Float,Un60Nums:%Float,Up60Nums:%Float,InsDays:%Float,AllFee:%Float") [ SqlProc ]
{
}

ClassMethod QueryMRPoisonDataExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	n (qHandle,startDate,endDate,type)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s kpiCodeStr="EPRMRPoisonAllPatNums,EPRMRPoisonOperNums,EPRMRPoisonPreOpDays,EPRMRPoisonOrdLyNums,EPRMRPoisonOrdZyNums,EPRMRPoisonOrdZsqNums,EPRMRPoisonNOrdZyNums,EPRMRPoisonOrdSwNums,EPRMRPoisonOrdQtNums,EPRMRPoisonUn5Nums,EPRMRPoisonUn15Nums,EPRMRPoisonUn45Nums,EPRMRPoisonUn60Nums,EPRMRPoisonUp60Nums,EPRMRPoisonInsDays,EPRMRPoisonAllFee"
    k ^tempDHCWL($j)
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	q:kpiCodeStr="" $$$OK
 	s monIdStr=""
	s monNameStr=##class(DHCWL.MKPIService.ComputerDate).GetMudDay(startDate,endDate)
	q:monNameStr="" 1
 	Set rset = ##class(%ResultSet).%New("DHCWL.MKPIService.MKPIQuery:QueryMutiMonKPIDataByGen")
	Set columns = rset.GetColumnCount()
	Set sc = rset.Execute(monNameStr,kpiCodeStr)
	While (rset.Next())
	{
      s mkpiId=rset.GetData(3)
      s mkpiIdDesc=rset.GetData(4)
      s mdimId=rset.GetData(5)
      s mdimIdDesc=rset.GetData(6)
      s mValue=rset.GetData(7)
      s ^tempDHCWL($j,mdimId,mkpiId)=$G(^tempDHCWL($j,mdimId,mkpiId))+$G(mValue)
	  s ^tempDHCWL($j,"Desc",mdimId)=mdimIdDesc
	}
	Do rset.Close()	
	k mlist
	k plist
	s ind=1
	s kpiIdStr=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCodeStr)
	s kpilen=$L(kpiIdStr,",")
	for i=1:1:kpilen  do
	.s mlist(i)=$P(kpiIdStr,",",i)
	s dimID="" for  s dimID=$O(^tempDHCWL($j,dimID))  Q:dimID=""  do
	.s plist(0)=$G(^tempDHCWL($j,"Desc",dimID))
	.Q:plist(0)=""
	.for i=1:1:kpilen  do
	..s plist(i)=+$g(^tempDHCWL($j,dimID,mlist(i)))
	.do QueryMRPoisonData
	k ^tempDHCWL($j)
	Set qHandle=$lb(0,repid,0)
    quit $$$OK
QueryMRPoisonData
	s Data=$lb(plist(0),plist(1),plist(2),plist(3),plist(4),plist(5),plist(6),plist(7),plist(8),plist(9),plist(10),plist(11),plist(12),plist(13),plist(14),plist(15),plist(16)) 
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	q
}

ClassMethod QueryMRPoisonDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMRPoisonDataExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMRPoisonDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMRPoisonDataExecute ]
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

}
