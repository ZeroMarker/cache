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
		['P','ҽʦ'],
		['E','סԺҽʦ']
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
	});
//����Ŀ�ġ�����������
var ConDestinationtwo = new Ext.form.TextArea({
		id : 'ConDestinationtwo' 
		,xtype: "textarea"
		,labelWidth: 60
        ,width: 230
		,anchor : '100%'
		,fieldLabel : '����Ŀ�ġ�����������' 
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
//��˰�ť
var btnSend = new Ext.Button({
		id : 'btnSend'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		//,width : 80
		,text : 'ȷ��'
		,icon:'../images/uiimages/ok.png'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
//�ܾ���ť
var btnRefuse = new Ext.Button({
		id : 'btnRefuse'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		//,width : 80
		,text : '�ܾ�'
		,icon:'../images/uiimages/undo.png'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
	
	//��ɰ�ť
var btnEnd = new Ext.Button({
		id : 'btnEnd'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		//,width : 80		
		,text : '�������'
		,icon:'../images/uiimages/permission.png'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
//����ҽ��
var PatDoc = new Ext.form.TextField({
		id : 'PatDoc' 
		,width : 100
		,anchor : 'anchor%'
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
					width:80,
					format:'Y-m-d',
					value:new Date(),
                    name: 'date',
					anchor:'100%'
                }
	);	
var AppTime=new Ext.form.TextField({
		id : 'AppTime' 
		,width : 100
		,anchor : '80%'
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
                 });
var InOut=new Ext.form.ComboBox({		  
			  xtype: "combo",
			         id:"InOut",
                     fieldLabel: "Ժ��Ժ��",
                     mode:"local", //ֱ�Ӷ���д��local
                     triggerAction: 'all', //����������
                     editable: false,
                     emptyText: "",
                     store: InOut_store,
                     displayField: 'text',//
					 valueField:'value'
                 });
var ConsultDepStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var ConsultDepStore = new Ext.data.Store({
		proxy: ConsultDepStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
var ConsultDep = new Ext.form.ComboBox({
		id : 'ConsultDep'
		,width : 100
		,minChars : 1 //���Զ���ɺ�typeAhead ����֮ǰ���û���������������ַ���
		,selectOnFocus : true //true �����ڻ�ý���ʱ���ѡ�б��������д��ڵ��ı��� ����editable = true ʱӦ��(Ĭ��Ϊfalse)�� 
		,forceSelection : true //true �����޶�ѡ���ֵ���б��е�ֵ֮һ�� false���������û����������������ֵ (Ĭ��Ϊfalse) 
		,store : ConsultDepStore
		,displayField : 'CTLocDesc'
		,fieldLabel : '�������'
		,editable : true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
		,triggerAction : 'all'  //�������������ʱ��Ҫִ�еĲ�����
		,anchor : '100%'
		,valueField : 'CTLocID'
	});				 
ConsultDepStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCBedManager';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = ConsultDep.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = "";
			param.Arg4 = "";   //CTHos.getValue();
			param.ArgCnt = 4;
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
		,columnWidth : .25
		,layout:'form'
		,items:[ConType]
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
		,columnWidth : .25
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
//��Ӱ�ť ---ҽ��Ʋ���ӿ��� ---����
var  pConditionChild25=new Ext.Panel({
		id : 'pConditionChild25'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:50
		,columnWidth : .15
		,layout:'form'
		,items:[btnAdd]
	});	
//ҽ��� ��� ��ť
var  pConditionChild27=new Ext.Panel({
		id : 'pConditionChild27'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .10
		,layout:'form'
		,items:[btnSend]
	});	
//ҽ��� ��ɻ��� ��ť
var  pConditionChild29=new Ext.Panel({
		id : 'pConditionChild29'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .15
		,layout:'column'
		,items:[btnEnd]
	});	
//ҽ��� �ܾ����� ��ť
var  pConditionChild30=new Ext.Panel({
		id : 'pConditionChild30'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:60
		,columnWidth : .15
		,layout:'column'
		,items:[btnRefuse]
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
			,{name: 'ConSultDocName', mapping: 'ConSultDocName'}
		])
	});
	var rowItemRecord = Ext.data.Record.create([
         {name: 'ConsultLocID', mapping : 'ConsultLocID'}
		,{name: 'ConsultLoc', mapping : 'ConsultLoc'}
		,{name: 'ConsultItmLoc', mapping : 'ConsultItmLoc'}
		,{name: 'ConSultDoc', mapping: 'ConSultDoc'}
		,{name: 'ConSultDocGrade', mapping: 'ConSultDocGrade'}
		,{name: 'ConSultDocName', mapping: 'ConSultDocName'}
    ]); 
	
	var gridResult = new Ext.grid.EditorGridPanel({
		id : 'gridResult'
		,store : gridResultStore
		,region : 'center'
		,clicksToEdit:1  //��ʾ����һ�ξͿɱ༭��Ĭ����˫���ſɱ༭
		,buttonAlign : 'center'
		,height: 290
		,tbar: new Ext.Toolbar(['-', {  
                text: '��ӻ������', 
				icon:'../images/uiimages/edit_add.png',
                handler: function() {  
					 //alert("hhah");
					 var rec = new rowItemRecord({  //ʵ����Record���󣬲�������ֶγ�ʼֵ
						'ConsultLocID': '',
						'ConsultLoc': '',
						'ConsultItmLoc': '',
						'ConSultDoc': '',
						'ConSultDocGrade': ''
					});
                     gridResult.stopEditing();  
                     gridResultStore.insert(gridResultStore.getCount() , rec);   
                     gridResult.startEditing(0, 0);  //������еı༭״̬  
                }  
            }, '-', {  
                text: 'ɾ���������',  
				id:'deleteLocBtn',
				icon:'../images/uiimages/edit_remove.png',
                handler: function() {  
                    Ext.Msg.confirm('��Ϣ', 'ȷ��Ҫɾ��', function(btn) {  
                        if(btn == 'yes') {  
                            var sm = gridResult.getSelectionModel(); //�õ�����ѡ��ģ��  
                            var cell = sm.getSelectedCell(); //ͨ��ѡ��ģ�͵õ�ѡ��ĵ�Ԫ��						
							var record = gridResultStore.getAt(cell[0]); //�õ�store��Ӧ��Record  
								if(record.data.ConSultSubId){
								var ret = tkMakeServerCall("web.DHCConsultNew","deleteLoc",record.data.ConSultSubId);
								if(ret==1){
									gridResultStore.remove(record);
								}else{
									return;
								}
							}else{
								gridResultStore.remove(record);
							}						
                        }  
                    })  
                }  
            }])  
		,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'} //һ�� Ext.LoadMask ���ã�����Ϊtrue�Ա��ڼ���ʱ����grid�� Ĭ��Ϊ false .
		//,plugins: expCtrlDetail //һ���������һ���������飬Ϊ����ṩ����Ĺ��ܡ� ��һ���Ϸ��Ĳ��Ψһ��Ҫ����������һ��init()������ �ܽ���һ��Ext.Component�͵Ĳ����������������ʱ������п��õĲ��������������ÿ�������init���������������������Ϊ�����������ݸ�����Ȼ��ÿ������Ϳ��Ե��÷���������Ӧ����ϵ��¼���������Ҫ�������ṩ�Լ��Ĺ��ܡ� 
		,columns: [
			/*new Ext.grid.RowNumberer({header:"����"	,width:60})*/
			{header: '����id', width: 0, dataIndex: 'ConsultLocID', sortable: true,hidden:true}
			,{header: '����', width: 150, dataIndex: 'ConsultLoc', sortable: true,hidden:true}
			,{header: '�������', width: 250, dataIndex: 'ConsultItmLoc', sortable: false,
			
			editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({
            id: 'ItmCTLoc', 
			width: 250,
			store: ConSultItmLocStore, 
			minChars: 1, 
			displayField: 'ItmLocDesc',
			editable: true, triggerAction: 'all', 
			anchor: '100%',
			valueField: 'ItmLocID',
            autoSelect: true,
            forceSelection: true,
            invalidText: "����ѡ����Ч���ң�", 
			listeners: {
				'beforequery': function (e) {
					var cell = gridResult.getSelectionModel().getSelectedCell();
					var id = gridResultStore.getAt(cell[0]).get('ConsultLocID'); //��ȡ���п���id������combobox��ѯ
					var content = this.getRawValue();
					//alert(id+"#"+content)
					ConSultItmLocStoreProxy.on('beforeload', function (objProxy, param) {
						param.ClassName = 'web.DHCConsultNew';
						param.QueryName = 'GetListItemLoc';
						param.Arg1 = id;
						param.Arg2 = content;
						param.ArgCnt = 2;
					})
					ConSultItmLocStore.load({});
				},
				'focus':function(e){
					var cell = gridResult.getSelectionModel().getSelectedCell();
					var ConsultItmLoc = gridResultStore.getAt(cell[0]);//.get('ConsultItmLoc');
					//console.log(ConsultItmLoc.data.ConsultLoc);
					var ItmCTLoc = Ext.getCmp('ItmCTLoc');
					ItmCTLoc.setRawValue(ConsultItmLoc.data.ConsultLoc);
				}
				

			}
    })),renderer: GetConSultItmDep 
			
			
			}
			, {

				header: 'Ҫ�����ҽ��',
				width: 250,
				dataIndex: 'ConSultDoc',
				sortable: false,
				editor: new Ext.grid.GridEditor(new Ext.form.ComboBox({
						id: 'CTDoc',
						width: 250,
						store: DocListStore,
						minChars: 1,
						displayField: 'ctcpDesc',
						editable: true,
						triggerAction: 'all',
						anchor: '100%',
						valueField: 'ctcpId',
						listeners: {
							'beforequery': function (e) {

								//************
								//var id="";

								var cell = gridResult.getSelectionModel().getSelectedCell();

								var id = gridResultStore.getAt(cell[0]).get('ConsultLocID');
								//alert(id);
								//��ȡ���п���id������combobox��ѯ
								//var thiscontent=gridResult.getStore().getAt(cell[0]).get('ConSultDoc');
								//alert(thiscontent)
								var ItmLocId = gridResultStore.getAt(cell[0]).get('ConsultItmLoc'); ///�ӿ���id

								var gg = this.getRawValue();
								DocListStoreProxy.on('beforeload', function (objProxy, param) {

									param.ClassName = 'web.DHCConsultNew';
									param.QueryName = 'GetDocListByLoc';
									param.Arg1 = ItmLocId;
									param.Arg2 = gg;
									param.Arg3 = ItmLocId;
									param.ArgCnt = 3;
								})
								DocListStore.load({});
							},
							'select':function(e){
								var selectDoc=this.value;
								if(admdoc==selectDoc){
									alert("������ѡ��������ҽ����");
									this.clearValue();
									return;
								}
							},
							'focus': function (e) {
								var cell = gridResult.getSelectionModel().getSelectedCell();
								var ConsultItmLoc = gridResultStore.getAt(cell[0]); 	
								var CTDoc = Ext.getCmp('CTDoc');
								CTDoc.setRawValue(ConsultItmLoc.data.ConSultDocName);
								CTDoc.fireEvent('beforequery',this);
							}
						}
					})),
				renderer: GetConSultDoc
			},
			{
			header: 'ҽʦ����', 
			dataIndex:'ConSultDocGrade',
			width: 150,
			sortable: true,
			hidden:true,
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
		id : 'pFieldSet1'
		,title : '������Ϣ'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,boxMinHeight : 100
		,height:100
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
				 pConditionChild28,
				 pConditionChild31,
				 pConditionChild32,
				 //pConditionChild24,
				 //pConditionChild25,
				 pConditionChild27,
				 pConditionChild29,
				 pConditionChild30
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
		border : false,
		layout : 'form',
		region : 'center',
		frame : true,
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
		border : false,
		layout : 'form',
		region : 'center',
		frame : true,
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
/*ҽ��Ʋ�����ɾ����������������Ϣ  ---����
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
*/
var init=function(){
new Ext.Viewport({
		id : 'viewScreen'
		,frame : true
		,layout : 'fit'
		,items:[
			pnScreen
			
		]
	}),
Ext.get('btnSend').on("click",btnSend_onclick);
Ext.get('btnEnd').on("click",btnEnd_onclick);
Ext.get('btnRefuse').on("click",btnRefuse_onclick);
//Ext.get('btnAdd').on("click",btnAdd_onclick);
AddConsultPlace()
AddPatinfo()
	
Ifhiddenelement()
}
Ext.onReady(init);
function Ifhiddenelement()
{
	var ret=tkMakeServerCall("web.DHCConsultNew","Ifhiddenelement",rowid);
	if ((ret=="W")||(ret=="V"))
	{
	document.getElementById('btnEnd').style.display="none";   ///������ɰ�ť
	}
	if (ret=="E")
	{
	//document.getElementById('btnAdd').style.display="none";   ///������Ӱ�ť
	document.getElementById('btnSend').style.display="none";   ///����ȷ�ϰ�ť
	document.getElementById('btnRefuse').style.display="none";   ///���ؾܾ���ť
	gridResult.getTopToolbar().hide(); ///����ɾ��������ҹ�����
	// document.getElementById('deleteLocBtn').style.display="none";   ///����ɾ��������Ұ�ť
	}
	if ((ret=="R")||(ret=="C")||(ret=="F"))
	{
	//document.getElementById('btnAdd').style.display="none";   ///������Ӱ�ť
	document.getElementById('btnSend').style.display="none";   ///����ȷ�ϰ�ť
	document.getElementById('btnEnd').style.display="none";   ///������ɰ�ť
	document.getElementById('btnRefuse').style.display="none";   ///���ؾܾ���ť
	Ext.getCmp('gridResult').getTopToolbar().hide();
	}
	var ret1 = tkMakeServerCall('User.DHCConsultDepItm', 'GetConfig');
	var ifOpenMoreLocAuditExec = ret1.split("^")[3];
	if(ifOpenMoreLocAuditExec!="Y"){
		document.getElementById('btnEnd').style.display="none";   ///������ɰ�ť
	}
}



function btnAdd_onclick()
{
	var dep=Ext.getCmp('ConsultDep');
	//alert(dep);
	addNewLineGrid(gridResultStore);
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
Ext.getCmp('InOut').disable();  
Ext.getCmp('ConType').disable();  
var ret=tkMakeServerCall("web.DHCConsultNew","GetPatinfobyId",rowid);
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
Ext.getCmp('ConDestination').setValue(infoArr[14]);
Ext.getCmp('ConDestinationtwo').setValue(infoArr[15]);
Ext.getCmp('ConPlace').setValue(infoArr[16]);
Ext.getCmp('ConTime').setValue(infoArr[17]);
Ext.getCmp('AppDate').setValue(infoArr[18]);
InOut.setValue(infoArr[12]);
ConType.setValue(infoArr[13]);

var listdepArr=tkMakeServerCall("web.DHCConsultNew","GetConlistbyId",rowid);

var listdep=listdepArr.split("!");
//debugger
for (var r = 0;r < listdep.length; r++)
{
var listdepsult=listdep[r].split("^")
//alert(listdepsult)
var record = new Object();


//**********
//var ceshi_data=[[listdepsult[2], listdepsult[3]]];   //ceshishuj
//var ceshi_store=new Ext.data.SimpleStore({ fields: ['value', 'text'], data: ceshi_data });

//******************


record.ConsultLocID=listdepsult[0];
record.ConsultLoc=listdepsult[1];  //"��һ��";
record.ConsultItmLoc=listdepsult[2];  //ceshi_store; 
record.ConSultDoc=listdepsult[4]; 
record.ConSultDocName=listdepsult[5]; 
record.ConSultSubId=listdepsult[6]; 
//record.ConSultDoc="";
//record.ConSultDocGrade="";
var records = new Ext.data.Record(record);
gridResultStore.add(records);

}



}
function AddConsultPlace()
{
var resultArr=tkMakeServerCall("web.DHCConsultNew","GetConPlace",rowid);
var result=resultArr.split("^");
Ext.getCmp("ConPlace").setValue(result[0]);
Ext.getCmp("ConTime").setValue(result[1]);

}
//ɾ���б�����Ӵ�Ŀ���
function DeleteHandle()
{
var cell = gridResult.getSelectionModel().getSelectedCell();
var record = gridResultStore.getAt(cell[0]);
gridResultStore.remove(record);
if(gridResultStore.getCount()==1) ConType.setValue('');
}
//�ܾ�
function btnRefuse_onclick(){
	var result=tkMakeServerCall("User.DHCConSultationNew","Refuse",rowid);
	if (result=="0") 
	{
		alert("�ܾ�����")
		window.close();
		Search_onclick();
	}
	else
	{
		//alert("ggg")
		alert(result)
		return;
	}
}
//���
function btnSend_onclick() {
	var dish = tkMakeServerCall("web.DHCDischargeHistory", "GetDischargeDateTime", EpisodeId);
	var recallStatus = tkMakeServerCall("web.DHCDischargeHistory", "GetCurrentDischargeStatus", EpisodeId);
	
	if ((recallStatus!="B")&&(dish != '^')) {
		alert("�����ѳ�Ժ!");
		return;
	}
	var ret = "";
	var ConPlace = Ext.getCmp("ConPlace").getValue();
	var ConTime = Ext.getCmp("ConTime").getValue();
	if ((ConPlace == "") || (ConTime == "")) {
		alert("��ѡ�����ص��ʱ��!")
		return;
	}
	var count = gridResultStore.getCount(); //��������
	for (var r = 0; r < count; r++) {

		var RItmLoc = gridResult.getStore().getAt(r).get('ConsultItmLoc'); //Ҫ������ӿ���
		//alert(RItmLoc+"#"+r)
		if ((isNaN(RItmLoc)) || (RItmLoc == "")) {

			alert("��ѡ������ӿ���")
			return;
		}

		var gg = gridResult.getStore().getAt(r).get('ConSultDoc'); //�������id
		//alert(gg+"#"+r)
		if ((isNaN(gg)) || (gg == "")) {

			alert("��ѡ��Ҫ�����ҽ��")
			return;
		}

	}
	for (var r = 0; r < count; r++) {
		var conlocid = gridResult.getStore().getAt(r).get('ConsultLocID'); //Ҫ��������
		var condoc = gridResult.getStore().getAt(r).get('ConSultDoc');
		var ItmConsultDep = gridResult.getStore().getAt(r).get('ConsultItmLoc');
		conlocid = ItmConsultDep;
		if (ret == "") {
			ret = conlocid + "^" + condoc + "^" + ItmConsultDep + "!"
		} else {
			ret = ret + conlocid + "^" + condoc + "^" + ItmConsultDep + "!"
		} //���������ҽ����Ӧ
	}
	//alert(count)
	//alert(ret+"^"+rowid+"^"+ConPlace+"^"+ConTime)
	var result = tkMakeServerCall("User.DHCConSultationNew", "Audit", ret, rowid, ConPlace, ConTime, "", count);
	if (result == "0") {
		alert("��˳ɹ�")
		window.close();
		window.opener.location.reload();
	} else {
		//alert("ggg")
		alert(result)
		return;
	}
	return;

	var ret = "",
	dep = ""
		var count = gridResultStore.getCount();
	if (count == 0) {
		Ext.Msg.alert("����ӻ������")
		return;
	}
	var appdate = Ext.getCmp("AppDate").value; //��������
	var apptime = Ext.getCmp("AppTime").getValue(); //����ʱ��
	var typ = Ext.getCmp("ConType").value; //�������
	if ((typ == undefined) || (typ == "")) {
		alert("��ѡ��������")
		rerun;
	}
	if ((count == 1) && (typ == "M")) {
		alert("�Ƕ�ƻ���")
		return;

	}
	var inout = InOut.value; //Ժ��Ժ��
	if (inout == undefined) {
		Ext.Msg.alert('��ʾ', "��ѡ��'Ժ��Ժ��'!");
		return;
	}

	var Diag = PatDiag.value; //���
	var destin = Ext.getCmp("ConDestination").getRawValue(); //���ﱸע
	///alert(appdate+"#"+apptime+"#"+typ+"#"+inout+"#"+Diag+"#"+destin)
	for (var r = 0; r < count; r++) {
		var gg = gridResult.getStore().getAt(r).get('ConsultLocID'); //�������id
		if (dep == "") {
			dep = gg;
		} else {
			dep = dep + "!" + gg;
		}
	}
	var dep = "ConsultDep|" + dep + "^";
	//*************************************************
	ret = ret + "AppDate|" + appdate + "^";
	ret = ret + "AppTime|" + apptime + "^";
	ret = ret + "ConType|" + typ + "^";
	ret = ret + "InOut|" + inout + "^";
	ret = ret + "ConDestination|" + destin + "^";
	ret = ret + "Diag|" + Diag + "^";
	ret = ret + "EpisdeID|" + EpisodeID + "^";
	ret = ret + "Status|V^";
	ret = ret + "AppDep|" + session['LOGON.CTLOCID'] + "^";
	ret = ret + "AppDoc|" + session['LOGON.USERID'] + "^";
	ret = ret + "Diag|" + PatDiag.value + "^"
		ret = ret + dep;
	var result = tkMakeServerCall("User.DHCConSultationNew", "Save", ret);
	if (result == "0") {
		alert("���ͳɹ�")
		window.close();
		window.opener.location.reload();
	} else {
		alert(result)
		return;
	}

}

///////����������ڲ�����,ͨ���·�����ʵ
function oldbak (ctcpId, cellmeta, record)   
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
                         if (ctcpId=="")
                         {
						 return "��ѡ��"
						 }	
                         else 
                         {						 
                         return ctcpId;//ע������ط���value������displayField�е�value  
						 }
                      } 

function GetConSultDoc(val)
{
var rtn=tkMakeServerCall("web.DHCConsultNew","GetConSultDoc",val);
return rtn;

}

function GetConSultItmDep(val)
{
var rtn=tkMakeServerCall("web.DHCConsultNew","GetConSultItmDep",val);
return rtn;

}
function btnEnd_onclick() {
	var dish = tkMakeServerCall("web.DHCDischargeHistory", "GetDischargeDateTime", EpisodeId);
	var recallStatus = tkMakeServerCall("web.DHCDischargeHistory", "GetCurrentDischargeStatus", EpisodeId);
	if((recallStatus!="B")&&(dish != '^')){
		alert("�����ѳ�Ժ!");
		return;
	}
	var userid = session['LOGON.USERID'];
	var loc = session['LOGON.CTLOCID'];
	//alert(rowid+"^"+userid+"^"+loc)
	var ret = tkMakeServerCall("web.DHCConsultNew", "ExcuteMoreConsult", rowid, userid, loc);
	if (ret == "0") {
		alert("�����ɹ�")
		window.close();
		Search_onclick()
	} else {
		alert(ret)
		return;
	}

}




