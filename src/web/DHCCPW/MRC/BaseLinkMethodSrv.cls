/// 名称: web.DHCCPW.MRC.BaseLinkMethodSrv
/// 描述: 临床路径关联项目函数库相关
/// 编写者：zhufei
/// 编写日期: 2012-02-08
Class web.DHCCPW.MRC.BaseLinkMethodSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-03-18
/// Description:  2012-02-08
/// Table：       DHCMRCBaseLinkMethodPackage
///               DHCMRCBaseLinkMethodDic
/// Input：       
/// Return：      返回树形结构json串
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseLinkMethodSrv","BuildMethodJson","","")
Query BuildMethodJson(argNodeID As %String, argOutFormat As %String) As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String,checked:%String,icon:%String,qtip:%String")
{
}

ClassMethod BuildMethodJsonExecute(ByRef qHandle As %Binary, argNodeID As %String, argOutFormat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set Type=$p(argNodeID,"-",2)
	If Type="root" {
		Set PackageID=0
		For {
			Set PackageID=$o(^DHCMRC("BLMP",PackageID))
			Quit:PackageID=""
			Set objPackage=##class(User.DHCMRCBaseLinkMethodPackage).GetObjById(PackageID)
			If $IsObject(objPackage){
				Set NodeID=PackageID_"-Package-"
				Set Desc=objPackage.BLMPName
				Set Resume=objPackage.BLMPResumeText
				Set:Resume'="" Desc=Desc_"("_Resume_")"
				Set Data=""
				Set $li(Data,1)=$c(34)_NodeID_$c(34)
				Set $li(Data,2)=$c(34)_Desc_$c(34)
				Set $li(Data,3)="false"
				Set $li(Data,4)="null"
				Set $li(Data,5)=$c(34)_"../images/websys/zreports.gif"_$c(34)
				Set $li(Data,6)=$c(34)_""_$c(34)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		If ($o(^DHCMRC("BLMP",0))="")&&(argOutFormat=1) {
			Set NodeID="0-Package-"
			Set Desc="请维护包名..."
			Set Data=""
			Set $li(Data,1)=$c(34)_NodeID_$c(34)
			Set $li(Data,2)=$c(34)_Desc_$c(34)
			Set $li(Data,3)="true"
			Set $li(Data,4)="null"
			Set $li(Data,5)=$c(34)_"../images/websys/zreports.gif"_$c(34)
			Set $li(Data,6)=$c(34)_""_$c(34)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}ElseIf Type="Package" {
		Set PackageID=$p(argNodeID,"-",1)
		Set MethodID=0
		For {
			Set MethodID=$o(^DHCMRCi("BLMD",0,"BLMDPackageIDIndex",PackageID,MethodID))
			Quit:MethodID=""
			Set objMethod=##class(User.DHCMRCBaseLinkMethodDic).GetObjById(MethodID)
			If $IsObject(objMethod){
				Set NodeID=MethodID_"-Method-"_PackageID
				Set Desc=objMethod.BLMDName
				Set Resume=objMethod.BLMDResumeText
				Set Data=""
				Set $li(Data,1)=$c(34)_NodeID_$c(34)
				Set $li(Data,2)=$c(34)_Desc_$c(34)
				Set $li(Data,3)="true"
				Set $li(Data,4)="null"
				Set $li(Data,5)=$c(34)_"../images/websys/report.gif"_$c(34)
				Set $li(Data,6)=$c(34)_Resume_$c(34)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		If ($o(^DHCMRCi("BLMD",0,"BLMDPackageIDIndex",PackageID,0))="")&&(argOutFormat=1) {
			Set NodeID="0-Method-"_PackageID
			Set Desc="请维护函数..."
			Set Data=""
			Set $li(Data,1)=$c(34)_NodeID_$c(34)
			Set $li(Data,2)=$c(34)_Desc_$c(34)
			Set $li(Data,3)="true"
			Set $li(Data,4)="null"
			Set $li(Data,5)=$c(34)_"../images/websys/report.gif"_$c(34)
			Set $li(Data,6)=$c(34)_""_$c(34)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod BuildMethodJsonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BuildMethodJsonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod BuildMethodJsonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BuildMethodJsonExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  通过名称查询方法包信息
/// Table：       DHCMRCBaseLinkMethodPackage
/// Input：       Name
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseLinkMethodSrv","QryPackage","")
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
		Set PackageID=$o(^DHCMRC("BLMP",PackageID))
		Quit:PackageID=""
		Set objPackage=##class(User.DHCMRCBaseLinkMethodPackage).GetObjById(PackageID)
		If $IsObject(objPackage){
			Set Code=objPackage.BLMPCode
			Set Name=objPackage.BLMPName
			Continue:(argName'="")&&(Name'=argName)
			Set IsActive=objPackage.BLMPIsActive
			Set Active=$s(IsActive=0:"否",1:"是")
			Set ResumeText=objPackage.BLMPResumeText
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

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  通过名称查询暴露函数
/// Table：       User.DHCMRCBaseLinkMethodDic
/// Input：       Name
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseLinkMethodSrv","QueryMethodDic","1","")
Query QueryMethodDic(argPackageID As %String, argName As %String) As %Query(ROWSPEC = "rowid:%String,Name:%String,ClassMetohd:%String,IsActive:%String,IsActiveDesc:%String,ResumeText:%String,DefaultValue:%String")
{
}

ClassMethod QueryMethodDicExecute(ByRef qHandle As %Binary, argPackageID As %String, argName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:argPackageID="" $$$OK
	Set MethodID=0
	For {
		Set MethodID=$o(^DHCMRCi("BLMD",0,"BLMDPackageIDIndex",argPackageID,MethodID))
		Quit:MethodID=""
		Set objMethod=##class(User.DHCMRCBaseLinkMethodDic).GetObjById(MethodID)
		If $IsObject(objMethod){
			Set Name=objMethod.BLMDName
			Set Method=objMethod.BLMDClassMethod
			Set IsActive=objMethod.BLMDIsActive
			Set Active=$s(IsActive=0:"否",1:"是")
			Set ResumeText=objMethod.BLMDResumeText
			Set ReturnValue=objMethod.BLMDDefaultValue
			Set Data=$lb(MethodID,Name,Method,IsActive,Active,ResumeText,ReturnValue)
			Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QueryMethodDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMethodDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMethodDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMethodDicExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  构造函数库应用json串
/// Table：       User.DHCMRCBaseLinkMethodPackage
///               User.DHCMRCBaseLinkMethodDic
/// Input：       
/// Return：      返回树形结构json串
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseLinkMethodSrv","BuildMethodAppJson","root","")
Query BuildMethodAppJson(argNodeID As %String, argOutFormat As %String) As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String,checked:%String,icon:%String,qtip:%String")
{
}

ClassMethod BuildMethodAppJsonExecute(ByRef qHandle As %Binary, argNodeID As %String, argOutFormat As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set Type=$p(argNodeID,"-",2)
	If (Type="root")||(Type="") {
		Set PackageID=0
		For {
			Set PackageID=$o(^DHCMRC("BLMP",PackageID))
			Quit:PackageID=""
			Set objPackage=##class(User.DHCMRCBaseLinkMethodPackage).GetObjById(PackageID)
			If $IsObject(objPackage){
				Set NodeID=PackageID_"-Package-"
				Set Desc=objPackage.BLMPName
				Set Resume=objPackage.BLMPResumeText
				Set IsActive=objPackage.BLMPIsActive
				Continue:IsActive=0
				Set:Resume'="" Desc=Desc_"("_Resume_")"
				If $o(^DHCMRCi("BLMD",0,"BLMDPackageIDIndex",PackageID,0))="" {
					Set Leaf="true"
				}Else{
					Set Leaf="false"  //有子节点
				}
				Set Data=""
				Set $li(Data,1)=$c(34)_NodeID_$c(34)
				Set $li(Data,2)=$c(34)_Desc_$c(34)
				Set $li(Data,3)=Leaf
				Set $li(Data,4)="null"
				Set $li(Data,5)=$c(34)_"../images/websys/zreports.gif"_$c(34)
				Set $li(Data,6)=$c(34)_""_$c(34)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}ElseIf Type="Package" {
		Set PackageID=$p(argNodeID,"-",1)
		Set MethodID=0
		For {
			Set MethodID=$o(^DHCMRCi("BLMD",0,"BLMDPackageIDIndex",PackageID,MethodID))
			Quit:MethodID=""
			Set objMethod=##class(User.DHCMRCBaseLinkMethodDic).GetObjById(MethodID)
			If $IsObject(objMethod){
				Set NodeID=MethodID_"-Method-"_PackageID
				Set Desc=objMethod.BLMDName
				Set IsActive=objMethod.BLMDIsActive
				Continue:IsActive=0
				Set Resume=objMethod.BLMDResumeText
				Set Data=""
				Set $li(Data,1)=$c(34)_NodeID_$c(34)
				Set $li(Data,2)=$c(34)_Desc_$c(34)
				Set $li(Data,3)="true"
				Set $li(Data,4)="null"
				Set $li(Data,5)=$c(34)_"../images/websys/report.gif"_$c(34)
				Set $li(Data,6)=$c(34)_Resume_$c(34)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod BuildMethodAppJsonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BuildMethodAppJsonExecute ]
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

ClassMethod BuildMethodAppJsonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BuildMethodAppJsonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 创建者:zhufei
/// 功能：根据MethodDic的Rowid组织关联项目表达式的类库函数声明
/// 返回关联项目表达式中用的类库调用声明
/// w ##class(web.DHCCPW.MRC.BaseLinkMethodSrv).GetLibName(1)
ClassMethod GetLibName(argMethodID As %String) As %String
{
	New (argMethodID)
	Set return=""
	Quit:argMethodID="" return
	
	Set $ZT="GetLibNameErr"
	Set objMethod=##class(User.DHCMRCBaseLinkMethodDic).GetObjById(argMethodID)
	Quit:'$IsObject(objMethod) return
	Set objPackage=objMethod.BLMDPackageID
	Quit:'$IsObject(objPackage) return
	Set PackageName=objPackage.BLMPName
	Set MethodName=objMethod.BLMDName
	Set ClassMethod=objMethod.BLMDClassMethod
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
