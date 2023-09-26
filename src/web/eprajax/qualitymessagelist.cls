Class web.eprajax.qualitymessagelist Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s count = 0
	s episodeID = $g(%request.Data("episodeID",1),"-1")
	q:(episodeID = -1) $$$OK
	
	w "<table name='tablelist' width='100%' id='tablelist' border='0' cellpadding='1' cellspacing='1' class='tableStyle01'>"
	w "<tr id='trTitle'>"
	w "<td width='10%' align='center' class='TDstyle02'><a>状态</a></td>"
	w "<td width='10%' align='center' class='TDstyle02'><a>状态</a></td>"
	w "<td width='20%' align='center' class='TDstyle02'><a>发送时间</a></td>"
	w "<td width='40%' align='center' class='TDstyle02'><font color='#004E82'><a>消息描述</a></font></td>"
	w "<td width='10%' align='center' class='TDstyle02'><a></a></td>"
	w "<td width='10%' align='center' class='TDstyle02'><a></a></td>"
	w "</tr>"
	
	s rset = ##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityMessage:GetMessagesByEpisodeID")
	
	//显示所有质控消息
	d rset.Execute(episodeID,"")
	
	//只显示未读消息
	//d rset.Execute(episodeID,1)
	
 	While (rset.Next()){
		w "<tr id='valueTr' onDblClick='dbChoTr(this)'; onMouseDown='choTr(this,0);'>"
		
		//w "<td align='center' class='TDstyle01' id='link_"_rset.Data("RowID")_"'><a href='#' onclick="_$c(34)_"ReadMessage("_rset.Data("RowID")_")"_$c(34)_">未读</a></td>"
		w "<td align='center' class='TDstyle01' id='link1_"_rset.Data("RowID")_"'><a>"_rset.Data("ReadStatus")_"</a></td>"
		w "<td align='center' class='TDstyle01' id='link2_"_rset.Data("RowID")_"'><a>"_rset.Data("ExecuteStatus")_"</a></td>"
		//判断消息内容是否大于15个字
		if ($l($tr(rset.Data("MessageBody"),"<br/>","")) > 15)
		{
			s message = $e($tr(rset.Data("MessageBody"),"<br/>",""),0,15)_"……"
		}
		else
		{
			s message = rset.Data("MessageBody")
		}
		
		if (rset.Data("ReadStatus") = "未读")
		{
			w "<td align='center' class='TDstyle01_unread' id='date_"_rset.Data("RowID")_"'><a>"_rset.Data("CreateDate")_" "_rset.Data("CreateTime")_"</a></td>"
			w "<td align='left' class='TDstyle01_unread' id='des_"_rset.Data("RowID")_"'>"_message_"</td>"
		}
		else
		{
			w "<td align='center' class='TDstyle01' id='date_"_rset.Data("RowID")_"'><a>"_rset.Data("CreateDate")_" "_rset.Data("CreateTime")_"</a></td>"
			w "<td align='left' class='TDstyle01' id='des_"_rset.Data("RowID")_"'>"_message_"</td>"
		}
		
		w "<td align='center' class='TDstyle01' id='detail_"_rset.Data("RowID")_"'><a href='#' onclick="_$c(34)_"ShowDetail("_rset.Data("RowID")_",'"_rset.Data("MessageBody")_"')"_$c(34)_">阅读</a></td>"
		w "<td align='center' class='TDstyle01' id='detail_"_rset.Data("RowID")_"'><a href='#' onclick="_$c(34)_"ShowExe("_rset.Data("RowID")_",'"_rset.Data("MessageBody")_"')"_$c(34)_">已改</a></td>"
		w "</tr>"
		s count = count + 1
 	}
 	Do rset.Close()

	w "</table>"_"$"_count
	q $$$OK
}

}
