Class EMRservice.BL.HyperLink Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:      取link单元信息
/// Creator:   Candy
/// CreateDate:2016-8-5
/// Input:     AName link单元代码
/// Debug:     w ##Class(EMRservice.BL.HyperLink).GetUnitLink("diagnosesRow")
ClassMethod GetUnitLink(AName As %String) As %String
{
	s result = ""
	q:(AName = "") result
	s rowId = $O(^DHCEMRM.OPUnitLinkI("IdxName"," "_$zcvt(AName,"U"),""))
	q:(rowId = "") result
	s obj = ##Class(EMRmeta.OPUnitLink).%OpenId(rowId)
	s result = "{""Title"":"""_obj.Title_""",""Link"":"""_obj.Link_""",""Method"":"""_obj.Method_"""}"
	q result
}

/// Desc:取link单元的Scheme
/// Creator:   Candy
/// CreateDate:2016-8-5
/// Input:     AName link单元代码
/// Debug: w ##Class(EMRservice.BL.HyperLink).GetUnitScheme("diagnosesLayer")
ClassMethod GetUnitScheme(AName As %String) As %String
{
	s result = ""
	q:(AName = "") result
	s rowId = $O(^DHCEMRM.OPUnitLinkI("IdxName"," "_$zcvt(AName,"U"),""))
	q:(rowId = "") result
	s obj = ##Class(EMRmeta.OPUnitLink).%OpenId(rowId)
	s result= obj.Scheme
	q result
}

/// Desc：取HIs回写数据
/// Creator:    Candy
/// CreateDate: 2016-8-11
/// Input:      AEpisodeID 就诊号
///             AName 连接单元名称
/// Output:     result 回写结果
/// Debug:      w ##Class(EMRservice.BL.HyperLink).GetHisLinkData(就诊号,"appointment")   
ClassMethod GetHisLinkData(AEpisodeID As %String, AName As %String) As %String
{
	s result = ""
	if (AName = "appointment")
	{
		s result = ..GetAppointment(AEpisodeID)
	}
	q result
}

/// Desc:       取预约数据
/// Creator:    Candy
/// CreateDate: 2016-8-11
/// Input:      AEpisodeID 就诊号
/// Output:     result 预约结果
ClassMethod GetAppointment(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s patientNo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientId)
	s date = $p($h,",",1)
	s ds = ##Class(%Library.ResultSet).%New("web.DHCDocRBAppointmentQuery:AppointmentNumQuery")
	d ds.Execute(date,date,AEpisodeID)
	s count = 0
	While (ds.Next())
	{
		s:(count '= 0) result = "\n"
		s result = ds.Data("APPDate")_" "_ ds.Data("LocDesc")_" "_ds.Data("CTPCPDesc")
	}
    q result
}

/// d ##Class(EMRservice.BL.HyperLink).Init()
ClassMethod Init()
{
	///电子病历诊断配置
	//层级引用
	s style = "<scheme><show><item><code>TypeDesc</code><desc>类型</desc><hidden>N</hidden></item><item><code>ICDDesc</code><desc>诊断</desc><hidden>N</hidden><width>200</width></item><item><code>MemoDesc</code><desc>备注</desc><hidden>N</hidden></item><item><code>ICDCode</code><desc>ICD编码</desc><hidden>N</hidden></item><item><code>EvaluationDesc</code><desc>状态</desc><hidden>N</hidden><width>60</width></item><item><code>UserName</code><desc>医生</desc><hidden>N</hidden></item><item><code>Date</code><desc>日期</desc><hidden>N</hidden><width>100</width></item><item><code>Time</code><desc>时间</desc><hidden>N</hidden><width>80</width></item></show><reference><style>layer</style><separate>enter</separate><interpunction>.^)</interpunction><memosep>()</memosep><category><display>y</display><separate>enter</separate></category><type><display>y</display><separate>enter</separate></type><namedate>y</namedate></reference><!--his/third(第三方）--><infectionsource>his</infectionsource><!--hascheck设置为1有选择框--><hascheck></hascheck></scheme>"
	d ..insertRecord("diagnosesLayer","诊断编辑层级引用","emr.record.diagnoses.csp?EpisodeID=@episodeID&LocID=@locID&UserID=@userID","",style)
	//行引用
	s style = "<scheme><show><item><code>TypeDesc</code><desc>类型</desc><hidden>N</hidden></item><item><code>ICDDesc</code><desc>诊断</desc><hidden>N</hidden><width>200</width></item><item><code>MemoDesc</code><desc>备注</desc><hidden>N</hidden></item><item><code>ICDCode</code><desc>ICD编码</desc><hidden>N</hidden></item><item><code>EvaluationDesc</code><desc>状态</desc><hidden>N</hidden><width>60</width></item><item><code>UserName</code><desc>医生</desc><hidden>N</hidden></item><item><code>Date</code><desc>日期</desc><hidden>N</hidden><width>100</width></item><item><code>Time</code><desc>时间</desc><hidden>N</hidden><width>80</width></item></show><reference><style>row</style><separate>;</separate><interpunction>.^)</interpunction><memosep>()</memosep><category><display>y</display><separate></separate></category><type><display>n</display><separate/></type><namedate>n</namedate></reference><!--his/third(第三方）--><infectionsource>his</infectionsource><!--hascheck设置为1有选择框--><hascheck></hascheck></scheme>"
	d ..insertRecord("diagnosesRow","诊断编辑行引用","emr.record.diagnoses.csp?EpisodeID=@episodeID&LocID=@locID&UserID=@userID","",style)
	
	//医生站诊断配置
	//层级引用
	s style = "<scheme><show><item><code>TypeDesc</code><desc>类型</desc><hidden>N</hidden></item><item><code>ICDDesc</code><desc>诊断</desc><hidden>N</hidden><width>200</width></item><item><code>MemoDesc</code><desc>备注</desc><hidden>N</hidden></item><item><code>ICDCode</code><desc>ICD编码</desc><hidden>N</hidden></item><item><code>EvaluationDesc</code><desc>状态</desc><hidden>N</hidden><width>60</width></item><item><code>UserName</code><desc>医生</desc><hidden>N</hidden></item><item><code>Date</code><desc>日期</desc><hidden>N</hidden><width>100</width></item><item><code>Time</code><desc>时间</desc><hidden>N</hidden><width>80</width></item></show><reference><style>layer</style><separate>enter</separate><interpunction>.^)</interpunction><memosep>()</memosep><category><display>y</display><separate>enter</separate></category><type><display>y</display><separate>enter</separate></type><namedate>y</namedate></reference><!--his/third(第三方）--><infectionsource>his</infectionsource><!--hascheck设置为1有选择框--><hascheck></hascheck></scheme>"
	d ..insertRecord("diagnosesLayerV8","医生站诊断编辑层级引用","diagnosentry.v8.csp?EpisodeID=@episodeID&LocID=@locID&UserID=@userID&Opener=EMR","",style)	
	//行引用
	s style = "<scheme><show><item><code>TypeDesc</code><desc>类型</desc><hidden>N</hidden></item><item><code>ICDDesc</code><desc>诊断</desc><hidden>N</hidden><width>200</width></item><item><code>MemoDesc</code><desc>备注</desc><hidden>N</hidden></item><item><code>ICDCode</code><desc>ICD编码</desc><hidden>N</hidden></item><item><code>EvaluationDesc</code><desc>状态</desc><hidden>N</hidden><width>60</width></item><item><code>UserName</code><desc>医生</desc><hidden>N</hidden></item><item><code>Date</code><desc>日期</desc><hidden>N</hidden><width>100</width></item><item><code>Time</code><desc>时间</desc><hidden>N</hidden><width>80</width></item></show><reference><style>row</style><separate>;</separate><interpunction>.^)</interpunction><memosep>()</memosep><category><display>y</display><separate></separate></category><type><display>n</display><separate/></type><namedate>n</namedate></reference><!--his/third(第三方）--><infectionsource>his</infectionsource><!--hascheck设置为1有选择框--><hascheck></hascheck></scheme>"
	d ..insertRecord("diagnosesRowV8","医生站诊断编辑行引用","diagnosentry.v8.csp?EpisodeID=@episodeID&LocID=@locID&UserID=@userID&Opener=EMR","",style)
	
	//挂号预约
	d ..insertRecord("appointment","挂号预约","dhcdocrbappoitmentquery.csp?CardNo=@cardNo","","")
	
	//既往史书写页面
	d ..insertRecord("pastHistory","既往史书写","emr.ip.pasthistory.csp?EpisodeID=@episodeID&PatientID=@patientID","","")
}

/// d ##class(EMRmeta.OPUnitLink).%BuildIndices()
ClassMethod insertRecord(Name, Title, Link, Method As %String, Scheme As %String = "")
{
	s id = $O(^DHCEMRM.OPUnitLinkI("IdxName"," "_$zcvt(Name,"U"),""))
	if (id = "")
	{
		s obj = ##Class(EMRmeta.OPUnitLink).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.OPUnitLink).%OpenId(id)
	}
	s obj.Name = Name
	s obj.Title = Title
	s obj.Link = Link
	s obj.Method = Method
	s obj.Scheme = Scheme
	d obj.%Save()
}

}
