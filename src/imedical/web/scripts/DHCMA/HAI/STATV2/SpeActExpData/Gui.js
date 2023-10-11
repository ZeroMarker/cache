$(function () {
	InitDischPatientWin();
});
//页面Gui
var objScreen = new Object();
function InitDischPatientWin(){
	var obj = objScreen;
   
    
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	// 日期赋初始值
	var YearList = $cm ({									//初始化年(最近十年)
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryYear"
	},false);
	$HUI.combobox("#cboYear",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//更改开始-结束日期
		}
	});
	var MonthList = $cm ({									//初始化月+季度+全年
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryMonth",
		aTypeID:1
	},false);
	$HUI.combobox("#cboMonth",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:MonthList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//更改开始-结束日期
		}
	});
	var NowDate=month_formatter(new Date());
	var NowYear=NowDate.split("-")[0];	//当前年
	var NowMonth=NowDate.split("-")[1]	//当前月
	$('#cboYear').combobox('select',NowYear);
	$('#cboMonth').combobox('select',NowMonth);

    obj.gridDischPatient = $HUI.datagrid("#DischPatient",{
		fit: true,
		//title:'患者查询',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:false,		
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200,1000],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.STATV2.SpeActSentHosp",
			QueryName:"QryinOutHosp",
			aHospIDs:$('#cboHospital').combobox('getValue'),
			aDateFrom:$('#dtDateFrom').datebox('getValue'),
			aDateTo:$('#dtDateTo').datebox('getValue')
	    },	    
		columns:[[
			{field:'PatName',title:'姓名',width:100},
			{field:'PapmiNo',title:'登记号',width:110,sortable:true},	
			{field:'patientId',title:'病案号',width:110},
			{field:'visitId',title:'住院次数',width:80},
			{field:'sex',title:'性别',width:50,align:'center'},
			{field:'birthDay',title:'出生日期',width:100},		
			{field:'inHospAt',title:'入院时间',width:160,sortable:true},
			{field:'AdmLocDesc',title:'就诊科室',width:160,sortable:true},
			{field:'outHospAt',title:'出院时间',width:160,sortable:true},
			{field:'DishLocDesc',title:'出院科室',width:120,sortable:true},	
			{field:'expander',title:'摘要',width:60,align:'center',
				formatter: function(value,row,index){
					return " <a href='#' style='white-space:normal; color:blue' onclick='objScreen.OpenView(\"" + row.zyid + "\");'>摘要</a>";
				}
			},
			{field:'inHospDig',title:'入院诊断',width:200},
			{field:'outDig',title:'出院诊断',width:200},		
			{field:'otherDig',title:'其他诊断',width:250}
		]]
	});
	
	
	InitDischPatientWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


