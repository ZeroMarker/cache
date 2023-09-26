function initPnlButton() {
    function liveBtnBind() {
        var isBtnClicked = false;
        $('#pnlButton button').live('click', function() {
            if (isBtnClicked) { return; }
            isBtnClicked = true;
            $('#btnOpOfficeAudit').attr({"disabled":"disabled"});
            $('#btnOpOfficePrint').attr({"disabled":"disabled"});
            $('#btnOpOfficePDFPrev').attr({"disabled":"disabled"});
            setTimeout(function(){
                isBtnClicked = false;
                $('#btnOpOfficeAudit').removeAttr("disabled");
                $('#btnOpOfficePrint').removeAttr("disabled");
                $('#btnOpOfficePDFPrev').removeAttr("disabled");
            }, 2000);

            var fnBtnClick = btnClick[$(this).attr('id')];
            if ('function' == typeof fnBtnClick) {
                fnBtnClick();
            } else {

            }
        });
        
        var btnClick = new function() {
            this.btnOpOfficeAudit = function() {
                var instanceId = emrEditor.getInstanceID();
                if (instanceId === '')
                    return;

                if ('0' === common.isSaved(instanceId)) {
                    return;
                }
                var auditUsrId = document.getElementById('auditUsrCombo').value;

                var InsertAudit = function() {
                    var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'InsertAudit', instanceId, auditUsrId, patInfo.UserID);
                    ajaxGET(data, function(ret) {
                        if (ret != "-1") {
                            var selectedRow = $('#patientListData').datagrid('getSelected');
                            var rowIndex = $('#patientListData').datagrid('getRowIndex',selectedRow);
                            $('#patientListData').datagrid('updateRow',{
                                index: rowIndex,
                                row: {
                                    AuditStatus: '已审核'
                                }
                            });
                            showEditorMsg('审核成功', 'alert');
                        }
                    }, function(ret) {
                        alert('InsertAudit error:' + ret);
                    });
                }

                var ShowAuditLog = function() {
                    var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetAuditLog', instanceId);
                    ajaxGET(data, function(ret) {
                        if ('' != ret) {
                            var info = ret.split('^');
                            var msg = '已审核' + info.length + '次：\r\n';
                            for (var idx = 0, max = info.length; idx < max; idx++) {
                                msg += '      ' + info[idx] + '\r\n';
                            }
                            alert(msg);
                        }
                        InsertAudit();
                    }, function(ret) {
                        alert('InsertAudit error:' + ret);
                    });
                }

                if ('' == auditUsrId) {
                    return;
                } else if (patInfo.UserID != auditUsrId) {
                    var auditUsrComboObj = document.getElementById('auditUsrCombo');
                    var index = auditUsrComboObj.selectedIndex;
                    var auditUsr = auditUsrComboObj.options[index].text;
                    var auditUsrCode = $.trim(auditUsr.split('-')[0]);
                    var auditUsrName = $.trim(auditUsr.split('-')[1]);
                    var ret = window.showModalDialog('emr.record.sign.csp?UserCode=' + auditUsrCode, '', 'dialogHeight:180px;dialogWidth:280px;resizable:yes;status:no');
                    ret = ret || '';
                    if (ret != '') {
                        ShowAuditLog();
                    }
                } else {
                    ShowAuditLog();
                }
            };
            this.btnOpOfficePrint = function() {
                var instanceId = emrEditor.getInstanceID();
                if (instanceId === '')
                    return;
                var pdfInfo = "";
                var data = {
                    action: 'getPDFInfo',
                    episodeID: patInfo.EpisodeID,
                    insID: instanceId,
                }
                var chkAuditPDF = function () {
                    $.ajax({
                        type: 'POST',
                        dataType: 'text',
                        url: '../CA.Ajax.anySign.cls',
                        async: false,
                        cache: false,
                        data: data,
                        success: function (ret) {
                            pdfInfo = JSON.parse(ret);
                            printToRealPrint(pdfInfo.pdfB64, pdfInfo.pdfName);
                        },
                        error: function (ret) {
                            alert("获取PDF错误");
                        }
                    });
                }
                chkAuditPDF();
            };
            this.btnOpOfficePDFPrev = function() {
                var instanceId = emrEditor.getInstanceID();
                if (instanceId === '')
                    return;
                var pdfInfo = "";
                var data = {
                    action: 'getPDFInfo',
                    episodeID: patInfo.EpisodeID,
                    insID: instanceId,
                }
                var chkAuditPDF = function () {
                    $.ajax({
                        type: 'POST',
                        dataType: 'text',
                        url: '../CA.Ajax.anySign.cls',
                        async: false,
                        cache: false,
                        data: data,
                        success: function (ret) {
                            pdfInfo = JSON.parse(ret)
                            pdfPreview(pdfInfo.pdfB64, pdfInfo.pdfName);
                        },
                        error: function (ret) {
                            alert("获取PDF错误");
                        }
                    });
                }
                chkAuditPDF();
            };
        };
    }

    //审核人列表
    function initAuditList() {
        var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetSSUserByLocID', patInfo.UserLocID);
        ajaxGET(data, function(ret) {
            if ('' != ret) {
                var userlst = $.parseJSON(ret);
                var keyCombo = document.getElementById('auditUsrCombo').options;
                keyCombo.length = 0;
                keyCombo.options[keyCombo.length] = new Option('', '');
                for (var i = 0; i < userlst.length; i++) {
                    var item = userlst[i];
                    var key = item.Name;
                    var value = item.ID;
                    keyCombo.options[keyCombo.length] = new Option(key, value);
                }
                $('#auditUsrCombo option[value="' + patInfo.UserID + '"]').attr('selected', true);
            }else {
                //showEditorMsg('未获取到审核人列表数据', 'alert');
                alert('未获取到审核人列表数据');
            }
        }, function(ret) {
            alert('GetSSUserByLocID error:' + ret);
        });
    }

    initAuditList();
    liveBtnBind();
    $('#btnOpOfficeAudit').attr('disabled', true);
    $('#btnOpOfficePrint').attr('disabled', true);
    $('#btnOpOfficePDFPrev').attr('disabled', true);
}
