/// 名称: web.DHCCPW.MRC.BaseConfig
/// 描述: 临床路径基础配置
/// 编写者：zhufei
/// 编写日期: 2010-12-09
Class web.DHCCPW.MRC.BaseConfig Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-02-15
/// Description:  根据ID取临床路径基础配置
/// Table：       User.DHCMRCBaseConfig
/// Input：       ID:    User.DHCMRCBaseConfig.ID
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.BaseConfig).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRCBaseConfig
{
	New (argId)
	Set return=##Class(User.DHCMRCBaseConfig).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-12-09
/// Description:  根据Code取临床路径基础配置
/// Table：       User.DHCMRCBaseConfig
/// Input：       ID:    User.DHCMRCBaseConfig.Code
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode("")
ClassMethod GetObjByCode(argCode As %String) As User.DHCMRCBaseConfig
{
	New (argCode)
	Set return=""
	Quit:argCode="" return
	Set RowID=$o(^DHCMRCi("BC",0,"IndexCode"," "_argCode,0))
	Quit:RowID="" return
	Set return=##Class(User.DHCMRCBaseConfig).%OpenId(RowID)
	Do:return'="" return.%Close()
	Quit return
}

/// w ##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("")
ClassMethod GetValueByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Set objConfig=##class(web.DHCCPW.MRC.BaseConfig).GetObjByCode(aCode)
	If $IsObject(objConfig){
		Set return=objConfig.BCValue
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-02-15
/// Description:  检查代码是否重复
/// Table：       User.DHCMRCBaseConfig
/// Input：       ID:    User.DHCMRCBaseConfig.ID
///               ID:    User.DHCMRCBaseConfig.Code
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.BaseConfig).CheckBCCode("AAA","")
ClassMethod CheckBCCode(argCode As %String, argID As %String)
{
	New (argCode,argID)
	Set return=0
	Quit:argCode="" return
	
	Set BCID=0
	For {
		Set BCID=$o(^DHCMRC("BC",BCID))
		Quit:(BCID="")||(return=1)
		Continue:(argID'="")&&(argID=BCID)
		Set objBC=..GetObjById(BCID)
		If $IsObject(objBC){
			Set Code=objBC.BCCode
			Continue:argCode'=Code
			Set return=1
		}
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-12-09
/// Description:  根据Code取临床路径基础配置
/// Table：       User.DHCMRCBaseConfig
/// Input：       ID:    User.DHCMRCBaseConfig.Code
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(web.DHCCPW.MRC.BaseConfig).GetStringByCode("","^")
ClassMethod GetStringByCode(argCode As %String, argSeparete As %String) As %String
{
	new (argCode,argSeparete)
	set return=""
	set obj=..GetObjByCode(argCode)
	if $IsObject(obj) {
		set:$g(argSeparete)="" argSeparete=..#SEPARATE
		set return=obj.%Id()_argSeparete
		set return=return_obj.BCCode_argSeparete
		set return=return_obj.BCDesc_argSeparete
		set return=return_obj.BCValue_argSeparete
		set return=return_obj.BCResume_argSeparete
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-12-09
/// Description:  删除临床路径基础配置
/// Table：       User.DHCMRCBaseConfig
/// Input：       User.DHCMRCBaseConfig.Code
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(web.DHCCPW.MRC.BaseConfig).DeleteByCode("")
ClassMethod DeleteByCode(argCode As %String) As %Boolean
{
	new (argCode)
	set return=-1
	quit:argCode="" return
	set RowID=$o(^DHCMRCi("BC",0,"IndexCode"," "_argCode,0))
	quit:RowID="" return
	
	set return=1
	set sc = ##class(User.DHCMRCBaseConfig).%DeleteId(RowID)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc)
   		set return=-1
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-12-09
/// Description:  删除临床路径基础配置
/// Table：       User.DHCMRCBaseConfig
/// Input：       User.DHCMRCBaseConfig.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(web.DHCCPW.MRC.BaseConfig).DeleteById("")
ClassMethod DeleteById(argId As %String) As %String
{
	new (argId)
	set return=1
	set sc = ##class(User.DHCMRCBaseConfig).%DeleteId(argId)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc)
   		set return=-1
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-12-09
/// Description:  增加或修改临床路径基础配置
///               代码不允许重复
/// Table：       User.DHCMRCBaseConfig
/// Input：       argInput: 临床路径基础配置
/// Return：      ID
/// w ##class(web.DHCCPW.MRC.BaseConfig).Update(argInput)
ClassMethod Update(argInput As %String) As %String
{
	New (argInput)
	Set return=-1
	
	Set ID=$p(argInput,"^",1)
	If ID="" {
		Set obj=##class(User.DHCMRCBaseConfig).%New()
	} Else {
		Set obj=##class(User.DHCMRCBaseConfig).%OpenId(ID)
		Quit:obj="" return
	}
	Set Code=$p(argInput,"^",2)
	Set Desc=$p(argInput,"^",3)
	Set Value=$p(argInput,"^",4)
	Set Resume=$p(argInput,"^",5)
	Quit:(Code="")||(Desc="") return
	
	Set obj.BCCode=Code                    // 代码
	Set obj.BCDesc=Desc                    // 描述
	Set obj.BCValue=Value                  // 值
	Set obj.BCResume=Resume                // 备注
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-12-09
/// Description:  查询基础字典的Query
///               Query查询的内容是在BaseConfig的Value值维护的信息
/// Input：       argCode：代码
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseConfig","QryBaseDic","")
Query QryBaseDic(argCode As %String) As %Query(ROWSPEC = "DicCode:%String,DicDesc:%String")
{
}

ClassMethod QryBaseDicExecute(ByRef qHandle As %Binary, argCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set BCInfo=..GetStringByCode(argCode,$c(0))
	Set BCValue=$p(BCInfo,$c(0),4)
	Quit:BCValue="" $$$OK
	
	For Index=1:1:$l(BCValue,",") {
		Set DicInfo=$p(BCValue,",",Index)
		Set DicCode=$p(DicInfo,"||",1)
		Set DicDesc=$p(DicInfo,"||",2)
		Continue:(DicCode="")||(DicDesc="")
		
		Set Data=$lb(DicCode,DicDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryBaseDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBaseDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBaseDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBaseDicExecute ]
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
/// CreatDate：   2010-12-09
/// Description:  根据Code取临床路径基础配置
/// Table：       User.DHCMRCBaseConfig
/// Input：       ID:    User.DHCMRCBaseConfig.Code
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(web.DHCCPW.MRC.BaseConfig).GetDicByCode("VarReasonType","A")
ClassMethod GetDicByCode(argCode As %String, argDicCode As %String) As %String
{
	New (argCode,argDicCode)
	Set return=""
	Set obj=..GetObjByCode(argCode)
	If $IsObject(obj) {
		Set BCValue=obj.BCValue
	}
	Quit:$g(BCValue)="" return
	
	For Index=1:1:$l(BCValue,",") {
		Set DicInfo=$p(BCValue,",",Index)
		Set DicCode=$p(DicInfo,"||",1)
		Set DicDesc=$p(DicInfo,"||",2)
		Continue:DicCode'=argDicCode
		Set return=DicDesc
		Quit
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-02-15
/// Description:  查询基础字典的Query
/// Input：       
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseConfig","QueryAll")
Query QueryAll() As %Query(ROWSPEC = "BCID:%String,BCCode:%String,BCDesc:%String,BCValue:%String,BCResume:%String")
{
}

ClassMethod QueryAllExecute(ByRef qHandle As %Binary, argCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set BCID=0
	For {
		Set BCID=$o(^DHCMRC("BC",BCID))
		Quit:BCID=""
		Set objBC=##class(web.DHCCPW.MRC.BaseConfig).GetObjById(BCID)
		If $IsObject(objBC) {
			Set BCCode=objBC.BCCode
			Set BCDesc=objBC.BCDesc
			Set BCValue=objBC.BCValue
			Set BCResume=objBC.BCResume
			
			Set Data=$lb(BCID,BCCode,BCDesc,BCValue,BCResume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
	}
		
	
	Quit $$$OK
}

ClassMethod QueryAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllExecute ]
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

}
