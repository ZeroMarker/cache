//页面Gui
var objScreen = new Object();
var obj = new Object();
function InitviewScreen(){
	obj.optionID=""		//自己的
	obj.Entity=""		//病种ID
	obj.indexExp=""
	obj.radioVal=""
    $.parser.parse(); // 解析整个页面 
    $('#ItemOptions').tree({
		url:$URL+"?ClassName=DHCMA.CPW.SDS.QCIndexInfoSrv&QueryName=QryQCEntityCatTree&aActvie=1&ResultSetType=array"	
		,onLoadSuccess:function(node,data)
		{
			//回调
		},
		onExpand:function(node)
			{
				obj.refreshNode(node);			
			},
		lines:true
	})
	
	$HUI.radio("[name='type']",{  
		onChecked:function(e,value){
			obj.radioVal = $(e.target).val();   //当前选中的值
			obj.gridScreeningLoad(obj.radioVal)
		}
	});
	$HUI.combobox('#cboParentid',
	    {
		    defaultFilter:4,
			url:$URL+'?ClassName=DHCMA.CPW.SDS.QCIndexInfoSrv&QueryName=QryQCHeadertype&EntityId='+obj.Entity+'&aType='+obj.radioVal+'&ResultSetType=Array',
			valueField:'RowId',
			textField:'Desc'	  
	    })
	$HUI.combobox('#cboHeadertype',
	    {
		    data:[
		    	{'Headertype':'1','Desc':"父指标"},
		    	{'Headertype':'0','Desc':"末级指标"}
		    ],
		    onChange:function(newValue,oldValue){	
		    	var url=$URL+'?ClassName=DHCMA.CPW.SDS.QCIndexInfoSrv&QueryName=QryQCHeadertype&EntityId='+obj.Entity+'&aType='+obj.radioVal+'&ResultSetType=Array';
				$('#cboParentid').combobox('reload',url);	
				if(newValue=="1"){
					$('#cboParentid').combobox('clear');
					$('#cboParentid').combobox('disable');
					$('#txtField').val('');
					$('#txtField').attr("disabled","disabled");
				}else{
					$('#cboParentid').combobox('enable');
					$('#txtField').removeAttr("disabled");
				
				}
			},
			valueField:'Headertype',
			textField:'Desc',
	    })
	 $HUI.combobox('#cboType',
	 {
	    data:[
	    	{'type':'0','Desc':"合计指标"},
	    	{'type':'1','Desc':"明细指标"}
	    ],
		valueField:'type',
		textField:'Desc',
	 })
 	//监听事件
	$('#ItemOptions').tree({
			onClick:function(node){	
			if(node.code.indexOf("SD")<0){
				obj.EntityDesc=node.text
				obj.Entity=node.id
				obj.radioVal=$("input[name='type']:checked").val()
				obj.gridScreeningLoad()
				$("#btnAdd").linkbutton('enable');
				$("#btnEdit").linkbutton('disable');
				$("#btnDelete").linkbutton('disable');
				$("#SuspScreening").datagrid('clearSelections');
			}else{
				obj.gridScreening.loadData({"rows":[]});
			}
		}
	})

	obj.gridScreening = $HUI.treegrid("#SuspScreening",{
		fit: true,
		title:'病种指标维护',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		idField:'RowId',           //关键字段来标识树节点，不能重复  
		treeField:'title', //树节点字段，也就是树节点的名称
		loadMsg:'数据加载中...',
		nowrap:true,
		fitColumns: true,
		columns:[[
			{field:'title',title:'指标名称',width:100},
			{field:'field',title:'指标字段',width:50,align:'center'},
			{field:'headertype',title:'指标类型',width:50,align:'center',
			formatter: function(value,row,index){
					if (row.headertype==1) {
						return "父指标";
					}else {
						return "末级指标";
					}
				}
			},
			{field:'sort',title:'序号',width:30,align:'center'},
			{field:'active',title:'是否有效',width:30,align:'center',
				formatter: function(value,row,index){
					if (row.active==1) {
						return "是";
					}else {
						return "否";
					}
				}
			},
			{field:'expander',title:'操作',width:30,align:'center',
				formatter: function(value,row,index){
					if((row.headertype==0)&&(row.field.indexOf("field")>-1)){
						return '<a href="#" class="icon-search" onclick="obj.InitDialogItem(\'' + row.ID + '\',\'' + row.title +  '\');" data-options="plain:true" >&nbsp;&nbsp;&nbsp;&nbsp;</a>';
					}else{
						return "";
					}
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.optionID = rowData["ID"];
				//obj.gridScreening_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if (rowIndex>-1) {
				obj.gridScreening_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	});

	obj.gridQCItem = $HUI.datagrid("#gridQCItem",{
		singleSelect: false,
		autoRowHeight: false,
		rownumbers:true, 
		loadMsg:'数据加载中...',
	    url:$URL,
	    height:400,
	    nowrap:false,
		columns:[[
			{field:'ItemId',title:'项目',width:'280',
			formatter:function(v,r){					
					return r.ItemDesc
			},
			editor:{
				type:'combobox',
				options:{
					mode:'remote',
					url:$URL,
					selectOnNavigation:true,
					valueField:'BTID',
					textField:'BTDesc',
					onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作	
						var Input=$(this).combobox('getText');
						if (Input=="") {
							var rowData = obj.gridQCItem.getSelected();
							Input=rowData.ItemDesc
							Input=Input.split('[')[0]
							Input=Input.split('(')[0]
						}
	                 	if (Input.length<2) return;				                 	
						param.ClassName = 'DHCMA.CPW.SDS.QCEntityItemSrv';
						param.QueryName = 'QryQCEntityItem';
						param.ResultSetType = 'Array';
						param.aKey = Input;
						param.aParRef = obj.Entity;
					}
				}
			}
			},
			{field:'ItemAbbrev',title:'项目代码',width:'120',
				editor:{
						type:'text'
				}
			},
		]]
		,onClickRow:function(index,rowData){
			$("#btnAddItem").linkbutton('enable');
			$("#btnDeleteItem").linkbutton('enable');
			$('#gridQCItem').datagrid('selectRow', index).datagrid('beginEdit', index);;
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				$('#txtIndexExp2').val(rowData.indexExp)
			}
		}
	});
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}

