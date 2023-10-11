/// 名称: 房间
/// 描述: 包含增删改查、维护房间
/// 编写者: 基础数据平台组-钟荣枫
/// 编写日期: 2019-11-18
var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.LAB.BTRoom&pClassMethod=SaveEntity&pEntityName=web.Entity.LAB.BTRoom";
	
	$.extend($.fn.validatebox.defaults.rules, {   
	    maxLength: {   
	        validator: function(value, param){   
	            return param[0] >= value.length;   
	        },   
	        message: '请输入最大{0}位字符.'  
	    }   
	}); 
	
	//点击事件
	//点击查询按钮
	$("#btnSearch").click(function(e){
		SearchFunLib();
	});
	//点击重置按钮
	$("#btnRefresh").click(function(e){
		ClearFunLib();
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
			DelData();
	});	
	$('#TextCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});
	$('#TextDesc').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});
	//医院下拉框
	$('#HospitalDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
				
	//查询
	SearchFunLib=function(){
		var code=$("#TextCode").val()
		var name=$("#TextDesc").val()
		$('#mygrid').datagrid('load',  { 
			'ClassName':"web.DHCBL.LAB.BTRoom",
			'QueryName':"GetList",
			'code': code,
			'desc': name
		});
		$('#mygrid').datagrid('unselectAll');
	}
	//重置
	ClearFunLib=function(){
		$("#TextCode").val("")
		$("#TextDesc").val("")
		$('#mygrid').datagrid('load',  { 
			'ClassName':"web.DHCBL.LAB.BTRoom",
			'QueryName':"GetList"			
		}); 
		$('#mygrid').datagrid('unselectAll');
	}
	
	//点击添加按钮
	AddData=function () 
	{	
		$('#HospitalDR').combobox('reload');
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
		$('#form-save').form("clear");
		$HUI.checkbox("#Active").setValue(true);

	}
	
	//点击修改按钮
	UpdateData=function () 
	{
		
		$('#HospitalDR').combobox('reload');		
		var record=mygrid.getSelected();	
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		else{
			var id=record.RowID;
			$.cm({
				ClassName:"web.DHCBL.LAB.BTRoom",
				MethodName:"OpenData",
				id: id      ///rowid
			},
			function(jsonData){		
				if (jsonData.Active==1)
				{
					$HUI.checkbox("#Active").setValue(true);	
				}else{
					$HUI.checkbox("#Active").setValue(false);
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
		}						
	}
	///添加、修改
	SaveFunLib=function(id)
	{	
		var Code=$("#Code").val()
		if ($.trim(Code)=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"info");
			return;
		}
		var CName=$("#CName").val()
		if ($.trim(CName)=="")
		{
			$.messager.alert('错误提示','名称不能为空!',"info");
			return;
		}
		var HospitalDR=$('#HospitalDR').combobox('getValue')	
		if ((HospitalDR==undefined)||(HospitalDR=="undefined")||(HospitalDR==""))
		{
			$.messager.alert('错误提示','医院请选择下拉列表里的值!',"info");
			return;
		}
		var result= tkMakeServerCall("web.DHCBL.LAB.BTRoom","FormValidate",id,Code,HospitalDR);
		if(result==0){

			$.messager.confirm('提示', "确认要保存数据吗?", function(r){
				if (r){
					///保存
					$('#form-save').form('submit', { 
						url: SAVE_ACTION_URL,
						success: function (data) { 
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
									$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
									if (id!="")
									{
										$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
									}
									else{
										
										 $.cm({
											ClassName:"web.DHCBL.LAB.BTRoom",
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
									var errorMsg ="提交失败！"
									if (data.errorinfo) {
										errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
									}
									$.messager.alert('操作提示',errorMsg,"error");
							  }
						} 
					});
				}
			})
		}else{
			$.messager.alert('操作提示',"该记录已经存在！","info");
		}
	}
	//点击删除按钮
	DelData=function()
	{
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var rowid=row.RowID;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				var datas = tkMakeServerCall("web.DHCBL.LAB.BTRoom","DeleteData",rowid);
				var data = eval('('+datas+')');

			    if (data.success == 'true') {
			        $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
			        $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
					$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据 							 			       
			    }
			    else{
			        var errorMsg ="删除失败！"
					if (data.info) {
						errorMsg =errorMsg+ '<br/>错误信息:' + data.info
					}
					$.messager.alert('操作提示',errorMsg,"error");
			    }				
			}
		});
	}

	function sort_int(a,b){  
	    if(a.length > b.length) return 1;
	        else if(a.length < b.length) return -1;
	        else if(a > b) return 1;
	        else return -1;
	}  
	
	//RowID,Code,CName,HospitalDR,Sequence,Active
	var columns =[[  
				  {field:'RowID',title:'RowID',width:60,sortable:true,hidden:true},//,hidden:true
				  {field:'Sequence',title:'序号',width:60,sortable:true,sorter:sort_int},//,sorter:sort_int 
				  {field:'Code',title:'代码',width:60,sortable:true},
				  {field:'CName',title:'名称',width:100,sortable:true},
				  {field:'HospitalDR',title:'医院',width:150,sortable:true},
				  {field:'Active',title:'激活',align:'center',formatter:ReturnFlagIcon,width:60,sortable:true}
	 ]];
	 
	 
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.LAB.BTRoom",         ///调用Query时
			QueryName:"GetList"
		},
		ClassTableName:'dbo.BTRoom',
		SQLTableName:'dbo.BT_Room',
		idField:'RowID',
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		
		onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
        },
        onClickRow:function(rowIndex,rowData){
        
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }
	});
	ShowUserHabit('mygrid');
	HISUI_Funlib_Translation('mygrid');
    HISUI_Funlib_Sort('mygrid');
	
};
$(init);
