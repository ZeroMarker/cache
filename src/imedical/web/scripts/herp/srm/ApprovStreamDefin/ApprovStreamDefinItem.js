var usernameDr = session['LOGON.USERID'];


//添加按钮
var AddButton = new Ext.Toolbar.Button({
	text: '新增',
    //tooltip:'增加',        
    iconCls: 'edit_add',
	handler:function(){
	
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	if (selectedRow.length < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请单击选择对应的审批流!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	}
	else
	{
	  var mainrowid=selectedRow[0].get("rowid");	
	}
        
		/////////////////////审批科室////////////////////////////
var aunitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

aunitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.approvstreamdefindetailexe.csp'+'?action=caldept&usernameDr='+usernameDr+'&str='+encodeURIComponent(Ext.getCmp('aunitField').getRawValue()),method:'POST'});
});

var aunitField = new Ext.form.ComboBox({
	id: 'aunitField',
	fieldLabel: '审批人科室',
	width:200,
	listWidth : 260,
	allowBlank: true,
	store: aunitDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择科室类别...',
	name: 'aunitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//////////////////////审批人//////////////////////
var aunituserDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

aunituserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.approvstreamdefindetailexe.csp'+'?action=caluser&str='+encodeURIComponent(Ext.getCmp('aunituserField').getRawValue()),method:'POST'});
});
//aunituserDs.load();

var aunituserField = new Ext.form.ComboBox({
	id: 'aunituserField',
	fieldLabel: '审批人',
	width:200,
	listWidth : 260,
	allowBlank: true,
	store: aunituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择科审批人名称...',
	name: 'aunituserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});  


/* var aunituserField = new Ext.form.MultiSelect({
    id:'aunituserField',
	fieldLabel: '审批人',
    width:200,
	listWidth : 260,
	allowBlank : false, 
	store: aunituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'选择...',
	name:'aunituserField',
	mode:'romote',
	minChars: 1,
	pageSize: 100,
	anchor: '95%',
	selectOnFocus:true,
	//forceSelection:'true',
	editable:true
}); */

var aChkUserGrid = new Ext.grid.GridPanel({
		id:'aChkUserGrid',
    store: new Ext.data.Store({
    //autoLoad:true,
		proxy: new Ext.data.MemoryProxy(),
		reader: new Ext.data.ArrayReader({}, [  
			 {name: 'rowid'},  
			 {name: 'name'}
         ])  
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '审批人ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '审批人列表', dataIndex: 'name',align:'center',width: 300}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 300,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'添加',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////添加多个审批人按钮////////////////
var addParticipants  = new Ext.Button({
		text: '增加',
		iconCls: 'edit_add',
		handler: function(){
			var ChkUserId;
			var id = Ext.getCmp('aunituserField').getValue();
			var ChkName = Ext.getCmp('aunituserField').getRawValue();

			var ptotal = aChkUserGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = aChkUserGrid.getStore().getAt(i).get('rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
						else{
						    ChkUserId=id;
						}
					}else{
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的审批人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'提示',msg:'请选择要添加的审批人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else{		
						ChkUserId=id;	
				}	
			}
			var data = new Ext.data.Record({'rowid':ChkUserId,'name':ChkName});
			aChkUserGrid.stopEditing(); 
			aChkUserGrid.getStore().insert(ptotal,data);
		}
	});	
var delParticipants = new Ext.Button({
		text:'删除',
		iconCls: 'edit_remove',
		handler: function() {  
			var rows = aChkUserGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的审批人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var rRowid = aChkUserGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				aChkUserGrid.getStore().removeAt(rRowid);//移除所选中的一行
			}		
		}
	});

/////////////////////是否科主任/////////////////////////////
var aIsdriectField = new Ext.form.Checkbox({
                        id:'aIsdriectField',
						name:'aIsdriectField',
						fieldLabel : '是否科主任'
					});
/////////////////////是否秘书/////////////////////////////					
var aIsSecretaryField = new Ext.form.Checkbox({
    id:'aIsSecretaryField',
	name:'aIsSecretaryField',
	fieldLabel : '是否科秘书'
});
//////////////////////审批功能描述//////////////////////
var aDescField = new Ext.form.TextField({
    id:'aDescField',
	name:'aDescField',
	fieldLabel:'审批功能描述',
	width : 200,
	allowBlank : false,
	selectOnFocus : true,
	labelSeparator:''
});
     	
	var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '1',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
							 aDescField,
							 aChkUserGrid,
							  
					         aunituserField,
					        
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
						      }
							  /* , 
							  //aunitField,
							 {
						         columnWidth : 1,
						         xtype : 'panel',
						         layout : "column",
						         items : [{
							       xtype : 'displayfield',
								   value:'是否科主任',
							       columnWidth : .25
							    },aIsdriectField,
							    {
							       xtype : 'displayfield',
							       columnWidth : .07
							    },{
							       xtype : 'displayfield',
								   value:'是否科秘书',
							       columnWidth : .25
							    },aIsSecretaryField]
						      } */
								]
							 }]
					}
				]	

