$(function () {
	InitSuRuleWin();
});

//页面Gui
function InitSuRuleWin(){
	var obj = new Object();
	obj.ItemRowID ="";
	obj.RuleRowID ="";
	obj.ExpRowID ="";
	obj.RuleID ="";
	obj.ItemCate="";
	obj.ItemDicTab="";
	//疑似筛查规则项目 
	obj.gridSuItem = $HUI.datagrid("#gridSuItem",{
		fit: true,
		//title: "疑似筛查规则项目",
		//headerCls:'panel-header-gray',	
		//iconCls:'icon-resort',
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,	
		nowrap:true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 999,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.IRS.CRuleSuRuleSrv",
			QueryName:"QrySuItem",
			page:1,    //可选项，页码，默认1
			rows:999    //可选项，获取多少条数据，默认50
	    },	    
		columns:[[
			{field:'Category',title:'项目分类',width:200}, 
			{field:'ItemDesc',title:'项目名称',width:200}, 
			{field:'ItemDesc2',title:'项目别名',width:200},
			{field:'InputDicTab',title:'值域',width:200}, 
			{field:'MaxTabDesc',title:'限定筛查上限',width:120,align:'center'},
			{field:'MinTabDesc',title:'限定筛查下限',width:120,align:'center'},
			{field:'DayTabDesc',title:'限定持续天数',width:120,align:'center'},	
			{field:'CntTabDesc',title:'限定次数',width:100,align:'center'},
			{field:'InputNote',title:'输入说明',width:200}		
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridSuItem_onDbselect(rowData);								
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridSuItem_onSelect();
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			//指定列进行合并操作
            $(this).datagrid("autoMergeCells", ['Category']);
		}
	});
	
	//疑似筛查规则 
	obj.gridSuRule = $HUI.datagrid("#gridSuRule",{
		fit: true,
		//title: "疑似筛查规则",
		//headerCls:'panel-header-gray',	
		//iconCls:'icon-resort',
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,	
		nowrap:true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 999,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.IRS.CRuleSuRuleSrv",
			QueryName:"QrySuRule",
			page:1,    //可选项，页码，默认1
			rows:999    //可选项，获取多少条数据，默认50
	    },	    
		columns:[[
			{field:'RuleType',title:'规则定义',width:80,sortable:true,align:'center'},
			{field:'RuleNote',title:'规则说明',width:150,sortable:true},
			{field:'ItmScreenDesc',title:'疑似筛查项目',width:150}, 
			{field:'InfPosDesc',title:'疑似诊断',width:150,align:'center'}, 
			{field:'Threshold',title:'阈值',width:60,align:'center'}, 
			{field:'IsActDesc',title:'是否<br>有效',width:60,align:'center'}		
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridSuRule_onDbselect(rowData);								
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.RuleID = rowData.RuleID;
				obj.gridSuRule_onSelect();
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd_R").linkbutton("enable");
			$("#btnEdit_R").linkbutton("disable");
			$("#btnDelete_R").linkbutton("disable");
			$("#btnAdd_E").linkbutton("disable");		
		}
	});
	
	
	//筛查规则表达式 
	obj.gridSuRuleExp = $HUI.datagrid("#gridSuRuleExp",{
		fit: true,
		//title: "筛查规则表达式",
		//headerCls:'panel-header-gray',
		//iconCls:'icon-resort',
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: 999,
		url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.IRS.CRuleSuRuleSrv",
			QueryName:"QrySuRuleExp",
			page:1,    //可选项，页码，默认1
			rows:999    //可选项，获取多少条数据，默认50
	    },	    
		columns:[[
			{field:'InputNote',title:'项目描述',width:250,showTip:true}, 
			{field:'ItemDesc',title:'项目名称',width:150},
			{field:'Weight',title:'权重',width:60,align:'center'},	
			{field:'InputDicSet',title:'值域',width:150}, 
			{field:'InputSttDay',title:'限定<br>天数',width:60,align:'center'},	
			{field:'InputMaxSet',title:'筛查<br>上限',width:60,align:'center'},
			{field:'InputMinSet',title:'筛查<br>下限',width:60,align:'center'},
			{field:'InputDaySet',title:'持续<br>天数',width:60,align:'center'},
			{field:'InputCntSet',title:'限定<br>次数',width:60,align:'center'}		
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridSuRuleExp_onDbselect(rowData);								
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridSuRuleExp_onSelect();
			}
		},
		onLoadSuccess:function(data){
			$("#btnEdit_E").linkbutton("disable");
			$("#btnDelete_E").linkbutton("disable");
		}
	});
	
	
	obj.cboItmScreen = $HUI.combobox("#cboItmScreen", {
     	url: $URL,
        editable: true,
        allowNull: true,
        defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
        valueField: 'ID',
        textField: 'Desc',
        onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
            param.ClassName = 'DHCHAI.IRS.CCItmScreenSrv';
            param.QueryName = 'QryScreenSrv';
        	param.ResultSetType = 'array';
			param.aActive =1;
      	}
    });
	
	obj.cboSuPos = $HUI.combobox("#cboSuPos", {
     	url: $URL,
        editable: true,
        allowNull: true,
        defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
        valueField: 'ID',
        textField: 'Diagnos',
        onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
            param.ClassName = 'DHCHAI.BTS.InfSuPosSrv';
            param.QueryName = 'QryInfSuPos';
        	param.ResultSetType = 'array';
      	}
    });
	obj.LoadItemDesc = function() {
		obj.cboItemDesc = $HUI.combobox("#cboItemDesc", {
			url: $URL,
			editable: true,
			allowNull: true,
			defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
			valueField: 'ItemDesc',
			textField: 'ItemDesc',
			onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
				param.ClassName = 'DHCHAI.IRS.CRuleSuRuleSrv';
				param.QueryName = 'QrySuItem';
				param.aItemCate = obj.ItemCate;
				param.ResultSetType = 'array';
			},
			onSelect:function(rowData){
				obj.ItemDicTab = rowData.InputDicTab;
				if (ItemDicTab) {
					$('#tr-ItemDicSet').css('display','');
					$('#txtInputDicSet').attr("readOnly", true);
					obj.LoadItemDic(ItemDicTab);
				}else {
					$('#tr-ItemDicSet').css('display','none');
					$('#txtInputDicSet').attr("readOnly", false);
				}
			}
		});
	}
	obj.LoadItemDesc();
	obj.cboItemCate = $HUI.combobox("#cboItemCate", {
     	url: $URL,
        editable: true,
        allowNull: true,
        defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
        valueField: 'Category',
        textField: 'Category',
        onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
            param.ClassName = 'DHCHAI.IRS.CRuleSuRuleSrv';
            param.QueryName = 'QrySuItemCate';
        	param.ResultSetType = 'array';
      	},
		onSelect:function(rowData){
			obj.ItemCate = rowData.Category;
			obj.LoadItemDesc();			
		}
    });
	
	obj.LoadItemDic =function (ItemDicTab) {
		if (ItemDicTab=="细菌字典") {
			obj.cboInputDicSet = $HUI.combobox("#cboInputDicSet", {
				multiple:true,
				rowStyle:'checkbox', //显示成勾选行形式
				editable: true,
				allowNull: true,
				defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'BacDesc',
				textField: 'BacDesc', 
				onBeforeLoad:function(param){
					var desc=param['q'];
					if (desc=="") return false;
					param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
				},
				onShowPanel: function () {
					var url=$URL+"?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBacteria&ResultSetType=array&aAlias";
					$("#cboInputDicSet").combobox('reload',url);
				}
			});
		}else if (ItemDicTab=="标本字典") {
			obj.cboInputDicSet = $HUI.combobox("#cboInputDicSet", {
				multiple:true,
				rowStyle:'checkbox', //显示成勾选行形式
				editable: true,
				allowNull: true,
				defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'SpecDesc',
				textField: 'SpecDesc', 
				onBeforeLoad:function(param){
					var desc=param['q'];
					if (desc=="") return false;
					param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
				},
				onShowPanel: function () {
					var url=$URL+"?ClassName=DHCHAI.DPS.LabSpecSrv&QueryName=QryLabSpecimen&ResultSetType=array&aAlias";
					$("#cboInputDicSet").combobox('reload',url);
				}
			});
		}else if (ItemDicTab=="检验项目") {
			obj.cboInputDicSet = $HUI.combobox("#cboInputDicSet", {
				multiple:true,
				rowStyle:'checkbox', //显示成勾选行形式
				editable: true,
				allowNull: true,
				defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'TestCode',
				textField: 'FieldDesc', 
				onShowPanel: function () {
					var url=$URL+"?ClassName=DHCHAI.DPS.LabTCMapSrv&QueryName=QryLabTCMapToCombo&ResultSetType=array";
					$("#cboInputDicSet").combobox('reload',url);
				}
			});
		}else if (ItemDicTab=="检验医嘱") {
			obj.cboInputDicSet = $HUI.combobox("#cboInputDicSet", {
				multiple:true,
				rowStyle:'checkbox', //显示成勾选行形式
				editable: true,
				allowNull: true,
				defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'TestSet',
				textField: 'TestSet', 
				onBeforeLoad:function(param){
					var desc=param['q'];
					if (desc=="") return false;
					param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
				},
				onShowPanel: function () {
					var url=$URL+"?ClassName=DHCHAI.DPS.LabTestSetSrv&QueryName=QryLabTestSet&ResultSetType=array&aAlias";
					$("#cboInputDicSet").combobox('reload',url);
				}
			});
		}else if (ItemDicTab=="抗菌药物字典") {
			obj.cboInputDicSet = $HUI.combobox("#cboInputDicSet", {
				multiple:true,
				rowStyle:'checkbox', //显示成勾选行形式
				editable: true,
				allowNull: true,
				defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'BTName',
				textField: 'BTName', 		
				onShowPanel: function () {
					var url=$URL+"?ClassName=DHCHAI.DPS.OEAntiMastSrv&QueryName=QryOEAntiMast&ResultSetType=array";
					$("#cboInputDicSet").combobox('reload',url);
				}
			});
		}else if (ItemDicTab=="医嘱项") {
			obj.cboInputDicSet = $HUI.combobox("#cboInputDicSet", {
				multiple:true,
				rowStyle:'checkbox', //显示成勾选行形式
				editable: true,
				allowNull: true,
				defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'BTDesc',
				textField: 'BTDesc', 
				onShowPanel: function () {
					var url=$URL+"?ClassName=DHCHAI.DPS.OEItmMastSrv&QueryName=QryOEItmMast&ResultSetType=array";
					$("#cboInputDicSet").combobox('reload',url);
				}
			});
		}
	}
	$HUI.combobox("#cboInputDicSet",{
		onSelect:function(rowData){
			var InputDicSet = $(this).combobox('getValues');
			if (InputDicSet) {
				var DicSet = InputDicSet.join("#");
				$('#txtInputDicSet').val(DicSet);
			}
		}
	});
	
	InitSuRuleWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}