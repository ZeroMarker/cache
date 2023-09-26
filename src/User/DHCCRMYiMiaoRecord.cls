Class User.DHCCRMYiMiaoRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlRowIdName = YM_RowId, SqlTableName = DHC_CRM_YiMiaoRecord ]
{

Parameter ClassName = "User.DHCCRMYiMiaoRecord";

Relationship ChildDHCCRMYiMiaoTime As User.DHCCRMYiMiaoTime [ Cardinality = children, Inverse = YMTParRef ];

/// 疫苗id
Property YMBDR As User.DHCCRMYiMiaoBase [ SqlColumnNumber = 2, SqlFieldName = YM_BDR ];

/// 疫苗编码
Property YMCode As %Library.String [ SqlColumnNumber = 3, SqlFieldName = YM_Code ];

/// 疫苗名称
Property YMDesc As %Library.String [ SqlColumnNumber = 4, SqlFieldName = YM_Desc ];

/// 针次
Property YMNum As %Library.Integer [ SqlColumnNumber = 5, SqlFieldName = YM_Num ];

/// 接种日期
Property YMGivenDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = YM_GivenDate ];

/// 是否接种
Property YMIsGiven As %Library.String [ SqlColumnNumber = 7, SqlFieldName = YM_IsGiven ];

/// 部位
Property YMSite As %Library.String [ SqlColumnNumber = 8, SqlFieldName = YM_Site ];

/// 剂量
Property YMDose As %Library.String [ SqlColumnNumber = 9, SqlFieldName = YM_Dose ];

/// 生成厂家
Property YMManufacturer As %Library.String [ SqlColumnNumber = 10, SqlFieldName = YM_Manufacturer ];

/// 批号
Property YMLotNo As %Library.String [ SqlColumnNumber = 11, SqlFieldName = YM_LotNo ];

/// 执行签字
Property YMUserDR As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = YM_UserDR ];

/// 备注
Property YMRemark As %Library.String [ SqlColumnNumber = 13, SqlFieldName = YM_Remark ];

/// 下次日期
Property YMNextDate As %Library.Date [ SqlColumnNumber = 14, SqlFieldName = YM_NextDate ];

/// 客户id
Property YMPatientDR As User.PAPerson [ SqlColumnNumber = 15, SqlFieldName = YM_PatientDR ];

/// 顺序
Property YMSequence As %Library.Integer [ SqlColumnNumber = 16, SqlFieldName = YM_Sequence ];

/// 审核签字
Property YMSHUserDR As User.SSUser [ SqlColumnNumber = 17, SqlFieldName = YM_SHUserDR ];

/// 状态
Property YMStatus As %Library.String [ SqlColumnNumber = 18, SqlFieldName = YM_Status ];

/// 方式
Property YMWay As %Library.String [ SqlColumnNumber = 19, SqlFieldName = YM_Way ];

/// 外院接种
Property YMGivenUserDR As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = YM_GivenUserDR ];

Index YMPatientSeqIndex On (YMPatientDR, YMSequence);

Index YMPatientBidIndex On (YMPatientDR, YMBDR);

Index YMNextDateIndex On YMNextDate;

Storage Default
{
<Data name="DHCCRMYiMiaoRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>YMBDR</Value>
</Value>
<Value name="3">
<Value>YMCode</Value>
</Value>
<Value name="4">
<Value>YMDesc</Value>
</Value>
<Value name="5">
<Value>YMNum</Value>
</Value>
<Value name="6">
<Value>YMGivenDate</Value>
</Value>
<Value name="7">
<Value>YMIsGiven</Value>
</Value>
<Value name="8">
<Value>YMSite</Value>
</Value>
<Value name="9">
<Value>YMDose</Value>
</Value>
<Value name="10">
<Value>YMManufacturer</Value>
</Value>
<Value name="11">
<Value>YMLotNo</Value>
</Value>
<Value name="12">
<Value>YMUserDR</Value>
</Value>
<Value name="13">
<Value>YMRemark</Value>
</Value>
<Value name="14">
<Value>YMNextDate</Value>
</Value>
<Value name="15">
<Value>YMPatientDR</Value>
</Value>
<Value name="16">
<Value>YMSequence</Value>
</Value>
<Value name="17">
<Value>YMSHUserDR</Value>
</Value>
<Value name="18">
<Value>YMStatus</Value>
</Value>
<Value name="19">
<Value>YMWay</Value>
</Value>
<Value name="20">
<Value>YMGivenUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCCRMYiMiaoRecordD</DataLocation>
<DefaultData>DHCCRMYiMiaoRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCCRMYiMiaoRecordD</IdLocation>
<IndexLocation>^User.DHCCRMYiMiaoRecordI</IndexLocation>
<StreamLocation>^User.DHCCRMYiMiaoRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
