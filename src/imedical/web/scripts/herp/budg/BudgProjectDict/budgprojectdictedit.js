budgprojectdictEditFun = function(loginuser) {
	var hospital1 = session['LOGON.HOSPID'];
	var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
    var rowObj=itemGrid.getSelectionModel().getSelections();
    
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要修改的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{          
	                var tmphospital = rowObj[0].get("CompName");
	                //alert(tmphospital);
	              
		var rowid = rowObj[0].get("rowid");
		//alert(rowid);
		var tmpyear =rowObj[0].get("year");
		//alert(tmpyear);
		var tmpdeptdr =rowObj[0].get("deptdr");
		var tmpuserdr =rowObj[0].get("userdr");
		var tmpproperty =rowObj[0].get("property");
		var tmpisgovbuy =rowObj[0].get("isgovbuy");
		var tmpstate =rowObj[0].get("state");
		/*var tmpbrand1=rowObj[0].get("brand1");
		var tmpspec1=rowObj[0].get("spec1");
		var tmpbrand2=rowObj[0].get("brand2");
		var tmpspec2=rowObj[0].get("spec2");
		var tmpbrand3=rowObj[0].get("brand3");
		var tmpspec3=rowObj[0].get("spec3");
		var tmpisaddedit=rowObj[0].get("isaddedit");*/
		var tmpbdeptdr=rowObj[0].get("budgDeptDR");
		
	}
	
	//获取医疗单位
	var gethospDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});	
	gethospDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl+'?action=hospital&rowid='+hospid+'',method:'POST'});
	});	
	var gethospField = new Ext.form.ComboBox({
		id: 'gethospField',
		fieldLabel: '医疗单位',
		width:200,
		listWidth : 250,
		allowBlank: false,
		store: gethospDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择医疗单位...',
		//valueNotFoundText: CompName,  
		name: 'gethospField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	gethospField.on('select',function(combo, record, index){
		tmphospital = combo.getValue();
		
	});
	

    
    
    var CodeField = new Ext.form.TextField({
				id : 'CodeField',
				fieldLabel : '项目编号',
				allowBlank : false,
				emptyText : '必填',
				anchor : '80%',
				update:true,
				disabled:true	//不允许编辑
			});

	var NameField = new Ext.form.TextField({
				id : 'NameField',
				fieldLabel : '项目名称',
				allowBlank : false,
				emptyText : '必填',
				anchor : '80%'
			});
  var GoalField = new Ext.form.TextField({
			    id : 'GoalField',
				fieldLabel : '项目说明',
				//allowBlank : false,
				emptyText : '',
				anchor : '80%'
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
		listWidth : 200,
		anchor: '80%',
		allowBlank: false,
		update:true,
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
	
	yearlistField.on('select',function(combo, record, index){
		tmpyear = combo.getValue();
	});
	
	//获取预算科室名称
	var deptnameBs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
	
	deptnameBs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl+'?action=dept&str='+encodeURIComponent(Ext.getCmp('BudgdeptNameField').getRawValue()),method:'POST'});
	});
	
	var BudgdeptNameField = new Ext.form.ComboBox({
		id: 'BudgdeptNameField',
		fieldLabel: '预算科室',
		listWidth : 240,
		allowBlank: false,
		store: deptnameBs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择科室...',
		name: 'BudgdeptNameField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
        anchor: '80%'
	});
	
	BudgdeptNameField.on('select',function(combo, record, index){
		tmpbdeptdr = combo.getValue();
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
		listWidth : 240,
		allowBlank: false,
		store: deptnameDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择科室...',
		name: 'deptnameField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
        anchor: '80%'
	});
	
	deptnameField.on('select',function(combo, record, index){
		tmpdeptdr = combo.getValue();
	});
	
	//负责人
	var userDs = new Ext.data.Store({
	atLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
    });

	userDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl+'?action=username&str='+encodeURIComponent(Ext.getCmp('userField').getRawValue()),method:'POST'});
	});
	var userField = new Ext.form.ComboBox({
		id: 'userField',
		fieldLabel: '人员名称',
		listWidth : 240,
		anchor: '80%',
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
		editable:true
	});
	
	userField.on('select',function(combo, record, index){
		tmpuserdr = combo.getValue();
	});
	
		
	//获取项目性质
	var proStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['1','一般性项目'],['2','基建项目'],['3','科研项目']]
	});
	var procomb = new Ext.form.ComboBox({
		id: 'procomb',
		fieldLabel: '项目性质',
		listWidth : 200,
		allowBlank: false,
		store: proStore,
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'选择期间类型...',
		mode: 'local', //本地模式
		selectOnFocus:true,
		forceSelection:true,
		anchor: '80%'
	});
	
	procomb.on('select',function(combo, record, index){
		tmpproperty = combo.getValue();
	});

	//政府采购
	var govbuyStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['1','是'],['2','否']]
	});
	var govbuycomb = new Ext.form.ComboBox({
		id: 'govbuycomb',
		fieldLabel: '政府采购',
		listWidth : 200,
		anchor: '80%',
		store: govbuyStore,
		displayField: 'keyValue',
		valueField: 'key',
		mode : 'local',
		triggerAction: 'all',
		emptyText:'选择期间类型...',
		selectOnFocus:true,
		forceSelection : true,
		anchor: '80%'		
	});
	
	govbuycomb.on('select',function(combo, record, index){
		tmpisgovbuy = combo.getValue();
	});
	
	//项目状态
	var pstateStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['1','新建'],['2','执行'],['3','完成'],['4','取消']]
	});
	var pstatecomb = new Ext.form.ComboBox({
		id: 'pstatecomb',
		fieldLabel: '项目状态',
		//width:200,
		listWidth : 200,
		anchor: '80%',
		store: pstateStore,
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'选择期间类型...',
		mode: 'local', //本地模式
		selectOnFocus:true,
		forceSelection:true,
		anchor: '80%'
	});
		
	pstatecomb.on('select',function(combo, record, index){
		tmpstate = combo.getValue();
	});
	
    //推荐品牌
    var brandField1 = new Ext.form.TextField({
				id : 'brandField1',
				fieldLabel : '推荐品牌1',
				//allowBlank : false,
				emptyText : '',
				anchor : '80%',
				update:true
			});
	var specField1 = new Ext.form.TextField({
				id : 'specField1',
				fieldLabel : '规格型号1',
				//allowBlank : false,
				emptyText : '',
				anchor : '80%',
				update:true
			});		
	var brandField2 = new Ext.form.TextField({
				id : 'brandField2',
				fieldLabel : '推荐品牌2',
				//allowBlank : false,
				emptyText : '',
				anchor : '80%',
				update:true
			});
	var specField2 = new Ext.form.TextField({
				id : 'specField2',
				fieldLabel : '规格型号2',
				//allowBlank : false,
				emptyText : '',
				anchor : '80%',
				update:true
			});			
	var brandField3 = new Ext.form.TextField({
				id : 'brandField3',
				fieldLabel : '推荐品牌3',
				//allowBlank : false,
				emptyText : '',
				anchor : '80%',
				update:true
			});
	var specField3 = new Ext.form.TextField({
				id : 'specField3',
				fieldLabel : '规格型号3',
				//allowBlank : false,
				emptyText : '',
				anchor : '80%',
				update:true
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
    //xycadd,新增或更新
	/*var addeditStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['1','新增'],['2','更新']]
	});
	var addeditcomb = new Ext.form.ComboBox({
		id: 'addeditcomb',
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
	});     
	addeditcomb.on('select',function(combo, record, index){
		tmpisaddedit = combo.getValue();
	});*/
	//定义并初始化面板
	var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [gethospField,CodeField, NameField,
							yearlistField, BudgdeptNameField, deptnameField, userField,GoalField,
							procomb, govbuycomb,pstatecomb ,PSField,PEField,RSField,REField
							//FileDescField,alertField
							/*brandField1,specField1,brandField2,specField2,brandField3,specField3,addeditcomb*/]
				});
				                                                                                            //
    //面板加载
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                              //
	this.getForm().loadRecord(rowObj[0]);
	gethospField.setValue(rowObj[0].get("CompName"));    
	CodeField.setValue(rowObj[0].get("code"));
	NameField.setValue(rowObj[0].get("name"));
                yearlistField.setValue(rowObj[0].get("yearlist"));
                BudgdeptNameField.setValue(rowObj[0].get("bdeptname"));	
	deptnameField.setValue(rowObj[0].get("deptname"));	
	userField.setValue(rowObj[0].get("username"));
	GoalField.setValue(rowObj[0].get("goal"));	
	procomb.setValue(rowObj[0].get("propertylist"));
	govbuycomb.setValue(rowObj[0].get("isgovbuylist"));	
	pstatecomb.setValue(rowObj[0].get("statelist"));
	PSField.setValue(rowObj[0].get("plansdate"));	
	PEField.setValue(rowObj[0].get("planedate"));
	RSField.setValue(rowObj[0].get("realsdate"));	
	REField.setValue(rowObj[0].get("realedate"));
	//FileDescField.setValue(rowObj[0].get("filedesc"));	                                                                                               //
    //alertField.setValue(rowObj[0].get("alert"));	  
    /*brandField1.setValue(rowObj[0].get("brand1"));
    specField1.setValue(rowObj[0].get("spec1"));
    brandField2.setValue(rowObj[0].get("brand2"));
    specField2.setValue(rowObj[0].get("spec2"));
    brandField3.setValue(rowObj[0].get("brand3"));
    specField3.setValue(rowObj[0].get("spec3"));
    addeditcomb.setValue(rowObj[0].get("isaddedit"))*/
    });   
    
    //定义并初始化保存修改按钮
    var editButton = new Ext.Toolbar.Button({
			text:'保存'

		});                                                                                                                                            //
                    
           //定义修改按钮响应函数
	    editHandler = function(){

        var rowObj=itemGrid.getSelectionModel().getSelections();
        var rowid = rowObj[0].get("rowid");          
		var store = itemGrid.getStore();
		var dataindex = store.indexOf(rowObj[0]);//获取行号
		//alert(dataindex);
	                var code = CodeField.getValue();
	                
		var name = encodeURIComponent(NameField.getValue());
		var year = tmpyear;
		///var hospital1= tmphospital;
		//alert(hospital1);
		var bdeptdr = tmpbdeptdr;
		var deptdr = tmpdeptdr; 
		//alert(deptdr);
		var userdr = tmpuserdr; 
		var goal = encodeURIComponent(GoalField.getRawValue());
		var property = tmpproperty; 
		var isgovbuy = tmpisgovbuy; 
		var state = tmpstate; 
		//var filedesc = encodeURIComponent(FileDescField.getRawValue());
		//var alert = encodeURIComponent(alertField.getValue());
		var plansdate = PSField.getValue();
		var planedate = PEField.getValue();
		var realsdate = RSField.getValue();
		var realedate = REField.getValue();
		if( plansdate !=""){plansdate=plansdate.format('Y-m-d');}
		if( planedate !=""){planedate=planedate.format('Y-m-d');}
		if( realsdate !=""){realsdate=realsdate.format('Y-m-d');}
		if( realedate !=""){realedate=realedate.format('Y-m-d');}
		/*var brand1 = encodeURIComponent(brandField1.getRawValue());
		var spec1 = encodeURIComponent(specField1.getRawValue());
		var brand2 = encodeURIComponent(brandField2.getRawValue());
		var spec2 = encodeURIComponent(specField2.getRawValue());
		var brand3 = encodeURIComponent(brandField3.getRawValue());
		var spec3 = encodeURIComponent(specField3.getRawValue());*/
		//var isaddedit = tmpisaddedit;
		  if((plansdate>planedate)||(realsdate>realedate)){
			        Ext.Msg.show({
				        title:'注意',
				        msg:'开始时间不能晚于结束时间！',
				        icon:Ext.MessageBox.INFO,
				        buttons:Ext.Msg.WARNING})
				       return;
			        }           
		//alert(rowid+code+name+year+deptdr+userdr+goal+property+isgovbuy+state+plansdate+planedate+realsdate+realedate+filedesc);

                Ext.Ajax.request({
				url:'herp.budg.budgprojectdictexe.csp?action=edit&rowid='+rowid+'&code='+code+'&name='+name
				+'&year='+year+'&bdeptdr='+bdeptdr+'&deptdr='+deptdr+'&plansdate='+plansdate+'&planedate='+planedate+'&realsdate='+realsdate+'&realedate='+realedate+'&userdr='+userdr+'&goal='+goal+'&property='+property
				+'&isgovbuy='+isgovbuy+'&state='+state
				+'&loginuser='+loginuser+'&hospital1='+hospital1,
				//+'&brand1='+brand1+'&spec1='+spec1+'&brand2='+brand2+'&spec2='+spec2+'&brand3='+brand3+'&spec3='+spec3+'&isaddedit='+isaddedit
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize,userdr:loginuser}});				
					itemGrid.store.on("load",function(){ 
					        itemGrid.getSelectionModel().selectRow(dataindex,true);

					 });
				}
				else
					{
						var message="";
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
			text:'取消'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改记录',
			width : 400,
			height : 480,    
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
	};