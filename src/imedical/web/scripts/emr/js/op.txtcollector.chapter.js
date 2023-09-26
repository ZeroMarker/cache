/*
  需先在csp定义textCollectForm的div，控件会自动嵌入其中。
  另定义一个js方法，用户双击表格的时候，将内容插入
*/
var textCollector = new Object();
textCollector.urlTextCollector = '../EMRservice.Ajax.textCollector.cls';

//常用文本
$(function() {
    $('#dgDisease').datagrid({
        view: detailview,
        url: textCollector.urlTextCollector + '?action=GetDiseaseForGrd&usrID=' + userID + '&ctloc=' + userLocID,
        fitColumns: true,
        singleSelect: true,
        height: 'auto',
        columns: [
            [{
                field: 'id',
                title: 'ID',
                width: 0,
                hidden: true
            }, {
                field: 'name',
                title: '',
                width: 200
            }]
        ],
        detailFormatter: function(index, row) {
            return '<div style="padding:2px"><table id="dgText_' + index + '" class="easyui-datagrid" data-options="fitColumns:true,singleSelect:true" isLoad=false></table></div>';
        },
        onSelect: function(index, row) {
            unselectAlldgText();
        },
        onExpandRow: function(index, row) {
            //debugger;
            var ddv = $(this).datagrid('getRowDetail', index).find('table.easyui-datagrid');

            var diseaseID = row.id;
            var urlGetCate = textCollector.urlTextCollector + '?action=GetCategoryForGrd&diseaseID=' + diseaseID;
            ddv.datagrid({
                view: detailview,
                url: urlGetCate,
                height: 'auto',
                columns: [
                    [{
                        field: 'id',
                        title: 'ID',
                        width: 0,
                        hidden: true
                    }, {
                        field: 'name',
                        title: '',
                        width: 200
                    }]
                ],
                onResize: function() {
                    $('#dgDisease').datagrid('fixDetailRowHeight', index);
                },
                onLoadSuccess: function() {
                    setTimeout(function() {
                        $('#dgDisease').datagrid('fixDetailRowHeight', index);
                        ddv.attr('isLoad', true);
                    }, 0);
                },
                onDblClickRow: function(idxText, rowText) {
                    //debugger;
                    var param = getTextContent(rowText.id).replace(/\"/g, "\\\"").replace(/\r?\n/g, "\\n");
                    param = "{\"action\":\"insertText\",\"text\":\"" + param + "\"}"
                    setCollectText(param);
                },
                onSelect: function(idxText, rowText) {
                    unselectAlldgText();
                    var parentRowIdx = $(this).attr('id').split('_')[1];
                    $('#dgDisease').datagrid('selectRow', parentRowIdx);

                },
                detailFormatter: function(idxText, rowText) {
                    return '<div style="padding:2px"><table id="dg1Text_' + idxText + '" class="easyui-datagrid" data-options="fitColumns:true,singleSelect:true" isLoad=false></table></div>';
                },
                onExpandRow: function(idxText, rowText) {
                    var ddv1 = $(this).datagrid('getRowDetail', idxText).find('table.easyui-datagrid');

                    var diseaseID = 167;
                    var categoryID = rowText.id;
                    var chapterID = $('#cboChapter').combobox('getValue');;
                    var urlGetText = textCollector.urlTextCollector + '?action=GetText&usrID=' + userID + '&ctloc=' + userLocID + '&DiseaseID=' + diseaseID + '&CategoryID=' + categoryID + '&ChapterID=' + chapterID;
                    //alert(urlGetText);
                    ddv1.datagrid({
                        url: urlGetText,
                        height: 'auto',
                        columns: [
                            [{
                                field: 'id',
                                title: 'ID',
                                width: 0,
                                hidden: true
                            }, {
                                field: 'summary',
                                title: '',
                                width: 200
                            }, {
                                field: 'usrID',
                                title: '',
                                width: 0,
                                hidden: true
                            }]
                        ],
                        onResize: function() {
                            $('#dgText_' + idxText).datagrid('fixDetailRowHeight', idxText);
                        },
                        onLoadSuccess: function() {
                            setTimeout(function() {
                                $('#dgText_' + idxText).datagrid('fixDetailRowHeight', idxText);
                                ddv.attr('isLoad', true);
                            }, 0);
                        }
                    });
                    //debugger;
                    $('#dgText_' + idxText).datagrid('fixDetailRowHeight', idxText);
                }
            });
        }
    });

    $('#textEditForm').dialog({
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true
    });
    //debugger;
    $('#cboChapter').combobox({
        url: '../EMRservice.Ajax.textCollector.cls?action=GetChapterForCombox&ctloc=' + userLocID,
        method: 'get',
        valueField: 'value',
        textField: 'text',
        groupField: 'group',
        onSelect: function(record) {
            $('#dgDisease').datagrid('reload');
        }
    });

    //新增常用文本
    $('#textAdd').bind('click', function(event) {
        //debugger;
        var row = $('#dgDisease').datagrid('getSelected');
        if (!row) {
            return;
        };
        var chapterID = row.id;

        var diseaseID = $('#cboDisease').combobox('getValue');
        var categoryID = '';
        var IDs = diseaseID.split('^');
        if ('' != IDs || 2 == IDs.length) {
            diseaseID = IDs[0];
            categoryID = IDs[1];
        }

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
                    var summary = $('#textSum').val();
                    var content = $('#textContent').val();
                    if (saveTextCollect('', diseaseID, chapterID, categoryID, summary, content))
                        $('#dgDisease').datagrid('reload');
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
        //debugger;
        var rowChapter = $('#dgDisease').datagrid('getSelected');
        if (!rowChapter) return;
        var idx = $('#dgDisease').datagrid('getRowIndex', rowChapter);
        var row = $('#dgText_' + idx).datagrid('getSelected');
        if (!row) {
            return;
        };
        var chapterID = row.id;

        var diseaseID = $('#cboDisease').combobox('getValue');
        var categoryID = '';
        var IDs = diseaseID.split('^');
        if ('' != IDs || 2 == IDs.length) {
            diseaseID = IDs[0];
            categoryID = IDs[1];
        }
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
                    var summary = $('#textSum').val();
                    var content = $('#textContent').val();
                    if (saveTextCollect(row.id, diseaseID, chapterID, categoryID, summary, content))
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
        var rowChapter = $('#dgDisease').datagrid('getSelected');
        if (!rowChapter) return;
        var idx = $('#dgDisease').datagrid('getRowIndex', rowChapter);
        var row = $('#dgText_' + idx).datagrid('getSelected');
        if (!row || row.usrID != userID) {
            return;
        };

        delTextCollect(row.id);
    });
    $('#textReload').bind('click', function() {
        $('#locutionGrd').datagrid('reload');
    });
});

function unselectAlldgText() {
    var tables = $("table[id^='dgText_']");

    for (var i = 0; i < tables.length; i++) {
        if ("false" == $(tables[i]).attr('isLoad')) {
            continue;
        }
        $(tables[i]).datagrid('unselectAll');
    };
}

function getTextContent(rowId) {
    var result = '';
    $.ajax({
        type: 'POST',
        dataType: 'text',
        url: textCollector.urlTextCollector,
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
        url: textCollector.urlTextCollector,
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

function saveTextCollect(id, diseaseID, chapterID, categoryID, summary, content) {

    var result = false;
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: textCollector.urlTextCollector,
        async: false,
        cache: false,
        data: {
            action: 'SaveTextCollect',
            id: id,
            diseaseID: diseaseID,
            chapterID: chapterID,
            categoryID: categoryID,
            summary: summary,
            content: content,
            usrID: '' //userID
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
