var PageLogicObj={
	//皮试附加医嘱表格的选择联动
	Order_selRowIndex:""	
}
$(function(){
	if (ServerObj.GuideAllergyType=="Guide"){
		///皮试引导窗口
		InitGuide();
		InitGuideEvent();
	}else if (ServerObj.GuideAllergyType=="Append"){
		//皮试附加医嘱选择窗口
		InitAppend();
		InitAppendEvent()
	}
	
	
});
function InitAppend(){
	var columns=[[
	    {field:'CheckOrd',title:'选择',checkbox:'true',align:'center',width:70,auto:false},
	    {field:'ID',hidden:true,title:''},
	    
		{field:'Priority',title:'医嘱类型',align:'center',width:80,auto:false},
		{field:'OrderName',title:'医嘱名称',align:'left',width:240,auto:false},
		{field:'DoseQtyInfo',title:'剂量',align:'center',width:70,auto:false},
		{field:'InstrDesc',title:'用药途径',align:'center',width:60,auto:false},
		{field:'FreqDesc',title:'频率',align:'center',width:60,auto:false},
		{field:'GroupSign',title:'组符号',align:'center',width:30,auto:false,
		 styler: function(value,row,index){
 			 return 'color:red;';
		 }
		},
		{field:'SeqNo',title:'组号',align:'center',width:40,auto:false,hidden:true},
		{field:'LinkSeqNo',title:'关联组号',align:'center',width:40,auto:false,hidden:true}
	]];	

	$("#AppendAllergyOrd").datagrid({
		fit : true,
		width:1500,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		autoSizeColumn : false,
		rownumbers:false,
		rownumbers : true,
		idField:'ID',
		columns :columns,
		onCheck:function(rowIndex,rowData){
			var SeqNo=rowData.SeqNo;
			if (PageLogicObj.Order_selRowIndex!==""){
				return false;
			}
			var LinkSeqNo=rowData.LinkSeqNo;
			//var rows = $("#AppendAllergyOrd").datagrid('getData').originalRows;
	        var rows = $("#AppendAllergyOrd").datagrid('getRows');
			var NurseLinkOrderRowId=rowData.NurseLinkOrderRowId;
			//勾选主医嘱
			if (LinkSeqNo==""){
				for (var idx=0;idx<rows.length;idx++) {
					var myLinkSeqNo=rows[idx].LinkSeqNo;
					if ((myLinkSeqNo==SeqNo)){
						PageLogicObj.Order_selRowIndex=idx;
						$("#AppendAllergyOrd").datagrid('checkRow',idx);
					}
				}
			}else { //勾选子医嘱
				var MasterrowIndex="";
				for (var idx=0;idx<rows.length;idx++) {
					var myLinkSeqNo=rows[idx].LinkSeqNo;
					var mySeqNo=rows[idx].SeqNo;
					if ((myLinkSeqNo=="")&&(mySeqNo==LinkSeqNo)){
						MasterrowIndex=idx;
					}
				}
				if (MasterrowIndex>=0){
					$("#AppendAllergyOrd").datagrid('checkRow',MasterrowIndex);
				}
			}
			PageLogicObj.Order_selRowIndex="";
		},
		onUncheck:function(rowIndex,rowData){
			var SeqNo=rowData.SeqNo;
			if (PageLogicObj.Order_selRowIndex!==""){
				return false;
			}
			var LinkSeqNo=rowData.LinkSeqNo;
			//var rows = $("#AppendAllergyOrd").datagrid('getData').originalRows;
	        var rows = $("#AppendAllergyOrd").datagrid('getRows');
			var NurseLinkOrderRowId=rowData.NurseLinkOrderRowId;
			//勾选主医嘱
			if (LinkSeqNo==""){
				for (var idx=0;idx<rows.length;idx++) {
					var myLinkSeqNo=rows[idx].LinkSeqNo;
					if ((myLinkSeqNo==SeqNo)){
						PageLogicObj.Order_selRowIndex=idx;
						$("#AppendAllergyOrd").datagrid('uncheckRow',idx);
					}
				}
			}else { //勾选子医嘱
				var MasterrowIndex="";
				for (var idx=0;idx<rows.length;idx++) {
					var myLinkSeqNo=rows[idx].LinkSeqNo;
					var mySeqNo=rows[idx].SeqNo;
					if ((myLinkSeqNo=="")&&(mySeqNo==LinkSeqNo)){
						MasterrowIndex=idx
					}
				}
				if (MasterrowIndex>=0){
					$("#AppendAllergyOrd").datagrid('uncheckRow',MasterrowIndex);
				}
			}
			PageLogicObj.Order_selRowIndex="";
		}
    });
	$.q({
	    ClassName : "web.DHCOEOrderGuideAllergy",
	    QueryName : "QueryAppendAllergyOrd",
	    EpisodeID:ServerObj.EpisodeID,
		ArcimRowId:ServerObj.ArcimRowId,
		OrderStartDateStr:ServerObj.OrderStartDateStr,
	    Pagerows:$("#AppendAllergyOrd").datagrid("options").pageSize,rows:99999
	},function(GridData){
		$("#AppendAllergyOrd").datagrid('uncheckAll').datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
	
	return;
}
function InitAppendEvent(){
	$("#AppendOKBtn").click(AppendOKClickHandler);
	$("#AppendCancelBtn").click(AppendCancelClickHandler);
}

function AppendOKClickHandler(){
	var SelOrdRowArr=$("#AppendAllergyOrd").datagrid('getChecked');
	if (SelOrdRowArr.length==0){
		$.messager.alert("提示","没有勾选医嘱!")
		return false;
	}
	var SelSeqNoStr="";
	for (var idx=0;idx<SelOrdRowArr.length;idx++) {
		var SeqNo=SelOrdRowArr[idx].SeqNo;
		if (("^"+SelSeqNoStr+"^").indexOf("^"+SeqNo+"^")>=0){
			continue
		}
		if (SelSeqNoStr==""){
			SelSeqNoStr=SeqNo
		}else{
			SelSeqNoStr=SelSeqNoStr+"^"+SeqNo
		}
	}
	if (SelSeqNoStr.indexOf("^")>=0){
		$.messager.alert("提示","请勿选择多组医嘱!")
		return false;
	}
	
	SetLayOutReturnValue(SelSeqNoStr);
}
function AppendCancelClickHandler(){
	var rtnValue="";
	SetLayOutReturnValue(rtnValue);
}
function SetLayOutReturnValue(rtnValue){
	if (websys_showModal("options").CallBackFunc) {
		websys_showModal("options").CallBackFunc(rtnValue);
	}else{
		window.returnValue=rtnValue;
		window.close();
	}
}

function InitGuide(){
	
	$.cm({
		ClassName:"web.DHCOEOrderGuideAllergy",
		MethodName:"GetGuideAllergyTableJson",
		EpisodeID:ServerObj.EpisodeID,
		ArcimRowId:ServerObj.ArcimRowId,
		OrderStartDateStr:ServerObj.OrderStartDateStr
	},function(AllergyTableJson){
		var SkinMsg=AllergyTableJson.SkinMsg;
		var PatAllergType=SkinMsg.split("^")[0];
		var PatAllergInfo=SkinMsg.split("^")[1];
		var SkinDesensitFlag=SkinMsg.split("^")[2];
		var SkinNoTestFlag=SkinMsg.split("^")[3];
		//皮试结果阳性且不允许脱敏治疗时，禁用治疗按钮
		if ((PatAllergType=="PositiveSkin")&&(SkinDesensitFlag!="Y")){
			$('#TreatBtn').linkbutton('disable');
			$("#TreatBtn").attr({title:"皮试结果阳性且不允许脱敏治疗"});
		}
		//无阴性结果/用药记录可以开立治疗医嘱 
		if ((ServerObj.EntryTreatOrdWhenNotHaveSkinOrd=="0")&&((PatAllergType!="NegativeSkin")&&(PatAllergType.indexOf("Treat")==-1))){
			$('#TreatBtn').linkbutton('disable');
			$("#TreatBtn").attr({title:"无阴性结果/用药记录"});
		}
		//无皮试医嘱且允许免试的情况下，才放开免试勾选的控制
		if ((PatAllergType=="NotSkinOrd")&&(SkinNoTestFlag=="Y")){
			$HUI.checkbox("#MSCheck").enable();
		}else{
			$("#MSCheck").next().attr({title:"无皮试医嘱且配置允许免试的情况时才允许使用免试选项"});
		}
		$("#PatAllergInfo").html(PatAllergInfo);
		//初始化简易表格列表
		var Length=AllergyTableJson.GuideAllergyTable.length;
		for (var i=0;i<Length;i++){
			buildTable(AllergyTableJson.GuideAllergyTable[i]);
		}
	});
}
function InitGuideEvent(){
	$("#SkinTestBtn").click(SkinTestClickHandler);
	$("#TreatBtn").click(TreatClickHandler);
	$("#ExitBtn").click(ExitBtnClickHandler);
	
}
function SkinTestClickHandler(){
	SetReturnValue("SkinTest");
}
function TreatClickHandler(){
	var options=$('#TreatBtn').linkbutton('options');
	if ((typeof options.disabled !="undefined")&&(options.disabled==true)){
		return
	}
	SetReturnValue("Treat");
}
function ExitBtnClickHandler(){
	SetReturnValue("Exit");
}
function SetReturnValue(GuideAllergyType){
	if ($("#MSCheck").checkbox('getValue')){
		var MSCheck="Y";
	}else{
		var MSCheck="N";
	}
	var rtnValue=GuideAllergyType+"^"+MSCheck;
	SetLayOutReturnValue(rtnValue);
}
function buildTable(data){
	var panel=$("#ItemIframeTemplate");
	var temp=$("#templtable-div");
	var tool=temp.clone();
	tool.removeAttr("style").removeAttr("id");
	tool.attr("id",data["id"]+"Panle");
	
	panel.append(tool);
	var oneHeight=47; 
	var dataLen=data["rows"].length;
	if (dataLen<=1){
		var PanelMaxHeight=oneHeight*3;
	}else{
		var PanelMaxHeight=oneHeight*(data["rows"].length-1)+100;  //oneHeight*(data["rows"].length+1);
	}
	
	tool.height(PanelMaxHeight);
	
	var columns=new Array();
	var head=data["head"];	
	for(var i=0,len=head.length;i<len;++i){
		var field=data["rowCols"][i].data;
		var title=head[i];
		if (field==title){
			columns.push({"field":field,"title":title,"hidden":true});
		}else{
			columns.push({"field":field,"title":title})
		}
	}
	var newcolumns=new Array();
	newcolumns.push(columns);
	var content='<table class="simplydatagrid" data-options="headerCls:'+"'panel-header-gray'"+'" id="'+data["id"]+'"></table> ' //hisui-datagrid
	tool.append(content);
	if (data["titleClass"]=="") data["titleClass"]="panel-header-gray";
	var title=data["title"];
	
	var tableId=data["id"];
	$("#"+data["id"]).simplydatagrid({
		title:title,
		headerCls:data["titleClass"],
		id:data["id"],
		idField:'ID',
		columns: newcolumns,
		data:data["rows"],
		border:false,
		onCheck:function(index, row){
		},
		onUncheck: function(index, row){
		}
	 });
}