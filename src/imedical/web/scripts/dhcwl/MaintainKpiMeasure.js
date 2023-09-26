(function() {
    Ext.ns("dhcwl.mkpi.MaintainKpiMeasure");
}
)();
dhcwl.mkpi.MaintainKpiMeasure = function(kpiId, kpiName) {
    this.kpiId = kpiId,
    this.kpiName = kpiName;
    var outThis = this;
    var serviceUrl = "dhcwl/kpi/kpimeasure.csp";
    var outThis = this;
    var kpiMeaList = [];
    var sm = new Ext.grid.RowSelectionModel({
        singleSelect: true
    });

    function seltext(v, record) {
        return record.KDTCode + record.KDTName;
    }

    var columnModel = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true,
            width: 80,
            menuDisabled: true
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'ID',
            dataIndex: 'ID',
            width: 120,
            hidden: true
        }, {
            header: '度量编码',
            dataIndex: 'MKPIMeasureCode',
            width: 120
        }, {
            header: '度量描述',
            dataIndex: 'MKPIMeasureDes',
            width: 120
        }, {
            header: '数据源',
            width: 300,
            dataIndex: 'MKPIDataSource'
        }, {
            header: '统计口径',
            width: 300,
            dataIndex: 'MKPIstaCal'
        }, {
            header: '计算数据项',
            dataIndex: 'MKPICalItem',
            width: 300
        }]
    });
    var tempKpiId = 0;
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: serviceUrl + "?action=getKpiMeasure&kpiId=" + tempKpiId
        }),
        //url:serviceUrl+'?action=GetKpiDimList&kpiId='+(outThis.kpiId||"")}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
            fields: [{
                name: 'ID'
            }, {
                name: 'MKPIMeasureCode'
            }, {
                name: 'MKPIMeasureDes'
            }, {
                name: 'MKPIDataSource'
            }, {
                name: 'MKPIstaCal'
            }, {
                name: 'MKPICalItem'
            }]
        })
    });
    var recorde = Ext.data.Record.create([{
        name: 'MKPIMeasureCode'
    }, {
        name: 'MKPIMeasureDes'
    }, {
        name: 'MKPIDataSource'
    }, {
        name: 'MKPIstaCal'
    }, {
        name: 'MKPICalItem'
    }]);
    var kpiMeasureGrid = new Ext.grid.EditorGridPanel({
        frame: true,
        clicksToEdit: 1,
        store: store,
        cm: columnModel,
        sm: sm,
        width: 730,
        height: 300,
        viewConfig: {
            forceFit: true,
            //强制充满
            markDirty: true
        },
        tbar: [{
            //text: '增加指标度量',
            text: '<span style="line-Height:1">增加指标度量</span>',
            icon: '../images/uiimages/edit_add.png',
            handler: function() {
                measureObj = new dhcwl.mkpi.MeasureSelector();
                measureObj.setParentWin(outThis);
                measureObj.showWin();
            }
        }, "-", {
            //text: '删除指标度量',
            text: '<span style="line-Height:1">删除指标度量</span>',
            icon: '../images/uiimages/edit_remove.png',
            handler: function() {
                var rd = sm.getSelected();
                if (!rd) {
                    alert("请选择要删除的指标维度！");
                    return;
                }
                Ext.Msg.confirm('信息', '确定要删除？', function(btn) {
                    if (btn == 'yes') {
                        var kpiMeaId = rd.get('ID');
                        dhcwl.mkpi.Util.ajaxExc(serviceUrl, {
                            'action': 'deleteKpiMea',
                            'meaID': kpiMeaId
                        }, function(jsonData) {
                            if (jsonData.success == true && jsonData.tip == "ok") {
                                Ext.Msg.alert("提示", "删除成功！");
                                outThis.refresh();
                            } else {
                                Ext.Msg.alert("删除失败", jsonData.info);
                            }
                        }, outThis);
                    }
                });

            }
        }, "-", {
            //text: '保存',
            text: '<span style="line-Height:1">保存</span>',
            icon: '../images/uiimages/filesave.png',
            handler: function() {
                var recCnt = kpiMeasureGrid.getStore().getCount();
                if (recCnt <= 0) {
                    Ext.Msg.alert("提示", "先维护指标维度之后才能保存");
                    return;
                }
                var aryKpiMeaCode = [];
                for (var i = 0; i <= recCnt - 1; i++) {
                    rec = kpiMeasureGrid.getStore().getAt(i);
                    if (rec.get("MKPIMeasureCode") == "") {
                        Ext.Msg.alert("提示", "不能存在为空的信息！");
                        return;
                    }
                    aryKpiMeaCode.push(rec.get("MKPIMeasureCode"));
                }
                var strKpiMeaCode = aryKpiMeaCode.toString();
                dhcwl.mkpi.Util.ajaxExc(serviceUrl, {
                    action: 'addMeasure',
                    'kpiId': outThis.kpiId,
                    meaCode: strKpiMeaCode
                }, function(jsonData) {
                    if (jsonData.success == true && jsonData.tip == "ok") {
                        Ext.Msg.alert("提示", "保存成功！");
						outThis.refresh();
                    } else {
                        Ext.Msg.alert("保存失败", jsonData.info);
                    }
                }, this);
            }
        }, "-", {
            //text: '刷新',
            text: '<span style="line-Height:1">刷新</span>',
            icon: '../images/uiimages/update.png',
            handler: function() {
                outThis.refresh();
            }
        }]
    });

    var kpiDimWin = new Ext.Window({
        layout: 'fit',
        modal: true,
        width: 1000,
        height: 400,
        autoScroll: true,
        //closeAction:'hide',
        plain: true,
        title: '度量维护',
        id: 'dhcwl_mkpi_mantainKpiMeasure',
        items: kpiMeasureGrid,
        listeners: {
            'close': function() {
                store.clearModified();
                var rd = null;
                for (var i = store.getCount() - 1; i > -1; i--) {
                    rd = store.getAt(i);
                    selectMeaCodeName = rd.get("MKPIMeasureDes");
                    kpiMeaList[i] = selectMeaCodeName;
                }
                kpiDimWin.destroy();
                kpiDimWin.close();
                if (dhcwl_mkpi_mantainKpiMeasure) {
                    dhcwl_mkpi_mantainKpiMeasure = null;
                }

                dhcwl_mkpi_showKpiWin.setKpiFormFile({
                    measure: kpiMeaList.join(",")
                })
            }
        }
    });
    this.getKpiMeasureInfor = function(meaCode, meaDesc, meaDSource, meaCalItem, meastaCal) {
        //---验证指标维度中是否已经存在已选度量
        var recCnt = kpiMeasureGrid.getStore().getCount();
        var upMeaCode = meaCode.toUpperCase();
        for (i = 0; i < recCnt; i++) {
            paraObj = kpiMeasureGrid.getStore().getAt(i);
            var currentCode = paraObj.get("MKPIMeasureCode");
            var upCurrentCode = currentCode.toUpperCase();
            if (upMeaCode == upCurrentCode) {
                Ext.Msg.alert("提示", "选择的度量已存在");
                return;
            }
        }
        var addedRec = new recorde({
            MKPIMeasureCode: meaCode,
            MKPIMeasureDes: meaDesc,
            MKPIDataSource: meaDSource,
            MKPIstaCal: meastaCal,
            MKPICalItem: meaCalItem
        });
        kpiMeasureGrid.getStore().add(addedRec);
    }
    this.getStore = function() {
        return store;
    }
    this.getRecord = function() {
        return recorde;
    }
    this.getKpiId = function() {
        return this.kpiId;
    }
    this.show = function(id, kpiName) {
        tempKpiId = id;
        this.kpiId = id,
        this.kpiName = kpiName;
        outThis.refresh();
        kpiDimWin.setTitle('指标度量维护--' + kpiName);
        kpiDimWin.show();
    }
    this.refresh = function() {
        store.proxy.setUrl(encodeURI(serviceUrl + '?action=getKpiMeasure&kpiId=' + this.kpiId));
        store.load()
        //kpiMeasureGrid.show();
        //kpiDimWin.show();
    }
}
