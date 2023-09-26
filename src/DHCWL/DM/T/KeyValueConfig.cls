/// d ##class(DHCWL.DM.T.KeyValueConfig).%BuildIndices()
Class DHCWL.DM.T.KeyValueConfig Extends %Persistent
{

// consist of ClassFullName||RowId

Property Master As %String [ Required ];

Property KeyName As %String [ Required ];

Property Value As %String(MAXLEN = 512);

Index MainI On (Master, KeyName) [ PrimaryKey ];

Index MKI On (Master As EXACT, KeyName As EXACT);

// d ##class(DHCWL.DM.T.KeyValueConfig).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.KeyValueConfig)
	k ^DHCWL.DM.T.KeyValueConfigD,^DHCWL.DM.T.KeyValueConfigI
}

ClassMethod Put(master, key, value) As %Status
{
	s flag=0,kvid="",status=$$$OK
	if ('$d(^DHCWL.DM.T.KeyValueConfigI("MKI",master,key))){
	}else{
		s kvid=$o(^DHCWL.DM.T.KeyValueConfigI("MKI",master,key,""))
		if '$d(^DHCWL.DM.T.KeyValueConfigD(kvid)){
		}else{
			s flag=1
		}
	}
	if flag=1{
		s obj=##class(DHCWL.DM.T.KeyValueConfig).%OpenId(kvid)
		s obj.Value=value
		s status= obj.%Save()
	}else{
		s obj=##class(DHCWL.DM.T.KeyValueConfig).%New()
		s obj.Master=master,obj.KeyName=key,obj.Value=value
		s status=  obj.%Save()
	}
	q status
}

ClassMethod Get(master, ByRef kvConfig)
{
	k kvConfig
	i $d(^DHCWL.DM.T.KeyValueConfigI("MainI"," "_master)) d
	.s key="" f  s key=$o(^DHCWL.DM.T.KeyValueConfigI("MainI"," "_master,key)) q:key=""  d
	..s kvid=$o(^DHCWL.DM.T.KeyValueConfigI("MainI"," "_master,key,""))
	..q:'$d(^DHCWL.DM.T.KeyValueConfigD(kvid))
	..s value=$lg(^DHCWL.DM.T.KeyValueConfigD(kvid),4)
	..s keyName=$lg(^DHCWL.DM.T.KeyValueConfigD(kvid),3)
	..s kvConfig(keyName)=value
}

// d ##class(DHCWL.DM.T.KeyValueConfig).GetValue(" METATABLEBASE-MDS-1"," TABLE")

ClassMethod GetValue(master As %String, key As %String)
{
	q:'$d(^DHCWL.DM.T.KeyValueConfigI("MainI",master,key)) ""
	s kvid=$o(^DHCWL.DM.T.KeyValueConfigI("MainI",master,key,""))
	q:'$d(^DHCWL.DM.T.KeyValueConfigD(kvid)) ""
	q $lg(^DHCWL.DM.T.KeyValueConfigD(kvid),4)
}

ClassMethod GetList(master) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	s master=" "_$zcvt(master,"U")
	i $d(^DHCWL.DM.T.KeyValueConfigI("MainI",master)) d
	.s key="" f  s key=$o(^DHCWL.DM.T.KeyValueConfigI("MainI",master,key)) q:key=""  d
	..s kvid=$o(^DHCWL.DM.T.KeyValueConfigI("MainI",master,key,""))
	..q:'$d(^DHCWL.DM.T.KeyValueConfigD(kvid))
	..s obj=##class(KeyValueConfig).%OpenId(kvid)
	..d list.Insert(obj)
	q list
}

Storage Default
{
<Data name="KeyValueConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Master</Value>
</Value>
<Value name="3">
<Value>KeyName</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.KeyValueConfigD</DataLocation>
<DefaultData>KeyValueConfigDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.KeyValueConfigD</IdLocation>
<IndexLocation>^DHCWL.DM.T.KeyValueConfigI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.KeyValueConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
