/// 名称：		EMRservice.BL.BLRecordDateChange
/// 描述：		2版病历转换BL层
/// 编写者：	yejian
/// 编写时间：	2015-6-18
Class EMRservice.BL.BLRecordDateChange Extends %RegisteredObject
{

/// 通过用户ID获取用户编码和姓名
/// debug w ##Class(EMRservice.BL.BLRecordDateChange).GetUserName("105")
ClassMethod GetUserName(AUserID As %String) As %String
{
	//s IdexCode=0
	s UserCode=$p($g(^SSU("SSUSR",AUserID)),"^",1)
	s UserName=$p($g(^SSU("SSUSR",AUserID)),"^",2)
	s UserLocID=$p($g(^SSU("SSUSR",AUserID)),"^",4)
	s SsgroupID=$p($g(^SSU("SSUSR",AUserID)),"^",5)
	s users = AUserID_"^"_UserCode_"^"_UserName_"^"_UserLocID_"^"_SsgroupID
	q users
}

/// 通过用户ID获取用户编码和姓名
/// debug w ##Class(EMRservice.BL.BLRecordDateChange).GetTitleName("2")
ClassMethod GetTitleName(ACode As %String) As %String
{
	s rowID=""
	s rowID=$o(^DHCEMRM.TitlesI("IdxCode"," "_ACode,rowID))
	s objTitle = ##Class(EMRmeta.Titles).%OpenId(rowID)
	q:(objTitle="") ""
	s Description =objTitle.Description
	q Description
}

/// 获取模板数据结构
/// w ##Class(EMRservice.BL.BLRecordDateChange).getEprInstancedata("794||1")
ClassMethod getEprInstancedata(InstanceDataID As %String) As %GlobalCharacterStream
{
		s ItemsSet=##Class(%GlobalCharacterStream).%New()
    	
    	s rowSegmID = ""
    	for
    	{
	    	s rowSegmID = $o(^DHCEPRI.ISegmentI("IdxForUpdate"," "_InstanceDataID,rowSegmID))
			q:(rowSegmID = "")
			s rowID = ""
			for
			{
				s rowID = $o(^DHCEPRI.ISegmentI("IdxForUpdate"," "_InstanceDataID,rowSegmID,rowID))
				q:(rowID = "")
				s objSegm = ##Class(EPRinstance.ISegment).%OpenId(rowID)
				q:(objSegm ="")
				s strText = objSegm.Text.Read(32000)
				s strText = $zcvt(strText,"O","XML")
				d ItemsSet.Write(strText)
			}
    	}
    	s rowTextDID = ""
    	for
    	{
	    	s rowTextDID = $o(^DHCEPRI.ITextDescI("IdxForUpdate"," "_InstanceDataID,rowTextDID))
			q:(rowTextDID = "")
			s rowID = ""
			for
			{
				s rowID = $o(^DHCEPRI.ITextDescI("IdxForUpdate"," "_InstanceDataID,rowTextDID,rowID))
				q:(rowID = "")
				s objTextD = ##Class(EPRinstance.ITextDesc).%OpenId(rowID)
				q:(objTextD ="")
				s strText = objTextD.Text.Read(32000)
				s strText = $zcvt(strText,"O","XML")  
				d ItemsSet.Write(strText)
			}
    	}
    	;d ItemsSet.OutputToDevice()
    	q ItemsSet
    	/*
    	s rowSimCodID = ""
    	for
    	{
	    	s rowSimCodID = $o(^DHCEPRI.ISimpleI("IdxForUpdate"," "_InstanceDataID,rowSimCodID))
			q:(rowSimCodID = "")
			s rowID = ""
			for
			{
				s rowID = $o(^DHCEPRI.ISimpleI("IdxForUpdate"," "_InstanceDataID,rowSimCodID,rowID))
				q:(rowID = "")
				s objSimp = ##Class(EPRinstance.ISimple).%OpenId(rowID)
				q:(objSimp ="")
				s displayName = arrlist.GetAt(objSimp.SimpleItemCode)
				s strValue = objSimp.DataValue
		    	s strItem = "<Item ItemID="""_objSimp.SimpleItemCode_""" ItemName="""_displayName_""" ItemValue="""_strValue_"""></Item>"
				s strItem = $zcvt(strItem,"O","UTF8")  
				d ItemsSet.Write(strItem)
			}
    	}
    	*/
}

/// Creator:	yejian
/// CreatDate:  2014-5-13
/// Desc:		获取所有配置信息
/// Input：		
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLRecordDateChange","GetInstances","58")
Query GetInstances(AEpisodeId As %String) As %Query(ROWSPEC = "ID:%String,Title:%String,TemplateID:%String,PatientID:%String,CreateUser:%String")
{
}

ClassMethod GetInstancesExecute(ByRef qHandle As %Binary, AEpisodeId As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s ChartItemID = ""
	for {
		s ChartItemID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeId,ChartItemID))
		q:(ChartItemID = "")	
		s aECRowID = ""
		for {
			s aECRowID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeId,ChartItemID,aECRowID))
			q:(aECRowID = "")
			s objECRecord = ##Class(EPRinstance.ECRecord).%OpenId(aECRowID)
			continue:(objECRecord.ChartItemType = "Single")
			s PatientID = objECRecord.PatientID
			s aINRowID = ""
			for {
				s aINRowID = $o(^DHCEPRI.InstanceDataI("IdxECRecord",aECRowID,aINRowID))
				q:(aINRowID = "")
				s aRowID = aECRowID _"||"_aINRowID
				s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(aRowID)
				q:(objInstance = "")
				continue:(objInstance.Status="UnSave")
				s ID = aRowID
				s Title = objInstance.Title
				s CreateUser = objInstance.CreateUser
				s TemplateID = objInstance.RealTemplateID
				s Data = $lb(ID,Title,TemplateID,PatientID,CreateUser)
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1
 			} 
		}
	}
	q $$$OK
}

ClassMethod GetInstancesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstancesExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetInstancesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstancesExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
