//页面gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	obj.RecRowID="";
    $.parser.parse(); // 解析整个页面
    
	obj.gridInfection =$HUI.datagrid("#gridInfection",{
		fit: true,
		title:'传染病字典维护'+'<span style="margin-left:30px;padding:6px 15px;background-color:#e3f7ff;color:#1278b8;border: 1px solid #c0e2f7;border-radius: 5px;"><span class="icon-tip-blue" style="margin-right:5px;">&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="color:#1278b8;font-weight: 700;">提示信息：多次患病的传染病首次报告后，在重复报告时限内因同种疾病就诊时提示上报，超出时限提示强制上报；非多次患病传染病无需维护重复报告时限</span></span>'+'<a id="admitTip" style="cursor:pointer;margin-top:2px;margin-right:5px;float:right;color:#1474AF;"><span class="icon-help" style="padding:5px 12px;"></span>操作说明</a>',
		headerCls:'panel-header-gray',
		iconCls:'icon-write-order',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMed.EPDService.InfectionSrv",
			QueryName:"QryIFList"		
	    },
		columns:[[
			{field:'ICD',title:'ICD',width:80},
			{field:'MIFDisease',title:'疾病名称',width:200},
			{field:'MIFKind',title:'类别',width:200},	
			{field:'MIFRank',title:'等级',width:200},
			{field:'MIFAppendix',title:'传染病附卡',width:250},
			{field:'MIFMulti',title:'多次患病',width:80,align:'center'},
			{field:'MIFTimeLimit',title:'上报时限',width:80,align:'center'},
			{field:'MIFIsActive',title:'是否有效',width:80,align:'center'},
			{field:'MIFIsForce',title:'是否强制报卡',width:120,align:'center'},
			{field:'MIFIsChronic',title:'是否慢性传染病',width:120,align:'center'},
			{field:'MIFResume',title:'备注',width:100}
		]],
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1) {
				obj.gridInfType_onSelect(rowData);
			}
		}
	});
	//传染病类别下拉框
	obj.cboKind = $HUI.combobox('#cboKind', {              
		url: $URL,
		editable: true,
		valueField: 'Code',
		textField: 'Description',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.aType = 'EpdemicType';
			param.aIsActive = 1;
			param.ResultSetType = 'array';
		}
	});
	//传染病级别下拉框
	obj.cboLevel = Common_ComboDicCode('cboLevel','EpidemicRank',"1");
	
	//传染病附卡下拉框
	obj.cboAppendix = $HUI.combobox('#cboAppendix', {       
		url: $URL,
		editable: true,
		valueField: 'ID',
		textField: 'Description',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMed.EPDService.AppendixCardSrv';
			param.QueryName = 'QryAppendixCard';
			param.ResultSetType = 'array';
		}
	});

	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}