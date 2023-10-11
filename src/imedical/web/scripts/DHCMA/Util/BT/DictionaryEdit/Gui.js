//页面Gui
function InitDicEditWin(){
	var obj = new Object();
	obj.RecRowID= "";
	obj.RecTicTypeID=""
    $.parser.parse(); // 解析整个页面 
	
	//增加院区配置 add by yankai20210728
	var DefHospOID = $cm({ClassName:"DHCMA.Util.IO.MultiHospInterface",MethodName:"GetDefaultHosp",aTableName:"DHCMA_Util_BT.Dictionary",aHospID:session['LOGON.HOSPID'],dataType:'text'},false);
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	obj.cboSSHosp = Common_ComboToSSHosp3("cboSSHosp","","","DHCMA_Util_BT.Dictionary",SessionStr,"");
	$('#cboSSHosp').combobox({
  		onSelect: function(title,index){
	  		obj.gridDictionary.load({
				ClassName:"DHCMA.Util.BTS.DictionarySrv",
				QueryName:"QryDictionaryByDicType",
				aTypeDr:$('#DicType').tabs('getSelected')[0]['id'],
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
	
	//字典类型列表
	var runQuery =$cm({
		ClassName:'DHCMA.Util.BTS.DicTypeSrv',
		QueryName:'QryDicType',
		aProCode: ProductCode
	},false);
	if(runQuery){
		var arrDT = runQuery.rows;
		tabsLength=arrDT.length;
		for (var indDT = 0; indDT < arrDT.length; indDT++){
			var rd = arrDT[indDT];
			if (!rd) continue;
			$('#DicType').tabs('add',{
				id:rd["BTID"],
				title:rd["BTDesc"],
				closable:false
			});
		}
	}
	
	obj.gridDictionary = $HUI.datagrid("#gridDictionary",{
		//title: "产品字典列表",
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCMA.Util.BTS.DictionarySrv",
			QueryName:"QryDictionaryByDicType",
			aTypeDr:$('#DicType').tabs('getSelected')[0]['id'],
			aHospID: $("#cboSSHosp").combobox('getValue')
		},
		columns:[[
			{field:'BTID',title:'ID',width:'50'},
			{field:'BTCode',title:'代码',width:'80',sortable:true},
			{field:'BTDesc',title:'名称',width:'200'}, 
			{field:'BTIndNo',title:'排序码',width:'70'},
			{field:'BTIsActive',title:'是否有效',width:'70'},
			{field:'BTActDate',title:'处置日期',width:'120'},
			{field:'BTActTime',title:'处置时间',width:'120'},
			{field:'BTActUserDesc',title:'处置人',width:'132'}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridDictionary_onDbselect(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridDictionary_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnAuthHosp").linkbutton("disable");
		}
	});
	
	$('#DicType').tabs({
    	onSelect:function(title,index){
        	var tab = $('#DicType').tabs('getSelected');
        	if(retMultiHospCfg=="Y"){
	        	obj.gridDictionary.load({
					ClassName:"DHCMA.Util.BTS.DictionarySrv",
					QueryName:"QryDictionaryByDicType",
					aTypeDr:tab[0]['id'],
					aHospID: $("#cboSSHosp").combobox('getValue')
				});
	        }else{
		    	obj.gridDictionary.load({
					ClassName:"DHCMA.Util.BTS.DictionarySrv",
					QueryName:"QryDictionaryByDicType",
					aTypeDr:tab[0]['id']
				});    
		    }
			
    	}
	});
	$('#DicType').tabs('select', 0);
	
	InitDicEditWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


