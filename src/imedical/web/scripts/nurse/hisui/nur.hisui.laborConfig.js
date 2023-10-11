/*
 * @Author: ouzilin 
 * @Date: 2022-08-15 18:37:21 
 * @Last Modified by: ouzilin
 * @Last Modified time: 2023-04-14 11:04:22
 */

$.extend($.fn.datagrid.defaults, {
	onBeforeDrag: function(row){},	// return false to deny drag
	onStartDrag: function(row){},
	onStopDrag: function(row){},
	onDragEnter: function(targetRow, sourceRow){},	// return false to deny drop
	onDragOver: function(targetRow, sourceRow){},	// return false to deny drop
	onDragLeave: function(targetRow, sourceRow){},
	onBeforeDrop: function(targetRow, sourceRow, point){},
	onDrop: function(targetRow, sourceRow, point){},	// point:'append','top','bottom'
});
$.extend($.fn.datagrid.methods, {
	enableDnd: function(jq, index){
		return jq.each(function(){
			var target = this;
			var state = $.data(this, 'datagrid');
			state.disabledRows = [];
			var dg = $(this);
			var opts = state.options;
			if (index != undefined){
				var trs = opts.finder.getTr(this, index);
			} else {
				var trs = opts.finder.getTr(this, 0, 'allbody');
			}
			trs.draggable({
				disabled: false,
				revert: true,
				cursor: 'pointer',
				proxy: function(source) {
					var index = $(source).attr('datagrid-row-index');
					var tr1 = opts.finder.getTr(target, index, 'body', 1);
					var tr2 = opts.finder.getTr(target, index, 'body', 2);
					var p = $('<div style="z-index:9999999999999"></div>').appendTo('body');
					tr2.clone().removeAttr('id').removeClass('droppable').appendTo(p);
					tr1.clone().removeAttr('id').removeClass('droppable').find('td').insertBefore(p.find('td:first'));
					$('<td><span class="tree-dnd-icon tree-dnd-no" style="position:static">&nbsp;</span></td>').insertBefore(p.find('td:first'));
					p.find('td').css('vertical-align','middle');
					p.hide();
					return p;
				},
				deltaX: 15,
				deltaY: 15,
				onBeforeDrag:function(e){
					if (opts.onBeforeDrag.call(target, getRow(this)) == false){return false;}
					if ($(e.target).parent().hasClass('datagrid-cell-check')){return false;}
					if (e.which != 1){return false;}
					opts.finder.getTr(target, $(this).attr('datagrid-row-index')).droppable({accept:'no-accept'});
				},
				onStartDrag: function() {
					$(this).draggable('proxy').css({
						left: -10000,
						top: -10000
					});
					var row = getRow(this);
					opts.onStartDrag.call(target, row);
					state.draggingRow = row;
				},
				onDrag: function(e) {
					var x1=e.pageX,y1=e.pageY,x2=e.data.startX,y2=e.data.startY;
					var d = Math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
					if (d>3){	// when drag a little distance, show the proxy object
						$(this).draggable('proxy').show();
						var tr = opts.finder.getTr(target, parseInt($(this).attr('datagrid-row-index')), 'body');
						$.extend(e.data, {
							startX: tr.offset().left,
							startY: tr.offset().top,
							offsetWidth: 0,
							offsetHeight: 0
						});
					}
					this.pageY = e.pageY;
				},
				onStopDrag:function(){
					for(var i=0; i<state.disabledRows.length; i++){
						var index = dg.datagrid('getRowIndex', state.disabledRows[i]);
						if (index >= 0){
							opts.finder.getTr(target, index).droppable('enable');
						}
					}
					state.disabledRows = [];
					var index = dg.datagrid('getRowIndex', state.draggingRow);
					dg.datagrid('enableDnd', index);
					opts.onStopDrag.call(target, state.draggingRow);
				}
			}).droppable({
				accept: 'tr.datagrid-row',
				onDragEnter: function(e, source){
					if (opts.onDragEnter.call(target, getRow(this), getRow(source)) == false){
						allowDrop(source, false);
						var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
						tr.find('td').css('border', '');
						tr.droppable('disable');
						state.disabledRows.push(getRow(this));
					}
				},
				onDragOver: function(e, source) {
					var targetRow = getRow(this);
					if ($.inArray(targetRow, state.disabledRows) >= 0){return;}
					var pageY = source.pageY;
					var top = $(this).offset().top;
					var bottom = top + $(this).outerHeight();
					
					allowDrop(source, true);
					var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
					tr.children('td').css('border','');
					if (pageY > top + (bottom - top) / 2) {
						tr.children('td').css('border-bottom','1px solid red');
					} else {
						tr.children('td').css('border-top','1px solid red');
					}
					
					if (opts.onDragOver.call(target, targetRow, getRow(source)) == false){
						allowDrop(source, false);
						tr.find('td').css('border', '');
						tr.droppable('disable');
						state.disabledRows.push(targetRow);
					}
				},
				onDragLeave: function(e, source) {
					allowDrop(source, false);
					var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
					tr.children('td').css('border','');
					opts.onDragLeave.call(target, getRow(this), getRow(source));
				},
				onDrop: function(e, source) {
					var sourceIndex = parseInt($(source).attr('datagrid-row-index'));
					var destIndex = parseInt($(this).attr('datagrid-row-index'));
					
					var tr = opts.finder.getTr(target, $(this).attr('datagrid-row-index'));
					var td = tr.children('td');
					var point =  parseFloat(td.css('border-top-width')) ? 'top' : 'bottom';
					td.css('border','');
					
					var rows = dg.datagrid('getRows');
					var dRow = rows[destIndex];
					var sRow = rows[sourceIndex];
					if (opts.onBeforeDrop.call(target, dRow, sRow, point) == false){
						return;
					}
					insert();
					opts.onDrop.call(target, dRow, sRow, point);
					
					function insert(){
						var row = $(target).datagrid('getRows')[sourceIndex];
						var index = 0;
						if (point == 'top'){
							index = destIndex;
						} else {
							index = destIndex+1;
						}
						if (index < sourceIndex){
							dg.datagrid('deleteRow', sourceIndex).datagrid('insertRow', {
								index: index,
								row: row
							});
							dg.datagrid('enableDnd', index);
						} else {
							dg.datagrid('insertRow', {
								index: index,
								row: row
							}).datagrid('deleteRow', sourceIndex);
							dg.datagrid('enableDnd', index-1);
						}
					}
				}
			});
			
			function allowDrop(source, allowed){
				var icon = $(source).draggable('proxy').find('span.tree-dnd-icon');
				icon.removeClass('tree-dnd-yes tree-dnd-no').addClass(allowed ? 'tree-dnd-yes' : 'tree-dnd-no');
			}
			function getRow(tr){
				return opts.finder.getRow(target, $(tr));
			}
		});
	}
});

