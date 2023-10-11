var acctbookid;

var CheckTypeUrl = '../csp/herp.acct.acctaidcheckexe.csp';
//ģ����ѯ
var strField = new Ext.form.TextField({
		id: 'StrField',
		name: 'StrField',
		// fieldLabel: '������Ŀ���ƣ�',
		emptyMsg: 'ģ����ѯ����',
		minWidth: 100,
		triggerAction: 'all'
	});
//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ', //��ͣ��ʾ
		iconCls: 'find',
		handler: function () {
			// ���ѡ��������и�ѡ��
			rowidArr=[];
			
			var str = encodeURIComponent(strField.getValue());
			var selectedData = AcctCheckTypeBookGrid.getSelectionModel().getSelections();
			var AcctCheckTypeID = selectedData[0].get("AcctCheckTypeID");
			CheckItemDs.proxy = new Ext.data.HttpProxy({
					url: CheckTypeUrl + '?action=CheckItemList' + '&AcctBookID=' + acctbookid
					 + '&AcctCheckTypeID=' + AcctCheckTypeID + '&str=' + str
				});
			CheckItemDs.load({
				params: {
					start: 0,
					limit: 25
				}
			});
		}
	});
//���Ӱ�ť
var addButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����', //��ͣ��ʾ
		iconCls: 'add',

		handler: function () {
			additemfun();
		}
	});

//�޸İ�ť
var editButton = new Ext.Toolbar.Button({
		text: '�޸�',
		tooltip: '�޸�',
		iconCls: 'edit',
		handler: function () {
			edititemfun();
		}
	});

//ɾ����ť
var delButton = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��',
		iconCls: 'remove',
		handler: function () {

			var records = AcctCheckItemGrid.getSelectionModel().getSelections();
			var rowids="";
			var len=records.length ;
			if (records.length < 1) {
				Ext.Msg.show({
					title: 'ע��',
					msg: '��ѡ����Ҫɾ��������!',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}else{
				for(var i=0;i<len;i++){
					var rowid=records[i].get("rowid");
					if(rowids==""){
						rowids=rowid;
					}else{
						rowids=rowids+","+rowid;
						
					}
					
				}
				//alert(rowids);
			}
			Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ��������?', function (btn) {
				if (btn == 'yes') {

					/* Ext.each(records, function(record) {
					if (Ext.isEmpty(record.get("rowid"))) {
					CheckItemDs.getStore().remove(record);
					return;
					} */
					// records[0].get("rowid")
					Ext.Ajax.request({
						url: CheckTypeUrl + '?action=CheckItemdel&rowid=' + rowids + '&AcctBookID=' + acctbookid,
						waitMsg: 'ɾ����...',
						failure: function (result, request) {
							Ext.Msg.show({
								title: '����',
								msg: '������������!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
						},
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								var count=jsonData.count;
								//alert(count);
								if(count==0){
								Ext.Msg.show({
									title: 'ע��',
									msg: 'ɾ���ɹ�!',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
								}else{
								   Ext.Msg.show({
									title: 'ע��',
									msg: 'ɾ���ɹ�,������'+count+"���������ڱ�ʹ�ã�����ɾ����",
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});	
									}
							var tbarnum = AcctCheckItemGrid.getBottomToolbar();  
                             tbarnum.doLoad(tbarnum.cursor);
							} else {
								var message = jsonData.info;
								Ext.Msg.show({
									title: '����',
									msg: message,
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.ERROR
								});
							}
						}

					});

				}
			});

		}
	});

//���밴ť
var uploadButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',
		iconCls: 'in',
		handler: function () {
			doimport();

		}
	});

//������Դ
var CheckItemProxy = new Ext.data.HttpProxy({
		url: CheckTypeUrl + '?action=CheckItemList' + '&AcctBookID=' + acctbookid
	});

// var CheckItemProxy;

var CheckItemDs = new Ext.data.Store({
		url: CheckTypeUrl + '?action=CheckItemList' + '&AcctBookID=' + acctbookid,
		// proxy: CheckItemProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, ['rowid', 'AcctBookID', 'BookName', 'AcctCheckTypeID', 'CheckTypeName', 'CheckItemCode', 'CheckItemName', 'IsValid',
				'StartDate', 'EndDate', 'SpellCode']),
		remoteSort: true
	});

//�洢ѡ���е�rowid
var rowidArr = [];
var AcctCheckItemGridsm = new Ext.grid.CheckboxSelectionModel({
		// id:"CheckboxSelection",
		// checkOnly: true, //��ͨ����ѡ��ѡ��
		singleSelect: false,
		// multiSelect:true,
		editable: false/* ,
		listeners: {
			rowselect: function (t, rowIndex, record) {
				if (rowidArr.indexOf(record.get("rowid")) == -1) {
					// console.log(record.get("rowid"));
					rowidArr.push(record.get("rowid"));
				}
				// console.log(rowidArr);
			},
			rowdeselect: function (t, rowIndex, record) {
				// console.log(record.get("rowid"))
				rowidArr.remove(record.get("rowid"));
				// console.log(rowidArr)
			}
		} */
	});

