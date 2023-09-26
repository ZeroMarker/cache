<%@ Page Language="C#" Inherits="PageBase" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>微生物标本</title>
    <script type="text/javascript">
        var BasePath = '<%=this.BasePath %>';
        var ResourcePath = '<%=this.ResourcePath %>';
        var WebServicAddress = '<%=LIS.DAL.DataAccess.WebManager.GetWebServicAddress() %>'; 
    </script>
    <link rel="shortcut icon" href="../../resource/common/images/favicon.ico" />
    <script type="text/javascript">
        var sysTheme = '<%=this.UserLogin.Theme %>';
    </script>
    <script src="../../resource/common/js/easyuicss.js" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="../../resource/easyUI/themes/icon.css" />
    <link href="../../resource/plug/font-awesome-4.3.0/css/font-awesome.min.css" rel="stylesheet" />
    <%--界面使用的公共文件--%>
    <script src="../../resource/common/js/lis-common.js" type="text/javascript"></script>
    <link href="../css/FormStyle.css" rel="stylesheet" type="text/css" />
    <script src="../../lisprint/js/LisPrint.js" type="text/javascript"></script>
    <script type="text/javascript">
        ///上下控制选中行
        $.extend($.fn.datagrid.methods, {
            keyCtr: function (jq) {
                return jq.each(function () {
                    var grid = $(this);
                    grid.datagrid('getPanel').panel('panel').attr('tabindex', 1).bind('keydown', function (e) {
                        switch (e.keyCode) {
                            case 13: // Enter
                                var selected = grid.datagrid('getSelected');
                                if (selected) {
                                    var index = grid.datagrid('getRowIndex', selected);
                                    if (editIndex == undefined) {
                                        if (index + 1 >= grid.datagrid('getRows').length) {
                                            grid.datagrid('selectRow', 0);
                                        } else {
                                            grid.datagrid('selectRow', index + 1);
                                        }
                                        return;
                                    } else {
                                        ///更新鉴定号
                                        var curEditors = grid.datagrid('getEditors', index)[0];
                                        var ReportDR = selected.ReportDR;
                                        var EpisodeNo = curEditors.target.val();
                                        ValidEpisodeNo(ReportDR, EpisodeNo, index);
                                        return;
                                    }
                                } else {
                                    grid.datagrid('selectRow', 0);
                                    grid.datagrid('removeEditor', 'EpisodeNo');
                                    editIndex = undefined;
                                }
                                break;
                            case 38: // up
                                var selected = grid.datagrid('getSelected');
                                if (selected) {
                                    var index = grid.datagrid('getRowIndex', selected);
                                    if (index == 0) {
                                        index = grid.datagrid('getRows').length - 1;
                                        grid.datagrid('selectRow', index);

                                        if (editIndex != undefined) {
                                            grid.datagrid('endEdit', editIndex);
                                            editIndex = index;
                                            grid.datagrid('beginEdit', editIndex);
                                            var curEditors = grid.datagrid('getEditors', editIndex)[0];
                                            curEditors.target.focus(); 	//设置焦点
                                            curEditors.target.select(); //选中数据
                                        }
                                        return;
                                    };
                                    grid.datagrid('selectRow', index - 1);
                                    //换行编辑
                                    if (editIndex != undefined) {
                                        grid.datagrid('endEdit', editIndex);
                                        editIndex = index - 1;
                                        grid.datagrid('beginEdit', editIndex);
                                        //设置焦点
                                        var curEditors = grid.datagrid('getEditors', editIndex)[0];
                                        curEditors.target.focus(); 	//设置焦点
                                        curEditors.target.select(); //选中数据
                                    }
                                } else {
                                    var curRows = grid.datagrid('getRows');
                                    grid.datagrid('selectRow', curRows.length - 1);
                                }
                                break;
                            case 40: // down
                                var selected = grid.datagrid('getSelected');
                                if (selected) {
                                    var index = grid.datagrid('getRowIndex', selected);
                                    if (index + 1 >= grid.datagrid('getRows').length) {
                                        grid.datagrid('selectRow', 0);
                                        if (editIndex != undefined) {
                                            grid.datagrid('endEdit', editIndex);
                                            editIndex = 0;
                                            grid.datagrid('beginEdit', editIndex);
                                            var curEditors = grid.datagrid('getEditors', editIndex)[0];
                                            curEditors.target.focus(); 	//设置焦点
                                            curEditors.target.select(); //选中数据
                                        }
                                        return;
                                    };
                                    grid.datagrid('selectRow', index + 1);
                                    //换行编辑
                                    if (editIndex != undefined) {
                                        grid.datagrid('endEdit', editIndex);
                                        editIndex = index + 1;
                                        grid.datagrid('beginEdit', editIndex);
                                        //设置焦点
                                        var curEditors = grid.datagrid('getEditors', editIndex)[0];
                                        curEditors.target.focus(); 	//设置焦点
                                        curEditors.target.select(); //选中数据
                                    }
                                } else {
                                    grid.datagrid('selectRow', 0);
                                    grid.datagrid('removeEditor', 'EpisodeNo');
                                    editIndex = undefined;
                                }
                                break;
                        }
                    });
                });
            }
        });
    </script>
    <script type="text/javascript">
        var me = {
            findType: '0',
            findFlag: null,
            CheckFlowNo: "1",
            RecNoFlag: "LabNo",
            WorkGroupMachineDR: "",
            TestSetDRLists: "",
            checkAssayNo: "",
            labEpisode: "",
            RegNo: "",
            LABIsCheckByTS: "0",     //工作小组是否选择医嘱进行核收
            actionUrlReceiveSample: '../ashx/ashReceiveSample.ashx',
            actionUrlVisitNumber: '../ashx/ashVisitNumber.ashx',
            actionUrlVisitNumberReport: '../ashx/ashVisitNumberReport.ashx',
            actionRejectSampleUrl: "../ashx/ashRejectSample.ashx",
            actionUrl: '../ashx/ashStatSample.ashx'
        };

        var editIndex = undefined;

        $(function () {
            //获取主窗口仪器组
            me.WorkGroupMachineDR = requestUrlParam(location.href, "WorkGroupMachineDR");
            me.checkAssayNo = requestUrlParam(location.href, "checkAssayNo");
            pageInit();

            GetLocalStorage();
            //控制网络按键
            $("#dgChkRecOrderItm").datagrid({}).datagrid("keyCtr");

            ///单独窗口判断 隐藏【返回】按钮
            if (me.WorkGroupMachineDR.length == 0) {
                $('#btn_winRecClose').hide();
            }

            $("#txt_EpisodeNo").focus();

        });

        function pageInit() {
            $('#btn_winRecClear').click(function () { WinRecClear(); });
            $('#btn_winRecSample').click(function () {
                var ReceiveNo = $.trim($('#txt_ReceiveNo').val());
                var VisNumTSDRList = $('#VisNumTSDRList').val();

                var labEpisode = me.labEpisode;
                ///检验号接收
                if (me.RecNoFlag == "LabNo") {
                    ReceiveSample(ReceiveNo, VisNumTSDRList);
                    return;
                };
                if (me.RecNoFlag == "RegNo") {
                    ReceiveSample(labEpisode, VisNumTSDRList);
                    return;
                };
            });
            //检验号回车
            $("#txt_ReceiveNo").keydown(function (event) {
                var ReceiveNo = $.trim($('#txt_ReceiveNo').val());
                //空结果回车跳到位置信息
                if (event.keyCode == "13"&&ReceiveNo == "") {
                    $("#txtRack1").focus();
                    return;
                }
                if ((event.keyCode == "13") && (ReceiveNo != "")) {
                    ///检验号接收
                    if (me.RecNoFlag == "LabNo") {
                        me.TestSetDRLists = "";
                        if (me.LABIsCheckByTS != "1") {
                            ReceiveSample(ReceiveNo, "");
                            return;
                        } else {
                            //按医嘱进行核收
                            var chekedRows = $('#dgLabTestSetInfo').datagrid("getChecked");
                            var TestSetDRLists = "";
                            if (chekedRows.length > 0) {
                                for (var i = 0; i < chekedRows.length; i++) {
                                    if (chekedRows[i].Labno == ReceiveNo) {
                                        if (TestSetDRLists.length == 0) TestSetDRLists = chekedRows[i].TestSetDR;
                                        else TestSetDRLists = chekedRows[i].TestSetDR + "," + TestSetDRLists;
                                    }
                                }
                            }
                            if (TestSetDRLists.length > 0) {
                                //直接接收标本
                                me.TestSetDRLists = TestSetDRLists;
                                ReceiveSample(ReceiveNo, "");
                                me.TestSetDRLists = "";
                                return;
                            }
                            $('#dgLabTestSetInfo').datagrid("loadData", []);
                            $('#divLabTestSetInfo').css({
                                display: 'none'
                            });
                            $.ajax({
                                url: me.actionUrl + '?method=QryAcceptInfoByLabno&LabNo=' + ReceiveNo + "&WorkGroupMachineDR=" + me.WorkGroupMachineDR,
                                async: false, //为true时，异步，不等待后台返回值，为false时强制等待；-asir
                                success: function (returnData) {
                                    $("#dgLabTestSetInfo").datagrid("loadData", returnData);
                                    if (returnData.length == 0 || returnData.length == 1) {
                                        me.TestSetDRLists = "";
                                        ReceiveSample(ReceiveNo, "");
                                        return;
                                    }
                                }

                            })
                            return;

                        }
                    };
                    if (me.RecNoFlag == "RegNo" || me.RecNoFlag == "CardNo") {
                        var div = document.getElementById('txt_ReceiveNo');
                        var oLeft = div.offsetParent.offsetLeft + div.offsetLeft;
                        var oTop = div.offsetParent.offsetTop + div.offsetTop + div.offsetHeight + 5;
                        $('#divLabInfo').css({
                            top: oTop + 'px',  //(e.pageY + 10)
                            left: oLeft + 'px',
                            display: 'block'
                        });
                        $('#dgLabInfo').datagrid({
                            url: me.actionUrl + '?method=QryHisOrderItemListByRegNo'
                        });
                        return;
                    };
//                    if (me.RecNoFlag == "CardNo") {
//                        return;
//                    };
                };
            });
            //位置1回车跳位置2
            $("#txtRack1").keydown(function (event) {
                if (event.keyCode == "13") {
                    $("#txtRack2").focus();
                }
            });
            //位置2回车跳检验号
            $("#txtRack2").keydown(function (event) {
                if (event.keyCode == "13") {
                    $("#txt_ReceiveNo").focus();
                }
            });
            //鉴定号回车
            $("#txt_EpisodeNo").keydown(function (event) {
                var EpisodeNo = $('#txt_EpisodeNo').val();
                if ((event.keyCode == "13") && (EpisodeNo != "")) {
                    $("#txt_ReceiveNo").focus();
                }
            });


            $('#dgLabInfo').datagrid({
                method: 'get',
                fit: true,
                fitColumns: false,  //列少设为true,列多设为false
                singleSelect: true,
                rownumbers: false,
                pagination: false,
                remoteSort: false,
                border: false,
                columns: [[
                   { field: 'labEpisode', title: '检验号', width: 85, sortable: true, align: 'left' },
                   { field: 'patName', title: '姓名', width: 50, sortable: true, align: 'left' },
                   { field: 'itmdesc', title: '医嘱名称', width: 160, sortable: true, align: 'left' },
                   { field: 'SpecimenDesc', title: '标本', width: 40, sortable: true, align: 'left' },
                ]],
                onBeforeLoad: function (param) {
                    if (me.RecNoFlag == "RegNo") param.RegNo = $.trim($('#txt_ReceiveNo').val());
                    if (me.RecNoFlag == "CardNo") param.CardNo = $.trim($('#txt_ReceiveNo').val());
                    param.WorkGroupMachineDR = me.WorkGroupMachineDR
                },
                onDblClickRow: function (rowIndex, rowData) {
                    ///选择
                    ReceiveSample(rowData.labEpisode, "");
                    return;
                },
                onSelect: function (rowIndex, rowData) {
                    me.labEpisode = rowData.labEpisode;
                    me.RegNo = rowData.RegNo;
                },
                onLoadSuccess: function (data) {
                    if (data.total == 0) {
                        $('#divLabInfo').css({
                            display: 'none'
                        });
                    }
                }
            });

            ///初始化工作小组
            $('#cmb_chkWorkGroupMachine').combogrid({
                //                url: me.actionUrlVisitNumberReport + '?method=FindWorkGroupMachine',
                method: 'get',
                panelWidth: 300,
                value: me.WorkGroupMachineDR,
                idField: 'RowID',
                textField: 'CName',
                columns: [[
					{ field: 'RowID', title: 'ID', width: 40, sortable: true, hidden: true, align: 'left' },
					{ field: 'Code', title: '代码', width: 70, sortable: true, align: 'left' },
					{ field: 'CName', title: '名称', width: 150, sortable: true, align: 'left' }
                ]],
                keyHandler: {
                    up: function (event) { keyHandlerUp(event, $(this)); },
                    down: function (event) { keyHandlerDown(event, $(this)); },
                    enter: function (event) { keyHandlerEnter(event, $(this), $('#txt_EpisodeNo')); },
                    query: function (q, event) { }
                },
                onSelect: function (rowIndex, rowData) {
                    $('#txt_EpisodeNo').removeAttr("disabled");
                    $('#btn_GetMaxEpisodeNo').linkbutton('enable');
                    if (rowData.RowID == "AUTO") {
                        $('#txt_EpisodeNo').val("自动分配");
                        $('#txt_EpisodeNo').attr("disabled", "disabled");
                        $('#btn_GetMaxEpisodeNo').linkbutton('disable');
                        $("#txt_ReceiveNo").focus();
                        me.WorkGroupMachineDR = rowData.RowID;
                        GetLocalStorage();
                        $("#chk_PrintRecord").prop("checked", false);
                        $("#chk_edit_BarCodePrint").prop("checked", false);
                        me.LABIsCheckByTS = "0";
                        return;
                    }
                    GetSysParameters("LABIsPrintBarCode^LABIsPrintMicRecord^LABIsCheckByTS^CheckSampleBarCodeNum", rowData.RowID);
                    
                    //设置查询选择
                    $('#cmbTestSetWorkGroup').combogrid("setValue", rowData.RowID);
                    if (me.WorkGroupMachineDR != rowData.RowID) {
                        me.WorkGroupMachineDR = rowData.RowID;
                        WinRecClear();
                        return;
                    };
                    me.WorkGroupMachineDR = rowData.RowID;
                    //获取当前最大鉴定号
                    GetMaxEpisodeNo();
                    GetLocalStorage();

                },
                onLoadSuccess: function (data) {

                    if (me.WorkGroupMachineDR != "") {
                        $('#cmb_chkWorkGroupMachine').combogrid('setValue', me.WorkGroupMachineDR);
                    }
                    else {
                        $.ajax({
                            url: "../ashx/ashVisitNumberReport.ashx?method=GetDefaultWorkGroupMachine",
                            success: function (returnData) {
                                if (returnData) {
                                    if (returnData.IsOk && returnData.Message.length > 0) {
                                        var retValue = returnData.Message;
                                        me.LABDefaultWorkGroupMachine = retValue.split("^")[0];
                                        $('#cmb_chkWorkGroupMachine').combogrid('setValue', me.LABDefaultWorkGroupMachine);
                                        GetSysParameters("LABIsPrintBarCode^LABIsPrintMicRecord^LABIsCheckByTS^CheckSampleBarCodeNum", me.LABDefaultWorkGroupMachine);
                                    }
                                    else {
                                        $('#cmb_chkWorkGroupMachine').combogrid('setValue', data.rows[0].RowID);
                                        me.WorkGroupMachineDR = data.rows[0].RowID;
                                        GetSysParameters("LABIsPrintBarCode^LABIsPrintMicRecord^LABIsCheckByTS^CheckSampleBarCodeNum", me.WorkGroupMachineDR);
                                    }
                                }
                            }
                        })
                    }
                }
            });

            ///初始化Grid
            ShowOrderListsGrid();
            var myDate = new Date();
            var month = myDate.getMonth() + 1;
            var day = myDate.getDate();
            if (month < 10) {
                month = "0" + month;
            }
            if (myDate.getDate() < 10) {
                day = "0" + day;
            }
            var curDateStr = myDate.getFullYear() + "-" + month + "-" + day;
            $("#ReceiveDate").datebox({
                onSelect: function (date) {
                    //求结束日期和开始日期的差
                    var days = daysBetween($("#ReceiveDate").datebox("getValue"), curDateStr);
                    if (days > 3) {
                        $("#ReceiveDate").datebox("setValue", curDateStr);
                        $.messager.alert('提示', "不合理的要求，请确认操作流程问题！");
                    }
                    if (days < 0) {
                        $("#ReceiveDate").datebox("setValue", curDateStr);
                        $.messager.alert('提示', "不合理的要求，请确认操作流程问题！");
                    }
                    GetMaxEpisodeNo();
                }
            });
            //设置默认开始时间值
            $("#ReceiveDate").datebox("setValue", curDateStr);

            ///获取当前最大鉴定号
            //GetMaxEpisodeNo();

            ///初始化查询日期
            var curDate = GetCurentDate();
            $('#dt_FindSttDate').datebox({
                onSelect: function () {
                    //求结束日期和开始日期的差
                    var days = daysBetween($('#dt_FindEndDate').datebox("getValue"), $('#dt_FindSttDate').datebox("getValue"));
                    if (days < 0) {
                        $('#dt_FindEndDate').datebox("setValue", $('#dt_FindSttDate').datebox("getValue"));
                    }
                    if (days > 30) {
                        $('#dt_FindEndDate').datebox("setValue", getNextDays($('#dt_FindSttDate').datebox("getValue"), 30));
                    }
                }
            });
            $('#dt_FindEndDate').datebox({
                onSelect: function () {
                    //求结束日期和开始日期的差
                    var days = daysBetween($('#dt_FindEndDate').datebox("getValue"), $('#dt_FindSttDate').datebox("getValue"));
                    if (days < 0) {
                        $('#dt_FindSttDate').datebox("setValue", $('#dt_FindEndDate').datebox("getValue"));
                    }
                    if (days > 30) {
                        $('#dt_FindSttDate').datebox("setValue", getNextDays($('#dt_FindEndDate').datebox("getValue"), -30));
                    }
                }
            });
            $('#dt_FindSttDate').datebox('setValue', curDate);
            $('#dt_FindEndDate').datebox('setValue', curDate);

            //隐藏高级查询
            $("#div_Complex").hide();
            //点击高级查询显示与隐匿查询条件  
            $('#btn_Complex').click(function () {
                if (me.findType == "0") {
                    me.findType = "1";
                    $("#div_Complex").show();
                    $('#ids').layout('panel', 'north').panel('resize', { height: 60 });
                    $('#ids').layout('resize');
                } else {
                    me.findType = "0";
                    $("#div_Complex").hide();
                    $('#ids').layout('panel', 'north').panel('resize', { height: 40 });
                    $('#ids').layout('resize');
                    //收起时清空下排选项
                    $('#cmb_HISDep').combogrid("setValue", "");
                    //$('#cmb_Collstat').combobox('clear');
                }
            });
            ///科室
            $('#cmb_HISDep').combogrid({
                url: me.actionUrl + '?Method=QryHisDepList',
                method: 'get',
                panelWidth: 300,
                idField: 'depId',
                textField: 'depdesc',
                columns: [[
					{ field: 'depId', title: '科室ID', sortable: true, width: 50, align: 'center' },
                    { field: 'depdesc', title: '名称', width: 200, sortable: true, align: 'left' }
                ]]
            });

            ///工作小组
            $('#cmbTestSetWorkGroup').combogrid({
                url: me.actionUrl + '?Method=CommonQueryView&data=' + JSON.stringify({ ModelName: "BTWorkGroupMachine", Pram: [], IsDisplayCount: false, Joiner: [], Operators: [] }),
                method: 'get',
                panelWidth: 300,
                idField: 'RowID',
                textField: 'CName',
                columns: [[
					{ field: 'RowID', title: 'ID', sortable: true, width: 50, align: 'center' },
                    { field: 'CName', title: '名称', width: 200, sortable: true, align: 'left' }
                ]]
            });

            $("#bt_track").linkbutton({
                iconCls: 'icon-track',
                plain: true
            });
            $('#bt_track').bind('click', function () {
                var curRow = $('#dgChkRecOrderItm').datagrid("getSelected");
                var Labno = "";
                if (curRow != null) {
                    Labno = curRow.Labno;
                }
                showwin("#win_reportTrace", "标本追踪", 'frmReportTrace.aspx?LabNo=' + Labno, document.body.clientWidth - 90, 360, true);
                $('#win_reportTrace').parent().css("background", "#FFFFFF");
                $('#win_reportTrace').attr("class", "easyui-window panel-body panel-body-noheader panel-body-noborder");

            });

            //右边查询回车事件
            $('#txt_FindFast').keydown(function (event) {
                if (event.keyCode == "13") {
                    HisOrderItem();
                    $('#txt_FindFast').val("");
                }
            });
            $.ajax({
                url: me.actionUrlVisitNumberReport + '?method=FindWorkGroupMachine',
                success: function (data) {
                    data.push({ "RowID": "AUTO", "Code": "AUTO", "CName": "自动分配工作小组" });
                    $('#cmb_chkWorkGroupMachine').combogrid('grid').datagrid("loadData", data);
                }


            })
            $('#dgLabTestSetInfo').datagrid({
                method: 'get',
                fit: true,
                fitColumns: false,  //列少设为true,列多设为false
                singleSelect: false,
                rownumbers: false,
                pagination: false,
                remoteSort: false,
                border: false,
                toolbar: '#tbWorkList',
                columns: [[
                   { field: "ck", checkbox: true },
                   { field: 'TestSetDR', title: 'TestSetDR', width: 85, hidden: true, align: 'left' },
                   { field: 'TestSetCode', title: '医嘱代码', width: 80, sortable: true, align: 'left' },
                   { field: 'TestSetName', title: '医嘱名称', width: 200, sortable: true, align: 'left' }
                ]],
                onLoadSuccess: function (data) {
                    $('#txt_ReceiveNo').select();
                    if (data.rows.length > 1) { //多条医嘱时展示选择窗口
                        $(this).datagrid("checkAll");
                        var div = document.getElementById('txt_ReceiveNo');
                        var oLeft = div.offsetParent.offsetLeft + div.offsetLeft;
                        var oTop = div.offsetParent.offsetTop + div.offsetTop + div.offsetHeight + 5;
                        $('#divLabTestSetInfo').css({
                            top: oTop + 'px',  //(e.pageY + 10)
                            left: oLeft + 'px',
                            display: 'block'

                        });

                    }
                }
            });
        };  //pageInit

        function ShowOrderListsGrid() {
            $('#dgChkRecOrderItm').datagrid({
                //url: me.actionUrlReceiveSample + '?Method=FindByLabno&Labno=' + Labno,
                iconCls: 'icon-save',
                method: 'get',
                fit: true,
                fitColumns: false,  //列少设为true,列多设为false
                singleSelect: true,
                rownumbers: false,
                pagination: false,
                //pageSize: 20,
                //pageList: [20, 40, 80, 100],
                remoteSort: false,
                border: false,
                columns: [[
                    { field: 'Operate', title: '补打操作', sortable: false, width: 70, align: 'center', formatter: function (value, row, index) {
                        return '<img src="../../mic/images/barcode.png" title="打印条码" onmouseover="this.style.cursor=\'pointer\'"  onclick=\'PrintBar("' + row.Labno + "|" + row.WorkGroupMachineDR + '")\' />&nbsp<img title="打印记录单" onmouseover="this.style.cursor=\'pointer\'" src="../../mic/images/viewreport.png" onclick=\'PrintMicRecord("' + row.Labno + "|" + row.WorkGroupMachineDR + '")\' />';
                    }
                    },
                    { field: 'WorkGroupMachineName', title: '工作小组', sortable: true, width: 120, align: 'left' },
                    { field: 'EpisodeNo', title: '鉴定号', sortable: true, width: 90, align: 'left', editor: 'text' },
                    { field: 'PatName', title: '姓名', sortable: true, width: 90, align: 'left' },
                    { field: 'Labno', title: '检验号', sortable: true, width: 90, align: 'left' },
                    { field: 'OrdItmFlag', title: '', width: 30, align: 'center', hidden: true, formatter: ReportIconPrompt },
                    { field: 'TestSetDesc', title: '医嘱名称', sortable: true, width: 200, align: 'left' },
                    { field: 'TestSetFee', title: '价格', sortable: true, width: 60, align: 'center' },
                    { field: 'SpecimenDesc', title: '标本', sortable: true, width: 150, align: 'left' },
                    { field: 'AdmType', title: '类型', sortable: true, width: 50, align: 'left' },
                    { field: 'ReportDR', title: 'ReportDR', hidden: true, width: 50, align: 'left' }
                ]],
                onClickCell: function (rowIndex, field, value) {
                    ///选择
                    if ((editIndex != undefined) || (editIndex != rowIndex)) {
                        $(this).datagrid('endEdit', editIndex);
                        editIndex == undefined;
                    }

                    if (field != "EpisodeNo") {
                        if (editIndex != undefined) {
                            $(this).datagrid('endEdit', editIndex);
                            editIndex = undefined;
                        }
                    } else {
                        editIndex = rowIndex;
                        $(this).datagrid('beginEdit', editIndex);
                        //设置焦点
                        var curEditors = $(this).datagrid('getEditors', rowIndex)[0];
                        curEditors.target.focus(); 	//设置焦点
                        curEditors.target.select(); //选中数据
                    }

                },
                onLoadSuccess: function (data) {
                    //$('#dgChkRecOrderItm').datagrid('clearSelections');   ///清除选择
                }
            });
            var curDate = GetCurentDate();
            //var TestSetWorkGroup = $('#cmbTestSetWorkGroup').combogrid('getValue');
            $('#HisOrderItemList').datagrid({
                //url: me.actionUrl + '?Method=QryHisOrderItemList&SttDate=' + curDate + '&EndDate=' + curDate + '&Stat=' + '已接收',
                method: 'get',
                fitColumns: false,  //列少设为true,列多设为false
                fit: true,
                collapsible: true,
                //rownumbers: true,
                pagination: true,
                pageSize: 20,
                pageList: [20, 50, 100, 200],
                singleSelect: true,
                selectOnCheck: true,
                checkOnSelect: false,
                nowrap: true,  //折行
                border: false,
                sortName: 'labEpisode',
                sortOrder: 'asc',
                remoteSort: false,
                idField: 'labEpisode',
                onSelect: function (rowIndex, rowData) {

                },
                columns: [[
                //                 { field: 'Operate', title: '补打操作', sortable: false, width: 80, align: 'center', formatter: function (value,row,index) {
                //                    // return '<img src="../../mic/images/barcode.png" onclick="PrintBar("' + row.labEpisode + '")" />&nbsp<img src="../../mic/images/viewreport.png" onclick="PrintMicRecord("' + row.labEpisode + '")" />'
                //                 } 
                //                 },
                  {field: 'labEpisode', title: '检验号', width: 85, sortable: true, align: 'left' },
                  { field: 'patName', title: '姓名', width: 50, sortable: true, align: 'left' },
                //{ field: 'itmcode', title: '医嘱代码', width: 60, sortable: true, align: 'center' },
                  {field: 'itmdesc', title: '医嘱名称', width: 160, sortable: true, align: 'left' },
                  { field: 'SpecimenDesc', title: '标本', width: 40, sortable: true, align: 'left' },
                  { field: 'depdesc', title: '科室', width: 100, sortable: true, align: 'left' },
                  { field: 'regNo', title: '登记号', width: 100, sortable: true, align: 'left' },
                  { field: 'executedate', title: '执行日期', hidden: true, sortable: true, align: 'left' },
                  { field: 'executetime', title: '执行时间', hidden: true, sortable: true, align: 'left' },
                  { field: 'RecDate', title: '接收日期', width: 80, sortable: true, align: 'left' },
                  { field: 'RecTime', title: '接收时间', width: 70, sortable: true, align: 'left' },
                  {
                      field: 'state', title: '标本状态', width: 60, sortable: true, align: 'center',
                      styler: function (value, rowData, rowIndex) {
                          if (rowData.state == "未接收") {
                              return 'color:blue;';
                          }
                      }
                  },
                  { field: 'dattim', title: '申请时间', width: 130, sortable: true, align: 'center' },
                //                  { field: 'specCollstate', title: '采集状态', width: 60, sortable: true, align: 'center',
                //                      styler: function (value, rowData, rowIndex) {
                //                          if (rowData.specCollstate == "未采集") {
                //                              return 'color:blue;';
                //                          }
                //                      }
                //                  },
                //                  { field: 'specCollUser', title: '采集者', width: 60, sortable: true, align: 'center' },
                //                  { field: 'specCollDate', title: '采集时间', width: 130, sortable: true, align: 'center',
                //                      formatter: function (value, rowData, rowIndex) {
                //                          return rowData.specCollDate + " " + rowData.specCollTime;
                //                      }
                //                  },
                //{ field: 'unit', title: '单位', width: 60, sortable: true, align: 'center' },
                //{ field: 'ordqty', title: '数量', width: 60, sortable: true, align: 'center' },
                //{ field: 'price', title: '价格', width: 60, sortable: true, align: 'center' },
                  {field: 'type', title: '就诊类型', width: 60, sortable: true, align: 'center' },
                  { field: 'addname', title: '医生', width: 80, sortable: true, align: 'center' },
                ]],
                onLoadSuccess: function (data) {
                    $('#HisOrderItemList').datagrid('clearSelections');
                },
                onDblClickRow: function (rowIndex, rowData) {
                    if (me.RecNoFlag == "LabNo") {
                        $("#txt_ReceiveNo").val(rowData.labEpisode);
                    }
                    else if (me.RecNoFlag == "RegNo") {
                        $("#txt_ReceiveNo").val(rowData.regNo);
                    }
                    ///选择
                    //                    ReceiveSample(rowData.labEpisode, "");
                    //                    $('#txt_FindFast').focus();
                    //                  $(this).datagrid("deleteRow", rowIndex);

                }
            });
        }

        ///获取系统参数
        function GetSysParameters(ParamCode, WorkGroupMachineDR) {
            var retVal = "";
            $.ajax({
                type: "GET",
                dataType: "text", //text, json, xml
                cache: false, //
                async: true, //为true时，异步，不等待后台返回值，为false时强制等待；-asir
                url: me.actionUrlVisitNumber + '?Method=GetSYSParameter&ParamCode=' + ParamCode + '&WorkGroupMachineDR=' + WorkGroupMachineDR,
                success: function (result, status) {
                    if (result) {
                        var Parameters = result.split("@")[0];
                        if (Parameters.split("^")[0] == "1") $("#chk_edit_BarCodePrint").prop("checked", true);
                        else $("#chk_edit_BarCodePrint").prop("checked", false);
                        if (Parameters.split("^")[1] == "1") $("#chk_PrintRecord").prop("checked", true);
                        else $("#chk_PrintRecord").prop("checked", false);
                        me.LABIsCheckByTS = Parameters.split("^")[2];
                        var printNum = "1";
                        if (Parameters.split("^")[3] != "") {
                            printNum = Parameters.split("^")[3];
                        }
                        $("#txtMemoNum").numberbox("setValue", printNum);
                    } else {
                        $("#chk_PrintRecord").prop("checked", false);
                        $("#chk_edit_BarCodePrint").prop("checked", false);
                        me.LABIsCheckByTS = "0";
                        $("#txtMemoNum").numberbox("setValue", "1");
                    }
                }
            });
            return retVal;
        }
        function ReportIconPrompt(value, rowData, rowIndex) {
            var a = [];
            if (value == "U") {
                a.push("<a style='text-decoration:none;' href=\"javascript:void(ShowUrgentInfo('", rowData.ReportDR, "'));\"><span class='icon-urgent'  title='加急'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
            }
            return a.join("");
        }
        function ShowRecSpecmenInfo(ReceiveNo) {
            var LabNo, RegNo, CardNo;
            var ReceiveInfo, VisNumTSDRList;
            var msgInfo;
            if (me.RecNoFlag == "") { me.RecNoFlag == "LabNo" }
            ///检验号处理
            // if (me.RecNoFlag == "LabNo") {
            LabNo = $.trim(ReceiveNo);
            var WorkGroupMachineDR = $('#cmb_chkWorkGroupMachine').combobox('getValue');
            if (WorkGroupMachineDR == "AUTO") WorkGroupMachineDR = "ALL";
            $.ajax({
                url: me.actionUrlVisitNumberReport + '?Method=QryWorkListByLabno&LabNo=' + LabNo + '&WorkGroupMachineDR=' + WorkGroupMachineDR,
                async: false, //为true时，异步，不等待后台返回值，为false时强制等待；-asir
                success: function (data) {
                    //自动分配时出现多报告情况
                    var labNos = "";
                    for (var i = 0; i < data.length; i++) {
                        $('#dgChkRecOrderItm').datagrid('insertRow', {
                            index: 0,
                            row: data[i]
                        });
                        if (labNos == "") labNos = ReceiveNo + "|" + data[i].WorkGroupMachineDR; //拼入工作小组，鉴定号，核收记录单按工作小组打印
                        else labNos = labNos + "^" + ReceiveNo + "|" + data[i].WorkGroupMachineDR;
                    }
                    $('#dgChkRecOrderItm').datagrid('selectRow', 0);
                    PutLocalStorage();
                    if (me.WorkGroupMachineDR == "AUTO") {
                        var BarCodePrint = $('#chk_edit_BarCodePrint').get(0).checked;
                        var memoNum = $("#txtMemoNum").numberbox("getValue");
                        if (BarCodePrint) {
                            //默认数量
                            if (labNos != "") PrintBar(labNos);
                            //请求患者信息web打印

                        }
                        var MicRecordPrint = $('#chk_PrintRecord').get(0).checked;
                        if (MicRecordPrint) {
                            if (labNos != "") PrintMicRecord(labNos);
                        }
                    }
                    //此段代码为仪器结果核收关联报告后不刷新页面提高效率
                    var LABIsMachineResult = window.parent.me.LABIsMachineResult;
                    if (LABIsMachineResult == "1" && me.checkAssayNo.length != 0) {
                        var rowdata = window.parent.$("#dgWorkList").datagrid("getSelected");
                        var index = window.parent.$("#dgWorkList").datagrid("getRowIndex", rowdata);
                        window.parent.$("#dgWorkList").datagrid('updateRow', {
                            index: index,
                            row: data[0]
                        });
                        window.parent.me.windowCloseOK = false;
                        window.parent.$("#dgWorkList").datagrid('selectRow', index);
                        window.parent.$('#win_CheckSample').window('close');
                        return;
                    }
                }
            })
            return;
            // };
            if (me.RecNoFlag == "RegNo") { RegNo = ReceiveNo; };
            if (me.RecNoFlag == "CardNo") { CardNo = ReceiveNo; };
            ///显示
            $.ajax({
                url: me.actionUrlVisitNumber + '?Method=FindSpecmenInfo&LabNo=' + LabNo + '&RegNo=' + RegNo + '&CardNo=' + CardNo,
                async: false, //为true时，异步，不等待后台返回值，为false时强制等待；-asir
                success: function (data) {
                    if (data.length > 0) {
                        //$('#winPatient_form').form('load', data[0]);
                        Labno = data[0].LabNo;
                        ReceiveInfo = data[0].ReceiveInfo;
                        VisNumTSDRList = data[0].VisNumTSDRList;

                        //标本核收
                        if (VisNumTSDRList != "") {
                            if (ReceiveInfo != "") {
                                $.messager.alert("操作提示", ReceiveInfo, "info", function () {
                                    if ($("#chk_AutoRec").is(":checked")) {
                                        ReceiveSample(ReceiveNo, VisNumTSDRList);
                                        return;
                                    } else {
                                        $('#btn_Receive').focus();
                                        return;
                                    }
                                });
                            }
                        } else {
                            if (ReceiveInfo != "") {
                                $.messager.alert("操作提示", ReceiveInfo, "info", function () {
                                    $('#txt_EpisodeNo').focus();
                                    $('#txt_EpisodeNo').select();
                                    return;
                                });
                            } else {
                                $.messager.alert("操作提示", "没有找到医嘱信息！", "info", function () {
                                    $('#txt_EpisodeNo').focus();
                                    $('#txt_EpisodeNo').select();
                                    return;
                                })
                            }
                        }
                    }
                    else {
                        $.messager.alert("操作提示", data.Message, "info", function () {
                            $('#txt_EpisodeNo').focus();
                            $('#txt_EpisodeNo').select();
                            return;
                        })
                    }
                }
            });
        };

        ///拒收信息提示
        function ReceiveSample(ReceiveNo, VisNumTSDRList) {
            if (ReceiveNo == "") {
                return;
            }
            var EpisodeNo = $('#txt_EpisodeNo').val();
            var TransmitDate = $("#ReceiveDate").datebox("getValue");
            $.ajax({
                url: me.actionRejectSampleUrl + '?Method=GetVisitNumberCheckedMSGMIC&FunCode=Reject&Labno=' + ReceiveNo + "&WorkGroupMachineDR=" + me.WorkGroupMachineDR + "&TransmitDate=" + TransmitDate + "&EpisodeNo=" + EpisodeNo,
                async: false, //为true时，异步，不等待后台返回值，为false时强制等待；-asir
                success: function (returnData) {
                    if (returnData) {
                        if (returnData.IsOk) { //无拒收，鉴定号存在信息，直接核收
                            Receive(ReceiveNo, EpisodeNo);
                            return;
                        } else {
                            var PromptArray = returnData.Message.split("@");
                            var WarningAarry = new Array(); //强制信息数组
                            var MaintionAarry = new Array(); //提示信息数组
                            for (var index in PromptArray) {
                                var Info = PromptArray[index];
                                if (Info.length > 0) {
                                    if (Info.split("^")[0] == "3") { //存在强制提示直接返回提示
                                        WarningAarry.push(Info.split("^")[1]);
                                        break;
                                    }
                                    if (Info.split("^")[0] == "2") MaintionAarry.push(Info.split("^")[1]);
                                }
                            }
                            //强制提示
                            if (WarningAarry.length > 0) {
                                $.messager.alert("操作提示", WarningAarry[0], "info", function () {
                                    GetMaxEpisodeNo();
                                    return;
                                });
                                return;
                            }
                            //递归处理提示信息
                            if (MaintionAarry.length > 0) {
                                DealShowInfo(0, MaintionAarry);
                                return;
                            } else {
                                Receive($("#txt_ReceiveNo").val(), $('#txt_EpisodeNo').val());
                                return;
                            }

                        }
                    } else {
                        ExcReceiveSample(ReceiveNo, VisNumTSDRList);
                        return;
                    }
                }
            });
        }
        //递归处理提示信息
        function DealShowInfo(index, MaintionAarry) {
            if (index >= MaintionAarry.length) { //处理完所有提示信息后接收标本
                var LabNo = $("#txt_ReceiveNo").val();
                if (me.RecNoFlag != "LabNo") {
                    LabNo = me.labEpisode;
                }
                Receive(LabNo, $('#txt_EpisodeNo').val());
                return;
            }
            $.messager.confirm("操作提示", MaintionAarry[index], function (ret) {
                if (ret) {
                    DealShowInfo(++index, MaintionAarry);
                    return;
                } else {
                    if (MaintionAarry[index].indexOf("流水号") > -1) {
                        GetMaxEpisodeNo();
                    } else {
                        $("#txt_ReceiveNo").select();
                    }
                    return;
                }
            });

        }
        //标本核收
        function ExcReceiveSample(ReceiveNo, VisNumTSDRList) {
            if (ReceiveNo == "") {
                return;
            }
            //if (VisNumTSDRList == "") {
            //    return;
            //}
            if (me.WorkGroupMachineDR == "") {
                $.messager.alert("操作提示", "工作小组不能为空!", "info", function () {
                    return;
                })
            }
            ///鉴定号重复判断
            var EpisodeNo = $('#txt_EpisodeNo').val();
            if (EpisodeNo.length > 0) {
                $.ajax({
                    url: me.actionUrlVisitNumberReport + '?Method=CheckEpisodeNoMIC&WorkGroupMachineDR=' + me.WorkGroupMachineDR + '&EpisodeNo=' + EpisodeNo,
                    async: false, //为true时，异步，不等待后台返回值，为false时强制等待；-asir
                    success: function (retData) {
                        if (!retData.IsOk) {
                            $.messager.confirm("操作提示", "当前鉴定号已经存在!是否继续核收?", function (ret) {
                                if (ret) {
                                    Receive(ReceiveNo, EpisodeNo);
                                    return;
                                }
                                else {
                                    $('#txt_EpisodeNo').focus();
                                    return;
                                }
                            });
                        } else {
                            Receive(ReceiveNo, EpisodeNo);
                            return;
                        }
                    }
                })
            } else {
                Receive(ReceiveNo, EpisodeNo);
                return;
            }
        };  //ReceiveSample

        function Receive(ReceiveNo, EpisodeNo) {
            var SpecimenQuanlityDR = "";
            var ReceiveNotes = "";
            var VisTSDRLists = "";
            var RackNo = $("#txtRack1").val();
            RackNo += "^" + $("#txtRack2").val();
            if (RackNo == "^") {
                RackNo = "";
            }
            ///接收
            $.ajax({
                url: me.actionUrlReceiveSample + "?Method=ReceiveVisitNumber&ReceiveType=H&Labno=" + ReceiveNo + "&VisTSDRLists=" + VisTSDRLists + "&SpecimenQuanlityDR=" + SpecimenQuanlityDR + "&ReceiveNotes=" + ReceiveNotes + "&WorkGroupMachineDR=" + me.WorkGroupMachineDR + "&EpisodeNo=" + EpisodeNo + "&AcceptDate=" + $("#ReceiveDate").datebox("getValue") + "&CheckTestSetDRList=" + me.TestSetDRLists + "&RackNo=" + RackNo,
                async: false, //为true时，异步，不等待后台返回值，为false时强制等待；-asir
                success: function (returnData) {
                    if (returnData) {
                        me.TestSetDRLists = "";
                        if (returnData.IsOk) {
                            $('#dgLabTestSetInfo').datagrid("loadData", []);
                            $('#divLabTestSetInfo').css({
                                display: 'none'
                            });
                            ShowRecSpecmenInfo(ReceiveNo);
                            $("#txtRack1").val("");
                            $("#txtRack2").val("");
                            if (me.WorkGroupMachineDR == "AUTO") {
                                $('#txt_ReceiveNo').focus();
                                $('#txt_ReceiveNo').select();
                                $('#txt_ReceiveNo').val("");
                                return;
                            }  //自动分配暂时打印条码放入ShowRecSpecmenInfo中
                            ///设置下一鉴定号 只从界面滚动
                            EpisodeNo = nextEpisodeNo(EpisodeNo);
                            $('#txt_EpisodeNo').val(EpisodeNo);
                            if (me.RecNoFlag == "RegNo") {
                                $('#dgLabInfo').datagrid({
                                    url: me.actionUrl + '?method=QryHisOrderItemListByRegNo'
                                });
                            }
                            $('#txt_ReceiveNo').focus();
                            $('#txt_ReceiveNo').select();
                            $('#txt_ReceiveNo').val("");
                            window.parent.me.windowCloseOK = true;
                            var WorkGroupMachineDR = $('#cmb_chkWorkGroupMachine').combogrid('getValue');
                            var BarCodePrint = $('#chk_edit_BarCodePrint').get(0).checked;
                            var memoNum = $("#txtMemoNum").numberbox("getValue");
                            var labNos = "";
                            for (var i = 0; i < memoNum; i++) {
                                if (labNos == "") labNos = ReceiveNo + "|" + WorkGroupMachineDR; //拼入工作小组，鉴定号，核收记录单按工作小组打印
                                else labNos = labNos + "^" + ReceiveNo + "|" + WorkGroupMachineDR;
                            }

                            if (BarCodePrint) {
                                //默认数量
                                if (labNos != "") PrintBar(labNos);
                                //请求患者信息web打印

                            }
                            var MicRecordPrint = $('#chk_PrintRecord').get(0).checked;
                            if (MicRecordPrint) {
                                if (ReceiveNo.length > 0) PrintMicRecord(labNos);
                            }
                            if (returnData.Message.length > 0) showInfo(returnData.Message);
                            return;
                        } else {
                            var returnInfo = returnData.Message.replace("-1^", "");
                            $.messager.alert("操作提示", returnInfo, "info", function () {
                                $('#txt_ReceiveNo').focus();
                                $('#txt_ReceiveNo').select();
                                return;
                            })
                        }
                    }
                }
            });
        }

        ///获取当前最大鉴定号
        function GetMaxEpisodeNo() {
            if (me.WorkGroupMachineDR.length > 0) {

                //此处关联报告处理仪器结果
                var LABIsMachineResult = window.parent.me.LABIsMachineResult;
                if (LABIsMachineResult == "1" && me.checkAssayNo.length != 0) {
                    $('#txt_EpisodeNo').val(me.checkAssayNo);
                    $('#txt_EpisodeNo').attr("disabled", "disabled");
                    $('#cmb_chkWorkGroupMachine').combogrid('textbox').attr("disabled", "disabled")
                    $('#txt_ReceiveNo').focus();
                    return;
                }
                var TransmitDate = $("#ReceiveDate").datebox("getValue");
                $.ajax({
                    url: me.actionUrlVisitNumberReport + '?Method=GetMaxEpisodeNo&WorkGroupMachineDR=' + me.WorkGroupMachineDR + "&TransmitDate=" + TransmitDate,
                    success: function (retData) {
                        if (retData.IsOk) {
                            $('#txt_EpisodeNo').val(retData.Message); ;
                            $('#txt_ReceiveNo').focus();
                        } else {
                            $('#txt_EpisodeNo').focus();
                        }
                    }
                })
            }
        }
        //取出LocalStorage中的核收标本数据
        function GetLocalStorage() {
            var Data = localStorage.getItem("CheckSampleData_" + me.WorkGroupMachineDR);
            if (Data != null & Data != '') {
                Data = jQuery.parseJSON(Data);
                $('#dgChkRecOrderItm').datagrid("loadData", Data);
            }
        }

        //将核收的标本数据根据登陆用户、工作小组放到LocalStorage中
        function PutLocalStorage() {
            var CheckSampleData = $('#dgChkRecOrderItm').datagrid('getData');
            localStorage.setItem("CheckSampleData_" + me.WorkGroupMachineDR, JSON.stringify(CheckSampleData));
        }
        ///验证鉴定号
        function ValidEpisodeNo(VisitNumberReportDR, EpisodeNo, index) {
            if (index == undefined) { return }
            var WorkGroupMachineDR = me.WorkGroupMachineDR;
            if (WorkGroupMachineDR == "AUTO") {
                var selectedRow = $("#dgChkRecOrderItm").datagrid("getSelected");
                if (selectedRow != null) WorkGroupMachineDR = selectedRow.WorkGroupMachineDR
            }
            $.ajax({
                url: me.actionUrlVisitNumberReport + '?Method=CheckEpisodeNoMIC&WorkGroupMachineDR=' + WorkGroupMachineDR + '&EpisodeNo=' + EpisodeNo + '&VisitNumberReportDR=' + VisitNumberReportDR,
                async: false,
                success: function (retData) {
                    if (!retData.IsOk) {
                        $.messager.confirm("操作提示", "当前鉴定号已经存在!是否确认修改?", function (ret) {
                            if (ret) {
                                UpdateEpisodeNo(VisitNumberReportDR, EpisodeNo, index);
                                return;
                            } else {
                                var curEditors = $('#dgChkRecOrderItm').datagrid('getEditors', editIndex)[0];
                                curEditors.target.focus(); 	//设置焦点
                                curEditors.target.select(); //选中数据
                                return;
                            }
                        })
                    } else {
                        UpdateEpisodeNo(VisitNumberReportDR, EpisodeNo, index);
                        return;
                    }
                }
            })
        }
        ///更新鉴定号
        function UpdateEpisodeNo(VisitNumberReportDR, EpisodeNo, index) {
            var AssayNo = $('#dgChkRecOrderItm').datagrid("getSelected").AssayNo;
            $.ajax({
                url: me.actionUrlVisitNumberReport + '?Method=UpdateEpisodeNo&VisitNumberReportDR=' + VisitNumberReportDR + '&EpisodeNo=' + EpisodeNo + "&AssayNo=" + AssayNo,
                async: false,
                success: function (retData) {
                    if (retData.IsOk) {
                        showSlide("修改成功！");
                        $('#dgChkRecOrderItm').datagrid('endEdit', index);
                        if (index + 1 > $('#dgChkRecOrderItm').datagrid('getRows').length) {
                            editIndex = undefined;
                            return;
                        } else {
                            editIndex = index + 1;
                        }
                        $('#dgChkRecOrderItm').datagrid('selectRow', editIndex);
                        $('#dgChkRecOrderItm').datagrid('beginEdit', editIndex);
                        var curEditors = $('#dgChkRecOrderItm').datagrid('getEditors', editIndex)[0];
                        curEditors.target.focus(); 	//设置焦点
                        curEditors.target.select(); //选中数据

                    } else {
                        $.messager.alert("操作提示", retData.Message, "info", function () {
                            var curEditors = $('#dgChkRecOrderItm').datagrid('getEditors', editIndex)[0];
                            curEditors.target.focus(); 	//设置焦点
                            curEditors.target.select(); //选中数据
                            return;
                        });
                    }
                }
            })
        }

        function WinRecClear() {
            //$('#winPatient_form').form('clear');
            $('#dgChkRecOrderItm').datagrid('loadData', { total: 0, rows: [] });
            $('#txt_ReceiveNo').val('');
            if (me.WorkGroupMachineDR == "AUTO") {
                $('#txt_ReceiveNo').focus();
                return;
            }
            $('#txt_EpisodeNo').val('');
            $('#txt_EpisodeNo').focus();
            $('#txt_EpisodeNo').select();
            GetMaxEpisodeNo();
            PutLocalStorage();
        }
        //接收类型
        function mnuRecClick(value, icon, name) {
            me.RecNoFlag = value;
            $('#mnu_winRecNo').menubutton({ menu: '#mnu_recType', iconCls: icon, text: name });
        }
        ///检验医嘱查询
        function HisOrderItem() {
            var SttDate = $('#dt_FindSttDate').datebox('getValue');
            var EndDate = $('#dt_FindEndDate').datebox('getValue');
            //var ReceiveDate = $('#dt_ReceiveDate').datebox('getValue');
            var ReceiveDate = "";
            var TestSetWorkGroup = $('#cmbTestSetWorkGroup').datebox('getValue');
            //            //计算天数差
            //            var arr1 = SttDate.replaceAll("-", "");
            //            var yyyy = arr1.substr(0, 4);
            //            var mm = arr1.substr(4, 2) - 1;
            //            var dd = arr1.substr(6, 2);
            //            var arr = EndDate.split('-');
            //            var EndDate1 = new Date(arr[0], arr[1] - 1, arr[2]); //转换为12-18-2006格式  
            //            var SttDate1 = new Date(yyyy, mm, dd);
            //            var res = (EndDate1.getTime() - SttDate1.getTime()) / (1000 * 3600 * 24); //把相差的毫秒数转换为天数 
            //            if (res > 31) {
            //                showSlide("查询日期不能超过31天");
            //                return;
            //            }
            var LabNo = "";
            var RegNo = "";
            var Name = "";
            var FindTxt = $('#txt_FindFast').val();
            var FindType = me.findFlag;
            //有输入内容，不用工作组查询
            if (FindTxt != "") {
                TestSetWorkGroup = "";
            }
            switch (FindType) {
                case "RegNo":
                    RegNo = FindTxt;
                    break;
                case "Name":
                    Name = FindTxt;
                    break;
                default:
                    LabNo = FindTxt;
                    break;
            }
            //var Collstat = $('#cmb_Collstat').combobox('getValue');
            var Collstat = "";
            var HISDep = $('#cmb_HISDep').combogrid('getValue');
            var Stat = $('#cmb_Stat').combobox('getValue');
            $('#HisOrderItemList').datagrid({
                url: me.actionUrl + '?Method=QryHisOrderItemList',
                queryParams: { SttDate: SttDate, EndDate: EndDate, LabNo: LabNo, RegNo: RegNo, Name: Name, Stat: Stat, Collstat: Collstat, HISDep: HISDep, ReceiveDate: ReceiveDate, TestSetWorkGroup: TestSetWorkGroup }
            });
            $('#txt_FindFast').focus();
        }
        //快速查询选择
        function mnuFindFastClick(value, icon, name) {
            me.findFlag = value;
            $('#mnu_FindFast').menubutton({ menu: '#mnu_FindFastType', iconCls: icon, text: name });
            $('#txt_FindFast').focus();
            $('#txt_FindFast').select();
        }
        //快速日期范围选择
        function mnuDateTypeClick(value) {
            var curDate = GetCurentDate();
            if (value == "1") {
                $('#dt_FindSttDate').datebox('setValue', curDate);
                $('#dt_FindEndDate').datebox('setValue', curDate);
                $('#btn_ThisDay').linkbutton('select');
                $('#btn_7Day').linkbutton('unselect');
                $('#btn_30Day').linkbutton('unselect');
                $('#btn_3Day').linkbutton('unselect');
            } else if (value == "7") {
                sttDate = DateParser("d-6");
                $('#dt_FindSttDate').datebox('setValue', DateFormatter(sttDate));
                $('#dt_FindEndDate').datebox('setValue', curDate);
                $('#btn_ThisDay').linkbutton('unselect');
                $('#btn_7Day').linkbutton('select');
                $('#btn_30Day').linkbutton('unselect');
                $('#btn_3Day').linkbutton('unselect');
            } else if (value == "30") {
                sttDate = DateParser("d-29");
                $('#dt_FindSttDate').datebox('setValue', DateFormatter(sttDate));
                $('#dt_FindEndDate').datebox('setValue', curDate);
                $('#btn_ThisDay').linkbutton('unselect');
                $('#btn_7Day').linkbutton('unselect');
                $('#btn_30Day').linkbutton('select');
                $('#btn_3Day').linkbutton('unselect');
            } else if (value == "3") {
                sttDate = DateParser("d-2");
                $('#dt_FindSttDate').datebox('setValue', DateFormatter(sttDate));
                $('#dt_FindEndDate').datebox('setValue', curDate);
                $('#btn_7Day').linkbutton('unselect');
                $('#btn_30Day').linkbutton('unselect');
                $('#btn_ThisDay').linkbutton('unselect');
                $('#btn_3Day').linkbutton('select');
            }
            HisOrderItem();
        }
        //条码打印
        function PrintBar(labNos) {
            //0:打印所有报告 1:循环打印每一份报告
            var printFlag = "0";
            var userCode = "MIC";
            //1:报告处理打印 2:自助打印 3:医生打印
            var paramList = "1";
            //PrintOut:打印  PrintPreview打印预览
            var printType = "PrintOut";
            var Param = printFlag + "@" + WebServicAddress + "@" + labNos + "@" + userCode + "@" + printType + "@" + paramList + "@HIS.DHCReportPrintBarCode@QueryPrintData";
            LISBasePrint(Param);



        }

        //记录单打印
        function PrintMicRecord(labNos) {

            var evt = document.createEvent("CustomEvent");
            //0:打印所有报告 1:循环打印每一份报告
            var printFlag = "0";
            var userCode = "dhcc";
            //1:报告处理打印 2:自助打印 3:医生打印
            var paramList = "1";
            //PrintOut:打印  PrintPreview打印预览
            var printType = "PrintOut";
            var Param = printFlag + "@" + WebServicAddress + "@" + labNos + "@" + userCode + "@" + printType + "@" + paramList + "@HIS.DHCReportPrintNotes@QueryPrintData";
            LISBasePrint(Param);
        }

        //批量取消核收
        function BatchDisCardReport() {
            var thisWorkGroupMachineDR = $('#cmb_chkWorkGroupMachine').combobox('getValue');
            if (thisWorkGroupMachineDR == "AUTO") {
                showInfo("请选择具体工作小组进行此操作！");
                return;
            }
            showwin("#win_BatchDisCard", "批量取消核收", 'frmBatchDiscardReport.aspx?WorkGroupMachineDR=' + thisWorkGroupMachineDR, 500, document.body.clientHeight - 80, true);
            $('#win_BatchDisCard').parent().css("background", "#FFFFFF");
            $('#win_BatchDisCard').attr("class", "easyui-window panel-body panel-body-noheader panel-body-noborder");
        }
        function CancelChecked() {
            $('#dgLabTestSetInfo').datagrid("loadData", []);
            $("#divLabTestSetInfo").css({
                display: "none"
            })

        }
        function AcceptChecked() {
            var ReceiveNo = $.trim($('#txt_ReceiveNo').val());
            var chekedRows = $('#dgLabTestSetInfo').datagrid("getChecked");
            var TestSetDRLists = "";
            if (chekedRows.length > 0) {
                for (var i = 0; i < chekedRows.length; i++) {
                    if (chekedRows[i].Labno == ReceiveNo) {
                        if (TestSetDRLists.length == 0) TestSetDRLists = chekedRows[i].TestSetDR;
                        else TestSetDRLists = chekedRows[i].TestSetDR + "," + TestSetDRLists;
                    }
                }
            }
            if (TestSetDRLists.length > 0) {
                //直接接收标本
                me.TestSetDRLists = TestSetDRLists;
                ReceiveSample(ReceiveNo, "");
                return;
            } else {
                showInfo("请勾选要核收的医嘱");
            }
        }
    </script>
</head>
<body>
    <div class="easyui-layout" fit="true">
        <div data-options="region:'center'">
            <div class="easyui-layout" fit="true">
                <div region="north" split="true" style="height: 80px; padding: 2px; overflow: hidden;">
                    <table cellspacing="0" cellpadding="0" border="0" class="form_table">
                        <tr>
                            <td>
                                <input class="easyui-datebox" name="ReceiveDate" id="ReceiveDate" data-options="formatter:DateFormatter,parser:DateParser"
                                    style="width: 120px;" />
                            </td>
                            <td>
                                <select class="easyui-validatebox" name="WorkGroupMachine" id="cmb_chkWorkGroupMachine"
                                    required="true" style="width: 150px;" />
                            </td>
                            <th style="text-align: right">
                                鉴定号：
                            </th>
                            <td>
                                <input class="easyui-validatebox" id="txt_EpisodeNo" name="EpisodeNo" style="width: 100px" />
                                <a class="easyui-linkbutton easyui-tooltip" title="获取当前鉴定号" id="btn_GetMaxEpisodeNo"
                                    href="javascript:void(0)" data-options="plain:true,iconCls:'icon-tag_blue_add'"
                                    onclick="GetMaxEpisodeNo();"></a>
                            </td>
                            <td style="background-color: rgb(238, 247, 254)">
                                <a href="#" id="mnu_winRecNo" class="easyui-menubutton" data-options="menu:'#mnu_recType',iconCls:'icon-text_padding_left'">
                                    检验号</a>
                            </td>
                            <td>
                                <input id='txt_ReceiveNo' name="ReceiveNo" style="width: 120px" />
                            </td>
                        </tr>
                        <tr>
                            <th colspan="4" style="text-align: left">
                                打印份数：<input id="txtMemoNum" type="text" style="width: 15px;" value="1" class="easyui-numberbox"
                                    min="1" max="9" />
                                条码打印：<input type="checkbox" id="chk_edit_BarCodePrint" name="chk_edit_BarCodePrint"
                                    value="1" style="width: 30px" />&nbsp 记录单打印:<input type="checkbox" id="chk_PrintRecord"
                                        name="chk_edit_PrintRecord" value="1" style="width: 30px" />&nbsp&nbsp
                                厌氧瓶：<input id='txtRack1' style="width: 90px" />
                                需氧瓶：<input id='txtRack2' style="width: 90px" />
                            </th>
                            <th style="text-align: left" colspan="2">
                                <a id="bt_track" class="easyui-linkbutton" title="标本追踪"></a>&nbsp<a id="btn_winRecSample"
                                    icon="icon-redo" class="easyui-linkbutton" href="javascript:void(0)"> 核收</a>
                                <a id="btn_winRecClear" icon="icon-clear" class="easyui-linkbutton" href="javascript:void(0)">
                                    清空</a> <a id="btn_BatchDisCard" icon="icon-delete" class="easyui-linkbutton easyui-tooltip"
                                        title="批量取消核收" href="javascript:void(0)" onclick="BatchDisCardReport();">批量取消核收</a><a
                                            id="btn_winRecClose" icon="icon-cancel" class="easyui-linkbutton" href="javascript:void(0)"
                                            onclick="window.parent.$('#win_CheckSample').window('close');">返回</a>
                            </th>
                        </tr>
                    </table>
                </div>
                <div data-options="region:'center'">
                    <div id="tt" class="easyui-tabs" data-options="fit:true">
                        <div id="p1" title='核收明细' region="center" data-opitions="fit:true">
                            <table id="dgChkRecOrderItm">
                            </table>
                        </div>
                        <div id="p2" title="标本信息明细查询" region="center" data-opitions="fit:true">
                            <div class="easyui-layout" id="ids" fit="true">
                                <div region="north" iconcls="icon-reload" split="false" style="height: 40px;">
                                    <div id="div_Simple" style="white-space: nowrap;">
                                        <table>
                                            <tr style="padding-top: 2px">
                                                <td style="width: 230px;">
                                                    <a href="#" id="btn_ThisDay" title="当天" class="easyui-linkbutton" data-options="toggle:false,plain:true,iconCls:'icon-calendar_view_day',selected:true"
                                                        onclick="mnuDateTypeClick('1')">1天</a><a href="#" id="btn_3Day" title="最近3天" class="easyui-linkbutton"
                                                            data-options="toggle:false,plain:true,iconCls:'icon-calendar_view_week'" onclick="mnuDateTypeClick('3')">3天</a><a
                                                                href="#" id="btn_7Day" title="最近7天" class="easyui-linkbutton" data-options="toggle:false,plain:true,iconCls:'icon-calendar_view_month'"
                                                                onclick="mnuDateTypeClick('7')"> 7天</a><a href="#" id="btn_30Day" title="最近30天" class="easyui-linkbutton"
                                                                    data-options="toggle:false,plain:true,iconCls:'icon-calendar_view_month'" onclick="mnuDateTypeClick('30')">
                                                                    30天</a>
                                                </td>
                                                <td>
                                                    <a href="#" id="mnu_FindFast" class="easyui-menubutton" data-options="menu:'#mnu_FindFastType',iconCls:'icon-text_padding_left'">
                                                        检验号</a>
                                                </td>
                                                <td>
                                                    <input class="easyui-validatebox" id='txt_FindFast' name="FindFast" style="width: 120px;" />
                                                </td>
                                                <th align="right">
                                                    标本状态：
                                                </th>
                                                <td align="left">
                                                    <select class="easyui-combobox" id="cmb_Stat" name="Stat" panelheight="80px" style="width: 100px;">
                                                        <option value="已接收">已接收</option>
                                                        <option value="未接收">未接收</option>
                                                        <option value="已核收">已核收</option>
                                                        <option value="全部">全部</option>
                                                    </select>
                                                </td>
                                                <th align="right">
                                                    工作小组：
                                                </th>
                                                <td align="left">
                                                    <input name="TestSetWorkGroup" id="cmbTestSetWorkGroup" style="width: 120px;" />
                                                </td>
                                                <td colspan="2" align="left">
                                                    <a href="javascript:void(0)" id="btn_find" class="easyui-linkbutton" icon="icon-search"
                                                        onclick="HisOrderItem();">查询</a><a href="javascript:void(0)" id="btn_Complex" class="easyui-linkbutton"
                                                            icon="icon-anchor">高级查询</a>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div id="div_Complex" style="white-space: nowrap;">
                                        <table width="100%" cellspacing="1" cellpadding="2" border="0" class="form_table">
                                            <tr>
                                                <th align="right">
                                                    开始日期：
                                                </th>
                                                <td align="left">
                                                    <input class="easyui-datebox" name="dtFindSttDate" id="dt_FindSttDate" data-options="formatter:DateFormatter,parser:DateParser"
                                                        style="width: 90px;" />
                                                </td>
                                                <th align="right">
                                                    结束日期：
                                                </th>
                                                <td align="left">
                                                    <input class="easyui-datebox" name="dtFindEndDate" id="dt_FindEndDate" data-options="formatter:DateFormatter,parser:DateParser"
                                                        style="width: 90px;" />
                                                </td>
                                                <th align="right">
                                                    HIS科室：
                                                </th>
                                                <td align="left">
                                                    <select id="cmb_HISDep" class="easyui-combogrid" name="HISDep" style="width: 90px" />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <div region="center">
                                    <table id="HisOrderItemList">
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="mnu_recType" style="width: 80px;">
        <div onclick="mnuRecClick('LabNo','icon-text_padding_left','检验号')" data-options="iconCls:'icon-text_padding_left'">
            检验号
        </div>
        <div onclick="mnuRecClick('RegNo','icon-newspaper','登记号')" data-options="iconCls:'icon-newspaper'">
            登记号
        </div>
        <div onclick="mnuRecClick('CardNo','icon-vcard','卡　号')" data-options="iconCls:'icon-vcard'">
            卡 号
        </div>
    </div>
    <div id="mnu_FindFastType" style="width: 80px;">
        <div onclick="mnuFindFastClick('LabNo','icon-text_padding_left','检验号')" data-options="iconCls:'icon-text_list_numbers'">
            检验号
        </div>
        <div onclick="mnuFindFastClick('RegNo','icon-newspaper','登记号')" data-options="iconCls:'icon-newspaper'">
            登记号
        </div>
        <%--<div onclick="mnuFindFastClick('RecordNo','icon-server','病案号')" data-options="iconCls:'icon-server'">
            病案号</div>--%>
        <div onclick="mnuFindFastClick('Name','icon-status_online','姓　名')" data-options="iconCls:'icon-status_online'">
            姓 名
        </div>
    </div>
    <div id="win_reportTrace" title="标本追踪" style="overflow: hidden;">
    </div>
    <div id="win_BatchDisCard" title="批量取消核收" style="overflow: hidden;">
    </div>
    <div id="divLabInfo" class="easyui-panel" style="position: absolute; width: 360px;
        height: 500px; display: none;">
        <table id="dgLabInfo">
        </table>
    </div>
    <div id="divLabTestSetInfo" class="easyui-panel" style="width: 400px;
        height: 250px; padding: 5px; background: #f4cccc;position: absolute;display: none;" data-options="iconCls:'icon-save',closable:true,collapsible:true,minimizable:true,maximizable:true">
        <table id="dgLabTestSetInfo">
        </table>
    </div>
    <div id="tbWorkList" style="text-align: right">
        <a id="bth_RefreshWorkList" class="easyui-linkbutton" title="确定核收" href="javascript:void(0)"
            data-options="plain:false,iconCls:'icon-accept'" onclick="AcceptChecked();">确认</a>&nbsp&nbsp<a
                id="A1" class="easyui-linkbutton" title="取消" href="javascript:void(0)" data-options="plain:false,iconCls:'icon-cancel'"
                onclick="CancelChecked();">取消</a>
    </div>
</body>
</html>
