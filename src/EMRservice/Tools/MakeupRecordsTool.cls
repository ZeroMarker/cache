/// 名称:EMRservice.Tools.MakeupRecordsTool
/// 描述:补录打散数据
/// 编写者：yejian
/// 编写日期: 2021-8-25
Class EMRservice.Tools.MakeupRecordsTool Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:     补录打散数据
/// creator:  yejian
/// Input:    AStartDate 修改的开始日期
/// 		  AEndDate	修改的结束日期
/// Out:      补录结果
/// debug d ##class(EMRservice.Tools.MakeupRecordsTool).MakeupBindData("2021-8-12","2021-8-12")
ClassMethod MakeupBindData(AStartDate As %String, AEndDate As %String) As %String
{
	s InstanceID=""
	s strRes = ""
	s count = 0
	q:(AStartDate = "") $$$OK
    q:(AEndDate = "") $$$OK
    s streamInstanceData = ##class(%GlobalBinaryStream).%New()
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s date = endDate
	s sdate=startDate-1
  	for {
		s sdate =  $o(^DHCEMRI.InstanceDataI("IdxModifyDate", sdate))			
		q:(sdate = "")
		q:(sdate>date)
		s parentId = ""
		for
		{
			s parentId = $o(^DHCEMRI.InstanceDataI("IdxModifyDate",sdate,parentId))
			q:(parentId = "")
			s subId = ""
			for
			{
				s subId = $o(^DHCEMRI.InstanceDataI("IdxModifyDate",sdate,parentId,subId))
				q:(subId = "")
				s InstanceID=parentId_"||"_subId
				s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)  
				q:(objInstance = "")
				q:(objInstance.Status="UnSave")
				s simCID = $o(^DHCEMRI.ISectionDescI("IdxForUpdate"," "_InstanceID,""))				
				q:(simCID '= "")
				d streamInstanceData.CopyFrom(objInstance.InstanceData)
				s streamScatterData = ##Class(EMRservice.Parser.StreamData).ParserStream(streamInstanceData,"<ScatterData","</ScatterData>","14")
			    s sdResult = ##Class(EMRservice.BL.BLInstanceData).SaveScatterData(InstanceID,streamScatterData)
			    if (sdResult '= "1")
			    {
				    s strRes = strRes_"^"_InstanceID
				}
				else
				{
					s count= count+1
				}
				d objInstance.%Close()
			}
		}					    
	}
	q "成功补录数："_count_",失败的实例ID:"_strRes
}

}
