/**
 * conloc.js - KJ Config Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2019-2020 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-05-30
 * 
 */
$(function(){
	
	//Ժ��
	/* PLObject.m_Hosp = $HUI.combobox("#i-hosp", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryHosp&ResultSetType=array",
		valueField:'id',
		textField:'text',
		value:session['LOGON.HOSPID'],
		blurValidValue:true,
		onSelect: function () {
			reloadGrid();
		}
	});	 */
	
	InitHospList();
	
	$("#i-find").click(reloadGrid);
	
	$('#i-tab-para-center').simpledatagrid({
		queryParams: {
			ClassName:"DHCAnt.KSS.Config.BaseData",
			QueryName:"QryAllbasedata",
			ModuleName:"datagrid",
			Arg1:type,
			Arg2:"",
			Arg3:"",
			Arg4:PLObject.m_Hosp.getValue()||"",
			ArgCnt:4
		},
		border:false,
		singleSelect:true,
		toolbar:[{
				text:'����',
				iconCls: 'icon-add',
				handler: function(){
					addCfg()
					
				}
			
			},{
				text:'�޸�',
				iconCls: 'icon-write-order',
				handler: function(){
					editCfg()
					
				}
			}],
		frozenColumns:[
			{field:'ck',checkbox:false}
		],
		onBeforeSelect:function(index, row){
			var selrow=$("#i-tab-para-center").datagrid('getSelected');
			if (selrow){
				var oldIndex=$("#i-tab-para-center").datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					$("#i-tab-para-center").datagrid('unselectRow',index);
					return false;
				}
			}
		},
		columns:[[
			{field:'code',title:'������Ҵ���',width:80},
			{field:'descText',title:'�������',width:200},
			{field:'infectDepFlag',title:'��Ⱦ��־',width:50},
			{field:'specialFlag',title:'�����־',width:50},
			{field:'active',title:'�Ƿ񼤻�',width:50,
				formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>��</span>";
					} else if (value == "0") {
						return "<span class='c-no'>��</span>";
					} else {
						return value;
					}
				}
			},
			{field:'hospName',title:'����Ժ��',width:200},
			{field:'tableType',title:'������',width:100,hidden:true},
			{field:'tableName',title:'������',width:100,hidden:true},
			{field:'desc',title:'�������ID',width:200,hidden:true},
			{field:'id',title:'id',width:100,hidden:true}
		]]
	});	
	  
	    
	
})
function save(){
	var id = $("#i-config input[name='id']").val();
	var tableType=$("#i-config input[name='tableType']").val();
	var tableName=$("#i-config input[name='tableName']").val();
	var desc = $("#i-config-conloc-loc").simplecombobox('getValue');
	var desc = desc || "";
	var code = $("#i-config input[name='code']").val();
	var active = $("#i-tab-para-center-active").localcombobox('getValue')||"";
	var parCode = "";
	var aimItem = "";
	var specialFlag = $("#i-config input[name='specialFlag']").val();
	var infectDepFlag = $("#i-config input[name='infectDepFlag']").val();
	var action = $("#i-config input[name='action']").val();
	if (tableType == "") tableType = type;
	if (tableName == "") tableName = $.InvokeMethod("DHCAnt.Base.MainConfigExcute","GetOSDesc", type);
	var hosp = PLObject.m_Hosp.getValue()||"";
	if (hosp == "") {
		layer.alert("����ѡ��Ժ����", {title:'��ʾ',icon: 0}); 
		return false;
	}
	var paraStr = id + "^" + tableType + "^" + tableName + "^" + desc + "^" + code + "^" + active;
	paraStr = paraStr + "^" + parCode + "^" + aimItem + "^" + specialFlag + "^" + infectDepFlag + "^" + hosp; 
	
	if( $.trim(code) =="") {
		layer.alert("������Ҵ��벻��Ϊ�գ�", {title:'��ʾ',icon: 0}); 
		return false;
	}
	if( $.trim(desc) =="" ) {
		layer.alert("������Ҳ���Ϊ�գ�", {title:'��ʾ',icon: 0}); 
		return false;
	}
	if (CUROBJ.Loc != desc) {
		var hasLoc = $.InvokeMethod("DHCAnt.KSS.Config.BaseData","ifHasConLoc", desc);
		if (hasLoc == 1) {
			layer.alert("�����������ӣ�", {title:'��ʾ',icon: 0}); 
			return false;
		}
	}
	if (active == "") {
		layer.alert("�����־����Ϊ�գ�", {title:'��ʾ',icon: 0}); 
		return false;
	}
	var rtn=$.InvokeMethod("DHCAnt.KSS.Config.BaseData","DBSaveBasedata", paraStr);
	if (rtn <= 0) {	
		layer.alert("����ʧ��", {title:'��ʾ',icon: 5}); 
		return false;
	};
	if (action=="add"){
		layer.alert("��ӳɹ�...", {title:'��ʾ',icon: 1}); 
	} else {
		layer.alert("�޸ĳɹ�...", {title:'��ʾ',icon: 1}); 
	}
	reloadGrid();
	$('#i-config').window('close');
}
 
