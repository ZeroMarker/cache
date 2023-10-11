//页面gui
var objScreen = new Object();
function InitESurReportWin(){
	//head 定义
	var obj = objScreen;
		
    //加载头部链接
    var ESurTypes = $cm({
        ClassName: "DHCMed.EPDService.ESurRepSrv",
        QueryName: "QryESurType",
        aActive: 1
    }, false);
    for(var ind=0;ind<ESurTypes.total;ind++){
        var ESurType=ESurTypes.rows[ind];
        var RepID=ESurType.ID;
        var RepType=ESurType.BTDesc;
        var RepCode=ESurType.BTCode;
        console.log(ind,RepType,RepCode);
        $("#custtb").append('<a class="hisui-linkbutton" iconCls="icon-w-paper" text="' + RepID + '" style="margin-left:10px" href="#"><span>' + RepType + '</span></a>');
    }
    $.parser.parse(); // 解析整个页面
    
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
			{ field: 'aRepID', title: '报告ID', width: 80, align: 'center' },
			{ field: 'SEName', title: '姓名', width: 80, align: 'center' },
			{ field: 'SERegNo', title: '登记号', width: 120, align: 'center' },
            { field: 'SERepStutas', title: '报告状态', width: 102, align: 'center',
                formatter: function (value, row, index) {
                    return "<a href='#' onclick='objScreen.OpenEsurView(\"" + row.RegTypeID + "\"," + "\"" + row.aRepID + "\");'>" + value + "</a>";
                }
            },
            { field: 'SEIDNumber', title: '身份证号', width: 220, align: 'center' },
            { field: 'SESex', title: '性别', width: 80, align: 'center' },
			{ field: 'SETelPhone', title: '电话', width: 140, align: 'center' },
            { field: 'SEDiagDateTime', title: '就诊时间', width: 200, align: 'center' },
			{ field: 'SEDiagLoc', title: '就诊科室', width: 140, align: 'center' },
			{ field: 'SEDiagDoc', title: '就诊医生', width: 140, align: 'center' }
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