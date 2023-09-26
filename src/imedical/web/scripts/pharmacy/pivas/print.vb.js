/**
 * creator:		yunhaibao
 * createdate:	2017-12-06
 * description: �����ӡ����
 * DHCST.PIVA.PRINT.js
 */
var PIVASPRINT = ({
    Init: function() {
        document.write("<OBJECT ID='PIVALabel' width='0' height='0' CLASSID='B9D18A6E-5B73-4235-B1D8-457D6DFD45C8' CODEBASE='dthealth/web/addins/client/DHCSTPrint.CAB#version=1,0,0,27'></object>");
    },
    // ������ٸ�ǩ����һ������
    PrintNum: 50,
    // ��¼ȫ�ִ�ǩjson
    LabelsJson: [],
    // �ص�
    CallBack: "",
    // ��ǰ��ӡ����Һ�����������
    WardPogNum: "",
    // ��Һ��ǩֱ�Ӵ�ӡ,����ӡ���Ż���,һ�δ�ӡһ������
    LabelsByPogsNo: function(_options) {
        // _options.pogsNo:  ����
        // _options.sortWay: ����ʽDHCST.PIVA.COMMON.js
        var pogsNo = _options.pogsNo;
        var sortWay = _options.sortWay;
        if (pogsNo == undefined) {
            return "";
        }
        var retVal = tkMakeServerCall("web.DHCSTPIVAS.PrintCom", "LabelsByPogsNo", pogsNo, sortWay);
        var retValArr = retVal.split("^");
        var pid = retValArr[0];
        var count = retValArr[1];
        if ((pid == "") || (count == 0)) {
            return;
        }
        var pageI = 0;
        for (var i = 1; i <= count; i++) {
            var pogId = tkMakeServerCall("web.DHCSTPIVAS.PrintCom", "ListPrintData", pid, i);
            if (pogId == "") {
                break;
            }
            var printTask = "0";
            if (i % (this.PrintNum) == 0) {
                printTask = "1";
            }
            if (i == count) {
                printTask = "1";
            }
            pageI = pageI + 1;
            this.Label({
                pogId: pogId,
                printTask: printTask,
                pageNo: pageI, // ҳ��
                pageNumbers: count, // ҳ��
                rePrint: ""
            });
        }
        // �������global
        tkMakeServerCall("web.DHCSTPIVAS.PrintCom", "KillPrintData", pid);
    },
    // ���ݵ��Ŵ�ӡ���б�ǩ,Json���
    LabelsJsonByPogsNo: function(_options) {
        var pogsNo = _options.pogsNo;
        var sortWay = _options.sortWay;
        if (pogsNo == undefined) {
            return "";
        }
        $.messager.progress({
            title: "�����ĵȴ�...",
            text: '<b>{value}%</b>  ��  ӡ  ��  ��  ��  ',
            interval: 1000000
        })
        $.cm({
            ClassName: "web.DHCSTPIVAS.PrintCom",
            MethodName: "LabelsJsonByPogsNo",
            pogsNo: pogsNo,
            prtWayStr: sortWay
        }, function(retJson) {
            PIVASPRINT.LabelsJson = retJson;
            var retLen = retJson.length;
            if (retLen > 0) {
                PIVASPRINT.LabelsJsonPrint(retLen, 0)
            } else {
                $.messager.progress("close");
            }
        })
    },
    // �ݹ��ӡ
    // @labelCnt:  ��ǩ�ܸ���
    // @labelPageI:�ڼ�����ǩ
    LabelsJsonPrint: function(labelCnt, labelPageI) {
        var PrintNum = PIVASPRINT.PrintNum;
        var PrintLabelI = labelPageI + 1;
        if (labelPageI >= labelCnt) {
            $.messager.progress('close');
            if (PIVASPRINT.CallBack != "") {
                PIVASPRINT.CallBack();
            }
            return;
        }
        var labelJson = PIVASPRINT.LabelsJson[labelPageI];
        var pogId = labelJson.pogId
        if (pogId == "") {
            labelPageI++;
            PIVASPRINT.LabelsJsonPrint(labelCnt, labelPageI);
            return;
        }
        var printTask = "0";
        if (labelPageI % PrintNum == 0) {
            printTask = "1";
        }
        if ((labelPageI + 1) == labelCnt) {
            printTask = "1";
        }
        PIVASPRINT.Label({
            pogId: pogId,
            printTask: printTask,
            pageNo: PrintLabelI, // ҳ��
            pageNumbers: labelCnt, // ��ҳ��
            rePrint: "",
            pogLabelData: labelJson.LabelData
        });
        if (labelPageI % (PIVASPRINT.PrintNum) == 0) {
            // ��ʱ����progress
            $("body>div.messager-window").find("div.messager-p-msg").text(PrintLabelI + " / " + labelCnt)
            $.messager.progress('bar').progressbar('setValue', parseInt((PrintLabelI / labelCnt) * 100));
            setTimeout(function() {
                labelPageI++;
                PIVASPRINT.LabelsJsonPrint(labelCnt, labelPageI);
            }, 10)
        } else {
            labelPageI++;
            PIVASPRINT.LabelsJsonPrint(labelCnt, labelPageI);
        }
    },
    // ��ӡ������ǩ
    // _options.printTask:   �Ƿ��ʹ�ӡ����
    // _options.pogId:	  	 ��Һ����Id
    // _options.pogLabelData:��ǩ����
    Label: function(_options) {
        var printTask = _options.printTask;
        var pogId = _options.pogId;
        var pogLabelData = _options.pogLabelData;
        if (pogLabelData == undefined) {
            pogLabelData = "";
        }
        if (pogId == undefined) {
            pogId = "";
        }
        if ((pogLabelData == "") && (pogId == "")) {
            return;
        }
        if (pogLabelData == "") {
            pogLabelData = tkMakeServerCall("web.DHCSTPIVAS.PrintCom", "GetPrintLabel", pogId);
        }
        if (pogLabelData == "") {
            alert("��ӡ��ǩ����,PogId:" + pogId);
            return;
        }
        var pageNumbers = _options.pageNumbers;
        var pageNo = _options.pageNo;
        var rePrint = _options.rePrint;
        if (pageNumbers == undefined) {
            pageNumbers = 1;
        }
        if (pageNo == undefined) {
            pageNo = 1;
        }
        if (rePrint == undefined) {
            rePrint = "";
        }
        var pogLabelArr = pogLabelData.split("|@|");
        var pogMainData = pogLabelArr[0];
        var pogDetailData = pogLabelArr[1];
        var Bar = new ActiveXObject("DHCSTPrint.PIVALabel")
        Bar.Device = "PIVAS"
        Bar.PageWidth = 70
        Bar.PageHeight = 90
        Bar.HeadFontSize = 9
        Bar.FontSize = 10
        Bar.Title = pogMainData.split("^")[36] + "��Һǩ" + rePrint;
        Bar.HeadType = ""
        Bar.IfPrintBar = "True" // �Ƿ��ӡ��
        Bar.BarTop = 66
        Bar.BarLeftMarg = 2
        Bar.BarFontSize = 20
        Bar.PageSpaceItm = 1
        Bar.ItmFontSize = 9
        Bar.PageMainStr = pogMainData
        Bar.PageItmStr = pogDetailData
        Bar.PageSpace = 1
        Bar.PageLeftMargine = 1
        Bar.PageTopMargine = 0
        Bar.BarWidth = 24
        Bar.BarHeight = 8
        Bar.PageNumbers = pageNumbers
        Bar.PageNumber = pageNo
        Bar.ItmOmit = true; // ҩƷ�����Ƿ���
        Bar.ItmCharNums = 30; // ҩƷ����ÿ���ַ���
        Bar.PrintDPage(printTask.toString());
    },
    // ���л���ǩ
    HeadTotalLabel: function(_options) {

    },
    // ��������ǩ
    HeadWardLabel: function(_options) {
        /// _options.headLabelStr
        try {
            var headLabelStr = _options.headLabelStr
            if (headLabelStr == "") {
                return;
            }
            var headLabelArr = headLabelStr.split("|@|");
            var headMainStr = headLabelArr[0];
            var headDetailStr = headLabelArr[1];
            var headMainArr = headMainStr.split("^");
            var headDetailArr = headDetailStr.split("!!");
            var MyList = "";
            var MyPara = "";
            MyPara += "title" + String.fromCharCode(2) + headMainArr[0];
            MyPara += "^printDateTime" + String.fromCharCode(2) + headMainArr[1];
            MyPara += "^printUser" + String.fromCharCode(2) + session['LOGON.USERNAME'];
            MyPara += "^wardDesc" + String.fromCharCode(2) + headMainArr[2];
            MyPara += "^count" + String.fromCharCode(2) + headMainArr[3];
            for (var headI = 0; headI < headDetailArr.length; headI++) {
                var detailStr = headDetailArr[headI];
                var detailArr = detailStr.split("^");
                var listIData = detailArr[0] + "^" + detailArr[1];
                if (MyList == "") MyList = listIData
                else MyList = MyList + String.fromCharCode(2) + listIData
            }
            DHCSTGetXMLConfig("PIVASHeadWardLabel");
            DHCSTPrintFun(MyPara, MyList);
            this.WardPogNum = headMainArr[3].split("��")[0];
        } catch (e) {}
    },
    // TPN��ǩ
    TPNLabel: function(_options) {},
    // ��ӡ·��
    Path: function(_options) {},
    // ��֤�û����Ƿ���ע�ᶯ̬��
    // xName:DHCSTPrint.PIVALabel(���ǩ)
    CheckActiveX: function(xName) {
        try {
            var activeObj = new ActiveXObject(xName);
        } catch (e) {
            alert("���ܴ�ӡ��ǩ,����ע�ᶯ̬�� " + xName);
            return false;
        }
    },
    /// �޸�Ϊ��Ǭraq·��,ע��ͬʱ������Ǭ�ļ�
    /// _option.raqName:   ��Ǭ�ļ���
    /// _options.raqParams:������Ϣ
    /// _options.isPreview:�Ƿ�Ԥ��(1:��)
    /// _options.isPath:   �Ƿ����ȡ·��(1:��)
    RaqPrint: function(_options) {
        var raqName = _options.raqName;
        var raqParams = _options.raqParams;
        var isPreview = _options.isPreview;
        var isPath = _options.isPath;
        var raqSplit = (isPreview == 1 ? "&" : ";");
        var fileName = "";
        var params = "";
        var paramsI = 0;
        for (var param in raqParams) {
            var iParam = raqParams[param];
            var iParamStr = param + "=" + iParam;
            if (paramsI == 0) {
                params = iParamStr;
            } else {
                params = params + raqSplit + iParamStr;
            }
            paramsI++;
        }
        var rqDTFormat = this.RQDTFormat();
        if (isPreview == 1) {
            fileName = raqName + "&RQDTFormat=" + rqDTFormat + "&" + params;
            if (isPath == 1) {
                return "dhccpmrunqianreport.csp?reportName=" + fileName;
            } else {
                DHCCPM_RQPrint(fileName, window.screen.availWidth * 0.5, window.screen.availHeight);
            }
        } else {
            fileName = "{" + raqName + "(" + params + ";RQDTFormat=" + rqDTFormat + ")}";
            alert(fileName)
            DHCCPM_RQDirectPrint(fileName);
        }
    },
    // һЩ�����ӡ��Ĭ������,��ɨ��ʱ��ӡ���ӵ�,��������
    DefaultParams: {
        // ��ҩ��
        Arrange: function() {
            var paramsArr = new Array(29);
            paramsArr[8] = "1"; // ִ�м�¼״̬
            paramsArr[21] = "N"; // ִ�м�¼״̬
            return paramsArr;
        },
        // �������ӵ�
        WardBat: function() {
            var paramsArr = new Array(28);
            paramsArr[8] = "1"; // ִ�м�¼״̬
            paramsArr[21] = "N"; // ִ�м�¼״̬
            return paramsArr;
        }
    },
    // ϵͳ���ڸ�ʽ,��Ǭ��ӡ��
    RQDTFormat: function() {
        var dateFmt = "yyyy-MM-dd"
        var fmtDate = $.fn.datebox.defaults.formatter(new Date());
        if (fmtDate.indexOf("/") >= 0) {
            dateFmt = "dd/MM/yyyy"
        }
        return dateFmt + " " + "HH:mm:ss";
    }
});