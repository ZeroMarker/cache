//页面Gui
function InitHISUIWin(){
	var obj = new Object();
	$.parser.parse(); // 解析整个页面  
	
	$('#file').filebox({
		width: 800,
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
			ClassName:"DHCMA.CPW.BTS.ImportPathWay",
			QueryName:"QryTempFormData"
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
			$("#btnSave").linkbutton("disable");	
			$("#btnDelTmp").linkbutton("disable");	
		}
	});	
	
	
	
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
