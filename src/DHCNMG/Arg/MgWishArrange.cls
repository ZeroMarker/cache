/// author:lulin
/// description：意愿排班表
/// date:2019年9月17日
Class DHCNMG.Arg.MgWishArrange Extends %Persistent
{

/// 病区
Property WardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = WardDR ];

/// 护士
Property PerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 3, SqlFieldName = PerDR ];

/// 日期
Property WishDate As %Date [ SqlColumnNumber = 4, SqlFieldName = WishDate ];

/// 班次id
Property PostDR As DHCNMG.DB.MgArgWardPost [ SqlColumnNumber = 5, SqlFieldName = PostDR ];

/// 备注
Property Remark As %String [ SqlColumnNumber = 6, SqlFieldName = Remark ];

/// 状态:N：保存；S:已提交；A:已审核；B:驳回;
Property Status As %String [ SqlColumnNumber = 7, SqlFieldName = Status ];

/// 审核人
Property Auditor As DHCNMG.HR.MgPersons [ SqlColumnNumber = 8, SqlFieldName = Autor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 9, SqlFieldName = AuditDate ];

Index WardPerDate On (WardDR, PerDR, WishDate);

Index PerDate On (PerDR, WishDate);

Storage Default
{
<Data name="MgWishArrangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardDR</Value>
</Value>
<Value name="3">
<Value>PerDR</Value>
</Value>
<Value name="4">
<Value>WishDate</Value>
</Value>
<Value name="5">
<Value>PostDR</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>Auditor</Value>
</Value>
<Value name="9">
<Value>AuditDate</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgWishArrangeD</DataLocation>
<DefaultData>MgWishArrangeDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgWishArrangeD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgWishArrangeI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgWishArrangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
