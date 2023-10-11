//页面Gui
function InitPathEntityListWin(){
	var obj = new Object();
	obj.RecRowID= "";
    $.parser.parse(); // 解析整个页面 
	
	//增加院区配置 add by yankai20210803
	var DefHospOID = $cm({ClassName:"DHCMA.Util.IO.MultiHospInterface",MethodName:"GetDefaultHosp",aTableName:"DHCMA_CPW_BT.PathEntity",aHospID:session['LOGON.HOSPID'],dataType:'text'},false);
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	obj.cboSSHosp = Common_ComboToSSHosp3("cboSSHosp","","","DHCMA_CPW_BT.PathEntity",SessionStr,"");
	$('#cboSSHosp').combobox({
  		onSelect: function(title,index){
	  		obj.gridPathEntity.load({
				ClassName:"DHCMA.CPW.BTS.PathEntitySrv",
				QueryName:"QryPathEntity",
				aHospID: $("#cboSSHosp").combobox('getValue'),
				aIsActive:""
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
		$("#divHosp").hide();	
	}
	
	obj.gridPathEntity = $HUI.datagrid("#gridPathEntity",{
		fit: true,
		//title: "病种字典维护",
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
		    ClassName:"DHCMA.CPW.BTS.PathEntitySrv",
			QueryName:"QryPathEntity",
			aIsActive:"",
			aHospID: $("#cboSSHosp").combobox('getValue')
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'50'},
			{field:'BTCode',title:'代码',width:'160',sortable:true},
			{field:'BTDesc',title:'名称',width:'320'}, 
			{field:'BTTypeDesc',title:'路径类型',width:'280'},
			{field:'BTIsActive',title:'是否有效',width:'100'},
			/*{field:'BTActDate',title:'处置日期',width:'160'},	
			{field:'BTActTime',title:'处置时间',width:'160'},*/
			{field:'BTActUserDesc',title:'处置人',width:'160'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPathEntity_onSelect(rowData);
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathEntity_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	obj.cboKind = $HUI.combobox('#cboTypeDr', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathTypeSrv';
			param.QueryName = 'QryPathType';
			param.aHospID = $("#cboSSHosp").combobox('getValue');
			param.ResultSetType = 'array'
		},
		onShowPanel:function(){			
			$(this).combobox('loadData',[]).combobox('reload');	
		}
	});
	
	InitPathEntityListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


