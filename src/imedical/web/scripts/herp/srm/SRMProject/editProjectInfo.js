// JavaScript Document
/////////////////////修改功能/////////////////////

var rawValue = "";
editFun = function(InventorsIDs) {
	//alert(InventorsIDs);
	
	
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//alert(rowObj[0].get("remark"));
	if(len < 1)
	{
		Ext.Msg.show({title:'提示',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid"); 
	}

///////////////////////课题名称//////////////////////////////
var ProjectsNameFields = new Ext.form.TextField({
	id:'ProjectsNameFields',
	width:180,
	fieldLabel: '课题名称',
	allowBlank: false,
	emptyText:'课题名称...',
	anchor: '95%'
});
	

/////////////////科室///////////////////////
var DeptsDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


DeptsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentapplyexe.csp'+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptFields').getRawValue()),
	method:'POST'});
});

var DeptFields = new Ext.form.ComboBox({
	id: 'DeptFields',
	fieldLabel: '科室',
	width:172,
	listWidth : 245,
	allowBlank: true,
	store:DeptsDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'请选择科室...',
	name: 'DeptFields',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////////负责人////////////////////////////
var HeadDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

HeadDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList',
						method : 'POST'
					});
		});

var HeadCombo = new Ext.form.ComboBox({
            id: 'HeadCombo',
			fieldLabel: '负责人',
			store : HeadDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择负责人...',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});




/////////////////参加人员///////////////////////////
var eInventorssDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


eInventorssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentapplyexe.csp?action=GetInventors&str='+encodeURIComponent(Ext.getCmp('Inventors').getRawValue()),
	method:'POST'});
});

var eInventorsFields = new Ext.form.ComboBox({
	id: 'eInventors',
	fieldLabel: '参加人员',
	width:172,
	listWidth : 245,
	allowBlank: true,
	store:eInventorssDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'请重新选择参加人员...',
	name: 'eInventors',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


//////////////////////课题来源//////////////////////////////////
var addSubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
addSubSourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=sourceList', 
                        method:'POST'
					});
		});

var addSubSourceCombo = new Ext.form.ComboBox({
			fieldLabel : '课题来源',
			store : addSubSourceDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
/////////////////////课题编号//////////////////////////
var ProjectNumField = new Ext.form.TextField({
	id:'PatentNumField',
    fieldLabel: '课题编号',
	width:180,
    allowBlank: false,
    emptyText:'课题编号...',
    anchor: '95%'
	});

///////////////////////申请经费///////////////////////////
var AppFundsField = new Ext.form.TextField({
	id:'AppFundsField',
	fieldLabel: '申请经费',
	width:180,
	allowBlank: false,
	emptyText:'申请经费...',
	anchor: '95%'
});

/////////////////课题起始时间///////////////////////
var StartDateFields = new Ext.form.DateField({
			fieldLabel: '课题开始日期',
			width:172,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});



////////////////////////课题截止日期///////////////////////
var EndDateFields = new Ext.form.DateField({
			fieldLabel: '课题截止日期',
			width:172,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
		
		
/////////////////结题时间///////////////////////
var ConDateFields = new Ext.form.DateField({
			fieldLabel: '结题日期',
			width:172,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});


		
//////////////////////依托单位//////////////////////////////////
var RelyUnitDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
RelyUnitDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=RelyUnitList', 
                        method:'POST'
					});
		});

var RelyUnitCombo = new Ext.form.ComboBox({
			fieldLabel : '依托单位',
			store : RelyUnitDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择依托单位',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
	

/////////////////////备注//////////////////////////
var RemarkField = new Ext.form.TextField({
	id:'RemarkField',
    fieldLabel: '备注',
	width:180,
	height: 110,
    allowBlank: false,
    emptyText:'备注...',
    anchor: '95%'
	});


//////////////////参加人员///////////////////////
var InventorsGrid = new Ext.grid.GridPanel({
		id:'InventorsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmpatentapplyexe.csp'+'?action=InventorID&start='+0+'&limit='+25+'&InventorsIDs='+InventorsIDs,
		method:'POST'}),
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '参加人员ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '参加人员名称', dataIndex: 'Name',align:'center',width: 258}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 260,
    height: 110
});

