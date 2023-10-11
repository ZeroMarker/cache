
listprjreimbursemenInfoFun=function(Name,ProjectDR){
	var Participantstitle = Name+"--������Ϣ";
	
	var ParticipantsInfo = new dhc.herp.Gridprs({
				width : 400,
				region : 'center',
				url : 'herp.srm.horizonprjsetupexe.csp',
				fields : [{
							header : 'Ԥ���ܶ�(��Ԫ)',
							width : 120,
							editable:false,
							dataIndex : 'BudgTotal',
							align : 'right',
							hidden : false,
							renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
						},{
							id : 'ActPayWait',
							header : '�ۼ���;�������(��Ԫ)',
							dataIndex : 'ActPayWait',
							align : 'right',
							width : 150,
							renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
						},{
							id : 'ActPay',
							header : '�ۼ���ִ�б������(��Ԫ)',
							dataIndex : 'ActPay',
							align : 'right',
							width : 180,
							renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
						}
						]
						//viewConfig : {forceFit : true}
						
	});

	ParticipantsInfo.btnAddHide();  //�������Ӱ�ť
   	ParticipantsInfo.btnSaveHide();  //���ر��水ť
    ParticipantsInfo.btnResetHide();  //�������ð�ť
    ParticipantsInfo.btnDeleteHide(); //����ɾ����ť
    ParticipantsInfo.btnPrintHide();  //���ش�ӡ��ť
    
	ParticipantsInfo.load({params : {start : 0,limit : 25,ProjectDR:ProjectDR}});
	//alert(ParticipantsIDs);
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({ text : '�ر�',iconCls : 'cancel'});
	// ����ȡ����ť����Ӧ����
	cancelHandler = function(){ 
	  window.close();
	};
	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
		
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [ParticipantsInfo]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : Participantstitle,
				iconCls: 'popup_list',
				plain : true,
				width : 600,
				height : 350,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};