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
//===================================================================================================================
var LINK_CSP="dhc.nurse.ip.common.getdata.csp";
var hospComp="",hospID = session['LOGON.HOSPID'];
var type="L"
var clickDiv=false
var GV={
	_CLASSNAME:"Nur.NIS.Service.OrderSheet.Setting",
	dateFormat:[
		{value:"0",label:"yyyy-MM-dd"},
		{value:"1",label:"dd/MM/yyyy"}
	],
	timeFormat:[
		{value:"0",label:"HH:mm:ss"},
		{value:"1",label:"HH:mm"}
	],
	DateTimeStyle:[],
	orderNameSuffix:[
		{id:"",desc:"���մ���",active:"N"},
		{id:"",desc:"��Ѫ����",active:"N"},
		{id:"",desc:"����",active:"N"},
		{id:"",desc:"���μ���",active:"N"},
		{id:"",desc:"�÷�",active:"N"},
		{id:"",desc:"Ƶ��",active:"N"},
		{id:"",desc:"Ƥ������",active:"N"},
		{id:"",desc:"Сʱҽ���Ʒ�����",active:"N"},
		{id:"",desc:"��鲿λ",active:"N"},
		{id:"",desc:"�������Ʊ�ע",active:"N"},
		{id:"",desc:"ҽ���׶�",active:"N"}
	],
	changePageList:[
		{id:"",item:"ת��",name:"",arcItmDR:"",arcItmDesc:"",skipFlag:"N",scribingFlag:"N"},
		{id:"",item:"����",name:"",arcItmDR:"",arcItmDesc:"",skipFlag:"N",scribingFlag:"N"},
		{id:"",item:"����",name:"",arcItmDR:"",arcItmDesc:"",skipFlag:"N",scribingFlag:"N"},
		{id:"",item:"��������",name:"",arcItmDR:"",arcItmDesc:"",skipFlag:"N",scribingFlag:"N"}
	],
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
	HeaderLevelList:[{
		value: "1",
		desc: "һ��",
	},{
		value: "2",
		desc: "����"
	}],
	BasicData: [],
	TextBasicData: [],
	BasicOrderData: [],
}
$(function() {
	var HISUIStyleCode;
	hospComp = GenHospComp("Nur_IP_OrderSheetSet",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //��ȡ�������ֵ
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "������׼�����ֻ�ҽԺ[��Ժ]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;
		initUI();    	       	
	}  ///ѡ���¼�	
	
	if (!!HISUIStyleCode  && HISUIStyleCode=="lite")
	{
		$(".tabs>.tabs-selected").after('<div id="TSheetTab" class="TSheetTabLite" style="float:left">'+
									'<a href="javascript:void(0)" class="tabs-lite" style="height: 33px; line-height: 33px;">'+
										'<span class="tabs-title">��ʱҽ����</span>'+
										'<span class="tabs-icon"/>'+
									'</a>'+
								'</div>'+
								'<div id="NSheetTab" class="NSheetTabLite" style="float:left">'+
									'<a href="javascript:void(0)" class="tabs-lite" style="height: 33px; line-height: 33px;">'+
										'<span class="tabs-title">������</span>'+
										'<span class="tabs-icon"/>'+
									'</a>'+
								'</div>'
								)	
	}else{
		$(".tabs>.tabs-selected").after('<div id="TSheetTab" class="TSheetTab" style="float:left">'+
									'<a href="javascript:void(0)" class="tabs-inner" style="height: 33px; line-height: 33px;">'+
										'<span class="tabs-title">��ʱҽ����</span>'+
										'<span class="tabs-icon"/>'+
									'</a>'+
								'</div>'+
								'<div id="NSheetTab" class="NSheetTab" style="float:left">'+
									'<a href="javascript:void(0)" class="tabs-inner" style="height: 33px; line-height: 33px;">'+
										'<span class="tabs-title">������</span>'+
										'<span class="tabs-icon"/>'+
									'</a>'+
								'</div>'
								)	
	}
	
	function changeTab(){
		clickDiv = true
		$("#tabs .tabs-selected").removeClass("tabs-selected")
		var selectedTab = $('#tabs').tabs('getSelected'); 
		var index = $('#tabs').tabs('getTabIndex',selectedTab);
		if (index == 2){
			$('#tabs').tabs('select',1)
			$("#tabs li.tabs-selected").removeClass("tabs-selected")
		}
		clickDiv = false
	}

	$("#TSheetTab").on("click",function(){

		changeTab()
		$("#TSheetTab").addClass("tabs-selected")
		type = "T"
		$('.dispalyConfig>.right').css("display","none")
		initChangeTab()
	})
	$("#NSheetTab").on("click",function(){
		changeTab()
		$("#NSheetTab").addClass("tabs-selected")
		type = "N"
		$('.dispalyConfig>.right').css("display","none")
		initChangeTab()
	})

	$("#tabs ul li:nth-child(2)").on("click",function(){
		$("#tabs .tabs-selected").removeClass("tabs-selected")
		$("#tabs ul li:nth-child(2)").addClass("tabs-selected")
		type = "L"
		$('.dispalyConfig>.right').css("display","block")
		initChangeTab()
	})

	$HUI.tabs("#tabs",
	{
		onSelect:function(title,index){
			$("#TSheetTab").removeClass("tabs-selected")
			$("#NSheetTab").removeClass("tabs-selected")
			if(index == 1 && !clickDiv){
				type = "L"
				initChangeTab()
			}else if(index == 2){
				type = ""
			}
		}
	});
	
	//��ȡ��������
	GV.BasicData = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getBasicData",
		
	},false)
	GV.TextBasicData = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getTextConfigBasicData",
		
	},false)
	GV.BasicOrderData = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getBasicOrderData",
	},false)
	
	GV.DateTimeStyle = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getDateTimeStyle",
	},false)
	initUI()
})
function initUI(){
	editSkipIndex=undefined,editArcCatIndex=undefined,editArcItmIndex=undefined,editOrdCatIndex=undefined,editArcCatIndex2=undefined,editArcItmIndex2=undefined,editLocIndex=undefined
	initTextConfig()
	initSheetConfig()
	initDispalyConfig()
	initCommonConfig()
}

function initChangeTab()
{
	editSkipIndex=undefined,editArcCatIndex=undefined,editArcItmIndex=undefined,editOrdCatIndex=undefined,editArcCatIndex2=undefined,editArcItmIndex2=undefined,editLocIndex=undefined
	initTextConfig()
	initSheetConfig()
	initDispalyConfig()
	
}

