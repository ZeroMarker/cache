Class EMRservice.BL.IPResource Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       前端获取住院、急诊资源区页签配置
/// CreateDate: 2018-9-10
/// Input:      AEpisodeID 患者就诊号
/// Debug       w ##Class(EMRservice.BL.IPResource).GetIPResource("289")
ClassMethod GetIPResource(AEpisodeID As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "") ret
	s episodeType = $p(^PAADM(AEpisodeID),"^",2)
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s position = ""
	for
	{
		s position = $o(^DHCEMRM.IPResourceI("Idxposition",position))
		q:(position = "")
		s rowId = ""
		for {
			s rowId = $o(^DHCEMRM.IPResourceI("Idxposition",position,rowId))
			q:(rowId = "")
			s obj = ##class(EMRmeta.IPResource).%OpenId(rowId)
			continue:(obj = "")
			continue:((obj.visible '= "")&&(obj.visible '= episodeType))
			
			///临床路径信息依据入径情况显示
			if (obj.frameId="clinicalpathway")
			{
				s isShowClinicalPathway =##class(DHCMA.CPW.IO.ToEmrNur).IsShowCPWTab(AEpisodeID_"!!1")
				continue:(isShowClinicalPathway=0)
			}
			s title = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.IPResource","title",obj.title,langid)
			
			s item = "{'id':'"_obj.frameId_"','title':'"_title_"','source':'"_obj.source_"','width':"_obj.width_"}"
			if (ret'="") { s ret = ret_","_item }
			else { s ret = item }
		}
	}
	
	if (ret'="") { s ret = "["_ret_"]" }
	q ret
}

/// d ##Class(EMRservice.BL.IPResource).Init()
ClassMethod Init()
{
	d ##class(EMRmeta.IPResource).%BuildIndices()
		
	s frameId = "KBTree"
	s title = "知识库"
	s source = "emr.ip.resource.kbtree.csp"
	s width = "300"
	s visible = ""
	s position = 1
	d ..insertRecord(frameId, title, source, width, visible, position)
	
	s frameId = "Order"
	s title = "医嘱"
	s source = "emr.ip.resource.medorder.csp"
	s width = "600"
	s visible = ""
	s position = 2
	d ..insertRecord(frameId, title, source, width, visible, position)

	s frameId = "zorders"
    s title = "中草药"
    s source = "emr.ip.resource.zorder.csp"
    s width = "600"
    s visible = ""
	s position = 3
	d ..insertRecord(frameId, title, source, width, visible, position)		
	
	s frameId = "Pacs"
    s title = "检查"
    s source = "emr.ip.resource.pacsdata.csp"
    s width = "600"
    s visible = ""
	s position = 4
	d ..insertRecord(frameId, title, source, width, visible, position)			
	
	s frameId = "Lis"
    s title = "检验"
    s source = "emr.ip.resource.lisdata.csp"
    s width = "700"
	s visible = ""
	s position = 5
	d ..insertRecord(frameId, title, source, width, visible, position)		
	
	s frameId = "vitalsigns"
    s title = "生命体征"
    s source = "emr.ip.resource.vitalsigns.csp"
    s width = "700"
	s visible = ""
	s position = 6
	d ..insertRecord(frameId, title, source, width, visible, position)
	s frameId = "pathology"
    s title = "病理"
    s source = "emr.ip.resource.pathology.csp"
    s width = "600"
	s visible = "N"
	s position = 7
	d ..insertRecord(frameId, title, source, width, visible, position)
	
	s frameId = "consult"
    s title = "会诊"
    s source = "emr.ip.resource.consult.csp"
	s width = "600"
	s visible = ""
	s position = 8
	d ..insertRecord(frameId, title, source, width, visible, position)
	
	s frameId = "textkb"
    s title = "专科知识库"
    s source = "emr.ip.resource.textkb.csp"
	s width = "600"
	s visible = ""
	s position = 9
	d ..insertRecord(frameId, title, source, width, visible, position)
	
	s frameId = "bloodsugar"
    s title = "血糖"
    s source = "emr.ip.resource.bloodsugar.csp"
	s width = "600"
	s visible = "N"
	s position = 10
	d ..insertRecord(frameId, title, source, width, visible, position)
	
	s frameId = "nursingreport"
    s title = "护理记录单"
    s source = "emr.ip.resource.nursingreport.csp"
	s width = "600"
	s visible = "N"
	s position = 11
	d ..insertRecord(frameId, title, source, width, visible, position)
	
	s frameId = "patsympInfo"
    s title = "每日症状情况"
    s source = "emr.ip.resource.patsympInfo.csp"
    s width = "600"
	s visible = "N"
	s position = 12
	d ..insertRecord(frameId, title, source, width, visible, position)
	
	s frameId = "bloodtrans"
    s title = "输血"
    s source = "emr.ip.resource.bloodtrans.csp"
    s width = "600"
	s visible = "N"
	s position = 13
	d ..insertRecord(frameId, title, source, width, visible, position)
	
	s frameId = "radiation"
	s title = "放疗"
    s source = "emr.ip.resource.radiation.csp"
    s width = "600"
	s visible = "N"
	s position = 14
	d ..insertRecord(frameId, title, source, width, visible, position)
	
	s frameId = "dptree"
	s title = "常用语"
    s source = "emr.ip.resource.dptree.csp"
    s width = "600"
	s visible = ""
	s position = 15
	d ..insertRecord(frameId, title, source, width, visible, position)
	
	s frameId = "narcosis"
	s title = "麻醉单"
    s source = "emr.ip.resource.narcosis.csp"
    s width = "600"
	s visible = ""
	s position = 16
	d ..insertRecord(frameId, title, source, width, visible, position)
}

/// d ##class(EMRservice.BL.IPResource).insertRecord()
ClassMethod insertRecord(frameId As %String, title As %String, source As %String, width As %Integer, visible As %String, position As %Integer)
{
	s id=$O(^DHCEMRM.IPResourceI("IdxframeId"," "_$zcvt(frameId,"U"),""))
	if ( id = "")
	{
		s obj = ##Class(EMRmeta.IPResource).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.IPResource).%OpenId(id)
	}
	
	s obj.frameId = frameId
	s obj.title = title
	s obj.source = source
	s obj.width = width
	s obj.visible = visible
	s obj.position = position
	d obj.%Save()
}

}
