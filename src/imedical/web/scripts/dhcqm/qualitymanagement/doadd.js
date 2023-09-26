doadd = function() {

var userID=session['LOGON.USERID'];	
				//计划表
var JournalDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
JournalDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.qm.qualityinfomanagementexe.csp'
							+'?action=ListPlandr&str='
							+ encodeURIComponent(Ext.getCmp('LocResultMainPlandr').getRawValue()),
						method : 'POST'
					});
		});
var LocResultMainPlandr = new Ext.form.ComboBox({
	id: 'LocResultMainPlandr',
	fieldLabel: '计划表',
	width:200,
	listWidth : 220,
	allowBlank: false,
	store: JournalDs,
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	typeAhead : true,
	//triggerAction : 'all',
	emptyText : '',
	name: 'LocResultMainPlandr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});
			//质量方案
var JournalDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
JournalDs.on('beforeload', function(ds, o) {
		
		ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.qm.qualityinfomanagementexe.csp'
							+'?action=ListschemDr&str='
							+ encodeURIComponent(Ext.getCmp('LocResultMainschemDr').getRawValue())+'&userid='+userid,
						method : 'POST'
					});
		});
var LocResultMainschemDr = new Ext.form.ComboBox({
	id: 'LocResultMainschemDr',
	fieldLabel: '质量方案',
	width:200,
	listWidth : 220,
	allowBlank: false,
	store: JournalDs,
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	typeAhead : true,
	//triggerAction : 'all',
	emptyText : '',
	name: 'LocResultMainschemDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});
LocResultMainschemDr.addListener('select',function(){
	checkDs.load({params:{start:0,limit:10,schemdr:LocResultMainschemDr.getValue()}});
});
var JournalDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid','deptGroupCode','deptGroupName'])
		});
		
JournalDs.on('beforeload', function(ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.qm.qualityinfomanagementexe.csp'
							+'?action=ListdepartDr&str='
							+ encodeURIComponent(Ext.getCmp('LocResultMaindepartDr').getRawValue()),
						method : 'POST'
					});
		});
var LocResultMaindepartDr = new Ext.form.ComboBox({
	id: 'LocResultMaindepartDr',
	fieldLabel: '科室',
	width:200,
	listWidth : 220,
	allowBlank: false,
	store: JournalDs,
	displayField: 'deptGroupName',
	valueField: 'rowid',
	triggerAction: 'all',
	typeAhead : true,
	//triggerAction : 'all',
	emptyText : '',
	name: 'LocResultMaindepartDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});
LocResultMaindepartDr.addListener('select',function(){
	wardDs.load({params:{start:0,limit:10,dept:LocResultMaindepartDr.getValue()}});
});
		
		//考核期间
//	var LocResultMainperiod = new Ext.form.DateField({
//		id: 'LocResultMainperiod',
//		fieldLabel: '考核期间',
//		width:200,
//		listWidth : 245,
//		triggerAction: 'all',
//		emptyText:'',
//		name: 'LocResultMainperiod',
//		format:"Ym",
//		value:"Ym",
//		minChars: 1,
//		pageSize: 10,
//		editable:true
//	});
//	
//	var periodTypeStore = new Ext.data.SimpleStore({
//		fields: ['key','keyValue'],
//		data:[['M','月'],['Q','季']]
//	});
//	var periodTypeField = new Ext.form.ComboBox({
//		id: 'innerperiodTypeField',
//		fieldLabel: '期间类型',
//		width:50,
//		listWidth : 200,
//		selectOnFocus: true,
//		allowBlank: false,
//		store: periodTypeStore,
//		anchor: '90%',
//		value:'M', //默认值
//		valueNotFoundText:'',
//		displayField: 'keyValue',
//		valueField: 'key',
//		triggerAction: 'all',
//		emptyText:'选择期间类型...',
//		mode: 'local', //本地模式
//		editable:false,
//		pageSize: 10,
//		minChars: 1,
//		selectOnFocus: true,
//		forceSelection: true
//	});

	var yearField = new Ext.form.TextField({
		id: 'aadyearField',
		fieldLabel:'年份',
		width:200,
		//regex: /^\d{4}$/,
		regexText:'年份为四位数字',
		//allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'yearField',
		value:(new Date()).getFullYear(),
		minChars: 1,
		pageSize: 10,
		editable:true
	});

	var periodTypeStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data:[['M','月'],['Q','季']]
	});
	var periodTypeField = new Ext.form.ComboBox({
		id: 'addperiodTypeField',
		fieldLabel: '期间类型',
		width:200,
		listWidth : 220,
		selectOnFocus: true,
		allowBlank: false,
		store: periodTypeStore,
		//anchor: '90%',
		value:'M', //默认值
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'选择期间类型...',
		mode: 'local', //本地模式
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	periodTypeField.on("select",function(cmb,rec,id){
		if(cmb.getValue()=="M"){
			data=[['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],['10','10月'],['11','11月'],['12','12月']];
		}
		if(cmb.getValue()=="Q"){
			data=[['01','01季度'],['02','02季度'],['03','03季度'],['04','04季度']];
		}
		if(cmb.getValue()=="H"){
			data=[['01','1~6上半年'],['02','7~12下半年']];
		}
		if(cmb.getValue()=="Y"){
			data=[['00','全年']];
		}
		periodStore.loadData(data);
	});
	periodStore = new Ext.data.SimpleStore({
		fields:['key','keyValue']
	});
	periodStore.loadData([['01','01月'],['02','02月'],['03','03月'],['04','04月'],['05','05月'],['06','06月'],['07','07月'],['08','08月'],['09','09月'],['10','10月'],['11','11月'],['12','12月']]);
	var periodField = new Ext.form.ComboBox({
		id: 'addperiodField',
		fieldLabel: '期间',
		value:(new Date()).getMonth()<10?"0"+((new Date()).getMonth()+1):((new Date()).getMonth()+1),
		width:200,
		listWidth : 220,
		selectOnFocus: true,
		//allowBlank: false,
		//allowBlank: false,
		store: periodStore,
		//anchor: '90%',
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'请选择...',
		mode: 'local', //本地模式
		editable:false,
		pageSize: 12,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});	
	

			//病区
var wardDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'deptGroupDr', 'wardCode', 'wardName'])
		});
		
