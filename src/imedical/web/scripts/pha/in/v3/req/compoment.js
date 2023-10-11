/**
 * 模块:     定义库存请求公共组件的属性
 * 编写日期: 2022-05-10
 * 编写人:   yangsj
 * scripts/pha/in/v3/req/compoment.js
 */
 
 /* 入参说明 
  * _options{
  * 	select   表格列勾选属性。默认不勾选，如果要勾选则传入true，且注意grid定义时的属性 singleSelect: false,
  * 	addAnnex 表格是否添加公共列。默认添加，如果不需要添加请传入 false (暂时没用，走公共表编辑)
  * }
  */
var INRQ_COMPOMENTS = {
	CmbWidth : 160,
	LongCmbWidth: 393,
	API : 'PHA.IN.REQ.Api',
	BUSICODE : 'REQ',
	Select_Col : { 
		field: 'tSelect', 		
		checkbox: true 
	},
	Columns : {
		Main : {
			Frozen : function (_options){
				var columns = [
					{ field: 'inrqId', 		title: 'inrqId', 		hidden: true 					},
		        	{ field: 'reqNo',		title: '请求单号',		width: 200,		align: 'left', 
		           		styler: function(value,row,index){				
		                    return {class:"pha-grid-link" };
		                }
			        }
				]
				if (_options){
					if (_options.select) columns.unshift(INRQ_COMPOMENTS.Select_Col)
				}
			    return [columns];
			},
			Normal : function (_options){
				var columns = [
		            { field: 'recLocDesc', 	title: '请求科室', 		width: 120, 	align: 'left'	},
		            { field: 'proLocDesc', 	title: '供给科室', 		width: 120, 	align: 'left'	},
		            { field: 'creator', 	title: '建单人', 		width: 100, 	align: 'left'	},
		            { field: 'createDate', 	title: '建单日期', 		width: 100, 	align: 'left'	},
		            { field: 'createTime', 	title: '建单时间', 		width: 100, 	align: 'left'	},
		            { field: 'compFlag', 	title: '完成标志', 		width: 70, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter},
		            { field: 'statusDesc', 	title: '单据状态', 		width: 120, 	align: 'left'	},
		            { field: 'remarks', 	title: '备注', 			width: 120, 	align: 'left'	},
		            { field: 'copyFrom', 	title: '复制于', 		width: 200, 	align: 'left'	}
			    ]
			    if (_options){
					if (_options.select) columns.unshift(INRQ_COMPOMENTS.Select_Col)
				}
			    return [columns];
			}
		},
		Detail : {
			Frozen : function (_options){
				var columns = [
					{ field: 'inrqiId', 	title: 'inrqiId', 		hidden: true },
					{ field: 'inciCode',	title: '药品代码',		width: 100,			align: 'left' },
		            { field: 'inciDesc',	title: '药品名称',		width: 200,			align: 'left' },
		            { field: 'refuseFlag', 	title: '拒绝', 			width: 60, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter},
		            { field: 'transFlag', 	title: '已转移', 		width: 60, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter},
		            { field: 'inci', 		title: 'inci', 			hidden: true }
		            
				]
				if (_options){
					if (_options.select) columns.unshift(INRQ_COMPOMENTS.Select_Col)
				}
			    return [columns];	
			},
			Normal : function (_options){
				var columns = [
					{ field: 'qty', 		title: '请求数量', 		width: 80, 		align: 'right'	},
					{ field: 'proLocQty', 	title: '供应方方库存', 	width: 80, 		align: 'right'	},
		            { field: 'recLocQty', 	title: '请求方库存', 	width: 80, 		align: 'right'	},
		            { field: 'rp', 			title: '进价', 			width: 80, 		align: 'right'	},
		            { field: 'rpAmt', 		title: '进价金额', 		width: 80, 		align: 'right'	},
		            { field: 'sp', 			title: '售价', 			width: 80, 		align: 'right'	},
		            { field: 'spAmt', 		title: '售价金额', 		width: 100, 	align: 'right'	},
		            { field: 'uomId', 		title: 'uomId', 		hidden: true 	},
		            { field: 'uomDesc', 	title: '单位', 			width: 100, 	align: 'right'	},
		            { field: 'remark', 		title: '备注', 			width: 100, 	align: 'left'	},
		            { field: 'inciSpec', 	title: '规格', 			width: 100, 	align: 'left'	},
		            { field: 'geneName', 	title: '处方通用名', 	width: 100, 	align: 'left'	},
		            { field: 'phcFormDesc', title: '剂型', 			width: 100, 	align: 'left'	},
		            { field: 'sugQty', 		title: '建议请领数量', 	width: 100, 	align: 'left'	},
		            { field: 'manfName', 	title: '生产企业', 		width: 200, 	align: 'left'	},
		            { field: 'insuCode', 	title: '国家医保编码', 	width: 100, 	align: 'left'	},
            		{ field: 'insuDesc', 	title: '国家医保名称', 	width: 100, 	align: 'left'	}
				]
				if (_options){
					if (_options.select) columns.unshift(INRQ_COMPOMENTS.Select_Col)
				}
			    return [columns];
			}
		}
	},
	InitGridInrqStatus: function(gridId){
		var columns = [
	        [
	            { field: 'codeID', 		title: 'codeID', 	hidden: true },
	        	{ field: 'code', 		title: 'code', 		hidden: true },
	            { field: 'desc', 		title: '流程名称', 	width: 80, 		align: 'left'	},
	            { field: 'userName', 	title: '操作人', 	width: 80, 		align: 'left'	},
				{ field: 'date', 		title: '日期', 		width: 100, 	align: 'left'	},
	            { field: 'time', 		title: '时间', 		width: 100, 	align: 'left'	}
	        ]
	    ];
	    var dataGridOption = {
			url: PHA.$URL,
			queryParams: {},
			singleSelect: true,
			pagination: false,
			columns: columns,
			gridSave: false,
			isCellEdit: false,
			allowEnd: true,
			isAutoShowPanel: true
		};
		PHA.Grid(gridId, dataGridOption);
	},
	
	FrToLoc : function(frLocId, toLocArr, frCallback, toCallback){
		frLocId = frLocId || '';
		if(!frLocId) return;
		toLocArr = toLocArr || [];
		var toLocArrLen = toLocArr.length;
		if(!toLocArrLen) return;
		frCallback = frCallback || '';
		toCallback = toCallback || '';
		PHA_UX.ComboBox.Loc(frLocId, {width: INRQ_COMPOMENTS.CmbWidth});
		for (i=0;i<toLocArrLen;i++){
			var toLocId = toLocArr[i]
			PHA_UX.ComboBox.Loc(toLocId, {
		        width: INRQ_COMPOMENTS.CmbWidth,
		        defValue: '',
		        qParams: {
		            proLocId: PHA_UX.Get(frLocId, session['LOGON.CTLOCID']),  // 加载时动态取值,第二个参数为默认值
		            relType: 'R'
		        },
		        onSelect:function(option){
			        if(toCallback){
				       /* 依据请领科室关系确定转移类型 */
				       var recLocId = option.RowId
				       toCallback(recLocId);
			        }
		        }
		    });
		}
	},
	
	ToFrLoc :  function(toLocId, frLocId, frCallback, toCallback){
		if(!toLocId || !frLocId) return;
		PHA_UX.ComboBox.Loc(toLocId, {width: INRQ_COMPOMENTS.CmbWidth});
	    PHA_UX.ComboBox.Loc(frLocId, {
			qParams: {
				recLocId: PHA_UX.Get(toLocId, session['LOGON.CTLOCID']),  // 加载时动态取值,第二个参数为默认值
				relType: 'TR'
			}
		});
	},
	Scg : function(scgId, locId){
		if(!scgId || !locId) return;
		PHA_UX.ComboBox.StkCatGrp(scgId, {
		    width: INRQ_COMPOMENTS.CmbWidth,
		    multiple: true,
	        rowStyle:'checkbox',
			qParams: {
				LocId: PHA_UX.Get(locId, session['LOGON.CTLOCID']),
				UserId: session['LOGON.USERID']
			}
		});
	},
	StkCat : function(domId, scgIf){
		PHA_UX.ComboBox.StkCat('stkcatId', {
	        width: INRQ_COMPOMENTS.CmbWidth,
	        multiple: true,
	        rowStyle:'checkbox',
	        qParams: {
	            CatGrpId: PHA_UX.Get(scgIf)
	        }
	    });
	},
	ReqTypeId : function(domId, multiple, required){
		multiple = multiple || false;
		required = required || false;
		PHA.ComboBox(domId, {
	        panelHeight: 'auto',
	       	value: 'O',             //默认初始值
	       	required: required,
	       	multiple: multiple,
	        rowStyle: multiple ? 'checkbox' : '',
	        editable: required ? false : true,
	        width: INRQ_COMPOMENTS.CmbWidth,
	        url: PHA_IN_STORE.ReqType().url,
	    });
	},
	ReqStatus : function(domId, rangeFlag, multiple, LongWidthFlag, LongWidth){
		multiple = multiple || false;
		LongWidthFlag = LongWidthFlag || false;
		LongWidth = LongWidth || '';
		var width = INRQ_COMPOMENTS.ComWidth;
		if(LongWidth) width = LongWidth;
		else width = LongWidthFlag ? INRQ_COMPOMENTS.LongCmbWidth : INRQ_COMPOMENTS.CmbWidth
		PHA.ComboBox(domId, {
	        width: width,
	        multiple: multiple,
	        rowStyle: multiple ? 'checkbox' : '',
	        url: PHA_IN_STORE.ReqStauts(rangeFlag).url
	    });
	},
	/*消耗业务*/
	BizRange : function(domId, multiple, LongWidthFlag, LongWidth){
		multiple = multiple || false;
		LongWidthFlag = LongWidthFlag || false;
		LongWidth = LongWidth || '';
		var width = INRQ_COMPOMENTS.ComWidth;
		if(LongWidth) width = LongWidth;
		else width = LongWidthFlag ? INRQ_COMPOMENTS.LongCmbWidth : INRQ_COMPOMENTS.CmbWidth
		PHA.ComboBox(domId, {
	        width: width,
	        multiple: multiple,
	        rowStyle: multiple ? 'checkbox' : '',
	        data: [
                { RowId: 'P,PH', Description: '住院发药' },
                { RowId: 'Y,YH', Description: '住院退药' },
                { RowId: 'F,FH', Description: '门诊发药' },
                { RowId: 'H,HH', Description: '门诊退药' },
                { RowId: 'T,TC', Description: '转移出库' },
                { RowId: 'K,KC', Description: '转移入库' }
            ]
	    });
	},
	/* 初始化主列表 */
	InitMainGrid:function(gridId, barId, clickCallback, click2Callback){
		var dataGridOption = {
			url: PHA.$URL,
			queryParams: {},
			singleSelect: true,
			pagination: true,
			columns: INRQ_COMPOMENTS.Columns.Main.Normal(),
			frozenColumns: INRQ_COMPOMENTS.Columns.Main.Frozen(),
			toolbar: barId,
			gridSave: false,
			isCellEdit: false,
			allowEnd: true,
			onClickRow: function (rowIndex, rowData) {clickCallback(rowData.inrqId)},
			onDblClickRow: function (rowIndex, rowData) {click2Callback(rowData.inrqId)},
			onClickCell: function (index, field, value) {      
				if(field == "reqNo"){
	                var rowData = $('#' + gridId).datagrid('getData').rows[index];
	                PHA_UX.BusiTimeLine({},{
	                    busiCode: INRQ_COMPOMENTS.BUSICODE,
	                    locId: session['LOGON.CTLOCID'],
	                    pointer: rowData.inrqId
	                });
	            }else{
	                PHA_UX.BusiTimeLine({},{},"close")
	            }
	        }
		};
		PHA.Grid(gridId, dataGridOption);
	},
	/* 初始化明细列表 */
	InitDetailGrid:function(gridId){
		var dataGridOption = {
			url: PHA.$URL,
			queryParams: {},
			singleSelect: true,
			pagination: false,
			columns: INRQ_COMPOMENTS.Columns.Detail.Normal(),
			frozenColumns: INRQ_COMPOMENTS.Columns.Detail.Frozen(),
			gridSave: true,
			isCellEdit: false,
			allowEnd: true,
			isAutoShowPanel: true,
			loadFilter:PHA.localFilter,
			showFooter: true,
			onLoadSuccess: function (data) {
				PHA_COM.SumGridFooter('#' + gridId, ['rpAmt', 'spAmt']);
			},
		};
		PHA.Grid(gridId, dataGridOption);
	},
	/* 清除数据 */
	Clear : function(gridArr, barArr){
		gridArr = gridArr || [];
		barArr = barArr || [];
		var len = gridArr.length;
		for (i=0;i<len;i++){
			var gridId = gridArr[i];
			$('#' + gridId).datagrid('loadData', []);
		}
		var len = barArr.length;
		for (i=0;i<len;i++){
			var barId = barArr[i];
			PHA.DomData(barId, {doType: 'clear'});
		}
	}
}