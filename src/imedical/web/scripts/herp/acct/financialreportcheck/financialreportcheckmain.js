var FinancialUrl ="../csp/herp.acct.financialreportcheckexe.csp";
var userid = session['LOGON.USERID'];//��¼��ID
var AcctBook=IsExistAcctBook();
//�ڼ�����
var PerTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['M', '��'], ['S', '����'], ['H', '����'], ['Y', '��']]
		});
var PerTypeField = new Ext.form.ComboBox({
			id : 'PerTypeField',
			fieldLabel : '�ڼ�����',
			width : 70,
			listWidth : 125,
			selectOnFocus : true,
			allowBlank : false,
			store : PerTypeStore,
			anchor : '90%',
			value:'M', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			listeners: {
               select: function(){ 
			         var PerType=Ext.getCmp('PerTypeField').getValue();
			         SPeriodDs.proxy=new Ext.data.HttpProxy({
	                 url:FinancialUrl+'?action=GetPeriod&PerType='+PerType+'&BookID='+AcctBook,
				     method:'POST'
				  });
				  EPeriodDs.proxy=new Ext.data.HttpProxy({
	                 url:FinancialUrl+'?action=GetPeriod&PerType='+PerType+'&BookID='+AcctBook,
				     method:'POST'
				  });
				  SPeriodField.setValue("");
				  EPeriodField.setValue("");
				  SPeriodDs.load({params : {start:0,limit:10}});
				  EPeriodDs.load({params : {start:0,limit:10}});
			   }
            }
		});
		
//����ڼ�(��ʼ)
var SPeriodDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
 SPeriodDs.proxy=new Ext.data.HttpProxy({
	                 url:FinancialUrl+'?action=GetPeriod&PerType='+Ext.getCmp('PerTypeField').getRawValue()+'&BookID='+AcctBook,
				     method:'POST'
				  });
var SPeriodField = new Ext.form.ComboBox({
	id: 'SPeriodField',
	fieldLabel: '����ڼ�',
	width:100,
	listWidth : 225,
	allowBlank: false,
	store: SPeriodDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��λ����...',
	name: 'SPeriodField',
	minChars: 1,
	pageSize: 12,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


//����ڼ�(����)
var EPeriodDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
 EPeriodDs.proxy=new Ext.data.HttpProxy({
	                 url:FinancialUrl+'?action=GetPeriod&PerType='+Ext.getCmp('PerTypeField').getRawValue()+'&BookID='+AcctBook,
				     method:'POST'
				  });
var EPeriodField = new Ext.form.ComboBox({
	id: 'EPeriodField',
	fieldLabel: '����ڼ�',
	width:100,
	listWidth : 225,
	allowBlank: false,
	store: EPeriodDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��λ����...',
	name: 'EPeriodField',
	minChars: 1,
	pageSize: 12,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//����״̬
var RepState = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','����'],['1','���']]
});
var RepStateField = new Ext.form.ComboBox({
	id: 'RepStateField',
	fieldLabel: '�Ƿ�ǰ����',
	width:100,
	listWidth : 130,
	selectOnFocus: true,
	allowBlank: true,
	store: RepState,
	//anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	//emptyText:'ѡ���ڼ�����...',
	mode: 'local', //����ģʽ
	editable:true,
	//pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
});
//ѡ��ѡ��
var SelectChbox = new Ext.form.Checkbox({ 
            id : 'SelectChbox', 
            name : "SelectChbox", 
            autoScroll : false, 
			//height:4,
            //width : 90, 
            anchor : "70%", 
            hideLabel : true
});	
//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'find',
	handler: function(){
				//alert(year);
				//var bookID= GetAcctBookID();
				
                 if(AcctBook==""){
                  AcctBook=GetAcctBookID();
                 }
                
				var PerType = PerTypeField.getValue();
				var SPeriod = SPeriodField.getValue();
				var EPeriod = EPeriodField.getValue();
				var RepState= RepStateField.getValue();
				itemGrid.load({params:{start:0,limit:25,PerType:PerType,SPeriod:SPeriod,EPeriod:EPeriod,RepState:RepState,AcctBook:AcctBook}});
	}
});

