/* 
 * FileName:	dhcbillmenu.orderlinktar.js
 * User:		TangTao
 * Date:		2014-04-10
 * Function:	医嘱项关联收费项
 * Description: 
*/

var PUBLIC_CONSTANT={
	SESSION:{
		GROUP_ROWID : session['LOGON.GROUPID'],
        GROUP_DESC : session['LOGON.GROUPDESC'],
        GUSER_ROWID : session['LOGON.USERID'],
        GUSER_NAME : session['LOGON.USERNAME'],
        GUSER_CODE : session['LOGON.USERCODE'],
		HOSPID : session['LOGON.HOSPID']
	},
	URL:{
		QUERY_GRID_URL : "./dhcbill.query.grid.easyuiorder.csp",
		QUERY_COMBO_URL : "./dhcbill.query.combo.easyui.csp",
		METHOD_URL : "./dhc.method.easyui.csp"
	},
	CATE:{
		TARCATE : "",
		TARSUBCATE : "",
		SUBCATEINDEX : "",
		ARCNUM : 6,
		TARNUM : 2,
		ARCTARITEM : 6,
		INSTRUNUM : 0,
		PRIORITYNUM : 0,
		ARCBYTARNUM : 2,
		TABLE : ""
	},
	METHOD:{
		CLS : "DHCBILLConfig.DHCBILLFIND",
		QUERY : "FindArcItm",	// 查询医嘱项
		QUERYARC : "FindArcByTar",	//根据收费项查询医嘱项
		QUERYTAR : "FindTarByArc",	// 根据医嘱项查询收费项
		QUERYTARITEM : "FindTarItem",	// 查询收费项
		QUERYINSTRU : "FindInstru",	// 查询用法
		QUERYPRIORITY : "FindPriority",	// 查询优先级
		INSERT : "InsertOrderLinkTar",
		UPDATE : "UpdateOrderLinkTar",
		DELETE : ""
	}
};

var EditIndex=-1;
var AddFlag=-1;
var TarItemDr="",InsutruRowid="",PriorityRowid="";

$(function(){
	initGrid();
	if(BDPAutDisableFlag('BtnTarAdd')){
		$('#BtnTarAdd').hide();
	}
	if(BDPAutDisableFlag('BtnTarUpdate')){
		$('#BtnTarUpdate').hide();
	}
	if(BDPAutDisableFlag('BtnTarSave')){
		$('#BtnTarSave').hide();
	}
});

