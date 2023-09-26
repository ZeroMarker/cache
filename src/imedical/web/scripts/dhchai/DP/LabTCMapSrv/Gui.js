//页面Gui
function InitLabTCMapWin(){
	var obj = new Object();
	obj.RecRowID1 = "";
	obj.RecRowID2 = "";
	obj.RecRowID3 = "";
	$.parser.parse(); // 解析整个页面 	
	
	obj.gridLabTCMap = $HUI.datagrid("#gridLabTCMap",{
			fit: true,
			title: "常规检验项目",
			iconCls:"icon-resort",
			headerCls:'panel-header-gray',
			pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
			//rownumbers: false, //如果为true, 则显示一个行号列
			singleSelect: true,
			autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			loadMsg:'数据加载中...',
			pageSize: 10,
			pageList : [10,20,50,100,200],
		    url:$URL,
		    queryParams:{
			    ClassName:"DHCHAI.DPS.LabTCMapSrv",
				QueryName:"QryLabTCMap"
		    },
			columns:[[
				{field:'ID',title:'ID',width:'50'},
				{field:'TestCode',title:'检验项目',width:'80',sortable:'true'},
				{field:'TestDesc',title:'项目名称',width:'150'},
				{field:'TestSetList',title:'检验医嘱',width:'300'},
				{field:'RstFormat',title:'结果类型',width:'80'},
				{field:'AbFlagS',title:'异常标记',width:'80'},
				{field:'HospGroup',title:'医院',width:'125'},
				{field:'IsActive',title:'是否有效',width:'90'}
			]],
			onSelect:function(rindex,rowData){
				if (rindex>-1) {		
					obj.gridLabTCMap_onSelect();
				}
			},
			onDblClickRow:function(rowIndex,rowData){
				if(rowIndex>-1){
					obj.gridLabTCMap_onDbselect(rowData);
				}
			},
			onLoadSuccess:function(data){
				//$("#btnEdit_one").hasClass("l-btn-disabled")
				//$("#btnEdit_one").linkbutton("disable");
				$("#btnEdit_two").linkbutton("disable");
				$("#btnEdit_three").linkbutton("disable");
				/* $("#btnsearch_one").linkbutton("disable");
				$("#btnsearch_two").linkbutton("disable");
				$("#btnsearch_three").linkbutton("disable"); */
			}
		});
		
		
		obj.gridLabTCMapRst = $HUI.datagrid("#gridLabTCMapRst",{
				fit: true,
				title: "检验项目结果",
				iconCls:"icon-resort",
				headerCls:'panel-header-gray',
				pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
				rownumbers: false, //如果为true, 则显示一个行号列
				singleSelect: true,
				autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
				loadMsg:'数据加载中...',
				pageSize: 10,
				pageList : [10,20,50,100,200],
				url:$URL,
				queryParams:{
					ClassName:"DHCHAI.DPS.LabTCMapSrv",
					QueryName:"QryMapRstByTC",
					aMapID:obj.RecRowID1
				},
				columns:[[
					{field:'TestRes',title:'定性结果',width:'150'},
					{field:'MapText',title:'标准结果',width:'150'},
					{field:'IsActive',title:'是否有效',width:'150'}
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
						obj.gridLabTCMapRst_onSelect();
						}
				},
				onDblClickRow:function(rowIndex,rowData){
					if(rowIndex>-1){
						obj.gridLabTCMapRst_onDbSelect(rowData);
					}
				},
				onLoadSuccess:function(data){
					//$("#btnEdit_two").hasClass("l-btn-disabled")
					//$("#btnEdit_two").linkbutton("disable");
					$("#btnEdit_three").linkbutton("disable");
					/*$("#btnsearch_one").linkbutton("disable");
					$("#btnsearch_two").linkbutton("disable");
					$("#btnsearch_three").linkbutton("disable"); */
				}
			});
			
			
			obj.gridLabTCMapAb = $HUI.datagrid("#gridLabTCMapAb",{
					fit: true,
					title: "检验项目定值结果",
					iconCls:"icon-resort",
					headerCls:'panel-header-gray',
					pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
					rownumbers: false, //如果为true, 则显示一个行号列
					singleSelect: true,
					autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
					loadMsg:'数据加载中...',
					pageSize: 10,
					pageList : [10,20,50,100,200],
				    url:$URL,
				    queryParams:{
					    ClassName:"DHCHAI.DPS.LabTCMapSrv",
						QueryName:"QryMapAbByTC",
						aMapID:obj.RecRowID1
				    },
					columns:[[
						{field:'AbFlag',title:'异常标志',width:'150'},
						{field:'MapText',title:'异常标志（H、L等）',width:'150'},
						{field:'IsActive',title:'是否有效',width:'150'},
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
							obj.gridLabTCMapAb_onSelect();
						}
					},
					onDblClickRow:function(rowIndex,rowData){
						if(rowIndex>-1){
							obj.gridLabTCMapAb_onDbSelect(rowData);
						}
					},
					onLoadSuccess:function(data){
					   //$("#btnEdit_two").hasClass("l-btn-disabled")
					   //$("#btnEdit_two").linkbutton("disable");
					   $("#btnEdit_three").linkbutton("disable");
					   /*$("#btnsearch_one").linkbutton("disable");
					   $("#btnsearch_two").linkbutton("disable");
					   $("#btnsearch_three").linkbutton("disable");*/
					}
				});
	
	
	// $("body").mCustomScrollbar({
	// 	theme: "dark-thick",
	// 	axis: "y",
	// 	scrollInertia: 100
	// });
	
	InitLabTCMapWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}