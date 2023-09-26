	///Creator:bianshuai
	///CreatDate:2014-04-24
	///Descript:�����ɹ��ƻ���
	InPurPlanConWin=function(Fn){
		var ConsumeLoc = new Ext.ux.LocComboBox({
			fieldLabel : '���Ŀ���',
			id : 'ConsumeLoc',
			name : 'ConsumeLoc',
			anchor : '90%',
			emptyText : '���Ŀ���...',
			defaultLoc:""
		});

		// ��������
		var PurLoc = new Ext.ux.LocComboBox({
			fieldLabel : '�ɹ�����',
			id : 'PurLoc',
			name : 'PurLoc',
			anchor : '90%',
			emptyText : '�ɹ�����...',
			groupId:session['LOGON.GROUPID']
		});
		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
			fieldLabel : '��ʼ����',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			value : DefaultStDate()
		});
		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
			fieldLabel : '��ֹ����',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			value : DefaultEdDate()
		});

		var UseDays =new Ext.form.NumberField({
			fieldLabel : '��ҩ����',
			id : 'UseDays',
			name : 'UseDays',
			anchor : '90%'
		});
			// �б�
			var ZBFlag = new Ext.form.Radio({
			boxLabel : '�б�',
			id : 'ZBFlag',
			name : 'ZBType',
			anchor : '80%'
		});
		// ���б�
		var NotZBFlag = new Ext.form.Radio({
			boxLabel : '���б�',
			id : 'NotZBFlag',
			name : 'ZBType',
			anchor : '80%'
		});
		// ȫ��
		var AllFlag = new Ext.form.Radio({
			boxLabel : 'ȫ��',
			id : 'AllFlag',
			name : 'ZBType',
			anchor : '80%',
			checked : true
		});
		// ҩƷ����
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			LocId:session['LOGON.CTLOCID'],
			UserId:session['LOGON.USERID'],
			anchor : '90%'
		}); 
		// ������
		var M_StkCat = new Ext.ux.ComboBox({
			fieldLabel : '������',
			id : 'M_StkCat',
			name : 'M_StkCat',
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpId:'StkGrpType'}
		});
		var PFlag = new Ext.form.Checkbox({
			boxLabel : 'סԺ��ҩ',
			id : 'PFlag',
			name : 'PFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});
		var YFlag = new Ext.form.Checkbox({
			boxLabel : 'סԺ��ҩ',
			id : 'YFlag',
			name : 'YFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});
		var FFlag = new Ext.form.Checkbox({
			boxLabel : '���﷢ҩ',
			id : 'FFlag',
			name : 'FFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});
		var HFlag = new Ext.form.Checkbox({
			boxLabel : '������ҩ',
			id : 'HFlag',
			name : 'HFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});
		var TFlag = new Ext.form.Checkbox({
			boxLabel : 'ת��',
			id : 'TFlag',
			name : 'TFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});
		var KFlag = new Ext.form.Checkbox({
			boxLabel : 'ת��',
			id : 'KFlag',
			name : 'KFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});

		// �رհ�ť
		var closeBT = new Ext.Toolbar.Button({
			text : '�ر�',
			//tooltip : '����ر�',
			iconCls : 'page_close',
			handler : function() {
				window.close();
			}
		});

		// ȷ�ϰ�ť
		var sureBT = new Ext.Toolbar.Button({
			text : 'ȷ��',
			id:'sure',
			//tooltip : '���ȷ��',
			iconCls:'page_save',
			handler : function() {
				createInPurPlan();
			}
		})
		//����
	  var mask = new Ext.LoadMask(Ext.getBody(), {
		  msg : '���Ժ� ... ',                           
		  removeMask : true
	  }); 

  	  //�����ɹ��ƻ���
	  function createInPurPlan()
	  { 
		var PurLoc = Ext.getCmp("PurLoc").getValue();   //�ɹ�����
		var ConsumeLoc = Ext.getCmp("ConsumeLoc").getValue();  //���Ŀ���
		var startDate = Ext.getCmp("StartDate").getRawValue(); //��ʼ����
		var endDate = Ext.getCmp("EndDate").getRawValue();     //��������
		var UseDays = Ext.getCmp("UseDays").getValue();   //�ο�����
        
		if (PurLoc == undefined || PurLoc.length <= 0) {
			Msg.info("warning", "��ѡ��ɹ�����!");
			return;
		}
	
		if (startDate == undefined || startDate.length <= 0) {
			Msg.info("warning", "��ѡ��ʼ����!");
			return;
		}
		if (endDate == undefined || endDate.length <= 0) {
			Msg.info("warning", "��ѡ���ֹ����!");
			return;
		}
		var stkgrp=Ext.getCmp("StkGrpType").getValue();
		var stkcat=Ext.getCmp("M_StkCat").getValue();
	 
		//ҵ������
		var TransType='';
		var PFlag=(Ext.getCmp("PFlag").getValue()==true?'P':'');
		var YFlag=(Ext.getCmp("YFlag").getValue()==true?'Y':'');
		var FFlag=(Ext.getCmp("FFlag").getValue()==true?'F':'');
		var HFlag=(Ext.getCmp("HFlag").getValue()==true?'H':'');
		var TFlag=(Ext.getCmp("TFlag").getValue()==true?'T':'');
		var KFlag=(Ext.getCmp("KFlag").getValue()==true?'K':'');
		if(PFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+PFlag;
			}else{
				TransType=PFlag;
			}
		}
		if(YFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+YFlag;
			}else{
				TransType=YFlag;
			}
		}
		if(FFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+FFlag;
			}else{
				TransType=FFlag;
			}
		}
		if(HFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+HFlag;
			}else{
				TransType=HFlag;
			}
		}
		if(TFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+TFlag;
			}else{
				TransType=TFlag;
			}
		}
		if(KFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+KFlag;
			}else{
				TransType=KFlag;
			}
		}
		if (TransType == null || TransType.length <= 0) {
			Msg.info("warning", "��ѡ��ҵ������!");
			return;
		}
		if (UseDays==""){
	        Msg.info("warning", "����д��ҩ����!");
			return;
	    }
		if(ConsumeLoc==""){ConsumeLoc=PurLoc;}  //���Ŀ���Ϊѡ��Ĭ�ϲɹ�����
		var StrParam=ConsumeLoc+"^"+startDate+"^"+endDate+"^"+UseDays+"^"+stkgrp+"^"+TransType+"^"+PurLoc;
		StrParam=StrParam+"^"+session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+stkcat;
		mask.show(); //�ڸ�
		//���ɼƻ���
		Ext.Ajax.request({
			url: DictUrl+'inpurplanaction.csp?actiontype=CreateInPurPlan',
			params:{strParam:StrParam},
			failure: function(result, request) {
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					window.close();
					Msg.info("success","����ɹ�!");
					mask.hide(); //�ڸ�����
					purId=jsonData.info;
					Fn(purId);
					//location.href="dhcst.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId;
				}else{
					if(jsonData.info==""){
						Msg.info("error","���һ���ԱΪ��!");
					}else if(jsonData.info=="-1"){
						Msg.info("warning","������Χ���޿�������!");
					}else{
						Msg.info("error","����ʧ��!");
					}
					mask.hide(); //�ڸ�����
					return;
				}
			},
			scope: this
		});
	  }
			//��ʼ�����
		var vendorPanel = new Ext.form.FormPanel({
			labelwidth : 30,
			labelAlign : 'right',
			frame : true,
			autoScroll : false,
			//bodyStyle : 'padding:1px;',
			items : [{
				autoHeight : true,
				items : [{
					xtype : 'fieldset',
					title : '�ƻ�����',
					autoHeight : true,
					items : [{
						layout : 'column',
						height:25,
						items : [ 
							{columnWidth:.5,layout:'form',items:[StartDate]},
							{columnWidth:.5,layout:'form',items:[PurLoc]}
						]
				    },{
					    layout : 'column',
					    height:25,
					    items : [
						   {columnWidth:.5,layout:'form',items:[EndDate]},
						   {columnWidth:.5,layout:'form',items:[ConsumeLoc]}
					    ]
				   },{
					    layout : 'column',
					    height:25,
					    items : [
						   {columnWidth:.5,layout:'form',items:[UseDays]},
						   {columnWidth:.5,layout:'form',items:[StkGrpType]}
					    ]
				   },{
					    layout : 'column',
					    height:25,
					    items : [
						   {columnWidth:.5,layout:'form',items:[M_StkCat]}
					    ]
				   }]
				},{
					xtype : 'fieldset',
					title : 'ҵ������',
					autoHeight : true,
					items : [{
						layout:'column',
						height:25,
						items : [
							{columnWidth:.5,layout:'form',items:[PFlag]},
							{columnWidth:.5,layout:'form',items:[YFlag]}
						]
					},{
						layout:'column',
						height:25,
						items : [
							{columnWidth:.5,layout:'form',items:[FFlag]},
							{columnWidth:.5,layout:'form',items:[HFlag]}
						]
					},{
						layout:'column',
						height:25,
						items : [
							{columnWidth:.5,layout:'form',items:[TFlag]},
							{columnWidth:.5,layout:'form',items:[KFlag]}
						]
					}]
				}]
			}]
		})

		var window=new Ext.Window({
			title:'���տ��ҿ�����ɲɹ��ƻ�',
			width:600,
			height:330,
			modal:true,
			resizable:false,
			items:vendorPanel,
			bbar:[sureBT,"-",closeBT]
		})
		
		window.show();
	}