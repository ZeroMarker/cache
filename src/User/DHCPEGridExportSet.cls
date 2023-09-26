/// Description: HISUI DataGrid表格导出配置表
/// FileName: User.DHCPEGridExportSet
/// Creator: wangguoying
/// Date: 2022-07-13
Class User.DHCPEGridExportSet Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_GridExportSet ]
{

Parameter ClassName = "User.DHCPEGridExportSet";

Relationship GESCols As User.DHCPEGridExportColsSet [ Cardinality = children, Inverse = GESCParRef ];

/// 业务界面名称  取CSP名称
Property GESPageName As %String [ Required, SqlColumnNumber = 2, SqlFieldName = GES_PageName ];

/// DataGrid 元素ID
Property GESElementID As %String [ Required, SqlColumnNumber = 3, SqlFieldName = GES_ElementID ];

/// 用户ID
Property GESUserID As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = GES_UserID ];

/// 科室ID
Property GESLocID As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = GES_LocID ];

/// 安全组ID
Property GESGroupID As User.SSGroup [ SqlColumnNumber = 6, SqlFieldName = GES_GroupID ];

/// 导出文件名称
Property GESFileName As %String(MAXLEN = 200) [ SqlColumnNumber = 7, SqlFieldName = GES_FileName ];

/// 导出文件标题
Property GESTitle As %String(MAXLEN = 200) [ SqlColumnNumber = 8, SqlFieldName = GES_Title ];

/// 标题大小
Property GESTitleSize As %Integer [ SqlColumnNumber = 9, SqlFieldName = GES_TitleSize ];

/// 落款
Property GESInscribe As %String(MAXLEN = 200) [ SqlColumnNumber = 10, SqlFieldName = GES_Inscribe ];

/// 页签字段
Property GESSheetField As %String [ SqlColumnNumber = 11, SqlFieldName = GES_SheetField ];

/// 显示线条
Property GESShowLine As %String(VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 12, SqlFieldName = GES_ShowLine ];

/// 更新人
Property GESUpdateUser As User.SSUser [ Required, SqlColumnNumber = 13, SqlFieldName = GES_UpdateUser ];

/// 更新日期
Property GESUpdateDate As %Date [ Required, SqlColumnNumber = 14, SqlFieldName = GES_UpdateDate ];

/// 更新时间
Property GESUpdateTime As %Time [ Required, SqlColumnNumber = 15, SqlFieldName = GES_UpdateTime ];

Index IndOfPageElment On (GESPageName, GESElementID);

Storage Default
{
<Data name="DHCPEGridExportSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GESPageName</Value>
</Value>
<Value name="3">
<Value>GESElementID</Value>
</Value>
<Value name="4">
<Value>GESUserID</Value>
</Value>
<Value name="5">
<Value>GESLocID</Value>
</Value>
<Value name="6">
<Value>GESGroupID</Value>
</Value>
<Value name="7">
<Value>GESUpdateUser</Value>
</Value>
<Value name="8">
<Value>GESUpdateDate</Value>
</Value>
<Value name="9">
<Value>GESUpdateTime</Value>
</Value>
<Value name="10">
<Value>GESFileName</Value>
</Value>
<Value name="11">
<Value>GESTitle</Value>
</Value>
<Value name="12">
<Value>GESTitleSize</Value>
</Value>
<Value name="13">
<Value>GESInscribe</Value>
</Value>
<Value name="14">
<Value>GESSheetField</Value>
</Value>
<Value name="15">
<Value>GESShowLine</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEGridExportSetD</DataLocation>
<DefaultData>DHCPEGridExportSetDefaultData</DefaultData>
<IdLocation>^User.DHCPEGridExportSetD</IdLocation>
<IndexLocation>^User.DHCPEGridExportSetI</IndexLocation>
<StreamLocation>^User.DHCPEGridExportSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