function initGrid(){
	// 初始化医嘱项Columns
	var ArcColumns = [[
		{ field: 'TArcCode', id:'ColTArcCode', title: '医嘱项代码', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TArcDesc', title: '医嘱项名称', width: 300, align: 'center', sortable: true, resizable: true },
		{ field: 'TOrderCat', title: '医嘱大类', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TArcItmCat', title: '医嘱子类', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TBillCat', title: '账单子类', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TArcPrice', title: '医嘱价格', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TOwn', title: '是否独立医嘱', width: 80, align: 'center', sortable: true, resizable: true },
		{ field: 'TStDate', title: '开始日期', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'TEndDate', title: '结束日期', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'Tjob', title: 'Tjob', width: 100, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'TArcRowid', title: 'TArcRowid', width: 100, align: 'center', sortable: true, resizable: true, hidden: true }
	]];
	
	// 初始化收费项Columns
	var TarItmColumns = [[
		{ field: 'TarCode', title: '收费项代码', width: 100, editor: 'text', align: 'center', sortable: true, resizable: true },
		{ field: 'TarDesc', title: '收费项名称', width: 300, align: 'center', sortable: true, resizable: true,
			editor:{  
				type:'combobox',  
				options:{
					//url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
					valueField:'rowid',
					textField:'desc',
					required:true,
					keyHandler:{
						enter: function(){
							var TarCodeEd = $('#tTarItem').datagrid('getEditor', {'index':EditIndex,'field':'TarCode'});
							var TarDescEd = $('#tTarItem').datagrid('getEditor', {'index':EditIndex,'field':'TarDesc'});
							var TarCodeEdValue = $(TarCodeEd.target).val();
							var TarDescEdValue = $(TarDescEd.target).combobox('getText');
							$(TarDescEd.target).combobox('clear'); //清除原来的数据
							if ((TarCodeEdValue == "") && (TarDescEdValue == "")){
								$.messager.alert('消息',"请输入别名!");
								return;
							}
							$(TarDescEd.target).combobox({
								url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
								valueField:'rowid',
								textField:'desc',
								width:300,
								//required:true,
								onBeforeLoad:function(param){
									param.ClassName = PUBLIC_CONSTANT.METHOD.CLS;
									param.QueryName = PUBLIC_CONSTANT.METHOD.QUERYTARITEM;
									param.Arg1 = "";	//项目代码
									param.Arg2 = "";			//项目名称 根据输入数据查询
									param.Arg3 = TarDescEdValue;	//别名
									param.Arg4 = "^^^^^^^^^Y";		//入参串
									param.Arg5 = PUBLIC_CONSTANT.SESSION.HOSPID;	//医院ID
									param.Arg6 = PUBLIC_CONSTANT.SESSION.GROUP_ROWID;	//用户ID
									param.ArgCnt = PUBLIC_CONSTANT.CATE.ARCTARITEM;
								}
							});
						},
						query: function(TarIEdValue){
						}
					},
					onSelect:function(rec){
						TarItemDr=rec.rowid	//获取选中的收费项目ID
						var TarCodeED = $('#tTarItem').datagrid('getEditor', {index:EditIndex,field:'TarCode'});
						$(TarCodeED.target).val(rec.code);
					}
				}
			}
		},
		{ field: 'TarQty', title: '数量', width: 100, editor : 'text', align: 'center', sortable: true, resizable: true, required:true },
		{ field: 'TarStDate', title: '开始日期', width: 100, editor : 'datebox', align: 'center', sortable: true, resizable: true, required:true },
		{ field: 'TarEndDate', title: '结束日期', width: 100, editor : 'datebox', align: 'center', sortable: true, resizable: true },
		{ field: 'TarYF', title: '用法', width: 100, align: 'center', sortable: true, resizable: true,
			editor:{  
				type:'combobox',  
				options:{
					url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
					valueField:'InstruRowid',
					textField:'InstruDesc',
					onBeforeLoad:function(param){
						param.ClassName = PUBLIC_CONSTANT.METHOD.CLS;
						param.QueryName = PUBLIC_CONSTANT.METHOD.QUERYINSTRU;
						param.ArgCnt = PUBLIC_CONSTANT.CATE.INSTRUNUM;
					},
					onSelect:function(rec){
						InsutruRowid=rec.InstruRowid	//获取选中的就诊类型ID
					}
				}
			}
		},
		{ field: 'TarPrority', title: '优先级', width: 100, align: 'center', sortable: true, resizable: true,
			editor:{  
				type:'combobox',  
				options:{
					url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
					valueField:'PriorityRowid',
					textField:'PriorityDesc',
					onBeforeLoad:function(param){
						param.ClassName = PUBLIC_CONSTANT.METHOD.CLS;
						param.QueryName = PUBLIC_CONSTANT.METHOD.QUERYPRIORITY;
						param.ArgCnt = PUBLIC_CONSTANT.CATE.PRIORITYNUM;
					},
					onSelect:function(rec){
						PriorityRowid=rec.PriorityRowid	//获取选中的就诊类型ID
					}
				}
			}
		},
		{ field: 'TarPrice', title: '收费项价格', width: 100, align: 'center', sortable: true, resizable: true },
		{ field: 'Oltrowid', title: 'Oltrowid', width: 100, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'TarRowid', title: 'TarRowid', width: 100, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'YFRowid', title: 'YFRowid', width: 100, align: 'center', sortable: true, resizable: true, hidden: true },
		{ field: 'PriorityRowid', title: 'PriorityRowid', width: 100, align: 'center', sortable: true, resizable: true, hidden: true }
	]];

	// 初始化DataGrid
	$('#tArcItem').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		url : '',
		loadMsg : '加载中,请稍后...',  
		pagination : true,  //如果为true，则在DataGrid控件底部显示分页工具栏
		rownumbers : true,  //如果为true，则显示一个行号列。
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns : ArcColumns,
		//toolbar : TarItmToolBar,
		onRowContextMenu : function(e, rowIndex, rowData) {
		},
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			var TArcRowid = rowData.TArcRowid
			var TarStr=TArcRowid+"###"
			initLoadTarGrid(TarStr);
			EditIndex=-1;
		}
	});
	
	// 初始化DataGrid
	$('#tTarItem').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		url : '',
		loadMsg : '加载中,请稍后...',  
		pagination : true,  //如果为true，则在DataGrid控件底部显示分页工具栏
		rownumbers : true,  //如果为true，则显示一个行号列。
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns : TarItmColumns,
		toolbar : '#tToolBar',
		onRowContextMenu : function(e, rowIndex, rowData) {
		},
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){
			EditIndex=-1;	
		}
	});
}

