//页面Gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = new Object();
	obj.RecRowID1 = "";
	obj.RecRowID2 = "";	
    $.parser.parse(); // 解析整个页面 	
				 
	obj.gridPcEntity = $HUI.datagrid("#gridPcEntity",{
		fit:true,
		title: "付费病种维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false, 
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.PCEntitySrv",
			QueryName:"QryPCEntity"		
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'50'},
			{field:'BTCode',title:'病种编码',width:'80',sortable:true},
			{field:'BTDesc',title:'病种名称',width:'300',sortable:true},
			{field:'BTIsActive',title:'是否有效',width:'80',align:'center'},
			{field:'BTDiagnos',title:'主要诊断',width:'150',sortable:true},
			{field:'BTICD10',title:'ICD-10码',width:'100',sortable:true},
			{field:'BTOperation',title:'主要操作/治疗方式',width:'200',sortable:true},
			{field:'BTICD9CM',title:'CCHI码',width:'100',sortable:true},
			{field:'BTReferCost',title:'定额收费标准',width:'100',sortable:true},
			{field:'BTWarningCost',title:'预警费用',width:'100',sortable:true},
			{field:'BTHospitalDays',title:'最短住院日',width:'100',sortable:true},
			{field:'BTIntervalDays',title:'再入院间隔时间',width:'120',sortable:true}
			//{field:'BTID',title:'RowID',hidden:true}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {		
				obj.gridPcEntity_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPcEntity_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
		}
	});
    //项目分类下拉框
	obj.EntityCat = $HUI.combobox('#txtEntityCat', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'BTCode',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.SDS.PCItemCatSrv';
			param.QueryName = 'QryPCItemCat';
			param.ResultSetType = 'array';
		}
	});
	//项目阶段下拉框
	obj.EntityEpis = $HUI.combobox('#txtEntityEpis', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'BTCode',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.SDS.PCItemEpisSrv';
			param.QueryName = 'QryPCItemEpis';
			param.ResultSetType = 'array';
		}
	});
    obj.gridPcEntityItem = $HUI.datagrid("#gridPcEntityItem",{
		fit: true,
		title:'病种项目维护',
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: true, 
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.PCEntityItemSrv",
			QueryName:"QryPCEntityItem",
	    },
		columns:[[
			{field:'ChildID',title:'ID',width:'40'},
			{field:'BTDesc',title:'项目描述',width:'150',sortable:true},
			{field:'BTEpisDesc',title:'项目阶段',width:'80',sortable:true},
			{field:'BTCatDesc',title:'项目分类',width:'80',sortable:true},
			{field:'BTIsActive',title:'是否有效',width:'80',align:'center'},
			{field:'PriceDesc',title:'医疗服务价格',width:'200',sortable:true,
				formatter:function(value,row){
					if (value) {
						return '<a href="#" class="detail" onclick="objScreen.show(\''+row.BTRowID+'\');">'+value.replace(/,/g,'<br/>')+'</a>';
					} else {
						return '<a href="#" class="detail" onclick="objScreen.show(\''+row.BTRowID+'\');">无</a>';
					}
				}
			},
			{field:'BTRowID',title:'RowID',hidden:true},
			{field:'PriceCode',title:'PriceDesc',hidden:true}			
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPcEntityItem_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPcEntityItem_onDbSelect(rowData);
			}
		},
		onLoadSuccess:function(data){	
		    if($("#btnAdd").hasClass("l-btn-disabled")){
				$("#btnSubAdd").linkbutton("enable");
			}else{
				$("#btnSubAdd").linkbutton("disable");
			}
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
		}
	});
	objScreen.show = function(RowID){
		$('#DiaLog_three').window("open");
		obj.gridPriceMast =$HUI.datagrid("#gridPriceMast",{
			fit: true,
			//rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			autoRowHeight: false, 
			loadMsg:'数据加载中...',
			pageSize: 5,
			url:$URL,
			queryParams:{
				ClassName:"DHCMA.CPW.SDS.PCEntityPriceSrv",
				QueryName:"QryPCEntityPrice",
				aParRef:RowID
			},
			columns:[[
				{field:'ChildID',title:'ID',width:'40'},
				//{field:'BTPriceDesc',title:'价格描述',width:'180'},
				{field:'BTPriceCode',title:'价格描述',width:'370',sortable:true,               //弹出框中类型字段下拉框
					formatter:function(value,row){
							return row.BTPriceDesc;
					},
					editor:{
						type:'combobox',
						options:{
							url: $URL,
							editable: true,
							//multiple:true,  //多选
							//mode: 'remote',
							valueField: 'BTCode',
							required:true,
							textField:'BTDesc',
							onBeforeLoad: function (param) {
								param.ClassName = 'DHCMA.CPW.SDS.PCPriceMastSrv';
								param.QueryName = 'QryPriceMast';
								param.ResultSetType = 'array';
							}
							,filter:function(q,row){
								var opts = $(this).combobox('options');
								return (row[opts.textField].toUpperCase().indexOf(q.toUpperCase())>=0);
							}
						}
					},
				},
				//{field:'null',title:'备注',width:'190',editor:'text'},
				{field:'ID',title:'RowID',hidden:true}
			]],
			onDblClickRow:function(rindex,rowData1){
				obj.editHandler(rindex);
			}
		});
	}	
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


