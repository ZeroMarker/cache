/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityDictionary
/// * Description:	The model of quality basic dictionary
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:		
/// ************************************************************/
Class EPRmeta.Quality.QualityDictionary Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxCode On Code [ Unique ];

Index IdxParentId On ParentId;

/// 代码
Property Code As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 父结点RowId
Property ParentId As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 描述
Property Name As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 是否有效
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5 ];

/// 备注
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Query SELECTALL() As %SQLQuery(CONTAINID = 1) [ SqlName = SP_QualityDictionary_SELECTALL, SqlProc ]
{
	SELECT %Id, Code, ParentId, Name, IsActive, ResumeText 
	FROM EPRmeta_Quality.QualityDictionary
	ORDER BY Code
}

Query SELECTBYCODE(ACode As %String) As %SQLQuery(CONTAINID = 1) [ SqlName = SP_QualityDictionary_SELECTBYCODE, SqlProc ]
{
	SELECT %Id, Code, ParentId, Name, IsActive, ResumeText
 	FROM EPRmeta_Quality.QualityDictionary
 	WHERE ParentId IN
 	(
 		SELECT ID FROM EPRmeta_Quality.QualityDictionary WHERE Code = :ACode
 	)
}

/// 判断Code是否存在
ClassMethod CheckCodeExist(ACode As %String) As %String
{
 	&sql(SELECT COUNT(Code) INTO :Result FROM EPRmeta_Quality.QualityDictionary WHERE Code = :ACode)
 	if (Result = "")
 	{
	 	s Result = 0 
	 }
 	q Result
}

/// 删除结点及其子结点
ClassMethod DeleteQualityDictionary(ARowId As %String) As %String
{
	if (##class(EPRmeta.Quality.QualityDictionary).%ExistsId(ARowId))	
	{
		&SQL(DELETE FROM EPRmeta_Quality.QualityDictionary WHERE ID IN (
			 SELECT ID FROM EPRmeta_Quality.QualityDictionary WHERE ParentId=:ARowId))
		
		do ##class(EPRmeta.Quality.QualityDictionary).%DeleteId(ARowId)
		
		Quit "1"
	}
	else
	{
		Quit "0"
	}
}

/// Desc:按代码查下级节点
/// Creator:Candyxu
/// CreateDate:2012-11-27
/// Input:父节点code值
/// output:Code,name
/// Debug:do ##class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualityDictionary","GetDicByParentID","QulaityLevel")
Query GetDicByParentID(ACode As %String) As %Query(ROWSPEC = "RowID:%String,Code:%String,Name:%String")
{
}

ClassMethod GetDicByParentIDExecute(ByRef qHandle As %Binary, ACode As %String) As %Status
{
	s PdicID = $O(^DHCEPRM.QualityDicI("IdxCode",ACode,""))
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:(PdicID = "") $$$OK
	s dicID = ""
	for {
		s dicID = $o(^DHCEPRM.QualityDicI("IdxParentId"," "_PdicID,dicID))
		q:(dicID = "")
		s Active = $li(^DHCEPRM.QualityDicD(dicID),4)
		q:($zcvt(Active,"U")  = "N")
		s Code = $li(^DHCEPRM.QualityDicD(dicID),1)
		s Name = $li(^DHCEPRM.QualityDicD(dicID),3)
		
		s Data = $lb(dicID,Code,Name)
	    s ^CacheTemp(repid,ind) = Data
	    s ind = ind + 1
	}
	
	Quit $$$OK
}

ClassMethod GetDicByParentIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDicByParentIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDicByParentIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDicByParentIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="QualityDictionaryDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>ParentId</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
<Value name="6">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityDicD</DataLocation>
<DefaultData>QualityDictionaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualityDicD</IdLocation>
<IndexLocation>^DHCEPRM.QualityDicI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
