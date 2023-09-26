function InitEditViewport(){
	var obj = new Object();
	
	//取复印登记记录信息
	obj.VC_Input = new Object();
	obj.VC_Input.RecordID = arguments[0];
	var sCopyInfo = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","GetCopyInfo",obj.VC_Input.RecordID);
	if (sCopyInfo) {
		var arrCopyInfo = sCopyInfo.split('^');
		obj.VC_Input.RecordID = arrCopyInfo[0];
		obj.VC_Input.MrTypeID = arrCopyInfo[1];
		obj.VC_Input.MrNo = arrCopyInfo[2];
		obj.VC_Input.VolumeIDs = arrCopyInfo[3];
		obj.VC_Input.StatusCode = arrCopyInfo[4];
		obj.VC_Input.ClientName = arrCopyInfo[5];
		obj.VC_Input.RelationID = arrCopyInfo[6];
		obj.VC_Input.RelationDesc = arrCopyInfo[7];
		obj.VC_Input.CardTypeID = arrCopyInfo[8];
		obj.VC_Input.CardTypeDesc = arrCopyInfo[9];
		obj.VC_Input.PersonalID = arrCopyInfo[10];
		obj.VC_Input.Telephone = arrCopyInfo[11];
		obj.VC_Input.Address = arrCopyInfo[12];
		obj.VC_Input.PurposeIDs = arrCopyInfo[13];
		obj.VC_Input.PurposeDescs = arrCopyInfo[14];
		obj.VC_Input.ContentIDs = arrCopyInfo[15];
		obj.VC_Input.ContentDescs = arrCopyInfo[16];
		obj.VC_Input.Resume = arrCopyInfo[17];
		obj.VC_Input.PaperNumber = arrCopyInfo[18];
		obj.VC_Input.CopyMoney = arrCopyInfo[19];
	} else {
		obj.VC_Input.RecordID = '';
		obj.VC_Input.MrTypeID = '';
		obj.VC_Input.MrNo = '';
		obj.VC_Input.VolumeIDs = '';
		obj.VC_Input.StatusCode = '';
		obj.VC_Input.ClientName = '';
		obj.VC_Input.RelationID = '';
		obj.VC_Input.RelationDesc = '';
		obj.VC_Input.CardTypeID = '';
		obj.VC_Input.CardTypeDesc = '';
		obj.VC_Input.PersonalID = '';
		obj.VC_Input.Telephone = '';
		obj.VC_Input.Address = '';
		obj.VC_Input.PurposeIDs = '';
		obj.VC_Input.PurposeDescs = '';
		obj.VC_Input.ContentIDs = '';
		obj.VC_Input.ContentDescs = '';
		obj.VC_Input.Resume = '';
		obj.VC_Input.PaperNumber = '';
		obj.VC_Input.CopyMoney = '';
	}
	
	obj.ClientName 			= Common_TextField("ClientName","委托人");
	obj.cboClientRelation 	= Common_ComboToDic("cboClientRelation","与患者关系","RelationType");
	obj.cboCardType 		= Common_ComboToDic("cboCardType","证明材料","Certificate");
	obj.txtPersonalID 		= Common_TextField("txtPersonalID","证件号码");
	obj.txtTelephone 		= Common_TextField("txtTelephone","联系电话");
	obj.txtAddress 			= Common_TextField("txtAddress","联系地址");
	obj.cbgPurpose 			= Common_CheckboxGroupToDC("cbgPurpose","复印目的","CopyAim",4,"cboHospital");
	obj.cbgContent 			= Common_CheckboxGroupToDC("cbgContent","复印内容","MrCopyInfo",4,"cboHospital");
	obj.txtNote 			= Common_TextField("txtNote","备注");
	
	obj.txtPaperNumber = new Ext.form.TextField({
		id : "txtPaperNumber"
		,selectOnFocus:true
		,fieldLabel : "复印页数"
		,labelSeparator :''
		,regex : /^[A-Za-z0-9]+$/
		,style: 'font-weight:bold;font-size:24'
		,labelStyle: 'font-weight:bold;font-size:22'
		,width : 80
		,height : 30
		,anchor : '100%'
	});
	
	obj.txtCopyPrice = new Ext.form.Label({
		id : "txtCopyPrice"
		,text : "费用"
		,style: 'font-weight:bold;font-size:22;color:red;'
		,width : 10
		,height : 27
		,anchor : '100%'
	});
	
	obj.btnBook = new Ext.Button({
		id : 'btnBook'
		,iconCls : 'icon-edit'
		,width : 80
		,anchor : '100%'
		,text : '装订'
	});
	
	obj.btnCharge = new Ext.Button({
		id : 'btnCharge'
		,iconCls : 'icon-edit'
		,width : 80
		,anchor : '100%'
		,text : '收费'
	});
	
	obj.btnRetFee = new Ext.Button({
		id : 'btnRetFee'
		,iconCls : 'icon-delete'
		,width : 80
		,anchor : '100%'
		,text : '退费'
	});
	
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-delete'
		,width : 80
		,anchor : '100%'
		,text : '作废'
	});
	
	obj.EditViewport = new Ext.Window({
		id: 'EditViewport'
		,height : 500
		,width : 750
		,modal : true
		,title : '复印信息'
		,closable : true
		,buttonAlign : 'center'
		,frame : true
		,layout : 'fit'
		,items:[
			{
				layout:'form'
				,frame : true
				,items:[
					{
						layout : 'column',
						items : [
							{
								width:350
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.ClientName]
							},{
								width:350
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 90
								,items: [obj.cboClientRelation]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								width:350
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.cboCardType]
							},{
								width:350
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 90
								,items: [obj.txtPersonalID]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								width:350
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtTelephone]
							},{
								width:350
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 90
								,items: [obj.txtAddress]
							}
						]
					},{
						heigth : 1
					},{
						width:700
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cbgPurpose]
					},{
						heigth : 1
					},{
						width:700
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cbgContent]
					},{
						heigth : 1
					},{
						width:700
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.txtNote]
					},{
						heigth : 5
					},{
						layout : 'column',
						items : [
							{
								width:240
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 150
								,items: [obj.txtPaperNumber]
							},{
								width:50
							},{
								width:400
								,layout : 'form'
								,items: [obj.txtCopyPrice]
							}
						]
					}
				]
			}
		]
		,buttons:[obj.btnBook,obj.btnCancel,obj.btnCharge,obj.btnRetFee]
	});
	
	InitEditViewportEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}