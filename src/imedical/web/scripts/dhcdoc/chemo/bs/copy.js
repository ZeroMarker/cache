/**
 * copy.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
$(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	InitTree("cur-tree","CUR")
	InitCurrentPLInfo()
}

function InitEvent () {
	
}

function InitCurrentPLInfo (PLID,InPatientID) {
	InPatientID=InPatientID||ServerObj.PatientID,
	PLID=PLID||ServerObj.PLID;
	
	if (InPatientID!="") {
		$cm({
			ClassName:"DHCDoc.THPY.Model.StageInfo",
			MethodName:"GetCurrentPLInfo",
			InPatientID: InPatientID,
			PLID:PLID
		},function(MObj){
			var PLName = MObj.PlanName||"";
			var CurrentStage = MObj.CurrentStage||"";
			if (PLName!="") {
				$("#CPLName").text(PLName + " ��" + CurrentStage+"�׶�")
			} else {
				$("#CPLName").text("��")
			}
			
			
		});
	}
}
function InitTree(ID,InType,InUser,InDep,InHosp,InPatientID) {
	ID=ID||""
	InType=InType||"",
	InUser=InUser||session['LOGON.USERID'],
	InDep=InDep||session['LOGON.CTLOCID'],
	InHosp=InHosp||session['LOGON.HOSPID'];
	InPatientID=InPatientID||ServerObj.PatientID;
	if (ID=="") {
		return false;
	}
	$HUI.tree("#"+ID, {
		fit: true,
		url: $URL,
		checkbox: false,
		lines: true,
		animate: true,
		onBeforeLoad: function (node, param) {
			param.ClassName = "DHCDoc.THPY.BS.Apply";
			param.MethodName = "GetTreeByType";
			param.ResultSetType = "array";
			param.InType = InType;
			param.InUser = InUser;	
			param.InDep = InDep;
			param.InHosp = InHosp;
			param.InPatientID = ServerObj.PatientID;
		},
		onClick: function(node){
			var isLeaf = $(this).tree('isLeaf', node.target);
			if (isLeaf) {
				var TPID = node.id.split("-")[0];
				var InStage = node.id.split("-")[1];
				PLObject.v_TPID = TPID;
				PLObject.v_PGStage = InStage;
				PLObject.v_Type = InType;
				InTPID = TPID;
				if (InType=="CUR")  {
					InTPID = ""
					PLObject.v_PLID=TPID;
				}
				InitGroupHtml(TPID,InStage,InType);
				InitStageInfo(InStage,InTPID);
				
			}
		}
	});
}

function InitGroupHtml (TPID,InStage,InType) {
	$m({
		ClassName:"DHCDoc.THPY.BS.Apply",
		MethodName:"BuildGroupShow",
		TPID:TPID,
		InStage:InStage,
		InType:InType,
		IsView:1
	}, function(result){
		_$dom = $(result);
		$("#i-center").empty();
		$("#i-center").append(_$dom);
		InitUI();
		InitPara(TPID,InStage,InType)
		InitGrid(TPID,InStage,InType);
	});

}

function InitGrid (TPID,InStage,InType) {
	if (PLObject.v_Groups ==0 ) {
		return false;
	}
	
	for (var i=1; i<= PLObject.v_Groups; i++) {
		var id = "GroupGrid-"+i;
		DrawGrid(id,TPID,InStage,i,InType);
		//InitGroupEvent(id,i);
	}
	
	
}
		
function InitPara (TPID,InStage,InType) {
	var result = $cm({
		ClassName:"DHCDoc.THPY.COM.Func",
		MethodName:"GetTPLStageGroups",
		TPID:TPID,
		InStage:InStage,
		InType:InType
	},false);
	PLObject.v_Groups = result;
}

function InitUI () {
	InitDateFlatpickr();
	$(".m-checkbox").checkbox();
	$(".m-button").linkbutton();
	$(".m-panel").panel();
}
function InitDateFlatpickr() {
	var dateFormate="Y-m-d"
	$(".m-plandate").flatpickr({
    	//enableTime: true,
		mode: "multiple",
    	//enableSeconds:true,
    	dateFormat: dateFormate,
    	time_24hr: true,
		conjunction: ",",
    	onOpen:function(pa1,ap2){
	    	
	    }
    })
}


function InitStageInfo(InStage,InTPID,InPatientID,PLID) {
	InStage = InStage||"",
	InTPID = InTPID||"",
	InPatientID=InPatientID||ServerObj.PatientID,
	PLID=PLID||PLObject.v_PLID;
	
	var ConfigStr = $cm({
		ClassName:"DHCDoc.THPY.COM.Func",
		MethodName:"GetClassPropertyList",
		Name:"DHCDoc.THPY.Model.StageInfo",
		ClsFlag:0,
		dataType:"text"
	},false);
	
	var ConfigAry = ConfigStr.split("^")
	if (InPatientID!="") {
		$cm({
			ClassName:"DHCDoc.THPY.Model.StageInfo",
			MethodName:"GetInfo",
			InStage:InStage,
			InPatientID: InPatientID,
			PLID:PLID,
			InTPID:InTPID
		},function(MObj){
			console.log(MObj)
			SetMObj(MObj,ConfigAry);
			PLObject.v_C_StageS = MObj.StageS;
			PLObject.v_C_TPID = MObj.TPID;
			$("#tpname").val(MObj.PlanName);
			$("#PLID").val(MObj.PLID);
			$("#planNote").val(MObj.PlanNote);
			$("#stageEffect").val(MObj.Effect);
			$("#startDate").datebox("setValue", MObj.StartDate);
			$("#endDate").datebox("setValue", MObj.EndDate);
			$("#BodyHeight").val(MObj.Hieht);
			$("#BodyWeight").val(MObj.Weight);
			$("#BMI").val(MObj.BMI);
			$("#BSA").val(MObj.BSA);
			
		});
	}
	
}


function DrawGrid (id,TPID,InStage,GroupCode,InType) {
	$("#"+id).jqGrid({
			url:'thpy.request.csp?action=GetTHPYList',
			datatype: "json",
			postData:{TPID:TPID,InStage:InStage,GroupCode:GroupCode,InType:InType},
			editurl:'clientArray',
			//autowidth:true,
			//autoheight:true,
			height:240,
			shrinkToFit: false,
			border:false,
			mtype:'POST',
			emptyrecords:'û������',
			viewrecords:true,
			loadtext:'���ݼ�����...',
			multiselect:true,//��ѡ
			multiboxonly:true,
			rowNum:false,
			//rowList:[10,20,30],
			loadonce:false, //����һ������  ���ط�ҳ
			//pager:'#Order_DataGrid_pagbar',
			//onPaging:uppage,		
			viewrecords: true,
			//sortorder: "desc",
			//caption:"ҽ��¼��",
			rownumbers:false,
			loadui:'enable',//disable����ajaxִ����ʾ��enableĬ�ϣ���ִ��ajax����ʱ����ʾ�� block����Loading��ʾ��������ֹ��������
			loadError:function(xhr,status,error){
				alert("oeorder.oplistcustom.show.js-err:"+status+","+error);
				//xhr��XMLHttpRequest ����status���������ͣ��ַ������ͣ�error��exception����
			},
			//userDataOnFooter:true,
			//userdata: {totalinvoice:240.00, tax:40.00}, //���صĶ�����Ϣ
			colNames:ListConfigObj.colNames,			
			colModel:ListConfigObj.colModel,			
			//footerrow: true,//��ҳ�����һ�У�������ʾͳ����Ϣ					
			jsonReader: {
                    page: "page",
                    total: "total",
                    records: "records",
                    root: "data",
                    repeatitems: false,
                    id: "id"
            },
			prmNames:{
				page:"page",//��ʾ����ҳ��Ĳ�������
				rows:"rows",//��ʾ���������Ĳ�������
				sort:"sidx",//��ʾ��������������Ĳ�������
				order:"sord",//��ʾ���õ�����ʽ�Ĳ�������
				search:"_search",//��ʾ�Ƿ�����������Ĳ�������
				nd:"nd",//��ʾ�Ѿ���������Ĵ����Ĳ�������
				id:"id",//��ʾ���ڱ༭����ģ���з�������ʱ��ʹ�õ�id������
				oper:"oper",//operation�������ƣ�����ʱ��û�õ���
				editoper:"edit",//����editģʽ���ύ����ʱ������������request.getParameter("oper") �õ�edit
				addoper:"add",//����addģʽ���ύ����ʱ������������request.getParameter("oper") �õ�add
				deloper:"del",//����deleteģʽ���ύ����ʱ������������request.getParameter("oper") �õ�del
				subgridid:"id",//��������������ݵ��ӱ�ʱ�����ݵ���������
				npage:null,
				totalrows:"totalrows" //��ʾ���Server�õ��ܹ����������ݵĲ������ƣ��μ�jqGridѡ���е�rowTotal
			},
			
			ondblClickRow:function(rowid,iRow,iCol,e){
				dbClick(id,rowid);
			},
			
			onCellSelect:function(rowid,iCol,cellcontent,e){
				//alert("cellcontent="+cellcontent);
			},
			onClickRow:function(rowIndex, rowData){
				//�Ѿ���beforeSelectRow��ֹ��ѡ�����
			},
			
			onSelectRow:function(rowid,status){	
				
			},
			beforeSelectRow:function(rowid, e){	
				if ($.isNumeric(rowid) == true) {
					PageLogicObj.FocusRowIndex=rowid;
				}else{
					PageLogicObj.FocusRowIndex=0;
				}
				return true;//false ��ֹѡ���в���
			},
			onRightClickRow:function(rowid,iRow,iCol,e){
				
			},
			formatCell: function (rowid, cellname, value, iRow, iCol){         
			},
			gridComplete:function(){
				
			},
			loadComplete:function(){
				//Add_Order_row(id);
			}
							
	});
}
var OrderPriorChange=OrderMasterChangeHandler=OrderSeqNokeydownhandler =xItem_lookuphandler=OrderDoseQtykeydownhandler =OrderDoseQtykeyuphandler =OrderDoseQtychangehandler =OrdDoseQtyFocusHandler =OrderDoseUOMchangehandler =PHCINDesc_lookuphandler =InstrChangeHandler =InstrFocusHandler =PHCFRDesc_lookuphandler =FrequencyChangeHandler =FrequencyFocusHandler =PHCDUDesc_lookuphandler =DurationChangeHandler =DurationFocusHandler =OrderFirstDayTimeskeypresshandler = OrderFirstDayTimeschangehandler=OrderFirstDayTimesFocusHandler=OrderPricechangehandler =OrderPackQtykeydownhandler =OrderPackQtychangehandler =OrderPackUOMchangehandler =OrderSkinTestChangehandler =OrderActionchangehandler =OrderPriorRemarkschangehandler =OrderRecDepchangehandler =OrderLabSpecchangehandler=OrderStagechangehandler =InitDatePicker =OrderDate_changehandler =OEORISttDatchangehandler =OrderBillTypechangehandler =keypressisnumhandler =OrderSpeedFlowRate_changehandler =OrderFlowRateUnitchangehandler =OrderNeedPIVAFlagChangehandler =OrderLocalInfusionQty_changehandler =ExceedReasonChange =OrderDIACatchangehandler =OrderMaterialBarcode_Keypresshandler =OrderMaterialBarcode_changehandler =OrdCateGoryChange =OrderOperationchangehandler =OrderInsurchangehandler =OrderEndDate_changehandler =OrderBodyPartchangehandler=AntUseReasonchangehandler=OrderSelfOMFlagChangehandler =OrderMKLightShow=CellDataPropertyChange 
=function () {}


function SetMObj (MObj, ConfigAry) {
	for (var i=0; i<ConfigAry.length; i++) {
		if (!MObj[ConfigAry[i]]) {
			MObj[ConfigAry[i]] = ""
		}
		
	}
	return MObj;
}

