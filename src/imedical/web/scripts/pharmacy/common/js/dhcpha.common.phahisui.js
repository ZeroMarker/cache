/**
 * creator:		dinghongying
 * createdate:	2018-11-23
 * description: 移动药房给予jquery+easyUI的一些公共方法
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
    // CSP入参分割字符
    Split: "|@|",
    // 登记号长度
    PatNoLength: function() {
        var patNoLen = tkMakeServerCall("web.PHAHERB.Common", "PatRegNoLen");
        return patNoLen;
    },
    // 补零
    PadZero: function(_no, _len) {
        var _noLen = _no.length;
        if (_noLen > _len) {
            $.messager.alert("提示", "字符长度大于需补齐的长度!", "warning");
            return _no;
        }
        var needLen = _len - _noLen;
        for (var i = 1; i <= needLen; i++) {
            _no = "0" + _no;
        }
        return _no
    },
    // 初始化业务界面各种下拉列表
    // dhcstcomboeu:scripts/dhcst/EasyUI/Plugins/dhcst.plugins.js
    ComboBox: {
        Init: function(_cOptions, _options) {
            DHCPHA_HUI_COM.ComboBox.Init(_cOptions, _options, "DHCPHA");
        },
        // 设置选择第几条记录
        Select: function(_options) {
            //_options.Id
            //_options.Num
            var _id = _options.Id;
            var data = $('#' + _id).combobox('getData');
            if (data.length > 0) {
                $('#' + _id).combobox('select', data[_options.Num].RowId);
            }

        },
        // 药房科室
        DHCPhaLoc: {
            ClassName: "web.DHCPHACOM.CommonUtil.QueryDictionary",
            QueryName: "DHCPhaLoc",
            inputParams: session['LOGON.CTLOCID']
        },
        // 配方类型
        PresForm: {
	        ClassName: "web.DHCPHACOM.CommonUtil.QueryDictionary",
            QueryName: "PrescForm",
            inputParams: session['LOGON.CTLOCID']
        },
        // 审方时刻
        PresChkSel: {
            data: [{ "RowId": "1", "Description": "先收费后审方" }, { "RowId": "2", "Description": "先审方后收费" }]
        },
        // 打印用法标签
        PrintLabSelect:{
            data: [{ "RowId": "0", "Description": "不打印标签" },{ "RowId": "1", "Description": "调配完成后打印标签" }, { "RowId": "2", "Description": "单独打印标签" }]
        },
        // 界面描述
        WHInterFace: {
            data: [{ "RowId": "H", "Description": "草药界面" }, { "RowId": "W", "Description": "西药界面" }]
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
    // 初始化业务界面各种下拉Grid
    // dhcstcombogrideu:scripts/dhcst/EasyUI/Plugins/dhcst.plugins.js
    ComboGrid: {
        Init: function(_cOptions, _options) {
            DHCPHA_HUI_COM.ComboGrid.Init(_cOptions, _options, "DHCPHA");
        },
    },    
    // 初始化日期
    Date: {
        Init: function(_options) {
            //_options.Id:元素id
            //_options.DateT: t格式的日期(t为当日)
            var id = _options.Id;
            var dateT = _options.DateT;
            if (!dateT) {
                dateT = "t";
            }
            var retDate = tkMakeServerCall("web.DHCSTKUTIL", "GetDate", "", "", dateT);
            $('#' + id).datebox('setValue', retDate)
        }
    },
    // 润乾背景
    RunQianBG: "../csp/dhcst.blank.backgroud.csp",
    // 拼接html用于前台显示
    Html: {
        // 指标公式维护
        IngredientButtons: function(_options) {
            //_options.Id // 添加到table的Id
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
        /// confirm,拼接显示内容为table,整齐布局
        ConfirmInfo: function(_options) {
            /// _options.Data 用于分解的json数组
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
        /// grid单元格划过提示,以后封装
        CellTip: function(_options) {
            //_options.TipArr:需要提示的列id,数组
            //_options.ClassName:需要调取后台的类(不常用,可优化)
            //_options.MethodName:需要调取后台的方法
            //_options.TdField:需要获取前台某列的单元格值的field
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
                            // 不用mousemove,mouseover,移动时调后台会频繁访问服务器
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
        // 关联勾选(比如:关联医嘱)
        LinkCheck: {
            Stat: "",
            Init: function(_options) {
                //_options.CurRowIndex:当前行
                //_options.GridId:表格Id
                //_options.Field: 列的Field值
                //_options.Check: true勾选,false不勾选
                //_options.Value: 键值
                //_options.Type:(Select-选择行,Check-勾选)
                if (this.Stat == "") {
                    this.Stat = 1;
                    var gridId = _options.GridId;
                    var field = _options.Field;
                    var check = _options.Check;
                    var value = _options.Value;
                    var type = _options.Type;
                    if (type == "Select") {
                        // 清除所有选中
                        $('#' + gridId).datagrid("unselectAll");
                    }
                    var gridRowsData = $('#' + gridId).datagrid("getRows");
                    var gridRowsCount = gridRowsData.length;
                    // 向下
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
                    // 向上
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
            SurgeryImg: '<img src="../images/webemr/手术（有手术医嘱的患者).png" border=0 height="12px"/>',
            Yes: '<img src="../scripts/pharmacy/common/image/yes.png"></img>',
            //Yes: '<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>',
            No: '<i class="fa fa-close" aria-hidden="true" style="color:#DD4F43;font-size:18px"></i>',
            PersonEven: "background-color:#00A59D;", //509de1
            SignEven: "color:red;",
            SignRowEven: "background-color:#20BB44",
            BatchPack: "background-color:#17C3AC;", // 打包批次
            BatchUp: "font-weight:bold;" // 修改批次
        },
        Formatter: {
            OeoriSign: function(value, row, index) {
                if ((value == "│") || (value == "0")) {
                    return '<div class="oeori-sign-c"></div>';
                } else if ((value == "┍") || (value == "-1")) {
                    return '<div class="oeori-sign-t"></div>';
                } else if ((value == "┕") || (value == "1")) {
                    return '<div class="oeori-sign-b"></div>';
                } else {
                    return value;
                }
            }
        },
        Styler: {
            // grid中field:incDescStyle,json列太多会慢,合一起
            // 库存不足(Y)!!溶媒超包装(Y)!!剂量非整包装(Y)
            IncDesc: function(value, row, index) {
                var incStyle = row.incDescStyle;
                if (incStyle) {
                    var incStyleArr = incStyle.split("!!");
                    var style = "";
                    if (incStyleArr[0] == "Y") { // 库存不足
                        style += "background-color:#17C3AC;"
                    }
                    if (incStyleArr[1] == "Y") { // 溶媒超包装
                        style += "font-weight:bold;"
                    }
                    if (incStyleArr[2] == "Y") { // 剂量非整包装
                        style += "border-bottom:1px solid black;"
                    }
                    return style;
                }
            },
            // 配液状态颜色
            PivaState: function(value, row, index) {
                switch (value) {
                    case "开医嘱":
                        colorStyle = "background: #ee4f38;color:white;font-weight:bold;";
                        break;
                    case "护士审核":
                        colorStyle = "background:#f58800;color:white;font-weight:bold;";
                        break;
                    case "配伍审核":
                        colorStyle = "background:#f58800;color:white;font-weight:bold;";
                        break;
                    case "审核通过":
                        colorStyle = "background:#f58800;color:white;font-weight:bold;";
                        break;
                    case "排批":
                        colorStyle = "background:#f1c516;color:white;font-weight:bold;";
                        break;
                    case "打签":
                        colorStyle = "background:#a4c703;color:white;font-weight:bold;";
                        break;
                    case "分签":
                        colorStyle = "background:#51b80c;color:white;font-weight:bold;";
                        break;
                    case "排药":
                        colorStyle = "background:#4b991b;color:white;font-weight:bold;";
                        break;
                    case "贴签":
                        colorStyle = "background:#03ceb4;color:white;font-weight:bold;";
                        break;
                    case "核对":
                        colorStyle = "background:#10b2c8;color:white;font-weight:bold;";
                        break;
                    case "配置":
                        colorStyle = "background:#107cc8;color:white;font-weight:bold;";
                        break;
                    case "复核":
                        colorStyle = "background:#1044c8;color:white;font-weight:bold;";
                        break;
                    case "打包":
                        colorStyle = "background:#6557d3;color:white;font-weight:bold;";
                        break;
                    case "病区接收":
                        colorStyle = "background:#a849cb;color:white;font-weight:bold;";
                        break;
                    case "开始输液":
                        colorStyle = "background:#d773b0;color:white;font-weight:bold;";
                        break;
                    case "结束输液":
                        colorStyle = "background:#77656b;color:white;font-weight:bold;";
                        break;
                    default:
                        colorStyle = "background:white;color:black;font-weight:bold;";
                        break;
                }
                return colorStyle;
            }
        },
        //不复杂直接用此即可,样式待修改
        WarnInfo: function() {
            var msghtml = '<div id="msgboxbox" style="display:none;position: absolute;width:200px;height:100px">一病房存在超时打签数据</div>'
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
        // 静配合计显示组数
        Pagination: function() {
            if ($.fn.pagination) {
                $.fn.pagination.defaults.displayMsg = "显示{from}到{to} 共{total}组"
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
    // 遮罩层,打印\保存\导出
    Progress: {
        Show: function(_options) {
            var _text = '  数  据  处  理  中  ';
            var _type = _options.type;
            if (_type) {
                if (_type == "save") {
                    _text = '  保  存  数  据  中';
                } else if (_type == 'print') {
                    _text = '  打  印  数  据  中'
                } else if (_type == 'export') {
                    _text = '  另  存  数  据  中'
                }
            }
            $.messager.progress({
                title: '请耐心等待...',
                text: _text,
                interval: _options.interval ? _options.interval : 1000
            })
        },
        Close: function() {
            $.messager.progress('close');
        }
    },
    // 声音,IE仅支持MP3
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
    // 选择单号窗体
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
            '<td> <a class="hisui-linkbutton" plain="false" id="btnFindPogsNo" iconCls="icon-w-find">查询</a></td>' +
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
            placeholder: "配液状态...",
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
                    { field: 'psName', title: '配液状态', width: 100, align: 'center' },
                    { field: 'pogsNo', title: '单号', width: 200, align: 'center' },
                    { field: 'pogsDate', title: '操作日期', width: 100, align: 'center' },
                    { field: 'pogsTime', title: '操作时间', width: 150, align: 'center' },
                    { field: 'pogsUserName', title: '操作人', width: 125, align: 'center' }
                ]
            ],
            onDblClickRow: function(rowIndex, rowData) {
                $('#' + _options.TargetId).searchbox('setValue', rowData.pogsNo);
                $('#PogsNoWindowDiv').window('close');
            }
        };
        DHCPHA_HUI_COM.Grid.Init("gridPogsNo", dataGridOption);
        $('#PogsNoWindowDiv').window({
            title: ' 流程单据记录',
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