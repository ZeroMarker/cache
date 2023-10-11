var userid = session['LOGON.USERID'];

projUrl='herp.acct.acctvouchexe.csp';
/////////////ƾ֤����
		var VouchTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid','name'])
		});

		VouchTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({

					url : projUrl+'?action=GetVouchType&str='+encodeURIComponent(Ext.getCmp('VouchTypeCombo').getRawValue()),method:'POST'
			});
		});
		var VouchTypeCombo = new Ext.form.ComboBox({
	        id:'VouchTypeCombo',
			fieldLabel : 'ƾ֤����',
			store : VouchTypeDs,
			valueField : 'rowid',
			displayField : 'name',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '��ѡ������',
			width : 100,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus:true,
			forceSelection:'true'
		});


		
		//////ƾ֤����ʱ�䷶Χ
		var VouchDateStartField = new Ext.form.DateField({
			fieldLabel: 'ƾ֤���ڿ�ʼʱ��',
			width:100,
			allowBlank:false,
			format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
		
		
		var VouchDateEndField = new Ext.form.DateField({
			fieldLabel: 'ƾ֤���ڽ���ʱ��',
			width:100,
			allowBlank:false,
			format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
		
		
		
		/////////////////////ƾ֤�ŷ�Χ/////////////////////////
		VouchNoMax= new Ext.form.TextField({
 			fieldLabel : 'ƾ֤���',
			width : 100,
			columnWidth : .142,
			selectOnFocus : true
		});	
		VouchNoMin= new Ext.form.TextField({
 			fieldLabel : 'ƾ֤���',
			width : 100,
			columnWidth : .142,
			selectOnFocus : true
		});	


		var StateStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '����'], ['05', '��˲�ͨ��'],  ['11', '�ύ'], 
			        ['21', '���ͨ��'],['31', '����'], ['41', '����']]
		});
		var StateField = new Ext.form.ComboBox({
			id : 'State',
			fieldLabel : 'ƾ֤״̬',
			width : 100,
			columnWidth : .15,
			listWidth :100,
			selectOnFocus : true,
			allowBlank : false,
			store : StateStore,
			anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', 
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
				
//////��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls:'find',
	handler: function(){
	//Summaryfield MakeDateField MakeDate2Field Makerfield Checkerfield StateField
	    var vouchtype = VouchTypeCombo.getValue();
	    var vouchdatestart = VouchDateStartField.getValue();
	    var vouchdateend = VouchDateEndField.getValue();
	    var vouchnomax = VouchNoMax.getValue();
	    var vouchnomin = VouchNoMin.getValue();
	    var state = StateField.getValue();
	    var data=vouchtype+"^"+vouchdatestart+"^"+vouchdateend+"^"+vouchnomax+"^"+vouchnomin+"^"+state;
		//alert(data);
		itemGrid.load({params:{start:0,limit:25,data:data,userid:userid}});
	}
});

//////��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text: '���ƾ֤',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){
        var myPanel = new Ext.Panel({
        layout : 'fit',
		//scrolling="auto"
        html : '<iframe src="acct.html"  width="100%"  height="100%" ></iframe>',
        frame : true
		});
		
        var win = new Ext.Window({
                    title : 'ƾ֤¼��',
                    width :1020,
                    height :500,
                    resizable : false,
                    closable : true,
                    draggable : true,
                    resizable : false,
                    layout : 'fit',
                    modal : false,
                    plain : true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
                    //bodyStyle : 'padding:5px;',
                    items : [myPanel ],
                    buttonAlign : 'center',
                    buttons : [{
                            text : '�ر�',
                            type : 'button',
                            handler : function() {
                                win .close();
                                }
                            }]
                });
                win.show();
			
	}

});


//////�ύ
var submitButton = new Ext.Toolbar.Button({
	text: '�ύƾ֤',
    tooltip:'�ύ',        
    iconCls:'add',
	handler:function(){
		
			submitFun();
			
	}
	
});

//////����
var copyButton = new Ext.Toolbar.Button({
	text: '����ƾ֤',
    tooltip:'����',        
    iconCls:'add',
	handler:function(){
		copyFun();
	}
	
});

//////����1
var destroyButton = new Ext.Toolbar.Button({
	text: '����ƾ֤',
    tooltip:'����',        
    iconCls:'reset',
	handler:function(){
		destroyFun();
	}
	
});

//////����
var cacelButton = new Ext.Toolbar.Button({
	text: '����ƾ֤',
    tooltip:'����',        
    iconCls:'remove',
	handler:function(){
		cacelFun();
	}
	
});

