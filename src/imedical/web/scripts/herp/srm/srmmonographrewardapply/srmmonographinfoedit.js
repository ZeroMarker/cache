
srmMonographEditFun = function(editorids) {
		

	
    var rowObj=itemGrid.getSelectionModel().getSelections();
    var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
    
	///////////////////����/////////////////////////////  
var esTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var esTypeCombox = new Ext.form.ComboBox({
	                   id : 'esTypeCombox',
		           fieldLabel : '����',
	                   width : 180,
		           selectOnFocus : true,
		           //allowBlank : false,
		           store : esTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''

						  });
//////////////////////���//////////////////////////////////
var eYearDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


eYearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardapplyexe.csp'+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('eYearField').getRawValue()),
	method:'POST'});
});

var eYearField = new Ext.form.ComboBox({
	id: 'eYearField',
	fieldLabel: '���',
	width:180,
	listWidth : 260,
	//allowBlank: false,
	store:eYearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'eYearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''

});						  
	var NameField = new Ext.form.TextArea({
		id: 'Name',
		fieldLabel: 'ר������',
		width:180,
		//allowBlank: false,
		listwidth : 180,
		triggerAction: 'all',
		//emptyText:'',
		name: 'Name',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''

	});
	
	//��ȡ�������
	var unittypeDs = new Ext.data.Store({
		      //autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });


	unittypeDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.monographrewardapplyexe.csp'
		                     + '?action=TypeList&str='
		                     + encodeURIComponent(Ext.getCmp('unittypeField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var unittypeField = new Ext.form.ComboBox({
			id: 'unittypeField',
			fieldLabel: '�������',
			width:180,
			listWidth : 260,
			//allowBlank: false,
			store: unittypeDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			//emptyText : '��ѡ���������...',
			name: 'unittypeField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true,
			labelSeparator:''

	});

	//��ȡ��������
	var unitdeptDs = new Ext.data.Store({
		      //autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });


	unitdeptDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.monographrewardapplyexe.csp'
		                     + '?action=deptList&str='
		                     + encodeURIComponent(Ext.getCmp('unitdeptField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var unitdeptField = new Ext.form.ComboBox({
			id: 'unitdeptField',
			fieldLabel: '��������',
			width:180,
			listWidth : 260,
			//allowBlank: false,
			store: unitdeptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			//typeAhead : true,
			triggerAction : 'all',
			//emptyText : '��ѡ���������...',
			name: 'unitdeptField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
			labelSeparator:''


	});
	
//////////////////��Ӷ����������///////////////////////

/////////////////��������///////////////////////////
var EditorTypeStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','����'],['2','����'],['3','����']]
});

var EditorTypeField = new Ext.form.ComboBox({
	id: 'EditorTypeField',
	fieldLabel: '��������',
	width:180,
	//anchor: '95%',
	listwidth : 180,
	//allowBlank: true,
	store:EditorTypeStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	//emptyText:'��ѡ��������������...',
	mode : 'local',
	name: 'EditorTypeField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	labelSeparator:'',
	listeners:{"select":function(combo,record,index){ 
				   	    if(EditorTypeField.getValue()=='3')
                        {
						  BookAuthorRangeCombox.setValue("");
						  BookAuthorRangeCombox.setRawValue("");
						  //BookAuthorRangeCombox.disabled();
						  BookAuthorRangeCombox.disabled=true;
						}						
			        }} 
});

//��������
	var unituserDs = new Ext.data.Store({
			//autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
			           totalProperty:'results',
			           root:'rows'
			       },['rowid','name'])
     });
     
	unituserDs.on('beforeload', function(ds, o){
		   ds.proxy = new Ext.data.HttpProxy({
		   url : itemGridUrl
		         +'?action=userList&str='
		         +encodeURIComponent(Ext.getCmp('unituserField').getRawValue()),
		         method:'POST'
		       });
	});

	var unituserField = new Ext.form.ComboBox({
			id: 'unituserField',
			fieldLabel: '��������',
			width:180,
			listWidth :260,
			//allowBlank: false,
			store: unituserDs,
			valueField: 'rowid',
			hideOnSelect:false,
			displayField: 'name',
			triggerAction: 'all',
			//emptyText:'��ѡ����Ա����...',
			name: 'unituserField',
			minChars: 1,
			pageSize: 10,
			hideOnSelect:false,
			forceSelection : true,
			selectOnFocus:true,
			labelSeparator:''

	});
