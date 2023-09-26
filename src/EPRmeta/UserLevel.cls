/// 用户级别
Class EPRmeta.UserLevel Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index NameIndex On Name [ Unique ];

Property Name As %String(TRUNCATE = 1);

//英文代码

Property Description As %String(TRUNCATE = 1);

//中文描述

Property IsValid As %String(TRUNCATE = 1);

//1 or 0

/// d ##Class(EPRmeta.UserLevel).IniData()
ClassMethod IniData()
{
	&sql(delete from EPRmeta.UserLevel)
 
	s obj=##Class(EPRmeta.UserLevel).%New()
	s obj.Name="Resident",obj.Description="住院医师",obj.IsValid="1"
    d obj.%Save()    	
   
    s obj=##Class(EPRmeta.UserLevel).%New()
	s obj.Name="Attending",obj.Description="主治医师",obj.IsValid="1"
    d obj.%Save()  
    
    s obj=##Class(EPRmeta.UserLevel).%New()
	s obj.Name="Chief",obj.Description="主任/副主任医师",obj.IsValid="1"
    d obj.%Save()  

    s obj=##Class(EPRmeta.UserLevel).%New()
	s obj.Name="",obj.Description="未分配",obj.IsValid="1"
    d obj.%Save()
}

Query SELECTALL() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Name:%String,Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_UserLevel_SELECTALL, SqlProc ]
{
	SELECT Name, Description
    FROM EPRmeta.UserLevel
    WHERE IsValid = '1'
}

Storage Default
{
<Data name="UserLevelDefaultData">
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
</Data>
<DataLocation>^DHCEPRM.UserLevelD</DataLocation>
<DefaultData>UserLevelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.UserLevelD</IdLocation>
<IndexLocation>^DHCEPRM.UserLevelI</IndexLocation>
<StreamLocation>^DHCEPRM.UserLevelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
