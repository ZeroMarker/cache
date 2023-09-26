var PatName = new Ext.form.TextField({
		id : 'PatName' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '����' 
	});
var BedCode = new Ext.form.TextField({
		id : 'BedCode' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '��ǰ��λ' 
	});

var AppBedCode = new Ext.form.TextField({
		id : 'AppBedCode' 
		,width : 100
		,anchor : '100%'
		,fieldLabel : '���봲��' 
	});
//���Ӱ�ť
var btnSend = new Ext.Button({
		id : 'btnSend'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 60
		,text : '��������'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
var pConditionChild1=new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .8
		,layout:'form'
		,anchor:'30%'
		,items:[PatName]
	});
var pConditionChild2=new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .8
		,layout:'form'
		,anchor:'30%'
		,items:[BedCode]
	});
var pConditionChild3=new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .8
		,layout:'form'
		,anchor:'30%'
		,items:[AppBedCode]
	});
var pConditionChild4=new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign:'center'
		,labelAligh:'center'
		,labelWidth:70
		,columnWidth : .9
		,layout:'form'
		,anchor:'30%'
		,items:[btnSend]
	});
var pFieldSet1 = new Ext.form.FieldSet({
		id : 'pFieldSet1'
		,title : '��������'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,boxMinHeight : 100
		,height:350
		,layout : 'column'
		,border:true
		,frame:true
		,anchor:'100%'
		//,labelWidth:65 //label�Ŀ��,�����Խ����Ŵ�����������
		,items : [
		         pConditionChild1,
				 pConditionChild2,
				 pConditionChild3,
				 pConditionChild4
				]
	});
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
		width : 20,
		 autoHeight: true,
		anchor:'100%',
		title : '������Ϣ',
		items : [
			pFieldSet1
			
		]
	});	
var pnScreen = new Ext.Panel({
		id : 'pnScreen'
		,buttonAlign : 'center'
		,frame : true
		,layout : 'form'
		,items:[
		
			ConditionPanel
		]
	});
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

AddPatinfo()
	
}
Ext.onReady(init);	

function AddPatinfo()
{
//var ret=parent.tkMakeServerCall("web.DHCConsultNew","GetPatinfobyId","2666");
var Patinfo=tkMakeServerCall("Nur.DHCBedManager","GetPatinfo",EpisodeID);
var ApplyBed=tkMakeServerCall("Nur.DHCBedManager","GetApplybed",ApplyBedId);
var infoArr=Patinfo.split("^");
Ext.getCmp('PatName').setValue(infoArr[0]);
Ext.getCmp('BedCode').setValue(infoArr[1]);
Ext.getCmp('AppBedCode').setValue(ApplyBed);
Ext.getCmp('PatName').disable();  
Ext.getCmp('BedCode').disable();  
Ext.getCmp('AppBedCode').disable(); 
}	
function btnSend_onclick()
{
var ctloc=session['LOGON.CTLOCID'];
var ApplyUser=session['LOGON.USERID'];
var ApplyStatus="V";
var ApplyType="M";
var ret=tkMakeServerCall("Nur.DHCBedApplyChange","Save",ApplyBedId,EpisodeID,ApplyUser,ApplyStatus,ApplyType);
//alert(ret)
if (ret=="0")
{
alert("���ͳɹ�")
window.close()
}
else
{
alert(ret)
window.close()
}
}	



/*alert(EpisodeID)
var Patinfo=tkMakeServerCall("Nur.DHCBedManager","GetPatinfo",EpisodeID);
alert(Patinfo)
*/