/// 初始化医嘱项
function initLoadArcGrid(ExpStr)
{
	EditIndex=-1;
	AddFlag=-1;
	var SearchArcAlias="",SearchArcCode="",SearchOrdCat="",SearchArcDesc="",SearchArcItmCat;
	if(ExpStr != ""){
		SearchArcAlias = ExpStr.split("###")[0];
		SearchArcCode = ExpStr.split("###")[1];
		SearchOrdCat = ExpStr.split("###")[2];
		SearchArcDesc = ExpStr.split("###")[3];
		SearchArcItmCat = ExpStr.split("###")[4];
	}
	var queryParams = new Object();
	queryParams.ClassName = PUBLIC_CONSTANT.METHOD.CLS;
	queryParams.QueryName = PUBLIC_CONSTANT.METHOD.QUERY;
	queryParams.Arg1 = SearchArcAlias;	//项目别名
	queryParams.Arg2 = SearchArcCode;	//项目代码
	queryParams.Arg3 = SearchOrdCat;	//医嘱大类
	queryParams.Arg4 = SearchArcDesc;	//项目名称
	queryParams.Arg5 = SearchArcItmCat;	//医嘱子类
	queryParams.Arg6 = PUBLIC_CONSTANT.SESSION.HOSPID;	//医院
	queryParams.ArgCnt = PUBLIC_CONSTANT.CATE.ARCNUM;
	loadDataGridStore("tArcItem", queryParams);
}

/// 初始化收费项
function initLoadTarGrid(ExpStr)
{
	EditIndex=-1;
	AddFlag=-1;
	var SearchArcRowid="";
	if(ExpStr != ""){
		SearchArcRowid = ExpStr.split("###")[0];
	}
	var queryParams = new Object();
	queryParams.ClassName = PUBLIC_CONSTANT.METHOD.CLS;
	queryParams.QueryName = PUBLIC_CONSTANT.METHOD.QUERYTAR;
	queryParams.Arg1 = SearchArcRowid;	//医嘱项ID
	queryParams.Arg2 = PUBLIC_CONSTANT.SESSION.HOSPID;	//医院
	queryParams.ArgCnt = PUBLIC_CONSTANT.CATE.TARNUM;
	loadDataGridStore("tTarItem", queryParams);
}

///加载DataGrid数据
function loadDataGridStore(DataGridID, queryParams){
	var jQueryGridObj = jQuery("#" + DataGridID);
	var opts = jQueryGridObj.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	jQueryGridObj.datagrid('load', queryParams);
}

