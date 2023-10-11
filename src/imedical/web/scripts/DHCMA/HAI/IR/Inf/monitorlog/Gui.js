//XX监测日志->Gui

function InitILogWin(obj) {
   	obj.LocDr=LocDr   
    obj.LocDesc=LocDesc  
    //XX监测日志[表]
    obj.gridLog = $HUI.datagrid("#gridLog", {
        fit: true,
       // title: "XX监测日志",
        iconCls: "icon-resort",
        headerCls: 'panel-header-gray',
        singleSelect: true,
        nowrap: true, 
        fitColumns: true,
        loadMsg: '数据加载中...',
        pageSize: 999,
        columns: [[
            {field: 'SurveryDay', title: '日期', width: 100, align: 'center',
                formatter: function (value, row, index) {
                    if (row.SurveryDay != "合计") {
                        return "<a href='#' style='white-space:normal; color:blue' onclick='obj.OpenICULocExt(\"" + row.SurveryDate + "\",\"" + row.LocDesc + "\");'>" + value + "</a>";
                    }
                    else {
                        return value;
                    }
                }
            },
            { field: 'AISItem1', title: '入科患者数', width: 110, align: 'center' },
            {
                field: 'AISItem2', title: '在科患者数', width: 110, align: 'center',
                formatter: function (value, row, index) {
                    if (row.SurveryDay != "合计") {
                        return "<a href='#' style='white-space:normal; color:blue' onclick='obj.OpenICULocExt(\"" + row.SurveryDate + "\",\"" + row.LocDesc + "\");'>" + value + "</a>";
                    }
                    else {
                        return value;
                    }
                }
            },
            { field: 'AISItem3', title: '出科患者数', width: 110, align: 'center' },
            { field: 'AISItem6', title: '泌尿道插管', width: 115, align: 'center' },
            { field: 'AISItem4', title: '呼吸机带管', width: 115, align: 'center' },
            { field: 'AISItem5', title: '中心静脉置管', width: 115, align: 'center'}
        ]],
        onLoadSuccess: function (data) {
            obj.tatal = data.total;   //获取原始数据行总数
            if (data.total > 1) {
                $('#gridLog').datagrid('appendRow', {
                    SurveryDay: '合计',
                    AISItem1: '<span class="subtotal">' + obj.computeICU("AISItem1") + '</span>',
                    AISItem2: '<span class="subtotal">' + obj.computeICU("AISItem2") + '</span>',
                    AISItem3: '<span class="subtotal">' + obj.computeICU("AISItem3") + '</span>',
                    AISItem6: '<span class="subtotal">' + obj.computeICU("AISItem6") + '</span>',
                    AISItem4: '<span class="subtotal">' + obj.computeICU("AISItem4") + '</span>',
                    AISItem5: '<span class="subtotal">' + obj.computeICU("AISItem5") + '</span>',
                });
            }
			dispalyEasyUILoad(); //隐藏效果
        }
    });
  
    InitLogWinEvent(obj);
    obj.LoadEvent();     //初始化信息
	return obj;
}