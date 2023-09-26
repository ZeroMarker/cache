var OrdListSelectedRow="";
var PrescNoTreeLoadOver=false;
var dialog;
var OldOEItemIDStr;
var OldPrescNoStr;
var m_IDCredTypePlate="01"; //身份证代码字段
var MyList = new Array();
var accessURL = "../../web/web.DHCPrintDesigner.cls";
$(function(){
	$("#SearchDate").datebox({
	    onSelect: function(date){
	        LoadOrdListDataGrid();
	    }
	})
	.datebox('setValue',NowDate);


	//初始化本次医嘱
	InitOrdList();
	InitTextFile()
	//PrescNoTree();
	$('#printButton').click(PrintInfo)
	//$('#SaveSupplyInfo').click(SaveSupplyInfo)
	$('#Save').click(SaveSupplyInfo)
	InitStatus();
	LoadOrdListDataGrid();
});

function InitStatus(){
	//门诊收费配置-》门诊系统参数配置-》打印导诊单
	if(PrtGuideFlag=="F"){
		 $('#guide').checkbox("disable"); 
		 $("#guide").checkbox("setValue",false); 
	}
}
function InitCheckBox(){
	var EMRSignInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetEMRSignUseID",
	    AdmRowId:EpisodeID, UserID:session['LOGON.USERID'], EMRType:"OPEMR",
	    dataType:"text"
	},false)
	//var EMRSignInfo=tkMakeServerCall("web.UDHCPrescript","GetEMRSignUseID",EpisodeID,session['LOGON.USERID'],"OPEMR");
	var EMRSignInfoArr=EMRSignInfo.split("^");
	if (EMRSignInfoArr[0]!=""){
		$("#EMR").checkbox("setValue",true);
	}
	var EMRSignInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetEMRSignUseID",
	    AdmRowId:EpisodeID, UserID:session['LOGON.USERID'], EMRType:"OPEMRReturn",
	    dataType:"text"
	},false)
	//var EMRSignInfo=tkMakeServerCall("web.UDHCPrescript","GetEMRSignUseID",EpisodeID,session['LOGON.USERID'],"OPEMRReturn");
	var EMRSignInfoArr=EMRSignInfo.split("^");
	if (EMRSignInfoArr[0]!=""){
		$("#EMRReturn").checkbox("setValue",true);
		$("#EMR").checkbox("setValue",false);
	}
	var EMRSignInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetEMRSignUseID",
	    AdmRowId:EpisodeID, UserID:session['LOGON.USERID'], EMRType:"EMRCertificate",
	    dataType:"text"
	},false)
	//var EMRSignInfo=tkMakeServerCall("web.UDHCPrescript","GetEMRSignUseID",EpisodeID,session['LOGON.USERID'],"EMRCertificate");
	var EMRSignInfoArr=EMRSignInfo.split("^");
	if (EMRSignInfoArr[0]!=""){
		$("#EMRCertificate").checkbox("setValue",true);
	}
}
function InitOrdList(){
	OrdListColumns=[[
		{field: 'Check',checkbox:true},
		{ field: 'ARCIMRowId', hidden:true}, 
		{ field: 'UserAddID', hidden:true},
		{ field: 'OEItemID', hidden:true},
		{ field: 'OEItemDR', hidden:true},
		/*6-10*/
		{ field: 'ReLocID', hidden:true},
		{ field: 'PHFreq',hidden:true},
		{ field: 'OrderPrintFlag', title:'打印',width:50},
		{ field: 'ArcimDesc', title:'医嘱名称',width:150},
		{ field: 'OrdBilled', title:'计费状态',hidden:true},
		/*11-15*/
		{ field: 'OrdStatus', title:'状态', width: 30},
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
		{ field: 'ArcPrice', title:'单价/元', width: 50},
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
	
	$.each(OrdListColumns[0],function(n,value){
        if (PAAdmType=="I"){
            if (("^9^10^17^22^25^").indexOf("^"+n+"^")>=0){
	        	this.hidden=true;
	        }
        }else{
	    	 if (("^26^27^28^").indexOf("^"+n+"^")>=0){
	        	this.hidden=true;
	        }  
	    }
    });

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
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : false,  //
		idField:"OEItemID",
		//pageList : [15,50,100,200],
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
			//PrescNoTree()
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
							}
						}
						if (FindSelAlready==0){continue}
						$('#tabOrdList').datagrid('unselectRow',i)
					}
				}
			}
			//PrescNoTree()
		},
		onUnselectAll:function(rowIndex, rowData){
			////取消所有选中时，显示所有
			//PrescNoTree()
		},
		onLoadSuccess:function(data){
			var OrdStr=""
			var Length=data.rows.length
			for (var i=0;i<Length;i++) {
				var PrintFlag=data.rows[i].OrderPrintFlag
				var OrdBilled=data.rows[i].OrdBilled
				//
				if ((PrintFlag!="Y")&&(OrdBilled!="已收费")){
					$('#tabOrdList').datagrid('checkRow',i)
				}
				var OEItemID=data.rows[i].OEItemID
				if (OrdStr==""){
					OrdStr=OEItemID
				}else{
					OrdStr=OrdStr+"^"+OEItemID
				}
			}
			///初始化勾选是否默认
			//InitCheckBox();
			if (Length>0){
				if(PrtGuideFlag=="F"){
					 $('#guide').checkbox("disable");
					 $("#guide").checkbox("setValue",false); 
	            }else{
		            $("#guide").checkbox("setValue",true);
		        }
				$("#frontFlag").checkbox("setValue",true);
		        $("#backFlag").checkbox("setValue",true);
				/*var retOrdItemInfo=tkMakeServerCall("web.UDHCPrescript","GetOrdTreatInfo",EpisodeID,OrdStr,session['LOGON.CTLOCID']);
				if (retOrdItemInfo!=""){
					$("#Treat").attr("checked",true);
				}
				var retOrdItemInfo=tkMakeServerCall("web.UDHCPrescript","GetOrdValuationInfo",EpisodeID,OrdStr,session['LOGON.CTLOCID']);
				if (retOrdItemInfo!=""){
					$("#ValuationList").attr("checked",true);
				}
				var retOrdItemInfo=tkMakeServerCall("web.UDHCPrescript","GetOutBuyInfo",EpisodeID,OrdStr,session['LOGON.CTLOCID']);
				if (retOrdItemInfo!=""){
					$("#OutBuy").attr("checked",true);
				}*/
			}
		},onBeforeLoad:function(param){
			/*param.ClassName ='web.DHCDocQryOEOrder';
			param.QueryName ='GetOrdByAdm';
			param.Arg1 =EpisodeID;
			if (EMRPrintAll=="1"){
				param.Arg2 ="";
			}else{
				param.Arg2 =session['LOGON.USERID'];
			}
			param.Arg3="",param.Arg4="",param.Arg5="",param.Arg6="",param.Arg7="",param.Arg8="";
			param.Arg9="",param.Arg10="",param.Arg11 ="",param.Arg12 ="";
			if (PAAdmType=="I"){
				param.Arg9 ="on";
				param.Arg10 ="J1^DM^DX^MZ";
				param.Arg11 ="Y";
				param.Arg12 ="N";
			}
			param.ArgCnt =12;*/
		}
	});
	//LoadOrdListDataGrid();
}
function LoadOrdListDataGrid()
{
	
	/*var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocQryOEOrder';
	queryParams.QueryName ='GetOrdByAdm';
	queryParams.Arg1 =EpisodeID;
	queryParams.Arg2 =session['LOGON.USERID'];
	queryParams.ArgCnt =2;
	var opts = OrdListDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	OrdListDataGrid.datagrid('load', queryParams);*/
	if (EMRPrintAll=="1"){
		var OrderCTPro ="";
	}else{
		var OrderCTPro =session['LOGON.USERID'];
	}
	var SearchDate="";
	if($("#SearchDate").length > 0) {
		SearchDate=$("#SearchDate").datebox('getValue');
	}
	var OutOrd="",DrgFormPoison="",Nexus="",CMMedFlag="Y";
	if (PAAdmType=="I"){
		OutOrd="on";
		DrgFormPoison="J1^DM^DX^MZ",
		Nexus="Y" //,CMMedFlag="N";
	}
	$.cm({
	    ClassName : "web.DHCDocQryOEOrder",
	    QueryName : "GetOrdByAdm",
	    EpisodeID:EpisodeID, OrderCTPro:OrderCTPro,
	    SearchStartDate:SearchDate, SearchEndDate:SearchDate, 
	    CategoryID:"", SubsortID:"", LongOrd:"", ShortOrd:"", OutOrd:OutOrd, DrgFormPoison:DrgFormPoison,
	    Nexus:Nexus, CMMedFlag:CMMedFlag,
	    rows:99999
	},function(GridData){
		OrdListDataGrid.datagrid('uncheckAll').datagrid('loadData',GridData);
	})
}
function PrescNoTree(){
	PrescNoTreeLoadOver=false
	var PrescNoStr=""
	var OEItemIDStr=""
	var SelectedList=$('#tabOrdList').datagrid('getSelections')
	for (var k=0;k<SelectedList.length;k++) {
		var OEItemID=SelectedList[k].OEItemID
		var PrescNo=SelectedList[k].OrderPrescNo
		if (PrescNo!=""){
			if (("^"+PrescNoStr+"^").indexOf("^"+PrescNo+"^")>=0){continue}
			if (PrescNoStr==""){
				PrescNoStr=PrescNo
			}else{
				PrescNoStr=PrescNoStr+"^"+PrescNo
			}
		}else{
			if (("^"+OEItemIDStr+"^").indexOf("^"+OEItemID+"^")>=0){continue}
			if (OEItemIDStr==""){
				OEItemIDStr=OEItemID
			}else{
				OEItemIDStr=OEItemIDStr+"^"+OEItemID
			}
		}
	}
	if ((OEItemIDStr==OldOEItemIDStr)&&(PrescNoStr==OldPrescNoStr)){return}
	/*$('#PrescNoTree').tree({
		url:'../web.UDHCPrescriptPage.cls?ACTION=DataPrescNoTree&EpisodeID='+EpisodeID+'&PrescNoStr='+PrescNoStr+'&OEItemIDStr='+OEItemIDStr,
		method:'get',
		onlyLeafCheck:true,
		lines:true,
		onSelect: function(node){
			if (typeof node.id =="undefined"){
				return
			}
			var id=node.id
			if (id.indexOf("@")==-1){return}
			if (node.checked){
				$('#PrescNoTree').tree("uncheck",node.target)
			}else{
				$('#PrescNoTree').tree("check",node.target)
			}
			///会自动触发onCheck
			
		},
		onCheck:function(node, checked){
			if (PrescNoTreeLoadOver){
				//UploadPrescNoTree()
			}
		},
		onLoadSuccess:function(node, data){

			for (var i=0;i<data.length;i++){
				if (typeof data[i].children =="undefined"){
					continue
				}
				for (var j=0;j<data[i].children.length;j++){
					var id=data[i].children[j].id
					var CheckFlag=id.split("@")[3]
					if (CheckFlag=="1"){
						$('#PrescNoTree').tree("check",data[i].children[j].target)
					}else{
						$('#PrescNoTree').tree("uncheck",data[i].children[j].target)
					}
				}
			}
			//$('#PrescNoTree').tree("collapseAll");
			PrescNoTreeLoadOver=true
		},
		onLoadError: function(){alert("EMRCatalogonLoadError");}
	});*/
	
	OldOEItemIDStr=OEItemIDStr;
	OldPrescNoStr=PrescNoStr;
	
}

