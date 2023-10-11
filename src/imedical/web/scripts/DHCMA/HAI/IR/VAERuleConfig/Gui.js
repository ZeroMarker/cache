//页面Gui
function InitVAERuleConfigWin(obj){
	var obj = new Object();
	obj.RecRowID = "";	 //监测项目
	obj.ClickEventID = "";  //点击编辑框事件
	obj.RecSelctFlag = "";
	obj.gridMonitItem = $HUI.datagrid("#gridMonitItem",{
		fit: true,
		title: "监测项目维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true,
		rownumbers: false,
		singleSelect: true,
		autoRowHeight: false,
		nowrap:true,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	  	queryParams:{  
			ClassName : "DHCHAI.IRS.VAEMonitItemSrv",
			QueryName : "QueryMonitItem"
	    },		
		columns:[[
			{field:'ID',title:'ID',width:40},
			{field:'VAItmCode',title:'项目代码',width:80},
			{field:'VAItmDesc',title:'项目名称',width:120},
			{field:'VAIsActive',title:'是否有效',width:80}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMonitItem_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMonitItem_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//检出菌设置modal
	$('#BactEdit1').dialog({
		title:'检出菌设置病原体信息',
		iconCls:"icon-w-paper",
		closed: true,
		closeable: true,
		modal: true,
		onBeforeOpen:function(){
			$('#BactList1').datagrid({
		        fit:true,
		        headerCls:'panel-header-gray',
		        rownumbers:true,
		        striped:true,
		        singleSelect:false,
		        fitColumns:false,
		        pagination: true,
		        pageSize: 20,
				pageList : [20,50,100,200],
		        url:$URL,
		        bodyCls:'no-border',
		        queryParams:{
			        ClassName:'DHCHAI.IRS.VAERuleConfigSrv',
			        QueryName:'QryVAERuleBact',
			        aMonitItemDr:obj.RecRowID,
					aClickEventID:obj.ClickEventID
			    },
		        columns:[[
		        	{ field:'checked',checkbox:'true',align:'center',width:30},
		        	{ field:"BactDesc",title:"病原体",width:260},
					{ field:"DictionDesc",title:"类型",width:180}
		        ]]  
          	});
		}
	});
	//加载病原体信息
	obj.reloadBactInfo = function(){
		$("#BactList1").datagrid("loading");
		$cm ({
			ClassName:'DHCHAI.IRS.VAERuleConfigSrv',
			QueryName:'QryVAERuleBact',
			aMonitItemDr:obj.RecRowID,
			aClickEventID:obj.ClickEventID,
			page:1,
			rows:200
		},function(rs){
			$('#BactList1').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
	}
	//抗生素设置modal
	$('#AntiEdit1').dialog({
		title:'抗生素设置',
		iconCls:"icon-w-paper",
		closed: true,
		closeable: true,
		modal: true,
		onBeforeOpen:function(){
			$('#AntiList1').datagrid({
		        fit:true,
		        headerCls:'panel-header-gray',
		        rownumbers:true,
		        striped:true,
		        singleSelect:false,
		        fitColumns:false,
		        url:$URL,
		        pagination: true,
		        pageSize: 20,
				pageList : [20,50,100,200],
		        bodyCls:'no-border',
		        queryParams:{
			        ClassName:'DHCHAI.IRS.VAERuleConfigSrv',
			        QueryName:'QryVAERuleAnti',
					aMonitItemDr:obj.RecRowID,
					aClickEventID:obj.ClickEventID
			    },
		        columns:[[
		        	{ field:'checked',checkbox:'true',align:'center',width:30},
		        	{ field:"AntiDesc",title:"抗生素",width:260},
					{ field:"DictionDesc",title:"类型",width:180}
		        ]]  
          	});
		}
	});
	//加载抗生素信息
	obj.reloadAntiInfo = function(){
		$("#AntiList1").datagrid("loading");
		$cm ({
			ClassName:'DHCHAI.IRS.VAERuleConfigSrv',
			QueryName:'QryVAERuleAnti',
			aMonitItemDr:obj.RecRowID,
			aClickEventID:obj.ClickEventID,
			page:1,
			rows:200
		},function(rs){
			$('#AntiList1').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
	}
	//标本设置modal
	$('#SpecEdit1').dialog({
		title:'标本设置',
		iconCls:"icon-w-paper",
		closed: true,
		closeable: true,
		modal: true,
		onBeforeOpen:function(){
			$('#SpecList1').datagrid({
		        fit:true,
		        headerCls:'panel-header-gray',
		        rownumbers:true,
		        striped:true,
		        singleSelect:false,
		        fitColumns:false,
		        url:$URL,
		        pagination: true,
		        pageSize: 20,
				pageList : [20,50,100,200],
		        bodyCls:'no-border',
		        queryParams:{
			        ClassName:'DHCHAI.IRS.VAERuleConfigSrv',
			        QueryName:'QryVAERuleSpec',
					aMonitItemDr:obj.RecRowID,
					aClickEventID:obj.ClickEventID
			    },
		        columns:[[
		        	{ field:'checked',checkbox:'true',align:'center',width:30},
		        	{ field:"SpecDesc",title:"标本",width:260},
					{ field:"DictionDesc",title:"类型",width:180}
		        ]]  
          	});
		}
	});
	//加载标本信息
	obj.reloadSpecInfo = function(){
		$("#SpecList1").datagrid("loading");
		$cm ({
			ClassName:'DHCHAI.IRS.VAERuleConfigSrv',
			QueryName:'QryVAERuleSpec',
			aMonitItemDr:obj.RecRowID,
			aClickEventID:obj.ClickEventID,
			page:1,
			rows:200
		},function(rs){
			$('#SpecList1').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
	}
	//检验医嘱设置modal
	$('#LabOEEdit1').dialog({
		title:'检验医嘱设置',
		iconCls:"icon-w-paper",
		closed: true,
		closeable: true,
		modal: true,
		onBeforeOpen:function(){
			$('#LabOEList1').datagrid({
		        fit:true,
		        headerCls:'panel-header-gray',
		        rownumbers:true,
		        striped:true,
		        singleSelect:false,
		        fitColumns:false,
		        url:$URL,
		        pagination: true,
		        pageSize: 20,
				pageList : [20,50,100,200],
		        bodyCls:'no-border',
		        queryParams:{
			        ClassName:'DHCHAI.IRS.VAERuleConfigSrv',
			        QueryName:'QryVAERuleLab',
			        aMonitItemDr:obj.RecRowID,
			        aClickEventID:obj.ClickEventID
			    },
		        columns:[[
		        	{ field:'checked',checkbox:'true',align:'center',width:30},
		        	{ field:"TestSetDesc",title:"检验医嘱",width:260},
					{ field:"DictionDesc",title:"类型",width:180}
		        ]]  
          	});
		}
	});
	//加载检验医嘱信息
	obj.reloadLabOEInfo = function(){
		$("#LabOEList1").datagrid("loading");
		$cm ({
			ClassName:'DHCHAI.IRS.VAERuleConfigSrv',
			QueryName:'QryVAERuleLab',
			aMonitItemDr:obj.RecRowID,
			aClickEventID:obj.ClickEventID,
			page:1,
			rows:200
		},function(rs){
			$('#LabOEList1').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
	}
	InitVAERuleConfigEvent(obj);
	obj.LoadEvent(arguments);
	$.parser.parse(); // 解析整个页面
	return obj;	
}
$(InitVAERuleConfigWin);