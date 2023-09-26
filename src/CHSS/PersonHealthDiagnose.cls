Class CHSS.PersonHealthDiagnose Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = DiagnoseRowId, SqlTableName = PersonHealthDiagnose ]
{

/// PersonRowIdParref  CHSS.PersonHealthRecordMain
Property PersonRowIdParref As %Integer;

/// DetailRowId
Property DetailRowId As %Integer;

/// 项目名称
Property ItemName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 项目代码
Property ItemdCode As %String(MAXLEN = 10, TRUNCATE = 1);

/// 项目分类代码
Property ItemAssortCode As %String(MAXLEN = 10, TRUNCATE = 1);

/// 项目分类名称
Property ItemAssortName As %String(MAXLEN = 60, TRUNCATE = 1);

/// 既往观察结果
Property DiagnoseResult As %String(MAXLEN = 100, TRUNCATE = 1);

/// ICD-10
Property ICDCode As %String(MAXLEN = 30, TRUNCATE = 1);

/// 开始日期
Property DateOfStart As %Date;

/// 结束日期
Property DateOfEnd As %Date;

/// 主要部位
Property MainPart As %Integer;

/// 主要原因
Property MainReason As %Integer;

/// 主要诊断
Property MainDiagnose As %Integer;

/// 顺序码
Property SequenceCode As %String(TRUNCATE = 1);

/// 对应记录号
Property RecordRowIdDR As %Integer;

/// 对应表
Property TableName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 对应类别
Property RecordType As %Integer;

/// 表中类别
Property TableType As %String(MAXLEN = 50, TRUNCATE = 1);

Index PersonAndCodeIndex On (PersonRowIdParref, ItemdCode);

Index PersonCheckCodeIndex On (PersonRowIdParref, ItemdCode, RecordRowIdDR);

Index PersonRowIdParrefIndex On PersonRowIdParref;

//插入之后 往CHSS.CommunityWorkStaNum 里插入数据

Trigger AfterInsert [ Event = INSERT, Time = AFTER ]
{
    Set DiagnoseRowId = {DiagnoseRowId} 
    Set PersonRowId = {PersonRowIdParref} 
    Set ItemdCode = {ItemdCode}
    Set ItemAssortName = {ItemAssortName} 
    d ##class(CHSSWeb.CommStaTriggerService).DiagnoseRecordInsert(DiagnoseRowId,PersonRowId,ItemdCode,ItemAssortName)
}

//修改之前 往CHSS.CommunityWorkStaNum 里更新数据

Trigger BeforeUpdate [ Event = UPDATE ]
{
  
  Set DiagnoseRowId = {DiagnoseRowId} 
    Set PersonRowId = {PersonRowIdParref} 
    Set ItemdCode = {ItemdCode}
     Set ItemAssortName = {ItemAssortName} 
    ;d ##class(CHSSWeb.CommStaTriggerService).DiagnoseRecordUpdate(DiagnoseRowId,PersonRowId,ItemdCode,ItemAssortName)
}

//删除之前 CHSS.CommunityWorkStaNum 里删除数据

Trigger BeforeDelete [ Event = DELETE ]
{
  
     Set DiagnoseRowId = {DiagnoseRowId} 
    Set PersonRowId = {PersonRowIdParref} 
    Set ItemdCode = {ItemdCode}
     Set ItemAssortName = {ItemAssortName}  
    d ##class(CHSSWeb.CommStaTriggerService).DiagnoseRecordDelete(DiagnoseRowId,PersonRowId,ItemdCode,ItemAssortName)
}

Method %OnBeforeSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="Error"
	i insert'=1 d
    .Set DiagnoseRowId = %this.%Id()   
    .Set PersonRowId = %this.PersonRowIdParref
    .Set ItemdCode= %this.ItemdCode
    .Set ItemAssortName = %this.ItemAssortName
    .;d ##class(CHSSWeb.CommStaTriggerService).DiagnoseRecordUpdate(DiagnoseRowId,PersonRowId,ItemdCode,ItemAssortName)
	Quit $$$OK
Error
 	Quit $$$OK
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="Error"
	i insert=1 d 
	 .Set DiagnoseRowId = %this.%Id()   
    .Set PersonRowId = %this.PersonRowIdParref
    .Set ItemdCode= %this.ItemdCode
    .Set ItemAssortName = %this.ItemAssortName
    .d ##class(CHSSWeb.CommStaTriggerService).DiagnoseRecordInsert(DiagnoseRowId,PersonRowId,ItemdCode,ItemAssortName)
	Quit $$$OK
Error
 	Quit $$$OK
}

/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status
{
	S $zt="Error"
 
	S tmpFamily= ##class(CHSS.ElerlyBaseInfo).%Open(oid) 
	 .Set DiagnoseRowId = %this.%Id()   
    .Set PersonRowId = %this.PersonRowIdParref
    .Set ItemdCode= %this.ItemdCode
    .Set ItemAssortName = %this.ItemAssortName
    d ##class(CHSSWeb.CommStaTriggerService).DiagnoseRecordDelete(DiagnoseRowId,PersonRowId,ItemdCode,ItemAssortName)

	Quit $$$OK
Error
 	Quit $$$OK
}

Storage Default
{
<Data name="PersonHealthDiagnoseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DetailRowId</Value>
</Value>
<Value name="3">
<Value>DiagnoseResult</Value>
</Value>
<Value name="4">
<Value>ICDCode</Value>
</Value>
<Value name="5">
<Value>ItemAssortCode</Value>
</Value>
<Value name="6">
<Value>ItemAssortName</Value>
</Value>
<Value name="7">
<Value>ItemName</Value>
</Value>
<Value name="8">
<Value>ItemdCode</Value>
</Value>
<Value name="9">
<Value>DateOfEnd</Value>
</Value>
<Value name="10">
<Value>DateOfStart</Value>
</Value>
<Value name="11">
<Value>MainComponent</Value>
</Value>
<Value name="12">
<Value>MainDiagnose</Value>
</Value>
<Value name="13">
<Value>MainReason</Value>
</Value>
<Value name="14">
<Value>SequenceCode</Value>
</Value>
<Value name="15">
<Value>PersonRowIdParref</Value>
</Value>
<Value name="16">
<Value>MainPart</Value>
</Value>
<Value name="17">
<Value>RecordRowIdDR</Value>
</Value>
<Value name="18">
<Value>RecordType</Value>
</Value>
<Value name="19">
<Value>TableName</Value>
</Value>
<Value name="20">
<Value>TableType</Value>
</Value>
<Value name="21">
<Value>RecordId</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonHealthDiagnoseD</DataLocation>
<DefaultData>PersonHealthDiagnoseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonHealthDiagnoseD</IdLocation>
<IndexLocation>^CHSS.PersonHealthDiagnoseI</IndexLocation>
<StreamLocation>^CHSS.PersonHealthDiagnoseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
