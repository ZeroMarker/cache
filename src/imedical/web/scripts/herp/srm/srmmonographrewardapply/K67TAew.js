
srmmonographAddFun = function() {

	var NameField = new Ext.form.TextField({
		id: 'Name',
		fieldLabel: 'ר������',
		width:200,
		allowBlank: false,
		listWidth : 200,
		triggerAction: 'all',
		emptyText:'',
		name: 'Name',
		minChars: 1,
		pageSize: 10,
		editable:true
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
		              
		               url: itemGridUrl
		                     + '?action=TypeList&str='
		                     + encodeURIComponent(Ext.getCmp('unittypeField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var unittypeField = new Ext.form.ComboBox({
			id: 'unittypeField',
			fieldLabel: '�������',
			width:200,
			listWidth : 250,
			allowBlank: true,
			store: unittypeDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '��ѡ���������...',
			name: 'unittypeField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true
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
		               url: itemGridUrl
		                     + '?action=deptList&str='
		                     + encodeURIComponent(Ext.getCmp('unitdeptField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var unitdeptField = new Ext.form.ComboBox({
			id: 'unitdeptField',
			fieldLabel: '��������',
			width:200,
			listWidth : 250,
			allowBlank: false,
			store: unitdeptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '��ѡ���������...',
			name: 'unitdeptField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true
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
	width:200,
	//anchor: '95%',
	listWidth : 200,
	allowBlank: true,
	store:EditorTypeStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	emptyText:'��ѡ��������������...',
	mode : 'local',
	name: 'EditorTypeField',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	listeners:{"select":function(combo,record,index){ 
				   	    if(EditorTypeField.getValue()=='3')
                        {
						  BookAuthorRangeCombox.setValue("");
						  BookAuthorRangeCombox.setRawValue("");
						  //BookAuthorRangeCombox.disabled();
						  BookAuthorRangeCombox.disabled=true;
						}else{
						  BookAuthorRangeCombox.disabled=false;
						}						
			        }} 
});

//��������
	var unituserDs = new Ext.data.Store({
			autoLoad : true,
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
			width:200,
			listWidth :250,
			//allowBlank: false,
			store: unituserDs,
			valueField: 'rowid',
			hideOnSelect:false,
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'��ѡ����Ա����...',
			name: 'unituserField',
			minChars: 1,
			pageSize: 10,
			hideOnSelect:false,
			forceSelection : true,
			selectOnFocus:true
	});
///////////////////����λ��/////////////////////////////  
var BookAuthorRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��һ'],['2', '�ڶ�'], ['3', '����'], ['4', '����'], ['5', '����'],['6', '����'],['7', '����'],['8', '�ڰ�']]
	});		
		
var BookAuthorRangeCombox = new Ext.form.ComboBox({
	                   id : 'BookAuthorRangeCombox',
		           fieldLabel : '����λ��',
	                   width : 200,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : BookAuthorRangeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : false,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true
						  });	
///////////////////���������Ƿ�Ժ/////////////////////////////  
var BookIsTheHosDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '��'],['0', '��']]
	});		
		
var BookIsTheHosCombox = new Ext.form.ComboBox({
	                   id : 'BookIsTheHosCombox',
		           fieldLabel : '�Ƿ�Ժ',
	                   width : 200,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : BookIsTheHosDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           value:'1',
		           selectOnFocus : true,
		           forceSelection : true
						  });	
	
	
var InventorsGrid = new Ext.grid.GridPanel({
        fieldLabel:'��������',
		id:'InventorsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.MemoryProxy(),
		/*proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmpatentapplyexe.csp'+'?action=InventorID&start='+0+'&limit='+25+'&InventorsIDs='+InventorsIDs,
		method:'POST'}),*/
		reader: new Ext.data.ArrayReader({}, [ 
		   {name:'typerowid'}, 
		   {name: 'typename'},
			 {name: 'rowid'},  
			 {name: 'name'},
			 {name: 'rangerowid'},  
			 {name: 'rangename'},
			 {name: 'isthehosrowid'},  
			 {name: 'isthehos'}
         ])  
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
            {id: 'isthehosrowid', header: '�Ƿ�ԺID', width: 100,dataIndex: 'isthehosrowid',hidden:true},
            {header: '�Ƿ�Ժ', dataIndex: 'isthehos',align:'center',width: 80}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 200,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});
