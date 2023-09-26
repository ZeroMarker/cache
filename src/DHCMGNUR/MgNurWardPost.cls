Class DHCMGNUR.MgNurWardPost Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 指向CT_LOC
Property PostWard As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = Post_Ward ];

/// 指向MgNurPost
Property PostID As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = Post_ID ];

/// 备注
Property PostRemarks As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = Post_Remarks ];

/// Order
Property PostOrder As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Post_Order ];

/// NurseNeed
Property NurseNeed As %String [ SqlColumnNumber = 6, SqlFieldName = Nurse_Need ];

Property PostValid As %String [ SqlColumnNumber = 7, SqlFieldName = Post_Valid ];

Index Ward On PostWard;

Index WardCode On (PostWard, PostID);

Index WardOrder On (PostWard, PostOrder);

/// w ##class(DHCMGNUR.MgNurWardPost).Save("PostWard|1018^PostID|3^PostReamrks|")
ClassMethod Save(parr)
{
	q:parr=""
	s tmp=""
	d ##class(web.DHCNurRosterComm).setTmp(parr,.tmp)
	s PostWard=$g(tmp("PostWard"))
	s PostID=$g(tmp("PostID"))
	s id = $O(^DHCMGNUR.MgNurWardPostI("WardCode"," "_PostWard," "_PostID,""))
	i id="" d
	.s a=##class(DHCMGNUR.MgNurWardPost).%New()
	.s a.PostWard=tmp("PostWard")
	.s a.PostID=tmp("PostID")
	.s a.PostOrder=..getCount(tmp("PostWard"))+1
	else  d
	.s a=##class(DHCMGNUR.MgNurWardPost).%OpenId(id)
	s a.PostRemarks=$g(tmp("PostReamrks"))
	s a.NurseNeed=$g(temp("PostPerNum"))
	s a.PostValid="Y"
	TStart
	s sc=a.%Save()
	I $$$ISERR(sc)
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "ERROR"
	}
	else
	{
		TCommit
		q "OK"
	}
}

ClassMethod getCount(WardID)
{
	s ret=0
	s wpID="" f  s wpID=$O(^DHCMGNUR.MgNurWardPostI("Ward"," "_WardID,wpID)) q:wpID=""  d
	.s ret=ret+1 
	q ret
}

ClassMethod MultSave(parr As %String) As %String
{
	q:parr="" -1
	s len=$L(parr,"@")
	f i=1:1:len d
	.s parm=$P(parr,"@",i)
	.d ..Save(parm)
	q 1
}

/// d ##class(DHCMGNUR.MgNurWardPost).Delete("4^5^6")
ClassMethod Delete(parr)
{
	q:parr=""
	s len=$L(parr,"^")
	f i=1:1:len d
	.s ID=$P(parr,"^",i)
	.s a=##class(DHCMGNUR.MgNurWardPost).%OpenId(ID)
	.s PostWard=a.PostWard
	.s PostOrder=a.PostOrder
	.d a.%DeleteId(ID)
	.s norder=PostOrder+1
	.f AdmOrder=(PostOrder+1):1:(..getCount(PostWard)) d
	..s PID=$O(^DHCMGNUR.MgNurWardPostI("WardOrder"," "_PostWard," "_AdmOrder,""))
	..q:PID=""
	..s b = ##class(DHCMGNUR.MgNurWardPost).%OpenId(PID)
	..s b.PostOrder=norder-1
	..d b.%Save()
	..s norder=norder+1
	q 0
}

