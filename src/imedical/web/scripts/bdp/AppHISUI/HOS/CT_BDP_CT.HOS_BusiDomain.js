/// Function:HOS 业务域
/// Creator: 钟荣枫
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.HOSBusiDomain&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.HOSBusiDomain";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSBusiDomain&pClassMethod=DeleteData";

var init = function(){
    
    var URL_Icon="../scripts/bdp/Framework/icons/";
    var columns =[[  
                    {field:'ID',title:'ID',hidden:true},
                    {field:'DomainCode',title:'代码',width:180,sortable:true},
                    {field:'DomainDesc',title:'名称',width:180,sortable:true}, 
                    
                    {field:'DomainParentCode',title:'父级业务域',width:180,sortable:true}, 
                    {field:'DomainLevel',title:'业务域层级',width:180,sortable:true}, 
                    {field:'DomainActivity',title:'是否有效',align:'center',width:80,sortable:true,formatter:ReturnFlagIcon},                    
                    {field:'DomainStartDate',title:'开始日期',width:180,sortable:true}, 
                    {field:'DomainEndDate',title:'结束日期',width:180,sortable:true}, 
                    {field:'DomainSeqNo',title:'排序号',width:60,sortable:true}, 
                    {field:'DomainPYCode',title:'拼音码',width:80,sortable:true},
                    {field:'DomainWBCode',title:'五笔码',width:80,sortable:true},                   
                    {field:'DomainMark',title:'备注',width:100,sortable:true}                       
                ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
         queryParams:{
            ClassName:"web.DHCBL.CT.HOSBusiDomain",
            QueryName:"GetList"
        }, 
        columns: columns,  //列信息
        ClassTableName:'CT.BDP.CT.HOSBusiDomain',
        SQLTableName:'CT_BDP_CT.HOS_Busi_Domain',
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300], 
        singleSelect:true,
        idField:'ID', 
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
        onDblClickRow:function(rowIndex,rowData){
            UpdateData();
        }
    });
    //父级业务域下拉框 
    $('#DomainParentCode').combobox({ 
        url:$URL+"?ClassName=web.DHCBL.CT.HOSBusiDomain&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'ID',
        textField:'DomainDesc'
        
    }); 

    //父级业务域下拉框 
    $('#TextParent').combobox({ 
        url:$URL+"?ClassName=web.DHCBL.CT.HOSBusiDomain&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'ID',
        textField:'DomainDesc',
        onSelect:function(record){
            SearchFunLib()
        },
        onShowPanel:function(){
            $(this).combobox("reload")
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
            DeleteData();
    }); 
    
     //查询方法
    function SearchFunLib(){
        var code=$.trim($("#TextCode").val());
        var desc=$.trim($('#TextDesc').val());
        var parent=$("#TextParent").combobox("getValue")
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSBusiDomain",
            QueryName:"GetList" ,   
            'code':code,    
            'desc': desc,
            'parentid':parent
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    //重置方法
    function ClearFunLib()
    {
        $("#TextCode").val("");
        $("#TextDesc").val("");
        $("#TextParent").combobox("setValue","")
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSBusiDomain",
            QueryName:"GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    }
    //失焦事件
     $('#DomainDesc').bind('blur',function(){
          var DomainDesc=$("#DomainDesc").val()  
          var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",DomainDesc) 
          var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",DomainDesc,1) 
          $("#DomainPYCode").val(PYCode)
          $("#DomainWBCode").val(WBCode)                                           
      });

    /*//获取当前日期
    function getCurentDateStr()
    { 
        var now = new Date();
        var year = now.getFullYear();       //年
        var month = now.getMonth() + 1;     //月
        var day = now.getDate();            //日
        var clock = year + "-";
        if(month < 10) clock += "0";       
        clock += month + "-";
        if(day < 10) clock += "0"; 
        clock += day;
        return clock; 
    }*/

     //点击新增按钮
    function AddData() { 
        $("#myWin").show(); 
        $('#DomainParentCode').combobox('reload');
        var myWin = $HUI.dialog("#myWin",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'新增',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存',
                //iconCls:'icon-save',
                id:'save_btn',
                handler:function(){
                    SaveFunLib("");
                }
            },{
                text:'关闭',
                //iconCls:'icon-cancel',
                handler:function(){
                    myWin.close();
                }
            }]
        }); 
        $('#form-save').form("clear"); 
        $HUI.checkbox("#DomainActivity").setValue(true);
        $('#DomainStartDate').datebox('setValue', getCurentDateStr());
        $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
    }
    

    //点击修改按钮
    function UpdateData() {
        $('#DomainParentCode').combobox('reload');
        var record = mygrid.getSelected(); 
        if (record){            
             //调用后台openData方法给表单赋值
            var id = record.ID;
            $.cm({
                ClassName:"web.DHCBL.CT.HOSBusiDomain",
                MethodName:"OpenData",
                id:id
            },function(jsonData){ 
                if (jsonData.DomainActivity=="Y")
                {
                    $HUI.checkbox("#DomainActivity").setValue(true);    
                }else{
                    $HUI.checkbox("#DomainActivity").setValue(false);
                }
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
                    //iconCls:'icon-save',
                    id:'save_btn',
                    handler:function(){
                        SaveFunLib(id);
                    }
                },{
                    text:'关闭',
                    //iconCls:'icon-cancel',
                    handler:function(){
                        myWin.close();
                    }
                }]
            }); 
            $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green"); 
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
    }
    
    ///新增、更新
    function SaveFunLib(id)
    {            
        var code=$.trim($("#DomainCode").val());
        var desc=$.trim($("#DomainDesc").val());
        var datefrom=$("#DomainStartDate").datebox("getValue");
        var dateto=$("#DomainEndDate").datebox("getValue");
        if (code=="")
        {
            $.messager.alert('错误提示','代码不能为空!',"error");
            return;
        }
        if (desc=="")
        {
            $.messager.alert('错误提示','名称不能为空!',"error");
            return;
        }
        if (datefrom=="")
        {
            $.messager.alert('错误提示','开始日期不能为空!',"error");
            return;
        }
        if (datefrom != "" && dateto != "") {   
            if (datefrom >dateto) {
                $.messager.alert('错误提示','开始日期不能大于结束日期!',"error"); 
                return;
            }
        }
        $.messager.confirm('提示', "确认要保存数据吗?", function(r){
            if (r){
                $('#form-save').form('submit', { 
                    url: SAVE_ACTION_URL,                     
                    success: function (data) { 
                        var data=eval('('+data+')'); 
                        if (data.success == 'true') { 
                            $.messager.popover({msg: '提交成功！',type:'success',timeout: 1000}); 
                            $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
                            $('#mygrid').datagrid('unselectAll');
                            $('#myWin').dialog('close'); // close a dialog
                        } 
                        else { 
                            var errorMsg ="保存失败！"
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
    function DeleteData()
    {    
        //更新
        var row = $("#mygrid").datagrid("getSelected"); 
        if (!(row))
        {   $.messager.alert('错误提示','请先选择一条记录!',"error");
            return;
        } 
        $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
            if (r){ 
                var rowid=row.ID; 
                $.ajax({
                    url:DELETE_ACTION_URL,  
                    data:{"id":rowid},  
                    type:"POST",   
                    //dataType:"TEXT",  
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