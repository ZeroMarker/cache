/// 名称: 药品用法接收科室导入用类
/// 描述: 用于药品用法接收科室导入
/// 编写者：基础数据平台组-钟荣枫
/// 编写日期: 2020-04-15
Class web.BDPExt.DHCPHCInstrRecLocBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：钟荣枫
/// CreatDate: 2020-4-10
/// Description：新装时删除所有药品用法接收科室数据
/// Table：User.DHCPHCInstrRecLoc 药品用法接收科室
/// Input：
/// Return：
/// w ##class(web.BDPExt.DHCPHCInstrRecLocBLL).ClearData()
ClassMethod ClearData() As %String
{
	s ParRef=0
	for
	{
		s ParRef=$o(^PHCIN(ParRef)) q:ParRef=""
		s ChildSub=0
		for {
			s ChildSub=$o(^PHCIN(ParRef,"RecLoc",ChildSub))
			q:ChildSub=""
			s RowID=ParRef_"||"_ChildSub
			s flag=$d(^PHCIN(ParRef,"RecLoc",ChildSub))
			if (flag>0)	//数据存在
			{
				d ##class(web.DHCBL.CT.DHCPHCInstrRecLoc).DeleteData(RowID)
			}
		}
	}
}

/// Creator：钟荣枫
/// CreatDate: 2020-04-03
/// Description：保存修改药品用法接收科室的内容 导入用
/// Table：User.DHCPHCInstrRecLoc 药品用法接收科室
/// Input：web.BDPExt.DHCPHCInstrRecLocEntity 实体类
/// Return：成功返回success:'true'和新增的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.BDPExt.DHCPHCInstrRecLocBLL).SaveEntity()
ClassMethod SaveEntity(Ceobj As web.BDPExt.DHCPHCInstrRecLocEntity) As %String
{
	n (%session,Ceobj)
	s ImportResult=""
	Ts			
				
	///药品用法
	//s ParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_PHCInstrRecLoc",Ceobj.PHCINCode)	
	s ParRef=$o(^PHCIN(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.PHCINCode),0))
	
	s eobj =##class(web.Entity.CT.DHCPHCInstrRecLoc).%New()
	
	s eobj.InstrRecLocParRef=ParRef
	s eobj.InstrRecLoc = Ceobj.InstrRecLoc 
	s eobj.InstrOrdDep = Ceobj.InstrOrdDep
	s eobj.InstrDefault = Ceobj.InstrDefault
	s eobj.InstrOrdSubCat = Ceobj.InstrOrdSubCat 
	s eobj.InstrOrdPrior = Ceobj.InstrOrdPrior 
	s InstrTimeRange=Ceobj.InstrTimeRangeFrom_"~"_Ceobj.InstrTimeRangeTo
	s eobj.InstrTimeRange = InstrTimeRange
	s eobj.InstrHospitalDR = Ceobj.InstrHospitalDR 
	
	s SaveResult=##class(web.DHCBL.CT.DHCPHCInstrRecLoc).SaveEntity(eobj)
	s RowID=##class(web.BDPExt.FunLib).GetResultRowId(SaveResult)
	if (RowID="")
	{
		s ImportResult="药品用法接收科室:"_SaveResult			
	}
	
	if (ImportResult="")
	{
		Tc
		s Result="{success:'true',id:'"_RowID_"'}" 
	}
	else
	{
		Tro
		s Result=ImportResult
	
	}
	q Result
}

}
