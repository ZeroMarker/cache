

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
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid"); 
		
	}
	
///////////////////����/////////////////////////////  
var eTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var eTypeCombox = new Ext.form.ComboBox({
	                   id : 'eTypeCombox',
		           fieldLabel : '����',
	                   width : 150,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : eTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
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

///��ְ��Ա
var EditUserCombo = new Ext.form.ComboBox({
			fieldLabel : '��ְ��Ա ',
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
		
///////////////////��ְ��Ա����/////////////////////////////  
var UserDeptCombo = new Ext.form.TextField({
				fieldLabel: '��ְ��Ա����',
				width:150,
				allowBlank : false, 
				name:'DeptName',
				//anchor: '90%',
				disabled:'true',
				selectOnFocus:'true',
				labelSeparator:''
			});	



///ѧ������
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
			fieldLabel : 'ѧ������',
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
		
	///�ֻ��ѧ������	
		
		var BranchField = new Ext.form.TextField({
				fieldLabel: '�ֻ��ѧ������',
				width:150,
				allowBlank : false, 
				name:'Branch',
				//anchor: '90%',
				//disabled:'true',
				selectOnFocus:'true',
				labelSeparator:''
			});	

		
///ְ������
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
			fieldLabel : 'ְλ����',
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
	
///��ѡ���
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
			fieldLabel : '��ѡ���',
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

///��ְ��ʼ����
var StartDateFields = new Ext.form.DateField({
			fieldLabel: '��ְ��ʼʱ��',
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

///��ְ��������	
var EndDateFields = new Ext.form.DateField({
			fieldLabel: '��ְ��ֹʱ��',
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

///������		
var SubUserText = new Ext.form.TextField({
	fieldLabel:'������',
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
  	title : '�޸�����ְ������Ϣ',
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
    	text: '����',
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
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize,usercode:usercode}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info!=0) message='��Ϣ�޸�����!';
									if(jsonData.info=='RepStart') message="��ʼʱ�䲻�ܴ��ڽ�ֹʱ��";
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ���󱣴档',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
			text: '�ر�',
			iconCls : 'cancel',
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
};
	
	
