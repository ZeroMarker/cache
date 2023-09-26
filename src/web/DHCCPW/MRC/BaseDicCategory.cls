/// 名称: web.DHCCPW.MRC.BaseDicCategory
/// 描述：基础字典项目大类相关操作
/// 编写者：zhufei
/// 编写日期：2011-04-24
Class web.DHCCPW.MRC.BaseDicCategory Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-04-24
/// Description:  根据ID取基础字典项目大类
/// Table：       User.DHCMRCBaseDicCategory
/// Input：       ID:    User.DHCMRCBaseDicCategory.ID
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.BaseDicCategory).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRCBaseDicCategory
{
	New (argId)
	Set return=##Class(User.DHCMRCBaseDicCategory).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-04-24
/// Description:  根据Code取临床路径项目大类
/// Table：       User.DHCMRCBaseDicCategory
/// Input：       Code:    User.DHCMRCBaseDicCategory.Code
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.BaseDicCategory).GetObjByCode("01")
ClassMethod GetObjByCode(argCode As %String) As User.DHCMRCBaseDicCategory
{
	New (argCode)
	Set return=""
	Quit:argCode="" return
	
	Set argId=0
	For {
		Set argId=$o(^DHCMRC("BDC",argId))
		Quit:argId=""
		Set objCateg=..GetObjById(argId)
		If $IsObject(objCateg) {
			Continue:objCateg.BDCCode'=argCode
			Set return=objCateg
		}
	}
	Quit return
}

/// Creator:zhufei
/// CreatDate:2011-04-24
/// Description:取基础字典项目大类所有记录
/// Table:User.DHCMRCBaseDicCategory
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseDicCategory","QryCategory")
Query QryCategory() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod QryCategoryExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set CategID=0
	For {
		Set CategID=$o(^DHCMRC("BDC",CategID))
		Quit:CategID=""
		Set objCateg=..GetObjById(CategID)
		If $IsObject(objCateg) {
			Set Code=objCateg.BDCCode
			Set Desc=objCateg.BDCDesc
			
			Set Data=$lb(CategID,Code,Desc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCategoryExecute ]
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

ClassMethod QryCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCategoryExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2011-04-24
/// Description:  保存基础字典项目大类
/// Table：       User.DHCMRCBaseDicCategory
/// Input：       argInPut: 基础字典项目子类数据
/// Return：      return<0: 保存失败
/// w ##Class(web.DHCCPW.MRC.BaseDicCategory).Update(argInput)
ClassMethod Update(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set ID=$p(argInput,"^",1)
	If ID="" {
		Set obj=##class(User.DHCMRCBaseDicCategory).%New()
	} Else {
		Set obj=##class(User.DHCMRCBaseDicCategory).%OpenId(ID)
		Quit:obj="" return
	}
	
	Set Code=$p(argInput,"^",2)
	Set Desc=$p(argInput,"^",3)
	Quit:(Code="")||(Desc="") return
	
	Set obj.BDCCode=Code               //代码
	Set obj.BDCDesc=Desc               //描述
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

/// Creator:zhufei
/// CreatDate:2011-04-24
/// Description:检查Code是否重复
/// Table:User.DHCMRCBaseDicCategory
/// w ##Class(web.DHCCPW.MRC.BaseDicCategory).CheckCode("01",1)
ClassMethod CheckCode(argCode As %String, argCategID As %String)
{
	New (argCode,argCategID)
	Set return=0
	Quit:argCode="" return
	
	Set CategID=0
	For {
		Set CategID=$o(^DHCMRC("BDC",CategID))
		Quit:(CategID="")||(return=1)
		Continue:(argCategID'="")&(argCategID=CategID)
		
		Set objCateg=..GetObjById(CategID)
		If $IsObject(objCateg) {
			Set Code=objCateg.BDCCode
			Continue:argCode'=Code
			Set return=1
		}
	}
	
	Quit return
}

/// Creator:李宇峰
/// CreatDate:2010-05-06
/// Description:基础字典项目大类记录
/// Table:User.DHCMRCBaseDicCategory
/// w ##Class(web.DHCCPW.MRC.BaseDicCategory).Delete(3)
ClassMethod Delete(argId As %String) As %String
{
	new (argId)
	set return=1
	set sc = ##class(User.DHCMRCBaseDicCategory).%DeleteId(argId)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}
	quit return
}

}
