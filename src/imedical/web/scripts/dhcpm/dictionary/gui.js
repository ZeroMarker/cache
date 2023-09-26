/*  Desc: ����ԭ������桾�ֵ����������ƣ�PMP.Dictionary3 
  Author��liubaoshi 
    Date: 2015-04-02
*/
function InitViewport(){
	var obj = new Object();	
	obj.bodyType=new Ext.form.ComboBox({
				id:'bodyType',
				fieldLabel:"�ֵ����",
				allowBlank:false,
				mode:'local',
				valueNotFoundText : '',
		        editable : true,
				store:new Ext.data.ArrayStore({    //��������,����������JsonReader
						fields:['code','desc'],
						data:[['Status','ģ��״̬']
							  ,['Product','��Ʒ��']
							  ,['Profession','ְ��']
							  ,['Emergency','�����̶�']
							  ,['Improvement','����״̬']
							  ,['Type','��������']
							  ,['Degree','���س̶�']
							  ,['IPMDFlag','�������']
							  ,['Communication','��ͨ��ʽ']
							  ,['CompanyType','��˾����']
							  ,['ProductType','��Ʒ����']
							  ,['Unit','��λ']
							  ,['ContractGroup','��ͬ����']
							  ,['ContractType','��ͬ����']
							  ,['Currency','����']
							  ,['ModeExecution','��ͬ���з�ʽ']
							  ,['ConcludeMode','������ʽ']
							  ,['Source','��ͬ�ɹ���Դ']
							  ,['ContractStatus','��ͬ״̬']
							  ,['MODEGROUP','ģ�����']
							  ,['Level','��ͬ���⼶��']
							  ,['Aging','��ͬ����']
							  ,['AgingStatus','����״̬']
							  ,['DocumentGroup','�ĵ�����']
							  ,['DocumentLevel','�ĵ�����']
							  ,['DocumentStatus','�ĵ�״̬']
							  ,['PlanType','����ƻ�����']
							  ,['PlanStatus','����ƻ�״̬']
							  ,['TreeType','����������']
							  ]
				}),
				displayField:'desc',
				valueField:'code',
				editable:false,
				anchor : '95%',
				triggerAction : 'all'
				//��ԭ�����Ч������һ��,��ʱע�ͼ���
				/*
				,listeners:{
					select:function(x,y,curindex){
						var SSObject=Ext.getCmp('gridList');
						SSObject.store.load({params : {start:0,limit:20}});
					}
				}
				*/
					
	});
	obj.bodyCode = new Ext.form.TextField({		
		id : 'bodyCode'
		,allowBlank : false
		,emptyText:'����д����...'
		,fieldLabel : "�ֵ����"         
		,anchor : '95%'
	});
	obj.bodyDesc = new Ext.form.TextField({		
		id : 'bodyDesc'
		,allowBlank : false
		,emptyText:'����д����...'
		,fieldLabel : "�ֵ�����"      
		,anchor : '95%'
	});
	obj.bodyNote = new Ext.form.TextField({		
		id : 'bodyNote'
		,allowBlank : true
		,emptyText:'����д��ע...'
		,fieldLabel : "�ֵ䱸ע"     
		,anchor : '95%'   
	});
	obj.btnSave = new Ext.Button({				
		id : 'btnSave'
		,tooltip:'����µ��ֵ�����'
		,iconCls : 'add'
		,anchor : '30%'
		,text : '���'
	});
	obj.btnSave1 = new Ext.Button({				
		id : 'btnSave1'
		,tooltip:'����µ��ֵ�����'
		,iconCls : 'add'
		,anchor : '30%'
		,text : '���'
	});
	obj.btnDel = new Ext.Button({			
		id : 'btnDel'
		,tooltip:'ɾ��ѡ�����ֵ�����'
		,iconCls : 'remove'
		,anchor : '30%'
		,text : 'ɾ��'
	});
	//�Ҽ�ɾ��(ֱ�ӵ���ԭbtn,������д��)
	/*
	obj.RightbtnDel = new Ext.Button({				
		id : 'RightbtnDel'
		,iconCls : 'remove'
		,anchor : '30%'
		,text : 'ɾ��'
	});
	*/
	obj.btnInput = new Ext.Button({				
		id : 'btnInput'
		,tooltip:'����Excel����'
		,iconCls : 'accordion'
		,anchor : '30%'
		,text : '����'
	});
	obj.btnSch = new Ext.Button({				
		id : 'btnSch'
		,tooltip:'��ѯ����'
		,iconCls : 'option'
		,anchor : '30%'
		,text : '��ѯ'
	});
	obj.btnClear = new Ext.Button({				
		id : 'btnClear'
		,tooltip:'��ղ�ѯ����'
		,iconCls : 'option'
		,anchor : '30%'
		,text : '���'
	});
	obj.btnUpdate = new Ext.Button({				
		id : 'btnUpdate'
		,tooltip:'����ѡ�е�����'
		,iconCls : 'option'
		,anchor : '30%'
		,text : '����'
	});
	//����1
	obj.btnUpdate1 = new Ext.Button({				
		id : 'btnUpdate1'
		,tooltip:'����ѡ�е�����'
		,iconCls : 'option'
		,anchor : '30%'
		,text : '����'
	});
	//�Ҽ�
	obj.RightMenu = new  Ext.menu.Menu({
		items : [

			{
				id : 'Update'
				,iconCls : 'add'
				,text :'����'
				,handler: function(){obj.btnUpdate1_click();}
			},

			{
				id : 'RightbtnDel'
				,iconCls : 'remove'
				,handler: function(){obj.btnDel_click();}   
				,text :'ɾ��'
					
			}
		]
	});
	//panel-1
	obj.headpanel = new Ext.Panel({				
		id : 'headpanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
							                  
			 obj.bodyCode
			,obj.bodyType
		]
	});
	//panel-2
	obj.Panel2 = new Ext.Panel({			  
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.bodyDesc
		],buttons:[						
			//obj.btnSave,
			//obj.btnDel,
			//obj.btnInput,
			//obj.btnSch
		]
	});
	//panel-3
	obj.Panel3 = new Ext.Panel({			
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.bodyNote
		],buttons:[
		    //obj.btnClear
		]
	});

	obj.fPanel = new Ext.form.FormPanel({	
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,title : '�ֵ�ά��'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,height : 100
		,collapsible : true               
		,items:[
			obj.headpanel,
			obj.Panel2,
			obj.Panel3
		]
	});
	
	obj.gridListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL	
			
		}));
	obj.gridListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.PMPDictionary';
			param.QueryName = 'SelectDictionary';
			param.Arg1 = Ext.getCmp('bodyType').getValue();
			param.Arg2 = Ext.getCmp('bodyCode').getValue();
			param.Arg3 = Ext.getCmp('bodyDesc').getValue();
			param.Arg4 = Ext.getCmp('bodyNote').getValue();
			param.ArgCnt = 4;
	});
	obj.gridListStore = new Ext.data.Store({
		proxy: obj.gridListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			fields:[
			{
			name: 'DTYCode', 
			mapping: 'DTYCode'
			},
			{
			name: 'DTYDesc', 
			mapping: 'DTYDesc'
			},
			{
			name: 'DTYFlag',
			mapping: 'DTYFlag'
			},
			{
			name: 'DTYRemark', 
			mapping: 'DTYRemark'
			},
			{
			name: 'RowID',
			mapping: 'RowID'
			}
			]
		})
	});
	
	obj.gridListStore.load({params : {start:0,limit:20}});   

	obj.gridList = new Ext.grid.GridPanel({		
		id : 'gridList'
		,buttonAlign : 'center'
		,store : obj.gridListStore
		,loadMask : true
		,region : 'center'
		,viewConfig:{        
			forceFit: true
		}
		,columns: [
			 new Ext.grid.RowNumberer(),
			 {
			 header: '�ֵ����', 
			 dataIndex: 'DTYCode', 
			 width: 100, 
			 align: 'left',
			 sortable: true
			 },
			 {
			 header: '�ֵ�����',
			 dataIndex: 'DTYDesc', 			 
			 width: 250, 
			 align: 'left',
			 sortable: true
			 },
			 {
			 header: '�ֵ��־',
			 dataIndex:'DTYFlag',
			 width: 100, 
			 align: 'left',
			 sortable: true
			 },
			 {
			 header:'�ֵ䱸ע',
			 dataIndex:'DTYRemark',
			 width: 300,
			 align: 'left',
			 sortable: true
			 },
			 {
			 header:'�ֵ�ID',
			 dataIndex:'RowID',
			 width: 150,
			 align: 'left',
			 sortable: true
			 }
		]
		,tbar: [obj.btnSave1,'-',obj.btnUpdate1,'-',obj.btnDel,'-',obj.btnInput,'-',obj.btnSch,'-',obj.btnClear]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.gridListStore,
			displayMsg: '��ʾ��¼:{0}-{1},�ϼ�:{2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})

	});

	obj.Viewport = new Ext.Viewport({	
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.fPanel
			,obj.gridList
		]
	});
	
	InitViewportEvent(obj);	
	obj.btnSave.on("click", obj.btnSave_click, obj);	
	obj.btnDel.on("click", obj.btnDel_click, obj);
	//obj.RightbtnDel.on("click", obj.RightbtnDel_click, obj);
	obj.btnUpdate.on("click", obj.btnUpdate_click, obj)
	obj.btnInput.on("click", obj.btnInput_click, obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.btnClear.on("click", obj.btnClear_click, obj);
	obj.gridList.on("rowcontextmenu", obj.rightClickFn_click, obj);   
	obj.gridList.on("rowdblclick", obj.gridList_rowclick,obj) 
	obj.btnSave1.on("click", obj.btnSave1_click, obj);       
	obj.btnUpdate1.on("click", obj.btnUpdate1_click, obj);  
	obj.bodyCode.on("specialkey", obj.bodyCode_specialkey,obj)  //����س��¼�
	obj.bodyDesc.on("specialkey", obj.bodyDesc_specialkey,obj)  //�����س��¼�
	obj.bodyNote.on("specialkey", obj.bodyNote_specialkey,obj)  //��ע�س��¼�
	obj.bodyType.on("specialkey", obj.bodyType_specialkey,obj)  //����س��¼�
	obj.LoadEvent(arguments);
	
  	return obj;
}

