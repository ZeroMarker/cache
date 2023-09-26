/// 科室常用临床路径
Class User.DHCMRCDeptClinicalPathWays Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = DCPW_RowId, SqlTableName = DHC_MRC_DeptClinicalPathWays ]
{

/// 临床路径
Property DCPWCPWDR As DHCMRCClinPathWaysDic [ SqlColumnNumber = 3, SqlFieldName = DCPW_CPW_DR ];

//Modified By LiYang 2010-12-15 新的结构中，科室常用临床路径应该指向临床路径字典

/// 科室
/// Table:CTLoc
Property DCPWCTLOCDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DCPW_CTLOC_DR ];

/// 科室建索引
Index IndexLoc On DCPWCTLOCDR;

/// 路径/科室建索引
Index IndexCPW On (DCPWCPWDR, DCPWCTLOCDR);

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DCPWCPWDR</Value>
</Value>
<Value name="3">
<Value>DCPWCTLOCDR</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("DEPCPW")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("DEPCPW")</IdLocation>
<IndexLocation>^DHCMRCi("DEPCPW",0)</IndexLocation>
<SqlRowIdName>DCPW_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRCDeptCl98ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
