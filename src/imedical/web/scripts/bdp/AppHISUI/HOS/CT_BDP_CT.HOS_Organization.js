/// Function:HOS 组织机构
/// Creator: 钟荣枫
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.HOSOrganization&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.HOSOrganization";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSOrganization&pClassMethod=DeleteData";

var init = function(){
    
    var URL_Icon="../scripts/bdp/Framework/icons/";
    var windowHight = document.documentElement.clientHeight;        //可获取到高度
    var windowWidth = document.documentElement.clientWidth;
    var columns =[[  
                    {field:'ID',title:'ID',hidden:true},
                    {field:'ORGCode',title:'代码',width:180,sortable:true},
                    {field:'ORGDesc',title:'名称',width:180,sortable:true}, 
                    
                    {field:'ORGUSCC',title:'统一社会信用代码',width:120,sortable:true}, 
                    {field:'ORGAbbrev',title:'组织简称',width:100,sortable:true}, 
                    {field:'ORGIntro',title:'组织简介',width:100,sortable:true}, 
                    {field:'ORGLegalEntity',title:'组织法人',width:100,sortable:true}, 
                    {field:'ORGHeader',title:'组织负责人',width:100,sortable:true}, 
                    {field:'ORGORGCode',title:'上级组织',width:160,sortable:true},
                    
                    {field:'ORGORGMCCode',title:'组织小类',width:100,sortable:true},
                    
                    {field:'ORGCountryCode',title:'组织所在国家',width:100,sortable:true},
                    {field:'ORGPROVCode',title:'组织所在省',width:100,sortable:true},
                    {field:'ORGCITYCode',title:'组织所在市',width:100,sortable:true},
                    {field:'ORGDISTRCode',title:'组织所在区',width:100,sortable:true},
                    {field:'ORGAddress',title:'组织地址',width:100,sortable:true},
                    {field:'ORGZipCode',title:'组织邮编',width:100,sortable:true},
                    {field:'ORGTel',title:'联系电话',width:100,sortable:true},
                    {field:'ORGFax',title:'传真',width:100,sortable:true},
                    {field:'ORGEmail',title:'邮箱',width:100,sortable:true},
                    {field:'ORGWebSite',title:'官网',width:100,sortable:true},
                    {field:'ORGFoundDate',title:'建立日期',width:100,sortable:true},
                    {field:'ORGCancelDate',title:'注销日期',width:100,sortable:true},

                    {field:'ORGActivity',title:'是否有效',align:'center',width:80,sortable:true,formatter:ReturnFlagIcon},                    
                    {field:'ORGStartDate',title:'开始日期',width:180,sortable:true}, 
                    {field:'ORGEndDate',title:'结束日期',width:180,sortable:true}, 
                    {field:'ORGSeqNo',title:'排序号',width:60,sortable:true}, 
                    {field:'ORGPYCode',title:'拼音码',width:80,sortable:true},
                    {field:'ORGWBCode',title:'五笔码',width:80,sortable:true},                   
                    {field:'ORGMark',title:'备注',width:100,sortable:true},                   
                    {field:'ORGStandardCode',title:'标准编码',width:100,sortable:true},                   
                    {field:'ORGStandardDesc',title:'标准名称',width:100,sortable:true},                   
                    {field:'ORGCodeBefore',title:'原系统编码',width:100,sortable:true}                    
                ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
         queryParams:{
            ClassName:"web.DHCBL.CT.HOSOrganization",
            QueryName:"GetList"
        }, 
        columns: columns,  //列信息
        ClassTableName:'CT.BDP.CT.HOSOrganization',
        SQLTableName:'CT_BDP_CT.HOS_Organization',
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300], 
        singleSelect:true,
        idField:'ID', 
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        //fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
        onDblClickRow:function(rowIndex,rowData){
            UpdateData();
        }
    });
   


    //上级组织下拉框 
    $('#ORGORGCode').combobox({ 
        url:$URL+"?ClassName=web.DHCBL.CT.HOSOrganization&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'ID',
        textField:'ORGDesc'
    });
   

    //组织小类下拉框 
    $('#ORGORGMCCode').combobox({ 
        url:$URL+"?ClassName=web.DHCBL.CT.HOSOrgMinCategory&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'ID',
        textField:'ORGMCDesc'
    });
   

    //组织所在国家下拉框 
    $('#ORGCountryCode').combobox({ 
        url:$URL+"?ClassName=web.DHCBL.CT.CTCountry&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'CTCOURowId',
        textField:'CTCOUDesc',
        placeholder:'国家',
        onSelect:function(record){
            ReloadROVCode()
        },
        onChange:function(newValue, oldValue){
            if (newValue==""){
                $('#ORGPROVCode').combobox('loadData',{});
                $('#ORGPROVCode').combobox('setValue',"");
                $('#ORGCITYCode').combobox('loadData',{});
                $('#ORGCITYCode').combobox('setValue',"");
                $('#ORGDISTRCode').combobox('loadData',{});
                $('#ORGDISTRCode').combobox('setValue',"");
            }
        }
    });

    //重载省
    ReloadROVCode=function(){
        $('#ORGPROVCode').combobox("setValue","")
        $('#ORGCITYCode').combobox("setValue","")
        $('#ORGDISTRCode').combobox("setValue","")
        var CountryCode=$('#ORGCountryCode').combobox('getValue');
        var url=$URL+"?ClassName=web.DHCBL.CT.CTProvince&QueryName=GetDataForCmb1&ResultSetType=array&countrydr=" +CountryCode;
        $('#ORGPROVCode').combobox('reload',url);
    }

    //组织所在省下拉框 
    $('#ORGPROVCode').combobox({ 
        //url:$URL+"?ClassName=web.DHCBL.CT.CTProvince&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'PROVRowId',
        textField:'PROVDesc',
        placeholder:'省',
        onSelect:function(record){
            ReloadCITYCode()
        },
        onChange:function(newValue, oldValue){
            if (newValue==""){
                $('#ORGCITYCode').combobox('loadData',{});
                $('#ORGCITYCode').combobox('setValue',"");
                $('#ORGDISTRCode').combobox('loadData',{});
                $('#ORGDISTRCode').combobox('setValue',"");
            }
        }
    });

    //重载市
    ReloadCITYCode=function(){
        $('#ORGCITYCode').combobox("setValue","")
        $('#ORGDISTRCode').combobox("setValue","")
        var PROVCode=$('#ORGPROVCode').combobox('getValue');
        var url=$URL+"?ClassName=web.DHCBL.CT.CTCity&QueryName=GetDataForCmb1&ResultSetType=array&provincedr=" +PROVCode;
        $('#ORGCITYCode').combobox('reload',url);
    }

    //组织所在市下拉框 
    $('#ORGCITYCode').combobox({ 
        //url:$URL+"?ClassName=web.DHCBL.CT.CTCity&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'CTCITRowId',
        textField:'CTCITDesc',
        placeholder:'市',
        onSelect:function(record){
            ReloadISTRCode()
        },
        onChange:function(newValue, oldValue){
            if (newValue==""){
                $('#ORGDISTRCode').combobox('loadData',{});
                $('#ORGDISTRCode').combobox('setValue',"");
            }
        }
    });

    //重载县区
    ReloadISTRCode=function(){
        $('#ORGDISTRCode').combobox("setValue","")
        var ITYCode=$('#ORGCITYCode').combobox('getValue');
        var url=$URL+"?ClassName=web.DHCBL.CT.CTCityArea&QueryName=GetDataForCmb1&ResultSetType=array&citydr=" +ITYCode;
        $('#ORGDISTRCode').combobox('reload',url);
    }
    //组织所在县下拉框 
    $('#ORGDISTRCode').combobox({ 
        //url:$URL+"?ClassName=web.DHCBL.CT.CTCityArea&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'CITAREARowId',
        textField:'CITAREADesc',
        placeholder:'县区'
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
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSOrganization",
            QueryName:"GetList" ,   
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
            ClassName:"web.DHCBL.CT.HOSOrganization",
            QueryName:"GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    }
    //失焦事件
     $('#ORGDesc').bind('blur',function(){
          var ORGDesc=$("#ORGDesc").val()  
          var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",ORGDesc) 
          var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",ORGDesc,1) 
          $("#ORGPYCode").val(PYCode)
          $("#ORGWBCode").val(WBCode)                                           
      });
     //点击新增按钮
    function AddData() { 
        $("#myWin").show(); 
        $('#ORGORGCode').combobox("reload")
        $('#ORGORGMCCode').combobox("reload")
        $('#ORGCountryCode').combobox("reload")
        $('#ORGPROVCode').combobox("reload")
        $('#ORGCITYCode').combobox("reload")
        $('#ORGDISTRCode').combobox("reload")

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
        $HUI.checkbox("#ORGActivity").setValue(true);
        $('#ORGStartDate').datebox('setValue', getCurentDateStr());
        $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
    }
    

    //点击修改按钮
    function UpdateData() {
        $('#ORGORGCode').combobox("reload")
        $('#ORGORGMCCode').combobox("reload")
        $('#ORGCountryCode').combobox("reload")
        $('#ORGPROVCode').combobox("reload")
        $('#ORGCITYCode').combobox("reload")
        $('#ORGDISTRCode').combobox("reload")
        var record = mygrid.getSelected(); 
        if (record){  
                     
             //调用后台openData方法给表单赋值
            var id = record.ID;
            $.cm({
                ClassName:"web.DHCBL.CT.HOSOrganization",
                MethodName:"OpenData",
                id:id
            },function(jsonData){ 
                //滚动条回到最上面
                $("#ORGCode").focus()
                $("#ORGCode").blur() 

                if (jsonData.ORGActivity=="Y")
                {
                    $HUI.checkbox("#ORGActivity").setValue(true);    
                }else{
                    $HUI.checkbox("#ORGActivity").setValue(false);
                }                
                //国家 省 市 县区 重新加载
                if(jsonData.ORGCountryCode!="") $('#ORGPROVCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTProvince&QueryName=GetDataForCmb1&ResultSetType=array&countrydr="+jsonData.ORGCountryCode);
                if(jsonData.ORGPROVCode!="") $('#ORGCITYCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTCity&QueryName=GetDataForCmb1&ResultSetType=array&provincedr="+jsonData.ORGPROVCode);
                if(jsonData.ORGCITYCode!="") $('#ORGDISTRCode').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.CTCityArea&QueryName=GetDataForCmb1&ResultSetType=array&citydr="+jsonData.ORGCITYCode);                
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
        var code=$.trim($("#ORGCode").val());
        var desc=$.trim($("#ORGDesc").val());
        var datefrom=$("#ORGStartDate").datebox("getValue");
        var dateto=$("#ORGEndDate").datebox("getValue");
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