
 doedit=function(){
		//alert("3");
		// ���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		
		// ���岢��ʼ���ж��󳤶ȱ���
                
		var len = rowObj.length;
		
		
		
				//�ƻ���
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
	fieldLabel: '�ƻ���',
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
	
	
			//��������
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
	fieldLabel: '��������',
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
			//����
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
	fieldLabel: '����',
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
		
		//�����ڼ�
		var LocResultMainperiod = new Ext.form.TextField({
		id: 'LocResultMainperiod',
		fieldLabel: '�����ڼ�',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'LocResultMainperiod',
		minChars: 1,
		pageSize: 10,
		editable:true
	});

			//����
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
	fieldLabel: '����',
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



			//����������ϸ
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
	fieldLabel: '����������ϸ',
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


			//������Ϣ
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
	fieldLabel: '������Ϣ',
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
		
			//����
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
	fieldLabel: '����',
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
		fieldLabel: 'Ȩ��',
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
		fieldLabel: '�����',
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
		fieldLabel: '��ע',
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
		fieldLabel: 'ͼƬ����',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'LocResultdetailPicLink',
		minChars: 1,
		pageSize: 10,
		editable:true
	});


			//������
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
	fieldLabel: '������',
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
		fieldLabel: '����ʱ��',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'LocResultdetailsaveDate',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
				//ִ�п���
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
	fieldLabel: 'ִ�п���',
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
		fieldLabel: '���ϸ��ʾ',
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
		
		
// ���岢��ʼ�������޸İ�ť
   var editButton = new Ext.Toolbar.Button({
			text:'�����޸�'

		});
	
		// �����޸İ�ť��Ӧ����
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
				waitMsg:'������...',
				failure: function(result, request){
	
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK});
				
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){				
						Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
						//var pageNow=$("input[class='x-form-text x-form-field x-form-num-field x-tbar-page-number']").val();
						//var pageStartNum=(pageNow-1)*limit;
						//alert(pageStartNum);
						//dosearch(pageStartNum,limit);
						itemGrid.getStore().reload();
					}
					else
					{
						var message="�ظ����";
						Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
		
		
			});
			editwin.close();
		};
		
		// ��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click',editHandler,false);
	
		// ���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'ȡ���޸�'
		});
	
		// ����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			editwin.close();
		};
	
		// ���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		// ���岢��ʼ������
		var editwin = new Ext.Window({
			title: '�޸ļ�¼',
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
	
	// �ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			//�жϵ�ǰ��ʱ��Ϊ����
			var checkFlag = selectedcellfieldname.split("_")[0];
			if(checkFlag=="check"){
				if(rowObj[0].data.auditstate=="���"){
					Ext.Msg.show({title:'ע��',msg:'�Ѿ���ˣ������޸�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				
				if(selectedcell=="&nbsp;"||selectedcell==""){
					Ext.Msg.show({title:'ע��',msg:'δ���˼��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
						
					}
					// ������ʾ
		editwin.show();
			}else{
				Ext.Msg.show({title:'��ʾ',msg:'��λ�ò��Ǽ��㣬���ܽ����޸�',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			}
		}
		
		//alert("88");
	
	}

