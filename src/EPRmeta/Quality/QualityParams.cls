/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityParams
/// * Description:	The model of quality params
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:		
/// ************************************************************/
Class EPRmeta.Quality.QualityParams Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxCode On Code [ Unique ];

/// 代码	
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 描述
Property Name As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 值
Property BindValue As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 是否有效
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5 ];

/// 备注
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Query SELECTALL() As %Library.SQLQuery(CONTAINID = 1) [ SqlName = SP_QualityParams_SELECTALL, SqlProc ]
{
	SELECT %Id, Code, Name, BindValue, IsActive, ResumeText
	FROM EPRmeta_Quality.QualityParams
	ORDER BY Name
}

ClassMethod CheckCodeUnique(ACode As %String) As %Integer
{
	s Result = 0
 	&sql(SELECT COUNT(Code) INTO:Result FROM EPRmeta_Quality.QualityParams WHERE Code = :ACode)
 	q Result
}

ClassMethod CheckUpdateCodeUnique(AId As %String, ACode As %String) As %Integer
{
	s Result = 0, OldId =""
 	&sql(SELECT COUNT(Code) INTO :Result FROM EPRmeta_Quality.QualityParams WHERE Code = :ACode)
 	if ((Result="")!(Result=0))
 	{
 		s Result=0
 	}
 	elseif '(Result=0) 
 	{
 		&sql(SELECT ID into :OldId FROM EPRmeta_Quality.QualityParams WHERE Code = :ACode)
 		if ('OldId=AId)     
 		{ 
 			s Result= 1
	  	}
	  	else
	  	{
			s Result = 0		  	
		}
 	}
 	q Result
}

Storage Default
{
<Data name="QualityParamsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BindValue</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityParamsD</DataLocation>
<DefaultData>QualityParamsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualityParamsD</IdLocation>
<IndexLocation>^DHCEPRM.QualityParamsI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityParamsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
