/**
 * passwork.bcs.hui.js ���౾����
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 */

//ҳ��ȫ�ֱ���
var PageLogicObj = {
	m_TypeCombox : "",
	m_TypeComboxValue : "",
	m_Grid : "",
	m_Diag_HiscodeCombox: "",
	m_Diag_TypeCombox: "",
	m_Win : ""
	
}

$(function(){
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
})

function Init(){
	InitBaseData();
	PageLogicObj.m_Grid = InitGrid();
}
function InitEvent(){
	$("#i-find").click(findConfig);
	$("#i-add").click(function(){opDialog("add")});
	$("#i-edit").click(function(){opDialog("edit")});
	//$("#i-delete").click(function(){deConfig()});
	$("#i-rule").click(InitRuleDg);
	$("#i-pat").click(InitPatDg);
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	
}

/**
 * ��ʼ����������
 */
function InitBaseData () {
	var responseText = $.m({
		ClassName:"DHCDoc.DHCDocConfig.PassWork",
		MethodName:"InitBaseData",
	},false);

	return responseText;
}
function InitPatDg () {
	if($('#dg-pat').hasClass("c-hidden")) {
		$('#dg-pat').removeClass("c-hidden");
	};
	
	$("#dg-pat-code").val("").removeAttr("disabled");
	$("#dg-pat-desc").val("");
	$("#dg-pat-isDisplay").checkbox("uncheck");
	$("#dg-pat-disNo").val("");
	$("#dg-pat-url").val("");
	$("#dg-pat-wh").val("");
			
	PageLogicObj.m_dg_patGrid = InitPatGrid();

	var cWin = $HUI.window('#dg-pat', {
		title: "��������",
		iconCls: "icon-w-config",
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			$('#dg-pat').addClass("c-hidden");
		}
	});
	
	PageLogicObj.m_dg_ruleWin = cWin;

	InitPatEvent();
}

function InitRuleDg () {
	if($('#dg-rule').hasClass("c-hidden")) {
		$('#dg-rule').removeClass("c-hidden");
	};
	
	$("#dg-rule-code").val("").removeAttr("disabled");
	$("#dg-rule-desc").val("");
	$("#dg-rule-value").val("");
			
	PageLogicObj.m_dg_ruleGrid = InitRuleGrid();

	var cWin = $HUI.window('#dg-rule', {
		title: "��������",
		iconCls: "icon-w-config",
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			$('#dg-rule').addClass("c-hidden");
		}
	});
	
	PageLogicObj.m_dg_ruleWin = cWin;

	InitRuleEvent();
	
}

function InitRuleEvent() {
	$("#dg-rule-save").unbind();
	$("#dg-rule-save").click(function () {
		var action = "add";
		var selected = PageLogicObj.m_dg_ruleGrid.getSelected();
		var code = $.trim($("#dg-rule-code").val());
		var desc = $.trim($("#dg-rule-desc").val());
		var value = $.trim($("#dg-rule-value").val());
		if (code == "") {
			$.messager.alert("��ʾ","���벻��Ϊ�գ�","info")
			return false;
		}
		if (desc == "") {
			$.messager.alert("��ʾ","��������Ϊ�գ�","info")
			return false;
		}
		if (selected) {
			action = "edit";
		}
		var responseText = $.m({
			ClassName:"DHCDoc.DHCDocConfig.PassWork",
			MethodName:"SaveRule",
			code:code,
			desc: desc,
			value:value,
			action:action
		},false);
		if (responseText == 0) {
			//$.messager.alert("��ʾ","���벻��Ϊ�գ�","info");
			$.messager.popover({msg:"����ɹ���",type:'success'});
			PageLogicObj.m_dg_ruleGrid.reload();
			$("#dg-rule-code").val("").removeAttr("disabled");
			$("#dg-rule-desc").val("");
			$("#dg-rule-value").val("");
			return true;
		} else if (responseText == "-1") {
			$.messager.popover({msg:"�����ظ���",type:'alert'});
			return false;
		} else {
			$.messager.popover({msg:"����ʧ�ܣ�",type:'error'});
			return false;
		}
	});
}

