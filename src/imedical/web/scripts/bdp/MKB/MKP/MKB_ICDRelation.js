/*
Creator:石萧伟
CreatDate:2017-03-15
Description:术语文献管理组合页面
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBICDRelation&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBICDRelation";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBICDRelation&pClassMethod=DeleteData";
//界面初始化
var init = function(){
    var columns =[[
        {field:'MKBICDRDiag',title:'诊断表达式ID',width:100,hidden:true},
        {field:'MKBICDRDiagDesc',title:'诊断表达式',width:100,sortable:true},
        {field:'MKBICDRBJDr',title:'ICD北京版ID',width:100,sortable:true,hidden:true},
        {field:'MKBICDRHisDr',title:'HISICDID',width:100,sortable:true,hidden:true},
        {field:'MKBICDRBJICD',title:'ICD北京版',width:100,sortable:true},
        {field:'MKBICDRBJNote',title:'北京版备注',width:100,hidden:true},
        {field:'MKBICDRBJState',title:'北京版对照状态',width:100,editor:{'type':'combobox',
            options:{
                valueField:'id',
                textField:'text',
                data:[
                    {id:'未对照',text:'未对照'},
                    {id:'已对照',text:'已对照'}
                ]
            }
        }},
        {field:'MKBICDRInterCode1',title:'ICD国际码1',width:100,hidden:true},
        {field:'MKBICDRInterCode2',title:'ICD国际码2',width:100,hidden:true},
        {field:'MKBICDRHisICD',title:'His版ICD',width:100,sortable:true},
        {field:'MKBICDRHisNote',title:'His版备注',width:100,sortable:true},
        {field:'MKBICDRHisState',title:'His版对照状态',width:100,sortable:true,editor:{'type':'combobox',
            options:{
                valueField:'id',
                textField:'text',
                data:[
                    {id:'未对照',text:'未对照'},
                    {id:'已对照',text:'已对照'}
                ]
            }
        }}, 
        {field:'MKBICDRRowId',title:'RowId',hidden:true} 
    ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBICDRelation",
            QueryName:"GetRelationList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        idField:'MKBICDRRowId',
        ClassTableName:'User.MKBICDRelation',
		SQLTableName:'MKB_ICDRelation',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        scrollbarSize :0,
        onClickCell:function(index, field, value){
             if (endEditing()){
                 $('#mygrid').datagrid('selectRow', index).datagrid('editCell', {index:index,field:field});
                 editIndex = index;
             }
        },
        onDblClickRow:function(index,row)
        {

        },
       onClickRow:function(index,row)
        {
            UpdateData();
        },
        onAfterEdit:function(index, row, changes){
            editrow(row);
            }
    });
    //编辑表格判断
    var editIndex = undefined;
    function endEditing(){
        if (editIndex == undefined){return true}
        if ($('#mygrid').datagrid('validateRow', editIndex)){
            $('#mygrid').datagrid('endEdit', editIndex);
            editIndex = undefined;
            return true;
        } else {
            return false;
        }
    }
    $.extend($.fn.datagrid.methods, {
        editCell: function(jq,param){
            return jq.each(function(){
                var opts = $(this).datagrid('options');
                var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
                for(var i=0; i<fields.length; i++){
                    var col = $(this).datagrid('getColumnOption', fields[i]);
                    col.editor1 = col.editor;
                    if (fields[i] != param.field){
                        col.editor = null;
                    }
                }
                $(this).datagrid('beginEdit', param.index);
                for(var i=0; i<fields.length; i++){
                    var col = $(this).datagrid('getColumnOption', fields[i]);
                    col.editor = col.editor1;
                }
            });
        }
    });
    //编辑单元格保存方法
    function editrow(row)
    {
        var id=row.MKBICDRRowId;
        $('#MKBICDRBJDr').combobox('setValue',row.MKBICDRBJDr);
        $('#MKBICDRBJState').combobox('setValue',row.MKBICDRBJState);
        $('#MKBICDRHisDr').combobox('setValue',row.MKBICDRHisDr);
        $('#MKBICDRHisNote').combobox('setValue',row.MKBICDRHisNote);
        $('#MKBICDRHisState').combobox('setValue',row.MKBICDRHisState);
        $('#MKBICDRDiag').val(row.MKBICDRDiag);
        $('#MKBICDRBJNote').val(row.MKBICDRBJNote);
        $('#MKBICDRInterCode1').val(row.MKBICDRInterCode1);
        $('#MKBICDRInterCode2').val(row.MKBICDRInterCode2);
        $('#form-save').form('submit', {
            url: SAVE_ACTION_URL,
            onSubmit: function (param) {
                param.MKBICDRRowId = id;
            },
        });
    }
    //ICD北京版编码下拉框
    $("#MKBICDRBJDr").combobox({
        url:$URL+"?ClassName=web.DHCBL.MKB.MKBICDRelation&QueryName=GetBJICD&ResultSetType=array",
        valueField:'MKBTRowId',
        textField:'ICD',
        keyHandler:{
            enter:function(){
                var desc=$.trim($('#MKBICDRBJDr').combobox('getText'));
                $('#MKBICDRBJDr').combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBICDRelation&QueryName=GetBJICD&ResultSetType=array&desc="+encodeURI(desc));
                $('#MKBICDRBJDr').combobox("setValue",desc);
            }
           
        }
    });
    //His版ICD版编码下拉框
    $("#MKBICDRHisDr").combobox({
        url:$URL+"?ClassName=web.DHCBL.MKB.MKBICDRelation&QueryName=GetHisICD&ResultSetType=array",
        valueField:'ID',
        textField:'ICD',
        keyHandler:{
            enter:function(){
                var desc=$.trim($('#MKBICDRHisDr').combobox('getText'));
                $('#MKBICDRHisDr').combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBICDRelation&QueryName=GetHisICD&ResultSetType=array&desc="+encodeURI(desc));
                $('#MKBICDRHisDr').combobox("setValue",desc);
            }
            
        }

    });

    //北京对照状态下拉框
    $("#MKBICDRBJState").combobox({
        valueField:'id',
        textField:'text',
        data:[
            {id:'未对照',text:'未对照'},
            {id:'已对照',text:'已对照'}
        ]
    });
    //HIS对照状态下拉框
    $("#MKBICDRHisState").combobox({
        valueField:'id',
        textField:'text',
        data:[
            {id:'未对照',text:'未对照'},
            {id:'已对照',text:'已对照'}
        ]
    });
    //HIS备注下拉框
    $("#MKBICDRHisNote").combobox({
        valueField:'id',
        textField:'text',
        data:[
            {id:'',text:''},
            {id:'同码同义',text:'同码同义'},
            {id:'同码不同义',text:'同码不同义'},
            {id:'同义不同码',text:'同义不同码'},
            {id:'不同码不同义',text:'不同码不同义'}
        ]
    });
   	//查询按钮
	$("#DescSearch").searchbox({
        searcher:function(value,name){
            SearchFunLib();
        }
    })
    //查询方法
    function SearchFunLib(){
        var desc=$.trim($('#DescSearch').searchbox('getValue'));
        $('#mygrid').datagrid('load',  {
            ClassName:"web.DHCBL.MKB.MKBICDRelation",
            QueryName:"GetRelationList",
            'desc': desc
        });

    }
    //添加按钮
    $("#add_btn").click(function (e) {

        SaveFunLib("");
    })
    //修改按钮
    $("#updata_btn").click(function (e) {
        var record = mygrid.getSelected();
        if (record){
            //调用后台openData方法给表单赋值
            var id = record.MKBICDRRowId;
        }
        SaveFunLib(id);
    })
    //删除按钮
    $("#del_btn").click(function (e) {

        RemoveText();
    })
    //重置按钮
    $("#btnRefresh").click(function (e) {

        ClearFunLib();
    })
    //重置方法
    function ClearFunLib()
    {
        $("#DescSearch").searchbox('setValue', '');
        $('#mygrid').datagrid('load',  {
            ClassName:"web.DHCBL.MKB.MKBICDRelation",
            QueryName:"GetRelationList"
        });
    $('#mygrid').datagrid('unselectAll');
    //清空表单
        $('#form-save').form('clear');
        var per="未对照";
        $('#MKBICDRBJState').combobox('setValue',per);
        $('#MKBICDRHisState').combobox('setValue',per);
    }

    //单机行显示数据
    function UpdateData() {
        var record = mygrid.getSelected();
        if (record){
            //调用后台openData方法给表单赋值
            var id = record.MKBICDRRowId;
            $.cm({
                ClassName:"web.DHCBL.MKB.MKBICDRelation",
                MethodName:"OpenData",
                id:id
            },function(jsonData){
                 $('#form-save').form("load",jsonData);
           });
        }
    }
    ///新增、更新
    function SaveFunLib(id)
    {
        $('#form-save').form('submit', {
            url: SAVE_ACTION_URL,
            onSubmit: function(param){
                param.MKBICDRRowId = id;
            },
            success: function (data) {
                    var data=eval('('+data+')'); 
                    if (data.success == 'true') {
                        $.messager.show({ 
                          title: '提示消息', 
                          msg: '提交成功', 
                          showType: 'show', 
                          timeout: 1000, 
                          style: { 
                            right: '', 
                            bottom: ''
                          } 
                        });
                    $('#mygrid').datagrid('reload');  // 重新载入当前页面数据
                    $('#myWin').dialog('close'); // close a dialog
                    ClearFunLib();
                }
                else {
                    var errorMsg ="更新失败！"
                    if (data.errorinfo) {
                        errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
                    }
                    $.messager.alert('操作提示',errorMsg,"error");

                }

            }
        });
    }
    //移除数据
    function RemoveText()
    {
        //更新
        var row = $("#mygrid").datagrid("getSelected");
        if (!(row))
        {	$.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        }
        var rowid=row.MKBICDRRowId;
        $.messager.confirm('提示', '确定要删除所选数据吗?', function(r){
            if (r){
                $.ajax({
                    url:DELETE_ACTION_URL,
                    data:{"id":rowid},
                    type:"POST",
                    success: function(data){
                        var data=eval('('+data+')');
                        if (data.success == 'true') {
                            $.messager.show({
                                title: '提示消息',
                                msg: '删除成功',
                                showType: 'show',
                                timeout: 1000,
                                style: {
                                    right: '',
                                    bottom: ''
                                }
                            });
                            $('#mygrid').datagrid('load',  {
                                ClassName:"web.DHCBL.MKB.MKBICDRelation",
                                QueryName:"GetRelationList"
                            });
                            // 重新载入当前页面数据
                            $('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
                        }
                        else
                        {
                            var errorMsg ="删除失败！"
                            if (data.info)
                            {
                                errorMsg =errorMsg+ '<br/>错误信息:' + data.info
                            }
                            $.messager.alert('操作提示',errorMsg,"error");

                        }
                    }
                })
            }
        });
    }
    //拖拽和右键列
    //ShowUserHabit('mygrid');
	$('#mygrid').datagrid('columnMoving');
	//HISUI_Funlib_Sort('mygrid');  ///放在columnMoving后面才能显示？？
	//HISUI_Funlib_Translation('mygrid');
	//HISUI_Funlib_Sort('mygrid');
	//var DisableArray=[];
	//DisableArray["del_btn"]='N';
	//DisableArray["update_btn"]='N';
	//DisableFlag(DisableArray);
	//KeyMap(disablebtnflag);
}
$(init);