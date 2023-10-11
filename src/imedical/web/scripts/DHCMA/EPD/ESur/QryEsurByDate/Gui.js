//页面gui
var objScreen = new Object();
function InitESurReportWin(){
	//head 定义
	var obj = objScreen;
    
    $.parser.parse(); // 解析整个页面
    
    obj.DateFrom = $('#DateFrom').datebox('setValue', Common_GetDate(new Date())); // 日期初始赋值
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));
	obj.chkRepStatus = Common_CheckboxToDic("chkRepStatus","ESurStatus",3);   // zhuantai 
    
    
	obj.gridESurReport =$HUI.datagrid("#gridESurReport",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'RepID',title:'操作',width:45,align:'center',align:'center',
				formatter: function(value,row,index){
					if (value=="") return "";
					var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenEsurView(\'' + row.RegTypeID + '\',\'' + row.aRepID + '\',\'' + row.EpisodeID + '\')"></a>';
					return btn;
				}
			}, 
			{ field: 'aRepID', title: '报告ID', width: 80, align: 'center' },
			{ field: 'SEName', title: '姓名', width: 80, align: 'center' },
			{ field: 'SERegNo', title: '登记号', width: 150, align: 'center' },
            { field: 'SERepStutas', title: '报告状态', width: 120, align: 'center',
                formatter: function (value, row, index) {
                    return "<a href='#' onclick='objScreen.OpenEsurView(\"" + row.RegTypeID + "\",\"" + row.aRepID + "\",\"" + row.EpisodeID + "\");'>" + value + "</a>";
                }
            },
            { field: 'SEIDNumber', title: '身份证号', width: 180, align: 'center' },
            { field: 'SESex', title: '性别', width: 100, align: 'center' },
			{ field: 'SETelPhone', title: '电话', width: 120, align: 'center' },
            { field: 'SEDiagDateTime', title: '就诊时间', width: 180, align: 'center' },
			{ field: 'SEDiagLoc', title: '就诊科室', width: 120, align: 'center' },
			{ field: 'SEDiagDoc', title: '就诊医生', width: 120, align: 'center' },
			{ field: 'DescOne', title: '是否境外输入', width: 120, align: 'center' },
			{ field: 'DescTwo', title: '是否门诊留观', width: 120, align: 'center' },
			{ field: 'DescThr', title: '是否有流行病学史', width: 120, align: 'center' },
			{ field: 'DescFor', title: '是否发热', width: 120, align: 'center' },
			{ field: 'DescFiv', title: '是否住院留观', width: 120, align: 'center' },
			{ field: 'DescSix', title: '体温', width: 120, align: 'center' },
			{ field: 'DescSev', title: '核酸检测结果', width: 120, align: 'center' },
			{ field: 'DescEit', title: '症状', width: 120, align: 'center' },
			{ field: 'DescNin', title: '病人去向', width: 120, align: 'center' },
		]],onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	
	//foot  执行
	InitESurReportWinEvent(obj);
	
	obj.LoadEvent(arguments);	
	return obj;
}