//��ʼ�� ���������
function initTextConfig()
{
	$("#textConfigTable").datagrid({
		url: LINK_CSP + '?className=Nur.NIS.Service.OrderSheet.Setting&methodName=getTextConfig',
		columns :[[
				{field:'id',hidden:true,rowspan:2},
				{field:'description',title:'��Ŀ����',rowspan:2, width:100,editor:{type:'text'}},
				{field:'printX',title:'��ӡ����X(mm)',rowspan:2,width:110,editor:{type:'numberbox',options:{min:0}}},
				{field:'printY',title:'��ӡ����Y(mm)',rowspan:2, width:110,editor:{type:'numberbox',options:{min:0}}},
				{title:'����',colspan:6},
				{title:'��Ԫ��',colspan:7},
				{field: 'handler', title: '����', width: 100, align:"center", rowspan:2, formatter:function(value, row, index){
						return  "<span style='cursor:pointer' onclick='deleteTextConfigRow(\""+ row.id +"\")' class='icon icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</span>"
					}
				}
			],[
				{field:'text',title:'�ı�', width:100, align:"center", editor:{type:'text'}},
				{field:'textWidth',title:'���(mm)', width:80, align:"center", editor:{type:'numberbox',options:{min:0}}},
				{field:'textFontFamily',title:'����', width:80,align:'center',
					formatter: setFormatter(GV.FontFamilyList),
					editor:setEditor(GV.FontFamilyList),
				},
				{field:'textFontSize',title:'�ֺ�', width:80, align:'center',editor:{type:'numberbox',options:{min:0}}},
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
				{field:'itemWidth',title:'Ԫ�ؿ��(mm)',width:110,align:'center',editor:{type:'numberbox',options:{min:0}}},
				{field:'itemFontFamily',title:'Ԫ������',width:80,align:'center',
					formatter: setFormatter(GV.FontFamilyList),
					editor:setEditor(GV.FontFamilyList),
				},
				{field:'itemFontSize',title:'Ԫ���ֺ�',width:80,align:'center',editor:{type:'numberbox',options:{min:0}}},
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
			]
		],
		rownumbers:true,
		singleSelect : true,
		autoSizeColumn:false,
		pagination:false,
		loadMsg : '������..',
		onBeforeLoad: function(param) {
            param.parameter1 = $HUI.combogrid('#_HospList').getValue()
            param.parameter2 =  type
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('����'),
			handler: function(){
				$('#textConfigTable').datagrid("rejectChanges");
				$('#textConfigTable').datagrid("unselectAll");
				$('#textConfigTable').datagrid('appendRow',{});
                var rows= $('#textConfigTable').datagrid('getRows');
                $('#textConfigTable').datagrid('beginEdit',rows.length-1);
				$('#textConfigTable').datagrid('selectRow',rows.length-1);
			}
		},{
			iconCls: 'icon-save',
			text:$g('����'),
			handler: function(){
				var indexs = $('#textConfigTable').datagrid('getEditingRowIndex');
				if (indexs.length == 0)
				{
					$.messager.popover({ msg: "���������ڱ༭����!", type:'error' });	
					return
				}
				$('#textConfigTable').datagrid('endEdit',indexs[0])
				var row = $('#textConfigTable').datagrid('getSelected',indexs[0])
				$.cm({	
					ClassName:GV._CLASSNAME,
					MethodName:"SaveTextConfig",
					saveDataJson:JSON.stringify([row]),
					hospID:$HUI.combogrid('#_HospList').getValue(),
					type: type
				},function testget(result){
					if(result==0){
						$.messager.popover({ msg: "����ɹ���", type:'success' });	
						$('#textConfigTable').datagrid('reload')
					}else{
						$.messager.popover({ msg: result, type:'error' });	
					}		
				})
			}
		}],
		onDblClickRow: function(rowIndex, rowData){
            $('#textConfigTable').datagrid("rejectChanges");
            $('#textConfigTable').datagrid("unselectAll");
            $('#textConfigTable').datagrid("beginEdit", rowIndex);
            $('#textConfigTable').datagrid("selectRow",rowIndex);
        },

	})	
}

//ɾ�����������
function deleteTextConfigRow(id){
	if ("undefined" == id && id == "" ) return
	$.messager.confirm('��ʾ','�Ƿ�ɾ��?',function(r){
		if (r)
		{
			$cm({
				ClassName: GV._CLASSNAME,
				MethodName: "DeleteTextConfig",
				id: id
			},function(result){
				if (result==0){
					$.messager.popover({ msg: "����ɹ���", type:'success' });	
					$('#textConfigTable').datagrid('reload')
				}else{
					$.messager.popover({ msg: result, type:'error' });	
				}		
			})
		}
	})
}

