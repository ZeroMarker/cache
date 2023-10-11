/// Function:HOS岗位角色
///	Creator: gaoshanshan
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.HOSPostRole&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.HOSPostRole";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSPostRole&pClassMethod=DeleteData";

var init = function(){
    var URL_Icon="../scripts/bdp/Framework/icons/";

	//角色代码
	$("#POROROLECode").combobox({
	    url:$URL+"?ClassName=web.DHCBL.CT.SSGroup&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'SSGRPRowId',
	    textField: 'SSGRPDesc'
	})

    var columns =[[  
                  {field:'POROPOSTDesc',title:'岗位',width:180,sortable:true},
                  {field:'POROROLEDesc',title:'角色',width:180,sortable:true},
                  {field:'POROActivity',title:'是否有效',align:'center',width:80,sortable:true,formatter:ReturnFlagIcon},  
                  {field:'POROStartDate',title:'开始日期',width:120,sortable:true},  
                  {field:'POROEndDate',title:'结束日期',width:120,sortable:true},  
                  {field:'POROSeqNo',title:'排序号',width:80,sortable:true},  
                  {field:'POROPYCode',title:'拼音码',width:120,sortable:true},  
                  {field:'POROWBCode',title:'五笔码',width:120,sortable:true},  
                  {field:'POROMark',title:'备注',width:120,sortable:true},  
                  {field:'ID',title:'ID',hidden:true}
                  ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.HOSPostRole",
            QueryName:"GetList",
            'code':PostID
        }, 
        columns: columns,  //列信息
        ClassTableName:'CT.BDP.CT.HOSPostRole',
        SQLTableName:'CT_BDP_CT.HOS_PostRole',
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

	//角色查询框
	$("#TextRole").combobox({
	    //url:$URL+"?ClassName=web.DHCBL.CT.SSGroup&QueryName=GetDataForCmb1&ResultSetType=array",
	    valueField: 'SSGRPRowId',
	    textField: 'SSGRPDesc',
	    onShowPanel:function(){
	    	$('#TextRole').combobox('reload',$URL+"?ClassName=web.DHCBL.CT.SSGroup&QueryName=GetDataForCmb1&ResultSetType=array")
	    },
	    onSelect:function(){
	    	SearchFunLib();
	    }
	})
	
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
        var role=$('#TextRole').combobox('getValue');
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSPostRole",
            QueryName:"GetList" ,   
            'code':PostID,    
            'role':role
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    //重置方法
    function ClearFunLib()
    {
        $('#TextRole').combobox('setValue',"");
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSPostRole",
            QueryName:"GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
     //点击新增按钮
    function AddData() { 
        $("#myWin").show(); 
        $('#POROROLECode').combobox('reload');
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
        $HUI.checkbox("#POROActivity").setValue(true);
        $('#POROStartDate').datebox('setValue', getCurentDateStr());
        $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
    }
 

    //点击修改按钮
    function UpdateData() {
        var record = mygrid.getSelected(); 
        if (record){            
             //调用后台openData方法给表单赋值
            var id = record.ID;
            $.cm({
                ClassName:"web.DHCBL.CT.HOSPostRole",
                MethodName:"OpenData",
                id:id
            },function(jsonData){ 
                $('#form-save').form("load",jsonData);  
				if(jsonData.POROActivity=="Y"){
					$HUI.checkbox("#POROActivity").setValue(true);
				}else{
					$HUI.checkbox("#POROActivity").setValue(false);
				}
            });
                     
            $("#myWin").show(); 
            $('#POROROLECode').combobox('reload');
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
        var role=$('#POROROLECode').combobox('getValue');
        var datefrom=$("#POROStartDate").datebox("getValue");
        var dateto=$("#POROEndDate").datebox("getValue");

        if (role=="")
        {
            $.messager.alert('错误提示','角色不能为空!',"error");
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
                    onSubmit: function(param){
                        param.POROPOSTCode = PostID;
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