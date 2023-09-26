Class User.DHCNURListLink Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_NURListLink ]
{

Property Name As %String(TRUNCATE = 1);

Property ListCode As %String(TRUNCATE = 1);

Property InCode As %String(TRUNCATE = 1);

Property PrintCode As %String(TRUNCATE = 1);

Property typ As %String(TRUNCATE = 1);

Property UserREC As %String(TRUNCATE = 1);

Property RECDate As %Library.Date;

Property RECTime As %Library.Time;

Index CodeIndex On ListCode;

Index PrintCodeIndex On (ListCode, PrintCode);

ClassMethod getlocward(loc) As %String
{
  s ward=$O(^PAWARD(0,"WARD_LocationDR",loc,"")) 
  q ward
}

//d ##class(User.DHCNURListLink).GetDepModel("48")

ClassMethod GetDepModel(adm As %String) As %String
{
   s LocId=$p(^PAADM(adm),"^",4)
     s curWardId=$p($g(^PAADM(adm)),"^",70) 
     s Ward=..getlocward(LocId)
     s totelstr=""
     s max=0
     s rw="" f  s rw=$o(^DHCNurDepModelSet(rw)) q:rw=""  d
     .s DepModelStr=$G(^DHCNurDepModelSet(rw))
     .s totelstr=totelstr_"^"_DepModelStr
     b
   
     f ii=1:1:$L(totelstr,"^") d
	 .s DepModel=$P(totelstr,"^",ii)
	 .//b ;99
	 .q:DepModel=""
	 .s ModelKey=$P(DepModel,"|",1)
	 .s ModelName=$P(DepModel,"|",2)
	 .s ModelSort=$P(DepModel,"|",3)
	 .s PrintCode=""
	 .i ModelKey'="" s PrintCode=..getPrintCode(ModelKey)
	 .s flag=..GetModelDataStatus(adm,ModelKey)
	 .//b ;55
	 .i flag'=0 s DepModel(ModelKey)=ModelKey_"|"_PrintCode
	 .//s DepModel(ModelKey)=ModelKey_"|"_PrintCode
	b ;44
	s ret=""
	s sort="" f  s sort=$O(DepModel(sort)) q:sort=""  d
	.s ret=ret_DepModel(sort)_"^"
	b ;66
 	q ret
}

//d ##class(User.DHCNURListLink).GetPerModel("48")

ClassMethod GetPerModel(adm As %String) As %String
{
    
     s ret="" 
     s id="" f  s id=$O(^User.DHCNURListLinkD(id)) q:id=""  d
 	 .s a=##class(User.DHCNURListLink).%OpenId(id)
 	 .s PrintCode=a.PrintCode
 	 .s Code=a.Code
 	 .s typ=a.typ
 	 .s Desc=a.Name
 	 .s flag=..GetModelDataStatus(adm,Code)
	 .i flag'=0 d
	 ..i ret="" s ret=Desc_"^"_Code_"^"_PrintCode_"^"_typ
	 ..e  s ret=ret_"|"_Desc_"^"_Code_"^"_PrintCode_"^"_typ
	 s Consultret=..GetAdmConsult(adm)
	 i Consultret'="" s ret=ret_"|"_Consultret
 	q ret
}

ClassMethod GetAdmConsult(adm) As %String
{
  	//w ##class(web.DHCConsult).GetConsult("340810^2011-05-23^2011-05-25^true","addconsult")
            q:adm="" ""
            s ret=""
			s id="" f  s id=$O(^User.DHCConsultationI("Adm"," "_adm,id)) q:id=""  d
			.s a=^User.DHCConsultationD(id)
			.i ret="" s ret=id_"^"_"DHCConsultPrn^会诊"
			.e  s ret=ret_"|"_id_"^"_"DHCConsultPrn^会诊"
			q ret
}

ClassMethod GetModelDataStatus(EpisodeID, EmrCode) As %String
{
	//w ##class(web.DHCMGNurData).GetModelDataStatus(11062752,"DHCNURANHUISPLIST")
	s ret=0
	s id=""
	if (EpisodeID'="")&&(EmrCode'="")
	{
	 s code=$ZConvert(EmrCode,"U")
	 i code="DHCNURANHUISPLIST" s code="DHCNURANHUI21"
	 //s ^fuckwxy(EpisodeID,code)=code
	 //s id=""  s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,id))
	 
	 s DHCMoudid=""  f  s DHCMoudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,DHCMoudid)) q:DHCMoudid=""  d
	 .i DHCMoudid'="" d
	 ..s b=##class(Nur.DHCMoudData).%OpenId(DHCMoudid)
	 ..i (b.RecCancelUser="") s id=DHCMoudid
	 
	 s par=""  s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_EpisodeID,par))
	 if par'=""
	 {
	 s rw="" f  s rw=$o(^Nur.DHCNurseRecSubD(par,rw)) q:rw=""  d
	 .s tmp("Id")=par_"||"_rw
	 .s a=##class(Nur.DHCNurseRecSub).%OpenId(tmp("Id"))
	 .//w !,a.RecTyp_"^"_a.RecCancelUser
	 .i (a.RecTyp=EmrCode)&&(a.RecCancelUser="") s id=tmp("Id")
	 }	 
	}
	i id'="" s ret=1
	q ret
}

