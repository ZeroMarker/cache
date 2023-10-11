/**
 * ��� - ���
 * @creator �ƺ���
 */
 $(function () {
    var biz = {
        data: {
            status: 'SAVE',
            handleStatus: '',
            defaultData: [
                {
                    loc: session['LOGON.CTLOCID'],
                    startDate: session['LOGON.CTLOCID'],
                    endDate: session['LOGON.CTLOCID'],
                    nextStatusResult: 'SHOULD'
                }
            ]
        },
        getData: function (key) {
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;
        }
    };
    var components = REC_COMPONENTS();
    var com = REC_COM;
    var settings = com.GetSettings();
    
    if(settings.App.Permission4Cancel != 'Y'){
	    $('#btnDestroy').hide();
    }

    components('Date', 'startDate');
    components('Date', 'endDate');
    components('Loc', 'loc');
    // components('StkCatGrp', 'stkCatGrp');
    components('No', 'no');
    components('NextStatus', 'nextStatus', {
        onLoadSuccess: function (data) {
            if (data.length > 0) {
                $(this).combobox('setValue', data[0].RowId);
            }
        },
        onChange: function (oldData, newData) {
            $.data($(this)[0], 'find', true);
        },
        onHidePanel: function (ee) {
            if ($.data($(this)[0], 'find') == true) {
                $('#btnFind').trigger('click-i');
            }
            $.data($(this)[0], 'find', false);
        }
    });
    components('StatusResult', 'nextStatusResult', {
        onChange: function (oldData, newData) {
            $.data($(this)[0], 'find', true);
        },
        onHidePanel: function (ee) {
            if ($.data($(this)[0], 'find') == true) {
                $('#btnFind').trigger('click-i');
            }
            $.data($(this)[0], 'find', false);
        }
    });
    components('Vendor', 'vendor');
    components('FilterField', 'filterField');
    components('MainGrid', 'gridMain', {
        toolbar: '#gridMainBar',
        onClickRow: function () {
            var pJson = com.Condition('#qCondition', 'get');
            pJson.recID = com.GetSelectedRow('#gridMain', 'recID');
            // com.QueryItmGrid('gridItm', pJson);
            com.LoadData('gridItm', {
                pJson: JSON.stringify(pJson),
                pMethodName: 'GetItmDataRows'
            });
        },
        onLoadSuccess: function (data) {
            com.ValidateGridData(data);
            $('#gridItm').datagrid('clear');
        }
    });
    var rebuildColumns = PHA_COM.RebuildColumns(components('ItmGridColmuns', 'gridItm'), {
        hiddenFields: ['gCheck']
    });
    components('ItmGrid', 'gridItm', {
        toolbar: '#gridItmBar',
        view:scrollview,
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns,
        showFooter:true,
        onClickCell: function (index, field, value) {
            // ��˹���, �������޸�
        }
    });

    PHA_EVENT.Bind('#btnFind', 'click', function () {
        com.QueryMainGrid('gridMain', com.Condition('#qCondition', 'get'));
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        $('#gridMain').datagrid('clear');
        $('#gridItm').datagrid('clear');
        SetDefaults();
    });
    PHA_EVENT.Bind('#btnAudit', 'click', function () {
        biz.setData('handleStatus', 'Audit');
        Audit();
    });

    PHA_EVENT.Bind('#btnAuditPrint', 'click', function () {
        biz.setData('handleStatus', 'Audit');
        Audit({
            callbackPrint: function (recID) {
                com.Print(recID);
            }
        });
    });
    PHA_EVENT.Bind('#btnAuditCancel', 'click', function () {
        biz.setData('handleStatus', 'AuditCancel');
        Audit();
    });
    PHA_EVENT.Bind('#btnAuditRefuse', 'click', function () {
        biz.setData('handleStatus', 'AuditRefuse');
        Audit();
    });
    PHA_EVENT.Bind('#btnPrint', 'click', function () {
        com.Print(com.GetSelectedRow('#gridMain', 'recID'));
    });
    function Audit(options) {
        options = options || {};
        var apiMethod = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (apiMethod === '') {
            return;
        }
        var popMsg = '����ѡ����Ҫ����ĵ��ݼ�¼'
        var recID = com.GetSelectedRow('#gridMain', 'recID');
        if (recID === '') {
            components('Pop', popMsg);
            return;
        }
        var statusCode = $('#nextStatus').combobox('getValue') || '';
        if (statusCode === '') {
            components('Pop', '����ѡ��Ԥ������');
            return;
        }
        var btnText = $(window.event.target).parent().find('.l-btn-text').text();
        if ((biz.getData('handleStatus') === 'AuditCancel')&&(statusCode === "AUDIT") ){
            PHA.BizPrompt({ title: '���ϵ�������', info: '<div><b>ȡ���󽫼����Ѿ����ӵĿ�棬���ҵ��ݽ���Ϊ����״̬</b></div><div>���������Ƶ���ѯ�н��и���</div>' }, function (promptRet) {
                if (promptRet !== undefined) {
                    if (promptRet === '') {
                        components('Pop', '��¼���Ҫ˵��');
                        return;
                    }
                    ExeAudit(promptRet);
                }
            });
        } else {
            PHA.BizPrompt({ title: 'ȷ������' }, function (promptRet) {
                if (promptRet !== undefined) {
                    // if (promptRet === '') {
                    //     components('Pop', '��¼���Ҫ˵��');
                    //     return;
                    // }
                    ExeAudit(promptRet);
                }
            });
            // PHA.Confirm('ȷ������', '��ȷ��' + btnText + '��?', ExeAudit);
        }

        function ExeAudit(promptRet) {
            var statusReason = '';
            if (typeof promptRet !== 'undefined') {
                statusReason = promptRet;
            }
            var data4save = {
                recID: recID,
                statusReason: statusReason,
                statusCode: statusCode
            };
            PHA.Loading('Show')
            com.Invoke(apiMethod, data4save, function (retData) {
                PHA.Loading('Hide')
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
                    if (!PHA_COM.SelectAfterDeleteRow('#gridMain') >= 0) {
                        $('#gridItm').datagrid('clear');
                    }
                    components('Pop', '�����ɹ�');
                    if (options.callbackPrint) {
                        options.callbackPrint(recID);
                    }
                }
            });
        }
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
        $('#nextStatus').combobox('reload');
    }
    function ControlOperation() {
        com.ControlOperation({});
    }
    setTimeout(function () {
        $.extend(biz.getData('defaultData')[0], settings.DefaultData || {});
        SetDefaults();
        ControlOperation();
        com.SetPage('pha.in.v3.rec.audit.csp');
        $("#btnFind").click();
    }, 500);
    // PHA.BizPrompt({ title: '���ϵ�������', info: '<div><b>���Ϻ󽫼����Ѿ����ӵĿ�棬���ҵ��ݽ���Ϊ����״̬</b></div><div>���������Ƶ���ѯ�н��и���</div>' }, function (promptRet) {
    //     if (promptRet !== undefined) {
    //         if (promptRet === '') {
    //             components('Pop', '��¼���Ҫ˵��');
    //             return;
    //         }
    //         ExeAudit();
    //     }
    // });
    // a();
});
function a() {
    var winID = 'pha_bizprompt';
    var winTarget = '#' + winID;
    var handleText = '�� ���� ��';
    // handleText = $('#btnDestroy')[0].outerHTML.replace('id=', 'iddddd=')
    var contentArr = [];
    // color:#339eff;
    contentArr.push('<div><div style="float:left;">���ڲ���</div><div style="font-weight:bold;font-size:16px;float:left;" >{handleText}</div><div style="clear:both"></div></div>');
    // contentArr.push('<div style="font-size:16px;">���ڲ���<span style="font-weight:bold;color:#ee4f38;font-size:16px;">{handleText}</span></div>');
    contentArr.push('<ul>');
    contentArr.push('<li>���Ϻ�<b>�����Ѿ����ӵĿ��</b>�����ҵ��ݽ���Ϊ����״̬</li>');
    contentArr.push('<li>����Ȼ�������Ƶ�����Ĳ�ѯ�����н��и���</li>');
    contentArr.push('</ul>');
    contentArr.push('<div style="padding-top:5px"><input class="hisui-validatebox" placeholder=" �˴�����������һЩ��Ҫ��Ϣ " style="width:calc(100% - 18px)"></input></div>');
    contentArr.push(
        '<div style="padding-top:10px;text-align:center;line-height:0;margin-left:-42px;"><a id="pha_bizprompt_ok" style="min-width:70px;margin-right:5px;">ȷ��</a><a id="pha_bizprompt_cancel" style="margin-left:5px;min-width:70px;">ȡ��</a</div>'
    );
    content = '<div style="line-height:2rem;padding:10px 20px;min-width:350px;">' + contentArr.join('') + '</div>';

    content = content.replace('{handleText}', handleText);
    // $('body').append(content);
    $('body').append('<div id="' + winID + '"><div class="messager-icon messager-question" style="position:relative;left:10px;top:10px;"></div><div style="margin-left:42px;">' + content + '</div></div>');
    $(winTarget + ' .hisui-validatebox').validatebox({});
    $(winTarget + ' #pha_bizprompt_ok,#pha_bizprompt_cancel').linkbutton({});
    $(winTarget).window({
        title: '��������',
        collapsible: false,
        border: false,
        closed: true,
        modal: true,
        maximizable: false,
        collapsible: false,
        minimizable: false,
        resizable: false,
        closable: false,
        onClose: function () {
            $(this).window('destroy');
        }
    });
    $(winTarget).window('open');
    $('#pha_bizprompt_ok')
        .unbind()
        .bind('click', function () {
            var textInfo =  $(winTarget + ' .hisui-validatebox').val()
            $(winTarget).window('close');
            // callback
        });
    $('#pha_bizprompt_cancel')
        .unbind()
        .bind('click', function () {
            $(winTarget).window('close');
            // callback
        });
 }
//  PHA.Loading('Show')
