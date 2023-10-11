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
			$applyGrid = "";
		if (HISUIStyleCode=="blue") {
			$applyGrid = $("<div style='border:1px solid #ccc;height:400px;border-radius:4px;'><div id='i-apply-grid'></div></div>");
		} else {
			$applyGrid = $("<div style='border:1px solid #E2E2E2;height:400px;border-radius:4px;'><div id='i-apply-grid'></div></div>");
		}
		var 
			consultDepNums = tkMakeServerCall("DHCAnt.KSS.Common.Method","GetConsultDepNums",session['LOGON.HOSPID']),
			curUserCtcareId = tkMakeServerCall("DHCAnt.KSS.Common.Method", "TransSSUserToCTCare", session['LOGON.USERID']),
			$applyWin = $("<div id='i-apply-win' style='width:900px;height:400px;padding:10px;'></div>");
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
			//iconCls:'icon-search',
			title: '<span style="font-size:14px;">'+$g("����ҩ�������б�")+'</span>',
			modal: true,
			border:false,
			iconCls: 'icon-w-list',
			maximizable:false,
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
				border:true,
				nowrap: true,
				fit:true,
				bodyCls:'panel-body-gray',
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
					Arg3:session['LOGON.HOSPID'],
					ArgCnt:3
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
					{field:'action',title:$g('����'),width:40,align:'center',
						formatter:function(value,row,index){
							if ((row.AppStatus == "A")&&(row.cOeori == "")){
								var s = '<a href="#" style="color:#40A2DE;" onclick="DHCANT.undoApply(' + row.id + ", '" + row.AppStatus + "'" + ')">����</a>';
								return s;
							} else {
								return "";
							}
						}
					},
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
					/*,{field:'detail',title:'��ϸ',width:40,align:'center',
						formatter:function(value,row,index){
							var s = '<span style="color:#40A2DE;cursor:pointer;" onclick="DHCANT.findDetail(' + row.id + ')">��ϸ</span>';
							return s;
						}
					}*/
				]],
				url:'dhcant.kss.main.request.csp?action=GetQueryData',
				toolbar:[{
						text:'ȷ��',
						iconCls: 'icon-ok',
						handler: function(){
							var selected = $('#i-apply-grid').datagrid('getSelected');
							if (!selected){
								$.messager.alert('��ʾ','��ѡ��һ����¼','info');
								return false;
							};
							var SCQMX = $.cm({
								ClassName:"DHCAnt.KSS.Extend.CQMX",
								MethodName:"IsFillCqmx",
								dataType:"text",
								arcim:selected.ArcimId,
								InHosp:session['LOGON.HOSPID']
							},false);
							
							if (SCQMX==1) {
								//ҵ��ģʽ
								var MCQMX = $.cm({
									ClassName:"DHCAnt.Base.MainConfigExcute",
									MethodName:"GetValueByMCGCode",
									dataType:"text",
									mcgCode:"MCQMX",
									mcgHosp:session['LOGON.HOSPID']
								},false);
								
								if (MCQMX == 2) {
									var content = "<div style='margin-bottom:10px;'><span style='margin-right:10px;'>��Ҫ���</span><input id='CQMX-MainDiag' type='text' style='width:155px;'>" + 
													"<span style='margin:0px 10px 0px 30px;'>ҩ���÷�</span><input id='CQMX-Instruc' type='text' style='width:155px;'></div>" +
													"<div style='margin-bottom:10px;'><span style='margin-right:10px;'>�Ƿ����</span><input id='CQMX-IsConsult' type='text' style='width:155px;'>" +
													"<span style='margin:0px 10px 0px 30px;'>�Ƿ����</span><input id='CQMX-IsEmergency' type='text' style='width:155px;'></div>" +
													"<div style='margin-bottom:10px;'><span style='margin-right:10px;'>�Ƿ��ͼ�</span><input id='CQMX-IsLab' type='text' style='width:155px;'>" +
													"<span style='margin:0px 10px 0px 30px;'>��������</span><input id='CQMX-LocName' class='textbox' type='text'></div>" +
													"<div style='margin-bottom:10px;'><span style='margin-right:10px;'>ҩƷ����</span><input class='textbox' id='CQMX-DrugName' type='text'>" +
													"<span style='margin:0px 10px 0px 30px;'>��������</span><input id='CQMX-PatName' class='textbox' type='text'></div>" +
													"<div style='margin-bottom:10px;'><span style='margin-right:10px;'>����ҽʦ</span><input id='CQMX-PrescDoc' class='textbox' type='text'>" +
													"<span style='margin:0px 10px 0px 30px;'>��������</span><input id='CQMX-IPNo' class='textbox' type='text'></div>" +
													"<div style='margin-bottom:10px;'><span style='margin-right:10px;'>��������</span><input id='CQMX-PrescDate' class='textbox' type='text'></div>" + 
													"<div style='text-align:center;'><a id='CQMX-Save' class='hisui-linkbutton hover-dark'>����</a></div>";
									DHCANT.diagShow("cqmx-win","̼��ùϩ�༰��ӻ���ʹ����Ϣ�ǼǱ�",495,327,content);
									DHCANT.drawCqmx(selected.ArcimName);
									var AnditAARowidArr=selected.id + "^";
									DHCANT.saveCqmx(selected.ArcimId, AnditAARowidArr);
									
									return true;
								} else {
									var AnditAARowidArr=selected.id + "^"
									//DHCAnt.KSS.MainInterface.GetAddToListArcimInfo
									var ret=cspRunServerMethod(GlobalObj.AddAuditItemToListMethod,'AddCopyItemToList','',EpisodeID,AnditAARowidArr);
									$('#i-apply-win').window('close');
								}
							} else { //
								var AnditAARowidArr=selected.id + "^"
								//DHCAnt.KSS.MainInterface.GetAddToListArcimInfo
								var ret=cspRunServerMethod(GlobalObj.AddAuditItemToListMethod,'AddCopyItemToList','',EpisodeID,AnditAARowidArr);
								$('#i-apply-win').window('close');
							}
						}
					}/*,'-',{
						text:'����˵��',
						iconCls: 'icon-undo',
						handler: function(){
							
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
                    var ApplyId=rowData.id;
					if (websys_getAppScreenIndex()==0){
						var Obj={
							ApplyId:rowData.id,
							EpisodeID:GlobalObj.EpisodeID,
							PageShowFromWay:"ListEntry"
						}
						websys_emit("onOpenKSSInterface",Obj);
					}
				},
				onDblClickRow: function(rowIndex, rowData){
					$("input[name='ck']").each(function(index, el){
						if (el.disabled == true) {
							$('#i-apply-grid').datagrid('unselectRow', index);
						};
					});
					return;
					var tempFlag = (rowData.AppStatus == "A")|| (rowData.AppStatus == "F");
					var tempFlag2 = rowData.ProcessInfo.indexOf("A,H")>= 0;
					var tempFlag3 = rowData.ProcessInfo.indexOf("A,F,H")>= 0;
					if ( tempFlag2 && tempFlag3) {
						return false;
					};
					if ( tempFlag2 && (rowData.AppStatus != "A")) {
						return false;
					};
					if ( tempFlag3 && (rowData.AppStatus != "F")) {
						return false;
					};
					var conApplyInfo = tkMakeServerCall("DHCAnt.KSS.FunctionExtend","GetConsultApplyInfo",rowData.id);
					var conApplyArr = conApplyInfo.split("^");
					var conAPP1 = conApplyArr[0].split(":"),conAPP2 = conApplyArr[1].split(":"),conAPP3 = conApplyArr[2].split(":");
					var ds1 = true, ds2 = true, ds3 = true;
					if (conAPP1[2]==0)  ds1 = false;
					if (conAPP2[2]==0)  ds2 = false;
					if (conAPP3[2]==0)  ds3 = false;
					//����:�޸Ļ�����ҽ���
					if ( (rowData.ProcessInfo.indexOf("H") >=0) && tempFlag ) {
						
						var appStr = "<div id='i-con-content' style='padding:15px 2px;text-align:center;'>";
						//appStr = appStr + "<div style='margin:0px 0px 10px 0px;'>"
						appStr = appStr + "<div style='margin:0px 0px 10px 0px;'>"
						appStr = appStr + "<label style='margin:0px 6px;'>�������1</label><input id='i-con1-loc' style='margin-right:15px;' />";
						appStr = appStr + "<label style='margin:0px 6px;'>����ҽ��1</label><input id='i-con1-doc' />";
						appStr = appStr + "</div>"
						
						appStr = appStr + "<div style='margin:10px 0px;'>"
						appStr = appStr + "<label style='margin:0px 6px;'>�������2</label><input id='i-con2-loc' style='margin-right:15px;' />";
						appStr = appStr + "<label style='margin:0px 6px;'>����ҽ��2</label><input id='i-con2-doc' /><br/>";
						appStr = appStr + "</div>"
						
						appStr = appStr + "<div style='margin:10px 0px;'>"
						appStr = appStr + "<label style='margin:0px 6px;'>�������3</label><input id='i-con3-loc' style='margin-right:15px;' />";
						appStr = appStr + "<label style='margin:0px 6px;'>����ҽ��3</label><input id='i-con3-doc' /><br/>";
						appStr = appStr + "</div>"
						
						appStr = appStr + "<div id='i-con-save' style='cursor:pointer;margin:10px auto;margin-bottom:0px;line-height:28px;background:#5BC0DE;width:100px;color:#fff;height:28px;'>����</div>";
						appStr = appStr + "</div>";
						
						var _conContent = $(appStr),
						    _conWin = $("<div id='i-con-win' style='width:500px;height:210px;'></div>");
						$("#i-con-win").remove();
						$("body").prepend(_conWin);
						$("#i-con-win").prepend(_conContent);
						
						
						$('#i-con1-loc').simplecombobox({
							onBeforeLoad: function(param){
								param.ClassName="DHCAnt.KSS.MainInterface";
								param.QueryName="QryConsultationLoc";
								param.ModuleName="combobox";
								param.Arg1=session['LOGON.CTLOCID'];
								param.ArgCnt=1;
							},
							disabled:ds1,
							value:conAPP1[0],
							onSelect:function(record) {
								$('#i-con1-doc').simplecombobox('clear');
								$('#i-con1-doc').simplecombobox({
									onBeforeLoad: function(param){
										param.ClassName="DHCAnt.KSS.MainInterface";
										param.QueryName="QryConsultationDoc";
										param.ModuleName="combobox";
										param.Arg1=record.id;
										param.ArgCnt=1;
									},
									value:'',
									onSelect: function(r){
										var	doc1 = r.id,
											loc1 = record.id,
											doc2 = "",
											loc2 = "",
											doc3 = "",
											loc3 = "";
											if (curUserCtcareId == r.id ) {
												$.messager.alert('��ʾ','����ҽʦ����ѡ�����뱾��!','info');
												$(this).simplecombobox('clear');
												return false;
											};
											if ( (r.id == conAPP1[1]) || (r.id == conAPP2[1]) || (r.id == conAPP3[1]) ) {
												$.messager.alert('��ʾ','֮ǰ������ѡ����ҽ��!','info');
												$(this).simplecombobox('clear');
												return false;
											};
											if (consultDepNums == "3") {
												doc3 = $('#i-con3-doc').simplecombobox('getValue')||"";
												loc3 = $('#i-con3-loc').simplecombobox('getValue')||"";
												doc2 = $('#i-con2-doc').simplecombobox('getValue')||"";
												loc2 = $('#i-con2-loc').simplecombobox('getValue')||"";
											};
											if (consultDepNums == "2") {
												doc2 = $('#i-con2-doc').simplecombobox('getValue')||"";
												loc2 = $('#i-con2-loc').simplecombobox('getValue')||"";
											};								
										var flag1 = (doc2!="")&&((doc1==doc2)||(doc2==doc3)),
											flag2 = (doc3!="")&&((doc3==doc1)||(doc3==doc2));
										if (flag1||flag2) {
											$.messager.alert('��ʾ','����ҽ���ظ�!','info');
											$(this).simplecombobox('clear');
											return false;
										};
									}
									
								});
								
							}
						});
						
						$('#i-con1-doc').simplecombobox({
							onBeforeLoad: function(param){
								param.ClassName="DHCAnt.KSS.MainInterface";
								param.QueryName="QryConsultationDoc";
								param.ModuleName="combobox";
								param.Arg1=conAPP1[0];
								param.ArgCnt=1;
							},
							value:conAPP1[1],
							disabled:ds1
						});
						
						switch (consultDepNums) { 
							case "3":
								$('#i-con3-loc').simplecombobox({
									onBeforeLoad: function(param){
										param.ClassName="DHCAnt.KSS.MainInterface";
										param.QueryName="QryConsultationLoc";
										param.ModuleName="combobox";
										param.Arg1=session['LOGON.CTLOCID'];
										param.ArgCnt=1;
									},
									disabled:ds3,
									value:conAPP3[0],
									onSelect:function(record) {
										$('#i-con3-doc').simplecombobox('clear');
										$('#i-con3-doc').simplecombobox({
											onBeforeLoad: function(param){
												param.ClassName="DHCAnt.KSS.MainInterface";
												param.QueryName="QryConsultationDoc";
												param.ModuleName="combobox";
												param.Arg1=record.id;
												param.ArgCnt=1;
											},
											value:'',
											onSelect: function(r){
												var doc1 = $('#i-con1-doc').simplecombobox('getValue')||"",
													loc1 = $('#i-con1-loc').simplecombobox('getValue')||"",
													doc2 = $('#i-con2-doc').simplecombobox('getValue')||"",
													loc2 = $('#i-con2-loc').simplecombobox('getValue')||"",
													doc3 = r.id,
													loc3 = record.id;
												if (curUserCtcareId == r.id ) {
													$.messager.alert('��ʾ','����ҽʦ����ѡ�����뱾��!','info');
													$(this).simplecombobox('clear');
													return false;
												};
												if ( (r.id == conAPP1[1]) || (r.id == conAPP2[1]) || (r.id == conAPP3[1]) ) {
													$.messager.alert('��ʾ','֮ǰ������ѡ����ҽ��!','info');
													$(this).simplecombobox('clear');
													return false;
												};
												var flag1 = (doc1!="")&&((doc1==doc2)||(doc1==doc3)),
													flag2 = (doc2!="")&&((doc1==doc2)||(doc2==doc3));
												if (flag1||flag2) {
													$.messager.alert('��ʾ','����ҽ���ظ�!','info');
													$(this).simplecombobox('clear');
													return false;
												};
												
											}
										});
										
									}
								});
								$('#i-con3-doc').simplecombobox({
									onBeforeLoad: function(param){
										param.ClassName="DHCAnt.KSS.MainInterface";
										param.QueryName="QryConsultationDoc";
										param.ModuleName="combobox";
										param.Arg1=conAPP3[0];
										param.ArgCnt=1;
									},
									value:conAPP3[1],
									disabled:ds3
								})
							case "2":
								$('#i-con2-loc').simplecombobox({
									onBeforeLoad: function(param){
										param.ClassName="DHCAnt.KSS.MainInterface";
										param.QueryName="QryConsultationLoc";
										param.ModuleName="combobox";
										param.Arg1=session['LOGON.CTLOCID'];
										param.ArgCnt=1;
									},
									value:conAPP2[0],
									disabled:ds2,
									onSelect:function(record) {
										$('#i-con2-doc').simplecombobox('clear');
										$('#i-con2-doc').simplecombobox({
											onBeforeLoad: function(param){
												param.ClassName="DHCAnt.KSS.MainInterface";
												param.QueryName="QryConsultationDoc";
												param.ModuleName="combobox";
												param.Arg1=record.id;
												param.ArgCnt=1;
											},
											value:'',
											onSelect: function(r){
												var doc1 = $('#i-con1-doc').simplecombobox('getValue')||"",
													loc1 = $('#i-con1-loc').simplecombobox('getValue')||"",
													doc2 = r.id,
													loc2 = record.id,
													doc3 = "",
													loc3 = "";
													if (curUserCtcareId == r.id ) {
														$.messager.alert('��ʾ','����ҽʦ����ѡ�����뱾��!','info');
														$(this).simplecombobox('clear');
														return false;
													};
													if ( (r.id == conAPP1[1]) || (r.id == conAPP2[1]) || (r.id == conAPP3[1]) ) {
														$.messager.alert('��ʾ','֮ǰ������ѡ����ҽ��!','info');
														$(this).simplecombobox('clear');
														return false;
													};
													if (consultDepNums == "3") {
														doc3 = $('#i-con3-doc').simplecombobox('getValue')||"";
														loc3 = $('#i-con3-loc').simplecombobox('getValue')||"";
													}
												var flag1 = (doc1!="")&&((doc1==doc2)||(doc1==doc3)),
													flag2 = (doc3!="")&&((doc3==doc1)||(doc3==doc2));
												if (flag1||flag2) {
													$.messager.alert('��ʾ','����ҽ���ظ�!','info');
													$(this).simplecombobox('clear');
													return false;
												};
											}
										});
										
									}
								});
								$('#i-con2-doc').simplecombobox({
									onBeforeLoad: function(param){
										param.ClassName="DHCAnt.KSS.MainInterface";
										param.QueryName="QryConsultationDoc";
										param.ModuleName="combobox";
										param.Arg1=conAPP2[0];
										param.ArgCnt=1;
									},
									value:conAPP2[1],
									disabled:ds2
								})
								break;
							default: //
						};
						
						$('#i-con-win').window({
							iconCls:'icon-edit',
							title: '<span style="color:#0E2D5F; font-size:14px;">&nbsp;'+ (rowIndex+1) + '������Ϣ�޸�</span>',
							modal: true,
							border:false,
							minimizable:false,
							collapsible:false,
							onClose: function () {
								$("#i-con-win").remove();
							}
						});
						
						$("#i-con-save").on("click", function () {
							var doc1 = $('#i-con1-doc').simplecombobox("getValue");
							var doc2 = $('#i-con2-doc').simplecombobox("getValue");
							var doc3 = $('#i-con3-doc').simplecombobox("getValue");
							
							var loc1 = $('#i-con1-loc').simplecombobox("getValue");
							var loc2 = $('#i-con2-loc').simplecombobox("getValue");
							var loc3 = $('#i-con3-loc').simplecombobox("getValue");
							 
							if ( (doc1=="") || (doc2=="") || (doc3=="") || (loc1=="") || (loc2=="") || (loc3=="") ) {
								$.messager.alert('��ʾ','������Һͻ���ҽ������Ϊ��...','info');
								return false;
							}
							var para = rowData.id + "^" + doc1 + "^" + loc1  + "^" + doc2 + "^" + loc2  + "^" + doc3 + "^" + loc3 + "^" + session['LOGON.USERID'];
							//alert(para);
							
							$.messager.confirm('��ʾ', '��ȷ��<span style="color:red; font-size:16px;margin:0px 2px;">�޸Ļ�����Ϣ</span>ô��', function(r){
								if (r){	
									var result = tkMakeServerCall("DHCAnt.KSS.FunctionExtend", "UpdateConsultInfo", para);
									if (result==0) {
										$('#i-con-win').window('close');
										$.messager.alert('��ʾ','�޸ĳɹ�...','info');
										return true;
									} else {
										$.messager.alert('��ʾ','�޸�ʧ��...','info');
										return false;
									}
									
								}
							});
							
						});
		
					};
					
					
				}
			});
		
	};
	//��չ
	$.parser.plugins.push("simplecombobox");
	$.fn.simplecombobox = function(options, param) {
		if (typeof options == "string") {
			return $.fn.combobox.apply(this, arguments);
		}
		options = options || {};
		var tempObj = {};
		tempObj.options = options;
		return this.each(function() {
			var jq = $(this),
				opts = $.extend({}, $.fn.combobox.parseOptions(this), tempObj.options),
				data = [];
			var exopts = $.extend(true, { 
				multiple:false,
				editable : true,
				mode: "local",
                filter: function(q, row){  
                    var opts = $(this).combobox('options');  
                    return row[opts.textField].indexOf(q) >= 0;  
                },
				valueField:'id',
				textField:'text',
				url:'dhcant.kss.main.request.csp?action=GetQueryData',
			}, opts);
			$.fn.combobox.call(jq, exopts);
		});
		
	};
	window.AuditInfo = createAuditPanel;
	window.GetKSSOrderStopInfo = function(){};
	//����ҩ�������б�
	window.BtnShowViewAnditAnti = function () {
		var userid=session['LOGON.USERID'];
		var AuditAnti = new AuditInfo(GlobalObj.EpisodeID, userid);
	};
	window.AntLoad = function () {
		var AUTOOPEN = tkMakeServerCall("DHCAnt.Base.MainConfigExcute", "GetValueByMCGCode", "AUTOOPEN",session['LOGON.HOSPID']);
		if ( AUTOOPEN == 1) {
			var EpisodeID=GlobalObj.EpisodeID
			var userid=session['LOGON.USERID'];
			var IsDoc=tkMakeServerCall("DHCAnt.KSS.MainBusiness","GetCareType",userid)
			if(IsDoc==1){
				var ordInfo=tkMakeServerCall("DHCAnt.KSS.MainBusiness","GetAuditApplyInfo",EpisodeID,userid)
				if (ordInfo!=""){
					var winAuditInfo = new AuditInfo(EpisodeID, userid);
				}
			}
		}
	};
	window.SetAntInfo = function (AntInfoStr,Row) {
		if(AntInfoStr==""){
            var Row=GetPreRowId();
            DeleteRow(Row,"Group");
        }else{
			var AntInfoArr=AntInfoStr.split("!")
			var UserReasonID=AntInfoArr[0]
			var AntibApplyRowid=AntInfoArr[1]
			var specailAction = AntInfoArr[2]
			SetCellData(Row,"OrderAntibApplyRowid",AntibApplyRowid);
			SetCellData(Row,"UserReasonId",UserReasonID);    //ʹ��Ŀ�� 
			/*if((OrderInsId!="")&&(OrderInsDesc!="")){
				SetCellData(Row,"OrderInstrRowid",OrderInsId);
				SetCellData(Row,"OrderInstr",OrderInsDesc);
			}*/
			if(specailAction=="isEmergency"){
				SetColumnList(Row,"OrderPrior",GlobalObj.OrderPriorStr);
				if (GetEditStatus(Row) == true) {
					SetCellData(Row,"OrderPrior",GlobalObj.ShortOrderPriorRowid);
				}else{
					SetCellData(Row,"OrderPrior","��ʱҽ��");
				}
				//SetCellData(Row,"OrderPrior",GlobalObj.ShortOrderPriorRowid);
				SetCellData(Row,"OrderPriorRowid",GlobalObj.ShortOrderPriorRowid);
				SetCellData(Row,"OrderPriorStr",GlobalObj.ShortOrderPriorRowid+":"+"��ʱҽ��");
				OrderPriorchangeCommon(Row,"",GlobalObj.ShortOrderPriorRowid);
				var obj={OrderPrior:false,OrderFreq:false};
				ChangeRowStyle(Row,obj)
				SetCellData(Row,"OrderFreqRowid",GlobalObj.ONCEFreqRowid);
				SetCellData(Row,"OrderFreq",GlobalObj.ONCEFreq);
				SetCellData(Row,"SpecialAction","isEmergency||");
				SetOrderFirstDayTimes(Row);
			}
		}   
	};
	//����ҩ�����
	window.CheckDoctorTypePoison_7 = function (PoisonRowId, ArcimRowid, Row, OrderPoisonCode, callBackFun) {
		var PoisonObject = $cm({
			ClassName: "DHCAnt.KSS.Config.PoisonSet",
			MethodName: "ValidatePhpoNew",
			InHosp: session['LOGON.HOSPID'],
			InPoisonRowId:PoisonRowId,
			InAdmType: GlobalObj.PAAdmType,
			ArcimRowid: ArcimRowid 
		},false)
		if (PoisonObject.code==0) {
			callBackFun(true);
			return true;   
		} else if (PoisonObject.code<0) {
			$.messager.alert("��ʾ",PoisonObject.msg,"info",function(){
				DeleteRow(Row,"Group");
				callBackFun(false);
			});	
			return false;	
		} else {
			if (PoisonObject.OrderPoisonCode!="") {
				OrderPoisonCode = PoisonObject.OrderPoisonCode;
				PoisonRowId = PoisonObject.PoisonRowId;
			}
		}
		var DoctorTypePoisonStr = GlobalObj.DoctorTypePoisonStr;
		var PAADMRowid = GlobalObj.EpisodeID;
		var EmerFlag = DHCANT.getEmergencyFlag();
		var ReasonFlag = 0,curProcess="";
		var AW = "",AH = "",ASH = "",ACH = "",AURL = "",AWAIM = "";
		var OrderPoisonDesc = "",ShowTabStr = "";
		var DoctorTypePoisonArr=new  Array();
		var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
		
		new Promise(function(resolve,rejected){
			//�ж��Ƿ���ҪƤ��,��ʱ������׼��QP
			var needPS = 0; //tkMakeServerCall("DHCAnt.KSS.FunctionExtend", "IsPSDrug", ArcimRowid);
			if (needPS == 1) {
				$.messager.confirm('ȷ�϶Ի���', '�Ƿ���ҪƤ�ԣ�', function(r){
					if (r) {
						SetColumnList(Row,"OrderPrior",GlobalObj.OrderPriorStr);
						SetCellData(Row,"OrderPrior",GlobalObj.ShortOrderPriorRowid);
						SetCellData(Row,"OrderPriorRowid",GlobalObj.ShortOrderPriorRowid);
						SetCellData(Row,"OrderPriorStr",GlobalObj.ShortOrderPriorRowid+":"+"��ʱҽ��");
						OrderPriorchangeCommon(Row,"",GlobalObj.ShortOrderPriorRowid);
						var OrderActionRowid="";
						var PSArr = GlobalObj.OrderActionJSON.split(";");
						for(var i=0; i<PSArr.length; i++) {
							var psText = PSArr[i].split(":")[1];
							if(psText == "ԭҺ"){
								OrderActionRowid = PSArr[i].split(":")[0];
								break;
							}
						}
						//�����÷�ΪƤ��
						//SetCellData(Row,"OrderInstrRowid",'54');
						//SetCellData(Row,"OrderInstr",'Ƥ��');  
						SetCellData(Row, "OrderSkinTest", true);
						SetCellData(Row, "OrderActionRowid", OrderActionRowid);
						SetCellData(Row, "OrderAction", OrderActionRowid);	//������ĸ�����
						var obj = {OrderPrior:false,OrderSkinTest:false,OrderAction: false};
						ChangeRowStyle(Row,obj)
						callBackFun(true);
					}else{
						resolve();
					}
				})
			} else {
				if (GlobalObj.SkinTestInstr != "") {
					var InstrRowId = GetCellData(Row, "OrderInstrRowid");
					var Instr = "^" + InstrRowId + "^";
					if ((GlobalObj.SkinTestInstr.indexOf(Instr) != "-1")&&(GlobalObj.SkinTestNeedApply=="0")) {
						//Ƥ���÷�
						callBackFun(true);
					} else {
						resolve();
					}
				} else {
					resolve();
				}
			}
		}).then(function(){
			return new Promise(function(resolve,rejected){
				curProcess = tkMakeServerCall("DHCAnt.KSS.Common.Method", "GetUserIsAuth", session['LOGON.USERID'], OrderPoisonCode, 1,GlobalObj.PAAdmType);
				if (CheckAuditItem()) {
					callBackFun(true);
					return true;
				}
				var Checkret=0 //CheckSuscept(PAADMRowid,ArcimRowid)
				if (Checkret==1){
					$.messager.confirm('ȷ�϶Ի���', '���˶��ڸ�ҩƷ����ҩ��Ӧ���Ƿ�Ի��߼�������ҩƷ?', function(r){
						if (!r) {
							DeleteRow(Row,"Group");
							callBackFun(false);
						}else{
							resolve();
						}
					})
				}else{
					resolve();
				}
			})
		}).then(function(){
			return new Promise(function(resolve,rejected){
				var applyPara = tkMakeServerCall("DHCAnt.KSS.FunctionExtend", "GetApplyPara");
				var applyParaArr = applyPara.split("^");
					AW = applyParaArr[0],
					AH = applyParaArr[1],
					ASH = applyParaArr[2],
					ACH = applyParaArr[3],
					AURL = applyParaArr[4],
					AWAIM = applyParaArr[5];
				DoctorTypePoisonArr = DoctorTypePoisonStr.split("^");
				if (GlobalObj.GetPHCPoisonByCode != ""){
					OrderPoisonDesc = cspRunServerMethod(GlobalObj.GetPHCPoisonByCode,OrderPoisonCode);
				};
				var dialogFlag = tkMakeServerCall("DHCAnt.KSS.FunctionExtend", "ChkSameAntForOnce", PAADMRowid, ArcimRowid)
				if (dialogFlag == "-2") {
					$.messager.alert("��ʾ","�������Խ���Ŀ���ҩ�����ˣ�","info",function(){
						DeleteRow(Row,"Group");
						callBackFun(false);
					});	
				}else if(dialogFlag > 0){
					SetCellData(Row,"UserReasonId",dialogFlag);    //ʹ��Ŀ�� 
					callBackFun(true);
				}else{
					resolve();
				}
			})
		}).then(function(){
			return new Promise(function(resolve,rejected){
				//TWOAPP
				var fillInfo = tkMakeServerCall("DHCAnt.KSS.FunctionExtend", "TwoApplyControl", PAADMRowid, ArcimRowid, session['LOGON.USERID'], GlobalObj.PAAdmType,session['LOGON.HOSPID'])
				var fillArr=fillInfo.split("^");
				var fillCode=fillArr[0],
					fillDaupid=fillArr[1],
					fillMsg=fillArr[2],
					fillEM=fillArr[3];
					
				if ((fillCode !="0")&&(fillCode !="1")) {
					if (fillCode == "-1") {
						$.messager.alert("��ʾ",fillMsg,"info",function(){
							DeleteRow(Row,"Group");
							callBackFun(false);
						});	
					} else if (fillCode == "2") {
						if (fillEM==0) {
							$.messager.alert("��ʾ","��Խ�������ѳ�����������Խ����","info",function(){
								DeleteRow(Row,"Group");
								callBackFun(false);
							});	
							
						} else {
							SetCellData(Row,"UserReasonId",fillDaupid);  
							SetColumnList(Row,"OrderPrior",GlobalObj.OrderPriorStr);
							SetCellData(Row,"OrderPrior",GlobalObj.ShortOrderPriorRowid);
							SetCellData(Row,"OrderPriorRowid",GlobalObj.ShortOrderPriorRowid);
							SetCellData(Row,"OrderPriorStr",GlobalObj.ShortOrderPriorRowid+":"+"��ʱҽ��");
							OrderPriorchangeCommon(Row,"",GlobalObj.ShortOrderPriorRowid);
							var obj={OrderPrior:false,OrderFreq:false};
							ChangeRowStyle(Row,obj)
							SetCellData(Row,"OrderFreqRowid",GlobalObj.ONCEFreqRowid);
							SetCellData(Row,"OrderFreq",GlobalObj.ONCEFreq);
							SetCellData(Row,"SpecialAction","isEmergency||");
							callBackFun(true);
						}
					} else if (fillCode == "3") {
						SetCellData(Row,"UserReasonId",fillDaupid);   
						callBackFun(true); 
					} else if (fillCode == "4") {
						$.messager.confirm('ȷ��','��ҩƷ�ѷ��͹����룬���������ˣ�����ֻ��Խ��ʹ�ã��Ƿ������',function(r){  
							if (r){
								if (fillEM==0) {
									$.messager.alert("��ʾ","��Խ�������ѳ�����������Խ����","info",function(){
										DeleteRow(Row,"Group");
										callBackFun(false);
									});	
								} else {
									SetCellData(Row,"UserReasonId",fillDaupid);   
									SetColumnList(Row,"OrderPrior",GlobalObj.OrderPriorStr);
									SetCellData(Row,"OrderPrior",GlobalObj.ShortOrderPriorRowid);
									SetCellData(Row,"OrderPriorRowid",GlobalObj.ShortOrderPriorRowid);
									SetCellData(Row,"OrderPriorStr",GlobalObj.ShortOrderPriorRowid+":"+"��ʱҽ��");
									OrderPriorchangeCommon(Row,"",GlobalObj.ShortOrderPriorRowid);
									var obj={OrderPrior:false,OrderFreq:false};
									ChangeRowStyle(Row,obj)
									SetCellData(Row,"OrderFreqRowid",GlobalObj.ONCEFreqRowid);
									SetCellData(Row,"OrderFreq",GlobalObj.ONCEFreq);
									SetCellData(Row,"SpecialAction","isEmergency||");
									callBackFun(true);	
								}
							} else {
								DeleteRow(Row,"Group");
								callBackFun(false);
							}
						});  
					} else {
						resolve();
					}
				} else {
					resolve();
				}
			})
		}).then(function(){
			return new Promise(function(resolve,rejected){
				(function(callBackExecFun){
					function loop(j){
						new Promise(function(resolve,rejected){
							var TypePoisonRowId = mPiece(DoctorTypePoisonArr[j],String.fromCharCode(1),0);
							var TypeControl = mPiece(DoctorTypePoisonArr[j],String.fromCharCode(1),1);
							if (PoisonRowId == TypePoisonRowId) {
								ReasonFlag=1
								if (TypeControl == 'F'){
									$.messager.alert("��ʾ","��ҩƷ����"+OrderPoisonDesc+"��"+t['PoisonClassIsFobidden'],"info",function(){
										DeleteRow(Row,"Group");
										resolve(false);
									});
								}else if(TypeControl == 'A'){
									$.messager.confirm('ȷ�϶Ի���', "��ҩƷ����"+OrderPoisonDesc+"��Ϊ����ҩƷ��ע�⣡", function(r){	//t['PoisonClassNeedConfirm']
										if (!r) {
										   DeleteRow(Row,"Group");
									    }
										resolve(r);
									})
								}else if(TypeControl == 'P'){
									if (OrderPoisonCode.indexOf("KSS")<0) {
										resolve(true);
									}
									if(curProcess.indexOf("H")>=0){ 
										AH = ACH;
										ShowTabStr="Apply,Consult"
										SetCellData(Row,"ShowTabStr",ShowTabStr);
									}else{
										AH = ASH;
										ShowTabStr="Apply";
										SetCellData(Row,"ShowTabStr",ShowTabStr);
									}
									var IsCallBacked=false;
									var antMainUrl = AURL + "?ShowTabStr=" + ShowTabStr + "&EpisodeID=" + PAADMRowid + "&ArcimRowid=" + ArcimRowid + "&OrderPoisonCode=" + OrderPoisonCode + "&PAAdmType=" + GlobalObj.PAAdmType + "&EmerFlag=" + EmerFlag + "&OrderPriorRowid=" + OrderPriorRowid;
									websys_showModal({
										url:antMainUrl,
										title:'����ҩ������',
										iconCls:'icon-w-predrug',
										width:AW,height:AH,
										CallBackFunc:function(result){
											IsCallBacked=true;
											websys_showModal("close");
											if (result!=""){
												SetAntInfo(result,Row);
												resolve(true);
											}else{
												DeleteRow(Row,"Group");
												callBackFun(false);
											}
										},
										onClose:function(){
											if (!IsCallBacked) {
												DeleteRow(Row,"Group");
												callBackFun(false);
											}
										}
									});
								}else if (TypeControl == 'E') {
									if (OrderPoisonCode.indexOf("KSS")<0) {
										resolve(true);
									}
									var result = tkMakeServerCall("DHCAnt.KSS.FunctionExtend","ChkEmergencyType", PAADMRowid, ArcimRowid,"",session['LOGON.HOSPID']);
									if ((result == "1")||(EmerFlag == 1)) {
										$.messager.alert('��ʾ','Խ��ʹ��δ��ˣ������ٴ�Խ��!',"info",function(){
											DeleteRow(Row,"Group");
											resolve(false);
										});
										return false;
									};
									
									var res = tkMakeServerCall("DHCAnt.KSS.FunctionExtend","EMNumsControl", PAADMRowid, ArcimRowid, session['LOGON.USERID'],session['LOGON.HOSPID']);
									if (res == 0) {
										$.messager.alert("��ʾ","��Խ�������ѳ�����������Խ����","info",function(){
											DeleteRow(Row,"Group");
											callBackFun(false);
										});
									
									};
									
									$.messager.alert('��ʾ',"ֻ���ڽ��������ʹ��!","info",function(){
										if (curProcess.indexOf("H")>=0 ){
											AH = ACH;
											ShowTabStr = "Apply,Consult,Emergency"
											SetCellData(Row, "ShowTabStr", ShowTabStr);
										} else {
											AH = ASH;
											ShowTabStr = "Apply,Emergency";
											SetCellData(Row, "ShowTabStr", ShowTabStr);
										}
										var IsCallBacked=false;
										var antMainUrl = AURL + "?ShowTabStr=" + ShowTabStr + "&EpisodeID=" + PAADMRowid + "&ArcimRowid=" + ArcimRowid + "&OrderPoisonCode=" + OrderPoisonCode + "&PAAdmType=" + GlobalObj.PAAdmType + "&EmerFlag=" + EmerFlag + "&OrderPriorRowid=" + OrderPriorRowid;
										websys_showModal({
											url:antMainUrl,
											title:'����ҩ������',
											iconCls:'icon-w-predrug',
											width:AW,height:AH,
											CallBackFunc:function(result){
												IsCallBacked=true;
												websys_showModal("close");
												if (result!=""){
													SetAntInfo(result, Row)
													resolve(true);
												}else{
													DeleteRow(Row,"Group");
													callBackFun(false);
												}
											},
											onClose:function(){
												if (!IsCallBacked) {
													DeleteRow(Row,"Group");
													callBackFun(false);
												}
											}
										});
									});
								}else{
									resolve(true);
								}
							}else{
								resolve(true);
							}
						}).then(function(rtn){
							if (!rtn) {
								callBackFun(false);
							}else{
								j++;
								if ( j < DoctorTypePoisonArr.length ) {
									 loop(j);
								}else{
									callBackExecFun();
								}
							}
						})
					}
					loop(0);
				})(resolve);
			})
		}).then(function(){
			return new Promise(function(resolve,rejected){
				if(DoctorTypePoisonStr == ""){
					$.messager.alert("��ʾ","��ҩƷ����"+OrderPoisonDesc+"(���Ʒ���),"+t['PoisonClassIsFobidden'],"info",function(){
						DeleteRow(Row,"Group");
						callBackFun(false);
					});
				}else{
					resolve();
				}
			})
		}).then(function(){
			return new Promise(function(resolve,rejected){
				if((ShowTabStr=="")&&(OrderPoisonCode.indexOf("KSS")>=0)&&(ReasonFlag==1)){
					ShowTabStr="UserReason"
					SetCellData(Row,"ShowTabStr",ShowTabStr);
					var IsCallBacked=false;
					var antMainUrl = AURL + "?ShowTabStr=" + ShowTabStr + "&EpisodeID=" + PAADMRowid + "&ArcimRowid=" + ArcimRowid + "&OrderPoisonCode=" + OrderPoisonCode + "&PAAdmType=" + GlobalObj.PAAdmType + "&EmerFlag=" + EmerFlag + "&OrderPriorRowid=" + OrderPriorRowid;
					websys_showModal({
						url:antMainUrl,
						title:'����ҩ������',
						iconCls:'icon-w-predrug',
						width:AWAIM,height:AH,
						CallBackFunc:function(result){
							IsCallBacked=true;
							websys_showModal("close");
							if ((result!="")&&(result!=undefined)){
								SetAntInfo(result, Row)
								resolve(true);
							}else{
								DeleteRow(Row,"Group");
								callBackFun(false);
							}
						},
						onClose:function(){
							if (!IsCallBacked) {
								DeleteRow(Row,"Group");
								callBackFun(false);
							}
						}
					});
				}else{
					resolve();
				}
			})
		}).then(function(){
			if(ReasonFlag == 0){
				$.messager.alert("��ʾ","��ҩƷ����"+OrderPoisonDesc+"(���Ʒ���),"+t['PoisonClassIsFobidden'],"info",function(){
						DeleteRow(Row,"Group");
						callBackFun(false);
				});
			}else{
				callBackFun(true);
			}
		})
	};
	//������ҩ����
	window.CheckAntCombined = function (rowids,callBackFun) {
		//debugger;
		var Paadmid = GlobalObj.EpisodeID;
        var ParrAllInfo = "";
        for (var i=0; i<rowids.length; i++) {
            var KssOrderPoisonCode=GetCellData(rowids[i],"OrderPoisonCode");
            var KssUserReasonId=GetCellData(rowids[i],"UserReasonId"); //ʹ��Ŀ�ı�id
            var KssOrderPriorRowid=GetCellData(rowids[i],"OrderPriorRowid"); //ҽ������id
            var OrderPriorRemarksRowId=GetCellData(rowids[i],"OrderPriorRemarksRowId");
			var OrderInstrRowID=GetCellData(rowids[i],"OrderInstrRowid"); //�÷�
            if((KssUserReasonId!="")&&(KssOrderPoisonCode.indexOf("KSS")>=0)&&(KssOrderPriorRowid!="")){
                if(ParrAllInfo==""){
                    ParrAllInfo=KssUserReasonId+"@"+KssOrderPriorRowid+"@"+OrderPriorRemarksRowId+"@"+OrderInstrRowID;
                }else{
                    ParrAllInfo=ParrAllInfo+"^"+KssUserReasonId+"@"+KssOrderPriorRowid+"@"+OrderPriorRemarksRowId+"@"+OrderInstrRowID;
                }
            }
        };
        if ( ParrAllInfo != "") {
	        //alert(1)
	         ParrAllInfo = tkMakeServerCall("DHCAnt.KSS.Combined","FilterOMSTOrder",ParrAllInfo,session['LOGON.HOSPID']);
             //alert(2)
             var CURetArr=tkMakeServerCall("DHCAnt.KSS.Combined","GetCombinedNumFormDAUP",Paadmid,ParrAllInfo,session['LOGON.HOSPID']);
            // alert(3)
             var CHret=tkMakeServerCall("DHCAnt.KSS.Combined","IfChangeFormDAUP",Paadmid,ParrAllInfo,session['LOGON.HOSPID']);
             //alert(4)
             var CUret=CURetArr.split("|")[0];
             var SameArcimName=CURetArr.split("|")[1];
	    }
        new Promise(function(resolve,rejected){
	        if ((ParrAllInfo != "")&&(CUret==-1)) {
	             $.messager.alert("��ʾ","������ͬ�Ŀ����س���ҽ��: "+SameArcimName,"info",function(){
		             resolve(false);
		         });
		    }else{
			    resolve(true);
			}
	    }).then(function(rtn){
		    return new Promise(function(resolve,rejected){
			    if (!rtn) {
				    resolve(rtn);
				}else{
					if (ParrAllInfo != ""){
						//alert(11)
						var combinedPara = tkMakeServerCall("DHCAnt.KSS.FunctionExtend","GetCombinedPara");
						//alert(2)
			            var combinedArr = combinedPara.split("^");
			            var CW = combinedArr[0],CH = combinedArr[1],CURL = combinedArr[2];
			            if((CUret>1)||(CHret==1)){
				            var IsCallBacked=false;
				            var CombinedUseUrl= CURL + "?EpisodeID="+Paadmid+"&ParrAllInfo="+ParrAllInfo;
				            websys_showModal({
								url:CombinedUseUrl,
								title:'����ҩ��������ҩ',
								width:CW,height:CH,
								iconCls:'icon-w-predrug',
								CallBackFunc:function(result){
									IsCallBacked=true;
									websys_showModal("close");
									if((result=="")||(typeof(result)=="undefined")){
										resolve(false);
									}else{
										resolve(true);
									}
								},
								onClose:function(){
									if (!IsCallBacked) resolve(false);
								}
							});
				        }else{
					        //�״���ҩ
			                var FirstKssret=tkMakeServerCall("DHCAnt.KSS.Combined","SaveCombinedInfo",Paadmid,ParrAllInfo,"","",session['LOGON.HOSPID']);
			                resolve(true);
					    }
				    }else{
					    resolve(true);
					}
				}
			})
		}).then(function(rtn){
		    callBackFun(rtn);
		})
        /*if ( ParrAllInfo != "") {
            ParrAllInfo = tkMakeServerCall("DHCAnt.KSS.Combined","FilterOMSTOrder",ParrAllInfo);
            var CURetArr=tkMakeServerCall("DHCAnt.KSS.Combined","GetCombinedNumFormDAUP",Paadmid,ParrAllInfo);
            var CHret=tkMakeServerCall("DHCAnt.KSS.Combined","IfChangeFormDAUP",Paadmid,ParrAllInfo);
            var CUret=CURetArr.split("|")[0];
            var SameArcimName=CURetArr.split("|")[1];
            if(CUret==-1){
                alert("������ͬ�Ŀ����س���ҽ��:"+SameArcimName);
                return false;
            };
            var combinedPara = tkMakeServerCall("DHCAnt.KSS.FunctionExtend","GetCombinedPara");
            var combinedArr = combinedPara.split("^");
            var CW = combinedArr[0],CH = combinedArr[1],CURL = combinedArr[2];
            if((CUret>1)||(CHret==1)){
                var CombinedUseUrl= CURL + "?EpisodeID="+Paadmid+"&ParrAllInfo="+ParrAllInfo;
                var ret=window.showModalDialog(CombinedUseUrl,"","dialogwidth:" + CW + "px;dialogheight:" + CH + "px;status:no;center:1;resizable:yes");
                if((ret=="")||(typeof(ret)=="undefined")){
                    return false;
                }
            }else{
                //�״���ҩ
                var FirstKssret=tkMakeServerCall("DHCAnt.KSS.Combined","SaveCombinedInfo",Paadmid,ParrAllInfo,"","");
            }
        }
        return true;*/
	};
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
			var result = tkMakeServerCall("DHCAnt.KSS.MainBusiness","ComSendEmergencyMsg",para,session['LOGON.HOSPID']);
			return result;
		},
		undoApply: function (aaid, status) {
			$.messager.confirm('��ʾ', '��ȷ��<span style="color:red; font-size:16px;margin:0px 2px;">��������</span>ô��', function(r){
				if (r){
					if (status != "A") {
						$.messager.alert('��ʾ','�ѱ��ϼ�ҽ����ˣ����ܳ���...','info');
						return false;
					};
					var result = tkMakeServerCall("DHCAnt.KSS.Extend.Undo", "UndoApply", aaid, session['LOGON.HOSPID']);
					if (result==1) {
						$('#i-apply-grid').datagrid("reload");
						$.messager.alert('��ʾ','�����ɹ�...','info');
						return false;
					} else {
						if (result=="-102" ) {
							$.messager.alert('��ʾ','���ﳷ��ʧ��...','info');
							return false;
						} else if (result=="-101" ) {
							$.messager.alert('��ʾ','״̬�޸�ʧ��...','info');
							return false;
						} else if (result=="-103" ) {
							$.messager.alert('��ʾ','������־ʧ��...','info');
							return false;
						} else {
							$.messager.alert('��ʾ','����ʧ��...','info');
							return false;
						}
					}
				}
			});
		},
		diagShow: function (id,title,W,H,content) {	//diagShow("cqmx-win",900,400)
			$Win = $("<div id='" + id + "' style='width:"+ W +"px;height:"+ H +"px;padding:10px;overflow:hidden;'></div>");
			//$Win = $("<div id='" + id + "' style='height:"+ H +"px;padding:10px;'></div>");
			$("#id").remove();
			$("body").prepend($Win);
			$content = $(content);
			$("#" + id).prepend($content);
			
			$('#' + id).window({
				iconCls:'icon-w-edit',
				title: title,
				modal: true,
				border:false,
				minimizable:false,
				collapsible:false,
				maximizable:false,
				onClose: function () {
					$("#" + id).remove();
				}
			});
		},
		saveCqmx: function(inArcim,AnditAARowidArr) {
			$("#CQMX-Save").click(function () {
				var SP = String.fromCharCode(1);
				var MainDiag = $("#CQMX-MainDiag").combogrid("getValue")||"";
				var Instruc = $("#CQMX-Instruc").combobox("getValue")||"";
				var IsConsult = $("#CQMX-IsConsult").combobox("getValue")||"";
				var IsEmergency = $("#CQMX-IsEmergency").combobox("getValue")||"";
				var IsLab = $("#CQMX-IsLab").combobox("getValue")||"";
				var Locid = session['LOGON.CTLOCID'];
				var Arcim = inArcim;
				var Patid = "";
				var PrescDoc = session['LOGON.USERID'];
				var IPNo = $("#CQMX-IPNo").val();
				var Admid = GlobalObj.EpisodeID;
				var inPara = MainDiag + SP + Instruc + SP + IsConsult + SP + IsEmergency + SP + IsLab + SP + Locid;
				inPara = inPara + SP + Arcim + SP + Patid + SP + PrescDoc + SP + IPNo + SP + Admid;
				
				if (( MainDiag=="")||(Instruc=="")||(IsConsult=="")||(IsEmergency=="")||(IsLab=="")) {
					$.messager.alert('��ʾ','����д�ñ����','warning');
					return false;
				}
				var CQMXid = $.cm({
					ClassName:"DHCAnt.KSS.Extend.CQMX",
					MethodName:"SaveCQMX",
					dataType:"text",
					inPara:inPara
				},false);
				
				if ( CQMXid <= 0) {
					$.messager.alert('��ʾ','̼��ùϩ�༰��ӻ��ر���ʧ��!','warning');
					return false;
				} 
				var ret=cspRunServerMethod(GlobalObj.AddAuditItemToListMethod,'AddCopyItemToList','',GlobalObj.EpisodeID,AnditAARowidArr,CQMXid);
				$('#i-apply-win').window('close');
				$('#cqmx-win').window('close');
				return true;	
			})
		},
		drawCqmx: function (arcimDesc) {
			$("#CQMX-Save").linkbutton();
			
			//��ֵ
			$("#CQMX-DrugName").val(arcimDesc);
			$m({
				ClassName:"DHCAnt.KSS.Extend.CQMX",
				MethodName:"GetBaseInfo",
				admid:GlobalObj.EpisodeID,
				locid:session['LOGON.CTLOCID']
			},function(responseData){
				var responseArr = responseData.split("^");
				$("#CQMX-PatName").val(responseArr[0]);
				$("#CQMX-LocName").val(responseArr[1]);
				$("#CQMX-PrescDate").val(responseArr[2]);
				$("#CQMX-IPNo").val(responseArr[3]);
				$("#CQMX-PrescDoc").val(session['LOGON.USERNAME']);
			});
			
			//�Ƿ��ͼ�
			$HUI.combobox("#CQMX-IsLab", {
				valueField:'id',
				required:true,
				textField:'text',
				data:[
					{id:'1',text:'��'},
					{id:'0',text:'��'}
				]
			});
			//�Ƿ����
			$HUI.combobox("#CQMX-IsConsult", {
				valueField:'id',
				required:true,
				textField:'text',
				data:[
					{id:'1',text:'��'},
					{id:'0',text:'��'}
				]
			});
			//�Ƿ����
			$HUI.combobox("#CQMX-IsEmergency", {
				valueField:'id',
				required:true,
				textField:'text',
				data:[
					{id:'1',text:'��'},
					{id:'0',text:'��'}
				]
			});
			
			//�÷�
			$HUI.combobox("#CQMX-Instruc", {
				url:$URL+"?ClassName=DHCAnt.KSS.Extend.CQMX&QueryName=QryUse&ResultSetType=array",
				valueField:'id',
				required:true,
				textField:'desc',
				blurValidValue:true
				
			});	
			
			//��Ҫ���
			$HUI.combogrid("#CQMX-MainDiag", {
				panelWidth:500,
				panelHeight:300,
				required:true,
				delay: 500,    
				mode: 'remote',    
				url:$URL+"?ClassName=DHCAnt.KSS.Extend.CQMX&QueryName=LookUpWithAlias",
				fitColumns: true,   
				striped: true,   
				editable:true,   
				pagination : true,//�Ƿ��ҳ   
				rownumbers:true,//���   
				collapsible:false,//�Ƿ���۵���   
				fit: true,//�Զ���С   
				pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
				pageList: [10],//��������ÿҳ��¼�������б�   
				method:'post', 
				idField: 'Rowid',    
				textField: 'desc',    
				columns: [[    
					{field:'desc',title:'����',width:400,sortable:true},
					{field:'code',title:'����',width:120,sortable:true},
					{field:'Rowid',title:'ID',width:120,sortable:true,hidden:false},
				]],
				onSelect: function (){
					var selected = $('#CQMX-MainDiag').combogrid('grid').datagrid('getSelected');  
					if (selected) { 
					  $('#CQMX-MainDiag').combogrid("options").value=selected.Rowid;
					}
				 },
				 onBeforeLoad:function(param){
					 var desc=param['q'];
					 param = $.extend(param,{desc:param["q"]});
				 }
			});
			
		}
	})
	
	
});
 
