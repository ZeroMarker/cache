/**
 * @Author: 钟荣枫 DHC-BDP
 * @Description: 用于科室多层分类。
 * @Created on 2019-12-27

 */
var init=function(){
	var Tree_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPCTLOCCategory&pClassMethod=GetJsonList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BDPCTLOCCategory&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BDPCTLOCCategory";
	var TREE_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPCTLOCCategory&pClassMethod=GetJsonDataForCmb";
	var DRAG_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPCTLOCCategory&pClassMethod=DragNode";

	var URL_Icon =  "../scripts/bdp/Framework/icons/";   //图标基本路径 
	var LastLevel=""  //选中的类别ID，全局变量
	var Type=""		//选中的类别类型，全局变量
	var ObjectReferenceText=""  //选中的选中的角色描述，全局变量
	

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

 		
	$('#TextSearch').searchbox({
		searcher:function(value,name){
			SearchFunLib();
		}
	});	
    						  	
   //类型下拉框
	$('#Type').combobox({ 
		data:[{'value':'Area','text':'片区'},{'value':'Subject','text':'学科'},{'value':'SubjectCategory','text':'学科分类'}],
        valueField:'value',
        textField:'text',
        panelHeight:'auto'
	});

	//上级分类下拉框
	
	$HUI.combotree('#ParentCatDr',{
		 url:TREE_COMBO_URL,
		 onBeforeExpand:function(node){
			$(this).tree('expandFirstChildNodes',node)
        }
	});
	
    //查询	$("#treeId").tree("search", searchText);
    SearchFunLib=function() {
    	var str = $.trim($("#TextSearch").searchbox('getValue')); 
    	
    	$("#mygrid").treegrid("search", str)
		$('#mygrid').treegrid('unselectAll')
    };
    //重置
    ClearFunLib=function() {
    	$("#TextSearch").searchbox('setValue', '');
    	$('#mygrid').treegrid('load',  { 
			ClassName:"web.DHCBL.CT.BDPCTLOCCategory",
			QueryName:"GetJsonList"
		});
		$('#mygrid').treegrid('unselectAll'); //取消树节点选择状态
    };
     //增加同级节点
	AddSameData=function () 
	{
		
		$('#ParentCatDr').combotree('reload');
		$('#Type').combobox('reload');
	
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
					SaveFunLib("",0)
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
		$HUI.checkbox("#ActiveFlag").setValue(true);
		var record = $("#mygrid").treegrid("getSelected"); 
		if (record)
		{	
			var ParentNode =$("#mygrid").treegrid("getParent",record.id);
			if (ParentNode)
			{
				$('#ParentCatDr').combotree('setValue',ParentNode.id);
				$("#Sequence").val(tkMakeServerCall("web.DHCBL.CT.BDPCTLOCCategory","GetSequence",ParentNode.id));
			}
			else
			{
				$("#Sequence").val(tkMakeServerCall("web.DHCBL.CT.BDPCTLOCCategory","GetSequence",""));
			}
			
		}				
	}

    //添加			
	AddData=function(){
		$('#ParentCatDr').combotree('reload');
		$('#Type').combobox('reload');
		//alert(id)
		
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
					SaveFunLib("",1)								
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
		$HUI.checkbox("#ActiveFlag").setValue(true);
		
		var record = $("#mygrid").treegrid("getSelected"); 
		if (record)
		{	
			$('#ParentCatDr').combotree('setValue',record.id);
			var Sequence=tkMakeServerCall("web.DHCBL.CT.BDPCTLOCCategory","GetSequence",record.id)
			$('#Sequence').numberbox('setValue',Sequence);
		}
		else
		{
			var Sequence=tkMakeServerCall("web.DHCBL.CT.BDPCTLOCCategory","GetSequence","")
			$('#Sequence').numberbox('setValue',Sequence);
		}
		
	}

	//修改
	UpdateData=function(){
		$('#ParentCatDr').combotree('reload');
		$('#Type').combobox('reload');
		var record = $("#mygrid").treegrid("getSelected");
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		else{
			var id=record.id;
			$.cm({
				ClassName:"web.DHCBL.CT.BDPCTLOCCategory",
				MethodName:"OpenData",
				id: id,      ///rowid
				RetFlag:"N"
			},function(jsonData){		
				if (jsonData.ActiveFlag=='true')
				{
					$HUI.checkbox("#ActiveFlag").setValue(true);
				}else{
					$HUI.checkbox("#ActiveFlag").setValue(false);
				}
				$('#ParentCatDr').combotree('setValue', jsonData.ParentCatDr);
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
	//点击删除按钮
	DelData=function()
	{
		var record = $("#mygrid").treegrid("getSelected");
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		else{
			var id=record.id;
			$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				var datas = tkMakeServerCall("web.DHCBL.CT.BDPCTLOCCategory","DeleteData",id);
				var data = eval('('+datas+')');
			    if (data.success == 'true') {
			        $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
			        $('#mygrid').treegrid('remove',id); 
			        						 
			       
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
		
	}

     //保存授权数据   
    SaveFunLib = function(id,flag){
    	var Code=$("#Code").val()
		if ($.trim(Code)=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"info");
			return;
		}
		var Caption=$("#Caption").val()
		if ($.trim(Caption)=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"info");
			return;
		}

		var Type=$('#Type').combobox('getValue')	
		if ((Type==undefined)||(Type=="undefined")||(Type==""))
		{
			$.messager.alert('错误提示','类型请选择下拉列表里的值!',"info");
			return;
		}
		
		if ($('#ParentCatDr').combotree('getText')=='')
		{
			$('#ParentCatDr').combotree('setValue','')
		}

		var result= tkMakeServerCall("web.DHCBL.CT.BDPCTLOCCategory","FormValidate",id,Code,Caption,Type);
		if(result==0){
			$.messager.confirm("提示", "确认要保存数据吗?", function (r) {
				if (r) {
					///保存
					$('#form-save').form('submit', { 
						url: SAVE_ACTION_URL, 
						success: function (data) { 
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
									//var ID=$("#ID").val()
									$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});							
									
									$('#mygrid').treegrid('reload')
									$('#myWin').dialog('close');
							  } 
							  else { 
									var errorMsg ="保存失败！"
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
		else if (result==1){
			$.messager.alert('操作提示',"代码已经存在！","info");
		}
		else {
			$.messager.alert('操作提示',"同级别下描述已经存在！","info");
		}
    }
    ReturnType=function(value){
		if(value=="Area"){
			return "片区"
		}
		else if(value=="Subject"){
			return "学科"
		}
		else if(value=="SubjectCategory"){
			return "学科分类"
		}
	}

    var columns =[[  
    			  {field:'ID',title:'ID',width:80,sortable:true,hidden:true},
				  {field:'Caption',title:'描述',width:250,sortable:true},
				  {field:'Code',title:'代码',width:250,sortable:true},
				  {field:'Type',title:'类型',width:200,sortable:true,formatter:ReturnType},
				  {field:'ParentCatDr',title:'父菜单',width:150,sortable:true},
				  {field:'Sequence',title:'顺序',width:120,sortable:true},
				  {field:'ActiveFlag',title:'激活',width:80,sortable:true,formatter:ReturnFlagIcon,align:'center' }
				  
				  ]];

    var mygrid = $HUI.treegrid("#mygrid",{
		url:Tree_ACTION_URL,
		columns: columns,  //列信息
		idField: 'ID',
		ClassTableName:'User.BDPCTLOCCategory',
		SQLTableName:'BDP_CTLOCCategory',
		ClassName: "web.DHCBL.CT.BDPCTLOCCategory", //拖拽方法DragNode 存在的类
		DragMethodName:"DragNode",
		treeField:'Caption',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
		autoSizeColumn:false,
		animate:false,     //是否树展开折叠的动画效果
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
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
			handler:DelData
			
		}],
		onContextMenu: function(e, row){
			e.preventDefault();
        	$(this).treegrid('select', row.id);
			var mygridmm = $('<div style="width:150px;"></div>').appendTo('body')
			
			$(
			'<div onclick=AddSameData() iconCls="icon-add">增加同级节点</div>' +
       		'<div onclick=AddData() iconCls="icon-add">增加子节点</div>' +
       		'<div onclick=UpdateData() iconCls="icon-write-order">修改</div>' +
       		'<div onclick=DelData() iconCls="icon-cancel">删除</div>'
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
	         	RefreshSearchData("User.BDPCTLOCCategory",rowData.ID,"A",rowData.Caption)
	    },
        onDrop: function(targetRow, sourceRow, point){
        	$(this).treegrid('enableDnd') //允许拖拽
        },
        onLoadSuccess:function(row,data){
        	$(this).treegrid('enableDnd', data?data.id:null);   //允许拖拽
	        $.each(data, function(i, val) {
	          $("#mygrid").treegrid("collapseAll", data[i].id);
	        });	
        }
	});

	ShowUserHabit('mygrid');

}
$(init);