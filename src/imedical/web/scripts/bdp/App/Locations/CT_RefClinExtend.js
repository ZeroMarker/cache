	
	/// 名称：医疗机构扩展信息维护
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2019-04-08
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
Ext.onReady(function() { 
	var CTRFCRowId=Ext.BDP.FunLib.getParam('selectrow')
	var SSUSRE_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTRefClinExtend&pClassMethod=OpenData";
	var SSUSRE_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTRefClinExtend&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTRefClinExtend"; 
  
	Ext.QuickTips.init(); 
	Ext.form.Field.prototype.msgTarget = 'qtip';
	  
	 
	/// 医疗机构地址   
	var CTRFCAddress = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '医疗机构地址',
		name : 'CTRFCAddress',
		id : 'CTRFCAddress',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCAddress'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCAddress')),
		dataIndex : 'CTRFCAddress'
	});
	/// 医疗机构等级 
	var CTRFCRank = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '医疗机构等级',
		name : 'CTRFCRank',
		id : 'CTRFCRank',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCRank'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCRank')),
		dataIndex : 'CTRFCRank'
	});
	/// 医疗机构收费等级 
	var CTRFCChargeLevel = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '医疗机构收费等级',
		name : 'CTRFCChargeLevel',
		id : 'CTRFCChargeLevel',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCChargeLevel'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCChargeLevel')),
		dataIndex : 'CTRFCChargeLevel'
	});
	/// 医疗机构类别 
	var CTRFCInstitutionType = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '医疗机构类别',
		name : 'CTRFCInstitutionType',
		id : 'CTRFCInstitutionType',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCInstitutionType'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCInstitutionType')),
		dataIndex : 'CTRFCInstitutionType'
	});
	/// 医疗机构经济类型   
	var CTRFCEconomyType = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '医疗机构经济类型',
		name : 'CTRFCEconomyType',
		id : 'CTRFCEconomyType',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCEconomyType'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCEconomyType')),
		dataIndex : 'CTRFCEconomyType'
	});
	/// 医疗机构经营性质 
	var CTRFCManageNature = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '医疗机构经营性质',
		name : 'CTRFCManageNature',
		id : 'CTRFCManageNature',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCManageNature'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCManageNature')),
		dataIndex : 'CTRFCManageNature'
	});
	/// 所有制形式 
	var CTRFCOwnershipForm = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '所有制形式',
		name : 'CTRFCOwnershipForm',
		id : 'CTRFCOwnershipForm',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCOwnershipForm'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCOwnershipForm')),
		dataIndex : 'CTRFCOwnershipForm'
	});
	
	 /// 隶属关系 
	var CTRFCSubordRelations = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '隶属关系',
		name : 'CTRFCSubordRelations',
		id : 'CTRFCSubordRelations',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCSubordRelations'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCSubordRelations')),
		dataIndex : 'CTRFCSubordRelations'
	});
	/// 服务对象 
	var CTRFCServiceObject = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '服务对象',
		name : 'CTRFCServiceObject',
		id : 'CTRFCServiceObject',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCServiceObject'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCServiceObject')),
		dataIndex : 'CTRFCServiceObject'
	});
	
	/// 主管单位名称   
	var CTRFCCompetUnitName = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '主管单位名称',
		name : 'CTRFCCompetUnitName',
		id : 'CTRFCCompetUnitName',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCCompetUnitName'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCCompetUnitName')),
		dataIndex : 'CTRFCCompetUnitName'
	});
	
