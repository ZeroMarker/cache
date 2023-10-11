/**
 * dhcinsu.datacycle.js
 * 医保数据生命周期查询
 * tangzf 20200703
 */
 var PUBLIC_CONSTANT = {
	SESSION: {
		USERID: session['LOGON.USERID'],
		USERCODE: session['LOGON.USERCODE'],
		USERNAME: session['LOGON.USERNAME'],
		GROUPID: session['LOGON.GROUPID'],
		GROUPDESC: session['LOGON.GROUPDESC'],
		CTLOCID: session['LOGON.CTLOCID'],
		WARDID: session['LOGON.WARDID'],
		HOSPID: session['LOGON.HOSPID'],
		LANGID: session['LOGON.LANGID']
	}
}
//界面入口
$(function(){
	// 操作类型
	ini_OptType();
		
	// 操作员
	ini_User();
	
	// 字典类型
	ini_DicType();
	
	//默认时间
	setDateBox();
	
	// grid
	init_dg();
	
	// 表名
	init_TableName();

	//回车查询事件 +tanfb 2023/4/20
	$("#KeyCode").keydown(function (e){
    	var key = websys_getKey(e);
    	if (key == 13)
    	{
        	RunQuery();
    	}
	});
	
});
//数据面板
function init_dg(){
	$HUI.datagrid("#dg", {
		fit: true,
		//fitColumns:true,
		border:false,
		nowrap: true,
		striped: true,
		pagination: true,
		singleSelect: true,
		pageSize:50,
		pageList: [50,100,150],
		columns: [[
			{ title: '数据ID', field: 'DataTableId', width: 70 },
			{ title: '表名', field: 'DataTableName', width: 140},
			{ title: '表名(汉字)', field: 'DicDesc', width: 140},
			{ title: '操作类型', field: 'DataOptType', width: 70 },
			{ title: '操作日期', field: 'DataDate', width: 100 },
			{ title: '操作时间', field: 'DataTime', width: 70 },
			{ title: '修改内容(双击查看详细)', field: 'CompareInfo', width: 500,formatter: function(value){
				  return "<span title='" + value + "'>" + value + "</span>";	
			}
			},
			{ title: '原始数据(双击查看详细)', field: 'DataStr', width: 700, formatter: function(value){
				 return "<span title='" + value + "'>" + value + "</span>";
				
			}
			},
			{ title: '新数据(双击查看详细)', field: 'NewDataStr', width: 400, formatter: function(value){
				 return "<span title='" + value + "'>" + value + "</span>";
				}
			},
			{ title: '操作员', field: 'DataUser', width: 90,hidden:true },
			{ title: '字典类型', field: 'DataDicType', width: 90,hidden:true }
			
		]],
		data:[],
		onDblClickCell:function(index,cell,val){
			if(cell == 'DataStr' || cell =="CompareInfo" || cell =="NewDataStr"){
				$.messager.popover({
					msg: val,
					type:'info',
					timeout: 5000
					
				});
			}	
		}
	});
	
}
function hoveringShow(value) {
     return "<span title='" + value + "'>" + value + "</span>";
}
function Export(){
	//
	var rtn = tkMakeServerCall("websys.Query","ToExcel","excelname","web.DHCINSUBase","QueryINSUDataCycle",getValueById('StartDate'),getValueById('EndDate'),getValueById('TableName'),getValueById('UserCode'),getValueById('OptType'),PUBLIC_CONSTANT.SESSION.HOSPID, $('#DicType').combobox('getValue'));
	location.href = rtn;
	/*$cm({
		//ResultSetType:"ExcelPlugin",  //表示通过DLL生成Excel，可支持IE与Chrome系。Chrome系浏览器请安装中间件
		//ResultSetTypeDo:"Print",    //默认Export，可以设置为：Print
		//localDir:"D:\\tmp\\",	      //固定文件路径
		localDir:"Self",            //用户选择路径
		//localDir:""   ,              //默认桌面
		ExcelName:"医保数据日志",				 //默认DHCCExcel
		ClassName:"web.DHCINSUBase",
		QueryName:"QueryINSUDataCycle",
		StartDate : getValueById('StartDate'),
		EndDate : getValueById('EndDate'),
		TableName : getValueById('TableName'),
		UserCode : getValueById('UserCode'),
		OptType : getValueById('OptType'),
		DicType : $('#DicType').combobox('getValue'),
		HospId : PUBLIC_CONSTANT.SESSION.HOSPID	
	});	*/
}
//查询
function RunQuery() {
	if(getValueById('TableName') == ''){
		$.messager.alert('提示','表名不能为空','info');
		return;		
	}
	var checkStDate = tkMakeServerCall("websys.Conversions","DateHtmlToLogical",getValueById('StartDate'));
	var checkEndDate = tkMakeServerCall("websys.Conversions","DateHtmlToLogical",getValueById('EndDate'));
	if((checkEndDate - checkStDate)>31){
		$.messager.alert('提示','最多查询一个月的数据','error');
		return;		
	}
	clearGrid();
	var queryParams = {
		ClassName : 'web.DHCINSUBase',
		QueryName : 'QueryINSUDataCycle',
		StartDate : getValueById('StartDate'),
		EndDate : getValueById('EndDate'),
		ParamClassName : getValueById('TableName'),
		UserCode : getValueById('UserCode'),
		OptType : getValueById('OptType'),
		ExpStr : $('#DicType').combobox('getValue'),
		KeyCode : getValueById('KeyCode'),
		HospId : PUBLIC_CONSTANT.SESSION.HOSPID	
	}
	loadDataGridStore('dg',queryParams);
}
// 配置
function Config() {
		websys_showModal({
		url : 'dhcinsu.pageconfig.csp?ParamHospId=' + PUBLIC_CONSTANT.SESSION.HOSPID + '&ParamPageName=' + 'dhcinsu.datacycle',
		title : '界面配置',
		iconCls:'icon-edit',
		width:'390' ,
		height:'212',
		callbackFunc:function(val){
		},
		onBeforeClose:function(){
			$('#TableName').combobox('reload');
		}
	})

}
//默认时间
function setDateBox() {
	setValueById('StartDate',getDefStDate(-31));
	setValueById('EndDate',getDefStDate(0));
}

