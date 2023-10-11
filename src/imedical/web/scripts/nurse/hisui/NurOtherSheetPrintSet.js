/**
* @author songchunli
* HISUI 其他打印配置
*/
var PageLogicObj={
	SheetConfigJson:[]
}
$(function(){
	InitSheet();
	
});
function InitBindItem(){
	var rows = $("#tabPrtSheet").datagrid("getSelections");
	var SPSXMLDataType=rows[0].SPSXMLDataType;
	if (SPSXMLDataType == "Pat") {
		var searchType ="0^3"
	}else if (SPSXMLDataType == "Ord") {
		var searchType ="1^2^3"
	}
	$.cm({ 
		ClassName:"Nur.NIS.Service.Base.BedConfig", 
		QueryName:"GetNurseBasicDataList",
		searchName:"",
		searchType:searchType,
		filter:1,
		rows:99999
	},function(jsonData){
		$("#t-binditem").combobox({
			multiple:true,
			//editable:false,
			rowStyle:'checkbox',
			selectOnNavigation:true,
			valueField:'RowID',
			textField:'NBDName',
			enterNullValueClear:false,
			onSelect:selectHandler,
			onUnselect:selectHandler,
			data:jsonData.rows,
			onLoadSuccess:function(){ 
				$('#t-binditem').combobox('setValue','');
			},
		});
	});
	/*$("#t-binditem").combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.Base.BedConfig&QueryName=GetNurseBasicDataList&filter=1&rows=99999",
		mode:'remote',
		method:"Get",
		multiple:true,
		//editable:false,
		rowStyle:'checkbox',
		selectOnNavigation:true,
		valueField:'RowID',
		textField:'NBDName',
		enterNullValueClear:false,
		onBeforeLoad:function(param){
			var rows = $("#tabPrtSheet").datagrid("getSelections");
			var SPSXMLDataType=rows[0].SPSXMLDataType;
			if (SPSXMLDataType == "Pat") {
				var searchType ="0^3"
			}else if (SPSXMLDataType == "Ord") {
				var searchType ="1^2^3"
			}
			param.searchType=searchType;
		},
		onSelect:selectHandler,
		onUnselect:selectHandler,
		onLoadSuccess:function(){ 
			$('#t-binditem').combobox('setValue','');
		},
		loadFilter:function(data){
			return data.rows;
		}
	});*/
}
$(window).load(function() {
	$("#loading").hide();
	$('#t-XMLPrintMode').next().after($('<a></a>').linkbutton({
        plain:true,
        iconCls:'icon-help'       
    }).tooltip({
	    position:'left',
        content:"打印设计：仅支持单张打印，可手动修改内容打印。"
    }))
    $('#t-PrintPresetQuantity').after($('<a></a>').linkbutton({
        plain:true,
        iconCls:'icon-help'       
    }).tooltip({
	    position:'left',
        content:"<p>草药医嘱数量：付数。</p><p>检验医嘱数量：项目组合套->默认条码数。</p><p>其他医嘱数量：1。</p>"
    }))
})
function HospChange(){
	ClearConfigData();
	$('#tabPrtSheet').datagrid("reload");
}
function ClearConfigData(){
	selectItem(""),
    selectCompSet = [],
    $("#lineLayout").siblings().remove();
    disableMenuItem("DelMenu", "del"),disableMenuItem("SaveMenu", "save");
}
function PrtSheetChange(){
	$.cm({ 
		ClassName:"Nur.NIS.Service.OrderExcute.SheetPrintConfig", 
		MethodName:"GetSheetPrtContentSetJson",
		sheetRowId:GetSelPrtSheetTypeRowId()
	},function(jsonData){
		PageLogicObj.SheetConfigJson=jsonData;
		var XML=JsonToXML(jsonData);
		loadXmlTpl(XML);
	});
	InitBindItem();
}
var tagNameObj={"ListData":"Listdatapara","TxtData":"txtdatapara","PLData":"PLine","PICData":"PICdatapara"}
function JsonToXML(obj)
{
	var SheetPrtConfigObj=obj.SheetPrtConfig;
	var SheetTableConfigObj=obj.SheetTableConfig[0]; //.Data.rows
	var SheetTableConfigDataObj=SheetTableConfigObj.Data.rows;
	if(SheetTableConfigDataObj.length ==0){
		return defaultXML();
	}else{
		var XMLItemTypeArr=[],XMLItemTypeObj={};
		for (var i=0;i<SheetTableConfigDataObj.length;i++){
			var ItemDataObj=SheetTableConfigDataObj[i];
			var XMLItemType=ItemDataObj.SPCSXMLItemType;
			if ((XMLItemType!="Listdatapara")&&(!XMLItemTypeObj[XMLItemType])){
				XMLItemTypeObj[XMLItemType]={
					tagName:XMLItemType,
					properties:{
						RePrtHeadFlag:"N"
					},
					children:[]
				}
			}
			if (XMLItemType =="ListData") {
				$.extend(XMLItemTypeObj[XMLItemType].properties,{
					PrintType:"List",
					xcol:ItemDataObj.SPCSX,
					yrow:ItemDataObj.SPCSY || 0,
					YStep:ItemDataObj.SPCSListYStep,
					height:ItemDataObj.SPCSHeight,
					CurrentRow:ItemDataObj.SPCSListCurrentRow,
					PageRows:ItemDataObj.SPCSListPageRows,
					SPCSID:ItemDataObj.ID
				});
				continue;
			}
			if (XMLItemType =="Listdatapara") {
				XMLItemType="ListData";
				if (!XMLItemTypeObj[XMLItemType]){
					//var ListDataIndex=$.hisui.indexOfArray(SheetTableConfigDataObj,"SPCSXMLItemType","ListData");
					//if (ListDataIndex >= 0){
						XMLItemTypeObj[XMLItemType]={
							tagName:XMLItemType,
							properties:{
								RePrtHeadFlag:"N"
							},
							children:[]
						}
					//}
				}
			}
			XMLItemTypeObj[XMLItemType].children.push(new CreatXmlDoc({
				tagName:tagNameObj[XMLItemType]||(XMLItemType+"para"),
				properties:{
					name:ItemDataObj.SPCSDesc,
					binditem:ItemDataObj.SPCSDataBindItem,
					defaultvalue:ItemDataObj.SPCSContent,
					xcol:ItemDataObj.SPCSX,
					yrow:ItemDataObj.SPCSY,
					width:ItemDataObj.SPCSWidth,
					height:ItemDataObj.SPCSHeight,
					fontname:ItemDataObj.SPCSFontDesc, //SPCSFont
					fontsize:ItemDataObj.SPCSFontSize,
					fontbold:ItemDataObj.SPCSBold,
					angle:ItemDataObj.SPCSAngle,
					qrcodeversion:ItemDataObj.SPCSQRCodeVersion,
					isqrcode:ItemDataObj.SPCSQRCodeVersion?"true":"false",
					barcodetype:ItemDataObj.SPCSBarCodeType,
					isshowtext:ItemDataObj.SPCSBarCodeShowText,
					BeginX:ItemDataObj.SPCSStartX,
					BeginY:ItemDataObj.SPCSStartY,
					EndX:ItemDataObj.SPCSEndX,
					EndY:ItemDataObj.SPCSEndY,
					src:ItemDataObj.SPCSImgSrc,
					coltype:ItemDataObj.SPCSXMLListItemColType,
					SPCSID:ItemDataObj.ID
				}
			}))
		}
		$.each(XMLItemTypeObj,function(index,item){
			XMLItemTypeArr.push(new CreatXmlDoc(item));
		})
		var invoiceObj={
				tagName:"invoice",
				properties:{
					width:SheetPrtConfigObj.SPSPrintTemplWidth,
					height:SheetPrtConfigObj.SPSPrintTemplHeight,
					PaperHeight:SheetPrtConfigObj.SPSPrintPaperHeight,
					PaperWidth:SheetPrtConfigObj.SPSPrintPaperWidth,
					LandscapeOrientation:SheetPrtConfigObj.SPSXMLPrintDirection,
					PrtDevice:SheetPrtConfigObj.SPSPrintDeviceName,
					PrtPage:SheetPrtConfigObj.SPSPrintPaperName,
					PaperDesc:"",
					HorizontalAmount:SheetPrtConfigObj.SPSHorizontalAmount,
					VerticalAmount:SheetPrtConfigObj.SPSVerticalAmount,
					PrintPreview:SheetPrtConfigObj.SPSPrintPreview,
					XMLPrintMode:SheetPrtConfigObj.SPSXMLPrintMode,
					ForbidRepeatPrint:SheetPrtConfigObj.SPSForbidRepeatPrint,
					PrintPresetQuantity:SheetPrtConfigObj.SPSPrintPresetQuantity
				},
				children:XMLItemTypeArr
		}
	}
	var invoiceXMLDoc=new CreatXmlDoc(invoiceObj);
	var xmlDoc = loadXMLDoc();
    var xe1 = xmlDoc.createElement("appsetting");
    xe1.appendChild(invoiceXMLDoc.render());
    return xmlToString(xe1);
}
function delSheetPrtContentSet(SPCSID){
	if (SPCSID) {
		var delDataArr=[];
		delDataArr.push(SPCSID)
		$.cm({ 
			ClassName:"Nur.NIS.Service.OrderExcute.SheetPrintConfig", 
			MethodName:"HandleSheetContent",
			dataArr:JSON.stringify(delDataArr),
			event:"DELETE"
		},false);
	}
}
function SaveConfig(i){
	var SheetID=GetSelPrtSheetTypeRowId();
	if (!SheetID) {
		$.messager.popover({msg: '请先选择左侧单据！',type: 'success'});
		return false;
	}
	var saveDataArr=[],savePrtConfigDataArr=[],tableDataArr=[];
	var saveInvoiceData= i.appsetting.invoice;
    if (void 0 === saveInvoiceData) return "";
    for (var p in tagNameObj){
	    var oneSaveData=saveInvoiceData[p];
	    if (!oneSaveData) continue;
	    delete oneSaveData["-RePrtHeadFlag"];
	    var ItemDataObj=oneSaveData[tagNameObj[p]];
	    if (ItemDataObj){
		    if ($.isArray(ItemDataObj)){
			    $.each(ItemDataObj, function (i, e) {
				    var ItemDataArr=[];
		            for (var t in ItemDataObj[i]){
			    		ItemDataArr.push({"field":t,"fieldValue":ItemDataObj[i][t]});
					}
					tableDataArr.push(ItemDataArr);
		        })
			}else{
				var ItemDataArr=[];
				for (var t in ItemDataObj){
			    	ItemDataArr.push({"field":t,"fieldValue":ItemDataObj[t]});
				}
				tableDataArr.push(ItemDataArr);
			}
			delete oneSaveData[tagNameObj[p]];
			var ItemDataArr=[];
			for (var t in oneSaveData){
		    	ItemDataArr.push({"field":t,"fieldValue":oneSaveData[t]});
			}
			if (ItemDataArr.length > 0) tableDataArr.push(ItemDataArr);	
		}
		delete saveInvoiceData[p];
	}
	var PrtConfigDataArr=[];
	for (var t in saveInvoiceData){
    	PrtConfigDataArr.push({"field":t,"fieldValue":saveInvoiceData[t]});
	}
	savePrtConfigDataArr.push(PrtConfigDataArr);
    saveDataArr.push({"SheetTableType":"","SheetID":SheetID,"SheetTableConfigData":JSON.stringify(tableDataArr)});
    saveDataArr.push({"SheetTableType":"SheetPrtConfigData","SheetID":SheetID,"SheetTableConfigData":JSON.stringify(savePrtConfigDataArr)});
	$.cm({
		ClassName:"Nur.NIS.Service.OrderExcute.SheetPrintConfig",
		MethodName:"HandleSheetContent",
		event:"SAVE",
		dataArr:JSON.stringify(saveDataArr)
	},function(rtn){
		if (rtn ==0) {
			$.messager.popover({msg: '保存成功！',type: 'success'});
			PrtSheetChange();
		}else{
			$.messager.popover({msg: '保存失败！',type: 'error'});
		}
	})
}