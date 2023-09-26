/**
 * 名称:	 药库-药品信息维护-控制初始化
 * 编写人:	 yunhaibao
 * 编写日期: 2019-05-09
 */

PHA_COM.App.Csp = 'pha.in.v3.drug.csp';
PHA_COM.App.Name = 'IN.DRUG';
PHA_COM.App.Load = '';
PHA_COM.Param.App = $.cm(
    {
        ClassName: 'PHA.IN.Drug.Query',
        MethodName: 'GetParamProp',
        LogonStr: PHA_COM.Session.ALL,
        dataType: 'json'
    },
    false
);
DRUG_TOOLTIP = $.cm(
    {
        ClassName: 'PHA.COM.BDP',
        MethodName: 'ToolTip',
        Code: 'pha.in.v3.drug.csp',
        dataType: 'json'
    },
    false
);
DRUG_SwitchType = ''; // 控制医嘱项与库存项表格加载时是否默认选中
$(function () {
    InitHospCombo(); //加载医院
    // tab事件
    $('#tabsDrug').tabs('options').onSelect = function (title, index) {
        if (title == '药品信息') {
            return;
        }
        $("[name='divDrug']").hide();
        $('#panelDetail').panel('setTitle', title);
        if (title == '医嘱项') {
            if ($('#divARCItmMast').text().trim() == '') {
                $('#divARCItmMast').append($('#scrArcItmMast').html());
                $('#divARCItmMast').show();
                // 先show再解析,否则布局是乱的
                ARCITMMAST();
            } else {
                $('#divARCItmMast').show();
            }
        } else if (title == '库存项') {
            if ($('#divINCItm').text().trim() == '') {
                $('#divINCItm').append($('#scrINCItm').html());
                $('#divINCItm').show();
                INCITM();
            } else {
                $('#divINCItm').show();
            }
        } else if (title == '处方通用名') {
            if ($('#divPHCGeneric').text().trim() == '') {
                $('#divPHCGeneric').append($('#scrPHCGeneric').html());
                $('#divPHCGeneric').show();
                PHCGENERIC();
            } else {
                $('#divPHCGeneric').show();
            }
        } else if (title == '药学分类') {
            if ($('#divDHCPHCCat').text().trim() == '') {
                $('#divDHCPHCCat').append($('#scrDHCPHCCat').html());
                $('#divDHCPHCCat').show();

                DHCPHCCAT();
            } else {
                $('#divDHCPHCCat').show();
            }
        } else if (title == '品种通用名') {
            if ($('#divDHCPHChemical').text().trim() == '') {
                $('#divDHCPHChemical').append($('#scrDHCPHChemical').html());
                $('#divDHCPHChemical').show();
                DHCPHCHEMICAL();
            } else {
                $('#divDHCPHChemical').show();
            }
        }
    };
    $('#tabsDrug').tabs('disableTab', 0);
    var selTab = '库存项';
    $.each($('#tabsDrug').tabs('tabs'), function (indexInArray, valueOfElement) {
        var title = valueOfElement.panel('options').title;
        if (title == PHA_COM.Param.App.DefaultTab) {
            selTab = title;
        }
    });

    $('#tabsDrug').tabs('select', selTab);
});

function InitTreePHCCat() {
    PHA.Tree('treePHCCat', {});
    $.cm(
        {
            ClassName: 'PHA.STORE.Drug',
            MethodName: 'GetDHCPHCCatTree',
            ParentId: ''
        },
        function (data) {
            $('#treePHCCat').tree({
                data: data
            });
        }
    );
}

function MakeToolTip() {
    for (var forId in DRUG_TOOLTIP) {
        var tipInfo = DRUG_TOOLTIP[forId] || '';
        if (tipInfo == '') {
            continue;
        }
        $('[for=' + forId + ']').tooltip({
            content: tipInfo,
            position: 'left',
            showDelay: 500
        });
    }
}