//清屏
function clear_click() {
	$('.search-table').form('clear');
}
// 字典类型
function ini_DicType() {
	//初始化combogrid
	$HUI.combogrid("#DicType",{  
	    panelWidth:520,   
	    panelHeight:300,  
	    idField:'INDIDDicCode',   
	    textField:'INDIDDicDesc', 
        pagination: false,
        delay:800,
	    columns:[[   
	        {field:'INDIDDicCode',title:'代码',width:160},  
	        {field:'INDIDDicDesc',title:'名称',width:210},
	        {field:'INDIDDicDemo',title:'备注',width:110}    
	    ]],
        keyHandler:{  
			up: function(){},  
			down: function(){},  
			enter: function(){},  
			query:function(q){ 
				$(this).combogrid('grid').datagrid('unselectAll');
				//异步加载
				$.cm({
					ClassName:"web.INSUDicDataCom",
					QueryName:"QueryDicSys",
					CodeAndDesc:q,
					queryFlag:"",
					rows:1000
				},function(jsonData){
					$('#DicType').combogrid('grid').datagrid('loadData',jsonData.rows);
					$('#DicType').combogrid('setText',q);
					$('#DicType').combogrid('setValue',q);
				}); 
			}  
		}
	}); 
}
// 操作类型
function ini_OptType() {
	$('#OptType').combobox({
		valueField: 'id',
		textField: 'desc',
		editable:false,
		data:[
			{
				"id":"UPDATE",
				"desc":"更新"
			},
			{
				"id":"DELETE",
				"desc":"删除"	
			},
			{
				"id":"INSERT",
				"desc":"新增"	
			},
			{
				"id":"",
				"desc":"全部",
				selected:true
			}
		
		]
	})
}
function init_TableName(){
	$('#TableName').combobox({
		valueField:'cCode',   
	    textField:'cDesc', 
		editable:false,
		url:$URL,
		onBeforeLoad: function(param) {
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic1';
			param.Type = 'INSUDataCycleConfig';
			param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID	;
			param.ResultSetType = 'array';
			return true;
		},
		onLoadSuccess:function(data){
			if(data.length <1){
				$.messager.alert('提示','请先维护配置:[INSUDataCycleConfig]','info');
			}
		},
		onSelect:function(row){
			if (row.cCode != "User.INSUDicData"){
				$('#DicType').combogrid('setValue','');
				$('#DicType').combogrid('disable',true);
			}else{
				$('#DicType').combogrid('enable',true);	
			}
		}
	})
}
// 操作员
function ini_User() {
	$HUI.combobox(('#UserCode'),{
		defaultFilter:'4',
		valueField: 'TUsrRowid',
		textField: 'TUsrName',
		url:$URL,
		onSelect:function(){
		},
		onLoadSuccess:function(data){

		}
		,onBeforeLoad: function(param) {
			param.ClassName = 'DHCBILLConfig.DHCBILLOthConfig';
			param.QueryName= 'FindGroupUser';
			param.Grp = '';
			param.Usr = "";
			param.HospId = PUBLIC_CONSTANT.SESSION.HOSPID	;
			param.ResultSetType = 'array';
			return true;
		}		
	})
}
function selectHospCombHandle(){
	$('#DicType').combogrid('grid').datagrid('unselectAll');
	setValueById('DicType','');
	
	//异步加载
	$.cm({
		ClassName:"web.INSUDicDataCom",
		QueryName:"QueryDicSys",
		CodeAndDesc:'',
		queryFlag:"",
		rows:1000
	},function(jsonData){		
		$('#DicType').combogrid('grid').datagrid('loadData',jsonData.rows);
	});	
	$('#TableName').combobox('reload');
}
function clearGrid(){
	$('#dg').datagrid('loadData',{total:0,rows:[]});	
}
