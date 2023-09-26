/// 名称:	EMR.DOC.BL.DoctorSignStream
/// 描述:	CA医护数据签名业务
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.DoctorSignStream Extends EMR.DOC.COM.ActionBase
{

/// Desc:      保存医护签数据
/// Creator:    yejian
/// CreateDate: 2022-9-22
/// Table:		
/// Input: 		aEpisodeID 就诊号
/// 			aSignID 签名ID
/// 			aDocumentID 文档ID
/// 			aDigest 签名哈希
/// 			argInData 签名原文
/// Output:     成功：1^ID  失败：0^ErrMsg	
/// debug:  	w ##Class(EMR.DOC.BL.DoctorSignStream).SaveDoctorSignStream()
ClassMethod SaveDoctorSignStream(aEpisodeID As %String, aSignID As %String, aDocumentID As %String, aDigest As %String, argInData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aSignID = "")||(aEpisodeID="")||(aDigest="") "-1^保存医护签参数有误！"
	s objSign = ##class(CA.DigitalSignature).%OpenId(aSignID,0)
	s docSignStream = ##class(EMR.DAO.DoctorSignStream).doCreateInstance(aEpisodeID)
	s docSignStream.SignID = objSign
	s docSignStream.Digest =aDigest
	d docSignStream.DocumentData.Clear()
	//数据压缩存储
	s temStream = ##class(EMR.DOC.COM.Parser.StreamData).CompressStream(argInData)
	d docSignStream.DocumentData.CopyFrom(temStream)
	s scStream =  docSignStream.%Save()
	if ($$$ISERR(scStream))
	{
		q "-1^DocumentID:"_aDocumentID_",保存签名原文失败"
	}
	q "1^"_docSignStream.%Id()
}

}
