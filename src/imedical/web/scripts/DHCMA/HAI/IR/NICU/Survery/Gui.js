//NICU患者日志->Gui
var objScreen = new Object();
function InitSurveryWin() {
    var obj = objScreen;
   
   	// 初始化下拉菜单(年-月)
	var YearList = $cm ({			//最近十年								
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryYear"
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
   
    //NICU患者日志(Apgar评分)
    obj.gridNICULogsA = $HUI.datagrid("#gridNICULogsA", {
        fit: true,
        title: "NICU患者日志",
        iconCls: "icon-resort",
        headerCls: 'panel-header-gray',
        singleSelect: true,
        nowrap: true, 
        fitColumns: true,
        loadMsg: '数据加载中...',
  		pageSize: 999,
        columns: [
            [ {field: 'SurveryDay', title: '日期', width: 35, rowspan: 2,
                    formatter: function (value, row, index) {
                        if (row.SurveryDay != $g("合计")) {
                            return "<a href='#' style='white-space:normal;' onclick='objScreen.OpenNICULocExt(\"" + row.SurveryDate + "\",\"" + row.LocDesc + "\");'>" + value + "</a>";
                        }
                        else {
                            return value;
                        }
                    }
                },
                { title: '正常（8-10分）', align: 'left',  colspan: 4 },
                { title: '轻度窒息（4-7分）', align: 'left', colspan: 4 },
                { title: '重度窒息（0-3分）', align: 'left', colspan: 4 },
                { title: 'Apgar评分未填写', align: 'left', colspan: 4 }
            ], [
	            { field: 'AISItem1', title: $g('入科<br>新生<br>儿数'), width: 38 },
	            { field: 'AISItem2', title: $g('在科<br>新生<br>儿数'), width: 38},
	            { field: 'AISItem3', title: $g('中央血管<br>导管数'), width: 48 },
	            { field: 'AISItem4', title: $g('使用<br>呼吸<br>机数'), width: 38},
	            { field: 'AISItem5', title: $g('入科<br>新生<br>儿数'), width: 38},
	            { field: 'AISItem6', title: $g('在科<br>新生<br>儿数'), width: 38},
	            { field: 'AISItem7', title: $g('中央血管<br>导管数'), width: 48},
	            { field: 'AISItem8', title: $g('使用<br>呼吸<br>机数'), width: 38},
	            { field: 'AISItem9', title: $g('入科<br>新生<br>儿数'), width: 38},
	            { field: 'AISItem10', title: $g('在科<br>新生<br>儿数'), width: 38},
	            { field: 'AISItem11', title: $g('中央血管<br>导管数'), width: 48},
	            { field: 'AISItem12', title: $g('使用<br>呼吸<br>机数'), width: 38},
	            { field: 'AISItem13', title: $g('入科<br>新生<br>儿数'), width: 38},
	            { field: 'AISItem14', title: $g('在科<br>新生<br>儿数'), width: 38},
	            { field: 'AISItem15', title: $g('中央血管<br>导管数'), width: 48},
	            { field: 'AISItem16', title: $g('使用<br>呼吸<br>机数'), width: 38 }
         	]
        ],
        onLoadSuccess: function (data) {
            obj.tatal = data.total;   //获取原始数据行总数
            if (data.total > 1) {
                $('#gridNICULogsA').datagrid('appendRow', {
                    SurveryDay: $g('合计'),
                    AISItem1: '<span class="subtotal">' + obj.computeNICUA("AISItem1") + '</span>',
                    AISItem2: '<span class="subtotal">' + obj.computeNICUA("AISItem2") + '</span>',
                    AISItem3: '<span class="subtotal">' + obj.computeNICUA("AISItem3") + '</span>',
                    AISItem4: '<span class="subtotal">' + obj.computeNICUA("AISItem4") + '</span>',
                    AISItem5: '<span class="subtotal">' + obj.computeNICUA("AISItem5") + '</span>',
                    AISItem6: '<span class="subtotal">' + obj.computeNICUA("AISItem6") + '</span>',
                    AISItem7: '<span class="subtotal">' + obj.computeNICUA("AISItem7") + '</span>',
                    AISItem8: '<span class="subtotal">' + obj.computeNICUA("AISItem8") + '</span>',
                    AISItem9: '<span class="subtotal">' + obj.computeNICUA("AISItem9") + '</span>',
                    AISItem10: '<span class="subtotal">' + obj.computeNICUA("AISItem10") + '</span>',
                    AISItem11: '<span class="subtotal">' + obj.computeNICUA("AISItem11") + '</span>',
                    AISItem12: '<span class="subtotal">' + obj.computeNICUA("AISItem12") + '</span>',
                    AISItem13: '<span class="subtotal">' + obj.computeNICUA("AISItem13") + '</span>',
                    AISItem14: '<span class="subtotal">' + obj.computeNICUA("AISItem14") + '</span>',
                    AISItem15: '<span class="subtotal">' + obj.computeNICUA("AISItem15") + '</span>',
                    AISItem16: '<span class="subtotal">' + obj.computeNICUA("AISItem16") + '</span>',
                });
            }
			dispalyEasyUILoad(); //隐藏效果
        }
    });
    //NICU患者日志(体重)
    obj.gridNICULogsW = $HUI.datagrid("#gridNICULogsW", {
        fit: true,
        title: "NICU患者日志",
        iconCls: "icon-resort",
        headerCls: 'panel-header-gray',
        singleSelect: true,
        nowrap: true, fitColumns: true,
        loadMsg: '数据加载中...',
        pageSize: 999,
        columns: [
            [ {field: 'SurveryDay', title: '日期', width: 35, rowspan: 2,
                    formatter: function (value, row, index) {
                        if (row.SurveryDay != $g("合计")) {
                            return "<a href='#' style='white-space:normal;' onclick='objScreen.OpenNICULocExt(\"" + row.SurveryDate + "\",\"" + row.LocDesc + "\");'>" + value + "</a>";
                        }
                        else {
                            return value;
                        }
                    }
                },
                { title: 'BW≤1000g', align: 'left', colspan: 4 },
                { title: 'BW 1001g~1500g', align: 'left', colspan: 4 },
                { title: 'BW 1501g~2500g', align: 'left', colspan: 4 },
                { title: 'BW>2500g', align: 'left', colspan: 4 },
                { title: 'BW未填写', align: 'left', colspan: 4 }
            ], [
	            { field: 'AISItem1', title: $g('入科<br>新生<br>儿数'), width: 38 },
	            { field: 'AISItem2', title: $g('在科<br>新生<br>儿数'), width: 38},
	            { field: 'AISItem3', title: $g('中央血管<br>导管数'), width: 48 },
	            { field: 'AISItem4', title: $g('使用<br>呼吸<br>机数'), width: 38 },
	            { field: 'AISItem5', title: $g('入科<br>新生<br>儿数'), width: 38 },
	            { field: 'AISItem6', title: $g('在科<br>新生<br>儿数'), width: 38 },
	            { field: 'AISItem7', title: $g('中央血管<br>导管数'), width: 48 },
	            { field: 'AISItem8', title: $g('使用<br>呼吸<br>机数'), width: 38 },
	            { field: 'AISItem9', title: $g('入科<br>新生<br>儿数'), width: 38 },
	            { field: 'AISItem10', title: $g('在科<br>新生<br>儿数'), width: 38 },
	            { field: 'AISItem11', title: $g('中央血管<br>导管数'), width: 48 },
	            { field: 'AISItem12', title: $g('使用<br>呼吸<br>机数'), width: 38 },
	            { field: 'AISItem13', title: $g('入科<br>新生<br>儿数'), width: 38 },
	            { field: 'AISItem14', title: $g('在科<br>新生<br>儿数'), width: 38 },
	            { field: 'AISItem15', title: $g('中央血管<br>导管数'), width: 48 },
	            { field: 'AISItem16', title: $g('使用<br>呼吸<br>机数'), width: 38 },
	            { field: 'AISItem17', title: $g('入科<br>新生<br>儿数'), width: 38 },
	            { field: 'AISItem18', title: $g('在科<br>新生<br>儿数'), width: 38 },
	            { field: 'AISItem19', title: $g('中央血管<br>导管数'), width: 48 },
	            { field: 'AISItem20', title: $g('使用<br>呼吸<br>机数'), width: 38 }
	        ]
	    ],
        onLoadSuccess: function (data) {
            obj.tatal = data.total;   //获取原始数据行总数
            if (data.total > 1) {
                $('#gridNICULogsW').datagrid('appendRow', {
                    SurveryDay: $g('合计'),
                    AISItem1: '<span class="subtotal">' + obj.computeNICUW("AISItem1") + '</span>',
                    AISItem2: '<span class="subtotal">' + obj.computeNICUW("AISItem2") + '</span>',
                    AISItem3: '<span class="subtotal">' + obj.computeNICUW("AISItem3") + '</span>',
                    AISItem4: '<span class="subtotal">' + obj.computeNICUW("AISItem4") + '</span>',
                    AISItem5: '<span class="subtotal">' + obj.computeNICUW("AISItem5") + '</span>',
                    AISItem6: '<span class="subtotal">' + obj.computeNICUW("AISItem6") + '</span>',
                    AISItem7: '<span class="subtotal">' + obj.computeNICUW("AISItem7") + '</span>',
                    AISItem8: '<span class="subtotal">' + obj.computeNICUW("AISItem8") + '</span>',
                    AISItem9: '<span class="subtotal">' + obj.computeNICUW("AISItem9") + '</span>',
                    AISItem10: '<span class="subtotal">' + obj.computeNICUW("AISItem10") + '</span>',
                    AISItem11: '<span class="subtotal">' + obj.computeNICUW("AISItem11") + '</span>',
                    AISItem12: '<span class="subtotal">' + obj.computeNICUW("AISItem12") + '</span>',
                    AISItem13: '<span class="subtotal">' + obj.computeNICUW("AISItem13") + '</span>',
                    AISItem14: '<span class="subtotal">' + obj.computeNICUW("AISItem14") + '</span>',
                    AISItem15: '<span class="subtotal">' + obj.computeNICUW("AISItem15") + '</span>',
                    AISItem16: '<span class="subtotal">' + obj.computeNICUW("AISItem16") + '</span>',
                    AISItem17: '<span class="subtotal">' + obj.computeNICUW("AISItem17") + '</span>',
                    AISItem18: '<span class="subtotal">' + obj.computeNICUW("AISItem18") + '</span>',
                    AISItem19: '<span class="subtotal">' + obj.computeNICUW("AISItem19") + '</span>',
                    AISItem20: '<span class="subtotal">' + obj.computeNICUW("AISItem20") + '</span>'
                });
            }
			dispalyEasyUILoad(); //隐藏效果
        }
    });
    
    InitSurveryWinEvent(obj);
    obj.LoadEvent();     //初始化信息
	return obj;
}