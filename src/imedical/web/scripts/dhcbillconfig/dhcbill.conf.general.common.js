// scripts/dhcbillconfig/dhcbill.conf.general.common.js

//载入前先判断该配置点是否未发布，如果不是则不允许再修改或导入
if (CV.IsReleased == "2"){
	disableById("btn-save");
	disableById("btn-import");
}else{
	enableById("btn-save");
	enableById("btn-import");			
}
// 只读权限
if (CV.LimitFlag == "2"){
	disableById("btn-save");
}
var GV={
	SeqStr : "",
	CheckData : "1",
	EditFlag : true,
	PassFlag:"N"
	}
$HUI.linkbutton("#btn-import", {
	onClick: function () {
		importClick();
	}
});
// 医院
$("#hospital").combobox({
	panelHeight: 150,
	width: 300,
	url: $URL + '?ClassName=BILL.CFG.COM.GeneralCfg&QueryName=QryHospList&PublicFlag=' + CV.PublicFlag + '&ResultSetType=array',
	method: 'GET',
	valueField: 'id',
	textField: 'text',
	editable: false,
	blurValidValue: true,
	onLoadSuccess: function(data) {
		if(CV.PublicFlag == "1"){
			$(this).combobox("select", "COM");
		}else{
			$(this).combobox("select", PUBLIC_CONSTANT.SESSION.HOSPID);
		}
	},
	onChange: function(newValue, oldValue) {
		initList();
	}
});

// 配置数据 过滤
$("#ret-type").combobox({
	panelHeight: 62,
	data: [{value: '1', text: '有效数据'},
		   {value: '0', text: '无效数据'}
		],
	valueField: 'value',
	textField: 'text',
	value: '1',
	editable: false,
	blurValidValue: true,
	onChange:function(newValue,oldValue){
		_loadResultList();
	}
});

// 目标数据列表 搜索
$("#tgt-search").searchbox({
	searcher: function(value) {
		if(CV.DataTgtFilterMode == "remote"){// 远程检索重新加载数据
			loadTgtList();
		}else{
			$("#tgtList").datagrid("reload");
		}
	}
});

// 配置数据列表 搜索
$("#ret-search").searchbox({
	searcher: function(value) {
		$("#resultList").datagrid("reload");
	}
});
// 目标数据列表
$("#tgtList").datagrid({
	//width: 300,
	height: 270,
	striped: true,
	title: '目标数据列表',
	iconCls: 'icon-paper',
	headerCls: 'panel-header-gray',
	fitColumns: true,
	rownumbers: true,
	singleSelect: true,
	pageSize: 999999999,
	toolbar: '#tgt-tb',
	className: CV.TgtClassName,
	queryName: CV.TgtQueryName,
	onColumnsLoad: function(cm) {
		cm.map(function(item) {
			item.width = 100;
		});
		if (CV.LimitFlag == 1){
			cm.push({field: 'handler', title: '操作', align: 'center', formatter: function(value, row, index) {
				return "<a href='javascript:;' onclick='_addHandler(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png'/></a>";
			}});
		}
	},
	loadFilter: function(data) {	//搜索框
		var srcSearch = $.trim($("#tgt-search").searchbox("getValue"));
		if (CV.DataTgtFilterMode != "remote" && srcSearch) {
			data.rows = data.rows.filter(function(row) {
				return ((row.text.toUpperCase().indexOf(srcSearch.toUpperCase()) != -1)||(row.code.toUpperCase().indexOf(srcSearch.toUpperCase()) != -1));
			});
		}
		return {rows: data.rows, total: data.rows.length};
	}/*,
	onBeforeLoad: function(param){	//控制默认加载
		var srcSearch = $.trim($("#tgt-search").searchbox("getValue"));
		if(CV.DataTgtFilterMode=="remote" && srcSearch==""){
			return false
		}
		return true;
	}*/
});

