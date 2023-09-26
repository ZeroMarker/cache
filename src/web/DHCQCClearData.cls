/// Creator：      DaiYi
/// CreatDate：    20141209
/// Description:： 清楚数据库数据
/// Table：        所有业务表数据
/// Input：        SQLCODE
/// Output：       无
/// Return：       0
/// Others：
Class web.DHCQCClearData Extends %Persistent
{

/// d ##class(web.DHCQCClearData).Clear()	
ClassMethod Clear() As %String
{
	//累计月计算数据
	&sql(delete from lab.DHCQC_AccTotal)
	w !,"累计月计算数据"_SQLCODE
	&sql(delete from lab.DHCQC_ItemAmend)
	w !,"清除校正液数据 "_SQLCODE
	//清除失控处理数据
	//&sql(delete from lab.DHC_IQC_RuleAppraise)
	//w !,SQLCODE
	k ^DHCQCRULEAP
	//清除质控评价数据
	//&sql(delete from lab.DHCQC_Appraise)
	//w !,SQLCODE
	k ^DHCQCAPPR,^DHCQCAPPRi
	//清除主业务表数据
	//&sql(delete from lab.DHCQC_ItemValue)
	//w !,SQLCODE
	k ^DHCQCIV,^DHCQCIVi,^DHCQCIVTCi
	//清除月质控汇总
	//&sql(delete from lab.DHCQC_TestCodeByMouth)
	//w !,SQLCODE
	k ^DHCQCTCM
	//清除中间表数据
	//&sql(delete from lab.DHCQC_TmpResult)
	//w !,SQLCODE
	k ^DHCQCTR,^DHCQCTRi
	//清除权限表数据
	//&sql(delete from lab.DHCQC_UserDeptRole)
	//w !,SQLCODE
	//清除仪器连接标识数据
	//&sql(delete from lab.DHCQC_MachineQC)
	k ^DHCQCMQ
	//清除质控物规则
	&sql(delete from lab.DHCQCMat_Rul)
	w !,SQLCODE
	//清除激活项目数据
	&sql(delete from lab.DHCQC_TestCode)
	w !,SQLCODE
	//清除批次数据
	&sql(delete from lab.DHCQC_Lot)
	w !,SQLCODE
	//清除批次数据
	&sql(delete from lab.DHCQC_Material)
	w !,SQLCODE
	//清除仪器结果汇总数据
	&sql(delete from lab.DHCQC_MachineTCTotal)
	w !,SQLCODE
	//清除校正液数据 
	Quit SQLCODE
}

Storage Default
{
<Data name="DHCQCClearDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCClearDataD</DataLocation>
<DefaultData>DHCQCClearDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCClearDataD</IdLocation>
<IndexLocation>^web.DHCQCClearDataI</IndexLocation>
<StreamLocation>^web.DHCQCClearDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
