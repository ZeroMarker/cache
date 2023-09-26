function InitwinScreen(){
	var obj = new Object();
	
	//-----------------------------------------------------
	obj.winfDemName = new Ext.form.TextField({ //winfPMenuCode
		id : 'winfDemName'
		,margins : '{50,0,0,0}'
		,allowBlank : false
		,fieldLabel : '����'
		,anchor : '100%'
});
obj.winDemName = new Ext.Panel({
		id : 'winDemName'
		,buttonAlign : 'center'
		,columnWidth : .7
		,layout : 'form'
		,items:[
			obj.winfDemName
		]
	});

/* 	obj.winfDemType = new Ext.form.TextField({ //winfPLinkUrl
		id : 'winfDemType'
		,fieldLabel : '����'
		//,width : 50
		,anchor : '30%'
}); */
obj.winfDemType = Common_ComboToDic("winfDemType","��������","Type","");
obj.winDDemType = new Ext.Panel({
		id : 'winDDemType'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.winfDemType
		]
	});
obj.winFPanelf1 = new Ext.form.FormPanel({
		id : 'winFPanelf1'
		,buttonAlign : 'center'
		//,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winDemName
			,obj.winDDemType
		]
	});



obj.winfEmergency = Common_ComboToDic("winfEmergency","�����̶�","Emergency","");

obj.winTPanel1 = new Ext.Panel({
		id : 'winTPanel1'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.winfEmergency
		]
	});


obj.winfSerious = Common_ComboToDic("winfSerious","���س̶�","Degree","");

obj.winTPanel2 = new Ext.Panel({
		id : 'winTPanel2'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winfSerious
		]
	});
	
obj.cboDemUser = Common_ComboUser("cboDemUser","�ѹ�ͨ��Ա","");
obj.winTPanelUser = new Ext.Panel({
		id : 'winTPanelUser'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.cboDemUser
		]
	});

obj.winFPanel1 = new Ext.form.FormPanel({
		id : 'winFPanel1'
		,buttonAlign : 'center'
		//,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winTPanel1
			,obj.winTPanel2
			,obj.winTPanelUser
		]
	});


	
	
	

obj.chkActive = new Ext.form.Checkbox({
		id : 'chkActive'
		
		,checked : false
		,fieldLabel : '�󲹱�־'
	});
obj.chkActivePanel = new Ext.Panel({
		id : 'chkActivePanel'
		//,hidden:true
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.chkActive
		]
	});


obj.cboDemMenu = Common_ComboMenu("cboDemMenu","�˵�����");
obj.winTPanelMenu = new Ext.Panel({
		id : 'winTPanelMenu'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.cboDemMenu
		]
	});

obj.winfPhone = new Ext.form.TextField({ //winfPIconClass
		id : 'winfPhone'
		,fieldLabel : '�绰'
		,anchor : '100%'
});

obj.winTPanelPhone = new Ext.Panel({
		id : 'winTPanelPhone'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winfPhone
		]
	});

	obj.winFPanel4 = new Ext.form.FormPanel({
		id : 'winFPanel4'
		,buttonAlign : 'center'
		//,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winTPanelMenu
			,obj.winTPanelPhone
			,obj.chkActivePanel
		]
	});
	obj.winfDemDesc = new Ext.form.TextArea({ //winfPIconClass
		id : 'winfDemDesc'
		,height : 130
		,fieldLabel : '��������'
		,anchor : '90%'
	});
	
	/* obj.winTPanelDesc = new Ext.Panel({
		id : 'winTPanelDesc'
		,buttonAlign : 'center'
		//,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winfDemDesc
		]
	}); */
	
	obj.winfDemResult = new Ext.form.TextArea({ 
		id : 'winfDemResult'
		,height : 130
		,fieldLabel : 'Ҫ����'
		,anchor : '90%'
	});
	
	obj.winTPanelResult = new Ext.Panel({
		title: '��д������Ҫ��Ч��'
		,id : 'winTPanelResult'
		,buttonAlign : 'center'
		,border: true
		//,margins: '{5000,0,0,5000}'
		//,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winfDemDesc
			,obj.winfDemResult
		]
	});
	obj.DemandID = new Ext.form.TextField({
		id : 'DemandID'
		,hidden : true
});	
//-------------------------------------------------------------------------------------------------

obj.formPanel = new Ext.form.FormPanel({
		id :'formPanel',
        title: '�ϴ��ļ�',
        labelAlign: 'right',
        buttonAlign: 'center',
        labelWidth: 80,
        defaults: { autoWidth: true },
        padding: 10,
        frame: false,
        border: false,
        autoScroll: true,
        fileUpload: true,
        items: [       
                {
                    layout: 'column',
                    border: false,
                    columnWidth: 1,
                    items:
                     [
                      {
                          columnWidth: 1,
                          layout: 'form',
                          border: false,
                          items: [
                                   [
                                     {
                                         xtype: 'textfield',
                                         id: 'txtFile',
                                         fieldLabel: '�ϴ�·��',
                                         inputType: 'file',
                                         buttonText: '���',
                                         width: 258
                                     }
                                    ]
                                 ]
                      }
                     ]
                }        
               ]/* ,
          bbar: [
                 {
                    text:'�ϴ�',
                    iconCls: 'icon_uploading',
                    handler: function() {
                    
                    if (!formPanel.getForm().isValid()) {
                        Ext.MessageBox.alert("��Ϣ", "��������֤ʧ�ܣ�����ȷ��д������");
                        return;
                    }
 
                        formPanel.form.submit({
                            waitMsg: 'Uploading ....',
                            url: 'Upload.ashx',
                            method: "POST",
                            success: function(form, action) {
                             
                            },
                            failure:function(form,action){

                            }

                            }
                            
                        );
                        
                    }                 
                 }
                ]   */             
     });
	


//--------------------------------------------------------------------------------------------------

obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '��������'
		,anchor : '95%'
	});
	
	obj.btnApply = new Ext.Button({
		id : 'btnApply'
		,iconCls : 'icon-add'
		//,columnWidth : .15
		,text : '�ύ����'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-cancel'
		//,columnWidth : .15
		,text : 'ȡ������'
	});
	
	
obj.winTPanelName1 = new Ext.Panel({
		id : 'winTPanelName1'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,margins : '{5,0,0,0}'
		,height:'80%'
		,title : '������Ϣ'
		,layout : 'form'
		,region : 'center'
		,frame : true
		,items:[
			obj.winFPanelf1
			,obj.winFPanel1
			,obj.winFPanel4
			,obj.formPanel
			
			,obj.winTPanelResult
			//,obj.winFPanelBtn 
			
			,obj.DemandID
		]
		,	buttons:[
			obj.btnSave
			,obj.btnApply
			,obj.btnDelete
		]
	});
	
	
	//-----------------------------------------------------
	
	
	
	
	
	//------------------------------------------------------------------------------------------------------
	
		
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 600
		,buttonAlign : 'center'
		,width : 800
		,modal : true
		,title : '��������'
		,layout : 'border'
		,items:[
			obj.winTPanelName1
			//,obj.winTPanelName2
	
		]
	});
	
	
	InitwinScreenEvent(obj);
	
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnApply.on("click", obj.btnApply_click, obj);
	obj.btnDelete.on("click", obj.btnDelete_click, obj);
	//�¼��������
	obj.LoadEvent(arguments);
  
  return obj;
}