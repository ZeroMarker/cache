/// 三级菜单
Class DHCMGNUR.DHCNurHEAPIItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 项目三
Property Item3 As %String(TRUNCATE = 1) [ Required, SqlFieldName = HEAPI_Item3 ];

/// 项目二指针
Property Item2DR As %String(TRUNCATE = 1) [ SqlFieldName = HEAPI_Item2DR ];

/// 项目三描述
Property Describe As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlFieldName = HEAPI_Describe ];

/// 有效标记
Property ItemValid As %String(TRUNCATE = 1) [ SqlFieldName = HEAPI_ItemValid ];

//Index Item3 On Item3;

Index ItemDR On Item2DR;

Parameter EXTENTSIZE = 1000000;

/// w ##class(DHCMGNUR.DHCNurHEAPIItem).Save("^测试^1^")
ClassMethod Save(parr As %String) As %String
{
	q:parr=""
	set ItemId=$P(parr,"^",1)
	set Item3=$P(parr,"^",2) q:Item3=""
	set Item2DR = $P(parr,"^",3) q:Item2DR=""
	set Describe = $P(parr,"^",4)
	i ItemId'="" do
	.set Object = ##class(DHCMGNUR.DHCNurHEAPIItem).%OpenId(ItemId)
	else  do
	.set Object = ##class(DHCMGNUR.DHCNurHEAPIItem).%New()
	set Object.Item3 = Item3
	set Object.Item2DR = Item2DR
	set Object.Describe = Describe
	TStart
	set sc = Object.%Save()
	if $$$ISERR(sc)
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "Fail"
	}
	else
	{
		TCommit
		q "Success"
	}
}

ClassMethod Delete(parr As %String) As %String
{
	q:parr=""
	set id=$P(parr,"^",1) q:id=""
	set valid = $P(parr,"^",2)
	set object = ##class(DHCMGNUR.DHCNurHEAPIItem).%OpenId(id)
	TStart
	set object.ItemValid=valid
	set sc = object.%Save()
	if $$$ISERR(sc)
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "Fail"
	}
	else
	{
		TCommit
		q "OK"
	}
}

/// d ##class(%ResultSet).RunQuery("DHCMGNUR.DHCNurHEAPIItem","FindHEAPIIData","1")
Query FindHEAPIIData(parr As %String) As %Query(ROWSPEC = "Item3,Item2Desc,Item3Decs,ItemId")
{
}

ClassMethod FindHEAPIIDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	if parr="" 
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	set ItemId="" for  set ItemId=$O(^DHCMGNUR.DHCNurHEAPIItemI("ItemDR"," "_parr,ItemId)) q:ItemId=""  do
	.set object = ##class(DHCMGNUR.DHCNurHEAPIItem).%OpenId(ItemId)
	.;q:'object.%ExistId(ItemId)
	.set Item3 = object.Item3
	.set Item2DR = object.Item2DR
	.set object2 = ##class(DHCMGNUR.DHCNurHEAProjectItem).%OpenId(Item2DR)
	.set Item2Desc = object2.Item2
	.set Item3Decs = object.Describe
	.set ItemValid = object.ItemValid
	.if ItemValid'="N" Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow     
	set Data=$lb(Item3,Item2Desc,Item3Decs,ItemId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHEAPIIDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHEAPIIDataExecute ]
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

ClassMethod FindHEAPIIDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHEAPIIDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(DHCMGNUR.DHCNurHEAPIItem).FindHEAPIIById(1)
ClassMethod FindHEAPIIById(id As %String) As %String
{
	q:id=""
	set object = ##class(DHCMGNUR.DHCNurHEAPIItem).%OpenId(id)
	set Item3 = object.Item3
	set Item2DR = object.Item2DR
	set object2 = ##class(DHCMGNUR.DHCNurHEAProjectItem).%OpenId(Item2DR)
	set Item2Desc = object2.Item2
	set Item3Decs = object.Describe
	set ret = Item3_"^"_Item2Desc_"^"_Item3Decs
	q ret
}

/// w ##class(DHCMGNUR.DHCNurHEAPIItem).SetValid("1^Y")
ClassMethod SetValid(parr)
{
	q:parr=""
	set id=$P(parr,"^",1) q:id=""
	set valid = $P(parr,"^",2)
	set object = ##class(DHCMGNUR.DHCNurHEAPIItem).%OpenId(id)
	if object.%ExistsId(id)
	{
		TStart
		set object.ItemValid=valid
		set sc = object.%Save()
		if $$$ISERR(sc)
		{
			TRollBack
			Do $System.Status.DisplayError(sc)
   			q "Fail"
		}
		else
		{
			TCommit
			q "Success"
		}
	}
	else
	{
		q "Is Not Exist"
	}
}

Storage Default
{
<Data name="DHCNurHEAPIItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Describe</Value>
</Value>
<Value name="3">
<Value>Item2DR</Value>
</Value>
<Value name="4">
<Value>Item3</Value>
</Value>
<Value name="5">
<Value>ItemValid</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.DHCNurHEAPIItemD</DataLocation>
<DefaultData>DHCNurHEAPIItemDefaultData</DefaultData>
<ExtentSize>1000000</ExtentSize>
<IdLocation>^DHCMGNUR.DHCNurHEAPIItemD</IdLocation>
<IndexLocation>^DHCMGNUR.DHCNurHEAPIItemI</IndexLocation>
<StreamLocation>^DHCMGNUR.DHCNurHEAPIItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
