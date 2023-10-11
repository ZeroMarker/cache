/**
* @author songchunli
* HISUI ִ�е���ӡ����
*/
var PageLogicObj={
	gridArr:[{"tableID":"tabExecSheetHeaderSet","InitedFlag":"N","SheetTableType":"Header","Default":{
				Font:"Song",
				FontSize:"13",
				Align:"AlignLeft",
				Bold:"Normal",
				Italic:"Normal"
			 },NeedRefreshData:"Y"
			  ,NotTogetherNullColumnArr:[{"SPCSContent":"","SPCSDataBindItem":""}]
			  ,DataBindItemSearchType:"0^3",
			 }, //NotTogetherNullColumnArr ����ͬʱΪ�յ��ֶμ���
			 {"tableID":"tabExecSheetUpSet","InitedFlag":"N","SheetTableType":"UpContent","Default":{
				Font:"Song",
				FontSize:"10",
				Align:"AlignLeft",
				Bold:"Normal",
				Italic:"Normal"
			 },NeedRefreshData:"Y"
			  ,NotTogetherNullColumnArr:[{"SPCSContent":"","SPCSDataBindItem":""}]
			  ,DataBindItemSearchType:"0^3",
			 },
			 {"tableID":"tabExecSheetDownSet","InitedFlag":"N","SheetTableType":"DownContent","Default":{
				Font:"Song",
				FontSize:"10",
				Align:"AlignLeft",
				Bold:"Normal",
				Italic:"Normal"
			 },NeedRefreshData:"Y"
			  ,NotTogetherNullColumnArr:[{"SPCSContent":"","SPCSDataBindItem":""}]
			  ,DataBindItemSearchType:"0^3",
			 },
			 {"tableID":"tabExecSheetFooterSet","InitedFlag":"N","SheetTableType":"Footer","Default":{
				Font:"Song",
				FontSize:"10",
				Align:"AlignLeft",
				Bold:"Normal",
				Italic:"Normal"
			 },NeedRefreshData:"Y"
			  ,NotTogetherNullColumnArr:[{"SPCSContent":"","SPCSDataBindItem":""}]
			  ,DataBindItemSearchType:"0^3",
			 },
			 {"tableID":"tabExecSheetOrdSet","InitedFlag":"N","SheetTableType":"OrderInfo","Default":{
				Font:"Song",
				FontSize:"10",
				Align:"AlignLeft",
				Bold:"Normal",
				Italic:"Normal"
			 },NeedRefreshData:"Y"
			  ,NotTogetherNullColumnArr:[{"SPCSContent":"","SPCSDataBindItem":""}]
			  ,DataBindItemSearchType:"1^2^3",
			 },
			 {"tableID":"tabExecSheetOrdAdditionInfoSet","InitedFlag":"N","SheetTableType":"OrderAdditionInfo","Default":{
				ordAdditionInfoType:"Suffix"
			 },NeedRefreshData:"Y"
			  ,NotTogetherNullColumnArr:[{"SPCSContent":"","SPCSDataBindItem":""}]
			  ,DataBindItemSearchType:"1",
			 }],
	SheetConfigJson:[],
	SheetPrtObj:{"InitedFlag":"N","NeedRefreshData":"Y"}
}
$(function(){
	Init();
	InitTip();
});
$(window).load(function() {
	$("#loading").hide();
	$("#prtconfig-tip").parent().css("width","44");
})
function Init(){
	InitSheet();
	InitEvent();
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
}
function HospChange(){
	ClearConfigData();
	$('#tabPrtSheet').datagrid("reload");
}
function InitConfigContentGrid(tableID){
	var ToolBar = [{
		text: '����',
		iconCls: '	icon-add',
		handler: function() {
			var SheetID=GetSelPrtSheetTypeRowId();
			if (!SheetID) {
				$.messager.popover({msg: '����ѡ����Ч����!',type: 'error'});
				return false;
			}
			var selTab=$("#config-accordion").accordion("getSelected");
			if (selTab) {
				var tabIndex=$("#config-accordion").accordion('getPanelIndex', selTab);
				var tabId=PageLogicObj.gridArr[tabIndex].tableID; 
				var maxRow=$("#"+tabId).datagrid("getRows");
				//SPCSOrdAdditionInfoType
				if (tabId=="tabExecSheetOrdAdditionInfoSet"){
					$("#"+tabId).datagrid("appendRow", {
						Index:maxRow.length,
	                    ID: '',
	                    SPCSOrdAdditionInfoType: PageLogicObj.gridArr[tabIndex].Default.ordAdditionInfoType
	                })
	                var editIndex=maxRow.length-1;
	                $("#"+tabId).datagrid("beginEdit", editIndex);
	                $('.sortUpcls').linkbutton({ text: '', plain: true, iconCls: 'icon-up' });
	        		$('.sortDowncls').linkbutton({ text: '', plain: true, iconCls: 'icon-down' });
				}else{
					$("#"+tabId).datagrid("appendRow", {
						Index:maxRow.length,
	                    ID: '',
	                    SPCSBold: PageLogicObj.gridArr[tabIndex].Default.Bold,
	                    SPCSItalic: PageLogicObj.gridArr[tabIndex].Default.Italic,
	                    SPCSAlign: PageLogicObj.gridArr[tabIndex].Default.Align,
	                    SPCSFont:PageLogicObj.gridArr[tabIndex].Default.Font,
	                    SPCSFontSize:PageLogicObj.gridArr[tabIndex].Default.FontSize
	                })
	                var editIndex=maxRow.length-1;
	                $("#"+tabId).datagrid("beginEdit", editIndex);
	                if (tabId =="tabExecSheetOrdSet"){
		                if (editIndex >0){
			                var ed = $('#'+tableID).datagrid('getEditor', {index:editIndex,field:'SPCSHeight'});
			                //SPCSHeightChange(editIndex,ed.target)
			                $(ed.target[0]).attr("disabled","disabled");
						}else{
							SetSPCSHeightStatus(tabId,0);
						}
					}
				}
			}
			
		}
	},{
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var selTab=$("#config-accordion").accordion("getSelected");
			if (selTab) {
				var tabIndex=$("#config-accordion").accordion('getPanelIndex', selTab);
				var tabId=PageLogicObj.gridArr[tabIndex].tableID;
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
		}
    }];		
    var DescFieldObj={ field: 'SPCSDesc', title: '����',width:140, editor : 
						{type : 'text',options : {required:true}}
			         };
	var ContentFieldObj={ field: 'SPCSContent', title: '����',width:160,editor : //,options : {required:true}
							{type : 'text'}
						};
	var DataBindItemFieldObj={ field: 'SPCSDataBindItem', title: '����������Ŀ',width:160,editor :{
					type:'combobox',  
					options:{
						mode:"local",
						multiple:true,
						//editable:false,
						defaultFilter:6,
						rowStyle:"checkbox",
						url:$URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetNurseBasicDataList&filter=1&rows=99999",
						valueField:'RowID',
						textField:'NBDName',
						loadFilter: function(data){
							return data['rows'];
						},
						onBeforeLoad:function(param){
							var selTab=$("#config-accordion").accordion("getSelected");
							var tabIndex=$("#config-accordion").accordion('getPanelIndex', selTab);
							var DataBindItemSearchType=PageLogicObj.gridArr[tabIndex].DataBindItemSearchType || "";
							$.extend(param, {
								searchType:DataBindItemSearchType,
								searchName:param["q"]
							});
						},
						onChange:function(newValue, oldValue){
							basicItemChange(this);
						},
						onLoadSuccess:function(){
							basicItemChange(this);
						}
					}
				},
				formatter: function(value,row,index){
					return row.SPCSDataBindItemDesc;
				}	
			};
	var MarginLeftFieldObj={ field: 'SPCSMarginLeft', title: '��߾�(mm)',width:90,editor :
				{type : 'numberbox'}
			};
	var MarginTopFieldObj={ field: 'SPCSMarginTop', title: '�ϼ��(mm)',width:90,editor :
				{type : 'numberbox'}
			};
	var MarginBottomFieldObj={ field: 'SPCSMarginBottom', title: '�¼��(mm)',width:90,editor :
				{type : 'numberbox'}
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
	var FontSizeFieldObj={ field: 'SPCSFontSize', title: '�ֺ�(��)',width:60,editor :
				{type : 'numberbox',options : {required:true}}
			};
	var WidthFieldObj={ field: 'SPCSWidth', title: '���(mm)',width:75,editor :
				{type : 'numberbox'}
			};
	var HeightFieldObj={ field: 'SPCSHeight', title: '�߶�(mm)',width:75,editor :
				{type : 'numberbox'}
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
	var DisplaySubOrdFieldObj={ field: 'SPCSDisplaySubOrd', title: '�Ƿ���ʾ��ҽ��',width:130, align:'center',editor : 
				{
					type : 'icheckbox',options:{on:'Y',off:'N'}
				},
				formatter: function(value,row,index){
					return row.SPCSDisplaySubOrdDesc;
				}
			};
	var mergeFieldObj={ field: 'SPCSMerge', title: '�Ƿ�ϲ���ʾ',width:120, align:'center',editor : 
				{
					type : 'icheckbox',options:{on:'Y',off:'N'}
				},
				formatter: function(value,row,index){
					return row.SPCSMergeDesc;
				}
			};
	var underlineFieldObj={ field: 'SPCSUnderline', title: '�Ƿ��߷ָ�',width:120, align:'center',editor : 
				{
					type : 'icheckbox',options:{on:'Y',off:'N'}
				},
				formatter: function(value,row,index){
					return row.SPCSUnderlineDesc;
				}
			};
	var SPCSOrdAdditionInfoTypeObj={ field: 'SPCSOrdAdditionInfoType', title: '����',width:120, align:'center',editor : 
				{
					type:'combobox',  
					options:{
						mode:"local",
						editable:false,
						valueField:'value',
						textField:'text',
						data:ServerObj.OrdAdditionInfoTypeJson,
						editable:false
					 }
				},
				formatter: function(value,row,index){
					return row.SPCSOrdAdditionInfoTypeDesc;
				}
			};
	var operations={ 
			field: 'rowid', title: '����', width: 120, formatter: function(val, row, index){
	                var sortUpBtn = '<a href="#this" class="sortUpcls" onclick="ordSortUp(\'' + (row.ID) + '\')"></a>';
	                var sortDownBtn = '<a href="#this" class="sortDowncls" onclick="ordSortDown(\'' + (row.ID) + '\')"></a>';
	                return sortUpBtn + " " + sortDownBtn;
	        	} 
			}
	var Columns=[],Column=[];
    if (tableID == "tabExecSheetOrdSet") {
	    ContentFieldObj.title="����";
	    Column.push(ContentFieldObj);
	    WidthFieldObj.title="�п�(mm)";
	    WidthFieldObj.width="80";
	    HeightFieldObj.title="�и�(mm)";
	    HeightFieldObj.width="80";
	    Column.push(WidthFieldObj);
	    Column.push(HeightFieldObj);
	    Column.push(DataBindItemFieldObj);
	    Column.push(FontFieldObj);
	    Column.push(FontSizeFieldObj);
	    Column.push(AlignFieldObj);
	    Column.push(BoldFieldObj);
	    Column.push(DisplaySubOrdFieldObj);
	    Column.push(mergeFieldObj);
	    Column.push(underlineFieldObj);
	}else if(tableID == "tabExecSheetOrdAdditionInfoSet"){
		Column.push(ContentFieldObj);
		Column.push(DataBindItemFieldObj);
		Column.push(DisplaySubOrdFieldObj);
		Column.push(SPCSOrdAdditionInfoTypeObj);
		Column.push(operations);
	}else{
		Column.push(DescFieldObj);
		Column.push(ContentFieldObj);
		Column.push(DataBindItemFieldObj);
		Column.push(MarginLeftFieldObj);
		Column.push(MarginTopFieldObj);
		Column.push(MarginBottomFieldObj);
		Column.push(FontFieldObj);
	    Column.push(FontSizeFieldObj);
		Column.push(WidthFieldObj);
	    Column.push(HeightFieldObj);
	    Column.push(AlignFieldObj);
	    Column.push(BoldFieldObj);
	    Column.push(ItalicFieldObj);
	}
	Columns.push(Column);
	$('#'+tableID).datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : tableID=="tabExecSheetOrdAdditionInfoSet"?true:false,
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
			$('#'+tableID).datagrid("beginEdit", rowIndex);
			SetSPCSHeightStatus(tableID,rowIndex);
        },
         onLoadSuccess: function (data) {
	        $('.sortUpcls').linkbutton({ text: '', plain: true, iconCls: 'icon-up' });
	        $('.sortDowncls').linkbutton({ text: '', plain: true, iconCls: 'icon-down' });
        }
	})
}
function SetSPCSHeightStatus(tableID,rowIndex){
	if (tableID =="tabExecSheetOrdSet"){
		var ed = $('#'+tableID).datagrid('getEditor', {index:rowIndex,field:'SPCSHeight'});
		if (rowIndex ==0){
			$(ed.target).bind('keyup', function (e) {
				var code = e.keyCode || e.which;
				SPCSHeightChange(rowIndex,ed.target);
			});
			$(ed.target).bind('change', function (e) {
				SPCSHeightChange(rowIndex,ed.target);
			});
		}else{
			$(ed.target[0]).attr("disabled","disabled");
		}
	}
}
function SPCSHeightChange(index,target){
	if(typeof(target)=='string') target='#'+target;
	var newValue=$(target).val();
	var rows=$("#tabExecSheetOrdSet").datagrid("getRows");
	for (var i=1;i<rows.length;i++){
		$('#tabExecSheetOrdSet').datagrid("beginEdit", i);
		var ed = $('#tabExecSheetOrdSet').datagrid('getEditor', {index:i,field:'SPCSHeight'});
		ed.target.numberbox('setValue',newValue);
		$(ed.target[0]).attr("disabled","disabled");
	}
    return true;
}
function refreshContentData(){
	var p = $('#config-accordion').accordion('getSelected');
	var index = $('#config-accordion').accordion('getPanelIndex', p);
	if (PageLogicObj.gridArr[index]) {
		var tableID = PageLogicObj.gridArr[index].tableID;
		var SheetTableType = PageLogicObj.gridArr[index].SheetTableType;
		if (PageLogicObj.gridArr[index].InitedFlag =="N"){
			$.extend(PageLogicObj.gridArr[index], {InitedFlag:"Y"});
			InitConfigContentGrid(tableID);
			LoadGridData();
		}else if(PageLogicObj.gridArr[index].NeedRefreshData =="Y"){
			LoadGridData();
		}
		$.extend(PageLogicObj.gridArr[index], {NeedRefreshData:"N"});
	}else{
		if(PageLogicObj.SheetPrtObj.InitedFlag =="N"){
			$.extend(PageLogicObj.SheetPrtObj, {InitedFlag:"Y"});
			InitPrtCombo();
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
			var SPSPrintPaper =$("#SPSPrintPaper").combobox("getValue");
			var SPSType =$("#execSheetType").combobox("getValue");
			if ((SPSType =="Person")&&(SPSPrintPaper=="OtherPaper")){
				$(".singlepagechg,.crossdaypagechg").show();
			}else{
				$(".singlepagechg,.crossdaypagechg").hide();
				$("#SPSPrintSinglePageChange,#SPSCrossDayPageChange").checkbox("uncheck");
			}
			var SPSExecSheetDataType="";
			var checked=$("input[name='ExecSheetDataType']:checked");
			if (checked.length) SPSExecSheetDataType=checked[0].id;
			if (SPSExecSheetDataType=="Ord") {
				$("#SPSPrintType").combobox("disable").combobox("setValue","");
			}else{
				$("#SPSPrintType").combobox("enable")
			}
		}
		$.extend(PageLogicObj.SheetPrtObj, {NeedRefreshData:"N"});
	}
	function LoadGridData(){
		var index=$.hisui.indexOfArray(PageLogicObj.SheetConfigJson.SheetTableConfig,"SheetTableType",SheetTableType);
		if  (index < 0) {
			$('#'+tableID).datagrid("unselectAll").datagrid('loadData',{"rows":[],"total":0});
		}else{
			$('#'+tableID).datagrid("unselectAll").datagrid('loadData',PageLogicObj.SheetConfigJson.SheetTableConfig[index].Data); 
		}
	}
}
function PrtSheetChange(){
	ClearConfigData();
	PageLogicObj.SheetConfigJson=$.cm({ 
		ClassName:"Nur.NIS.Service.OrderExcute.SheetPrintConfig", 
		MethodName:"GetSheetPrtContentSetJson",
		sheetRowId:GetSelPrtSheetTypeRowId()
	},false);
	for(var i=0;i<PageLogicObj.gridArr.length;i++){
     	PageLogicObj.gridArr[i].NeedRefreshData ="Y";
 	}
 	PageLogicObj.SheetPrtObj.NeedRefreshData ="Y";
	refreshContentData();
}
function InitPrtCombo(){
	//ִ�е���ӡ
	$("#SPSPrintPaper").combobox({
		valueField: 'value',
		textField: 'text', 
		editable:false,
		data: ServerObj.PrintPaperJson,
		onSelect:function(rec){
			$(".other-paper").hide();
			if (rec.value =="OtherPaper") {
				$(".other-paper").show();
			}
			var SPSType =$("#execSheetType").combobox("getValue");
			if ((SPSType =="Person")&&(rec.value=="OtherPaper")){
				$(".crossdaypagechg").show();
			}else{
				$(".crossdaypagechg").hide();
			}
		}
	})
	//��ӡ����
	$("#SPSPrintDirection").combobox({
		valueField: 'value',
		textField: 'text', 
		editable:false,
		data: ServerObj.PrintDirectionJson
	})
	
	var  SPSExecSheetDataType="";
	var checked=$("input[name='ExecSheetDataType']:checked");
	if (checked.length) SPSExecSheetDataType=checked[0].id;
	//��ӡ����
	$("#SPSPrintType").combobox({
		valueField: 'value',
		textField: 'text', 
		editable:false,
		disabled:SPSExecSheetDataType=="Ord"?true:false,
		data: ServerObj.PrintTypeJson
	})
	//˫����ӡ
	$("#SPSPrintDuplex").combobox({
		valueField: 'value',
		textField: 'text', 
		//editable:false,
		data: ServerObj.PrintDuplexJson
	})
}
function SaveConfig(){
	var SheetID=GetSelPrtSheetTypeRowId();
	if (!SheetID) {
		$.messager.popover({msg: '����ѡ����Ч����!',type: 'error'});
		return false;
	}
	var saveDataArr=[],ErrMsgArr=[];
	var reg = /^[+]{0,1}(\d+)$/; //��Լ����0��������
	var reg1 = /^[0-9]*[1-9][0-9]*$/; //����0��������
	for (var i=0;i < PageLogicObj.gridArr.length ;i++){
		if (PageLogicObj.gridArr[i].InitedFlag =="N") continue;
		var NullValColumnArr=[],NotValidateColumnArr=[],NotTogetherNullColumnArr=[];
		var SheetTableType=PageLogicObj.gridArr[i].SheetTableType;
		var tableDataArr=[];
		var tableID=PageLogicObj.gridArr[i].tableID;
		var rows=$("#"+tableID).datagrid("getRows");
		for (var j=0;j<rows.length;j++){
			var rowDataArr=[];
			var editors=$('#'+tableID).datagrid('getEditors',j);
			if (editors.length ==0){
				if (tableID=="tabExecSheetOrdAdditionInfoSet"){
					var SPCSID=rows[j].ID;
					if (!SPCSID) SPCSID="";
					rowDataArr.push({"field":"ID","fieldValue":SPCSID});
					rowDataArr.push({"field":"SPCSOrdSerialNo","fieldValue":(j+1)});
					tableDataArr.push(rowDataArr);
				}
				continue;
			}
			var SPCSContent_Value="",SPCSDataBindItem_Value="";
			for (var k=0;k<editors.length;k++){
				var field=editors[k].field;
				if (field=="SPCSOrdSerialNo") continue;
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
				var fieldOpts = $('#'+tableID).datagrid('getColumnOption',field);
				if (fieldOpts.editor.options){
					if ((fieldOpts.editor.options.required)&&(!value)){
						NullValColumnArr.push("��"+(j+1)+"��"+fieldOpts.title);
					}
				}
				if ((value)&&(fieldType =="numberbox")&&(!reg.test(value))){
					NotValidateColumnArr.push("��"+(j+1)+"��"+fieldOpts.title);
				}
				rowDataArr.push({"field":field,"fieldValue":value});
				for (var l=0;l<PageLogicObj.gridArr[i].NotTogetherNullColumnArr.length;l++){
					for (elem in PageLogicObj.gridArr[i].NotTogetherNullColumnArr[l]){
						if (elem == field) {
							if (NotTogetherNullColumnArr[j+1]) {
								$.extend(NotTogetherNullColumnArr[j+1],{"title":NotTogetherNullColumnArr[j+1]["title"]+"��"+fieldOpts.title});
							}else{
								NotTogetherNullColumnArr[j+1]={"title":fieldOpts.title};
							}
							NotTogetherNullColumnArr[j+1][field]=value;
						}
					}
				}
			}
			if (rowDataArr.length>0){
				var SPCSID=rows[j].ID;
				if (!SPCSID) SPCSID="";
				rowDataArr.push({"field":"ID","fieldValue":SPCSID});
				rowDataArr.push({"field":"SPCSOrdSerialNo","fieldValue":(j+1)});
				tableDataArr.push(rowDataArr);
			}
		}
		if (tableDataArr.length>0){
			saveDataArr.push({"SheetTableType":SheetTableType,"SheetID":SheetID,"SheetTableConfigData":JSON.stringify(tableDataArr)});
		}
		var OneTableErrMsg="";
		
		if (NullValColumnArr.length>0){
			OneTableErrMsg=NullValColumnArr.join("��")+"����Ϊ�գ�";
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
					OneTableErrMsg += title+"����ͬʱΪ�գ�"
				}
			}
		}
		if (NotValidateColumnArr.length>0){
			OneTableErrMsg+=NotValidateColumnArr.join("��")+"��������ڵ���0����������"
		}
		if (OneTableErrMsg){
			var AccordionOpts=$('#config-accordion').accordion('getPanel', i).panel("options");
			var AccordionTitle=AccordionOpts.title;
			ErrMsgArr.push("<span style='color:red;'>"+AccordionTitle+"</span>��"+OneTableErrMsg);
		}
	}
	var NotValidatePrtConfigArr=[];
	var savePrtConfigDataArr=[],PrtConfigDataArr=[];
	var SPSExecSheetDataType="";
	var checked=$("input[name='ExecSheetDataType']:checked");
	if (checked.length) SPSExecSheetDataType=checked[0].id;
	PrtConfigDataArr.push({"field":"SPSExecSheetDataType","fieldValue":SPSExecSheetDataType});
	if (SPSExecSheetDataType=="") {
		ErrMsgArr.push("δѡ����������");
	}
	if (PageLogicObj.SheetPrtObj.InitedFlag =="Y"){
		var _$input=$("#prtconfig-table tr td:not(.r-label) > input");
		for (var i=0;i<_$input.length;i++){
			var id=_$input[i].id;
			if (!id) continue;
			var _$id=$("#"+id);
			if (_$id.parents("tr").css("display") =='none'){
				if(_$id.hasClass('checkbox-f')){
					var value="N";
				}else{
					var value="";
				}
			}else{
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
			}
			if ((SPSExecSheetDataType=="Ord")&&(id=="SPSPrintType")) value="";
			PrtConfigDataArr.push({"field":id,"fieldValue":value});
		}
		var _$div=$("#prtconfig-table tr td:not(.r-label) > div");
		for (var i=0;i<_$div.length;i++){
			var id=_$div[i].id;
			if (!id) continue;
			var _$id=$("#"+id);
			if(_$id.hasClass("hisui-switchbox")){
				var value=_$id.switchbox("getValue")?"Y":"N";
			}
			PrtConfigDataArr.push({"field":id,"fieldValue":value});
		}
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
function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>����˵��</li>" + 
		"<li>1��˫����ӡ��ָ��ӡһҳ����ִ�е���ģʽ,�������������ظ��Ͳ��ظ���</li>" +
		"<li>2�����˻�ҳ��ִָ�е�(����)��ӡʱ��ͬ���߻�ҳ��ӡ��</li>" + 
		"<li>3����ӡ���ͣ�</li>" +
		
		"<li>��ҽ����ӡʱ��ģʽ����ͬҽ����ִ�м�¼�ϲ���ӡ��ͬһ�����,Ҫ��ִ��ʱ���в��;</li>" + 
		"<li>��ҽ����ӡ����ģʽ����ͬҽ����ִ�м�¼�ϲ���ӡ��ͬһ�����,Ҫ��ִ��ʱ���в����;</li>" + 
		"<li>��ִ�м�¼��ӡ��ÿ��ִ�м�¼����һ���������ִ�м�¼��Ҫ��ִ��ʱ������;</li>"+
		"<li>��ӡԤ�����Դ�ӡ����Ԥ������δ���á���ӡ�����ơ��������Ԥ�����ֶ�ѡ���ӡ����ӡ;</li>"
		
	$("#prtconfig-tip").popover({
		width:500,
		height:320,
		trigger:'hover',
		content:_content
	});
}
function ClearConfigData(){
	PageLogicObj.SheetConfigJson=[];
	for (var i=0;i < PageLogicObj.gridArr.length ;i++){
		if (PageLogicObj.gridArr[i].InitedFlag =="N") continue;
		var tableID=PageLogicObj.gridArr[i].tableID;
		$('#'+tableID).datagrid("unselectAll").datagrid('loadData',{"rows":[],"total":0});
	}
	if (PageLogicObj.SheetPrtObj.InitedFlag =="Y"){
		var _$input=$("#prtconfig-table tr td:not(.r-label) > input");
		for (var i=0;i<_$input.length;i++){
			var id=_$input[i].id;
			if (!id) continue;
			var _$id=$("#"+id);
			if (_$id.next().hasClass('combo')){
				_$id.combobox('setValue','');
			}else if(_$id.hasClass('checkbox-f')){
				_$id.checkbox('setValue',false);
			}else if(_$id.hasClass('numberbox')){
				_$id.numberbox('setValue','');
			}else{
				_$id.val('');
			}
		}
	}
}
function basicItemChange(that){
	var existExecTypeItem=0;
	var basicItemArr=$(that).combobox("getData")
	var basicSelItemArr=$(that).combobox("getValues");
	for (var itemIndex=0;itemIndex<basicSelItemArr.length;itemIndex++){
		var itemId=basicSelItemArr[itemIndex];
		var Index=$.hisui.indexOfArray(basicItemArr,"RowID",itemId);
		if (Index>=0){
			if (basicItemArr[Index]["NBDTypeDesc"]=="ִ�м�¼��Ϣ") {
				existExecTypeItem=1;
				break;
			}
		}
	}
	var selTab=$("#config-accordion").accordion("getSelected");
	var tabIndex=$("#config-accordion").accordion('getPanelIndex', selTab);
	var tabId=PageLogicObj.gridArr[tabIndex].tableID;
	var tr = $(that).closest("tr.datagrid-row");
	var modRowIndex = tr.attr("datagrid-row-index");
	var MergeObj=$("#"+tabId).datagrid('getEditor', {index:modRowIndex,field:'SPCSMerge'});
	var UnderlineObj=$("#"+tabId).datagrid('getEditor', {index:modRowIndex,field:'SPCSUnderline'});
	//��������Ϊ�ջ����ִ�м�¼���͵�,��ά���Ƿ���
	if (UnderlineObj) {
		if ((basicSelItemArr.length==0)||(existExecTypeItem==1)){
			UnderlineObj.target.checkbox("enable");
		}else{
			UnderlineObj.target.checkbox("disable").checkbox("uncheck");
		}
	}
	//����������Ŀ��Ϊ���Ҳ���ִ�м�¼����,��ά���Ƿ�ϲ�
	if (MergeObj) {
		if ((basicSelItemArr.length>0)&&(existExecTypeItem==0)){
			MergeObj.target.checkbox("enable");
		}else{
			MergeObj.target.checkbox("disable").checkbox("uncheck");
		}
	}
}
function ExecSheetDataTypeChange(e,value){
	var selected = $("#tabPrtSheet").datagrid("getSelected");
	if (selected){
		var SPSExecSheetDataType="";
		var checked=$("input[name='ExecSheetDataType']:checked");
		if (checked.length) SPSExecSheetDataType=checked[0].id;
		if (($("#SPSPrintType").length>0)&&(PageLogicObj.SheetPrtObj.InitedFlag=="Y")){
			if (SPSExecSheetDataType=="Ord") {
				$("#SPSPrintType").combobox("disable").combobox("setValue","");
			}else{
				$("#SPSPrintType").combobox("enable");
			}
		}
		var selTab=$("#config-accordion").accordion("getSelected");
		var oldSelTabIndex=$("#config-accordion").accordion('getPanelIndex', selTab);
		var tableID="tabExecSheetOrdSet";
		var tabIndex=$.hisui.indexOfArray(PageLogicObj.gridArr,"tableID","tabExecSheetOrdSet");
		if (SPSExecSheetDataType=="Ord") {
			PageLogicObj.gridArr[tabIndex].DataBindItemSearchType="1^3";
		}else{
			PageLogicObj.gridArr[tabIndex].DataBindItemSearchType="1^2^3";
		}
		if ((tabIndex==oldSelTabIndex)&&(PageLogicObj.gridArr[tabIndex].InitedFlag =="Y")){
			var rows=$("#"+tableID).datagrid("getRows");
			for (var j=0;j<rows.length;j++){
				var editors=$('#'+tableID).datagrid('getEditors',j);
				if (editors.length ==0) continue;
				var dataBindItemObj=$("#"+tableID).datagrid('getEditor', {index:j,field:'SPCSDataBindItem'});
				dataBindItemObj.target.combobox("setValues","").combobox("reload");
			}
		}
	}
}
function ordSortUp(sortSetId){
	if (!sortSetId){
		$.messager.popover({ msg: '���ȱ�����ٵ���˳��!', type: 'error'});
		return false;
	}
	var rows=$("#tabExecSheetOrdAdditionInfoSet").datagrid("getRows"); 
	var index=$.hisui.indexOfArray(rows,"ID",sortSetId); //$("#tabExecSheetOrdAdditionInfoSet").datagrid("getRowIndex",sortSetId);
	if (index==0) return false;
	var preRow=rows[index-1];
	var curRow=rows[index];
	var preRowSerialNo=preRow["SPCSOrdSerialNo"];
	var curRowSerialNo=curRow["SPCSOrdSerialNo"];
	preRow["EOSSSerialNo"]=curRowSerialNo;
	curRow["EOSSSerialNo"]=preRowSerialNo;
	$('#tabExecSheetOrdAdditionInfoSet').datagrid('getData').rows[index] = preRow;
    $('#tabExecSheetOrdAdditionInfoSet').datagrid('getData').rows[index - 1] = curRow;
    $('#tabExecSheetOrdAdditionInfoSet').datagrid('refreshRow', index);
    $('#tabExecSheetOrdAdditionInfoSet').datagrid('refreshRow', index - 1).datagrid('selectRow', index - 1);
    //saveOrdSortNoChange(curRow,preRow);
    $('.sortUpcls').linkbutton({ text: '', plain: true, iconCls: 'icon-up' });
	$('.sortDowncls').linkbutton({ text: '', plain: true, iconCls: 'icon-down' });
}
function ordSortDown(sortSetId){
	if (!sortSetId){
		$.messager.popover({ msg: '���ȱ�����ٵ���˳��!'+txtData, type: 'error'});
		return false;
	}
	var rows=$("#tabExecSheetOrdAdditionInfoSet").datagrid("getRows"); 
	var index=$.hisui.indexOfArray(rows,"ID",sortSetId); //$("#tabExecSheetOrdAdditionInfoSet").datagrid("getRowIndex",sortSetId);
	if (index==(rows.length-1)) return;
	var nextRow=rows[index+1];
	var curRow=rows[index];
	var nextRowSerialNo=nextRow["SPCSOrdSerialNo"];
	var curRowSerialNo=curRow["SPCSOrdSerialNo"];
	nextRow["EOSSSerialNo"]=curRowSerialNo;
	curRow["EOSSSerialNo"]=nextRowSerialNo;
	$('#tabExecSheetOrdAdditionInfoSet').datagrid('getData').rows[index] = nextRow;
    $('#tabExecSheetOrdAdditionInfoSet').datagrid('getData').rows[index + 1] = curRow;
    $('#tabExecSheetOrdAdditionInfoSet').datagrid('refreshRow', index);
    $('#tabExecSheetOrdAdditionInfoSet').datagrid('refreshRow', index + 1).datagrid('selectRow', index + 1);
    $('.sortUpcls').linkbutton({ text: '', plain: true, iconCls: 'icon-up' });
	$('.sortDowncls').linkbutton({ text: '', plain: true, iconCls: 'icon-down' });
    //saveOrdSortNoChange(curRow,nextRow);
}
/*function saveOrdSortNoChange(curRow,exchangeRow){
	var sheetId=GetSelPrtSheetTypeRowId();
	if (!sheetId) {
		$.messager.popover({msg: '����ѡ����Ч����!',type: 'error'});
		return false;
	}
	var SaveDataArr=[];
    var saveObj={
	    sheetId:sheetId,
	    sortSetId:curRow["ID"],
	    SPCSOrdSerialNo:curRow["SPCSOrdSerialNo"]
	}
	$.extend(saveObj,curRow);
    SaveDataArr.push(saveObj);
    
    var saveObj={
	    sheetId:sheetId,
	    sortSetId:exchangeRow["ID"],
	    SPCSOrdSerialNo:exchangeRow["SPCSOrdSerialNo"]
	}
	$.extend(saveObj,exchangeRow);
    SaveDataArr.push(saveObj);
    $m({
        ClassName: 'Nur.NIS.Service.OrderExcute.SheetPrintConfig',
        MethodName: 'handleOrdSortSet',
        SaveDataArr:JSON.stringify(SaveDataArr),
        EVENT:"SAVE"
    }, function (txtData) {
        if (txtData == 0) {
	        $('.sortUpcls').linkbutton({ text: '', plain: true, iconCls: 'icon-up' });
	        $('.sortDowncls').linkbutton({ text: '', plain: true, iconCls: 'icon-down' });
        }else{
	        $.messager.popover({ msg: '����ʧ�ܣ�'+txtData, type: 'error'});
	    }
    })
}*/