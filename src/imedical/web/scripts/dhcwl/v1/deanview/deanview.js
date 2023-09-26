/**
 * @Title:院区配置
 * @Author: 汪凯-DHCWL
 * @Description:院区配置维护界面
 * @Created on 2018-01-10
 */
var init = function(){
	/*--响应用户新增按钮点击事件，弹出选择框--*/
	var addUser = function(){
		$('#searchText').searchbox('setValue', '');
		userListObj.load({ClassName:"web.DHCWL.V1.YZCXData.FunctionModule",QueryName:"GetUserComboQuery",filterUser:''}); 
		$("#iconsDlg").show();
		var iconsDlgObj = $HUI.dialog("#iconsDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			buttons:[{
				text:'保存',
				handler:function(){
					var row = userListObj.getSelected();
					if (!row) {
						$.messager.alert("提示","请先选择一行");
						return;
					};
					var ID=row.id;
					$.m({ClassName:"web.DHCWL.V1.YZCXData.SaveData",MethodName:"SaveUserNew",  //$.m是固定写法,用于调用自定义处理方法
						"userID":ID
					},function(btn){
						if (btn=="ok"){  //返回数据成功
							iconsDlgObj.close();
							userTableObj.load();
							disableUserDelButton();
						}else{  //返回数据失败的处理
							$.messager.alert("提示",btn); 
						}
					})
				}
			},{
				text:'关闭',
				handler:function(){
					/*--点击关闭按钮,关闭弹出框--*/
					iconsDlgObj.close();
				}
			}]
		});	
	}
	
	
	/*--响应院区新增点击事件，弹出选择框--*/
	var hoselect = function(){
		$("#hoselect").show();
		var row = userTableObj.getSelected();
		if (!row) {
			$.messager.alert("提示","请先选择用户");  //当没有选中已维护用户的时候，弹框提示
			return;
		};
		var ID=row.ID;
		codecbgObj.load({ClassName:"web.DHCWL.V1.YZCXData.FunctionModule",QueryName:"GetAllHosQuery",filterInfor:ID});
		var hosDlgObj = $HUI.dialog("#hoselect",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			buttons:[{
				text:'保存',
				handler:function(){
					var hosRow = codecbgObj.getSelected();
					if (!hosRow) {
						$.messager.alert("提示","院区还没有选中"); //当没有选中需要新增的院区时报错
						return;
					};
					var userID=row.ID;
					var hosID=hosRow.allHosID;
					$.m({ClassName:"web.DHCWL.V1.YZCXData.SaveData",MethodName:"SaveHospNew",  //调用后台方法的固定写法
						"userID":userID,"hospId":hosID
					},function(btn){
						if (btn=="ok"){ //返回数据成功时
							hosDlgObj.close();  //关闭弹出框
							hospTableObj.load();  //重新院区表格
							disableHosDelButton();  //删除按钮设置不可用
							var row = $("#userList").datagrid("getSelected");
							if (row){
								var index = $("#userList").datagrid("getRowIndex",row);
								$('#userList').datagrid('updateRow',{
									index: index,
									row: {
										flag: '是'
									}
								});
							}
						}else{     //操作失败提示操作信息
							$.messager.alert("提示",btn);
						}
					})
					
					
				}
			},{
				text:'关闭',
				handler:function(){
					hosDlgObj.close();  //点击关闭按钮关闭弹出框
				}
			}]
		});	
	}
	
	
	
	/*--已维护用户表格--*/
	var userTableObj = $HUI.datagrid("#userList",{
		url:$URL,  //固定写法
		queryParams:{
			ClassName:"web.DHCWL.V1.YZCXData.FunctionModule", //class或者query路径
			QueryName:"GetAllUserQuery", //query名
			ProfileID:""
		},
		pagination:true, //是否支持分页
		//striped:true,    //斑马线效果
		pageSize:15,     //页面默认一页显示条数
	    pageList:[5,10,15,20,50,100],   //可选择的分页条数
		fitColumns:true,   //列充满表格
		toolbar:[{
			iconCls:'icon-add',  //按钮图标样式
			text:'新增',         //按钮文本
			handler:function(){
				addUser();   //点击按钮响应事件
			}
		},{
			iconCls:'icon-cancel',  //按钮图标样式
			text:'删除',   //按钮文本
			disabled:true, //按钮默认不可用
			id:'delIcons', //按钮ID
			handler:function(){
				var row = userTableObj.getSelected();
				if (!row) {
					$.messager.alert("提示","请先选择一行");
					return;
				};
				var ID=row.ID;
				$.messager.confirm("提示", "删除后将不能恢复,确认删除么", function (r) {
					if (r) {
						$.m({
							ClassName:"web.DHCWL.V1.YZCXData.SaveData",
							MethodName:"deleteUserNew",//固定写法，调用后台写好的类方法
							"ID":ID
						},function(btn){
							if (btn=="ok"){  //成功删除时,1、重新加载用户表格 2、将删除按钮重新置成不可用状态
								userTableObj.load();
								disableUserDelButton();
							}else{
								$.messager.alert("提示",btn);  //删除失败时弹出错误信息
							}
						})
					}
				});
				
				
			}
		}],
		onSelect:function(rowIndex,rowData){  //响应行选中事件
			if (rowIndex>-1){
				enableUserDelButton();  //用户删除按钮可用
				disableHosDelButton();  //科室删除按钮不可用
				hospTableObj.load({ClassName:"web.DHCWL.V1.YZCXData.FunctionModule",QueryName:"GetHosByUserQuery",userID:rowData.ID});  //重新加载关联的院区表格
			}
		},
		onLoadSuccess:function(data){
			$("#iconList").datagrid('loadData',{total:0,rows:[]})
		}
	});
	
	
	/*--已维护院区表格数据--*/
	var hospTableObj = $HUI.datagrid("#iconList",{
		url:$URL,   //URL固定写法
		queryParams:{
			ClassName:"web.DHCWL.V1.YZCXData.FunctionModule",  //调用方法或query的路径
			QueryName:"GetHosByUserQuery"  //调用query名
		},
		onSelect:function(rowIndex,rowData){  //监听表格选中事件
			if (rowIndex>-1){
				enableHosDelButton();  //选中一行时删除按钮变成可用状态
			}
		},
		pagination:true,  //分页可用
		//striped:true,  //表格斑马线状态
		pageSize:15,  //当前页每页条数
	    pageList:[5,10,15,20,50,100],  //每页可以选中的显示条数
		fitColumns:true,  //列填充满datagrid
		toolbar:[
		{
			iconCls:'icon-add',  //新增图标样式
			text:'新增',  //新增文本
			handler:function(){  //响应方法
				var row = userTableObj.getSelected();
				if (!row) {
					$.messager.alert("提示","用户还没有选中");
					return;
				};
				hoselect();  //弹出院区新增界面
			}
		},{
			iconCls:'icon-cancel',  //删除按钮的样式
			text:'删除',  
			disabled:true,  //默认不可用
			id:'delIcon',  //删除按钮的ID
			handler:function(){
				var row = hospTableObj.getSelected();
				if (!row) {
					$.messager.alert("提示","请先选中要删除的院区");
					return;
				};
				$.messager.confirm('提示', '您确认要删除该院区么?', function(r){  //确认删除提示
					if (r){
						var userID=row.ID;
						$.m({ClassName:"web.DHCWL.V1.YZCXData.SaveData",MethodName:"deleteHospNew",  //调用方法固定写法
								"id":userID
						},function(btn){
							if (btn=="ok"){   //调用方法成功
								var rows = $("#iconList").datagrid("getRows");
								var len = rows.length;
								if (len == 1){
									var row = $("#userList").datagrid("getSelected");
									if (row){
										var index = $("#userList").datagrid("getRowIndex",row);
										$('#userList').datagrid('updateRow',{
											index: index,
											row: {
												flag: '否'
											}
										});
									}
								}
								hospTableObj.load();   //病区表格数据重新加载
								disableHosDelButton();  //病区按钮置为不可用状态
							}else{
								$.messager.alert("提示",btn);  //运行错误时给出提示
							}
						})
						
						
					}
				});
			}
		}]
	})
	
	/*--用户新增表格--*/
	var userListObj = $HUI.datagrid("#userBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.YZCXData.FunctionModule",
			QueryName:"GetUserComboQuery"
		},
		columns:[[
			{field:'id',width:'200',title:'ID'},
			{field:'desc',width:'308',title:'用户'}
		]],
		pagination:true,
		//striped:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100],
		toolbar:'#usertb'  //将id是usertb的div作为toolbar
	})
	
	/*--院区新增表格--*/
	var codecbgObj = $HUI.datagrid("#combogrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.YZCXData.FunctionModule",
			QueryName:"GetAllHosQuery"
		},
		columns:[[
			{field:'allHosID',title:'院区ID',width:80},
			{field:'allHosCode',title:'院区编码',width:200},
			{field:'allHosDesc',title:'院区描述',width:230},
		]],
		pagination:true,
		//striped:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100]
	})
	/*--用户表格删除按钮可用--*/
	var enableUserDelButton = function(){
		var p = userTableObj.getPanel();
		p.find("#delIcons").linkbutton("enable",false);
	}
	/*--用户表格删除按钮不可用--*/
	var disableUserDelButton = function(){
		var p = userTableObj.getPanel();
		p.find("#delIcons").linkbutton("disable",false);
		
	}
	/*--院区表格删除按钮不可用--*/
	var enableHosDelButton = function(){
		var p = hospTableObj.getPanel();
		p.find("#delIcon").linkbutton("enable",false);
		
	}
	/*--院区表格删除按钮可用--*/
	var disableHosDelButton = function(){
		var p = hospTableObj.getPanel();
		p.find("#delIcon").linkbutton("disable",false);
	}
	/*--用户新增查询--*/
	$('#searchText').searchbox({
		searcher:function(value,name){
			userListObj.load({ClassName:"web.DHCWL.V1.YZCXData.FunctionModule",QueryName:"GetUserComboQuery",filterUser:value}); 
		}
	});
};
$(init);