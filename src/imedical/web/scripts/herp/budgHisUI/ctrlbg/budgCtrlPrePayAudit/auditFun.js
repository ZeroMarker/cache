checkFun = function (itemGrid) {
        // console.info(itemGrid);
        var userdr = session['LOGON.USERID'];
        var username = session['LOGON.USERNAME'];
        var rowids = itemGrid.rowid;
        var $win;
        $win = $('#CheckWin').window({
            title: '"����˵��"+�������',
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
            onClose: function () { //�رչرմ��ں󴥷�
                $("#ViewField").val("");
                $("#MainGrid").datagrid("reload"); //�رմ��ڣ����¼��������
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
                    ///������ǵ�ǰ���裬��ôȡ���༭
                    if (iscur == 1) {
                        $win.window('open');
                        // ֧����ʽ��������
                        var CheckResultObj = $HUI.combobox("#CheckResult", {
                            mode: 'local',
                            valueField: 'rowid',
                            textField: 'name',
                            value: 2,
                            data: [{
                                'rowid': 2,
                                'name': "ͨ��"
                            }, {
                                'rowid': 3,
                                'name': "��ͨ��"
                            }]
                        });
                        $("#CheckClose").unbind('click').click(function () {
                            $win.window('close');
                        });
                        $("#CheckSave").unbind('click').click(function () {
                            var view = $("#ViewField").val();
                            var ChkResult = $("#CheckResult").combobox('getValue');
                            if (view == "") {
                        		var message = "�����������Ϊ�գ�";
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
                                            msg: '��˳ɹ���',
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
                                            msg: '���ʧ��' + SQLCODE,
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


                    } else if ((billstate == "���") || (ChkselfResult == 2)) {
                        var message = "�����ظ���ˣ�";
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
                        var message = "���ǵ�ǰ����ˣ�";
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