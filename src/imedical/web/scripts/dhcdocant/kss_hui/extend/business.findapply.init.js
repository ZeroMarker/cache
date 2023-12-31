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
			kssConfig.DEFAULTCONDEP=undefined;
		},
		initConfigLayout: function (kssConfig) {
			//计算各面板的高度,DHCANT-V4.1.2中增加配置
			var consultPanelHeight = 118,
				applyPanelHeight = 85,
				kss3PanelHieght = 85,
				drugTimePanelHeight = 120;
			var dynamicHeight = 215 + Math.floor(drugTimePanelHeight/2);	//Condition1 所有配置都启用时 
			var dynamicHeight2 = 210 + Math.floor((drugTimePanelHeight - kss3PanelHieght)/2);	//Condition2 特抗药指证不启用，其他都启用 
			var dynamicHeight3 = 217;			//Condition3 预防用药指证不启用，其他都启用
			var dynamicHeight4 = "无需设置";	//Condition4 预防用药指证不启用，特抗药指证不启用，其他都有
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
					title:"申请信息",
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
						title:"会诊信息",
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
											$.messager.alert('提示','会诊医师不能选择申请本人!','info');
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
										$.messager.alert('提示','会诊医生重复!','info');
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
													$.messager.alert('提示','会诊医师不能选择申请本人!','info');
													$(this).simplecombobox('clear');
													return false;
												};
												var flag1 = (doc1!="")&&((doc1==doc2)||(doc1==doc3)),
													flag2 = (doc2!="")&&((doc1==doc2)||(doc2==doc3));
												if (flag1||flag2) {
													$.messager.alert('提示','会诊医生重复!','info');
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
														$.messager.alert('提示','会诊医师不能选择申请本人!','info');
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
													$.messager.alert('提示','会诊医生重复!','info');
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
			
			//是否启用致病菌
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
					title:"<span style='margin-left:8px;'>用药时间</span>",
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
					title:"特抗药相关",
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
			$("#i-baseinfo-drug-content-ddd").text("DDD：" + drugInfoObj.drugDDD);
			/*if (PARAMObj.OrderPoisonCode == "KSS3") {
				drugPoisonDesc = "特殊级";
			} else if (PARAMObj.OrderPoisonCode == "KSS2"){
				drugPoisonDesc = "限制级";
			} else {
				drugPoisonDesc = "非限制级";
			};*/
			drugPoisonDesc = drugInfoObj.phoDesc;
			var sprator = "&nbsp;&nbsp;&nbsp;&nbsp;";
			var drugHtmlInfo = drugInfoObj.drugDesc + sprator + drugInfoObj.drugForm + sprator + drugPoisonDesc + sprator + "DDD：" + drugInfoObj.drugDDD;
			var docHtmlInfo = docInfoObj.docName + sprator + docInfoObj.ctCarPrvTpDesc;
			$("#i-baseinfo-drug-content-info").html(drugHtmlInfo);
			$("#i-baseinfo-doc-content-info").html(docHtmlInfo);
			
			// BaseInfo DIY DISPLAY
			var displayText = "";
			for (var j = 0; j < kssConfig.processInfo.length; j++ ) {
			if (kssConfig.processInfo[j] == "F") displayText = displayText + "> "+$g("需科室预审");
				if (kssConfig.processInfo[j] == "H") displayText = displayText + "> "+$g("需会诊");
				if (kssConfig.processInfo[j] == "S") displayText = displayText + "> "+$g("需科室审核");
				if (kssConfig.processInfo[j] == "U") displayText = displayText + "> "+$g("需最终审核");
			};
			if ($.trim(displayText) == "") {
				displayText = "无";
			};
			$("#i-baseinfo-doc-content-process").text(displayText);
		},
		drawMainInerface: function(){
			//使用目的
			$('#i-useaim-panel-aim').simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.MainInterface";
					param.QueryName="QryUseAim";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				},
				/*onSelect:function(record) {
					var UPMRtn = $.InvokeMethod("DHCAnt.KSS.Config.UsePurposeManage","UPMControl", record.id, PARAMObj.ArcimRowid);
					var UPMArr = UPMRtn.split("^");
					if (UPMArr[0]==1) {
						$.messager.alert('提示',UPMArr[1],'warning');
					} else if (UPMArr[0]==2) {
						$.messager.alert('提示',UPMArr[1],'warning');
						$('#i-useaim-panel-aim').simplecombobox("setValue","");
						return false;
					} else {
						//0不做控制
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
					if (record.text.indexOf("预防-手术")>=0) {
						$("#i-useaim-panel-usedrugtime").simplecombobox('enable');
					} else {
						$("#i-useaim-panel-usedrugtime").simplecombobox('clear');
						$("#i-useaim-panel-usedrugtime").simplecombobox('disable');
						
					}
				}*/
			});
			//用药指征
			$('#i-useaim-panel-usedrugindication').simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.MainInterface";
					param.QueryName="QryUseDrugIndication";
					param.ModuleName="combobox";
					param.Arg1="";
					param.ArgCnt=1;
				}
			});
			
			//感染部位
			$('#i-useaim-panel-infectionsite').simplecombobox({
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.MainInterface";
					param.QueryName="QryInfectionSite";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
			})
			
			//是否送检
			$("#i-useaim-aetiology-panel-islab").localcombobox({
				data: [{id: '1', text: $g('是')}, {id: '0',text: $g('否')}]
				//value: 0,
				/*onLoadSuccess: function(){
					var result = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","ChkSubmitType", PARAMObj.ArcimRowid);
					if (result == "1") {
						$(this).localcombobox('setValue',1);
					};
				}*/
			});
			
			//用药时机
			$('#i-useaim-panel-usedrugtime').simplecombobox({
				disabled:true,
				onBeforeLoad: function(param){
					param.ClassName="DHCAnt.KSS.MainInterface";
					param.QueryName="QryUseDrugTime";
					param.ModuleName="combobox";
					param.ArgCnt=0;
				}
			})
			//药敏
			$('#i-useaim-sensitive-grid').simpledatagrid({
				pagination:false,
				border:false,
				headerCls:'panel-header-gray',
				idField:'id',
				queryParams: {
					ClassName:"DHCAnt.KSS.MainInterface",
					QueryName:"QrySensitiveList",
					ModuleName:"datagrid",
					Arg1:PARAMObj.PAADMRowid,
					Arg2:PARAMObj.OrderAntibApplyRowid,
					ArgCnt:2
				},
				onLoadSuccess: function(data){
					$(this).parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
					for (var i=0; i<data.rows.length;i++) {
						if (data.rows[i].Selected == 1) {
							$(this).simpledatagrid("selectRecord",data.rows[i].id);
						}
					}
				},
				columns:[[
					{field:'BacterialNameC',title:'细菌名',width:100},
					{field:'AntName',title:'抗生素名',width:100},
					{field:'Resistance',title:'耐药机制',width:100},
					{field:'SPName',title:'标本',width:100},
					{field:'ReportDate',title:'报告日期',width:100},
					{field:'TSName',title:'检验项目',width:100},
					{field:'id',title:'id',width:100,hidden:true}
				]]
			});
			
			//手术
			$('#i-useaim-operlist-grid').simpledatagrid({
				pagination:false,
				headerCls:'panel-header-gray',
				fit:true,
				idField:'id',
				border:false,
				queryParams: {
					ClassName:"DHCAnt.KSS.MainInterface",
					QueryName:"QryOperationList",
					ModuleName:"datagrid",
					Arg1:PARAMObj.PAADMRowid,
					Arg2:PARAMObj.OrderAntibApplyRowid,
					ArgCnt:2
				},
				columns:[[
					{field:'OpName',title:'手术名称',width:100},
					{field:'operCut',title:'手术切口',width:100},
					{field:'StartDateStr',title:'手术开始时间',width:100},
					{field:'id',title:'id',width:100,hidden:true},
				]],
				onLoadSuccess: function(data){
					$(this).parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
					/*if (data.rows.length > 0) {
						for (var i = 0; i < data.rows.length; i++) {
							$("#i-useaim-operlist-row .datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[0].disabled = true;
						};
					};*/
					for (var i=0; i<data.rows.length;i++) {
						if (data.rows[i].Selected == 1) {
							$(this).simpledatagrid("selectRecord",data.rows[i].id);
						}
					}
				},
				onSelect: function(rowIndex, rowData) {
					var curYFDesc = $('#i-useaim-panel-aim').simplecombobox('getText');
					if (curYFDesc.indexOf("预防") >= 0) {
						var tempFlag = $.InvokeMethod("DHCAnt.KSS.MainInterface","ContrlOPYf",PARAMObj.PAADMRowid, rowData.id, PARAMObj.ArcimRowid);
						if(tempFlag == 1){
							$.messager.alert('提示','该手术在【预防-手术】使用目的下，不建议用此药!','info');
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
						/*if ((KSSConfig.EOE)&&(KSSConfig.EOE!="0")) {
							var result = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","ChkEmergencyType", PARAMObj.PAADMRowid, PARAMObj.ArcimRowid);
							if (result == "1") {
								$.messager.alert('提示','越级使用未审核，不能再次越级!','info', function () {
									$("#i-apply-panel-isem").checkbox('uncheck');
								});
								
								return false;
							}
						}*/
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
			//赋值使用目的
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
					$("#i-useaim-aetiology-panel-islab").simplecombobox("setValue", lastOEArray[5]);
					if (($.trim(KSSConfig.SKSS3IND) == "1")&&(PARAMObj.OrderPoisonCode == "KSS3")) {
						
						$('#i-useaim-panel-kss3indication').simplecombobox("setValue", lastOEArray[6]=="undefined" ? "" : lastOEArray[6]);
					};
					if ($.trim(KSSConfig.SBJ) == "1") {
						$('#i-useaim-aetiology-panel-zbjinput').simplecombobox("setValue", lastOEArray[7]);
					};
					
				};
			};
			//赋值申请信息
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
			//赋值会诊信息
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
							$("#i-consulation-panel-row3-conloc").simplecombobox('setValue' , myArr[2]);	//会诊科室
							var url3 = $URL+"?ClassName=DHCAnt.KSS.MainInterface&QueryName=QryConsultationDoc&ctLocId="+myArr[2]+"&ResultSetType=array";
							$("#i-consulation-panel-row3-condoc").simplecombobox("reload",url3);
							$("#i-consulation-panel-row3-condoc").simplecombobox('setValue' , myArr[5]);	//会诊医生
						case "2":
							$("#i-consulation-panel-row2-conloc").simplecombobox('setValue' , myArr[1]);	//会诊科室
							var url2 = $URL+"?ClassName=DHCAnt.KSS.MainInterface&QueryName=QryConsultationDoc&ctLocId="+myArr[1]+"&ResultSetType=array";
							$("#i-consulation-panel-row2-condoc").simplecombobox("reload",url2);
							$("#i-consulation-panel-row2-condoc").simplecombobox('setValue' , myArr[4]);	//会诊医生
						default:
							$("#i-consulation-panel-row1-conloc").simplecombobox('setValue' , myArr[0]);	//会诊科室
							var url1 = $URL+"?ClassName=DHCAnt.KSS.MainInterface&QueryName=QryConsultationDoc&ctLocId="+myArr[0]+"&ResultSetType=array";
							$("#i-consulation-panel-row1-condoc").simplecombobox("reload",url1);
							$("#i-consulation-panel-row1-condoc").simplecombobox('setValue' , myArr[3]);	//会诊医生
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
			
			//赋值扩展信息
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
			if (PARAMObj.LocalMode == 2) {
				
				$HUI.combobox("#JLUom", {
					url:$URL+"?ClassName=DHCAnt.KSS.Common.Query&QueryName=QryDoseUom&arcim="+PARAMObj.ArcimRowid+"&ResultSetType=array",
					valueField:'id',
					textField:'text',
					blurValidValue:true,
					onLoadSuccess: function () {
						var data = $(this).combobox('getData');
						if (data.length>0) {
							//$(this).combobox("select",data[0].id);
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
					blurValidValue:true
					
				});
			}
			
		},
		SetInfoByXML: function (XMLStr) {
			var jsonData = $.parseJSON(XMLStr);
			var myparseinfo = PARAMObj.ModePrjEntity;
			var myary = myparseinfo.split("^");
			for (var myIdx=1; myIdx<myary.length; myIdx++){
				var cid = myary[myIdx];
				var _$id=$("#"+cid);
				var myItemValue = jsonData[0][cid];
				if (_$id.hasClass("hisui-combobox")||(_$id.hasClass("combo-f"))){
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