/// 法定代表人  //法人姓名 
	var CTRFCPersonName = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '法定代表人',
		name : 'CTRFCPersonName',
		id : 'CTRFCPersonName',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCPersonName'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCPersonName')),
		dataIndex : 'CTRFCPersonName'
	});
	/// 法人证件类型 
	var CTRFCCertificateType = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '法人证件类型',
		name : 'CTRFCCertificateType',
		id : 'CTRFCCertificateType',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCCertificateType'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCCertificateType')),
		dataIndex : 'CTRFCCertificateType'
	});
	
	/// 法人证件号码 
	var CTRFCCertificateCode = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '法人证件号码',
		name : 'CTRFCCertificateCode',
		id : 'CTRFCCertificateCode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCCertificateCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCCertificateCode')),
		dataIndex : 'CTRFCCertificateCode'
	});
	
 /// 法人联系地址 
	var CTRFCPersonAddress = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '法人联系地址',
		name : 'CTRFCPersonAddress',
		id : 'CTRFCPersonAddress',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCPersonAddress'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCPersonAddress')),
		dataIndex : 'CTRFCPersonAddress'
	});
	
	/// 法人联系电话 
	var CTRFCPersonPhone = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '法人联系电话',
		name : 'CTRFCPersonPhone',
		id : 'CTRFCPersonPhone',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCPersonPhone'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCPersonPhone')),
		dataIndex : 'CTRFCPersonPhone'
	});
	/// 医疗机构邮政编码 
	var CTRFCZipCode = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '医疗机构邮政编码',
		name : 'CTRFCZipCode',
		id : 'CTRFCZipCode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCZipCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCZipCode')),
		dataIndex : 'CTRFCZipCode'
	});
	
	/// 社会信用代码 
	var CTRFCSociaCreditCode = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '社会信用代码',
		name : 'CTRFCSociaCreditCode',
		id : 'CTRFCSociaCreditCode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCSociaCreditCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCSociaCreditCode')),
		dataIndex : 'CTRFCSociaCreditCode'
	});
	
	/// 执业（经营）许可证号 
	var CTRFBusinessClicenseCode = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '执业(经营)许可证号',
		name : 'CTRFBusinessClicenseCode',
		id : 'CTRFBusinessClicenseCode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFBusinessClicenseCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFBusinessClicenseCode')),
		dataIndex : 'CTRFBusinessClicenseCode'
	});
	
	/// 工商营业执照 
	var CTRFCInduComBusinessLicense = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '工商营业执照',
		name : 'CTRFCInduComBusinessLicense',
		id : 'CTRFCInduComBusinessLicense',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCInduComBusinessLicense'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCInduComBusinessLicense')),
		dataIndex : 'CTRFCInduComBusinessLicense'
	});
 
	/// 税务登记代码 
	var CTRFCTaxCode = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '税务登记代码',
		name : 'CTRFCTaxCode',
		id : 'CTRFCTaxCode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCTaxCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCTaxCode')),
		dataIndex : 'CTRFCTaxCode'
	});
	
	/// 药品经营企业合格证号
	var CTRFCPhaTradCertificateCode = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '药品经营企业合格证号',
		name : 'CTRFCPhaTradCertificateCode',
		id : 'CTRFCPhaTradCertificateCode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCPhaTradCertificateCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCPhaTradCertificateCode')),
		dataIndex : 'CTRFCPhaTradCertificateCode'
	}); 
/// 医疗机构银行行号 
	var CTRFCBankCode = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '医疗机构银行行号',
		name : 'CTRFCBankCode',
		id : 'CTRFCBankCode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCBankCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCBankCode')),
		dataIndex : 'CTRFCBankCode'
	});
	
	/// 医疗机构银行户名 
	var CTRFCBankName = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '医疗机构银行户名',
		name : 'CTRFCBankName',
		id : 'CTRFCBankName',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCBankName'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCBankName')),
		dataIndex : 'CTRFCBankName'
	});
	
/// 医疗机构银行账号 
	var CTRFCBankAccount = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '医疗机构银行账号',
		name : 'CTRFCBankAccount',
		id : 'CTRFCBankAccount',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCBankAccount'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCBankAccount')),
		dataIndex : 'CTRFCBankAccount'
	});
/// 建筑面积 
	var CTRFCConstructionArea = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '建筑面积',
		name : 'CTRFCConstructionArea',
		id : 'CTRFCConstructionArea',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCConstructionArea'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCConstructionArea')),
		dataIndex : 'CTRFCConstructionArea'
	});
/// 业务用房面积 
	var CTRFCBusinessArea = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '业务用房面积',
		name : 'CTRFCBusinessArea',
		id : 'CTRFCBusinessArea',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCBusinessArea'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCBusinessArea')),
		dataIndex : 'CTRFCBusinessArea'
	});
	/// 占地面积 
	var CTRFCCoversArea = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '占地面积',
		name : 'CTRFCCoversArea',
		id : 'CTRFCCoversArea',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCCoversArea'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCCoversArea')),
		dataIndex : 'CTRFCCoversArea'
	}); 
/// 医疗机构批准床位数
 var CTRFCApprovedBedsNum = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '医疗机构批准床位数',
		name : 'CTRFCApprovedBedsNum',
		id : 'CTRFCApprovedBedsNum',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCApprovedBedsNum'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCApprovedBedsNum')),
		dataIndex : 'CTRFCApprovedBedsNum'
	});
