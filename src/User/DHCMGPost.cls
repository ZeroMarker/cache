Class User.DHCMGPost Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = DHCMG_Post ]
{

Property PostCode As %String(TRUNCATE = 1) [ SqlFieldName = Post_Code ];

//科室

Property PostDesc As %String(TRUNCATE = 1) [ SqlFieldName = Post_Desc ];

Property PostPerNums As %String(TRUNCATE = 1) [ SqlFieldName = Post_PerNums ];

Property PostMaxTime As %String(TRUNCATE = 1) [ SqlFieldName = Post_MaxTime ];

Property PostLocDr As %String(TRUNCATE = 1) [ SqlFieldName = Post_Loc_Dr ];

Property PostFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = Post_Flag ];

Property Postmem As %Library.String(TRUNCATE = 1) [ SqlFieldName = Post_mem ];

Property PostWeek As %Library.String(TRUNCATE = 1) [ SqlFieldName = Post_Week ];

Property PostWeekendPers As %Library.String(TRUNCATE = 1) [ SqlFieldName = Post_WeekendPers ];

Property PostTypDr As User.DHCMGCCode;

//不可用

Property PostCurrFlag As %Library.String(TRUNCATE = 1) [ SqlFieldName = Post_CurrFlag ];

//顺序号

Property PostSort As %Library.String(TRUNCATE = 1) [ SqlFieldName = Post_Sort ];

/// NightHour
Property PostNightHour As %Library.String(TRUNCATE = 1) [ SqlFieldName = Post_NightHour ];

/// 开始时间
Property PostStartTime As %Library.String(TRUNCATE = 1) [ SqlFieldName = Post_StartTime ];

/// 结束时间
Property PostEndTime As %Library.String(TRUNCATE = 1) [ SqlFieldName = Post_EndTime ];

//节假日

Property PostHolFlag As %Library.String(TRUNCATE = 1) [ SqlFieldName = Post_HolFlag ];

Index Loc On PostLocDr;

Index postloc On (PostLocDr, PostCode);

ClassMethod delpost(pstdr, loc) As %String
{
 //s a=##class(User.DHCMGPost).delpost(
 d ##class(User.DHCMGPost).%DeleteId(pstdr)   
 s rw=""  f  s rw=$O(^User.DHCMGPersonArrangeI("Loc"," "_loc,rw)) q:rw=""  d
 .s post=$listGet(^User.DHCMGPersonArrangeD(rw),6)
 .if post=pstdr d
 ..d ##class(User.DHCMGPersonArrange).%DeleteId(rw) 
 q 0
}

ClassMethod CopyDepPost(dep, todep) As %String
{
 s dep=$g(dep)
 s todep=$g(todep)
 q:(dep=todep) 0
 //s a=##class(User.DHCMGPost).CopyDepPost()
  	    s rw="" f  s rw=$O(^User.DHCMGPostI("Loc"," "_dep,rw)) q:rw=""  d
	      . s a=^User.DHCMGPostD(rw)
	      . s Code=$List(a,2)
	      . s Desc=$List(a,3)
	      . s Times=$List(a,5)
	      . s nums=$List(a,6)
	      . s flag=$List(a,7)
	      . s mem=$List(a,8)
	      . s week=$List(a,9)
	      . s weeknum=$List(a,10)
	      . s posttyp=$List(a,11)
	      . s postcurrflag=$ListGet(a,12)
	      . s NightHour=$ListGet(a,14)
	      . s StartTime=$ListGet(a,15)
	      . i StartTime'="" s StartTime=$zt(StartTime,2)
	      . s EndTime=$ListGet(a,16)	
	      . i EndTime'="" s EndTime=$zt(EndTime,2)
	      . s PostHolFlag=$ListGet(a,17)   
	      . s parr =  "^" _ Code _ "^" _ Desc _ "^" _ todep _ "^" _ nums_"^"_flag _"^"_mem_"^"_week_"^"_weeknum_"^"_posttyp_"^"_postcurrflag_"^"_NightHour_"^"_StartTime_"^"_EndTime_"^"_PostHolFlag   ;
	      . ;b
	      . d ..SavePost(parr)
	     q 0
}

