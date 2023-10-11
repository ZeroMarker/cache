/// 名称: 床位费时制关联时段
/// 描述:包含时段增删改查功能
/// 编写者： 基础数据平台组 鲁俊文
/// 编写日期: 2022-10-17
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BedFeeTimePeriod&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BedFeeTimePeriod";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BedFeeTimePeriod&pClassMethod=DeleteData";
var init = function(){
    var columns =[[   
                  {field:'DateFrom',title:'开始日期',width:180,sortable:true},
                  {field:'DateTo',title:'结束日期',width:180,sortable:true},
                  {field:'ParRef',title:'父表指针',width:180,sortable:true,hidden:true},
                  {field:'RowId',title:'RowId',hidden:true}
                  ]];
                  
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.BedFeeTimePeriod",
            QueryName:"GetList",
            parref:ParRef
        }, 
        columns: columns,  //列信息
        ClassTableName:'CT.BDP.CT.BedFeeTimePeriod',
        SQLTableName:'CT_BDP_CT.BedFeeTimePeriod',
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
        singleSelect:true, //最多允许选择一行
        idField:'RowId',   //指明标识字段
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        //remoteSort:false,  //定义是否从服务器排序数据。定义是否从服务器排序数据。true
        //toolbar:'#mytbar'
        
		onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
		}
    });

     
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
	
   
    
     //点击新增按钮
    function AddData() { 
        $("#myWin").show();    
        $('#form-save').form("clear");
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
	         
                    SaveFunLib("")
                }
            },{
                text:'关闭',
                //iconCls:'icon-cancel',
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
            var id = record.RowId;
            $.cm({
                ClassName:"web.DHCBL.CT.BedFeeTimePeriod",
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
                    //iconCls:'icon-save',
                    id:'save_btn',
                    handler:function(){
                    	SaveFunLib(id)
                    }
                },{
                    text:'关闭',
                    //iconCls:'icon-cancel',
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
        var datefrom=$("#DateFrom").datebox("getValue");
        var dateto=$("#DateTo").datebox("getValue");
        // 获取时间微调组件的值alert(v);
        if (datefrom=="")
        {
            $.messager.alert('错误提示','开始日期不能为空!',"error");
            return;
        }
        if (dateto=="")
        {
            $.messager.alert('错误提示','结束日期不能为空!',"error");
            return;
        }
        if (datefrom != "" && dateto != "") 
        {  
        	if (datefrom >dateto) 
        	{
        		$.messager.alert('错误提示','开始日期不能大于结束日期!',"error"); 
          		return;
      		}
      	}
      			
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				$('#form-save').form('submit', { 
					url: SAVE_ACTION_URL, 
					onSubmit: function(param){
						param.ParRef = ParRef;
					},
					success: function (data) { 
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
						$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
						if (id!="")
								{
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据
									$('#mygrid').datagrid('unselectAll');									
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.CT.BedFeeTimePeriod",
										QueryName:"GetList",
										rowid: data.id   
									},function(jsonData){
										$('#mygrid').datagrid('insertRow',{
											index:0,
											row:jsonData.rows[0]
										})
									})
									$('#mygrid').datagrid('unselectAll');
								}
								$('#myWin').dialog('close'); // close a dialog
						//$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
						//$('#mygrid').datagrid('unselectAll');
						//$('#myWin').dialog('close'); // close a dialog
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
				var rowid=row.RowId; 
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
    ShowUserHabit('mygrid');
};

$(init);