function InitPatEvent() {
	$("#dg-pat-save").unbind();
	$("#dg-pat-save").click(function () {
		var action = "add";
		var selected = PageLogicObj.m_dg_patGrid.getSelected();
		var code = $.trim($("#dg-pat-code").val());
		var desc = $.trim($("#dg-pat-desc").val());
		var isDisplay = $("#dg-pat-isDisplay").checkbox("getValue")?1:0;
		var disNo = $.trim($("#dg-pat-disNo").val());
		var url = $.trim($("#dg-pat-url").val());
		var wh = $.trim($("#dg-pat-wh").val());
		if (code == "") {
			$.messager.alert("��ʾ","���벻��Ϊ�գ�","info")
			return false;
		}
		if (desc == "") {
			$.messager.alert("��ʾ","��������Ϊ�գ�","info")
			return false;
		}
		if (disNo == "") {
			$.messager.alert("��ʾ","��ʾ˳����Ϊ�գ�","info")
			return false;
		}
		if (url == "") {
			$.messager.alert("��ʾ","ģ�����Ӳ���Ϊ�գ�","info")
			return false;
		}
		if (wh == "") {
			$.messager.alert("��ʾ","��߲���Ϊ�գ�","info")
			return false;
		}
		if (selected) {
			action = "edit";
		}
		var responseText = $.m({
			ClassName:"DHCDoc.DHCDocConfig.PassWork",
			MethodName:"SavePat",
			code:code,
			desc: desc,
			isDisplay:isDisplay,
			disNo:disNo,
			url:url,
			wh:wh,
			action:action
		},false);
		if (responseText == 0) {
			//$.messager.alert("��ʾ","���벻��Ϊ�գ�","info");
			$.messager.popover({msg:"����ɹ���",type:'success'});
			PageLogicObj.m_dg_patGrid.reload();
			$("#dg-pat-code").val("").removeAttr("disabled");
			$("#dg-pat-desc").val("");
			$("#dg-pat-isDisplay").checkbox("uncheck");
			$("#dg-pat-disNo").val("");
			$("#dg-pat-url").val("");
			$("#dg-pat-wh").val("");
			return true;
		} else if (responseText == "-1") {
			$.messager.popover({msg:"�����ظ���",type:'alert'});
			return false;
		} else {
			$.messager.popover({msg:"����ʧ�ܣ�",type:'error'});
			return false;
		}
	});
}

/**
 * ���ز�������Grid
 */
function InitPatGrid(){
	var columns = [[
		{field:'code',title:'����',width:100},
		{field:'desc',title:'����',width:100},
		{field:'isDisplay',title:'�Ƿ���ʾ',width:80,
			formatter:function(value,row,index){
				if (value == 1) {
					return "<span class='c-ok'>��</span>"
				} else {
					return "<span class='c-no'>��</span>"
				}
			}
		},
		{field:'disNo',title:'��ʾ˳��',width:80},
		{field:'wh',title:'���',width:80},
		{field:'tplURL',title:'ģ������',width:200},
    ]]
	var DurDataGrid = $HUI.datagrid("#dg-patgrid", {
		fit : true,
		border : false,
		striped : true,
		nowrap:false,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.DHCDocConfig.PassWork",
			QueryName : "QryPat"
		},
		onBeforeSelect:function(index, row){
			var selrow = PageLogicObj.m_dg_patGrid.getSelected();
			if (selrow){
				var oldIndex = PageLogicObj.m_dg_patGrid.getRowIndex(selrow);
				if (oldIndex == index){
					PageLogicObj.m_dg_patGrid.unselectRow(index);
					return false;
				}
			}
		},
		onUnselect: function (rowIndex, rowData) {
			$("#dg-pat-code").val("").removeAttr("disabled");
			$("#dg-pat-desc").val("");
			$("#dg-pat-isDisplay").checkbox("uncheck");
			$("#dg-pat-disNo").val("");
			$("#dg-pat-url").val("");
			$("#dg-pat-wh").val("");
		},
		onSelect: function (rowIndex, rowData) {
			$("#dg-pat-code").val(rowData.code).attr("disabled","disabled");;
			$("#dg-pat-desc").val(rowData.desc);
			$("#dg-pat-disNo").val(rowData.disNo);
			$("#dg-pat-url").val(rowData.tplURL);
			$("#dg-pat-wh").val(rowData.wh);
			if (rowData.isDisplay == 1) {$("#dg-pat-isDisplay").checkbox("check")}
			else {$("#dg-pat-isDisplay").checkbox("uncheck")}
		},
		columns :columns
	});
	
	return DurDataGrid;
}

