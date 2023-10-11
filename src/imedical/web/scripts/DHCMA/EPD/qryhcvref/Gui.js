//页面Gui
var objScreen = new Object();

function InitviewScreen(){
	var obj = objScreen;		
    var nowdate = new Date();
    nowdate.setMonth(nowdate.getMonth()-1);
    var y = nowdate.getFullYear();
    var m = nowdate.getMonth()+1;
    var d = nowdate.getDate();
    var formatwdate = y+'-'+m+'-'+d;
    obj.dtStaDate = $('#dtStaDate').datebox('setValue', formatwdate);   // 日期初始赋值
    obj.dtEndDate = $('#dtEndDate').datebox('setValue', Common_GetDate(new Date()));
    //初始查询条件
    obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"EPD");

   obj.gridHcvQuery = $HUI.datagrid("#HcvQuery",{
		fit: true,
		title:'丙肝转介单查询列表',
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		//singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'expander',title:'操作',width:45,align:'center',
				formatter: function(value,row,index){
					var ReportID = row["ReportID"];
					var EpisodeID = row["EpisodeID"];					
					var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenHCVRefReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					return btn;
				}
			}, 
			{field:'RepStatus',title:'报告状态',width:80,align:'center'}, 
			{field:'ReportDate',title:'报告日期',width:130,align:'center'},
			{field:'RecHospName',title:'接收医疗机构名称',width:150,align:'center'},
			{field:'PatName',title:'姓名',width:120,align:'center'},
			{field:'PatSex',title:'性别',width:50,align:'center'},
			{field:'PersonalID',title:'身份证号',width:180,align:'center'},
			{field:'DetectionDesc',title:'丙肝抗体检测',width:130,align:'center'},
			{field:'ExamPlanDesc',title:'丙肝检验方案',width:130,align:'center'},
			{field:'RefTelPhone',title:'转介单位联系电话',width:140,align:'center'},
			{field:'RefDoctor',title:'转介医生',width:130,align:'center'},
			{field:'RefOrgName',title:'转介单位',width:200,align:'center'},
			{field:'Resume',title:'备注',width:150,align:'center',showTip:true}
		]],
		onDblClickRow:function(index, row) {
			if (index>-1) {				
				obj.gridReport_rowdbclick(row);
			}
		},onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
		}
	});

	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}