//加载页面
$(function () {
	InitBactAntiIntWin(); 
});

//页面Gui
function InitBactAntiIntWin(){
	var obj = new Object();
    obj.RecRowID = '';	
  	obj.BacteriaID ='';
	obj.AntibioticID ='';
    obj.gridBactAntiInt = $HUI.datagrid("#BactAntiInt",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:'DHCHAI.DPS.LabBactAntiIntSrv',
			QueryName:'QryBactAntiInt',
			aKeyDesc:''
	    },
		columns:[[
			{field:'ID',title:'ID',width:80},
			{field:'BactDesc',title:'细菌名称',width:200,sortable:true},
			{field:'AntDesc',title:'抗生素',width:200,sortable:true},
			{field:'IsActDesc',title:'是否有效',width:100},
			{field:'Note',title:'备注',width:200},
			{field:'ActDate',title:'更新日期',width:100},
			{field:'ActTime',title:'更新时间',width:100}	
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridBactAntiInt_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridBactAntiInt_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	obj.cboBact = $HUI.lookup("#cboBact", {
		panelWidth:450,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		isValid:true,
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:1,             //isCombo为true时，可以搜索要求的字符最小长度
		valueField: 'ID',
		textField: 'BacDesc',
		queryParams:{ClassName: 'DHCHAI.DPS.LabBactSrv',QueryName: 'QryLabBacteria'},
		columns:[[  
			{field:'BacCode',title:'代码',width:80},   
			{field:'BacDesc',title:'病原体名称',width:180},
			{field:'BacName',title:'英文名称',width:160}			
		]],
		onBeforeLoad:function(param){
			var desc=param['q'];
			//if (desc=="") return false;  				
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
		},
		onSelect:function(index,rowData){  
			obj.BacteriaID = rowData['ID'];			
		}
	});

	obj.cboAnti = $HUI.lookup("#cboAnti", {
		panelWidth:450,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		isValid:true,
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:1,             //isCombo为true时，可以搜索要求的字符最小长度
		valueField: 'ID',
		textField: 'AntDesc',
		queryParams:{ClassName: 'DHCHAI.DPS.LabAntiSrv',QueryName: 'QryLabAntibiotic'},
		columns:[[  
			{field:'AntCode',title:'抗生素代码',width:120},   
			{field:'AntDesc',title:'抗生素名称',width:260}			
		]],
		onBeforeLoad:function(param){
			var desc=param['q'];
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
		},
		onSelect:function(index,rowData){  
			obj.AntibioticID = rowData['ID'];			
		}
	});
	
	InitBactAntiIntWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