var editSuffixIndex;
//��ʼ���������
function initSheetConfig(){
	//�������
	$("#sheetConfigTable").datagrid({
		url: LINK_CSP + '?className=Nur.NIS.Service.OrderSheet.Setting&methodName=getSheetConfig',
		columns :[[
				{field:'columnName',title:'����',rowspan:2, width:100,editor:{type:'text'}},
				{field:'headerLevel',title:'��ͷ�㼶',rowspan:2,width:100,
					formatter: setFormatter(GV.HeaderLevelList),
					editor:setEditor(GV.HeaderLevelList),
				},
				{field:'upperHeader',title:'�ϼ���ͷ',rowspan:2, width:100,editor:{type:'text'}},
				{field:'width',title:'���',rowspan:2, width:80, align:"center", editor:{type:'numberbox',options:{min:0}} },
				{title:'��ͷ',colspan:4},
				{title:'��Ԫ��',colspan:5},
				{field: 'handler', title: '����', width: 130, align:"center", rowspan:2, formatter:function(value, row, index){
					var del = "<span style='padding-left: 5px;cursor:pointer' class='icon icon-cancel' onclick='deleteSheetConfigRow(\""+ row.id +"\")'>&nbsp;&nbsp;&nbsp;&nbsp</span>";
					var down = '<span style="padding-left: 5px;cursor:pointer" class="icon icon-down" onclick=upOrDownSheetConfigRow("'+row.id+'","down","'+index+'")>&nbsp;&nbsp;</span> ';
                    var up = '<span style="padding-left: 5px;width:10px;cursor:pointer" class="icon icon-up" onclick=upOrDownSheetConfigRow("'+row.id+'","up","'+index+'")>&nbsp;&nbsp;</span>';
                    return up + down + del ; 
					}
				}
			],[
				{field:'textFontFamily',title:'����',width:80,align:'center',
					formatter: setFormatter(GV.FontFamilyList),
					editor:setEditor(GV.FontFamilyList),
				},
				{field:'textFontSize',title:'�ֺ�',width:80, align:'center',editor:{type:'numberbox',options:{min:0}}},
				{field:'textFontAlign',title:'���뷽ʽ' , width:90,align:'center',
					formatter: setFormatter(GV.FontAlignList),
					editor:setEditor(GV.FontAlignList),
				},
				{field:'textontWeight',title:'�Ӵ�����', width:90,align:'center',
					formatter: setFormatter(GV.FontWeightList),
					editor:setEditor(GV.FontWeightList),
				},
				{field:'item',title:'������������',width: 110,align:'center',
					formatter: setFormatter(GV.BasicData),
					editor:setEditor(GV.BasicData),
				},
				{field:'itemFontFamily',title:'����', width:80,align:'center',
					formatter: setFormatter(GV.FontFamilyList),
					editor:setEditor(GV.FontFamilyList),
				},
				{field:'itemFontSize',title:'�ֺ�', width:80, align:'center',editor:{type:'numberbox',options:{min:0}}},
				{field:'itemFontAlign',title:'���뷽ʽ', width:90,align:'center',
					formatter: setFormatter(GV.FontAlignList),
					editor:setEditor(GV.FontAlignList),
				},
				{field:'itemFontWeight',title:'�Ӵ�����', width:90,align:'center',
					formatter: setFormatter(GV.FontWeightList),
					editor:setEditor(GV.FontWeightList),
				}
			]
		],
		rownumbers:true,
		singleSelect : true,
		autoSizeColumn:false,
		fitColumns:true,
		pagination:false,
		loadMsg : '������..',
		onBeforeLoad: function(param) {
            param.parameter1 = $HUI.combogrid('#_HospList').getValue()
            param.parameter2 =  type
        },
		toolbar:[{
			iconCls: 'icon-add',
			text:$g('����'),
			handler: function(){
				$('#sheetConfigTable').datagrid("rejectChanges");
				$('#sheetConfigTable').datagrid("unselectAll");
				$('#sheetConfigTable').datagrid('appendRow',{});
                var rows= $('#sheetConfigTable').datagrid('getRows');
                $('#sheetConfigTable').datagrid('beginEdit',rows.length-1);
				$('#sheetConfigTable').datagrid('selectRow',rows.length-1);
			}
		},{
			iconCls: 'icon-save',
			text:$g('����'),
			handler: function(){
				var indexs = $('#sheetConfigTable').datagrid('getEditingRowIndex');
				if (indexs.length == 0)
				{
					$.messager.popover({ msg: "���������ڱ༭����!", type:'error' });	
					return
				}
				$('#sheetConfigTable').datagrid('endEdit',indexs[0])
				var row = $('#sheetConfigTable').datagrid('getSelected',indexs[0])
				$.cm({	
					ClassName:GV._CLASSNAME,
					MethodName:"SaveSheetConfig",
					saveDataJson:JSON.stringify([row]),
					hospID:$HUI.combogrid('#_HospList').getValue(),
					type: type
				},function testget(result){
					if(result==0){
						$.messager.popover({ msg: "����ɹ���", type:'success' });	
						$('#sheetConfigTable').datagrid('reload')
					}else{
						$.messager.popover({ msg: result, type:'error' });	
					}		
				})
			}
		}],
		onDblClickRow: function(rowIndex, rowData){
            $('#sheetConfigTable').datagrid("rejectChanges");
            $('#sheetConfigTable').datagrid("unselectAll");
            $('#sheetConfigTable').datagrid("beginEdit", rowIndex);
            $('#sheetConfigTable').datagrid("selectRow",rowIndex);
        },

	})

	//ҽ��������Ϣ����
	$("#OrdSuffixConfigTable").datagrid({
		url: LINK_CSP + '?className=Nur.NIS.Service.OrderSheet.Setting&methodName=getOrdSuffixConfig',
		columns :[[
			{field:'id',hidden:true},
			{field:'Sequence',title:'˳��',width:40,hidden:true},
			{field:'Item',title:'ҽ�����ƺ�׺',width:100,
				formatter: setFormatter(GV.BasicOrderData),
				editor:setEditor(GV.BasicOrderData)},
	    	{field:'ItemDesc',title:'ҽ�����ƺ�׺',width:100, hidden:true}, 
	    	{field:'Code',title:'����',width:150,hidden:true}, 
	        {field:'ActiveFlag',title:'�Ƿ�����',width:80,formatter:function(value,row,index){
		    	return value=="Y" ? "��" : "��";	
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}},hidden:true},
    		{field: 'handler', title: '����', width: 50, align:"center", formatter:function(value, row, index){
				return  "<span style='cursor:pointer' onclick='deleteOrdSuffixConfigRow(\""+ row.id +"\")' class='icon icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</span>"
			}}
		    	       	       
		]],
		rownumbers: true,
		singleSelect : true,
		loadMsg : '������..',
		onBeforeLoad: function(param) {
            param.parameter1 = type
            param.parameter2 =  $HUI.combogrid('#_HospList').getValue()
        },
		onClickRow:function(rowIndex,rowData){
			var indexs = $('#OrdSuffixConfigTable').datagrid('getEditingRowIndex');
			if (indexs.length > 0)
			{
				$('#OrdSuffixConfigTable').datagrid("acceptChanges");
			}
			var rows = $('#OrdSuffixConfigTable').datagrid('getRows')
			if ( $.isEmptyObject(rows[rowIndex]))	
			{
				$('#OrdSuffixConfigTable').datagrid("rejectChanges");
			}
            $('#OrdSuffixConfigTable').datagrid("unselectAll");
            $('#OrdSuffixConfigTable').datagrid("beginEdit", rowIndex);
            $('#OrdSuffixConfigTable').datagrid("selectRow",rowIndex);
            var ed = $('#OrdSuffixConfigTable').datagrid('getEditor', {index:rowIndex,field:'Item'});
			$(ed.target).combobox("options").onSelect = function(){
				$('#OrdSuffixConfigTable').datagrid("acceptChanges");
				var rows = $('#OrdSuffixConfigTable').datagrid('getRows')
				$cm({
					ClassName:GV._CLASSNAME,
					MethodName: "saveOrdSuffixConfig",
					saveDataJson: JSON.stringify(rows[rowIndex]),
					hospID:$HUI.combogrid('#_HospList').getValue(),
					type : type
				}, function(rtn){
					$.messager.popover({ msg: "����ɹ���", type:'success' });
					$('#OrdSuffixConfigTable').datagrid("reload");
				})
				//saveOrdNameSuffixSet()
			};
		},
		onLoadSuccess:function(){
			$(this).datagrid('enableDnd');
			$('#OrdSuffixConfigTable').datagrid('appendRow', {});
		},
		onDrop:function(targetRow,sourceRow,point){
			$cm({
				ClassName:GV._CLASSNAME,
				MethodName: "changeOrdSuffixSequence",
				targetRow: JSON.stringify(targetRow),
				sourceRow:JSON.stringify(sourceRow)
			}, function(rtn){
				$.messager.popover({ msg: "����ɹ���", type:'success' });
				$('#OrdSuffixConfigTable').datagrid("reload");
			})
		}
	})

	reloadSuffixGrid();
}


// ɾ��ҽ�����ƺ�׺
function deleteOrdSuffixConfigRow(id){
	if ('undefined' === id || id === '' )
	{
		$.messager.popover({ msg: "δ�����¼", type:'error' });
		return
	}
	$cm({
		ClassName:GV._CLASSNAME,
		MethodName: "deleteOrdSuffixConfig",
		id : id
	}, function(result){
		if (result == 0){
			$.messager.popover({ msg: "����ɹ���", type:'success' });		
			$('#OrdSuffixConfigTable').datagrid("reload");
		}else{
			$.messager.popover({ msg: result, type:'error' });	
		}
	})
}

//ɾ�����������
function deleteSheetConfigRow(id){
	if ("undefined" == id && id == "" ) return
	$.messager.confirm('��ʾ','�Ƿ�ɾ��?',function(r){  
	    if (r){
		    $cm({
				ClassName: GV._CLASSNAME,
				MethodName: "DeleteSheetConfig",
				id: id
			},function(result){
				if (result==0){
					$.messager.popover({ msg: "����ɹ���", type:'success' });	
					$('#sheetConfigTable').datagrid('reload')
				}else{
					$.messager.popover({ msg: result, type:'error' });	
				}		
			})
		    
	    }  
	});
}
//�ƶ����������
function upOrDownSheetConfigRow(id, handler, index)
{
	
	if ((index==0)&&(handler=="up"))
    {
        $.messager.popover({msg: '�����޷�����!',type:'error',timeout: 1000});
      	return
    }
    
    var rows=$('#sheetConfigTable').datagrid('getRows');
    var rowlength=rows.length
    
   if ((index==rowlength-1)&&(handler=="down"))
   {
   		$.messager.popover({msg: '�����޷�����!',type:'error',timeout: 1000});
       	return
   }
   $cm({
	   	ClassName: GV._CLASSNAME,
		MethodName: "upOrDownSheetConfig",
		id: id,
		handler:handler
   },function(data){
	     if (data == 0){
		    $.messager.popover({ msg: "����ɹ���", type:'success' });
	        $('#sheetConfigTable').datagrid('reload')
	    }else{
	        $.messager.popover({msg: data,type:'error',timeout: 1000});
	    }
   })

}

function reloadSuffixGrid(){
	var data= $.cm({
		ClassName:"Nur.NIS.Service.OrderSheet.OrderName",
		MethodName:"getOrderNameSuffixItem",
	},false);
	var orderNameSuffix=[];
	var sequence=1;
	for(var key in data){
		if(key!="getOrderNameSuffixItem"){
			orderNameSuffix.push({id:"",code:key,desc:data[key],active:"N",sequence:sequence++});	
		}	
	}
	var selectedTab = $('#tabs').tabs('getSelected');
	$.cm({
		ClassName:GV._CLASSNAME,
		QueryName:"GetOrdNameSuffixList",
		hospID:hospID,
		type : type,
		rows:99999
	},function(data){		
		var result=data.rows;		
		if(result.length>0){
			var newData=result;
			var arr=[];
			result.forEach(function(val){
				arr.push(val.code);	
			})
			orderNameSuffix.forEach(function(val){
				if(arr.indexOf(val.code)<0) newData.push(val);	
			})
			newData.sort(sortRule("sequence"))
			$("#OrdSuffixConfigTable").datagrid("loadData",newData);		
		}else{
			$("#OrdSuffixConfigTable").datagrid("loadData",orderNameSuffix);
		}		
	})	
}

