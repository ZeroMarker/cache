Class dbo.RGOrderPlan Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_OrderPlan, StorageStrategy = Default ]
{

Index IndexOrderPlanNo On OrderPlanNo [ SqlName = Index_OrderPlanNo, Type = index, Unique ];

Index IndexReagentGroup On ReagentGroupDR [ SqlName = Index_ReagentGroup, Type = index ];

Index IndexCreator On CreatorDR [ SqlName = Index_Creator, Type = index ];

Index IndexCreateDate On CreateDate [ SqlName = Index_CreateDate, Type = index ];

Index IndexSubmitDate On SubmitDate [ SqlName = Index_SubmitDate, Type = index ];

Index IndexSubmiter On SubmiterDR [ SqlName = Index_Submiter, Type = index ];

Index IndexApprover On ApproverDR [ SqlName = Index_Approver, Type = index ];

Index PKRGORDERPLAN On RowID [ PrimaryKey, SqlName = PK_RG_ORDERPLAN, Type = index, Unique ];

ForeignKey FKRGOrderPlanGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_OrderPlan_Group ];

ForeignKey FKRGOrderPlanCreator(CreatorDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_OrderPlan_Creator ];

ForeignKey FKRGOrderPlanSubmiter(SubmiterDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_OrderPlan_Submiter ];

ForeignKey FKRGOrderPlanApprover(ApproverDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_OrderPlan_Approver ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property OrderPlanNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Status As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property CreatorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property SubmiterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property SubmitDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property SubmitTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property ApproverDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property ApproveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property ApproveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="RGOrderPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderPlanNo</Value>
</Value>
<Value name="3">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>CreatorDR</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>SubmiterDR</Value>
</Value>
<Value name="9">
<Value>SubmitDate</Value>
</Value>
<Value name="10">
<Value>SubmitTime</Value>
</Value>
<Value name="11">
<Value>ApproverDR</Value>
</Value>
<Value name="12">
<Value>ApproveDate</Value>
</Value>
<Value name="13">
<Value>ApproveTime</Value>
</Value>
<Value name="14">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.RGOrderPlanD</DataLocation>
<DefaultData>RGOrderPlanDefaultData</DefaultData>
<IdLocation>^dbo.RGOrderPlanD</IdLocation>
<IndexLocation>^dbo.RGOrderPlanI</IndexLocation>
<StreamLocation>^dbo.RGOrderPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
