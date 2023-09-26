/// 名称:	CT.MA.QC.QualityPool
/// 描述:	质控条目基础数据表
/// 编写者：hky
/// 编写日期: 2021-06-30
Class CT.MA.QC.QualityPool Extends (%Persistent, User.Abstract)
{

/// 目的是使ID列具有和Code列相同的数据
Index RowIDBasedIDKeyIndex On Code [ IdKey, PrimaryKey, Unique ];

/// 代码（完整性项目以E开头，一致性项目以U开头）
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 描述
Property Title As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 表达式
Property Expression As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 质控结构
Property StructID As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="QualityPoolDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Title</Value>
</Value>
<Value name="3">
<Value>Expression</Value>
</Value>
<Value name="4">
<Value>StructDR</Value>
</Value>
<Value name="5">
<Value>StructID</Value>
</Value>
</Data>
<DataLocation>^CT.MA.QC.QualityPoolD</DataLocation>
<DefaultData>QualityPoolDefaultData</DefaultData>
<IdLocation>^CT.MA.QC.QualityPoolD</IdLocation>
<IndexLocation>^CT.MA.QC.QualityPoolI</IndexLocation>
<StreamLocation>^CT.MA.QC.QualityPoolS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

/// Debug:	w ##Class(CT.MA.QC.QualityPool).GetTitleByPoolID("U001")
ClassMethod GetTitleByPoolID(APoolID As %String) As %String
{
	s ret = ""
	q:($d(APoolID) = 0)||(APoolID = "") ret
	s Type = $e(APoolID,1)
	if ($zcvt(Type,"U") = "E") 
	{
		s UnitID = $ZSTRIP(APoolID,"*A")
		
		
		s objTemplate=##Class(CT.MA.QC.QualityTemplate).%OpenId(UnitID)
		s Title = objTemplate.Title // 
		s objTemplate=""
	} 
	else 
	{
		
		s objPool=##Class(CT.MA.QC.QualityPool).%OpenId(APoolID)
		s Title = objPool.Title  //$list($g(^DHCEPRM.QualityPoolD(APoolID)),2)
		
		s objPool=""
	}
	s ret = Title
	q ret
}

}
