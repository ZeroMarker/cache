/***************************/
/*****creator:yanglf
/*****description:坏账提取
/***************************/

//---------余额法----------//

var userid = session['LOGON.USERID'];
var AcctBookID = GetAcctBookID();
var ExtBadDebtsBalMetUrl = '../csp/herp.acct.acctbaddebtsextractexe.csp';

/**************余额法**************/

//****取当前会计期间****/
var CurYearMonth = new Ext.form.DisplayField({
		id: 'CurYearMonth',
		columnWidth: 0.08

	});
//****取应收款余额****/
var EndSumField = new Ext.form.DisplayField({
		id: 'EndSumField',
		columnWidth: 0.15
	});

var endsums = 0, perc = 0; //余额法提取额度
var yearmonth;
var year, month, flag, ext_btn_final;
//查询当前期间
Ext.Ajax.request({
	url: ExtBadDebtsBalMetUrl + '?action=GetCurYearMonth&UserID=' + userid,
	method: 'GET',
	success: function (result, request) {
		var respText = Ext.util.JSON.decode(result.responseText);
		YearMonth = respText.info;
		strs = YearMonth.split('^');
		year = strs[0],
		month = strs[1];
		yearmonth = year + '-' + month;
		CurYearMonth.setValue(yearmonth);
		zlCurYearMonth.setValue(yearmonth); //账龄法会计期间
		// oplogstr = year + "年" + month + "月坏账提取";
		//取应收款余额和额度
		Ext.Ajax.request({
			url: ExtBadDebtsBalMetUrl + '?action=GetEndSum&UserID=' + userid + '&YearMonth=' + yearmonth,
			method: 'GET',
			success: function (result, request) {
				var respText = Ext.util.JSON.decode(result.responseText);
				str = respText.info;
				endsums = str.split('^')[0]; //应收款余额总和
				perc = str.split('^')[1]; //余额法提取比率
				// alert(endsums)
				if(!endsums) endsums=0;
				EndSumField.setValue(Ext.util.Format.number(endsums, '0,000.00'));
			},
			failure: function (result, request) {
				return;
			}
		});
		//end

		//判断是否本期间坏账已提取
		var oplogstr = year + "年" + month + "月坏账提取";
		// alert(oplogstr);
		// console.log(oplogstr)
		Ext.Ajax.request({
			url: ExtBadDebtsBalMetUrl + '?action=IfRepVouch&UserID=' + userid + '&oplogstr=' + encodeURI(oplogstr),
			method: 'GET',
			success: function (result, request) {
				var respText = Ext.util.JSON.decode(result.responseText);
				flag = respText.info;
				if(flag == (year + "年" + month + "月坏账提取")) GenVouchBtn.disable();
				// alert(str);
				/* if(flag==1){
				Ext.Msg.show({
				title:'提示',
				msg:year+'年'+month+'月坏账提取凭证已生成，无需再生成！ ',
				icon:Ext.Msg.INFO,
				buttons:Ext.MessageBox.OK
				});
				return;
				}else{
				scpzcr();
				} */
			},
			failure: function (result, request) {
				return;
			}
		});
	},
	failure: function (result, request) {
		return;
	}

});