/// 医疗机构实际开放床位数   
	var CTRFCActualBedsNum = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '医疗机构实际开放床位数',
		name : 'CTRFCActualBedsNum',
		id : 'CTRFCActualBedsNum',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCActualBedsNum'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCActualBedsNum')),
		dataIndex : 'CTRFCActualBedsNum'
	});
/// 所属行政区划代码 
	var CTRFCAdministDivisionCode = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '所属行政区划代码',
		name : 'CTRFCAdministDivisionCode',
		id : 'CTRFCAdministDivisionCode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCAdministDivisionCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCAdministDivisionCode')),
		dataIndex : 'CTRFCAdministDivisionCode'
	});
/// 注册地址  
	var CTRFCRegisteredAddress = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '注册地址',
		name : 'CTRFCRegisteredAddress',
		id : 'CTRFCRegisteredAddress',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCRegisteredAddress'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCRegisteredAddress')),
		dataIndex : 'CTRFCRegisteredAddress'
	});
/// 注册地址行政区划代码 
	var CTRFCRegisteredDivisionCode = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '注册地址行政区划代码',
		name : 'CTRFCRegisteredDivisionCode',
		id : 'CTRFCRegisteredDivisionCode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCRegisteredDivisionCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCRegisteredDivisionCode')),
		dataIndex : 'CTRFCRegisteredDivisionCode'
	});
 
/// 组织机构代码 
	var CTRFCInstitutionCode = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '组织机构代码',
		name : 'CTRFCInstitutionCode',
		id : 'CTRFCInstitutionCode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCInstitutionCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCInstitutionCode')),
		dataIndex : 'CTRFCInstitutionCode'
	});
/// 组织机构代码证号 
	var CTRFCInstitutionCodeNum = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '组织机构代码证号',
		name : 'CTRFCInstitutionCodeNum',
		id : 'CTRFCInstitutionCodeNum',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCInstitutionCodeNum'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCInstitutionCodeNum')),
		dataIndex : 'CTRFCInstitutionCodeNum'
	});
/// 注册资金 
	var CTRFCRegisteredCapital = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '注册资金',
		name : 'CTRFCRegisteredCapital',
		id : 'CTRFCRegisteredCapital',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCRegisteredCapital'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCRegisteredCapital')),
		dataIndex : 'CTRFCRegisteredCapital'
	});
/// 生产经营状态 
	var CTRFCStatus = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '生产经营状态',
		name : 'CTRFCStatus',
		id : 'CTRFCStatus',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCStatus'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCStatus')),
		dataIndex : 'CTRFCStatus'
	});
/// 母婴保健技术服务执业许可证号   
	var CTRFCMachildLicenseCode = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '母婴保健技术服务执业许可证号',
		name : 'CTRFCMachildLicenseCode',
		id : 'CTRFCMachildLicenseCode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCMachildLicenseCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCMachildLicenseCode')),
		dataIndex : 'CTRFCMachildLicenseCode'
	}); 
/// 院长   
	var CTRFCGeneMgr = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '院长',
		name : 'CTRFCGeneMgr',
		id : 'CTRFCGeneMgr',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCGeneMgr'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCGeneMgr')),
		dataIndex : 'CTRFCGeneMgr'
	}); 
