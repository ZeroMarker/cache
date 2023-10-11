AddFun = function(itemDetail,projDr,projName,userid,Username,deptdr,deptname,year){

//itemDetail,Username,userid,FundBillDR,projDr,Name,deptdr,deptname,ApplBillCode,year
var statetitle = projName +"֧������";

/////////////��������////////////////
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			disabled: true,
			selectOnFocus : true
		});

/////////////////////��Ŀ����/////////////////////////
var projnameCombo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: projName,
			disabled: true,
			selectOnFocus : true
		});
/*
/////////////////////������/////////////////////////
var appuName = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: Username,
			disabled: true,
			selectOnFocus : true
		});*/
///////////////������////////////////////////
var appuDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

appuDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.expenseaccountdetailexe.csp?action=userlist',
						method : 'POST'
					});
		});

var appuName = new Ext.form.ComboBox({
			fieldLabel : '������',
			store : appuDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
		});		
/////////////////////����˵��/////////////////////////
 Descfield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			selectOnFocus : true

		});		
/*

/////////////////////�������/////////////////////////
var dnamefield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: deptname,
			disabled: true,
			selectOnFocus : true

		});
		*/
///////////////��������////////////////////////
var dnameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

dnameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgctrlfundbillmngexe.csp?action=deptlist&flag=2',
						method : 'POST'
					});
		});

var dnamefield = new Ext.form.ComboBox({
			fieldLabel : '��������',
			store : dnameDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
		});		
/////////////�ʽ����뵥//////////// 
var applyDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'namedesc'])
});

applyDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgprojclaimapplynos.csp?action=billcode&projDr='+projDr,
				method : 'POST'
			});
});

 applyCombo = new Ext.form.ComboBox({
	fieldLabel : '�ʽ����뵥',
	store : applyDs,
	displayField : 'namedesc',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 90,
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true
});
applyCombo.on('focus', function(f){
				/*var state=stateField.getValue();
				if (state!="1"){
					Ext.Msg.show({title:'����',msg:'�û�״̬������Ч������ͬ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;}*/
				AddReqFun(applyCombo);
			});	

///////////////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	height : 120,
	region : 'north',
	frame : true,
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:120%">��Ŀ֧������</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '��������:',
					columnWidth : .12
				}, applyNo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '��Ŀ����:',
					columnWidth : .12
				},projnameCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '������:',
					columnWidth : .12
				}, appuName

		]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '����˵��:',
					columnWidth : .12
				}, Descfield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '�������:',
					columnWidth : .12
				},dnamefield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '�ʽ����뵥:',
					columnWidth : .12
				}, applyCombo

		]
	}]
});

var del = function() {

	Ext.Ajax.request({
		url: '../csp/herp.budg.budgprojclaimapplyaddexe.csp?action=Del',
				waitMsg : '������...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
					}
				},
				scope : this
			});
}


///////////////////// ��ǰԤ����� ///////////////////////////
var budgbalanceDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['name', 'name'])
});

budgbalanceDs.on('beforeload', function(ds, o){
	var code=codeCombo.getValue();	
	if(!code)
	{
		Ext.Msg.show({title:'ע��',msg:'����ѡ��Ԥ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}	
});

var budgbalanceCombo = new Ext.form.ComboBox({
	fieldLabel : '��ǰԤ�����',
	store : budgbalanceDs,
	displayField : 'name',
	valueField : 'name',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 70,
	listWidth : 225,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});

///////////////// Ԥ���� /////////////////
var codeDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['code', 'name'])
});

codeDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgprojclaimapplynos.csp?action=itemcode&projDr='+projDr,
				method : 'POST'
			});
});

 codeCombo = new Ext.form.ComboBox({
	fieldLabel : 'Ԥ����',
	store : codeDs,
	displayField : 'name',
	valueField : 'code',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 70,
	listWidth : 225,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true,
	listeners:{
            "select":function(combo,record,index){
	            budgbalanceDs.removeAll();     
							budgbalanceCombo.setValue('');
							budgbalanceDs.proxy = new Ext.data.HttpProxy({url:'herp.budg.budgprojclaimapplynos.csp?action=budgbalance&itemcode='+combo.value+'&projDr='+projDr+'&year='+year,method:'POST'})  
							budgbalanceDs.load({params:{start:0,limit:10}});           					
				}
	}
});

