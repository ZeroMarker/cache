var userid = session['LOGON.USERCODE'];

EditFun = function(AuthorInfoID,CorrAuthorInfoID) {
	

	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//alert(rowObj[0].get("remark"));
	if(len < 1)
	{
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		var editRowid = rowObj[0].get("rowid"); 
		var tmptypeid = rowObj[0].get("TypeID"); 
		var tmpyearid = rowObj[0].get("YearID"); 
		var tmprecordtypeid = rowObj[0].get("RecordTypeID"); 
		var tmpjournaldr = rowObj[0].get("JournalDR"); 
		var tmpjourlevelid = rowObj[0].get("JourLevelID"); 
		var tmppapertypeid = rowObj[0].get("PaperTypeID"); 
		var tmpcompunitid = rowObj[0].get("CompleteUnitID"); 
		var tmpprjdr = rowObj[0].get("PrjDR"); 
	}

////////////////////�ڿ�����///////////////////
var eJNameDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
	
eJNameDs.on('beforeload', function(ds, o){
	    ds.proxy=new Ext.data.HttpProxy({
			 url:projUrl+'?action=GetJournalDict&str='+encodeURIComponent(Ext.getCmp('eJNameField').getRawValue()),method:'POST'});
		var year=YearField.getValue();	
		if(!year){
			Ext.Msg.show({title:'ע��',msg:'����ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return ;
		}
});

///////////////////�ڿ�����/////////////////////////////  
var eJNameField = new Ext.form.ComboBox({
				    id : 'eJNameField',
				    fieldLabel: '�ڿ�����',
				    width:180,
				    listWidth : 260,
				    allowBlank :false,
				    store: eJNameDs,
				    valueField: 'rowid',
				    displayField: 'name',
				    triggerAction: 'all',
				    //emptyText:'ѡ��...',
				    name: 'eJNameField',
			    	minChars: 1,
				    pageSize: 10,
				    anchor: '95%',
				    selectOnFocus:true,
				    //mode : 'local',
				    forceSelection:'true',
				    editable:true,
					labelSeparator:'',
					value:tmpjournaldr,
				    listeners:{"select":function(combo,record,index){ 
				   	    Ext.Ajax.request({				   	    			        
                     url: projUrl+'?action=GetJournalInfo&year='+encodeURIComponent(YearField.getValue())+'&jdr='+encodeURIComponent(eJNameField.getValue()),
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
						         if (jsonData.success=='true'){
							         var data = jsonData.info;	
							         var dataarr = data.split("^",-1);
							         var typename = dataarr[2];
							         var levelname = dataarr[3]; 			
							         var ifs = dataarr[4];	         
                       //RecordType.setValue(typename);       
                       JourLevel.setValue(levelname);  
                       IF.setValue(ifs);
					         	}
				         	},
					       scope: this
				   	    });           
			        }}  
});	
///////////////////����¼���ݿ�/////////////////////////////  
/**
var RecordType = new Ext.form.TextField({
				fieldLabel: '����¼���ݿ�',
				width:180,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '����¼���ݿ�......',
				selectOnFocus:'true',
				disabled:true

			});
**/

			
	/* var RecordTypeDs = new Ext.data.Store({
		        autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});	
	
	
	RecordTypeDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:projUrl+'?action=GetJournalTypes&str='+encodeURIComponent(Ext.getCmp('RecordType').getRawValue()),method:'POST'});
				
	}); */
	var eRecordTypeDs = new Ext.data.Store({
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : "results",
								root : 'rows'
							}, ['rowid', 'name'])
				});

		eRecordTypeDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
			         url : projUrl+'?action=GetJournalTypes&str='+encodeURIComponent(Ext.getCmp('eRecordTypeField').getRawValue()),
			         method : 'POST'
				});
		});
	
	var eRecordTypeField = new Ext.form.ComboBox({
					id:'eRecordTypeField',
			        name:'eRecordTypeField',
			        fieldLabel : '����¼���ݿ�',
					store : eRecordTypeDs,
					displayField : 'name',
					valueField : 'rowid',
					//typeAhead : true,
					allowBlank : false, 
					anchor: '95%',
					forceSelection : true,
					triggerAction : 'all',
					//emptyText : '',
					width : 180,
					value:tmprecordtypeid,
					listWidth : 260,
                    editable:true,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					labelSeparator:''
 });			
 
 ///////////////////�ڿ�����/////////////////////////////  
var JourLevel = new Ext.form.TextField({
				fieldLabel: '�ڿ�����',
				width:180,
				allowBlank : true, 
				anchor: '95%',
        ////emptyText: '�ڿ�����......',
				selectOnFocus:'true',
        disabled:true,
		labelSeparator:''
			});

///////////////////������Ŀ/////////////////////////////  
var Title = new Ext.form.TextArea({
				fieldLabel: '������Ŀ',
				width:180,
				allowBlank : false, 
				anchor: '95%',
        ////emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});
			
///////////////////�������/////////////////////////////  
var EnPaperTypeDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
	});
					
EnPaperTypeDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:projUrl+'?action=GetPaperType&str='+encodeURIComponent(Ext.getCmp('EnPaperType').getRawValue()),method:'POST'});
	});
	
var EnPaperType = new Ext.form.ComboBox({
				    id :'EnPaperType',
				    fieldLabel: '�������',
				    width:180,
				    listWidth : 260,
				    allowBlank :true,
				    store: EnPaperTypeDs,
				    valueField: 'code',
				    displayField: 'name',
				    triggerAction: 'all',
				    ////emptyText:'ѡ��...',
				    name: 'EnPaperType',
					value:tmppapertypeid,
			    	minChars: 1,
				    pageSize: 10,
				    anchor: '95%',
				    selectOnFocus:true,
				    forceSelection:'true',
				    editable:true,
					labelSeparator:''
			});

///////////////////��һ����/////////////////////////////  
var FristAuthorDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
					
FristAuthorDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('FristAuthor').getRawValue()),method:'POST'});
	});
	
var FristAuthor = new Ext.form.ComboBox({
				    id :'FristAuthor',
				    fieldLabel: '��һ����',
				    width:180,
				    listWidth : 260,
				    allowBlank :true,
				    store: FristAuthorDs,
				    valueField: 'rowid',
				    displayField: 'name',
				    triggerAction: 'all',
				    ////emptyText:'ѡ��...',
				    name: 'FristAuthor',
			    	minChars: 1,
				    pageSize: 10,
				    anchor: '95%',
					disabled:true,
				    selectOnFocus:true,
				    forceSelection:'true',
				    editable:true,
					labelSeparator:''
			});	

////*************����ID���������Ƿ�Ժ**************////////
//////////////////����///////////////////////
var ParticipantssDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


ParticipantssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('Participantsss').getRawValue()),
	method:'POST'});
});

var ParticipantsFields = new Ext.form.ComboBox({
	id: 'Participantsss',
	fieldLabel: '����',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:ParticipantssDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ������...',
	name: 'Participantsss',
	minChars: 1,
	pageSize: 10,
	anchor: '95%',
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

///////////////////����λ��/////////////////////////////  
var AuthorRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��һ'],['2', '�ڶ�'], ['3', '����'], ['4', '����'], ['5', '����'],['6', '����'],['7', '����'],['8', '�ڰ�'],['9', '����']]
	});		
		
var AuthorRangeCombox = new Ext.form.ComboBox({
	                   id : 'AuthorRangeCombox',
		           fieldLabel : '����λ��',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : AuthorRangeDs,
		           anchor : '95%',			
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
///////////////////�Ƿ�Ժ/////////////////////////////  
var IsTheHosDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��Ժְ��'],['0', '��Ժ��Ա'],['2','��ʿ�о���'],['3','˶ʿ�о���']]
	});		
		
var IsTheHosCombox = new Ext.form.ComboBox({
	                   id : 'IsTheHosCombox',
		           fieldLabel : '���ķ���ʱ���',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : IsTheHosDs,
		           anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:'',
				   listeners:{
                           "select":function(combo,record,index){
						           if((combo.value=='2')||(combo.value=='3'))
								   {
								   AuthorRangeCombox.setValue('');
								   AuthorRangeCombox.disable();  //��Ϊ�ң����ɱ༭
                                   //AuthorRangeCombox.disabled=true;   //����Ϊ�ң����ɱ༭	
                                   }				
                                   else{
								   AuthorRangeCombox.enable();  	
								   }								   
			}
	}	
						  });	
						  