wardDs.on('beforeload', function(ds, o) {
	var deptdr=LocResultMaindepartDr.getValue();
		if(deptdr==""){
			
			Ext.Msg.show({title:'错误',msg:'请先选择科室',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return ;
		}
	
	
		ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.qm.qualityinfomanagementexe.csp'
							+'?action=ListwardDr&str='
							+ encodeURIComponent(Ext.getCmp('LocResultwardDr').getRawValue())+'&dept='+deptdr,
						method : 'POST'
					});
		});

var LocResultwardDr = new Ext.form.ComboBox({
	id: 'LocResultwardDr',
	fieldLabel: '病区',
	width:200,
	listWidth : 220,
	//allowBlank: false,
	store: wardDs,
	displayField: 'wardName',
	valueField: 'rowid',
	triggerAction: 'all',
	typeAhead : true,
	//triggerAction : 'all',
	emptyText : '',
	name: 'LocResultwardDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});



			//质量方案明细
var JournalDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
JournalDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.qm.qualityinfomanagementexe.csp'
							+'?action=ListJXPat&str='
							+ encodeURIComponent(Ext.getCmp('LocResultdetailsDetailDr').getRawValue()),
						method : 'POST'
					});
		});
var LocResultdetailsDetailDr = new Ext.form.ComboBox({
	id: 'LocResultdetailsDetailDr',
	fieldLabel: '质量方案明细',
	width:200,
	listWidth : 220,
	allowBlank: false,
	store: JournalDs,
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	typeAhead : true,
	//triggerAction : 'all',
	emptyText : '',
	name: 'LocResultdetailsDetailDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});


			//病人信息
var JournalDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
JournalDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.qm.qualityinfomanagementexe.csp'
							+'?action=ListJXPat&str='
							+ encodeURIComponent(Ext.getCmp('LocResultdetailJXPatDr').getRawValue()),
						method : 'POST'
					});
		});
var LocResultdetailJXPatDr = new Ext.form.ComboBox({
	id: 'LocResultdetailJXPatDr',
	fieldLabel: '病人信息',
	width:200,
	listWidth : 220,
	allowBlank: false,
	store: JournalDs,
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	typeAhead : true,
	//triggerAction : 'all',
	emptyText : '',
	name: 'LocResultdetailJXPatDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});
		
			//检查点
var checkDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
checkDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.qm.qualityinfomanagementexe.csp'
							+'?action=ListCheck&str='
							+ encodeURIComponent(Ext.getCmp('LocResultDetailcheck').getRawValue())+'&schemdr='+LocResultMainschemDr.getValue(),
						method : 'POST'
					});
		});
