Class web.DHCREAGDataClear Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：      huhm
/// CreatDate：    20100917
/// Description:： 清除业务数据
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod ClearData() As %String
{
	w !,"警告!!清除试剂库的业务数据.是否继续?(Y/N)"
	r *R
	s val=$zcvt($c(R),"U")
	i R=13 s val="N"
	i val="N" w !,"已取消操作" q 100
	&sql(delete from lab.DHCREAGStockIn)
	w !,"1.入库单:",SQLCODE
	&sql(delete from lab.DHCREAGTransfer)
	w !,"2.领用单:",SQLCODE
	&sql(delete from lab.DHCREAGStock)
	w !,"3.库存:",SQLCODE
	&sql(delete from lab.DHCREAGStockOut)
	w !,"4.出库单:",SQLCODE
	&sql(delete from lab.DHCREAGRequest)
	w !,"5.请领单:",SQLCODE	
	&sql(delete from lab.DHCREAGTrace)
	w !,"6.台帐:",SQLCODE
	&sql(delete from lab.DHCREAGDayStock)
	w !,"7.日库存:",SQLCODE
	k ^lab.DHCREAG
	Quit 0
}

/// Creator：      huhm
/// CreatDate：    20100917
/// Description:： 清除基础数据
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod ClearCTData() As %String
{
	&sql(delete from lab.DHCCTSupplier)
	w !,"1.供应商:",SQLCODE
	&sql(delete from lab.DHCCTUnit)
	w !,"2.单位:",SQLCODE
	&sql(delete from lab.DHCCTPackageSize)
	w !,"3.规格:",SQLCODE
	&sql(delete from lab.DHCCTManufacturer)
	w !,"4.厂商",SQLCODE
	&sql(delete from lab.DHCCTReagent)
	w !,"5.试剂:",SQLCODE
	&sql(delete from lab.DHCCTDepartment)
	w !,"6.科室:",SQLCODE
	&sql(delete from lab.DHCCTPosition)
	w !,"7.存储位置:",SQLCODE
	&sql(delete from lab.DHCCTOperateType)
	w !,"8.操作类型:",SQLCODE
	&sql(delete from lab.DHCCTGroupType)
	w !,"9.组别:",SQLCODE
	&sql(delete from lab.DHCCTReason)
	w !,"10.处理原因:",SQLCODE
	&sql(delete from lab.DHCCTMachine)
	w !,"11.仪器:",SQLCODE
	&sql(delete from lab.DHCCTUser)
	w !,"12.用户:",SQLCODE	
	Quit 0
}

}
