/**
 * creator:		dinghongying
 * createdate:	2018-11-23
 * description: �ƶ�ҩ������jquery+easyUI��һЩ��������
 * common.js
 */
var DHCPHA = ({
    Session: {
        More: function(_locId) {
            $.cm({
                ClassName: "web.DHCSTPIVAS.Settings",
                MethodName: "LogonData",
                locId: _locId,
            }, function(jsonData) {
                DHCPHA.Session.HOSPDESC = jsonData.HOSPDESC;
                DHCPHA.Session.CTLOCDESC = jsonData.CTLOCDESC;
            });
        },
        HOSPDESC: "",
        CTLOCDESC: ""
    },
    VAR: {},
    URL: {
        COMMON: "DHCST.HERB.ACTION.csp",
        MAINTAIN: "DHCST.HERB.MAINTAIN.ACTION.csp"
    },
    // CSP��ηָ��ַ�
    Split: "|@|",
    // �ǼǺų���
    PatNoLength: function() {
        var patNoLen = tkMakeServerCall("web.PHAHERB.Common", "PatRegNoLen");
        return patNoLen;
    },
    // ����
    PadZero: function(_no, _len) {
        var _noLen = _no.length;
        if (_noLen > _len) {
            $.messager.alert("��ʾ", "�ַ����ȴ����貹��ĳ���!", "warning");
            return _no;
        }
        var needLen = _len - _noLen;
        for (var i = 1; i <= needLen; i++) {
            _no = "0" + _no;
        }
        return _no
    },
    // ��ʼ��ҵ�������������б�
    // dhcstcomboeu:scripts/dhcst/EasyUI/Plugins/dhcst.plugins.js
    ComboBox: {
        Init: function(_cOptions, _options) {
            DHCPHA_HUI_COM.ComboBox.Init(_cOptions, _options, "DHCPHA");
        },
        // ����ѡ��ڼ�����¼
        Select: function(_options) {
            //_options.Id
            //_options.Num
            var _id = _options.Id;
            var data = $('#' + _id).combobox('getData');
            if (data.length > 0) {
                $('#' + _id).combobox('select', data[_options.Num].RowId);
            }

        },
        // ҩ������
        DHCPhaLoc: {
            ClassName: "web.DHCPHACOM.CommonUtil.QueryDictionary",
            QueryName: "DHCPhaLoc",
            inputParams: session['LOGON.CTLOCID']
        },
        // �䷽����
        PresForm: {
	        ClassName: "web.DHCPHACOM.CommonUtil.QueryDictionary",
            QueryName: "PrescForm",
            inputParams: session['LOGON.CTLOCID']
        },
        // ��ʱ��
        PresChkSel: {
            data: [{ "RowId": "1", "Description": "���շѺ���" }, { "RowId": "2", "Description": "���󷽺��շ�" }]
        },
        // ��ӡ�÷���ǩ
        PrintLabSelect:{
            data: [{ "RowId": "0", "Description": "����ӡ��ǩ" },{ "RowId": "1", "Description": "������ɺ��ӡ��ǩ" }, { "RowId": "2", "Description": "������ӡ��ǩ" }]
        },
        // ��������
        WHInterFace: {
            data: [{ "RowId": "H", "Description": "��ҩ����" }, { "RowId": "W", "Description": "��ҩ����" }]
        }
        
    },
    GridComboBox: {
        Init: function(_cOptions, _options) {
            return DHCPHA_HUI_COM.GridComboBox.Init(_cOptions, _options, "DHCPHA");
        }
    },
    GridComboGrid: {
        Init: function(_cOptions, _options) {
            return DHCPHA_HUI_COM.GridComboGrid.Init(_cOptions, _options, "DHCPHA");
        }
    },
    // ��ʼ��ҵ������������Grid
    // dhcstcombogrideu:scripts/dhcst/EasyUI/Plugins/dhcst.plugins.js
    ComboGrid: {
        Init: function(_cOptions, _options) {
            DHCPHA_HUI_COM.ComboGrid.Init(_cOptions, _options, "DHCPHA");
        },
    },    
    // ��ʼ������
    Date: {
        Init: function(_options) {
            //_options.Id:Ԫ��id
            //_options.DateT: t��ʽ������(tΪ����)
            var id = _options.Id;
            var dateT = _options.DateT;
            if (!dateT) {
                dateT = "t";
            }
            var retDate = tkMakeServerCall("web.DHCSTKUTIL", "GetDate", "", "", dateT);
            $('#' + id).datebox('setValue', retDate)
        }
    },
    // ��Ǭ����
    RunQianBG: "../csp/dhcst.blank.backgroud.csp",
    // ƴ��html����ǰ̨��ʾ
    Html: {
        // ָ�깫ʽά��
        IngredientButtons: function(_options) {
            //_options.Id // ��ӵ�table��Id
            var btnsHtml = tkMakeServerCall("web.DHCSTPIVAS.Dictionary", "PHCIngredientButtons")
            if (btnsHtml != "") {
                var btnsHtmlArr = btnsHtml.split("^");
                var btnsHtmlLen = btnsHtmlArr.length;
                var cacuTableHtml = '';
                for (var btnsI = 0; btnsI < btnsHtmlLen; btnsI++) {
                    var btnDesc = btnsHtmlArr[btnsI];
                    var btnHtml = '<div style="padding-top:5px;padding-left:5px;float:left"><a>' + btnDesc + '</a></div>';
                    cacuTableHtml = cacuTableHtml + btnHtml;
                }
                $("#" + _options.Id).append(cacuTableHtml);
                $("#" + _options.Id + " a").linkbutton();
            }
        },
        /// confirm,ƴ����ʾ����Ϊtable,���벼��
        ConfirmInfo: function(_options) {
            /// _options.Data ���ڷֽ��json����
            var dataArr = _options.Data;
            var _confirmHtml = "<table>";
            for (var cI = 0; cI < dataArr.length; cI++) {
                var cData = dataArr[cI];
                var cHtml = '<tr>' + '<td style="text-align:right;width:70px;border-left:2px solid #40A2DE;">' + cData.title + '</td>' + '<td style="font-weight:bold">' + cData.data + '</td>' + '</tr>'
                _confirmHtml = _confirmHtml + cHtml;

            }
            _confirmHtml = _confirmHtml + "</table>";
            return _confirmHtml;
        }
    },
    Grid: {
        /// grid��Ԫ�񻮹���ʾ,�Ժ��װ
        CellTip: function(_options) {
            //_options.TipArr:��Ҫ��ʾ����id,����
            //_options.ClassName:��Ҫ��ȡ��̨����(������,���Ż�)
            //_options.MethodName:��Ҫ��ȡ��̨�ķ���
            //_options.TdField:��Ҫ��ȡǰ̨ĳ�еĵ�Ԫ��ֵ��field
            if ($("#tipRemark").length < 1) {
                var html = '<div id="tipRemark" style="border-radius:3px; display:none; border:1px solid #017BCE; padding:10px;position: absolute; background-color: white;color:black;"></div>';
                $('body').append(html);
            }
            var findConds = ".datagrid-btable ";
            var tipsArr = _options.TipArr;
            var arrLen = tipsArr.length;
            var tdConds = "";
            for (var i = 0; i < arrLen; i++) {
                tdConds = (tdConds == "") ? "td[field='" + tipsArr[i] + "']" : tdConds + "," + "td[field='" + tipsArr[i] + "']";
            }
            findConds = findConds + tdConds;
            $(findConds).each(function() {
                if (this.textContent != "") {
                    $(this).on({
                        'mouseenter': function() {
                            // ����mousemove,mouseover,�ƶ�ʱ����̨��Ƶ�����ʷ�����
                            var tipInfo = this.textContent;
                            if (_options.ClassName) {
                                var inputStr = $(this).parent().find("td[field=" + _options.TdField + "]").text()
                                tipInfo = tkMakeServerCall(_options.ClassName, _options.MethodName, inputStr)
                            } else if (_options.TdField) {
                                tipInfo = $(this).parent().find("td[field=" + _options.TdField + "]").text()
                            }
                            var tleft = (event.clientX + 20);
                            $("#tipRemark").css({
                                display: 'block',
                                bottom: (document.body.clientHeight - event.clientY) + 'px',
                                left: tleft + 'px',
                                'z-index': 9999,
                                opacity: 1
                            }).html(tipInfo);
                        },
                        'mouseleave': function() {
                            $("#tipRemark").css({ display: 'none' });
                        }
                    })
                }
            })
        },
        // ������ѡ(����:����ҽ��)
        LinkCheck: {
            Stat: "",
            Init: function(_options) {
                //_options.CurRowIndex:��ǰ��
                //_options.GridId:���Id
                //_options.Field: �е�Fieldֵ
                //_options.Check: true��ѡ,false����ѡ
                //_options.Value: ��ֵ
                //_options.Type:(Select-ѡ����,Check-��ѡ)
                if (this.Stat == "") {
                    this.Stat = 1;
                    var gridId = _options.GridId;
                    var field = _options.Field;
                    var check = _options.Check;
                    var value = _options.Value;
                    var type = _options.Type;
                    if (type == "Select") {
                        // �������ѡ��
                        $('#' + gridId).datagrid("unselectAll");
                    }
                    var gridRowsData = $('#' + gridId).datagrid("getRows");
                    var gridRowsCount = gridRowsData.length;
                    // ����
                    var i = _options.CurRowIndex;
                    var tmpRowsCnt = i + 50;
                    for (i = _options.CurRowIndex; i < tmpRowsCnt; i++) {
                        var rowData = gridRowsData[i];
                        if (!rowData) {
                            break;
                        }
                        var iColValue = rowData[field];
                        if (iColValue == value) {
                            if (type == "Select") {
                                $('#' + gridId).datagrid("selectRow", i);
                            } else {
                                $('#' + gridId).datagrid((check == true) ? "checkRow" : "uncheckRow", i);
                            }
                        } else {
                            break;
                        }
                    }
                    // ����
                    var i = _options.CurRowIndex;
                    for (i = _options.CurRowIndex; i >= 0; i--) {
                        var iColValue = gridRowsData[i][field];
                        if (iColValue == value) {
                            if (type == "Select") {
                                $('#' + gridId).datagrid("selectRow", i);
                            } else {
                                $('#' + gridId).datagrid((check == true) ? "checkRow" : "uncheckRow", i);
                            }
                        } else {
                            break;
                        }
                    }
                    this.Stat = "";
                }
            }
        },
        CSS: {
            NoStock: "background-color:#8FC320;",
            SurgeryImg: '<img src="../images/webemr/������������ҽ���Ļ���).png" border=0 height="12px"/>',
            Yes: '<img src="../scripts/pharmacy/common/image/yes.png"></img>',
            //Yes: '<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>',
            No: '<i class="fa fa-close" aria-hidden="true" style="color:#DD4F43;font-size:18px"></i>',
            PersonEven: "background-color:#00A59D;", //509de1
            SignEven: "color:red;",
            SignRowEven: "background-color:#20BB44",
            BatchPack: "background-color:#17C3AC;", // �������
            BatchUp: "font-weight:bold;" // �޸�����
        },
        Formatter: {
            OeoriSign: function(value, row, index) {
                if ((value == "��") || (value == "0")) {
                    return '<div class="oeori-sign-c"></div>';
                } else if ((value == "��") || (value == "-1")) {
                    return '<div class="oeori-sign-t"></div>';
                } else if ((value == "��") || (value == "1")) {
                    return '<div class="oeori-sign-b"></div>';
                } else {
                    return value;
                }
            }
        },
        Styler: {
            // grid��field:incDescStyle,json��̫�����,��һ��
            // ��治��(Y)!!��ý����װ(Y)!!����������װ(Y)
            IncDesc: function(value, row, index) {
                var incStyle = row.incDescStyle;
                if (incStyle) {
                    var incStyleArr = incStyle.split("!!");
                    var style = "";
                    if (incStyleArr[0] == "Y") { // ��治��
                        style += "background-color:#17C3AC;"
                    }
                    if (incStyleArr[1] == "Y") { // ��ý����װ
                        style += "font-weight:bold;"
                    }
                    if (incStyleArr[2] == "Y") { // ����������װ
                        style += "border-bottom:1px solid black;"
                    }
                    return style;
                }
            },
            // ��Һ״̬��ɫ
            PivaState: function(value, row, index) {
                switch (value) {
                    case "��ҽ��":
                        colorStyle = "background: #ee4f38;color:white;font-weight:bold;";
                        break;
                    case "��ʿ���":
                        colorStyle = "background:#f58800;color:white;font-weight:bold;";
                        break;
                    case "�������":
                        colorStyle = "background:#f58800;color:white;font-weight:bold;";
                        break;
                    case "���ͨ��":
                        colorStyle = "background:#f58800;color:white;font-weight:bold;";
                        break;
                    case "����":
                        colorStyle = "background:#f1c516;color:white;font-weight:bold;";
                        break;
                    case "��ǩ":
                        colorStyle = "background:#a4c703;color:white;font-weight:bold;";
                        break;
                    case "��ǩ":
                        colorStyle = "background:#51b80c;color:white;font-weight:bold;";
                        break;
                    case "��ҩ":
                        colorStyle = "background:#4b991b;color:white;font-weight:bold;";
                        break;
                    case "��ǩ":
                        colorStyle = "background:#03ceb4;color:white;font-weight:bold;";
                        break;
                    case "�˶�":
                        colorStyle = "background:#10b2c8;color:white;font-weight:bold;";
                        break;
                    case "����":
                        colorStyle = "background:#107cc8;color:white;font-weight:bold;";
                        break;
                    case "����":
                        colorStyle = "background:#1044c8;color:white;font-weight:bold;";
                        break;
                    case "���":
                        colorStyle = "background:#6557d3;color:white;font-weight:bold;";
                        break;
                    case "��������":
                        colorStyle = "background:#a849cb;color:white;font-weight:bold;";
                        break;
                    case "��ʼ��Һ":
                        colorStyle = "background:#d773b0;color:white;font-weight:bold;";
                        break;
                    case "������Һ":
                        colorStyle = "background:#77656b;color:white;font-weight:bold;";
                        break;
                    default:
                        colorStyle = "background:white;color:black;font-weight:bold;";
                        break;
                }
                return colorStyle;
            }
        },
        //������ֱ���ô˼���,��ʽ���޸�
        WarnInfo: function() {
            var msghtml = '<div id="msgboxbox" style="display:none;position: absolute;width:200px;height:100px">һ�������ڳ�ʱ��ǩ����</div>'
            $("body").append(msghtml)
            $("#msgboxbox").css({
                background: "#3cbd88",
                color: "white",
                display: 'block',
                bottom: '50px',
                right: '10px',
                'z-index': 9999,
                opacity: 0.8,
                transform: "translateY(20%)",
                transition: "all 1s"
            })
            setTimeout(function() {
                $("#msgboxbox").remove()
            }, 3000)
        },
        // ����ϼ���ʾ����
        Pagination: function() {
            if ($.fn.pagination) {
                $.fn.pagination.defaults.displayMsg = "��ʾ{from}��{to} ��{total}��"
            }
        }
    },
    FullScreen: function(ele) {
        if (!!window.ActiveXObject || "ActiveXObject" in window) {
            if (window.screenTop != 0) {
                var WsShell = new ActiveXObject('WScript.Shell')
                WsShell.SendKeys('{F11}');
            }
        } else {}
    },
    // ���ֲ�,��ӡ\����\����
    Progress: {
        Show: function(_options) {
            var _text = '  ��  ��  ��  ��  ��  ';
            var _type = _options.type;
            if (_type) {
                if (_type == "save") {
                    _text = '  ��  ��  ��  ��  ��';
                } else if (_type == 'print') {
                    _text = '  ��  ӡ  ��  ��  ��'
                } else if (_type == 'export') {
                    _text = '  ��  ��  ��  ��  ��'
                }
            }
            $.messager.progress({
                title: '�����ĵȴ�...',
                text: _text,
                interval: _options.interval ? _options.interval : 1000
            })
        },
        Close: function() {
            $.messager.progress('close');
        }
    },
    // ����,IE��֧��MP3
    Media: {
        Play: function(_msgType) {
            if (window.HTMLAudioElement) {
                audio = new Audio();
                if (_msgType != "") {
                    audio.src = "../scripts/pharmacy/common/audio/" + _msgType + ".mp3";
                } else {
                    audio.src = "";
                }
                audio.play();
            }
        },
        Stop: function() {

        }
    },
    // ѡ�񵥺Ŵ���
    // _options.TargetId
    // _options.PivaLocId
    // _options.PsNumber
    PogsNoWindow: function(_options) {
        var winDivId = 'PogsNoWindowDiv';
        var winDiv = '<div id="PogsNoWindowDiv" style="padding:10px;"><div id="gridPogsNo"></div></div>'
        var gridPogsNoBar = '<div id="gridPogsNoBar">' +
            '<table><tr>' +
            '<td> <input id="datePogsNo" class="hisui-datebox" type="text" /></td>' +
            '<td> <input id="cmbPogsNoPsStat" type="text" /></td>' +
            '<td> <a class="hisui-linkbutton" plain="false" id="btnFindPogsNo" iconCls="icon-w-find">��ѯ</a></td>' +
            '</tr></table>' +
            '</div>';
        $("body").append(winDiv);
        $("body").append(gridPogsNoBar);
        $("#btnFindPogsNo").linkbutton();
        $("#datePogsNo").datebox();
        $("#cmbPogsNoPsStat").combobox();
        this.Date.Init({ Id: 'datePogsNo', LocId: "", Type: 'Start', QueryType: 'Query' });
        this.ComboBox.Init({ Id: 'cmbPogsNoPsStat', Type: 'PIVAState' }, {
            editable: false,
            placeholder: "��Һ״̬...",
            onLoadSuccess: function() {
                $(this).combobox('setValue', _options.PsNumber);
            },
            onBeforeLoad: function(param) {
                param.inputStr = _options.PivaLocId;
                param.filterText = param.q;
            }
        });
        $('#btnFindPogsNo').on('click', function() {
            var params = _options.PivaLocId + "^" + $("#cmbPogsNoPsStat").combobox('getValue') + "^" + $("#datePogsNo").datebox('getValue');
            $('#gridPogsNo').datagrid('query', { strParams: params })
        });
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: "web.DHCSTPIVAS.Dictionary",
                QueryName: "PIVAOrdGrpState"
            },
            title: "",
            border: false,
            fitColumns: false,
            singleSelect: true,
            nowrap: false,
            striped: true,
            pagination: true,
            rownumbers: false,
            toolbar: "#gridPogsNoBar",
            columns: [
                [
                    { field: 'psName', title: '��Һ״̬', width: 100, align: 'center' },
                    { field: 'pogsNo', title: '����', width: 200, align: 'center' },
                    { field: 'pogsDate', title: '��������', width: 100, align: 'center' },
                    { field: 'pogsTime', title: '����ʱ��', width: 150, align: 'center' },
                    { field: 'pogsUserName', title: '������', width: 125, align: 'center' }
                ]
            ],
            onDblClickRow: function(rowIndex, rowData) {
                $('#' + _options.TargetId).searchbox('setValue', rowData.pogsNo);
                $('#PogsNoWindowDiv').window('close');
            }
        };
        DHCPHA_HUI_COM.Grid.Init("gridPogsNo", dataGridOption);
        $('#PogsNoWindowDiv').window({
            title: ' ���̵��ݼ�¼',
            collapsible: false,
            iconCls: "icon-apply-check",
            border: false,
            closed: true,
            modal: true,
            width: 900,
            height: 400,
            onBeforeClose: function() {
                $("#PogsNoWindowDiv").remove();
                $("#gridPogsNoBar").remove();
            }
        });

        $('#PogsNoWindowDiv').window('open');
        $("#PogsNoWindowDiv [class='panel datagrid']").css("border", "#cccccc solid 1px")
    }
});