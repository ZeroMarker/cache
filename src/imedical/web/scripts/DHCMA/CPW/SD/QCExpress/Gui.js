//页面Gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = new Object();
	obj.RecRowID1 = "";
	obj.RecRowID2 = "";
    $.parser.parse(); // 解析整个页面 	
	obj.BTType=$HUI.combobox("#BTType",{
				url:$URL+'?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&ResultSetType=Array&aTypeCode=SDEXPType',
				valueField:'BTID',
				textField:'BTDesc',
				panelHeight:'auto'
				})	
	obj.BTLevel=$HUI.combobox("#BTLevel",{
				valueField:'id',
				textField:'text',
				panelHeight:'auto',
				data:[	
						{id:'Error',text:'错误提示'},
						{id:'Warning',text:'警告提示'}
					]
				})
	$("#ExpType").keywords({
			    singleSelect:true,
			    items:[	       
			        {text:'取值表达式',id:'GetValue'},
			        {text:'入单表达式',id:'QCRule'},
			        {text:'检验表达式',id:'ValiRule'},
			         {text:'全部表达式',id:''}
				    ],
			    onClick:function(v){
					$("#gridQCExpress").datagrid("loadData", { total: 0, rows: [] });
				    obj.clearForm();
				    if (v.id=='ValiRule'){
						$('#BTLevel').combobox('enable');
						$('#gridQCExpress').datagrid({
							columns:[[
								{field:'BTCode',title:'代码',width:'80',sortable:true},
								{field:'BTDesc',title:'描述',width:'200',sortable:true},
								{field:'BTTypeDesc',title:'类型',width:'80',align:'center'},
								{field:'BTLevel',title:'级别',width:'80',align:'center',
									formatter:function(v,r,i){
										  if (v=="Error") {
											  	return "错误提示";
											}else if(v=="Warning"){
												return "警告提示";
											}else{
												return v
												}
										}
								},
								{field:'BTIsActive',title:'是否<br>有效',width:'60',sortable:true},
								{field:'BTExpress',title:'取值表达式',width:'300',sortable:true},
								{field:'BTExpressParam',title:'参数格式',width:'150',sortable:true},
								{field:'BTExpressTxt',title:'表达式说明',width:'200',sortable:true}
							]]
						})
					}else{
						$('#BTLevel').combobox('setValue','');
						$('#BTLevel').combobox('disable');
						$('#gridQCExpress').datagrid({
							columns:[[
								{field:'BTCode',title:'代码',width:'80',sortable:true},
								{field:'BTDesc',title:'描述',width:'200',sortable:true},
								{field:'BTTypeDesc',title:'类型',width:'80',align:'center'},
								{field:'BTIsActive',title:'是否<br>有效',width:'60',sortable:true},
								{field:'BTExpress',title:'取值表达式',width:'300',sortable:true},
								{field:'BTExpressParam',title:'参数格式',width:'150',sortable:true},
								{field:'BTExpressTxt',title:'表达式说明',width:'200',sortable:true}
							]]	
						})
			    	}
				    setTimeout(function(){			//延迟加载数据，等待列渲染
						obj.gridQCExpress.reload({
							ClassName:"DHCMA.CPW.SDS.QCExpressSrv",
							QueryName:"QryQCExpress",
							aExpType:v.id	
						})
					},20)
				    },
			    onUnselect:function(v){},
			    onSelect:function(v){
				    }
			});	 
	obj.gridQCExpress = $HUI.datagrid("#gridQCExpress",{
		fit:true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		striped:true,
		rownumbers:true, 
		loadMsg:'数据加载中...',
	    url:$URL,
	    bodyCls:'no-border',
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.QCExpressSrv",
			QueryName:"QryQCExpress",
			aExpType:"GetValue"		
	    },
		onSelect:function(rindex,rowData){
			if (rindex>-1) {		
				obj.gridQCExpress_onSelect(rowData);
			}
		},
		onDblClickRow:function(rowIndex,rowData){
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	$('#gridQCExpress').datagrid('getPanel').addClass('border:0px;')
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


