// /����: �������Combo
// /����: �������Combo
// /��д�ߣ�zhangyong
// /��д����: 2011.10.11

/*
 * �˻�ԭ��ComboBox
 */
var ReasonForReturnStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl
				+ 'otherutil.csp?actiontype=ReasonForReturn&start=0&limit=100'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * ����ԭ�� */
var ReasonForAdjSpStore= new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl
				+ 'otherutil.csp?actiontype=ReasonForAdjSpStore&start=0&limit=100'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description','RowId'])
});

/*
 * ����ԭ��ComboBox
 */
var ReasonForAdjustMentStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl
				+ 'otherutil.csp?actiontype=ReasonForAdjustment'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

		
/*
 * ���Ĳ�������ComboBox
 */
var OperateInTypeStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : DictUrl
								+ 'otherutil.csp?actiontype=OperateType&Type=I'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId','Default'])
		});

		/*
 * ����Ĳ�������ComboBox
 */
var OperateOutTypeStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : DictUrl
								+ 'otherutil.csp?actiontype=OperateType&Type=O'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId','Default'])
		});


/*
 * ����ԭ��ComboBox
 * LiangQiang
 */
var ReasonForScrapurnStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl
				+ 'otherutil.csp?actiontype=ReasonForScrap&start=0&limit=100'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * ̨������ComboBox
 * yunhaibao
 */
var TransTypeStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['G', '���'], ['R', '�˻�'],['T','ת�Ƴ���'], ['K', 'ת�����'], ['F', '���﷢ҩ'],['H', '������ҩ'],
			['P', 'סԺ��ҩ'],['Y', 'סԺ��ҩ'],['A','������'],['D','��汨��'],['M','�Ƽ�����'],['X','�Ƽ�����']
			]
});