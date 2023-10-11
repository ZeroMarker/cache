/**
 * 名称:   药房公共
 * 编写人:  yunhaibao
 * 编写日期: 2019-03-12
 * scripts/pha/com/v1/js/com.js
 */
var PHA_COM = {
    /**
     * 对应每个产品菜单的csp全称,注意大小写
     */
    Param: {
        Com: {},
        App: {}
    },
    App: {
        Csp: '',
        Name: '',
        Load: ''
    },
    Session: {
        ALL: session['LOGON.USERID'] + '^' + session['LOGON.CTLOCID'] + '^' + session['LOGON.GROUPID'] + '^' + session['LOGON.HOSPID'],
        USERID: session['LOGON.USERID'],
        CTLOCID: session['LOGON.CTLOCID'],
        HOSPID: session['LOGON.HOSPID'],
        GROUPID: session['LOGON.GROUPID']
    },
    Val: {
        CAData: '',
        CAModelCode: '',
        APPCOMNAME: 'DHCSTCOMMON'
    },
    Ele: {},
    /**
     * 登记号补零, 不需要非必要提醒, 已知登记号才录入, 而不是录入数据保存, yunhaibao
     * @param {String} _patNo
     */
    FullPatNo: function (_patNo) {
        if (_patNo === '') {
            return '';
        }
        if (_patNo <= 0) {
            PHA.Popover({
                msg: '请输入正确的登记号',
                type: 'alert'
            });
            return;
        }
        var pStr = $.cm(
            {
                ClassName: 'PHA.COM.Method',
                MethodName: 'FullPatNo',
                PatNo: _patNo,
                dataType: 'text'
            },
            false
        );
        if (/^0+$/.test(pStr) || pStr == '') {
            PHA.Popover({
                msg: '请输入正确的登记号',
                type: 'alert'
            });
            return '';
        }
        return pStr;
    },
    Input: function () {
        this.Main = {};
        this.Detail = [];
        this.Logon = {
            UserId: session['LOGON.USERID'],
            LocId: session['LOGON.CTLOCID'],
            HospId: session['LOGON.HOSPID'],
            GrpId: session['LOGON.GROUPID']
        };
    },
    Fmt: {
        Grid: {
            Yes: {
                Icon: '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png"></img>',
                Chinese: '<font color="#21ba45">' + $g('是') + '</font>'
            },
            No: {
                Icon: '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/close.png"></img>',
                Chinese: '<font color="#f16e57">' + $g('否') + '</font>'
            },
            Number: function (value, fmtStr) {
                if (!fmtStr || isNaN(value)) {
                    return value;
                }
                var fmtArr = fmtStr.split('.');
                var preLen = fmtArr.length > 1 ? fmtArr[fmtArr.length - 1].length : 0;
                if (preLen >= 0) {
                    value = parseFloat(value).toFixed(preLen);
                }
                var intFmt = fmtArr[0].indexOf(',') >= 0 ? fmtArr[0] : '';
                if (intFmt == '') {
                    return value;
                }
                var intFmtArr = intFmt.split(',');
                var intLen = intFmtArr[intFmtArr.length - 1].length;
                if (intLen <= 0) {
                    return value;
                }
                var regExp = new RegExp('(\\d{1,' + intLen + '})(?=(\\d{' + intLen + '})+(?:$|\\.))', 'g');
                return ('' + value).replace(regExp, '$1,');
            }
        }
    },
    Drug: {
        // styler: PHA_COM.Drug.Color
        Color: function (value, rowData, rowIndex) {
            if (rowData.drugIcon) {
                var drugIconArr = rowData.drugIcon.split('|');
                var _dColor = drugIconArr[0],
                    _dBackColor = drugIconArr[1];
                return 'color:' + _dColor + ';background-color:' + _dBackColor;
            }
            return '';
        },
        // formatter: PHA_COM.Drug.Icon
        Icon: function (value, rowData, rowIndex) {
            var iconStr = '';
            if (rowData.drugIcon) {
                var drugIconArr = rowData.drugIcon.split('|');
                var oneIconStr = '',
                    oneIconArr = [];
                for (var ic = 2; ic < drugIconArr.length; ic++) {
                    oneIconStr = drugIconArr[ic];
                    if (oneIconStr != '') {
                        oneIconArr = oneIconStr.split(':');
                        iconStr += "<img src='../scripts/pha/in/v1/drugicon/" + oneIconArr[0] + "' title='" + oneIconArr[1] + "' class='pha-drugicon' />";
                    }
                }
                return iconStr;
            }
            return iconStr;
        },
        // onLoadSuccess: function(){ PHA_COM.Drug.Tips(); }
        Tips: function () {
            $('.pha-drugicon').hover(
                function (e) {
                    var $t = $(e.target);
                    var imgX = $t.offset().left;
                    var imgY = $t.offset().top;
                    var imgSrc = $t.attr('src');
                    var imgTitle = $t.attr('title');
                    var imgWidth = $t.width();
                    var imgHeight = $t.height();
                    $t.attr('title', '');
                    if (imgTitle != '' && imgTitle != null) {
                        $t.attr('tips_title', imgTitle);
                    }
                    imgTitle = $t.attr('tips_title') || '';
                    var tipWidth = 300;
                    var tipHeight = 134;
                    var povId = 'pha_drug_icon_tips';
                    if ($('#' + povId).length == 0) {
                        var povCss = '';
                        povCss += 'width:' + tipWidth + 'px;';
                        povCss += 'height:' + tipHeight + 'px;';
                        povCss += 'top:' + (imgY - tipHeight / 2) + 'px;';
                        povCss += 'left:' + (imgX + imgWidth + 4) + 'px;';
                        $('body').append('</div><div id="' + povId + '" class="pha-drugicon-tips-body" style="' + povCss + '"></div>');
                    } else {
                        $('#' + povId).css('top', imgY - tipHeight / 2);
                        $('#' + povId).css('left', imgX + imgWidth + 4);
                    }
                    var eHtml = '';
                    eHtml += '<div class="pha-drugicon-tips">';
                    eHtml += '<table style="margin-top:4px;">';
                    eHtml += '<tr>';
                    eHtml += '<td valign="top" align="left" style="width:115px;">';
                    eHtml += '<img src="' + imgSrc + '" style="width:100px;height:100px;" />';
                    eHtml += '</td>';
                    eHtml += '<td valign="top" align="left" style="width:150px;">';
                    eHtml += '<label>' + imgTitle + '<label>';
                    eHtml += '</td>';
                    eHtml += '</tr>';
                    eHtml += '</table>';
                    eHtml += '</div>';
                    $('#' + povId).html(eHtml);
                    $('#' + povId).show();
                },
                function () {
                    var povId = 'pha_drug_icon_tips';
                    $('#' + povId).html('');
                    $('#' + povId).hide();
                }
            );
        }
    },
    /**
     * 导出grid数据导excel
     * @param {String} _id 表格Id
     */
    ExportGrid: function (_id, _fileName) {
        _fileName = _fileName || '数据导出_' + new Date().getTime() + '.xlsx'; // 待加日期
        var $grid = $('#' + _id);
        var newCols;
        // var cols = $grid.datagrid('options').columns[0];
        // var frozenCols = $grid.datagrid('options').frozenColumns[0];
        // 处理抬头 取最后一行数据表头
        var cols = PHA_COM.SetColsLastTitle($grid.datagrid('options').columns);
        var frozenCols = PHA_COM.SetColsLastTitle($grid.datagrid('options').frozenColumns);
        if (frozenCols != undefined) {
            newCols = frozenCols.concat(cols);
        } else {
            newCols = cols;
        }
        var exportChkCol = $grid.datagrid('options').exportChkCol;

        var mField = '';
        var titleObj = {};
        var colsFormatter = {};
        for (var ncI = 0; ncI < newCols.length; ncI++) {
            var colIModal = newCols[ncI];
            if (colIModal.checkbox == true) {
                continue;
            }
            if (exportChkCol) {
                if (colIModal.ifExport == false) {
                    continue;
                }
            } else {
                if (colIModal.hidden) {
                    continue;
                }
            }
            mField = colIModal.descField ? colIModal.descField : colIModal.field;
            titleObj[mField] = colIModal.title;
            if (colIModal.formatter) {
                colsFormatter[mField] = colIModal.formatter;
            }
        }
        // 取参数,url不一定是$URL
        var queryParams = $grid.datagrid('options').queryParams;
        var url = $grid.datagrid('options').url || '';
        if (url == '') {
	        $grid.datagrid('getData').originalRows = $grid.datagrid('getRows');
	    } else {
		    if (url.indexOf('?') < 0) {
	            url = url + '?';
	        }
	        url += '&page=1&rows=9999';
		}
        
        PHA.Loading('Show');
        // 增加日志
        if (typeof App_MenuCsp == '') {
            var logParams = JSON.parse(JSON.stringify(queryParams));
            logParams.url = url;
            PHA_LOG.Operate({
                operate: 'E',
                logInput: JSON.stringify(logParams),
                // logInput: logParams,
                type: 'page',
                pointer: App_MenuCsp,
                origData: '',
                remarks: App_MenuName
            });
        }

        var origRows = $grid.datagrid('getData').originalRows;
        if (typeof origRows === 'undefined') {
            // 遮罩与消失
            $.ajax({
                type: 'GET',
                url: url,
                async: true,
                data: queryParams,
                dataType: 'json',
                success: function (data) {
                    PHA.Loading('Hide');
                    // 重新序列data
                    var rowsData = data.rows;
                    PHA_UTIL.LoadJS(['../scripts/pha/com/v1/js/export.js'], function () {
                        PHA_EXPORT.XLSX(titleObj, rowsData, _fileName, colsFormatter);
                    });
                }
            });
        } else {
            PHA.Loading('Hide');
            var rowsData = JSON.parse(JSON.stringify(origRows));
            PHA_UTIL.LoadJS(['../scripts/pha/com/v1/js/export.js'], function () {
                PHA_EXPORT.XLSX(titleObj, rowsData, _fileName, colsFormatter);
            });
        }
    },
    SetColsLastTitle: function (cols) {
        var y = cols.length;
        if (y <= 1) return cols[0];

        var x = 0;
        var firstCols = cols[0];
        for (i = 0; i < firstCols.length; i++) {
            var col = firstCols[i];
            var colspan = col.colspan || 1;
            x = x + colspan;
        }
        /* 定义个二维数组，将所有合并表格拆分成单个单元格 */
        var arr = new Array(y);
        for (j = 0; j < y; j++) {
            arr[j] = new Array(x);
        }
        for (var m = 0; m < y; m++) {
            var rowcols = cols[m];
            for (var n = 0; n < rowcols.length; n++) {
                var colObj = cols[m][n];
                var colspan = colObj.colspan || 1;
                var rowspan = colObj.rowspan || 1;
                for (var j = 0; j < rowspan; j++) {
                    for (var h = 0; h < colspan; h++) {
                        /* 获取当前y行第一个空元素的位置 */
                        var lastX = PHA_COM.GetLastX4Arr(arr[m + j]); // 如果遇到单行对象，直接取arr行最后一个空元素的位置即可
                        if (rowspan > 1) {
                            // 如果遇到多行的元素，则直接取父对象的位置再拓展
                            var sameX = PHA_COM.GetFristX4Arr(arr[m], colObj, 'title');
                            if (sameX != '') lastX = sameX + h;
                        }
                        if (lastX === '') break;
                        if (!(arr[m + j][lastX] instanceof Object)) {
                            arr[m + j][lastX] = copy = JSON.parse(JSON.stringify(cols[m][n])); //必须使用深复制，不然修改改cols的值。
                            if (m + j >= 1) {
                                if (arr[m + j][lastX].title.indexOf(arr[m + j - 1][lastX].title) < 0) {
                                    arr[m + j][lastX].title = arr[m + j - 1][lastX].title + '-' + arr[m + j][lastX].title;
                                }
                            }
                        }
                    }
                }
            }
        }
        return arr[arr.length - 1];
    },
    GetLastX4Arr: function (arr) {
        for (i = 0; i < arr.length; i++) {
            if (arr[i] == undefined) return i;
        }
        return '';
    },
    GetFristX4Arr: function (arr, obj, field) {
        for (i = 0; i < arr.length; i++) {
            if (arr[i] instanceof Object && Reflect.has(arr[i], field) && arr[i][field] == obj[field]) return i;
        }
        return '';
    },

    /**
     * 直接打印Grid数据
     * @param {String} _id 表格Id
     * @param {Object} _printFn 自定义打印函数
     */
    PrintGrid: function (_id, _printFn) {
        if (typeof PHA_LODOP == 'undefined') {
            PHA_COM._Alert('请在csp引入<label style="color:red;">&lt;PHAPRINTCOM &frasl;&gt;</label>标签!', 'error');
            return;
        }
        var $GRID = $('#' + _id);
        if ($GRID.length == 0) {
            return;
        }
        var gridClsName = $GRID[0].className || '';
        var gUrl = '',
            gParams = {},
            gColumns = [];
        if (gridClsName.indexOf('datagrid') >= 0) {
            var _gridOpts = $GRID.datagrid('options');
            gUrl = _gridOpts.url;
            gParams = _gridOpts.queryParams;
            var pColumns = _gridOpts.columns[0];
            for (var i = 0; i < pColumns.length; i++) {
                var iCol = pColumns[i];
                if (_gridOpts.printChkCol) {
                    if (iCol.ifPrint == 1) {
                        gColumns.push(iCol);
                    }
                } else {
                    if (iCol.hidden == true) {
                        continue;
                    }
                    gColumns.push(iCol);
                }
            }
        } else if (gridClsName.indexOf('jqgrid') >= 0) {
            gUrl = $GRID.jqGrid('getGridParam', 'url');
            gParams = $GRID.jqGrid('getGridParam', 'postData');
            var pColumns = $GRID.jqGrid('getGridParam', 'colModel');
            for (var i = 0; i < pColumns.length; i++) {
                var iCol = pColumns[i];
                if (iCol.hidden == true) {
                    continue;
                }
                gColumns.push(iCol);
            }
        } else {
            PHA_COM._Alert('this grid id is not supported!');
            return;
        }
        gParams['page'] = 1;
        gParams['rows'] = 9999;

        var pGridData = {};
        if (gUrl == '') {
            pGridData = $GRID.datagrid('getData');
        } else {
            $.ajax({
                url: gUrl,
                data: gParams,
                type: 'post',
                async: false,
                dataType: 'json',
                success: function (jsonData) {
                    pGridData = jsonData;
                },
                error: function (XMLHR, err) {
                    PHA_COM._Alert(err);
                }
            });
        }
        var gData = pGridData.rows;
        if (pGridData.footer) {
            for (var i = 0; i < pGridData.footer.length; i++) {
                gData.push(pGridData.footer[i]);
            }
        }
        if (gData.length == 0) {
            return;
        }
        if (_printFn) {
            _printFn({
                data: gData,
                columns: gColumns
            });
            return;
        }
        function printOut() {
            new PHA_LODOP.Init('PHA_Print_DataGrid')
                .Page('Orient:1; Width:0; Height:0; PageName:A4')
                .PageNo('Top:2mm; Left:165mm;')
                .Html({
                    // 区域
                    type: 'table',
                    FromTop: 30,
                    FromLeft: 5,
                    DivWidth: '98%',
                    DivHeight: '94%',
                    // 表格
                    width: 195,
                    fitColumns: true,
                    borderStyle: 4,
                    padding: 2,
                    fontSize: 12,
                    rowHeight: 10,
                    // 列信息
                    data: gData,
                    columns: gColumns
                })
                .Print();
        }
        printOut();
    },
    // 兼容非hisui提示框
    _Alert: function (msgContent, msgType) {
        if ($.messager) {
            msgType = msgType || 'error';
            $.messager.alert('温馨提示', msgContent, msgType);
            return;
        }
        alert(msgContent);
    },
    /**
     * @param {json} _data json格式数据
     * @param {Array} _cmArr 可导出的col属性
     * @param {String} _fileName 可选参数
     */
    ExportData: function (_data, _cmArr, _fileName) {
        var dataArr = [];
        // 标题列
        var titleArr = [];
        for (var colI = 0; colI < _cmArr.length; colI++) {
            var colIModal = _cmArr[colI];
            if (colIModal.hidden || colIModal.checkbox) {
                continue;
            }
            titleArr.push(colIModal.title);
        }
        dataArr.push(titleArr);
        var rowsLen = _data.length;
        for (var i = 0; i < rowsLen; i++) {
            var rowData = _data[i];
            var oneRowArr = [];
            for (var colI = 0; colI < _cmArr.length; colI++) {
                var colIModal = _cmArr[colI];
                var field = colIModal.field;

                if (colIModal.hidden || colIModal.checkbox) {
                    continue;
                }
                if (colIModal.descField) {
                    cellData = rowData[colIModal.descField];
                } else {
                    var formater = colIModal.formatter;
                    var cellData = '';
                    if (formater) {
                        cellData = formater(rowData[field], rowData);
                        if (/(<[a-z].*>).*(<\/[a-z].*>$)/g.test(cellData)) {
                            // 有<das></dsa>此类格式取原始值
                            cellData = rowData[field];
                        }
                    } else {
                        cellData = rowData[field];
                    }
                }
                var regExp = /^([0-9]\d*)-([0-9]\d*)-([0-9]\d*)$/; // x-x-x
                var regExpT = /^([0-9]\d*)-([0-9]\d*)-([0-9]\d*) ([0-9]\d*):([0-9]\d*):([0-9]\d*)$/; // x-x-x b:b:b
                if (regExp.test(cellData) == true || regExpT.test(cellData) == true) {
                    //cellData = "'" + cellData;
                }
                if (parseInt(cellData) == cellData && cellData != 0) {
                    if (cellData.toString().charAt(0) == 0) {
                        //cellData = "'" + cellData;
                    }
                }
                if (cellData.indexOf('</br>') >= 0) {
                    //cellData = '"' + cellData + '"';
                    cellData = cellData.replace(/<\/br>/g, '\r\n');
                }
                oneRowArr.push(cellData);
            }
            dataArr.push(oneRowArr);
        }

        ExportUtil.toExcel(dataArr, _fileName);
    },
    /**
     * @description 读取excel数据
     * 使用时需单独引用
     * <script type="text/javascript" src="../scripts/pha/plugins/xlsx/xlsx.full.min.js"></script>
     */
    ReadExcel: function (file, callBack) {
        // 先固定这么写
        if (!FileReader.prototype.readAsBinaryString) {
            FileReader.prototype.readAsBinaryString = function (fileData) {
                var binary = '';
                var pk = this;
                var reader = new FileReader();
                reader.onload = function (e) {
                    var bytes = new Uint8Array(reader.result);
                    var length = bytes.byteLength;
                    for (var i = 0; i < length; i++) {
                        var a = bytes[i];
                        var b = String.fromCharCode(a);
                        binary += b;
                    }
                    pk.content = binary;
                    $(pk).trigger('onload');
                };
                reader.readAsArrayBuffer(fileData);
            };
        }
        var reader = new FileReader();
        reader.onload = function (e) {
            if (reader.result) {
                reader.content = reader.result;
            }
            // In IE browser event object is null
            var data = e ? e.target.result : reader.content;
            // var baseEncoded = btoa(data);
            // var wb = XLSX.read(baseEncoded, {type: 'base64'});
            workBook = XLSX.read(data, {
                type: 'binary'
            });
            var jsonData = {};
            var result = XLSX.utils.sheet_to_json(workBook.Sheets[workBook.SheetNames[0]]);
            callBack(result, workBook);
            // result 即为所有数据
            // 数据格式,LocDesc等为首行标题,具体应用自己定义
            // [{LocDesc: 1, InciCode: 2, InciDesc: 3, PHCDFSCDIDr: 4, PHCDFMenstruumFlag: 5}]
        };
        reader.readAsBinaryString(file);
    },
    GenHospCombo: function (_options) {
        var tableName = _options.tableName || '';
        if (tableName === '') {
            PHA_COM._Alert('程序错误,未传授权表名或代码', 'error');
            return;
        }
        var hospAutFlag = tkMakeServerCall('PHA.FACE.IN.Com', 'GetHospAut');
        if (hospAutFlag === 'Y') {
            $($('body>.hisui-layout')[0]).layout('add', {
                region: 'north',
                border: false,
                height: 40,
                split: false,
                bodyCls: 'pha-ly-hosp',
                content:
                    '<div style="padding-left:10px;">' +
                    '   <div class="pha-row">' +
                    '       <div class="pha-col">' +
                    '           <label id="_HospListLabel" style="color:red;">医院</label>' +
                    '       </div>' +
                    '       <div class="pha-col">' +
                    '           <input id="_HospList" class="textbox"/>' +
                    '       </div>' +
                    '   </div>' +
                    '</div>'
            });
            var genHospObj = GenHospComp(tableName);
            return genHospObj;
        } else {
            return '';
        }
    },
    /**
     * 数据导出为文件(可以导出的格式: xls/xlsx/txt/jpg/gif)
     * @creator Huxt 2020-07-28
     * @param {Object} title    - 可选参数,主要有两个作用:1.指定需要导出的列信息;2.指定列标提中文. 例如: {name:'姓名', age:'年龄'}
     * @param {Array}  data        - 数据内容,为json格式. 例如: [{name:'张三', age:25}, {name:'李四', age:30}, ...]
     * @param {string} fileName - 文件名称. 例如: xxx.xlsx
     * @return null
     */
    ExportFile: function (title, data, fileName) {
        var fileNameArr = fileName.split('.');
        var suffix = '.' + fileNameArr[fileNameArr.length - 1];
        if (suffix == '.xls' || suffix == '.xlsx') {
            PHA_UTIL.LoadJS(['../scripts/pha/com/v1/js/export.js'], function () {
                fileName = PHA_EXPORT.GetFileName(fileName);
                PHA_EXPORT.XLSX(title, data, fileName);
            });
        } else if (suffix == '.txt') {
            PHA_UTIL.LoadJS(['../scripts/pha/com/v1/js/export.js'], function () {
                fileName = PHA_EXPORT.GetFileName(fileName);
                PHA_EXPORT.TXT(title, data, fileName);
            });
        } else if (suffix == '.jpg' || suffix == '.gif') {
            PHA_UTIL.LoadJS(['../scripts/pha/com/v1/js/export.js'], function () {
                fileName = PHA_EXPORT.GetFileName(fileName);
                PHA_EXPORT.IMAGE(title, data, fileName);
            });
        } else {
            PHA_COM._Alert('不支持导出的文件类型:' + suffix);
        }
    },
    /**
     * 导入文件/读取文件的数据 (可以导出的格式: xls/xlsx/txt/jpg/gif)
     * @creator Huxt 2020-07-28
     * @param {Object}  _options.charset: 读取的文件编码, 例如: utf-8 / gb2312
     *                  _options.suffixReg: 文件格式验证正则表达式, 例如: /^(.xls)|(.xlsx)$/
     * @param {Function}  data: 回调函数
     * @return null
     * others: PHA_COM.ImportFile()
     */
    ImportFile: function (_options, _callFn) {
        // 定义创建文件框方法
        var createFileBox = function (_thisCall) {
            var inputFileBox = document.createElement('input');
            inputFileBox.type = 'file';
            inputFileBox.onchange = function () {
                var files = this.files || [];
                if (files.length == 0) {
                    PHA_COM._Alert('未选择文件!');
                    return;
                }
                var file = files[0];
                var fileName = file.name;
                var reversedArr = fileName.split('.');
                var reversedLen = reversedArr.length;
                var fileSuffix = '.' + reversedArr[reversedLen - 1]; // 文件后缀

                var defaultReg = /^(.xml)|(.txt)|(.xls)|(.xlsx)|(.jpg)|(.gif)$/;
                var suffixReg = _options.suffixReg || defaultReg;
                if (suffixReg == '') {
                    suffixReg = defaultReg;
                }
                var suffixRegStr = suffixReg.toString().replace('/^', '').replace('$/', '');

                if (suffixReg.test(fileSuffix) == false) {
                    PHA_COM._Alert('文件格式错误, 请选择后缀为: ' + suffixRegStr + ' 的文件!');
                    return;
                }
                _thisCall && _thisCall(file);
            };
            document.body.appendChild(inputFileBox);
            inputFileBox.click();
        };
        // 定义读取文件的入口方法
        var readFile = function (file) {
            if (!file) {
                PHA_COM._Alert('未选择文件!');
                return;
            }
            var fileName = file.name || '';
            if (fileName == '') {
                PHA_COM._Alert('未选择文件!');
                return;
            }
            var reversedArr = fileName.split('.');
            var reversedLen = reversedArr.length;
            var fileSuffix = '.' + reversedArr[reversedLen - 1]; // 文件后缀
            if (fileSuffix == '.xls' || fileSuffix == '.xlsx') {
                PHA_COM.ReadExcel(file, function (data, workBook) {
                    _callFn && _callFn(data, file, workBook); // read excel, this data is json
                });
            } else {
                readAsData(file, function (data) {
                    _callFn && _callFn(data, file); // data is text
                });
            }
        };
        // 定义读取 txt & xml & img 的方法
        var readAsData = function (file, _thisCall) {
            if (!FileReader) {
                PHA_COM._Alert('浏览器不支持FileReader,请使用Chrome');
                return;
            }
            var _mCharset = _options.charset || 'gb2312' || 'utf-8';
            var reader = new FileReader();
            if (/text+/.test(file.type)) {
                reader.onload = function () {
                    _thisCall && _thisCall(this.result);
                };
                reader.readAsText(file, _mCharset); /*读取文本文件*/
            } else if (/image+/.test(file.type)) {
                reader.onload = function () {
                    _thisCall && _thisCall(this.result);
                };
                reader.readAsDataURL(file); /*读取图片文件*/
            } else {
                PHA_COM._Alert('仅能读取txt & xml & img文件');
            }
        };
        // 加载并执行
        PHA_UTIL.LoadJS(['../scripts/pha/plugins/xlsx/xlsx.full.min.js'], function () {
            createFileBox(readFile);
        });
    },
    /**
     * 读卡公共方法 (不需要卡类型,iMedical8.4+可用)
     * Huxt 2020-08-24
     * @param {object}  _options
     *                  _options.CardNoId: CSP中INPUT标签的id
     *                  _options.PatNoId: CSP中INPUT标签的id
     * @param {string}  _fn: 回调函数
     * @return
     * @others: 使用该方法注意需要在csp中引用:
     *  <server>d ##class(PHA.COM.ReadCard).LoadPlugin()</server>
     *  <ADDINS require="RWCard,PublicReadPerson"/>
     *  PHA_COM.ReadCard({CardNoId:'', PatNoId:''}, function(){ // dosomething});
     */
    ReadCard: function (_options, _fn) {
        // 界面ID传给全局变量
        var cardNoId = _options.CardNoId;
        var patNoId = _options.PatNoId;
        var cardTypeId = _options.CardTypeId;
        PHA_COM.ReadCardTemp = PHA_COM.ReadCardTemp ? PHA_COM.ReadCardTemp : {};
        PHA_COM.ReadCardTemp.cardNoId = cardNoId;
        PHA_COM.ReadCardTemp.patNoId = patNoId;
        PHA_COM.ReadCardTemp.cardTypeId = cardTypeId;
        PHA_COM.ReadCardTemp.fn = _fn;
        // 调用读卡
        var patCarNo = $('#' + cardNoId).val();
        if (patCarNo != '') {
            DHCACC_GetAccInfo('', patCarNo, '', 'PatInfo', 'PHA_COM.CardTypeCallBack');
        } else {
            DHCACC_GetAccInfo7('PHA_COM.CardTypeCallBack');
        }
    },
    // 读卡回调函数
    CardTypeCallBack: function (readRet) {
        var cardNoId = PHA_COM.ReadCardTemp.cardNoId;
        var patNoId = PHA_COM.ReadCardTemp.patNoId;
        var cardTypeId = PHA_COM.ReadCardTemp.cardTypeId;
        var _fn = PHA_COM.ReadCardTemp.fn;
        if (readRet == false) {
            $.messager.popover({
                msg: '卡无效！',
                type: 'error',
                timeout: 1000
            });
            return;
        }
        var readRetArr = readRet.split('^');
        var readRtn = readRetArr[0];
        switch (readRtn) {
            case '0':
                // 卡有效
                PatientID = readRetArr[4];
                PatientNo = readRetArr[5];
                CardNo = readRetArr[1];
                $('#' + cardNoId).val(CardNo);
                $('#' + patNoId).val(PatientNo);
                $('#' + cardTypeId).val(readRetArr[8]);
                _fn && _fn(readRet);
                break;
            case '-1':
                $.messager.popover({
                    msg: '请检查读卡器，或者输入卡号后重试！',
                    type: 'error',
                    timeout: 1000
                });
                break;
            case '-200':
                $.messager.popover({
                    msg: '卡无效！',
                    type: 'error',
                    timeout: 1000
                });
                break;
            case '-201':
                //现金
                PatientID = readRetArr[4];
                PatientNo = readRetArr[5];
                CardNo = readRetArr[1];
                $('#' + cardNoId).val(CardNo);
                $('#' + patNoId).val(PatientNo);
                $('#' + cardTypeId).val(readRetArr[8]);
                _fn && _fn(readRet);
                break;
            default:
        }
    },
    /**
     * 重置Panel大小
     * @param {object}  _options
     *                  _options.layoutId: layout div 的id
     *                  _options.region: north / south & east / west
     *                  _options.height: 当 region 为 north / south 的高度比例
     *                  _options.width: 当 region 为 east / west 的宽度比例
     * @params {boolean} autoResize true|false 是否同时绑定window.resize, 以使窗口变化大小后动态调整布局
     * @others: PHA_COM.ResizePanel({});
     */
    ResizePanel: function (_options, autoResize) {
        autoResize = autoResize === false ? false : true;
        var $Layout = $('#' + _options.layoutId);
        if ($Layout.length == 0) {
            return;
        }
        var resizeOpts = {};
        if (_options.height < 1) {
            var vHeight = $Layout.height();
            resizeOpts.height = parseInt(_options.height * vHeight);
        }
        if (_options.width < 1) {
            var vWidth = $Layout.width();
            resizeOpts.width = parseInt(_options.width * vWidth);
        }
        $Layout.layout('panel', _options.region).panel('resize', resizeOpts);
        $Layout.layout('resize');
        if (autoResize === true) {
            $(window).resize(function () {
                console.log(_options);
                setTimeout(function () {
                    PHA_COM.ResizePanel(_options, false);
                }, 500);
            });
        }
    },
    /**
     * HIS菜单是否为页签形式
     */
    IsTabsMenu: function () {
        try {
            if (top.document.getElementById('centerPanel').getElementsByTagName('iframe')[0].contentWindow.document.getElementById('TRAK_tabs') !== null) {
                return true;
            }
        } catch (e) {}
        return false;
    },
    PatNoLength: function () {
        return $.cm(
            {
                ClassName: 'PHA.COM.Method',
                MethodName: 'PatNoLen'
            },
            false
        );
    },
    /**
     * 分组拆分表格数据,成组医嘱等
     * @param {*} data
     * @returns
     */
    LocalFilterGroup: function (data) {
        var $grid = $(this);
        var opts = $grid.datagrid('options');
        var pager = $grid.datagrid('getPager');
        var linkField = opts.linkField;
        pager.pagination({
            onSelectPage: function (pageNum, pageSize) {
                opts.pageNumber = pageNum;
                opts.pageSize = pageSize;
                pager.pagination('refresh', {
                    pageNumber: pageNum,
                    pageSize: pageSize
                });
                $grid.datagrid('loading');
                setTimeout(function () {
                    $grid.datagrid('loadData', data);
                }, 100);
            }
        });
        if (!data.originalRows) {
            data.originalRows = data.rows;
        }
        var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
        var end = start + parseInt(opts.pageSize);
        data.rows = SliceSignRows(data.originalRows, start, end, linkField);
        data.total = Total(data.originalRows, linkField);
        return data;

        function Total(originalRows, signField) {
            var cnt = 0;
            var signArr = [];
            for (var i = 0, len = originalRows.length; i < len; i++) {
                var rowData = originalRows[i];
                var signValue = rowData[signField];
                if (signArr.indexOf(signValue) < 0) {
                    signArr.push(signValue);
                    cnt++;
                }
            }
            return cnt;
        }
        function SliceSignRows(originalRows, start, end, signField) {
            var hideRules = $grid.datagrid('options').hideRules;
            var altField = $grid.datagrid('options').altField;
            var lastAltFieldVal = '',
                altFlag = '';
            // 用于存隐藏的主键
            var hideRuleMap = {};
            for (var hideKey in hideRules) {
                hideRuleMap[hideKey] = {
                    cnt: 0,
                    lastValue: '',
                    hideFields: hideRules[hideKey]
                };
            }
            var retRows = [];
            var signArr = [];
            var cnt = 0;
            for (var i = 0, len = originalRows.length; i < len; i++) {
                var rowData = originalRows[i];
                var signValue = rowData[signField];
                if (signArr.indexOf(signValue) < 0) {
                    signArr.push(signValue);
                    cnt++;
                }
                if (cnt <= start) {
                    continue;
                }
                if (cnt > end) {
                    break;
                }
                // 处理隐藏
                for (var mapKey in hideRuleMap) {
                    var tmpValue = rowData[mapKey];
                    if (hideRuleMap[mapKey].lastValue !== '' && hideRuleMap[mapKey].lastValue === tmpValue) {
                        hideRuleMap[mapKey].hideFields.forEach(function (value) {
                            rowData[value] = '';
                        });
                    }
                    hideRuleMap[mapKey].lastValue = tmpValue;
                }
                // 处理隔行变色
                var altFieldVal = rowData[altField];
                if (lastAltFieldVal !== '' && altFieldVal !== '') {
                    if (lastAltFieldVal !== altFieldVal) {
                        altFlag = altFlag === '' ? 'Y' : '';
                    }
                }
                if (altFieldVal !== '') {
                    lastAltFieldVal = altFieldVal;
                }
                rowData.altFlag = altFlag;
                retRows.push(rowData);
            }
            return retRows;
        }
    },
    LinkCheck: {
        Check: function (rowIndex, rowData) {
            PHA_COM.LinkCheck.Exe($(this), 'checkRow', rowIndex, rowData);
        },
        UnCheck: function (rowIndex, rowData) {
            PHA_COM.LinkCheck.Exe($(this), 'uncheckRow', rowIndex, rowData);
        },
        Select: function (rowIndex, rowData) {
            PHA_COM.LinkCheck.Exe($(this), 'selectRow', rowIndex, rowData);
        },
        UnSelect: function (rowIndex, rowData) {
            $(this).datagrid('unselectAll');
        },
        Exe: function ($grid, type, rowIndex, rowData) {
            if ($grid.datagrid('options').checking == true) {
                return;
            }
            $grid.datagrid('options').checking = true;
            if (type === 'selectRow') {
                $grid.datagrid('unselectAll');
            }
            var linkField = $grid.datagrid('options').linkField;
            var linkValue = rowData[linkField];
            var rows = $grid.datagrid('getRows');
            var len = rows.length;
            for (var i = rowIndex; i < len; i++) {
                if (linkValue === rows[i][linkField]) {
                    $grid.datagrid(type, i);
                } else {
                    break;
                }
            }
            // 向上
            for (var j = rowIndex; j >= 0; j--) {
                if (linkValue === rows[j][linkField]) {
                    $grid.datagrid(type, j);
                } else {
                    break;
                }
            }
            $grid.datagrid('options').checking = '';
        }
    },
    /**
     * 重置pha-col的宽度,实现label自动对齐
     * @param {object}  _options
     *                  _options.id: string, 应为pha-row和pha-col所在的外层div的id, 例如: <div id='xxx'><div class='pha-row'><div class='pha-col'></div></div></div>
     *                  _options.timeout: int, 延时执行; 默认为10
     *                  _options.forLable: boolean, 是否只对包含for属性的label重置宽度; 默认true
     *                  _options.maxWidth: int, 限定最大宽度; 默认100
     * @others: PHA_COM.ResizePhaCol();
     */
    ResizePhaColParam: {
        auto: false,
        idArr: [],
        maxWidth: 200
    },
    ResizePhaCol: function (_options) {
        _options = _options || {};
        _options.forLable = _options.forLable != false ? true : false;
        _options.maxWidth = _options.maxWidth || this.ResizePhaColParam.maxWidth;
        var outterId = _options.id || _options.outterId || '';
        if (this.ResizePhaColParam.idArr.indexOf(outterId) >= 0) {
            return;
        }
        this.ResizePhaColParam.idArr.push(outterId);
        var timeout = _options.timeout || 0;
        var _tFn = function () {
            if (outterId == '') {
                var $_phaRows = $('.pha-row');
                var rowsParArr = [];
                $_phaRows.each(function (index, ele) {
                    var $_row = $(this);
                    var $_par = $_row.parent();
                    var hasPar = false;
                    for (var t = 0; t < rowsParArr.length; t++) {
                        if ($_par.is(rowsParArr[t])) {
                            hasPar = true;
                            break;
                        }
                    }
                    if (hasPar == false) {
                        rowsParArr.push($_par);
                        $_row.children().each(function (index, ele) {
                            PHA_COM._ResizeOnePhaCol($(this), _options);
                        });
                    }
                });
            } else {
                var $_phaRows = $('#' + outterId + ' .pha-row');
                if ($_phaRows.length == 0) {
                    return;
                }
                var $_firstRow = $($_phaRows[0]);
                $_firstRow.children().each(function (index, ele) {
                    PHA_COM._ResizeOnePhaCol($(this), _options);
                });
            }
        };
        setTimeout(function () {
            _tFn();
        }, timeout);
    },
    _ResizeOnePhaCol: function (jqCol, _options) {
        var $_phaCol = jqCol;
        var colWidth = $_phaCol.width();
        var $_phaRow = $_phaCol.parent();
        var $_phaCols = $_phaRow.children();
        var colIndex = $_phaCols.index($_phaCol);
        var maxColWidth = colWidth;
        var $_otherRows = $_phaRow.siblings('.pha-row');
        var colArr = [];
        $_otherRows.each(function (index, ele) {
            var $_oneCol = $(this).children().eq(colIndex);
            colArr.push($_oneCol);
            var tWidth = $_oneCol.width();
            maxColWidth = tWidth > maxColWidth ? tWidth : maxColWidth;
        });
        if (maxColWidth > _options.maxWidth) {
            maxColWidth = _options.maxWidth;
        }
        if (maxColWidth <= 0) {
            return; // 没有意义 TODO...
        }
        var _updColFn = function ($_c, w) {
            if (_options.forLable) {
                if (typeof $_c.children('label').eq(0).attr('for') != 'undefined') {
                    $_c.attr('style', '')
                        .css('text-align', 'right')
                        .width(maxColWidth + 1);
                }
            } else {
                if (typeof $_c.children('label').eq(0).attr('for') != 'undefined') {
                    $_c.attr('style', '').css('text-align', 'right');
                }
                $_c.width(maxColWidth + 1);
            }
        };
        _updColFn($_phaCol, maxColWidth);
        for (var c = 0; c < colArr.length; c++) {
            _updColFn(colArr[c], maxColWidth);
        }
        return;
    },
    DataApi: {
        Msg: function (msgJson) {
            var messageStr = msgJson.message;
            messageArr = messageStr.split('</br>');
            messageStr = messageArr.slice(0, 5).join('</li><li style="padding-left:13px;padding-top:5px;">');
            var msg = '';
            msg += '<div style="line-height:32px">';
            msg += '    <span style="color:#757575;font-weight:bold">总记录:' + msgJson.recordCnt + '</span>';
            msg += '    <span style="padding-left:10px;color:#00B69C;font-weight:bold">成功:' + msgJson.succCnt + '</span>';
            msg += '    <span style="padding-left:10px;color:#FFA804;font-weight:bold">失败:' + msgJson.failCnt + '</span>';
            msg += '</div>';
            msg += '<div style="border-top:1px solid #cccccc;margin-left:-40px;margin-top:10px"></div>';
            msg += '<div style="color:#757575;padding-top:10px;margin-left:-13px">';
            msg += '    <ul style="list-style-type:disc;">';
            msg += '        <li style="padding-left:13px">' + messageStr + '</li>';
            msg += '    </ul>';
            msg += '</div>';
            return msg;
        }
    },
    ParamProp: function (AppName) {
        return $.cm(
            {
                ClassName: 'PHA.COM.Method',
                MethodName: 'GetParamProp',
                AppName: AppName,
                Param: [PHA_COM.Session.GROUPID, PHA_COM.Session.CTLOCID, PHA_COM.Session.USERID, PHA_COM.Session.HOSPID].join('^')
            },
            false
        );
    },
    SetPanel: function (target, desc) {
        if (desc == undefined) {
            desc = App_MenuName;
        }
        //$(target).layout('panel', _options.region).panel('resize', resizeOpts);
        $(target).panel({
            title: PHA_COM.IsTabsMenu() !== true ? desc : '',
            headerCls: 'panel-header-gray ',
            iconCls: 'icon-template',
            bodyCls: 'panel-body-gray',
            fit: true
        });
        // 父级需要resize, 否则界面有空白
        $($(target).closest('.hisui-layout')).layout('resize');
    },
    Window: {
        Proportion: 0.85,
        /**
         * 弹窗默认宽度
         * @param() target dom目标, 默认为body
         * @return  可用数值
         * @example PHA_COM.Window.Width()
         */
        Width: function (target) {
            target = target || 'body';
            return $(target).width() * this.Proportion;
        },
        /**
         * 弹窗默认高度
         */
        Height: function (target) {
            target = target || 'body';
            return $(target).height() * this.Proportion;
        },
        Defaults: function () {
            return {
                width: PHA_COM.Window.Width(),
                height: PHA_COM.Window.Height()
            };
        }
    },
    /**
     * 转换为jquery筛选器的目标形式, 一般用于处理ID追加#号
     * @param {*} target
     */
    Fmt2IdTarget: function (target) {
        if (target.indexOf('#') < 0) {
            target = '#' + target;
        }
        return target;
    },
    /**
     * 计算合计
     * @param {*} target
     * @param {*} fieldArr
     * @returns
     * @example
     *          PHA_COM.SumGridData('#gridPlan',['rpAmt'])
     */
    SumGridData: function (target, fieldArr) {
        target = PHA_COM.Fmt2IdTarget(target);
        fieldArr = fieldArr || [];
        var ret = {};
        // zz
        var gridData = $(target).datagrid('getData');
        if (gridData.inputRows != undefined) {
            var rows = gridData.inputRows;
        } else if (gridData.originalRows != undefined) {
            var rows = gridData.originalRows;
        } else if (gridData.firstRows != undefined) {
            var rows = gridData.firstRows;
        } else {
            var rows = gridData.rows;
        }

        //var rows = $(target).datagrid('getRows');
        var tmpFixLen = 2;
        for (var i = 0, length = fieldArr.length; i < length; i++) {
            var field = fieldArr[i];
            var tmpFixLen = 2;
            ret[field] = 0;
            for (var rows_i = 0, rows_length = rows.length; rows_i < rows_length; rows_i++) {
                var row = rows[rows_i];
                var val = row[field];
                if (val === '' || val === undefined) {
                    continue;
                }
                ret[field] = _.safecalc('add', ret[field], val);
                var fixStr = val.toString().split('.')[1];
                if (fixStr !== undefined) {
                    tmpFixLen = Math.max(fixStr.length, tmpFixLen);
                }
            }
            ret[field] = PHA_COM.Fmt.Grid.Number(_.toFixed(ret[field], tmpFixLen), '#0,000.00');
        }
        return ret;
    },
    /**
     * 刷新合计
     * @example SumGridFooter('#gridPlan',['rpAmt'])
     */
    SumGridFooter: function (target, fieldArr) {
        target = PHA_COM.Fmt2IdTarget(target);
        $(target).datagrid('reloadFooter', this.SumGridFooterData(target, fieldArr));
    },
    SumGridFooterData: function (target, fieldArr, origData) {
        target = PHA_COM.Fmt2IdTarget(target);
        fieldArr = fieldArr || $(target).datagrid('options').footerSumFields || [];
        var ret = this.SumGridData(target, fieldArr);
        var records = '';
        var gridData = $(target).datagrid('getData');
        if (gridData.inputRows != undefined) {
            records = gridData.inputRows.length;
        } else if (gridData.originalRows != undefined) {
            records = gridData.originalRows.length;
        } else if (gridData.firstRows != undefined) {
            records = gridData.firstRows.length;
        } else {
            records = gridData.rows.length;
        }
        var showFields = PHA_GridEditor.GetShowColumnFields(target, {
            max: 2,
            fmt2DescField: true
        });
        ret[showFields[0]] = $g('合计');
        ret[showFields[1]] = $g('共') + records + $g('条记录');
        return [ret];
    },
    HandleCheckStyle: function (target, method, rowIndex) {
        target = PHA_COM.Fmt2IdTarget(target);
        var checkEvents = {
            onCheck: function (rowIndex) {
                $(target)
                    .parent()
                    .find('[datagrid-row-index=' + rowIndex + '] td')
                    .addClass('pha-datagrid-check-delete');
            },
            onUncheck: function (rowIndex) {
                $(target)
                    .parent()
                    .find('[datagrid-row-index=' + rowIndex + ']')
                    .removeClass('pha-datagrid-check-delete');
            },
            onCheckAll: function () {
                $(target).parent().find('[datagrid-row-index]').addClass('pha-datagrid-check-delete');
            },
            onUncheckAll: function () {
                $(target).parent().find('[datagrid-row-index]').removeClass('pha-datagrid-check-delete');
            }
        };
        checkEvents[method](rowIndex);
    },
    ControlOperation: function (handleObj) {
        var $dataphabtn = $('[data-pha-btn]');
        $dataphabtn.linkbutton('enable');
        $dataphabtn.show();
        for (var target in handleObj) {
            targetObj = handleObj[target];
            // $('#btnSave').linkbutton.methods['disable'] // 不需要那么那么智能, 无非就隐藏和不可用
            if (targetObj.disabled === true) {
                // var bindTimer = $.data($(target)[0], 'timer') || '';
                // if (bindTimer !== ''){
                //     clearTimeout(bindTimer);
                //     $.data($(target)[0], 'timer', '')
                // }
                $(target).linkbutton('disable');
            }
            if (targetObj.hide === true) {
                $(target).hide();
            }
        }
    },
    /**
     * 为json对象追加登录session信息, 如果有main则追加到main中
     * @param {*} jsonObj
     * @returns
     */
    AppendLogonData: function (jsonObj) {
        var logonData = {
            logonUser: session['LOGON.USERID'],
            logonLoc: session['LOGON.CTLOCID'],
            logonHosp: session['LOGON.HOSPID'],
            logonGroup: session['LOGON.GROUPID']
        };
        if (jsonObj.main) {
            $.extend(jsonObj.main, logonData);
        } else {
            $.extend(jsonObj, logonData);
        }
        return jsonObj;
    },
    GetSelectedRow: function (target, field) {
        target = PHA_COM.Fmt2IdTarget(target);
        field = field || '';
        var sel = $(target).datagrid('getSelected');
        if (field !== '') {
            return sel !== null ? sel[field] || '' : '';
        }
        return sel;
    },
    GetSelectedRowIndex: function (target) {
        target = PHA_COM.Fmt2IdTarget(target);
        return $(target).datagrid('getRows').indexOf(this.GetSelectedRow(target));
    },
    ValidateGridData: function (data) {
        if (data.success === 0) {
            PHA.Alert('提示', data.msg, 'error');
            return false;
        }
        return true;
    },
    LoadData: function (domID, qJson, callback) {
        domID = domID.replace('#', '');
        var $target = $('#' + domID);
        $target.datagrid('loading');
        PHA.CM(
            $.extend(
                {
                    pPlug: 'datagrid',
                    rows: 9999999,
                    page: 1,
                    sort: $target.datagrid('options').sortName,
                    order: $target.datagrid('options').sortOrder
                },
                qJson
            ),
            function (retData) {
                if (retData.success === 0) {
                    PHA.Alert('', retData.msg, 'error');
                }
                $target.datagrid('loaded');
                $target.datagrid('getData').inputRows = retData.rows;
                if ($target.datagrid('options').view.type === 'scrollview') {
                    retData.footer = PHA_COM.SumGridFooterData(domID);
                }

                $target.datagrid('loadData', retData);
                if (callback) {
                    callback(retData);
                }
            },
            function (failData) {
                $target.datagrid('loaded');
                if (callback) {
                    callback(retData);
                }
            }
        );
    },
    Condition: function (target, type, options) {
        switch (type) {
            case 'set':
                break;
            case 'get':
                var typeOpts = {
                    doType: 'query',
                    retType: 'Json'
                };
                return PHA.DomData(target, $.extend(typeOpts, options || {}))[0];
            case 'clear':
                PHA.DomData(target, {
                    doType: 'clear'
                });
                return;
            default:
                break;
        }
    },
    // 对应lodop+xml打印的标准样式, 体现为边框, 分页位置
    PrintStyle: {
        listColAlign: {
            qty: 'right',
            rp: 'right',
            sp: 'right',
            rpAmt: 'right',
            spAmt: 'right',
            invAmt: 'right'
        },
        listBorder: {
            headBorder: true,
            style: 4,
            startX: 2,
            endX: 210,
            space: 0
        },
        page: {
            x: 180,
            y: 5,
            fontname: '宋体',
            fontbold: 'false',
            fontsize: '11',
            format: '第{1}页/共{2}页'
        },
        FixListFields: function (aptFields, prepend) {
            prepend = prepend || 'lab_';
            newFields = [];
            aptFields.forEach(function (field) {
                newFields.push(field);
                newFields.push(prepend + field); // 增加前缀
            });
            // 可以直接增加一些常规签名的变量
            return newFields;
        }
    },
    SelectAfterDeleteRow: function (target) {
        var curIndex = this.GetSelectedRowIndex(target);
        $(target).datagrid('deleteRow', curIndex);
        var rowsLen = $(target).datagrid('getRows').length - 1;
        var selIndex = curIndex > rowsLen ? rowsLen : curIndex;
        if (selIndex >= 0) {
            $(target).datagrid('selectRow', selIndex);
        }
        return selIndex;
    },
    /**
     * 根据点击事件获取所处的窗口ID, 对应最外层的div指名如下class, 便于识别
     */
    GetWindowId4Event: function () {
        return $(window.event.target).closest('.js-pha-com-window-sign').attr('id') || '';
    },
    /**
     * 根据参数重新对列排序, 不可编辑等, 因模块内的表格列使用的是一个, 因此需要此功能
     * 注意field是存在于columns中实际的列
     * @param {object} columnsObj               表格列的列的原始值
     * @param {array}  columnsObj.columns       表格列的列的原始值
     * @param {array}  columnsObj.frozenColumns 表格列的列的原始值
     * @param {object} options
     * @param {array}  options.frozenFields     需要显示的列, 优先按此排序, 不在范围内的追加到最后
     * @param {array}  options.fields           需要显示的列, 优先按此排序, 不在范围内的追加到最后
     * @param {array}  options.banFields        置为不可编辑
     * @param {array}  options.editFields       仅可编辑
     * @param {array}  options.hiddenFields     不显示
     */
    RebuildColumns: function (columnsObj, options) {
        var frozenColumns = columnsObj.frozenColumns || [[]];
        var frozenColumnsLen = frozenColumns[0].length;
        var columns = columnsObj.columns || [[]];
        // var allColumns = frozenColumns[0].concat(normalColumns[0])
        var allColumns = frozenColumns[0].concat(columns[0]);
        var frozenFields = options.frozenFields || [];
        var fields = options.fields || [];
        var banFields = options.banFields || [];
        var editFields = options.editFields || [];
        var hiddenFields = options.hiddenFields || [];
        var newColumns = [];
        var newFrozenColumns = [];
        var leftColumns = [];
        for (var i = 0, length = allColumns.length; i < length; i++) {
            var col = allColumns[i];
            var colField = col.field;
            if (banFields.indexOf(colField) >= 0) {
                delete col.editor;
            }
            if (editFields.length > 0 && editFields.indexOf(colField) < 0) {
                delete col.editor;
            }
            if (hiddenFields.indexOf(colField) >= 0) {
                col.hidden = true;
            }
            var frozenFieldIndex = frozenFields.indexOf(colField);
            var fieldIndex = fields.indexOf(colField);
            if (frozenFieldIndex >= 0) {
                newFrozenColumns[frozenFieldIndex] = col;
            } else if (fieldIndex >= 0) {
                newColumns[fieldIndex] = col;
            } else {
                leftColumns.push(col);
            }
        }
        // 没有重排过, 按输入的输出
        if (newColumns.length === 0 && newFrozenColumns.length === 0) {
            newFrozenColumns = leftColumns.splice(0, frozenColumnsLen);
            newColumns = leftColumns;
        } else {
            newColumns = newColumns.concat(leftColumns);
        }

        return {
            frozenColumns: [newFrozenColumns],
            columns: [newColumns]
        };
    },
    CACert: function (modelName, _callback) {
        var logonType = ''; // 登录类型，UKEY|PHONE|FACE|SOUND|"" 空时弹出配置签名方式
        var singleLogon = 0; // 是否弹出单登录方式: 0-弹出多页签签名，1-单种签名方式
        var forceOpen = 0; // 强制弹出签名窗口(默认0:没有登录过则弹出，登录过则不弹出;1:强制弹出签名窗口)
        if (modelName == '') modelName = PHA_COM.Val.CAModelCode;

        dhcsys_getcacert({
            modelCode: modelName /*签名模块中代码*/,
            callback: function (cartn) {
                // 签名窗口关闭后,会进入这里
                if (cartn.IsSucc) {
                    if (cartn.ContainerName == '') {
                        _callback(); // CA未开启
                    } else {
                        if ('object' == typeof cartn && cartn.ContainerName !== '') {
                            PHA_COM.Val.CAData = cartn;
                            _callback(); // 写后面的业务代码
                        }
                    }
                } else {
                    alert('签名失败！');
                    return false;
                }
            }
            //isHeaderMenuOpen:true, // 是否在头菜单打开签名窗口. 默认true
            //SignUserCode:"YF01",   // 期望签名人HIS工号，会校验证书用户与HIS工号. 默认空
            //signUserType:"",   // 默认空，表示签名用户与当前HIS用户一致。ALL时不验证用户与证书
            //notLoadCAJs:1,  // 登录成功后，不向头菜单加载CA
            //loc:deptDesc,   // 科室id或描述，默认当前登录科室
            //groupDesc:groupDesc,  // 安全组描述，默认当前登录安全组
            //caInSelfWindow:1  // 用户登录与切换科室功能，业务组不用
        });
    },
    SaveCACert: function (_opt) {
        if (PHA_COM.Val.CAData == '') {
            return;
        }
        if (PHA_COM.ParamProp(PHA_COM.Val.APPCOMNAME).CADataSaveFlag != 'Y') {
            return;
        }
        var signVal = _opt.signVal;
        var type = _opt.type;
        var modelName = _opt.modelName || '';
        if (modelName == '') modelName = PHA_COM.Val.CAModelCode;
        var hashData = PHA_COM.Val.CAData.ca_key.HashData(signVal);
        var signData = PHA_COM.Val.CAData.ca_key.SignedData(hashData, PHA_COM.Val.CAData.ContainerName);
        if (signData == '') {
            return;
        } else {
            var userCertCode = PHA_COM.Val.CAData.CAUserCertCode;
            var certNo = PHA_COM.Val.CAData.CACertNo;
            var pJson = {
                usrCertCode: userCertCode,
                contentHash: hashData,
                signData: signData,
                code: modelName,
                certNo: certNo,
                signVal: signVal,
                type: type
            };
        }
        var retData = PHA.CM(
            {
                pClassName: 'PHA.COM.CA.Biz',
                pMethodName: 'SaveCAData',
                pJson: JSON.stringify(pJson)
            },
            false
        );
    }
};

