/// 名称:	EMR.DAO.GlobalData
/// 描述:	全局图表业务类
/// 编写者：yejian
/// 编写日期: 2022-7-6
/// 产品组：电子病历产品组
Class EMR.DAO.GlobalData Extends EMR.DAO.Base
{

/// Desc:       根据规则分发全局图表ID
/// Creator:    yejian
/// CreateDate: 2022-7-21
/// Table：     EMR.GB.GlobalData 
/// Input：     aEpisodeID 就诊号
/// 			aDOCCategoryCode 业务活动记录分类编码
/// 			aDOCCode 业务活动记录编码
/// 			aTemplateID 模板ID
/// 			aHappenDate 发生日期（重复模板回收）
/// Output:     
/// Return：    ID
/// Debug:       w ##Class(EMR.DAO.GlobalData).GetGlobalData(4,"EMR02","EMR020102",47)
ClassMethod GetGlobalData(aEpisodeID As %String, aDOCCategoryCode As %String, aDOCCode As %String, aTemplateID As %String, aHappenDate As %Date = "", ByRef aGData As EMR.GB.GlobalData = "") As %String
{
	s strRes = "1",objDoc="",hasDateTime="",hasDateDocumentID=""
	q:(aEpisodeID="")||(aDOCCategoryCode="")||(aDOCCode="")||(aTemplateID="") "-1^就诊号、模板ID、活动记录分类、活动记录不能为空"
	s objTem = ##class(CF.EMR.DOC.Template).%OpenId(aTemplateID)
	s objEpisode = ##class(User.PAAdm).%OpenId(aEpisodeID,0)
	q:(objTem="")||(objEpisode="") "-1^就诊号、模板ID不能为空"
	s TILDocumentData = ##Class(EMR.DAO.DocumentData).GetTureIndexLocation(aEpisodeID)
	s intListNo = $o(^EMR.GB.GlobalDataI("IdxMain",aEpisodeID," "_$zcvt(aDOCCategoryCode,"U"),""),-1)
	if (intListNo'="")
	{
		s docID = $o(^CF.EMR.DOC.TemplateCategoryI("IdxCode"," "_$zcvt(aDOCCode,"U"),""))
		s:(docID'="") objDoc = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(docID)		
		q:(objDoc="")||(objDoc.StructType.Code '="Record") "-1^获取业务活动记录失败"
		s IsMutex = $case(objDoc.Title.IsMutex,"":"0",:objDoc.Title.IsMutex)
		//标识 1:异常 ，0:无异常
		s flag = "0"
		s nodeId = ##Class(EMR.DAO.EpisodeIDShardingStrategy).TableStrategy(aEpisodeID)
		//获取分类下的互斥记录
		s strDocID = ""
		for
		{
			s strDocID =$o(^CF.EMR.DOC.TemplateCategoryI("IdxParentID"," "_objDoc.ParentID,strDocID))
			q:(strDocID="")
			s objCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strDocID)
			continue:(objCat="")			
			s docCode = objCat.Code
			//获取实例ID
			s documentID = $O(@TILDocumentData@("IdxEpisodeRecordCodeStatus",aEpisodeID," "_$zcvt(docCode,"U")," SAVE",""))
			continue:(documentID="")
			s objData = ##class(EMR.DAO.DocumentData).doOpenByID(documentID)
			s strTemID = objData.TemplateID.%Id()
			//互斥情况下不同模板不允许创建
			if (strTemID'=aTemplateID)&&(objCat.Title.IsMutex=1)&&(IsMutex=1)
			{
				s flag =1
				s strRes =  "-1^已保存有互斥的病历"
				q
			}
			//互斥情况下相同模板，已有唯一实例或唯一模板，则不允许创建
			if (strTemID=aTemplateID)&&((objCat.Title.UniqueCreate="1")||(objTem.ChartItemType="SINGLE"))
			{
				s flag =1
				s strRes =  "-1^已保存该病历"
				q
			}
		}
		q:(flag=1) strRes
	}
	if (aGData '="")
	{
		//唯一模板，(UNSAVE状态)回收文档ID
		s hasDocumentID = $O(@TILDocumentData@("IdxEpisodeTemplateStatus",aEpisodeID,aTemplateID," UNSAVE",""),-1)
		//重复模板ID根据日期回收
		if (aHappenDate'="")
		{
			s hasDateTime = $O(@TILDocumentData@("IdxEpisodeTemplateStatusHDT",aEpisodeID,aTemplateID," UNSAVE",aHappenDate,""),-1)
			s:(hasDateTime'="") hasDateDocumentID = $O(@TILDocumentData@("IdxEpisodeTemplateStatusHDT",aEpisodeID,aTemplateID," UNSAVE",aHappenDate,hasDateTime,""),-1)
			s:(hasDateDocumentID'="") hasDocumentID = hasDateDocumentID
		}
		if (hasDocumentID'="")&&(objTem.ChartItemType="SINGLE")
		{
			s aGData =##class(EMR.GB.GlobalData).%OpenId(hasDocumentID)
		}
		elseif (hasDocumentID'="")&&(objTem.ChartItemType="MULTIPLE")
		{
			s objTemDocumentData = ##class(EMR.DAO.DocumentData).doOpenByID(hasDocumentID)
			q:(objTemDocumentData="") "-1^回收重复文档ID，获取文档失败" 
			//重复模板发生时间日期相同，回收ID
			if (objTemDocumentData.HappenDate=aHappenDate) 
			{
				s aGData =##class(EMR.GB.GlobalData).%OpenId(hasDocumentID)
			}
			else
			{
				s aGData.DOCCategoryCode =aDOCCategoryCode
				s aGData.DOCCode =aDOCCode
				s aGData.EpisodeID =objEpisode
				s aGData.ListNo=intListNo+1
			}
		}
		else
		{
			s aGData.DOCCategoryCode =aDOCCategoryCode
			s aGData.DOCCode =aDOCCode
			s aGData.EpisodeID =objEpisode
			s aGData.ListNo=intListNo+1
		}
	}
	q strRes
}

}
