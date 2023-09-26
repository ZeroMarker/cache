 var FINDConSultDoc_URL="dhcconsultrequest.csp?requestType=GetConSultDoc"
 var Doclistcombo=new Ext.data.ArrayStore({
			    id:"getDocList",
				fields: ['Docrowid','DocDesc'],
				baseParams: {act: 'GetDoclist'},
				url: "dhcconsultrequest.csp"			
			});
var DocListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));			
var DocListStore = new Ext.data.Store({
		proxy: DocListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctcpId'
		}, 
		[
			{name: 'ctcpDesc', mapping : 'ctcpDesc'}
			,{name: 'ctcpId', mapping: 'ctcpId'}
		])
	});
	
var ConSultItmLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var ConSultItmLocStore = new Ext.data.Store({
		proxy: ConSultItmLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ItmLocID'
		}, 
		[
			{name: 'ItmLocID', mapping : 'ItmLocID'}
			,{name: 'ItmLocDesc', mapping: 'ItmLocDesc'}
		])
	});		
 var comboData = [
        ['D','����ҽʦ'],
        ['A','������ҽʦ'],
        ['C','����ҽʦ'],
		['P','֪��ר��']
    ];
var DocGradstore=new Ext.data.SimpleStore({
                fields:['disvalue','distext'],
                data: comboData
            });
var PatName = new Ext.form.TextField({
		id : 'PatName' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '����' 
	});
var PatSex = new Ext.form.TextField({
		id : 'PatSex' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '�Ա�' 
	});
var PatAge = new Ext.form.TextField({
		id : 'PatAge' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '����' 
	});
var BedCode = new Ext.form.TextField({
		id : 'BedCode' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '����' 
	});
var PatRegNo = new Ext.form.TextField({
		id : 'PatRegNo' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '����ID' 
	});
var PatMedNo = new Ext.form.TextField({
		id : 'PatMedNo' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : 'סԺ��' 
	});
var PatWard = new Ext.form.TextField({
		id : 'PatWard' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '����' 
	});
var PatDiag = new Ext.form.TextField({
		id : 'PatDiag' 
		,width : 900
		,anchor : '100%'
		,fieldLabel : '���' 
	});
//��Ҫ����������Ŀ��
var ConDestination = new Ext.form.TextArea({
		id : 'ConDestination' 
		,xtype: "textarea"
		,labelWidth: 60
        ,width: 230
		,anchor : '100%'
		,fieldLabel : '����ժҪ' 
		,allowBlank: false
	});
//����Ŀ�ġ�����������
var ConDestinationtwo = new Ext.form.TextArea({
		id : 'ConDestinationtwo' 
		,xtype: "textarea"
		,labelWidth: 60
        ,width: 230
		,anchor : '100%'
		,fieldLabel : '����Ŀ��' 
		,allowBlank: false
	});

var pConditionChild1=new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .15
		,layout:'form'
		,items:[PatName]
	});
var pConditionChild2=new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .15
		,layout:'form'
		,items:[PatSex]
	});
var pConditionChild3=new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .15
		,layout:'form'
		,items:[PatAge]
	});
var pConditionChild4=new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .15
		,layout:'form'
		,items:[BedCode]
	});
var pConditionChild5=new Ext.Panel({
		id : 'pConditionChild5'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .15
		,layout:'form'
		,items:[PatRegNo]
	});
var pConditionChild6=new Ext.Panel({
		id : 'pConditionChild6'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .15
		,layout:'form'
		,items:[PatMedNo]
	});
var pConditionChild7=new Ext.Panel({
		id : 'pConditionChild7'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .15
		,layout:'form'
		,items:[PatWard]
	});
var pConditionChild8=new Ext.Panel({
		id : 'pConditionChild8'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .85
		,layout:'form'
		,items:[PatDiag]
	});
var pConditionChild9=new Ext.Panel({
		id : 'pConditionChild9'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .85
		,layout:'form'
		,items:[ConDestination]
	});	
var pConditionChild10=new Ext.Panel({
		id : 'pConditionChild10'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .85
		,layout:'form'
		,items:[ConDestinationtwo]
	});	