/*
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
		,fieldLabel : '���ﱸע' 
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
var pFieldSet1 = new Ext.form.FieldSet({
		id : 'pFieldSet1'
		,title : '���˻�����Ϣ'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,boxMinHeight : 100
		,height:150
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
				 pConditionChild9
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
		,text : '���'
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
			param.ClassName = 'Nur.DHCBedManager';
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
		,columnWidth : .15
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
			,{name: 'ConSultDoc', mapping: 'ConSultDoc'}
			,{name: 'ConSultDocGrade', mapping: 'ConSultDocGrade'}
		])
	});
	var gridResult = new Ext.grid.EditorGridPanel({
		id : 'gridResult'
		,store : gridResultStore
		,region : 'center'
		,buttonAlign : 'center'
		,height: 290
		,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'} //һ�� Ext.LoadMask ���ã�����Ϊtrue�Ա��ڼ���ʱ����grid�� Ĭ��Ϊ false .
		//,plugins: expCtrlDetail //һ���������һ���������飬Ϊ����ṩ����Ĺ��ܡ� ��һ���Ϸ��Ĳ��Ψһ��Ҫ����������һ��init()������ �ܽ���һ��Ext.Component�͵Ĳ����������������ʱ������п��õĲ��������������ÿ�������init���������������������Ϊ�����������ݸ�����Ȼ��ÿ������Ϳ��Ե��÷���������Ӧ����ϵ��¼���������Ҫ�������ṩ�Լ��Ĺ��ܡ� 
		,columns: [
			/*new Ext.grid.RowNumberer({header:"����"	,width:60})
			{header: '����id', width: 0, dataIndex: 'ConsultLocID', sortable: true}
			,{header: '����', width: 150, dataIndex: 'ConsultLoc', sortable: true}
			,{
			
			header: 'Ҫ�����ҽ��', width: 150, dataIndex: 'ConSultDoc', sortable: false,
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
		   
		   var cell = gridResult.getSelectionModel().getSelectedCell();
           var id=gridResultStore.getAt(cell[0]).get('ConsultLocID');  //��ȡ���п���id������combobox��ѯ
		    //var thiscontent=gridResult.getStore().getAt(cell[0]).get('ConSultDoc');
			//alert(thiscontent)
			DocListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCConsultNew';
			param.QueryName = 'GetDocListByLoc';
			param.Arg1 = id;
			param.Arg2="";
			param.ArgCnt = 2;})
			DocListStore.load({})			
		   //*********************		   
		   
		   }
		   
		   }
		   
		   
		   
		   
		   
		  
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
                         if (ctcpId=="")
                         {
						 return "��ѡ��"
						 }	
                         else 
                         {						 
                         return ctcpId;//ע������ط���value������displayField�е�value  
						 }
                      } 			
}, 
			{
			header: 'ҽʦ����', 
			dataIndex:'ConSultDocGrade',
			width: 150,
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
				 pConditionChild27
				]
	});	

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

InOut.setValue(infoArr[12]);
ConType.setValue(infoArr[13]);

var listdepArr=tkMakeServerCall("web.DHCConsultNew","GetConlistbyId",rowid);

var listdep=listdepArr.split("!");
for (var r = 0;r < listdep.length; r++)
{
var listdepsult=listdep[r].split("^")
var record = new Object();
record.ConsultLocID=listdepsult[0];
record.ConsultLoc=listdepsult[1];  //"��һ��";
record.ConSultDoc="";
record.ConSultDocGrade="";
var records = new Ext.data.Record(record);
gridResultStore.add(records);

}



}
//ɾ���б�����Ӵ�Ŀ���
function DeleteHandle()
{
var cell = gridResult.getSelectionModel().getSelectedCell();
var record = gridResultStore.getAt(cell[0]);
gridResultStore.remove(record);
if(gridResultStore.getCount()==1) ConType.setValue('');
}
//���
function btnSend_onclick()
{
var ret="";
var ConPlace=Ext.getCmp("ConPlace").getValue();
var ConTime=Ext.getCmp("ConTime").getValue();
if((ConPlace=="")||(ConTime==""))
{
alert("��ѡ�����ص��ʱ��")
return;
}
var count=gridResultStore.getCount();   //��������
for (var r = 0;r < count; r++) {
			var gg= gridResult.getStore().getAt(r).get('ConSultDoc');   //�������id
			//alert(gg+"#"+r)
			if((isNaN(gg))||(gg=="")){
			
			alert("��ѡ��Ҫ�����ҽ��")
			return;
			}
			}
for (var r = 0;r < count; r++) {
var conlocid=gridResult.getStore().getAt(r).get('ConsultLocID');  //Ҫ��������
var condoc=gridResult.getStore().getAt(r).get('ConSultDoc');
if (ret=="") {ret=conlocid+"^"+condoc+"!"}
else {ret=ret+conlocid+"^"+condoc+"!"}    //���������ҽ����Ӧ
}		
var result=tkMakeServerCall("User.DHCConSultationNew","Audit",ret,rowid,ConPlace,ConTime);
alert(result+ConPlace)
if (result=="0") 
	{
	alert("��˳ɹ�")
	window.close();
	}
return ;


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

var Diag = PatDiag.value;  //���
var destin = Ext.getCmp("ConDestination").getRawValue();  //���ﱸע
///alert(appdate+"#"+apptime+"#"+typ+"#"+inout+"#"+Diag+"#"+destin)
for (var r = 0;r < count; r++) {
			var gg= gridResult.getStore().getAt(r).get('ConsultLocID');   //�������id
			if(dep=="")
			{
			dep=gg;
			}
			else
			{
			dep=dep+"!"+gg;
			}
	    }
var dep="ConsultDep|" + dep + "^";    
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
	ret=ret+"Diag|"+PatDiag.value+"^"
	ret=ret+dep;
	var result=tkMakeServerCall("User.DHCConSultationNew","Save",ret);
	alert(result)
	if (result=="0") 
	{
	alert("���ͳɹ�")
	window.close();
	}

}


*/








