function log(val) {
	//console.log(val);
}
var GroupSelectID="" ;
var FIXEDNUM = 2;
var SessionObj = {
	guser : curUserID,
	group : session['LOGON.GROUPID'],
	ctLoc : curLocID,
	LANGID : session['LOGON.LANGID']
}
var QUERY_URL = {
	QUERY_GRID_URL : "./dhceq.jquery.grid.easyui.csp",
	QUERY_COMBO_URL : "./dhceq.jquery.combo.easyui.csp"
};
/*var GlobalObj = {
	patientId : "",
	clearGlobal : function(){
		this.patientId = "";
		this.episodeId = "";
		this.billId  = "";
		this.prtId = "";
		this.balance = 99999;
	}
}
*/
//界面入口
jQuery(document).ready(function(){
	setTimeout("initDocument();",50);
});

function initDocument() {
	//GlobalObj.clearGlobal();
	initPanel();
	initMoveListData();
	//setFocus("GroupText");
}


function initPanel() {
	initTopPanel();
	//initGroupListPanel();
	initMoveListPanel();  //注意位置，要放到最后
}

//初始化查询头面板
function initTopPanel() {
	jQuery("#btnQuery").linkbutton({
		iconCls: 'icon-search'
	});
	jQuery("#btnQuery").on("click", QueryMoveClick);
	initObjType();
	initSourceType();
	initEventType();
	initStatus();
	initDeptType("FromDeptType");
	initDeptType("ToDeptType");
	initLocationDR("FromLocationDR");
	initLocationDR("ToLocationDR");
	initUserDR("SendUserDR");
	initUserDR("AcceptUserDR");
	setDefVal();
}
function initLocationDR(comboxid) {
	jQuery("#"+comboxid).combobox({
		url:'dhceq.jquery.operationtype.csp?&action=GetLocation',
	    valueField: 'id',    
	    textField: 'text'
	});
}
function initUserDR(comboxid) {
	jQuery("#"+comboxid).combobox({
		url:'dhceq.jquery.operationtype.csp?&action=GetUser',
	    valueField: 'id',    
	    textField: 'text'
	});
}	
function initDeptType(comboxid){
	jQuery("#"+comboxid).combobox({
		fit: true,
		height: 24,
		multiple: false,
		//editable: false,
		disabled: false,
		readonly: false,
    	valueField:'id', 
    	url:null,   
    	textField:'text',
		data: [{
			id: '',
			text: ''
		},{
			id: '1',
			text: '科室'
		},{
			id: '2',
			text: '服务商'
		},{
			id: '3',
			text: '供应商'
		},{
			id: '4',
			text: '生产厂商'
		}],
		onSelect: function(record) {
			//initMoveListData();
		}
	});
}
function initMoveListPanel() {
	var editRow = undefined;
	jQuery('#tMoveList').datagrid({
		fit:true,
		border:false,
		checkOnSelect: false, 
		selectOnCheck: false,
		striped: true,
		singleSelect : true,
		url: null,
		fitColumns:false,
		autoRowHeight:true,
		remoteSort:false,
		cache: false,
		singleSelect:true,
		loadMsg:'Loading…',
		pagination: true,
		pageSize:20,
		rownumbers: true,  //如果为true，则显示一个行号列。
		columns:[[  
			{ title: 'Rowid', field: 'rowid',halign:"center", width:10, hidden: true},
			{ title: '操作', field: 'opt', width: 60, halign: 'center', formatter: fomartOperation },
			{ title: '移动单号', field: 'no' ,halign:"center", width:120},
			{ title: '物体类型',  field: 'objtype' ,halign:"center", width:60, hidden: true},
			{ title: '物体ID', field: 'objid',halign:"center", width:30, hidden:true},
			{ title: '设备名称', field: 'equipname',halign:"center", width:120},
			{ title: '设备编号', field: 'equipno',halign:"center", width:200},
			{ title: '对应事件', field: 'sourcetype',halign:"center", width:60},
			{ title: '业务ID',  field: 'sourceid',align: "right",halign:"center", width:50, hidden:true },
			{ title: '移动缘由', field: 'eventype',align: "right",halign:"center", width:60 },
			{ title: '初始单位类型',  field: 'fromdepttype' ,align: "right",halign:"center", width:80 },
			{ title: '原单位ID', field: 'fromdeptid',align: "right" ,halign:"center", width:50, hidden:true},
			{ title: '初始位置', field: 'fromlocation' ,align: "right" ,halign:"center", width:100},
			{ title: '开始日期', field: 'startdate',align: "right" ,halign:"center", width:80},
			{ title: '移动原因', field: 'movereason',halign:"center", width:80 , hidden:true},
			{ title: '送出负责人',  field: 'senduser' ,halign:"center", width:80},
			{ title: '目的单位类型', field: 'todepttype',halign:"center", width:80},
			{ title: '目的单位ID', field: 'todeptid',halign:"center", width:80, hidden:true },
			{ title: '目的位置', field: 'tolocation',halign:"center", width:100},
			{ title: '完成日期', field: 'enddate',align: "right" ,halign:"center", width:80},
			{ title: '接收负责人',  field: 'acceptuser',halign:"center", width:80 },
			{ title: '备注', field: 'remark',halign:"center", width:220},
			{ title: 'statusdr', field: 'statusdr',halign:"center", width:30, hidden: true },
			{ title: '状态', field: 'status',halign:"center", width:50 },
			{ title: 'invalidflag', field: 'invalidflag',halign:"center", width:30, hidden: true },
			{ title: '无效原因', field: 'invalidreason',halign:"center", width:220, hidden: true},
		]],
		onBeforeLoad: function(param) {
			//目的是为了防止loadData时，设置url加载两次
			if(param.ArgCnt == undefined) {
				return false;
			}
		},
		onLoadError: function() {
			jQuery.messager.alert('错误', '加载列表失败.');
		},
		onSelect: function(rowIndex, rowData) {		
		}
	}); 
}
function fomartOperation(value, rowData, rowIndex) {//生成行内的修改和删除按钮和事件
	var str="";
	if(rowData.rowid!="")
	{
		if(rowData.statusdr==1)
		{
			str+='    <a onclick="onupload('+rowData.rowid+')" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/upload.png" /></a>'; 
			//str+="    <a  href='javascript:void(onupload('"+rowData.rowid+"','"+rowData.statusdr+"'))'><img border='0' src='../scripts/dhceq/easyui/themes/icons/upload.png' width='16' height='16'></a>"; 	
			str+='    <a onclick="onedit('+rowData.rowid+','+rowData.statusdr+')" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/pencil.png" /></a>'; 
		}
		if((rowData.statusdr!=1))
		{
			str+='    <a onclick="detail('+rowData.rowid+')" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></a>'; 
			//str+="    <a  href='javascript:void(detail('"+rowData.rowid+"'))'><img border='0' src='../scripts/dhceq/easyui/themes/icons/cancel.png' width='16' height='16'></a>"; 
		}
	}
	return str;
}
function onedit(rowid,statusdr) {
	var str="id="+rowid+"&status="+statusdr;
    //window.open('dhceqmovenew1.csp?'+str, '_blank', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=750,height=400,left=80,top=0');
	openwindow('dhceqmovenew1.csp',str,'800','400');  //modified by HHM 2016-01-25 窗口居中
}
function detail(value) {
    var str="id="+value+"&status=";
    //window.open('dhceqmovenew1.csp?'+str, '_blank', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=750,height=400,left=80,top=0');
	openwindow('dhceqmovenew1.csp',str,'800','400');  //modified by HHM 2016-01-25 窗口居中
}
function onupload(rowid) {
	var info = tkMakeServerCall("web.DHCEQMove", "GetMoveInfo",rowid);
	var InfoStr = info.split("^");
	if(InfoStr[13]=="")
	{
		jQuery.messager.alert("提示", "目的单位类型为空");
		return false;
	}
	if(InfoStr[14]=="")
	{
		jQuery.messager.alert("提示", "目的单位为空");
		return false;
	}
	/*if(InfoStr[12]=="")
	{
		jQuery.messager.alert("提示", "目的位置为空");
		return false;
	}*/
	if(InfoStr[15]=="")
	{
		jQuery.messager.alert("提示", "完成日期为空");
		return false;
	}
	if(InfoStr[16]=="")
	{
		jQuery.messager.alert("提示", "完成时间为空");
		return false;
	}
	if(InfoStr[18]=="")
	{
		jQuery.messager.alert("提示", "接受负责人为空");
		return false;
	}
    var result = tkMakeServerCall("web.DHCEQMove", "SubitMoveInfo",2,rowid,SessionObj.guser);
    if(result==0) {
		jQuery.messager.alert("提示", "提交成功");
		jQuery("#tMoveList").datagrid('reload'); 
		return false;
	}
	else{
		jQuery.messager.alert("提示", "提交失败");
		return false;
	}
}
/*//初始化台帐信息
function initGroupListPanel() {
	jQuery("#tGroupList").datagrid({
		fit:true,
		border:false,
		striped: true,
		singleSelect : true,
		url: null,
		fitColumns:false,
		autoRowHeight:false,
		remoteSort:false,
		cache: false,
		singleSelect:true,
		loadMsg:'Loading…',
		pagination: true,
		pageSize:20,
		rownumbers: true,  //如果为true，则显示一个行号列。
		columns:[[  
			{ title: 'SSGRPRowId', field: 'SSGRPRowId',width:80, hidden:true},
			{ title: '安全组', field: 'SSGRPDesc' ,width:120,sortable:true},
			{ title: '启用', field: 'SSGRPUseFlag' ,halign:"center" ,width:60,editor:{type:'checkbox',options:{on:'Y',off:''}}},
			{ title: '备注', field: 'SSGRPNotes' ,width:100,editor:'text'},
			{ title: '工作流', field: 'SSGRPWorkflow' ,width:60},
			{ title: '头菜单', field: 'SSGRPMainMenu' ,width:60},
			{ title: '侧菜单', field: 'SSGRPSideMenu' ,width:60},
			{ title: '超时时间', field: 'SSGRPAppTimeout' ,width:60},
			{ title: '列编辑', field: 'ColumnManager' ,width:60},
			{ title: '界面编辑', field: 'LayoutManager' ,width:60}
		]],
		onBeforeLoad: function(param) {
			//目的是为了防止loadData时，设置url加载两次
			if(param.ArgCnt == undefined) {
				return false;
			}
		},
		onLoadError: function() {
			jQuery.messager.alert("错误", "加载列表错误.");
		},
		
		onClickCell:onClickCell,
		onSelect: function(rowIndex, rowData) {
			GroupSelectID=rowData.SSGRPRowId ;
			initMenuListData();
		}
	});	
}
*/
jQuery.extend(jQuery.fn.datagrid.methods, {
	editCell: function(jq,param){
		return jq.each(function(){
			var opts = jQuery(this).datagrid('options');
			var fields = jQuery(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
			for(var i=0; i<fields.length; i++){
				var col = jQuery(this).datagrid('getColumnOption', fields[i]);
				col.editor1 = col.editor;
				if (fields[i] != param.field){
					col.editor = null;
				}
			}
			jQuery(this).datagrid('beginEdit', param.index);
			for(var i=0; i<fields.length; i++){
				var col = jQuery(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	}
});
var editIndex = undefined;		
function endEditing(){
	if (editIndex == undefined){return true}
	if (jQuery('#tMoveList').datagrid('validateRow', editIndex)){
		jQuery('#tMoveList').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function onClickCell(index, field){
	if (endEditing()){
		jQuery('#tMoveList').datagrid('selectRow', index)
				.datagrid('editCell', {index:index,field:field});
		var ed = jQuery('#tMoveList').datagrid('getEditor', {index:index,field:field});
		if(ed) {
			jQuery(ed.target).focus();
		};
		editIndex = index;
	}
}
function initObjType() {
	jQuery("#ObjType").combobox({
		fit: true,
		height: 24,
		multiple: false,
		editable: false,
		disabled: false,
		readonly: false,
    	valueField:'id', 
    	url:null,   
    	textField:'text',
		data: [{
			id: '',
			text: ''
		},{
			id: '1',
			text: '设备'
		}],
		onSelect: function(record) {
			//initMoveListData();
		}
	});
}
function initSourceType() {
	jQuery("#SourceType").combobox({
		fit: true,
		height: 24,
		multiple: false,
		editable: false,
		disabled: false,
		readonly: false,
    	valueField:'id', 
    	url:null,   
    	textField:'text',
		data: [{
			id: '',
			text: ''
		},{
			id: '1',
			text: '维修'
		},{
			id: '2',
			text: '租赁'
		},{
			id: '3',
			text: '转移单'
		}],
		onSelect: function(record) {
			initMoveListData();
		}
	});
}
function initEventType() {
	jQuery("#EventType").combobox({
		fit: true,
		height: 24,
		multiple: false,
		editable: false,
		disabled: false,
		readonly: false,
    	valueField:'id', 
    	url:null,   
    	textField:'text',
		data: [{
			id: '',
			text: ''
		},{
			id: '1',
			text: '送出'
		},{
			id: '2',
			text: '返还'
		}],
		onSelect: function(record) {
			initMoveListData();
		}
	});
}
function initStatus() {
	jQuery("#Status").combobox({
		fit: true,
		height: 24,
		multiple: false,
		editable: false,
		disabled: false,
		readonly: false,
    	valueField:'id', 
    	url:null,   
    	textField:'text',
		data: [{
			id: '1',
			text: '提交'
		},{
			id: '2',
			text: '审核'
		}],
		onSelect: function(record) {
			initMoveListData();
		}
	});
}
function QueryMoveClick()
{
	initMoveListData();
}
/*function findGroupKeyDown(e) {
	var e = e || window.event;
	if (e.keyCode == 13) {
		initGroupListData();
	}
}
function findMenuTextKeyDown(e){
	var e = e || window.event;
	if (e.keyCode == 13) {
		if (GroupSelectID=="") {
			jQuery.messager.alert("错误", "未选择对应安全组.");
			quit;
		}
		initMenuListData();
	}
}*/
//初始化安全组列表数据
function initMoveListData() {
	var queryParams = new Object();
	var ClassName = "web.DHCEQMove";
	var QueryName = "MoveList";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 = jQuery("#No").val();
	queryParams.Arg2 = jQuery("#EquipName").val();
	queryParams.Arg3 = jQuery("#SourceType").combobox('getValue');
	queryParams.Arg4 = jQuery("#EventType").combobox('getValue');
	queryParams.Arg5 = jQuery("#FromDeptType").combobox('getValue');
	queryParams.Arg6 = jQuery("#FromLocationDR").combobox('getValue');
	queryParams.Arg7 = jQuery("#StartDate").datebox('getValue');
	queryParams.Arg8 = jQuery("#SendUserDR").combobox('getValue');
	queryParams.Arg9 = jQuery("#ToDeptType").combobox('getValue');
	queryParams.Arg10 = jQuery("#ToLocationDR").combobox('getValue');
	queryParams.Arg11 = jQuery("#EndDate").datebox('getValue');
	queryParams.Arg12 = jQuery("#AcceptUserDR").combobox('getValue');
	queryParams.Arg13 = jQuery("#Status").combobox('getValue');
	queryParams.Arg14 = jQuery("#EquipNo").val();
	queryParams.Arg15 = "";
	queryParams.Arg16 = "";   //修改参数 Modified bu HHM 2013-03-30
	queryParams.ArgCnt =16;
	loadDataGridStore("tMoveList", queryParams);
}
//初始化菜单列表数据
/*function initMenuListData() {
	var queryParams = new Object();
	var ClassName="web.DHCGroupMenuData";
	var QueryName="QueryGroupMenuList"; 
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 = GroupSelectID;
	queryParams.Arg2 = SessionObj.LANGID;
	queryParams.Arg3 = jQuery("#MenuText").val();
	queryParams.ArgCnt = 3;
	loadDataGridStore("tMenuList",queryParams);
}*/

/**
*加载DataGrid数据
*/
function loadDataGridStore(DataGridID, queryParams){
	window.setTimeout(function(){
		var jQueryGridObj = jQuery("#" + DataGridID);
		jQuery.extend(jQueryGridObj.datagrid("options"),{
			url : QUERY_URL.QUERY_GRID_URL,
			queryParams : queryParams
		});
		jQueryGridObj.datagrid("load");
	},0);
}
/**
*加载ComboGrid数据
*/
function loadComboGridStore(ComboGridID, queryParams) {
	var jQueryComboGridObj = jQuery("#" + ComboGridID);
	var grid = jQueryComboGridObj.combogrid('grid');	// 获取数据表格对象
	var opts = grid.datagrid("options");
	opts.url = QUERY_URL.QUERY_GRID_URL;

	grid.datagrid('load', queryParams);
}

//设置默认下拉框值
function setDefVal() {
	jQuery("#Status").combobox('setValue', '1');
	var curr_time = new Date();
   	var strDate = curr_time.getFullYear()+"-";
   	strDate += curr_time.getMonth()+1+"-";
   	strDate += curr_time.getDate()+"-";
   	strDate += curr_time.getHours()+":";
   	strDate += curr_time.getMinutes()+":";
   	strDate += curr_time.getSeconds();
	jQuery("#EndDate").datebox('setValue', strDate);
}

//设置默认焦点
function setFocus(id) {
	if(jQuery("#" + id).length) {
		jQuery("#" + id).focus();
	}
}

//datagrid key control
jQuery.extend(jQuery.fn.datagrid.methods, {
    keyCtr : function (jq) {
        return jq.each(function () {
            var grid = jQuery(this);
            grid.datagrid('getPanel').panel('panel').attr('tabindex', 1).bind('keydown', function (e) {
                switch (e.keyCode) {
                case 38: // up
                    var selected = grid.datagrid('getSelected');
                    if (selected) {
                        var index = grid.datagrid('getRowIndex', selected);
                        grid.datagrid('selectRow', index - 1);
                    } else {
                        var rows = grid.datagrid('getRows');
                        grid.datagrid('selectRow', rows.length - 1);
                    }
                    break;
                case 40: // down
                    var selected = grid.datagrid('getSelected');
                    if (selected) {
                        var index = grid.datagrid('getRowIndex', selected);
                        grid.datagrid('selectRow', index + 1);
                    } else {
                        grid.datagrid('selectRow', 0);
                    }
                    break;
                }
            });
        });
    }
});

/*//获取编辑框底下是否已经设置
function clearLeftRow(index) {
	var maxLen = jQuery("#tPaymList").datagrid("getData").rows.length;
	for(var i=index; i<maxLen; i++) {
		var ed = jQuery('#tPaymList').datagrid('getEditor', {index:i, field:"CTPMAmt"});
		if(ed) {
			jQuery(ed.target).numberbox("setValue", "");
		}else {
			jQuery('#tPaymList').datagrid('updateRow', {
				index: i,
				row: {
					CTPMAmt: ''
				}
			});
		}
	}
	setBalance();
}*/

//扩展单击单元格
jQuery.extend(jQuery.fn.datagrid.methods, {
	editCell: function(jq,param){
		return jq.each(function(){
			var opts = jQuery(this).datagrid('options');
			var fields = jQuery(this).datagrid('getColumnFields',true).concat(jQuery(this).datagrid('getColumnFields'));
			for(var i=0; i<fields.length; i++){
				var col = jQuery(this).datagrid('getColumnOption', fields[i]);
				col.editor1 = col.editor;
				if (fields[i] != param.field){
					col.editor = null;
				}
			}
			jQuery(this).datagrid('beginEdit', param.index);
			for(var i=0; i<fields.length; i++){
				var col = jQuery(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	},
	endEditCell : function(jq,param){
		return jq.each(function(){
			var thisCellEditor = null;
			var opts = jQuery(this).datagrid('options');
			var fields = jQuery(this).datagrid('getColumnFields',true).concat(jQuery(this).datagrid('getColumnFields'));
			for(var i=0; i<fields.length; i++){
				var col = jQuery(this).datagrid('getColumnOption', fields[i]);
				log(col.editor)
				if (fields[i] == param.field){
					thisCellEditor = col.editor;
					col.editor = null;
					break;
				}
			}

			jQuery(this).datagrid('endEdit', param.index);

			for(var i=0; i<fields.length; i++){
				var col = jQuery(this).datagrid('getColumnOption', fields[i]);
				if (fields[i] == param.field){
					col.editor = thisCellEditor;
					break;
				}
			}
		});
	}
});
jQuery.extend(jQuery.fn.datagrid.methods, {
    addEditor : function(jq, param) {
        if (param instanceof Array) {
            $.each(param, function(index, item) {
                var e = jQuery(jq).datagrid('getColumnOption', item.field);
                e.editor = item.editor;
            });
        } else {
            var e = jQuery(jq).datagrid('getColumnOption', param.field);
            e.editor = param.editor;
        }
    },
    removeEditor : function(jq, param) {
        if (param instanceof Array) {
            jQuery.each(param, function(index, item) {
                var e = jQuery(jq).datagrid('getColumnOption', item);
                e.editor = {};
            });
        } else {
            var e = jQuery(jq).datagrid('getColumnOption', param);
            e.editor = {};
        }
    }
});
//add by HHM 2016-01-21 弹出窗口居中显示
function openwindow(url,str,iWidth,iHeight){
	//var iWidth=800;
	//var iHeight=400;
	//window.screen.height获得屏幕的高，window.screen.width获得屏幕的宽  
	var iTop = (window.screen.height-30-iHeight)/2; //获得窗口的垂直位置;  
	var iLeft = (window.screen.width-10-iWidth)/2; //获得窗口的水平位置; 
	window.open(''+url+'?'+str+'', '_blank', 'width='+iWidth+',height='+iHeight+',left='+iLeft+',top='+iTop+'');	
}

