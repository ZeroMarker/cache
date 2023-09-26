/// 岗位信息
Class DHCMGNUR.MgNurPost Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 岗位代码
Property PostCode As %String [ SqlColumnNumber = 2, SqlFieldName = Post_Code ];

/// 岗位名称
Property PostDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Post_Desc ];

/// 人数
Property PostPerNum As %String [ SqlColumnNumber = 4, SqlFieldName = Post_PerNum ];

/// 小时数
Property PostHours As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Post_Hours ];

/// 包含夜班小时数
Property PostNightHours As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Post_NightHours ];

/// 开始时间
Property PostStTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = Post_StTime ];

/// 结束时间
Property PostEndTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = Post_EndTime ];

/// 班次类型
Property PostType As %String [ SqlColumnNumber = 9, SqlFieldName = Post_Type ];

/// 岗位分类
Property PostWorkType As %String [ SqlColumnNumber = 10, SqlFieldName = Post_WorkType ];

/// 节假日
Property PostHoliday As %String [ SqlColumnNumber = 11, SqlFieldName = Post_Holiday ];

/// 备注
Property PostRemarks As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Post_Remarks ];

/// 状态
Property PostValid As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = Post_Valid ];

/// 序号
Property PostOrder As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = Post_Order ];

/// 科室
Property PostWard As %String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = Post_Ward ];

Index PostWard On PostWard;

Index WardCode On (PostWard, PostCode);

Index WardOrder On (PostWard, PostOrder);

/// 保存岗位信息
/// w ##class(DHCMGNUR.MgNurPost).Save("PostCode|白班^PostDesc|白班^PostPerNum|1^PostHours|8^PostNightHours|0^PostStTime|08:00^PostEndTime|17:00^PostType|29__1^PostWorkType|64__1^PostHoliday|N^PostRemarks|")
/// 
ClassMethod Save(parr As %String)
{
	q:parr="" -1
	set tmp=""
	d ##class(web.DHCNurRosterComm).setTmp(parr,.tmp)
	i $g(tmp("ID"))="" d
	.s PostObj = ##class(DHCMGNUR.MgNurPost).%New()
	.s PostObj.PostOrder = ..getCount($g(tmp("PostWard")))+1
	else  d
	.s PostObj = ##class(DHCMGNUR.MgNurPost).%OpenId(tmp("ID"))
	s PostObj.PostWard=$g(tmp("PostWard"))
	s PostObj.PostCode = $g(tmp("PostCode"))
	s PostObj.PostDesc = $g(tmp("PostDesc"))
	s PostObj.PostPerNum = $g(tmp("PostPerNum"))
	s PostObj.PostHours = $g(tmp("PostHours"))
	s PostObj.PostNightHours= $g(tmp("PostNightHours"))
	s PostObj.PostStTime = $zth($g(tmp("PostStTime")),2)
	s PostObj.PostEndTime = $zth($g(tmp("PostEndTime")),2)
	s PostObj.PostType=$tr($g(tmp("PostType")),"__","||")
	s PostObj.PostWorkType=$tr($g(tmp("PostWorkType")),"__","||")
	s PostObj.PostHoliday=$g(tmp("PostHoliday"))
	s PostObj.PostRemarks = $g(tmp("PostRemarks"))
	s PostObj.PostValid="Y"
	TStart
	set sc = PostObj.%Save()
	I $$$ISERR(sc)
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q 0
	}
	else
	{
		TCommit
		q PostObj.%Id()
	}
}

ClassMethod getCount(ward)
{
	s maxOrder=0
	s ID="" f  s ID=$O(^DHCMGNUR.MgNurPostI("PostWard"," "_ward,ID)) q:ID=""  d
	.q:+ID=0
	.s aa=##class(DHCMGNUR.MgNurPost).%OpenId(ID)
	.s PostOrder=aa.PostOrder
	.s PostValid=aa.PostValid
	.q:PostValid="N"
	.i PostOrder>maxOrder s maxOrder=PostOrder
	q maxOrder
}

