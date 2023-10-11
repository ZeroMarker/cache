/**
 * ģ��:     ������ת�ƹ������
 * ��д����: 2022-05-10
 * ��д��:   yangsj
 * scripts/pha/in/v3/trans/component.js 
 */
 
 /* Columns ���˵�� 
  * _options{
  * 	select   ����й�ѡ���ԡ�Ĭ�ϲ���ѡ�����Ҫ��ѡ����true����ע��grid����ʱ������ singleSelect: false,
  * 	addAnnex ����Ƿ���ӹ����С�Ĭ����ӣ��������Ҫ����봫�� false  (��ʱû��,�߹�����༭)
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
			            { field: 'transNo',		title: 'ת�Ƶ���',		width: 200,		align: 'left', 
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
			            { field: 'recLocDesc', 	title: '�������', 		width: 120, 	align: 'left'	},
			            { field: 'proLocDesc', 	title: '��������', 		width: 120, 	align: 'left'	},
			            { field: 'creator', 	title: '������', 		width: 100, 	align: 'left'	},
			            { field: 'createDate', 	title: '��������', 		width: 100, 	align: 'left'	},
			            { field: 'createTime', 	title: '����ʱ��', 		width: 100, 	align: 'left'	},
			            //{ field: 'compFlag', 	title: '��ɱ�־', 		width: 70, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter},
			            { field: 'statusDesc', 	title: '����״̬', 		width: 120, 	align: 'left'	},
			            { field: 'newestStatusInfo', 	title: '������ת��Ϣ', 		width: 200, 	align: 'left',	
			            	styler: function (val) {
	                            if (val.indexOf('�ܾ�') > 0) {
	                                return { class: 'pha-datagrid-status-warn' };
	                            }
	                        }
			            },
			            { field: 'remarks', 	title: '��ע', 			width: 120, 	align: 'left'	},
			            { field: 'copyFrom', 	title: '������', 		width: 200, 	align: 'left'	},
			            { field: 'mzjyFlag', 	title: '����һ', 		width: 80, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter, hidden: INIT_COM.ParamTrans.OutPoisonDoubleSign == 'Y' ? false : true},
			            { field: 'mzjyAuditStatus', 	title: '����һ��˱�־', 		width: 200, 	align: 'left',	hidden: INIT_COM.ParamTrans.OutPoisonDoubleSign == 'Y' ? false : true	}
				    ]
				    return [columns];
				}
			},
			Detail : {
				Frozen : function (_options){
					var columns = [
			            { field: 'initiId', 	title: 'initiId', 		hidden: true 					},
			            { field: 'inci', 		title: 'inci', 			hidden: true 					},
			            { field: 'inciCode',	title: 'ҩƷ����',		width: 100,		align: 'left' 	},
			            { field: 'inciDesc',	title: 'ҩƷ����',		width: 200,		align: 'left' 	},
			            { field: 'statusCode',	title: 'statusCode',	hidden: true 					},
		            	{ field: 'statusDesc',	title: '��ϸ״̬',		width: 100,		align: 'left',	styler:INIT_COMPOMENTS.ItmStatusStyler },
				    ]
				    if (_options){
						if (_options.select ) columns.unshift(INIT_COMPOMENTS.Select_Col)
					}
				    return [columns];
				},
				Normal : function (_options){
					var columns = [
			            { field: 'qty', 		title: 'ת������', 		width: 80, 		align: 'right'	},
						{ field: 'proLocQty', 	title: '��Ӧ�����', 	width: 80, 		align: 'right'	},
			            { field: 'recLocQty', 	title: '���󷽿��', 	width: 80, 		align: 'right'	},
			            { field: 'rp', 			title: '����', 			width: 80, 		align: 'right'	},
			            { field: 'rpAmt', 		title: '���۽��', 		width: 80, 		align: 'right'	},
			            { field: 'sp', 			title: '�ۼ�', 			width: 80, 		align: 'right'	},
			            { field: 'spAmt', 		title: '�ۼ۽��', 		width: 100, 	align: 'right'	},
			            { field: 'uomId', 		title: 'uomId', 		hidden: true 					},
			            { field: 'uomDesc', 	title: '��λ', 			width: 100, 	align: 'right'	},
			            { field: 'remark', 		title: '��ע', 			width: 100, 	align: 'left'	},
			            { field: 'batNo', 		title: '����', 			width: 100, 	align: 'left'	},
			            { field: 'expDate', 	title: 'Ч��', 			width: 100, 	align: 'left'	},
			            { field: 'stkbin', 		title: '��λ', 			width: 100, 	align: 'left'	},
			            { field: 'inciSpec', 	title: '���', 			width: 100, 	align: 'left'	},
			            { field: 'geneName', 	title: '����ͨ����', 	width: 100, 	align: 'left'	},
			            { field: 'phcFormDesc', title: '����', 			width: 100, 	align: 'left'	},
			            { field: 'manfName', 	title: '������ҵ', 		width: 200, 	align: 'left'	},
			            { field: 'insuCode', 	title: '����ҽ������', 	width: 100, 	align: 'left'	},
            			{ field: 'insuName', 	title: '����ҽ������', 	width: 100, 	align: 'left'	}
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
	            { field: 'desc', 		title: '��������', 	width: 80, 		align: 'left'	},
	            { field: 'userName', 	title: '������', 	width: 80, 		align: 'left'	},
				{ field: 'date', 		title: '����', 		width: 100, 	align: 'left'	},
	            { field: 'time', 		title: 'ʱ��', 		width: 100, 	align: 'left'	}
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
	/* ת������ */
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
	/* ����״̬ */
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
		            proLocId: PHA_UX.Get(frLocId, session['LOGON.CTLOCID']),  // ����ʱ��̬ȡֵ,�ڶ�������ΪĬ��ֵ
		            relType: 'R'
		        },
		        onSelect:function(option){
			        if(toCallback){
				       /* ����������ҹ�ϵȷ��ת������ */
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
				recLocId: PHA_UX.Get(toLocId, session['LOGON.CTLOCID']),  // ����ʱ��̬ȡֵ,�ڶ�������ΪĬ��ֵ
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
	/*����ҵ��*/
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
                { RowId: 'P,PH', Description: 'סԺ��ҩ' },
                { RowId: 'Y,YH', Description: 'סԺ��ҩ' },
                { RowId: 'F,FH', Description: '���﷢ҩ' },
                { RowId: 'H,HH', Description: '������ҩ' },
                { RowId: 'T,TC', Description: 'ת�Ƴ���' },
                { RowId: 'K,KC', Description: 'ת�����' }
            ]
	    });
	},
	/* ����һ */
	MZJY : function(domId){
		PHA.ComboBox(domId, {
	        width: INIT_COMPOMENTS.ComWidth,
	        panelHeight: 'auto',
	        data: [
                { RowId: '', Description: 'ȫ��' },
                { RowId: 'ONLY', Description: '��' },
                { RowId: 'NOT', Description: '��' },
            ]
	    });
	},
	Inci:function(domId){
		PHA_UX.ComboGrid.INCItm(domId, {
			width: INIT_COMPOMENTS.ComWidth,
			placeholder: 'ҩƷ...'
		});
	},
	
	/* ��ʼ�����б� */
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
	/* ��ʼ����ϸ�б� */
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
	/* ������� */
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
