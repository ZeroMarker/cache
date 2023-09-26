/// geyanguang
/// 配对维护
Class DHCINM.Arg.MgWardPostRatio Extends %Persistent
{

/// 病区
Property RatioWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Ratio_Ward ];

/// 病区班次
Property RatioPost As CF.DHCINM.DB.MgArgWardPost [ SqlColumnNumber = 3, SqlFieldName = Ratio_Post ];

/// 数量
Property RatioNumber As %Integer [ SqlColumnNumber = 4, SqlFieldName = Ratio_Number ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 5, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 7, SqlFieldName = Create_Time ];

Index Ward On RatioWard;

Storage Default
{
<Data name="MgWardPostRatioDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RatioWard</Value>
</Value>
<Value name="3">
<Value>RatioPost</Value>
</Value>
<Value name="4">
<Value>RatioNumber</Value>
</Value>
<Value name="5">
<Value>Creator</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Arg.MgWardPostRatioD</DataLocation>
<DefaultData>MgWardPostRatioDefaultData</DefaultData>
<IdLocation>^DHCINM.Arg.MgWardPostRatioD</IdLocation>
<IndexLocation>^DHCINM.Arg.MgWardPostRatioI</IndexLocation>
<StreamLocation>^DHCINM.Arg.MgWardPostRatioS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
