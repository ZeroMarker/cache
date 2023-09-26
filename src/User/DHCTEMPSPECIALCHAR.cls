Class User.DHCTEMPSPECIALCHAR Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property CharDesc As %String(TRUNCATE = 1);

Property HospitalID As %String(TRUNCATE = 1);

Index Hosp On HospitalID;

ClassMethod Save(desc As %String, id As %String) As %String
{
	if id'="" s a=##class(User.DHCTEMPSPECIALCHAR).%OpenId(id)
	else  s a=##class(User.DHCTEMPSPECIALCHAR).%New()
	s a.CharDesc=desc
	d a.%Save()
	q 0
}

ClassMethod Delete(id As %String) As %String
{
	d ##class(User.DHCTEMPSPECIALCHAR).%DeleteId(id)
	q 0
}

ClassMethod CRItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CRItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod CRItemExecute(ByRef qHandle As %Binary, HospitalID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	//多院区-增加索引更新字段
#; 	i '$d(^User.DHCTEMPSPECIALCHARI("Hosp")) {
#;	 	d ##class(User.DHCTEMPSPECIALCHAR).%BuildIndices()
#; 	}
#; 	s charsHosp=$o(^User.DHCTEMPSPECIALCHARI("Hosp",""))
#;	s charsHosp=$tr(charsHosp," ","")
#;	i charsHosp="" {
#;		&SQL(UPDATE SQLUser.DHCTEMPSPECIALCHAR SET HospitalID=:HospitalID WHERE HospitalID IS NULL)
#;	}
#; 	s id="" f  s id=$O(^User.DHCTEMPSPECIALCHARI("Hosp"," "_HospitalID,id)) q:id=""  d
 	s id="" f  s id=$O(^User.DHCTEMPSPECIALCHARD(id)) q:id=""  d
 	.s a=^User.DHCTEMPSPECIALCHARD(id)
	.s desc=$List(a,2)
	.s rw=id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(desc,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CRItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CRItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query CRItem(HospitalID As %String) As %Query(ROWSPEC = "desc,rw")
{
}

ClassMethod IfCanAdd(user As %String) As %String
{
	//w ##class(User.DHCTEMPSPECIALCHAR).IfCanAdd("1")
	s flag="N"
	i user="1" s flag="Y"
	e  d
	.s grp=$P($G(^SSU("SSUSR",user)),"^",5)
	.i grp["护理部" s flag="Y"
	q flag
}

ClassMethod CRItemNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CRItemNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("User.DHCTEMPSPECIALCHAR","CRItemNew")

ClassMethod CRItemNewExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s num=1
 	s id="" f  s id=$O(^User.DHCTEMPSPECIALCHARD(id)) q:id=""  d
 	.s a=^User.DHCTEMPSPECIALCHARD(id)
	.s desc=$List(a,2)
	.i num=1 s one=desc
	.i num=2 s two=desc
	.i num=3 s three=desc
	.i num=4 s four=desc
	.i num=5 s five=desc
	.i num=5 d outsep
	.s num=num+1
	.i num=6 s num=1,(one,two,three,four,five)=""
	i num'=1 d outsep
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outsep
	set Data=$lb(one,two,three,four,five)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CRItemNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CRItemNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query CRItemNew() As %Query(ROWSPEC = "one,two,three,four,five")
{
}

/// Creator:     yaojining
/// CreateDate:  2020.06.20
/// Description: 后期扩展的院区ID字段，生成索引，并且自动赋默认值
/// Input:       HospitalID
/// Return：     
/// Others:      ##class(NurMp.RecordsBrowserFtpInfo).setHosp("2")
ClassMethod setHosp(HospitalID) As %String
{
	i '$d(^User.DHCTEMPSPECIALCHARI("Hosp")) {
	 	d ##class(User.DHCTEMPSPECIALCHAR).%BuildIndices()
 	}
 	s charsHosp=$o(^User.DHCTEMPSPECIALCHARI("Hosp",""))
	s charsHosp=$tr(charsHosp," ","")
	i charsHosp="" {
		&SQL(UPDATE SQLUser.DHCTEMPSPECIALCHAR SET HospitalID=:HospitalID WHERE HospitalID IS NULL)
	}
}

Storage Default
{
<Data name="DHCTEMPSPECIALCHARDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CharDesc</Value>
</Value>
<Value name="3">
<Value>HospitalID</Value>
</Value>
</Data>
<DataLocation>^User.DHCTEMPSPECIALCHARD</DataLocation>
<DefaultData>DHCTEMPSPECIALCHARDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCTEMPSPECIALCHARD</IdLocation>
<IndexLocation>^User.DHCTEMPSPECIALCHARI</IndexLocation>
<StreamLocation>^User.DHCTEMPSPECIALCHARS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
