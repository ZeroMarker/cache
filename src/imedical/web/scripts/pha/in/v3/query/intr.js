/**
 * 名称:	 台账查询
 * 编写人:	 pushuangcai
 * 编写日期: 2022-04-22
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v3.query.intr.csp';
PHA_COM.App.Name = $g('台账查询');
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
	InitIntrDetailGrid();
	
	InitDefVal();
	InitEvents();
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
			pMethodName: 'StockMoveSum',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
		    $('#gridIntrDetail').datagrid('clear');
	        $('#gridIncItmLoc').datagrid('loadData', data);
	    }
	);
}

/**
 * 查询业务数据明细
 * @params {string} incil 	科室库存项id
 */
function QueryIntrDetail(incil){
	var pJson = GetParams();
	pJson.incil = incil;
	$('#gridIntrDetail').datagrid('loading');
	
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'QueryIntrDetail',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
	        $('#gridIntrDetail').datagrid('loadData', data);
	    }
	);
}

/**
 * 获取界面参数
 */
function GetParams(){
	var formData = QUE_FORM.GetFormData();
	return formData;
}

/**
 * 初始化界面默认值
 */
function InitDefVal(){
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate("t"));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate("t"));
	$('#startTime').timespinner('setValue', PHA_UTIL.SysTime("s"));
	$('#endTime').timespinner('setValue', PHA_UTIL.SysTime("l"));
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
}

/**
 * 绑定事件
 */
function InitEvents(){
	PHA_EVENT.Bind('#btnFind', 'click', Query);
	PHA_EVENT.Bind('#btnClear', 'click', Clear);
	PHA_EVENT.Bind('#consumeFlag', 'click', Query);
	PHA_EVENT.Bind('#aspFlag', 'click', Query);
}

/**
 * 清屏、初始化默认值
 */
function Clear(){
	QUE_FORM.ClearFormData();
	$('#gridIncItmLoc').datagrid('clear');	
	$('#gridIntrDetail').datagrid('clear');	
	InitDefVal();	
}


/**
 * 初始化界面组件
 */
function InitComponent(){	
	PHA.ComboBox('businessType', {
		multiple: true,
		rowStyle: 'checkbox',
		width: 396,
		url: PHA_STORE.BusinessType().url
	});
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
		}, {
			title: "变动数量",
			field: "changeQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "增加数量",
			field: "plusQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "减少数量",
			field: "minusQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "变动数量(基本)",
			field: "changeBQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "增加数量(基本)",
			field: "plusBQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "减少数量(基本)",
			field: "minusBQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "基本单位",
			field: "bUomDesc",
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: "变动数量(入库)",
			field: "changePQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "增加数量(入库)",
			field: "plusPQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "减少数量(入库)",
			field: "minusPQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "入库单位",
			field: "pUomDesc",
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: "期初库存",
			field: "begQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "期末库存",
			field: "endQtyWithUom",
			align: 'right',
			width: 120,
			hidden: false
		}, {
			title: "期初进价金额",
			field: "begRpAmt",
			align: 'right',
			width: 120,
			hidden: false
		}, {
			title: "期末进价金额",
			field: "endRpAmt",
			align: 'right',
			width: 120,
			hidden: false
		}, {
			title: "期初售价金额",
			field: "begSpAmt",
			align: 'right',
			width: 120,
			hidden: false
		}, {
			title: "期末售价金额",
			field: "endSpAmt",
			align: 'right',
			width: 120,
			hidden: false
		}, {
			title: "pUomId",
			field: "pUomId",
			width: 100,
			hidden: true
		}, {
			title: "bUomId",
			field: "bUomId",
			width: 100,
			hidden: true
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
			title: "货位",
			field: "stkBin",
			width: 100
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
		fitColumns: false,
		border: false,
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
            if (data.total > 0){
	           $(this).datagrid('selectRow', 0); 
	        }
		},
		onSelect: function(rowIndex, rowData){
			QueryIntrDetail(rowData.incil);
		}
	};
	PHA.Grid('gridIncItmLoc', dataGridOption);
    QUE_COM.ComGridEvent("gridIncItmLoc");
}