function UploadPrescNoTree()
{
	var UploadInfo=""
	var findeUnCheckNode=false
	var Record=$('#PrescNoTree').tree("getRoots")
	for (var i=0;i<Record.length;i++){
		findeUnCheckNode=false
		for (var j=0;j<Record[i].children.length;j++){
			//alert(Record[i].children.target.innerHTML)
			var d = $("#" + Record[i].children[j].domId);
			var CheckFlag=d.find(".tree-checkbox").hasClass("tree-checkbox1")
			if (CheckFlag==false){
				findeUnCheckNode=true
				if (UploadInfo==""){
					UploadInfo=Record[i].children[j].id
				}else{
					UploadInfo=UploadInfo+"^"+Record[i].children[j].id
				}
			}
		}
		if (findeUnCheckNode==false){
			if (UploadInfo==""){
				UploadInfo=Record[i].id
			}else{
				UploadInfo=UploadInfo+"^"+Record[i].id
			}
		}
	}
	/*
	var Record=$('#PrescNoTree').tree("getChecked",'unchecked')
	for (var i=0;i<Record.length;i++){
		if (UploadInfo==""){
			UploadInfo=Record[i].id
		}else{
			UploadInfo=UploadInfo+"^"+Record[i].id
		}
	}
	*/
	//var rtn=tkMakeServerCall("web.UDHCPrescriptPage","SetPrescNoLinkDiagnose",UploadInfo,EpisodeID)
	var rtn=$.cm({
	    ClassName : "web.UDHCPrescriptPage",
	    MethodName : "SetPrescNoLinkDiagnose",
	    UploadInfo:UploadInfo, EpisodeID:EpisodeID,
	    dataType:"text"
	},false)
	return rtn
}

