/**
 * 名称: 库存动销查询
 * 作者: pushuangcai
 * 日期: 2022-05-09
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v3.query.buysales.csp';
PHA_COM.App.Name = $g('库存动销查询');
PHA_COM.App.AppName = 'DHCSTLOCSTKMOVE';
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = false;

var ParamProp = PHA_COM.ParamProp(PHA_COM.App.AppName);

PHA_COM.VAR = {
	hospId: session['LOGON.HOSPID'],
	groupId: session['LOGON.GROUPID'],
	userId: session['LOGON.USERID'],
	locId: session['LOGON.CTLOCID']
};

$(function(){
	InitComponent();
	QUE_FORM.InitComponents(); 		// 公共组件 component.js
	
	InitGridIncItmLoc();
	InitGridBuySalesDetail();
	
	InitDefVal();
	InitEvents();
	PHA_COM.SetPanel($('#gridIncItmLoc').datagrid('getPanel'), "库存动销查询");
})

/**
 * 查询台账汇总
 */
function Query(){
	var pJson = GetParams();
	if (pJson === null){
		return;	
	}
	$('#gridIncItmLoc').datagrid('loading');
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'LocItmBuyAndSales',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
	        $('#gridIncItmLoc').datagrid('loadData', data);
	    }
	);
}

/**
 * 获取界面参数
 */
function GetParams(){
	var formData = QUE_FORM.GetFormData();
	var intrTypeKwArr = $('#intrTypeKw').keywords('getSelected');
	var intrTypeArr = [];
	for(var i = 0; i < intrTypeKwArr.length; i++){
		intrTypeArr.push(intrTypeKwArr[i].id);
	}
	formData.intrTypeStr = intrTypeArr.join("^");
	return formData;
}

/**
 * 初始化界面默认值
 */
function InitDefVal(){
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate("t-30"));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate("t"));
	$('#startTime').timespinner('setValue', PHA_UTIL.SysTime("s"));
	$('#endTime').timespinner('setValue', PHA_UTIL.SysTime("l"));
	$('#dspDays').numberbox('setValue', 30);
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
}

/**
 * 绑定事件
 */
function InitEvents(){
	PHA_EVENT.Bind('#btnFind', 'click', function () {
        Query();
    });
	PHA_EVENT.Bind('#btnClear', 'click', function () {
        Clear();
    });
}

function InitComponent(){
	$('#operateWin').window({
		title: '库存动销明细',
		iconCls: 'icon-w-list',
		closed: true,
		modal: true,
		width: 950,
		height: $(this).height() * 0.65,
		onOpen: function(){
			$(this).window('center');
		},
		onClose: function(){
			PHA_UX.BusiTimeLine({},{}, "close");
		}
	});
}

/**
 * 清屏、初始化默认值
 */
function Clear(){
	QUE_FORM.ClearFormData();
	$('#gridIncItmLoc').datagrid('clear');	
	InitDefVal();	
}

/**
 * 科室库存项表格
 */
function InitGridIncItmLoc(){
	var columns = [[
		{
			title: "inci",
			field: "inci",
			width: 100,
			hidden: true
		},{
			title: "incil",
			field: "incil",
			width: 100,
			hidden: true
		}, {
			title: "bUomId",
			field: "bUomId",
			width: 100,
			hidden: true
		}, {
			title: "基本单位",
			field: "bUomDesc",
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: "入库单位",
			field: "pUomDesc",
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: "pUomId",
			field: "pUomId",
			width: 100,
			hidden: true
		}, {
			title: "库存(基本)",
			field: "bQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "库存(入库)",
			field: "pQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "库存(单位)",
			field: "qtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "入数量",
			field: "inQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false,
			formatter: function(value, rowData){
				if (!value) { return ""; }
				if ($.isEmptyObject(rowData)){ return ""; }
				return '<a class="pha-grid-a js-grid-inQtyWithUom">' + value + '</a>';	
			}
		}, {
			title: "出数量",
			field: "outQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false,
			formatter: function(value, rowData){
				if (!value) { return ""; }
				if ($.isEmptyObject(rowData)){ return ""; }
				return '<a class="pha-grid-a js-grid-outQtyWithUom">' + value + '</a>';	
			}
		}, {
			title: "入进价金额",
			field: "inRpAmt",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "出进价金额",
			field: "outRpAmt",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "入售价金额",
			field: "inSpAmt",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "出售价金额",
			field: "outSpAmt",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "进价(入库)",
			field: "TPRp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "售价(入库)",
			field: "TPSp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "进价(基本)",
			field: "TBRp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "售价(基本)",
			field: "TBSp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "进价金额",
			field: "TRpAmt",
			width: 100,
			align: 'right',
			hidden: true
		}, {
			title: "售价金额",
			field: "TSpAmt",
			width: 100,
			align: 'right',
			hidden: true
		}, {
			title: "货位",
			field: "stkBin",
			width: 100
		}, {
			title: "剂型",
			field: "phcFormDesc",
			width: 100
		}, {
			title: "商品名",
			field: "goodName",
			width: 130
		}, {
			title: "处方通用名",
			field: "geneName",
			width: 130
		}, {
			title: "不可用",
			field: "notUseFlag",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
		}, {
			title: "贵重药",
			field: "highPrice",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
		}, {
			title: "国家医保编码",
			field: "insuCode",
			width: 100
		}, {
			title: "国家医保名称",
			field: "insuName",
			width: 100
		}
	]];
	var frozenColumns = [[
		{
			title: "药品代码",
			field: "inciCode",
			width: 120,
			formatter: QUE_COM.Grid.Formatter.InciCode()
		}, {
			title: "药品名称",
			field: "inciDesc",
			width: 200
		}, {
			title: "药品规格",
			field: "inciSpec",
			width: 100
		}
	]]
	var dataGridOption = {
		url: "",	
		nowrap: false,
		fitColumns: false,
		border: true,
		headerCls: 'panel-header-gray',
		toolbar: '#gridIncItmLocTool',
		rownumbers: true,
		columns: columns,
		frozenColumns: frozenColumns,
		pagination: true,
		singleSelect: true,
		showFooter: true,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		fixRowNumber: true,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		}
	};
	PHA.Grid('gridIncItmLoc', dataGridOption);
	QUE_COM.ComGridEvent("gridIncItmLoc");

	var eventClassArr = [];
	eventClassArr.push('pha-grid-a js-grid-inQtyWithUom');
	eventClassArr.push('pha-grid-a js-grid-outQtyWithUom');
	
	PHA.GridEvent('gridIncItmLoc', 'click', eventClassArr, function(rowIndex, rowData, className){
		var pJson = GetParams();
		if (className === 'pha-grid-a js-grid-inQtyWithUom'){
			if(rowData.inQtyWithUom == 0){
				return;	
			}
			pJson.intrFlag = "IN";
		} else if (className === 'pha-grid-a js-grid-outQtyWithUom'){
			if(rowData.outQtyWithUom == 0){
				return;	
			}
			pJson.intrFlag = "OUT";
		}
		$('#operateWin').window('setTitle', $g("库存动销明细：")+ $g(rowData.inciDesc));
		$('#operateWin').window('open');
		pJson.incil = rowData.incil;
		GetInOutDetail(pJson);
	});	
}

