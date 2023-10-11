

srmPartTimeInfoEditFun = function() {
var daptdr="";
var userkdr   = session['LOGON.USERCODE'];
var projUrl = 'herp.srm.srmapplypaperexe.csp';
var itemGridUrl = '../csp/herp.srm.srmPartTimeInfoexe.csp';
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
	
///////////////////类型/////////////////////////////  
var eTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '科研'],['2', '教学']]
	});		
		
var eTypeCombox = new Ext.form.ComboBox({
	                   id : 'eTypeCombox',
		           fieldLabel : '类型',
	                   width : 150,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : eTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
		           labelSeparator:''
						  });	

var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList',
						method : 'POST'
					});
		});

///兼职人员
var EditUserCombo = new Ext.form.ComboBox({
			fieldLabel : '兼职人员 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			name:'UserName',
			width : 150,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
		  listeners : {
				    	 select:{
                       fn:function(combo,record,index) { 
                       Ext.Ajax.request({			        
                       url: '../csp/herp.srm.srmPartTimeInfoexe.csp?action=UserDeptList&userdr='+EditUserCombo.getValue(),	
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
						         if (jsonData.success=='true'){
							         var data = jsonData.info;
							         var arr= data.split("^");
							          deptdr=arr[0];
							         var name=arr[1];
							     	UserDeptCombo.setValue(name);  
 
                                        
					         	}
				         	},
					       scope: this
				      	});              
                  }
                }			
						}
			});	
		
///////////////////兼职人员科室/////////////////////////////  
var UserDeptCombo = new Ext.form.TextField({
				fieldLabel: '兼职人员科室',
				width:150,
				allowBlank : false, 
				name:'DeptName',
				//anchor: '90%',
				disabled:'true',
				selectOnFocus:'true',
				labelSeparator:''
			});	



///学会名称
var EditCommitteeInfoDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
EditCommitteeInfoDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : itemGridUrl+'?action=CalCommitteeInfo', 
                        method:'POST'
					});
		});

var EditCommitteeInfoCombo = new Ext.form.ComboBox({
			fieldLabel : '学会名称',
			store : EditCommitteeInfoDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			name:'CommitteeName',
			width : 150,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''
		});
		
	///分会或学组名称	
		
		var BranchField = new Ext.form.TextField({
				fieldLabel: '分会或学组名称',
				width:150,
				allowBlank : false, 
				name:'Branch',
				//anchor: '90%',
				//disabled:'true',
				selectOnFocus:'true',
				labelSeparator:''
			});	

		
///职务名称
var EditPartTimeJobsDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
EditPartTimeJobsDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : itemGridUrl+'?action=CalPartTimeJobs', 
                        method:'POST'
					});
		});

var EditPartTimeJobsCombo = new Ext.form.ComboBox({
			fieldLabel : '职位名称',
			store : EditPartTimeJobsDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			name:'PositionName',
			width : 150,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''
		});
	
///当选年度
var YserDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
YserDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : itemGridUrl+'?action=CalYear', 
                        method:'POST'
					});
		});

var YearCombo = new Ext.form.ComboBox({
			fieldLabel : '当选年度',
			store : YserDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			name:'Year',
			width : 150,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''
		});

///任职起始日期
var StartDateFields = new Ext.form.DateField({
			fieldLabel: '任职开始时间',
			width:150,
			allowBlank:false,
			//format:'Y-m-d',
			columnWidth : .12,
			name:'StartDate',
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true',
			labelSeparator:''
		});

///任职结束日期	
var EndDateFields = new Ext.form.DateField({
			fieldLabel: '任职截止时间',
			width:150,
			allowBlank:false,
			//format:'Y-m-d',
			name:'EndDate',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true',
			labelSeparator:''
		});

///申请人		
var SubUserText = new Ext.form.TextField({
	fieldLabel:'申请人',
	width : 150,
	selectOnFocus : true,
	labelSeparator:''
});
SubUserText.setValue(userkdr);


	
   var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [eTypeCombox,EditUserCombo,UserDeptCombo,EditCommitteeInfoCombo,BranchField,EditPartTimeJobsCombo,YearCombo,StartDateFields,EndDateFields]
		});
		
formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			eTypeCombox.setRawValue(rowObj[0].get("Type"));
			//InventorsGrid.load();
		});

  // define window and show it in desktop
  var editWindow = new Ext.Window({
  	title : '修改社会兼职申请信息',
	iconCls: 'pencil',
    width: 300,
    autoHeight : true,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存',
    	iconCls: 'save', 
      handler: function() {
      		var eUserDr = EditUserCombo.getValue();
			//var DeptDr = deptdr;
			var eCommitteeDr = EditCommitteeInfoCombo.getValue();
			var ePositionDr = EditPartTimeJobsCombo.getValue();
			var eYearDr = YearCombo.getValue();
			var eStartDate = StartDateFields.getRawValue();
			
			
			var eDeptName=UserDeptCombo.getValue();
			
			var eBranch=BranchField.getValue();
			
			
			 if (eStartDate!=="")
				{
				 //eStartDate=eStartDate.format ('Y-m-d');
				}
			var eEndDate = EndDateFields.getRawValue();
			 if (eEndDate!=="")
				{
				 //eEndDate=eEndDate.format ('Y-m-d');
				}
				
		

		    var Type=eTypeCombox.getValue();
		
			var eSubUser = SubUserText.getValue();
      		 if(eUserDr==rowObj[0].get("UserName")){eUserDr=""};
			 if(eCommitteeDr==rowObj[0].get("CommitteeName")){eCommitteeDr=""};
			 if(ePositionDr==rowObj[0].get("PositionName")){ePositionDr=""};	
			 if(eYearDr==rowObj[0].get("Year")){eYearDr=""};
			 //if(eStartDate==rowObj[0].get("StartDate")){eStartDate=""};
			 //if(eEndDate==rowObj[0].get("EndDate")){eEndDate=""};
			 
			 
			 if(eDeptName==rowObj[0].get("DeptName")){eDeptName=""};
			 
			 if(eBranch==rowObj[0].get("Branch")){eBranch=""};
			 if(Type==rowObj[0].get("Type")){Type="";}
			 
        	  if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url:  'herp.srm.srmPartTimeInfoexe.csp?action=edit&rowid='+myRowid+'&eUserDr='+encodeURIComponent(eUserDr)+'&DeptDr='+encodeURIComponent(eDeptName)+'&eCommitteeDr='+eCommitteeDr+'&ePositionDr='+ePositionDr+'&eYearDr='+eYearDr+'&eStartDate='+encodeURIComponent(eStartDate)+'&eEndDate='+encodeURIComponent(eEndDate)+'&eSubUser='+encodeURIComponent(eSubUser)+'&eBranch='+encodeURIComponent(eBranch)+'&Type='+Type,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize,usercode:usercode}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info!=0) message='信息修改有误!';
									if(jsonData.info=='RepStart') message="开始时间不能大于截止时间";
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后保存。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
			text: '关闭',
			iconCls : 'cancel',
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
};
	
	
