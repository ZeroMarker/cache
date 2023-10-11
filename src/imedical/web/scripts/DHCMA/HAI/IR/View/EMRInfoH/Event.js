function InitCCScreeningWinEvent(obj){		
	obj.HTMlInfo = function(runQuery){
		if (!runQuery) return;
		arrRecord = runQuery.rows;
		$("#divMian").empty();
		for(var  i =0 ; i < arrRecord.length ; i++){
			var RecordID 	= arrRecord[i].RecordID;
			var DocType 	= arrRecord[i].DocType;
			var DocTitle 	= arrRecord[i].DocTitle;
			var DocDate 	= arrRecord[i].DocDate;
			var DocContent  = arrRecord[i].DocContent;
			var ActDate 	= arrRecord[i].ActDate;
			var ActTime 	= arrRecord[i].ActTime;
			var ActUser 	= arrRecord[i].ActUser;

			var htm="";
			htm+='<div class="hisui-panel" title="'+ActDate+' '+ActTime+ ' '+DocTitle+'"';
			htm+='style="width:fit;padding:10px" data-options="headerCls:\'panel-header-card\'">'
			htm+='&nbsp;&nbsp;&nbsp;&nbsp;'+DocContent;
			htm+='<p class="sign">医生：'+ActUser+'</p>'; 
			htm+='</div>';
			
			$("#divMian").append(htm);
			// 解决样式不生效
			
	 		$.parser.parse($("#divMian").parent());

		}
		return true;
	}

}