$('#BtnFind').bind('click', function(){
	FindClick();
});

$('#BtnClear').bind('click', function(){
	location.reload();
}); 

$('#BtnTarAdd').bind('click', function(){
	var selected = $('#tArcItem').datagrid('getSelected');
	if(!selected){
		$.messager.alert('消息',"请选择一条医嘱项再添加收费项!");
		return;
	}
	lastIndex = $('#tTarItem').datagrid('getRows').length-1;  
	$('#tTarItem').datagrid('selectRow', lastIndex);
	var selected = $('#tTarItem').datagrid('getSelected');
	if (selected){
		if(typeof(selected.TarRowid) == "undefined"){
			$.messager.alert('消息',"不能同时添加多条!");
			return;
		}
	}
	if((EditIndex>=0)){
		$.messager.alert('消息',"一次只能修改一条记录!");
		return;
	}
	$('#tTarItem').datagrid('appendRow',{  
		TarCode : '',
		TarDesc : '',
		TarQty : '',
		TarStDate : '',
		TarEndDate : '',
		TarYF : '',
		TarPrority : ''
	});
	lastIndex = $('#tTarItem').datagrid('getRows').length-1;  
	$('#tTarItem').datagrid('selectRow', lastIndex);
	$('#tTarItem').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
	AddFlag = 0;
	var TarCodeEd = $('#tTarItem').datagrid('getEditor', {'index':EditIndex,'field':'TarCode'});
	var TarDescEd = $('#tTarItem').datagrid('getEditor', {'index':EditIndex,'field':'TarDesc'});
	////为可编辑框绑定keyup事件事件
	$(TarCodeEd.target).keyup(function(a){
		SearchByCode();
	});
	/*
	$(TarDescEd.target).keyup(function(){
		ClearDesc();
	});*/
});

$('#BtnTarUpdate').bind('click', function(){
	var selected = $('#tArcItem').datagrid('getSelected');
	if(!selected){
		$.messager.alert('消息',"请选择一条医嘱项再修改收费项!");
		return;
	}
	var selected = $('#tTarItem').datagrid('getSelected');
	if (selected){
		var thisIndex = $('#tTarItem').datagrid('getRowIndex',selected);
		if((EditIndex!=-1) && (EditIndex!=thisIndex)){
			$.messager.alert('消息',"一次只能修改一条记录!");
			return;
		}
		$('#tTarItem').datagrid('beginEdit', thisIndex);
		EditIndex=thisIndex;
		TarItemDr=selected.TarRowid;
		InsutruRowid=selected.YFRowid;
		PriorityRowid=selected.PriorityRowid;
		//$('#tTarItem').datagrid('removeEditor', 'TarCode');
		var TarCodeEd = $('#tTarItem').datagrid('getEditor', {'index':EditIndex,'field':'TarCode'});
		$(TarCodeEd.target)[0].disabled=true;	// 可编辑行的某Textbox列不可编辑,上下两种都可以
		//$(TarCodeEd.target).attr("readonly",true);	// 可编辑行的某Textbox列不可编辑,上下两种都可以
		var TarDescEd = $('#tTarItem').datagrid('getEditor', {'index':EditIndex,'field':'TarDesc'});
		$(TarDescEd.target).combobox({width:300,disabled: true});
		var TarStDateEd = $('#tTarItem').datagrid('getEditor', {'index':EditIndex,'field':'TarStDate'});
		$(TarStDateEd.target).datebox('disable');
		var TarYFEd = $('#tTarItem').datagrid('getEditor', {'index':EditIndex,'field':'TarYF'});
		$(TarYFEd.target).combobox({width:100,disabled: true});
		var TarProrityEd = $('#tTarItem').datagrid('getEditor', {'index':EditIndex,'field':'TarPrority'});
		$(TarProrityEd.target).combobox({width:100,disabled: true});
		AddFlag = 1;
	}else{
		$.messager.alert('消息',"请选择一条收费项!")
	}
});

