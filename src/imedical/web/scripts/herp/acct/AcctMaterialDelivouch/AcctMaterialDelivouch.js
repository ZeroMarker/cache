
//var acctbookid=IsExistAcctBook();
//var userid = session['LOGON.USERID'];
var projUrl="herp.acct.acctMaterialDelivouchexe.csp";
var acctbookid="";
var userid="";
var vouchNO="";
var Vno=document.getElementById("vouchNO").innerHTML;
if(document.getElementById("vouchNO").innerHTML!=""){
	acctbookid=document.getElementById("AcctBookID").innerHTML;
	userid=document.getElementById("userid").innerHTML;
	vouchNO=document.getElementById("vouchNO").innerHTML+"#"+acctbookid;	
}

if(vouchNO==""){
 acctbookid=IsExistAcctBook();
 userid = session['LOGON.USERID'];	
	
}

/////////////�����·�///////////////////////
var YearMonth = new Ext.form.DateField({
    id:'YearMonth',
    fieldLabel: '�����·�',
    name : 'YearMonth',
    format : 'Y-m',
    editable : true,
    //allowBlank : false,
    emptyText:'��ѡ������...',
   // value:new Date(),
    width: 120,
   // maxValue : new Date(),
    plugins: 'monthPickerPlugin',
	listeners:{
	
		"change":function(field,newvalue,oldvalue,op){
			depotDs.removeAll();
			depotCombo.setValue('');
			
			var Month=newvalue.format('Y-m');	
		    //alert(Month);
			depotDs.on('beforeload', function(ds, o) {
			depotDs.proxy=new Ext.data.HttpProxy({
						url : projUrl+'?action=Ctlocdr&yearMonth='+Month,method:'POST'
					});
			
		   });
		   depotDs.load({params:{start:0,limit:10,yearMonth:Month}});    
		}
		
	}
});

///////////////�����ⷿ////////////////////////////  
var depotDs = new Ext.data.Store({
			autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		

depotDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=Ctlocdr',method:'POST'
					});
			
		});
var depotCombo = new Ext.form.ComboBox({
			fieldLabel : '�����ⷿ',
			store : depotDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 150,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			editable:true,
			 model : 'remote',
			selectOnFocus : true
		});
  
///////////////ҵ�񵥺�////////////////////////  
var OrderNO = new Ext.form.TextField({
    id:'OrderNO',
	fieldLabel:'ҵ�񵥺�',
	labelAlign:'left',
	labelWidth:40,
	width : 120,
	name:'OrderNO',
	triggerAction: 'all',
	forceSelection:'true',
    editable:true,
	selectOnFocus : true
});
	
//////////////////////����״̬///////////////////////	
var orderStatusDS=new Ext.data.SimpleStore({
    fields : ['key', 'keyValue'],
	data : [['','ȫ��'],['Q', 'δ����'],['P', '����']]
});
//����������  ����״̬
var orderStatus=new Ext.form.ComboBox({
   id:'orderStatus',
   fieldLabel : '����״̬',
	width : 120,
	listWidth : 100,
	store : orderStatusDS,
	valueNotFoundText : '',
	displayField : 'keyValue',
	valueField : 'key',
	mode : 'local', // ����ģʽ
	triggerAction: 'all',
	emptyText:'ȫ��',
	selectOnFocus:true,
	forceSelection : true,
	editable:true
	//allowBlank:true	
});	

var findButton=new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',        
	iconCls:'find',
	width:55,
    handler:function(){
		var Month=YearMonth.getValue();	  
		var depot=depotCombo.getValue();
		var OrderNOs=OrderNO.getValue();
		var Status=orderStatus.getValue();
		if(Month!=""){		
			Month=Month.format('Y-m');
		}
			itemGrid.load({
				params:{		
				sortField:'',
				sortDir:'',
				start:0,
				limit:25,
				YearMonth:Month,
				depot:depot,
				OrderNO:OrderNOs,
				orderStatus:Status,
				VouchNO:vouchNO
				}
			});	
			itemGridf.load({params:{start:0, limit:25, rowid:"", kf:""}});
		//}else{
		//	Ext.Msg.show({title:'��ʾ',msg:'��ѡ�������·� ',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});		
		//}   
	}
});
   
 //ƾ֤����
