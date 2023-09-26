/// Descript:	病历文档目录信息
/// Creator:    bianshuai
/// CreatDate:  2016-09-26
Class web.DHCCM.EMRservice.BL.BLDirectoryInformation Extends %RegisteredObject
{

/// Desc:       存储文档目录信息
/// Creator:    Candy
/// CreatDate:  2014-02-18
/// Input: 	    AInstanceID 实例数据id
///             ADirInfoData 目录xml
/// OutPut:     result  -1 失败  1 成功
ClassMethod SetDirectoryInformation(AInstanceID As %String, ADirInfoData As %GlobalBinaryStream) As %String
{
	s result = "-1"
	q:((AInstanceID = "")||(ADirInfoData = "")) result
	s ECRecordID = $p(AInstanceID,"||",1) 
	s SubRowID = $p(AInstanceID,"||",2)
	q:($d(^DHCPHI.InstanceDataI("IdxECRecord",ECRecordID,SubRowID))<=0) result
	s rowID = $o(^DHCEMRI.DirectoryInformationI("IdxECRecordID"," "_ECRecordID,""))
	if (rowID = "")
	{
		s obj = ##Class(EMRinstance.DirectoryInformation).%New()
		s obj.ECRecordID = ECRecordID
		s objECRecord = ##Class(User.DHCPHECRecord).%OpenId(ECRecordID)
		q:(objECRecord = "") result
		s objDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objECRecord.ChartItemID)
		q:(objDoc = "") result	
		s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objDoc.ParentCategoryID)
		q:(objChapter = "") result
		s obj.DocID = objECRecord.ChartItemID
		s obj.EpisodeID = objECRecord.EpisodeID
		s obj.DocName = objChapter.CategoryName
		k objCategory,objECRecord
	}
	else
	{
		s obj = ##Class(EMRinstance.DirectoryInformation).%OpenId(rowID)
	}
	d obj.DirInfoData.Clear()
	d obj.DirInfoData.CopyFrom(ADirInfoData)
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       取文档目录信息
/// Creator:    Candy
/// CreatDate:  2014-02-18
/// Input: 	    AInstanceID 实例数据ID
/// OutPut:     dirInfoData  文档目录信息
ClassMethod GetDirectoryInformation(AInstanceID As %String) As %GlobalBinaryStream
{
	s dirInfoData = ##Class(%GlobalBinaryStream).%New()
	q:(AInstanceID = "") dirInfoData
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s ECRecordID = $p(AInstanceID,"||",1)
	d objInstance.%Close() 
	k objInstance
	s rowID = $o(^DHCEMRI.DirectoryInformationI("IdxECRecordID"," "_ECRecordID,""))
	q:(rowID = "") dirInfoData
	s obj = ##Class(EMRinstance.DirectoryInformation).%OpenId(rowID)
	q:(obj = "") dirInfoData
	s dirInfoData = obj.DirInfoData
	q dirInfoData
}

/// Desc:       保存病历页码
/// Creator:    Candy
/// CreateDate: 2015-05-21
/// Input:      AIndexXml 变更页码xml
/// Output:     result 成功1 失败0
/// d ##Class(EMRservice.BL.BLDirectoryInformation).SetDocumentIndex()
ClassMethod SetDocumentIndex(AIndexXml As %GlobalBinaryStream) As %String
{
	s result = "0"
	q:(AIndexXml = "")||(AIndexXml.Size = 0) result
	s reader = ##class(%XML.Reader).%New()
	s sc = reader.OpenStream(AIndexXml)
	q:($$$ISERR(sc)) result
	d reader.Correlate("NInstanceIndex","EMRservice.entity.ENInstanceIndex")
	Tstart
	s result = "1"
	While reader.Next(.obj,.sc)
	{
		s indexCount = obj.InstanceIndex.Count()
		continue:(indexCount <=0)
		for i=1:1:indexCount
		{
			s id = obj.InstanceIndex.GetAt(i).ID
			s startPageNum = obj.InstanceIndex.GetAt(i).StartPageNum
	        s startRowNum = obj.InstanceIndex.GetAt(i).StartRowNum
			s endPageNum = obj.InstanceIndex.GetAt(i).EndPageNum
			s endRowNum = obj.InstanceIndex.GetAt(i).EndRowNum
			s sc = ##Class(web.DHCCM.EMRservice.BL.BLInstanceData).SetDocumentPageNum(id,startPageNum,startRowNum,endPageNum,endRowNum)
			s:(sc = "0") result = "0"
			q:(result = "0")
		}
		q:(result = "0")
	}
	if (result = "1")
	{
		Tcommit
	}
	else
	{
		Trollback
	}
	q result
}

