//页面Gui
var objScreen = new Object();
function InitDMReportList(){
	var obj = objScreen;		  
    $.parser.parse(); // 解析整个页面  
    
    //初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"DTH");
	//医院科室联动
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","","","",HospID);
	    }
    });
	var nowDate = new Date();
	nowDate.setMonth(nowDate.getMonth()-1);
	obj.txtStartDate = $('#txtStartDate').datebox('setValue', Common_GetDate(nowDate)); // 日期初始赋值
	obj.txtEndDate = $('#txtEndDate').datebox('setValue', Common_GetDate(new Date()));
	//报告状态
	$HUI.combobox("#cboRepStatus",{
		onLoadSuccess:function(){
			var data=$(this).combobox('getData');
			if (data.length>0){
				//默认选中第一个状态：待审
				$(this).combobox('select',data[0]['DicRowId']);
				obj.gridDeathReportLoad()  //刷新当前页
			}
		}
	})
	obj.cboRepStatus = Common_ComboToDic("cboRepStatus","DTHRunningState","1");

   obj.gridDeathReport = $HUI.datagrid("#gridDeath",{
		fit: true,
		title:'死亡报告查询',
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'RowID',title:'操作',width:45,align:'center',
				formatter: function(value,row,index){
					if (value=="") return "";
					var ReportID = row["RowID"];
					var EpisodeID = row["EpisodeID"];
					var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenDeathReport(\'' + EpisodeID + '\',\'' + ReportID + '\')"></a>';
					return btn;
				}
			}, 
			{field:'PapmiNo',title:'登记号',width:'100'},
			{field:'MrNo',title:'病案号',width:'100'},
			{field:'PatName',title:'姓名',width:'100'},
			{field:'Sex',title:'性别',width:'50'},
			{field:'Age',title:'年龄',width:'50'},
			{field:'EncryptLevel',title:'密级',width:'80',hidden:(IsSecret==1 ? true:'')},
			{field:'PatLevel',title:'级别',width:'80',hidden:(IsSecret==1 ? true:'')}, 
			{field:'RepStatusDesc',title:'报告状态',width:'120'},
			{field:'RepUser',title:'上报人',width:'100'},
			{field:'RepLoc',title:'上报科室',width:'120'},				
			{field:'RepDateTime',title:'上报时间',width:'180'},	
			{field:'CheckDate',title:'打印明细',width:'70',
				formatter: function(value,row,index){
					if (value=="") return "";
					var ReportID = row["RowID"];
					
					var btn = '<a href="#" class="btn_search" onclick="objScreen.OpenPrintReason(\'' + ReportID + '\')"></a>';
					return btn;
				}
			},
			{field:'PrintReason',title:'重复打印原因',width:'200'}		
		]],
		onDblClickRow:function(index, row) {
			if (index>-1) {
				obj.gridDeathReport_click(row);
			}
		}
	});

	InitDMReportListEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