$('#BtnTarSave').bind('click', function(){
	$('#tTarItem').datagrid('acceptChanges');
	$('#tTarItem').datagrid('selectRow',EditIndex);
	var selected = $('#tTarItem').datagrid('getSelected');
	if (selected){
		var selectedArc = $('#tArcItem').datagrid('getSelected');
		if(!selectedArc){
			$.messager.alert('消息',"请选择一条医嘱项再保存收费项!");
			return;
		}
		if(typeof(selected.Oltrowid) == "undefined"){
			if((TarItemDr == "undefined") || (TarItemDr == "") || (typeof(TarItemDr) == "undefined")){
				$.messager.alert('消息',"收费项ID为空,请选择收费项!");
				EditIndex=-1;
				AddFlag=-1;
				TarItemDr="",InsutruRowid="",PriorityRowid="";
				var ArcRowid=selectedArc.TArcRowid;
				var ExpStr=ArcRowid+"###"
				initLoadTarGrid(ExpStr);
				return;
			}
			if((selected.TarQty == "") || (selected.TarStDate == "")){
				$.messager.alert('消息',"收费项数量和开始日期不能为空,请重新填写!");
				EditIndex=-1;
				AddFlag=-1;
				TarItemDr="",InsutruRowid="",PriorityRowid="";
				var ArcRowid=selectedArc.TArcRowid;
				var ExpStr=ArcRowid+"###"
				initLoadTarGrid(ExpStr);
				return;
			}
			var OltInfo=selectedArc.TArcRowid+"^"+TarItemDr+"^"+selected.TarStDate+"^"+selected.TarEndDate;
			OltInfo=OltInfo+"^"+selected.TarQty+"^"+selected.TarPrice+"^"+selected.TarYF;
			OltInfo=OltInfo+"^"+selected.TarPrority
			$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.INSERT,"false",function testget(value){
				if(value=="0"){$.messager.alert('消息',"保存成功!");
				}else{$.messager.alert('消息',"保存失败,错误代码:"+value);
				}
				EditIndex=-1;
				AddFlag=-1;
				TarItemDr="",InsutruRowid="",PriorityRowid="";
				var ArcRowid=selectedArc.TArcRowid;
				var ExpStr=ArcRowid+"###"
				initLoadTarGrid(ExpStr);
			},"","",OltInfo,PUBLIC_CONSTANT.SESSION.GUSER_ROWID,PUBLIC_CONSTANT.SESSION.HOSPID);
		}else{
			$('#tTarItem').datagrid('selectRow',EditIndex);
			var selected = $('#tTarItem').datagrid('getSelected');
			if((TarItemDr == "undefined") || (TarItemDr == "") || (typeof(TarItemDr) == "undefined")){
				$.messager.alert('消息',"收费项ID为空,请选择收费项!");
				EditIndex=-1;
				AddFlag=-1;
				TarItemDr="",InsutruRowid="",PriorityRowid="";
				var ArcRowid=selectedArc.TArcRowid;
				var ExpStr=ArcRowid+"###"
				initLoadTarGrid(ExpStr);
				return;
			}
			if((selected.TarQty == "") || (selected.TarStDate == "")){
				$.messager.alert('消息',"收费项数量和开始日期不能为空,请重新填写!");
				EditIndex=-1;
				AddFlag=-1;
				TarItemDr="",InsutruRowid="",PriorityRowid="";
				var ArcRowid=selectedArc.TArcRowid;
				var ExpStr=ArcRowid+"###"
				initLoadTarGrid(ExpStr);
				return;
			}

			var OltInfo=selectedArc.TArcRowid+"^"+TarItemDr+"^"+selected.TarStDate+"^"+selected.TarEndDate;
			OltInfo=OltInfo+"^"+selected.TarQty+"^"+selected.TarPrice+"^"+InsutruRowid;
			OltInfo=OltInfo+"^"+PriorityRowid+"^"+selected.Oltrowid
			$.dhc.util.runServerMethod(PUBLIC_CONSTANT.METHOD.CLS,PUBLIC_CONSTANT.METHOD.UPDATE,"false",function testget(value){
				if(value=="0"){$.messager.alert('消息',"修改成功!");
				}else{$.messager.alert('消息',"修改失败,错误代码:"+value);
				}
				EditIndex=-1;
				AddFlag=-1;
				TarItemDr="",InsutruRowid="",PriorityRowid="";
				var ArcRowid=selectedArc.TArcRowid;
				var ExpStr=ArcRowid+"###"
				initLoadTarGrid(ExpStr);
			},"","",OltInfo,PUBLIC_CONSTANT.SESSION.GUSER_ROWID,PUBLIC_CONSTANT.SESSION.HOSPID);
		}
	}
});