function InitTextFile()
{
	$.cm({
	    ClassName : "web.DHCDocQryOEOrder",
	    MethodName : "GetOrdItemSum",
	    AdmId:EpisodeID, CTLocID:"",
	    dataType:"text"
	},function(TotalExp){
		if(isNaN(TotalExp)){
			TotalExp = 0;
		}
		$("#TotalExpenses").val(TotalExp);
	})
	/*var TotalExp = tkMakeServerCall("web.DHCDocQryOEOrder","GetOrdItemSum",EpisodeID,"");
	//var TotalExp = parseFloat(TotalExp);
	if(isNaN(TotalExp)){
		TotalExp = 0;
	}
	$("#TotalExpenses").val(TotalExp);*/
	$.cm({
	    ClassName : "web.DHCDocQryOEOrder",
	    MethodName : "GetOrdItemSum",
	    AdmId:EpisodeID, CTLocID:session['LOGON.CTLOCID'],
	    dataType:"text"
	},function(ThisDepExp){
		if(isNaN(ThisDepExp)){
			TotalExp = 0;
		}
		$("#ThisDepartment").val(ThisDepExp);
	})
	
	/*var ThisDepExp = tkMakeServerCall("web.DHCDocQryOEOrder","GetOrdItemSum",EpisodeID,session['LOGON.CTLOCID']);
	//var ThisDepExp = parseFloat(ThisDepExp);
	if(isNaN(ThisDepExp)){
		ThisDepExp = 0;
	}
	$("#ThisDepartment").val(ThisDepExp);*/
	LoadCredType();
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
	$("#PatAddress").val(PatAddress);
	$("#Weight").val(Weight);
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
		 if (code!=m_IDCredTypePlate){
			 for (var i=0;i<Data.length;i++){
				 var id=Data[i].id;
				 if (id.split("^")[1]==m_IDCredTypePlate){
					 $("#PAPMICredType,#AgencyCredType").combobox('setValue',id);
				 }
			 }
		 }
	 }
}
function PrintInfo()
{
    var ret=SaveSupplyInfoCom(0);
    if (!ret) return false;
	var EMR="N",EMRReturn="N",EMRCertificate="N";
	var guide=GetCheckValue("guide")
	var EMR=GetCheckValue("EMR")
	var EMRReturn=GetCheckValue("EMRReturn");
	var EMRCertificate=GetCheckValue("EMRCertificate")
	var frontFlag=GetCheckValue("frontFlag")
	var backFlag=GetCheckValue("backFlag")
	//var Treat=GetCheckValue("Treat")
	//var ValuationList=GetCheckValue("ValuationList")
	//var OutBuy=GetCheckValue("OutBuy")
	var printCount=0;
	/*
	*如果启用三合一医生工作站界面，门诊及复诊病历由医生站调用xml打印方式打印，
	*除了页眉及医嘱信息由医生站自己从数据库中获取，其他的病历信息均由电子病历数据集提供，
	*数据集配置请参考d ##class(DHCDoc.Local.SysParams).SetSysEMRInfo()方法，项目提供数据集后
	*修改此方法运行，进行global配置，不允许直接修改global。
	*病历内容与标板不符的，可酌情修改d ##Class(web.UDHCPrescript).GetEMRInfo方法，如有疑问请联系tanjishan
	*/
	/*if (EMR=="Y"){
		PrintEMRInfo(PatientID, EpisodeID, mradm)
		printCount=printCount+1;
	}
	if (EMRReturn=="Y") {
		PrintEMRInfo(PatientID, EpisodeID, mradm,"OPEMRReturn")
		printCount=printCount+1;
	}
	if (EMRCertificate=="Y"){
		PrintEMRCertificate(PatientID, EpisodeID, mradm)
		printCount=printCount+1;
	}
	if (guide=="Y"){
		PrintGuideInfo(PatientID, EpisodeID, mradm)
		printCount=printCount+1;
	}*/
	/*if(Treat=="Y"){
		PrintTreatInfo(PatientID, EpisodeID, mradm)
		printCount=printCount+1;
	}
	if(ValuationList=="Y"){
		PrintValuationInfo(PatientID, EpisodeID, mradm)
		printCount=printCount+1;
	}
	if (OutBuy=="Y"){
		PrintOutBuyInfo(PatientID, EpisodeID, mradm)
		printCount=printCount+1;	
	}*/
	var strSelectedOrder=GetSelectedOrder()
	if ((frontFlag=="Y")||(backFlag=="Y")){
		//获取病人的基本信息
		var PatientInfo=GetPatientBaseInfo(PatientID,EpisodeID,"Presc");
		if (PatientInfo==false){
			return false;
		}
	}
	if((frontFlag=="Y")||(backFlag=="Y")){
		//打印处方正方或底方
		PatientPrescPrint(PatientID,EpisodeID,mradm,strSelectedOrder,frontFlag,backFlag,PatientInfo);
		printCount=printCount+1;
	}
	/*if (AInstanceIDList!=""){
		var AInstanceIDListArr=AInstanceIDList.split("^");
		for (var i=1;i<=AInstanceIDListArr.length;i++){
			var obj=document.getElementById("PrintEMR_"+i);
			if (!obj){continue;}
			if (GetCheckValue("PrintEMR_"+i)!="Y") {continue;}
			var AInstanceID=AInstanceIDListArr[i-1].split(String.fromCharCode(2))[0];
			if (AInstanceID==""){continue;}
			var emrPrintUrl=$.cm({
			    ClassName : "web.UDHCPrescript",
			    MethodName : "GetSelfPrintParam",
			    AInstanceID:AInstanceID,
			    dataType:"text"
			},false)
			if (emrPrintUrl==""){continue;}
			var ret=$.cm({
			    ClassName : "web.UDHCPrescript",
			    MethodName : "InsertSelfPrintLog",
			    AInstanceID:AInstanceID,
			    dataType:"text"
			},false)
			(function(URL){
				win=window.showModalDialog(URL,"","status=1,top=150,left=150,width=10,height=10,resizable=no,scrollbars=no");	
				
			})(emrPrintUrl);
			printCount=printCount+1;
		}
	}
	
	if (AllEMRData!=""){
		var AllEMRDataArr=AllEMRData.split("^");
		for (var i=1;i<=AllEMRDataArr.length;i++){
			var obj=document.getElementById("PrintAllEMR_"+i);
			if (!obj){continue;}
			if (GetCheckValue("PrintAllEMR_"+i)!="Y") {continue;}
			///signUsrID_$C(2)_signUsrName_$C(2)_titleName_$C(2)_AInstanceID
			var signUsrID=AllEMRDataArr[i-1].split(String.fromCharCode(2))[0];
			var signUsrName=AllEMRDataArr[i-1].split(String.fromCharCode(2))[1];
			var titleName=AllEMRDataArr[i-1].split(String.fromCharCode(2))[2];
			var AInstanceID=AllEMRDataArr[i-1].split(String.fromCharCode(2))[3];
			if (AInstanceID==""){
				//走医生站的程序
				if (titleName=="门诊病历"){
					PrintEMRInfo(PatientID, EpisodeID, mradm,"OPEMR",signUsrID)
				}else if (titleName=="复诊病历"){
					PrintEMRInfo(PatientID, EpisodeID, mradm,"OPEMRReturn")
				}else{
					return
				}
			}else{
				//走电子病历的程序
				var emrPrintUrl=$.cm({
				    ClassName : "web.UDHCPrescript",
				    MethodName : "GetSelfPrintParam",
				    AInstanceID:AInstanceID,
				    dataType:"text"
				},false)
				if (emrPrintUrl==""){continue;}
				var ret=$.cm({
				    ClassName : "web.UDHCPrescript",
				    MethodName : "InsertSelfPrintLog",
				    AInstanceID:AInstanceID,
				    dataType:"text"
				},false)
				(function(URL){
					win=window.showModalDialog(URL,"","status=1,top=150,left=150,width=10,height=10,resizable=no,scrollbars=no");	
				
				})(emrPrintUrl);
			}
			printCount=printCount+1;
		}
	}*/
	
	if (printCount==0){
		$.messager.alert("提示","请选择打印数据!")
		return
	}
}
function PatientPrescPrint(PatientID,EpisodeID,MRADMID,OrdList,flag1,flag2,PatientInfo){
	if (OrdList==""){
		$.messager.alert("提醒","请选择需要打印的医嘱");
		return;
	}
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
			episodeID:EpisodeID,
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
		return false;
		///以下是8.3发布的方法
	    if(OrdList=="") return false;
	    var SearchDate="";
		if($("#SearchDate").length > 0) {
			SearchDate=$("#SearchDate").datebox('getValue');
		}
	    var PrescNoStr=$.cm({
		    ClassName : "web.UDHCPrescript",
		    MethodName : "GetPrescNoStrByOrdList",
		    EpisodeID:EpisodeID, OrdItemList:OrdList, SearchDate: SearchDate,
		    dataType:"text"
		},false)
		if(PrescNoStr=="")return false;
		//2019-01-15改为调用药房组接口统一获取处方打印数据 
		var myobj=document.getElementById('ClsBillPrint');
		var PrescNoArr=PrescNoStr.split("^");
		if((PrescNoArr[0].split(' ')[0].indexOf("!")>0)){
			var PrescDMnum=PrescNoArr[0].split(' ')[0].split("!")[1];
			if ((flag1=="Y")&&(flag2=="Y")){
				PrescDMnum=2*PrescDMnum;
			}
			if(!dhcsys_confirm("毒麻处方需要红纸打印，请放入"+PrescDMnum+"张红色处方纸。"))return false;
		}
		var ZfFlag="正方";
		for (var j=0;j<PrescNoArr.length;j++){
			var PrescDesc=PrescNoArr[j];
			var PrescNo=PrescDesc.split('   ')[0];//alert(PrescNo)
			if(PrescNo.indexOf("!")>0) PrescNo=PrescNo.split("!")[0];
			var PrescNoPrintData=$.cm({
			    ClassName : "PHA.FACE.OUT.Com",
			    MethodName : "GetPreDataForPrint",
			    PrescNo:PrescNo, ZfFlag:ZfFlag, PrtType: ''//,
			    //dataType:"text"
			},false)
			var TemplName=PrescNoPrintData.Templet;
			var List=PrescNoPrintData.List;
			var Para=PrescNoPrintData.Para;
			DHCP_GetXMLConfig("XMLObject",TemplName);
			var MyPara="";
			for (var index in Para){
				var onePara=index+String.fromCharCode(2)+Para[index];
				if (MyPara=="") MyPara=onePara;
				else  MyPara=MyPara+"^"+onePara;
			}
			var MyList="";
			for (var i=0;i<List.length;i++){
				if (MyList=="") MyList=List[i];
				else  MyList=MyList+String.fromCharCode(2)+List[i];
			}
			if (TemplName.indexOf("Ver")<0){
				var onePageNums=12; //处方打印一页打印行数
			}else{
				var onePageNums=16;
			}
			var listLen=MyList.split(String.fromCharCode(2)).length;
			var Len=Math.ceil(listLen/onePageNums); //向上取整
			for (var i=1;i<=Len;i++){
				var oneList="";
				var n=parseInt((i-1)*onePageNums);
				var k=n+parseInt(onePageNums);
				if (k>listLen) k=listLen;
				for (var listI=n;listI<k;listI++){
					var listIData=MyList.split(String.fromCharCode(2))[listI];
					if (oneList==""){
						oneList=listIData;
					}else{
						oneList+=String.fromCharCode(2)+listIData;
					}
				}
				PrintFun(myobj,MyPara,oneList);
			}
		}
		var rtn=$.cm({
		    ClassName : "web.UDHCPrescript",
		    MethodName : "SetOrdItemPrintFlag",
		    OrdItemList:OrdList,
		    dataType:"text"
		},false)
		LoadOrdListDataGrid();
		return false;
		//以下是旧版方法
		
		//获取病人本次就诊的诊断信息
		var PatMradmInfo=GetPatMradmInfo(MRADMID);
		PatMradmInfo=PatMradmInfo.replace(/(^\s*)|(\s*$)/g,'')
		//var PatMradmInfo=PatMradmInfo.split(" ")[0];
		var PrintCount=2;
		var myobj=document.getElementById('ClsBillPrint');
		var PrescNoArr=PrescNoStr.split("^");
		if((PrescNoArr[0].split(' ')[0].indexOf("!")>0)){
			var PrescDMnum=PrescNoArr[0].split(' ')[0].split("!")[1];
			if ((flag1=="Y")&&(flag2=="Y")){
				PrescDMnum=2*PrescDMnum;
			}
			if(!dhcsys_confirm("毒麻处方需要红纸打印，请放入"+PrescDMnum+"张红色处方纸。"))return false;
		}
		for (var j=0;j<PrescNoArr.length;j++){
			var PrescDesc=PrescNoArr[j];
			var PrescNo=PrescDesc.split('   ')[0];//alert(PrescNo)
			if(PrescNo.indexOf("!")>0)PrescNo=PrescNo.split("!")[0];
			var presType = tkMakeServerCall("web.DHCDocPrescript","IsPrescType",PrescNo)
			if(presType==1){
				 //草药处方
				 DHCP_GetXMLConfig("XMLObject","DHCOutPrescCY");
				 var ReportData=$.cm({
				    ClassName : "web.DHCDocPrescript",
				    MethodName : "GetPrescInfoByOrd",
				    PrescNo:PrescNo,
				    dataType:"text"
				},false)
				//var ReportData = tkMakeServerCall("web.DHCDocPrescript","GetPrescInfoByOrd",PrescNo)
				 ///DHCOPPrtCommon.js
				 PrintPrescCY('','',ReportData);
				 var ReportId=$.cm({
				    ClassName : "web.DHCDocPrescript",
				    MethodName : "GetXMLTemplateId",
				    XMLTemplateName:"DHCOutPrescCY",
				    dataType:"text"
				},false)
				//var ReportId =tkMakeServerCall("web.DHCDocPrescript","GetXMLTemplateId","DHCOutPrescCY");
				 OpenReport(ReportId);
				 PrintOnePrescCY(PrescNo,"",flag1,flag2)
			}else{
				//西药处方
				//var PrescSerialNo=PrescNo.substring(1,12);
				DHCP_GetXMLConfig("XMLObject","DHCOutPrescXYPrt");
				var ReclocDesc=PrescDesc.split('   ')[2];
				if (ReclocDesc.indexOf("-")!=-1)ReclocDesc=ReclocDesc.split("-")[1];
				var PrescType="";
				var BillType=PrescDesc.split('   ')[3];
				var PatPrescInfo=$.cm({
				    ClassName : "web.UDHCPrescript",
				    MethodName : "GetOrdItemByPrescNo",
				    EpisodeID:EpisodeID, PrescNo:PrescNo, SearchDate: SearchDate,
				    dataType:"text"
				},false);
				//var PatPrescInfo=tkMakeServerCall("web.UDHCPrescript","GetOrdItemByPrescNo",EpisodeID,PrescNo);
				if (PatPrescInfo=="") continue;
				var MyPara="",MyList="";
				var PrescInfoArr=PatPrescInfo.split(String.fromCharCode(1));
				var BilledTxt=PrescInfoArr[2];
				var PrescInfoArr1=PrescInfoArr[0].split("^");
				var Sum=PrescInfoArr1[0],PoisonClass=PrescInfoArr1[1];
				var OrdDate=PrescInfoArr1[2],OrdTime=PrescInfoArr1[3];
				if((PoisonClass!='J1')&&(PoisonClass!='J2')&&(PoisonClass!='DX')&&(PoisonClass!='MZ'))PoisonClass="";
				if ((PoisonClass=='DX')||(PoisonClass=='MZ')||(PoisonClass=='J1'))PoisonClass='[麻 精一]';
				if (PoisonClass=='J2')PoisonClass='[精二]';
				var MyPara='^Sum'+String.fromCharCode(2)+Sum+'元';
				MyPara=MyPara+'^OrdDate'+String.fromCharCode(2)+OrdDate;
				MyPara=MyPara+'^OrdTime'+String.fromCharCode(2)+OrdTime;
				MyPara=MyPara+'^PoisonClass'+String.fromCharCode(2)+PoisonClass;
				MyPara=MyPara+'^BilledTxt'+String.fromCharCode(2)+BilledTxt;
				MyPara=MyPara+'^PrescNo'+String.fromCharCode(2)+PrescNo;
				MyPara=MyPara+'^RecLoc'+String.fromCharCode(2)+ReclocDesc;
				//MyPara=MyPara+'^PrescType'+String.fromCharCode(2)+PrescType;
				MyPara=MyPara+'^BillType'+String.fromCharCode(2)+"["+BillType+"]";
				var SerialNo=tkMakeServerCall("User.PAQue1PrtSerial","GetPrtSerial",PrescNo,SearchDate);
				if (SerialNo==""){
					var SerialNo=$.cm({
					    ClassName : "User.PAQue1PrtSerial",
					    MethodName : "InsertPrtSerial",
					    PrescNo:PrescNo, PrtDate:SearchDate, UserID:session['LOGON.USERID'],
					    dataType:"text"
					},false)
					//SerialNo=tkMakeServerCall("User.PAQue1PrtSerial","InsertPrtSerial",PrescNo,"",session['LOGON.USERID']);
				}
				MyPara=MyPara+'^PrescSerialNo'+String.fromCharCode(2)+SerialNo;
				
				//改为与处方预览统一模板
				//对于毒麻处方，取代办人信息从新的方法获取。
				var PrescSupplyInfo=$.cm({
				    ClassName : "web.DHCDocCheckPoison",
				    MethodName : "GetAgencyInfoByPrescNo",
				    PrescNo:PrescNo, PersonID:EpisodeID,
				    dataType:"text"
				},false)
				//var PrescSupplyInfo=tkMakeServerCall("web.DHCDocCheckPoison","GetAgencyInfoByPrescNo",PrescNo,EpisodeID)
				if ((PrescSupplyInfo!="")&&((PoisonClass=='[麻 精一]')||(PoisonClass=='[精二]'))){
					var PrescSupplyInfoArr=PrescSupplyInfo.split("^");
					var PAPMIAgencyName=PrescSupplyInfoArr[1];
					var PAPMIAgencyCredNo=PrescSupplyInfoArr[0];
					var PAPMIAgencyTel=PrescSupplyInfoArr[2];
					var PerSupply="代办人姓名:"+PAPMIAgencyName;
					var MyPara=MyPara+"^"+"SupplyName"+String.fromCharCode(2)+PerSupply;
					var PerSupplyCrad="代办人身份证号:"+PAPMIAgencyCredNo;
					var MyPara=MyPara+"^"+"SupplyCard"+String.fromCharCode(2)+PerSupplyCrad;
				}
			
				var PrescInfoArr2=PrescInfoArr[1].split(String.fromCharCode(2));
				var ReportData=$.cm({
				    ClassName : "web.DHCDocPrescript",
				    MethodName : "GetPrescInfoByOrd",
				    PrescNo:PrescNo, SearchDate:SearchDate,
				    dataType:"text"
				},false)
				//var ReportData=tkMakeServerCall("web.DHCDocPrescript","GetPrescInfoByOrd",PrescNo)
				var tmparr = ReportData.split("!!")
				var patarr = tmparr[0].split("^")
				var Medcare=patarr[37]
				MyPara=MyPara+'^MRNo'+String.fromCharCode(2)+Medcare;
				var medinfo = tmparr[1]
		        var medarr = medinfo.split("@")
		        var mlength = medarr.length
		         for (h = 0; h < mlength; h++) {
			         var medrow = medarr[h]
		            var rowarr = medrow.split("^")
		            var OrderName = rowarr[0]
		            var PackQty = rowarr[1] + rowarr[2]
		            var DoseQty = rowarr[3]
		            var Inst = rowarr[4]
		            var Freq = rowarr[5]
		            var Lc = rowarr[6]
		            var totalprice = rowarr[8]
		            var Ordremark = rowarr[10]
		            var Testflag = rowarr[9]
		            var Seqno = rowarr[11]
					var ISLongOrderPrior= rowarr[13]
					var Priority= rowarr[14]
		            if (Testflag != "") {
		                Seqno = Seqno + String.fromCharCode(9650)
		            }
		            if (Ordremark.length > 10) {
		                Ordremark = Ordremark.substr(0, 10) + "...";
		            }

		            var OrderName = Seqno + " " + OrderName
					///项目要求在备注存在用法：的时候使用备注覆盖单次计量
		            if (ISLongOrderPrior=="1"){
						var firstdesc = OrderName + ' (' + Priority+")"
					}else{
		            	var firstdesc = OrderName + ' X ' + PackQty
					}
	     
		            var inststring = "   			用法:每次" + DoseQty + "     " + Freq + "     " + Inst + Testflag + "     " + Ordremark

		            var firstdesc = firstdesc + String.fromCharCode(2) + inststring

		            if (MyList == '') {
		                MyList=firstdesc;
		            } else {
		                //MyList.push(firstdesc);
		                MyList=MyList+String.fromCharCode(2)+firstdesc;
		            }
			     }
				MyPara=PatientInfo+PatMradmInfo+MyPara;
				if (flag1=="Y") {
					var zf="[正方]";
					var MyPara1=MyPara+'^ZDF'+String.fromCharCode(2)+zf;
					PrintFun(myobj,MyPara1,MyList);
				}
				if (flag2=="Y") {
					var zf="[底方]";
					var MyPara1=MyPara+'^ZDF'+String.fromCharCode(2)+zf;
					PrintFun(myobj,MyPara1,MyList);
				}
				var rtn=$.cm({
				    ClassName : "User.PAQue1PrtSerial",
				    MethodName : "SavePrintLog",
				    SerialNumber:SerialNo, UserID:session['LOGON.USERID'],
				    dataType:"text"
				},false)
				//var rtn=tkMakeServerCall("User.PAQue1PrtSerial","SavePrintLog",SerialNo,session['LOGON.USERID']);
			}
		}
		//var rtn=tkMakeServerCall("web.UDHCPrescript","SetOrdItemPrintFlag",OrdList);
		var rtn=$.cm({
		    ClassName : "web.UDHCPrescript",
		    MethodName : "SetOrdItemPrintFlag",
		    OrdItemList:OrdList,
		    dataType:"text"
		},false)
		return true;
	}
}
function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr='';
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject('MSXML2.DOMDocument.4.0');
		docobj.async = false;    //close
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)			
			var rtn=PObj.ToPrintHDLP(inpara,inlist,docobj); //ToPrintDocNew
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
			return websys_cancel();
		}
	}catch(e){
		var dt=new Date();
		var PrintDate=dt.getFullYear()+"-"+(dt.getMonth()+1)+"-"+dt.getDate();
		var PrintTime=dt.getHours()+":"+dt.getMinutes()+":"+dt.getSeconds();
		var ErrInfo=PrintDate+" "+PrintTime+" "+"错误编号："+e.number+"/  "+"错误名称："+e.name;
		var ErrInfo=ErrInfo+"/  "+"错误消息："+e.message+"/  "+"PrintError！！！";
		writeFile(ErrInfo);
		//alert(e.meaasge);
	}
}

