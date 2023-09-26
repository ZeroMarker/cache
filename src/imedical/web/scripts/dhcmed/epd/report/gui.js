function InitviewScreen() {
	window.returnValue = false;
	var obj = new Object();
	
	obj.objCurrPatient = null;			// 当前病人对象
	obj.objCurrPaadm = null;			// 当前病人就诊对象
	obj.objCurrReport = null;			// 当前传染病报告对象
	obj.objCurrReportStatus = null;		// 当前报告状态对象
	obj.objCurrRepPlace = null; 		// 当前上报位置对象(全部、病房、急诊、门诊)
	obj.objCurrRepCtloc = null; 		// 当前上报科室对象
	obj.objCurrRepUser = null; 		    // 当前上报用户对象
	obj.EpdRepPatRelNotice = "";		// 当前上报界面“家长姓名”文本框旁边的提示信息
	obj.EpdRepPatCompanyNotice = "";	// 当前上报界面“工作单位”文本框旁边的提示信息
	
	obj.EpdRepCardNotice = "";	  // 有效证件号文本框旁边的提示信息

	// 如果病人信息不存在，则退出
	if (PatientID == "" || EpisodeID == "") {
		ExtTool.alert("提示信息", "抱歉，病人信息不存在!<br>请确认后，重新操作!");
		return;
	}

	// 病人基本信息板块-第一个大Panel
	obj.PanelRow0 = new Ext.Panel({
				id : 'PanelRow0',
				layout : 'fit',
				modal : true,
				renderTo : Ext.getBody(),
				autoScroll : true
			});

	// 病人基本信息模板
	obj.tplBaseInfo = new Ext.XTemplate(
			'<table border=.1 width=100% align=center>',
				'<tr>',
					'<td width=7% align="right">登记号：</td><td width=18% align="left">{PapmiNo}</td>',
					'<td width=6% align="right">姓名：</td><td width=19% align="left">{PatientName}</td>',
					'<td width=6% align="right">性别：</td><td width=19% align="left">{Sex}</td>',
					'<td width=7% align="right">报告科室：</td><td width=18% align="left">{RepLoc}</td>',
				'</tr>',
				'<tr>',                                    
					'<td width=7% align="right">病案号：</td><td width=18% align="left">{InPatientMrNo}</td>',
					'<td width=6% align="right">年龄：</td><td width=19% align="left">{Age}</td>',
					'<td width=6% align="right">病区：</td><td width=19% align="left">{RepWard}</td>',
					'<td width=7% align="right">报告位置：</td><td width=18% align="left">{RepPlace}</td>',
				'</tr>',                
				'<tr>',                
					'<td width=7% align="right">报告人：</td><td width=18% align="left">{RepUser}</td>',
					'<td width=6% align="right">报告状态：</td><td width=19% align="left">{RepStatus}</td>',
					'<td width=6% align="right">病人密级：</td><td width=19% align="left">{EncryptLevel}</td>',
					'<td width=7% align="right">病人级别：</td><td width=18% align="left">{PatLevel}</td>',
				'</tr>',
			'</table>');

	// ***************************************************************************
	// 病人基本信息（针对报告表单项）
	// ***************************************************************************
	// 职业（必填）
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
				fieldLabel : "<font color='red'>*</font>人群分类",
				labelSeparator :'', 
				store : obj.cboOccupationStore,
				emptyText : '请选择',
				editable : false,
				mode : 'local',
				selectOnFocus : true,
				forceSelection : true,
				typeAhead : true,
				triggerAction : 'all',
				valueField : 'Code'
			});
			
	// 区域（必填）
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
				fieldLabel : "<font color='red'>*</font>病人属于",
				labelSeparator :'', 
				store : obj.cboRegionStore,
				emptyText : '请选择',
				editable : false,
				mode : 'local',
				selectOnFocus : true,
				forceSelection : true,
				typeAhead : true,
				triggerAction : 'all',
				valueField : 'Code',
				displayField : 'Description'
			});
			
			
	// add 20160111 证件类型
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
				fieldLabel : "<font color='red'>*</font>证件类型",
				labelSeparator :'', 
				store : obj.cboCardTypeStore,
				emptyText : '请选择',
				editable : false,
				mode : 'local',
				selectOnFocus : true,
				forceSelection : true,
				typeAhead : true,
				triggerAction : 'all',
				valueField : 'Code',
				displayField : 'Description'
			});
	//有效证件号提示信息
	obj.lblCardNotice = new Ext.form.Label({
				id : 'lblCardNotice',
				cls : 'textfield-red',
				anchor : '97%'
			});
			
	// 身份证号（必填）　//改为有效证件号
	obj.txtPatCardNo = new Ext.form.TextField({
				id : 'txtPatCardNo',
				fieldLabel : "<font color='red'>*</font>有效证件号",
				labelSeparator :'', 
				//readOnly : true,
				anchor : '100%'
				//width : 200
			});
		
	// 联系电话（必填）
	obj.txtTel = new Ext.form.TextField({
				id : 'txtTel',
				fieldLabel : "<font color='red'>*</font>联系电话",
				labelSeparator :'', 
				//readOnly : true,
				//anchor : '99%',
				width : 180
			});
		
	// 家长姓名（条件：“年龄小于14周岁患者必须填写家长姓名”）
	obj.txtRelationName = new Ext.form.TextField({
				id : 'txtRelationName',
				fieldLabel : "家长姓名",
				labelSeparator :'', 
				//readOnly : true,
				anchor : '100%'
				//width : 180
			});

	// 家长姓名提示信息
	obj.lblRelationNotice = new Ext.form.Label({
				id : 'lblRelationNotice',
				cls : 'textfield-red',
				anchor : '95%'
			});
	
	// 工作单位（必填）
	obj.txtCompany = new Ext.form.TextField({
				id : 'txtCompany',
				width : 100,
				//readOnly : true,
				anchor : '100%',
				labelSeparator :'', 
				fieldLabel : "<font color='red'>*</font>单位(学校)"
			});

	// 工作单位提示信息
	obj.lblCompanyNotice = new Ext.form.Label({
				id : 'lblCompanyNotice',
				cls : 'textfield-red',
				anchor : '97%'
			});

    /*
	// 户籍地址
	obj.txtIDAddress = new Ext.form.TextField({
				id : 'txtIDAddress',
				width : 100,
				anchor : '95%',
				labelSeparator :'', 
				fieldLabel : "户籍地址"
			});
	*/		
	// 现住址（必填）
	obj.txtAddress = new Ext.form.TextField({
				id : 'txtAddress',
				//width : 100,
				anchor : '95%',
				//readOnly : true,
				labelSeparator :'', 
				fieldLabel : "<font color='red'>*</font>现住址"
			});

	// 省、市、县、乡、街道门牌号**********************************开始
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
				fieldLabel : '省',
				labelSeparator :'', 
				valueField : 'ID',
				queryDelay : 10,
				emptyText : '请选择',
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
				fieldLabel : '市',
				labelSeparator :'', 
				emptyText : '请选择',
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
				fieldLabel : '县',
				labelSeparator :'', 
				emptyText : '请选择',
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
				fieldLabel : '乡',
				labelSeparator :'', 
				emptyText : '请选择',
				displayField : 'ShortDesc',
				valueField : 'ID',
				width : 100,
				anchor : '99%',
				editable : false
			});
	obj.txtRoad = new Ext.form.TextField({
				id : 'txtRoad',
				fieldLabel : '街道、门牌号',
				labelSeparator :'', 
				anchor : '100%'
				//width : 200
			});
	// 省、市、县、乡、街道门牌号**********************************结束

	// 第1列第1行：职业　／／改为人群分类
	// 第1列第2行：联系电话
	obj.PanelRow1Col1 = new Ext.Panel({
				id : 'PanelRow1Col1',
				labelWidth : 75,
				labelAlign : 'right',
				columnWidth : 0.25,
				layout : 'form',
				items : [obj.cboOccupation, obj.txtTel]
			});

	// 第2列第1行：区域
	// 第2列第2行：家长姓名
	obj.PanelRow1Col2 = new Ext.Panel({
				id : 'PanelRow1Col2',
				labelWidth : 70,
				labelAlign : 'right',
				columnWidth : 0.25,
				layout : 'form',
				items : [obj.cboRegion, obj.txtRelationName]
			});

	// 第3列第1行：身份证号 //改为证件类型
	// 第3列第2行：家长姓名提示信息
	obj.PanelRow1Col3 = new Ext.Panel({
				id : 'PanelRow1Col3',
				labelWidth : 70,
				labelAlign : 'right',
				columnWidth : 0.25,
				layout : 'form',
				items : [obj.cboCardType, obj.lblRelationNotice]
			});
	// add 20160111 增加PanelRow1Col4 ：证件号码
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
	// 病人基本信息板块-第二个大Panel
	// 包含obj.PanelRow1Col1、obj.PanelRow1Col2、obj.PanelRow1Col3,obj.PanelRow1Col4
	obj.PanelRow1 = new Ext.Panel({
				id : 'PanelRow1',
				buttonAlign : 'center',
				layout : 'column',
				items : [obj.PanelRow1Col1, obj.PanelRow1Col2, obj.PanelRow1Col3,obj.PanelRow1Col4,obj.PanelRow1Col5]
			});

	// 包含obj.txtCompany（工作单位）//改为工作单位(学校)
	obj.PanelRow2Col1 = new Ext.Panel({
				id : 'PanelRow2Col1',
				labelWidth : 75,
				labelAlign : 'right',
				columnWidth : 0.5,
				layout : 'form',
				items : [obj.txtCompany]
			});

	// 包含obj.lblCompanyNotice（工作单位提示信息）
	obj.PanelRow2Col2 = new Ext.Panel({
				id : 'PanelRow2Col2',
				labelWidth : 70,
				labelAlign : 'right',
				columnWidth : 0.45,
				layout : 'form',
				items : [obj.lblCompanyNotice]
			});

	// 病人基本信息板块-第三个大Panel
	// 包含：工作单位、工作单位提示信息
	// 包含obj.PanelRow2Col1、obj.PanelRow2Col2
	obj.PanelRow2 = new Ext.Panel({
				id : 'PanelRow2',
				buttonAlign : 'center',
				layout : 'column',
				items : [obj.PanelRow2Col1, obj.PanelRow2Col2]
			});

	// 病人基本信息板块-第四个大Panel
	// 包含：户籍地址、现住址
	// 包含obj.txtIDAddress、obj.txtAddress
	obj.PanelRow3 = new Ext.Panel({
				id : 'PanelRow3',
				labelWidth : 75,
				labelAlign : 'right',
				columnWidth : 0.95,
				layout : 'form',
				items : [obj.txtAddress] // 2016年新版传染病去掉户籍地址
			});

	// 包含obj.cboProvince（省）
	obj.PanelRow4Col1 = new Ext.Panel({
				id : 'PanelRow4Col1',
				labelWidth : 75,
				labelAlign : 'right',
				columnWidth : 0.20,
				layout : 'form',
				items : [obj.cboProvince]
			});

	// 包含obj.cboCity（市）
	obj.PanelRow4Col2 = new Ext.Panel({
				id : 'PanelRow4Col2',
				labelWidth : 30,
				labelAlign : 'right',
				columnWidth : 0.20,
				layout : 'form',
				items : [obj.cboCity]
			});

	// 包含obj.cboCounty（县）
	obj.PanelRow4Col3 = new Ext.Panel({
				id : 'PanelRow4Col3',
				labelWidth : 30,
				labelAlign : 'right',
				columnWidth : 0.20,
				layout : 'form',
				items : [obj.cboCounty]
			});

	// 包含obj.cboVillage（乡）
	obj.PanelRow4Col4 = new Ext.Panel({
				id : 'PanelRow4Col4',
				labelWidth : 30,
				labelAlign : 'right',
				columnWidth : 0.15,
				layout : 'form',
				items : [obj.cboVillage]
			});

	// 包含obj.txtRoad（街道门牌号）
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
	// 病人基本信息板块-第五个大Panel
	// 包含：省、市、县、乡、街道门牌号
	// 包含obj.PanelRow4Col1、obj.PanelRow4Col2、obj.PanelRow4Col3、obj.PanelRow4Col4、obj.PanelRow4Col5
	obj.PanelRow4 = new Ext.Panel({
				id : 'PanelRow4',
				layout : 'column',
				items : [obj.PanelRow4Col1, obj.PanelRow4Col2, obj.PanelRow4Col3, obj.PanelRow4Col4, obj.PanelRow4Col5,obj.PanelRow4Col6]
			});

	// 病人基本信息总板块
	obj.PanelRow00 = new Ext.Panel({
				id : 'PanelRow00',
				layout : 'form',
				frame : false,
				title : "病人基本信息",
				iconCls : 'icon-PatInfo',
				anchor : '99.999%',
				items : [obj.PanelRow0, obj.PanelRow1, obj.PanelRow2, obj.PanelRow4, obj.PanelRow3]
			});

	// ***************************************************************************
	// 传染病信息
	// ***************************************************************************
	// 诊断（必填）
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
		fieldLabel : "<font color='red'>*</font>诊断",
				labelSeparator :'', 
		mode : 'remote',
		//mode : 'local',
		emptyText : '请选择传染病诊断',
		selectOnFocus : true,
		forceSelection : true,
		typeAhead : true,
		triggerAction : 'all',
		valueField : 'RowID',
		displayField : 'MIFDisease'
	});
			
	// 诊断分类（必填）
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
				emptyText : '请选择',
				editable : false,
				fieldLabel : "<font color='red'>*</font>病例分类",
				labelSeparator :'', 
				valueField : 'Code',
				triggerAction : 'all'
			});
			
	// 接触情况
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
				fieldLabel : "接触情况",  //<font color='red'>*</font>
				labelSeparator :'', 
				width : 180,
				store : obj.cboIntimateStore,
				minChars : 1,
				emptyText : '请选择',
				editable : true,  //update by zf 20111014 接触情况为非必填项
				selectOnFocus : true,
				forceSelection : true,
				typeAhead : true,
				displayField : 'Description',
				valueField : 'Code',
				triggerAction : 'all'
			});
			
	// 发病日期（必填）
	obj.dtSickDate = new Ext.form.DateField({
				id : 'dtSickDate',
				//anchor : '99%',
				fieldLabel : "<font color='red'>*</font>发病日期",
				labelSeparator :'', 
				width : 180,
				emptyText : '请选择'
				//,format : 'Y-m-d'
				,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
			});

	// 诊断日期
	// Modify By PanLei 2012-03-20 医生站不能修改诊断日期(默认为当前日期)，感染办则可以修改
	if (LocFlag > 0) {
		obj.dtDiagnoseDate = new Ext.form.DateField({
			id : 'dtDiagnoseDate',
			//format : 'Y-m-d H:i',
			format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)+" H:i",
			//anchor : '99%',
			fieldLabel : "<font color='red'>*</font>诊断日期",
				labelSeparator :'', 
			emptyText : '请选择',
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
			fieldLabel : "<font color='red'>*</font>诊断日期",
			labelSeparator :'', 
			emptyText : '请选择',
			disabled : true,
			altFormats : 'Y-m-d H:i|d/m/Y H:i',
			width : 180
		});
	}
			
	// 死亡日期
	obj.dtDeadDate = new Ext.form.DateField({
		id : 'dtDeadDate',
		//format : 'Y-m-d',
		format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat),		
		width : 180,
		//anchor : '99%',
		emptyText : '请选择',
		labelSeparator :'', 
		fieldLabel : '死亡日期'
	});

	// 发病程度（必填）
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
				emptyText : '请选择',
				editable : true,  //update by zf 20111014 发病程度为非必填项
				selectOnFocus : true,
				forceSelection : true,
				typeAhead : true,
				displayField : 'Description',
				fieldLabel : "发病程度",  //<font color='red'>*</font>
				labelSeparator :'', 
				valueField : 'Code',
				triggerAction : 'all'
			});

	// 备注
	obj.txtResumeText = new Ext.form.TextArea({
				id : 'txtResumeText',
				width : 230,
				height : 50,
				//anchor : '99%',
				labelSeparator :'', 
				fieldLabel : '备注'
			});

	// 传染病信息板块-第一列大Panel
	// 包含：诊断、诊断分类、接触情况
	obj.PanelRow5Col1 = new Ext.Panel({
				id : 'PanelRow5Col1',
				buttonAlign : 'center',
				columnWidth : 0.3,
				layout : 'form',
				items : [obj.cboDisease, obj.cboDegree, obj.cboIntimate]
			});

	// 传染病信息板块-第二列大Panel
	// 包含：发病日期、诊断日期、死亡日期
	obj.PanelRow5Col2 = new Ext.Panel({
				id : 'PanelRow5Col2',
				buttonAlign : 'center',
				columnWidth : 0.3,
				layout : 'form',
				items : [obj.dtSickDate, obj.dtDiagnoseDate, obj.dtDeadDate]
			});

	// 传染病信息板块-第三列大Panel
	// 包含：发病程度、备注
	obj.PanelRow5Col3 = new Ext.Panel({
				id : 'PanelRow5Col3',
				buttonAlign : 'center',
				columnWidth : 0.4,
				layout : 'form',
				items : [obj.cboSickKind, obj.txtResumeText]
			});

	// 传染病信息总板块
	obj.PanelRow5 = new Ext.Panel({
				id : 'PanelRow5',
				labelWidth : 70,
				labelAlign : 'right',
				layout : 'column',
				title : '传染病信息',
				iconCls : 'icon-DiseaseInfo',
				frame : false,
				anchor : '99.999%',
				items : [obj.PanelRow5Col1, obj.PanelRow5Col2, obj.PanelRow5Col3]
			});

	// ***************************************************************************
	// 传染病附卡信息
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
							header : '项目',
							width : 100,
							dataIndex : 'ItemCaption',
							sortable : false
						}, {
							header : '值(仅填写此列，双击编辑或选择)',
							width : 100,
							id : 'valueCol',
							dataIndex : 'ItemValue',
							sortable : false,
							editor : new Ext.form.TextField({})
						}, {
							header : '数据类型',
							width : 50,
							dataIndex : 'NoticeText',
							sortable : false
						}, {
							header : '是否必填',
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
				title : '附卡信息',
				layout : 'fit',
				autoScroll : true,
				height : 250,
				frame : false,
				iconCls : 'icon-EpdInfo',
				anchor : '99.999%',
				items : [obj.AppendixGridPanel]
			});

	// 总板块（除按钮区域以外）
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

	// 帮助文档说明模板**************************************************Start
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
	//	helpInfo : "帮助文档说明："
	//};
	//obj.tplhelpInfo.compile();
	//obj.tplhelpInfo.overwrite(obj.PanelRow7.body, tplHelpInfoData);
	// 帮助文档说明模板***************************************************End

	// 功能按钮*********************************************************Start
	obj.btnSaveTmp = new Ext.Button({
				id : 'btnSaveTmp',
				width : 75,
				iconCls : 'icon-temp',
				text : '草稿'
			});

	obj.btnSave = new Ext.Button({
				id : 'btnSave',
				width : 75,
				iconCls : 'icon-save',
				text : '上报'
			});
			
	obj.btnCheck = new Ext.Button({
				id : 'btnCheck',
				width : 75,
				iconCls : 'icon-check',
				text : '审核'
			});
	obj.btnUpdoCheck = new Ext.Button({
				id : 'btnUpdoCheck',
				width : 75,
				iconCls : 'icon-undo',
				text : '取消审核'
			});
			
	obj.btnCorrect = new Ext.Button({
				id : 'btnCorrect',
				width : 75,
				iconCls : 'icon-update',
				text : '订正'
			});
			
	obj.btnReturn = new Ext.Button({
				id : 'btnReturn',
				width : 75,
				iconCls : 'icon-cancel',
				text : '退回'
			});
			
	obj.btnDelete = new Ext.Button({
				id : 'btnDelete',
				width : 75,
				iconCls : 'icon-delete',
				text : '删除'
			});
			
	obj.btnUpdateCDC = new Ext.Button({
				id : 'btnUpdateCDC',
				width : 75,
				iconCls : 'icon-add',
				text : '上报CDC'
			});

	obj.btnPrint = new Ext.Button({
				id : 'btnPrint',
				width : 75,
				iconCls : 'icon-print',
				text : '打印'
			});

	obj.btnClose = new Ext.Button({
				id : 'btnClose',
				width : 75,
				iconCls : 'icon-close',
				text : '关闭'
			});
	obj.btnOutHospReport = new Ext.Button({
		id : 'btnOutHospReport',
		width : 75,
		text : '外院已报'
	});
	// 功能按钮*********************************************************End
	
	// 总板块
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
	
	//职业（加载数据的准备参数）
	obj.cboOccupationStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = 'Career';
				param.ArgCnt = 1;
			});

	// 区域（加载数据的准备参数）
	obj.cboRegionStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = "EpidemicReportRegion";
				param.ArgCnt = 1;
			});
			
	// 省（加载数据的准备参数）
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
	
	// 市（加载数据的准备参数）
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

	// 县（加载数据的准备参数）
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

	// 乡（加载数据的准备参数）
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
			
	// 诊断（加载数据的准备参数）
	obj.cboDiseaseStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.EPDService.InfectionSrv';
		param.QueryName = 'QryInfection';
		param.Arg1 = obj.cboDisease.getRawValue();
		param.Arg2 = IFRowID;
		param.ArgCnt = 2;
	});
			
	// 诊断分类（加载数据的准备参数）
	obj.cboDegreeStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = 'EpidemicDiagnoseDegree';
				param.ArgCnt = 1;
			});
			
	// 发病程度（加载数据的准备参数）
	obj.cboSickKindStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = "EpidemicSickQuality";
				param.ArgCnt = 1;
			});

	//接触情况（加载数据的准备参数）
	obj.cboIntimateStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = 'EpidemicContact';
				param.ArgCnt = 1;
			});
	
	//证件类型（加载数据的准备参数）
	obj.cboCardTypeStoreProxy.on('beforeload', function(objProxy, param) {
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = 'EpidemicCardType';
				param.ArgCnt = 1;
			});
	
	//document.getElementById("PanelRow00").className='subtitle';
	// 将定义obj对象所有方法，挂入obj对象
	InitviewScreenEvent(obj);
	
	// 在客户端操作前，自动初始化执行所需的事件
	obj.LoadEvent(arguments);
	
	return obj;
}