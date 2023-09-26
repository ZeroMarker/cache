/**
 * creator:		yunhaibao
 * createdate:	2017-12-06
 * description: �����ӡ����
 * modify:      2019-04-11,�޸�Ϊlodop��ӡ,vb��ӡ�ɼ�print.vb.js,yunhaibao
 */
var PIVASLODOP = '';
var PIVASPRINT = {
	CallBack:'',
    // ��ǰ��ӡ����Һ�����������
    WardPogNum: '',
    /**
     * @description : ��ǩ����,���ݴ�ӡ����,������ӡ����ǩ
     * @param {Object} _options
     *                  .pogsNo : ���� (PIVA_OrdGrpState.POGS_No)
     *                  .sortWay : ������Id^��ӡ��ʽId
     */
    LabelsJsonByPogsNo: function (_options) {
        var pogsNo = _options.pogsNo;
        var sortWay = _options.sortWay;
        if (pogsNo == undefined) {
            return '';
        }
        $.messager.progress({
            title: '׼  ��  ��  ��  ��...',
            text: '<b>{value}%</b>',
            interval: 100000
        });
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.PrintCom',
                MethodName: 'LabelsJsonByPogsNo',
                pogsNo: pogsNo,
                prtWayStr: sortWay
            },
            function (retJson) {
                PIVASPRINT.LabelsJson = retJson;
                var retLen = retJson.length;
                if (retLen > 0) {
                    PIVASLABEL.Print(retJson, '');
                } else {
                    $.messager.progress('close');
                }
            }
        );
    },
    /**
     * @description : ������ѡ��Һ������ӡ
     * @param {Object} _options
     *                  .pogsNo : ���� (PIVA_OrdGrpState.POGS_No)
     *                  .sortWay : ������Id^��ӡ��ʽId
     */
    LabelsJsonByPogStr: function (_options) {
        var pogStr = _options.pogStr || '';
        if (pogStr == undefined) {
            return '';
        }
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.PrintCom',
                MethodName: 'LabelsJsonByPogStr',
                pogStr: pogStr
            },
            function (retJson) {
                var retLen = retJson.length;
                if (retLen > 0) {
                    PIVASLABEL.Print(retJson, '��');
                } else {
                    $.messager.progress('close');
                }
            }
        );
    },
    // ���л���ǩ
    HeadTotalLabel: function (_options) {},
    // ��������ǩ
    HeadWardLabel: function (_options) {
        /// _options.headLabelStr
        try {
            var headLabelStr = _options.headLabelStr;
            if (headLabelStr == '') {
                return;
            }
            var headLabelArr = headLabelStr.split('|@|');
            var headMainStr = headLabelArr[0];
            var headDetailStr = headLabelArr[1];
            var headMainArr = headMainStr.split('^');
            var headDetailArr = headDetailStr.split('!!');
            var MyList = '';
            var MyPara = '';
            MyPara += 'title' + String.fromCharCode(2) + headMainArr[0];
            MyPara += '^printDateTime' + String.fromCharCode(2) + headMainArr[1];
            MyPara += '^printUser' + String.fromCharCode(2) + session['LOGON.USERNAME'];
            MyPara += '^wardDesc' + String.fromCharCode(2) + headMainArr[2];
            MyPara += '^count' + String.fromCharCode(2) + headMainArr[3];
            for (var headI = 0; headI < headDetailArr.length; headI++) {
                var detailStr = headDetailArr[headI];
                var detailArr = detailStr.split('^');
                var listIData = detailArr[0] + '^' + detailArr[1];
                if (MyList == '') MyList = listIData;
                else MyList = MyList + String.fromCharCode(2) + listIData;
            }
            DHCSTGetXMLConfig('PIVASHeadWardLabel');
            DHCSTPrintFun(MyPara, MyList);
            this.WardPogNum = headMainArr[3].split('��')[0];
        } catch (e) {}
    },
    /**
     * @description Ԥ��Ϊtpn��ǩ
     */
    TPNLabel: function (_options) {},
    /**
     * @description �޸�Ϊ��Ǭraq·��,ע��ͬʱ������Ǭ�ļ�
     * @param {Object} _options
     *                  .raqName : ��Ǭ�ļ���
     *                  .isPreview:�Ƿ�Ԥ��(1:��)
     *                  .isPath:   �Ƿ����ȡ·��(1:��)
     */
    RaqPrint: function (_options) {
        var raqName = _options.raqName;
        var raqParams = _options.raqParams;
        var isPreview = _options.isPreview;
        var isPath = _options.isPath;
        var raqSplit = isPreview == 1 ? '&' : ';';
        var fileName = '';
        var params = '';
        var paramsI = 0;
        for (var param in raqParams) {
            var iParam = raqParams[param];
            var iParamStr = param + '=' + iParam;
            if (paramsI == 0) {
                params = iParamStr;
            } else {
                params = params + raqSplit + iParamStr;
            }
            paramsI++;
        }
        var rqDTFormat = this.RQDTFormat();
        if (isPreview == 1) {
            fileName = raqName + '&RQDTFormat=' + rqDTFormat + '&' + params;
            if (isPath == 1) {
                return 'dhccpmrunqianreport.csp?reportName=' + fileName;
            } else {
                DHCCPM_RQPrint(fileName, window.screen.availWidth * 0.5, window.screen.availHeight);
            }
        } else {
            fileName = '{' + raqName + '(' + params + ';RQDTFormat=' + rqDTFormat + ')}';
            alert(fileName);
            DHCCPM_RQDirectPrint(fileName);
        }
    },
    // һЩ�����ӡ��Ĭ������,��ɨ��ʱ��ӡ���ӵ�,��������
    DefaultParams: {
        // ��ҩ��
        Arrange: function () {
            var paramsArr = new Array(29);
            paramsArr[8] = '1'; // ִ�м�¼״̬
            paramsArr[21] = 'N'; // ִ�м�¼״̬
            return paramsArr;
        },
        // �������ӵ�
        WardBat: function () {
            var paramsArr = new Array(28);
            paramsArr[8] = '1'; // ִ�м�¼״̬
            paramsArr[21] = 'N'; // ִ�м�¼״̬
            return paramsArr;
        }
    },
    // ϵͳ���ڸ�ʽ,��Ǭ��ӡ��
    RQDTFormat: function () {
        var dateFmt = 'yyyy-MM-dd';
        var fmtDate = $.fn.datebox.defaults.formatter(new Date());
        if (fmtDate.indexOf('/') >= 0) {
            dateFmt = 'dd/MM/yyyy';
        }
        return dateFmt + ' ' + 'HH:mm:ss';
    },
    /**
     * @description : ������ҺҩƷ���
     * @param {String} pogLabelData : ��Һ������Ϣ
     * @param {String} pageNo : ��ǰҳ
     * @param {String} pageNumbers : ��ҳ��
     * @param {String} rePrint : �����ʶ
     * lodop������� : top left width height
     */
    MakeLodopLabel: function (pogLabelData, pageNo, pageNumbers, rePrint) {
        var pogLabelArr = pogLabelData.split('|@|');
        var pogMainData = pogLabelArr[0];
        var pogDetailData = pogLabelArr[1];
        var pogMainArr = pogMainData.split('^');
        var pogDetailArr = pogDetailData.split('||');
        var pogDetailLen = pogDetailArr.length;
        // ֻҪ��ӡ����NewPageA
        var widthMM = '70mm';
        var heightMM = '70mm';
        var bottomTop = 47; // �ײ�ǩ�־ඥ������,mm
        // ÿҳ�̶�����ҩ
        var incCnt = 3;
        var pageLen = Math.ceil(pogDetailLen / incCnt);
        // ҳü����ÿҳ����д,����ʹ��SET_PRINT_STYLEA(0, "ItemType", 1),ÿ�ζ�������ص�,��˿ɸ���������ÿҳ�������
        for (var pageI = 0; pageI < pageLen; pageI++) {
            var pageICnt = incCnt;
            if (pageI + 1 == pageLen) {
                var rem = pogDetailLen % incCnt;
                if (rem != 0) {
                    pageICnt = rem;
                }
            }
            // ��ȡÿҳ����
            var st = pageI * incCnt;
            var ed = pageI * incCnt + pageICnt;
            var detailArr = pogDetailArr.slice(st, ed);
            PIVASLODOP.NewPageA();
            // top����
            var topMM = 0;
            // ҽԺ̧ͷ
            topMM += 1;
            PIVASLODOP.ADD_PRINT_TEXTA('hospName', topMM + 'mm', '1mm', widthMM, 15, pogMainArr[36] + '��Һǩ' + rePrint);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 2);
            // ��ǩPNo
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '59mm', '10mm', 15, pogMainArr[5]);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 3);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            // ����
            topMM += 3;
            PIVASLODOP.ADD_PRINT_TEXTA('wardDesc', topMM + 'mm', '1mm', '40mm', 15, pogMainArr[3]);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 12);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            // ����(���)-ҽ�����ȼ�
            var batNo = pogMainArr[6];
            var priDesc = pogMainArr[9];
            var packFlag = pogMainArr[23];
            if (packFlag != '') {
                batNo = batNo + '(' + packFlag + ')';
            }
            if (priDesc != '') {
                batNo = batNo + '-' + priDesc;
            }
            PIVASLODOP.ADD_PRINT_TEXTA('batNo', topMM + 'mm', '40mm', '30mm', 15, batNo);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 12);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 3);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            // ��ά��
            topMM += 4.5;
            var barCode = pogMainArr[31];
            // ��ά�벻����С��13mm
            PIVASLODOP.ADD_PRINT_BARCODE(topMM + 'mm', '1mm', '13mm', '13mm', 'QRCode', barCode);
            // ���� ���� ���� �Ա�
            var bedNo = pogMainArr[25];
            var patName = pogMainArr[26];
            var patAge = pogMainArr[28];
            var patSex = pogMainArr[29];
            PIVASLODOP.ADD_PRINT_TEXTA('patInfo', topMM + 'mm', '13mm', '40mm', 15, bedNo + ' ' + patName + ' ' + patAge + ' ' + patSex);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 10);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            // ��Һ���� ������
            var pivaCat = pogMainArr[30];
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '41mm', '28mm', 15, pivaCat);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 10);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 3);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            // �÷� Ƥ�� No.�ǼǺ�
            topMM += 4;
            var instrucDesc = pogMainArr[11];
            var skinTest = pogMainArr[41];
            var patNo = pogMainArr[27];
            PIVASLODOP.ADD_PRINT_TEXTA('instruc', topMM + 'mm', '13mm', '55mm', 15, instrucDesc + ' ' + skinTest + ' ' + patNo);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 10);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            // ��ά������ ����+����
            topMM += 4;
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '13mm', '50mm', 10, pogMainArr[4] + '    ' + barCode);
            // PIVASLODOP.SET_PRINT_STYLEA(0, "FontSize", 7);
            // ͣ �� �� ��ʶ - ���Զ�λ
            var specStat = pogMainArr[17];
            if (specStat != '') {
                PIVASLODOP.ADD_PRINT_TEXT('5mm', '38mm', 15, 15, specStat);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 25);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
                PIVASLODOP.ADD_PRINT_ELLIPSE('4mm', '37.5mm', '10mm', '10mm', 0, 3);
                // PIVASLODOP.SET_PRINT_STYLEA(0, "Bold", 1);
            }
            // ����
            topMM += 4;
            PIVASLODOP.ADD_PRINT_LINE(topMM + 'mm', '1mm', topMM + 'mm', '69mm', 0, 1);
            // ������
            topMM += 1;
            // ҩƷ+����+���
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '50mm', 15, 'ҩƷ        ����   ���');
            // ����
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '55mm', '20mm', 15, '���� ����');
            // ����
            topMM += 4;
            PIVASLODOP.ADD_PRINT_LINE(topMM + 'mm', '1mm', topMM + 'mm', '69mm', 0, 1);
            topMM += 1;
            // ҩƷ,ÿ��ҩƷռ����
            var detailLen = detailArr.length;
            for (var detailI = 0; detailI < detailLen; detailI++) {
                var iData = detailArr[detailI];
                var iDataArr = iData.split('^');
                if (detailI > 0) {
                    topMM += 8;
                }
                // ������������֧
                var dosageFlag = iDataArr[3]; // 0\1
                // ��ý����װ
                var qtyFlag = iDataArr[5]; // 0\1                // ҩƷ+����+���
                PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '53mm', '10mm', iDataArr[0] + iDataArr[7] + iDataArr[2]);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'LineSpacing', '-1mm'); // �ı��м��
                if (dosageFlag == 0) {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Underline', 1);
                }
                if (qtyFlag == 1) {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
                }
                // ����
                PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '55mm', '20mm', 15, iDataArr[1]);
                if (dosageFlag == 0) {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Underline', 1);
                }
                if (qtyFlag == 1) {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
                }
                // ����
                PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '65mm', '10mm', 15, iDataArr[4]);
                if (dosageFlag == 0) {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Underline', 1);
                }
                if (qtyFlag == 1) {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
                }
            }
            // �ײ���ʼ�߶�,���¼���߶�
            var topMM = bottomTop;
            // ����
            PIVASLODOP.ADD_PRINT_LINE(topMM + 'mm', '1mm', topMM + 'mm', '69mm', 0, 1);
            // ҽ����ҩ˵��(��ҩʱ�� ���� )
            topMM += 1;
            var doseDateTime = pogMainArr[12];
            var ivgSpeed = pogMainArr[35];
            var freq = pogMainArr[10];
            var ordInfo = '��ҩ:' + doseDateTime + ' ' + freq + ' ' + ivgSpeed;
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '69mm', 15, ordInfo);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            // ˵�� (��ҩ˵�� ��������)
            topMM += 4;
            var drugInfo = pogMainArr[33];
            var storeInfo = pogMainArr[34];
            var useInfo = '˵��:' + drugInfo + ' ' + storeInfo;
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '69mm', 15, useInfo);
            // ����
            topMM += 4;
            PIVASLODOP.ADD_PRINT_LINE(topMM + 'mm', '1mm', topMM + 'mm', '69mm', 0, 1);
            // ǩ��(�� ��ҩ �˶�)
            topMM += 1;
            var user30Name = pogMainArr[38];
            if (pogMainArr[37] != '') {
                user30Name = pogMainArr[37];
            }
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '23mm', 15, '��ǩ:' + session['LOGON.USERNAME']);
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '24mm', '23mm', 15, '��ҩ:' + user30Name);
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '47mm', '23mm', 15, '���:' + pogMainArr[19]);
            // ǩ��(��Һ ���� ҽ��)
            topMM += 4;
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '23mm', 15, '��Һ:');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '24mm', '23mm', 15, '����:');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '47mm', '23mm', 15, 'ҽ��:' + pogMainArr[22]);
            // ����
            topMM += 4;
            PIVASLODOP.ADD_PRINT_LINE(topMM + 'mm', '1mm', topMM + 'mm', '69mm', 0, 1);
            // ��ӡʱ��
            topMM += 1;
            var fmtDT = 'TIME:yyyy-mm-dd hh:mm:ss';
            if (dtformat) {
                if (dtformat.indexOf('DMY') >= 0) {
                    var fmtDT = 'TIME:dd/mm/yyyy hh:mm:ss';
                }
            }
            var nowTime = PIVASLODOP.FORMAT(fmtDT, 'now');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '35mm', 15, nowTime);
            // ҳ��
            var pageInfo = pageNo + '-' + (pageI + 1) + ' / ' + pageNumbers;
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '36mm', '30mm', 15, pageInfo);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 3);
        }
    },
    /**
     * @description ��html,�Կ�����ʽ��ӡ���������Ȳ���,�ݲ�����
     */
    MakeLodopLabelHtml: function (pogLabelData, pageNo, pageNumbers, rePrint) {},
    Lodop: {
        /**
         * @description lodop��ҩ��
         * �˴�Ԥ��Ϊ8.3��������Һ,סԺ��ʱ����,���ڴ˴���ɾ��
         *
         */
        Arrange: function (_qOpts, _pOpts) {
            _pOpts = _pOpts || {};
            PIVASLODOP = getLodop();
            var retJson = $.cm(
                {
                    ClassName: 'PHA.PIVAS.PRT.Arrange',
                    QueryName: 'Query',
                    POGSNo: _qOpts.pogsNo || '',
                    MDspIdStr: _qOpts.mDspIdStr || '',
                    POGIdStr: _qOpts.pogIdStr || '',
                    InputStr: _qOpts.inputStr || '',
                    page: 1,
                    rows: 9999
                },
                false
            );
            var rowsData = retJson.rows;
            var rowsLen = rowsData.length;
            if (rowsLen == 0) {
                return;
            }
            var pogsNo = _qOpts.pogsNo || '';
            var mainJson = $.cm(
                {
                    ClassName: 'PHA.PIVAS.PRT.Arrange',
                    MethodName: 'GetPrtTag',
                    POGSNo: _qOpts.pogsNo || '',
                    MDspIdStr: _qOpts.mDspIdStr || '',
                    POGIdStr: _qOpts.pogIdStr || ''
                },
                false
            );
            var HtmlZoom = this.Zoom;
            HtmlZoom.getHtmlFactor(); // ֻ��IE����������
            var title = mainJson.hospDesc + mainJson.locDesc + '��ҩ��';
            var rePrint = _pOpts.rePrint || '';
            if (rePrint != '') {
                title = title + ' ( �� ) ';
            }

            PIVASLODOP.PRINT_INIT('��Һ������ҩ��');
            PIVASLODOP.SET_PRINT_STYLE('FontName', 'Microsoft Yahei');
            PIVASLODOP.SET_PRINT_PAGESIZE(1, 0, 0, 'A4');
            PIVASLODOP.ADD_PRINT_TEXT('5mm', '0mm', '100%', '5mm', title);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontName', 'Microsoft Yahei');
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 14);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 2);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
            if (pogsNo != '') {
                // ��ά��
                PIVASLODOP.ADD_PRINT_BARCODE('5mm', '189mm', '20mm', '20mm', 'QRCode', pogsNo);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
                PIVASLODOP.ADD_PRINT_TEXT('20.5mm', '115mm', '90mm', '5mm', pogsNo);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 3);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
            }
            // ��ֵ�ðٷֱ�
            var html =
                '<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:' +
                HtmlZoom.val_pt('10.5') +
                ';font-family:Microsoft Yahei} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:' +
                HtmlZoom.val_pt('10.5') +
                ';text-align:left} tfoot,th,tr,td{font-weight:normal}</style><table>';
            html += "<thead style='font-weight:bold;'>";
            html += "<td style='width:" + HtmlZoom.val_mm('20mm') + "'>" + ' ��λ' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('60mm') + "'>" + ' ҩƷ����' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('20mm') + "'>" + ' ���' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('30mm') + "'>" + ' ����' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('15mm') + ";text-align:center'>" + '����' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('15mm') + "'>" + ' ��λ' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('40mm') + "'>" + ' ����������' + '</td></tr>';
            html += '</thead>';
            html += '<tbody>';
            for (var i = 0; i < rowsLen; i++) {
                var rowData = rowsData[i];
                html += '<tr>';
                html += '<td>' + rowData.stkBin + '</td>';
                html += '<td>' + rowData.inciDesc + '</td>';
                html += '<td>' + rowData.spec + '</td>';
                html += '<td>' + rowData.phManfDesc + '</td>';
                html += "<td style='text-align:center'>" + rowData.qty + '</td>';
                html += '<td>' + rowData.bUomDesc + '</td>';
                html += '<td>' + rowData.batNoQty + '</td>';
                html += '</tr>';
            }
            html += '</tbody><tfoot>';
            html += '<tr>';
            html += "<th colspan='2'>" + ' ��ӡʱ��:' + mainJson.printDateTime + '</th>';
            html += "<th colspan='2'>" + ' ��ӡ��:' + session['LOGON.USERNAME'] + '</th>';
            html += "<th colspan='2'>" + "<span tdata='pageNO'>��##ҳ</span> <span tdata='pageCount'>��##ҳ</span>" + '</th>';
            html += '</tr>';
            html += '<tr>';
            html += "<th colspan='7'  style='border:1px solid black'>" + ' ��ҩ��:��������������ҩʱ��:��������������ҩ�˶���:��������������ҩ�˶�ʱ��:������������' + '' + '</th>';
            html += '</tr>';
            html += '</tfoot></table>';
            // �ڲ���������,�˴�����
            PIVASLODOP.ADD_PRINT_TABLE('25mm', '5mm', '200mm', '250mm', html);
            // PIVASLODOP.PREVIEW();
            PIVASLODOP.PRINT();
        },
        /* ��������Ŵ��� */
        Zoom: {
            HtmlFactor: 1,
            //��ȡ��ǰҳ�������ֵ
            detectZoom: function () {
                var ratio = 0,
                    screen = window.screen,
                    ua = navigator.userAgent.toLowerCase();
                if (ua.indexOf('trident') >= 0) {
                    if (window.devicePixelRatio !== undefined) {
                        ratio = window.devicePixelRatio;
                    } else if (~ua.indexOf('trident')) {
                        if (screen.deviceXDPI && screen.logicalXDPI) {
                            ratio = screen.deviceXDPI / screen.logicalXDPI;
                        }
                    } else if (window.outerWidth !== undefined && window.innerWidth !== undefined) {
                        ratio = window.outerWidth / window.innerWidth;
                    }
                } else {
                    ratio = 1;
                }
                if (ratio) {
                    ratio = Math.round(ratio * 100);
                }
                return ratio;
            },
            // ��ȡת��ϵ��
            getHtmlFactor: function () {
                this.HtmlFactor = 1;
                var ratio = this.detectZoom();
                if (ratio > 100) {
                    var x = 1 - 100 / ratio; //ҳ�汻�Ŵ�,��������С�ı���
                    this.HtmlFactor = 1 - x;
                    return 1 - x;
                } else if (ratio < 100) {
                    var x = 100 / ratio - 1; //ҳ�汻��С,������Ŵ�ı���
                    this.HtmlFactor = 1 + x;
                    return 1 + x;
                } else {
                    this.HtmlFactor = 1;
                    return 1;
                }
            },
            // �ⲿ�������ű���
            printSize: function (val) {
                return this.HtmlFactor * val;
            },

            // ת��Ϊ����֮�����λ������3������
            val_mm: function (val) {
                var valStr = val.toString();
                val = val.replace('mm', '');
                return valStr.indexOf('%') > 0 ? valStr : val * this.HtmlFactor + 'mm';
            },
            val_px: function (val) {
                var valStr = val.toString();
                val = val.replace('px', '');
                return valStr.indexOf('%') > 0 ? valStr : val * this.HtmlFactor + 'px';
            },
            val_pt: function (val) {
                var valStr = val.toString();
                val = val.replace('pt', '');
                return valStr.indexOf('%') > 0 ? valStr : val * this.HtmlFactor + 'pt';
            }
        }
    },
    /**
     * xml��ҩ��
     * POGSNo = "", POGIdStr = "", Pid
     */
    Arrange: function (pogsNo, pogIdStr, pid) {
        $.messager.progress({
            title: '��  ҩ  ��  ��  ӡ  ��...',
            text: '<b>{value}%</b>',
            interval: 100000
        });
        var data = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Arrange',
                MethodName: 'GetPrtJson',
                POGSNo: pogsNo,
                POGIdStr: pogIdStr,
                Pid: pid
            },
            false
        );
        if (JSON.stringify(data) == '{}') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: 'û�пɹ���ӡ����',
                type: 'alert'
            });
            $.messager.progress('close');
            return;
        }
        data.Para.prtUser = session['LOGON.USERNAME'];
        PRINTCOM.XML({
            printBy: 'lodop', // inv or lodop, default is lodop
            XMLTemplate: 'PHAPIVASARRANGE',
            data: data,
            preview: false,
            //aptListFields: ["label6", "printUserName", "label8", "printDate"],
            listBorder: { style: 2, startX: 1, endX: 193 },
            page: {
                x: 170,
                y: 3,
                rows: 38,
                fontbold: 'true',
                fontsize: '12',
                format: 'ҳ��:{1}/{2}'
            }
        });
        setTimeout(function () {
            $.messager.progress('close');
        }, 1000);
    }
};
// ��ǩ��ӡ
var PIVASLABEL = {
    Print: function (dataJson, rePrint) {
        var labelIterator = PIVASLABEL.Iterator(dataJson);
        while (labelIterator.isFinished() !== true) {
            labelIterator.initPrint();
            labelIterator.makeLabel(rePrint);
            labelIterator.toPrint();
            labelIterator.next();
        }
        if (PIVASPRINT.CallBack != '') {
            PIVASPRINT.CallBack();
        }
    },
    Iterator: function (dataJson) {
        var dataLen = dataJson.length;
        var printNum = 10;
        var labelCnt = 0;
        var labelJson;
        var taskQue = [];
        var taskQueOrigLen = 0;
        PIVASLODOP = getLodop();

        $.messager.progress({
            title: '��  ��  ��  ӡ  ��  ��  ��...',
            text: '<b>{value}%</b>',
            interval: 1000000
        });

        var refreshProgress = function () {
            if (PIVASLODOP.CVERSION) {
                $('body>div.messager-window')
                    .find('div.messager-p-msg')
                    .text((taskQueOrigLen - taskQue.length) * 10 + ' / ' + dataLen);
                $.messager.progress('bar').progressbar('setValue', parseInt(((taskQueOrigLen - taskQue.length) / taskQueOrigLen) * 100));
                if (taskQue.length === 0) {
                    $.messager.progress('close');
                }
            } else {
                setTimeout(function () {
                    $('body>div.messager-window')
                        .find('div.messager-p-msg')
                        .text(labelCnt + 1 + ' / ' + dataLen);
                    $.messager.progress('bar').progressbar('setValue', parseInt(((labelCnt + 1) / dataLen) * 100));
                    if (labelCnt + 1 === dataLen) {
                        $.messager.progress('close');
                    }
                }, 50);
            }
        };
        // �Ƿ����
        var isFinished = function () {
            return labelCnt === dataLen;
        };
        // ȡ��ǰ��ǩ����
        var getCurLabel = function () {
            labelJson = dataJson[labelCnt];
            return labelJson;
        };

        // ��һ����ǩ
        var next = function () {
            labelCnt++;
        };

        // �Ƿ���Ҫ��ʼ��ӡ,�����������һ�����ӡ
        var needPrint = function () {
            var labelCntI = labelCnt + 1;
            if (labelCntI % printNum === 0 || labelCntI === dataLen) {
                return true;
            }
            return false;
        };
        // �������һ����ǩ���ǳ�ʼ��
        var initPrint = function () {
            var labelCntI = labelCnt + 1;
            if (labelCntI % printNum === 1) {
                PIVASLODOP.PRINT_INIT('PHA_PIVAS_LABEL');
            }
        };
        var makeLabel = function (rePrint) {
            getCurLabel();
            PIVASPRINT.MakeLodopLabel(labelJson.LabelData, labelCnt + 1, dataLen, rePrint);
        };
        var toPrint = function () {
            if (needPrint()) {
                PIVASLODOP.SET_PRINT_MODE('CUSTOM_TASK_NAME', '��Һ������Һ��ǩ' + labelCnt + 1);
                PIVASLODOP.SET_PRINT_MODE('CATCH_PRINT_STATUS', true);
                if (PIVASLODOP.CVERSION) {
                    PIVASLODOP.On_Return_Remain = true; // true - ÿ�λ�ȡ״̬�������on_return�ص�
                    PIVASLODOP.On_Return = function (TaskID, Value) {
                        if (Value != 0 && TaskID != 0) {
                            var taskIndex = taskQue.indexOf(TaskID);
                            if (taskIndex >= 0) {
                                taskQue.splice(taskIndex, 1);
                            }
                            refreshProgress();
                            PIVASLODOP.GET_VALUE('PRINT_STATUS_OK', Value);
                        }
                    };
                } else {
                    refreshProgress();
                }
                var task = PIVASLODOP.PRINT();
                taskQue.push(task);
                taskQueOrigLen++;
            }
        };

        return {
            isFinished: isFinished,
            needPrint: needPrint,
            next: next,
            getCurLabel: getCurLabel,
            isFinished: isFinished,
            toPrint: toPrint,
            makeLabel: makeLabel,
            initPrint: initPrint
        };
    }
};
