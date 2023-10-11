var init = function() {
    var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBGlobal&pClassMethod=DelGlobalData";
    var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBGlobal&pClassMethod=SaveGlobalData&pEntityName=web.Entity.MKB.MKBGlobal";
    var MERGE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBGlobal&pClassMethod=MergeGlobalData";
    var CONFIRM_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBGlobal&pClassMethod=Confirm";
    var editIndex = undefined; //正在编辑的行index
    var rowsvalue = undefined; //正在编辑的行数据
    var oldrowsvalue = undefined; //上一个编辑的行数据
    var preeditIndex = ""; //上一个编辑的行index
    var textareInfoArr = []; //多行文本框信息串
    var mergedata = undefined; //合并之后的id
    var showPage = "new";
    var GlobalID = "";
    var fasterHeight = "";//可编辑表格的高度
    var Type = "N";
    var refablearray = []; //可引用的数组
    var nowrefableid = ""; //目前展示的refid
    var SortMethod="freqsort"
    var MKBGMark =  "临床实用诊断,常用诊断描述,业务诊断,展示名";
    if (DataDesc != "") {
        Type = "SameGlobal";
    }
    var base=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetIdByDesc","全局化词表标记")
    var locbase=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetIdByDesc","专业科室")
    var PreLocStr=""    //上一次查询的科室排序串
    var PreFreq=""      //上一次查询的频次
    var PreLocDescStr="" //上一次查询的科室排序串，，描述

    //数据导出按钮
    $('#export_btn').click(function(e) {
        //引用hisui库后,js文件中代码，
        var rtn = $cm({
            dataType: 'text',
            ResultSetType: "Excel",
            ExcelName: "全局化词表", //默认DHCCExcel
            ClassName: "web.DHCBL.MKB.MKBGlobal",
            QueryName: "ImportDataToNLP",
        }, false);
        location.href = rtn;
    });
    //导出重复按钮
    $('#ExportSame').click(function(e) {
        loadData()
    });
function loadData()
{ 

    $.m({
        ClassName:"web.DHCBL.MKB.MKBGlobal",
        MethodName:"ExportSameDescData",
        page:1,
        rows:10000000           
    }, function (jsonData) {
        var data = eval('(' + jsonData + ')');
        var str = "<tr><td>术语ID</td><td>术语描述</td><td>别名ID</td><td>别名描述</td></tr>";

       for (var i = 0; i < data.rows.length; i++) {
            str = str + "<tr><td>" + data.rows[i].GlobalID + "</td><td>" + data.rows[i].MKBGDesc 
            + "</td><td>" + data.rows[i].AliasRowID+ "</td><td>" + data.rows[i].MKBGADesc
            + "</td></tr>"
        }       
        console.log(str)
        document.getElementById("table1").innerHTML = str;
        excel = new ExcelGen({
            "src_id": "table1",
            "show_header": true,
            "fileName":"描述一致的术语数据"
        });
        excel.generate();
    }) 


}
    //tabs自适应
    tabsresize = function(tabs) {
        $("#"+tabs).css("width", "100%");
        $("#"+tabs).css({
            height: fasterHeight-44 + 'px',
            overflow: 'hidden'
        });
        $("#tt").css({
            height: fasterHeight + 'px'
        })
        
    }
   
    //确认引用之后触发的自检方法
    SelfTestAftExpRef = function(AliasID, RefMKBTPDObj) {
        var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "SelfTestAftExpRef", AliasID, RefMKBTPDObj.MKBTPDRowId);
        var result = eval('(' + result + ')');
        $("#ErrorMessage2").val(""); 
        if (result.exist == "true") {       //已存在相同诊断表达式！
            var  RefRowID=result.id
            if ((RefRowID="undefined")||(RefRowID=undefined))
            {
                RefRowID=""
            }
            var errorStr=result.errorinfo
            var Mergestr=result.MergeStr
            if ((Mergestr!="")&&(Mergestr!="undefined")&&(Mergestr!=undefined))
            {
                //2021-3-17     自检后如果这个引用在其他地方存在引用，触发合并
                MergeDataFunlib()
                $('#mergelist').datagrid("loadData",[])
                var len=Mergestr.split(",").length
                for (m=0;m<len;m++)
                {
                    var merid= Mergestr.split(",")[m]
                    if (merid=="")
                    {
                        continue
                    }
                    var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",merid);                  
                    var rowdata=eval('('+rowdata+')');
                    $('#mergelist').datagrid('insertRow',{ row:rowdata});
                }
            }
            else
            {
                $("#ErrorMessage2").val(errorStr); 
                //$("#ErrorTable").append('<tr><a href="#" class="hisui-linkbutton" id="changerefexp" style="margin-right:30px">更名引用</a></tr>')        
                $("#changerefexp").attr("style","margin-left: 30px;width: 100px;display:block;");
                // 渲染更名引用按钮
                $("#changerefexp").linkbutton({
                    onClick: function() {
                        //不保存现编辑行的修改
                        $('#cancelrefexp').click();
                        //调用后台方法 去执行引用
                        var rs = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "SaveReference", AliasID, RefMKBTPDObj.MKBTPDRowId,RefRowID);
                        var rs = eval('(' + rs + ')');
                        if (rs.success == 'true') {
                            $.messager.popover({
                                msg: '引用成功！',
                                type: 'success',
                                timeout: 1000
                            });
                            $('#referencecenterlistgrid').datagrid('reload');
                            //$('#aliascenterlistgrid').datagrid('reload');
                            LoadAliasList(GlobalID);
                            //LoadReferenceList(GlobalID); 
                            
                            $("#tt").tabs('select', "属性维护");
                            $('#tt').tabs('close', "新增引用");
                        }
                        else
                        {
                            

                            var errorMsg ="保存失败！"
                            if (rs.errorinfo) 
                            {
                                errorMsg =errorMsg+ '<br/>错误信息:' + rs.errorinfo
                            }
                            $("#ErrorMessage2").val(errorMsg); 
                            //$.messager.alert('操作提示',errorMsg,"error");
                        }
                    }
                });
            }
            
                
        }
        else
        {
            $('#cancelrefexp').click();
                    //调用后台方法 去执行引用
                    var rs = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "SaveReference", AliasID, RefMKBTPDObj.MKBTPDRowId,"");
                    var rs = eval('(' + rs + ')');
                    if (rs.success == 'true') {
                        $.messager.popover({
                            msg: '引用成功！',
                            type: 'success',
                            timeout: 1000
                        });
                        $('#referencecenterlistgrid').datagrid('reload');
                        //$('#aliascenterlistgrid').datagrid('reload');
                        LoadAliasList(GlobalID);
                        //LoadReferenceList(GlobalID); 
                        $("#tt").tabs('select', "属性维护");
                        $('#tt').tabs('close', "新增引用");
                    };
        }
        

        /*if (result.exist == 'ture') {
            $.messager.confirm('提示', '列表中存在相同描述,是否更换引用对象?', function(r) {
                if (r) {
                    //不保存现编辑行的修改
                    $('#cancelrefexp').click();
                    //调用后台方法 去执行引用
                    var rs = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "SaveReference", result.MKBGARowId, RefMKBTPDObj.MKBTPDRowId, "EditObj");
                    var rs = eval('(' + rs + ')');
                    if (rs.success == 'true') {
                        $.messager.popover({
                            msg: '引用成功！',
                            type: 'success',
                            timeout: 1000
                        });
                        LoadAliasList(GlobalID);
                        LoadReferenceList(GlobalID);
                        $("#tt").tabs('select', "引用场景");
                    };
                } else {
                    return
                }
            })
        } else {
            $.messager.confirm('提示', '列表不存在相同描述,是否新增引用对象?', function(r) {
                if (r) {
                    //不保存现编辑行的修改
                    $('#cancelrefexp').click();
                    //调用后台方法 去执行引用
                    var rs = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "SaveReference", GlobalID, RefMKBTPDObj.MKBTPDRowId, "AddObj");
                    var rs = eval('(' + rs + ')');
                    if (rs.success == 'true') {
                        $.messager.popover({
                            msg: '引用成功！',
                            type: 'success',
                            timeout: 1000
                        });
                        LoadAliasList(GlobalID);
                        LoadReferenceList(GlobalID);
                        $("#tt").tabs('select', "引用场景");
                    };
                } else {
                    return
                }
            })
        };*/
    }
    //fwkreftest  确认引用按钮触发方法
    fwkreftest = function(AliasID) {
        //console.log(MKBGAObj)
        //var AliasID=MKBGAObj.MKBGARowId; 
        var data = $("#iframediagref")[0].contentWindow.getMKBTPDRowId();
        var RefMKBTPDRowID = data.MKBTPDRowId;
        var RefMKBTPDDesc = data.MKBTPDDesc;
        // 判断是否触发自检 如果发起引用的Desc与被引用的Desc 不一致 则触发引用后的自检
        //触发引用后的自检方法
        //console.log(MKBGAObj.MKBGADesc+"--"+RefMKBTPDDesc)
        //if (MKBGAObj.MKBGADesc !== RefMKBTPDDesc) {
            SelfTestAftExpRef(AliasID, data);
            //SelfTestAftExpRef(GlobalID, data);
       /* } else {
            var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "SaveReference", AliasID, RefMKBTPDRowID, "EditObj");
            //var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "SaveReference", MKBGAObj.MKBGARowId, RefMKBTPDRowID, "");
            
            var result = eval('(' + result + ')');
            if (result.success == 'true') {
                $.messager.popover({
                    msg: '引用成功！',
                    type: 'success',
                    timeout: 1000
                });
            };
            //$("#myalias")[0].contentWindow.ClickFun();
            $('#tt').tabs('close', "新增引用");
            //关闭辅助功能区tabs页
            $('#tab_div').tabs('close', "表达式<span class='hidecls'></span>");
            //折叠辅助功能区
            $('#test').layout('collapse', 'east');
            $("#tt").tabs('select', "引用场景");
            LoadAliasList(GlobalID);
            LoadReferenceList(GlobalID);
            
        }
        */
        
    }
    //声明自查列表
    //声明列表
    refdiagexplist = function(listId,data,selectedDesc) {
        //$("#"+listId).datagrid("loadData",[])
        /*var newdata = [];
        var str=""
        if (typeof(data.预测结果)=="string")
        {
            
            var StructValue=tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","GetStructValueByDesc",structname,1);  
            var Type="词表术语"
            if (StructValue!=""){
                var value=StructValue.split("#")[0].split("-")[1]
                if ((value=="")||(value==undefined))    //结构化属性值为空
                {
                    Type="临床实用诊断"
                }
                else
                {
                    Type="常用诊断表达式"
                }
            }
            newdata.push({'normalize':data.预测结果,'prop':Type,'structdata':StructValue})
        }        
        else 
        {
            for(var key2 in data.预测结果){
                var StructValue=tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","GetStructValueByDesc",data.预测结果[key2],1);  
                var Type="词表术语"
                if (StructValue!=""){
                    var value=StructValue.split("#")[0].split("-")[1]
                    if ((value=="")||(value==undefined))    //结构化属性值为空
                    {
                        Type="临床实用诊断"
                    }
                    else
                    {
                        Type="常用诊断表达式"
                    }
                }

                newdata.push({'normalize':data.预测结果[key2],'prop':Type,'structdata':StructValue})
            }
        }
        for(var key in data.分词结果){
           if (key.toString()!="诊断")
            {
                var StructValue=tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","GetStructValueByDesc",data.分词结果[key][key3],1); 
                var Type="词表术语"
                if (StructValue!=""){
                    var value=StructValue.split("#")[0].split("-")[1]
                    if ((value=="")||(value==undefined))    //结构化属性值为空
                    {
                        Type="临床实用诊断"
                    }
                    else
                    {
                        Type="常用诊断表达式"
                    }
                }
                newdata.push({'normalize':data.分词结果[key][key3],'prop':key.toString(),'structdata':StructValue})
            }
            else
            {
                for(var key3 in data.分词结果[key]){
                    newdata.push({'normalize':data.分词结果[key][key3],'prop':key.toString(),'structdata':""})
                }

            }
            
        } */     
        var columns = [
            [{
                field: 'Desc',
                title: '术语',
                width: 100
            },{
                field:'Type',
                title:'术语类别',
                width: 70 
            },{
                field:'Structdata',
                title:'结构化结果',
                width: 70,
                hidden:true
            }
            ]
        ];
        
        $HUI.datagrid('#'+listId, {
            columns: columns, //列信息
            data: data,
            remoteSort: false,
            pagination: false, //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
            singleSelect: true,
            checkOnSelect: false,
            selectOnCheck: false,
            idField: 'MKBTRowId',
            rownumbers: false, //设置为 true，则显示带有行号的列。
            fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            scrollbarSize: 0,
            onClickRow: function(index, row){
                if ($("#tt").tabs('exists', "新增引用")) {
                                $("#tt").tabs('select', "新增引用");
                                $('#addglobalref').css('width','auto');
                            } else {
                                $('#tt').tabs('add', {
                                    title: "新增引用",
                                    id: "addglobalref",
                                    //content:'<span>未能自动匹配到有关诊断</span><iframe id="iframediagref" src="dhc.bdp.ext.sys.csp?BDPMENU=1803"  width="100%" height="700px" frameborder="0">',//里边可以插html内容    
                                    closable: true
                                });
                            };
                
                $('#addglobalref').css('width','auto');
                var matchstr=""
                if ((row.Structdata=="undefined")||(row.Structdata=="undefined"))
                {
                    row.Structdata=""
                }
                var matchstr = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "AliasDescMatchDiag2",row.Desc,row.Structdata); 
                $("#ErrorMessage2").val("")
                if (matchstr!="")
                {
                    MKBTPRowId=matchstr.split("^")[0]
                    structstr=matchstr.split("^")[2]
                    var url="dhc.bdp.mkb.mkbtermprodetaillist.csp?property="+MKBTPRowId+"&detaildesc="+selectedDesc+"&detailstruct="+structstr
                    if ('undefined'!==typeof websys_getMWToken){
                            url += "&MWToken="+websys_getMWToken()
                        }
                    $('#addglobalref').html('<iframe id="iframediagref" src="'+url+'" width="100%" height="779px" frameborder="0">')
                    //parent.$('#addglobalref').html('<iframe id="iframediagref" src="dhc.bdp.mkb.mkbtermprodetaillist.csp?&property="+MKBTPRowId+'&detaildesc='+row.normalize" width="100%" height="779px" frameborder="0">')
                }                             
                else
                {
                    $("#ErrorMessage2").val("未找到该术语对应的临床实用诊断中心词！"); 
                }
               
            }
        });
    }
    
    //指定临床实用诊断引用      应该从别名中添加临床实用诊断标记触发
    /*$('#refdiag_add').click(function(e) {
        //传参 当前被选择的datagrid的id 即可
        var data = $('#globalgrid').datagrid('getSelected')
        var idstr = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "AliasMatchDiag", data.MKBGRowId);
        var idArray = idstr.split(",");
        nowrefableid = 0;
        if (idstr == "") {
            $('#tt').tabs('add', {
                title: "新增引用",
                id: "addglobalref",
                content: '<span>未能自动匹配到有关诊断</span><iframe id="iframediagref" src="dhc.bdp.ext.sys.csp?BDPMENU=1803"  width="100%" height="788px" frameborder="0">', //里边可以插html内容    
                closable: true
            });
        } else {
            $('#tt').tabs('add', {
                title: "新增引用",
                id: "addglobalref",
                content: '<span>已自动匹配有关诊断</span><div><a href="#" id="nextrefid">下一个</a></div><iframe id="iframediagref" src="dhc.bdp.ext.sys.csp?BDPMENU=1803&TermID=' + idArray[nowrefableid] + '"  width="100%" height="788px" frameborder="0">', //里边可以插html内容    
                closable: true
            });
        }
        $('#nextrefid').click(function() {
            nowrefableid = nowrefableid + 1;
            //console.log(idArray[nowrefableid]);
            var termid = idArray[nowrefableid];
            var contenturl = "dhc.bdp.ext.sys.csp?BDPMENU=1803&TermID=" + termid;
            $('#iframediagref').attr('src', contenturl)
        })
    })*/
    ///下拉框组件声明
    $HUI.radio("#LocFreq").setValue(true);
    var statebox = $HUI.combobox("#statebox", {
        valueField: 'id',
        textField: 'text',
        multiple: true,
        rowStyle: 'checkbox', //显示成勾选行形式
        selectOnNavigation: false,
        panelHeight: "auto",
        editable: false,
        data: [{
            id: '1',
            text: '导入待审核',
            selected: true
        }, {
            id: '2',
            text: '已审核'
        }, {
            id: '3',
            text: '常用词'
        }]
    });
    var markbox = $HUI.combobox("#markbox", {
        valueField: 'id',
        textField: 'text',
        multiple: true,
        rowStyle: 'checkbox', //显示成勾选行形式
        selectOnNavigation: false,
        panelHeight: "auto",
        editable: false,
        data: [{
            id: '1',
            text: '主要部位',
            selected: true
        }, {
            id: '2',
            text: '临床实用诊断',
            selected: true
        }, {
            id: '3',
            text: '常用诊断描述',
            selected: true
        }, {
            id: '4',
            text: '业务诊断',
            selected: true
        }]
    });
    var prefixbox = $HUI.combobox("#prefixbox", {
        valueField: 'id',
        textField: 'text',
        multiple: true,
        rowStyle: 'checkbox', //显示成勾选行形式
        selectOnNavigation: false,
        panelHeight: "auto",
        editable: false,
        data: [{
            id: '1',
            text: '左'
        }, {
            id: '2',
            text: '右'
        }, {
            id: '3',
            text: '双'
        }, {
            id: '4',
            text: '左侧'
        }, {
            id: '5',
            text: '右侧'
        }, {
            id: '6',
            text: '双侧'
        }]
    });
    //关联并发症下拉框
    $('#stembox').combobox({
        //url: $URL + "?ClassName=web.DHCBL.CDSS.DiseJoinDiffDiag&QueryName=DiffDiagSource&ResultSetType=array",
        valueField: 'MKBDiagDR',
        textField: 'MKBDiagDesc',
        /*valueField: 'ComplicationDR',
        textField: 'ComplicationDesc',*/
        //mode:'remote',
        panelWidth: 250,
        delay: 1000,
        keyHandler: {
            query: function(q) {
                $(this).combobox("setValue", q);
                var object = new Object();
                object = $(this)
                if (this.AutoSearchTimeOut) {
                    window.clearTimeout(this.AutoSearchTimeOut)
                    this.AutoSearchTimeOut = window.setTimeout(LoadStemData(q, object), 1000)
                } else {
                    this.AutoSearchTimeOut = window.setTimeout(LoadStemData(q, object), 1000)
                }
            }
        }
    });
    LoadStemData = function(q, obj) {
        var url = $URL + "?ClassName=web.DHCBL.MKB.MKBGlobal&QueryName=StemWordSource&q=" + encodeURIComponent(q) + "&ResultSetType=array";
        $('#stembox').combobox('reload', url)
    }
    var suffixbox = $HUI.combobox("#suffixbox", {
        valueField: 'id',
        textField: 'text',
        multiple: true,
        rowStyle: 'checkbox', //显示成勾选行形式
        selectOnNavigation: false,
        panelHeight: "auto",
        editable: false,
        data: [{
            id: '1',
            text: '?'
        }, {
            id: '2',
            text: '不除外'
        }, {
            id: '3',
            text: '可能性大'
        }, {
            id: '4',
            text: '待除外'
        }, {
            id: '5',
            text: '术后'
        }, {
            id: '6',
            text: '术前'
        }, {
            id: '6',
            text: '疗效待审核'
        }]
    });
   
    var columns = [
        [/*{
            field: 'ck',
            checkbox: true,
        }, */{
            field: 'MKBGRowId',
            title: 'MKBGRowId',
            //sortable: true,
            width: 100,
            hidden: true
        }, {
            field: 'MKBGCode',
            title: '编码',
            //sortable: true,
            width: 100,
            hidden: true
        }, {
            field: 'MKBGDisplaName',
            title: '展示名',
            width: 100,
            editor: 'validatebox'
            
        },{
            field: 'MKBGDesc',
            title: '中心词',
            //sortable: true,
            width: 100,
            editor: 'validatebox',
            hidden: true
        }, {
            field: 'MKBGEnName',
            title: '英文名',
            //sortable: true,
            width: 50,
            editor: 'validatebox',
            hidden: true
        }, {
            field: 'MKBGNote',
            title: '备注',
            //sortable: true,
            width: 600,
            hidden: true,
            //fixed: true,
            editor: {
                type: 'textarea'
            },
            formatter: function(value, row, index) {
                //鼠标悬浮显示备注信息
                return '<span class="mytooltip" title="' + row.MKBGNote + '">' + value + '</span>'
            }
        }, {
            field: 'MKBGAlias',
            title: '别名',
            width: 100,
            hidden: true
        }, {
            field: 'MKBGPYCode',
            title: '检索码',
            //sortable: true,
            width: 100,
            hidden: true,
            editor: 'validatebox'
        }, {
            field: 'MKBGLastLevel',
            title: '引用位置',
            //sortable: true,
            hidden: true,
            width: 100
        }, {
            field: 'MKBGState',
            title: '状态',
            //sortable: true,
            hidden: true,
            width: 100,
            formatter: function(value, row, index) {
                if (value == "U") {
                    return '<span href="#" title="在用"  class="mytooltip">在用</span>';
                } else if (value == "S") {
                    return '<span href="#" title="封闭" class="mytooltip">封闭</span>';
                } else if (value == "D") {
                    return '<span href="#" title="删除" class="mytooltip">删除</span>';
                } else if (value == "M") {
                    return '<span href="#" title="合并" class="mytooltip">合并</span>';
                }
            }
        }, {
            field: 'MKBGConfirm',
            title: '确认状态',
            width: 100,
            hidden: true,
            styler: function(value, row, index) {
                if (value == "Y") {
                    return 'background-color:#33FF66;';
                } else {
                    return 'background-color:#FF0033;';
                }
            },
            formatter: function(value, row, index) {
                if (value == "Y") {
                    return '<span href="#" title="已确认"  class="mytooltip">已确认</span>';
                } else {
                    return '<span href="#" title="未确认" class="mytooltip">未确认</span>';
                }
            }
        }, {
            field: 'TopDataFlag',
            title: 'TopDataFlag',
            width: 80,
            hidden: true
        }, {
            field: 'MKBGloMark',
            title: '标记',
            width: 80,
            hidden: true
        }, {
            field: 'MKBGDiaTotalFreq',
            title: '频次',
            width: 80,
            hidden: true
        }]
    ];
    var mygrid = $HUI.datagrid("#globalgrid", {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCBL.MKB.MKBGlobal", /////////***************
            QueryName: "GetList",
            'desc': DataDesc,
            'Type': Type,
            'MarkStr': MKBGMark
        },
        columns: columns, //列信息
        pagination: true, //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize: 20,
        pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500, 1000],
        singleSelect: true,
        checkOnSelect: false,
        selectOnCheck: false,
        remoteSort: false,
        idField: 'MKBGRowId',
        rownumbers: false, //设置为 true，则显示带有行号的列。
        //fixRowNumber: true,
        fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        scrollbarSize: 0,
        onDblClickRow: function(rowIndex, rowData) {
            // DblClickFun(rowIndex, rowData)
        },
        onClickRow: function(index, row) {
            
            SetHeight();
            ClickFun();
            GlobalID = row.MKBGRowId;
            LoadEditList(row);
            LoadAliasList(GlobalID);
            LoadReferenceList(GlobalID);
            RefreshSearchData("User.MKBGlobal", GlobalID, "A", row.MKBGDisplaName)
            if ($("#tab_div").tabs('exists', "术语拆分<span class='hidecls'></span>"))
            {
                $("#ErrorBox").val("");
                $('#splitaliaslist').datagrid("loadData",[])
                $('#splitreflist').datagrid("loadData",[])
            }
                
            
        },
        onCheck: function(index, row) {
            //TopCheckData(row) //当勾选的时候自动置顶该数据
            $('#reloadlist').click();
        },
        onUncheck: function(index, row) {
            $('#reloadlist').click();
        },
        onLoadSuccess: function(data) {
            SetHeight();
            //保留置顶数据
            for (var i = 0; i < topdata.length; i++) {
                var rowindex = $('#globalgrid').datagrid('getRowIndex', topdata[i].MKBGRowId);
                //console.log(topdata[i].MKBGRowId)
                if (rowindex >= 0) {
                    $('#globalgrid').datagrid('deleteRow', rowindex);
                }
                $('#globalgrid').datagrid('insertRow', {
                        index: 0, // index start with 0
                        row: {
                            MKBGRowId: topdata[i].MKBGRowId, //record.MKBTDescFramework\icons\mkb
                            MKBGDesc: topdata[i].MKBGDesc + "<img src='../scripts/bdp/Framework/icons/mkb/nail.png' ></img>",
                            MKBGPYCode: topdata[i].MKBGPYCode,
                            MKBGNote: topdata[i].MKBGNote,
                            TopDataFlag: "top"
                        }
                    }),
                    $('#globalgrid').datagrid('freezeRow', 0);
            }
            LoadExDisplayList(data);
            if (data.total == 0) {
                return
            }
            if (mergedata !== undefined) {
                /*var index = $('#globalgrid').datagrid('getRowIndex', mergedata.MKBGRowId);
                $("#globalgrid").datagrid('selectRow', index);*/
                LoadEditList(mergedata);
                LoadAliasList(mergedata.MKBGRowId);
                LoadReferenceList(mergedata.MKBGRowId);
                mergedata = undefined;
            }
            else {
                if (SearchGlobalDesc!="")
                {
                    var existstr = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","IsExist",SearchGlobalDesc,"","","");
                    var existflag=existstr.split("^")[0]
                    if (existflag==1)
                    {
                        var gloablflag=existstr.split("^")[1]
                        var TheID=existstr.split("^")[2]
                        if (gloablflag==1)
                        {
                            var seGlobalID=TheID
                        }
                        else
                        {
                            var seGlobalID=TheID.split("||")[0]
                        }
                        var thedata=tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",seGlobalID);
                        var thedata=eval('('+thedata+')');
                        GlobalID = seGlobalID
                        LoadEditList(thedata);
                        LoadAliasList(GlobalID);
                        LoadReferenceList(GlobalID);
                        /*$('#referencecenterlistgrid').datagrid('load',  { 
                            ClassName:"web.DHCBL.MKB.MKBGlobal",
                            QueryName:"GetReferenceList",    
                            'GlobalRowId':GlobalID
                        });*/
                        //LoadReferenceList(GlobalID);
                        if (jumpoption==2)
                        {
                            $("#tt").tabs('select', "引用场景");
                        }
                        else if (jumpoption==3)    //存在术语需要合并
                        {
                            if ((mergeidstr!="")&&(mergeidstr!=","))
                            {
                                MergeDataFunlib()
                                $('#mergelist').datagrid("loadData",[])
                                var len=mergeidstr.split(",").length
                                for (m=0;m<len;m++)
                                {
                                    var merid= mergeidstr.split(",")[m]
                                    var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",merid);                  
                                    var rowdata=eval('('+rowdata+')');
                                    $('#mergelist').datagrid('insertRow',{ row:rowdata});
                                }
                                    
                            }
                        }
                                                
                        
                    }
                    $('#westTextDesc').combobox('setValue',SearchGlobalDesc)
                }
                else{
                    $("#globalgrid").datagrid('selectRow', 0);
                    GlobalID = data.rows[0].MKBGRowId
                    LoadEditList(data.rows[0]);
                    LoadAliasList(GlobalID);
                    LoadReferenceList(GlobalID);
                }
                    
            }
                
            
            
        },
        onRowContextMenu: function(e, rowIndex, rowData) {
            var $clicked = $(e.target);
            copytext = $clicked.text() || $clicked.val() //普通复制功能
            e.preventDefault(); //阻止浏览器捕获右键事件
            var record = $(this).datagrid("selectRow", rowIndex); //根据索引选中该行 
            //置顶、取消置顶是否可用
            var stickDisable = false,
                cancelstickDisable = false
            if (rowData.TopDataFlag == "top") {
                stickDisable = true
            } else {
                cancelstickDisable = true
            }
            var mygridmm = $('<div style="width:120px;"></div>').appendTo('body');
            //mygridmm.html('<div onclick="TopData()" iconCls="icon-stick" data-options="disabled:' + stickDisable + '" id="stick">置顶</div>' + '<div onclick="CancelTopData()" iconCls="icon-cancelstick" data-options="disabled:' + cancelstickDisable + '" id="cancelstick">取消置顶</div>' + '<div id="del_menu" onclick="DelGlobal()" iconCls="icon-cancel" data-options="">删除</div>' + '<div id="merge_menu" onclick="MergeGlobal()" iconCls="icon-paper-link" data-options="">合并</div>' + '<div id="copy_menu" onclick="CopyText()" iconCls="icon-copy" data-options="">复制</div>' + '<div id="same_menu" onclick="SameGlobal()" iconCls="icon-paper-link" data-options="">查看同名</div>' + '<div id="confirm_menu" onclick="ConfirmGlobal()" iconCls="icon-ok" data-options="">确认</div>' + '<div id="merge_menu" onclick="MergeGlobal()" iconCls="icon-paper-link" data-options="">查看子元素</div>').click(stopPropagation);
            mygridmm.html('<div onclick="TopData()" iconCls="icon-stick" data-options="disabled:' + stickDisable + '" id="stick">置顶</div>' + '<div onclick="CancelTopData()" iconCls="icon-cancelstick" data-options="disabled:' + cancelstickDisable + '" id="cancelstick">取消置顶</div>' + '<div id="del_menu" onclick="DelGlobal()" iconCls="icon-cancel" data-options="">删除</div>' + '<div id="copy_menu" onclick="CopyText()" iconCls="icon-copy" data-options="">复制</div>' + '<div id="same_menu" onclick="SameGlobal()" iconCls="icon-paper-link" data-options="">查看同名</div>' + '<div id="confirm_menu" onclick="ConfirmGlobal()" iconCls="icon-ok" data-options="">确认</div>').click(stopPropagation);  // + '<div id="merge_menu" onclick="MergeGlobal()" iconCls="icon-paper-link" data-options="">查看子元素</div>'
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
        toolbar: '#globalTools'
    });
    //加载扩展展示列表
    LoadExDisplayList = function(data) {
        var Excolumns = [
            [{
                field: 'MKBGRowId',
                title: 'MKBGRowId',
                //sortable: true,
                width: 100,
                hidden: true
            }, {
                field: 'MKBGCode',
                title: '编码',
                //sortable: true,
                width: 100,
                hidden: true
            }, {
                field: 'MKBGDesc',
                title: '术语名',
                //sortable: true,
                width: 200,
                editor: 'validatebox'
            }, {
                field: 'MKBGDiaTotalFreq',
                title: '频次',
                width: 80
            }, {
                field: 'MKBGloMark',
                title: '标记',
                width: 80
            }, {
                field: 'MKBGEnName',
                title: '英文名',
                //sortable: true,
                width: 50,
                editor: 'validatebox',
                hidden: true
            }, {
                field: 'MKBGAlias',
                title: '别名',
                width: 100,
            }, {
                field: 'MKBGPYCode',
                title: '检索码',
                //sortable: true,
                width: 100,
                editor: 'validatebox',
                hidden: true
            }, {
                field: 'MKBGLastLevel',
                title: '引用位置',
                //sortable: true,
                hidden: true,
                width: 100
            }, {
                field: 'MKBGState',
                title: '状态',
                //sortable: true,
                width: 100,
                hidden: true,
                formatter: function(value, row, index) {
                    if (value == "U") {
                        return '<span href="#" title="在用"  class="mytooltip">在用</span>';
                    } else if (value == "S") {
                        return '<span href="#" title="封闭" class="mytooltip">封闭</span>';
                    } else if (value == "D") {
                        return '<span href="#" title="删除" class="mytooltip">删除</span>';
                    } else if (value == "M") {
                        return '<span href="#" title="合并" class="mytooltip">合并</span>';
                    }
                }
            }, {
                field: 'MKBGConfirm',
                title: '确认状态',
                width: 100,
                hidden: true,
                styler: function(value, row, index) {
                    if (value == "Y") {
                        return 'background-color:#2AB66A;';
                    } else {
                        return 'background-color:#FFB746;';
                    }
                },
                formatter: function(value, row, index) {
                    if (value == "Y") {
                        return '<span href="#" title="已确认"  class="mytooltip"><font color="#FFFFFF">已确认</font></span>';
                    } else {
                        return '<span href="#" title="未确认" class="mytooltip"><font color="#FFFFFF">未确认</font></span>';
                    }
                }
            }, {
                field: 'TopDataFlag',
                title: 'TopDataFlag',
                width: 80,
                hidden: true
            }, {
                field: 'MKBGNote',
                title: '备注',
                //sortable: true,
                width: 300,
                //fixed: true,
                editor: {
                    type: 'textarea'
                },
                formatter: function(value, row, index) {
                    //鼠标悬浮显示备注信息
                    return '<span class="mytooltip" title="' + row.MKBGNote + '">' + value + '</span>'
                }
            }]
        ];
        var ExDisplaygrid = $HUI.datagrid("#ExDisplaygrid", {
            data: data,
            columns: Excolumns, //列信息
            pagination: false, //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
            pageSize: 20,
            pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500, 1000],
            singleSelect: true,
            checkOnSelect: false,
            selectOnCheck: false,
            remoteSort: false,
            idField: 'MKBGRowId',
            rownumbers: false, //设置为 true，则显示带有行号的列。
            //fixRowNumber: true,
            fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            scrollbarSize: 0,
            onLoadSuccess: function(data) {
                //保留置顶数据
                for (var i = 0; i < topdata.length; i++) {
                    var rowindex = $('#ExDisplaygrid').datagrid('getRowIndex', topdata[i].MKBGRowId);
                    //alert(rowindex)
                    if (rowindex >= 0) {
                        $('#ExDisplaygrid').datagrid('deleteRow', rowindex);
                    }
                    $('#ExDisplaygrid').datagrid('insertRow', {
                            index: 0, // index start with 0
                            row: {
                                MKBGRowId: topdata[i].MKBGRowId, //record.MKBTDescFramework\icons\mkb
                                MKBGDesc: topdata[i].MKBGDesc + "<img src='../scripts/bdp/Framework/icons/mkb/nail.png' ></img>",
                                MKBGPYCode: topdata[i].MKBGPYCode,
                                MKBGNote: topdata[i].MKBGNote,
                                MKBGAlias: topdata[i].MKBGAlias,
                                MKBGState: topdata[i].MKBGState,
                                MKBGConfirm: topdata[i].MKBGConfirm,
                                TopDataFlag: "top"
                            }
                        }),
                        $('#ExDisplaygrid').datagrid('freezeRow', 0);
                }
            }
        })
    }
    //扩展置顶数据更新方法
    UpdateExDisplayList = function() {
        //保留置顶数据
        for (var i = 0; i < topdata.length; i++) {
            var rowindex = $('#ExDisplaygrid').datagrid('getRowIndex', topdata[i].MKBGRowId);
            //alert(rowindex)
            if (rowindex >= 0) {
                $('#ExDisplaygrid').datagrid('deleteRow', rowindex);
            }
            $('#ExDisplaygrid').datagrid('insertRow', {
                    index: 0, // index start with 0
                    row: {
                        MKBGRowId: topdata[i].MKBGRowId, //record.MKBTDescFramework\icons\mkb
                        MKBGDesc: topdata[i].MKBGDesc + "<img src='../scripts/bdp/Framework/icons/mkb/nail.png' ></img>",
                        MKBGPYCode: topdata[i].MKBGPYCode,
                        MKBGNote: topdata[i].MKBGNote,
                        MKBGAlias: topdata[i].MKBGAlias,
                        MKBGState: topdata[i].MKBGState,
                        MKBGConfirm: topdata[i].MKBGConfirm,
                        TopDataFlag: "top"
                    }
                }),
                $('#ExDisplaygrid').datagrid('freezeRow', 0);
        }
    }
    
    //让datagrid默认选中第一行
    LoadReferenceList = function(GlobalID) 
    {
        
    
        //加载引用场景tabel
        var referencecolumns = [
            [{
                field: 'MKBGRRowId',
                title: 'RowId',
                hidden: true,
                width: 100,
                resizable: true
            }, {
                field: 'MKBGRCode',
                title: '代码',
                width: 100,
                hidden: true,
                formatter: function(value, row, index) {
                    return '<span class="hisui-tooltip" title="' + row.MKBGRCode + '">' + value + '</span>'
                } //注意tooltip标签与分词标记区分，分词点击事件有冲突
            }, {
                field: 'MKBGRDesc',
                title: '名称',
                hidden: false,
                width: 100,
                formatter: function(value, row, index) {
                    return '<span class="hisui-tooltip" title="' + row.MKBGRDesc + '">' + value + '</span>'
                } //注意tooltip标签与分词标记区分，分词点击事件有冲突
            }, {
                field: 'MKBGRType',
                title: '所属类型',
                hidden: false,
                width: 100,
                hidden: true
            }, {
                field: 'MKBGRLevel',
                title: '引用位置',
                hidden: false,
                width: 150,
                formatter: function(value, row, index) {
                    return '<span class="hisui-tooltip" title="' + row.MKBGRLevel + '">' + value + '</span>'
                } //注意tooltip标签与分词标记区分，分词点击事件有冲突
            }, {
                field: 'MKBGRLastLevel',
                title: '上级节点',
                hidden: true,
                width: 150,
                formatter: function(value, row, index) {
                    return '<span class="hisui-tooltip" title="' + row.MKBGRLastLevel + '">' + value + '</span>'
                } //注意tooltip标签与分词标记区分，分词点击事件有冲突
            }, {
                field: 'MKBGRPYCode',
                title: '检索码',
                hidden: true,
                width: 100
            }, {
                field: 'MKBGRNote',
                title: '备注',
                hidden: true,
                width: 100,
                formatter: function(value, row, index) {
                    return '<span class="hisui-tooltip" title="' + row.MKBGRNote + '">' + value + '</span>'
                } //注意tooltip标签与分词标记区分，分词点击事件有冲突
            }]
        ];
        //var mygrid = $HUI.datagrid("#globalgrid", {
        var referencelist = $HUI.datagrid("#referencecenterlistgrid", {
            url: $URL, //QUERY_ACTION_URL
            queryParams: {
                ClassName: "web.DHCBL.MKB.MKBGlobal",
                QueryName: "GetReferenceList",
                'GlobalRowId': GlobalID
            },
            columns: referencecolumns, //列信息
            singleSelect: true,
            rownumbers: false, //设置为 true，则显示带有行号的列。
            fixRowNumber: true,
            fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            //toolbar: '#referenceTools',
            scrollbarSize: 0,
            onRowContextMenu: function(e, rowIndex, rowData) {
                var $clicked = $(e.target);
                e.preventDefault(); //阻止浏览器捕获右键事件
                var record = $(this).datagrid("selectRow", rowIndex); //根据索引选中该行 
                var mygridmm = $('<div style="width:120px;"></div>').appendTo('body');
                mygridmm.html('<div id="merge_menu" onclick="JumptoPage()" iconCls="icon-paper-link" data-options="">跳转界面</div><div id="deletereference" onclick="DeleteReference()" iconCls="icon-cancel" data-options="">删除</div>').click(stopPropagation);
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
            onDblClickRow: function(rowIndex, rowData) {
                //$('#test').layout('expand', 'east');
                LoadFZ(rowData.MKBGRRowId, rowData.MKBGRDesc);
                //JumptoPage();
            },
            onClickRow: function(rowIndex, rowData) {
                if ($("#tab_div").tabs('exists', "术语拆分<span class='hidecls'></span>"))
                {
                    var sameflag=0
                    var listRows=$('#splitreflist').datagrid('getRows')
                    for (var i=0;i<listRows.length;i++)
                    {
                        if (listRows[i].ID==rowData.MKBGRRowId)
                        {
                            sameflag=1
                        }
                    }   
                    if (sameflag==0) //不存在重复
                    {
                        $('#splitreflist').datagrid('insertRow',{ row: {
                            ID: rowData.MKBGRRowId,Desc: rowData.MKBGRDesc,Place:rowData.MKBGRLevel
                        } });
                    }
                }                                
            },
            onBeforeLoad: function (param) {
                /*var firstLoad = $(this).attr("firstLoad");
                if (firstLoad == "false" || typeof (firstLoad) == "undefined")
                {
                    $(this).attr("firstLoad","true");
                    
                    return false;
                }
                return true;*/
            }
        })
    }
    //引用场景跳转界面按钮
    JumptoPage = function() {
        var data = $('#referencecenterlistgrid').datagrid('getSelected')
        var referenceid = data.MKBGRRowId
        // 拿id去取termid
        var idstr = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "Returntermproid", referenceid);
        var idArray = idstr.split(",");
        //2166,临床实用诊断,15879,9440054
        var termid=idArray[2]
        var property=idArray[3]
        //alert(termid)
        if (idArray[2] == "" || idArray[2] == undefined) {
            $.messager.alert('错误提示', '请先选择一条诊断记录!', "error");
        } else {
            //var menuid = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine", "GetID", "dhc.bdp.mkb.mtm.Diagnosis");
            var parentid = "" //tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm");
            var menuimg = "" //tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetIconByID",menuid);
            //判断浏览器版本
            var Sys = {};
            var ua = navigator.userAgent.toLowerCase();
            var s;
            (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
            (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
            (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
            (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
            (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
            //if(!Sys.ie){
            window.parent.parent.closeNavTab(idArray[0])
            window.parent.parent.showNavTab(idArray[0], idArray[1], 'dhc.bdp.ext.sys.csp?BDPMENU=' + idArray[0] + "&TermID=" + idArray[2] + "&ProId=" + idArray[3], parentid, menuimg)
            //}else{
            //  parent.PopToTab(menuid,"临床实用诊断",'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&TermID="+termid+"&ProId=",menuimg);
            //  }
        }
    }
    //引用场景删除按钮
    DeleteReference = function(){
        
        var record = $("#referencecenterlistgrid").datagrid("getSelected");
        
        if (!(record)) {
            $.messager.alert('错误提示', '请先选择一条记录!', "error");
            return;
        }
        if ((record.MKBGRRowId == undefined) || (record.MKBGRRowId == "")) {
            referencelist.deleteRow(editIndex)
            editIndex = undefined;
            return;
        }
        $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r) {
            if (r) {
                $.ajax({
                    url: "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBGlobal&pClassMethod=DeleteReferenceData",
                    data: {
                        "Id": record.MKBGRRowId ///rowid
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
                            $('#referencecenterlistgrid').datagrid('reload'); // 重新载入当前页面数据  
                            $('#referencecenterlistgrid').datagrid('unselectAll'); // 清空列表选中数据
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
    //设置页签的高度
    SetHeight = function() {
        fasterHeight = $('#layoutedit').height();
        $("#tt").css({
            height: fasterHeight+ 'px'
        });
        $("#ttt").css({
            height: fasterHeight-37 + 'px'
        });
        $("#reftabs").css({
            height: fasterHeight-37 + 'px'
        });
        $("#ExDisplay").css({
            height: fasterHeight-37 + 'px'
        })
        $("#EchartsDisplay").css({
            height: fasterHeight-37 + 'px'
        })
    }
   /*
    //搜索按钮
    $("#globalbtnSearch").click(function(e) {
        var re = [];
        $("body").find("input[type='checkbox']:checked").each(function() {
            re.push($(this).val());
        })
        var SearchStr = re.join(",");
        SearchGlobal(SearchStr);
    })
    */
    //清屏按钮
    $("#globalbtnWestRefresh").click(function(e) {
        
        ClearGlobal();
        $("#globalgrid").datagrid('unselectAll');
        //$("#globalgrid").datagrid('uncheckAll');
        $('#globalgrid').datagrid('clearChecked'); //清除所有勾选的行。
    })
    //多音字批处理按钮
    $("#PYMEdit").click(function(e) {
        PYEditWin();
    })
    //查询配置按钮
    $("#SearchSet").click(function(e) {
        SearchSetWin();
    })
    //组词查询按钮
    $("#CreateWord").click(function(e) {
        CreateWordWin();
    })
    //组合查询
    $("#ConditionSearch").click(function(e) {
        ConditionSearchFunlib();
    })
    //ICD查询
    $("#ICDSearch").click(function(e) {
        RefICDSearchFunlib();
    })

    //新增按钮弹窗新增
    $("#globaladd_btn").click(function(e) {
        AddGlobalFun()
    })
    //删除方法
    DelGlobal = function() {
        if (GlobalID!=undefined)
        {
            var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",GlobalID)
            var rowdata=eval('('+rowdata+')');
            var GlobalDesc=rowdata.MKBGDesc
            $.messager.confirm('提示', '确定彻底删除术语条目"'+GlobalDesc+'"吗?', function(r){
                if (r){
                    var result=tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","DelGlobalData",GlobalID);
                    if (result.indexOf("true")>=0)
                    {
                        $("#globalgrid").datagrid('reload');
                        $("#globalgrid").datagrid('selectRow', 0);
                        var record=$("#globalgrid").datagrid('getSelected')
                        GlobalID = record.MKBGRowId
                        LoadEditList(record);
                        LoadAliasList(GlobalID);
                        LoadReferenceList(GlobalID);
                        
                        $.messager.popover({msg: '删除成功！',type: 'success',timeout: 1000});
                    }
                    else
                    {
                        //errorinfo
                        $.messager.alert('错误提示','删除失败!<br/>错误信息:'+ result.errorinfo,"info");
                    }

                }
            });
                
        }
        else
        {
            $.messager.alert('错误提示', '请先选择一条记录!', "error");
            return;
        }

        
    }

    //删除术语按钮
    $("#DelData").click(function(e) {        
        DelGlobal()
    })
    //ICD查询
    var RefICDSearchFunlib=function(){
        $('#test').layout('expand', 'east');
        $("#myTaglist").css("left", "140px");
        if ($("#tab_div").tabs('exists', "ICD查询"+"<span class='hidecls'></span>")) {
            $("#tab_div").tabs('select', "ICD查询"+"<span class='hidecls'></span>");
        } else {
            $('#tab_div').tabs('add', {
                title: "ICD查询"+"<span class='hidecls'></span>",
                id: "RefICDSearch",
                closable: true,
            });
        };
        // 辅助功能区表达式页签增加html代码
        $('.tabs .tabs-inner').css('line-height', '16px');
        $('.tabs .tabs-inner').css('height', 'auto');
        $('.tabs .tabs-inner').css('padding', '6px');
       // $('.tabs .tabs-inner .tabs-title').css('white-space', 'pre-wrap');
        $('#test').layout('expand', 'east');    //展开辅助功能区
        //$("#RefICDSearch").html('<div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="startsearchreficd">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="endsearchreficd">放弃操作</a></td></tr></table></div>')
        $("#RefICDSearch").html('<div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="startsearchreficd">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="endsearchreficd">放弃操作</a></td></tr></table><table style="padding:0 7px;padding-bottom:20px"  id="ErrorTable"><tr><td style="padding:10px 0;text-align: center;">报错信息</td></tr><tr><td><textarea id="ICDSearchBox" style="height:100px;width:265px;"></textarea></td></tr></table></div>')

         // 渲染按钮
        $("#startsearchreficd").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
         // 渲染按钮
        $("#endsearchreficd").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
        //开始按钮
        $('#startsearchreficd').click(function(e) {
            $("#ICDSearchBox").val("")
            var SearchICDCode=""
            var record=$("#referencecenterlistgrid").datagrid("getSelected")
            if (record)
            {
                var str=record.MKBGRLevel
                if (str.indexOf("ICD")!=-1)
                {
                    var symbodlegth=str.split("(").length
                    SearchICDCode=str.split("(")[symbodlegth-1].split(")")[0]
                    $('#searchicd').val(SearchICDCode)
                }
            } 
            else
            {
                $("#ICDSearchBox").val('请选择一个ICD引用!')
                //$.messager.alert('错误提示', '请选择一个ICD引用!', "error");
                return
            }
            if  (SearchICDCode!="")
            {
                ICDSearchFun(SearchICDCode) 
            } 
            else
            {
                $("#ICDSearchBox").val('请选择一个ICD引用!')
                //$.messager.alert('错误提示', '请选择一个ICD引用!', "error");
                return
            }
                                  
        })
        //关闭ICD查询页签
        $('#endsearchreficd').click(function(e) {
            $('#tab_div').tabs('close', "ICD查询<span class='hidecls'></span>");
            $('#test').layout('collapse', 'east');
        })
                                         
    }

    ICDSearchFun=function(SearchICDCode){
        if ($("#tab_div").tabs('exists', "查询结果<span class='hidecls'></span>")) {
            $("#tab_div").tabs('select', "查询结果<span class='hidecls'></span>");
        } else {
            $('#tab_div').tabs('add', {
                title: "查询结果<span class='hidecls'></span>",
                //id: "tab_" + MKBGRRowId
                id: "SearchICDCode",
                //content:'Tab Body',//里边可以插html内容    
                closable: true,
                //href:url
            });
        };
        // 辅助功能区表达式页签增加html代码
        $("#SearchICDCode").css('position', 'relative');
        //<a style="color:#000" >处理内容:'+data.MKBGADesc+'</a></div><div style="width:100%;height:300px;">

          // $("#SearchICDCode").html('<div ><a style="color:#000" >查询ICD:'+SearchICDCode+'</a></div><div><a style="color:#000" >全部搜索结果:</a></div ><div style="height:80%"><table data-options="fit:true" style="width:100%;position:absolute;height:90%" id="SearchICDCode" ></table></div >');
    $("#SearchICDCode").html('<div ><a style="color:#000" >查询ICD:'+SearchICDCode+'</a></div><div><a style="color:#000" >全部搜索结果:</a></div ><div style="height:80%"><table data-options="fit:true" style="width:100%;position:absolute;height:90%" id="ResultListDiv" ></table></div >');
   
    
        var GlobalTable = $('<table data-options="fit:true"  id="SICDCoderesultlist" border="false"></table>')
        $("#ResultListDiv").html(GlobalTable);               
        
            //MKBGRowId,MKBGDesc,Type
            var resultcolumns = [
                [{
                    field: 'CK',
                    checkbox:"true"
                },{ 
                
                    field: 'MKBGRowId',
                    title: 'MKBGRowId',
                    //sortable: true,
                    width: 100,
                    hidden: true
                }, {
                    field: 'MKBGDesc',
                    title: '展示名',
                    //sortable: true,
                    width: 100
                }, {
                    field: 'Type',
                    title: '来源',
                    width: 100,
                    hidden: true
                    
                }]
            ];

            $HUI.datagrid("#SICDCoderesultlist", {
                url: $URL,
                queryParams: {
                    ClassName: "web.DHCBL.MKB.MKBGlobal", 
                    QueryName: "GetICDList",                    
                    
                    'ICDCode':SearchICDCode
                },
                columns:resultcolumns,
                remoteSort: false,
                pagination: true, //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
                pageSize: 20,
                pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500, 1000],
                singleSelect: true,    //允许多选
                checkOnSelect: false,
                selectOnCheck: false,
                idField: 'MKBGRowId',
                rownumbers: false, //设置为 true，则显示带有行号的列。
                fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
                scrollbarSize: 0,
                onSelect: function(index, row){
                    SetHeight();
                    
                    var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",row.MKBGRowId)
                    
                    var rowdata=eval('('+rowdata+')'); 
                    GlobalID=row.MKBGRowId                                       
                    LoadEditList(rowdata);
                    LoadAliasList(GlobalID);
                    LoadReferenceList(GlobalID);                   
                },
                onCheck: function(index, row){
                        
                    if ($("#tab_div").tabs('exists', "术语合并<span class='hidecls'></span>")) {
                        var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",row.MKBGRowId)
                        
                        var rowdata=eval('('+rowdata+')');
                        var rowindex=$('#mergelist').datagrid("getRowIndex",rowdata.MKBGRowId)
                        var recordss=$('#mergelist').datagrid("getRows")

                        if (rowindex==-1)
                        {
                            $('#mergelist').datagrid('insertRow',{ row:rowdata});                                
                        }
                        
                    }
                },
                onUncheck:function(index, row){
                    if ($("#tab_div").tabs('exists', "术语合并<span class='hidecls'></span>")) {
                        
                        var nindex=$('#mergelist').datagrid("getRowIndex",row.MKBGRowId)
                        if (nindex!=-1)
                        {
                            $('#mergelist').datagrid('deleteRow',nindex);
                        }
                        
                    }
                },
                /*onUnselect:function(index, row){
                    if ($("#tab_div").tabs('exists', "术语合并<span class='hidecls'></span>")) {
                        
                        var nindex=$('#mergelist').datagrid("getRowIndex",row.MKBGRowId)
                        if (nindex!=-1)
                        {
                            $('#mergelist').datagrid('deleteRow',nindex);
                        }
                        
                    }
                },*/
                onLoadSuccess:function(data){
                    $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
                    $(this).datagrid('columnMoving'); //列可以拖拽改变顺序
                     //$("#allresultlist_"+text).datagrid('selectRow', 0);
                }
            });
        
    }

    //组合查询
    var ConditionSearchFunlib=function(){
        $('#test').layout('expand', 'east');
        $("#myTaglist").css("left", "140px");
        if ($("#tab_div").tabs('exists', "组合查询"+"<span class='hidecls'></span>")) {
            $("#tab_div").tabs('select', "组合查询"+"<span class='hidecls'></span>");
        } else {
            $('#tab_div').tabs('add', {
                title: "组合查询"+"<span class='hidecls'></span>",
                id: "ConditionSearch",
                closable: true,
            });
        };
        // 辅助功能区表达式页签增加html代码
        $('.tabs .tabs-inner').css('line-height', '16px');
        $('.tabs .tabs-inner').css('height', 'auto');
        $('.tabs .tabs-inner').css('padding', '6px');
       // $('.tabs .tabs-inner .tabs-title').css('white-space', 'pre-wrap');
        $('#test').layout('expand', 'east');    //展开辅助功能区
        //$("#ConditionSearch").html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">名称</td><td style="padding:10px 0"><select id="trunksymbol" style="width:65px;"></select></td><td><input id="trunktext" style="width:150px;"></td></tr><tr><td style="padding:10px 0">别名标志</td><td style="padding:10px 0"><a style="width:65px;padding-left: 20px;">等于</a><td><select id="markbox" style="width:150px;"></select></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="startsearch">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="endsearch">放弃操作</a></td></tr></table></div>')
        $("#ConditionSearch").html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">名称</td><td style="padding:10px 0"><select id="trunksymbol" style="width:65px;"></select></td><td><input id="trunktext" style="width:150px;"></td></tr><tr><td style="padding:10px 0">别名标志</td><td style="padding:10px 0"><a style="width:65px;padding-left: 20px;">等于</a><td><input style="width:150px" id="markbox"/><span class="searchbox-button" style="margin:1px 0 0 -30px;" id="btnmarksearch"></span></td></tr><tr><td colspan="3"><table  id="marklist" border="false"></table></td></tr><tr><td style="padding:10px 0">查询标志</td><td colspan="2"><input id="searchmarktext" style="width:150px;"><img class="btnmarkrel"  id="refreshloc" onclick="refreshmark(this)" src="../scripts_lib/hisui-0.1.0/dist/css/icons/reset.png" style="vertical-align:middle;padding-left:10px;cursor:pointer"></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="startsearch">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="endsearch">放弃操作</a></td></tr></table></div>')

         // 渲染按钮
        $("#startsearch").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
         // 渲染按钮
        $("#endsearch").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
         
        refreshmark=function()
        {
            $('#markbox').combobox('setValue',"")
            var nodes=$("#marklist").treegrid("getCheckedNodes");
            for (var i=0;i<nodes.length;i++)
            {
                $("#marklist").treegrid("uncheckNode",nodes[i].MKBTRowId);
            }
            $('#marklist').treegrid('unselectAll')
            $('#searchmarktext').val("")
            
        }
        //开始按钮
        $('#startsearch').click(function(e) {
            var trunksymbol = $('#trunksymbol').combobox('getValue');
            var nodes=$("#marklist").treegrid("getCheckedNodes");
            var markStr=""
            if(nodes.length > 0){
                for(var i=0; i<nodes.length; i++){
                    if (markStr==""){
                        markStr=nodes[i].MKBTDesc
                    }
                    else
                    {
                        markStr=markStr+","+nodes[i].MKBTDesc
                    } 
                }
            }
            
            
            var trunktext=$('#trunktext').val()
            //$('#test').layout('expand', 'east');
            //$("#myTaglist").css("left", "140px");
            DataShowFunlib(trunktext,markStr,trunksymbol)
 
            
        })
        //关闭组合查询页签
        $('#endsearch').click(function(e) {
            $('#tab_div').tabs('close', "组合查询<span class='hidecls'></span>");
            $('#test').layout('collapse', 'east');
        })
        var trunksymbol = $HUI.combobox("#trunksymbol", {
            valueField: 'id',
            textField: 'text',
            selectOnNavigation: false,
            panelHeight: "auto",
            editable: false,
            data: [{
                    id: '0',
                    text: '包含',
                    selected: true
                },{
                    id: '1',
                    text: '等于'
                    //selected: true
                }]
        }); 
        

        /*var markbox=$HUI.combotree("#markbox", {
            url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetTreeJson&base="+base,
            //url: $URL+ "?ClassName=web.DHCBL.MKB.MKBTerm&QueryName=GetTreeJson&base=" + base, 
            valueField: 'MKBTDesc',
            textField: 'MKBTDesc',
            multiple:true,              
            selectOnNavigation: false,
            panelHeight: 200,
            editable: false,
            formatter:function(node){
                return node.MKBTDesc;
            }
        })*/
        $('#markbox').searchcombobox({ 
            url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTerm"+base,
            onSelect:function (record) 
            {   
                if (record.Desc!="...")
                {
                    $(this).combobox('textbox').focus();
                    $("#marklist").treegrid("checkNode", record.ID); 
                }
                                                    
            }
        });
        $('#markbox').combobox('textbox').bind('keyup',function(e){  
            if (e.keyCode==13){ 
                var SearchStr =$('#markbox').combobox('getValue')
                var url = $URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTerm"+base+"&q="+SearchStr         
                $('#markbox').combobox('reload', url)
                $('#markbox').combobox("showPanel") 
            }
        }); 

        $("#btnmarksearch").click(function (e) { 
                var SearchStr =$('#markbox').combobox('getValue')
                var url = $URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTerm"+base+"&q="+SearchStr 
                $('#markbox').combobox('reload', url)
                $('#markbox').combobox("showPanel") 
        })
        var markcolumns =[[  
                      {field:'MKBTRowId',title:'MKBTRowId',width:80,sortable:true,hidden:true},
                      {field:'MKBTCode',title:'代码',width:120,sortable:true,hidden:true},
                      {field:'MKBTDesc',title:'中心词',width:270/*,sortable:true,
                        styler: function (value, row, index) {
                            if(row.MKBTActiveFlag=="N")
                            {
                                 return 'background-color:red;';
                            } 
                           }*/
                       },
                      {field:'MKBTSequence',title:'顺序',width:60,sortable:true,hidden:true },
                      {field:'MKBTPYCode',title:'检索码',width:60,sortable:true,hidden:true },
                      {field:'MKBTLastLevel',title:'上级节点',width:80,hidden:true},
                      {field:'MKBTNote',title:'备注',width:80,hidden:true},
                      {field:'MKBTActiveFlag',title:'是否封闭',width:80,hidden:true}
                      ]];
        var marklist = $HUI.treegrid("#marklist",{
            url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetTreeJson&base="+base+"&id="+"&closeflag=",
            ClassTableName:'User.MKBTerm'+base,
            SQLTableName:'MKB_Term',
            columns: markcolumns,  //列信息
            height:250,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
            width:250,
            cascadeCheck:false,//取消勾选属性
            checkbox:true,
            idField: 'MKBTRowId',
            ClassName: "web.DHCBL.MKB.MKBTerm", //拖拽方法DragNode存在的类
            DragMethodName:"DragNode",
            treeField:'MKBTDesc',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。       
            autoSizeColumn:false,
            animate:false,     //是否树展开折叠的动画效果
            fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            //remoteSort:false,  //定义是否从服务器排序数据。true
            onLoadSuccess:function(row,data){               
                 
            },
            onCheckNode:function(row,checked){
                var nowloc=""
                var nodes=$("#marklist").treegrid("getCheckedNodes");
                var nodestr=""
                for (var n=0;n<nodes.length;n++)
                {
                    if (nodestr=="")
                    {
                        nodestr=nodes[n].MKBTDesc
                    }
                    else
                    {
                        nodestr=nodestr+","+nodes[n].MKBTDesc
                    }                   
                }
                $("#searchmarktext").val(nodestr)
                
            }
        })
                                   
    }
    //显示查询结果方法
    DataShowFunlib=function(text,AliasMarkStr,Matchflag){
        
        
        if ($("#tab_div").tabs('exists', "查询结果-"+text+"<span class='hidecls'></span>")) {
            $("#tab_div").tabs('select', "查询结果-"+text+"<span class='hidecls'></span>");
        } else {
            $('#tab_div').tabs('add', {
                title: "查询结果-"+text+"<span class='hidecls'></span>",
                //id: "tab_" + MKBGRRowId
                id: "SearchResult_"+text,
                //content:'Tab Body',//里边可以插html内容    
                closable: true,
                //href:url
            });
        };
        // 辅助功能区表达式页签增加html代码
        $("#SearchResult_"+text).css('position', 'relative');
        $("#SearchResult_"+text).html('<div ><a style="color:#000" >全部搜索结果:</a></div ><div style="height:80%"><table data-options="fit:true" style="width:100%;position:absolute;height:90%" id="ResultListDiv_'+text+'" ></table></div >');
        var GlobalTable = $('<table data-options="fit:true"  id="allresultlist_'+text+'" border="false"></table>')
        $("#ResultListDiv_"+text).html(GlobalTable);               
        
        var resultcolumns = [
            [ {
                field: 'MKBGRowId',
                title: 'MKBGRowId',
                //sortable: true,
                width: 100,
                hidden: true
            }, {
                field: 'MKBGCode',
                title: '编码',
                //sortable: true,
                width: 100,
                hidden: true
            }, {
                field: 'MKBGDisplaName',
                title: '展示名',
                width: 100,
                editor: 'validatebox'
                
            },{
                field: 'MKBGDesc',
                title: '中心词',
                //sortable: true,
                width: 100,
                editor: 'validatebox',
                hidden: true
            }, {
                field: 'MKBGEnName',
                title: '英文名',
                //sortable: true,
                width: 50,
                editor: 'validatebox',
                hidden: true
            }, {
                field: 'MKBGNote',
                title: '备注',
                //sortable: true,
                width: 600,
                hidden: true,
                //fixed: true,
                editor: {
                    type: 'textarea'
                },
                formatter: function(value, row, index) {
                    //鼠标悬浮显示备注信息
                    return '<span class="mytooltip" title="' + row.MKBGNote + '">' + value + '</span>'
                }
            }, {
                field: 'MKBGAlias',
                title: '别名',
                width: 100,
                hidden: true
            }, {
                field: 'MKBGPYCode',
                title: '检索码',
                //sortable: true,
                width: 100,
                hidden: true,
                editor: 'validatebox'
            }, {
                field: 'MKBGLastLevel',
                title: '引用位置',
                //sortable: true,
                hidden: true,
                width: 100
            }, {
                field: 'MKBGState',
                title: '状态',
                //sortable: true,
                hidden: true,
                width: 100,
                formatter: function(value, row, index) {
                    if (value == "U") {
                        return '<span href="#" title="在用"  class="mytooltip">在用</span>';
                    } else if (value == "S") {
                        return '<span href="#" title="封闭" class="mytooltip">封闭</span>';
                    } else if (value == "D") {
                        return '<span href="#" title="删除" class="mytooltip">删除</span>';
                    } else if (value == "M") {
                        return '<span href="#" title="合并" class="mytooltip">合并</span>';
                    }
                }
            }, {
                field: 'MKBGConfirm',
                title: '确认状态',
                width: 100,
                hidden: true,
                styler: function(value, row, index) {
                    if (value == "Y") {
                        return 'background-color:#33FF66;';
                    } else {
                        return 'background-color:#FF0033;';
                    }
                },
                formatter: function(value, row, index) {
                    if (value == "Y") {
                        return '<span href="#" title="已确认"  class="mytooltip">已确认</span>';
                    } else {
                        return '<span href="#" title="未确认" class="mytooltip">未确认</span>';
                    }
                }
            }, {
                field: 'TopDataFlag',
                title: 'TopDataFlag',
                width: 80,
                hidden: true
            }, {
                field: 'MKBGloMark',
                title: '标记',
                width: 80,
                hidden: true
            }, {
                field: 'MKBGDiaTotalFreq',
                title: '频次',
                width: 80,
                hidden: true
            }]
        ];

        $HUI.datagrid("#allresultlist_"+text, {
            url: $URL,
            queryParams: {
                ClassName: "web.DHCBL.MKB.MKBGlobal", 
                QueryName: "GetList",
                'Type': Type,
                'desc': text,
                'MarkStr': MKBGMark,
                'AliasMarkStr':AliasMarkStr,
                'Matchflag':Matchflag
            },
            columns:resultcolumns,
            remoteSort: false,
            pagination: true, //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
            pageSize: 20,
            pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500, 1000],
            singleSelect: true,    
            checkOnSelect: false,
            selectOnCheck: false,
            idField: 'MKBGRowId',
            rownumbers: false, //设置为 true，则显示带有行号的列。
            fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            scrollbarSize: 0,
            onSelect: function(index, row){
                SetHeight();
                ClickFun();
                GlobalID = row.MKBGRowId;
                LoadEditList(row);
                LoadAliasList(GlobalID);
                LoadReferenceList(GlobalID);
                RefreshSearchData("User.MKBGlobal", GlobalID, "A", row.MKBGDisplaName)
               
            },
            onLoadSuccess:function(data){
                $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
                $(this).datagrid('columnMoving'); //列可以拖拽改变顺序
                 //$("#allresultlist_"+text).datagrid('selectRow', 0);
            }
        });
    }

    //
    //新增术语右侧辅助功能区新增
    $("#AddGlobal").click(function(e) {
        
        AddGlobalFun()
    })
    AddGlobalFun=function(){
        if ($("#tab_div").tabs('exists', "新增术语<span class='hidecls'></span>")) {
            $("#tab_div").tabs('select', "新增术语<span class='hidecls'></span>");
        } else {
            $('#tab_div').tabs('add', {
                title: "新增术语<span class='hidecls'></span>",
                id: "AddGlobalTab", 
                closable: true,
            });
        }
        $('.tabs .tabs-inner').css('line-height', '16px');
        $('.tabs .tabs-inner').css('height', 'auto');
        $('.tabs .tabs-inner').css('padding', '6px');
       // $('.tabs .tabs-inner .tabs-title').css('white-space', 'pre-wrap');
        $('#test').layout('expand', 'east');
        $("#AddGlobalTab").html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">名称</td></tr><tr><td><input  id="AddGlobalName" type="text"  style="width:258px" ></td></tr></table><div style="padding:10px 0 10px;border-top:1px #ccc dashed;text-align:center;left:0px;right:0px;bottom:0px"><a href="#" class="hisui-linkbutton" id="addGlobal" style="margin-right:10px">确认执行</a><a href="#" class="hisui-linkbutton" id="closeGlobal" style="margin-right:10px">放弃操作</a><table style="padding:0 7px;padding-bottom:20px" ><tr><td style="padding:10px 0">报错信息</td></tr><tr><td><textarea id="ErrorMessageBox" style="height:100px;width:265px;"></textarea></td></tr></table><table data-options="fit:true" id="ErrorMessagegrid" border="false"></table></div><div style="padding:10px 0 10px;text-align:center;position:absolute;left:0px;right:0px;bottom:0px"><table align=center><tr><td><a href="#" class="hisui-linkbutton"  id="SearchMagger">近似查询</a></td></tr></table></div>')        //错误信息展示列表
        
        // 渲染按钮
        $("#closeGlobal").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
        // 渲染按钮
        $("#SearchMagger").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
        //查找类似
        $("#SearchMagger").click(function(e) {
            var GlobalName = stripscript($("#AddGlobalName").val());
            options={};
            options.url=$URL;
            options.queryParams={
                    ClassName: "web.DHCBL.MKB.MKBGlobal",
                    QueryName: "GetGlobalAndGloAlias",
                    'Desc': GlobalName
            }   
            $('#ErrorMessagegrid').datagrid(options);
        });

        //新增术语按钮
        $("#addGlobal").click(function(e) {
            AddGlobal1();
        });
        $("#closeGlobal").click(function(e) {
            $("#tab_div").tabs('close', "新增术语<span class='hidecls'></span>");
            //折叠辅助功能区
            $('#test').layout('collapse', 'east');  
        })
        //搜索回车事件
        $('#AddGlobalName').keyup(function(event)
        {
            if(event.keyCode == 13) 
            {
                AddGlobal1();
            }
        });
        var Errorcolumns = [
            [{
                field: 'MKBGRowId',
                title: '全局化词表ID',
                width: 100,
                hidden: true
            }, {
                field: 'MKBGAliasId',
                title: '别名列表ID',
                width: 100,
                hidden: true
            }, {
                field: 'MKBGADesc',
                title: '重复内容',
                width: 100,
            }]
        ];
        var Errorrowdata=""
        $HUI.datagrid("#ErrorMessagegrid", {
            //url:$URL,
            columns: Errorcolumns,
            remoteSort: false,
            pagination: false, //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
            singleSelect: true,
            checkOnSelect: false,
            selectOnCheck: false,
            idField: 'MKBGRowId',
            rownumbers: false, //设置为 true，则显示带有行号的列。
            fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            scrollbarSize: 0,
            onClickRow: function(index, row) {
                LoadAliasList1(row.MKBGRowId,row.MKBGAliasId);
            },
            onLoadSuccess:function(data){
                Errorrowdata=$(this).datagrid("getRows")
            }
        });
        $("#AddGlobalName").focus()
        // 渲染按钮
        $("#addGlobal").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
        //辅助功能区新增术语方法和错误信息操作方法
         var AddGlobal1= function(){
            $('#ErrorMessageBox').val("")
            var Errorrowdata=""
            var GlobalName = stripscript($("#AddGlobalName").val());
            if (GlobalName == "") {
                $('#ErrorMessageBox').val("新增术语名称不能为空!")
                $('#ErrorMessagegrid').datagrid("loadData",[]);
                return;
            }
            
            options={};
            options.url=$URL;
            options.queryParams={
                 ClassName: "web.DHCBL.MKB.MKBGlobal",
                QueryName: "GetGlobalAndGloAlias",
                'Desc': GlobalName,
                'globalflag':1 
            } 
            $('#ErrorMessagegrid').datagrid(options);

            var Errorrowdata=$('#ErrorMessagegrid').datagrid("getRows");
          
            
            if (Errorrowdata!="")   //有数据
            {
                $('#ErrorMessageBox').val("术语名重复")
                $("#AddGlobalName").focus()
            }
            else
            {
                var result1 = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "SaveGlobalDataNotForm2", GlobalName);
                var result = eval('(' + result1 + ')');
                if (result.success == 'true') 
                {
                    
                    $.messager.popover({
                        msg: '新增成功！',
                        type: 'success',
                        timeout: 1000
                    });
                    
                    $.cm({
                        ClassName:"web.DHCBL.MKB.MKBGlobal",         ///调用Query时
                        QueryName:"GetList",
                        rowid: result.id   
                    },function(jsonData){
                        $('#globalgrid').datagrid('insertRow',{
                            index:0,
                            row:jsonData.rows[0]
                        })
                        $("#globalgrid").datagrid('selectRow', 0);
                        GlobalID = result.id;
                        LoadEditList(jsonData.rows[0]);
                        LoadAliasList(result.id);
                        LoadReferenceList(result.id);
                        RefreshSearchData("User.MKBGlobal", result.id, "A",jsonData.rows[0].MKBGDisplaName)
                        
                    })
                    
                    
                   $("#tab_div").tabs('close', "新增术语<span class='hidecls'></span>")
                   $('#test').layout('collapse', 'east');
                }
                else
                {
                    var errorMsg=result.errorinfo
                    $('#ErrorMessageBox').val(errorMsg)
                }
            }
         }
    }    
     
    //已确认按钮
    $("#Yconfirm").click(function(e) {
        $("#westTextDesc").combobox('setText', "");
        $('#globalgrid').datagrid('load', {
            ClassName: "web.DHCBL.MKB.MKBGlobal",
            QueryName: "GetList",
            'confirm': "Y",
            'MarkStr': MKBGMark
        });
        $('#globalgrid').datagrid('unselectAll');
    })
    //未确认按钮
    $("#Nconfirm").click(function(e) {
        $("#westTextDesc").combobox('setText', "");
        $('#globalgrid').datagrid('load', {
            ClassName: "web.DHCBL.MKB.MKBGlobal",
            QueryName: "GetList",
            'confirm': "N",
            'MarkStr': MKBGMark
        });
        $('#globalgrid').datagrid('unselectAll');
    })
    //查看同名术语按钮
    $("#SameGlobal").click(function(e) {
        LoadSameGlobal();
    })
    //一键取消所有置顶按钮
    $("#CancelAllTop").click(function(e) {
        CancelAllTopData();
    })
    //切换展示按钮
    $("#ChangePage").click(function(e) {
        if (showPage == "new") {
            $("#globalgrid").datagrid("showColumn", "MKBGNote");
            $("#globalgrid").datagrid("showColumn", "MKBGEnName");
            $("#globalgrid").datagrid("showColumn", "MKBGAlias");
            $('#layoutglobal').panel('resize', {
                width: 1330,
            });
            showPage = "old"
        } else {
            $("#globalgrid").datagrid("hideColumn", "MKBGNote");
            $("#globalgrid").datagrid("hideColumn", "MKBGEnName");
            $("#globalgrid").datagrid("hideColumn", "MKBGAlias");
            $('#layoutglobal').panel('resize', {
                width: 310,
            });
            showPage = "new"
        }
    })
    ///置顶
    var topdata = new Array();
    //勾选数据时自动置顶
    TopCheckData = function(record) {
        if (record.TopDataFlag == "top") {
            return;
        } else {
            $('#globalgrid').datagrid('insertRow', {
                index: 0, // index start with 0
                row: {
                    MKBGRowId: record.MKBGRowId, //record.MKBTDesc
                    MKBGDesc: record.MKBGDesc + "<img src='../scripts/bdp/Framework/icons/mkb/nail.png' onClick='CancelTopData()'></img>",
                    MKBGPYCode: record.MKBGPYCode,
                    MKBGNote: record.MKBGNote,
                    TopDataFlag: "top"
                }
            });
            record.TopDataFlag = "top"
            topdata.push(record);
            UpdateExDisplayList();
            var rowIndex = $('#globalgrid').datagrid('getRowIndex', record);
            $('#globalgrid').datagrid('checkRow', 0);
            $('#globalgrid').datagrid('deleteRow', rowIndex);
            $('#globalgrid').datagrid('freezeRow', 0);
        }
    }
    TopData = function() {
        var record = $("#globalgrid").datagrid("getSelected");
        if (!(record)) {
            $.messager.alert('错误提示', '请先选择一条记录!', "error");
            return;
        } else {
            if (record.TopDataFlag == "top") {
                $.messager.alert('错误提示', '已经是置顶数据!', "error");
                return;
            } else {
                var nrecord=record
                nrecord.TopDataFlag = "top"
                nrecord.MKBGDesc + "<img src='../scripts/bdp/Framework/icons/mkb/nail.png' ></img>",
                $('#globalgrid').datagrid('insertRow', {
                    index: 0, // index start with 0
                    row:nrecord
                });

                //record.TopDataFlag = "top"
                topdata.push(record);
                UpdateExDisplayList();
                //alert(topdata.length)
                var rowIndex = $('#globalgrid').datagrid('getRowIndex', record);
                $('#globalgrid').datagrid('checkRow', 0);
                $('#globalgrid').datagrid('deleteRow', rowIndex);
                $('#globalgrid').datagrid('freezeRow', 0);
            }
        }
    }
    ///取消置顶
    CancelTopData = function() {
        var record = $("#globalgrid").datagrid("getSelected");
        if (!(record)) {
            $.messager.alert('错误提示', '请先选择一条记录!', "error");
            return;
        } else {
            for (var i = 0; i < topdata.length; i++) {
                if (topdata[i].MKBGRowId == record.MKBGRowId) {
                    topdata.splice(i, 1)
                }
            }
            
            ClearGlobal();
            $('#globalgrid').datagrid('uncheckAll');
        }
    }
    ///用于合并之后取消置顶
    CancelTop = function(record) {
        for (var i = 0; i < topdata.length; i++) {
            if (topdata[i].MKBGRowId == record.MKBGRowId) {
                topdata.splice(i, 1)
            }
            UpdateExDisplayList();
        }
    }
    //一键取消所有置顶
    CancelAllTopData = function() {
        /*for (var i = 0; i < topdata.length; i++) {
            topdata.splice(i, 1)
        }*/
        topdata = [];
        ClearGlobal();
    }
    //右键复制
    $("#copy_menu").click(function(e) {
        CopyText()
    })
    //编辑区查看引用按钮
    $("#search_ref").click(function(e) {
        //alert(1)
        //document.getElementById('myeditgrid').style.display = 'none'; //隐藏mygrid
        //$("#myref").show(); //展示初始图片          
        //$("#myref").display = '';
        $('#test').layout('expand', 'east');
        $('#tt').tabs('resize');
        $('#ttt').tabs('resize');
        LoadReferenceList(GlobalID)
        //SaveEditData();
    })
    //数据导入按钮
    $("#importData").click(function(e) {
        addTab('数据导入', 'dhc.bdp.mkb.mkbglobalimportdata.csp')
    })
    //将其他表的数据导入全局化词表的导入按钮
    $("#InsertData").click(function(e) {
        var  handlerstr="InsertData"
        var handtitle="数据导入"
        if ($("#tab_div").tabs('exists', handtitle+"<span class='hidecls'></span>")) {
            $("#tab_div").tabs('select', handtitle+"<span class='hidecls'></span>");
        } else {
            $('#tab_div').tabs('add', {
                title: handtitle+"<span class='hidecls'></span>",
                id: handlerstr,
                closable: true,
            });
        }
        $('.tabs .tabs-inner').css('line-height', '16px');
        $('.tabs .tabs-inner').css('height', 'auto');
        $('.tabs .tabs-inner').css('padding', '6px');
       // $('.tabs .tabs-inner .tabs-title').css('white-space', 'pre-wrap');
        $('#test').layout('expand', 'east');
        $("#"+handlerstr).html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">确认处理范围</td></tr><tr><td><select id="'+handlerstr+'rangebox" style="width:265px;"></select></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="'+handlerstr+'starthandle">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="'+handlerstr+'endhandle">放弃操作</a></td></tr></table></div>')
         // 渲染按钮
        $("#"+handlerstr+"starthandle").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
         // 渲染按钮
        $("#"+handlerstr+"endhandle").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
        //开始按钮
        $('#'+handlerstr+'starthandle').click(function(e) {
            var rangeStr = $('#'+handlerstr+'rangebox').combobox('getValue');            
            if (rangeStr=="1")
            {
                var methodstr="ICDContrastToGlobal"
            }
            
            var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", methodstr);
            if ((result=="true" )||(result=="success"))
            { 
                $("#mygrid").datagrid('reload');
                $("#mygrid").datagrid('selectRow', 0);

            
                $('#tab_div').tabs('close', handtitle+"<span class='hidecls'></span>");
                $('#test').layout('collapse', 'east');
            }
        })
     
         //关闭页签
        $('#'+handlerstr+'endhandle').click(function(e) {
            $('#tab_div').tabs('close', handtitle+"<span class='hidecls'></span>");
            $('#test').layout('collapse', 'east');
        })
        var rangebox = $HUI.combobox("#"+handlerstr+"rangebox", {
            valueField: 'id',
            textField: 'text',
            //multiple:true,
            //rowStyle:'checkbox', //显示成勾选行形式
            selectOnNavigation: false,
            panelHeight: "auto",
            editable: false,
            data: [{
                id: '1',
                text: '从各版本ICD对照导入',
                selected: true
            }/*, {
                id: '2',
                text: ''
            }, {
                id: '3',
                text: ''
            }*/]
        });
    })

    //数据排序按钮
    $("#freqsort").click(function(e) {
        SortMethod="freqsort"
        $('#globalgrid').datagrid('load',  { 
            ClassName: "web.DHCBL.MKB.MKBGlobal",
            QueryName: "GetList",
            'Type': Type,
            'MarkStr': MKBGMark
        });
        /*
        $('#mergelist').datagrid('options').sortName='MKBGDiaTotalFreq';
        $('#mergelist').datagrid('options').sortOrder='asc';
        $('#reloadlist').click();*/
        /*$HUI.datagrid("#mergelist", {
            sortName:'MKBGPYCode',
            sortOrder:'asc',
            remoteSort:false
        })*/
    })
    $("#pysort").click(function(e){
        /*$('#mergelist').datagrid('options').sortName='MKBGPYCode';
        $('#mergelist').datagrid('options').sortOrder='asc';
        $('#reloadlist').click();*/
    })
    //实用诊断排序
   $("#termsort").click(function(e){
        SortMethod="termsort"
        $('#globalgrid').datagrid('load',  { 
            ClassName: "web.DHCBL.MKB.MKBGlobal",
            QueryName: "GetList",
            'desc': "",
            'Type': Type,
            'MarkStr': MKBGMark,
            'SortMethod':"termsort"
        });
       
    })
   //专业科室排序
   $("#locsort").click(function(e){        
        LocSorFunlib()
    })
   //专业科室排序
    var LocSorFunlib=function(){
        $('#test').layout('expand', 'east');
        $("#myTaglist").css("left", "140px");
        if ($("#tab_div").tabs('exists', "专业科室排序"+"<span class='hidecls'></span>")) {
            $("#tab_div").tabs('select', "专业科室排序"+"<span class='hidecls'></span>");
        } else {
            $('#tab_div').tabs('add', {
                title: "专业科室排序"+"<span class='hidecls'></span>",
                id: "LocSorSearch",
                closable: true,
            });
        };
        // 辅助功能区表达式页签增加html代码
        $('.tabs .tabs-inner').css('line-height', '16px');
        $('.tabs .tabs-inner').css('height', 'auto');
        $('.tabs .tabs-inner').css('padding', '6px');
       // $('.tabs .tabs-inner .tabs-title').css('white-space', 'pre-wrap');
        $('#test').layout('expand', 'east');    //展开辅助功能区
        //$("#LocSorSearch").html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">专业科室</td><td><select id="locbox" style="width:150px;"></select></td></tr><tr><td style="padding:10px 0">科室频次</td><td><input id="freqtext" style="width:150px;"></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="startsearchloc">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="endsearchloc">放弃操作</a></td></tr></table></div>')
        //$("#LocSorSearch").html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">专业科室</td><td><select id="locbox" style="width:150px;"></select></td></tr><tr><td><table data-options="fit:true" id="loclist" border="false"></table></td></tr><tr><td style="padding:10px 0">科室频次</td><td><input id="freqtext" style="width:150px;"></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="startsearchloc">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="endsearchloc">放弃操作</a></td></tr></table></div>')
        //$("#LocSorSearch").html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">专业科室</td><td><input style="width:165px" id="locbox"/><span class="searchbox-button" style="margin:1px 0 0 -30px;" id="btnlocsearch"></span></td></tr><tr><td><table data-options="fit:true" id="loclist" border="false"></table></td></tr><tr><td style="padding:10px 0">科室频次</td><td><input id="freqtext" style="width:150px;"></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="startsearchloc">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="endsearchloc">放弃操作</a></td></tr></table></div>')
         //$("#LocSorSearch").html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">专业科室</td><td><input style="width:165px" id="locbox"/><span class="searchbox-button" style="margin:1px 0 0 -30px;" id="btnlocsearch"></span><a href="#" class="hisui-linkbutton" iconCls='icon-refresh'  id="btnlocrel"></a></td></tr><tr><td><table data-options="fit:true" id="loclist" border="false"></table></td></tr><tr><td style="padding:10px 0">科室频次</td><td><input id="freqtext" style="width:150px;"></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="startsearchloc">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="endsearchloc">放弃操作</a></td></tr></table></div>')
         //$("#LocSorSearch").html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">专业科室</td><td><input style="width:165px" id="locbox"/><span class="searchbox-button" style="margin:1px 0 0 -30px;" id="btnlocsearch"></span><a href="#" class="hisui-linkbutton"   id="btnlocrel"></a></td></tr><tr><td><table data-options="fit:true" id="loclist" border="false"></table></td></tr><tr><td style="padding:10px 0">科室频次</td><td><input id="freqtext" style="width:150px;"></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="startsearchloc">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="endsearchloc">放弃操作</a></td></tr></table></div>')
         //$("#LocSorSearch").html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">专业科室</td><td><input style="width:165px" id="locbox"/><span class="searchbox-button" style="margin:1px 0 0 -30px;" id="btnlocsearch"></span><a href="#" class="hisui-linkbutton"   id="btnlocrel"></a></td></tr><tr><td colspan="2"><table  id="loclist" border="false"></table></td></tr><tr><td style="padding:10px 0">科室频次</td><td><input id="freqtext" style="width:150px;"></td></tr><tr><td style="padding:10px 0">查询科室</td><td><input id="searchloctext" style="width:150px;"></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="startsearchloc">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="endsearchloc">放弃操作</a></td></tr></table></div>')
         //$("#LocSorSearch").html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">专业科室</td><td><input style="width:165px" id="locbox"/><span class="searchbox-button" style="margin:1px 0 0 -30px;" id="btnlocsearch"></span><img class="btnlocrel"  id="refreshloc" onclick="refreshloc(this)" src="../scripts_lib/hisui-0.1.0/dist/css/icons/card.png" style="padding-right:10px;padding-top:10px;border:0px;cursor:pointer"></td></tr><tr><td colspan="2"><table  id="loclist" border="false"></table></td></tr><tr><td style="padding:10px 0">科室频次</td><td><input id="freqtext" style="width:150px;"></td></tr><tr><td style="padding:10px 0">查询科室</td><td><input id="searchloctext" style="width:150px;"></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="startsearchloc">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="endsearchloc">放弃操作</a></td></tr></table></div>')
         $("#LocSorSearch").html('<table style="padding:0 7px;padding-bottom:10px"><tr><td style="padding:10px 0">专业科室</td><td><input style="width:165px" id="locbox"/><span class="searchbox-button" style="margin:1px 0 0 -30px;" id="btnlocsearch"></span><img class="btnlocrel"  id="refreshloc" onclick="refreshloc(this)" src="../scripts_lib/hisui-0.1.0/dist/css/icons/reset.png" style="vertical-align:middle;padding-left:10px;cursor:pointer"></td></tr><tr><td colspan="2"><table  id="loclist" border="false"></table></td></tr><tr><td style="padding:10px 0">科室频次</td><td><input id="freqtext" style="width:150px;"></td></tr><tr><td style="padding:10px 0">排序科室</td></tr><tr><td colspan="2"><table  id="searchloclist" border="false"></table></td></tr></table><div><table cellspacing="10" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="startsearchloc">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="endsearchloc">放弃操作</a></td></tr></table></div>')

         //$("#LocSorSearch").html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">专业科室</td><td><input style="width:165px" id="locbox"/><span class="searchbox-button" style="margin:1px 0 0 -30px;" id="btnlocsearch"></span><a class="hisui-linkbutton l-btn-0" iconCls='icon-refresh' plain="true" data-options="stopAllEventOnDisabled:true" id="btnlocrel"></a></td></tr><tr><td><table data-options="fit:true" id="loclist" border="false"></table></td></tr><tr><td style="padding:10px 0">科室频次</td><td><input id="freqtext" style="width:150px;"></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="startsearchloc">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="endsearchloc">放弃操作</a></td></tr></table></div>')
         //<img class="refreshloc"  id="refreshloc" onclick="refreshloc(this)" src="../scripts_lib/hisui-0.1.0/dist/css/icons/card.png" style="padding-right:10px;padding-top:10px;border:0px;cursor:pointer">
         // 渲染按钮
        $("#startsearchloc").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
         // 渲染按钮
        $("#endsearchloc").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        }); 
        refreshloc=function()
        {
            $('#locbox').combobox('setValue',"")
            var nodes=$("#loclist").treegrid("getCheckedNodes");
            for (var i=0;i<nodes.length;i++)
            {
                $("#loclist").treegrid("uncheckNode",nodes[i].MKBTRowId);
            }
            $('#loclist').treegrid('unselectAll')
            //$('#searchloctext').val("")
            
            $('#searchloclist').datagrid("loadData" ,[])   
            $('#freqtext').val("")
            
        }
        //术语维护查询框
        $('#locbox').searchcombobox({ 
            url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTerm"+locbase,
            onSelect:function (record) 
            {   
                $(this).combobox('textbox').focus();
                $("#loclist").treegrid("checkNode", record.ID); 
                //SearchFunLibTree()
                /*$('#searchloclist').datagrid('appendRow',{
                            MKBTRowId: record.ID,
                            MKBTDesc: record.Desc
                        });*/
                
            }
        });
        $('#locbox').combobox('textbox').bind('keyup',function(e){  
            if (e.keyCode==13){ 
                //SearchFunLibTree() 
                var SearchStr =$('#locbox').combobox('getValue')
                //$('#locbox').combobox('setValue',SearchText)
                
                var url = $URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTerm"+locbase+"&q="+SearchStr
                $('#locbox').combobox('reload', url)
                $('#locbox').combobox("showPanel") 
            }
        }); 

        $("#btnlocsearch").click(function (e) { 
                //SearchFunLibTree();
                var SearchStr =$('#locbox').combobox('getValue')
                var url = $URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.MKBTerm"+locbase+"&q="+SearchStr
                $('#locbox').combobox('reload', url)
                $('#locbox').combobox("showPanel") 
        })
        

         //查询方法
        SearchFunLibTree=function (){
            var CatDesc=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase", "GetCatDescById",locbase)  //获取知识库分类描述
            var desc=$("#locbox").combobox('getText');
            if(desc=="")
            {
                ClearFunLibTree();
                return
            }
            if (CatDesc.indexOf("分级加载")!= -1)//((MKBTBFlag=="ICD11")||(MKBTBFlag=="KnoClass"))
            {
                $('#loclist').treegrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=SearchTermICD&desc="+encodeURI(desc)+"&base="+base+"&closeflag="+closeflag; 
                $('#loclist').treegrid('reload')
            }
            else
            {
                $("#loclist").treegrid("search", desc)   
            }
            $('#loclist').treegrid('unselectAll');           
            
        }
        ClearFunLibTree=function (){
            //是否收缩树形标志
            firstflag="Y"
            //加载全部与否的标志
            closeflag=""
            $("#locbox").combobox('setValue', '');
            $('#loclist').treegrid('options').url = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetTreeJson&base="+locbase+"&id="+"&closeflag=", 
            $('#loclist').treegrid('reload')
            $('#loclist').treegrid('unselectAll');
            
        }
        
        //开始按钮
        $('#startsearchloc').click(function(e) {
            SortMethod="locsort"
            var locStr=""
            var locDesc=""
            var records=$("#searchloclist").datagrid("getRows");
            for (var n=0;n<records.length;n++)
            {
                if (locStr==""){
                    locStr=records[n].MKBTRowId
                    locDesc=records[n].MKBTDesc
                }
                else
                {
                    locStr=locStr+","+records[n].MKBTRowId
                    locDesc=locDesc+","+records[n].MKBTDesc
                } 
            }
            /*var nodes=$("#searchloclist").treegrid("getCheckedNodes");
            for (var n=0;n<nodes.length;n++)
            {
                if (locStr==""){
                    locStr=nodes[n].MKBTRowId
                    locDesc=nodes[n].MKBTDesc
                }
                else
                {
                    locStr=locStr+","+nodes[n].MKBTRowId
                    locDesc=locDesc+","+nodes[n].MKBTDesc
                } 
            }*/
            

            PreLocStr=locStr 
            PreLocDescStr=  locDesc   
            
            
            var freqtext=$('#freqtext').val()
            PreFreq=freqtext
            var url=$URL+"?ClassName=web.DHCBL.MKB.MKBGlobal&QueryName=GetTermForCmb2&ResultSetType=array&markstr="+MKBGMark+"&SortMethod="+SortMethod+"&SortLocStr="+PreLocStr+"&LocFreq="+PreFreq
            $('#westTextDesc').combobox('reload', url) 
            $('#TextGlobal').combobox('reload', url) 

            if ((locStr!="")&&(freqtext!=""))
            {
                $('#globalgrid').datagrid('load',  { 
                    ClassName: "web.DHCBL.MKB.MKBGlobal",
                    QueryName: "GetList",
                    'desc': "",
                    'Type': Type,
                    'MarkStr': MKBGMark,
                    'SortMethod':"locsort",
                    'LocFreq':freqtext,
                    'SortLocStr':locStr
                });
            }
           
        })
        //关闭组合查询页签
        $('#endsearchloc').click(function(e) {
            $('#tab_div').tabs('close', "专业科室排序<span class='hidecls'></span>");
            $('#test').layout('collapse', 'east');
        })
        
        var loccolumns =[[  
                      {field:'MKBTRowId',title:'MKBTRowId',width:80,sortable:true,hidden:true},
                      {field:'MKBTCode',title:'代码',width:120,sortable:true,hidden:true},
                      {field:'MKBTDesc',title:'中心词',width:270/*,sortable:true,
                        styler: function (value, row, index) {
                            if(row.MKBTActiveFlag=="N")
                            {
                                 return 'background-color:red;';
                            } 
                           }*/
                       },
                      {field:'MKBTSequence',title:'顺序',width:60,sortable:true,hidden:true },
                      {field:'MKBTPYCode',title:'检索码',width:60,sortable:true,hidden:true },
                      {field:'MKBTLastLevel',title:'上级节点',width:80,hidden:true},
                      {field:'MKBTNote',title:'备注',width:80,hidden:true},
                      {field:'MKBTActiveFlag',title:'是否封闭',width:80,hidden:true}
                      ]];
        var loclist = $HUI.treegrid("#loclist",{
            url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetTreeJson&base="+locbase+"&id="+"&closeflag=",
            ClassTableName:'User.MKBTerm'+locbase,
            SQLTableName:'MKB_Term',
            columns: loccolumns,  //列信息
            height:250,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
            width:250,
            cascadeCheck:false,//取消勾选属性
            checkbox:true,
            idField: 'MKBTRowId',
            ClassName: "web.DHCBL.MKB.MKBTerm", //拖拽方法DragNode存在的类
            DragMethodName:"DragNode",
            treeField:'MKBTDesc',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。       
            autoSizeColumn:false,
            animate:false,     //是否树展开折叠的动画效果
            fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            //remoteSort:false,  //定义是否从服务器排序数据。true
            onLoadSuccess:function(row,data){               
                if (PreLocStr!="")  //前一次科室排序查询不为空，回显
                {                    
                    //$('#searchloctext').val(PreLocDescStr)
                    
                    var PrelocArry=PreLocStr.split(",")
                    var PreLocDescArry=PreLocDescStr.split(",")
                    for (var m=0;m<PrelocArry.length;m++)
                    {   
                        $('#searchloclist').datagrid('appendRow',{
                            MKBTRowId: PrelocArry[m],
                            MKBTDesc: PreLocDescArry[m]
                        });
                        
                        /*if (PrelocArry[m]!="")
                        {
                            $("#loclist").treegrid("checkNode", PrelocArry[m]); 
                        }*/

                    }
                    $('#freqtext').val(PreFreq)
                }  
            },
            onCheckNode:function(row,checked){
                var nowloc=""
                var nodes=$("#loclist").treegrid("getCheckedNodes");
                $('#searchloclist').datagrid("loadData",[])
                for (var n=0;n<nodes.length;n++)
                {
                    $('#searchloclist').datagrid('appendRow',{
                            MKBTRowId: nodes[n].MKBTRowId,
                            MKBTDesc: nodes[n].MKBTDesc
                        });
                    
                    /*if (nowloc==""){
                        nowloc=nodes[n].MKBTDesc
                    }
                    else
                    {
                        nowloc=nowloc+","+nodes[n].MKBTDesc
                    }*/ 
                }
                
            }
        })
        var sloccolumns = [
            [ {
                field: 'MKBTRowId',
                title: 'ID',
                //sortable: true,
                width: 100,
                hidden: true
            }, {
                field: 'MKBTDesc',
                title: '描述',
                //sortable: true,
                width: 100
            }]
            ]
        var searchloclist=$HUI.datagrid("#searchloclist", {
            //url:$URL,
            columns: sloccolumns,
            remoteSort: false,
            pagination: false, //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
            height:100,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
            width:250,
            singleSelect: true,
            checkOnSelect: false,
            selectOnCheck: false,
            idField: 'MKBTRowId',
            rownumbers: false, //设置为 true，则显示带有行号的列。
            fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            scrollbarSize: 0,
            onRowContextMenu: function(e, rowIndex, rowData) {
                var $clicked = $(e.target);
                copytext = $clicked.text() || $clicked.val() //普通复制功能
                e.preventDefault(); //阻止浏览器捕获右键事件
                var record = $(this).datagrid("selectRow", rowIndex); //根据索引选中该行 
                var mygridmm = $('<div style="width:120px;"></div>').appendTo('body');
                mygridmm.html('<div id="del_menu" onclick="DelSearchlist()" iconCls="icon-cancel" data-options="">删除</div>').click(stopPropagation);
                mygridmm.menu({
                    onClick: function(item) {
                        var itemid = item.id
                    }
                });
                mygridmm.menu('show', {
                    left: e.pageX,
                    top: e.pageY
                });
            }
        }); 
        //删除列表行数据
        DelSearchlist = function() {
            var record = $("#searchloclist").datagrid("getSelected");
            var RowIndex = $("#searchloclist").datagrid("getRowIndex", record.MKBTRowId);
            $("#searchloclist").datagrid("deleteRow", RowIndex);
            $("#loclist").treegrid("uncheckNode",record.MKBTRowId);
        } 
                 
        
    }

    //术语拆分菜单
    $("#SplitGlobal").click(function(e) {

        $('#test').layout('expand', 'east');
        $("#myTaglist").css("left", "140px");
        if ($("#tab_div").tabs('exists', "术语拆分<span class='hidecls'></span>")) {
            $("#tab_div").tabs('select', "术语拆分<span class='hidecls'></span>");
        } else {
            $('#tab_div').tabs('add', {
                title: "术语拆分<span class='hidecls'></span>",
                id: "SplitGlobal",
                closable: true
            });
        };
        $("#SplitGlobal").css('position', 'relative');
     
        // 辅助功能区表达式页签增加html代码
        $("#SplitGlobal").css('position', 'relative');
        //$("#SplitGlobal").html('<div style="padding:10px 0 10px;border-top:1px #ccc dashed;width:100%;height:150px"><a style="color:#000" >拆分别名:</a><table data-options="fit:true" id="splitaliaslist"  border="false"></table></div><div style="padding:10px 0 10px;border-top:1px #ccc dashed;width:100%;height:150px"><a style="color:#000" >拆分引用:</a><table data-options="fit:true" id="splitreflist"  border="false"></table></div><div style="padding:10px 0 10px;border-top:1px #ccc dashed;text-align:center;position:absolute;left:0px;right:0px;bottom:0px"><a href="#" class="hisui-linkbutton" id="dosplit" style="margin-right:10px">确认执行</a><a href="#" class="hisui-linkbutton" id="cancelsplit" style="margin-right:10px">放弃操作</a><table style="padding:0 7px;padding-bottom:20px" id="ErrorTable" align=center><tr><td style="padding:10px 0">报错信息</td></tr><tr><td><textarea id="ErrorBox" style="height:100px;width:265px;"></textarea></td></tr></table><a href="#" class="hisui-linkbutton" id="confirmsplit" style="display:none;">确认合并</a></div>');  
        $("#SplitGlobal").html('<div style="padding:10px 0 10px;border-top:1px #ccc dashed;width:100%;height:150px"><a style="color:#000" >拆分别名:</a><table data-options="fit:true" id="splitaliaslist"  border="false"></table></div><div style="padding:10px 0 10px;border-top:1px #ccc dashed;width:100%;height:150px"><a style="color:#000" >拆分引用:</a><table data-options="fit:true" id="splitreflist"  border="false"></table></div><div style="padding:10px 0 10px;border-top:1px #ccc dashed;text-align:center;left:0px;right:0px;bottom:0px"><a href="#" class="hisui-linkbutton" id="dosplit" style="margin-right:10px">确认执行</a><a href="#" class="hisui-linkbutton" id="cancelsplit" style="margin-right:10px">放弃操作</a><table style="padding:0 7px;padding-bottom:20px" id="ErrorTable" align=center><tr><td style="padding:10px 0">报错信息</td></tr><tr><td><textarea id="ErrorBox" style="height:100px;width:265px;"></textarea></td></tr></table><a href="#" class="hisui-linkbutton" id="confirmsplit" style="display:none;">确认合并</a></div>');  

         // 渲染按钮
        $("#dosplit").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
         // 渲染按钮
        $("#cancelsplit").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        }); 

        //开始按钮
        $('#dosplit').click(function(e) {
            var records = $("#splitaliaslist").datagrid('getRows'); //获取准备合并列表的所有行。
            var record = $("#splitaliaslist").datagrid('getSelected');
            if ((record=="")||(record=="null")||(record==null))
            {
                $("#ErrorBox").val("请选择别名作为展示名!");
                //$.messager.alert('错误提示', '请选择别名作为展示名!', "error");
                return
            }
            var RowIdArry = [];
            for (var i = 0; i < records.length; i++) {
                if (records[i].ID != record.ID)
                 {
                    RowIdArry.push(records[i].ID);
                }
            }
            RowIdArry.unshift(record.ID)     //将展示名置于首位
            var RowIdStr = RowIdArry.join(",");
            
            var refrecords = $("#splitreflist").datagrid('getRows'); //获取准备合并列表的所有行。
            var RefArry = [];
            for (var i = 0; i < refrecords.length; i++) {                
                RefArry.push(refrecords[i].ID);                
            }
            RefArry = RefArry.join(",");

            var existstr = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","IsMatch",record.ID)
            var existflag=existstr.split("^")[0]
            var matchglobal=existstr.split("^")[1]
            if ((existstr.split("^")[0]==0)||(existstr==0))  //不存在，新增术语
            {
                var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","SplitGlobalData",RowIdStr,RefArry,"")
                var data = eval('(' + result + ')');
                if (data.success == 'true') 
                {
                    $.messager.popover({
                        msg: '拆分成功！',
                        type: 'success',
                        timeout: 1000
                    });
                    $("#ErrorBox").val("");
                    $('#splitaliaslist').datagrid("loadData",[])
                    $('#splitreflist').datagrid("loadData",[])

                    var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",data.id);
                  
                    var rowdata=eval('('+rowdata+')');

                    GlobalID = data.id
                    LoadEditList(rowdata);
                    
                    LoadAliasList(GlobalID);
                    $('#referencecenterlistgrid').datagrid('load',  { 
                        ClassName:"web.DHCBL.MKB.MKBGlobal",
                        QueryName:"GetReferenceList",    
                        'GlobalRowId':GlobalID
                    });

                    //关闭辅助功能区tabs页
                    $('#tab_div').tabs('close', "术语拆分<span class='hidecls'></span>");
                    //折叠辅助功能区
                    $('#test').layout('collapse', 'east');
                    $("#tt").tabs('select', "属性维护");
                } else {

                    var errorMsg = ""
                    if (data.info) {
                        $("#ErrorBox").val(data.info);
                    }
                }
            }
            else    //存在，报重复
            {

                $("#ErrorBox").val("名称重复:已存在术语！");
                $("#confirmsplit").attr("style","margin-left: 30px;width: 100px;display:block;");
                 // 渲染确认拆分按钮
                $("#confirmsplit").linkbutton({
                    onClick: function() {
                        //调用后台方法 去执行引用
                        var rs = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","SplitGlobalData",RowIdStr,RefArry,matchglobal)
                        var rs = eval('(' + rs + ')');
                        if (rs.success == 'true') {
                            $.messager.popover({
                                msg: '引用成功！',
                                type: 'success',
                                timeout: 1000
                            });
                            $("#ErrorBox").val("");
                            $('#splitaliaslist').datagrid("loadData",[])
                            $('#splitreflist').datagrid("loadData",[])
                            var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",rs.id);
                  
                            var rowdata=eval('('+rowdata+')');

                            GlobalID = rs.id
                            LoadEditList(rowdata);
                            LoadAliasList(GlobalID);
                            $('#referencecenterlistgrid').datagrid('load',  { 
                                ClassName:"web.DHCBL.MKB.MKBGlobal",
                                QueryName:"GetReferenceList",    
                                'GlobalRowId':GlobalID
                            });
                            
                            //关闭辅助功能区tabs页
                            $('#tab_div').tabs('close', "术语拆分<span class='hidecls'></span>");
                            //折叠辅助功能区
                            $('#test').layout('collapse', 'east');
                            $("#tt").tabs('select', "属性维护");
                        }
                    }
                });
            }            
        })
        //关闭页签
        $('#cancelsplit').click(function(e) {
            $('#splitaliaslist').datagrid("loadData",[])
            $('#tab_div').tabs('close', "术语拆分<span class='hidecls'></span>");
            $('#test').layout('collapse', 'east');
        })
        var Aliaslistcolumns = [
            [ {
                field: 'ID',
                title: 'ID',
                //sortable: true,
                width: 100,
                hidden: true
            }, {
                field: 'Desc',
                title: '描述',
                //sortable: true,
                width: 100
            }]
            ]
        $HUI.datagrid("#splitaliaslist", {
            //url:$URL,
            columns: Aliaslistcolumns,
            remoteSort: false,
            pagination: false, //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
            singleSelect: true,
            checkOnSelect: false,
            selectOnCheck: false,
            idField: 'ID',
            rownumbers: false, //设置为 true，则显示带有行号的列。
            fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            scrollbarSize: 0,
            onRowContextMenu: function(e, rowIndex, rowData) {
                var $clicked = $(e.target);
                copytext = $clicked.text() || $clicked.val() //普通复制功能
                e.preventDefault(); //阻止浏览器捕获右键事件
                var record = $(this).datagrid("selectRow", rowIndex); //根据索引选中该行 
                var mygridmm = $('<div style="width:120px;"></div>').appendTo('body');
                mygridmm.html('<div id="del_menu" onclick="DelSplitlist()" iconCls="icon-cancel" data-options="">删除</div>').click(stopPropagation);
                mygridmm.menu({
                    onClick: function(item) {
                        var itemid = item.id
                    }
                });
                mygridmm.menu('show', {
                    left: e.pageX,
                    top: e.pageY
                });
            }
        }); 
        //删除拆分列表行数据
        DelSplitlist = function() {
            var record = $("#splitaliaslist").datagrid("getSelected");
            var RowIndex = $("#splitaliaslist").datagrid("getRowIndex", record.ID);
            $("#splitaliaslist").datagrid("deleteRow", RowIndex);
        } 
        var Reflistcolumns = [
            [ {
                field: 'ID',
                title: 'ID',
                //sortable: true,
                width: 100,
                hidden: true
            }, {
                field: 'Desc',
                title: '名称',
                width: 100
            }, {
                field: 'Place',
                title: '引用位置',
                width: 100
            }]
            ]
        $HUI.datagrid("#splitreflist", {
            //url:$URL,
            columns: Reflistcolumns,
            remoteSort: false,
            pagination: false, //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
            singleSelect: true,
            checkOnSelect: false,
            selectOnCheck: false,
            idField: 'ID',
            rownumbers: false, //设置为 true，则显示带有行号的列。
            fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            scrollbarSize: 0,
            onRowContextMenu: function(e, rowIndex, rowData) {
                var $clicked = $(e.target);
                copytext = $clicked.text() || $clicked.val() //普通复制功能
                e.preventDefault(); //阻止浏览器捕获右键事件
                var record = $(this).datagrid("selectRow", rowIndex); //根据索引选中该行 
                var mygridmm = $('<div style="width:120px;"></div>').appendTo('body');
                mygridmm.html('<div id="del_menu" onclick="DelSplitReflist()" iconCls="icon-cancel" data-options="">删除</div>').click(stopPropagation);
                mygridmm.menu({
                    onClick: function(item) {
                        var itemid = item.id
                    }
                });
                mygridmm.menu('show', {
                    left: e.pageX,
                    top: e.pageY
                });
            }
        }); 
        //删除拆分引用列表行数据
        DelSplitReflist = function() {
            var record = $("#splitreflist").datagrid("getSelected");
            var RowIndex = $("#splitreflist").datagrid("getRowIndex", record.ID);
            $("#splitreflist").datagrid("deleteRow", RowIndex);
        }
          
    })
    
    //术语合并菜单
    $("#MergeData").click(function(e) {
        if (GlobalID=="")
        {
            return
        }
        else
        {
            MergeDataFunlib()
            $('#mergelist').datagrid("loadData",[])                            
            var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",GlobalID);                  
            var rowdata=eval('('+rowdata+')');
            $('#mergelist').datagrid('insertRow',{ row:rowdata});
            if ($("#tab_div").tabs('exists', "ICD查询<span class='hidecls'></span>")) {
                //20210830
               var rows=$('#mergelist').datagrid("getRows")
                var records=$("#SICDCoderesultlist").datagrid("getChecked")
                if (records.length>0)
                {
                    for (var m=0;m<records.length;m++)
                    {
                        var rowid=records[m].MKBGRowId
                          
                        var rowindex=$('#mergelist').datagrid("getRowIndex",rowid)
                        if (rowindex==-1)
                        {
                            var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",rowid)
                                
                            var rowdata=eval('('+rowdata+')');
                            if (rowdata.MKBGDesc!="")
                            {
                                $('#mergelist').datagrid('insertRow',{ row:rowdata});  
                            }
                                                         
                        }
                    }
                    
                }
            }
        }


    }); 
    //术语合并方法
    MergeDataFunlib=function(){

        if ($("#tab_div").tabs('exists', "术语合并<span class='hidecls'></span>")) {
            $("#tab_div").tabs('select', "术语合并<span class='hidecls'></span>");
        } else {
            $('#tab_div').tabs('add', {
                title: "术语合并<span class='hidecls'></span>",
                //id: "tab_" + MKBGRRowId
                id: "MergeData",
                //content:'Tab Body',//里边可以插html内容    
                closable: true,
                //href:url
            });
        }
        $('.tabs .tabs-inner').css('line-height', '16px');
        $('.tabs .tabs-inner').css('height', 'auto');
        $('.tabs .tabs-inner').css('padding', '6px');
       // $('.tabs .tabs-inner .tabs-title').css('white-space', 'pre-wrap');
        $('#test').layout('expand', 'east');
        SetHeight();
        $('#tt').tabs('resize');
        $("#ttt").css("width","1200px");
        $("#myeditgrid").datagrid('resize');
        $("#MergeData").html('<div style="width:100%;height:70%" border:"false"><table data-options="fit:true" id="mergelist" ></table></div><div><a href="#" class="hisui-linkbutton" style="padding-left:40px;display:none" id="reloadlist">刷新列表</a><table align=center cellspacing="30" ><tr><td><a href="#" class="hisui-linkbutton" id="mergedesc">合并术语</a></td><td><a href="#" class="hisui-linkbutton"  id="mergeend">放弃操作</a></td></tr></table></div><div style="width:100%;height:20%"> <table><tr><td style="padding:10px 0">术语查询</td><td><input style="width:165px" id="TextGlobal" /><span class="searchbox-button" style="margin:1px 0 0 -30px;" id="BtnGlobal"></span></td></tr></table></div>');
        // 渲染按钮
        $("#mergedesc").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
        // 渲染按钮
        $("#mergeend").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });    
        //$('#TextGlobal').combobox("setValue","")
        var SearchGlobalText=""
        //术语查询查询框 
        $('#TextGlobal').searchcombobox({ 
            url:$URL+"?ClassName=web.DHCBL.MKB.MKBGlobal&QueryName=GetTermForCmb2&ResultSetType=array&markstr="+MKBGMark+"&SortMethod="+SortMethod+"&SortLocStr="+PreLocStr+"&LocFreq="+PreFreq,
            onLoadSuccess:function(data)
            {

                var thetext=$('#TextGlobal').combobox('getText')
                if (thetext!="...")
                {
                    SearchGlobalText=thetext
                }
                else
                {
                    SearchGlobalText=""
                }


            },
             onSelect:function (record) 
            {   
                $('#TextGlobal').combobox('setValue',SearchGlobalText)  //保持查询条件不变
                if (record.Desc=="...")
                {
                      //保持查询条件不变
                    //数据超过11条,显示...，点击后辅助功能区 弹窗显示对应的所有数据 
                    MergeResultFunlib()
                }
                else
                {
                    
                    $(this).combobox('textbox').focus();
                    var galobalid=record.ID.split("||")[0]
                    var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",galobalid)
                    var rowdata=eval('('+rowdata+')');
                    
                    if (rowdata!="")
                    {
                        var sameflag=0
                        var mergelistRows=$('#mergelist').datagrid('getRows')
                        for (var i=0;i<mergelistRows.length;i++)
                        {
                            if (mergelistRows[i].MKBGRowId==rowdata.MKBGRowId)
                            {
                                sameflag=1
                            }
                        }   
                        if (sameflag==0) //不存在重复
                        {
                            $('#mergelist').datagrid('insertRow',{ row:rowdata});
                        }
                    }
                    
                }
                
            }
        });
        $('#TextGlobal').combobox('textbox').bind('keyup',function(e){  
            if (e.keyCode==13){ 
                //TextSearchFun() 
                var SearchGlobalText =$('#TextGlobal').combobox('getValue')
                $('#TextGlobal').combobox('setValue',SearchGlobalText)
                
                var url=$URL+"?ClassName=web.DHCBL.MKB.MKBGlobal&QueryName=GetTermForCmb2&ResultSetType=array&markstr="+MKBGMark+"&matchflag=1&q="+SearchGlobalText+"&SortMethod="+SortMethod+"&SortLocStr="+PreLocStr+"&LocFreq="+PreFreq;
                $('#TextGlobal').combobox('reload', url)
                $('#TextGlobal').combobox("showPanel")               
            }
        }); 

        $("#BtnGlobal").click(function (e) { 
            //点击查询录入框查询按钮   精确匹配
            var SearchGlobalText =$('#TextGlobal').combobox('getValue')
            $('#TextGlobal').combobox('setValue',SearchGlobalText)
            
            var url=$URL+"?ClassName=web.DHCBL.MKB.MKBGlobal&QueryName=GetTermForCmb2&ResultSetType=array&markstr="+MKBGMark+"&matchflag=1&q="+SearchGlobalText+"&SortMethod="+SortMethod+"&SortLocStr="+PreLocStr+"&LocFreq="+PreFreq;
            $('#TextGlobal').combobox('reload', url)
            $('#TextGlobal').combobox("showPanel") 
            
        })
        $('#TextGlobal').combobox({
            onChange:function(newValue, oldValue){
                if (newValue=="")
                {
                    var url = $URL+"?ClassName=web.DHCBL.MKB.MKBGlobal&QueryName=GetTermForCmb2&ResultSetType=array"
                    $('#TextGlobal').combobox('reload', url)
                    $('#TextGlobal').combobox("resize")  
                }
                    
            }
        })
        MergeResultFunlib=function(){
            SearchGlobalText =$('#TextGlobal').combobox('getText')
            
            $("#myTaglist").css("left", "140px");
            if ($("#tab_div").tabs('exists', "查询结果-"+SearchGlobalText+"<span class='hidecls'></span>")) {
                $("#tab_div").tabs('select', "查询结果-"+SearchGlobalText+"<span class='hidecls'></span>");
            } else {
                $('#tab_div').tabs('add', {
                    title: "查询结果-"+SearchGlobalText+"<span class='hidecls'></span>",
                    //id: "tab_" + MKBGRRowId
                    id: "SearchResult_"+SearchGlobalText,
                    //content:'Tab Body',//里边可以插html内容    
                    closable: true,
                    //href:url
                });
            };
            // 辅助功能区表达式页签增加html代码
            $("#SearchResult_"+SearchGlobalText).css('position', 'relative');
            $("#SearchResult_"+SearchGlobalText).html('<div ><a style="color:#000" >全部搜索结果:</a></div ><div style="height:80%"><table data-options="fit:true" style="width:100%;position:absolute;height:90%" id="ResultListDiv_'+SearchGlobalText+'" ></table></div >');
            var GlobalTable = $('<table data-options="fit:true"  id="allresultlist_'+SearchGlobalText+'" border="false"></table>')
            $("#ResultListDiv_"+SearchGlobalText).html(GlobalTable);
            //$("#allresultlist_"+SearchGlobalText).datagrid("resize");
            //PickWord();
            
            var srcolumns = [
                [{
                    field: 'ck',
                    checkbox:true
                },{
                    field: 'MKBGRowId',
                    title: 'MKBGRowId',
                    //sortable: true,
                    width: 100,
                    hidden: true
                }, {
                    field: 'MKBGCode',
                    title: '编码',
                    //sortable: true,
                    width: 100,
                    hidden: true
                }, {
                    field: 'MKBGDesc',
                    title: '展示名',
                    //sortable: true,
                    width: 100,
                    editor: 'validatebox'
                }, {
                    field: 'MKBGEnName',
                    title: '英文名',
                    //sortable: true,
                    width: 50,
                    editor: 'validatebox',
                    hidden: true
                }, {
                    field: 'MKBGNote',
                    title: '备注',
                    //sortable: true,
                    width: 600,
                    hidden: true,
                    //fixed: true,
                    editor: {
                        type: 'textarea'
                    },
                    formatter: function(value, row, index) {
                        //鼠标悬浮显示备注信息
                        return '<span class="mytooltip" title="' + row.MKBGNote + '">' + value + '</span>'
                    }
                }, {
                    field: 'MKBGAlias',
                    title: '别名',
                    width: 100,
                    hidden: true
                }, {
                    field: 'MKBGPYCode',
                    title: '检索码',
                    sortable: true,
                    width: 100,
                    hidden: true,
                    editor: 'validatebox'
                }, {
                    field: 'MKBGLastLevel',
                    title: '引用位置',
                    //sortable: true,
                    hidden: true,
                    width: 100
                }, {
                    field: 'MKBGState',
                    title: '状态',
                    //sortable: true,
                    hidden: true,
                    width: 100,
                    formatter: function(value, row, index) {
                        if (value == "U") {
                            return '<span href="#" title="在用"  class="mytooltip">在用</span>';
                        } else if (value == "S") {
                            return '<span href="#" title="封闭" class="mytooltip">封闭</span>';
                        } else if (value == "D") {
                            return '<span href="#" title="删除" class="mytooltip">删除</span>';
                        } else if (value == "M") {
                            return '<span href="#" title="合并" class="mytooltip">合并</span>';
                        }
                    }
                }, {
                    field: 'MKBGConfirm',
                    title: '确认状态',
                    width: 100,
                    hidden: true,
                    styler: function(value, row, index) {
                        if (value == "Y") {
                            return 'background-color:#33FF66;';
                        } else {
                            return 'background-color:#FF0033;';
                        }
                    },
                    formatter: function(value, row, index) {
                        if (value == "Y") {
                            return '<span href="#" title="已确认"  class="mytooltip">已确认</span>';
                        } else {
                            return '<span href="#" title="未确认" class="mytooltip">未确认</span>';
                        }
                    }
                }, {
                    field: 'TopDataFlag',
                    title: 'TopDataFlag',
                    width: 80,
                    hidden: true
                }, {
                    field: 'MKBGloMark',
                    title: '标记',
                    width: 80,
                    hidden: true
                }, {
                    field: 'MKBGDiaTotalFreq',
                    title: '频次',
                    sortable: true,
                    sorter:function(a,b){
                        return(Number(a)<Number(b)?1:-1);
                    },
                    width: 80,
                    hidden: true
                }]
            ];

            $HUI.datagrid("#allresultlist_"+SearchGlobalText, {
                url: $URL,
                queryParams: {
                    ClassName: "web.DHCBL.MKB.MKBGlobal", 
                    QueryName: "GetList",
                    'desc': SearchGlobalText,
                    'Type': Type,
                    'MarkStr': MKBGMark
                },
                columns:srcolumns,
                remoteSort: false,
                pagination: true, //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
                pageSize: 20,
                pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500, 1000],
                singleSelect: true,    //允许多选
                checkOnSelect: false,
                selectOnCheck: false,
                idField: 'MKBGRowId',
                rownumbers: false, //设置为 true，则显示带有行号的列。
                fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
                scrollbarSize: 0,
                onSelect: function(index, row){
                    SetHeight();
                    GlobalID=row.MKBGRowId                                       
                    LoadEditList(row);
                    LoadAliasList(GlobalID);
                    LoadReferenceList(GlobalID); 
                   
                },
                onCheck: function(index, row){
                    var sameflag=0
                    var mergelistRows=$('#mergelist').datagrid('getRows')
                    for (var i=0;i<mergelistRows.length;i++)
                    {
                        if (mergelistRows[i].MKBGRowId==row.MKBGRowId)
                        {
                            sameflag=1
                        }
                    }   
                    if (sameflag==0) //不存在重复
                    {
                        $('#mergelist').datagrid('insertRow',{ row:row});
                    }
                },
                onUncheck: function(index, row){
                    var index=$("#mergelist").datagrid('getRowIndex',row.MKBGRowId)
                    if (index!=-1)
                    {
                        $("#mergelist").datagrid('deleteRow',index)

                    }
                },
                
                onLoadSuccess:function(data){
                    $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
                    $(this).datagrid('columnMoving'); //列可以拖拽改变顺序
                }
            });   
        }
        
        
        //关闭合并术语页签
        $('#mergeend').click(function(e) {
            $('#mergelist').datagrid("loadData",[])  
            $("#globalgrid").datagrid('clearChecked');   
            $('#tab_div').tabs('close', "术语合并<span class='hidecls'></span>");
            $('#test').layout('collapse', 'east');
            $('#tt').tabs('resize');
        })
        var columns = [
            [{
                field: 'MKBGRowId',
                title: 'MKBGRowId',
                //sortable: true,
                width: 100,
                hidden: true
            }, {
                field: 'MKBGCode',
                title: '编码',
                //sortable: true,
                width: 100,
                hidden: true
            }, {
                field: 'MKBGDesc',
                title: '待合并数据',
                //sortable: true,
                width: 100,
                editor: 'validatebox'
            }, {
                field: 'MKBGEnName',
                title: '英文名',
                //sortable: true,
                width: 50,
                editor: 'validatebox',
                hidden: true
            }, {
                field: 'MKBGNote',
                title: '备注',
                //sortable: true,
                width: 600,
                hidden: true,
                //fixed: true,
                editor: {
                    type: 'textarea'
                },
                formatter: function(value, row, index) {
                    //鼠标悬浮显示备注信息
                    return '<span class="mytooltip" title="' + row.MKBGNote + '">' + value + '</span>'
                }
            }, {
                field: 'MKBGAlias',
                title: '别名',
                width: 100,
                hidden: true
            }, {
                field: 'MKBGPYCode',
                title: '检索码',
                sortable: true,
                width: 100,
                hidden: true,
                editor: 'validatebox'
            }, {
                field: 'MKBGLastLevel',
                title: '引用位置',
                //sortable: true,
                hidden: true,
                width: 100
            }, {
                field: 'MKBGState',
                title: '状态',
                //sortable: true,
                hidden: true,
                width: 100,
                formatter: function(value, row, index) {
                    if (value == "U") {
                        return '<span href="#" title="在用"  class="mytooltip">在用</span>';
                    } else if (value == "S") {
                        return '<span href="#" title="封闭" class="mytooltip">封闭</span>';
                    } else if (value == "D") {
                        return '<span href="#" title="删除" class="mytooltip">删除</span>';
                    } else if (value == "M") {
                        return '<span href="#" title="合并" class="mytooltip">合并</span>';
                    }
                }
            }, {
                field: 'MKBGConfirm',
                title: '确认状态',
                width: 100,
                hidden: true,
                styler: function(value, row, index) {
                    if (value == "Y") {
                        return 'background-color:#33FF66;';
                    } else {
                        return 'background-color:#FF0033;';
                    }
                },
                formatter: function(value, row, index) {
                    if (value == "Y") {
                        return '<span href="#" title="已确认"  class="mytooltip">已确认</span>';
                    } else {
                        return '<span href="#" title="未确认" class="mytooltip">未确认</span>';
                    }
                }
            }, {
                field: 'TopDataFlag',
                title: 'TopDataFlag',
                width: 80,
                hidden: true
            }, {
                field: 'MKBGloMark',
                title: '标记',
                width: 80,
                hidden: true
            }, {
                field: 'MKBGDiaTotalFreq',
                title: '频次',
                sortable: true,
                sorter:function(a,b){
                    return(Number(a)<Number(b)?1:-1);
                },
                width: 80,
                hidden: true
            }]
        ];
        $HUI.datagrid("#mergelist", {
            //url: $URL,
            queryParams: {
                //ClassName: "web.DHCBL.MKB.SDSDiagnosTimeline",
                //QueryName: "OutputTable",
                //SDSDiagnosId: ids
            },
            columns: columns,
            sortName:'MKBGDiaTotalFreq',
            sortOrder:'asc',
            remoteSort: false,
            pagination: false, //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
            singleSelect: true,
            checkOnSelect: false,
            selectOnCheck: false,
            idField: 'MKBGRowId',
            rownumbers: false, //设置为 true，则显示带有行号的列。
            fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            scrollbarSize: 0,
            onLoadSuccess: function(data) {
                //$('#reloadlist').click();
                //console.log(data)
                /*$(this).prev().find('div.datagrid-body').prop('scrollTop', 0);*/                
            },
            onClickRow: function(index, row) {
            //alert(index)
            GlobalID = row.MKBGRowId;
            LoadEditList(row);
            LoadAliasList(GlobalID);
            LoadReferenceList(GlobalID);
            //RefreshSearchData("User.MKBGlobal", GlobalID, "A", row.MKBGDesc)                
           },
            onRowContextMenu: function(e, rowIndex, rowData) {
                var $clicked = $(e.target);
                copytext = $clicked.text() || $clicked.val() //普通复制功能
                e.preventDefault(); //阻止浏览器捕获右键事件
                var record = $(this).datagrid("selectRow", rowIndex); //根据索引选中该行 
                var mygridmm = $('<div style="width:120px;"></div>').appendTo('body');
                mygridmm.html('<div id="del_menu" onclick="Delmergelist()" iconCls="icon-cancel" data-options="">删除</div>').click(stopPropagation);
                mygridmm.menu({
                    onClick: function(item) {
                        var itemid = item.id
                    }
                });
                mygridmm.menu('show', {
                    left: e.pageX,
                    top: e.pageY
                });
                

            }
        });
        

        //删除待合并列表行数据
        Delmergelist = function() {
            var record = $("#mergelist").datagrid("getSelected");
            var RowIndex = $("#mergelist").datagrid("getRowIndex", record.MKBGRowId);
            $("#mergelist").datagrid("deleteRow", RowIndex);
        }
        //添加合并的项
        $('#reloadlist').click(function(e) {
            $('#mergelist').datagrid("loadData",[]) 
            var arr = $("#globalgrid").datagrid('getChecked');
            $('#mergelist').datagrid('loadData', arr);
        })
        //$('#reloadlist').click();
        $('#mergedesc').click(function() {
            mergedesc();
        });
        mergedesc = function() {
            var records = $("#mergelist").datagrid('getRows'); //获取准备合并列表的所有行。
            var record = $("#mergelist").datagrid('getSelected');
            if ((record=="")||(record=="null")||(record==null))
            {
                $.messager.alert('错误提示', '请选择要合并到的术语!', "error");
                return
            }
            var RowIdArry = [];
            for (var i = 0; i < records.length; i++) {
                if (records[i].MKBGRowId != record.MKBGRowId)
                 {
                    RowIdArry.push(records[i].MKBGRowId);
                    CancelTop(records[i])
                }
            }
            RowIdArry.unshift(record.MKBGRowId)     //要合并到的术语置于首位
            var RowIdStr = RowIdArry.join(",");
            var test = RowIdStr.indexOf(record.MKBGRowId);
            if (test == -1) {
                $.messager.alert('错误提示', '请选择正确的合并数据!', "error");
                return
            }
            //$.messager.confirm('提示', '确定要合并所选的数据吗?', function(r) {
            //if (r) {
            $.ajax({
                url: MERGE_ACTION_URL,
                data: {
                    "RowIdStr": RowIdStr
                },
                type: "POST",
                success: function(data) {
                    $("#globalgrid").datagrid('clearSelections');
                    var data = eval('(' + data + ')');
                    if (data.success == 'true') {
                        $.messager.popover({
                            msg: '合并成功！',
                            type: 'success',
                            timeout: 1000
                        });
                        if (SearchGlobalDesc!="")   //从患者诊断信息浏览跳转过来的，在合并后，需要清除原先的传参数据
                        {
                            SearchGlobalDesc=""
                            jumpoption=""
                            mergeidstr=""
                        }
                        $('#globalgrid').datagrid('reload'); // 重新载入当前页面数据 
                        mergedata = record;
                        GlobalID = record.MKBGRowId;
                        //$('#globalgrid').datagrid('unselectAll'); // 清空列表选中数据
                        //$("#globalgrid").datagrid('selectRow', record.MKBGRowId);
                        $("#globalgrid").datagrid('clearChecked'); //清空check状态
                        $('#reloadlist').click();
                        //LoadSameGlobal();
                        editIndex = undefined;
                        rowsvalue = undefined;
                        
                        //关闭辅助功能区tabs页
                        $('#tab_div').tabs('close', "术语合并<span class='hidecls'></span>");
                        //折叠辅助功能区
                        $('#test').layout('collapse', 'east');
                        $("#tt").tabs('select', "属性维护");
                    } else {
                        var errorMsg = ""
                        if (data.info) {
                            errorMsg = '合并失败！<br/>错误信息:' + data.info
                            $.messager.alert('操作提示', errorMsg, "error");
                        }
                    }
                }
            })
            //}
            //});
        };
    }     
    //新增名称菜单
    $("#AddGloalName").click(function(e){
        
        $("#myalias")[0].contentWindow.AddAlias();
    })
    
    //新增别名菜单
    $("#AddGloalias").click(function(e) {
        if ($("#tab_div").tabs('exists', "新增别名<span class='hidecls'></span>")) {
            $("#tab_div").tabs('select', "新增别名<span class='hidecls'></span>");
        } else {
            $('#tab_div').tabs('add', {
                title: "新增别名<span class='hidecls'></span>",
                //id: "tab_" + MKBGRRowId
                id: "AddGloalias",
                //content:'Tab Body',//里边可以插html内容    
                closable: true,
                //href:url
            });
        }
        $('.tabs .tabs-inner').css('line-height', '16px');
        $('.tabs .tabs-inner').css('height', 'auto');
        $('.tabs .tabs-inner').css('padding', '6px');
       // $('.tabs .tabs-inner .tabs-title').css('white-space', 'pre-wrap');
        $('#test').layout('expand', 'east');
        var MKBGDesc = $("#globalgrid").datagrid("getSelected").MKBGDesc;
        $("#AddGloalias").html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">当前术语为:</td></tr><tr><td><span>' + MKBGDesc + '</span></td></tr><tr><td style="padding:10px 0">请输入您要添加的别名名称</td></tr><tr><td><input  id="addaliasname" type="text"  style="width:258px" ></td></tr><tr><td style="padding:10px 0">名称检索码</td></tr><tr><td><input  id="aliasnamepy" type="text"  style="width:258px" ></td></tr><tr><td style="padding:10px 0">选择别名标志</td></tr><tr><td><select id="aliasmark" style="width:265px;"></select></td></tr></table><div><a href="#" class="hisui-linkbutton" style="padding-left:40px" id="addalias">新增别名</a><a href="#" class="hisui-linkbutton" style="padding-left:80px" id="closealias">关闭窗口</a></div>')
        //术语名失去焦点自动生成检索码
        $('#addaliasname').bind('blur', function() {
            $("#aliasnamepy").val(Pinyin.GetJPU($('#addaliasname').val()))
        });
        var aliasmark = $HUI.combobox("#aliasmark", {
            valueField: 'id',
            textField: 'text',
            //multiple:true,
            //rowStyle:'checkbox', //显示成勾选行形式
            selectOnNavigation: false,
            panelHeight: "auto",
            editable: false,
            data: [{
                id: '1',
                text: '别名',
                selected: true
            }, {
                id: '2',
                text: '中心词'
            }, {
                id: '3',
                text: '展示名'
            }]
        });
        //新增别名按钮
        $("#addalias").click(function(e) {
            var dataID = $("#globalgrid").datagrid("getSelected").MKBGRowId;
            var alaisname = $("#addaliasname").val();
            if (alaisname == "") {
                $.messager.alert('错误提示', '新增别名名称不能为空!', "error");
                return;
            }
            var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "AddMKBGAlias", dataID, alaisname);
            var result = eval('(' + result + ')');
            if (result.success == 'success') {
                $.messager.popover({
                    msg: '新增成功！',
                    type: 'success',
                    timeout: 1000
                });
                $("#aliasnamepy").val('');
                $("#addaliasname").val('');
            } else {
                $.messager.popover({
                    msg: result.info,
                    type: 'error',
                    timeout: 1000
                });
            }
        })
    })
    
    //引用处理按钮
    $("#RefHandle").click(function(e) {
        if ($("#tab_div").tabs('exists', "引用处理<span class='hidecls'></span>")) {
            $("#tab_div").tabs('select', "引用处理<span class='hidecls'></span>");
        } else {
            $('#tab_div').tabs('add', {
                title: "引用处理<span class='hidecls'></span>",
                //id: "tab_" + MKBGRRowId
                id: "RefHandle",
                //content:'Tab Body',//里边可以插html内容    
                closable: true,
                //href:url
            });
        }
        $('.tabs .tabs-inner').css('line-height', '16px');
        $('.tabs .tabs-inner').css('height', 'auto');
        $('.tabs .tabs-inner').css('padding', '6px');
       // $('.tabs .tabs-inner .tabs-title').css('white-space', 'pre-wrap');
        $('#test').layout('expand', 'east');
        $("#RefHandle").html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">确认清洗范围</td></tr><tr><td><select id="refrange" style="width:265px;"></select></td></tr><tr><td style="padding:10px 0">选择清洗方式</td></tr><tr><td><select id="refmethod" style="width:265px;"></select></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="refstart">开始清洗</a></td><td><a href="#" class="hisui-linkbutton"  id="refend">关闭窗口</a></td></tr></table></div>')
         // 渲染按钮
        $("#refstart").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
         // 渲染按钮
        $("#refend").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
        var refrange = $HUI.combobox("#refrange", {
            valueField: 'id',
            textField: 'text',
            //multiple:true,
            //rowStyle:'checkbox', //显示成勾选行形式
            selectOnNavigation: false,
            panelHeight: "auto",
            editable: false,
            data: [{
                id: '1',
                text: '当前选中术语',
                selected: true
            }, {
                id: '2',
                text: '当前查询术语集'
            }, {
                id: '3',
                text: '词表内所有术语'
            }]
        });
        var refmethod = $HUI.combobox("#refmethod", {
            valueField: 'id',
            textField: 'text',
            multiple: true,
            rowStyle: 'checkbox', //显示成勾选行形式
            selectOnNavigation: false,
            panelHeight: "auto",
            editable: false,
            data: [{
                id: '1',
                text: 'ICD2.0匹配',
                selected: true
            }, {
                id: '2',
                text: '医大一ICD匹配',
                selected: true
            }, {
                id: '3',
                text: '临床实用诊断匹配'
            }]
        });
        //引用处理开始清洗按钮
        $('#refstart').click(function(e) {
            var rangeStr = $('#refrange').combobox('getValue');
            var methodArry = $('#refmethod').combobox('getValues');
            var methodStr = methodArry.join(',');
            //var descStr = $('#westTextDesc').combobox('getText');
            var dataID = $("#globalgrid").datagrid("getSelected").MKBGRowId;
            var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "RefHandle", rangeStr, methodStr, dataID);
            if (result == "success") {
                $.messager.popover({
                    msg: '数据清洗完成!',
                    type: 'success',
                    timeout: 1000
                });
            }
        })
        //关闭引用处理页签
        $('#refend').click(function(e) {
            $('#tab_div').tabs('close', "引用处理<span class='hidecls'></span>");
            $('#test').layout('collapse', 'east');
        })
    })
    //临床实用诊断标记按钮
    $("#GlobalMark").click(function(e) {
         
        var  markresult=tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","ImportDataByTerm");
        $.messager.popover({msg: '处理完成！',type:'success',timeout: 1000});
    });
    
    //空格处理按钮
    $("#SpaceData").click(function(e) {
        HandlerFunction("SpaceData")
        
    })

    //全角/半角按钮
    $("#FullData").click(function(e) {
        HandlerFunction("FullData")
        
    })

    //拆词处理按钮
    $("#SplitData").click(function(e) {
        HandlerFunction("SplitData")
        
    })

    //无效字符处理按钮
    $("#InvalidHandle").click(function(e) {
        HandlerFunction("InvalidHandle")
        
    })
    var HandlerFunction=function(handlerstr){
        if (handlerstr=="SpaceData")
        {
            var handtitle="空格处理"
        }
        else if (handlerstr=="FullData")
        {
            var handtitle="全角/半角"            
        }
        else if (handlerstr=="SplitData")
        {
            var handtitle="拆词处理"            
        }
        else if (handlerstr=="SuffixHandle")
        {
            var handtitle="后缀处理"            
        }
        else if (handlerstr=="InvalidHandle")
        {
            var handtitle="无效字符处理"            
        }
        if ($("#tab_div").tabs('exists', handtitle+"<span class='hidecls'></span>")) {
            $("#tab_div").tabs('select', handtitle+"<span class='hidecls'></span>");
        } else {
            $('#tab_div').tabs('add', {
                title: handtitle+"<span class='hidecls'></span>",
                id: handlerstr,
                closable: true
            });
        }
        $('.tabs .tabs-inner').css('line-height', '16px');
        $('.tabs .tabs-inner').css('height', 'auto');
        $('.tabs .tabs-inner').css('padding', '6px');
       // $('.tabs .tabs-inner .tabs-title').css('white-space', 'pre-wrap');
        $('#test').layout('expand', 'east');

        if (handlerstr=="SuffixHandle")
        {
            $("#"+handlerstr).html('</*table*/ style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">确认处理范围</td></tr><tr><td><select id="'+handlerstr+'rangebox" style="width:265px;"></select></td></tr><tr><td style="padding:10px 0">选择处理方式</td></tr><tr><td><select id="'+handlerstr+'methodbox" style="width:265px;"></select></td></tr><tr id="sufrange1" style="display: none"><td style="padding:10px 0">确认要处理的后缀</td></tr><tr id="sufrange2" style="display: none"><td><select id="'+handlerstr+'sufrange" style="width:265px;"></select></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="'+handlerstr+'starthandle">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="'+handlerstr+'endhandle">放弃操作</a></td></tr></table ></div><table style="width:300px; height:200px;" id="tobemerge" ></table><div><table cellspacing="30" align=center ><tr><td><a href="#" class="hisui-linkbutton"  id="'+handlerstr+'next">下一个</a></td><td><a href="#" class="hisui-linkbutton"  id="'+handlerstr+'doall">批量执行</a></td></tr></table></div>')            
             // 渲染按钮
            $("#"+handlerstr+"next").linkbutton({
                stopAllEventOnDisabled: true,
                onClick: function() {
                }
            });

            $("#"+handlerstr+"doall").linkbutton({
                stopAllEventOnDisabled: true,
                onClick: function() {
                }
            });
        }
        else
        {
             $("#"+handlerstr).html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">确认处理范围</td></tr><tr><td><select id="'+handlerstr+'rangebox" style="width:265px;"></select></td></tr><tr><td style="padding:10px 0">选择处理方式</td></tr><tr><td><select id="'+handlerstr+'methodbox" style="width:265px;"></select></td></tr><tr id="sufrange1" style="display: none"><td style="padding:10px 0">确认要处理的后缀</td></tr><tr id="sufrange2" style="display: none"><td><select id="'+handlerstr+'sufrange" style="width:265px;"></select></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="'+handlerstr+'starthandle">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="'+handlerstr+'endhandle">放弃操作</a></td></tr></table></div>')    
        }
        
         // 渲染按钮
        $("#"+handlerstr+"starthandle").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
         // 渲染按钮
        $("#"+handlerstr+"endhandle").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
        

        
        var MergeDisplay=function(resultstr)
        {
            $('#tobemerge').datagrid("loadData",[]) 
            if (resultstr!="")
            {
                var newarry= new Array(); //定义一数组
                newarry=resultstr.split(","); //字符分割
                for (i=0;i<newarry.length ;i++ )
                {
                    var globalstr=newarry[i]
                    var  mergeid=globalstr.split("^")[0]
                    var  mergedesc=globalstr.split("^")[1]
                    $('#tobemerge').datagrid('insertRow',{ row: {id: mergeid,Desc: mergedesc} });             
                }
            }
                
            $('#tobemerge').datagrid("selectRow",0) 
        }
        //开始按钮
        $('#'+handlerstr+'starthandle').click(function(e) {
            var rangeStr = $('#'+handlerstr+'rangebox').combobox('getValue');
            var methodArry = $('#'+handlerstr+'methodbox').combobox('getValues');
            var methodStr = methodArry.join(',');
            //var descStr = $('#westTextDesc').combobox('getText');
            var selectedglobal=$("#globalgrid").datagrid("getSelected")
            var dataID =GlobalID        //$("#globalgrid").datagrid("getSelected").MKBGRowId;
            if (handlerstr=="SpaceData")
            {
                var handmethod="SpaceHandle"
            }
            else if (handlerstr=="FullData")
            {
                var handmethod="FullDataHandle"            
            }
            else if (handlerstr=="SplitData")
            {
                var handmethod="SplitDataHandle"
                var totalcount=tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","GetTotalCount",rangeStr)             
            }
            else if (handlerstr=="SuffixHandle")
            {
                var handmethod="SuffixHandle"
            }
            else if (handlerstr=="InvalidHandle")
            {
                var handmethod="InvalidHandle"
            }
            
            if (handlerstr=="SuffixHandle") //后缀处理
            {
                var sufstr = "";
                if (methodStr==2)   //自定义后缀
                {

                    var tr= $("#"+handlerstr+"sufrange").combotree('tree');
                    var nodes = tr.tree('getChecked');
                    if(nodes.length > 0){
                        for(var i=0; i<nodes.length; i++){
                           sufstr += nodes[i].id + "," ;
                        }
                        if(sufstr.indexOf(",") > -1){
                            sufstr = sufstr.substring(0, sufstr.length - 1);
                        }
                    } 
                }
                if (rangeStr==1)
                {
                    var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "SuffixHandle", rangeStr,methodStr,sufstr,dataID,0);
                    if (result!="")
                    {
                        
                        var toglobal=result.split("^")[0]
                        var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",toglobal)
                        var rowdata=eval('('+rowdata+')');
                        LoadEditList(rowdata);
                        GlobalID=toglobal
                        LoadAliasList(GlobalID);
                        LoadReferenceList(GlobalID);
                    }
                    else
                    {
                        
                        var index=$("#globalgrid").datagrid('getRowIndex',dataID);
                        GlobalID = dataID;
                        LoadAliasList(GlobalID);
                        LoadReferenceList(GlobalID);
                        /*if (index!=-1)
                        {
                            mergedata=dataID
                        }
                        else
                        {
                            $("#globalgrid").datagrid("reload")
                        } */
                    }                     
                } 
                else
                {

                    var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "SuffixHandle", rangeStr,methodStr,sufstr,dataID,1);
                    if (result!="")
                    {

                        MergeDisplay(result)
                    }
                    else
                    {
                        $("#globalgrid").datagrid("reload")
                    }
                    
                }   
                    
                
            }
            else
            {
               var Handle_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBGlobal&pClassMethod="+handmethod;
                $.ajax({
                    url:Handle_ACTION_URL,  
                    data:{
                        //"id":record.MKBTRowId      ///rowid
                        "rangeStr":rangeStr,
                        "methodStr":methodStr,
                        "dataID":dataID
                    },  
                    type:"get", 
                    success: function(msg){//msg为返回的数据，在这里做数据绑定
                        //成功后隐藏进度条 并且将进度条的值置成0 以免下次没刷新页面 直接再次执行时 value还是100 
                        var index=$("#globalgrid").datagrid('getRowIndex',dataID);
                        //console.log(index)
                        if (index!=-1)
                        {
                            mergedata=selectedglobal
                            $("#globalgrid").datagrid("reload")
                            GlobalID = dataID;
                        } 
                        else
                        {
                            $("#globalgrid").datagrid("reload")
                        }  
                        $('#tab_div').tabs('close', handtitle+"<span class='hidecls'></span>");
                        $('#test').layout('collapse', 'east');                          
                    }
                            
                    });
                    if ((rangeStr!=1)&&(handmethod=="SplitDataHandle"))
                    {
                        $("#ProgressWin").show();
                        var ProgressWin = $HUI.dialog("#ProgressWin",{
                            //iconCls:'icon-w-add',
                            resizable:true,
                            title:'进度',
                            modal:true
                            
                           
                        }); 
                        $('#progress').progressbar({
                            text: '{value}%',
                            value:0
                        })
                        //$('#progress').progressbar('setValue', 0);
                        //调用
                        //setTimeout(start(rangeStr), 200)
                        var t = setInterval(function(){ 
                            var data = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","CountProgress")
                            var thevalue=data/totalcount*100;
                            //console.log(thevalue)
                            if (thevalue < 100){
                                $('#progress').progressbar('setValue', thevalue);
                            }else{
                                setTimeout(function(){
                                    $('#ProgressWin').window('close', true);
                                    $('#progress').progressbar('setValue', 0); 
                                }, 50) 
                                clearInterval(t);
                            }

                        }, 500);
                        //start(rangeStr,totalcount); 
                        //alert($('#progress').progressbar('getValue'))
                    } 
            }
                
                                  
        })

        //下一个按钮
        $('#'+handlerstr+'next').click(function(e) {
            var records = $("#tobemerge").datagrid('getRows'); //获取准备合并列表的所有行。
            if (records.length>=2)
            {
                var record = $("#tobemerge").datagrid('getSelected');
                if ((record=="")||(record=="null")||(record==null))
                {
                    $.messager.alert('错误提示', '请选择要合并到的术语!', "error");
                    return
                }

                var RowIdArry = [];
                for (var i = 0; i < records.length; i++) {
                    if (records[i].id != record.id)
                     {
                        RowIdArry.push(records[i].id);
                        CancelTop(records[i])
                    }
                }
                RowIdArry.unshift(record.id)     //要合并到的术语置于首位
                var RowIdStr = RowIdArry.join(",");
                var test = RowIdStr.indexOf(record.id);
                if (test == -1) {
                    $.messager.alert('错误提示', '请选择正确的合并数据!', "error");
                    return
                }
                    //做合并
                var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "MergeGlobalData", RowIdStr);
                var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",GlobalID)
                var rowdata=eval('('+rowdata+')');
                LoadEditList(rowdata);
                GlobalID=record.id
                LoadAliasList(GlobalID);
                LoadReferenceList(GlobalID);                
            }
            else if (records.length==0)
            {
                $("#globalgrid").datagrid("reload")
            }
            $('#tobemerge').datagrid("loadData",[])
            var rangeStr = $('#'+handlerstr+'rangebox').combobox('getValue');
            if (rangeStr!=1)
            {
               $('#'+handlerstr+'starthandle').click() 
            }
         })

        //批量执行按钮
        $('#'+handlerstr+'doall').click(function(e) {
            $('#tobemerge').datagrid("loadData",[])
            var rangeStr = $('#'+handlerstr+'rangebox').combobox('getValue');
            var methodArry = $('#'+handlerstr+'methodbox').combobox('getValues');
            var methodStr = methodArry.join(',');
            var dataID = $("#globalgrid").datagrid("getSelected").MKBGRowId;
            var selectedglobal=$("#globalgrid").datagrid("getSelected")
            var sufstr = "";
            if (methodStr==2)   //自定义后缀
            {

                var tr= $("#"+handlerstr+"sufrange").combotree('tree');
                var nodes = tr.tree('getChecked');
                if(nodes.length > 0){
                    for(var i=0; i<nodes.length; i++){
                       sufstr += nodes[i].id + "," ;
                    }
                    if(sufstr.indexOf(",") > -1){
                        sufstr = sufstr.substring(0, sufstr.length - 1);
                    }
                } 
            }
                
            var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "SuffixHandle", rangeStr,methodStr,sufstr,dataID,0);
             
            var index=$("#globalgrid").datagrid('getRowIndex',dataID);
            //console.log(index)
            if (index!=-1)
            {
                mergedata=selectedglobal
                $("#globalgrid").datagrid("reload")
                GlobalID = dataID;
            } 
            else
            {
                $("#globalgrid").datagrid("reload")
            }                 
            
         })
        //关闭空格清洗页签
        $('#'+handlerstr+'endhandle').click(function(e) {
            $('#tab_div').tabs('close', handtitle+"<span class='hidecls'></span>");
            $('#test').layout('collapse', 'east');
        })
        var rangebox = $HUI.combobox("#"+handlerstr+"rangebox", {
            valueField: 'id',
            textField: 'text',
            //multiple:true,
            //rowStyle:'checkbox', //显示成勾选行形式
            selectOnNavigation: false,
            panelHeight: "auto",
            editable: false,
            data: [{
                id: '1',
                text: '当前选中术语',
                selected: true
            }, {
                id: '2',
                text: '当前查询术语集'
            }, {
                id: '3',
                text: '词表内所有术语'
            }]
        });
        if (handlerstr=="SpaceData")
        {            
            var methodbox = $HUI.combobox("#"+handlerstr+"methodbox", {
                valueField: 'id',
                textField: 'text',
                multiple: true,
                rowStyle: 'checkbox', //显示成勾选行形式
                selectOnNavigation: false,
                panelHeight: "auto",
                editable: false,
                data: [{
                    id: '1',
                    text: '起始/末尾无效空格',
                    selected: true
                }, {
                    id: '2',
                    text: '左括号前/后空格',
                    selected: true
                }, {
                    id: '3',
                    text: '右括号前空格',
                    selected: true
                }]
            });
        }        
        else if (handlerstr=="FullData")
        {
            $("#rangebox").combobox("select",3) 
             var methodbox = $HUI.combobox("#"+handlerstr+"methodbox", {    
                valueField: 'id',
                textField: 'text',                
                selectOnNavigation: false,
                panelHeight: "auto",
                editable: false,
                data: [{
                    id: '1',
                    text: '全角转半角',
                    selected: true
                }, {
                    id: '2',
                    text: '半角转全角',
                }]
            });
        }
        else if (handlerstr=="SplitData")
        {
            $("#rangebox").combobox("select",1) 
             var methodbox = $HUI.combobox("#"+handlerstr+"methodbox", {    
                valueField: 'id',
                textField: 'text',              
                selectOnNavigation: false,
                panelHeight: "auto",
                editable: false,
                data: [{
                    id: '1',
                    text: '逗号为拆分符',
                    selected: true
                }, {
                    id: '2',
                    text: '顿号为拆分符',
                }, {
                    id: '3',
                    text: '空格为拆分符',
                }, {
                    id: '4',
                    text: '分号为拆分符',
                }, {
                    id: '5',
                    text: '句号为拆分符',
                }]
            });
        }
        else if (handlerstr=="SuffixHandle")
        {
            $("#rangebox").combobox("select",1) 
             var methodbox = $HUI.combobox("#"+handlerstr+"methodbox", {    
                valueField: 'id',
                textField: 'text',                
                selectOnNavigation: false,
                panelHeight: "auto",
                editable: false,
                data: [{
                    id: '1',
                    text: '全部后缀',
                    selected: true
                }, {
                    id: '2',
                    text: '自选后缀',
                }],
                onSelect:function(record){
                    if (record.id==2)       //后缀处理，自选要处理的后缀
                    {
                         $('#sufrange1').css('display',"");
                         $('#sufrange2').css('display',"");
                         //##class(web.DHCBL.MKB.MKBTerm).GetTreeJson(111,1710331)
                         var sufrange = $HUI.combotree("#"+handlerstr+"sufrange", {  
                            url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetTreeJson&base="+base+"&id=1710331",
                            valueField: 'id',
                            textField: 'MKBTDesc',  
                            multiple:true,              
                            selectOnNavigation: false,
                            panelHeight: "auto",
                            editable: false,
                            formatter:function(node){
                                return node.MKBTDesc;
                            },
                            onSelect:function(){
                                //var str=$("#"+handlerstr+"sufrange").combotree("getValues")
                               // console.log(str)
                            }

                        });  
                    }
                    else
                    {
                        $('#sufrange1').css('display',"none");
                        $('#sufrange2').css('display',"none");
                    }
                }
            }); 
             var mergecolumns = [
                [{
                    field: 'id',
                    title: 'id',
                    //sortable: true,
                    width: 100,
                    hidden: true
                }, {
                    field: 'Desc',
                    title: '描述',
                    //sortable: true,
                    width: 100
                }]]
            $HUI.datagrid("#tobemerge", {
                queryParams: {
                },
                columns: mergecolumns,
                remoteSort: false,
                pagination: false, //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
                singleSelect: true,
                checkOnSelect: false,
                selectOnCheck: false,
                idField: 'id',
                rownumbers: false, //设置为 true，则显示带有行号的列。
                fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
                scrollbarSize: 0,
                onLoadSuccess: function(data) {

                },
                onClickRow: function(index, row) {
                    GlobalID = row.id;
                     var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",GlobalID)
                     var rowdata=eval('('+rowdata+')');
                    LoadEditList(rowdata);
                    LoadAliasList(GlobalID);
                    LoadReferenceList(GlobalID);
               }
            }); 

        }
        else if (handlerstr=="InvalidHandle")
        {
            $("#rangebox").combobox("select",1) 
             var methodbox = $HUI.combobox("#"+handlerstr+"methodbox", {    
                valueField: 'id',
                textField: 'text',
                multiple:true,
                rowStyle:'checkbox', //显示成勾选行形式
                selectOnNavigation: false,
                panelHeight: "auto",
                editable: false,
                data: [{
                    id: '1',
                    text: '空格( )',
                    selected: true
                }, {
                    id: '2',
                    text: '顿号(、)',
                }, {
                    id: '3',
                    text: '句号(。)',
                }, {
                    id: '4',
                    text: '(0)',
                }]
            });
        }         
                  
    }
    
    //数据恢复按钮
    $("#RecoverData").click(function(e) {
        var handtitle="数据恢复"
        var handlerstr="RecoverData"
        AlisaDataHandle(handtitle,handlerstr)              
    })
    //后缀处理按钮
    $("#SuffixHandle").click(function(e) {
        HandlerFunction("SuffixHandle")
    })

    //同名合并按钮
    $("#SameMerge").click(function(e) {
        var handtitle="同名合并"
        var handlerstr="SameMerge"
        AlisaDataHandle(handtitle,handlerstr)              
    })

    //别名自检按钮
    $("#AliasSelfCheck").click(function(e) {
        var handtitle="别名自检"
        var handlerstr="AliasSelfCheck"
        AlisaDataHandle(handtitle,handlerstr)              
    })

    //医院引用按钮
    $("#HospitalReference").click(function(e) {
        var handtitle="ICD引用导入"
        var handlerstr="HospitalReference"
        AlisaDataHandle(handtitle,handlerstr)              
    })

    var AlisaDataHandle=function(handtitle,handlerstr){
        if ($("#tab_div").tabs('exists', handtitle+"<span class='hidecls'></span>")) {
            $("#tab_div").tabs('select', handtitle+"<span class='hidecls'></span>");
        } else {
            $('#tab_div').tabs('add', {
                title: handtitle+"<span class='hidecls'></span>",
                id: handlerstr,
                closable: true,
                headerWidth : 120
            });
        }
        $('.tabs .tabs-inner').css('line-height', '16px');
        $('.tabs .tabs-inner').css('height', 'auto');
        $('.tabs .tabs-inner').css('padding', '6px');
        //$('.tabs .tabs-inner .tabs-title').css('white-space', 'pre-wrap');
        $('#test').layout('expand', 'east');
        $("#"+handlerstr).html('<table style="padding:0 7px;padding-bottom:20px"><tr><td style="padding:10px 0">确认处理范围</td></tr><tr><td><select id="'+handlerstr+'rangebox" style="width:265px;"></select></td></tr></table><div><table cellspacing="30" align=center><tr><td><a href="#" class="hisui-linkbutton"  id="'+handlerstr+'starthandle">执行操作</a></td><td><a href="#" class="hisui-linkbutton"  id="'+handlerstr+'endhandle">放弃操作</a></td></tr></table></div>')
         // 渲染按钮
        $("#"+handlerstr+"starthandle").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
         // 渲染按钮
        $("#"+handlerstr+"endhandle").linkbutton({
            stopAllEventOnDisabled: true,
            onClick: function() {
            }
        });
        //开始按钮
        $('#'+handlerstr+'starthandle').click(function(e) {
            var rangeStr = $('#'+handlerstr+'rangebox').combobox('getValue');            
            if (handlerstr=="SameMerge")
            {
                var methodstr="MergeSameDesc"
            }
            else if (handlerstr=="RecoverData")
            {
                var methodstr="RecoveryAlisaHandle"
            }
            else if (handlerstr=="AliasSelfCheck")
            {
                var methodstr="SelfCheckAliasMark"

            }
            else if (handlerstr=="HospitalReference")
            {
                var methodstr="AddMatchFlag"

            }
            if (handlerstr=="HospitalReference")
            {

                var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", methodstr, rangeStr);                
            }   
            else
            {
                var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", methodstr, rangeStr, GlobalID);
                
            }
            if ((result=="true" )||(result=="success"))
            { 
                var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",GlobalID)
                var rowdata=eval('('+rowdata+')');
                LoadEditList(rowdata);
                LoadAliasList(GlobalID);
                $('#referencecenterlistgrid').datagrid('load',  { 
                    ClassName:"web.DHCBL.MKB.MKBGlobal",
                    QueryName:"GetReferenceList",    
                    'GlobalRowId':GlobalID
                });
                $('#tab_div').tabs('close', handtitle+"<span class='hidecls'></span>");
                $('#test').layout('collapse', 'east');
            }
                
        })
            
       // var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","RecoveryAlisa",GlobalID)
         

         //关闭空格清洗页签
        $('#'+handlerstr+'endhandle').click(function(e) {
            $('#tab_div').tabs('close', handtitle+"<span class='hidecls'></span>");
            $('#test').layout('collapse', 'east');
        })
        if (handlerstr=="ICDContrast")
        {            
            var rangebox = $HUI.combobox("#"+handlerstr+"rangebox", {
                valueField: 'id',
                textField: 'text',
                selectOnNavigation: false,
                panelHeight: "auto",
                editable: false,
                data: [{
                    id: '1',
                    text: '当前选中术语',
                    selected: true
                }, {
                    id: '2',
                    text: '当前查询术语集'
                }, {
                    id: '3',
                    text: '词表内所有术语'
                }]
            });
        }
        else if (handlerstr=="HospitalReference")
        {            
             var rangebox = $HUI.combobox("#"+handlerstr+"rangebox", {    
                valueField: 'id',
                textField: 'text',              
                selectOnNavigation: false,
                panelHeight: "auto",
                editable: false,
                data: [{
                    id: '8',
                    text: '西南医科大数据处理工厂',
                    selected: true
                }, {
                    id: '9',
                    text: '香港大学深圳医院数据处理工厂',
                }, {
                    id: '10',
                    text: '天津中医数据处理工厂',
                }, {
                    id: '11',
                    text: '北京大学第一医院数据处理工厂',
                }, {
                    id: '13',
                    text: '武汉市第一医院数据处理工厂',
                }, {
                    id: '14',
                    text: '新安贞数据处理工厂',
                }, {
                    id: '15',
                    text: '东华数据处理工厂',
                }]
            });
        }
        else
        {
            var rangebox = $HUI.combobox("#"+handlerstr+"rangebox", {
                valueField: 'id',
                textField: 'text',
                //multiple:true,
                //rowStyle:'checkbox', //显示成勾选行形式
                selectOnNavigation: false,
                panelHeight: "auto",
                editable: false,
                data: [{
                    id: '1',
                    text: '当前选中术语',
                    selected: true
                }, {
                    id: '2',
                    text: '当前查询术语集'
                }, {
                    id: '3',
                    text: '词表内所有术语'
                }]
            });
        }  

             
    }

    //引用场景按钮
    $("#SearchRef").click(function(e) {
        //addTab('引用场景', 'dhc.bdp.mkb.mkbglobalreference.csp');
        LoadReferenceList(GlobalID)
    })
    //扩展展示按钮
    $("#ChangePage").click(function(e) {})
    

    var westTextDescText =""
    //术语维护查询框
    $('#westTextDesc').searchcombobox({
        //url: $URL + "?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename=" + "User.MKBGlobal",
        url:$URL+"?ClassName=web.DHCBL.MKB.MKBGlobal&QueryName=GetTermForCmb2&ResultSetType=array&markstr="+MKBGMark+"&SortMethod="+SortMethod+"&SortLocStr="+PreLocStr+"&LocFreq="+PreFreq,
        onLoadSuccess:function(data)
        {
            var thetext=$('#westTextDesc').combobox('getText')
            if (thetext!="...")
            {
                westTextDescText=thetext
            }
            else
            {
                westTextDescText=""
            }
           
        },
        onSelect: function(record) {
            
            $('#westTextDesc').combobox('setValue',westTextDescText)
            if (record.Desc=="...")
            {
                //数据超过11条,显示...，点击后辅助功能区 弹窗显示对应的所有数据 2020-05-29
                //alert('辅助功能区显示所有数据，待做')
                ShowInListFunlib(westTextDescText,0)
            }
            else
            {
                SetHeight();
                ClickFun();
                $(this).combobox('textbox').focus();
                GlobalID = record.ID.split("||")[0];
                var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",GlobalID)
                var rowdata=eval('('+rowdata+')');
                //console.log(rowdata)
                
                
                //console.log(GlobalID)
                LoadEditList(rowdata);
                LoadAliasList(GlobalID);
                LoadReferenceList(GlobalID);
                RefreshSearchData("User.MKBGlobal", GlobalID, "A", rowdata.MKBGDisplaName)
                
            }
        }
    });
    //$('#westTextDesc').combobox("setValue","")
    ShowInListFunlib=function(westTextDescText,matchflag)
    {
        $('#test').layout('expand', 'east');
        $("#myTaglist").css("left", "140px");
        if ($("#tab_div").tabs('exists', "查询结果-"+westTextDescText+"_"+matchflag+"<span class='hidecls'></span>")) {
            $("#tab_div").tabs('select', "查询结果-"+westTextDescText+"_"+matchflag+"<span class='hidecls'></span>");
        } else {
            $('#tab_div').tabs('add', {
                title: "查询结果-"+westTextDescText+"_"+matchflag+"<span class='hidecls'></span>",
                //id: "tab_" + MKBGRRowId
                id: "SearchResult_"+westTextDescText+"_"+matchflag,
                //content:'Tab Body',//里边可以插html内容    
                closable: true,
                //href:url
            });
        };
        
        if (matchflag==0)
        {
            var tips="全部搜索结果:"
        }
        else
        {
            var tips="完全匹配结果:"
        }
        // 辅助功能区表达式页签增加html代码
        $("#SearchResult_"+westTextDescText+"_"+matchflag).css('position', 'relative');
        $("#SearchResult_"+westTextDescText+"_"+matchflag).html('<div ><a style="color:#000" >'+tips+'</a></div ><div style="height:80%"><table data-options="fit:true" style="width:100%;position:absolute;height:90%" id="ResultListDiv_'+westTextDescText+'_'+matchflag+'" ></table></div >');
        var GlobalTable = $('<table data-options="fit:true"  id="allresultlist_'+westTextDescText+'_'+matchflag+'" border="false"></table>')
        $("#ResultListDiv_"+westTextDescText+"_"+matchflag).html(GlobalTable);               
        
        var matchcolumns = [
            [{
                field: 'ID',
                title: 'ID',
                //sortable: true,
                width: 100,
                hidden: true
            }, {
                field: 'Desc',
                title: '展示名',
                width: 100/*,formatter:function(val,row,index){
                    return val.split("(")[0]
                }*/
            }]]

        $HUI.datagrid("#allresultlist_"+westTextDescText+"_"+matchflag, {
            url: $URL,
            queryParams: {
                ClassName: "web.DHCBL.MKB.MKBGlobal", 
                QueryName: "GetTermForCmb2",
                'q': westTextDescText,
                'matchflag':matchflag,
                'allflag':1,
                'SortMethod':SortMethod,
                'markstr':MKBGMark,
                'SortLocStr':PreLocStr,
                'LocFreq':PreFreq
            },
            columns:matchcolumns,
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
            onSelect: function(index, row){
                SetHeight();
                ClickFun();
                GlobalID = row.ID.split("||")[0];
                var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","OpenGlobalData",GlobalID)
                var rowdata=eval('('+rowdata+')');
                LoadEditList(rowdata);
                LoadAliasList(GlobalID);
                LoadReferenceList(GlobalID);
            },
            onLoadSuccess:function(data){
                $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
                $(this).datagrid('columnMoving'); //列可以拖拽改变顺序
            }
        });
    }

    $("#globalbtnSearch").click(function (e) { 
        //SearchGlobal()   
        //ShowInListFunlib(westTextDescText,1) 
        var url=$URL+"?ClassName=web.DHCBL.MKB.MKBGlobal&QueryName=GetTermForCmb2&ResultSetType=array&matchflag=1&markstr="+MKBGMark+"&SortMethod="+SortMethod+"&SortLocStr="+PreLocStr+"&LocFreq="+PreFreq;
        $('#westTextDesc').combobox('reload', url)
        $('#westTextDesc').combobox("showPanel")                
    })
    
    //搜索框键盘监听
    $("#westTextDesc").combobox('textbox').bind('keyup', function(e) {
        if (e.keyCode == 13) {
            //var SearchStr =$('#westTextDesc').combobox('getValue')
            //$('#westTextDesc').combobox('setValue',SearchStr)
            
            
            var url=$URL+"?ClassName=web.DHCBL.MKB.MKBGlobal&QueryName=GetTermForCmb2&ResultSetType=array&matchflag=1&markstr="+MKBGMark+"&SortMethod="+SortMethod+"&SortLocStr="+PreLocStr+"&LocFreq="+PreFreq;
            $('#westTextDesc').combobox('reload', url)
            $('#westTextDesc').combobox("showPanel")
        }
    });
    $('#westTextDesc').combobox({
        onChange:function(newValue, oldValue){
            if (newValue=="")
            {
                var url = $URL+"?ClassName=web.DHCBL.MKB.MKBGlobal&QueryName=GetTermForCmb2&ResultSetType=array&markstr="+MKBGMark+"&SortMethod="+SortMethod+"&SortLocStr="+PreLocStr+"&LocFreq="+PreFreq;
                $('#westTextDesc').combobox('reload', url)
                $('#westTextDesc').combobox("resize")  
            }
                
        }
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
    //查询配置弹窗
    SearchSetWin = function() {
        $("#SearchSetWin").show();
        var SearchSetWin = $HUI.dialog("#SearchSetWin", {
            iconCls: 'icon-w-add',
            resizeable: true,
            title: '查询配置',
            modal: true,
            buttonAlign: 'center',
            buttons: [{
                text: '保存',
                id: 'save_btn',
                handler: function() {
                    var markStr = $('#markbox').combobox('getText');
                    //$("#westTextDesc").combobox('setText', "");
                    if (markStr !== MKBGMark) {
                        MKBGMark = markStr;
                        //重新加载数据
                        //var desc = $('#westTextDesc').combobox('getText')
                        $('#globalgrid').datagrid('load', {
                            ClassName: "web.DHCBL.MKB.MKBGlobal",
                            QueryName: "GetList",
                            'MarkStr': MKBGMark
                        });
                    }
                    
                }
            }, {
                text: '关闭',
                handler: function() {
                    SearchSetWin.close();
                }
            }]
        })
    }
    //组词查询弹窗
    CreateWordWin = function() {
        $("#CreateWordWin").show();
        var CreateWordWin = $HUI.dialog("#CreateWordWin", {
            iconCls: 'icon-w-add',
            resizeable: true,
            title: '组词查询',
            modal: true,
            buttonAlign: 'center',
            buttons: [{
                text: '查询',
                id: 'save_btn',
                handler: function() {
                    var prefStr = $('#prefixbox').combobox('getText');
                    var suffStr = $('#suffixbox').combobox('getText');
                    var stemWord = $('#stembox').combobox('getText');
                    if (stemWord == "") {
                        $.messager.alert('错误提示', '主干词不能为空!', "error");
                        return;
                    }
                    /*console.log(prefStr);
                    console.log(suffStr);
                    console.log(stemWord);*/
                    //$("#westTextDesc").combobox('setText', "");
                    /*if (markStr !== MKBGMark){
                        MKBGMark = markStr;
                        //重新加载数据
                        //var desc = $('#westTextDesc').combobox('getText')
                        $('#globalgrid').datagrid('load', {
                        ClassName: "web.DHCBL.MKB.MKBGlobal",
                        QueryName: "GetList",
                        //'desc': desc,
                        //'SearchStr': SearchStr,
                        'MarkStr':MKBGMark
                        });
                    }*/
                    //alert(MKBGMark);
                }
            }, {
                text: '关闭',
                handler: function() {
                    CreateWordWin.close();
                }
            }]
        })
    }
    //多音字批处理弹窗
    PYEditWin = function() {
        $("#PYEditWin").show();
        var PYEditWin = $HUI.dialog("#PYEditWin", {
            iconCls: 'icon-w-add',
            resizeable: true,
            title: '多音字批处理',
            modal: true,
            buttonAlign: 'center',
            buttons: [{
                text: '处理',
                id: 'save_btn',
                handler: function() {
                    //获得参数 调用后台方法
                    var StrDesc = $("#StrDesc").val();
                    var StrPYM = $("#StrPYM").val();
                    var sucnum = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "PYEdit", StrDesc, StrPYM);
                    $.messager.popover({
                        msg: '已成功处理' + sucnum + '条数据!',
                        type: 'success',
                        timeout: 1000
                    });
                }
            }, {
                text: '关闭',
                handler: function() {
                    PYEditWin.close();
                }
            }]
        })
    }
    //点击新增按钮
    AddGlobal = function() {
        $("#myWin").show();
        var myWin = $HUI.dialog("#myWin", {
            iconCls: 'icon-w-add',
            resizable: true,
            title: '新增',
            modal: true,
            //height:$(window).height()-70,
            buttonAlign: 'center',
            buttons: [{
                text: '保存',
                //iconCls:'icon-save',
                id: 'save_btn',
                handler: function() {
                    SaveGlobalData("")
                }
            }, {
                text: '关闭',
                //iconCls:'icon-cancel',
                handler: function() {
                    myWin.close();
                }
            }]
        });
        $('#form-save').form("clear");
    }
    //新增保存方法
    SaveGlobalData = function() {
        if ($.trim($("#MKBGDesc").val()) == "") {
            $.messager.alert('错误提示', '中心词不能为空!', "error");
            return;
        }
        //var Desc = $('#MKBTDesc').val();
        $('#form-save').form('submit', {
            url: SAVE_ACTION_URL,
            onSubmit: function(param) {
                //param.MKBTRowId = id;
                //param.MKBTBaseDR = base;
            },
            success: function(data) {
                var data = eval('(' + data + ')');
                if (data.success == 'true') {
                    $.messager.popover({
                        msg: '新增成功！',
                        type: 'success',
                        timeout: 1000
                    });
                    
                    $.cm({
                        ClassName: "web.DHCBL.MKB.MKBGlobal", ///调用Query时
                        QueryName: "GetList",
                        rowid: data.id
                    }, function(jsonData) {
                        $('#globalgrid').datagrid('insertRow', {
                            index: 0,
                            row: jsonData.rows[0]
                        })
                        $("#globalgrid").datagrid('selectRow', 0);
                        LoadEditList(jsonData.rows[0]);
                        LoadAliasList(data.id,AliasId);
                        LoadReferenceList(data.id);
                        RefreshSearchData("User.MKBGlobal", data.id, "A",jsonData.rows[0].MKBGDisplaName)
                    })
                    //}
                    $('#myWin').dialog('close'); // close a dialog
                } else {
                    var errorMsg = "提交失败！"
                    if (data.errorinfo) {
                        errorMsg = errorMsg + '<br/>错误信息:' + data.errorinfo
                    }
                    $.messager.alert('操作提示', errorMsg, "error");
                }
            }
        });
    }
    //术语名失去焦点自动生成检索码
    $('#MKBGDesc').bind('blur', function() {
        $("#MKBGPYCode").val(Pinyin.GetJPU($('#MKBGDesc').val()))
    });
    
    //被编辑数据保存方法
    SaveEditData = function() {
        var editdata = [];
        var data = $('#myeditgrid').datagrid('getRows')
        
        for (var i = 0; i < 4; i++) {
            $('#myeditgrid').datagrid("endEdit", i); //结束编辑
            editdata.push(data[i]['MKBGPDDesc'])
        }
        var record = $('#globalgrid').datagrid('getSelected')
        record.MKBGDesc = stripscript(editdata[0])
        record.MKBGEnName = editdata[1]
        record.MKBGPYCode = Pinyin.GetJPU(record.MKBGDesc)
        record.MKBGNote = editdata[3]
        //执行保存
        $.ajax({
            type: 'post',
            url: SAVE_ACTION_URL,
            data: record,
            success: function(data) { //返回json结果           
                var data = eval('(' + data + ')');
                if (data.success == 'true') {
                    $.messager.popover({
                        msg: '修改成功！',
                        type: 'success',
                        timeout: 1000
                    });
                } else {
                    var errorMsg = "修改失败！";
                    if (data.errorinfo) {
                        errorMsg = errorMsg + '</br>错误信息:' + data.errorinfo
                    }
                    $.messager.alert('错误提示', errorMsg, 'error', function() {})
                }
            }
        });
        editIndex = undefined;
    }
    //去掉首尾空格和特殊字符
    stripscript =function(s){
        var pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]")
        var rs = "";
        for (var i = 0; i < s.length; i++) {
        rs = rs+s.substr(i, 1).replace(pattern, '');
        rs=rs.replace(/^\s+|\s+$/g,'');  //去首尾空格
        }
        return rs;
    }
    //合并方法
    MergeGlobal = function() {
        var records = $('#globalgrid').datagrid('getChecked')
        var record = $('#globalgrid').datagrid('getSelected')
        var RowIdArry = [];
        for (var i = 0; i < records.length; i++) {
            if (records[i].MKBGRowId == record.MKBGRowId) {
                RowIdArry.unshift(records[i].MKBGRowId)
            } else {
                RowIdArry.push(records[i].MKBGRowId);
                CancelTop(records[i])
            }
        }
        var RowIdStr = RowIdArry.join(",");
        var test = RowIdStr.indexOf(record.MKBGRowId);
        if (test == -1) {
            $.messager.alert('错误提示', '请选择正确的合并数据!', "error");
            return
        }
        $.messager.confirm('提示', '确定要合并所选的数据吗?', function(r) {
            if (r) {
                $.ajax({
                    url: MERGE_ACTION_URL,
                    data: {
                        "RowIdStr": RowIdStr
                    },
                    type: "POST",
                    success: function(data) {
                        $("#globalgrid").datagrid('clearSelections');
                        var data = eval('(' + data + ')');
                        if (data.success == 'true') {
                            $.messager.popover({
                                msg: '合并成功！',
                                type: 'success',
                                timeout: 1000
                            });
                            $('#globalgrid').datagrid('reload'); // 重新载入当前页面数据 
                            $('#mergelist').datagrid('reload');
                            mergedata = record;
                            $('#globalgrid').datagrid('unselectAll'); // 清空列表选中数据
                            //$("#globalgrid").datagrid('selectRow', record.MKBGRowId);
                            $("#globalgrid").datagrid('uncheckAll'); //清空check状态
                            //LoadSameGlobal();
                            editIndex = undefined;
                            rowsvalue = undefined;
                            /*
                            alert(record.MKBGRowId)
                            LoadEditList(record);
                            LoadAliasList(record.MKBGRowId);
                            LoadReferenceList(record.MKBGRowId);
                            */
                        } else {
                            var errorMsg = ""
                            if (data.info) {
                                errorMsg = '合并失败！<br/>错误信息:' + data.info
                                $.messager.alert('操作提示', errorMsg, "error");
                            }
                        }
                    }
                })
            }
        });
        //OpenData(record);
    }
    //用于单击非grid行保存可编辑行
    $(document).bind('click', function() {
        ClickFun()
    });
    //加载表达式、多行文本框等可编辑表格控件
    AppendDom = function() {
        if (editIndex != undefined) {
            var col = $('#layoutglobal').children().find('tr[datagrid-row-index=' + editIndex + ']')[1];
            $(col).find('table').each(function() {
                var target = $(this).find('input:first')
                if (target.css('display') == 'none') {
                    target.next().find('input:first').click(function() {
                        $('#knoExe').css('display', 'none');
                    })
                } else {
                    target.click(function() {
                        $('#knoExe').css('display', 'none');
                    })
                }
            })
            //备注多行文本框
            CreateTADom(col, "MKBGNote")
            //加载多行文本框控件
            for (fieldid in textareInfoArr) {
                var comId = "Extend" + fieldid
                CreateTADom(col, comId)
            }
            //展示名和拼音码赋值
            var descTarget = $(col).find('td[field=MKBGDesc] input')
            if (mygrid.getRows()[editIndex].MKBGRowId == undefined) {
                descTarget.keyup(function() {
                    var desc = descTarget.val() //中心词列的值
                    if (showNameChild != "") //展示名赋值
                    {
                        var showNameCol = $("#globalgrid").datagrid("getEditor", {
                            index: editIndex,
                            field: showNameChild
                        });
                        $(showNameCol.target).val(desc)
                    }
                    //检索码赋值
                    var PYCode = Pinyin.GetJPU(desc)
                    var PYCodeCol = $("#globalgrid").datagrid("getEditor", {
                        index: editIndex,
                        field: "MKBGPYCode"
                    });
                    $(PYCodeCol.target).val(PYCode)
                })
            }
            descTarget.click(function() {
                var desc = descTarget.val() //中心词列的值
                if (showNameChild != "") //展示名赋值
                {
                    var showNameCol = $("#globalgrid").datagrid("getEditor", {
                        index: editIndex,
                        field: showNameChild
                    });
                    if ((mygrid.getRows()[editIndex].MKBGRowId == undefined) || (showNameCol.target.val() == "")) {
                        $(showNameCol.target).val(desc)
                    }
                }
                //检索码赋值
                var PYCode = Pinyin.GetJPU(desc)
                var PYCodeCol = $("#globalgrid").datagrid("getEditor", {
                    index: editIndex,
                    field: "MKBGPYCode"
                });
                if ((mygrid.getRows()[editIndex].MKBGRowId == undefined) || (PYCodeCol.target.val() == "")) {
                    $(PYCodeCol.target).val(PYCode)
                }
            })
        }
    }
    //修改完后给这一行赋值
    UpdataRow = function(row, Index, TAType) {
        //处理换行符
        if (TAType == "1") //双击的时候</br>转换为\n
        {
            //多行文本框
            for (fieldid in textareInfoArr) {
                var comId = "Extend" + fieldid
                row[comId] = row[comId].replace(/<br\/>/g, "\n");
            }
            //备注
            row.MKBGNote = row.MKBGNote.replace(/<br\/>/g, "\n");
        } else //保存成功的时候\n转换为</br>
        {
            //多行文本框
            for (fieldid in textareInfoArr) {
                var comId = "Extend" + fieldid
                row[comId] = row[comId].replace(/\n/g, "<br\/>");
            }
            //备注
            row.MKBGNote = row.MKBGNote.replace(/\n/g, "<br\/>");
        }
        $('#globalgrid').datagrid('updateRow', {
            index: Index,
            row: row
        })
    }
    //是否有正在编辑的行true/false
    endEditing = function() {
        if (editIndex == undefined) {
            return true
        }
        if ($('#globalgrid').datagrid('validateRow', editIndex)) {
            $('#globalgrid').datagrid('endEdit', editIndex);
            rowsvalue = mygrid.getRows()[editIndex];
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
                if ((rowsvalue.MKBGDesc != "")) {
                    var differentflag = "";
                    if (oldrowsvalue != undefined) {
                        var oldrowsvaluearr = JSON.parse(oldrowsvalue)
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
                    
                        SaveData(rowsvalue, saveType);
                    } else {
                        
                        UpdataRow(rowsvalue, editIndex)
                        editIndex = undefined
                        rowsvalue = undefined
                    }
                } else {
                    $.messager.alert('错误提示', '术语名' + '不能为空!', "error");
                    $('#globalgrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
                    AppendDom()
                    return
                }
            }
        }
    }
    //新增修改保存方法
    SaveData = function(trecord, saveType) {
        var Desc = trecord.MKBGDesc;
        if ((rowsvalue.MKBGDesc == "")) {
            $.messager.alert('错误提示', '术语名' + '不能为空!', "error");
            $('#globalgrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
            AppendDom()
            return
        }
        //执行保存
        $.ajax({
            type: 'post',
            url: SAVE_ACTION_URL,
            data: trecord,
            success: function(data) { //返回json结果           
                var data = eval('(' + data + ')');
                if (data.success == 'true') {
                    $.messager.popover({
                        msg: '测试成功！',
                        type: 'success',
                        timeout: 1000
                    });
                    if (saveType == 'AddData') {
                        preeditIndex = preeditIndex + 1;
                    }
                    //alert(saveType+"&"+preeditIndex)
                    trecord.MKBGRowId = data.id
                    UpdataRow(trecord, preeditIndex);
                    if (saveType != 'AddData') {
                        editIndex = undefined
                        rowsvalue = undefined
                    }
                    //parent.UpdateMKBTPDDescCell(property,"L")
                } else {
                    var errorMsg = "保存失败！";
                    if (data.errorinfo) {
                        errorMsg = errorMsg + '</br>错误信息:' + data.errorinfo
                    }
                    $.messager.alert('错误提示', errorMsg, 'error', function() {
                        UpdataRow(trecord, preeditIndex)
                        editIndex = undefined
                        DblClickFun(preeditIndex, trecord);
                    })
                }
            }
        })
    }
    //grid双击事件
    DblClickFun = function(index, row) {
        if (index == editIndex) {
            return
        }
        if ((row != undefined) && (row.MKBGRowId != undefined)) {
            UpdataRow(row, index, "1")
        }
        preeditIndex = editIndex
        if (editIndex != index) {
            if (endEditing()) {
                $('#globalgrid').datagrid('selectRow', index).datagrid('beginEdit', index);
                editIndex = index;
            } else {
                $('#globalgrid').datagrid('selectRow', editIndex);
            }
        }
        oldrowsvalue = JSON.stringify(row); //用于和rowvalue比较 以判断是否行值发生改变
        AppendDom()
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
    //确认按钮方法  //修改确认状态
    ConfirmGlobal = function() {
        var records = $('#globalgrid').datagrid('getChecked')
        var record = $('#globalgrid').datagrid('getSelected')
        if (!record) {
            $.messager.alert('错误提示', '请选择正确的确认数据!', "error");
            return
        }
        /*var RowIdArry = [];
        for (var i = 0; i < records.length; i++) {
            if (records[i].MKBGRowId == record.MKBGRowId) {
                RowIdArry.unshift(records[i].MKBGRowId)
            } else {
                RowIdArry.push(records[i].MKBGRowId)
            }
        }
        var RowIdStr = RowIdArry.join(",");
        var test = RowIdStr.indexOf(record.MKBGRowId);
        if (test == -1) {
            $.messager.alert('错误提示', '请选择正确的确认数据!', "error");
            return
        }
        */
       var RowIdStr=record.MKBGRowId

        $.messager.confirm('提示', '确定要确认所选的数据吗?', function(r) {
            if (r) {
                $.ajax({
                    url: CONFIRM_ACTION_URL,
                    data: {
                        "RowIdStr": RowIdStr
                    },
                    type: "POST",
                    success: function(data) {
                        var data = eval('(' + data + ')');
                        if (data.success == 'true') {
                            $.messager.popover({
                                msg: '确认成功！',
                                type: 'success',
                                timeout: 1000
                            });
                            $('#globalgrid').datagrid('reload'); // 重新载入当前页面数据  
                            $('#globalgrid').datagrid('unselectAll'); // 清空列表选中数据
                            $("#globalgrid").datagrid('uncheckAll');
                            editIndex = undefined;
                            rowsvalue = undefined;
                        } else {
                            var errorMsg = ""
                            if (data.info) {
                                errorMsg = '确认失败！<br/>错误信息:' + data.info
                                $.messager.alert('操作提示', errorMsg, "error");
                            }
                        }
                    }
                })
            }
        });
    }
    //查看同名术语按钮
    SameGlobal = function() {
        var record = $('#globalgrid').datagrid('getSelected')
        /*var RowIdArry = [];
        for (var i = 0; i < records.length; i++) {
            RowIdArry.push(records[i].MKBGRowId)
        }
        var RowIdStr = RowIdArry.join(",");*/
        if (!record) {
            $.messager.alert('错误提示', '至少选择一条术语!', "error");
            return;
        }
        //var Desc = record.MKBGDesc
        $('#globalgrid').datagrid('load', {
            ClassName: "web.DHCBL.MKB.MKBGlobal",
            QueryName: "GetList",
            'rowid': record.MKBGRowId,
            'Type': "SameGlobal",
            'MarkStr': MKBGMark
        });
        $('#globalgrid').datagrid('unselectAll');
        $('#globalgrid').datagrid('uncheckAll');
        $("#westTextDesc").combobox('setText', "");
    }
    //菜单按钮查看同名术语    //修改后没有同名的术语
    LoadSameGlobal = function() {
        //var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "TempGlobalDesc");
        $('#globalgrid').datagrid('load', {
            ClassName: "web.DHCBL.MKB.MKBGlobal", ///调用Query时
            QueryName: "GetList",
            'LoadSameFlag': "1",
            'MarkStr': MKBGMark
        })
    }
    //搜索方法
    SearchGlobal = function(SearchStr) {
        var desc = $('#westTextDesc').combobox('getText')
        if (SortMethod=="termsort")
        {
            $('#globalgrid').datagrid('load',  { 
                ClassName: "web.DHCBL.MKB.MKBGlobal",
                QueryName: "GetList",
                'Type': Type,
                'desc': desc,
                'MarkStr': MKBGMark,
                'SortMethod':"termsort"
            });
        }
        else if (SortMethod=="freqsort")
        {
            $('#globalgrid').datagrid('load', {
                ClassName: "web.DHCBL.MKB.MKBGlobal",
                QueryName: "GetList",
                'Type': Type,
                'desc': desc,
                'MarkStr': MKBGMark
            });
        }
        else if (SortMethod=="locsort")
        {
            $('#globalgrid').datagrid('load',  { 
                ClassName: "web.DHCBL.MKB.MKBGlobal",
                QueryName: "GetList",
                'desc': desc,
                'Type': Type,
                'MarkStr': MKBGMark,
                'SortMethod':"locsort",
                'LocFreq':PreFreq,
                'SortLocStr':PreLocStr
            });

        }
        
       
        //$('#globalgrid').datagrid('unselectAll');
    }
    //清屏方法
    ClearGlobal = function() {
        $("#westTextDesc").combobox('setText', "");
        if (SortMethod=="termsort")
        {
            $('#globalgrid').datagrid('load',  { 
                ClassName: "web.DHCBL.MKB.MKBGlobal",
                QueryName: "GetList",
                'Type': Type,
                'MarkStr': MKBGMark,
                'SortMethod':"termsort"
            });
        }
        else if (SortMethod=="freqsort")
        {
            $('#globalgrid').datagrid('load', {
                ClassName: "web.DHCBL.MKB.MKBGlobal",
                QueryName: "GetList",
                'Type': Type,
                'MarkStr': MKBGMark
            });
        }
        else if (SortMethod=="locsort")
        {
            $('#globalgrid').datagrid('load',  { 
                ClassName: "web.DHCBL.MKB.MKBGlobal",
                QueryName: "GetList",
                'Type': Type,
                'MarkStr': MKBGMark,
                'SortMethod':"locsort",
                'LocFreq':PreFreq,
                'SortLocStr':PreLocStr
            });
        }
        $('#globalgrid').datagrid('unselectAll');
        //$('#globalgrid').datagrid('uncheckAll');
        //$('#reloadlist').click();
    }
    var proeditIndex = undefined;  //正在编辑的行index
    var prorowsvalue=undefined;   //正在编辑的行数据

    //加载可编辑区域列表
    LoadEditList = function(rowData) {
        protitletip = "展示名：" + rowData.MKBGDisplaName
        protitle = '<span class="titleCls">展示名：</span>' + rowData.MKBGDisplaName 
        if (protitle.length > 150) {
            protitle = protitle.substr(0, 148) + "..."
        }
        protitle = '<span id="protooltip"  class="hisui-tooltip" title="' + protitletip + '" href="javascript:void(0)">' + protitle + '</span>'
        $('#layoutedit').panel('setTitle', protitle)
        var columns = [
            [{
                field: 'MKBGPDesc',
                title: '属性名称',
                width: 50
            }, {
                field: 'MKBGPDDesc',
                title: '属性内容',
                width: 150,
                editor: 'textarea',
                formatter: function(value, row, index) {
                    //鼠标悬浮显示备注信息
                    return '<span class="mytooltip" title="' + row.MKBGPDDesc + '">' + value + '</span>'
                }
            }, {
                field: 'MKBGPType',
                title: '格式',
                width: 50,
                sortable: true,
                hidden: true,
                formatter: function(v, row, index) {
                    if (v == 'TX') {
                        return '文本';
                    }
                    if (v == 'TA') {
                        return '多行文本框';
                    }
                    if (v == 'L') {
                        return '列表';
                    }
                }
            }]
        ];
        if (rowData.MKBGRowId != "") {
            var maxheight = window.screen.height - 370 //定义展开属性内容的高度
            if (maxheight < 300) {
                maxheight = 300
            }
            var minheight = maxheight //(window.screen.height-200)/2
        } else {
            //var maxheight = parent.$("#myTabContent").height() - 200 //定义展开属性内容的高度
            var maxheight = parent.$("#tt").height() - 200
            if (maxheight < 300) {
                maxheight = 300
            }
            var minheight = maxheight //(window.screen.height-200)/2
        }
        var myeditgrid = $HUI.datagrid("#myeditgrid", {
            url: $URL,
            queryParams: {
                ClassName: "web.DHCBL.MKB.MKBGlobal",
                QueryName: "GetEditList",
                Id: rowData.MKBGRowId
            },
            columns: columns, //列信息
            pagination: false, //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
            singleSelect: true,
            checkOnSelect: false,
            selectOnCheck: false,
            remoteSort: false,
            idField: 'MKBGPDesc',
            rownumbers: false, //设置为 true，则显示带有行号的列。
            fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            scrollbarSize: 0,
            view: detailview,
            detailFormatter: function(rowIndex, rowData) {
                var type = rowData.MKBGPType;
                if (type == "L") {
                    return "<div style='width:99%;height:" + minheight + "px'><iframe id='myalias' class='myiframe' frameborder='0' src='' style='width:99%;height:98%'></iframe></div>";
                };
                if (type == "T") {
                    return "<div style='width:99%;height:" + minheight + "px'><iframe id='mymark' class='myiframe' frameborder='0' src='' style='width:99%;height:98%'></iframe></div>";
                }
                if (type == "Loc") {
                    return "<div style='width:99%;height:" + minheight + "px'><iframe id='mylocfreq' class='myiframe' frameborder='0' src='' style='width:99%;height:95%'></iframe></div>"
                }
            },
            onExpandRow: function(rowIndex, rowData) {
                var type = rowData.MKBGPType;
                var expannummax = 0,
                    expannummin = 0
                $.each($('.datagrid-row-collapse'), function(i, r) {
                    var ids = $(this).parent().parent().parent().attr('datagrid-row-index');
                });
                var scrollheight = expannummax * maxheight + expannummin * minheight + rowIndex * 35;
                $(this).prev().find('div.datagrid-body').prop('scrollTop', scrollheight);
                if (type == "L") {
                    var contenturl = "dhc.bdp.mkb.mkbglobalalias.csp?GlobalID=" + GlobalID;
                    $('#myalias').attr('src', contenturl)
                }
                if (type == "T") {
                    var contenturl = "dhc.bdp.mkb.mkbglobalmark.csp?GlobalID=" + GlobalID;
                    $('#mymark').attr('src', contenturl)
                }
                if (type == "Loc") {
                    var contenturl = "dhc.bdp.mkb.mkbgloballocfreq.csp?GlobalID=" + GlobalID;
                    $('#mylocfreq').attr('src', contenturl)
                }
            },
            
            onLoadSuccess: function(data) {
                if (data.rows.length == 0) {} else {
                    $("#myeditgrid").datagrid('expandRow', 0);   //默认展开第一个
                    $.each(data.rows, function(index, rowdata) {
                        if ((rowdata.MKBGPType == "TX") || (rowdata.MKBGPType == "TA")) {
                            //移除前面的收缩、展开按钮
                            var col = $('#ttt').find('tr[datagrid-row-index=' + index + ']')[0];
                            $(col).find('.datagrid-row-expander').removeClass('datagrid-row-expand');
                        }
                    })
                }
            },
           onDblClickCell:function(index, field, value){
                var rows = $("#myeditgrid").datagrid('getRows');//获得所有行
                var row = rows[index];//根据index获得其中一行。
                var MKBGPDesc=row.MKBGPDesc
                prorowsvalue=row
                if ((field=="MKBGPDDesc")&&(MKBGPDesc=="备注"))  //只修改备注
                {    
                    var editingcol=$("#myeditgrid").children().find('tr[datagrid-row-index='+index+']');
                    CreateTADom(editingcol, "MKBGPDDesc")               
                    //进入编辑状态
                    $('#myeditgrid').datagrid('selectRow', index)
                        .datagrid('beginEdit', index);
                    proeditIndex=index
                    

                }
            },
            onAfterEdit:function(index, row, changes) {
                /*var differentflag=0
                if (row.MKBGPDDesc!=prorowsvalue.MKBGPDDesc)
                {
                    differentflag=1
                }*/
                if (row.MKBGPDDesc!="")
                {
                    var savere=tkMakeServerCall("web.DHCBL.MKB.MKBGlobal","SaveGlobalNote",GlobalID,row.MKBGPDDesc);
                    var savere=eval('(' + savere + ')');
                    if (savere.success=="true")
                    {
                        $.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
                       
                    }
                    else{

                        var errorMsg ="提交失败！"
                        if (savere.errorinfo) {
                            errorMsg =errorMsg+ '<br/>错误信息:' + savere.errorinfo
                        }
                        $.messager.alert('操作提示',errorMsg,"error");
                    }
                }
                    
                
            },
            onClickRow:function(rowIndex,rowData){
                if(proeditIndex!==undefined){
                    var lastindex=proeditIndex
                    $(this).datagrid('endEdit', proeditIndex);                    
                }
            }

        });
    }
    //点击非编辑行实现保存功能
    $("#layoutedit").bind('click', function() {
        if (editIndex == undefined) {
            return
        } else {
            SaveEditData();
        }
    })
    //加载别名列表
    LoadAliasList1 = function(PPID,AliasId) {
        
        var contenturl = "dhc.bdp.mkb.mkbglobalalias.csp?GlobalID=" +PPID+"&AliasId="+AliasId;
        $('#myalias').attr('src',contenturl)
    };
    LoadAliasList = function(PPID) {
        
        var contenturl = "dhc.bdp.mkb.mkbglobalalias.csp?GlobalID=" +PPID;
        $('#myalias').attr('src',contenturl)
    };
    //加载辅助功能区界面
    LoadFZ = function(MKBGRRowId, MKBGRDesc) {
        var tkresult = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "ReturnSkipParm", MKBGRRowId)
        var myMenuArray = tkresult.split("^");
        var contenturl = "dhc.bdp.mkb.mkblistterm.csp?BDPMENU=" + myMenuArray[0] + "&TermID=" + myMenuArray[1] + "&ProId=" + myMenuArray[2];
        ADDTab(MKBGRRowId, MKBGRDesc, contenturl, myMenuArray[1])
    }
    //辅助功能区页签编写
    //用hisui 渲染tab主体
    $('#tab_div').tabs({
        border: false,
        tabPosition: 'right',
        headerWidth: '80', //页签宽度
        onAdd: function(title, index) {
            //添加标签时，如果超过六个，则删除index为0的第一项
            if (index >10) {
                $(this).tabs('close', 0)
            }
        }
    });
    //增加页签方法
    addTab = function(title, url) {
        if ($("#tt").tabs('exists', title)) {
            $("#tt").tabs('select', title);
        } else {
            var fasterHeight = $('#layoutedit').height();
            if ('undefined'!==typeof websys_getMWToken){
                url += "&MWToken="+websys_getMWToken()
            }
            var content = '<iframe scrolling ="auto" frameborder="0" src ="' + url + '" style="width:100%;height:' + fasterHeight + 'px;"></iframe>';
            $("#tt").tabs('add', {
                title: title,
                content: content,
                closable: true
            });
        }
    }
    //双击引用场景，增加tab
    ADDTab = function(MKBGRRowId, MKBGRDesc, url, TermID) {
        var MKBGRowId = $("#globalgrid").datagrid("getSelected").MKBGRowId;
        if ($('#tab_div').tabs('exists', MKBGRDesc + "<span class='hidecls'>(" + MKBGRRowId + ")</span>")) {
            //alert(1)
            $('#tab_div').tabs('select', MKBGRDesc + "<span class='hidecls'>(" + MKBGRRowId + ")</span>")
        } else {
            $('#tab_div').tabs('add', {
                title: MKBGRDesc + "<span class='hidecls'>(" + MKBGRRowId + ")</span>",
                //id: "tab_" + MKBGRRowId,
                id: "tab_" + MKBGRRowId,
                //content:'Tab Body',//里边可以插html内容    
                closable: true,
                //href:url
            });
            $('.tabs .tabs-inner').css('line-height', '16px');
            $('.tabs .tabs-inner').css('height', 'auto');
            $('.tabs .tabs-inner').css('padding', '6px');
           // $('.tabs .tabs-inner .tabs-title').css('white-space', 'pre-wrap');
        }
        /*暂时注释，改为只加载树形结构
        var htm = '';
        htm += '<iframe id="iframe_' + MKBGRRowId + '" src="' + url + '"  width="100%" height="100%" frameborder="0" >';
        htm += '系统使用了框架技术，但是您的浏览器不支持框架，请升级您的浏览器以便正常访问。';
        htm += '</iframe>';
        $("#tab_" + MKBGRRowId).append(htm);
        */
        /*fwkadd*/
        var columns = [
            [{
                field: 'MKBTRowId',
                title: 'MKBTRowId',
                width: 80,
                sortable: true,
                hidden: true
            }, {
                field: 'MKBTDesc',
                title: '中心词',
                width: 200,
                sortable: true
            }, {
                field: 'MKBTSequence',
                title: '顺序',
                width: 150,
                sortable: true,
                hidden: true
            }, {
                field: 'MKBTLastLevel',
                title: '上级节点',
                width: 80,
                hidden: true
            }]
        ];
        $("#tab_" + MKBGRRowId).empty()
        $("#tab_" + MKBGRRowId).html('<table data-options="fit:true" id="centertreegrid' + MKBGRRowId + '" border="false" ></table>')
        var FatherID = tkMakeServerCall('web.DHCBL.MKB.MKBGlobal', 'GetFatherID', TermID);
        var centertreegrid = $('#centertreegrid' + MKBGRRowId).treegrid({
            url: "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBGlobal&pClassMethod=GetFatherJsonStr&id=" + FatherID,
            columns: columns, //列信息
            height: $(window).height() - 105, ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
            idField: 'MKBTRowId',
            treeField: 'MKBTDesc', //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
            autoSizeColumn: false,
            scrollbarSize: 8,
            //ClassTableName: 'User.MKBTermT26',
            //SQLTableName: 'MKB_TermT26',
            // toolbar:'#centerTools',
            animate: false, //是否树展开折叠的动画效果
            fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            remoteSort: false, //定义是否从服务器排序数据。true
            onLoadSuccess: function(data) {
                //alert(1)
                $('#centertreegrid' + MKBGRRowId).treegrid('search', MKBGRDesc);
                $('#centertreegrid' + MKBGRRowId).treegrid('select', TermID);
            },
        });
        //$("#centertreegrid"+MKBGRRowId).treegrid('find',"16389");
        //$('#centertreegrid').treegrid('unselectAll');
    }
    //辅助功能区放大按钮功能实现
    $('#enlargeWin').click(function(e) {
        var MKBGRRowId = $("#referencecenterlistgrid").datagrid("getSelected").MKBGRRowId;
        //$('#test').layout('collapse', 'east');
        var testw = $(window).width();
        var resetw = testw - 310;
        //alert(resetw)
        $('#reflist').panel('resize', {
            width: resetw,
            left: 305,
        });
        //放大之后 首先清空掉 tab中的内容，然后加载内容
        $("#tab_" + MKBGRRowId).empty();
        var record = $("#referencecenterlistgrid").datagrid("getSelected");
        var tkresult = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "ReturnSkipParm", record.MKBGRRowId)
        var myMenuArray = tkresult.split("^");
        var contenturl = "dhc.bdp.mkb.mkblistterm.csp?BDPMENU=" + myMenuArray[0] + "&TermID=" + myMenuArray[1] + "&ProId=" + myMenuArray[2];
        if ('undefined'!==typeof websys_getMWToken){
            contenturl += "&MWToken="+websys_getMWToken()
        }
        var htm = '';
        htm += '<iframe id="iframe_' + record.MKBGRRowId + '" src="' + contenturl + '"  width="100%" height="100%" frameborder="0" >';
        htm += '系统使用了框架技术，但是您的浏览器不支持框架，请升级您的浏览器以便正常访问。';
        htm += '</iframe>';
        $("#tab_" + MKBGRRowId).append(htm);
        // $('#test').layout('expand', 'east');
    })
    //辅助功能区向右缩小按钮功能实现
    $('#reduceWin').click(function(e) {
        //var MKBGRowId = $("#globalgrid").datagrid("getSelected").MKBGRowId;
        //var record = $("#referencecenterlistgrid").datagrid("getSelected").MKBGRRowId;
        //var MKBGRRowId = $("#globalgrid").datagrid("getSelected").MKBGRRowId;
        var testw = $(window).width();
        var restw = testw - 400;
        $('#reflist').panel('resize', {
            width: 400,
            left: restw,
        });
    })
    //辅助功能区放大展开功能 辅助功能区的面板变大
    /*$("#search_Open").click(function(e) {
        $('#reflist').panel('resize',{
        width: 1000,
        });
    })*/
    reficdlist=function(desc){
        //alert(desc);
        $('#reficddiaglist').datagrid('load',  { 
        ClassName:"web.DHCBL.MKB.MKBICDContrast",
        MethodName:"GetNewList",
        diag:desc,
        });
    }
    
    
}
$(init);
