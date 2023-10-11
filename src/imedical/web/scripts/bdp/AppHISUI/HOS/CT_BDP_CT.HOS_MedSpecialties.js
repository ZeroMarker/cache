/// Function:HOS 医疗机构二级诊疗科目
/// Creator: gaoshanshan
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.HOSMedSpecialties&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.HOSMedSpecialties";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSMedSpecialties&pClassMethod=DeleteData";

var init = function(){
    var URL_Icon="../scripts/bdp/Framework/icons/";
    
    //一级诊疗科目下拉框 
    $('#MSPECMSUBCode').combobox({ 
        url:$URL+"?ClassName=web.DHCBL.CT.HOSMedSubjects&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'ID',
        textField:'MSUBDesc'
    }); 
    var columns =[[  
                    {field:'ID',title:'ID',hidden:true},
                    {field:'MSPECCode',title:'代码',width:180,sortable:true},
                    {field:'MSPECDesc',title:'名称',width:180,sortable:true}, 
                    {field:'MSPECMSUBDesc',title:'一级诊疗科目',width:180,sortable:true}, 
                    {field:'MSPECSource',title:'分类来源',width:180,sortable:true}, 
                    {field:'MSPECActivity',title:'是否有效',align:'center',width:80,sortable:true,formatter:ReturnFlagIcon},                    
                    {field:'MSPECStartDate',title:'开始日期',width:180,sortable:true}, 
                    {field:'MSPECEndDate',title:'结束日期',width:180,sortable:true}, 
                    {field:'MSPECSeqNo',title:'排序号',width:60,sortable:true}, 
                    {field:'MSPECPYCode',title:'拼音码',width:80,sortable:true},
                    {field:'MSPECWBCode',title:'五笔码',width:80,sortable:true},                   
                    {field:'MSPECMark',title:'备注',width:100,sortable:true}                       
                ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
         queryParams:{
            ClassName:"web.DHCBL.CT.HOSMedSpecialties",
            QueryName:"GetList"
        }, 
        columns: columns,  //列信息
        ClassTableName:'CT.BDP.CT.HOSMedSpecialties',
        SQLTableName:'CT_BDP_CT.HOS_MedSpecialties',
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

   //搜索回车事件
    $('#TextDesc,#TextCode').keyup(function(event){
        if(event.keyCode == 13) {
          SearchFunLib();
        }
    });  
    //一级诊疗科目查询框
    $('#TextSubjects').combobox({ 
        //url:$URL+"?ClassName=web.DHCBL.CT.HOSMedSubjects&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'ID',
        textField:'MSUBDesc',
        onShowPanel:function(){
	    	$('#TextSubjects').combobox('reload', $URL+"?ClassName=web.DHCBL.CT.HOSMedSubjects&QueryName=GetDataForCmb1&ResultSetType=array")
	    },
        onSelect:function(){
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
        var subjects=$("#TextSubjects").combobox('getValue')
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSMedSpecialties",
            QueryName:"GetList" ,   
            'code':code,    
            'desc': desc,
            'subjects':subjects
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    //重置方法
    function ClearFunLib()
    {
        $("#TextCode").val("");
        $("#TextDesc").val("");
        $("#TextSubjects").combobox('setValue',"")
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSMedSpecialties",
            QueryName:"GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    }
    //失焦事件
     $('#MSPECDesc').bind('blur',function(){
          var MSPECDesc=$("#MSPECDesc").val()  
          var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetDBCCNCODE",MSPECDesc,4) 
          var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",MSPECDesc,1) 
          $("#MSPECPYCode").val(PYCode)
          $("#MSPECWBCode").val(WBCode)                                           
      });

     //点击新增按钮
    function AddData() { 
        $("#myWin").show(); 
        $('#MSPECMSUBCode').combobox('reload');
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
        $HUI.checkbox("#MSPECActivity").setValue(true);
        $('#MSPECStartDate').datebox('setValue', getCurentDateStr());
        $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
    }
    

    //点击修改按钮
    function UpdateData() {
        var record = mygrid.getSelected(); 
        if (record){            
             //调用后台openData方法给表单赋值
            var id = record.ID;
            $.cm({
                ClassName:"web.DHCBL.CT.HOSMedSpecialties",
                MethodName:"OpenData",
                id:id
            },function(jsonData){ 

                $('#form-save').form("load",jsonData); 
                
                if(jsonData.MSPECActivity=="Y"){
					$HUI.checkbox("#MSPECActivity").setValue(true);
				}else{
					$HUI.checkbox("#MSPECActivity").setValue(false);
				}
            });
                     
            $("#myWin").show(); 
            $('#MSPECMSUBCode').combobox('reload');
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
        var code=$.trim($("#MSPECCode").val());
        var desc=$.trim($("#MSPECDesc").val());
        var datefrom=$("#MSPECStartDate").datebox("getValue");
        var dateto=$("#MSPECEndDate").datebox("getValue");
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