var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 90,
				labelAlign: 'right',
				//layout: 'form',
				frame: true,
				items: colItems
			});
			
		//初始化添加按钮
		add1Button = new Ext.Toolbar.Button({
			text:'保存',
			iconCls: 'save'
		});
		
		var auser="";
		//定义添加按钮响应函数
		add1Handler = function(){
            //alert("wwww")
			var adesc = aDescField.getValue();
			//var auint = aunitField.getValue();
            var auint="";
			var chknamecount = aChkUserGrid.getStore().getCount();
			  if(chknamecount>0){
				var id = aChkUserGrid.getStore().getAt(0).get('rowid');
				auser = id;
				for(var i=1;i<chknamecount;i++){
				  var tmpid = aChkUserGrid.getStore().getAt(i).get('rowid');
				  auser = auser+","+tmpid;
				   };
			   }

            var aisdirect = "";
			if (Ext.getCmp('aIsdriectField').checked) {aisdirect="Y";}
			else { aisdirect="N";}
			var aissecretary = "";
			if (Ext.getCmp('aIsSecretaryField').checked) {aissecretary="Y";}
			else{aissecretary="N";}
	        //alert(adesc+"^"+auint+"^"+auser+"^"+aisdirect+"^"+aissecretary);
			//encodeURI
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.srm.approvstreamdefindetailexe.csp?action=add&checkmainid='+mainrowid+'&procdesc='+adesc+'&chkname='+auser+'&deptname='+auint+'&isdirect='+aisdirect+'&IsSecretary='+aissecretary),
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){aField.focus();};
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'增加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						detailGrid.load({params:{start:0, limit:20,checkmainid:mainrowid}});
						//addwin.close();
					}
					else
							{
								var message="";
                                message=jsonData.info
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
				},
				scope: this
			});
			addwin.close();
		};
	
		//添加保存按钮的监听事件
		add1Button.addListener('click',add1Handler,false);
	
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
			title: '新增审批流明细信息',
			iconCls: 'edit_add',
			width: 380,
			height:320,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				add1Button,
				cancelButton
			]
		});
	
		//窗口显示
		addwin.show();
	}	
});



//修改按钮
var EditButton = new Ext.Toolbar.Button({
	text: '修改',
    //tooltip:'修改',        
    iconCls: 'pencil',
	handler:function(){
		//定义并初始化行对象
		var rowObj=detailGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			var bfchknamedr = rowObj[0].get("chknamedr");
			var bfdeptnamedr = rowObj[0].get("deptnamedr");
		}
	
	
/////////////////////审批科室////////////////////////////
var eunitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

eunitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.approvstreamdefindetailexe.csp'+'?action=caldept&usernameDr='+usernameDr+'&str='+encodeURIComponent(Ext.getCmp('eunitField').getRawValue()),method:'POST'});
});

var eunitField = new Ext.form.ComboBox({
	id: 'eunitField',
	fieldLabel: '审批人科室',
	width:200,
	listWidth : 260,
	allowBlank: true,
	store: eunitDs,
	value:bfdeptnamedr,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择科室类别...',
	name: 'eunitField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//////////////////////审批人//////////////////////
var eunituserDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

eunituserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.approvstreamdefindetailexe.csp'+'?action=caluser&str='+encodeURIComponent(Ext.getCmp('eunituserField').getRawValue()),method:'POST'});
});

var eunituserField = new Ext.form.ComboBox({
	id: 'eunituserField',
	fieldLabel: '审批人',
	width:200,
	listWidth : 260,
	allowBlank: true,
	store: eunituserDs,
	//value:bfchknamedr,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择科审批人名称...',
	name: 'eunituserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

/**
var eunituserField = new Ext.form.MultiSelect({
    id :'eunituserField',
	fieldLabel: '审批人',
    width:200,
	listWidth : 260,
	allowBlank : false, 
	store: eunituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	////emptyText:'选择...',
	name: 'eunituserField',
	mode:'romote',
	//minChars: 1,
	pageSize: 100,
	anchor: '95%',
	//selectOnFocus:true,
	//forceSelection:'true',
	//editable:true
});
**/


var eChkUserGrid = new Ext.grid.GridPanel({
		id:'eChkUserGrid',
     store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.approvstreamdefindetailexe.csp'+'?action=GetChkUserInfo&start='+0+'&limit='+25+'&IDs='+bfchknamedr,
		method:'POST'}),
	  reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])

    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '审批人ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '审批人名称', dataIndex: 'name',align:'center',width: 300}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 300,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'添加',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////添加多个审批人按钮////////////////