var rawValue="";
///////////////��Ӷ�������˰�ť////////////////
var addInventors  = new Ext.Button({
		text: '���',
		handler: function(){
			var InventorId;
			var BookAuthorRangeId;
			var BookAuthorTypeId;
			var IsTheHosId;
			
			var id = Ext.getCmp('unituserField').getValue();
			var typeid = Ext.getCmp('EditorTypeField').getValue();
			var rangeid = Ext.getCmp('BookAuthorRangeCombox').getValue();
			var isthehosid = Ext.getCmp('BookIsTheHosCombox').getValue();
			
			var InventorName = Ext.getCmp('unituserField').getRawValue();
			var BookAuthorTypeName = Ext.getCmp('EditorTypeField').getRawValue();
			var BookAuthorRange = Ext.getCmp('BookAuthorRangeCombox').getRawValue();
			var BookIsTheHos = Ext.getCmp('BookIsTheHosCombox').getRawValue();
			
			var total = InventorsGrid.getStore().getCount();
			if(total>0){	
				for(var i=0;i<total;i++){
					var erow = InventorsGrid.getStore().getAt(i).get('rowid');
					var tmprange = InventorsGrid.getStore().getAt(i).get('rangename');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ����ͬһ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
							if((tmprange!="")&(BookAuthorRange!="")&(tmprange==BookAuthorRange))
							{
								//alert("tmprange:"+tmprange+"BookAuthorRange:"+BookAuthorRange);
								Ext.Msg.show({title:'����',msg:'��ͬ������������ѡ������ͬ��λ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							  return;
							}
							else{
						    InventorId=id;
						    BookAuthorTypeId=typeid;
						    IsTheHosId=isthehosid;
						    BookAuthorRangeId=rangeid;
						    //alert("BookAuthorRangeId2:"+BookAuthorRangeId);
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
				}else{
					InventorId=id;
					BookAuthorTypeId=typeid;
					IsTheHosId=isthehosid;
					BookAuthorRangeId=rangeid;
					//alert("BookAuthorRangeId1:"+BookAuthorRangeId);
				}	
			}
			var data = new Ext.data.Record({'typerowid':BookAuthorTypeId,'typename':BookAuthorTypeName,'rowid':InventorId,'name':InventorName,'rangerowid':BookAuthorRangeId,'rangename':BookAuthorRange,'isthehosrowid':IsTheHosId,'isthehos':BookIsTheHos});
			InventorsGrid.stopEditing(); 
			InventorsGrid.getStore().insert(total,data);
//			alert("total:"+total);
//			if(total>0){
//				rawValue = InventorsGrid.getStore().getAt(0).get('typerowid');
//				alert("rawValue(0):"+rawValue);
//				for(var i=1;i<total;i++){
//				  var row = InventorsGrid.getStore().getAt(i).get('typerowid');//ÿ�ж���rowid��ֵ
//				  rawValue = rawValue+","+row;
//				}
//			}
//			alert("rawValue:"+rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delInventors = new Ext.Button({
		text:'ɾ��',
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
	var TotalNum = new Ext.form.NumberField({
		id: 'TotalNum',
		fieldLabel: '��������ǧ�֣�',
		width:200,
		allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'TotalNum',
		minChars: 1,
		pageSize: 10,
		editable:true
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
	               url: itemGridUrl
	                     + '?action=pressList&str='
	                     + encodeURIComponent(Ext.getCmp('PressField').getRawValue()),
	               method:'POST'
	              });
	});

var PressField = new Ext.form.ComboBox({
		id: 'PressField',
		fieldLabel: '������',
		width:200,
		listWidth : 250,
		allowBlank: false,
		store: PressDs,
		displayField: 'name',
		valueField: 'rowid',
		triggerAction: 'all',
		typeAhead : true,
		triggerAction : 'all',
		emptyText : '��ѡ�������...',
		name: 'PressField',
		pageSize: 10,
		minChars: 1,
		forceSelection : true,
		selectOnFocus:true,
	    editable:true,
	    listeners : {
				       select:{
                     fn:function(combo,record,index) { 
                     Ext.Ajax.request({			        
                     url: itemGridUrl+'?action=PressLevelList&pressdr='+PressField.getValue(),	
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
						         if (jsonData.success=='true'){
							         var data = jsonData.info;							         
                       PressLevel.setValue(data);          
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
		width:200,
		emptyText : '',
		editable:false,
		name: 'PressLevel',
		selectOnFocus : true
	});
	
	var PubTime = new Ext.form.DateField({
		id : 'PubTime',
		fieldLabel:'��������',
		format : 'Y-m-d',
		width : 200,
		//allowBlank : false,
		emptyText : ''
	});
	
	var ISBN = new Ext.form.TextField({
		id: 'ISBN',
		fieldLabel: 'ISBN��',
		width:200,
		allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'ISBN',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
	var PublishFreqField = new Ext.form.NumberField({
		id: 'PublishFreq',
		fieldLabel: '������',
		width:200,
		allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'TotalNum',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
/////////////////��Ժ��λλ��///////////////////////////
var CompleteUnitStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','��һ��ɵ�λ'],['2','�ڶ���ɵ�λ'],['3','������ɵ�λ'],['4','������ɵ�λ'],['5','������ɵ�λ'],['6','������ɵ�λ'],['7','������ɵ�λ'],['8','�ڰ���ɵ�λ']]
});

var CompleteUnitField = new Ext.form.ComboBox({
	id: 'CompleteUnitField',
	fieldLabel: '��Ժ��λλ��',
	width:200,
	//anchor: '95%',
	listWidth : 200,
	allowBlank: true,
	store:CompleteUnitStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	emptyText:'��ѡ����Ժ��λλ��...',
	mode : 'local',
	disabled:true,
	name: 'CompleteUnitField',
	minChars: 1,
	disabled:true,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
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
					{
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						},
					   NameField,unittypeField,
					   //unitdeptField,
					   InventorsGrid,EditorTypeField,unituserField,BookAuthorRangeCombox,BookIsTheHosCombox,
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
					{
							xtype : 'displayfield',
							value : '',
							columnWidth : .1
						},
						TotalNum,PressField,PressLevel,PubTime,ISBN,PublishFreqField,CompleteUnitField									
					]
				 }]
		}
	]		
	// create form panel
  var formPanel = new Ext.form.FormPanel({
    labelWidth: 60,
	frame: true,
    items: colItems
	});
	
	
	var allauthorinfo="";
	var addWin = new Ext.Window({
		    
			title : '���',
			width :600,
			height : 420,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '����',
				handler : function() {
					if (formPanel.form.isValid()) {
						var name = NameField.getValue();
						var typedr = unittypeField.getValue();
						//var deptdr = unitdeptField.getValue();
						var deptdr="";
						//var editor = unituserField.getValue();
					    var total = InventorsGrid.getStore().getCount();
						  if(total>0){
							var authortypeid = InventorsGrid.getStore().getAt(0).get('typerowid');
							var authorid = InventorsGrid.getStore().getAt(0).get('rowid');
				      var authorrangeid = InventorsGrid.getStore().getAt(0).get('rangerowid');
				      var authoristhehosid = InventorsGrid.getStore().getAt(0).get('isthehosrowid');
				      allauthorinfo = authortypeid+"-"+authorid+"-"+authorrangeid+"-"+authoristhehosid;
				      //alert(allauthorinfo);
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
			   
			      //alert(allauthorinfo);
					  var editor = allauthorinfo;
						var totalnum = TotalNum.getValue();
						var press = PressField.getValue();
						var pubtime = PubTime.getValue();
						var isbn = ISBN.getValue();
						var publishfreq = PublishFreqField.getValue();
						//var completeunit = CompleteUnitField.getValue();
						var completeunit = "";
						if (pubtime!==""){
							pubtime=pubtime.format ('Y-m-d');
						}
						
//					if(idnum!=""){
//						if (!/(^\d{18}$)|(^\d{17}(\d|X)$)/.test(idnum)){Ext.Msg.show({title:'����',msg:'���֤�Ÿ�ʽ����ȷ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
//						}
//					    if(phone!=""){
//						if (!/[0-9]/.test(phone)){Ext.Msg.show({title:'����',msg:'�绰����ֻ��λ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
//					    }
				Ext.Ajax.request({
					url:'herp.srm.monographrewardapplyexe.csp?action=add&name='+encodeURIComponent(name)+'&typedr='+encodeURIComponent(typedr)+'&deptdr='+encodeURIComponent(deptdr)+'&editor='+editor+'&totalnum='+encodeURIComponent(totalnum)+'&press='+encodeURIComponent(press)+'&pubtime='+encodeURIComponent(pubtime)+'&isbn='+encodeURIComponent(isbn)+'&publishfreq='+publishfreq+'&completeunit='+completeunit+'&subuser='+userdr,
					waitMsg:'������...',
					failure: function(result, request){		
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGrid.load({params:{start:0, limit:25,userdr:userdr}});
						} 
						else
						{
							var message="�ظ����";
							if(jsonData.info=='RepName') message="���������ظ���";
							if(jsonData.info=='RepISDN') message="ISDN�ظ���";
							
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : 'ȡ��',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
