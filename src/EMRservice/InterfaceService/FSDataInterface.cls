/// 名称:	EMRservice.InterfaceService.FSDataInterface
/// 描述:	提供归档管理相应接口服务
/// 编写者：yejian
/// 编写日期: 2023-3-8
/// 产品组：电子病历产品组
Class EMRservice.InterfaceService.FSDataInterface Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description: 获取病历模板结构
/// Creator：    yejian
/// CreatDate：  2023-3-8
/// Input：     
/// Output:      DocID Emrmeta.emrtemplatecategory表的CategoryType类型为TempCate的rowID
/// 			 DocName 业务活动记录的目录名称
/// 			 TitleCode 标题编码
/// 		     TitleName 标题名称
/// Return：     函数返回值的说明
/// Others：     其它说明
/// Debug: 		d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.FSDataInterface","SelectEMRTemplate")
Query SelectEMRTemplate() As %Query(ROWSPEC = "DocID,DocName,TitleCode,TitleName")
{
}

ClassMethod SelectEMRTemplateExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s DocID="",DocName="",TitleCode="",TitleName=""
 	s strRowID=""
	for {
		s strRowID=$o(^DHCEMRM.EMRTemplateCategoryD(strRowID))
		q:(strRowID = "")
		s objItem =##class(EMRmeta.EMRTemplateCategory).%OpenId(strRowID)
		continue:(objItem="") 
		continue:(objItem.CategoryType'="TempCate")
		s DocID = strRowID
	 	s DocName = objItem.CategoryName
	 	s cateID = objItem.ParentCategoryID
	 	s TitleCode=""
	 	s seq=""
		for {
			s seq=$o(^DHCEMRM.TitleConfigI("IdxCategorySequence"," "_cateID,seq))
			q:(seq = "")
			s tcRowID=$o(^DHCEMRM.TitleConfigI("IdxCategorySequence"," "_cateID,seq,""))
			q:(tcRowID = "")
			s titleConfig =##class(EMRmeta.TitleConfig).%OpenId(tcRowID)
			continue:(titleConfig="")
			s TitleCode = titleConfig.TitleCode
			s titleID = $o(^DHCEMRM.TitlesI("IdxCode"," "_$zcvt(TitleCode,"U"),""))
		 	continue:(titleID="")
		 	s objTitle = ##class(EMRmeta.Titles).%OpenId(titleID)
		 	continue:(objTitle="")
		 	s TitleName =objTitle.Description
		 	s ^CacheTemp(repid,ind) = $lb(DocID,DocName,TitleCode,TitleName)
			s ind=ind+1
		}
		s TitleCode="",TitleName=""
		s ^CacheTemp(repid,ind) = $lb(DocID,DocName,TitleCode,TitleName)
		s ind=ind+1
	}
	
   Quit $$$OK
}

ClassMethod SelectEMRTemplateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectEMRTemplateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectEMRTemplateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectEMRTemplateExecute ]
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

/// Description: 获取病历模板结构
/// Creator：    yejian
/// CreatDate：  2023-3-8
/// Input：     
/// Output:      BusinessSysCode "EMR.DHC"
/// 			 DocumentID InstanceID或DocID
/// 			 ChartItemID 模板ID
/// 			 ChartItemType 模板类型
/// 		     DocumentCharacteristic 文档特性 0单文档显示 1多个文档连续显示
/// 			 EditorType 编辑器类型
/// 			 InstanceID 实例ID
/// 		     HappenDate 业务发生日期
/// 			 HappenTime 业务发生时间
/// 			 ModifyDate 最后修改日期
/// 		     ModifyTime 最后修改时间
/// 		     DocumentTitle 文书标题
/// 			 TitleCode 标题编码
/// 			 IsLoadOne 单独加载标志
/// 		     DocStatus 文书状态 Save/Signed 已保存，已签名
/// 			 RecordParam 打印参数 [{"id":"'||B.ID||'","text":"'||Title||'","chartItemType":"'||ChartItemType||'","pluginType":"'||DocumentType||'","emrDocId":"'||A.ChartItemID||'"}]
/// 			 PatSignedPDFPath 患者知情同意书地址
/// 		     SignXMLPath 签名记录XML文件路径
/// Return：     函数返回值的说明
/// Others：     其它说明
/// Debug: 		d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.FSDataInterface","SelectDocumentData","67")
Query SelectDocumentData(AEpisodeID As %String) As %Query(ROWSPEC = "BusinessSysCode,DocumentID,ChartItemID,ChartItemType,DocumentCharacteristic,EditorType,InstanceID,HappenDate,HappenTime,ModifyDate,ModifyTime,DocumentTitle,TitleCode,IsLoadOne,DocStatus,RecordParam,PatSignedPDFPath,SignXMLPath")
{
}

