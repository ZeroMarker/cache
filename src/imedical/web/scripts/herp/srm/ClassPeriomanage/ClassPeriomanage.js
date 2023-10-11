var itemGridUrl = '../csp/herp.srm.classperiomanagemain.csp';

//�������Դ

var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'Year',
		'YearName',
		'Class',
		'ClassName',
		'Perion',
		'PerionName',
		'Level',
		'LevelName',
        'influence',
        'IsValid',
        'IsCHJ'
	]),
    remoteSort: true
});


Ext.ns("dhc.herp");

dhc.herp.PageSizePlugin = function() {
	dhc.herp.PageSizePlugin.superclass.constructor.call(this, {
				store : new Ext.data.SimpleStore({
							fields : ['text', 'value'],
							data : [['10', 10], ['20', 20], ['30', 30],
									['50', 50], ['100', 100]]
						}),
				mode : 'local',
				displayField : 'text',
				valueField : 'value',
				editable : false,
				allowBlank : false,
				triggerAction : 'all',
				width : 40
			});
};

Ext.extend(dhc.herp.PageSizePlugin, Ext.form.ComboBox, {
			init : function(paging) {
				paging.on('render', this.onInitView, this);
			},

			onInitView : function(paging) {
				paging.add('-', this, '-');
				this.setValue(paging.pageSize);
				this.on('select', this.onPageSizeChanged, paging);
			},

			onPageSizeChanged : function(combo) {
				this.pageSize = parseInt(combo.getValue());
				this.doLoad(0);
			}
		});
	
var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: itemGridDs,
	plugins : new dhc.herp.PageSizePlugin(),
	atLoad : true,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"//,

});
//����Ĭ�������ֶκ�������
//itemGridDs.setDefaultSort('rowid', 'name');

//���ݿ�����ģ��
var itemGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
	    id:'rowid',
    	header: 'id',
        dataIndex: 'rowid',
        width: 180,		  
        hidden: true,
        sortable: true
	    
    },{ 
        id:'Year',
    	header: '���',
        dataIndex: 'Year',
        width: 180,	
        hidden:true  
        //sortable: true
    },
    { 
        id:'YearName',
    	header: '���',
        dataIndex: 'YearName',
        width: 80	  
        //sortable: true
    },{
        id:'Class',
    	header: '�ڿ����',
        dataIndex: 'Class',
        width: 180,
        hidden:true
        //sortable: true
    },
    {
        id:'ClassName',
    	header: '�ڿ����',
        dataIndex: 'ClassName',
        width: 180,
		hidden:true,
        sortable: true
    },{
        id:'LevelName',
    	header: '�ڿ�����',
        dataIndex: 'LevelName',
        width: 100
        //sortable: true
    },{           
         id:'Perion',
         header: '�ڿ�',
         allowBlank: true,
         width:180,
         dataIndex: 'Perion',
         hidden: true
    
    },{           
         id:'PerionName',
         header: '�ڿ�',
         allowBlank: true,
         width:180,    
         dataIndex: 'PerionName'
    
    },{           
         id:'influence',
         header: 'Ӱ������',
         allowBlank: true,
         width:100,
         align:'right',
         //xtype:'numbercolumn',
         dataIndex: 'influence',
         renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 } 
    }/* ,{           
         id:'IsCHJ',
         header: '�Ƿ�Ϊ�л��ڿ�',
         allowBlank: true,
         width:100,
         align:'left',
         dataIndex: 'IsCHJ'   
    } */
    
]);

//��ʼ��Ĭ��������
//itemGridCm.defaultSortable = true;


//��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text: '����',
    //tooltip:'����',        
    iconCls:'edit_add',
	handler:function(){
	
	
//��ȡ���

var YearDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.classperiomanagemain.csp'+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('YearField').getRawValue()),method:'POST'});
});

var YearField1 = new Ext.form.ComboBox({
	id: 'YearField1',
	fieldLabel: '���',
	width:200,
	listWidth : 250,
	//allowBlank:true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'typeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});


 var ClassStore1 = new Ext.data.Store({
         //autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
              });
ClassStore1.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:itemGridUrl+'?action=GetJournalTypes&str='+encodeURIComponent(Ext.getCmp('ClassField1').getRawValue()),method:'POST'});
});
var ClassField1 = new Ext.form.ComboBox({
	        id: 'ClassField1',
	        fieldLabel: '�ڿ�����',
	        width:200,
	        listWidth : 250,
	        selectOnFocus: true,
	        //allowBlank: false,
	        store:ClassStore1,
	        disabled:true,
	        //anchor: '90%',
	        valueNotFoundText:'',
	        displayField: 'name',
	        valueField: 'rowid',
	       triggerAction: 'all',
	       //emptyText:'��ѡ���ڿ����...',
	       name: 'ClassField1',
	       minChars: 1,
	       pageSize: 10,
	       selectOnFocus:true,
	       forceSelection:'true',
	       editable:true,
	       labelSeparator:''
});