$.extend($.fn.datagrid.methods, {
	getEditingRowIndex: function(jq){
		var rows= $.data(jq[0], "datagrid").panel.find('.datagrid-row-editing');
		var indexs = [];
		rows.each(function(i, row){
			var index = row.sectionRowIndex;
			if (indexs.indexOf(index) == -1)
			{
				indexs.push(index);
			}
		})
		return indexs
	}
})

var GV = {
    _CLASSNAME: "Nur.NIS.Service.Labor.Config",
	FieldType: [],
	FieldAlign: [{
		value:"left",
		desc:"�����"
	},{
		value:"right",
		desc:"�Ҷ���"
	},{
		value:"center",
		desc:"����"
	}],
	FontFamilyList: [{
		value:"����",
		desc:"����"
	},{
		value:"����",
		desc:"����"
	},{
		value:"Microsoft Himalaya",
		desc:"Microsoft Himalaya"
	}],
	FontAlignList: [{
		value:"Center",
		desc:"����"
	},{
		value:"start",
		desc:"�����"
	},{
		value:"end",
		desc:"�Ҷ���"
	}],
	FontWeightList:[{
		value:"bold",
		desc:"�Ӵ�"
	},{
		value:"normal",
		desc:"����"
	}],
	TextBasicData: [],
	OBSItem: [],
	LineTypeList:[{
		value:"Y",
		desc:"ʵ��"
	},{
		value:"N",
		desc:"����"
	}],
	LineWidthList:[{
		value:"Y",
		desc:"��ͨ"
	},{
		value:"N",
		desc:"�Ӵ�"
	}],
	ConditionList:[{
		value:">",
		desc:">"
	},{
		value:">=",
		desc:">="
	}]
}

function HospChange(){
	initLogoConfig({})
	$(".show-img").hide();
	$('#obsItemTable,#charsTable,#textConfigTable,#sheetConfigTable,#curveConfigTable,#curveStartConfigTable').datagrid("rejectChanges")
	initUI();    	
}

$(function() {
	initTextDataSourceWin()
    initUI()
})

function initUI(){
	initBasicData()             //��ȡ��������
    initObsItemTable()          //���̼�¼����
    initCharsTable()            //����ͼ��ӡ�б�����
	//initLogoConfig()
    initTextConfigTable()       //����ͼ�ı�����
    initSheetConfigTable()      //����ͼ�������
    initCurveConfigTable()      //����ͼ��������
    initCurveStartConfigTable() //����ͼ��ʼ��������
    initBorderWin()             //�߿��嵯��
	initWpLineConfig()          //�����ߡ�������
	initFullWombConfig()        //����ȫ��
	initBirthMarkerConfig()     //������
	$('#save').on('click',function(){
		initSaveBtn()          //���水ť
	})
}

/**
 * ��ȡ��������
 */
function initBasicData(){
	
	GV.TextBasicData = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getTextConfigBasicData",
		
	},false)

	GV.OBSItem = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getOBSItemCombox",
		hospID: getHosp()
	},false)

	GV.FieldType = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getOBSItemFieldType"
	},false)

	GV.LaborDataField = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getLaborDataField"
	},false)
}


/**
 * �ı�����-������������ά��
 */
function openTextDataSourceWin()
{
	$('#textDataSourceWin').window('open')
	$('#textDataSourceTable').datagrid('reload')
}

/**
 * ��ʼ�� �ı�����-������������ά������
 */
function initTextDataSourceWin(){

	
	$('#textDataSourceWin').window({
		top:"70px",
		width:900,  
		height:600,
		modal: true,
		closed: true,
		collapsible: false,
		minimizable: false,
		maximizable: false,
		closable: true,
		title: '�ı�����-������������ά��',
		iconCls:'icon-w-config'
	})


	$("#textDataSourceTable").datagrid({
		url: $URL,
		columns :[[
				{field:'id',hidden:true},
				{field:'code',title:'���ݱ���', width:100,editor:{type:'text'}},
				{field:'name',title:'����', width:100,editor:{type:'text'}},
				{field:'note',title:'��ע', width:100,editor:{type:'text'}},
				{field:'expression',title:'���ʽ', width:450,editor:{type:'text'}},
				{field: 'handler', title: '����', width: 100, align:"center", formatter:function(value, row, index){
					return  "<span style='cursor:pointer' onclick='textDataSourceHandler.delete(\""+ row.id +"\")' class='icon icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</span>"
					}
				}
			]
		],
		nowrap: false,
		singleSelect : true,
		autoSizeColumn:false,
		loadMsg : '������..',
		onBeforeLoad: function(param) {
			param.ClassName = GV._CLASSNAME,
            param.MethodName = "getTextDataSource"
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('����'),
			handler: function(){
				$('#textDataSourceTable').datagrid("acceptChanges");
				$('#textDataSourceTable').datagrid("unselectAll");
				$('#textDataSourceTable').datagrid('appendRow',{});
                var rows= $('#textDataSourceTable').datagrid('getRows');
                $('#textDataSourceTable').datagrid('beginEdit',rows.length-1);
				$('#textDataSourceTable').datagrid('selectRow',rows.length-1);
			}
		},{
			iconCls: 'icon-save',
			text:$g('����'),
			handler: function(){
				textDataSourceHandler.save()
			}
		}],
		onDblClickRow: function(rowIndex, rowData){
            $('#textDataSourceTable').datagrid("acceptChanges");
            $('#textDataSourceTable').datagrid("unselectAll");
            $('#textDataSourceTable').datagrid("beginEdit", rowIndex);
            $('#textDataSourceTable').datagrid("selectRow",rowIndex);
        }

	})
}

var textDataSourceHandler = {
	delete : function(id){
		if ("undefined" == id && id == "" ) return
		$.messager.confirm('��ʾ','�Ƿ�ɾ��?',function(r){
			if (r)
			{
				$cm({
					ClassName: GV._CLASSNAME,
					MethodName: "deleteTextDataSource",
					id: id
				},function(result){
					if (result==0){
						$.messager.popover({ msg: "����ɹ���", type:'success' });	
						$('#textDataSourceTable').datagrid('reload')
					}else{
						$.messager.popover({ msg: result, type:'error' });	
					}		
				})
			}
		})
	},
	save: function(){
		var indexs = $('#textDataSourceTable').datagrid('getEditingRowIndex');
		if (indexs.length != 0)
		{
			$('#textDataSourceTable').datagrid('endEdit',indexs[0])
		}
		var rows = $('#textDataSourceTable').datagrid('getRows');
		$.m({	
			ClassName:GV._CLASSNAME,
			MethodName:"saveTextDataSource",
			saveDataJson:JSON.stringify(rows)
		},function(result){
			if(result==0){
				$.messager.popover({ msg: "����ɹ���", type:'success' });	
				$('#textDataSourceTable').datagrid('reload')
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}		
		})
	}
}

/**
 * ����¼������
 */
