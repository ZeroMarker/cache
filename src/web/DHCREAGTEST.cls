Class web.DHCREAGTEST Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//##Class(web.DHCREAGTEST).InitialCTData()

//##Class(web.DHCREAGTEST).InsertModule()

//##Class(web.DHCREAGTEST).ClearCTData()

ClassMethod ClearData() As %String
{
	&sql(delete from lab.DHCREAGStockIn)
	w !,"入库单:",SQLCODE
	&sql(delete from lab.DHCREAGTransfer)
	w !,"领用单:",SQLCODE
	&sql(delete from lab.DHCREAGRequest)
	w !,"请领单:",SQLCODE
	&sql(delete from lab.DHCREAGStock)
	w !,"库存:",SQLCODE
	&sql(delete from lab.DHCREAGTrace)
	w !,"台涨:",SQLCODE
	&sql(delete from lab.DHCREAGStockOut)
	w !,"出库单:",SQLCODE
	k ^lab.DHCREAGStockInItemsI("LotNo")
	&sql(delete from lab.DHCREAGDayStock)
	w !,"日库存:",SQLCODE
	Quit 0
}

ClassMethod ClearCTData() As %String
{
	&sql(delete from lab.DHCCTSupplier)
	w !,"供应商:",SQLCODE
	&sql(delete from lab.DHCCTUnit)
	w !,"单位:",SQLCODE
	&sql(delete from lab.DHCCTPackageSize)
	w !,"包装规格:",SQLCODE
	&sql(delete from lab.DHCCTManufacturer)
	w !,"生产厂商",SQLCODE
	&sql(delete from lab.DHCCTReagent)
	w !,"试剂:",SQLCODE
	&sql(delete from lab.DHCCTDepartment)
	w !,"科室:",SQLCODE
	&sql(delete from lab.DHCCTPosition)
	w !,"存储位置:",SQLCODE
	&sql(delete from lab.DHCCTOperateType)
	w !,"操作类型:",SQLCODE
	&sql(delete from lab.DHCCTGroupType)
	w !,"试剂组别:",SQLCODE
	Quit 0
}

