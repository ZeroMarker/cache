/**
 * @author SongChao
 * @version 20180730
 * @description 需关注医嘱
 * @name nur.needcareorder.js
 */
var GV = {
    ClassName: "Nur.DHCADTDischarge",
    abnormalType: "Disch",
    episodeID: "",
    abnStat: ""

};
var init = function () {
	initPageDom();
    initEvent();
}
$(init)
function initPageDom() {
    initTypeBox();
    initStatBox();
    initPatTable();
    initOrderGrid();
    initPatSearchbox();
}
/**
 * @description 绑定页面元素事件
 */
function initEvent() {
    $('#ignoreBtn').bind('click', ignoreBtnClick);
    $('#hasIgnoreListBtn').bind('click', hasIgnoreListBtnClick);
    $('#saveIgnBtn').bind('click', saveIgnBtnClick);
    $('#closeIgnDlgBtn').bind('click', function () { $("#ignoreDlg").dialog('close'); });
    $('#seeOrdBtn').bind('click', seeOrdBtnClick);
    $('#saveSeeOrdDlgBtn').bind('click', saveSeeOrdDlgBtnClick);
    $('#closeSeeOrdDlgBtn').bind('click', function () { $("#seeOrdDlg").dialog('close'); });
    $('#execOrdBtn').bind('click', execOrdBtnClick);
    $('#cancelExecBtn').bind('click', cancelExecBtnClick);
    $('#refreshOrderGridBtn').bind('click', orderGridReload);
	$("#ignoreDlg").dialog({
		onClose:function(){
			$('#ignoreForm').form('clear');
		}
	});
	$("#seeOrdDlg").dialog({
		onClose:function(){
			$('#seeOrdForm').form('clear');
		}
	});
}
/**
 *@description 初始化患者列表
 */
function initPatTable() {
    var wardID = session["LOGON.WARDID"];
    var locID = session['LOGON.CTLOCID'];
	GV.episodeID = _EPISODEID;
    $('#patTable').datagrid({
        url: $URL + '?ClassName=' + GV.ClassName + '&MethodName=getWardPatListArray&wardID=' + wardID + '&locID=' + locID,
        onSelect: function (rowIndex, rowData) {
            setPatInfo(rowData);
            GV.episodeID = rowData.EpisodeID;
            orderGridReload();
        },
        autoSizeColumn: false,
        fitColumns: true,
        columns: [[
            { field: 'BedCode', title: '床号', width: 80, styler: removeGridBorder },
            { field: 'PatName', title: '姓名', width: 150, styler: removeGridBorder },
            { field: 'RegNo', title: '登记号', width: 110, styler: removeGridBorder }
        ]],
        idField: 'EpisodeID',
        singleSelect: true,
        width: 200,
        showHeader: false,
		onLoadSuccess:function(){
			var selectRec=getPatRecordByEpisode(GV.episodeID);
			if(selectRec!=""){
				$('#patTable').datagrid('selectRecord',selectRec)
			}
		}
    });
	
}
function getPatRecordByEpisode(episodeID) {
	var record = "";
	if (episodeID != "") {
		var patRows = $('#patTable').datagrid('getRows');
		record = patRows.find(function (row) {
				return row.EpisodeID == episodeID;
			});
	}
	return record;
}
/**
 * @description 去除grid边框
 * @param {*} value 
 * @param {*} row 
 * @param {*} index 
 */
function removeGridBorder(value, row, index) {
    return 'border:0;';
}
/**
 * @description 设置页面患者信息值
 * @param {} patInfo :患者信息json对象
 */
function setPatInfo(patInfo) {
    if (patInfo) {
        $('#pbarDiv').show();
    }
    for (var item in patInfo) {
        var domID = "#pbar" + item;
        $(domID).html(patInfo[item]);
    }
}
/**
 * @description 初始需关注类型列表
 */
function initTypeBox() {
    $('#typeBox').combobox({
        valueField: 'value',
        textField: 'label',
        data: [{
            label: '出院需关注',
            value: 'Disch',
            selected: true
        }, {
            label: '转科需关注',
            value: 'Trans'
        }, {
            label: '全部需关注',
            value: 'default'
        }],
        onSelect: typeBoxOnSelect
    })
}
/**
 * @description 需关注类型选中事件(选中重查询需关注类型)
 */
