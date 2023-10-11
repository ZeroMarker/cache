
//---------账龄法----------//

var userid = session['LOGON.USERID'];
// var AcctBookID = IsExistAcctBook();
var ExtBadDebtsBalMetUrl = '../csp/herp.acct.acctbaddebtsextractexe.csp';

//****取当前会计期间****/
var zlCurYearMonth=new Ext.form.DisplayField({
	id:'CurYearMonth',
	columnWidth:0.08
	
});

//*****坏账提取按钮*****/
var year,month,flag,ext_btn_final;
var zlExtBadButton = new Ext.Button({
		text : '坏账提取',
		iconCls : 'option',
		columnWidth : .08,
		handler : function () {
			
			var ym = CurYearMonth.getValue();
			year = ym.split('-')[0],
			month = ym.split('-')[1];
			// alert(flag)
			if (flag == (year + "年" + month + "月坏账提取")) {
				zlGrid.store.load({
					params: {
						YearMonth: yearmonth,
						UserID: userid
					}
				});
				
				pzGrid.store.load({
					params: {
						YearMonth: yearmonth,
						UserID: userid
					}
				});
				GenVouchBtn.disable();
				return;
			}
			
			Ext.Msg.confirm('提示', '您确定要对' + year + '年' + month + '月进行坏账提取吗？ ', callback);
			function callback(id) {
				if (id == 'yes') {
					zlGrid.store.removeAll();	//清空页面数据
					pzGrid.store.removeAll();	
					
					// AgeRangeDs.reload();
					
					/* //store增加合计行
					pzGrid.getStore().on('load',function(){
						//调用增加合计行函数
						gridsum(pzGrid);
					}); */
					zlGrid.store.load({
						params:{
							YearMonth:yearmonth,
							UserID:userid
						}
					});
					
					pzGrid.store.load({
						params: {
							YearMonth: yearmonth,
							UserID: userid
						}
					});
					// flag=year + "年" + month + "月坏账提取";				
					ext_btn_final="提取操作完成";
				}
			}
					
		}
	});

//**********账龄法面板***********//
var zlPanel= new Ext.Panel({
		region : 'north',
		height : 70,
		frame : true,
		defaults : {
			bodyStyle : 'paddingBottom:3px'
		},
		items : [{
				xtype : 'panel',
				layout : 'column',
				columnWidth : 1,
				items : [{
						xtype : 'displayfield',
						value : '当前会计期间：',
						// style : "padding-top:2px;",
						columnWidth : .09
					}, zlCurYearMonth]
			}, {
				xtype : 'panel',
				layout : 'column',
				columnWidth : 1,
				items : [{
						xtype : 'displayfield',
						value : '本账套提取方式为"账龄法"。',
						style : "padding-top:5px;",
						columnWidth : .22
					}, zlExtBadButton]
			}
		]

});


//**********账龄区间数据源**********//
var AgeRangeDs=new Ext.data.Store({   
		proxy : new Ext.data.HttpProxy({
					method:'POST',
					url : ExtBadDebtsBalMetUrl + '?action=GetAgeRange&UserID=' + userid+'&start=0&limit=10'
																								
				}),
		reader : new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : 'results'
				}, ['TAreaID','TAreaDesc','DeadScale','AmtDebitSum','AmtS']),
		remoteSort : true
});


//**********账龄区间数据列**********//
var zlAgeRangeData=new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), 
			{
				header : '<div style="text-align:center">区间编号</div>',
				width : 50,
				dataIndex : 'TAreaID',
				hidden : true,
				align : 'center'
			},{
				header : '<div style="text-align:center">账龄区间</div>',
				width : 180,
				dataIndex : 'TAreaDesc',
				align : 'left'
			}, {
				header : '<div style="text-align:center">提取百分比(%)</div>',
				dataIndex : 'DeadScale',
				width : 100,
				align : 'right'
			}, {
				header : '<div style="text-align:center">应收款额度</div>',
				dataIndex : 'AmtDebitSum',
				width : 200,
				align : 'right',
				renderer:function(value){
					return Ext.util.Format.number(value,'0,000.00');
				}
			}, {
				header : '<div style="text-align:center">提取额度</div>',
				dataIndex : 'AmtS',
				width : 200,
				align : 'right',
				renderer:function(value){
					return Ext.util.Format.number(value,'0,000.00');
				}
			}
		]);
		


//***********账龄区间、提取金额展示面板************//
var zlGrid=new Ext.grid.GridPanel({
		atLoad:true,
		height:250,
		pageSize:10,
		region : 'center',
		store : AgeRangeDs,
		trackMouseOver : true, //高亮鼠标所在行
		stripeRows : true,
		cm : zlAgeRangeData,
		bbar : new Ext.PagingToolbar({
			store: AgeRangeDs,
			pageSize : 10,
			displayInfo: true,
			displayMsg: '当前显示{0} - {1}，共计{2}条。',
			emptyMsg: "没有数据"
		})

});