function InitwinScreen()
{
	var obj = new Object();
		obj.winbodyType=new Ext.form.ComboBox({
				id:'winbodyType',
				fieldLabel : '<font color="red">�ֵ����</font>',
				allowBlank:false,
				mode:'local',
				valueNotFoundText : '',
		        editable : true,
				store:new Ext.data.ArrayStore({    //��������,����������JsonReader
						fields:['code','desc'],
						data:[['Status','ģ��״̬']
							  ,['Product','��Ʒ��']
							  ,['Profession','ְ��']
							  ,['Emergency','�����̶�']
							  ,['Improvement','����״̬']
							  ,['Type','��������']
							  ,['Degree','���س̶�']
							  ,['IPMDFlag','�������']
							  ,['Communication','��ͨ��ʽ']
							  ,['CompanyType','��˾����']
							  ,['ProductType','��Ʒ����']
							  ,['Unit','��λ']
							  ,['ContractGroup','��ͬ����']
							  ,['ContractType','��ͬ����']
							  ,['Currency','����']
							  ,['ModeExecution','��ͬ���з�ʽ']
							  ,['ConcludeMode','������ʽ']
							  ,['Source','��ͬ�ɹ���Դ']
							  ,['ContractStatus','��ͬ״̬']
							  ,['MODEGROUP','ģ�����']
							  ,['Level','��ͬ���⼶��']
							  ,['Aging','��ͬ����']
							  ,['AgingStatus','����״̬']
							  ,['DocumentGroup','�ĵ�����']
							  ,['DocumentLevel','�ĵ�����']
							  ,['DocumentStatus','�ĵ�״̬']
							  ,['PlanType','����ƻ�����']
							  ,['PlanStatus','����ƻ�״̬']
							  ,['TreeType','����������']
							  ]
				}),
				displayField:'desc',
				valueField:'code',
				editable:false,
				anchor : '95%',
				triggerAction : 'all'
				//��ԭ�����Ч������һ��,��ʱע�ͼ���
				/*
				,listeners:{
					select:function(x,y,curindex){
						var SSObject=Ext.getCmp('gridList');
						SSObject.store.load({params : {start:0,limit:20}});
					}
				}
				*/
					
	});
	obj.winRowid= new Ext.form.TextField({
		id : 'winRowid'
		,width : 40
		,minChars : 1
		,displayField : 'Rowid'
		,fieldLabel : 'Rowid'
		,disabled:true
		//,editable : true
		//,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.winbodyCode = new Ext.form.TextField({		
		id : 'winbodyCode'
		,allowBlank : false
		,emptyText:'����д����...'
		,fieldLabel : '<font color="red">�ֵ����</font>'
		,anchor : '95%'
	});
	obj.winbodyDesc = new Ext.form.TextField({		
		id : 'winbodyDesc'
		,allowBlank : false
		,emptyText:'����д����...'
		,fieldLabel : '<font color="red">�ֵ�����</font>'
		,anchor : '95%'
	});
	obj.winbodyNote = new Ext.form.TextField({		
		id : 'winbodyNote'
		,allowBlank : true
		,emptyText:'����д��ע...'
		,fieldLabel : '<font color="red">�ֵ䱸ע</font>'
		,anchor : '95%'
	});	
	obj.winSave = new Ext.Button({
		id : 'winSave'
		,iconCls : 'add'
		,text : '����'
	});
	obj.winCancel = new Ext.Button({
		id : 'winCancel'
		,iconCls : 'remove'
		,text : 'ȡ��'
	});
	obj.windictionarypanel = new Ext.Panel({
		id : 'windictionarypanel'
		//,labelAlign : 'right'
		,buttonAlign : 'center'
		//,margins : '{3,0,0,0}'
		//,height:'80%'
		//,title : '�ֵ�'
		,layout : 'form'
		,region : 'center'
		,labelWidth:80
		,frame : true
		,items:[
			obj.winRowid
		    ,obj.winbodyType
			,obj.winbodyCode
			,obj.winbodyDesc 
			,obj.winbodyNote 
		]
	});
	obj.windictionary = new Ext.Window({
		id : 'windictionary'
		,height : 300
		,buttonAlign : 'center'
		,width : 350
		,modal : true
		,title : '�ֵ�����ά��'
		,layout : 'border'
		,border:true
		,items:[
			   obj.windictionarypanel
		]
		,buttons:[
			   obj.winSave
			  ,obj.winCancel
		]
	});

	//�¼�����
	InitwinScreenEvent(obj);
	obj.winSave.on("click",obj.winSave_click,obj);
	obj.winCancel.on("click",obj.winCancel_click,obj);
	obj.LoadEvent(arguments);
    
	return obj;

}
