/// 名称:	EMRservice.InterfaceService.FSDataService
/// 描述:	提供归档管理相应接口服务
/// 编写者：yejian
/// 编写日期: 2023-3-8
/// 产品组：电子病历产品组
Class EMRservice.InterfaceService.FSDataService Extends %SOAP.WebService
{

///  TODO: change this to actual network address.
///  URL for invoking the WebService.
///  Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
///  TODO: change this to actual SOAP namespace.
///  SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

///  Name of the WebService. 
Parameter SERVICENAME = "FSDataServiceInfo";

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
/// Debug: ##class(EMRservice.BOUserTemplate).GetAllLoc()
ClassMethod SelectEMRTemplate() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("EMRservice.InterfaceService.FSDataInterface:SelectEMRTemplate")

	d result.SetArgs()
	Quit result
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
/// Debug: d ##class(EMRservice.BOUserTemplate).GetAllUserTemplate()
ClassMethod SelectDocumentData(AEpisodeID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.InterfaceService.FSDataInterface:SelectDocumentData")
	d result.SetArgs(AEpisodeID)
	q result
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
ClassMethod GetSignXml(aInstanceID As %String) As %GlobalBinaryStream [ WebMethod ]
{
	q ##Class(EMRservice.InterfaceService.FSDataInterface).GetSignXml(aInstanceID)
}

}