var pFieldSet1 = new Ext.form.FieldSet({
		id : 'pFieldSet1'
		,title : '���˻�����Ϣ'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,boxMinHeight : 100
		,height:230
		,layout : 'column'
		,border:true
		,frame:true
		,anchor:'100%'
		//,labelWidth:65 //label�Ŀ��,�����Խ����Ŵ�����������
		,items : [
		         pConditionChild1,
				 pConditionChild2,
				 pConditionChild3,
				 pConditionChild4,
				 pConditionChild5,
				 pConditionChild6,
				 pConditionChild7,
				 pConditionChild8,
				 pConditionChild9,
				 pConditionChild10
				]
	});

	
//*********************************************************************����������Ϣ
//���Ӱ�ť
var btnAdd = new Ext.Button({
		id : 'btnAdd'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 60
		,text : '���'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
//���Ӱ�ť
var btnSend = new Ext.Button({
		id : 'btnSend'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 80
		,text : '��������'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
//����ҽ��
var PatDoc = new Ext.form.TextField({
		id : 'PatDoc' 
		,width : 80
		,anchor : '100%'
		,fieldLabel : '����ҽ��' 
	});	
//����ص�
var ConPlace = new Ext.form.TextField({
		id : 'ConPlace' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '����ص�' 
	});	
//����ʱ��
var ConTime=new Ext.form.TextField({
		id : 'ConTime' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '����ʱ��' 
	});
var MoreLoc = new Ext.form.Checkbox(
	                    {  
                        boxLabel  : '���',  
                        name      : 'MoreLoc',  
                        inputValue: '1',  
                        id        : 'MoreLoc'      // checked:'true'						
                        }  
	);		
var ConType_data = [['C', '��ͨ'],['E','��' ],['M', '���']];    //�������
var ConType_store=new Ext.data.SimpleStore({ fields: ['value', 'text'], data: ConType_data });

var InOut_data=[['I', 'Ժ��'],['O','Ժ��' ]];   //Ժ��Ժ��
var InOut_store=new Ext.data.SimpleStore({ fields: ['value', 'text'], data: InOut_data });

var AppDate=new Ext.form.DateField(
	            {
                    xtype: 'datefield',
                    fieldLabel: '��������',
					id:'AppDate',
					width:30,
					format:'Y-m-d',
					value:new Date(),
                    name: 'date',
					anchor : '100%'
                }
	);	
var AppTime=new Ext.form.TextField({
		id : 'AppTime' 
		,width : 90
		,anchor : '100%'
		,fieldLabel : 'ʱ��' 
	});
///�������
var  ConType=new Ext.form.ComboBox({		  
			  xtype: "combo",
			         id:"ConType",
                     fieldLabel: "���",
                     mode:"local", //ֱ�Ӷ���д��local
                     triggerAction: 'all', //����������
                     editable: false,
                     emptyText: "",
                     store: ConType_store,
                     displayField: 'text',//
					 valueField:'value'
					 ,anchor : '100%'
                 });
var InOut=new Ext.form.ComboBox({		  
			  xtype: "combo",
			         id:"InOut",
					 width : 100,
                     fieldLabel: "Ժ��Ժ��",
                     mode:"local", //ֱ�Ӷ���д��local
                     triggerAction: 'all', //����������
                     editable: false,
                     emptyText: "",
                     store: InOut_store,
                     displayField: 'text',//
					 valueField:'value',
					 anchor : '100%'
                 });
var ConsultDepStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var ConsultDepStore = new Ext.data.Store({
		proxy: ConsultDepStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ConID'
		}, 
		[
			{name: 'ConID', mapping : 'ConID'}
			,{name: 'ConDesc', mapping: 'ConDesc'}
			,{name: 'HosID', mapping: 'HosID'}
			,{name: 'HosDesc', mapping: 'HosDesc'}
		])
	});
var ConsultDep = new Ext.form.ComboBox({
		id : 'ConsultDep'
		,width : 100
		,minChars : 1 //���Զ���ɺ�typeAhead ����֮ǰ���û���������������ַ���
		,selectOnFocus : true //true �����ڻ�ý���ʱ���ѡ�б��������д��ڵ��ı��� ����editable = true ʱӦ��(Ĭ��Ϊfalse)�� 
		,forceSelection : true //true �����޶�ѡ���ֵ���б��е�ֵ֮һ�� false���������û����������������ֵ (Ĭ��Ϊfalse) 
		,store : ConsultDepStore
		,displayField : 'ConDesc'
		,fieldLabel : '�������'
		,editable : true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
		,triggerAction : 'all'  //�������������ʱ��Ҫִ�еĲ�����
		,anchor : '100%'
		,valueField : 'ConID'
	});				 
ConsultDepStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCConsultNew';
			param.QueryName = 'QryConsultDep';
			param.Arg1 = ConsultDep.getRawValue();
			param.ArgCnt = 1;
	});	
