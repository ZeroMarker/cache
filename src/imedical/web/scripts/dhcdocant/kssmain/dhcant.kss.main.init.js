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
			if (!kssConfig.CONDEPNUM) {
				kssConfig.CONDEPNUM = 1;
			};
			if ($.trim(kssConfig.SMANYCONSULT) != "1") {
				kssConfig.CONDEPNUM = 1;
			};
		},
		initConfigLayout: function (kssConfig) {
			if (PARAMObj.ShowTabStr.indexOf("Apply")>=0){	//APPLY
				$("#i-apply").removeClass("c-item-hidden");
				$("#i-apply-panel").simplepanel({
					title:"&nbsp;申请信息",
					iconCls:'icon-apply'
				});
				if ((PARAMObj.EmerFlag == 1)&&(kssConfig.EOE == 1)) {
					$("#i-apply-panel-isem").attr("disabled", true);
				} else {
					if (PARAMObj.ShowTabStr.indexOf("Emergency") >= 0) {
						$("#i-apply-panel-isem").attr("checked", true).attr("disabled", true);
						$("#i-apply-panel-emreason").removeAttr("disabled");
					};
				};
			};
			//CONSULT DEP DISPLAY
			if ((PARAMObj.ShowTabStr.indexOf("Consult")>=0)&&(kssConfig.processInfo.indexOf("H")>=0)){		//CONSULT
				if ((!kssConfig.DEFAULTCONDEP)||(!kssConfig.DEFAULTCONDOC)) {		//IS DEFAULTDEP
					$("#i-consulation").removeClass("c-item-hidden");
					$("#i-consulation-panel").simplepanel({
						title:"&nbsp;会诊信息",
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
					title:"&nbsp;用药时间",
					iconCls:'icon-drugtime'
				});
			}
			
			//Is Start KSS3Indication Controller
			if (($.trim(kssConfig.SKSS3IND) == "1")&&(PARAMObj.OrderPoisonCode == "KSS3")) {
				$("#i-useaim-panel-kss3indication-lab").removeClass("c-item-hidden");
				$("#i-useaim-panel-kss3indication-div").removeClass("c-item-hidden");
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
			var drugInfoObj = jQuery.parseJSON(drugInfo),docInfoObj=jQuery.parseJSON(docInfo);
			$("#i-baseinfo-drug-content-drugname").text(drugInfoObj.drugDesc);
			$("#i-baseinfo-drug-content-drugform").text(drugInfoObj.drugForm);
			$("#i-baseinfo-drug-content-ddd").text("DDD：" + drugInfoObj.drugDDD);
			if (PARAMObj.OrderPoisonCode == "KSS3") {
				$("#i-baseinfo-drug-content-ksslevel").text("特殊级");
			} else if (PARAMObj.OrderPoisonCode == "KSS2"){
				$("#i-baseinfo-drug-content-ksslevel").text("限制级");
			} else {
				$("#i-baseinfo-drug-content-ksslevel").text("非限制级");
			}
			$("#i-baseinfo-doc-content-docname").text(docInfoObj.docName);
			$("#i-baseinfo-doc-content-docLevel").text(docInfoObj.ctCarPrvTpDesc);
			
			// BaseInfo DIY DISPLAY
			var displayText = "";
			for (var j = 0; j < kssConfig.processInfo.length; j++ ) {
				if (kssConfig.processInfo[j] == "F") displayText = displayText + "> 需科室预审 ";
				if (kssConfig.processInfo[j] == "H") displayText = displayText + "> 需会诊";
				if (kssConfig.processInfo[j] == "S") displayText = displayText + "> 需科室审核";
				if (kssConfig.processInfo[j] == "U") displayText = displayText + "> 需最终审核";
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
				onSelect:function(record) {
					$('#i-useaim-panel-usedrugindication').simplecombobox({
						onBeforeLoad: function(param){
							param.ClassName="DHCAnt.KSS.MainInterface";
							param.QueryName="QryUseDrugIndication";
							param.ModuleName="combobox";
							param.Arg1=record.id;
							param.ArgCnt=1;
						}
					});
					$("#i-useaim-operlist-grid").simpledatagrid("clearSelections");
					if (record.text.indexOf("预防-手术")>=0) {
						$("#i-useaim-panel-usedrugtime").simplecombobox('enable');
					} else {
						$("#i-useaim-panel-usedrugtime").simplecombobox('clear');
						$("#i-useaim-panel-usedrugtime").simplecombobox('disable');
						
					}
				}
			})
			
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
				data: [{id: '1', text: '是'}, {id: '0',text: '否'}],
				value: 0,
				onLoadSuccess: function(){
					var result = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","ChkSubmitType", PARAMObj.ArcimRowid);
					if (result == "1") {
						$(this).localcombobox('setValue',1);
					};
				}
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
				queryParams: {
					ClassName:"DHCAnt.KSS.MainInterface",
					QueryName:"QrySensitiveList",
					ModuleName:"datagrid",
					Arg1:PARAMObj.PAADMRowid,
					ArgCnt:1
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
				queryParams: {
					ClassName:"DHCAnt.KSS.MainInterface",
					QueryName:"QryOperationList",
					ModuleName:"datagrid",
					Arg1:PARAMObj.PAADMRowid,
					ArgCnt:1
				},
				columns:[[
					{field:'OpName',title:'手术名称',width:100},
					{field:'operCut',title:'手术切口',width:100},
					{field:'StartDateStr',title:'手术开始时间',width:100},
					{field:'id',title:'id',width:100,hidden:true},
				]],
				onLoadSuccess: function(data){
					$(this).parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
					if (data.rows.length > 0) {
						for (var i = 0; i < data.rows.length; i++) {
							$("#i-useaim-operlist-row .datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[0].disabled = true;
						};
					};
				},
				onSelect: function(rowIndex, rowData) {
					var curYFDesc = $('#i-useaim-panel-aim').simplecombobox('getText');
					if (curYFDesc.indexOf("预防") >= 0) {
						var tempFlag = $.InvokeMethod("DHCAnt.KSS.MainInterface","ContrlOPYf",PARAMObj.PAADMRowid, rowData.id, PARAMObj.ArcimRowid);
						if(tempFlag == 1){
							$.messager.alert('提示','该手术在【预防-手术】使用目的下，不建议用此药!','info');
							$(this).simpledatagrid("clearSelections");
						};
					};
					
				}
			});
		},
		extendFunction: function(){
			$("#i-useaim-sensitive-panel").panel({
				'onMaximize': function(){
					$.SetGridSize("i-useaim-sensitive", 1366, (310-55));
				},
				'onRestore':function(){
					$.SetGridSize("i-useaim-sensitive", 1366, 60);
				}
			});
			$("#i-useaim-operlist-panel").panel({
				'onMaximize': function(){
					$.SetGridSize("i-useaim-operlist", 1366, (310-55));
				},
				'onRestore':function(){
					$.SetGridSize("i-useaim-operlist", 1366, 60);
				}
			});
			$("#i-apply-panel-isem").change(function () {
				if (!$("#i-apply-panel-isem").is(':checked')) {
					$("#i-btn-submit").linkbutton("enable");
					$("#i-apply-panel-emreason").attr("disabled","disabled");
					$("#i-apply-panel-emreason").val("");
				} else {
					$("#i-apply-panel-emreason").removeAttr("disabled");
					if ((KSSConfig.EOE)&&(KSSConfig.EOE!="0")) {
						var result = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","ChkEmergencyType", PARAMObj.PAADMRowid, PARAMObj.ArcimRowid);
						if (result == "1") {
							$.messager.alert('提示','越级使用未审核，不能再次越级!','info');
							$("#i-btn-submit").linkbutton("disable");
							return false;
						}
					}
				}
			});
			if (( $.trim(KSSConfig.SUSEDRUGTIME) == "1" )&&(PARAMObj.PAAdmType=="I")) {
				$("#i-useaim-drugtime-existime").attr("disabled", "disabled");
				var existDays = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","GetUsedDaysNew", PARAMObj.PAADMRowid, PARAMObj.ArcimRowid);
				if (existDays !="" ) $("#i-useaim-drugtime-existime").val(existDays);
				if (existDays!="0") {
					$("#i-useaim-drugtime-extensionreason").attr("disabled", "disabled");
				}
				
			};
			if ((KSSConfig.AUTOAIM) && $.trim(KSSConfig.AUTOAIM) != "0" && $.trim(KSSConfig.AUTOAIM) != "") {
				var lastOEInfo = $.InvokeMethod("DHCAnt.KSS.FunctionExtend","GetLastDaupInfo", PARAMObj.PAADMRowid, PARAMObj.ArcimRowid);
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
		},
		validateUseAim: function(saveMainObj) {	//验证使用目的是否合法
			if (!saveMainObj.useaim) {
				$.messager.alert('提示','使用目的不能为空!','info');
				return false;
			};
			if (!saveMainObj.usedrugIndication) {
				$.messager.alert('提示','用药指征不能为空!','info');
				return false;
			};
			if (!saveMainObj.infectionSite) {
				$.messager.alert('提示','感染部位不能为空!','info');
				return false;
			};
			if (saveMainObj.useaimText.indexOf("预防-手术")>=0) {
				if (!saveMainObj.usedrugTime) {
					$.messager.alert('提示','用药时机不能为空!','info');
					return false;
				};
				if (saveMainObj.operIds.length==0) {
					$.messager.alert('提示','请选择手术记录!','info');
					return false;
				};
			};
			if ((saveMainObj.useaimText.indexOf("药敏")>=0) && (saveMainObj.sensitiveIds.length==0)) {
				$.messager.alert('提示','请选择药敏记录!','info');
				return false;
			};
			if ((saveMainObj.SKSS3IND == 1) && (saveMainObj.OrderPoisonCode == "KSS3")) {
				if (!saveMainObj.kss3Indication) {
					$.messager.alert('提示','请选择特抗药指征!','info');
					return false;
				};
			};
			if ( (saveMainObj.SBJ) && (!saveMainObj.zBj) && ($.trim(saveMainObj.SBJ) == "1") ) {
				$.messager.alert('提示','请选择致病菌!','info');
				return false;
			};
			if (($.trim(saveMainObj.SUSEDRUGTIME) == "1")&&(PARAMObj.PAAdmType=="I")) {
				if (!saveMainObj.pretime) {
					$.messager.alert('提示','请选填写预计用药天数!','info');
					return false;
				};
				var existDays = $("#i-useaim-drugtime-existime").val();
				if (existDays <= "0") {
					$("#i-useaim-drugtime-extensionreason").removeAttr("disabled");
					if ($.trim(saveMainObj.extensionreason) == "") {
						$.messager.alert('提示','请填写延长用药原因!','info');
						return false;
					};
				}
				
			};
			
			return true;
		},
		validateApplyInfo: function (applyMainObj){
			if ((applyMainObj.isEm)&&(!applyMainObj.emreason)) {
				$.messager.alert('提示','请填写越级使用原因!','info');
				$("#i-apply-panel-emreason").validatebox({   
					required: true,
					missingMessage:'请输入越级使用原因...',
					invalidMessage:'你输入的越级使用原因不合法...'
				}); 
				return false;
			};
			return true;
		},
		validateConsultInfo: function (consultMainObj) {
			switch ($.trim(consultMainObj.CONDEPNUM)) {
				case "3":
					if ((!consultMainObj.consultDoc3)||(!consultMainObj.consultDep3)) {
						$.messager.alert('提示','会诊科室和会诊医生不能为空!','info');
						return false;
					}
				case "2":
					if ((!consultMainObj.consultDoc2)||(!consultMainObj.consultDep2)) {
						$.messager.alert('提示','会诊科室和会诊医生不能为空!','info');
						return false;
					}
				default:
					if ((!consultMainObj.consultDoc1)||(!consultMainObj.consultDep1)) {
						$.messager.alert('提示','会诊科室和会诊医生不能为空!','info');
						return false;
					}
			}
			return true;
		},
		getUseAim: function (useaimMainObj) {
			useaimMainObj.useaim = $('#i-useaim-panel-aim').simplecombobox('getValue');	//使用目的
			useaimMainObj.useaimText = $('#i-useaim-panel-aim').simplecombobox('getText');	//使用目的文本值
			useaimMainObj.usedrugIndication = $("#i-useaim-panel-usedrugindication").simplecombobox('getValue');	//用药指征
			useaimMainObj.infectionSite=$("#i-useaim-panel-infectionsite").simplecombobox('getValue');	//感染部位
			useaimMainObj.usedrugTime = $("#i-useaim-panel-usedrugtime").simplecombobox('getValue');		//用药时机
			if ((useaimMainObj.SKSS3IND == 1) && (useaimMainObj.OrderPoisonCode == "KSS3")) {
				useaimMainObj.kss3Indication = $("#i-useaim-panel-kss3indication").simplecombobox('getValue');		//特抗药指征
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
			useaimMainObj.operIds = operIds;				//获取手术
			useaimMainObj.sensitiveIds = sensitiveIds;	//药敏记录
		},
		getDrugTime: function (useaimMainObj) {
			//useaimMainObj.existime = $.trim($("#i-useaim-drugtime-existime").val());	//当次可用药天数
			useaimMainObj.pretime = $.trim($("#i-useaim-drugtime-pretime").val());	//预计用药天数 
			useaimMainObj.extensionreason = $.trim($("#i-useaim-drugtime-extensionreason").val());	//延长用药原因
		},
		getZBacterium: function (useaimMainObj) {
			useaimMainObj.isLab = $("#i-useaim-aetiology-panel-islab").logicombobox('getValue');	//是否送检
			if ($.trim(useaimMainObj.SBJ) == "1") {
				useaimMainObj.zBj = $("#i-useaim-aetiology-panel-zbjinput").simplecombobox('getValue');	//致病菌
			}
			
		},
		getApplyInfo: function (applyMainObj) {
			applyMainObj.isEm = $("#i-apply-panel-isem").is(':checked');		//是否越级：true OR false
			if (applyMainObj.isEm) {
				applyMainObj.isEm = 1;
			} else {
				applyMainObj.isEm = 0;
			};
			if (applyMainObj.isEm) {
				applyMainObj.emreason = $.trim($("#i-apply-panel-emreason").val());	//越级原因
			};
		},
		getConsultInfo: function (consultMainObj) {
			switch ($.trim(consultMainObj.CONDEPNUM)){
				case "3":
					consultMainObj.consultDep3 = $("#i-consulation-panel-row3-conloc").simplecombobox('getValue');	//会诊科室
					consultMainObj.consultDoc3 = $("#i-consulation-panel-row3-condoc").simplecombobox('getValue');	//会诊医生
				case "2":
					consultMainObj.consultDep2 = $("#i-consulation-panel-row2-conloc").simplecombobox('getValue');	//会诊科室
					consultMainObj.consultDoc2 = $("#i-consulation-panel-row2-condoc").simplecombobox('getValue');	//会诊医生
				default:
					consultMainObj.consultDep1 = $("#i-consulation-panel-row1-conloc").simplecombobox('getValue');	//会诊科室
					consultMainObj.consultDoc1 = $("#i-consulation-panel-row1-condoc").simplecombobox('getValue');	//会诊医生
			};
		},
		closeWin: function (returnValue) {
			if (window.opener) {
				window.opener.returnValue = returnValue;
			} else {
				window.returnValue = returnValue;
			}
			window.close();
		}
	});
}(jQuery));