// 配置数据列表
$("#resultList").datagrid({
	//width: 634,
	height: 290,
	striped: true,
	title: '配置数据列表',
	iconCls: 'icon-paper',
	headerCls: 'panel-header-gray',
	fitColumns: true,
	rownumbers: true,
	singleSelect: true,
	pageSize: 999999999,
	toolbar: '#ret-tb',
	className: CV.ResClassName,
	queryName: CV.ResQueryName,
	onColumnsLoad: function(cm) {
		for (var i = 0;i<cm.length;i++){
			if (cm[i]['field'] == "handler"){// 操作 handler
				if (CV.LimitFlag == 2) return;
				//cm[i].width = 40;
				cm[i].align = 'center';
				cm[i].formatter =function(value, row, index) {
					return "<a href='javascript:;' onclick='_delHandler(" + index + "," + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png'/></a>";
				};
			}
			if (cm[i]['field'] == "seqNum"){// 序号 seqNum
				//cm[i].width = 40;
				cm[i].align = 'center';
				cm[i].editor = {
					type:'numberbox',
					options:{
						min:1
					}          
				}  
			}
			if (cm[i]['field'] == "id"){ // id
				cm[i].title = "目标数据ID";
				//cm[i].width = 80;
				// 字典作为目标源数据的时候，不再展示id
				if(CV.DataSrcFilterMode == "dic") {cm[i].hidden = "true";}
				
			}
			if (cm[i]['field'] == "code"||cm[i]['field'] == "srcCode"){// 代码 code
				if (cm[i]['field'] == "code"){cm[i].title = "目标数据代码";}
				//cm[i].width = 120;
			}
			if (cm[i]['field'] == "text"){// 描述 text
				//cm[i].width = 120;
			}
			if (cm[i]['field'] == "activeFrom"||cm[i]['field'] == "activeTo"){// 生效时间 失效时间
				//cm[i].width = 400;
				cm[i].align = 'center';
				cm[i].editor = {
					 type:'datebox'                 
				}
			}
		if (cm[i]['field'].indexOf("eCol") != -1){
				var typeStr = CV.Type.split("|");
				//2|2:numberbox:|1:datebox:
				//var typeStrNew=typeStr[1].split(":");
				var fieldIdx = cm[i]['field'].substring(4);
				//数字|名称|类型|
				// 0	1	2		3		4				
				if ((typeStr[0] - fieldIdx) >= 0){
					var typeStrNew=typeStr[fieldIdx].split(":");
					cm[i].title = typeStrNew[0];
					//cm[i].width = 100;
					cm[i].align = 'center';
					cm[i].editor = {
						 type:typeStrNew[1]                
					};
					switch (cm[i].editor.type){
						case "combobox":
							cm[i].editor.options={
								defaultFilter:4,
								valueField:'code',
								textField:'text',
								url:$URL,
								mode:'local',
								editable:false,
								onBeforeLoad:function(param){
									param.ClassName = 'BILL.CFG.COM.GeneralCfg';
									param.QueryName = 'QryDicDataByType';
									param.dicType = typeStrNew[2];
									param.ResultSetType = 'array';
									return true;
								},
							}
							break;
						case "checkbox":
							cm[i].editor.options={
								on:'Y',
								off:''
							}
							break;
						case "":
							break;
						default:
							// 默认不处理
					}
				}else{
					 cm[i].hidden = "true";
				}
			}
			if (cm[i]['field'] == "updateUser"){ // 更新人 updateUser
				//cm[i].width = 80;
				cm[i].align = 'center';
			}
			if (cm[i]['field'] == "updateDate"){// 更新日期 updateDate
				//cm[i].width = 80;
				cm[i].align = 'center';
			}
			if (cm[i]['field'] == "updateFlag"){// 更新标志 永久性隐藏
				cm[i].hidden = "true";
			}
			if (cm[i]['field'] != "handler"){
				cm[i].formatter = function(val,rowData,rowIndex){
					if (val != undefined){return '<span title=\"'+val+'\">'+val+'</span>';}
				}
        	}
		}
	},
	loadFilter: function(data) {	//搜索框
		var srcSearch = $.trim($("#ret-search").searchbox("getValue"));
		if (srcSearch) {
			data.rows = data.rows.filter(function(row) {
				return ((row.text.toUpperCase().indexOf(srcSearch.toUpperCase()) != -1)||(row.code.toUpperCase().indexOf(srcSearch.toUpperCase()) != -1));
			});
			return {rows: data.rows, total: data.rows.length};
		}
		return data;
	},
	onDblClickRow: function(index, row){
		// 不允许全部展示的时候修改数据
		if ((CV.CSPType == "cont")&&(_getSrcData() == "")) {
			$.messager.popover({msg: "选择源数据列表后才可以修改数据！", type: "error"});
			return; 
		}
		// 不允许修改无效数据
		if (getValueById("ret-type") == "0") { return; }
		// 进入编辑
		if (GV.EditIndex != index) {
			$('#resultList').datagrid('endEdit', GV.EditIndex);
			if(!GV.EditFlag){
				return;
			}
			$('#resultList').datagrid('beginEdit', index);
			GV.EditIndex = index;
			return;
		}
		// 退出编辑
		if (GV.EditIndex == index){
			$('#resultList').datagrid('endEdit', GV.EditIndex);
			if(!GV.EditFlag){
				return;
			}
			$('#resultList').datagrid('unselectRow', GV.EditIndex);
			GV.EditIndex = undefined;
		}
		
	},
	onAfterEdit: function(index, row, changes){
		if(!checkData()){
			return;
		}
		if(GV.CheckData == "0") {
			$('#resultList').datagrid('beginEdit', GV.EditIndex);
			return;
		}
		// 数据变化则修改标志置为1
		for(key in changes){
			if(changes[key] != undefined){
				row.updateFlag = 1;
			}
		}
		//if( changes.activeFrom != undefined || changes.activeTo != undefined || changes.seqNum != undefined ) row.updateFlag = 1
		// 编辑后，需要将序号的数据拼至字符串中
		if(changes.seqNum != undefined) GV.SeqStr = GV.SeqStr + "^" + changes.seqNum
		/*
			校验数据
		*/
		function checkData(){
			// 未开始编辑的时候不进行校验原有数据
			if(typeof(GV.EditIndex) =='undefined') return true;
			// 获取编辑行，对数据进行校验
			var rows = $('#resultList').datagrid('getRows');//获得所有行 
			var rowSel = rows[GV.EditIndex];
			var checkFlag = 1,msg = "";
			// 校验有效时间
			if((rowSel.activeFrom != "")&&(rowSel.activeTo != "")&&(rowSel.activeFrom > rowSel.activeTo)){
				setMsg("失效日期不能小于生效日期！")
			}
			// 校验序号
			if( rowSel.seqNum != ""){
				// 与已配置数据判断，序号是否重复
				var existsFlag = $.m({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "CheckCfgRelaSeqNumExist", RelaCode: CV.RelaCode, SrcData:_getSrcData(), TgtData:rowSel.id ,SeqNum: rowSel.seqNum , HospId: getHospId()}, false);
				if(existsFlag == "1"){
					setMsg("序号重复！")
				}
				// 与已新增尚未保存的数据判断
				if((GV.SeqStr+"^").indexOf("^"+rowSel.seqNum+"^") != -1){
					setMsg("序号重复！")
				}
			}
			if(checkFlag == 0){
				$.messager.popover({msg: msg, type: "error"});
				$('#resultList').datagrid('beginEdit', GV.EditIndex);
				GV.CheckData = "0";
				GV.EditFlag = false;
				return false;
			}else{
				GV.CheckData = "1";
				GV.EditFlag = true;
				return true;
			}
			// 设置msg错误值，并将flag设置为0
			function setMsg(error){
				if(msg == ""){
					msg = error;
				}else{
					msg = msg + "\n" + error;
				}
				checkFlag = 0;
			}
		}
	},
	onLoadSuccess: function(data){
		// 每次加载成功，需要将序号字符串重置
		GV.SeqStr = "";
		GV.EditFlag = true;
	}
});

