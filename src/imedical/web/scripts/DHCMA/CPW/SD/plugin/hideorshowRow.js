//获取 easyui-datagrid 数据存储所在表格
function easyuiDG_getTBody(tableid) {
    /*
    获取easyui datagrid 数据所在的html 表格 
    cssclass datagrid-view2 是 easyui datagrid 数据展示table所在的div
    */
    var view2 = $('#' + tableid).prevAll('div.datagrid-view2');
    var table = view2.children('div.datagrid-body').children('table.datagrid-btable');

    return table;
}
//隐藏指定行
function easyuiDG_hideRow(tableid, index) {
    var tbody = easyuiDG_getTBody(tableid).children('tbody');//获取 easyui-datagrid 数据存储所在表格
    tbody.children().eq(index).hide(); //隐藏指定行
    //如果显示行号的话 则隐藏行号
    if ($('#' + tableid).prevAll('div.datagrid-view1')) {
        var numbers = $('#' + tableid).prevAll('div.datagrid-view1')
            .children('div.datagrid-body')
            .children('div.datagrid-body-inner')
            .children('table.datagrid-btable')
            .children('tbody');
        numbers.children().eq(index).hide();//隐藏行号
    }
}
//隐藏所有行
function easyuiDG_hideAllRow(tableid) {
    var tbody = easyuiDG_getTBody(tableid).children('tbody');//获取 easyui-datagrid 数据存储所在表格
    for (var i = 0; i < tbody.children().length; i++) {
        tbody.children().eq(i).hide();
        //如果显示行号的话 则隐藏行号
        if ($('#' + tableid).prevAll('div.datagrid-view1')) {
            var numbers = $('#' + tableid).prevAll('div.datagrid-view1')
                .children('div.datagrid-body')
                .children('div.datagrid-body-inner')
                .children('table.datagrid-btable')
                .children('tbody');
            numbers.children().eq(i).hide();//隐藏行号
        }
    }
}
//显示指定行
function easyuiDG_ShowRow(tableid, index) {
    var tbody = easyuiDG_getTBody(tableid).children('tbody');//获取 easyui-datagrid 数据存储所在表格
    tbody.children().eq(index).show(); //显示指定行
    //如果显示行号的话 则隐藏行号
    if ($('#' + tableid).prevAll('div.datagrid-view1')) {
        var numbers = $('#' + tableid).prevAll('div.datagrid-view1')
            .children('div.datagrid-body')
            .children('div.datagrid-body-inner')
            .children('table.datagrid-btable')
            .children('tbody');
        numbers.children().eq(index).show();//显示行号
    }
}
//显示所有行
function easyuiDG_showAllRow(tableid) {
    var tbody = easyuiDG_getTBody(tableid).children('tbody');//获取 easyui-datagrid 数据存储所在表格
    for (var i = 0; i < tbody.children().length; i++) {
        tbody.children().eq(i).show();
        //如果显示行号的话 则显示行号
        if ($('#' + tableid).prevAll('div.datagrid-view1')) {
            var numbers = $('#' + tableid).prevAll('div.datagrid-view1')
                .children('div.datagrid-body')
                .children('div.datagrid-body-inner')
                .children('table.datagrid-btable')
                .children('tbody');
            numbers.children().eq(i).show();//显示行号
        }
    }
}