function GetPatMradmInfo(MRADMID){
	//var GetMRDiagnosDesc=document.getElementById('GetMRDiagnos');
	//if (GetMRDiagnosDesc) {var encmeth=GetMRDiagnosDesc.value} else {var encmeth=''};
	//if (encmeth!='') {
		var j=0;
		var MyPara="";
		var delim=';';//+String.fromCharCode(13)+String.fromCharCode(10)
		//var PatMradmInfo=cspRunServerMethod(encmeth,MRADMID,delim);
		var PatMradmInfo=$.cm({
		    ClassName : "web.UDHCPrescript",
		    MethodName : "GetMRDiagnosDescNew",
		    MRAdmRowid:mradm, DelimStr:";", LogonCTLocRowId:session['LOGON.CTLOCID'],
		    dataType:"text"
		},false)
		//var PatMradmInfo=tkMakeServerCall("web.UDHCPrescript","GetMRDiagnosDescNew",mradm,";",session['LOGON.CTLOCID']);
		//tkMakeServerCall("web.DHCMRDiagnos","GetMRDiagnosDesc",MRADMID,delim);
		var len=PatMradmInfo.length;
		var MradmInfoArr=PatMradmInfo.split(delim);
		for (var i=0;i<MradmInfoArr.length;i++) {
			j=j+1;
			var MradmInfo=MradmInfoArr[i];
			if (MyPara=="") {
				if(MradmInfo.length>8){
					var MradmInfo1=MradmInfo.substring(0,9);
					var MradmInfo2=MradmInfo.substring(9,20);
					MyPara='^Diagnose'+j+String.fromCharCode(2)+MradmInfo1;
					j=j+1;
					MyPara=MyPara+'^Diagnose'+j+String.fromCharCode(2)+MradmInfo2;
				}else{
					MyPara='^Diagnose'+j+String.fromCharCode(2)+MradmInfo;
				}
			}else{
				if(MradmInfo.length>8){
					var MradmInfo1=MradmInfo.substring(0,9);
					var MradmInfo2=MradmInfo.substring(9,20);
					MyPara=MyPara+'^Diagnose'+j+String.fromCharCode(2)+MradmInfo1;
					j=j+1;
					MyPara=MyPara+'^Diagnose'+j+String.fromCharCode(2)+MradmInfo2;
				}else{
					MyPara=MyPara+'^Diagnose'+j+String.fromCharCode(2)+MradmInfo;
				}
			}
		}
	//}

	return MyPara;
}
function GetCheckValue(name)
{
	if ($("#"+name).checkbox("getValue")){
		return "Y"
	}else{
		return "N"
	}
}

function PrintEMRCertificate(PatientID, EpisodeID, MRADMID){
	///电子病历内容换行数量
	var BreakLeng=50;
	DHCP_GetXMLConfig('XMLObject','EMRCertificatePrint');
	var PatientInfo = GetPatientBaseInfo(PatientID, EpisodeID);
	//获取病人本次就诊的诊断信息
	MyPara=PatientInfo;
	var ListP=String.fromCharCode(2);
	var MyList="";
	var LineNum=0
	////电子病历信息
	var EMRSignInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetEMRSignUseID",
	    AdmRowId:EpisodeID, UserID:session['LOGON.USERID'], EMRType:EMRCertificate,
	    dataType:"text"
	},false)
	//var EMRSignInfo=tkMakeServerCall("web.UDHCPrescript","GetEMRSignUseID",EpisodeID,session['LOGON.USERID'],"EMRCertificate");
	var EMRSignInfoArr=EMRSignInfo.split("^")
	if (EMRSignInfoArr[0]==""){
		$.messager.alert("提示","疾病诊断证明书找不到有效的签名医生")
		return
	}
	var SignUserID=EMRSignInfoArr[0]
	var SignUserName=EMRSignInfoArr[1]
	var EMRInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetEMRCertificateInfo",
	    AdmRowId:EpisodeID, UserID :session['LOGON.USERID'],
	    dataType:"text"
	},false)
	//var EMRInfo=tkMakeServerCall("web.UDHCPrescript","GetEMRCertificateInfo",EpisodeID,session['LOGON.USERID']);
	var EMRInfoArr=EMRInfo.split(String.fromCharCode(1))
	
	MyPara=MyPara+'^SignData'+String.fromCharCode(2)+EMRInfoArr[1]
	MyPara=MyPara+'^LingChuangDia'+String.fromCharCode(2)+EMRInfoArr[2]
	MyPara=MyPara+'^WorkStat'+String.fromCharCode(2)+EMRInfoArr[3]
	MyPara=MyPara+'^Page'+String.fromCharCode(2)+"1"
	MyPara=MyPara+'^TotaPage'+String.fromCharCode(2)+"1"
	//MyList=EMRInfoArr[4].split("|||")[0]+String.fromCharCode(2)+EMRInfoArr[4].split("|||")[1]
	var EMRListArr=EMRInfoArr[4].split("|||")
	for (var i=0;i<EMRListArr.length;i++){
		var EMRName=EMRListArr[i].split("^")[0]
		var EMRDetail=EMRListArr[i].split("^")[1]
		///如果有换行符
		if (EMRDetail.indexOf(String.fromCharCode(10))){
			var EMRInfoLineArr=EMRDetail.split(String.fromCharCode(10))
			for (var j=0;j<EMRInfoLineArr.length;j++){
				var strLen=strlen(EMRInfoLineArr[j])
				var TMPStr=EMRInfoLineArr[j]
				do {
					var StrInfo=GetStrInfo(TMPStr,BreakLeng)
					///保证只有第一次循环才会将病历表头赋值
					if ((j==0)&&(TMPStr==EMRInfoLineArr[j])){
						MyList=MyList+String.fromCharCode(2)+EMRName+"^"+StrInfo.split("^")[0]
					}else{
						MyList=MyList+String.fromCharCode(2)+"^"+StrInfo.split("^")[0]
					}
					LineNum+=1;
					TMPStr=StrInfo.split("^")[1]
				}while (TMPStr!="")
			}
		}
	}

	if (GetGifInfo(SignUserID)==0){
		MyPara=MyPara+'^UserGif'+String.fromCharCode(2)+"c:\\"+SignUserID+".gif"
	}else{
		MyPara=MyPara+'^UserName'+String.fromCharCode(2)+SignUserName
	}
	var myobj = document.getElementById('ClsBillPrint');
	DHCP_PrintFunHDLP(myobj, MyPara, MyList);
}

