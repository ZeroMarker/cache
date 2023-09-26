Ext.onReady(function() {

			Ext.QuickTips.init();

			var khstore = new Ext.data.Store({

						url : 'dhccrmyimiaorecord1.csp?actiontype=list&patientID='
								+ patientID,

						reader : new Ext.data.JsonReader({

									totalProperty : 'results',
									root : 'rows',
									id : 'RegNo'

								}, [{
											name : 'RegNo'
										}, {
											name : 'Name'
										}, {
											name : 'Sex'
										}, {
											name : 'Birth'
										}, {
											name : 'Age'
										}, {
											name : 'hometel'
										}, {
											name : 'worktel'
										}, {
											name : 'MobPhone'
										}])

					});
			var signstore = new Ext.data.Store({

						url : 'dhccrmgrowthcurve1.csp?actiontype=signlist&patientID='
								+ patientID,

						reader : new Ext.data.JsonReader({

									totalProperty : 'results',
									root : 'rows',
									id : 'RegNo'

								}, [{
											name : 'Item4'
										}, {
											name : 'Item5'
										}, {
											name : 'Item8'
										}, {
											name : 'Item2'
										}, {
											name : 'Item3'
										}, {
											name : 'Item9'
										}, {
											name : 'Item1'
										}, {
											name : 'Item17'
										}, {
											name : 'Item18'
										}, {
											name : 'Item19'
										}, {
											name : 'Item6'
										}, {
											name : 'Item7'
										}, {
											name : 'Item13'
										}, {
											name : 'Item14'
										}, {
											name : 'Item15'
										}, {
											name : 'Item16'
										}, {
											name : 'Item20'
										}, {
											name : 'EmrDate'
										}])

					});
			var khcm = new Ext.grid.ColumnModel([{

						header : $g('登记号'),
						dataIndex : 'RegNo'
					}, {
						header : $g('姓名'),
						dataIndex : 'Name'
					}, {
						header : $g('性别'),
						dataIndex : 'Sex'
					}, {
						header : $g('出生日期'),
						dataIndex : 'Birth'
					}, {
						header : $g('年龄'),
						dataIndex : 'Age'
					}, {
						header : $g('家庭电话'),
						dataIndex : 'hometel'
					}, {
						header : $g('工作电话'),
						dataIndex : 'worktel'
					}, {
						header : $g('移动电话'),
						dataIndex : 'MobPhone'
					}]);

			var signcm = new Ext.grid.ColumnModel([{
						header : $g('身高'),
						dataIndex : 'Item4'
					}, {
						header : $g('体重'),
						dataIndex : 'Item5'
					}, {
						header : $g('头围'),
						dataIndex : 'Item8'
					}, {
						header : $g('脉搏'),
						dataIndex : 'Item2'
					}, {
						header : $g('收缩压'),
						dataIndex : 'Item3'
					}, {
						header : $g('舒张压'),
						dataIndex : 'Item9'
					}, {
						header : $g('体温'),
						dataIndex : 'Item1'
					}, {
						header : $g('呼吸'),
						dataIndex : 'Item17'
					}, {
						header : $g('血氧饱和度SPO2'),
						dataIndex : 'Item18'
					}, {
						header : $g('BMI'),
						dataIndex : 'Item19'
					}, {
						header : $g('视力'),
						dataIndex : 'Item6'
					}, {
						header : $g('辨色力'),
						dataIndex : 'Item7'
					}, {
						header : $g('左眼矫正视力'),
						dataIndex : 'Item13'
					}, {
						header : $g('右眼矫正视力'),
						dataIndex : 'Item14'
					}, {
						header : $g('左眼非矫正视力'),
						dataIndex : 'Item15'
					}, {
						header : $g('右眼非矫正视力'),
						dataIndex : 'Item16'
					}, {
						header : $g('拒检'),
						dataIndex : 'Item20'
					}, {
						header : $g('记录日期'),
						dataIndex : 'EmrDate'
					}]);

			var khgrid = new Ext.grid.GridPanel({

						region : 'north',
						height : 70,
						frame : true,
						viewConfig : {
							forceFit : true
						},
						store : khstore,
						cm : khcm

					});

			var SignInfo = new Ext.grid.GridPanel({
						title : '体征信息',
						frame : true,
						viewConfig : {
							forceFit : true
						},
						store : signstore,
						cm : signcm

					});

			var gc0to2panel = new Ext.Panel({
						frame : true,
						title : '0到2岁身高体重曲线',
						html : "<iframe src='dhccrmgrowthcurve0to2.csp?patientID="
								+ patientID
								+ "' width=100% height=100%></iframe>"
					});
			var gc2to5panel = new Ext.Panel({
						frame : true,
						title : '2到5岁身高体重曲线',
						html : "<iframe src='dhccrmgrowthcurve2to5.csp?patientID="
								+ patientID
								+ "' width=100% height=100%></iframe>"
					});
			var gc0to5panel = new Ext.Panel({
						frame : true,
						title : '0到5岁头围曲线',
						html : "<iframe src='dhccrmgrowthcurve0to5.csp?patientID="
								+ patientID
								+ "' width=100% height=100%></iframe>"
					});
			var gc2to20panel = new Ext.Panel({
						frame : true,
						title : '2到20岁身高体重曲线',
						html : "<iframe src='dhccrmgrowthcurve2to20.csp?patientID="
								+ patientID
								+ "' width=100% height=100%></iframe>"
					});
			var gcpanel = new Ext.TabPanel({

						region : 'center',
						activeTab : gc0to2panel,
						items : [gc0to2panel, gc2to5panel, gc0to5panel,
								gc2to20panel, SignInfo]
					})
			var main = new Ext.Viewport({

						layout : 'border',
						collapsible : true,
						items : [khgrid, gcpanel]
					});
			khstore.load();
			signstore.load();
		})