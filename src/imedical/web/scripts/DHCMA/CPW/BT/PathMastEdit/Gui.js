//页面Gui
function InitPathMastListWin(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.cboHospValue="";
    $.parser.parse(); // 解析整个页面 
	
	//增加院区配置 add by yankai20210803
	var DefHospOID = $cm({ClassName:"DHCMA.Util.IO.MultiHospInterface",MethodName:"GetDefaultHosp",aTableName:"DHCMA_CPW_BT.PathMast",aHospID:session['LOGON.HOSPID'],dataType:'text'},false);
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	obj.cboSSHosp = Common_ComboToSSHosp3("cboSSHosp","","","DHCMA_CPW_BT.PathMast",SessionStr,"");
	$('#cboSSHosp').combobox({
  		onSelect: function(title,index){
	  		obj.gridPathMast.load({
				ClassName:"DHCMA.CPW.BTS.PathMastSrv",
				QueryName:"QryPathMast",
				aKeyValue:$('#txtSearch').searchbox('getValue'),
				aHospID: $("#cboSSHosp").combobox('getValue')
			});
	  	}
	 })
	 
	obj.gridPathMast = $HUI.datagrid("#gridPathMast",{
		fit: true,
		title: "路径字典维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		checkOnSelect:true,
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:$g('数据加载中...'),
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathMastSrv",
			QueryName:"QryPathMast",
			aHospID: $("#cboSSHosp").combobox('getValue')
	    },
		columns:[[
			{field:'check',checkbox:'true',align:'center',width:'',auto:false},
			{field:'BTID',title:'ID',width:'50'},
			{field:'BTCode',title:'代码',width:'120',sortable:true},
			{field:'BTDesc',title:'名称',width:'200'}, 
			{field:'BTTypeDesc',title:'路径类型',width:'100'},
			{field:'BTEntityDesc',title:'病种路径',width:'100'},
			{field:'BTPCEntityDesc',title:'付费病种',width:'150',hidden:true},
			{field:'BTQCEntityDesc',title:'质控病种',width:'150',hidden:true},
			{field:'HospDescList',title:'关联医院',width:'200'},
			{field:'BTAdmType',title:'就诊类型',width:'100',formatter:function(v){
				if (v=="I") return $g("住院");
					else if (v=="O") return  $g("门诊");
					else return "";
				}
			},
			{field:'IsOper',title:'手术路径',width:'80',formatter:function(v){
				if(v=='1') return  $g('是');else return  $g('否'); 	
			}},
			{field:'IsAsComplDesc',title:'合并症路径',width:'80'},
			//{field:'StaCategoryDesc',title:'统计类别',width:'150'},
			{field:'BTIsActive',title:'是否有效',width:'80'},
			/*{field:'BTActDate',title:'处置日期',width:'100'},	
			{field:'BTActTime',title:'处置时间',width:'80'},*/
			{field:'BTActUserDesc',title:'处置人',width:'120'}
		]],
		onSelect:function(rindex,rowData){
			if(rindex>-1){
				obj.gridPathMast_onSelect();	
			}
		},
		onUnselect:function(rindex,rowData){
			if(rindex>-1){
				obj.gridPathMast_onSelect();	
			}	
		},
		onCheckAll: function(rows){
			obj.gridPathMast_onSelect();	
		},
		onUncheckAll:function(rows){
			obj.gridPathMast_onSelect();		
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathMast_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnExport").linkbutton("disable");
			
			var checkboxHeader = $('div.datagrid-header-check input[type=checkbox]');	//取到全选全不选这个元素
			checkboxHeader.prop("checked",false); 										//prop("checked","checked");//将其设置为checked即可
		}
	});
	//路径类型
	obj.cbokind = $HUI.combobox('#cboTypeDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathTypeSrv';
			param.QueryName = 'QryPathType';
			param.aHospID 	= $("#cboSSHosp").combobox('getValue');
			param.ResultSetType = 'array'
		},
		onShowPanel:function(){
			$(this).combobox('reload');	
		},
		defaultFilter:4,
	});
	//病种路径
	obj.cboPath = $HUI.combobox('#cboEntityDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		allowNull:true,
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		defaultFilter:4,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathEntitySrv';
			param.QueryName = 'QryPathEntity';
			param.aHospID 	= $("#cboSSHosp").combobox('getValue');
			param.ResultSetType = 'array'
		},
		onShowPanel:function(){
			$(this).combobox('reload');	
		}
	});
	//病种付费
	obj.cboPay = $HUI.combobox('#cboPCEntityDr', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		allowNull:true,
		mode: 'remote',
		valueField: 'RowID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.SDS.PCEntitySrv';
			param.QueryName = 'QryPCEntity';
			param.ResultSetType = 'array'
		},
		onSelect:function(rec){
			var ret = $m({
				ClassName:"DHCMA.Util.BT.Config",
				MethodName:"GetValueByCode",
				aCode:"SDIsOpenPCModBaseCPW"
			},false);
	  		if(parseInt(ret)!=1) {
	  			$.messager.alert( $g("提示"),  $g("未启用单病种付费提醒功能，请开启该模块配置后再维护此数据！"), 'info');
	  			$("#cboPCEntityDr").combobox({disabled:true});
	  			return false;
	  		}	
		}
	})
	//病种质量
	obj.cboQuality = $HUI.combobox('#cboQCEntityDr', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		allowNull:true,
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.SDS.QCEntitySrv';
			param.QueryName = 'QryQCEntity';
			param.ResultSetType = 'array'
		}
	});
	
	//就诊类型
	obj.AdmType = $HUI.combobox('#AdmType', {
		valueField:'id',
		textField:'text',
		selectOnNavigation:true,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'O',text: $g('门诊')},
			{id:'I',text: $g('住院')}
		]
	})
	
	//统计分类
	obj.cboStaCategory = $HUI.combobox('#cboStaCategory', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		allowNull:true,
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.DictionarySrv';
			param.QueryName = 'QryDictByType';
			param.aTypeCode = 'CPWStaCategory';
			param.aIsActive = 1;
			param.aHospID 	= $("#cboSSHosp").combobox('getValue');
			param.ResultSetType = 'array'
		},
		onShowPanel:function(){
			$(this).combobox('reload');	
		}
	});
	
	
	//医院下拉框
	obj.cboHosp = $HUI.combobox('#cboHosp', {		//采用多院区改写后取值query
		url: $URL,
		editable: false,
		multiple:true,
		selectOnNavigation:false,
		mode: 'remote',
		valueField: 'OID',
		textField: 'Desc',
		onBeforeLoad: function (param) {			
			param.ClassName = 'DHCMA.Util.IO.MultiHospInterface';
			param.QueryName = 'QryHospInfoForCombo';
			param.aTableName = "DHCMA_CPW_BT.PathMast";
			param.aSessionStr = SessionStr;
			param.ResultSetType = 'array';
		}
		,formatter:function(row){  
			var opts;
			if(row.selected==true){
				opts = "<input type='checkbox' checked='checked' id='r"+row.OID+"' value='"+row.OID+"' style='vertical-align:middle;margin-right: 3px;'>"+row.Desc;
			}else{
				opts = "<input type='checkbox' id='r"+row.OID+"' value='"+row.OID+"' style='vertical-align:middle;margin-right: 3px;'>"+row.Desc;
			}
			return opts;
		},
		onSelect:function(rec) {
			var objr =  document.getElementById("r"+rec.OID);
			$(objr).prop('checked',true);
			obj.cboHospValue=obj.cboHospValue+"^"+rec.OID+"-";
		}
		,onUnselect:function(rec){
			var objr =  document.getElementById("r"+rec.OID);
			$(objr).prop('checked',false);
			var subStr="^"+rec.OID+"-";
			obj.cboHospValue=obj.cboHospValue.replace(subStr,"");
		}
	});
	
	//搜索框定义
	$('#txtSearch').searchbox({ 
		searcher:function(value,name){
			obj.gridPathMast.load({
				ClassName:"DHCMA.CPW.BTS.PathMastSrv",
				QueryName:"QryPathMast",
				aKeyValue:value,
				aHospID: $("#cboSSHosp").combobox('getValue')
			});
		}, 
		prompt: $g('请输入名称/路径类型') 
	});
	
	
	//多院区信息的隐藏与显示
	obj.retMultiHospCfg = $m({
		ClassName:"DHCMA.Util.BT.Config",
		MethodName:"GetValueByCode",
		aCode:"SYSIsOpenMultiHospMode",
		aHospID:session['DHCMA.HOSPID']
	},false);
	if(obj.retMultiHospCfg!="Y"){
		//$("#layout").layout('panel',"north").hide();
		//$("#layout").layout('panel',"center").panel({fit:true});		
		//$("#layout").layout('resize');
		//$("#layout").layout('panel',"center").parent().css({'top':'0'});
	}else{
		$('#gridPathMast').datagrid('hideColumn', 'HospDescList');
		$("#trHosp").css({'display':'none'});	
	}
	
	InitPathMastListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


