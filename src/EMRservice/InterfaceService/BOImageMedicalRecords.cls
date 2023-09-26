/// Desc:对外根据就诊号取FTP图片路径接口（新版和二版）
/// Creator:yejian
/// CreateDate:2019-2-27
Class EMRservice.InterfaceService.BOImageMedicalRecords Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/interfaceservice";

/// Name of the WebService.
Parameter SERVICENAME = "ImageMedicalRecordsInfo";

/// Input:	AEpisodeID 	患者就诊RowID
/// 
/// Return:	<MedRecordList>
/// 				<Record>
/// 						<Id>30</Id>
/// 					<Desc>入院记录</Desc>
/// 					<Flag>1</Flag>
/// 					<PathList>
/// 						<Path>/dhcepr/vol1/1109/2320/169/1.gif</Path>
/// 						<Path>/dhcepr/vol1/1109/2320/169/2.gif</Path>
/// 						<Path>/dhcepr/vol1/1109/2320/169/3.gif</Path>
/// 						<Path>/dhcepr/vol1/1109/2320/169/4.gif</Path>
/// 					</PathList>
/// 				</Record>
/// 				<Record>
/// 					<Id>35</Id>
/// 						<Desc>病程记录</Desc>
/// 					<Flag>1</Flag>
/// 					<PathList>
/// 						<Path>/dhcepr/vol1/1109/2320/210/1.gif</Path>
/// 						<Path>/dhcepr/vol1/1109/2320/215/1.gif</Path>
/// 						<Path>/dhcepr/vol1/1109/2320/289/1.gif</Path>
/// 						<Path>/dhcepr/vol1/1109/2320/290/1.gif</Path>
/// 						<Path>/dhcepr/vol1/1109/2320/311/1.gif</Path>
/// 					</PathList>
/// 				</Record>
/// 			<MedRecordList>
/// Debug:	w ##Class(EMRservice.InterfaceService.BOImageMedicalRecords).GetImage("13")
ClassMethod GetImage(AEpisodeID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.ImageMedicalRecords).GetImage(AEpisodeID)
}

}
