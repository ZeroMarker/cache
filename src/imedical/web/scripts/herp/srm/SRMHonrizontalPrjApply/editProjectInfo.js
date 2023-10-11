// JavaScript Document
/////////////////////修改功能/////////////////////
Date.dayNames = ["日", "一", "二", "三", "四", "五", "六"];  
    Date.monthNames=["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"];  
    if (Ext.DatePicker) {  
        Ext.apply(Ext.DatePicker.prototype, {  
            todayText: "今天",  
            minText: "日期在最小日期之前",  
            maxText: "日期在最大日期之后",  
            disabledDaysText: "",  
            disabledDatesText: "",  
            monthNames: Date.monthNames,  
            dayNames: Date.dayNames,  
            nextText: '下月 (Control+Right)',  
            prevText: '上月 (Control+Left)',  
            monthYearText: '选择一个月 (Control+Up/Down 来改变年)',  
            todayTip: "{0} (Spacebar)",  
            okText: "确定",  
            cancelText: "取消" 
        });  
    } 
var prawValue = "";
var urawValue = "";
editFun = function(ParticipantsIDs,RelyUnitsIDs) {
	//alert(ParticipantsIDs);
	
	
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
	name:'Name',
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
	url:'herp.srm.srmhorizentalprjapplyexe.csp'+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptFields').getRawValue()),
	method:'POST'});
});

var DeptFields = new Ext.form.ComboBox({
	id: 'DeptFields',
	fieldLabel: '科室',
	width:172,
	listWidth : 220,
	allowBlank: true,
	store:DeptsDs,
	valueField: 'rowid',
	displayField: 'Name',
	name:'Dept',
	triggerAction: 'all',
	emptyText:'请选择科室...',
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
					}, ['rowid', 'Name'])
		});

HeadDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.srm.srmhorizentalprjapplyexe.csp'+'?action=applyerList',
						method : 'POST'
					});
		});

var HeadCombo = new Ext.form.ComboBox({
            id: 'HeadCombo',
			fieldLabel: '负责人',
			store : HeadDs,
			displayField : 'Name',
			valueField : 'rowid',
			name:'Head',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择负责人...',
			width : 172,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});





//////////////////////课题来源//////////////////////////////////
var addSubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});
		
addSubSourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url :'herp.srm.srmhorizentalprjapplyexe.csp'+'?action=sourceList', 
                        method:'POST'
					});
		});

var addSubSourceCombo = new Ext.form.ComboBox({
			id:'addSubSourceCombo',
			fieldLabel : '课题来源',
			store : addSubSourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			name:'PTName',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 172,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
/////////////////////课题编号//////////////////////////
var ProjectNumField = new Ext.form.TextField({
	id:'ProjectNumField',
    fieldLabel: '课题编号',
	width:180,
	name:'SubNo',
    allowBlank: false,
    emptyText:'课题编号...',
    anchor: '95%'
	});

///////////////////////申请经费///////////////////////////
var AppFundsField = new Ext.form.TextField({
	id:'AppFundsField',
	fieldLabel: '申请经费',
	width:180,
	name:'AppFunds',
	allowBlank: false,
	emptyText:'申请经费...',
	anchor: '95%'
});

/////////////////课题起始时间///////////////////////
var StartDateFields = new Ext.form.DateField({
			id:'StartDateFields',
			fieldLabel: '课题开始日期',
			width:172,
			name:'StartDate',
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
			id:'EndDateFields',
			fieldLabel: '课题截止日期',
			width:172,
			name:'EndDate',
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
			id:'ConDateFields',
			fieldLabel: '结题日期',
			width:172,
			name:'ConDate',
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
					}, ['rowid', 'Name'])
		});
		
RelyUnitDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.srm.srmhorizentalprjapplyexe.csp'+'?action=GetRelyUnit', 
                        method:'POST'
					});
		});

var RelyUnitCombo = new Ext.form.ComboBox({
			id:'eRelyUnits',
			fieldLabel : '依托单位',
			store : RelyUnitDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择依托单位',
			width : 172,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
var RelyUnitsGrid = new Ext.grid.GridPanel({
		id:'RelyUnitsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmhorizentalprjapplyexe.csp?action=RelyUnitsID&start='+0+'&limit='+25+'&RelyUnitsIDs='+RelyUnitsIDs,
		method:'POST'}),
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 129,
            sortable: true
        },
        columns: [
            {id: 'rowid', header: '依托单位ID', width: 129, sortable: true, dataIndex: 'rowid',hidden:true},
            {header: '依托单位名称', dataIndex: 'Name',align:'center',width: 258}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 260,
    height: 100
});

