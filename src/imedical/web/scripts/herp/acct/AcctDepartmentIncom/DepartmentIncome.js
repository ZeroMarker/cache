
var projUrl="herp.acct.acctdepartmentincomeexe.csp";
var acctbookid="";
var userid="";
var vouchNO="";
var Vno=document.getElementById("vouchNO").innerHTML;
if(document.getElementById("vouchNO").innerHTML!=""){
	acctbookid=document.getElementById("AcctBookID").innerHTML;
	userid=document.getElementById("userid").innerHTML;
	vouchNO=document.getElementById("vouchNO").innerHTML+"#"+acctbookid;	
}
 //vouchNO="201601010001";
if(vouchNO==""){
 acctbookid=IsExistAcctBook();
 userid = session['LOGON.USERID'];	
	
}
//alert(vouchNO);


 //�ɼ�����
var collStartDate = new Ext.form.DateField({
    id:'collStartDate',
    fieldLabel: '�����·�',
    name : 'collStartDate',
    format : 'Y-m',
    editable : true,
	value:new Date(),
    allowBlank : false,
    emptyText:'��ѡ������...',
    plugins: 'monthPickerPlugin',
    width: 120
});
 var collEndDate = new Ext.form.DateField({
		id:'collEndDate',
		name : 'collEndDate',
		format : 'Y-m-d',
		editable : true,
		 value:new Date(),
		allowBlank : false,
		emptyText:'��ѡ������...',
		//plugins: 'monthPickerPlugin',
		width: 120
	  
	}); 
	
 //��������
 var accountDate = new Ext.form.DateField({
    id:'accountDate',
    fieldLabel: '��������',
    name : 'accountDate',
    format : 'Y-m-d',
    editable : true,
	//value:new Date(),
    allowBlank : false,
    emptyText:'��ѡ������...',
    width: 120
});
  
  //��������
  var departTypeDS=new Ext.data.SimpleStore({
    fields : ['key', 'keyValue'],
	data : [['A', 'ȫ��'],['I', 'סԺ'],['O','����'],['E','����'],['H','���']]
});
//���������� 
var departType=new Ext.form.ComboBox({
	id:'departType',
	fieldLabel : '��������',
	width : 120,
	listWidth : 100,
	store : departTypeDS,
	valueNotFoundText : '',
	displayField : 'keyValue',
	valueField : 'key',
	mode : 'local', // ����ģʽ
	triggerAction: 'all',
	emptyText:'ȫ��',
	selectOnFocus:true,
	forceSelection : true,
	editable:true
	
});	

//����״̬	
	var dataStatusDS=new Ext.data.SimpleStore({
      fields : ['key', 'keyValue'],
	  data : [['0', '�ɼ�'],['1', '����']]
});
//����������  ����״̬
var  dataStatus=new Ext.form.ComboBox({
	id:' dataStatus',
	fieldLabel : '����״̬',
	width : 120,
	listWidth : 100,
	store : dataStatusDS,
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
		find();
	}
});


