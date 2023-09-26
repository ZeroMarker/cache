Class web.DHCEQ.EM.BUSOpenCheckList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQ.EM.BUSOpenCheckList).GetOneOpenCheckList("",98)
/// Modified By QW20200108 BUG:QW0035 增加OCRRowID主单id
ClassMethod GetOneOpenCheckList(RowID As %Library.String = "", OCRRowID As %Library.String = "")
{
	s $ZT="ERRORGetOneOpenCheckList"
	if RowID="" s RowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest", OCRRowID, 0)) ///Add By QW20200108 BUG:QW0035根据验收主单id获取明细id
	s Obj=##Class(User.DHCEQOpenCheckList).%OpenId(RowID)
	s DataInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(Obj)
	d DataInfo.%Set("OCLEquipTypeDR_ETDesc",Obj.OCLEquipTypeDR.ETDesc)
	d DataInfo.%Set("OCLModelDR_MDesc",Obj.OCLModelDR.MDesc)
	d DataInfo.%Set("OCLEquiCatDR_ECDesc",Obj.OCLEquiCatDR.ECDesc)
	d DataInfo.%Set("OCLUnitDR_UOMDesc",##class(web.DHCEQCommon).GetTrakNameByID("uom",Obj.OCLUnitDR))  //Modify by WL 2019-10-31 1072609 错误参数修正
	///add by ZY0215 2020-04-03
	d DataInfo.%Set("OCLManuFactoryDR_MDesc",Obj.OCLManuFactoryDR.VName)		//modified by CZF0103 20200408
	//s OCLManuFactoryDR=Obj.OCLManuFactoryDRGetObjectId()
	//d DataInfo.%Set("OCLManuFactoryDR",OCLManuFactoryDR)
	//d DataInfo.%Set("OCLManuFactoryDR_MDesc",##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",Obj.OCLManuFactoryDR))	//modified by CZF0093 2020-03-17
	d DataInfo.%Set("OCLUseLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",Obj.OCLUseLocDR))   ///Modified By QW20200119 BUG:BUG:QW0039增加输出
	///Modified By QW20200108 BUG:QW0035增加输出 benign
	d DataInfo.%Set("OCLDepreMethodDR_DMDesc",Obj.OCLDepreMethodDR.DMDesc)
	d DataInfo.%Set("OCLItemDR_MIDesc",Obj.OCLItemDR.MIDesc)
	//Add By QW20200108 BUG:QW0035 Begin 来源
	s OCLSourceTypeDesc=$case(Obj.OCLSourceType,"0":"设备项","1":"采购合同","3":"计划单","4":"协议合同","5":"投放合同")
	d DataInfo.%Set("OCLSourceTypeDesc",OCLSourceTypeDesc)
	//Add By QW20200108 BUG:QW0035 End 来源
	s OCLHOld5EDesc=""
	i Obj.OCLHold5'=""
	{
		s OCLHOld5EDesc=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",Obj.OCLHold5)),"^",2)
	}
	d DataInfo.%Set("OCLHold5_EDesc",OCLHOld5EDesc)
	s LeaveFactoryIDs = ^DHCEQOpenCheckList(RowID,"EX")
	Set FileNo = ^DHCEQOpenCheckList(RowID,"FileNo")
	d DataInfo.%Set("OCLLeaveFactoryIDs",LeaveFactoryIDs)
	d DataInfo.%Set("OCLFileNos",FileNo)
	///Modified By QW20200108 BUG:QW0035增加输出 end
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,DataInfo)
ERRORGetOneOpenCheckList
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

Storage Default
{
<Data name="BUSOpenCheckListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQ.EM.BUSOpenCheckListD</DataLocation>
<DefaultData>BUSOpenCheckListDefaultData</DefaultData>
<IdLocation>^web.DHCEQ.EM.BUSOpenCheckListD</IdLocation>
<IndexLocation>^web.DHCEQ.EM.BUSOpenCheckListI</IndexLocation>
<StreamLocation>^web.DHCEQ.EM.BUSOpenCheckListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