///////////////////����λ��/////////////////////////////  
var BookAuthorRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��һ'],['2', '�ڶ�'], ['3', '����'], ['4', '����'], ['5', '����'],['6', '����'],['7', '����'],['8', '�ڰ�']]
	});		
		
var BookAuthorRangeCombox = new Ext.form.ComboBox({
	                   id : 'BookAuthorRangeCombox',
		           fieldLabel : '����λ��',
	                   width : 180,
		           selectOnFocus : true,
		           //allowBlank : true,
		           store : BookAuthorRangeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''

						  });	
///////////////////���������Ƿ�Ժ/////////////////////////////  
var BookIsTheHosDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['0', '��Ժ��Ա'],['1', '��Ժְ��'],['2','��ʿ�о���'],['3','˶ʿ�о���']]
	});		
		
var BookIsTheHosCombox = new Ext.form.ComboBox({
	                   id : 'BookIsTheHosCombox',
		           fieldLabel : '��������ʱ���',
	                   width : 180,
		           selectOnFocus : true,
		           //allowBlank : true,
		           store : BookIsTheHosDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           value:'1',
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:'',
				   listeners:{
                           "select":function(combo,record,index){
						           if((combo.value=='2')||(combo.value=='3'))
								   {
								   BookAuthorRangeCombox.setValue('');
								   BookAuthorRangeCombox.disable();  //��Ϊ�ң����ɱ༭
                                   //BookAuthorRangeCombox.disabled=true;   //����Ϊ�ң����ɱ༭	
                                   }				
                                   else{
								   BookAuthorRangeCombox.enable();  	
								   }								   
			}
	}	
						  });	
	
	