//��������
var pConditionChild20=new Ext.Panel({
		id : 'pConditionChild20'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .15
		,layout:'form'
		,items:[AppDate]
	});
//����ʱ��
var pConditionChild21=new Ext.Panel({
		id : 'pConditionChild21'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .2
		,layout:'form'
		,items:[AppTime]
	});
//�������
var pConditionChild22=new Ext.Panel({
		id : 'pConditionChild22'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .2
		,layout:'form'
		,items:[ConType]
	});
//������
var emergency = new Ext.form.Checkbox(
	                    {  
                        boxLabel  : '��',  
                        name      : 'emergency',  
                        inputValue: '1',  
                        id        : 'emergency'      // checked:'true'						
                        }  
	);	
//�Ƿ����
var pConditionChild29=new Ext.Panel({
		id : 'pConditionChild29'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .2
		,layout:'form'
		,items:[emergency]
	});	
//Ժ��Ժ��
var pConditionChild28=new Ext.Panel({
		id : 'pConditionChild28'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .25
		,layout:'form'
		,items:[InOut]
	});	
	
//����ҽ��
var  pConditionChild23=new Ext.Panel({
		id : 'pConditionChild23'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .2
		,layout:'form'
		,items:[PatDoc]
	});	
var  pConditionChild31=new Ext.Panel({
		id : 'pConditionChild31'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .2
		,layout:'form'
		,items:[ConPlace]
	});	
var  pConditionChild32=new Ext.Panel({
		id : 'pConditionChild32'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .2
		,layout:'form'
		,items:[ConTime]
	});	
//�������
var  pConditionChild24=new Ext.Panel({
		id : 'pConditionChild24'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .2
		,layout:'form'
		,items:[ConsultDep]
	});	
//���
var  pConditionChild26=new Ext.Panel({
		id : 'pConditionChild26'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:50
		,columnWidth : .25
		,layout:'form'
		,items:[MoreLoc]
	});	
//��Ӱ�ť
var  pConditionChild25=new Ext.Panel({
		id : 'pConditionChild25'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:50
		,columnWidth : .15
		,layout:'form'
		,items:[btnAdd]
	});	
//��Ӱ�ť
var  pConditionChild27=new Ext.Panel({
		id : 'pConditionChild27'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .25
		,layout:'form'
		,items:[btnSend]
	});	

