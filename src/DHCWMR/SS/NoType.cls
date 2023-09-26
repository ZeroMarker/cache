/// 病案号码类型定义
Class DHCWMR.SS.NoType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.SS.MrType [ Cardinality = parent, Inverse = ChildNT ];

Relationship ChildLnk As DHCWMR.SS.NoTypeLnk [ Cardinality = children, Inverse = Parref ];

/// 代码
Property NTCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property NTDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 号码长度
Property NTNoLen As %String(MAXLEN = 100, TRUNCATE = 1);

/// 类型标记
Property NTNoHead As %String(MAXLEN = 100, TRUNCATE = 1);

/// 当前号
Property NTCurrNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 最大号（结束号）
Property NTMaxNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 最小号（起始号）
Property NTMinNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否默认类型
Property NTIsDefault As %Boolean;

/// 是否有效
Property NTIsActive As %Boolean;

/// 备注
Property NTResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  取病案号码类型
/// Table：       DHCWMR.SS.NoType
/// Input：       Id : DHCWMR.SS.NoType.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.NoType).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.NoType
{
	new (aId)
	quit:'##class(DHCWMR.SS.NoType).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.NoType).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  更新病案号码类型
/// Table：       DHCWMR.SS.NoType
/// Input：       InputStr : 号码类型信息
///               Separate ：分隔符
/// Return：      返回obj
/// w ##class(DHCWMR.SS.NoType).Update("2^3^5^门诊号码3^5^C^40000^50000^40000^0^1^5^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As DHCWMR.SS.NoType
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set Code=$p(aInputStr,aSeparate,3)
	Set Desc=$p(aInputStr,aSeparate,4)
	Set NoLen=$p(aInputStr,aSeparate,5)
	Set NoHead=$p(aInputStr,aSeparate,6)
	Set CurrNo=+$p(aInputStr,aSeparate,7)
	Set MaxNo=$p(aInputStr,aSeparate,8)
	Set MinNo=$p(aInputStr,aSeparate,9)
	Set IsDefault=$p(aInputStr,aSeparate,10)
	Set IsActive=$p(aInputStr,aSeparate,11)
	Set Resume=$p(aInputStr,aSeparate,12)
	Quit:(Parref="") return
	
	Set objParref=##class(DHCWMR.SS.MrType).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildSub="" {
		Set obj=##class(DHCWMR.SS.NoType).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.NoType).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref      = objParref
	Set obj.NTCode      = Code
	Set obj.NTDesc      = Desc
	Set obj.NTNoLen     = NoLen
	Set obj.NTNoHead    = $zcvt(NoHead,"U")
	Set obj.NTCurrNo    = CurrNo
	Set obj.NTMaxNo     = MaxNo
	Set obj.NTMinNo     = MinNo
	Set obj.NTIsDefault = IsDefault
	Set obj.NTIsActive  = IsActive
	Set obj.NTResume    = Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  删除病案号码类型
/// Table：       DHCWMR.SS.NoType
/// Input：       Id : DHCWMR.SS.NoType.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.NoType).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-26
/// Description:  根据病案类型查询号码类型
/// Table：       DHCWMR.SS.NoType
/// Input：       MrTypeID ：DHCWMR.SS.MrType.ID 病案类型
/// Return：      返回Query
/// D ##class(%ResultSet).RunQuery("DHCWMR.SS.NoType","QryMrNoType")
Query QryMrNoType(aMrTypeID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,NoLen:%String,NoHead:%String,CurrNo:%String,CurrMrNo:%String,MaxNo:%String,MinNo:%String,IsDefault:%String,IsDefaultDesc:%String,IsActive:%String,IsActiveDesc:%String,Resume:%String")
{
}

ClassMethod QryMrNoTypeExecute(ByRef qHandle As %Binary, aMrTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aMrTypeID="" $$$OK
 	
 	Set xSub=0
 	For {
	 	Set xSub=$o(^DHCWMR.SS.MrTypeD(aMrTypeID,"NT",xSub))
	 	Quit:xSub=""
	 	
	 	Set ID=aMrTypeID_"||"_xSub
	 	Set obj=##class(DHCWMR.SS.NoType).GetObjById(ID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set Code=obj.NTCode
	 	Set Desc=obj.NTDesc
	 	Set NoLen=obj.NTNoLen
	 	Set NoHead=obj.NTNoHead
		Set CurrNo=obj.NTCurrNo
		Set CurrNo=+CurrNo
		Set xCurrNo=+$g(^DHCWMR.SS.MrNoC(aMrTypeID,ID))
		Set:CurrNo<xCurrNo CurrNo=xCurrNo
		Set MaxNo=obj.NTMaxNo
		Set MinNo=obj.NTMinNo
		Set IsDefault=obj.NTIsDefault
		Set IsDefaultDesc=$s(IsDefault=1:"是",1:"否")
		Set IsActive=obj.NTIsActive
		Set IsActiveDesc=$s(IsActive=1:"是",1:"否")
		Set Resume=obj.NTResume
		
		Set CurrMrNo=""
		Set xNoLen=+NoLen
		If xNoLen>$l(CurrNo) {
			Set $p(CurrMrNo,"0",xNoLen+1-$l(CurrNo))=CurrNo
		} Else {
			Set CurrMrNo=CurrNo
		}
		Set:NoHead'="" CurrMrNo=$zcvt(NoHead,"U")_CurrMrNo
		
		Set Data=$lb(ID,Code,Desc,NoLen,NoHead,CurrNo,CurrMrNo,MaxNo,MinNo,IsDefault,IsDefaultDesc,IsActive,IsActiveDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMrNoTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMrNoTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMrNoTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMrNoTypeExecute ]
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
/// CreatDate：   2014-12-06
/// Description:  根据病案类型查询有效号码类型
/// Table：       DHCWMR.SS.NoType
/// Input：       MrTypeID ：DHCWMR.SS.MrType.ID 病案类型
/// Return：      返回Query
/// D ##class(%ResultSet).RunQuery("DHCWMR.SS.NoType","QryActNoType")
Query QryActNoType(aMrTypeID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,NoLen:%String,NoHead:%String,CurrNo:%String,CurrMrNo:%String,MaxNo:%String,MinNo:%String,IsDefault:%String,IsDefaultDesc:%String,IsActive:%String,IsActiveDesc:%String,Resume:%String")
{
}

ClassMethod QryActNoTypeExecute(ByRef qHandle As %Binary, aMrTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aMrTypeID="" $$$OK
 	
 	Set xSub=0
 	For {
	 	Set xSub=$o(^DHCWMR.SS.MrTypeD(aMrTypeID,"NT",xSub))
	 	Quit:xSub=""
	 	
	 	Set ID=aMrTypeID_"||"_xSub
	 	Set obj=##class(DHCWMR.SS.NoType).GetObjById(ID)
	 	Continue:'$IsObject(obj)
	 	Continue:obj.NTIsActive'=1
	 	
	 	Set Code=obj.NTCode
	 	Set Desc=obj.NTDesc
	 	Set NoLen=obj.NTNoLen
	 	Set NoHead=obj.NTNoHead
		Set CurrNo=obj.NTCurrNo
		Set CurrNo=+CurrNo
		Set xCurrNo=+$g(^DHCWMR.SS.MrNoC(aMrTypeID,ID))
		Set:CurrNo<xCurrNo CurrNo=xCurrNo
		Set MaxNo=obj.NTMaxNo
		Set MinNo=obj.NTMinNo
		Set IsDefault=obj.NTIsDefault
		Set IsDefaultDesc=$s(IsDefault=1:"是",1:"否")
		Set IsActive=obj.NTIsActive
		Set IsActiveDesc=$s(IsActive=1:"是",1:"否")
		Set Resume=obj.NTResume
		
		Set CurrMrNo=""
		Set xNoLen=+NoLen
		If xNoLen>$l(CurrNo) {
			Set $p(CurrMrNo,"0",xNoLen+1-$l(CurrNo))=CurrNo
		} Else {
			Set CurrMrNo=CurrNo
		}
		Set:NoHead'="" CurrMrNo=$zcvt(NoHead,"U")_CurrMrNo
		
		Set Data=$lb(ID,Code,Desc,NoLen,NoHead,CurrNo,CurrMrNo,MaxNo,MinNo,IsDefault,IsDefaultDesc,IsActive,IsActiveDesc,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryActNoTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryActNoTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryActNoTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryActNoTypeExecute ]
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

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NTCode</Value>
</Value>
<Value name="3">
<Value>NTDesc</Value>
</Value>
<Value name="4">
<Value>NTNoLen</Value>
</Value>
<Value name="5">
<Value>NTNoHead</Value>
</Value>
<Value name="6">
<Value>NTCurrNo</Value>
</Value>
<Value name="7">
<Value>NTMaxNo</Value>
</Value>
<Value name="8">
<Value>NTMinNo</Value>
</Value>
<Value name="9">
<Value>NTIsDefault</Value>
</Value>
<Value name="10">
<Value>NTIsActive</Value>
</Value>
<Value name="11">
<Value>NTResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("NT")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("NT")</IdLocation>
<IndexLocation>^DHCWMR.SS.MrTypeI("MNT")</IndexLocation>
<StreamLocation>^DHCWMR.SS.NoTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