function initObsItemTable(){
    $("#obsItemTable").datagrid({
        url: $URL,
		fit: true,
		fitColumns: false,
		columns :[[
				{field:'id',hidden:true},
				{field:'code',title:'��ѡ��', width:150,
				formatter: setFormatter(GV.LaborDataField),
				editor:{
					type:'combobox',
					options:{
						valueField:'value',
						textField:'desc',
						data: GV.LaborDataField,
						required : true,
						onSelect: function(newValue, oldValue){
							var indexs = $('#obsItemTable').datagrid('getEditingRowIndex');
							var editor=$("#obsItemTable").datagrid("getEditor",{index:indexs[0],field:'description'})
							$(editor.target).val(newValue.desc)
						}
					}
				}
				},	
				{field:'description',title:'����',width:200,editor:{type:'text'}},
				{field:'startRange',title:'��ʼ��Χ', width:100,editor:{type:'numberbox',options:{min:0}}},
				{field:'endRange',title:'������Χ', width:100,editor:{type:'numberbox',options:{min:0}}},
				{field:'fieldType',title:'����', width:100,
					formatter: setFormatter(GV.FieldType ),
					editor:setEditor(GV.FieldType),
				},
				{field:'fieldWidth',title:'�п�', width:100,editor:{type:'numberbox',options:{min:0}}},
				{field:'fieldAlign',title:'λ��', width:100,
					formatter: setFormatter(GV.FieldAlign),
					editor:setEditor(GV.FieldAlign),  
				},
				{field:'options',title:'ѡ��', width:300,editor:{type:'textarea'}},
				{field:'ifMultShow',title:'��̥ʱ��ʾ', width:90,align:'center',
            		formatter: function(value,row){
                		return value=="Y" ? "��":""
            		},	
            		editor:{type:'checkbox',options:{on:'Y',off:''}}
            	},
                {field: 'handler', title: '����', width: 100, align:"center", formatter:function(value, row, index){
                    return  "<a onclick='deleteObsItem(\""+ row.id +"\")' class='icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</a>"
                    }
                }
			]
		],
        nowrap: false,
		rownumbers:true,
		singleSelect : true,
		autoSizeColumn:false,
		pagination:false,
		loadMsg : '������..',
		onBeforeLoad: function(param) {
            param.ClassName = GV._CLASSNAME,
            param.MethodName = "getObsItem",
            param.hospID = getHosp()
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('����'),
			handler: function(){
                $('#obsItemTable').datagrid("rejectChanges");
				$('#obsItemTable').datagrid("unselectAll");
				$('#obsItemTable').datagrid('appendRow',{});
                var rows= $('#obsItemTable').datagrid('getRows');
                $('#obsItemTable').datagrid('beginEdit',rows.length-1);
				$('#obsItemTable').datagrid('selectRow',rows.length-1);
			}
		},{
			iconCls: 'icon-save',
			text:$g('����'),
			handler: function(){
                var indexs = $('#obsItemTable').datagrid('getEditingRowIndex');
				if (indexs.length == 0)
				{
					$.messager.popover({ msg: "���������ڱ༭����!", type:'error' });	
					return
				}
				$('#obsItemTable').datagrid('endEdit',indexs[0])
				var row = $('#obsItemTable').datagrid('getSelected',indexs[0])
				$.m({	
					ClassName:GV._CLASSNAME,
					MethodName:"saveObsItem",
					saveDataJson:JSON.stringify([row]),
					hospID:getHosp(),
				},function testget(result){
					if(result==0){
						$.messager.popover({ msg: "����ɹ���", type:'success' });	
						$('#obsItemTable').datagrid('reload')
					}else{
						$.messager.popover({ msg: result, type:'error' });	
					}		
				})
			}
		}],
		onDblClickRow: function(rowIndex, rowData){
            $('#obsItemTable').datagrid("rejectChanges");
            $('#obsItemTable').datagrid("unselectAll");
            $('#obsItemTable').datagrid("beginEdit", rowIndex);
            $('#obsItemTable').datagrid("selectRow",rowIndex);
			var opts = $(this).datagrid("options");
			var trs = opts.finder.getTr(this, rowIndex);
			trs.draggable( 'disable')  //����ȥ����ק������༭���ı�����ѡ�е�����
        },
        onLoadSuccess:function(){
            //�����϶���
			$(this).datagrid('enableDnd');
		},
        onDrop:function(targetRow,sourceRow,point){
			$cm({
				ClassName:GV._CLASSNAME,
				MethodName: "changeObsItemSequence",
				rows: JSON.stringify($('#obsItemTable').datagrid("getRows")),
				hospID:getHosp()
			}, function(rtn){
                if (rtn == 0)
                {
				    $.messager.popover({ msg: "����ɹ���", type:'success' });
				    $('#obsItemTable').datagrid("reload");
                }else{
                    $.messager.popover({ msg: "����ʧ�ܣ�", type:'error' });
                }
			})
		}

	})	
}

/**
 * 
 * @param {*} id ���̼�¼��id 
 */
function deleteObsItem(id){
    if ("undefined" == id && id == "" ) return
	$.messager.confirm('��ʾ','�Ƿ�ɾ��?',function(r){
		if (r)
		{
			$cm({
				ClassName: GV._CLASSNAME,
				MethodName: "deleteObsItem",
				id: id
			},function(result){
				if (result==0){
					$.messager.popover({ msg: "����ɹ���", type:'success' });	
					$('#obsItemTable').datagrid('reload')
				}else{
					$.messager.popover({ msg: result, type:'error' });	
				}		
			})
		}
	})
}

/**
 * ����ͼ�б�����
 */
