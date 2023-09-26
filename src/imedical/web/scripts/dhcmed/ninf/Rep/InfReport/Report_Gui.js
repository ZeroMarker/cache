
function InitViewPort()
{
	var obj = new Object();
	
	if (typeof InitReportEvent == 'function') obj = InitReportEvent(obj);     //初始化报告事件
	if (typeof InitReportWord == 'function') obj = InitReportWord(obj);       //初始化报告打印
	
	//初始化报告信息、就诊信息、患者信息
	obj.CurrReport = obj.GetReport(ReportID);
	if (!obj.CurrReport) return;
	obj.CurrPaadm  = obj.ClsBasePatientAdm.GetObjById(obj.CurrReport.EpisodeID);
	if (!obj.CurrPaadm) return;
	obj.CurrPatient = obj.ClsBasePatient.GetObjById(obj.CurrPaadm.PatientID);
	if (!obj.CurrPatient) return;
	
	//初始化报告标题
	var RepTitle = '';
	
	var ModuleList = '';
	if (obj.CurrReport.ReportType) {
		RepTitle = obj.CurrReport.ReportType.Description;
		var RepCode = obj.CurrReport.ReportType.Code;
		if (RepCode=='COMP') {
			ModuleList = 'BASE^INFPOS^OPR^LAB^ANTI^NOTE';
		} else if (RepCode=='NCOM') {
			ModuleList = 'BASE^NBINF^LAB^ANTI';
		} else if (RepCode=='ICU') {
			ModuleList = 'IBASE^IDIAG^ADIAG^IPICC^IVAP^IUC^ALAB';
		} else if (RepCode=='NICU') {
			ModuleList = 'NBASE^NPICC^NVNT^NUC';
		} else if (RepCode=='OPR') {
			ModuleList = 'OBASE^ADIAG^OOPR^AANTI';
		} else {
			ModuleList = 'BASE^INFPOS^OPR^LAB^ANTI^NOTE';
		}
	}
	
	//初始化操作权限
	obj.AdminPower  = AdminPower;
	/*
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	*/
	
	//初始化界面模块
	var arrTabItems = [];
	var arrModule = ModuleList.split("^");
	for (var indModule = 0; indModule < arrModule.length; indModule++) {
		var strModule = arrModule[indModule];
		switch (strModule) {
			case "NOTE" :
				if (typeof InitNOTE == 'function') {
					obj = InitNOTE(obj);                      //加载 报告说明
					arrTabItems = arrTabItems.concat([obj.NOTE_ViewPort]);
				}
				break;
			case "BASE" :
				if (typeof InitBASE == 'function') {
					obj = InitBASE(obj);                      //加载 病人基本信息
					arrTabItems = arrTabItems.concat([obj.BASE_ViewPort]);
				}
				break;
			case "INFPOS" :
				if (typeof InitINFPOS == 'function') {
					obj = InitINFPOS(obj);                    //加载 感染部位
					arrTabItems = arrTabItems.concat([obj.INFPOS_ViewPort]);
				}
				break;
			case "NBINF" :
				if (typeof InitNBINF == 'function') {
					obj = InitNBINF(obj);                    //加载 新生儿感染信息
					arrTabItems = arrTabItems.concat([obj.NBINF_ViewPort]);
				}
				break;
			case "OPR" :
				if (typeof InitOPR == 'function') {
					obj = InitOPR(obj);                       //加载 手术相关
					arrTabItems = arrTabItems.concat([obj.OPR_ViewPort]);
				}
				break;
			case "LAB" :
				if (typeof InitLAB == 'function') {
					obj = InitLAB(obj);                       //加载 病原菌检验
					arrTabItems = arrTabItems.concat([obj.LAB_ViewPort]);
				}
				break;
			case "ANTI" :
				if (typeof InitANTI == 'function') {
					obj = InitANTI(obj);                      //加载 抗菌药物
					arrTabItems = arrTabItems.concat([obj.ANTI_ViewPort]);
				}
				break;
			case "IBASE" :
				if (typeof InitIBASE == 'function') {
					obj = InitIBASE(obj);                     //加载 病人基本信息
					arrTabItems = arrTabItems.concat([obj.IBASE_ViewPort]);
				}
				break;
			case "IDIAG" :
				if (typeof InitIDIAG == 'function') {
					obj = InitIDIAG(obj);                     //加载 转入ICU诊断
					arrTabItems = arrTabItems.concat([obj.IDIAG_ViewPort]);
				}
				break;
			case "IPICC" :
				if (typeof InitIPICC == 'function') {
					obj = InitIPICC(obj);                     //加载 ICU中央导管
					arrTabItems = arrTabItems.concat([obj.IPICC_ViewPort]);
				}
				break;
			case "IVAP" :
				if (typeof InitIVAP == 'function') {
					obj = InitIVAP(obj);                     //加载 ICU呼吸机
					arrTabItems = arrTabItems.concat([obj.IVAP_ViewPort]);
				}
				break;
			case "IUC" :
				if (typeof InitIUC == 'function') {
					obj = InitIUC(obj);                      //加载 ICU导尿管
					arrTabItems = arrTabItems.concat([obj.IUC_ViewPort]);
				}
				break;
			case "NBASE" :
				if (typeof InitNBASE == 'function') {
					obj = InitNBASE(obj);                   //加载 病人基本信息
					arrTabItems = arrTabItems.concat([obj.NBASE_ViewPort]);
				}
				break;
			case "NPICC" :
				if (typeof InitNPICC == 'function') {
					obj = InitNPICC(obj);                   //加载 NICU中央导管
					arrTabItems = arrTabItems.concat([obj.NPICC_ViewPort]);
				}
				break;
			case "NVNT" :
				if (typeof InitNVNT == 'function') {
					obj = InitNVNT(obj);                    //加载 NICU气管插管
					arrTabItems = arrTabItems.concat([obj.NVNT_ViewPort]);
				}
				break;
			case "NUC" :
				if (typeof InitNUC == 'function') {
					obj = InitNUC(obj);                     //加载 NICU脐静脉
					arrTabItems = arrTabItems.concat([obj.NUC_ViewPort]);
				}
				break;
			case "OBASE" :
				if (typeof InitOBASE == 'function') {
					obj = InitOBASE(obj);                   //加载 病人基本信息
					arrTabItems = arrTabItems.concat([obj.OBASE_ViewPort]);
				}
				break;
			case "OOPR" :
				if (typeof InitOOPR == 'function') {
					obj = InitOOPR(obj);                    //加载 手术相关
					arrTabItems = arrTabItems.concat([obj.OOPR_ViewPort]);
				}
				break;
			case "ADIAG" :
				if (typeof InitADIAG == 'function') {
					obj = InitADIAG(obj);                   //加载 基础疾病
					arrTabItems = arrTabItems.concat([obj.ADIAG_ViewPort]);
				}
				break;
			case "ALAB" :
				if (typeof InitALAB == 'function') {
					obj = InitALAB(obj);                   //加载 病原菌检验
					arrTabItems = arrTabItems.concat([obj.ALAB_ViewPort]);
				}
				break;
			case "AANTI" :
				if (typeof InitAANTI == 'function') {
					obj = InitAANTI(obj);                  //加载 抗菌药物
					arrTabItems = arrTabItems.concat([obj.AANTI_ViewPort]);
				}
				break;
			default :
				break;
		}
	}
	
	//功能按钮定义(上报,审核,删除,退回,导出,打印)
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,width: 80
		,text : '<b><big>保存</big></b>'
		,listeners : {
			'click' :  function(){
				if (obj.SaveReport('1')) {
					ExtTool.alert("提示", "保存成功!");
					ParrefWindowRefresh_Handler();
					//if (obj.CurrReport.RowID == '') {
					//	var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportID="+obj.CurrReport.RowID+"&AdminPower="+AdminPower+"&2=3";
					//	location.href=lnk;
					//} else {
						obj.InitReport();
					//}
				}
			}
		}
	});
	
	obj.btnSubmit = new Ext.Button({
		id : 'btnSubmit'
		,iconCls : 'icon-save'
		,width: 80
		,text : '<b><big>提交</big></b>'
		,listeners : {
			'click' :  function(){
				if (obj.SaveReport('2')) {
					ExtTool.alert("提示", "提交成功!");
					ParrefWindowRefresh_Handler();
					//if (obj.CurrReport.RowID == '') {
					//	var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportID="+obj.CurrReport.RowID+"&AdminPower="+AdminPower+"&2=3";
					//	location.href=lnk;
					//} else {
						//add cpj 2014-12-20 修改tdbug 提交后，‘填报日期’不显示
						obj.CurrReport = obj.GetReport(obj.CurrReport.RowID);
						obj.InitReport();
						var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000019",obj.CurrReport.RowID,"1",obj.CurrReport.EpisodeID);
					
						var result=ExtTool.RunServerMethod("DHCMed.NINFService.BC.CasesSrv","IsHandleByReportID",obj.CurrReport.RowID);
						var Flag = result.split('^')[0];
						var HandleID=result.split('^')[1];
						if (Flag==1) {
							var Hisret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000041",HandleID,"4",obj.CurrReport.EpisodeID);		
						}
					//}
				}
			}
		}
	});
	
	obj.btnCheck = new Ext.Button({
		id : 'btnCheck'
		,iconCls : 'icon-check'
		,width: 80
		,text : '<b><big>审核</big></b>'
		,listeners : {
			'click' :  function(){
				if (obj.SaveRepStatus('3','')) {
					
					var objConfig=ExtTool.StaticServerObject("DHCMed.SSService.ConfigSrv");
					var IsChecked=objConfig.GetValueByKeyHospN("DHCMedNINFReportCheck","")
					if(IsChecked==1){
						var objFrmEdit = new InitwinEdit(obj);
						objFrmEdit.winEdit.show();
					}else{
						ExtTool.alert("提示", "审核成功!");
						ParrefWindowRefresh_Handler();
					}
					obj.InitReport();
					var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000019",obj.CurrReport.RowID,"2",obj.CurrReport.EpisodeID);
				}
			}
		}
	});
	
	obj.btnUpdoCheck = new Ext.Button({
		id : 'btnUpdoCheck'
		,iconCls : 'icon-delete'
		,width: 80
		,text : '<b><big>取消审核</big></b>'
		,listeners : {
			'click' :  function(){
				ExtTool.prompt("取消审核", "请输入取消审核原因!", function(btn, txt) {
					if (btn == 'ok') {
						//Add By YJF 2014-12-20 FixBug：1979 取消审核需要填写取消审核原因，否则无法取消审核成功
						if(txt == "")
						{
							ExtTool.alert("提示", "请输入取消审核原因!");
							return;
						}
						if (obj.SaveRepStatus('4',txt)) {
							ExtTool.alert("提示", "取消审核成功!");
							ParrefWindowRefresh_Handler();
							obj.InitReport();
							var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000019",obj.CurrReport.RowID,"5",obj.CurrReport.EpisodeID);
						}
					}
				});
			}
		}
	});
	
	obj.btnIsCheck = new Ext.Button({
		id : 'btnIsCheck'
		,iconCls : 'icon-save'
		,width: 80
		,text : '<b><big>评价信息</big></b>'
		,listeners : {
			'click' :  function(){
				var objFrmEdit = new InitwinEdit(obj);
				objFrmEdit.winEdit.show();
			}
		}
	});
	
	obj.btnReturn = new Ext.Button({
		id : 'btnReturn'
		,iconCls : 'icon-delete'
		,width: 80
		,text : '<b><big>退回</big></b>'
		,listeners : {
			'click' :  function(){
				ExtTool.prompt("退回", "请输入退回原因!", function(btn, txt) {
					if (btn == 'ok') {
						//Add By LiYang 2014-07-04 FixBug：1979 医院感染管理-全院综合性监测-感染报告查询-不填写退回原因，感染报告退回成功
						if(txt == "")
						{
							ExtTool.alert("提示", "请输入退回原因!");
							return;
						}
						if (obj.SaveRepStatus('5',txt)) {
							ExtTool.alert("提示", "退回成功!");
							ParrefWindowRefresh_Handler();
							obj.InitReport();
							var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000019",obj.CurrReport.RowID,"3",obj.CurrReport.EpisodeID);
						}
					}
				});
			}
		}
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width: 80
		,text : '<b><big>删除</big></b>'
		,listeners : {
			'click' :  function(){
				ExtTool.prompt("删除", "请输入删除原因!", function(btn, txt) {
					if (btn == 'ok') {
						//Add By YJF 2014-12-20 FixBug：1979 医院感染管理-全院综合性监测-感染报告查询-不填写删除原因，感染报告删除成功
						if(txt == "")
						{
							ExtTool.alert("提示", "请输入删除原因!");
							return;
						}
						if (obj.SaveRepStatus('0',txt)) {
							ExtTool.alert("提示", "删除成功!");
							ParrefWindowRefresh_Handler();
							obj.InitReport();
						}
				 			var ret = ExtTool.RunServerMethod("DHCMed.SSIO.FromEnsSrv","DHCHisInterface","S00000019",obj.CurrReport.RowID,"4",obj.CurrReport.EpisodeID);
					}
				});
			}
		}
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width: 80
		,text : '<b><big>导出</big></b>'
		,listeners : {
			'click' :  function(){
				obj.ExportReport(obj.CurrReport.RowID);
			}
		}
	});
	
	//界面整体布局
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort',
		layout : 'border',
		items : [
			{
				region : 'north',
				layout : 'form',
				frame : true,
				html : '<table border="0" width="100%" height="100%"><tr><td id="Title" align="center" >' + RepTitle + '</td></tr></table>'
			},{
				region : 'center',
				layout : 'anchor',
				autoScroll : true,
				items : arrTabItems,
				buttonAlign : 'center',
				buttons : [obj.btnSubmit,obj.btnCheck,obj.btnIsCheck ,obj.btnUpdoCheck,obj.btnReturn,obj.btnDelete,obj.btnExport]
			}
		]
	});
	
	obj.InitReport();
	
	return obj;
}