$(function(){
	InitOrdList();
	UpdateOrdListDataCount();
})
function InitOrdList(){
	if (ServerObj.DisplayType == "MJ") {
		var toolBar=[{
            text: '打印麻精一',
            iconCls: 'icon-print',
            handler: function() {
	            PrintMJ();
	        }
        },{
	        text: '打印精二',
            iconCls: 'icon-print',
            handler: function() {
	            PrintJ2();
	        }
	    },{
		    text: '打印',
            iconCls: 'icon-print',
            handler: function() {
	            Print();
	        }
		}];
	}else{
		var toolBar=[{
            text: '打印',
            iconCls: 'icon-print',
            handler: function() {
	            
	        }
        }];
	}
	var OrdListColumns=[[
		{field: 'Check',checkbox:true},
		{ field: 'ARCIMRowId', hidden:true}, 
		{ field: 'UserAddID', hidden:true},
		{ field: 'OEItemID', hidden:true},
		{ field: 'OEItemDR', hidden:true},
		/*6-10*/
		{ field: 'ReLocID', hidden:true},
		{ field: 'PHFreq',hidden:true},
		{ field: 'OrderPrintFlag', title:'打印',width:40},
		{ field: 'ArcimDesc', title:'医嘱名称',width:170,
			formatter:function(value,rec){ //OrderPrescNoclick
				if ((rec.OEItemDR =="")&&(rec.rescTitle !="")&&(ServerObj.DisplayType == "MJ")){
	    			return "<font color=red>【"+rec.PrescTitle+"】</font>"+value;
	    		}else if (rec.OEItemDR !=""){
		    		return "&nbsp&nbsp&nbsp&nbsp"+value;
		    	}
	    		return value;
      		}
		},
		{ field: 'OrdBilled', title:'计费状态',hidden:true},
		/*11-15*/
		{ field: 'OrdStatus', title:'状态', width: 50},
		{ field: 'DoseQty', title:'单次剂量', width: 80},
		{ field: 'DoseUnit', title:'单位', width: 50},
		{ field: 'PHFreqDesc', title:'频次', width: 100},
		{ field: 'Instr', title:'用法', width: 100},
		/*16-20*/
		{ field: 'Dura', title:'疗程', width: 50},
		{ field: 'OrderPrescNo', title:'处方号', width: 120,
			formatter:function(value,rec){ //OrderPrescNoclick
	    		var btn = '<a class="editcls" onclick="OrderPrescNoLinkDiag(\''+rec.OrderPrescNo +'\')">'+rec.OrderPrescNo+'\</a>';
	    		return btn;
      		}
		},
		{ field: 'ArcPrice', title:'单价/元', width: 70},
		//{ field: 'Pqty', title:'数量', width: 50},
		{ field: 'OrderPackQty', title:'数量', width: 50},
		{ field: 'PackUOMDesc', title:'单位', width: 80},
		{ field: 'DMdsstatus', title:'发药状态', width: 80,
				styler: function(value,row,index){
					if (value="已发"){
						return 'background-color:#F16D56;border-radius: 0px;color:#FFF;';
					}
					if (value="未发"){
						return 'background-color:#27B66B;border-radius: 0px;color:#FFF;';
					}
					if (value="已退药"){
						return 'background-color:#F05AD7;border-radius: 0px;color:#FFF;';
					}
				},
				formatter: function(value,row,index){
					return value;
				}

		},
		/*21-25*/
		{ field: 'ReLoc', title:'接收科室', width: 120},
		{ field: 'UserAdd', title:'开医嘱人', width: 100},
		{ field: 'OrderSum', title:'金额', width: 50},
		{ field: 'OrderType', title:'医嘱类型', width: 30,hidden:true},
		{ field: 'OrdDepProcNotes', title:'备注', width: 50},
		/*26-*/ 
		{ field: 'AdmReason', title:'费别', width: 70},
		{ field: 'Priority', title:'医嘱类型', width: 80},
		{ field: 'OrdStartDate', title:'开始日期', width: 100},
		{ field: 'OrdStartTime', title:'开始时间', width: 80}
	]];
	OrdListDataGrid=$('#tabOrdList').datagrid({
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		multiselect:true,
		singleSelect : false,		///可以多选
		checkOnSelect:false,		///单击行时选择复选框
		fitColumns : false, 			//为true时 不显示横向滚动条
		selectOnCheck : false,	///如果为true，单击复选框将永远选择行。如果为false，选择行将不选中复选框。
		singleSelect : false,		///如果为true，则只允许选择一行。
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : false,  //
		idField:"OEItemID",
		toolbar :toolBar,
		columns :OrdListColumns,
		onClickRow:function(rowIndex, rowData){
			OrdListSelectedRow=rowIndex
		},
		onCheck:function(rowIndex, rowData){
			var PrescNo=rowData.OrderPrescNo
			if (PrescNo=="") {return}
			var OrdList=$('#tabOrdList').datagrid('getData')
			for (var i=0;i<OrdList.rows.length;i++) {
				var myPrescNo=OrdList.rows[i].OrderPrescNo
				var myOEItemID=OrdList.rows[i].OEItemID
				if (rowIndex==i) {continue}
				
				if (myPrescNo==PrescNo){
					///先判断是否已经选中
					var FindCheckAlready=0
					var Checked=$('#tabOrdList').datagrid('getChecked')
					for (var k=0;k<Checked.length;k++) {
						var TmpOEItemID=Checked[k].OEItemID
						if (TmpOEItemID==myOEItemID){
							FindCheckAlready=1
						}
					}
					if (FindCheckAlready==1){continue}
					$('#tabOrdList').datagrid('checkRow',i)
				}
			}
		},
		onUncheck:function(rowIndex, rowData){
			var PrescNo=rowData.OrderPrescNo
			if (PrescNo=="") {return}
			var OrdList=$('#tabOrdList').datagrid('getData')
			for (var i=0;i<OrdList.rows.length;i++) {
				var myPrescNo=OrdList.rows[i].OrderPrescNo
				var myOEItemID=OrdList.rows[i].OEItemID
				if (rowIndex==i) {continue}
				if (myPrescNo==PrescNo){
					///先判断是否已经选中
					var FindCheckAlready=1
					var Checked=$('#tabOrdList').datagrid('getChecked')
					for (var k=0;k<Checked.length;k++) {
						var TmpOEItemID=Checked[k].OEItemID
						if (TmpOEItemID==myOEItemID){
							FindCheckAlready=0
						}
					}
					if (FindCheckAlready==1){continue}
					$('#tabOrdList').datagrid('uncheckRow',i)
				}
			}
		},
		onSelect:function(rowIndex, rowData){
			////选中时加载树结构，只显示该树结构
			var PrescNo=rowData.OrderPrescNo;
			var OEItemID=rowData.OEItemID;
			if (PrescNo!=""){
				var OrdList=$('#tabOrdList').datagrid('getData')
				for (var i=0;i<OrdList.rows.length;i++) {
					var myPrescNo=OrdList.rows[i].OrderPrescNo
					var myOEItemID=OrdList.rows[i].OEItemID
					if (rowIndex==i) {continue}
					if (myPrescNo==PrescNo){
						var FindSelAlready=1
						var SelectedList=$('#tabOrdList').datagrid('getSelections')
						for (var k=0;k<SelectedList.length;k++) {
							if (rowIndex==k) {continue}
							var TmpOEItemID=SelectedList[k].OEItemID
							if (TmpOEItemID==myOEItemID){
								FindSelAlready=0
							}
						}
						if (FindSelAlready==0){continue}
						$('#tabOrdList').datagrid('selectRow',i)
					}
				}
			}
		},
		onUnselect:function(rowIndex, rowData){
			////选中时加载树结构，只显示该树结构
			var PrescNo=rowData.OrderPrescNo;
			var OEItemID=rowData.OEItemID;
			if (PrescNo!=""){
				var OrdList=$('#tabOrdList').datagrid('getData')
				for (var i=0;i<OrdList.rows.length;i++) {
					var myPrescNo=OrdList.rows[i].OrderPrescNo
					var myOEItemID=OrdList.rows[i].OEItemID
					if (rowIndex==i) {continue}
					if (myPrescNo==PrescNo){
						var FindSelAlready=0
						var SelectedList=$('#tabOrdList').datagrid('getSelections')
						for (var k=0;k<SelectedList.length;k++) {
							if (rowIndex==k) {continue}
							var TmpOEItemID=SelectedList[k].OEItemID
							if (TmpOEItemID==myOEItemID){
								FindSelAlready=1
							};
						}
						if (FindSelAlready==0){continue}
						$('#tabOrdList').datagrid('unselectRow',i)
					}
				}
			}
		},
		onLoadSuccess:function(data){
			var OrderPrescNoArr=[];
			var UnPrintCount=0;
			var Length=data.rows.length;
			for (var i=0;i<Length;i++) {
				var PrintFlag=data.rows[i].OrderPrintFlag;
				var OrdBilled=data.rows[i].OrdBilled;
				var OrderPrescNo=data.rows[i].OrderPrescNo;
				if ((PrintFlag!="Y")&&(OrdBilled!="已收费")){
					$('#tabOrdList').datagrid('checkRow',i);
					if (!OrderPrescNoArr[OrderPrescNo]) UnPrintCount++;
					OrderPrescNoArr[OrderPrescNo]=1;
				}
			}
			if (parent.UpdateOneTabsTile){
				parent.UpdateOneTabsTile(UnPrintCount);
			}
			var Columns=$('#tabOrdList').datagrid('options').columns
			$.each(Columns[0],function(n,value){
		        if (data.PAAdmType=="I"){
		            if (("^9^10^17^22^25^").indexOf("^"+n+"^")>=0){
			        	this.hidden=true;
			        }
		        }else{
			    	 if (("^26^27^28^").indexOf("^"+n+"^")>=0){
			        	this.hidden=true;
			        }  
			    }
		    });
		    
		}
	});
}
function LoadOrdListDataGrid()
{
	var SearchDate="";
	if($("#SearchDate").length > 0) {
		SearchDate=$("#SearchDate").datebox('getValue');
	}
	var OutOrd="",DrgFormPoison="",CMMedFlag="N";
	if (ServerObj.DisplayType =="MJ") {
		DrgFormPoison="J1^DM^DX^MZ";
	}else if (ServerObj.DisplayType =="CM"){
		CMMedFlag="Y";
	}else if (ServerObj.DisplayType =="OUT") {
		OutOrd="on";
	}
	$.cm({
	    ClassName : "web.DHCDocIPDocPrescPrint",
	    MethodName : "GetOrdDataJsonByAdm",
	    EpisodeID:ServerObj.EpisodeID, 
	    SearchStartDate:SearchDate, SearchEndDate:SearchDate, 
	    OutOrd:OutOrd, DrgFormPoison:DrgFormPoison,
	    CMMedFlag:CMMedFlag
	},function(GridData){
		OrdListDataGrid.datagrid('uncheckAll').datagrid('loadData',GridData);
	})
}
function UpdateOrdListDataCount(EpisodeID){
	if (!EpisodeID) EpisodeID=ServerObj.EpisodeID;
	if ((parent.UpdateTabsTile)&&(EpisodeID!="")){
		var SearchDate="";
		if($("#SearchDate").length > 0) {
			SearchDate=$("#SearchDate").datebox('getValue');
		}
		$.cm({
		    ClassName : "web.DHCDocIPDocPrescPrint",
		    MethodName : "GetIPDocPrescCatCount",
		    EpisodeID:EpisodeID,
		    SearchStartDate:SearchDate, SearchEndDate:SearchDate
		},function(data){
			parent.UpdateTabsTile(data);
		}); 
	}
}
function OrderPrescNoLinkDiag(OrderPrescNo){
	var url="dhcdocdiagnoseselect.hui.csp?EpisodeID="+ServerObj.EpisodeID+"&PrescNoStr="+OrderPrescNo+"&ExitFlag="+"Y";
	websys_showModal({
		url:url,
		title:OrderPrescNo+"关联诊断",
		width:$(window).width()-150,
		height:$(window).height()-50
	});
}
function PrintMJ(){
	var OrdList="";
	var OrdListArr=$('#tabOrdList').datagrid('getChecked');
	for (var i=0;i<OrdListArr.length;i++){
		var OEItemID=OrdListArr[i].OEItemID;
		var PrescTitle=OrdListArr[i].PrescTitle;
		if ((PrescTitle !="毒麻")&&(PrescTitle !="精一")) continue;
		if (OrdList==""){
			OrdList=OEItemID;
		}else{
			OrdList=SelectedOrder+"^"+OEItemID;
		}
	}
	if (OrdList==""){
		$.messager.alert("提示","请选择需要打印的麻精一处方!");
		return;
	}
	PrescPrintCom(OrdList);
}
function PrintJ2(){
	var OrdList="";
	var OrdListArr=$('#tabOrdList').datagrid('getChecked');
	for (var i=0;i<OrdListArr.length;i++){
		var OEItemID=OrdListArr[i].OEItemID;
		var PrescTitle=OrdListArr[i].PrescTitle;
		if (PrescTitle !="精二") continue;
		if (OrdList==""){
			OrdList=OEItemID;
		}else{
			OrdList=SelectedOrder+"^"+OEItemID;
		}
	}
	if (OrdList==""){
		$.messager.alert("提示","请选择需要打印的精二处方!");
		return;
	}
	PrescPrintCom(OrdList);
}
function Print(){
	var OrdList=GetSelectedOrder();
	if (OrdList==""){
		$.messager.alert("提示","请选择需要打印的处方!");
		return;
	}
	PrescPrintCom(OrdList);
}
function GetSelectedOrder()
{
	var SelectedOrder=""
	var OrdListArr=$('#tabOrdList').datagrid('getChecked');
	for (var i=0;i<OrdListArr.length;i++){
		var OEItemID=OrdListArr[i].OEItemID;
		if (SelectedOrder==""){
			SelectedOrder=OEItemID;
		}else{
			SelectedOrder=SelectedOrder+"^"+OEItemID;
		}
	}
	return SelectedOrder;
}
function PrescPrintCom(OrdList){
	var DMPrescCount=$.cm({
		ClassName : "DHCDoc.OPDoc.TreatPrint",
		MethodName : "GetDMPrescCount",
		OrdItemList:OrdList,
		dataType:"text"
	},false)
	if (DMPrescCount>0){
		$.messager.confirm('确认对话框', '毒麻处方需要红纸打印，请放入'+DMPrescCount+'张红色处方纸。', function(r){
			if (r){
				PrescPrint();
			}
		});
	}else{
		PrescPrint();
	}
	
	function PrescPrint(){
		var SearchDate="";
		if($("#SearchDate").length > 0) {
			SearchDate=$("#SearchDate").datebox('getValue');
		}
		var PrintType="CFZ";
		///统一使用总览打印的方法
		var jsonString=$.cm({
			ClassName:"DHCDoc.OPDoc.TreatPrint",
			MethodName:"PrescriptPrintData",
			dataType:"text",
			episodeID:ServerObj.EpisodeID,
			selectedOEItemID:OrdList,
			listFilter:"",
			PrintType:PrintType,
			type:"Print",
			StDate:SearchDate,
			EndDate:""
		},false);
		if (jsonString==""){return}
		var respData=eval('(' + jsonString+ ')');
		if($.type(respData) === "array"){
			for(var j=0,len=respData.length;j<len;++j){
				var options={
					"ReadyJson":respData[j]["data"]
				};
			    //若后台返回的xml模板名不为空,则根据返回模板展示
				if ((respData[j]["templateId"]!="")&&(respData[j]["templateId"]!=undefined)){
					options["templateId"]=respData[j]["templateId"];
				}else if ((respData[j]["PrintTemp"]!="")&&(respData[j]["PrintTemp"]!=undefined)){
					var JsontempId=$.cm({
						ClassName:"web.DHCDocPrescript",
						MethodName:"GetXMLTemplateId",
						dataType:"text",
						XMLTemplateName:respData[j]["PrintTemp"]
					},false);
					options["templateId"]=JsontempId;
				}
				opdoc.print.common.print(options);
			}
		}else{
			var options={
				"ReadyJson":respData
			};
			opdoc.print.common.print(options);
		}
		var menuSearchDate=$.cm({
			ClassName:"websys.Conversions",
			MethodName:"DateHtmlToLogical",
			dataType:"text",
			d:SearchDate
		},false);
		var menuOERalation="";
		var menuOrdList="";
		var OrdListArr=OrdList.split("^");
		for (var j=0;j<OrdListArr.length;j++){
			var LoopData=PrintType+"."+OrdListArr[j]+"||||"+menuSearchDate+String.fromCharCode(2)+"true";
			if (menuOERalation==""){
				menuOERalation=LoopData;
			}else{
				menuOERalation=menuOERalation+String.fromCharCode(1)+LoopData;
			}
			if (menuOrdList==""){
				menuOrdList=OrdListArr[j]+"||||"+menuSearchDate;
			}else{
				menuOrdList=menuOrdList+"^"+OrdListArr[j]+"||||"+menuSearchDate
			}
		}
		var rtn=$.cm({
				ClassName:"DHCDoc.OPDoc.PrintHistory",
				MethodName:"Record",
				dataType:"text",
				oeList:menuOrdList,
				menuOERalation:menuOERalation, 
				operator:"NULL",
				selectedListRows:""
			},false);
		
		LoadOrdListDataGrid();
	}
}