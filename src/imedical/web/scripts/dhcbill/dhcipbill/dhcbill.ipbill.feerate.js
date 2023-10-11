/**
 * FileName: dhcbill.ipbill.feerate.js
 * Author: ZhYW
 * Date: 2019-12-30
 * Description: 住院患者费用比例
 */

$(function () {
    initQueryMenu();
    initRateList();
    initECharts();
});

function initQueryMenu() {
    //登记号
    $("#patientNo").focus().keydown(function (e) {
        patientNoKeydown(e);
    });

    //账单号
    $HUI.combogrid("#billList", {
        panelWidth: 350,
        panelHeight: 220,
        striped: true,
        editable: false,
        selectOnNavigation: false,
        method: 'GET',
        idField: 'TBill',
        textField: 'TBill',
        columns: [[{field: 'TBill', title: '账单号', width: 60},
                   {field: 'TDateFrm', title: '账单开始日期', width: 100},
                   {field: 'TDateTo', title: '账单结束日期', width: 100},
                   {field: 'TAdm', title: '就诊ID', width: 80}
            ]],
        onLoadSuccess: function (data) {
            setValueById("EpisodeID", "");
            setValueById("BillRowId", "");
            if (data.total == 1) {
                setValueById("billList", data.rows[0].TBill);
            } else {
                $("#billList").combogrid("clear");
                $(".numberbox-f").numberbox("clear");
                $("input:disabled").val("");
                loadRateList();
            }
        },
        onSelect: function (index, row) {
            setValueById("EpisodeID", row.TAdm);
            setValueById("BillRowId", row.TBill);
            getPatInfo();
            loadRateList();
        }
    });
}

function patientNoKeydown(e) {
    var key = websys_getKey(e);
    if (key == 13) {
        $.m({
            ClassName: "web.UDHCJFBaseCommon",
            MethodName: "regnocon",
            PAPMINo: getValueById("patientNo")
        }, function (patientNo) {
            setValueById("patientNo", patientNo);
            loadBillList();
        });
    }
}

function getPatInfo() {
    $.cm({
        ClassName: "BILL.IP.BL.FeeRate",
        MethodName: "GetPatInfo",
        adm: getValueById("EpisodeID"),
        billId: getValueById("BillRowId")
    }, function (json) {
        setValueById("admDate", json.admDate);
        setValueById("dischDate", json.dischDate);
        setValueById("dept", json.admDept);
        setValueById("bed", json.bed);
        setValueById("patName", json.patName);
        setValueById("patientNo", json.regNo);
        setValueById("admReason", json.admReaDesc);
        setValueById("inDays", json.inDays);
        setValueById("totalAmt", json.totalAmount);
    });
}

function loadBillList() {
    var queryParams = {
        ClassName: "BILL.IP.BL.FeeRate",
        QueryName: "FindBillList",
        patientNo: getValueById("patientNo"),
        hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
        rows: 9999999
    };
    loadComboGridStore("billList", queryParams);
}

function initRateList() {
    GV.RateList = $HUI.datagrid("#rateList", {
            fit: true,
            striped: true,
            border: false,
            singleSelect: true,
            pageSize: 9999999,
            columns: [[{title: 'TCateId', field: 'TCateId', hidden: true},
            		   {title: '分类', field: 'TCateDesc', width: 110,
                        formatter: function (value, row, index) {
                            if (value) {
                                return "<a href='javascript:;' onclick='billDtl(" + row.TCateId + ")'>" + value + "</a>";
                            }
                        }
                       },
                       {title: '金额', field: 'TCateFee', width: 110, align: 'right'},
                       {title: '百分比', field: 'TCateRate', width: 110,
                       	formatter: function (value, row, index) {
                            if (value) {
                                return value + "%";
                            }
                        }
                       },
                       {title: 'TCateId1', field: 'TCateId1', hidden: true},
                       {title: '分类', field: 'TCateDesc1', width: 110,
                        formatter: function (value, row, index) {
                            if (value) {
                                return "<a href='javascript:;' onclick='billDtl(" + row.TCateId1 + ")'>" + value + "</a>";
                            }
                        }
                       },
                       {title: '金额', field: 'TCateFee1', width: 110, align: 'right'},
                       {title: '百分比', field: 'TCateRate1', width: 110,
                       	formatter: function (value, row, index) {
                            if (value) {
                                return value + "%";
                            }
                        }
                       },
                       {title: 'TCateId2', field: 'TCateId2', hidden: true},
                       {title: '分类', field: 'TCateDesc2', width: 110,
                        formatter: function (value, row, index) {
                            if (value) {
                                return "<a href='javascript:;' onclick='billDtl(" + row.TCateId2 + ")'>" + value + "</a>";
                            }
                        }
                       },
                       {title: '金额', field: 'TCateFee2', width: 110, align: 'right'},
                       {title: '百分比', field: 'TCateRate2', width: 110,
                       	formatter: function (value, row, index) {
                            if (value) {
                                return value + "%";
                            }
                        }
                       },
                       {title: 'TCateId3', field: 'TCateId3', hidden: true},
                       {title: '分类', field: 'TCateDesc3', width: 110,
                        formatter: function (value, row, index) {
                            if (value) {
                                return "<a href='javascript:;' onclick='billDtl(" + row.TCateId3 + ")'>" + value + "</a>";
                            }
                        }
                       },
                       {title: '金额', field: 'TCateFee3', width: 110, align: 'right'},
                       {title: '百分比', field: 'TCateRate3', width: 110,
                       	formatter: function (value, row, index) {
                            if (value) {
                                return value + "%";
                            }
                        }
                       }
                ]],
            onLoadSuccess: function (data) {
                loadECharts(data);
            }
        });
}

