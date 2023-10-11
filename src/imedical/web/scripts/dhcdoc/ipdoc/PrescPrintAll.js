var PageLogicObj={
	keywordsArr:[
		{text:'出院处方',id:'OUT'},
        {text:'毒麻处方',id:'MJ'},
        {text:'草药处方',id:'CM'}
	],
	FindCheckAlready:0,
	FindPrintCheckAlready:0,
	m_IDCredTypePlate:"01", //身份证代码字段
	EpisodeID:"",
	mradm:"",
	PatDobDate:"",
	PatSex:"",
	OrderPrescNo:""
}
$(function(){
	InitKeyWord();
	InitOrdList();
	PageHandle();
	
})
$(window).load(function() {
	setTimeout(function() { 
    	LoadOrdListDataGrid();
    }, 250);
})
function PageHandle(){
	//科室
	LoadDept(); 
	if (ServerObj.ParaType=="SideMenu"){
		$('#PatNo').attr('disabled',"true");
		$('#CardNo').attr('disabled',"true");
		$("#ReadCard").linkbutton('disable');
		$('#Patmed').attr('disabled',"true");
		$("#BClear").linkbutton('disable');
		}
}
function InitKeyWord(){
	var NewKeywordsArr=[];
	for ( var i=0;i < PageLogicObj.keywordsArr.length;i++) {
		var id=PageLogicObj.keywordsArr[i].id
		if ((("!"+ServerObj.DisplayType+"!").indexOf("!"+id+"!")) >=0) {
			NewKeywordsArr.push(PageLogicObj.keywordsArr[i]);
		}
	}
	NewKeywordsArr[0].selected=true;
	$("#redkw").keywords({
	    singleSelect:true,
	    labelCls:'red',
	    items:NewKeywordsArr,
	    onClick:function(v){
		    LoadOrdListDataGrid();
		}
	});
}
function InitOrdList(){
	var toolBar=[{
		id:"PrintMJ",
        text: '打印毒麻精一',
        iconCls: 'icon-print',
        handler: function() {
            PrintMJ();
        }
    },{
	    id:"PrintJ2",
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
	var OrdListColumns=[[
		//{field: 'Check',checkbox:true},
		{ field: 'ARCIMRowId', hidden:true}, 
		{ field: 'UserAddID', hidden:true},
		{ field: 'OEItemID', hidden:true},
		{ field: 'OEItemDR', hidden:true},
		/*6-10*/
		{ field: 'ReLocID', hidden:true},
		{ field: 'PHFreq',hidden:true},
		{ field: 'name', title:'',width:90,
			styler: function(value,row,index){
				if (value){
  					return 'background-color:#58C8B8;color:white;';
				}
			}
		},
		{ field: 'OrderPrintFlag', title:'打印',width:40},
		{ field: 'ArcimDesc', title:'医嘱名称',width:170,
			formatter:function(value,rec){
				if (!value) value="";
				if ((rec.OEItemDR =="")&&(rec.PrescTitle !="")){
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
			formatter:function(value,rec){
				if (!value) return "";
				if (value!=""){
					if ((rec.OrdStatus!="停止")&&(rec.OrdStatus!="撤销")&&(rec.OrdStatus!="作废")){
						var btn = '<a class="editcls" onclick="OrderPrescNoLinkDiag(\''+rec.OrderPrescNo +'\',\''+rec.EpisodeID +'\')">'+rec.OrderPrescNo+'\</a>';
						return btn;
					}else{
						return rec.OrderPrescNo;	
					}
		    	}
		    	return value;
      		}
		},
		{ field: 'ArcPrice', title:'单价/元', width: 70, align:'right'},
		//{ field: 'Pqty', title:'数量', width: 50},
		{ field: 'OrderPackQty', title:'数量', width: 50},
		{ field: 'PackUOMDesc', title:'单位', width: 80},
		{ field: 'DMdsstatus', title:'发药状态', width: 80,
				styler: function(value,row,index){
					if (value ==$g("已发")){
						return 'background-color:#F16D56;border-radius: 0px;color:#FFF;';
					}
					if (value ==$g("未发")){
						return 'background-color:#27B66B;border-radius: 0px;color:#FFF;';
					}
					if (value ==$g("已退药")){
						return 'background-color:#F05AD7;border-radius: 0px;color:#FFF;';
					}
				},
				formatter: function(value,row,index){
					return $g(value);
				}

		},
		/*21-25*/
		{ field: 'ReLoc', title:'接收科室', width: 120},
		{ field: 'UserAdd', title:'开医嘱人', width: 100},
		{ field: 'OrderSum', title:'金额', width: 50, align:'right'},
		{ field: 'OrderType', title:'医嘱类型', width: 30,hidden:true},
		{ field: 'OrdDepProcNotes', title:'备注', width: 50},
		/*26-*/ 
		{ field: 'AdmReason', title:'费别', width: 70},
		{ field: 'Priority', title:'医嘱类型', width: 80},
		{ field: 'OrdStartDate', title:'开始日期', width: 100},
		{ field: 'OrdStartTime', title:'开始时间', width: 80},
		{ field: 'PostionInfo', title:'毒麻信息维护', width: 120,
			formatter:function(value,rec){
		    		if ((rec.PrescTitle ==$g("毒麻"))||(rec.PrescTitle ==$g("精一"))||(rec.PrescTitle ==$g("麻、精一"))) {
		    		var btn = '<a class="editcls" onclick="PatInfoSaveClickHandler(\''+rec.OrderPrescNo +'\',\''+rec.EpisodeID +'\')">'+$g("信息维护")+'\</a>';
		    		return btn;
					}
					return "";
      		}
		},
	]];
	OrdListtreegrid=$('#tabOrdList').treegrid({
		checkbox:true,
		idField:'index',
	    treeField:'name',
	    fit : true,
	    border: false,
		toolbar :toolBar,
		columns :OrdListColumns,
		onCheckNode:function(row,checked){
			if (PageLogicObj.FindCheckAlready==1){return;}
			var PrescNo=row.OrderPrescNo;
			var parent=$('#tabOrdList').treegrid("getParent",row.index);
			if (parent) {
				var childrens=$('#tabOrdList').treegrid("getChildren",parent.index);
				for (var i=0;i<childrens.length;i++){
					if ((childrens[i].OrderPrescNo ==PrescNo)&&(childrens[i] !=row)) {
						PageLogicObj.FindCheckAlready=1;
						if (checked) {
							$('#tabOrdList').treegrid('checkNode',childrens[i].index);
						}else {
							$('#tabOrdList').treegrid('uncheckNode',childrens[i].index);
						}
					}
				}
			}
			PageLogicObj.FindCheckAlready=0;
		},
		onLoadSuccess:function(rows,data){
			var columnLen=$('#tabOrdList').treegrid('options').columns[0].length;
			for (var i=0;i<data.length;i++){
				if (!data[i].OEItemID) {
					//$('#tabOrdList').treegrid("mergeCells",{index:data[i].index,field:"name",rowspan:1,colspan:columnLen});
					var _$td=$($("#datagrid-row-r1-2-"+data[i].index+" td")[6]);
					_$td.attr("colSpan",columnLen).children("div").css({"width":"100%"});
					$("#datagrid-row-r1-2-"+data[i].index+" td:not(:eq(6))").hide();;
					$("#datagrid-row-r1-2-"+data[i].index+" .tree-title").css("font-size",'16px');
				}
			}
		}
	});
}
function LoadOrdListDataGrid()
{
	var SearchSttDate=$("#SearchSttDate").datebox('getValue');
	var SearchEndDate=$("#SearchEndDate").datebox('getValue');
	var OutOrd="",DrgFormPoison="",CMMedFlag="N";
	var keySel=$("#redkw").keywords('getSelected');
	var selId=keySel[0].id;
	if (selId =="MJ") {
		DrgFormPoison="J1^DM^DX^MZ";
	}else if (selId =="CM"){
		CMMedFlag="Y";
	}else if (selId =="OUT") {
		OutOrd="on";
	}
	var LocId=$("#Dept").combobox('getValue');
	if (!LocId) LocId="";
	var WardId=$("#Ward").combobox('getValue');
	if (!WardId) WardId="";
	var PrintSel="";
	if ($("#SelctAll").checkbox('getValue')) {
		PrintSel="SelctAll";
	}else if($("#AllUnPrint").checkbox('getValue')){
		PrintSel="AllUnPrint";
	}else if($("#AllPrinted").checkbox('getValue')){
		PrintSel="AllPrinted";
	}
	$.cm({
	    ClassName : "web.DHCDocIPDocPrescPrint",
	    MethodName : "GetOrdDataJson",
	    PatNo:$("#PatNo").val(), 
	    SearchStartDate:SearchSttDate, SearchEndDate:SearchEndDate, 
	    OutOrd:OutOrd, DrgFormPoison:DrgFormPoison,
	    CMMedFlag:CMMedFlag,LocId:LocId,WardId:WardId,PrintSel:PrintSel
	},function(JsonData){
		$('#tabOrdList').treegrid('uncheckAll').treegrid('loadData',JsonData.data);
		$("#PrintMJ,#PrintJ2").show();
		if (JsonData.MJ1Count ==0) {
			$("#PrintMJ").hide();
		}
		if (JsonData.J2Count ==0) {
			$("#PrintJ2").hide();
		} 
	})
}
function OrderPrescNoLinkDiag(OrderPrescNo,EpisodeID){
	var url="dhcdocdiagnoseselect.hui.csp?EpisodeID="+EpisodeID+"&PrescNoStr="+OrderPrescNo+"&ExitFlag="+"Y";
	websys_showModal({
		url:url,
		title:OrderPrescNo+$g("关联诊断"),
		width:$(window).width()-150,
		height:$(window).height()-50
	});
}
function PrintMJ(){
	var OrdList="";
	var OrdListArr=$('#tabOrdList').treegrid('getCheckedNodes');
	for (var i=0;i<OrdListArr.length;i++){
		var OEItemID=OrdListArr[i].OEItemID;
		if (!OEItemID) continue;
		var PrescTitle=OrdListArr[i].PrescTitle;
		if ((PrescTitle !="毒麻")&&(PrescTitle !="精一")) continue;
		if (OrdList==""){
			OrdList=OEItemID;
		}else{
			OrdList=OrdList+"^"+OEItemID;
		}
	}
	if (OrdList==""){
		$.messager.alert("提示","请选择需要打印的毒麻精一处方!");
		return;
	}
	PrescPrintCom(OrdList);
}
function PrintJ2(){
	var OrdList="";
	var OrdListArr=$('#tabOrdList').treegrid('getCheckedNodes');
	for (var i=0;i<OrdListArr.length;i++){
		var OEItemID=OrdListArr[i].OEItemID;
		if (!OEItemID) continue;
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
	var OrdListArr=$('#tabOrdList').treegrid('getCheckedNodes');
	for (var i=0;i<OrdListArr.length;i++){
		var OEItemID=OrdListArr[i].OEItemID;
		if (!OEItemID) continue;
		if (SelectedOrder==""){
			SelectedOrder=OEItemID;
		}else{
			SelectedOrder=SelectedOrder+"^"+OEItemID;
		}
	}
	return SelectedOrder;
}
function PrescPrintCom(OrdList){
	var StDate=$("#SearchSttDate").datebox('getValue');
	if (StDate =="") StDate=ServerObj.NowDate;
	var EndDate=$("#SearchEndDate").datebox('getValue');
	if (StDate =="") StDate=ServerObj.NowDate;
	var DMPrescCount=$.cm({
		ClassName : "DHCDoc.OPDoc.TreatPrint",
		MethodName : "GetDMPrescCount",
		OrdItemList:OrdList,
		StDate:StDate,
		EndDate:EndDate,
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
		var menuStDate=$.cm({
			ClassName:"websys.Conversions",
			MethodName:"DateHtmlToLogical",
			dataType:"text",
			d:StDate
		},false);
		var menuEndDate=$.cm({
			ClassName:"websys.Conversions",
			MethodName:"DateHtmlToLogical",
			dataType:"text",
			d:EndDate
		},false);
		var OrderPrescNoStr=""
		for (var date=menuStDate;date<=menuEndDate;date++){
			var NewOrdList="";
			var OrdListArr=$('#tabOrdList').treegrid('getCheckedNodes');
			for (var i=0;i<OrdListArr.length;i++){
				var OEItemID=OrdListArr[i].OEItemID;
				if (!OEItemID) continue;
				if (("^"+OrdList+"^").indexOf("^"+OEItemID+"^")<0) continue;
				var OrdStartDateHide=OrdListArr[i].OrdStartDateHide;
				var LongPriorFlag=OrdListArr[i].LongPriorFlag;
				if (LongPriorFlag ==1) {
					if (date < OrdStartDateHide) continue;
				}else{
					if (OrdStartDateHide != date) continue;
				}
				var OrderPrescNo=OrdListArr[i].OrderPrescNo;
				if ((OrderPrescNoStr.indexOf(OrderPrescNo)>=0)&&(LongPriorFlag !=1)){continue}
				var PrintType="CFZ";
				///统一使用总览打印的方法
				var jsonString=$.cm({
					ClassName:"DHCDoc.OPDoc.TreatPrint",
					MethodName:"PrescriptPrintData",
					dataType:"text",
					episodeID:ServerObj.EpisodeID,
					selectedOEItemID:OEItemID,
					listFilter:"",
					PrintType:PrintType,
					type:"Print",
					StDate:date,
					EndDate:""
				},false);
				if ((jsonString=="")||(jsonString=="[]")){continue;}
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
				var menuOERalation="";
				var menuOrdList="";
				var OrdListArrB=OrdList.split("^");
				for (var j=0;j<OrdListArrB.length;j++){
					var LoopData=PrintType+"."+OrdListArrB[j]+"||||"+date+String.fromCharCode(2)+"true";
					if (menuOERalation==""){
						menuOERalation=LoopData;
					}else{
						menuOERalation=menuOERalation+String.fromCharCode(1)+LoopData;
					}
					if (menuOrdList==""){
						menuOrdList=OrdListArrB[j]+"||||"+date;
					}else{
						menuOrdList=menuOrdList+"^"+OrdListArrB[j]+"||||"+date
					}
				}
				if (NewOrdList==""){
					NewOrdList=OEItemID;
				}else{
					NewOrdList=NewOrdList+"^"+OEItemID;
				}
				OrderPrescNoStr=OrderPrescNoStr+OrderPrescNo;
				var rtn=$.cm({
					ClassName:"DHCDoc.OPDoc.PrintHistory",
					MethodName:"Record",
					dataType:"text",
					oeList:menuOrdList,
					menuOERalation:menuOERalation, 
					operator:"NULL",
					selectedListRows:""
				},false);
			}
		}
		LoadOrdListDataGrid();
	}
}
function LoadDept(){
	$.cm({
		ClassName:"web.DHCExamPatList",
		QueryName:"ctloclookup",
	   	desc:"",hospid:session['LOGON.HOSPID'],
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#Dept", {
				valueField: 'ctlocid',
				textField: 'ctloc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["ctloc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onSelect: function(rec){  
					LoadWard(); 
				},
				onChange:function(newValue,oldValue){
					if (newValue==""){
						LoadWard();
					}
				}
		 });
		 LoadWard();
	});
}
function LoadWard(){
	var LocId=$("#Dept").combobox('getValue');
	$.cm({
		ClassName:"web.DHCExamPatList",
		QueryName:"GetWardMessage",
		desc:"", luloc:LocId,
		HospID:session['LOGON.HOSPID'],
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#Ward", {
				valueField: 'HIDDEN', 
				textField: 'Ward', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["Ward"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onLoadSuccess:function(data){
					if ((data.length>0)&&(LocId!="")){
						$(this).combobox('select',data[0]['HIDDEN']);
					}else{
						SetDefaultWard();
					}
				}
		 });
	});
}
function SetDefaultWard(){
	var LocId=$("#Dept").combobox('getValue');
	if (LocId!=""){
		$("#Ward").combobox('select','');
		return;
	}
	var rtn=$.cm({
		ClassName:"web.DHCExamPatList",
		MethodName:"GetDefaultWard",
		PatNo:"", WardID:"", Name:"",EpisodeID:GetMenuPara("EpisodeID"),
		dataType:"text"
	},false);
	if (rtn!=""){
		$("#Ward").combobox('setValue',rtn.split("^")[1]);
	}
}
var FindCheckAlready=0;
function PrintSelCheckChange(e,value){
	if (PageLogicObj.FindPrintCheckAlready ==1) return;
	var CurId=e.target.id;
	if (value) {
		var _$PrintSel=$("input[name='PrintSel']");
		for (var i=0;i<_$PrintSel.length;i++){
			if (_$PrintSel[i].id !=CurId) {
				PageLogicObj.FindPrintCheckAlready=1;
				$(_$PrintSel[i]).checkbox("uncheck");
			}
		}
	}
	PageLogicObj.FindPrintCheckAlready =0;
	if (CurId =="SelctAll") {
		var roots=$('#tabOrdList').treegrid("getRoots");
		for (var i=0;i<roots.length;i++){
			if (value) {
				$('#tabOrdList').treegrid('checkNode',roots[i].index);
			}else{
				$('#tabOrdList').treegrid('uncheckNode',roots[i].index);
			}
		}
		
	}else if( CurId=="AllUnPrint"){
		var roots=$('#tabOrdList').treegrid("getRoots");
		for (var i=0;i<roots.length;i++){
			var childrens=roots[i].children;
			for (var j=0;j<childrens.length;j++){
				if (value) {
					if (childrens[j].OrderPrintFlag =="Y"){
						$('#tabOrdList').treegrid('uncheckNode',childrens[j].index);
					}else{
						$('#tabOrdList').treegrid('checkNode',childrens[j].index);
					}
				}
			}
			
		}
	}else if( CurId=="AllPrinted"){
		var roots=$('#tabOrdList').treegrid("getRoots");
		for (var i=0;i<roots.length;i++){
			var childrens=roots[i].children;
			for (var j=0;j<childrens.length;j++){
				if (value) {
					if (childrens[j].OrderPrintFlag =="Y"){
						$('#tabOrdList').treegrid('checkNode',childrens[j].index);
					}else{
						$('#tabOrdList').treegrid('uncheckNode',childrens[j].index);
					}
				}
			}
		}
	}
}
function LoadCredType(){
	var Data=$.m({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"ReadCredTypeExp",
		JSFunName:"GetCredTypeToHUIJson",
		ListName:""
	},false);
	var Data=JSON.parse(Data);
	var cbox = $HUI.combobox("#PAPMICredType,#AgencyCredType", {
			valueField: 'id',
			textField: 'text',
			blurValidValue:true, 
			editable:false,
			data:Data 
	 });
	 //默认证件类型为身份证
	 var selData=$("#PAPMICredType").combobox('getValue');
	 if (selData){
		 var code=selData.split("^")[1];
		 if (code!=PageLogicObj.m_IDCredTypePlate){
			 for (var i=0;i<Data.length;i++){
				 var id=Data[i].id;
				 if (id.split("^")[1]==PageLogicObj.m_IDCredTypePlate){
					 $("#PAPMICredType,#AgencyCredType").combobox('setValue',id);
				 }
			 }
		 }
	 }
}
function PatInfoSaveClickHandler(OrderPrescNo,EpisodeID){
	
	$('#PatientPostInfo').window('open');
	LoadCredType();
	var PatSupplyInfo=$.cm({
		ClassName:"web.DHCDocCheckPoison",
		MethodName:"GetSupplyMethod",
		EpisodeID:EpisodeID,
		OrderPrescNo:OrderPrescNo,
		 dataType:"text"
	},false);
	var PatSupplyInfoArr=PatSupplyInfo.split("^");
	$("#PatCredNo").val(PatSupplyInfoArr[0]);
	$("#SupplyName").val(PatSupplyInfoArr[1]);
	$("#SupplyCredNo").val(PatSupplyInfoArr[2]);
	$("#SupplyTelH").val(PatSupplyInfoArr[3]);
	var AgencyCredTypeDr=PatSupplyInfoArr[4];
	if (AgencyCredTypeDr!=""){
		$("#AgencyCredType").combobox('select',AgencyCredTypeDr.replace("$","^"));
	}
	var PAPMIDCredTypeDr=PatSupplyInfoArr[5];
	if ((PAPMIDCredTypeDr!="")&&(PatSupplyInfoArr[0]!="")){
		$("#PAPMICredType").combobox('select',PAPMIDCredTypeDr.replace("$","^"));
	}
	$("#PatAddress").val(PatSupplyInfoArr[7]);
	$("#Weight").val(PatSupplyInfoArr[6]);
	PageLogicObj.mradm=PatSupplyInfoArr[8];
	PageLogicObj.EpisodeID=EpisodeID;
	PageLogicObj.OrderPrescNo=OrderPrescNo;
	PageLogicObj.PatientID=PatSupplyInfoArr[9];
	PageLogicObj.PatDobDate=PatSupplyInfoArr[10];
	PageLogicObj.PatSex=PatSupplyInfoArr[11];
	// renyx 增加病区的默认
	if ((PatSupplyInfoArr[12])&&(PatSupplyInfoArr[12]!="")) $("#Ward").combobox('setValue',PatSupplyInfoArr[12]);
	}
function IsCredTypeID(id){
	var myval=$("#"+id).combobox("getValue");
	var myary = myval.split("^");
	if (myary[1]==PageLogicObj.m_IDCredTypePlate){
		return true;
	}else{
		return false;
	}
}
function InfoSaveClickHandler(){
	var IsDPatCredNo=true,IsIdCardNo=true;
	var PatCredNo=$("#PatCredNo").val();
	var PAPMICredType=$("#PAPMICredType").combobox('getValue');
	var PAPMICredTypeId=PAPMICredType.split("^")[0];
	var AgencyCredType=$("#AgencyCredType").combobox('getValue');
	var AgencyCredTypeId=AgencyCredType.split("^")[0];
	if ((PatCredNo!="")&&(PAPMICredType.split("^")[1]=="01")){
		var myrtn=IsCredTypeID("PAPMICredType");
		if (myrtn){
			var IsIdCardNo=DHCWeb_IsIdCardNo(PatCredNo);
			if (!IsIdCardNo){
				return false;
			}
			var IDNoInfoStr=DHCWeb_GetInfoFromId(PatCredNo)
			var IDBirthday=IDNoInfoStr[2]  
			if (PageLogicObj.PatDobDate!=IDBirthday){
				$.messager.alert("提示","出生日期与身份证信息不符!","info",function(){
					$("#SupplyCredNo").focus();
				});
	   		    return false;
			}
			var IDSex=IDNoInfoStr[3]
			if(PageLogicObj.PatSex!=IDSex){
				$.messager.alert("提示","身份证号:"+PatCredNo+"对应的性别是【"+IDSex+"】,与患者本人性别不同!","info",function(){
					$('#SupplyCredNo').next('span').find('input').focus();
				});
				return false;
			}
			
			var myage=getAge(PatCredNo)
			if ((!isNaN(myage))&&(myage!="")){
				if (parseInt(myage)>=parseInt(176)){
					$.messager.alert("提示","本人年龄不能超过176岁!");
					return false;
				}
			}
		}
   }
	var SupplyName=$("#SupplyName").val();
	var SupplyCredNo=$("#SupplyCredNo").val();
	var AgencyTel=$("#SupplyTelH").val();
	if((PatCredNo=="")&&((SupplyCredNo=="")||(SupplyName=="")||(AgencyTel==""))){
		$.messager.alert("提示","信息不完整,请填写完整信息","info",function(){
				$("#PatCredNo").focus();
			});
			return false;
		}
	if ((SupplyCredNo!="")&&(AgencyCredType.split("^")[1]=="01")){
		var myrtn=IsCredTypeID("AgencyCredType");
		if (myrtn){
			var IsDPatCredNo=DHCWeb_IsIdCardNo(SupplyCredNo);
			if (!IsDPatCredNo){
				//$.messager.alert("提示","代办人身份证号码错误!");
				return false;
			}
			var myage=getAge(SupplyCredNo)
			if ((!isNaN(myage))&&(myage!="")){
				if (parseInt(myage)>=parseInt(176)){
					$.messager.alert("提示","代办人年龄不能超过176岁");
					return false;
				}
			}
		}
   }
   var AgencyTel=$("#SupplyTelH").val(); //PatSupplyInfo.split("^")[3]
	if ((AgencyTel!="")&&(!CheckTelOrMobile(AgencyTel,"SupplyTelH","代理人联系电话"))) return false;
	if((IsIdCardNo)&&(IsDPatCredNo)){
		var PAPMICredType=$("#PAPMICredType").combobox('getValue');
		var PAPMICredTypeId=PAPMICredType.split("^")[0];
		var AgencyCredType=$("#AgencyCredType").combobox('getValue');
		var AgencyCredTypeId=AgencyCredType.split("^")[0];
		var PatInfo = PatCredNo + "^" + SupplyName + "^" + SupplyCredNo + "^" + AgencyTel+"^"+PAPMICredTypeId+"^"+AgencyCredTypeId; 
	}
	var rtn=$.cm({
	    ClassName : "web.DHCDocCheckPoison",
	    MethodName : "UpdateAgencyInfo",
	    EpisodeID:PageLogicObj.EpisodeID, PatInfo:PatInfo,OrderPrescNo:PageLogicObj.OrderPrescNo,
	    dataType:"text"
	},false)
	if (rtn!=0) {
		$.messager.alert("提示","保存失败!"+rtn);
		return false;
	}
	var PatAddress=$("#PatAddress").val();
    //if(PatAddress!=""){
	     var rtn=$.cm({
		    ClassName : "web.UDHCPrescript",
		    MethodName : "SavePatAddress",
		    PatientID:PageLogicObj.PatientID, PatAddress:PatAddress,
		    dataType:"text"
		},false)
	//}
	var Weight=$("#Weight").val();
    //if(Weight!=""){
	    var retOrdItemInfo=$.cm({
		    ClassName : "web.UDHCPrescript",
		    MethodName : "SaveWeight",
		    MRAdmID:PageLogicObj.mradm, Weight:Weight ,
		    dataType:"text"
		},false)
    //}
	$.messager.alert("提示","保存成功")
	$('#PatientPostInfo').window('close');
	return true;
	}
function CheckTelOrMobile(telephone,Name,Type){
	if (DHCC_IsTelOrMobile(telephone)) return true;
	if (telephone.indexOf('-')>=0){
		//if(telephone.length<12){
			$.messager.alert("提示",Type+",固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		//}
	}else{
		if(telephone.length!=11){
			$.messager.alert("提示",Type+",长度应为【11】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+",不存在该号段的手机号,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}
function getAge(pId)
	{
		var id=String(pId);
        if (id.length==18){
		    var myMM=(id.slice(10,12)).toString();
		    var myDD=id.slice(12,14).toString();
		    var myYY=id.slice(6,10).toString();
	    }else{
		    var myMM=(id.slice(8,10)).toString();
		    var myDD=id.slice(10,12).toString();
		    var myYY=id.slice(6,8).toString();
			if(parseInt(myYY)<10)	{
				myYY = '20'+myYY;
			}else{
				myYY = '19'+myYY;
			}	    
	    
	    }
	    var myMM=myMM.length==1?("0"+myMM):myMM;
	    var myDD=myDD.length==1?("0"+myDD):myDD;
	    var birthday=myYY+"-"+ myMM +"-"+myDD;
	    var myAge="";
		var bage=birthday;
		bage=bage.substring(0,4);
		var now = new Date();
	    var yy = now.getFullYear();
		var myAge=yy-bage;
		return myAge;
	}
