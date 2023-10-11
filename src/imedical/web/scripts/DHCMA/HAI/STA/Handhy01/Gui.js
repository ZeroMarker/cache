//手卫生统计图(Gui)
var objScreen = new Object();
function InitHand01Win() {
    var obj = objScreen;
	$.parser.parse();
	
    //初始化院区
	obj.cboHospital = Common_ComboToSSHosp("cboHospital", $.LOGON.HOSPID);
	//初始化日期类型
	$HUI.combobox("#cboDateType", {
	    data: [{ ID: ' SurveyDate', text: '调查日期', selected: true }],
	    valueField: 'ID',
	    textField: 'text'
	})
	//初始化日期
	Common_CreateMonth('dtDateFrom');   //年-月
	obj.dtDate = $('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));
	Common_CreateMonth('dtDateTo');   //年-月
	obj.dtDate = $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	//初始化调查病区
	//obj.cboInfLocation = Common_ComboToLoc("cboInfLocation", "", "", "", "");   
    //初始化统计类型(合计/职业/指征)
	$HUI.combobox("#cboSumType", {
		data: [
	    	{ ID: 'QryOpp1', text: '合计', selected: true },
	    	{ ID: 'QryOpp2', text: '职业'},
	    	{ ID: 'QryOpp3', text: '指征'}
	    ],
	    valueField: 'ID',
	    textField: 'text'
	})
	
	//手卫生统计表
	obj.gridHandHyReg = $HUI.datagrid("#gridHandHyReg", {
    	fit:true,
    	title: '手卫生统计图',
     	headerCls: 'panel-header-gray',
     	iconCls: 'icon-paper',
     	singleSelect: true,
     	nowrap: true, fitColumns: true,     //自动宽度
     	loadMsg: '数据加载中...',
     	columns: [[
         	{ field: 'CatDesc', title: '名称', width: 160, align: 'center'},
        	{ field: 'Value1', title: '调查时机数', width: 170, align: 'center' },
        	{ field: 'Value2', title: '依从数', width: 170, align: 'center'},
     		{ field: 'Value3', title: '正确数', width: 170, align: 'center' },
       		{ field: 'Radio1', title: '依从率', width: 170, align: 'center' },
        	{ field: 'Radio2', title: '正确率', width: 170, align: 'center' },
          	{ field: 'ECPatCount', title: '调查人数', width: 170, align: 'center' }
     	]]
	});
	
	InitHand01WinEvent(obj);
	return obj;
}
