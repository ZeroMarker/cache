/// Description: HISUI DataGrid表格配置表
/// FileName: User.DHCPEDataGridSet
/// Creator: wangguoying
/// Date: 2022-07-11
Class User.DHCPEDataGridSet Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_DataGridSet ]
{

Parameter ClassName = "User.DHCPEDataGridSet";

Relationship DGSCols As User.DHCPEDataGridColsSet [ Cardinality = children, Inverse = DGSCParRef ];

/// 业务界面名称  取CSP名称
Property DGSPageName As %String [ Required, SqlColumnNumber = 2, SqlFieldName = DGS_PageName ];

/// DataGrid 元素ID
Property DGSElementID As %String [ Required, SqlColumnNumber = 3, SqlFieldName = DGS_ElementID ];

/// 用户ID
Property DGSUserID As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = DGS_UserID ];

/// 科室ID
Property DGSLocID As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = DGS_LocID ];

/// 安全组ID
Property DGSGroupID As User.SSGroup [ SqlColumnNumber = 6, SqlFieldName = DGS_GroupID ];

/// 更新人
Property DGSUpdateUser As User.SSUser [ Required, SqlColumnNumber = 7, SqlFieldName = DGS_UpdateUser ];

/// 更新日期
Property DGSUpdateDate As %Date [ Required, SqlColumnNumber = 8, SqlFieldName = DGS_UpdateDate ];

/// 更新时间
Property DGSUpdateTime As %Time [ Required, SqlColumnNumber = 9, SqlFieldName = DGS_UpdateTime ];

/// rowStyler函数
Property DGSRowStylerFunc As %String [ SqlColumnNumber = 10, SqlFieldName = DGS_RowStylerFunc ];

/// 自动换行
Property DGSAutoWrap As %String(VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 11, SqlFieldName = DGS_AutoWrap ];

Index IndOfPageElment On (DGSPageName, DGSElementID);

Storage Default
{
<Data name="DHCPEDataGridSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DGSPageName</Value>
</Value>
<Value name="3">
<Value>DGSElementID</Value>
</Value>
<Value name="4">
<Value>DGSUserID</Value>
</Value>
<Value name="5">
<Value>DGSLocID</Value>
</Value>
<Value name="6">
<Value>DGSGroupID</Value>
</Value>
<Value name="7">
<Value>DGSUpdateUser</Value>
</Value>
<Value name="8">
<Value>DGSUpdateDate</Value>
</Value>
<Value name="9">
<Value>DGSUpdateTime</Value>
</Value>
<Value name="10">
<Value>DGSRowStylerFunc</Value>
</Value>
<Value name="11">
<Value>DGSAutoWrap</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEDataGridSetD</DataLocation>
<DefaultData>DHCPEDataGridSetDefaultData</DefaultData>
<IdLocation>^User.DHCPEDataGridSetD</IdLocation>
<IndexLocation>^User.DHCPEDataGridSetI</IndexLocation>
<StreamLocation>^User.DHCPEDataGridSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