// 获取 院区
function getHospId() {
	return getValueById("hospital");
};

// 加载 目标数据列表
function loadTgtList() {
	switch(CV.DataTgtFilterMode) {
		case "local":
			var queryParams = {
				ClassName: CV.TgtClassName,
				QueryName: CV.TgtQueryName,
				methodName: CV.DataTgtParam,
				hospId: getHospId(),
				rows: 99999999
			};
			break;
		case "remote":
			var queryParams = {//远程检索需要传key（搜索框内容）
				ClassName: CV.TgtClassName,
				QueryName: CV.TgtQueryName,
				methodName: CV.DataTgtParam,
				key:$("#tgt-search").searchbox("getValue"),
				hospId: getHospId(),
				rows: 99999999
			};
			break;
		case "dic":
			var queryParams = {
				ClassName: CV.TgtClassName,
				QueryName: CV.TgtQueryName,
				dicType:CV.DataTgtParam,
				rows: 99999999
			};
			break;
	    case "dicInsu":
			var queryParams = {
				ClassName: CV.TgtClassName,
				QueryName: CV.TgtQueryName,
				dicType:CV.DataTgtParam,
				hospId: getHospId(),
				rows: 99999999
			};
			break;   
		default: 	
	} 
	loadDataGridStore("tgtList", queryParams);
};

