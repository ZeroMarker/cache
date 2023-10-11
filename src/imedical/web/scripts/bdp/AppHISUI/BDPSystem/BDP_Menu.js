/// 名称: 菜单维护
/// 描述: 包含增删改查 拖拽保存功能
/// 编写者: 基础数据平台组-陈莹
/// 编写日期: 2018-03-05

var init = function(){
	var changedflag=0
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenu&pClassMethod=GetJsonList";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenu&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPMenu&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPMenu";
	var TREE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMenu&pClassMethod=GetJsonDataForCmb&MKBFlag="+MKBFlag;
	
	
	///功能
	$('#LinkFuntionDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPExecutables&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'ID',
		textField:'Caption'
	});
	
	//父菜单
	/*$('#ParentMenuDr').combotree({
		 url:TREE_QUERY_ACTION_URL,
		 onBeforeExpand:function(node){
			$(this).tree('expandFirstChildNodes',node)
        }
	});*/
	$HUI.combotree('#ParentMenuDr',{
		 url:TREE_QUERY_ACTION_URL,
		 onBeforeExpand:function(node){
			$(this).tree('expandFirstChildNodes',node)
        }
	});
	//关联产品线
	$HUI.combotree('#ProductLineDr',{
		 url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.DHCProductLine&pClassMethod=GetLineForCmb",
		 onBeforeExpand:function(node){
			$(this).tree('expandFirstChildNodes',node)
        }
	});
	
	
	/*$('#TextSearchbox').searchbox({
	    searcher:function(value,name){
	    	$("#mygrid").treegrid("search", value)
	    }
	});
	*/
	
	SearchFunLib=function()
 	{
   			 var desc=$.trim($("#TextSearch").combobox('getText'));
			$("#mygrid").treegrid("search", desc)
			$('#mygrid').treegrid('unselectAll');		
	}
	
	$('#TextSearch').searchcombobox({ 
			url:$URL+"?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename="+"User.BDPMenu",
			onSelect:function () 
			{	
				$(this).combobox('textbox').focus();
				SearchFunLib()  
	        }
		});
		
		
	$('#TextSearch').combobox('textbox').bind('keyup',function(e){  
			if (e.keyCode==13){ 
				SearchFunLib()  
			}
	}); 

	$("#btnSearch").click(function (e) { 
			SearchFunLib();
	})
	
	
	
	
	//重置按钮
	$("#btnRefresh").click(function (e) { 
 			ClearFunLib();
	 }) 
 	
	//重置方法
	function ClearFunLib()
	{
	
		//$('#TextSearchbox').searchbox('setValue', '')
		$("#TextSearch").combobox('setValue', '');
		$('#mygrid').treegrid('load',  { 
			ClassName:"web.DHCBL.BDP.BDPMenu",
			QueryName:"GetJsonList",
			'MKBFlag':MKBFlag
		});
		$('#mygrid').treegrid('unselectAll'); //取消树节点选择状态

	}
	///新增、修改
	SaveFunLib=function (id)
	{            
		var code=$.trim($("#Code").val())		
		if ($.trim($("#Code").val())=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"error");
			return;
		}
		if (code.length>100)
		{
			$.messager.alert('错误提示','代码长度不能超过100!',"error");
			return;
		}
		var desc=$.trim($("#Caption").val())
		if ($.trim($("#Caption").val())=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"error");
			return;
		}
		if (desc.length>100)
		{
			$.messager.alert('错误提示','描述长度不能超过100!',"error");
			return;
		}
		
		///上级分类
		if ($('#ParentMenuDr').combotree('getText')=='')
		{
			$('#ParentMenuDr').combotree('setValue','')
		}
		
		var comboId=$('#ParentMenuDr').combotree('getValue');
		if(id!=""){
			if(justFlag(comboId,id,"mygrid"))
			{
				return;				
			}
		}	
		///产品线
		if ($('#ProductLineDr').combotree('getText')=='')
		{
			$('#ProductLineDr').combotree('setValue','')
		}
		
		if (MKBFlag==1)
		{
			if($HUI.checkbox("#IsMKBMenu").getValue()!=true)
			{
				$.messager.alert('错误提示','必须勾选属于医学知识库',"error");
				return;
			}
		}
		
		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			success: function (data) { 
			  var data=eval('('+data+')'); 
			  if (data.success == 'true') {
				$.messager.show({ 
				  title: '提示消息', 
				  msg: '提交成功', 
				  showType: 'show', 
				  timeout: 1000, 
				  style: { 
					right: '', 
					bottom: ''
				  } 
				}); 
				ReloadTreegridNode("mygrid",comboId,id)  //重新加载改动的数据
				$('#myWin').dialog('close');				
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
	 //新增同级节点
	AddSameData=function () 
	{
		
		$('#LinkFuntionDR').combobox('reload');
		$('#ParentMenuDr').combotree('reload')
		$('#ProductLineDr').combotree('reload')
	
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-addlittle',
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
		$HUI.checkbox("#actMenuBDP").setValue(true);
		$HUI.checkbox("#actMenuAutItem").setValue(true);
		$HUI.checkbox("#actMenuAutData").setValue(true);
		
		if (MKBFlag==1)
		{
			$HUI.checkbox("#IsMKBMenu").setValue(true);
		}
		else
		{
			$HUI.checkbox("#IsMKBMenu").setValue(false);
			//如勾选框默认不选择，需要去掉checked样式 ，如果默认勾选则不用加。2018-06-12
			$('#IsMKBMenu').parent().removeClass("checked");
		}
		var record = $("#mygrid").treegrid("getSelected"); 
		var Sequence=""
		if (record)
		{	
			var ParentNode =$("#mygrid").treegrid("getParent",record.id);
			if (ParentNode)
			{

				$('#ParentMenuDr').combotree('setValue',ParentNode.id);								
			}
			else
			{
				Sequence=tkMakeServerCall("web.DHCBL.BDP.BDPMenu","GetSequence","")
			}
			
		}
		$("#Sequence").numberbox("setValue",Sequence)
		
	}
	 
	
	 //点击新增按钮
	AddData=function () 
	{
		$('#LinkFuntionDR').combobox('reload');
		$('#ParentMenuDr').combotree('reload');
		$('#ProductLineDr').combotree('reload');
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
		$HUI.checkbox("#actMenuBDP").setValue(true);
		$HUI.checkbox("#actMenuAutItem").setValue(true);
		$HUI.checkbox("#actMenuAutData").setValue(true);
		if (MKBFlag==1)
		{
			$HUI.checkbox("#IsMKBMenu").setValue(true);
		}
		else
		{
			$HUI.checkbox("#IsMKBMenu").setValue(false);
			//如勾选框默认不选择，需要去掉checked样式 ，如果默认勾选则不用加。2018-06-12
			$('#IsMKBMenu').parent().removeClass("checked");
		}
		
		var record = $("#mygrid").treegrid("getSelected"); 
		var Sequence=""
		if (record)
		{	
			$('#ParentMenuDr').combotree('setValue',record.id);
			Sequence=tkMakeServerCall("web.DHCBL.BDP.BDPMenu","GetSequence",record.id)
		}
		else
		{
			Sequence=tkMakeServerCall("web.DHCBL.BDP.BDPMenu","GetSequence","")
		}
		
		$("#Sequence").numberbox("setValue",Sequence)
	}
	
	//点击修改按钮
	UpdateData=function () 
	{
		$('#LinkFuntionDR').combobox('reload');
		$('#ParentMenuDr').combotree('reload')
		$('#ProductLineDr').combotree('reload')
		var record = $("#mygrid").treegrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var id=record.ID
		$.cm({
			ClassName:"web.DHCBL.BDP.BDPMenu",
			MethodName:"OpenDataJSON",
			id:id
		},function(jsonData){
			
			if (jsonData.actMenuBDP=="Y"){
				$HUI.checkbox("#actMenuBDP").setValue(true);		
			}else{
				$HUI.checkbox("#actMenuBDP").setValue(false);
			}
			if (jsonData.actMenuBDP=="Y"){
				$HUI.checkbox("#actMenuBDP").setValue(true);		
			}else{
				$HUI.checkbox("#actMenuBDP").setValue(false);
			}
			if (jsonData.actMenuBDP=="Y"){
				$HUI.checkbox("#actMenuBDP").setValue(true);		
			}else{
				$HUI.checkbox("#actMenuBDP").setValue(false);
			}
			if (jsonData.IsMKBMenu=="Y"){
				$HUI.checkbox("#IsMKBMenu").setValue(true);		
			}else{
				$HUI.checkbox("#IsMKBMenu").setValue(false);
			}
			
			$('#ParentMenuDr').combotree('setValue', jsonData.ParentCatDr);
			$('#form-save').form("load",jsonData);
			
			
			$("#myWin").show(); 
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				showType:'fade',
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
    
    
	//批量激活菜单功能
	ActiveData=function ()
	{
		$("#myChecktreeWin").show();
		changedflag=0
		var myChecktreeWin = $HUI.dialog("#myChecktreeWin",{
			iconCls:'icon-w-paper',
			resizable:true,
			title:'批量删除/激活（基础数据授权）',
			modal:true,
			showType:'fade',
			buttons:[{
				text:'关闭',
				//iconCls:'icon-cancel',
				handler:function(){
					myChecktreeWin.close();
					if (changedflag==1)
					{
						$("#mygrid").treegrid('reload');
					}
				}
			}]
		});
	    $("#myChecktree").tree("reload")  //窗口每次打开时，数据重新加载
		$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部
		$("#myChecktreeDesc").val("")
		
	}
	
	///批量激活/隐藏菜单
	var myChecktree = $HUI.tree("#myChecktree",{
		url:TREE_QUERY_ACTION_URL,
		idField: 'id',
		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		checkbox:true,
		cascadeCheck:false,  //是否级联检查。默认true  菜单特殊，不级联操作
		animate:false,     //是否树展开折叠的动画效果
		onCheck:function(node,checked)
		{
			//保存菜单批量激活隐藏状态，点击勾选框就触发后台保存，实时保存
			var rs=tkMakeServerCall("web.DHCBL.BDP.BDPMenu","SaveActiveTree",node.id,checked)
			changedflag=1
		},
		onBeforeExpand:function(node){
			//2018-11-30展开一个节点，展开下面第一级子节点，而不是只符合查询条件的数据。 
			$(this).tree('expandFirstChildNodes',node)
        }
	});
	
	
	
	var columns =[[ 
				  {field:'ID',title:'ID',width:80,sortable:true,hidden:true},
				  {field:'Caption',title:'描述',width:280,sortable:true},
				  {field:'Code',title:'代码',width:200,sortable:true},
				  {field:'LinkUrl',title:'URL解析地址',width:250,sortable:true},
				  {field:'LinkFuntionDR',title:'功能',width:150,sortable:true},
				  {field:'CompName',title:'组件名称',width:150,sortable:true},
				  {field:'ParentMenuDr',title:'父菜单',width:150,sortable:true},
				  {field:'Sequence',title:'显示顺序',width:80,sortable:true},
				  {field:'ValueExpression',title:'值表达式',width:150,sortable:true},
				  {field:'Image',title:'图标',width:150,sortable:true},
				  {field:'ProductLineDr',title:'关联产品线',width:150,sortable:true,hidden:true},
				  {field:'Method',title:'服务器端类方法',width:150,sortable:true,hidden:true},
				  {field:'ShortcutKey',title:'快捷键',width:150,sortable:true,hidden:true},
				  {field:'ShowInNewWindow',title:'弹出窗口方式',width:150,sortable:true,hidden:true},			  
				  {field:'actMenuBDP',title:'激活基础数据维护菜单',width:80,sortable:true,formatter:ReturnFlagIcon },
				  {field:'actMenuAutItem',title:'激活功能元素授权菜单',width:80,sortable:true,formatter:ReturnFlagIcon },
				  {field:'actMenuAutData',title:'激活基础数据授权菜单',width:80,sortable:true,formatter:ReturnFlagIcon },
				  {field:'IsMKBMenu',title:'属于医学知识库',width:80,sortable:true,formatter:ReturnFlagIcon }		  
				  ]];
				  
	var mygrid = $HUI.treegrid("#mygrid",{
		url:QUERY_ACTION_URL,
		columns: columns,  //列信息
		idField: 'ID',
		queryParams:{'MKBFlag':MKBFlag}, 
		ClassTableName:'User.BDPMenu',
		SQLTableName:'BDP_Menu',
		ClassName: "web.DHCBL.BDP.BDPMenu", //拖拽方法DragNode 存在的类
		DragMethodName:"DragNode",
		treeField:'Caption',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
		autoSizeColumn:false,
		animate:false,     //是否树展开折叠的动画效果
		//fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		toolbar:[{
			iconCls:'icon-add',
			text:'新增',
			id:'add_btn',
			handler:AddData
		},{
			iconCls:'icon-write-order',
			text:'修改',
			id:'update_btn',
			handler:UpdateData
		},{
			iconCls:'icon-cancel',
			text:'删除',
			id:'del_btn',
			handler:function()
			{
				Treegrid_DelData("mygrid",DELETE_ACTION_URL)
			}
		},{
			iconCls:'icon-ok',
			text:'激活',
			id:'active_btn',
			handler:ActiveData
		}],
		onContextMenu: function(e, row){
			e.preventDefault();
        	$(this).treegrid('select', row.id);
			var mygridmm = $('<div style="width:140px;"></div>').appendTo('body')
			
			$(
			'<div onclick=AddSameData() iconCls="icon-add">新增同级节点</div>' +
       		'<div onclick=AddData() iconCls="icon-add">新增子节点</div>' +
       		'<div onclick=UpdateData() iconCls="icon-write-order">修改</div>' +
       		'<div onclick=Treegrid_DelData("mygrid","'+DELETE_ACTION_URL+'") iconCls="icon-cancel">删除</div>'
       		).appendTo(mygridmm)
		       		
			mygridmm.menu()
			mygridmm.menu('show',{
				left:e.pageX,  
				top:e.pageY
			});
		},
		onDblClickRow:function(rowIndex,rowData){
			UpdateData();
        },
        onBeforeExpand:function(row){
			$(this).treegrid('expandFirstChildNodes',row.id)
        },
        onClickRow: function (rowIndex,rowData) {
	         	RefreshSearchData("User.BDPMenu",rowData.ID,"A",rowData.Caption)
	    },
        onDrop: function(targetRow, sourceRow, point){
        	$(this).treegrid('enableDnd') //允许拖拽
        },
        onLoadSuccess:function(data){
        	$(this).treegrid('enableDnd', data?data.id:null);   //允许拖拽	
        }
	});
	ShowUserHabit('mygrid');
	
};
$(init);