var PerionDs1 = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


PerionDs1.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.classperiomanagemain.csp'+'?action=GetPerion&str='+encodeURIComponent(Ext.getCmp('PerionField1').getRawValue()),method:'POST'});
});

var PerionField1 = new Ext.form.ComboBox({
	id: 'PerionField1',
	fieldLabel: '�ڿ�',
	width:200,
	listWidth : 250,
	//allowBlank: false,
	store:PerionDs1,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ����ڿ�...',
	name: 'PerionField1',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});
var LevelDs1 = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


LevelDs1.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.classperiomanagemain.csp'+'?action=GetJLevel&str='+encodeURIComponent(Ext.getCmp('LevelField1').getRawValue()),method:'POST'});
});

var LevelField1 = new Ext.form.ComboBox({
	id: 'LevelField1',
	fieldLabel: '�ڿ�����',
	width:200,
	listWidth : 250,
	//allowBlank: false,
	store:LevelDs1,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ����ڿ�����...',
	name: 'LevelField1',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});


		var nField = new Ext.form.NumberField({
			id:'nField',
			name:'nField',
			fieldLabel: 'Ӱ������',
			allowBlank: true,
			width:200,
			listWidth : 120,
            regex :/(^[0-9]$|^[0-9]+[0-9]+$|^[0-9]+[.][0-9]+$)/,
			regexText:"����д����!",
			//emptyText:'ֻ����������...',
			//anchor: '70%',
			selectOnFocus:'true',
			editable:true,
			decimalPrecision : 3,
			labelSeparator:''
			
		});
	
	/**
	var IF = new Ext.form.NumberField({
				id:'IF',
				fieldLabel: 'Ӱ������',
				width:180,
				//regex:/[0-9]*[1-9][0-9]*$/,
				regex:/^\d+(\.\d+)?$/,
				regexText:"����д����!",
				allowBlank : true, 
				disabled:false,
				anchor: '95%',
				name:'IF',
				selectOnFocus:'true',
				editable:true
								
});
	**/
	
	var IsCHJDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['Y', '��'],['N', '��']]
	});		
		
var IsCHJCombox = new Ext.form.ComboBox({
	                   id : 'IsCHJCombox',
		           fieldLabel :'�Ƿ�Ϊ�л��ڿ�',
	                  width:200,
	                  listWidth : 200,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : IsCHJDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           //value:'1',
		           triggerAction : 'all',
		           //emptyText : '��������ʱ�Ƿ�Ϊ��Ժ��Ա',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
		           labelSeparator:''
						  });

		//��ʼ�����
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			//labelAlign: 'right',
			items: [
                                YearField1,
                                //ClassField1,
                                LevelField1,
                                PerionField1,
				                nField
				                //IsCHJCombox
				
			]
		});
		//aField.setDisabled(true);   
		//��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
			text:'����',
			iconCls : 'save'
		});
		
		//������Ӱ�ť��Ӧ����
		addHandler = function(){
            //alert("wwww")
			var Year     = YearField1.getValue();
			//alert(Year);
			var Class    = ClassField1.getValue();
			var Perion   = PerionField1.getValue();
			var Level = LevelField1.getValue();
            var influence= nField.getValue();
            
             var IsCHJ= IsCHJCombox.getValue();


			if(Year==""){
				Ext.Msg.show({title:'����',msg:'��Ȳ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(Level ==""){
				Ext.Msg.show({title:'����',msg:'�ڿ�������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}	
			if(Perion ==""){
				Ext.Msg.show({title:'����',msg:'�ڿ�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}			
			//encodeURI
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.srm.classperiomanagemain.csp?action=add&Year='+Year+'&Class='+Class+'&Perion='+Perion+'&Level='+Level+'&influence='+influence+'&IsCHJ='+IsCHJ),
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){YearField1.focus();};
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){YearField1.focus();};
						Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						//addwin.close();
					}
					else
							{
							   var message = "";
					           message = "SQLErr: " + jsonData.info;
					           if (jsonData.info == 'RepJournal')
						       message = '������ڿ������ظ�';
                                
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
				},
				scope: this
			});
			addwin.close();
		};
	
		//��ӱ��水ť�ļ����¼�
		addButton.addListener('click',addHandler,false);
	
		//��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
			text:'�ر�',
			iconCls : 'cancel'
		});
	
		//����ȡ����ť����Ӧ����
		cancelHandler = function(){
			addwin.close();
		};
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//��ʼ������
		addwin = new Ext.Window({
			title: '���������ڿ���Ϣ',
			iconCls: 'edit_add',
			width: 350,
			height:250,
			minWidth: 350, 
			minHeight: 250,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});
	
		//������ʾ
		addwin.show();
	}	
});