//������
var gridBbar = new Ext.PagingToolbar({
		store: CheckItemDs,
		pageSize: 25,
		displayInfo: true,
		displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg: "û�м�¼"/* ,
		listeners: {
			change: function (pageData) {
				// ȡ��ǰҳ����������
				var allData = pageData.store.data.items;
				// console.log(allData);
				var curRowidArr = [];
				// �����������е�rowid�洢
				
				Ext.each(allData, function (v) { //������
					curRowidArr.push(v.data.rowid);
				});

				// curRowidArr = allData.map(function (v) { //������
				// return v.data.rowid;
				// });
				// console.log(curRowidArr);
				// ����ѡ��Ľ��бȽϣ���ת����ѡ�е�ҳʱ��ʹ���ѡ��״̬��
				var rowNo = [];
				for (var i = 0; i < rowidArr.length; i++) {
					//�жϱ�����rowid����ѡ��rowid�����е�λ�ã��кţ�
					var pos = curRowidArr.indexOf(rowidArr[i])
						if (pos !== -1) {
							// alert(rowidArr[i]);
							rowNo.push(pos);
							// console.log(rowNo)
						};

				}
				// var selModel = AcctCheckItemGrid.getSelectionModel();
				// selModel.selectRows(rowNo);
				AcctCheckItemGridsm.selectRows(rowNo);
				
			}
		} */
	});
	/* //��д������ˢ�°�ť�ķ���
	gridBbar.refresh.handler=function(){
		// alert(12314);
		rowidArr=[];	//ˢ��ǰ��ո�ѡ��ѡ�е�������
		this.doLoad(this.cursor);
		
	}; */
	
	//console.log(gridBbar.refresh.listeners)
	
	
var AcctCheckItemGrid = new Ext.grid.EditorGridPanel({
		title: '��ƺ������ֵ�ά��',
		region: 'center',
		iconCls:'maintain',
		// height: 600,	//Ext.getBody().getHeight()
		atLoad: true,
		// collapsible : true,	//��������
		store: CheckItemDs,
		trackMouseOver: true,
		stripeRows: true,
		/* viewConfig:{
		forceFit:true,
		scrollOffset : 0
		},  */
		sm: AcctCheckItemGridsm,
		loadMask: true,
		cm: new Ext.grid.ColumnModel([
				new Ext.grid.RowNumberer(),
				// AcctCheckItemGridsm, 
				{
					header: '<div style="text-align:center">ID</div>',
					dataIndex: 'rowid',
					Width: 40,
					align: 'center',
					tdCls: 'tdValign',
					hidden: true
				}, {
					header: '<div style="text-align:center">��λ���״���</div>',
					dataIndex: 'AcctBookID',
					Width: 40,
					align: 'center',
					hidden: true
				}, {
					id: 'AcctBookName',
					header: '<div style="text-align:center">��λ��������</div>',
					dataIndex: 'BookName',
					width: 120,
					/* renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
					cellmeta.css="cellColor2";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
					return '<span style="color:brown;cursor:hand;backgroundColor:red">'+value+'</span>';
					}, */
					//align:'center',
					editable: true
				}, {
					header: '<div style="text-align:center">��ƺ���������</div>',
					dataIndex: 'AcctCheckTypeID',
					Width: 40,
					align: 'center',
					hidden: true
				}, {
					id: 'CheckTypeName',
					header: '<div style="text-align:center">��ƺ������</div>',
					dataIndex: 'CheckTypeName',
					width: 120,
					align: 'center'
				}, {
					id: 'CheckItemCode',
					header: '<div style="text-align:center">������Ŀ����</div>',
					dataIndex: 'CheckItemCode',
					width: 100
					//align:'center'
				}, {
					id: 'CheckItemName',
					header: '<div style="text-align:center">������Ŀ����</div>',
					dataIndex: 'CheckItemName',
					width: 240,
					renderer: function (value, meta, record) {
						meta.attr = 'style="white-space:normal;"'; //���ȳ������ʱ���С�vertical-align:middle;
						return value;
					}
					//align:'center'
				}, {
					id: 'IsValid',
					header: '<div style="text-align:center">�Ƿ���Ч</div>',
					dataIndex: 'IsValid',
					//minwidth:20,
					width: 65,
					align: 'center'
				}, {
					id: 'StartDate',
					header: '<div style="text-align:center">��ʼʱ��</div>',
					dataIndex: 'StartDate',
					width: 90,
					align: 'center'
				}, {
					id: 'EndDate',
					header: '<div style="text-align:center">��ֹʱ��</div>',
					dataIndex: 'EndDate',
					width: 90,
					align: 'center'
				}, {
					id: 'SpellCode',
					header: '<div style="text-align:center">ƴ����</div>',
					dataIndex: 'SpellCode',
					width: 150,
					align: 'center',
					hidden: true
				}
			]),
		tbar: ['������Ŀ���ƣ�', strField, '-', findButton, '-', addButton, '-', editButton, '-', delButton, '-', uploadButton],
		bbar:gridBbar

	});
	
	
	