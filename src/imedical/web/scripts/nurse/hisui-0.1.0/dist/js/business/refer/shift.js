/*
 * @Descripttion: �Ҽ�����-����
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
 * @description: ��������
 * @return {*}
 */
function initCondition() {
	getDateTime(1, 0, function (dt) {
		$('#shiftDate').datebox('setValue', dt);
	});
}

// ��ʼ��tab
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
			$.messager.popover({ msg: $g('δ���ý����Σ�'), type: 'alert' });
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
	// ��ʼ���������
    initTable(0);
    reloadShiftContent(0, shiftDate, GV.shiftTypeList[0].value);
}

// ��ʼ���������
function initTable(tabIndex) {
    $("#dg" + tabIndex).datagrid({
        columns: [[
            { field: 'reason', title: '������Ŀ', width: 150 },
            { field: 'content', title: '��������', width: 400 }
        ]],
        singleSelect: true,
        loadMsg: '������..',
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

// ��ѯ
function searchShift(){
	var shiftDate=$('#shiftDate').datebox("getValue");
	var tab = $('#clsTab').tabs('getSelected');
	var index = $('#clsTab').tabs('getTabIndex',tab);
	reloadShiftContent(index,shiftDate,GV.shiftTypeList[index].value);	
}

/**
 * @description: �����������
 */
function reloadData() {
	searchShift();
}