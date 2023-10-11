checkFun = function (itemGrid) {
        // console.info(itemGrid);
        var userdr = session['LOGON.USERID'];
        var username = session['LOGON.USERNAME'];
        var rowids = itemGrid.rowid;
        var $win;
        $win = $('#CheckWin').window({
            title: '"申请说明"+审批意见',
            width: 500,
            height: 300,
            top: ($(window).height() - 300) * 0.5,
            left: ($(window).width() - 500) * 0.5,
            shadow: true,
            modal: true,
            iconCls: 'icon-w-stamp',
            closed: true,
            minimizable: false,
            maximizable: false,
            collapsible: false,
            resizable: true,
            onClose: function () { //关闭关闭窗口后触发
                $("#ViewField").val("");
                $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
            	$("#MainGrid").datagrid("selectRecord",rowids);
            }
        });

        
        var iscur = itemGrid.IsCurStep;

        var sc = itemGrid.StepNOC;
        ///var sf = itemGrid.StepNOF;
        billstate = itemGrid.BillState;
        ChkselfResult = itemGrid.ChkResult1;
        $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgFundApply',
                    MethodName: 'listIsCurStep',
                    billid: rowids,
                    userid: userdr,
                    billtype: 5
                },
                function (iscur) {
                    ///如果不是当前步骤，那么取消编辑
                    if (iscur == 1) {
                        $win.window('open');
                        // 支付方式的下拉框
                        var CheckResultObj = $HUI.combobox("#CheckResult", {
                            mode: 'local',
                            valueField: 'rowid',
                            textField: 'name',
                            value: 2,
                            data: [{
                                'rowid': 2,
                                'name': "通过"
                            }, {
                                'rowid': 3,
                                'name': "不通过"
                            }]
                        });
                        $("#CheckClose").unbind('click').click(function () {
                            $win.window('close');
                        });
                        $("#CheckSave").unbind('click').click(function () {
                            var view = $("#ViewField").val();
                            var ChkResult = $("#CheckResult").combobox('getValue');
                            if (view == "") {
                        		var message = "审批意见不可为空！";
                        		$.messager.popover({
                            		msg: message,
                            		type: 'alert',
                            		style: {
                                		"position": "absolute",
                                		"z-index": "9999",
                                		left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                		top: 1
                            }
                        })
                        return;
                    }
                            $.m({
                                    ClassName: 'herp.budg.hisui.udata.uBudgCtrlPrePay',
                                    MethodName: 'Audit',
                                    rowid: rowids,
                                    view: view,
                                    ChkResult: ChkResult,
                                    userdr: userdr
                                },
                                function (SQLCODE) {
                                    if (SQLCODE == 0) {
                                        $.messager.popover({
                                            msg: '审核成功！',
                                            type: 'success',
                                            style: {
                                                "position": "absolute",
                                                "z-index": "9999",
                                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                                top: 1
                                            }
                                        });
                                        $win.window('close');
                                    } else {
                                        $.messager.popover({
                                            msg: '审核失败' + SQLCODE,
                                            type: 'error',
                                            style: {
                                                "position": "absolute",
                                                "z-index": "9999",
                                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                                top: 1
                                            }
                                        })
                                        $win.window('close');
                                    }
                                }
                            );

                        });


                    } else if ((billstate == "完成") || (ChkselfResult == 2)) {
                        var message = "不可重复审核！";
                        $.messager.popover({
                            msg: message,
                            type: 'alert',
                            style: {
                                "position": "absolute",
                                "z-index": "9999",
                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                top: 1
                            }
                        })
                    } else if (iscur != 1) {
                        //console.log(iscur)
                        var message = "不是当前审核人！";
                        $.messager.popover({
                            msg: message,
                            type: 'alert',
                            style: {
                                "position": "absolute",
                                "z-index": "9999",
                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                top: 1
                            }
                        })
                    }
                
        })}       