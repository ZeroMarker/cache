
function InitALAB(obj)
{
	//�б༭
	obj.ALAB_GridRowEditer_cboArcim = Common_ComboToArcim("ALAB_GridRowEditer_cboArcim","����ҽ��","L");
	obj.ALAB_GridRowEditer_cboSpecimen = Common_ComboToDic("ALAB_GridRowEditer_cboSpecimen","�걾","NINFInfSpecimen");
	obj.ALAB_GridRowEditer_cboInfectionPos = Common_ComboToInfPos("ALAB_GridRowEditer_cboInfectionPos","��Ⱦ��λ");
	obj.ALAB_GridRowEditer_txtSubmissionDate = Common_DateFieldToDate("ALAB_GridRowEditer_txtSubmissionDate","�ͼ�����");
	obj.ALAB_GridRowEditer_cboAssayMethod = Common_ComboToDic("ALAB_GridRowEditer_cboAssayMethod","���鷽��","NINFInfAssayMethod");
	obj.ALAB_GridRowEditer_cboPathogenTest = Common_ComboToDic("ALAB_GridRowEditer_cboPathogenTest","������","NINFInfPathogenTest");
	obj.ALAB_GridRowEditer_gridPyAnti_cboPathogeny = Common_ComboToPathogeny("ALAB_GridRowEditer_gridPyAnti_cboPathogeny","��ԭ��");
	obj.ALAB_GridRowEditer_gridPyAnti_cboAntibiotics = Common_ComboToAntibiotics("ALAB_GridRowEditer_gridPyAnti_cboAntibiotics","������");
	obj.ALAB_GridRowEditer_gridPyAnti_cboSenTestRst = Common_ComboToDic("ALAB_GridRowEditer_gridPyAnti_cboSenTestRst","ҩ�����","NINFInfSenTestRst");
	obj.ALAB_GridRowEditer_gridPyAnti_btnAdd = new Ext.Button({
		id : 'ALAB_GridRowEditer_gridPyAnti_btnAdd'
		,iconCls : 'icon-add'
		,width: 80
		,text : '����'
		,listeners : {
			'click' :  function(){
				var PathogenyID = Common_GetValue('ALAB_GridRowEditer_gridPyAnti_cboPathogeny');
				var PathogenyDesc = Common_GetText('ALAB_GridRowEditer_gridPyAnti_cboPathogeny');
				var AntibioticsID = Common_GetValue('ALAB_GridRowEditer_gridPyAnti_cboAntibiotics');
				var AntibioticsDesc = Common_GetText('ALAB_GridRowEditer_gridPyAnti_cboAntibiotics');
				if (AntibioticsDesc != '') {
					var SenTestRstID = Common_GetValue('ALAB_GridRowEditer_gridPyAnti_cboSenTestRst');
					var SenTestRstDesc = Common_GetText('ALAB_GridRowEditer_gridPyAnti_cboSenTestRst');
				} else {
					var SenTestRstID = '';
					var SenTestRstDesc = '';
				}
				
				var errInfo = '';
				if (PathogenyDesc == '') {
					errInfo = errInfo + '��ԭ��Ϊ��!<br>';
				}
				if ((AntibioticsDesc != '')&&((SenTestRstID == '')||(SenTestRstDesc == ''))) {
					errInfo = errInfo + 'ҩ�����Ϊ��!<br>';
				}
				
				//Add By LiYang 2014-07-03 FixBug:2001 ���������¼�-ҽԺ��Ⱦ����-ICU��Ⱦ��⣬��ԭѧ�����ͼ�����С����Ժ���ڣ��ύ�ɹ�
				var tDate = Date.parseDate(obj.ALAB_GridRowEditer_txtSubmissionDate.getRawValue(), "Y-m-d");
				var tAdmDate = Date.parseDate(obj.CurrPaadm.AdmitDate, "Y-m-d");
				if(tDate < tAdmDate)
					errInfo = errInfo + '��ԭѧ�����ͼ�����Ӧ������Ժ����!<br>';

				
				if (errInfo != '') {
					ExtTool.alert("��ʾ",errInfo);
					return;
				}
				
				Common_SetValue('ALAB_GridRowEditer_gridPyAnti_cboAntibiotics','','');
				Common_SetValue('ALAB_GridRowEditer_gridPyAnti_cboSenTestRst','','');
				
				var objGrid = Ext.getCmp('ALAB_GridRowEditer_gridPyAnti');
				if (objGrid) {
					var objStore = objGrid.getStore();
					
					//�ж��Ƿ������ͬҽ������,��ͬ�ͼ���������
					var IsBoolean = false;
					for (var ind = 0; ind < objStore.getCount(); ind++) {
						var tmpRec = objStore.getAt(ind);
						if ((PathogenyDesc == tmpRec.get('PathogenyDesc'))&&(AntibioticsDesc == '')) {
							IsBoolean = true;
						} else {
							if ((PathogenyDesc == tmpRec.get('PathogenyDesc'))&&(AntibioticsDesc == tmpRec.get('AntibioticsDesc'))) {
								IsBoolean = true;
							}
						}
					}
					if (IsBoolean) {
						ExtTool.alert("��ʾ","�����ظ�����!");
						return;
					}
					
					//��������
					var RecordType = objStore.recordType;
					var RecordData = new RecordType({
						PathogenyID : PathogenyID
						,PathogenyDesc : PathogenyDesc
						,AntibioticsID : AntibioticsID
						,AntibioticsDesc : AntibioticsDesc
						,SenTestRstID : SenTestRstID
						,SenTestRstDesc : SenTestRstDesc
					});
					objStore.insert(objStore.getCount(), RecordData);
					objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
				}
			}
		}
	});
	obj.ALAB_GridRowEditer_gridPyAnti_btnDel = new Ext.Button({
		id : 'ALAB_GridRowEditer_gridPyAnti_btnDel'
		,iconCls : 'icon-delete'
		,width: 80
		,text : 'ɾ��'
		,listeners : {
			'click' :  function(){
				var objGrid = Ext.getCmp("ALAB_GridRowEditer_gridPyAnti");
				if (objGrid){
					var arrRec = objGrid.getSelectionModel().getSelections();
					if (arrRec.length>0){
						Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
							if(btn=="yes"){
								for (var indRec = 0; indRec < arrRec.length; indRec++){
									var objRec = arrRec[indRec];
									objGrid.getStore().remove(objRec);
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
	obj.ALAB_GridRowEditer_gridPyAnti = new Ext.grid.GridPanel({
		id: 'ALAB_GridRowEditer_gridPyAnti',
		store : new Ext.data.Store({
			reader: new Ext.data.JsonReader(
				{
					root: 'record',
					totalProperty: 'total'
				},
				[
					{name: 'PathogenyID', mapping: 'PathogenyID'}
					,{name: 'PathogenyDesc', mapping: 'PathogenyDesc'}
					,{name: 'AntibioticsID', mapping: 'AntibioticsID'}
					,{name: 'AntibioticsDesc', mapping: 'AntibioticsDesc'}
					,{name: 'SenTestRstID', mapping: 'SenTestRstID'}
					,{name: 'SenTestRstDesc', mapping: 'SenTestRstDesc'}
				]
			)
		})
		,anchor : '100%'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '��ԭ��', width: 150, dataIndex: 'PathogenyDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '����ҩ��', width: 150, dataIndex: 'AntibioticsDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: 'ҩ�����', width: 60, dataIndex: 'SenTestRstDesc', sortable: false, menuDisabled:true, align:'center' }
		],
		viewConfig : {
			forceFit : true
		}
	});
	obj.ALAB_GridRowViewPort = {
		layout : 'border',
		frame : true,
		items : [
			{
				region: 'north',
				height : 90,
				layout : 'form',
				frame : true,
				items : [
					{
						layout : 'column',
						items : [
							{
								columnWidth :.50,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [
									obj.ALAB_GridRowEditer_cboArcim
									,obj.ALAB_GridRowEditer_cboSpecimen
									//,obj.ALAB_GridRowEditer_cboInfectionPos
									,obj.ALAB_GridRowEditer_txtSubmissionDate
								]
							},{
								columnWidth :.50,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								items : [
									obj.ALAB_GridRowEditer_cboAssayMethod
									,obj.ALAB_GridRowEditer_cboPathogenTest
								]
							}
						]
					}
				]
			},{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'south',
						height: 35,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										columnWidth :.50,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 50,
										items : [
											obj.ALAB_GridRowEditer_gridPyAnti_cboPathogeny
										]
									},{
										columnWidth :.50,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 50,
										items : [
											obj.ALAB_GridRowEditer_gridPyAnti_cboAntibiotics
										]
									},{
										width :150,
										layout : 'form',
										labelAlign : 'right',
										labelWidth : 60,
										items : [
											obj.ALAB_GridRowEditer_gridPyAnti_cboSenTestRst
										]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.ALAB_GridRowEditer_gridPyAnti
						]
					}
				],
				bbar : [obj.ALAB_GridRowEditer_gridPyAnti_btnAdd,obj.ALAB_GridRowEditer_gridPyAnti_btnDel,'->','��']
			}
		]
	}
	obj.ALAB_GridRowDataCheck = function(objRec){
		var errInfo = '';
		
		if (objRec) {
			var val = objRec.get('ArcimDesc');
			if (val=='') {
				errInfo = errInfo + '����ҽ��δ��!<br>';
			}
			var val = objRec.get('SpecimenID');
			if (val=='') {
				errInfo = errInfo + '�걾δ��!<br>';
			}
			var val = objRec.get('InfectionPosID');
			if (val=='') {
				//errInfo = errInfo + '��Ⱦ��λδ��!<br>';
			}
			var val = objRec.get('SubmissionDate');
			if (val=='') {
				errInfo = errInfo + '�ͼ�����δ��!<br>';
			}
			var val = objRec.get('AssayMethodID');
			if (val=='') {
				errInfo = errInfo + '��ԭѧ���鷽��δ��!<br>';
			}
			var val = objRec.get('PathogenTestID');
			if (val=='') {
				errInfo = errInfo + '������δ��!<br>';
			}
		} else {
			var val = Common_GetText('ALAB_GridRowEditer_cboArcim');
			if (val=='') {
				errInfo = errInfo + '����ҽ��δ��!<br>';
			}
			var val = Common_GetValue('ALAB_GridRowEditer_cboSpecimen');
			if (val=='') {
				errInfo = errInfo + '�걾δ��!<br>';
			}
			var val = Common_GetValue('ALAB_GridRowEditer_cboInfectionPos');
			if (val=='') {
				//errInfo = errInfo + '��Ⱦ��λδ��!<br>';
			}
			var val = Common_GetValue('ALAB_GridRowEditer_txtSubmissionDate');
			if (val=='') {
				errInfo = errInfo + '�ͼ�����δ��!<br>';
			}
			var val = Common_GetValue('ALAB_GridRowEditer_cboAssayMethod');
			if (val=='') {
				errInfo = errInfo + '��ԭѧ���鷽��δ��!<br>';
			}
			var val = Common_GetValue('ALAB_GridRowEditer_cboPathogenTest');
			if (val=='') {
				errInfo = errInfo + '������δ��!<br>';
			}
		}
		
		return errInfo;
	}
	obj.ALAB_GridRowDataSave = function(objRec){
		var ArcimID = Common_GetValue('ALAB_GridRowEditer_cboArcim');
		var ArcimDesc = Common_GetText('ALAB_GridRowEditer_cboArcim');
		var SpecimenID = Common_GetValue('ALAB_GridRowEditer_cboSpecimen');
		var SpecimenDesc = Common_GetText('ALAB_GridRowEditer_cboSpecimen');
		var InfectionPosID = Common_GetValue('ALAB_GridRowEditer_cboInfectionPos');
		var InfectionPosDesc = Common_GetText('ALAB_GridRowEditer_cboInfectionPos');
		var SubmissionDate = Common_GetValue('ALAB_GridRowEditer_txtSubmissionDate');
		var AssayMethodID = Common_GetValue('ALAB_GridRowEditer_cboAssayMethod');
		var AssayMethodDesc = Common_GetText('ALAB_GridRowEditer_cboAssayMethod');
		var PathogenTestID = Common_GetValue('ALAB_GridRowEditer_cboPathogenTest');
		var PathogenTestDesc = Common_GetText('ALAB_GridRowEditer_cboPathogenTest');
		var TestResultValues = '';
		var TestResultDescs = '';
		var objGrid = Ext.getCmp('ALAB_GridRowEditer_gridPyAnti');
		if (objGrid) {
			var objStore = objGrid.getStore();
			var arrPathogeny = new Array();
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objXRec = objStore.getAt(indRec);
				
				//��ԭ��
				var PathogenyID = objXRec.get('PathogenyID');
				var PathogenyDesc = objXRec.get('PathogenyDesc');
				if (PathogenyDesc == '') continue;
				var indArrPy = -1;
				for (var indPy = 0; indPy < arrPathogeny.length; indPy++) {
					if (PathogenyDesc == arrPathogeny[indPy].PathogenyDesc) {
						indArrPy = indPy;
						break;
					}
				}
				var objPathogeny = new Object();
				if (indArrPy < 0) {
					objPathogeny.PathogenyID = PathogenyID;
					objPathogeny.PathogenyDesc = PathogenyDesc;
					objPathogeny.Antibiotics = new Array();
					arrPathogeny.push(objPathogeny);
					indArrPy = arrPathogeny.length-1;
				} else {
					objPathogeny = arrPathogeny[indArrPy];
				}
				
				//������
				var AntibioticsID = objXRec.get('AntibioticsID');
				var AntibioticsDesc = objXRec.get('AntibioticsDesc');
				var SenTestRstID = objXRec.get('SenTestRstID');
				var SenTestRstDesc = objXRec.get('SenTestRstDesc');
				if (AntibioticsDesc == '') continue;
				var indArrAnti = -1;
				for (var indAnti = 0; indAnti < objPathogeny.Antibiotics.length; indAnti++) {
					if (AntibioticsDesc == objPathogeny.Antibiotics[indAnti].AntibioticsDesc) {
						indArrAnti = indAnti;
						break;
					}
				}
				if (indArrAnti < 0) {
					var objAntiSenTest = new Object();
					objAntiSenTest.AntibioticsID = AntibioticsID;
					objAntiSenTest.AntibioticsDesc = AntibioticsDesc;
					objAntiSenTest.SenTestRstID = SenTestRstID;
					objAntiSenTest.SenTestRstDesc = SenTestRstDesc;
					objPathogeny.Antibiotics.push(objAntiSenTest);
				}
			}
			
			for (var indPy = 0; indPy < arrPathogeny.length; indPy++) {
				var objPy = arrPathogeny[indPy];
				var AntiValues = '';
				for (var indAnti = 0; indAnti < objPy.Antibiotics.length; indAnti++) {
					var objAnti = objPy.Antibiotics[indAnti];
					var AntiValue = objAnti.AntibioticsID;
					AntiValue = AntiValue + CHR_4 + objAnti.AntibioticsDesc;
					AntiValue = AntiValue + CHR_4 + objAnti.SenTestRstID;
					AntiValue = AntiValue + CHR_4 + objAnti.SenTestRstDesc;
					AntiValues = (AntiValues == '' ? AntiValue : AntiValues + CHR_3 + AntiValue);
				}
				var PyValue = objPy.PathogenyID + CHR_2 + objPy.PathogenyDesc + CHR_2 + AntiValues;
				TestResultValues = (TestResultValues == '' ? PyValue : TestResultValues + CHR_1 + PyValue);
				TestResultDescs = (TestResultDescs == '' ? objPy.PathogenyDesc : TestResultDescs + ',' + objPy.PathogenyDesc);
			}
		}
		
		if (objRec) {      //�ύ����
			objRec.set('ArcimID',ArcimID);
			objRec.set('ArcimDesc',ArcimDesc);
			objRec.set('SpecimenID',SpecimenID);
			objRec.set('SpecimenDesc',SpecimenDesc);
			objRec.set('InfectionPosID',InfectionPosID);
			objRec.set('InfectionPosDesc',InfectionPosDesc);
			objRec.set('SubmissionDate',SubmissionDate);
			objRec.set('AssayMethodID',AssayMethodID);
			objRec.set('AssayMethodDesc',AssayMethodDesc);
			objRec.set('PathogenTestID',PathogenTestID);
			objRec.set('PathogenTestDesc',PathogenTestDesc);
			objRec.set('TestResultValues',TestResultValues);
			objRec.set('TestResultDescs',TestResultDescs);
			objRec.commit();
		} else {                 //��������
			var objGrid = Ext.getCmp('ALAB_gridLab');
			if (objGrid){
				var objStore = objGrid.getStore();
				var RecordType = objStore.recordType;
				var RecordData = new RecordType({
					RepID : obj.CurrReport.RowID
					,SubID : ''
					,ArcimID : ArcimID
					,ArcimDesc : ArcimDesc
					,SpecimenID : SpecimenID
					,SpecimenDesc : SpecimenDesc
					,InfectionPosID : InfectionPosID
					,InfectionPosDesc : InfectionPosDesc
					,SubmissionDate : SubmissionDate
					,AssayMethodID : AssayMethodID
					,AssayMethodDesc : AssayMethodDesc
					,PathogenTestID : PathogenTestID
					,PathogenTestDesc : PathogenTestDesc
					,TestResultValues : TestResultValues
					,TestResultDescs : TestResultDescs
					,DataSource : ''
				});
				objStore.insert(objStore.getCount(), RecordData);
				objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
			}
		}
	}
	obj.ALAB_GridRowDataSet = function(objRec){
		if ((objRec != '') || (objRec != null))
			Common_SetDisabled("ALAB_GridRowEditer_cboArcim", false);
		else
			Common_SetDisabled("ALAB_GridRowEditer_cboArcim", true);
			
		if (objRec) {
			Common_SetValue('ALAB_GridRowEditer_cboArcim',objRec.get('ArcimID'),objRec.get('ArcimDesc'));
			//Common_SetDisabled("ALAB_GridRowEditer_cboArcim",(objRec.get('DataSource') != ''));  //Modified By LiYang 2014-07-03 FixBug:1755 ���������¼�-ҽԺ��Ⱦ����-��ԭѧ������ȡ���ݺ󣬵�������ӡ���ť������ѡ�񡾼���ҽ����
			if(objRec.get('SpecimenDesc').substr(0,1)=='*'){
				Common_SetValue('ALAB_GridRowEditer_cboSpecimen',objRec.get('SpecimenID'));
			}else{
				Common_SetValue('ALAB_GridRowEditer_cboSpecimen',objRec.get('SpecimenID'),objRec.get('SpecimenDesc'));
			}
			Common_SetValue('ALAB_GridRowEditer_cboInfectionPos',objRec.get('InfectionPosID'),objRec.get('InfectionPosDesc'));
			Common_SetValue('ALAB_GridRowEditer_txtSubmissionDate',objRec.get('SubmissionDate'));
			Common_SetValue('ALAB_GridRowEditer_cboAssayMethod',objRec.get('AssayMethodID'),objRec.get('AssayMethodDesc'));
			Common_SetValue('ALAB_GridRowEditer_cboPathogenTest',objRec.get('PathogenTestID'),objRec.get('PathogenTestDesc'));
			
			var objGrid = Ext.getCmp('ALAB_GridRowEditer_gridPyAnti');
			if (objGrid) {
				objGrid.getStore().removeAll();
				
				var objStore = objGrid.getStore();
				var TestResultValues = objRec.get('TestResultValues');
				TestResultValues = TestResultValues.replace(/<\$C2>/gi,CHR_2);
				TestResultValues = TestResultValues.replace(/<\$C3>/gi,CHR_3);
				TestResultValues = TestResultValues.replace(/<\$C4>/gi,CHR_4);
				var arrPy = TestResultValues.split(CHR_1);
				for (var indPy = 0; indPy < arrPy.length; indPy++) {
					var strPyField = arrPy[indPy];
					if (strPyField == '') continue;
					var arrPyField = strPyField.split(CHR_2);
					if (arrPyField[2] == '') {
						var RecordType = objStore.recordType;
						var RecordData = new RecordType({
							PathogenyID : arrPyField[0]
							,PathogenyDesc : arrPyField[1]
							,AntibioticsID : ''
							,AntibioticsDesc : ''
							,SenTestRstID : ''
							,SenTestRstDesc : ''
						});
						objStore.insert(objStore.getCount(), RecordData);
					} else {
						var arrAnti = arrPyField[2].split(CHR_3);
						for (var indAnti = 0; indAnti < arrAnti.length; indAnti++) {
							var strAntiField = arrAnti[indAnti];
							var arrAntiField = strAntiField.split(CHR_4);
							var RecordType = objStore.recordType;
							var RecordData = new RecordType({
								PathogenyID : arrPyField[0]
								,PathogenyDesc : arrPyField[1]
								,AntibioticsID : arrAntiField[0]
								,AntibioticsDesc : arrAntiField[1]
								,SenTestRstID : arrAntiField[2]
								,SenTestRstDesc : arrAntiField[3]
							});
							objStore.insert(objStore.getCount(), RecordData);
						}
					}
				}
			}
		} else {
			Common_SetValue('ALAB_GridRowEditer_cboArcim','','');
			Common_SetValue('ALAB_GridRowEditer_cboSpecimen','','');
			Common_SetValue('ALAB_GridRowEditer_cboInfectionPos','','');
			Common_SetValue('ALAB_GridRowEditer_txtSubmissionDate','');
			Common_SetValue('ALAB_GridRowEditer_cboAssayMethod','','');
			Common_SetValue('ALAB_GridRowEditer_cboPathogenTest','','');
			var objGrid = Ext.getCmp('ALAB_GridRowEditer_gridPyAnti');
			if (objGrid) {
				objGrid.getStore().removeAll();
			}
		}
		
		Common_SetValue('ALAB_GridRowEditer_gridPyAnti_cboPathogeny','','');
		Common_SetValue('ALAB_GridRowEditer_gridPyAnti_cboAntibiotics','','');
		Common_SetValue('ALAB_GridRowEditer_gridPyAnti_cboSenTestRst','','');
	}
	obj.ALAB_GridRowEditer = function(objRec){
		obj.ALAB_GridRowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('ALAB_GridRowEditer');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'ALAB_GridRowEditer',
				height : 450,
				closeAction: 'hide',
				width : 600,
				modal : true,
				title : '��ԭѧ����-�༭',
				layout : 'fit',
				frame : true,
				items: [
					obj.ALAB_GridRowViewPort
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "ALAB_GridRowEditer_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>����",
						listeners : {
							'click' : function(){
								var errInfo = obj.ALAB_GridRowDataCheck('');
								if (errInfo){
									ExtTool.alert("��ʾ",errInfo);
									return;
								}
								obj.ALAB_GridRowDataSave(obj.ALAB_GridRowEditer_objRec);
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "ALAB_GridRowEditer_btnCancel",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/cancel.png'>�ر�",
						listeners : {
							'click' : function(){
								winGridRowEditer.hide();
							}
						}
					})
				]
			});
		}
		winGridRowEditer.show();
		obj.ALAB_GridRowDataSet(objRec);
	}
	
	//��ȡ��
	obj.ALAB_GridExtract_gridLab = new Ext.grid.GridPanel({
		id: 'ALAB_GridExtract_gridLab',
		store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' :  function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Rep.InfReportLab';
						param.QueryName = 'QrySubRec';
						param.Arg1      = '';
						param.Arg2      = obj.CurrReport.EpisodeID;
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
					,{name: 'ArcimID', mapping: 'ArcimID'}
					,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
					,{name: 'SpecimenID', mapping: 'SpecimenID'}
					,{name: 'SpecimenDesc', mapping: 'SpecimenDesc'}
					,{name: 'InfectionPosID', mapping: 'InfectionPosID'}
					,{name: 'InfectionPosDesc', mapping: 'InfectionPosDesc'}
					,{name: 'SubmissionDate', mapping: 'SubmissionDate'}
					,{name: 'AssayMethodID', mapping: 'AssayMethodID'}
					,{name: 'AssayMethodDesc', mapping: 'AssayMethodDesc'}
					,{name: 'PathogenTestID', mapping: 'PathogenTestID'}
					,{name: 'PathogenTestDesc', mapping: 'PathogenTestDesc'}
					,{name: 'TestResultValues', mapping: 'TestResultValues'}
					,{name: 'TestResultDescs', mapping: 'TestResultDescs'}
					,{name: 'DataSource', mapping: 'DataSource'}
				]
			)
		})
		,height : 180
		//,overflow:'scroll'
		//,overflow-y:hidden
		//,style:'overflow:auto;overflow-y:hidden'
		//,loadMask : true
		//,frame : true
		,anchor : '100%'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '����ҽ��', width: 150, dataIndex: 'ArcimDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '�걾', width: 80, dataIndex: 'SpecimenDesc', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '��Ⱦ��λ', width: 100, dataIndex: 'InfectionPosDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '�ͼ�����', width: 80, dataIndex: 'SubmissionDate', sortable: false, menuDisabled:true, align:'center' }
			,{header: '���鷽��', width: 80, dataIndex: 'AssayMethodDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '��ԭѧ<br>������', width: 60, dataIndex: 'PathogenTestDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header: '��ԭ��', width: 200, dataIndex: 'TestResultDescs', sortable: false, menuDisabled:true, align:'center' }
			,{header: '����<br>��Դ', width: 50, dataIndex: 'DataSource', sortable: false, menuDisabled:true, align:'center' }
		],
		viewConfig : {
			forceFit : true
		}
	});
	obj.ALAB_GridExtract = function() {
		var winGridRowEditer = Ext.getCmp('ALAB_GridExtract');
		if (!winGridRowEditer){
			winGridRowEditer = new Ext.Window({
				id : 'ALAB_GridExtract',
				height : 500,
				closeAction: 'hide',
				width : 800,
				modal : true,
				title : '��ԭѧ����-��ȡ',
				layout : 'fit',
				frame : true,
				items: [
					obj.ALAB_GridExtract_gridLab
				],
				bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "ALAB_GridExtract_btnUpdate",
						width : 80,
						text : "<img SRC='../scripts/dhcmed/img/update.png'>ȷ��",
						listeners : {
							'click' : function(){
								var objRowDataGrid = Ext.getCmp('ALAB_GridExtract_gridLab');
								var objGrid = Ext.getCmp('ALAB_gridLab');
								if ((objRowDataGrid)&&(objGrid)) {
									function insertfun(){
										var objStore = objGrid.getStore();
										var arrRec = objRowDataGrid.getSelectionModel().getSelections();
										var rowbreak = -1;
										for (var indRec = 0; indRec < arrRec.length; indRec++){
											var objRec = arrRec[indRec];
											
											//����Ƿ������ͬһ������ͬ������,����ͬ������Դ����
											var isBoolean = false;
											for (var indStore = 0; indStore < objStore.getCount(); indStore++) {
												var tmpRec = objStore.getAt(indStore);
												if ((tmpRec.get('ArcimDesc') == objRec.get('ArcimDesc'))
												&&((tmpRec.get('SubmissionDate') == objRec.get('SubmissionDate')))) {
													isBoolean = true;
												}
												if (tmpRec.get('DataSource') == objRec.get('DataSource')) {
													isBoolean = true;
												}
											}
											
											var row = objRowDataGrid.getStore().indexOfId(objRec.id);  //��ȡѡ�е��к�
											if (typeof arrSelections[row] == 'undefined') arrSelections[row] = -1;
											
											if ((isBoolean)&&(arrSelections[row]<0)) {
												rowbreak = row;
												break;       //������
											} else if (arrSelections[row] > 0) {
												continue;    //�Ѵ���
											} else {
												arrSelections[row] = 1;
											}
											
											var RecordType = objStore.recordType;
											var RecordData = new RecordType({
												RepID : objRec.get('RepID')
												,SubID : objRec.get('SubID')
												,ArcimID : objRec.get('ArcimID')
												,ArcimDesc : objRec.get('ArcimDesc')
												,SpecimenID : objRec.get('SpecimenID')
												,SpecimenDesc : objRec.get('SpecimenDesc')
												,InfectionPosID : objRec.get('InfectionPosID')
												,InfectionPosDesc : objRec.get('InfectionPosDesc')
												,SubmissionDate : objRec.get('SubmissionDate')
												,AssayMethodID : objRec.get('AssayMethodID')
												,AssayMethodDesc : objRec.get('AssayMethodDesc')
												,PathogenTestID : objRec.get('PathogenTestID')
												,PathogenTestDesc : objRec.get('PathogenTestDesc')
												,TestResultValues : objRec.get('TestResultValues')
												,TestResultDescs : objRec.get('TestResultDescs')
												,DataSource : objRec.get('DataSource')
											});
											
											objStore.insert(objStore.getCount(), RecordData);
											obj.ALAB_GridRowEditer(RecordData);//���ȷ����ȡ���ݺ�ֱ�ӵ�����ԭѧ����༭���� add by yanjf,20140512
										}
										if (rowbreak > -1) {
											checkfun(rowbreak);
										} else {
											objGrid.getView().focusRow(objGrid.getStore().getCount()-1);
											winGridRowEditer.hide();
										}
									}
									
									function checkfun(row){
										Ext.MessageBox.confirm('��ʾ', '�����ظ�����,�Ƿ����?Row=' + (row + 1), function(btn,text){
											if (btn == "yes") {
												arrSelections[row] = 0;    //������
												insertfun();
											} else {
												arrSelections[row] = 1;    //�Ѵ���
												insertfun();
											}
										});
									}
									
									var arrSelections = new Array();
									insertfun();
								} else {
									winGridRowEditer.hide();
								}
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "ALAB_GridExtract_btnCancel",
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
						var objRowDataGrid = Ext.getCmp('ALAB_GridExtract_gridLab');
						if (objRowDataGrid) {
							objRowDataGrid.getStore().load({});
						}
					}
				}
			});
		}
		winGridRowEditer.show();
	}
	
	//���б�
	obj.ALAB_GridLabInit = function() {
		var tmpGridPanel = new Ext.grid.GridPanel({
			id: arguments[0],
			store : new Ext.data.Store({
				proxy: new Ext.data.HttpProxy({
					url : ExtToolSetting.RunQueryPageURL,
					listeners : {
						'beforeload' :  function(objProxy, param){
							param.ClassName = 'DHCMed.NINFService.Rep.InfReportLab';
							param.QueryName = 'QrySubRec';
							param.Arg1      = ReportID; //obj.CurrReport.RowID; Modified By LiYang 2014-07-03 FixBug��1755 ���������¼�-ҽԺ��Ⱦ����-��ԭѧ������ȡ���ݺ󣬵�������ӡ���ť������ѡ�񡾼���ҽ����
							param.Arg2      = '';   //obj.CurrReport.EpisodeID;  �½�����Ĭ�ϲ���������
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
						,{name: 'ArcimID', mapping: 'ArcimID'}
						,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
						,{name: 'SpecimenID', mapping: 'SpecimenID'}
						,{name: 'SpecimenDesc', mapping: 'SpecimenDesc'}
						,{name: 'InfectionPosID', mapping: 'InfectionPosID'}
						,{name: 'InfectionPosDesc', mapping: 'InfectionPosDesc'}
						,{name: 'SubmissionDate', mapping: 'SubmissionDate'}
						,{name: 'AssayMethodID', mapping: 'AssayMethodID'}
						,{name: 'AssayMethodDesc', mapping: 'AssayMethodDesc'}
						,{name: 'PathogenTestID', mapping: 'PathogenTestID'}
						,{name: 'PathogenTestDesc', mapping: 'PathogenTestDesc'}
						,{name: 'TestResultValues', mapping: 'TestResultValues'}
						,{name: 'TestResultDescs', mapping: 'TestResultDescs'}
						,{name: 'DataSource', mapping: 'DataSource'}
					]
				)
			})
			,height : 180
			//,overflow:'scroll'
			//,overflow-y:hidden
			//,style:'overflow:auto;overflow-y:hidden'
			//,loadMask : true
			,frame : true
			,anchor : '100%'
			,columns: [
				new Ext.grid.RowNumberer()
				,{header: '����ҽ��', width: 200, dataIndex: 'ArcimDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�걾', width: 80, dataIndex: 'SpecimenDesc', sortable: false, menuDisabled:true, align:'center' }
				//,{header: '��Ⱦ��λ', width: 100, dataIndex: 'InfectionPosDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '�ͼ�����', width: 80, dataIndex: 'SubmissionDate', sortable: false, menuDisabled:true, align:'center' }
				,{header: '���鷽��', width: 80, dataIndex: 'AssayMethodDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��ԭѧ<br>������', width: 60, dataIndex: 'PathogenTestDesc', sortable: false, menuDisabled:true, align:'center' }
				,{header: '��ԭ��', width: 200, dataIndex: 'TestResultDescs', sortable: false, menuDisabled:true, align:'center' }
			]
			,bbar : [
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnGet",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/update.gif'>��ȡ����",
					listeners : {
						'click' : function(){
							obj.ALAB_GridExtract();
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnAdd",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/add.png'>����",
					listeners : {
						'click' : function(){
							obj.ALAB_GridRowEditer('');
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: arguments[0] + "_btnDelete",
					width : 80,
					text : "<img SRC='../scripts/dhcmed/img/delete.gif'>ɾ��",
					listeners : {
						'click' :  function(){
							var objGrid = Ext.getCmp("ALAB_gridLab");
							if (objGrid){
								//var arrRec = objGrid.getSelectionModel().getSelections();
								var arrRec = objGrid.getStore().getRange(); //Modified By LiYang 2014-07-03 FixBug:1776 ���������¼�-ҽԺ��Ⱦ����-ICU��Ⱦ��⣬������ľ����ùܼ�¼��ֱ�ӵ����ɾ������ť����ʾ"��ѡ�����ݼ�¼���ٵ��ɾ����"
								if (arrRec.length>0){
									Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
										if(btn=="yes"){
											for (var indRec = 0; indRec < arrRec.length; indRec++){
												var objRec = arrRec[indRec];
												if (objRec.get('SubID')) {
													var RecID = objRec.get('RepID') + '||' + objRec.get('SubID');
													var flg = obj.ClsInfReportLabSrv.DelSubRec(objRec.get('RepID') + '||' + objRec.get('SubID'));
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
				})
				,'->'
				,'��'
			]
			,viewConfig : {
				forceFit : true
			}
		});
		
		return tmpGridPanel;
	}
	obj.ALAB_gridLab = obj.ALAB_GridLabInit("ALAB_gridLab");
	
	//���沼��
	obj.ALAB_ViewPort = {
		//title : '��ԭѧ����',
		layout : 'fit',
		//frame : true,
		height : 300,
		anchor : '-20',
		tbar : ['<b>��ԭѧ����</b>'],
		items : [
			obj.ALAB_gridLab
		]
	}
	
	//��ʼ������
	obj.ALAB_InitView = function(){
		var objGrid = Ext.getCmp("ALAB_gridLab");
		if (objGrid){
			objGrid.getStore().load({});
			objGrid.on('rowdblclick',function(){
				var rowIndex = arguments[1];
				var objRec = this.getStore().getAt(rowIndex);
				obj.ALAB_GridRowEditer(objRec);
			},objGrid);
		}
	}
	
	//���ݴ洢
	obj.ALAB_SaveData = function(){
		var errinfo = '';
		
		var objCmp = Ext.getCmp('ALAB_gridLab');
		if (objCmp) {
			var objStore = objCmp.getStore();
			for (var indRec = 0; indRec < objStore.getCount(); indRec++) {
				var objRec = objStore.getAt(indRec);
				
				//����������У��
				var flg = obj.ALAB_GridRowDataCheck(objRec);
				if (flg){
					var row = objStore.indexOfId(objRec.id);  //��ȡ�к�
					errinfo = errinfo + '������ ��' + (row + 1) + '�� ���ݴ���!<br>'
				}
				
				var objLab = obj.ClsInfReportLabSrv.GetSubObj('');
				if (objLab) {
					if (objRec.get('RepID')&&objRec.get('SubID')) objLab.RowID = objRec.get('RepID') + '||' + objRec.get('SubID');
					objLab.DataSource = objRec.get('DataSource');
					objLab.ArcimID = objRec.get('ArcimID');
					objLab.ArcimDesc = objRec.get('ArcimDesc');
					objLab.Specimen = obj.ClsSSDictionary.GetObjById(objRec.get('SpecimenID'));
					objLab.InfectionPos = obj.ClsInfPosition.GetObjById(objRec.get('InfectionPosID'));
					objLab.SubmissionDate = objRec.get('SubmissionDate');
					objLab.AssayMethod = obj.ClsSSDictionary.GetObjById(objRec.get('AssayMethodID'));
					objLab.PathogenTest = obj.ClsSSDictionary.GetObjById(objRec.get('PathogenTestID'));
					
					//��ԭ��,������,ҩ�����
					var pyerrinfo = '';
					var antierrinfo = '';
					objLab.TestResults = new Array();
					var TestResultValues = objRec.get('TestResultValues');
					TestResultValues = TestResultValues.replace(/<\$C2>/gi,CHR_2);
					TestResultValues = TestResultValues.replace(/<\$C3>/gi,CHR_3);
					TestResultValues = TestResultValues.replace(/<\$C4>/gi,CHR_4);
					var arrPy = TestResultValues.split(CHR_1);
					for (var indPy = 0; indPy < arrPy.length; indPy++) {
						var strPyField = arrPy[indPy];
						if (strPyField == '') continue;
						var arrPyField = strPyField.split(CHR_2);
						
						var objPy = new Object();
						objPy.PathogenyID = arrPyField[0]
						objPy.PathogenyDesc = arrPyField[1]
						objPy.DrugSenTest = new Array();
						
						var arrAnti = arrPyField[2].split(CHR_3);
						for (var indAnti = 0; indAnti < arrAnti.length; indAnti++) {
							var strAntiField = arrAnti[indAnti];
							if (strAntiField == '') continue;
							var arrAntiField = strAntiField.split(CHR_4);
							var objAnti = new Object();
							objAnti.AntibioticsID = arrAntiField[0]
							objAnti.AntibioticsDesc = arrAntiField[1]
							objAnti.SenTestRst = obj.ClsSSDictionary.GetObjById(arrAntiField[2]);
							objPy.DrugSenTest.push(objAnti);
						}
						objLab.TestResults.push(objPy);
					}
					
					obj.CurrReport.ChildLab.push(objLab);
				}
			}
		}
		
		return errinfo;
	}
	
	return obj;
}