var vouchDate = new Ext.form.DateField({
    id:'vouchDate',
    fieldLabel: 'ƾ֤����',
    name : 'vouchDate',
    format : 'Y-m-d',
    editable : true,
	value:new Date(),
    allowBlank : false,
    emptyText:'��ѡ������...',
    width: 120
   // plugins: 'monthPickerPlugin'
});
   
  
  var createVouch=new Ext.Toolbar.Button({
		text : '&nbsp;����ƾ֤',
		width:80,
		tooltip : '����ƾ֤',
		iconCls : 'createvouch',
		handler:function(){
		createVouch();
		}
	  
  });
  
  
  //��ѯ���
if(vouchNO==""){
	var queryPanel = new Ext.FormPanel({
		title:'���ʳ���ƾ֤',
		iconCls:'createvouch',
		  height:73,	  
		  region:'north',
		  frame:true,
		  //split : true,
		  //collapsible : true,
		  defaults: {bodyStyle:'padding:5px'},
		  items:[{
			 columnWidth:1,
			 xtype: 'panel',
			 layout:"column",
			 width:1200,
			 items: [ {
							xtype:'displayfield',
							value:'�����·�',
							style:'padding:0 5px;'
							//width:60
						},YearMonth,
					 {
						 xtype:'displayfield',
						 value:'',
						 width:40	
					 },{
							xtype:'displayfield',
							value:'�������',
							style:'padding:0 5px;'  
							//width:60
						},depotCombo,
					 {
						 xtype:'displayfield',
						 value:'',
						 width:40	
					 },
					 {
							xtype:'displayfield',
							value:'ҵ�񵥺�',
							style:'padding:0 5px;'
							//width:60
					 },OrderNO,
					 {
						 xtype:'displayfield',
						 value:'',
						 width:40	
					  },
					 {
							xtype:'displayfield',
							value:'����״̬',
							style:'padding:0 5px;'
							//width:60
						},orderStatus,
					 		  
					 {
						 xtype:'displayfield',
						 value:'',
						 width:30	
					  },findButton,{
						xtype:'displayfield',
						value:'',
						width:30	
					 },createVouch 
		 ] }/* ,{
			 columnWidth:1,
			 xtype: 'panel',
			 layout:"column",
			 items:[
					{
						xtype:'displayfield',
						value:'ƾ֤����:',
						style:'line-height: 20px;',  
						width:60
					},vouchDate,
					 {
						xtype:'displayfield',
						value:'',
						width:100	
					 },createVouch ]
		 } */]	
	});
}else if(vouchNO!=""){	
	var queryPanel =new Ext.FormPanel({
		region:'north',
		frame:true,
		height:80,		
		items:[			
			{
                xtype:'displayfield',
                value:'���ʳ��������ϸ��',
                style:'text-align:center;font-size:16px;height:40px;vertical-align:middle; line-height:40px;font-weight:bold'
                        //width:60
            },{
				xtype:'displayfield',
                value:'ƾ֤���ţ�'+Vno,
				style:'text-align:left'
			}
		]				
	});	
}

 var itemGrid = new dhc.herp.Grid({
            //width: 400,
			region: 'center',
			iconCls:'list',
			title:'���ʳ�������',
			url : projUrl,
			fields : [
			new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
				id:'rowid',
				header:'<div style="text-align:center">ID</div>',
				width:50,
				editable : false,
				align:'left',
				allowBlank : false, 
                hidden : true,				
				dataIndex : 'rowid'
				},{
				id:'bookid',
				header:'<div style="text-align:center">bookid</div>',
				width:50,
				editable : false,
				align:'left',
				allowBlank : false, 
                hidden : true,				
				dataIndex : 'bookid'
				},{
				  id:'StkMonNo',
				  header:'<div style="text-align:center">ҵ�񵥺�</div>',
				  width : 150,
				  align:'left',
				  editable : false,
				  allowBlank : true,     
				  dataIndex : 'StkMonNo'
				},{
				  id:'CTLOCID',
				  header:'<div style="text-align:center">�������id</div>',
				  width : 80,
				  align:'left',
				  editable : false,
				  allowBlank : true,   
				  hidden : true,				  
				  dataIndex : 'CTLOCID'
				},{
				  id:'CTLOCDR',
				  header:'<div style="text-align:center">�������</div>',
				  width : 180,
				  align:'left',
				  editable : false,
				  allowBlank : true,     
				  dataIndex : 'CTLOCDR'
				},{
				  id:'Month',
				  header:'<div style="text-align:center">�����·�</div>',
				  width : 90,
				  align:'center',
				  editable : false,
				  allowBlank : true,    
				  dataIndex : 'Month'
				},{
				  id:'FromDate',
				  header:'<div style="text-align:center">��ʼ����</div>',
				  width : 90,
				  align:'center',
				  editable : false,
				  allowBlank : true,    
				  dataIndex : 'FromDate'
				},{
				  id:'ToDate',
				  header:'<div style="text-align:center">��������</div>',
				  width : 90,
				  align:'center',
				  editable : false,
				  allowBlank : true, 
				 // hidden:true,       
				  dataIndex : 'ToDate'
				},{
				  id:'CreatedUser',
				  header:'<div style="text-align:center">�Ƶ���</div>',
				  width : 120,
				  align:'center',
				  editable : false,
				  allowBlank : true, 
				 // hidden:true,       
				  dataIndex : 'CreatedUser'
				},{
				  id:'AcctVoucherStatus',
				  header:'<div style="text-align:center">����״̬</div>',
				  width : 70,
				  align:'center',
				  editable : false,
				  allowBlank : true,  
				  dataIndex : 'AcctVoucherStatus'
				},{
				 id:'AcctVoucherUser',
				 header:'<div style="text-align:center">������</div>',
				 width : 120,
				// align:'left',
				 align: 'center',
				 editable : false,
				 allowBlank : true,     
				 dataIndex : 'AcctVoucherUser'
				},{
				  id:'AcctVoucherDate',
				  header:'<div style="text-align:center">��������</div>',
				  width : 90,
				  align:'center',
				  editable : false,
				  allowBlank : true,     
				  dataIndex : 'AcctVoucherDate'
				},{
				 id:'AcctVoucherCode',
				 header:'<div style="text-align:center">ƾ֤��</div>',
				 width : 120,
				  align:'center',
				  editable : false,
				  allowBlank : true,     			  
				  renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
						},				  
				  dataIndex : 'AcctVoucherCode'
				},{
				id:'PdfFile',
				header : 'PDF�ļ�',
				editable : false,
				align : 'center',
				width:120,					
				renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
					},
				dataIndex : 'PdfFile'
				}],
	sm : new Ext.grid.RowSelectionModel({	singleSelect : true	}),
	split : true,
	collapsible : true,
	containerScroll :true,
	xtype : 'grid',
	stripeRows : true,
	loadMask : true,
	height:300,
	trackMouseOver: true
});
    
	itemGrid.btnAddHide();
    itemGrid.btnSaveHide();
    itemGrid.btnResetHide();
    itemGrid.btnDeleteHide();
    itemGrid.btnPrintHide();
	//itemGrid.load(({params:{start:0,limit:25}}));