var CheckButton = new Ext.Toolbar.Button({
	text: '�������',
	tooltip: '�������',
	iconCls: 'audit',
	handler: function(){
		    var RowIdStr="";
			var RepStr  ="";
			var type="";
			var yearmonth="";
			/*
			itemGrid.store.each(function (record) {  
                if(record.get('selecteds')===true)
				{
				  if(record.get('Repstate')=="���"){
				     if(RepStr!=""){
					    RepStr=RepStr+"��"+record.get('RepName');
					 }
				     else{
					    RepStr=record.get('RepName');
					 }
				  }
				  else{
				     if(RowIdStr!=""){
					    RowIdStr=RowIdStr+"^"+record.get('rowid');
					 }
					 else{
					    RowIdStr=record.get('rowid');
					 } 
				  }
				}
            }); 
			if((RowIdStr==="")&&(RepStr==="")){
			    Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ��Ҫ��˵�ģ��!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		        return;
			} 
			var PerType =Ext.getCmp("PerTypeField").getValue();         //�ڼ�����
			var SPeriod =Ext.getCmp("SPeriodField").getValue();         //����ڼ�(��ʼ)
		    var EPeriod =Ext.getCmp("EPeriodField").getValue();         //����ڼ�(����)
		    var RepState=Ext.getCmp("RepStateField").getValue();        //����״̬
			var CheckUrl =FinancialUrl+'?action=Checked&data='+RowIdStr;
			if(RepStr!==""){
			RepStr="����ѡ��ģ���У�"+RepStr+"�Ѿ���ˣ���������ˣ��Ƿ�ȷ���������δ���ģ��?"
			}
			else{
			RepStr="�Ƿ�ȷ�������ѡ���ݣ�"
			}
			*/
			var records=itemGrid.getSelectionModel().getSelections();
			var length=records.length;
			if(length<1){
				  Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ��Ҫ��˵�ģ��! ',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		        return;
				
			}
			
			for(i=0;i<length;i++){
				var rowid=records[i].data["ReportTempletID"];
				var status=records[i].data["Repstate"];
				var rpeName=records[i].data["RepName"];
				var periodType=records[i].data["PeriodType"];
				//alert(periodType=="��");
				if(periodType=="��"){
					//alert("mmmm");
				var periodType="M" 
				
				}else if(periodType=="����"){
					var periodType="S"
				}else if(periodType=="����"){
					var periodType="H"
				}else if(periodType=="��"){
					var periodType="Y"
				}
				
				var AcctMonth=records[i].data["YearMonth"]
				//alert(status+rpeName);
				if(status=="���"){
					RepStr=RepStr+rpeName+"��";
				}
				if((RowIdStr=="")&&(status!="���")){
					RowIdStr=rowid;
					type=periodType;
					yearmonth=AcctMonth
				}else if((RowIdStr!="")&&(status!="���")){
					RowIdStr=RowIdStr+"^"+rowid;
					type=type+"^"+periodType
					yearmonth=yearmonth+"^"+AcctMonth
				}
								
				
			}
			 //alert(RowIdStr+"^"+type+"^"+yearmonth);
			if((RepStr!=="")&&(RowIdStr!="")){
				
			RepStr="����ѡ��ģ���У�"+RepStr+"�Ѿ���˽�������ˣ��Ƿ�ȷ���������δ���ģ��? "
			}else if((RepStr!=="")&&(RowIdStr=="")){
				 Ext.Msg.show({
					title:'��ʾ',
					msg:'��������� ',
					buttons:Ext.Msg.OK,
					icon:Ext.MessageBox.WARNING
				});
	            return;
			}
			else{
			RepStr="�Ƿ�ȷ�������ѡ���ݣ� "
			}
			
			var PerType =Ext.getCmp("PerTypeField").getValue();         //�ڼ�����
			var SPeriod =Ext.getCmp("SPeriodField").getValue();         //����ڼ�(��ʼ)
		    var EPeriod =Ext.getCmp("EPeriodField").getValue();         //����ڼ�(����)
		    var RepState=Ext.getCmp("RepStateField").getValue();        //����״̬
			var CheckUrl =FinancialUrl+'?action=Checked&data='+RowIdStr+'&type='+type+'&yearmonth='+yearmonth;
			Ext.MessageBox.confirm("��ʾ", RepStr, function (id) {
			   if(id=="yes"){
			     if(RowIdStr!=""){
				   itemGrid.saveurl(CheckUrl);
		           itemGrid.load({params : {start:0,limit:25,PerType:PerType,SPeriod:SPeriod,EPeriod:EPeriod,RepState:RepState}});
				 }  
			   }        			 
			 return ;
			 });  		
	  return;	
	}
});
var report=new Ext.Toolbar.Button({
	text:'���ɱ�������',
	tooltip:'���ɱ�������', 
	iconCls: 'add',
	handler:function(){
		createData();
		}
});

