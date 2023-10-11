/*
Creator:石萧伟
CreatDate:2017-03-15
Description:文献管理
*/
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBDocManage&pClassMethod=DeleteData";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBDocManage&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBDocManage";
var DELETE_FILE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPUploadFile&pClassMethod=DeleteFile";
var PREVIEW_FILE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.TKBKnoManage&pClassMethod=Webservice";

//添加右键股则管理菜单
var termBase = "D"
var rightMenuInfos = tkMakeServerCall('web.DHCBL.MKB.MKBKLMappingDetail', 'CreateRightMenu', termBase);
var menuStr = ""
if (rightMenuInfos != "") {
    var rightMenuInfo = rightMenuInfos.split("[A]")
    for (var i = 0; i < rightMenuInfo.length; i++) {
        var rightMenu = rightMenuInfo[i];  //右键菜单
        var rightMenu = eval('(' + rightMenu + ')');
        menuStr = menuStr + '<div id=' + rightMenu.MKBKMBRowId + ' name="规则管理" iconCls="icon-set-paper" data-options="">' + rightMenu.MKBKMBDesc + '</div>'
    }
}

//界面初始化
var init = function () {
    var columns = [[
        { field: 'MKBDMCode', title: '代码', hidden: true, width: 100 },
        {
            field: 'MKBDMDesc', title: '文献名称', sortable: true, width: 180,
            formatter: function (value, row, index) {
                var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
                return content;
            }
        },
        { field: 'MKBDMKeyWord', title: '关键词', sortable: true, width: 100 },
        { field: 'MKBDMSource', title: '出处', sortable: true, width: 100 },
        { field: 'SSUSRName', title: '上传人', sortable: true, width: 100 },
        { field: 'MKBDMUpdateDate', title: '上传时间', sortable: true, width: 100 },
        { field: 'MKBDMClassify', title: '文献分类', sortable: true, width: 100 },
        {
            field: 'MKBDMFlag', title: '审核状态', width: 100, sortable: true,
            formatter: function (value, row, index) {
                if (value == 'F')  //初传
                {
                    return "初传"
                }
                else if (value == 'N') //审核不通过
                {
                    return "审核不通过";
                }
                else if (value == "Y") {
                    return "审核通过"; //审核通过
                }
            }
        },
        {
            field: 'MKBDMNote', title: '备注', width: 100, sortable: true,
            formatter: function (value, row, index) {
                var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
                return content;
            }
        },
        { field: 'MKBDMUpdateUsere', title: '上传人ID', hidden: true, width: 100 },
        /*{field:'MKBDMType',title:'类型',width:100,hidden:true,
            formatter: function(value,row,index){
                if(value=='D')  
                {
                    return "doc"
                }
                else if(value=='P') 
                {
                    return "pdf";
                }
                else if(value=="E")
                {
                    return "excel"; 
                }
            }

        },*/
        { field: 'MKBDMPath', title: '路径', hidden: true, width: 100 },
        { field: 'MKBDMRowId', title: 'RowId', hidden: true, width: 100 }
    ]];
    var mygrid = $HUI.datagrid("#mygrid", {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCBL.MKB.MKBDocManage",
            QueryName: "GetList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize: PageSizeMain,
        pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500, 1000],
        singleSelect: true,
        remoteSort: false,
        ClassTableName: 'User.MKBDocManage',
        SQLTableName: 'MKB_DocManage',
        idField: 'MKBDMRowId',
        rownumbers: true,    //设置为 true，则显示带有行号的列。
        fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        //scrollbarSize :0,
        //        onDblClickRow:function(index,row)
        //        {
        //        },
        onClickRow: function (index, row) {
            RefreshSearchData("User.MKBDocManage", row.MKBDMRowId, "A", row.MKBDMDesc);
            ClickMyGrid();
        },
        //        onAfterEdit:function(index, row, changes){
        //            editrow(row);
        //            },
        onLoadSuccess: function (data) {
            $(this).prev().find('div.datagrid-body').prop('scrollTop', 0);
            $(this).datagrid('columnMoving');

            $('.mytooltip').tooltip({
                trackMouse: true,
                onShow: function (e) {
                    $(this).tooltip('tip').css({
                        width: 250, top: e.pageY + 20, left: e.pageX - (250 / 2)
                    });
                }

            });
        },
        onRowContextMenu: function (e, rowIndex, rowData) {   //右键菜单
            var $clicked = $(e.target);
            e.preventDefault();  //阻止浏览器捕获右键事件
            $(this).datagrid("selectRow", rowIndex); //根据索引选中该行  

            if (menuStr != "") {
                var mygridmm = $('<div style="width:140px;"></div>').appendTo('body');
                //$( menuStr).appendTo(mygridmm).click(stopPropagation);
                mygridmm.html(menuStr).click(stopPropagation);
                //mygridmm.menu()
                mygridmm.menu({
                    onClick: function (item) {
                        var itemid = item.id
                        if ((item.name == "规则管理") & (itemid != "") & (itemid != null) & (itemid != undefined)) {
                            //var newOpenUrl="../csp/dhc.bdp.mkb.mkbklmappingdetail.csp?mappingBase="+itemid+"&termBase="+termBase+"&termRowId="+rowData.MKBDMRowId
                            //window.open(newOpenUrl, 'newwindow', 'height=400, width=800, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no')		
                            var url="../csp/dhc.bdp.mkb.mkbklmappingdetail.csp?mappingBase=" + itemid + "&termBase=" + termBase + "&termRowId=" + rowData.MKBDMRowId
                            if ('undefined'!==typeof websys_getMWToken){
                                url += "&MWToken="+websys_getMWToken()
                            }
                            var mappingWin = $("#win").window({
                                width: 850,
                                height: 550,
                                modal: true,
                                title: item.text,
                                content: '<iframe frameborder="0" src="'+url+'" width="100%" height="99%" ></iframe>'
                            });

                            mappingWin.show();
                        }
                    }
                });
                mygridmm.menu('show', {
                    left: e.pageX,
                    top: e.pageY
                });
            }
        }

    });
    //启用预览按钮
    function ClickMyGrid() {
        var record = $("#mygrid").datagrid("getSelected");
        if (record) {
            var fileType = (record.MKBDMPath).split(".")[(record.MKBDMPath).split(".").length - 1];
            var PDFisExists = tkMakeServerCall("web.DHCBL.BDP.BDPUploadFile", "IsExistsFile", "scripts\\bdp\\MKB\\Doc\\Doc\\" + (record.MKBDMPath).replace(fileType, "pdf"));
            if (PDFisExists == 1) {
                $("#pre_btn").linkbutton('enable');
            }
            else {
                $("#pre_btn").linkbutton('disable');
            }

        }

    }
    //主页面工具栏
    $('#add_btn').click(function (e) {
        AddData();
    });
    $('#update_btn').click(function (e) {
        UpdateData();
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
    //审核下拉框
    var modeCmb = $HUI.combobox("#MKBDMFlag", {
        valueField: 'id',
        textField: 'text',
        data: [
            { id: 'F', text: '初传' },
            { id: 'Y', text: '审核通过' },
            { id: 'N', text: '审核未通过' }
        ],
        panelHeight: 100
    });
    //查询按钮
    /*$("#TextDesc").searchbox({
        searcher:function(value,name){
            SearchFunLib();
        }
    })*/
    $('#TextDesc').searchcombobox({
        url: $URL + "?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename=User.MKBDocManage",
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
    //查询方法
    function SearchFunLib() {
        var desc = $("#TextDesc").combobox('getText');
        $('#mygrid').datagrid('load', {
            ClassName: "web.DHCBL.MKB.MKBDocManage",
            QueryName: "GetList",
            'desc': desc
        });

    }
    //重置按钮
    $("#btnRefresh").click(function (e) {
        ClearFunLib();
    })
    //重置方法
    function ClearFunLib() {
        $("#TextDesc").combobox('setValue', '');
        $('#mygrid').datagrid('load', {
            ClassName: "web.DHCBL.MKB.MKBDocManage",
            QueryName: "GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    }
    //点击上传按钮
    function AddData() {
        $("#myWin").show();
        $("#for_updata").show();
        setTimeout(function () {
            $('#MKBDMDesc').focus();
        }, 200)
        $('#upload').show();//防止修改时将上传隐藏
        $('#txtchooses').show();
        var myWin = $HUI.dialog("#myWin", {
            iconCls: 'icon-w-upload',
            resizable: true,
            title: '上传文献',
            modal: true,
            buttonAlign: 'center',
            buttons: [{
                text: '保存',
                id: 'save_btn',
                handler: function () {
                    SaveFunLib("")
                }
            }, {
                text: '关闭',
                handler: function () {
                    myWin.close();
                }
            }]
        });
        $('#form-save').form("clear");
        //字动生成文献的code，默认只读不可修改
        $.m({
            ClassName: "web.DHCBL.MKB.MKBDocManage",
            MethodName: "GetLastCode"
        }, function (txtData) {
            $('#MKBDMCode').val(txtData);
        });
        //审核状态默认初传
        var per = "F";
        $('#MKBDMFlag').combobox('setValue', per);
    }
    //点击下载按钮
    function DownLoadFile() {
        //alert(document.getElementById("onload_btn").className);
        var record = mygrid.getSelected();
        if (record) {
            $(".load").attr("href", "#");
            $(".load").removeAttr("download");
            $(".load").removeAttr("target");
            var fileName = record.MKBDMPath;
            var isExists = tkMakeServerCall("web.DHCBL.BDP.BDPUploadFile", "IsExistsFile", "scripts\\bdp\\MKB\\Doc\\Doc\\" + fileName);
            filepath = "../scripts/bdp/MKB/Doc/Doc/" + fileName;
            if (isExists == 1) {
                $(".load").attr("href", filepath);
                $(".load").attr("download", fileName);
                //var filepath = "../scripts/bdp/Framework/NDoc/"+fileName;
                //window.open(filepath,"_self");
                //判断浏览器是否支持a标签 download属性
                var isSupportDownload = 'download' in document.createElement('a');
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
                url = url + "scripts/bdp/MKB/Doc/Doc/" + fileName
                // //ajax检测文件是否存在
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


                    // },
                    // statusCode: {
                    //     404: function () {
                    //         $.messager.popover({ msg: '该文件不存在！', type: 'alert' });
                    //     }
                    // }
                //});
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
            var fileType = (record.MKBDMPath).split(".")[(record.MKBDMPath).split(".").length - 1];
            var PDFisExists = tkMakeServerCall("web.DHCBL.BDP.BDPUploadFile", "IsExistsFile", "scripts\\bdp\\MKB\\Doc\\Doc\\" + (record.MKBDMPath).replace(fileType, "pdf"));
            if (PDFisExists == 1) {
                fileName = record.MKBDMPath;
                var filepath = "../scripts/bdp/MKB/Doc/Doc/" + fileName.replace(fileType, "pdf");
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
                /*$.messager.show
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
                $.messager.popover({ msg: '不存在pdf预览文件！', type: 'alert' });
            }
        }
        else {
            $.messager.alert('错误提示', '请先选择一条记录!', "error");
        }
    }
    //点击修改按钮
    function UpdateData() {
        //隐藏上传文件表单
        //$('#upload').hide();
        //$('#txtchooses').hide();
        //$('#upload').show();//防止修改时将上传隐藏
        $("#for_updata").hide();
        $('#txtchooses').show();
        var record = mygrid.getSelected();
        if (record) {
            //调用后台openData方法给表单赋值
            var id = record.MKBDMRowId;
            $.cm({
                ClassName: "web.DHCBL.MKB.MKBDocManage",
                MethodName: "OpenData",
                RowId: id
            }, function (jsonData) {
                $('#form-save').form("load", jsonData);
                $('#MKBDMCode').val(jsonData.MKBDMCode);
                $('#MKBDMExpression').val(jsonData.MKBDMExpression);
                $('#MKBDMKeyWord').val(jsonData.MKBDMKeyWord);
            });
            $("#myWin").show();
            setTimeout(function () {
                $('#MKBDMDesc').focus();
            }, 200)
            var myWin = $HUI.dialog("#myWin", {
                iconCls: 'icon-updatelittle',
                resizable: true,
                title: '修改',
                modal: true,
                buttons: [{
                    text: '保存',
                    id: 'save_btn',
                    handler: function () { SaveFunLib(id) }
                }, {
                    text: '关闭',
                    handler: function () {
                        myWin.close();
                    }
                }]
            });

        } else {
            $.messager.alert('错误提示', '请先选择一条记录!', "error");
        }

    }
    ///新增、更新
    function SaveFunLib(id) {
        var code = $.trim($("#MKBDMCode").val());
        var desc = $.trim($("#MKBDMDesc").val());
        var path = $.trim($("#MKBDMPath").val());
        if (code == "") {
            $.messager.alert('错误提示', '代码不能为空!', "error");
            return;
        }
        if (desc == "") {
            $.messager.alert('错误提示', '名称不能为空!', "error");
            return;
        }
        if (path == "") {
            $.messager.alert('错误提示', '请先上传文件!', "error");
            return;
        }
        $('#form-save').form('submit', {
            url: SAVE_ACTION_URL,
            onSubmit: function (param) {
                param.MKBDMRowId = id;
            },
            success: function (data) {
                var data = eval('(' + data + ')');
                if (data.success == 'true') {
                    var titleF = $('#myWin').panel('options').title;
                    /*if(titleF=="上传文献")
                    {
                        var fileName=$('#MKBDMPath').val();
                        var pp = fileName.split(".")[fileName.split(".").length-1];
                        if((pp=="doc")||(pp=="docx")||(pp=="xls")||(pp=="xlsx"))
                        {
                            $.ajax({
                                url : PREVIEW_FILE_URL,
                                method : 'POST',
                                data : {
                                    path: "D:\\DTHealth\\app\\dthis\\web\\scripts\\bdp\\MKB\\Doc\\Doc\\"+fileName
                                },
                                success: function(){
                                    $.messager.popover({msg: '预览文件生成成功！',type:'success',timeout: 1000});
                                }
                            });
                        }
                    }*/
                    $.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
                    $('#mygrid').datagrid('reload');  // 重新载入当前页面数据
                    $('#myWin').dialog('close'); // close a dialog
                }
                else {
                    var errorMsg = "更新失败！"
                    if (data.errorinfo) {
                        errorMsg = errorMsg + '<br/>错误信息:' + data.errorinfo
                    }
                    $.messager.alert('操作提示', errorMsg, "error");

                }

            }
        });
    }
    //移除数据
    function RemoveText() {
        //更新
        var row = $("#mygrid").datagrid("getSelected");
        if (!(row)) {
            $.messager.alert('错误提示', '请先选择一条记录!', "error");
            return;
        }
        var rowid = row.MKBDMRowId;
        var eastid = row.MKBDRRowId;
        //alert(eastid);
        var path = "scripts\\bdp\\MKB\\Doc\\Doc\\" + row.MKBDMPath;
        var fileType = row.MKBDMPath.split(".")[(row.MKBDMPath).split(".").length - 1];
        var pdfpath = "scripts\\bdp\\MKB\\Doc\\Doc\\" + (row.MKBDMPath).replace(fileType, "pdf");
        $.messager.confirm('提示', '确定要删除所选的文件数据吗?', function (r) {
            if (r) {
                //删除非pdf文件
                $.ajax({
                    url: DELETE_FILE_URL,
                    data: { "filePath": path },
                    type: "POST"
                });
                //删除pdf文件
                $.ajax({
                    url: DELETE_FILE_URL,
                    data: { "filePath": pdfpath },
                    type: "POST"
                });
                //删除文献数据
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
                            });*/
                            $.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
                            $('#mygrid').datagrid('load', {
                                ClassName: "web.DHCBL.MKB.MKBDocManage",
                                QueryName: "GetList"
                            });
                            // 重新载入当前页面数据
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
    ///disable和enable覆盖重写
    /**
     * linkbutton方法扩展
     * @param {Object} jq
	
    $.extend($.fn.linkbutton.methods, {
        enable: function(jq){
            return jq.each(function(){
                var state = $.data(this, 'linkbutton');
                if ($(this).hasClass('l-btn-disabled')) {
                    var itemData = state._eventsStore;
                    //恢复超链接
                    if (itemData.href) {
                        $(this).attr("href", itemData.href);
                    }
                    //回复点击事件
                    if (itemData.onclicks) {
                        for (var j = 0; j < itemData.onclicks.length; j++) {
                            $(this).bind('click', itemData.onclicks[j]);
                        }
                    }
                    //设置target为null，清空存储的事件处理程序
                    itemData.target = null;
                    itemData.onclicks = [];
                    $(this).removeClass('l-btn-disabled');
                }
            });
        },
        /**
         * 禁用选项（覆盖重写）
         * @param {Object} jq
         
        disable: function(jq){
            return jq.each(function(){
                var state = $.data(this, 'linkbutton');
                if (!state._eventsStore)
                    state._eventsStore = {};
                if (!$(this).hasClass('l-btn-disabled')) {
                    var eventsStore = {};
                    eventsStore.target = this;
                    eventsStore.onclicks = [];
                    //处理超链接
                    var strHref = $(this).attr("href");
                    if (strHref) {
                        eventsStore.href = strHref;
                        $(this).attr("href", "javascript:void(0)");
                    }
                    //处理直接耦合绑定到onclick属性上的事件
                    var onclickStr = $(this).attr("onclick");
                    if (onclickStr && onclickStr != "") {
                        eventsStore.onclicks[eventsStore.onclicks.length] = new Function(onclickStr);
                        $(this).attr("onclick", "");
                    }
                    //处理使用jquery绑定的事件
                    var eventDatas = $(this).data("events") || $._data(this, 'events');
                    if (eventDatas["click"]) {
                        var eventData = eventDatas["click"];
                        for (var i = 0; i < eventData.length; i++) {
                            if (eventData[i].namespace != "menu") {
                                eventsStore.onclicks[eventsStore.onclicks.length] = eventData[i]["handler"];
                                $(this).unbind('click', eventData[i]["handler"]);
                                i--;
                            }
                        }
                    }
                    state._eventsStore = eventsStore;
                    $(this).addClass('l-btn-disabled');
                }
            });
        }
    });*/
    //拖拽和右键菜单
    ShowUserHabit('mygrid');
    //$('#mygrid').datagrid('columnMoving');
    //HISUI_Funlib_Sort('mygrid');  ///放在columnMoving后面才能显示？？
    //HISUI_Funlib_Translation('mygrid');
    //HISUI_Funlib_Sort('mygrid');
    //var DisableArray=[];
    //DisableArray["del_btn"]='N';
    //DisableArray["update_btn"]='N';
    //DisableFlag(DisableArray);
    //KeyMap(disablebtnflag);

    /********************************************导出左侧列表的数据************************************************************* */
    //导出实际匹配结果按钮

    $('#onloaddata_btn').click(function (e) {

        $.cm({
            ClassName: "web.DHCBL.MKB.MKBDocManage",
            QueryName: "GetList",
            page: 1,
            rows: 1000000000
        }, function (jsonData) {
            var data = jsonData.rows
            str = "<tr><td>ID</td><td>文献名称</td><td>关键词</td><td>出处</td></tr>";
            for (var i = 0; i < data.length; i++) {
                str = str + "<tr><td>" + data[i].MKBDMRowId + "</td><td>" + data[i].MKBDMDesc + "</td><td>" + data[i].MKBDMKeyWord + "</td><td>" + data[i].MKBDMSource + "</td></tr>"
            }

            document.getElementById("table1").innerHTML = str;
            excel = new ExcelGen({
                "src_id": "table1",
                "show_header": true,
                fileName:'文献管理数据'
            });
            excel.generate();
        })



    })
    /**
     * shixiaowei
     * js-xlsx插件解决linux后台无法生成导出文件，支持谷歌
     */
    function loadTableDataNew(aoa) {
        var sheet = XLSX.utils.aoa_to_sheet(aoa);
        openDownloadDialog(sheet2blob(sheet), '文献管理列表.xlsx');

    }
    // 将一个sheet转成最终的excel文件的blob对象，然后利用URL.createObjectURL下载
    function sheet2blob(sheet, sheetName) {
        sheetName = sheetName || 'sheet1';
        var workbook = {
            SheetNames: [sheetName],
            Sheets: {}
            
        };
        workbook.Sheets[sheetName] = sheet; // 生成excel的配置项

        var wopts = {
            bookType: 'xlsx', // 要生成的文件类型
            bookSST: false, // 是否生成Shared String Table，如果开启生成速度会下降，但在低版本IOS设备上有更好的兼容性
            type: 'binary'
        };
        var wbout = XLSX.write(workbook, wopts);
        var blob = new Blob([s2ab(wbout)], {
            type: "application/octet-stream"
        }); // 字符串转ArrayBuffer
        function s2ab(s) {
            var buf = new ArrayBuffer(s.length);
            var view = new Uint8Array(buf);
            for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
            return buf;
        }
        return blob;
    }

    function openDownloadDialog(url, saveName) {
        if (typeof url == 'object' && url instanceof Blob) {
            url = URL.createObjectURL(url); // 创建blob地址
        }
        var aLink = document.createElement('a');
        aLink.href = url;
        aLink.download = saveName || ''; // HTML5新增的属性，指定保存文件名，可以不要后缀，注意，file:///模式下不会生效
        var event;
        if (window.MouseEvent) {
            event = new MouseEvent('click');
        } else {
            event = document.createEvent('MouseEvents');
            event.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
        }
        aLink.dispatchEvent(event);
    }
    //点击导出实际匹配结果按钮
    function loadTableData() {
        //win10不支持
        var os = navigator.platform;
        var userAgent = navigator.userAgent;
        if (os.indexOf("Win") > -1) {
            /*if (userAgent.indexOf("Windows NT 6.1") > -1 || userAgent.indexOf("Windows 7") > -1) {  
                console.log("Win7");  
            } else */
            if (userAgent.indexOf("Windows NT 6.2") > -1 && userAgent.indexOf("Windows 8") > -1) {
                $.messager.alert('错误提示', '该功能不支持win8及以上系统在ie下导出，请使用谷歌浏览器!', "error");
                return;
            } else if (userAgent.indexOf("Windows NT 6.3") > -1 && userAgent.indexOf("Windows 8.1") > -1) {
                $.messager.alert('错误提示', '该功能不支持win8及以上系统在ie下导出，请使用谷歌浏览器!', "error");
                return;
            } else if (userAgent.indexOf("Windows NT 10.0") > -1 && userAgent.indexOf("Windows 10") > -1) {
                $.messager.alert('错误提示', '该功能不支持win10系统在ie下导出，请使用谷歌浏览器!', "error");
                return;
            }
        }
        var filename = tkMakeServerCall("web.DHCBL.MKB.MKBDocManage", "ExportUnReadDoc");
        if (filename != "") {
            //$.messager.progress('close');
            $(".load").attr("href", "#");
            $(".load").removeAttr("download");
            $(".load").removeAttr("target");
            filepath = "../scripts/bdp/MKB/DataExport/" + filename;
            $(".load").attr("href", filepath);
            $(".load").attr("download", filename);
            //判断浏览器是否支持a标签 download属性
            var isSupportDownload = 'download' in document.createElement('a');
            if (!isSupportDownload) {
                var fileType = filename.split(".")[filename.split(".").length - 1];
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
        } else {
            $.messager.alert("提示", "导出失败", "error")
            //$.messager.progress('close');
        }

    }

}
$(init);