//////��ӡ
var printButton = new Ext.Toolbar.Button({
	text: '��ӡƾ֤',
    tooltip:'��ӡ',        
    iconCls:'add',
	handler:function(){
            var records = itemGrid.getSelectionModel().getSelections();   
			var VouchNo = records[0].get("VouchNo");
            var objPrint = new ActiveXObject("PrintBar.prnbar");
           /*  objPrint.CARDLEFT = 2;
			 alert("3");
            objPrint.CARDTOP = 2;
            objPrint.LABHEIGHT = 10;
            objPrint.LABWIDTH = 30;  */
                //��ǩ,�����,����,����,Ч�� ,ʱ��,���տ�������,�����
            objPrint.PrintLabelVouch(VouchNo);

	}
	
});


       
	var button1= new Ext.Toolbar([addButton,'-',submitButton,'-',copyButton,'-',destroyButton,'-',cacelButton,'-',printButton]);
    var itemGrid = new dhc.herp.Grid({
			//title:'ƾ֤¼��',
		    region : 'center',
		    url: 'herp.acct.acctvouchexe.csp',
		    //atLoad : true, // �Ƿ��Զ�ˢ��
			tbar:['ƾ֤����:',VouchTypeCombo,'-','ƾ֤����:',VouchDateStartField,'��',VouchDateEndField,'-','ƾ֤��:',VouchNoMax,'��',VouchNoMin,'-','ƾ֤����״̬:',StateField,'-',findButton],                                                    
		    listeners :{
				 'render': function(){button1.render(itemGrid.tbar);},	
			}, 
			items:[ {xtype : 'panel',
                   width : 1120,
						height : 580,
						title : 'ddd'
       
		}],
			
			viewConfig : {forceFit : true},
			fields : [{
						id : 'VouchID',
						header : 'ƾ֤��ID',
						editable:false,
						width : 130,
						dataIndex : 'VouchID',
                        hidden : true
	                 },{
						id : 'AcctYear',
						header : '��',
						width : 50,
						editable:false,
						dataIndex : 'AcctYear'

					},{
						id : 'AcctMonth',
						header : '��',
						width : 50,
						editable:false,
						dataIndex : 'AcctMonth'

					},{
						id : 'VouchDate',
						header : 'ƾ֤����',
						width : 90,
						editable:false,
						dataIndex : 'VouchDate'

					},{
						id : 'VouchNo',
						header : 'ƾ֤��',
						editable:false,
						width : 100,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
						var sf = record.data['IsDestroy']
						if (sf == "��") {
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>'+'<b> </b>'
							+'<span style="color:red;cursor:hand;backgroundColor:white">��</span>';
						}else{
							return '<span style="color:blue;cursor:hand;backgroundColor:red;src="../scripts/herp/acct/acct.html""><u>'+value+'</u></span>';
						}},
						dataIndex : 'VouchNo'

					},{
                        id : 'typename',
						header : 'ƾ֤����',
						width : 80,
						editable:false,
						dataIndex : 'typename'
					},{
						id : 'Operator',
						header : '�Ƶ���',
						width : 100,
						editable:false,
						dataIndex : 'Operator'

					},{
						id : 'MakeBillDate',
						header : '�Ƶ�����',
						width : 90,
						editable:false,
						dataIndex : 'MakeBillDate'

					},{
						id : 'Auditor',
						header : '�����',
						width : 100,
						editable:false,
						dataIndex : 'Auditor'

					},{
                        id : 'Poster',
						header : '������',
						width : 100,
						editable:false,
						dataIndex : 'Poster'
					},{
                        id : 'VouchState',
						header : 'ƾ֤״̬',
						width : 90,
						editable:false,
						dataIndex : 'VouchState'
					},
					{
                        id : 'VouchProgress',
						header : 'ƾ֤�������',
						width : 100,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						dataIndex : 'VouchProgress'
					},{
                        id : 'IsDestroy',
						header : '����',
						width : 40,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['IsDestroy']
						if (sf == "��") {
							//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:red;cursor:hand;backgroundColor:white">'+value+'</span>';
						}},
						dataIndex : 'IsDestroy'
					},{
                        id : 'IsCancel',
						header : '����',
						width : 40,
						editable:false,
						//hidden: true,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['IsCancel']
						if (sf == "��") {
							//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:red;cursor:hand;backgroundColor:white">'+value+'</span>';
						}},
						dataIndex : 'IsCancel'
					},{
                        id : 'VouchState1',
						header : 'ƾ֤״̬',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'VouchState1'
					},{
							id:'upload',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){		
							return '<span style="color:blue"><u>�ϴ�</u></span>';			
							}	
					},{
							id:'download',
							header: '����',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>����</u></span>';
					}} ]
		});
		

	
	itemGrid.load({params:{start:0,limit:25,userid:userid}});

	uploadMainFun(itemGrid,'VouchID','P007',16);
    downloadMainFun(itemGrid,'VouchID','P007',17);	
		
    itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

	    if(columnIndex=='5'){
			//p_URL = 'acct.html?acctno=2';
		    //document.getElementById("frameReport").src='acct.html';
			var records = itemGrid.getSelectionModel().getSelections();   
			var VouchNo = records[0].get("VouchNo");
			var VouchState = records[0].get("VouchState1");
			var myPanel = new Ext.Panel({
			layout : 'fit',
			//scrolling="auto"
			html : '<iframe id="frameReport" width="100%"  height="100%" src="../csp/acct.html?acctno='+VouchNo+'&user='+userid+'&acctstate='+VouchState+'" /></iframe>',
			frame : true
			});

			var win = new Ext.Window({
						title : 'ƾ֤¼��',
						width :1020,
						height :600,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
						//bodyStyle : 'padding:5px;',
						items : [myPanel ],
						buttonAlign : 'center',
						buttons : [{
								text : '�ر�',
								type : 'button',
								handler : function() {
									win .close();
									}
								}]
					});
					win.show();
		}
		if(columnIndex=='12'){
			var records = itemGrid.getSelectionModel().getSelections();   
			var VouchID = records[0].get("VouchID");
			VouchProgressFun(VouchID);
		}
    });

    itemGrid.btnAddHide();  //�������Ӱ�ť
   	itemGrid.btnSaveHide();  //���ر��水ť
    itemGrid.btnResetHide();  //�������ð�ť
    itemGrid.btnDeleteHide(); //����ɾ����ť
    itemGrid.btnPrintHide();  //���ش�ӡ��ť


