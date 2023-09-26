
function InitViewPort()
{
	var obj = new Object();
	
	if (typeof InitReportEvent == 'function') obj = InitReportEvent(obj);     //��ʼ�������¼�
	if (typeof InitReportWord == 'function') obj = InitReportWord(obj);       //��ʼ�������ӡ
	
	//��ʼ��������Ϣ��������Ϣ��������Ϣ
	obj.CurrReport = obj.GetReport(ReportID);
	if (!obj.CurrReport) return;
	obj.CurrPaadm  = obj.ClsBasePatientAdm.GetObjById(obj.CurrReport.EpisodeID);
	if (!obj.CurrPaadm) return;
	obj.CurrPatient = obj.ClsBasePatient.GetObjById(obj.CurrPaadm.PatientID);
	if (!obj.CurrPatient) return;
	
	//��ʼ���������
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
	
	//��ʼ������Ȩ��
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
	
	//��ʼ������ģ��
	var arrTabItems = [];
	var arrModule = ModuleList.split("^");
	for (var indModule = 0; indModule < arrModule.length; indModule++) {
		var strModule = arrModule[indModule];
		switch (strModule) {
			case "NOTE" :
				if (typeof InitNOTE == 'function') {
					obj = InitNOTE(obj);                      //���� ����˵��
					arrTabItems = arrTabItems.concat([obj.NOTE_ViewPort]);
				}
				break;
			case "BASE" :
				if (typeof InitBASE == 'function') {
					obj = InitBASE(obj);                      //���� ���˻�����Ϣ
					arrTabItems = arrTabItems.concat([obj.BASE_ViewPort]);
				}
				break;
			case "INFPOS" :
				if (typeof InitINFPOS == 'function') {
					obj = InitINFPOS(obj);                    //���� ��Ⱦ��λ
					arrTabItems = arrTabItems.concat([obj.INFPOS_ViewPort]);
				}
				break;
			case "NBINF" :
				if (typeof InitNBINF == 'function') {
					obj = InitNBINF(obj);                    //���� ��������Ⱦ��Ϣ
					arrTabItems = arrTabItems.concat([obj.NBINF_ViewPort]);
				}
				break;
			case "OPR" :
				if (typeof InitOPR == 'function') {
					obj = InitOPR(obj);                       //���� �������
					arrTabItems = arrTabItems.concat([obj.OPR_ViewPort]);
				}
				break;
			case "LAB" :
				if (typeof InitLAB == 'function') {
					obj = InitLAB(obj);                       //���� ��ԭ������
					arrTabItems = arrTabItems.concat([obj.LAB_ViewPort]);
				}
				break;
			case "ANTI" :
				if (typeof InitANTI == 'function') {
					obj = InitANTI(obj);                      //���� ����ҩ��
					arrTabItems = arrTabItems.concat([obj.ANTI_ViewPort]);
				}
				break;
			case "IBASE" :
				if (typeof InitIBASE == 'function') {
					obj = InitIBASE(obj);                     //���� ���˻�����Ϣ
					arrTabItems = arrTabItems.concat([obj.IBASE_ViewPort]);
				}
				break;
			case "IDIAG" :
				if (typeof InitIDIAG == 'function') {
					obj = InitIDIAG(obj);                     //���� ת��ICU���
					arrTabItems = arrTabItems.concat([obj.IDIAG_ViewPort]);
				}
				break;
			case "IPICC" :
				if (typeof InitIPICC == 'function') {
					obj = InitIPICC(obj);                     //���� ICU���뵼��
					arrTabItems = arrTabItems.concat([obj.IPICC_ViewPort]);
				}
				break;
			case "IVAP" :
				if (typeof InitIVAP == 'function') {
					obj = InitIVAP(obj);                     //���� ICU������
					arrTabItems = arrTabItems.concat([obj.IVAP_ViewPort]);
				}
				break;
			case "IUC" :
				if (typeof InitIUC == 'function') {
					obj = InitIUC(obj);                      //���� ICU�����
					arrTabItems = arrTabItems.concat([obj.IUC_ViewPort]);
				}
				break;
			case "NBASE" :
				if (typeof InitNBASE == 'function') {
					obj = InitNBASE(obj);                   //���� ���˻�����Ϣ
					arrTabItems = arrTabItems.concat([obj.NBASE_ViewPort]);
				}
				break;
			case "NPICC" :
				if (typeof InitNPICC == 'function') {
					obj = InitNPICC(obj);                   //���� NICU���뵼��
					arrTabItems = arrTabItems.concat([obj.NPICC_ViewPort]);
				}
				break;
			case "NVNT" :
				if (typeof InitNVNT == 'function') {
					obj = InitNVNT(obj);                    //���� NICU���ܲ��
					arrTabItems = arrTabItems.concat([obj.NVNT_ViewPort]);
				}
				break;
			case "NUC" :
				if (typeof InitNUC == 'function') {
					obj = InitNUC(obj);                     //���� NICU�꾲��
					arrTabItems = arrTabItems.concat([obj.NUC_ViewPort]);
				}
				break;
			case "OBASE" :
				if (typeof InitOBASE == 'function') {
					obj = InitOBASE(obj);                   //���� ���˻�����Ϣ
					arrTabItems = arrTabItems.concat([obj.OBASE_ViewPort]);
				}
				break;
			case "OOPR" :
				if (typeof InitOOPR == 'function') {
					obj = InitOOPR(obj);                    //���� �������
					arrTabItems = arrTabItems.concat([obj.OOPR_ViewPort]);
				}
				break;
			case "ADIAG" :
				if (typeof InitADIAG == 'function') {
					obj = InitADIAG(obj);                   //���� ��������
					arrTabItems = arrTabItems.concat([obj.ADIAG_ViewPort]);
				}
				break;
			case "ALAB" :
				if (typeof InitALAB == 'function') {
					obj = InitALAB(obj);                   //���� ��ԭ������
					arrTabItems = arrTabItems.concat([obj.ALAB_ViewPort]);
				}
				break;
			case "AANTI" :
				if (typeof InitAANTI == 'function') {
					obj = InitAANTI(obj);                  //���� ����ҩ��
					arrTabItems = arrTabItems.concat([obj.AANTI_ViewPort]);
				}
				break;
			default :
				break;
		}
	}
	
	//���ܰ�ť����(�ϱ�,���,ɾ��,�˻�,����,��ӡ)
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,width: 80
		,text : '<b><big>����</big></b>'
		,listeners : {
			'click' :  function(){
				if (obj.SaveReport('1')) {
					ExtTool.alert("��ʾ", "����ɹ�!");
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
		,text : '<b><big>�ύ</big></b>'
		,listeners : {
			'click' :  function(){
				if (obj.SaveReport('2')) {
					ExtTool.alert("��ʾ", "�ύ�ɹ�!");
					ParrefWindowRefresh_Handler();
					//if (obj.CurrReport.RowID == '') {
					//	var lnk="dhcmed.ninf.rep.infreport.csp?1=1&ReportID="+obj.CurrReport.RowID+"&AdminPower="+AdminPower+"&2=3";
					//	location.href=lnk;
					//} else {
						//add cpj 2014-12-20 �޸�tdbug �ύ�󣬡�����ڡ�����ʾ
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
		,text : '<b><big>���</big></b>'
		,listeners : {
			'click' :  function(){
				if (obj.SaveRepStatus('3','')) {
					
					var objConfig=ExtTool.StaticServerObject("DHCMed.SSService.ConfigSrv");
					var IsChecked=objConfig.GetValueByKeyHospN("DHCMedNINFReportCheck","")
					if(IsChecked==1){
						var objFrmEdit = new InitwinEdit(obj);
						objFrmEdit.winEdit.show();
					}else{
						ExtTool.alert("��ʾ", "��˳ɹ�!");
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
		,text : '<b><big>ȡ�����</big></b>'
		,listeners : {
			'click' :  function(){
				ExtTool.prompt("ȡ�����", "������ȡ�����ԭ��!", function(btn, txt) {
					if (btn == 'ok') {
						//Add By YJF 2014-12-20 FixBug��1979 ȡ�������Ҫ��дȡ�����ԭ�򣬷����޷�ȡ����˳ɹ�
						if(txt == "")
						{
							ExtTool.alert("��ʾ", "������ȡ�����ԭ��!");
							return;
						}
						if (obj.SaveRepStatus('4',txt)) {
							ExtTool.alert("��ʾ", "ȡ����˳ɹ�!");
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
		,text : '<b><big>������Ϣ</big></b>'
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
		,text : '<b><big>�˻�</big></b>'
		,listeners : {
			'click' :  function(){
				ExtTool.prompt("�˻�", "�������˻�ԭ��!", function(btn, txt) {
					if (btn == 'ok') {
						//Add By LiYang 2014-07-04 FixBug��1979 ҽԺ��Ⱦ����-ȫԺ�ۺ��Լ��-��Ⱦ�����ѯ-����д�˻�ԭ�򣬸�Ⱦ�����˻سɹ�
						if(txt == "")
						{
							ExtTool.alert("��ʾ", "�������˻�ԭ��!");
							return;
						}
						if (obj.SaveRepStatus('5',txt)) {
							ExtTool.alert("��ʾ", "�˻سɹ�!");
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
		,text : '<b><big>ɾ��</big></b>'
		,listeners : {
			'click' :  function(){
				ExtTool.prompt("ɾ��", "������ɾ��ԭ��!", function(btn, txt) {
					if (btn == 'ok') {
						//Add By YJF 2014-12-20 FixBug��1979 ҽԺ��Ⱦ����-ȫԺ�ۺ��Լ��-��Ⱦ�����ѯ-����дɾ��ԭ�򣬸�Ⱦ����ɾ���ɹ�
						if(txt == "")
						{
							ExtTool.alert("��ʾ", "������ɾ��ԭ��!");
							return;
						}
						if (obj.SaveRepStatus('0',txt)) {
							ExtTool.alert("��ʾ", "ɾ���ɹ�!");
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
		,text : '<b><big>����</big></b>'
		,listeners : {
			'click' :  function(){
				obj.ExportReport(obj.CurrReport.RowID);
			}
		}
	});
	
	//�������岼��
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