/// 通过Id查询Post数据
/// Input:parr(PostId)
/// w ##class(DHCMGNUR.MgNurPost).getValue("1")
ClassMethod getValue(ID As %String) As %String
{
	q:ID="" ""
	q:$D(^DHCMGNUR.MgNurPostD(ID))=0 ""
	s pobj = ##class(DHCMGNUR.MgNurPost).%OpenId(ID)
	s ret="rw|"_ID
	s ret=ret_"^PostWard|"_pobj.PostWard
	i pobj.PostWard'="" d
	.s wardcode=$P(^CTLOC(pobj.PostWard),"^",1)
	.s warddesc=$P(^CTLOC(pobj.PostWard),"^",2)
	s ret=ret_"^WardCode|"_$g(wardcode)
	s ret=ret_"^WardDesc|"_$g(warddesc)
	s ret=ret_"^PostCode|"_pobj.PostCode
	s ret=ret_"^PostDesc|"_pobj.PostDesc
	s ret=ret_"^PostPerNum|"_pobj.PostPerNum
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
	s ret=ret_"^Remarks|"_pobj.PostRemarks
	s ret=ret_"^PostOrder|"_pobj.PostOrder
	s ret=ret_"^PostValid|"_pobj.PostValid
	s ret=ret_"^PostID|"_ID
	q ret
}