//���ݲɼ�
 var collectionButton=new Ext.Toolbar.Button({
	text:'����ǩ��',
	tooltip:'����ǩ��',        
	iconCls:'dataabstract',
	width:55,
    handler:function(){
		collect();
	}
});

   
//����PDF
 var createPDFButton=new Ext.Toolbar.Button({
	text:'����PDF',
	tooltip:'����PDF',        
	iconCls:'opTion',
	width:55,
    handler:function(){
		createPDF();
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
  
if(vouchNO==""){
  //��ѯ���
	var queryPanel = new Ext.FormPanel({
		title:'��������ƾ֤',
		iconCls : 'createvouch',
		height:115,
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
			items:[
				{
                    xtype:'displayfield',
                    value:'�����·�',
                    style:'padding:0 5px;',  
                   // width:60,
					id:'SDate'
				},collStartDate,						  
				// {
                    // xtype:'displayfield',
                    // value:'--',
                    // style:'line-height: 20px;',  
                    // width:12					
				// },collEndDate,
				{
					xtype:'displayfield',
                    value:'',
                    width:40	
			    },
                {
                    xtype:'displayfield',
                    value:'��������',
                    style:'padding:0 5px;'
                    //width:60
                },accountDate,
				{
					xtype:'displayfield',
                    value:'',
                    width:40	
			    },
                {
                    xtype:'displayfield',
                    value:'��������',
                    style:'padding:0 5px;'
                    //width:60
                },departType,
				{
					xtype:'displayfield',
                    value:'',
                    width:40	
				},{
                    xtype:'displayfield',
                    value:'����״̬',
                   style:'padding:0 5px;'
                    //width:60
                },dataStatus,
				{
					xtype:'displayfield',
                    value:'',
                    width:40	
				},findButton
			]
		},{
			columnWidth:1,
			xtype: 'panel',
			layout:"column",
			width:1200,
			items:[
				collectionButton,{
					xtype:'displayfield',
                    value:'',
                    width:40	
			    },createPDFButton,{
					xtype:'displayfield',
                    value:'',
                    width:40	
			    },createVouch 
			]
		}]	
	});
}else if(vouchNO!=""){	
	var queryPanel =new Ext.FormPanel({
		region:'north',
		frame:true,
		height:80,		
		items:[			
			{
                xtype:'displayfield',
                value:'����������ϸ��',
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
           iconCls : 'list',
			region: 'center',
			title:'�������������ܱ�',
			url : projUrl,
			atLoad : false, // �Ƿ��Զ�ˢ��
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
				},
				{
					id:'bookid',
					header:'<div style="text-align:center">BookID</div>',
					width:50,
					editable : false,
					align:'left',
					allowBlank : false, 
					hidden : true,				
					dataIndex : 'bookid'
				},
				{
					id:'BillNo',
					header:'<div style="text-align:center">ҵ�����</div>',
					width : 120,
					align:'center',
					editable : false,
					allowBlank : true,     
					dataIndex : 'BillNo'
				},{
					id:'DateRange',
					header:'<div style="text-align:center">�����·�</div>',
					width : 150,
					align:'center',
					editable : false,				  
					dataIndex : 'DateRange'
				},
				{
					id:'CollectPerson',
					header:'<div style="text-align:center">ǩ����Ա</div>',
					width : 100,
					align:'center',
					editable : false,
					allowBlank : true,     
					dataIndex : 'CollectPerson'
				},
				{
					id:'CollectDate',
					header:'<div style="text-align:center">ǩ��ʱ��</div>',
					width : 90,
					align:'center',
					editable : false,
					allowBlank : true,    
					dataIndex : 'CollectDate'
				},
				{
					id:'AcctAmount',
					header:'<div style="text-align:center">�ܽ��</div>',
					width : 100,
					align:'right',
					editable : false,
					allowBlank : true, 
					// hidden:true,       
					dataIndex : 'AcctAmount'
				},
				{
					id:'DataStatus',
					header:'<div style="text-align:center">����״̬</div>',
					width : 100,
					align:'center',
					editable : false,
					allowBlank : true, 
					// hidden:true,       
					dataIndex : 'DataStatus'
				},
				{
					id:'PostPerson',
					header:'<div style="text-align:center">������</div>',
					width : 100,
					align:'center',
					editable : false,
					allowBlank : true,  
					dataIndex : 'PostPerson'
				},
				{
					id:'PostDate',
					header:'<div style="text-align:center">��������</div>',
					width : 90,
					// align:'left',
					align: 'center',
					editable : false,
					allowBlank : true,     
					dataIndex : 'PostDate'
				},
				{
					id:'VounchNo',
					header:'<div style="text-align:center">ƾ֤��</div>',
					width : 120,
					align:'center',
					editable : false,
					allowBlank : true, 
                    renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
						},				  
					dataIndex : 'VounchNo'
				},
				{
					id:'PdfUrl',
					header : 'PDF�ļ�',
					editable : false,
					align : 'center',
					width:100,
					renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
						return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
					},
					dataIndex : 'PdfUrl'
				}],
	sm : new Ext.grid.RowSelectionModel({	singleSelect : true	}),
	split : true,
	collapsible : true,
	containerScroll :true,
	xtype : 'grid',
	stripeRows : true,
	//loadMask : true,
	height:250,
	trackMouseOver: true
    });
    
	itemGrid.btnAddHide();
    itemGrid.btnSaveHide();
    itemGrid.btnResetHide();
    itemGrid.btnDeleteHide();
    itemGrid.btnPrintHide();
