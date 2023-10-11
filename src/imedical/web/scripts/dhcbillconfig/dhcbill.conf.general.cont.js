// scripts/dhcbillconfig/dhcbill.conf.general.cont.js
function initList(){
	_loadSourceList();
	loadTgtList();
	_loadResultList();	
}

// 源数据列表 搜索框
$("#src-search").searchbox({
	searcher: function(value) {
		if(CV.DataSrcFilterMode == "remote"){// 远程检索重新加载数据
			_loadSourceList();
		}else{
			$("#sourceList").datagrid("reload");
		}
	}
});

// 源数据列表 过滤
$("#src-type").combobox({
	panelHeight: 92,
	data: [{value: '2', text: '全部数据'},
		   {value: '1', text: '已配置数据'},
		   {value: '0', text: '未配置数据'}
		],
	valueField: 'value',
	textField: 'text',
	value: '2',
	editable: false,
	blurValidValue: true,
	onChange:function(newValue,oldValue){
		$("#sourceList").datagrid("reload");
	}
});

// 源数据列表 重置
$("#srcClear").bind('click', function(){    
	setValueById("src-type","2");
	$('#src-search').searchbox('setValue',''); 
	$("#sourceList").datagrid("reload");
	$("#sourceList").datagrid("unselectAll");
	_loadResultList();	
});

// 源数据列表
$("#sourceList").datagrid({
	//width: window.innerWidth*0.5,
	height: 270,
	title: '源数据列表',
	iconCls: 'icon-paper',
	headerCls: 'panel-header-gray',
	fitColumns: true,
	rownumbers: true,
	singleSelect: true,
	pageSize: 999999999,
	toolbar: '#src-tb',
	className: CV.SrcClassName,
	queryName: CV.SrcQueryName,
	onColumnsLoad: function(cm) {
		cm.map(function(item) {
			item.width = 100;
		});
	},
	onLoadSuccess: function(data) {
		$("#resultList").datagrid("loadData", {total: 0, rows: []});
	},
	onBeforeSelect: function(index, row) {
		var row = $("#sourceList").datagrid("getSelected");
		if ($("#sourceList").datagrid("getRowIndex", row) != index) {
			return true;
		}
		$("#sourceList").datagrid("unselectRow", index);
		return false;
	},
	onSelect: function(index, row) {
		_loadResultList();
	},
	onUnselect: function(index, row) {
		_loadResultList();
	},
	loadFilter: function(data) {	//搜索框
		// 逻辑更改 加载模式为remote 的，此处搜索框屏蔽
		var srcSearch = $.trim($("#src-search").searchbox("getValue"));
		if (CV.DataSrcFilterMode != "remote" && srcSearch) {
			data.rows = data.rows.filter(function(row) {// 搜索框判断代码和描述两个变量
				return ((row.text.toUpperCase().indexOf(srcSearch.toUpperCase()) != -1)||(row.code.toUpperCase().indexOf(srcSearch.toUpperCase()) != -1));
			});
		}
		if(getValueById("src-type") != "2"){
			var srcData = $.m({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "GetCfgRelaDataSrcExist", RelaCode: CV.RelaCode, HospId: getHospId()}, false);
			srcData = "^" + srcData + "^";
			if(getValueById("src-type") == "1"){// 已配置
				data.rows = data.rows.filter(function(row) {
					var id = "^" + row.id + "^"
					return srcData.indexOf(id) != -1 ;
				});
				
			}
			
			if(getValueById("src-type") == "0"){// 未配置
				data.rows = data.rows.filter(function(row) {
					var id = "^" + row.id + "^"
					return srcData.indexOf(id) == -1 ;				
				});
			}
		}

		return {rows: data.rows, total: data.rows.length};
	}/*,
	onBeforeLoad: function(param){	//控制默认加载
	
		var srcSearch = $.trim($("#src-search").searchbox("getValue"));
		if((CV.DataSrcFilterMode == "remote") && (srcSearch == "") ){
			return false
		}
		return true;
		
	}*/
});

// 加载 源数据列表
var _loadSourceList = function() {
	switch(CV.DataSrcFilterMode) {
		case "local":
			var queryParams = {
				ClassName: CV.SrcClassName,
				QueryName: CV.SrcQueryName,
				methodName: CV.DataSrcParam,
				hospId: getHospId(),
				rows: 99999999
			};
			break;
		case "remote":
			var queryParams = {//远程检索需要传key（搜索框内容）
				ClassName: CV.SrcClassName,
				QueryName: CV.SrcQueryName,
				methodName: CV.DataSrcParam,
				key:$("#src-search").searchbox("getValue"),
				hospId: getHospId(),
				rows: 99999999
			};
			break;
		case "dic":
			var queryParams = {
				ClassName: CV.SrcClassName,
				QueryName: CV.SrcQueryName,
				dicType:CV.DataSrcParam,
				rows: 99999999
			};
			break;
	    case "dicInsu":
			var queryParams = {
				ClassName: CV.SrcClassName,
				QueryName: CV.SrcQueryName,
				dicType:CV.DataSrcParam,
				hospId: getHospId(),
				rows: 99999999
			};
			break;   
		default: 	
	}	
	loadDataGridStore("sourceList", queryParams);
};	