function PrintEMRInfo(PatientID, EpisodeID, MRADMID,Type,SignUser){
	
	///电子病历内容换行数量
	var BreakLeng=50;
	////诊断内容换行数量
	var DiaDescBreakLeng=25;
	////西药换行数量
	var XOrdDescBreakLeng=50;
	///检查检验换行数量
	var SOrdDescBreakLeng=63;
	///嘱托换行
	var ZTOrdDescBreakLeng=63;
	////每页可以容纳多少行数据
	var PageOnLine=25
	DHCP_GetXMLConfig('XMLObject','EMRPrint');
	if (typeof Type =="undefined"){
		Type="OPEMR";
	}
	if (typeof SignUser =="undefined"){
		SignUser=session['LOGON.USERID'];
	}
	var PatientInfo = GetPatientBaseInfo(PatientID, EpisodeID);
	//获取病人本次就诊的诊断信息
	MyPara=PatientInfo;
	var ListP=String.fromCharCode(2);
	var MyList="";
	var LastMyList="";	///需要放置在后面的行
	var LineNum=0
	var EMRSignInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetEMRSignUseID",
	    AdmRowId:EpisodeID, UserID:SignUser, EMRType:Type,
	    dataType:"text"
	},false)
	//var EMRSignInfo=tkMakeServerCall("web.UDHCPrescript","GetEMRSignUseID",EpisodeID,SignUser,Type);
	var EMRSignInfoArr=EMRSignInfo.split("^")
	if (EMRSignInfoArr[0]==""){
		$.messager.alert("提示","门诊病历找不到有效的签名医生")
		return
	}
	//alert(EMRSignInfo)
	var SignUserID=EMRSignInfoArr[0]
	var SignUserName=EMRSignInfoArr[1]
	////电子病历信息9^10
	var EMRInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetEMRInfo",
	    AdmRowId:EpisodeID, UserID:SignUser, Type:Type,
	    dataType:"text"
	},false)
	//var EMRInfo=tkMakeServerCall("web.UDHCPrescript","GetEMRInfo",EpisodeID,SignUser,Type);
	var EMRInfoArr=EMRInfo.split("|||");
	for (var i=0;i<EMRInfoArr.length;i++){
		var EMRName=EMRInfoArr[i].split("^")[0]
		var EMRDetail=EMRInfoArr[i].split("^")[1]
		///如果有换行符
		if (EMRDetail.indexOf(String.fromCharCode(10))){
			var EMRInfoLineArr=EMRDetail.split(String.fromCharCode(10))
			for (var j=0;j<EMRInfoLineArr.length;j++){
				var strLen=strlen(EMRInfoLineArr[j])
				var TMPStr=EMRInfoLineArr[j]
				do {
					var StrInfo=GetStrInfo(TMPStr,BreakLeng)
					///保证只有第一次循环才会将病历表头赋值
					if ((EMRName.indexOf("处")>=0)&&(EMRName.indexOf("置")>=0)){
						if ((j==0)&&(TMPStr==EMRInfoLineArr[j])){
							if (LastMyList==""){
								LastMyList="^^^^^^^^"+EMRName+"^"+StrInfo.split("^")[0]+"^^^"
							}else{
								LastMyList=LastMyList+ListP+"^^^^^^^^"+EMRName+"^"+StrInfo.split("^")[0]+"^^^"
							}
						}else{
							if (LastMyList==""){
								LastMyList="^^^^^^^^"+"^"+StrInfo.split("^")[0]+"^^^"
							}else{
								LastMyList=LastMyList+ListP+"^^^^^^^^"+"^"+StrInfo.split("^")[0]+"^^^"
							}
						}
					}else{
						if ((j==0)&&(TMPStr==EMRInfoLineArr[j])){
							MyList=MyList+ListP+"^^^^^^^^"+EMRName+"^"+StrInfo.split("^")[0]+"^^^"
						}else{
							MyList=MyList+ListP+"^^^^^^^^"+"^"+StrInfo.split("^")[0]+"^^^"
						}
					}
					LineNum+=1;
					TMPStr=StrInfo.split("^")[1]
				}while (TMPStr!="")
			}
		}
	}
	///诊断数据打印2^3^4  这时MyList肯定不为空
	var PatMradmInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetMRDiagnosDesc",
	    MRAdmRowid:MRADMID, DelimStr:"", LogLocId:session['LOGON.CTLOCID'],
	    dataType:"text"
	},false)
	//var PatMradmInfo=tkMakeServerCall("web.UDHCPrescript","GetMRDiagnosDesc",MRADMID,"",session['LOGON.CTLOCID']);
	var PatMradmInfoArr=PatMradmInfo.split("||");
	var XYDiagList=PatMradmInfoArr[0]
	var ZYDiagList=PatMradmInfoArr[1]
	var ZYDiagListArr=ZYDiagList.split("^")
	for (var i =0;i<ZYDiagListArr.length;i++){
		var TMPStr=ZYDiagListArr[i]
		do {
			var StrInfo=GetStrInfo(TMPStr,DiaDescBreakLeng)
			///保证只有第一次循环
			if ((i==0)&&(TMPStr==ZYDiagListArr[i])){
				MyList=MyList+ListP+"^诊断^中医诊断:^"+StrInfo.split("^")[0]+"^^^^^^^^^^"
			}else{
				MyList=MyList+ListP+"^^^"+StrInfo.split("^")[0]+"^^^^^^^^^^"
			}
			LineNum+=1;
			TMPStr=StrInfo.split("^")[1]
		}while (TMPStr!="")
	}
	//alert(XYDiagList)
	var XYDiagListArr=XYDiagList.split("^")
	for (var i =0;i<XYDiagListArr.length;i++){
		var TMPStr=XYDiagListArr[i]
		do {
			var StrInfo=GetStrInfo(TMPStr,DiaDescBreakLeng)
			///保证只有第一次循环
			//alert(TMPStr+"11111"+XYDiagListArr[i]+"##"+i)
			if ((i==0)&&(TMPStr==XYDiagListArr[i])){
				MyList=MyList+ListP+"^^西医诊断:^"+StrInfo.split("^")[0]+"^^^^^^^^^^"
			}else{
				MyList=MyList+ListP+"^^^"+StrInfo.split("^")[0]+"^^^^^^^^^^"
			}
			LineNum+=1;
			TMPStr=StrInfo.split("^")[1]
		}while (TMPStr!="")
	}
	MyList=MyList+ListP+"处理:^^^^^^^^^^^^^"
	LineNum+=1;
	////除处方之外的医嘱信息，拼串
	var SOrdInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetSOrdInfo",
	    AdmRowId:EpisodeID,
	    dataType:"text"
	},false)
	//var SOrdInfo=tkMakeServerCall("web.UDHCPrescript","GetSOrdInfo",EpisodeID);
	var SOrdInfoArr=SOrdInfo.split(String.fromCharCode(2));
	for (var i =0;i<SOrdInfoArr.length;i++){
		if (SOrdInfoArr[i]==""){
			continue
		}
		var strLen=strlen(SOrdInfoArr[i])
		var TMPStr=SOrdInfoArr[i]
		do {
			var StrInfo=GetStrInfo(TMPStr,SOrdDescBreakLeng)
			///保证只有第一次循环才会将病历表头赋值
			MyList=MyList+ListP+"^^^^"+StrInfo.split("^")[0]+"^^^^^^^^^"
			LineNum+=1;
			TMPStr=StrInfo.split("^")[1]
		}while (TMPStr!="")
	}
	
	////协定处方
	var FormulaOrdInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetFormulaOrdInfo",
	    AdmRowId:EpisodeID,
	    dataType:"text"
	},false)
	//var FormulaOrdInfo=tkMakeServerCall("web.UDHCPrescript","GetFormulaOrdInfo",EpisodeID);
	if (FormulaOrdInfo!=""){
		var FormulaOrdInfoArr=FormulaOrdInfo.split(String.fromCharCode(2));
		for (var i =0;i<FormulaOrdInfoArr.length;i++){
			//alert(CMOrdInfoArr[i])
			if (FormulaOrdInfoArr[i]==""){
				continue
			}
			var TmpInfo=FormulaOrdInfoArr[i].split("||");
			var TmpARCOSName=TmpInfo[0];
			var ARCOSInfo=TmpInfo[1];
			var StrInfo=GetStrInfo(TmpARCOSName,XOrdDescBreakLeng)
			MyList=MyList+ListP+"^^^^"+StrInfo.split("^")[0]+"^"+ARCOSInfo+"^^^^^^^^^"
			LineNum+=1;
			if (StrInfo.split("^")[1]!=""){
				MyList=MyList+ListP+"^^^^"+StrInfo.split("^")[1]+"^^^^^^^^^"
				LineNum+=1;
			}
		}
	}
	
	////草药处方
	var CMOrdInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetCMOrdInfo",
	    AdmRowId:EpisodeID,
	    dataType:"text"
	},false)
	//var CMOrdInfo=tkMakeServerCall("web.UDHCPrescript","GetCMOrdInfo",EpisodeID);
	if (CMOrdInfo!=""){
		var CMOrdInfoArr=CMOrdInfo.split(String.fromCharCode(2));
		for (var i =0;i<CMOrdInfoArr.length;i++){
			//alert(CMOrdInfoArr[i])
			if (CMOrdInfoArr[i]==""){
				continue
			}
			var TmpInfo=CMOrdInfoArr[i].split("||");
			var TmpCMOrdInfo=TmpInfo[0];
			var CookInfo=TmpInfo[1];
			var TmpCMOrdInfoArr=TmpCMOrdInfo.split("&");
			for (var j =0;j<TmpCMOrdInfoArr.length;j++){
				var TmpCMOrdInfoLineArr=TmpCMOrdInfoArr[j].split("#");
				MyList=MyList+ListP+"^^^^^^^^^^"+TmpCMOrdInfoLineArr[0]+"^"+TmpCMOrdInfoLineArr[1]+"^";
				LineNum+=1;
			}
			MyList=MyList+ListP+"^^^^^^^^^^^^"+CookInfo;
			LineNum+=1;
		}
	}
	//alert(MyList)
	////西药处方
	var OrdInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetOrdInfo",
	    AdmRowId:EpisodeID,
	    dataType:"text"
	},false)
	//var OrdInfo=tkMakeServerCall("web.UDHCPrescript","GetOrdInfo",EpisodeID);
	if (OrdInfo!=""){
		var OrdInfoArr=OrdInfo.split(String.fromCharCode(2))
		for (var i =0;i<OrdInfoArr.length;i++){
			var TmpInfo=OrdInfoArr[i].split("^")
			var OrdName=TmpInfo[0]
			var DoseQty=TmpInfo[1]
			var Freq=TmpInfo[2]
			var Instr=TmpInfo[3]
			var StrInfo=GetStrInfo(OrdName,XOrdDescBreakLeng)
			MyList=MyList+ListP+"^^^^"+StrInfo.split("^")[0]+"^"+DoseQty+"^"+Freq+"^"+Instr+"^^^^^^"
			LineNum+=1;
			if (StrInfo.split("^")[1]!=""){
				MyList=MyList+ListP+"^^^^"+StrInfo.split("^")[1]+"^^^^^^^^^"
				LineNum+=1;
			}
		}
	}
	///把处置放在门诊病历最后面
	if (LastMyList!=""){
		MyList=MyList+ListP+LastMyList
	}
	///嘱托
	MyList=MyList+ListP+"^^^^^^^^嘱托:^^^^^"
	LineNum+=1;
	////除处方之外的医嘱信息，拼串
	var ZTOrdInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetZTOrdInfo",
	    AdmRowId:EpisodeID,
	    dataType:"text"
	},false)
	//var ZTOrdInfo=tkMakeServerCall("web.UDHCPrescript","GetZTOrdInfo",EpisodeID);
	var ZTOrdInfoArr=ZTOrdInfo.split(String.fromCharCode(2));
	for (var i =0;i<ZTOrdInfoArr.length;i++){
		if (ZTOrdInfoArr[i]==""){
			continue
		}
		var strLen=strlen(ZTOrdInfoArr[i])
		var TMPStr=ZTOrdInfoArr[i]
		do {
			var StrInfo=GetStrInfo(TMPStr,ZTOrdDescBreakLeng)
			///保证只有第一次循环才会将病历表头赋值
			MyList=MyList+ListP+"^^^^"+StrInfo.split("^")[0]+"^^^^^^^^^"
			LineNum+=1;
			TMPStr=StrInfo.split("^")[1]
		}while (TMPStr!="")
	}
	
	
	///-------------
	///生成签名图片
	///var UserGif=session['LOGON.USERID']
	if (GetGifInfo(SignUserID)==0){
		MyPara=MyPara+'^UserGif'+String.fromCharCode(2)+"c:\\"+SignUserID+".gif"
	}else{
		MyPara=MyPara+'^UserName'+String.fromCharCode(2)+SignUserName
	}
	//alert(MyPara)
	////分页
	//var myobj = parent.frames[1].document.getElementById('ClsBillPrint');
	//if (!myobj){
		var myobj = document.getElementById('ClsBillPrint');
	//}
	///2016-05-18
	var LineNum=MyList.split(ListP).length;
	///----
	var TotaPage=Math.ceil(LineNum/PageOnLine)
	MyPara=MyPara+'^TotaPage'+String.fromCharCode(2)+TotaPage;
	var MyListArr=MyList.split(ListP)
	for (i = 1; i <= TotaPage; i++) {
		var EndLine=parseInt(i*PageOnLine-1)
		if (EndLine>MyListArr.length){
			EndLine=MyListArr.length
		}
		var MyList1Arr=MyListArr.slice(parseInt((i-1)*PageOnLine),parseInt(i*PageOnLine));
		var MyList1=MyList1Arr.join(ListP)
		
		//alert(parseInt((i-1)*PageOnLine)+"@@@"+parseInt(i*PageOnLine-1))
		DHCP_PrintFunHDLP(myobj, MyPara+'^Page'+String.fromCharCode(2)+i, MyList1);
	}
}

