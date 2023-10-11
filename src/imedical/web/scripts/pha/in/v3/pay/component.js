/**
 * ������� - ��� - ��Ҫ���ڳ�ʼ����
 * @creator �ƺ���
 */
var PAY_COMPONENTS = function () {
    var components = {
        Loc: function (domID, options) {
            options = options || {};
            PHA_UX.ComboBox.Loc(domID, options);
        },
        StkCatGrp: function (domID, options) {
            options = options || {};
            var defOptions = {
                simple: true,
                panelHeight: 'auto',
                multiple: true,
                rowStyle: 'checkbox',
                qParams: {
                    LocId: PHA_UX.Get('loc', session['LOGON.CTLOCID']),
                    UserId: session['LOGON.USERID']
                }
            };
            PHA_UX.ComboBox.StkCatGrp(domID, $.extend(defOptions, options));
        },
        StkCat: function (domID) {
            options = options || {};
            var defOptions = {
                multiple: true,
                rowStyle: 'checkbox'
            };
            PHA_UX.ComboBox.StkCat(domID, $.extend(defOptions, options));
        },
        Poison: function (domID) {
            PHA.ComboBox(domID, {
                url: PHA_STORE.PHCPoison().url
            });
        },
        Date: function (domID) {
            PHA.DateBox(domID, {});
            $('#' + domID).datebox('setValue', 't');
        },
        User: function (domID) {
            PHA.ComboBox(domID, {
                url: PHA_STORE.SSUser().url
            });
        },
        No: function (domID) {
            PHA.ValidateBox(domID, {});
        },
        InvNo: function (domID) {
            PHA.ValidateBox(domID, {});
        },
        Inci: function (domID) {
            // ����һ���ò���ҩƷ������
            PHA_UX.ComboGrid.INCItm(domID, {});
        },
        Vendor: function (domID) {
            PHA_UX.ComboBox.Vendor(domID, {
                panelWidth: 'auto',
                panelHeight: $.fn.combobox.defaults.height * 10 + 5
            });
        },
        Status: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                multiple: true,
                rowStyle: 'checkbox',
                url: PHA_STORE.BusiProcess('PAY', session['LOGON.CTLOCID'], session['LOGON.USERID']).url
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        StatusText: function (domID) {
            PHA.ValidateBox(domID, {});
        },
        AuditStatus: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                multiple: true,
                rowStyle: 'checkbox',
                data: [
                    {
                        RowId: 'Purch',
                        Description: '�ɹ���ȷ��'
                    },
                    {
                        RowId: 'Account',
                        Description: '�����ȷ��'
                    },
                    {
                        RowId: 'Treasure',
                        Description: '������ȷ��'
                    }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        InvStatus: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                rowStyle: 'checkbox',
                multiple: true,
                editable: false,
                data: [
                    {
                        RowId: 'Y',
                        Description: '�з�Ʊ'
                    },
                    {
                        RowId: 'N',
                        Description: '�޷�Ʊ'
                    }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        BizType: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                multiple: true,
                editable: false,
                rowStyle: 'checkbox',
                data: [
                    {
                        RowId: 'G',
                        Description: '���'
                    },
                    {
                        RowId: 'R',
                        Description: '�˻�'
                    }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
            $('#' + domID).combobox('setValues', ['G', 'R']);
        },
        ApproveStatus: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                multiple: true,
                rowStyle: 'checkbox',
                data: [
                    {
                        RowId: 'Y',
                        Description: '�����'
                    },
                    {
                        RowId: 'N',
                        Description: 'δ���'
                    }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        Remarks: function (domID) {
            PHA.ValidateBox(domID, {});
        },
        PayCheckMode: function (domID) {
            PHA.ComboBox(domID, {
                url: PHA_STORE.CTPayMode().url
            });
        },
        /**
         * ȫ��ģ������
         */
        FilterField: function (domID) {
            PHA.ValidateBox(domID, {});
        },
        Banner: function (domID, options) {
            if (typeof options === 'object') {
                var dataArr = [];
                dataArr = [
                    {
                        info: options.no,
                        append: '/'
                    },
                    {
                        info: options.vendorDesc,
                        append: '/'
                    },
                    {
                        prepend: '�Ƶ�: ',
                        info: options.createUserName + ' ' + options.createDate + ' ' + options.createTime
                    },
                    {
                        info: options.statusDesc == '����' ? 'δ���' : options.statusDesc,
                        labelClass: options.statusDesc == '����' ? 'danger' : 'info'
                    }
                ];
                if (options.purchUserName !== '') {
                    dataArr.push({ append: '/', info: '' });
                    dataArr.push({ prepend: '�ɹ�ȷ��: ', info: options.purchUserName  });  //+ ' ' + options.purchDate + ' ' + options.purchTime  // չʾ��Ϣ̫����������ʾ����
                }
                if (options.accountUserName !== '') {
                    dataArr.push({ append: '/', info: '' }); 
                    dataArr.push({ prepend: '���ȷ��: ', info: options.accountUserName  });  //+ ' ' + options.accountDate + ' ' + options.accountTime
                }
                if (options.treasureUserName !== '') {
                    dataArr.push({ append: '/', info: '' });
                    dataArr.push({ prepend: '����ȷ��: ', info: options.treasureUserName  });  //+ ' ' + options.treasureDate + ' ' + options.treasureTime
                }
                $('#' + domID).phabanner('loadData', dataArr);
            } else {
                $('#' + domID).phabanner({
                    title: 'ѡ�񵥾ݺ�, ��ʾ��ϸ��Ϣ'
                });
            }
        },
        ItmGrid: function (domID, opts) {
            var columnsObj = this.ItmGridColmuns();
            var dataGridOption = {
                url: '',
                exportXls: false,
                columns: columnsObj.columns,
                frozenColumns: columnsObj.frozenColumns,
                toolbar: [],
                pageNumber: 1,
                pageSize: 9999,
                autoSizeColumn: true,
                selectOnCheck: true,
                checkOnSelect: true,
                pagination: false,
                showFooter: true,
                rownumbers: true,
                showComCol: true,
                footerSumFields: ['rpAmt', 'spAmt'],
                onLoadSuccess: function (data) {
                    $(this).datagrid('clearChecked');
                    PHA_GridEditor.End(domID);
                    PHA_COM.SumGridFooter('#' + this.id);
                },
                onNextCell: function (index, field, value, isLastRow, isLastCol) {
                    if (isLastRow && isLastCol) {
                        console.log('onNextCell');
                    }
                }
            };
            PHA.Grid(domID, $.extend(dataGridOption, opts));
            var eventClassArr = ['pha-grid-a js-grid-inciCode'];
            PHA.GridEvent(domID, 'click', eventClassArr, function (rowIndex, rowData, className) {
                if (className.indexOf('js-grid-inciCode') >= 0) {
                    PHA_UX.DrugDetail({}, { inci: rowData.inci });
                    return;
                }
            });
        },
        ItmGridColmuns: function () {
            var frozenColumns = [
                [
                    {
                        field: 'gCheck',
                        checkbox: true
                    },
                    {
                        field: 'payItmID',
                        title: 'payItmID',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'bizTypeDesc',
                        title: '����',
                        width: 50,
                        sortable: true
                    },
                    {
                        field: 'inciCode',
                        title: 'ҩƷ����',
                        width: 100,
                        sortable: true,
                        formatter: function (value, rowData, index) {
                            if (!value || !rowData.inci) {
                                return value;
                            }
                            return '<a class="pha-grid-a js-grid-inciCode">' + value + '</a>';
                        }
                    },
                    {
                        field: 'inciDesc',
                        title: 'ҩƷ����',
                        width: 200,
                        sortable: true
                    }
                ]
            ];
            var columns = [
                [
                    {
                        field: 'payAmt',
                        title: '������',
                        width: 100,
                        sortable: true,
                        align: 'right',
                        styler: function (val) {
                            if (val * 1 < 0) {
                                return 'color:red';
                            }
                        }
                    },
                    {
                        field: 'payedAmt',
                        title: '�����ۼƽ��',
                        width: 100,
                        sortable: true,
                        align: 'right',
                        styler: function (val) {
                            if (val * 1 < 0) {
                                return 'color:red';
                            }
                        }
                    },

                    {
                        field: 'qty',
                        title: '����',
                        width: 75,
                        sortable: true
                    },
                    {
                        field: 'uomDesc',
                        title: '��λ',
                        width: 75,
                        sortable: true
                    },
                    {
                        field: 'manfDesc',
                        title: '������ҵ',
                        width: 150,
                        sortable: true
                    },

                    {
                        field: 'rp',
                        title: '����',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'sp',
                        title: '�ۼ�',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },

                    {
                        field: 'rpAmt',
                        title: '���۽��',
                        width: 100,
                        sortable: true,
                        align: 'right',
                        styler: function (val) {
                            if (val * 1 < 0) {
                                return 'color:red';
                            }
                        }
                    },
                    {
                        field: 'spAmt',
                        title: '�ۼ۽��',
                        width: 100,
                        sortable: true,
                        align: 'right',
                        styler: function (val) {
                            if (val * 1 < 0) {
                                return 'color:red';
                            }
                        }
                    },
                    {
                        field: 'payOverFlag',
                        title: '����',
                        width: 50,
                        sortable: true,
                        align: 'center',
                        formatter: function (value, rowData, index) {
                            if (value == 'Y') {
                                return PHA_COM.Fmt.Grid.Yes.Chinese;
                            } else if (value == 'N' || value === '') {
                                return PHA_COM.Fmt.Grid.Yes.Chinese;
                            }
                        }
                    },
                    {
                        field: 'invNo',
                        title: '��Ʊ��',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'invDate',
                        title: '��Ʊ����',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'invAmt',
                        title: '��Ʊ���',
                        width: 100,
                        sortable: true,
                        align: 'right',
                        styler: function (val) {
                            if (val * 1 < 0) {
                                return 'color:red';
                            }
                        }
                    },
                    {
                        field: 'batNo',
                        title: '����',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'expDate',
                        title: 'Ч��',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'insuCode',
                        title: '����ҽ������',
                        sortable: true,
                        width: 150
                    },
                    {
                        field: 'insuDesc',
                        title: '����ҽ������',
                        sortable: true,
                        width: 150
                    }
                ]
            ];
            return {
                frozenColumns: frozenColumns,
                columns: columns
            };
        },
        MainGrid: function (domID, opts) {
            var columnsObj = this.MainGridColmuns();
            var dataGridOption = {
                url: '',
                exportXls: false,
                columns: columnsObj.columns,
                frozenColumns: columnsObj.frozenColumns,
                toolbar: [],
                pageNumber: 1,
                pageSize: 100,
                autoSizeColumn: true,
                isAutoShowPanel: true,
                rownumbers: true,
                loadFilter: function (data) {
                    if (data.success === 0) {
                        PHA.Alert('��ʾ', data.msg, 'warning');
                    } else {
                        if (data.rows.length > 0) {
                            if (typeof data.rows[0] === 'string') {
                                PHA.Alert('��ʾ', data.rows[0], 'warning');
                            }
                        }
                    }
                    return data;
                }
            };
            PHA.Grid(domID, $.extend(dataGridOption, opts));
        },
        MainGridColmuns: function () {
            var frozenColumns = [
                [
                    {
                        field: 'payID',
                        title: 'payID',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'no',
                        title: '����',
                        width: 150,
                        sortable: true
                    },
                    {
                        field: 'locDesc',
                        title: '�ɹ�����',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'vendorDesc',
                        title: '��Ӫ��ҵ',
                        width: 150,
                        sortable: true
                    },
                    {
                        field: 'payAmt',
                        title: '������',
                        width: 100,
                        sortable: true,
                        align: 'right'
                    }
                ]
            ];
            var columns = [
                [
                    {
                        field: 'createDate',
                        title: '�Ƶ�����',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'createTime',
                        title: '�Ƶ�ʱ��',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'createUserName',
                        title: '�Ƶ���',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'finishDate',
                        title: '�������',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'finishTime',
                        title: '���ʱ��',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'finishUserName',
                        title: '�����',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'voucherNo',
                        title: '����ƾ֤',
                        width: 120,
                        sortable: true
                    },
                    {
                        field: 'purchDate',
                        title: '�ɹ�ȷ������',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'purchTime',
                        title: '�ɹ�ȷ��ʱ��',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'purchUserName',
                        title: '�ɹ�ȷ����',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'accountDate',
                        title: '���ȷ������',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'accountTime',
                        title: '���ȷ��ʱ��',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'accountUserName',
                        title: '���ȷ����',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'treasureDate',
                        title: '����ȷ������',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'treasureTime',
                        title: '����ȷ��ʱ��',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'treasureUserName',
                        title: '����ȷ����',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'statusDesc',
                        title: '״̬',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'status',
                        title: '״̬����',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'remarks',
                        title: '��ע',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'checkModeDesc',
                        title: '֧����ʽ',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'checkNo',
                        title: '֧��Ʊ�ݺ�',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'checkDate',
                        title: '֧��Ʊ������',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'checkAmt',
                        title: '֧��Ʊ�ݽ��',
                        width: 100,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'poisonFlag',
                        title: '�����־', 
                        width: 100,
                        sortable: true,
                        hidden: true
                    }
                ]
            ];
            return {
                frozenColumns: frozenColumns,
                columns: columns
            };
        },
        QueryWindow: function (domID, options) {
            PHA_IN_PAY_ID = '';
            $('#' + domID)
                .window({
                    iconCls: 'icon-w-paper',
                    title: '��ѯ���',
                    width: $('body').width() * 0.85,
                    height: $('body').height() * 0.85,
                    modal: true,
                    closable: true,
                    collapsible: false,
                    maximizable: false,
                    minimizable: false,
                    onClose: function () {
                        options.callBack(PHA_IN_PAY_ID, '');
                        PHA_IN_PAY_ID = '';
                    }
                })
                .window('open');
            // �̶����ǵ���query.csp
            $('#gridMain-q').datagrid('reload');
            PHA_COM.ResizePanel({
                layoutId: 'layout-pay-query',
                region: 'north',
                height: 0.5
            });
        },
        BizWindow: function (domID, options) {
            PHA_IN_PAY_ID = '';
            $('#' + domID)
                .window({
                    iconCls: 'icon-w-paper',
                    title: 'Ӧ�����',
                    width: $('body').width() * 0.85,
                    height: $('body').height() * 0.85,
                    modal: true,
                    closable: true,
                    collapsible: false,
                    maximizable: false,
                    minimizable: false,
                    onClose: function () {
                        options.callBack(PHA_IN_PAY_ID, '');
                        PHA_IN_PAY_ID = '';
                    }
                })
                .window('open');
            // �̶����ǵ���query.csp
            $('#btnFind-biz').trigger('click-i');
            // $('#gridMain-biz').datagrid('reload'); // δ������loadsuccess
        },
        Pop: function (msg, type) {
            type = type || 'info';
            PHA.Popover({
                msg: msg,
                type: type
            });
        }
    };
    return function (type) {
        var pParams = [].slice.call(arguments, 1, arguments.length);
        return components[type].apply(components, pParams);
    };
};