/// Desc:       取文档目录信息
/// Creator:    Candy
/// CreatDate:  2014-02-18
/// Input: 	    AInstanceID 实例数据ID
/// OutPut:     dirInfoData  文档目录信息
/// Debug:      d ##Class(EMRservice.BL.BLDirectoryInformation).GetDocumentIndex("2||1","DELETE")
ClassMethod GetDocumentIndex(AInstanceID As %String, AType As %String) As %GlobalBinaryStream
{
	s dirInfoData = ##Class(%GlobalBinaryStream).%New()
	q:(AInstanceID = "") dirInfoData
	s eCRecordId = $p(AInstanceID,"||",1)
	q:(eCRecordId = "") result
	d dirInfoData.Write("<NInstanceIndex>")
	if (AType = "DELETE")
	{
		d dirInfoData.Write("<InstanceIndex><ID>"_AInstanceID_"</ID></InstanceIndex>")
	}
	elseif ( AType = "BROWSE")
	{
		d GetIndexStream
	}
	else
	{
		s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
		if (objInstance.TheECRecord.DocumentCharacteristic = "0")
		{
			s result = ##Class(web.DHCCM.EMRservice.BL.BLInstanceData).GetDocumentPageNum(AInstanceID)
			d dirInfoData.Write(result)		
		}
		else
		{
			d GetIndexStream
		}
	}
	d dirInfoData.Write("</NInstanceIndex>")
	q dirInfoData
GetIndexStream
	s date = ""
	for
	{
		s date = $o(^DHCPHI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCPHI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date,time)) 
			q:(time = "")
			s subId = ""
			for
			{
				s subId = $o(^DHCPHI.InstanceDataI("IdxHappenDateTime",eCRecordId," SAVE",date,time,subId))
				q:(subId = "")	
				s result = ##Class(web.DHCCM.EMRservice.BL.BLInstanceData).GetDocumentPageNum(eCRecordId_"||"_subId)
				d dirInfoData.Write(result)
			}
		}
	}
}

/// Desc:       按实例ID将索引表数据迁移到实例表中
/// Creator:    Candy
/// CreateDate: 2015-6-25
/// Desc:       w ##Class(EMRservice.BL.BLDirectoryInformation).MoveIndexToInstanceEcrecord(0,5)
ClassMethod MoveIndexToInstanceEcrecord(AStart As %String, AEnd As %String) As %String
{
	s result = "1"
	s ECRecordID = AStart
	for
	{	
		s ECRecordID = $o(^DHCPHI.ECRecordD(ECRecordID))
		q:((ECRecordID = "")||(ECRecordID > AEnd))
		s rowId = $o(^DHCEMRI.DirectoryInformationI("IdxECRecordID"," "_ECRecordID,""))	
		continue:(rowId = "")
		s obj = ##Class(EMRinstance.DirectoryInformation).%OpenId(rowId)
		continue:(obj = "") 
		s result = ..SetDocumentIndex(obj.DirInfoData)
		w "ECRecordID: "_ECRecordID_" DirectoryInformation: "_rowId_" result: "_result,!	
		q:(result = "0")
	}
	q result
}

/// Desc:       按索引ID将索引表数据迁移到实例表中
/// Creator:    Candy
/// CreateDate: 2015-6-25
/// Input:      AStartDate 开始日期 格式：2015-6-25
///             AEndDate 结束日期 格式：2015-6-25
/// Desc:       w ##Class(EMRservice.BL.BLDirectoryInformation).MoveIndexToInstance(0,"10")
ClassMethod MoveIndexToInstance(AStart As %String, AEnd As %String) As %String
{
	s result = "1"
	s rowId = AStart
	for
	{
		s rowId = $o(^DHCEMRI.DirectoryInformationD(rowId))
		q:((rowId = "")||(rowId > AEnd))
		s obj = ##Class(EMRinstance.DirectoryInformation).%OpenId(rowId)
		continue:(obj = "") 
		s result = ..SetDocumentIndex(obj.DirInfoData)	
		w " DirectoryInformation: "_rowId_" result: "_result,!
		q:(result = "0")
	}
	q result
}

}
