/// 名称: web.DHCCPW.MRC.BaseDicSubCategory
/// 描述：基础字典项目子类相关操作
/// 编写者：zhufei
/// 编写日期：2011-04-24
Class web.DHCCPW.MRC.BaseDicSubCategory Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-04-24
/// Description:  根据ID取基础字典项目子类
/// Table：       User.DHCMRCBaseDicSubCategory
/// Input：       ID:    User.DHCMRCBaseDicSubCategory.ID
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.BaseDicSubCategory).GetObjById("1||1")
ClassMethod GetObjById(argId As %String) As User.DHCMRCBaseDicSubCategory
{
	New (argId)
	Set return=##Class(User.DHCMRCBaseDicSubCategory).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator:      zhufei
/// CreatDate:    2011-04-24
/// Description:  取基础字典项目子类所有记录
/// Table:        User.DHCMRCBaseDicSubCategory
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseDicSubCategory","QrySubCategory","")
Query QrySubCategory(argCategID As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,CategID:%String,CategDesc:%String,Type:%String,MultiSelect:%String")
{
}

ClassMethod QrySubCategoryExecute(ByRef qHandle As %Binary, argCategID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set CategID=0
	For {
		Set CategID=$o(^DHCMRC("BDC",CategID))
		Quit:CategID=""
		Continue:(argCategID'="")&&(argCategID'=CategID)
		Set CategSub=0
		For {
			Set CategSub=$o(^DHCMRC("BDC",CategID,"SUB",CategSub))
			Quit:CategSub=""
			Set CategSubID=CategID_"||"_CategSub
			Set objCategSub=##class(web.DHCCPW.MRC.BaseDicSubCategory).GetObjById(CategSubID)
			If $IsObject(objCategSub) {
				Set Code=objCategSub.BDSCCode
				Set Desc=objCategSub.BDSCDesc
				Set CategDesc=objCategSub.BDSCParRef.BDCDesc
				Set Type=objCategSub.BDSCType    //add by wuqk 2011-09-16
				Set MultiSelect=objCategSub.BDSCMultiSelect
				
				Set Data=$lb(CategSubID,Code,Desc,CategID,CategDesc,Type,MultiSelect)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QrySubCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySubCategoryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QrySubCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySubCategoryExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##Class(web.DHCCPW.MRC.BaseDicSubCategory).CheckCode("01-01","1||1")
ClassMethod CheckCode(argCode As %String, argCategSubID As %String)
{
	New (argCode,argCategSubID)
	Set return=0
	Quit:argCode="" return
	
	Set CategID=0
	For {
		Set CategID=$o(^DHCMRC("BDC",CategID))
		Quit:(CategID="")||(return=1)
		
		Set CategSub=0
		For {
			Set CategSub=$o(^DHCMRC("BDC",CategID,"SUB",CategSub))
			Quit:(CategSub="")||(return=1)
			Set CategSubID=CategID_"||"_CategSub
			Continue:(argCategSubID'="")&&(argCategSubID=CategSubID)
			Set objCategSub=##class(web.DHCCPW.MRC.BaseDicSubCategory).GetObjById(CategSubID)
			If $IsObject(objCategSub){
				Set Code=objCategSub.BDSCCode
				Continue:argCode'=Code
				Set return=1
			}
		}
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-04-24
/// Description:  保存基础字典项目子类
/// Table：       User.DHCMRCBaseDicSubCategory
/// Input：       argInPut: 基础字典项目子类数据
/// Return：      return<0: 保存失败
/// w ##Class(web.DHCCPW.MRC.BaseDicSubCategory).Update(argInput)
ClassMethod Update(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set ParRef=$p($p(argInput,"^",1),"||",1)
	Quit:ParRef="" return
	Set ChildSub=$p($p(argInput,"^",1),"||",2)
	If ChildSub="" {
		Set obj=##class(User.DHCMRCBaseDicSubCategory).%New()
	} Else {
		Set ID=ParRef_"||"_ChildSub
		Set obj=##class(User.DHCMRCBaseDicSubCategory).%OpenId(ID)
		Quit:obj="" return
	}
	
	Set objParRef=##Class(User.DHCMRCBaseDicCategory).%OpenId(ParRef)
	If objParRef'="" Do objParRef.%Close()
	
	Set Code=$p(argInput,"^",2)
	Set Desc=$p(argInput,"^",3)
	Set Type=$p(argInput,"^",4)        //add by wuqk 2011-09-16
	Set MultiSelect=$p(argInput,"^",5)
	Quit:(Code="")||(Desc="")||(objParRef="")||(Type="") return
	
	Set obj.BDSCParRef=objParRef
	Set obj.BDSCCode=Code                //代码
	Set obj.BDSCDesc=Desc                //描述
	Set obj.BDSCType=Type                //字典类型
	Set obj.BDSCMultiSelect=MultiSelect  //描述
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// w ##Class(web.DHCCPW.MRC.BaseDicSubCategory).Delete(argId)
ClassMethod Delete(argId As %String) As %String
{
	new (argId)
	set return=1
	set sc = ##class(User.DHCMRCBaseDicSubCategory).%DeleteId(argId)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}
	quit return
}

/// Creator:      wuqk
/// CreatDate:    2011-09-19
/// Description:  取指定大类的字典子类
/// Table:        User.DHCMRCBaseDicSubCategory
///               User.DHCMRCClinPathWays
/// InPut:
///               CateCode : 大类代码
///               CPWVerId : 路径版本ID User.DHCMRCClinPathWays.ID
///               MatchingOnly : 只显示匹配项目  1/0 ""
/// 
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseDicSubCategory","QrySubCateByCPWVer","")
Query QrySubCateByCPWVer(CateCode As %String, CPWVerId As %String, MatchingOnly As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,Type:%String,Matching:%String,MultiSelect:%String,unique:%String")
{
}

ClassMethod QrySubCateByCPWVerExecute(ByRef qHandle As %Binary, CateCode As %String, CPWVerId As %String, MatchingOnly As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set MatchingOnly=$g(MatchingOnly)
	Set flag=0
	Set CategID=0
	For {
		Set CategID=$o(^DHCMRC("BDC",CategID))
		quit:CategID=""
		Set objCateg=##Class(User.DHCMRCBaseDicCategory).%OpenId(CategID)
		If $IsObject(objCateg) {
			Set Code=objCateg.BDCCode
			Continue:CateCode'=Code
			Set flag=1
			quit
		}
	}
	quit:flag=0 $$$OK
	
	set CPWEveList=##Class(web.DHCCPW.MRC.ClinPathWaysSrv).GetEvaluateListById(CPWVerId)

	Set CategSub=0
	For {
		Set CategSub=$o(^DHCMRC("BDC",CategID,"SUB",CategSub))
		Quit:CategSub=""
		Set CategSubID=CategID_"||"_CategSub
		Set objCategSub=##class(web.DHCCPW.MRC.BaseDicSubCategory).GetObjById(CategSubID)
		
		If $IsObject(objCategSub) {
			Set Code=objCategSub.BDSCCode
			Set Desc=objCategSub.BDSCDesc
			Set Type=objCategSub.BDSCType    //add by wuqk 2011-09-16
			Set MultiSelect=objCategSub.BDSCMultiSelect
			Set Matching=$F(CPWEveList,"^"_CategSubID_":")
			quit:(Matching<1)&&(MatchingOnly=1)
			Set:Matching>0 Matching=1
			Set unique=+$p(CPWEveList,"^"_CategSubID_":",2)
			//w !,Code
			//Rowid:%String,Code:%String,Desc:%String,Type:%String,Matching:%String,MultiSelect:%String
			Set Data=$lb(CategSubID,Code,Desc,Type,Matching,MultiSelect,unique)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}

	
	Quit $$$OK
}

ClassMethod QrySubCateByCPWVerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySubCateByCPWVerExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QrySubCateByCPWVerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySubCateByCPWVerExecute ]
{
 Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
