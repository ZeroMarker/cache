/**
 * dhcant.kss.config.function.app.js - KJ Config Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-03-09
 * 
 */
var PageObj = {
	m_Grid: "",
	m_Hosp: ""
}

$(function(){
	InitHospList();
	InitGrid();
	
})

function InitGrid() {
	PageObj.m_Grid = $HUI.datagrid("#i-tab-process", {
		pagination:true,
		fit:true,
		border:false,
		//headerCls:'panel-header-gray',
		iconCls:'fa fa-gavel',
		singleSelect:true,
		url:$URL,
		fitColumns:true,
		queryParams: {
			ClassName:"DHCAnt.KSS.Extend.Hosp",
			QueryName:"QryProcessConfig",
			InHosp:""
		},
		idField:"id",
		columns:[[
			{field:'ParentCode',title:'�������ʹ���',width:100,hidden:true},
			{field:'ParentDesc',title:'������������',width:150},
			{field:'MCGType',title:'�������ʹ���',width:100,hidden:true},
			{field:'CodeF',title:'�Ƿ����Ԥ��',width:100,align:'center',
				formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>��</span>"
					} else {
						return "<span class='c-no'>��</span>"
					}
				},
				editor:{
					type:'icheckbox',
					options:{
						on: '1',
						off: '0'
					}
				}
			},
			{field:'CodeH',title:'�Ƿ����',width:100,align:'center',
				formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>��</span>"
					} else {
						return "<span class='c-no'>��</span>"
					}
				},
				editor:{
					type:'icheckbox',
					options:{
						on: '1',
						off: '0'
					}
				}
			},
			{field:'CodeS',title:'�Ƿ�������',width:100,align:'center',
				formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>��</span>"
					} else {
						return "<span class='c-no'>��</span>"
					}
				},
				editor:{
					type:'icheckbox',
					options:{
						on: '1',
						off: '0'
					}
				}
			},
			{field:'CodeU',title:'�Ƿ��������',width:100,align:'center',
				formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>��</span>"
					} else {
						return "<span class='c-no'>��</span>"
					}
				},
				editor:{
					type:'icheckbox',
					options:{
						on: '1',
						off: '0'
					}
				}
			},
			{field:'ULocID',title:'������˿���',width:100,
				formatter:function(value,row){
					return row.ULocDesc;
				},
				/* editor:{
					type:'combobox',
					options:{
						valueField:'id',
						textField:'desc',
						data:products,
						required:false
					}
				}, */
				editor:{
					type:'combobox',
					options:{
						valueField:'ULocID',
						textField:'ULocDesc',
						defaultFilter:4,
						//multiple:true,
						url:$URL+"?ClassName=DHCAnt.KSS.Common.Query&QueryName=QryAllDep&ResultSetType=array",
						mode:'remote',
						//data:PageLogicObj.m_HisDoc,
						required:false,
						blurValidValue:true,
						onBeforeLoad:function(param){
							param.inHosp= getHospValue();
							//param.indesc= param[q];
						
						}
					}
				}
						
			},
			{field:'id',title:'id',width:100,hidden:true},
			{field:'action',title:'����',width:50,align:'center',
				formatter:function(value,row,index){
					var listId = "#i-tab-process";
					if (row.editing){
						var s = '<span style="cursor:pointer;" onclick="ANT.saveGridRow(this,' + "'" + listId + "'" + ')"><img src="../scripts/dhcdocant/img/uicon/27-save.png" /></span>&nbsp;&nbsp;';
						var c = '<span style="cursor:pointer;" onclick="ANT.cancelGridRow(this,' + "'" + listId + "'" + ')"><img src="../scripts/dhcdocant/img/uicon/26-no.png" /></span>';
						return s + c;
					} else {
						var e = '<span style="cursor:pointer;" onclick="ANT.editGridRow(this,' + "'" + listId + "'" + ')"><img src="../scripts/dhcdocant/img/uicon/28-edit.png" /></span> ';
						return e;
					}
				}
			}
		]],
		onLoadSuccess:function(data){  
			//var eds = $('#i-tab-process').datagrid('getEditors',index);  
			//$(eds[0].target).bind('click',function(){  
			//});
			/*
			$(".datagrid-header-check").html("");
			 if (data.rows.length > 0) {
                 for (var i = 0; i < data.rows.length; i++) {
                    $("input[type='checkbox']").remove();
                 }
			 }*/
		},
		frozenColumns:[
			{field:'ck',checkbox:false}
		],
		onBeforeEdit:function(index,row){
			row.editing = true;
			ANT.updateGridActions(index, "#i-tab-process");
		},
		onAfterEdit:function(index,row){
			row.editing = false;
			ANT.updateGridActions(index, "#i-tab-process");
			var selected = $('#i-tab-process').simpledatagrid('getSelected');
			if (!selected){
				layer.alert("��ѡ��һ����¼", {title:'��ʾ',icon: 0}); 
				return false;
			};
			if ($.trim(selected.CodeU) == "1") {
				if (($.trim(selected.ULocID) == "")||(!selected.ULocID)) {
					layer.alert("�����а���������ˣ�����Ҫά��������˿��ң�", {title:'��ʾ',icon: 0}); 
					
					$(this).simpledatagrid('reload').simpledatagrid('clearSelections');
					return false;
				}
			} 
			var type = selected.MCGType;
			var parCode = selected.ParentCode;
			var processStr=selected.CodeF + "^" + selected.CodeH + "^" + selected.CodeS + "^" + selected.CodeU;
			var finalDep = selected.ULocID||"";
			if ((selected.CodeF == 0) && (selected.CodeH == 0) && (selected.CodeS == 0) && (selected.CodeU == 0)) {
				layer.alert("��������һ�����̲��裡", {title:'��ʾ',icon: 2});
				//$.messager.alert("��ʾ", "����ʧ��", "error");
				//$(this).simpledatagrid('reload').simpledatagrid('clearSelections');
				PageObj.m_Grid.reload();
				return false;
			};
			var mcgValue="A",
				mcgCode = selected.ParentCode,
				mcgHosp = getHospValue(),
				id = selected.id;
			
			if (mcgHosp == "") {
				layer.alert("��ѡ��Ժ����", {title:'��ʾ',icon: 2});
				return false;
			}
			if (selected.CodeF==1) {
				mcgValue = mcgValue + ",F"
			}
			if (selected.CodeH==1) {
				mcgValue = mcgValue + ",H"
			}
			if (selected.CodeS==1) {
				mcgValue = mcgValue + ",S"
			}
			if (selected.CodeU==1) {
				mcgValue = mcgValue + ",U"
			}
			//var rtn=$.InvokeMethod("DHCAnt.KSS.Config.Function","DBInsertProcessConfig", type, parCode, processStr, loc);
			var result = $m({
				ClassName:"DHCAnt.Base.MainConfigExcute",
				MethodName:"SaveProcess",
				mcgCode:mcgCode,
				mcgValue:mcgValue,
				mcgHosp:mcgHosp,
				finalDep:finalDep,
				id:id
			},false);
			
			if (result == "1") {
				layer.alert("����ɹ���", {title:'��ʾ',icon: 1}); 
			} else {
				layer.alert("����ʧ�ܣ�", {title:'��ʾ',icon: 2});
			};
			//$(this).simpledatagrid('reload').simpledatagrid('clearSelections');
			PageObj.m_Grid.reload()
			PageObj.m_Grid.clearSelections();
			return false;
				
		},
		onCancelEdit:function(index,row){
			row.editing = false;
			ANT.updateGridActions(index, "#i-tab-process");
		}
	});
}

function InitHospList() {
	PageObj.m_Hosp = GenHospComp("Ant_Config_Func_Process");
	PageObj.m_Hosp.jdata.options.onSelect = function(rowIndex,data){
		//PageObj.m_Hosp = data.HOSPRowId;
		reloadGrid(data.HOSPRowId);
		
	}
	PageObj.m_Hosp.jdata.options.onLoadSuccess= function(data){
		//PageObj.m_Hosp = session['LOGON.HOSPID'];
		reloadGrid(session['LOGON.HOSPID']);
		
	}
}
function reloadGrid (inHosp) {
	PageObj.m_Grid.reload({
		ClassName:"DHCAnt.KSS.Extend.Hosp",
		QueryName:"QryProcessConfig",
		InHosp:inHosp
	})
}
function getHospValue () {
	if (PageObj.m_Hosp=="") {
		return session['LOGON.HOSPID'];
	}
	var hospId = PageObj.m_Hosp.getValue()||"";
	if (hospId == "") {
		return session['LOGON.HOSPID'];
	}
	return hospId;
}
