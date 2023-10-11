/**
 * creator:		yunhaibao
 * createdate:	2018-04-11
 * description: TPN分析
 * pharmacy/pivas/pass.tpn.js
 * div等命名固定
 */
var PIVASPASSTPN = {
    /**Tpn指标显示窗口创建
     * _options.Params:     主医嘱Id^大指标Id
     * _options.Field:      定义点击哪一列弹出分析窗口
     * _options.ClickField: 当前点击列
     */
    Init: function (_options) {
        var Field = _options.Field;
        var ClickField = _options.ClickField;
        if (Field != ClickField) {
            if ($('#PassTpnWin')) {
                $('#PassTpnWin').remove();
            }
            return;
        }
        if ($('#PassTpnWin').text() != '') {
            // reload
        } else {
            var winDiv = '';
            winDiv += '<div id="PassTpnWin" style="padding:10px">';
            winDiv += '    <div id="lyTpn" class="hisui-layout" fit="true" border="false">';
            winDiv += "        <div data-options=\"region:'west',width:300,split:true,headerCls:'panel-header-gray',bodyCls:'panel-body-gray',border:true\" style=\"border-radius: 4px;\">";
            winDiv += '            <table id="gridTpnFormula"></table>';
            winDiv += '        </div>';
            winDiv += "        <div data-options=\"region:'center',title:'TPN分析图',headerCls:'panel-header-gray',bodyCls:'panel-body-gray',border:true\" style=\"boder-radius: 4px;\">";
            winDiv += '            <div id="radarTpn" style="height:500px;width:400px;"></div>';
            winDiv += '        </div>';
            winDiv += '    </div>';
            winDiv += '</div>';
            $('body').append(winDiv);
            $('#lyTpn').layout();
            $('#PassTpnWin').find('.layout-panel-center').find('.panel-body').css('border-radius', '0px 0px 4px 4px');
            $('#PassTpnWin').find('.layout-panel-center').find('.panel-header').css('border-radius', '4px 4px 0px 0px');
            $('#lyTpn').children().eq(0).css('border-right', '10px solid #ffffff');
        }
        var dataGridOption = {
            url: null,
            border: false,
            fitColumns: true,
            singleSelect: true,
            nowrap: false,
            striped: false,
            pagination: false,
            rownumbers: false,
            columns: [
                [
                    { field: 'ingIndItmDesc', title: '指标名称', width: 100, align: 'left', halign: 'left' },
                    {
                        field: 'ingIndItmValue',
                        title: '值',
                        width: 50,
                        align: 'center',
                        halign: 'center',
                        styler: function (value, row, index) {
                            if (value != '') {
                                value = parseFloat(value);
                                var minVal = row.ingIndItmMin || '';
                                var maxVal = row.ingIndItmMax || '';
                                if (minVal != '') {
                                    if (value < parseFloat(minVal)) {
                                        return 'color:#ff9933;font-weight:bold;';
                                    }
                                }
                                if (maxVal != '') {
                                    if (value > parseFloat(maxVal)) {
                                        return 'color:red;font-weight:bold;';
                                    }
                                }
                            }
                        }
                    },
                    {
                        field: 'ingIndItmRange',
                        title: '范围(~)',
                        width: 75,
                        halign: 'left',
                        align: 'left',
                        formatter: function (value, row, index) {
                            return (row.ingIndItmMin || '') + '~' + (row.ingIndItmMax || '');
                        }
                    }
                ]
            ]
        };
        DHCPHA_HUI_COM.Grid.Init('gridTpnFormula', dataGridOption);
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Formula',
                QueryName: 'OeoriIngrIndItm',
                inputStr: _options.Params
            },
            function (retJson) {
                if (retJson.rows.length > 0) {
                    $('#gridTpnFormula').datagrid('loadData', retJson);
                    PIVASPASSTPN.RadarHtml(retJson);
                    PIVASPASSTPN.Show();
                } else {
                    setTimeout(function () {
                        try {
                            $('#PassTpnWin').window('close');
                        } catch (e) {}
                        $('#PassTpnWin').closest("[class='panel window']").remove();
                    }, 100);
                }
            }
        );
    },
    /** 窗口显示 */
    Show: function () {
        $('#PassTpnWin').window({
            title: ' TPN分析',
            collapsible: false,
            iconCls: 'icon-w-predrug',
            border: false,
            closed: true,
            modal: false,
            width: 730,
            maximizable: false,
            height: $(window).height() - 30,
            left: 10,
            top: 10,
            onBeforeClose: function () {
                $('#PassTpnWin').remove();
            }
        });
        $('#PassTpnWin').window('open');
    },
    /**根据返回json,拼接table数据 */
    TblHtml: function (jsonData) {
        var len = jsonData.length;
        if ((length = 0)) {
            return '';
        }
        var _tblHtml =
            '<table>' +
            '	<thead style="text-align:center">' +
            '		<th style="width:150px;text-align:left">' +
            '			指标名称' +
            '		</th>' +
            '		<th style="width:50px">' +
            '			值' +
            '		</th>' +
            '		<th style="width:100px">' +
            '			范围(~)' +
            '		</th>' +
            '	</thead>' +
            '	<tbody style="text-align:center">';
        var trHtml = '';
        for (var i = 0; i < len; i++) {
            var iJson = jsonData[i];
            var title = iJson.ingIndItmDesc;
            var value = iJson.ingIndItmValue;
            var min = iJson.ingIndItmMin;
            var max = iJson.ingIndItmMax;
            if (value == '') {
                //continue;
            }
            trHtml = '		<tr>' + '			<td style="text-align:left">' + title + '</td>' + '			<td>' + value + '</td>' + '			<td>' + min + '~' + max + '</td>' + '		</tr>';
            _tblHtml += trHtml;
        }
        if (trHtml == '') {
            //return "";
        }
        _tblHtml += '</tbody></table>';
        return _tblHtml;
    },
    /**根据返回json,拼接雷达图数据*/
    RadarHtml: function (jsonData) {
        var indicatorArr = [];
        var valueArr = [];
        var rowsData = jsonData.rows;
        var rowsLen = rowsData.length;
        if (rowsLen == 0) {
            return '';
        }
        for (var i = 0; i < rowsLen; i++) {
            var iJson = rowsData[i];
            var title = iJson.ingIndItmDesc;
            var value = iJson.ingIndItmValue;
            var min = iJson.ingIndItmMin;
            var max = iJson.ingIndItmMax;
            if (value == '') {
                //continue;
            }
            if (max == '' || max == 0) {
                continue;
            }
            var iIndObj = { text: title, max: max };
            indicatorArr.push(iIndObj);
            valueArr.push(value);
        }
        if (indicatorArr.length == 0) {
            var tpnRealTag = document.getElementById('radarTpnReal');
            if (tpnRealTag) {
                tpnRealTag.remove();
            }
            return;
        } else {
            var radarRealHtml = '<div id="radarTpnReal" style="width:100%;height:100%"></div>';
            document.getElementById('radarTpn').innerHTML = radarRealHtml;
        }
        var myChart = echarts.init(document.getElementById('radarTpnReal'));
        var option = {
            title: {
                text: '' // 'TPN分析'
            },
            tooltip: {},
            legend: {},
            polar: [
                {
                    name: { show: true, textStyle: { fontSize: 11, color: '#32cd32' } },
                    indicator: indicatorArr,
                    center: ['50%', '50%'],
                    radius: 75 //半径，可放大放小雷达图
                }
            ],
            series: [
                {
                    name: '',
                    type: 'radar',
                    index: '',
                    symbolSize: 5, // 标注值所的大小
                    data: [
                        {
                            value: valueArr
                        }
                    ]
                }
            ]
        };
        myChart.setOption(option);
    },
    /**根据返回json,拼接病区数据 */
    CircleHtml: function (jsonData) {}
};
