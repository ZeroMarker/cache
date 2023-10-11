//页面Gui
var obj = new Object();
function InitHISUIWin(){
	
	$.parser.parse(); // 解析整个页面  
	
	//搜索框
	$('#txtSearch').searchbox({ 
		searcher:function(value,name){
			obj.gridKBase.load({
				ClassName:"DHCMA.CPW.KBS.PathBaseSrv",
				QueryName:"QryPBase",
				q:value
			});
		}, 
		prompt:'请输入路径名称' 
	});

	obj.gridKBase = $HUI.datagrid("#gridKBase",{
		url:$URL,
		fit: true,
		queryParams:{
			ClassName:"DHCMA.CPW.KBS.PathBaseSrv",
			QueryName:"QryPBase"
		}, //允许多选
		singleSelect: true,
		columns:[[			
			{field:'BTCode',title:'序号',sortable:true,width:130},
			{field:'BTDesc',title:'路径名称',sortable:true,width:220},
			{field:'BTType',title:'专科类型',sortable:true,width:130},
			{field:'BTAdmType',title:'是否门诊路径',sortable:true,width:100},
			{field:'BTIsOper',title:'是否手术路径',sortable:true,width:100},
			{field:'BTYear',title:'发布年份',sortable:true,width:100},
			{field:'BTPubType',title:'版本类型',sortable:true,width:80},
			{field:'BTPDFPath',title:'文件路径',sortable:true,width:200},
			{field:'BTIsActive',title:'是否启用',sortable:true,width:80},
						{title:'查看文件',width:80,field:'expander',align:'center',
				formatter: function(value,row,index){
					//var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					var btn = '<a href="#" class="btn_detail" onclick="obj.OpenPdf(\'' + row.BTPDFPath +  '\')"></a>';
					return btn;
				}
			}		
		]],		
		onLoadSuccess:function(data){
		},
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: 200,
		pageList : [10,20,50,100,200]
	});	
	//导入表单窗口
	$('#winImportPath').dialog({
		title:"导入表单",
		closed: true,
		iconCls:'icon-w-save',
		modal: true,
		center:true,
		width:'1280',
		onBeforeClose:function(){
			$('#file').filebox('clear');
			$('#gridKBase').datagrid('reload');
		}
	});
	//obj.DefHospOID = $cm({ClassName:"DHCMA.Util.IO.MultiHospInterface",MethodName:"GetDefaultHosp",aTableName:"DHCMA_CPW_KB.PathBase",aHospID:session['LOGON.HOSPID'],dataType:'text'},false);
	obj.DefHospOID = session['LOGON.HOSPID'];
	$('#file').filebox({
		width: 1060,
		prompt: 'excel文件：*.xls,*.xlsx',
		buttonText: '选择',
		buttonAlign: 'right',
		plain: true,
		multiple:true,
		accept:'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
		onChange:function(newVal,oldVal){
			if(newVal) $("#btnSaveTmp").linkbutton("enable");
		}
	})
	$("#btnSaveTmp").linkbutton("disable");
	$("#btnSave").linkbutton("disable");	
	$("#btnDelTmp").linkbutton("disable");
	obj.admitList = $HUI.datagrid("#admitList",{
		url:$URL,
		fit: true,
		queryParams:{
			ClassName:"DHCMA.CPW.KBS.ImportPathWay",
			QueryName:"QryTempFormData",
			argHospID:obj.DefHospOID
		}, //允许多选
		singleSelect: false,
		//设置复选框和行的选择状态不同步
		checkOnSelect:true,
		selectOnCheck:false,
		onSelect:function(rowIndex,rowData){
			
		},
		onClickRow:function(){
			var Data = $('#admitList').datagrid('getChecked');
			if(Data==""){
				$("#btnSave").linkbutton("disable");	
				$("#btnDelTmp").linkbutton("disable");	
			}else{
				$("#btnSave").linkbutton("enable");	
				$("#btnDelTmp").linkbutton("enable");	
			}
		},
		onCheckAll:function(){
			$("#btnSave").linkbutton("enable");	
			$("#btnDelTmp").linkbutton("enable");		
		},
		onUncheckAll:function(){
			$("#btnSave").linkbutton("disable");	
			$("#btnDelTmp").linkbutton("disable");
		},
		columns:[[			
			{field:null,title:'选择',checkbox:'true',align:'center',width:30,auto:false},
			{field:'Code',title:'代码',sortable:true,width:150},
			{field:'Desc',title:'描述',sortable:true,width:200},			
			{field:'RowCount',title:'行数',sortable:true,width:80},
			{field:'Reminder',title:'温馨提示',sortable:true,width:300}					
		]],	
		onUncheck:function(){
			var Data = $('#admitList').datagrid('getChecked');
			if(Data==""){
				$("#btnSave").linkbutton("disable");	
				$("#btnDelTmp").linkbutton("disable");	
			}else{
				$("#btnSave").linkbutton("enable");	
				$("#btnDelTmp").linkbutton("enable");	
			}
		},	
		onCheck:function(rowIndex,rowData){
			var Data = $('#admitList').datagrid('getChecked');
			if(Data==""){
				$("#btnSave").linkbutton("disable");	
				$("#btnDelTmp").linkbutton("disable");	
			}else{
				$("#btnSave").linkbutton("enable");	
				$("#btnDelTmp").linkbutton("enable");	
			}
		},
		onLoadSuccess:function(data){
			$("#admitList").datagrid("unselectAll");
			$("#btnSave").linkbutton("disable");	
			$("#btnDelTmp").linkbutton("disable");	
		},
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: 200,
		pageList : [10,20,50,100,200]
	});	
	
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