function InitHospCombo() {
    var hospAutFlag = tkMakeServerCall('PHA.FACE.IN.Com', 'GetHospAut');
    if (hospAutFlag === 'Y') {
        $('#lyMainView').layout('add', {
            region: 'north',
            border: false,
            title: '',
            height: '40',
            bodyCls: 'pha-ly-hosp',
            content:
                '<div style="padding-left:10px;">' +
                '   <div class="pha-row">' +
                '       <div class="pha-col">' +
                '           <label id="_HospListLabel" style="color:red;" class="r-label">医院</label>' +
                '       </div>' +
                '   	<div class="pha-col">' +
                '       	<input id="_HospList" class="textbox"/>' +
                '   	</div>' +
                '	</div>' +
                '</div>'
        });

        var genObj = GenHospComp('ARC_ItmMast');
        //增加选择事件
        $('#_HospList').combogrid('options').onSelect = function (index, record) {
            var newHospId = record.HOSPRowId;
            var oldHospId = PHA_COM.Session.HOSPID;
            if (newHospId != oldHospId) {
                PHA_COM.Session.HOSPID = newHospId;
                PHA_COM.Session.ALL = PHA_COM.Session.USERID + '^' + PHA_COM.Session.CTLOCID + '^' + PHA_COM.Session.GROUPID + '^' + PHA_COM.Session.HOSPID;
                $('#divARCItmMast').empty();
                $('#divINCItm').empty();
                var selTab = $('#tabsDrug').tabs('getSelected');
                var title = selTab.panel('options').title;
                if (title == '医嘱项') {
                    $('#divARCItmMast').append($('#scrArcItmMast').html());
                    $('#divARCItmMast').show();
                    ARCITMMAST();
                } else if (title == '库存项') {
                    $('#divINCItm').append($('#scrINCItm').html());
                    $('#divINCItm').show();
                    INCITM();
                }
            }
        };
    }
}

function InitHospButton() {
    var btnObj = GenHospWinButton('ARC_ItmMast');
    if (!btnObj) {
        return;
    }
    btnObj.options().onClick = function () {
        var rowData = $('#gridARCItmMast').datagrid('getSelected');
        if (rowData === null) {
            return;
        }

        InitHospWin('ARC_ItmMast', rowData.arcimId, HospWinCallback, { singleSelect: false });
    };
    // 选中回调
    function HospWinCallback() {}
}

function InitHospWin(objectName, objectId, callback, opt) {
    if ($('#_HospListWin').length == 0) {
        $('<div id="_HospListWin" />').prependTo('body');
    }
    var singleSelect = false;
    if (opt) {
        singleSelect = opt.singleSelect || false;
    }
    var gridObj = '';
    var obj = $HUI.dialog('#_HospListWin', {
        width: 550,
        modal: true,
        height: 350,
        title: '医院权限分配',
        content: '<table id="_HospListGrid"></table>',
        buttons: [
            {
                text: '确定',
                handler: function () {
                    var HospIDs = '';
                    var rows = gridObj.getData().rows;
                    var checkRow = gridObj.getChecked();
                    if (rows.length > 0) {
                        for (var i = 0; i < rows.length; i++) {
                            if ($.hisui.indexOfArray(checkRow, 'HOSPRowId', rows[i]['HOSPRowId']) == -1) {
                                HospIDs += '^' + rows[i]['HOSPRowId'] + '$N';
                            } else {
                                HospIDs += '^' + rows[i]['HOSPRowId'] + '$Y';
                            }
                        }
                    }
                    //保存医院关联
                    $cm({
                        ClassName: 'PHA.IN.Drug.Save',
                        MethodName: 'SaveHospMulti',
                        arcim: objectId,
                        hospStr: HospIDs
                    });
                    if ('function' == typeof callback) callback(checkRow);
                    $HUI.dialog('#_HospListWin').close();
                }
            },
            {
                text: '取消',
                handler: function () {
                    $HUI.dialog('#_HospListWin').close();
                }
            }
        ],
        onOpen: function () {
            gridObj = $HUI.datagrid('#_HospListGrid', {
                mode: 'remote',
                fit: true,
                border: false,
                pagination: false,
                showPageList: false,
                showRefresh: false,
                singleSelect: singleSelect,
                queryParams: { ClassName: 'web.DHCBL.BDP.BDPMappingHOSP', QueryName: 'GetHospDataForCloud', tablename: objectName, dataid: objectId },
                url: $URL,
                columns: [
                    [
                        { field: 'LinkFlag', title: '授权情况', align: 'center', width: 100, checkbox: true },
                        { field: 'HOSPRowId', title: 'HOSPRowId', align: 'left', hidden: true, width: 100 },
                        { field: 'HOSPDesc', title: '医院名称', align: 'left', width: 300 },
                        { field: 'MappingID', title: 'ObjectId', align: 'left', hidden: true, width: 100 }
                    ]
                ],
                onLoadSuccess: function (row) {
                    var rowData = row.rows;
                    $.each(rowData, function (idx, val) {
                        if (val.LinkFlag == 'Y') {
                            $('#_HospListGrid').datagrid('selectRow', idx);
                        }
                    });
                }
            });
        }
    });
}
