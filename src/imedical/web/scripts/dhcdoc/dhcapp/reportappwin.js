/// ����ԤԼ���鴰��
showItmAppDetWin = function(arReqID){

	if($('#newWin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="newWin"></div>');
	$("#newWin").append('<div id="tabWin"></div>');
	
	$("#tabWin").append('<div id="app" title="ԤԼ"></div>');
	$("#tabWin").append('<div id="det" title="ԤԼ����"></div>');
	$("#det").html('<div id="dgAppList"></div>');
	
	/// ԤԼ���鴰��
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:"true",
		onClose:function(){
			$("#newWin").remove();
		}
	};
	
	new WindowUX('ԤԼ����', 'newWin', '1200', '600', option).Init();
	
	/// ԤԼ����tab��ǩ
	var option = {
		border:true,
		fit:true,
	    onSelect:function(title){
	        var tab = $("#tabWin").tabs('getSelected');  // ��ȡѡ������
	        var tbId = tab.attr("id");
	        var maintab="";
	        switch(tbId){
	            case "det":
					//maintab="dhcpha.comment.paallergy.csp";  //ԤԼ����
					$('#dgAppList').datagrid('resize',{width: 1100,height: 500 });
					$("#dgAppList").datagrid("reload");
					break;
				case "app":
					maintab="dhc.ris.appointment.csp";       //ԤԼ
					break;
			}
			if (maintab != ""){
				//iframe ����
		        var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+maintab+'?PatientID='+ "" +'&EpisodeID='+ EpisodeID +'"></iframe>';
		        tab.html(iframe);
	        }
	    }
	    
	}

	new TabsUX('ԤԼ����', 'tabWin', option).Init();
	$('#newWin').window('open');
	
	initAppItmList(arReqID);   /// ԤԼ����
}

/// ԤԼ���� DataGrid��ʼ����
function initAppItmList(arReqID){
	
	///  ����columns
	var columns=[[
		{field:'ItemLabel',title:'��Ŀ',width:220},
		{field:'PartDesc',title:'��λ',width:120},
		{field:'ItemStatus',title:'ԤԼ״̬',width:120},
		{field:'ItemDate',title:'����',width:120},
		{field:'ItemTime',title:'ʱ��',width:120},
		{field:'ItemMach',title:'�豸',width:120}
		
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true
	};

	var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqAppList&arReqID="+arReqID;
	new ListComponent('dgAppList', columns, uniturl, option).Init(); 
}
