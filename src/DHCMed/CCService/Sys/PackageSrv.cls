/// 名称: DHCMed.CCService.Sys.PackageSrv
/// 编写者：liuyh
/// 编写日期: 2010-09-025
Class DHCMed.CCService.Sys.PackageSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-09-25
/// Description:  通过名称查询方法包信息
/// 
/// Table：       DHCMed.CCService.Sys.MethodPackage
/// Input：       Name
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.PackageSrv","QryPackage","")
Query QryPackage(argName As %String) As %Query(ROWSPEC = "rowid:%String,Code:%String,Name:%String,IsActive:%String,IsActiveDesc:%String,ResumeText:%String")
{
}

ClassMethod QryPackageExecute(ByRef qHandle As %Binary, argName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set PackageID=0
	For {
		Set PackageID=$o(^DHCMed.CCF("Package",PackageID))
		Quit:PackageID=""
		Set objPackage=##class(DHCMed.CC.MethodPackage).GetObjById(PackageID)
		If $IsObject(objPackage){
			Set Code=objPackage.Code
			Set Name=objPackage.Name
			Continue:(argName'="")&&(Name'=argName)
			Set IsActive=objPackage.IsActive
			Set Active=$s(IsActive=0:"否",1:"是")
			Set ResumeText=objPackage.ResumeText
			Set Data=$lb(PackageID,Code,Name,IsActive,Active,ResumeText)
			Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryPackageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPackageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPackageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPackageExecute ]
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
/// Table：       DHCMed.CCService.Sys.MethodInfo
/// Input：       Name
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.Sys.PackageSrv","QueryMethodInfo","1","")
Query QueryMethodInfo(argPackageID As %String, argName As %String) As %Query(ROWSPEC = "rowid:%String,Name:%String,ClassMetohd:%String,IsActive:%String,IsActiveDesc:%String,ResumeText:%String,DefaultReturnValue:%String")
{
}

ClassMethod QueryMethodInfoExecute(ByRef qHandle As %Binary, argPackageID As %String, argName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:argPackageID="" $$$OK
	Set MethodID=0
	For {
		Set MethodID=$o(^DHCMed.CCFi("PMethod",0,"PackageIDIndex",argPackageID,MethodID))
		Quit:MethodID=""
		Set objMethod=##class(DHCMed.CC.MethodInfo).GetObjById(MethodID)
		If $IsObject(objMethod){
			Set Name=objMethod.Name
			Set Method=objMethod.ClassMethod
			Set IsActive=objMethod.IsActive
			Set Active=$s(IsActive=0:"否",1:"是")
			Set ResumeText=objMethod.ResumeText
			Set ReturnValue=objMethod.DefaultReturnValue
			Set Data=$lb(MethodID,Name,Method,IsActive,Active,ResumeText,ReturnValue)
			Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
	}
	Quit $$$OK
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

/// 创建者:李阳
/// 功能：根据MethodInfo的Rowid组织监控表达式的类库函数声明
/// 返回监控表达式中用的类库调用声明
/// w ##class(DHCMed.CCService.Sys.PackageSrv).GetLibName(1)
ClassMethod GetLibName(argMethodID As %String) As %String
{
	New (argMethodID)
	Set return=""
	Quit:argMethodID="" return
	
	Set $ZT="GetLibNameErr"
	Set objMethod=##class(DHCMed.CC.MethodInfo).GetObjById(argMethodID)
	Quit:'$IsObject(objMethod) return
	Set PackageID=objMethod.PackageID
	Set objPackage=##class(DHCMed.CC.MethodPackage).GetObjById(PackageID)
	Quit:'$IsObject(objPackage) return
	Set PackageName=objPackage.Name
	Set MethodName=objMethod.Name
	Set ClassMethod=objMethod.ClassMethod
	Set return="#"_PackageName_"."_MethodName
	Set intPos=..Instr(ClassMethod,"(",1)
	Set return=return_$e(ClassMethod,intPos,$l(ClassMethod))
	Quit return
	
GetLibNameErr
	Write "Error:"_$ZERROR
	Quit ""
}

ClassMethod Instr(argExp As %String, argStr As %String, argStart As %String) As %String
{
		New (argExp,argStr,argStart)
		Set return=-1
		Quit:(argStr="")||(argExp="") return
		Set lenStr=$l(argStr)
		For ind=argStart:1:($l(argExp)-lenStr)
		{
			Set tmp=$e(argExp,ind,ind+lenStr-1)
			If tmp=argStr
			{
				Set return=ind
				Continue
			}
		}
		Quit return
}

}
