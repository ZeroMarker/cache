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
	//医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			obj.cboLocation = Common_ComboToLoc("cboLocation",rec.ID,"","I","E");
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	$('#cboLocation').combobox({}); //联动表格需先初始化
	///加载科室
	/*$HUI.combobox("#cboLocation",{
		url:$URL+'?ClassName=DHCHAI.BTS.LocationSrv&QueryName=QryLoc&ResultSetType=Array&aHospIDs='+""+'&aAlias='+""+'&aLocCate='+"I|E"+'&aLocType='+"E"+'&aIsActive='+"1",
		valueField:'ID',
		textField:'LocDesc2',
		
	});*/

	//抗菌用药列表$HUI.datagrid   
	obj.gridCRuleLocArgs = $HUI.datagrid("#gridCRuleLocArgs",{
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
			{field:'ID',title:'ID',width:50,sortable:true},
			{field:'Type',title:'类型',width:100,
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
			{field:'GrpDesc',title:'医院分组',width:150,align:'left'},
			{field:'HospDesc',title:'院区',width:200,sortable:true,align:'left'},
			{field:'LocDesc',title:'科室',width:150,align:'left'},
			{field:'FeverMax',title:'体温上限',width:150,align:'left'},
			{field:'FeverMin',title:'体温下限',width:150,align:'left'},
			{field:'DiarrMin',title:'腹泻下限',width:150,align:'left'},
			{field:'DiarrMin2',title:'腹泻下限(儿童)',width:80,align:'left'},
			{field:'ActDate',title:'更新时间',width:120,align:'left',
			formatter:function(value,row,index){
					 var ActDate = row["ActDate"];
					 var ActTime = row["ActTime"];
					 return ActDate+""+ActTime;
			}},
			{field:'UserName',title:'更新人',width:80,align:'left'}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				console.log(rowData);
				obj.gridCRuleLocArgs_onDbselect(rowData);	
									
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCRuleLocArgs_onSelect(rowData,rindex);
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