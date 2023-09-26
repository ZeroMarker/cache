var objScreen = new Object();
function InitSpeNewsWin(){
	var obj = objScreen;
	obj.SPN_Input = new Object();
	obj.SPN_Input.SpeID      = SpeID;
	obj.SPN_Input.OperTpCode = OperTpCode;
	
	$.parser.parse(); 
	 if (EmrOpen==1){
		$('#divSouth').css('display','none');
    } 
	obj.gridSpeNewsList = $HUI.datagrid("#SpeNewsList",{
		fit: true,
		//title: "消息列表",
		//headerCls:'panel-header-gray',
		//iconCls:'icon-paper',
		//toolbar: [],  //配置项toolbar为空时,会在标题与列头产生间距"
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'正在读取数据,请稍后...',
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMed.SPEService.PatientsQry",
			QueryName:"QryNewsBySpeID",		
			aSpeID: obj.SPN_Input.SpeID
	    },
		columns:[[
			{field:'NewsTypeDesc',title:'类型',width:'90'},
			{field:'Opinion',title:'消息',width:'200'},
			{field:'ActDate',title:'发送日期',width:'100'},
			{field:'ActUserDesc',title:'发送人',width:'90'},
			{field:'ReadStatus',title:'状态',width:'50'},
			{field:'ReadDate',title:'阅读日期',width:'100'}, 
			{field:'ReadUserDesc',title:'阅读人',width:'90'}, 
			{field:'SpeLogID',title:'操作',width:'50',
				formatter: function(value,row,index){
					if (value=="") return "";
					var SpeLogID = row["SpeLogID"];
					var IsRead =row["IsRead"];
					if (IsRead==0){
						return " <a href='#'  class='btn_delete' onclick='objScreen.btnDeleteNews_Click(\"" + SpeLogID + "\");'></a>";
						//return " <a href='#' onclick='objScreen.btnDeleteNews_Click(\"" + SpeLogID + "\");'>删除</a>";
					}else{
						return '';
						//return " <a href='#' style='color:gray;'>删除</a>";
					}
				}			
			}, 	
		]]
	});
	
	InitSpeNewsWinEvent(obj);
	obj.LoadEvent();
	return obj;

}