if(vouchNO!=""){
	itemGrid.load(({params:{start:0,limit:25,VouchNO:vouchNO}}));
}
itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var MainRowid='';
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var MainRowid=selectedRow[0].data['rowid'];
	var kf=selectedRow[0].data['CTLOCDR'];
	var CTLOCID=selectedRow[0].data['CTLOCID'];
	//alert(MainRowid);
	itemGridf.load({params:{start:0, limit:25,rowid:MainRowid,kf:kf,CTLOCID:CTLOCID}});	
});

// ����ƾ֤���ڵ�panel
var VouchDatePanel = new Ext.form.FormPanel({
	baseCls: 'x-plain',
	labelWidth: 90,
	labelAlign: 'right',
	lineHeight: 20,
	items: vouchDate
});
// ����ƾ֤����
var CreateVouchWin;


   var createVouch = function () {
   	var selectedRow = itemGrid.getSelectionModel().getSelections();
   	var len = selectedRow.length;
   var Vouchrowid = "";
   	// alert(len);
   	if (len == 0) {
   		Ext.Msg.show({
   			title: '��ʾ',
   			msg: '��ѡ����Ҫ����ƾ֤�����ݣ� ',
   			buttons: Ext.Msg.OK,
   			icon: Ext.MessageBox.WARNING
   		});
   		return;
   	}

   	for (var i = 0; i < len; i++) {
   		
   		//var VouchmainID = "";
   		var VouchmainID = selectedRow[i].get('rowid');
   		//var vouchNO = selectedRow[i].data['AcctVoucherCode'];
   		var Status = selectedRow[i].get('AcctVoucherStatus');
   		if (Vouchrowid == "") {
   			Vouchrowid = VouchmainID
   		} else {
   			Vouchrowid = Vouchrowid + "^" + VouchmainID
   		}
   	
   		if (Status == "����") {
   			Ext.Msg.show({
   				title: '��ʾ',
   				msg: '��ѡ���������Ѿ�����ƾ֤������,�����ظ����ɣ� ',
   				buttons: Ext.Msg.OK,
   				icon: Ext.MessageBox.WARNING
   			});
   			return;
   		}
   	}

	Ext.Ajax.request({
		url: projUrl + '?action=ifNotConfigured&rowid=' + Vouchrowid + '&AcctBookID=' + acctbookid + "&userid=" + userid,
		method: 'POST',
		success: function (result, request) {
		
	    var jsonData = Ext.util.JSON.decode(result.responseText);
	    if (jsonData.success == 'true') {
		 Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ����ƾ֤�� ', function (btn) {
   		  if (btn == 'yes') {

   			if (!CreateVouchWin) {
   				CreateVouchWin = new Ext.Window({
   						title: "����ƾ֤������",
   						height: 200,
   						width: 300,
   						bodyStyle: 'padding:30px 10px 0 5px;',
   						buttonAlign: 'center',
   						closeAction: 'hide',
   						items: VouchDatePanel,
   						buttons: [{
   								text: "ȷ��",
   								handler: function () {
   									var VouchDate = vouchDate.getValue();
   									if (VouchDate == "") {
   										Ext.Msg.show({
   											title: '��ʾ',
   											msg: 'ƾ֤���ڲ���Ϊ�գ� ',
   											buttons: Ext.Msg.OK,
   											icon: Ext.MessageBox.WARNING
   										});
   										return;
   									} else {
   										VouchDate = VouchDate.format('Y-m-d');
   										CreateVouchWin.hide();
   									}
                                  	var selectedRow = itemGrid.getSelectionModel().getSelections();
									var len = selectedRow.length;
                                    var rowid = "";
   									   	for (var i = 0; i < len; i++) {
   		

		//var VouchmainID = "";
                                   var VouchID = selectedRow[i].get('rowid');
                                      //var vouchNO = selectedRow[i].data['AcctVoucherCode'];
                                   var Status = selectedRow[i].get('AcctVoucherStatus');
                                if (rowid == "") {
                                 rowid = VouchID
                                     } else {
                                           rowid = rowid + "^" + VouchID
                                     }
										}
									Ext.Ajax.request({
   										url: projUrl + '?action=CreateVouch&rowid=' + rowid + '&vouchdate=' + VouchDate + '&AcctBookID=' + acctbookid + "&userid=" + userid,
   										method: 'POST',
   										success: function (result, request) {
   											var jsonData = Ext.util.JSON.decode(result.responseText);
   											if (jsonData.success == 'true') {
   												Ext.Msg.show({
   													title: '��ʾ',
   													msg: '����ƾ֤�ɹ� ',
   													buttons: Ext.Msg.OK,
   													icon: Ext.MessageBox.INFO
   												});
   												var tbarnum = itemGrid.getBottomToolbar();
   												tbarnum.doLoad(tbarnum.cursor);
   											} else if (jsonData.success == 'false') {
												Ext.Msg.show({
   													title: '��ʾ',
   													msg: '����ƾ֤ʧ�� ',
   													buttons: Ext.Msg.OK,
   													icon: Ext.MessageBox.INFO
   												});
   											} else {
   												Ext.Msg.show({
   													title: '��ʾ',
   													msg: '����ƾ֤ʧ�� ',
   													buttons: Ext.Msg.OK,
   													icon: Ext.MessageBox.INFO
   												});
   											}
   										},
   										failure: function (result, request) {
   											Ext.Msg.show({
   												title: '����',
   												msg: '����ƾ֤ʧ��,������������! ',
   												buttons: Ext.Msg.OK,
   												icon: Ext.MessageBox.ERROR
   											});
   										}
   									});

   								}
   							}, {
   								text: "ȡ��",
   								handler: function () {
   									CreateVouchWin.hide();
   								}
   							}
   						]
   					});
   			}
   			CreateVouchWin.show();
   		}
   	});
								
					} else if (jsonData.success == 'false') {
						var information = jsonData.info;
						if (information == "EmptyRecData") {
							Ext.Msg.show({
								title: '��ʾ',
								msg: 'ƾ֤��Ϣ������! ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.INFO
							});
						} else if (information == "Emptydetail") {
							Ext.Msg.show({
								title: '��ʾ',
								width: 350,
								msg: 'ƾ֤��ϸ��Ϣ������,��˲�[��ƿ��Ҷ���]�Լ�[ƾ֤ģ������]�Ƿ�ά���˵�ǰ���׵���Ϣ��',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.INFO
							});
						} else if (information == "NoSubj") {
							Ext.Msg.show({
								title: '��ʾ',
								msg: '��ƿ�Ŀ������,��ȷ����ƿ�Ŀ�������ԣ� ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.INFO
							});
						} else if (information.split("*")[0] == "NoLoc") {
							var Loc = information.split("*")[1]
								Ext.Msg.show({
									title: '��ʾ',
									width: 300,
									msg: '����ƾ֤ʧ�ܣ�δ�ҵ�[<span style="color:blue">' + Loc + '</span><br/>]��Ӧ�Ŀ������,���Ƚ���ά���� ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
						} else if (information.split("*")[0] == "NoDept") {
							var Dept = information.split("*")[1]
								//var deptname = information.split("*")[2]
								Ext.Msg.show({
									title: '��ʾ',
									width: 300,
									msg: '����ƾ֤ʧ�ܣ�δ�ҵ�[<br/><span style="color:blue">' + Dept + '</span><br/>],����"ƾ֤ģ������"�������ά���� ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
						}
					} else {
						Ext.Msg.show({
							title: '��ʾ',
							msg: '����ƾ֤ʧ�� ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.INFO
						});
					}
				},
				failure: function (result, request) {
					Ext.Msg.show({
						title: '����',
						msg: '����ƾ֤ʧ��,������������! ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.ERROR
					});
				}
			});

   }
		
	itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {
	    if(columnIndex=='14'){
			var records = itemGrid.getSelectionModel().getSelections();   
			var VouchNo = records[0].get("AcctVoucherCode");
			var AcctBookID=records[0].get("bookid");
			var VouchState = '11';
			if(VouchNo!=""){
				var myPanel = new Ext.Panel( {
				layout : 'fit',
				//scrolling="auto"
				html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno='+VouchNo+'&user='+userid+'&acctstate='+VouchState+'&bookID='+AcctBookID+'&SearchFlag='+'3'+'" /></iframe>'
				//frame : true
				});
				var win = new Ext.Window({
							title : 'ƾ֤�鿴',
							width :1090,
							height :620,
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
	    }else if(columnIndex=='15'){
			var records = itemGrid.getSelectionModel().getSelections();   
			var filename=records[0].get("PdfFile");
			if(filename!=""){
				window.open("ftp://192.168.102.144:21/acct/reportFile/"+filename);
			} 
		}
     });