PHA_COM.ScrollGrid = {
    GetChecked: function (target) {
        var ret = [];
        $(target)
            .datagrid('getData')
            .firstRows.forEach(function (ele) {
                if (ele.check === 'Y') {
                    ret.push(ele);
                }
            });
        return ret;
    }
};

// 利用顶部top进行页面之间的传值
PHA_COM.TOP = {
    Prefix: 'PHA_COM',
    Set: function (key, value) {
        key = PHA_COM + '_' + this.Prefix;
        top[key] = value;
    },
    Get: function (key, clearFlag) {
        key = PHA_COM + '_' + this.Prefix;
        if (top[key]) {
            var ret = top[key] || ''; // 对象需要深拷贝
            if (clearFlag === true) {
                delete top[key];
            }
            return ret;
        }
        return '';
    }
};

PHA_COM.GridSelecting = function (target, rowIndex) {
    target = PHA_COM.Fmt2IdTarget(target);
    if ($(target).datagrid('options').selecting === undefined) {
        $(target).datagrid('options').selecting = {};
    }
    if ($(target).datagrid('options').selecting[rowIndex] === true) {
        return true;
    }
    $(target).datagrid('options').selecting[rowIndex] = true;
    setTimeout(function () {
        delete $(target).datagrid('options').selecting[rowIndex];
    }, 400);
    return false;
};