function initCharsTable(){
    $("#charsTable").datagrid({
	    fit:true,
        url: $URL,
		columns :[[
				{field:'id',hidden:true},
				{field:'isActive',title:'�Ƿ�����',width:70,align:'center',formatter:function(value,row,index){
                    return value=="Y" ? "<font color='green'>����</font>" : "<font color='red'>ͣ��</font>";	
                },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
				{field:'name',title:'����',width:120,editor:{type:'text'}},
				{field:'ifHorizontalPrint',title:'����ӡ',width:70,align:'center',formatter:function(value,row,index){
                    return value=="Y" ? "��" : "��";	
                },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
			]
		],
		singleSelect : true,
		autoSizeColumn:false,
		pagination:false,
		loadMsg : '������..',
		onBeforeLoad: function(param) {
            param.ClassName = GV._CLASSNAME,
            param.MethodName = "getCharsTable",
            param.hospID = getHosp()
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('����'),
			handler: function(){
                $('#charsTable').datagrid("rejectChanges");
				$('#charsTable').datagrid("unselectAll");
				$('#charsTable').datagrid('appendRow',{});
                var rows= $('#charsTable').datagrid('getRows');
                $('#charsTable').datagrid('beginEdit',rows.length-1);
				$('#charsTable').datagrid('selectRow',rows.length-1);
			}
		},{
			iconCls: 'icon-save',
			text:$g('����'),
			handler: function(){
                var indexs = $('#charsTable').datagrid('getEditingRowIndex');
				if (indexs.length == 0)
				{
					$.messager.popover({ msg: "���������ڱ༭����!", type:'error' });	
					return
				}
				$('#charsTable').datagrid('endEdit',indexs[0])
				var row = $('#charsTable').datagrid('getSelected',indexs[0])
				$.cm({	
					ClassName:GV._CLASSNAME,
					MethodName:"saveCharsTable",
					saveDataJson:JSON.stringify([row]),
					hospID:getHosp(),
				},function testget(result){
					if(result==0){
						$.messager.popover({ msg: "����ɹ���", type:'success' });	
						$('#charsTable').datagrid('reload')
					}else{
						$.messager.popover({ msg: result, type:'error' });	
					}		
				})
			}
		},{
			iconCls: 'icon-copy',
			text:$g('����'),
			handler: function(){
				$('#configCopyTable').datagrid('reload')
				$('#configCopyWin').window('open')
			}
		},{
			iconCls: 'icon-cancel',
			text:$g('ɾ��'),
			handler: function(){
				var selectedRow = $('#charsTable').datagrid('getSelected')
				if (!selectedRow){
					$.messager.popover({ msg: "��ѡ��һ����¼��", type:'success' });
					return
				}
				$.messager.confirm('��ʾ','�Ƿ�ɾ��?',function(r){
					if (r)
					{
						$cm({
							ClassName: GV._CLASSNAME,
							MethodName: "deleteConfigTable",
							id: selectedRow.id
						},function(result){
							if(result==0){
								$.messager.popover({ msg: "ɾ���ɹ���", type:'success' });	
								$('#charsTable').datagrid('reload')
							}else{
								$.messager.popover({ msg: result, type:'error' });	
							}	
						})
					}
				})
			}
		}],
		onDblClickRow: function(rowIndex, rowData){
            $('#charsTable').datagrid("rejectChanges");
            $('#charsTable').datagrid("unselectAll");
            $('#charsTable').datagrid("beginEdit", rowIndex);
            $('#charsTable').datagrid("selectRow",rowIndex);
        },
        onClickRow: function(rowIndex, rowData){
            getLaborConfigInfo()
        }
	})	

	//��Ժ�����Ƶ���
	$('#configCopyWin').window({
		top:"70px",
		width:900,  
		height:400,
		modal: true,
		closed: true,
		collapsible: false,
		minimizable: false,
		maximizable: false,
		closable: true,
		title: '����',
		iconCls:'icon-w-config'
	})

	$("#configCopyTable").datagrid({
		url: $URL,
		columns :[[
				{field:'id',hidden:true},
				{field:'hospDesc',title:'ҽԺ����', width:250},
				{field:'name',title:'����', width:200},
				{field:'ifHorizontalPrint',title:'�Ƿ�����ӡ', align:"center",width:150},
				{field:'isActive',title:'�Ƿ�����', align:"center",width:150},
			]
		],
		nowrap: false,
		singleSelect : true,
		autoSizeColumn:false,
		pagination:false,
		loadMsg : '������..',
		onBeforeLoad: function(param) {
			param.ClassName = GV._CLASSNAME,
            param.MethodName = "getAllConfigTable"
        }
	})

	$('#closeConfigCopyWinBtn').on('click',function(){
		$('#configCopyWin').window('close')
	})
	
}

var charsTableHandler = {
	copy: function(){
		var selectedRow = $('#configCopyTable').datagrid('getSelected')
		if (!selectedRow){
			$.messager.popover({ msg: "��ѡ��һ����¼��", type:'success' });
			return
		}
		debugger
		$cm({
			ClassName: GV._CLASSNAME,
			MethodName: "copyConfigTable",
			copyId: selectedRow.id,
			hospID: getHosp()
		},function(result){
			if(result==0){
				$.messager.popover({ msg: "����ɹ�", type:'success' });
				$('#configCopyWin').window('close')
				$('#charsTable').datagrid('reload')
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}	
		})
	}
}

/**
 * ͼƬ����
 */
function initLogoConfig(data){
	$(".td-img").html('<input id="img" class="hisui-filebox" name="file" value="'+data.ImgName+'" style="width:274px;" />');
		$HUI.filebox("#img",{
			plain:true,
			prompt:data.ImgName,
			onChange:function(){
				chooseImg();	
			}
		});
		$("#img").next().find("input.filebox-text").val(data.ImgName);
		$(".bg-layer").hide();
		$(".show-img img").attr("src",data.ImgSrc);
		if (!!data.ImgSrc)
		{
			$(".show-img").show();
		}
		$("#width").numberbox("setValue",data.ImgWidth);
		$("#height").numberbox("setValue",data.ImgHeight);
		$("#xAxis").numberbox("setValue",data.ImgXAxis);
		$("#yAxis").numberbox("setValue",data.ImgYAxis);
}

/**
 * ����ͼ �ı�����
 */
function initTextConfigTable(){

    createEditGrid('textConfigTable', [
        {field:'id',hidden:true},
        {field:'description',title:'����', width:100,editor:{type:'text'}},
        {field:'printX',title:'����X',width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'printY',title:'����Y', width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'text',title:'�ı�', width:100, align:"center", editor:{type:'text'}},
        {field:'textWidth',title:'���(mm)', width:80, align:"center", editor:{type:'numberbox',options:{min:0}}},
        {field:'textFontFamily',title:'����', width:80,align:'center',
            formatter: setFormatter(GV.FontFamilyList),
            editor:setEditor(GV.FontFamilyList),
        },
        {field:'textFontSize',title:'�ֺ�', width:80, align:'center',editor:{type:'numberbox',options:{min:0}}},
		{field:'textFontColor',title:'�ֺ���ɫ', width:90, editor:{type:'combobox'},styler: function(value, row, index){				
            return 'background-color:' + value;
        }},
        {field:'textFontAlign',title:'���뷽ʽ', width:90,align:'center',
            formatter: setFormatter(GV.FontAlignList),
            editor:setEditor(GV.FontAlignList),
        },
        {field:'textFontWeight',title:'�Ӵ�����', width:90,align:'center',
            formatter: setFormatter(GV.FontWeightList),
            editor:setEditor(GV.FontWeightList),
        },
        {field:'item',title:'������������',width:110,align:'center',
            formatter: setFormatter(GV.TextBasicData),
            editor:setEditor(GV.TextBasicData),
        },
		{field:'loopTimes',title:'ѭ������', width:80, align:'center',editor:{type:'numberbox',options:{min:1}}},
        {field:'itemWidth',title:'Ԫ�ؿ��(mm)',width:110,align:'center',editor:{type:'numberbox',options:{min:0}}},
        {field:'itemFontFamily',title:'Ԫ������',width:80,align:'center',
            formatter: setFormatter(GV.FontFamilyList),
            editor:setEditor(GV.FontFamilyList),
        },
        {field:'itemFontSize',title:'Ԫ���ֺ�',width:80,align:'center',editor:{type:'numberbox',options:{min:0}}},
		{field:'itemFontColor',title:'Ԫ����ɫ', width:90, editor:{type:'combobox'},styler: function(value, row, index){				
            return 'background-color:' + value;
        }},
        {field:'itemFontAlign',title:'Ԫ�ض��뷽ʽ',width:100,align:'center',
            formatter: setFormatter(GV.FontAlignList),
            editor:setEditor(GV.FontAlignList),
        },
        {field:'itemFontWeight',title:'Ԫ�ؼӴ�����',width:100,align:'center',
            formatter: setFormatter(GV.FontWeightList),
            editor:setEditor(GV.FontWeightList),
        },
        {field:'itemUnderline',title:'�Ƿ���»���',width:110,align:'center',
            formatter: function(value,row){
                return value=="Y" ? "��":""
            },	
            editor:{type:'checkbox',options:{on:'Y',off:''}}},
    ], function(rowIndex){
        var ed = $('#textConfigTable').datagrid('getEditor', {index:rowIndex, field:'textFontColor'});
        $(ed.target).color({
            editable:true,
            width:90,
            height:30
        });	
		var ed = $('#textConfigTable').datagrid('getEditor', {index:rowIndex, field:'itemFontColor'});
        $(ed.target).color({
            editable:true,
            width:90,
            height:30
        });
    },
    function(rowIndex,rowData){
		var ed = $('#textConfigTable').datagrid('getEditor', {index:rowIndex, field:'textFontColor'});
        $(ed.target).color({
            editable:true,
            width:90,
            height:30
        });	
		if (rowData.textFontColor != "")
		{
			$(ed.target).color("setValue",rowData.textFontColor)
		}
		var ed = $('#textConfigTable').datagrid('getEditor', {index:rowIndex, field:'itemFontColor'});
        $(ed.target).color({
            editable:true,
            width:90,
            height:30
        });
		if (rowData.itemFontColor != "")
		{
			$(ed.target).color("setValue",rowData.itemFontColor)
		}
    })
}

/**
 * ����ͼ������� //�߼����ӣ������
 */
function initSheetConfigTable(){
    createEditGrid('sheetConfigTable', [
        {field:'id',hidden:true},
        {field:'positionDesc',title:'λ��˵��',width:200,editor:{type:'text'}},
        {field:'xAxis',title:'����X(mm)',width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'yAxis',title:'����Y(mm)',width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'height',title:'���߶�(mm)',width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'width',title:'�����(mm)',width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'showWin',title:'�߿���',width:110, align:'center', formatter:function(){
            return '<img src="../images/uiimages/split_cells.png" style="cursor: pointer;">'
        } },
		{field:'border',hidden:true},
        {field:'cols',title:'�����',width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'rows',title:'�����',width:110,editor:{type:'numberbox',options:{min:0}}},

    ])

    $('#sheetConfigTable').datagrid('options').onClickCell = function(rowIndex, field, value){
        if (field == 'showWin'){
			var rows = $('#sheetConfigTable').datagrid('getRows')
			var border = rows[rowIndex].border
			if (!!border)
			{
				$.each(border,function(index,single){
					var linkObj = $("."+$("#"+index).attr('link'))
					if (single.flag == "Y")
					{
						$("#"+index).css('background-position-y', '-46px')
						linkObj.addClass('active')
						if (single.linetype == 'bold'){
							linkObj.addClass('boldActive')
						}
						linkObj.css('border-color', single.color)
					}else{
						$("#"+index).css('background-position-y',  '0px')
						linkObj.removeClass('active')
						linkObj.removeClass('boldActive')
						linkObj.css('border-color', '')
					}
					
				})
			}else{
				$('.main-right a').each(function(index,single){
					$(single).css('background-position-y',  '0px')
					var linkObj = $("."+$(single).attr('link'))
					linkObj.removeClass('active')
					linkObj.removeClass('boldActive')
					linkObj.css('border-color', '')
				})
			}
			$('#selectSheetId').val(rowIndex)
            $('#borderWin').window('open')
        }
    }
}

/**
 * ����ͼ��������
 */
function initCurveConfigTable(){

	/**
	 *
	var rowEditors=$('#'+obj).datagrid('getEditors',curEditIndex);	
	rowid=$(rowEditors[0].target).val();
	field1=$.trim($(rowEditors[1].target).val());
	index3=$.trim($(rowEditors[2].target).val());
	if(obj=="dg") field3=$(rowEditors[3].target).radio("getValue") ? "Y" : "";	
	if(obj=="dg2" || obj=="dg3") field3=$(rowEditors[3].target).numberbox("getValue");
	if(obj=="dg4") field3=$(rowEditors[3].target).color("getValue");
	field4=$(rowEditors[4].target).radio("getValue") ? "Y" : "";
	field2=$.trim($(rowEditors[5].target).numberbox("getValue"));
	 * 
	 */
    createEditGrid('curveConfigTable', [
        {field:'rowKey',hidden:true},
        {field:'itemDr',title:'�������̼�¼', width:100,
            formatter: setFormatter(GV.OBSItem),
            editor:setEditor(GV.OBSItem),
        },
        {field:'xAxis',title:'����X',width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'yAxis',title:'����Y', width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'cHeight',title:'��С����߶�', width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'cWidth',title:'��С������', width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'minScaleValue',title:'��С�̶�ֵ', width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'maxValue',title:'���ֵ', width:110,editor:{type:'numberbox'}},
        {field:'minValue',title:'��Сֵ', width:110,editor:{type:'numberbox'}},
		{field:'offsetValue',title:'ƫ����', width:110,editor:{type:'numberbox'}},
		{field:'ifOrderDesc',title:'����',width:60,align:'center',
		editor:{type:'checkbox',options:{on:'Y',off:''}}},
		{field:'ifLinkMarker',title:'���ӷ�����',width:110,align:'center',
		editor:{type:'checkbox',options:{on:'Y',off:''}}},
        {field:'color',title:'��ɫ', width:90, editor:{type:'combobox'},styler: function(value, row, index){				
            return 'background-color:' + value;
        }},
        {field:'icon',title:'ͼ��', width:100, editor:{type:'text'}},
        {field:'iconSize',title:'ͼ���С', width:110,editor:{type:'numberbox',options:{min:0}}},
        {field:'iconFontStyle',title:'ͼ��������ʽ', width:80,align:'center',
            formatter: setFormatter(GV.FontWeightList),
            editor:setEditor(GV.FontWeightList),
        },
        {field:'lineWidth',title:'�߿�', width:110,align:'center',
			formatter: setFormatter(GV.LineWidthList),
			editor:setEditor(GV.LineWidthList),},
        {field:'lineType',title:'������', width:80,align:'center',
            formatter: setFormatter(GV.LineTypeList),
            editor:setEditor(GV.LineTypeList),
        },        
        {field:'ifLinkStart',title:'�Ƿ�������ʼֵ',width:110,align:'center',	
            editor:{type:'checkbox',options:{on:'Y',off:''}}},
        {field:'ifSupportMult',title:'��̥ʱ��ʾ',width:110,align:'center',	
            editor:{type:'checkbox',options:{on:'Y',off:''}}
        },
    ],
    function(rowIndex){
        var ed = $('#curveConfigTable').datagrid('getEditor', {index:rowIndex, field:'color'});
        $(ed.target).color({
            editable:true,
            width:90,
            height:30
        });	
    },
    function(rowIndex,rowData){
        var ed = $('#curveConfigTable').datagrid('getEditor', {index:rowIndex, field:'color'});
        $(ed.target).color({
            editable:true,
            width:90,
            height:30
        });	
		if (rowData.color !="" )
		{
			$(ed.target).color("setValue",rowData.color)
		}
    })
}

/**
 * ����ͼ��ʼ��������
 */
function initCurveStartConfigTable(){

    createEditGrid('curveStartConfigTable', [
        {field:'rowKey',hidden:true},
        {field:'itemDr',title:'�������̼�¼', width:100,
            formatter: setFormatter(GV.OBSItem),
            editor:setEditor(GV.OBSItem),
        },
        {field:'condition',title:'����',width:110,
            formatter: setFormatter(GV.ConditionList),
            editor:setEditor(GV.ConditionList),
        },
        {field:'value',title:'��ֵ', width:110,editor:{type:'numberbox',options:{min:0}}},
    ])
}

/**
 * �߿��嵯��
 */
function initBorderWin(){
    $('#borderWin').window({
	    height: 320,
        width: 440,
        modal: true,
        closed: true,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        title: '�߿���',
        iconCls:'icon-batch-cfg'
    })
    $("#selColorInput").color({
        width:90,
        height:30
    });	
    $("#lineStyle li").on('click',function(){
        $("#lineStyle li.active").removeClass('active')
        $(this).addClass('active')
    })
    
	$('.main-right a').each(function(index,single){
		$(single).on('click', function(){
			$(this).css('background-position-y',  $(this).css('background-position-y')=='0px' ? '-46px' : '0px')
			var link = $('.main-right .text .' + $(this).attr('link'))
			if ($(this).css('background-position-y')=='0px')
			{
				link.removeClass('active')
				link.removeClass('boldActive')
				link.css('border-color', '')
			}else{
				link.addClass('active')
				if ($("#lineStyle li.active").attr('value') == '1')
				{
					link.addClass('boldActive')	
				}
				link.css('border-color', $("#selColorInput").color('getValue'))
			}
		})
	})
	
	$("#borderWinCancel").on('click',function(){
		$('#borderWin').window('close')
	})
	
	$("#borderWinSave").on('click',function(){
		var border = {}
		var obj = $(".border-left")
		border.left = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}
		var obj = $(".border-right")
		border.right = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}
		var obj = $(".border-top")
		border.top = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}
		var obj = $(".border-bottom")
		border.bottom = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}
		var obj = $(".left-diagonal")
		border.leftDiagonal = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}
		var obj = $(".right-diagonal")
		border.rightDiagonal = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}
		var obj = $(".horizontal")
		border.horizontal = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}
		var obj = $(".vertical")
		border.vertical = {
			color: obj.hasClass('active') ? colorRGBtoHex(obj.css('border-color')) : '',
			linetype: obj.hasClass('active') ?  (obj.hasClass('boldActive') ? 'bold' : '') : '',
			flag: obj.hasClass('active') ? "Y":"N"	
		}

		$('#sheetConfigTable').datagrid('getRows')[ parseInt($('#selectSheetId').val())].border = border

		$('#borderWin').window('close')
			
	})
	
	

    //$('#borderWin').window('open')
}

