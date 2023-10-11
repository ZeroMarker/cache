
var userid = session['LOGON.USERID'];
var usercode = session['LOGON.USERCODE'];
var prjbudgfundsURL='herp.srm.srmprosoliethicauditexe.csp';

var rnt="";

///��˽��
var EthicResultDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '���ͨ��'],['2', '�޸ĺ�����'],['3', '�޸ĺ��ύ']]
	});		
		
var EthicResultCombox = new Ext.form.ComboBox({
	                   id : 'EthicResultCombox',
		           fieldLabel : '��˽��',
	                   width : 245,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : EthicResultDs,			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           selectOnFocus : true,
		           forceSelection : true
});		

/////////////////������ť/////////////////////
var FeedBackButton = new Ext.Toolbar.Button({
		id:'FeedBackButton',
		text: '������������',
        tooltip:'������������',        
        iconCls: 'pencil',
		handler:function(){
		var rowObj = EthicResultGrid.getSelectionModel().getSelections();
		
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			
			var isfeedback = rowObj[0].get("IsFeedBack");
			if(isfeedback != "��"){
				var rowObj = EthicResultGrid.getSelectionModel().getSelections();     // get the selected items
				var len = rowObj.length;
				if(len > 0)
				{  
					Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ�Ѹý��������������?�����󲻿��޸ġ�����ɾ����', function(btn) 
					{
						if(btn == 'yes')
						{	
							if(rowObj[0].get("IsFeedBack")!="��"){
								for(var i = 0; i < len; i++){     		
									Ext.Ajax.request({
										url: prjbudgfundsURL+'?action=feedback&rowid='+rowObj[i].get("rowid"),
										waitMsg:'�ύ��...',
										failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
										success: function(result, request){
											var jsonData = Ext.util.JSON.decode( result.responseText );
											if (jsonData.success=='true') { 
												Ext.MessageBox.alert('��ʾ', '�������');
												EthicResultGrid.load({params:{start:0, limit:25}});
												itemGrid.load({params:{start:0, limit:25}});
											}
											else {
												var message = "����ʧ��";
												Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
											}
										},
										scope: this
									});
								}
							}else{
								Ext.Msg.show({title:'����',msg:'��ѡ�����˽���ѷ����������ٴη���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								//return;
							}
						}
					});	
				}
				else
				{
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��������˽��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				}    
			}
			else {Ext.Msg.show({title:'����',msg:'��˽�����ύ�������ٴη�����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}				
		}
});

////////////////�ύ��ť//////////////////////////
var submitProSoliInfoButton  = new Ext.Toolbar.Button
({
		text: '�ύ�����д�',        
		iconCls: 'pencil',
		id: 'submitProSoliInfoButton',
		handler: function()
		{
			/* var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�ύ��Ŀ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			} */
			var DetailObj = EthicResultGrid.getSelectionModel().getSelections();
			var detaillen = DetailObj.length; 
			if(detaillen < 1)
			{
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�ύ��������˽��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			for(var j= 0; j < detaillen; j++)
			{
				var state = DetailObj[0].get("DataStatus");		
				if(state != '��')
				{
					submitFun();
				}
				else
				{
					{Ext.Msg.show({title:'����',msg:'��˽�����ύ�������ٴ��ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
				}
			}
		}
});
var EthicResultGrid = new dhc.herp.Gridlyf({
    region : 'center',
	title: '��Ŀ����������˲�ѯ�б�',
	iconCls: 'list',
    url: prjbudgfundsURL,
    fields: [
       new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: '��Ŀ�����������',
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'prjrowid',
        header: '��ĿID',
        dataIndex: 'prjrowid',
        width:90,
        allowBlank: true,
		hidden: true
    },{ 
        id:'EthicChkResult',
        header: '������˽��',
        dataIndex: 'EthicChkResult',
        width:120,
        editable:true,
		hidden:false,
		update:true,
		type:EthicResultCombox
    },{ 
        id:'EthicAuditDesc',
        header: '�������˵��',
        dataIndex: 'EthicAuditDesc',
        width:180,
		update:true,
        editable:true
    },{
        id:'EthicAuditDate',
        header: '���ʱ��',
        width:100,
		allowBlank: true,
		editable:false,
        dataIndex: 'EthicAuditDate'
    }, {
        id:'SubUser',
        header: '��д��',
        width:100,
        editable:false,
        dataIndex: 'SubUser',
        hidden: false	
    },{
    	id:'IsFeedBack',
        header: '�Ƿ���',
		editable:false,
        width:80,
        dataIndex: 'IsFeedBack'
    },{
    	id:'DataStatus',
        header: '�Ƿ��ύ',
        width:180,
		editable:false,
        dataIndex: 'DataStatus'
    }]		
});

EthicResultGrid.addButton('-');
EthicResultGrid.addButton(FeedBackButton);

EthicResultGrid.addButton('-');
EthicResultGrid.addButton(submitProSoliInfoButton);