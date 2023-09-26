/// 科室分组配置
Class User.DHCPELocGrpConfig Extends (%Persistent, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_LocGrpConfig ]
{

Parameter ClassName = "User.DHCPELocGrpConfig";

/// 科室(健康体检中心) 指向CT_Loc
Property LGLocDR As %String [ Required, SqlFieldName = LG_LocDR ];

/// 科室组默认科室 指向CT_Loc
Property LGLocGrpDR As %String [ Required, SqlFieldName = LG_LocGrpDR ];

/// 科室别名
Property LGLocDesc2 As %String [ SqlFieldName = LG_LocDesc2 ];

/// 激活
Property LGActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = LG_Active ];

/// 更新日期
Property LGUpdateDate As %Date [ SqlFieldName = LG_UpdateDate ];

/// 更新时间
Property LGUpdateTime As %Time [ SqlFieldName = LG_UpdateTime ];

/// 更新人 指向SS_User
Property LGUpdateUserDR As %String [ SqlFieldName = LG_UpdateUserDR ];

/// 备注说明
Property LGRemark As %String(MAXLEN = 500) [ SqlFieldName = LG_Remark ];

/// 科室(健康体检中心) 索引
Index IdxOfLoc On LGLocDR [ Unique ];

/// 科室组索引 IdxOfLocGrp
Index IdxOfLocGrp On (LGLocGrpDR, LGLocDR);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LGLocDR</Value>
</Value>
<Value name="3">
<Value>LGLocGrpDR</Value>
</Value>
<Value name="4">
<Value>LGLocDesc2</Value>
</Value>
<Value name="5">
<Value>LGActive</Value>
</Value>
<Value name="6">
<Value>LGUpdateDate</Value>
</Value>
<Value name="7">
<Value>LGUpdateTime</Value>
</Value>
<Value name="8">
<Value>LGUpdateUserDR</Value>
</Value>
<Value name="9">
<Value>LGRemark</Value>
</Value>
</Data>
<DataLocation>^CF.PE.LocGrpConfigD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.LocGrpConfigD</IdLocation>
<IndexLocation>^CF.PE.LocGrpConfigI</IndexLocation>
<StreamLocation>^User.DHCPELocGrpConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
