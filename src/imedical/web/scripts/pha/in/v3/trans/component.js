/**
 * 模块:     定义库存转移公共组件
 * 编写日期: 2022-05-10
 * 编写人:   yangsj
 * scripts/pha/in/v3/trans/component.js 
 */
 
 /* Columns 入参说明 
  * _options{
  * 	select   表格列勾选属性。默认不勾选，如果要勾选则传入true，且注意grid定义时的属性 singleSelect: false,
  * 	addAnnex 表格是否添加公共列。默认添加，如果不需要添加请传入 false  (暂时没用,走公共表编辑)
  * }
  */
var INIT_COMPOMENTS = {
		API: 'PHA.IN.TRANS.Api',
		CmbWidth : 160,
		LongCmbWidth : 262,
		BUSICODE: 'TRANS',
		longCmbWidth : 262,
		Select_Col : { 
			field: 'Select', 		
			checkbox: true 
		},
		Columns : {
			Main : {
				Frozen : function (_options){
					var columns = [
						{ field: 'initId', 		title: 'initId', 		hidden: true },
			            { field: 'transNo',		title: '转移单号',		width: 200,		align: 'left', 
			                formatter: function (value, rowData, index) {
                            if (!value) {
	                                return;
	                            }
	                            return '<a class="pha-grid-a js-grid-transNo">' + value + '</a>';
	                        }
			           	}
					]
					if (_options){
						if (_options.select) columns.unshift(INIT_COMPOMENTS.Select_Col)
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
			            //{ field: 'compFlag', 	title: '完成标志', 		width: 70, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter},
			            { field: 'statusDesc', 	title: '单据状态', 		width: 120, 	align: 'left'	},
			            { field: 'newestStatusInfo', 	title: '最新流转信息', 		width: 200, 	align: 'left',	
			            	styler: function (val) {
	                            if (val.indexOf('拒绝') > 0) {
	                                return { class: 'pha-datagrid-status-warn' };
	                            }
	                        }
			            },
			            { field: 'remarks', 	title: '备注', 			width: 120, 	align: 'left'	},
			            { field: 'copyFrom', 	title: '复制于', 		width: 200, 	align: 'left'	},
			            { field: 'mzjyFlag', 	title: '麻醉精一', 		width: 80, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter, hidden: INIT_COM.ParamTrans.OutPoisonDoubleSign == 'Y' ? false : true},
			            { field: 'mzjyAuditStatus', 	title: '麻醉精一审核标志', 		width: 200, 	align: 'left',	hidden: INIT_COM.ParamTrans.OutPoisonDoubleSign == 'Y' ? false : true	}
				    ]
				    return [columns];
				}
			},
			Detail : {
				Frozen : function (_options){
					var columns = [
			            { field: 'initiId', 	title: 'initiId', 		hidden: true 					},
			            { field: 'inci', 		title: 'inci', 			hidden: true 					},
			            { field: 'inciCode',	title: '药品代码',		width: 100,		align: 'left' 	},
			            { field: 'inciDesc',	title: '药品名称',		width: 200,		align: 'left' 	},
			            { field: 'statusCode',	title: 'statusCode',	hidden: true 					},
		            	{ field: 'statusDesc',	title: '明细状态',		width: 100,		align: 'left',	styler:INIT_COMPOMENTS.ItmStatusStyler },
				    ]
				    if (_options){
						if (_options.select ) columns.unshift(INIT_COMPOMENTS.Select_Col)
					}
				    return [columns];
				},
				Normal : function (_options){
					var columns = [
			            { field: 'qty', 		title: '转移数量', 		width: 80, 		align: 'right'	},
						{ field: 'proLocQty', 	title: '供应方库存', 	width: 80, 		align: 'right'	},
			            { field: 'recLocQty', 	title: '请求方库存', 	width: 80, 		align: 'right'	},
			            { field: 'rp', 			title: '进价', 			width: 80, 		align: 'right'	},
			            { field: 'rpAmt', 		title: '进价金额', 		width: 80, 		align: 'right'	},
			            { field: 'sp', 			title: '售价', 			width: 80, 		align: 'right'	},
			            { field: 'spAmt', 		title: '售价金额', 		width: 100, 	align: 'right'	},
			            { field: 'uomId', 		title: 'uomId', 		hidden: true 					},
			            { field: 'uomDesc', 	title: '单位', 			width: 100, 	align: 'right'	},
			            { field: 'remark', 		title: '备注', 			width: 100, 	align: 'left'	},
			            { field: 'batNo', 		title: '批号', 			width: 100, 	align: 'left'	},
			            { field: 'expDate', 	title: '效期', 			width: 100, 	align: 'left'	},
			            { field: 'stkbin', 		title: '货位', 			width: 100, 	align: 'left'	},
			            { field: 'inciSpec', 	title: '规格', 			width: 100, 	align: 'left'	},
			            { field: 'geneName', 	title: '处方通用名', 	width: 100, 	align: 'left'	},
			            { field: 'phcFormDesc', title: '剂型', 			width: 100, 	align: 'left'	},
			            { field: 'manfName', 	title: '生产企业', 		width: 200, 	align: 'left'	},
			            { field: 'insuCode', 	title: '国家医保编码', 	width: 100, 	align: 'left'	},
            			{ field: 'insuName', 	title: '国家医保名称', 	width: 100, 	align: 'left'	}
					];
				    return [columns];
				}
			}
		},
	ItmStatusStyler : function(value, row, index){
		var statusCode = row.statusCode
	     switch (statusCode) {
	         case 'KC':
	             colorStyle = 'background:#f1c516;color:white;';
	             break;
	         case 'K':
	             colorStyle = 'background:#ee4f38;color:white;';
	             break;
	         default:
	         	return ;
	             colorStyle = 'background:white;color:black;';
	             break;
	     }
	     return colorStyle;
	},
	InitGridInitStatus: function(gridId){
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
	/* 转移类型 */
	OpertId : function(domId, select1){
		if(!domId) return;
		select1 = select1 || false;
		PHA.ComboBox(domId, {
	        width: INIT_COMPOMENTS.CmbWidth,
	        url: PHA_IN_STORE.OperateType('O').url,
	        mode: 'remote',
	        onLoadSuccess: function(rows){
		        if (select1){
			        rows.forEach((element) => {
			            if (element.DefaultFlag === 'Y') {
			                $(this).combobox('setValue', element.RowId);
			            }
			        });
		        }
			}
	    });
	},
	/* 流程状态 */
	StatusCode : function(domId, rangeFlag, appointCode, multiple, select1, callback){
		if(!domId || !rangeFlag) return;
		select1 = select1 || false;
		multiple = multiple || false;
		appointCode = appointCode || '',
		PHA.ComboBox(domId, {
	        width: INIT_COMPOMENTS.CmbWidth,
	        multiple: multiple,
	        rowStyle: multiple ? 'checkbox' : '',
	        url: PHA_IN_STORE.BusiProcess(INIT_COMPOMENTS.BUSICODE, rangeFlag, appointCode).url,
	        mode: 'remote',
	        onLoadSuccess: function(data){
		        if(select1){
					if (data && data.length > 0) {
						$(this).combobox('setValue', data[0].RowId);
					}
		        }
			},
			onSelect:function(option){
		        if(callback){
			       var statusCode = option.RowId
			       callback();
		        }
	        }
	    });
	},
	
	FrToLoc : function(frLocId, toLocArr, frCallback, toCallback){
		frLocId = frLocId || '';
		if(!frLocId) return;
		toLocArr = toLocArr || [];
		var toLocArrLen = toLocArr.length;
		if(!toLocArrLen) return;
		frCallback = frCallback || '';
		toCallback = toCallback || '';
		PHA_UX.ComboBox.Loc(frLocId, {width: INIT_COMPOMENTS.CmbWidth});
		for (i=0;i<toLocArrLen;i++){
			var toLocId = toLocArr[i]
			PHA_UX.ComboBox.Loc(toLocId, {
		        width: INIT_COMPOMENTS.CmbWidth,
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
		PHA_UX.ComboBox.Loc(toLocId, {width: INIT_COMPOMENTS.CmbWidth});
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
		    width: INIT_COMPOMENTS.CmbWidth,
		    multiple: 'multiple',
	        rowStyle:'checkbox',
			qParams: {
				LocId: PHA_UX.Get(locId, session['LOGON.CTLOCID']),
				UserId: session['LOGON.USERID']
			}
		});
	},
	StkCat : function(domId, scgIf){
		PHA_UX.ComboBox.StkCat('stkcatId', {
	        width: INIT_COMPOMENTS.CmbWidth,
	        multiple: 'multiple',
	        rowStyle:'checkbox',
	        qParams: {
	            CatGrpId: PHA_UX.Get(scgIf)
	        }
	    });
	},
	
	StatusResult :function(domId, select1,callback){
		if(!domId) return;
		select1 = select1 || false;
		PHA.ComboBox('nextStatusResult', {
	        width: INIT_COMPOMENTS.CmbWidth,
	        url: PHA_IN_STORE.BusiStatusResult().url,
	        mode: 'remote',
	        panelHeight: 'auto',
	        editable: false,
	        onLoadSuccess: function(data){
		        if(select1){
					if (data && data.length > 0) {
						$(this).combobox('setValue', data[0].RowId);
					}
		        }
			},
			onSelect:function(option){
		        if(callback){
			       var statusResultCode = option.RowId
			       callback();
		        }
	        }
	    });
	},
	
	SetDisabled: function(btnArr, combArr){
		var btnArr = btnArr || [];
		var combArr = combArr || [];
		var btnLen = BTNARR.length
		for (i=0;i<btnLen;i++){
			btnId = BTNARR[i]
			if(btnArr.indexOf(btnId) >= 0) $('#' + btnId).linkbutton('disable');
			else $('#' + btnId).linkbutton('enable');
		}
		var combLen = COMBARR.length
		for (i=0;i<combLen;i++){
			combId = COMBARR[i]
			if(combArr.indexOf(combId) >= 0) $('#' + combId).combobox('disable')
			else $('#' + combId).combobox('enable')
		}
	},
	/*消耗业务*/
	BizRange : function(domId, multiple, LongWidthFlag, LongWidth){
		multiple = multiple || false;
		LongWidthFlag = LongWidthFlag || false;
		LongWidth = LongWidth || '';
		var width = INIT_COMPOMENTS.ComWidth;
		if(LongWidth) width = LongWidth;
		else width = LongWidthFlag ? INIT_COMPOMENTS.LongCmbWidth : INIT_COMPOMENTS.CmbWidth
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
	/* 麻醉精一 */
	MZJY : function(domId){
		PHA.ComboBox(domId, {
	        width: INIT_COMPOMENTS.ComWidth,
	        panelHeight: 'auto',
	        data: [
                { RowId: '', Description: '全部' },
                { RowId: 'ONLY', Description: '仅' },
                { RowId: 'NOT', Description: '非' },
            ]
	    });
	},
	Inci:function(domId){
		PHA_UX.ComboGrid.INCItm(domId, {
			width: INIT_COMPOMENTS.ComWidth,
			placeholder: '药品...'
		});
	},
	
	/* 初始化主列表 */
	InitMainGrid:function(gridId, barId, clickCallback, click2Callback){
		var dataGridOption = {
			url: PHA.$URL,
			queryParams: {},
			singleSelect: true,
			pagination: true,
			columns: INIT_COMPOMENTS.Columns.Main.Normal(),
			frozenColumns: INIT_COMPOMENTS.Columns.Main.Frozen(),
			toolbar: barId,
			gridSave: false,
			isCellEdit: false,
			allowEnd: true,
			onClickRow: function (rowIndex, rowData) {clickCallback()},
			onDblClickRow: function (rowIndex, rowData) {click2Callback()},
			onClickCell: function (index, field, value) {      
				if(field == "transNo"){
	                var rowData = $('#' + gridId).datagrid('getData').rows[index];
	                PHA_UX.BusiTimeLine({},{
	                    busiCode: INIT_COMPOMENTS.BUSICODE,
	                    locId: session['LOGON.CTLOCID'],
	                    pointer: rowData.initId
	                });
	            }else{
	                PHA_UX.BusiTimeLine({},{},"close")
	            }
	        }
		};
		PHA.Grid(gridId, dataGridOption);
	},
	/* 初始化明细列表 */
	InitDetailGrid:function(gridId, barId, select){
		barId = barId || '';
		select = select || false;
		var dataGridOption = {
			url: PHA.$URL,
			queryParams: {},
			singleSelect: select ? false : true,
			pagination: false,
			columns: INIT_COMPOMENTS.Columns.Detail.Normal(),
			frozenColumns: INIT_COMPOMENTS.Columns.Detail.Frozen({select:select}),
			gridSave: true,
			isCellEdit: false,
			allowEnd: true,
			toolbar: barId,
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
			$('#' + gridId).datagrid('clearChecked');
		}
		var len = barArr.length;
		for (i=0;i<len;i++){
			var barId = barArr[i];
			PHA.DomData(barId, {doType: 'clear'});
		}
	}
	
}
