var testJsonData = {
	results : 8,
	rows : [{
				rowid : '1',
				date : '2010-6-18',
				person : '张三',
				deptcode : '1',
				deptname : '科室1',
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
				person : '张三',
				deptcode : '2',
				deptname : '科室2',
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
				person : '李四',
				deptcode : '1',
				deptname : '科室1',
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
				person : '李四',
				deptcode : '2',
				deptname : '科室2',
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
				person : '张三',
				deptcode : '1',
				deptname : '科室1',
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
				person : '张三',
				deptcode : '2',
				deptname : '科室2',
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
				person : '李四',
				deptcode : '1',
				deptname : '科室1',
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
				person : '李四',
				deptcode : '2',
				deptname : '科室2',
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
			header : '日期',
			dataIndex : 'date',
			width : 100,
			sortable : true
		}, {
			header : '病人类别',
			dataIndex : 'patientType',
			width : 100,
			sortable : true
		}, {
			header : '收入合计',
			dataIndex : 'incomeAll',
			width : 100,
			sortable : true
		}, {
			header : '现金',
			dataIndex : 'cash',
			width : 100,
			sortable : true
		}, {
			header : '支票',
			dataIndex : 'check',
			width : 100,
			sortable : true
		}, {
			header : '银联卡',
			dataIndex : 'unionPay',
			width : 100,
			sortable : true
		}, {
			header : '个人记账',
			dataIndex : 'personalAccount',
			width : 100,
			sortable : true
		}, {
			header : '大额支付',
			dataIndex : 'largePay',
			width : 100,
			sortable : true
		}, {
			header : '收预交金',
			dataIndex : 'prepaid',
			width : 100,
			sortable : true
		}, {
			header : '退预交金',
			dataIndex : 'prepaidBack',
			width : 100,
			sortable : true
		}, {
			header : '临时凭证号',
			dataIndex : 'tempCertificateNo ',
			width : 100,
			sortable : true
		}, {
			header : '凭证编号',
			dataIndex : 'certificateNo',
			width : 100,
			sortable : true
		}]);

var autohisoutclearingMain = new Ext.grid.GridPanel({
			title : '门诊结算',
			store : tmpStore, // new Ext.form.DateField(),
			cm : autohisoutclearingCM,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : ['收费时间:', beginDate, '至', stopDate, '-'],
			plugins : [new Ext.ux.plugins.GroupHeaderGrid({
						rows : [[{}, {}, {}, {
									header : '支付方式',
									colspan : 6,
									align : 'center',
									dataIndex : 'incomeAll'
								}, {
									header : '预交金',
									colspan : 2,
									align : 'center',
									dataIndex : 'prepaid'
								}, {}, {}]],
						hierarchicalColMenu : true
					})]
		});

tmpStore.load();