/// 科室导诊单项目分类
Class User.DHCPEUsherItemCat Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_UsherItemCat ]
{

Parameter ClassName = "User.DHCPEUsherItemCat";

/// 科室 指向CT_Loc
Property PILocDR As %String [ SqlFieldName = PI_LocDR ];

/// 导诊分类代码
Property PICatCode As %String [ SqlFieldName = PI_CatCode ];

/// 导诊分类（如：超声）
Property PICategory As %String [ SqlFieldName = PI_Category ];

/// 顺序号
Property PISort As %Integer [ SqlFieldName = PI_Sort ];

/// 就餐标志
Property PIDiet As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = PI_Diet ];

/// 自动调整顺序
Property PIAutoChange As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = PI_AutoChange ];

/// 注意事项
Property PIPlace As %String [ SqlFieldName = PI_Place ];

/// 医生签名
Property PIDocSignName As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = PI_DocSignName ];

/// 患者签名
Property PIPatSignName As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = PI_PatSignName ];

/// 作废标记
Property PINoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = PI_NoActive ];

/// 更新日期
Property PIUpdateDate As %Date [ SqlFieldName = PI_UpdateDate ];

/// 更新时间
Property PIUpdateTime As %Time [ SqlFieldName = PI_UpdateTime ];

/// 更新人 指向SS_User
Property PIUpdateUserDR As %String [ SqlFieldName = PI_UpdateUserDR ];

/// 科室+导诊分类 索引
Index IdxOfLocCat On (PILocDR, PICategory);

/// 科室+导诊分类代码 索引
Index IdxOfLocCatCode On (PILocDR, PICatCode);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PILocDR</Value>
</Value>
<Value name="3">
<Value>PICategory</Value>
</Value>
<Value name="4">
<Value>PISort</Value>
</Value>
<Value name="5">
<Value>PIPlace</Value>
</Value>
<Value name="6">
<Value>PIDocSignName</Value>
</Value>
<Value name="7">
<Value>PIPatSignName</Value>
</Value>
<Value name="8">
<Value>PINoActive</Value>
</Value>
<Value name="9">
<Value>PIUpdateDate</Value>
</Value>
<Value name="10">
<Value>PIUpdateTime</Value>
</Value>
<Value name="11">
<Value>PIUpdateUserDR</Value>
</Value>
<Value name="12">
<Value>PICatCode</Value>
</Value>
<Value name="13">
<Value>PIDiet</Value>
</Value>
<Value name="14">
<Value>PIAutoChange</Value>
</Value>
</Data>
<DataLocation>^CF.PE.UsherItemCatD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.UsherItemCatD</IdLocation>
<IndexLocation>^CF.PE.UsherItemCatI</IndexLocation>
<StreamLocation>^User.DHCPEUsherItemCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
