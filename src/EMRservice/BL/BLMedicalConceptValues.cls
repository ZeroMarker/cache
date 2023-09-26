Class EMRservice.BL.BLMedicalConceptValues Extends (%RegisteredObject, %XML.Adaptor)
{

Query SELECTALLBYCategoryID(aCategoryID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,CategoryID:%String,Code:%String,DisplayName:%String,Description:%String,AllowInput:%String,FixedStructs:%String,FontName:%String,FontSize:%String,FontWeight:%String,FontStyle:%String,TextColor:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_MEDCONCEPTVALUE_SELECTALLBYCATEGORYID, SqlProc ]
{
	SELECT ID,CategoryID,Code,DisplayName,Description,AllowInput,FixedStructs,FontName,FontSize,FontWeight,FontStyle,TextColor
	FROM EMRmeta.MedicalConceptValues
	WHERE CategoryID = :aCategoryID
}

/// 更新一个医学概念
ClassMethod SelectMedConceptVByID(AMedConceptVByID As %String) As EMRservice.entity.EMedicalConceptValues
{
	set objMedConceptValues=##class(EMRmeta.MedicalConceptValues).%OpenId(AMedConceptVByID)
	quit:(objMedConceptValues="") "0"

	s objEMedConceptValues =  ##Class(EMRservice.entity.EMedicalConceptValues).%New()
	s objEMedConceptValues.ID = AMedConceptVByID
	s objEMedConceptValues.DisplayName = objMedConceptValues.DisplayName
	s objEMedConceptValues.CategoryID=objMedConceptValues.CategoryID
	s objEMedConceptValues.Code=objMedConceptValues.Code
	s objEMedConceptValues.Description=objMedConceptValues.Description
	s objEMedConceptValues.AllowInput=objMedConceptValues.AllowInput
	s objEMedConceptValues.FixedStructs=objMedConceptValues.FixedStructs
	s objEMedConceptValues.FontName=objMedConceptValues.FontName
	s objEMedConceptValues.FontSize=objMedConceptValues.FontSize
	s objEMedConceptValues.FontWeight=objMedConceptValues.FontWeight
	s objEMedConceptValues.FontStyle=objMedConceptValues.FontStyle
	s objEMedConceptValues.TextColor=objMedConceptValues.TextColor
	d objEMedConceptValues.SubItems.CopyFrom(objMedConceptValues.SubItems)

	quit objEMedConceptValues
}

/// 创建一个医学概念
ClassMethod CreateMedConceptV(aEMedConceptValues As EMRservice.entity.EMedicalConceptValues) As %String
{
	set objMedConceptValues=##class(EMRmeta.MedicalConceptValues).%New()
	quit:(objMedConceptValues="") ""
	s objMedConceptValues.DisplayName = aEMedConceptValues.DisplayName
	s objMedConceptValues.CategoryID=aEMedConceptValues.CategoryID
	s objMedConceptValues.Code=aEMedConceptValues.Code
	s objMedConceptValues.Description=aEMedConceptValues.Description
	s objMedConceptValues.AllowInput=aEMedConceptValues.AllowInput
	s objMedConceptValues.FixedStructs=aEMedConceptValues.FixedStructs
	s objMedConceptValues.FontName=aEMedConceptValues.FontName
	s objMedConceptValues.FontSize=aEMedConceptValues.FontSize
	s objMedConceptValues.FontWeight=aEMedConceptValues.FontWeight
	s objMedConceptValues.FontStyle=aEMedConceptValues.FontStyle
	s objMedConceptValues.TextColor=aEMedConceptValues.TextColor

	s sc = objMedConceptValues.%Save()
	if ($$$ISOK(sc))
	{
		quit objMedConceptValues.%Id()
	}
	else
	{
		 quit "-1"
	}
}

/// 删除一个医学概念
ClassMethod DeleteMedConceptVByID(aCargroyId As %String) As %String
{
	q:(aCargroyId ="") "-1"
	s objMedConceptValues = ##Class(EMRmeta.MedicalConceptValues).%OpenId(aCargroyId)
	q:(objMedConceptValues="") "-1"
	s sc = ##class(EMRmeta.MedicalConceptValues).%DeleteId(aCargroyId)
	if ($$$ISOK(sc))
	{
		q (+sc)
	}
	else
	{
		q "-1"
	}
}

/// 更新一个医学概念
ClassMethod UpdateMedConceptV(aEMedConceptValues As EMRservice.entity.EMedicalConceptValues) As %String
{
	set objMedConceptValues=##class(EMRmeta.MedicalConceptValues).%OpenId(aEMedConceptValues.ID)
	quit:(objMedConceptValues="") "0"
	s objMedConceptValues.Code=aEMedConceptValues.Code
	s objMedConceptValues.DisplayName = aEMedConceptValues.DisplayName
	s objMedConceptValues.Description=aEMedConceptValues.Description
	s objMedConceptValues.AllowInput=aEMedConceptValues.AllowInput
	s objMedConceptValues.FixedStructs=aEMedConceptValues.FixedStructs
	s objMedConceptValues.FontName=aEMedConceptValues.FontName
	s objMedConceptValues.FontSize=aEMedConceptValues.FontSize
	s objMedConceptValues.FontWeight=aEMedConceptValues.FontWeight
	s objMedConceptValues.FontStyle=aEMedConceptValues.FontStyle
	s objMedConceptValues.TextColor=aEMedConceptValues.TextColor
	
	d objMedConceptValues.SubItems.CopyFrom(aEMedConceptValues.SubItems)
	
	
	s sc = objMedConceptValues.%Save()
	if ($$$ISOK(sc))
	{

		q (objMedConceptValues.%Id())
	}
	else
	{

		 quit "-1"
	}
}

/// 得到最大code编号
/// d ##Class(EMRservice.BL.BLMedicalConceptValues).selectMaxRowID()
ClassMethod selectMaxRowID() As %String
{
	//s IdexCode=0
	s IdexCode =^DHCEMRM.MedConceptVD 
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

ClassMethod GetSubItemsByID(AMedID As %String) As %Stream
{
	q:(($d(AMedID)=0)||(AMedID="")) ""
 	s objMedicalConcept = ##class(EMRmeta.MedicalConceptValues).%OpenId(AMedID)
    q:(objMedicalConcept="") ""
    QUIT objMedicalConcept.SubItems
}

/// 通过ID获取医学概念xml结构流
/// d ##Class(EMRservice.BL.BLMedicalConceptValues).GetStreamByID("14",.argOutData)
ClassMethod GetStreamByID(AMedConceptID As %String, AMedCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	set objMedConceptValues=##class(EMRmeta.MedicalConceptValues).%OpenId(AMedConceptID)
	quit:(objMedConceptValues="") "0"
	d argOutData.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	d argOutData.Write("<MIConcept>")
	
	s DisplayName = $case(objMedConceptValues.DisplayName,$c(0):"",:$zcvt(objMedConceptValues.DisplayName,"O","UTF8"))
	s Description = $case(objMedConceptValues.Description,$c(0):"",:$zcvt(objMedConceptValues.Description,"O","UTF8"))
	s AllowInput = $case(objMedConceptValues.AllowInput,$c(0):"",:$zcvt(objMedConceptValues.AllowInput,"O","UTF8"))
	s FixedStructs = $case(objMedConceptValues.FixedStructs,$c(0):"",:$zcvt(objMedConceptValues.FixedStructs,"O","UTF8"))
	
	s FontName = $case(objMedConceptValues.FontName,$c(0):"",:$zcvt(objMedConceptValues.FontName,"O","UTF8"))
	s FontSize = $case(objMedConceptValues.FontSize,$c(0):"",:$zcvt(objMedConceptValues.FontSize,"O","UTF8"))
	s FontWeight = $case(objMedConceptValues.FontWeight,$c(0):"",:$zcvt(objMedConceptValues.FontWeight,"O","UTF8"))
	s FontStyle = $case(objMedConceptValues.FontStyle,$c(0):"",:$zcvt(objMedConceptValues.FontStyle,"O","UTF8"))
	s TextColor = $case(objMedConceptValues.TextColor,$c(0):"",:$zcvt(objMedConceptValues.TextColor,"O","UTF8"))
	//使用关联表中维护的编码
	//d argOutData.Write("<Code>"_$zcvt(objMedConceptValues.Code,"O","UTF8")_"</Code>")
	d argOutData.Write("<Code>"_$zcvt(AMedCode,"O","UTF8")_"</Code>")
	d argOutData.Write("<DisplayName>"_DisplayName_"</DisplayName>")
	d argOutData.Write("<Description>"_Description_"</Description>")
	d argOutData.Write("<AllowInput>"_AllowInput_"</AllowInput>")
	d argOutData.Write("<FixedStructs>"_FixedStructs_"</FixedStructs>")
	d argOutData.Write("<Style>")
	d argOutData.Write("<FontName>"_FontName_"</FontName>")
	d argOutData.Write("<FontSize>"_FontSize_"</FontSize>")
	d argOutData.Write("<FontWeight>"_FontWeight_"</FontWeight>")
	d argOutData.Write("<FontStyle>"_FontStyle_"</FontStyle>")
	d argOutData.Write("<TextColor>"_TextColor_"</TextColor>")
	d argOutData.Write("</Style>")
	d argOutData.CopyFrom(objMedConceptValues.SubItems)
	d argOutData.Write("</MIConcept>")
	
	//s AStream=##Class(%FileBinaryStream).%New()
	//s AStream.Filename="d:\xml\123.xml"
	//d AStream.CopyFrom(argOutData)
	//d AStream.SaveStream()
	//d AStream.%Close()
	q "1"
}

}
