function InitviewScreen() {
	window.returnValue = false;
	var obj = new Object();
	
	obj.objCurrPatient = null;			// ��ǰ���˶���
	obj.objCurrPaadm = null;			// ��ǰ���˾������
	obj.objCurrReport = null;			// ��ǰ��Ⱦ���������
	obj.objCurrReportStatus = null;		// ��ǰ����״̬����
	obj.objCurrRepPlace = null; 		// ��ǰ�ϱ�λ�ö���(ȫ�����������������)
	obj.objCurrRepCtloc = null; 		// ��ǰ�ϱ����Ҷ���
	obj.objCurrRepUser = null; 		    // ��ǰ�ϱ��û�����
	obj.EpdRepPatRelNotice = "";		// ��ǰ�ϱ����桰�ҳ��������ı����Աߵ���ʾ��Ϣ
	obj.EpdRepPatCompanyNotice = "";	// ��ǰ�ϱ����桰������λ���ı����Աߵ���ʾ��Ϣ
	
	obj.EpdRepCardNotice = "";	  // ��Ч֤�����ı����Աߵ���ʾ��Ϣ

	// ���������Ϣ�����ڣ����˳�
	if (PatientID == "" || EpisodeID == "") {
		ExtTool.alert("��ʾ��Ϣ", "��Ǹ��������Ϣ������!<br>��ȷ�Ϻ����²���!");
		return;
	}

	// ���˻�����Ϣ���-��һ����Panel
	obj.PanelRow0 = new Ext.Panel({
				id : 'PanelRow0',
				layout : 'fit',
				modal : true,
				renderTo : Ext.getBody(),
				autoScroll : true
			});

	// ���˻�����Ϣģ��
	obj.tplBaseInfo = new Ext.XTemplate(
			'<table border=.1 width=100% align=center>',
				'<tr>',
					'<td width=7% align="right">�ǼǺţ�</td><td width=18% align="left">{PapmiNo}</td>',
					'<td width=6% align="right">������</td><td width=19% align="left">{PatientName}</td>',
					'<td width=6% align="right">�Ա�</td><td width=19% align="left">{Sex}</td>',
					'<td width=7% align="right">������ң�</td><td width=18% align="left">{RepLoc}</td>',
				'</tr>',
				'<tr>',                                    
					'<td width=7% align="right">�����ţ�</td><td width=18% align="left">{InPatientMrNo}</td>',
					'<td width=6% align="right">���䣺</td><td width=19% align="left">{Age}</td>',
					'<td width=6% align="right">������</td><td width=19% align="left">{RepWard}</td>',
					'<td width=7% align="right">����λ�ã�</td><td width=18% align="left">{RepPlace}</td>',
				'</tr>',                
				'<tr>',                
					'<td width=7% align="right">�����ˣ�</td><td width=18% align="left">{RepUser}</td>',
					'<td width=6% align="right">����״̬��</td><td width=19% align="left">{RepStatus}</td>',
					'<td width=6% align="right">�����ܼ���</td><td width=19% align="left">{EncryptLevel}</td>',
					'<td width=7% align="right">���˼���</td><td width=18% align="left">{PatLevel}</td>',
				'</tr>',
			'</table>');

	// ***************************************************************************
	// ���˻�����Ϣ����Ա�����
	// ***************************************************************************
	// ְҵ�����
	obj.cboOccupationStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection(
			{
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboOccupationStore = new Ext.data.Store({
				proxy : obj.cboOccupationStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'Code'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'Code',
									mapping : 'Code'
								}, {
									name : 'Description',
									mapping : 'Description'
								}])
			});
	obj.cboOccupation = new Ext.form.ComboBox({
				id : 'cboOccupation',
				width : 180,
				//anchor : '99%',
				minChars : 1,
				displayField : 'Description',
				fieldLabel : "<font color='red'>*</font>��Ⱥ����",
				labelSeparator :'', 
				store : obj.cboOccupationStore,
				emptyText : '��ѡ��',
				editable : false,
				mode : 'local',
				selectOnFocus : true,
				forceSelection : true,
				typeAhead : true,
				triggerAction : 'all',
				valueField : 'Code'
			});
			
	// ���򣨱��
	obj.cboRegionStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboRegionStore = new Ext.data.Store({
				proxy : obj.cboRegionStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'Code'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'Code',
									mapping : 'Code'
								}, {
									name : 'Description',
									mapping : 'Description'
								}])
			});
	obj.cboRegion = new Ext.form.ComboBox({
				id : 'cboRegion',
				//width : 100%,
				anchor : '100%',
				minChars : 1,
				fieldLabel : "<font color='red'>*</font>��������",
				labelSeparator :'', 
				store : obj.cboRegionStore,
				emptyText : '��ѡ��',
				editable : false,
				mode : 'local',
				selectOnFocus : true,
				forceSelection : true,
				typeAhead : true,
				triggerAction : 'all',
				valueField : 'Code',
				displayField : 'Description'
			});
			
			
	// add 20160111 ֤������
	obj.cboCardTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboCardTypeStore = new Ext.data.Store({
				proxy : obj.cboCardTypeStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'Code'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'Code',
									mapping : 'Code'
								}, {
									name : 'Description',
									mapping : 'Description'
								}])
			});
	obj.cboCardType = new Ext.form.ComboBox({
				id : 'cboCardType',
				//width : 180,
				anchor : '100%',
				minChars : 1,
				fieldLabel : "<font color='red'>*</font>֤������",
				labelSeparator :'', 
				store : obj.cboCardTypeStore,
				emptyText : '��ѡ��',
				editable : false,
				mode : 'local',
				selectOnFocus : true,
				forceSelection : true,
				typeAhead : true,
				triggerAction : 'all',
				valueField : 'Code',
				displayField : 'Description'
			});
	//��Ч֤������ʾ��Ϣ
	obj.lblCardNotice = new Ext.form.Label({
				id : 'lblCardNotice',
				cls : 'textfield-red',
				anchor : '97%'
			});
			
	// ���֤�ţ������//��Ϊ��Ч֤����
	obj.txtPatCardNo = new Ext.form.TextField({
				id : 'txtPatCardNo',
				fieldLabel : "<font color='red'>*</font>��Ч֤����",
				labelSeparator :'', 
				//readOnly : true,
				anchor : '100%'
				//width : 200
			});
		
	// ��ϵ�绰�����
	obj.txtTel = new Ext.form.TextField({
				id : 'txtTel',
				fieldLabel : "<font color='red'>*</font>��ϵ�绰",
				labelSeparator :'', 
				//readOnly : true,
				//anchor : '99%',
				width : 180
			});
		
	// �ҳ�������������������С��14���껼�߱�����д�ҳ���������
	obj.txtRelationName = new Ext.form.TextField({
				id : 'txtRelationName',
				fieldLabel : "�ҳ�����",
				labelSeparator :'', 
				//readOnly : true,
				anchor : '100%'
				//width : 180
			});

	// �ҳ�������ʾ��Ϣ
	obj.lblRelationNotice = new Ext.form.Label({
				id : 'lblRelationNotice',
				cls : 'textfield-red',
				anchor : '95%'
			});
	
	// ������λ�����
	obj.txtCompany = new Ext.form.TextField({
				id : 'txtCompany',
				width : 100,
				//readOnly : true,
				anchor : '100%',
				labelSeparator :'', 
				fieldLabel : "<font color='red'>*</font>��λ(ѧУ)"
			});

	// ������λ��ʾ��Ϣ
	obj.lblCompanyNotice = new Ext.form.Label({
				id : 'lblCompanyNotice',
				cls : 'textfield-red',
				anchor : '97%'
			});

    /*
	// ������ַ
	obj.txtIDAddress = new Ext.form.TextField({
				id : 'txtIDAddress',
				width : 100,
				anchor : '95%',
				labelSeparator :'', 
				fieldLabel : "������ַ"
			});
	*/		
	// ��סַ�����
	obj.txtAddress = new Ext.form.TextField({
				id : 'txtAddress',
				//width : 100,
				anchor : '95%',
				//readOnly : true,
				labelSeparator :'', 
				fieldLabel : "<font color='red'>*</font>��סַ"
			});

	// ʡ���С��ء��硢�ֵ����ƺ�**********************************��ʼ
	obj.cboProvinceStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection(
			{
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboProvinceStore = new Ext.data.Store({
				proxy : obj.cboProvinceStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'ID'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'ID',
									mapping : 'ID'
								}, {
									name : 'ShortDesc',
									mapping : 'ShortDesc'
								}])
			});
	obj.cboProvince = new Ext.form.ComboBox({
				id : 'cboProvince',
				store : obj.cboProvinceStore,
				minChars : 0,
				displayField : 'ShortDesc',
				fieldLabel : 'ʡ',
				labelSeparator :'', 
				valueField : 'ID',
				queryDelay : 10,
				emptyText : '��ѡ��',
				minLength : 0,
				width : 100,
				anchor : '99%',
				editable : false
			});
	obj.cboCityStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboCityStore = new Ext.data.Store({
				proxy : obj.cboCityStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'ID'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'ID',
									mapping : 'ID'
								}, {
									name : 'ShortDesc',
									mapping : 'ShortDesc'
								}])
			});
	obj.cboCity = new Ext.form.ComboBox({
				id : 'cboCity',
				store : obj.cboCityStore,
				minChars : 0,
				displayField : 'ShortDesc',
				fieldLabel : '��',
				labelSeparator :'', 
				emptyText : '��ѡ��',
				valueField : 'ID',
				queryDelay : 10,
				width : 100,
				anchor : '99%',
				editable : false
			});
	obj.cboCountyStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboCountyStore = new Ext.data.Store({
				proxy : obj.cboCountyStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'ID'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'ID',
									mapping : 'ID'
								}, {
									name : 'ShortDesc',
									mapping : 'ShortDesc'
								}])
			});
	obj.cboCounty = new Ext.form.ComboBox({
				id : 'cboCounty',
				minChars : 0,
				store : obj.cboCountyStore,
				valueField : 'ID',
				fieldLabel : '��',
				labelSeparator :'', 
				emptyText : '��ѡ��',
				displayField : 'ShortDesc',
				width : 100,
				anchor : '99%',
				editable : false
			});
	obj.cboVillageStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboVillageStore = new Ext.data.Store({
				proxy : obj.cboVillageStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'ID'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'ID',
									mapping : 'ID'
								}, {
									name : 'ShortDesc',
									mapping : 'ShortDesc'
								}])
			});
	obj.cboVillage = new Ext.form.ComboBox({
				id : 'cboVillage',
				minChars : 0,
				store : obj.cboVillageStore,
				fieldLabel : '��',
				labelSeparator :'', 
				emptyText : '��ѡ��',
				displayField : 'ShortDesc',
				valueField : 'ID',
				width : 100,
				anchor : '99%',
				editable : false
			});
	obj.txtRoad = new Ext.form.TextField({
				id : 'txtRoad',
				fieldLabel : '�ֵ������ƺ�',
				labelSeparator :'', 
				anchor : '100%'
				//width : 200
			});
	// ʡ���С��ء��硢�ֵ����ƺ�**********************************����

	// ��1�е�1�У�ְҵ��������Ϊ��Ⱥ����
	// ��1�е�2�У���ϵ�绰
	obj.PanelRow1Col1 = new Ext.Panel({
				id : 'PanelRow1Col1',
				labelWidth : 75,
				labelAlign : 'right',
				columnWidth : 0.25,
				layout : 'form',
				items : [obj.cboOccupation, obj.txtTel]
			});

	// ��2�е�1�У�����
	// ��2�е�2�У��ҳ�����
	obj.PanelRow1Col2 = new Ext.Panel({
				id : 'PanelRow1Col2',
				labelWidth : 70,
				labelAlign : 'right',
				columnWidth : 0.25,
				layout : 'form',
				items : [obj.cboRegion, obj.txtRelationName]
			});

	// ��3�е�1�У����֤�� //��Ϊ֤������
	// ��3�е�2�У��ҳ�������ʾ��Ϣ
	obj.PanelRow1Col3 = new Ext.Panel({
				id : 'PanelRow1Col3',
				labelWidth : 70,
				labelAlign : 'right',
				columnWidth : 0.25,
				layout : 'form',
				items : [obj.cboCardType, obj.lblRelationNotice]
			});
	// add 20160111 ����PanelRow1Col4 ��֤������
	obj.PanelRow1Col4 = new Ext.Panel({
				id : 'PanelRow1Col4',
				labelWidth : 80,
				labelAlign : 'right',
				columnWidth : 0.20,
				layout : 'form',
				items : [obj.txtPatCardNo,obj.lblCardNotice]
			});
	obj.PanelRow1Col5 = new Ext.Panel({
				id : 'PanelRow1Col5',
				labelWidth : 80,
				labelAlign : 'right',
				columnWidth : 0.05,
				layout : 'form',
				items : []
			});
	// ���˻�����Ϣ���-�ڶ�����Panel
	// ����obj.PanelRow1Col1��obj.PanelRow1Col2��obj.PanelRow1Col3,obj.PanelRow1Col4
	obj.PanelRow1 = new Ext.Panel({
				id : 'PanelRow1',
				buttonAlign : 'center',
				layout : 'column',
				items : [obj.PanelRow1Col1, obj.PanelRow1Col2, obj.PanelRow1Col3,obj.PanelRow1Col4,obj.PanelRow1Col5]
			});

	// ����obj.txtCompany��������λ��//��Ϊ������λ(ѧУ)
	obj.PanelRow2Col1 = new Ext.Panel({
				id : 'PanelRow2Col1',
				labelWidth : 75,
				labelAlign : 'right',
				columnWidth : 0.5,
				layout : 'form',
				items : [obj.txtCompany]
			});

	// ����obj.lblCompanyNotice��������λ��ʾ��Ϣ��
	obj.PanelRow2Col2 = new Ext.Panel({
				id : 'PanelRow2Col2',
				labelWidth : 70,
				labelAlign : 'right',
				columnWidth : 0.45,
				layout : 'form',
				items : [obj.lblCompanyNotice]
			});

	// ���˻�����Ϣ���-��������Panel
	// ������������λ��������λ��ʾ��Ϣ
	// ����obj.PanelRow2Col1��obj.PanelRow2Col2
	obj.PanelRow2 = new Ext.Panel({
				id : 'PanelRow2',
				buttonAlign : 'center',
				layout : 'column',
				items : [obj.PanelRow2Col1, obj.PanelRow2Col2]
			});

	// ���˻�����Ϣ���-���ĸ���Panel
	// ������������ַ����סַ
	// ����obj.txtIDAddress��obj.txtAddress
	obj.PanelRow3 = new Ext.Panel({
				id : 'PanelRow3',
				labelWidth : 75,
				labelAlign : 'right',
				columnWidth : 0.95,
				layout : 'form',
				items : [obj.txtAddress] // 2016���°洫Ⱦ��ȥ��������ַ
			});

	// ����obj.cboProvince��ʡ��
	obj.PanelRow4Col1 = new Ext.Panel({
				id : 'PanelRow4Col1',
				labelWidth : 75,
				labelAlign : 'right',
				columnWidth : 0.20,
				layout : 'form',
				items : [obj.cboProvince]
			});

	// ����obj.cboCity���У�
	obj.PanelRow4Col2 = new Ext.Panel({
				id : 'PanelRow4Col2',
				labelWidth : 30,
				labelAlign : 'right',
				columnWidth : 0.20,
				layout : 'form',
				items : [obj.cboCity]
			});

	// ����obj.cboCounty���أ�
	obj.PanelRow4Col3 = new Ext.Panel({
				id : 'PanelRow4Col3',
				labelWidth : 30,
				labelAlign : 'right',
				columnWidth : 0.20,
				layout : 'form',
				items : [obj.cboCounty]
			});

	// ����obj.cboVillage���磩
	obj.PanelRow4Col4 = new Ext.Panel({
				id : 'PanelRow4Col4',
				labelWidth : 30,
				labelAlign : 'right',
				columnWidth : 0.15,
				layout : 'form',
				items : [obj.cboVillage]
			});

	// ����obj.txtRoad���ֵ����ƺţ�
	obj.PanelRow4Col5 = new Ext.Panel({
				id : 'PanelRow4Col5',
				labelWidth : 85,
				labelAlign : 'right',
				columnWidth : 0.20,
				layout : 'form',
				items : [obj.txtRoad]
			});