PHA_COM.OpenHelp = function (_options) {
    var winId = 'help_win';
    var winContentId = winId + '_' + 'content';
    if ($('#' + winId).length == 0) {
        $("<div id='" + winId + "'></div>").appendTo('body');
        $('#' + winId).dialog(
            $.extend(
                {
                    width: $(document.body).width() * 0.8,
                    height: $(document.body).height() - 40,
                    modal: true,
                    title: '帮助信息',
                    iconCls: 'icon-w-list',
                    content: "<iframe id='" + winContentId + "' src='' style='border-width:0px;'></iframe>",
                    closable: true,
                    onClose: function () {}
                },
                _options
            )
        );
        $('#' + winContentId).width(
            $('#' + winContentId)
                .parent()
                .width()
        );
        $('#' + winContentId).height(
            $('#' + winContentId)
                .parent()
                .height() - 4
        );
        $(document.getElementById(winContentId)).load(function () {
            $(this)
                .contents()
                .find('trans')
                .each(function () {
                    var txt = $(this).text();
                    if (typeof $g != 'undefined') {
                        $(this).text($g(txt));
                    }
                });
        });
    }
    _options.title = _options.title || $g('帮助信息');
    $('#' + winContentId).attr('src', _options.url);
    $('#' + winId).dialog('setTitle', _options.title);
    $('#' + winId).dialog('open');
};

/**
 * 对tab形式的菜单, 新增tab签, 如果已存在则刷新
 * 注意field是存在于columns中实际的列
 * @param {object} title       标题
 * @param {object} url         链接
 * @param {boolean} newWinFlag 是否在新窗口中打开
 * @example PHA_COM.GotoMenu({title: '采购计划制单',url: 'plan.csp?planID=1')
 */
PHA_COM.GotoMenu = function (options, newWinFlag) {
    if (options.url) {
        if (typeof websys_writeMWToken === 'function') {
            options.url = websys_writeMWToken(options.url);
        }
    }
    if (PHA_COM.IsTabsMenu() === true) {
        var title = options.title;
        var tab = parent.$('#TRAK_tabs').tabs('getTab', title);
        websys_addTab(options);
        // 如果已经有tab, 则刷新对应的链接
        if (tab) {
            tab.find('iframe').get(0).src = options.url;
        }
        return;
    }
    if (newWinFlag === true) {
        window.open(options.url);
        return;
    }
    window.location.href = options.url;
};

/**
 * 判断是否极简UI样式
 */
PHA_COM.IsLiteCss = (function () {
    return typeof HISUIStyleCode == 'string' && HISUIStyleCode == 'lite';
})();
