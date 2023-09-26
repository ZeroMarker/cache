//页面Gui
var objScreen = new Object();
function InitReportQryWin(){
	var obj = objScreen;		
    
    $.parser.parse(); // 解析整个页面  
    var nowdate = new Date();
    nowdate.setMonth(nowdate.getMonth()-1);
    var y = nowdate.getFullYear();
    var m = nowdate.getMonth()+1;
    var d = nowdate.getDate();
    var formatwdate = y+'-'+m+'-'+d;
    //初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"SMD");
	//医院科室联动
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","","","",HospID);
	    }
    });
	obj.dtDateFrom = $('#dtDateFrom').datebox('setValue',formatwdate); // 日期初始赋值
	obj.dtDateTo = $('#dtDateTo').datebox('setValue',Common_GetDate(new Date()));
	//报卡类型
	obj.cboRepType = Common_ComboToDic("cboRepType","SMDRepType","^全部类型",CTHospID);
	
	//报卡类型
    obj.AdmTypeList = Common_CheckboxToDic("chkAdmTypeList","SMDAdmType","2");
    //报卡状态checkbox
    obj.RepStatusList = Common_CheckboxToDic("chkRepStatusList","SMDRepStatus","2");
    var StatusList = document.getElementsByName("chkRepStatusList");
	for (var i=0; i<StatusList.length; i++) {
		if ($('#'+StatusList[i].id).attr("label")=="提交") {
			$('#'+StatusList[i].id).checkbox('check','check');	
		}
	}
   obj.gridSMDDQuery = $HUI.datagrid("#SMDDQuery",{
		fit: true,
		title:'精神疾病报告查询',
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		//singleSelect: true,
		checkOnSelect:true,
		selectOnCheck:false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'expander',title:'操作',width:45,align:'center',
				formatter: function(value,row,index){
					if (value=="") return "";
					var ReportID = row["ReportID"];
					
					var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenSMDReport(\'' + ReportID + '\')"></a>';
					return btn;
				}
			},
			{field: 'RepTypeDesc',title: '报告类别', width: 200},                                                                                                                                                       
			{field: 'PapmiNo',title: '登记号', width: 100},                                                                                                                                              
			{field: 'PatName',title: '姓名', width: 100},                                                                                                                                                
			{field: 'Sex',title: '性别', width: 40},                                                                                                                                                
			{field: 'Age',title: '年龄', width: 60},                                                                                                                                                
			{field: 'PersonalID',title: '证件号码', width: 180},                                                                                                                                           
			{field: 'DiseaseDesc',title: '诊断', width: 200},                                                                                                                                                                                                                                              
			{field: 'StatusDesc',title: '报告状态', width: 80,
				formatter: function(v,r,index){
					if (v == "草稿"){
						return "<span style='color:magenta'>"+ v +"</span>";
					} else if (v == "提交"){
						return "<span style='color:red'>"+ v +"</span>";
					} else if (v == "删除"){
						return "<span style='color:green'>"+ v +"</span>";
					} else if (v == "审核"){
						return "<span style='color:blue'>"+ v +"</span>";
					} else if (v == "取消审核"){
						return "<span style='color:pink'>"+ v +"</span>";
					} else {
						return  v;
					}
				}
			},    
			{field: 'CardNo',title: '卡片编号', width: 120,
				formatter: function(value,row,index){
					if (value=="") return "";
					var ReportID = row["ReportID"];
					var btn = '<a href="#" onclick="objScreen.OpenSMDReport(\'' + ReportID + '\')"><span style="color:blue">'+ value +'</span></a>';
					return btn;
				}
			},			
			{field: 'RepLocDesc',title: '报告科室', width: 150},                                                                                                                                           
			{field: 'RepUserDesc',title: '报告人', width: 100},                                                                                                                                              
			{field: 'RepDate',title: '报告日期', width: 100},                                                                                                                                            
			{field: 'RepTime',title: '报告时间', width: 80},                                                                                                                                            
			{field: 'CheckUserDesc',title: '审核人', width: 100},                                                                                                                                              
			{field: 'CheckDate',title: '审核日期', width: 100},                                                                                                                                            
			{field: 'CheckTime',title: '审核时间', width: 80},                                                                                                                                            
			{field: 'Contactor',title: '联系人姓名', width: 100},                                                                                                                                      
			{field: 'ContactorTel',title: '联系人电话', width: 120}
		]],onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
		}
	});

	InitReportQryWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