ClassMethod SelectDocumentDataExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:(AEpisodeID = "") $$$OK
 	s BusinessSysCode="",DocumentID="",ChartItemID="",ChartItemType="",DocumentCharacteristic="",EditorType="",InstanceID="",HappenDate="",HappenTime="",ModifyDate="",ModifyTime="",DocumentTitle="",TitleCode="",IsLoadOne="",DocStatus="",RecordParam="",PatSignedPDFPath="",SignXMLPath=""
	s titleConfig= "",hasSign=""
	s AStatus = "Save"
	s temInstanceIDs = ##class(%ArrayOfDataTypes).%New()
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," "_$zcvt(AStatus,"U"),date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," "_$zcvt(AStatus,"U"),date,time))
			q:(time = "")
			s parentId = ""
			for
			{
				s parentId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," "_$zcvt(AStatus,"U"),date,time,parentId))
				q:(parentId = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," "_$zcvt(AStatus,"U"),date,time,parentId,subId))
					q:(subId = "")
					s instanceId = parentId_"||"_subId
					s objInstanceData = ##class(EMRinstance.InstanceData).%OpenId(instanceId)
					continue:(objInstanceData="")
					s objECRecord = objInstanceData.TheECRecord
					;s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(instanceId)
					s BusinessSysCode="EMR.DHC"
					s DocumentID=instanceId
					s ChartItemID=objECRecord.RealChartItemID
					s ChartItemType=objECRecord.ChartItemType
					s DocumentCharacteristic=objECRecord.DocumentCharacteristic
					s EditorType=objECRecord.DocumentType
					s InstanceID =instanceId
					s HappenDate=$case(objInstanceData.HappenDate,"":"",:$zd(objInstanceData.HappenDate,3))
					s HappenTime=$case(objInstanceData.HappenTime,"":"",:$zt(objInstanceData.HappenTime))
					s ModifyDate=$case(objInstanceData.ModifyDate,"":"",:$zd(objInstanceData.ModifyDate,3))
					s ModifyTime=$case(objInstanceData.ModifyTime,"":"",:$zt(objInstanceData.ModifyTime))
					
					if (objECRecord.ChartItemType ="Multiple")&&(objECRecord.DocumentCharacteristic ="1")
					{
						if (temInstanceIDs.IsDefined(ChartItemID)="0")
						{
							s temData = instanceId_","_objInstanceData.ModifyDate_objInstanceData.ModifyTime
							d temInstanceIDs.SetAt(temData,ChartItemID)
						}
						else
						{
							s temModData = temInstanceIDs.GetAt(ChartItemID)
							s temModData = $p(temModData,",",2)
							s newModData = objInstanceData.ModifyDate_objInstanceData.ModifyTime
							if (newModData>temModData)
							{
							  	s newData =instanceId_","_objInstanceData.ModifyDate_objInstanceData.ModifyTime
							  	d temInstanceIDs.SetAt(newData,ChartItemID)
							}
						}
					}
					s DocumentTitle =objInstanceData.Title
					s TitleCode =objInstanceData.TitleCode
					s IsLoadOne ="N"
					s:(objECRecord.ChartItemType ="Multiple")&&(objECRecord.DocumentCharacteristic ="1") IsLoadOne = "Y"
					s DocStatus =AStatus
					s emrNum  = objInstanceData.ListNo
					s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(AEpisodeID, ChartItemID, emrNum)
					;s hasSign = ##Class(EMRservice.BL.BLTemplateSign).HasRecordSign(AEpisodeID, ChartItemID, emrNum)
					//医生的CA签
					s hasSign = ##Class(EMRservice.BL.BLClientCategory).GetIsSignCAByType(instanceId,"Doctor")
					//患者PDF签状态
					s pdfStatus = ##Class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(instanceId, AEpisodeID)
					s pdfSign = $Case($zcvt(pdfStatus,"U"),"SIGNED":"1",:"0")
					s:(hasSign'="1")&&(pdfSign="1") hasSign="1"
					s:(($p(log,"^",10)="finished")||($p(log,"^",10)="checkedRevision")) hasSign = "0"
					s:(hasSign="1") DocStatus= "Signed"
					//打印参数 [{"id":"'||B.ID||'"="","text":"'||Title||'"="","chartItemType":"'||ChartItemType||'"="","pluginType":"'||DocumentType||'"="","emrDocId":"'||A.ChartItemID||'"}]
					s RecordParam ="[{""id"":"""_instanceId_""",""text"":"""_DocumentTitle _""",""chartItemType"":"""_ChartItemType_""",""pluginType"":"""_EditorType_""",""emrDocId"":"""_ChartItemID_"""}]"
					s PatSignedPDFPath=""
					s SignXMLPath=""				
					s ^CacheTemp(repid,ind) = $lb(BusinessSysCode,DocumentID,ChartItemID,ChartItemType,DocumentCharacteristic,EditorType,InstanceID,HappenDate,HappenTime,ModifyDate,ModifyTime,DocumentTitle,TitleCode,IsLoadOne,DocStatus,RecordParam,PatSignedPDFPath,SignXMLPath)
					s ind=ind+1
		
				}
			}
		}
	}
	s oneKey=""
	for {
		s oneKey=temInstanceIDs.Next(oneKey)
	 	q:oneKey=""
	 	s instanceIDs=temInstanceIDs.GetAt(oneKey)
		s instanceId = $p(instanceIDs,",",1)
		continue:(instanceId="")
		s objInstanceData = ##class(EMRinstance.InstanceData).%OpenId(instanceId)
		continue:(objInstanceData="")
		s objECRecord = objInstanceData.TheECRecord
		;s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(instanceId)
		s BusinessSysCode="EMR.DHC"
		s DocumentID=objECRecord.RealChartItemID
		s ChartItemID=objECRecord.RealChartItemID
		s ChartItemType=objECRecord.ChartItemType
		s DocumentCharacteristic=objECRecord.DocumentCharacteristic
		s EditorType=objECRecord.DocumentType
		s InstanceID =instanceId
		s HappenDate=$case(objInstanceData.HappenDate,"":"",:$zd(objInstanceData.HappenDate,3))
		s HappenTime=$case(objInstanceData.HappenTime,"":"",:$zt(objInstanceData.HappenTime))
		s ModifyDate=$case(objInstanceData.ModifyDate,"":"",:$zd(objInstanceData.ModifyDate,3))
		s ModifyTime=$case(objInstanceData.ModifyTime,"":"",:$zt(objInstanceData.ModifyTime))
		
		s DocumentTitle =objInstanceData.Title
		s TitleCode =objInstanceData.TitleCode
		s IsLoadOne ="N"
		s DocStatus =AStatus
		s emrNum  = objInstanceData.ListNo
		s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(AEpisodeID, ChartItemID, emrNum)
		;s hasSign = ##Class(EMRservice.BL.BLTemplateSign).HasRecordSign(AEpisodeID, ChartItemID, emrNum)
		//医生的CA签
		s hasSign = ##Class(EMRservice.BL.BLClientCategory).GetIsSignCAByType(instanceId,"Doctor")
		//患者PDF签状态
		s pdfStatus = ##Class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(instanceId, AEpisodeID)
		s pdfSign = $Case($zcvt(pdfStatus,"U"),"SIGNED":"1",:"0")
		s:(hasSign'="1")&&(pdfSign="1") hasSign="1"
		s:(($p(log,"^",10)="finished")||($p(log,"^",10)="checkedRevision")) hasSign = "0"
		s:(hasSign="1") DocStatus= "Signed"
		//打印参数 [{"id":"'||B.ID||'"="","text":"'||Title||'"="","chartItemType":"'||ChartItemType||'"="","pluginType":"'||DocumentType||'"="","emrDocId":"'||A.ChartItemID||'"}]
		s RecordParam ="[{""id"":"""_instanceId_""",""text"":"""_DocumentTitle _""",""chartItemType"":"""_ChartItemType_""",""pluginType"":"""_EditorType_""",""emrDocId"":"""_ChartItemID_"""}]"
		s PatSignedPDFPath=""
		s SignXMLPath=""				
		s ^CacheTemp(repid,ind) = $lb(BusinessSysCode,DocumentID,ChartItemID,ChartItemType,DocumentCharacteristic,EditorType,InstanceID,HappenDate,HappenTime,ModifyDate,ModifyTime,DocumentTitle,TitleCode,IsLoadOne,DocStatus,RecordParam,PatSignedPDFPath,SignXMLPath)
		s ind=ind+1
	}
   Quit $$$OK
}

ClassMethod SelectDocumentDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectDocumentDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectDocumentDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectDocumentDataExecute ]
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

/// Description: 获取病历签名XML结构
/// Input:	aInstanceID	实例ID
/// Creator：    yejian
/// CreatDate：  2023-3-8
/// Return:	<SignLogs>
/// 		 	<BusinessSysCode></BusinessSysCode>
/// 		 	<PATPatientID></PATPatientID>
/// 		 	<PAADMVisitNumber></PAADMVisitNumber>
/// 		 	<DocumentType></DocumentType>
/// 		 	<DocumentTitle></DocumentTitle>
/// 		 	<DocumentID></DocumentID>
/// 		 	<!—如有多次签名记录，按照签名时间依次记录 -->
/// 		 	<SignRecord>
/// 		 		<PlainData></PlainData>
/// 				<Algorithm></Algorithm>
/// 			 	<PlainDataDigest></PlainDataDigest>
/// 			 	<SignAlg></SignAlg>
/// 			 	<SignData></SignData>
/// 			 	<TimeStampData></TimeStampData>
/// 			 	<SignTimeStamp></SignTimeStamp>
/// 			 	<Certification></Certification>
/// 			 	<SignDate></SignDate>
/// 			 	<SignTime></SignTime>
/// 			 	<SignUserName></SignUserName>
/// 			 	<SignType></SignType>
/// 		 	</SignRecord>
/// 		</SignLogs>
/// Debug:	w ##Class(EMRservice.InterfaceService.FSDataInterface).GetSignXml("330||4").Read()
ClassMethod GetSignXml(aInstanceID As %String) As %GlobalBinaryStream
{
	s retData = ##class(%GlobalBinaryStream).%New()
	q:(aInstanceID="") retData
	s objItem = ##class(EMRinstance.InstanceData).%OpenId(aInstanceID)
	q:(objItem="") retData
	d retData.Write("<SignLogs>")
	d retData.Write("<BusinessSysCode>"_"EMR.DHC"_"</BusinessSysCode>")
	s papmiNo =##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(objItem.TheECRecord.PatientID)
	d retData.Write("<PATPatientID>"_papmiNo_"</PATPatientID>")
	d retData.Write("<PAADMVisitNumber>"_objItem.TheECRecord.RealEpisodeID_"</PAADMVisitNumber>")
	d retData.Write("<DocumentType>"_objItem.TheECRecord.DocumentType_"</DocumentType>")
	d retData.Write("<DocumentTitle>"_objItem.Title_"</DocumentTitle>")
	d retData.Write("<DocumentID>"_aInstanceID_"</DocumentID>")
	s signLogID = ""
	for {
		s signLogID = $O(^DHCEMRCA.EMRSignLogI("IdxInstance"," "_aInstanceID, signLogID))
		q:(signLogID = "")
		s obj = ##Class(EMRinstance.EMRSignLog).%OpenId(signLogID)
		continue:(obj = "")
		continue:(obj.isSignValid '= "1")
		continue:(obj.SignID = "")||(obj.SignID = $c(0))
		continue:(obj.Digest = "")||(obj.Digest = $c(0))
		s listSign = ..ExportCA(obj.SignID)
 		d retData.Write("<SignRecord>")
		d retData.Write("<PlainData>")
		d retData.CopyFrom(obj.InstanceData)
		d retData.Write("</PlainData>")
		d retData.Write("<Algorithm>"_"MD5"_"</Algorithm>")
		d retData.Write("<PlainDataDigest>"_obj.Digest_"</PlainDataDigest>")
		d retData.Write("<SignAlg>"_""_"</SignAlg>")
		d retData.Write("<SignData>"_$lg(listSign,1)_"</SignData>")
		d retData.Write("<TimeStampData>"_obj.Digest_$lg(listSign,1)_"</TimeStampData>")
		d retData.Write("<SignTimeStamp>"_$lg(listSign,2)_"</SignTimeStamp>")
		d retData.Write("<Certification>"_$lg(listSign,3)_"</Certification>")
		d retData.Write("<SignDate>"_$case(obj.SignDate,"":"",:$zd(obj.SignDate,3))_"</SignDate>")
		d retData.Write("<SignTime>"_$case(obj.SignTime,"":"",:$zt(obj.SignTime))_"</SignTime>")
		d retData.Write("<SignUserName>"_$lg(listSign,4)_"</SignUserName>")
		d retData.Write("<SignType>"_""_"</SignType>")
		d retData.Write("</SignRecord>")
 		
 	}
	d retData.Write("</SignLogs>")
	k objItem
	q retData
}

ClassMethod ExportCA(ASignID) As %List
{
	s objSign = ##Class(CA.DigitalSignature).%OpenId(ASignID)
	s signValue =  objSign.SignValue
	s ts = objSign.SignTimeStamp
	s objCert = ##Class(CA.UsrSignatureInfo).%OpenId(objSign.UsrSignInfoID)
	s cert = objCert.Certificate
	s user = ##class(User.SSUser).%OpenId(objCert.UsrID)
	s userName =$case(user,"":"",:user.SSUSRName)
	s userCA = objCert.UsrCertCode
	;s info = "医生姓名:"_userName_", CA用户标识:"_userCA
	s info = userName
	q $lb(signValue, ts, cert, info)
}

}