obj.PanelRow4Col6 = new Ext.Panel({
				id : 'PanelRow4Col6',
				labelWidth : 80,
				labelAlign : 'right',
				columnWidth : 0.05,
				layout : 'form',
				items : []
			});
	// ���˻�����Ϣ���-�������Panel
	// ������ʡ���С��ء��硢�ֵ����ƺ�
	// ����obj.PanelRow4Col1��obj.PanelRow4Col2��obj.PanelRow4Col3��obj.PanelRow4Col4��obj.PanelRow4Col5
	obj.PanelRow4 = new Ext.Panel({
				id : 'PanelRow4',
				layout : 'column',
				items : [obj.PanelRow4Col1, obj.PanelRow4Col2, obj.PanelRow4Col3, obj.PanelRow4Col4, obj.PanelRow4Col5,obj.PanelRow4Col6]
			});

	// ���˻�����Ϣ�ܰ��
	obj.PanelRow00 = new Ext.Panel({
				id : 'PanelRow00',
				layout : 'form',
				frame : false,
				title : "���˻�����Ϣ",
				iconCls : 'icon-PatInfo',
				anchor : '99.999%',
				items : [obj.PanelRow0, obj.PanelRow1, obj.PanelRow2, obj.PanelRow4, obj.PanelRow3]
			});

	// ***************************************************************************
	// ��Ⱦ����Ϣ
	// ***************************************************************************
	// ��ϣ����
	obj.cboDiseaseStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboDiseaseStore = new Ext.data.Store({
		proxy : obj.cboDiseaseStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'myid'
		}, [
			{name : 'checked',mapping : 'checked'}
			,{name : 'RowID',mapping : 'RowID'}
			,{name : 'MIFDisease',mapping : 'MIFDisease'}
		])
	});
	obj.cboDisease = new Ext.form.ComboBox({
		id : 'cboDisease',
		store : obj.cboDiseaseStore,
		minChars : 0,
		width : 180,
		//anchor : '99%',
		fieldLabel : "<font color='red'>*</font>���",
				labelSeparator :'', 
		mode : 'remote',
		//mode : 'local',
		emptyText : '��ѡ��Ⱦ�����',
		selectOnFocus : true,
		forceSelection : true,
		typeAhead : true,
		triggerAction : 'all',
		valueField : 'RowID',
		displayField : 'MIFDisease'
	});
			
	// ��Ϸ��ࣨ���
	obj.cboDegreeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboDegreeStore = new Ext.data.Store({
				proxy : obj.cboDegreeStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'Code'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'Code',
									mapping : 'Code'
								}, {
									name : 'Description',
									mapping : 'Description'
								}])
			});
	obj.cboDegree = new Ext.form.ComboBox({
				id : 'cboDegree',
				width : 180,
				//anchor : '99%',
				store : obj.cboDegreeStore,
				displayField : 'Description',
				minChars : 1,
				mode : 'local',
				selectOnFocus : true,
				forceSelection : true,
				typeAhead : true,
				emptyText : '��ѡ��',
				editable : false,
				fieldLabel : "<font color='red'>*</font>��������",
				labelSeparator :'', 
				valueField : 'Code',
				triggerAction : 'all'
			});
			
	// �Ӵ����
	obj.cboIntimateStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection(
			{
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboIntimateStore = new Ext.data.Store({
				proxy : obj.cboIntimateStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'Code'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'Code',
									mapping : 'Code'
								}, {
									name : 'Description',
									mapping : 'Description'
								}])
			});
	obj.cboIntimate = new Ext.form.ComboBox({
				id : 'cboIntimate',
				//anchor : '99%',
				fieldLabel : "�Ӵ����",  //<font color='red'>*</font>
				labelSeparator :'', 
				width : 180,
				store : obj.cboIntimateStore,
				minChars : 1,
				emptyText : '��ѡ��',
				editable : true,  //update by zf 20111014 �Ӵ����Ϊ�Ǳ�����
				selectOnFocus : true,
				forceSelection : true,
				typeAhead : true,
				displayField : 'Description',
				valueField : 'Code',
				triggerAction : 'all'
			});
			
	// �������ڣ����
	obj.dtSickDate = new Ext.form.DateField({
				id : 'dtSickDate',
				//anchor : '99%',
				fieldLabel : "<font color='red'>*</font>��������",
				labelSeparator :'', 
				width : 180,
				emptyText : '��ѡ��'
				//,format : 'Y-m-d'
				,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
			});

	// �������
	// Modify By PanLei 2012-03-20 ҽ��վ�����޸��������(Ĭ��Ϊ��ǰ����)����Ⱦ��������޸�
	if (LocFlag > 0) {
		obj.dtDiagnoseDate = new Ext.form.DateField({
			id : 'dtDiagnoseDate',
			//format : 'Y-m-d H:i',
			format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)+" H:i",
			//anchor : '99%',
			fieldLabel : "<font color='red'>*</font>�������",
				labelSeparator :'', 
			emptyText : '��ѡ��',
			//disabled : true,
			altFormats : 'Y-m-d H:i|d/m/Y H:i',
			width : 180
		});
	} else {
		obj.dtDiagnoseDate = new Ext.form.DateField({
			id : 'dtDiagnoseDate',
			//format : 'Y-m-d H:i',
			format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)+" H:i",
			//anchor : '99%',
			fieldLabel : "<font color='red'>*</font>�������",
			labelSeparator :'', 
			emptyText : '��ѡ��',
			disabled : true,
			altFormats : 'Y-m-d H:i|d/m/Y H:i',
			width : 180
		});
	}
			
	// ��������
	obj.dtDeadDate = new Ext.form.DateField({
		id : 'dtDeadDate',
		//format : 'Y-m-d',
		format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat),		
		width : 180,
		//anchor : '99%',
		emptyText : '��ѡ��',
		labelSeparator :'', 
		fieldLabel : '��������'
	});

	// �����̶ȣ����
	obj.cboSickKindStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection(
			{
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.cboSickKindStore = new Ext.data.Store({
				proxy : obj.cboSickKindStoreProxy,
				reader : new Ext.data.JsonReader({
							root : 'record',
							totalProperty : 'total',
							idProperty : 'Code'
						}, [{
									name : 'checked',
									mapping : 'checked'
								}, {
									name : 'Code',
									mapping : 'Code'
								}, {
									name : 'Description',
									mapping : 'Description'
								}])
			});
	obj.cboSickKind = new Ext.form.ComboBox({
				id : 'cboSickKind',
				width : 230,
				//anchor : '99%',
				store : obj.cboSickKindStore,
				minChars : 1,
				mode : 'local',
				emptyText : '��ѡ��',
				editable : true,  //update by zf 20111014 �����̶�Ϊ�Ǳ�����
				selectOnFocus : true,
				forceSelection : true,
				typeAhead : true,
				displayField : 'Description',
				fieldLabel : "�����̶�",  //<font color='red'>*</font>
				labelSeparator :'', 
				valueField : 'Code',
				triggerAction : 'all'
			});

	// ��ע
	obj.txtResumeText = new Ext.form.TextArea({
				id : 'txtResumeText',
				width : 230,
				height : 50,
				//anchor : '99%',
				labelSeparator :'', 
				fieldLabel : '��ע'
			});

	// ��Ⱦ����Ϣ���-��һ�д�Panel
	// ��������ϡ���Ϸ��ࡢ�Ӵ����
	obj.PanelRow5Col1 = new Ext.Panel({
				id : 'PanelRow5Col1',
				buttonAlign : 'center',
				columnWidth : 0.3,
				layout : 'form',
				items : [obj.cboDisease, obj.cboDegree, obj.cboIntimate]
			});

	// ��Ⱦ����Ϣ���-�ڶ��д�Panel
	// �������������ڡ�������ڡ���������
	obj.PanelRow5Col2 = new Ext.Panel({
				id : 'PanelRow5Col2',
				buttonAlign : 'center',
				columnWidth : 0.3,
				layout : 'form',
				items : [obj.dtSickDate, obj.dtDiagnoseDate, obj.dtDeadDate]
			});

	// ��Ⱦ����Ϣ���-�����д�Panel
	// �����������̶ȡ���ע
	obj.PanelRow5Col3 = new Ext.Panel({
				id : 'PanelRow5Col3',
				buttonAlign : 'center',
				columnWidth : 0.4,
				layout : 'form',
				items : [obj.cboSickKind, obj.txtResumeText]
			});

	// ��Ⱦ����Ϣ�ܰ��
	obj.PanelRow5 = new Ext.Panel({
				id : 'PanelRow5',
				labelWidth : 70,
				labelAlign : 'right',
				layout : 'column',
				title : '��Ⱦ����Ϣ',
				iconCls : 'icon-DiseaseInfo',
				frame : false,
				anchor : '99.999%',
				items : [obj.PanelRow5Col1, obj.PanelRow5Col2, obj.PanelRow5Col3]
			});

	// ***************************************************************************
	// ��Ⱦ��������Ϣ
	// ***************************************************************************
	obj.AppendixGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection(
			{
				url : ExtToolSetting.RunQueryPageURL
			}));
	obj.AppendixGridPanelStore = new Ext.data.Store({
				proxy : obj.AppendixGridPanelStoreProxy,
				reader : new Ext.data.JsonReader({
						root : 'record',
						totalProperty : 'total',
						idProperty : 'AppendixItemID'
					}, [
						{name : 'checked',mapping : 'checked'}
						,{name : 'RowID',mapping : 'RowID'}
						,{name : 'ItemCaption',mapping : 'ItemCaption'}
						,{name : 'ItemValue',mapping : 'ItemValue'}
						,{name : 'ItemType',mapping : 'ItemType'}
						,{name : 'ItemDic',mapping : 'ItemDic'}
						,{name : 'AppendixItemID',mapping : 'AppendixItemID'}
						,{name : 'HiddenValue',mapping : 'HiddenValue'}
						,{name : 'NoticeText',mapping : 'NoticeText'}
						,{name : 'IsNecess',mapping : 'IsNecess'}
					]
				)
			});
	obj.AppendixGridPanel = new Ext.grid.EditorGridPanel({
				id : 'AppendixGridPanel',
				store : obj.AppendixGridPanelStore,
				buttonAlign : 'center',
				columns : [{
							header : '��Ŀ',
							width : 100,
							dataIndex : 'ItemCaption',
							sortable : false
						}, {
							header : 'ֵ(����д���У�˫���༭��ѡ��)',
							width : 100,
							id : 'valueCol',
							dataIndex : 'ItemValue',
							sortable : false,
							editor : new Ext.form.TextField({})
						}, {
							header : '��������',
							width : 50,
							dataIndex : 'NoticeText',
							sortable : false
						}, {
							header : '�Ƿ����',
							width : 50,
							dataIndex : 'IsNecess',
							sortable : false
						}
				],
				viewConfig : {
					forceFit : true
				}
			});

	obj.PanelRow6 = new Ext.Panel({
				id : 'PanelRow6',
				buttonAlign : 'center',
				title : '������Ϣ',
				layout : 'fit',
				autoScroll : true,
				height : 250,
				frame : false,
				iconCls : 'icon-EpdInfo',
				anchor : '99.999%',
				items : [obj.AppendixGridPanel]
			});

	// �ܰ�飨����ť�������⣩
	obj.PanelReport = new Ext.form.FormPanel({
				id : 'PanelReport',
				buttonAlign : 'center',
				labelAlign : 'right',
				autoScroll : true,
				layout : 'form',
				//frame : true,
				border : true,
				anchor : '99%',
				items : [obj.PanelRow00, obj.PanelRow5, obj.PanelRow6
				//,obj.PanelRow7
				]
			});

	// �����ĵ�˵��ģ��**************************************************Start
	//obj.PanelRow7 = new Ext.Panel({
	//			id : 'PanelRow7',
	//			layout : 'fit',
	//			modal : true,
	//			renderTo : Ext.getBody(),
	//			autoScroll : true
	//		});
	//obj.tplhelpInfo = new Ext.XTemplate(
	//		'<table border=.1 width=100% align=center>', '<tr>',
	//		'<td>{helpInfo}</td>', '</tr>', '</table>');
	//var tplHelpInfoData = {
	//	helpInfo : "�����ĵ�˵����"
	//};
	//obj.tplhelpInfo.compile();
	//obj.tplhelpInfo.overwrite(obj.PanelRow7.body, tplHelpInfoData);
	// �����ĵ�˵��ģ��***************************************************End

	// ���ܰ�ť*********************************************************Start
	obj.btnSaveTmp = new Ext.Button({
				id : 'btnSaveTmp',
				width : 75,
				iconCls : 'icon-temp',
				text : '�ݸ�'
			});

	obj.btnSave = new Ext.Button({
				id : 'btnSave',
				width : 75,
				iconCls : 'icon-save',
				text : '�ϱ�'
			});
			
	obj.btnCheck = new Ext.Button({
				id : 'btnCheck',
				width : 75,
				iconCls : 'icon-check',
				text : '���'
			});
	obj.btnUpdoCheck = new Ext.Button({
				id : 'btnUpdoCheck',
				width : 75,
				iconCls : 'icon-undo',
				text : 'ȡ�����'
			});
			
	obj.btnCorrect = new Ext.Button({
				id : 'btnCorrect',
				width : 75,
				iconCls : 'icon-update',
				text : '����'
			});
			
	obj.btnReturn = new Ext.Button({
				id : 'btnReturn',
				width : 75,
				iconCls : 'icon-cancel',
				text : '�˻�'
			});
			
	obj.btnDelete = new Ext.Button({
				id : 'btnDelete',
				width : 75,
				iconCls : 'icon-delete',
				text : 'ɾ��'
			});
			
	obj.btnUpdateCDC = new Ext.Button({
				id : 'btnUpdateCDC',
				width : 75,
				iconCls : 'icon-add',
				text : '�ϱ�CDC'
			});

	obj.btnPrint = new Ext.Button({
				id : 'btnPrint',
				width : 75,
				iconCls : 'icon-print',
				text : '��ӡ'
			});

	obj.btnClose = new Ext.Button({
				id : 'btnClose',
				width : 75,
				iconCls : 'icon-close',
				text : '�ر�'
			});
	obj.btnOutHospReport = new Ext.Button({
		id : 'btnOutHospReport',
		width : 75,
		text : '��Ժ�ѱ�'
	});
	// ���ܰ�ť*********************************************************End
	
	// �ܰ��
	obj.framePanel = new Ext.Panel({
				id : 'framePanel',
				layout : 'fit',
				frame : false,
				buttonAlign : 'center',
				//width : 800,
				items : [obj.PanelReport],
				buttons : [obj.btnSaveTmp, obj.btnSave, obj.btnCheck, obj.btnUpdoCheck, obj.btnCorrect, obj.btnReturn, obj.btnDelete, obj.btnUpdateCDC, obj.btnPrint, obj.btnClose]
			});

	obj.viewScreen = new Ext.Viewport({
				id : 'viewScreen',
				layoutConfig : {
					padding : '0',
					align : 'left'
				},
				layout : 'fit',
				items : [obj.framePanel]
			});
	
	//ְҵ���������ݵ�׼��������
	obj.cboOccupationStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = 'Career';
				param.ArgCnt = 1;
			});

	// ���򣨼������ݵ�׼��������
	obj.cboRegionStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = "EpidemicReportRegion";
				param.ArgCnt = 1;
			});
			
	// ʡ���������ݵ�׼��������
	obj.cboProvinceStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.EPD.AreaDic';
				param.QueryName = 'QryArea';
				param.Arg1 = '';
				param.Arg2 = 1;
				param.Arg3 = '';
				param.Arg4 = '';
				param.Arg5 = '';
				param.ArgCnt = 5;
			});
	
	// �У��������ݵ�׼��������
	obj.cboCityStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.EPD.AreaDic';
				param.QueryName = 'QryArea';
				param.Arg1 = '';
				param.Arg2 = obj.cboProvince.getValue();
				param.Arg3 = '';
				param.Arg4 = '';
				param.Arg5 = '';
				param.ArgCnt = 5;
			});

	// �أ��������ݵ�׼��������
	obj.cboCountyStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.EPD.AreaDic';
				param.QueryName = 'QryArea';
				param.Arg1 = '';
				param.Arg2 = obj.cboCity.getValue();
				param.Arg3 = '';
				param.Arg4 = '';
				param.Arg5 = '';
				param.ArgCnt = 5;
			});

	// �磨�������ݵ�׼��������
	obj.cboVillageStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.EPD.AreaDic';
				param.QueryName = 'QryArea';
				param.Arg1 = '';
				param.Arg2 = obj.cboCounty.getValue();
				param.Arg3 = '';
				param.Arg4 = '';
				param.Arg5 = '';
				param.ArgCnt = 5;
			});
			
	// ��ϣ��������ݵ�׼��������
	obj.cboDiseaseStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.EPDService.InfectionSrv';
		param.QueryName = 'QryInfection';
		param.Arg1 = obj.cboDisease.getRawValue();
		param.Arg2 = IFRowID;
		param.ArgCnt = 2;
	});
			
	// ��Ϸ��ࣨ�������ݵ�׼��������
	obj.cboDegreeStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = 'EpidemicDiagnoseDegree';
				param.ArgCnt = 1;
			});
			
	// �����̶ȣ��������ݵ�׼��������
	obj.cboSickKindStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = "EpidemicSickQuality";
				param.ArgCnt = 1;
			});

	//�Ӵ�������������ݵ�׼��������
	obj.cboIntimateStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = 'EpidemicContact';
				param.ArgCnt = 1;
			});
	
	//֤�����ͣ��������ݵ�׼��������
	obj.cboCardTypeStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = 'EpidemicCardType';
				param.ArgCnt = 1;
			});
	
	//document.getElementById("PanelRow00").className='subtitle';
	// ������obj�������з���������obj����
	InitviewScreenEvent(obj);
	
	// �ڿͻ��˲���ǰ���Զ���ʼ��ִ��������¼�
	obj.LoadEvent(arguments);
	
	return obj;
}