/// A list of icons
Class epr.CTIconProfile Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 649;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "Code";

Parameter SQLDESCRIPTION = "Description";

Parameter SQLROWID = "ID";

Property Code As %Library.String(COLLATION = "ALPHAUP", MAXLEN = 300, TRUNCATE = 1) [ Required ];

Property CodeTableIcons As %Library.Boolean;

Property Description As %Library.String(COLLATION = "ALPHAUP", MAXLEN = "", TRUNCATE = 1) [ Required ];

Relationship Items As epr.CTIconProfileItem [ Cardinality = children, Inverse = ParRef ];

/// ab 14.05.03 - 32393 - Builds the ^epr.CTIconProfileG global
/// the global contains the code needed to get the data items
/// using globals based on item name,used by CTIconProfile.Gather
ClassMethod BuildGlobal()
{
}

/// ab 14.05.03 - 32393
/// gathers ARY data for icon profiles, only gets the data that is needed
/// will replace CTIconAssociation.FPGatheringData for most components that use icon profiles.
ClassMethod Gather(compid As %Library.String = "", compitmid As %Library.String = "", ProfileID As %Library.String = "", pstring As %Library.String = "")
{
}

/// by wuqk 2011-06-29
ClassMethod GetField(ProfileID As %Library.String, Field As %Library.String) As %Library.String
{
}

ClassMethod ItemsFindClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ItemsFindFetch ]
{
}

/// by wuqk 2011-06-29
ClassMethod ItemsFindExecute(ByRef QHandle As %Library.Binary, ProfileID As %Library.String) As %Library.Status
{
}

ClassMethod ItemsFindFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ItemsFindExecute ]
{
}

ClassMethod PreAdmissionDesc(EpisodeID As %Library.String = "") As %Library.String
{
}

/// Created for Log 26756
/// 组件展现会调用d ##class(epr.CTIconProfile).Show("50307","t50307iIconProfile1","1",val)
/// zhouzq 2011.06.05
ClassMethod Show(compid As %Library.String, ItemID As %Library.String, ProfileID As %Library.String, val As %Library.String, ImageReturnType As %Library.String = "") As %Library.Status
{
}

/// @param : code    图标组的描述   (走描述--兼容问题)
/// @param : val     病人信息       如："EpisodeID^ApptID^SchedDate^PatientID^WardID"
/// @param : context 上下文内容     可为空
/// @debug : ##class(epr.CTIconProfile).ShowIcon("MAP","1^^^1","")
ClassMethod ShowIcon(code As %String, val As %String, context As %String = "") [ ProcedureBlock = 0 ]
{
}

/// Created for Log 26756
/// by wuqk 2011-06-29 
ClassMethod websysSave(compref As %String, id As %String)
{
}

/// by wuqk 2011-0-30
ClassMethod websysSaveLinks(compref As %Library.String, id As %Library.String)
{
}

/// ab 7.03.07 61960
ClassMethod CodeTableIconItems() As %String
{
}

Query Find(name As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Description,Code")
{
SELECT ID, Description, Code
FROM epr.CTIconProfile
WHERE (Description %STARTSWITH :name)
}

Query ItemsFind(ProfileID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,IconID,Code,Description,Icon,Sequence,Active")
{
}

Index UDESC On Description [ Unique ];

Index UCODE On Code [ Unique ];

Storage Default
{
<Data name="CTIconProfileClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="CTIconProfileDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>IncludeCTIcons</Value>
</Value>
<Value name="4">
<Value>CodeTableIcons</Value>
</Value>
</Data>
<DataLocation>^epr.CTIconProfileD</DataLocation>
<DefaultData>CTIconProfileDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CTIconProfileD</IdLocation>
<IndexLocation>^epr.CTIconProfileI</IndexLocation>
<StreamLocation>^epr.CTIconProfileS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
