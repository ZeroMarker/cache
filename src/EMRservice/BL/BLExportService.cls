Class EMRservice.BL.BLExportService Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLExportService","GetAllInstanceIDByEpisodeID","112")
Query GetAllInstanceIDByEpisodeID(AEpisodeId As %String) As %Query(ROWSPEC = "InstanceID:%String,DocumentType:%String")
{
}

ClassMethod GetAllInstanceIDByEpisodeIDExecute(ByRef qHandle As %Binary, AEpisodeId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s InstanceID=""
	s AStatus = " SAVE"
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId,AStatus,date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId,AStatus,date,time))
			q:(time = "")
			s parentId = ""
			for
			{
				s parentId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId,AStatus,date,time,parentId))
				q:(parentId = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId,AStatus,date,time,parentId,subId))
					q:(subId = "")
				    s InstanceID=parentId_"||"_subId
				    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)  
	                q:(objInstance = "")
	                continue:(objInstance.Status'="Save")
	                s DocumentType = objInstance.TheECRecord.DocumentType 
				    s ^CacheTemp(repid,ind) = $lb(InstanceID,DocumentType)
	                s ind=ind+1		
				}
			}
		}
	} 	
 
   Quit $$$OK
}

ClassMethod GetAllInstanceIDByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllInstanceIDByEpisodeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllInstanceIDByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllInstanceIDByEpisodeIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLExportService","GetSignInfo","764||9")
Query GetSignInfo(AInstanceID As %String) As %Query(ROWSPEC = "InstanceID:%String,CertName:%String,Certificate:%String,Digest:%String,SignValue:%String")
{
}

ClassMethod GetSignInfoExecute(ByRef qHandle As %Binary, AInstanceID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:(""=AInstanceID) $$$OK

	s id = $O(^DHCEMRCA.EMRSignLogI("IdxInstance", " "_AInstanceID, ""), -1)
	q:(""=id) $$$OK
	s objEMRSignLog = ##class(EMRinstance.EMRSignLog).%OpenId(id)
	q:(1'=objEMRSignLog.isSignValid) $$$OK
	s signID = objEMRSignLog.SignID
	s objSign = ##class(CA.DigitalSignature).%OpenId(signID)
	s usrSignInfoID = objSign.UsrSignInfoID
	s objUsrSign = ##class(CA.UsrSignatureInfo).%OpenId(usrSignInfoID)

    //证书名:
    s CertName = objUsrSign.CertName
    //证书:
    s Certificate = objUsrSign.Certificate
    //签名原文(病历原文的Hash):
    s Digest = objEMRSignLog.Digest
    //签名值:
	s SignValue = objSign.SignValue
	
    s ^CacheTemp(repid,ind) = $lb(AInstanceID,CertName,Certificate,Digest,SignValue)
    s ind=ind+1	
 
   Quit $$$OK
}

ClassMethod GetSignInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSignInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSignInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSignInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// 获取签名信息
ClassMethod GetSignStatu(AEpisodeID As %String)
{
	s objEMRSignLog = ##class(EMRinstance.EMRSignLog).%OpenId(id)
	q:(1'=objEMRSignLog.isSignValid)
}

/// 获取签名信息
ClassMethod GetInstanceSignInfo(AEpisodeID As %String)
{
	s ret=1
	s CategoryID = ""
	for 
	{
		s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID))
		q:(CategoryID="")

		s id = "" 
		for 
		{
			s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, CategoryID, id))
			s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ecRecordID)
			q:(objECRecord="")
			
			s instanceCount = objECRecord.InstanceCount
			for idx = 1:1:instanceCount 
			{ 
				s objInstance = objECRecord.Instances.GetAt(idx)
				q:(objInstance="") 
				w objInstance.Status,!
				continue:(objInstance.Status'="Save")
				s instanceID = objInstance.%Oid()
				// 导出instance数据
				d ..ExportInstance(objInstance)
				d ..GetSignInfo(instanceID)
			}
			q:(ret=0)
		}
		q:(ret=0)
	}
	
	q ret
}

ClassMethod ExportInstance(objInstance As EMRinstance.InstanceData)
{
	q:(objInstance = "")
	s stream=##class(%FileCharacterStream).%New()
	s fileName = "D:\garbage\"_$TR(AInstanceID,"||","-")_".xml"

	d stream.CopyFrom(##Class(EMRservice.BL.BLTemplate).GetRecordXML(objInstance.RealTemplateID,"Document",objInstance.Title,objInstance.TitleCode,objInstance.InstanceMetaData,objInstance.InstanceScriptData,objInstance.InstanceData,objInstance.InstanceMedia))			
    d stream.SaveStream()
    d stream.%Close()
}

/// w ##class(EMRservice.BL.BLExportService).GetRecordDocName("72||7")
ClassMethod GetRecordDocName(AInstanceID As %String) As %String
{
	s result= ""
	q:(AInstanceID = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s EpisodeID = objInstance.RealEpisodeID
	s title = objInstance.Title
	
	s result =EpisodeID_"^"_title
	q result
}

/// d ##class(EMRservice.BL.BLInstanceData).GetSignInfo("25||586")
ClassMethod GetSignInfo(AInstanceID As %String)
{
	q:(""=AInstanceID)

	s id = $O(^DHCEMRCA.EMRSignLogI("IdxInstance", " "_AInstanceID, ""), -1)
	q:(""=id)
	s objEMRSignLog = ##class(EMRinstance.EMRSignLog).%OpenId(id)
	q:(1'=objEMRSignLog.isSignValid)
	s signID = objEMRSignLog.SignID
	s objSign = ##class(CA.DigitalSignature).%OpenId(signID)
	s usrSignInfoID = objSign.UsrSignInfoID
	s objUsrSign = ##class(CA.UsrSignatureInfo).%OpenId(usrSignInfoID)
	
	s stream=##class(%FileCharacterStream).%New()
	s fileName = "D:\garbage\"_$TR(AInstanceID,"||","-")_" Sign.txt"
	w fileName,!
	s stream.Filename = fileName	
	
	w "证书名:",!
	d stream.WriteLine("")
	d stream.WriteLine("证书名:")
    w objUsrSign.CertName,!
    d stream.WriteLine("")
    d stream.WriteLine(objUsrSign.CertName)
    w "证书:",!
    d stream.WriteLine("")
    d stream.WriteLine("证书:")
    w objUsrSign.Certificate,!
    d stream.WriteLine("")
    d stream.WriteLine(objUsrSign.Certificate)
    w "签名原文(病历原文的Hash):",!
    d stream.WriteLine("")
    d stream.WriteLine("签名原文(病历原文的Hash):")
    w objEMRSignLog.Digest,!
    d stream.WriteLine("")
    d stream.WriteLine(objEMRSignLog.Digest)
    w "签名值:",!
    d stream.WriteLine("")
    d stream.WriteLine("签名值:")
	w objSign.SignValue,!
	d stream.WriteLine("")
	d stream.WriteLine(objSign.SignValue)
	
	d stream.SaveStream()
	d stream.%Close()	
	q
}

}