ClassMethod InitialCTData() As %String
{
	///供应商
	Set Seq=1
	&sql(insert into lab.DHCCTSupplier(Code,Name,Visible) Values('S01','北京供应','Y'))
	///单位
	Set Seq=1
	&sql(insert into lab.DHCCTUnit(Code,Name,Visible,Sequence) 
	Values('U01','包','Y',:Seq))
	Set Seq=Seq+1
	&sql(insert into lab.DHCCTUnit(Code,Name,Visible,Sequence) 
	Values('U02','盒','Y',:Seq))
	Set Seq=Seq+1
	&sql(insert into lab.DHCCTUnit(Code,Name,Visible,Sequence) 
	Values('U03','套','Y',:Seq))
	Set Seq=Seq+1
	&sql(insert into lab.DHCCTUnit(Code,Name,Visible,Sequence) 
	Values('U04','ml','Y',:Seq))
	///包装规格
	//Set Seq=1
	//&sql(insert into lab.DHCCTPackageSize(Code,Name,Visible,Sequence)
	//Values('P01','100ml','Y',:Seq))
	//Set Seq=Seq+1
	//&sql(insert into lab.DHCCTPackageSize(Code,Name,Visible,Sequence)
	//Values('P02','1套','Y',:Seq))
	///生产厂商
	Set Seq=1
	&sql(insert into lab.DHCCTManufacturer(Code,Name,Visible,Sequence)
	Values('M011','贝克曼库尔特','Y',:Seq))
	Set Seq=Seq+1
	&sql(insert into lab.DHCCTManufacturer(Code,Name,Visible,Sequence)
	Values('M017','德灵DADA','Y',:Seq))
	///试剂库
	///科室
	Set Seq=1
	&sql(insert into lab.DHCCTDepartment(Code,Name,Visible,Sequence)
	Values('D01','试剂库','Y',:Seq))
	Set Seq=Seq+1
	&sql(insert into lab.DHCCTDepartment(Code,Name,Visible,Sequence)
	Values('D02','生化','Y',:Seq))
	Set Seq=Seq+1
	&sql(insert into lab.DHCCTDepartment(Code,Name,Visible,Sequence)
	Values('D03','临检','Y',:Seq))
	Set Seq=Seq+1
	&sql(insert into lab.DHCCTDepartment(Code,Name,Visible,Sequence)
	Values('D04','免疫','Y',:Seq))
	///存储位置
	&sql(insert into lab.DHCCTPosition(Code,Name,Visible,Sequence)
	Values('P01','1号冰箱','Y',:Seq))
	///操作类型
	Set Seq=1
	&sql(insert into lab.DHCCTOperateType(Code,Name,Type,Visible,Sequence) 
	Values('1','入库','I','Y',:Seq))
	Set Seq=Seq+1
	&sql(insert into lab.DHCCTOperateType(Code,Name,Type,Visible,Sequence) 
	Values('2','出库','O','Y',:Seq))
	Set Seq=Seq+1
	&sql(insert into lab.DHCCTOperateType(Code,Name,Type,Visible,Sequence) 
	Values('3','试剂领用(库存转移)','T','Y',:Seq))
	Set Seq=Seq+1
	&sql(insert into lab.DHCCTOperateType(Code,Name,Type,Visible,Sequence) 
	Values('4','退货','C','Y',:Seq))
	Set Seq=Seq+1
	&sql(insert into lab.DHCCTOperateType(Code,Name,Type,Visible,Sequence) 
	Values('5','报损','D','Y',:Seq))
	Set Seq=Seq+1
	&sql(insert into lab.DHCCTOperateType(Code,Name,Type,Visible,Sequence) 
	Values('7','试剂领用(库存不转移)','T','Y',:Seq))
	Set Seq=Seq+1
	&sql(insert into lab.DHCCTOperateType(Code,Name,Type,Visible,Sequence) 
	Values('8','自动消耗','O','Y',:Seq))	
    ///试剂组别
    Set Seq=1
    &sql(insert into lab.DHCCTGroupType(Code,Name,Visible,Sequence)
    Values('1','生化','Y',:Seq))
    Set Seq=Seq+1
    &sql(insert into lab.DHCCTGroupType(Code,Name,Visible,Sequence)
    Values('2','免疫','Y',:Seq))
    Set Seq=Seq+1
    &sql(insert into lab.DHCCTGroupType(Code,Name,Visible,Sequence)
    Values('3','临检','Y',:Seq))
    Set Seq=Seq+1
    &sql(insert into lab.DHCCTGroupType(Code,Name,Visible,Sequence)
    Values('4','微生物','Y',:Seq))
    Set Seq=Seq+1
    &sql(insert into lab.DHCCTGroupType(Code,Name,Visible,Sequence)
    Values('5','质控品','Y',:Seq))
    Set Seq=Seq+1
    &sql(insert into lab.DHCCTGroupType(Code,Name,Visible,Sequence)
    Values('6','定标液','Y',:Seq))
    Set Seq=Seq+1
    &sql(insert into lab.DHCCTGroupType(Code,Name,Visible,Sequence)
    Values('7','一次性耗材','Y',:Seq))
    Set Seq=Seq+1
    &sql(insert into lab.DHCCTGroupType(Code,Name,Visible,Sequence)
    Values('8','其它','Y',:Seq))
	Quit 0
}

ClassMethod InsertModule() As %String
{
	//初始化用户科室
	s user="trak"
	s id="" f  s id=$o(^lab.DHCCTDepartmentD(id)) q:id=""  d
	.&sql(insert into lab.DHCCTUserDepartment(UserDR,DepartmentDR) values(:user,:id))
	//	
	s seq="" f  s seq=$o(^DHCREAGMODULE(seq)) q:seq=""  d
	.s str=^(seq)
	.s code=$p(str,"^",1)
	.s name=$p(str,"^",2)
	.i '$l(code) q
	.d init(code)
	.i $d(^lab.DHCCTSYSModule(code)) q
	.&sql(insert into lab.DHCCTSYSModule(Code,Name) Values(:code,:name))
	.//
	.w !,name,":",SQLCODE
	q 0
init(mdl)
  s dep="" f  s dep=$o(^lab.DHCCTUserDepartmentI("MasterIndex","trak",dep)) q:dep=""  d
  .s id="" f  s id=$o(^lab.DHCCTUserDepartmentI("MasterIndex","trak",dep,id)) q:id=""  d
  ..s subid=$o(^lab.DHCCTUserDepartRoleI("MasterIndex",mdl,dep,""))
  ..i $l(subid) q
  ..&sql(insert into lab.DHCCTUserDepartRole(ParRef,ModuleDR) values(:id,:mdl))
  s dep="" f  s dep=$o(^lab.DHCCTUserDepartmentI("MasterIndex","demo",dep)) q:dep=""  d
  .s id="" f  s id=$o(^lab.DHCCTUserDepartmentI("MasterIndex","demo",dep,id)) q:id=""  d
  ..s subid=$o(^lab.DHCCTUserDepartRoleI("MasterIndex",mdl,dep,""))
  ..i $l(subid) q
  ..&sql(insert into lab.DHCCTUserDepartRole(ParRef,ModuleDR) values(:id,:mdl))
  q
}

}
