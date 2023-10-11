//页面Gui
function InitPathItemCatListWin(){
	var obj = new Object();
	obj.RecRowID = "";	
    $.parser.parse(); // 解析整个页面 
	
	//增加院区配置 add by yankai20210803
	var DefHospOID = $cm({ClassName:"DHCMA.Util.IO.MultiHospInterface",MethodName:"GetDefaultHosp",aTableName:"DHCMA_CPW_BT.PathItemCat",aHospID:session['LOGON.HOSPID'],dataType:'text'},false);
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	obj.cboSSHosp = Common_ComboToSSHosp3("cboSSHosp","","","DHCMA_CPW_BT.PathItemCat",SessionStr,"");
	$('#cboSSHosp').combobox({
  		onSelect: function(title,index){
	  		obj.gridPathItemCat.load({
				ClassName:"DHCMA.CPW.BTS.PathItemCatSrv",
				QueryName:"QryPathItemCat",
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
		$("#divHosp").hide();
		$("#btnAuthHosp").hide();	
	}
	
	obj.gridPathItemCat = $HUI.datagrid("#gridPathItemCat",{
		fit: true,
		//title: "项目分类维护",
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
		    ClassName:"DHCMA.CPW.BTS.PathItemCatSrv",
			QueryName:"QryPathItemCat",
			aHospID:DefHospOID
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'50'},
			{field:'BTCode',title:'代码',width:'245',sortable:true},
			{field:'BTDesc',title:'名称',width:'400'}, 
			{field:'BTTypeDesc',title:'项目大类',width:'350'},
			{field:'BTPowerDesc',title:'权限类型',width:'150'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {	
				obj.gridPathItemCat_onSelect();	
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathItemCat_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnAuthHosp").linkbutton("disable");
		}
	});
	
	// 项目大类
	obj.cboItemType = $HUI.combobox('#cboItemType', {              
		url: $URL,
		blurValidValue:true,
		editable: true,
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.DictionarySrv';
			param.QueryName = 'QryDictByType';
			param.ResultSetType = 'array'
			param.aTypeCode = 'CPWFormItemType',
			param.aHospID = $("#cboSSHosp").combobox('getValue')
		},
		onShowPanel:function(){
			$(this).combobox('reload');	
		},
		filter: function(q, row){
			return (row["BTDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	});
	
	// 权限分类
	obj.cboPowerType = $HUI.combobox('#cboPowerType', {              
		url: $URL,
		blurValidValue:true,
		editable: true,
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.DictionarySrv';
			param.QueryName = 'QryDictByType';
			param.ResultSetType = 'array'
			param.aTypeCode = 'CPWItemPowerType'
		},
		filter: function(q, row){
			return (row["BTDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	});
	
	InitPathItemCatListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


