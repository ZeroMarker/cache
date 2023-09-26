Class DHCMGNUR.MgNurArgJob Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 病区
Property WardDR As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = Ward_DR ];

/// 开始时间
Property StartDate As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = Start_Date ];

/// 结束时间
Property EndDate As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = End_Date ];

/// 备注或通知
Property Remarks As %String(MAXLEN = 10000, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = Remarks ];

/// 隔断位置
Property SpaceLoc As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SpaceLoc ];

/// 状态
Property Status As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Status ];

Index WardDate On (WardDR, StartDate, EndDate);

/// w ##class(DHCMGNUR.MgNurArgJob).Save("1018^2014-03-31^2014-04-06^jhasjkdhk")
ClassMethod Save(parr As %String) As %String
{
	q:parr=""
	s WardDR=$P(parr,"^",1)
	s StartDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s Remarks=$P(parr,"^",4)
	s ID=$O(^DHCMGNUR.MgNurArgJobI("WardDate"," "_WardDR," "_StartDate," "_EndDate,""))
	i ID'=""
	{
		s object=##class(DHCMGNUR.MgNurArgJob).%OpenId(ID)	
	}
	else
	{
		s object=##class(DHCMGNUR.MgNurArgJob).%New()
		s object.WardDR=WardDR
		s object.StartDate=StartDate
		s object.EndDate=EndDate
		s object.Status="N"
	}
	s object.Remarks=Remarks
	TStart 
	s sc=object.%Save()
	i $$$ISERR(sc)  ///If ($$$ISOK(sc))
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

ClassMethod getVal(ID As %String) As %String
{
	q:ID="" ""
	s a=##class(DHCMGNUR.MgNurArgJob).%OpenId(ID)
	s ret="WardDR|"_a.WardDR
	s ret=ret_"^StartDate|"_$zd(a.StartDate,3)
	s ret=ret_"^EndDate|"_$zd(a.EndDate,3)
	s Remarks=$tr(a.Remarks,$c(13,10),"_n")
	s ret=ret_"^Remarks|"_Remarks
	s ret=ret_"^SpaceLoc|"_a.SpaceLoc
	s ret=ret_"^Status|"_a.Status
	s ret=ret_"^ID|"_ID
	q ret
}

ClassMethod getValue(parr As %String) As %String
{
	;w ##class(DHCMGNUR.MgNurArgJob).getValue("1018^2014-03-31^2014-04-06")
	q:parr="" ""
	s WardDR=$P(parr,"^",1)
	s StDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s ID=$O(^DHCMGNUR.MgNurArgJobI("WardDate"," "_WardDR," "_StDate," "_EndDate,""))
	q:ID="" ""
	s ret=..getVal(ID)
	q ret
}

ClassMethod setSpaceLoc(parr)
{
	;d ##class(DHCMGNUR.MgNurArgJob).setSpaceLoc("1018^2014-04-21^2014-04-27^3")
	s WardDR=$P(parr,"^",1)
	s StDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s SpaceNum=$P(parr,"^",4)
	s ID=$O(^DHCMGNUR.MgNurArgJobI("WardDate"," "_WardDR," "_StDate," "_EndDate,""))
	i ID="" d
	.s object=##class(DHCMGNUR.MgNurArgJob).%New()
	.s object.WardDR=WardDR
	.s object.StartDate=StDate
	.s object.EndDate=EndDate
	.s object.SpaceLoc=SpaceNum
	else  d
	.s object=##class(DHCMGNUR.MgNurArgJob).%OpenId(ID)
	.s object.SpaceLoc=object.SpaceLoc_";"_SpaceNum
	TStart 
	s sc=object.%Save()
	i $$$ISERR(sc)  ///If ($$$ISOK(sc))
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

ClassMethod deleteSpaceLoc(parr)
{
	;d ##class(DHCMGNUR.MgNurArgJob).setSpaceLoc("1018^2014-04-21^2014-04-27^5")
	s WardDR=$P(parr,"^",1)
	s StDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s SpaceNum=$P(parr,"^",4)
	s ID=$O(^DHCMGNUR.MgNurArgJobI("WardDate"," "_WardDR," "_StDate," "_EndDate,""))
	q:ID=""
	s object=##class(DHCMGNUR.MgNurArgJob).%OpenId(ID)
	s OldSpaceLocs=object.SpaceLoc
	s NewSpaceLoc=""
	f i=1:1:$L(OldSpaceLocs,";") d
	.s SpaceLoc=$P(OldSpaceLocs,";",i)
	.q:SpaceLoc=SpaceNum
	.i NewSpaceLoc="" s NewSpaceLoc=SpaceLoc
	.else  s NewSpaceLoc=NewSpaceLoc_";"_SpaceLoc
	s object.SpaceLoc=NewSpaceLoc
	TStart 
	s sc=object.%Save()
	i $$$ISERR(sc)  ///If ($$$ISOK(sc))
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

ClassMethod SetStatus(parr As %String) As %String
{
	q:parr="" 0
	s WardID=$P(parr,"^",1)
	s StDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s Status=$P(parr,"^",4)
	s ID=$O(^DHCMGNUR.MgNurArgJobI("WardDate"," "_WardID," "_StDate," "_EndDate,""))
	i ID'="" d
	.s a=##class(DHCMGNUR.MgNurArgJob).%OpenId(ID)
	.s a.Status=Status
	.d a.%Save()
	else  d
	.s object=##class(DHCMGNUR.MgNurArgJob).%New()
	.s object.WardDR=WardID
	.s object.StartDate=StDate
	.s object.EndDate=EndDate
	.s object.Status=Status
	.s object.Remarks=""
	.d object.%Save()
	q 1
}

ClassMethod GetStatus(parr)
{
	q:parr="" 0
	s wardid=$P(parr,"^",1)
	s StDate=$P(parr,"^",2)
	s EndDate=$P(parr,"^",3)
	s status="N"
	s ID="" f  s ID=$O(^DHCMGNUR.MgNurArgJobI("WardDate"," "_wardid," "_StDate," "_EndDate,ID)) q:ID=""  d
	.s argjob=##class(DHCMGNUR.MgNurArgJob).%OpenId(ID)
	.s stdate=argjob.StartDate,enddate=argjob.EndDate
	.q:(stdate>StDate)!(enddate<StDate)
	.s status=argjob.Status
	q status
}

ClassMethod GetStatus2(parr)
{
	//w ##class(DHCMGNUR.MgNurArgJob).GetStatus2("197^2017-07-24^2017-07-30")
	//s ^TEMP("jyc123")=parr
	q:parr="" 0
	s wardid=$P(parr,"^",1)
	s StDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s status="0"
	s ID=$O(^DHCMGNUR.MgNurArgJobI("WardDate"," "_wardid," "_StDate," "_EndDate,"")) 
	i ID'="" d 
	.s argjob=##class(DHCMGNUR.MgNurArgJob).%OpenId(ID)
	.i argjob.Status'="" s status=argjob.Status
	q status
}

Storage Default
{
<Data name="MgNurArgJobDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardDR</Value>
</Value>
<Value name="3">
<Value>StartDate</Value>
</Value>
<Value name="4">
<Value>EndDate</Value>
</Value>
<Value name="5">
<Value>Remarks</Value>
</Value>
<Value name="6">
<Value>SpaceLoc</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurArgJobD</DataLocation>
<DefaultData>MgNurArgJobDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurArgJobD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurArgJobI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurArgJobS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
