/**
 * dhcant.kss.main.init.js - KJ Interface Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2016-08-11
 * 
 */
(function($){
	$.extend($.DHCAnt, {
		initKSSConfig: function (kssConfig) {
			if ((!kssConfig.DEFAULTCONDEP)||(!kssConfig.DEFAULTCONDOC)) {
				//
			}else {
				if ((kssConfig.DEFAULTCONDEP==0)||(kssConfig.DEFAULTCONDOC==0)){
					kssConfig.DEFAULTCONDEP = undefined;
				}
			}
			if (!kssConfig.CONDEPNUM) {
				kssConfig.CONDEPNUM = 1;
			};
			if ($.trim(kssConfig.SMANYCONSULT) != "1") {
				kssConfig.CONDEPNUM = 1;
			};
		},
		initConfigLayout: function (kssConfig) {
			//��������ĸ߶�,DHCANT-V4.1.2����������
			var consultPanelHeight = 118,
				applyPanelHeight = 85,
				kss3PanelHieght = 85,
				drugTimePanelHeight = 120;
			var dynamicHeight = 215 + Math.floor(drugTimePanelHeight/2);	//Condition1 �������ö�����ʱ 
			var dynamicHeight2 = 210 + Math.floor((drugTimePanelHeight - kss3PanelHieght)/2);	//Condition2 �ؿ�ҩָ֤�����ã����������� 
			var dynamicHeight3 = 217;			//Condition3 Ԥ����ҩָ֤�����ã�����������
			var dynamicHeight4 = "��������";	//Condition4 Ԥ����ҩָ֤�����ã��ؿ�ҩָ֤�����ã���������
			var browserType = ANT.getBrowserType();
			//Condition1
			if (($.trim(kssConfig.SUSEDRUGTIME) == "1")&&($.trim(kssConfig.SKSS3IND)=="1")&&(PARAMObj.ShowTabStr.indexOf("Consult")>=0)) {
				$('#i-useaim-sensitive-panel').panel('resize',{
					height: dynamicHeight+8
				});
				$('#i-useaim-operlist-panel').panel('resize',{
					height: dynamicHeight+7
				});
				consultPanelHeight = 160;
			};
			//Condition2
			if (($.trim(kssConfig.SUSEDRUGTIME) == "1")&&($.trim(kssConfig.SKSS3IND)!="1")&&(PARAMObj.ShowTabStr.indexOf("Consult")>=0)) {
				$('#i-useaim-sensitive-panel').panel('resize',{
					height: dynamicHeight2 + 3
				});
				$('#i-useaim-operlist-panel').panel('resize',{
					height: dynamicHeight2 + 3
				});
				consultPanelHeight = 160;
			};
			//Condition3
			if (($.trim(kssConfig.SUSEDRUGTIME) != "1")&&($.trim(kssConfig.SKSS3IND)=="1")&&(PARAMObj.ShowTabStr.indexOf("Consult")>=0)) {
				$('#i-useaim-sensitive-panel').panel('resize',{
					height: dynamicHeight3+1
				});
				$('#i-useaim-operlist-panel').panel('resize',{
					height: dynamicHeight3
				});
				consultPanelHeight = 160;
			};
			//Condition4
			if (($.trim(kssConfig.SUSEDRUGTIME) != "1")&&($.trim(kssConfig.SKSS3IND)!="1")&&(PARAMObj.ShowTabStr.indexOf("Consult")>=0)) {
				consultPanelHeight = consultPanelHeight + applyPanelHeight + 1;
			};
			
			if (PARAMObj.ShowTabStr.indexOf("Apply")>=0){	//APPLY
				$("#i-apply").removeClass("c-item-hidden");
				
				$("#i-apply-panel").simplepanel({
					headerCls:'panel-header-gray',
					title:"������Ϣ",
					collapsible:false,
					height:applyPanelHeight,
					maximizable:false,
					iconCls:'icon-apply'
				});
				/*
				if ((PARAMObj.EmerFlag == 1)&&(kssConfig.EOE == 1)) {
					$("#i-apply-panel-isem").attr("disabled", true);
				} else {
					if (PARAMObj.ShowTabStr.indexOf("Emergency") >= 0) {
						//$("#i-apply-panel-isem").attr("checked", true).attr("disabled", true);
						//$("#i-apply-panel-isem").iCheck('check').attr("disabled", true);
						$("#i-apply-panel-isem").checkbox("disable");
						$("#i-apply-panel-isem").checkbox("check");
						$("#i-apply-panel-emreason").removeAttr("disabled");
					};
				};*/
			};
			//CONSULT DEP DISPLAY
			if ((PARAMObj.ShowTabStr.indexOf("Consult")>=0)&&(kssConfig.processInfo.indexOf("H")>=0)){		//CONSULT
				if ((!kssConfig.DEFAULTCONDEP)||(!kssConfig.DEFAULTCONDOC)) {		//IS DEFAULTDEP
					$("#i-consulation").removeClass("c-item-hidden");
					$("#i-consulation-panel").simplepanel({
						title:"������Ϣ",
						height:consultPanelHeight,
						maximizable:false,
						collapsible:false,
						headerCls:'panel-header-gray',
						iconCls:'icon-consult'
					});
					//INIT CONSULT DEP1
					$('#i-consulation-panel-row1-conloc').simplecombobox({
						onBeforeLoad: function(param){
							param.ClassName="DHCAnt.KSS.MainInterface";
							param.QueryName="QryConsultationLoc";
							param.ModuleName="combobox";
							param.Arg1=session['LOGON.CTLOCID'];
							param.ArgCnt=1;
						},
						onSelect:function(record) {
							$('#i-consulation-panel-row1-condoc').simplecombobox('clear');
							$('#i-consulation-panel-row1-condoc').simplecombobox({
								onBeforeLoad: function(param){
									param.ClassName="DHCAnt.KSS.MainInterface";
									param.QueryName="QryConsultationDoc";
									param.ModuleName="combobox";
									param.Arg1=record.id;
									param.ArgCnt=1;
								},
								onSelect: function(r){
									var	doc1 = r.id,
										loc1 = record.id,
										doc2 = "",
										loc2 = "",
										doc3 = "",
										loc3 = "";
										if (kssConfig.curUserCtcareId == r.id ) {
											$.messager.alert('��ʾ','����ҽʦ����ѡ�����뱾��!','info');
											$(this).simplecombobox('clear');
											return false;
										};
										if ($.trim(kssConfig.CONDEPNUM) == "3") {
											doc3 = $('#i-consulation-panel-row3-condoc').simplecombobox('getValue')||"";
											loc3 = $('#i-consulation-panel-row3-conloc').simplecombobox('getValue')||"";
											doc2 = $('#i-consulation-panel-row2-condoc').simplecombobox('getValue')||"";
											loc2 = $('#i-consulation-panel-row2-conloc').simplecombobox('getValue')||"";
										};
										if ($.trim(kssConfig.CONDEPNUM) == "2") {
											doc2 = $('#i-consulation-panel-row2-condoc').simplecombobox('getValue')||"";
											loc2 = $('#i-consulation-panel-row2-conloc').simplecombobox('getValue')||"";
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
							//ANT.DHC.setHCombo(browserType,"i-consulation-panel-row1-condoc");
						}
						
					});
					$('#i-consulation-panel-row1-condoc').simplecombobox({
						onBeforeLoad: function(param){
							param.ClassName="DHCAnt.KSS.MainInterface";
							param.QueryName="QryConsultationDoc";
							param.ModuleName="combobox";
							param.Arg1="";
							param.ArgCnt=1;
						}
					});
					if ($.trim(kssConfig.SMANYCONSULT) == "1") {
						switch ($.trim(kssConfig.CONDEPNUM)){
							case "3":
								$("#i-consulation-panel-row3").removeClass("c-item-hidden");
								$('#i-consulation-panel-row3-conloc').simplecombobox({
									onBeforeLoad: function(param){
										param.ClassName="DHCAnt.KSS.MainInterface";
										param.QueryName="QryConsultationLoc";
										param.ModuleName="combobox";
										param.Arg1=session['LOGON.CTLOCID'];
										param.ArgCnt=1;
									},
									onSelect:function(record) {
										$('#i-consulation-panel-row3-condoc').simplecombobox('clear');
										$('#i-consulation-panel-row3-condoc').simplecombobox({
											onBeforeLoad: function(param){
												param.ClassName="DHCAnt.KSS.MainInterface";
												param.QueryName="QryConsultationDoc";
												param.ModuleName="combobox";
												param.Arg1=record.id;
												param.ArgCnt=1;
											},
											onSelect: function(r){
												var doc1 = $('#i-consulation-panel-row1-condoc').simplecombobox('getValue')||"",
													loc1 = $('#i-consulation-panel-row1-conloc').simplecombobox('getValue')||"",
													doc2 = $('#i-consulation-panel-row2-condoc').simplecombobox('getValue')||"",
													loc2 = $('#i-consulation-panel-row2-conloc').simplecombobox('getValue')||"",
													doc3 = r.id,
													loc3 = record.id;
												if (kssConfig.curUserCtcareId == r.id ) {
													$.messager.alert('��ʾ','����ҽʦ����ѡ�����뱾��!','info');
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
										//ANT.DHC.setHCombo(browserType,"i-consulation-panel-row3-condoc");
									}
								});
								$('#i-consulation-panel-row3-condoc').simplecombobox({
									onBeforeLoad: function(param){
										param.ClassName="DHCAnt.KSS.MainInterface";
										param.QueryName="QryConsultationDoc";
										param.ModuleName="combobox";
										param.Arg1="";
										param.ArgCnt=1;
									}
								})
								//break;
							case "2":
								$("#i-consulation-panel-row2").removeClass("c-item-hidden");
								$('#i-consulation-panel-row2-conloc').simplecombobox({
									onBeforeLoad: function(param){
										param.ClassName="DHCAnt.KSS.MainInterface";
										param.QueryName="QryConsultationLoc";
										param.ModuleName="combobox";
										param.Arg1=session['LOGON.CTLOCID'];
										param.ArgCnt=1;
									},
									onSelect:function(record) {
										$('#i-consulation-panel-row2-condoc').simplecombobox('clear');
										$('#i-consulation-panel-row2-condoc').simplecombobox({
											onBeforeLoad: function(param){
												param.ClassName="DHCAnt.KSS.MainInterface";
												param.QueryName="QryConsultationDoc";
												param.ModuleName="combobox";
												param.Arg1=record.id;
												param.ArgCnt=1;
											},
											onSelect: function(r){
												var doc1 = $('#i-consulation-panel-row1-condoc').simplecombobox('getValue')||"",
													loc1 = $('#i-consulation-panel-row1-conloc').simplecombobox('getValue')||"",
													doc2 = r.id,
													loc2 = record.id,
													doc3 = "",
													loc3 = "";
													if (kssConfig.curUserCtcareId == r.id ) {
														$.messager.alert('��ʾ','����ҽʦ����ѡ�����뱾��!','info');
														$(this).simplecombobox('clear');
														return false;
													};
													if ($.trim(kssConfig.CONDEPNUM) == "3") {
														doc3 = $('#i-consulation-panel-row3-condoc').simplecombobox('getValue')||"";
														loc3 = $('#i-consulation-panel-row3-conloc').simplecombobox('getValue')||"";
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
										//ANT.DHC.setHCombo(browserType,"i-consulation-panel-row2-condoc");
									}
								});
								$('#i-consulation-panel-row2-condoc').simplecombobox({
									onBeforeLoad: function(param){
										param.ClassName="DHCAnt.KSS.MainInterface";
										param.QueryName="QryConsultationDoc";
										param.ModuleName="combobox";
										param.Arg1="";
										param.ArgCnt=1;
									}
								})
							  break;
							default: //
						};
					};
				} else {
					//NO DISPLAY CONSULT DEP
				};
			}
			
			//�Ƿ������²���
			if ($.trim(kssConfig.SBJ) == "1") {
				$("#i-useaim-aetiology-panel-zbjlabel").removeClass("c-item-hidden");
				$("#i-useaim-aetiology-panel-zbjcontent").removeClass("c-item-hidden");
				$('#i-useaim-aetiology-panel-zbjinput').simplecombobox({
					onBeforeLoad: function(param){
						param.ClassName="DHCAnt.KSS.MainInterface";
						param.QueryName="QryZBacterium";
						param.ModuleName="combobox";
						param.ArgCnt=0;
					}
				})
			}
			
			//Is Start DrugTime Controller
			if (($.trim(kssConfig.SUSEDRUGTIME) == "1")&&(PARAMObj.PAAdmType=="I")) {
				$("#i-useaim-drugtime").removeClass("c-item-hidden");
				$("#i-useaim-drugtime-panel").simplepanel({
					title:"<span style='margin-left:8px;'>��ҩʱ��</span>",
					maximizable:false,
					collapsible:false,
					height:drugTimePanelHeight,
					headerCls:'panel-header-gray',
					iconCls:'icon-drugtime'
				});
			}
			
			//Is Start KSS3Indication Controller
			if (($.trim(kssConfig.SKSS3IND) == "1")&&(PARAMObj.OrderPoisonCode == "KSS3")) {
				
				$("#i-kss3Info").removeClass("c-item-hidden");
				$("#i-kss3Info-panel").simplepanel({
					headerCls:'panel-header-gray',
					title:"<span style='margin-left:8px;'>�ؿ�ҩ���</span>",
					maximizable:false,
					collapsible:false,
					height:kss3PanelHieght,
					iconCls:'icon-kss3drug'
				});
				//$("#i-useaim-panel-kss3indication-lab").removeClass("c-item-hidden");
				//$("#i-useaim-panel-kss3indication-div").removeClass("c-item-hidden");
				$('#i-useaim-panel-kss3indication').simplecombobox({
					onBeforeLoad: function(param){
						param.ClassName="DHCAnt.KSS.MainInterface";
						param.QueryName="QryKSS3Indication";
						param.ModuleName="combobox";
						param.ArgCnt=0;
					}
				});
			};
		},
		doBaseInfo: function (kssConfig) {
			var drugInfo = $.InvokeMethod("DHCAnt.KSS.MainInterface","GetDrugDetail",PARAMObj.ArcimRowid);
			var docInfo = $.InvokeMethod("DHCAnt.KSS.MainInterface","GetDocDetail",session['LOGON.USERID']);
			var processInfoStr = $.InvokeMethod("DHCAnt.KSS.Common.Method", "GetUserIsAuth", session['LOGON.USERID'], PARAMObj.OrderPoisonCode, 3, PARAMObj.PAAdmType);
			var curUserCtcareId = $.InvokeMethod("DHCAnt.KSS.Common.Method", "TransSSUserToCTCare", session['LOGON.USERID']);
			kssConfig.curUserCtcareId = curUserCtcareId;
			var processInfoArr = processInfoStr.split('!')
			kssConfig.processInfo = processInfoArr[0];
			kssConfig.processType = processInfoArr[1];
			kssConfig.lastAuditUser = processInfoArr[2];
			var drugPoisonDesc = "";
			var drugInfoObj = jQuery.parseJSON(drugInfo),docInfoObj=jQuery.parseJSON(docInfo);
			$("#i-baseinfo-drug-content-drugname").text(drugInfoObj.drugDesc);
			$("#i-baseinfo-drug-content-drugform").text(drugInfoObj.drugForm);
			$("#i-baseinfo-drug-content-ddd").text("DDD��" + drugInfoObj.drugDDD);
			if (PARAMObj.OrderPoisonCode == "KSS3") {
				drugPoisonDesc = "���⼶";
			} else if (PARAMObj.OrderPoisonCode == "KSS2"){
				drugPoisonDesc = "���Ƽ�";
			} else {
				drugPoisonDesc = "�����Ƽ�";
			};
			var sprator = "&nbsp;&nbsp;&nbsp;&nbsp;";
			var drugHtmlInfo = drugInfoObj.drugDesc + sprator + drugInfoObj.drugForm + sprator + drugPoisonDesc + sprator + "DDD��" + drugInfoObj.drugDDD;
			var docHtmlInfo = docInfoObj.docName + sprator + docInfoObj.ctCarPrvTpDesc;
			$("#i-baseinfo-drug-content-info").html(drugHtmlInfo);
			$("#i-baseinfo-doc-content-info").html(docHtmlInfo);
			
			// BaseInfo DIY DISPLAY
			var displayText = "";
			for (var j = 0; j < kssConfig.processInfo.length; j++ ) {
				if (kssConfig.processInfo[j] == "F") displayText = displayText + "> �����Ԥ�� ";
				if (kssConfig.processInfo[j] == "H") displayText = displayText + "> �����";
				if (kssConfig.processInfo[j] == "S") displayText = displayText + "> ��������";
				if (kssConfig.processInfo[j] == "U") displayText = displayText + "> ���������";
			};
			if ($.trim(displayText) == "") {
				displayText = "��";
			};
			$("#i-baseinfo-doc-content-process").text(displayText);
		},
		drawMainInerface: function(){
			//ʹ��Ŀ��
			$('#i-useaim-panel-aim').simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.MainInterface";
					param.QueryName="QryUseAim";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				},
				onSelect:function(record) {
					var UPMRtn = $.InvokeMethod("DHCAnt.KSS.Config.UsePurposeManage","UPMControl", record.id, PARAMObj.ArcimRowid);
					var UPMArr = UPMRtn.split("^");
					if (UPMArr[0]==1) {
						$.messager.alert('��ʾ',UPMArr[1],'warning');
					} else if (UPMArr[0]==2) {
						$.messager.alert('��ʾ',UPMArr[1],'warning');
						$('#i-useaim-panel-aim').simplecombobox("setValue","");
						return false;
					} else {
						//0��������
					}
					var browserType = ANT.getBrowserType();
					$('#i-useaim-panel-usedrugindication').simplecombobox({
						onBeforeLoad: function(param){
							param.ClassName="DHCAnt.KSS.MainInterface";
							param.QueryName="QryUseDrugIndication";
							param.ModuleName="combobox";
							param.Arg1=record.id;
							param.ArgCnt=1;
						}
					});
					//ANT.DHC.setHCombo(browserType,"i-useaim-panel-usedrugindication");
					$("#i-useaim-operlist-grid").simpledatagrid("clearSelections");
					if (record.text.indexOf("Ԥ��-����")>=0) {
						$("#i-useaim-panel-usedrugtime").simplecombobox('enable');
					} else {
						$("#i-useaim-panel-usedrugtime").simplecombobox('clear');
						$("#i-useaim-panel-usedrugtime").simplecombobox('disable');
						
					}
				}
			});
			//��ҩָ��
			$('#i-useaim-panel-usedrugindication').simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.MainInterface";
					param.QueryName="QryUseDrugIndication";
					param.ModuleName="combobox";
					param.Arg1="";
					param.ArgCnt=1;
				}
			});
			
			//��Ⱦ��λ
			$('#i-useaim-panel-infectionsite').simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.MainInterface";
					param.QueryName="QryInfectionSite";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
			})
			
			//�Ƿ��ͼ�
			$("#i-useaim-aetiology-panel-islab").localcombobox({
				data: [{id: '1', text: '��'}, {id: '0',text: '��'}],
				value: 0,
				onLoadSuccess: function(){
					var result = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","ChkSubmitType", PARAMObj.ArcimRowid);
					if (result == "1") {
						$(this).localcombobox('setValue',1);
					};
				}
			});
			
			//��ҩʱ��
			$('#i-useaim-panel-usedrugtime').simplecombobox({
				disabled:true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.MainInterface";
					param.QueryName="QryUseDrugTime";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
			})
			//ҩ��
			$('#i-useaim-sensitive-grid').simpledatagrid({
				pagination:false,
				border:false,
				headerCls:'panel-header-gray',
				queryParams: {
					ClassName:"DHCAnt.KSS.MainInterface",
					QueryName:"QrySensitiveList",
					ModuleName:"datagrid",
					Arg1:PARAMObj.PAADMRowid,
					ArgCnt:1
				},
				onLoadSuccess: function(data){
					$(this).parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
				},
				columns:[[
					{field:'BacterialNameC',title:'ϸ����',width:100},
					{field:'AntName',title:'��������',width:100},
					{field:'Resistance',title:'��ҩ����',width:100},
					{field:'SPName',title:'�걾',width:100},
					{field:'ReportDate',title:'��������',width:100},
					{field:'TSName',title:'������Ŀ',width:100},
					{field:'id',title:'id',width:100,hidden:true}
				]]
			});
			
			//����
			$('#i-useaim-operlist-grid').simpledatagrid({
				pagination:false,
				headerCls:'panel-header-gray',
				fit:true,
				border:false,
				queryParams: {
					ClassName:"DHCAnt.KSS.MainInterface",
					QueryName:"QryOperationList",
					ModuleName:"datagrid",
					Arg1:PARAMObj.PAADMRowid,
					ArgCnt:1
				},
				columns:[[
					{field:'OpName',title:'��������',width:100},
					{field:'operCut',title:'�����п�',width:100},
					{field:'StartDateStr',title:'������ʼʱ��',width:100},
					{field:'id',title:'id',width:100,hidden:true},
				]],
				onLoadSuccess: function(data){
					$(this).parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
					/*if (data.rows.length > 0) {
						for (var i = 0; i < data.rows.length; i++) {
							$("#i-useaim-operlist-row .datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[0].disabled = true;
						};
					};*/
				},
				onSelect: function(rowIndex, rowData) {
					var curYFDesc = $('#i-useaim-panel-aim').simplecombobox('getText');
					if (curYFDesc.indexOf("Ԥ��") >= 0) {
						var tempFlag = $.InvokeMethod("DHCAnt.KSS.MainInterface","ContrlOPYf",PARAMObj.PAADMRowid, rowData.id, PARAMObj.ArcimRowid);
						if(tempFlag == 1){
							$.messager.alert('��ʾ','�������ڡ�Ԥ��-������ʹ��Ŀ���£��������ô�ҩ!','info');
							//$(this).simpledatagrid("clearSelections");
							$(this).simpledatagrid('unselectRow', rowIndex);
							setTimeout(function () {
								$("#i-useaim-operlist-row tr[datagrid-row-index=" + rowIndex + "] input[name='ck']").attr("checked",false);
							},200);
						};
					};
					
				}
			});
		},
		extendFunction: function(){
			$("#i-apply-panel-isem").checkbox({
				onCheckChange: function () {
					if (!$("#i-apply-panel-isem").is(':checked')) {
						//$("#i-btn-submit").linkbutton("enable");
						$("#i-apply-panel-emreason").attr("disabled","disabled");
						$("#i-apply-panel-emreason").val("");
					} else {
						$("#i-apply-panel-emreason").removeAttr("disabled");
						if ((KSSConfig.EOE)&&(KSSConfig.EOE!="0")) {
							var result = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","ChkEmergencyType", PARAMObj.PAADMRowid, PARAMObj.ArcimRowid);
							if (result == "1") {
								$.messager.alert('��ʾ','Խ��ʹ��δ��ˣ������ٴ�Խ��!','info', function () {
									$("#i-apply-panel-isem").checkbox('uncheck');
								});
								
								return false;
							}
						}
					}
				}
			})
			
			if (( $.trim(KSSConfig.SUSEDRUGTIME) == "1" )&&(PARAMObj.PAAdmType=="I")) {
				$("#i-useaim-drugtime-existime").attr("disabled", "disabled");
				var existDays = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","GetUsedDaysNew", PARAMObj.PAADMRowid, PARAMObj.ArcimRowid);
				if (existDays !="" ) $("#i-useaim-drugtime-existime").val(existDays);
				if (existDays!="0") {
					$("#i-useaim-drugtime-extensionreason").attr("disabled", "disabled");
				}
				
			};
			//��ֵʹ��Ŀ��
			if (1) {	
				var lastOEInfo = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","GetDaupInfo", PARAMObj.OrderAntibApplyRowid);
				if ( (lastOEInfo!="-1") && (lastOEInfo != "")) {
					var lastOEArray = lastOEInfo.split('^');
					$("#i-useaim-panel-aim").simplecombobox("setValue", lastOEArray[0]);
					$("#i-useaim-panel-usedrugindication").simplecombobox("setValue", lastOEArray[2]);
					$("#i-useaim-panel-infectionsite").simplecombobox("setValue", lastOEArray[3]);
					if (lastOEArray[1] == "YF") {
						$('#i-useaim-panel-usedrugtime').simplecombobox("setValue", lastOEArray[4]);
						$('#i-useaim-panel-usedrugtime').simplecombobox("enable");
					}
					//$("#i-useaim-aetiology-panel-islab").simplecombobox("setValue", lastOEArray[5]);
					if (($.trim(KSSConfig.SKSS3IND) == "1")&&(PARAMObj.OrderPoisonCode == "KSS3")) {
						
						$('#i-useaim-panel-kss3indication').simplecombobox("setValue", lastOEArray[6]=="undefined" ? "" : lastOEArray[6]);
					};
					if ($.trim(KSSConfig.SBJ) == "1") {
						$('#i-useaim-aetiology-panel-zbjinput').simplecombobox("setValue", lastOEArray[7]);
					};
					
				};
			};
			//��ֵ������Ϣ
			if (PARAMObj.ShowTabStr.indexOf("Apply")>=0) {
				var myRtn = $.cm({
					ClassName:"DHCAnt.KSS.Extend.FindApply",
					MethodName:"GetApplyInfo",
					aaid:PARAMObj.OrderAntibApplyRowid,
					dataType:"text"
				},false); 
				if (myRtn!=""){
					var c1 = String.fromCharCode(1);
					myArr = myRtn.split(c1);
					if (myArr[0]==1) {
						$("#i-apply-panel-isem").checkbox("check");
						$("#i-apply-panel-emreason").val(myArr[1]);
						
					}
				}
				
				//
			}
			//��ֵ������Ϣ
			if (PARAMObj.ShowTabStr.indexOf("Consult")>=0) {
				var myRtn = $.cm({
					ClassName:"DHCAnt.KSS.Extend.FindApply",
					MethodName:"GetConsultInfo",
					AppRowid:PARAMObj.OrderAntibApplyRowid,
					dataType:"text"
				},false); 
				if (myRtn!=""){
					myArr = myRtn.split("^");
					
					switch ($.trim(KSSConfig.CONDEPNUM)){
						case "3":
							$("#i-consulation-panel-row3-conloc").simplecombobox('setValue' , myArr[2]);	//�������
							var url3 = $URL+"?ClassName=DHCAnt.KSS.MainInterface&QueryName=QryConsultationDoc&ctLocId="+myArr[2]+"&ResultSetType=array";
							$("#i-consulation-panel-row3-condoc").simplecombobox("reload",url3);
							$("#i-consulation-panel-row3-condoc").simplecombobox('setValue' , myArr[5]);	//����ҽ��
						case "2":
							$("#i-consulation-panel-row2-conloc").simplecombobox('setValue' , myArr[1]);	//�������
							var url2 = $URL+"?ClassName=DHCAnt.KSS.MainInterface&QueryName=QryConsultationDoc&ctLocId="+myArr[1]+"&ResultSetType=array";
							$("#i-consulation-panel-row2-condoc").simplecombobox("reload",url2);
							$("#i-consulation-panel-row2-condoc").simplecombobox('setValue' , myArr[4]);	//����ҽ��
						default:
							$("#i-consulation-panel-row1-conloc").simplecombobox('setValue' , myArr[0]);	//�������
							var url1 = $URL+"?ClassName=DHCAnt.KSS.MainInterface&QueryName=QryConsultationDoc&ctLocId="+myArr[0]+"&ResultSetType=array";
							$("#i-consulation-panel-row1-condoc").simplecombobox("reload",url1);
							$("#i-consulation-panel-row1-condoc").simplecombobox('setValue' , myArr[3]);	//����ҽ��
					}
				}
				var myRtn = $.cm({
					ClassName:"DHCAnt.KSS.Extend.FindApply",
					MethodName:"GetConsultReamrk",
					AppRowid:PARAMObj.OrderAntibApplyRowid,
					dataType:"text"
				},false); 
				if (myRtn!=""){
					$("#i-blcontent").val(myRtn);
				}
				
			}
			//��ֵ��չ��Ϣ
			if (KSSConfig.LOCALMODEL == 2) {
				var myXml = $.cm({
					ClassName:"DHCAnt.KSS.Extend.ModePrj",
					MethodName:"GetModePrjInfo",
					aaid:PARAMObj.OrderAntibApplyRowid,
					dataType:"text"
				},false); 
				if (myXml!=""){
					$.DHCAnt.SetInfoByXML(myXml);
				}
			}
			
		},
		doUI: function () {
			if (PARAMObj.ShowTabStr.indexOf("Apply")>=0){
				if ((PARAMObj.EmerFlag == 1)&&((KSSConfig.EOE == 1)||(KSSConfig.EOE == 2))) {
					$("#i-apply-panel-isem").attr("disabled", true);
				} else {
					if (PARAMObj.ShowTabStr.indexOf("Emergency") >= 0) {
						//$("#i-apply-panel-isem").attr("checked", true).attr("disabled", true);
						//$("#i-apply-panel-isem").iCheck('check').attr("disabled", true);
						$("#i-apply-panel-isem").checkbox("disable");
						$("#i-apply-panel-isem").checkbox("check");
						$("#i-apply-panel-emreason").removeAttr("disabled");
					};
				};
			};
		},
		SetInfoByXML: function (XMLStr) {
			var jsonData = $.parseJSON(XMLStr);
			var myparseinfo = PARAMObj.ModePrjEntity;
			var myary = myparseinfo.split("^");
			for (var myIdx=1; myIdx<myary.length; myIdx++){
				var cid = myary[myIdx];
				var _$id=$("#"+cid);
				var myItemValue = jsonData[0][cid];
				if (_$id.hasClass("hisui-combobox")){
						if (cid == "UPMYFLEVEL") {
							PageLogicObj.m_UPMYFVAL = jsonData[0]["UPMYFVAL"];
						}
						if (cid == "UPMZLLEVEL") {
							PageLogicObj.m_UPMZLVAL = jsonData[0]["UPMZLVAL"];
						}
						_$id.combobox("select",myItemValue);
						
				}else if(_$id.hasClass("hisui-checkbox")){
					if ((myItemValue=="Y")||(myItemValue=="1")){
						_$id.checkbox('check');
					}else{
						_$id.checkbox('uncheck');
					}
				} else if (_$id.hasClass("radiogroup")) {
					_$id.find("input[value='"+ myItemValue +"']").radio('check');
				} else if (_$id.hasClass("checkboxgroup")) {
					if (myItemValue=="") {
						continue;
					}
					var myItemArr = myItemValue.split(",");
					for (var i=0; i<myItemArr.length; i++) {
						var cVal = myItemArr[i];
						_$id.find("input[value='"+ cVal +"']").checkbox('check');
					}
				} else if (_$id.hasClass("hisui-numberspinner")) {
					_$id.numberspinner("setValue",myItemValue);
				} else if (_$id.hasClass("multiple")) {
					if (myItemValue == "") {
						continue;
					}
					if ((myItemValue=="UPMYFVAL")||(myItemValue=="UPMZLVAL")) {
						continue;
					}
					var size = $("#" + cid + " option").size();
					if (size > 0) {
						$.each($("#" + cid + " option"), function(i,own){
							//ARCICRowId + ">" + n.ARCICDesc
							var cValue = $(this).attr("value");
							if ((","+myItemValue+",").indexOf(","+cValue+",")>=0) {
								$(this).attr("selected",true);
							}
						})
					}	   
				} else if (cid == "DrugReason") {
					_$id.html(myItemValue)
				} else {
					_$id.val(myItemValue);
				}
				
				
			}
		}
	});
}(jQuery));