function typeBoxOnSelect(record) {
    $('#stateBox').combobox('clear');
    GV.abnormalType = record.value;
    var loadUrl = $URL + '?1=1&ClassName='+GV.ClassName+'&MethodName=getAbnormalStat&setType=' + GV.abnormalType;
    $('#stateBox').combobox('reload', loadUrl);
    orderGridReload();
}
/**
 * @description 初始需关注类型列表
 */
function initStatBox() {
    var setType = $('#typeBox').combobox('getValue');
    $('#stateBox').combobox({
        url: $URL + '?1=1&ClassName='+GV.ClassName+'&MethodName=getAbnormalStat&setType=' + setType,
        valueField: 'ID',
        textField: 'abnormalStat',
        onSelect: stateBoxOnSelect,
        onChange: function (newVal) {
            if (newVal == "") {
                $('#stateBox').combobox('clear');
                GV.abnStat = '';
                orderGridReload();
            }
        }
    })
}
function stateBoxOnSelect(record) {
    GV.abnStat = record.abnormalStat;
    orderGridReload();
}
/**
 * @description 初始化医嘱列表
 */
function initOrderGrid() {
    $("#orderGrid").datagrid({
        url: $URL,
        fit: true,
        striped: true, //是否显示斑马线效果
        border: false,
        autoRowHeight: false,
        showFooter: true,
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers: true, //如果为true, 则显示一个行号列
        pageSize: 2000,
        pageList: [2000, 4000, 6000, 8000],
        queryParams: {
            ClassName: 'Nur.DHCADTDischarge',
            MethodName: 'getAbnormalOrdList',
            AdmID: GV.episodeID,
            AbnormalType: GV.abnormalType,
            AbnStat: GV.abnStat
        }
    });
}

function orderGridReload() {
    $("#orderGrid").datagrid('reload', {
        ClassName: 'Nur.DHCADTDischarge',
        MethodName: 'getAbnormalOrdList',
        AdmID: GV.episodeID,
        AbnormalType: GV.abnormalType,
        AbnStat: GV.abnStat
    });
}
/**
 *@description 初始化搜索框
 */
function initPatSearchbox() {
    $('#patSearchbox').searchbox({
        searcher: function (value) {
        	var wardID = session["LOGON.WARDID"];
        	var locID = session['LOGON.CTLOCID'];
        	
        	$('#patTable').datagrid('reload', {
        		ClassName: GV.ClassName,
        		MethodName: 'getWardPatListArray',
        		wardID: wardID,
        		locID: locID,
        		searchStr: value
        	});
        },
        prompt: '请输入姓名、登记号、床号'
    });
}
/**
 * @description 忽略需关注按钮
 */
function ignoreBtnClick() {
    if (GV.episodeID != "") {
        var selections = $('#orderGrid').datagrid('getSelections');
        if (selections.length > 0) {
            $("#ignoreDlg").dialog('open');
            var currDateTime = getServerTime();
            $("#ignoreDateBox").datebox('setValue', currDateTime.date);
            $("#ignoreTimeBox").timespinner('setValue', currDateTime.time);
            $("#ignoreTimeBox").timespinner('isValid')
            $("#ignoreUserBox").val(session['LOGON.USERCODE']);
            $("#ignoreUserBox").validatebox('isValid');
        } else {
            $.messager.popover({
                msg: '请选中要忽略的医嘱!',
                type: 'alert'
            });
        }
    }
}
/**
 *@description 确认忽略
 */
function saveIgnBtnClick() {
    var ignoreDate = $("#ignoreDateBox").datebox('getValue');
    var ignoreTime = $("#ignoreTimeBox").timespinner('getValue');
    var ignorReason = $("#ignoreReasonBox").val();
    var ignoreUserCode = $("#ignoreUserBox").val();
    var pwd = $("#ignorePwdBox").val();
    var ifPass = passwordConfirm(ignoreUserCode, pwd);
	var isValid = $('#ignoreForm').form('validate');
    if (ifPass.result == "0"&&isValid) {
        var ignoreUserID = ifPass.userID;
        var selections = $('#orderGrid').datagrid('getSelections');
        var oeordArray = selections.map(function (rowData) {
            return rowData.oeoreID + "@" + rowData.abnormalID + "@" + rowData.abnType;
        });
        var oeordAbnormalStatStr = oeordArray.join('^');
        $m({
            ClassName: "Nur.DHCADTDischarge",
            MethodName: "ignorSelectedOrder",
            EpisodeID: GV.episodeID,
            IgnoreUser: ignoreUserID,
            IgnoreDate: ignoreDate,
            IgnoreTime: ignoreTime,
            IgnorReason: ignorReason,
            oeordAbnormalStatStr: oeordAbnormalStatStr
        }, function (txtData) {
            if (txtData == 0) {
                $("#ignoreDlg").dialog('close');
                $.messager.popover({ msg: "忽略成功", type: 'success' });
                orderGridReload();
            } else {
                parent.$.messager.popover({ msg: (txtData == "" ? "操作失败！" : txtData), type: 'alert' });
            }
        });
    } else {
		if(isValid){
			parent.$.messager.popover({ msg: ifPass.result, type: 'alert' });
		}
    }
}
/**
 *@description 获取需处理医嘱数组
 * @returns array
 */
