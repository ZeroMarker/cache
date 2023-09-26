var PageLogicObj={
}
$(function(){
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
})
function InitEvent(){
	$HUI.checkbox("#OPAdm,#IPAdm,#selAll,#NotDrug,#Drug",{
        onCheckChange:function(e,value){
	       CheckChange(e,value);
        }
    });
	$("#Copy").click(CopyClickHandler);
	$("#CopyShort").click(CopyShortClickHandler);
	$("#CopyLong").click(CopyLongClickHandler);
	$("#CopyOut").click(CopyOutClickHandler);
	$("#CopyONE").click(CopyONEClickHandler);
	$("#CopyVirLong").click(CopyVirLongClickHandler);
	$("#BFindOrd").click(loadOrdTableData);
	$("#BFindAdm").click(FindAdmClickHandler);
	$("#Patientno").keydown(PatientnoKeydown);
	$("#BSaveOrdItem").click(BSaveOrdItemClickHandler);
}
function PageHandle(){
	InitCombobox();
	//$("#StartDate").datebox('setValue',ServerObj.SttDate);
	//$("#EndDate").datebox('setValue',ServerObj.EndDate);
	$("#Patientno").val(ServerObj.Patientno);
	var AdmTimeLineExpString=""+String.fromCharCode(1)+""+String.fromCharCode(1)+"";
	LoadPatAdmTimeLine("All",AdmTimeLineExpString);
	if (ServerObj.IsCanCopyOtherPatOrd==0){
		$("#Patientno").prop("disabled",true);
	}
	
	var MenuAdm="";
	var frm = dhcsys_getmenuform();
    if (frm) {
    	MenuAdm = frm.EpisodeID.value;
    }
    if (MenuAdm!=""){
	    //有可能是检索的其他就诊记录的医嘱进行的复制，按照menu上的就诊进行判断是否展示虚拟长期按钮
		var UserEMVirtualtLong=$.cm({
		    ClassName : "web.DHCDocOrderVirtualLong",
		    MethodName : "GetUserEMVirtualtLong",
		    EpisodeID : MenuAdm,
		    dataType:"text"
		},false);
		var PAAdmType=$.cm({
		    ClassName : "web.DHCDocOrderEntry",
		    MethodName : "GetPAAdmType",
		    EpisodeID : MenuAdm,
		    dataType:"text"
		},false);
		if (UserEMVirtualtLong==0){
			$("#CopyVirLong").hide();
		}
		if (PAAdmType!="I"){
			$("#CopyLong").hide();
			$("#CopyLong").parent().hide();
			$("#CopyOut").hide();
			$("#CopyONE").hide();
		}
    }
	
	
}
function AdmChange(e){
	var id=e.target.id;
	if (id==""){
		id=$($(e.target).parents("a"))[0].id;
	}
	$(".seleted-a").removeClass("seleted-a");
	$(".selectdot").removeClass("selectdot");
	$("#"+id).addClass("seleted-a");
	$("#"+id).prev().addClass('selectdot');
	loadOrdTableData();
}
function CheckChange(e,value){
   var id=e.target.id;
   if (id=="OPAdm"){
       var cbox=$HUI.checkbox("#IPAdm");
       var IPValue=cbox.getValue();
       if (((value)&&(IPValue))||(!value)&&(!IPValue)){
	       var paraAdmType="";
	   }else{
		   if (value){var paraAdmType="O^E";}
		   else {var paraAdmType="I";}
	   }
	   ReloadPatAdmTimeLine(paraAdmType);
   }else if (id=="IPAdm"){
	   var cbox=$HUI.checkbox("#OPAdm");
       var OPValue=cbox.getValue();
       if (((value)&&(OPValue))||(!value)&&(!OPValue)){
	       var paraAdmType="";
	   }else{
		   if (value){var paraAdmType="I";}
		   else {var paraAdmType="O^E";}
	   }
	   ReloadPatAdmTimeLine(paraAdmType);
   }else if(id=="selAll"){
	   SelectAllCheckChange(value);
   }else if((id=="Drug")||(id=="NotDrug")){
	   setTimeout(function(){
		   loadOrdTableData();
	   })
   }
}
function InitCombobox(){
	//下医嘱科室
	$("#DocUserDep").combobox({
		url:$URL+"?ClassName=web.DHCDocOrderCommon&QueryName=ctloclookup&rows=99999&LogonHospDr="+session['LOGON.HOSPID'],
        mode:'remote',
        method:"Get",
		valueField: 'NO', 
		textField: 'CtLoc', 
		editable:true,
		onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{desc:desc});
	    },
	    loadFilter:function(data){
		    return data['rows'];
		},
		onSelect:function(record){
			LoadDoc(record.NO);
			if ($(".seleted-a").length==0) return;
			loadOrdTableData();
		}
	});
	//医嘱医生
	var cbox = $HUI.combobox("#DocName", {
		valueField: 'DocID',
		textField: 'DocDesc',
		onSelect:function(record){
			if ($(".seleted-a").length==0) return;
			loadOrdTableData();
		}
    });
    //医嘱类型
	var jsonData=$.q({
	    ClassName:"web.OECPriority",
	    QueryName:"LookUp",
	    desc:"",
	    page:1,  
	    rows:99999
	},false);
	var data=jsonData.rows;
	data.unshift({"Description":"全部","HIDDEN":"","Code":""})
	var cbox = $HUI.combobox("#OrdPrior", {
		valueField: 'HIDDEN',
		textField: 'Description', 
		data: data,
		onSelect:function(record){
			//if ($(".seleted-a").length==0) return;
			//loadOrdTableData();
		},
		onLoadSuccess:function(){
			var sbox = $HUI.combobox("#OrdPrior");
			//if (ServerObj.PAAdmType=="I"){
				//sbox.select(ServerObj.DefLongPriorRowid);
			//}else{
				sbox.select(""); //ServerObj.DefShortPriorRowid
			//}
		}
    });
}
function LoadDoc(LocId){
	$HUI.combobox("#DocName").clear();
	$.q({
	    ClassName:"web.DHCDocOrderCommon", 
	    QueryName:"FindLocDoc",
	    LocID:LocId,
	    DocDescIn:"",
	    page:1,  
	    rows:99999
	},function(jsonData){ 
		var cbox = $HUI.combobox("#DocName", {
			data: jsonData.rows
	    });
	});
}
function SelectAllCheckChange(checked){
	var $table=$("[id$='_TablePanle']");
	for (var i=0;i<$table.length;i++){
		var oneId=$table[i].id;
		var tableId=oneId.split("_")[0];
		if (checked){
			$("#"+tableId+"_Table").simplydatagrid('checkAll');
		}else{
			$("#"+tableId+"_Table").simplydatagrid('uncheckAll');
		}
	}
}
function ReloadPatAdmTimeLine(paraAdmType){
	var startDate=$HUI.datebox("#StartDate").getValue(); 
	var endDate=$HUI.datebox("#EndDate").getValue(); 
	AdmTimeLineExpString=startDate+String.fromCharCode(1)+endDate+String.fromCharCode(1)+paraAdmType;
	LoadPatAdmTimeLine("All",AdmTimeLineExpString);
}
function LoadPatAdmTimeLine(type,AdmTimeLineExpString){
	$.q({
	    ClassName:"web.DHCDoc.OP.EMR",
	    QueryName:"GetPatHistoryAdmList",
	    EpisodeID:ServerObj.EpisodeID, PatientID:ServerObj.PatientID, OrderBy:type, ExpString:AdmTimeLineExpString,
	    page:1,  
	    rows:99999
	},function(jsonData){ 
		createPatAdmTimeLine(jsonData);
	});
}
function createPatAdmTimeLine(data){
	if ($(".adm-list li").length>=2){
		
		$(".adm-list li:not('#admlineTemplate')").remove();
		$(".head,.foot").remove();
	}
	if (data.rows.length==0) {
		removeTable();
		return false;
	}
	var len=data.rows.length;
	var panel=$(".adm-list");
	var template=$("#admlineTemplate");
	for (var i=0;i<data.rows.length;i++){
		var AdmType=data.rows[i].AdmType; 
        var MainDiagnos=data.rows[i].MainDiagnos;
		var mode=(i+1)%5;
        if (mode==0) mode=5;
		var id=data.rows[i].AdmRowId+"_"+mode+"_"+AdmType+"_"+data.rows[i].mradm+"_"+data.rows[i].PatientID;
		var tool=template.clone();
		tool.removeAttr("style");
		tool.removeAttr("id");
		$("a",tool).attr("id",id);
		if (i==0){
			panel.append('<div class="head"></div>');
		}
		var content="";
		$(".first",tool).text("").append(data.rows[i].MainDiagnos);
		$(".second .operator",tool).text("").append(data.rows[i].AdmDate);
		$($(".second span",tool)[1]).text("").append(data.rows[i].AdmLoc);
		$(".third",tool).text("").append(data.rows[i].AdmDoc);
		panel.append(tool);
		if (i==(data.total-1)){
			panel.append('<div class="foot"></div>');
		}
	}
	if (len>0){
		if (ServerObj.EpisodeID==""){
			$($(".adm-list li a")[1]).addClass("seleted-a");
			$($(".adm-list li a")[1]).prev().addClass('selectdot');
			loadOrdTableData();
		}else{
			if ($("a[id^='"+ServerObj.EpisodeID+"']").length==0){
				$($(".adm-list li a")[1]).addClass("seleted-a");
				$($(".adm-list li a")[1]).prev().addClass('selectdot');
				loadOrdTableData();
			}else{
				$("a[id^='"+ServerObj.EpisodeID+"']").addClass("seleted-a");
				$("a[id^='"+ServerObj.EpisodeID+"']").prev().addClass('selectdot');
				loadOrdTableData();
			}
		}
		$(".adm-list li a").click(function(e){
		    AdmChange(e);
		});
	}
}
function AdmTimeLineClick(id){
	$(".seleted-a").removeClass("seleted-a");
	$(".selectdot").removeClass("selectdot");
	$("#"+id).addClass("seleted-a");
	$("#"+id).prev().addClass('selectdot');
	loadOrdTableData();
}
function loadOrdTableData(){
	$(".no-data").hide();
	var id=$(".seleted-a")[0].id;
	var episodeID=id.split("_")[0];
	var AdmType=id.split("_")[2];
	$("#layout-opordlist,#frameIPOrdList").hide();
    if (AdmType=="I"){
	    $("#frameIPOrdList").show();
	    if ($("#frameIPOrdList").attr('src')=="about:blank"){
		    if (ServerObj.isNurseLogin=="1"){
		    	$("#frameIPOrdList").attr('src',"ipdoc.patorderviewnurse.csp?PageShowFromWay=ShowFromOrdCopy&EpisodeID=" +episodeID+"&DefaultOrderPriorType=S");
		    }else{
			    $("#frameIPOrdList").attr('src',"ipdoc.patorderview.csp?PageShowFromWay=ShowFromOrdCopy&EpisodeID=" +episodeID+"&DefaultOrderPriorType=S");
			}
		}else{
			var mradm=id.split("_")[3];
			var patientid=id.split("_")[4]; //{adm:episodeID,mradm:mradm,patientid:patientid}
			$("#frameIPOrdList")[0].contentWindow.ipdoc.patord.view.xhrRefresh(episodeID);
			//$("#frameIPOrdList")[0].contentWindow.ipdoc.patord.view.ReLoadGridDataFromOrdEntry("","");
		}
	}else{
		$("#layout-opordlist").show();
		$.cm({
			ClassName:"DHCDoc.OPDoc.CopyOrderItemList",
			MethodName:"QueryOEForCopyJson",
			episodeID:episodeID,
			GroupRowId:session['LOGON.GROUPID'],
			PriorID:$("#OrdPrior").combobox('getValue'),
			CTLOCRowId:$("#DocUserDep").combobox('getValue'),
			DocNameID:$("#DocName").combobox('getValue'),
			Drug:$("#Drug").checkbox('getValue')?'on':'',
			notDrug:$("#NotDrug").checkbox('getValue')?'on':'',
			rows:99999
		},function(jsonData){
			removeTable();
			var len=jsonData.length;
			if (len==0) {
				$(".no-data").show();
			}else{
				for (var m=0;m<len;m++){
					buildTable(jsonData[m]);
				}
			}
			/*var len=jsonData.length;
			if (len==0) {
				$(".no-data").show();
			}else{
				var RanderTable=function (i){
						setTimeout(function(){
							buildTable(jsonData[i]);
							i++;
							if (i<len){
								RanderTable(i);
							}
						})
				}
				RanderTable(0);
			}*/
		});
	}
}
function removeTable(){
	var $table=$("[id$='_TablePanle']");
		$table.remove();
}
var selRowIndex="";
var ordItemTableTemplate=$("#ordItemTableTemplate");
var panel=$("#OrdTableList");
var OrdTableListTempl=$("#OrdTableListTempl");
function buildTable(data){
	if ($("#"+data["id"]).length>0) return;
	var temp=OrdTableListTempl.clone();
	temp.removeAttr("style").removeAttr("id");
	temp.attr("id",data["id"]+"Panle");
	panel.append(temp);
	var oneHeight=35; 
	var dataLen=data["rows"].length;
	if (dataLen<=1){
		var PanelMaxHeight=125;
	}else{
		var PanelMaxHeight=oneHeight*(data["rows"].length)+90; //+100
	}
	//temp.height(PanelMaxHeight);
	temp.css({
		"height":PanelMaxHeight,
		"overflow-x":"auto",
		"overflow-y":"hidden"
	});
	var config=data["config"];
	var columns=new Array();
	var head=data["head"];	
	for(var i=0,len=head.length;i<len;++i){
		var field=data["rowCols"][i].data;
		var header=head[i];
		var title=header.split(":")[0];
		var width=header.split(":")[1];
		if (width=="") width=40;
		var isHidden=data["HiddenCols"][i][field];
		if (field=="OrderSkinTest"){
			columns.push({"field":field,"title":title,"width":width,formatter:function(value,row,index){
				var rtn='<input type="checkbox" disabled';
				if (value=="Y"){
					rtn=rtn+' checked="checked">'
				}else{
					rtn=rtn+'>';
				}
				return rtn;
			}})
		}else{
			if (config["checkHeaders"] && config["checkHeaders"][i]){
				columns.push({"field":field,"title":title,"checkbox":true,"width":width})
			}else{
				if (isHidden=="Y"){
					columns.push({"field":field,"title":title,"hidden":true,"width":0});
				}else{
					columns.push({"field":field,"title":title,"width":width});
				}
			}
		}
	}
	var newcolumns=new Array();
	newcolumns.push(columns);
	var content='<table class="simplydatagrid" id="'+data["id"]+'"></table>' //class="hisui-datagrid"
	temp.append(content);
	if (data["titleClass"]=="") data["titleClass"]="panel-header-gray";
	$("#"+data["id"]).simplydatagrid({
	   title:data["title"],
	   headerCls:data["titleClass"],
	   id:data["id"],
	   idField:'OrderItemRowid',
	   columns: newcolumns,
	   data:data["rows"],
	   border:false,
	   rowStyler:function(rowIndex, rowData){
 			if (rowData["OrderStatusRowid"]==ServerObj.DCStatusRowId){
	 			return 'background-color:deepskyblue;';
	 		}
	   },
	   onCheck:function(index, row){
		   var OrderItemInValid=row["OrderItemInValid"];
			if (OrderItemInValid=="1"){return false;}
			var selOrderSeqNo=row["OrderSeqNo"];
			var MasterOrderSeqNo=selOrderSeqNo.split(".")[0];
			/*if (selOrderSeqNo.indexOf(".")>=0){
				var MasterOrderSeqNo=selOrderSeqNo.split(".")[0];
				var MasterrowIndex=$("#"+data["id"]).simplydatagrid('getRowIndex',row['LinkOrderItem']);
				$("#"+data["id"]).simplydatagrid('checkRow',MasterrowIndex);
			}else{
				var GridData=$("#"+data["id"]).simplydatagrid("getRows");
				for (var i=index+1;i<GridData.length;i++){
					var OrderSeqNo=GridData[i]["OrderSeqNo"];
					if (OrderSeqNo.indexOf(".")>=0) OrderSeqNo=OrderSeqNo.split(".")[0];
					if (OrderSeqNo==selOrderSeqNo){
						var OrderItemInValid=GridData[i]["OrderItemInValid"];
						if (OrderItemInValid!="1"){
							$("#"+data["id"]).simplydatagrid('checkRow',i);
						}
					}
				}
			}*/
			var GridData=$("#"+data["id"]).simplydatagrid("getRows");
			for (var i=0;i<GridData.length;i++){
				var OrderSeqNo=GridData[i]["OrderSeqNo"];
				if (OrderSeqNo.split(".")[0]==MasterOrderSeqNo){
					var OrderItemInValid=GridData[i]["OrderItemInValid"];
					if (OrderItemInValid!="1"){
						$("#"+data["id"]).simplydatagrid('checkRow',i);
					}
				}
			}
	   },
		onUncheck: function(index, row){
			var OrderItemInValid=row["OrderItemInValid"];
			if (OrderItemInValid=="1"){return false;}
			var selOrderSeqNo=row["OrderSeqNo"];
			var MasterOrderSeqNo=selOrderSeqNo.split(".")[0];
			/*if (selOrderSeqNo.indexOf(".")>=0){
				var MasterrowIndex=$("#"+data["id"]).simplydatagrid('getRowIndex',row['LinkOrderItem']);
				$("#"+data["id"]).simplydatagrid('uncheckRow',MasterrowIndex);
			}else{
				var GridData=$("#"+data["id"]).simplydatagrid("getRows");
				for (var i=index+1;i<GridData.length;i++){
					var OrderSeqNo=GridData[i]["OrderSeqNo"];
					if (OrderSeqNo.indexOf(".")>=0) OrderSeqNo=OrderSeqNo.split(".")[0];
					if (OrderSeqNo==selOrderSeqNo){
						var OrderItemInValid=GridData[i]["OrderItemInValid"];
						if (OrderItemInValid!="1"){
							$("#"+data["id"]).simplydatagrid('uncheckRow',i);
						}
					}
				}
			}*/
			var GridData=$("#"+data["id"]).simplydatagrid("getRows");
			for (var i=0;i<GridData.length;i++){
				var OrderSeqNo=GridData[i]["OrderSeqNo"];
				if (OrderSeqNo.split(".")[0]==MasterOrderSeqNo){
					var OrderItemInValid=GridData[i]["OrderItemInValid"];
					if (OrderItemInValid!="1"){
						$("#"+data["id"]).simplydatagrid('uncheckRow',i);
					}
				}
			}
		}
	 });
	/*$("#"+data["id"]).datagrid({
		title:data["title"],
		headerCls:data["titleClass"],
		fit : true,
		border : false,
		striped : false,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		autoSizeColumn : false,
		rownumbers:false,
		pagination : false,  
		idField:'OrderItemRowid',
		columns :newcolumns,
		data:data["rows"],
		rowStyler:function(rowIndex, rowData){
 			if (rowData["OrderStatusRowid"]==ServerObj.DCStatusRowId){
	 			return 'background-color:deepskyblue;';
	 		}
		},
		onCheck:function(index, row){
			if (selRowIndex!="") return false;
			var OrderItemInValid=row["OrderItemInValid"];
			if (OrderItemInValid=="1"){return false;}
			var selOrderSeqNo=row["OrderSeqNo"];
			if (selOrderSeqNo.indexOf(".")>=0){
				var MasterrowIndex=$("#"+data["id"]).datagrid('getRowIndex',row['LinkOrderItem']);
				$("#"+data["id"]).datagrid('checkRow',MasterrowIndex);
			}else{
				var GridData=$("#"+data["id"]).datagrid("getData");
				for (var i=index+1;i<GridData.rows.length;i++){
					var OrderSeqNo=GridData.rows[i]["OrderSeqNo"];
					if (OrderSeqNo.indexOf(".")>=0) OrderSeqNo=OrderSeqNo.split(".")[0];
					if (OrderSeqNo==selOrderSeqNo){
						var OrderItemInValid=GridData.rows[i]["OrderItemInValid"];
						if (OrderItemInValid!="1"){
							selRowIndex=i;
							$("#"+data["id"]).datagrid('checkRow',i);
						}
					}
				}
			}
			selRowIndex="";
		},
		onUncheck: function(index, row){
			if (selRowIndex!="") return false;
			var OrderItemInValid=row["OrderItemInValid"];
			if (OrderItemInValid=="1"){return false;}
			var selOrderSeqNo=row["OrderSeqNo"];
			
			if (selOrderSeqNo.indexOf(".")>=0){
				var MasterrowIndex=$("#"+data["id"]).datagrid('getRowIndex',row['LinkOrderItem']);
				$("#"+data["id"]).datagrid('uncheckRow',MasterrowIndex);
			}else{
				var GridData=$("#"+data["id"]).datagrid("getData");
				for (var i=index+1;i<GridData.rows.length;i++){
					var OrderSeqNo=GridData.rows[i]["OrderSeqNo"];
					if (OrderSeqNo.indexOf(".")>=0) OrderSeqNo=OrderSeqNo.split(".")[0];
					if (OrderSeqNo==selOrderSeqNo){
						var OrderItemInValid=GridData.rows[i]["OrderItemInValid"];
						if (OrderItemInValid!="1"){
							selRowIndex=i;
							$("#"+data["id"]).datagrid('uncheckRow',i);
						}
					}
				}
			}
			selRowIndex="";
		}
	});*/
}
function CopyClickHandler(){
	SetCopyData(1);
}
function CopyShortClickHandler(){
    SetCopyData(2);
}
function CopyLongClickHandler(){
	SetCopyData(3);
}
function CopyONEClickHandler() {
    SetCopyData(4);
}
function CopyOutClickHandler() {
	SetCopyData(5);
}
function CopyVirLongClickHandler(){
	SetCopyData(6);
}
function SetCopyData(type){
	var Copyary=new Array();
	var IsSelectFlag=false;
	var Outflag=false;
	var $table=$("[id$='_TablePanle']");
	for (var i=0;i<$table.length;i++){
		var oneId=$table[i].id;
		var tableId=oneId.split("_")[0];
		var selRows=$("#"+tableId+"_Table").simplydatagrid('getSelections');
		selRows=selRows.sort(compare('OrderItemRowid'));
		for (var j=0;j<selRows.length;j++){
			IsSelectFlag=true;
			var data=selRows[j];
			var code=data.OrderARCIMRowid;
			var OrderType=data.OrderType;
			if((type==5)&&(OrderType!="R")){
				Outflag=true;
				$.messager.alert("提示","非药品医嘱不允许复制为出院带药医嘱");
			}
			var OrderPrior=data.OrderPrior;
			var OrderPriorRowid=data.OrderPriorRowid;
			var OrderDoseQty=data.OrderDoseQty;
			if ((OrderDoseQty!="")&&(OrderDoseQty.toString().indexOf("-")>=0)){
				OrderDoseQty=OrderDoseQty.split("-")[0];
			}
			var OrderDoseUOM=data.OrderDoseUOM;
			var OrderDoseUOMRowid=data.OrderDoseUOMRowid;
			var OrderFreq=data.OrderFreq;
			var OrderFreqRowid=data.OrderFreqRowid;
			var OrderFreqFactor=data.OrderFreqFactor;
			var OrderFreqInterval=data.OrderFreqInterval;
			var OrderInstr=data.OrderInstr;
			var OrderInstrRowid=data.OrderInstrRowid;
			var OrderDur=data.OrderDur;
			var OrderDurRowid=data.OrderDurRowid;
			var OrderDurFactor=data.OrderDurFactor; //OrderPackQtyHidden,OrderPackUOMRowidHidden,OrderPackUOMHidden
			var OrderPackQty=data.OrderPackQtyHidden//data.OrderPackQty;
			if (OrderPackQty==" "){OrderPackQty=""}; 
			if (OrderPackQty!="") OrderPackQty=+OrderPackQty;
			var OrderPackUOM=data.OrderPackUOMHidden//data.OrderPackUOM;
			var OrderPackUOMRowid=data.OrderPackUOMRowidHidden //data.OrderPackUOMRowid;
			var OrderSeqNo=data.OrderSeqNo;
			var OrderBodyPartLabel=data.ReqPartId;
			var VirtualtLongFlag="N";
			if ((type==2)&&(ServerObj.DefShortPriorRowid!="")){
				OrderPrior="";
				OrderPriorRowid=ServerObj.DefShortPriorRowid;
			}
			if ((type==3)&&(ServerObj.DefLongPriorRowid!="")){
				OrderPrior="";
				OrderPriorRowid=ServerObj.DefLongPriorRowid;
			}
			if ((type == 4) && (ServerObj.DefONEPriorRowid != "")) {
				OrderPrior = "";
				OrderPriorRowid = ServerObj.DefONEPriorRowid;
			}
			if ((type == 5) && (ServerObj.DefOutPriorRowid != "")) {
				OrderPrior="";
				OrderPriorRowid = ServerObj.DefOutPriorRowid;
				
			}
			if ((type == 6) && (ServerObj.DefOutPriorRowid != "")) {
				OrderPrior="";
				OrderPriorRowid=ServerObj.DefShortPriorRowid;
				VirtualtLongFlag="Y";
			}
			var OrderActionRowid=data.OrderActionRowid;
			var OrderAction=data.OrderAction;
			var OrderSkinTest=data.OrderSkinTest;
			var OrderBillTypeRowId="";
			var OrderDepProcNote=data.OrderDepProcNote;
			var ARCOSRowid="";
			var OrderNotifyClinician=data.OrderNotifyClinician;
			var OrdSpeedFlowRate=data.OrdSpeedFlowRate;
			var OrderFlowRateUnit=data.OrderFlowRateUnit;
			var OrderFlowRateUnitdesc=data.OrderFlowRateUnitdesc;
			var OrdFreqTimeDoseQtyStr=data.OrderFreqTimeDoseQtyStr;
			OrdFreqTimeDoseQtyStr=OrdFreqTimeDoseQtyStr.replace(/!/g,String.fromCharCode(2));
			var ITMFreqWeekStr=data.OrderFreqDispTimeStr;
			ITMFreqWeekStr=ITMFreqWeekStr.replace(/~/g,String.fromCharCode(1));
			ITMFreqWeekStr=ITMFreqWeekStr.replace(/@/g,String.fromCharCode(2));
			var ExceedReasonID=data.ExceedReasonID;
			var ExceedReason=data.ExceedReason;
			var ItemData=code+"!"+OrderSeqNo+"!"+OrderDoseQty+String.fromCharCode(1)+OrderDoseUOM+String.fromCharCode(1)+OrderDoseUOMRowid;
			ItemData=ItemData+"^"+OrderFreq+String.fromCharCode(1)+OrderFreqRowid+String.fromCharCode(1)+OrderFreqFactor+String.fromCharCode(1)+OrderFreqInterval;
			ItemData=ItemData+"^"+OrderInstr+String.fromCharCode(1)+OrderInstrRowid;
			ItemData=ItemData+"^"+OrderDur+String.fromCharCode(1)+OrderDurRowid+String.fromCharCode(1)+OrderDurFactor;
			ItemData=ItemData+"^"+OrderPackQty+String.fromCharCode(1)+OrderPackUOM+String.fromCharCode(1)+OrderPackUOMRowid;
			ItemData=ItemData+"^"+OrderPrior+String.fromCharCode(1)+OrderPriorRowid+String.fromCharCode(1)+"";
			ItemData=ItemData+"^"+"";
			ItemData=ItemData+"^^"+""+"^"+OrderDepProcNote+"^"+""+"^"+"";
			ItemData=ItemData+"^"+OrderNotifyClinician+"^^^^"+OrdSpeedFlowRate+String.fromCharCode(1)+OrderFlowRateUnitdesc+String.fromCharCode(1)+OrderFlowRateUnit+"^"+OrderBodyPartLabel;
			
			//ItemData=ItemData+"^^^^^^"+OrderBodyPartLabel; //12-- 加急 16-SpeedFlowRate_$C(1)_FlowRateUnit_$C(1)_FlowRateUnitRowid
			ItemData=ItemData+"^"+OrderActionRowid+"^"+OrderAction+"^"+OrderSkinTest;
			ItemData=ItemData+"^"; //计费组套餐明细编号
			ItemData=ItemData+"^"+OrdFreqTimeDoseQtyStr+"^"+ITMFreqWeekStr; //同频次不同剂量、周频次
			ItemData=ItemData+"^"+ExceedReasonID+String.fromCharCode(1)+ExceedReason; //疗程超量原因
			ItemData=ItemData+"^"	//ViewBindSource
			ItemData=ItemData+"^"+VirtualtLongFlag;
			ItemData=ItemData+"!"+OrderType+"!"+OrderBillTypeRowId+"!"+"Order";
			Copyary[Copyary.length]=ItemData; //
		}
	}
	if (!IsSelectFlag) {$.messager.alert("提示","请选择要复制的医嘱");return false;}
	if (Outflag) return false;
	/*var par_win=window.opener;
	if ((par_win)&&(Copyary.length!=0)){
		par_win.AddCopyItemToList(Copyary);
	}else{
		return;
	}
	window.setTimeout("window.close();",500);*/
	if (Copyary.length!=0){
		websys_showModal("hide");
		websys_showModal('options').AddCopyItemToList(Copyary);
		websys_showModal("close");
	}
}
function compare(property){
    return function(a,b){
        var value1 = a[property].split("||")[1];
        var value2 = b[property].split("||")[1];
        return value1 - value2;
    }
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function FindAdmClickHandler(){
	var paraAdmType="";
	if ($("#IPAdm").checkbox('getValue')){
		paraAdmType="I";
	}
	if ($("#OPAdm").checkbox('getValue')){
		if (paraAdmType=="") paraAdmType="O^E";
		else paraAdmType=paraAdmType+"^O^E";
	}
	removeTable();
	ReloadPatAdmTimeLine(paraAdmType);
}
function PatientnoKeydown(e){
	var key=websys_getKey(e);
	if (key==13) {
		var PatientNo=$("#Patientno").val();
		if (PatientNo!='') {
			if (PatientNo.length<10) {
				for (var i=(10-PatientNo.length-1); i>=0; i--) {
					PatientNo="0"+PatientNo;
				}
			}
		}else{
			return false;
		}
		$("#Patientno").val(PatientNo);
		$.cm({
			ClassName:"web.DHCOPAdmReg",
			MethodName:"GetPatientIDByNo",
			PatientNo:PatientNo,
			dataType:"text"
		},function(PatientID){ 
		    if (PatientID==""){
			    $.messager.alert("提示","此登记号不存在!","info",function(){
				    $("#Patientno").focus();
				});
				return false;
			}
			removeTable();
			ServerObj.EpisodeID="";
			ServerObj.PatientID=PatientID;
			FindAdmClickHandler();
		});
	}
}
function BSaveOrdItemClickHandler(){
	var str="";
	var $table=$("[id$='_TablePanle']");
	for (var i=0;i<$table.length;i++){
		var oneId=$table[i].id;
		var tableId=oneId.split("_")[0];
		var selRows=$("#"+tableId+"_Table").simplydatagrid('getChecked'); //getSelections
		for (var j=0;j<selRows.length;j++){
			IsSelectFlag=true;
			var data=selRows[j];
			var OrderItemRowid=data.OrderItemRowid
			if (str==""){
				str=OrderItemRowid;
			}else{
				str=str+"^"+OrderItemRowid;
			}
		}
	}
	if (str==""){
		$.messager.alert("提示","请选择医嘱后再保存");
		return false;
	}
	var AddTOArcosARCIMDatas=$.cm({
	 ClassName:"DHCDoc.OPDoc.CopyOrderItemList",
		MethodName:"GetDataforCheck",
		dataType:"text",
		Str:str
	},false);
	var RtnStr=UDHCOEOrderSaveToTemplate(AddTOArcosARCIMDatas);
}
function UDHCOEOrderSaveToTemplate(AddTOArcosARCIMDatas)
{
    var XCONTEXT="WNewOrderEntry"
    var lnk="doc.ordsavetotemplate.hui.csp?Type="+"西药"+"&AddTOArcosARCIMDatas="+escape(AddTOArcosARCIMDatas)+"&XCONTEXT="+escape(XCONTEXT);
    var obj=new Object();  
    obj.name=AddTOArcosARCIMDatas; 
    /*var RtnStr=window.showModalDialog(lnk,obj,"dialogwidth:811px;dialogheight:396px;help:no;status:no;center:1;resizable:no");
    //var RtnStr=window.open(lnk,"UDHCOEOrderSaveToTemplate","dialogwidth:100;dialogheight:200;help:no;status:no;center:1;resizable:no");   
    return  RtnStr*/
    websys_showModal({
		url:lnk,
		title:'保存至医嘱模板',
		width:810,height:440,
		paraObj:obj
	})
}