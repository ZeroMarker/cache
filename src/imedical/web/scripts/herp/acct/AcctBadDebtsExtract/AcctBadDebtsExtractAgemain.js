
//---------���䷨----------//

var userid = session['LOGON.USERID'];
// var AcctBookID = IsExistAcctBook();
var ExtBadDebtsBalMetUrl = '../csp/herp.acct.acctbaddebtsextractexe.csp';

//****ȡ��ǰ����ڼ�****/
var zlCurYearMonth=new Ext.form.DisplayField({
	id:'CurYearMonth',
	columnWidth:0.08
	
});

//*****������ȡ��ť*****/
var year,month,flag,ext_btn_final;
var zlExtBadButton = new Ext.Button({
		text : '������ȡ',
		iconCls : 'option',
		columnWidth : .08,
		handler : function () {
			
			var ym = CurYearMonth.getValue();
			year = ym.split('-')[0],
			month = ym.split('-')[1];
			// alert(flag)
			if (flag == (year + "��" + month + "�»�����ȡ")) {
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
			
			Ext.Msg.confirm('��ʾ', '��ȷ��Ҫ��' + year + '��' + month + '�½��л�����ȡ�� ', callback);
			function callback(id) {
				if (id == 'yes') {
					zlGrid.store.removeAll();	//���ҳ������
					pzGrid.store.removeAll();	
					
					// AgeRangeDs.reload();
					
					/* //store���Ӻϼ���
					pzGrid.getStore().on('load',function(){
						//�������Ӻϼ��к���
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
					// flag=year + "��" + month + "�»�����ȡ";				
					ext_btn_final="��ȡ�������";
				}
			}
					
		}
	});

//**********���䷨���***********//
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
						value : '��ǰ����ڼ䣺',
						// style : "padding-top:2px;",
						columnWidth : .09
					}, zlCurYearMonth]
			}, {
				xtype : 'panel',
				layout : 'column',
				columnWidth : 1,
				items : [{
						xtype : 'displayfield',
						value : '��������ȡ��ʽΪ"���䷨"��',
						style : "padding-top:5px;",
						columnWidth : .22
					}, zlExtBadButton]
			}
		]

});


//**********������������Դ**********//
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


//**********��������������**********//
var zlAgeRangeData=new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), 
			{
				header : '<div style="text-align:center">������</div>',
				width : 50,
				dataIndex : 'TAreaID',
				hidden : true,
				align : 'center'
			},{
				header : '<div style="text-align:center">��������</div>',
				width : 180,
				dataIndex : 'TAreaDesc',
				align : 'left'
			}, {
				header : '<div style="text-align:center">��ȡ�ٷֱ�(%)</div>',
				dataIndex : 'DeadScale',
				width : 100,
				align : 'right'
			}, {
				header : '<div style="text-align:center">Ӧ�տ���</div>',
				dataIndex : 'AmtDebitSum',
				width : 200,
				align : 'right',
				renderer:function(value){
					return Ext.util.Format.number(value,'0,000.00');
				}
			}, {
				header : '<div style="text-align:center">��ȡ���</div>',
				dataIndex : 'AmtS',
				width : 200,
				align : 'right',
				renderer:function(value){
					return Ext.util.Format.number(value,'0,000.00');
				}
			}
		]);
		


//***********�������䡢��ȡ���չʾ���************//
var zlGrid=new Ext.grid.GridPanel({
		atLoad:true,
		height:250,
		pageSize:10,
		region : 'center',
		store : AgeRangeDs,
		trackMouseOver : true, //�������������
		stripeRows : true,
		cm : zlAgeRangeData,
		bbar : new Ext.PagingToolbar({
			store: AgeRangeDs,
			pageSize : 10,
			displayInfo: true,
			displayMsg: '��ǰ��ʾ{0} - {1}������{2}����',
			emptyMsg: "û������"
		})

});



