/// Desc:       诊断部位字典逻辑类
/// Creator:    Candy
/// CreateDate: 2017-9-8
Class EMRservice.BL.BLDicDiagnosPosition Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       取部位数据
/// Creator:    Candy
/// CreateDate: 2017-9-8
/// Debug:      w ##Class(EMRservice.BL.BLDicDiagnosPosition).GetData()
ClassMethod GetData() As %String
{
	s result = ""
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.DicDiagnosPositionI("IdxSequence",seq))
		q:(seq = "")
		s rowId = $o(^DHCEMRM.DicDiagnosPositionI("IdxSequence",seq,""))
		continue:(rowId = "")
		s obj = ##Class(EMRmeta.DicDiagnosPosition).%OpenId(rowId)
		continue:(obj = "")
		continue:(obj.IsActive = "N")
		s code = obj.Code
		s desc = obj.Description
		s location = obj.Location	
		s:(result '= "") result = result_","
		s result = result_"{"
		s result = result_"""RowId"":"""_rowId_""""
		s result = result_",""Code"":"""_code_""""
		s result = result_",""Desc"":"""_desc_""""
		s result = result_"}"
	}
	q "["_result_"]"
}

/// Desc:       初始化数据
/// Creator:    Candy
/// CreateDate: 2017-9-8
ClassMethod SetData(ACode As %String, ADesc As %String, ALocation As %String, ASequence As %String) As %String
{
	s result = ""
	q:(ACode = "") result
	s id = $O(^DHCEMRM.DicDiagnosPositionI("IdxCode"," "_$zcvt(ACode,"U"),""))
	if (id = "")
	{
		s obj = ##Class(EMRmeta.DicDiagnosPosition).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.DicDiagnosPosition).%OpenId(id)
	}
	s obj.Code = ACode
	s obj.Description = ADesc
	s obj.Location = ALocation
	s obj.Sequence = ASequence
	d obj.%Save()
}

/// Desc: d ##Class(EMRservice.BL.BLDicDiagnosPosition).InitData()
ClassMethod InitData()
{
	d ..SetData("Top","上","above",1)
	d ..SetData("Middle","中","above",2)
	d ..SetData("Down","下","above",3)
	d ..SetData("Left","左","above",4)
	d ..SetData("Right","右","above",5)
	d ..SetData("Dobule","双","above",6)
	d ..SetData("Above","前","above",7)
	d ..SetData("Behind","后","above",8)
	d ..SetData("Postoperation","术后","above",9)
}

}
