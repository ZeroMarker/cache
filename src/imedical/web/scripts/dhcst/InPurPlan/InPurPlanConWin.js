	///Creator:bianshuai
	///CreatDate:2014-04-24
	///Descript:�����ɹ��ƻ���
	InPurPlanConWin=function(Fn){
		var ConsumeLoc = new Ext.ux.LocComboBox({
			fieldLabel : $g('���Ŀ���'),
			id : 'ConsumeLoc',
			name : 'ConsumeLoc',
			anchor : '90%',
			emptyText : $g('���Ŀ���...'),
			defaultLoc:""
		});

		// ��������
		var PurLoc = new Ext.ux.LocComboBox({
			fieldLabel : $g('�ɹ�����'),
			id : 'PurLoc',
			name : 'PurLoc',
			anchor : '90%',
			emptyText : $g('�ɹ�����...'),
			groupId:session['LOGON.GROUPID'],
			listeners : {
			'select' : function(e) {
                          var PurLoc=Ext.getCmp('PurLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
                          StkGrpType.getStore().removeAll();
                          StkGrpType.getStore().setBaseParam("locId",PurLoc)
                          StkGrpType.getStore().setBaseParam("userId",UserId)
                          StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
                          StkGrpType.getStore().load();
				}
		}
		});
		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
			fieldLabel : $g('��ʼ����'),
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			value : DefaultStDate()
		});
		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
			fieldLabel : $g('��ֹ����'),
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			value : DefaultEdDate()
		});

		var UseDays =new Ext.form.NumberField({
			fieldLabel : $g('��ҩ����'),
			id : 'UseDays',
			name : 'UseDays',
			anchor : '90%'
		});
			// �б�
			var ZBFlag = new Ext.form.Radio({
			boxLabel : $g('�б�'),
			id : 'ZBFlag',
			name : 'ZBType',
			anchor : '80%'
		});
		// ���б�
		var NotZBFlag = new Ext.form.Radio({
			boxLabel : $g('���б�'),
			id : 'NotZBFlag',
			name : 'ZBType',
			anchor : '80%'
		});
		// ȫ��
		var AllFlag = new Ext.form.Radio({
			boxLabel : $g('ȫ��'),
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
		StkGrpType.on('select',function(){
		Ext.getCmp("M_StkCat").setValue("");
	});
		// ������
		var M_StkCat = new Ext.ux.ComboBox({
			fieldLabel : $g('������'),
			id : 'M_StkCat',
			name : 'M_StkCat',
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpId:'StkGrpType'}
		});
		var PFlag = new Ext.form.Checkbox({
			boxLabel : $g('סԺ��ҩ'),
			id : 'PFlag',
			name : 'PFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});
		var YFlag = new Ext.form.Checkbox({
			boxLabel : $g('סԺ��ҩ'),
			id : 'YFlag',
			name : 'YFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});
		var FFlag = new Ext.form.Checkbox({
			boxLabel : $g('���﷢ҩ'),
			id : 'FFlag',
			name : 'FFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});
		var HFlag = new Ext.form.Checkbox({
			boxLabel : $g('������ҩ'),
			id : 'HFlag',
			name : 'HFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});
		var TFlag = new Ext.form.Checkbox({
			boxLabel : $g('ת��'),
			id : 'TFlag',
			name : 'TFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});
		var KFlag = new Ext.form.Checkbox({
			boxLabel : $g('ת��'),
			id : 'KFlag',
			name : 'KFlag',
			anchor : '90%',
			height : 30 ,
			//width : 80,
			checked : false
		});

		// �رհ�ť
		var closeBT = new Ext.Toolbar.Button({
			text : $g('�ر�'),
			//tooltip : '����ر�',
			iconCls : 'page_close',
			handler : function() {
				window.close();
			}
		});

		// ȷ�ϰ�ť
		var sureBT = new Ext.Toolbar.Button({
			text : $g('ȷ��'),
			id:'sure',
			//tooltip : '���ȷ��',
			iconCls:'page_save',
			handler : function() {
				createInPurPlan();
			}
		})
		//����
	  var mask = new Ext.LoadMask(Ext.getBody(), {
		  msg : $g('���Ժ� ... '),                           
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
			Msg.info("warning", $g("��ѡ��ɹ�����!"));
			return;
		}
	
		if (startDate == undefined || startDate.length <= 0) {
			Msg.info("warning", $g("��ѡ��ʼ����!"));
			return;
		}
		if (endDate == undefined || endDate.length <= 0) {
			Msg.info("warning", $g("��ѡ���ֹ����!"));
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
			Msg.info("warning", $g("��ѡ��ҵ������!"));
			return;
		}
		if (UseDays==""){
	        Msg.info("warning", $g("����д��ҩ����!"));
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
				Msg.info("error",$g("������������!"));
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
						Msg.info("error",$g("���һ���ԱΪ��!"));
					}else if(jsonData.info=="-1"){
						Msg.info("warning",$g("������Χ���޿�������!"));
					}else{
						Msg.info("error",$g("����ʧ��!"));
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
					title : $g('�ƻ�����'),
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
					title : $g('ҵ������'),
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
			title:$g('���տ��ҿ�����ɲɹ��ƻ�'),
			width:600,
			height:330,
			modal:true,
			resizable:false,
			items:vendorPanel,
			bbar:[sureBT,"-",closeBT]
		})
		
		window.show();
	}