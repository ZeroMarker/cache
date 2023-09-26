/// 名称: DHCMed.CCService.MethodPackageSrv
/// 编写者：liuyh
/// 编写日期: 2010-09-025
Class DHCMed.CCService.MethodPackageSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-09-25
/// Description:  通过名称查询方法包信息
/// Table：       DHCMed.CCService.MethodPackage
/// Input：       Name
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.MethodPackageSrv","QueryMethodPackageInfo","")
Query QueryMethodPackageInfo(Name As %String) As %Query(ROWSPEC = "rowid:%String,Code:%String,Name:%String,IsActive:%String,IsActiveDesc:%String,ResumeText:%String")
{
}

ClassMethod QueryMethodPackageInfoExecute(ByRef qHandle As %Binary, Name As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s rowid=""
	f  s rowid=$o(^DHCMed.CC.MethodPackageD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.MethodPackage).%OpenId(rowid)
	.q:((Name'="")&(obj.Name'[Name))
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.Code
	.s $li(data,3)=obj.Name
	.s $li(data,4)=obj.IsActive
	.s $li(data,5)="是"
	.s:obj.IsActive=0 $li(data,5)="否"
	.s $li(data,6)=obj.ResumeText
 	.s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .d obj.%Close()
	q $$$OK
}

ClassMethod QueryMethodPackageInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMethodPackageInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMethodPackageInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMethodPackageInfoExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2010-09-27
/// Description:  通过名称查询暴露函数
/// Table：       DHCMed.CCService.MethodInfo
/// Input：       Name
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.MethodPackageSrv","QueryMethodInfo","")
Query QueryMethodInfo(PackageID As %String, Name As %String) As %Query(ROWSPEC = "rowid:%String,Name:%String,ClassMetohd:%String,IsActive:%String,IsActiveDesc:%String,ResumeText:%String,DefaultReturnValue:%String")
{
}

ClassMethod QueryMethodInfoExecute(ByRef qHandle As %Binary, PackageID As %String, Name As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:PackageID="" $$$OK
	s rowid=""
	f  s rowid=$o(^DHCMed.CC.MethodInfoD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.CC.MethodInfo).%OpenId(rowid)
	.q:PackageID'=obj.PackageID
	.q:((Name'="")&(obj.Name'[Name))
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.Name
	.s $li(data,3)=obj.ClassMethod
	.s $li(data,4)=obj.IsActive
	.s $li(data,5)="是"
	.s:obj.IsActive=0 $li(data,5)="否"
	.s $li(data,6)=obj.ResumeText
	.s $li(data,7)=obj.DefaultReturnValue
 	.s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .d obj.%Close()
	q $$$OK
}

ClassMethod QueryMethodInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMethodInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMethodInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMethodInfoExecute ]
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

Query QueryPackageMethod(tmp As %String, checkBox As %String) As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String,checked:%String,icon:%String,qtip:%String")
{
}

ClassMethod QueryPackageMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPackageMethodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPackageMethodExecute(ByRef qHandle As %Binary, tmp As %String, checkBox As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	i tmp="0"  d
	.s PackageName=""
	.s PackageName="" f  s PackageName=$o(^DHCMed.CC.MethodPackageI("NameIndex",PackageName)) q:PackageName=""  d
	..s rowid=$o(^DHCMed.CC.MethodPackageI("NameIndex",PackageName,""))
	..s objPackage=##class(DHCMed.CC.MethodPackage).%OpenId(rowid)		//add by liuyh 2010-10-12 显示函数库包名
	..s PackageResume=objPackage.ResumeText
	..s hasMethod=0
	..s methodID="" f  s methodID=$o(^DHCMed.CC.MethodInfoI("PackageIDIndex",rowid,methodID)) q:methodID=""  d
	...s hasMethod=1
	..q:hasMethod=0
	..s data=$$BuildPackageData(rowid,PackageName,'hasMethod,PackageResume)
	..s ^CacheTemp(repid,ind)=data
	..s ind=ind+1
	i tmp>0  d
	.s rowid="" f  s rowid=$o(^DHCMed.CC.MethodInfoI("PackageIDIndex",+tmp,rowid)) q:rowid=""  d
	..s objMethod=##class(DHCMed.CC.MethodInfo).%OpenId(rowid)
	..d objMethod.%Close()
	..s isActive=objMethod.IsActive
	..s MethodName=objMethod.Name
	..s resumeText=objMethod.ResumeText
	..s objMethod=""
	..k objMethod
	..q:isActive=0
	..s data=$$BuildMethodData(rowid,MethodName,resumeText)
	..s ^CacheTemp(repid,ind)=data
	..s ind=ind+1	
	Quit $$$OK
BuildPackageData(PackageID,PackageName,IsLeaf,PackageResume)
	n (PackageID,PackageName,IsLeaf,PackageResume)
	s data=$lb("")
	s $li(data,1)=$c(34)_PackageID_$c(34)
	s $li(data,2)=$c(34)_PackageName_$c(34)
	s $li(data,3)=IsLeaf
	s $li(data,4)="null"
	s $li(data,5)=$c(34)_"../images/websys/zreports.gif"_$c(34)
	s $li(data,6)=$c(34)_PackageResume_$c(34)
	q data
BuildMethodData(rowid,MethodName,resumeText)
	n (rowid,MethodName,resumeText)
	s data=$lb("")
	s $li(data,1)=$c(34)_"M-"_rowid_$c(34)
	s $li(data,2)=$c(34)_MethodName_$c(34)
	s $li(data,3)="true"
	s $li(data,4)="null"
	s $li(data,5)=$c(34)_"../images/websys/report.gif"_$c(34)
	s $li(data,6)=$c(34)_resumeText_$c(34)
	q data
}

ClassMethod QueryPackageMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPackageMethodExecute ]
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

ClassMethod Instr(exp, str, start)
{
		n (exp,str,start)
		//w %var,!
		q:str=""!exp="" -1
		s len=$l(str)
		s ret=-1
		f i=start:1:($l(exp)-len)  d
		.s tmp=$extract(exp,i,i+len-1)
		.i tmp=str  d
		..s ret=i
		..q
		q ret
}

/// 创建者:李阳
/// 功能：根据MethodInfo的Rowid组织监控表达式的类库函数声明
/// 返回监控表达式中用的类库调用声明
/// w ##class(DHCMed.CCService.MethodPackageSrv).GetLibName(1)
ClassMethod GetLibName(MethodID)
{
	n (MethodID)
	q:##class(DHCMed.CC.MethodInfo).%ExistsId(MethodID)=0 ""
	s objMethod=##class(DHCMed.CC.MethodInfo).%OpenId(MethodID)
	d objMethod.%Close()
	s objPackage=##class(DHCMed.CC.MethodPackage).%OpenId(objMethod.PackageID)
	d objPackage.%Close()
	s ret="#"_objPackage.Name_"."_objMethod.Name
	s intPos=..Instr(objMethod.ClassMethod,"(",1)
	s ret=ret_$extract(objMethod.ClassMethod,intPos,$l(objMethod.ClassMethod))
	s objMethod=""
	k objMethod
	s objPackage=""
	k objPackage
	q ret
}

}