var LocResultDetailcheck = new Ext.form.ComboBox({
	id: 'LocResultDetailcheck',
	fieldLabel: '检查点',
	width:200,
	listWidth : 220,
	allowBlank: false,
	store: checkDs,
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	typeAhead : true,
	//triggerAction : 'all',
	emptyText : '',
	name: 'LocResultDetailcheck',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});

	var LocResultdetailrate = new Ext.form.TextField({
		id: 'LocResultdetailrate',
		fieldLabel: '权重',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'LocResultdetailrate',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var LocResultdetailactValue = new Ext.form.TextField({
		id: 'LocResultdetailactValue',
		fieldLabel: '检查结果',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'LocResultdetailactValue',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var LocResultdetailtxtValue = new Ext.form.TextField({
		id: 'LocResultdetailtxtValue',
		fieldLabel: '备注',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'LocResultdetailtxtValue',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var LocResultdetailPicLink = new Ext.form.TextField({
		id: 'LocResultdetailPicLink',
		fieldLabel: '图片链接',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'LocResultdetailPicLink',
		minChars: 1,
		pageSize: 10,
		editable:true
	});


			//保存人
var JournalDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
JournalDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						
						url : '../csp/dhc.qm.qualityinfomanagementexe.csp'
							+'?action=ListSSUSR&str='
							+ encodeURIComponent(Ext.getCmp('LocResultdetailsaveUserDr').getRawValue()),
						method : 'POST'
					});
		});
    var LocResultdetailsaveUserDr = new Ext.form.ComboBox({
	id: 'LocResultdetailsaveUserDr',
	fieldLabel: '保存人',
	width:200,
	listWidth : 220,
	//allowBlank: false,
	store: JournalDs,
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	typeAhead : true,
	//triggerAction : 'all',
	emptyText : '',
	name: 'LocResultdetailsaveUserDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});

	var LocResultdetailsaveDate = new Ext.form.TextField({
		id: 'LocResultdetailsaveDate',
		fieldLabel: '保存时间',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'LocResultdetailsaveDate',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
				//执行科室
var JournalDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
JournalDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({

						url : '../csp/dhc.qm.qualityinfomanagementexe.csp'
							+'?action=ListDEP&str='
							+ encodeURIComponent(Ext.getCmp('LocResultdetailexdepartDr').getRawValue()),method : 'POST'
					});
		});
var LocResultdetailexdepartDr = new Ext.form.ComboBox({
	id: 'LocResultdetailexdepartDr',
	fieldLabel: '执行科室',
	width:200,
	listWidth : 220,
	//allowBlank: false,
	store: JournalDs,
	displayField: 'name',
	valueField: 'rowid',
	triggerAction: 'all',
	typeAhead : true,
	//triggerAction : 'all',
	emptyText : '',
	name: 'LocResultdetailexdepartDr',
	pageSize: 10,
	minChars: 1,
	forceSelection : true,
	selectOnFocus:true,
    editable:true
		});

	var LocResultdetaildisqua = new Ext.form.TextField({
		id: 'LocResultdetaildisqua',
		fieldLabel: '不合格标示',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'LocResultdetaildisqua',
		minChars: 1,
		pageSize: 10,
		editable:true
	});



	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [
			         //LocResultMainPlandr,
			         LocResultMainschemDr,LocResultMaindepartDr,
			         //LocResultMainperiod,
			         //periodTypeField,
			         yearField,periodTypeField,periodField,
					 LocResultwardDr,
					 //LocResultdetailsDetailDr,LocResultdetailJXPatDr,
					 LocResultDetailcheck,
			        // LocResultdetailrate,
					 LocResultdetailactValue//,LocResultdetailtxtValue
					 //, LocResultdetailPicLink,
			        // LocResultdetailsaveUserDr,LocResultdetailsaveDate,LocResultdetailexdepartDr,LocResultdetaildisqua
					 ]
		});
	
	var addWin = new Ext.Window({
		    
			title : '添加',
			width : 400,
			height : 310,
			layout : 'fit',
			plain : true,
			//modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '保存',
				handler : function() {
					
					if (formPanel.form.isValid()) {
						
						year=yearField.getValue();
						var pattern=/^\d{4}$/;
						if(pattern.test(year)==false){
							Ext.Msg.show({title:'注意',msg:'年份格式请输入四位有效数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
							return null;}
						
					var plandr = LocResultMainPlandr.getValue();
					var schemdr = LocResultMainschemDr.getValue();
					var departdr = LocResultMaindepartDr.getValue();
					var period = yearField.getValue()+''+periodField.getValue();
					//var periodtype=innerperiodTypeField.getValue();
					var warddr = LocResultwardDr.getValue();
					//var parref = LocResultMainPlandr.getValue();
					var sdetaildr = LocResultdetailsDetailDr.getValue();
					var jxpatdr = LocResultdetailJXPatDr.getValue();
					var checkdr = LocResultDetailcheck.getValue();
					var rate = LocResultdetailrate.getValue();
					var actvalue = encodeURIComponent(LocResultdetailactValue.getValue());
					var txtvalue = encodeURIComponent(LocResultdetailtxtValue.getValue());
					var piclink = LocResultdetailPicLink.getValue();
					var saveuserdr = userID; //LocResultdetailsaveUserDr.getValue();
					var savedate = LocResultdetailsaveDate.getValue();
					var exdepartdr = LocResultdetailexdepartDr.getValue();
					var disqua = LocResultdetaildisqua.getValue();

			
					Ext.Ajax.request({
					url:'../csp/dhc.qm.qualityinfomanagementexe.csp?action=add&plandr='+plandr+'&schemdr='+schemdr
						+'&departdr='+departdr+'&period='+period+'&warddr='+warddr+'&sdetaildr='+sdetaildr+'&saveuserdr='+saveuserdr
						//+'&jxpatdr='+jxpatdr
						+'&checkdr='+checkdr
						//+'&rate='+rate
						+'&actvalue='+actvalue//+'&txtvalue='+txtvalue
						//+'&piclink='+piclink+'&saveuserdr='+saveuserdr+'&savedate='+savedate+'&exdepartdr='+exdepartdr
						//+'&disqua='+disqua
						,
					//waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:function(){
							dosearch(start,limit,year,periodTypeField.getValue(),periodField.getValue());	}});					
							
							//itemGrid.getStore().load();
						}
						else
						{
							var message="重复添加";
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  //addWin.close();
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
