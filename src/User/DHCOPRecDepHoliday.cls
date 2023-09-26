/// 门急诊假日接收科室设置
/// 仅设置日期,时间假日数据,对于周末是否假日走原来的节点配置数据
/// 是否在插入和删除的时候同步更新DHC_OPRegFestivalSet数据,待定,暂不处理
Class User.DHCOPRecDepHoliday Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_OPRecDepHoliday ]
{

Index HSDateIndex On RDHStartDate As Exact;

/// 假日开始日期
Property RDHStartDate As %Date [ Required, SqlColumnNumber = 2, SqlFieldName = RDH_StartDate ];

/// 假日开始时间
Property RDHStartTime As %Time [ SqlColumnNumber = 3, SqlFieldName = RDH_StartTime ];

/// 假日结束日期
Property RDHEndDate As %Date [ Required, SqlColumnNumber = 4, SqlFieldName = RDH_EndDate ];

/// 假日结束时间
Property RDHEndTime As %Time [ SqlColumnNumber = 5, SqlFieldName = RDH_EndTime ];

/// 创建人
Property RDHCreateUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = RDH_CreateUser_DR ];

/// 创建日期
Property RDHCreateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = RDH_CreateDate ];

/// 创建时间
Property RDHCreateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = RDH_CreateTime ];

/// 是否可用标识
Property RDHIsActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = RDH_IsActiveFlag ];

/// 院区
Property RDHHospDR As CTHospital [ SqlColumnNumber = 10, SqlFieldName = RDH_Hosp_DR ];

Storage Default
{
<Data name="DHCOPRecDepHolidayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RDHCreateUserDR</Value>
</Value>
<Value name="3">
<Value>RDHCreateDate</Value>
</Value>
<Value name="4">
<Value>RDHCreateTime</Value>
</Value>
<Value name="5">
<Value>RDHIsActiveFlag</Value>
</Value>
<Value name="6">
<Value>RDHStartDate</Value>
</Value>
<Value name="7">
<Value>RDHStartTime</Value>
</Value>
<Value name="8">
<Value>RDHEndDate</Value>
</Value>
<Value name="9">
<Value>RDHEndTime</Value>
</Value>
<Value name="10">
<Value>RDHHospDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCOPRecDepHolidayD</DataLocation>
<DefaultData>DHCOPRecDepHolidayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCOPRecDepHolidayD</IdLocation>
<IndexLocation>^User.DHCOPRecDepHolidayI</IndexLocation>
<StreamLocation>^User.DHCOPRecDepHolidayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