ClassMethod SavePost(parr) As %String
{
 //
   s id=$P(parr,"^",1)
   s code=$P(parr,"^",2)
   s desc=$P(parr,"^",3)
   s PostLocDr=$P(parr,"^",4)
   s nums=$P(parr,"^",5)
   s flag=$P(parr,"^",6)
   s mem=$P(parr,"^",7)
   s weeks=$P(parr,"^",8)
   s weekpers=$P(parr,"^",9)
   s postyp=$P(parr,"^",10)
   s postcurrflag=$P(parr,"^",11)
   s NightHour=$P(parr,"^",12)
   s PostStartTime=$P(parr,"^",13)
   i PostStartTime'="" s PostStartTime=$zth(PostStartTime,3)
   s PostEndTime=$P(parr,"^",14)
   i PostEndTime'="" s PostEndTime=$zth(PostEndTime,3)
   s PostHolFlag=$P(parr,"^",15)
   s ifflag=..ifexsit(PostLocDr,code)
   if (id="")&(ifflag'="") q 0
   if id=""  s post=##class(User.DHCMGPost).%New()
   e  s post=##class(User.DHCMGPost).%OpenId(id)
   s post.PostCode=code
   s post.PostDesc=desc
   s post.PostPerNums=nums
   s post.PostLocDr=PostLocDr
   s post.Postmem=mem
   s post.PostFlag=flag
   s post.PostWeek=weeks
   s post.PostWeekendPers=weekpers
   s post.PostTypDr=##class(User.DHCMGCCode).%OpenId(postyp)
   s post.PostCurrFlag=postcurrflag
   s post.PostNightHour=NightHour
   s post.PostStartTime=PostStartTime
   s post.PostEndTime=PostEndTime
   s post.PostHolFlag=PostHolFlag
   d post.%Save()
   q 0
}

ClassMethod ifexsit(loc, postcode) As %String
{
       s rw="" s rw=$O(^User.DHCMGPostI("postloc"," "_loc," "_postcode,rw))
       q rw
}

/// 保存岗位代码顺序号
ClassMethod SavePostSort(parr As %String) As %String
{
  	//w ##class(User.DHCMGPost).SavePostSort("51|0^1|1^")
	s ln=$L(parr,"^")
	f i=1:1:ln
	{
		s itm=$P(parr,"^",i)
		q:itm=""
		s id=$P(itm,"|",1)
		s sort=$P(itm,"|",2)
		q:id=""
   		s post=##class(User.DHCMGPost).%OpenId(id)
   		s post.PostSort=sort
   		d post.%Save()
	}
	q 0
}

Storage Default
{
<Data name="DHCMGPostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PostCode</Value>
</Value>
<Value name="3">
<Value>PostDesc</Value>
</Value>
<Value name="4">
<Value>PostLocDr</Value>
</Value>
<Value name="5">
<Value>PostMaxTime</Value>
</Value>
<Value name="6">
<Value>PostPerNums</Value>
</Value>
<Value name="7">
<Value>PostFlag</Value>
</Value>
<Value name="8">
<Value>Postmem</Value>
</Value>
<Value name="9">
<Value>PostWeek</Value>
</Value>
<Value name="10">
<Value>PostWeekendPers</Value>
</Value>
<Value name="11">
<Value>PostTypDr</Value>
</Value>
<Value name="12">
<Value>PostCurrFlag</Value>
</Value>
<Value name="13">
<Value>PostSort</Value>
</Value>
<Value name="14">
<Value>PostNightHour</Value>
</Value>
<Value name="15">
<Value>PostStartTime</Value>
</Value>
<Value name="16">
<Value>PostEndTime</Value>
</Value>
<Value name="17">
<Value>PostHolFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPostD</DataLocation>
<DefaultData>DHCMGPostDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGPostD</IdLocation>
<IndexLocation>^User.DHCMGPostI</IndexLocation>
<StreamLocation>^User.DHCMGPostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