$('#BtnTarFind').bind('click', function(){
	var selected = $('#tArcItem').datagrid('getSelected');
	if(!selected){
		$.messager.alert('消息',"请选择一条医嘱项!")
		return;
	}
	var TArcRowid = selected.TArcRowid;
	var TarStr=TArcRowid+"###";
	EditIndex=-1;
	AddFlag=-1;
	initLoadTarGrid(TarStr);
});

$('#BtnArcTarFind').bind('click', function(){
	var selected = $('#tTarItem').datagrid('getSelected');
	if(!selected){
		$.messager.alert('消息',"请选择一条收费项!");
		return;
	}
	var TarRowid = selected.TarRowid;
	
	var queryParams = new Object();
	queryParams.ClassName = PUBLIC_CONSTANT.METHOD.CLS;
	queryParams.QueryName = PUBLIC_CONSTANT.METHOD.QUERYARC;
	queryParams.Arg1 = TarRowid;	//收费项ID
	queryParams.Arg2 = PUBLIC_CONSTANT.SESSION.HOSPID;	//医院
	queryParams.ArgCnt = PUBLIC_CONSTANT.CATE.ARCBYTARNUM;
	loadDataGridStore("tArcItem", queryParams);
});

$('#TxtArcCode').keyup(function(){
	if(event.keyCode==13){
		FindClick();
	}
});

$('#TxtArcAlias').keyup(function(){
	if(event.keyCode==13){
		FindClick();
	}
});

$('#TxtArcDesc').keyup(function(){
	if(event.keyCode==13){
		FindClick();
	}
});

function FindClick()
{
	var TxtArcCode=$('#TxtArcCode').val();
	var TxtArcAlias=$('#TxtArcAlias').val();
	var TxtArcDesc=$('#TxtArcDesc').val();
	var ComboOrdCat=$('#ComboOrdCat').combobox('getValue');
	var ComboArcItmCat=$('#ComboArcItmCat').combobox('getValue');
	var TarStr=TxtArcAlias+"###"+TxtArcCode+"###"+ComboOrdCat+"###"+TxtArcDesc+"###"+ComboArcItmCat;
	initLoadArcGrid(TarStr);
}

