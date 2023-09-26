/// Desc:质控对外web接口
/// Creator:Candy
/// Date:2013-10-12
Class EPRservice.BIO.BIOQulaity Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "BIOQulaityInfo";

/// Creator: Candy
/// Date:    2013-10-12
/// Desc:    指控列表
/// Input:   AEpisodeID 就诊号
/// Output:	 ExamEntry为质控项目RowId;
/// 		 EntryDesc为质控项目描述;
/// 		 ResultRowid为质控结果RowId;
/// 		 DocName为患者主治医生名;
/// 		 DocRowid为患者主治医生RowId;
/// 		 EntryScore为质控项目分配的分数;
ClassMethod GetPromptList(AEpisodeID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("EPRservice.Quality.BORunTimeQuality:GetPromptList")
	d obj.SetArgs(AEpisodeID,"")
	q obj
}

}
