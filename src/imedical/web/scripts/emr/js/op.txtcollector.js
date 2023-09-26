/*
  需先在csp定义textCollectForm的div，控件会自动嵌入其中。
  另定义一个js方法，用户双击表格的时候，将内容插入
*/

var urlTextCollector = '../EMRservice.Ajax.textCollector.cls';

//常用文本
$(function() {
    $('#locutionGrd').datagrid({
        view: detailview,
        url: '../EMRservice.Ajax.textCollector.cls?action=GetTextByUsrID&usrID=' + userID,
        fitColumns: true,
        singleSelect: true,
        columns: [
            [{
                field: 'id',
                title: '',
                width: 0,
                hidden: true
            }, {
                field: 'category',
                title: '',
                width: 100
            }, {
                field: 'summary',
                title: '',
                width: 150
            }]
        ],
        detailFormatter: function(index, row) {
            return '<div class="ddv" style="width:100%;padding:5px 0"><textarea id="tb' + index + '" contentEditable="false" wrap="hard" style="width:100%;height:100%;overflow-y:auto;" value="">' + getTextContent(row.id) + '</textarea></div>';
        },
        onExpandRow: function(index, row) {
            var ddv = $(this).datagrid('getRowDetail', index).find('div.ddv');
            ddv.panel({
                height: 80,
                width: 300,
                border: false,
                cache: false,
                href: '',
                onLoad: function() {
                    $('#locutionGrd').datagrid('fixDetailRowHeight', index);
                    $(this).datagrid('getRowDetail', index).find('div.ddv').children('textarea').val(getTextContent(row.id));  
                }
            });
            $('#locutionGrd').datagrid('fixDetailRowHeight', index);

        },
        onDblClickRow: function(index, row) {
            var param = getTextContent(row.id).replace(/\"/g, "\\\"").replace(/\r?\n/g, "\\n");
            param = "{\"action\":\"insertText\",\"text\":\"" + param + "\"}"
            setCollectText(param);
        }
    });

    $('#textEditForm').dialog({
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true
    });

    //新增常用文本
    $('#textAdd').bind('click', function(event) {
        $('#textCate').val('');
        $('#textSum').val('');
        $('#textContent').val('');
        $('#textEditForm').dialog({
            left: event.pageX - 300,
            top: event.pageY + 40,
            title: '新增常用文本',
            buttons: [{
                text: '确定',
                iconCls: 'icon-ok',
                handler: function() {
                    //debugger;
                    if (saveTextCollect('', $('#textCate').val(), $('#textSum').val(), $('#textContent').val()))
                        $('#locutionGrd').datagrid('reload');
                    $('#textEditForm').dialog('close');
                }
            }, {
                text: '取消',
                handler: function() {
                    $('#textEditForm').dialog('close');
                }
            }]
        }).dialog('open');
    });

    //编辑常用文本
    $('#textEdit').bind('click', function(event) {
        var row = $('#locutionGrd').datagrid('getSelected');
        if (!row) return;

        $('#textCate').val(row.category);
        $('#textSum').val(row.summary);
        $('#textContent').val(getTextContent(row.id));
        $('#textEditForm').dialog({
            left: event.pageX - 320,
            top: event.pageY + 40,
            title: '编辑常用文本',
            buttons: [{
                text: '确定',
                iconCls: 'icon-ok',
                handler: function() {
                    if (saveTextCollect(row.id, $('#textCate').val(), $('#textSum').val(), $('#textContent').val()))
                        $('#locutionGrd').datagrid('reload');
                    $('#textEditForm').dialog('close');
                }
            }, {
                text: '取消',
                handler: function() {
                    $('#textEditForm').dialog('close');
                }
            }]
        }).dialog('open');
    });

    $('#textDel').bind('click', function() {
        var row = $('#locutionGrd').datagrid('getSelected');
        if (!row) return;

        delTextCollect(row.id);
    });
    $('#textReload').bind('click', function() {
        $('#locutionGrd').datagrid('reload');
    });
});


function getTextContent(rowId) {
    var result = '';
    $.ajax({
        type: 'POST',
        dataType: 'text',
        url: urlTextCollector,
        async: false,
        cache: false,
        data: {
            action: 'getContent',
            rowID: rowId
        },
        success: function(ret) {
            result = ret;
        },
        error: function(ret) {}
    });
    return result;
}

function delTextCollect(rowId) {
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: urlTextCollector,
        async: false,
        cache: false,
        data: {
            action: 'DelTextCollect',
            rowID: rowId
        },
        success: function(ret) {
            if (ret && ret.Err) {
                $.messager.alert('保存失败！', ret.Err);
            } else {
                $('#locutionGrd').datagrid('reload');
            }
        },
        error: function(ret) {}
    });

}

function saveTextCollect(id, category, summary, content) {
    var result = false;
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: urlTextCollector,
        async: false,
        cache: false,
        data: {
            action: 'SaveTextCollect',
            id: id,
            category: category,
            summary: summary,
            content: content,
            usrID: userID
        },
        success: function(ret) {
            if (ret && ret.Err) {
                $.messager.alert('保存失败！', ret.Err);
            } else {
                result = true;
            }
        },
        error: function(ret) {}
    });
    return result;
}