//************************************************************************************************gridpanel

  
var gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	var gridResultStore = new Ext.data.Store({
		id: 'gridResultStoretore',
		proxy: gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ConsultAppID'
		}, 
		[
		    {name: 'ConsultLocID', mapping : 'ConsultLocID'}
			,{name: 'ConsultLoc', mapping : 'ConsultLoc'}
			,{name: 'ConsultItmLoc', mapping : 'ConsultItmLoc'}
			,{name: 'ConSultDoc', mapping: 'ConSultDoc'}
			,{name: 'ConSultDocGrade', mapping: 'ConSultDocGrade'}
		])
	});
	var gridResult = new Ext.grid.EditorGridPanel({
		id : 'gridResult'
		,store : gridResultStore
		,region : 'center'
		,buttonAlign : 'center'
		,clicksToEdit:1  //��ʾ����һ�ξͿɱ༭��Ĭ����˫���ſɱ༭
		,height: 1000
		,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'} //һ�� Ext.LoadMask ���ã�����Ϊtrue�Ա��ڼ���ʱ����grid�� Ĭ��Ϊ false .
		//,plugins: expCtrlDetail //һ���������һ���������飬Ϊ����ṩ����Ĺ��ܡ� ��һ���Ϸ��Ĳ��Ψһ��Ҫ����������һ��init()������ �ܽ���һ��Ext.Component�͵Ĳ����������������ʱ������п��õĲ��������������ÿ�������init���������������������Ϊ�����������ݸ�����Ȼ��ÿ������Ϳ��Ե��÷���������Ӧ����ϵ��¼���������Ҫ�������ṩ�Լ��Ĺ��ܡ� 
		,columns: [
			/*new Ext.grid.RowNumberer({header:"����"	,width:60})*/
			{header: '����id', width: 0, dataIndex: 'ConsultLocID', sortable: true}
			,{header: '����', width: 200, dataIndex: 'ConsultLoc', sortable: true}
			,{header: '�ӿ���', width: 250, dataIndex: 'ConsultItmLoc', sortable: false,
			
			editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({
            id : 'ItmCTLoc'
		   ,width : 250
		   ,store : ConSultItmLocStore
		   ,minChars : 1
		   ,displayField : 'ItmLocDesc'
		   ,editable : true
		   ,triggerAction : 'all'
		   ,anchor : '100%'
		   ,valueField : 'ItmLocID'
		   ,listeners:{
		   'beforequery':function(e){
		   var cell = gridResult.getSelectionModel().getSelectedCell();
           var id=gridResultStore.getAt(cell[0]).get('ConsultLocID');  //��ȡ���п���id������combobox��ѯ
			var content=this.getRawValue(); 
			//alert(id+"#"+content)
			ConSultItmLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCConsultNew';
			param.QueryName = 'GetListItemLoc';
			param.Arg1 = id;
			param.Arg2=content;
			param.ArgCnt = 2;})
			ConSultItmLocStore.load({})			
		   //*********************		   
		   
		   }
		   
		   }
    })),renderer: GetConSultItmDep 
			
			
			}
			,{
			
			header: 'Ҫ�����ҽ��', width: 200, dataIndex: 'ConSultDoc', sortable: false, hidden:true,
			editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({
            id : 'CTLoc'
		   ,width : 100
		   ,store : DocListStore
		   ,minChars : 1
		   ,displayField : 'ctcpDesc'
		   ,editable : true
		   ,triggerAction : 'all'
		   ,anchor : '100%'
		   ,valueField : 'ctcpId'
		    
		   
		   ,listeners:{
		   'beforequery':function(e){

            //************
		   //var id="";
		   //debugger;
		   var cell = gridResult.getSelectionModel().getSelectedCell();
           var id=gridResultStore.getAt(cell[0]).get('ConsultLocID');  //��ȡ���п���id������combobox��ѯ
		   ////var gg= gridResult.getStore().getAt(cell[0]).get('ConSultDoc'); 
		   var gg=this.getRawValue();     //gg add �ҳ���Ҫ
		   //alert(gg);
		   //var rowObj = gridResult.getSelectionModel().getSelections();
		
			DocListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCConsultNew';
			param.QueryName = 'GetDocListByLoc';
			param.Arg1 = id;
			param.Arg2=gg;
			param.ArgCnt = 2;})
			DocListStore.load({})	  //����		
		   //*********************		   
		   
		   }
		   
		   }
		   
		   
		   
		   
		   
		   /*,
		   listeners : { 
		   'beforequery':function(e){ 
		   DocListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCConsultNew';
			param.QueryName = 'GetDocListByLoc';
			param.Arg1 = id;
			param.ArgCnt = 1;
			})
	 
		   
		   }
		   }*/
    })),renderer: function(ctcpId, cellmeta, record)   
                     {  
                         //ͨ��ƥ��valueȡ��ds����  
                         var index = DocListStore.find(Ext.getCmp('CTLoc').valueField,ctcpId);  
                         //ͨ������ȡ�ü�¼ds�еļ�¼��  
                         var record = DocListStore.getAt(index);  
                         //���ؼ�¼���е�value�ֶε�ֵ  
                         var ctcpId = "";  
                         if (record)   
                         {  
                             ctcpId = record.data.ctcpDesc;  
                         }  
                         return ctcpId;//ע������ط���value������displayField�е�value  
                      } 			
}, 
			{
			header: 'ҽʦ����', 
			dataIndex:'ConSultDocGrade',
			width: 150,
			hidden:true,
			sortable: true,
			editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({
			id:'ConDocGrade',
            store:DocGradstore ,
            emptyText: '��ѡ��',
            mode: 'local',
            triggerAction: 'all',
            valueField: 'disvalue', //disvalue ���о�
            displayField: 'distext',
            readOnly:false
			})),renderer: function(disvalue, cellmeta, record1)   
                     {  
                         //ͨ��ƥ��valueȡ��ds����  
                         var index = DocGradstore.find(Ext.getCmp('ConDocGrade').valueField,disvalue);  
                         //ͨ������ȡ�ü�¼ds�еļ�¼��  
                         var record1 = DocGradstore.getAt(index);  
                         //���ؼ�¼���е�value�ֶε�ֵ  
                         var disvalue = "";  
                         if (record1)   
                         {  
                             disvalue = record1.data.distext;  
                         }  
                         return disvalue;//ע������ط���value������displayField�е�value  
                      } 
			}
			
		],bbar: new Ext.PagingToolbar({
			pageSize : 1000,
			store : gridResultStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: ''
		})
	});
