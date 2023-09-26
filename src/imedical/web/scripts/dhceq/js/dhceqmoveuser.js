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
	QUERY_GRID_URL : "./dhcbill.query.grid.easyui.csp",
	QUERY_COMBO_URL : "./dhcbill.query.combo.easyui.csp"
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
	initMoveUserData();
	//setFocus("GroupText");
}


function initPanel() {
	initTopPanel();
	//initGroupListPanel();
	initMoveUserPanel();  //ע��λ�ã�Ҫ�ŵ����
}

//��ʼ����ѯͷ���
function initTopPanel() {
	var str=window.location.search.substr(1);
   	var list=str.split("&");
   	var tmp=list[0].split("=");
   	var tid=tmp[1];
   	var info = tkMakeServerCall("web.DHCEQMove", "GetMoveInfo",tid);
	var InfoStr = info.split("^");
	//messageShow("","","",InfoStr);
  	jQuery("#MoveDR").val(tid);
	jQuery("#btnDelete").linkbutton({
		iconCls: 'icon-cancel'
	});
	jQuery("#btnSave").linkbutton({
		 iconCls: 'icon-save'
	});
	jQuery("#btnDelete").linkbutton('disable');	
	//jQuery("#btnSave").on("click", SaveClick);
	//jQuery("#btnDelete").on("click", DeleteClick);
	if(InfoStr[30]=="Y")
	{
		jQuery("#btnSave").linkbutton('disable');
		jQuery("#btnDelete").linkbutton('disable');	
	}
	if(InfoStr[29]>0)
	{
		jQuery("#btnSave").linkbutton('disable');
		jQuery("#btnDelete").linkbutton('disable');	
	}
	if((InfoStr[29]==0)&&(InfoStr[30]=="N"))
	{
		//jQuery("#btnSave").linkbutton('enable');
		jQuery("#btnSave").on("click", SaveClick);
	}
	jQuery("#btnColse").on("click", CloseClick);
	initUserDR("UserDR");
}
function initUserDR(comboxid) {
	jQuery("#"+comboxid).combobox({
		url:'dhceq.jquery.operationtype.csp?&action=GetUser',
	    valueField: 'id',    
	    textField: 'text'
	});
}	
function initMoveUserPanel() {
	var editRow = undefined;
	jQuery('#tMoveUser').datagrid({
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
			{ title: 'movedr', field: 'movedr',halign:"center", width:10, hidden: true},
			{ title: 'statusdr', field: 'statusdr',halign:"center", width:10, hidden: true},
			{ title: 'flag', field: 'flag',halign:"center", width:10, hidden: true},
			{ title: 'userdr',  field: 'userdr',align: "right",halign:"center", width:50, hidden:true },
			{ title: '�˵���',  field: 'user',halign:"center", width:100 },
			{ title: '��ע', field: 'remark',halign:"center", width:220},
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
		},
		onClickRow : function (rowIndex, rowData) {
        	MoveUsergrid_OnClickRow();
    	} 
	}); 
}
var SelectedRowID = 0;
var preRowID=0;  
function MoveUsergrid_OnClickRow()
{
     var selected=jQuery('#tMoveUser').datagrid('getSelected');
     if (selected)
     {       
        var SelectedRowID=selected.rowid;
        if(preRowID!=SelectedRowID)
        {
             jQuery('#Rowid').val(selected.rowid);
             jQuery('#UserDR').combobox('setValue',selected.userdr);
             jQuery('#Remark').val(selected.remark);
             if((selected.statusdr==0)&&(selected.flag=="N"))
             {
             	jQuery("#btnDelete").linkbutton('enable');
             }	
             preRowID=SelectedRowID;
         }
         else
         {
             cleardata();
             jQuery("#btnDelete").linkbutton('disable');	
             SelectedRowID = 0;
             preRowID=0;
         }
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
	if (jQuery('#tMoveUser').datagrid('validateRow', editIndex)){
		jQuery('#tMoveUser').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function onClickCell(index, field){
	if (endEditing()){
		jQuery('#tMoveUser').datagrid('selectRow', index)
				.datagrid('editCell', {index:index,field:field});
		var ed = jQuery('#tMoveUser').datagrid('getEditor', {index:index,field:field});
		if(ed) {
			jQuery(ed.target).focus();
		};
		editIndex = index;
	}
}
function DeleteClick(){
	window.close();
}
function CloseClick(){
	window.close();
}
function SaveClick(){
	var rowid=jQuery("#Rowid").val();
	var movedr=jQuery("#MoveDR").val();
	var userdr=jQuery("#UserDR").combobox('getValue');
	if (userdr==""){
           jQuery.messager.alert("��ʾ", "�˵��˲���Ϊ�գ�")
           return false;
    }
	var remark=jQuery("#Remark").val();
	var result = tkMakeServerCall("web.DHCEQMove", "SaveMoveUser",rowid,movedr,userdr,remark);
	if(result>0) {
				cleardata();
				jQuery('#tMoveUser').datagrid('reload'); 
				initMoveUserData();
				jQuery.messager.alert("��ʾ", "����ɹ�");
				//window.location.href='dhceqmovefind.csp';
				return false;
			}
	else{
		jQuery.messager.alert("��ʾ", "����ʧ��");
				return false;
	}
}
function cleardata(){
	jQuery('#Rowid').val("");
   	jQuery('#UserDR').combobox('setValue',"");
    jQuery('#Remark').val("");
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
function initMoveUserData() {
	var queryParams = new Object();
	var ClassName = "web.DHCEQMove";
	var QueryName = "MoveUser";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 = jQuery("#MoveDR").val();
	queryParams.ArgCnt =1;
	loadDataGridStore("tMoveUser", queryParams);
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
	jQuery("#Status").combobox('setValue', '0');
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