function PrintOutBuyInfo(PatientID, EpisodeID, mradm){

	var strSelectedOrder=GetSelectedOrder()
	//alert(strSelectedOrder)
	if (strSelectedOrder==""){
		$.messager.alert("提示","请选相应医嘱,进行打印操作!")
		return
	}
	//打印药店处方
	var MyPara="",MyList="",MyListStr="";
	DHCP_GetXMLConfig('XMLObject','DHCOPCMEXEPrint');
	var retOrdItemInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetOutBuyInfo",
	    EpisodeID:EpisodeID, OrdItemList:strSelectedOrder,
	    dataType:"text"
	},false)
	//var retOrdItemInfo=tkMakeServerCall("web.UDHCPrescript","GetOutBuyInfo",EpisodeID,strSelectedOrder,session['LOGON.CTLOCID']);
	if (retOrdItemInfo==""){
		return
	}
	var myobj = document.getElementById('ClsBillPrint');
	//获取病人的基本信息
	var PatientInfo=GetPatientBaseInfo(PatientID,EpisodeID);
	//获取病人本次就诊的诊断信息
	var MradmInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetMRDiagnosDescNew",
	    MRAdmRowid:mradm, DelimStr:";", LogonCTLocRowId:session['LOGON.CTLOCID'],
	    dataType:"text"
	},false)
	//var MradmInfo=tkMakeServerCall("web.UDHCPrescript","GetMRDiagnosDescNew",mradm,";",session['LOGON.CTLOCID']);
	var MradmInfoArry=MradmInfo.split(" ");
	MyPara=PatientInfo+'^Diagnose'+String.fromCharCode(2)+MradmInfo;
	var UserGif=session['LOGON.USERID'];
	var SignUserName=session['LOGON.USERNAME'];
	if (GetGifInfo(UserGif)==0){
		MyPara=MyPara+'^UserGif'+String.fromCharCode(2)+"c:\\"+SignUserID+".gif"
	}else{
		MyPara=MyPara+'^UserName'+String.fromCharCode(2)+SignUserName;
	}
	var retOrdItemInfoArr=retOrdItemInfo.split("PerDlim");
	for (var i=0;i<retOrdItemInfoArr.length;i++) {
		var PerOrderInfo=retOrdItemInfoArr[i];
		var PerOrderInfoArr=PerOrderInfo.split("TotaDlim")
		var PMyPara=MyPara+'^TotaPage'+String.fromCharCode(2)+PerOrderInfoArr[0];
		var OnePageinlistArr=PerOrderInfoArr[1].split("PageDlim")
		for (var j=0;j<OnePageinlistArr.length;j++) {
			var LMyPara=PMyPara+'^Page'+String.fromCharCode(2)+(j+1);
			//alert(OnePageinlistArr[j])
			DHCP_PrintFunHDLP(myobj, LMyPara, OnePageinlistArr[j]);
		}
	}
}
function GetPatientBaseInfo(PatientID,EpisodeID,PrintType){
	if (typeof PrintType =="undefined"){
		PrintType="";
	}
	//var GetPatient=document.getElementById('GetPatient');
	//if (GetPatient) {var encmeth=GetPatient.value} else {var encmeth=''};
	var GetPatientInfo=$.cm({
	    ClassName : "web.DHCDocOrderEntry",
	    MethodName : "GetPatientByRowid",
	    PapmiRowid:PatientID, EpisodeID:EpisodeID,
	    dataType:"text"
	},false)
	//var GetPatientInfo=tkMakeServerCall("web.DHCDocOrderEntry","GetPatientByRowid",PatientID,EpisodeID);
	if (GetPatientInfo!='') {
		//var GetPatientInfo=cspRunServerMethod(encmeth,PatientID);
		var PatientInfoArr=GetPatientInfo.split("^");
		var PatientNo=PatientInfoArr[1],PatientName=PatientInfoArr[2];
 		var PatientSex=PatientInfoArr[3],PatientAge=PatientInfoArr[4];
 		var PatBirthday=PatientInfoArr[5],PatCompany=PatientInfoArr[14];
 		var MRNo=PatientInfoArr[18],PatientTel=PatientInfoArr[24];
 		var Pattype=PatientInfoArr[6],InsuNo=PatientInfoArr[28];
 		var PersonIDNo=PatientInfoArr[29];
	}
	var PatientAge=$.cm({
	    ClassName : "web.DHCBillInterface",
	    MethodName : "GetPapmiAge",
	    Papmi:PatientID, Adm:EpisodeID,
	    dataType:"text"
	},false)
	var PAAdmInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetPatInform",
	    AdmRowId:EpisodeID,
	    dataType:"text"
	},false)
	//var PatientAge=tkMakeServerCall("web.DHCBillInterface","GetPapmiAge",PatientID,EpisodeID);
	//var PAAdmInfo=tkMakeServerCall("web.UDHCPrescript","GetPatInform",EpisodeID);
 	var PAAdmInfoArr=PAAdmInfo.split("^");
	var AdmDep=PAAdmInfoArr[2],AdmDate=PAAdmInfoArr[3],AdmDepDr=PAAdmInfoArr[5],PAAdmBed=PAAdmInfoArr[7];
	var HosName=PAAdmInfoArr[4];
	var AdmReasonDesc=PAAdmInfoArr[6]
	var NCDList="" //PAAdmInfoArr[5]
	var PrescTitle="",Childweight="";
	var CTLocPrintTypeID=$.cm({
	    ClassName : "web.DHCDocPrescript",
	    MethodName : "GetCTLocPrintTypeID",
	    LocId:AdmDepDr,
	    dataType:"text"
	},false)
	//var CTLocPrintTypeID=tkMakeServerCall("web.DHCDocPrescript","GetCTLocPrintTypeID",AdmDepDr)
	if(CTLocPrintTypeID==1){
		var rtn=$.cm({
		    ClassName : "web.UDHCPrescript",
		    MethodName : "SetGetChildWeight",
		    EpisodeID:EpisodeID, Weight:"",
		    dataType:"text"
		},false)
		//var rtn=tkMakeServerCall("web.UDHCPrescript","SetGetChildWeight",EpisodeID,"");
		if (rtn!='') {				
	        var str=rtn.split("^");
	        if((str[0]=="1")&&(str[1]=="")){
		        if (PrintType=="Presc"){
			         $.messager.alert("提示","儿科必须填写体重!");
		             return false;
			    }
		    }
		    Childweight="体重:"+str[1]+"KG";
		}
		PrescTitle="[儿科]";
	}
	if(CTLocPrintTypeID==2){
		    PrescTitle="[急]";
	}
	//此处判断是否是儿科或者急诊不正确，应该根据设置去控制
	/*if (AdmDep.indexOf("儿科")!=-1) {
		var rtn=tkMakeServerCall("web.UDHCPrescript","SetGetChildWeight",EpisodeID,"");
		if (rtn!='') {				
	        var str=rtn.split("^");
	        if((str[0]=="1")&&(str[1]=="")){
		         alert("儿科必须填写体重!");
		         return "";
		    }
		    Childweight="体重:"+str[1];
		}
		PrescTitle="[儿科]";
	}else if (AdmDep.indexOf("急")!=-1) {PrescTitle="[急]";}*/
	

	var PrintDateTime=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetSystemDateTime",
	    dataType:"text"
	},false)
	//var PrintDateTime=tkMakeServerCall("web.UDHCPrescript","GetSystemDateTime");
	var gmsy="",PrintFormat="",BillType="",UserAddName="";
	var SupplyCardNo="",Duration=""
	var MyPara='PrescTitle'+String.fromCharCode(2)+PrescTitle;
	//MyPara=MyPara+'^PatientMedicareNo'+String.fromCharCode(2)+InsuNo;
	MyPara=MyPara+'^MRNo'+String.fromCharCode(2)+MRNo;
	MyPara=MyPara+'^PANo'+String.fromCharCode(2)+PatientNo;
	MyPara=MyPara+'^PANoBarCode'+String.fromCharCode(2)+("*"+PatientNo+"*");
	MyPara=MyPara+'^AdmDep'+String.fromCharCode(2)+AdmDep;
	MyPara=MyPara+'^Name'+String.fromCharCode(2)+PatientName;
	MyPara=MyPara+'^Sex'+String.fromCharCode(2)+PatientSex;
	MyPara=MyPara+'^Age'+String.fromCharCode(2)+PatientAge;
	MyPara=MyPara+'^gmsy'+String.fromCharCode(2)+gmsy;
	MyPara=MyPara+'^Company'+String.fromCharCode(2)+PatCompany;
	MyPara=MyPara+'^AdmDate'+String.fromCharCode(2)+AdmDate;
	MyPara=MyPara+'^UserAddName'+String.fromCharCode(2)+UserAddName;
	MyPara=MyPara+'^BillType'+String.fromCharCode(2)+BillType;
	MyPara=MyPara+'^PrintFormat'+String.fromCharCode(2)+PrintFormat;
	MyPara=MyPara+'^Childweight'+String.fromCharCode(2)+Childweight;
	//MyPara=MyPara+'^SupplyCard'+String.fromCharCode(2)+SupplyCardNo;
	MyPara=MyPara+'^Duration'+String.fromCharCode(2)+Duration;
	MyPara=MyPara+'^PatientTel'+String.fromCharCode(2)+PatientTel;
	MyPara=MyPara+'^IDCardNo'+String.fromCharCode(2)+PersonIDNo;
	MyPara=MyPara+'^PatientMedicareNo'+String.fromCharCode(2)+PersonIDNo;
	MyPara=MyPara+'^PrintDateTime'+String.fromCharCode(2)+PrintDateTime;
	MyPara=MyPara+'^AdmReasonDesc'+String.fromCharCode(2)+AdmReasonDesc;
	if (PrintType=="guid"){
		MyPara=MyPara+'^HosName'+String.fromCharCode(2)+HosName+"导诊单";
	}else{
		MyPara=MyPara+'^HosName'+String.fromCharCode(2)+HosName;
	}
	
	if (NCDList!=""){
		MyPara=MyPara+'^NCDList'+String.fromCharCode(2)+"慢病病种:"+NCDList;
	}
	if (DisPlayType=="MJ") MyPara=MyPara+'^PAAdmBed'+String.fromCharCode(2)+"床号:"+PAAdmBed;
	return MyPara;
}

