/// 名称:	EMR.DOC.BL.ScattetData
/// 描述:	实例数据打散业务实现
/// 编写者：	yejian
/// 编写日期: 	2021-7-29
/// 产品组：电子病历产品组
Class EMR.DOC.BL.ScattetData Extends EMR.DOC.COM.ActionBase
{

/// Desc:       数据打散
/// Creator:    yejian
/// CreateDate: 2021-8-5
/// Input:      aDocumentID 文档ID,
/// 			aJsonData 文档json数据
/// OutPut:     成功 1,	失败 -1^失败信息
/// 			argOutData json数据
/// Output:     result 1成功,-1失败     
/// Debug: d ##Class(EMR.DOC.BL.ScattetData).SaveScatterData("36","")
ClassMethod SaveScatterData(aDocumentID As %String, aJsonData As %DynamicAbstractObject = "") As %String
{
	s $zt = "Error"
	s strRes = "-1"	
	if (aJsonData="")
	{
		s obj = ##Class(%GlobalBinaryStream).%New()
		s outStream = ##Class(%GlobalBinaryStream).%New()
		s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
		//数据解压缩
		s temStream = ##class(EMR.DOC.COM.Parser.StreamData).DeCompressStream(objDocument.DocumentStream.DocumentData)
		d obj.CopyFrom(temStream)	
		d obj.Rewind()
		while (obj.AtEnd = 0)
		{
			s tmpOut = obj.Read(30000)
			s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
			d outStream.Write(tmpUtf8)
	  	} 
		s aJsonData = ##class(%DynamicAbstractObject).%FromJSON(outStream)
	}
    s ScatterData = ##Class(EMR.DOC.DTO.NIScatterData).%New()
    //json反序列化为对象
    d ScatterData.XMLDeserialize(aJsonData)
    //通过对象更新打散数据
    s strRes = ##Class(EMR.DOC.BL.ScattetData).Save(ScatterData,aDocumentID)
    k ScatterData
    q strRes
Error
   q "-1^"_aDocumentID_$zerror
}

/// Desc:       保存打散数据
/// Creator:    yejian
/// CreateDate: 2021-8-5
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
/// Debug: d ##Class(EMR.DOC.BL.ScattetData).BuildIndexData()
ClassMethod Save(aScatterData As EMR.DOC.DTO.NIScatterData, aDocumentID As %String) As %String
{
	s $zt = "Error"
	s strRes = 1
	q:(aDocumentID="") "-1^实例ID不能为空"
	s reSction = ##Class(EMR.DOC.BL.IStructSection).Save(aScatterData,aDocumentID)
	q:(reSction [ "-1") reSction
	s reSimple = ##Class(EMR.DOC.BL.IStructSimple).Save(aScatterData,aDocumentID)
	q:(reSimple[ "-1") reSimple 
	s reMacro = ##Class(EMR.DOC.BL.IStructMacro).Save(aScatterData,aDocumentID)
	q:(reMacro[ "-1") reMacro 
	s reMacroSim = ##Class(EMR.DOC.BL.IStructMacroSimple).Save(aScatterData,aDocumentID)
	q:(reMacroSim[ "-1") reMacroSim 
	s reTooth = ##Class(EMR.DOC.BL.IStructTooth).Save(aScatterData,aDocumentID)
	q:(reTooth[ "-1") reTooth 
	s reToothPosition = ##Class(EMR.DOC.BL.IStructToothPosition).Save(aScatterData,aDocumentID)
	q:(reToothPosition[ "-1") reToothPosition 
	s reToothSurface = ##Class(EMR.DOC.BL.IStructToothSurface).Save(aScatterData,aDocumentID)
	q:(reToothSurface[ "-1") reToothSurface 
	q strRes
Error
    q "-1^"_aDocumentID_$zerror
}

/// Desc:       解析打散的数据
/// Creator:    yejian
/// CreateDate: 2021-8-5
/// Input:      AScatterData 反序列化的打散Data
///             AInstanceID 实例数据ID
///             AKey 唯一识别码 
/// Debug: d ##Class(EMR.DOC.BL.ScattetData).TestData("36","")
ClassMethod TestData(aDocumentID As %DynamicAbstractObject, aJsonData As %DynamicAbstractObject = "") As %String
{
	s $zt = "Error"
	s strRes = "1"	
	if (aJsonData="")
	{
		s obj = ##Class(%GlobalBinaryStream).%New()
		s outStream = ##Class(%GlobalBinaryStream).%New()
		s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
		d obj.CopyFrom(objDocument.DocumentStream.DocumentData)	
		d obj.Rewind()
		while (obj.AtEnd = 0)
		{
			s tmpOut = obj.Read(30000)
			s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
			d outStream.Write(tmpUtf8)
	  	} 
		s aJsonData = ##class(%DynamicAbstractObject).%FromJSON(outStream)
	}
    s ScatterData = ##Class(EMR.DOC.DTO.NIScatterData).%New()
    //json反序列化为对象
    d ScatterData.XMLDeserialize(aJsonData)
 
    d ##Class(EMR.DOC.BL.ScattetData).BuildIndexData(ScatterData,aDocumentID)
    //通过对象更新打散数据
    ;s strRes = ##Class(EMR.DOC.BL.ScattetData).Save(ScatterData,aDocumentID)
    
    k ScatterData
    q strRes
Error
   q "-1^"_aDocumentID_$zerror
}

/// Desc:       测试查看打散的数据
/// Creator:    yejian
/// CreateDate: 2021-8-5
/// Input:      AScatterData 反序列化的打散Data
///             AInstanceID 实例数据ID
///             AKey 唯一识别码 
/// Debug: d ##Class(EMR.DOC.BL.ScattetData).BuildIndexData()
ClassMethod BuildIndexData(AScatterData As EMR.DOC.DTO.NIScatterData, AInstanceID As %String)
{
	s AKey = $i(^CacheTempEMRScatterData)
    k ^CacheTempEMRScatterData(AKey)
    k ^CacheTempEMRScatterData
	s count = AScatterData.DataList.Sections.Count()
	for i=1:1:count
	{
		s sctionCode = $zcvt(AScatterData.DataList.Sections.GetAt(i).Code,"U")
		s ^CacheTempEMRScatterData(AKey,"tmpNewSection",AInstanceID,sctionCode)= AScatterData.DataList.Sections.GetAt(i).Text
	}
	s count = AScatterData.DataList.Paragraph.Count()
	for i=1:1:count
	{
		s paragraphCode = $zcvt(AScatterData.DataList.Paragraph.GetAt(i).Code,"U")
		s:(paragraphCode ="") paragraphCode=i
		s ^CacheTempEMRScatterData(AKey,"tmpNewParagraph",AInstanceID,paragraphCode)= AScatterData.DataList.Paragraph.GetAt(i).Text
	}
	s count = AScatterData.DataList.Macros.Count()
	for i=1:1:count
	{
		s macroCode = $zcvt(AScatterData.DataList.Macros.GetAt(i).Code,"U")
		s:(macroCode ="") macroCode=i
		s ^CacheTempEMRScatterData(AKey,"tmpNewMacro",AInstanceID,macroCode)= AScatterData.DataList.Macros.GetAt(i).Text
	}
	s ccount = AScatterData.DataList.Simples.Count()
	for j=1:1:ccount
	{
		s simpleCode = $zcvt(AScatterData.DataList.Simples.GetAt(j).Code,"U")
		s:(simpleCode ="") simpleCode=" "
		s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,simpleCode,"SectionCode") = AScatterData.DataList.Simples.GetAt(j).SectionCode
		s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,simpleCode,"ValueCode") = AScatterData.DataList.Simples.GetAt(j).ValueCode
		s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,simpleCode,"DataValue") = AScatterData.DataList.Simples.GetAt(j).DataValue
		s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,simpleCode,"DataRef") = AScatterData.DataList.Simples.GetAt(j).DataRef
		s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,simpleCode,"Separator") = AScatterData.DataList.Simples.GetAt(j).Separator
		s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,simpleCode,"Type") = AScatterData.DataList.Simples.GetAt(j).Type
		s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,simpleCode,"KBNodeID") = AScatterData.DataList.Simples.GetAt(j).KBNodeID
		s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,simpleCode,"SourceCode") = AScatterData.DataList.Simples.GetAt(j).SourceCode
		s ^CacheTempEMRScatterData(AKey,"tmpNewSimple",AInstanceID,simpleCode,"SourceCCode") = AScatterData.DataList.Simples.GetAt(j).SourceCCode
	}
}

}