// 加载 配置数据列表
function _loadResultList() {
	var queryParams = {
		ClassName: CV.ResClassName,
		QueryName: CV.ResQueryName,
		relaCode: CV.RelaCode,
		srcData: _getSrcData(),
		hospId: getHospId(),
		VaildFlag: getValueById("ret-type"),
		rows: 99999999
	};
	loadDataGridStore("resultList", queryParams);
};

// 获取 源数据列表 选中数据
function _getSrcData() {
	if($("#sourceList").length>0){
		var row = $("#sourceList").datagrid("getSelected");
		return (row && row.id) ? row.id : "";
	}else{
		return "";
	}
	
};

//保存事件
function _saveClick() {
	// 保存前调用一次退出行编辑，保存最后编辑的数据
	$('#resultList').datagrid('endEdit', GV.EditIndex);
	if ((GV.CSPType == "cont")&&(_getSrcData() == "")){
		$.messager.popover({msg: "源数据列表须选择数据后再修改！", type: "error"});
		return;
	}
	// 检查数据校验标志
	if(GV.CheckData == "0"){
		return;
	}
	// 开发级别的配置点保存数据必须输入密码
	if (CV.UpdLevelFlag == "1"){
		if (GV.PassFlag == "Y"){
			updateDate();
		}else{
			$.messager.prompt("提示", "请输入密码", function (r) {
				if (r) {
					var PassWardFlag =  $.m({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "CheckPassword", Password: r}, false);
					if (+PassWardFlag){
						GV.PassFlag = "Y";
						updateDate();
					}else{
						$.messager.alert('错误','密码错误','error');	
					}
				}
			})
		}
	}else{
		$.messager.confirm("确定", "是否确认保存？", function(r) {
			if (r) {
				updateDate();
			}
		});
	}
	function updateDate(){
		var relaAry = [];
		$("#resultList").datagrid("getRows").forEach(function(row) {
			var index = $("#resultList").datagrid('getRowIndex', row); 
		
			// 过滤修改标志为0的数据
			if (row.updateFlag != 0){
				var rela = {
					CRDTgtData: row.id,
					CRDActiveDateFrom: row.activeFrom,
					CRDActiveDateTo: row.activeTo,
					CRDSeqNum: row.seqNum,
					CRDECol1:row.eCol1
				};
				relaAry.push(JSON.stringify(rela));
			}
		});
		if(relaAry.length == 0){
			$.messager.popover({msg: "未检查到修改的数据！", type: "success"});
			return;
		}
		
		$.m({
			ClassName: "BILL.CFG.COM.GeneralCfg",
			MethodName: "SaveRelaData",
			RelaCode: CV.RelaCode,
			SourceData: _getSrcData(),
			RelaList: relaAry,
			HospId: getHospId()
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "保存成功", type: "success"});
				//保存成功后刷新当前配置数据列表
				_loadResultList();
				return;
			}
			$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
		});
	}
}