function PrintGuideInfo()
{
	var strSelectedOrder=GetSelectedOrder()
	//alert(strSelectedOrder)
	if (strSelectedOrder==""){
		$.messager.alert("提示","请选相应医嘱,进行打印操作!")
		return
	}
	var myobj = document.getElementById('ClsBillPrint');
	//打印导诊单VB
	var MyPara="",MyList="",MyListStr="";
	///var PrintLine="_______________________________________________________________________________________";
	var PrintLine="-----------------------------------------------------------------";
	DHCP_GetXMLConfig('XMLObject','NewDHCDocOrderDirectPrint')
	//DHCP_GetXMLConfig('XMLObject','DHCDOCOrderDirectPrint');
	//DHCP_GetXMLConfig('XMLObject','DHCDocGuidePatDocuments');
	//获取病人的基本信息
	var PatientInfo=GetPatientBaseInfo(PatientID,EpisodeID,"guid");
	//获取病人本次就诊的诊断信息
	var MradmInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetMRDiagnosDescNew",
	    MRAdmRowid:mradm, DelimStr:";", LogonCTLocRowId:session['LOGON.CTLOCID'],
	    dataType:"text"
	},false)
	//var MradmInfo=tkMakeServerCall("web.UDHCPrescript","GetMRDiagnosDescNew",mradm,";",session['LOGON.CTLOCID']);
	var MradmInfoArry=MradmInfo.split(" ");
	MyPara=PatientInfo+'^Diagnose'+String.fromCharCode(2)+MradmInfo;
	
	MyPara=MyPara+'^Diagnose1'+String.fromCharCode(2)+MradmInfo.substring(0,30);
	MyPara=MyPara+'^Diagnose2'+String.fromCharCode(2)+MradmInfo.substring(30,MradmInfo.length);

	var UserGif=session['LOGON.USERID']
	var UserName=session['LOGON.USERNAME']
	if (GetGifInfo(UserGif)==0){
		MyPara=MyPara+'^UserGif'+String.fromCharCode(2)+"c:\\"+UserGif+".gif"
	}else{
		MyPara=MyPara+'^UserName'+String.fromCharCode(2)+UserName
	}
	//alert(MyPara)
	/*
	var retOrdItemInfo=tkMakeServerCall("web.UDHCPrescript","GetOrdItemInfo",EpisodeID,strSelectedOrder,session['LOGON.CTLOCID']);
	//alert("ret+"+retOrdItemInfo)
	var OrdItemArr=retOrdItemInfo.split(String.fromCharCode(1));
	for (var i=0;i<OrdItemArr.length;i++){
		var OrdItemArr1=OrdItemArr[i].split(String.fromCharCode(2));
		if (MyListStr==""){
			MyListStr=OrdItemArr1[0];     //+PrintLine;
		}else{
			MyListStr=MyListStr+String.fromCharCode(2)+OrdItemArr1[0];   //+PrintLine;
		}
		var OrdItemArr2=OrdItemArr1[1].split(String.fromCharCode(3));
		for (var j=0;j<OrdItemArr2.length;j++){
			MyListStr=MyListStr+String.fromCharCode(2)+OrdItemArr2[j];					
		}
		if(OrdItemArr.length-1>i)MyListStr=MyListStr+String.fromCharCode(2)+PrintLine;
	}
	*/
	//var MyListStr=tkMakeServerCall("web.UDHCPrescript","GetOrdItemInfoNew",EpisodeID,strSelectedOrder,session['LOGON.CTLOCID']);
	var MyListStr=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetOrdItemInfoNew",
	    EpisodeID:EpisodeID, OrdItemList:strSelectedOrder,
	    dataType:"text"
	},false)
	//var MyListStr=tkMakeServerCall("web.UDHCPrescript","GetOrdItemInfoNew",EpisodeID,strSelectedOrder);
	/*
	var PrintPage=0;  //打印页码
	//var myobj=parent.frames[1].document.getElementById('ClsBillPrint');
	//if (!myobj){
	
	//}
	var MyListArr=MyListStr.split(String.fromCharCode(2));
	var PageTotal=Math.ceil(MyListArr.length/25); //15
	for (var j=1;j<=MyListArr.length;j++){
		if(MyList==""){MyList=MyListArr[j-1];}
		else{MyList=MyList+String.fromCharCode(2)+MyListArr[j-1];}
		if ((j>1)&&(j%25==0)) {
			PrintPage=PrintPage+1;
			var PrintPageText="第 "+PrintPage+" 页  共 "+PageTotal+" 页"
			var MyPara1=MyPara+'^PrintPage'+String.fromCharCode(2)+PrintPageText;
			DHCP_PrintFunHDLP(myobj,MyPara1,MyList);
			MyList="";
		}
	}
	
	if((MyListArr.length%25)>0){
		var PrintPageText="第 "+PageTotal+" 页  共 "+PageTotal+" 页"
		var MyPara1=MyPara+'^PrintPage'+String.fromCharCode(2)+PrintPageText;
		DHCP_PrintFunHDLP(myobj,MyPara1,MyList);
	}
	
	*/
	//alert(MyListStr)
	var PageOnLine=17
	var MyListArr=MyListStr.split(String.fromCharCode(2));
	var LineNum=MyListArr.length
	var TotaPage=Math.ceil(LineNum/PageOnLine)
	debugger;
	//alert(TotaPage+"^"+LineNum+"^"+PageOnLine)
	for (i = 1; i <= TotaPage; i++) {
		var EndLine=parseInt(i*PageOnLine-1)
		if (EndLine>MyListArr.length){
			EndLine=MyListArr.length
		}
		
		var MyList1Arr=MyListArr.slice(parseInt((i-1)*PageOnLine),parseInt(i*PageOnLine));
		var MyList1=MyList1Arr.join(String.fromCharCode(2))
		
		//alert(parseInt((i-1)*PageOnLine)+"@@@"+parseInt(i*PageOnLine-1))
		DHCP_PrintFunHDLP(myobj, MyPara+'^PrintPage'+String.fromCharCode(2)+"第 "+i+" 页  共 "+TotaPage+" 页", MyList1);
	}
	
	var rtn=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "SetOrdItemPrintFlag",
	    OrdItemList:strSelectedOrder,
	    dataType:"text"
	},false)
	//var rtn=tkMakeServerCall("web.UDHCPrescript","SetOrdItemPrintFlag",strSelectedOrder);
}

