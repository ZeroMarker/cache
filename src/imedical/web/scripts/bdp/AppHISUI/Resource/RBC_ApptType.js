/// Function:预约渠道
/// Creator: sunfengchao 
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.RBCApptType&pClassMethod=SaveData&pEntityName=web.Entity.CT.RBCApptType";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.RBCApptType&pClassMethod=DeleteData";
var init = function(){
    var URL_Icon="../scripts/bdp/Framework/icons/";
    var columns =[[  
                  {field:'ATCode',title:'代码',width:180,sortable:true},
                  {field:'ATDesc',title:'描述',width:180,sortable:true},  
                  {field:'ATDateFrom',title:'开始日期',width:180,sortable:true},
                  {field:'ATDateTo',title:'结束日期',width:180,sortable:true},
                  {field:'ATRowId',title:'ATRowId',hidden:true}
                  ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
         queryParams:{
            ClassName:"web.DHCBL.CT.RBCApptType",
            QueryName:"GetList"
        }, 
        columns: columns,   
        ClassTableName:'User.RBCApptType',
        SQLTableName:'RBC_ApptType',
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200], 
        singleSelect:true,
        idField:'ATRowId', 
        rownumbers:true,    
        fitColumns:true,  
        onDblClickRow:function(rowIndex,rowData){
            UpdateData();
        }
    });
  
   //搜索回车事件
    $('#TextDesc,#TextCode').keyup(function(event){
        if(event.keyCode == 13) {
          SearchFunLib();
        }
    });  
    //查询按钮
    $("#btnSearch").click(function (e) { 
         SearchFunLib(); 
     })  
     
    //重置按钮
    $("#btnRefresh").click(function (e) { 
         ClearFunLib();
     })  
    
    //点击添加按钮
    $("#btnAdd").click(function(e){
        AddData();
    });
    //点击修改按钮
    $("#btnUpdate").click(function(e){
        UpdateData();
    });
    //点击删除按钮
    $("#btnDel").click(function (e) { 
        DelData();
    }); 
    
     //查询方法
    function SearchFunLib(){
        var code=$.trim($("#TextCode").val());
        var desc=$.trim($('#TextDesc').val());
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.RBCApptType",
            QueryName:"GetList",   
            'code':code,    
            'desc': desc
        });
        $('#mygrid').datagrid('unselectAll');
    } 
    //重置方法
    function ClearFunLib()
    {
        $("#TextCode").val("");
        $("#TextDesc").val("");
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.RBCApptType",
            QueryName:"GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
     //点击新增按钮
    function AddData() { 
        $("#myWin").show(); 
        $("#ATCodeF").val("");
        $("#ATDescF").val(""); 
        var myWin = $HUI.dialog("#myWin",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'新增',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存', 
                id:'save_btn',
                handler:function(){
                    SaveFunLib("")
                }
            },{
                text:'关闭', 
                handler:function(){
                    myWin.close();
                }
            }]
        }); 
    }
  
    //点击修改按钮
    function UpdateData() {
        var record = mygrid.getSelected(); 
        if (record){            
             //调用后台openData方法给表单赋值
            var id = record.ATRowId;
            $.cm({
                ClassName:"web.DHCBL.CT.RBCApptType",
                MethodName:"OpenData",
                id:id
            },function(jsonData){ 
                $('#form-save').form("load",jsonData);  
            });
                     
            $("#myWin").show(); 
            var myWin = $HUI.dialog("#myWin",{
                iconCls:'icon-w-edit',
                resizable:true,
                title:'修改',
                modal:true,
                buttons:[{
                    text:'保存', 
                    id:'save_btn',
                    handler:function(){
                        SaveFunLib(id)
                    }
                },{
                    text:'关闭', 
                    handler:function(){
                        myWin.close();
                    }
                }]
            });             
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
    }
    
    ///新增、更新
    function SaveFunLib(id)
    {            
        var code=$.trim($("#ATCodeF").val());
        var desc=$.trim($("#ATDescF").val()); 
        var dateto=$.trim($("#ATDateFromF").val());
        if (code=="")
        {
            $.messager.alert('错误提示','代码不能为空!',"error");
            return;
        }
        if (desc=="")
        {
            $.messager.alert('错误提示','描述不能为空!',"error");
            return;
        }
         if (dateto=="")
        {
            $.messager.alert('错误提示','开始日期不能为空!',"error");
            return;
        }       
        $.messager.confirm('提示', "确认要保存数据吗?", function(r){
            if (r){
                $('#form-save').form('submit', { 
                    url: SAVE_ACTION_URL, 
                    onSubmit: function(param){
                        param.ATRowId = id;
                    },
                    success: function (data) { 
                      var data=eval('('+data+')'); 
                      if (data.success == 'true') {
                        $.messager.popover({msg: '提交成功！',type:'success',timeout: 1000}); 
                        $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                        $('#mygrid').datagrid('unselectAll');
                        $('#myWin').dialog('close'); // close a dialog
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
    })  
   }

    ///删除
    function DelData()
    {    
        //更新
        var row = $("#mygrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        } 
        $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
            if (r){ 
                var rowid=row.ATRowId; 
                $.ajax({
                    url:DELETE_ACTION_URL,  
                    data:{"id":rowid},  
                    type:"POST", 
                    success: function(data){
                              var data=eval('('+data+')'); 
                              if (data.success == 'true') { 
                                $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000}); 
                                $('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
                                $('#mygrid').datagrid('unselectAll');
                              } 
                              else { 
                                var errorMsg ="删除失败！"
                                if (data.info) {
                                    errorMsg =errorMsg+ '<br/>错误信息:' + data.info
                                }
                                 $.messager.alert('操作提示',errorMsg,"error"); 
                            }           
                    }  
                }) 
            }
        });
    } 
    HISUI_Funlib_Translation('mygrid');
    HISUI_Funlib_Sort('mygrid');
     
};
$(init);