var addeParticipants  = new Ext.Button({
		text: '增加',
		iconCls: 'edit_add',
		handler: function(){
			var ChkUserId;
			var id = Ext.getCmp('eunituserField').getValue();
			var ChkName = Ext.getCmp('eunituserField').getRawValue();

			var ptotal = eChkUserGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = eChkUserGrid.getStore().getAt(i).get('rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
						else{
						    ChkUserId=id;
						}
					}else{
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的审批人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'提示',msg:'请选择要添加的审批人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else{		
						ChkUserId=id;	
				}	
			}
			var data = new Ext.data.Record({'rowid':ChkUserId,'name':ChkName});
			eChkUserGrid.stopEditing(); 
			eChkUserGrid.getStore().insert(ptotal,data);
		}
	});	
var deleParticipants = new Ext.Button({
		text:'删除',
		iconCls: 'edit_remove',
		handler: function() {  
			var rows = eChkUserGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的审批人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var rRowid = eChkUserGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				eChkUserGrid.getStore().removeAt(rRowid);//移除所选中的一行
			}		
		}
	});

/////////////////////是否科主任/////////////////////////////
var eIsdriectField = new Ext.form.Checkbox({
                        id:'eIsdriectField',
						name:'eIsdriectField',
						fieldLabel : '是否科主任',
						renderer : function(v, p, record){
        	               p.css += ' x-grid3-check-col-td'; 
        	               return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
					});
/////////////////////是否秘书/////////////////////////////					
var eIsSecretaryField = new Ext.form.Checkbox({
    id:'eIsSecretaryField',
	name:'eIsSecretaryField',
	fieldLabel : '是否科秘书',
	renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
});
//////////////////////审批功能描述//////////////////////
var eDescField = new Ext.form.TextField({
    id:'eDescField',
	name:'eDescField',
	fieldLabel:'审批功能描述',
	width : 200,
	allowBlank : false,
	selectOnFocus : true,
	labelSeparator:''
});
		var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '1',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								   
							 eDescField,
							 eChkUserGrid,
					         eunituserField,
					        {
						         columnWidth : 1,
						         xtype : 'panel',
						         layout : "column",
						         items : [{
							       xtype : 'displayfield',
							       columnWidth : .05
							    },addeParticipants,
							    {
							       xtype : 'displayfield',
							       columnWidth : .07
							    },deleParticipants]
						      }
							 /*  , 
							  //eunitField,
							 {
						         columnWidth : 1,
						         xtype : 'panel',
						         layout : "column",
						         items : [{
							       xtype : 'displayfield',
								   value:'是否科主任',
							       columnWidth : .25
							    },eIsdriectField,
							    {
							       xtype : 'displayfield',
							       columnWidth : .07
							    },{
							       xtype : 'displayfield',
								   value:'是否科秘书',
							       columnWidth : .25
							    },eIsSecretaryField]
						      } */
								]
							 }]
					}
				]	

var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 90,
				labelAlign: 'right',
				//layout: 'form',
				frame: true,
				items: colItems
			});
		//定义并初始化面板
		/* var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				eDescField,
				eChkUserGrid,
				eunituserField,
				{
				 columnWidth : 1,
				 xtype : 'panel',
				 layout : "column",
				 items : [{
				 xtype : 'displayfield',
				 columnWidth : .05
				 },addeParticipants,
				{
				xtype : 'displayfield',
				columnWidth : .07
				},deleParticipants]
			    },
				eunitField,
				eIsdriectField,
				eIsSecretaryField
			]
		}); */
	
		//面板加载
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			eDescField.setValue(rowObj[0].get("procdesc"));
			//eunitField.setRawValue(rowObj[0].get("deptname"));
			//eunituserField.setRawValue(rowObj[0].get("chkname"));

            if(rowObj[0].get("isdirect")=="Y"){eIsdriectField.setValue(true);}		
			if(rowObj[0].get("IsSecretary")=="Y"){eIsSecretaryField.setValue(true);}	

			
		});