// 操作-新增
function _addHandler(row) {
	if(getValueById("ret-type") == "0"){
		$.messager.popover({msg: "当前配置数据列表为无效数据，无法新增，请更改为有效数据", type: "error"});
		return;
	}
	if ((CV.CSPType == "cont")&&(_getSrcData() == "")) {
		$.messager.popover({msg: "请先选择源数据源列表数据后再新增！", type: "error"});
		return;
	}
	var data = $("#resultList").datagrid("getData");
	if ((CV.DataMulFlag == 0) && (data.total > 0)) {
		$.messager.popover({msg: "该配置点不允许多选，如需多选请修改配置点选项是否支持多选！", type: "info"});
		return;
	}
	if ($.hisui.indexOfArray(data.rows, 'id', row.id) != -1) {
		$.messager.popover({msg: "<font color=\"red\">" + row.text + "</font>已存在，不能重复添加", type: "info"});
		return;
	}
	// 对照类型的将源数据列表的字段加至配置数据列表
	if(CV.CSPType == "cont"){
		var srcRow = $("#sourceList").datagrid("getSelected");
		row.srcData = srcRow.id;
		row.srcCode = srcRow.code;
		row.srcDesc = srcRow.text;
	}
	// 新增操作时将 updateFlag 设置为 2
	row.updateFlag = 2;
	$("#resultList").datagrid("appendRow", row);
	var index = $("#resultList").datagrid("getRows").length - 1;
	$("#resultList").datagrid("checkRow", index).datagrid("scrollTo", index);
};

// 操作-删除
function _delHandler(index,row) {
	if(getValueById("ret-type") == "0"){
		$.messager.popover({msg: "无效数据不能删除！", type: "error"});
		return;
	}
	var flag = true;
	var msg = "";
	// 开发级别的配置点删除操作需要进行密码校验
	if (row.updateFlag == 2){//新增后直接删除不进行判断、调用
		deleteData();
	}else{
		if (CV.UpdLevelFlag == "1"){
			if (GV.PassFlag == "Y"){
				deleteData();
			}else{
				$.messager.prompt("提示", "请输入密码", function (r) {
					if (r) {
						var PassWardFlag =  $.m({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "CheckPassword", Password: r}, false);
						if (+PassWardFlag){
							GV.PassFlag = "Y";
							deleteData();
						}else{
							$.messager.alert('错误','密码错误','error');	
						}
					}
				})
			}
		}else{
			deleteData();
		}
	}
	function deleteData(){
		$.messager.confirm("确定", "是否删除该条数据？", function(r) {
			if (r) {
				if (row.updateFlag == 2) {//新增后直接删除不进行判断、调用
					delGrid(flag,msg);
				}else{
					$.m({
						ClassName: "BILL.CFG.COM.GeneralCfg",
						MethodName: "DeleteRelaData",
						RelaCode: CV.RelaCode,
						SrcData: ((row.srcData) ? row.srcData : ""),
						TgtData: row.id,
						HospId: getHospId()
					}, function(rtn) {
						var myAry = rtn.split("^");
						if (myAry[0] != 0) { 
							flag = false;
							msg = myAry[1] || myAry[0];
						}
						delGrid(flag,msg);
					});	
				}			
			}
		})
	}
	// 配置数据表删除对应行数据
	function delGrid(flag,msg){
		if (flag) {
			$.messager.popover({msg: "删除成功", type: "success"});
			$("#resultList").datagrid("deleteRow", index);
			var data = $("#resultList").datagrid("getData");
			$("#resultList").datagrid("loadData", data);
			return;
		}
		$.messager.popover({msg: "删除失败:" + msg, type: "error"});
	}
	// 弹框焦点在取消
	var okSpans = $(".l-btn-text");
	var len = okSpans.length;
	for(var i = 0; i < len; i++){
		var $okSpan = $(okSpans[i]);
		var okSpanHtml = $okSpan.html();
		if(okSpanHtml == "Cancel"|| okSpanHtml == "取消"){
			$okSpan.parent().parent().trigger("focus");
		}
	}
};

// 导入方法
function importClick(){
	var GlobalDataFlg = "0"; //是否保存到临时global的标志 1 保存到临时global 0 保存到表中(必须有类名和方法名)
	var ClassName = CV.ResClassName; //导入处理类名
	var MethodName = CV.ImportMethod; //导入处理方法名
	var ExtStrPam = CV.RelaCode+"^"+getHospId(); //备用参数(代码+院区指针)
	ExcelImport(GlobalDataFlg, ClassName, MethodName, ExtStrPam,_loadResultList);
}

