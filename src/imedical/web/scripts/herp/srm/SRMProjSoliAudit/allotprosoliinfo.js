//分配专业审核人 伦理审核人--xm 兰大一院需求20170606，只需要分配专家审核人，伦理审核由伦理办公室完成
allotFun = function()
{	
var selectedRow = itemGrid.getSelectionModel().getSelections();
	if (selectedRow.length < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请单击选择的项目征集数据!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	}
	else
	{
	  var mainrowid=selectedRow[0].get("rowid");	
	  var isethic=selectedRow[0].get("IsEthic");	
	}
        
//////////////////////专业审批人//////////////////////
var expertuserDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

expertuserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=expertList&str='+encodeURIComponent(Ext.getCmp('expertuserField').getRawValue()),method:'POST'});
});
//aunituserDs.load();

var expertuserField = new Ext.form.ComboBox({
	id: 'expertuserField',
	fieldLabel: '专业审批人',
	width:200,
	listWidth : 260,
	allowBlank: true,
	store: expertuserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择专业审批人名称...',
	name: 'expertuserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});  

var ExpertGrid = new Ext.grid.GridPanel({
		id:'ExpertGrid',
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
            {id: 'rowid', header: '专业审批人ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '专业审批人列表', dataIndex: 'name',align:'center',width: 300}
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
			var id = Ext.getCmp('expertuserField').getValue();
			var ChkName = Ext.getCmp('expertuserField').getRawValue();

			var ptotal = ExpertGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = ExpertGrid.getStore().getAt(i).get('rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
						else{
						    ChkUserId=id;
						}
					}else{
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的专业审批人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'提示',msg:'请选择要添加的专业审批人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else{		
						ChkUserId=id;	
				}	
			}
			var data = new Ext.data.Record({'rowid':ChkUserId,'name':ChkName});
			ExpertGrid.stopEditing(); 
			ExpertGrid.getStore().insert(ptotal,data);
		}
	});	
var delParticipants = new Ext.Button({
		text:'删除',
		iconCls: 'edit_remove',
		handler: function() {  
			var rows = ExpertGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的审批人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var rRowid = ExpertGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				ExpertGrid.getStore().removeAt(rRowid);//移除所选中的一行
			}		
		}
	});

/*
//////////////////////伦理审批人//////////////////////
var ethicuserDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

ethicuserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=ethicList&str='+encodeURIComponent(Ext.getCmp('ethicuserField').getRawValue()),method:'POST'});
});
//aunituserDs.load();

var ethicuserField = new Ext.form.ComboBox({
	id: 'ethicuserField',
	fieldLabel: '伦理审批人',
	width:200,
	listWidth : 260,
	allowBlank: true,
	store: ethicuserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择伦理审批人名称...',
	name: 'ethicuserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});  

var EthicGrid = new Ext.grid.GridPanel({
		id:'EthicGrid',
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
            {id: 'rowid', header: '伦理审批人ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '伦理审批人列表', dataIndex: 'name',align:'center',width: 300}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 300,
    height: 100
	//plugins:[rowEditing]
	//tbar:[{text:'添加',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});

///////////////添加多个伦理审批人按钮////////////////
var addethicParticipants  = new Ext.Button({
		id:'addethicParticipants',
		text: '添加',
		
		handler: function(){
			var EthicChkUserId;
			var ethicid = Ext.getCmp('ethicuserField').getValue();
			var EthicChkName = Ext.getCmp('ethicuserField').getRawValue();

			var ethicptotal = EthicGrid.getStore().getCount();
			if(ethicptotal>0){	
				for(var i=0;i<ethicptotal;i++){
					var ethicerow = EthicGrid.getStore().getAt(i).get('rowid');
					if(ethicid!=""){
						if(ethicid==ethicerow){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
						else{
						    EthicChkUserId=ethicid;
						}
					}else{
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的伦理审批人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(ethicid==""){
					Ext.Msg.show({title:'提示',msg:'请选择要添加的伦理审批人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else{		
						EthicChkUserId=ethicid;	
				}	
			}
			var data = new Ext.data.Record({'rowid':EthicChkUserId,'name':EthicChkName});
			EthicGrid.stopEditing(); 
			EthicGrid.getStore().insert(ethicptotal,data);
		}
	});	
var delethicParticipants = new Ext.Button({
		id:'delethicParticipants',
		text:'删除',
		handler: function() {  
			var rows = EthicGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的审批人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var rRowid = EthicGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				EthicGrid.getStore().removeAt(rRowid);//移除所选中的一行
			}		
		}
	});

*/	
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
					items: 
					[
						ExpertGrid,
						{
							xtype : 'displayfield',
							value : '',
							width : 10
						},
						expertuserField,
						
					    {
							columnWidth : 1,
						    xtype : 'panel',
						    layout : "column",
						    items : 
						    [
						    	{
									xtype : 'displayfield',
									value : '',
									width : 5
								},
							    addParticipants,
							    {
									xtype : 'displayfield',
									value : '',
									width : 20
								},
							    delParticipants
							]
						}
					]
				}
								]
							 }]
					

