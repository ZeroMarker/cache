/**
 * creator:		yunhaibao
 * createdate:	2018-03-05
 * description: 调用东华知识库,界面处理的js
 * plugins:	    基于jquery
 */
var DHCSTPHCMPASS = {
    // 根据返回值修改前台亮灯等提示
    // _options.GridId:  表格Id
    // _options.MOeori:  主医嘱所在表格Field
    // _options.PrescNo: 处方号所在表格Field
    // _options.Field:   亮灯列
    // _options.ResultField: 分析结果列
    // _options.GridType:表格插件(JqGrid,EasyUI)
    // _options.CallBack:回调
    PassAnalysis: function (_options) {
        var gridId = _options.GridId;
        var mOeoriField = _options.MOeori;
        var analyField = _options.Field;
        var prescNoField = _options.PrescNo;
        var resultField = _options.ResultField;
        var gridType = _options.GridType;
        var manLevelFleld = _options.ManLevel; // add by MaYuqiang 20190823
        var valField = _options.valField;
        var $grid = $('#' + gridId);

        var rows = 0;
        if (gridType == 'EasyUI') {
            var rowsData = $grid.datagrid('getRows');
            rows = rowsData.length;
            if (rows == 0) {
                $.messager.alert('提示', '无明细数据', 'warning');
                return;
            }
        } else if (gridType == 'JqGrid') {
            //rows = $grid.getGridParam('records');
            rows = $grid.getDataIDs().length; //当前页数据
            if (rows == 0) {
                dhcphaMsgBox.alert($g('无明细数据'));
                return;
            }
        }
        if (rows == 0) {
            return;
        }
        var mOeoriArr = [];
        var userInfo = session['LOGON.USERID'] + '^' + session['LOGON.CTLOCID'] + '^' + session['LOGON.GROUPID'];
        for (var i = 0; i < rows; i++) {
            var rowData = '';
            if (gridType == 'EasyUI') {
                rowData = rowsData[i];
            } else {
                rowData = $grid.jqGrid('getRowData', i + 1);
            }
            if (rowData == '') {
                continue;
            }
            var mOeori = rowData[mOeoriField];
            if (mOeoriArr.indexOf(mOeori) >= 0) {
                continue;
            }
            var prescNo = '';
            if (prescNoField != '') {
                prescNo = rowData[prescNoField] || '';
            }
            mOeoriArr.push(mOeori);
            var chkRet = tkMakeServerCall('web.DHCSTInterfacePHCMPASS', 'LibPhaCheckOrder', mOeori, prescNo, userInfo, 'C');
            //alert("chkRet:"+chkRet)
            if (chkRet == '') {
                continue;
            }
            if (chkRet.indexOf('^') > -1 && chkRet.split('^')[0] == '-1') {
                if (gridType == 'EasyUI') {
                    $.messager.alert('提示', chkRet.split('^')[1], 'warning');
                } else if (gridType == 'JqGrid') {
                    dhcphaMsgBox.alert(chkRet.split('^')[1]);
                }
                continue;
            }
            var retJson = JSON.parse(chkRet)[0];
            var passFlag = retJson.passFlag;
            var manLevel = retJson.manLevel; // add by maYuqiang 20190823
            var analysisData = '';
            if (passFlag == 1) {
                // 通过
                analysisResult = 1;
            } else {
                analysisResult = 2;
                analysisData = this.RetMsgHtml(retJson.retMsg);
                if (analysisData == '') {
                    analysisResult = 1;
                } else {
                    analysisResult = 0;
                }
            }
            if (gridType == 'EasyUI') {
                if (analysisResult == 1) {
                    analysisResult = 0;
                } else {
                    analysisResult = 2;
                }
                $grid.datagrid('updateRow', {
                    index: i,
                    row: {
                        analysisResult: analysisResult,
                        analysisData: analysisData,
                        manLevel: manLevel
                    }
                });
            } else if (gridType == 'JqGrid') {
                analysisResult = analysisResult == 1 ? 0 : 1;
                $grid.setCell(i + 1, analyField, analysisResult);
                $grid.setCell(i + 1, resultField, analysisData);
                $grid.setCell(i + 1, manLevelFleld, manLevel);
                $grid.setCell(i + 1, valField, analysisResult);
            }
        }
        if (_options.CallBack) {
            _options.CallBack();
        }
    },
    AnalysisTips: function (_options) {
        var analyDivId = 'AnalysisTipsDiv';
        var analysisTips = _options.Content || '';
        //alert("analysisTips:"+analysisTips)
        if (analysisTips == '') {
            $('#' + analyDivId).remove();
            return;
        }
        if ($('#' + analyDivId).text() != '') {
            $('#' + analyDivId + ' #AnalysisTipsDivCon').text('');
        } else {
            var analyDiv =
                '<div id="AnalysisTipsDiv" style="display:block;position: absolute;width:400px;height:200px;border: 2px solid #20A0FF;">' +
                '<div style="background-color: #20A0FF;height:30px;line-height:30px">' +
                '<div style="color:#FFFFFF;float:left;font-weight:bold;padding-left:5px">' +
                '合理分析结果' +
                '</div>' +
                '<div style="float:right;"><a style="background: url(/imedical/web/scripts_lib/hisui-0.1.0/dist/css/images/panel_tools_2.png) no-repeat -16px 0px;margin-top:6px;width:16px;height:16px;display:block;cursor: pointer;"></a></div>' +
                '<div style="clear:both;font-size:13px;overflow:auto;height:160px" id="AnalysisTipsDivCon">' +
                '</div>';
            ('</div>');
            ('</div>');
            $('body').append(analyDiv);
        }
        $('#' + analyDivId + ' a').on('click', function () {
            $('#' + analyDivId).remove();
        });
        $('#' + analyDivId + ' #AnalysisTipsDivCon').html(analysisTips);
        $('#' + analyDivId).css({
            display: 'block',
            top: '10px',
            left: '350px',
            'z-index': 9999,
            background: 'white'
            //transform: "translateY(20%)",
            //transition: "all 1s"
        });
    },
    // 点击单条医嘱显示具体的div提示信息
    MedicineTips: function (_options) {
        var incDesc = _options.IncDesc;
        var medDivId = 'MedicineTipsDiv';
        if ($('#' + medDivId).text() != '') {
            $('#' + medDivId + ' #MedicineTipsDivCon').text('');
            $('#MedicineTipsTitle').text(incDesc);
        } else {
            var medDiv =
                '<div id="MedicineTipsDiv" style="display:block;position: absolute;width:600px;height:403px;border: 2px solid #20A0FF;">' +
                '<div style="background-color: #20A0FF;height:30px;line-height:30px">' +
                '<div style="color:#FFFFFF;float:left;font-weight:bold;padding-left:5px" id="MedicineTipsTitle">' +
                incDesc +
                '</div>' +
                '<div style="float:right;"><a style="background: url(/imedical/web/scripts_lib/hisui-0.1.0/dist/css/images/panel_tools_2.png) no-repeat -16px 0px;margin-top:6px;width:16px;height:16px;display:block;cursor: pointer;"></a></div>' +
                '<div style="clear:both;font-size:13px;height:369px;overflow:auto" id="MedicineTipsDivCon">' +
                '</div>';
            ('</div>');
            ('</div>');
            $('body').append(medDiv);
        }
        $('#' + medDivId + ' a').on('click', function () {
            $('#' + medDivId).remove();
        });
        var oeori = _options.Oeori;
        var userInfo = _options.UserInfo;
        var libInfo = tkMakeServerCall('web.DHCSTInterfacePHCMPASS', 'LibPhaMedTips', oeori, userInfo, 'Q');
        var libMedContext = libInfo;
        if (libMedContext == '') {
            $('#' + medDivId).remove();
            return;
        }
        var libMedHtml = this.MakeMedTipsHtml(libInfo);
        if (libMedHtml == '') {
            $('#' + medDivId).remove();
            return;
        }
        $('#' + medDivId + ' #MedicineTipsDivCon').html(libMedHtml);
        $('#MedicineTipsDiv').css({
            display: 'block',
            top: '10px',
            left: '350px',
            'z-index': 9999,
            background: 'white'
            //transform: "translateY(20%)",
            //transition: "all 1s"
        });
        //$("#MedicineTipsDiv").draggable();
    },
    // _data: 药典内容
    // return:html格式的内容
    MakeMedTipsHtml: function (libData) {
        var libHtml = '';
        var libDataArr = libData.split('!');
        for (var libI = 0; libI < libDataArr.length; libI++) {
            var libIData = libDataArr[libI];
            if (libIData == '') {
                continue;
            }
            var libIDataArr = libIData.split('@/$');
            var libITitle = libIDataArr[0];
            var libIDetail = libIDataArr[1];
            // 以 /n拆分 换行
            var libIDetailS = '';
            var libIDetailArr = libIDetail.split('/n');
            for (var libJ = 0; libJ < libIDetailArr.length; libJ++) {
                libIDetailS += '<p>' + '<span style="font-weight:bold;">' + (libJ + 1) + '.</span>' + libIDetailArr[libJ] + '</p>';
            }
            var libITitleDiv = '<div style="background: #20A0FF;font-weight: bold;color: white;line-height:25px;margin-top:2px;padding-left:5px">' + libITitle + '</div>';
            var libIDataDiv = '<div style="line-height:16px;color:#666666">' + libIDetailS + '</div>';
            var libIHtml = libITitleDiv + libIDataDiv;
            libHtml += libIHtml;
        }
        return libHtml;
    },
    // 解析分析结果的json
    RetMsgHtml: function (retMsg) {
        if (retMsg == '') {
            return '';
        }
        var retMsgLen = retMsg.length;
        if (retMsgLen == 0) {
            return '';
        }
        var retString = '';
        for (var retI = 0; retI < retMsgLen; retI++) {
            var retIString = '';
            var retIMsg = retMsg[retI];
            var retChild = retIMsg.chlidren;
            if (retChild) {
                var retCIString = '';
                var retChildLen = retChild.length;
                for (var retCI = 0; retCI < retChildLen; retCI++) {
                    var retIChild = retChild[retCI];
                    var labelDesc = retIChild.labelDesc;
                    var alertMsg = retIChild.alertMsg;
                    retCIString = labelDesc + ':' + alertMsg;
                    retIString = retIString == '' ? retCIString : retIString + '</br>' + retCIString;
                }
            }
            var geneDesc = retIMsg.geneDesc;
            retIString = '<b>' + geneDesc + '</b>' + '</br>' + retIString + '';
            if (retIString != '') {
                retString = retString == '' ? retIString : retString + '</br>' + retIString;
            }
        }
        return retString;
    },
    HUIAnalysisTips: function (_options) {
        var _winDivId = 'HUIAnalysisTipsDiv';
        var analysisTips = _options.Content || '';
        if (analysisTips == '') {
            $('#' + _winDivId).window('destroy');
            $('#' + _winDivId).remove();
            return;
        }
        if ($('#' + _winDivId).text() == '') {
            var _winDiv = '<div id=' + _winDivId + '></div>';
            $('body').append(_winDiv);
        }
        $('#' + _winDivId)
            .window({
                title: '合理分析结果',
                collapsible: false,
                iconCls: 'icon-w-eye',
                border: false,
                closed: true,
                modal: false,
                width: 400,
                height: 300,
                minimizable: false,
                maximizable: false,
                content: '<div style="padding:10px">' + analysisTips + '</div>',
                onBeforeClose: function () {
                    $(this).window('destroy');
                }
            })
            .window('open');
    }
};
