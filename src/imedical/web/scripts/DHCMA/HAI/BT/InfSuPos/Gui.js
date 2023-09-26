//页面Gui
function InitInfSuPosWin(){
	var obj = new Object();
	obj.PosRowID = '';
   	obj.KeyRowID = '';	
   
   	obj.gridInfSuPos = $HUI.datagrid("#gridInfSuPos",{
		fit: true,
		title:'疑似诊断',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,	
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	
		url:$URL,
	    queryParams:{
			ClassName:'DHCHAI.IRS.CRuleInfSuSrv',
			QueryName:'QryInfSuPos'
	    },
	 
		columns:[[
			{field:'Diagnos',title:'疑似诊断',width:200},
			{field:'CateDesc',title:'分类',width:180},
			{field:'KeyWord',title:'关键词',width:300}, 
			{field:'PRIDesc',title:'优先级',width:80}, 
			{field:'Property',title:'属性',width:80},
			{field:'CurrentDesc',title:'是否通用',width:80}, 
			{field:'Note',title:'说明',width:200}, 
			{field:'ActDate',title:'更新日期',width:100},
			{field:'ActTime',title:'更新时间',width:80},
			{field:'ActUser',title:'更新用户',width:120}
		]],
		onClickCell:function(rowIndex, field, value){
			if (rowIndex>-1) {
				var flg =0
				if (field=='Diagnos') flg =1; 
				$("#btnAddPos").linkbutton("disable");
				$("#btnAddKey").linkbutton("disable");
				var rowData = $('#gridInfSuPos').datagrid('getRows')[rowIndex];
				obj.gridInfSuPos_onSelect(rowData,flg);
			}
			
		},
		onDblClickCell:function(rowIndex, field, value){
			var flg =0
			if (field=='Diagnos') flg =1;
			if (rowIndex>-1) {
				var rowData = $('#gridInfSuPos').datagrid('getRows')[rowIndex];
				obj.gridInfSuPos_onDbselect(rowData,flg);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAddPos").linkbutton("enable");
			$("#btnAddKey").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			//所有列进行合并操作
            //$(this).datagrid("autoMergeCells");
            //指定列进行合并操作
            $(this).datagrid("autoMergeCells", ['Diagnos']);
            $(this).datagrid("autoMergeCells", ['CateDesc']);
		}
	});

	//感染部位
	obj.cboInfPos = $HUI.combobox("#cboInfPos", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'Desc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.InfPosSrv&QueryName=QryInfPos&ResultSetType=array";
		   	$("#cboInfPos").combobox('reload',url);
		}
	});
	
	
	//疑似诊断
	obj.cboSuPos = $HUI.combobox('#cboSuPos', {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'Diagnos',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.InfSuPosSrv&QueryName=QryInfSuPos&ResultSetType=array";
		   	$("#cboSuPos").combobox('reload',url);
		}
	});

	obj.cboKeyCate = Common_ComboDicID("cboKeyCate","InfSuPosKeyCate");
	obj.cboPRI = Common_ComboDicID("cboPRI","InfSuPosKeyTpye");
	
	InitInfSuPosWinEvent(obj);	
	obj.LoadEvent(arguments);
	
	return obj;
}


