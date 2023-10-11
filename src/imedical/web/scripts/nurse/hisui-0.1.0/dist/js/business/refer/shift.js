/*
 * @Descripttion: 右键引用-交班
 * @Author: yaojining
 */

var GV = {
    code: 'Shift',
    groupID: 'groupShift',
    hospitalID: session['LOGON.HOSPID'],
    className: 'NurMp.Service.Refer.Handle',
    shiftTypeList: new Array(),
    ConfigInfo: new Object(),
    shiftTypeList: new Object(),
    OtherConfig: new Object()
};

$(function () {
	initConditions();
	requestConfig(initTabs);
	listenEvents();
});

/**
 * @description: 请求配置
 * @return {*}
 */
function initCondition() {
	getDateTime(1, 0, function (dt) {
		$('#shiftDate').datebox('setValue', dt);
	});
}

// 初始化tab
function initTabs(config) {
    $('#clsTab').tabs({
        onSelect: function (title, index) {
            var shiftDate = $('#shiftDate').datebox('getValue');
            initTable(index);
            reloadShiftContent(index, shiftDate, GV.shiftTypeList[index].value);
        }
    });
    $cm({
        ClassName: config.queryParams.ClassName,
        QueryName: config.queryParams.QueryName,
        Desc: '',
        WardID: session['LOGON.WARDID'],
        TJDate: $('#shiftDate').datebox('getValue'),
        rows: 99999
    }, function (data) {
	    GV.shiftTypeList = data.rows;
		if (data.rows.length == 0) {
			$.messager.popover({ msg: $g('未配置交班班次！'), type: 'alert' });
        	return false;
		}
        addTabs(data.rows);
    });
}

function addTabs(rows) {
	for (i = 0; i < rows.length; i++) {
		$('#clsTab').tabs('add', {
	        title: rows[i].text,
	        selected: i == 0 ? true : false,
	        content: '<div class="hisui-panel" data-options="fit:true,border:false" style="padding-top:2px;border-radius:0;"><div class="hisui-panel top_border_panel" style="border-top-color:#E2E2E2" data-options="fit:true,bodyCls:\'panel-body-gray\'"><table class="hisui-datagrid" data-options="fit:true,border:false" id="dg' + i + '" style="border-radius:0;"></table></div></div>'
	    });
	}
	// 初始化班次数据
    initTable(0);
    reloadShiftContent(0, shiftDate, GV.shiftTypeList[0].value);
}

// 初始化班次内容
function initTable(tabIndex) {
    $("#dg" + tabIndex).datagrid({
        columns: [[
            { field: 'reason', title: '交班项目', width: 150 },
            { field: 'content', title: '交班内容', width: 400 }
        ]],
        singleSelect: true,
        loadMsg: '加载中..',
    })
}

function reloadShiftContent(tabIndex,shiftDate,shiftType){
	$cm({
		ClassName: GV.ConfigInfo[GV.code].resultParams.ClassName,
		QueryName: GV.ConfigInfo[GV.code].resultParams.QueryName,
		WardID:session['LOGON.WARDID'],
		QDate:shiftDate,
		ShiftType:shiftType,
		ItemDR:"",
		rows:99999
	},function(data){
		var result=data.rows;
		if(result.length>0){					
			var array=result.filter(function(val,index){
				return (val.episodeID==EpisodeID && (val.reason!="" || val.content!=""))	
			})	
			data.rows=array;
		}
		$("#dg"+tabIndex).datagrid('loadData',data);				
	})	
}

// 查询
function searchShift(){
	var shiftDate=$('#shiftDate').datebox("getValue");
	var tab = $('#clsTab').tabs('getSelected');
	var index = $('#clsTab').tabs('getTabIndex',tab);
	reloadShiftContent(index,shiftDate,GV.shiftTypeList[index].value);	
}

/**
 * @description: 表格数据重载
 */
function reloadData() {
	searchShift();
}