/**
 * ��ͷͼƬ����
 */
function initImgSet()
{

}


/**��ȡ����ͼ��ӡ���� */
function getLaborConfigInfo(){
    var row = $('#charsTable').datagrid("getSelected");
    if (row == null){
        $.messager.popover({ msg: "��ѡ���ӡ�б�!", type:'error' });
        return
    }
    $cm({
        ClassName: GV._CLASSNAME,
        MethodName:"getLaborConfigInfo",
        id:row.id
    },function(data){
        if (data.code == 0){
			assignPage(data.data)
        }else{
            $.messager.popover({ msg: data.error, type:'error' });
            return
        }
    })

}

/**
 * ���水ť���
 */
function initSaveBtn(){

	var row = $('#charsTable').datagrid("getSelected");
    if (row == null){
        $.messager.popover({ msg: "��ѡ���ӡ�б�!", type:'error' });
        return
    }
	//logo����
	var ImgName=$("#img").filebox("files").length>0 ? $("#img").next().find('input[type=file]')[0].files[0].name : $("#img").next().find('input.filebox-text').val();
	var ImgSrc=$(".show-img img").attr("src");
	var ImgWidth=$.trim($("#width").numberbox("getValue"));
	var ImgHeight=$.trim($("#height").numberbox("getValue"));
	var ImgXAxis=$.trim($("#xAxis").numberbox("getValue"));
	var ImgYAxis=$.trim($("#yAxis").numberbox("getValue"));
	var contentConfig = {
		ImgName:ImgName,
		ImgSrc:ImgSrc,
		ImgWidth:ImgWidth,
		ImgHeight:ImgHeight,
		ImgXAxis:ImgXAxis,
		ImgYAxis:ImgYAxis
	}
	//�ı�����
	$('#textConfigTable').datagrid("acceptChanges");
	var indexs = $('#textConfigTable').datagrid('getEditingRowIndex');
	if (indexs.length > 0)
	{
		$('#textConfigTable').datagrid('endEdit',indexs[0]);
	}
	var texts = $('#textConfigTable').datagrid('getRows')
	var textConfig = { texts: texts}

	//�������
	var indexs = $('#sheetConfigTable').datagrid('getEditingRowIndex');
	if (indexs.length > 0)
	{
		$('#sheetConfigTable').datagrid('endEdit',indexs[0]);
	}
	var sheet = $('#sheetConfigTable').datagrid('getRows')
	var sheetConfig = { sheet: sheet}

	//��������
	var indexs = $('#curveConfigTable').datagrid('getEditingRowIndex');
	if (indexs.length > 0)
	{
		$('#curveConfigTable').datagrid('endEdit',indexs[0]);
	}
	var curve = $('#curveConfigTable').datagrid('getRows')
	sheetConfig.curve = curve

	//���߿�ʼ����
	var indexs = $('#curveStartConfigTable').datagrid('getEditingRowIndex');
	if (indexs.length > 0)
	{
		$('#curveStartConfigTable').datagrid('endEdit',indexs[0]);
	}
	var curveStart = $('#curveStartConfigTable').datagrid('getRows')
	if (!checkUnique(curveStart,"itemDr"))
	{
		$.messager.popover({ msg: "�������߿�ʼ��������,�������̼�¼�����ظ�", type:'error' });
		return
	}
	sheetConfig.curveStart = curveStart

	//��ӡ�������� ��ʾ�ߺʹ����� ����ȫ�� ������
	var printRuleConfig = getFromValue("#printRuleConfig")
	
	$cm({
		ClassName:GV._CLASSNAME,
		MethodName:"saveLaborConfigInfo",
		id:row.id,
		contentConfig:JSON.stringify(contentConfig), 
		printRuleConfig: JSON.stringify(printRuleConfig),
		tableConfig: JSON.stringify(sheetConfig),
		textConfig: JSON.stringify(textConfig)
	},function(data){
		if (data.code == 0){
			$.messager.popover({ msg: '����ɹ�', type:'success' });
			getLaborConfigInfo()
        }else{
            $.messager.popover({ msg: data.error, type:'error' });
            return
        }
	})
}


