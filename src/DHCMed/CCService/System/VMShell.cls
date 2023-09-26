/// 创建者：李阳
/// 创建日期：2010-09-28
/// 功能：
/// 1.将VM输出的内容组织成Query传出
/// 2.负责组织数据
Class DHCMed.CCService.System.VMShell Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 按照指定的监控主题运行VM进行监控,并组织数据输出
/// RuleID:监控主题
/// PaadmList:需要监控的Paadm列表
Query RunVM(SubjectID As %String, PaadmStoreRepid As %String, SubjectItmIDList As %String) As %Query(ROWSPEC = "PatientID:%String,Paadm:%String,TotalScore:%String:总分数,FiredItemCnt:%String:触发项目数量,FiredTypeCnt:%String:触发类型数量,FiredType:%String:触发的类别,ItemDic:%String:监控条目,Detail:%String:详情")
{
}

ClassMethod RunVMExecute(ByRef qHandle As %Binary, SubjectID As %String, PaadmStoreRepid As %String, SubjectItmIDList As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	
	s ret=##class(DHCMed.CCService.System.VM).Process(SubjectID,PaadmStoreRepid,SubjectItmIDList)
	;b
	q:$li(ret,1)'="OK" $$$OK
	s handle=$li(ret,2)
	///PatientID:%String,Paadm:%String,TotalScore:%String:总分数,FiredItemCnt:%String:触发项目数量,FiredTypeCnt:%String:触发类型数量,
	///FiredType:%String:触发的类别,ItemDic:%String:监控条目,Detail:%String:详情
	s paadm="" f  s paadm=$o(^CacheTemp(handle,"Paadm",paadm)) q:paadm=""  d
	.s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	.d objAdm.%Close()
	.s summaryInfo=$g(^CacheTemp(handle,"Paadm",paadm))
	.s data=$$EmptyList(8)
	.s $li(data,1)=objAdm.PatientID //patientID
	.s $li(data,2)=paadm //paadm
	.s $li(data,3)=$p(summaryInfo,"^",1) //总分
	.s $li(data,4)=$p(summaryInfo,"^",2) //触发数量
	.s $li(data,5)=$p(summaryInfo,"^",3) //触发类型数量
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	.s itemDicRowID="" f  s itemDicRowID=$o(^CacheTemp(handle,"Paadm",paadm,"Detail",itemDicRowID)) q:itemDicRowID=""  d
	..s itemDic=##class(DHCMed.CC.ItemDic).%OpenId(itemDicRowID)
	..d itemDic.%Close()
	..s itemSubCat=##class(DHCMed.CC.ItemSubCat).%OpenId(itemDic.IDSubCatDr)
	..d itemSubCat.%Close()
	..s intCounter="" f  s intCounter=$o(^CacheTemp(handle,"Paadm",paadm,"Detail",itemDicRowID,intCounter)) q:intCounter=""  d
	...s data=$$EmptyList(8)
	...s $li(data,6)=itemSubCat.ISCDesc
	...s $li(data,7)=itemDic.IDDesc
	...s $li(data,8)=$g(^CacheTemp(handle,"Paadm",paadm,"Detail",itemDicRowID,intCounter))
	...s ^CacheTemp(repid,ind)=data
	...s ind=ind+1
	..s itemDic=""
	..s itemSubCat=""
	..k itemDic
	..k itemSubCat
	..k objAdm
	k ^CacheTemp(handle)
	Quit $$$OK
EmptyList(num)
	n (num)
	s data=$lb("")
	f i=1:1:num  d
	.s $li(data,i)=""
	q data
}

ClassMethod RunVMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RunVMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod RunVMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RunVMExecute ]
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

/// 创建存储ID
ClassMethod CreateStoreID()
{
	q $I(^CacheTemp)
}

ClassMethod SaveStorePaadm(StoreID, Paadm)
{
	n (StoreID,Paadm)
	s ind=$o(^CacheTemp(StoreID,""),-1)
	s ind=ind+1
	s ^CacheTemp(StoreID,ind)=Paadm
	q "OK"
}

ClassMethod DeleteStorePaadm(StoreID)
{
	n (StoreID)
	k ^CacheTemp(StoreID)
	q "OK"
}

ClassMethod Test()
{
	// w ##class(DHCMed.CCService.System.VMShell).Test()
	k ^CacheTemp
	s storeID=..CreateStoreID()
	d ..SaveStorePaadm(storeID,50729)
	d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.System.VMShell","RunVM",1,storeID,"")
	d ..DeleteStorePaadm(storeID)
	q ""
}

}
