
srmmonographAddFun = function() {

	var NameField = new Ext.form.TextField({
		id: 'Name',
		fieldLabel: '专著名称',
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
	
	//获取著作类别
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
			fieldLabel: '著作类别',
			width:200,
			listWidth : 250,
			allowBlank: true,
			store: unittypeDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '请选择著作类别...',
			name: 'unittypeField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true
	});
	
	//获取科室名称
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
			fieldLabel: '科室名称',
			width:200,
			listWidth : 250,
			allowBlank: false,
			store: unitdeptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '请选择科室姓名...',
			name: 'unitdeptField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true
	});



//////////////////添加多个著作编者///////////////////////

/////////////////主编类型///////////////////////////
var EditorTypeStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','主编'],['2','副编'],['3','编者']]
});

var EditorTypeField = new Ext.form.ComboBox({
	id: 'EditorTypeField',
	fieldLabel: '作者类型',
	width:200,
	//anchor: '95%',
	listWidth : 200,
	allowBlank: true,
	store:EditorTypeStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	emptyText:'请选择著作作者类型...',
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

//著作作者
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
			fieldLabel: '作者名称',
			width:200,
			listWidth :250,
			//allowBlank: false,
			store: unituserDs,
			valueField: 'rowid',
			hideOnSelect:false,
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'请选择人员姓名...',
			name: 'unituserField',
			minChars: 1,
			pageSize: 10,
			hideOnSelect:false,
			forceSelection : true,
			selectOnFocus:true
	});
///////////////////编者位次/////////////////////////////  
var BookAuthorRangeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '第一'],['2', '第二'], ['3', '第三'], ['4', '第四'], ['5', '第五'],['6', '第六'],['7', '第七'],['8', '第八']]
	});		
		
var BookAuthorRangeCombox = new Ext.form.ComboBox({
	                   id : 'BookAuthorRangeCombox',
		           fieldLabel : '作者位次',
	                   width : 200,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : BookAuthorRangeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : false,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true
						  });	
///////////////////著作作者是否本院/////////////////////////////  
var BookIsTheHosDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '是'],['0', '否']]
	});		
		
var BookIsTheHosCombox = new Ext.form.ComboBox({
	                   id : 'BookIsTheHosCombox',
		           fieldLabel : '是否本院',
	                   width : 200,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : BookIsTheHosDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           value:'1',
		           selectOnFocus : true,
		           forceSelection : true
						  });	
	
	
var InventorsGrid = new Ext.grid.GridPanel({
        fieldLabel:'著作作者',
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
            {id: 'typerowid', header: '著作作者类型ID', width: 100,dataIndex: 'typerowid',hidden:true},
            {header: '著作作者类型', dataIndex: 'typename',align:'center',width: 80},
            {id: 'rowid', header: '著作作者ID', width: 100,dataIndex: 'rowid',hidden:true},
            {header: '著作作者', dataIndex: 'name',align:'center',width: 80},
            {id: 'rangerowid', header: '著作作者位次ID', width: 100,dataIndex: 'rangerowid',hidden:true},
            {header: '著作作者位次', dataIndex: 'rangename',align:'center',width: 80},
            {id: 'isthehosrowid', header: '是否本院ID', width: 100,dataIndex: 'isthehosrowid',hidden:true},
            {header: '是否本院', dataIndex: 'isthehos',align:'center',width: 80}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 200,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'添加',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});
var rawValue="";
///////////////添加多个发明人按钮////////////////
var addInventors  = new Ext.Button({
		text: '添加',
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
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
							if((tmprange!="")&(BookAuthorRange!="")&(tmprange==BookAuthorRange))
							{
								//alert("tmprange:"+tmprange+"BookAuthorRange:"+BookAuthorRange);
								Ext.Msg.show({title:'错误',msg:'不同的著作作者您选择了相同的位次!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的著作作者!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'提示',msg:'请选择您要添加的著作作者!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
//				  var row = InventorsGrid.getStore().getAt(i).get('typerowid');//每行对象rowid的值
//				  rawValue = rawValue+","+row;
//				}
//			}
//			alert("rawValue:"+rawValue);
			//alert(InventorId+"  "+InventorName);
		}
	});	
var delInventors = new Ext.Button({
		text:'删除',
		handler: function() {  
			var rows = InventorsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = InventorsGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				InventorsGrid.getStore().removeAt(rRowid);//移除所选中的一行
			}

//			var total = InventorsGrid.getStore().getCount();
//			//alert(total);
//			if(total>0){
//				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
//				for(var i=1;i<total;i++){
//				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
//				  rawValue = rawValue+","+row;
//				}
//			}
		}
	});
	var TotalNum = new Ext.form.NumberField({
		id: 'TotalNum',
		fieldLabel: '总字数（千字）',
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
		fieldLabel: '出版社',
		width:200,
		listWidth : 250,
		allowBlank: false,
		store: PressDs,
		displayField: 'name',
		valueField: 'rowid',
		triggerAction: 'all',
		typeAhead : true,
		triggerAction : 'all',
		emptyText : '请选择出版社...',
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
		fieldLabel:'出版社级别',
		width:200,
		emptyText : '',
		editable:false,
		name: 'PressLevel',
		selectOnFocus : true
	});
	
	var PubTime = new Ext.form.DateField({
		id : 'PubTime',
		fieldLabel:'出版日期',
		format : 'Y-m-d',
		width : 200,
		//allowBlank : false,
		emptyText : ''
	});
	
	var ISBN = new Ext.form.TextField({
		id: 'ISBN',
		fieldLabel: 'ISBN号',
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
		fieldLabel: '出版版次',
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
	
/////////////////我院单位位次///////////////////////////
var CompleteUnitStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','第一完成单位'],['2','第二完成单位'],['3','第三完成单位'],['4','第四完成单位'],['5','第五完成单位'],['6','第六完成单位'],['7','第七完成单位'],['8','第八完成单位']]
});

var CompleteUnitField = new Ext.form.ComboBox({
	id: 'CompleteUnitField',
	fieldLabel: '我院单位位次',
	width:200,
	//anchor: '95%',
	listWidth : 200,
	allowBlank: true,
	store:CompleteUnitStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	emptyText:'请选择我院单位位次...',
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
		    
			title : '添加',
			width :600,
			height : 420,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '保存',
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
							  //var row = InventorsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
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
//						if (!/(^\d{18}$)|(^\d{17}(\d|X)$)/.test(idnum)){Ext.Msg.show({title:'错误',msg:'身份证号格式不正确!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
//						}
//					    if(phone!=""){
//						if (!/[0-9]/.test(phone)){Ext.Msg.show({title:'错误',msg:'电话号码只能位数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); return null;}
//					    }
				Ext.Ajax.request({
					url:'herp.srm.monographrewardapplyexe.csp?action=add&name='+encodeURIComponent(name)+'&typedr='+encodeURIComponent(typedr)+'&deptdr='+encodeURIComponent(deptdr)+'&editor='+editor+'&totalnum='+encodeURIComponent(totalnum)+'&press='+encodeURIComponent(press)+'&pubtime='+encodeURIComponent(pubtime)+'&isbn='+encodeURIComponent(isbn)+'&publishfreq='+publishfreq+'&completeunit='+completeunit+'&subuser='+userdr,
					waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGrid.load({params:{start:0, limit:25,userdr:userdr}});
						} 
						else
						{
							var message="重复添加";
							if(jsonData.info=='RepName') message="著作名称重复！";
							if(jsonData.info=='RepISDN') message="ISDN重复！";
							
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : '取消',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