/**
 * 查询业务数据明细
 * @params {object} pJson 
 * @params {string} pJson.incil 	科室库存项id
 * @params {string} pJson.opType 	查询类别
 */
function GetInOutDetail(pJson){
	if (pJson === null){
		return;	
	}
	$('#gridBuySalesDetail').datagrid('loading');
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'QueryIntrDetail',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
	        $('#gridBuySalesDetail').datagrid('loadData', data);
	    }
	);
}

/**
 * 库存动销明细表格
 */
function InitGridBuySalesDetail(){
	var columns = [[
		{ 
    		field: 'intrId',
    		title: 'intrId',
    		align: 'left',
    		width: 100, 
    		hidden: true 
    	}, { 
    		field: 'bizCode',
    		title: 'bizCode', 		
    		hidden: true
		}, { 
    		field: 'typeDesc',
    		title: '业务类型', 		
    		align: 'left',	
    		width: 130, 
    		hidden: false
		}, { 
			field: 'date', 		
			title: '时间', 			
			align: 'left', 	
			width: 160, 
			hidden: false,
            formatter: function(val, row, index){
	            return val +" "+ row.time;
	        }
		}, { 
			field: 'operator', 	
			title: '操作人', 		
			align: 'left', 	
			width: 120, 
			hidden: false 
		}, { 
			field: 'batNo', 		
			title: '批号', 			
			align: 'left', 
			width: 120
		}, { 
			field: 'qtyWithUom', 		
			title: '数量(单位)', 			
			align: 'right', 
			width: 150 
		}, { 
			field: 'pQty', 		
			title: '数量(入库)', 			
			align: 'right', 
			width: 150,
			hidden: true 
		}, { 
			field: 'pUomDesc', 	
			title: '入库单位', 			
			align: 'left',	
			width: 80,
			hidden: true 
		}, { 
			field: 'bQty', 		
			title: '数量(基本)', 			
			align: 'right', 
			width: 150,
			hidden: true 
		}, { 
			field: 'bUomDesc', 	
			title: '基本单位', 			
			align: 'left',	
			width: 80,
			hidden: true 
		}, { 
			field: 'qty', 		
			title: '数量', 			
			align: 'right', 
			width: 150,
			hidden: true 
		}, { 
			field: 'uomDesc', 	
			title: '单位', 			
			align: 'left',	
			width: 80,
			hidden: true 
		}, { 
			field: 'intrNo', 		
			title: '处理号', 		
			align: 'left', 	
			width: 200,
			formatter: QUE_COM.Grid.Formatter.BizNo()
		}
	]];
	var dataGridOption = {
		url: "",	
		nowrap: false,
		fitColumns: false,
		border: true,
		toolbar: null,
		headerCls: 'panel-header-gray',
		bodyCls: 'panel-body-gray',
		rownumbers: true,
		border: true,
		columns: columns,
		pagination: true,
		singleSelect: true,
		showFooter: true,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		fixRowNumber: true,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		}
	};
	PHA.Grid('gridBuySalesDetail', dataGridOption);
	QUE_COM.ComGridEvent("gridBuySalesDetail");
}