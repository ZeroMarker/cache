/*
Creator:石萧伟
CreatDate:2018-02-23
Description:业务执行表
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBBusExecute&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBBusExecute";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBBusExecute&pClassMethod=DeleteData";
var TREE_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBBusExecute&pClassMethod=GetNewTreeComboJson";
var TREE_INTERCOMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBInterfaceManage&pClassMethod=GetNewTreeComboJson";
var DRAG_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBBusExecute&pClassMethod=DragNode";
var init = function(){
	//上级分类下拉树
	var lastLevelTree = $HUI.combotree('#MKBBELastLevel',{
		url:TREE_COMBO_URL
	});
	//接口下拉树
	var InterTree = $HUI.combotree('#MKBBEInterfDr',{
		url:TREE_INTERCOMBO_URL
	});
	$('#add_btn').click(function (e){
        AddData();
    });
    $('#update_btn').click(function (e){
        UpdateData();
    });
    $('#del_btn').click(function (e){
        DelData();
    });  
	 //重置按钮
	$("#btnRefresh").click(function (e) { 

			ClearFunLib();
	 }) 

	//查询方法
	/*function SearchFunLib(){
        var desc=$.trim($('#DescSearch').searchbox('getValue'));  //检索的描述
        $("#mygrid").treegrid("search", desc)

    }*/
    $('#TextDesc').searchcombobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename=User.MKBBusExecute",
		onSelect:function () 
		{	
			$(this).combobox('textbox').focus();
			var desc=$("#TextDesc").combobox('getText');
			$("#mygrid").treegrid("search", desc);
					
				}
	});
	$('#TextDesc').combobox('textbox').bind('keyup',function(e){ 
		if(e.keyCode==13){ 
        var desc=$("#TextDesc").combobox('getText');
        $("#mygrid").treegrid("search", desc)
		}
	}); 

	$("#btnSearch").click(function (e) { 
        var desc=$("#TextDesc").combobox('getText');
        $("#mygrid").treegrid("search", desc)
	})     
	//查询按钮
	$("#DescSearch").searchbox({
        searcher:function(value,name){
            SearchFunLib();
        }
    })
	//重置方法
	ClearFunLib=function()
	{
		$("#TextDesc").combobox('setValue', '');//清空检索框
		$('#mygrid').treegrid('load',  { 
		'LastLevel':''	
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//双击事件
	function  DblClickGrid(rowIndex, rowData)
	{
		UpdateData()
	}
	
	//点击新增按钮,添加下级按钮
    AddData=function() {
		var record = mygrid.getSelected();
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
			},
			{
				text:'继续新增',
				id:'save_btnagain',
				handler:function(){
					SaveFunLibT("")
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		$('#form-save').form("clear");
		//点击某行添加新数据时，默认选择该行为上级
		if(record){
			var per=record.id;
			//alert(per);
			$('#MKBBELastLevel').combotree('setValue',per);	
		}
		$HUI.checkbox("#MKBBEActive").setValue(true);		
	}
		 
	//点击添加本级
    AddDataB=function() {
		var record = mygrid.getSelected();
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
			},
			{
				text:'继续新增',
				id:'save_btnagain',
				handler:function(){
					SaveFunLibT("")
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		$('#form-save').form("clear");
		//点击某行添加新数据时，默认选择该行为上级
		if(record){
			var per=record.id;
			var LastLevel = tkMakeServerCall("web.DHCBL.MKB.MKBBusExecute","GetLastLevel",per);
			var LastId = LastLevel.split("^")[0];
			$('#MKBBELastLevel').combotree('setValue',LastId);	
		}
		$HUI.checkbox("#MKBBEActive").setValue(true);		
	}
				
	//点击修改按钮
    UpdateData=function() {
		var record = mygrid.getSelected(); 
		if (record){			
			 //调用后台openData方法给表单赋值
			var id = record.id;
			$.cm({
				ClassName:"web.DHCBL.MKB.MKBBusExecute",
				MethodName:"NewOpenData",
				id:id
			},function(jsonData){
				//给是否可用单独赋值				
				if (jsonData.MKBBEActive=="Y"){
					$HUI.checkbox("#MKBBEActive").setValue(true);		
				}else{
					$HUI.checkbox("#MKBBEActive").setValue(false);
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
					handler:function(){SaveFunLib(id)}
				},{
					text:'关闭',
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
    SaveFunLib=function(id)
	{            
						
		var code=$.trim($("#MKBBECode").val());
		var desc=$.trim($("#MKBBEBusExe").val());
		//自动生成顺序
		var level=$("#MKBBELastLevel").combotree('getValue')
		$.m({
			ClassName:"web.DHCBL.MKB.MKBBusExecute",
			MethodName:"GetLastSort",
			LastLevel:level
		},function(txtData){
				var wintitle=$('#myWin').panel('options').title;//获取修改或者添加框的标题
				if(wintitle=="新增")
				{
					mode=parseInt(txtData);//转换数据类型
					$("#MKBBELevel").val(mode+1);
				}
				var active="N";
				if ($('#MKBBEActive').attr('checked')) 
				{
					var active="Y" ;
				}
				
				if (code=="")
				{
					$.messager.alert('错误提示','代码不能为空!',"error");
					return;
				}
				if (desc=="")
				{
					$.messager.alert('错误提示','业务执行动作不能为空!',"error");
					return;
				}
				///上级分类
				if ($('#MKBBELastLevel').combotree('getText')=='')
				{
					$('#MKBBELastLevel').combotree('setValue','')
				}
				if($('#MKBBEInterfDr').combotree('getText')=='')
				{
					$('#MKBBEInterfDr').combotree('setValue','')
				}
				if(id!="")
				{
					//在修改添加时判断选中的上级是不是本身或者自己的下级
					var comboId=$('#MKBBELastLevel').combotree('getValue');
					if(justFlag(comboId,id,"mygrid"))
					{
						return;				
					}
					
				}
				$('#form-save').form('submit', { 
					url: SAVE_ACTION_URL, 
					onSubmit: function(param){
						param.MKBBERowId = id;
					},
					success: function (data) { 
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
						/*$.messager.show({ 
						  title: '提示消息', 
						  msg: '提交成功', 
						  showType: 'show', 
						  timeout: 1000, 
						  style: { 
							right: '', 
							bottom: ''
						  } 
						}); */
						$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
						$('#mygrid').treegrid('reload');  // 重新载入当前页面数据 
						$('#MKBBELastLevel').combotree('reload');//重新载入下拉框数据
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
			
		});
	}
	///继续新增
    SaveFunLibT=function(id)
	{            
						
		var code=$.trim($("#MKBBECode").val());
		var desc=$.trim($("#MKBBEBusExe").val());
		//自动生成顺序
		var level=$("#MKBBELastLevel").combotree('getValue')
		$.m({
			ClassName:"web.DHCBL.MKB.MKBBusExecute",
			MethodName:"GetLastSort",
			LastLevel:level
		},function(txtData){
				var wintitle=$('#myWin').panel('options').title;//获取修改或者添加框的标题
				if(wintitle=="新增")
				{
					mode=parseInt(txtData);//转换数据类型
					$("#MKBBELevel").val(mode+1);
				}
				var active="N";
				if ($('#MKBBEActive').attr('checked')) 
				{
					var active="Y" ;
				}
				
				if (code=="")
				{
					$.messager.alert('错误提示','代码不能为空!',"error");
					return;
				}
				if (desc=="")
				{
					$.messager.alert('错误提示','业务执行动作不能为空!',"error");
					return;
				}
					
				$('#form-save').form('submit', { 
					url: SAVE_ACTION_URL, 
					onSubmit: function(param){
						param.MKBBERowId = id;
					},
					success: function (data) { 
					  var data=eval('('+data+')'); 
					  if (data.success == 'true') {
						/*$.messager.show({ 
						  title: '提示消息', 
						  msg: '提交成功', 
						  showType: 'show', 
						  timeout: 1000, 
						  style: { 
							right: '', 
							bottom: ''
						  } 
						});*/
						$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000}); 
						$('#mygrid').treegrid('reload');  // 重新载入当前页面数据 
						$('#MKBBELastLevel').combotree('reload');//重新载入下拉框数据
						$("#MKBBECode").val("");
						$("#MKBBEBusExe").val("");
						$("#MKBBEBusScene").val("");
						$("#MKBBEInterfDr").combotree('setValue',"");
						$HUI.checkbox("#MKBBEActive").setValue(true)

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
			
		});
		
		
	}


	///删除
    DelData=function()
	{                  

		//更新
		var row = $("#mygrid").treegrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.id;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{"id":rowid},  
					type:"POST",   
					//dataType:"TEXT",  
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
								/*$.messager.show({ 
								  title: '提示消息', 
								  msg: '删除成功', 
								  showType: 'show', 
								  timeout: 1000, 
								  style: { 
									right: '', 
									bottom: ''
								  } 
								}); */
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								 $('#mygrid').treegrid('reload');  // 重新载入当前页面数据 
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

    //业务执行表主界面
    var TREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBBusExecute&pClassMethod=GetNewTreeJson";
    var mainclumns=[[
        {field:'MKBBEBusExe',title:'业务执行动作',sortable:true,width:100},
        {field:'MKBBECode',title:'代码',sortable:true,width:100},
        {field:'MKBBEBusScene',title:'业务场景',sortable:true,width:100},
        {field:'MKBINMDesc',title:'业务接口',sortable:true,width:100},
        {field:'MKBBEActive',title:'是否激活',sortable:true,width:50},
        {field:'MKBBELastLevel',title:'上级分类',sortable:true,hidden:true,width:100},
        {field:'PINYINDesc',title:'拼音码',sortable:true,hidden:true,width:100},
        {field:'id',title:'id',sortable:true,hidden:true,width:50}
        //{field:'MKBBELevel',title:'顺序',sortable:true,hidden:true}
    ]];
    var mygrid = $HUI.treegrid("#mygrid",{
        width:'100%',
        height:'100%',
        pagination: false,
        pageSize:1000,
        pageList:[1000],
        fitColumns: true,//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        loadMsg:'数据装载中......',
        autoRowHeight: true,
        url:TREE_ACTION_URL,
        singleSelect:true,
        idField:'id',
        treeField:'MKBBEBusExe',
        ClassName: "web.DHCBL.MKB.MKBBusExecute", //拖拽方法DragNode 存在的类
        SQLTableName:'MKB_BusExecute',
        ClassTableName:'Usert.MKBBusExecute',
        DragMethodName:"DragNode",
        rownumbers:false,
        fit:true,
        remoteSort:false,
        columns:mainclumns,
        //scrollbarSize :0,
        onDblClickRow:DblClickGrid,
        //animate:true,//定义在节点展开或折叠的时候是否显示动画效果。
        //为treegrid同级拖拽引用的插件enableDnd
        onLoadSuccess:function(data){
            $(this).treegrid('enableDnd', data?data.id:null);
        },
        onDrop:function (targetRow,sourceRow,point)
        {
            //onDrop,当选中某一行时触发
            //1.targetRow:放置的目标行/替换的行
            //2.sourceRow:拖拽的源行
            //3.point：指示放置的位置,可能的值:'append''top'或'bottom'。
            $(this).treegrid('enableDnd'); //允许拖拽
        },
        onContextMenu:function (e, row) { //右键时触发事件
            e.preventDefault();//阻止浏览器捕获右键事件
            $(this).treegrid('select', row.id);
            var mygridmm = $('<div style="width:120px;"></div>').appendTo('body');
			mygridmm.html(
                '<div onclick="AddDataB()" iconCls="icon-add" data-options="">添加同级</div>' +
                '<div onclick="AddData()" iconCls="icon-add" data-options="">添加子级</div>' +
                '<div onclick="UpdateData()" iconCls="icon-write-order" data-options="">修改</div>' +
                '<div onclick="DelData()" iconCls="icon-cancel" data-options="">删除</div>' +
                '<div onclick="ClearFunLib()" iconCls="icon-reload" data-options="">刷新</div>'
            )//.appendTo(mygridmm)
            mygridmm.menu()
            mygridmm.menu('show',{
                left:e.pageX,
                top:e.pageY
            });
        },
        onClickRow:function(index,row)
        {
	        RefreshSearchData("User.MKBBusExecute",row.id,"A",row.MKBBEBusExe);
        },
        onBeforeSelect:function(node){
	    	$("#TextDesc").combobox("panel").panel("close");
		}          
    });

	ShowUserHabit('mygrid');






};
$(init);
