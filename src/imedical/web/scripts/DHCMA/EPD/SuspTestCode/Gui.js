//页面Gui
function InitSuspTestCodeWin(){
	var obj = new Object();		
    obj.RecRowID1 = '';
	obj.RecRowID2 = '';
	obj.RecRowID = '';
    $.parser.parse(); // 解析整个页面  
 
    obj.girdTestCode = $HUI.datagrid("#girdTestCode",{
		fit: true,
		title:'传染病疑似检验项目',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:'DHCMed.EPDService.SuspTestCodeSrv',
			QueryName:'QryTestCode'
	    },
		columns:[[
			{field:'BTCode',title:'项目代码',width:80},
			{field:'BTDesc',title:'项目名称',width:240},
			{field:'BTNote',title:'说明',width:210}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.girdTestCode_onSelect();
				obj.RecRowID=rowData.ID;
				obj.girdTestCodeExt.reload();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.girdTestCode_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
    
	obj.girdTestCodeExt = $HUI.datagrid("#girdTestCodeExt",{
		fit: true,
		title:'检验项目',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:'DHCMed.EPDService.SuspTestCodeSrv',
			QueryName:'QryTestCodeExt'
	    },
		columns:[[
			{field:'TestCode',title:'检验ID',width:80},
			{field:'TCCode',title:'检验代码',width:80},
			{field:'TestDesc',title:'检验名称',width:120},
			{field:'SpecCode',title:'标本代码',width:80},
			{field:'SpecDesc',title:'标本名称',width:100},
			{field:'ResultTypeDesc',title:'结果类型',width:80},
			{field:'ResultUnit',title:'结果单位',width:80},
			{field:'CompValueMax',title:'最大比较值',width:80},
			{field:'CompValueMin',title:'最小比较值',width:80},
			{field:'CompValues',title:'结果比较值',width:120},
			{field:'PatSexDesc',title:'性别',width:120},
			{field:'IsActDesc',title:'有效标志',width:80}, 
			{field:'ActDate',title:'更新日期',width:100},
			{field:'ActTime',title:'更新时间',width:80},
			{field:'ActUser',title:'更新用户',width:120}
		]],
		onBeforeLoad: function (param) {
			param.aTestID = obj.RecRowID1;
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.girdTestCodeExt_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.girdTestCodeExt_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			if (!obj.RecRowID1) {
				$("#btnExtAdd").linkbutton("disable");
			}else {
				$("#btnExtAdd").linkbutton("enable");
			}
			$("#btnExtEdit").linkbutton("disable");
			$("#btnExtDelete").linkbutton("disable");
		}
	});
		
	//检验医嘱
	obj.cbgTestSet = $('#cbgTestSet').lookup({
		width:260,
		panelWidth:600,
		url:$URL+"?ClassName=DHCMA.Util.EPS.TestSetSrv&QueryName=QryTestSet&aIsActive=1", 
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		idField: 'ID',
		textField: 'BTDesc',
		columns: [[
			{field:'OID',title:'医嘱ID',width:100},
			{field:'BTCode',title:'医嘱代码',width:100},
			{field:'BTDesc',title:'医嘱名称',width:240},
			{field:'BTCode2',title:'医嘱代码2',width:120},
			{field:'BTDesc2',title:'医嘱名称2',width:240}
		]],
		pagination:true,
		onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;        
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
	    },
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.RecRowID=rowData.ID;
				obj.TestCodeLoad();
			}
		},
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:0            //isCombo为true时，可以搜索要求的字符最小长度
		
	});

	obj.TestCodeLoad = function() {
		//检验项目
		obj.cbgTestCode = $('#cbgTestCode').lookup({
			width:260,
			panelWidth:600,
			url:$URL+"?ClassName=DHCMA.Util.EPS.TestSetSrv&QueryName=QryTestCodeByTS&aTSID="+obj.RecRowID, 
			editable: true,
			mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
			idField: 'OID',
			textField: 'BTDesc',
			columns: [[
				{field:'OID',title:'检验项目ID',width:100},
				{field:'BTCode',title:'检验项目代码',width:100},
				{field:'BTDesc',title:'检验项目名称',width:200},
				{field:'RstFormat',title:'结果类型',width:80}
			]],
			onBeforeLoad:function(param){
				var desc=param['q'];
				if (obj.RecRowID==""){
					$.messager.popover({msg: '请选择检验医嘱！',type:'error',timeout: 1000});
					return
				}
				//if (desc=="") return false; //修复bug 876856 下拉选择时,8.3+版本 为空，8.3以下版本为undefined  
				param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
			},
			
			pagination:true,
			loadMsg:'正在查询',	
			isCombo:true,             //是否输入字符即触发事件，进行搜索
			minQueryLen:0             //isCombo为true时，可以搜索要求的字符最小长度
		});
	}
	obj.TestCodeLoad();
	//送检标本
	obj.cbgSpecimen = $('#cbgSpecimen').lookup({
		width:260,
		panelWidth:600,
		url:$URL+"?ClassName=DHCMA.Util.EPS.SpecimenSrv&QueryName=QrySpecimen&aIsActive=1", 
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		idField: 'OID',
		textField: 'BTDesc',
		columns: [[
			{field:'OID',title:'标本ID',width:100},
			{field:'BTCode',title:'标本代码',width:100},
			{field:'BTDesc',title:'标本名称',width:200}
		]],
		onBeforeLoad:function(param){
			var desc=param['q'];
			//if (desc=="") return false;  //修复bug 876856 下拉选择时,8.3+版本 为空，8.3以下版本为undefined        
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
		},
		
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:0             //isCombo为true时，可以搜索要求的字符最小长度
	
	});
	
	//结果类型
	$('#cboResultType').combobox({      
		valueField:'Code',    
		textField:'Desc',  //K,I,L,R
		data : [{
			Code:'N', 
			Desc:'数值'
		},{
			Code:'L', 
			Desc:'列表'
		}, {
			Code:'K', 
			Desc:'关键词'
		}]
	});  
	obj.cboPatSex =Common_ComboDicCode("cboPatSex","EPDPetSex");  
	
	InitSuspTestCodeWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