function loadRateList() {
    var queryParams = {
        ClassName: "BILL.IP.BL.FeeRate",
        QueryName: "FindFeeRate",
        billId: getValueById("BillRowId"),
        rows: 9999999
    };
    loadDataGridStore("rateList", queryParams);
}

function billDtl(cateId) {
    var url = "dhcbill.ipbill.billdtl.csp?&EpisodeID=" + getValueById("EpisodeID") + "&BillID=" + getValueById("BillRowId") + "&CateID=" + cateId;
    websys_showModal({
        url: url,
        title: $g('费用明细'),
        iconCls: 'icon-w-list'
    });
}

function initECharts() {
    // 指定图表的配置项和数据
    var option = {
	    title: {
            text: $g('分类费用饼图'),
            left: 'center',
            textStyle: {
	            fontSize: 16,
	            color: 'black',
	            fontWeight: 'bold'
	        },
	        padding: [10, 5, 5, 5]
        },
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b} : {c} ({d}%)'
        },
        legend: {
	         orient: 'vertical',
	         top: 20,
        	 left: '20%'
	    },
        toolbox: {
            feature: {
                saveAsImage: {
                    show: true
                }
            }
        },
        series: []
    };

    GV.ECharts = echarts.init($('#container')[0], 'infographic');
    GV.ECharts.setOption(option);
    GV.ECharts.on('click', function (params) {
        var cateId = params.data.id;
        if (cateId) {
            billDtl(cateId);
        }
    });
}

function loadECharts(data) {
    var amtAry = [];
    $.each(data.rows, function (index, row) {
        if (row.TCateFee > 0) {
            amtAry.push({value: row.TCateFee, name: row.TCateDesc, id: row.TCateId});
        }
        if (row.TCateFee1 > 0) {
            amtAry.push({value: row.TCateFee1, name: row.TCateDesc1, id: row.TCateId1});
        }
        if (row.TCateFee2 > 0) {
            amtAry.push({value: row.TCateFee2, name: row.TCateDesc2, id: row.TCateId2});
        }
        if (row.TCateFee3 > 0) {
            amtAry.push({value: row.TCateFee3, name: row.TCateDesc3, id: row.TCateId3});
        }
    });
	
    var option = GV.ECharts.getOption();
    option.series = [{
            name: amtAry.length > 0 ? $g('分类费用') : '',
            type: 'pie',
            data: amtAry,
            top: 30,
            radius: '65%',
            center: ['50%', '50%'],
            label: {
                formatter: '{a|{a}}{abg|}\n{hr|}\n  {b|{b}：}{c}  {per|{d}%}',
                backgroundColor: '#eee',
                borderColor: '#aaa',
                borderWidth: 1,
                borderRadius: 4,
                rich: {
                    a: {
                        color: '#999',
                        lineHeight: 22,
                        align: 'center'
                    },
                    hr: {
                        borderColor: '#aaa',
                        width: '100%',
                        borderWidth: 0.5,
                        height: 0
                    },
                    b: {
                        fontSize: 16,
                        lineHeight: 33
                    },
                    per: {
                        color: '#eee',
                        backgroundColor: '#334455',
                        padding: [2, 4],
                        borderRadius: 2
                    }
                }
            }
        }
    ];
    GV.ECharts.setOption(option);
}