/// 名称: web.DHCCPW.MRC.VarianceCategory
/// 描述: 临床路径变异类型记录
/// 编写者：zhufei
/// 编写日期: 2010-05-10
Class web.DHCCPW.MRC.VarianceCategory Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-05-10
/// Description:  根据ID取临床路径变异类型字典
/// Table：       User.DHCMRCVarianceCategory
/// Input：       ID:    User.DHCMRCVarianceCategory.Id
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.VarianceCategory).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRCVarianceCategory
{
	New (argId)
	Set return=##Class(User.DHCMRCVarianceCategory).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-10
/// Description:  根据ID取临床路径变异类型字典
/// Table：       User.DHCMRCVarianceCategory
/// Input：       ID:    User.DHCMRCVarianceCategory.Id
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(web.DHCCPW.MRC.VarianceCategory).GetStringById(1)
ClassMethod GetStringById(argId As %String, argSeparete As %String) As %String
{
	new (argId,argSeparete)
	set return=""
	set obj=..GetObjById(argId)
	if $IsObject(obj) {
		set:$g(argSeparete)="" argSeparete=..#SEPARATE
		set return=obj.%Id()_argSeparete
		set return=return_obj.VCCode_argSeparete
		set return=return_obj.VCDesc_argSeparete
		set return=return_obj.VCColour_argSeparete
		set return=return_obj.VCDateFrom_argSeparete
		set return=return_obj.VCDateTo_argSeparete
		set return=return_obj.VCType_argSeparete
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-10
/// Description:  更新User.DHCMRCVarianceCategory
/// Table：       User.DHCMRCVarianceCategory
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:VCCode 3:VCDesc 4:VCColour 5:VCDateFrom 6:VCDateTo
/// w ##class(web.DHCCPW.MRC.VarianceCategory).Update("Rowid^VCCode^VCDesc^VCColour^VCDateFrom^VCDateTo")
ClassMethod Update(argInStr As %String) As %String
{
	new (argInStr)
	set return=-1
	set id=$p(argInStr,"^",1)
	if id="" {
		set obj=##class(User.DHCMRCVarianceCategory).%New()
	} else {
		set obj=##class(User.DHCMRCVarianceCategory).%OpenId(id)
		quit:obj="" ret
	}
	set obj.VCCode=$p(argInStr,"^",2)
	set obj.VCDesc=$p(argInStr,"^",3)
	set obj.VCColour=$p(argInStr,"^",4)
	set DateFrom=$p(argInStr,"^",5)
	;set:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	;set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	Set:DateFrom'="" DateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DateFrom)
	set:DateFrom'="" DateFrom=+DateFrom
	set obj.VCDateFrom=DateFrom
	set DateTo=$p(argInStr,"^",6)
	;set:DateTo["/" DateTo=$zdh(DateTo,4)
	;set:DateTo["-" DateTo=$zdh(DateTo,3)
	Set:DateTo'="" DateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DateTo)
	set:DateTo'="" DateTo=+DateTo
	set obj.VCDateTo=DateTo
	set obj.VCType=$p(argInStr,"^",7)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                      //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	} else {
		set return=obj.%Id()
	}
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-10
/// Description:  删除User.DHCMRCVarianceCategory
/// Table：       User.DHCMRCVarianceCategory
/// Input：       User.DHCMRCVarianceCategory.Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(web.DHCCPW.MRC.VarianceCategory).DeleteById(1)
ClassMethod DeleteById(argId As %String) As %String
{
	new (argId)
	set return=0
	set sc = ##class(User.DHCMRCVarianceCategory).%DeleteId(argId)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-10
/// Description:  取临床路径变异类型字典记录集
/// Input：       
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.VarianceCategory","QueryAll")
Query QueryAll() As %Query(ROWSPEC = "ID:%Integer:ID,VCCode:%String:代码,VCDesc:%String:描述,VCColour:%String:颜色,VCDateFrom:%String:开始日期,VCDateTo:%String:结束日期,VCType:%String:类型代码,VCTypeDesc:%String:类型")
{
}

ClassMethod QueryAllExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	
	set Rowid=0
	for {
		set Rowid=$o(^DHCMRC("VC",Rowid))
		quit:Rowid=""
		set objVarCat=..GetObjById(Rowid)
		if $IsObject(objVarCat)
		{
			Set Rowid=objVarCat.%Id()
			Set VCCode=objVarCat.VCCode
			set VCDesc=objVarCat.VCDesc
			set VCColour=objVarCat.VCColour
			set VCDateFrom=objVarCat.VCDateFrom
			;set:VCDateFrom'="" VCDateFrom=$zd(+VCDateFrom,3)
			set:VCDateFrom'="" VCDateFrom=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+VCDateFrom)
			set VCDateTo=objVarCat.VCDateTo
			;set:VCDateTo'="" VCDateTo=$zd(+VCDateTo,3)
			set:VCDateTo'="" VCDateTo=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+VCDateTo)
			set VCType=objVarCat.VCType
			set VCTypeDesc=##class(web.DHCCPW.MRC.BaseConfig).GetDicByCode("VarCategoryType",VCType)
		} else {
			continue
		}
		
		set Data=$lb(Rowid,VCCode,VCDesc,VCColour,VCDateFrom,VCDateTo,VCType,VCTypeDesc)
		set ^CacheTemp(repid,ind)=Data
		set ind=ind+1
	}
	
	quit $$$OK
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

/// Creator：     zhufei
/// CreatDate：   2010-05-10
/// Description:  取临床路径变异类型字典记录集
/// Input：       
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.VarianceCategory","QryVarCateg","O")
Query QryVarCateg(argType As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod QryVarCategExecute(ByRef qHandle As %Binary, argType As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	
	set Rowid=0
	for {
		set Rowid=$o(^DHCMRC("VC",Rowid))
		quit:Rowid=""
		set objVarCat=..GetObjById(Rowid)
		if $IsObject(objVarCat)
		{
			Set Rowid=objVarCat.%Id()
			Set VCCode=objVarCat.VCCode
			set VCDesc=objVarCat.VCDesc
			set VCColour=objVarCat.VCColour
			set VCDateFrom=objVarCat.VCDateFrom
			continue:(VCDateFrom'="")&&((+VCDateFrom)>(+$h))
			set:VCDateFrom'="" VCDateFrom=$zd(+VCDateFrom,3)
			set VCDateTo=objVarCat.VCDateTo
			continue:(VCDateTo'="")&&((+VCDateTo)<(+$h))
			set:VCDateTo'="" VCDateTo=$zd(+VCDateTo,3)
			set VCType=objVarCat.VCType
			continue:(argType'="")&&(VCType'=argType)
		} else {
			continue
		}
		
		set Data=$lb(Rowid,VCCode,VCDesc)
		set ^CacheTemp(repid,ind)=Data
		set ind=ind+1
	}
	
	quit $$$OK
}

ClassMethod QryVarCategClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarCategExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarCategFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarCategExecute ]
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

/// Creator：     李宇峰
/// CreatDate：   2010-07-5
/// Description:  检查code是否重复
/// Table：       User.DHCMRCVarianceCategory
/// Input：       User.DHCMRCVarianceCategory.Id
/// Return：      如果重复：返回1，不重复：返回0
/// w ##Class(web.DHCCPW.MRC.VarianceCategory).CheckVCCode("A",1)
ClassMethod CheckVCCode(argCode As %String, argRowid As %String)
{
	New (argCode,argRowid)
	Set return=0
	Quit:argCode="" return
	
	Set VCRowid=0
	For {
		Set VCRowid=$o(^DHCMRC("VC",VCRowid))
		Quit:(VCRowid="")||(return=1)
		Continue:(argRowid'="")&&(VCRowid=argRowid)
		Set objVC=..GetObjById(VCRowid)
		Set Code=objVC.VCCode
		Continue:Code'=argCode
		Set return=1
	}
	
	Quit return
}

Storage Default
{
<Data name="VarianceCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW435.VarianceCate667D</DataLocation>
<DefaultData>VarianceCategoryDefaultData</DefaultData>
<IdLocation>^web.DHCCPW435.VarianceCate667D</IdLocation>
<IndexLocation>^web.DHCCPW435.VarianceCate667I</IndexLocation>
<StreamLocation>^web.DHCCPW435.VarianceCate667S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
