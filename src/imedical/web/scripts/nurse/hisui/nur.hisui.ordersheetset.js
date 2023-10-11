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
//===================================================================================================================
var hospComp="",hospID = session['LOGON.HOSPID'];
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
	]
}
$(function() {
	hospComp = GenHospComp("Nur_IP_OrderSheetSet",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //��ȡ�������ֵ
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "������׼�����ֻ�ҽԺ[��Ժ]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;
		initUI(1);    	       	
	}  ///ѡ���¼�	
	
	initUI(0);
	// ҳǩ
	$HUI.tabs("#tabs",
	{
		onSelect:function(title,index){
			if(index==0){
				initOrdSheetTable("L");
				reloadOecprGrid("L");
				reloadSkipGrid("L")
			}else{
				initOrdSheetTable("T");
				reloadOecprGrid("T");
				reloadSkipGrid("T")			
			}
			reloadSuffixGrid()
		}
	});
})

function initUI(flag){
	// ������ʾ����ͷͼƬ����
	getConHeaderImgSet();
	// ҽ�����ƺ�׺
	initOrderNameSuffixTable();
	reloadSuffixGrid();	
	// ҽ��������
	var type="L";
	if(flag){
		var selectedTab = $('#tabs').tabs('getSelected'); 
		var index = $('#tabs').tabs('getTabIndex',selectedTab);
		type=index==1 ? "L" : "T";
	}
	initOrdSheetTable(type);
	reloadOecprGrid(type);
	reloadSkipGrid(type)
	// ��ʾ�ڳ���ҽ�����ϵ���ʱҽ�����ü���������
	initGridData("dgArcCat","TempOrd",0);
	initGridData("dgArcItm","TempOrd",1);
	initGridData("dgOrderCat","Shield",0);
	initGridData("dgArcCat2","Shield",1);
	initGridData("dgLoc","Shield",2);	
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
}

