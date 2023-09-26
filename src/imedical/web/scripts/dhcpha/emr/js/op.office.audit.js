
$(function () {
    $('#patLst').panel('resize', {
        width: (screen.availWidth) * 0.382
    });
    $('body').layout('resize');

    initPatTable();

    $('.easyui-searchbox').searchbox({
        searcher: function (value, name) {
            var data;
            if ('regNoSearch' == this.id) {
                data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetOPPatList', value, '', '');
            } else if ('nameSearch' == this.id) {
                data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetOPPatList', '', value, '');
            } else if ('cardNoSearch' == this.id) {
                value = '0000000000' + value;
                value = value.substring(value.length - 10, value.length);
                $(this).searchbox('setValue', value);
                data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetOPPatList', '', '', value);
            }

            ajaxGET(data, function (ret) {
                if ('' != ret) {
                    var patData = $.parseJSON(ret);
                    $('#patientListData').datagrid('loadData', patData);
                }

            }, function (ret) {
                alert('GetOPPatList error:' + ret);
            });
        },
        prompt: '请输入'
    });
    $('#cardNoSearch').searchbox('textbox').focus();
	initPnlButton();
    //处理编辑器
    $('#editorFrame').attr('src', 'emr.op.editor.csp');
});

//  emr.op.editor.csp invoke
function initEditor() {
    emrEditor.newEmrPlugin();
    emrEditor.initDocument(false);
}

// 更新病历页面内容
function switchEMRContent(_patientID, _episodeID, _mradm) {
    if (_episodeID == patInfo.EpisodeID)
        return;
    //全局参数替换
    patInfo.PatientID = _patientID;
    patInfo.EpisodeID = _episodeID;
    patInfo.MRadm = _mradm;

    common.getSavedRecords(function (ret) {
        envVar.savedRecords = $.parseJSON(ret);
        emrEditor.initDocument(false);
        if (0 == envVar.savedRecords) {
            emrEditor.cleanDoc();
            $('#btnOpOfficeAudit').attr('disabled', true);
            showEditorMsg("本次就诊无电子病历记录！", 'warning');
        } else {
            $('#btnOpOfficeAudit').attr('disabled', false);
        }        
    });
}

function initPatTable() {
    $('#patientListData').datagrid({
        width: '100%',
        height: 106,
        //pageSize:20,
        //pageList:[10,20,30,50,80,100],
        //fitColumns: true,
        striped: true,
        loadMsg: '数据装载中......',
        //autoSizeColumn: true,
        autoRowHeight: true,
        singleSelect: true,
        idField: 'EpisodeID',
        rownumbers: true,
        fit: true,
        remoteSort: false,
        columns: [[{
                    field: 'PatientID',
                    title: 'PatientID',
                    width: 80,
                    hidden: true
                }, {
                    field: 'EpisodeID',
                    title: 'EpisodeID',
                    width: 80,
                    hidden: true
                }, {
                    field: 'mradm',
                    title: 'mradm',
                    width: 80,
                    hidden: true
                }, {
                    field: 'HasComplete',
                    title: '诊断证明',
                    width: 70,
                    sortable: true
                }, {
                    field: 'PAPMIName',
                    title: '姓名',
                    width: 60,
                    sortable: true
                }, {
                    field: 'PAPMISex',
                    title: '性别',
                    width: 40,
                    sortable: true
                }, {
                    field: 'PAPMIAge',
                    title: '年龄',
                    width: 40,
                    sortable: true
                }, {
                    field: 'PAAdmDate',
                    title: '就诊日期',
                    width: 80,
                    sortable: true
                }, {
                    field: 'PAAdmTime',
                    title: '就诊时间',
                    width: 80,
                    sortable: true
                }, {
                    field: 'PAAdmLoc',
                    title: '就诊科室',
                    width: 120,
                    sortable: true
                }, {
                    field: 'PAAdmDoc',
                    title: '就诊医师',
                    width: 80,
                    sortable: true
                }, {
                    field: 'Diagnosis',
                    title: '门诊诊断',
                    width: 500,
                    sortable: true
                }
            ]],
        rowStyler: function (index, row) {
            if (row.HasComplete == "完成") {
                return 'background-color:#A4D3EE;color:red;';
            }
        },
        onDblClickRow: function () {
            //alert('onDblClickRow');
            var seleRow = $('#patientListData').datagrid('getSelected');
            if (seleRow) {
                switchEMRContent(seleRow.PatientID, seleRow.EpisodeID, seleRow.mradm);
            }
        }
    });
}
