/// 名称:	EMR.DOC.BL.TitleColConfig
/// 描述:	模板标题维护 标题配置
/// 编写者：Ningyanghong
/// 编写日期: 2021-9-28
/// 产品组：电子病历产品组
Class EMR.DOC.BL.TitleColConfig Extends EMR.DOC.COM.ActionBase
{

/// Desc:       保存标题信息
/// Creator:    ningyanghong
/// CreateDate: 2021-12-16
/// Input:      argArray  命令参数 {"action":"SAVE_SCHEMEITEM_SSGROUP","params":{"id":"68^67","locStr":"259^262","title":"11111"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SaveConfig(title As %String, objCon As EMR.DOC.DTO.TitleColConfig)
{
	s $zt = "Error"
	
	q:(title="")
	s objRecord=##class(CF.EMR.DOC.TemplateCategory).%OpenId(title)
	q:(objRecord="") "-301"
	
	s type=objCon.Type
	
	// 没有就新增 有就修改
	
	s rowID=""
	&sql(select ID into :rowID from CF_EMR_DOC.TitleColConfig where TemplateCategory = :title and Type =:type)
	
	if (rowID="")
	{
		// 新增
		s objconfig= ##class(CF.EMR.DOC.TitleColConfig).%New()
		s objconfig.Align=objCon.Align
		s objconfig.FontStyle=objCon.FontStyle 
		s objconfig.Format=objCon.Format
		s objconfig.SeqNum=objCon.SeqNum
		s objconfig.TemplateCategory=objRecord
		s objconfig.Type=objCon.Type
		s objconfig.Visible=objCon.Visible
		s objconfig.Params=objCon.Params
		s objconfig.ReadOnly=objCon.ReadOnly
		s sc=objconfig.%Save()
		if ($$$ISOK(sc))
		{
			q objconfig.%Id()
		}
		
	}else
	{
		// 修改
		s objconfig= ##class(CF.EMR.DOC.TitleColConfig).%OpenId(rowID)
		s objconfig.Align=objCon.Align
		s objconfig.FontStyle=objCon.FontStyle 
		s objconfig.Format=objCon.Format
		s objconfig.SeqNum=objCon.SeqNum
		s objconfig.TemplateCategory=objRecord
		s objconfig.Params=objCon.Params
		s objconfig.Type=objCon.Type
		s objconfig.Visible=objCon.Visible
		s objconfig.ReadOnly=objCon.ReadOnly
		s sc=objconfig.%Save()
		if ($$$ISOK(sc))
		{
			q objconfig.%Id()
		}
	}
	
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       获取标题信息
/// Creator:    ningyanghong
/// CreateDate: 2021-12-16
/// Input:      argArray  命令参数 {"action":"SAVE_SCHEMEITEM_SSGROUP","params":{"id":"68^67","locStr":"259^262","title":"11111"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod getConfig(titleID As %String, argOutData As %GlobalBinaryStream) As %DynamicObject
{
	s rowID=""
	s objTitle=##class(%DynamicObject).%New()
	for
	{
		s rowID = $o(^CF.EMR.DOC.TitleColConfigI("IdxTemplateCategory",titleID,rowID))
		q:(rowID="")
		s objCol=##class(CF.EMR.DOC.TitleColConfig).%OpenId(rowID)
		s type=objCol.Type
		if (type="Title")
		{
			s objTitle.includeTitle=objCol.Visible
			s objTitle.readOnly=objCol.ReadOnly
			s objTitle.align=objCol.Align
			s objTitle.doctorLevel=objCol.Params
			if (objCol.FontStyle'="")
			{
				
				s objJson = ##class(%DynamicAbstractObject).%FromJSON(objCol.FontStyle)
				s objTitle.fontStyle=objJson.bold
				s objTitle.fontSize=objJson.fontSize
				s objTitle.fontFamily=objJson.fontFamily
				s objTitle.color=objJson.color
			}
			
			if (objCol.Format'="")
			{
				for i=1:1:$l(objCol.Format,"^")
				{
					s ItemID=$p(objCol.Format,"^",i)
					q:(ItemID="")
					
					if (ItemID="DoctorName")
					{
						s objTitle.includeDoctorName=1
					}elseif (ItemID="DoctorLevel")
					{
						s objTitle.includeDoctorLevel=1
					}
				}
			}
		}else
		{
			s objTitle.dateFormat=objCol.Format
			s objTitle.includeDate=objCol.Visible
			s objTitle.dateReadOnly=objCol.ReadOnly
			s objTitle.dateAlign=objCol.Align
			if (objCol.FontStyle'="")
			{
				s objJson = ##class(%DynamicAbstractObject).%FromJSON(objCol.FontStyle)
				s objTitle.dateFontStyle=objJson.bold
				s objTitle.dateFontSize=objJson.fontSize
				s objTitle.dateFontFamily=objJson.fontFamily
				s objTitle.dateColor=objJson.color
			}
		}
		
		
	}
	d objTitle.%ToJSON(argOutData)
	q "1"
}

}