ClassMethod getdata() As %String
{
   s ret="" 
   s id="" f  s id=$O(^User.DHCNURListLinkD(id)) q:id=""  d
 	.s a=##class(User.DHCNURListLink).%OpenId(id)
 	.s PrintCode=a.PrintCode
 	
	.s ret=ret_"^rw|"_id_"^PrintCode|"_PrintCode
	q ret
}

//d ##class(User.DHCNURListLink).getPrintCode("DHCNURXH12")

ClassMethod getPrintCode(RecTyp) As %String
{
   s ret="" 
   s RecTyp=$zconvert(RecTyp,"U")
   s id="" f  s id=$O(^User.DHCNURListLinkI("CodeIndex"," "_RecTyp,id)) q:id=""  d
 	.s a=##class(User.DHCNURListLink).%OpenId(id)
 	.s PrintCode=a.PrintCode
 	.s typ=a.typ
	.s ret=PrintCode_"|"_typ

	q ret
}

ClassMethod Save(parr As %String, id As %String) As %String
{
	s ^oeek=parr
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	if id=""
	{
	 s a=##class(User.DHCNURListLink).%New()
	}else
	{
	 s a=##class(User.DHCNURListLink).%OpenId(id)
	}
	if $D(tmp("ListCode")) s a.ListCode=tmp("ListCode")
	if $D(tmp("InCode")) s a.InCode=tmp("InCode")
	if $D(tmp("PrintCode")) s a.PrintCode=tmp("PrintCode")
	if $D(tmp("typ")) s a.typ=tmp("typ")
	if $D(tmp("Name")) s a.Name=tmp("Name")
	s a.RECDate=$p($h,",",1)
	s a.RECTime=$p($h,",",2)
	s a.UserREC=%session.Get("LOGON.USERNAME")
	d a.%Save()
	q 0
}

ClassMethod QtDelete(id As %String) As %String
{
  
   s a=##class(User.DHCNURListLink).%DeleteId(id)
   q 0
}

// d ##class(%ResultSet).RunQuery("web.DHCNurblsjflwh","CRItem","parr$111")

ClassMethod getVal(id) As %String
{
	s ret=""
	
	if id'=""
	{
	s a=##class(User.DHCNURListLink).%OpenId(id)	
	s tmp("Name")=a.Name
	s tmp("ListCode")=a.ListCode
	s tmp("InCode")=a.InCode
	s tmp("typ")=a.typ
	s tmp("PrintCode")=a.PrintCode	
	s k=""
	f {
	s k=$O(tmp(k))
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"
	}
	}
	q ret
}

ClassMethod CRItemExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    s id="" f  s id=$O(^User.DHCNURListLinkD(id)) q:id=""  d
 	.s a=##class(User.DHCNURListLink).%OpenId(id)
	.s rw=id
	.s ret=""
	.s ret=..getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
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

Query CRItem(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod CRItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CRItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Storage Default
{
<Data name="DHCNURListLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>ListCode</Value>
</Value>
<Value name="4">
<Value>InCode</Value>
</Value>
<Value name="5">
<Value>PrintCode</Value>
</Value>
<Value name="6">
<Value>typ</Value>
</Value>
<Value name="7">
<Value>UserREC</Value>
</Value>
<Value name="8">
<Value>RECDate</Value>
</Value>
<Value name="9">
<Value>RECTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCNURListLinkD</DataLocation>
<DefaultData>DHCNURListLinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNURListLinkD</IdLocation>
<IndexLocation>^User.DHCNURListLinkI</IndexLocation>
<StreamLocation>^User.DHCNURListLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
