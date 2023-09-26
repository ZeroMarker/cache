// 名称:新品种立项申请
// 编写日期:2017-09-04
// 编写人：XuChao
// table: DHC_NewItm

var win = null;
var GWOperateType;
var GWNIRowId;
var GWTaskDefKey;
var GWRecord;
/**
 * 新品种立项申请
 * @param {业务类型} OperateType: 新建:'BPMSave', 提交:'BPMSubmit', 通过:'BPMPass', 其他:null
 * @param {新项rowid} NIRowId
 * @param {BPM模型角色} taskDefKey
 * @param {BPM信息record} Record
 */
function CreateNewItmRequest(OperateType, NIRowId, taskDefKey, Record) {
	GWOperateType = OperateType;
	GWNIRowId = NIRowId;
	GWTaskDefKey = taskDefKey;
	GWRecord = Record;
	
//	if (win) {
//		win.show();
//		return;
//	}
	// 物资描述
	var NIDesc = new Ext.form.TextField({
				id : 'NIDesc',
				fieldLabel : '<font color=red>*物资描述</font>',
				allowBlank : false,
				anchor : '90%'
			});
	// 规格
	var NISpec = new Ext.form.TextField({
				id : 'NISpec',
				fieldLabel : '规格',
				anchor : '90%'
			});
	// 型号
	var NIModel = new Ext.form.TextField({
				id : 'NIModel',
				fieldLabel : '型号',
				anchor : '90%'
			});

	// 品牌
	var NIBrand = new Ext.form.TextField({
				id : 'NIBrand',
				fieldLabel : '品牌',
				anchor : '90%'
			});
	// 简称
	var NIAbbrev = new Ext.form.TextField({
				id : 'NIAbbrev',
				fieldLabel : '简称',
				anchor : '90%'
			});
	var NIPUom = new Ext.ux.ComboBox({
		id : 'NIPUom',
		fieldLabel : '单位',
		store : CTUomStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'CTUomDesc'
	});
	var NIInciRemarks = new Ext.form.TextField({
		id : 'NIInciRemarks',
		fieldLabel : '备注',
		anchor : '90%'
	});
	
//	var NIImportFlag = new Ext.form.Checkbox({
//				id : 'NIImportFlag',
//				boxLabel : '进口标志',
//				inputValue:'Y',
//				hideLabel : true
//			});
	var ImportStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['国产', '国产'], ['进口', '进口'], ['合资', '合资']]
	});
	var NIImportFlag = new Ext.form.ComboBox({
		fieldLabel : '进口标志',
		id : 'NIImportFlag',
		store : ImportStore,
		valueField : 'RowId',
		displayField : 'Description',
		anchor:'90%',
		mode : 'local',
		forceSelection : true,
		editable : false
	});
	var NIPbNo = new Ext.form.TextField({
		id : 'NIPbNo',
		fieldLabel : '省集采流水号',
		anchor : '90%'
	});
	var NIBAFlag = new Ext.form.Checkbox({
				id : 'NIBAFlag',
				boxLabel : '一次性标志',
				inputValue:'Y',
				hideLabel : true
			});

	var NIHighRiskFlag = new Ext.form.Checkbox({
				id : 'NIHighRiskFlag',
				boxLabel : '高危标志',
				inputValue:'Y',
				hideLabel : true
			});
	var NIChargeFlag = new Ext.form.Checkbox({
				id : 'NIChargeFlag',
				boxLabel : '收费标志',
				inputValue:'Y',
				hideLabel : true
			});
	var NIImplantationMat = new Ext.form.Checkbox({
				id : 'NIImplantationMat',
				boxLabel : '植入标志',
				inputValue:'Y',
				hideLabel : true
			});
	var NIZeroStk = new Ext.form.Checkbox({
				id : 'NIZeroStk',
				boxLabel : '零库存标志',
				inputValue:'Y',
				hideLabel : true
			});
	var NIDoubleFlag = new Ext.form.Checkbox({
				id : 'NIDoubleFlag',
				boxLabel : '两票制标志',
				inputValue:'Y',
				hideLabel : true
			});
	var NIPRp = new Ext.form.NumberField({
				id : 'NIPRp',
				fieldLabel : '预估单价',
				anchor : '90%',
				enableKeyEvents : true,
				listeners : {
					keyup : function(field, e){
						ComputeFun();
					}
				}
			});
	var NIConsumeQty = new Ext.form.NumberField({
				id : 'NIConsumeQty',
				fieldLabel : '预估年用量',
				anchor : '90%',
				enableKeyEvents : true,
				listeners : {
					keyup : function(field, e){
						ComputeFun();
					}
				}
			});
	var NIConsumeRpAmt = new Ext.form.NumberField({
				id : 'NIConsumeRpAmt',
				fieldLabel : '预估年采购额',
				anchor : '90%',
				diabled : true
			});
	var NIRegNo = new Ext.form.TextField({
		id : 'NIRegNo',
		fieldLabel : '注册证',
		anchor : '100%'
	});
	var NIChargeBasis = new Ext.form.TextField({
		id : 'NIChargeBasis',
		fieldLabel : '收费依据',
		anchor : '100%'
	});
	var NIRemark = new Ext.form.TextArea({
		id : 'NIRemark',
		fieldLabel : '说明意见',
		anchor : '100%'
	});
	
	var NIReqUser = new Ext.form.TextField({
		id : 'NIReqUser',
		fieldLabel : '人员',
		anchor : '100%'
	});
	var NIReqLoc = new Ext.ux.LocComboBox({
		id : 'NIReqLoc',
		fieldLabel : '科室',
		defaultLoc : {},
		anchor : '100%'
	});
	var NIReqPicBtn = new Ext.Button({
		text : '上传图片',
		handler : function(){
			UpLoadNIPic('ReqFile');
		}
	});
	var NIReqPhone = new Ext.form.TextField({
		id : 'NIReqPhone',
		fieldLabel : '联系方式',
		anchor : '100%'
	});
	var NIReqDuty = new Ext.form.TextField({
		id : 'NIReqDuty',
		fieldLabel : '职务/职称',
		anchor : '100%'
	});
	
	//评审意见部分的相关控件
	//管理专家评审:同意（人数），不同意（人数），暂缓（人数） 
	var ManageProfessor_Yes = new Ext.form.NumberField({
		id : 'ManageProfessor_Yes',
		fieldLabel : '同意',
		allowNegative : false,
		allowDecimals : false,
		anchor : '100%'
	});
	var ManageProfessor_No = new Ext.form.NumberField({
		id : 'ManageProfessor_No',
		fieldLabel : '不同意',
		allowNegative : false,
		allowDecimals : false,
		anchor : '100%'
	});
	var ManageProfessor_Wait = new Ext.form.NumberField({
		id : 'ManageProfessor_Wait',
		fieldLabel : '暂缓',
		allowNegative : false,
		allowDecimals : false,
		anchor : '100%'
	});
	var ManageProfessor_PicBtn = new Ext.Button({
		text : '上传图片',
		handler : function(){
			UpLoadNIPic('ManageProfessor');
		}
	});
	//院使用专家评审
	var HospProfessor_Yes = new Ext.form.NumberField({
		id : 'HospProfessor_Yes',
		fieldLabel : '同意',
		allowNegative : false,
		allowDecimals : false,
		anchor : '100%'
	});
	var HospProfessor_No = new Ext.form.NumberField({
		id : 'HospProfessor_No',
		fieldLabel : '不同意',
		allowNegative : false,
		allowDecimals : false,
		anchor : '100%'
	});
	var HospProfessor_Wait = new Ext.form.NumberField({
		id : 'HospProfessor_Wait',
		fieldLabel : '暂缓',
		allowNegative : false,
		allowDecimals : false,
		anchor : '100%'
	});
	var HospProfessor_PicBtn = new Ext.Button({
		text : '上传图片',
		handler : function(){
			UpLoadNIPic('HospProfessor');
		}
	});
	//专家委员会评审
	var Committee_Yes = new Ext.form.NumberField({
		id : 'Committee_Yes',
		fieldLabel : '同意',
		allowNegative : false,
		allowDecimals : false,
		anchor : '100%'
	});
	var Committee_No = new Ext.form.NumberField({
		id : 'Committee_No',
		fieldLabel : '不同意',
		allowNegative : false,
		allowDecimals : false,
		anchor : '100%'
	});
	var Committee_Wait = new Ext.form.NumberField({
		id : 'Committee_Wait',
		fieldLabel : '暂缓',
		allowNegative : false,
		allowDecimals : false,
		anchor : '100%'
	});
	var Committee_PicBtn = new Ext.Button({
		text : '上传图片',
		handler : function(){
			UpLoadNIPic('Committee');
		}
	});
	//办公室
	var Office_Yes = new Ext.form.NumberField({
		id : 'Office_Yes',
		fieldLabel : '同意',
		allowNegative : false,
		allowDecimals : false,
		anchor : '100%'
	});
	var Office_No = new Ext.form.NumberField({
		id : 'Office_No',
		fieldLabel : '不同意',
		allowNegative : false,
		allowDecimals : false,
		anchor : '100%'
	});
	var Office_Wait = new Ext.form.NumberField({
		id : 'Office_Wait',
		fieldLabel : '暂缓',
		allowNegative : false,
		allowDecimals : false,
		anchor : '100%'
	});
	var Office_PicBtn = new Ext.Button({
		text : '上传图片',
		handler : function(){
			UpLoadNIPic('Office');
		}
	});
	
	//上传图片
	function UpLoadNIPic(Type) {
		if (GWNIRowId == '') {
			Msg.info("warning", "请先保存立项信息, 再上传图片!");
			return;
		}
		var NIUpLoadDialog = new Ext.ux.UploadDialog.Dialog({
			width: 600,
			height: 400,
			url: 'dhcstm.newitmaction.csp?actiontype=UpLoadPic&RowId=' + GWNIRowId,
			reset_on_hide: false,
			permitted_extensions: ['gif', 'jpeg', 'jpg', 'png', 'bmp'],
			allow_close_on_upload: true,
			upload_autostart: false,
			title: '上传立项相关图片',
			base_params: {
				'Type': Type
			}
		});
		NIUpLoadDialog.show();
	};
	
	var NIResult = new Ext.form.RadioGroup({
		id : 'NIResult',
		fieldLabel : '立项结果',
		columns : 3,
		items:[
			{boxLabel:'通过',name:'NIResult',id:'NIResult_Yes',inputValue:'Yes',checked:true},
			{boxLabel:'不通过',name:'NIResult',id:'NIResult_No',inputValue:'No'},
			{boxLabel:'暂缓',name:'NIResult',id:'NIResult_Wait',inputValue:'Wait'}
		]
	});
	
	
	//查看图片
	var ShowNIPicBtn = new Ext.Button({
		text: '查看图片',
		tooltip: '查看立项相关图片',
		iconCls: 'page_edit',
		width: 70,
		height: 30,
		handler: function () {
			if (Ext.isEmpty(GWNIRowId)) {
				Msg.info('warning', '请先保存后再查看!');
				return false;
			}
			NewItmPicWin(GWNIRowId);
		}
	});
	
	
	// 界面数据计算
	function ComputeFun(){
		var Rp = Ext.getCmp('NIPRp').getValue();
		var Qty = Ext.getCmp('NIConsumeQty').getValue();
		var RpAmt = accMul(Rp, Qty);
		Ext.getCmp('NIConsumeRpAmt').setValue(RpAmt);
	}
	/*
	 * 保存,提交,通过,均需调用
	 * 用于获取表单数据
	 */
	function GetStrParam(){
		var NIDesc=Ext.getCmp('NIDesc').getValue();
		var NISpec=Ext.getCmp('NISpec').getValue();
		var NIModel=Ext.getCmp('NIModel').getValue();
		var NIBrand=Ext.getCmp('NIBrand').getValue();
		var NIAbbrev=Ext.getCmp('NIAbbrev').getValue();
		var NIPUom=Ext.getCmp('NIPUom').getRawValue();
		
		var NIImportFlag=Ext.getCmp('NIImportFlag').getValue();
		var NIBAFlag=Ext.getCmp('NIBAFlag').getValue()? 'Y' : '';
		var NIHighRiskFlag=Ext.getCmp('NIHighRiskFlag').getValue()? 'Y' : '';
		var NIChargeFlag=Ext.getCmp('NIChargeFlag').getValue()? 'Y' : '';
		var NIImplantationMat=Ext.getCmp('NIImplantationMat').getValue()? 'Y' : '';
		var NIPbNo=Ext.getCmp('NIPbNo').getValue();
		var NIDoubleFlag=Ext.getCmp('NIDoubleFlag').getValue()? 'Y' : 'N';
		var NIPRp=Ext.getCmp('NIPRp').getValue();
		var NIConsumeQty=Ext.getCmp('NIConsumeQty').getValue();
		var NIInciRemarks=Ext.getCmp('NIInciRemarks').getValue();				//物资备注
		var NIRegNo=Ext.getCmp('NIRegNo').getValue();
		var NIChargeBasis=Ext.getCmp('NIChargeBasis').getValue();
		
		var NIZeroStk=Ext.getCmp('NIZeroStk').getValue()? 'Y' : '';
		var NIRemark=Ext.getCmp('NIRemark').getValue()? 'Y' : '';		//说明意见
		
		var NIReqUser=Ext.getCmp('NIReqUser').getValue();
		var NIReqLoc=Ext.getCmp('NIReqLoc').getValue();
		var NIReqPhone=Ext.getCmp('NIReqPhone').getValue();
		var NIReqDuty=Ext.getCmp('NIReqDuty').getValue();
		var NIProfessorInfo=GetProfessorInfo();
		
		var NIResult = Ext.getCmp('NIResult').getValue().getGroupValue();
		
		var StrParam = NIDesc + '^' + NISpec + '^' + NIModel + '^' + NIBrand + '^' + NIAbbrev
			+ '^' + NIImportFlag + '^' + NIBAFlag + '^' + NIHighRiskFlag + '^' + NIChargeFlag + '^' + NIImplantationMat
			+ '^' + NIZeroStk + '^' + NIRemark + '^' + NIPUom + '^' + NIPbNo + '^' + NIDoubleFlag
			+ '^' + NIPRp + '^' + NIConsumeQty + '^' + NIInciRemarks + '^' + NIReqUser + '^' + NIReqLoc
			+ '^' + NIProfessorInfo + '^' + NIRegNo + '^' + NIChargeBasis + '^' + NIReqPhone + '^' + NIReqDuty
			+ '^' + NIResult;
		return StrParam;
	}
	/*
	 * 获取审批意见的Str
	 */
	function GetProfessorInfo(){
		var ManageProfessor_Yes=Ext.getCmp('ManageProfessor_Yes').getValue();
		var ManageProfessor_No=Ext.getCmp('ManageProfessor_No').getValue();
		var ManageProfessor_Wait=Ext.getCmp('ManageProfessor_Wait').getValue();
		var ManageProfessorInfo = ManageProfessor_Yes + '|' + ManageProfessor_No + '|' + ManageProfessor_Wait;
		
		var HospProfessor_Yes=Ext.getCmp('HospProfessor_Yes').getValue();
		var HospProfessor_No=Ext.getCmp('HospProfessor_No').getValue();
		var HospProfessor_Wait=Ext.getCmp('HospProfessor_Wait').getValue();
		var HospProfessorInfo = HospProfessor_Yes + '|' + HospProfessor_No + '|' + HospProfessor_Wait;
		
		var Committee_Yes=Ext.getCmp('Committee_Yes').getValue();
		var Committee_No=Ext.getCmp('Committee_No').getValue();
		var Committee_Wait=Ext.getCmp('Committee_Wait').getValue();
		var CommitteeInfo = Committee_Yes + '|' + Committee_No + '|' + Committee_Wait;
		
		var Office_Yes=Ext.getCmp('Office_Yes').getValue();
		var Office_No=Ext.getCmp('Office_No').getValue();
		var Office_Wait=Ext.getCmp('Office_Wait').getValue();
		var OfficeInfo = Office_Yes + '|' + Office_No + '|' + Office_Wait;
		
		var ProfessorInfo = ManageProfessorInfo + '&' + HospProfessorInfo + '&' + CommitteeInfo + '&' + OfficeInfo;
		return ProfessorInfo;
	}
	
	var saveButton = new Ext.Toolbar.Button({
		text : '保存',
		height : 30,
		width : 70,
		handler : function() {
			var Param=GWNIRowId+"^"+gCtLocId+"^"+gUserId;
			var StrParam = GetStrParam();
			NewItmPanel.getForm().submit({
				clientValidation: true,
				url:'dhcstm.newitmaction.csp?actiontype=BPMSave',
				params:{Param : Param, StrParam : StrParam},
				success: function(form, action) {
					if(action.result.success=='true'){
						Msg.info('success','保存成功！');
						//2018-04-23 保存成功后自动关闭window
						win.close();
					}else{
						Msg.info('error','保存失败！');
					}
				}
			});
		}
	});
	
	var commitButton = new Ext.Toolbar.Button({
		text : '提交',
		height : 30,
		width : 70,
		handler : function() {
			BPMNodeActorsWin.show();
			var NodeParamObj = {};
			NodeParamObj.procInsId = GWRecord.get('procInsId');
			NodeParamObj.excutionId = GWRecord.get('excutionId');
			NodeParamObj.nodeId = GWRecord.get('taskDefKey');
			NodeParamObj.nodeName = GWRecord.get('taskName');
			NodeParamObj.businessId = GWRecord.get('businessId');
			NodeParamObj.pageRoleCode = GWRecord.get('taskDefKey');
			NodeParamObj.typeCode = '0';								//0:提交 ; 1:通过
			NodeParamObj.tenantId = G_SysCode;
			var BPMStrParam = Ext.encode(NodeParamObj);
			BPMNextNodesGrid.getStore().load({
				params : {
					InputJson : BPMStrParam
				}
			});
		}
	});

	var BPMPassButton = new Ext.Toolbar.Button({
		text : '通过',
		height : 30,
		width : 70,
		handler : function() {
			BPMNodeActorsWin.show();
			var NodeParamObj = {};
			NodeParamObj.procInsId = GWRecord.get('procInsId');
			NodeParamObj.excutionId = GWRecord.get('excutionId');
			NodeParamObj.nodeId = GWRecord.get('taskDefKey');
			NodeParamObj.nodeName = GWRecord.get('taskName');
			NodeParamObj.businessId = GWRecord.get('businessId');
			NodeParamObj.pageRoleCode = GWRecord.get('taskDefKey');
			NodeParamObj.typeCode = '1';								//0:提交 ; 1:通过
			NodeParamObj.tenantId = G_SysCode;
			var BPMStrParam = Ext.encode(NodeParamObj);
			BPMNextNodesGrid.getStore().load({
				params : {
					InputJson : BPMStrParam
				},
				callback : function(r, options, success){
					if(success && r.length > 0){
						BPMNextNodesGrid.getSelectionModel().selectFirstRow();
					}
				}
			});
		}
	});
	
	var BPMRejectButton = new Ext.Toolbar.Button({
		text : '回退',
		height : 30,
		width : 70,
		handler : function() {
			if(!confirm('您将要回退请求, 是否继续?')){
				return false;
			}
			
			var ParamObj = {};
			ParamObj.procInsId = GWRecord.get('procInsId');
			ParamObj.excutionId = GWRecord.get('excutionId');
			ParamObj.businessId = GWRecord.get('businessId');
			ParamObj.taskId = GWRecord.get('taskId');
			ParamObj.nodeKey = GWRecord.get('taskDefKey');
			ParamObj.nodeName = GWRecord.get('taskName');
			ParamObj.tenantId = G_SysCode;
			var BPMStrParam = Ext.encode(ParamObj);
			var RetUrl = 'dhcstm.bpmcommon.csp?actiontype=BPMCommon&Code=taskNodeBackUpNode&InputJson=' + BPMStrParam;
			RetUrl = encodeURI(RetUrl);
			var RetJson = ExecuteDBSynAccess(RetUrl);
			var RetObj = Ext.decode(RetJson);
			if(RetObj.stateCode != '0'){
				Msg.info('error', '回退失败!');
				return false;
			}else{
				Msg.info('success', '回退成功!');
				win.close();
			}
		}
	});
	
	// 初始化取消按钮
	var cancelButton = new Ext.Toolbar.Button({
				text : '取消',
				height : 30,
				width : 70,
				handler : function() {
					if (win) {
						win.close();
					}
				}
			});
	// 初始化取消按钮
	var confButton = new Ext.Toolbar.Button({
				text : '配置权限',
				height:30,
				width:70,
				iconCls : 'page_gear',
				handler : function() {
					ElementAuthorWin("NewItmPanel",G_BPMCode)
				}
			});
	// 初始化面板
	var NewItmPanel = new Ext.form.FormPanel({
		BPMCode : G_BPMCode,	//设置表单对应的BPM模型
		id:'NewItmPanel',
		labelWidth : 90,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		tbar:[confButton, '-', ShowNIPicBtn],
		bodyStyle : 'padding:5px;',
		items : [{
			xtype : 'fieldset',
			title : '基本信息',
			autoHeight : true,
			layout : 'column',
			defaults : {layout : 'form'},
			items : [{
				columnWidth : .33,
				items : [NIDesc, NISpec, NIInciRemarks]
			}, {
				columnWidth : .33,
				items : [NIPUom, NIModel]
			}, {
				columnWidth : .33,
				items : [NIBrand, NIAbbrev]
			}]
		}, {
			xtype : 'fieldset',
			title : '其他信息',
			autoHeight : true,
			layout : 'column',
			defaults : {layout : 'form'},
			items : [{
				columnWidth : .15,
				items : [NIChargeFlag, NIHighRiskFlag, NIImplantationMat]
			}, {
				columnWidth : .15,
				items : [NIBAFlag, NIDoubleFlag, NIZeroStk]
			}, {
				columnWidth : .25,
				items : [NIPRp, NIConsumeQty, NIConsumeRpAmt]
			}, {
				columnWidth : .25,
				items : [NIImportFlag, NIPbNo]
			}, {
				columnWidth : .2,
				labelWidth : 60,
				items : [NIRegNo, NIChargeBasis]
			}]
		}, {
			xtype : 'fieldset',
			title : '申请信息',
			autoHeight : true,
			items : [{
				fieldLabel : '申请单位',
				layout : 'column',
				labelWidth : 50,
				defaults : {layout : 'form'},
				items : [
					{columnWidth : .15, items : [NIReqUser]},
					{columnWidth : .3, items : [NIReqLoc]},
					{columnWidth : .1, items : [NIReqPicBtn]},
					{columnWidth : .25, labelWidth : 60, items : [NIReqPhone]},
					{columnWidth : .2, labelWidth : 70, items : [NIReqDuty]}
				]
			}, {
				fieldLabel : '管理专家',
				layout : 'column',
				labelWidth : 50,
				defaults : {layout : 'form'},
				items : [
					{columnWidth : .15, items : [ManageProfessor_Yes]},
					{columnWidth : .15, items : [ManageProfessor_No]},
					{columnWidth : .15, items : [ManageProfessor_Wait]},
					{columnWidth : .1, items : [ManageProfessor_PicBtn]}
				]
			}, {
				fieldLabel : '院使用专家',
				layout : 'column',
				labelWidth : 50,
				defaults : {layout : 'form'},
				items : [
					{columnWidth : .15, items : [HospProfessor_Yes]},
					{columnWidth : .15, items : [HospProfessor_No]},
					{columnWidth : .15, items : [HospProfessor_Wait]},
					{columnWidth : .1, items : [HospProfessor_PicBtn]}
				]
			}, {
				fieldLabel : '评审委员会',
				layout : 'column',
				labelWidth : 50,
				defaults : {layout : 'form'},
				items : [
					{columnWidth : .15, items : [Committee_Yes]},
					{columnWidth : .15, items : [Committee_No]},
					{columnWidth : .15, items : [Committee_Wait]},
					{columnWidth : .1, items : [Committee_PicBtn]}
				]
			}, {
				fieldLabel : '办公室',
				layout : 'column',
				labelWidth : 50,
				defaults : {layout : 'form'},
				items : [
					{columnWidth : .15, items : [Office_Yes]},
					{columnWidth : .15, items : [Office_No]},
					{columnWidth : .15, items : [Office_Wait]},
					{columnWidth : .1, items : [Office_PicBtn]}
				]
			}]
		}, {
			autoHeight : true,
			xtype : 'fieldset',
			title : '立项结果',
			labelWidth : 70,
			items : [{
				layout : 'form',
				items : [NIResult]
			}]
		}, {
			autoHeight : true,
			xtype : 'fieldset',
			title : '审批意见',
			labelWidth : 70,
			items : [{
				layout : 'form',
				items : [NIRemark]
			}]
		}]
	});
	
	function GetWinButtons(){
		switch (GWOperateType){
			case 'BPMSave':
				return [saveButton, cancelButton];
				break;
			case 'BPMSubmit':
				return [saveButton, commitButton, cancelButton];
				break;
			case 'BPMPass':
				return [saveButton, BPMPassButton, BPMRejectButton, cancelButton];
				break;
			default:
				return [];
		}
	}
			
	// 初始化窗口
	win = new Ext.Window({
		title : '新品种申请',
		width : gWinWidth,
		height : gWinHeight,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'right',
		items : NewItmPanel,
		closeAction : 'close',
		buttons : GetWinButtons(),
		listeners : {
			'show' : function() {
				//可以放在beforeshow里
				ReSetFormElement('NewItmPanel', GWTaskDefKey);
				
				if (GWNIRowId != '') {
					SetItmDetailInfo(GWNIRowId);
				}
			},
			'beforehide' : function(e) {
				clearPanel(NewItmPanel);
			},
			'close' : function(){
				if(Ext.getCmp('westpanel')){
					var ActiveId = Ext.getCmp('westpanel').layout.activeItem.id;
					if(!Ext.isEmpty(ActiveId)){
						Ext.getCmp(ActiveId).getStore().reload();
					}
				}
			}
		}
	});

	win.show();

	// 显示明细信息
	function SetItmDetailInfo(RowId) {
		Ext.Ajax.request({
			url :'dhcstm.newitmaction.csp?actiontype=GetItmDetail',
			params : {RowId : RowId},
			failure : function(result, request) {
				Msg.info('error', '失败！');
			},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				NewItmPanel.getForm().setValues(jsonData);
				ComputeFun();
			},
			scope : this
		});
	}



	var BPMNextNodeSm = new Ext.grid.CheckboxSelectionModel({
		listeners : {
			rowselect : function(sm, rowIndex, r){
				var ActorsParamObj = {};
				ActorsParamObj.procInsId = r.get('procInsId');
				ActorsParamObj.excutionId = r.get('excutionId');
				ActorsParamObj.pageRoleCode = r.get('nextNodeKey');
				ActorsParamObj.nodeId = r.get('nextNodeKey');
				ActorsParamObj.nodeName = r.get('nextNodeName');
				ActorsParamObj.businessId = r.get('businessId');
				ActorsParamObj.tenantId = G_SysCode;
				var ActorsParam = Ext.encode(ActorsParamObj);
				var ActorsUrl = 'dhcstm.bpmcommon.csp?actiontype=BPMCommon&Code=getNodeActors&InputJson=' + ActorsParam;
				ActorsUrl = encodeURI(ActorsUrl);
				ActorsJson = ExecuteDBSynAccess(ActorsUrl);
				var ActorsObj = Ext.decode(ActorsJson);
				if(Ext.isEmpty(ActorsObj) || Ext.isEmpty(ActorsObj.listData)){
					return;
				}
				for(var i = 0, Len = ActorsObj.listData.length; i < Len; i++){
					var NextNode = ActorsObj.listData[i];
					var nextNodeKey = NextNode.nextNodeKey;
					var nextNodeName = NextNode.nextNodeName;
					var ActorsFields = BPMNodeActorsGrid.getStore().fields;
					for(var j = 0, ActorsLen = NextNode.actorsJson.length; j < ActorsLen; j++){
						var ActorInfo = NextNode.actorsJson[j];
						var IsParent = ActorInfo.isParent;
						if(IsParent == true){
							//BPM按tree传值,isParent==true的不需要
							continue;
						}
						var ActorId = ActorInfo.id;
						if(BPMNodeActorsGrid.getStore().findExact('id',0,ActorId) == -1){
							Ext.applyIf(ActorInfo, NextNode);
							var NewRecord = CreateRecordInstance(ActorsFields, ActorInfo);
							BPMNodeActorsGrid.getStore().add(NewRecord);
						}
					}
				}
			}
		}
	});
	
	var BPMNextNodesGrid = new Ext.grid.GridPanel({
		region : 'west',
		width : 300,
		store : new Ext.data.JsonStore({
			url : 'dhcstm.bpmcommon.csp?actiontype=BPMCommon&Code=getNextNodes',
			fields : ['nodeKey','nodeName','nextNodeKey','nextNodeName','isMutilate',
				'transactSequence','businessId','title','excutionId','procInsId',
				'procDefKey','tenantId'],
			totalProperty : 'total',
			root : 'listData',
			pruneModifiedRecords : true
		}),
		cm : new Ext.grid.ColumnModel(
			[
				new Ext.grid.RowNumberer(),
				BPMNextNodeSm,
				{header : '当前环节id', dataIndex : 'nodeKey', width : 100, hidden : true},
				{header : '当前环节名称', dataIndex : 'nodeName', width : 100},
				{header : '下一环节id', dataIndex : 'nextNodeKey', width : 100, hidden : true},
				{header : '下一环节名称', dataIndex : 'nextNodeName', width : 100}
			]
		),
		sm : BPMNextNodeSm
	});
	
	var BPMNodeActorsSm = new Ext.grid.CheckboxSelectionModel({
		listeners : {
			rowselect : function(sm, rowIndex, r){
//					alert(rowIndex)
			}
		}
	});
	var BPMNodeActorsGrid = new Ext.grid.GridPanel({
		region : 'center',
		store : new Ext.data.JsonStore({
			url : 'dhcstm.bpmcommon.csp?actiontype=BPMCommon&actiontype=getNodeActors',
			fields : ['nodeKey', 'nodeName', 'nextNodeKey', 'nextNodeName', 'actorsJson',
				'businessId', 'title', 'excutionId', 'procInsId', 'procDefKey', 'tenantId',
				'isMutilate', 'transactSequence',
				//这三个节点,是从actorsJson中获取的
				'id', 'name', 'parentId'],
			totalProperty : 'total',
			root : 'listData',
			pruneModifiedRecords : true
		}),
		sm : BPMNodeActorsSm,
		cm : new Ext.grid.ColumnModel({
			columns : [
				new Ext.grid.RowNumberer(),
				BPMNodeActorsSm,
				{header : '工号', dataIndex : 'id', width : 100},
				{header : '姓名', dataIndex : 'name', width : 100},
				{header : 'parentId', dataIndex : 'parentId', width : 100},
				{header : '下一环节id', dataIndex : 'nextNodeKey', width : 100},
				{header : '下一环节名称', dataIndex : 'nextNodeName', width : 100}
			]
		})
	});
	
	var BPMSubmitYes = new Ext.ux.Button({
		text : '确认提交',
		iconCls : 'page_save',
		handler : function(b, e){
			var ActorSels = BPMNodeActorsGrid.getSelectionModel().getSelections();
			if(Ext.isEmpty(ActorSels)){
				Msg.info('warning', '请选择下一环节审批人!');
				return false;
			}
			var FirstActor = ActorSels[0];
			var taskId = GWRecord.get('taskId');
			var BPMSubmitObj = {};
			BPMSubmitObj.taskId = taskId;
			BPMSubmitObj.procInsId = FirstActor.get('procInsId');
			BPMSubmitObj.excutionId = FirstActor.get('excutionId');
			BPMSubmitObj.nextNodeId = FirstActor.get('nextNodeKey');
			BPMSubmitObj.comment = '';
			BPMSubmitObj.title = FirstActor.get('title');
			BPMSubmitObj.tenantId = G_SysCode;
			BPMSubmitObj.pageRoleCode = FirstActor.get('nodeKey');
			BPMSubmitObj.businessId = FirstActor.get('businessId');
			
			//这里需要拆分Node
			var NodeKey = FirstActor.get('nodeKey');
			
			var ActorArr = [];
			for(var i = 0, Len = ActorSels.length; i < Len; i++){
				var ActorRec = ActorSels[i];
				var ActorId = ActorRec.get('id');
				var ActorName = ActorRec.get('name');
				var parentId = ActorRec.get('parentId');
				var ActorObj = {};
				ActorObj.actorId = ActorId;
				ActorObj.actorName = ActorName;
				ActorObj.actorOrgId = parentId;
				ActorArr.push(ActorObj);
			}
			var ActorArrStr = Ext.encode(ActorArr);
			ActorArrStr = ActorArrStr.replace(/\"/g,"'");		//使用单引号,编码后面eval等处理造成的转义字符
			var NodeActorsStr = '{' + NodeKey +':' + ActorArrStr + '}';
			var NodeActors = eval('(' + NodeActorsStr + ')');
			BPMSubmitObj.actors = NodeActors;
			var BPMStrParam = Ext.encode(BPMSubmitObj);
			var Param = GWNIRowId+"^"+gCtLocId+"^"+gUserId;
			var StrParam = GetStrParam();		//表单数据
			NewItmPanel.getForm().submit({
				clientValidation: true,
				url:'dhcstm.newitmaction.csp?actiontype=BPMSubmit',
				params:{Param : Param, StrParam : StrParam, BPMStrParam : BPMStrParam},
				success: function(form, action) {
					if(action.result.success=='true'){
						Msg.info('success','提交成功！');
						BPMNodeActorsWin.close();
						win.close();
					}else{
						Msg.info('error','提交失败！');
					}
				}
			});
		}
	});
	
	var BPMPassYes = new Ext.ux.Button({
		text : '通过',
		iconCls : 'page_save',
		handler : function(b, e){
			var NodeSels = BPMNextNodesGrid.getSelectionModel().getSelections();
			var ActorSels = BPMNodeActorsGrid.getSelectionModel().getSelections();
			if(Ext.isEmpty(NodeSels)){
				Msg.info('warning', '请选择下一环节审批人!');
				return false;
			}
			var FirstActor = NodeSels[0];
			var taskId = GWRecord.get('taskId');
			var BPMSubmitObj = {};
			BPMSubmitObj.taskId = taskId;
			BPMSubmitObj.procInsId = FirstActor.get('procInsId');
			BPMSubmitObj.excutionId = FirstActor.get('excutionId');
			BPMSubmitObj.nextNodeId = FirstActor.get('nextNodeKey');
			BPMSubmitObj.comment = '';
			BPMSubmitObj.title = FirstActor.get('title');
			BPMSubmitObj.tenantId = G_SysCode;
			BPMSubmitObj.pageRoleCode = FirstActor.get('nodeKey');
			BPMSubmitObj.businessId = FirstActor.get('businessId');
			
			//这里需要拆分Node
			var NodeKey = FirstActor.get('nextNodeKey');		//下一环节nodekey
			
			var ActorArr = [];
			for(var i = 0, Len = ActorSels.length; i < Len; i++){
				var ActorRec = ActorSels[i];
				var ActorId = ActorRec.get('id');
				var ActorName = ActorRec.get('name');
				var parentId = ActorRec.get('parentId');
				var ActorObj = {};
				ActorObj.actorId = ActorId;
				ActorObj.actorName = ActorName;
				ActorObj.actorOrgId = parentId;
				ActorArr.push(ActorObj);
			}
			var ActorArrStr = Ext.encode(ActorArr);
			ActorArrStr = ActorArrStr.replace(/\"/g,"'");		//使用单引号,编码后面eval等处理造成的转义字符
			var NodeActorsStr = '{' + NodeKey +':' + ActorArrStr + '}';
			var NodeActors = eval('(' + NodeActorsStr + ')');
			BPMSubmitObj.actors = NodeActors;
			var BPMStrParam = Ext.encode(BPMSubmitObj);
			var Param = GWNIRowId+"^"+gCtLocId+"^"+gUserId;
			var StrParam = GetStrParam();		//表单数据
			NewItmPanel.getForm().submit({
				clientValidation: true,
				url:'dhcstm.newitmaction.csp?actiontype=BPMPass',
				params:{Param : Param, StrParam : StrParam, BPMStrParam : BPMStrParam},
				success: function(form, action) {
					if(action.result.success=='true'){
						Msg.info('success','提交成功！');
						BPMNodeActorsWin.close();
						win.close();
					}else{
						Msg.info('error','提交失败！');
					}
				}
			});
		}
	});
	
	function GetActorsButtons(){
		switch (GWOperateType){
			case 'BPMSubmit':
				return [BPMSubmitYes];
				break;
			case 'BPMPass':
				return [BPMPassYes];
				break;
			default:
				return [];
		}
	}
	
	var BPMNodeActorsWin = new Ext.Window({
		title : '人员角色',
		width : 0.8 * gWinWidth,
		height : 0.9 * gWinHeight,
		layout : 'fit',
		plain : true,
		modal : true,
		layout : 'border',
		items : [BPMNextNodesGrid, BPMNodeActorsGrid],
		closeAction : 'close',
		buttons : GetActorsButtons(),
		listeners : {
			beforehide : function(){
				ClearNodeActorsPanel();
			}
		}
	});
	
	function ClearNodeActorsPanel(){
		BPMNodeActorsGrid.getStore().removeAll();
		BPMNextNodesGrid.getStore().removeAll();
	}
	
}