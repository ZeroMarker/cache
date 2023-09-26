function EI_InitExtraItem(SubFlow,SysOpera,RequestID){
	var obj = new Object();
	obj.EI_Arguments = new Object();
	obj.EI_Arguments.SubFlow = SubFlow;
	obj.EI_Arguments.SysOpera = SysOpera;
	obj.EI_Arguments.RequestID = RequestID;
	
	var anchor = '95%';
	
	//质控附加项
	if (SubFlow == 'Q'){
		obj.EI_txtQCReason = Common_TextArea("EI_txtQCReason","问题描述",50,500,anchor);
		var winHeight = 130;
		if (SysOpera == 'H'){
			var formitmes = [
				{text:' ',style:'font-weight:bold;font-size:5px;height:5px;',xtype:'label'}
				,obj.EI_txtQCReason
			]
		}
	}
	
	//借阅附加项
	if (SubFlow == 'L'){
		obj.EI_txtLUserName = Common_TextField("EI_txtLUserName","借阅人",anchor);
		obj.EI_txtLUserCode = Common_TextField("EI_txtLUserCode","工号",anchor);
		obj.EI_txtLUserTel = Common_TextField("EI_txtLUserTel","电话",anchor);
		obj.EI_txtLLocTel = Common_TextField("EI_txtLLocTel","科内电话",anchor);
		obj.EI_cbgLPurpose = Common_CheckboxGroupToDic("EI_cbgLPurpose","借阅目的","LendAim",2,anchor);
		obj.EI_txtLBackDate = Common_DateFieldToDate("EI_txtLBackDate","预计归还日期",anchor);
		obj.EI_txtLNote = Common_TextArea("EI_txtLNote","备注信息",50,500,anchor);
		var winHeight = 400;
		if (SysOpera == 'H'){
			var formitmes = [
				{text:' ',style:'font-weight:bold;font-size:5px;height:5px;',xtype:'label'}
				,obj.EI_txtLUserName
				,obj.EI_txtLUserCode
				,obj.EI_txtLUserTel
				,obj.EI_txtLLocTel
				,obj.EI_cbgLPurpose
				,obj.EI_txtLBackDate
				,obj.EI_txtLNote
			]
		} else {}
	}
	
	//复印附加项
	if (SubFlow == 'C'){
		obj.EI_txtClientName = Common_TextField("EI_txtClientName","委托人",anchor);
		obj.EI_cboClientRelation = Common_ComboToDic("EI_cboClientRelation","与患者关系","RelationType",anchor);
		obj.EI_cboCardType = Common_ComboToDic("EI_cboCardType","证明材料","Certificate",anchor);
		obj.EI_txtPersonalID = Common_TextField("EI_txtPersonalID","证件号码",anchor);
		obj.EI_txtTelephone = Common_TextField("EI_txtTelephone","联系电话",anchor);
		obj.EI_txtAddress = Common_TextField("EI_txtAddress","联系地址",anchor);
		obj.EI_txtClientNote = Common_TextArea("EI_txtClientNote","委托备注信息",50,500,anchor);
		obj.EI_cbgCContent = Common_CheckboxGroupToDic("EI_cbgCContent","复印内容","MRCopyInfo",2,anchor);
		obj.EI_cbgCPurpose = Common_CheckboxGroupToDic("EI_cbgCPurpose","复印目的","CopyAim",2,anchor);
		obj.EI_txtCPageNumber = Common_TextField("EI_txtCPageNumber","复印数量",anchor);
		obj.EI_txtCUnitPrice = Common_TextField("EI_txtCUnitPrice","复印单价",anchor);
		obj.EI_txtCMoneyCount = Common_TextField("EI_txtCMoneyCount","复印金额",anchor);
		obj.EI_txtCNote = Common_TextArea("EI_txtCNote","备注信息",50,500,anchor);
		var winHeight = 400;
		if (SysOpera == 'R'){
			var formitmes = [
				{text:' ',style:'font-weight:bold;font-size:5px;height:5px;',xtype:'label'}
				,obj.EI_txtClientName
				,obj.EI_cboClientRelation
				,obj.EI_cboCardType
				,obj.EI_txtPersonalID
				,obj.EI_txtTelephone
				,obj.EI_txtAddress
				,obj.EI_txtClientNote
				,obj.EI_cbgCContent
				,obj.EI_cbgCPurpose
				,obj.EI_txtCUnitPrice
				,obj.EI_txtCNote
			]
		} else if (SysOpera == 'H'){
			var formitmes = [
				{text:' ',style:'font-weight:bold;font-size:5px;height:5px;',xtype:'label'}
				,obj.EI_txtClientName
				,obj.EI_cboClientRelation
				,obj.EI_cboCardType
				,obj.EI_txtPersonalID
				,obj.EI_txtTelephone
				,obj.EI_txtAddress
				,obj.EI_txtClientNote
				,obj.EI_cbgCContent
				,obj.EI_cbgCPurpose
				,obj.EI_txtCUnitPrice
				,obj.EI_txtCPageNumber
				,obj.EI_txtCMoneyCount
				,obj.EI_txtCNote
			]
		} else {}
	}
	
	//封存附加项
	if (SubFlow == 'S'){
		obj.EI_txtClientName = Common_TextField("EI_txtClientName","委托人<font color='red'>*</font>",anchor);
		obj.EI_cboClientRelation = Common_ComboToDic("EI_cboClientRelation","与患者关系<font color='red'>*</font>","RelationType",300,anchor);
		obj.EI_cboCardType = Common_ComboToDic("EI_cboCardType","证明材料<font color='red'>*</font>","Certificate",300,anchor);
		obj.EI_txtPersonalID = Common_TextField("EI_txtPersonalID","证件号码<font color='red'>*</font>",anchor);
		obj.EI_txtTelephone = Common_TextField("EI_txtTelephone","联系电话<font color='red'>*</font>",anchor);
		obj.EI_txtAddress = Common_TextField("EI_txtAddress","联系地址",anchor);
		obj.EI_txtClientNote = Common_TextArea("EI_txtClientNote","委托备注信息",50,500,anchor);
		obj.EI_cbgSContent = Common_CheckboxGroupToDic("EI_cbgSContent","封存内容<font color='red'>*</font>","MRCopyInfo",2,anchor);
		obj.EI_cbgSPurpose = Common_CheckboxGroupToDic("EI_cbgSPurpose","封存原因<font color='red'>*</font>","StoreReason",2,anchor);
		obj.EI_txtSCount = Common_TextField("EI_txtSCount","封存数量",anchor);
		obj.EI_txtSDocCode = Common_TextField("EI_txtSDocCode","医师<font color='red'>*</font>",anchor);
		obj.EI_txtSDocName = Common_TextField("EI_txtSDocName","工号<font color='red'>*</font>",anchor);
		obj.EI_txtSMedUserName = Common_TextField("EI_txtSMedUserName","医务处人员<font color='red'>*</font>",anchor);
		obj.EI_txtSMedUserCode = Common_TextField("EI_txtSMedUserCode","工号<font color='red'>*</font>",anchor);
		obj.EI_txtSNote = Common_TextArea("EI_txtSNote","备注信息",50,500,anchor);
		
		var winHeight = 400;
		if (SysOpera == 'H'){
			var formitmes = [
				{text:' ',style:'font-weight:bold;font-size:5px;height:5px;',xtype:'label'}
				,obj.EI_txtClientName
				,obj.EI_cboClientRelation
				,obj.EI_cboCardType
				,obj.EI_txtPersonalID
				,obj.EI_txtTelephone
				,obj.EI_txtAddress
				,obj.EI_txtClientNote
				,obj.EI_cbgSContent
				,obj.EI_cbgSPurpose
				,obj.EI_txtSCount
				,obj.EI_txtSDocCode
				,obj.EI_txtSDocName
				,obj.EI_txtSMedUserName
				,obj.EI_txtSMedUserCode
				,obj.EI_txtSNote
			]
		} else {}
	}
	
	obj.EI_btnSave = new Ext.Button({
		id : 'EI_btnSave'
		,iconCls : 'icon-update'
		,width: 60
		,text : '确定'
	});
	obj.EI_btnCancel = new Ext.Button({
		id : 'EI_btnCancel'
		,iconCls : 'icon-exit'
		,width: 60
		,text : '关闭'
	});
	
	obj.EI_WinExtraItem = new Ext.Window({
		id : 'EI_WinExtraItem'
		,autoScroll : true
		,width : 350
		,height : winHeight
		,modal : true
		,title : '附加信息登记'
		,closable : false
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 80
		,buttonAlign : 'center'
		,items : formitmes
		,frame : true
		,bbar : [
			'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
			,'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
			,'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
			,obj.EI_btnSave,obj.EI_btnCancel
		]
	});
	
	EI_InitExtraItemEvent(obj);
	obj.EI_LoadEvent(arguments);
	return obj;
}

