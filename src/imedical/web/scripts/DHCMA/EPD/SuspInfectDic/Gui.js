//页面Gui
function InitSuspInfectDicWin(){
	var obj = new Object();
    obj.RecRowID = '';	
    $.parser.parse(); // 解析整个页面  
   
   obj.gridInfectDic = $HUI.datagrid("#SuspInfectDic",{
		fit: true,
		title:'传染病疑似诊断维护',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:'DHCMed.EPDService.SuspInfectDicSrv',
			QueryName:'QryInfectDic'
	    },
		columns:[[
			{field:'BTCode',title:'代码',width:70},
			{field:'BTDesc',title:'描述',width:160},
			{field:'Infection',title:'传染病诊断',width:180},
			{field:'BTKind',title:'传染病类别',width:180},
			{field:'BTIndNo',title:'排序码',width:80},
			{field:'IsActDesc',title:'有效标志',width:80}, 
			{field:'ActDate',title:'更新日期',width:100},
			{field:'ActTime',title:'更新时间',width:80},
			{field:'ActUser',title:'更新用户',width:120}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridInfectDic_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridInfectDic_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//传染病类别
	obj.cboKind = Common_ComboDicID('cboKind','EpdemicType');
	//传染病诊断
	$HUI.combobox('#cboKind',{
		editable: true,				   
	    onSelect:function(rows){
			var KindID = rows.Code;
		    obj.cboInfect = $HUI.combobox('#cboInfect', {
				url: $URL,
				editable: true,
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'RowID',
				textField: 'MIFDisease',
				onBeforeLoad: function (param) {
					param.ClassName = 'DHCMed.EPDService.InfectionSrv';
					param.QueryName = 'QryIFList';
					param.ResultSetType = 'array';
					param.aKind = KindID;
				}
			});
	    }
    });

	
	InitSuspInfectDicWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


