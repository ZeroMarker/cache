/// Description:工作量分配
/// Creator:wangguoying
Class User.DHCPEWorkDistribution Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_WorkDistribution ]
{

Parameter ClassName = "User.DHCPEWorkDistribution";

/// 就诊记录
Property WDPAAdmDR As User.PAAdm [ Required, SqlColumnNumber = 2, SqlFieldName = WD_PAAdm_DR ];

/// 分配类型 RR：结果录入  CC：粘贴核对 AR：报告审核  PR：报告打印 
Property WDType As %String(COLLATION = "AlphaUp") [ Required, SqlColumnNumber = 3, SqlFieldName = WD_Type ];

/// 接收任务人员
Property WDReceiverDR As User.SSUser [ Required, SqlColumnNumber = 4, SqlFieldName = WD_Receiver_DR ];

/// 完成标记 0：未完成，1：已完成
Property WDFinish As %String(VALUELIST = ",0,1") [ InitialExpression = "0", Required, SqlColumnNumber = 5, SqlFieldName = WD_Finish ];

/// 更新人
Property WDUpdateUserDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = WD_UpdateUser_DR ];

/// 操作日期
Property WDUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = WD_UpdateDate ];

/// 更新时间
Property WDUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = WD_UpdateTime ];

/// 完成日期
Property WDFinishDate As %Date [ SqlColumnNumber = 9, SqlFieldName = WD_FinishDate ];

/// 完成时间
Property WDFinishTime As %Time [ SqlColumnNumber = 10, SqlFieldName = WD_FinishTime ];

/// 医生类型 W：全天医生  H：半天医生
Property WDDocType As %String(VALUELIST = ",W,H") [ SqlColumnNumber = 11, SqlFieldName = WD_DocType ];

/// 唯一索引  有没有可能一个就诊 一个类型 分配给多个人？
Index TypePAADMIndex On (WDType, WDPAAdmDR, WDReceiverDR) [ Unique ];

Index TypeReceiverDRIndex On (WDType, WDReceiverDR, WDPAAdmDR);

Storage Default
{
<Data name="DHCPEWorkDistributionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WDPAAdmDR</Value>
</Value>
<Value name="3">
<Value>WDType</Value>
</Value>
<Value name="4">
<Value>WDReceiverDR</Value>
</Value>
<Value name="5">
<Value>WDFinish</Value>
</Value>
<Value name="6">
<Value>WDUpdateUserDR</Value>
</Value>
<Value name="7">
<Value>WDUpdateDate</Value>
</Value>
<Value name="8">
<Value>WDUpdateTime</Value>
</Value>
<Value name="9">
<Value>WDFinishDate</Value>
</Value>
<Value name="10">
<Value>WDFinishTime</Value>
</Value>
<Value name="11">
<Value>WDDocType</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEWorkDistributionD</DataLocation>
<DefaultData>DHCPEWorkDistributionDefaultData</DefaultData>
<IdLocation>^User.DHCPEWorkDistributionD</IdLocation>
<IndexLocation>^User.DHCPEWorkDistributionI</IndexLocation>
<StreamLocation>^User.DHCPEWorkDistributionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