// ������ʾ����ͷͼƬ����
function getConHeaderImgSet(){
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
		$("#orderNums").numberbox("setValue",data.OrderNums);
		var IfShowCASign=data.IfShowCASign=="Y" ? true : false;
		$("#switch3").switchbox("setValue",IfShowCASign);
		var IfShowAllCY=data.IfShowAllCY=="Y" ? true : false;
		$("#switch4").switchbox("setValue",IfShowAllCY);
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
	}) 
}
function saveConHeaderImgSet(){
	var IfShowCancelTempOrder=$("#switch").switchbox('getValue') ? "Y" : "N";
	var CancelOrderShowText=$.trim($("#undo-name").val());
	var IfShowGroupFlag=$("#switch2").switchbox('getValue') ? "Y" : "N";
	var DateFormat=$("#date-format").combobox("getValue");
	var TimeFormat=$("#time-format").combobox("getValue");
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

// ҽ�����ƺ�׺����
var editSuffixIndex;
function initOrderNameSuffixTable(){
	$("#dg").datagrid({
		columns :[[
			{field:'sequence',title:'˳��',width:40},
	    	{field:'desc',title:'ҽ�����ƺ�׺',width:100}, 
	    	{field:'code',title:'����',width:150}, 
	        {field:'active',title:'�Ƿ�����',width:80,formatter:function(value,row,index){
		    	return value=="Y" ? "��" : "��";	
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}}		       	       
		]],
		singleSelect : true,
		loadMsg : '������..',
		onClickRow:function(rowIndex,rowData){
			if((editSuffixIndex!=undefined)&&(editSuffixIndex!=rowIndex)) $('#dg').datagrid("endEdit",editSuffixIndex);
			editSuffixIndex=rowIndex;
			$('#dg').datagrid("beginEdit",editSuffixIndex);
			var ed = $('#dg').datagrid('getEditor', {index:editSuffixIndex,field:'active'});
			$(ed.target).checkbox({
				checked:rowData.active=="Y" ? true : false,
				onCheckChange:function(e,value){
					var arr=[];
					rowData.active=value ? "Y" : "N";
					arr.push(rowData);
					saveOrdNameSuffixSet(arr);
				}
			});
		},
		onLoadSuccess:function(){
			$(this).datagrid('enableDnd');
		},
		onDrop:function(targetRow,sourceRow,point){
			var rows=$(this).datagrid("getRows");
			for(var i=0;i<rows.length;i++){
				rows[i].sequence=i+1;	
			}
			saveOrdNameSuffixSet(rows);
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
	var type = $('#tabs').tabs('getTabIndex',selectedTab) == 1 ? "L":"T";
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
			$("#dg").datagrid("loadData",newData);		
		}else{
			$("#dg").datagrid("loadData",orderNameSuffix);
		}		
	})	
}
function saveOrdNameSuffixSet(data){
	var selectedTab = $('#tabs').tabs('getSelected'); 
	var type = $('#tabs').tabs('getTabIndex',selectedTab) == 1 ? "L":"T";
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
// ����
function sortRule(field){
	return function(a,b){
		return a[field]-b[field];	
	}
}

// ҽ�����ȼ�
var savedOecpr=[];
function getSavedOecpr(type){	
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
function reloadOecprGrid(type){
	getSavedOecpr(type); 
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetConfig",
		QueryName:"GetOecpr",
		rows:99999
	},function(data){
		$("#dgOecpr"+type).datagrid('loadData',data); 
		$("#dgOecpr"+type).datagrid("unselectAll");	
		if(savedOecpr.length>0){
			savedOecpr.forEach(function(val){
				$("#dgOecpr"+type).datagrid("selectRecord",val);	
			});	
		}
	}) 
}
function saveOecprSet(){
	var tab = $('#tabs .tabs-selected .tabs-title').html();
	var type = tab=="����ҽ����" ? "L" : "T";
	var rows=$("#dgOecpr"+type).datagrid("getSelections");
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
		var tab = $('#tabs .tabs-selected .tabs-title').html();
		var type = tab=="����ҽ����" ? "L" : "T";
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
// ҽ������ҳ��������
function reloadSkipGrid(type){
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
				$("#dgSkip"+type).datagrid("loadData",newData);
			}else{
				$("#dgSkip"+type).datagrid("loadData",data);
			}			
		}else{
			var newData=type=="L" ? GV.changePageList : GV.changePageList.slice(0,3)
			$("#dgSkip"+type).datagrid("loadData",newData);
		}		
	}) 	
}
// ҽ������ҳ�������ý����༭
function endSkipEdit(type,rowData){
	var ed=$('#dgSkip'+type).datagrid('getEditor', {index:editSkipIndex,field:'name'});
	var ed2=$('#dgSkip'+type).datagrid('getEditor', {index:editSkipIndex,field:'arcItmDesc'});
	var ed3=$('#dgSkip'+type).datagrid('getEditor', {index:editSkipIndex,field:'skipFlag'});
	var ed4=$('#dgSkip'+type).datagrid('getEditor', {index:editSkipIndex,field:'scribingFlag'});
	var name=$.trim($(ed.target).val());
	var arcItmDR=$(ed2.target).combogrid("getValue");
	var arcItmDesc=$(ed2.target).combogrid("getText");
	var skipFlag=$(ed3.target).radio('getValue') ? "Y" : "N";
	var scribingFlag=$(ed4.target).radio('getValue') ? "Y" : "N";
	$('#dgSkip'+type).datagrid("endEdit",editSkipIndex);
	$('#dgSkip'+type).datagrid('updateRow',{
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
	var tab = $('#tabs .tabs-selected .tabs-title').html();
	var type = tab=="����ҽ����" ? "L" : "T";
	if(editSkipIndex!=undefined){
		var row=$("#dgSkip"+type).datagrid("getSelections");
		endSkipEdit(type,row[0]);	
	}	
	var data=$("#dgSkip"+type).datagrid("getRows");
	$.cm({
		ClassName:GV._CLASSNAME,
		MethodName:"SaveChangePageSet",
		saveDataJson:JSON.stringify(data),
		hospID:$HUI.combogrid('#_HospList').getValue(),
		type:type
	},function testget(result){
		if(result==0){
			$.messager.popover({ msg: "����ɹ���", type:'success' });	
			reloadSkipGrid(type);	
			editSkipIndex=undefined;
		}else{
			$.messager.popover({ msg: result, type:'error' });	
		}		
	})	
}

// ҽ��������
var editSkipIndex,editTable;
function initOrdSheetTable(type){
	// ҽ�����ȼ�
	$('#dgOecpr'+type).datagrid({fit:true,fitColumns:true,idField:"ID",frozenColumns:[[{field:'ck',title:'ck',checkbox:true}]],columns :[[{field:'Desc',title:'ҽ�����ȼ�',width:160}]]});	
	// ҽ������ҳ��������
	$("#dgSkip"+type).datagrid({
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
				var rows=$('#dgSkip'+type).datagrid("getRows");
				endSkipEdit(type,rows[editSkipIndex]);
			}
			editSkipIndex=rowIndex;
			$('#dgSkip'+type).datagrid("beginEdit",editSkipIndex);
			var ed = $('#dgSkip'+type).datagrid('getEditor', {index:editSkipIndex,field:'arcItmDesc'});
			var ed2 = $('#dgSkip'+type).datagrid('getEditor', {index:editSkipIndex,field:'skipFlag'});
			if(rowData.item=="��������"){
				$(ed.target).combogrid("disable");
				$(ed2.target).checkbox("disable");
			}else{
				var obj=$(ed.target)
				getArcItmList(obj,rowData.arcItmDR,rowData.arcItmDesc,"180");	
			}
		}	
	})		
}
// ��ʼ������ҽ�����ϵ���ʱҽ������
var editArcCatIndex,editArcItmIndex,editOrdCatIndex,editArcCatIndex2,editLocIndex;
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
		nameCol={field:'',title:'',hidden:true}; 
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
		                    }
                        }
                        else {
	                        var editIndex;
	                        if(tableID=="dgArcCat") editIndex=editArcCatIndex;
		       				if(tableID=="dgArcItm") editIndex=editArcItmIndex;
	                        if(tableID=="dgOrderCat") editIndex=editOrdCatIndex;
		       				if(tableID=="dgArcCat2") editIndex=editArcCatIndex2;
		       				if(tableID=="dgLoc") editIndex=editLocIndex;
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
                titleDesc: '���εĿ���',
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
        case 'dgArcItm':
            obj = {
                combogrid: {
                    getMethod: 'getArcim',
                    valueField: 'id',
                    textField: 'desc',
                },
                fieldName: 'desc',
                titleDesc: 'ҽ����',
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
   		btns = '<a class="btnCls icon-cancel" href="#" onclick=delData(\'' + row.id + '\',\'' + tableID + '\')></a>'
    	return btns;	
	}    
}
function delData(rowid,tableID){
	var type;
	if(tableID=="dgArcCat" || tableID=="dgOrderCat") type=0;
	if(tableID=="dgArcItm" || tableID=="dgArcCat2") type=1;
	if(tableID=="dgLoc") type=2
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
	})
}

// ��������
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
			var rows=$("#dg").datagrid("getRows");
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