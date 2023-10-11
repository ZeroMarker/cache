/// Function:床位费时制
///	Creator: 鲁俊文
///CreateTime:2022-9-13
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BedFeeTime&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BedFeeTime";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BedFeeTime&pClassMethod=DeleteData";
var init = function(){
    var windowHight = document.documentElement.clientHeight;        //可获取到高度
    var windowWidth = document.documentElement.clientWidth;
	var columns =[[ 
	 		  {field:'BedFeeTimeRowId',title:'BedFeeTimeRowId',hidden:true},
              {field:'BedFeeTimeCode',title:'代码',width:180,sortable:true},
              {field:'BedFeeTimeName',title:'名称',width:180,sortable:true}, 
              {field:'BedFeeDateFrom',title:'开始日期',width:180,sortable:true},
              {field:'BedFeeDateTo',title:'结束日期',width:180,sortable:true},
              
              ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url: $URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.BedFeeTime",
            QueryName:"GetList",
        }, 
        columns: columns,  //列信息
        ClassTableName:'CT.BDP.CT.BedFeeTime',
        SQLTableName:'CT_BDP_CT.BedFeeTime',
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
        singleSelect:true,
        idField:'BedFeeTimeRowId', 
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        //remoteSort:false,  //定义是否从服务器排序数据。定义是否从服务器排序数据。true
        //toolbar:'#mytbar'
        
		onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
		}
    });

    var pg = $("#mygrid").datagrid("getPager");
    if(pg)
    {
   		$(pg).pagination({
       onRefresh:function(pageNumber,pageSize){
           $('#mygrid').datagrid('unselectAll');
        },
       onChangePageSize:function(){
            $('#mygrid').datagrid('unselectAll');
        },
       onSelectPage:function(pageNumber,pageSize){
           $('#mygrid').datagrid('unselectAll');
        }
   		});
	}
	
    //搜索回车事件
	$('#TextDesc,#TextCode').keyup(function(event){
		if(event.keyCode == 13)
		{
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
	
	//时段信息弹窗
	$('#btnTimePeriod').bind('click', function(){
		var record = $("#mygrid").datagrid("getSelected"); 		
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		
		var ParRef=record.BedFeeTimeRowId; //父表RowId
		var BedFeeTimeNameTip=record.BedFeeTimeName;
		
        var url="dhc.bdp.ct.bedfeetimeperiod.csp?ParRef="+ParRef;       
		if ('undefined'!==typeof websys_getMWToken)
        {
			url += "&MWToken="+websys_getMWToken() //增加token
		}		
		$("#winTimePeriod").show();  
		$('#winTimePeriod').window({
			iconCls:'icon-paper',
			title:BedFeeTimeNameTip+"-床位费时制信息",
            width: windowWidth-50,    
            height: windowHight-20,	
			modal:true,
			resizable:true,
			minimizable:false,
			maximizable:false,
			collapsible:false,
			content:'<iframe frameborder="0" src="'+url+'" width="100%" height="100%" scrolling="auto"></iframe>',
			onBeforeClose:function(){            
		　　　　// $('#mygrid').datagrid('reload');      
		　　}
		});
	});
	
 
	
     //查询方法
    function SearchFunLib(){
        var code=$.trim($("#TextCode").val());
        var name=$.trim($('#TextDesc').val());   
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.BedFeeTime",
            QueryName:"GetList" ,   
            'code':code,    
            'name': name

        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    //重置方法
    function ClearFunLib()
    {
        $("#TextCode").val("");
        $("#TextDesc").val("");
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.CT.BedFeeTime",
            QueryName:"GetList"
        });
        $('#mygrid').datagrid('unselectAll');
    }
    
    
     //点击新增按钮
    function AddData() { 
        $("#myWin").show(); 

        var myWin = $HUI.dialog("#myWin",{
            iconCls:'icon-w-add',
            resizable:true,
            title:'新增',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存',
                //iconCls:'icon-save',
                //id:'save_btn',
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
         $('#form-save').form("clear"); //优化弹窗清空          
    }
    //点击修改按钮
    function UpdateData() 
    {
        var record = mygrid.getSelected(); 
        if (record)
        {            
             //调用后台openData方法给表单赋值
            var id = record.BedFeeTimeRowId;
            $.cm({
                ClassName:"web.DHCBL.CT.BedFeeTime",
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
                    //id:'save_btn',
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
        }
        else
        {
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
    }
	
    ///新增、更新
    function SaveFunLib(id)
    {            
        var code=$.trim($("#BedFeeTimeCode").val());
        var name=$.trim($("#BedFeeTimeName").val());
        var datefrom=$("#BedFeeDateFrom").datebox("getValue");
        var dateto=$("#BedFeeDateTo").datebox("getValue");      
        if (code=="")
        {
            $.messager.alert('错误提示','代码不能为空!',"error");
            return;
        }
        if (name=="")
        {
            $.messager.alert('错误提示','描述不能为空!',"error");
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
						param.BedFeeTimeRowId = id;
					},
					success: function (data) { 
					  var data=eval('('+data+')'); 
					  if (data.success == 'true')
					  {
						  $.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
						if (id!="")
						{
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据
									$('#mygrid').datagrid('unselectAll');									
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.CT.BedFeeTime",
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

    //删除 
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
				var rowid=row.BedFeeTimeRowId; 
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
    ShowUserHabit('mygrid');
};
$(init);