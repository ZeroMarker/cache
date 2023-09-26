/*
  需先在csp定义textCollectForm的div，控件会自动嵌入其中。
  另定义一个js方法，用户双击表格的时候，将内容插入
*/

var urlTextCollector = '../EMRservice.Ajax.textCollector.cls';

//常用文本
$(function() {
    if ($('#locutionGrd').length == 0) {
        var html = '<div id="locutionPnl" title="" style="">';
        html = html + '<table id="locutionGrd" data-options="fit:true,border:false" style="">';
        html = html + '</table></div>';
        html = html + '<div id="textEditForm" class="easyui-dialog" title="" data-options="border:true,closed:true" style="width:360px;height:300px;padding:10px 20px">';
        html = html + '<div style="margin-bottom:5px">';
        html = html + '<div>分类:</div>';
        html = html + '<input id="textCate" class="easyui-textbox" type="text" data-options="required:true" style="width:100%;height:25px">';
        html = html + '</div>';
        html = html + '<div style="margin-bottom:5px">';
        html = html + '<div>摘要:</div>';
        html = html + '<input id="textSum" class="easyui-textbox" type="text" data-options="required:true" style="width:100%;height:25px">';
        html = html + '</div>';
        html = html + '<div style="margin-bottom:5px">';
        html = html + '<div>常用文本:</div>';
        html = html + '<textarea id="textContent" contentEditable="true" word-wrap="break-word" wrap="hard" style="width:100%;height:80px;overflow-y:auto;"></textarea>';
        html = html + '</div>';
        html = html + '</div>';
        html = html + '<div id="textCollectTool">';
        html = html + ' <a id="textAdd" href="javascript:void(0)" class="icon-add"></a>';
        html = html + ' <a id="textEdit" href="javascript:void(0)" class="icon-edit"></a>';
        html = html + ' <a id="textDel" href="javascript:void(0)" class="icon-remove"></a>';
        html = html + ' <a id="textReload" href="javascript:void(0)" class="icon-reload"></a>';
        html = html + '</div>';

        $('#textCollectForm').append(html);
        $('#locutionPnl').panel({
            fit: true,
            border: false,
            closable: false,
            tools: '#textCollectTool',
            title: '   '
        });
    }

    $('#locutionGrd').datagrid({
        view: detailview,
        url: '../EMRservice.Ajax.textCollector.cls?action=GetTextByUsrID&usrID=' + userID,
        fitColumns: true,
        singleSelect: true,
        columns: [
            [{
                field: 'id',
                title: 'ID',
                width: 0,
                hidden: true
            }, {
                field: 'category',
                title: '分类',
                width: 100
            }, {
                field: 'summary',
                title: '摘要',
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
            //alert(param);
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
