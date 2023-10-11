/// 名称: 医用知识库 -全局化词表-别名列表展示
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-范文凯
/// 编写日期: 2019-10-18
var init = function() {
    var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBGlobal&pClassMethod=DeleteAliasData";
    var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBGlobal&pClassMethod=SaveAliasEntity&pEntityName=web.Entity.MKB.MKBGloAlias";
    var editIndex = undefined; //正在编辑的行index
    var rowsvalue = undefined; //正在编辑的行数据
    var oldrowsvalue = undefined; //上一个编辑的行数据
    var preeditIndex = ""; //上一个编辑的行index
    var oldeditIndex = "";//
    var textareInfoArr = [] //多行文本框信息串
    var showNameChild = "" //展示名child
    var documentWidth = window.screen.availWidth //$(window).width(); // $(document).width();
    var documentHeight = window.screen.availHeight // $(window).height() // $(document).height();
    // var iframeheight = $(".hisui-layout.layout").height();
    // var iframewidth = $(".hisui-layout.layout").width();
    var MarkParent=""
    
    var myProWidth = documentWidth * (1 / 2);
    var myProHeight = documentHeight * (3 / 8);
    LoadLocFrequency = function() {
        var LocFreqcolumns = [
            [{
                field: 'MKBGLFRowId',
                title: 'RowId',
                hidden: true,
                width: 100
            }, {
                field: 'LocName',
                title: '科室名称',
                width: 100
            }, {
                field: 'LocFreq',
                title: '开立频次',
                width: 100
            }]
        ];
        var LocFreqlist = $HUI.datagrid("#aliascenterlistgrid", {
            url: $URL, //QUERY_ACTION_URL
            queryParams: {
                ClassName: "web.DHCBL.MKB.MKBGlobal",
                QueryName: "GetLocFreq",
                'GlobalID': GlobalID
            },
            columns: LocFreqcolumns, //列信息
            idField:'MKBGLFRowId',
            rownumbers: false, //设置为 true，则显示带有行号的列。
            fixRowNumber: true,
            fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            //toolbar: '#aliasTools',
            scrollbarSize: 0,
            remoteSort: false
        })
    };
    var aliascolumns = [
        [{
            field: 'MKBGARowId',
            title: 'RowId',
            hidden: true,
            width: 100
        }, {
            field: 'MKBGADesc',
            title: '名称',
            width: 100,
            editor: 'validatebox',
            formatter:function(value,row,index){
                return '<span class="hisui-tooltip" title="'+row.MKBGADesc+'">'+value+'</span>'
            } 
        }, {
            field: 'MKBGAPYCode',
            title: '检索码',
            hidden: false,
            width: 150,
            editor: 'validatebox'
        }, {
            field: 'MKBGAMark',
            title: '标志',
            width: 150,
        }, {
            field: 'MKBGANote',
            title: '备注',
            hidden: false,
            width: 150,
            editor: {
                type: 'textarea'
            },
            formatter: function(value, row, index) {
                //鼠标悬浮显示备注信息
                return '<span class="mytooltip" title="' + row.MKBGANote + '">' + value + '</span>'
            }
        },{
            field: 'MKBGACEFlag',
            title: '中英文标识',
            width: 100,
            editor: 'validatebox',
            hidden: true
        },{
            field: 'MKBGASequence',
            title: '展示顺序',
            width: 100,
            hidden: true,
            sortable: true,
        }]
    ];
    var aliaslayoutlist = $HUI.datagrid("#aliascenterlistgrid", {
        url: $URL, //QUERY_ACTION_URL
        queryParams: {
            ClassName: "web.DHCBL.MKB.MKBGlobal",
            QueryName: "GetAliasList",
            'parref': GlobalID
        },
        columns: aliascolumns, //列信息
        pagination: true,
        pageSize: 50,
        idField:'MKBGARowId',
        rownumbers: false, //设置为 true，则显示带有行号的列。
        fixRowNumber: true,
        fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        scrollbarSize: 0,
        remoteSort: false,
        singleSelect: true,
        onDblClickRow: function(rowIndex, rowData) {
           // DblClickFun(rowIndex, rowData)
        },
        onClickCell:function(index, field, value){
            
            //ClickFun();
            //$('#aliascenterlistgrid').datagrid('selectRow', index).datagrid('beginEdit', index);
        },
        onClickRow: function(rowIndex, rowData) {
           $("#myTaglist").hide();
           ClickFun();
            if (parent.$("#tab_div").tabs('exists', "术语拆分<span class='hidecls'></span>"))
            {
                var sameflag=0
                var listRows=parent.$('#splitaliaslist').datagrid('getRows')
                for (var i=0;i<listRows.length;i++)
                {
                    if (listRows[i].ID==rowData.MKBGARowId)
                    {
                        sameflag=1
                    }
                }   
                if (sameflag==0) //不存在重复
                {
                    parent.$('#splitaliaslist').datagrid('insertRow',{ row: {
                        ID: rowData.MKBGARowId,Desc: rowData.MKBGADesc
                    } });
                }
                var sameflag=0
                var relistRows=parent.$('#splitreflist').datagrid('getRows')

                var result=tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","GetReference",rowData.MKBGARowId)
                var result=eval('(' + result + ')');

                if (result.reidstr!="")
                {
                    var reidstr=result.reidstr
                    var newarry= new Array(); //定义一数组
                    newarry=reidstr.split(","); //字符分割
                    var refarry= new Array(); //定义一数组
                    for (j=0;j<newarry.length;j++ )
                    {
                        refarry=newarry[j].split("^"); //字符分割  
                        for (var i=0;i<relistRows.length;i++)
                        {
                            if (relistRows[i].ID==refarry[0])
                            {
                                sameflag=1
                            }
                        }   
                        if (sameflag==0) //不存在重复
                        {
                            parent.$('#splitreflist').datagrid('insertRow',{ row: {
                                ID: refarry[0],Desc: refarry[1],Place:refarry[2]
                            } });
                        }
                            
                    }
                }
                if (result.info!="")
                {
                    parent.$("#ErrorBox").val("引用错误："+result.info);
                }
            }
        },
        onRowContextMenu: function(e, rowIndex, rowData) {
            var $clicked = $(e.target);
            copytext = $clicked.text() || $clicked.val() //普通复制功能
            e.preventDefault(); //阻止浏览器捕获右键事件
            var record = $(this).datagrid("selectRow", rowIndex); //根据索引选中该行 
            var mygridmm = $('<div style="width:120px;"></div>').appendTo('body');
            mygridmm.html('<div id="del_menu" onclick="DelAlias()" iconCls="icon-cancel" data-options="">删除</div>' + '<div id="copy_menu" onclick="CopyText()" iconCls="icon-copy" data-options="">复制</div>'+ '<div id="set_name" onclick="SetName()" iconCls="icon-move-up-most" data-options="">设为展示名</div>').click(stopPropagation);
            mygridmm.menu({
                onClick: function(item) {
                    var itemid = item.id
                }
            });
            mygridmm.menu('show', {
                left: e.pageX,
                top: e.pageY
            });
        },
        onDblClickCell: function (index, field, value) {
            var record=$(this).datagrid("getSelected")
            DblClickFun(index, record)
            var col = $('#aliascenter').children().find('tr[datagrid-row-index=' + index + ']');
            if (field=="MKBGADesc")
            {
                $(col).find('td[field=MKBGADesc]').find("input").focus();  //聚焦到描述上

                //DblClickFun(index, record)
            }
            else
            {
                /*var rows = $(this).datagrid('getRows');
                var MKBGAMark = rows[index].MKBGAMark;*/
                var MKBGAMark = record.MKBGAMark;
                
                var CheckedTagStr = $(col).find('td[field=MKBGAMark]') //获取已维护诊断标记
                //var Temp = $(col).find('td[field=MKBGAMark] div').html()
                CreatPropertyDom(CheckedTagStr,MKBGAMark);
            }
                
        },
        onLoadSuccess: function(data) {
            if(AliasId!=""){
                var index = $("#aliascenterlistgrid").datagrid('getRowIndex',AliasId);  
                $("#aliascenterlistgrid").datagrid('selectRow',index);  
            }
        }
    })
    //创建可编辑属性列表控件
    function CreatPropertyDom(CheckedTagStr,Temp){
            $("#SelTagStr").val(Temp)
            $('#Form_TagSearchGrid').datagrid('loadData', {
                total: 0,
                rows: []
            })
            $('#Form_TagSelectedGrid').datagrid('loadData', {
                total: 0,
                rows: []
            })
            $("#TagForm").empty();
            indexTagParent = ""
            SelTagData=""
            //调后台方法获取诊断标记id串
            var CheckedTagIdStr = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "GetCheckedTagIdStr", Temp);
            LoadTagData(CheckedTagIdStr, "");
            //再次打开时重新设置默认值，以防拖动后显示不下
            $("#myTaglist").css("width", myProWidth + "px")
            $("#myTaglist").css("height", myProHeight + "px")
            $('#mytagmplayout').layout('panel', 'west').panel('resize', {
                width: myProWidth * (1 / 4)
            });
            $('#mytagmplayout').layout('panel', 'east').panel('resize', {
                width: myProWidth * (9 / 20)
            });
            if (CheckedTagStr.offset().top + $("#myTaglist").height() + 30 > $(window).height()) {
                //2019-10-15 chenying
                if ((CheckedTagStr.offset().top - $("#myTaglist").height() - 5) < 0) {
                    //偏移
                    $("#myTaglist").css({
                        "top": CheckedTagStr.offset().top - (CheckedTagStr.offset().top + $("#myTaglist").height() + 30 - $(window).height()),
                        "left": (CheckedTagStr.offset().left) / 2
                    }).show();
                } else {
                    //显示在上面
                    $("#myTaglist").css({
                        "top": CheckedTagStr.offset().top - $("#myTaglist").height() - 5,
                        "left": (CheckedTagStr.offset().left) / 2
                    }).show();
                }
            } else {
                //显示在下面
                $("#myTaglist").css({
                    "top": CheckedTagStr.offset().top + 30,
                    "left": (CheckedTagStr.offset().left) / 2
                }).show();
            }
            $("#mytaglayout").layout("resize");
            //结构化诊断属性列表拖动改变大小
            $('#myTaglist').resizable({
                onStopResize: function(e) {
                    $('#mytagmplayout').layout('panel', 'west').panel('resize', {
                        width: $("#myTaglist").width() * (1 / 4)
                    });
                    $('#mytagmplayout').layout('panel', 'east').panel('resize', {
                        width: $("#myTaglist").width() * (9 / 20)
                    });
                    $("#mytaglayout").layout("resize");
                }
            });
    }
 
    //别名新增按钮
    $("#aliasadd_btn").click(function(e) {
        $('#knoExe').css('display', 'none');
        AddAlias();
    })
    //别名删除按钮
    $("#aliasdel_btn").click(function(e) {
        DelAlias();
    })
    ///中心词 右键复制
    CopyText = function() {
        var aux = document.createElement("input");
        // 获取复制内容
        //var content =elementId.text()||elementId.val() 
        // 设置元素内容
        aux.setAttribute("value", copytext);
        // 将元素插入页面进行调用
        document.body.appendChild(aux);
        // 复制内容
        aux.select();
        // 将内容复制到剪贴板
        document.execCommand("copy");
        // 删除创建元素
        document.body.removeChild(aux);
        //提示
        //alert("复制内容成功：" + aux.value);
    }
    //别名设置为展示名方法
    SetName = function() {
        var record = $("#aliascenterlistgrid").datagrid("getSelected");
        var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "PromoteSeqToFirst",record.MKBGARowId);
        $('#aliascenterlistgrid').datagrid('reload'); // 重新载入当前页面数据 
    }
    //别名新增方法
    AddAlias = function() {
        preeditIndex = editIndex;
        if(ClickFun('AddData')==0){
            return
        }
        if (endEditing() && editIndex!=0) {
            $('#aliascenterlistgrid').datagrid('insertRow', {
                index: 0,
                row: {}
            });
            editIndex = 0;
            $('#aliascenterlistgrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
            oldrowsvalue = aliaslayoutlist.getRows()[editIndex];
            oldrowsvalue = JSON.stringify(oldrowsvalue);
        }
        $('.eaitor-label span').each(function() {
            $(this).unbind('click').click(function() {
                if ($(this).prev()._propAttr('checked')) {
                    $(target).combobox('unselect', $(this).attr('value'));
                } else {
                    $(target).combobox('select', $(this).attr('value'));
                }
            })
        });
        var col=$('#aliascenter').children().find('tr[datagrid-row-index='+editIndex+']');
        $(col).find('td[field=MKBGADesc]').find("input").focus();
        AppendDom()
    }
    //是否有正在编辑的行true/false
    endEditing = function() {
        if (editIndex == undefined) {
            return true
        }
        //$('#aliascenterlistgrid').datagrid('validateRow', editIndex)  是判断是否有这行数据，不是判断是否在编辑
        if ($('#aliascenterlistgrid').datagrid('validateRow', editIndex)) {
            $('#aliascenterlistgrid').datagrid('endEdit', editIndex);
            rowsvalue = aliaslayoutlist.getRows()[editIndex];
            //rowsvalue = JSON.stringify(rowsvalue); 
            //editIndex = undefined;
            return true;
        } else {
            return false;
        }
    }
   
    //grid单击事件
    ClickFun = function(saveType) { //单击执行保存可编辑行
        if (endEditing()) {
            
            if (rowsvalue != undefined) {
                if ((rowsvalue.MKBGADesc != "")&&(rowsvalue.MKBGADesc != undefined)) 
                {
                    var PYCode = Pinyin.GetJPU(rowsvalue.MKBGADesc)
                    if (rowsvalue.MKBGAPYCode!=PYCode)        //修改了别名描述，检索吗也需要自动修改
                    {
                        rowsvalue.MKBGAPYCode=PYCode
                    }
                    var differentflag = "";

                    if (oldrowsvalue != undefined) {
                        var oldrowsvaluearr =JSON.parse(oldrowsvalue)      //JSON.parse(oldrowsvalue)
                        for (var params in rowsvalue) {
                            if (oldrowsvaluearr[params] == undefined) {
                                oldrowsvaluearr[params] = ""
                            }
                            if (rowsvalue[params] == undefined) {
                                rowsvalue[params] = ""
                            }
                            if (oldrowsvaluearr[params] != rowsvalue[params]) {
                                differentflag = 1
                            }
                        }
                    } else {
                        differentflag = 1
                    }
                    if (differentflag == 1) {
                        preeditIndex = editIndex
                        SaveAliasData(rowsvalue, saveType);
                    } else {
                        //UpdataRow(rowsvalue, editIndex)
                        //$('#aliascenterlistgrid').datagrid('refreshRow',editIndex)
                        editIndex = undefined
                        rowsvalue = undefined
                    }
                } 
                else 
                {
                   if (((rowsvalue.MKBGANote=="")||(rowsvalue.MKBGANote==undefined))&&((rowsvalue.MKBGAPYCode=="")||(rowsvalue.MKBGAPYCode==undefined)))
                    {
                        //均为空
                        $('#aliascenterlistgrid').datagrid("deleteRow",0)
                        editIndex = undefined;
                    }
                    else
                    {
                        $('#aliascenterlistgrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);   
                        //$.messager.alert('错误提示', '别名不能为空!', "error");
                        
                        /*$('#aliascenterlistgrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
                        oldrowsvalue = aliaslayoutlist.getRows()[editIndex];
                        oldrowsvalue = JSON.stringify(oldrowsvalue); 
                        AppendDom()*/
                        //return
                    }
                }
            }
        }
    }
    //grid双击事件
    DblClickFun = function(index, row) {
        
        if (index == editIndex) {
            return
        }
        if ((row != undefined) && (row.MKBGARowId != undefined)) {
            UpdataRow(row, index, "1")
            
        }
        preeditIndex = editIndex
        if (editIndex != index) {
            if (endEditing()) {
                $('#aliascenterlistgrid').datagrid('selectRow', index).datagrid('beginEdit', index);
                editIndex = index;
                //oldrowsvalue = aliaslayoutlist.getRows()[editIndex];
                //oldrowsvalue = JSON.stringify(oldrowsvalue);
            } else {
                $('#aliascenterlistgrid').datagrid('selectRow', editIndex);
            }
        }
        oldrowsvalue = JSON.stringify(row); //用于和rowvalue比较 以判断是否行值发生改变
        //AppendDom()
    }
    //加载表达式、多行文本框等可编辑表格控件
    AppendDom = function() {
        if (editIndex != undefined) {
           // var col = $('#aliascenter').children().find('tr[datagrid-row-index=' + editIndex + ']')[1];
            var col = $('#aliascenter').children().find('tr[datagrid-row-index=' + editIndex + ']');
          
            
            //备注多行文本框
            CreateTADom(col, "MKBGANote")
            CreatTagDom(col, "MKBGAMark", editIndex);
            //加载多行文本框控件
            for (fieldid in textareInfoArr) {
                var comId = "Extend" + fieldid
                CreateTADom(col, comId)
            }
            //展示名和拼音码赋值
            var descTarget = $(col).find('td[field=MKBGADesc] input')
            //if (aliaslayoutlist.getRows()[editIndex].MKBGARowId == undefined) {
                descTarget.keyup(function() {
                    var desc = descTarget.val() //中心词列
                    if (showNameChild != "") //展示名赋值
                    {
                        var showNameCol = $("#aliascenterlistgrid").datagrid("getEditor", {
                            index: editIndex,
                            field: showNameChild
                        });
                        $(showNameCol.target).val(desc)
                    }
                    //检索码赋值
                    var PYCode = Pinyin.GetJPU(desc)
                    var PYCodeCol = $("#aliascenterlistgrid").datagrid("getEditor", {
                        index: editIndex,
                        field: "MKBGAPYCode"
                    });
                    $(PYCodeCol.target).val(PYCode)
                })
            //}
            descTarget.click(function() {
                var desc = descTarget.val() //中心词列的值
                if (showNameChild != "") //展示名赋值
                {
                    var showNameCol = $("#aliascenterlistgrid").datagrid("getEditor", {
                        index: editIndex,
                        field: showNameChild
                    });
                    if ((aliaslayoutlist.getRows()[editIndex].MKBGARowId == undefined) || (showNameCol.target.val() == "")) {
                        $(showNameCol.target).val(desc)
                    }
                }
                //检索码赋值
                var PYCode = Pinyin.GetJPU(desc)
                var PYCodeCol = $("#aliascenterlistgrid").datagrid("getEditor", {
                    index: editIndex,
                    field: "MKBGAPYCode"
                });
                if ((aliaslayoutlist.getRows()[editIndex].MKBGRowId == undefined) || (PYCodeCol.target.val() == "")) {
                    $(PYCodeCol.target).val(PYCode)
                }
            })
        }
    }
    //修改完后给这一行赋值
    UpdataRow = function(row, Index, TAType) {
        if (Index == undefined){
            Index = oldeditIndex;
        }
        //处理换行符
        if (TAType == "1") //双击的时候</br>转换为\n
        {
            //多行文本框
            for (fieldid in textareInfoArr) {
                var comId = "Extend" + fieldid
                row[comId] = row[comId].replace(/<br\/>/g, "\n");
            }
            //备注
            row.MKBGANote = row.MKBGANote.replace(/<br\/>/g, "\n");
        } else //保存成功的时候\n转换为</br>
        {
            //多行文本框
            for (fieldid in textareInfoArr) {
                var comId = "Extend" + fieldid
                row[comId] = row[comId].replace(/\n/g, "<br\/>");
            }
            if ((row.MKBGANote=="")||(row.MKBGANote==undefined))
            {

            }
            else
            {
                //备注
                row.MKBGANote = row.MKBGANote.replace(/\n/g, "<br\/>");
            }
            
        }
        $('#aliascenterlistgrid').datagrid('updateRow', {
            index: Index,
            row: row
        })
    }
    //正则表达式去特殊符号
    stripscript =function(s){
        var pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]")  //去特殊字符
        var rs = "";
        for (var i = 0; i < s.length; i++) {
        rs = rs+s.substr(i, 1).replace(pattern,'');
        rs=rs.replace(/^\s+|\s+$/g,'');  //去首尾空格
        }
        return rs;
    }
    //新增修改保存方法
    SaveAliasData = function(trecord, saveType) {
        var listData = trecord;
        var Desc = listData.MKBGADesc;
        listData.MKBGAParRef = GlobalID;
        if ((listData.MKBGADesc == "")) {
            $('#aliascenterlistgrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
            //$.messager.alert('错误提示', '别名不能为空!', "error");
            //DblClickFun(0,undefined)
            /*$('#aliascenterlistgrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
            oldrowsvalue = aliaslayoutlist.getRows()[editIndex];
            oldrowsvalue = JSON.stringify(oldrowsvalue);*/
            return
        }
        /*
        if (parent.$("#tab_div").tabs('exists', "新增名称<span class='hidecls'></span>")) {
            
            record.MKBGADesc=stripscript(parent.$("#addaliasname").val())
        }else{
            record.MKBGADesc=stripscript(record.MKBGADesc);
        }  
        */  
        //执行保存
        $.ajax({
            type: 'post',
            url: SAVE_ACTION_URL,
            data: listData,
            success: function(data) { //返回json结果           
                var data = eval('(' + data + ')');
                if (data.success == 'true') {
                    $.messager.popover({
                        msg: '维护成功！',
                        type: 'success',
                        timeout: 1000
                    });
                    /*if (saveType == 'AddData') {
                        preeditIndex = preeditIndex + 1;
                    }*/
                  
                    listData.MKBGARowId = data.id
                    //var rowindex = $('#aliascenterlistgrid').datagrid('getRowIndex', listData);
                    //$('#aliascenterlistgrid').datagrid('refreshRow'.rowindex)
                    UpdataRow(listData, preeditIndex);        //保存后需要修改显示
                    //if (saveType != 'AddData') {
                        editIndex = undefined
                        rowsvalue = undefined
                   // }
                    /*
                    if (parent.$("#tab_div").tabs('exists', "新增别名<span class='hidecls'></span>")){
                        //关闭辅助功能区tabs页
                        parent.$("#tab_div").tabs('close', "新增别名<span class='hidecls'></span>");
                        //折叠辅助功能区
                        parent.$('#test').layout('collapse', 'east');
                    }
                    */
        
                  
                } else {
                    $('#aliascenterlistgrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);

                    //DblClickFun(editIndex,undefined)
                    /*$('#aliascenterlistgrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
                    oldrowsvalue = aliaslayoutlist.getRows()[editIndex];
                    oldrowsvalue = JSON.stringify(oldrowsvalue);*/
                    if (parent.$("#tab_div").tabs('exists', "新增别名<span class='hidecls'></span>")) {
                        parent.$("#tab_div").tabs('select', "新增别名<span class='hidecls'></span>");
                    } else {
                        parent.$('#tab_div').tabs('add', {
                        title: "新增别名<span class='hidecls'></span>",
                        id: "AddTheGloalias",
                        closable: true,
               
                        });
                    }
                    parent.$('.tabs .tabs-inner').css('line-height', '16px');
                    parent.$('.tabs .tabs-inner').css('height', 'auto');
                    parent.$('.tabs .tabs-inner').css('padding', '6px');
                   // parent.$('.tabs .tabs-inner .tabs-title').css('white-space', 'pre-wrap');
                    parent.$('#test').layout('expand', 'east');
                    var MKBGADesc = $("#aliascenterlistgrid").datagrid("getSelected").MKBGADesc;
                    parent.$("#AddTheGloalias").html('<table style="padding:0 7px;padding-bottom:20px" align=center><tr><td style="padding:10px 0">名称</td></tr><tr><td><input  id="addaliasname" type="text"  style="width:258px" ></td></tr></table><table  cellspacing="30" align=center ><tr><td><a href="#" class="hisui-linkbutton"  id="addalias">执行</a></td><td><a href="#" class="hisui-linkbutton" id="closealias">放弃</a></td></tr></table><table style="padding:0 7px;padding-bottom:20px" align=center><tr><td style="padding:10px 0">报错信息</td></tr><tr><td><textarea id="ErrorMessage" style="height:200px;width:265px;"></textarea></td></tr></table>')
                    // 渲染按钮
                    parent.$("#addalias").linkbutton({
                        stopAllEventOnDisabled: true,
                        onClick: function() {
                        }
                    });
                    // 渲染按钮
                    parent.$("#closealias").linkbutton({
                        stopAllEventOnDisabled: true,
                        onClick: function() {
                        }
                    });
                    
                    var errorMsg = "名称重名";
                    if (data.errorinfo) {
                       errorMsg = errorMsg +":" +"'"+ MKBGADesc+"'"+'该词'+data.errorinfo
                       parent.$("#addaliasname").focus();
                    }
                    parent.$("#addaliasname").val(MKBGADesc);
                    parent.$("#addaliasname").focus();
                    parent.$("#ErrorMessage").val(errorMsg);
                    //执行操作按钮
                    parent.$("#addalias").click(function(e) {
                        SaveAliasData(listData,saveType);
                    })
                    parent.$("#closealias").click(function(e) {
                        parent.$("#tab_div").tabs('close', "新增别名<span class='hidecls'></span>");
                        //折叠辅助功能区
                        parent.$('#test').layout('collapse', 'east');
                        aliaslayoutlist.deleteRow(editIndex);
                        
                    }) 
                     
                }
            }
        })
    }
    //删除方法
    DelAlias = function() {
        var record = $("#aliascenterlistgrid").datagrid("getSelected");
        if (!(record)) {
            $.messager.alert('错误提示', '请先选择一条记录!', "error");
            return;
        }
        if ((record.MKBGARowId == undefined) || (record.MKBGARowId == "")) {
            aliaslayoutlist.deleteRow(editIndex)
            editIndex = undefined;
            return;
        }
        $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r) {
            if (r) {
                $.ajax({
                    url: DELETE_ACTION_URL,
                    data: {
                        "Id": record.MKBGARowId ///rowid
                    },
                    type: "POST",
                    success: function(data) {
                        var data = eval('(' + data + ')');
                        if (data.success == 'true') {
                            $.messager.popover({
                                msg: '删除成功！',
                                type: 'success',
                                timeout: 1000
                            });
                            $('#aliascenterlistgrid').datagrid('reload'); // 重新载入当前页面数据  
                            $('#aliascenterlistgrid').datagrid('unselectAll'); // 清空列表选中数据
                           
                            editIndex = undefined;
                            rowsvalue = undefined;

                        } else {
                            var errorMsg = ""
                            if (data.info) {
                                errorMsg = '删除失败！<br/>错误信息:' + data.info
                                $.messager.alert('操作提示', errorMsg, "error");
                            }
                        }
                    }
                })
            }
        });
    }
    //创建多行文本框
    CreateTADom = function(jq1, jq2) { //生成textarea下拉区域
        var target = $(jq1).find('td[field=' + jq2 + '] textarea')
        target.click(function() {
            $('body').append('<textarea rows="10" cols="30" id="textareadom" style="z-index:999999;display:none;position:absolute;background:#FFFFFF">')
            $("#textareadom").val(target.val())
            if (target.offset().top + $("#textareadom").height() > $(window).height()) {
                $("#textareadom").css({
                    "left": target.offset().left,
                    "top": target.offset().top - $("#textareadom").height() + 27,
                    "width": target.width()
                }).show();
            } else {
                $("#textareadom").css({
                    "left": target.offset().left,
                    "top": target.offset().top,
                    "width": target.width()
                }).show();
            }
            $("#textareadom").focus(function() {
                $('#knoExe').css('display', 'none');
            }).focus().blur(function() {
                target.val($("#textareadom").val())
                $(this).remove();
            }).keydown(function(e) {
                if (e.keyCode == 13) {
                    //$("#textareadom").hide();
                    target.val($("#textareadom").val())
                }
            }).click(stopPropagation);
        });
    }
    //创建可编辑标记列表控件
    function CreatTagDom(jq1, jq2, index) {

        var target = $(jq1).find('td[field=' + jq2 + '] input')
        target.click(function() {
            $("#aliaslayoutlist").datagrid("selectRow", index)
            var col = $('#aliascenter').children().find('tr[datagrid-row-index=' + index + ']');
            var CheckedTagStr = $(col).find('td[field=MKBGAMark] input').val() //获取已维护诊断标记
            $("#SelTagStr").val(CheckedTagStr)
            $('#Form_TagSearchGrid').datagrid('loadData', {
                total: 0,
                rows: []
            })
            $('#Form_TagSelectedGrid').datagrid('loadData', {
                total: 0,
                rows: []
            })
            $("#TagForm").empty();
            indexTagParent = ""
            SelTagData=""
            //调后台方法获取诊断标记id串
            var CheckedTagIdStr = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "GetCheckedTagIdStr", CheckedTagStr);
            LoadTagData(CheckedTagIdStr, "");
            //再次打开时重新设置默认值，以防拖动后显示不下
            $("#myTaglist").css("width", myProWidth + "px")
            $("#myTaglist").css("height", myProHeight + "px")
            $('#mytagmplayout').layout('panel', 'west').panel('resize', {
                width: myProWidth * (1 / 4)
            });
            $('#mytagmplayout').layout('panel', 'east').panel('resize', {
                width: myProWidth * (9 / 20)
            });
            if (target.offset().top + $("#myTaglist").height() + 30 > $(window).height()) {
                //2019-10-15 chenying
                if ((target.offset().top - $("#myTaglist").height() - 5) < 0) {
                    //偏移
                    $("#myTaglist").css({
                        "top": target.offset().top - (target.offset().top + $("#myTaglist").height() + 30 - $(window).height()),
                        "left": (target.offset().left) / 2
                    }).show();
                } else {
                    //显示在上面
                    $("#myTaglist").css({
                        "top": target.offset().top - $("#myTaglist").height() - 5,
                        "left": (target.offset().left) / 2
                    }).show();
                }
            } else {
                //显示在下面
                $("#myTaglist").css({
                    "top": target.offset().top + 30,
                    "left": (target.offset().left) / 2
                }).show();
            }
            $("#mytaglayout").layout("resize");
            //结构化诊断属性列表拖动改变大小
            $('#myTaglist').resizable({
                onStopResize: function(e) {
                    $('#mytagmplayout').layout('panel', 'west').panel('resize', {
                        width: $("#myTaglist").width() * (1 / 4)
                    });
                    $('#mytagmplayout').layout('panel', 'east').panel('resize', {
                        width: $("#myTaglist").width() * (9 / 20)
                    });
                    $("#mytaglayout").layout("resize");
                }
            });
        })
    };
 
    //标记为常用诊断表达式触发方法
    MarkisDiagExp = function() {
        var data = $('#aliascenterlistgrid').datagrid('getSelected')
        var selectedDesc=data.MKBGADesc
        var str = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "GetStructedDataAPI", data.MKBGADesc);
        
        var str = eval('(' + str + ')');
        //右侧辅助功能区自动展开并生成相对应的辅助功能区页签
        parent.$('#test').layout('expand', 'east');
        parent.$("#ttt").css("width", "1200px");
        parent.$("#myeditgrid").datagrid('resize');
        $("#myTaglist").css("left", "140px");
        if (parent.$("#tab_div").tabs('exists', "表达式<span class='hidecls'></span>")) {
            parent.$("#tab_div").tabs('select', "表达式<span class='hidecls'></span>");
        } else {
            parent.$('#tab_div').tabs('add', {
                title: "表达式<span class='hidecls'></span>",
                //id: "tab_" + MKBGRRowId
                id: "RefDiagExp",
                //content:'Tab Body',//里边可以插html内容    
                closable: true
            });
        };
        // 辅助功能区表达式页签增加html代码
        parent.$("#RefDiagExp").css('position', 'relative');
         parent.$("#RefDiagExp").html('<div id="RefDiagExpDIV"><a style="color:#000" >处理内容:'+data.MKBGADesc+'</a></div><div style="width:100%;height:300px;"><a style="color:#000;width:100%;" >分词结果:</a><table id="refdiagexplist" style="width:300px;height:250px;" border="false"></table></div><div style="text-align:center;"><a href="#" class="hisui-linkbutton" id="affirmrefexp" style="margin-right:10px">确认引用</a><a href="#" class="hisui-linkbutton" id="cancelrefexp" style="margin-right:10px">放弃操作</a><a href="#" class="hisui-linkbutton" id="operationrefexp">合并操作</a><table><tr><td style="padding:10px 0">人工分词</td><td><input style="width:165px" id="TextDesc2" /><span class="searchbox-button" style="margin:1px 0 0 -30px;" id="TextDesc4"></span></td></tr></table><table style="padding:0 7px;padding-bottom:20px" id="ErrorTable" align=center><tr><td style="padding:10px 0">报错信息</td></tr><tr><td><textarea id="ErrorMessage2" style="height:70px;width:265px;"></textarea></td></tr></table><a href="#" class="hisui-linkbutton" id="changerefexp" style="display:none;">更名引用</a></div>'); 
         parent.$("#affirmrefexp").linkbutton({
            onClick: function() {
                var AliasRowID=data.MKBGARowId
                parent.fwkreftest(AliasRowID);

            }
        });
        // 渲染引用操作按钮
        parent.$("#operationrefexp").linkbutton({
            onClick: function() {
                $('#aliascenterlistgrid').datagrid('selectRow', editIndex);
                var MKBGAObj = aliaslayoutlist.getRows()[editIndex];
                var data = parent.$("#iframediagref")[0].contentWindow.getMKBTPDRowId();

                var TGlobalID=MKBGAObj.MKBGARowId.split("||")[0];
                parent.MergeDataFunlib()        //显示合并窗口
                parent.$('#mergelist').datagrid("loadData",[])
                
                var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",TGlobalID)
                var rowdata=eval('('+rowdata+')');
                parent.$('#mergelist').datagrid('insertRow',{ row:rowdata});
                                   
                    

                var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "SelfTestInitiativeID", data.MKBTPDRowId);
                var result = eval('(' + result + ')');
                if(result.exist== "true")
                {
                    var PassiveIDStr=result.PassiveID.split(",")
                    for (var m=0;m<PassiveIDStr.length;m++)
                    {
                        
                        if ((PassiveIDStr[m]=="undefined")||(PassiveIDStr[m]==TGlobalID))
                        {
                            continue
                        }
                        else
                        {
                            var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",PassiveIDStr[m])
                            var rowdata=eval('('+rowdata+')');
                            parent.$('#mergelist').datagrid('insertRow',{ row:rowdata}); 
                                
                        }
                    }
                }
            }
        });
        /*
        // 渲染取消操作按钮
        parent.$("#cancelrefexp").linkbutton({
            onClick: function() {
                console.log(parent)
                //关闭主展示区tabs页
                parent.$('#tt').tabs('close', "新增引用");
                //关闭辅助功能区tabs页
                parent.$('#tab_div').tabs('close', "表达式<span class='hidecls'></span>");
                //折叠辅助功能区
                parent.$('#test').layout('collapse', 'east');
                //主展示区选择属性维护页签
                parent.$('#tt').tabs('select', "属性维护");
                //名称列表保存old值
                rowsvalue = JSON.parse(oldrowsvalue);
                oldeditIndex = editIndex;
                editIndex = undefined;
                ClickFun();
                $("#myTaglist").hide();
            }
        });
        */
        MarkParent.$("#cancelrefexp").linkbutton({
            onClick: function() {
                //关闭主展示区tabs页
                MarkParent.$('#tt').tabs('close', "新增引用");
                //关闭辅助功能区tabs页
                MarkParent.$('#tab_div').tabs('close', "表达式<span class='hidecls'></span>");
                //折叠辅助功能区
                MarkParent.$('#test').layout('collapse', 'east');
                //主展示区选择属性维护页签
                MarkParent.$('#tt').tabs('select', "属性维护");
                //名称列表保存old值
                rowsvalue = JSON.parse(oldrowsvalue);
                oldeditIndex = editIndex;
                editIndex = undefined;
                $('#aliascenterlistgrid').datagrid("reload")
                //ClickFun();
                $("#myTaglist").hide();

            }
        });
        
        
        var SearchText =""
        //人工分词查询框
         parent.$('#TextDesc2').searchcombobox({ 
            url:$URL+"?ClassName=web.DHCBL.MKB.MKBGlobal&QueryName=GetTermForCmb1&ResultSetType=array",
            onLoadSuccess:function(data)
            {
                var thetext=parent.$('#TextDesc2').combobox('getText')
                if (thetext!="")
                {
                    SearchText=parent.$('#TextDesc2').combobox('getText')
                }                
                if (SearchText!="")
                {
                    for (var i=0;i<data.length;i++)
                    {
                        if (data[i].ID==SearchText)
                        {
                            //parent.$('#TextDesc2').combobox('unselect',SearchText);
                            parent.$('#TextDesc2').combobox("setValue","")
                        }
                    }
                }
                
            },            
            onSelect:function (record) 
            {   
                    parent.$('#TextDesc2').combobox('setValue',SearchText)
                    if (record.Desc=="...")
                    {
                        
                        $("#myTaglist").css("left", "140px");
                        if (parent.$("#tab_div").tabs('exists', "人工分词<span class='hidecls'></span>")) {
                            parent.$("#tab_div").tabs('select', "人工分词<span class='hidecls'></span>");
                        } else {
                            parent.$('#tab_div').tabs('add', {
                                title: "人工分词<span class='hidecls'></span>",
                                //id: "tab_" + MKBGRRowId
                                id: "PickWord",
                                //content:'Tab Body',//里边可以插html内容    
                                closable: true,
                                //href:url
                            });
                        };
                        // 辅助功能区表达式页签增加html代码
                        parent.$("#PickWord").css('position', 'relative');
                        //var currentTabPanel = $("#tabsMain").tabs('getSelected');
                        parent.$("#PickWord").html('<div ><a style="color:#000" >全部搜索结果:</a></div ><div id="AllListDiv"  style="width:100%;position:absolute;top:20px;bottom:20px"></div>');
                        var dynamicTable = $('<table data-options="fit:true"  id="allresultlist" border="false"></table>')
                        parent.$("#AllListDiv").html(dynamicTable);
                       // parent.$("#PickWord").html('<div ><a style="color:#000" >全部搜索结果:</a></div ><div ><table data-options="fit:true" style="width:100%;position:absolute;top:20px;bottom:20px" id="allresultlist" border="false"></table></div>');
                        $("#allresultlist").datagrid("resize");
                        //PickWord();
                        var listcolumns = [
                            [{
                                field: 'ID',
                                title: '中心词',
                                width: 100,
                                hidden: true
                            },{
                                field:'Desc',
                                title:'中心词对应的显示',
                                width: 100 
                            }
                            ]
                        ];
                        
                        dynamicTable.datagrid({
                            url: $URL,
                            queryParams: {
                                ClassName: "web.DHCBL.MKB.MKBGlobal",
                                QueryName: "GetTermForCmb1",
                                allflag: 1,
                                q:SearchText
                            },
                            columns:listcolumns,
                            remoteSort: false,
                            pagination: true, //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
                            pageSize: 20,
                            pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500, 1000],
                            singleSelect: true,
                            checkOnSelect: false,
                            selectOnCheck: false,
                            idField: 'ID',
                            rownumbers: false, //设置为 true，则显示带有行号的列。
                            fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
                            scrollbarSize: 0,
                            onClickRow: function(index, row){
                                if (row.Desc==row.ID)
                                {
                                    var str=row.Desc
                                }       
                                else
                                {
                                    var str=row.Desc.split(row.ID+"(")[1].slice(0,-1)
                                }                                                               
                                SearchCenterWord(parent,str,selectedDesc);
                               
                            },
                            onLoadSuccess:function(data){
                                $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
                                $(this).datagrid('columnMoving'); //列可以拖拽改变顺序
                            }
                        });
                    }
                    else
                    {
                        
                        parent.$(this).combobox('textbox').focus();
                        if (record.Desc==record.ID)
                        {
                            var str=record.Desc
                        }       
                        else
                        {
                            var str=record.Desc.split(record.ID+"(")[1].slice(0,-1)
                        }
                        
                        SearchCenterWord(parent,str,selectedDesc);

                        //var SearchStr =record.ID
                        //SearchCenterWord(parent,SearchStr,selectedDesc);
                    }
                    
                    
                }
                
            });
        parent.$('#TextDesc2').combobox("setValue","")
        parent.$('#TextDesc2').combobox('textbox').bind('keyup',function(e){  
            if (e.keyCode==13){ 
                // var SearchStr =parent.$('#TextDesc2').combobox('getValue')
                parent.$('#TextDesc2').combobox('setValue',SearchText)
                
                var url = $URL + "?ClassName=web.DHCBL.MKB.MKBGlobal&QueryName=GetTermForCmb1&matchflag=1&ResultSetType=array";
                parent.$('#TextDesc2').combobox('reload', url)
                parent.$('#TextDesc2').combobox("showPanel")

            }
        });
        

        parent.$("#TextDesc4").click(function (e) {               
                /*var SearchStr =parent.$('#TextDesc2').combobox('getValue')                
                SearchCenterWord(parent,SearchStr,selectedDesc);*/

                parent.$('#TextDesc2').combobox('setValue',SearchText)
                
                var url = $URL + "?ClassName=web.DHCBL.MKB.MKBGlobal&QueryName=GetTermForCmb1&matchflag=1&ResultSetType=array";
                parent.$('#TextDesc2').combobox('reload', url)
                parent.$('#TextDesc2').combobox("showPanel")
        })
         parent.$('#TextDesc2').combobox({
            onChange:function(newValue, oldValue){
                if (newValue=="")
                {
                    var url = $URL+"?ClassName=web.DHCBL.MKB.MKBGlobal&QueryName=GetTermForCmb1&ResultSetType=array"
                    $('#TextDesc4').combobox('reload', url)
                    $('#TextDesc4').combobox("resize")  
                }
                    
            }
        })
  
        
        // 父界面tabs自使用方法
        parent.tabsresize("addglobalref");
        //匹配常用诊断表达式输入框
        parent.refdiagexplist("refdiagexplist", str,selectedDesc);
    }
    
    //查找中心词
    SearchCenterWord=function (parent,searchvalue,selectedDesc){
            if(searchvalue!=null){
                if (parent.$("#tt").tabs('exists', "新增引用")) {
                    parent.$("#tt").tabs('select', "新增引用");
                    parent.$('#addglobalref').css('width','auto');
                } else {
                    parent.$('#tt').tabs('add', {
                        title: "新增引用",
                        id: "addglobalref",   
                        closable: true
                    });
                };
                parent.$("#ErrorMessage2").val("")
                var matchstr = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "AliasDescMatchDiag2",searchvalue);
                if (matchstr!="")
                {
                    //9438867^高血压性心脏病^14679-2474:318725^高血压[3级（极高危）]
                    var MKBTPRowId=matchstr.split("^")[0]
                    var structstr=matchstr.split("^")[2]
                    
                    var url="dhc.bdp.mkb.mkbtermprodetaillist.csp?property="+MKBTPRowId+"&detaildesc="+selectedDesc+"&detailstruct="+structstr
                    if ('undefined'!==typeof websys_getMWToken){
                        url += "&MWToken="+websys_getMWToken()
                    }
                    parent.$('#addglobalref').html('<iframe id="iframediagref" src="'+url+'" width="100%" height="779px" frameborder="0">')
                   // parent.$('#addglobalref').html('<iframe id="iframediagref" src="'+url+'" width="100%" height="779px" frameborder="0">')
                }
                else
                {
                    parent.$("#ErrorMessage2").val("未找到该术语对应的临床实用诊断中心词！"); 
                }   

                              
                              
            } 
        }
    //标记列表取消
    $("#cancel_btn_Tag").click(function(e) {
        $("#myTaglist").hide();
    });
    //标记列表确定
    $("#confirm_btn_Tag").click(function(e) {
        $("#myTaglist").hide();
        var tagValue = GetTagValue();
        MarkParent=parent
        var markstr=""
        var MKBGAObj = aliaslayoutlist.getRows()[editIndex];
        
        markstr = tagValue.split("#")[1];

        if (MKBGAObj.MKBGAMark==markstr)
        {
            $('#aliascenterlistgrid').datagrid("endEdit", editIndex);
            editIndex=undefined
            rowsvalue=undefined           
        }
        else
        {
           var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "EditMKBGAMark", MKBGAObj.MKBGARowId, markstr);
            var result = eval('(' + result + ')');
            if (result.success == 'true') {
                $.messager.popover({
                    msg: '修改成功！',
                    type: 'success',
                    timeout: 1000
                });
                
                $('#aliascenterlistgrid').datagrid('reload')
                

                editIndex=undefined
                rowsvalue=undefined
                if (tagValue.indexOf("临床实用诊断") >= 0)
                {
                    parent.$('#referencecenterlistgrid').datagrid('reload');                   
                }
                //和原先的别名标志进行对比，新增了“常用诊断表达式”标志的时候
                //现在含有“常用诊断表达式”，以前没有 
                if ((MKBGAObj.MKBGAMark!="")&&(MKBGAObj.MKBGAMark!=undefined))
                {
                    if ((MKBGAObj.MKBGAMark.indexOf("常用诊断表达式")<=-1)&&(markstr.indexOf("常用诊断表达式")>-1)) 
                    {       
                        MarkisDiagExp();
                    }
                }
                    
                

            }else{
               $.messager.popover({
                    msg: '修改失败！'+result.info,
                    type: 'error',
                    timeout: 2000
                });
                var thedata=$("#aliascenterlistgrid").datagrid('getSelected');                 
                var theindex=$('#aliascenterlistgrid').datagrid('getRowIndex',thedata);  //获取行的编号
                $('#aliascenterlistgrid').datagrid('refreshRow'.theindex)

                if(result.type == 'Term'){
                   //辅助功能区的操作
                }else if(result.type == 'ICD'){
                   //辅助功能区的操作
                   //MarkisICDDiag();
                }
            } 
        }
            
    });
    SaveFreq = function(obj, ejb, djb) {}
};
$(init);
