var itemGridUrl = '../csp/herp.srm.classperiomanagemain.csp';

//配件数据源

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
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
//itemGridDs.setDefaultSort('rowid', 'name');

//数据库数据模型
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
    	header: '年度',
        dataIndex: 'Year',
        width: 180,	
        hidden:true  
        //sortable: true
    },
    { 
        id:'YearName',
    	header: '年度',
        dataIndex: 'YearName',
        width: 80	  
        //sortable: true
    },{
        id:'Class',
    	header: '期刊类别',
        dataIndex: 'Class',
        width: 180,
        hidden:true
        //sortable: true
    },
    {
        id:'ClassName',
    	header: '期刊类别',
        dataIndex: 'ClassName',
        width: 180,
		hidden:true,
        sortable: true
    },{
        id:'LevelName',
    	header: '期刊级别',
        dataIndex: 'LevelName',
        width: 100
        //sortable: true
    },{           
         id:'Perion',
         header: '期刊',
         allowBlank: true,
         width:180,
         dataIndex: 'Perion',
         hidden: true
    
    },{           
         id:'PerionName',
         header: '期刊',
         allowBlank: true,
         width:180,    
         dataIndex: 'PerionName'
    
    },{           
         id:'influence',
         header: '影响因子',
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
         header: '是否为中华期刊',
         allowBlank: true,
         width:100,
         align:'left',
         dataIndex: 'IsCHJ'   
    } */
    
]);

//初始化默认排序功能
//itemGridCm.defaultSortable = true;


