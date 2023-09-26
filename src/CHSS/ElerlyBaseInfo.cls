Class CHSS.ElerlyBaseInfo Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = ElerlyRowId, SqlTableName = ElerlyBaseInfo ]
{

/// 个人档案主键
Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

/// 老年人等级
Property ElerlyGrade As %String(MAXLEN = 80, TRUNCATE = 1);

/// 生活赡养
Property LifeSupport As %String(MAXLEN = 100, TRUNCATE = 1);

/// 护理情况
Property Nursing As %String(MAXLEN = 100, TRUNCATE = 1);

/// 视力指数
Property Eyesight As CHSS.DictEyesight;

/// 牙齿残缺
Property ToothDeformity As CHSS.DictToothDeformity;

/// 被调查者
Property Informant As %String(MAXLEN = 60, TRUNCATE = 1);

/// 调查者
Property Inquirer As %String(MAXLEN = 60, TRUNCATE = 1);

/// 记录者
Property Recorder As %String(MAXLEN = 60, TRUNCATE = 1);

/// 签名日期
Property DateOfSign As %Date;

/// 调查日期
Property DateOfInquire As %Date;

/// 记录日期
Property DateOfRecord As %Date;

Index PersonRowIdIndex On PersonRowId [ Unique ];

//插入之后 往CHSS.CommunityWorkStaNum 里插入数据

Trigger AfterInsert [ Event = INSERT, Time = AFTER ]
{
    Set ElerlyRowId = {ElerlyRowId} 
    Set PersonRowId = {PersonRowId} 
    Set OperateDate = {DateOfRecord}  
    d ##class(CHSSWeb.CommStaTriggerService).ElerlyRecordInsert("ElerlyBaseInfo",ElerlyRowId,PersonRowId,OperateDate)
}

//修改之前 往CHSS.CommunityWorkStaNum 里更新数据

Trigger BeforeUpdate [ Event = UPDATE ]
{
  
   Set ElerlyRowId = {ElerlyRowId} 
    Set PersonRowId = {PersonRowId} 
    Set OperateDate = {DateOfRecord}  
    d ##class(CHSSWeb.CommStaTriggerService).ElerlyRecordUpdate("ElerlyBaseInfo",ElerlyRowId,PersonRowId,OperateDate)
}

//删除之前 CHSS.CommunityWorkStaNum 里删除数据

Trigger BeforeDelete [ Event = DELETE ]
{
  
    Set ElerlyRowId = {ElerlyRowId} 
    Set PersonRowId = {PersonRowId} 
    Set OperateDate = {DateOfRecord}   
    d ##class(CHSSWeb.CommStaTriggerService).ElerlyRecordDelete("ElerlyBaseInfo",ElerlyRowId,PersonRowId,OperateDate)
}

Method %OnBeforeSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="Error"
	i insert'=1 d
    .Set ElerlyRowId = %this.%Id()   
    .Set PersonRowId = %this.PersonRowId
    .;W "----"_PersonRowId,!
    .Set OperateDate = %this.DateOfRecord
    .d ##class(CHSSWeb.CommStaTriggerService).ElerlyRecordUpdate("ElerlyBaseInfo",ElerlyRowId,PersonRowId,OperateDate)
	Quit $$$OK
Error
 	Quit $$$OK
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="Error"
	i insert=1 d 
	.Set ElerlyRowId = %this.%Id()   
    .Set PersonRowId = %this.PersonRowId
    .;w "SSSSSSSSSSSSSSSSS"_PersonRowId,!
    .Set OperateDate = %this.DateOfRecord
    .d ##class(CHSSWeb.CommStaTriggerService).ElerlyRecordInsert("ElerlyBaseInfo",ElerlyRowId,PersonRowId,OperateDate)
	Quit $$$OK
Error
 	Quit $$$OK
}

/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status
{
	S $zt="Error"
 
	S tmpFamily= ##class(CHSS.ElerlyBaseInfo).%Open(oid) 
	Set ElerlyRowId = %this.%Id()   
    Set PersonRowId = tmpFamily.PersonRowId  
    Set OperateDate = tmpFamily.DateOfRecord 
    d ##class(CHSSWeb.CommStaTriggerService).ElerlyRecordDelete("ElerlyBaseInfo",ElerlyRowId,PersonRowId,OperateDate)

	Quit $$$OK
Error
 	Quit $$$OK
}

Storage Default
{
<Data name="ElerlyBaseInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateOfInquire</Value>
</Value>
<Value name="3">
<Value>DateOfRecord</Value>
</Value>
<Value name="4">
<Value>DateOfSign</Value>
</Value>
<Value name="5">
<Value>ElerlyGrade</Value>
</Value>
<Value name="6">
<Value>Eyesight</Value>
</Value>
<Value name="7">
<Value>Informant</Value>
</Value>
<Value name="8">
<Value>Inquirer</Value>
</Value>
<Value name="9">
<Value>LifeSupport</Value>
</Value>
<Value name="10">
<Value>Nursing</Value>
</Value>
<Value name="11">
<Value>PersonRowId</Value>
</Value>
<Value name="12">
<Value>Recorder</Value>
</Value>
<Value name="13">
<Value>ToothDeformity</Value>
</Value>
</Data>
<DataLocation>^CHSS.ElerlyBaseInfoD</DataLocation>
<DefaultData>ElerlyBaseInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.ElerlyBaseInfoD</IdLocation>
<IndexLocation>^CHSS.ElerlyBaseInfoI</IndexLocation>
<StreamLocation>^CHSS.ElerlyBaseInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
