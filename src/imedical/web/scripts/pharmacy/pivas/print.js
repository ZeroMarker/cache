/**
 * creator:		yunhaibao
 * createdate:	2017-12-06
 * description: �����ӡ����
 * modify:      2019-04-11,�޸�Ϊlodop��ӡ,vb��ӡ�ɼ�print.vb.js,yunhaibao
 */
var PIVASLODOP = '';
var PIVASPRINT = {
    CallBack: '',
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
                pogsNoStr: pogsNo,
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
        var rePrintFlag = _options.rePrintFlag || '';
        rePrintFlag = rePrintFlag !== 'N' ? '��' : '';
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
                    PIVASLABEL.Print(retJson, rePrintFlag);
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
                if (typeof websys_writeMWToken !== 'undefined') {
                    return websys_writeMWToken('dhccpmrunqianreport.csp?reportName=' + fileName);
                }

                return 'dhccpmrunqianreport.csp?reportName=' + fileName;
            } else {
                DHCCPM_RQPrint(fileName, window.screen.availWidth * 0.5, window.screen.availHeight);
            }
        } else {
            fileName = '{' + raqName + '(' + params + ';RQDTFormat=' + rqDTFormat + ')}';
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
            paramsArr[8] = ''; // ִ�м�¼״̬
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
        PIVASLODOP.SET_PRINT_STYLE('FontName', '����');
        var rows = pogLabelData.rows;
        var pogDetailLen = rows.length;

        // ֻҪ��ӡ����NewPageA
        var widthMM = '70mm';
        var heightMM = '70mm';
        var lineLeft = 1;
        var lineRight = 69;
        var bottomTop = 53; // �ײ�ǩ�־ඥ������,mm
        // ÿҳ�̶�����ҩ
        var incCnt = 4;
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
            var detailData = rows.slice(st, ed);
            PIVASLODOP.NewPageA();
            // top����
            var topMM = 0;
            // ҽԺ̧ͷ
            topMM += 1;
            var title = pogLabelData.phaLocDesc + '��Һǩ';
            if (rePrint !== '') {
                title += '(��-' + pogLabelData.printTimes + ')';
            }
            // ҳ��
            var pageInfo = pageNo + '-' + (pageI + 1) + '/' + pageNumbers;
            title += '��' + pageInfo;

            PIVASLODOP.ADD_PRINT_TEXTA('hospName', topMM + 'mm', '1mm', '60mm', 1, title);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 8);
            // ��ǩPNo
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '60mm', '9mm', 15, pogLabelData.pNo);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 3);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 8);
            // ����
            topMM += 3;
            PIVASLODOP.ADD_PRINT_TEXTA('wardDesc', topMM + 'mm', '1mm', '45mm', 1, pogLabelData.wardDesc);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 11);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            // ����
            PIVASLODOP.ADD_PRINT_TEXTA('wardDesc', topMM + 4 + 'mm', '1mm', '20mm', 1, pogLabelData.bedNo);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 11);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            //            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 2);
            // ����
            PIVASLODOP.ADD_PRINT_TEXTA('wardDesc', topMM + 8 + 'mm', '1mm', '20mm', 1, pogLabelData.patName);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 11);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            //            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 2);
            // ���� - ���� - ���
            var batNo = pogLabelData.batNo;
            var priDesc = pogLabelData.priDesc;
            var packFlag = pogLabelData.packFlag;
            var pivaCat = pogLabelData.pivaCat;
            var batInfo = '';
            if (pivaCat !== '') {
                batInfo += pivaCat;
            }
            batInfo += ' ' + batNo;
            if (packFlag !== '') {
                batInfo += ' ' + packFlag;
            }

            PIVASLODOP.ADD_PRINT_TEXTA('batNo', topMM + 'mm', '40mm', '29mm', 15, batInfo);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 11);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 3);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);

            // ��ҩʱ�� �÷� Ƶ�� ҽ�����ȼ�
            topMM += 5;
            var ordInfo = '';
            ordInfo += ' ' + pogLabelData.doseDateTime;
            ordInfo += ' ' + pogLabelData.instrucDesc;
            ordInfo += ' ' + pogLabelData.freqDesc;
            ordInfo += ' ' + pogLabelData.priDesc;
            PIVASLODOP.ADD_PRINT_TEXTA('ordInfo', topMM + 'mm', '20mm', '100mm', 15, ordInfo); // ��ʾ���׾�д��
            // ���� �Ա� �ǼǺ�
            topMM += 4;
            var patInfo = '';
            patInfo += ' ' + pogLabelData.patAge;
            patInfo += ' ' + pogLabelData.patSex;
            patInfo += ' ' + pogLabelData.patNo;
            patInfo += ' ' + pogLabelData.orderSkin;
            PIVASLODOP.ADD_PRINT_TEXTA('patInfo', topMM + 'mm', '20mm', '100mm', 15, patInfo);
            // ͣ �� �� ��ʶ - ���Զ�λ
            var specType = pogLabelData.specType;
            if (specType !== '') {
                PIVASLODOP.ADD_PRINT_TEXT('3mm', '40mm', 15, 15, specType);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 24);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 0);
                PIVASLODOP.ADD_PRINT_ELLIPSE('4mm', '39mm', '10mm', '10mm', 0, 2);
            }
            // ������
            topMM += 4;
            PIVASLODOP.ADD_PRINT_LINE(topMM + 'mm', lineLeft + 'mm', topMM + 'mm', lineRight + 'mm', 0, 1);
            topMM += 1;
            PIVASLODOP.SET_PRINT_STYLE('FontSize', 8);
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '30mm', 1, 'ҩƷ');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '20mm', '20mm', 1, '���');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '35mm', '20mm', 1, '������ҵ');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '50mm', '10mm', 1, '����');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '63mm', '100mm', 1, '����');
            topMM += 4;
            PIVASLODOP.ADD_PRINT_LINE(topMM + 'mm', lineLeft + 'mm', topMM + 'mm', lineRight + 'mm', 0, 1);
            topMM += 1;
            PIVASLODOP.SET_PRINT_STYLE('FontSize', 9);
            // ҩƷ��ϸ ÿ��ҩƷռ����
            var detailLen = detailData.length;
            for (var detailI = 0; detailI < detailLen; detailI++) {
                var iData = detailData[detailI];
                if (detailI > 0) {
                    topMM += 7;
                }
                var compFlag = iData.compFlag; // ! ������֧
                var moreFlag = iData.moreFlag; // ! ����װ
                PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '50mm', 15, iData.inciDesc);
                // PIVASLODOP.SET_PRINT_STYLEA(0, 'LineSpacing', '-1mm'); // �ı��м��
                if (compFlag === 'Y') {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Underline', 1);
                }
                if (moreFlag === 'Y') {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
                }
                // ����
                PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '50mm', '15mm', 1, iData.dosage);
                if (compFlag === 'Y') {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Underline', 1);
                }
                if (moreFlag === 'Y') {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
                }
                // ����
                PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '63mm', '10mm', 15, iData.qty);
                // PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 3);
                if (moreFlag === 'Y') {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Underline', 1);
                }
                if (moreFlag === 'Y') {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
                }
                // ������ҵ���
                PIVASLODOP.ADD_PRINT_TEXT(topMM + 3.5 + 'mm', '15mm', '100mm', 15, iData.spec);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 7.5);
                PIVASLODOP.ADD_PRINT_TEXT(topMM + 3.5 + 'mm', '35mm', '30mm', 15, iData.manfDesc);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 7.5);
            }
            PIVASLODOP.SET_PRINT_STYLE('FontSize', 7);
            // �ײ���ʼ�߶�,���¼���߶�
            var topMM = bottomTop;
            // ����
            PIVASLODOP.ADD_PRINT_LINE(topMM + 'mm', lineLeft + 'mm', topMM + 'mm', lineRight + 'mm', 0, 1);
            // ��ע(ҽ����ע ҩʦ��ע��)
            topMM += 1;
            var ordInfoStr = pogLabelData.ordRemark;
            if (pogLabelData.phaLabelRemark !== '') {
                ordInfoStr = ordInfoStr === '' ? pogLabelData.phaLabelRemark : ordInfoStr + ';' + pogLabelData.phaLabelRemark;
            }
            var ordInfo = '��ע: ' + ordInfoStr;
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '50mm', 10, ordInfo);
            // ˵�� (��ҩ˵�� ����������)
            topMM += 3;
            var useInfo = '˵��: ' + pogLabelData.useInfo + ' ' + pogLabelData.storeInfo;
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '50mm', 10, useInfo);
            // ����
            topMM += 3;
            PIVASLODOP.ADD_PRINT_LINE(topMM + 'mm', lineLeft + 'mm', topMM + 'mm', lineRight - 18 + 'mm', 0, 1);
            // ǩ��(�� ��ҩ �˶�)
            topMM += 1;
            var user30Name = pogLabelData.ps30UserName !== '' ? pogLabelData.ps30UserName : pogLabelData.user30Name;
            // ǩ��(ҽ��\��\��ǩ), ������˳��
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '20mm', 1, 'ҽ��:' + pogLabelData.docName);
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '17mm', '20mm', 1, '��:' + pogLabelData.passUserName);
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '34mm', '20mm', 1, '��ǩ:' + session['LOGON.USERNAME']);
            // ǩ��(�˶�\����\����)
            topMM += 3;
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '20mm', 1, '�˶�:');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '17mm', '20mm', 1, '����:');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '34mm', '20mm', 1, '����:');
            // ��ӡʱ�� ���� ��ά��
            topMM += 2;
            var fmtDT = 'TIME:yyyy-mm-dd hh:mm:ss';
            if (dtformat) {
                if (dtformat.indexOf('DMY') >= 0) {
                    var fmtDT = 'TIME:dd/mm/yyyy hh:mm:ss';
                }
            }
            var nowTime = PIVASLODOP.FORMAT(fmtDT, 'now');
            // PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '35mm', 1, nowTime + ' ' + pogLabelData.prtNo);
            PIVASLODOP.ADD_PRINT_BARCODE(bottomTop + 1 + 'mm', '53mm', '20mm', '20mm', 'QRCode', pogLabelData.barCode);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'QRCodeVersion', 3);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'QRCodeErrorLevel', 'M');
            topMM += 1;
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '50mm', 10, pogLabelData.prtNo + '��' + pogLabelData.barCode.split('-').slice(0, 3).join('-'));
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
            PIVASLODOP.SET_PRINT_STYLE('FontName', '����');
            PIVASLODOP.SET_PRINT_PAGESIZE(1, 0, 0, 'A4');
            PIVASLODOP.ADD_PRINT_TEXT('5mm', '0mm', '100%', '5mm', title);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontName', '����');
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
                ';font-family:����} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:' +
                HtmlZoom.val_pt('10.5') +
                ';text-align:left} tfoot,th,tr,td{font-weight:normal}</style><table>';
            html += "<thead style='font-weight:bold;'>";
            html += "<td style='width:" + HtmlZoom.val_mm('20mm') + "'>" + ' ��λ' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('60mm') + "'>" + ' ҩƷ����' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('20mm') + "'>" + ' ���' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('30mm') + "'>" + ' ������ҵ' + '</td>';
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
        data.List.unshift({
            stkBin: '��λ��',
            inciDesc: 'ҩƷ',
            spec: '���',
            manfDesc: '������ҵ',
            qty: '����',
            uomDesc: '��λ'
        });
        PRINTCOM.XML({
            printBy: 'lodop', // inv or lodop, default is lodop
            XMLTemplate: 'PHAPIVASARRANGE',
            data: data,
            preview: false,
            //aptListFields: ["label6", "printUserName", "label8", "printDate"],
            listBorder: { style: 4, startX: 1, endX: 193 },
            page: {
                x: 170,
                y: 3,
                rows: 38,
                fontbold: 'true',
                fontsize: '12',
                format: 'ҳ��:{1}/{2}'
            }
        });
        if (typeof App_MenuCsp !== 'undefined') {
            if (pogsNo !== '') {
                PHA_LOG.Operate({
                    operate: 'P',
                    logInput: JSON.stringify({ pogsNo: pogsNo }),
                    // logInput: logParams,
                    type: 'User.PIVAOrdGrpState.Arrange',
                    pointer: pogsNo,
                    origData: '',
                    remarks: App_MenuName + ' - ��ҩ��'
                });
            } else {
                PHA_LOG.Operate({
                    operate: 'P',
                    logInput: JSON.stringify({ pogIdStr: pogIdStr.substr(0, 30) }),
                    // logInput: logParams,
                    type: 'page',
                    pointer: App_MenuCsp,
                    origData: '',
                    remarks: App_MenuName + ' - ��ҩ��'
                });
            }
        }
        setTimeout(function () {
            $.messager.progress('close');
        }, 1000);
    },
    WardBat: {
        /**
         * �������ӵ���ӡ, ʹ��csp����ģ��,ͨ��handlebars����,����Lodop
         * TIPS: Ĭ������ÿ��ѭ��ֻ��ӡһ�������ĵ���, �����Ҫ��ӡ�����Ҫ������ά������ɷ�ʽ
         * @param {object[]} pJson
         * @param {array}  pJson.pogsNoArr ����, ������
         * @param {string} pJson.loc ��Һ����ID
         * @param {string} pJson.rePrint �����־ Y
         * @param {string} pJson.printType ��ӡ�ĵ�������
         */
        Handler: function (pJson) {
            var prtData = tkMakeServerCall('web.DHCSTPIVAS.PrintWardBat', 'GetData', JSON.stringify(pJson));

            var prtArr = JSON.parse(prtData);
            for (var i = 0; i < prtArr.length; i++) {
                var prtJson = prtArr[i];
                this[pJson.printType](prtJson);
            }
        },
        Total: function (prtJson) {
            var template = PIVAS.GetFileContent('dhcpha.pivas.temp.wardbat.total.csp');

            var handler = Handlebars.compile(template);
            var printHtml = handler([prtJson]);
            var WBLODOP = getLodop();
            WBLODOP.ADD_PRINT_HTML('1mm', '1mm', '100%', '100%', printHtml);
            WBLODOP.ADD_PRINT_BARCODE('2mm', '2mm', '23mm', '23mm', 'QRCode', prtJson.pogsNo);
            WBLODOP.SET_PRINT_STYLEA(0, 'QRCodeVersion', 4);
            WBLODOP.SET_PRINT_STYLEA(0, 'QRCodeErrorLevel', 'Q');
            WBLODOP.SET_PRINT_PAGESIZE(3, '200mm', '10mm', '');
            // WBLODOP.PREVIEW();
            WBLODOP.PRINT();
            if (typeof App_MenuName !== 'undefined') {
                PHA_LOG.Operate({
                    operate: 'P',
                    logInput: JSON.stringify({ pogsNo: prtJson.pogsNo }),
                    // logInput: logParams,
                    type: 'User.PIVAOrdGrpState.WardBatTotal',
                    pointer: prtJson.pogsNo,
                    origData: '',
                    remarks: App_MenuName + ' - ���ӵ� - �������κϼ�'
                });
            }
        },
        Inci: function (prtJson) {
            var template = PIVAS.GetFileContent('dhcpha.pivas.temp.wardbat.inci.csp');
            var handler = Handlebars.compile(template);
            var printHtml = handler([prtJson]);
            var WBLODOP = getLodop();
            WBLODOP.ADD_PRINT_HTML('1mm', '1mm', '100%', '100%', printHtml);
            WBLODOP.ADD_PRINT_BARCODE('2mm', '2mm', '23mm', '23mm', 'QRCode', prtJson.pogsNo);
            WBLODOP.SET_PRINT_STYLEA(0, 'QRCodeVersion', 4);
            WBLODOP.SET_PRINT_STYLEA(0, 'QRCodeErrorLevel', 'Q');
            WBLODOP.SET_PRINT_PAGESIZE(3, '200mm', '10mm', '');
            // WBLODOP.PREVIEW();
            WBLODOP.PRINT();
            if (typeof App_MenuName !== 'undefined') {
                PHA_LOG.Operate({
                    operate: 'P',
                    logInput: JSON.stringify({ pogsNo: prtJson.pogsNo }),
                    // logInput: logParams,
                    type: 'User.PIVAOrdGrpState.WardBatTotal',
                    pointer: prtJson.pogsNo,
                    origData: '',
                    remarks: App_MenuName + ' - ���ӵ� - ҩƷ��������'
                });
            }
        }
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
                    if (labelCnt + 1 >= dataLen) {
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
            PIVASPRINT.MakeLodopLabel(labelJson, labelCnt + 1, dataLen, rePrint);
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
