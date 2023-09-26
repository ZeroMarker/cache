/**
 * dhcant.kss.business.apply.js ����ҩ�������б�
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2016-08-20
 * 
 */
$(function(){
	/**
	 * QP
	 * 2016-08-20
	 * ����������
	**/
	function createAuditPanel(EpisodeID, userid) {
		var consultDisplay1 = true,
			consultDisplay2 = true,
			consultDisplay3 = true,
			$applyGrid = $("<div id='i-apply-grid'></div>"),
			consultDepNums=tkMakeServerCall("DHCAnt.KSS.Common.Method","GetConsultDepNums"),
			$applyWin = $("<div id='i-apply-win' style='width:900px;height:400px;'>Window Content</div>");
			if (consultDepNums == "1") {
				consultDisplay1 = false;
			} else if (consultDepNums == "2") {
				consultDisplay1 = false;
				consultDisplay2 = false;
			} else {
				consultDisplay1 = false;
				consultDisplay2 = false;
				consultDisplay3 = false;
			};
		$("#i-apply-win").remove();
		$("body").prepend($applyWin);
		$("#i-apply-win").prepend($applyGrid);
		
		$('#i-apply-win').window({
			iconCls:'icon-search',
			title: '<span style="color:#0E2D5F; font-size:14px;">����ҩ������б�</span>',
			modal: true,
			minimizable:false,
			collapsible:false,
			onClose: function () {
				$("#i-apply-win").remove();
			}
		});
		
		$('#i-apply-grid').datagrid({
				idField:'id',
				method:	'post',
				striped:true,
				nowrap: true,
				fit:true,
				rownumbers:true,
				singleSelect:true,
				//checkOnSelect:false,
				mode:'remote',
				loadMsg:"���ڼ������ݣ������ĵȴ�...",
				pagination:false,
				frozenColumns:[[
					{field:'ck',checkbox:true}
				]],
				queryParams: {
					ClassName:"DHCAnt.KSS.MainInterface",
					QueryName:"QryAntApplyInfo",
					ModuleName:"datagrid",
					Arg1:GlobalObj.EpisodeID,
					Arg2:session['LOGON.USERID'],
					ArgCnt:2
				},
				/*rowStyler:function(index,row){
					if (row.AppStatus == "A"){
						return 'background-color:#8DB6CD;color:#fff;';
					} else if (row.AppStatus == "F") {
						
					} else if (row.AppStatus == "H") {
						
					} else if (row.AppStatus == "S") {
						
					} else if (row.AppStatus == "R") {
						return 'background-color:#E9967A;color:#fff;';
					}
					else {
						return 'background-color:#9BCD9B;color:#fff;';
					};
				},*/
				columns:[[
					{field:'ArcimName',title:'ҽ����',width:250},
					{field:'AppStatusDesc',title:'��ǰ״̬',width:100
						,styler: function(value,row,index){
							//9BCD9B E9967A 8DB6CD
							if ((row.AppStatus == "U")&&(row.checkboxok == "1")){
								return 'background-color:#66CDAA;color:#fff;padding:2px;';
							} else if (row.AppStatus == "R") {
								return 'background-color:#F08080;color:#fff;padding:2px;';
							} else {
								//return 'background-color:#8DB6CD;color:#fff;padding:2px;';
							}
						}
					},
					{field:'AuditUserName',title:'�����',width:100},
					{field:'AuditDT',title:'���ʱ��',width:150},
					{field:'AppDT',title:'����ʱ��',width:150},
					{field:'AppUserName',title:'������',width:100},
					{field:'EmergencyDesc',title:'�Ƿ�Խ��',width:100},
					{field:'ProcessInfo',title:'��������',width:100},
					{field:'ConsultDT1',title:'��������1',width:150,hidden:consultDisplay1},
					{field:'ConsultDoc1',title:'����ҽ��1',width:100,hidden:consultDisplay1},
					{field:'ConsultDT2',title:'��������2',width:150,hidden:consultDisplay2},
					{field:'ConsultDoc2',title:'����ҽ��2',width:100,hidden:consultDisplay2},
					{field:'ConsultDT3',title:'��������3',width:150,hidden:consultDisplay3},
					{field:'ConsultDoc3',title:'����ҽ��3',width:100,hidden:consultDisplay3},
					{field:'AppStatus',title:'״̬����',width:100},
					{field:'checkboxok',title:'checkboxok',width:100,hidden:true},
					{field:'id',title:'id',width:100,hidden:true}
				]],
				url:'dhcant.kss.main.request.csp?action=GetQueryData',
				toolbar:[{
						text:'ȷ��',
						iconCls: 'icon-edit',
						handler: function(){
							var selected = $('#i-apply-grid').datagrid('getSelected');
							if (!selected){
								$.messager.alert('��ʾ','��ѡ��һ����¼','info');
								return false;
							};
							var AnditAARowidArr=selected.id + "^"
							//DHCAnt.KSS.MainInterface.GetAddToListArcimInfo
							var ret=cspRunServerMethod(GlobalObj.AddAuditItemToListMethod,'AddCopyItemToList','',EpisodeID,AnditAARowidArr);
							$('#i-apply-win').window('close');
						}
					}/*,'-',{
						text:'��ϵ��ʽ',
						iconCls: 'icon-help',
						handler: function(){
							$.messager.alert('��ʾ','������������ϵҽ����������֧����: ����','info');
						}
					}*/
				],
				onLoadSuccess: function(data){
					if (data.rows.length > 0) {
						for (var i = 0; i < data.rows.length; i++) {
							if (data.rows[i].checkboxok == 0) {
								//$("input[type='checkbox']")[i + 1].disabled = true;
								$(".datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[0].disabled = true;
							};
						};
					};
				},
				onClickRow: function(rowIndex, rowData){
					$("input[name='ck']").each(function(index, el){
						if (el.disabled == true) {
							$('#i-apply-grid').datagrid('unselectRow', index);
						};
					});
				},
				onDblClickRow: function(rowIndex, rowData){
					$("input[name='ck']").each(function(index, el){
						if (el.disabled == true) {
							$('#i-apply-grid').datagrid('unselectRow', index);
						};
					});
				}
			});
		
	};
	window.AuditInfo = createAuditPanel;
	window.GetKSSOrderStopInfo=function(){};
	window.DHCANT = {};
	$.extend(DHCANT, {
		getEmergencyFlag: function () {
			var mRtn=0
			var rowids=$('#Order_DataGrid').getDataIDs();
			if (rowids) {
				for (var i=0; i<(rowids.length-1); i++){
					var Row=rowids[i];
					var OrderAntibApplyRowid=GetCellData(Row,"OrderAntibApplyRowid");
					var Reasonid=GetCellData(Row,"UserReasonId");
					var SpecialAction=GetCellData(Row,"SpecialAction");
					if ((OrderAntibApplyRowid!="")&&(SpecialAction!="")) {
						mRtn = 1
					}
			  
				}
			}
			return mRtn;
		},
		sendEmergencyMsg: function(rowids) {
			var para="";
			for(var i = 0; i< rowids.length; i++){
				var OrderAntibApplyRowid = GetCellData(rowids[i],"OrderAntibApplyRowid");
				var UserReasonId = GetCellData(rowids[i],"UserReasonId");
				if (para == "") {
					para = OrderAntibApplyRowid;
				} else {
					para = para + "^" + OrderAntibApplyRowid;
				};
			};
			var result = tkMakeServerCall("DHCAnt.KSS.MainBusiness","ComSendEmergencyMsg",para);
			return result;
		}
	})
	
	
});
 