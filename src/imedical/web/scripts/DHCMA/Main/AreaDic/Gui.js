//页面Gui
function  InitAreaDicWin(){
	var obj=new Object();
	obj.ParentId = "";
	obj.Select=0;
	$.parser.parse();//解析界面
	
	obj.gripAreaDic = $HUI.datagrid("#gridAreaDic",{
		fit:true,
		title:"省市县乡维护",
		headerCls:'panel-header-gray',
		iconCls:"icon-resort",
		pagination:true, 			//分页工具栏
		rownumbers:false,            // 行号
		singleSelect:true,
		autoRowHeight:false,        //行高是否自动扩展
		loadMsg:"数据加载中...",
		pageSize:10,
		pageList:[10,20,50,100],
		url:$URL,
		queryParams:{
			ClassName:"DHCMed.SSService.AreaDicSrv",
			QueryName:"QryAreaDic",
			aParentID:obj.ParentId,
			//aIsActive:"1"     //1或者0
		},
		columns:[[
			{field:'RowID',title:'ID',width:100},
			{field:'Code',title:'代码',width:160},
			{field:'ShortDesc',title:'名称',width:200},
			{field:'LongDesc',title:'全名',width:400},
			{field:'IsActiveDesc',title:'是否有效',width:200},
		]],
		/*onSelect:function(rowIndex,RowData){
			if(rowIndex>-1){
				if(obj.Select!=1){obj.Select=1}else{obj.Select=0}
				console.log(obj.Select)
			}
		},*/
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridAreaDic_onDblClickRow(rowData);
			}
		}
		
	});
	//省市县乡公共方法
	function ComboToArea() {
		var ItemCode = arguments[0];
		var lnkLocCmp = arguments[1];
		var cbox = $HUI.combobox("#"+ItemCode, {
			url: $URL,
			editable: true,
			valueField: 'RowID',
			textField: 'ShortDesc',
			onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
				param.ClassName = 'DHCMed.SSService.AreaDicSrv';
				param.QueryName = 'QryAreaDic';
				param.aParentID = (lnkLocCmp != "1" ? $('#'+lnkLocCmp).combobox('getValue') : 1);
				param.ResultSetType = 'array';
				
			},	
			onSelect:function(info){
				obj.ParentId = info["RowID"];
				var param=$("#gridAreaDic").datagrid("options").queryParams;
				param.aParentID=obj.ParentId;
				$("#gridAreaDic").datagrid("reload");
				
			},	 
			filter: function(q, row){
				return (row["ShortDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);  //toUpperCase  转换大写  indexOf 返回首次出现的位置
			}
		});			
	}
	//省
	obj.cboProvince = ComboToArea("cboProvince","1");
	//市
	$HUI.combobox('#cboProvince',{
		onChange:function(newValue,oldValue){
			if(!newValue){
				obj.ParentId = "";
				var param=$("#gridAreaDic").datagrid("options").queryParams;
				param.aParentID=obj.ParentId;
				$("#gridAreaDic").datagrid("reload");
			}
			$("#cboCity").combobox('clear');
			$("#cboCounty").combobox('clear');
			$('#cboCounty').combobox('loadData', {});
			obj.cboCity =ComboToArea("cboCity","cboProvince");	
		}
	});
	//县
    $HUI.combobox("#cboCity",{
		onChange:function(newValue,oldValue){
			if(!newValue){
				obj.ParentId = $("#cboProvince").combobox('getValue');;
				var param=$("#gridAreaDic").datagrid("options").queryParams;
				param.aParentID=obj.ParentId;
				$("#gridAreaDic").datagrid("reload");
			}
			$("#cboCounty").combobox('clear');
			obj.cboCounty=ComboToArea("cboCounty","cboCity");
		}
	});
	$HUI.combobox("#cboCounty",{
		onChange:function(newValue,oldValue){
			if(!newValue){
				obj.ParentId = $("#cboCity").combobox('getValue');;
				var param=$("#gridAreaDic").datagrid("options").queryParams;
				param.aParentID=obj.ParentId;
				$("#gridAreaDic").datagrid("reload");
			}
		}
	});
	InitAreaDicWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
	
}