/**
 * ���ع����б�Grid
 */
function InitRuleGrid(){
	var columns = [[
		{field:'code',title:'����',width:50},
		{field:'desc',title:'����',width:100},
		{field:'value',title:'��ֵ',width:200}
    ]]
	var DurDataGrid = $HUI.datagrid("#dg-rulegrid", {
		fit : true,
		border : false,
		striped : true,
		nowrap:false,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.DHCDocConfig.PassWork",
			QueryName : "QryRule"
		},
		onBeforeSelect:function(index, row){
			var selrow = PageLogicObj.m_dg_ruleGrid.getSelected();
			if (selrow){
				var oldIndex = PageLogicObj.m_dg_ruleGrid.getRowIndex(selrow);
				if (oldIndex == index){
					PageLogicObj.m_dg_ruleGrid.unselectRow(index);
					return false;
				}
			}
		},
		onUnselect: function (rowIndex, rowData) {
			$("#dg-rule-code").val("").removeAttr("disabled");
			$("#dg-rule-desc").val("");
			$("#dg-rule-value").val("");
		},
		onSelect: function (rowIndex, rowData) {
			$("#dg-rule-code").val(rowData.code).attr("disabled","disabled");
			$("#dg-rule-desc").val(rowData.desc);
			$("#dg-rule-value").val(rowData.value);
		},
		columns :columns
	});
	
	return DurDataGrid;
}

function InitGrid(){
	var columns = [[
		{field:'code',title:'����',width:100},
		{field:'name',title:'���',width:100},
		{field:'seqno',title:'�ڼ����',width:100},
		{field:'sTime',title:'��ʼʱ��',width:100},
		{field:'eTime',title:'����ʱ��',width:100},
        {field:'nextDay',title:'���ձ�־',width:100,
			formatter:function(value,row,index){
                if (value == 2) {
                    return "�����������"
                } else if (value == 1) {
                    return "��������"
                } else {
					return "������"
				}
            }
		},
        {field:'active',title:'�Ƿ񼤻�',width:100,
            formatter:function(value,row,index){
                if (value == 1) {
                    return "<span class='c-ok'>��</span>"
                } else {
                    return "<span class='c-no'>��</span>"
                }
            }
        },
        {field:'note',title:'��ע',width:60},
        {field:'rowid',title:'ID',width:60,hidden:true}
    ]]
	var DurDataGrid = $HUI.datagrid("#i-durGrid", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.DHCDocConfig.PassWork",
			QueryName : "QryPWConfig"
		},
		onUnselect:function(){
		},
		columns :columns,
		toolbar:[{
				text:'����',
				id:'i-add',
				iconCls: 'icon-add'
			},{
				text:'�޸�',
				id:'i-edit',
				iconCls: 'icon-write-order'
            }
            ,{
				text:'��������',
				id:'i-pat',
				iconCls: 'icon-batch-cfg'
			},{
				text:'��������',
				id:'i-rule',
				iconCls: 'icon-paper-cfg'
			}
		]
	});
	
	return DurDataGrid;
}

