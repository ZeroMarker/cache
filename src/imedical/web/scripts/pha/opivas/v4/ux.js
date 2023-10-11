/**
 * 名称:	 门诊配液系统公用组件
 * 编写人:	 yunhaibao
 * 编写日期: 2019-06-06
 */
PHA_OPIVAS_UX = {
    AutoGif: function (_method) {
        var _id = 'PHA_OPIVAS_UX_Auto_Refresh';
        var _fun = {
            Hide: function () {
                $('#' + _id).remove();
            },
            Show: function () {
                $('#' + _id).remove();
                var autoHtml = '<div id=' + _id + ' style="position:absolute;bottom:60px;right:20px">';
                autoHtml += '<img src="../scripts/pha/com/v1/css/gif/loading.gif" height="100px" width="100px">';
                autoHtml += ' </div>';
                $('body').append(autoHtml);
            }
        };
        _fun[_method]();
    },
    // 原因备注录入
    DisRemark: function (_saveOpts, _callBack) {
        var winId = 'PHA_OPIVAS_UX_DisRemark';
        var remarkId = winId + '_remark';
        var winDiv =
            '<div id=' +
            winId +
            ' style="overflow:hidden"><div style="padding:10px;padding-right:22px;height:90px;"><textarea class="validatebox-text" id=' +
            remarkId +
            ' style="width:100%;height:100%;padding:5px;"></textarea></div></div>';
        $('body').append(winDiv);
        $('#' + winId)
            .dialog({
                title: '原因录入',
                collapsible: false,
                iconCls: 'icon-w-list',
                border: false,
                closed: true,
                closable: false,
                modal: true,
                width: 400,
                height: PHA_COM.IsLiteCss ? 197 : 200,
                buttons: [
                    {
                        text: '确定',
                        handler: function () {
                            var remark = $('#' + remarkId).val();
                            if (remark.trim() == '') {
                                PHA.Popover({
                                    msg: '请录入信息',
                                    type: 'alert'
                                });
                                return;
                            }
                            $('#' + winId).dialog('close');
                            _saveOpts.remark = remark;
                            _callBack(_saveOpts);
                        }
                    },
                    {
                        text: '取消',
                        handler: function () {
                            $('#' + winId).dialog('close');
                        }
                    }
                ],
                onBeforeClose: function () {
                    $('#' + winId).remove();
                }
            })
            .dialog('open');
        $('#' + remarkId).focus();
    },
    /**
     * 审核记录
     * @param {String} MOeori 主医嘱Id
     */
    AuditRecord: function (MOeori, MDspId) {
        if (MOeori == '' && MDspId == '') {
            return;
        }
        var winId = 'PHA_OPIVAS_UX_AuditRecord';
        var gridId = winId + '_Grid';
        var winDiv = '<div id="' + winId + '" style="padding:10px;overflow:hidden;"><div id=' + gridId + '></div></div>';
        $('body').append(winDiv);
        //定义表格
        var columns = [
            [
                {
                    field: 'auditStatusDesc',
                    title: '审核状态',
                    width: 100,
                    styler: PHA_OPIVAS_COM.Grid.Styler.PassStatus
                },
                {
                    field: 'userName',
                    title: '操作人',
                    width: 90
                },
                {
                    field: 'dateTime',
                    title: '操作时间',
                    width: 155
                },
                {
                    field: 'reasonDesc',
                    title: '审核原因',
                    width: 250
                },
                {
                    field: 'phNote',
                    title: '药师备注',
                    width: 100
                },
                {
                    field: 'docAgree',
                    title: '医生接受',
                    width: 70
                },
                {
                    field: 'docNotes',
                    title: '医生申诉',
                    width: 100
                },
                {
                    field: 'oeoriStat',
                    title: '医嘱状态',
                    width: 70
                },
                {
                    field: 'cancelUserName',
                    title: '取消人',
                    width: 90
                },
                {
                    field: 'cancelDateTime',
                    title: '取消时间',
                    width: 100
                }
            ]
        ];
        var dataGridOption = {
            exportXls: false,
            url: $URL,
            queryParams: {
                ClassName: 'PHA.OPIVAS.COM.Query',
                QueryName: 'OeAuditRecord',
                MOeori: MOeori,
                MDspId: MDspId
            },
            fit: true,
            rownumbers: false,
            columns: columns,
            pagination: false,
            singleSelect: true,
            nowrap: false,
            toolbar: null,
            gridSave: false
        };
        PHA.Grid(gridId, dataGridOption);
        $('#' + winId).window({
            title: ' 配伍审核记录',
            collapsible: false,
            iconCls: 'icon-w-paper',
            border: false,
            closed: true,
            modal: true,
            width: 1155,
            height: 500,
            maximizable: false,
            minimizable: false,
            onBeforeClose: function () {
                $('#' + winId).remove();
            }
        });
        $('#' + winId).window('open');
        $('#' + winId + " [class='panel datagrid']").css({
            border: '#cccccc solid 1px',
            'border-radius': '4px'
        });
    },
    /**
     * 流程单号
     * @param {String} _id 标签Id
     * @param {*} _opts
     */
    POGSNo: function (_opts, _callBack) {
        var winId = 'PHA_OPIVAS_UX_POGSNo';
        var gridId = winId + '_GRID';
        var winDiv = '<div id=' + winId + ' style="padding:10px; overflow:hidden;"><div id=' + gridId + '></div></div>';
        var stDateId = winId + '_StDate';
        var edDateId = winId + '_EdDate';
        var psId = winId + '_PS';
        var findId = winId + '_FIND';

        var barHtmlArr = [];
        barHtmlArr.push('<div class="" id = "' + gridId + '_BAR' + '">');
        barHtmlArr.push('    <div class="pha-row">');
        barHtmlArr.push('        <div class="pha-col">' + $g('操作日期') + '</div>');
        barHtmlArr.push('        <div class="pha-col"><input id=' + stDateId + ' class="hisui-datebox"/></div>');
        barHtmlArr.push('        <div class="pha-col">' + $g('至') + '</div>');
        barHtmlArr.push('        <div class="pha-col"><input id=' + edDateId + ' class="hisui-datebox"/></div>');
        barHtmlArr.push('        <div class="pha-col">' + $g('配液状态') + '</div>');
        barHtmlArr.push('        <div class="pha-col"><input id=' + psId + ' type="text" /></div>');
        barHtmlArr.push('        <div class="pha-col"><a class="hisui-linkbutton" plain="false" id=' + findId + ' iconCls="icon-w-find">查询</a></div>');
        barHtmlArr.push('    </div>');
        barHtmlArr.push('</div>');

        $('body').append(winDiv + barHtmlArr.join(''));
        $('#' + findId).linkbutton({
            onClick: function () {
                var inputStr = _opts.locId + '^' + $('#' + psId).combobox('getValue') + '^' + $('#' + stDateId).datebox('getValue') + '^' + $('#' + edDateId).datebox('getValue');
                $('#' + gridId).datagrid('query', {
                    InputStr: inputStr
                });
            }
        });
        $('#' + stDateId)
            .datebox()
            .datebox('setValue', 't');
        $('#' + edDateId)
            .datebox()
            .datebox('setValue', 't');
        PHA.ComboBox(psId, {
            panelHeight: 'auto',
            url: PHA_OPIVAS_STORE.PIVAState().url + '&InputStr=' + _opts.locId + '^10^OPIVAS.EXE^' + ''
        });
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'PHA.OPIVAS.COM.Query',
                QueryName: 'POGSNoRecord'
            },
            title: '',
            border: false,
            fitColumns: false,
            singleSelect: true,
            nowrap: false,
            striped: false,
            pagination: true,
            rownumbers: false,
            toolbar: '#' + gridId + '_BAR',
            columns: [
                [
                    {
                        field: 'psName',
                        title: '配液状态',
                        width: 100
                    },
                    {
                        field: 'pogsNo',
                        title: '单号',
                        width: 300
                    },
                    {
                        field: 'pogsDate',
                        title: '操作日期',
                        width: 100
                    },
                    {
                        field: 'pogsTimeRange',
                        title: '操作时间',
                        width: 175
                    },
                    {
                        field: 'pogsUserName',
                        title: '操作人',
                        width: 125
                    },
                    {
                        field: 'pogsCnt',
                        title: '组数',
                        width: 50
                    }
                ]
            ],
            onDblClickRow: function (rowIndex, rowData) {
                _callBack(rowData);
                $('#' + winId).window('close');
            }
        };
        PHA.Grid(gridId, dataGridOption);
        $('#' + winId)
            .window({
                title: ' 流程单据',
                collapsible: false,
                iconCls: 'icon-w-list',
                border: false,
                closed: true,
                modal: true,
                width: 900,
                height: 500,
                maximizable: false,
                minimizable: false,
                onBeforeClose: function () {
                    $('#' + winId).remove();
                    $('#' + winId + '+BAR').remove();
                }
            })
            .window('open');
        $('#' + winId + " [class='panel datagrid']").css('border', '#cccccc solid 1px');
        $('#' + winId + " [class='panel datagrid']").css('border-radius', '4px');
    }
};
