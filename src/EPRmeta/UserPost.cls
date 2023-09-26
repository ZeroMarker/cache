/// 用户职务
Class EPRmeta.UserPost Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index NameIndex On Name [ Unique ];

/// 英文代码
Property Name As %String(TRUNCATE = 1);

/// 中文描述
Property Description As %String(TRUNCATE = 1);

/// 操作代码
Property OperAction As %String(TRUNCATE = 1);

/// 1 or 0
Property IsValid As %String(TRUNCATE = 1);

/// d ##Class(EPRmeta.UserPost).IniData()
ClassMethod IniData()
{
	&sql(delete from EPRmeta.UserPost)
 
	s obj=##Class(EPRmeta.UserPost).%New()
	s obj.Name="Chairman",obj.Description="科主任",obj.OperAction="ChairmanCheck",obj.IsValid="1"
    d obj.%Save()    	
   
    s obj=##Class(EPRmeta.UserPost).%New()
	s obj.Name="QCDoc",obj.Description="质控医师",obj.OperAction="QCDocCheck",obj.IsValid="1"
    d obj.%Save()  
    
    s obj=##Class(EPRmeta.UserPost).%New()
	s obj.Name="QCNurse",obj.Description="质控护士",obj.OperAction="QCNurseCheck",obj.IsValid="1"
    d obj.%Save()   
    
    s obj=##Class(EPRmeta.UserPost).%New()
	s obj.Name="ChargeNurse",obj.Description="责任护士",obj.OperAction="ChargeNurseCheck",obj.IsValid="1"
    d obj.%Save()
    
    s obj=##Class(EPRmeta.UserPost).%New()
	s obj.Name="",obj.Description="未分配",obj.OperAction="",obj.IsValid="1"
    d obj.%Save()
}

Query SELECTALL() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Name:%String,Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_UserPost_SELECTALL, SqlProc ]
{
	SELECT Name, Description
    FROM EPRmeta.UserPost
    WHERE IsValid = '1'
}

Storage Default
{
<Data name="UserPostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>IsValid</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>OperAction</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.UserPostD</DataLocation>
<DefaultData>UserPostDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.UserPostD</IdLocation>
<IndexLocation>^DHCEPRM.UserPostI</IndexLocation>
<StreamLocation>^DHCEPRM.UserPostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