//*****************************************************************************************************
var pFieldSet2 = new Ext.form.FieldSet({
		id : 'pFieldSet2'
		,title : '������Ϣ'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,boxMinHeight : 100
		,height:140
		,layout : 'column'
		,border:true
		,frame:true
		,anchor:'100%'
		//,labelWidth:65 //label�Ŀ��,�����Խ����Ŵ�����������
		,items : [
		         pConditionChild23,
				 pConditionChild20,
				 pConditionChild21,
				 pConditionChild22,
				 pConditionChild29,
				 pConditionChild28,
				 pConditionChild31,
				 pConditionChild32,
				 pConditionChild24,
				 pConditionChild25,
				 pConditionChild27
				]
	});	
/*/************
		   //var id="";
		   gridResult.on("cellclick",function(g,r,e) {
						var id=g.getStore().getAt(r).get("ConsultLocID");
						//alert(id)
						//*****
						DocListStoreProxy.on('beforeload', function(objProxy, param){
						//alert(this.getStore())
			param.ClassName = 'web.DHCConsultNew';
			param.QueryName = 'GetDocListByLoc';
			param.Arg1 = id;
			param.Arg2=g.getStore().getAt(r).get("ConSultDoc");
			param.ArgCnt = 2;})
						})
		   //*********************
		   */
var ConditionPanel = new Ext.form.FormPanel({
		id : 'ConditionPanel',
		buttonAlign : 'center', //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ�� 
		labelAlign : 'right', //�������п��õ��ı�����ֵ���Ϸ�ֵ�� "left", "top" �� "right" (Ĭ��Ϊ "left").
		labelWidth : 60,
		bodyBorder : false,
		border : true,
		layout : 'form',
		region : 'center',
		frame : true,
		width : 100,
		height : 10,
		anchor:'100%',
		title : '������Ϣ',
		items : [
			pFieldSet1
			
		]
	});	
	
var ConditionPanel2 = new Ext.form.FormPanel({
		id : 'ConditionPanel2',
		buttonAlign : 'center', //��ӵ���ǰpanel������ buttons �Ķ��뷽ʽ�� 
		labelAlign : 'right', //�������п��õ��ı�����ֵ���Ϸ�ֵ�� "left", "top" �� "right" (Ĭ��Ϊ "left").
		labelWidth : 60,
		bodyBorder : false,
		border : true,
		layout : 'form',
		region : 'center',
		frame : true,
		width : 100,
		height : 10,
		anchor:'100%',
		title : '������Ϣ',
		items : [
			pFieldSet2
			
		]
	});	
var pnScreen = new Ext.Panel({
		id : 'pnScreen'
		,buttonAlign : 'center'
		,frame : true
		,layout : 'form'
		,items:[
		
			ConditionPanel,
			ConditionPanel2,
			gridResult
		]
	});
//***********************
var contextmenu =new Ext.menu.Menu({
        id: 'theContextMenu',
        items: [{
            text: 'ɾ��',
			id: 'DeleteHandle',
            handler:DeleteHandle
        }
		]
    });
grid=Ext.getCmp("gridResult");
grid.on("rowcontextmenu", function(grid1, rowIndex, e){
//debugger
        e.preventDefault();
        //grid1.getSelectionModel().selectRow(rowIndex);
        contextmenu.showAt(e.getXY());
    });	
