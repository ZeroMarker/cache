//页面Gui
function InitEnviHyObjectWin(){
	var obj = new Object();
	obj.RecRowID = "";
	$.parser.parse(); // 解析整个页面
	
	//监测对象列表
	obj.gridEvObject = $HUI.datagrid("#gridEvObject",{
		fit: true,
		title: "环境卫生监测对象维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false,//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		fitColumns:true,
		loadMsg:'数据加载中...',
		nowrap:false,
		//分组
		showGroup: true,
		checkOnSelect:false,
		groupField:'Mod',
		pageSize: 10,
		pageList : [10,20,50,100],
		url:$URL,
		groupField:'Mod',
		groupFormatter:function(value, rows){
			if(value==undefined) return;
			return value;
		},
		queryParams:{
			ClassName:"DHCHAI.IRS.EnviHyObjectSrv",
			QueryName:"QryEvObject"

		},
		columns:[[
			{field:'ID',title:'ID',width:100},
			{field:'ObjectDesc',title:'对象名称',width:220,sortable:true},
			{field:'ObjectDesc2',title:'对象别名',width:150,sortable:true},
			{field:'LocDesc',title:'对象科室',width:150,sortable:true},
			{field:'SpecimenTypeDesc',title:'标本类型',width:280,sortable:true},
			{field:'HospDesc',title:'关联院区',width:180,sortable:true,
				formatter:function(v){
					if (v=="") {
						return "全部院区";
					}else{
						return v
					}
				}
			},
			{field:'IsActDesc',title:'是否有效',width:80}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridEvObject_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridEvObject_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//标本类型
	obj.SpecimenType = Common_ComboDicID('cboSpecimenType','EHSpenType');
	
	//关联院区
	obj.cboHospital=$HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospital&ResultSetType=Array',
		valueField:'ID',
		textField:'BTDesc'
	})
	//对象特指科室
	obj.cboObjLoc=$HUI.combobox("#cboObjLoc",{
		url:$URL+'?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLoc&ResultSetType=Array&aHospIDs=',
		valueField:'ID',
		textField:'LocDesc2'
	})
	InitEnviHyObjectWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
	
	
}