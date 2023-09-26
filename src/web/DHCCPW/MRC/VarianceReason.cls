/// 名称: web.DHCCPW.MRC.VarianceReason
/// 描述: 临床路径变异原因记录
/// 编写者：zhufei
/// 编写日期: 2010-05-10
Class web.DHCCPW.MRC.VarianceReason Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-05-10
/// Description:  根据ID取临床路径变异原因字典
/// Table：       User.DHCMRCVarianceReason
/// Input：       ID:    User.DHCMRCVarianceReason.Id
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.VarianceReason).GetObjById(2)
ClassMethod GetObjById(argId As %String) As User.DHCMRCVarianceReason
{
	New (argId)
	Set return=##Class(User.DHCMRCVarianceReason).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-10
/// Description:  根据ID取临床路径变异原因字典
/// Table：       User.DHCMRCVarianceReason
/// Input：       ID:    User.DHCMRCVarianceReason.Id
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(web.DHCCPW.MRC.VarianceReason).GetStringById(1)
ClassMethod GetStringById(argId As %String, argSeparete As %String) As %String
{
	new (argId,argSeparete)
	set return=""
	set obj=..GetObjById(argId)
	if $IsObject(obj) {
		set:$g(argSeparete)="" argSeparete=..#SEPARATE
		set return=obj.%Id()_argSeparete
		set return=return_obj.VRCode_argSeparete
		set return=return_obj.VRDesc_argSeparete
		if $IsObject(obj.VRVarCategDR)
		{
			set return=return_obj.VRVarCategDR.%Id()_argSeparete
			set return=return_obj.VRVarCategDR.VCDesc_argSeparete
		} else {
			set return=return_argSeparete
			set return=return_argSeparete
		}
		set return=return_obj.VRDateFrom_argSeparete
		set return=return_obj.VRDateTo_argSeparete
		set return=return_obj.VRType_argSeparete
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-10
/// Description:  更新User.DHCMRCVarianceReason
/// Table：       User.DHCMRCVarianceReason
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:VRCode 3:VRDesc 4:VRVarCategDR 5:VRDateFrom 6:VRDateTo
/// w ##class(web.DHCCPW.MRC.VarianceReason).Update("Rowid^VRCode^VRDesc^VRVarCategDR^VRDateFrom^VRDateTo")
ClassMethod Update(argInStr As %String) As %String
{
	new (argInStr)
	set return=-1
	set id=$p(argInStr,"^",1)
	if id="" {
		set obj=##class(User.DHCMRCVarianceReason).%New()
	} else {
		set obj=##class(User.DHCMRCVarianceReason).%OpenId(id)
		quit:obj="" return
	}
	
	set obj.VRCode=$p(argInStr,"^",2)
	set obj.VRDesc=$p(argInStr,"^",3)
	
	set VarCategID=$p(argInStr,"^",4)
	set objVarCateg=##class(web.DHCCPW.MRC.VarianceCategory).GetObjById(VarCategID)
	set obj.VRVarCategDR=objVarCateg
	do:objVarCateg'="" objVarCateg.%Close()
	
	set DateFrom=$p(argInStr,"^",5)
	;set:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	;set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	Set:DateFrom'="" DateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DateFrom)
	set:DateFrom'="" DateFrom=+DateFrom
	set obj.VRDateFrom=DateFrom
	
	set DateTo=$p(argInStr,"^",6)
	;set:DateTo["/" DateTo=$zdh(DateTo,4)
	;set:DateTo["-" DateTo=$zdh(DateTo,3)
	Set:DateTo'="" DateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DateTo)
	set:DateTo'="" DateTo=+DateTo
	set obj.VRDateTo=DateTo
	
	set ReaType=$p(argInStr,"^",7)
	set obj.VRType=ReaType
	set obj.VRActive=$p(argInStr,"^",8)
	
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
/// Description:  删除User.DHCMRCVarianceReason
/// Table：       User.DHCMRCVarianceReason
/// Input：       User.DHCMRCVarianceReason.Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(web.DHCCPW.MRC.VarianceReason).DeleteById(1)
ClassMethod DeleteById(argId As %String) As %String
{
	new (argId)
	set return=0
	set sc = ##class(User.DHCMRCVarianceReason).%DeleteId(argId)
	if $system.Status.IsError(sc) {         //检查删除是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-10
/// Description:  取临床路径变异原因字典记录集
/// Input：       
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.VarianceReason","QueryAll")
Query QueryAll() As %Query(ROWSPEC = "ID:%Integer:ID,VRCode:%String:代码,VRDesc:%String:描述,VRVarCategDR:%String:VarCategID,VRVarCategDesc:%String:变异类型,VRDateFrom:%String:开始日期,VRDateTo:%String:结束日期,VRType:%String:类型代码,VRTypeDesc:%String:类型,VRActive:%String:是否有效")
{
}

ClassMethod QueryAllExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	
	set Rowid=0
	for {
		set Rowid=$o(^DHCMRC("VR",Rowid))
		quit:Rowid=""
		set objVarRsn=..GetObjById(Rowid)
		if $IsObject(objVarRsn)
		{
			set VRCode=objVarRsn.VRCode
			set VRDesc=objVarRsn.VRDesc
			if $IsObject(objVarRsn.VRVarCategDR)
			{
				set VRVarCategDR=objVarRsn.VRVarCategDR.%Id()
				set VRVarCategDesc=objVarRsn.VRVarCategDR.VCDesc
			} else {
				set VRVarCategDR=""
				set VRVarCategDesc=""
			}
			set VRDateFrom=objVarRsn.VRDateFrom
			;set:VRDateFrom'="" VRDateFrom=$zd(+VRDateFrom,3)
			set:VRDateFrom'="" VRDateFrom=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+VRDateFrom)
			set VRDateTo=objVarRsn.VRDateTo
			;set:VRDateTo'="" VRDateTo=$zd(+VRDateTo,3)
			set:VRDateTo'="" VRDateTo=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(+VRDateTo)
			set VRType=objVarRsn.VRType
			set VRTypeDesc=##class(web.DHCCPW.MRC.BaseConfig).GetDicByCode("VarReasonType",VRType)
			Set VRActive=$s(objVarRsn.VRActive["Y":"Yes",1:"No")
		} else {
			continue
		}
		
		set Data=$lb(Rowid,VRCode,VRDesc,VRVarCategDR,VRVarCategDesc,VRDateFrom,VRDateTo,VRType,VRTypeDesc,VRActive)
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
/// CreatDate：   2010-05-14
/// Description:  CS/BS程序中用此方法取出径原因
/// Input：       
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.VarianceReason","QryVarReason",5)
Query QryVarReason(argVarCategID As %String, argIsActive As %String = "Y") As %Query(ROWSPEC = "Rowid:%Integer,Code:%String,Desc:%String")
{
}

ClassMethod QryVarReasonExecute(ByRef qHandle As %Binary, argVarCategID As %String, argIsActive As %String = "Y") As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	
	set Rowid=0
	for {
		set Rowid=$o(^DHCMRC("VR",Rowid))
		quit:Rowid=""
		set objVarRsn=..GetObjById(Rowid)
		if $IsObject(objVarRsn)
		{
			set VRCode=objVarRsn.VRCode
			set VRDesc=objVarRsn.VRDesc
			if $IsObject(objVarRsn.VRVarCategDR)
			{
				set VRVarCategDR=objVarRsn.VRVarCategDR.%Id()
				set VRVarCategDesc=objVarRsn.VRVarCategDR.VCDesc
				set VRVarCategType=objVarRsn.VRVarCategDR.VCType
			} else {
				set VRVarCategDR=""
				set VRVarCategDesc=""
				set VRVarCategType=""
			}
			continue:VRVarCategType'="O"
			continue:(argVarCategID'="")&&(argVarCategID'=VRVarCategDR)
			set VRDateFrom=objVarRsn.VRDateFrom
			continue:(VRDateFrom'="")&&((+VRDateFrom)>(+$h))
			set:VRDateFrom'="" VRDateFrom=$zd(+VRDateFrom,3)
			set VRDateTo=objVarRsn.VRDateTo
			continue:(VRDateTo'="")&&((+VRDateTo)<(+$h))
			set:VRDateTo'="" VRDateTo=$zd(+VRDateTo,3)
			Set Active=objVarRsn.VRActive
			Continue:(argIsActive'="")&(argIsActive'[Active)
		} else {
			continue
		}
		
		set Data=$lb(Rowid,VRCode,VRDesc)
		set ^CacheTemp(repid,ind)=Data
		set ind=ind+1
	}
	
	quit $$$OK
}

ClassMethod QryVarReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarReasonExecute ]
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
/// CreatDate：   2010-12-10
/// Description:  用此方法取变异原因(出径原因),变异类型不允许为空
/// Input：       
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.VarianceReason","QryVarReasonNew",5)
Query QryVarReasonNew(argVarCategID As %String, argIsActive As %String = "Y") As %Query(ROWSPEC = "Rowid:%Integer,Code:%String,Desc:%String")
{
}

ClassMethod QryVarReasonNewExecute(ByRef qHandle As %Binary, argVarCategID As %String, argIsActive As %String = "Y") As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	
	set Rowid=0
	for {
		set Rowid=$o(^DHCMRC("VR",Rowid))
		quit:Rowid=""
		set objVarRsn=..GetObjById(Rowid)
		if $IsObject(objVarRsn)
		{
			set VRCode=objVarRsn.VRCode
			set VRDesc=objVarRsn.VRDesc
			if $IsObject(objVarRsn.VRVarCategDR)
			{
				set VRVarCategDR=objVarRsn.VRVarCategDR.%Id()
				set VRVarCategDesc=objVarRsn.VRVarCategDR.VCDesc
				set VRVarCategType=objVarRsn.VRVarCategDR.VCType
			} else {
				set VRVarCategDR=""
				set VRVarCategDesc=""
				set VRVarCategType=""
			}
			continue:argVarCategID'=VRVarCategDR    //变异类型不允许为空
			set VRDateFrom=objVarRsn.VRDateFrom
			continue:(VRDateFrom'="")&&((+VRDateFrom)>(+$h))
			set:VRDateFrom'="" VRDateFrom=$zd(+VRDateFrom,3)
			set VRDateTo=objVarRsn.VRDateTo
			continue:(VRDateTo'="")&&((+VRDateTo)<(+$h))
			set:VRDateTo'="" VRDateTo=$zd(+VRDateTo,3)
			Set Active=objVarRsn.VRActive
			Continue:(argIsActive'="")&(argIsActive'[Active)
		} else {
			continue
		}
		
		set Data=$lb(Rowid,VRCode,VRDesc)
		set ^CacheTemp(repid,ind)=Data
		set ind=ind+1
	}
	
	quit $$$OK
}

ClassMethod QryVarReasonNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVarReasonNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVarReasonNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVarReasonNewExecute ]
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
/// CreatDate：   2011-09-19
/// Description:  取原因列表,类型不允许为空
/// Input：       
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.VarianceReason","QryReasonByType","O")
Query QryReasonByType(argTypeCode As %String, argIsActive As %String = "Y") As %Query(ROWSPEC = "Rowid:%Integer,Code:%String,Desc:%String,CategDesc:%String")
{
}

ClassMethod QryReasonByTypeExecute(ByRef qHandle As %Binary, argTypeCode As %String, argIsActive As %String = "Y") As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	
	set Rowid=0
	for {
		set Rowid=$o(^DHCMRC("VR",Rowid))
		quit:Rowid=""
		set objVarRsn=..GetObjById(Rowid)
		if $IsObject(objVarRsn)
		{
			set VRCode=objVarRsn.VRCode
			set VRDesc=objVarRsn.VRDesc
			if $IsObject(objVarRsn.VRVarCategDR)
			{
				set VRVarCategDR=objVarRsn.VRVarCategDR.%Id()
				set VRVarCategDesc=objVarRsn.VRVarCategDR.VCDesc
				set VRVarCategType=objVarRsn.VRVarCategDR.VCType
			} else {
				set VRVarCategDR=""
				set VRVarCategDesc=""
				set VRVarCategType=""
			}
			continue:VRVarCategType'=argTypeCode
			set VRDateFrom=objVarRsn.VRDateFrom
			continue:(VRDateFrom'="")&&((+VRDateFrom)>(+$h))
			set:VRDateFrom'="" VRDateFrom=$zd(+VRDateFrom,3)
			set VRDateTo=objVarRsn.VRDateTo
			continue:(VRDateTo'="")&&((+VRDateTo)<(+$h))
			set:VRDateTo'="" VRDateTo=$zd(+VRDateTo,3)
			Set Active=objVarRsn.VRActive
			Continue:(argIsActive'="")&(argIsActive'[Active)
		} else {
			continue
		}
		
		set Data=$lb(Rowid,VRCode,VRDesc,VRVarCategDesc)
		set ^CacheTemp(repid,ind)=Data
		set ind=ind+1
	}
	
	quit $$$OK
}

ClassMethod QryReasonByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReasonByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReasonByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReasonByTypeExecute ]
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
/// Table：       User.DHCMRCVarianceReason
/// Input：       User.DHCMRCVarianceReason.Id
/// Return：      如果重复：返回1，不重复：返回0
/// w ##class(web.DHCCPW.MRC.VarianceReason).CheckReaCode("1","")
ClassMethod CheckReaCode(argCode As %String, argRowid As %String)
{
	New (argCode,argRowid)
	Set return=0
	Quit:argCode="" return
	
	Set VRowid=0
	For {
		Set VRowid=$o(^DHCMRC("VR",VRowid))
		Quit:(VRowid="")||(return=1)
		Set objVarRsn=..GetObjById(VRowid)
		Set Code=objVarRsn.VRCode
		Continue:(argRowid'="")&&(argRowid=VRowid)
		Continue:Code'=argCode
		Set return=1
	}
	
	Quit return
}

Storage Default
{
<Data name="VarianceReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW.MRC.VarianceReasonD</DataLocation>
<DefaultData>VarianceReasonDefaultData</DefaultData>
<IdLocation>^web.DHCCPW.MRC.VarianceReasonD</IdLocation>
<IndexLocation>^web.DHCCPW.MRC.VarianceReasonI</IndexLocation>
<StreamLocation>^web.DHCCPW.MRC.VarianceReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