/**
 * ��ֵ����
 * @param {*} data 
 */
function assignPage(data){

	initLogoConfig({})
	setFromValue('#printRuleConfig',{})
	$('#textConfigTable').datagrid('loadData',[])
	$('#sheetConfigTable').datagrid('loadData',[])
	$('#curveConfigTable').datagrid('loadData',[])
	$('#curveStartConfigTable').datagrid('loadData',[])

	if (!!data.textConfig)
	{
		$('#textConfigTable').datagrid('loadData',$.parseJSON(data.textConfig).texts)
	}

	if (!!data.contentConfig)
	{
		var contentConfig =  $.parseJSON(data.contentConfig)
		initLogoConfig(contentConfig)
	}

	if (!!data.tableConfig)
	{
		var tableConfig =  $.parseJSON(data.tableConfig)
		$('#sheetConfigTable').datagrid('loadData',tableConfig.sheet)
		$('#curveConfigTable').datagrid('loadData',tableConfig.curve)
		$('#curveStartConfigTable').datagrid('loadData',tableConfig.curveStart)
	}

	if (!! data.printRuleConfig)
	{
		var printRuleConfig = $.parseJSON(data.printRuleConfig)
		setFromValue('#printRuleConfig',printRuleConfig)
	}
}

/**
 * �����ߡ�������
 */