var InventorsGrid = new Ext.grid.GridPanel({
        fieldLabel:'��������',
		labelSeparator:'',
		    id:'InventorsGrid',
    	  store: new Ext.data.Store({
        autoLoad:true,
	      proxy: new Ext.data.HttpProxy({
		    url:'herp.srm.monographrewardapplyexe.csp'+'?action=GetAuthorInfo&IDs='+editorids,method:'POST'}),
		    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['typerowid','typename','rowid','name','rangerowid','rangename','isthehosrowid','isthehos'])

    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 100,
            sortable: true
        },
        columns: [
            {id: 'typerowid', header: '������������ID', width: 100,dataIndex: 'typerowid',hidden:true},
            {header: '������������', dataIndex: 'typename',align:'center',width: 80},
            {id: 'rowid', header: '��������ID', width: 100,dataIndex: 'rowid',hidden:true},
            {header: '��������', dataIndex: 'name',align:'center',width: 80},
            {id: 'rangerowid', header: '��������λ��ID', width: 100,dataIndex: 'rangerowid',hidden:true},
            {header: '��������λ��', dataIndex: 'rangename',align:'center',width: 80},
            {id: 'isthehosrowid', header: '��������ʱ���ID', width: 100,dataIndex: 'isthehosrowid',hidden:true},
            {header: '��������ʱ���', dataIndex: 'isthehos',align:'center',width: 100}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 180,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ�������˰�ť////////////////
var addInventors  = new Ext.Button({
		text: '����',iconCls: 'edit_add',
		handler: function(){
			var InventorId;
			var BookAuthorRangeId;
			var BookAuthorTypeId;
			var IsTheHosId;
			var id = Ext.getCmp('unituserField').getValue();
			var typeid = Ext.getCmp('EditorTypeField').getValue();
			var rangeid = Ext.getCmp('BookAuthorRangeCombox').getValue();
			var isthehosid = Ext.getCmp('BookIsTheHosCombox').getValue();
			//alert(id);
			var InventorName = Ext.getCmp('unituserField').getRawValue();
			var BookAuthorTypeName = Ext.getCmp('EditorTypeField').getRawValue();
			var BookAuthorRange = Ext.getCmp('BookAuthorRangeCombox').getRawValue();
			var BookIsTheHos = Ext.getCmp('BookIsTheHosCombox').getRawValue();
			
			var total = InventorsGrid.getStore().getCount();
			if(total>0){	
				for(var i=0;i<total;i++){
					var erow = InventorsGrid.getStore().getAt(i).get('rowid');
					var tmprange = InventorsGrid.getStore().getAt(i).get('rangename');
					var tmpAuthorType = InventorsGrid.getStore().getAt(i).get('typename');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
						     if((rangeid=="")&&((isthehosid=='0')||(isthehosid=='1'))&&(typeid!=3))
							{
							  Ext.Msg.show({title:'����',msg:'��ѡ����������λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
							if((tmprange!="")&(BookAuthorRange!="")&(tmprange==BookAuthorRange)&(tmpAuthorType==BookAuthorTypeName)) 
							//if((tmprange!="")&(BookAuthorRange!="")&(tmprange==BookAuthorRange))
							{
								Ext.Msg.show({title:'����',msg:'��ͬ����������������ѡ������ͬ��λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
						    InventorId=id;
						    BookAuthorTypeId=typeid;
						    IsTheHosId=isthehosid;
						    BookAuthorRangeId=rangeid;
						  }
						  }
						}
					}else{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵ���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
			
				if(id==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵ���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
			    if((BookAuthorTypeName!="")&&(id!="")&&(BookAuthorRange=="")&&(typeid!=3)&&((isthehosid=='0')||(isthehosid=='1')))          {
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ������λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				

				else{
					InventorId=id;
					BookAuthorTypeId=typeid;
					IsTheHosId=isthehosid;
				  BookAuthorRangeId=rangeid;
				}	
			}
			var data = new Ext.data.Record({'typerowid':BookAuthorTypeId,'typename':BookAuthorTypeName,'rowid':InventorId,'name':InventorName,'rangerowid':BookAuthorRangeId,'rangename':BookAuthorRange,'isthehosrowid':IsTheHosId,'isthehos':BookIsTheHos});
			InventorsGrid.stopEditing(); 
			InventorsGrid.getStore().insert(total,data);
//			if(total>0){
//				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
//				for(var i=1;i<total;i++){
//				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
//				  rawValue = rawValue+","+row;
//				}
//			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delInventors = new Ext.Button({
		text:'ɾ��',iconCls: 'edit_remove',
		handler: function() {  
			var rows = InventorsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = InventorsGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				InventorsGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}

//			var total = InventorsGrid.getStore().getCount();
//			//alert(total);
//			if(total>0){
//				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
//				for(var i=1;i<total;i++){
//				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
//				  rawValue = rawValue+","+row;
//				}
//			}
		}
	});
	var TotalNumField = new Ext.form.TextField({
		id: 'TotalNumField',
		fieldLabel: '������(ǧ��)',
		width:180,
		//allowBlank: false,
		listwidth : 180,
		triggerAction: 'all',
		//emptyText:'',
		name: 'TotalNumField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	
var PressDs = new Ext.data.Store({
	      autoLoad:true,
	      proxy : "",
	      reader : new Ext.data.JsonReader({
	                 totalProperty : 'results',
	                 root : 'rows'
	              }, ['rowid','name'])
});


PressDs.on('beforeload', function(ds, o){

	     ds.proxy=new Ext.data.HttpProxy({
	               url: 'herp.srm.monographrewardapplyexe.csp'
	                     + '?action=pressList&str='
	                     + encodeURIComponent(Ext.getCmp('PressField').getRawValue()),
	               method:'POST'
	              });
	});

var PressField = new Ext.form.ComboBox({
		id: 'PressField',
		fieldLabel: '������',
		width:180,
		listWidth : 260,
		//allowBlank: false,
		store: PressDs,
		displayField: 'name',
		valueField: 'rowid',
		triggerAction: 'all',
		typeAhead : true,
		triggerAction : 'all',
		//emptyText : '��ѡ�������...',
		name: 'PressField',
		pageSize: 10,
		minChars: 1,
		forceSelection : true,
		selectOnFocus:true,
	    editable:true,
		labelSeparator:'',
	    listeners : {
				       select:{
                       fn:function(combo,record,index) { 
                       Ext.Ajax.request({			        
                       url: '../csp/herp.srm.monographrewardapplyexe.csp?action=PressLevelList&pressdr='+PressField.getValue(),	
					           success: function(result, request){
					           
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
						         if (jsonData.success=='true'){
							         var data = jsonData.info;
							         var str=data.split("^")	
									 
                                     PressLevel.setValue(str[0]);        
                                     //PressAdd.setValue(str[1]);									 
					         	}
				         	},
					       scope: this
				      	});              
                  }
                }			
	 }
});
    var PressLevel = new Ext.form.TextField({
		id : 'PressLevel',
		fieldLabel:'�����缶��',
		width:180,
		//emptyText : '',
		selectOnFocus : true,
		labelSeparator:''
	});
	
	
	var PubTimeField = new Ext.form.DateField({
		id : 'PubTimeField',
		fieldLabel:'��������',
		//format : 'Y-m-d',
		width : 180,
		labelSeparator:''
		//allowBlank : false,
		//emptyText : ''
	});
	
	var ISBNField = new Ext.form.TextField({
		id: 'ISBNField',
		fieldLabel: 'ISBN��',
		width:180,
		//allowBlank: false,
		//regex:/^\d{3}-\d-\d{3}-\d{5}-\d$/,
		//regexText:'ISBN��ʽ����ȷ',
		listWidth : 260,
		triggerAction: 'all',
		//emptyText:'',
		name: 'ISBNField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	
	var PublishFreqField = new Ext.form.NumberField({
		id: 'PublishFreq',
		fieldLabel: '������',
		width:180,
		//allowBlank: false,
		listWidth : 260,
		triggerAction: 'all',
		//emptyText:'',
		name: 'PublishFreqField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
/////////////////��Ժ��λλ��///////////////////////////
var CompleteUnitStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','��һ��ɵ�λ'],['2','�ڶ���ɵ�λ'],['3','������ɵ�λ'],['4','������ɵ�λ'],['5','������ɵ�λ'],['6','������ɵ�λ'],['7','������ɵ�λ'],['8','�ڰ���ɵ�λ']]
});

var CompleteUnitField = new Ext.form.ComboBox({
	id: 'CompleteUnitField',
	fieldLabel: '��Ժ��λλ��',
	width:180,
	//anchor: '95%',
	listwidth : 180,
	//allowBlank: true,
	store:CompleteUnitStore,
	disabled:true,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	////emptyText:'��ѡ����Ժ��λλ��...',
	mode : 'local',
	name: 'CompleteUnitField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	labelSeparator:''
});

////��������
var ePrjNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
			totalProperty : "results",
			root : 'rows'
		}, ['rowid', 'name'])
	});
				
ePrjNameDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
		url : 'herp.srm.monographrewardapplyexe.csp'+'?action=GetPrjName&str='+encodeURIComponent(Ext.getCmp('ePrjNameField').getRawValue()),
		method : 'POST'
			});
	});
var ePrjNameField = new Ext.form.ComboBox({
	        id:'ePrjNameField',
			fieldLabel : '������Ŀ',
			width : 180,
			listWidth : 260,
			selectOnFocus : true,
			//allowBlank : true,
			store : ePrjNameDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			//emptyText : '',
			//mode : 'local', // ����ģʽ
			name:'ePrjNameField',
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''
	});
				
///Ժ�����п���
var eOutPrjNameField = new Ext.form.TextField({
	fieldLabel:'������Ŀ(Ժ��)',
	width : 180,
	//allowBlank : true,
	selectOnFocus : true,
	labelSeparator:''
});

	var colItems =	[
		{
			layout: 'column',
			border: false,
			defaults: {
				columnWidth: '.5',
				bodyStyle:'padding:5px 5px 0',
				border: false
			},            
			items: [
				{
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						/* {
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						}, */
			           esTypeCombox,eYearField,
					   NameField,
					   //unitdeptField,
					   InventorsGrid,EditorTypeField,unituserField,BookIsTheHosCombox,BookAuthorRangeCombox,
					   {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
						    xtype : 'displayfield',
							columnWidth : .3
							},addInventors,{
							xtype : 'displayfield',
							columnWidth : .2
							},delInventors]
					   }  
				   ]	 
				}, {
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						/* {
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						}, */
						TotalNumField,PressField,PressLevel,PubTimeField,ISBNField,PublishFreqField,//CompleteUnitField,
						ePrjNameField,unittypeField										
					]
				 }]
		}
	]		
	// create form panel
  var formPanel = new Ext.form.FormPanel({
    labelWidth: 100,
	labelAlign:'right',
	frame: true,
    items: colItems
	});
		                                                                                            //
    //������
    formPanel.on('afterlayout', function(panel, layout) { 
    	 //var rowObj=itemGrid.getSelectionModel().getSelections();    
    	 ////'rowid','Name','DeptDr','IsSigDept','Editor','MonTra','TotalNum','WriteWords','Press','PubTime','PriTime','ISBN','SubUser','SubDate','DataStatus','SysNo','ChkResult'
			this.getForm().loadRecord(rowObj[0]);
			NameField.setValue(rowObj[0].get("Name"));
			unittypeField.setValue(rowObj[0].get("Type"));
			//unitdeptField.setValue(rowObj[0].get("DeptName"));
			//InventorsGrid.getStore().getAt(i).get('EditorName')
            TotalNumField.setValue(rowObj[0].get("TotalNum"));
			PressField.setValue(rowObj[0].get("PressName"));
			PressLevel.setValue(rowObj[0].get("PressLevel"));
			PubTimeField.setValue(rowObj[0].get("PubTime"));
			ISBNField.setValue(rowObj[0].get("ISBN"));
			PublishFreqField.setValue(rowObj[0].get("PublishFreq"));
			CompleteUnitField.setRawValue(rowObj[0].get("CompleteUnit"));
			esTypeCombox.setRawValue(rowObj[0].get("sType"));
			eYearField.setValue(rowObj[0].get("YearID"));
			eYearField.setRawValue(rowObj[0].get("YearName"));
			ePrjNameField.setRawValue(rowObj[0].get("PrjName"));
   });   

var allauthorinfo="";
	    //���岢��ʼ�������޸İ�ť
	    var editButton = new Ext.Toolbar.Button({
				text:'����',iconCls: 'save'
			});                                                                                                                                            //
                    
		        //�����޸İ�ť��Ӧ����
			    editHandler = function(){
			    var rowObj=itemGrid.getSelectionModel().getSelections();
					//���岢��ʼ���ж��󳤶ȱ���
					
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");     
		        var Name = rowObj[0].get("Name");    
		        var Type = rowObj[0].get("Type");
				    //var Dept = rowObj[0].get("DeptName");
				    var Editor = rowObj[0].get("EditorIDs");
				    
				    var CompleteUnit = rowObj[0].get("CompleteUnit");
				    var TotalNum = rowObj[0].get("TotalNum");
				    var PressName = rowObj[0].get("PressName");
				    var PubTime = rowObj[0].get("PubTime");
				    var PublishFreq = rowObj[0].get("PublishFreq");
				    var ISBN = rowObj[0].get("ISBN");
				    var sType = rowObj[0].get("Type");
					var Year = rowObj[0].get("YearName")
					
				    var name = NameField.getValue();
				    var total = InventorsGrid.getStore().getCount();
						if(total>0){
							var authortypeid = InventorsGrid.getStore().getAt(0).get('typerowid');
							var authorid = InventorsGrid.getStore().getAt(0).get('rowid');
				      var authorrangeid = InventorsGrid.getStore().getAt(0).get('rangerowid');
				      var authoristhehosid = InventorsGrid.getStore().getAt(0).get('isthehosrowid');
				      allauthorinfo = authortypeid+"-"+authorid+"-"+authorrangeid+"-"+authoristhehosid;
				
							for(var i=1;i<total;i++){
							  //var row = InventorsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
							  var authortypeid = InventorsGrid.getStore().getAt(i).get('typerowid');
							  var authorid = InventorsGrid.getStore().getAt(i).get('rowid');
				        var authorrangeid = InventorsGrid.getStore().getAt(i).get('rangerowid');
				        var authoristhehosid = InventorsGrid.getStore().getAt(i).get('isthehosrowid');
				        var authorinfo = authortypeid+"-"+authorid+"-"+authorrangeid+"-"+authoristhehosid;
				        allauthorinfo = allauthorinfo+","+authorinfo;
							};
						}
			  var editor = allauthorinfo;
			  
				var typedr = unittypeField.getValue();
				//var deptdr = unitdeptField.getValue();
				var deptdr="";
				var totalnum = TotalNumField.getValue();
				var press = PressField.getValue();
				var pubtime = PubTimeField.getRawValue();
				var isbn = ISBNField.getValue();
				var publishfreq=PublishFreqField.getValue();
				var completeunit=CompleteUnitField.getValue();
				var stype=esTypeCombox.getValue();
				var year = eYearField.getValue();
				
				var prjdr = ePrjNameField.getValue(); ///libairu20160913������̨
				
				if (pubtime!==""){
					//pubtime=pubtime.format ('Y-m-d');
				}
				
				if(name==Name){name="";}
				if(typedr==Type){typedr="";}
				//if(deptdr==Dept){deptdr="";}
				if(totalnum==TotalNum){totalnum="";}
				if(press==PressName){press="";}
				if(pubtime==PubTime){pubtime="";}
				if(isbn==ISBN){isbn="";}
				if(completeunit==CompleteUnit){completeunit="";}
				if(editor==Editor){editor="";}
				if(publishfreq==PublishFreq){publishfreq="";}
			    completeunit="";
				if(stype==sType){stype="";}
				if(year==Year){year="";}
				/**
				var pattern=/^\d{3}-\d-\d{3}-\d{5}-\d$/;
                     if(!pattern.test(isbn)){
			     Ext.Msg.show({title:'ע��',msg:'ISBNӦ������13λ��Ч����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
			return null;
		}
		        **/
		if(esTypeCombox.getRawValue()=="")
		{
		Ext.Msg.show({title:'����',msg:'���Ͳ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}
		if(eYearField.getRawValue()=="")
		{
		Ext.Msg.show({title:'����',msg:'��Ȳ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}
		if(NameField.getRawValue()=="")
		{
		Ext.Msg.show({title:'����',msg:'ר�����Ʋ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}
		
        if(InventorsGrid.getStore().getCount()<1)
     	{
      		Ext.Msg.show({title:'����',msg:'��ѡ����������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      		return;
    	};
        if(TotalNumField.getRawValue()=="")
         {
        	Ext.Msg.show({title:'����',msg:'����������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
        }
        if(PressField.getRawValue()=="")
		{
		Ext.Msg.show({title:'����',msg:'�����粻��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}
        
		if(PubTimeField.getRawValue()=="")
		{
		Ext.Msg.show({title:'����',msg:'����ʱ�䲻��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}
		
		if(ISBNField.getRawValue()=="")
		{
		Ext.Msg.show({title:'����',msg:'ISBN�Ų���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}
		
		if(PublishFreqField.getRawValue()=="")
		{
		Ext.Msg.show({title:'����',msg:'�����β���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}

		if(unittypeField.getRawValue()=="")
		{
		Ext.Msg.show({title:'����',msg:'���������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}	
		
		
				if (formPanel.form.isValid()) {
                Ext.Ajax.request({
				url:'herp.srm.monographrewardapplyexe.csp?action=edit&rowid='+rowid+'&name='+encodeURIComponent(name)+'&typedr='+encodeURIComponent(typedr)+'&deptdr='+encodeURIComponent(deptdr)+'&editor='+encodeURIComponent(editor)+'&totalnum='+encodeURIComponent(totalnum)+'&press='+encodeURIComponent(press)+'&pubtime='+encodeURIComponent(pubtime)+'&isbn='+encodeURIComponent(isbn)+'&publishfreq='+encodeURIComponent(publishfreq)+'&completeunit='+encodeURIComponent(completeunit)+'&sType='+stype+'&Year='+year+'&PrjDr='+prjdr,
				
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGrid.load({params:{start:0, limit:25,userdr:userdr}});		
				}
				else
					{
					var message="�ظ����";
					if(jsonData.info=='RepISBN') message="ISBN���ظ���";
					if(jsonData.info=='RepName') message="�����ظ���";
					Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				
				};
			},
				scope: this
			});
			}
			editwin.close();
		};
		//��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click',editHandler,false);
	
		//���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'�ر�',iconCls : 'cancel'
		});
	
		//����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			editwin.close();
		};
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//���岢��ʼ������
		var editwin = new Ext.Window({
			title: '�޸�ר������������Ϣ',
			iconCls: 'pencil',
			width : 660,
			height : 470,    
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
		
		editwin.show();
		
		

		
	};
