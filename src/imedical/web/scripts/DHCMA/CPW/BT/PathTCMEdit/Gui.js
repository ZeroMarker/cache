//页面Gui
function InitPathTCMListWin(){
	var obj = new Object();
	obj.RecRowID1 = "";
	obj.RecRowID2 = "";	
	obj.RecRowID3 = "";	
    $.parser.parse(); // 解析整个页面 	
	
	$HUI.combobox("#comArcResume",{
				url:$URL+"?ClassName=DHCMA.CPW.BTS.PathTCMExtSrv&QueryName=QryDocConfig&ResultSetType=array",
				valueField:'ID',
				textField:'DocConfigDesc'
	});	
	
	obj.gridPathTCM = $HUI.datagrid("#gridPathTCM",{
		fit: true,
		title: "中药方剂",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathTCMSrv",
			QueryName:"QryPathTCM"
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'50'},
			{field:'BTCode',title:'代码',width:'80',sortable:'true'},
			{field:'BTDesc',title:'名称',width:'150'},
			{field:'BTIsActive',title:'是否有效',width:'80'},
			//{field:'BTActDate',title:'处置日期',width:'100'},
			//{field:'BTActTime',title:'处置时间',width:'100'},
			{field:'BTActUserDesc',title:'处置人',width:'125'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {		
				obj.gridPathTCM_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathTCM_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnPathTCMOSAdd").linkbutton("disable");
			$("#btnPathTCMOSDel").linkbutton("disable");
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
		}
	});
	
	obj.gridPathTCMOS = $HUI.datagrid("#gridPathTCMOS",{
		fit: true,
		//title: "中药方剂-协定处方维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		//singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.LinkArcimSrv",
			QueryName:"QryPathTCMOS",
			aPathTCMDr:obj.RecRowID1
		},
		columns:[[
			{field:'TCMOSDr',title:'ID',sortable:true,width:60},
			//{field:'ARCOSID',title:'ID',sortable:true,width:60},
			{field:'ARCOSCode',title:'代码',sortable:true,width:150},
			{field:'ARCOSDesc',title:'名称',sortable:true,width:240}
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
		onClickRow:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPathTCMOS_onClickRow();
			}
		},
		onLoadSuccess:function(data){
		    if($("#btnAdd").hasClass("l-btn-disabled")){
				$("#btnPathTCMOSAdd").linkbutton("enable");
			}else{
				$("#btnPathTCMOSAdd").linkbutton("disable");
			}
			$("#btnPathTCMOSDel").linkbutton("disable");
			$("#btnPathTCMOSDel").linkbutton("disable");
		}
	});
	
	obj.gridTCMOSList = $HUI.datagrid("#gridTCMOSList",{
		fit: true,
		//title: "中药方剂-协定处方维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		//singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.LinkArcimSrv",
			QueryName:"QryTCMOSByAlias"
		},
		columns:[[
			{field:null,title:'选择',checkbox:'true',align:'center',width:40,auto:false},
			//{field:'ARCOSID',title:'ID',sortable:true,width:60},
			{field:'ARCOSCode',title:'代码',sortable:true,width:150},
			{field:'ARCOSDesc',title:'名称',sortable:true,width:240}
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		}
	});
	
    obj.gridPathTCMExt = $HUI.datagrid("#gridPathTCMExt",{
		fit: true,
		//title: "中药方剂-君臣佐使维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathTCMExtSrv",
			QueryName:"QryPathTCMExt",
			aParRef:obj.RecRowID1
	    },
		columns:[[
			{field:'BTSID',title:'ID',width:'60'},
			{field:'BTOrdMastID',title:'医嘱项',width:'150'},
			{field:'BTTypeDesc',title:'类型',width:'60'},
			{field:'DoseQty',title:'计量',width:'60'},
			{field:'CTUnit',title:'单位',width:'60'},
			{field:'SPriority',title:'备用',width:'60'},
			{field:'ArcResumeDesc',title:'备注',width:'60'},
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
				obj.gridPathTCMExt_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathTCMExt_onDbSelect(rowData);
			}
		},
		onLoadSuccess:function(data){
		    if($("#btnAdd").hasClass("l-btn-disabled")){
				$("#btnSubAdd").linkbutton("enable");
			}else{
				$("#btnSubAdd").linkbutton("disable");
			}
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
		}
	});
	//医嘱项选择
	$("#txtOrdMastID").lookup({
		width:267,
		panelWidth:450,
		url:$URL+"?ClassName=DHCMA.CPW.BTS.PathTCMExtSrv&QueryName=QryArcimByAliasAndItemCat&aHospID="+session['DHCMA.HOSPID'],  //江苏省中医院要求中药饮片分类医嘱查询
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		idField:'ArcimID',
		textField:'ArcimDesc',
		columns:[[  
			{field:'ArcimCode',title:'代码',width:120},  
			{field:'ArcimDesc',title:'描述',width:240},  
			{field:'ArcimID',title:'ID',width:80}  
		]],
		/*
		onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;        
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
	    },*/
		onSelect:function(index,rowData){
			obj.CTUnit(rowData);
			 var ArcimDesc=rowData['ArcimDesc'];
			 if (ArcimDesc) {
				$("#txtOrdMastID").val(ArcimDesc);            //赋值
			 }
		},
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:2             //isCombo为true时，可以搜索要求的字符最小长度
	});
	//类型-君臣佐使加载
	obj.cboTypeDr= $HUI.combobox('#cboTypeDr', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.DictionarySrv';
			param.QueryName = 'QryDictByType';
			param.ResultSetType = 'array';
			param.aTypeCode = 'CPWTCMOrdType'
		}
	});
	
	InitPathTCMListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