if(vouchNO!=""){
	itemGrid.load(({params:{start:0,limit:25,VouchNO:vouchNO}}));
}
itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var rowid='';
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	rowid=selectedRow[0].data['rowid'];	
	itemGridf.load({params:{start:0, limit:25,rowid:rowid}});	
});


var find=function(){
	
	var CollStartDate=collStartDate.getValue();
	if(CollStartDate!=""){
		CollStartDate=CollStartDate.format('Y-m');  
	}	
	// var CollEndDate=collEndDate.getValue();
	// if(CollEndDate!=""){
		// CollEndDate=CollEndDate.format('Y-m-d');  
	// }	
	var AccountDate=accountDate.getValue();
	if(AccountDate!=""){
		AccountDate=AccountDate.format('Y-m-d');  
	}		  
	var DepartType=departType.getValue();
	var DataStatus=dataStatus.getValue();
	  
	itemGrid.load({
		params:{		
			sortField:'',
			sortDir:'',
		    start:0,
		    limit:25,
			collStartDate:CollStartDate,
			//collEndDate:CollEndDate,
			accountDate:AccountDate, 
			departType:DepartType, 
			dataStatus:DataStatus
			}
	  });	
     
	itemGridf.load({params:{start:0, limit:25,rowid:""}});	  
};