// 上移 下移 方法相关
/*
GV.DOMList = $HUI.datagrid("#resultList")		
//上移
$HUI.linkbutton("#btn-moveUp", {
	onClick: function () {
		moveUpClick();
	}
});

//下移
$HUI.linkbutton("#btn-moveDown", {
	onClick: function () {
		moveDownClick();
	}
});
// 上移
function moveUpClick() {
	var row = GV.DOMList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要移动的行",type: "info"});
		return;
	}
	var index = GV.DOMList.getRowIndex(row);
	var rows = GV.DOMList.getRows();
	if (index > 0) {
		var required = getCKEditorCellVal(index, "required");
		var disabled = getCKEditorCellVal(index, "disabled");
		var focus = getCKEditorCellVal(index, "focus");
		
		var upRequired = getCKEditorCellVal(index - 1, "required");
		var upDisabled = getCKEditorCellVal(index - 1, "disabled");
		var upFocus = getCKEditorCellVal(index - 1, "focus");
		
		var upRow = rows[index - 1];
		rows[index] = upRow;
		rows[index - 1] = row;
		
		// 两行数据交换的时候，需要更改updateFlag、交换序号	wzh
		var indexTmp = rows[index].seqNum
		rows[index].seqNum = rows[index - 1].seqNum
		rows[index - 1].seqNum = indexTmp
		rows[index].updateFlag = 1
		rows[index - 1].updateFlag = 1
		
		GV.DOMList.refreshRow(index);
		GV.DOMList.refreshRow(index - 1);
		
		setCKEditorCellVal(index, "required", upRequired);
		setCKEditorCellVal(index, "disabled", upDisabled);
		setCKEditorCellVal(index, "focus", upFocus);
		
		setCKEditorCellVal(index - 1, "required", required);
		setCKEditorCellVal(index - 1, "disabled", disabled);
		setCKEditorCellVal(index - 1, "focus", focus);
		
		GV.DOMList.selectRow(index - 1);
	}
}
// 下移
function moveDownClick() {
	var row = GV.DOMList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要移动的行", type: "info"});
		return;
	}
	var index = GV.DOMList.getRowIndex(row);
	var rows = GV.DOMList.getRows();
	if ((index + 1) < rows.length) {
		var required = getCKEditorCellVal(index, "required");
		var disabled = getCKEditorCellVal(index, "disabled");
		var focus = getCKEditorCellVal(index, "focus");
		
		var downRequired = getCKEditorCellVal(index + 1, "required");
		var downDisabled = getCKEditorCellVal(index + 1, "disabled");
		var downFocus = getCKEditorCellVal(index + 1, "focus");
		
		var downRow = rows[index + 1];
		rows[index + 1] = row;
		rows[index] = downRow;
		
		// 两行数据交换的时候，需要更改updateFlag、交换序号	wzh
		var indexTmp = rows[index].seqNum
		rows[index].seqNum = rows[index + 1].seqNum
		rows[index + 1].seqNum = indexTmp
		rows[index].updateFlag = 1
		rows[index + 1].updateFlag = 1
		
		GV.DOMList.refreshRow(index);
		GV.DOMList.refreshRow(index + 1);
		
		setCKEditorCellVal(index, "required", downRequired);
		setCKEditorCellVal(index, "disabled", downDisabled);
		setCKEditorCellVal(index, "focus", downFocus);
		
		setCKEditorCellVal(index + 1, "required", required);
		setCKEditorCellVal(index + 1, "disabled", disabled);
		setCKEditorCellVal(index + 1, "focus", focus);
		
		GV.DOMList.selectRow(index + 1);
	}
}
// 获取行编辑checkbox对象
function getCKEditorCellObj(rowIndex, fieldName) {
	return GV.DOMList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + rowIndex + "] td[field=" + fieldName + "] input:checkbox");
}
// 获取行编辑checkbox值
function getCKEditorCellVal(rowIndex, fieldName) {
	var obj = GV.DOMList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + rowIndex + "] td[field=" + fieldName + "] input:checked");
	return $(obj).prop("checked");
}

// 给行编辑checkbox赋值
function setCKEditorCellVal(rowIndex, fieldName, value) {
	var obj = getCKEditorCellObj(rowIndex, fieldName);
	return $(obj).prop("checked", value);
}
*/