function reloadGrid() {
	var hosp = PLObject.m_Hosp.getValue()||"";
	$('#i-tab-para-center').simpledatagrid("reload",{
		ClassName:"DHCAnt.KSS.Config.BaseData",
		QueryName:"QryAllbasedata",
		ModuleName:"datagrid",
		Arg1:type,
		Arg2:"",
		Arg3:"",
		Arg4:hosp,
		ArgCnt:4
	});
}

function editCfg () {
	var selected = $('#i-tab-para-center').simpledatagrid('getSelected');
	if (!selected){
		layer.alert("��ѡ��һ����¼��", {title:'��ʾ',icon: 0});
		return false;
	};
	var domStr = "<div id='i-config' class='c-config'>" +
					'<div class="c-hidden">' +
						'<input type="hidden" name="id" />' +
						'<input type="hidden" name="action" />' + 
						'<input type="hidden" name="tableType" />' + 
						'<input type="hidden" name="tableName" />' + 
					'</div>' + 
					'<div class="row">' +
						'<span class="c-span">���Ҵ���</span><input id="i-config-conloc-code" class="textbox" type="text" name="code" style="width:150px;"/>' + 
						'<span class="c-span-sp"></span>'+
						'<span class="c-span">�������</span><input id="i-config-conloc-loc" type="text" name="desc" style="width:157px;" />' + 
					'</div>' +
					'<div class="row">' +
						'<span class="c-span">�����־</span><input class="textbox" type="text" name="specialFlag" style="width:150px;"/>' + 
						'<span class="c-span-sp"></span>'+
						'<span class="c-span">��Ⱦ��־</span><input class="textbox" type="text" name="infectDepFlag" style="width:150px;"/><br/>' + 
					'</div>' + 
					'<div class="row">' +
						'<span class="c-span">�Ƿ񼤻�</span><input id="i-tab-para-center-active" type="text" name="active" style="width:157px;" /><br/>' + 
					'</div>' + 
					'<div style="text-align:center;">' + 
						'<a id="i-config-btn" class="hisui-linkbutton" onclick="save()">����</a>'+
						//'<a id="i-config-btn" onclick="save()" class="btn btn-primary c-btn"><i class="fa fa-save"></i>&nbsp;����</a>' +
					'</div>' +
				'</div>';
				
	var $domStr = $(domStr);
	$("#i-msg").append($domStr);
	$("#i-config-btn").linkbutton({iconCls:'icon-w-save'});
	$("#i-tab-para-center-active").localcombobox({
		data:[{id: '1', text: '��'}, {id: '0',text: '��'}]
	});
	$('#i-config-conloc-loc').simplecombobox({
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Config.Authority";
			param.QueryName="QryGetdep";
			param.ModuleName="combobox";
			param.Arg1="";
			param.Arg2=PLObject.m_Hosp.getValue()||"";
			param.ArgCnt=2;
		},
		value:selected.desc
	});
	CUROBJ.Loc = selected.desc;
	$("#i-config input[name='id']").val(selected.id);
	$("#i-config input[name='tableType']").val(selected.tableType);
	$("#i-config input[name='tableName']").val(selected.tableName);
	$("#i-config input[name='action']").val("update");
	$("#i-config input[name='code']").val(selected.code);
	//$("#i-config input[name='desc']").val(selected.desc);
	$("#i-config input[name='specialFlag']").val(selected.specialFlag);
	$("#i-config input[name='infectDepFlag']").val(selected.infectDepFlag);
	$("#i-tab-para-center-active").localcombobox("setValue", selected.active);
	$('#i-config').window({
		title: '�޸Ļ������',
		modal: true,
		iconCls:'icon-w-edit',
		maximizable:false,
		minimizable:false,
		collapsible:false,
		onClose: function () {
			$("#i-config").window('destroy');
			$domStr.remove();
		}
	});
}