function InitIntrDetailGrid(){
	var columns = [[
    	{ 
    		field: 'intrId',
    		title: 'intrId',
    		align: 'left',
    		width: 100, 
    		hidden: true 
    	}, { 
    		field: 'typeDesc',
    		title: '业务类型', 		
    		align: 'center',	
    		width: 120, 
    		hidden: false,
            styler: function(value, row, index){
	            if (value.indexOf("损益") > 0){
					return 'background-color:#F1C516;color:#fff;';
				} 
	        }
		}, { 
			field: 'date', 		
			title: '时间', 			
			align: 'center', 	
			width: 160, 
			hidden: false,
            formatter: function(val, row, index){
	            return val +" "+ row.time;
	        }
		}, { 
			field: 'operator', 	
			title: '操作人', 		
			align: 'left', 	
			width: 100, 
			hidden: false 
		}, { 
			field: 'batNo', 		
			title: '批号', 			
			align: 'left', 
			width: 100
		}, { 
			field: 'expDate', 	
			title: '效期', 			
			align: 'left', 	
			width: 100, 
			hidden: true
		}, { 
			field: 'qtyWithUom', 		
			title: '数量(单位)', 			
			align: 'right', 
			width: 100,
			formatter: function(value, rowData, index){
				if (rowData.qty > 0){
					value = "+" + value;
				}
				return value;
			},
			styler: function(value, rowData, index){
				var styleStr = "";
				if (rowData.qty > 0){
					styleStr = "color:#5DB42F;"
				} else if (rowData.qty < 0){
					styleStr = "color:#F25757;"	
				}
	            return 'font-weight:bold;' + styleStr;	
	        }
		}, { 
			field: 'endQtyWithUom', 	
			title: '结余数量(单位)', 		
			align: 'right', 
			width: 150 
		}, { 
			field: 'pQty', 		
			title: '数量(入库)', 			
			align: 'right', 
			width: 100,
			hidden: true 
		}, { 
			field: 'endPQty', 	
			title: '结余数量(入库)', 		
			align: 'right', 
			width: 150,
			hidden: true 
		}, { 
			field: 'pUomDesc', 	
			title: '入库单位', 			
			align: 'center',	
			width: 80,
			hidden: false 
		}, { 
			field: 'bQty', 		
			title: '数量(基本)', 			
			align: 'right', 
			width: 100,
			hidden: true 
		}, { 
			field: 'endBQty', 	
			title: '结余数量(基本)', 		
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
			width: 100,
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
			align: 'center', 	
			width: 150,
			formatter: function(value, rowData, index){
				if (!value){
					return value;	
				}
				return '<a class="pha-grid-a js-grid-intrNo" id="intrNo-'+ index +'">' + value + '</a>';
			}
		}, { 
			field: 'TBRp', 			
			title: '进价(基本)', 			
			align: 'right', 
			width: 80,
			hidden: true
		}, { 
			field: 'TBSp', 			
			title: '售价(基本)', 			
			align: 'right', 
			width: 80,
			hidden: true
		}, { 
			field: 'TPRp', 			
			title: '进价(入库)', 			
			align: 'right', 
			width: 80 
		}, { 
			field: 'TPSp', 			
			title: '售价(入库)', 			
			align: 'right', 
			width: 80 
		}, { 
			field: 'rp', 			
			title: '进价', 			
			align: 'right', 
			width: 80,
			hidden: true
		}, { 
			field: 'sp', 			
			title: '售价', 			
			align: 'right', 
			width: 80,
			hidden: true
		}, { 
			field: 'rpAmt', 		
			title: '进价金额', 		
			align: 'right', 
			width: 120 
		}, { 
			field: 'spAmt', 		
			title: '售价金额', 		
			align: 'right', 
			width: 120 
		}, { 
			field: 'type', 		
			title: '业务类型Code', 	
			align: 'center',
			width: 100, 
			hidden: true 
		}, { 
			field: 'endRpAmt', 	
			title: '结余金额(进价)',
			align: 'right', 
			width: 120 
		}, { 
			field: 'endSpAmt', 	
			title: '结余金额(售价)',
			align: 'right', 
			width: 120 
		}, { 
			field: 'manfName', 	
			title: '生产企业',
			align: 'left', 
			width: 120 
		}, { 
			field: 'vendorName', 	
			title: '经营企业',
			align: 'left', 
			width: 120 
		}           
	]];
	
    var dataGridOption = {
        url: "",
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
        fit: true,
		fixRowNumber: true,
		border: false,
		onLoadSuccess: function(){
			$(this).datagrid('loaded');
		}
    };
    PHA.Grid('gridIntrDetail', dataGridOption);
    QUE_COM.ComGridEvent("gridIntrDetail");

    var eventClassArr = [];
	eventClassArr.push('pha-grid-a js-grid-intrNo');
	PHA.GridEvent('gridIntrDetail', 'click', eventClassArr, function(rowIndex, rowData, className){
		if (className === 'pha-grid-a js-grid-intrNo') {
			var pJson = {
                intrId: rowData.intrId
            }
            PHA.CM({
				    pClassName: 'PHA.IN.Query.Api',
					pMethodName: 'IntrNoInfo',
			        pJsonStr: JSON.stringify(pJson)
			    },function(retData){
					if ((retData.items) && ((retData.items.length === 0) && (retData.oeori == ""))){
					    PHA.Popover({ 
				        	showType: 'show', 
				        	msg: '没有找到单据信息！', 
				        	type: 'alert' 
				        });
						return;
					} else if (retData.oeori != ""){
						PHA_UX.OrderView(retData.oeori);
						return;
					}
					var $intrNoWin = $('#js-grid-intrNo');
					if ($intrNoWin.length === 0){
						$intrNoWin = $('<div class="pha-panel-body-content" style="padding-top:0;"></div>').appendTo('body');
					}
				    if (retData.msgArr.length === 0){
						retData.msgArr = ["<div></div>"];
					}
				    var $content = $('<div>' + retData.msgArr.join("") + '</div>').appendTo('body');
				    $hstep = $("<div class='pha-row'></div>").appendTo($content);
				    $hstep.hstep({
				        showNumber: false,
				        stepWidth: 170,
				        currentInd: retData.currentInd,
				        items: retData.items
					});

				    $intrNoWin.window({
					    title: $g('单据信息'),
						content: $content,
						width: (retData.items.length * 175),
						height: ($content.height() + 80),
						iconCls: 'icon-w-paper',
						modal: true,
						collapsible: false,
						minimizable: false,
						maximizable: false,
						onShow: function(e, value){
						}
					}); 
					$intrNoWin.window('open');
			    }
			);
		}
	});
}