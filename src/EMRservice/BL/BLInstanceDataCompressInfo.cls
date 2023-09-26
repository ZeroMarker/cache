Class EMRservice.BL.BLInstanceDataCompressInfo Extends %RegisteredObject
{

/// Creator：      lifengbo
/// CreateDate：   2022-11-02
/// Description:： 通过实例ID获取实例存储的压缩状态
/// Input： AInstanceID，实例ID
/// Output：TRUE，实例存储为压缩存储  FALSE，实例存储为非压缩存储
/// Debugger: w ##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsCompressByInstanceID("110||4")
ClassMethod GetIsCompressByInstanceID(AInstanceID As %String) As %String
{
	s ret = "FALSE"
	q:(AInstanceID="") ret
	
	if ($d(^DHCEMRI.InstanceDataCompressI("IdxInstanceCompress"," "_AInstanceID))=0)
	{
		q ret
	}
	
	s LongIsCompress = $O(^DHCEMRI.InstanceDataCompressI("IdxInstanceCompress"," "_AInstanceID,""))
	
	s IsCompress = $e(LongIsCompress,2,*)
	
	q IsCompress
}

/// Desc:		获取是否后台压缩标记
/// CreateDate: 2022-12-26
/// Creator:    yejian
/// Input:      AInstanceID 文档ID,
/// Output:     AIsBSCompress 后台压缩(1 后台压缩，0 后台未压缩)
/// w ##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsBKCompressByInstanceID("110||4")
ClassMethod GetIsBKCompressByInstanceID(AInstanceID As %String) As %String
{
	s ret = "0"
	q:(AInstanceID="") ret
	
	if ($d(^DHCEMRI.InstanceDataCompressI("IdxInstanceBKCompress"," "_AInstanceID))=0)
	{
		q ret
	}
	
	s LongIsCompress = $O(^DHCEMRI.InstanceDataCompressI("IdxInstanceBKCompress"," "_AInstanceID,""))
	
	s IsKBCompress = $e(LongIsCompress,2,*)
	
	q IsKBCompress
}

/// Desc:		保存压缩信息
/// CreateDate: 2022-12-26
/// Creator:    yejian
/// Input:      AInstanceID 文档ID,AIsCompressDocument 插件压缩（TRUE 插件压缩,FALSE或空 未压缩）,AIsBSCompress 后台压缩(1 后台压缩，0 后台未压缩)
/// Output:     true,启用； false,不启用。 默认启用
/// w ##class(EMRservice.BL.BLInstanceDataCompressInfo).SaveData("110||4","FALSE")
ClassMethod SaveData(AInstanceID As %String, AIsCompressDocument As %String = "FALSE", AIsBKCompress As %String = "0") As %String
{
	s ret = 0
	q:(AInstanceID="") ret
	s tmpIntCompressID=""
	s tmpIntCompressID = $O(^DHCEMRI.InstanceDataCompressI("IdxInstanceID"," "_AInstanceID,tmpIntCompressID))
	if (tmpIntCompressID="")
	{
		s objInstanceCompress = ##class(EMRinstance.InstanceDataCompressInfo).%New()
	}
	else
	{
		s objInstanceCompress = ##class(EMRinstance.InstanceDataCompressInfo).%OpenId(tmpIntCompressID)
	}
	//
	s:(AIsCompressDocument="") AIsCompressDocument="FALSE"
	s:(AIsBKCompress = "") AIsBKCompress = "0"
	s objInstanceCompress.InstanceID=AInstanceID
	s objInstanceCompress.IsCompress=AIsCompressDocument
	s objInstanceCompress.IsBKCompress=AIsBKCompress
	s sc= objInstanceCompress.%Save()
	
	if ($$$ISOK(sc))
	{
		s ret=1
	}
	
	q ret
}

}
