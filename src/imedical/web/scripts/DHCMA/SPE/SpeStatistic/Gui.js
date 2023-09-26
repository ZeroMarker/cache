//页面Gui
function InitSpeStatisticWin(){
	var obj = new Object();		

	$.parser.parse(); // 解析整个页面  
	 
    //初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"SPE");
    //医院科室联动
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboLoc = Common_ComboToLoc("cboLoc","E","","",HospID);
	    }
    });
    obj.DateFrom = $('#DateFrom').datebox('setValue', Common_GetDate(new Date()));    // 日期初始赋值
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));
	
	obj.cboPatType = $HUI.combobox('#cboPatType', {
		url: $URL,
		editable: true,
		mode: 'remote',
		valueField: 'PTID',
		textField: 'PTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMed.SPEService.PatType';
			param.QueryName = 'QryPatTypeActive';
			param.ResultSetType = 'array';
		},
		onChange: function (newValue, oldValue) {
			if (newValue == "") {
				$('#cboPatTypeSub').combobox('reload');
			}
		}
	});

	obj.cboPatTypeSub = $HUI.combobox('#cboPatTypeSub', {
		url: $URL,
		editable: true,
		mode: 'remote',
		valueField: 'PTSID',
		textField: 'PTSDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMed.SPEService.PatTypeSub';
			param.QueryName = 'QryPatTypeSubActive';
			param.ResultSetType = 'array';
			param.aPatTypeID = $('#cboPatType').combobox('getValue');
		}
	});
    
    obj.gridSpeStatistic = $HUI.datagrid("#SpeStatistic",{
		fit: true,
		title:'特殊患者统计',
		headerCls:'panel-header-gray',
		iconCls:'icon-copy-prn',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'LocDesc',title:'责任科室',width:'150'},
			{field:'TypeDesc',title:'患者大类',width:'200'},
			{field:'TypeSubDesc',title:'患者子类',width:'120',
				styler: function(value,row,index){ //单元格的样式函数，返回样式字符串来自定义该单元格的样式
					if (value=="") return "";
					var retStr = ""
					if (value=="合计") {
						retStr =  'color:blue;';
					} else {
						retStr =  'color:black;'; 
					} 
					return retStr;
				}
			}, 
			{field:'CountCS',title:'人(次)数',width:'80'},
			{field:'CountBJ',title:'标记人数',width:'80'},
			{field:'CountSH',title:'审核人数',width:'80'},
			{field:'CountZF',title:'作废人数',width:'80'},
			{field:'CountGB',title:'关闭人数',width:'80'}
		]],onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
		}
	});
 
	InitSpeStatisticWinEvent(obj);	
	obj.LoadEvent(arguments);
	
	return obj;
}


