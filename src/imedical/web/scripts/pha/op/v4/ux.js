var PHA_OP={
    Grid: {
        Formatter:{
            GetGroup: function (rowArr, field) {
               
                var valJson = rowArr;
                var maxDrugCnt = valJson.length;
                var len = valJson.length;
                var retHtmlArr = [];
                for (var i = 0; i < len; i++) {
                    var valData = valJson[i];
                    if (i >= maxDrugCnt) {
                        retHtmlArr.push('<div class="op-ord-grp-row pivas-ord-toggle" style="display:none;line-height:19px; ">');
                    } else {
                        retHtmlArr.push('<div class="op-ord-grp-row style="line-height:19px;">');
                    }
                    retHtmlArr.push(valData[field]);
                    retHtmlArr.push('</div>');
                }
                return retHtmlArr.join('');
            },
            InciGroup:function(value, rowData, index){
                
                var valJson = JSON.parse(value);
                var maxDrugCnt = valJson.length;
                var len = valJson.length;
                var inciHtmlArr = [];
                for (var i = 0; i < len; i++) {
                    var valData = valJson[i];
                    if (i >= maxDrugCnt) {
                        inciHtmlArr.push('<div class="op-ord-grp-row" style="display:none;">');
                    } else {
                        inciHtmlArr.push('<div class="op-ord-grp-row" style="">');
                    }
                    var inciDesc = valData.inciDesc;
                    var omFlag = valData.omFlag;
                    var skinTest = valData.skinTest;
                    if (omFlag !== '') {
                        omFlag = '<span style="color:#F6A519;font-weight:bold;">[自备]</span>';
                        inciDesc = omFlag + ' ' + inciDesc;
                    }
                    if (skinTest !== '') {
                        if (skinTest.indexOf('+') >= 0) {
                            skinTest = '<span style="color:#F6704E;font-weight:bold;">' + skinTest + '</span>';
                        }
                        inciDesc = skinTest + ' ' + inciDesc;
                    }
                    var inciHtml = '<span style="white-space: nowrap;';
                    inciHtml += '">' + inciDesc + '</span>';
                    inciHtmlArr.push(inciHtml);
                    inciHtmlArr.push('</div>');
                }
                var inciGrpHtml = '<div style="margin-left:10px">' + inciHtmlArr.join('') + '</div>';
                var signHtml =PHA_OP.Grid.Formatter.SignGroup(value, rowData, index);
                return '<div style="padding-left:10px;position:relative">' + signHtml + inciGrpHtml + '</div>';
                        
            },
            DosageGroup: function (value, rowData, index) {
                return PHA_OP.Grid.Formatter.GetGroup(JSON.parse(rowData.PrescItmArr), 'dosage');
            },
            InstGroup: function (value, rowData, index) {
                return PHA_OP.Grid.Formatter.GetGroup(JSON.parse(rowData.PrescItmArr), 'instDesc');
            },
            FreqGroup: function (value, rowData, index) {
                return PHA_OP.Grid.Formatter.GetGroup(JSON.parse(rowData.PrescItmArr), 'freqDesc');
            },
            QtyUomGroup: function (value, rowData, index) {
                return PHA_OP.Grid.Formatter.GetGroup(JSON.parse(rowData.PrescItmArr), 'qtyUom');
            },
            OrdRemarkGroup: function (value, rowData, index) {
                return PHA_OP.Grid.Formatter.GetGroup(JSON.parse(rowData.PrescItmArr), 'ordRemark');
            } ,
            SignGroup:function (value, rowData, index) {
               
                var valJson = JSON.parse(value);
                var maxDrugCnt = valJson.length;
                var len = valJson.length;
                var rowHeight = 16;

                var visibleStyle = 'margin-left:-10px;margin-top:5px;';
                var signHeight = rowHeight * maxDrugCnt +(maxDrugCnt-1)*16 ;
                var maxHeight = rowHeight * len +(len-1)*16 ;
                var moreHeight = signHeight - 10;
                var moreFlag = false;
                if (maxHeight < signHeight) {
                    signHeight = maxHeight;
                }
                var retHtmlArr = [];
                if (len === 1) {
                    retHtmlArr.push('<div class="op-single-sign"  style="' + visibleStyle + '">');
                } else {
                    retHtmlArr.push('<div class="op-ord-sign"  style="' + visibleStyle + '">');
                }
                retHtmlArr.push('   <div class="op-ord-toggle" style="height:' + signHeight + 'px;line-height:' + signHeight + 'px">');
                if (moreFlag === true) {
                    retHtmlArr.push('       <div class="op-ord-sign-more" style="height:' + moreHeight + 'px;"></div>');
                }
                retHtmlArr.push('   </div>');
                retHtmlArr.push('   <div class="op-ord-toggle" style="height:' + maxHeight + 'px;display:none">');
                retHtmlArr.push('   </div>');
                retHtmlArr.push('</div>');
                return retHtmlArr.join('');
            }
        }
    },
    Progress: {
        Show: function (_options) {
            var _text = '  数  据  处  理  中  ';
            var _type = _options.type;
            if (_type) {
                if (_type == 'save') {
                    _text = '  保  存  数  据  中';
                } else if (_type == 'print') {
                    _text = '  打  印  数  据  中';
                } else if (_type == 'export') {
                    _text = '  另  存  数  据  中';
                }
            }
            $.messager.progress({
                title: '请耐心等待...',
                text: _text,
                interval: _options.interval ? _options.interval : 1000
            });
        },
        Close: function () {
            $.messager.progress('close');
        }
    },
    PrescTimeLine: function (_opts, _qOpts) {
        var winId = 'PHAOP_UX_PrescTimeLine';
        var lineId = winId + '_Line';
        var existHtml = $('#' + winId).html() || '';
        if (existHtml === '') {
            var winDiv = '<div id=' + winId + ' style="padding:10px"><div id=' + lineId + '></div></div>';
            $('body').append(winDiv);
            var winOpts = {
                title: ' 处方时间轴',
                collapsible: false,
                iconCls: 'icon-w-clock',
                border: false,
                resizable: true,
                minimizable: false,
                maximizable: false,
                closed: true,
                modal: true,
                width: $('body').width() - 40,
                height: 200,
                top: 20,
                left: 20,
                toolbar: null,
                onBeforeClose: function () {}
            };

            $('#' + winId).window($.extend({}, winOpts, _opts));
            $('#' + winId).window('setModalable');
        }
        $('#' + winId).window('open');
       var retData = PHA.CM({
                pClassName: 'PHA.OP.DispQuery.Query',
                pQueryName: 'PrescOperRecords',
                inputStr: _qOpts.prescNo
        },false);
        var itemsArr = [];
        var rowsData = retData;
        for (var i = 0; i < rowsData.length; i++) {
            var rowData = rowsData[i];
            var contextArr = [];
            contextArr.push('<div style="font-weight:normal;color:black;">');
            contextArr.push(rowData.dateTime);
            contextArr.push('</div>');
            contextArr.push('<div style="font-weight:normal;color:black;">');
            contextArr.push(rowData.userName);
            contextArr.push('</div>');
            var item = {};
            item.title = rowData.psName;
            item.context = contextArr.join('');
            itemsArr.push(item);
        }
        $('.hstep').children().remove();
        $('#' + lineId).hstep({
            showNumber: false,
            stepWidth: 200,
            currentInd: rowsData.length,
            items: itemsArr
        });
    }
}