//�޸İ�ť
var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
    tooltip:'�޸�',        
    iconCls: 'pencil',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
                
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{	
			var rowid = rowObj[0].get("rowid");
			var yearbf = rowObj[0].get("Year");
			var levelbf = rowObj[0].get("Level");
			var journaldrbf = rowObj[0].get("Perion");
		}
	
	//��ȡ���

		var YearDs = new Ext.data.Store({
			//autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
		});
		
		
		YearDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
			url:'herp.srm.classperiomanagemain.csp?action=GetYear',method:'POST'});
		});
		
		var YearField1 = new Ext.form.ComboBox({
			id: 'YearField1',
			fieldLabel: '���',
			width:200,
			listWidth : 250,
			//allowBlank:true,
			store:YearDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			//emptyText:'��ѡ�����...',
			name: 'typeField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:'true',
			forceSelection:'true',
			editable:true,
			value:yearbf,
			labelSeparator:''
		});
			/* YearField1.on('select',function(combo, record, index){
		    tmpYear = combo.getValue(); 
	});
		*/	
	    
var ClassStore1 = new Ext.data.Store({
         //autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
              });
ClassStore1.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:itemGridUrl+'?action=GetJournalTypes',method:'POST'});
});
var ClassField1 = new Ext.form.ComboBox({
	        id: 'ClassField1',
	        fieldLabel: '�ڿ�����',
	        width:200,
	        listWidth : 250,
	        selectOnFocus: true,
	        //allowBlank: false,
	        store:ClassStore1,
	        //anchor: '90%',
	        valueNotFoundText:'',
	         disabled:true,
	        displayField: 'name',
	        valueField: 'rowid',
	       triggerAction: 'all',
	       //emptyText:'��ѡ���ڿ����...',
	       name: 'ClassField1',
	       minChars: 1,
	       pageSize: 10,
	       selectOnFocus:true,
	       forceSelection:'true',
	       editable:true,
	       labelSeparator:''
});


	/* ClassField1.on('select',function(combo, record, index){
		    tmpClass = combo.getValue();
		}); */
               
		var PerionDs1 = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
		});
		
		
PerionDs1.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.classperiomanagemain.csp'+'?action=GetPerion&str='+encodeURIComponent(Ext.getCmp('PerionField1').getRawValue()),method:'POST'});
});
		
		var PerionField1 = new Ext.form.ComboBox({
			id: 'PerionField1',
			fieldLabel: '�ڿ�',
			width:200,
			listWidth : 250,
			//allowBlank: false,
			store:PerionDs1,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
		    value:'',
			//emptyText:'��ѡ����ڿ�...',
			name: 'PerionField1',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:'true',
			forceSelection:'true',
			editable:true,
			value:journaldrbf,
			labelSeparator:''
		});
		
		/* PerionField1.on('select',function(combo, record, index){
		    tmpPerion = combo.getValue();
			}); */
			
var LevelDs1 = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


LevelDs1.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.classperiomanagemain.csp'+'?action=GetJLevel&str='+encodeURIComponent(Ext.getCmp('LevelField1').getRawValue()),method:'POST'});
});

var LevelField1 = new Ext.form.ComboBox({
	id: 'LevelField1',
	fieldLabel: '�ڿ�����',
	width:200,
	listWidth : 250,
	//allowBlank: false,
	store:LevelDs1,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ����ڿ�����...',
	name: 'LevelField1',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	value:levelbf,
	editable:true,
	labelSeparator:''
});

		var InfluField = new Ext.form.NumberField({
			id:'nField',
			fieldLabel: 'Ӱ������',
			allowBlank: true,
			width:200,
			listWidth : 200,
            regex :/(^[0-9]$|^[0-9]+[0-9]+$|^[0-9]+[.][0-9]+$)/,
			//emptyText:'ֻ����������...',
			//anchor: '70%',
			selectOnFocus:'true',
			decimalPrecision : 3,
			labelSeparator:''
			
		});
		  

