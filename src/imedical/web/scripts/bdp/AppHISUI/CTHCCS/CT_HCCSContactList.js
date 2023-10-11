//Creator:yangfan
//CreatDate:2020-12-17
//Description:个人通讯录
var GV={}  ;//存放全局变量
var init = function(){
	
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHCCSContactList&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTHCCSContactList&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTHCCSContactList";
	
	//设备绑定弹窗
	var BAND_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHCCSEquipLinkContList&pClassMethod=DeleteData";
	var BAND_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTHCCSEquipLinkContList&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTHCCSEquipLinkContList";
	var HospID=""
	//多院区下拉框
	var hospComp=GenHospComp('CT_HCCSContactList');
	GV.getSelectHospId=function(){
		return $("#_HospList").combogrid('getValue');
	}
	GV.selectHospId=GV.getSelectHospId();
	hospComp.options().onSelect=function(){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		ClearFunLib();
	}

	
	/*
	//多院区下拉框
	var hospComp = GenHospComp("CT_HCCSContactList");
	hospComp.jdata.options.onSelect = function(e){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		ClearFunLib();
	}*/

	//个人通讯录用户查询、重置
	$('#TextUserCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});
	//个人通讯录科室查询、重置
	$('#TextLocCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
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
	 //人员分类
	$HUI.combobox("#TextType",{
		valueField:'value',
		textField:'text',
		editable:false,
		data:[
			{value:'D',text:'医生'},
			{value:'N',text:'护士'},
			{value:'O',text:'其他'},
			{value:'V',text:'虚拟账户'}
		],
		onSelect:function() 
		{	
			SearchFunLib();
        }
	});
	 //查询方法
	SearchFunLib=function(){
		var usercode=$("#TextUserCode").val();
		var loccode=$("#TextLocCode").val();
		var HospID=$HUI.combogrid('#_HospList').getValue();
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.CTHCCSContactList",
			QueryName:"GetList",	
			'usercode':usercode,	
			'loccode':loccode,
			'type':$('#TextType').combobox("getValue"),
			'hospid':HospID
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function()
	{
		$("#TextUserCode").val("");
		$("#TextLocCode").val("");
		$("#TextType").combobox('setValue', '')
		var HospID=$HUI.combogrid('#_HospList').getValue();
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.CTHCCSContactList",
			QueryName:"GetList",
			'hospid':HospID
		});
		$('#mygrid').datagrid('unselectAll');

	}
	
	//点击添加按钮
    $('#btnAdd').click(function(e)
    {
        AddData();
	});

	
    //点击修改按钮
	$('#btnUpdate').click(function(e)
	{
    	UpdateData();
	});

    //点击删除按钮
	$('#btnDel').click(function(e)
	{
    	DelData();
	});
	//点击配置按钮
	$('#btnConfig').click(function(e)
	{
    	ConfigData();
	});
	/* //查询工具栏用户下拉框
	$('#TextUserCode').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.SSUser&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'SSUSRInitials',
		textField:'SSUSRName',
		onBeforeLoad: function(param){
			param.hospid = hospComp.getValue();
		}
	});
	
	
	//查询工具栏科室下拉框
	$('#TextLocCode').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTLOCCode',
		textField:'CTLOCDesc',
		onBeforeLoad: function(param){
			param.hospid = hospComp.getValue();
		}
	});
	
	 */
	//科室下拉框
	$('#HCCSCLLocCode').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTLOCCode',
		textField:'CTLOCDesc',
		onBeforeLoad: function(param){
			param.hospid = hospComp.getValue();
		}
	});
	//用户下拉框
	/*$('#HCCSCLUserCode').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.SSUser&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'SSUSRInitials',
		textField:'SSUSRName',
		onBeforeLoad: function(param){
			param.hospid = hospComp.getValue();
		}
	});
	*/
	//人员分类
	$HUI.combobox("#HCCSCLType",{
		valueField:'value',
		textField:'text',
		editable:false,
		data:[
			{value:'D',text:'医生'},
			{value:'N',text:'护士'},
			{value:'O',text:'其他'},
			{value:'V',text:'虚拟账户'}
	]
	});
	 ///新增、修改
	SaveFunLib=function(id)
	{			
		/*var HCCSCLUserCode=$('#HCCSCLUserCode').combobox("getValue");
		if ((HCCSCLUserCode==undefined)||(HCCSCLUserCode=="") )
		{
			$.messager.alert('错误提示','用户不能为空!',"info");
			return;
		}*/
		var HCCSCLUserCode=$('#HCCSCLUserCode').val();
		if ((HCCSCLUserCode==undefined)||(HCCSCLUserCode=="") )
		{
			$.messager.alert('错误提示','用户代码不能为空!',"info");
			return;
		}
		var HCCSCLUserDesc=$('#HCCSCLUserDesc').val();
		if ((HCCSCLUserDesc==undefined)||(HCCSCLUserDesc=="") )
		{
			$.messager.alert('错误提示','用户描述不能为空!',"info");
			return;
		}
		var HCCSCLLocCode=$('#HCCSCLLocCode').combobox("getValue");
		if ((HCCSCLLocCode==undefined)||(HCCSCLLocCode=="") )
		{
			$.messager.alert('错误提示','科室不能为空!',"info");
			return;
		}
		/* var HCCSCLLocDesc=$('#HCCSCLLocDesc').val();	
		if ((HCCSCLLocDesc==undefined)||(HCCSCLLocDesc=="") )
		{
			$.messager.alert('错误提示','科室描述不能为空!',"info");
			return;
		} */
		if ($.trim($("#HCCSCLVOIPNumber").val())=="")
		{
			$.messager.alert('错误提示','VOIP号码不能为空!',"info");
			return;
		}
		var flag= tkMakeServerCall("web.DHCBL.CT.CTHCCSContactList","FormValidate",$.trim($("#HCCSCLRowId").val()),HCCSCLUserCode,hospComp.getValue());
		if (flag==1)
		{
			$.messager.alert('错误提示','同一工号下不能存储两个有效科室!',"info");
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
									$('#mygrid').datagrid('unselectAll');									
								}
								else{
									
									 $.cm({
										ClassName:"web.DHCBL.CT.CTHCCSContactList",
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
		//$('#HCCSCLUserCode').combobox('reload');
		$('#HCCSCLLocCode').combobox('reload'); 
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
		$("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
		$('#form-save').form("clear");
		var date=$.fn.datebox.defaults.formatter(new Date())
		$('#HCCSCLDateFrom').datebox('setValue',date);   //设置开始日期为当天
	}
	
	//点击修改按钮
	UpdateData=function() {
		//$('#HCCSCLUserCode').combobox('reload');
		$('#HCCSCLLocCode').combobox('reload'); 
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.HCCSCLRowId
		$.cm({
			ClassName:"web.DHCBL.CT.CTHCCSContactList",
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
		$("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
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
						"id":record.HCCSCLRowId      ///rowid
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
	//点击配置按钮
	ConfigData=function() {
		var str = tkMakeServerCall("web.DHCBL.CT.CTHCCSContactList","getConfigData")
		var PlatformID="",SceneID="",WordID="",LocID="",GroupID="",NameID=""
		if (str!=="")
		{
			strs=str.split("^");
			PlatformID=strs[0],SceneID=strs[1],WordID=strs[2],LocID=strs[3],GroupID=strs[4],NameID=strs[5]
		}
		$('#PlatformID').val(PlatformID);
		$('#SceneID').val(SceneID);
		$('#WordID').val(WordID);
		$('#LocID').val(LocID);
		$('#GroupID').val(GroupID);
		$('#NameID').val(NameID);
		$("#myConfigWin").show(); 
		var myConfigWin = $HUI.dialog("#myConfigWin",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'配置',
			modal:true,
			buttons:[{
				text:'保存',
				id:'config_save_btn',
				handler:function(){
					SaveConfigFunLib()
				}
			},{
				text:'关闭',
				handler:function(){
					myConfigWin.close();
				}
			}]
		});
		$("#config_save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
	}
	///保存配置
	SaveConfigFunLib=function(id)
	{			
		var PlatformID=$('#PlatformID').val();
		var SceneID=$('#SceneID').val();
		var WordID=$('#WordID').val();
		var LocID=$('#LocID').val();
		var GroupID=$('#GroupID').val();
		var NameID=$('#NameID').val();
		var  str=PlatformID+"^"+SceneID+"^"+WordID+"^"+LocID+"^"+GroupID+"^"+NameID
		var flag= tkMakeServerCall("web.DHCBL.CT.CTHCCSContactList","saveConfigData",str);
		if (flag==1)
		{
			$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
			$('#myConfigWin').dialog('close'); // close a dialog
		}
		else
		{
			var errorMsg ="配置保存失败！"
			$.messager.alert('操作提示',errorMsg,"error");
		}
	}
	/****************************设备绑定部分 开始***************************/
	//点击设备绑定按钮
	/*BandEQMethod=function(index)
	{
		$('#mygrid').datagrid('selectRow',index);   //点击按钮选中列表
		var record = $("#mygrid").datagrid("getSelected"); 
		var HCCSCLRowId=record.HCCSCLRowId;
		var HCCSCLUserCode=record.HCCSCLUserCode
		var HospID=$HUI.combogrid('#_HospList').getValue();
		$("#winband").show();  
		$('#winband').window({
			iconCls:'icon-paper',
			title:"设备绑定",
			width:780,
			height:Math.min(document.body.clientHeight-10,550),
			modal:true,
			resizable:true,
			minimizable:false,
			maximizable:false,
			collapsible:false,
			content:'<iframe id="band" frameborder="0" src="dhc.bdp.ct.ctcontlistlink.csp?HCCSCLRowId='+HCCSCLRowId+'&HospID='+HospID+'&HCCSCLUserCode='+HCCSCLUserCode+'" width="99%" height="98%" scrolling="auto"></iframe>'
		});
	}*/
	/****************************设备绑定部分 结束***************************/
	
	var columns =[[  
				  {field:'HCCSCLRowId',title:'HCCSCLRowId',width:80,hidden:true,sortable:true},
				  {field:'HCCSCLUserCode',title:'用户代码',width:80,sortable:true},
				  {field:'HCCSCLUserDesc',title:'用户描述',width:120,sortable:true},
				  {field:'HCCSCLType',title:'人员分类',width:120,sortable:true,
				  formatter:function(v,row,index){  
						if(v=='D'){return '医生';}
						if(v=='N'){return '护士';}
						if(v=='O'){return '其他';}
						if(v=='V'){return '虚拟账户';}
					}},
				  {field:'HCCSCLLocCode',title:'科室代码',width:80,sortable:true},
				  {field:'HCCSCLLocDesc',title:'科室描述',width:120,sortable:true},
				  {field:'HCCSCLVOIPNumber',title:'VOIP号码',width:80,sortable:true},
				  {field:'HCCSCLDateFrom',title:'开始日期',width:80,sortable:true},
				  {field:'HCCSCLDateTo',title:'结束日期',width:80,sortable:true}
				  /*,
				  {field:'HCCSCLBind',title:'设备绑定',width:60,align:'center',
                    formatter:function(val,row,index){  
                        var btn =  '<img class="contrast mytooltip" title="设备绑定" onclick="BandEQMethod('+index+')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/book_green.png" style="border:0px;cursor:pointer">'   
                        
                        return btn;  
                    }
                  }*/
				  ]];
				  
				  
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.CTHCCSContactList",
			QueryName:"GetList",
			'hospid':hospComp.getValue()    ///多院区医院
		},
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		ClassTableName:'User.CTHCCSContactList',
		SQLTableName:'CT_HCCSContactList',
		idField:'HCCSCLRowId', 
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