/// 按查询岗位信息
/// d ##Class(%ResultSet).RunQuery("DHCMGNUR.MgNurPost","FindPostData","27^Y")
Query FindPostData(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPostDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	set ind=1
	s ^TEMP("1703221616001")=parr
	s tmp=""
	s wardid= $P(parr,"^",1)
	s valid = $P(parr,"^",2)
	i wardid'="" d
 	.;s order="" f  s order = $O(^DHCMGNUR.MgNurPostI("WardOrder"," "_wardid,order)) q:order=""  d
 	.;s postid="" f  s postid=$O(^DHCMGNUR.MgNurPostI("PostWard"," "_wardid,postid)) q:postid=""  d
 	.s ord="" f  s ord=$O(^DHCMGNUR.MgNurPostI("WardOrder"," "_wardid,ord)) q:ord=""  d
 	..s postid="" f  s postid=$O(^DHCMGNUR.MgNurPostI("WardOrder"," "_wardid,ord,postid)) q:postid=""  d
 	...s PostObj=##class(DHCMGNUR.MgNurPost).%OpenId(postid)
	...s PostValid=PostObj.PostValid
	...q:(valid=PostValid)
	...s postward=PostObj.PostWard
	...s postord=PostObj.PostOrder
	...s ret=PostObj.getValue(postid)
	...;s tmp(postward,postord)=PostObj.getValue(postid)
	...d OutputPost
	;s pord="" f  s pord=$O(tmp(wardid,pord)) q:pord=""  d
	;.s ret=tmp(wardid,pord)
	;.d OutputPost
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

/// 设置标志位
/// input:parr(PostId)
/// d ##class(DHCMGNUR.MgNurPost).SetValid("1^N")
ClassMethod SetValid(parr As %String) As %String
{
	q:parr=""
	s ID=$P(parr,"^",1)
	s valid=$P(parr,"^",2)
	s PostObj=##class(DHCMGNUR.MgNurPost).%OpenId(ID)
	s PostObj.PostValid=valid
	s postward=PostObj.PostWard
	s postorder=PostObj.PostOrder
	i valid="N" d 
	.s pid="" f  s pid=$O(^DHCMGNUR.MgNurPostI("PostWard"," "_postward,pid)) q:pid=""  d
	..s pobj=##class(DHCMGNUR.MgNurPost).%OpenId(pid)
	..s porder=pobj.PostOrder
	..i postorder<porder s pobj.PostOrder=porder-1
	..d pobj.%Save()
	.s PostObj.PostOrder=0
	e  d
	.s maxorder=..getCount(PostObj.PostWard)
	.s PostObj.PostOrder=maxorder+1
	TStart
	s sc=PostObj.%Save()
	I $$$ISERR(sc)
	{
		TRollback
		q "操作失败！"
	}
	else
	{
		TCommit
		q "操作成功！"
	}
}

/// 顺序号改变
/// d ##class(DHCMGNUR.MgNurPost).ChangeOrder("1^8")
ClassMethod ChangeOrder(parr As %String) As %String
{
	q:parr="" 0
	s postid=$P(parr,"^",1) 
	s order=$P(parr,"^",2)
	q:(postid="")||(order="") 0
	s postobj=##class(DHCMGNUR.MgNurPost).%OpenId(postid)
	s postward=postobj.PostWard
	s postorder=postobj.PostOrder
	s maxorder=..getCount(postward)
	i order<0 s order=1
	i order>maxorder s order=maxorder
	s pid="" f  s pid=$O(^DHCMGNUR.MgNurPostI("PostWard"," "_postward,pid)) q:pid=""  d
	.s pobj=##class(DHCMGNUR.MgNurPost).%OpenId(pid)
	.s porder=pobj.PostOrder
	.i (postorder<porder)&&(porder<=order) d
	..b ;01
	..s pobj.PostOrder=porder-1
	.i (order<=porder)&&(porder<postorder) d
	..s pobj.PostOrder=porder+1
	..b ;02
	.d pobj.%Save()
	s postobj.PostOrder=order
	d postobj.%Save()
	q 1
}

/// d ##class(DHCMGNUR.MgNurPost).CheckRepeat("")
ClassMethod CheckRepeat(parr As %String) As %String
{
	s ^TEMP("g121011380001")=parr
	s wardid=$P(parr,"^",1)
	s postcode=$P(parr,"^",2)
	s rowid=$P(parr,"^",3) 
	q:(wardid="")||(postcode="") 0
	s ret=""
	s Code=$ZCVT(postcode,"U")
	s ID=""  f  s ID=$O(^DHCMGNUR.MgNurPostI("WardCode"," "_wardid," "_Code,ID)) q:(ID="")!(ret'="")  d
	.s postobj=##class(DHCMGNUR.MgNurPost).%OpenId(ID)
	.s valid=postobj.PostValid
	.i (valid="N")&&(ret="") s ret="存在相同代码的班次，但已作废！"
	.e  i (ID=rowid) s ret=""
	.e  s ret="存在相同的代码！"
	i ret="" q 0
	e  q ret
}

Storage Default
{
<Data name="MgNurPostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PostCategoryDR</Value>
</Value>
<Value name="3">
<Value>PostCode</Value>
</Value>
<Value name="4">
<Value>PostConfirm</Value>
</Value>
<Value name="5">
<Value>PostHolidayNurse</Value>
</Value>
<Value name="6">
<Value>PostIsNigth</Value>
</Value>
<Value name="7">
<Value>PostLimits</Value>
</Value>
<Value name="8">
<Value>PostMaxTime</Value>
</Value>
<Value name="9">
<Value>PostName</Value>
</Value>
<Value name="10">
<Value>PostNeedNurse</Value>
</Value>
<Value name="11">
<Value>PostNotUse</Value>
</Value>
<Value name="12">
<Value>PostOrderNo</Value>
</Value>
<Value name="13">
<Value>PostRemarks</Value>
</Value>
<Value name="14">
<Value>PostWardDR</Value>
</Value>
<Value name="15">
<Value>PostCreateDate</Value>
</Value>
<Value name="16">
<Value>PostModifyDate</Value>
</Value>
<Value name="17">
<Value>PostHourNum</Value>
</Value>
<Value name="18">
<Value>PostIsNight</Value>
</Value>
<Value name="19">
<Value>PostValid</Value>
</Value>
<Value name="20">
<Value>PostStTime1</Value>
</Value>
<Value name="21">
<Value>PostEndTime1</Value>
</Value>
<Value name="22">
<Value>PostStTime2</Value>
</Value>
<Value name="23">
<Value>PostEndTime2</Value>
</Value>
<Value name="24">
<Value>PostDesc</Value>
</Value>
<Value name="25">
<Value>PostPerNum</Value>
</Value>
<Value name="26">
<Value>PostHours</Value>
</Value>
<Value name="27">
<Value>PostNightHours</Value>
</Value>
<Value name="28">
<Value>PostStTime</Value>
</Value>
<Value name="29">
<Value>PostEndTime</Value>
</Value>
<Value name="30">
<Value>PostType</Value>
</Value>
<Value name="31">
<Value>PostWorkType</Value>
</Value>
<Value name="32">
<Value>PostHoliday</Value>
</Value>
<Value name="33">
<Value>PostOrder</Value>
</Value>
<Value name="34">
<Value>PostWard</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurPostD</DataLocation>
<DefaultData>MgNurPostDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurPostD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurPostI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurPostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