var queryPanel = new Ext.FormPanel({
	     title: '���񱨱����',
	     iconCls:'audit',
		region: 'north',
		height: 75,
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px '
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '�ڼ�����',
						style: 'padding : 0 5px;'
						//width: 60
					}, PerTypeField,  {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, {
						xtype: 'displayfield',
						value: '����ڼ�',
						style: 'padding : 0 5px;'
						//width: 60
					}, SPeriodField, {
						xtype: 'displayfield',
						value: '��',
						style: 'padding : 0 5px;'
					}, EPeriodField,{
						xtype: 'displayfield',
						value: '',
						width: 40
					},{
						xtype: 'displayfield',
						value: '����״̬',
						style: 'padding : 0 5px;'
						//width: 60
					}, RepStateField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, findButton,{
						xtype: 'displayfield',
						value: '',
						style: 'line-height: 15px;',
						width: 30
					}, CheckButton, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, 
					report
				]
			}
		]

	});
	
var itemGrid = new dhc.herp.Grid({
       // title: '���񱨱����',
        width: 400,
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
		//tbar:['�ڼ����ͣ�',PerTypeField,'-','����ڼ䣺',SPeriodField,'--',EPeriodField,'-','����״̬��',RepStateField,'-',findButton,'-',CheckButton,'-',report],
        url: FinancialUrl,	  
		atLoad : false, // �Ƿ��Զ�ˢ��
		loadmask:true,
		listeners :{
		'cellclick':function(grid, rowIndex, columnIndex, e) {
			var record = grid.getStore().getAt(rowIndex);
			var repcode=record.get("RepCode");
			var PeriodType=record.get("PeriodType");
			if(PeriodType=="��"){
				var PeriodType="M" 
				}else if(PeriodType=="����"){
					var PeriodType="S"
				}else if(PeriodType=="����"){
					var PeriodType="H"
				}else if(PeriodType=="��"){
					var PeriodType="Y"
				}
			var YearMonth=record.get("YearMonth");
			var year=YearMonth.substring(0,4);
			var month=YearMonth.substring(4,6);
			
			var data=year+"^"+month+"^"+PeriodType+"^"+userid
			//var report=document.getElementById("report");
			//alert(data);
			if(columnIndex==4){
				
		     if(repcode=="KY01"){
			var myPanel = new Ext.Panel( {
			layout : 'fit',
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="dhccpmrunqianreport.csp?reportName=herp.acct.AssetsLiabilites.raq&year='+year+'&frequency='+PeriodType+'&period='+month+'&userid='+userid+'" /></iframe>'
			//frame : true
			});
			var win = new Ext.Window({
						//title : '�ʲ���ծ���������',
						width :1150,
						height :580,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
						//bodyStyle : 'padding:5px;',
						items : [myPanel],
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
					
			 }else if(repcode=="KY02"){
		    var myPanel = new Ext.Panel( {
			layout : 'fit',
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="dhccpmrunqianreport.csp?reportName=herp.acct.IncomePaymentTotal.raq&year='+year+'&frequency='+PeriodType+'&period='+month+'&userid='+userid+'" /></iframe>'
			//frame : true
			});
			var win = new Ext.Window({
						//title : '��������ܱ��������',
						width :1150,
						height :580,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
						//bodyStyle : 'padding:5px;',
						items : [myPanel],
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
					
					 
		 }else if(repcode=="KY0201"){
			var myPanel = new Ext.Panel( {
			layout : 'fit',
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="dhccpmrunqianreport.csp?reportName=herp.acct.IncomePaymentDetail.raq&year='+year+'&frequency='+PeriodType+'&period='+month+'&userid='+userid+'" /></iframe>'
			//frame : true
			});
			var win = new Ext.Window({
						//title : 'ҽ�����������ϸ���������',
						width :1150,
						height :580,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
						//bodyStyle : 'padding:5px;',
						items : [myPanel],
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
		}else if(repcode=="KY03"){
		    var myPanel = new Ext.Panel( {
			layout : 'fit',
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="dhccpmrunqianreport.csp?reportName=herp.acct.CashFlowT.raq&year='+year+'&userid='+userid+'" /></iframe>'
			//frame : true
			});
			var win = new Ext.Window({
						//title : '�ֽ��������������',
						width :1150,
						height :580,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
						//bodyStyle : 'padding:5px;',
						items : [myPanel],
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
					 
		}else if(repcode=="KY04"){
		   var myPanel = new Ext.Panel( {
			layout : 'fit',
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="dhccpmrunqianreport.csp?reportName=herp.acct.FinancialAidPayments.raq&year='+year+'&userid='+userid+'" /></iframe>'
			//frame : true
			});
			var win = new Ext.Window({
						//title : '����������֧������������',
						width :1150,
						height :580,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
						//bodyStyle : 'padding:5px;',
						items : [myPanel],
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
					 
				 }else if(repcode=="KY05"){
			var myPanel = new Ext.Panel( {
			layout : 'fit',
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="dhccpmrunqianreport.csp?reportName=herp.acct.AcctPayOutEconomyAnalysis.raq&year='+year+'&frequency='+PeriodType+'&period='+month+'&userid='+userid+'" /></iframe>'
			//frame : true
			});
			var win = new Ext.Window({
						//title : 'ҽ�����������ϸ���������',
						width :1150,
						height :580,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
						//bodyStyle : 'padding:5px;',
						items : [myPanel],
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
			}
			 
		}
		},
		
        fields: [
		new Ext.grid.CheckboxSelectionModel({editable:false}),
		{
			header : 'RowID',
			dataIndex : 'ReportTempletID',
			width : 40,
			hidden:'true',
			sortable : true

		}, 
		/*
		{
			header : 'ѡ��',
			dataIndex : 'selecteds',
			width : 60,
			type:SelectChbox,
			renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//����ֵ����checkbox�Ƿ�ѡ
			sortable : true

		},*/
		{
			header : '�������',
			dataIndex : 'RepCode',
			width : 110,
			editable:false,
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'RepName',
			renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
						},   
			width : 140,
			//align:'right',
			editable:false,
			sortable : true
		}, {
			header : '����',
			dataIndex : 'YearMonth',
			width : 100,
			align:'center',
			editable:false,
			sortable : true
		}, {
			header : '�ڼ�����',
			dataIndex : 'PeriodType',
			width : 100,
			align:'center',
			
			editable:false,
			sortable : true
		}, {
			header : '����˵���ļ�',
			dataIndex : 'RepDesc',
			width : 120,
			align:'center',
			renderer : function(v, p, r) {
						  return '<span style="color:blue;cursor:hand"><u>�鿴</u></span>';						
						},
			editable:false,
			sortable : true
		}, {
			header : '����״̬',
			dataIndex : 'Repstate',
			width : 100,
			align:'center',
			editable:false,
			sortable : true
		}, {
			header : '�鵵�ļ�',
			dataIndex : 'Pigeonhole',
			width : 100,
			editable:false,
			hidden:true,
			renderer : function(v, p, r) {
						  return '<span style="color:blue;cursor:hand"><u>����PDF�ļ�</u></span>';								
						},
			align:'center',
			sortable : true
		}, {
			header : '������',
			dataIndex : 'Editor',
			width : 100,
			align:'center',
			editable:false,
			sortable : true
		}, {
			header : '����ʱ��',
			dataIndex : 'EditDate',
			width : 100,
			align:'center',
			editable:false,
			sortable : true
		}, {
			header : '�����',
			dataIndex : 'Checker',
			width : 100,
			align:'center',
			editable:false,
			sortable : true
		}, {
			header : '���ʱ��',
			dataIndex : 'CheckDate',
			width : 100,
			align:'right',
			editable:false,
			sortable : true
		}] 
});

itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	// alert(columnIndex)
	// ǰ�÷�������
	if (columnIndex == 7) {
		var filename="";
		var server="";
		var path="";
		var records = itemGrid.getSelectionModel().getSelections();
	    var repCode=records[0].get("RepCode");
		var RepName=records[0].get("RepName");
		 //alert(repCode);
		Ext.Ajax.request({
        url:FinancialUrl+'?action=GetFileName&AcctBook='+ AcctBook+'&RepCode='+repCode,
        method: 'GET',
        success: function(result, request) {
        var jsonData = Ext.util.JSON.decode( result.responseText );
		var result=jsonData.info;
        if (jsonData.success=='true'){
			filename=result.split("*")[0];
			server=result.split("*")[1];
			path=result.split("*")[2];
			//alert(server+path);
			if(filename==""){
				  Ext.Msg.show({
						title : '��ʾ',
						msg : 'δ�ϴ��ļ�! ',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
						});
		    return;
				
			}else{
	     // window.open("ftp://192.168.102.144:21/acct/reportFile/"+filename); 
		  window.open("ftp://"+server+"/"+path+"/"+filename); 
                  }
		}
             }
	});
	
	}
}); 



	itemGrid.btnAddHide() 	//�������Ӱ�ť
	itemGrid.btnSaveHide() 	//���ر��水ť
	itemGrid.btnResetHide() 	//�������ð�ť
	itemGrid.btnDeleteHide() //����ɾ����ť
	itemGrid.btnPrintHide() 	//���ش�ӡ��ť
	itemGrid.load(({params:{start:0,limit:25,AcctBook:AcctBook}}));