// ����
function sortRule(field){
	return function(a,b){
		return a[field]-b[field];	
	}
}

function saveOrdNameSuffixSet(data){
	$.cm({
		ClassName:GV._CLASSNAME,
		MethodName:"SaveOrdNameSuffixSet",
		saveDataJson:JSON.stringify(data),
		hospID:$HUI.combogrid('#_HospList').getValue(),
		type: type
	},function testget(result){
		if(result==0){
			$.messager.popover({ msg: "����ɹ���", type:'success' });	
			reloadSuffixGrid();	
			editSuffixIndex=undefined;
		}else{
			$.messager.popover({ msg: result, type:'error' });	
		}		
	})	
}

//��ʼ�� ��ʾ����
var editSkipIndex,editTable;
function initDispalyConfig(){
	// ҽ�����ȼ�
	$('#oecprTable').datagrid({fit:true,fitColumns:true,idField:"ID",frozenColumns:[[{field:'ck',title:'ck',checkbox:true}]],columns :[[{field:'Desc',title:'ҽ�����ȼ�',width:160}]]});

	reloadOecprGrid()

	// ҽ������ҳ��������
	$("#skipTable").datagrid({
		columns :[[
			{field:'item',title:'��Ŀ',width:70},
			{field:'name',title:'��ʾ����',width:100,editor:{type:'validatebox'}},
			{field:'arcItmDesc',title:'ҽ����',width:180,editor:{type:'combogrid'}},
			{field:'skipFlag',title:'�Ƿ�ҳ',width:70,formatter:function(value,row,index){
		    	return value=="Y" ? "��" : "��";	
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
			{field:'scribingFlag',title:'�Ƿ���',width:70,formatter:function(value,row,index){
		    	return value=="Y" ? "��" : "��";	
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}}
		]],
		singleSelect : true,
		loadMsg : '������..',
		onClickRow:function(rowIndex,rowData){
			if((editSkipIndex!=undefined)&&(editSkipIndex!=rowIndex)){
				var rows=$('#skipTable').datagrid("getRows");
				endSkipEdit(rows[editSkipIndex]);
			}
			editSkipIndex=rowIndex;
			$('#skipTable').datagrid("beginEdit",editSkipIndex);
			var ed = $('#skipTable').datagrid('getEditor', {index:editSkipIndex,field:'arcItmDesc'});
			var ed2 = $('#skipTable').datagrid('getEditor', {index:editSkipIndex,field:'skipFlag'});
			if(rowData.item=="��������"){
				$(ed.target).combogrid("disable");
				$(ed2.target).checkbox("disable");
			}else if(rowData.item=="ת��")
			{
				$(ed.target).combogrid("disable");
				$(ed.target).next().attr("title","ת��ͨ��ת�Ƽ�¼�ж�")
			}
			else{
				var obj=$(ed.target)
				getArcItmList(obj,rowData.arcItmDR,rowData.arcItmDesc,"180");	
			}
		}	
	})		

	reloadSkipGrid()
	//��ʾ�ڳ���ҽ�����ϵ���ʱҽ��
	//initEditDataGrig('arcCatTable',[[{field:'item',title:'ҽ����',width:70},{field:'desc',title:'��ʾ����',width:70}]],'arcCatTable')
	//initEditDataGrig('arcItmTable',[[{field:'item',title:'ҽ������',width:70},{field:'desc',title:'��ʾ����',width:70}]],'arcCatTable')

	initGridData("dgArcCat","TempOrd",0);
	initGridData("dgArcItm","TempOrd",1);

}

// ҽ������ҳ��������
function reloadSkipGrid(){
	$.cm({
		ClassName:GV._CLASSNAME,
		QueryName:"GetChangePageSet",
		hospID:hospID,
		type:type,
		rows:99999
	},function(data){		
		var result=data.rows;		
		if(result.length>0){
			var total=type=="L" ? 4 : 3;
			if(result.length<total){
				var newData=result;	
				var nums=total-result.length;
				for(var i=result.length;i<total;i++){
					newData.push(GV.changePageList[i]);	
				}
				$("#skipTable").datagrid("loadData",newData);
			}else{
				$("#skipTable").datagrid("loadData",data);
			}			
		}else{
			var newData=type=="L" ? GV.changePageList : GV.changePageList.slice(0,3)
			$("#skipTable").datagrid("loadData",newData);
		}		
	}) 	
}


// ҽ�����ȼ�
var savedOecpr=[];
function getSavedOecpr(){	
	var data=$.cm({
		ClassName:GV._CLASSNAME,
		QueryName:"GetSavedOecpr",
		hospID:$HUI.combogrid('#_HospList').getValue(),
		type:type,
		rows:99999
	},false)
	savedOecpr=[];
	if(data.rows.length>0){		
		data.rows.forEach(function(val){
			savedOecpr.push(val.oecprDR);	
		})	
	}	
}
function reloadOecprGrid(){
	getSavedOecpr(); 
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetOecpr",
		rows:99999
	},function(data){
		$("#oecprTable").datagrid('loadData',data); 
		$("#oecprTable").datagrid("unselectAll");	
		if(savedOecpr.length>0){
			savedOecpr.forEach(function(val){
				$("#oecprTable").datagrid("selectRecord",val);	
			});	
		}
	}) 
}

function saveOecprSet(){
	var rows=$("#oecprTable").datagrid("getSelections");
	if(rows.length>0){
		var saveArr=[],delArr=[];
		rows.forEach(function(val){
			saveArr.push(val.ID);
		});
		if(savedOecpr.length>0){
			savedOecpr.forEach(function(val){
				if(saveArr.indexOf(val)==-1){
					delArr.push(val);	
				}	
			})	
		}
		savedOecpr=saveArr;
		$.cm({
			ClassName:GV._CLASSNAME,
			MethodName:"SaveOecprSet",
			saveDataJson:JSON.stringify(saveArr),
			delDataJson:JSON.stringify(delArr),
			hospID:$HUI.combogrid('#_HospList').getValue(),
			type:type
		},function testget(result){
			if(result==0){
				$.messager.popover({ msg: "����ɹ���", type:'success' });
			}else{
				$.messager.popover({ msg: result, type:'error' });	
			}		
		})
	}			
}

// ҽ������ҳ�������ý����༭
function endSkipEdit(rowData){
	var ed=$('#skipTable').datagrid('getEditor', {index:editSkipIndex,field:'name'});
	var ed2=$('#skipTable').datagrid('getEditor', {index:editSkipIndex,field:'arcItmDesc'});
	var ed3=$('#skipTable').datagrid('getEditor', {index:editSkipIndex,field:'skipFlag'});
	var ed4=$('#skipTable').datagrid('getEditor', {index:editSkipIndex,field:'scribingFlag'});
	var name=$.trim($(ed.target).val());
	var arcItmDR=$(ed2.target).combogrid("getValue");
	var arcItmDesc=$(ed2.target).combogrid("getText");
	var skipFlag=$(ed3.target).radio('getValue') ? "Y" : "N";
	var scribingFlag=$(ed4.target).radio('getValue') ? "Y" : "N";
	$('#skipTable').datagrid("endEdit",editSkipIndex);
	$('#skipTable').datagrid('updateRow',{
		index: editSkipIndex,
		row: {
			id:rowData.id,
			item:rowData.item,
			name:name,
			arcItmDR:arcItmDR,
			arcItmDesc:arcItmDesc,
			skipFlag:skipFlag,
			scribingFlag:scribingFlag
		}
	});	
}

