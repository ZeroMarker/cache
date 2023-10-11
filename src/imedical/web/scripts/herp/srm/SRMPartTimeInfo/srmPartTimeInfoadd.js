

srmPartTimeInfoAddFun = function() {


var deptdr="";
var userkdr   = session['LOGON.USERCODE'];
var projUrl = 'herp.srm.srmapplypaperexe.csp';
var itemGridUrl = '../csp/herp.srm.srmPartTimeInfoexe.csp';

///////////////////类型/////////////////////////////  
var aTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '科研'],['2', '教学']]
	});		
		
var aTypeCombox = new Ext.form.ComboBox({
	                   id : 'aTypeCombox',
		           fieldLabel : '类型',
	                   width : 150,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : aTypeDs,
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
var AddUserCombo = new Ext.form.ComboBox({
			fieldLabel : '兼职人员 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			allowBlank:false,
			triggerAction : 'all',
			emptyText : '',
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
                       url: '../csp/herp.srm.srmPartTimeInfoexe.csp?action=UserDeptList&userdr='+AddUserCombo.getValue(),	
					           success: function(result, request){
					         	 var jsonData = Ext.util.JSON.decode( result.responseText );  
					         	 
						         if (jsonData.success=='true'){
							         var data = jsonData.info;
							         var arr= data.split("^");
							         deptdr=arr[0];
							         var name=arr[1];
							     	UserDeptCombo.setValue(name);  
                                  //UserDeptCombo.Value=deptdr;  
                                        
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
				id:'UserDeptCombo',
				fieldLabel: '兼职人员科室',
				width:150,
				allowBlank : false, 
				//anchor: '90%',
				disabled:'true',
				selectOnFocus:'true',
				labelSeparator:''
			});	


///学会名称
var AddCommitteeInfoDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
AddCommitteeInfoDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : itemGridUrl+'?action=CalCommitteeInfo', 
                        method:'POST'
					});
		});

var AddCommitteeInfoCombo = new Ext.form.ComboBox({
			fieldLabel : '学会名称',
			store : AddCommitteeInfoDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			allowBlank:false,
			triggerAction : 'all',
			emptyText : '',
			width : 150,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''
		});
		///分会或学组名称
	var Branch = new Ext.form.TextField({
				id:'Branch',
				fieldLabel : '分会或学组名称',
				
				width:150,
				allowBlank : false, 
			
				//anchor: '90%',
				//disabled:'true',
				selectOnFocus:'true',
				labelSeparator:''
			});	
	
		
		
		
///职务名称
var AddPartTimeJobsDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
AddPartTimeJobsDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : itemGridUrl+'?action=CalPartTimeJobs', 
                        method:'POST'
					});
		});

var AddPartTimeJobsCombo = new Ext.form.ComboBox({
			fieldLabel : '职位名称',
			store : AddPartTimeJobsDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			allowBlank:false,
			triggerAction : 'all',
			emptyText : '',
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
			width : 150,
			allowBlank:false,
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
			items : [aTypeCombox,AddUserCombo,UserDeptCombo,AddCommitteeInfoCombo,Branch,AddPartTimeJobsCombo,YearCombo,StartDateFields,EndDateFields]
		});
	
	var addWin = new Ext.Window({
		    
			title : '新增社会兼职申请信息',
			iconCls : 'edit_add',
			width : 300,
			autoHeight : true,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '保存',
				iconCls: 'save',
				handler : function() {
					if (formPanel.form.isValid()) {
					var UserDr = AddUserCombo.getValue();
					var DeptDr = deptdr;
					//alert(DeptDr);
					var CommitteeDr = AddCommitteeInfoCombo.getValue();
					var PositionDr = AddPartTimeJobsCombo.getValue();
					var YearDr = YearCombo.getValue();
					var StartDate = StartDateFields.getRawValue();
					
					var Branchs = Branch.getValue();
					var Type = aTypeCombox.getValue();
					
					 if (StartDate!=="")
					    {
						 //StartDate=StartDate.format ('Y-m-d');
					    }
					   
					var EndDate = EndDateFields.getRawValue();
					 if (EndDate!=="")
					    {
						 //EndDate=EndDate.format ('Y-m-d');
					    }
				
					var SubUser = SubUserText.getValue();
					
					if(Type=="")
					{
					Ext.Msg.show({title:'错误',msg:'类型不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	        return;
					}
					
				Ext.Ajax.request({
					url:'herp.srm.srmPartTimeInfoexe.csp?action=add&UserDr='+encodeURIComponent(UserDr)+'&DeptDr='+encodeURIComponent(DeptDr)+'&CommitteeDr='+CommitteeDr+'&PositionDr='+encodeURIComponent(PositionDr)+'&YearDr='+encodeURIComponent(YearDr)+'&StartDate='+encodeURIComponent(StartDate)+'&EndDate='+encodeURIComponent(EndDate)+'&SubUser='+encodeURIComponent(SubUser)+'&Branch='+encodeURIComponent(Branchs)+'&Type='+Type,
					waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize,usercode:usercode}});
						addWin.close();
						}
						else
						{	var message="重复添加";
							if(jsonData.info=='RepPartTimeInfo') message="兼职人员和学会名称与原记录重复！";
							if(jsonData.info=='RepStart') message="开始时间不能大于截止时间";
						    Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  
				} 
				}					
			},
			{
				text : '关闭',
				iconCls : 'cancel',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
