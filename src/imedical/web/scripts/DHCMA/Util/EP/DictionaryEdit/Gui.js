//页面Gui
function InitDicEditWin(){
	var obj = new Object();
	obj.RecRowID= "";
	obj.RecTicTypeID=""
    $.parser.parse(); // 解析整个页面 
	
	//字典类型列表
	var runQuery =$cm({
		ClassName:'DHCMA.Util.EPS.DictionarySrv',
		QueryName:'QryHISDicType'
	},false);
	if(runQuery){
		$("#ulDicType").empty();
		var str="";
		var active="";
		var arrDT = runQuery.rows;
		for (var indDT = 0; indDT < arrDT.length; indDT++){
			var rd = arrDT[indDT];
			if (!rd) continue;
			
			if (!active){
				active = 1;
				$("#ulDicType").val(rd["BTID"]);
				console.log(rd["BTID"])
				str+='<li class="treeview active" value="' + rd["BTID"] + '">' + rd["BTDesc"] + '</li>';
				$("#gridDictionary").datagrid({title:'字典列表 ['+rd["BTDesc"]+']'});
			} else {
				str+='<li class="treeview" value="' + rd["BTID"] + '">' + rd["BTDesc"] + '</li>';
			}	
		}	
		$("#ulDicType").append(str)
	}
	
	//列表点击
	$('#ulDicType > li').click(function (e) {
		e.preventDefault();
		$('#ulDicType > li').removeClass('active');
		$(this).addClass('active');
		$('#ulDicType').val($(this).val());//全局存储，用于update 和reload
		var param=$("#gridDictionary").datagrid("options").queryParams;
		param.aTypeDr=$('#ulDicType').val()
		$("#gridDictionary").datagrid("reload");
		$("#gridDictionary").datagrid({title:'字典列表 ['+$(this).text() + ']'});
	});
	
	//表单加载
	obj.gridDictionary = $HUI.datagrid("#gridDictionary",{
		//title: "字典列表",
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
			ClassName:"DHCMA.Util.EPS.DictionarySrv",
			QueryName:"QryDicInfo",
			aTypeDr:$('#ulDicType').val()
	    },
		columns:[[
			{field:'ID',title:'ID',width:'50'},
			{field:'Code',title:'代码',width:'80'},
			{field:'Desc',title:'名称',width:'200'},
			{field:'RangeDesc',title:'对照字典',width:'175'},
			{field:'IsActive',title:'是否有效',width:'70'},
			{field:'ActDate',title:'处置日期',width:'120'},
			{field:'ActTime',title:'处置时间',width:'120'},
			{field:'ActUserDesc',title:'处置人',width:'80'}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridDictionary_onDbselect(rowData);
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridDictionary_onSelect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnEdit").linkbutton("disable");
			$("#btnTask").linkbutton("enable");
		}
	});
	
	//值域
	obj.cboRanger = $HUI.combobox('#cboRange', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选   
		mode: 'remote',
		valueField: 'OID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.EPS.DictionarySrv';
			param.QueryName = 'QryDicInfo';
			param.aTypeDr = $('#ulDicType').val();
			param.ResultSetType = 'array'
		}
	});
	
	InitDicEditWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