ClassMethod getValue(ID)
{
	;w ##class(DHCMGNUR.MgNurWardPost).getValue("9")
	q:ID=""
	s a=##class(DHCMGNUR.MgNurWardPost).%OpenId(ID)
	s ret="rw|"_ID
	s PostID=a.PostID
	q:PostID="" ""
	s pobj = ##class(DHCMGNUR.MgNurPost).%OpenId(PostID)
	q:pobj.PostValid="N"
	s ret=ret_"^PostID|"_PostID
	s ret=ret_"^PostCode|"_pobj.PostCode
	s ret=ret_"^PostDesc|"_pobj.PostDesc
	;s ret=ret_"^PostPerNum|"_pobj.PostPerNum
	s ret=ret_"^PostHours|"_pobj.PostHours
	s ret=ret_"^PostNightHours|"_pobj.PostNightHours
	s ret=ret_"^PostStTime|" s:pobj.PostStTime'="" ret=ret_$zt(pobj.PostStTime,2)
	s ret=ret_"^PostEndTime|" s:pobj.PostEndTime'="" ret=ret_$zt(pobj.PostEndTime,2)
	s ret=ret_"^PostType|"_$tr(pobj.PostType,"||","__")
	i pobj.PostType'="" d
	.s type=##class(DHCMGNUR.CommDictionarySub).%OpenId(pobj.PostType)
	.s TypeCode=type.Code
	.s TypeDesc=type.CodeDesc
	s ret=ret_"^TypeCode|"_$g(TypeCode)
	s ret=ret_"^TypeDesc|"_$g(TypeDesc)
	s ret=ret_"^PostWorkType|"_$tr(pobj.PostWorkType,"||","__")
	i pobj.PostWorkType'="" d
	.s worktype=##class(DHCMGNUR.CommDictionarySub).%OpenId(pobj.PostWorkType)
	.s WorkTypeCode=worktype.Code
	.s WorkTypeDesc=worktype.CodeDesc
	s ret=ret_"^WorkTypeCode|"_$g(WorkTypeCode)
	s ret=ret_"^WorkTypeDesc|"_$g(WorkTypeDesc)
	s ret=ret_"^PostHoliday|"_pobj.PostHoliday
	;s ret=ret_"^PostRemarks|"_pobj.PostRemarks
	;s ret=ret_"^PostOrder|"_pobj.PostOrder
	;s ret=ret_"^PostValid|"_pobj.PostValid
	s ret=ret_"^PostWard|"_a.PostWard
	i a.PostWard'="" d
	.s wardcode=$P(^CTLOC(a.PostWard),"^",1)
	.s warddesc=$P(^CTLOC(a.PostWard),"^",2)
	s ret=ret_"^WardDesc|"_$g(warddesc)
	s ret=ret_"^WardCode|"_$g(wardcode)
	s ret=ret_"^PostOrder|"_a.PostOrder
	s ret=ret_"^PostPerNum|"
	s:a.NurseNeed="" ret=ret_pobj.PostPerNum
	s:a.NurseNeed'="" ret=ret_a.NurseNeed
	s ret=ret_"^PostRemarks|" 
	s:a.PostRemarks="" ret=ret_pobj.PostRemarks
	s:a.PostRemarks'="" ret=ret_a.PostRemarks
	q ret
}

/// d ##class(DHCMGNUR.MgNurWardPost).changeOrder("2^3")
ClassMethod changeOrder(parr)
{
	q:parr="" -1
	s ID=$P(parr,"^",1) q:ID="" 0
	s Order=$P(parr,"^",2)
	s object = ##class(DHCMGNUR.MgNurWardPost).%OpenId(ID)
	s WardId=object.PostWard
	s OldOrder = object.PostOrder
	s object.PostOrder = Order
	i OldOrder>Order d
	.f AdmOrder=(OldOrder-1):-1:Order d
	..s ID2=$O(^DHCMGNUR.MgNurWardPostI("WardOrder"," "_WardId," "_AdmOrder,""))
	..q:ID2=""
	..s a = ##class(DHCMGNUR.MgNurWardPost).%OpenId(ID2)
	..s a.PostOrder = AdmOrder+1
	..s sc = a.%Save()
	..i $$$ISERR(sc) Do $System.Status.DisplayError(sc)
	i OldOrder<Order d
	.f AdmOrder=(OldOrder+1):1:Order d
	..s ID2=$O(^DHCMGNUR.MgNurWardPostI("WardOrder"," "_WardId," "_AdmOrder,""))
	..q:ID2=""
	..s b = ##class(DHCMGNUR.MgNurWardPost).%OpenId(ID2)
	..s b.PostOrder = AdmOrder-1
	..s sc = b.%Save()
	..i $$$ISERR(sc) Do $System.Status.DisplayError(sc)
	s sc = object.%Save()
	i $$$ISERR(sc) Do $System.Status.DisplayError(sc)
	q 1
}

/// 按查询岗位信息
Query FindPostData(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPostDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurWardPost","FindPostData","27")
	Set repid=$I(^CacheTemp)
	set ind=1
	set WardId = $P(parr,"^",1)
	set valid=$P(parr,"^",2)
	set tmp=""
 	set ID = "" for  set ID = $O(^DHCMGNUR.MgNurWardPostI("Ward"," "_WardId,ID)) q:ID=""  do
	.s a=##class(DHCMGNUR.MgNurWardPost).%OpenId(ID)
	.q:((valid="")||(valid="N"))&&(a.PostValid="N")
	.s PostOrder=a.PostOrder
	.s tmp(PostOrder)=..getValue(ID)
	s Order="" f  s Order=$O(tmp(Order)) q:Order=""  d
	.set ret=tmp(Order)
	.Do OutputPost
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPost
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPostDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPostDataExecute ]
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

ClassMethod FindPostDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPostDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SetValid(parr As %String) As %String
{
	q:parr="" -1
	s postid=$P(parr,"^",1)
	s valid=$P(parr,"^",2)
	s a=##class(DHCMGNUR.MgNurWardPost).%OpenId(postid)
	s a.PostValid=valid
	s sc=a.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

Storage Default
{
<Data name="MgNurWardPostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PostID</Value>
</Value>
<Value name="3">
<Value>PostOrder</Value>
</Value>
<Value name="4">
<Value>PostRemarks</Value>
</Value>
<Value name="5">
<Value>PostWard</Value>
</Value>
<Value name="6">
<Value>NurseNeed</Value>
</Value>
<Value name="7">
<Value>PostValue</Value>
</Value>
<Value name="8">
<Value>PostValid</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurWardPostD</DataLocation>
<DefaultData>MgNurWardPostDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurWardPostD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurWardPostI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurWardPostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
