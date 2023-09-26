/// 名称：EPRservice.BOLISData
/// 描述：获取LIS数据业务类
/// 创建者：HouJ
/// 创建时间：
Class EPRservice.BOLISData Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// Parameter LOCATION = "http://10.10.141.189/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "LISDataInfo";

/// Desc: 获取LIS检验项目分类
ClassMethod SelectLISItemCategory() As %XML.DataSet [ WebMethod ]
{
	set ds=##class(%XML.DataSet).%New("EPRservice.LISData:SelectLISItemCategory")
	
	quit ds
}

/// Desc：获取某分类下的检验项
/// Debug：w ##class(EPRservice.BOLISData).SelectLISItemByCateID("347")
ClassMethod SelectLISItemByCateID(aCategoryID As %String) As %XML.DataSet [ WebMethod ]
{
	set ds=##class(%XML.DataSet).%New("EPRservice.LISData:SelectLISItemByCateID")
	do ds.SetArgs(aCategoryID)
	
	quit ds
}

/// 获取检验项目对应的检验指标项
ClassMethod SelectLISItemIndicators(aItemID As %String) As %XML.DataSet [ WebMethod ]
{
}

/// Desc：		根据就诊号和起始时间(医嘱时间)查询病人已执行的检验医嘱列表
/// Creator:	HouJian
/// CreateTime:	2009-05-31
/// Input:		EpisodeID: 就诊rowid
/// 			StDate: 开始日期，格式为：yyyy-mm-dd
/// 			EndDate: 结束日期，格式为：yyyy-mm-dd
/// Output:		EPRservice.dataset.ELISItemListByDateDataSet
/// 			其字段描述如下：
/// 			OEordItemRowID:%String		医嘱套Rowid	
/// 				OEordItemDesc:%String		医嘱套描述
/// 				LabEpisodeNo:%String		标本号
ClassMethod GetLISItemListByDate(EpisodeID As %String, StDate As %String, EndDate As %String) As EPRservice.dataset.ELISItemListByDateDataSet [ WebMethod ]
{
 	s StDate=$zdh(StDate,3)
 	s EndDate =$zdh(EndDate,3)
 	S result=##class(EPRservice.dataset.ELISItemListByDateDataSet).%New()
	d result.SetArgs(EpisodeID,StDate,EndDate)
 	q result
}

/// Desc：		根据选择的具体医嘱ID，取得本医嘱的检验项目的结果
/// Creator:	HouJian
/// CreateTime:	2009-05-31
/// Input:		OeordID：%String				医嘱ID
/// Output:		EPRservice.dataset.ELISReportByOeordIDDataSet
/// 			其字段描述如下：
/// 				ItemDesc:%String				描述
/// 				ItemResult:%String				结果
/// 				ItemUnit:%String				单位
/// 				AbnorFlag:%String				异常标记
/// 				ItemRanges:%String				范围值
ClassMethod GetReportByOeordID(OeordID As %String) As EPRservice.dataset.ELISReportByOeordIDDataSet [ WebMethod ]
{
 	s result=##class(EPRservice.dataset.ELISReportByOeordIDDataSet).%New()
	d result.SetArgs(OeordID)
 	q result
}

/// Desc：		按医嘱条数逆序查询病人已执行的检验医嘱列表，比如查询病人最后的30条检验医嘱
/// Creator:	HouJian
/// CreateTime:	2009-05-31
/// Input:		EpisodeID: 就诊rowid
/// 			StCount：开始的医嘱数
/// 			EndDate: 结束的医嘱数
/// Output:		EPRservice.dataset.ELISItemListByCountDataSet
/// 			其字段描述如下：
/// 			OEordItemRowID:%String		医嘱套Rowid	
/// 				OEordItemDesc:%String		医嘱套描述
/// 				LabEpisodeNo:%String		标本号
ClassMethod GetLISItemListByCount(EpisodeID As %String, StCount As %String, EndCount As %String) As EPRservice.dataset.ELISItemListByCountDataset [ WebMethod ]
{
 	S result=##class(EPRservice.dataset.ELISItemListByCountDataset).%New()
	d result.SetArgs(EpisodeID,StCount,EndCount)
 	q result
}

/// Creator:Candyxu
/// CreatTime:2011-12-08
/// Desc:按就诊号或按病人号分页查询或查询一段时间内的检验医嘱
/// Input: PID：当PFlag为1时PID为EpisodeID,否则SelectID为patientID，PStartDate：开始时间
///       PEndDate：结束时间，PStartPage：返回分页开始页号，PEendPage：返回分页结束页号
/// OutPut:OEordItemRowID:医嘱ID,OEordItemDesc:医嘱名称,LabEpisodeNo:标本号,SpecimenDesc:标本类型,CollectionDate:,CollectionTime:,ReceiveDate:送检日期,ReceiveTime:送检时间,AuthorisationDate:,AuthorisationTime:,ExistReport:,EpisodeDate:就诊日期,EpisodeSection:就诊科室	
ClassMethod GetLISDATAListItems(AID As %String, AStDate As %String, AEdDate As %String, AStPage As %String, AEdPage As %String, AFlag As %String) As EPRservice.dataset.ELISDataListDataSet [ WebMethod ]
{
	i (AStDate '= $c(0)) && (AStDate '= "") 
	{
	   s AStDate = $zdh(AStDate,3)
       s AEdDate = $zdh(AEdDate,3)
	}
 	s result=##class(EPRservice.dataset.ELISDataListDataSet).%New()
	d result.SetArgs(AID,AStDate,AEdDate,AStPage,AEdPage,AFlag)
 	q result
}

}
