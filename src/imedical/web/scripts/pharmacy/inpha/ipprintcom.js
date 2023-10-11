/**
 * @creator: Huxt 2019-11-27
 * @desc:    סԺ��ҩ��ӡ���ʹ��lodop���
 * @js:      scripts/pharmacy/inpha/ipprintcom.js
 * @����:    2021-09-10 �޸�Ϊ�µĵ��÷�ʽ
 */
var IPPRINTCOM = {
    PrintBy: 'Single', // All or Single
    BrowsePreview: false, // ��ҳǩԤ��
    /*
     * @desc: סԺҩ����ӡͳһ���
     * @params: _options.phacStr - ����ID�ַ���, ��ʽ: phac1^phac2^phac3
     * @params: _options.otherStr - ��̨��������������ַ��� str1^str3^str3
     * @params: _options.printType - ��ӡ���Ϳ���, ȡֵ: ��-��Ĭ������, 1-��ϸ, 2-����, 3-����&��ϸ
     * @params: _options.reprintFlag - �����־, 1����Y��ʾ����
     * @params: _options.pid - ��ӡ��治��ʱ�Ŵ���
     * @params: _options.printResRet - ��ӡ�����ϸ, ���ڲ���
     * @params: _options.printOther - ��ӡ��������, ���ڲ���
     * @params: _options.banConfig - ���߷�ҩ������õ�Ĭ�Ϲ��� 1 ����
     */
    Print: function (_options) {
        // ��ҳǩԤ��
        if (this.BrowsePreview) {
            if (_options.notOpen != 'Y') {
                return this.OpenBrowser(_options);
            }
        }
        // ������ӡ
        _options.phacStr = _options.phacStr || '';
        _options.otherStr = _options.otherStr || '';
        _options.printType = _options.printType || '';
        _options.reprintFlag = _options.reprintFlag || 'N';
        _options.printResRet = _options.printResRet || '';
        _options.printOther = _options.printOther || '';
        _options.banConfig = _options.banConfig || '';
        if (_options.phacStr == '') {
            return;
        }
        var pid = _options.pid || '';
        // ��ӡ��ͨ����
        if (this.PrintBy == 'Single') {
            this.PrintBySingle(_options);
        } else {
            this.PrintAll(_options);
        }
        // ��ӡ��治��
        this.PrintNoStock(pid);
        this.PrintNoStockByPhac(_options.phacStr);
    },

    /*
     * @desc: ��ӡ����, �µĴ�ӡ���෽ʽ, ���phacһ���ӡ
     * @params: _options.phacStr - ����ID�ַ���, ��ʽ: phac1^phac2^phac3
     * @params: _options.otherStr - ��̨��������������ַ��� str1^str3^str3
     * @params: _options.printType - ��ӡ���Ϳ���, ȡֵ: 1-��ϸ, 2-����, 3-����&��ϸ
     * @params: _options.reprintFlag - �����־, 1����Y��ʾ����
     * @params: _options.isPreview - �Ƿ�Ԥ��, 1����Y��ʾԤ�� (Chrome�¶��Ԥ������������,������Ԥ��)
     * @others: ��ЩҽԺҪ��ĳһ�η�ҩ��phacҪһ���ӡ,������һ��phac��ӡһ��;
     *          ���phacһ���ӡ��Ĭ�ϵ������Ѿ�û������,ֱ���ò�������
     */
    PrintAll: function (_options) {
        if (_options.printType == 1) {
            this.PrintDispDetail(_options);
        } else if (_options.printType == 2) {
            this.PrintDispTotal(_options);
        } else if (_options.printType == 3) {
            this.PrintDispDetail(_options);
            this.PrintDispTotal(_options);
        } else {
            alert('��ѡ���ӡ��ϸ���߻���!');
        }
        this.PrintResRetDetail(_options);
    },

    /*
     * @desc: ��ӡ����, �˴������ϰ汾�ķ�ʽ����, һ��phac��ӡһ��
     * @params: _options.phacStr - ����ID�ַ���, ��ʽ: phac1^phac2^phac3
     * @params: _options.otherStr - ��̨��������������ַ��� str1^str3^str3
     * @params: _options.printType - ��ӡ���Ϳ���, ȡֵ: 1-��ϸ, 2-����, 3-����&��ϸ
     * @params: _options.reprintFlag - �����־, 1����Y��ʾ����
     * @params: _options.printResRet - ��ӡ�����ϸ, ���ڲ���
     * @params: _options.printOther - ��ӡ��������, ���ڲ���
     */
    PrintBySingle: function (_options) {
        var newOptions = this.deepCopy(_options);
        var phacArr = [];
        var phacStr = _options.phacStr;
        phacArr = phacStr.split('^');
        for (var printi = 0; printi < phacArr.length; printi++) {
            var phac = phacArr[printi];
            var phaType = this.GetDispType(phac);
            newOptions.phacStr = phac; //��ӡ����
            newOptions.phaType = phaType;
            this.ClassOfPrint(newOptions);
        }
    },

    /*
     * @ desc: ��ӡ����, �˴������ϰ汾�ķ�ʽ����
     * @ �������˵��:
     *  (1)���Ȱ��ս��湴ѡ�Ĵ�ӡ,���湴ѡ����ϸ�����ϸ,��ѡ�Ļ���������,����ѡ�򶼴�ӡ; ���Ʋ���ΪprintType, 1-��ϸ, 2-����, 3-����&��ϸ
     *  (2)��ҩʱ����û�й�ѡ��ϸ�ͻ���,�������õĴ�ӡ
     *  (3)���ⷢҩ���,�������ý������ô�ӡ������,����js����Ӹú�������
     * @others:
     */
    ClassOfPrint: function (prtOptions) {
        var phaType = prtOptions.phaType;
        var printType = prtOptions.printType;
        var reprintFlag = prtOptions.reprintFlag;
        var printResRetFlag = prtOptions.printResRet;
        var printOther = prtOptions.printOther;
        var banConfig = prtOptions.banConfig;
        // ״ֵ̬
        prtOptions.isPreview = 0;
        var conDetail = 0,
            conTotal = 0,
            conOther = 0,
            prtResRet = 0,
            prtNoStock = 0;
        if (printOther !== '') {
            conOther = printOther;
        }
        var flag = 0;
        if (printType === 3) {
            conDetail = 1;
            conTotal = 1;
            flag = 1;
        } else if (printType === 2) {
            conTotal = 1;
            flag = 1;
        } else if (printType === 1) {
            conDetail = 1;
            flag = 1;
        } else if (printType === -1) {
            flag = 1;
        }

        if (phaType === 'ZCY') {
            if (printType == 1 || printType == 3) {
                alert('��ҩ����Ҫ��ѡ��ӡ���ܻ��ӡ��ϸ!');
                return;
            }
        }
        var configObj = this.GetPrtTypeConfig(phaType);
        // ��ҩ��ӡ(��reprintFlag="")���߽���δѡ��(��flag=0)ʱ, ȡĬ�����õĴ�ӡ��ʽ
        if ((flag == 0 || reprintFlag == '') && banConfig === '') {
            var isPreview = parseFloat(configObj.isPreview);
            prtOptions.isPreview = configObj.isPreview || 0; // �Ƿ�Ԥ��
            if (flag == 0) {
                conDetail = parseFloat(configObj.printDetail); // ��ϸ
                conTotal = parseFloat(configObj.printTotal); // ����
                conOther = configObj.printOther || ''; // ����
                prtResRet = parseFloat(configObj.printResRet); // �����ҩ
                prtNoStock = parseFloat(configObj.printNoStock); // ��治��
                if (isNaN(conDetail) && isNaN(conTotal) && conOther == '') {
                    alert('ҩƷ���:' + phaType + '��ӡ��ʽδ����,���ʵ!');
                    return;
                }
                if (conDetail == 0 && conTotal == 0 && conOther == '') {
                    alert('ҩƷ���:' + phaType + '��ӡ��ʽδ����,���ʵ!');
                    return;
                }
            }
        }
        // ��ӡ����ϸ�ͻ���,��ӡ���� (��:�ڷ�ҩ��ǩ,�в�ҩ����)
        /* MaYuqiang 20220429 ��ӡ�����������ж��Ƿ�ά������ϸ������ */
        if (conOther != '') {
            var conOtherArr = [];
            if (conOther.indexOf(';') >= 0) {
                conOtherArr = conOther.split(';');
            } else {
                conOtherArr = conOther.split(',');
            }
            for (var otheri = 0; otheri < conOtherArr.length; otheri++) {
                var printother = conOtherArr[otheri];
                if (printother === '') {
                    continue;
                }
                printother = printother.indexOf('IPPRINTCOM.') >= 0 ? printother : 'IPPRINTCOM.' + printother;
                eval(printother)(prtOptions);
            }
        }

        // ��ӡ��ϸ�ͻ���,����ӡ����
        /* MaYuqiang 20220429 ��ʹά��������ӡ������Ҳ���ж���ϸ������ */
        // if (conOther == "") {
        // ��ӡ��ϸ�嵥
        if (conDetail == 1) {
            if (configObj.detailGroupByPat == 1) {
                this.PrintDispDetailGroupByPat(prtOptions);
            } else {
                this.PrintDispDetail(prtOptions);
            }
        }
        // ��ӡ���ܵ�
        if (conTotal == 1) {
            this.PrintDispTotal(prtOptions);
        }
        // �����ҩ��ϸ��ӡ
        if (prtResRet == 1 || printResRetFlag == 1) {
            this.PrintResRetDetail(prtOptions);
        }
        // }
    },

    /*
     * @desc: סԺ��ϸ��ӡ
     * @params: phacStr - סԺ��ҩ����ID�ַ���
     * @others:
     */
    PrintDispDetail: function (prtOptions) {
        this.jsRunServer(
            {
                ClassName: 'web.DHCINPHA.Disp.Print',
                MethodName: 'GetDetailJsonData',
                phacStr: prtOptions.phacStr,
                otherStr: prtOptions.otherStr
            },
            function (retJson) {
                if (retJson.length == 0) {
                    return;
                }
                IPPRINTCOM.PrintDispDetailLodop(null, retJson, prtOptions);
            },
            function (error) {
                console.dir(error);
                alert(error.responseText);
            }
        );
    },
    PrintDispDetailLodop: function (LODOP, jsonData, prtOptions) {
        PHA_LODOP.PREVIEW_IN_BROWSE = !this.BrowsePreview ? false : this.ToBool(prtOptions.isPreview);
        var title = this.GetPrintTitle('��ҩ��ϸ��', prtOptions.reprintFlag);
        var p = new PHA_LODOP.Init('��ҩ��ϸ��');
        p.Printer('');
        p.Page('Orient:1; Width:0; Height:0; PageName:A4');
        p.PageNo('Top:270mm; Left:90mm; Format:0');
        p.Text(title, 'Top:5mm; Left:5mm; Width:180mm; Height:20mm; FontName:����; FontSize:16; Alignment:2; Bold:1');
        p.Html({
            // ����
            type: 'html',
            FromTop: 50,
            FromLeft: 5,
            DivWidth: '98%',
            DivHeight: '98%',
            // ������
            data: jsonData,
            width: 195,
            borderStyle: 4,
            padding: 2,
            fontSize: 11,
            rowHeight: 25,
            columns: [
                {
                    name: '����',
                    index: 'bedNo',
                    width: '12',
                    maxTextLen: 20
                },
                {
                    name: '����',
                    index: 'patName',
                    width: '12',
                    maxTextLen: 10
                },
                {
                    name: 'ҩƷ����',
                    index: 'inciDesc',
                    width: '32'
                },
                {
                    name: '����',
                    index: 'doseQty',
                    width: '12'
                },
                {
                    name: 'Ƶ��',
                    index: 'freqDesc',
                    width: '11'
                },
                {
                    name: '�÷�',
                    index: 'instDesc',
                    width: '14'
                },
                {
                    name: 'ʱ��',
                    index: 'timeDosingStr',
                    width: '20'
                },
                {
                    name: '���',
                    index: 'spec',
                    width: '15'
                },
                {
                    name: '����',
                    index: 'qty',
                    width: '15'
                },
                {
                    name: '��λ',
                    index: 'uomDesc',
                    width: '11',
                    align: 'center'
                }
            ],
            // ������ - ͷ
            formatHeader: function (main) {
                return {
                    marginTop: 20,
                    fontSize: 12,
                    data: [
                        [
                            {
                                td: '������ң�' + main.wardDesc,
                                width: 30
                            },
                            {
                                td: '��ҩ���' + main.phaType,
                                width: 15
                            },
                            {
                                td: '*' + main.dispNo + '*',
                                width: 20,
                                font: 'C39HrP60DmTt',
                                size: 36
                            }
                        ],
                        [
                            {
                                td: '���ţ�' + main.dispNo
                            },
                            {
                                td: '��ҩʱ�䣺' + main.phaDate
                            },
                            {
                                td: '��ӡʱ�䣺' + main.sysDateTime
                            }
                        ]
                    ]
                };
            },
            // ������ - β
            formatFooter: function (main) {
                return {
                    fontSize: 12,
                    data: [
                        [
                            {
                                td: '�Ƶ���' + session['LOGON.USERNAME']
                            },
                            {
                                td: '��ҩ��' + main.phaUserName
                            },
                            {
                                td: '��ҩ��' + main.phaCollectUserName
                            },
                            {
                                td: '�˶ԣ�' + main.phaCollateUserName
                            },
                            {
                                td: '��ҩ��'
                            }
                        ],
                        [
                            {
                                td: '�ܽ�' + main.amtSum + 'Ԫ'
                            },
                            {
                                td: ''
                            }
                        ]
                    ]
                };
            }
        });
        if (this.ToBool(prtOptions.isPreview)) {
            p.Preview(true);
        } else {
            p.Print();
            this.LogPrint({}, jsonData, prtOptions, 'DispDetail', '��ӡ��ϸ');
        }
    },
    LogPrint: function (logOptions, jsonData, prtOptions, printWay, printWayDesc) {
        if (typeof App_MenuCsp === 'undefined') {
            return;
        }
        printWayDesc = printWayDesc || '';
        printWay = printWay || '';
        var phacIDStr = prtOptions.phacStr || '';
        if (phacIDStr !== '') {
            var phacIDArr = phacIDStr.split('^');
            for (var i = 0, length = phacIDArr.length; i < length; i++) {
                var phacID = phacIDArr[i];
                // ���б�Ҫ, ��ҩ����־����д����̨����
                var logInputParams = '';
                if (phacIDArr.length === 1) {
                    logInputParams = JSON.stringify(jsonData[0].main);
                }
                var pointerType = 'User.DHCPHACollected';
                if (printWay !== '') {
                    pointerType = pointerType + '.' + printWay;
                }
                PHA_LOG.Operate({
                    operate: 'P',
                    logInput: logInputParams,
                    type: pointerType,
                    pointer: phacID,
                    origData: JSON.stringify(prtOptions),
                    remarks: App_MenuName + ' - ' + printWayDesc
                });
            }
        }
    },

    /*
     * @desc: סԺ���ܴ�ӡ
     * @params: phacStr - סԺ��ҩ����ID�ַ���
     * @others:
     */
    PrintDispTotal: function (prtOptions) {
        this.jsRunServer(
            {
                ClassName: 'web.DHCINPHA.Disp.Print',
                MethodName: 'GetTotalJsonData',
                phacStr: prtOptions.phacStr,
                otherStr: prtOptions.otherStr
            },
            function (retJson) {
                if (retJson.length == 0) {
                    return;
                }
                IPPRINTCOM.PrintDispTotalLodop(null, retJson, prtOptions);
            },
            function (error) {
                console.dir(error);
                alert(error.responseText);
            }
        );
    },
    PrintDispTotalLodop: function (LODOP, jsonData, prtOptions) {
        PHA_LODOP.PREVIEW_IN_BROWSE = !this.BrowsePreview ? false : this.ToBool(prtOptions.isPreview);
        var title = this.GetPrintTitle('ҩƷ�����嵥', prtOptions.reprintFlag);
        var p = new PHA_LODOP.Init('ҩƷ�����嵥');
        p.Printer('');
        p.Page('Orient:1; Width:0; Height:0; PageName:A4');
        p.PageNo('Top:270mm; Left:90mm; Format:0');
        p.Text(title, 'Top:5mm; Left:5mm; Width:180mm; Height:20mm; FontName:����; FontSize:16; Alignment:2;Bold:1');
        p.Html({
            // ����
            type: 'html',
            FromTop: 50,
            FromLeft: 5,
            DivWidth: '98%',
            DivHeight: '98%',
            // ������
            data: jsonData,
            width: 195,
            borderStyle: 4,
            padding: 2,
            fontSize: 11,
            rowHeight: 25,
            columns: [
                {
                    name: '��λ',
                    index: 'stkBin',
                    width: '15'
                },
                {
                    name: 'ҩƷ����',
                    index: 'inciDesc',
                    width: '32',
                    maxTextLen: 20
                },
                {
                    name: '���',
                    index: 'spec',
                    width: '15',
                    maxTextLen: 10
                },
                {
                    name: '��ҩ��',
                    index: 'facQty',
                    width: '12'
                },
                {
                    name: 'ҽ����',
                    index: 'ordQty',
                    width: '12'
                },
                {
                    name: '�����',
                    index: 'resQty',
                    width: '12'
                },
                {
                    name: '�ܼ�(Ԫ)',
                    index: 'amt',
                    width: '12',
                    align: 'right'
                },
                {
                    name: '��λ����',
                    index: 'bedQty',
                    width: '30'
                }
            ],
            // ������ - ͷ
            formatHeader: function (main) {
                return {
                    marginTop: 20,
                    fontSize: 12,
                    data: [
                        [
                            {
                                td: '������ң�' + main.wardDesc,
                                width: 30
                            },
                            {
                                td: '��ҩ���' + main.phaType,
                                width: 15
                            },
                            {
                                td: '*' + main.dispNo + '*',
                                width: 20,
                                font: 'C39HrP60DmTt',
                                size: 36
                            }
                        ],
                        [
                            {
                                td: '���ţ�' + main.dispNo
                            },
                            {
                                td: '��ҩʱ�䣺' + main.phaDate
                            },
                            {
                                td: '��ӡʱ�䣺' + main.sysDateTime
                            }
                        ]
                    ]
                };
            },
            // ������ - β
            formatFooter: function (main) {
                return {
                    fontSize: 12,
                    data: [
                        [
                            {
                                td: '�ܽ�' + main.amtSum + 'Ԫ'
                            },
                            {
                                td: ''
                            },
                            {
                                td: ''
                            },
                            {
                                td: ''
                            }
                        ],
                        [
                            {
                                td: '�Ƶ���' + session['LOGON.USERNAME']
                            },
                            {
                                td: '��ҩ��' + main.phaUserName
                            },
                            {
                                td: '��ҩ��' + main.phaCollectUserName
                            },
                            {
                                td: '�˶ԣ�' + main.phaCollateUserName
                            },
                            {
                                td: '��ҩ��'
                            }
                        ]
                    ]
                };
            }
        });
        if (this.ToBool(prtOptions.isPreview)) {
            p.Preview(true);
        } else {
            p.Print();
            this.LogPrint({}, jsonData, prtOptions, 'DispTotal', '��ӡ����');
        }
    },

    /*
     * @desc: ��ӡ�����ҩ��ϸ
     * @params: phacStr - סԺ��ҩ����ID�ַ���
     * @others:
     */
    PrintResRetDetail: function (prtOptions) {
        this.jsRunServer(
            {
                ClassName: 'web.DHCINPHA.Disp.Print',
                MethodName: 'ResRetDetailJsonData',
                phacStr: prtOptions.phacStr,
                otherStr: prtOptions.otherStr
            },
            function (retJson) {
                if (retJson.length == 0) {
                    return;
                }
                IPPRINTCOM.PrintResRetDetailLodop(null, retJson, prtOptions);
            },
            function (error) {
                console.dir(error);
                alert(error.responseText);
            }
        );
    },
    PrintResRetDetailLodop: function (LODOP, jsonData, prtOptions) {
        PHA_LODOP.PREVIEW_IN_BROWSE = !this.BrowsePreview ? false : this.ToBool(prtOptions.isPreview);
        var title = this.GetPrintTitle('�����ϸ��', prtOptions.reprintFlag);
        var p = new PHA_LODOP.Init('�����ϸ��');
        p.Printer('');
        p.Page('Orient:1; Width:0; Height:0; PageName:A4');
        p.PageNo('Top:270mm; Left:90mm; Format:0');
        p.Text(title, 'Top:5mm; Left:5mm; Width:180mm; Height:20mm; FontName:����; FontSize:16; Alignment:2;Bold:1');
        p.Html({
            // ����
            type: 'html',
            FromTop: 50,
            FromLeft: 5,
            DivWidth: '98%',
            DivHeight: '98%',
            // ������
            data: jsonData,
            width: 195,
            borderStyle: 4,
            padding: 2,
            fontSize: 11,
            rowHeight: 25,
            columns: [
                {
                    name: 'ҩƷ����',
                    index: 'inciDesc',
                    width: '32'
                },
                {
                    name: '���',
                    index: 'spec',
                    width: '15',
                    maxTextLen: 10
                },
                {
                    name: '��������',
                    index: 'reqQty',
                    width: '20'
                },
                {
                    name: '�������',
                    index: 'resQty',
                    width: '20'
                },
                {
                    name: '�����',
                    index: 'retPatName',
                    width: '20'
                }
            ],
            // ������ - ͷ
            formatHeader: function (main) {
                return {
                    marginTop: 20,
                    fontSize: 12,
                    data: [
                        [
                            {
                                td: '������' + main.wardDesc,
                                colspan: 4
                            }
                        ],
                        [
                            {
                                td: '��ҩ���ţ�' + main.dispNo,
                                colspan: 2
                            },
                            {
                                td: '��ҩ���뵥�ţ�' + main.reqNo,
                                colspan: 2
                            }
                        ],
                        [
                            {
                                td: '���ţ�' + main.bedCode
                            },
                            {
                                td: '�ǼǺţ�' + main.patNo
                            },
                            {
                                td: '������' + main.patName
                            },
                            {
                                td: '�Ա�' + main.patSex
                            }
                        ]
                    ]
                };
            },
            // ������ - β
            formatFooter: function (main) {
                return {
                    fontSize: 12,
                    data: [
                        [
                            {
                                td: '�Ƶ��ˣ�' + session['LOGON.USERNAME']
                            }
                        ]
                    ]
                };
            }
        });
        if (this.ToBool(prtOptions.isPreview)) {
            p.Preview(true);
        } else {
            p.Print();
            this.LogPrint({}, jsonData, prtOptions, 'ResRetDetail', '��ӡ�����ϸ');
        }
    },

    /*
     * @desc: ��ӡ��治�� (ע: ��治���Ǹ��ݷ�ҩʱ��ѯ��������ʱGlobal����ӡ��,�޷�����)
     * @params: pid - ��ѯ��ϸ���߻���ʱ������pid
     * @others:
     */
    PrintNoStock: function (pid) {
        if (pid == '') {
            return;
        }
        this.jsRunServer(
            {
                ClassName: 'web.DHCINPHA.Disp.Print',
                MethodName: 'GetNoStock',
                Pid: pid
            },
            function (retJson) {
                if (retJson.length == 0) {
                    return;
                }
                IPPRINTCOM.PrintNoStockLodop(null, retJson);
            },
            function (error) {
                console.dir(error);
                alert(error.responseText);
            }
        );
    },
    /**
     * �µĿ���Ѳ����ӡ, �뷢ҩ������
     */
    PrintNoStockByPhac: function (phacIDStr) {
        if (phacIDStr == '') {
            return;
        }
        this.jsRunServer(
            {
                ClassName: 'web.DHCINPHA.Disp.Print',
                MethodName: 'GetNoStockByPhac',
                phacIDStr: phacIDStr
            },
            function (retJson) {
                if (retJson.length == 0) {
                    return;
                }
                IPPRINTCOM.PrintNoStockLodop(null, retJson);
            },
            function (error) {
                console.dir(error);
                alert(error.responseText);
            }
        );
    },
    PrintNoStockLodop: function (LODOP, jsonData) {
        var prtOptions = {};
        PHA_LODOP.PREVIEW_IN_BROWSE = !this.BrowsePreview ? false : this.ToBool(prtOptions.isPreview);
        var title = this.GetPrintTitle('��治����ϸ', prtOptions.reprintFlag);
        var p = new PHA_LODOP.Init('��治����ϸ');
        p.Printer('');
        p.Page('Orient:1; Width:0; Height:0; PageName:A4');
        p.PageNo('Top:270mm; Left:90mm; Format:0');
        p.Text(title, 'Top:5mm; Left:5mm; Width:180mm; Height:20mm; FontName:����; FontSize:16; Alignment:2;Bold:1');
        p.Html({
            // ����
            type: 'html',
            FromTop: 50,
            FromLeft: 5,
            DivWidth: '98%',
            DivHeight: '98%',
            // ������
            data: jsonData,
            width: 195,
            borderStyle: 4,
            padding: 2,
            fontSize: 11,
            rowHeight: 25,
            columns: [
                {
                    name: 'ҩƷ����',
                    index: 'incDesc',
                    width: '32'
                },
                {
                    name: '���',
                    index: 'spec',
                    width: '15',
                    maxTextLen: 10
                },
                {
                    name: '����',
                    index: 'qty',
                    width: '20'
                },
                {
                    name: '��λ',
                    index: 'uomDesc',
                    width: '20'
                }
            ],
            // ������ - ͷ
            formatHeader: function (main) {
                return {
                    marginTop: 20,
                    fontSize: 12,
                    data: [
                        [
                            {
                                td: '������' + main.wardDesc,
                                width: 50,
                                colspan: 4
                            }
                        ],
                        [
                            {
                                td: '�ǼǺţ�' + main.patNo
                            },
                            {
                                td: '������' + main.patName
                            },
                            {
                                td: '���ţ�' + main.bedCode
                            },
                            {
                                td: '�Ա�' + main.patSex
                            }
                        ]
                    ]
                };
            },
            // ������ - β
            formatFooter: function (main) {
                return {
                    fontSize: 12,
                    data: [
                        [
                            {
                                td: '��ӡ�ˣ�' + session['LOGON.USERNAME']
                            }
                        ]
                    ]
                };
            }
        });
        if (this.ToBool(prtOptions.isPreview)) {
            p.Preview(true);
        } else {
            p.Print();
        }
    },
    /*
     * @desc: �в�ҩ��������ӡ -- xmlģ��
     * @params: phacStr - סԺ��ҩ����ID�ַ���
     * @others:
     *   (1)�в�ҩ��ӡ����ϸ&���ܴ�ӡ���߲�����ͬʱ����
     *   (2)cspҳ������js: scripts/pharmacy/inpha/dhcpha.inpha.hmprintcom.js
     */
    PrintZCY: function (prtOptions) {
        IPPRINTCOM.jsRunServer(
            {
                ClassName: 'web.DHCINPHA.Disp.Print',
                MethodName: 'GetPrescNoArr',
                phacStr: prtOptions.phacStr
            },
            function (retJson) {
                var pLen = retJson.length;
                for (var pi = 0; pi < pLen; pi++) {
                    var PrescNo = retJson[0];
                    INPHA_PRINTCOM.Presc(PrescNo, '����', '');
                }
            },
            function (error) {
                console.dir(error);
                alert(error.responseText);
            }
        );
    },
    /*
     * @desc: ��ӡ�ڷ�ҩ��ǩ -- xmlģ��
     * @params: phacStr - סԺ��ҩ����ID�ַ���
     * @others: �в�ҩ��ӡ����ϸ&���ܴ�ӡ���߲�����ͬʱ����
     */
    PrintKFYLabel: function (prtOptions) {
        IPPRINTCOM.jsRunServer(
            {
                ClassName: 'web.DHCINPHA.Disp.Print',
                MethodName: 'GetKFYLabelJsonData',
                phacStr: prtOptions.phacStr,
                otherStr: prtOptions.otherStr
            },
            function (retJson) {
                IPPRINTCOM.PrintKFYLabelLodop(retJson);
            },
            function (error) {
                console.dir(error);
                alert(error.responseText);
            }
        );
    },
    PrintKFYLabelLodop: function (jsonData) {
        var prtData = [];
        var persons = jsonData.length;
        for (var i = 0; i < persons; i++) {
            var onePersonData = jsonData[i];
            var mainData = onePersonData.main;
            var detailData = onePersonData.detail;
            var myPara = '';
            var myList = '';
            for (var j = 0; j < detailData.length; j++) {
                prtData.push({
                    Para: {
                        warddesc: mainData.wardDesc,
                        paname: mainData.patName,
                        bed: mainData.bedCode,
                        orddate: detailData[j].dodisDate,
                        instruction: detailData[j].instDesc,
                        freqflag: detailData[j].freqDesc
                    },
                    List: []
                });
            }
        }
        PRINTCOM.XML({
            printBy: 'lodop',
            XMLTemplate: 'DHCSTPJLABLE',
            data: prtData,
            oneTask: true
        });
    },

    /*
     * @author:     zhaoxinlong 2022.04.20
     * @description:��ӡ�ڷ�ҩҩ��(������ҽ������ʱҽ������Ҫҩ��) -- xmlģ��
     * @params:     phacStr - סԺ��ҩ����ID�ַ���
     * @others:     �в�ҩ��ӡ����ϸ&���ܴ�ӡ���߲�����ͬʱ����
     * @tips:       ҩ����С��117mm*889mm
     */
    PrintKFYBag: function (prtOptions) {
        var paramsStr = session['LOGON.GROUPID'] + '^' + session['LOGON.CTLOCID'] + '^' + session['LOGON.USERID'] + '^' + session['LOGON.HOSPID'];
        var prtType = tkMakeServerCall('web.DHCST.Common.AppCommon', 'GetAppPropValue', 'DHCSTORDDISP', 'KFYBagPrtType', paramsStr);
        IPPRINTCOM.jsRunServer(
            {
                ClassName: 'web.DHCINPHA.Disp.Print',
                MethodName: 'GetKFYBagJsonData',
                phacStr: prtOptions.phacStr,
                otherStr: prtOptions.otherStr,
                prtType: prtType
            },
            function (retJson) {
                IPPRINTCOM.PrintKFYBagLodop(retJson, prtType);
            },
            function (error) {
                console.dir(error);
                alert(error.responseText);
            }
        );
    },
    PrintKFYBagLodop: function (jsonData, prtType) {
        var prtData = [];
        var persons = jsonData.length;
        for (var i = 0; i < persons; i++) {
            var onePersonData = jsonData[i];
            var mainData = onePersonData.main;
            var detailData = onePersonData.detail;
            var myPara = '';
            var myList = '';
            if (prtType == 'Detail') {
                for (var j = 0; j < detailData.length; j++) {
                    prtData.push({
                        Para: {
                            wardDesc: mainData.wardDesc,
                            patName: mainData.patName,
                            bedCode: mainData.bedCode,
                            dosDate: mainData.dosDate,
                            dosTime: mainData.dosTime,
                            patAge: mainData.patAge,
                            patNo: mainData.patNo,
                            patSex: mainData.patSex,
                            sysDateTime: mainData.sysDateTime,
                            instDesc: mainData.instDesc,
                            bagSeqNo: mainData.bagSeqNo
                        },
                        List: [{ arcimDesc: detailData[j].arcimDesc, spec: detailData[j].spec, doseQty: detailData[j].doseQty }]
                    });
                }
            } else {
                prtData.push({
                    Para: onePersonData.main,
                    List: onePersonData.detail
                });
            }
        }
        PRINTCOM.XML({
            printBy: 'lodop',
            XMLTemplate: 'PHAIPKFYBAG',
            data: prtData,
            oneTask: true
        });
    },
    /*
     * @desc: סԺ��ϸ��ӡ, �����߲�ֵ���, ����˺ֽ, ��ҪԴ�ڳ�Ժ��ҩ������
     * @params: phacStr - סԺ��ҩ����ID�ַ���
     * @others:
     */
    PrintDispDetailGroupByPat: function (prtOptions) {
        this.jsRunServer(
            {
                ClassName: 'web.DHCINPHA.Disp.Print',
                MethodName: 'GetDetailJsonGroupByPat',
                phacStr: prtOptions.phacStr,
                otherStr: prtOptions.otherStr
            },
            function (retJson) {
                if (retJson.length == 0) {
                    return;
                }
                IPPRINTCOM.PrintDispDetailGroupByPatLodop(null, retJson, prtOptions);
            },
            function (error) {
                console.dir(error);
                alert(error.responseText);
            }
        );
    },
    PrintDispDetailGroupByPatLodop: function (LODOP, jsonData, prtOptions) {
        PHA_LODOP.PREVIEW_IN_BROWSE = !this.BrowsePreview ? false : this.ToBool(prtOptions.isPreview);
        var title = this.GetPrintTitle('��ҩ��ϸ��', prtOptions.reprintFlag);
        var p = new PHA_LODOP.Init('��ҩ��ϸ��');
        p.Printer('');
        p.Page('Orient:1; Width:0; Height:0; PageName:A4');
        p.PageNo('Top:270mm; Left:90mm; Format:0');
        p.Text(title, 'Top:5mm; Left:5mm; Width:180mm; Height:20mm; FontName:����; FontSize:16; Alignment:2; Bold:1');
        p.Html({
            // ����
            type: 'html',
            FromTop: 50,
            FromLeft: 5,
            DivWidth: '98%',
            DivHeight: '98%',
            // ������
            data: jsonData,
            width: 195,
            borderStyle: 4,
            padding: 2,
            fontSize: 11,
            rowHeight: 25,
            columns: [
                {
                    name: 'ҩƷ����',
                    index: 'inciDesc',
                    width: '52'
                },
                {
                    name: '����',
                    index: 'doseQty',
                    width: '12'
                },
                {
                    name: 'Ƶ��',
                    index: 'freqDesc',
                    width: '11'
                },
                {
                    name: '�÷�',
                    index: 'instDesc',
                    width: '15'
                },
                {
                    name: 'ʱ��',
                    index: 'timeDosingStr',
                    width: '20'
                },
                {
                    name: '���',
                    index: 'spec',
                    width: '15'
                },
                {
                    name: '����',
                    index: 'qty',
                    width: '15'
                },
                {
                    name: '��λ',
                    index: 'uomDesc',
                    width: '11',
                    align: 'center'
                }
            ],
            // ������ - ͷ
            formatHeader: function (main) {
                return {
                    marginTop: 20,
                    fontSize: 12,
                    data: [
                        [
                            {
                                td: '������ң�' + main.wardDesc,
                                width: 30
                            },
                            {
                                td: '��ҩ���' + main.phaType,
                                width: 15
                            },
                            {
                                td: '*' + main.dispNo + '*',
                                width: 20,
                                font: 'C39HrP60DmTt',
                                size: 36
                            }
                        ],
                        [
                            {
                                td: '���ţ�' + main.dispNo
                            },
                            {
                                td: '��ҩʱ�䣺' + main.phaDate
                            },
                            {
                                td: '��ӡʱ�䣺' + main.sysDateTime
                            }
                        ],
                        [
                            {
                                td: '���ţ�' + main.bedNo + '����������' + main.patName + '���ǼǺţ�' + main.patNo,
                                colspan: 3
                            }
                        ]
                    ]
                };
            },
            // ������ - β
            formatFooter: function (main) {
                return {
                    fontSize: 12,
                    data: [
                        [
                            {
                                td: '�Ƶ���' + session['LOGON.USERNAME']
                            },
                            {
                                td: '��ҩ��' + main.phaUserName
                            },
                            {
                                td: '��ҩ��' + main.phaCollectUserName
                            },
                            {
                                td: '�˶ԣ�' + main.phaCollateUserName
                            },
                            {
                                td: '��ҩ��'
                            }
                        ],
                        [
                            {
                                td: '�ܽ�' + main.amtSum + 'Ԫ'
                            },
                            {
                                td: ''
                            }
                        ]
                    ]
                };
            }
        });
        if (this.ToBool(prtOptions.isPreview)) {
            p.Preview(true);
        } else {
            p.Print();
            this.LogPrint({}, jsonData, prtOptions, 'DispDetailGroupByPat', '��ӡ��Ժ��ҩ(������)');
        }
    },
    /*
     * @desc: ��ȡ��ҩ�����Ӧ�ķ�ҩ���
     * @params: phac - ��ҩ����ID
     */
    GetDispType: function (phac) {
        var dispType = tkMakeServerCall('web.DHCINPHA.Disp.Print', 'GetDispType', phac);
        return dispType;
    },
    /*
     * @desc: ��������(�����ν���)
     */
    CommonVar: null,
    GetCommonVar: function () {
        var phaloc = this.GetPhaLoc();
        var printConfigStr = tkMakeServerCall('web.DHCINPHA.Disp.Print', 'GetPrintConfig', phaloc);
        this.CommonVar = JSON.parse(printConfigStr);
        return;
    },
    /*
     * @desc: ��ȡ��ӡ����
     */
    GetPrintTitle: function (type, reprintFlag) {
        this.GetCommonVar();
        if (reprintFlag == 'Y' || reprintFlag == 1 || reprintFlag == '1') {
            return this.CommonVar.titlePrefix + type + '(��)';
        }
        return this.CommonVar.titlePrefix + type;
    },
    /*
     * @desc: ��ȡĳ��ҩ����
     * @params: dspTypeCode - ��ҩ������
     */
    GetPrtTypeConfig: function (dspTypeCode) {
        this.GetCommonVar();
        return this.CommonVar[dspTypeCode] || {};
    },
    /*
     * @desc: �������
     */
    deepCopy: function (source) {
        var result = {};
        for (var key in source) {
            result[key] = typeof source[key] === 'object' ? IPPRINTCOM.deepCoyp(source[key]) : source[key];
        }
        return result;
    },
    /*
     * @desc: 8.3û��hisui�Ļ���,���Զ���һ��ajax
     */
    jsRunServer: function (_options, successFn, errorFn) {
        $.ajax({
            url: 'websys.Broker.cls',
            type: 'post',
            async: false,
            dataType: 'json',
            data: _options,
            success: function (jsonData) {
                successFn(jsonData);
            },
            error: function (XMLHR) {
                errorFn(XMLHR);
            }
        });
    },
    GetPhaLoc: function () {
        if ($('#conPhaLoc').length > 0 && $('#conPhaLoc')['combobox']) {
            return $('#conPhaLoc').combobox('getValue') || session['LOGON.CTLOCID'];
        }
        if ($('#sel-phaloc').length > 0 && $('#sel-phaloc')['select2']) {
            return $('#sel-phaloc').select2('data')[0].id || session['LOGON.CTLOCID'];
        }
        return session['LOGON.CTLOCID'];
    },
    ToBool: function (preFlag) {
        var trueArr = [1, '1', 'true', true, 'Y', 'y'];
        if (trueArr.indexOf(preFlag) >= 0) {
            return true;
        }
        return false;
    },
    /**
     * description: ����IE�����ʵ�ֶ�ҳǩԤ��
     * creator:     Huxt 2021-10-30
     * others:      ��Ҫ�������²���:
     *  (1)�ڱ�js���޸�IPPRINTCOM.BrowsePreview��ֵΪtrue
     *  (2)��סԺ��ҩ��סԺ�ѷ�ҩ��ѯ�����csp�������ǩ: <ADDINS require="CmdShell" />
     */
    OpenBrowser: function (_options) {
        _options.notOpen = 'Y';
        var jsFuncParam = JSON.stringify(_options);
        var jsFunc = 'IPPRINTCOM.Print(' + jsFuncParam + ')';
        PHA_LODOP_OPEN({
            jsSrc: 'scripts/pharmacy/inpha/ipprintcom.js',
            jsFunction: jsFunc
        });
        return true;
    }
};
