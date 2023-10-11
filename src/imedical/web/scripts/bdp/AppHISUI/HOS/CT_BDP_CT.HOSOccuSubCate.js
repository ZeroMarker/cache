/// Function:职业子类字典
///	Creator: lujunwen
//Date：2022-11-18
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.HOSOccuSubCate&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.HOSOccuSubCate";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSOccuSubCate&pClassMethod=DeleteData";

var init = function(){
    var columns =[[  
                  {field:'OCCUSCCode',title:'代码',width:180,sortable:true},
                  {field:'OCCUSCDesc',title:'名称',width:180,sortable:true},
                  {field:'OCCUSCOCCUCCode',title:'职业大类',width:180,sortable:true},
                  {field:'OCCUSCActivity',title:'是否有效',width:150,sortable:true,align:'center',formatter:ReturnFlagIcon},  
                  {field:'OCCUSCStartDate',title:'开始日期',width:180,sortable:true},
                  {field:'OCCUSCEndDate',title:'结束日期',width:180,sortable:true},
                  {field:'OCCUSCSeqNo',title:'排序号',width:180,sortable:true},
                  {field:'OCCUSCPYCode',title:'拼音码',width:180,sortable:true},
                  {field:'OCCUSCWBCode',title:'五笔码',width:180,sortable:true},
                  {field:'OCCUSCMark',title:'备注',width:180,sortable:true},
                  {field:'ID',title:'ID',hidden:true}
                  ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
         queryParams:{
            ClassName:"web.DHCBL.CT.HOSOccuSubCate",
            QueryName:"GetList"
        }, 
        columns: columns,  //列信息
        ClassTableName:'CT.BDP.CT.HOSOccuSubCate',
        SQLTableName:'CT_BDP_CT.HOS_OccuSubCate',
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
	
	//职业大类下拉框
    $('#OCCUSCOCCUCCode').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.HOSOccuCategory&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'ID',
		textField:'OCCUCDesc'
	});
	
	//职业大类查询下拉框
    $('#Occupation').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.HOSOccuCategory&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'ID',
		textField:'OCCUCDesc'
	});	
	
	
     //查询方法
    function SearchFunLib(){
        var code=$.trim($("#TextCode").val());
        var desc=$.trim($('#TextDesc').val());
        var occupation=$("#Occupation").combobox('getValue') 
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSOccuSubCate",
            QueryName:"GetList" ,   
            'code':code,    
            'desc': desc,
            'occupation':occupation
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    //重置方法
    function ClearFunLib()
    {
        $("#TextCode").val("");
        $("#TextDesc").val("");
        $("#Occupation").combobox('setValue','');  ///职业大类
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.HOSOccuSubCate",
            QueryName:"GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
     //点击新增按钮
    function AddData() { 
        $("#myWin").show();
        var url=$URL+"?ClassName=web.DHCBL.CT.HOSOccuCategory&QueryName=GetDataForCmb1&ResultSetType=array";
		$('#OCCUSCOCCUCCode').combobox('reload',url);        
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
		$('#form-save').form("clear"); //优化弹窗清空
		$('#OCCUSCStartDate').datebox('setValue', getCurentDateStr());
        $HUI.checkbox("#OCCUSCActivity").setValue(true); 
        $("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");                   
    }
 

    //点击修改按钮
    function UpdateData() {
        var record = mygrid.getSelected(); 
        var url=$URL+"?ClassName=web.DHCBL.CT.HOSOccuCategory&QueryName=GetDataForCmb1&ResultSetType=array";
		$('#OCCUSCOCCUCCode').combobox('reload',url);     
        if (record){            
             //调用后台openData方法给表单赋值
            var id = record.ID;
            $.cm({
                ClassName:"web.DHCBL.CT.HOSOccuSubCate",
                MethodName:"OpenData",
                id:id
            },function(jsonData){ 
                $('#form-save').form("load",jsonData);
                if (jsonData.OCCUSCActivity=="Y")
				{	
					$HUI.checkbox("#OCCUSCActivity").setValue(true);	
				}else{
					$HUI.checkbox("#OCCUSCActivity").setValue(false);
				}                

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
        var code=$.trim($("#OCCUSCCode").val());
        var desc=$.trim($("#OCCUSCDesc").val());
        var datefrom=$("#OCCUSCStartDate").datebox("getValue");
        var dateto=$("#OCCUSCEndDate").datebox("getValue");
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
					onSubmit: function(param){  
						param.ID = id;
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
    //HISUI_Funlib_Translation('mygrid');
    //HISUI_Funlib_Sort('mygrid');
};
$(init);