//************************
var init=function(){
new Ext.Viewport({
		id : 'viewScreen'
		,frame : true
		,layout : 'fit'
		,items:[
			pnScreen
			
		]
	}),
Ext.get('btnAdd').on("click",btnAdd_onclick);
Ext.get('btnSend').on("click",btnSend_onclick);

AddPatinfo()
	
}
Ext.onReady(init);
function btnAdd_onclick()
{
var dep=Ext.getCmp('ConsultDep');
if ((dep.value=="")||(dep.value==undefined)) return;
//************************
for (i=0;i<gridResultStore.getCount();i++)
{
var locid=gridResultStore.getAt(i).get('ConsultLocID');
if(locid==dep.value) return;   //�Ѿ����ĳ�������ˣ��������ٴ������

}

//*****************************
var record = new Object();
record.ConsultLocID=dep.value;
record.ConsultLoc=dep.getRawValue();  //"��һ��";
record.ConSultDoc="";
record.ConSultDocGrade="";
record.ConsultItmLoc=tkMakeServerCall("web.DHCConsultNew","GetItemLocStr",dep.value); //class(web.DHCConsultNew).GetItemLocStr"437"   //��������ҵ�ʱ������ӿ���
var records = new Ext.data.Record(record);
gridResultStore.add(records);
if(gridResultStore.getCount()>1)
{

ConType.setValue('M');
}

}
//��Ӳ��˻�����Ϣ
function AddPatinfo()
{
InOut.setValue('I');
ConType.setValue('C');
var ret=tkMakeServerCall("web.DHCConsultNew","GetPatinfo",EpisodeID);
var infoArr=ret.split("^");
Ext.getCmp('PatName').setValue(infoArr[0]);
Ext.getCmp('PatSex').setValue(infoArr[1]);
Ext.getCmp('PatAge').setValue(infoArr[2]);
Ext.getCmp('BedCode').setValue(infoArr[3]);
Ext.getCmp('PatDiag').setValue(infoArr[7]);
Ext.getCmp('PatWard').setValue(infoArr[9]);
Ext.getCmp('PatRegNo').setValue(infoArr[8]);
Ext.getCmp('PatMedNo').setValue(infoArr[6]);
Ext.getCmp('PatDoc').setValue(infoArr[5]);
Ext.getCmp('AppTime').setValue(infoArr[10]);
var ArcimRowid = "14453||1"
var ConInfo=tkMakeServerCall("web.DHCConsultNew","getConInfoByArcimid",ArcimRowid); //����������Ϣ
var ConInfoArr=ConInfo.split("!");
if (ConInfoArr[0]=="M")
{
ConType.setValue('M');
Ext.getCmp('ConType').disable(); 

}
else
{
Ext.getCmp('ConsultDep').disable();  
Ext.getCmp("gridResult").getColumnModel().setHidden(2, true);
var items=Ext.getCmp("pFieldSet2").items
//var itemnum=items.getCount();
 for (var i = 0; i < items.getCount(); i++)   
 {
 //alert(items.getCount())
 //debugger;
 //	alert(items.getCount()+"#"+items.get(i).id)
 if ((items.get(i).id=="pConditionChild31")||(items.get(i).id=="pConditionChild32"))
 {
               Ext.getCmp("pFieldSet2").remove(items.get(i));
			  i--;
              			   
			   }
			   }

}

var listdepsult=ConInfoArr[1].split("^")
var record = new Object();
record.ConsultLocID=listdepsult[1];
record.ConsultLoc=listdepsult[0];  //"��һ��";
record.ConSultDoc="";
record.ConSultDocGrade="";
var records = new Ext.data.Record(record);
gridResultStore.add(records);


}
//ɾ���б�����Ӵ�Ŀ���
function DeleteHandle()
{
var ConInfo=tkMakeServerCall("web.DHCConsultNew","getConInfoByArcimid",ArcimRowid); //����������Ϣ
var ConInfoArr=ConInfo.split("!");
if (ConInfoArr[0]!="M")
{
alert("�Ƕ�ƻ��ﲻ��ɾ��")
return;

}
var cell = gridResult.getSelectionModel().getSelectedCell();
var record = gridResultStore.getAt(cell[0]);
gridResultStore.remove(record);
//if(gridResultStore.getCount()==1) ConType.setValue('');
}

