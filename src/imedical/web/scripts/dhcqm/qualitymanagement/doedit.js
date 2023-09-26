
 doedit=function(){
		//alert("3");
		// 定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		
		// 定义并初始化行对象长度变量
                
		var len = rowObj.length;
		
		
		
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
			//科室
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
		
		//考核期间
		var LocResultMainperiod = new Ext.form.TextField({
		id: 'LocResultMainperiod',
		fieldLabel: '考核期间',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'LocResultMainperiod',
		minChars: 1,
		pageSize: 10,
		editable:true
	});

			//病区
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
							+'?action=ListwardDr&str='
							+ encodeURIComponent(Ext.getCmp('LocResultMainwardDr').getRawValue()),
						method : 'POST'
					});
		});
var LocResultMainwardDr = new Ext.form.ComboBox({
	id: 'LocResultMainwardDr',
	fieldLabel: '病区',
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
	name: 'LocResultMainwardDr',
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
							+'?action=ListCheck&str='
							+ encodeURIComponent(Ext.getCmp('LocResultdetailcheckDr').getRawValue()),
						method : 'POST'
					});
		});
var LocResultdetailcheckDr = new Ext.form.ComboBox({
	id: 'LocResultdetailcheckDr',
	fieldLabel: '检查点',
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
	name: 'LocResultdetailcheckDr',
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
	var LocResultdetailactValue = new Ext.form.TextArea({
		id: 'LocResultdetailactValue',
		fieldLabel: '检查结果',
		width:250,
		//listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'LocResultdetailactValue',
		minChars: 1,
		//pageSize: 10,
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
	allowBlank: false,
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
	allowBlank: false,
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
			labelWidth :80,
			items : [
			        // LocResultMainPlandr,
			        // LocResultMainschemDr,LocResultMaindepartDr,LocResultMainperiod,
					// LocResultMainwardDr,
					 //LocResultdetailsDetailDr,
					 //LocResultdetailJXPatDr,LocResultdetailcheckDr
					 //,LocResultdetailrate,
			        LocResultdetailactValue//,LocResultdetailtxtValue
			        //, LocResultdetailPicLink,
			        // LocResultdetailsaveUserDr,LocResultdetailsaveDate,LocResultdetailexdepartDr,LocResultdetaildisqua
					 ]
		});
		
		 formPanel.on('afterlayout', function(panel, layout){ 
			this.getForm().loadRecord(rowObj[0]);
		  	LocResultMainPlandr.setValue(rowObj[0].get("plandr"));
			LocResultMainschemDr.setValue(rowObj[0].get("schemename"));
			LocResultMaindepartDr.setValue(rowObj[0].get("desc"));
			LocResultMainperiod.setValue(rowObj[0].get("period"));
			
			LocResultMainwardDr.setValue(rowObj[0].get("warddr"));
			LocResultdetailsDetailDr.setValue(rowObj[0].get("sdetaildr"));
			LocResultdetailJXPatDr.setValue(rowObj[0].get("pname"));
			LocResultdetailcheckDr.setValue(selectedcellfieldname);
			
			LocResultdetailrate.setValue(rowObj[0].get("rate"));
			LocResultdetailactValue.setValue(selectedcell.split("*")[0]);
			//LocResultdetailtxtValue.setValue(selectedcell.split("||")[2]);
			LocResultdetailPicLink.setValue(rowObj[0].get("piclink"));
			
			LocResultdetailsaveUserDr.setValue(rowObj[0].get("saveuserdr"));
			LocResultdetailsaveDate.setValue(rowObj[0].get("savedate"));
			LocResultdetailexdepartDr.setValue(rowObj[0].get("exdepartdr"));
			LocResultdetaildisqua.setValue(rowObj[0].get("disqua"));
			}); 
		
		
// 定义并初始化保存修改按钮
   var editButton = new Ext.Toolbar.Button({
			text:'保存修改'

		});
	
		// 定义修改按钮响应函数
		editHandler = function(){
		
		/* 
            var rowObj=itemGrid.getSelectionModel().getSelections();
            var rowid = rowObj[0].get("locresultmainid");   
			// var Year = YearField1.getValue(); 
			*/
			/****************************************/
			
			        var rowObj=itemGrid.getSelectionModel().getSelections();
                    var rowid = rowObj[0].get("locresultmainid");
				
					var mainrowid = rowObj[0].get("parref");
					
					var detailrowid=selectedcell.split("*")[1];
					
					
					var plandr = LocResultMainPlandr.getValue();
					var schemdr = isNaN(LocResultMainschemDr.getValue())?'':LocResultMainschemDr.getValue();
					var departdr = isNaN(LocResultMaindepartDr.getValue())?'':LocResultMaindepartDr.getValue();
					var period = LocResultMainperiod.getValue();
					var warddr = isNaN(LocResultMainwardDr.getValue())?'':LocResultMainwardDr.getValue();
					
					var sdetaildr = LocResultdetailsDetailDr.getValue();
					var jxpatdr = isNaN(LocResultdetailJXPatDr.getValue())?'':LocResultdetailJXPatDr.getValue();
					var checkdr = isNaN(LocResultdetailcheckDr.getValue())?'':LocResultdetailcheckDr.getValue();
					var rate = LocResultdetailrate.getValue();
					var actvalue = LocResultdetailactValue.getValue();
					//alert(actvalue);
					var txtvalue = LocResultdetailtxtValue.getValue();
					var piclink = LocResultdetailPicLink.getValue();
					var saveuserdr = session['LOGON.USERID']; //LocResultdetailsaveUserDr.getValue();
					var savedate = LocResultdetailsaveDate.getValue();
					var exdepartdr = LocResultdetailexdepartDr.getValue();
					var disqua = LocResultdetaildisqua.getValue();
					var urlStr='../csp/dhc.qm.qualityinfomanagementexe.csp?action=edit'+
					//'&plandr='+plandr+'&detailrowid='+detailrowid+//isNaN(Number.parseInt(schemdr))?'':
					'&mainrowid='+mainrowid+
					//'&schemdr='+schemdr+
					//'&departdr='+departdr+'&period='+period+'&warddr='+warddr+
					'&detailrowid='+detailrowid+
					//'&sdetaildr='+sdetaildr+
					//'&jxpatdr='+jxpatdr+'&checkdr='+checkdr;
					//+'&rate='+rate+
					'&actvalue='+encodeURIComponent(actvalue)+'&txtvalue='+encodeURIComponent(txtvalue)+'&saveuserdr='+saveuserdr;
					//+'&piclink='+piclink+'&saveuserdr='+saveuserdr+'&savedate='+savedate+'&exdepartdr='+exdepartdr+'&disqua='+disqua,
					//alert(urlStr);
					Ext.Ajax.request({
					//url:'../csp/dhc.qm.qualityinfomanagementexe.csp?action=add&rowid='+selectedcell.spelit("||")[1]+'&parref='+parref+'&jxpatdr='+jxpatdr+'&checkdr='+checkdr/*+'&rate='+rate+'&actvalue='+actvalue+'&txtvalue='+txtvalue+'&piclink='+piclink+'&saveuserdr='+saveuserdr+'&exdepartdr='+exdepartdr+'&disqua='+disqua*/,
				url:urlStr,
				waitMsg:'保存中...',
				failure: function(result, request){
	
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK});
				
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){				
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
						//var pageNow=$("input[class='x-form-text x-form-field x-form-num-field x-tbar-page-number']").val();
						//var pageStartNum=(pageNow-1)*limit;
						//alert(pageStartNum);
						//dosearch(pageStartNum,limit);
						itemGrid.getStore().reload();
					}
					else
					{
						var message="重复添加";
						Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
		
		
			});
			editwin.close();
		};
		
		// 添加保存修改按钮的监听事件
		editButton.addListener('click',editHandler,false);
	
		// 定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
			text:'取消修改'
		});
	
		// 定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		};
	
		// 添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		// 定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改记录',
			width: 400,
			height:200,
			minWidth: 400, 
			minHeight: 100,
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
	
	// 判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			//判断当前的时候为检查点
			var checkFlag = selectedcellfieldname.split("_")[0];
			if(checkFlag=="check"){
				if(rowObj[0].data.auditstate=="审核"){
					Ext.Msg.show({title:'注意',msg:'已经审核，不能修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				
				if(selectedcell=="&nbsp;"||selectedcell==""){
					Ext.Msg.show({title:'注意',msg:'未做此检查!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
						
					}
					// 窗口显示
		editwin.show();
			}else{
				Ext.Msg.show({title:'提示',msg:'该位置不是检查点，不能进行修改',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			}
		}
		
		//alert("88");
	
	}

