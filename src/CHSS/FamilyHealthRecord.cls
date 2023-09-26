Class CHSS.FamilyHealthRecord Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = FamilyRowId, SqlTableName = FamilyHealthRecord ]
{

/// 家庭编码
Property FamilyCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

/// 建档日期
Property DateOfRegister As %Date(FORMAT = 1) [ SqlColumnNumber = 3 ];

/// 录入日期
Property DateOfInput As %Date(FORMAT = 1) [ SqlColumnNumber = 4 ];

/// 责任医生
Property Doctor As %String(MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 责任护士
Property Nurse As User.SSUser [ SqlColumnNumber = 6 ];

/// 录入人员
Property Operator As User.SSUser [ SqlColumnNumber = 7 ];

/// 户主姓名
Property HouseHoldName As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// 家庭人口数
Property FamilyPeopleNum As %Numeric [ SqlColumnNumber = 9 ];

/// 现住人口数
Property CurrentNum As %Numeric [ SqlColumnNumber = 10 ];

/// 家庭平均月收入
Property AverageEarnings As %Float [ SqlColumnNumber = 11 ];

/// 住房类型
Property HouseType As CHSS.DictHouseType [ SqlColumnNumber = 12 ];

/// 住房面积
Property HouseArea As %Float [ SqlColumnNumber = 13 ];

/// 家庭燃料类型
Property FuelType As CHSS.DictFamilyFuelType [ SqlColumnNumber = 14 ];

/// 厕所类型
Property ToiletType As CHSS.DictToiletType [ SqlColumnNumber = 15 ];

/// 家庭住址
Property FamilyAddress As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 16 ];

/// 固定电话
Property FamilyPhone As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17 ];

/// 移动电话
Property CellPhone As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18 ];

/// EMail
Property EMail As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19 ];

/// 邮编
Property Post As %String(MAXLEN = 6, TRUNCATE = 1) [ SqlColumnNumber = 20 ];

/// 家庭状态
Property FamilyStatus As %Integer [ SqlColumnNumber = 21 ];

/// 机构编码
Property CommunityCode As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 22 ];

/// 备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 23 ];

/// 地址类别代码
Property AddressTypeDR As CHSS.DictAddressType [ SqlColumnNumber = 24 ];

/// 省（自治区、直辖市）
Property ProvinceDR As CHSS.DictProvince [ SqlColumnNumber = 25 ];

/// 市（地区）
Property CityDR As CHSS.DictCity [ SqlColumnNumber = 26 ];

/// 县（区）
Property SectionDR As CHSS.DictSection [ SqlColumnNumber = 27 ];

/// 乡（镇、街道办事处）
Property StreetDR As CHSS.DictStreet [ SqlColumnNumber = 28 ];

/// 村（街、路、弄等）ID
Property VillageDR As CHSS.DictVillage [ SqlColumnNumber = 29 ];

/// 门牌号码
Property DoorPlate As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30 ];

/// 行政区划代码
Property AdministrativeDivisions As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 31 ];

/// 村（街、路、弄等）Description
Property VillageName As %String(MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 32 ];

/// 是否受灾家庭
Property bEarthquakeFamily As %String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 33 ];

/// 饮用水来源 
Property WaterSource As %String(MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 34 ];

/// 档案建立类别
Property RegisterType As %Integer [ SqlColumnNumber = 35 ];

Index FamilyCodeIndex On FamilyCode [ Unique ];

Index CommunityCodeIndex On CommunityCode;

//插入之后 往ReportCommunityFPCount 里插入数据

Trigger AfterInsert [ Event = INSERT, Time = AFTER ]
{
    Set FamilyRowId = {FamilyRowId} 
    Set CommunityCode = {CommunityCode} 
    Set DateOfRegister = {DateOfRegister}  
    d ##class(CHSSWeb.ReportOfTrigger).RecordInsert("FamilyHealthRecord",FamilyRowId,CommunityCode,DateOfRegister)
    q
}

//修改之前 往ReportCommunityFPCount 里更新数据

Trigger BeforeUpdate [ Event = UPDATE ]
{
    Set FamilyRowId = {FamilyRowId} 
    Set CommunityCode = {CommunityCode} 
    Set DateOfRegister = {DateOfRegister} 
   d ##class(CHSSWeb.ReportOfTrigger).RecordUpdate("FamilyHealthRecord",FamilyRowId,CommunityCode,DateOfRegister)
  q
}

//删除之前 ReportCommunityFPCount 里删除数据