///////////////添加多个依托单位按钮////////////////
var eaddRelyUnits  = new Ext.Button({
		text: '添加',
		handler: function(){
			var RelyUnitsId;
			var id = Ext.getCmp('eRelyUnits').getValue();
			var RelyUnitsName = Ext.getCmp('eRelyUnits').getRawValue();
			var utotal = RelyUnitsGrid.getStore().getCount();
			if(utotal>0){	
				for(var i=0;i<utotal;i++){
					var erow = RelyUnitsGrid.getStore().getAt(i).get('rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个依托单位!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
							RelyUnitsId=id;
						}
					}else{
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的依托单位!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'提示',msg:'请选择您要添加的依托单位!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					RelyUnitsId=id;
				}	
			}	
			var data = new Ext.data.Record({'rowid':RelyUnitsId,'Name':RelyUnitsName});
			RelyUnitsGrid.stopEditing(); 
			RelyUnitsGrid.getStore().insert(0,data);
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var urow = RelyUnitsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  urawValue = urawValue+","+urow;
				}
			}
		}
	});	

	var edelRelyUnits = new Ext.Button({
		text:'删除',
		handler: function() {  
			var rows = RelyUnitsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = RelyUnitsGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				RelyUnitsGrid.getStore().removeAt(rRowid);//移除所选中的一行
			var utotal = RelyUnitsGrid.getStore().getCount();
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var urow = RelyUnitsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  urawValue = urawValue+","+urow;
				}
			}
		}}
	});
	
	

/////////////////////备注//////////////////////////
var RemarkField = new Ext.form.TextField({
	id:'RemarkField',
    fieldLabel: '备注',
	width:180,
	height: 200,
	name:'Remark',
    allowBlank: true,
    emptyText:'备注...',
    anchor: '95%'
	});


//////////////////参加人员///////////////////////
var eParticipantssDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
});


eParticipantssDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmhorizentalprjapplyexe.csp?action=GetParticipants&str='+encodeURIComponent(Ext.getCmp('eParticipants').getRawValue()),
	method:'POST'});
});

