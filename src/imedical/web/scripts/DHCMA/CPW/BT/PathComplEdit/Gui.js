//页面Gui
function InitPathComplListWin(){
	var obj = new Object();
	obj.RecRowID = "";	
    $.parser.parse(); // 解析整个页面 
	
	//增加院区配置 add by yankai20210803
	var DefHospOID = $cm({ClassName:"DHCMA.Util.IO.MultiHospInterface",MethodName:"GetDefaultHosp",aTableName:"DHCMA_CPW_BT.PathCompl",aHospID:session['LOGON.HOSPID'],dataType:'text'},false);
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	obj.cboSSHosp = Common_ComboToSSHosp3("cboSSHosp","","","DHCMA_CPW_BT.PathCompl",SessionStr,"");
	$('#cboSSHosp').combobox({
  		onSelect: function(title,index){
	  		obj.gridPathCompl.load({
				ClassName:"DHCMA.CPW.BTS.PathComplSrv",
				QueryName:"QryPathCompl",
				aHospID: $("#cboSSHosp").combobox('getValue')
			});
	  	}
	 })
	var retMultiHospCfg = $m({
		ClassName:"DHCMA.Util.BT.Config",
		MethodName:"GetValueByCode",
		aCode:"SYSIsOpenMultiHospMode",
		aHospID:session['DHCMA.HOSPID']
	},false);
	if(retMultiHospCfg!="Y" && retMultiHospCfg!="1"){
		$("#layout").layout('panel',"north").hide();
		$("#layout").layout('panel',"center").panel({fit:true});		
		$("#layout").layout('resize');
		$("#layout").layout('panel',"center").parent().css({'top':'0'});	
	}
	
	obj.gridPathCompl = $HUI.datagrid("#gridPathCompl",{
		fit: true,
		title: "合并症病种维护",
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
		    ClassName:"DHCMA.CPW.BTS.PathComplSrv",
			QueryName:"QryPathCompl",
			aHospID: $("#cboSSHosp").combobox('getValue')
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'50',hidden:true},
			{field:'BTCode',title:'代码',width:'100',sortable:true},
			{field:'BTDesc',title:'名称',width:'350'}, 
			{field:'BTIsActiveDesc',title:'是否有效',width:'80'},
			{field:'BTActDate',title:'更新日期',width:'100'},	
			{field:'BTActTime',title:'更新时间',width:'100'},
			{field:'BTActUserDesc',title:'处置人',width:'150'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPathCompl_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathCompl_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitPathComplListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


