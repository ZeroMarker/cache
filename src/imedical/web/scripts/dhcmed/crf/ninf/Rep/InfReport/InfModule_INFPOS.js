
function InitINFPOS(obj)
{
	//�׸�����
	obj.INFPOS_cbgInfFactors = Common_CheckboxGroupToDic("INFPOS_cbgInfFactors","<span style='color:red'><b>�׸�����</b></span>","NINFInfInfFactors",6);
	//�ֺ��Բ���
	obj.INFPOS_cbgInvasiveOper = Common_CheckboxGroupToDic("INFPOS_cbgInvasiveOper","<span style='color:red'><b>�ֺ��Բ���</b></span>","NINFInfInvasiveOper",6);
	
	//��Ⱦ��Ϣ �༭��
	obj.INFPOS_gridInfPos_RowEditer_objRec = '';
	obj.INFPOS_gridInfPos_RowEditer = function(objRec) {
		obj.INFPOS_gridInfPos_RowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('INFPOS_gridInfPos_RowEditer');
		if (!winGridRowEditer)
		{
			obj.INFPOS_gridInfPos_RowEditer_cboInfPos = Common_ComboToInfPos("INFPOS_gridInfPos_RowEditer_cboInfPos","<span style='color:red'><b>��Ⱦ��λ</b></span>","INFPOS_gridInfPos_RowEditer_cboInfDiag","","95%");
			obj.INFPOS_gridInfPos_RowEditer_cboInfDate = Common_DateFieldToDate("INFPOS_gridInfPos_RowEditer_cboInfDate","<span style='color:red'><b>��Ⱦ����</b></span>","95%");
			obj.INFPOS_gridInfPos_RowEditer_cboInfEndDate = Common_DateFieldToDate("INFPOS_gridInfPos_RowEditer_cboInfEndDate","��������","95%");  //Modified By LiYang 2013-05-18 ���Ӹ�Ⱦ����������
			obj.INFPOS_gridInfPos_RowEditer_cboInfEndResult = Common_ComboToDic("INFPOS_gridInfPos_RowEditer_cboInfEndResult","��Ⱦת��","NINFInfEndResult","","95%"); //Modified By LiYang 2013-05-18 ���Ӹ�Ⱦת����
			obj.INFPOS_gridInfPos_RowEditer_cboInfDiag = Common_ComboToInfDia("INFPOS_gridInfPos_RowEditer_cboInfDiag","<span style='color:red'><b>��Ⱦ���</b></span>","INFPOS_gridInfPos_RowEditer_cboInfPos","95%");
			obj.INFPOS_gridInfPos_RowEditer_cboInfDiagCat = Common_ComboToInfDiagCat("INFPOS_gridInfPos_RowEditer_cboInfDiagCat","<span style='color:red'><b>��Ϸ���</b></span>","INFPOS_gridInfPos_RowEditer_cboInfDiag","95%");
			obj.INFPOS_gridInfPos_RowEditer_txtDiagnosisBasis = Common_TextAreaToDC("INFPOS_gridInfPos_RowEditer_txtDiagnosisBasis","�������",70,"95%","INFPOS_gridInfPos_RowEditer_cboInfPos","INFPOS_gridInfPos_RowEditer_cboInfDiag","DiagnosisBasis");
			obj.INFPOS_gridInfPos_RowEditer_txtDiseaseCourse = Common_TextArea("INFPOS_gridInfPos_RowEditer_txtDiseaseCourse","��Ⱦ�Լ�������",65,500,"95%");
			obj.INFPOS_gridInfPos_RowEditer_gridInfOperStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
			obj.INFPOS_gridInfPos_RowEditer_gridInfOperStore = new Ext.data.Store({
				proxy : obj.INFPOS_gridInfPos_RowEditer_gridInfOperStoreProxy,
				reader : new Ext.data.JsonReader({
					root : 'record',
					totalProperty : 'total',
					idProperty : 'IDRowID'
				}, [
					{name : 'IsChecked',mapping : 'IsChecked'}
					,{name : 'IDRowID',mapping : 'IDRowID'}
					,{name : 'IDCode',mapping : 'IDCode'}
					,{name : 'IDDesc',mapping : 'IDDesc'}
				])
			});
			obj.INFPOS_gridInfPos_RowEditer_gridInfOper = new Ext.grid.EditorGridPanel({
				id : 'INFPOS_gridInfPos_RowEditer_gridInfOper',
				store : obj.INFPOS_gridInfPos_RowEditer_gridInfOperStore,
				selModel : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
				columnLines : true,
				region : 'center',
				loadMask : true,
				height : 300,
				//tbar : ['��˴θ�Ⱦֱ����ص��ֺ��Բ���'],
				columns : [
					{header : 'ѡ��',width : 35,dataIndex : 'IsChecked',sortable : false,menuDisabled : true,align : 'center',
						renderer : function(v, m, rd, r, c, s) {
							var IsChecked = rd.get("IsChecked");
							if (IsChecked == '1') {
								return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
							} else {
								return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
							}
						}
					},
					{header : '��˴θ�Ⱦֱ����ص�<br>�ֺ��Բ���',width : 150,dataIndex : 'IDDesc',sortable : false,menuDisabled : true,align : 'left'}
				],
				listeners : {
					'rowclick' : function() {
						var objRecOper = obj.INFPOS_gridInfPos_RowEditer_gridInfOper.getSelectionModel().getSelected();
						if (objRecOper.get("IsChecked") == '1') {
							var newValue = '0';
						} else {
							var newValue = '1';
						}
						objRecOper.set("IsChecked", newValue);
					}
				},
				viewConfig : {
					forceFit : true
				}
			});
			obj.INFPOS_gridInfPos_RowEditer_gridInfOperStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.NINFService.Dic.MapPosOperDic';
				param.QueryName = 'QryOperByInfPos1';
				param.Arg1 = Common_GetValue('INFPOS_gridInfPos_RowEditer_cboInfPos');
				param.Arg2 = obj.strInfPosOpers;
				param.ArgCnt = 2;
			});
			obj.INFPOS_gridInfPos_RowEditer_cboInfPos.on('select',function(){
				var objCmp = Ext.getCmp('INFPOS_gridInfPos_RowEditer_gridInfOper');
				if (objCmp){
					objCmp.getStore().removeAll();
					objCmp.getStore().load({});
				}
				var objCmp = Ext.getCmp('INFPOS_gridInfPos_RowEditer_cboInfDiagCat');
				if (objCmp){
					objCmp.setValue('');
					objCmp.setRawValue('');
					var objStore = objCmp.getStore();
					objStore.removeAll();
				}
			});
			obj.INFPOS_gridInfPos_RowEditer_cboInfDiag.on('select',function(){
				var objCmp = Ext.getCmp('INFPOS_gridInfPos_RowEditer_cboInfDiagCat');
				if (objCmp){
					objCmp.setValue('');
					objCmp.setRawValue('');
					var objStore = objCmp.getStore();
					objStore.removeAll();
					objStore.load({
						callback : function() {
							if (objStore.getTotalCount()>0) {
								document.all['cboInfDiagCatPn'].style.display = 'block';
							} else {
								document.all['cboInfDiagCatPn'].style.display = 'none';
							}
						}
						,scope : objStore
						,add : false
					});
				}
			});
			
			winGridRowEditer = new Ext.Window({
				id : 'INFPOS_gridInfPos_RowEditer',
				height : 400,
				closeAction: 'hide',
				width : 600,
				modal : true,
				title : '��Ⱦ��Ϣ-�༭',
				layout : 'border',
				frame : true,
				items: [
					{
						region: 'center',
						layout : 'form',
						frame : true,
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.INFPOS_gridInfPos_RowEditer_cboInfDate
							,obj.INFPOS_gridInfPos_RowEditer_cboInfPos
							,obj.INFPOS_gridInfPos_RowEditer_cboInfDiag
							,{
								id : 'cboInfDiagCatPn',
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [
									obj.INFPOS_gridInfPos_RowEditer_cboInfDiagCat
								]
							}
							//,obj.INFPOS_gridInfPos_RowEditer_cboInfEndDate
							//,obj.INFPOS_gridInfPos_RowEditer_cboInfEndResult
							,obj.INFPOS_gridInfPos_RowEditer_txtDiagnosisBasis
							,obj.INFPOS_gridInfPos_RowEditer_txtDiseaseCourse
						]
					},{
						region: 'east',
						layout : 'fit',
						width : 240,
						frame : true,
						items : [obj.INFPOS_gridInfPos_RowEditer_gridInfOper]
					}
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "INFPOS_gridInfPos_RowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>ȷ��",
						listeners : {
							'click' : function(){
								var InfPosID = Common_GetValue('INFPOS_gridInfPos_RowEditer_cboInfPos');
								var InfPosDesc = Common_GetText('INFPOS_gridInfPos_RowEditer_cboInfPos');
								var InfDate = Common_GetText('INFPOS_gridInfPos_RowEditer_cboInfDate');
								var InfEndDate = '' //Common_GetText('INFPOS_gridInfPos_RowEditer_cboInfEndDate'); //Add By LiYang 2013-05-18 ����ҽԺ��Ⱦ��������
								var InfEndResult = Common_GetValue('INFPOS_gridInfPos_RowEditer_cboInfEndResult'); //Add By LiYang 2013-05-18 ����ҽԺ��Ⱦת��(ID)
								var InfEndResultDesc = Common_GetText('INFPOS_gridInfPos_RowEditer_cboInfEndResult'); //Add By LiYang 2013-05-18 ����ҽԺ��Ⱦת��(Desc)
								var InfDiagnosID = Common_GetValue('INFPOS_gridInfPos_RowEditer_cboInfDiag');
								var InfDiagnosDesc = Common_GetText('INFPOS_gridInfPos_RowEditer_cboInfDiag');
								var InfDiagCatID = Common_GetValue('INFPOS_gridInfPos_RowEditer_cboInfDiagCat');
								var InfDiagCatDesc = Common_GetText('INFPOS_gridInfPos_RowEditer_cboInfDiagCat');
								var InfPosOprValues = "";
								var InfPosOprDescs = "";
								var objGridInfOper = Ext.getCmp('INFPOS_gridInfPos_RowEditer_gridInfOper');
								var objStore = objGridInfOper.getStore();
								for (var ind = 0; ind < objStore.getCount(); ind++) {
									var tmpRec = objStore.getAt(ind);
									if (tmpRec.get("IsChecked") == 1) {
										InfPosOprValues = InfPosOprValues + CHR_1 + tmpRec.get("IDRowID") + CHR_2 + CHR_2 + CHR_2 + CHR_2;
										if (InfPosOprDescs != "") {
											InfPosOprDescs = InfPosOprDescs + "," + tmpRec.get("IDDesc");
										} else {
											InfPosOprDescs = tmpRec.get("IDDesc");
										}
									}
								}
								//�������+��Ⱦ�Լ�������
								var DiagnosisBasis = Common_GetValue('INFPOS_gridInfPos_RowEditer_txtDiagnosisBasis');
								var DiseaseCourse = Common_GetValue('INFPOS_gridInfPos_RowEditer_txtDiseaseCourse');
								
								var errInfo = '';
								if ((InfPosID == '')||(InfPosDesc == '')) {
									errInfo = errInfo + '��Ⱦ��λΪ��!<br>'
								}
								if ((InfDiagnosID == '')||(InfDiagnosDesc == '')) {
									errInfo = errInfo + '��Ⱦ���Ϊ��!<br>'
								}
								if ((InfDiagCatID == '')||(InfDiagCatDesc == '')) {
									var cboInfDiagCat = Ext.getCmp('INFPOS_gridInfPos_RowEditer_cboInfDiagCat');
									if (cboInfDiagCat){
										if (cboInfDiagCat.getStore().getTotalCount()>0){
											errInfo = errInfo + '��Ⱦ��Ϸ���Ϊ��!<br>'
										}
									}
								}
								if (InfDate == '') {
									errInfo = errInfo + '��Ⱦ����Ϊ��!<br>'
								} else {
									var today = new Date();
									var CurrDate = today.getYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
									var flg = Common_CompareDate(InfDate,CurrDate);
									if (!flg) errInfo = errInfo + '��Ⱦ���ڴ��ڵ�ǰ����!<br>'
									
									var objPaadm = obj.CurrPaadm;
									var flg = Common_CompareDate(objPaadm.AdmitDate,InfDate);
									if (!flg) errInfo = errInfo + '��Ⱦ����С����Ժ����!<br>'
									
									if (objPaadm.DisDate) {
										var flg = Common_CompareDate(InfDate,objPaadm.DisDate);
										if (!flg) errInfo = errInfo + '��Ⱦ���ڴ��ڳ�Ժ����!<br>'
									}
								}
								//Add By LiYang 2013-05-18 У���Ⱦ�������ڣ�Ҫ���ڸ�Ⱦ����
								if (InfEndDate != '')
								{
									var flg = Common_CompareDate(InfDate,InfEndDate);
									if (!flg) errInfo = errInfo + '��Ⱦ���ڴ��ڸ�Ⱦ��������!<br>'
									var today = new Date();
									var CurrDate = today.getYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
									var flg = Common_CompareDate(InfEndDate,CurrDate);
									if (!flg) errInfo = errInfo + '��Ⱦ�������ڴ��ڵ�ǰ����!<br>'									
								}
								if (InfEndResult != '')
								{
									var strText = Common_GetText('INFPOS_gridInfPos_RowEditer_cboInfEndResult');
									if((objPaadm.DisDate == "") && ((strText == '��') || (strText == 'Я��')))
									{
										errInfo = errInfo + '��Ⱦת����������񻯡�����Я����ѡ��ֻ���ڻ��߳�Ժ�����ѡ��<br>'
									}									
								}
								if ((InfPosOprValues == '')||(InfPosOprDescs == '')) {
									//errInfo = errInfo + '���Ⱦ��ص��ֺ��Բ���Ϊ��!<br>'
								}
								if (errInfo != '') {
									ExtTool.alert("��ʾ",errInfo);
									return;
								}
								
								var objRec = obj.INFPOS_gridInfPos_RowEditer_objRec;
								var objGrid = Ext.getCmp('INFPOS_gridInfPos');
								if (objGrid) {
									var objStore = objGrid.getStore();
									
									//�ж��Ƿ������ͬ��Ⱦ��λ,��ͬ��Ⱦ��������
									var IsBoolean = false;
									for (var ind = 0; ind < objStore.getCount(); ind++) {
										var tmpRec = objStore.getAt(ind);
										if (objRec) {
											if (tmpRec.id == objRec.id) continue;
										}
										if ((InfPosDesc == tmpRec.get('InfPosDesc'))&&(InfDate == tmpRec.get('InfDate'))) {
											IsBoolean = true;
										}
									}
									if (IsBoolean) {
										ExtTool.alert("��ʾ","������ͬ��Ⱦ��λ,��ͬ��Ⱦ��������!");
										return;
									}
									
									if (objRec) {
										objRec.set('InfPosID',InfPosID);
										objRec.set('InfPosDesc',InfPosDesc);
										objRec.set('InfDate',InfDate);
										objRec.set('InfEndDate', InfEndDate); //Add By LiYang 2013-05-18 �����Ⱦ��������
										objRec.set('InfDiagnosID',InfDiagnosID);
										objRec.set('InfDiagnosDesc',InfDiagnosDesc);
										objRec.set('InfDiagCatID',InfDiagCatID);
										objRec.set('InfDiagCatDesc',InfDiagCatDesc);
										objRec.set('InfPosOprValues',InfPosOprValues);
										objRec.set('InfPosOprDescs',InfPosOprDescs);
										objRec.set('InfEndResultID', InfEndResult); //Add By LiYang 2013-05-19 ҽԺ��Ⱦת��ID
										objRec.set('InfEndResultDesc', InfEndResultDesc);	//Add By LiYang 2013-05-19 ҽԺ��Ⱦת��Desc
										objRec.set('DiagnosisBasis', DiagnosisBasis);
										objRec.set('DiseaseCourse', DiseaseCourse);
										objRec.commit();
									} else {
										var RecordType = objStore.recordType;
										var RecordData = new RecordType({
											RepID : ''
											,SubID : ''
											,DataSource : ''
											,InfPosID : InfPosID
											,InfPosDesc : InfPosDesc
											,InfDate : InfDate
											,InfEndDate : InfEndDate //Add By LiYang 2013-05-18 �����Ⱦ��������
											,InfDiagnosID : InfDiagnosID
											,InfDiagnosDesc : InfDiagnosDesc
											,InfDiagCatID : InfDiagCatID
											,InfDiagCatDesc : InfDiagCatDesc
											,InfPosOprValues : InfPosOprValues
											,InfPosOprDescs : InfPosOprDescs
											,InfEndResultID : InfEndResult //Add By LiYang 2013-05-19 ҽԺ��Ⱦת��ID
											,InfEndResultDesc : InfEndResultDesc //Add By LiYang 2013-05-19 ҽԺ��Ⱦת��Desc
											,DiagnosisBasis : DiagnosisBasis
											,DiseaseCourse : DiseaseCourse
										});
										objStore.insert(objStore.getCount(), RecordData);
										objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
									}
								}
								
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "INFPOS_gridInfPos_RowEditer_btnCancel",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/cancel.png'>ȡ��",
						listeners : {
							'click' : function(){
								winGridRowEditer.hide();
							}
						}
					})
				],
				listeners :{
					'beforeshow' : function(){
						var objRec = obj.INFPOS_gridInfPos_RowEditer_objRec;
						if (objRec) {
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfPos',objRec.get('InfPosID'),objRec.get('InfPosDesc'));
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfDate',objRec.get('InfDate'));
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfEndDate',objRec.get('InfEndDate')); //Add By LiYang 2013-05-18 ��ʾ��Ⱦ��������
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfEndResult',objRec.get('InfEndResultID'), objRec.get('InfEndResultDesc')); //Add By LiYang 2013-05-18 ��ʾ��Ⱦת��
							Common_SetDisabled("INFPOS_gridInfPos_RowEditer_cboInfPos",(objRec.get('DataSource') != ''));
							Common_SetDisabled("INFPOS_gridInfPos_RowEditer_cboInfDate",(objRec.get('DataSource') != ''));
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfDiag',objRec.get('InfDiagnosID'),objRec.get('InfDiagnosDesc'));
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfDiagCat',objRec.get('InfDiagCatID'),objRec.get('InfDiagCatDesc'));
							Common_SetValue('INFPOS_gridInfPos_RowEditer_txtDiagnosisBasis',objRec.get('DiagnosisBasis'));
							Common_SetValue('INFPOS_gridInfPos_RowEditer_txtDiseaseCourse',objRec.get('DiseaseCourse'));
							obj.strInfPosOpers = "";
							var InfPosOprValues = objRec.get('InfPosOprValues');
							InfPosOprValues = InfPosOprValues.replace(/<\$C2>/gi,CHR_2);
							var arrInfPosOprValue = InfPosOprValues.split(CHR_1);
							for (var ind = 0; ind < arrInfPosOprValue.length; ind++) {
								var strRec = arrInfPosOprValue[ind];
								if (!strRec) continue;
								var arrField = strRec.split(CHR_2);
								if (!arrField[0]) continue;
								obj.strInfPosOpers = obj.strInfPosOpers + "," + arrField[0];
							}
							obj.INFPOS_gridInfPos_RowEditer_gridInfOperStore.load({});
						} else {
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfPos','','');
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfDate','');
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfEndDate',''); //Add By LiYang 2013-05-18 ��ʼ����Ⱦ��������
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfEndResult',''); //Add By LiYang 2013-05-18 ��ʼ����Ⱦת��
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfDiag','','');
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cboInfDiagCat','','');
							Common_SetValue('INFPOS_gridInfPos_RowEditer_cbgInvasiveOper','');
							Common_SetValue('INFPOS_gridInfPos_RowEditer_txtDiagnosisBasis','');
							Common_SetValue('INFPOS_gridInfPos_RowEditer_txtDiseaseCourse','');
							obj.strInfPosOpers = obj.tmpInfPosOpers;
							obj.INFPOS_gridInfPos_RowEditer_gridInfOperStore.load({});
						}
						
						//�Ƿ����ظ�Ⱦ����ӷ���������
						document.all['cboInfDiagCatPn'].style.display = 'none';
						if (objRec){
							if (objRec.get('InfDiagCatID') != '') {
								document.all['cboInfDiagCatPn'].style.display = 'block';
							}
						}
					}
				}
			});
		}
		winGridRowEditer.show();
	}
	
	//��Ⱦ��Ϣ ��ʾ
	obj.INFPOS_gridInfPos_btnAdd = new Ext.Button({
		id : 'INFPOS_gridInfPos_btnAdd'
		,iconCls : 'icon-add'
		,width: 80
		,text : '����'
		,listeners : {
			'click' :  function(){
				obj.INFPOS_gridInfPos_RowEditer('');
			}
		}
	});
	obj.INFPOS_gridInfPos_btnDel = new Ext.Button({
		id : 'INFPOS_gridInfPos_btnDel'
		,iconCls : 'icon-delete'
		,width: 80
		,text : 'ɾ��'
		,listeners : {
			'click' :  function(){
			
				//Add By LiYang 2014-07-08 FixBug��1667 ҽԺ��Ⱦ����-��Ⱦ�������-��Ⱦ�����ѯ-������ĸ�Ⱦ��Ϣɾ���������ύ����ˣ����´򿪱���ʱ��Ⱦ��ϱ�ɾ��
				if(obj.CurrReport)
				{
					if(obj.CurrReport.ReportStatus){
						if((obj.CurrReport.ReportStatus.Code == "2")||
							(obj.CurrReport.ReportStatus.Code == "3")||
							(obj.CurrReport.ReportStatus.Code == "0"))
						{
							ExtTool.alert("������ʾ", "��" + obj.CurrReport.ReportStatus.Description + "��״̬�ı��治����ɾ����Ŀ��");
							return;
						}
					}
				}
			
			
				var objGrid = Ext.getCmp("INFPOS_gridInfPos");
				if (objGrid){
					var arrRec = objGrid.getSelectionModel().getSelections();
					if (arrRec.length>0){
						Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
							if(btn=="yes"){
								for (var indRec = 0; indRec < arrRec.length; indRec++){
									var objRec = arrRec[indRec];
									if (objRec.get('SubID')) {
										var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
										var flg = obj.ClsInfReportInfPosSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
										if (parseInt(flg) > 0) {
											objGrid.getStore().remove(objRec);
										} else {
											ExtTool.alert("������ʾ","ɾ����ϴ���!error=" + flg);
										}
									} else {
										objGrid.getStore().remove(objRec);
									}
								}
							}
						});
					} else {
						ExtTool.alert("��ʾ","��ѡ�����ݼ�¼,�ٵ��ɾ��!");
					}
				}
			}
		}
	});
	obj.INFPOS_gridInfPos_iniFun = function() {
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.InfReportInfPos';
							param.QueryName = 'QrySubRec';
							param.Arg1      = obj.CurrReport.RowID;
							param.Arg2      = '';
							param.ArgCnt    = 2;
						}
					}
				}),
				reader: new Ext.data.JsonReader(
					{
						root: 'record',
						totalProperty: 'total'
					},
					[
						{name: 'RepID', mapping: 'RepID'}
						,{name: 'SubID', mapping: 'SubID'}
						,{name: 'DataSource', mapping: 'DataSource'}
						,{name: 'InfPosID', mapping: 'InfPosID'}
						,{name: 'InfPosDesc', mapping: 'InfPosDesc'}
						,{name: 'InfDate', mapping: 'InfDate'}
						,{name: 'InfEndDate', mapping: 'InfEndDate'} //Add By LiYang 2013-05-18 ��ʾ��Ⱦ��������
						,{name: 'InfDiagnosID', mapping: 'InfDiagnosID'}
						,{name: 'InfDiagnosDesc', mapping: 'InfDiagnosDesc'}
						,{name: 'InfDiagCatID', mapping: 'InfDiagCatID'}
						,{name: 'InfDiagCatDesc', mapping: 'InfDiagCatDesc'}
						,{name: 'InfPosOprValues', mapping: 'InfPosOprValues'}
						,{name: 'InfPosOprDescs', mapping: 'InfPosOprDescs'}
						,{name: 'InfEndResultID', mapping: 'InfEndResultID'} //Add By LiYang 2013-05-18 ��ʾ��Ⱦת��
						,{name: 'InfEndResultDesc', mapping: 'InfEndResultDesc'}//Add By LiYang 2013-05-18 ��ʾ��Ⱦת������
						,{name: 'DiagnosisBasis', mapping: 'DiagnosisBasis'}  //add by zf 20130615 �������
						,{name: 'DiseaseCourse', mapping: 'DiseaseCourse'}  //add by zf 20130615 ��Ⱦ�Լ�������
					]
				)
			})
			,height : 180
			,columnLines : true
			,style:'overflow:auto;overflow-y:hidden'
			,loadMask : true
			,selModel : new Ext.grid.RowSelectionModel({
				singleSelect : true
			})
			,anchor : '100%'
			,columns: [
				new Ext.grid.RowNumberer()
				,{header: '��Ⱦ����', width: 80, dataIndex: 'InfDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��Ⱦ��λ', width: 80, dataIndex: 'InfPosDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��Ⱦ���', width: 100, dataIndex: 'InfDiagnosDesc', sortable: false, menuDisabled:true, align:'left',
					renderer : function(v, m, rd, r, c, s) {
						m.attr = 'style="white-space:normal;"';
						var str = rd.get('InfDiagnosDesc');
						var InfDiagCatDesc = rd.get('InfDiagCatDesc');
						if (InfDiagCatDesc != ''){
							str = str + '��' + InfDiagCatDesc + '��';
						}
						return str;
					}
				}
				//,{header: '��������', width: 80, dataIndex: 'InfEndDate', sortable: false, menuDisabled:true, align:'center' } //Add By LiYang 2013-05-18 ��ʾ��Ⱦ��������
				//,{header: '��Ⱦת��', width: 80, dataIndex: 'InfEndResultDesc', sortable: false, menuDisabled:true, align:'center' } //Add By LiYang 2013-05-18 ��ʾ��Ⱦת��
				,{header: '��˴θ�Ⱦֱ��<br>��ص��ֺ��Բ���', width: 120, dataIndex: 'InfPosOprDescs', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�������', width: 200, dataIndex: 'DiagnosisBasis', sortable: false, menuDisabled:true, align:'left',
					renderer : function(v, m, rd, r, c, s) {
						m.attr = 'style="white-space:normal;"';
						return v;
					}
				}
				,{header: '��Ⱦ��<br>��������', width: 200, dataIndex: 'DiseaseCourse', sortable: false, menuDisabled:true, align:'left',
					renderer : function(v, m, rd, r, c, s) {
						m.attr = 'style="white-space:normal;"';
						return v;
					}
				}
			],
			viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.INFPOS_gridInfPos = obj.INFPOS_gridInfPos_iniFun("INFPOS_gridInfPos");
	
	//��Ⱦ��� ���沼��
	obj.INFPOS_ViewPort = {
		//title : '��Ⱦ���',
		layout : 'fit',
		//frame : true,
		height : 500,
		anchor : '-20',
		tbar : ['<b>��Ⱦ���</b>'],
		items : [
			{
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'north',
						layout : 'form',
						height : 220,
						//frame : true,
						labelAlign : 'right',
						labelWidth : 60,
						items : [
							obj.INFPOS_cbgInfFactors,
							obj.INFPOS_cbgInvasiveOper
						]
					},{
						region: 'center',
						layout : 'border',
						items : [
							{
								region: 'center',
								layout : 'fit',
								buttonAlign : 'left',
								//frame : true,
								items : [obj.INFPOS_gridInfPos],
								bbar : [obj.INFPOS_gridInfPos_btnAdd,obj.INFPOS_gridInfPos_btnDel,'->','��']
							},{
								region: 'west',
								layout : 'fit',
								width : 68,
								html: '<table border="0" width="100%" height="30px"><tr><td align="center" >��Ⱦ��Ϣ:</td></tr></table>'
							}
						]
					}
				]
			}
		]
	}
	
	//��Ⱦ��� �����ʼ��
	obj.INFPOS_InitView = function(){
		obj.tmpInfPosOpers = "";
		
		//��ʼ��"�׸�����,�ֺ��Բ���"����Ԫ��ֵ
		var varInfFactors = '';
		var varInvasiveOperation = '';
		if(obj.CurrReport.RowID == "") {
			//Add By LiYang 2012-11-27 ��ȡ�ۺϼ������
			obj.tmpInfPosOpers = GetEpisodeIntCtlResult(EpisodeID);
			Common_SetValue('INFPOS_cbgInfFactors',obj.tmpInfPosOpers);
			Common_SetValue('INFPOS_cbgInvasiveOper',obj.tmpInfPosOpers);
		} else {
			if (obj.CurrReport.ChildSumm.InfFactors) {
				var arrInfFactors = obj.CurrReport.ChildSumm.InfFactors;
				for (var ind = 0; ind < arrInfFactors.length; ind++) {
					var objDic = arrInfFactors[ind];
					if (objDic) {
						varInfFactors = (varInfFactors == '' ? objDic.RowID : varInfFactors + ',' + objDic.RowID);
					}
				}
			}
			Common_SetValue('INFPOS_cbgInfFactors',varInfFactors);
			if (obj.CurrReport.ChildSumm.InvasiveOperation) {
				var arrInvasiveOperation = obj.CurrReport.ChildSumm.InvasiveOperation;
				for (var ind = 0; ind < arrInvasiveOperation.length; ind++) {
					var objDic = arrInvasiveOperation[ind];
					if (objDic) {
						varInvasiveOperation = (varInvasiveOperation == '' ? objDic.RowID : varInvasiveOperation + ',' + objDic.RowID);
					}
				}
			}
			Common_SetValue('INFPOS_cbgInvasiveOper',varInvasiveOperation);
		}
		
		//��ʼ��"��Ⱦ��Ϣ"load��rowdblclick�¼�
		var objGrid = Ext.getCmp("INFPOS_gridInfPos");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.INFPOS_gridInfPos_RowEditer(objRec);
			},objGrid);
		}
	}
	
	//��Ⱦ��� ���ݴ洢
	obj.INFPOS_SaveData = function(){
		var errinfo = '';
		
		//�׸�����
		obj.CurrReport.ChildSumm.InfFactors = new Array();
		var itmValue = Common_GetValue('INFPOS_cbgInfFactors');
		var arrValue = itmValue.split(',');
		if (itmValue) {
			for (var ind = 0; ind < arrValue.length; ind++) {
				var objDic = obj.ClsSSDictionary.GetObjById(arrValue[ind]);
				if (objDic) {
					obj.CurrReport.ChildSumm.InfFactors.push(objDic);
				}
			}
		}
		
		//�ֺ��Բ���
		obj.CurrReport.ChildSumm.InvasiveOperation = new Array();
		var itmValue = Common_GetValue('INFPOS_cbgInvasiveOper');
		var arrValue = itmValue.split(',');
		if (itmValue) {
			for (var ind = 0; ind < arrValue.length; ind++) {
				var objDic = obj.ClsSSDictionary.GetObjById(arrValue[ind]);
				if (objDic) {
					obj.CurrReport.ChildSumm.InvasiveOperation.push(objDic);
				}
			}
		}
		
		//��Ⱦ��Ϣ
		obj.CurrReport.ChildInfPos   = new Array();
		objSumm = obj.CurrReport.ChildSumm;
		var objCmp = Ext.getCmp('INFPOS_gridInfPos');
		if (objCmp) {
			var objStore = objCmp.getStore();
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objRec = objStore.getAt(indRec);
				var objInfPos = obj.ClsInfReportInfPosSrv.GetSubObj('');
				if (objInfPos) {
					objInfPos.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objInfPos.DataSource = objRec.get('DataSource');
					objInfPos.InfPos = obj.ClsInfPosition.GetObjById(objRec.get('InfPosID'));
					objInfPos.InfDate = objRec.get('InfDate'); 
					objInfPos.InfEndDate = objRec.get('InfEndDate');//��Ⱦ��������
					objInfPos.InfEndResult = objRec.get('InfEndResultID'); //��Ⱦת��
					objInfPos.InfDiag = obj.ClsInfDiagnose.GetObjById(objRec.get('InfDiagnosID'));
					objInfPos.InfDiagCat = obj.ClsSSDictionary.GetObjById(objRec.get('InfDiagCatID')); //��Ⱦ����ӷ���
					objInfPos.DiagnosisBasis = objRec.get('DiagnosisBasis');
					objInfPos.DiseaseCourse = objRec.get('DiseaseCourse');
					
					//���Ⱦ��ص��ֺ��Բ���
					objInfPos.InfPosOpr = new Array();
					var InfPosOprValues = objRec.get('InfPosOprValues');
					InfPosOprValues = InfPosOprValues.replace(/<\$C2>/gi,CHR_2);
					var arrInfPosOpr = InfPosOprValues.split(CHR_1);
					for (var indOpr = 0; indOpr < arrInfPosOpr.length; indOpr++) {
						var strRec = arrInfPosOpr[indOpr];
						if (strRec == '') continue;
						var arrField = strRec.split(CHR_2);
						var objInfPosOpr = new Object();
						objInfPosOpr.InvasiveOper = obj.ClsSSDictionary.GetObjById(arrField[0]);
						objInfPosOpr.StartDate = ''; //Add By LiYang 2013-05-19 ����ҽԺ��Ⱦ��������
						objInfPosOpr.StartTime = '';
						objInfPosOpr.EndDate = '';
						objInfPosOpr.EndTime = '';
						objInfPos.InfPosOpr.push(objInfPosOpr);
						
						//"���Ⱦ��λ�йص��ֺ��Բ���"��ӵ�"�ֺ��Բ���"����
						var isActive = false;
						var arrInvasiveOperation = obj.CurrReport.ChildSumm.InvasiveOperation;
						for (var indInvOpr = 0; indInvOpr < arrInvasiveOperation.length; indInvOpr++) {
							var tmpDic = arrInvasiveOperation[indInvOpr];
							if (!tmpDic) continue;
							if (tmpDic.RowID == objInfPosOpr.InvasiveOper.RowID) {
								isActive = true;
							}
						}
						if (!isActive) {
							obj.CurrReport.ChildSumm.InvasiveOperation.push(objInfPosOpr.InvasiveOper);
						}
					}
					
					//���������У��
					var rowerrinfo = '';
					if (!objInfPos.InfPos) {
						rowerrinfo = rowerrinfo + '��Ⱦ��λ&nbsp;'
					}
					if (!objInfPos.InfDate) {
						rowerrinfo = rowerrinfo + '��Ⱦ����&nbsp;'
					}
					if (!objInfPos.InfDiag) {
						rowerrinfo = rowerrinfo + '��Ⱦ���&nbsp;'
					}
					if (objInfPos.InfPosOpr.length < 1) {
						//rowerrinfo = rowerrinfo + '���Ⱦ��ص��ֺ��Բ���&nbsp;'
					}
					if (rowerrinfo) {
						var row = objStore.indexOfId(objRec.id);  //��ȡ�к�
						rowerrinfo = rowerrinfo + '��Ⱦ��Ϣ ��' + (row + 1) + '�� ' + rowerrinfo + 'δ��!<br>';
					}
					
					obj.CurrReport.ChildInfPos.push(objInfPos);
				}
			}
		}
		
		//����������У��
		if (obj.CurrReport.ChildInfPos.length < 1) {
			errinfo = errinfo + '��Ⱦ��Ϣδ��!<br>'
		}
		if (obj.CurrReport.ChildSumm.InfFactors.length < 1) {
			errinfo = errinfo + '�׸�����δ��!<br>'
		}
		if (obj.CurrReport.ChildSumm.InvasiveOperation.length < 1) {
			//errinfo = errinfo + '�ֺ��Բ���δ��!<br>'
		}
		
		return errinfo;
	}
	
	return obj;
}