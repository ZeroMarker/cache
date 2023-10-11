var acctbookid =IsExistAcctBook();

var CheckTypeUrl='../csp/herp.acct.acctaidcheckexe.csp';

//���Ӱ�ť
var addButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip:'����',        //��ͣ��ʾ
		iconCls: 'add',
		handler:function(){
				addtypefun();
	}
});


//�޸İ�ť
var editButton = new Ext.Toolbar.Button({
		text:'�޸�',
		tooltip:'�޸�',
		iconCls: 'edit',
		handler:function(){
				edittypefun();
		}
	});
//ɾ����ť
var delButton = new Ext.Toolbar.Button({
		text : 'ɾ��',
		tooltip : 'ɾ��',
		iconCls : 'remove',
		handler :function() {
			
			var records = AcctCheckTypeBookGrid.getSelectionModel().getSelections();
			if(records.length<1){
				Ext.Msg.show({
					title:'ע��',
					msg:'��ѡ����Ҫɾ��������!',
					buttons: Ext.Msg.OK,
					icon:Ext.MessageBox.WARNING
				});
				return;
			}
			Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ���˺��������?', function(btn) {
				if (btn == 'yes') {
				
					/* Ext.each(records, function(record) {
						if (Ext.isEmpty(record.get("rowid"))) {
							Ext.Msg.show({
								title:'ע��',
								msg:'��ѡ����Ҫɾ��������!',
								buttons: Ext.Msg.OK,
								icon:Ext.MessageBox.WARNING
							});
							CheckTypeBookDs.getStore().remove(record);
							return;
						}
 */
						Ext.Ajax.request({
							url : CheckTypeUrl + '?action=TypeBookdel&rowid='+records[0].get("rowid")+'&AcctBookID='+acctbookid,
							waitMsg : 'ɾ����...',
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
									Ext.Msg.show({
										title:'ע��',
										msg:'ɾ���ɹ�!',
										buttons: Ext.Msg.OK,
										icon:Ext.MessageBox.INFO
									});
									CheckTypeBookDs.load({
										params : {
											start : 0,
											limit : 25
										}
									});
									/* CheckItemDs.load({
										params:{
											start : 0,
											limit : 25
										}
									}); */		
								} else {
									var message = jsonData.info;
									Ext.Msg.show({
												title : '����',
												msg : message,
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
										}
							}
							
						});
						
				// });
			}
		});
		
	}
});

//������Դ
var CheckTypeBookProxy = new Ext.data.HttpProxy({
		url:CheckTypeUrl+'?action=TypeBookList'+'&AcctBookID='+acctbookid
});
var CheckTypeBookDs = new Ext.data.Store({
		proxy:CheckTypeBookProxy,
		reader:new Ext.data.JsonReader({
					root:'rows',
					totalProperty:'results'
		},['rowid','AcctBookID','BookName','AcctCheckTypeID','CheckTypeName','isValid','IsFinishInit',
		'StartYear','StartMonth','EndYear','EndMonth']),
		remoteSort:true
});
	CheckTypeBookDs.load({
		params:{
			start:0,
			limit:25
		}
	});

var AcctCheckTypeBookGrid = new Ext.grid.GridPanel({
		title: '������������',
		iconCls:'find',
		region: 'west',
		width: 540,
		height: 600,	//Ext.getBody().getHeight()
		atLoad:true,
		collapsible : true,	//��������
		autoScoll:true, //������
		store:CheckTypeBookDs,
		trackMouseOver:true,
		stripeRows:true,
		viewConfig:{
			//forceFit:true,
			scrollOffset:0
		},
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true
		}),
		loadMask:true,
		columns:[
			new Ext.grid.RowNumberer(),
			{
				header:'<div style="text-align:center">ID</div>',
				dataIndex:'rowid',
				width:40,
				align:'center',
				hidden:true
			},{
				header:'<div style="text-align:center">��λ���״���</div>',
				dataIndex:'AcctBookID',
				width:40,
				align:'center',
				hidden:true
			},{
				id:'AcctBookName',
				header:'<div style="text-align:center">��λ��������</div>',
				//type:AcctBookNameField,
				dataIndex:'BookName',
				width:120,
				//align:'center',
				editable:true
			},{
				header:'<div style="text-align:center">��ƺ���������</div>',
				dataIndex:'AcctCheckTypeID',
				width:40,
				align:'center',
				hidden:true
			},{
				id:'CheckTypeName',
				header:'<div style="text-align:center">��ƺ������</div>',
				//type:CheckTypeField,
				dataIndex:'CheckTypeName',
				width:120,
				align:'center'
			},{
				id:'isValid',
				header:'<div style="text-align:center">�Ƿ���Ч</div>',
				dataIndex:'isValid',
				width:65,
				align:'center'
			},{
				id:'IsFinishInit',
				header:'<div style="text-align:center">�Ƿ���ɳ�ʼ��</div>',
				dataIndex:'IsFinishInit',
				width:110,
				align:'center',
				editable:false
			},{
				id:'StartYear',
				header:'<div style="text-align:center">������</div>',
				dataIndex:'StartYear',
				width:50,
				align:'center'
			},{
				id:'StartMonth',
				header:'<div style="text-align:center">������</div>',
				dataIndex:'StartMonth',
				width:50,
				align:'center'
			},{
				id:'EndYear',
				header:'<div style="text-align:center">ͣ����</div>',
				dataIndex:'EndYear',
				width:50,
				align:'center'
			},{
				id:'EndMonth',
				header:'<div style="text-align:center">ͣ����</div>',
				dataIndex:'EndMonth',
				width:50,
				align:'center'
			}
		],
		tbar:['-',addButton,'-',editButton,'-',delButton],
		bbar : new Ext.PagingToolbar({
			store : CheckTypeBookDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg : "û�м�¼"
		})	
	
});
/* 
//��д������ˢ�°�ť�ķ���
	AcctCheckTypeBookGrid.bbar.refresh.handler=function(){
		alert(12314);
		rowidArr=[];	//ˢ��ǰ��ո�ѡ��ѡ�е�������
		this.doLoad(this.cursor);
		
	};
 */
AcctCheckTypeBookGrid.on('rowclick', function (grid, rowIndex, e) {
	var selectedRow = CheckTypeBookDs.data.items[rowIndex];
	// var rowidArr=[];
	var AcctCheckTypeID = selectedRow.data['AcctCheckTypeID'];
	CheckItemDs.proxy = new Ext.data.HttpProxy({
			url: CheckTypeUrl + '?action=CheckItemList' + '&AcctBookID=' + acctbookid + '&AcctCheckTypeID=' + AcctCheckTypeID
		});

	// ���ѡ��������и�ѡ��
	rowidArr = [];
	
	CheckItemDs.load({
		params: {
			start: 0,
			limit: 25
		}
	});

});

