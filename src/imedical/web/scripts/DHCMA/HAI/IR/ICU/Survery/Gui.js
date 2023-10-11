//ICU患者日志->Gui
var objScreen = new Object();
function InitSurveryWin() {
    var obj = objScreen;
   	
   	// 初始化下拉菜单(年-月)
	var YearList = $cm ({			//最近十年								
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryYear"
	},false);
	
	obj.ICUPatLogSplit = $m ({							
		ClassName:"DHCHAI.BT.Config",
		MethodName:"GetValByCode",
		aCode:"ICUPatLogSplit"
	},false);
	
	$HUI.combobox("#cboYear",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows
	});
	var MonthList = $cm ({			//1~12月							
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryMonth",
		aTypeID:1
	},false);
	$HUI.combobox("#cboMonth",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:MonthList.rows
	});
   
    //ICU患者日志[表]
    obj.gridICULogs = $HUI.datagrid("#gridICULogs", {
        fit: true,
        title: "ICU患者日志",
        iconCls: "icon-resort",
        headerCls: 'panel-header-gray',
        singleSelect: true,
        nowrap: true, 
        fitColumns: true,
        loadMsg: '数据加载中...',
        pageSize: 999,
        columns: [[
            {field: 'SurveryDay', title: '日期', width: 70, align: 'center',
                formatter: function (value, row, index) {
                    if (row.SurveryDay != $g("合计")) {
                        return "<a href='#' style='white-space:normal; text-decoration:underline;color:#339eff' onclick='objScreen.OpenICULocExt(\"" + row.SurveryDate + "\",\"" + row.LocDesc + "\");'>" + value + "</a>";
                    }
                    else {
                        return value;
                    }
                }
            },
            { field: 'AISItem1', title: '入科患者数', width: 100, align: 'center' },
            {
                field: 'AISItem2', title: '在科患者数', width: 100, align: 'center',
                formatter: function (value, row, index) {
                    if (row.SurveryDay != $g("合计")) {
                        return "<a href='#' style='white-space:normal;text-decoration:underline; color:#339eff' onclick='objScreen.OpenICULocExt(\"" + row.SurveryDate + "\",\"" + row.LocDesc + "\");'>" + value + "</a>";
                    }
                    else {
                        return value;
                    }
                }
            },
            { field: 'AISItem3', title: '出科患者数', width: 100, align: 'center' },
            { field: 'AISItem6', title: '泌尿道插管', width: 100, align: 'center' },
            { field: 'AISItem4', title: '呼吸机带管', width: 100, align: 'center' },
            { field: 'AISItem9', title: 'CVC', width: 100, align: 'center'},
            { field: 'AISItem5', title: 'PICC', width: 110, align: 'center'},
            { field: 'AISItem10', title: '血透(CRRT)', width: 100, align: 'center'},
            { field: 'AISItem11', title: '输液港(PORT)', width: 100, align: 'center'},
            { field: 'AISItem12', title: '中央血管导管(总人数)', width: 115, align: 'center'}
        ]],
        onLoadSuccess: function (data) {
            obj.tatal = data.total;   //获取原始数据行总数
            if (data.total > 1) {
                $('#gridICULogs').datagrid('appendRow', {
                    SurveryDay: $g('合计'),
                    AISItem1: '<span class="subtotal">' + obj.computeICU("AISItem1") + '</span>',
                    AISItem2: '<span class="subtotal">' + obj.computeICU("AISItem2") + '</span>',
                    AISItem3: '<span class="subtotal">' + obj.computeICU("AISItem3") + '</span>',
                    AISItem6: '<span class="subtotal">' + obj.computeICU("AISItem6") + '</span>',
                    AISItem4: '<span class="subtotal">' + obj.computeICU("AISItem4") + '</span>',
                    AISItem5: '<span class="subtotal">' + obj.computeICU("AISItem5") + '</span>',
                    AISItem9: '<span class="subtotal">' + obj.computeICU("AISItem9") + '</span>',
                    AISItem10: '<span class="subtotal">' + obj.computeICU("AISItem10") + '</span>',
                    AISItem11: '<span class="subtotal">' + obj.computeICU("AISItem11") + '</span>',
                    AISItem12: '<span class="subtotal">' + obj.computeICU("AISItem12") + '</span>'
                });
            }
            if (obj.ICUPatLogSplit!=1){
	            $('#gridICULogs').datagrid("hideColumn","AISItem9");
	            $('#gridICULogs').datagrid("hideColumn","AISItem10");
	            $('#gridICULogs').datagrid("hideColumn","AISItem11");
	            $('#gridICULogs').datagrid("hideColumn","AISItem12");
	            $('#gridICULogs').datagrid("getColumnOption","AISItem5").title = $g("中央血管导管");
            }
			dispalyEasyUILoad(); //隐藏效果
        }
    });
  
    InitSurveryWinEvent(obj);
    obj.LoadEvent();     //初始化信息
	return obj;
}