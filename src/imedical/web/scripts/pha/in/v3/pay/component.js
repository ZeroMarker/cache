/**
 * 付款管理 - 组件 - 主要用于初始化等
 * @creator 云海宝
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
            // 付款一般用不上药品的条件
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
                        Description: '采购已确认'
                    },
                    {
                        RowId: 'Account',
                        Description: '会计已确认'
                    },
                    {
                        RowId: 'Treasure',
                        Description: '财务已确认'
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
                        Description: '有发票'
                    },
                    {
                        RowId: 'N',
                        Description: '无发票'
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
                        Description: '入库'
                    },
                    {
                        RowId: 'R',
                        Description: '退货'
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
                        Description: '已审核'
                    },
                    {
                        RowId: 'N',
                        Description: '未审核'
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
         * 全局模糊检索
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
                        prepend: '制单: ',
                        info: options.createUserName + ' ' + options.createDate + ' ' + options.createTime
                    },
                    {
                        info: options.statusDesc == '保存' ? '未完成' : options.statusDesc,
                        labelClass: options.statusDesc == '保存' ? 'danger' : 'info'
                    }
                ];
                if (options.purchUserName !== '') {
                    dataArr.push({ append: '/', info: '' });
                    dataArr.push({ prepend: '采购确认: ', info: options.purchUserName  });  //+ ' ' + options.purchDate + ' ' + options.purchTime  // 展示信息太长。导致显示换行
                }
                if (options.accountUserName !== '') {
                    dataArr.push({ append: '/', info: '' }); 
                    dataArr.push({ prepend: '会计确认: ', info: options.accountUserName  });  //+ ' ' + options.accountDate + ' ' + options.accountTime
                }
                if (options.treasureUserName !== '') {
                    dataArr.push({ append: '/', info: '' });
                    dataArr.push({ prepend: '财务确认: ', info: options.treasureUserName  });  //+ ' ' + options.treasureDate + ' ' + options.treasureTime
                }
                $('#' + domID).phabanner('loadData', dataArr);
            } else {
                $('#' + domID).phabanner({
                    title: '选择单据后, 显示详细信息'
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
                        title: '类型',
                        width: 50,
                        sortable: true
                    },
                    {
                        field: 'inciCode',
                        title: '药品代码',
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
                        title: '药品名称',
                        width: 200,
                        sortable: true
                    }
                ]
            ];
            var columns = [
                [
                    {
                        field: 'payAmt',
                        title: '付款金额',
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
                        title: '付款累计金额',
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
                        title: '数量',
                        width: 75,
                        sortable: true
                    },
                    {
                        field: 'uomDesc',
                        title: '单位',
                        width: 75,
                        sortable: true
                    },
                    {
                        field: 'manfDesc',
                        title: '生产企业',
                        width: 150,
                        sortable: true
                    },

                    {
                        field: 'rp',
                        title: '进价',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'sp',
                        title: '售价',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },

                    {
                        field: 'rpAmt',
                        title: '进价金额',
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
                        title: '售价金额',
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
                        title: '结清',
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
                        title: '发票号',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'invDate',
                        title: '发票日期',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'invAmt',
                        title: '发票金额',
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
                        title: '批号',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'expDate',
                        title: '效期',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'insuCode',
                        title: '国家医保编码',
                        sortable: true,
                        width: 150
                    },
                    {
                        field: 'insuDesc',
                        title: '国家医保名称',
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
                        PHA.Alert('提示', data.msg, 'warning');
                    } else {
                        if (data.rows.length > 0) {
                            if (typeof data.rows[0] === 'string') {
                                PHA.Alert('提示', data.rows[0], 'warning');
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
                        title: '单号',
                        width: 150,
                        sortable: true
                    },
                    {
                        field: 'locDesc',
                        title: '采购科室',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'vendorDesc',
                        title: '经营企业',
                        width: 150,
                        sortable: true
                    },
                    {
                        field: 'payAmt',
                        title: '付款金额',
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
                        title: '制单日期',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'createTime',
                        title: '制单时间',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'createUserName',
                        title: '制单人',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'finishDate',
                        title: '完成日期',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'finishTime',
                        title: '完成时间',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'finishUserName',
                        title: '完成人',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'voucherNo',
                        title: '付款凭证',
                        width: 120,
                        sortable: true
                    },
                    {
                        field: 'purchDate',
                        title: '采购确认日期',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'purchTime',
                        title: '采购确认时间',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'purchUserName',
                        title: '采购确认人',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'accountDate',
                        title: '会计确认日期',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'accountTime',
                        title: '会计确认时间',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'accountUserName',
                        title: '会计确认人',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'treasureDate',
                        title: '财务确认日期',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'treasureTime',
                        title: '财务确认时间',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'treasureUserName',
                        title: '财务确认人',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'statusDesc',
                        title: '状态',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'status',
                        title: '状态代码',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'remarks',
                        title: '备注',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'checkModeDesc',
                        title: '支付方式',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'checkNo',
                        title: '支付票据号',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'checkDate',
                        title: '支付票据日期',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'checkAmt',
                        title: '支付票据金额',
                        width: 100,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'poisonFlag',
                        title: '毒麻标志', 
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
                    title: '查询付款单',
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
            // 固定就是调的query.csp
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
                    title: '应付款单据',
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
            // 固定就是调的query.csp
            $('#btnFind-biz').trigger('click-i');
            // $('#gridMain-biz').datagrid('reload'); // 未触发进loadsuccess
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