var IsCHJDs1 = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['Y', '��'],['N', '��']]
	});		
		
var IsCHJCombox1 = new Ext.form.ComboBox({
	                   id : 'IsCHJCombox1',
		           fieldLabel :'�Ƿ�Ϊ�л��ڿ�',
	                  width:200,
	                  listWidth : 200,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : IsCHJDs1,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           //value:'1',
		           triggerAction : 'all',
		           //emptyText : '��������ʱ�Ƿ�Ϊ��Ժ��Ա',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
		           labelSeparator:''
						  });


		//��ʼ�����
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			//labelAlign: 'right',
			items: [
                                YearField1,
                                //ClassField1,
                                LevelField1,
                                PerionField1,
				                InfluField
				                //IsCHJCombox1 
			]
		});
	
		//������
             
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			YearField1.setRawValue(rowObj[0].get("YearName"));
			ClassField1.setRawValue(rowObj[0].get("ClassName"));	
			LevelField1.setRawValue(rowObj[0].get("LevelName"));
			PerionField1.setRawValue(rowObj[0].get("PerionName"));
			InfluField.setValue(rowObj[0].get("influence"));
			IsCHJCombox1.setValue(rowObj[0].get("IsCHJ"));
		});
		
//���岢��ʼ�������޸İ�ť
   var editButton = new Ext.Toolbar.Button({
			text:'����',
			iconCls: 'save'

		});
	
		//�����޸İ�ť��Ӧ����
		editHandler = function(){

            var rowObj=itemGrid.getSelectionModel().getSelections();
            var rowid = rowObj[0].get("rowid");   
			var Year     = YearField1.getValue();
			var Class     = ClassField1.getValue();
			var Level     = LevelField1.getValue();
			var Perion     = PerionField1.getValue();
            var influence= InfluField.getValue();
            
            var ischj= IsCHJCombox1.getValue();
			
			/*
             var year=rowObj[0].get("rowid"); 
             var classname=rowObj[0].get("ClassName");
             var levelname=rowObj[0].get("LevelName");
             var perionname=rowObj[0].get("PerionName");
             var influences=rowObj[0].get("influence");
             
             var ischjs=rowObj[0].get("IsCHJ");
             
             if (year==Year){Year=""}
             if (classname==Class){Class=""}
             if (classname==Level){Level=""}
             if (perionname==Perion){Perion=""}
             if (influences==influence){influence=""}
             
             if (ischjs==ischj){ischj=""}
             */
			if(Year==""){
				Ext.Msg.show({title:'����',msg:'��Ȳ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(Level ==""){
				Ext.Msg.show({title:'����',msg:'�ڿ�������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}	
			if(Perion ==""){
				Ext.Msg.show({title:'����',msg:'�ڿ�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}	
			
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.srm.classperiomanagemain.csp?action=editd&rowid='+rowid+'&Year='+Year+'&Class='+Class+'&Perion='+Perion+'&Level='+Level+'&influence='+influence+'&IsCHJ='+ischj),
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){activeFlag.focus();};
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				
				},
				
				success: function(result, request){
				   	var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){YearField1.focus();};
						Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
						itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						
					}
					else
						{
							var message = "";
					        message = "SQLErr: " + jsonData.info;
					        if (jsonData.info == 'RepJournal')
						    message = '���ڿ������Ѵ��ڣ�';
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
				},
				scope: this
			});
			editwin.close();
		};
	
		//��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click',editHandler,false);
	
		//���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'�ر�',
			iconCls : 'cancel'
		});
	
		//����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			editwin.close();
		};
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//���岢��ʼ������
		var editwin = new Ext.Window({
			title: '�޸ķ����ڿ���Ϣ',
			iconCls: 'pencil',
			width: 400,
			height:250,
			minWidth: 400, 
			minHeight: 250,
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
	
		//������ʾ
		editwin.show();
	}
});


///ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
   // tooltip:'ɾ��',       
    id:'delButton', 
    iconCls:'edit_remove',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			//alert(rowid);
		}
		function handler(id){
			if(id=="yes"){
			
				  Ext.each(rowObj, function(record) {
				  if (Ext.isEmpty(record.get("rowid"))) {
				  itemGrid.getStore().remove(record);
				  return;}
					Ext.Ajax.request({
						url:'herp.srm.classperiomanagemain.csp?action=del&rowid='+rowid,
						waitMsg:'ɾ����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
								//detailGrid.load({params:{start:0, limit:20,checkmainid:rowid}});
							}else{
								Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				});
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��������¼��?',handler);
	}
});




//��ȡ�ڿ�

var PerionDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


PerionDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.classperiomanagemain.csp'+'?action=GetPerion&str='+encodeURIComponent(Ext.getCmp('PerionField').getRawValue()),method:'POST'});
});

var PerionField = new Ext.form.ComboBox({
	id: 'PerionField',
	fieldLabel: '�ڿ�',
	width:120,
	listWidth : 250,
	//allowBlank: false,
	store:PerionDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ����ڿ�...',
	name: 'PerionField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});




//��ȡ���

var YearDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.classperiomanagemain.csp'+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('YearField').getRawValue()),method:'POST'});
});

var YearField = new Ext.form.ComboBox({
	id: 'YearField',
	fieldLabel: '���',
	width:120,
	listWidth : 250,
	allowBlank:true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ�����...',
	name: 'typeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});



//�ڿ����

var ClassStore = new Ext.data.Store({
         //autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
              });
ClassStore.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:itemGridUrl+'?action=GetJournalTypes&str='+encodeURIComponent(Ext.getCmp('ClassField').getRawValue()),method:'POST'});
});
var ClassField = new Ext.form.ComboBox({
	        id: 'ClassField',
	        fieldLabel: '�ڿ�����',
	        width:120,
	        listWidth : 250,
	        selectOnFocus: true,
	        allowBlank: false,
	        store:ClassStore,
	        //anchor: '90%',
	        valueNotFoundText:'',
	        displayField: 'name',
	        valueField: 'rowid',
	       
	       triggerAction: 'all',
	       //emptyText:'��ѡ���ڿ����...',
	       name: 'ClassField',
	       minChars: 1,
	       pageSize: 10,
	       selectOnFocus:true,
	       forceSelection:'true',
	       editable:true
});

var LevelDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


LevelDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.classperiomanagemain.csp'+'?action=GetJLevel&str='+encodeURIComponent(Ext.getCmp('LevelField').getRawValue()),method:'POST'});
});

var LevelField = new Ext.form.ComboBox({
	id: 'LevelField',
	fieldLabel: '�ڿ�����',
	width:120,
	listWidth : 250,
	//allowBlank: false,
	store:LevelDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ����ڿ�����...',
	name: 'LevelField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});





var SearchButton = new Ext.Toolbar.Button({
        text: '��ѯ', 
        tooltip:'��ѯ',        
        iconCls:'search',
	handler:function(){	
	var Year  = YearField.getValue();
        var Class = ClassField.getValue();
        var Perion= PerionField.getValue();
      var Level = LevelField.getValue();
	//itemGridDs.load(({params:{start:0,limit:25,Year:Year,Class:Class,Perion:Perion,Level:Level}}));
	itemGridDs.proxy = new Ext.data.HttpProxy({
	    	
								url : itemGridUrl+'?action=list&Year='+ encodeURIComponent(Year)+ 
								'&Class='+encodeURIComponent(Class)+
								'&Perion='+ encodeURIComponent(Perion)+
								'&Level='+ encodeURIComponent(Level),
								
								method : 'GET'
								//'&type='+ userTypeField.getValue()
							});
					itemGridDs.load({
								params : {
									start : 0,
									limit : 25,
									sortDir:'',
									sortField:''
								}
							});
	
	}
});


//���
var itemGrid = new Ext.grid.GridPanel({
	title: '�ڿ�������Ϣά��',
	iconCls: 'list',
    region: 'center',
    layout:'fit',
    width:400,
    readerModel:'local',
    url: 'herp.srm.classperiomanagemain.csp',
    atLoad : true, // �Ƿ��Զ�ˢ��
	store: itemGridDs,
	cm: itemGridCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	//tbar:['���:','-',YearField,'-','�ڿ����:','-',ClassField,'-','�ڿ�����:','-',LevelField,'�ڿ�����:','-',PerionField ,'-',SearchButton,'-',addButton,'-',editButton,'-',delButton],
	tbar:['','���','',YearField,'','�ڿ�����','',LevelField,'','�ڿ�����','',PerionField,'-',SearchButton,'-',addButton,'-',editButton,'-',delButton],
	bbar:itemGridPagingToolbar
});
itemGridDs.load({params:{start:0, limit:25}});



	