function initWpLineConfig(){
	//�������̼�¼
	$('#wpLinkOBSItem').combobox({
        valueField: 'value',
        textField: 'desc',
        data: GV.OBSItem
    })
	//��ɫ
	$('#wpLineColor').color({
		editable:true,
		width:90,
		height:30
	});	
	//������ʽ
	$('#wpLineType').combobox({
        valueField: 'value',
        textField: 'desc',
        data: GV.LineTypeList
    })
}
/**
 * ����ȫ��
 */
function initFullWombConfig()
{
	//�������̼�¼
	$('#wombLinkOBSItem').combobox({
        valueField: 'value',
        textField: 'desc',
        data: GV.OBSItem
    })
	//��ɫ
	$('#wombFontColor').color({
		editable:true,
		width:90,
		height:30
	});	
}
/**
 * ������
 */
function initBirthMarkerConfig()
{
	//�������̼�¼
	$('#markerLinkOBSItem').combobox({
        valueField: 'value',
        textField: 'desc',
        data: GV.OBSItem
    })
	//��ɫ
	$('#markerFontColor').color({
		editable:true,
		width:90,
		height:30
	});	
}

/**
 * ��ȡԺ��ID
 * @returns Ժ��ID
 */
function getHosp()
{
	try{
		return parent.$HUI.combogrid('#_HospList').getValue()		
	}catch(err){
		return "2"
	}

}

function setFormatter(data){
	return function(value){
		for(var index in data)
		{
			if (data[index].value == value){
				return data[index].desc
			}
		}
		return value
	}
}

function setEditor(data){
	return {
		type:'combobox',
		options:{
			valueField:'value',
			textField:'desc',
			data: data
		}
	}
}

/**
 * �½����
 */
 function createEditGrid(tableId,columns,addCallBack,dblClickCallBack)
 {
     var tableId = "#" + tableId
     $(tableId).datagrid({
	     fit: true,
         columns :[ columns ],
         rownumbers:true,
         singleSelect : true,
         autoSizeColumn:false,
         pagination:false,
         loadMsg : '������..',
         toolbar:[{
             iconCls: 'icon-add',
             text:$g('����'),
             handler: function(){
				$(tableId).datagrid("acceptChanges");
                 //$(tableId).datagrid("rejectChanges");
				 $(tableId).datagrid("unselectAll");
                 $(tableId).datagrid('appendRow',{ rowKey : Math.random().toString(36).substr(2) });
				 $(tableId).datagrid("acceptChanges");
                 var rows= $(tableId).datagrid('getRows');
                 $(tableId).datagrid('beginEdit',rows.length-1);
                 $(tableId).datagrid('selectRow',rows.length-1);
                 if (!!addCallBack)
                 {
                     addCallBack(rows.length-1)
                 }
             }
         },{
             iconCls: 'icon-copy',
             text:$g('����'),
             handler: function(){
				var row = $(tableId).datagrid("getSelected");
				if (row == null){
					$.messager.popover({ msg: "��ѡ��һ��!", type:'error' });
					return
				}
				$(tableId).datagrid("acceptChanges");
				//$(tableId).datagrid("rejectChanges");
				$(tableId).datagrid("unselectAll");
				var newRow = {}
				$.extend(true,newRow,row)
				newRow.rowKey = Math.random().toString(36).substr(2)
				$(tableId).datagrid('appendRow',newRow);
				var rows= $(tableId).datagrid('getRows');
				$(tableId).datagrid('beginEdit',rows.length-1);
				$(tableId).datagrid('selectRow',rows.length-1);

             }
         },{
			iconCls: 'icon-cancel',
			text:$g('ɾ��'),
			handler: function(){
			   var row = $(tableId).datagrid("getSelected");
			   if (row == null){
				   $.messager.popover({ msg: "��ѡ��һ��!", type:'error' });
				   return
			   }
			   var index = $(tableId).datagrid("getRowIndex",row);
			   $(tableId).datagrid("deleteRow",index);
			}
		 }],
         onDblClickRow: function(rowIndex, rowData){
			$(tableId).datagrid("acceptChanges");
             //$(this).datagrid("rejectChanges");
			 $(this).datagrid("acceptChanges");
             $(this).datagrid("unselectAll");
             $(this).datagrid("beginEdit", rowIndex);
             $(this).datagrid("selectRow",rowIndex);
			 var opts = $(this).datagrid("options");
			 var trs = opts.finder.getTr(this, rowIndex);
			 trs.draggable( 'disable')  //����ȥ����ק������༭���ı�����ѡ�е�����
             if (!!dblClickCallBack)
             {
                 dblClickCallBack(rowIndex,rowData)
             }
         },
         onLoadSuccess:function(){
             //�����϶���
             $(this).datagrid('enableDnd');
         },
		 onClickCell: function(){
			console.log("222")
		 }
     })	
 }

 // ѡ��ͼƬ