var createPDF=function(){
	var URL="";
	Ext.Ajax.request({
        url:projUrl+'?action=GetURL&AcctBookID='+ acctbookid,
        method: 'GET',
        success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
				var URL= jsonData.info;	
				//alert(URL);		
				callback(URL);
            }
        }		 
	});	
	function callback(URL){
		var selectedRow = itemGrid.getSelectionModel().getSelections();
		var len=selectedRow.length;
		var rowidd="";
		// alert(len);
		if(len==0){
			Ext.Msg.show({
				title:'��ʾ',msg:'��ѡ����Ҫ����pdf�ļ������ݣ� ',
				buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING		  
			});
			return;
        }else{
			for(var i=0;i<len;i++){
				pdffile=selectedRow[i].data['PdfUrl'];
				if(pdffile!=""){
					Ext.Msg.show({
						title:'��ʾ',msg:'��ѡ���������Ѿ�����pdf�ļ�������,�����ظ����ɣ� ',
						buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING		  
					});
					return;	
				}
				rowidd=selectedRow[i].data['rowid'];  
				var pdfloadUrl= "http://"+ URL+"/herpacctPDFcreate/CreatePDFServlet"
				Ext.Ajax.request({			
					url:pdfloadUrl,
					waitMsg:'����������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success==true){
							Ext.Msg.show({title:'ע��',msg:'����PDF�ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});	
							var tbarnum = itemGrid.getBottomToolbar();  
							tbarnum.doLoad(tbarnum.cursor);
						}else{
							Ext.Msg.show({title:'����',msg:'����ʧ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					},
					params:{rowid:rowidd},
					scope: this
				});		
			}				
		}						
	}	
}  
    
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
   		var Status = selectedRow[i].get('DataStatus');
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
											var VouchID = selectedRow[i].get('rowid');
											//var vouchNO = selectedRow[i].data['AcctVoucherCode'];
											var Status = selectedRow[i].get('DataStatus');
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
								}]
							});
						}
						CreateVouchWin.show();
					}
				});
			} else if (jsonData.success == 'false') {
				var information = jsonData.info;
				var ZY = information.split("^")[0]
				var MZ = information.split("^")[1]
				if (ZY == "EmptyRecData") {
					Ext.Msg.show({
						title: '��ʾ',
						msg: 'סԺ�����ƾ֤��Ϣ������! ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (MZ == "EmptyRecData") {
					Ext.Msg.show({
						title: '��ʾ',
						msg: '���������ƾ֤��Ϣ������! ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (ZY == "Emptydetail") {
					Ext.Msg.show({
						title: '��ʾ',
						width: 350,
						msg: 'סԺ�����ƾ֤��ϸ��Ϣ������,��˲�[��ƿ��Ҷ���]�Լ�[ƾ֤ģ������]�Ƿ�ά���˵�ǰ���׵���Ϣ��',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (MZ == "Emptydetail") {
					Ext.Msg.show({
						title: '��ʾ',
						width: 350,
						msg: '���������ƾ֤��ϸ��Ϣ������,��˲�[��ƿ��Ҷ���]�Լ�[ƾ֤ģ������]�Ƿ�ά���˵�ǰ���׵���Ϣ��',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (ZY == "NoSubj") {
					Ext.Msg.show({
						title: '��ʾ',
						msg: 'סԺ����Ļ�ƿ�Ŀ������,��ȷ����ƿ�Ŀ�������ԣ� ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (MZ == "NoSubj") {
					Ext.Msg.show({
						title: '��ʾ',
						msg: '��������Ļ�ƿ�Ŀ������,��ȷ����ƿ�Ŀ�������ԣ� ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (ZY.split("*")[0] == "NoLoc") {
					var Loc = ZY.split("*")[1]
					Ext.Msg.show({
						title: '��ʾ',
						width: 300,
						msg: '����ƾ֤ʧ�ܣ�δ�ҵ�[<span style="color:blue">' + Loc + '</span><br/>]��Ӧ�Ŀ������,���Ƚ���ά���� ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (MZ.split("*")[0] == "NoLoc") {
					var Loc = MZ.split("*")[1]
					Ext.Msg.show({
						title: '��ʾ',
						width: 300,
						msg: '����ƾ֤ʧ�ܣ�δ�ҵ�[<span style="color:blue">' + Loc + '</span><br/>]��Ӧ�Ŀ������,���Ƚ���ά������ ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (ZY.split("*")[0] == "NoDept") {
					var Dept = ZY.split("*")[1]
					//var deptname = ZY.split("*")[2]
					Ext.Msg.show({
						title: '��ʾ',
						width: 300,
						msg: '����ƾ֤ʧ�ܣ�δ�ҵ�[<br/><span style="color:blue">' + Dept + '</span><br/>],����"ƾ֤ģ������"�������ά���� ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (MZ.split("*")[0] == "NoDept") {
					var Dept = MZ.split("*")[1]
					//var deptname = MZ.split("*")[2]
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

itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
        
	    if(columnIndex=='12'){
			//p_URL = 'acct.html?acctno=2';
		    //document.getElementById("frameReport").src='acct.html';
			var records = itemGrid.getSelectionModel().getSelections();   
			var VouchNo = records[0].get("VounchNo");
			var AcctBookID=records[0].get("bookid");
			//alert(AcctBookID);
			var VouchState = '11';
			if(VouchNo!=""){
			var myPanel = new Ext.Panel({
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
									win.close();
									}
								}]
					});
					win.show();
				}
	    }else if(columnIndex=='13'){
			var records = itemGrid.getSelectionModel().getSelections();   
			var filename=records[0].get("PdfUrl");			
			if(filename!=""){	 
				window.open("../scripts/herp/acct/AcctDepartmentIncom/pdf/"+filename);
			}
		}
     });
	 