function InitHospList() {
	PLObject.m_Hosp = GenHospComp("Ant_Config_Data_ConLoc");
	PLObject.m_Hosp.jdata.options.onSelect = function(e,t){
		reloadGrid();
	}
	PLObject.m_Hosp.jdata.options.onLoadSuccess= function(data){
		//Init();
	}
}

function addCfg() {
	var domStr = "<div id='i-config' class='c-config'>" +
			'<div class="c-hidden">' +
				'<input type="hidden" name="id" />' +
				'<input type="hidden" name="action" />' + 
				'<input type="hidden" name="tableType" />' + 
				'<input type="hidden" name="tableName" />' + 
			'</div>' + 
			'<div class="row">' +
				'<span class="c-span">���Ҵ���</span><input id="i-config-conloc-code" class="textbox" type="text" name="code" style="width:150px;"/>' + 
				'<span class="c-span-sp"></span>'+
				'<span class="c-span">�������</span><input id="i-config-conloc-loc" type="text" name="desc" style="width:157px;" />' + 
			'</div>' +
			'<div class="row">' +
				'<span class="c-span">�����־</span><input class="textbox" type="text" name="specialFlag" style="width:150px;"/>' + 
				'<span class="c-span-sp"></span>'+
				'<span class="c-span">��Ⱦ��־</span><input class="textbox" type="text" name="infectDepFlag" style="width:150px;"/><br/>' + 
			'</div>' + 
			'<div class="row">' +
				'<span class="c-span">�Ƿ񼤻�</span><input id="i-tab-para-center-active" type="text" name="active" style="width:157px;" /><br/>' + 
			'</div>' + 
			'<div style="text-align:center;">' + 
				'<a id="i-config-btn" class="hisui-linkbutton" onclick="save()">����</a>'+
				//'<a id="i-config-btn" onclick="save()" class="btn btn-primary c-btn"><i class="fa fa-save"></i>&nbsp;����</a>' +
			'</div>' +
		'</div>';
	var $domStr = $(domStr);
	$("#i-msg").append($domStr);
	$("#i-config-btn").linkbutton({iconCls:'icon-w-save'});
	$("#i-tab-para-center-active").localcombobox({
		data:[{id: '1', text: '��'}, {id: '0',text: '��'}]
	});

	$('#i-config-conloc-loc').simplecombobox({
		onBeforeLoad: function(param){
			param.ClassName="DHCAnt.KSS.Config.Authority";
			param.QueryName="QryGetdep";
			param.ModuleName="combobox";
			param.Arg1="";
			param.Arg2=PLObject.m_Hosp.getValue()||"";
			param.ArgCnt=2;
		},
		value:""
	});
	CUROBJ.Loc = "";
	$("#i-config input[name='action']").val("add");

	$("#i-config input[name='id']").val("");
	$("#i-config input[name='tableType']").val("");
	$("#i-config input[name='tableName']").val("");
	$("#i-config input[name='code']").val("");

	$("#i-config-conloc-loc").simplecombobox("setValue","");
	$("#i-config input[name='specialFlag']").val("");
	$("#i-config input[name='infectDepFlag']").val("");

	$('#i-config').window({
		title: '��ӻ������',
		modal: true,
		iconCls:'icon-w-add',
		minimizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			$("#i-config").window('destroy');
			$domStr.remove();
		}
	});
}