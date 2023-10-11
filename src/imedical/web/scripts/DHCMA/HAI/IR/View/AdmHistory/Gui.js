//页面Gui
var obj = new Object();
function InitHospSurveryWin(){
	obj.RecRowID = "";
	$.parser.parse(); // 解析整个页面
	
	//历史转科
	 obj.gridAdmHistory = $HUI.datagrid("#gridAdmHistory",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: false, 	//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, 	//如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap: false, 	//不换行(false为自动换行)
		fitColumns: true,	
		loadMsg:'数据加载中...', 
		showGroup: true,
		checkOnSelect:false,
		groupField:'xAdmTime',
		view: groupview,
		groupFormatter:function(value, rows){
			if(value==undefined) return;
			// var SumAdmTime=rows[0].SumAdmTime;
			// if(SumAdmTime==value){
			// 	return '第'+value + '次住院('+rows[0].AdmDateTime+'~'+rows[0].DischDateTime+')';
			// }
			// else{
				return '<a href="#" onclick=obj.btnAbstractMsg_Click(\''+rows[0].EpisodeID+'\')>'+$g("第")+value + $g("次住院")+'('+rows[0].AdmDateTime+'~'+rows[0].DischDateTime+')'+'</a>';
			//}	
		},
	   	url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.DPS.PAAdmTransSrv",
			QueryName:"QryTransInfoByID",
			aEpisodeID:PaadmID
	    },
		columns:[[
			{field:'xCount',title:'序号',width:50,align:'left'},
			{field:'TransLocDesc',title:'科室',width:150,align:'left'},
			{field:'TransWardDesc',title:'病区',width:150,align:'left'},
			{field:'TransBedDesc',title:'床位',width:60,align:'left'},
			{field:'TransDateTime',title:'转入日期时间',width:150,align:'left'},
			{field:'OutLocDateTime',title:'转出日期时间',width:150,align:'left'},
			{field:'Explain',title:'说明',width:120,align:'left'},
			{field:'PAAdmDoc',title:'管床医生',width:120,align:'left'}
		]]
	});
	InitHospSurveryWinEvent(obj);
	return obj;
}