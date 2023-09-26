var testJsonData = {
	results : 8,
	rows : [{
				rowid : '1',
				date : '2010-6-18',
				person : '����',
				deptcode : '1',
				deptname : '����1',
				allmoney : '21',
				jiancha : '1',
				guahao : '2',
				huayan : '3',
				zhenliao : '4',
				zhiliao : '5',
				shoushu : '6',
				tempnumber : '20100618',
				cernumber : '20100618'
			}, {
				rowid : '2',
				date : '2010-6-18',
				person : '����',
				deptcode : '2',
				deptname : '����2',
				allmoney : '21',
				jiancha : '1',
				guahao : '2',
				huayan : '3',
				zhenliao : '4',
				zhiliao : '5',
				shoushu : '6',
				tempnumber : '20100618',
				cernumber : '20100618'
			}, {
				rowid : '3',
				date : '2010-6-18',
				person : '����',
				deptcode : '1',
				deptname : '����1',
				allmoney : '21',
				jiancha : '1',
				guahao : '2',
				huayan : '3',
				zhenliao : '4',
				zhiliao : '5',
				shoushu : '6',
				tempnumber : '20100618',
				cernumber : '20100618'
			}, {
				rowid : '4',
				date : '2010-6-18',
				person : '����',
				deptcode : '2',
				deptname : '����2',
				allmoney : '21',
				jiancha : '1',
				guahao : '2',
				huayan : '3',
				zhenliao : '4',
				zhiliao : '5',
				shoushu : '6',
				tempnumber : '20100618',
				cernumber : '20100618'
			}, {
				rowid : '5',
				date : '2010-6-19',
				person : '����',
				deptcode : '1',
				deptname : '����1',
				allmoney : '21',
				jiancha : '1',
				guahao : '2',
				huayan : '3',
				zhenliao : '4',
				zhiliao : '5',
				shoushu : '6',
				tempnumber : '20100619',
				cernumber : '20100619'
			}, {
				rowid : '6',
				date : '2010-6-19',
				person : '����',
				deptcode : '2',
				deptname : '����2',
				allmoney : '21',
				jiancha : '1',
				guahao : '2',
				huayan : '3',
				zhenliao : '4',
				zhiliao : '5',
				shoushu : '6',
				tempnumber : '20100619',
				cernumber : '20100619'
			}, {
				rowid : '7',
				date : '2010-6-19',
				person : '����',
				deptcode : '1',
				deptname : '����1',
				allmoney : '21',
				jiancha : '1',
				guahao : '2',
				huayan : '3',
				zhenliao : '4',
				zhiliao : '5',
				shoushu : '6',
				tempnumber : '20100619',
				cernumber : '20100619'
			}, {
				rowid : '8',
				date : '2010-6-19',
				person : '����',
				deptcode : '2',
				deptname : '����2',
				allmoney : '21',
				jiancha : '1',
				guahao : '2',
				huayan : '3',
				zhenliao : '4',
				zhiliao : '5',
				shoushu : '6',
				tempnumber : '20100619',
				cernumber : '20100619'
			}]
};

var tmpStore = new Ext.data.Store({
	proxy : new Ext.data.MemoryProxy(testJsonData),
	reader : new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : 'results'
			}, ['date'])
		// remoteSort: true
	});

var beginDate = new Ext.form.DateField({
			format : 'Y-m-d'
		});

var stopDate = new Ext.form.DateField({
			format : 'Y-m-d'
		});

var autohisoutclearingCM = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(), {
			header : '����',
			dataIndex : 'date',
			width : 100,
			sortable : true
		}, {
			header : '�������',
			dataIndex : 'patientType',
			width : 100,
			sortable : true
		}, {
			header : '����ϼ�',
			dataIndex : 'incomeAll',
			width : 100,
			sortable : true
		}, {
			header : '�ֽ�',
			dataIndex : 'cash',
			width : 100,
			sortable : true
		}, {
			header : '֧Ʊ',
			dataIndex : 'check',
			width : 100,
			sortable : true
		}, {
			header : '������',
			dataIndex : 'unionPay',
			width : 100,
			sortable : true
		}, {
			header : '���˼���',
			dataIndex : 'personalAccount',
			width : 100,
			sortable : true
		}, {
			header : '���֧��',
			dataIndex : 'largePay',
			width : 100,
			sortable : true
		}, {
			header : '��Ԥ����',
			dataIndex : 'prepaid',
			width : 100,
			sortable : true
		}, {
			header : '��Ԥ����',
			dataIndex : 'prepaidBack',
			width : 100,
			sortable : true
		}, {
			header : '��ʱƾ֤��',
			dataIndex : 'tempCertificateNo ',
			width : 100,
			sortable : true
		}, {
			header : 'ƾ֤���',
			dataIndex : 'certificateNo',
			width : 100,
			sortable : true
		}]);

var autohisoutclearingMain = new Ext.grid.GridPanel({
			title : '�������',
			store : tmpStore, // new Ext.form.DateField(),
			cm : autohisoutclearingCM,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : ['�շ�ʱ��:', beginDate, '��', stopDate, '-'],
			plugins : [new Ext.ux.plugins.GroupHeaderGrid({
						rows : [[{}, {}, {}, {
									header : '֧����ʽ',
									colspan : 6,
									align : 'center',
									dataIndex : 'incomeAll'
								}, {
									header : 'Ԥ����',
									colspan : 2,
									align : 'center',
									dataIndex : 'prepaid'
								}, {}, {}]],
						hierarchicalColMenu : true
					})]
		});

tmpStore.load();