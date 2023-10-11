//页面Gui
function InitCRuleAntiWin(){
	var obj = new Object();
	
	
	$HUI.combobox("#cboType",{
		data:[
			{value:'1',text:'全院',selected:true},
			{value:'2',text:'院区'},
			{value:'3',text:'科室'}
			
		],
		valueField:'value',
		textField:'text'
	})
	///加载科室
	$HUI.combobox("#cboLocation",{
		url:$URL+'?ClassName=DHCHAI.BTS.LocationSrv&QueryName=QryLoc&ResultSetType=Array&aHospIDs='+""+'&aAlias='+""+'&aLocCate='+"I|E"+'&aLocType='+"E"+'&aIsActive='+"1",
		valueField:'ID',
		textField:'LocDesc2',
		
	});
	///抗生素分类
	$HUI.combobox("#cboAntiCat",{
		url:$URL+'?ClassName=DHCHAI.DPS.OEAntiCatSrv&QueryName=QryOEAntiCat&ResultSetType=Array',
		valueField:'ID',
		textField:'BTDesc',
		
	});
	///抗菌用药
	$HUI.combobox("#cboAntiMast",{
		url:$URL+'?ClassName=DHCHAI.DPS.OEAntiMastSrv&QueryName=QryOEAntiMast&ResultSetType=Array',
		valueField:'ID',
		textField:'BTName',
		
	});
	//抗菌用药列表$HUI.datagrid   
	obj.gridCRuleAnti = $HUI.datagrid("#gridCRuleAnti",{
		fit: true,
		title: "",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		sortName:'ID',
		sortOrder:'asc',
		remoteSort:false,    //是否是服务器对数据排序
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100,200],
		columns:[[
			{field:'ID',title:'ID',width:50,sortable:true,align:'center'},
			{field:'Type',title:'类型',width:100,align:'center',
				formatter:function(value,row,index){
					 var Type = row["Type"];
					 switch(Type){
						case "1":
							return "全院";
							break;
						case "2":
							return "院区";
							break;
						case "3":
							return "科室";
							break;
						default:
							return "全院";
					}
			}}, 
			{field:'GrpDesc',title:'医院分组',width:150,align:'center'},
			{field:'HospDesc',title:'院区',width:200,sortable:true,align:'center'},
			{field:'LocDesc',title:'科室',width:200,align:'center'},
			{field:'AntiCatDesc',title:'抗生素分类',width:200,align:'center'},
			{field:'AntiMastDesc',title:'抗菌用药',width:200,align:'center'},
			{field:'IsActive',title:'是否有效',width:80,align:'center',
				formatter:function(value,row,index){
					 var IsActive = row["IsActive"];
					 return (IsActive == '1' ? '是' : '否');
			}}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				console.log(rowData);
				obj.gridCRuleAnti_onDbselect(rowData);	
									
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleAnti_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitCRuleAntiWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}