function getSeeOrdArray() {
    var selections = $('#orderGrid').datagrid('getSelections');
    var oeordArray = [];
    for (j = 0, len = selections.length; j < len; j++) {
        var rowData = selections[j];
        if (rowData.abnormalStat == '需处理医嘱'||rowData.abnormalStat == '停止未处理') {
            oeordArray.push(rowData.oeoreID);
        }
    }
    return oeordArray;
}
/**
 *@description  处理按钮点击
 */
function seeOrdBtnClick() {
    if (GV.episodeID != "") {
        var oeordArray = getSeeOrdArray();
        if (oeordArray.length > 0) {
            $("#seeOrdDlg").dialog('open');
            initSeeTypeBox();
            var currDateTime = getServerTime();
            $("#seeOrdDateBox").datebox('setValue', currDateTime.date);
            $("#seeOrdTimeBox").timespinner('setValue', currDateTime.time);
            $("#seeOrdTimeBox").timespinner('isValid')
            $("#seeOrdUserBox").val(session['LOGON.USERCODE']);
            $("#seeOrdUserBox").validatebox('isValid');
        } else {
            $.messager.popover({
                msg: '请选中要处理的医嘱!',
                type: 'alert'
            });
        }
    }
}

/**
 * @description 初始医嘱处理类型列表
 */
function initSeeTypeBox() {
    $('#seeTypeBox').combobox({
        valueField: 'value',
        textField: 'label',
        data: [{
            label: '接受',
            value: 'A',
            selected: true
        }, {
            label: '拒绝',
            value: 'R'
        }, {
            label: '完成',
            value: 'F'
        }]
    })
}
/**
 *@description 处理医嘱
 */
function saveSeeOrdDlgBtnClick() {
    //var ret=tkMakeServerCall("web.DHCLCNUREXCUTE","SeeOrder",oeoriId,userId,objSeeType,SeeNote,SeeDate,SeeTime);
    var userCode = $("#seeOrdUserBox").val();
    var pwd = $("#seeOrdPwdBox").val();
    var ifPass = passwordConfirm(userCode, pwd);
    if (ifPass.result == "0") {
        var userID = ifPass.userID;
        var note = $("#seeOrdNoteBox").val();
        var oeoriIdStr = getSeeOrdArray().join("^");
        var seeType = $('#seeTypeBox').combobox('getValue');
        var seeDate = $('#seeOrdDateBox').datebox('getValue');
        var seeTime = $('#seeOrdTimeBox').timespinner('getValue');
        $cm({
            ClassName: 'Nur.CommonInterface.OrderHandle',
            MethodName: 'SeeOrderChunks',
            oeoriIdStr: oeoriIdStr,
            userId: userID,
            type: seeType,
            note: note,
            date: seeDate,
            time: seeTime
        }, function (jsonData) {
            if (jsonData.success == "0") {
                $("#seeOrdDlg").dialog('close');
                $.messager.popover({ msg: "处理成功", type: 'success' });
                orderGridReload();
            } else {
                parent.$.messager.popover({ msg: jsonData.errList.join(';'), type: 'alert' });
            }
        });
    } else {
        parent.$.messager.popover({ msg: ifPass.result, type: 'alert' });
    }
}

/**
 *@description 执行医嘱
 */
function execOrdBtnClick() {
    updateOrdGroup("F", "WZX");
}
/**
 *@description 调用后台
 * @param {*} execStatusCode
 * @param {*} queryTypeCode
 */
