/// 术语
Class EPRmeta.Glossary Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxGUIT On GUID [ Unique ];

Index IdxParentID On ParentID;

Index IdxCategoryID On GlossaryCategoryID;

Index IdxInternalID On (InternalID, GlossaryCategoryID) [ Unique ];

Index IdxGlossaryID On InternalID;

/// 术语名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术语描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 全局唯一标识符
Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

/// 术语范畴父类ID
Property GlossaryCategoryID As %String(TRUNCATE = 1);

/// 关联的模板项目,其信息格式如下：
/// Simple型：TNAME.UNAME#TYPE:#TID:#TVER:#SCODE:#VTYPE
/// Segment型：TNAME.UNAME#TYPE:#TID:#TVER:#GCODE:#VTYPE
/// TextDesc型：TNAME.UNAME#TYPE:#TID:#TVER:#ECODE:#VTYPE
/// SegmentSimple型：TNAME.UNAME#TYPE:#TID:#TVER:#TCODE:#SCODE:#VTYPE
/// TextDescSimple型：TNAME.UNAME#TYPE:#TID:#TVER:#TCODE:#SCODE:#KBNode:#KBPartNo#VTYPE
/// 引用术语的项目
Property BindItemData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.GlossaryS");

Property MetaItemData As %GlobalCharacterStream(LOCATION = "^DHCEPRM.GlossaryS");

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 最后修改日期
Property LastModifyDate As %Date;

/// 最后修改时间
Property LastModifyTime As %Time;

/// 术语类型(TG：界面模板单元术语; KG:知识库单元术语)
Property GlossaryType As %String(TRUNCATE = 1);

/// 父术语节点RowID(如果没有，则为空。这里主要用于存储知识库术语的上下文术语RowID)
Property ParentID As %String(TRUNCATE = 1);

/// 内部标识符
Property InternalID As %String(TRUNCATE = 1);

/// 数据元标识符
Property MetaID As %String(TRUNCATE = 1);

/// Debug:	d ##Class(%ResultSet).RunQuery("EPRmeta.Glossary","GetSubGlossariesByParentID",19)
Query GetSubGlossariesByParentID(AParentID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,Description:%String,GUID:%String,GlossaryCategoryID:%String,GlossaryType:%String,InternalID:%String,MetaID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Glossary_SelectAllByParentID, SqlProc ]
{
	select ID,Name,Description,GUID,GlossaryCategoryID,GlossaryType,InternalID,MetaID
	from EPRmeta.Glossary
	where ParentID = :AParentID
	order by ID
}

/// Debug:	d ##Class(%ResultSet).RunQuery("EPRmeta.Glossary","GetAllGlossarys")
Query GetAllGlossarys() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,Description:%String,GUID:%String,GlossaryCategoryID:%String,GlossaryType:%String,InternalID:%String,MetaID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Glossary_SelectAll, SqlProc ]
{
	select ID,Name,Description,GUID,GlossaryCategoryID,GlossaryType,InternalID,MetaID
	from EPRmeta.Glossary
}

/// Desc:	获取第一线术语集合
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRmeta.Glossary","SelectAllByCategoryID",127)
Query SelectAllByCategoryID(ACategoryID As %String) As %Query(ROWSPEC = "ID:%Integer,Name:%String,Description:%String,GUID:%String,GlossaryCategoryID:%String,GlossaryType:%String,ChildCount:%String,InternalID:%String,MetaID:%String")
{
}

ClassMethod SelectAllByCategoryIDExecute(ByRef qHandle As %Binary, ACategoryID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(ACategoryID) = "") $$$OK
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRM.GlossaryI("IdxCategoryID"," "_ACategoryID,rowID))
		q:(rowID = "")	
		
		s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(rowID)
		
		s name = objGlossary.Name
		s desc = objGlossary.Description
		s guid = objGlossary.GUID
		s type = objGlossary.GlossaryType
		s parentID = objGlossary.ParentID
		s internalID = objGlossary.InternalID
		s metaID = objGlossary.MetaID
		
		continue:(parentID '= "")&&(parentID '= $c(0))
				
		s count = 0
		s sub = ""
		for {
			s sub = $o(^DHCEPRM.GlossaryI("IdxParentID"," "_rowID,sub))
			q:(sub = "")
			
			s count = count + 1	
		}
		
		s Data = $lb(rowID,name,desc,guid,ACategoryID,type,count,internalID,metaID)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
		
	q $$$OK
}

ClassMethod SelectAllByCategoryIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectAllByCategoryIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectAllByCategoryIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectAllByCategoryIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod SelectByGUID(aGUID As %String) As %String
{
	 set Result=""	 
	 &sql(SELECT ID
	 into :Result 
	 FROM EPRmeta.Glossary
	 WHERE GUID = :aGUID)
	 QUIT Result
}

/// w ##Class(EPRmeta.Glossary).GetMetaItem("1")
/// 住院病历.病史.一般情况.通用模板.姓?名.值#TYPE:Simple#TID:704#TVER:0#SCODE:S0004#VTYPE:V^
/// 住院病历.病史.一般情况.儿科.姓?名.值#TYPE:Simple#TID:705#TVER:0#SCODE:S0004#VTYPE:V^
/// 住院病历.病史.一般情况.新生儿.姓?名.值#TYPE:Simple#TID:706#TVER:0#SCODE:S0004#VTYPE:V
ClassMethod GetMetaItem(AGlossaryID) As %String
{
	s ret = ""
	q:($d(AGlossaryID) = 0||AGlossaryID = "") ret
	
	s items = ""
	s obj = ..%OpenId(AGlossaryID)
	q:(obj = "") items
	
	s sc = ##Class(%XML.TextReader).ParseStream((obj.MetaItemData), .reader)
	q:($$$ISERR(sc)) items
	
	while(reader.Read())
	{
		if ((reader.NodeType = "element")&&(reader.Name = "Item"))
		{
			if (reader.Read())
			{
				if (items = "")
				{	s items = reader.Value}
				else
				{	s items = items_"^"_reader.Value}
			}
		}
	}
	
	q items
}

Storage Default
{
<Data name="GlossaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateDate</Value>
</Value>
<Value name="3">
<Value>CreateTime</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>GUID</Value>
</Value>
<Value name="6">
<Value>GlossaryCategoryID</Value>
</Value>
<Value name="7">
<Value>LastModifyDate</Value>
</Value>
<Value name="8">
<Value>LastModifyTime</Value>
</Value>
<Value name="9">
<Value>Name</Value>
</Value>
<Value name="10">
<Value>SubItems</Value>
</Value>
<Value name="11">
<Value>BindItemData</Value>
</Value>
<Value name="12">
<Value>MetaItemData</Value>
</Value>
<Value name="13">
<Value>GlossaryType</Value>
</Value>
<Value name="14">
<Value>ParentID</Value>
</Value>
<Value name="15">
<Value>InternalID</Value>
</Value>
<Value name="16">
<Value>MetaID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.GlossaryD</DataLocation>
<DefaultData>GlossaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.GlossaryD</IdLocation>
<IndexLocation>^DHCEPRM.GlossaryI</IndexLocation>
<StreamLocation>^DHCEPRM.GlossaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