function SearchByCode(){
	var event=window.event;
	if(event.keyCode == 13){
		if((EditIndex != -1)&(AddFlag == 0)){	//AddFlag 为0说明是增加
			var TarCodeEd = $('#tTarItem').datagrid('getEditor', {'index':EditIndex,'field':'TarCode'});
			if(!TarCodeEd){return;}
			var TarDescEd = $('#tTarItem').datagrid('getEditor', {'index':EditIndex,'field':'TarDesc'});
			$(TarDescEd.target).combobox('clear'); //清除原来的数据
			var TarCodeEdValue = $(TarCodeEd.target).val();
			var TarDescEdValue = $(TarDescEd.target).combobox('getText');
			if ((TarCodeEdValue == "") && (TarDescEdValue == "")){
				return;
			}
			$(TarDescEd.target).combobox({
				url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
				valueField:'rowid',
				textField:'desc',
				width:300,
				//required:true,
				onBeforeLoad:function(param){
					param.ClassName = PUBLIC_CONSTANT.METHOD.CLS;
					param.QueryName = PUBLIC_CONSTANT.METHOD.QUERYTARITEM;
					param.Arg1 = TarCodeEdValue;	//项目代码
					param.Arg2 = "";			//项目名称 根据输入数据查询
					param.Arg3 = "";	//别名
					param.Arg4 = "^^^^^^^^^Y";		//入参串
					param.Arg5 = PUBLIC_CONSTANT.SESSION.HOSPID;	//医院ID
					param.Arg6 = PUBLIC_CONSTANT.SESSION.GROUP_ROWID;	//用户ID
					param.ArgCnt = PUBLIC_CONSTANT.CATE.ARCTARITEM;
				}
			});
		}
	}
}

$('#BtnExportLink').bind('click', function(){
	EportLink();
});

///导出关联关系
function EportLink(){
 	var job="";
	var rows = $('#tArcItem').datagrid('getRows').length;
	if(rows!=""){
		$('#tArcItem').datagrid('selectRow',0);
		var selected = $('#tArcItem').datagrid('getSelected');
		job = selected.Tjob
	}
	if(job == ""){$.messager.alert('消息',"获取导出数据失败!");return;}
	//获取模板路径
	var path=tkMakeServerCall("DHCBILLConfig.DHCBILLFIND","GetPath");
	if(path==""){$.messager.alert('消息',"获取模板路径失败!");return;}
	var datanum=tkMakeServerCall("DHCBILLConfig.DHCBILLFIND","GetOrderLinkTarInfo",PUBLIC_CONSTANT.SESSION.GUSER_ROWID,job,PUBLIC_CONSTANT.SESSION.HOSPID)
	if((datanum=="") || (datanum==0)){$.messager.alert('消息',"没有需要导出的收费项!");return;}
	var datanum=eval(datanum);
	var Template=path+"ExportLink.xls"
	var xlApp = new ActiveXObject("Excel.Application");//不支持Google浏览器，只支持IE
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet
	xlApp.Visible=true;
	for ( i=1 ; i <= datanum ; i++){
		var value=tkMakeServerCall("DHCBILLConfig.DHCBILLFIND","GetLinkData",PUBLIC_CONSTANT.SESSION.GUSER_ROWID,job,i)
		var ValueStr=value.split("^");
		var Vlen=ValueStr.length;
		for(j = 0; j < Vlen; j++){
			xlsheet.cells(i,j+1).value=ValueStr[j];
		}
	}
	//Grid(xlsheet,1,1,datanum,Vlen)
	//xlsheet.PrintPreview();
	xlBook.Close (savechanges=true);
	xlApp.Quit();
	xlApp=null;
	xlBook=null;
	xlsheet=null;
}

/*
function ClearDesc()
{
	var event=window.event;
	alert(event.keyCode)
	if((event.keyCode == 8) || (event.keyCode == 46)){
		if((EditIndex != -1)&(AddFlag == 0)){	//AddFlag 为0说明是增加
			var TarCodeEd = $('#tTarItem').datagrid('getEditor', {'index':EditIndex,'field':'TarCode'});
			if(!TarCodeEd){return;}
			var TarDescEd = $('#tTarItem').datagrid('getEditor', {'index':EditIndex,'field':'TarDesc'});
			var TarCodeEdValue = $(TarCodeEd.target).val();
			var TarDescEdValue = $(TarDescEd.target).combobox('getText');
			alert(TarDescEdValue)
			if (TarDescEdValue == ""){
				$(TarCodeEd.target).val('');
				$(TarDescEd.target).combobox('clear');
			}
		}
	}
}	*/