////////// ���α������� ����¼�� ///////////////////
var valueField = new Ext.form.TextField({
	id: 'valueField',
	width:215,
	listWidth : 215,
	name: 'valueField',
	regex : /^(-?\d+)(\.\d+)?$/,
	regexText : "ֻ����������",
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////��Ӱ�ť////////////////////////////
var saveButton = new Ext.Toolbar.Button({
	text: '����',
  tooltip:'���',        
  iconCls: 'save',
	handler:function(){
	if(Descfield.getValue()=="")
			{
				Ext.Msg.show({
						title : 'ע��',
						msg : '�����뱨��˵��',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
			}
			
			/*if(applyCombo.getValue()=="")
			{
				Ext.Msg.show({
						title : 'ע��',
						msg : '����ѡ��������Ҫ�������ʽ����뵥!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
			}*/
			
	AddFun1();			//�������뵥�ݹ������
	}
	
});

/////////////// ��Ŀ֧����ϸ�� //////////////////////////
var adddetailGrid = new dhc.herp.Gridapplyadddetail({
				width : 600,
				height : 150,
				region : 'south',
				url : 'herp.budg.budgprojclaimapplyaddexe.csp',				
				fields : [
						{
							header : '֧����ϸID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'itemcode',
							header : 'Ԥ����(����)',
							dataIndex : 'itemcode',
							width : 60,
							editable:true,
							hidden : true
						},{
							id : 'Name',
							header : 'Ԥ����',
							dataIndex : 'Name',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							width: 225,
							allowBlank: true,
							editable:true,
							type:codeCombo
						},{
							id : 'budgreal',
							header : '��ǰԤ�����',
							dataIndex : 'budgreal',
							align:'right',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							width: 225,
							editable:true,
							type:budgbalanceCombo
						},{
							id : 'reqpay',
							header : '���α�������',
							dataIndex : 'reqpay',
							align:'right',
							width : 120,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							editable:true,
							type:valueField
						},{
							id : 'actpay',
							header : '����֧��',
							align:'right',
							dataIndex : 'actpay',
							width : 120,
							editable:false

						},{
							id : 'ddesc',
							header : '˵��',
							dataIndex : 'ddesc',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
								cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
								return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
								},
							width : 120,
							editable:true

						},{
							id : 'budgco',
							header : 'ִ��Ԥ�����',
							dataIndex : 'budgco',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgcotrol',
							header : 'Ԥ�����',
							dataIndex : 'budgcotrol',
							width : 100,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['budgcotrol']
							if (sf == "����Ԥ��") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
							editable:false

						}],
						loadMask : true
			});

adddetailGrid.btnSaveHide();
adddetailGrid.addButton(saveButton);
 

var addmainGrid = new dhc.herp.GridapplyaddMain({
				width : 600,
				region : 'center',
				url : 'herp.budg.budgprojclaimapplyaddexe.csp',
				fields : [
				{
							header : '֧����������ID',
							width : 100,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'budgtotal',
							header : '��Ŀ��Ԥ��',
							dataIndex : 'budgtotal',
							width : 120,
							align:'right',
							editable:false
						},{
							id : 'reppay',
							header : '�����ʽ�',
							dataIndex : 'reppay',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'actpaywait',
							header : '��;����',
							dataIndex : 'actpaywait',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'actpay',
							header : '��ִ��Ԥ��',
							dataIndex : 'actpay',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgcur',
							header : '��ǰԤ�����',
							dataIndex : 'budgcur',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'actpaycur',
							header : '���α���',
							dataIndex : 'actpaycur',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgco',
							header : 'ִ�к�Ԥ�����',
							dataIndex : 'budgco',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgcontrol',
							header : 'Ԥ�����',
							dataIndex : 'budgcontrol',
							width : 100,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['budgcontrol']
							if (sf == "����Ԥ��") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
							editable:false

						},{
							id : 'FundBillDR',
							header : '��������Ӧ���ʽ����뵥ID',
							dataIndex : 'FundBillDR',
							align:'right',
							width : 120,
							editable:false,
							hidden : true

						}],
						viewConfig : {forceFit : true}
			}
);

	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({ text : '�ر�'});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function(){ 
	  itemDetail.load({params:{start:0, limit:12,userid:userid,projdr:projDr}});
	  window.close();
	};

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click',cancelHandler, false);
	
	
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [queryPanel,addmainGrid,adddetailGrid]
			});

	var tabPanel =  new Ext.Panel({
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,addmainGrid,adddetailGrid]                                 //���Tabs
  });
	
	var window = new Ext.Window({
				layout : 'fit',
				title : statetitle,
				plain : true,
				width : 950,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]

			});
	
	//adddetailGrid.setUrlParam({No:applyNo.getValue()});
	
	
	
	window.show();	
	//window.on('beforeclose',del);
	
	
	AddFun1=function() {
		var records=adddetailGrid.store.getModifiedRecords();
		var o = {};
	    var tmpDate = adddetailGrid.dateFields;
	    var tmpstro = "";
	    var tmpstros="";
	    var data = [];
	    var rtn = 0;
	    var datad="";
	    Ext.MessageBox.confirm('��ʾ', '��ȷ���Ƿ񱣴棿', function(btn) {
			if(btn=="yes")
			{
			var length = addmainGrid.getStore().getCount();

			var rowidm="";
			var oldfundbilldr=""
			var datam="";
			var deptdr = dnamefield.getValue();
			var userdr = appuName.getValue();
			if(length!=0)
			{
				addmainGrid.getStore().each(function(rec){
								rowidm=rec.get('rowid'); // ��Ŀ֧������ID
								oldfundbilldr=rec.get('FundBillDR');				
							})
				datam='&rowidm='+rowidm+'&mdesc='+encodeURIComponent(Descfield.getValue())+'&fundbilldr='+applyCombo.getValue()+'&oldfundbilldr='+oldfundbilldr;				
			}
			else
			{
				datam='&deptdr='+deptdr+'&userdr='+userdr+'&projdr='+projDr+'&mdesc='+encodeURIComponent(Descfield.getValue())+'&fundbilldr='+applyCombo.getValue();					
			}
			
	    	Ext.Ajax.request({  
				url: 'herp.budg.budgprojclaimapplyaddexe.csp?action=Add1'+datam,
				waitMsg : '������...',
				failure : function(result, request) {
				Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						applyNo.setValue(jsonData.info);	
	    
			Ext.each(records, function(r) {
			var o = {};
			var tmpstro = "";
			var deleteFlag = r.data['delFlag'];// ɾ����ʶ��1���Ǹü�¼�Ѿ�ɾ����0��δɾ����

			// ������������֤Beging
			for (var i = 0; i < adddetailGrid.fields.length; i++) {
				var indx = adddetailGrid.getColumnModel().getColumnId(i + 1)
				var tmobj = adddetailGrid.getColumnModel().getColumnById(indx)
				if (tmobj != null) {
					// ������update���ԣ�true����������û�б仯Ҳ���̨�ύ���ݣ�false���򲻻�ǿ���ύ����
					var reValue = r.data[indx];
					if ((typeof(reValue) != "undefined") && (tmobj.update)) {
						tmpstro += "&" + indx + "=" + r.data[indx].toString();
					}
					if (tmobj.allowBlank == false) {
						var title = tmobj.header
						if ((r.data[indx].toString() == "")|| (parseInt(r.data[indx].toString()) == 0)) {
							var info = "[" + title + "]��Ϊ���������Ϊ�ջ��㣡"
							Ext.Msg.show({
										title : '����',
										msg : info,
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							rtn = -1;
							return -1;

						}
					}
				}

			}
			// ������������֤END

			if (r.isValid()) {
				if (deleteFlag == "-1") {
					return;
				}
			
			} else {
				Ext.Msg.show({
							title : '����',
							msg : '�뽫�����������������!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			}
			//alert(tmpstro);
			var itemcode=r.data['Name'];
			var budgreal=r.data['budgreal'];
			var reqpay  =r.data['reqpay'];
			var ddesc   =r.data['ddesc'];
		  //alert(ddesc);
			var recordType;
			if (r.data.newRecord) {
				recordType = "add";
				datad='&itemcode='+itemcode+'&budgreal='+budgreal+'&reqpay='+reqpay+'&ddesc='+encodeURIComponent(ddesc);
			} else {
				recordType = "edit";
				//tmpstro = "&rowid=" + r.data['rowid'];
				datad="&rowid=" + r.data['rowid']+'&reqpay='+reqpay+'&ddesc='+encodeURIComponent(ddesc);
			}
			
			//datad='&itemcode='+itemcode+'&budgreal='+budgreal+'&reqpay='+reqpay+'&ddesc='+encodeURIComponent(ddesc);	
			
			var saveUrl = adddetailGrid.url+'?action='+recordType+datad;
			//alert(saveUrl);
			p = {
				url : saveUrl,
				method : 'GET',
				waitMsg : '������...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {

						var message = "";
						message = recordType == 'add' ? '��ӳɹ�!' : '����ɹ�!'
						Ext.Msg.show({
									title : 'ע��',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
						addmainGrid.load({params:{start:0,limit:25,projdr:projDr}});
						adddetailGrid.store.commitChanges();
						if (jsonData.refresh == 'true') {
							adddetailGrid.store.load({
								params : {
									start : Ext
											.isEmpty(adddetailGrid.getTopToolbar().cursor)
											? 0
											: adddetailGrid.getTopToolbar().cursor,
									limit : adddetailGrid.pageSize
								}
							});
						}
					} else {
						if (jsonData.refresh == 'true') {
							adddetailGrid.store.load({
								params : {
									start : Ext
											.isEmpty(adddetailGrid.getTopToolbar().cursor)
											? 0
											: adddetailGrid.getTopToolbar().cursor,
									limit : adddetailGrid.pageSize
								}
							});
						}
						var message = "";
						message = "SQLErr: " + jsonData.info;
						if (jsonData.info == 'EmptyName')
							message = '�����Ԥ�����Ϊ��!';
						if (jsonData.info == 'EmptyOrder')
							message = '��������Ϊ��!';
						if (jsonData.info == 'RepCode')
							message = '����ı����Ѿ�����!';
						if (jsonData.info == 'RepName')
							message = '����������Ѿ�����!';
						if (jsonData.info == 'RepOrder')
							message = '���������Ѿ�����!';
						if (jsonData.info == 'RecordExist')
							message = '����ļ�¼�Ѿ�����!';
						Ext.Msg.show({
									title : '����',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						adddetailGrid.store.rejectChanges();
					}
				},
				scope : this
			};
			Ext.Ajax.request(p);
		}, this);
		return rtn;
				}
			},
				scope : this
		});
	
		}
		
		})
		
	}  	

	
}