function btnSend_onclick()
{


var ret="",dep=""
var count=gridResultStore.getCount();
if (count==0)
{Ext.Msg.alert("����ӻ������")
return;
}
var appdate = Ext.getCmp("AppDate").value;   //��������
var apptime = Ext.getCmp("AppTime").getValue();   //����ʱ��
var typ = Ext.getCmp("ConType").value;   //�������
if((typ==undefined)||(typ=="")) 
{
alert("��ѡ��������")
rerun;
}
if ((count==1)&&(typ=="M"))
{
alert("�Ƕ�ƻ���")
return;

}
var inout = InOut.value;   //Ժ��Ժ��
if(inout==undefined)
{
Ext.Msg.alert('��ʾ', "��ѡ��'Ժ��Ժ��'!");
		return;
}

//***************************
var count=gridResultStore.getCount();   //��������
if(typ=="M")
{
for (var r = 0;r < count; r++) {

           var RItmLoc= gridResult.getStore().getAt(r).get('ConsultItmLoc');   //Ҫ������ӿ���
			//alert(RItmLoc+"#"+r)
			if((isNaN(RItmLoc))||(RItmLoc=="")){
			
			alert("��ѡ������ӿ���")
			return;
			}
			}
			}
//**************************

var Diag = PatDiag.value;  //���
var destin = Ext.getCmp("ConDestination").getRawValue();  //���ﱸע
var despurpose=Ext.getCmp("ConDestinationtwo").getRawValue();   ///����Ŀ��
if ((destin=="")||(despurpose==""))
{
alert("����ժҪ�ͻ���Ŀ��Ϊ������")
return;
}

if (ConType.value=="M")
{
var MoreConPlace=Ext.getCmp("ConPlace").getRawValue();  ///��ƻ���ص�
var MoreConTime=Ext.getCmp("ConTime").getRawValue();  ///��ƻ���ʱ��
}
else
{
var MoreConPlace="";
var MoreConTime="";
}
for (var r = 0;r < count; r++) {
			var gg= gridResult.getStore().getAt(r).get('ConsultLocID');   //�������id
			var RItmLoc= gridResult.getStore().getAt(r).get('ConsultItmLoc');   //Ҫ������ӿ���
			if(dep=="")
			{
			dep=gg+"#"+RItmLoc;
			}
			else
			{
			dep=dep+"!"+gg+"#"+RItmLoc;
			}
	    }
var dep="ConsultDep|" + dep + "^";   


//*************************************************
var emergen="";
var isemer = Ext.getCmp("emergency").getValue();
if (isemer==true) {emergen="E"}
else  {
emergen=""
}
	ret = ret + "AppDate|" + appdate + "^";
	ret = ret + "AppTime|" + apptime + "^";
	ret = ret + "ConType|" + typ + "^";
	ret = ret + "InOut|" + inout + "^";
	ret = ret + "ConDestination|" + destin + "^";
	ret = ret + "ConDestinationtwo|" + despurpose + "^";
	ret = ret + "Diag|" + Diag + "^";
	ret = ret + "EpisdeID|" + EpisodeID + "^";
	ret = ret + "Status|V^";
	ret = ret + "AppDep|" + session['LOGON.CTLOCID'] + "^";
	ret = ret + "AppDoc|" + session['LOGON.USERID'] + "^";
	ret=ret+"Diag|"+Ext.getCmp('PatDiag').getRawValue()+"^";
	ret=ret+"EmergenCon|"+emergen+"^";
	ret=ret+"MoreConPlace|"+MoreConPlace+"^";       //�ص�
	ret=ret+"MoreConTime|"+MoreConTime+"^";      //ʱ��
	ret=ret+dep;
	
	if (ConType.value=="M")
	{
	var result=tkMakeServerCall("User.DHCConSultationNew","Save",ret);
	var resultArr=result.split("^");
	if (resultArr[0]=="0") 
	{
	alert("���ͳɹ�")
	//alert(resultArr[1])
	window.returnValue="M"+resultArr[1];; ///+resultArr[1];
	window.close();
	}
	}
	else 
	{
	///���ƻ���ֱ�Ӳ������
	var result=tkMakeServerCall("User.DHCConSultationNew","SaveSingle",ret);
	var resultArr=result.split("^");
	if (resultArr[0]=="0") 
	{
	alert("���ͳɹ�")
	//alert(resultArr[1])
	window.returnValue=resultArr[1];
	window.close();
	}
	}
}

var emergency = Ext.getCmp("emergency")
	emergency.on("check", function() {
	     if (ConType.value=="M")
		 {
		 //alert("�û���Ϊ��ƻ���")
		 }
		 else
		 {
         ConType.setValue('E');
		 }
			});

function GetConSultItmDep(val)
{
if (val==undefined) return "";
var rtn=tkMakeServerCall("web.DHCConsultNew","GetConSultItmDep",val);
return rtn;

}









