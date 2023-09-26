Class User.DHCCRMYiMiaoBase Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlRowIdName = YMB_RowId, SqlTableName = DHC_CRM_YiMiaoBase ]
{

Parameter ClassName = "User.DHCCRMYiMiaoBase";

/// 疫苗代码
Property YMBCode As %Library.String [ SqlColumnNumber = 2, SqlFieldName = YMB_Code ];

/// 疫苗名称
Property YMBDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = YMB_Desc ];

/// 次数
Property YMBCount As %Library.Integer [ SqlColumnNumber = 4, SqlFieldName = YMB_Count ];

/// 部位
Property YMBSite As %Library.String [ SqlColumnNumber = 5, SqlFieldName = YMB_Site ];

/// 剂量
Property YMBDose As %Library.String [ SqlColumnNumber = 6, SqlFieldName = YMB_Dose ];

/// 生成厂家
Property YMBManufacturer As %Library.String [ SqlColumnNumber = 7, SqlFieldName = YMB_Manufacturer ];

/// 批号
Property YMBLotNo As %Library.String [ SqlColumnNumber = 8, SqlFieldName = YMB_LotNo ];

/// 备注
Property YMBRemark As %Library.String [ SqlColumnNumber = 9, SqlFieldName = YMB_Remark ];

/// 顺序
Property YMBSequence As %Library.Integer [ SqlColumnNumber = 10, SqlFieldName = YMB_Sequence ];

/// 方式
Property YMBWay As %Library.String [ SqlColumnNumber = 11, SqlFieldName = YMB_Way ];

/// 激活
Property YMBActive As %Library.String [ SqlColumnNumber = 12, SqlFieldName = YMB_Active ];

/// 院区
Property YMBHosp As User.CTHospital [ SqlColumnNumber = 13, SqlFieldName = YMB_Hospital ];

Index YMBSequenceIndex On YMBSequence;

Storage Default
{
<Data name="DHCCRMYiMiaoBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>YMBCode</Value>
</Value>
<Value name="3">
<Value>YMBDesc</Value>
</Value>
<Value name="4">
<Value>YMBCount</Value>
</Value>
<Value name="5">
<Value>YMBSite</Value>
</Value>
<Value name="6">
<Value>YMBDose</Value>
</Value>
<Value name="7">
<Value>YMBManufacturer</Value>
</Value>
<Value name="8">
<Value>YMBLotNo</Value>
</Value>
<Value name="9">
<Value>YMBRemark</Value>
</Value>
<Value name="10">
<Value>YMBSequence</Value>
</Value>
<Value name="11">
<Value>YMBWay</Value>
</Value>
<Value name="12">
<Value>YMBActive</Value>
</Value>
<Value name="13">
<Value>YMBHosp</Value>
</Value>
</Data>
<DataLocation>^User.DHCCRMYiMiaoBaseD</DataLocation>
<DefaultData>DHCCRMYiMiaoBaseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCCRMYiMiaoBaseD</IdLocation>
<IndexLocation>^User.DHCCRMYiMiaoBaseI</IndexLocation>
<StreamLocation>^User.DHCCRMYiMiaoBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
