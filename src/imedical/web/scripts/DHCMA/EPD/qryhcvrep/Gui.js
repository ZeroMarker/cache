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
	//医院科室联动
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboReportLoc = Common_ComboToLoc("cboReportLoc","E|EM","","",HospID);
	    }
    });
	
	$('#cboDateType').combobox({      
		valueField:'Code',    
		textField:'Desc',
		data : [ {
			Code:'IndexReportDate', 
			Desc:'报告日期',
			"selected":true   
		},{
			Code:'IndexCheckDate', 
			Desc:'审核日期'
		}]
	});  
	
   obj.gridHcvQuery = $HUI.datagrid("#HcvQuery",{
		fit: true,
		title:"丙肝病例个案调查表查询",
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
					console.log(HISUIStyleCode);
					if (HISUIStyleCode=="lite"){
						var btn = '<span class="icon icon-paper" onclick="objScreen.OpenHCVReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></span>'
					}else{
						var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenHCVReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					}
					return btn;
				}
			}, 
			{field:'SerialNum',title:'流水号',width:80,align:'center'},
			{field:'StatusDesc',title:'报告状态',width:80,align:'center',
				 styler: function(value,row,index){
					var retStr = "", tmpStatusCode = row["StatusCode"];
					if (tmpStatusCode==1) {
						retStr =  'color:red;';
					} else if (tmpStatusCode==2) {
						retStr = 'color:green;';
					}else if (tmpStatusCode==3) {
						retStr = 'color:black;';
					} else if (tmpStatusCode==4) {
						retStr = 'color:blue;';
					} else if (tmpStatusCode==5) {
						retStr = 'color:gray;';
					} else {
						retStr = 'color:black;';
					} 
					return retStr;
				}
			}, 
			{field:'PapmiNo',title:'登记号',width:100},
			{field:'PatientName',title:'姓名',width:80},
			{field:'PatientSex',title:'性别',width:50,align:'center'},
			{field:'PatientAge',title:'年龄',width:50},
			{field:'TestPosDate',title:'首次抗体检测日期',width:130},
			{field:'TestMethodDesc',title:'首次抗体检测方法',width:130},
			{field:'TestReasonDesc',title:'首次抗体检测原因',width:140},
			{field:'ResultsDesc',title:'抗体复检结果',width:110},
			{field:'NucleinRet',title:'丙肝核酸检测结果',width:180},
			{field:'BloodDate',title:'采血日期',width:100},
			{field:'EntryDate',title:'网络直报录入日期',width:130},
			{field:'ReferResultDesc',title:'转介结果',width:170},
			{field:'RepUser',title:'填报人',width:80},
			{field:'RepDate',title:'填报日期',width:100},
			{field:'CheckUser',title:'审核人',width:80},
			{field:'CheckDate',title:'审核日期',width:100},
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