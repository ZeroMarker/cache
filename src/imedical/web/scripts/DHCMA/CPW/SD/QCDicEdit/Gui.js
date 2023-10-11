//页面Gui
function InitDicEditWin(){
	var obj = new Object();
	obj.DicID=""
	obj.TypeID=""
	obj.TypeCode=""
	obj.VerID="";
	obj.ItemID="";
    $.parser.parse(); // 解析整个页面 
	$('#ItemOptions').tree({
		url:$URL+"?ClassName=DHCMA.CPW.SDS.QCEntityItemSrv&QueryName=QryQCTree&ResultSetType=array"	
		,onLoadSuccess:function(node,data)
		{
			//回调
		},
		onExpand:function(node)
			{		
			},
		lines:true
	})
	$('#winDicType').dialog({
		title: '值域类型',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true
	});
	$('#winDictionary').dialog({
		title: '值域字典',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true
	});
	obj.QCVersion=$HUI.combobox("#QCVersion",{
		url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntityVersionSrv&QueryName=QryQCEntityVer&ResultSetType=Array',
		valueField:'BTID',
		textField:'BTCode',
		placeholder:'版本选择',
		onSelect:function(record){
			obj.gridDicType.load({
			    ClassName:"DHCMA.CPW.SDS.DicTypeSrv",
				QueryName:"QryDicType"	,
				aEntityID:obj.QCEntityID,
				aVersion:record.BTID	
				}
			) ;	
			obj.VerID=record.BTID;
			obj.gridDictionary.loadData([]);
		}
	})
	$("#btnAddT").linkbutton("disable");
	$("#btnEditT").linkbutton("disable");
	$("#btnAddD").linkbutton("disable");
	$("#btnEditD").linkbutton("disable");
 	//监听事件
	$('#ItemOptions').tree({
			onClick:function(node){		
				obj.QCEntityID=node.id;
				obj.QCEntityDesc=node.text;
				var CurVerID=$m({
					ClassName:'DHCMA.CPW.SDS.QCEntityVersionSrv',
					MethodName:'GetQCVerID',
					aQCID:node.id	
				},false)
				$("#btnAddT").linkbutton("enable");
				$("#btnEditT").linkbutton("disable");
				$("#btnAddD").linkbutton("disable");
				$("#btnEditD").linkbutton("disable");
				obj.QCVersion.clear();
				obj.QCVersion.select(CurVerID)
				obj.gridDictionary.loadData([]);
				$('#dicTKey').searchbox('setValue',"")
				$('#dicDKey').searchbox('setValue',"")
			}		
	})
	
	obj.gridDictionary = $HUI.datagrid("#gridDictionary",{
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		url:$URL,
		queryParams:{
						ClassName:"DHCMA.CPW.SDS.DictionarySrv",
						QueryName:"QryDictByType"
		},
		columns:[[
			{field:'BTCode',title:'字典代码',width:'80'},
			{field:'BTDesc',title:'字典名称',width:'200'}, 
			{field:'IsDefault',title:'默认项',width:'70',
			formatter:function(v,r,i){
				  if (r.IsDefault=="1") {
					  	return "是";
					}else{
						return "";
						}
				}
			}, 
			{field:'BTIsActive',title:'是否<br>有效',width:'50',
			formatter:function(v,r,i){
				  if (r.BTIsActive=="1") {
					  	return "是";
					}else{
						return "否";
						}
				}},
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridDictionary_edit(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridDictionary_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			//$("#btnAddD").linkbutton("disable");
			$("#btnEditD").linkbutton("disable");
		}
	});
	
	obj.gridDicType = $HUI.datagrid("#gridDicType",{
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
		url:$URL,
		nowrap:false,
		fitColumns:true,
		//displayMsg:'',
		queryParams:{
					ClassName:"DHCMA.CPW.SDS.DicTypeSrv",
					QueryName:"QryDicType",
					aEntityID:""	
		},
		columns:[[
			{field:'BTCode',title:'值域代码',width:'200'},
			{field:'BTDesc',title:'值域名称',width:'320'}, 
			{field:'BTIsActive',title:'是否有效',width:'70',
			formatter:function(v,r,i){
				  if (r.BTIsActive=="1") {
					  	return "是";
					}else{
						return "否";
						}
				}
			},
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridDicType_edit(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridDicType_onSelect(rowData,rindex);
				obj.TypeCode=rowData.BTCode
			}
		},
		onLoadSuccess:function(data){
			//$("#btnAddT").linkbutton("enable");
			$("#btnEditT").linkbutton("disable");
			$("#btnAddD").linkbutton("disable");
			obj.gridDictionary.loadData([]);
		}
	});
	
	InitDicEditWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


