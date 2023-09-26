Class web.eprajax.reportlistgrid Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("EpisodeID",1),"-1")
	s examRuleRowID = $Get(%request.Data("ExamRuleRowID",1),"")
	//s ^CacheTemp("EPRQuality","web.eprajax.reportlistgrid","Params") = "episodeID:"_episodeID_";examRuleRowID="_examRuleRowID
	q:(episodeID = -1) $$$OK
	
	w "<table name='tablelist' id='tablelist' width='98%' border='0' cellpadding='1' cellspacing='1' class='tableStyle01' style='table-layout:fixed'>"
	w "<tr>"
	w "<td width='70%' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>问题描述</a></font></td>"
	w "<td width='15%' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>医生</a></font></td>"
	w "<td width='15%' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>级别</a></font></td>"	
	//w "<td width='10%' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>扣分</a></font></td>"
	w "</tr>"

	//如果是医政组的质控
	//s rset = ##Class(%ResultSet).%New("web.DHCWMRQuality.BORunTimeError:QueryEntrys")

	//如果是电子病历的质控
	s rset = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetPromptList")
	
	s NewQualityCtrlInterface = ##class(EPRmeta.SysOption).GetOptionValueByName("NewQualityCtrlInterface")
	if ($zcvt(NewQualityCtrlInterface,"U") = "Y")
	{
		s ctLocID = %session.Get("LOGON.CTLOCID")
		s ssGroupID = %session.Get("LOGON.GROUPID")
		s sc = rset.Execute(episodeID, examRuleRowID_"_"_ssGroupID_"_"_ctLocID)	
	}
	else
	{
 		s sc = rset.Execute(episodeID, examRuleRowID)
	}
	//w "["
   // s json =""
 	While (rset.Next()){
		w "<tr id='valueTr'  onDblClick='dbChoTr(this)'; onMouseDown='choTr(this,0);' onMouseover='tip.start(this);' style='background-color:"_rset.Data("PhaseColor")_"'>"
		w "<td nowrap align='left' class='TDstyle04' style='overflow:hidden;text-overflow:ellipsis;'>"_rset.Data("EntryDesc")_"</td>"
		w "<td nowrap align='center' class='TDstyle04'>"_rset.Data("DocName")_"</td>"
		w "<td nowrap align='center' class='TDstyle04'>"_rset.Data("PhaseName")_"</td>"
		w "</tr>"
		//s json = json_"{EntryDesc:'"_rset.Data("EntryDesc")_"',"
		//s json = json_"DocName:'"_rset.Data("DocName")_"',"
		//s json = json_"PhaseName:'"_rset.Data("PhaseName")_"',"
		//s json = json_"PhaseColor:'"_rset.Data("PhaseColor")_"'},"		
 	}
 	
 	//s json = $E(json, 1, $L(json)-1)
	//s json = json_"]"
	
	//w json

 	
 	d rset.Close()
	w "</table>"
	q $$$OK
}

}