var eParticipantsFields = new Ext.form.ComboBox({
	id: 'eParticipants',
	fieldLabel: '参加人员',
	width:172,
	listWidth : 220,
	allowBlank: true,
	store:eParticipantssDs,
	valueField: 'rowid',
	displayField: 'Name',
	triggerAction: 'all',
	emptyText:'请重新选择参加人员...',
	name: 'eParticipants',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


var ParticipantsGrid = new Ext.grid.GridPanel({
		id:'ParticipantsGrid',
    	store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'herp.srm.srmhorizentalprjapplyexe.csp?action=ParticipantsID&start='+0+'&limit='+25+'&ParticipantsIDs='+ParticipantsIDs,
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
    height: 100
});

///////////////添加多个参加人员按钮////////////////
var eaddParticipants  = new Ext.Button({
		text: '添加',
		handler: function(){
			var ParticipantsId;
			var id = Ext.getCmp('eParticipants').getValue();
			var ParticipantsName = Ext.getCmp('eParticipants').getRawValue();
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = ParticipantsGrid.getStore().getAt(i).get('rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了同一个人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}else{
							ParticipantsId=id;
						}
					}else{
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的参加人员!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'提示',msg:'请选择您要添加的参加人员!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					ParticipantsId=id;
				}	
			}	
			var data = new Ext.data.Record({'rowid':ParticipantsId,'Name':ParticipantsName});
			ParticipantsGrid.stopEditing(); 
			ParticipantsGrid.getStore().insert(0,data);
			if(ptotal>0){
				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  prawValue = prawValue+","+prow;
				}
			}
		}
	});	

	var edelParticipants = new Ext.Button({
		text:'删除',
		handler: function() {  
			var rows = ParticipantsGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				rRowid = ParticipantsGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				ParticipantsGrid.getStore().removeAt(rRowid);//移除所选中的一行
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){
				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  prawValue = prawValue+","+prow;
				}
			}
		}}
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
					   //ParticipantsTextArea,
					   //addParticipants
					   //RelyUnitCombo,
					   RelyUnitsGrid,
					   RelyUnitCombo,
					    {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							
							columnWidth : .05
							},eaddRelyUnits,{
							xtype : 'displayfield',
							
							columnWidth : .07
							},edelRelyUnits]
						},
					   ParticipantsGrid,
					   eParticipantsFields,
					    {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [{
							xtype : 'displayfield',
							
							columnWidth : .05
							},eaddParticipants,{
							xtype : 'displayfield',
							
							columnWidth : .07
							},edelParticipants]
						}
					   //addParticipants,
					   //delParticipants
					   
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
			var rowObj=itemGrid.getSelectionModel().getSelections(); 
			this.getForm().loadRecord(rowObj[0]);
			//"rowid^Dept^Name^Head^Participants^PTName^SubNo^RelyUnit^PrjCN^FundGov^FundOwn^FundMatched^IsGovBuy^AlertPercent^SEndDate^ConDate^Remark"
	    //"^SubUser^SubDate^DataStatuslist^Desc^ProjStatus^ResAudit^HeadDr^ParticipantsIDs^RelyUnitIDs"
			FundGovField.setValue(rowObj[0].get("FundGov"));	
			FundOwnField.setValue(rowObj[0].get("FundOwn"));
			FundMatchedField.setValue(rowObj[0].get("FundMatched"));			
			IsGovBuyField.setRawValue(rowObj[0].get("IsGovBuy"));
			EndDateFields.setValue(rowObj[0].get("EndDate"));
		  StartDateFields.setValue(rowObj[0].get("StartDate"));
			RemarkField.setValue(rowObj[0].get("Remark"));
			AppFundsField.setValue(rowObj[0].get("AppFund"));
			AlertPercentField.setValue(rowObj[0].get("AlertPercent"));
		});

  // define window and show it in desktop
  var editWindow = new Ext.Window({
  	title: '修改项目材料申请上报信息',
    width: 600,
    height:510,
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
			var dept = rowObj[0].get("Dept");
			var heads = rowObj[0].get("Head");
			var source = rowObj[0].get("PTName");
      		var DeptDr = DeptFields.getValue();
			var HeadDr = HeadCombo.getValue();
			var invent = rowObj[0].get("Participants");
			var ptotal = ParticipantsGrid.getStore().getCount();
			if(ptotal>0){
				prawValue = ParticipantsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<ptotal;i++){
				  var prow = ParticipantsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  prawValue = prawValue+","+prow;
				};
			}
			var Participants = prawValue;
			var SubSource = addSubSourceCombo.getValue();
			var SubNo = ProjectNumField.getValue();
			var AppFunds = AppFundsField.getValue();
      		var StartDate = StartDateFields.getValue();
        	var EndDate = EndDateFields.getValue();
			var ConDate = ConDateFields.getValue();
			var utotal = RelyUnitsGrid.getStore().getCount();
			if(utotal>0){
				urawValue = RelyUnitsGrid.getStore().getAt(0).get('rowid');
				for(var i=1;i<utotal;i++){
				  var urow = RelyUnitsGrid.getStore().getAt(i).get('rowid');//每行对象rowid的值
				  urawValue = urawValue+","+urow;
				};
			}
			var RelyUnit = urawValue;
			//alert(RelyUnit);
			var SubUser = userdr;
			var Remark = RemarkField.getValue();
        	
			ProjectsName = ProjectsName.trim();
      		DeptDr = DeptDr.trim();
			HeadDr = HeadDr.trim();
			
			Participants = Participants.trim();
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
			if(Participants=="")
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
			 //if(Participants==invent){Participants=""};
			 if(HeadDr==heads){HeadDr=""};	
			 if(SubSource==source){SubSource=""};	
        	if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url:  'herp.srm.srmhorizentalprjapplyexe.csp?action=edit&rowid='+myRowid+'&ProjectsName='+encodeURIComponent(ProjectsName)+'&Participants='+Participants+'&HeadDr='+HeadDr+'&EndDate='+EndDate+'&SubSource='+SubSource+'&SubNo='+SubNo+'&AppFunds='+AppFunds+'&StartDate='+StartDate+'&SubUser='+SubUser+'&DeptDr='+DeptDr+'&ConDate='+ConDate+'&RelyUnit='+RelyUnit+'&Remark='+encodeURIComponent(Remark),
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
