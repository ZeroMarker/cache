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
//�������
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
	initMoveListPanel();  //ע��λ�ã�Ҫ�ŵ����
}

//��ʼ����ѯͷ���
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
			text: '����'
		},{
			id: '2',
			text: '������'
		},{
			id: '3',
			text: '��Ӧ��'
		},{
			id: '4',
			text: '��������'
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
		loadMsg:'Loading��',
		pagination: true,
		pageSize:20,
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		columns:[[  
			{ title: 'Rowid', field: 'rowid',halign:"center", width:10, hidden: true},
			{ title: '����', field: 'opt', width: 60, halign: 'center', formatter: fomartOperation },
			{ title: '�ƶ�����', field: 'no' ,halign:"center", width:120},
			{ title: '��������',  field: 'objtype' ,halign:"center", width:60, hidden: true},
			{ title: '����ID', field: 'objid',halign:"center", width:30, hidden:true},
			{ title: '�豸����', field: 'equipname',halign:"center", width:120},
			{ title: '�豸���', field: 'equipno',halign:"center", width:200},
			{ title: '��Ӧ�¼�', field: 'sourcetype',halign:"center", width:60},
			{ title: 'ҵ��ID',  field: 'sourceid',align: "right",halign:"center", width:50, hidden:true },
			{ title: '�ƶ�Ե��', field: 'eventype',align: "right",halign:"center", width:60 },
			{ title: '��ʼ��λ����',  field: 'fromdepttype' ,align: "right",halign:"center", width:80 },
			{ title: 'ԭ��λID', field: 'fromdeptid',align: "right" ,halign:"center", width:50, hidden:true},
			{ title: '��ʼλ��', field: 'fromlocation' ,align: "right" ,halign:"center", width:100},
			{ title: '��ʼ����', field: 'startdate',align: "right" ,halign:"center", width:80},
			{ title: '�ƶ�ԭ��', field: 'movereason',halign:"center", width:80 , hidden:true},
			{ title: '�ͳ�������',  field: 'senduser' ,halign:"center", width:80},
			{ title: 'Ŀ�ĵ�λ����', field: 'todepttype',halign:"center", width:80},
			{ title: 'Ŀ�ĵ�λID', field: 'todeptid',halign:"center", width:80, hidden:true },
			{ title: 'Ŀ��λ��', field: 'tolocation',halign:"center", width:100},
			{ title: '�������', field: 'enddate',align: "right" ,halign:"center", width:80},
			{ title: '���ո�����',  field: 'acceptuser',halign:"center", width:80 },
			{ title: '��ע', field: 'remark',halign:"center", width:220},
			{ title: 'statusdr', field: 'statusdr',halign:"center", width:30, hidden: true },
			{ title: '״̬', field: 'status',halign:"center", width:50 },
			{ title: 'invalidflag', field: 'invalidflag',halign:"center", width:30, hidden: true },
			{ title: '��Чԭ��', field: 'invalidreason',halign:"center", width:220, hidden: true},
		]],
		onBeforeLoad: function(param) {
			//Ŀ����Ϊ�˷�ֹloadDataʱ������url��������
			if(param.ArgCnt == undefined) {
				return false;
			}
		},
		onLoadError: function() {
			jQuery.messager.alert('����', '�����б�ʧ��.');
		},
		onSelect: function(rowIndex, rowData) {		
		}
	}); 
}
function fomartOperation(value, rowData, rowIndex) {//�������ڵ��޸ĺ�ɾ����ť���¼�
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
	openwindow('dhceqmovenew1.csp',str,'800','400');  //modified by HHM 2016-01-25 ���ھ���
}
function detail(value) {
    var str="id="+value+"&status=";
    //window.open('dhceqmovenew1.csp?'+str, '_blank', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=750,height=400,left=80,top=0');
	openwindow('dhceqmovenew1.csp',str,'800','400');  //modified by HHM 2016-01-25 ���ھ���
}
function onupload(rowid) {
	var info = tkMakeServerCall("web.DHCEQMove", "GetMoveInfo",rowid);
	var InfoStr = info.split("^");
	if(InfoStr[13]=="")
	{
		jQuery.messager.alert("��ʾ", "Ŀ�ĵ�λ����Ϊ��");
		return false;
	}
	if(InfoStr[14]=="")
	{
		jQuery.messager.alert("��ʾ", "Ŀ�ĵ�λΪ��");
		return false;
	}
	/*if(InfoStr[12]=="")
	{
		jQuery.messager.alert("��ʾ", "Ŀ��λ��Ϊ��");
		return false;
	}*/
	if(InfoStr[15]=="")
	{
		jQuery.messager.alert("��ʾ", "�������Ϊ��");
		return false;
	}
	if(InfoStr[16]=="")
	{
		jQuery.messager.alert("��ʾ", "���ʱ��Ϊ��");
		return false;
	}
	if(InfoStr[18]=="")
	{
		jQuery.messager.alert("��ʾ", "���ܸ�����Ϊ��");
		return false;
	}
    var result = tkMakeServerCall("web.DHCEQMove", "SubitMoveInfo",2,rowid,SessionObj.guser);
    if(result==0) {
		jQuery.messager.alert("��ʾ", "�ύ�ɹ�");
		jQuery("#tMoveList").datagrid('reload'); 
		return false;
	}
	else{
		jQuery.messager.alert("��ʾ", "�ύʧ��");
		return false;
	}
}
/*//��ʼ��̨����Ϣ
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
		loadMsg:'Loading��',
		pagination: true,
		pageSize:20,
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		columns:[[  
			{ title: 'SSGRPRowId', field: 'SSGRPRowId',width:80, hidden:true},
			{ title: '��ȫ��', field: 'SSGRPDesc' ,width:120,sortable:true},
			{ title: '����', field: 'SSGRPUseFlag' ,halign:"center" ,width:60,editor:{type:'checkbox',options:{on:'Y',off:''}}},
			{ title: '��ע', field: 'SSGRPNotes' ,width:100,editor:'text'},
			{ title: '������', field: 'SSGRPWorkflow' ,width:60},
			{ title: 'ͷ�˵�', field: 'SSGRPMainMenu' ,width:60},
			{ title: '��˵�', field: 'SSGRPSideMenu' ,width:60},
			{ title: '��ʱʱ��', field: 'SSGRPAppTimeout' ,width:60},
			{ title: '�б༭', field: 'ColumnManager' ,width:60},
			{ title: '����༭', field: 'LayoutManager' ,width:60}
		]],
		onBeforeLoad: function(param) {
			//Ŀ����Ϊ�˷�ֹloadDataʱ������url��������
			if(param.ArgCnt == undefined) {
				return false;
			}
		},
		onLoadError: function() {
			jQuery.messager.alert("����", "�����б����.");
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
			text: '�豸'
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
			text: 'ά��'
		},{
			id: '2',
			text: '����'
		},{
			id: '3',
			text: 'ת�Ƶ�'
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
			text: '�ͳ�'
		},{
			id: '2',
			text: '����'
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
			text: '�ύ'
		},{
			id: '2',
			text: '���'
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
			jQuery.messager.alert("����", "δѡ���Ӧ��ȫ��.");
			quit;
		}
		initMenuListData();
	}
}*/
//��ʼ����ȫ���б�����
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
	queryParams.Arg16 = "";   //�޸Ĳ��� Modified bu HHM 2013-03-30
	queryParams.ArgCnt =16;
	loadDataGridStore("tMoveList", queryParams);
}
//��ʼ���˵��б�����
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
*����DataGrid����
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
*����ComboGrid����
*/
function loadComboGridStore(ComboGridID, queryParams) {
	var jQueryComboGridObj = jQuery("#" + ComboGridID);
	var grid = jQueryComboGridObj.combogrid('grid');	// ��ȡ���ݱ�����
	var opts = grid.datagrid("options");
	opts.url = QUERY_URL.QUERY_GRID_URL;

	grid.datagrid('load', queryParams);
}

//����Ĭ��������ֵ
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

//����Ĭ�Ͻ���
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

/*//��ȡ�༭������Ƿ��Ѿ�����
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

//��չ������Ԫ��
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
//add by HHM 2016-01-21 �������ھ�����ʾ
function openwindow(url,str,iWidth,iHeight){
	//var iWidth=800;
	//var iHeight=400;
	//window.screen.height�����Ļ�ĸߣ�window.screen.width�����Ļ�Ŀ�  
	var iTop = (window.screen.height-30-iHeight)/2; //��ô��ڵĴ�ֱλ��;  
	var iLeft = (window.screen.width-10-iWidth)/2; //��ô��ڵ�ˮƽλ��; 
	window.open(''+url+'?'+str+'', '_blank', 'width='+iWidth+',height='+iHeight+',left='+iLeft+',top='+iTop+'');	
}