function updateOrdGroup(execStatusCode, queryTypeCode) {
    var selections = $('#orderGrid').datagrid('getSelections');
    var oeordArray = [];
	var needCareList=[];
    for (j = 0, len = selections.length; j < len; j++) {
        var rowData = selections[j];
		if(rowData.abnormalStat!= '需处理医嘱'){
			if (execStatusCode=="F"&&(rowData.execStat == '未执行'||rowData.execStat == '撤销执行')) {
				oeordArray.push(rowData);
			}
			if(execStatusCode=="C"&&rowData.execStat == '已执行'){
				oeordArray.push(rowData);
			}
		}else{
			needCareList.push(rowData.oeoreID + " " + rowData.arcimDesc)
		}
    }
	if (needCareList.length > 0) {
		$.messager.popover({
			msg: "以下医嘱请先处理,再执行:<br/>" + needCareList.join("<br/>"),
			type: 'alert',
			timeout:5000
		});
	}
    var errList = [];
    if (oeordArray.length > 0) {
		var ordCount=0;
    	oeordArray.forEach(function (ordItem) {
    		$m({
    			ClassName: 'Nur.CommonInterface.OrderHandle',
    			MethodName: 'UpdateOrdGroup',
    			setSkinTest: '',
    			oeoreId: ordItem.oeoreID,
    			execStatusCode: execStatusCode,
    			userId: session['LOGON.USERID'],
    			userDeptId: session['LOGON.CTLOCID'],
    			queryTypeCode: queryTypeCode,
    			execDate: ordItem.sttDate,
    			execTime: ordItem.sttTime,
    			changeReasonDr: '',
    			groupID: session['LOGON.GROUPID']
    		}, function (txtData) {
				ordCount++;
    			if (txtData != "0") {
    				errList.push(ordItem.oeoreID + " " + ordItem.arcimDesc + "执行失败:" + txtData);
    			}				
				if(ordCount==oeordArray.length){
					callback();
				}
    		});
    	});
		function callback(){
			if (errList.length > 0) {
				$.messager.popover({
					msg: errList.join(";"),
					type: 'alert'
				});
				orderGridReload();
			} else {
				var msgInfo="";
				if (execStatusCode == "F") msgInfo="执行成功";
				if (execStatusCode == "C") msgInfo="撤销执行成功";
				$.messager.popover({msg: msgInfo,type: 'success'});
				orderGridReload();
			}
		}
    }
    else {
		var msgInfo="";
		if (execStatusCode == "F"&&needCareList.length==0) msgInfo="请选中未执行的医嘱";
		if (execStatusCode == "C"&&needCareList.length==0) msgInfo="请选中已执行的医嘱";
		if (msgInfo!="") $.messager.popover({msg: msgInfo,type: 'alert'});    	
    }
}
/**
 *@description 撤销执行
 */
function cancelExecBtnClick() {
    updateOrdGroup("C", "WZX");
}

/**
 *@description 已忽略列表按钮
 */
function hasIgnoreListBtnClick() {
    $('#ignoreListWin').window('open');
    $("#ignoreListGrid").datagrid({
        url: $URL,
        fit: true,
        striped: true, //是否显示斑马线效果
        border: false,
        autoRowHeight: false,
        showFooter: false,
        pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers: true, //如果为true, 则显示一个行号列
        pageSize: 20000,
        pageList: [20000, 40000, 60000, 80000],
        toolbar: [{
            id: 'cancelIngBtn',
            text: '撤销',
            iconCls: 'icon-arrow-right-top',
            handler: cancelIngBtnClick
        }],
        queryParams: {
            ClassName: 'Nur.DHCADTDischarge',
            MethodName: 'getIgnorOrderList',
            EpisodeID: GV.episodeID
        }
    });
}
/**
 *@description 撤销忽略
 */
function cancelIngBtnClick() {
    //var retStr = tkMakeServerCall("Nur.DHCADTDischarge", , oeoreIDstr, userID);
    var selections = $("#ignoreListGrid").datagrid('getSelections');
    if (selections.length > 0) {
        var array = selections.map(function (rowData) {
            return rowData.ignoreOeoreID;
        })
        $m({
            ClassName: "Nur.DHCADTDischarge",
            MethodName: "cancelIgnorOrder",
            oeoreIDStr: array.join("^"),
            userID: session['LOGON.USERID']
        }, function (txtData) {
            if (txtData == '0') {
                $.messager.popover({ msg: "操作成功!", type: "alert" });
                $("#ignoreListGrid").datagrid('reload');
            } else {
                $.messager.popover({ msg: txtData, type: "alert" });
                return;
            }
        })
    }
    else {
        $.messager.popover({ msg: "请选择撤销项目!", type: "alert" });
    }

}