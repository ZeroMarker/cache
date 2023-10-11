budgprojectdictAddFun = function(loginuser) {
	var hospid = session['LOGON.HOSPID'];
	var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
	var userid = session['LOGON.USERID'];
	var CTLOCID = session['LOGON.CTLOCID'];
	var tmpbudgdeptdr="";
	//获取医疗单位
	/*var gethospDs = new Ext.data.Store({
		url:commonboxUrl+'?action=hospital&rowid='+hospid+'',
		autoLoad:true,
		fields: ['rowid','name'],
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});	
	//gethospDs.on('beforeload', function(ds, o){
	//	ds.proxy=new Ext.data.HttpProxy({
	//	url:commonboxUrl+'?action=hospital&rowid='+hospid+'',method:'POST'});
	//});
	
	var gethospField = new Ext.form.ComboBox({
		id:'test',
		fieldLabel: '医疗单位',
		width:200,
		listWidth : 250,
		allowBlank: false,
		store: gethospDs,
		mode:'remote',
		typeAhead:true,
		valueField:'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择医疗单位...',
		name: 'gethospField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true'
		
	});
	
	
	gethospDs.on("load", function() {

			var Num=gethospDs.getCount();
    			if (Num!=0){
			var id=gethospDs.getAt(0).get('rowid');
		                alert(id);
			gethospField.setValue(id);  
    			} 
			});
	*/
	
	var CodeField = new Ext.form.TextField({
				id : 'CodeField',
				fieldLabel : '项目编号',
				//allowBlank : false,
				emptyText : '自动生成',
				width:200,
				//anchor : '80%'
				value:'自动生成',
				disabled:true	//不允许编辑
			});
		
	var NameField = new Ext.form.TextField({
				id : 'NameField',
				fieldLabel : '项目名称',
				allowBlank : false,
				emptyText : '必填',
				width:200//,
				//anchor : '80%'
			});

    //获取年度
	var yearlistDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
	});	
	yearlistDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl+'?action=year&str='+encodeURIComponent(Ext.getCmp('yearlistField').getRawValue()),method:'POST'});
	});	
	var yearlistField = new Ext.form.ComboBox({
		id: 'yearlistField',
		fieldLabel: '年度',
		width:200,
		listWidth : 250,
		allowBlank: false,
		store: yearlistDs,
		valueField: 'year',
		displayField: 'year',
		triggerAction: 'all',
		emptyText:'请选择年度...',
		name: 'yearlistField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	//设置年度默认显示本年度
	var date = new Date();
	yearlistField.setValue(date.getFullYear());
	
	//获取预算科室名称 xycadd BudgdeptNameField
	var deptnameBs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
	deptnameBs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl+'?action=dept&flag=1&str='+encodeURIComponent(Ext.getCmp('BudgdeptNameField').getRawValue()),method:'POST'});
	});
	var BudgdeptNameField = new Ext.form.ComboBox({
		id: 'BudgdeptNameField',
		fieldLabel: '预算科室',
		width:200,
		listWidth : 250,
		allowBlank: false,
		store: deptnameBs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择科室名称...',
		name: 'BudgdeptNameField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	Ext.Ajax.request({
					url: '../csp/herp.budg.budgprojectdictexe.csp?action=GetDept&CTlocID='+CTLOCID,				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var data = jsonData.info;
							var arr=data.split("^");
							var id = arr[0];
							var name = arr[2];
							tmpbudgdeptdr=id;
							//alert(tmpbudgdeptdr);
							BudgdeptNameField.setValue(name);
						}
					},
					scope: this
					});
	//alert(tmpbudgdeptdr);
	BudgdeptNameField.on('select',function(combo, record, index){
		tmpbudgdeptdr = combo.getValue();
	});
	
	//获取责任科室名称
	var deptnameDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
	
	
	deptnameDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:'herp.budg.budgprojectdictexe.csp'+'?action=calItemdept&str='+encodeURIComponent(Ext.getCmp('deptnameField').getRawValue()),method:'POST'});
	});
	
	var deptnameField = new Ext.form.ComboBox({
		id: 'deptnameField',
		fieldLabel: '责任科室',
		width:200,
		listWidth : 250,
		allowBlank: false,
		store: deptnameDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择科室名称...',
		name: 'deptnameField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	
	
	//负责人
	var userDs = new Ext.data.Store({
	atLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
    });

	userDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:'herp.budg.budgprojectdictexe.csp'+'?action=caluser&str='+encodeURIComponent(Ext.getCmp('userField').getRawValue()),method:'POST'});
	});
	var userField = new Ext.form.ComboBox({
		id: 'userField',
		fieldLabel: '人员名称',
		width:200,
		listWidth : 250,
		allowBlank: false,
		store: userDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择人员姓名...',
		name: 'userField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		disabled:true	//不允许编辑
	});
	//默认登录人 
	userField.setValue(session['LOGON.USERCODE']+'-'+session['LOGON.USERNAME']);
	
	var GoalField = new Ext.form.TextField({
			    id : 'GoalField',
				fieldLabel : '项目说明',
				//allowBlank : false,
				width:200,
				emptyText : ''//,
				//anchor : '80%'
		});
		
	//获取项目性质
	var proStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['1','一般性项目'],['2','基建项目'],['3','科研项目']]
	});
	var procomb = new Ext.form.ComboBox({
		id: 'property',
		fieldLabel: '项目性质',
		width:200,
		listWidth : 250,
		allowBlank: false,
		store: proStore,
		value:1,
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'请选择...',
		mode: 'local', //本地模式
		selectOnFocus:true,
		forceSelection:true
	});
	//procomb.setValue('贷');

	//政府采购
	var govbuyStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['1','是'],['2','否']]
	});
	var govbuycomb = new Ext.form.ComboBox({
		id: 'isgovbuy',
		fieldLabel: '政府采购',
		width:200,
		listWidth : 250,
		value: 1,
		store: govbuyStore,
		displayField: 'keyValue',
		valueField: 'key',
		mode : 'local',
		triggerAction: 'all',
		emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection : true
		
	});
	
	//项目状态
	var pstateStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['1','新建'],['2','执行'],['3','完成'],['4','取消']]
	});
	var pstatecomb = new Ext.form.ComboBox({
		id: 'state',
		fieldLabel: '项目状态',
		width:200,
		listWidth : 250,
		store: pstateStore,
		displayField: 'keyValue',
		valueField: 'key',
		value:1, //默认值
		disabled:true,
		triggerAction: 'all',
		emptyText:'请选择...',
		mode: 'local', //本地模式
		selectOnFocus:true,
		forceSelection:true
	});
	
	var PSField = new Ext.form.DateField({
		id : 'PSField',
		format : 'Y-m-d',
		fieldLabel : '计划开始时间',
		width : 200,
		emptyText : ''
	});
	var PEField = new Ext.form.DateField({
		id : 'PEField',
		format : 'Y-m-d',
		fieldLabel : '计划结束时间',
		width : 200,
		emptyText : ''
		
	});
	var RSField = new Ext.form.DateField({
		id : 'RSField',
		format : 'Y-m-d',
		fieldLabel : '实际开始时间',
		width : 200,
		emptyText : ''
	});
	var REField = new Ext.form.DateField({
		id : 'REField',
		format : 'Y-m-d',
		fieldLabel : '实际结束时间',
		width : 200,
		emptyText : ''
	});
    
    //推荐品牌
    var brandField1 = new Ext.form.TextField({
				id : 'brandField1',
				fieldLabel : '推荐品牌1',
				//allowBlank : false,
				emptyText : '',
				width:200
			});
	var specField1 = new Ext.form.TextField({
				id : 'specField1',
				fieldLabel : '规格型号1',
				//allowBlank : false,
				emptyText : '',
				width:200
			});		
	var brandField2 = new Ext.form.TextField({
				id : 'brandField2',
				fieldLabel : '推荐品牌2',
				//allowBlank : false,
				emptyText : '',
				width:200
			});
	var specField2 = new Ext.form.TextField({
				id : 'specField2',
				fieldLabel : '规格型号2',
				//allowBlank : false,
				emptyText : '',
				width:200
			});			
	var brandField3 = new Ext.form.TextField({
				id : 'brandField3',
				fieldLabel : '推荐品牌3',
				//allowBlank : false,
				emptyText : '',
				width:200
			});
	var specField3 = new Ext.form.TextField({
				id : 'specField3',
				fieldLabel : '规格型号3',
				//allowBlank : false,
				emptyText : '',
				width:200
			});	
	//xycadd,新增或更新
	/*var addeditStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['1','新增'],['2','更新']]
	});
	var addeditcomb = new Ext.form.ComboBox({
		id: 'isaddedit',
		fieldLabel: '新增-更新',
		width:200,
		listWidth : 250,
		store:addeditStore,
		displayField:'keyValue',
		valueField: 'key',
		mode:'local',
		triggerAction: 'all',
		emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		allowBlank: false	//必选项
	});   */  
	
	var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [CodeField, NameField,
							yearlistField,BudgdeptNameField, deptnameField, userField,GoalField,
							procomb, govbuycomb,pstatecomb,
							PSField,PEField,RSField,REField
							/*brandField1,specField1,brandField2,specField2,brandField3,specField3,addeditcomb*/]
				});

	var addWin = new Ext.Window({
		title : '添加',
		width : 400,
		height : 465,
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
		                                			
				var code = CodeField.getValue();
				var name = encodeURIComponent(NameField.getValue());
				var year = yearlistField.getValue();
				//alert(tmpbudgdeptdr);
				var budgdeptdr = tmpbudgdeptdr; //预算科室
				var deptdr = deptnameField.getValue(); //责任科室
				var userdr = session['LOGON.USERID']; //直接默认当前登录人id //userField.getValue();
				var goal = encodeURIComponent(GoalField.getRawValue());
				var property = procomb.getValue();
				if( property == "一般性项目"){property = "1";} //默认显示值为汉字，此处转换为数字
				var isgovbuy = govbuycomb.getValue();
				var state = pstatecomb.getValue();
				//var filedesc = encodeURIComponent(FileDescField.getRawValue());
				//var alert = alertField.getValue();
				var plansdate = PSField.getValue();
				var planedate = PEField.getValue();
				var realsdate = RSField.getValue();
				var realedate = REField.getValue();
				if( plansdate !=""){plansdate=plansdate.format('Y-m-d');}
				if( planedate !=""){planedate=planedate.format('Y-m-d');}
				if( realsdate !=""){realsdate=realsdate.format('Y-m-d');}
				if( realedate !=""){realedate=realedate.format('Y-m-d');}
				/*var brand1 = encodeURIComponent(brandField1.getValue());
				var spec1 = encodeURIComponent(specField1.getValue());
				var brand2 = encodeURIComponent(brandField2.getValue());
				var spec2 = encodeURIComponent(specField2.getValue());
				var brand3 = encodeURIComponent(brandField3.getValue());
				var spec3 = encodeURIComponent(specField3.getValue());
				var isaddedit = encodeURIComponent(addeditcomb.getValue());*/
				//brand1+"^"+spec1+"^"+brand2+"^"+spec2+"^"+brand3+"^"+spec3+"^"+ +"^"+isaddedit
		                                //var hospital = gethospField.getValue();
		                               // alert(hospital);
		        if((plansdate>planedate)||(realsdate>realedate)){
			        Ext.Msg.show({
				        title:'注意',
				        msg:'开始时间不能晚于结束时间！',
				        icon:Ext.MessageBox.INFO,
				        buttons:Ext.Msg.WARNING})
				       return;
			        }                 
		var data=code+"^"+name+"^"+year+"^"+budgdeptdr+"^"+deptdr+"^"+userdr+"^"+goal+"^"+property+"^"+isgovbuy+"^"+state+"^"+plansdate+"^"+planedate+"^"+realsdate+"^"+realedate+"^"+loginuser+"^"+hospid;
				Ext.Ajax.request({
				url:'herp.budg.budgprojectdictexe.csp?action=add&data='+data,
				waitMsg:'保存中...',
				failure: function(result, request){		
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){				
						Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
						itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize,userdr:loginuser}});
					}
					else
					{
						var message="";
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
