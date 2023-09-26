// /名称: 其他类别Combo
// /描述: 其他类别Combo
// /编写者：zhangyong
// /编写日期: 2011.10.11

/*
 * 退货原因ComboBox
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
 * 调价原因 */
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
 * 调整原因ComboBox
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
 * 入库的操作类型ComboBox
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
 * 出库的操作类型ComboBox
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
 * 报损原因ComboBox
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
 * 台账类型ComboBox
 * yunhaibao
 */
var TransTypeStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['G', '入库'], ['R', '退货'],['T','转移出库'], ['K', '转移入库'], ['F', '门诊发药'],['H', '门诊退药'],
			['P', '住院发药'],['Y', '住院退药'],['A','库存调整'],['D','库存报损'],['M','制剂生成'],['X','制剂消耗']
			]
});