//添加按钮
var addButton = new Ext.Toolbar.Button({
	text: '新增',
    //tooltip:'增加',        
    iconCls:'edit_add',
	handler:function(){
	
	
//获取年度

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
	fieldLabel: '年度',
	width:200,
	listWidth : 250,
	//allowBlank:true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择年度...',
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
	        fieldLabel: '期刊类型',
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
	       //emptyText:'请选择期刊类别...',
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
	fieldLabel: '期刊',
	width:200,
	listWidth : 250,
	//allowBlank: false,
	store:PerionDs1,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择科期刊...',
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
	fieldLabel: '期刊级别',
	width:200,
	listWidth : 250,
	//allowBlank: false,
	store:LevelDs1,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择科期刊级别...',
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
			fieldLabel: '影响因子',
			allowBlank: true,
			width:200,
			listWidth : 120,
            regex :/(^[0-9]$|^[0-9]+[0-9]+$|^[0-9]+[.][0-9]+$)/,
			regexText:"请填写数字!",
			//emptyText:'只能输入数字...',
			//anchor: '70%',
			selectOnFocus:'true',
			editable:true,
			decimalPrecision : 3,
			labelSeparator:''
			
		});
	
	/**
	var IF = new Ext.form.NumberField({
				id:'IF',
				fieldLabel: '影响因子',
				width:180,
				//regex:/[0-9]*[1-9][0-9]*$/,
				regex:/^\d+(\.\d+)?$/,
				regexText:"请填写数字!",
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
		data : [['Y', '是'],['N', '否']]
	});		
		
var IsCHJCombox = new Ext.form.ComboBox({
	                   id : 'IsCHJCombox',
		           fieldLabel :'是否为中华期刊',
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
		           //emptyText : '发表论文时是否为本院人员',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
		           labelSeparator:''
						  });

		//初始化面板
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
		//初始化添加按钮
		addButton = new Ext.Toolbar.Button({
			text:'保存',
			iconCls : 'save'
		});
		
		//定义添加按钮响应函数
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
				Ext.Msg.show({title:'错误',msg:'年度不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(Level ==""){
				Ext.Msg.show({title:'错误',msg:'期刊级别不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}	
			if(Perion ==""){
				Ext.Msg.show({title:'错误',msg:'期刊不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}			
			//encodeURI
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.srm.classperiomanagemain.csp?action=add&Year='+Year+'&Class='+Class+'&Perion='+Perion+'&Level='+Level+'&influence='+influence+'&IsCHJ='+IsCHJ),
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){YearField1.focus();};
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){YearField1.focus();};
						Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						//addwin.close();
					}
					else
							{
							   var message = "";
					           message = "SQLErr: " + jsonData.info;
					           if (jsonData.info == 'RepJournal')
						       message = '输入的期刊名称重复';
                                
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
				},
				scope: this
			});
			addwin.close();
		};
	
		//添加保存按钮的监听事件
		addButton.addListener('click',addHandler,false);
	
		//初始化取消按钮
		cancelButton = new Ext.Toolbar.Button({
			text:'关闭',
			iconCls : 'cancel'
		});
	
		//定义取消按钮的响应函数
		cancelHandler = function(){
			addwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//初始化窗口
		addwin = new Ext.Window({
			title: '新增分类期刊信息',
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
	
		//窗口显示
		addwin.show();
	}	
});



//修改按钮
var editButton = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改',        
    iconCls: 'pencil',
	handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
                
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{	
			var rowid = rowObj[0].get("rowid");
			var yearbf = rowObj[0].get("Year");
			var levelbf = rowObj[0].get("Level");
			var journaldrbf = rowObj[0].get("Perion");
		}
	
	//获取年度

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
			fieldLabel: '年度',
			width:200,
			listWidth : 250,
			//allowBlank:true,
			store:YearDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			//emptyText:'请选择年度...',
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
	        fieldLabel: '期刊类型',
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
	       //emptyText:'请选择期刊类别...',
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
			fieldLabel: '期刊',
			width:200,
			listWidth : 250,
			//allowBlank: false,
			store:PerionDs1,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
		    value:'',
			//emptyText:'请选择科期刊...',
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
	fieldLabel: '期刊级别',
	width:200,
	listWidth : 250,
	//allowBlank: false,
	store:LevelDs1,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择科期刊级别...',
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
			fieldLabel: '影响因子',
			allowBlank: true,
			width:200,
			listWidth : 200,
            regex :/(^[0-9]$|^[0-9]+[0-9]+$|^[0-9]+[.][0-9]+$)/,
			//emptyText:'只能输入数字...',
			//anchor: '70%',
			selectOnFocus:'true',
			decimalPrecision : 3,
			labelSeparator:''
			
		});
		  

var IsCHJDs1 = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['Y', '是'],['N', '否']]
	});		
		
var IsCHJCombox1 = new Ext.form.ComboBox({
	                   id : 'IsCHJCombox1',
		           fieldLabel :'是否为中华期刊',
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
		           //emptyText : '发表论文时是否为本院人员',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
		           labelSeparator:''
						  });


		//初始化面板
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
	
		//面板加载
             
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			YearField1.setRawValue(rowObj[0].get("YearName"));
			ClassField1.setRawValue(rowObj[0].get("ClassName"));	
			LevelField1.setRawValue(rowObj[0].get("LevelName"));
			PerionField1.setRawValue(rowObj[0].get("PerionName"));
			InfluField.setValue(rowObj[0].get("influence"));
			IsCHJCombox1.setValue(rowObj[0].get("IsCHJ"));
		});
		
//定义并初始化保存修改按钮
   var editButton = new Ext.Toolbar.Button({
			text:'保存',
			iconCls: 'save'

		});
	
		//定义修改按钮响应函数
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
				Ext.Msg.show({title:'错误',msg:'年度不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(Level ==""){
				Ext.Msg.show({title:'错误',msg:'期刊级别不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}	
			if(Perion ==""){
				Ext.Msg.show({title:'错误',msg:'期刊不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}	
			
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.srm.classperiomanagemain.csp?action=editd&rowid='+rowid+'&Year='+Year+'&Class='+Class+'&Perion='+Perion+'&Level='+Level+'&influence='+influence+'&IsCHJ='+ischj),
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){activeFlag.focus();};
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				
				},
				
				success: function(result, request){
				   	var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){YearField1.focus();};
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
						itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						
					}
					else
						{
							var message = "";
					        message = "SQLErr: " + jsonData.info;
					        if (jsonData.info == 'RepJournal')
						    message = '该期刊名称已存在！';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
				},
				scope: this
			});
			editwin.close();
		};
	
		//添加保存修改按钮的监听事件
		editButton.addListener('click',editHandler,false);
	
		//定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
			text:'关闭',
			iconCls : 'cancel'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改分类期刊信息',
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
	
		//窗口显示
		editwin.show();
	}
});


///删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除',
   // tooltip:'删除',       
    id:'delButton', 
    iconCls:'edit_remove',
	handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
								//detailGrid.load({params:{start:0, limit:20,checkmainid:rowid}});
							}else{
								Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				});
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除该条记录吗?',handler);
	}
});




//获取期刊

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
	fieldLabel: '期刊',
	width:120,
	listWidth : 250,
	//allowBlank: false,
	store:PerionDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择科期刊...',
	name: 'PerionField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});




//获取年度

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
	fieldLabel: '年度',
	width:120,
	listWidth : 250,
	allowBlank:true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择年度...',
	name: 'typeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});



//期刊类别

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
	        fieldLabel: '期刊类型',
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
	       //emptyText:'请选择期刊类别...',
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
	fieldLabel: '期刊级别',
	width:120,
	listWidth : 250,
	//allowBlank: false,
	store:LevelDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择科期刊级别...',
	name: 'LevelField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});





var SearchButton = new Ext.Toolbar.Button({
        text: '查询', 
        tooltip:'查询',        
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


//表格
var itemGrid = new Ext.grid.GridPanel({
	title: '期刊分类信息维护',
	iconCls: 'list',
    region: 'center',
    layout:'fit',
    width:400,
    readerModel:'local',
    url: 'herp.srm.classperiomanagemain.csp',
    atLoad : true, // 是否自动刷新
	store: itemGridDs,
	cm: itemGridCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	//tbar:['年度:','-',YearField,'-','期刊类别:','-',ClassField,'-','期刊级别:','-',LevelField,'期刊名称:','-',PerionField ,'-',SearchButton,'-',addButton,'-',editButton,'-',delButton],
	tbar:['','年度','',YearField,'','期刊级别','',LevelField,'','期刊名称','',PerionField,'-',SearchButton,'-',addButton,'-',editButton,'-',delButton],
	bbar:itemGridPagingToolbar
});
itemGridDs.load({params:{start:0, limit:25}});



	