var euser="";
//定义并初始化保存修改按钮
   var editButton = new Ext.Toolbar.Button({
			text:'保存',
			iconCls : 'save'

		});
	
		//定义修改按钮响应函数
		editHandler = function(){

            var rowObj=itemGrid.getSelectionModel().getSelections();
            var mainrowid = rowObj[0].get("rowid");    
			
			var edesc = eDescField.getValue();
			//var euint = eunitField.getValue();	
			var euint="";
			var chknamecount = eChkUserGrid.getStore().getCount();
			  if(chknamecount>0){
				var id = eChkUserGrid.getStore().getAt(0).get('rowid');
				euser = id;
				for(var i=1;i<chknamecount;i++){
				  var tmpid = eChkUserGrid.getStore().getAt(i).get('rowid');
				  euser = euser+","+tmpid;
				   };
			   }
			
            var eisdirect = "";
			if (Ext.getCmp('eIsdriectField').checked) {eisdirect="Y";}
			else { eisdirect="N";}
			var eissecretary = "";
			if (Ext.getCmp('eIsSecretaryField').checked) {eissecretary="Y";}
			else { eissecretary="N";}
			
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.srm.approvstreamdefindetailexe.csp?action=edit&rowid='+rowid+'&checkmainid='+mainrowid+'&procdesc='+edesc+'&chkname='+euser+'&deptname='+euint+'&isdirect='+eisdirect+'&IsSecretary='+eissecretary),
				waitMsg:'保存中...',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});			
				},
				
				success: function(result, request){
				   	var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						detailGrid.load({params:{start:0, limit:20,checkmainid:mainrowid}});	
					}
					else
						{
							var message="";
                            message=jsonData.info
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
			title: '修改审批流明细信息',
			iconCls: 'pencil',
			width:380,
			height:320,
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
var DelButton = new Ext.Toolbar.Button({
	text: '删除',
   // tooltip:'删除',       
    id:'delButton', 
    iconCls:'edit_remove',
	handler:function(){
		//定义并初始化行对象
		var rowObj=detailGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		function handler(id){
			if(id=="yes"){
			       var mainrowObj=itemGrid.getSelectionModel().getSelections();
                   var mainrowid = mainrowObj[0].get("rowid");   
			
				  Ext.each(rowObj, function(record) {
				  if (Ext.isEmpty(record.get("rowid"))) {
				  detailGrid.getStore().remove(record);
				  return;}
					Ext.Ajax.request({
						url:'herp.srm.approvstreamdefindetailexe.csp?action=del&rowid='+rowid+'&checkmainid='+mainrowid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								detailGrid.load({params:{start:0, limit:20,checkmainid:mainrowid}});
							}else{
							    var message=jsonData.info;
							    if(jsonData.info=='HaveDate') message='明细中有信息，不能直接删除根节点!';
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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

var detailGrid = new dhc.herp.Gridhm({
        title:'审批流明细',
        iconCls: 'popup_list',
        region: 'east',
        //layout:'fit',
        width:700,
		tbar:[AddButton,EditButton,DelButton],
        url: 'herp.srm.approvstreamdefindetailexe.csp',
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			editable:false,
            hidden: true
        },{
            id:'checkmainid',
            header: '审批流主表ID',
			editable:false,
			hidden:true,
            dataIndex: 'checkmainid'
        },{
            id:'stepno',
            header: '审批顺序号',
			//allowBlank: false,
			editable:false,
			width:80,
            dataIndex: 'stepno'
        },{
           id:'procdesc',
            header: '审批功能描述',
			allowBlank: false,
			width:150,
			editable:false,
            dataIndex: 'procdesc'
        },{
            id:'chkname',
            header: '审批人',
			editable:false,
			//allowBlank: false,
			width:280,
            dataIndex: 'chkname'
            //type: unituserField
        },{
            id:'deptname',
            header: '审批人科室',
			hidden:true,
			//allowBlank: false,
			width:100,
            dataIndex: 'deptname'
            //type:unitField
        },{
            id:'isdirect',
            header: '是否是科主任',
			width:80,
            dataIndex: 'isdirect',
			hidden:true,
            //sortable: true,          
            //type : IsdriectField
            renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        },{
            id:'IsSecretary',
            header: '是否是科秘书',
			//allowBlank: false,
			width:80,
            dataIndex: 'IsSecretary',
			hidden:true,
            //type:driectField,
            //type : IsSecretaryField,
            renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        },{
            id:'chknamedr',
            header: '审批人dr',
			//allowBlank: false,
			width:100,
            dataIndex: 'chknamedr',
            hidden:true
        },{
            id:'deptnamedr',
            header: '审批人科室dr',
			//allowBlank: false,
			width:100,
            dataIndex: 'deptnamedr',
            hidden:true
        }]
   });
	
	// detailGrid.hiddenButton(0);  
	// detailGrid.hiddenButton(1);
	// detailGrid.hiddenButton(2); 
	

    /* detailGrid.btnDeleteHide(); //隐藏删除按钮
    detailGrid.btnAddHide(); 	//隐藏重置按钮
    detailGrid.btnSaveHide(); 	//隐藏重置按钮 */