function GetSelectedOrder()
{
	//OEItemID  datagrid
	var SelectedOrder=""
	var OrdListArr=$('#tabOrdList').datagrid('getChecked')
	//alert(OrdListArr.length)
	for (var i=0;i<OrdListArr.length;i++){
		var OEItemID=OrdListArr[i].OEItemID
		if (SelectedOrder==""){
			SelectedOrder=OEItemID
		}else{
			SelectedOrder=SelectedOrder+"^"+OEItemID
		}
	}
	return SelectedOrder
}
function SaveSupplyInfo()
{
	SaveSupplyInfoCom(1);
}
function SaveSupplyInfoCom(Warning)
{
	var IsDPatCredNo=true,IsIdCardNo=true;
	var PatCredNo=$("#PatCredNo").val();
	if (PatCredNo!=""){
		var myrtn=IsCredTypeID("PAPMICredType");
		if (myrtn){
			var IsIdCardNo=DHCWeb_IsIdCardNo(PatCredNo);
			if (!IsIdCardNo){
				return false;
			}
			var IDNoInfoStr=DHCWeb_GetInfoFromId(PatCredNo)
			var IDBirthday=IDNoInfoStr[2]  
			if (PatDobDate!=IDBirthday){
				$.messager.alert("提示","出生日期与身份证信息不符!","info",function(){
					$("#PatCredNo").focus();
				});
	   		    return false;
			}
			var IDSex=IDNoInfoStr[3]
			if(PatSex!=IDSex){
				$.messager.alert("提示","身份证号:"+PatCredNo+"对应的性别是【"+IDSex+"】,与患者本人性别不同!","info",function(){
					$('#PatCredNo').next('span').find('input').focus();
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
	if (SupplyCredNo!=""){
		var myrtn=IsCredTypeID("AgencyCredType");
		if (myrtn){
			var IsDPatCredNo=DHCWeb_IsIdCardNo(SupplyCredNo);
			if (!IsDPatCredNo){
				$.messager.alert("提示","代办人身份证号码错误!");
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
	    EpisodeID:EpisodeID, PatInfo:PatInfo,
	    dataType:"text"
	},false)
	if (rtn!=0) {
		$.messager.alert("提示","保存失败!"+rtn);
		return false;
	}
	var PatAddress=$("#PatAddress").val();
    if(PatAddress!=""){
	     var rtn=$.cm({
		    ClassName : "web.UDHCPrescript",
		    MethodName : "SavePatAddress",
		    PatientID:PatientID, PatAddress:PatAddress,
		    dataType:"text"
		},false)
	}
	var Weight=$("#Weight").val();
    if(Weight!=""){
	    var retOrdItemInfo=$.cm({
		    ClassName : "web.UDHCPrescript",
		    MethodName : "SaveWeight",
		    MRAdmID:mradm, Weight:Weight ,
		    dataType:"text"
		},false)
    }
	if(Warning=="1"){
		$.messager.alert("提示","保存成功")
	}
	return true;
}
function IsCredTypeID(id){
	var myval=$("#"+id).combobox("getValue");
	var myary = myval.split("^");
	if (myary[1]==m_IDCredTypePlate){
		return true;
	}else{
		return false;
	}
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
function PrintTreatInfo(PatientID, EpisodeID, MRADMID)
{
	var strSelectedOrder=GetSelectedOrder()
	if (strSelectedOrder==""){
		$.messager.alert("提示","请选相应医嘱,进行打印操作!")
		return
	}
	//打印治疗单
	var MyPara="",MyList="",MyListStr="";
	///var PrintLine="_______________________________________________________________________________________";
	var PrintLine="-----------------------------------------------------------------";
	DHCP_GetXMLConfig('XMLObject','MZJSSZYDTXD');
	var retOrdItemInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetOrdTreatInfo",
	    EpisodeID:EpisodeID, OrdItemList:strSelectedOrder,
	    dataType:"text"
	},false)
	//var retOrdItemInfo=tkMakeServerCall("web.UDHCPrescript","GetOrdTreatInfo",EpisodeID,strSelectedOrder,session['LOGON.CTLOCID']);
	if(retOrdItemInfo==""){
		return false;
	}
	var myobj = document.getElementById('ClsBillPrint');
	//获取病人的基本信息
	var PatientInfo=GetPatientBaseInfo(PatientID,EpisodeID);
	//获取病人本次就诊的诊断信息
	var MradmInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetMRDiagnosDescNew",
	    MRAdmRowid:mradm, DelimStr:";", LogonCTLocRowId:session['LOGON.CTLOCID'],
	    dataType:"text"
	},false)
	//var MradmInfo=tkMakeServerCall("web.UDHCPrescript","GetMRDiagnosDescNew",mradm,";",session['LOGON.CTLOCID']);
	var MradmInfoArry=MradmInfo.split(" ");
	MyPara=PatientInfo+'^Diagnose'+String.fromCharCode(2)+MradmInfo;
	var OrdItemArr=retOrdItemInfo.split(String.fromCharCode(3));
	for (var i=0;i<OrdItemArr.length;i++){
		var OneOrdItemArr=OrdItemArr[i].split("$")[0]
		var OneSum=OrdItemArr[i].split("$")[1]
		var OneOEORIUserDepartment=OrdItemArr[i].split("$")[2]
		var OneOEORIDoc=OrdItemArr[i].split("$")[3]
		var OneOEORIDate=OrdItemArr[i].split("$")[4]
		var OneTitle=OrdItemArr[i].split("$")[5]
		var MyPara1='^purpose1'+String.fromCharCode(2)+OneOrdItemArr+'^Sum'+String.fromCharCode(2)+OneSum;
		MyPara1=MyPara1+'^InLoc'+String.fromCharCode(2)+OneOEORIUserDepartment+'^DocUser'+String.fromCharCode(2)+OneOEORIDoc;
		MyPara1=MyPara1+'^HopeDate'+String.fromCharCode(2)+OneOEORIDate+'^Title'+String.fromCharCode(2)+OneTitle;
		var MyList=OneOrdItemArr
		DHCP_PrintFunHDLP(myobj,MyPara+MyPara1,MyList);
	}
	
}
function PrintValuationInfo(PatientID, EpisodeID, MRADMID)
{
	/*var strSelectedOrder=GetSelectedOrder()
	if (strSelectedOrder==""){
		alert("请选相应医嘱,进行导诊单打印操作!")
		return
	}
	//打印治疗单
	var MyPara="",MyList="",MyListStr="";
	///var PrintLine="_______________________________________________________________________________________";
	var PrintLine="-----------------------------------------------------------------";
	DHCP_GetXMLConfig('XMLObject','MZJSSZYDTXD');
	var retOrdItemInfo=tkMakeServerCall("web.UDHCPrescript","GetOrdValuationInfo",EpisodeID,strSelectedOrder,session['LOGON.CTLOCID']);
	if(retOrdItemInfo==""){
		return false;
	}
	var myobj = document.getElementById('ClsBillPrint');
	//获取病人的基本信息
	var PatientInfo=GetPatientBaseInfo(PatientID,EpisodeID);
	//获取病人本次就诊的诊断信息
	var MradmInfo=tkMakeServerCall("web.DHCMRDiagnos","GetMRDiagnosDesc",mradm,";");
	var MradmInfoArry=MradmInfo.split(" ");
	MyPara=PatientInfo+'^Diagnose'+String.fromCharCode(2)+MradmInfo;
	var OrdItemArr=retOrdItemInfo.split(String.fromCharCode(3));
	for (var i=0;i<OrdItemArr.length;i++){
		var OneOrdItemArr=OrdItemArr[i].split("$")[0]
		var OneSum=OrdItemArr[i].split("$")[1]
		var OneOEORIUserDepartment=OrdItemArr[i].split("$")[2]
		var OneOEORIDoc=OrdItemArr[i].split("$")[3]
		var OneOEORIDate=OrdItemArr[i].split("$")[4]
		var OneTitle=OrdItemArr[i].split("$")[5]
		MyPara1=MyPara1+'^InLoc'+String.fromCharCode(2)+OneOEORIUserDepartment+'^DocUser'+String.fromCharCode(2)+OneOEORIDoc;
		MyPara1=MyPara1+'^HopeDate'+String.fromCharCode(2)+OneOEORIDate+'^Title'+String.fromCharCode(2)+OneTitle;
		DHCP_PrintFunHDLP(myobj,MyPara+MyPara1,"");
	}*/
	var strSelectedOrder=GetSelectedOrder()
	//打印计价单
	var MyPara="",MyList="",MyListStr="";
	///var PrintLine="_______________________________________________________________________________________";
	var PrintLine="-----------------------------------------------------------------";
	DHCP_GetXMLConfig('XMLObject','MZJSSZYDTXD');
	var myobj = document.getElementById('ClsBillPrint');
	//获取病人的基本信息
	var PatientInfo=GetPatientBaseInfo(PatientID,EpisodeID);
	//获取病人本次就诊的诊断信息
	var MradmInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetMRDiagnosDescNew",
	    MRAdmRowid:mradm, DelimStr:";", LogonCTLocRowId:session['LOGON.CTLOCID'],
	    dataType:"text"
	},false)
	//var MradmInfo=tkMakeServerCall("web.UDHCPrescript","GetMRDiagnosDescNew",mradm,";",session['LOGON.CTLOCID']);
	var MradmInfoArry=MradmInfo.split(" ");
	MyPara=PatientInfo+'^Diagnose'+String.fromCharCode(2)+MradmInfo;
	var retOrdItemInfo=$.cm({
	    ClassName : "web.UDHCPrescript",
	    MethodName : "GetOrdValuationInfo",
	    EpisodeID:EpisodeID, OrdItemList:strSelectedOrder,
	    dataType:"text"
	},false)
	//var retOrdItemInfo=tkMakeServerCall("web.UDHCPrescript","GetOrdValuationInfo",EpisodeID,strSelectedOrder,session['LOGON.CTLOCID']);
	if(retOrdItemInfo=="") return false;
	var OrdItemInfoArr=retOrdItemInfo.split(String.fromCharCode(1));
	for (var i=0;i<OrdItemInfoArr.length;i++){
		var Title=OrdItemInfoArr[i].split("$")[0]
		var ARCOSSum=OrdItemInfoArr[i].split("$")[1]
		var OEORIDate=OrdItemInfoArr[i].split("$")[2]
		var OEORIUserDepartment=OrdItemInfoArr[i].split("$")[3]
		var OEORIDoc=OrdItemInfoArr[i].split("$")[4]
		var ARCOSDesc=OrdItemInfoArr[i].split("$")[5]
		var OrderStr=OrdItemInfoArr[i].split("$")[6]
		if(OrderStr=="") continue
		//alert(OrderStr)
		MyList=ARCOSDesc
		var OrderStrArr=OrderStr.split(String.fromCharCode(3))
		for (var j=0;j<OrderStrArr.length;j++){
			var OrdItemArr1=OrderStrArr[j];
			if (MyList==""){
			  MyList=OrdItemArr1     
		    }else{
			  MyList=MyList+String.fromCharCode(2)+OrdItemArr1   
		    }
		}
		MyPara=MyPara+'^purpose1'+String.fromCharCode(2)+""+'^Sum'+String.fromCharCode(2)+ARCOSSum;
	    MyPara=MyPara+'^InLoc'+String.fromCharCode(2)+OEORIUserDepartment+'^DocUser'+String.fromCharCode(2)+OEORIDoc;
	    MyPara=MyPara+'^HopeDate'+String.fromCharCode(2)+OEORIDate+'^Title'+String.fromCharCode(2)+Title;
	    DHCP_PrintFunHDLP(myobj,MyPara,MyList);
	} 
}
function OrderPrescNoLinkDiag(OrderPrescNo){
	var url="dhcdocdiagnoseselect.hui.csp?EpisodeID="+EpisodeID+"&PrescNoStr="+OrderPrescNo+"&ExitFlag="+"Y";
	websys_showModal({
		url:url,
		title:OrderPrescNo+"关联诊断",
		width:$(window).width()-150,
		height:$(window).height()-50
	});
}
function OrderPrescNoclick(OrderPrescNo)
{
	//OEItemID  datagrid
	var AllPrescNo=""
	var OrdList=$('#tabOrdList').datagrid('getData')
	for (var i=0;i<OrdList.rows.length;i++) {
		var myPrescNo=OrdList.rows[i].OrderPrescNo
		if (myPrescNo==""){
			continue
		}
		if (AllPrescNo==""){
			AllPrescNo=myPrescNo
		}else{
			AllPrescNo=AllPrescNo+"^"+myPrescNo
		}
	}
    //+OrderPrescNo
	//var lnk = "dhcdoc.viewpresclist.csp?PrescNoStr="+AllPrescNo+"&EpisodeID="+EpisodeID+"&PrescNoMain="+"&DisPlayType="+DisPlayType;
    //window.open(lnk,"","status=1,top=40,left=50,width=900,height=700,scrollbars=Yes,status=1,resizable=yes");
    var src="dhcdoc.viewpresclist.csp?PrescNoStr="+AllPrescNo+"&EpisodeID="+EpisodeID+"&PrescNoMain="+"&DisPlayType="+DisPlayType+"&SearchDate="+$("#SearchDate").datebox('getValue');
	var $code ="<iframe width='100%' height='99%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("BookCreat","处方预览", 900, 700,"icon-funnel-eye","",$code,"");
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
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(sysDateFormat=="4"){
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