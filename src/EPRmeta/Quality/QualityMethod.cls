/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityMethod
/// * Description:	The model of quality methods
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:		
/// ************************************************************/
Class EPRmeta.Quality.QualityMethod Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxCode On Code [ Unique ];

/// 代码	
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 名称
Property Name As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// Method expression
Property MethodEx As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// Parameters of the method
Property BindParms As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// Active or not
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6 ];

/// Resume of this method
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

ClassMethod CheckCodeUnique(ACode As %String) As %Integer
{
	s Result = 0
 	&sql(SELECT COUNT(Code) INTO:Result FROM EPRmeta_Quality.QualityMethod WHERE Code = :ACode)
 	q Result
}

ClassMethod CheckUpdateCodeUnique(AId As %String, ACode As %String) As %Integer
{
 	s Result = 0,OldId=""
 	&sql(SELECT COUNT(Code) INTO :Result FROM EPRmeta_Quality.QualityMethod WHERE Code = :ACode)
 	if ((Result="")!(Result=0))
 	{
 		s Result=0
 	}
 	elseif '(Result=0) 
 	{
 		&sql(SELECT ID into :OldId FROM EPRmeta_Quality.QualityMethod WHERE Code = :ACode)
 		if ('OldId=AId)     
 		{ 
 			Set Result= 1
	  	}
	  	else
	  	{
			Set Result = 0		  	
		}
 	}
 	Quit Result
}

Query SELECTALL() As %Library.SQLQuery(CONTAINID = 1) [ SqlName = SP_QualityMethod_SELECTALL, SqlProc ]
{
	SELECT %Id, Code, Name, MethodEx, BindParms, IsActive, ResumeText
	FROM EPRmeta_Quality.QualityMethod
	ORDER BY Code
}

Storage Default
{
<Data name="QualityMethodDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>MethodEx</Value>
</Value>
<Value name="4">
<Value>BindParms</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
<Value name="7">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityMethodD</DataLocation>
<DefaultData>QualityMethodDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualityMethodD</IdLocation>
<IndexLocation>^DHCEPRM.QualityMethodI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityMethodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