var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 95,
				//layout: 'form',
				frame: true,
				items: colItems
			});
/*
if ((isethic=="否")||(isethic==""))
{
	addethicParticipants.disable();
	delethicParticipants.disable();
	ethicuserField.disable();
}			
*/
		//初始化添加按钮
		add1Button = new Ext.Toolbar.Button({
			text:'保存',
			iconCls: 'save'
		});
		
		var auser="";
		var ethicuser="";
		//定义添加按钮响应函数
		add1Handler = function(){
			var chknamecount = ExpertGrid.getStore().getCount();
			  if(chknamecount>0){
				var id = ExpertGrid.getStore().getAt(0).get('rowid');
				auser = id;
				for(var i=1;i<chknamecount;i++){
				  var tmpid = ExpertGrid.getStore().getAt(i).get('rowid');
				  auser = auser+","+tmpid;
				   };
			   }
			  /* var ethicchknamecount = EthicGrid.getStore().getCount();
			  if(ethicchknamecount>0){
				var ethicid = EthicGrid.getStore().getAt(0).get('rowid');
				ethicuser = ethicid;
				for(var i=1;i<ethicchknamecount;i++){
				  var tmpethicid = EthicGrid.getStore().getAt(i).get('rowid');
				  ethicuser = ethicuser+","+tmpethicid;
				   };
			   } */
			   
			   var allotRowid = selectedRow[0].get("rowid");
		       var allotisethic = selectedRow[0].get("IsEthic");
		       var allotexpert = selectedRow[0].get("Expert");
		       var allotethicexpert = selectedRow[0].get("EthicExpert");
		       
			   //addethicParticipants.disable();
			   //if((chknamecount==0)&&(auser == ""))
				if(auser == "")
				{
					Ext.Msg.show({title:'提示',msg:'请添加专业审核人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;		
				}
			Ext.Ajax.request({
				url: projUrl+'?action=allot&rowid='+allotRowid+'&Expert='+encodeURIComponent(auser),
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){aField.focus();};
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'分配完成!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						//addwin.close();
						itemGrid.load({params:{start:0,limit:25}});
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
			title: '分配专业审批人',
			iconCls:'updateinfo',
			width: 400,
			height:300,
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
		/* 
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1)
	{
		Ext.Msg.show({title:'提示',msg:'请选择需要分配的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		var allotRowid = rowObj[0].get("rowid");
		var allotisethic = rowObj[0].get("IsEthic");
		var allotexpert = rowObj[0].get("Expert");
		var allotethicexpert = rowObj[0].get("EthicExpert");
		if(allotisethic == "否")
		{
			if(allotexpert == "")
			{
				Ext.Msg.show({title:'提示',msg:'请填写专业审核人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;		
			}
		}
		else if(allotisethic == "是")
		{
			if((allotexpert == "") || (allotethicexpert == ""))
			{
				Ext.Msg.show({title:'提示',msg:'请填写专业审核人和伦理审核人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}		
		}
		
		Ext.Ajax.request
		({
			url:  projUrl+'?action=allot&rowid='+allotRowid+'&Expert='+encodeURIComponent(allotexpert)+'&EthicExpert='+encodeURIComponent(allotethicexpert),
			waitMsg:'保存中...',
			failure: function(result, request)
			{			
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request)
			{				
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true')
				{								
					Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					itemGrid.load({params:{start:0,limit:25}});
				}
				else
				{
					var message = "";
					message = jsonData.info;
					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
			scope: this
		});	
	}	 */
};