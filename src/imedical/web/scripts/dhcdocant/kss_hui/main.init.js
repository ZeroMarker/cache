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
			kssConfig.DEFAULTCONDEP = undefined;
			kssConfig.DEFAULTCONDOC = undefined;
			kssConfig.DEFAULTCONDEP1 = ((typeof kssConfig.DEFAULTCONDEP1 =="undefined")||(kssConfig.DEFAULTCONDEP1==0))?"":kssConfig.DEFAULTCONDEP1;
			kssConfig.DEFAULTCONDEP2 = ((typeof kssConfig.DEFAULTCONDEP2 =="undefined")||(kssConfig.DEFAULTCONDEP2==0))?"":kssConfig.DEFAULTCONDEP2;
			kssConfig.DEFAULTCONDEP3 = ((typeof kssConfig.DEFAULTCONDEP3 =="undefined")||(kssConfig.DEFAULTCONDEP3==0))?"":kssConfig.DEFAULTCONDEP3;
			kssConfig.DEFAULTCONDOC1 = ((typeof kssConfig.DEFAULTCONDOC1 =="undefined")||(kssConfig.DEFAULTCONDOC1==0))?"":kssConfig.DEFAULTCONDOC1;
			kssConfig.DEFAULTCONDOC2 = ((typeof kssConfig.DEFAULTCONDOC2 =="undefined")||(kssConfig.DEFAULTCONDOC2==0))?"":kssConfig.DEFAULTCONDOC2;
			kssConfig.DEFAULTCONDOC3 = ((typeof kssConfig.DEFAULTCONDOC3 =="undefined")||(kssConfig.DEFAULTCONDOC3==0))?"":kssConfig.DEFAULTCONDOC3;

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
						value:kssConfig.DEFAULTCONDEP1,
						onSelect:function(record) {
							if (typeof record == "undefined") {
								return false;
							}
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
							param.Arg1=kssConfig.DEFAULTCONDEP1;
							param.ArgCnt=1;
						},
						//value:kssConfig.DEFAULTCONDOC1		//���ڼ��سɹ�֮��ֵ����Ȼ�л��������ʱ������
						onLoadSuccess: function (data) {
							if (data.length>0) {
								if ($.hisui.indexOfArray(data,"id",kssConfig.DEFAULTCONDOC1)>-1){
									$(this).combobox("select",kssConfig.DEFAULTCONDOC1);
								}else{
									$(this).combobox("select","");
								}
							}
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
									value:kssConfig.DEFAULTCONDEP3,
									onSelect:function(record) {
										if (typeof record == "undefined") {
											return false;
										}
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
										param.Arg1=kssConfig.DEFAULTCONDEP3;
										param.ArgCnt=1;
									},
									//value:kssConfig.DEFAULTCONDOC3		//���ڼ��سɹ�֮��ֵ����Ȼ�л��������ʱ������
									onLoadSuccess: function (data) {
										if (data.length>0) {
											if ($.hisui.indexOfArray(data,"id",kssConfig.DEFAULTCONDOC3)>-1){
												$(this).combobox("select",kssConfig.DEFAULTCONDOC3);
											}else{
												$(this).combobox("select","");
											}
										}
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
									value:kssConfig.DEFAULTCONDEP2,
									onSelect:function(record) {
										if (typeof record == "undefined") {
											return false;
										}
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
										param.Arg1=kssConfig.DEFAULTCONDEP2;
										param.ArgCnt=1;
									},
									//value:kssConfig.DEFAULTCONDOC2		//���ڼ��سɹ�֮��ֵ����Ȼ�л��������ʱ������
									onLoadSuccess: function (data) {
										if (data.length>0) {
											if ($.hisui.indexOfArray(data,"id",kssConfig.DEFAULTCONDOC1)>-1){
												$(this).combobox("select",kssConfig.DEFAULTCONDOC2);
											}else{
												$(this).combobox("select","");
											}
										}
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
					//title:"<span style='margin-left:8px;'>�ؿ�ҩ���</span>",
					title:"�ؿ�ҩ���",
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
			var processInfoStr = $.InvokeMethod("DHCAnt.KSS.Common.Method", "GetUserIsAuth", session['LOGON.USERID'], PARAMObj.OrderPoisonCode, 3, PARAMObj.PAAdmType, session['LOGON.HOSPID']);
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
			/*
			if (PARAMObj.OrderPoisonCode == "KSS3") {
				drugPoisonDesc = "���⼶";
			} else if (PARAMObj.OrderPoisonCode == "KSS2"){
				drugPoisonDesc = "���Ƽ�";
			} else {
				drugPoisonDesc = "�����Ƽ�";
			};*/
			drugPoisonDesc = drugInfoObj.phoDesc;
			var sprator = "&nbsp;&nbsp;&nbsp;&nbsp;";
			var drugHtmlInfo = drugInfoObj.drugDesc + sprator + drugInfoObj.drugForm + sprator + drugPoisonDesc + sprator + "DDD��" + drugInfoObj.drugDDD;
			var docHtmlInfo = docInfoObj.docName + sprator + docInfoObj.ctCarPrvTpDesc;
			$("#i-baseinfo-drug-content-info").html(drugHtmlInfo);
			$("#i-baseinfo-doc-content-info").html(docHtmlInfo);
			
			// BaseInfo DIY DISPLAY
			var displayText = "";
			for (var j = 0; j < kssConfig.processInfo.length; j++ ) {
				if (kssConfig.processInfo[j] == "F") displayText = displayText + "> "+$g("�����Ԥ��");
				if (kssConfig.processInfo[j] == "H") displayText = displayText + "> "+$g("�����");
				if (kssConfig.processInfo[j] == "S") displayText = displayText + "> "+$g("��������");
				if (kssConfig.processInfo[j] == "U") displayText = displayText + "> "+$g("���������");
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
				defaultFilter:4,
				onSelect:function(record) {
					var UPMRtn = $.InvokeMethod("DHCAnt.KSS.Config.UsePurposeManage","UPMControl", record.id, PARAMObj.ArcimRowid,session['LOGON.HOSPID']);
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
				data: [{id: '1', text: $g('��')}, {id: '0',text: $g('��')}],
				value: 0,
				onLoadSuccess: function(){
					var result = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","ChkSubmitType", PARAMObj.ArcimRowid, "", session['LOGON.HOSPID']);
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
					{field:'OPAStatus',title:'����״̬',width:100},
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
			$("#i-useaim-sensitive-panel").panel({
				'onMaximize': function(){
					//$.SetGridSize("i-useaim-sensitive", 1366, (310-55));
				},
				'onRestore':function(){
					//$.SetGridSize("i-useaim-sensitive", 1366, 60);
				}
			});
			$("#i-useaim-operlist-panel").panel({
				'onMaximize': function(){
					//$.SetGridSize("i-useaim-operlist", 1366, (310-55));
				},
				'onRestore':function(){
					//$.SetGridSize("i-useaim-operlist", 1366, 60);
				}
			});
			
			$("#i-apply-panel-isem").checkbox({
				onCheckChange: function () {
					if (!$("#i-apply-panel-isem").is(':checked')) {
						//$("#i-btn-submit").linkbutton("enable");
						$("#i-apply-panel-emreason").attr("disabled","disabled");
						$("#i-apply-panel-emreason").val("");
					} else {
						$("#i-apply-panel-emreason").removeAttr("disabled");
						if ((KSSConfig.EOE)&&(KSSConfig.EOE!="0")) {
							var result = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","ChkEmergencyType", PARAMObj.PAADMRowid, PARAMObj.ArcimRowid,"",session['LOGON.HOSPID']);
							if (result == "1") {
								$.messager.alert('��ʾ','Խ��ʹ��δ��ˣ������ٴ�Խ��!','info', function () {
									$("#i-apply-panel-isem").checkbox('uncheck');
								});
								//$("#i-btn-submit").linkbutton("disable");
								//window.setTimeout(function () {
								//	$("#i-apply-panel-isem").checkbox('uncheck');
								//},100)
								return false;
							}
							var result = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","EMNumsControl", PARAMObj.PAADMRowid, PARAMObj.ArcimRowid, session['LOGON.USERID'],session['LOGON.HOSPID']);
							if (result == "0") {
								$.messager.alert('��ʾ','��Խ�������ѳ�����������Խ����','info', function () {
									$("#i-apply-panel-isem").checkbox('uncheck');
								});
								return false;
							}
						}
					}
				}
			})
			/* HISUI��8.20�Ÿ���֮�󣬲���֧��ifChanged �¼���
			$("#i-apply-panel-isem").on('ifChanged', function () {
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
							//$("#i-btn-submit").linkbutton("disable");
							//window.setTimeout(function () {
							//	$("#i-apply-panel-isem").checkbox('uncheck');
							//},100)
							return false;
						}
					}
				}
			});*/
			if (( $.trim(KSSConfig.SUSEDRUGTIME) == "1" )&&(PARAMObj.PAAdmType=="I")) {
				$("#i-useaim-drugtime-existime").attr("disabled", "disabled");
				var existDays = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","GetUsedDaysNew", PARAMObj.PAADMRowid, PARAMObj.ArcimRowid);
				if (existDays !="" ) $("#i-useaim-drugtime-existime").val(existDays);
				if (existDays!="0") {
					$("#i-useaim-drugtime-extensionreason").attr("disabled", "disabled");
				}
				
			};
			if ((KSSConfig.AUTOAIM) && $.trim(KSSConfig.AUTOAIM) != "0" && $.trim(KSSConfig.AUTOAIM) != "") {
				var lastOEInfo = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","GetLastDaupInfo", PARAMObj.PAADMRowid, PARAMObj.ArcimRowid,"",session['LOGON.HOSPID']);
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
					if (lastOEArray[8]==1) {
						$.messager.alert('��ʾ','��ʹ��Ŀ���£���ҩƷ�����ã�','info');
					}
				};
			};
			//��ֵ��Ⱦ���
			if (KSSConfig.LOCALMODEL == 2) {
				var result = $.cm({
					ClassName:"DHCAnt.KSS.Extend.ModePrj",
					MethodName:"GetGRInfo",
					dataType:"text",
					admid:PARAMObj.PAADMRowid
				},false);
				if (result != "") {
					var jsonData = $.parseJSON(result);
					$("#WBC").val(jsonData[0]["WBC"]);
					$("#N").val(jsonData[0]["GRAN"]);
					$("#CRP").val(jsonData[0]["CRP"]);
					$("#PCT").val(jsonData[0]["PCT"]);
					$("#G").val(jsonData[0]["GTEST"]);
					$("#GM").val(jsonData[0]["GMTEST"]);
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
			if (PARAMObj.LocalMode == 2) {
				
				$HUI.combobox("#JLUom", {
					url:$URL+"?ClassName=DHCAnt.KSS.Common.Query&QueryName=QryDoseUom&arcim="+PARAMObj.ArcimRowid+"&ResultSetType=array",
					valueField:'id',
					textField:'text',
					blurValidValue:true,
					onLoadSuccess: function () {
						var data = $(this).combobox('getData');
						if (data.length>0) {
							$(this).combobox("select",data[0].id);
						}
					}
				});	
				
				$HUI.combobox("#Instruc", {
					url:$URL+"?ClassName=web.UDHCFavItemNew&QueryName=CombListFind&CombName=ItemInstruction&ResultSetType=array",
					valueField:'CombValue',
					textField:'CombDesc',
					defaultFilter:4,
					blurValidValue:true
				});	
				
				$HUI.combobox("#Freq", {
					url:$URL+"?ClassName=web.UDHCFavItemNew&QueryName=CombListFind&CombName=ItemFrequence&ResultSetType=array",
					valueField:'CombValue',
					defaultFilter:4,
					textField:'CombDesc',
					blurValidValue:true
					
				});
				
				$HUI.combobox("#Prior", {
					url:$URL+"?ClassName=DHCAnt.KSS.Common.Query&QueryName=QryOrderPrior&ResultSetType=array",
					valueField:'id',
					defaultFilter:4,
					textField:'text',
					value:PARAMObj.OrderPriorRowid||"",
					blurValidValue:true
					
				});
				
			}

		},
		validateUseAim: function(saveMainObj) {	//��֤ʹ��Ŀ���Ƿ�Ϸ�
			if (!saveMainObj.useaim) {
				websys_getTop().$.messager.alert('��ʾ','ʹ��Ŀ�Ĳ���Ϊ��!','info');
				return false;
			};
			if (!saveMainObj.usedrugIndication) {
				websys_getTop().$.messager.alert('��ʾ','��ҩָ������Ϊ��!','info');
				return false;
			};
			if (!saveMainObj.infectionSite) {
				websys_getTop().$.messager.alert('��ʾ','��Ⱦ��λ����Ϊ��!','info');
				return false;
			};
			if (saveMainObj.useaimText.indexOf("Ԥ��-����")>=0) {
				if (!saveMainObj.usedrugTime) {
					websys_getTop().$.messager.alert('��ʾ','��ҩʱ������Ϊ��!','info');
					return false;
				};
				if (saveMainObj.operIds.length==0) {
					websys_getTop().$.messager.alert('��ʾ','��ѡ��������¼!','info');
					return false;
				};
			};
			if ((saveMainObj.useaimText.indexOf("ҩ��")>=0) && (saveMainObj.sensitiveIds.length==0)) {
				websys_getTop().$.messager.alert('��ʾ','��ѡ��ҩ����¼!','info');
				return false;
			};
			if ((saveMainObj.SKSS3IND == 1) && (saveMainObj.OrderPoisonCode == "KSS3")) {
				if (!saveMainObj.kss3Indication) {
					websys_getTop().$.messager.alert('��ʾ','��ѡ���ؿ�ҩָ��!','info');
					return false;
				};
			};
			if ( (saveMainObj.SBJ) && (!saveMainObj.zBj) && ($.trim(saveMainObj.SBJ) == "1") ) {
				//websys_getTop().$.messager.alert('��ʾ','��ѡ���²���!','info');
				//return false;
			};
			if (($.trim(saveMainObj.SUSEDRUGTIME) == "1")&&(PARAMObj.PAAdmType=="I")) {
				if (!saveMainObj.pretime) {
					websys_getTop().$.messager.alert('��ʾ','��ѡ��дԤ����ҩ����!','info');
					return false;
				};
				var existDays = $("#i-useaim-drugtime-existime").val();
				if (existDays <= "0") {
					$("#i-useaim-drugtime-extensionreason").removeAttr("disabled");
					if ($.trim(saveMainObj.extensionreason) == "") {
						websys_getTop().$.messager.alert('��ʾ','����д�ӳ���ҩԭ��!','info');
						return false;
					};
				}
				
			};
			
			return true;
		},
		validateApplyInfo: function (applyMainObj){
			if ((applyMainObj.isEm)&&(!applyMainObj.emreason)) {
				websys_getTop().$.messager.alert('��ʾ','����дԽ��ʹ��ԭ��!','info');
				$("#i-apply-panel-emreason").validatebox({   
					required: true,
					missingMessage:'������Խ��ʹ��ԭ��...',
					invalidMessage:'�������Խ��ʹ��ԭ�򲻺Ϸ�...'
				}); 
				return false;
			};
			return true;
		},
		validateConsultInfo: function (consultMainObj) {
			switch ($.trim(consultMainObj.CONDEPNUM)) {
				case "3":
					if ((!consultMainObj.consultDoc3)||(!consultMainObj.consultDep3)) {
						websys_getTop().$.messager.alert('��ʾ','������Һͻ���ҽ������Ϊ��!','info');
						return false;
					}
				case "2":
					if ((!consultMainObj.consultDoc2)||(!consultMainObj.consultDep2)) {
						websys_getTop().$.messager.alert('��ʾ','������Һͻ���ҽ������Ϊ��!','info');
						return false;
					}
				default:
					if ((!consultMainObj.consultDoc1)||(!consultMainObj.consultDep1)) {
						websys_getTop().$.messager.alert('��ʾ','������Һͻ���ҽ������Ϊ��!','info');
						return false;
					}
			}
			return true;
		},
		getUseAim: function (useaimMainObj) {
			useaimMainObj.useaim = $('#i-useaim-panel-aim').simplecombobox('getValue');	//ʹ��Ŀ��
			useaimMainObj.useaimText = $('#i-useaim-panel-aim').simplecombobox('getText');	//ʹ��Ŀ���ı�ֵ
			useaimMainObj.usedrugIndication = $("#i-useaim-panel-usedrugindication").simplecombobox('getValue');	//��ҩָ��
			useaimMainObj.infectionSite=$("#i-useaim-panel-infectionsite").simplecombobox('getValue');	//��Ⱦ��λ
			useaimMainObj.usedrugTime = $("#i-useaim-panel-usedrugtime").simplecombobox('getValue');		//��ҩʱ��
			if ((useaimMainObj.SKSS3IND == 1) && (useaimMainObj.OrderPoisonCode == "KSS3")) {
				useaimMainObj.kss3Indication = $("#i-useaim-panel-kss3indication").simplecombobox('getValue');		//�ؿ�ҩָ��
				useaimMainObj.kss3Indication = !useaimMainObj.kss3Indication ? "" : useaimMainObj.kss3Indication;
			};
			var operIds = [],	
				sensitiveIds = [],
				operSelectedRows = $('#i-useaim-operlist-grid').datagrid('getSelections'),
				senstiveSelectedRows = $('#i-useaim-sensitive-grid').datagrid('getSelections');	
			for (var i = 0; i < operSelectedRows.length; i++) {
				operIds.push(operSelectedRows[i].id);
			};
			for (var j = 0; j < senstiveSelectedRows.length; j++) {
				sensitiveIds.push(senstiveSelectedRows[j].id);
			};
			useaimMainObj.operIds = operIds;				//��ȡ����
			useaimMainObj.sensitiveIds = sensitiveIds;	//ҩ����¼
		},
		getDrugTime: function (useaimMainObj) {
			//useaimMainObj.existime = $.trim($("#i-useaim-drugtime-existime").val());	//���ο���ҩ����
			useaimMainObj.pretime = $.trim($("#i-useaim-drugtime-pretime").val());	//Ԥ����ҩ���� 
			useaimMainObj.extensionreason = $.trim($("#i-useaim-drugtime-extensionreason").val());	//�ӳ���ҩԭ��
		},
		getZBacterium: function (useaimMainObj) {
			useaimMainObj.isLab = $("#i-useaim-aetiology-panel-islab").logicombobox('getValue');	//�Ƿ��ͼ�
			if ($.trim(useaimMainObj.SBJ) == "1") {
				useaimMainObj.zBj = $("#i-useaim-aetiology-panel-zbjinput").simplecombobox('getValue');	//�²���
			}
			
		},
		getApplyInfo: function (applyMainObj) {
			applyMainObj.isEm = $("#i-apply-panel-isem").is(':checked');		//�Ƿ�Խ����true OR false
			if (applyMainObj.isEm) {
				applyMainObj.isEm = 1;
			} else {
				applyMainObj.isEm = 0;
			};
			if (applyMainObj.isEm) {
				applyMainObj.emreason = $.trim($("#i-apply-panel-emreason").val());	//Խ��ԭ��
			};
		},
		getConsultInfo: function (consultMainObj) {
			switch ($.trim(consultMainObj.CONDEPNUM)){
				case "3":
					consultMainObj.consultDep3 = $("#i-consulation-panel-row3-conloc").simplecombobox('getValue');	//�������
					consultMainObj.consultDoc3 = $("#i-consulation-panel-row3-condoc").simplecombobox('getValue');	//����ҽ��
				case "2":
					consultMainObj.consultDep2 = $("#i-consulation-panel-row2-conloc").simplecombobox('getValue');	//�������
					consultMainObj.consultDoc2 = $("#i-consulation-panel-row2-condoc").simplecombobox('getValue');	//����ҽ��
				default:
					consultMainObj.consultDep1 = $("#i-consulation-panel-row1-conloc").simplecombobox('getValue');	//�������
					consultMainObj.consultDoc1 = $("#i-consulation-panel-row1-condoc").simplecombobox('getValue');	//����ҽ��
			};
		},
		closeWin: function (returnValue) {
			if ((websys_showModal('options'))&&(websys_showModal('options').CallBackFunc)) {
				websys_showModal('options').CallBackFunc(returnValue);
			}else{
				if (window.opener) {
					window.opener.returnValue = returnValue;
				} else {
					window.returnValue = returnValue;
				}
				window.close();
			}
		}
	});
}(jQuery));
