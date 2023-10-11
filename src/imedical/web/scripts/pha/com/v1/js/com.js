/**
 * ����:   ҩ������
 * ��д��:  yunhaibao
 * ��д����: 2019-03-12
 * scripts/pha/com/v1/js/com.js
 */
var PHA_COM = {
    /**
     * ��Ӧÿ����Ʒ�˵���cspȫ��,ע���Сд
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
     * �ǼǺŲ���, ����Ҫ�Ǳ�Ҫ����, ��֪�ǼǺŲ�¼��, ������¼�����ݱ���, yunhaibao
     * @param {String} _patNo
     */
    FullPatNo: function (_patNo) {
        if (_patNo === '') {
            return '';
        }
        if (_patNo <= 0) {
            PHA.Popover({
                msg: '��������ȷ�ĵǼǺ�',
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
                msg: '��������ȷ�ĵǼǺ�',
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
                Chinese: '<font color="#21ba45">' + $g('��') + '</font>'
            },
            No: {
                Icon: '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/close.png"></img>',
                Chinese: '<font color="#f16e57">' + $g('��') + '</font>'
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
     * ����grid���ݵ�excel
     * @param {String} _id ���Id
     */
    ExportGrid: function (_id, _fileName) {
        _fileName = _fileName || '���ݵ���_' + new Date().getTime() + '.xlsx'; // ��������
        var $grid = $('#' + _id);
        var newCols;
        // var cols = $grid.datagrid('options').columns[0];
        // var frozenCols = $grid.datagrid('options').frozenColumns[0];
        // ����̧ͷ ȡ���һ�����ݱ�ͷ
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
        // ȡ����,url��һ����$URL
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
        // ������־
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
            // ��������ʧ
            $.ajax({
                type: 'GET',
                url: url,
                async: true,
                data: queryParams,
                dataType: 'json',
                success: function (data) {
                    PHA.Loading('Hide');
                    // ��������data
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
        /* �������ά���飬�����кϲ�����ֳɵ�����Ԫ�� */
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
                        /* ��ȡ��ǰy�е�һ����Ԫ�ص�λ�� */
                        var lastX = PHA_COM.GetLastX4Arr(arr[m + j]); // ����������ж���ֱ��ȡarr�����һ����Ԫ�ص�λ�ü���
                        if (rowspan > 1) {
                            // ����������е�Ԫ�أ���ֱ��ȡ�������λ������չ
                            var sameX = PHA_COM.GetFristX4Arr(arr[m], colObj, 'title');
                            if (sameX != '') lastX = sameX + h;
                        }
                        if (lastX === '') break;
                        if (!(arr[m + j][lastX] instanceof Object)) {
                            arr[m + j][lastX] = copy = JSON.parse(JSON.stringify(cols[m][n])); //����ʹ����ƣ���Ȼ�޸ĸ�cols��ֵ��
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
     * ֱ�Ӵ�ӡGrid����
     * @param {String} _id ���Id
     * @param {Object} _printFn �Զ����ӡ����
     */
    PrintGrid: function (_id, _printFn) {
        if (typeof PHA_LODOP == 'undefined') {
            PHA_COM._Alert('����csp����<label style="color:red;">&lt;PHAPRINTCOM &frasl;&gt;</label>��ǩ!', 'error');
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
                    // ����
                    type: 'table',
                    FromTop: 30,
                    FromLeft: 5,
                    DivWidth: '98%',
                    DivHeight: '94%',
                    // ���
                    width: 195,
                    fitColumns: true,
                    borderStyle: 4,
                    padding: 2,
                    fontSize: 12,
                    rowHeight: 10,
                    // ����Ϣ
                    data: gData,
                    columns: gColumns
                })
                .Print();
        }
        printOut();
    },
    // ���ݷ�hisui��ʾ��
    _Alert: function (msgContent, msgType) {
        if ($.messager) {
            msgType = msgType || 'error';
            $.messager.alert('��ܰ��ʾ', msgContent, msgType);
            return;
        }
        alert(msgContent);
    },
    /**
     * @param {json} _data json��ʽ����
     * @param {Array} _cmArr �ɵ�����col����
     * @param {String} _fileName ��ѡ����
     */
    ExportData: function (_data, _cmArr, _fileName) {
        var dataArr = [];
        // ������
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
                            // ��<das></dsa>�����ʽȡԭʼֵ
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
     * @description ��ȡexcel����
     * ʹ��ʱ�赥������
     * <script type="text/javascript" src="../scripts/pha/plugins/xlsx/xlsx.full.min.js"></script>
     */
    ReadExcel: function (file, callBack) {
        // �ȹ̶���ôд
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
            // result ��Ϊ��������
            // ���ݸ�ʽ,LocDesc��Ϊ���б���,����Ӧ���Լ�����
            // [{LocDesc: 1, InciCode: 2, InciDesc: 3, PHCDFSCDIDr: 4, PHCDFMenstruumFlag: 5}]
        };
        reader.readAsBinaryString(file);
    },
    GenHospCombo: function (_options) {
        var tableName = _options.tableName || '';
        if (tableName === '') {
            PHA_COM._Alert('�������,δ����Ȩ���������', 'error');
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
                    '           <label id="_HospListLabel" style="color:red;">ҽԺ</label>' +
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
     * ���ݵ���Ϊ�ļ�(���Ե����ĸ�ʽ: xls/xlsx/txt/jpg/gif)
     * @creator Huxt 2020-07-28
     * @param {Object} title    - ��ѡ����,��Ҫ����������:1.ָ����Ҫ����������Ϣ;2.ָ���б�������. ����: {name:'����', age:'����'}
     * @param {Array}  data        - ��������,Ϊjson��ʽ. ����: [{name:'����', age:25}, {name:'����', age:30}, ...]
     * @param {string} fileName - �ļ�����. ����: xxx.xlsx
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
            PHA_COM._Alert('��֧�ֵ������ļ�����:' + suffix);
        }
    },
    /**
     * �����ļ�/��ȡ�ļ������� (���Ե����ĸ�ʽ: xls/xlsx/txt/jpg/gif)
     * @creator Huxt 2020-07-28
     * @param {Object}  _options.charset: ��ȡ���ļ�����, ����: utf-8 / gb2312
     *                  _options.suffixReg: �ļ���ʽ��֤������ʽ, ����: /^(.xls)|(.xlsx)$/
     * @param {Function}  data: �ص�����
     * @return null
     * others: PHA_COM.ImportFile()
     */
    ImportFile: function (_options, _callFn) {
        // ���崴���ļ��򷽷�
        var createFileBox = function (_thisCall) {
            var inputFileBox = document.createElement('input');
            inputFileBox.type = 'file';
            inputFileBox.onchange = function () {
                var files = this.files || [];
                if (files.length == 0) {
                    PHA_COM._Alert('δѡ���ļ�!');
                    return;
                }
                var file = files[0];
                var fileName = file.name;
                var reversedArr = fileName.split('.');
                var reversedLen = reversedArr.length;
                var fileSuffix = '.' + reversedArr[reversedLen - 1]; // �ļ���׺

                var defaultReg = /^(.xml)|(.txt)|(.xls)|(.xlsx)|(.jpg)|(.gif)$/;
                var suffixReg = _options.suffixReg || defaultReg;
                if (suffixReg == '') {
                    suffixReg = defaultReg;
                }
                var suffixRegStr = suffixReg.toString().replace('/^', '').replace('$/', '');

                if (suffixReg.test(fileSuffix) == false) {
                    PHA_COM._Alert('�ļ���ʽ����, ��ѡ���׺Ϊ: ' + suffixRegStr + ' ���ļ�!');
                    return;
                }
                _thisCall && _thisCall(file);
            };
            document.body.appendChild(inputFileBox);
            inputFileBox.click();
        };
        // �����ȡ�ļ�����ڷ���
        var readFile = function (file) {
            if (!file) {
                PHA_COM._Alert('δѡ���ļ�!');
                return;
            }
            var fileName = file.name || '';
            if (fileName == '') {
                PHA_COM._Alert('δѡ���ļ�!');
                return;
            }
            var reversedArr = fileName.split('.');
            var reversedLen = reversedArr.length;
            var fileSuffix = '.' + reversedArr[reversedLen - 1]; // �ļ���׺
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
        // �����ȡ txt & xml & img �ķ���
        var readAsData = function (file, _thisCall) {
            if (!FileReader) {
                PHA_COM._Alert('�������֧��FileReader,��ʹ��Chrome');
                return;
            }
            var _mCharset = _options.charset || 'gb2312' || 'utf-8';
            var reader = new FileReader();
            if (/text+/.test(file.type)) {
                reader.onload = function () {
                    _thisCall && _thisCall(this.result);
                };
                reader.readAsText(file, _mCharset); /*��ȡ�ı��ļ�*/
            } else if (/image+/.test(file.type)) {
                reader.onload = function () {
                    _thisCall && _thisCall(this.result);
                };
                reader.readAsDataURL(file); /*��ȡͼƬ�ļ�*/
            } else {
                PHA_COM._Alert('���ܶ�ȡtxt & xml & img�ļ�');
            }
        };
        // ���ز�ִ��
        PHA_UTIL.LoadJS(['../scripts/pha/plugins/xlsx/xlsx.full.min.js'], function () {
            createFileBox(readFile);
        });
    },
    /**
     * ������������ (����Ҫ������,iMedical8.4+����)
     * Huxt 2020-08-24
     * @param {object}  _options
     *                  _options.CardNoId: CSP��INPUT��ǩ��id
     *                  _options.PatNoId: CSP��INPUT��ǩ��id
     * @param {string}  _fn: �ص�����
     * @return
     * @others: ʹ�ø÷���ע����Ҫ��csp������:
     *  <server>d ##class(PHA.COM.ReadCard).LoadPlugin()</server>
     *  <ADDINS require="RWCard,PublicReadPerson"/>
     *  PHA_COM.ReadCard({CardNoId:'', PatNoId:''}, function(){ // dosomething});
     */
    ReadCard: function (_options, _fn) {
        // ����ID����ȫ�ֱ���
        var cardNoId = _options.CardNoId;
        var patNoId = _options.PatNoId;
        var cardTypeId = _options.CardTypeId;
        PHA_COM.ReadCardTemp = PHA_COM.ReadCardTemp ? PHA_COM.ReadCardTemp : {};
        PHA_COM.ReadCardTemp.cardNoId = cardNoId;
        PHA_COM.ReadCardTemp.patNoId = patNoId;
        PHA_COM.ReadCardTemp.cardTypeId = cardTypeId;
        PHA_COM.ReadCardTemp.fn = _fn;
        // ���ö���
        var patCarNo = $('#' + cardNoId).val();
        if (patCarNo != '') {
            DHCACC_GetAccInfo('', patCarNo, '', 'PatInfo', 'PHA_COM.CardTypeCallBack');
        } else {
            DHCACC_GetAccInfo7('PHA_COM.CardTypeCallBack');
        }
    },
    // �����ص�����
    CardTypeCallBack: function (readRet) {
        var cardNoId = PHA_COM.ReadCardTemp.cardNoId;
        var patNoId = PHA_COM.ReadCardTemp.patNoId;
        var cardTypeId = PHA_COM.ReadCardTemp.cardTypeId;
        var _fn = PHA_COM.ReadCardTemp.fn;
        if (readRet == false) {
            $.messager.popover({
                msg: '����Ч��',
                type: 'error',
                timeout: 1000
            });
            return;
        }
        var readRetArr = readRet.split('^');
        var readRtn = readRetArr[0];
        switch (readRtn) {
            case '0':
                // ����Ч
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
                    msg: '������������������뿨�ź����ԣ�',
                    type: 'error',
                    timeout: 1000
                });
                break;
            case '-200':
                $.messager.popover({
                    msg: '����Ч��',
                    type: 'error',
                    timeout: 1000
                });
                break;
            case '-201':
                //�ֽ�
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
     * ����Panel��С
     * @param {object}  _options
     *                  _options.layoutId: layout div ��id
     *                  _options.region: north / south & east / west
     *                  _options.height: �� region Ϊ north / south �ĸ߶ȱ���
     *                  _options.width: �� region Ϊ east / west �Ŀ�ȱ���
     * @params {boolean} autoResize true|false �Ƿ�ͬʱ��window.resize, ��ʹ���ڱ仯��С��̬��������
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
     * HIS�˵��Ƿ�Ϊҳǩ��ʽ
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
     * �����ֱ������,����ҽ����
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
            // ���ڴ����ص�����
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
                // ��������
                for (var mapKey in hideRuleMap) {
                    var tmpValue = rowData[mapKey];
                    if (hideRuleMap[mapKey].lastValue !== '' && hideRuleMap[mapKey].lastValue === tmpValue) {
                        hideRuleMap[mapKey].hideFields.forEach(function (value) {
                            rowData[value] = '';
                        });
                    }
                    hideRuleMap[mapKey].lastValue = tmpValue;
                }
                // ������б�ɫ
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
            // ����
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
     * ����pha-col�Ŀ��,ʵ��label�Զ�����
     * @param {object}  _options
     *                  _options.id: string, ӦΪpha-row��pha-col���ڵ����div��id, ����: <div id='xxx'><div class='pha-row'><div class='pha-col'></div></div></div>
     *                  _options.timeout: int, ��ʱִ��; Ĭ��Ϊ10
     *                  _options.forLable: boolean, �Ƿ�ֻ�԰���for���Ե�label���ÿ��; Ĭ��true
     *                  _options.maxWidth: int, �޶������; Ĭ��100
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
            return; // û������ TODO...
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
            msg += '    <span style="color:#757575;font-weight:bold">�ܼ�¼:' + msgJson.recordCnt + '</span>';
            msg += '    <span style="padding-left:10px;color:#00B69C;font-weight:bold">�ɹ�:' + msgJson.succCnt + '</span>';
            msg += '    <span style="padding-left:10px;color:#FFA804;font-weight:bold">ʧ��:' + msgJson.failCnt + '</span>';
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
        // ������Ҫresize, ��������пհ�
        $($(target).closest('.hisui-layout')).layout('resize');
    },
    Window: {
        Proportion: 0.85,
        /**
         * ����Ĭ�Ͽ��
         * @param() target domĿ��, Ĭ��Ϊbody
         * @return  ������ֵ
         * @example PHA_COM.Window.Width()
         */
        Width: function (target) {
            target = target || 'body';
            return $(target).width() * this.Proportion;
        },
        /**
         * ����Ĭ�ϸ߶�
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
     * ת��Ϊjqueryɸѡ����Ŀ����ʽ, һ�����ڴ���ID׷��#��
     * @param {*} target
     */
    Fmt2IdTarget: function (target) {
        if (target.indexOf('#') < 0) {
            target = '#' + target;
        }
        return target;
    },
    /**
     * ����ϼ�
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
     * ˢ�ºϼ�
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
        ret[showFields[0]] = $g('�ϼ�');
        ret[showFields[1]] = $g('��') + records + $g('����¼');
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
            // $('#btnSave').linkbutton.methods['disable'] // ����Ҫ��ô��ô����, �޷Ǿ����غͲ�����
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
     * Ϊjson����׷�ӵ�¼session��Ϣ, �����main��׷�ӵ�main��
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
            PHA.Alert('��ʾ', data.msg, 'error');
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
    // ��Ӧlodop+xml��ӡ�ı�׼��ʽ, ����Ϊ�߿�, ��ҳλ��
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
            fontname: '����',
            fontbold: 'false',
            fontsize: '11',
            format: '��{1}ҳ/��{2}ҳ'
        },
        FixListFields: function (aptFields, prepend) {
            prepend = prepend || 'lab_';
            newFields = [];
            aptFields.forEach(function (field) {
                newFields.push(field);
                newFields.push(prepend + field); // ����ǰ׺
            });
            // ����ֱ������һЩ����ǩ���ı���
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
     * ���ݵ���¼���ȡ�����Ĵ���ID, ��Ӧ������divָ������class, ����ʶ��
     */
    GetWindowId4Event: function () {
        return $(window.event.target).closest('.js-pha-com-window-sign').attr('id') || '';
    },
    /**
     * ���ݲ������¶�������, ���ɱ༭��, ��ģ���ڵı����ʹ�õ���һ��, �����Ҫ�˹���
     * ע��field�Ǵ�����columns��ʵ�ʵ���
     * @param {object} columnsObj               ����е��е�ԭʼֵ
     * @param {array}  columnsObj.columns       ����е��е�ԭʼֵ
     * @param {array}  columnsObj.frozenColumns ����е��е�ԭʼֵ
     * @param {object} options
     * @param {array}  options.frozenFields     ��Ҫ��ʾ����, ���Ȱ�������, ���ڷ�Χ�ڵ�׷�ӵ����
     * @param {array}  options.fields           ��Ҫ��ʾ����, ���Ȱ�������, ���ڷ�Χ�ڵ�׷�ӵ����
     * @param {array}  options.banFields        ��Ϊ���ɱ༭
     * @param {array}  options.editFields       ���ɱ༭
     * @param {array}  options.hiddenFields     ����ʾ
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
        // û�����Ź�, ����������
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
        var logonType = ''; // ��¼���ͣ�UKEY|PHONE|FACE|SOUND|"" ��ʱ��������ǩ����ʽ
        var singleLogon = 0; // �Ƿ񵯳�����¼��ʽ: 0-������ҳǩǩ����1-����ǩ����ʽ
        var forceOpen = 0; // ǿ�Ƶ���ǩ������(Ĭ��0:û�е�¼���򵯳�����¼���򲻵���;1:ǿ�Ƶ���ǩ������)
        if (modelName == '') modelName = PHA_COM.Val.CAModelCode;

        dhcsys_getcacert({
            modelCode: modelName /*ǩ��ģ���д���*/,
            callback: function (cartn) {
                // ǩ�����ڹرպ�,���������
                if (cartn.IsSucc) {
                    if (cartn.ContainerName == '') {
                        _callback(); // CAδ����
                    } else {
                        if ('object' == typeof cartn && cartn.ContainerName !== '') {
                            PHA_COM.Val.CAData = cartn;
                            _callback(); // д�����ҵ�����
                        }
                    }
                } else {
                    alert('ǩ��ʧ�ܣ�');
                    return false;
                }
            }
            //isHeaderMenuOpen:true, // �Ƿ���ͷ�˵���ǩ������. Ĭ��true
            //SignUserCode:"YF01",   // ����ǩ����HIS���ţ���У��֤���û���HIS����. Ĭ�Ͽ�
            //signUserType:"",   // Ĭ�Ͽգ���ʾǩ���û��뵱ǰHIS�û�һ�¡�ALLʱ����֤�û���֤��
            //notLoadCAJs:1,  // ��¼�ɹ��󣬲���ͷ�˵�����CA
            //loc:deptDesc,   // ����id��������Ĭ�ϵ�ǰ��¼����
            //groupDesc:groupDesc,  // ��ȫ��������Ĭ�ϵ�ǰ��¼��ȫ��
            //caInSelfWindow:1  // �û���¼���л����ҹ��ܣ�ҵ���鲻��
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

// ���ö���top����ҳ��֮��Ĵ�ֵ
PHA_COM.TOP = {
    Prefix: 'PHA_COM',
    Set: function (key, value) {
        key = PHA_COM + '_' + this.Prefix;
        top[key] = value;
    },
    Get: function (key, clearFlag) {
        key = PHA_COM + '_' + this.Prefix;
        if (top[key]) {
            var ret = top[key] || ''; // ������Ҫ���
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
                    title: '������Ϣ',
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
    _options.title = _options.title || $g('������Ϣ');
    $('#' + winContentId).attr('src', _options.url);
    $('#' + winId).dialog('setTitle', _options.title);
    $('#' + winId).dialog('open');
};

/**
 * ��tab��ʽ�Ĳ˵�, ����tabǩ, ����Ѵ�����ˢ��
 * ע��field�Ǵ�����columns��ʵ�ʵ���
 * @param {object} title       ����
 * @param {object} url         ����
 * @param {boolean} newWinFlag �Ƿ����´����д�
 * @example PHA_COM.GotoMenu({title: '�ɹ��ƻ��Ƶ�',url: 'plan.csp?planID=1')
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
        // ����Ѿ���tab, ��ˢ�¶�Ӧ������
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
 * �ж��Ƿ񼫼�UI��ʽ
 */
PHA_COM.IsLiteCss = (function () {
    return typeof HISUIStyleCode == 'string' && HISUIStyleCode == 'lite';
})();
