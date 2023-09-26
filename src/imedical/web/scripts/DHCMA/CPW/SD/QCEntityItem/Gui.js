//页面Gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	obj.ParrefID=""
    $.parser.parse(); // 解析整个页面 
    obj.gridQCEntity =$HUI.datagrid("#gridQCEntity",{
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false, 
		loadMsg:'数据加载中...',
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.QCEntitySrv",
			QueryName:"QryQCEntity"		
	    },
		columns:[[
			{field:'BTDesc',title:'病种名称',width:'250',sortable:true},
			{field:'BTCode',title:'编码',width:'150',sortable:true},
			{field:'BTAbbrev',title:'缩写',width:'150',sortable:true},
			{field:'BTIsActive',title:'是否有效',width:'150',align:'center'},
			{field:'BTIndNo',title:'排序码',width:'150',sortable:true},
			{field:'BTPubdate',title:'发布时间',width:'150'}
			//{field:'BTID',title:'RowID',hidden:true}	
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridQCEntity_onSelect(rowData);
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){			
				obj.gridQCEntity_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	$HUI.combobox("#GetDataParam",{
					})
	obj.BTType=$HUI.combobox("#BTType",{
				url:$URL+'?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&ResultSetType=Array&aTypeCode=SDType',
				valueField:'BTID',
				textField:'BTDesc',
				})
	obj.BTExpress=$HUI.combobox("#BTExpress",{
				url:$URL+'?ClassName=DHCMA.CPW.SDS.QCExpressSrv&QueryName=QryQCExpress&ResultSetType=Array&aExpType=GetValue',
				valueField:'BTID',
				textField:'BTDesc',
				})	
	obj.BTLinkItem=$HUI.combobox("#BTLinkItem",{
				url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntityItemSrv&QueryName=QryQCEntityItem&ResultSetType=Array',
				valueField:'BTID',
				textField:'BTDesc',
				})
	obj.BTUpType=$HUI.combobox("#BTUpType",{
				url:$URL+'?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&ResultSetType=Array&aTypeCode=SDUpType',
				valueField:'BTID',
				textField:'BTDesc',
				})		 
	obj.gridQCEntityItem = $HUI.datagrid("#gridQCEntityItem",{
		fit:true,
		title: "质控项目维护",
		iconCls:"icon-template",
		toolbar:'#custtb',
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		fitColumns:false,
		striped:true,
		rownumbers:true, 
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,50],
	    url:$URL,
	    nowrap:false,
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
			QueryName:"QryQCEntityItem"				
	    },
		columns:[[	
			{field:'BTCode',title:'代码',width:'150',sortable:true},
			{field:'BTDesc',title:'描述',width:'180',sortable:true},
			{field:'BTTypeDesc',title:'类型',width:'80',align:'center'},
			{field:'BTUpTypeDesc',title:'上传类型',width:'80',align:'center'},
			{field:'BTIndNo',title:'序号',width:'50',sortable:true},
			{field:'BTItemCat',title:'项目大类',width:'180',align:'center'},
			{field:'BTItemSubCat',title:'项目子类',width:'180',align:'center'},
			{field:'BTIsActive',title:'是否<br>有效',align:'center',width:'60',sortable:true},
			{field:'BTIsNeeded',title:'是否<br>必填',align:'center',width:'60',sortable:true},
			{field:'BTExpressCode',title:'取值表达式',width:'120',sortable:true},
			{field:'GetDataParam',title:'取值参数',width:'100',sortable:true},
			{field:'ValiRule',title:'校验规则',width:'100',sortable:true,align:'center',
				formatter: function(value,row,index){
						if (value!="") {
							return '<a href="#" class="hisui-linkbutton" onclick=objScreen.ShowItemRule("'+row.BTID+'")><span style="color:green;">查看</span></a>';
						}else{
							return '<a href="#" class="hisui-linkbutton" onclick=objScreen.ShowItemRule("'+row.BTID+'")>添加</a>';
						}
				}
			},
			{field:'BTLinkedItemDesc',title:'关联项目',width:'150',sortable:true},			
			{field:'BTTriggerCondition',title:'关联触<br>发条件',width:'60',sortable:true}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridQCEntityItem_onDbselect(rowData);
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridQCEntityItem_onSelect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


