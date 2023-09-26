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
				+ 'otherutil.csp?actiontype=ReasonForReturn&start=0&limit=100&StkType='+App_StkTypeCode
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
				+ 'otherutil.csp?actiontype=ReasonForAdjSpStore&start=0&limit=100&StkType='+App_StkTypeCode
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
				+ 'otherutil.csp?actiontype=ReasonForAdjustment&StkType='+App_StkTypeCode
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

		
/*
 * 物资入库的操作类型ComboBox
 */
var OperateInTypeStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : DictUrl
								+ 'otherutil.csp?actiontype=OperateType&Type=IM'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});



		/*
 * 物资出库的操作类型ComboBox
 */
var OperateOutTypeStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : DictUrl
								+ 'otherutil.csp?actiontype=OperateType&Type=OM'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 报损原因ComboBox
 */
var ReasonForScrapStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl
				+ 'otherutil.csp?actiontype=ReasonForScrap&start=0&limit=100&StkType=M'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});
/*
 * 订单取消原因ComboBox
 */
var ReasonForCancelInPoStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl
				+ 'otherutil.csp?actiontype=ReasonForCancelInPo&start=0&limit=100&StkType=M'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});