/// 名称: 药品成分字典
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-丁亚男
/// 编写日期: 2018-8-15
var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtIngr&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHExtIngr";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtIngr&pClassMethod=DeleteData";
	
	var DrugId = tkMakeServerCall("web.DHCBL.KB.DHCPHLibCat","GetDrugId","DRUG");  //默认药品的值
	var CatID="";
	///代码生成规则
	$HUI.checkbox("#AutoCodeF",{
		onChecked: function(event){
			$("#CodeLenF").attr("disabled",true); 
			$("#StartCodeF").attr("disabled",true); 
		},
		onUnchecked: function(event){
			 $("#CodeLenF").attr("disabled",false); 
			$("#StartCodeF").attr("disabled",false); 
		}
	});
	ConfigData=function ()
	{
			var AutoCode=tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","ShowAutoCode","AutoCode");
			var CodeLen=tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","ShowAutoCode","CodeLen");
			var StartCode=tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","ShowAutoCode","StartCode");
			if(AutoCode=="") {AutoCode=false}
			if(AutoCode=="false"){AutoCode=false}
			$("#myWinAutoCode").show(); 
			var myWinAutoCode = $HUI.dialog("#myWinAutoCode",{
				iconCls:'icon-w-batch-cfg',
				resizable:true,
				title:'代码生成规则',
				modal:true,
				//height:$(window).height()-70,
				buttons:[{
					text:'保存',
					//iconCls:'icon-save',
					id:'save_btn',
					handler:function(){
						SaveAutoCode()
					}
				},{
					text:'关闭',
					//iconCls:'icon-cancel',
					handler:function(){
						myWinAutoCode.close();
					}
				}]
			});
			$('#form-save-AutoCode').form("clear");
			$HUI.checkbox("#AutoCodeF").setValue(AutoCode);
			$('#CodeLenF').val(CodeLen);
			$('#StartCodeF').val(StartCode);
	}
	//保存自动生成代码规则
	SaveAutoCode=function (){	
		var configureFlag=$('#AutoCodeF').checkbox('getValue');
		 if(configureFlag)
        {
            var StartCode="";
            var CodeLen="";
            var AutoCode="true"
        }
        else
        {
        	var AutoCode=""
			var CodeLen=$.trim($("#CodeLenF").val())
			var StartCode=$.trim($("#StartCodeF").val())
			var regex=/^[a-zA-Z]+$/;
			if (StartCode.length==1)
			{
                $.messager.alert('错误提示','代码起始字符不能以单个字符为准!',"error");
                return;  				
			}
			if (!StartCode.match(regex))
           {
                $.messager.alert('错误提示','代码起始字符必须为英文字母!',"error");
                return;  
           }
			if (CodeLen=="")
			{
				$.messager.alert('错误提示','代码长度不能为空!',"error");
				return;
			}
			if (StartCode=="")
			{
				$.messager.alert('错误提示','代码起始字符不能为空!',"error");
				return;
			}
        }
			var saveflag =tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","SaveAutoCode",AutoCode,CodeLen,StartCode);
			if (saveflag==2& StartCode!="" & CodeLen!="")
			{
				$.messager.alert('错误提示','代码起始字符的长度要小于代码长度!',"error");
				return;
			}
			if (saveflag==""){
					$.messager.alert('操作提示','保存失败',"error");
					
				}else{
					/*$.messager.show({ 
							  title: '提示消息', 
							  msg: '保存成功', 
							  showType: 'show', 
							  timeout: 1000, 
							  style: { 
								right: '', 
								bottom: ''
							  } 
							});*/
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					$('#myWinAutoCode').dialog('close');
				}
		
	}
	///关系
	var RelationCmb = $HUI.combobox("#PHEINGRelationF",{
		valueField:'id',
		textField:'text',
		data:[
			{id:'>',text:'大于'},
			{id:'<',text:'小于'},
			{id:'=',text:'等于'},
			{id:'!>',text:'不大于'},
			{id:'!<',text:'不小于'},
			{id:'<>',text:'不等于'}			
		]

	});
	//检索框
	$('#FindTreeText').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});
	$("#btn_search").click(function(e){
		SearchFunLib();
	})
	//查询方法
	SearchFunLib=function (){
		var desc=$.trim($("#FindTreeText").val());
		$("#mygrid").treegrid("search", desc)
		$('#mygrid').treegrid('unselectAll');
		
	}
		
		
	//重置方法
	ClearFunLib=function ()
	{
		$("#FindTreeText").val("");
		$('#mygrid').treegrid('load',  { 
				ClassName:"web.DHCBL.KB.DHCPHExtIngr",
				QueryName:"NewGetTreeJson"
			});
		$('#mygrid').datagrid('unselectAll');
	}
	//上级分类
	$HUI.combotree('#PHEINGLastLevelF',{
		 url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtIngr&pClassMethod=NewGetTreeJson"
	});
	
	 //点击添加同级节点按钮
	AddSameDataTree = function() {
		$('#PHEINGLastLevelF').combotree('reload')
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
					SaveFunLibTree("")
				}
			},{
				text:'继续新增',
				//iconCls:'icon-save',
				id:'save_btn',
				handler:function(){
					TAddFunLibTree("")
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});	
		$('#form-save').form("clear");
		var code = tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","GetLastCode");
		$('#PHEINGCodeF').val(code);
		var record = $("#mygrid").treegrid("getSelected"); 
		if (record)
		{
			var ParentNode=$("#mygrid").treegrid("getParent",record.id)
			if (ParentNode)
			{
				$('#PHEINGLastLevelF').combotree('setValue', ParentNode.id);
			}
		}
		$HUI.checkbox("#PHEINGActiveFlagF").setValue(true);
		$HUI.checkbox("#PHEINGSysFlagF").setValue(true);
	}
	
	 //点击添加同级子节点按钮
	AddDataTree = function() {
		$('#PHEINGLastLevelF').combotree('reload')		
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			//height:$(window).height()-70,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				//iconCls:'icon-save',
				id:'save_btn',
				handler:function(){
					SaveFunLibTree("")
				}
			},{
				text:'继续新增',
				//iconCls:'icon-save',
				id:'save_btn',
				handler:function(){
					TAddFunLibTree("")
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
		var code = tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","GetLastCode");
		$('#PHEINGCodeF').val(code);
		var record = $("#mygrid").treegrid("getSelected"); 
		if (record)
		{
			$('#PHEINGLastLevelF').combotree('setValue', record.id);
		}
		$HUI.checkbox("#PHEINGActiveFlagF").setValue(true);
		$HUI.checkbox("#PHEINGSysFlagF").setValue(true);
	}
	
	 //点击修改按钮
	UpdateDataTree=function () {
		$('#PHEINGLastLevelF').combotree('reload')
		var record = $("#mygrid").treegrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var id=record.id
		$.cm({
			ClassName:"web.DHCBL.KB.DHCPHExtIngr",
			MethodName:"NewOpenData",
			id:id
		},function(jsonData){
			$('#form-save').form("load",jsonData);	
			$("#myWin").show(); 
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				//height:$(window).height()-70,
				buttons:[{
					text:'保存',
					//iconCls:'icon-save',
					id:'save_btn',
					handler:function(){
						SaveFunLibTree(id)
					}
				},{
					text:'关闭',
					//iconCls:'icon-cancel',
					handler:function(){
						myWin.close();
					}
				}]
			});
		});
		
	}
	
	///新增、更新
	SaveFunLibTree=function (id){		
		if ($.trim($("#PHEINGCodeF").val())=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"error");
			return;
		}
		if ($.trim($("#PHEINGDescF").val())=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"error");
			return;
		}
		///上级分类
		if ($('#PHEINGLastLevelF').combotree('getText')=='')
		{
			$('#PHEINGLastLevelF').combotree('setValue','')
		}
		var PivaTotalQty=$.trim($("#PHEINGPivaTotalQtyF").val())
		if(PivaTotalQty!="")
		{
			var regex=/^\d+(\.\d+)?$/;
			if (!PivaTotalQty.match(regex))
	        {
	            $.messager.alert('错误提示','配液整组含量必须为浮点数!',"error");
	            return;  
	        }
		}
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			onSubmit: function(param){
				param.PHICRowId = id;		
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
	
	///继续添加
	TAddFunLibTree=function (id){		
		if ($.trim($("#PHEINGCodeF").val())=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"error");
			return;
		}
		if ($.trim($("#PHEINGDescF").val())=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"error");
			return;
		}
		var LastLevel=$('#PHEINGLastLevelF').combotree('getValue')
		///上级分类
		if ($('#PHEINGLastLevelF').combotree('getText')=='')
		{
			$('#PHEINGLastLevelF').combotree('setValue','')
		}
		var PivaTotalQty=$.trim($("#PHEINGPivaTotalQtyF").val())
		if(PivaTotalQty!="")
		{
			var regex=/^\d+(\.\d+)?$/;
			if (!PivaTotalQty.match(regex))
	        {
	            $.messager.alert('错误提示','配液整组含量必须为浮点数!',"error");
	            return;  
	        }
		}
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			onSubmit: function(param){
				param.PHICRowId = id;		
			},
			success: function (data) { 
				  var data=eval('('+data+')'); 
				  if (data.success == 'true') {
				  		$('#form-save').form("clear");
				  		var code = tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","GetLastCode");
						$('#PHEINGCodeF').val(code);
				  		$HUI.checkbox("#PHEINGActiveFlagF").setValue(true);
						$HUI.checkbox("#PHEINGSysFlagF").setValue(true);
						$('#PHEINGLastLevelF').combotree('setValue', LastLevel);
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
						//$('#myWin').dialog('close'); // close a dialog
						
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
	///删除
	DelDataTree=function (){                  
		var record = $("#mygrid").treegrid("getSelected"); 
		if (!(record))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){			
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{
						"id":record.id      ///rowid
					},  
					type:"POST",   
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
									$('#mygrid').treegrid('unselectAll');  // 清空列表选中数据
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
	//检索框
	$("#myChecktreeDesc").keyup(function(){ 
		var str = $("#myChecktreeDesc").val(); 
		findByRadioCheck("myChecktree",str,$("input[name='FilterCK']:checked").val())
		
	})
	///全部、已选、未选
	$HUI.radio("#myChecktreeWin [name='FilterCK']",{
        onChecked:function(e,value){
        	findByRadioCheck("myChecktree",$("#myChecktreeDesc").val(),$(e.target).attr("value"))
       }
    });
    
    
	//批量设定药品
	BatchData=function ()
	{
		var record = $("#mygrid").treegrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请选择需要批量设定药品的药品成分!',"error");
			return;
		}
		else{
			$("#myChecktreeWin").show();
			changedflag=0
			var myChecktreeWin = $HUI.dialog("#myChecktreeWin",{
				iconCls:'icon-w-paper',
				resizable:true,
				title:'批量设定药品',
				modal:true,
				showType:'fade',
				buttons:[{
					text:'关闭',
					//iconCls:'icon-cancel',
					handler:function(){
						myChecktreeWin.close();
						if (changedflag==1)
						{
							//$("#mygrid").treegrid('reload');
						}
					}
				}]
			});
			options={};
			options.url="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGenIngr&pClassMethod=NewGetTreeJson&DrugId="+DrugId+"&CatID="+CatID,
			$('#myChecktree').tree(options); 
		    //$("#myChecktree").tree("reload")  //窗口每次打开时，数据重新加载
			$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部
			$("#myChecktreeDesc").val("")
		}	
	}
	
	///批量激活/隐藏菜单
	var myChecktree = $HUI.tree("#myChecktree",{
		//url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGenIngr&pClassMethod=NewGetTreeJson&DrugId="+DrugId+"&CatID="+CatID,
		idField: 'id',
		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		checkbox:true,
		cascadeCheck:false,  //是否级联检查。默认true  菜单特殊，不级联操作
		animate:false,     //是否树展开折叠的动画效果
		onCheck:function(node,checked)
		{
			//保存菜单批量激活隐藏状态，点击勾选框就触发后台保存，实时保存
			var rs=tkMakeServerCall("web.DHCBL.KB.DHCPHExtGenIngr","NewSaveBatchData",DrugId,CatID,node.id,checked)
			changedflag=1
		}
	});
	
	
	///左侧列表
	var ISPToolBarUsetype;
	var columns =[[  
				  {field:'id',title:'id',width:80,sortable:true,hidden:true},
				  {field:'text',title:'描述',width:360,sortable:true}
				  ]];
	var mygrid = $HUI.treegrid("#mygrid",{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtIngr&pClassMethod=NewGetTreeJson&libDr="+DrugId,
		columns: columns,  //列信息
		height:$(window).height()-105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
		idField: 'id',
		ClassName: "web.DHCBL.KB.DHCPHExtIngr", //拖拽方法DragNode存在的类
		DragMethodName:"DragNode",
		treeField:'text',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。		
		autoSizeColumn:false,
		animate:false,     //是否树展开折叠的动画效果
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		lines:true,
		showHeader:false,
       // toolbar:'#mybar',
		striped:false,
		onContextMenu: function(e, row){   //右键菜单
			var $clicked=$(e.target);
			copytext =$clicked.text()||$clicked.val()   //普通复制功能
		
			termdr=row.id
			e.preventDefault();
        	$(this).treegrid('select', row.id);
			var mygridmm = $('<div style="width:120px;"></div>').appendTo('body')
			
			$(
			'<div onclick="AddSameDataTree()" iconCls="icon-add" data-options="">新增本级</div>' +
       		'<div onclick="AddDataTree()" iconCls="icon-add" data-options="">新增下级</div>' +
       		'<div onclick="UpdateDataTree()" iconCls="icon-write-order" data-options="">修改</div>' +
       		'<div onclick="DelDataTree()" iconCls="icon-cancel" data-options="">删除</div>'+
       		'<div onclick="ClearFunLib()" iconCls="icon-reload" data-options="">重置</div>'
       		).appendTo(mygridmm)
		       		
			mygridmm.menu()
			mygridmm.menu('show',{
				left:e.pageX,  
				top:e.pageY
			});	
		},
        onDblClickRow: function (rowIndex,rowData) {
        	CatID=rowData.id
        	UpdateDataTree()
        },
         onClickRow: function (rowIndex,rowData) {
        	CatID=rowData.id
        },
		onLoadSuccess:function(data) {
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
			
			$(this).treegrid('enableDnd', data?data.id:null);   //允许拖拽
		
        },
        
        onDrop: function(targetRow, sourceRow, point){
        	$(this).treegrid('enableDnd') //允许拖拽
        }
	});

};
$(init);