/// 上级医疗机构代码   
	var CTRFCParentOrgCode = new Ext.BDP.FunLib.Component.TextField({  
		fieldLabel : '上级医疗机构代码',
		name : 'CTRFCParentOrgCode',
		id : 'CTRFCParentOrgCode',
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTRFCParentOrgCode'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTRFCParentOrgCode')),
		dataIndex : 'CTRFCParentOrgCode'
	}); 
	  
	var CTRFCRowIdT=new Ext.BDP.FunLib.Component.TextField({   
		name : 'CTRFCRowId', 
		hidden : true,
		id:'CTRFCRowIdF',
		dataIndex : 'CTRFCRowId'
	});  
	  
	  
	var ExtWinForm = new Ext.FormPanel({
		id : 'Extend-form-save', 
		region : 'center', 
		labelAlign : 'right',
		labelWidth : 120,
		split : true,
		frame : true,
		waitMsgTarget : true,
		buttonAlign : 'center',
		reader: new Ext.data.JsonReader({root:'list'},
				[
					{
						name: 'CTRFCRowId',
						mapping:'CTRFCRowId',
						type : 'string'
					},{
						name : 'CTRFCAddress',
						mapping :'CTRFCAddress',
						type:'string' 
					},{
						name : 'CTRFCRank',
						mapping :'CTRFCRank',
						type:'string'  
					},{
						name : 'CTRFCChargeLevel',
						mapping :'CTRFCChargeLevel',
						type:'string'   
					} ,{
						name : 'CTRFCInstitutionType',
						mapping :'CTRFCInstitutionType',
						type:'string'    
					},{
						name : 'CTRFCEconomyType',
						mapping :'CTRFCEconomyType',
						type:'string'  
					},{
						name : 'CTRFCManageNature',
						mapping :'CTRFCManageNature',
						type:'string'   
					} ,{
						name : 'CTRFCOwnershipForm',
						mapping :'CTRFCOwnershipForm',
						type:'string'      
					},{
						name : 'CTRFCSubordRelations',
						mapping :'CTRFCSubordRelations',
						type:'string' 
					},{
						name : 'CTRFCServiceObject',
						mapping :'CTRFCServiceObject',
						type:'string'  
					} ,{
						name : 'CTRFCCompetUnitName',
						mapping :'CTRFCCompetUnitName',
						type:'string' 
					},{
						name : 'CTRFCPersonName',
						mapping :'CTRFCPersonName',
						type:'string'  
					},{
						name : 'CTRFCCertificateType',
						mapping :'CTRFCCertificateType',
						type:'string'  
					} ,{
						name : 'CTRFCCertificateCode',
						mapping :'CTRFCCertificateCode',
						type:'string'  
					},{
						name : 'CTRFCPersonAddress',
						mapping :'CTRFCPersonAddress',
						type:'string'  
					},{
						name : 'CTRFCPersonPhone',
						mapping :'CTRFCPersonPhone',
						type:'string'  
					} ,{
						name : 'CTRFCZipCode',
						mapping :'CTRFCZipCode',
						type:'string'  
					},{
						name : 'CTRFCSociaCreditCode',
						mapping :'CTRFCSociaCreditCode',
						type:'string'  
					},{
						name : 'CTRFBusinessClicenseCode',
						mapping :'CTRFBusinessClicenseCode',
						type:'string'  
					} ,{
						name : 'CTRFCInduComBusinessLicense',
						mapping :'CTRFCInduComBusinessLicense',
						type:'string'  
					},{
						name : 'CTRFCTaxCode',
						mapping :'CTRFCTaxCode',
						type:'string'  
					},{
						name : 'CTRFCPhaTradCertificateCode',
						mapping :'CTRFCPhaTradCertificateCode',
						type:'string'  
					} ,{
						name : 'CTRFCBankCode',
						mapping :'CTRFCBankCode',
						type:'string'  
					},{
						name : 'CTRFCBankName',
						mapping :'CTRFCBankName',
						type:'string'  
					},{
						name : 'CTRFCBankAccount',
						mapping :'CTRFCBankAccount',
						type:'string'  
					} ,{
						name : 'CTRFCConstructionArea',
						mapping :'CTRFCConstructionArea',
						type:'string'  
					} ,{
						name : 'CTRFCBusinessArea',
						mapping :'CTRFCBusinessArea',
						type:'string'  
					},{
						name : 'CTRFCCoversArea',
						mapping :'CTRFCCoversArea',
						type:'string'  
					},{
						name : 'CTRFCApprovedBedsNum',
						mapping :'CTRFCApprovedBedsNum',
						type:'string'  
					} ,{
						name : 'CTRFCActualBedsNum',
						mapping :'CTRFCActualBedsNum',
						type:'string'  
					} ,{
						name : 'CTRFCAdministDivisionCode',
						mapping :'CTRFCAdministDivisionCode',
						type:'string'  
					},{
						name : 'CTRFCRegisteredAddress',
						mapping :'CTRFCRegisteredAddress',
						type:'string'  
					},{
						name : 'CTRFCRegisteredDivisionCode',
						mapping :'CTRFCRegisteredDivisionCode',
						type:'string'  
					},{
						name : 'CTRFCInstitutionCode',
						mapping :'CTRFCInstitutionCode',
						type:'string'  
					} ,{
						name : 'CTRFCInstitutionCodeNum',
						mapping :'CTRFCInstitutionCodeNum',
						type:'string'   
					},{
						name : 'CTRFCRegisteredCapital',
						mapping :'CTRFCRegisteredCapital',
						type:'string'  
					} ,{
						name : 'CTRFCStatus',
						mapping :'CTRFCStatus',
						type:'string'  
					},{
						name : 'CTRFCMachildLicenseCode',
						mapping :'CTRFCMachildLicenseCode',
						type:'string'  
					},{
						name : 'CTRFCGeneMgr',
						mapping :'CTRFCGeneMgr',
						type:'string'  
					},{
						name : 'CTRFCParentOrgCode',
						mapping :'CTRFCParentOrgCode',
						type:'string'  
					}
				]),
				items : [ {
				xtype:'fieldset',
				title:'医疗机构扩展信息',
				labelWidth: 120,
				autoHeight:true,
				items :[{
					baseCls : 'x-plain',
					layout:'column',
					border:false,
					items:[{
						baseCls : 'x-plain',
						columnWidth:'.33',
						layout: 'form',
						labelWidth: 120,
						labelPad:1,//默认5
						border:false,
						defaults: {anchor:'96%',msgTarget:'under'},
						items: [CTRFCRank,CTRFCChargeLevel,CTRFCInstitutionType,CTRFCEconomyType,CTRFCManageNature,CTRFCOwnershipForm, CTRFCSubordRelations, CTRFCServiceObject,CTRFCCompetUnitName,CTRFCCertificateType,CTRFCCertificateCode,CTRFCParentOrgCode,CTRFCRowIdT]					
					},{
						baseCls : 'x-plain',
						columnWidth:'.33',
						layout: 'form',
						labelWidth: 160,
						labelPad:1,
						border:false,
						defaults: {anchor:'96%',xtype: 'textfield',msgTarget:'under'},
						items: [CTRFCPersonAddress,CTRFCPersonPhone,CTRFCZipCode,CTRFBusinessClicenseCode,CTRFCInduComBusinessLicense,CTRFCTaxCode,CTRFCPhaTradCertificateCode,CTRFCBankCode,CTRFCBankName,CTRFCBankAccount,CTRFCConstructionArea,CTRFCBusinessArea]								
					},{
						baseCls : 'x-plain',
						columnWidth:'.33',
						layout: 'form',
						labelWidth: 200,
						labelPad:1,
						border:false,
						defaults: {anchor:'96%',xtype: 'textfield',msgTarget:'under'},
						items:[CTRFCApprovedBedsNum,CTRFCActualBedsNum,CTRFCAdministDivisionCode,CTRFCRegisteredAddress,CTRFCRegisteredDivisionCode,CTRFCInstitutionCode,CTRFCInstitutionCodeNum,CTRFCRegisteredCapital,CTRFCStatus,CTRFCMachildLicenseCode,CTRFCCoversArea,CTRFCGeneMgr]  	
					}]
				}]
			}], 
			buttons:[{
			text : '保存',
			iconCls : 'icon-save',
			handler : function() {
				ExtWinForm.form.submit({
					clientValidation : true, // 进行客户端验证
					waitMsg : '正在提交数据请稍后...',
					waitTitle : '提示',
					url : SSUSRE_SAVE_ACTION_URL, 
					method : 'POST',
					success : function(form, action) {
						if (action.result.success == 'true') {
							var myrowid = action.result.id; 
							Ext.Msg.show({
										title : '提示',
										msg : '保存成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
											parent.HideParentWin(); 
										}
							});
						} else {
							var errorMsg = '';
							if (action.result.errorinfo) {
								errorMsg = '<br/>错误信息:' + action.result.errorinfo
							}
							Ext.Msg.show({
										title : '提示',
										msg : '保存失败!' + errorMsg,
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
						}

					},
					failure : function(form, action) {
						Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
					}
				})
			}
		}, {
				text : '关闭',
				iconCls : 'icon-close',
				handler : function() {
					parent.HideParentWin(); 
				}
			}
		
		]
	})

   // 载入被选择的数据行的表单数据
    var loadFormData = function() {
		Ext.getCmp('CTRFCRowIdF').setValue(CTRFCRowId) 
        ExtWinForm.form.load( {
            url : SSUSRE_OPEN_ACTION_URL + '&id='+ CTRFCRowId, 
            success : function(form,action) { 
			  
            },
            failure : function(form,action) {
            	Ext.Msg.alert('编辑','载入失败！');
            }
        });
    };
    loadFormData() 
	//创建viewport
	var viewport = new Ext.Viewport({
			layout : 'border',
			items : [ExtWinForm]
	});

});