function chooseImg() {
	var files = $("#img").next().find('input[type=file]')[0].files[0];
	var size = files.size / 1024 / 1024;
	if (size <= 1) {
		var reader = new FileReader();
		reader.readAsDataURL(files);
		reader.onload = function(event){
			var imgFile = event.target.result;
			$(".show-img").show();
			$(".bg-layer").hide();
			$(".show-img img").attr("src",imgFile);
		};
	} else {
		$.messager.popover({ msg: "ͼƬ��С���ܳ���1M", type:'alert' });
	}
}
// ɾ��ͼƬ
function deleteImg(){
	$(".td-img").html('<input id="img" class="hisui-filebox" name="file" style="width:274px;" />');
	$HUI.filebox("#img",{
		plain:true,
		prompt:"",
		onChange:function(){
			chooseImg();	
		}
	});
	$(".show-img").hide();
	$(".show-img img").attr("src","");
}


 /**
  * ��rgbת����16������ɫ����
  * @param {rgb} color  
  * @returns 
  */
 function colorRGBtoHex(color) {
	var rgb = color.split(',');
	var r = parseInt(rgb[0].split('(')[1]);
	var g = parseInt(rgb[1]);
	var b = parseInt(rgb[2].split(')')[0]);
	var hex = "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
	return hex;
}




function getFromValue(container){
	var attrs = {}; // ���صĶ���
	var gettedNames = []; // �����������������
	var target = $(container);

	// combo&datebox
	var cbxCls = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
	var ipts = jQuery('[comboName]', target);
	if (ipts.length){
		ipts.each(function(){
			for(var i=0; i<cbxCls.length; i++){
				var type = cbxCls[i];
				var name = jQuery(this).attr('comboName');
				if (jQuery(this).hasClass(type+'-f')){
					if (jQuery(this)[type]('options').multiple){
						var val = jQuery(this)[type]('getValues');
						extendJSON(name, val);
					} else {
						var val = jQuery(this)[type]('getValue');
						extendJSON(name, val);
					}
					break;
				}
			}
		});
	}
	// radio&checkbox
	var ipts = jQuery("input[name][type=radio], input[name][type=checkbox]", target);
	if(ipts.length) {
		var iptsNames = [];
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
				iptsNames.push(name);
			}
		});
		for(var i=0;i<iptsNames.length;i++) {
			var iptsFlts = ipts.filter('[name='+iptsNames[i]+']');
			var type = iptsFlts.eq(0).attr('type');
			if(type === 'radio') {
				iptsFlts.each(function(){
					if(jQuery(this).prop('checked')) {
						extendJSON(iptsNames[i], jQuery(this).val());
						return false;
					}
				});
			} else if(type === 'checkbox') {
				var vals = [];
				iptsFlts.each(function(){
					if(jQuery(this).prop('checked')) {
						vals.push(jQuery(this).val());
					}
				});
				extendJSON(iptsNames[i], vals);
			}
		}
	}
	// numberbox&slider
	var cTypes = ['numberbox', 'slider'];
	for(var i=0;i<cTypes.length;i++) {
		ipts = jQuery("input["+cTypes[i]+"Name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr(cTypes[i]+'Name');
				var val = jQuery(this)[cTypes[i]]('getValue');
				extendJSON(name, val);
			});
		}
	}
	// multiselect2side
	ipts = jQuery(".multiselect2side", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			var val = jQuery(this)['multiselect2side']('getValue');
			extendJSON(name, val);
		});
	}
	// select
	ipts = jQuery("select[name]", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			var val = jQuery(this).val();
			extendJSON(name, val);
		});
	}
	// validatebox&input&textarea
	ipts = jQuery("input[name], textarea[name]", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			var val = jQuery(this).val();
			extendJSON(name, val);
		});
	}

	//swtichbox
	ipts = jQuery(".hisui-switchbox", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			var val = jQuery(this)['switchbox']('getValue') ? "Y" : "N";
			extendJSON(name, val);
		});
	}

	// function
	function extendJSON(name, val) {
		if(!name) return;
		if(-1 !== $.inArray(name, gettedNames)) {
			// ֻ��ȡ��һ��name��ֵ
			return;
		} else {
			gettedNames.push(name);
		}
		val = 'undefined'!==typeof(val)? val:'';
		var newObj = eval('({"'+name+'":'+JSON.stringify(val)+'})');
		jQuery.extend(attrs, newObj);
	}
	return attrs;
}

function setFromValue(container, json){
	var target = $(container);
	// combo&datebox
	var cbxCls = ['combobox','combotree','combogrid','datetimebox','datebox','combo'];
	var ipts = jQuery('[comboName]', target);
	if (ipts.length){
		ipts.each(function(){
			for(var i=0; i<cbxCls.length; i++){
				var type = cbxCls[i];
				var name = jQuery(this).attr('comboName');
				if (jQuery(this).hasClass(type+'-f')){
					if (name.indexOf('Color')>-1)
					{
						jQuery(this)['color']('setValue', json[name] || '');
					}else{
						if (jQuery(this)[type]('options').multiple){
							jQuery(this)[type]('setValues',json[name] || []);
						} else {
							jQuery(this)[type]('setValue', json[name] || '');
						}
					}
					break;
				}
			}
		});
	}
	// radio&checkbox
	var ipts = jQuery("input[name][type=radio], input[name][type=checkbox]", target);
	if(ipts.length) {
		var iptsNames = [];
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			if(name!='' && name!=null && -1 === jQuery.inArray(name, iptsNames)) {
				iptsNames.push(name);
			}
		});
		for(var i=0;i<iptsNames.length;i++) {
			var iptsFlts = ipts.filter('[name='+iptsNames[i]+']');
			var type = iptsFlts.eq(0).attr('type');
			if(type === 'radio') {
				iptsFlts.each(function(){
					if(jQuery(this).prop('checked')) {
						//extendJSON(iptsNames[i], jQuery(this).val());
						return false;
					}
				});
			} else if(type === 'checkbox') {
				var vals = [];
				iptsFlts.each(function(){
					if(jQuery(this).prop('checked')) {
						vals.push(jQuery(this).val());
					}
				});
				//extendJSON(iptsNames[i], vals);
			}
		}
	}
	// numberbox&slider
	var cTypes = ['numberbox', 'slider'];
	for(var i=0;i<cTypes.length;i++) {
		ipts = jQuery("input["+cTypes[i]+"Name]", target);
		if(ipts.length){
			ipts.each(function(){
				var name = jQuery(this).attr(cTypes[i]+'Name');
				jQuery(this)[cTypes[i]]('setValue',json[name] || '');
			});
		}
	}
	// multiselect2side
	ipts = jQuery(".multiselect2side", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			jQuery(this)['multiselect2side']('setValue',json[name] || '');
		});
	}
	// select
	ipts = jQuery("select[name]", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			jQuery(this).val(json[name] || '');
		});
	}
	// validatebox&input&textarea
	ipts = jQuery("input[name], textarea[name]", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			jQuery(this).val(json[name] || '');
		});
	}

	//swtichbox
	ipts = jQuery(".hisui-switchbox", target);
	if(ipts.length){
		ipts.each(function(){
			var name = jQuery(this).attr('name');
			jQuery(this)['switchbox']('setValue',json[name] =="Y" ? true : false)
		});
	}
	return true;
}

function checkUnique(rows, columnName) {
	var values = {};
	for (var i = 0; i < rows.length; i++) {
	  var value = rows[i][columnName];
	  if (values[value]) {
		return false; // �ظ�ֵ
	  }
	  values[value] = true;
	}
	return true; // Ψһֵ
  }