var ParticipantsGrid = new Ext.grid.GridPanel({
		id:'ParticipantsGrid',
    store: new Ext.data.Store({
    autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:projUrl+'?action=GetPaperAuthorInfo&start='+0+'&limit='+25+'&IDs='+AuthorInfoID,
		method:'POST'}),
	  reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','rangerowid','range','isthehosrowid','isthehos'])

    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '����ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '��������', dataIndex: 'name',align:'center',width: 80},
            {id: 'rangerowid', header: '��������ID', width: 129, sortable: true, dataIndex: 'rangerowid',hidden:true},
            {header: '����λ��', dataIndex: 'range',align:'center',width: 80},
            {id: 'isthehosrowid', header: '���ķ���ʱ���ID', width: 129, sortable: true, dataIndex: 'isthehosrowid',hidden:true},
            {header: '���ķ���ʱ���', dataIndex: 'isthehos',align:'center',width: 100}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 280,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ���μ���Ա��ť////////////////
var addParticipants  = new Ext.Button({
		text: '����',
		iconCls: 'edit_add',
		handler: function(){
			var ParticipantsId;
			var RangeId;
			var IsTheHosId;
			var id = Ext.getCmp('Participantsss').getValue();
			var rangeid = Ext.getCmp('AuthorRangeCombox').getValue();
			var isthehosid = Ext.getCmp('IsTheHosCombox').getValue();
			var ParticipantsName = Ext.getCmp('Participantsss').getRawValue();
			var AuthorRange = Ext.getCmp('AuthorRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('IsTheHosCombox').getRawValue();
			var firstauthor = FristAuthor.getValue();
		
      if(id==firstauthor )
			{
				if( rangeid!=1)
				{
				   Ext.Msg.show({title:'����',msg:'��һ����λ�α���Ϊ��һλ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				   return;
			  }
			}
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = ParticipantsGrid.getStore().getAt(i).get('rowid');
					var tmprange = ParticipantsGrid.getStore().getAt(i).get('range');
					
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
						   if((rangeid=="")&&((isthehosid=='0')||(isthehosid=='1')))
							{
							  Ext.Msg.show({title:'����',msg:'��ѡ������λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else {
							if((tmprange==AuthorRange)&&((isthehosid=='0')||(isthehosid=='1')))
							{
								Ext.Msg.show({title:'����',msg:'��ͬ��������ѡ������ͬ��λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
							if(rangeid=='1'){
							FristAuthor.setValue(id);FristAuthor.setRawValue(ParticipantsName);
							}
						    ParticipantsId=id;
						    RangeId=rangeid;
						    IsTheHosId=isthehosid;
						  }
						}
					}
					}else{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}
					
					
				if((AuthorRange=="")&&((isthehosid=='0')||(isthehosid=='1')))
							{
								Ext.Msg.show({title:'����',msg:'��ѡ������λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							
							if(IsTheHos=="")
							{
								Ext.Msg.show({title:'����',msg:'��ѡ�����ķ���ʱ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				if((AuthorRange=="")&&((isthehosid=='0')||(isthehosid=='1')))
							{
								Ext.Msg.show({title:'����',msg:'��ѡ������λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							
							if(IsTheHos=="")
							{
								Ext.Msg.show({title:'����',msg:'��ѡ�����ķ���ʱ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
				else{		
				       if(rangeid=='1'){
							FristAuthor.setValue(id);FristAuthor.setRawValue(ParticipantsName);
					    }
						ParticipantsId=id;
						RangeId=rangeid;
						IsTheHosId=isthehosid;			
				}	
			}
			var data = new Ext.data.Record({'rowid':ParticipantsId,'name':ParticipantsName,'rangerowid':RangeId,'isthehosrowid':IsTheHosId,'range':AuthorRange,'isthehos':IsTheHos});
			ParticipantsGrid.stopEditing(); 
			ParticipantsGrid.getStore().insert(ptotal,data);
			if(ptotal>0){
				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  prawValue = prawValue+","+prow;
				}
			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delParticipants = new Ext.Button({
		text:'ɾ��',
		iconCls: 'edit_remove',
		handler: function() {  
			var rows = ParticipantsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = ParticipantsGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				var temprangerowid = ParticipantsGrid.getStore().getAt(rRowid).get('rangerowid')
				//alert("temprangerowid:"+temprangerowid);
				if(temprangerowid=='1'){FristAuthor.setValue("");FristAuthor.setRawValue("");}
				ParticipantsGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}

			var ptotal = ParticipantsGrid.getStore().getCount();
			//alert(total);
			if(ptotal>0){
				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  prawValue = prawValue+","+prow;
				}
			}
			
		}
	});
////*************����ID���������Ƿ�Ժ**************////////

///////////////////��һͨѶ����/////////////////////////////  
var CorrAuthorDs = new Ext.data.Store({
				//autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
			
			
CorrAuthorDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('CorrAuthor').getRawValue()),method:'POST'});
	});
	
var CorrAuthor = new Ext.form.ComboBox({
				    id :'CorrAuthor',
				    fieldLabel: '��һͨѶ����',
				    width:180,
				    listWidth : 260,
				    allowBlank :true,
				    store: CorrAuthorDs,
				    valueField: 'rowid',
				    displayField: 'name',
				    triggerAction: 'all',
				    ////emptyText:'ѡ��...',
				    name: 'CorrAuthor',
			    	minChars: 1,
				    pageSize: 10,
				    anchor: '95%',
					disabled:true,
				    selectOnFocus:true,
				    forceSelection:'true',
				    editable:true,
					labelSeparator:''
			});	
			
////*************ͨѶ����ID���������Ƿ�Ժ**************////////
//////////////////ͨѶ����///////////////////////
var CorrParticipantssDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


CorrParticipantssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAuthor&str='+encodeURIComponent(Ext.getCmp('CorrParticipantsss').getRawValue()),
	method:'POST'});
});

var CorrParticipantsFields = new Ext.form.ComboBox({
	id: 'CorrParticipantsss',
	fieldLabel: 'ͨѶ����',
	width:180,
	listWidth : 260,
	anchor:'95%',
	allowBlank: true,
	store:CorrParticipantssDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ������ͨѶ����...',
	name: 'CorrParticipantsss',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

///////////////////ͨѶ����λ��/////////////////////////////  
var CorrAuthorRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��һ'],['2', '����']]
		//data : [['1', '��һ'],['2', '�ڶ�'], ['3', '����'], ['4', '����'], ['5', '����'],['6', '����'],['7', '����'],['8', '�ڰ�']]
	});		
		
var CorrAuthorRangeCombox = new Ext.form.ComboBox({
	                   id : 'CorrAuthorRangeCombox',
		           fieldLabel : 'ͨѶ����λ��',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : CorrAuthorRangeDs,
		           anchor : '95%',			
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
///////////////////ͨѶ�����Ƿ�Ժ/////////////////////////////  
var CorrIsTheHosDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��Ժְ��'],['0', '��Ժ��Ա'],['2','��ʿ�о���'],['3','˶ʿ�о���']]
	});		
		
var CorrIsTheHosCombox = new Ext.form.ComboBox({
	                   id : 'CorrIsTheHosCombox',
		           fieldLabel : '��������ʱ���',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : CorrIsTheHosDs,
		           anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:'',
				   listeners:{
                           "select":function(combo,record,index){
						           if((combo.value=='2')||(combo.value=='3'))
								   {
								   CorrAuthorRangeCombox.setValue('');
								   CorrAuthorRangeCombox.disable();  //��Ϊ�ң����ɱ༭
                                   //CorrAuthorRangeCombox.disabled=true;   //����Ϊ�ң����ɱ༭	
                                   }				
                                   else{
								   CorrAuthorRangeCombox.enable();  	
								   }								   
			}
	}	
						  });	
						  
var CorrParticipantsGrid = new Ext.grid.GridPanel({
		id:'CorrParticipantsGrid',
    store: new Ext.data.Store({
    autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:projUrl+'?action=GetPaperAuthorInfo&start='+0+'&limit='+25+'&IDs='+CorrAuthorInfoID,
		method:'POST'}),
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','rangerowid','range','isthehosrowid','isthehos'])
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: 'ͨѶ����ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: 'ͨѶ��������', dataIndex: 'name',align:'center',width: 80},
            {id: 'rangerowid', header: 'ͨѶ��������ID', width: 129, sortable: true, dataIndex: 'rangerowid',hidden:true},
            {header: 'ͨѶ����λ��', dataIndex: 'range',align:'center',width: 80,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					   if (value=='�ڶ�'){
						   var value='����';
						   };       
						  return '<span >'+value+'</span>';
			}
            
            },
            {id: 'isthehosrowid', header: '��������ʱ���ID', width: 129, sortable: true, dataIndex: 'isthehosrowid',hidden:true},
            {header: '��������ʱ���', dataIndex: 'isthehos',align:'center',width: 100}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 280,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////��Ӷ���μ���Ա��ť////////////////
var addCorrParticipants  = new Ext.Button({
		text: '����',
		iconCls: 'edit_add',
		handler: function(){
			var ParticipantsId;
			var RangeId;
			var IsTheHosId;
			var id = Ext.getCmp('CorrParticipantsss').getValue();
			var rangeid = Ext.getCmp('CorrAuthorRangeCombox').getValue();
			var isthehosid = Ext.getCmp('CorrIsTheHosCombox').getValue();
			var ParticipantsName = Ext.getCmp('CorrParticipantsss').getRawValue();
			var AuthorRange = Ext.getCmp('CorrAuthorRangeCombox').getRawValue();
			var IsTheHos = Ext.getCmp('CorrIsTheHosCombox').getRawValue();
			var corrauthor = CorrAuthor.getValue();
		
			var ptotal = CorrParticipantsGrid.getStore().getCount();
//			if(corrauthor==id)
//			{
//				Ext.Msg.show({title:'����',msg:'�����ٴ�ѡ���һͨѶ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//			  return;
//			}
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = CorrParticipantsGrid.getStore().getAt(i).get('rowid');
					var tmprange = CorrParticipantsGrid.getStore().getAt(i).get('range');
					
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
						    if((rangeid=="")&&((isthehosid=='0')||(isthehosid=='1')))
							{
							  Ext.Msg.show({title:'����',msg:'��ѡ������λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
							if((tmprange==AuthorRange)&&(AuthorRange=='��һ'))
							{
								Ext.Msg.show({title:'����',msg:'��һͨѶ����ֻ��ѡ��һ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
							if(rangeid=='1'){
						       CorrAuthor.setValue(id);CorrAuthor.setRawValue(ParticipantsName);
					        }
						    ParticipantsId=id;
						    RangeId=rangeid;
						    IsTheHosId=isthehosid;
						  }
						  }
						}
					}else{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵ�ͨѶ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				
				if((AuthorRange=="")&&((isthehosid=='0')||(isthehosid=='1')))
							{
								Ext.Msg.show({title:'����',msg:'��ѡ��ͨѶ����λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							
							if(IsTheHos=="")
							{
								Ext.Msg.show({title:'����',msg:'��ѡ�����ķ���ʱ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
				
				
				}
			}else{
				if(id==""){
					
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵ�ͨѶ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				
					
				
				else{	
				
				
					
				       if(rangeid=='1'){
						CorrAuthor.setValue(id);CorrAuthor.setRawValue(ParticipantsName);
					   }
						ParticipantsId=id;
						RangeId=rangeid;
						IsTheHosId=isthehosid;			
				}	
			}
			var data = new Ext.data.Record({'rowid':ParticipantsId,'name':ParticipantsName,'rangerowid':RangeId,'isthehosrowid':IsTheHosId,'range':AuthorRange,'isthehos':IsTheHos});
			CorrParticipantsGrid.stopEditing(); 
			CorrParticipantsGrid.getStore().insert(ptotal,data);
			if(ptotal>0){
				prawValue = CorrParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = CorrParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  prawValue = prawValue+","+prow;
				}
			}
			//alert(rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delCorrParticipants = new Ext.Button({
		text:'ɾ��',
		iconCls: 'edit_remove',
		handler: function() {  
			var rows = CorrParticipantsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = CorrParticipantsGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				//����к�ΪrRowid��rangerowidrowid
				var temprangerowid = CorrParticipantsGrid.getStore().getAt(rRowid).get('rangerowid') 
				//alert("temprangerowid:"+temprangerowid);
				if(temprangerowid=='1'){CorrAuthor.setValue("");CorrAuthor.setRawValue("");}
				CorrParticipantsGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}

			var ptotal = CorrParticipantsGrid.getStore().getCount();
			//alert(total);
			if(ptotal>0){
				prawValue = CorrParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = CorrParticipantsGrid.getStore().getAt(i).get('rowid');//ÿ�ж���rowid��ֵ
				  prawValue = prawValue+","+prow;
				}
			}
			
		}
	});
////*************ͨѶ����ID���������Ƿ�Ժ**************////////

///////////////////��/////////////////////////////  

var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetYear&str='+encodeURIComponent(YearField.getRawValue()),method:'POST'});
});

var YearField = new Ext.form.ComboBox({
	id: 'YearField',
	fieldLabel: '��',
	width:180,
	listWidth : 260,
	allowBlank: true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	anchor: '95%',
	name: 'YearField',
	value:tmpyearid,
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});
		
///////////////////��/////////////////////////////  
var Roll = new Ext.form.TextField({
				fieldLabel: '��',
				width:180,
				//allowBlank : true, 
				regex:/[0-9]*[1-9][0-9]*$/,
				regexText:"����д����!",
				anchor: '95%',
        ////emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});
					
			
///////////////////��/////////////////////////////  
var Period = new Ext.form.TextField({
				fieldLabel: '��',
				width:180,
				//allowBlank : true, 
				regex:/[0-9]*[1-9][0-9]*$/,
				regexText:"����д����!",
				anchor: '95%',
        ////emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});		
			
			
			
///////////////////��ʼҳ/////////////////////////////  
var StartPage = new Ext.form.TextField({
				fieldLabel: '��ʼҳ',
				width:180,
				allowBlank : true,
				regex:/[0-9]*[1-9][0-9]*$/,
				regexText:"����д����!", 
				anchor: '95%',
        ////emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});
					
			
///////////////////��ֹҳ/////////////////////////////  
var EndPage = new Ext.form.TextField({
				fieldLabel: '��ֹҳ',
				width:180,
				allowBlank : true, 
				regex:/[0-9]*[1-9][0-9]*$/,
				regexText:"����д����!",
				anchor: '95%',
        ////emptyText: '��Ŀ����......',
				selectOnFocus:'true',
				labelSeparator:''

			});			
	
///////////////////Ӱ������/////////////////////////////  
var IF = new Ext.form.NumberField({
				id:'IF',
				fieldLabel: 'Ӱ������',
				width:180,
				allowBlank : true, 
				disabled:false,
				anchor: '95%',
				regex:/^\d+(\.\d+)?$/,
				regexText:"����д����!",
				name:'IF',
				selectOnFocus:'true',
				editable:true,
				labelSeparator:''

								
});			
///////////////////�����/////////////////////////////  
var PageChargeField = new Ext.form.NumberField({
				fieldLabel: '��������(Ԫ)',
				width:180,
				allowBlank : true, 
				disabled:false,
				regex:/^\d+(\.\d+)?$/,
				regexText:"����д����!",
				anchor: '95%',
				selectOnFocus:'true',
				editable:true,
				labelSeparator:''

});
////////////////////���ҵ�λ/////////////////////////////

var UnitMoneyStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['R','�����'],['D','��Ԫ'],['E','ŷԪ'],['P','Ӣ��']]
});

var UnitMoneyField = new Ext.form.ComboBox({
	id: 'UnitMoneyField',
	fieldLabel: '���ҵ�λ',
	width:180,
	anchor: '95%',
	listWidth : 180,
	allowBlank: true,
	store:UnitMoneyStore,
	valueField: 'key',
	displayField: 'keyvalue',
	value:'R',
	triggerAction: 'all',
	//emptyText:'��ѡ����ҵ�λ...',
	mode : 'local',
	name: 'UnitMoneyField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	labelSeparator:''

});


///////////////////��Ʊ����/////////////////////////////  
var InvoiceCodeField = new Ext.form.NumberField({
				fieldLabel: '��Ʊ����',
				width:180,
				allowBlank : true, 
				disabled:false,
				anchor: '95%',
				selectOnFocus:'true',
				editable:true,
				labelSeparator:''

});	
///////////////////��Ʊ����/////////////////////////////  
var InvoiceNoField = new Ext.form.NumberField({
				fieldLabel: '��Ʊ����',
				width:180,
				allowBlank : true, 
				disabled:false,
				anchor: '95%',
				selectOnFocus:'true',
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
	anchor: '95%',
	listWidth : 180,
	allowBlank: true,
	store:CompleteUnitStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	////emptyText:'��ѡ����Ժ��λλ��...',
	mode : 'local',
	name: 'CompleteUnitField',
	minChars: 1,
	//pageSize: 10,
	value:tmpcompunitid,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	labelSeparator:''

});
/////////////////�Ƿ�ESI�߱���///////////////////////////
var ESICitedStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','��'],['0','��']]
});

var ESICitedField = new Ext.form.ComboBox({
	id: 'ESICitedField',
	disabled:true,
	fieldLabel: '�Ƿ�ESI�߱���',
	width:180,
	anchor: '95%',
	listWidth : 180,
	allowBlank: true,
	store:ESICitedStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	////emptyText:'��ѡ���Ƿ�ESI�߱���...',
	mode : 'local',
	name: 'ESICitedField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	//hidden:true,
	labelSeparator:''

});
///////////////////����/////////////////////////////  
var eTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var eTypeCombox = new Ext.form.ComboBox({
	                   id : 'eTypeCombox',
		           fieldLabel : '����',
	                   width : 180,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : eTypeDs,
		           anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           value:tmptypeid,
		           selectOnFocus : true,
		           forceSelection : true,
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
						url : projUrl+'?action=GetPrjName&str='+encodeURIComponent(Ext.getCmp('ePrjNameField').getRawValue()),
						method : 'POST'
					});
		});
var ePrjNameField = new Ext.form.ComboBox({
	        id:'ePrjNameField',
			fieldLabel : '������Ŀ',
			width : 180,
			listWidth : 260,
			selectOnFocus : true,
			//allowBlank : false,
			store : ePrjNameDs,
			anchor : '95%',
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
			value:tmpprjdr,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''

		});

///Ժ�����п���
var eOutPrjNameField = new Ext.form.TextField({
	fieldLabel:'������Ŀ(Ժ��)',
	width : 180,
	anchor : '95%',
	allowBlank : true,
	selectOnFocus : true,
	labelSeparator:''

});

var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.5',
							bodyStyle:'padding:0px 0px 0',
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
										columnWidth : .03
									}, */
									eTypeCombox,
									 eJNameField,   
								   JourLevel,
								    eRecordTypeField,
								   EnPaperType, 
								   Title, 	 
                                   //ESICitedField,								   
								   CompleteUnitField,
									 YearField,
								   Roll,
								   Period,
								   StartPage,
								   EndPage,
									 IF	,
									 PageChargeField,
									 UnitMoneyField,
								   InvoiceCodeField,
								   InvoiceNoField	
								   					   
								]	 
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								   /* {
										xtype : 'displayfield',
										value : '',
										columnWidth : .03
									}, */
									FristAuthor, 
								   ParticipantsGrid,
					         ParticipantsFields,
							 IsTheHosCombox,
					         AuthorRangeCombox,
					        {
						         columnWidth : 1,
						         xtype : 'panel',
						         layout : "column",
						         items : [{
							       xtype : 'displayfield',
							       columnWidth : .05
							    },addParticipants,
							    {
							       xtype : 'displayfield',
							       columnWidth : .07
							    },delParticipants]
						      },
								   CorrAuthor,
								   CorrParticipantsGrid,
					         CorrParticipantsFields,
							 CorrIsTheHosCombox,
					         CorrAuthorRangeCombox,
					        {
						         columnWidth : 1,
						         xtype : 'panel',
						         layout : "column",
						         items : [{
							       xtype : 'displayfield',
							       columnWidth : .05
							    },addCorrParticipants,
							    {
							       xtype : 'displayfield',
							       columnWidth : .07
							    },delCorrParticipants]
						      }	,
								ePrjNameField,	
								eOutPrjNameField
								]
							 }]
					}
				]			
			
var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 100,
				labelAlign:'right',
				//layout: 'form',
				frame: true,
				items: colItems
			});

formPanel.on('afterlayout', function(panel, layout) {
			var rowObj=itemGrid.getSelectionModel().getSelections(); 
			this.getForm().loadRecord(rowObj[0]);
			//"rowid^RecordType^DeptDr^Title^JName^PType^FristAuthor^CorrAuthor^CNPaperType^PageCharge^SubUser^
			//SubDate^DataStatus^CheckDesc^CheckState^RegInfo^PubYear^Roll^Period^StartPage^EndPage^TitleInfo"
			Title.setValue(rowObj[0].get("Title"));
			eJNameField.setRawValue(rowObj[0].get("JName"));
			//JName.setValue(rowObj[0].get("JournalDR"));
			eRecordTypeField.setRawValue(rowObj[0].get("RecordType"));//����¼���ݿ�
			//RecordType.setValue(rowObj[0].get("RecordTypeID"));
			
			UnitMoneyField.setRawValue(rowObj[0].get("UnitMoney"));//���ҵ�λ
			
			JourLevel.setRawValue(rowObj[0].get("JourLevel"));   //��С��
			EnPaperType.setRawValue(rowObj[0].get("PaperType"));	
			FristAuthor.setRawValue(rowObj[0].get("FristAuthor"));	
			CorrAuthor.setRawValue(rowObj[0].get("CorrAuthor"));	
			
			//FirstAuthorRangeCombox.setRawValue(rowObj[0].get("FristAuthorRange"));
			
			PageChargeField.setValue(rowObj[0].get("PageCharge"));			
			YearField.setRawValue(rowObj[0].get("PubYear"));
			Roll.setValue(rowObj[0].get("Roll"));
		    Period.setValue(rowObj[0].get("Period"));
			StartPage.setValue(rowObj[0].get("StartPage"));
			EndPage.setValue(rowObj[0].get("EndPage"));
			InvoiceCodeField.setValue(rowObj[0].get("InvoiceCode"));   //��С��
			InvoiceNoField.setValue(rowObj[0].get("InvoiceNo"));
			
			CompleteUnitField.setRawValue(rowObj[0].get("CompleteUnit"));
			IF.setValue(rowObj[0].get("IF"));
			ESICitedField.setRawValue(rowObj[0].get("ESICited"));
			eTypeCombox.setRawValue(rowObj[0].get("Type"));
			
			ePrjNameField.setRawValue(rowObj[0].get("PrjName"));
			eOutPrjNameField.setValue(rowObj[0].get("OutPrjName"))
		});
	
			editButton = new Ext.Toolbar.Button({
				text:'����',
				iconCls: 'save'
			});
var allauthorinfo = "";
var allcorrauthorinfo = "";

			editHandler = function(){
				var PrjDr = ePrjNameField.getValue(); 
				var OutPrjName = eOutPrjNameField.getValue();
				
				var JNameDr = eJNameField.getValue(); 
				
				var Titles = Title.getValue(); 
				var EnPaperTypes = EnPaperType.getValue();   //��С��
				var FristAuthors = FristAuthor.getValue(); 
				//var FristAuthorsRange = FirstAuthorRangeCombox.getValue(); 
				var authorscount = ParticipantsGrid.getStore().getCount();
			  if(authorscount>0){
				var authorid = ParticipantsGrid.getStore().getAt(0).get('rowid');
				var authorrangeid = ParticipantsGrid.getStore().getAt(0).get('rangerowid');
				var authoristhehosid = ParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				allauthorinfo = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				for(var i=1;i<authorscount;i++){
				  var authorid = ParticipantsGrid.getStore().getAt(i).get('rowid');
				  var authorrangeid = ParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  var authoristhehosid = ParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  var authorinfo = authorid+"-"+authorrangeid+"-"+authoristhehosid;
				  allauthorinfo = allauthorinfo+","+authorinfo;
				   };
			   }
				
				var CorrAuthors = CorrAuthor.getValue(); 
				//var CorrAuthorsRange = CorrAuthorRangeCombox.getValue(); 
				var corrauthorscount = CorrParticipantsGrid.getStore().getCount();
			  if(corrauthorscount>0){
				var corrauthorid = CorrParticipantsGrid.getStore().getAt(0).get('rowid');
				var corrauthorrangeid = CorrParticipantsGrid.getStore().getAt(0).get('rangerowid');
				var corrauthoristhehosid = CorrParticipantsGrid.getStore().getAt(0).get('isthehosrowid');
				allcorrauthorinfo = corrauthorid+"-"+corrauthorrangeid+"-"+corrauthoristhehosid;
				for(var i=1;i<corrauthorscount;i++){
				  var corrauthorid = CorrParticipantsGrid.getStore().getAt(i).get('rowid');
				  var corrauthorrangeid = CorrParticipantsGrid.getStore().getAt(i).get('rangerowid');
				  var corrauthoristhehosid = CorrParticipantsGrid.getStore().getAt(i).get('isthehosrowid');
				  var corrauthorinfo = corrauthorid+"-"+corrauthorrangeid+"-"+corrauthoristhehosid;
				  allcorrauthorinfo = allcorrauthorinfo+","+corrauthorinfo;
				   };
			   }
			   
				var YearFields = YearField.getValue(); 
				var Rolls = Roll.getValue(); 			
				var Periods = Period.getValue(); 
        var StartPages = StartPage.getValue(); 
        var EndPages = EndPage.getValue();        
        var IFs = IF.getValue(); 
        var PageCharge = PageChargeField.getValue();
        var InvoiceCodes = InvoiceCodeField.getValue();  //��С��
        var InvoiceNos = InvoiceNoField.getValue();
        var CompleteUnit = CompleteUnitField.getValue();
        var ESICited = ESICitedField.getValue();
        
        var RecordTypes = eRecordTypeField.getValue();//����¼���ݿ�
        var UnitMoneys = UnitMoneyField.getValue(); //���ҵ�λ
        
        var Types = eTypeCombox.getValue(); //xm20150311
		
		if(eTypeCombox.getRawValue()=="")
		{
		Ext.Msg.show({title:'����',msg:'���Ͳ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}
		if(YearField.getRawValue()=="")
		{
		Ext.Msg.show({title:'����',msg:'��Ȳ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}
        if(((+StartPages)>(+EndPages))&(StartPages!="")&(EndPages!=""))
        {
        	Ext.Msg.show({title:'����',msg:'��ֹҳ��д����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
        }
        if(Title.getRawValue()=="")
        {
        	Ext.Msg.show({title:'����',msg:'������Ŀ����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
        }
        if(eJNameField.getRawValue()=="")
         {
        	Ext.Msg.show({title:'����',msg:'�ڿ����Ʋ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
        }
        if(eRecordTypeField.getRawValue()=="")
		{
		Ext.Msg.show({title:'����',msg:'����¼���ݿⲻ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}
		if(allauthorinfo=="")
		{
			Ext.Msg.show({title:'����',msg:'�������߲���ȫ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	return;
		}
				if(formPanel.form.isValid()){
			   Ext.Ajax.request({
					url: projUrl+'?action=update&rowid='+editRowid+'&Titles='+encodeURIComponent(Titles)+'&FristAuthors='+encodeURIComponent(FristAuthors)
					+'&AuthorsInfo='+encodeURIComponent(allauthorinfo)+'&CorrAuthors='+encodeURIComponent(CorrAuthors)+'&CorrAuthorsInfo='+encodeURIComponent(allcorrauthorinfo)
					+'&PubYear='+encodeURIComponent(YearFields)+'&Rolls='+encodeURIComponent(Rolls)+'&Periods='+encodeURIComponent(Periods)+'&StartPages='+encodeURIComponent(StartPages)
					+'&EndPages='+encodeURIComponent(EndPages)+'&IFs='+encodeURIComponent(IFs)+'&JNameDr='+encodeURIComponent(JNameDr)+'&PageCharge='+PageCharge
					+'&PaperType='+encodeURIComponent(EnPaperTypes)+'&InvoiceCode='+encodeURIComponent(InvoiceCodes)+'&InvoiceNo='+encodeURIComponent(InvoiceNos)+'&CompleteUnit='+encodeURIComponent(CompleteUnit)+'&ESICited='+encodeURIComponent(ESICited)+'&RecordTypes='+encodeURIComponent(RecordTypes)+'&UnitMoneys='+encodeURIComponent(UnitMoneys)+'&Type='+encodeURIComponent(Types)+'&PrjDr='+encodeURIComponent(PrjDr)+'&OutPrjName='+encodeURIComponent(OutPrjName),
						waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );	
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!���ٴβ�ѯ�鿴�޸Ľ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});									
									editwin.close();
									
									var data = ''+"|"+''+"|"+''+"|"+''+"|"+''+"|"+''+"|"+''+"|"+userdr 
									itemGrid.load({params:{data:data,sortField:'', sortDir:'',start:0,limit:25}});  //20151221 hiddin 
								}
								else
								{	
									//RepTitles
									var message = "";
									if(jsonData.info=='RepTitles') message='���������ظ�!';
							    Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							    if(jsonData.info=='RepInvoice') message='��Ʊ��Ϣ�ظ�!';
							    Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
						
						}else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ���󱣴档',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					} 
					editwin.close();
			}
			
			editButton.addListener('click',editHandler,false);
	
			cancelButton = new Ext.Toolbar.Button({
				text:'�ر�',
				iconCls : 'cancel'
			});
			
			cancelHandler = function(){
				editwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			editwin = new Ext.Window({
				title: '�޸����ı����뽱����Ϣ',
				iconCls: 'pencil',
				width: 620,
				height: 620,
				//autoHeight: true,
				layout: 'fit',
				plain:true,
				modal:true,
				//bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: formPanel,
				buttons: [
					editButton,
					cancelButton
				]
			});		
			editwin.show();			

		}
			
				
	
	