Trigger BeforeDelete [ Event = DELETE ]
{
  
    Set FamilyRowId = {FamilyRowId} 
    Set CommunityCode = {CommunityCode} 
    Set DateOfRegister = {DateOfRegister} 
    d ##class(CHSSWeb.ReportOfTrigger).RecordDelete("FamilyHealthRecord",FamilyRowId,CommunityCode,DateOfRegister)
    q
}

Method %OnBeforeSave(insert As %Boolean) As %Status
{
	s $zt="Error"
 
	i insert'=1 d
    .Set FamilyRowId = %this.%Id()  
    .Set CommunityCode = %this.CommunityCode
    .Set DateOfRegister = %this.DateOfRegister 
    .d ##class(CHSSWeb.ReportOfTrigger).RecordUpdate("FamilyHealthRecord",FamilyRowId,CommunityCode,DateOfRegister)
   	Quit $$$OK
Error
	Quit $$$OK
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="Error"
	i insert=1 d 
	.Set FamilyRowId = %this.%Id()   
    .Set CommunityCode = %this.CommunityCode
    .Set DateOfRegister = %this.DateOfRegister 
    .d ##class(CHSSWeb.ReportOfTrigger).RecordInsert("FamilyHealthRecord",FamilyRowId,CommunityCode,DateOfRegister)
	Quit $$$OK
Error
 	Quit $$$OK
}

/// [Previously private]
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status
{
	S $zt="Error"
 
	S tmpFamily= ##class(CHSS.FamilyHealthRecord).%Open(oid) 
	Set FamilyRowId = tmpFamily.%Id()  
    Set CommunityCode = tmpFamily.CommunityCode  
    Set DateOfRegister = tmpFamily.DateOfRegister   
    d ##class(CHSSWeb.ReportOfTrigger).RecordDelete("FamilyHealthRecord",FamilyRowId,CommunityCode,DateOfRegister)
	Quit $$$OK
Error
 	Quit $$$OK
}

Storage Default
{
<Data name="FamilyHealthRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FamilyCode</Value>
</Value>
<Value name="3">
<Value>DateInput</Value>
</Value>
<Value name="4">
<Value>DateRegister</Value>
</Value>
<Value name="5">
<Value>Doctor</Value>
</Value>
<Value name="6">
<Value>Nurse</Value>
</Value>
<Value name="7">
<Value>Operator</Value>
</Value>
<Value name="8">
<Value>CurrentNum</Value>
</Value>
<Value name="9">
<Value>FamilyPeopleNum</Value>
</Value>
<Value name="10">
<Value>HouseHoldName</Value>
</Value>
<Value name="11">
<Value>AverageEarnings</Value>
</Value>
<Value name="12">
<Value>HouseType</Value>
</Value>
<Value name="13">
<Value>FuelType</Value>
</Value>
<Value name="14">
<Value>HouseArea</Value>
</Value>
<Value name="15">
<Value>CellPhone</Value>
</Value>
<Value name="16">
<Value>FamilyAddress</Value>
</Value>
<Value name="17">
<Value>FamilyPhone</Value>
</Value>
<Value name="18">
<Value>ToiletType</Value>
</Value>
<Value name="19">
<Value>EMail</Value>
</Value>
<Value name="20">
<Value>CommunityCode</Value>
</Value>
<Value name="21">
<Value>FamilyStatus</Value>
</Value>
<Value name="22">
<Value>Post</Value>
</Value>
<Value name="23">
<Value>Remark</Value>
</Value>
<Value name="24">
<Value>DateOfRegister</Value>
</Value>
<Value name="25">
<Value>DateOfInput</Value>
</Value>
<Value name="26">
<Value>AddressTypeDR</Value>
</Value>
<Value name="27">
<Value>AdministrativeDivisions</Value>
</Value>
<Value name="28">
<Value>CityDR</Value>
</Value>
<Value name="29">
<Value>DoorPlate</Value>
</Value>
<Value name="30">
<Value>ProvinceDR</Value>
</Value>
<Value name="31">
<Value>SectionDR</Value>
</Value>
<Value name="32">
<Value>StreetDR</Value>
</Value>
<Value name="33">
<Value>VillageDR</Value>
</Value>
<Value name="34">
<Value>VillageName</Value>
</Value>
<Value name="35">
<Value>bEarthquakeFamily</Value>
</Value>
<Value name="36">
<Value>WaterSource</Value>
</Value>
<Value name="37">
<Value>RegisterType</Value>
</Value>
</Data>
<DataLocation>^CHSS.FamilyHealthRecordD</DataLocation>
<DefaultData>FamilyHealthRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.FamilyHealthRecordD</IdLocation>
<IndexLocation>^CHSS.FamilyHealthRecordI</IndexLocation>
<StreamLocation>^CHSS.FamilyHealthRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