//*****坏账提取按钮*****/
var ExtBadButton = new Ext.Button({
		text: '坏账提取',
		iconCls: 'dataabstract',
		cls: 'x-btn-text-icon ',
		columnWidth: .08,
		handler: function () {
			//应收款余额为零，无需进行后续操作
			// alert(endsums+"^"+!endsums)
			if (endsums == 0) {
				Ext.Msg.show({
					title: '注意',
					msg: '应收款余额为零，无需进行坏账提取！ ',
					icon: Ext.Msg.INFO,
					buttons: Ext.Msg.OK
				});
				// ExtBadButton.disable();
				GenVouchBtn.disable();
				return;
			}
			//本期间凭证生成后，只进行查询
			// alert(flag)
			if (flag == (year + "年" + month + "月坏账提取")) {
				pzGrid.store.load({
					params: {
						YearMonth: yearmonth,
						UserID: userid
					}
				});
				GenVouchBtn.disable();
				return;
			}
			//生成凭证明细
			/* var ym = CurYearMonth.getValue();
			year = ym.split('-')[0],
			month = ym.split('-')[1]; */
			Ext.Msg.confirm('提示', '您确定要对' + year + '年' + month + '月进行坏账提取吗？ ', callback);
			function callback(id) {
				if (id == 'yes') {

					pzGrid.store.removeAll(); //清空页面数据
					Ext.Msg.show({
						title: '注意',
						width: 400,
						msg: '坏账提取比例为：' + Math.round(perc * 100) + '%，<br>提取额度为：' + Ext.util.Format.number(endsums, '0,000.00') + '×' +Math.round(perc * 100) + '%=' + Ext.util.Format.number(endsums * perc, '0,000.00'),
						icon: Ext.Msg.INFO,
						buttons: Ext.MessageBox.OK
					});

					pzGrid.store.load({
						params: {
							YearMonth: yearmonth,
							UserID: userid
						}
					});
					//已执行坏账提取操作
					// flag=year + "年" + month + "月坏账提取";
					ext_btn_final="提取操作完成";
				}
			}

		}
	});

//******临时凭证插入凭证表按钮**********/
function scpzcr() {
	// alert("凭证插入");
	Ext.Msg.confirm('提示', '您确定要生成' + year + '年' + month + '月的坏账凭证吗？ ', callback);
	function callback(id) {
		if (id == 'yes') {
			Ext.Ajax.request({
				url: ExtBadDebtsBalMetUrl + '?action=Add&UserID=' + userid + '&YearMonth=' + yearmonth,
				method: 'GET',
				success: function (result, request) {
					var respText = Ext.util.JSON.decode(result.responseText);
					str = respText.info;
					// alert(str);
					if (str == "") {
						Ext.Msg.show({
							title: '提示',
							msg: '生成凭证成功！ ',
							icon: Ext.Msg.INFO,
							buttons: Ext.MessageBox.OK
						});
						pzGrid.store.load({
							params: {
								YearMonth: yearmonth,
								UserID: userid
							}
						});
						GenVouchBtn.disable();	//生成完成后按钮不可用
						flag=year + "年" + month + "月坏账提取";
						return;
					} else {
						Ext.Msg.show({
							title: '错误',
							msg: '生成凭证时出错！ ',
							icon: Ext.Msg.ERROR,
							buttons: Ext.MessageBox.OK
						});
						return;
					}
				},
				failure: function (result, request) {
					return;
				}
			});
		}
	}
}

var GenVouchBtn = new Ext.Button({
		text: '&nbsp;生成凭证',
		width: 80,
		tooltip: '生成凭证',
		iconCls: 'createvouch',
		handler: function () {
			// alert(pzGrid.getStore().getAt(0).get('VouchNo'))
			// if(flag!==2){
			// if (flag != year + "年" + month + "月坏账提取") {
			if(ext_btn_final!="提取操作完成"){
				Ext.Msg.show({
					title: '错误',
					msg: '请先进行坏账提取操作！ ',
					icon: Ext.Msg.ERROR,
					buttons: Ext.MessageBox.OK
				});
				return;
			} else {
				scpzcr();
			}

		}

	});

//*****余额法面板*****/
var yePanel = new Ext.Panel({
		region: 'north',
		height: 70,
		frame: true,
		defaults: {
			bodyStyle: 'padding:0 0 0 10;line-height:20px;'

		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				columnWidth: 1,
				items: [{
						xtype: 'displayfield',
						value: '当前会计期间:',
						columnWidth: .09
					}, CurYearMonth]
			}, {
				xtype: 'panel',
				layout: 'column',
				columnWidth: 1,
				items: [{
						xtype: 'displayfield',
						value: '本账套提取方式为"余额法"；当前应收款余额为:',
						columnWidth: .28
					}, EndSumField, ExtBadButton]
			}
		]

	});

//*********临时凭证数据源*********//
var VouchDsproxy = new Ext.data.HttpProxy({
		method: 'POST',
		url: ExtBadDebtsBalMetUrl + '?action=TempBadDebtsVouch'

	});
