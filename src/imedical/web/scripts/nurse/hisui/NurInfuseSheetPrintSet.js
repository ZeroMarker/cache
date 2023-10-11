/**
* @author songchunli
* HISUI ��Һ����ӡ����
*/
var PageLogicObj={
	InfuseSheetTableObj:{"tableID":"tabInfuseSheetTableSet","InitedFlag":"N",NeedRefreshData:"Y",EditRow:undefined,"OrdSheetTable":"OrderInfo"},
	InfuseSheetContentSetObj:{
		"tableID":"tabInfuseSheetContentSet","InitedFlag":"N","Default":{
			Font:"Song",
			FontSize:"10",
			Align:"AlignLeft",
			Bold:"Normal",
			Italic:"Normal"
	 	}
	 	,NeedRefreshData:"Y"
	 },	 
	SheetConfigJson:[],
	SheetPrtObj:{"NeedRefreshData":"Y"}
}
$(function(){
	InitSheet();
	InitEvent();
});
$(window).load(function() {
	$("#loading").hide();
})
function HospChange(){
	ClearConfigData()
	$('#tabPrtSheet').datagrid("reload");
}
function InitEvent(){
	$("#config-accordion").accordion({
		onSelect:function(title,index){
			var sheetRowId=GetSelPrtSheetTypeRowId();
			if (sheetRowId !="") {
				refreshContentData();
			}
		}
	})
	$("#Save").click(SaveConfig);
	$("#Preview").click(showSheetPreviewWin);
	$(window).resize(function() {
		ResizeTablePanel();
	})
	ResizeTablePanel();
}
function refreshContentData(){
	if (PageLogicObj.InfuseSheetTableObj.InitedFlag =="N"){
		InitInfuseSheetTableGrid();
		LoadInfuseTableData();
		$.extend(PageLogicObj.InfuseSheetTableObj, {InitedFlag:"Y",NeedRefreshData:"N"});
	}else if(PageLogicObj.InfuseSheetTableObj.NeedRefreshData =="Y"){
		LoadInfuseTableData();
		if (PageLogicObj.InfuseSheetContentSetObj.InitedFlag =="Y"){
			$('#'+PageLogicObj.InfuseSheetContentSetObj.tableID).datagrid("unselectAll").datagrid('loadData',{"rows":[],"total":0});
		}
	}
	function LoadInfuseTableData(){
		$('#'+PageLogicObj.InfuseSheetTableObj.tableID).datagrid("unselectAll").datagrid('loadData',PageLogicObj.SheetConfigJson.InfuseTableConfig);
	}
	if (PageLogicObj.SheetPrtObj.NeedRefreshData =="Y"){
		var SheetPrtConfigObj=PageLogicObj.SheetConfigJson.SheetPrtConfig;
		$.each(SheetPrtConfigObj,function(id,val){
			var _$id=$("#"+id);
			if (_$id.length >0){
				if (_$id.next().hasClass('combo')){
					_$id.combobox("select",val);
				}else if(_$id.hasClass('checkbox-f')){
					_$id.checkbox("setValue",val=="Y"?true:false);
				}else if(_$id.hasClass('numberbox')){
					_$id.numberbox('setValue',val);
				}else if(_$id.hasClass("hisui-switchbox")){
					_$id.switchbox("setValue",val=="Y"?true:false);
				}else{
					_$id.val(val);
				}
			}
	����});
	}
	$.extend(PageLogicObj.SheetPrtObj, {NeedRefreshData:"N"});
}
function ClearConfigData(){
	PageLogicObj.SheetConfigJson=[];
	if (PageLogicObj.InfuseSheetTableObj.InitedFlag =="Y"){
		$('#'+PageLogicObj.InfuseSheetTableObj.tableID).datagrid("unselectAll").datagrid('loadData',{"rows":[],"total":0});
	}
	if (PageLogicObj.InfuseSheetContentSetObj.InitedFlag =="Y"){
		$('#'+PageLogicObj.InfuseSheetContentSetObj.tableID).datagrid("unselectAll").datagrid('loadData',{"rows":[],"total":0});
	}
	var _$input=$(".prtconfig-table tr td:not(.r-label) > input");
	for (var i=0;i<_$input.length;i++){
		var id=_$input[i].id;
		if (!id) continue;
		var _$id=$("#"+id);
		_$id.val('');
	}
	$("#SPSPrintPreview").switchbox("setValue",false);
}
function PrtSheetChange(){
	PageLogicObj.InfuseSheetTableObj.EditRow =undefined;
	ClearConfigData();
	PageLogicObj.SheetConfigJson=$.cm({ 
		ClassName:"Nur.NIS.Service.OrderExcute.SheetPrintConfig", 
		MethodName:"GetSheetPrtContentSetJson",
		sheetRowId:GetSelPrtSheetTypeRowId()
	},false);
	var NeedRefreshDataObj={NeedRefreshData:"Y"};
	$.extend(PageLogicObj.InfuseSheetTableObj, NeedRefreshDataObj);
	$.extend(PageLogicObj.InfuseSheetContentSetObj, NeedRefreshDataObj);
	$.extend(PageLogicObj.SheetPrtObj, NeedRefreshDataObj);	
	refreshContentData();
}
function InitInfuseSheetTableGrid(){
	var ToolBar = [{
		text: '����',
		iconCls: '	icon-add',
		handler: function() {
			var SheetID=GetSelPrtSheetTypeRowId();
			if (!SheetID) {
				$.messager.popover({msg: '����ѡ����Ч����!',type: 'error'});
				return false;
			}
			if (PageLogicObj.InfuseSheetTableObj.EditRow !=undefined){
				$.messager.popover({msg: '�����ڱ༭����,���ȱ���!',type: 'error'});
				return false;
			}
			var tabId=PageLogicObj.InfuseSheetTableObj.tableID;
			var maxRow=$("#"+tabId).datagrid("getRows");
			$("#"+tabId).datagrid("appendRow", {
				Index:maxRow,
                ID: ''
            })
            PageLogicObj.InfuseSheetTableObj.EditRow=maxRow.length-1;
            $("#"+tabId).datagrid("beginEdit", PageLogicObj.InfuseSheetTableObj.EditRow).datagrid("selectRow",PageLogicObj.InfuseSheetTableObj.EditRow);
		}
	},{
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
				var tabId=PageLogicObj.InfuseSheetTableObj.tableID;
				var rows = $("#"+tabId).datagrid("getSelected");
				if (rows) {
					$.messager.confirm("��ʾ", "ȷ��Ҫɾ����?",
	                function(r) {
	                    if (r) {
		                    var ISPSID=rows.ID;
		                    if (ISPSID) {
			                    var value=$.m({ 
									ClassName:"Nur.NIS.Service.OrderExcute.SheetPrintConfig", 
									MethodName:"DelInfuseSheetPrtTab",
									event:"DELETE",
									ISPSID:ISPSID
								},false);
								if(value=="0"){
								   $("#"+tabId).datagrid("unselectAll").datagrid("deleteRow",$("#"+tabId).datagrid("getRowIndex",ISPSID));
								   ClearInfuseSheetContentData();
								   PageLogicObj.InfuseSheetTableObj.EditRow=undefined;
		   					       $.messager.popover({msg: 'ɾ���ɹ�!',type: 'success'});
						        }else{
							       $.messager.popover({msg: 'ɾ��ʧ��:'+value,type: 'error'});
						        }
			                }else{
				                $("#"+tabId).datagrid("deleteRow",PageLogicObj.InfuseSheetTableObj.EditRow);
				                ClearInfuseSheetContentData();
				                PageLogicObj.InfuseSheetTableObj.EditRow=undefined;
				            }
	                    }
	                });
				}else{
					$.messager.popover({msg: '��ѡ��Ҫɾ������!',type: 'error'});
				}
		}
    },'-',{
        id:'tip',
		iconCls: 'icon-help',
		handler: function(){
			$("#tip").popover('show');
		}
    }];		
	var ISPSTableTypeFieldObj={ field: 'ISPSTableType', title: '�������',width:160,editor :{
					type:'combobox',  
					options:{
						mode:"local",
						editable:false,
						rowStyle:'checkbox',
						valueField:'value',
						textField:'text',
						data:ServerObj.ISPSTableTypeJson,
						required:true,
						onSelect:function(rec){
							var ISPSTableRowsObj=$("#"+PageLogicObj.InfuseSheetTableObj.tableID).datagrid('getEditor', {index:PageLogicObj.InfuseSheetTableObj.EditRow,field:'ISPSTableRows'});
							if ((rec)&&(rec.value ==PageLogicObj.InfuseSheetTableObj.OrdSheetTable)){
								$(ISPSTableRowsObj.target[0]).removeAttr("disabled");
							}else{
								ISPSTableRowsObj.target[0].value="";
								$(ISPSTableRowsObj.target[0]).attr("disabled","disabled");
							}
							InfuseSheetTableClick();
						}
					 }
				},
				formatter: function(value,row,index){
					return row.ISPSTableTypeDesc;
				}	
			};
	var ISPSTableHeightFieldObj={ field: 'ISPSTableHeight', title: '�и�(mm)',width:80,editor :
				{type : 'numberbox',options:{required:true}}
			};
	var ISPSTableRowsFieldObj={ field: 'ISPSTableRows', title: '����',width:60,editor :
				{type : 'numberbox'}
			};
	var Columns=[],Column=[];
		Column.push(ISPSTableTypeFieldObj);
		Column.push(ISPSTableHeightFieldObj);
		Column.push(ISPSTableRowsFieldObj);
	Columns.push(Column); 
	$('#'+PageLogicObj.InfuseSheetTableObj.tableID).datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : true,
		idField:"ID",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*�˴�Ϊfalse*/
		onDblClickRow:function(rowIndex, rowData){ 
			if (PageLogicObj.InfuseSheetTableObj.EditRow !=undefined){
				$.messager.popover({msg: '�����ڱ༭����,���ȱ���!',type: 'error'});
				return false;
			}
			$('#'+PageLogicObj.InfuseSheetTableObj.tableID).datagrid("beginEdit", rowIndex);
			PageLogicObj.InfuseSheetTableObj.EditRow =rowIndex;
			var ISPSTableRowsObj=$("#"+PageLogicObj.InfuseSheetTableObj.tableID).datagrid('getEditor', {index:PageLogicObj.InfuseSheetTableObj.EditRow,field:'ISPSTableRows'});
			if ((rowData.ISPSTableType)&&(rowData.ISPSTableType ==PageLogicObj.InfuseSheetTableObj.OrdSheetTable)){
				$(ISPSTableRowsObj.target[0]).removeAttr("disabled");
			}else{
				ISPSTableRowsObj.target[0].value="";
				$(ISPSTableRowsObj.target[0]).attr("disabled","disabled");
			}
							
       },
       onSelect:function(rowIndex, rowData){
	       InfuseSheetTableClick();	       
	   },
	   onBeforeSelect:function(rowIndex,rowData){
		   if ((PageLogicObj.InfuseSheetTableObj.EditRow !=undefined)&&(PageLogicObj.InfuseSheetTableObj.EditRow !=rowIndex)){
				$.messager.popover({msg: '�����ڱ༭����,���ȱ���!',type: 'error'});
				return false;
		   }
	   }
	})
	InitTip();
}
function ClearInfuseSheetContentData(){
   if (PageLogicObj.InfuseSheetContentSetObj.InitedFlag =="Y"){
	  $('#'+PageLogicObj.InfuseSheetContentSetObj.tableID).datagrid("unselectAll").datagrid('loadData',{"rows":[],"total":0});
   }
}
function InitInfuseSheetContentGrid(){
	PageLogicObj.InfuseSheetContentSetObj.InitedFlag="Y";
	var ToolBar = [{
		text: '����',
		iconCls: '	icon-add',
		handler: function() {
			var SheetID=GetSelPrtSheetTypeRowId();
			if (!SheetID) {
				$.messager.popover({msg: '����ѡ����Ч����!',type: 'error'});
				return false;
			}
			var selected=$("#"+PageLogicObj.InfuseSheetTableObj.tableID).datagrid("getSelected");
			if ((!selected)&&(PageLogicObj.InfuseSheetTableObj.EditRow)){
				var selected=$("#"+PageLogicObj.InfuseSheetTableObj.tableID).datagrid("selectRow",PageLogicObj.InfuseSheetTableObj.EditRow).datagrid("getSelected");
			}
			if (!selected){
				$.messager.popover({msg: '����ѡ���������У�',type: 'error'});
				return false;
			}
			var tabId=PageLogicObj.InfuseSheetContentSetObj.tableID;
			var maxRow=$("#"+tabId).datagrid("getRows");
			$("#"+tabId).datagrid("appendRow", {
				Index:maxRow,
                ID: '',
                SPCSBold: PageLogicObj.InfuseSheetContentSetObj.Default.Bold,
                SPCSItalic: PageLogicObj.InfuseSheetContentSetObj.Default.Italic,
                SPCSAlign: PageLogicObj.InfuseSheetContentSetObj.Default.Align,
                SPCSFont:PageLogicObj.InfuseSheetContentSetObj.Default.Font,
                SPCSFontSize:PageLogicObj.InfuseSheetContentSetObj.Default.FontSize
            })
            $("#"+tabId).datagrid("beginEdit", maxRow.length-1);
		}
	},{
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var tabId=PageLogicObj.InfuseSheetContentSetObj.tableID;
			var rows = $("#"+tabId).datagrid("getSelections");
			if (rows.length > 0) {
				$.messager.confirm("��ʾ", "ȷ��Ҫɾ����?",
                function(r) {
                    if (r) {
	                    var delDataArr=[],delIndexArr=[];
                        for (var i = 0; i < rows.length; i++) {
                            var SPCSID=rows[i].ID;
                            if (SPCSID) {
	                            delDataArr.push(SPCSID)
	                        }
		                    delIndexArr.push($("#"+tabId).datagrid("getRowIndex",rows[i].Index));
                        }
                        var value=$.m({ 
							ClassName:"Nur.NIS.Service.OrderExcute.SheetPrintConfig", 
							MethodName:"HandleSheetContent",
							event:"DELETE",
							dataArr:JSON.stringify(delDataArr)
						},false);
				        if(value=="0"){
					       for (var i = delIndexArr.length-1; i >=0; i--) {
						       $("#"+tabId).datagrid("deleteRow",delIndexArr[i]);
						   }
   					       $.messager.popover({msg: 'ɾ���ɹ�!',type: 'success'});
				        }else{
					       $.messager.popover({msg: 'ɾ��ʧ��:'+value,type: 'error'});
				        }
                    }
                });
			}else{
				$.messager.popover({msg: '��ѡ��Ҫɾ������!',type: 'error'});
			}
		}
    }];	
    var DescFieldObj={ field: 'SPCSDesc', title: '����',width:140, editor : 
						{type : 'text',options : {required:true}}
			         };
	var ContentFieldObj={ field: 'SPCSContent', title: '����',width:160,editor :
							{type : 'text'}
						};
	var WidthFieldObj={ field: 'SPCSWidth', title: '�п�(mm)',width:80,editor :
				{type : 'numberbox',options : {required:true}}
			};

	var DataBindItemFieldObj={ field: 'SPCSDataBindItem', title: '����������Ŀ',width:160,editor :{
					type:'combobox',  
					options:{
						mode:"local",
						multiple:true,
						//editable:false,
						panelHeight:220,
						defaultFilter:6,
						rowStyle:"checkbox",
						url:$URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetNurseBasicDataList&filter=1&rows=99999",
						valueField:'RowID',
						textField:'NBDName',
						loadFilter: function(data){
							return data['rows'];
						},
						onBeforeLoad:function(param){
							var ISPSTableType=GetISPSTableType();
							if (ISPSTableType =="OrderInfo") {
								var DataBindItemSearchType="1^2^3";
							}else{
								var DataBindItemSearchType="0^3";
							}
							$.extend(param, {
								searchType:DataBindItemSearchType,
								searchName:param["q"]
							});
						}
					}
				},
				formatter: function(value,row,index){
					return row.SPCSDataBindItemDesc;
				}	
			};
	var FontFieldObj={ field: 'SPCSFont', title: '����',width:70,editor :{
					type:'combobox',  
					options:{
						mode:"local",
						valueField:'value',
						textField:'text',
						editable:false,
						required:true,
						data:ServerObj.FontJson
					 }
				},
				formatter: function(value,row,index){
					return row.SPCSFontDesc;
				}
			};
	var FontSizeFieldObj={ field: 'SPCSFontSize', title: '�ֺ�(��)',width:70,editor :
				{type : 'numberbox',options : {required:true}}
			};
	var AlignFieldObj={ field: 'SPCSAlign', title: '���뷽ʽ',width:80,editor :{
					type:'combobox',  
					options:{
						mode:"local",
						valueField:'value',
						textField:'text',
						editable:false,
						data:ServerObj.AlignJson
					 }
				},
				formatter: function(value,row,index){
					return row.SPCSAlignDesc;
				}
			};
	var MarginLeftFieldObj={ field: 'SPCSMarginLeft', title: '������߾�(mm)',width:115,editor :
				{type : 'numberbox'}
			};
	var MarginTopFieldObj={ field: 'SPCSMarginTop', title: '�����ϼ��(mm)',width:115,editor :
				{type : 'numberbox'}
			};
	var BoldFieldObj={ field: 'SPCSBold', title: '�Ӵ�����',width:80,editor :{
					type:'combobox',  
					options:{
						mode:"local",
						editable:false,
						valueField:'value',
						textField:'text',
						data:ServerObj.BoldJson
					 }
				},
				formatter: function(value,row,index){
					return row.SPCSBoldDesc;
				}
			};
	var DisplaySubOrdFieldObj={ field: 'SPCSDisplaySubOrd', title: '�Ƿ���ʾ��ҽ��',align:'center',width:160, editor : 
				{
					type : 'icheckbox',options:{on:'Y',off:'N'}
				},
				formatter: function(value,row,index){
					return row.SPCSDisplaySubOrdDesc;
				}
			};
	var ItalicFieldObj={ field: 'SPCSItalic', title: '�Ƿ�б��',width:80,editor :{
					type:'combobox',  
					options:{
						mode:"local",
						editable:false,
						valueField:'value',
						textField:'text',
						data:ServerObj.ItalicJson
					 }
				},
				formatter: function(value,row,index){
					return row.SPCSItalicDesc;
				}
			};
			
	var Columns=[],Column=[];
		Column.push(DescFieldObj);
	    Column.push(ContentFieldObj);
	    Column.push(DataBindItemFieldObj);
	    Column.push(FontFieldObj);
	    Column.push(FontSizeFieldObj);
	    Column.push(WidthFieldObj);
	    Column.push(AlignFieldObj);
	    Column.push(MarginLeftFieldObj);
	    Column.push(MarginTopFieldObj);
	    Column.push(BoldFieldObj);
	    Column.push(ItalicFieldObj);
	    Column.push(DisplaySubOrdFieldObj);
	Columns.push(Column);
	$('#'+PageLogicObj.InfuseSheetContentSetObj.tableID).datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : true,
		idField:"Index",
		columns :Columns,
		toolbar :ToolBar,
		nowrap:false,  /*�˴�Ϊfalse*/
		onDblClickRow:function(rowIndex, rowData){ 
			$('#'+PageLogicObj.InfuseSheetContentSetObj.tableID).datagrid("beginEdit", rowIndex);
       }
	})
}
function SaveConfig(){
	var saveDataArr=[],ErrMsgArr=[];
	var reg = /^[+]{0,1}(\d+)$/;
	var reg1 = /^[0-9]*[1-9][0-9]*$/;
	var SheetID=GetSelPrtSheetTypeRowId();
	if (!SheetID) {
		$.messager.popover({msg: '����ѡ����Ч����!',type: 'error'});
		return false;
	}
	if (PageLogicObj.InfuseSheetTableObj.InitedFlag =="N") {
		$.messager.popover({msg: 'û����Ҫ��������ݣ�',type: 'error'});
		return false;
	}
	var selected=$("#"+PageLogicObj.InfuseSheetTableObj.tableID).datagrid("getSelected");
	var NullValColumnArr=[],NotValidateColumnArr=[],NotTogetherNullColumnArr=[];
	if (selected){
		var ISPSID=selected.ID;		
		var InfuseSheetTableArr=[];
		InfuseSheetTableArr.push({"field":"ID","fieldValue":ISPSID});
		var editors=$('#'+PageLogicObj.InfuseSheetTableObj.tableID).datagrid('getEditors',PageLogicObj.InfuseSheetTableObj.EditRow);
		if (editors.length >0){
			for (var k=0;k<editors.length;k++){
				var field=editors[k].field;
				var fieldType=editors[k].type;
				if (fieldType =="combobox"){
					var comOpts=editors[k].target.combobox("options");
					if (comOpts.multiple){
						var value=editors[k].target.combobox('getValues').join(",");
					}else{
						var value=editors[k].target.combobox('getValue');
					}						
				}else if(fieldType =="numberbox"){
					var value=editors[k].target.numberbox('getValue');
				}else {
					var value=editors[k].target.val();
				}
				value=$.trim(value);
				if (field ==PageLogicObj.InfuseSheetTableObj.OrdSheetTable) {
					var ISPSTableRows=$.trim(editors[2].target.numberbox('getValue'));
					if (!ISPSTableRows){
						$.messager.popover({msg: '�������Ϊҽ����Ϣ��ʱ,�������',type: 'error'});
						return false;
					}
				}
				var fieldOpts = $('#'+PageLogicObj.InfuseSheetTableObj.tableID).datagrid('getColumnOption',field);
				if (fieldOpts.editor.options){
					if ((fieldOpts.editor.options.required)&&(!value)){
						NullValColumnArr.push(fieldOpts.title);
					}
				}
				if ((value)&&(fieldType =="numberbox")&&(!reg1.test(value))){
					NotValidateColumnArr.push(fieldOpts.title);
				}
				InfuseSheetTableArr.push({"field":field,"fieldValue":value});
			}
			var tableRows=$('#'+PageLogicObj.InfuseSheetTableObj.tableID).datagrid('getRows');
			var InfuseSheetTableIndex=$.hisui.indexOfArray(InfuseSheetTableArr,"field","ISPSTableType");
			var TableTypeIndex=$.hisui.indexOfArray(tableRows,"ISPSTableType",InfuseSheetTableArr[InfuseSheetTableIndex].fieldValue);
			if ((TableTypeIndex >=0)&&(TableTypeIndex!=PageLogicObj.InfuseSheetTableObj.EditRow)){
				$.messager.popover({msg: "�������: "+tableRows[TableTypeIndex].ISPSTableTypeDesc+"�Ѵ��ڣ�",type: 'error'});
				return false;
			}
		}
		if (NotValidateColumnArr.length>0){
			ErrMsgArr.push("<span style='color:red;'>�������</span>��"+NotValidateColumnArr.join("��")+"���������0����������");
			NotValidateColumnArr=[];
		}
		if (NullValColumnArr.length>0){
			ErrMsgArr.push("<span style='color:red;'>�������</span>��"+NullValColumnArr.join("��")+"����Ϊ�գ�");
			NullValColumnArr=[];
		}
		var saveInfuseSheetTableArr=[];
		saveInfuseSheetTableArr.push(InfuseSheetTableArr);
		saveDataArr.push({"SheetTableType":"InfuseSheetTableConfigData","SheetID":SheetID,"SheetTableConfigData":JSON.stringify(saveInfuseSheetTableArr)});
		
		//��ȡ��Ҫ�������������
		var ISPSTableType=GetISPSTableType();	
		if (ISPSTableType=="OrderInfo") {
			var NotTogetherNullColumnConfigArr=[{"SPCSContent":""}];
		}else{
			var NotTogetherNullColumnConfigArr=[{"SPCSContent":"","SPCSDataBindItem":""}];
		}
		var tableDataArr=[];
		var tableID=PageLogicObj.InfuseSheetContentSetObj.tableID;
		var rows=$("#"+tableID).datagrid("getRows");
		for (var j=0;j<rows.length;j++){
			var editors=$('#'+tableID).datagrid('getEditors',j);
			if (editors.length ==0) continue;
			var rowDataArr=[];
			for (var k=0;k<editors.length;k++){
				var field=editors[k].field;
				var fieldOpts = $('#'+tableID).datagrid('getColumnOption',field);
				if (fieldOpts.hidden) {
					rowDataArr.push({"field":field,"fieldValue":""});
				}else{
					var fieldTitle=$($("."+fieldOpts.cellClass)[0])[0].innerText || fieldOpts.title;
					var fieldType=editors[k].type;
					if (fieldType =="combobox"){
						var comOpts=editors[k].target.combobox("options");
						if (comOpts.multiple){
							var value=editors[k].target.combobox('getValues').join(",");
						}else{
							var value=editors[k].target.combobox('getValue');
						}						
					}else if(fieldType =="icheckbox"){
						var value=editors[k].target.checkbox('getValue')?"Y":"N";
					}else if(fieldType =="numberbox"){
						var value=editors[k].target.numberbox('getValue');
					}else {
						var value=editors[k].target.val();
					}
					value=$.trim(value);
					if (fieldOpts.editor.options){
						if ((fieldOpts.editor.options.required)&&(!value)){
							NullValColumnArr.push("��"+(j+1)+"��"+fieldTitle);
						}
					}
					if ((value)&&(fieldType =="numberbox")&&(!reg.test(value))){
						NotValidateColumnArr.push("��"+(j+1)+"��"+fieldTitle);
					}
					rowDataArr.push({"field":field,"fieldValue":value});
					for (var l=0;l<NotTogetherNullColumnConfigArr.length;l++){
						for (elem in NotTogetherNullColumnConfigArr[l]){
							if (elem == field) {
								if (NotTogetherNullColumnArr[j+1]) {
									$.extend(NotTogetherNullColumnArr[j+1],{"title":NotTogetherNullColumnArr[j+1]["title"]+"��"+fieldTitle});
								}else{
									NotTogetherNullColumnArr[j+1]={"title":fieldTitle};
								}
								NotTogetherNullColumnArr[j+1][field]=value;
							}
						}
					}
				}
			}
			if (rowDataArr.length>0){
				var SPCSID=rows[j].ID;
				if (!SPCSID) SPCSID="";
				rowDataArr.push({"field":"ID","fieldValue":SPCSID});
				rowDataArr.push({"field":"SPCSInfuseSheetTabDR","fieldValue":ISPSID});
				tableDataArr.push(rowDataArr);
			}
		}
		if (tableDataArr.length>0){
			saveDataArr.push({"SheetTableType":"","SPCSInfuseSheetTabDR":ISPSID,"SheetID":SheetID,"SheetTableConfigData":JSON.stringify(tableDataArr)});
		}
		var OneTableErrMsg="";
		if (NullValColumnArr.length>0){
			OneTableErrMsg=NullValColumnArr.join("��")+"����Ϊ�գ�";
			NullValColumnArr=[];
		}
		if (NotTogetherNullColumnArr.length>0){
			if (!Object.values){
				Object.values = function(obj){
					return Object.keys(obj).map(function(e){
						return obj[e];
					})
				}
			}
			for (RowIndex in NotTogetherNullColumnArr){
				var ItemObj=NotTogetherNullColumnArr[RowIndex]
				var title=ItemObj.title;
				delete ItemObj.title
				var filterArr=Object.values(ItemObj).filter(function(item){
					if (item !="") return true;
				})
				if (filterArr.length ==0) {
					if (title.split("��").length==1){
						OneTableErrMsg += title+"����Ϊ�գ�"
					}else{
						OneTableErrMsg += title+"����ͬʱΪ�գ�"
					}
				}
			}
		}
		if (NotValidateColumnArr.length>0){
			OneTableErrMsg+=NotValidateColumnArr.join("��")+"��������ڵ���0����������"
			NotValidateColumnArr=[];
		}
		if (OneTableErrMsg){
			ErrMsgArr.push("<span style='color:red;'>��������</span>��"+OneTableErrMsg);
		}
	}
	//��ȡ��ӡ��������
	var NotValidatePrtConfigArr=[];
	var savePrtConfigDataArr=[],PrtConfigDataArr=[];
	var _$input=$(".prtconfig-table tr td:not(.r-label) > input");
	for (var i=0;i<_$input.length;i++){
		var id=_$input[i].id;
		if (!id) continue;
		var _$id=$("#"+id);
		if (_$id.next().hasClass('combo')){
			var value=_$id.combobox("getValue");
		}else if(_$id.hasClass('checkbox-f')){
			var value=_$id.checkbox("getValue")?"Y":"N";
		}else if(_$id.hasClass('numberbox')){
			var value=_$id.numberbox('getValue');
			if ((value)&&(!reg1.test(value))){
				NotValidatePrtConfigArr.push($('label[for="' + id + '"]')[0].innerHTML);
			}
		}else{
			var value=$.trim(_$id.val());
		}
		PrtConfigDataArr.push({"field":id,"fieldValue":value});
	}
	var _$div=$(".prtconfig-table tr td:not(.r-label) > div");
	for (var i=0;i<_$div.length;i++){
		var id=_$div[i].id;
		if (!id) continue;
		var _$id=$("#"+id);
		if(_$id.hasClass("hisui-switchbox")){
			var value=_$id.switchbox("getValue")?"Y":"N";
		}
		PrtConfigDataArr.push({"field":id,"fieldValue":value});
	}
		
	var SPSPrintSignDR=$("#SheetPrintSign").combobox("getValue");
	PrtConfigDataArr.push({"field":"SPSPrintSignDR","fieldValue":SPSPrintSignDR});
	savePrtConfigDataArr.push(PrtConfigDataArr)
	saveDataArr.push({"SheetTableType":"SheetPrtConfigData","SheetID":SheetID,"SheetTableConfigData":JSON.stringify(savePrtConfigDataArr)});
		
	if (NotValidatePrtConfigArr.length>0){
		ErrMsgArr.push("<span style='color:red;'>��ӡ����</span>��"+NotValidatePrtConfigArr.join("��")+"���������0����������");
	}
	if (ErrMsgArr.length>0){
		$.messager.alert("��ʾ",ErrMsgArr.join("</br>"));
		return false;
	}
	if (saveDataArr.length==0){
		$.messager.popover({msg: 'û����Ҫ��������ݣ�',type: 'error'});
		return false;
	}
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetPrintConfig",
		MethodName:"HandleSheetContent",
		event:"SAVE",
		dataArr:JSON.stringify(saveDataArr)
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '����ɹ���',type: 'success'});
			PrtSheetChange();
			RefreshSheetPrintSign(SheetID,SPSPrintSignDR);
		}else{
			$.messager.popover({msg: '����ʧ�ܣ�',type: 'error'});
		}
	})
}
function ResizeTablePanel(){
	$(".sheettable-panel").panel('resize',{
		width: $(document.body).width()-382,
		height: 250, //$(document.body).height()-400
	});
	$(".sheetcontent-panel").panel('resize',{
		width: $(document.body).width()-382,
		height: $(document.body).height()-403
	});
}
function ReSetInfuseSheetContentGridCol(){
	var ISPSTableType=GetISPSTableType();	
	var tableID=PageLogicObj.InfuseSheetContentSetObj.tableID;
	if (ISPSTableType=="OrderInfo") {
		var showColumns="SPCSDisplaySubOrd";
		var hideColumns="SPCSDesc^SPCSMarginLeft^SPCSMarginTop^SPCSItalic";
		$('#'+tableID).datagrid("setColumnTitle",{'SPCSContent':'����','SPCSWidth':'�п�(mm)'});
	}else{
		var showColumns="SPCSDesc^SPCSMarginLeft^SPCSMarginTop^SPCSItalic";
		var hideColumns="SPCSDisplaySubOrd";
		$('#'+tableID).datagrid("setColumnTitle",{'SPCSContent':'����','SPCSWidth':'���(mm)'});
	}
	if (hideColumns!="") {
		for (var i=0;i < hideColumns.split("^").length; i++){
			$('#'+tableID).datagrid("hideColumn",hideColumns.split("^")[i]);
		}
	}
	if (showColumns!="") {
		for (var i=0;i < showColumns.split("^").length; i++){
			$('#'+tableID).datagrid("showColumn",showColumns.split("^")[i]);
		}
	}
}
function GetISPSTableType(){
	var selected=$("#"+PageLogicObj.InfuseSheetTableObj.tableID).datagrid("getSelected");
	if (selected){
		var editors=$('#'+PageLogicObj.InfuseSheetTableObj.tableID).datagrid('getEditors',PageLogicObj.InfuseSheetTableObj.EditRow);
		if (editors.length >0){
			var ISPSTableType=editors[0].target.combobox('getValue');
		}else{
			var ISPSTableType=selected.ISPSTableType;
		}
		return ISPSTableType;
	}
	return "";
}
function InfuseSheetTableClick(){
   ClearInfuseSheetContentData();
   if (PageLogicObj.InfuseSheetContentSetObj.InitedFlag =="N"){
       InitInfuseSheetContentGrid();
   }
   var rowData=$("#"+PageLogicObj.InfuseSheetTableObj.tableID).datagrid("getSelected");
   if (rowData.ID!="") {
        var index=$.hisui.indexOfArray(PageLogicObj.SheetConfigJson.SheetTableConfig,"SPCSInfuseSheetTabDR",rowData.ID);
		if  (index < 0) {
			$('#'+PageLogicObj.InfuseSheetContentSetObj.tableID).datagrid("unselectAll").datagrid('loadData',{"rows":[],"total":0});
		}else{
			$('#'+PageLogicObj.InfuseSheetContentSetObj.tableID).datagrid("unselectAll").datagrid('loadData',PageLogicObj.SheetConfigJson.SheetTableConfig[index].Data); 
		}
   }else{
       $('#'+PageLogicObj.InfuseSheetContentSetObj.tableID).datagrid("unselectAll").datagrid('loadData',{"rows":[],"total":0});
   }
   ReSetInfuseSheetContentGridCol();
}
function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>ʹ��˵��</li>" + 
		'<li>1���������-�������˵��:</li>'+
		'<li><a href="#"><img src="../scripts/nurse/image/infusesheet-example.png"/></a></li>'+
		'<li>2��ά��������ú�ѡ���У��ɱ༭����Ӧ�Ĵ�ӡ����.</li>'+
		"</ul>" 
		
	$("#tip").popover({
		width:500,
		trigger:'hover',
		content:_content
	});
}
