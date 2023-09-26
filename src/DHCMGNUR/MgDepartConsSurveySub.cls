/// Hospital:北京协和医院
/// Class Description:
/// Date:2014-12-01
Class DHCMGNUR.MgDepartConsSurveySub Extends %Persistent
{

Relationship subParref As DHCMGNUR.MgDepartConsSurvey [ Cardinality = parent, Inverse = perDepCon, Required ];

//护士工号

Property NurseID As %Library.String [ SqlColumnNumber = 2, SqlFieldName = Nurse_ID ];

//所属科室

Property WardID As %Library.String [ SqlColumnNumber = 3, SqlFieldName = Ward_ID ];

// 存在标识

Property DataFlag As %Library.String [ SqlColumnNumber = 4, SqlFieldName = Data_Flag ];

Property NurFillDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 5, SqlFieldName = NurFill_Date ];

//填表时间

Property NurFillTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 6, SqlFieldName = NurFill_Time ];

//得分

Property NurScore As %Library.String [ SqlColumnNumber = 7, SqlFieldName = Nur_Score ];

Property Item1 As %Library.String [ SqlColumnNumber = 8 ];

Property Item2 As %Library.String [ SqlColumnNumber = 9 ];

Property Item3 As %Library.String [ SqlColumnNumber = 10 ];

Property Item4 As %Library.String [ SqlColumnNumber = 11 ];

Property Item5 As %Library.String [ SqlColumnNumber = 12 ];

Property Item6 As %Library.String [ SqlColumnNumber = 13 ];

Property Item7 As %Library.String [ SqlColumnNumber = 14 ];

Property Item8 As %Library.String [ SqlColumnNumber = 15 ];

Property Item9 As %Library.String [ SqlColumnNumber = 16 ];

Property Item10 As %Library.String [ SqlColumnNumber = 17 ];

Property Item11 As %Library.String [ SqlColumnNumber = 18 ];

Property Item12 As %Library.String [ SqlColumnNumber = 19 ];

Property Item13 As %Library.String [ SqlColumnNumber = 20 ];

Property Item14 As %Library.String [ SqlColumnNumber = 21 ];

Property Item15 As %Library.String [ SqlColumnNumber = 22 ];

Property Item16 As %Library.String [ SqlColumnNumber = 23 ];

Property Item17 As %Library.String [ SqlColumnNumber = 24 ];

Property Item18 As %Library.String(MAXLEN = 300) [ SqlColumnNumber = 25 ];

Index LOCID On WardID;

Index NurID On NurseID;

Index Existflag On (subParref, DataFlag, NurseID);

ClassMethod SaveSurvey(parr As %String) As %String
{
	//parr="nurseId|10317^nurseLoc|573^id|2^Item1|1@Item2|2@Item3|3@Item4|4@Item5|5@Item6|1@Item7|2@Item8|3@Item9|4@Item10|5@Item11|1@Item12|2@Item13|3@Item14|4@Item15|5@Item16|1@Item17|2@^Item20|ssssssss"
	s ^TMP("g20141208105401")=parr
	s a=##class(DHCMGNUR.MgDepartConsSurveySub).%New()
	s a.subParref=##class(DHCMGNUR.MgDepartConsSurvey).%OpenId($P($P(parr,"^",3),"|",2))
	s a.DataFlag=1
	s a.NurseID=$P($P(parr,"^",1),"|",2)
	s a.WardID=$P($P(parr,"^",2),"|",2)
	s items=$P(parr,"^",4)
	s a.NurScore=$P($P(parr,"^",5),"|",2)
	s len=$L(items,"@")
	for i=1:1:len
	{
		s item="Item"_i
		s $ZOBJPROPERTY(a,item)=$P($P(items,"@",i),"|",2)
		;s $PROPERTY(a,item)=$P($P(items,"@",i),"|",2)
	}
	b ;01
	d a.%Save()
	q a.%Id()
}

ClassMethod ExistData(str As %String) As %String
{
	//str="2^1^10317"
	;s ^TEMP("g20141203114601")=str
	s ret=""
	s par=$P(str,"^",1)
	s titleId=$P(str,"^",2)
	s nurseId=$P(str,"^",3)
	s id=$O(^DHCMGNUR.MgDepartConsSurveySubI("Existflag",par," "_titleId," "_nurseId,""))
	i id'=""
	s ret=id
	q id
}

Storage Default
{
<Data name="MgDepartConsSurveySubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardID</Value>
</Value>
<Value name="3">
<Value>NurseID</Value>
</Value>
<Value name="4">
<Value>DataFlag</Value>
</Value>
<Value name="5">
<Value>Item1</Value>
</Value>
<Value name="6">
<Value>Item2</Value>
</Value>
<Value name="7">
<Value>Item3</Value>
</Value>
<Value name="8">
<Value>Item4</Value>
</Value>
<Value name="9">
<Value>Item5</Value>
</Value>
<Value name="10">
<Value>Item6</Value>
</Value>
<Value name="11">
<Value>Item7</Value>
</Value>
<Value name="12">
<Value>Item8</Value>
</Value>
<Value name="13">
<Value>Item9</Value>
</Value>
<Value name="14">
<Value>Item10</Value>
</Value>
<Value name="15">
<Value>Item11</Value>
</Value>
<Value name="16">
<Value>Item12</Value>
</Value>
<Value name="17">
<Value>Item13</Value>
</Value>
<Value name="18">
<Value>Item14</Value>
</Value>
<Value name="19">
<Value>Item15</Value>
</Value>
<Value name="20">
<Value>Item16</Value>
</Value>
<Value name="21">
<Value>Item17</Value>
</Value>
<Value name="22">
<Value>Item18</Value>
</Value>
<Value name="23">
<Value>Item19</Value>
</Value>
<Value name="24">
<Value>Item20</Value>
</Value>
<Value name="25">
<Value>NurScore</Value>
</Value>
<Value name="26">
<Value>NurFillDate</Value>
</Value>
<Value name="27">
<Value>NurFillTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("perDepCon")</DataLocation>
<DefaultData>MgDepartConsSurveySubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgDepartConsSurveyC("perDepCon")</IdLocation>
<IndexLocation>^DHCMGNUR.MgDepartConsSurveySubI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgDepartCons72DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