//�༭������
function opDialog(action) {
	var selected = PageLogicObj.m_Grid.getSelected();
	var _title = "", _icon = "" ;
	if (action == "add") {
		_title = "����";
		_icon = "icon-w-add";
		$("#i-action").val("add");
		$("#i-id").val("");
	} else {
		if (!selected) {
			$.messager.alert("��ʾ","��ѡ��һ����¼��","info")
			return false;
		}
		_title = "�޸�";
		_icon = "icon-w-edit";
		$("#i-action").val("edit");
		$("#i-id").val(selected.rowid);
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	
	PageLogicObj.m_nextday = $HUI.combobox("#i-diag-nextday",{
		valueField:'id',
		textField:'text',
		multiple:false,
		//rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'0',text:'������'},{id:'1',text:'��������'},{id:'2',text:'�����������'}
		]
	});
	
	if (action == "add") {
		$("#i-diag-code").val("");
        $("#i-diag-name").val("");
		$("#i-diag-seqno").numberbox("setValue","");
        $("#i-diag-stime").timespinner("clear");
        $("#i-diag-etime").timespinner("clear");
        //$("#i-diag-nextday").checkbox("uncheck");
		PageLogicObj.m_nextday.setValue(0);
        $("#i-diag-active").checkbox("uncheck");
        $("#i-diag-note").val("");
	} else {
        $("#i-diag-code").val(selected.code);
        $("#i-diag-name").val(selected.name);
		$("#i-diag-seqno").numberbox("setValue",selected.seqno)
        $("#i-diag-stime").timespinner("setValue", selected.sTime);
        $("#i-diag-etime").timespinner("setValue", selected.eTime);
        //if (selected.nextDay == 1) $("#i-diag-nextday").checkbox("check")
        //else $("#i-diag-nextday").checkbox("uncheck")
		PageLogicObj.m_nextday.setValue(selected.nextDay);
        if (selected.active == 1) $("#i-diag-active").checkbox("check")
        else $("#i-diag-active").checkbox("uncheck");
        $("#i-diag-note").val(selected.note);
	}
	$("#i-diag-code").validatebox("validate");
	$("#i-diag-name").validatebox("validate");
	$("#i-diag-seqno").numberbox("validate");
	var cWin = $HUI.window('#i-dialog', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#i-dialog').addClass("c-hidden");
		}
	});
	
	PageLogicObj.m_Win = cWin;
}

function deConfig () {
	var selected = PageLogicObj.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ","��ѡ��һ����¼��","info")
		return false;
	}
	$.m({
			ClassName:"web.DHCDocExtData",
			MethodName:"DeleteExtData",
			MUCRowid: selected.HidRowid
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('��ʾ','ɾ���ɹ���',"info");
				PageLogicObj.m_Grid.reload();
			} else {
				$.messager.alert('��ʾ','�޸�ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
}

//�����ֵ���Ϣ
function saveCfg() {
	var id = $("#i-id").val();
	var action = $("#i-action").val();
    var code = $.trim($("#i-diag-code").val());
    var name = $.trim($("#i-diag-name").val());
    var stime = $("#i-diag-stime").timespinner("getValue")||"";
    var etime = $("#i-diag-etime").timespinner("getValue")||"";
    var nextday = PageLogicObj.m_nextday.getValue();	//$("#i-diag-nextday").checkbox("getValue")?1:0;
    var active = $("#i-diag-active").checkbox("getValue")?1:0;
    var note = $.trim($("#i-diag-note").val());
    var seqno = $.trim($("#i-diag-seqno").val());
	var paraInStr = id + "^" + code + "^" + name + "^" + stime + "^" + etime + "^" + nextday + "^" + active;
	paraInStr = paraInStr + "^" + note + "^" + seqno;
	if (code == "") {
		$.messager.alert('��ʾ','��δ��벻��Ϊ��!',"info");
		return false;
	}
	if (name == "") {
		$.messager.alert('��ʾ','������Ʋ���Ϊ��!',"info");
		return false;
    }
	if (seqno == "") {
		$.messager.alert('��ʾ','�ڼ���β���Ϊ��!',"info");
		return false;
    }
    rpResult = tkMakeServerCall("DHCDoc.DHCDocConfig.PassWork","HasBCCode", id, code);
    if ( rpResult == 1) {
        $.messager.alert('��ʾ','��δ����Ѵ���!',"info");
        return false;
    }
    $.m({
        ClassName:"DHCDoc.DHCDocConfig.PassWork",
        MethodName:"DBSave",
        inPara:paraInStr
    },function (responseText){
        if(responseText > 0) {
            $.messager.alert('��ʾ','����ɹ���',"info");
            PageLogicObj.m_Win.close();
            PageLogicObj.m_Grid.reload();
        } else {
            $.messager.alert('��ʾ','����ʧ��,�������: '+ responseText , "info");
            return false;
        }	
    })
}

//����
function findConfig () {
	//var text = PageLogicObj.m_ArcimCombox.getText();
	var SelectTypeCode = PageLogicObj.m_TypeCombox.getValue();
	
	PageLogicObj.m_Grid.reload({
		ClassName : "web.DHCDocExtData",
		QueryName : "ExtDataQuery",
		SelectTypeCode: SelectTypeCode
	});
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//�������Backspace������  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}


