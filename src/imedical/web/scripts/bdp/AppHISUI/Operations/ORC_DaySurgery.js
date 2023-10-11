/// 日间手术表
/// 基础数据平台-李可凡
/// 2021-05-08

var GV={}  ;//存放全局变量
var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ORCDaySurgery&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ORCDaySurgery";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCDaySurgery&pClassMethod=DeleteData";
	
	var HospID=""
	//多院区下拉框
	var hospComp=GenHospComp('ORC_DaySurgery');
	GV.getSelectHospId=function(){
		return $("#_HospList").combogrid('getValue');
	}
	GV.selectHospId=GV.getSelectHospId();
	hospComp.options().onSelect=function(){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		ClearFunLib();
	}
	
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
	
	//手术下拉框
	$('#DSDaySurgeryDR').combobox({
		url:$URL+"?ClassName=web.DHCBL.CT.ORCOperation&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+HospID,
		valueField:'OPERRowId',
		textField:'OPERDesc'
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
	SearchFunLib=function(){
		var code=$.trim($("#TextCode").val());
		var desc=$.trim($('#TextDesc').val());
		var HospID=hospComp.getValue();
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.ORCDaySurgery",
			QueryName:"GetList",
			'hospid':HospID,
			'code':code,	
			'desc':desc
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function()
	{
		$("#TextCode").val("");
		$("#TextDesc").val("");
		var HospID=hospComp.getValue();
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.ORCDaySurgery",
			QueryName:"GetList",
			'hospid':HospID
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	///删除
	DelData=function()
	{                  
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{
						"id":record.DSRowId
					},  
					type:"POST",   
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
									$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
									
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
									$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据
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
	
	///新增、修改
	SaveFunLib=function(id)
	{
		if ($('#DSDaySurgeryDR').combobox('getValue')=="")
		{
			$.messager.alert('错误提示','手术不能为空!',"info");
			return;
		}
		var flag = tkMakeServerCall("web.DHCBL.CT.ORCDaySurgery","FormValidate",$("#DSRowId").val(),$('#DSDaySurgeryDR').combobox('getValue'),hospComp.getValue());	
		if (flag==1)
		{
			$.messager.alert('操作提示',"该记录已经存在！","info");
			return;
		}
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				$('#form-save').form('submit', { 
					url: SAVE_ACTION_URL, 
					onSubmit: function(param){
						param.LinkHospId = hospComp.getValue()
					},
					success: function (data) { 
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
								$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
								if (id!="")
								{
									$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.CT.ORCDaySurgery",
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

	}
	
	//点击新增按钮
	AddData=function() {
		var HospID=hospComp.getValue();
		var url=$URL+"?ClassName=web.DHCBL.CT.ORCOperation&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+HospID;
		$('#DSDaySurgeryDR').combobox('reload',url);
		//$('#DSDaySurgeryDR').combobox('reload');
		$("#myWin").show();
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
		$('#form-save').form("clear");
		
	}
	
	//点击修改按钮
	UpdateData=function() {
		var HospID=hospComp.getValue();
		var url=$URL+"?ClassName=web.DHCBL.CT.ORCOperation&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+HospID;
		$('#DSDaySurgeryDR').combobox('reload',url);
		//$('#DSDaySurgeryDR').combobox('reload');
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.DSRowId
		$.cm({
			ClassName:"web.DHCBL.CT.ORCDaySurgery",
			MethodName:"OpenData",
			id:id
		},function(jsonData){
			$('#form-save').form("load",jsonData);
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
		});
		
	}
	
	//datagrid排序：
	function sort_int(a,b){
		if(a.length >b.length) return 1;
		else if (a.length <b.length) return -1;
		else if (a > b) return 1;
		else return -1;
	}
	
	var columns =[[
				{field:'DSRowId',title:'RowId',width:80,hidden:true,sortable:true},
				{field:'DSDaySurgeryDR',title:'手术DR',width:120,hidden:true,sortable:true,},
				{field:'OPERCode',title:'代码',width:120,sortable:true},
				{field:'OPERDesc',title:'名称',width:120,sortable:true}
				]];
	
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.ORCDaySurgery",
			QueryName:"GetList",
			'hospid':hospComp.getValue()    //多院区医院
		},
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		ClassTableName:'User.ORCDaySurgery',
		SQLTableName:'ORC_DaySurgery',
		idField:'DSRowId', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true, //列号 自适应宽度
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		
		onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }
		
	});
	ShowUserHabit('mygrid');
	
};
$(init);