function saveChangePageSet(){
	if(editSkipIndex!=undefined){
		var row=$("#skipTable").datagrid("getSelections");
		endSkipEdit(row[0]);	
	}	
	var data=$("#skipTable").datagrid("getRows");
	$.cm({
		ClassName:GV._CLASSNAME,
		MethodName:"SaveChangePageSet",
		saveDataJson:JSON.stringify(data),
		hospID:$HUI.combogrid('#_HospList').getValue(),
		type:type
	},function testget(result){
		if(result==0){
			$.messager.popover({ msg: "����ɹ���", type:'success' });	
			reloadSkipGrid();	
			editSkipIndex=undefined;
		}else{
			$.messager.popover({ msg: result, type:'error' });	
		}		
	})	
}

// ��ȡҽ�����б�
function getArcItmList(obj,arcItmDR,arcItmName,width) { 	
	//ҽ������
	obj.combogrid({
		width:width,
		panelWidth: 500,
		panelHeight: 350,
		delay:500,
		mode:'remote',
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		columns: [[
			{field:'ArcimDesc',title:'��Ŀ����',width:100},
			{field:'ArcimDR',title:'��ĿID',width:30}
		]],
		pagination : true,
		//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem&arcimdesc=",
		url:$URL+"?ClassName=Nur.NIS.Service.NursingGrade.DataConfig&QueryName=FindMasterItem&arcimdesc=",
		fitColumns: true,
		enterNullValueClear:true,
		onBeforeLoad:function(param){
			if(arcItmName){
				param['q']=arcItmName;
				arcItmName=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		},
		onLoadSuccess:function(){			 
			if(arcItmDR){
	            $(this).combogrid('setValue', arcItmDR);
	            arcItmDR="";     
	        }
		}
	})
}


// ��ʼ������ҽ�����ϵ���ʱҽ������
var editArcCatIndex,editArcItmIndex,editOrdCatIndex,editArcCatIndex2,editArcItmIndex2,editLocIndex;
function initGridData(tableID,flag,type) {
    var setObj = getSelectObj(tableID);
    $('#' + tableID).datagrid({
        url: $URL,
        singleSelect: true,
        queryParams: {
            ClassName: GV._CLASSNAME,
            QueryName: flag=="TempOrd" ? 'GetTempOrdSet' : "GetShieldSet",
            hospID: hospID,
            type: type
        },
        columns: initGridColumn(tableID, setObj,flag),
        onClickRow: function (rowIndex,rowData) {
	        if(tableID=="dgArcCat" || tableID=="dgArcItm"){
		        clickTempOrdRow(tableID,rowIndex,rowData);	
	        }else{
		       	var editIndex=rowIndex;		       	
		       	$('#'+tableID).datagrid("beginEdit",editIndex);
		       	if(tableID=="dgOrderCat") editOrdCatIndex=editIndex;
		       	if(tableID=="dgArcCat2") editArcCatIndex2=editIndex;
		       	if(tableID=="dgLoc") editLocIndex=editIndex;
				if(tableID=="dgArcItm2") editArcItmIndex2=editIndex;
		    }	        		
        },
        onLoadSuccess: function (data) {
            $('#' + tableID).datagrid('appendRow', {id:"",itemDR:"",desc:"",name:""});
        }
    });
}


// ������¼�
function clickTempOrdRow(tableID,rowIndex,rowData){
	var flag=true;
    var editIndex=tableID=="dgArcCat" ? editArcCatIndex : editArcItmIndex;
    var rows=$('#'+tableID).datagrid("getRows");
	if((editIndex!=undefined)&&(editIndex!=rowIndex)){				
		var flag=endTempOrdEdit(tableID,rows[editIndex],editIndex);
	}
	if(flag){
		editIndex=rowIndex;
		$('#'+tableID).datagrid("beginEdit",editIndex);
		tableID=="dgArcCat" ? editArcCatIndex=editIndex : editArcItmIndex=editIndex;
		var ed=$('#'+tableID).datagrid('getEditor', {index:editIndex,field:'desc'});			
        if ((rowIndex + 1) == rows.length) { 
        	$(ed.target).combogrid("enable");
    	}else{
        	$(ed.target).combogrid("disable");
        }
	}else{
		var msg=tableID=="dgArcCat" ? "ҽ�����಻��Ϊ�գ�" : "ҽ�����Ϊ�գ�"
		return $.messager.popover({ msg: "��ʾ���Ʋ�Ϊ��ʱ��"+msg, type:'error' });
	}
}
// ��ȡ��ʱҽ��������/����������
function initGridColumn(tableID, setObj, flag) {
	var nameCol="";
	if(flag=="TempOrd"){
		nameCol={field:'name',title:'��ʾ����',width:100,editor:{type:'validatebox'}}; 	
	}else{
		nameCol={field:'e3333',hidden:true}; 
	}
    return [[
        {
            field: setObj.fieldName,
            title: setObj.titleDesc,
            width: flag=="TempOrd" ? 180 : 220,
            formatter: function (value, row) {
                return row[setObj.fieldName];
            },
            editor: {
                type: 'combogrid',
                options: {
                    mode: 'remote',
                    delay: 500,
                    panelWidth: 330,
                    panelHeight: 200,
                    idField: setObj.combogrid.valueField,
                    textField: setObj.combogrid.textField,
                    displayMsg: '',
                    url: $URL,
                    queryParams: {
                        ClassName: "Nur.HISUI.NeedCareOrderSet",
                        QueryName: setObj.combogrid.getMethod,
                        HospID: hospID,
                        ConfigName:'Nur_IP_OrderSheetSet'
                    },
                    pagination: true,
                    pageSize: 10,
                    columns: [[
                        { field: setObj.combogrid.valueField, title: 'id', width: 120, hidden: true },
                        { field: setObj.combogrid.textField, title: setObj.titleDesc, width: 300 }
                    ]],

                    onSelect: function (rowIndex, rowData) {
                        var arcimBeforeTrans = $('#' + tableID).datagrid('getData');
                        var ifExit =false;
                         arcimBeforeTrans.rows.forEach(function (row) {	              
	                        if(row.itemDR == rowData.id){
                            	ifExit=true ;
                            	return false;
	                        }
                        })
                        if (!ifExit) {
                            if(flag=="TempOrd") {
	                            $('#' + tableID).datagrid('appendRow', {id:"",itemDR:"",desc:"",name:""});
	                        }else{
		                    	saveShieldSet(tableID,rowData.id);    
		                    	$(this).parent().parent().parent().parent().parent().hide()
		                    }
                        }
                        else {
	                        var editIndex;
	                        if(tableID=="dgArcCat") editIndex=editArcCatIndex;
		       				if(tableID=="dgArcItm") editIndex=editArcItmIndex;
	                        if(tableID=="dgOrderCat") editIndex=editOrdCatIndex;
		       				if(tableID=="dgArcCat2") editIndex=editArcCatIndex2;
		       				if(tableID=="dgLoc") editIndex=editLocIndex;
							if(tableID=="dgArcItm2") editIndex=editArcItmIndex2;
	                        var ed=$('#' + tableID).datagrid('getEditor', {index:editIndex,field:'desc'});
	                        $(ed.target).combogrid("setValue","");
                            $.messager.popover({ msg: setObj.titleDesc + '�Ѵ��ڣ�', type: 'alert', timeout: 2000 });
                        }
                    }
                }
            },
        },
        nameCol,
        { field: 'oper', title: '����', width: 40, formatter: setObj.operFormatter }
    ]];
}
function getSelectObj(tableID) {
    var obj = {};
    switch (tableID) {
        case 'dgLoc':
            obj = {
                combogrid: {
                    getMethod: 'getLocs',
                    valueField: 'id',
                    textField: 'desc',
                },
                fieldName: 'desc',
                titleDesc: '���ηǱ�����ҽ���Ŀ�ҽ������',
                operFormatter: delBtn(tableID)
            };
            break;
        case 'dgOrderCat':
            obj = {
                combogrid: {
                    getMethod: 'getOrdCat',
                    valueField: 'id',
                    textField: 'desc',
                },
                fieldName: 'desc',
                titleDesc: '���ε�ҽ������',
                operFormatter: delBtn(tableID)
            };
            break;
        case 'dgArcCat': case 'dgArcCat2':
            obj = {
                combogrid: {
                    getMethod: 'getArcItmChart',
                    valueField: 'id',
                    textField: 'desc',
                },
                fieldName: 'desc',
                titleDesc: tableID=="dgArcCat" ? 'ҽ������' : "���ε�ҽ������",
                operFormatter: delBtn(tableID)
            };
            break;
        case 'dgArcItm' : case 'dgArcItm2':
            obj = {
                combogrid: {
                    getMethod: 'getArcim',
                    valueField: 'id',
                    textField: 'desc',
                },
                fieldName: 'desc',
                titleDesc: tableID=="dgArcItm" ? 'ҽ����' : "���ε�ҽ����",
                operFormatter: delBtn(tableID)
            };
            break;
    }

    return obj;
}
// ��ʾ�ڳ���ҽ�����ϵ���ʱҽ�����ý����༭
function endTempOrdEdit(tableID,rowData,editIndex){
	var ed=$('#'+tableID).datagrid('getEditor', {index:editIndex,field:'desc'});
	var ed2=$('#'+tableID).datagrid('getEditor', {index:editIndex,field:'name'});	
	var itemDR=$(ed.target).combogrid("getValue");
	var itemDesc=$(ed.target).combogrid("getText");
	var name=$.trim($(ed2.target).val());
	if(name!="" && itemDR=="") return false;		
	$('#'+tableID).datagrid("endEdit",editIndex);
	$('#'+tableID).datagrid('updateRow',{
		index: editIndex,
		row: {
			id:rowData.id,
			itemDR:rowData.itemDR && rowData.itemDR!=itemDR ? rowData.itemDR : itemDR,
			desc:itemDesc,
			name:name
		}
	});	
	return true;			
}

function delBtn(tableID) {
	return function(val,row,index){
		var btns = '';
		btns =   "<span style='cursor:pointer' onclick='onclick=delData(\""+ row.id +"\",\""+ tableID +"\")' class='icon icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</span>"
    	return btns;	
	}   
}
function delData(rowid,tableID){
	var type;
	if(tableID=="dgArcCat" || tableID=="dgOrderCat") type=0;
	if(tableID=="dgArcItm" || tableID=="dgArcCat2") type=1;
	if(tableID=="dgLoc") type=2
	if(tableID=="dgArcItm2") type=3
	if(rowid){
		$.m({
			ClassName:GV._CLASSNAME,
			MethodName:(tableID=="dgArcCat" || tableID=="dgArcItm") ? "DelTempOrdSet" : "DelShieldSet",
			rowid:rowid,
			hospID:$HUI.combogrid('#_HospList').getValue(),
			itemType:type
		},function testget(result){	
			if(tableID=="dgArcCat") editArcCatIndex=undefined;
    		if(tableID=="dgArcItm") editArcItmIndex=undefined;
    		if(tableID=="dgOrderCat") editOrdCatIndex=undefined;
    		if(tableID=="dgArcCat2") editArcCatIndex2=undefined;
    		if(tableID=="dgLoc") editLocIndex=undefined;		
			if(tableID=="dgArcItm2") editArcItmIndex2=undefined;
			if(result==0){        		
				$("#"+tableID).datagrid("reload");			
			}else{	
				$.messager.popover({ msg: result, type:'error' });
				return;	
			}
		});
	}else{
		return $.messager.popover({ msg: "δ����Ŀհ��в���ɾ����", type:'alert' });		
	}
}

// ��ʼ���༭���
function initEditDataGrig(tableID, columns, queryName){
    $('#' + tableID).datagrid({
        url: $URL,
        singleSelect: true,
       
        columns: initEditGridColumn(columns),
        onClickRow: function (rowIndex,rowData) {

        },
        onLoadSuccess: function (data) {
            $('#' + tableID).datagrid('appendRow', {id:"",itemDR:"",desc:"",name:""});
        }
    });
}

function initEditGridColumn(columns){
	return columns
}


function saveTempOrdSet(tableID,type){
	var editIndex=tableID=="dgArcCat" ? editArcCatIndex : editArcItmIndex;
	var flag=true;	
	if(editIndex!=undefined){
		var row=$("#"+tableID).datagrid("getSelections");
		flag=endTempOrdEdit(tableID,row[0],editIndex);		
	}
	if(flag){
		var arr=[];
		var rows=$("#"+tableID).datagrid("getRows");
		console.log($('#' + tableID).datagrid("getRows"))
		if(rows.length>0){
			arr=rows.filter(function(val){
				return val.desc!=""	
			})
		}
		if(arr.length>0){
			$.cm({
				ClassName:GV._CLASSNAME,
				MethodName:"SaveTempOrdSet",
				saveDataJson:JSON.stringify(arr),
				hospID:$HUI.combogrid('#_HospList').getValue(),
				itemType:type
			},function testget(result){
				if(result==0){
					//$.messager.popover({ msg: "����ɹ���", type:'success' });	
					$('#' + tableID).datagrid('reload');					
		            tableID=="dgArcCat" ? editArcCatIndex=undefined : editArcItmIndex=undefined;
		        }else{
					$.messager.popover({ msg: "�������ݲ����ڣ����ȱ��棡", type:'error' });	
				}		
			})
		}
	}
	return flag;		
}
// ������������
function saveShieldSet(tableID,itemDR){
	var editIndex,type;
	if(tableID=="dgOrderCat") editIndex=editOrdCatIndex,type=0;
	if(tableID=="dgArcCat2") editIndex=editArcCatIndex2,type=1;
	if(tableID=="dgLoc") editIndex=editLocIndex,type=2;
	if(tableID=="dgArcItm2") editIndex=editArcItmIndex2,type=3;
	var row=$("#"+tableID).datagrid("getRows")[editIndex];
	row.itemDR=itemDR;
	$.cm({
		ClassName:GV._CLASSNAME,
		MethodName:"SaveShieldSet",
		saveDataJson:JSON.stringify(row),
		hospID:$HUI.combogrid('#_HospList').getValue(),
		itemType:type
	},function testget(result){
		if(result==0){
			$.messager.popover({ msg: "����ɹ���", type:'success' });			
        }else{
			$.messager.popover({ msg: "�������ݲ����ڣ����ȱ��棡", type:'error' });	
		}
		$('#' + tableID).datagrid('reload');					
        if(tableID=="dgOrderCat") editOrdCatIndex=undefined;
		if(tableID=="dgArcCat2") editArcCatIndex2=undefined;
		if(tableID=="dgLoc") editLocIndex=undefined;	
		if(tableID=="dgArcItm2") editArcItmIndex2=undefined;	

	})
}

// ͨ������
function initCommonConfig(){
	// ����/ʱ���ʽ
	$HUI.combobox("#date-format",
	{
		panelHeight:"80",
		valueField:"value",
		textField:"label",
		data:GV.dateFormat
	});
	$HUI.combobox("#time-format",
	{
		panelHeight:"80",
		valueField:"value",
		textField:"label",
		data:GV.timeFormat
	});
	$HUI.combobox("#DateTimeStyle",
	{
		valueField:"value",
		textField:"desc",
		data:GV.DateTimeStyle
	});
	$.cm({
		ClassName:GV._CLASSNAME,
		MethodName:"GetConHeaderImgSet",
		hospID:hospID,
		rows:99999
	},function(data){
		var IfShowCancelTempOrder=data.IfShowCancelTempOrder=="Y" ? true : false;
		$("#switch").switchbox("setValue",IfShowCancelTempOrder);	
		$("#undo-name").val(data.CancelOrderShowText);
		var IfShowGroupFlag=data.IfShowGroupFlag=="Y" ? true : false;
		$("#switch2").switchbox("setValue",IfShowGroupFlag);		
		$("#date-format").combobox("setValue",data.DateFormat);
		$("#time-format").combobox("setValue",data.TimeFormat);
		$("#DateTimeStyle").combobox("setValue",data.DateTimeStyle);
		$("#orderNums").numberbox("setValue",data.OrderNums);
		
		var IfShowCASign=data.IfShowCASign=="Y" ? true : false;
		$("#switch3").switchbox("setValue",IfShowCASign);
		var IfShowAllCY=data.IfShowAllCY=="Y" ? true : false;
		$("#switch4").switchbox("setValue",IfShowAllCY);
		var IfGroupOrderPageFeed=data.IfGroupOrderPageFeed=="Y" ? true : false;
		$("#IfGroupOrderPageFeed").switchbox("setValue",IfGroupOrderPageFeed);
		if(data.ShowOrder!==""){
			$("#radio_"+data.ShowOrder).radio("check");	
		}else{
			$("input[name=radio]").radio("uncheck");
		}
		if(data.ImgSrc!=""){
			$(".show-img").show();	
		}else{
			$(".show-img").hide();		
		}
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
		$("#width").numberbox("setValue",data.ImgWidth);
		$("#height").numberbox("setValue",data.ImgHeight);
		$("#xAxis").numberbox("setValue",data.ImgXAxis);
		$("#yAxis").numberbox("setValue",data.ImgYAxis);
		
		var IfShowNurOrdSheet=data.IfShowNurOrdSheet=="Y" ? true : false;
		$("#showNurOrdSheetSwitch").switchbox("setValue",IfShowNurOrdSheet);
		
		if(data.DefaultSheetType!==""){
			$("#ordType_"+data.DefaultSheetType).radio("check");	
		}else{
			$("input[name=ordType]").radio("uncheck");
		}
		
		$("#tableX").val(data.tableX);
		$("#tableY").val(data.tableY);
		$("#rowHeight").val(data.rowHeight);
	}) 

	//����ҽ������
	var specialOrderColumnData = $cm({
		ClassName: GV._CLASSNAME,
		MethodName: "getSpecialOrderColumnData"
	},false)
	console.log(specialOrderColumnData)
	//����ҽ����ʾ ҽ����
	$('#specialArcMastTable').datagrid({
		url: LINK_CSP + '?className=Nur.NIS.Service.OrderSheet.Setting&methodName=getSpecialOrder',
		columns:[[
			{field:'id',hidden:true},
			{field:'ItemDR',title:'ҽ����', width:100, formatter: function (value, row, index) {
                return row["ItemDesc"];
            },
            editor: {
                type: 'combogrid',
                options: {
                    mode: 'remote',
                    delay: 500,
                    panelWidth: 330,
                    panelHeight: 200,
                    idField: 'id',
                    textField: 'desc',
                    displayMsg: '',
                    url: $URL,
                    queryParams: {
                        ClassName: "Nur.HISUI.NeedCareOrderSet",
                        QueryName: "getArcim",
                        HospID: $HUI.combogrid('#_HospList').getValue(),
                        ConfigName:'Nur_IP_OrderSheetSet'
                    },
                    pagination: true,
                    pageSize: 10,
                    columns: [[
                        { field: 'id', title: 'id', width: 120, hidden: true },
                        { field: 'desc', title: "ҽ����", width: 300 }
                    ]]
                }
            }},
			{field:'ExecUser',title:'ִ����',width:100,
				formatter: setFormatter(specialOrderColumnData.execUser),
				editor:setEditor(specialOrderColumnData.execUser),
			},{field:'ExecDataTime',title:'ִ��ʱ��',width:100,
				formatter: setFormatter(specialOrderColumnData.execDateTime),
				editor:setEditor(specialOrderColumnData.execDateTime),
			},
			{field: 'handler', title: '����', width: 50, align:"center", formatter:function(value, row, index){
				return  "<span style='cursor:pointer' onclick='deleteSpecialOrderRow(\""+ row.id +"\")' class='icon icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</span>"
				}
			}

		]],
		singleSelect : true,
		autoSizeColumn:false,
		fitColumns:true,
		pagination:false,
		onBeforeLoad: function(param) {
            param.parameter1 = $HUI.combogrid('#_HospList').getValue()
            param.parameter2 =  "0"
        },
		onClickRow: function(rowIndex, rowData){
			var indexs = $('#specialArcMastTable').datagrid('getEditingRowIndex');
			var ItemDesc=""
			if (indexs.length > 0)
			{
				var ed=$("#specialArcMastTable").datagrid('getEditor', {index:indexs[0],field:'ItemDR'});
				ItemDesc=$(ed.target).combogrid("getText")
				$('#specialArcMastTable').datagrid("acceptChanges");
			}
			var rows = $('#specialArcMastTable').datagrid('getRows')
			if (ItemDesc != "")
			{
				var editRow = rows[indexs[0]]
				editRow["ItemDesc"] = ItemDesc
				$("#specialArcMastTable").datagrid('updateRow',{
					index: indexs[0],
					row: editRow
				});
				$('#specialArcMastTable').datagrid("acceptChanges");
				
			}
			if ( $.isEmptyObject(rows[rowIndex]))	
			{
				$('#specialArcMastTable').datagrid("rejectChanges");
			}
            $('#specialArcMastTable').datagrid("unselectAll");
            $('#specialArcMastTable').datagrid("beginEdit", rowIndex);
            $('#specialArcMastTable').datagrid("selectRow",rowIndex);
        },
		onLoadSuccess: function (data) {
            $('#specialArcMastTable').datagrid('appendRow', {});
        }

	})

	//����ҽ����ʾ ҽ������
	$('#specialArcCatTable').datagrid({
		url: LINK_CSP + '?className=Nur.NIS.Service.OrderSheet.Setting&methodName=getSpecialOrder',
		columns:[[
			{field:'ItemDR',title:'ҽ������', width:100, formatter: function (value, row) {
                return row["ItemDesc"];
            },
            editor: {
                type: 'combogrid',
                options: {
                    mode: 'remote',
                    delay: 500,
                    panelWidth: 330,
                    panelHeight: 200,
                    idField: 'id',
                    textField: 'desc',
                    displayMsg: '',
                    url: $URL,
                    queryParams: {
                        ClassName: "Nur.HISUI.NeedCareOrderSet",
                        QueryName: "getArcItmChart",
                        HospID: $HUI.combogrid('#_HospList').getValue()
                    },
                    pagination: true,
                    pageSize: 10,
                    columns: [[
                        { field: 'id', title: 'id', width: 120, hidden: true },
                        { field: 'desc', title: "ҽ������", width: 300 }
                    ]]
                }
            }},
			{field:'ExecUser',title:'ִ����',width:100,
				formatter: setFormatter(specialOrderColumnData.execUser),
				editor:setEditor(specialOrderColumnData.execUser),
			},{field:'ExecDataTime',title:'ִ��ʱ��',width:100,
				formatter: setFormatter(specialOrderColumnData.execDateTime),
				editor:setEditor(specialOrderColumnData.execDateTime),
			},
			{field: 'handler', title: '����', width: 50, align:"center", formatter:function(value, row, index){
				return  "<span style='cursor:pointer' onclick='deleteSpecialOrderRow(\""+ row.id +"\")' class='icon icon-cancel' href='javascript:;'>&nbsp&nbsp&nbsp&nbsp</span>"
				}
			}

		]],
		singleSelect : true,
		autoSizeColumn:false,
		fitColumns:true,
		pagination:false,
		onBeforeLoad: function(param) {
            param.parameter1 = $HUI.combogrid('#_HospList').getValue()
            param.parameter2 =  "1"
        },
		onClickRow: function(rowIndex, rowData){
			var indexs = $('#specialArcCatTable').datagrid('getEditingRowIndex');
			var ItemDesc=""
			if (indexs.length > 0)
			{
				var ed=$("#specialArcCatTable").datagrid('getEditor', {index:indexs[0],field:'ItemDR'});
				ItemDesc=$(ed.target).combogrid("getText")
				$('#specialArcCatTable').datagrid("acceptChanges");
			}
			var rows = $('#specialArcCatTable').datagrid('getRows')
			if (ItemDesc != "")
			{
				var editRow = rows[indexs[0]]
				editRow["ItemDesc"] = ItemDesc
				$("#specialArcCatTable").datagrid('updateRow',{
					index: indexs[0],
					row: editRow
				});
				$('#specialArcCatTable').datagrid("acceptChanges");
				
			}
			if ( $.isEmptyObject(rows[rowIndex]))	
			{
				$('#specialArcCatTable').datagrid("rejectChanges");
			}
            $('#specialArcCatTable').datagrid("unselectAll");
            $('#specialArcCatTable').datagrid("beginEdit", rowIndex);
            $('#specialArcCatTable').datagrid("selectRow",rowIndex);
        },
		onLoadSuccess: function (data) {
            $('#specialArcCatTable').datagrid('appendRow', {});
        }
	})


	//��������
	initGridData("dgOrderCat","Shield",0);
	initGridData("dgArcCat2","Shield",1);
	initGridData("dgLoc","Shield",2);
	initGridData("dgArcItm2","Shield",3);

}

//����ͨ������
function saveConHeaderImgSet(){
	var IfShowCancelTempOrder=$("#switch").switchbox('getValue') ? "Y" : "N";
	var CancelOrderShowText=$.trim($("#undo-name").val());
	var IfShowGroupFlag=$("#switch2").switchbox('getValue') ? "Y" : "N";
	var DateFormat=$("#date-format").combobox("getValue");
	var TimeFormat=$("#time-format").combobox("getValue");
	var DateTimeStyle=$("#DateTimeStyle").combobox("getValue");
	var OrderNums=$.trim($("#orderNums").numberbox("getValue"));
	var IfShowCASign=$("#switch3").switchbox('getValue') ? "Y" : "N";
	var IfShowAllCY=$("#switch4").switchbox("getValue") ? "Y" : "N";
	var ShowOrder=$("input[name=radio]:checked").val();
	var ImgName=$("#img").filebox("files").length>0 ? $("#img").next().find('input[type=file]')[0].files[0].name : $("#img").next().find('input.filebox-text').val();
	var ImgSrc=$(".show-img img").attr("src");
	var ImgWidth=$.trim($("#width").numberbox("getValue"));
	var ImgHeight=$.trim($("#height").numberbox("getValue"));
	var ImgXAxis=$.trim($("#xAxis").numberbox("getValue"));
	var ImgYAxis=$.trim($("#yAxis").numberbox("getValue"));
	var ShowNurOrdSheet=$("#showNurOrdSheetSwitch").switchbox('getValue') ? "Y" : "N";
	var DefaultSheetType=$("input[name=ordType]:checked").val();
	var tableX=$("#tableX").val();
	var tableY=$("#tableY").val();
	var rowHeight=$("#rowHeight").val();
	var IfGroupOrderPageFeed=$("#IfGroupOrderPageFeed").switchbox("getValue") ? "Y" : "N";
	var data={
		IfShowCancelTempOrder:IfShowCancelTempOrder,
		CancelOrderShowText:CancelOrderShowText,
		IfShowGroupFlag:IfShowGroupFlag,
		DateFormat:DateFormat,
		TimeFormat:TimeFormat,
		OrderNums:OrderNums,
		IfShowCASign:IfShowCASign,
		IfShowAllCY:IfShowAllCY,
		ShowOrder:ShowOrder,
		ImgName:ImgName,		
		ImgWidth:ImgWidth,
		ImgHeight:ImgHeight,
		ImgXAxis:ImgXAxis,
		ImgYAxis:ImgYAxis,
		ShowNurOrdSheet:ShowNurOrdSheet,
		DefaultSheetType:DefaultSheetType,
		tableX:tableX,
		tableY:tableY,
		rowHeight:rowHeight,
		DateTimeStyle:DateTimeStyle,
		IfGroupOrderPageFeed:IfGroupOrderPageFeed
	}
	$.cm({
		ClassName:GV._CLASSNAME,
		MethodName:"SaveConHeaderImgSet",
		saveDataJson:JSON.stringify(data),
		ImgSrc:ImgSrc,
		hospID:$HUI.combogrid('#_HospList').getValue()
	},function testget(result){
		if(result==0){
			//$.messager.popover({ msg: "����ɹ���", type:'success' });		
		}else{
			$.messager.popover({ msg: result, type:'error' });	
		}		
	})

	//��������ҽ������
	saveSpecialOrder("specialArcMastTable","0")
	saveSpecialOrder("specialArcCatTable","1")
}

//��������ҽ������
function saveSpecialOrder(tableID, type){
	$('#'+tableID).datagrid("acceptChanges");
	var rows = $('#'+tableID).datagrid('getRows')
	rows = rows.slice(0,-1)
	var ifExitNull = false
	$.each(rows,function(index,single){
		if (single.ItemDR == "" || String(single.ExecDataTime)=="" || String(single.ExecUser)=="")
		{
			ifExitNull = true
		}
	})
	if (ifExitNull)
	{
		$.messager.popover({ msg: "����ҽ����ʾ���ô������", type:'error',style: {bottom: 500,right: 500}});
		return
	}
	
	$cm({
		ClassName:GV._CLASSNAME,
		MethodName: "SaveSpecialOrder",
		saveDataJson: JSON.stringify(rows),
		hospID:$HUI.combogrid('#_HospList').getValue(),
		type : type
	}, function(rtn){
		$('#'+tableID).datagrid("reload");
	})

}

// ɾ������ҽ������
function deleteSpecialOrderRow(id){
	if ('undefined' === id || id === '' )
	{
		$.messager.popover({ msg: "δ�����¼", type:'error' });
		return
	}
	$cm({
		ClassName:GV._CLASSNAME,
		MethodName: "DeleteSpecialOrder",
		id : id
	}, function(result){
		if (result == 0){
			$.messager.popover({ msg: "����ɹ���", type:'success' });		
			$('#specialArcMastTable').datagrid("reload");
			$('#specialArcCatTable').datagrid("reload");
		}else{
			$.messager.popover({ msg: result, type:'error' });	
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


function saveSet(){
	// ��ʱҽ������
	// ��ʾ���ݼ���ͷͼƬ
	saveConHeaderImgSet();
	var flag=saveTempOrdSet("dgArcCat",0);
	console.log(flag);
	if(flag){
		var flag2=saveTempOrdSet("dgArcItm",1);
		if(flag2){			
			// ҽ�����ƺ�׺
			var rows=$("#OrdSuffixConfigTable").datagrid("getRows");
			var arr=rows.filter(function(val){
				return val.id=="";	
			})
			if(arr.length>0){
				saveOrdNameSuffixSet(arr);	
			}
			// ҽ�����ȼ�
			saveOecprSet();	
			// ҽ������ҳ����
			saveChangePageSet();
		}else{
			return $.messager.popover({ msg: "��ʾ���Ʋ�Ϊ��ʱ��ҽ�����Ϊ�գ�", type:'alert' });	
		}			
	}else{
		return $.messager.popover({ msg: "��ʾ���Ʋ�Ϊ��ʱ��ҽ�����಻��Ϊ�գ�", type:'alert' });	
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