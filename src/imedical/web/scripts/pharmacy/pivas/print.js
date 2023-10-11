/**
 * creator:		yunhaibao
 * createdate:	2017-12-06
 * description: 静配打印公共
 * modify:      2019-04-11,修改为lodop打印,vb打印可见print.vb.js,yunhaibao
 */
var PIVASLODOP = '';
var PIVASPRINT = {
    CallBack: '',
    // 当前打印病区液体的组数总数
    WardPogNum: '',
    /**
     * @description : 打签界面,根据打印单号,批量打印所有签
     * @param {Object} _options
     *                  .pogsNo : 单号 (PIVA_OrdGrpState.POGS_No)
     *                  .sortWay : 工作组Id^打印方式Id
     */
    LabelsJsonByPogsNo: function (_options) {
        var pogsNo = _options.pogsNo;
        var sortWay = _options.sortWay;
        if (pogsNo == undefined) {
            return '';
        }
        $.messager.progress({
            title: '准  备  数  据  中...',
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
     * @description : 根据所选配液主表串打印
     * @param {Object} _options
     *                  .pogsNo : 单号 (PIVA_OrdGrpState.POGS_No)
     *                  .sortWay : 工作组Id^打印方式Id
     */
    LabelsJsonByPogStr: function (_options) {
        var pogStr = _options.pogStr || '';
        var rePrintFlag = _options.rePrintFlag || '';
        rePrintFlag = rePrintFlag !== 'N' ? '补' : '';
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
    // 所有汇总签
    HeadTotalLabel: function (_options) {},
    // 病区汇总签
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
            this.WardPogNum = headMainArr[3].split('组')[0];
        } catch (e) {}
    },
    /**
     * @description 预计为tpn标签
     */
    TPNLabel: function (_options) {},
    /**
     * @description 修改为润乾raq路径,注意同时引入润乾文件
     * @param {Object} _options
     *                  .raqName : 润乾文件名
     *                  .isPreview:是否预览(1:是)
     *                  .isPath:   是否仅获取路径(1:是)
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
    // 一些界面打印的默认条件,如扫描时打印交接单,返回数组
    DefaultParams: {
        // 排药单
        Arrange: function () {
            var paramsArr = new Array(29);
            paramsArr[8] = '1'; // 执行记录状态
            paramsArr[21] = 'N'; // 执行记录状态
            return paramsArr;
        },
        // 病区交接单
        WardBat: function () {
            var paramsArr = new Array(28);
            paramsArr[8] = ''; // 执行记录状态
            paramsArr[21] = 'N'; // 执行记录状态
            return paramsArr;
        }
    },
    // 系统日期格式,润乾打印用
    RQDTFormat: function () {
        var dateFmt = 'yyyy-MM-dd';
        var fmtDate = $.fn.datebox.defaults.formatter(new Date());
        if (fmtDate.indexOf('/') >= 0) {
            dateFmt = 'dd/MM/yyyy';
        }
        return dateFmt + ' ' + 'HH:mm:ss';
    },
    /**
     * @description : 创建配液药品表格
     * @param {String} pogLabelData : 配液主子信息
     * @param {String} pageNo : 当前页
     * @param {String} pageNumbers : 总页数
     * @param {String} rePrint : 补打标识
     * lodop坐标参数 : top left width height
     */
    MakeLodopLabel: function (pogLabelData, pageNo, pageNumbers, rePrint) {
        PIVASLODOP.SET_PRINT_STYLE('FontName', '宋体');
        var rows = pogLabelData.rows;
        var pogDetailLen = rows.length;

        // 只要打印就是NewPageA
        var widthMM = '70mm';
        var heightMM = '70mm';
        var lineLeft = 1;
        var lineRight = 69;
        var bottomTop = 53; // 底部签字距顶部距离,mm
        // 每页固定几个药
        var incCnt = 4;
        var pageLen = Math.ceil(pogDetailLen / incCnt);
        // 页眉部分每页单独写,不能使用SET_PRINT_STYLEA(0, "ItemType", 1),每次都是输出重叠,因此可更加灵活控制每页输出内容
        for (var pageI = 0; pageI < pageLen; pageI++) {
            var pageICnt = incCnt;
            if (pageI + 1 == pageLen) {
                var rem = pogDetailLen % incCnt;
                if (rem != 0) {
                    pageICnt = rem;
                }
            }
            // 截取每页数据
            var st = pageI * incCnt;
            var ed = pageI * incCnt + pageICnt;
            var detailData = rows.slice(st, ed);
            PIVASLODOP.NewPageA();
            // top坐标
            var topMM = 0;
            // 医院抬头
            topMM += 1;
            var title = pogLabelData.phaLocDesc + '输液签';
            if (rePrint !== '') {
                title += '(补-' + pogLabelData.printTimes + ')';
            }
            // 页码
            var pageInfo = pageNo + '-' + (pageI + 1) + '/' + pageNumbers;
            title += '　' + pageInfo;

            PIVASLODOP.ADD_PRINT_TEXTA('hospName', topMM + 'mm', '1mm', '60mm', 1, title);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 8);
            // 标签PNo
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '60mm', '9mm', 15, pogLabelData.pNo);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 3);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 8);
            // 病区
            topMM += 3;
            PIVASLODOP.ADD_PRINT_TEXTA('wardDesc', topMM + 'mm', '1mm', '45mm', 1, pogLabelData.wardDesc);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 11);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            // 床号
            PIVASLODOP.ADD_PRINT_TEXTA('wardDesc', topMM + 4 + 'mm', '1mm', '20mm', 1, pogLabelData.bedNo);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 11);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            //            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 2);
            // 姓名
            PIVASLODOP.ADD_PRINT_TEXTA('wardDesc', topMM + 8 + 'mm', '1mm', '20mm', 1, pogLabelData.patName);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 11);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
            //            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 2);
            // 大类 - 批次 - 打包
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

            // 用药时间 用法 频次 医嘱优先级
            topMM += 5;
            var ordInfo = '';
            ordInfo += ' ' + pogLabelData.doseDateTime;
            ordInfo += ' ' + pogLabelData.instrucDesc;
            ordInfo += ' ' + pogLabelData.freqDesc;
            ordInfo += ' ' + pogLabelData.priDesc;
            PIVASLODOP.ADD_PRINT_TEXTA('ordInfo', topMM + 'mm', '20mm', '100mm', 15, ordInfo); // 显示到底就写长
            // 年龄 性别 登记号
            topMM += 4;
            var patInfo = '';
            patInfo += ' ' + pogLabelData.patAge;
            patInfo += ' ' + pogLabelData.patSex;
            patInfo += ' ' + pogLabelData.patNo;
            patInfo += ' ' + pogLabelData.orderSkin;
            PIVASLODOP.ADD_PRINT_TEXTA('patInfo', topMM + 'mm', '20mm', '100mm', 15, patInfo);
            // 停 拒 退 标识 - 绝对定位
            var specType = pogLabelData.specType;
            if (specType !== '') {
                PIVASLODOP.ADD_PRINT_TEXT('3mm', '40mm', 15, 15, specType);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 24);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 0);
                PIVASLODOP.ADD_PRINT_ELLIPSE('4mm', '39mm', '10mm', '10mm', 0, 2);
            }
            // 表格标题
            topMM += 4;
            PIVASLODOP.ADD_PRINT_LINE(topMM + 'mm', lineLeft + 'mm', topMM + 'mm', lineRight + 'mm', 0, 1);
            topMM += 1;
            PIVASLODOP.SET_PRINT_STYLE('FontSize', 8);
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '30mm', 1, '药品');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '20mm', '20mm', 1, '规格');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '35mm', '20mm', 1, '生产企业');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '50mm', '10mm', 1, '剂量');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '63mm', '100mm', 1, '数量');
            topMM += 4;
            PIVASLODOP.ADD_PRINT_LINE(topMM + 'mm', lineLeft + 'mm', topMM + 'mm', lineRight + 'mm', 0, 1);
            topMM += 1;
            PIVASLODOP.SET_PRINT_STYLE('FontSize', 9);
            // 药品明细 每个药品占两行
            var detailLen = detailData.length;
            for (var detailI = 0; detailI < detailLen; detailI++) {
                var iData = detailData[detailI];
                if (detailI > 0) {
                    topMM += 7;
                }
                var compFlag = iData.compFlag; // ! 不满整支
                var moreFlag = iData.moreFlag; // ! 超包装
                PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '50mm', 15, iData.inciDesc);
                // PIVASLODOP.SET_PRINT_STYLEA(0, 'LineSpacing', '-1mm'); // 文本行间距
                if (compFlag === 'Y') {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Underline', 1);
                }
                if (moreFlag === 'Y') {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
                }
                // 剂量
                PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '50mm', '15mm', 1, iData.dosage);
                if (compFlag === 'Y') {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Underline', 1);
                }
                if (moreFlag === 'Y') {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
                }
                // 数量
                PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '63mm', '10mm', 15, iData.qty);
                // PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 3);
                if (moreFlag === 'Y') {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Underline', 1);
                }
                if (moreFlag === 'Y') {
                    PIVASLODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
                }
                // 生产企业规格
                PIVASLODOP.ADD_PRINT_TEXT(topMM + 3.5 + 'mm', '15mm', '100mm', 15, iData.spec);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 7.5);
                PIVASLODOP.ADD_PRINT_TEXT(topMM + 3.5 + 'mm', '35mm', '30mm', 15, iData.manfDesc);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 7.5);
            }
            PIVASLODOP.SET_PRINT_STYLE('FontSize', 7);
            // 底部开始高度,重新计算高度
            var topMM = bottomTop;
            // 横线
            PIVASLODOP.ADD_PRINT_LINE(topMM + 'mm', lineLeft + 'mm', topMM + 'mm', lineRight + 'mm', 0, 1);
            // 备注(医嘱备注 药师备注等)
            topMM += 1;
            var ordInfoStr = pogLabelData.ordRemark;
            if (pogLabelData.phaLabelRemark !== '') {
                ordInfoStr = ordInfoStr === '' ? pogLabelData.phaLabelRemark : ordInfoStr + ';' + pogLabelData.phaLabelRemark;
            }
            var ordInfo = '备注: ' + ordInfoStr;
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '50mm', 10, ordInfo);
            // 说明 (用药说明 储存条件等)
            topMM += 3;
            var useInfo = '说明: ' + pogLabelData.useInfo + ' ' + pogLabelData.storeInfo;
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '50mm', 10, useInfo);
            // 横线
            topMM += 3;
            PIVASLODOP.ADD_PRINT_LINE(topMM + 'mm', lineLeft + 'mm', topMM + 'mm', lineRight - 18 + 'mm', 0, 1);
            // 签字(审方 排药 核对)
            topMM += 1;
            var user30Name = pogLabelData.ps30UserName !== '' ? pogLabelData.ps30UserName : pogLabelData.user30Name;
            // 签字(医生\审方\打签), 按流程顺序
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '20mm', 1, '医生:' + pogLabelData.docName);
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '17mm', '20mm', 1, '审方:' + pogLabelData.passUserName);
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '34mm', '20mm', 1, '打签:' + session['LOGON.USERNAME']);
            // 签字(核对\配置\复核)
            topMM += 3;
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '20mm', 1, '核对:');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '17mm', '20mm', 1, '配置:');
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '34mm', '20mm', 1, '复核:');
            // 打印时间 单号 二维码
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
            PIVASLODOP.ADD_PRINT_TEXT(topMM + 'mm', '1mm', '50mm', 10, pogLabelData.prtNo + '　' + pogLabelData.barCode.split('-').slice(0, 3).join('-'));
        }
    },
    /**
     * @description 纯html,以快照形式打印，但清晰度不行,暂不考虑
     */
    MakeLodopLabelHtml: function (pogLabelData, pageNo, pageNumbers, rePrint) {},
    Lodop: {
        /**
         * @description lodop排药单
         * 此处预留为8.3的门诊配液,住院暂时不调,后期此处将删除
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
            HtmlZoom.getHtmlFactor(); // 只是IE缩放有问题
            var title = mainJson.hospDesc + mainJson.locDesc + '排药单';
            var rePrint = _pOpts.rePrint || '';
            if (rePrint != '') {
                title = title + ' ( 补 ) ';
            }

            PIVASLODOP.PRINT_INIT('配液中心排药单');
            PIVASLODOP.SET_PRINT_STYLE('FontName', '宋体');
            PIVASLODOP.SET_PRINT_PAGESIZE(1, 0, 0, 'A4');
            PIVASLODOP.ADD_PRINT_TEXT('5mm', '0mm', '100%', '5mm', title);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontName', '宋体');
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 14);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 2);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
            if (pogsNo != '') {
                // 二维码
                PIVASLODOP.ADD_PRINT_BARCODE('5mm', '189mm', '20mm', '20mm', 'QRCode', pogsNo);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
                PIVASLODOP.ADD_PRINT_TEXT('20.5mm', '115mm', '90mm', '5mm', pogsNo);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 3);
                PIVASLODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
            }
            // 列值用百分比
            var html =
                '<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:' +
                HtmlZoom.val_pt('10.5') +
                ';font-family:宋体} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:' +
                HtmlZoom.val_pt('10.5') +
                ';text-align:left} tfoot,th,tr,td{font-weight:normal}</style><table>';
            html += "<thead style='font-weight:bold;'>";
            html += "<td style='width:" + HtmlZoom.val_mm('20mm') + "'>" + ' 货位' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('60mm') + "'>" + ' 药品名称' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('20mm') + "'>" + ' 规格' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('30mm') + "'>" + ' 生产企业' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('15mm') + ";text-align:center'>" + '数量' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('15mm') + "'>" + ' 单位' + '</td>';
            html += "<td style='width:" + HtmlZoom.val_mm('40mm') + "'>" + ' 各批次数量' + '</td></tr>';
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
            html += "<th colspan='2'>" + ' 打印时间:' + mainJson.printDateTime + '</th>';
            html += "<th colspan='2'>" + ' 打印人:' + session['LOGON.USERNAME'] + '</th>';
            html += "<th colspan='2'>" + "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>" + '</th>';
            html += '</tr>';
            html += '<tr>';
            html += "<th colspan='7'  style='border:1px solid black'>" + ' 排药人:　　　　　　排药时间:　　　　　　排药核对人:　　　　　　排药核对时间:　　　　　　' + '' + '</th>';
            html += '</tr>';
            html += '</tfoot></table>';
            // 内部控制缩放,此处不用
            PIVASLODOP.ADD_PRINT_TABLE('25mm', '5mm', '200mm', '250mm', html);
            // PIVASLODOP.PREVIEW();
            PIVASLODOP.PRINT();
        },
        /* 浏览器缩放处理 */
        Zoom: {
            HtmlFactor: 1,
            //获取当前页面的缩放值
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
            // 获取转换系数
            getHtmlFactor: function () {
                this.HtmlFactor = 1;
                var ratio = this.detectZoom();
                if (ratio > 100) {
                    var x = 1 - 100 / ratio; //页面被放大,字体需缩小的比例
                    this.HtmlFactor = 1 - x;
                    return 1 - x;
                } else if (ratio < 100) {
                    var x = 100 / ratio - 1; //页面被缩小,字体需放大的比例
                    this.HtmlFactor = 1 + x;
                    return 1 + x;
                } else {
                    this.HtmlFactor = 1;
                    return 1;
                }
            },
            // 外部调用缩放比例
            printSize: function (val) {
                return this.HtmlFactor * val;
            },

            // 转换为缩放之后带单位的数据3个方法
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
     * xml排药单
     * POGSNo = "", POGIdStr = "", Pid
     */
    Arrange: function (pogsNo, pogIdStr, pid) {
        $.messager.progress({
            title: '排  药  单  打  印  中...',
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
                msg: '没有可供打印数据',
                type: 'alert'
            });
            $.messager.progress('close');
            return;
        }
        data.Para.prtUser = session['LOGON.USERNAME'];
        data.List.unshift({
            stkBin: '货位码',
            inciDesc: '药品',
            spec: '规格',
            manfDesc: '生产企业',
            qty: '数量',
            uomDesc: '单位'
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
                format: '页码:{1}/{2}'
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
                    remarks: App_MenuName + ' - 排药单'
                });
            } else {
                PHA_LOG.Operate({
                    operate: 'P',
                    logInput: JSON.stringify({ pogIdStr: pogIdStr.substr(0, 30) }),
                    // logInput: logParams,
                    type: 'page',
                    pointer: App_MenuCsp,
                    origData: '',
                    remarks: App_MenuName + ' - 排药单'
                });
            }
        }
        setTimeout(function () {
            $.messager.progress('close');
        }, 1000);
    },
    WardBat: {
        /**
         * 病区交接单打印, 使用csp建立模板,通过handlebars解析,调用Lodop
         * TIPS: 默认如下每个循环只打印一个病区的单据, 如果需要打印多个需要调整二维码的生成方式
         * @param {object[]} pJson
         * @param {array}  pJson.pogsNoArr 单号, 传数组
         * @param {string} pJson.loc 配液中心ID
         * @param {string} pJson.rePrint 补打标志 Y
         * @param {string} pJson.printType 打印的单据类型
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
                    remarks: App_MenuName + ' - 交接单 - 病区批次合计'
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
                    remarks: App_MenuName + ' - 交接单 - 药品数量汇总'
                });
            }
        }
    }
};
// 标签打印
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
            title: '发  送  打  印  任  务  中...',
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
        // 是否完成
        var isFinished = function () {
            return labelCnt === dataLen;
        };
        // 取当前标签数据
        var getCurLabel = function () {
            labelJson = dataJson[labelCnt];
            return labelJson;
        };

        // 下一个标签
        var next = function () {
            labelCnt++;
        };

        // 是否需要开始打印,整数倍或最后一个则打印
        var needPrint = function () {
            var labelCntI = labelCnt + 1;
            if (labelCntI % printNum === 0 || labelCntI === dataLen) {
                return true;
            }
            return false;
        };
        // 新任务第一个标签都是初始化
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
                PIVASLODOP.SET_PRINT_MODE('CUSTOM_TASK_NAME', '配液中心输液标签' + labelCnt + 1);
                PIVASLODOP.SET_PRINT_MODE('CATCH_PRINT_STATUS', true);
                if (PIVASLODOP.CVERSION) {
                    PIVASLODOP.On_Return_Remain = true; // true - 每次获取状态都会进入on_return回调
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