///////////////添加多个发明人按钮////////////////
var eaddInventors  = new Ext.Button({
		text: '添加',
		handler: function(){
			var InventorId;
			var id = Ext.getCmp('eInventors').getValue();
			var InventorName = Ext.getCmp('eInventors').getRawValue();
			var total = InventorsGrid.getStore().getCount();
			if(total>0){	
				for(var i=0;i<total;i++){
					var erow = InventorsGrid.getStore().getAt(i).get('rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
							InventorId=id;
						}
					}else{
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的发明人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'提示',msg:'请选择您要添加的发明人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					InventorId=id;
				}	
			}	
			var data = new Ext.data.Record({'rowid':InventorId,'Name':InventorName});
			InventorsGrid.stopEditing(); 
			InventorsGrid.getStore().insert(0,data);
			if(total>0){
				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  rawValue = rawValue+","+row;
				}
			}
		}
	});	

	var edelInventors = new Ext.Button({
		text:'删除',
		handler: function() {  
			var rows = InventorsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = InventorsGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				InventorsGrid.getStore().removeAt(rRowid);//移除所选中的一行
			var total = InventorsGrid.getStore().getCount();
			if(total>0){
				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  rawValue = rawValue+","+row;
				}
			}
		}
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
			
					  ProjectsNameFields,  
					   DeptFields,
					   HeadCombo,
					   //InventorsTextArea,
					   //addInventors
					   RelyUnitCombo,
					   InventorsGrid,
					   InventorsFields,
					   addInventors,
					   delInventors
					   
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
						addSubSourceCombo,
						//PatenteeFields,
						ProjectNumField,
						AppFundsField,
						StartDateFields,
						EndDateFields,
						ConDateFields,
						RemarkField										
					]
				 }]
		}
	]		
	// create form panel
  var editFormPanel = new Ext.form.FormPanel({
    labelWidth: 80,
	frame: true,
    items: colItems
	});
	
	editFormPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			//InventorsGrid.load();
		});

  // define window and show it in desktop
  var editWindow = new Ext.Window({
  	title: '修改项目材料申请上报信息',
    width: 600,
    height:370,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: editFormPanel,
    buttons: [{
    	text: '保存', 
      handler: function() {
      	// check form value
      		var ProjectsName = ProjectsNameFields.getValue();
      		var DeptDr = DeptFields.getValue();
			var HeadDr = HeadCombo.getValue();
			var invent = rowObj[0].get("Inventors");
			var total = InventorsGrid.getStore().getCount();
			if(total>0){
				rawValue = InventorsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<total;i++){
				  var row = InventorsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  rawValue = rawValue+","+row;
				};
			}
			var Inventors = rawValue;
			var SubSource = addSubSourceCombo.getValue();
			var SubNo = ProjectNumField.getValue();
			var AppFunds = AppFundsField.getValue();
      		var StartDate = StartDateFields.getValue();
        	var EndDate = EndDateFields.getValue();
			var ConDate = ConDateFields.getValue();
			var RelyUnit = RelyUnitCombo.getValue();
			var SubUser = userdr;
			var Remark = RemarkField.getValue();
        	
			ProjectsName = ProjectsName.trim();
      		DeptDr = DeptDr.trim();
			HeadDr = HeadDr.trim();
			
			Inventors = Inventors.trim();
      		SubSource = SubSource.trim();
      		SubNo = SubNo.trim();
			AppFunds = AppFunds.trim();
			RelyUnit = RelyUnit.trim();
      		Remark = Remark.trim();
      		
      		
      		if(ProjectsName=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'项目名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(DeptDr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'科室为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(HeadDr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'负责人为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(Inventors=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'专利参加人员为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(SubSource=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'课题来源为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(SubNo=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'课题编码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(StartDate=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'项目开始时间为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(EndDate=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'项目结束时间为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(ConDate=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'结题时间为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			if(RelyUnit=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'依托单位为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		 if(DeptDr==dept){DeptDr=""};
			 if(Inventors==invent){Inventors=""};
			 if(HeadDr==HeadDr){HeadDr=""};	
			 if(SubSource==SubSource){SubSource=""};	
        	if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url:  'herp.srm.srmpatentapplyexe.csp?action=edit&rowid='+myRowid+'&Name='+encodeURIComponent(Name)+'&DeptDr='+encodeURIComponent(DeptDr)+'&Inventors='+Inventors+'&CertificateNo='+CertificateNo+'&AnnDate='+AnnDate+'&YearDr='+YearDr+'&Patentee='+Patentee+'&PatentNum='+PatentNum+'&AppDate='+AppDate,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:25}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info!=0) message='信息修改有误!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
			text: '取消',
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
};
