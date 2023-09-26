//��ȡ easyui-datagrid ���ݴ洢���ڱ��
function easyuiDG_getTBody(tableid) {
    /*
    ��ȡeasyui datagrid �������ڵ�html ��� 
    cssclass datagrid-view2 �� easyui datagrid ����չʾtable���ڵ�div
    */
    var view2 = $('#' + tableid).prevAll('div.datagrid-view2');
    var table = view2.children('div.datagrid-body').children('table.datagrid-btable');

    return table;
}
//����ָ����
function easyuiDG_hideRow(tableid, index) {
    var tbody = easyuiDG_getTBody(tableid).children('tbody');//��ȡ easyui-datagrid ���ݴ洢���ڱ��
    tbody.children().eq(index).hide(); //����ָ����
    //�����ʾ�кŵĻ� �������к�
    if ($('#' + tableid).prevAll('div.datagrid-view1')) {
        var numbers = $('#' + tableid).prevAll('div.datagrid-view1')
            .children('div.datagrid-body')
            .children('div.datagrid-body-inner')
            .children('table.datagrid-btable')
            .children('tbody');
        numbers.children().eq(index).hide();//�����к�
    }
}
//����������
function easyuiDG_hideAllRow(tableid) {
    var tbody = easyuiDG_getTBody(tableid).children('tbody');//��ȡ easyui-datagrid ���ݴ洢���ڱ��
    for (var i = 0; i < tbody.children().length; i++) {
        tbody.children().eq(i).hide();
        //�����ʾ�кŵĻ� �������к�
        if ($('#' + tableid).prevAll('div.datagrid-view1')) {
            var numbers = $('#' + tableid).prevAll('div.datagrid-view1')
                .children('div.datagrid-body')
                .children('div.datagrid-body-inner')
                .children('table.datagrid-btable')
                .children('tbody');
            numbers.children().eq(i).hide();//�����к�
        }
    }
}
//��ʾָ����
function easyuiDG_ShowRow(tableid, index) {
    var tbody = easyuiDG_getTBody(tableid).children('tbody');//��ȡ easyui-datagrid ���ݴ洢���ڱ��
    tbody.children().eq(index).show(); //��ʾָ����
    //�����ʾ�кŵĻ� �������к�
    if ($('#' + tableid).prevAll('div.datagrid-view1')) {
        var numbers = $('#' + tableid).prevAll('div.datagrid-view1')
            .children('div.datagrid-body')
            .children('div.datagrid-body-inner')
            .children('table.datagrid-btable')
            .children('tbody');
        numbers.children().eq(index).show();//��ʾ�к�
    }
}
//��ʾ������
function easyuiDG_showAllRow(tableid) {
    var tbody = easyuiDG_getTBody(tableid).children('tbody');//��ȡ easyui-datagrid ���ݴ洢���ڱ��
    for (var i = 0; i < tbody.children().length; i++) {
        tbody.children().eq(i).show();
        //�����ʾ�кŵĻ� ����ʾ�к�
        if ($('#' + tableid).prevAll('div.datagrid-view1')) {
            var numbers = $('#' + tableid).prevAll('div.datagrid-view1')
                .children('div.datagrid-body')
                .children('div.datagrid-body-inner')
                .children('table.datagrid-btable')
                .children('tbody');
            numbers.children().eq(i).show();//��ʾ�к�
        }
    }
}
