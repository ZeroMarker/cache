Class CHSSWeb.CHSSUserVsResourceService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(Start, Limit, GroupRowId)
{
	Set start=$G(Start)
	Set limit=$G(Limit)
	s GroupRowId=$G(GroupRowId)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	s UserVsGrRowId=0

    For  Set UserVsGrRowId=$O(^CHSS.CHSSUserVsResourceI("GroupIndex",GroupRowId,UserVsGrRowId)) q:UserVsGrRowId=""  d
	.s tempRes=##class(CHSS.CHSSUserVsResource).%OpenId(UserVsGrRowId)
	
	.s RowId=""
	.s Description=""
	.s Code=""
	.i tempRes.UserRowId'="" d
	.s RowId=tempRes.UserRowId
	.s Description=""
	.s SSGroup = ##class(User.SSGroup).%OpenId(tempRes.UserRowId)
	.q:(SSGroup = "")
	.i SSGroup '= "" d
	..s Description= SSGroup.SSGRPDesc
	.s Code=tempRes.UserRowId
	.;.s RowId=tempRes.UserRowId
	.;.s Description=tempRes.UserRowId.SSUSRName
	
	.s tmp=""
	.s tmp=UserVsGrRowId_"^"_GroupRowId_"^"_RowId_"^"_Description_"^"_Code
	.s count=count+1
	.i (count>start)&(count<=end) d
	..d json.InsertRowData(tmp)
	s resultString=json.getJsonData("UserVsGrRowId^GroupRowId^RowId^Description^Code",count)
	k json       
	Quit resultString
}

ClassMethod insert(Limit, GroupRowId, UserRowId, UserVsGroupRowId)
{
	s Limit = $G(Limit)
	s GroupRowId = $G(GroupRowId)
	s UserRowId = $G(UserRowId)
	s UserVsGroupRowId = $G(UserVsGroupRowId)
	s count=0
	
	i Limit=0 d
	.s count=..deleteAll(GroupRowId)
	
	i UserVsGroupRowId ="" d
	.s tempRes=##class(CHSS.CHSSUserVsResource).%New()
	
	i GroupRowId '="" d
	.s tempRes.GroupRowId=##class(CHSS.CHSSResourceGroup).%OpenId(GroupRowId)
	
	;i UserRowId '="" d
	.;s tempRes.UserRowId=##class(User.SSUser).%OpenId(UserRowId)
	s tempRes.UserRowId=UserRowId

	s result=""
	s result=tempRes.%Save()
	
	s resultString=""
	i result="1" d
	.s resultString="{""success"":""true"",""info"":""1""}"
	e  d
	.s resultString="{""success"":""false"",""info"":""数据保存出错！""}"
	q resultString
}

ClassMethod deleteAll(GroupRowId)
{
	s UserVsGrRowId=0
	s GroupRowId=$G(GroupRowId)
	s count=0

    For  Set UserVsGrRowId=$O(^CHSS.CHSSUserVsResourceI("GroupIndex",GroupRowId,UserVsGrRowId)) q:UserVsGrRowId=""  d
	.s tempRes=##class(CHSS.CHSSUserVsResource).%OpenId(UserVsGrRowId)
	.s result=tempRes.%DeleteId(UserVsGrRowId)
	.i result="1" d
	..s count=count+1
	
	q count
}

ClassMethod find(Start, Limit, text)
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT SSGRP_RowId,SSGRP_Desc FROM SQLUser.SS_Group where SSGRP_Desc like'%"_text_"%'"

	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = Start+Limit
	
	s json = ##class(Code.JsonObj).%New()
	
	while(result.Next()){
		s RowId=result.Data("SSGRP_RowId")
		s Description=result.Data("SSGRP_Desc")
		s tmp=RowId_"^"_Description
		s count = count+1
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Description",count)
	k json
	q resultString
}

Storage Default
{
<Data name="CHSSUserVsResourceServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CHSSUserVsRe9B2D</DataLocation>
<DefaultData>CHSSUserVsResourceServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CHSSUserVsRe9B2D</IdLocation>
<IndexLocation>^CHSSWeb.CHSSUserVsRe9B2I</IndexLocation>
<StreamLocation>^CHSSWeb.CHSSUserVsRe9B2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
