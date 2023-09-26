Class User.DHCDocAssPlanFav Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHC_DocAssPlanFav, StorageStrategy = Default ]
{

Parameter EXTENTSIZE = 250;

Index SaveType On (APFSaveType, APFSaveRefer, PAPPreDirectory);

Index Directory On PAPPreDirectory;

/// 科室或者全院保存
Property APFSaveType As %String [ SqlColumnNumber = 2, SqlFieldName = APF_SaveType ];

/// 科室或者院区id
Property APFSaveRefer As %String [ SqlColumnNumber = 3, SqlFieldName = APF_SaveRefer ];

/// PAP_PreDirectory 指向User.DHCDocAssPlanFav
Property PAPPreDirectory As %String [ SqlColumnNumber = 4, SqlFieldName = PAP_PreDirectory ];

/// PAP_Title
Property PAPTitle As %String [ SqlColumnNumber = 5, SqlFieldName = PAP_UserType ];

/// APF_UserType
Property APFUserType As %String [ SqlColumnNumber = 6, SqlFieldName = APF_UserType ];

/// APF_PatSymptom
Property APFPatSymptom As %GlobalBinaryStream(LOCATION = "^DHCDocAssPlanFavS") [ SqlColumnNumber = 7, SqlFieldName = APF_PatSymptom ];

/// APF_ExpectedGoal
Property APFExpectedGoal As %GlobalBinaryStream(LOCATION = "^DHCDocAssPlanFavS") [ SqlColumnNumber = 8, SqlFieldName = APF_ExpectedGoal ];

/// APF_Measures
Property APFMeasures As %GlobalBinaryStream(LOCATION = "^DHCDocAssPlanFavS") [ SqlColumnNumber = 9, SqlFieldName = APF_Measures ];

/// APF_State (0:closed  1:opened)
Property APFState As %String [ SqlColumnNumber = 10, SqlFieldName = APF_State ];

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAPPreDirectory</Value>
</Value>
<Value name="3">
<Value>PAPTitle</Value>
</Value>
<Value name="4">
<Value>APFUserType</Value>
</Value>
<Value name="5">
<Value>APFPatSymptom</Value>
</Value>
<Value name="6">
<Value>APFExpectedGoal</Value>
</Value>
<Value name="7">
<Value>APFMeasures</Value>
</Value>
<Value name="8">
<Value>APFSaveType</Value>
</Value>
<Value name="9">
<Value>APFSaveRefer</Value>
</Value>
<Value name="10">
<Value>PAPPreDirectory</Value>
</Value>
<Value name="11">
<Value>APFState</Value>
</Value>
</Data>
<DataLocation>^DHCDocAssPlanFavD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^DHCDocAssPlanFavD</IdLocation>
<IndexLocation>^DHCDocAssPlanFavI</IndexLocation>
<SqlRowIdName>APF_RowID</SqlRowIdName>
<StreamLocation>^DHCDocAssPlanFavS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