var VouchDs = new Ext.data.Store({
		proxy: VouchDsproxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, ['VouchNo', 'AcctSubjCode', 'AcctSubjName', 'Summary', 'AmtDebit', 'AmtCredit']),
		remoteSort: true
	});
// console.log(VouchDs)
//*********添加合计********//
/*function gridsum(grid){
var AmtDebitSum=0,AmtCreditSum=0;	//借贷方金额合计
grid.store.each(function(record){
// alert(record.data.AmtDebit+"^"+Number(record.data.AmtDebit))
AmtDebitSum+=Number(record.data.AmtDebit);
AmtCreditSum+=Number(record.data.AmtCredit);
});
var newdata=new Ext.data.Record({
Summary:'合计：',
AmtDebit:AmtDebitSum,
AmtCredit:AmtCreditSum
});
// grid.store.insert(0,newdata);	//添加到第一行
grid.store.insert(grid.store.getCount(),newdata);	//添加到最后一行
}*/

//**********数据列**********//
var columnData = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(), {
			header: '<div style="text-align:center">凭证号</div>',
			width: 100,
			dataIndex: 'VouchNo',
			sortable: true,
			align: 'left',
			renderer: function (v) {
				if (v) {
					return "<span style='color:blue;cursor:hand;'><u>" + v + "</u></span>";
				}
			}
		}, {
			header: '<div style="text-align:center">科目编码</div>',
			width: 150,
			dataIndex: 'AcctSubjCode',
			// sortable : true,
			align: 'left'
		}, {
			header: '<div style="text-align:center">科目名称</div>',
			dataIndex: 'AcctSubjName',
			width: 180,
			align: 'left'
		}, {
			header: '<div style="text-align:center">摘要</div>',
			dataIndex: 'Summary',
			width: 240,
			// align : 'left',
			renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
				// alert(value);
				if (value == "合计:") {
					return '<div style="text-align:right;">' + value + '</div>';
				} else {
					return value;
				}

			}
		}, {
			header: '<div style="text-align:center">借方金额</div>',
			dataIndex: 'AmtDebit',
			width: 200,
			align: 'right',
			renderer: function (value) {
				return Ext.util.Format.number(value, '0,000.00');
			}
		}, {
			header: '<div style="text-align:center">贷方金额</div>',
			dataIndex: 'AmtCredit',
			width: 200,
			align: 'right',
			renderer: function (value) {
				return Ext.util.Format.number(value, '0,000.00');
			}
		}
	]);

//**********生成凭证显示**********//
var pzGrid = new Ext.grid.GridPanel({
		// atLoad:true,
		region: 'south',
		height: 510,
		autoScroll: true,
		store: VouchDs,
		pageSize: 25,
		trackMouseOver: true, //高亮鼠标所在行
		stripeRows: true,
		tbar: [GenVouchBtn],
		cm: columnData /* ,
		bbar : new Ext.PagingToolbar({
		store :VouchDs,
		pageSize : 25,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}条。',
		emptyMsg: "没有数据"
		}) */
	});

pzGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	if (columnIndex == '1') {
		//p_URL = 'acct.html?acctno=2';
		//document.getElementById("frameReport").src='acct.html';
		var records = pzGrid.getSelectionModel().getSelections();
		var VouchNo = records[0].get("VouchNo");
		// var VouchState = records[0].get("VouchState1");
		if(!VouchNo) return;
		var myPanel = new Ext.Panel({
				layout: 'fit',
				//scrolling="auto"
				html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userid + '&acctstate=11&bookID=' + AcctBookID + '&SearchFlag=1" /></iframe>'
				// frame : true
			});

		var win = new Ext.Window({
				title: '凭证查看',
				width: 1093,
				height: 620,
				resizable: false,
				closable: true,
				draggable: true,
				resizable: false,
				layout: 'fit',
				modal: false,
				plain: true, // 表示为渲染window body的背景为透明的背景
				//bodyStyle : 'padding:5px;',
				items: [myPanel],
				buttonAlign: 'center',
				buttons: [{
						text: '关闭',
						type: 'button',
						handler: function () {
							win.close();
						}
					}
				]
			});
		win.show();
	};

});
