/*
Creator:石萧伟
CreatDate:2017-03-07
Description:知识审核
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBKnoManage&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBKnoManage";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKnoManage&pClassMethod=DeleteData";
var DELETE_FILE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPUploadFile&pClassMethod=DeleteFile";

var init = function () {

    var columns = [[
        {
            field: 'MKBKMFlag', width: 100, title: '审核状态',
            formatter: function (value, row, index) {
                if (value == 'N')  //审核未通过
                {
                    return "<img  src='../scripts/bdp/Framework/icons/mkb/check-notthrough.png' style='border: 0px'><span>"
                }
                else if (value == 'Y') //审核通过
                {
                    return "<img src='../scripts/bdp/Framework/icons/mkb/check-through.png' style='border: 0px'><span>";
                }
                else {
                    return ""; //未审核
                }
            }
        },
        { field: 'MKBKMCode', title: '代码', hidden: true, sortable: true, width: 100 },
        {
            field: 'MKBKMDesc', title: '名称', width: 100, sortable: true,
            formatter: function (value, row, index) {
                var content = '<span href="#" title="' + value + '" class="hisui-tooltip">' + value + '</span>';
                return content;
            }
        },
        { field: 'SSUSRName', title: '上传人', sortable: true, width: 100 },
        { field: 'MKBKMUpdateDate', title: '上传时间', sortable: true, width: 100 },
        {
            field: 'MKBKMNote', title: '备注', width: 100, sortable: true,
            formatter: function (value, row, index) {
                var content = '<span href="#" title="' + value + '" class="hisui-tooltip">' + value + '</span>';
                return content;
            }
        },
        { field: 'MKBKMUpdateLoc', title: '科室', sortable: true, width: 100 },
        { field: 'MKBKMTerm', title: '知识', sortable: true, width: 100 },
        { field: 'MKBKMPro', title: '属性', sortable: true, width: 100 },
        { field: 'MKBKMTermDr', title: '知识id', sortable: true, width: 100, hidden: true },
        { field: 'MKBKMProDr', title: '属性id', sortable: true, width: 100, hidden: true },
        { field: 'MKBKMDetailo', title: '属性内容id', sortable: true, width: 100, hidden: true },
        {
            field: 'MKBKMDetail', title: '属性内容', width: 100, sortable: true,
            formatter: function (value, row, index) {
                var content = '<span href="#" title="' + value + '" class="hisui-tooltip">' + value + '</span>';
                return content;
            }
        },
        //{field:'MKBKMUpdateUser',title:'上传人id',hidden:true,sortable:true,width:100},
        /*{field:'MKBKMType',title:'类型',hidden:true,width:100,sortable:true,
                  formatter: function(value,row,index){
                      if(value=='D')  //初传
                      {
                          return "doc"
                      }
                      else if(value=='P') //审核不通过
                      {
                          return "pdf";
                      }
                      else if(value=="E")
                      {
                          return "excel"; //审核通过
                      }
                  }
        },*/
        { field: 'MKBKMPath', title: '路径', hidden: true, sortable: true, width: 100 },
        { field: 'MKBKMSource', title: '出处', hidden: true, sortable: true, width: 100 },
        { field: 'MKBKMRowId', title: 'RowId', hidden: true, sortable: true, width: 100 },
        {
            field: 'MKBKMMiniFlag', title: '上报来源', sortable: true, width: 100,
            formatter: function (value, row, index) {
                if (value == "M") {
                    return "微信小程序";
                } else {
                    return "浏览器";
                }

            }

        },
        { field: 'MKBKMFailureReason', title: '未通过原因', sortable: true, width: 100 }

    ]];
    var mygrid = $HUI.datagrid("#mygrid", {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCBL.MKB.MKBKnoManage",
            QueryName: "GetList"
        },
        columns: columns,  //列信息
        //frozenColumns:[[{field:'MKBKMDesc',title:'名称'}]],
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize: PageSizeMain,
        pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500, 1000],
        singleSelect: true,
        idField: 'MKBKMRowId',
        ClassTableName: 'User.MKBKnoManage',
        SQLTableName: 'MKB_KnoManage',
        rownumbers: true,    //设置为 true，则显示带有行号的列。
        fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        //scrollbarSize :15,
        remoteSort: false,
        //sortName:'MKBKMRowId',
        //sortOrder:'desc',
        onClickRow: function (index, row) {
            RefreshSearchData("User.MKBKnoManage", row.MKBKMRowId, "A", row.MKBKMDesc);
            var record = mygrid.getSelected();
            if (record) {
                var fileType = (record.MKBKMPath).split(".")[(record.MKBKMPath).split(".").length - 1];
                var PDFisExists = tkMakeServerCall("web.DHCBL.BDP.BDPUploadFile", "IsExistsFile", "scripts\\bdp\\MKB\\Doc\\Kno\\" + (record.MKBKMPath).replace(fileType, "pdf"));
                if (PDFisExists == 1) {
                    $("#pre_btn").linkbutton('enable');
                }
                else {
                    $("#pre_btn").linkbutton('disable');
                }
            }
        },
        onLoadSuccess: function (data) {
            $(this).datagrid('columnMoving');
        }
    });
    //主页面工具栏
    $('#yes_btn').click(function (e) {
        reviewDataY();
    });
    $('#no_btn').click(function (e) {
        reviewDataN();
    });
    $('#pre_btn').click(function (e) {
        previewFile();
    });
    $('#del_btn').click(function (e) {
        RemoveText();
    });
    //单独给上传按钮引用样式，为了不和class冲突
    $('#onload_btn').click(function (e) {
        DownLoadFile();
    });
    //查询按钮
    /*$("#TextDesc").searchbox({
        searcher:function(value,name){
            SearchFunLib();
        }
    })*/
    $('#TextDesc').searchcombobox({
        url: $URL + "?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename=User.MKBKnoManage",
        onSelect: function () {
            $(this).combobox('textbox').focus();
            SearchFunLib()

        }
    });
    $('#TextDesc').combobox('textbox').bind('keyup', function (e) {
        if (e.keyCode == 13) {
            SearchFunLib();
        }
    });
    $("#btnSearch").click(function (e) {
        SearchFunLib();
    })
    //重置按钮
    $("#btnRefresh").click(function (e) {
        ClearFunLib();
    })
    //查询方法
    function SearchFunLib() {
        var desc = $("#TextDesc").combobox('getText');
        $('#mygrid').datagrid('load', {
            ClassName: "web.DHCBL.MKB.MKBKnoManage",
            QueryName: "GetList",
            'desc': desc
        });

    }
    //重置方法
    function ClearFunLib() {
        $("#TextDesc").combobox('setValue', '');
        $('#mygrid').datagrid('load', {
            ClassName: "web.DHCBL.MKB.MKBKnoManage",
            QueryName: "GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    }

    //通过审核按钮
    function reviewDataY() {
        var record = mygrid.getSelected();
        if (record) {
            var flag = record.MKBKMFlag;
            if (flag != "" && flag != "F") {
                $.messager.popover({ msg: '已通过审核，不能再审核！', type: 'alert' });
            }
            else {
                $("#MKBKMFlag").val("Y");
                $('#form-save').form('submit', {
                    url: SAVE_ACTION_URL,
                    onSubmit: function (param) {
                        param.MKBKMRowId = record.MKBKMRowId;
                    },
                    success: function (data) {
                        var data = eval('(' + data + ')');
                        if (data.success == 'true') {
                            $.messager.popover({ msg: '审核成功！', type: 'success', timeout: 1000 });
                            $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                        }
                        else {
                            var errorMsg = "审核失败！"
                            if (data.errorinfo) {
                                errorMsg = errorMsg + '<br/>错误信息:' + data.errorinfo
                            }
                            $.messager.alert('操作提示', errorMsg, "error");
                        }
                    }
                });
            }
        }
        else {
            $.messager.popover({ msg: '请选择需要审核的数据！', type: 'info', timeout: 2000, showType: 'show' });
        }
    }
    //审核未通过按钮
    function reviewDataN() {
        var record = mygrid.getSelected();
        if (record) {
            var flag = record.MKBKMFlag;
            if (flag != "" & flag != "F") {
                $.messager.popover({ msg: '已通过审核，不能再审核！', type: 'alert' });
            }
            else {
              //填写未通过理由
              $('#MKBKMFailureReason').val('');
              $("#failurereason_win").show();
              var myWin = $HUI.dialog("#failurereason_win", {
                  iconCls: 'icon-w-edit',
                  resizable: true,
                  title: '未通过原因',
                  modal: true,
                  buttonAlign: 'center',
                  buttons: [{
                      text: '保存',
                      id: 'reasonsave_btn',
                      handler: function () {
                          SaveReason()
                      }
                  }, {
                      text: '关闭',
                      handler: function () {
                          myWin.close();
                      }
                  }]
              });
            }
        }
        else {
            $.messager.popover({ msg: '请选择需要审核的数据！', type: 'info', timeout: 2000, showType: 'show' });
        }
    }

    function SaveReason() {
        var record = $('#mygrid').datagrid('getSelected');

        if (record) {
            var reason = $('#MKBKMFailureReason').val();
            if(reason == ""){
                $.messager.alert('错误提示','理由不能为空!',"error");
                return;               
            }

            var id = record.MKBKMRowId;

            var result = tkMakeServerCall("web.DHCBL.MKB.MKBKnoManage", "SaveFailureReason", id, reason);
            var data = eval('(' + result + ')');
            if (data.success == 'true') {
                //$.messager.popover({ msg: '保存成功!', type: 'success', timeout: 1000 });
                $('#failurereason_win').dialog('close'); // close a dialog
                $('#mygrid').datagrid('reload');  // 重新载入当前页面数据
                $("#MKBKMFlag").val("N");               
                        $('#form-save').form('submit', {
                            url: SAVE_ACTION_URL,
                            onSubmit: function (param) {
                                param.MKBKMRowId = record.MKBKMRowId;
                            },
                            success: function (data) {
                                var data = eval('(' + data + ')');
                                if (data.success == 'true') {
                                    $.messager.popover({ msg: '审核成功！', type: 'success', timeout: 1000 });                          
                                    //$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                                }
                                else {
                                    var errorMsg = "审核失败！"
                                    if (data.errorinfo) {
                                        errorMsg = errorMsg + '<br/>错误信息:' + data.errorinfo
                                    }
                                    $.messager.alert('操作提示', errorMsg, "error");
                                }
                            }
                        });
            } else {
                var errorMsg = "更新失败！"
                if (data.errorinfo) {
                    errorMsg = errorMsg + '<br/>错误信息:' + data.errorinfo
                }
                $.messager.alert('操作提示', errorMsg, "error");

            }
        }
    }

    //点击下载按钮
    function DownLoadFile() {
        var record = mygrid.getSelected();
        if (record) {
            $(".load").attr("href", "#");
            $(".load").removeAttr("download");
            $(".load").removeAttr("target");
            var fileName = record.MKBKMPath;
            var isExists = tkMakeServerCall("web.DHCBL.BDP.BDPUploadFile", "IsExistsFile", "scripts\\bdp\\MKB\\Doc\\Kno\\" + fileName);
            var filepath = "../scripts/bdp/MKB/Doc/Kno/" + fileName;
            if (isExists == 1 && fileName != "") {
                $(".load").attr("href", filepath);
                $(".load").attr("download", fileName);
                //判断浏览器是否支持a标签 download属性
                var isSupportDownload = 'download' in document.createElement('a');
                //alert(isSupportDownload );
                if (!isSupportDownload) {
                    var fileType = fileName.split(".")[fileName.split(".").length - 1];
                    if ((fileType != "pdf") && (fileType != "PDF")) {
                        objIframe = document.createElement("IFRAME");
                        document.body.insertBefore(objIframe);
                        objIframe.outerHTML = "<iframe   name=a1   style='width:0;hieght:0'   src=" + $(".load").attr("href") + "></iframe>";
                        pic = window.open($(".load").attr("href"), "a1");
                        document.all.a1.removeNode(true)
                    } else {
                        alert("此浏览器使用另存下载");
                        $(".load").attr("target", "_blank");
                    }
                }
            }
            else {
                var url = window.location.href.split('csp')[0]
                url = url + "scripts/bdp/MKB/Doc/Kno/" + fileName
                //ajax检测文件是否存在
                // $.ajax({
                //     url: url,
                //     type: "get",
                //     async: false,
                //     success: function () {
                //存在直接下载pdf以外的文件
                if (fileName.split('.')[1] != "pdf") {
                    $(".load").attr("href", url);
                } else {
                    //如果是pdf则打开浏览器窗口预览保存文件
                    window.open(url);     //在同当前窗口中打开窗口
                }


                //     },
                //     statusCode: {
                //         404: function () {
                //             $.messager.popover({ msg: '该文件不存在！', type: 'alert' });
                //         }
                //     }
                // });
            }
        }
        else {
            $.messager.alert('错误提示', '请先选择一条记录!', "error");
        }
    }
    //点击预览按钮
    function previewFile() {
        var record = mygrid.getSelected();
        if (record) {
            var fileType = (record.MKBKMPath).split(".")[(record.MKBKMPath).split(".").length - 1];
            var PDFisExists = tkMakeServerCall("web.DHCBL.BDP.BDPUploadFile", "IsExistsFile", "scripts\\bdp\\MKB\\Doc\\Kno\\" + (record.MKBKMPath).replace(fileType, "pdf"));
            if (PDFisExists == 1) {
                fileName = record.MKBKMPath;
                var filepath = "../scripts/bdp/MKB/Doc/Kno/" + fileName.replace(fileType, "pdf");
                var previewWin = $("#win").window({
                    width: 850,
                    height: 550,
                    modal: true,
                    title: fileName

                });
                $('#win').html('<object id="PDFViewObject" type="application/pdf" width="100%" height="100%" data=' + filepath + ' style="display:block"> <div id="PDFNotKnown">你需要先安装pdf阅读器才能正常浏览文件，请点击<a href="http://get.adobe.com/cn/reader/download/?installer=reader_11.0_chinese_simplified_for_windows" target="_blank">这里</a>下载.</div> </object>');
                previewWin.show();
            }
            else {
                /* $.messager.show
                 ({ 
                     title: '提示消息', 
                     msg: '不存在pdf预览文件！', 
                     showType: 'show', 
                     timeout: 1000, 
                     style: { 
                     right: '', 
                     bottom: ''
                     } 
                });*/
                $.messager.popover({ msg: '不存在pdf预览文件！', type: 'info', timeout: 2000, showType: 'show' });
            }
        }
        else {
            $.messager.alert('错误提示', '请先选择一条记录!', "error");
        }
    }
    //移除数据
    function RemoveText() {
        //更新
        var row = $("#mygrid").datagrid("getSelected");
        if (!(row)) {
            $.messager.alert('错误提示', '请先选择一条记录!', "error");
            return;
        }
        var rowid = row.MKBKMRowId;
        var path = "scripts\\bdp\\MKB\\Doc\\Kno\\" + row.MKBKMPath;
        var fileType = row.MKBKMPath.split(".")[(row.MKBKMPath).split(".").length - 1];
        var pdfpath = "scripts\\bdp\\MKB\\Doc\\Kno\\" + (row.MKBKMPath).replace(fileType, "pdf");
        $.messager.confirm('提示', '确定要删除所选的文件数据吗?', function (r) {
            if (r) {
                $.ajax({
                    url: DELETE_FILE_URL,
                    data: { "filePath": path },
                    type: "POST"
                });
                $.ajax({
                    url: DELETE_FILE_URL,
                    data: { "filePath": pdfpath },
                    type: "POST"
                });
                $.ajax({
                    url: DELETE_ACTION_URL,
                    data: { "id": rowid },
                    type: "POST",
                    success: function (data) {
                        var data = eval('(' + data + ')');
                        if (data.success == 'true') {
                            /*$.messager.show({ 
                              title: '提示消息', 
                              msg: '删除文件成功', 
                              showType: 'show', 
                              timeout: 1000, 
                              style: { 
                                right: '', 
                                bottom: ''
                              } 
                            }); */
                            $.messager.popover({ msg: '删除文件成功！', type: 'success', timeout: 1000 });
                            $('#mygrid').datagrid('reload');  // 重新载入当前页面数据
                            $('#mygrid').datagrid('unselectAll');  // 清空列表选中数据  
                        }
                        else {
                            var errorMsg = "删除文件失败！"
                            if (data.info) {
                                errorMsg = errorMsg + '<br/>错误信息:' + data.info
                            }
                            $.messager.alert('操作提示', errorMsg, "error");

                        }
                    }
                })
            }
        });
    }

    $('#btnTerm').click(function () {
        var data = $('#mygrid').datagrid('getSelected');
        var termid = data.MKBKMTermDr
        var proid = data.MKBKMProDr
        if (data.MKBKMDetailo.indexOf("^") > -1) {
            var detailid = data.MKBKMDetailo.split("^")[0]
        } else {
            var detailid = data.MKBKMDetailo
        }

        var menuid = tkMakeServerCall("web.DHCBL.BDP.BDPMenu", "GetID", "dhc.bdp.mkb.mtm.Diagnosis");
        var parentid = "" //tkMakeServerCall("web.DHCBL.MKB.Menu","GetID","dhc.bdp.mkb.mtm");
        var menuimg = "" //tkMakeServerCall("web.DHCBL.MKB.Menu","GetIconByID",menuid);
        //判断浏览器版本
        var Sys = {};
        var ua = navigator.userAgent.toLowerCase();
        var s;
        (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
            (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
                (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
                    (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
                        (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
        //双击时跳转到对应界面
        //if(!Sys.ie){
        window.parent.closeNavTab(menuid)
        // if(isTOrP=="P"){
       // window.parent.showNavTab(menuid, "临床实用诊断", 'dhc.bdp.cdss.sys.csp?BDPMENU=' + menuid + "&TermID=" + termid + "&ProId=" + proid + "&detailId=" + detailid, parentid, menuimg)
        window.parent.showNavTab(menuid, "临床实用诊断", 'dhc.bdp.ext.sys.csp?BDPMENU=' + menuid + "&TermID=" + termid + "&ProId=" + proid + "&detailId=" + detailid, parentid, menuimg)
        
        // }else{
        //     var termmenuid=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetMenuId",childDesc); 
        //     window.parent.showNavTab(menuid,"临床实用诊断",'dhc.bdp.cdss.sys.csp?BDPMENU='+termmenuid+"&TermID="+termid+"&ProId=",parentid,menuimg)
        // }

    });

    //拖拽和右键列
    ShowUserHabit('mygrid');

}
$(init);