/**
 * nurse.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
PLObject = {
	v_Type: "",
	v_Target: "",	//��ǰ���ڵ�
	v_TotalStage:"", //��������
	v_Groups:0,		//����������
	v_C_TPID: "",	//��ǰ���Ƶ�ģ��ID
	v_Stage:"",		//��ѡ���ڴ���
	v_NextDay:"",	//�´λ�������
	
	v_C_StageS: "",	//��ǰ���Ƶ��ѱ���Ľ׶δ�
	
	v_TPID:"",		//ģ��ID
	v_TSID: "",		//ģ������ID
	v_PLID: "",		//���Ƶ�ID
	v_PSID: "",		//��������ID
	v_PDID: "",		//��ѡ���ڷ���ID
	v_NodeText: "",	//��ѡ�����ı�����
	v_SelectDate: "",	//��ѡ����
	
	o_NAV:[],
	o_MObj: ""
}

$(function() {
	Init();
	InitEvent();
	PageHandle();
})

function Init(){
	InitSearchBox();
	LoadBar(ServerObj.EpisodeID);
	//InitTree("user-tree","USER")
	//InitTree("dep-tree","DEP")
	//InitTree("hosp-tree","HOSP")
	if (ServerObj.PLID!="") {
		
	}
	InitTree("history-tree","HIS")
	InitTree("cur-tree","CUR")
	InitCombox()
	//InitGroupHtml();
	//InitGrid();
	
}

function InitEvent () {
	if (websys_showModal('options')) {
		PCallBack = websys_showModal('options').CallBackFunc;
	} else {
		PCallBack = function(){}	
	}
	
	//$("#up").click(Add_Order_row)
	//$("#Del_btn").click(Delete_Order_row);
	$("#BLDetail").click(BLDetail_Handler)
	$("#OtherHosp").click(OtherHosp_Handler)
	$("#Calculate").click(Calculate_Handler)
	$("#Save").click(Save_Handler)
	$("#Stop").click(Stop_Handler)
	$("#Cancel").click(Cancel_Handler)
	$("#Submit").click(Submit_Handler)
	$("#Send").click(Send_Handler)
	$("#Find").click(Find_Handler)
	$("#Formula").click(Formula_Handler)
	
	$("#Refuse").click(Refuse_Handler)
	$("#Agree").click(Agree_Handler)
	//
	$("#Exam").click(Exam_Handler)
	$("#Lab").click(Lab_Handler)
	$("#GMisOK").click(GMisOK_Handler)
	$("#AgreeForm").click(AgreeForm_Handler)
	$("#GMis").click(GMis_Handler)
	
	$("#MC").click(MC_Handler)
	$("#NUR").click(NUR_Handler)
	$("#AES").click(AES_Handler)
	$("#BL").click(BL_Handler)
	
	$("#CurOrder").click(CurOrder_Handler)
	$("#HisOrder").click(HisOrder_Handler)
	
	$("#ApplyList").click(ApplyList_Handler)
	
	//$("#AdjPlanDate").click(AdjPlanDate_Handler)
	$("#VS-SC").keyup(SC_UP_Handler);
	$("#FormulaRef").click(FormulaRef_Handler)
	$("#AdjDetail").click(AdjDetail_Handler)
	$("#OkPlan").click(OkPlan_Handler)
	//��ʷ��������
	$("#SearchPlan").click(SearchPlan_Handler)
	$("#s-content").bind('keypress',function(event){
    	if(event.keyCode == "13") {
	    	SearchPlan_Handler();
	    }
            
    });
    //����ģ������
    $("#SearchDep").click(SearchDep_Handler)
    $("#s-content-dep").bind('keypress',function(event){
    	if(event.keyCode == "13") {
	    	SearchDep_Handler();
	    }
            
    });
	$("#Gotop").click(Gotop_Handler)
    $("#s-content-depzy").checkbox({
		onChecked:function () {
			SearchHosp_Handler();
		},onUnchecked:function () {
			SearchHosp_Handler();
		}  
	})
	$("#CurCollapse").click(function () {
		$('#i-layout').layout('collapse','west'); 
	})
	$(window).resize(Resize_Handler)
	
	
}

function PageHandle () {
	$("input").attr("disabled","disabled")
	$("textarea").attr("disabled","disabled")	
	//setTimeout(function() {
		$(".searchbox-prompt").removeAttr("disabled")	
		$("#s-content").removeAttr("disabled")	
	//},100)

}

function doScroll() {
	$("#main-center,#l-hosp,#l-cur,#l-dep,#l-his").niceScroll({
		cursorborder:"",
		cursorcolor:"#40A2DE",
		boxzoom:false
	});
}
function DoNavBar () {
	$("#nav1").click(function(){
		//var tag = $(this).attr("data-taget");
		//var top = $("#"+tag).offset().top;
		//if (top<0) top= PLObject.v_TV;
		var top = PLObject.v_TV;
		$("#main-center").animate({scrollTop:top},200);
		return false;
	})
}

function CreateNavBar(TSID,InType) {
	var result = $cm({
		ClassName:"DHCDoc.Chemo.BS.Ext.NavBar",
		MethodName:"CreateNavBar",
		TSID:TSID,
		InType:InType,
		dataType:"text"
	},false);
	_$dom = $(result);
	$("#anchorList").empty();
	$("#anchorList").append(_$dom);
	
	$("#anchorList>li>a").mouseover(function(){
		$(this).animate({fontSize:"16px"},300);
		$(this).addClass("anchor-cur");
	});
	$("#anchorList>li>a").mouseout(function(){
		$(this).animate({fontSize:"14px"},300);
		$(this).removeClass("anchor-cur");
		
	});
	
	$("#anchorList>li>a").on('click', function(e){
		var tag = $(this).attr("data-taget");
		var top = PLObject["o_NAV"][tag]
		$("#main-center").animate({scrollTop:top},200);
		ChangeNavStyle(tag);
		return false;
	})
	Gotop_Handler();
	setTimeout(function () {
		$("#anchorList>li>a").each(function (i,obj) {
			var target=$(obj).attr("data-taget");
			if (target) {
				PLObject["o_NAV"][target]=$("#"+target).offset().top-90;
			}
			
		})
		//debug(PLObject["o_NAV"]);
	},100)
	
}

function ChangeNavStyle(cid) {
	for (var key in PLObject["o_NAV"]) {
		if (key == cid) {
			$("#"+key).css({"color":"red"})
		} else {
			$("#"+key).css({"color":"#000"})
		}
	}
}

function InitGroupEvent(id) {
	return false;
	$("#Add_btn_"+code).click(function(){
		Add_Order_row(id)
		Add_ChgReason(id, code,"ADD")
	})
	$("#Del_btn_"+code).click(function(){
		Delete_Order_row(id,code)
		
	})
	$("#Adj_btn_"+code).click(function(){
		Adj_Order_row(id,code)
		
	})
	$("#Link_btn_"+code).click(function(){
		var btnId = "Link_btn_"+code
		Link_Order_row(btnId,id,code)
		
	})
	$("#Up_btn_"+code).click(function(){
		SortRowClick(id,"up")
		
	})
	$("#Down_btn_"+code).click(function(){
		SortRowClick(id,"down")
		
	})
}

function SortRowClick(id, type){
	return false;
    var SelIds=$('#'+id).jqGrid("getGridParam", "selarrrow"); 
    if (SelIds == null || SelIds.length == 0) {
        if (PageLogicObj.FocusRowIndex > 0) {
            if ($("#jqg_"+id+"_" + PageLogicObj.FocusRowIndex).prop("checked") != true) {
                console.log(PageLogicObj.FocusRowIndex)
                $("#"+id).setSelection(PageLogicObj.FocusRowIndex, true);
            }
        }
        SelIds = $('#'+id).jqGrid("getGridParam", "selarrrow");
    }
    SelIds=SelIds.slice(0);
    if (SelIds.length==0){
		return false;   
	}
	SelIds.sort(function(a, b){ return a - b; });	//����
	debug(SelIds,"SelIds")
	var MinRowid=SelIds[0];
	var MaxRowid=SelIds[SelIds.length-1];
	var rowids = $('#'+id).getDataIDs().slice(0);	//�õ����е�����
	///�����к�����˵���ɾ��
	GetUnSaveRows(rowids,id);
	debug(rowids,"rowids")
	
	var EnableSort=true;
	var CheckStart=0;
	for (var i = 0; i<rowids.length; i++){
		var LoopIndex=$.inArray(rowids[i],SelIds);
		if (LoopIndex!=-1){
			CheckStart=1;
		}
		if ((CheckStart==1)&&(LoopIndex==-1)&&(SelIds[SelIds.length-1]>rowids[i])){
			EnableSort=false;
			break;
		}
	}
	if (EnableSort==false){
		$.messager.alert("����","��ѡ�����ڵĿ�����ƶ�!","warning");
		return false;
	}
	
	
	var RecentlyRowid="";
	if (type=="up"){
		//���ҵ�ѡ���ҽ���������һ��ҽ����id
		for (var i = rowids.length-1; i >=0; i--) {
			if (rowids[i]<SelIds[0]){
				RecentlyRowid=rowids[i];
				break;
			}
		}
	}else{
		for (var i = 0; i <rowids.length; i++) {
			if (rowids[i]>SelIds[SelIds.length-1]){
				RecentlyRowid=rowids[i];
				break;
			}
		}
	}
	if (RecentlyRowid==""){return;}
	
	var RecentlyOrderMasterSeqNo=GetCellData(id,RecentlyRowid, "OrderMasterSeqNo");
	var RecentlyOrderSeqNo=GetCellData(id,RecentlyRowid, "id");
	var RecentlyLinkRowidList = ""
	if (RecentlyOrderMasterSeqNo!="") {	//����ҽ��
		RecentlyLinkRowidList=GetSeqNolist(id,RecentlyRowid);
	}
	debug(RecentlyRowid,"RecentlyRowid")
	debug(RecentlyLinkRowidList,"RecentlyLinkRowidList")
	//�ҵ���Ҫ������������
	var NeedMoveRowids = new Array();
	
	for (var i = 0; i < rowids.length; i++) {
        var OrderMasterSeqNo = GetCellData(rowids[i], "OrderMasterSeqNo");
        var OrderSeqNo = GetCellData(rowids[i], "id");
        var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
        
        if (type=="down") {
	        if (rowids[i]<=MaxRowid) {
		    	continue;   
		    	var Index=$.inArray(rowids[i],RecentlyLinkRowidList);
		        if (Index<0) {
			        continue;
			    }
	        }
	        if (rowids[i]>RecentlyRowid) {
		        var Index=$.inArray(rowids[i],RecentlyLinkRowidList);
		        if (Index<0) {
			        continue;
			    }
		    }
	    } else {
		    if (rowids[i]>=MinRowid) {
		    	continue;   
		    	var Index=$.inArray(rowids[i],RecentlyLinkRowidList);
		        if (Index<0) {
			        continue;
			    }
	        }
	        if (rowids[i]<RecentlyRowid) {
		        var Index=$.inArray(rowids[i],RecentlyLinkRowidList);
		        if (Index<0) {
			        continue;
			    }
		    }
		}
		
    	NeedMoveRowids.push(rowids[i]);
    }
    if (NeedMoveRowids.length==0){return;}
    ///����������Ҫ���ĵĶ���
    var MoveList = new Array();
    MoveList=NeedMoveRowids.concat(SelIds);
    debug(NeedMoveRowids,"NeedMoveRowids")
    debug(MoveList,"MoveList")
    var DataArry=new Array();
     
	for (var i=0;i < MoveList.length;i++){
		var rowid=MoveList[i];
		EndEditRow(id,rowid);
		var curRowData = $("#"+id).getRowData(rowid);
		debug(curRowData,"curRowData")
		debug(i,"i")
		debug(NeedMoveRowids.length-1,"NeedMoveRowids.length-1")
		var OrderSeqNo = curRowData["id"];
		if (type=="up"){
			//ǰ��������Ҫ�����ƶ�����
			if (i<=(NeedMoveRowids.length-1)){
				var cid = parseInt(curRowData["id"])+parseInt(SelIds.length);
			}else{
				var cid = curRowData["id"]=parseInt(curRowData["id"])-(NeedMoveRowids.length);
			}
			curRowData["id"] = cid;
			debug(cid,"cid")
		} else {
			//ǰ��������Ҫ�����ƶ�����
			if (i<=(NeedMoveRowids.length-1)){
				var cid = parseInt(curRowData["id"])-parseInt(SelIds.length);
			}else{
				var cid = curRowData["id"]=parseInt(curRowData["id"])+(NeedMoveRowids.length);
			}
			curRowData["id"] = cid;
			debug(cid,"cid")
		}
		
		DataArry[curRowData["id"]-1]=curRowData;
	}
	debug(DataArry,"DataArry")
	
	///�����ȡ������Ҫ�༭���ж���
	var SortList=MoveList.slice(0);
	SortList.sort(function(a, b){return a - b;});
	debug(SortList,"SortList")
	$.each(SortList,function(i,rowid){
		debug(i,"SortList-i")
		debug(rowid,"SortList-rowid")
        //var NeedChangeData=DataArry[i];
        var NeedChangeData=DataArry[rowid-1];
        SetRowData(id,rowid,NeedChangeData,"");
        EditRowCommon(id,rowid);
        
        if ($("#jqg_"+id+"_" + rowid).prop("checked") == true) {
	         $("#"+id).setSelection(rowid, false);
	    }
        EndEditRow(id, rowid)
	})
	
}

function GetUnSaveRows(rowids,id){
	loop();
	function loop(){
		for (var i = 0; i < rowids.length; i++) {
	        var OrderARCIMRowid = GetCellData(id, rowids[i], "OrderARCIMRowid");
	        if (OrderARCIMRowid == "") {
		    	rowids.splice(i,1);
		    	loop();
		    	break;
		    }
	    }
	}
    return;
}

function Link_Order_row (btnId,id,code) {
	return false;
	var ids = $('#'+id).jqGrid("getGridParam", "selarrrow");
	var BtnText=$("#"+btnId+" .l-btn-text")[0].innerText;
    if (BtnText.indexOf($g('��������')) != -1){
       	if (!ClearSeqNohandler(id)) return false;
        PageLogicObj.IsStartOrdSeqLink=0;
        PageLogicObj.StartMasterOrdSeq="";
        $("#"+btnId+" .l-btn-text")[0].innerText=$g("��ʼ����");
    }else{
       	if (!SetSeqNohandler(id)) {
	        PageLogicObj.IsStartOrdSeqLink="";
	        return false;
	    }
        PageLogicObj.IsStartOrdSeqLink=1;
        $("#"+btnId+" .l-btn-text")[0].innerText=$g("��������");
    }
    
}

function Adj_Order_row (id,code) {
	return false;
	if (!PageLogicObj.FocusRowIndex) {
		return false;	
	}
	var Height=$.trim($("#VS-Height").val());
	var Weight=$.trim($("#VS-Weight").val());
	var BSA=$.trim($("#BSA").val());
	var GFR=$.trim($("#GFR").val());
	var SC=$.trim($("#VS-SC").val());
	var BSAUnitSTD = GetCellData(id,PageLogicObj.FocusRowIndex,"BSAUnitSTD");
	var Formula = GetCellData(id,PageLogicObj.FocusRowIndex,"Formula");
	var PGIId=GetCellData(id,PageLogicObj.FocusRowIndex,"PGIId");
	var ArcimDR=GetCellData(id,PageLogicObj.FocusRowIndex,"OrderARCIMRowid");
	
	var VSData=Height+"^"+Weight+"^"+BSA+"^"+GFR+"^"+SC+"^"+BSAUnitSTD+"^"+Formula;
	if ((PGIId=="")||(ArcimDR=="")) {
		$.messager.alert("��ʾ","������ҩƷ���ȱ����ڽ��е�����","warning")
		return false;
	}
	var isEdit = GetEditStatus(id,PageLogicObj.FocusRowIndex);
	if (isEdit) {
		var URL = "chemo.bs.adjust.csp?VSData="+VSData+"&PGIId="+PGIId+"&ArcimDR="+ArcimDR;
		websys_showModal({
			url:URL,
			closable:true,
			iconCls: 'icon-w-edit',
			title:'��������',
			width:620,height:$(window).height()-100,
			CallBackFunc:function (BSAUnit,FinalDose) {
				SetCellData(id,PageLogicObj.FocusRowIndex,"BSAUnit",BSAUnit)
				SetCellData(id,PageLogicObj.FocusRowIndex,"OrderDoseQty",FinalDose)
			}
		})
	}
	
}
function Add_ChgReason (id, code, Action, ArcimDR) {
	return false;
	var MainDrug_ID = "MainDrug-"+code;
	var MainDrug = $("#"+MainDrug_ID).val();
	var closable = false;
	if (MainDrug == "N") {
		closable = true;
	}
	var TPGID = $("#TPGID-"+code).val();
	var PGID = $("#PGID-"+code).val();
	var PIID = "";
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		ArcimDR = ArcimDR||"";
	var URL = "chemo.bs.chgreason.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&ArcimDR="+ArcimDR+"&PGID="+PGID+"&Action="+Action+"&TPGID="+TPGID;
	
	websys_showModal({
		url:URL,
		closable:closable,
		iconCls: 'icon-w-add',
		title:'����ҩƷ���ԭ��',
		width:400,height:400
		//CallBackFunc:callback
	})
}
		
function InitPara (TSID,InType) {
	var result = $cm({
		ClassName:"DHCDoc.Chemo.COM.Func",
		MethodName:"GetTPLStageGroups",
		TSID:TSID,
		InType:InType
	},false);
	PLObject.v_Groups = result;
}
function InitSearchBox() {
	searchbox("s-content", {
		width: 278,
		searcher: function (text) {
			SearchPlan_Handler()
		}
		//,placeholder: "�����������س���ѯ"
	});
}

function InitCombox () {
	/*PLObject.m_BSAType = $HUI.combobox("#BSAType", {
		url:$URL+"?ClassName=DHCDoc.THPY.COM.Qry&QueryName=QryBSAType&ResultSetType=array",
		valueField:'id',
		value:"Default",
		textField:'text',
		blurValidValue:true
	});*/
	/*
	PLObject.m_AuditLoc = $HUI.combobox("#AuditLoc", {
		url:$URL+"?ClassName=DHCDoc.Chemo.BS.Ext.Audit&QueryName=AuditLoc&ResultSetType=array",
		valueField:'id',
		textField:'text',
		disabled:true,
		value:9,
		blurValidValue:true
	});
	*/
	PLObject.m_AuditLoc = $HUI.combobox("#AuditLoc", {
		url:$URL+"?ClassName=DHCDoc.Chemo.BS.Ext.Audit&QueryName=AuditLoc&InHosp="+session['LOGON.HOSPID']+"&InLoc="+session['LOGON.CTLOCID']+"&ResultSetType=array",
		valueField:'id',
		textField:'text',
		//value:9,
		disabled:true,
		blurValidValue:true,
		onLoadSuccess:function(data){
			//console.log(data)
			for (var i=0;i<data.length;i++){
				if (data[0]["default"]==1) {
					PLObject.m_AuditLoc.setValue(data[0].id);	
					break;
				}
				
			}
		}	
			   
	});
	
	PLObject.m_AuditDoc = $HUI.combobox("#AuditDoc", {
		url:$URL+"?ClassName=DHCDoc.Chemo.BS.Ext.Audit&QueryName=AuditDoc&depid=9&ResultSetType=array",
		valueField:'id',
		//value:"Default",
		disabled:true,
		textField:'text',
		blurValidValue:true
	});
	
	PLObject.m_TreatType = $HUI.combobox("#treatTypeID", {
		url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryTreatType&ResultSetType=array",
		valueField:'id',
		//value:"Default",
		textField:'text',
		disabled:true,
		blurValidValue:true
	});
}

function InitDateBox (PSID) {
	return false;
	var now = new Date();
	var now1 = new Date();
	now1.setTime(now.getTime())	///-(1*24*60*60*1000));
	var opt = $("#nexday").datebox('options');
	var opt2 = $("#otherDate").datebox('options');
	opt.minDate = opt.formatter(now1); 
	opt2.minDate = opt.formatter(now1); 
	
	/*
	var result = $cm({
		ClassName:"DHCDoc.Chemo.BS.Apply",
		MethodName:"EnableDate",
		PSID:PSID,
		dataType:"text"
	},false);
	
	
	var dateFormate="Y-m-d"
	$("#otherDate").flatpickr({
    	//enableTime: true,
		mode: "multiple",
    	//enableSeconds:true,
    	dateFormat: dateFormate,
    	time_24hr: true,
		conjunction: ",",
    	onOpen:function(pa1,ap2){
	    	
	    },
		enable: result.split(",")
    })
	*/
}

function InitGroupHtml (TPID,InStage,InType,ID,TSID,SelectDate) {
	$m({
		ClassName:"DHCDoc.Chemo.BS.Apply",
		MethodName:"BuildGroupShow",
		TSID:TSID,
		IsView:1,
		SelectDate:SelectDate,
		InType:InType
	}, function(result){
		_$dom = $(result);
		$("#i-center").empty();
		$("#i-center").append(_$dom);
		InitUI(ID);
		InitPara(TSID,InType)
		InitGrid(TSID,InType,SelectDate);
		$(".fill").attr("disabled","disabled");
	});
	/*
	var result = $m({
		ClassName:"DHCDoc.Chemo.BS.Apply",
		MethodName:"BuildGroupShow",
		TSID:TSID,
		IsView:1,
		InType:InType,
		SelectDate:SelectDate
	}, false);
	
	var _$dom = $(result);
	$("#i-center").empty();
	$("#i-center").append(_$dom);
	InitUI(ID);
	InitPara(TSID,InType)
	InitGrid(TSID,InType,SelectDate);
	$(".fill").attr("disabled","disabled");
	*/

}

function InitUI (ID) {
	//
	setInReamrk();
	//
	setTreeNodeSelected(ID)
	//
	InitDateFlatpickr();
	$(".m-checkbox").checkbox();
	$(".m-button").linkbutton();
	$(".m-panel").panel();
}

function setInReamrk() {
	if (PLObject.v_Type == "CUR") {
		$("#InRemark").text("��"+$g("��ǰ")+"��")
	} else if (PLObject.v_Type == "DEP") {
		$("#InRemark").text("��"+$g("����")+"��")
	} else if (PLObject.v_Type == "USER") {
		$("#InRemark").text("��"+$g("�û�")+"��")
	} else if (PLObject.v_Type == "HOSP") {
		$("#InRemark").text("��"+$g("Ժ��")+"��")
	} else if (PLObject.v_Type == "HIS") {
		$("#InRemark").text("��"+$g("��ʷ")+"��")
	} else {
		$("#InRemark").text("")
	}
}

function setTreeNodeSelected(ID) {
	var tmpObj = {
		"dep-tree":"",
		"hosp-tree":"",
		"cur-tree":"",
		"history-tree":""
	}
	for ( key in tmpObj) {
		if(key==ID) continue;
		$("#" + key + " .tree-node-selected").removeClass("tree-node-selected");
	}
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
function GetSearchContent(InType) {
	var mRtn="",
		PDAID="",
		PLID="",
		isZY="0",
		content="",
		SEP = String.fromCharCode(1);
		
	if (InType == "HIS") {
		//content = $.trim($("#s-content").val());
		content = $("#s-content").searchbox("getValue")||""
		if (content!="") {
			mRtn = content + SEP + PDAID + SEP + PLID + SEP + isZY;
		}
	} else if (InType == "DEP") {
		isZY=$("#s-content-depzy").checkbox("getValue")?1:0;
		//content = $.trim($("#s-content-dep").val());
		content = $("#s-content-dep").searchbox("getValue")||""
		mRtn = content + SEP + PDAID + SEP + PLID + SEP + isZY;
	} else if (InType == "HOSP") {
		isZY=$("#s-content-hospzy").checkbox("getValue")?1:0;
		content = $("#s-content-hosp").searchbox("getValue")||""
		//content = $.trim($("#s-content-hosp").val());
		mRtn = content + SEP + PDAID + SEP + PLID + SEP + isZY;
	} else if (InType == "USER") {
		isZY=$("#s-content-userzy").checkbox("getValue")?1:0;
		//content = $.trim($("#s-content-user").val());
		content = $("#s-content-user").searchbox("getValue")||""
		mRtn = content + SEP + PDAID + SEP + PLID + SEP + isZY;
	} else {
		
	}
	return mRtn;
}

function GetSearchContentOld(InType) {
	var mRtn="",
		PDAID="",
		PLID="",
		isZY="0",
		content="",
		SEP = String.fromCharCode(1);
		
	if (InType == "HIS") {
		content = $.trim($("#s-content").val());
		if (content!="") {
			mRtn = content + SEP + PDAID + SEP + PLID + SEP + isZY;
		}
	} else if (InType == "DEP") {
		isZY=$("#s-content-depzy").checkbox("getValue")?1:0;
		content = $.trim($("#s-content-dep").val());
		mRtn = content + SEP + PDAID + SEP + PLID + SEP + isZY;
	} else if (InType == "HOSP") {
		isZY=$("#s-content-hospzy").checkbox("getValue")?1:0;
		content = $.trim($("#s-content-hosp").val());
		mRtn = content + SEP + PDAID + SEP + PLID + SEP + isZY;
	} else {
		
	}
	return mRtn;
}
function InitTree(ID,InType) {	
	//,InUser,InDep,InHosp,InPatientID,InAdm
	ID=ID||"",
	InType=InType||"",
	InUser=session['LOGON.USERID'],
	InDep=session['LOGON.CTLOCID'],
	InHosp=session['LOGON.HOSPID'],
	InAdm=ServerObj.EpisodeID,
	InPatientID=ServerObj.PatientID;
	var 
		InSContent = GetSearchContent(InType),
		PDAID = ServerObj.PDAID,
		PLID = ServerObj.PLID,
		SEP = String.fromCharCode(1);
	var 
		InExt = InSContent + SEP + PDAID + SEP + PLID;
	//������ʼ��
	InitGlobalPara();
	
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
			param.ClassName = "DHCDoc.Chemo.BS.Apply";
			param.MethodName = "GetTreeByType";
			param.ResultSetType = "array";
			param.InType = InType;
			param.InUser = InUser;	
			param.InDep = InDep;
			param.InHosp = InHosp;
			param.InExt = InExt;
			param.InPatientID = ServerObj.PatientID;
			param.InAdm = InAdm;
			param.IsView = 1;
			param.DefualtDay=ServerObj.ChemoDate;
		},
		onSelect: function(node){
			//������ʼ��
			debug(node,"node")
			InitGlobalPara();
			var target = node.target
			var isLeaf = $(this).tree('isLeaf', node.target);
			if (isLeaf) {
				var TSID = node.id.split("-")[0];
				var TPID = TSID.split("||")[0];
				var InStage = node.id.split("-")[1];
				var SelectDate ="",SelectDate3="";
				
				//
				PLObject.v_NodeText = node.text;
				PLObject.v_Stage = InStage;
				PLObject.v_Type = InType;
				
				//
				if (InType=="CUR")  {
					var SP = "^";
					SelectDate = node.Ext.split(SP)[0];
					SelectDate3 = node.Ext.split(SP)[1];
					PLObject.v_SelectDate = SelectDate;
					
					PLObject.v_PLID=TPID;
					PLObject.v_PSID=TSID;
					PLObject.v_PDID=node.id.split("-")[2];
					PLObject.v_Target = node.id;
					//InitDateBox(TSID);
				} else {
					PLObject.v_TSID = TSID;
					PLObject.v_TPID = TPID;
				}
				InitMainDrug(TSID,InType);
				
				InitGroupHtml(TPID,InStage,InType,ID,TSID,SelectDate);
				InitStageInfo(TSID,InType,SelectDate);
				//
				CreateNavBar(TSID,InType)
			}
		},
		onLoadSuccess: function (node, data) {
			/*
			if (InType=="CUR")  { 
				if (data.length > 0) {
					//var n = $(this).tree('find', data[0].id);
					var n = $(this).tree('find', data[0].children[0].id);
					//$(this).tree('select', n.target);
					console.log(PLObject.v_Target);
					if (PLObject.v_Target == "") {
						$(this).tree("select", n.target);
					} else {
						$(this).tree("select", PLObject.v_Target);
					}
					
				}
			}*/
			
			//debug(data,"data")
			if ((InType=="CUR")||(ServerObj.ComPLID==1))  { 
				if (data.length > 0) {
					var isCheck=false,idCheck=""
					for (var i=0; i<data.length; i++) {
						if (isCheck) {
							break;
						}
						var stageOBJ = data[i].children;
						for (var j=0; j<stageOBJ.length; j++) {
							if (isCheck) {
								break;
							}
							var nodeOBJ = stageOBJ[j].children;
							for (var k=0; k <nodeOBJ.length; k++) {
								var cNode = nodeOBJ[k];
								isCheck = cNode.checked;
								if (isCheck) {
									idCheck = cNode.id;
									break;
								}
							}
							
						}
					}
					if (idCheck=="") {
						idCheck = data[0].children[0].children[0].id;
					}
					var n = $(this).tree('find', idCheck);
					var selected = $(this).tree('getChecked')
					if (PLObject.v_Target == "") {
						$(this).tree("select", n.target);
					} else {
						var selectNode = $(this).tree('find', PLObject.v_Target);
						$(this).tree('select', selectNode.target);
						//$(this).tree("select", PLObject.v_Target);
					}
					
				}
			}
			
			
		}

	});
}

function InitMainDrug(TSID,InType) {
	var PSID = PLObject.v_PSID||"";
	if (PSID == "") {
		return;
	}
	$cm({
			ClassName: "DHCDoc.Chemo.BS.Apply",
			MethodName: "GetMainDrug",
			PSID: PSID,
			InType:InType,
			dataType:"text"
		},function(result){
			_$dom = $(result);
			$("#MainDrug").empty();
			$("#MainDrug").append(_$dom);
	});
}

function InitGlobalPara () {
	PLObject.v_Groups = 0;
	//PLObject.v_Target = "";
	PLObject.v_TotalStage = "";
	PLObject.v_NextDay = "";
	PLObject.v_Stage = "";
	PLObject.v_Type = "";
	PLObject.v_PLID = "";
	PLObject.v_PSID = "";
	PLObject.v_TSID = "";
	PLObject.v_TPID = "";
	PLObject.v_PDID = "";
	PLObject.v_NodeText = "";
	PLObject.v_SelectDate = "";
}

function InitGrid (TSID,InType,SelectDate) {
	if (PLObject.v_Groups ==0 ) {
		return false;
	}
	var id = "GroupGrid";
	DrawGrid(id,TSID,InType,SelectDate);
	InitGroupEvent(id);
	
}


function DrawGrid (id,TSID,InType,SelectDate) {
	//debug(GroupCode,"DrawGrid")
	
	var SessionStr = GetSessionStr();
	var num = $cm({
		ClassName:"DHCDoc.Chemo.BS.Apply",
		MethodName:"GetGridNum",
		TSID:TSID,
		InType:InType,
		SelectDate:SelectDate,
		PatientID:ServerObj.PatientID,
		EpisodeID:ServerObj.EpisodeID,
		SessionStr:SessionStr,
		dataType:"text"
	},false);
	var GridHeight = 300;
	if (num!=0) {
		GridHeight = num*40+50;
	}
	
	
	
	$("#"+id).jqGrid({
			url:'chemo.request.csp?action=GetChemoList',
			datatype: "json",
			postData:{TSID:TSID,InType:InType,SelectDate:SelectDate},
			editurl:'clientArray',
			//autowidth:true,
			autoheight:true,
			shrinkToFit: false,
			border:false,
			height:GridHeight,	//200,
			autoScroll: false,
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
				//dbClick(id,rowid);
			},
			
			onCellSelect:function(rowid,iCol,cellcontent,e){
				//alert("cellcontent="+cellcontent);
			},
			onClickRow:function(rowIndex, rowData){
				//�Ѿ���beforeSelectRow��ֹ��ѡ�����
			},
			
			onSelectRow:function(rowid,status){	
				//SelectContrl(id,rowid,status,GroupCode)
			},
			beforeSelectRow:function(rowid, e){	
				if ($.isNumeric(rowid) == true) {
					PageLogicObj.FocusRowIndex=rowid;
				}else{
					PageLogicObj.FocusRowIndex=0;
				}
				//$(this).jqGrid('resetSelection');
				return true;//false ��ֹѡ���в���
			},
			onRightClickRow:function(rowid,iRow,iCol,e){
				
			},
			formatCell: function (rowid, cellname, value, iRow, iCol){         
			},
			gridComplete:function(){
				/*$m({
							ClassName: "DHCDoc.Chemo.COM.Func2",
							MethodName: "IsMainDrugGroup",
							PSID: TSID,
							GroupCode: GroupCode,
							InType: InType
						},function(result){
							//debug(result)
							if(result==0){
								$("#"+id).setGridParam().hideCol("BSAUnit");
							}
					});*/
				//$("#"+id).setGridParam().hideCol("OrderDoseQty");
				//$(this).jqGrid('setFrozenColumns');//���ö�������Ч
			},
			loadComplete:function(){
				//Add_Order_row(id);
			}
							
	});
	
}
var OrderMasterChangeHandler=OrderSeqNokeydownhandler =xItem_lookuphandler=OrderDoseQtykeydownhandler =OrderDoseQtychangehandler =OrdDoseQtyFocusHandler =PHCINDesc_lookuphandler =InstrChangeHandler =InstrFocusHandler =PHCFRDesc_lookuphandler =FrequencyChangeHandler =FrequencyFocusHandler =PHCDUDesc_lookuphandler =DurationChangeHandler =DurationFocusHandler =OrderFirstDayTimeskeypresshandler = OrderFirstDayTimeschangehandler=OrderFirstDayTimesFocusHandler=OrderPricechangehandler =OrderPackQtykeydownhandler =OrderPackQtychangehandler =OrderSkinTestChangehandler  =OrderPriorRemarkschangehandler =OrderLabSpecchangehandler =InitDatePicker =OrderDate_changehandler =OEORISttDatchangehandler =OrderBillTypechangehandler =keypressisnumhandler =OrderSpeedFlowRate_changehandler =OrderNeedPIVAFlagChangehandler =OrderLocalInfusionQty_changehandler =ExceedReasonChange =OrderDIACatchangehandler =OrderMaterialBarcode_Keypresshandler =OrderMaterialBarcode_changehandler =OrdCateGoryChange =OrderOperationchangehandler =OrderInsurchangehandler =OrderEndDate_changehandler =OrderBodyPartchangehandler=AntUseReasonchangehandler=OrderSelfOMFlagChangehandler =OrderMKLightShow=CellDataPropertyChange 
= OrderPackQtyFocusHandler =OrderDocchangehandler =OrderVirtualtLongClickhandler
=function () {}


//���㹫ʽ
function Formulachangehandler (e) {
	var rowid = "";
	var obj = websys_getSrcElement(e);
	var parObj = $(obj).closest('table');
	if (parObj.length>0) {
		var id = parObj.attr("id");
		if (obj.id.indexOf("_") > 0) {
			rowid = obj.id.split("_")[0];
		}
		SetCellData(id, rowid, "Formula", obj.value);
	}
}

//���ٵ�λ
function OrderFlowRateUnitchangehandler (e) {
	var rowid = "";
	var obj = websys_getSrcElement(e);
	var parObj = $(obj).closest('table');
	if (parObj.length>0) {
		var id = parObj.attr("id");
		if (obj.id.indexOf("_") > 0) {
			rowid = obj.id.split("_")[0];
		}
		SetCellData(id, rowid, "OrderFlowRateUnitRowId", obj.value);
	}
}

//ҽ���׶�
function OrderStagechangehandler (e) {
	var rowid = "";
	var obj = websys_getSrcElement(e);
	var parObj = $(obj).closest('table');
	if (parObj.length>0) {
		var id = parObj.attr("id");
		if (obj.id.indexOf("_") > 0) {
			rowid = obj.id.split("_")[0];
		}
		SetCellData(id, rowid, "OrderStageCode", obj.value);
	}
	
}

//Ƥ�Ա�ע
function OrderActionchangehandler (e) {
	var rowid = "";
	var obj = websys_getSrcElement(e);
	var parObj = $(obj).closest('table');
	if (parObj.length>0) {
		var id = parObj.attr("id");
		if (obj.id.indexOf("_") > 0) {
			rowid = obj.id.split("_")[0];
		}
		SetCellData(id, rowid, "OrderAction", obj.value);
        SetCellData(id, rowid, "OrderActionRowid", obj.value);
	}
	
}
//���տ���
function OrderRecDepchangehandler (e) {
	var rowid = "";
	var obj = websys_getSrcElement(e);
	var parObj = $(obj).closest('table');
	if (parObj.length>0) {
		var id = parObj.attr("id");
		if (obj.id.indexOf("_") > 0) {
			rowid = obj.id.split("_")[0];
		}
		SetCellData(id, rowid, "OrderRecDepRowid", obj.value);
		SetCellData(id, rowid, "OrderRecDep", obj.value);
	}
    
}

//������λ
function OrderDoseUOMchangehandler (e) {
	var rowid = "";
    var obj = websys_getSrcElement(e);
	var parObj = $(obj).closest('table');
	if (parObj.length>0) {
		var id = parObj.attr("id")
		if (obj.id.indexOf("_") > 0) {
			rowid = obj.id.split("_")[0];
		}
		
		SetCellData(id,rowid, "OrderDoseUOMRowid", obj.value);
		SetCellData(id,rowid, "OrderDoseUOM", obj.value);
	}
	
}

//������λ
function OrderPackUOMchangehandler(e) {
    var rowid = "";
    var obj = websys_getSrcElement(e);
	var parObj = $(obj).closest('table');
	if (parObj.length>0) {
		var id = parObj.attr("id");
		if (obj.id.indexOf("_") > 0) {
			rowid = obj.id.split("_")[0];
		}
		SetCellData(id, rowid, "OrderPackUOMRowid", obj.value);
		SetCellData(id, rowid, "OrderPackUOM", obj.value);
	}
    
}

//ҽ������
function OrderPriorChange(e) {
    var rowid = "";
    var obj = websys_getSrcElement(e);
	var parObj = $(obj).closest('table');
	if (parObj.length>0) {
		var id = parObj.attr("id") 
		if (obj.id.indexOf("_") > 0) {
			rowid = obj.id.split("_")[0];
		}
		SetCellData(id, rowid, "OrderPriorRowid", obj.value);
		SetCellData(id, rowid, "OrderPrior", obj.value);
	}
   
}


function InitRowLookUp(id,rowid){
	InitOrderNameLookup(id,rowid);
	InitOrderInstrLookup(id,rowid);
	InitOrderFreqLookup(id,rowid);
	InitOrderDurLookup(id,rowid);
	//Combox_DoseUOM(id,rowid);
}
function InitOrderDurLookup(id,rowid){
	$("#"+id + " input[name='OrderDur']").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'CTPCPDesc',
        columns:[[  
           {field:'CTPCPDesc',title:'�Ƴ�',width:130,sortable:true},
           {field:'CTPCPCode',title:'����',width:130,sortable:true}
        ]],
        width:80,
        pagination:true,
        panelWidth:300,
        panelHeight:300,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.Chemo.COM.Qry',QueryName: 'LookUpDuration'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{desc:desc});
	    }
		,onSelect:function(ind,item){
		    /* var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			}); */
			DurationLookUpSelect(id,rowid,item);
		}
		
    });
}


function InitOrderFreqLookup(id,rowid){
	$("#"+id + " input[name='OrderFreq']").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'Desc',
        columns:[[  
           {field:'Desc',title:'Ƶ������',width:130,sortable:true},
           {field:'Code',title:'Ƶ�α���',width:130,sortable:true}
        ]],
        pagination:true,
        panelWidth:300,
        panelHeight:300,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.Chemo.COM.Qry',QueryName: 'LookUpFrequency'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        param = $.extend(param,{desc:desc});
	    },onSelect:function(ind,item){
		    /* var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			}); */
			FrequencyLookUpSelect(id,rowid,item);
		}
    });
}

function InitOrderInstrLookup(id,rowid){
	$("#"+id + " input[name='OrderInstr']").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'Desc',
        columns:[[  
           {field:'Desc',title:'�÷�����',width:130,sortable:true},
           {field:'Code',title:'�÷�����',width:130,sortable:true}
        ]],
        pagination:true,
        panelWidth:300,
        panelHeight:300,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.Chemo.COM.Qry',QueryName: 'LookUpInstr'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        param = $.extend(param,{instrdesc:desc});
	    },onSelect:function(ind,item){
		    /* var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			}); */
			InstrLookUpSelect(id,rowid,item);
		}
    });
}

function InitOrderNameLookup(id,rowid){ 
	$("#"+id + " input[name='OrderName']").lookup({
		//name="OrderName"
        url:$URL,
        mode:'remote',
        method:"Get",
       idField:'ArcimDR',
        textField:'ArcimDesc',
        columns:[[  
            {field:'ArcimDesc',title:'����',width:320,sortable:true},
		   {field:'stock',title:'���',width:80,sortable:true},
		   {field:'factor',title:'����',width:300,sortable:true},
            {field:'ArcimDR',title:'ID',width:70,sortable:true}
        ]],
        pagination:true,
        rownumbers:true,
        panelWidth:500,
        panelHeight:330,
        isCombo:true,
        minQueryLen:2,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.Chemo.COM.Qry',QueryName: 'FindMasterItem'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			var EpisodeID = ServerObj.EpisodeID;
			console.log(EpisodeID)
	        if (desc=="") return false;
			param = $.extend(param,{arcimdesc:desc,EpisodeID:EpisodeID});
	    },onSelect:function(ind,item){
			var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			});
			OrderItemLookupSelect(id,rowid,ItemArr);
			
			
		
		}
    });
}


function OrderItemLookupSelect(id,rowid,ItemArr) {
	//Combox_DoseUOM(id,rowid,ItemArr[1])
	SetCellData(id,rowid,"OrderARCIMRowid",ItemArr[1])
	SetDosageUom(id,PageLogicObj.FocusRowIndex,ItemArr[1]);
	SetQtyUom(id,PageLogicObj.FocusRowIndex,ItemArr[1]);
	SetRecLoc(id,PageLogicObj.FocusRowIndex,ItemArr[1]);
}


function DurationLookUpSelect(id,rowid,item) {
    SetCellData(id, rowid, "OrderDur", item["CTPCPDesc"])
	SetCellData(id, rowid, "OrderDurRowid", item["HIDDEN"]);
	//SetCellData(id, rowid, "OrderDurFactor", OrderDurFactor);
		
}

function FrequencyLookUpSelect(id,rowid,item) {
	SetCellData(id, rowid, "OrderFreq", item["Desc"]);
    //SetCellData(id, rowid, "OrderFreqFactor", OrderFreqFactor);
    //SetCellData(id, rowid, "OrderFreqInterval", OrderFreqInterval);
    SetCellData(id, rowid, "OrderFreqRowid", item["HIDDEN2"]);
}

function InstrLookUpSelect(id,rowid,item) {
	SetCellData(id, rowid, "OrderInstr", item["Desc"]);
	SetCellData(id, rowid, "OrderInstrRowid", item["HIDDEN"]);
	//SetFocusCell(id, rowid, "OrderInstr");
						
}

function SetDosageUom (id,rowid,arcim,isEdit) {
	isEdit=isEdit||""
	$m({
		ClassName:"DHCDoc.THPY.COM.Func",
		MethodName:"GetDosageUom",
		Arcim:arcim
	}, function(result){
		if (isEdit=="") {
			SetColumnList(id, rowid, "OrderDoseUOM", result)
			//SetCellData(rowid, "OrderDoseQty", RowDataObj.OrderDoseQty);
			//SetCellData(rowid, "OrderDoseUOM", RowDataObj.OrderDoseUOMRowid);
		} else {
			SetColumnList(id, rowid, "OrderDoseUOM_Edit", result)
		}
	});
}

function SetQtyUom (id,rowid,arcim,isEdit) {
	isEdit=isEdit||""
	$m({
		ClassName:"DHCDoc.THPY.COM.Func",
		MethodName:"GetQtyUom",
		ArcimRowid:arcim
	}, function(result){
		if (isEdit=="") {
			SetColumnList(id, rowid, "OrderPackUOM", result)
		} else {
			SetColumnList(id, rowid, "OrderPackUOM_Edit", result)
		}
	});
}

function SetRecLoc (id,rowid,arcim,isEdit) {
	isEdit=isEdit||""
	$m({
		ClassName:"DHCDoc.THPY.COM.Func",
		MethodName:"GetRecLoc",
		ArcimRowid:arcim
	}, function(result){
		if (isEdit=="") {
			SetColumnList(id, rowid, "OrderRecDep", result)
		} else {
			SetColumnList(id, rowid, "OrderRecDep_Edit", result)
		}
	});
}

function dbClick (id,rowid) {
	var editable = $("#"+ id + " tr[id='"+rowid+"']").attr('editable')
	if (editable == 1) {
		return
	}
	EditRowCommon(id,rowid);	
	var arcim = GetCellData(id,rowid,"OrderARCIMRowid");
	if (arcim!="") {
		SetDosageUom(id,rowid,arcim,1)
		SetQtyUom(id,rowid,arcim,1)
		SetRecLoc(id,rowid,arcim,1)
	}
}

function SelectContrl (id,rowid,status,GroupCode) {
	var btnId = "Link_btn_"+GroupCode
	
	if ($.isNumeric(rowid) == false) { return rowid }
    var stutas = $("#jqg_"+id+"_" + rowid).prop("checked");
    var OrderMasterSeqNo = GetCellData(id,rowid, "OrderMasterSeqNo");
    var rowids = GetAllRowId(id);
    
    if (OrderMasterSeqNo != "") {
	    var OrderMasterFlag = 1;	//Ĭ����ҽ��
	    if (OrderMasterSeqNo.indexOf(".")>=0) {
		    OrderMasterFlag = 0;
		    OrderMasterSeqNo = OrderMasterSeqNo.split(".")[0];
		}
        for (var i = 0; i < rowids.length; i++) {
	        if (rowids[i]==rowid) {
		        continue;
		    }
		    var MasterSeqNo = GetCellData(id, rowids[i], "OrderMasterSeqNo");
		    if (MasterSeqNo=="") {
			    continue;
			}
	        if (OrderMasterFlag==1) {
		        if (MasterSeqNo.indexOf(".")<0) {
				    continue;
				}
		    	MasterSeqNo = MasterSeqNo.split(".")[0];
		    	if (MasterSeqNo == OrderMasterSeqNo) {
					if ($("#jqg_"+id+"_" + rowids[i]).prop("checked") != stutas) {
						$("#"+id).setSelection(rowids[i], false);
					}
	               	if (stutas){
		            	$("#"+btnId+" .l-btn-text")[0].innerText=$g("��������");
		            }else{
			            $("#"+btnId+" .l-btn-text")[0].innerText=$g("��ʼ����");
			        }
		        
			    }
			    
		    } else {
			    //��ҽ��ʱ
			    if (MasterSeqNo.indexOf(".")>=0) {
				    MasterSeqNo = MasterSeqNo.split(".")[0];
				}
		    	
		    	if (MasterSeqNo == OrderMasterSeqNo) {
					if ($("#jqg_"+id+"_" + rowids[i]).prop("checked") != stutas) {
						$("#"+id).setSelection(rowids[i], false);
					}
	               	if (stutas){
		            	$("#"+btnId+" .l-btn-text")[0].innerText=$g("��������");
		            }else{
			            $("#"+btnId+" .l-btn-text")[0].innerText=$g("��ʼ����");
			        }
		        
			    }
			    
			    
			}
        }
			
	} else {
		$("#"+btnId+" .l-btn-text")[0].innerText=$g("��ʼ����");
	}
    
    
    
}

//���ý���Ĭ��ֵ
function InitStageInfo(TSID,InType,SelectDate) {
	var ConfigStr = $cm({
		ClassName:"DHCDoc.Chemo.COM.Func",
		MethodName:"GetClassPropertyList",
		Name:"DHCDoc.Chemo.Model.PlanInfo",
		ClsFlag:0,
		dataType:"text"
	},false);
	
	var ConfigAry = ConfigStr.split("^")
	debug(SelectDate,"SelectDate")
	debug(TSID,"TSID")
	$cm({
		ClassName: "DHCDoc.Chemo.Model.PlanInfo",
		MethodName: "GetInfo",
		TSID: TSID,
		InType: InType,
		SelectDate:SelectDate,
		PatientID: ServerObj.PatientID,
		EpisodeID: ServerObj.EpisodeID,
		PAAdmType: ServerObj.PAAdmType
	},function(MObj){
		console.log(MObj)
		SetMObj(MObj, ConfigAry);
		SetPlanInfo(MObj,InType);
		PLObject.v_C_StageS = MObj.SaveStage;
		PLObject.v_C_TPID = MObj.TPID;

		//$("#startDate").datebox("setValue", MObj.StartDate);
		//$("#endDate").datebox("setValue", MObj.EndDate);
	
		
	});
		
	
}

function SetButton (MObj) {
	if (PLObject.v_Type =="CUR") {
			if (MObj.NeedPL == 0) {
				$("#Save").linkbutton('enable');
				//$("#Send").linkbutton('enable');
				$("#Submit").linkbutton('enable');
				$("#Formula").linkbutton('enable');
				$("#Stop").linkbutton('enable');
				$("#Find").linkbutton('enable');
				$("#GMisOK").linkbutton('disable');
				$("#AdjPlanDate").linkbutton('disable');
				$("#OkPlan").linkbutton('enable');
				$("#AdjDetail").linkbutton('enable');	
			} else {
				$("#Save").linkbutton('enable');
				//$("#Send").linkbutton('enable');
				$("#Submit").linkbutton('enable');
				$("#Formula").linkbutton('enable');
				$("#Stop").linkbutton('enable');
				$("#Find").linkbutton('enable');
				$("#GMisOK").linkbutton('enable');
				$("#AdjPlanDate").linkbutton('enable');
				$("#OkPlan").linkbutton('enable');
				$("#AdjDetail").linkbutton('enable');	
			}
	} else {
		if (PLObject.v_Type =="HIS") {
			$("#Save").linkbutton('disable');
			$("#Formula").linkbutton('disable');
			$("#Find").linkbutton('disable');
			$("#Send").linkbutton('disable');
			$("#Submit").linkbutton('disable');
			$("#Stop").linkbutton('disable');
			$("#GMisOK").linkbutton('disable');
			$("#AdjPlanDate").linkbutton('disable');
			$("#OkPlan").linkbutton('disable');
			$("#ApplyList").linkbutton('disable');
			$("#AdjDetail").linkbutton('enable');	
		} else {
			$("#Save").linkbutton('enable');
			$("#Formula").linkbutton('enable');
			$("#Find").linkbutton('enable');
			$("#Send").linkbutton('disable');
			$("#Submit").linkbutton('disable');
			$("#Stop").linkbutton('disable');
			$("#GMisOK").linkbutton('disable');
			$("#AdjPlanDate").linkbutton('disable');
			$("#OkPlan").linkbutton('disable');	
			$("#AdjDetail").linkbutton('disable');	
		}
		
	}
}

function SetPlanInfo (MObj,InType) {
	//
	$("#PLID").val(MObj.PLID);
	PLObject.v_TotalStage = MObj.PLTotalStage;
	$("#tip-1").text("every 21 days for "+ MObj.PLTotalStage +"  cycles");
	$("#tip-2").text("ÿ21��Ϊһ���ڣ�������ҩ"+MObj.PLTotalStage+"������");
	//
	$("#tip-3").html(MObj.ChemoTitle)	
	//SetButton(MObj)
	var ExamNote="1��Ѫ���棺��ϸ��������1.5��109��ѪС�壺80��109��Ѫ�쵰�ף�90g/L \n"+
			"2��������飺ת��ø<2������ֵ���ޣ���С���˹���>60%��\n"+
			"3���ĵ�ͼ������Ľ��ɡ�\n"+
			"4������ʳ�EF>50%��";
	ExamNote = "";
	
	//������ֵ
	{
		$("#LabExamNote").val(ExamNote)
		$("#Diagnosis").val(MObj.PSDiagnosis)
		$("#admDoc").val(MObj.PDAdmDoc)
		//����������Ϣ
		$("#VS-Height").val(MObj.Height);
		$("#VS-Weight").val(MObj.Weight);
		$("#VS-Temperature").val(MObj.Temperature);
		$("#VS-BloodPressure").val(MObj.Blood);
		$("#VS-Pulse").val(MObj.Pulse);
		$("#VS-Oxygen").val(MObj.Oxygen);
		$("#VS-ECOG").val(MObj.ECOG);
		$("#VS-KQ-Score").val(MObj.KQScore);
		//$("#VS-Data").val(MObj.DataSR);
		$("#VS-SC").val(MObj.SC);
		$("#Age").val(MObj.Age);
		$("#Sex").val(MObj.Sex);
		//$("#VS-Data").text(MObj.DataSR)
		var BSA = CalcBSA(MObj.Height, MObj.Weight);
		var IBW = CalcIBW(MObj.Height, MObj.Weight,MObj.Sex);
		var GFR = CalcGFR(MObj.Age,MObj.Weight,MObj.SC,MObj.Sex)
		if (!isNaN(IBW)) $("#IBW").val(IBW);
		if (!isNaN(BSA)) $("#BSA").val(BSA);
		if (!isNaN(GFR)) $("#GFR").val(GFR);
		
		$("#otherDate").datebox("disable");
	}
	
	if ((InType == "CUR")||(InType == "HIS")) {
		$("#tpname").val(MObj.PLName);
		$("#tpstage").val(MObj.PSStage);
		$("#curPlanDate").val(MObj.PSDate);
		$("#otherDate").datebox("setValue",MObj.PSDate)
		debug(MObj.PSDate,"MObj.PSDate")
		$("#nexday").datebox("setValue",MObj.PSNextDate);
		PLObject.v_NextDay = MObj.PSNextDate;
		$("#day").val("Day"+MObj.PSDay)
		if (MObj.PSGMisOK==1) $("#GMisOK_New").checkbox("check")
		else $("#GMisOK_New").checkbox("uncheck")
		$("#stageEffect").val(MObj.PSEffect)
		$("#tip-1").text("On Day "+MObj.PSDay+" ��every 21 days for "+ MObj.PLTotalStage +"  cycles");
		$("#tip-2").text("��"+MObj.PSDay+"����ҩ��ÿ21��Ϊһ���ڣ�������ҩ"+MObj.PLTotalStage+"������");
		//alert(MObj.PSTreatType)
		PLObject.m_TreatType.setValue(MObj.PSTreatType)
		/*if (MObj.PSTreatType!="") {
			$("#treatTD").find("input[value='"+ MObj.PSTreatType +"']").radio('check');
		}*/
		if (MObj.PSTreatTypeNew!="") {
			$("#treatTD").find("input[value='"+ MObj.PSTreatTypeNew +"']").radio('check');
		}
		if (MObj.PSAgreeForm!="") {
			$("#agreeFormTD").find("input[value='"+ MObj.PSAgreeForm +"']").radio('check');
		}
		if (MObj.PSHasGMis!="") {
			$("#sensitiveTD").find("input[value='"+ MObj.PSHasGMis +"']").radio('check');
		}
		if (MObj.PDOnTime!="") {
			$("#ontimeTD").find("input[value='"+ MObj.PDOnTime +"']").radio('check');
		}
		$("#planNote").val(MObj.PLNote)
		
		/*if (MObj.NeedPL == 1) {
			$("#needPL").checkbox("check")
		} else {
			$("#needPL").checkbox("uncheck")
		}*/
		if (MObj.PLExamNote!="") {
			$("#LabExamNote").val(MObj.PLExamNote)
		}
		$("#CancerStage").val(MObj.PSCancerStage)
		$("#delayReason").val(MObj.PDDelayReason)
		$("#PDID").val(MObj.PDID)
		$("#GMisFill").val(MObj.GMisFill)
		$("#OhterFill").val(MObj.OtherFill)
		$("#PDStatus").val(MObj.PDStatus)
		PLObject.m_AuditDoc.setValue(MObj.PDNeedUser)
		if (MObj.PDNeedLoc!="") {
			PLObject.m_AuditLoc.setValue(MObj.PDNeedLoc)
		}
		//PLObject.m_AuditDoc.enable();
		//PLObject.m_AuditLoc.enable();
		$("#palnTime").val(MObj.PDPlanTime)
		
	} else {
		$("#tpname").val(MObj.TPName);
		$("#tpstage").val(MObj.PSStage);
		PLObject.m_AuditDoc.setValue("")
		PLObject.m_AuditLoc.setValue("")
		PLObject.m_AuditDoc.disable();
		PLObject.m_AuditLoc.disable();
	}
	
}

function SetMObj (MObj, ConfigAry) {
	for (var i=0; i<ConfigAry.length; i++) {
		if (typeof MObj[ConfigAry[i]] == "undefined") {
			MObj[ConfigAry[i]] = ""
		}
		
	}
	return MObj;
}

function checkData (buttonType) {
	buttonType = buttonType||"";
	//console.log(PLObject)
	if (PLObject.v_Groups == 0) {
		$.messager.alert("��ʾ","����ѡ�����ڣ�","warning")
		return false;
	}
	
	if (PLObject.v_Type != "CUR") {
		
		if (PLObject.v_C_TPID != "" ) {
			if (PLObject.v_C_TPID != PLObject.v_TPID ) {
				$.messager.alert("��ʾ","��ͬģ�岻�ܱ��棡","warning")
				return false;
			}
		}
	
		if (PLObject.v_C_StageS!="") {
			if (PLObject.v_C_StageS.indexOf(PLObject.v_Stage) >= 0 ) {
				$.messager.alert("��ʾ","��ģ��׶��Ѿ����棡","warning")
				return false;
			}
		}
	}
	
	var PLName = $.trim($("#tpname").val());
	
	if (PLName=="") {
		$.messager.alert("��ʾ","���Ʒ�������Ϊ�գ�","warning")
		return false;
	}
	
	var auditLoc = PLObject.m_AuditLoc.getValue()||"";
	var auditDoc = PLObject.m_AuditDoc.getValue()||"";
	
	if (PLObject.v_Type == "CUR") {	
		if (auditLoc=="") {
			$.messager.alert("��ʾ","��˿��Ҳ���Ϊ�գ�","warning")
			return false;
		}
		if (auditDoc=="") {
			$.messager.alert("��ʾ","���ҽ������Ϊ�գ�","warning")
			return false;
		}
	}
	var PSHasGMis = $("#sensitiveTD").find("input[type='radio']:checked").val();
	var GMisFill = $.trim($("#GMisFill").val());
	if (PSHasGMis==1) {
		if (GMisFill=="") {
			$.messager.alert("��ʾ","����д����ʷ��¼��","warning",function () {
				$("#GMisFill").focus();	
			})
			
			return false;
		}
	}
	if (buttonType == "Send") {
		
		var PDStatus=$("#PDStatus").val();
		var auditLoc = PLObject.m_AuditLoc.getValue()||"";
		var auditDoc = PLObject.m_AuditDoc.getValue()||"";
		if (PDStatus!="") {
			var cDate = $("#curPlanDate").val();
			var mDate = $("#otherDate").datebox("getValue")||"";
			var result = $cm({
				ClassName:"DHCDoc.Chemo.BS.Ext.Audit",
				MethodName:"IsCurrentDate",
				mDate:mDate,
				cDate:cDate,
				dataType:"text"
			},false);
			
			if (result==1) {
				$.messager.alert("��ʾ","������Ϣ�Ѿ����ͣ�","warning")
				return false;
			}
	
		}
		if (auditLoc=="") {
			$.messager.alert("��ʾ","��˿��Ҳ���Ϊ�գ�","warning")
			return false;
		}
		if (auditDoc=="") {
			$.messager.alert("��ʾ","���ҽ������Ϊ�գ�","warning")
			return false;
		}
		
	}
	var isExit=0,msg=""
	for (var j=1; j<=PLObject.v_Groups; j++) {
		if (isExit==1) {
			break;
		}
		var GroupAry = [],
			GroupInfo = "",
			id = "GroupGrid-"+j,
			PlanDateID = "PlanDate-"+j,
			DescID = "TPGDesc-"+j,
			TPGID = "TPGID-"+j,
			PGID_ID = "PGID-"+j,
			MainDrug_ID = "MainDrug-"+j,
			NoteID = "Note-"+j;
			
		var gridData = GetGirdData(id);
		for (var k=0; k < gridData.length; k++) {
			if (isExit==1) {
				break;
			}
			var ItemAry=[],
				HDItem = "",
				HDID = gridData[k].HDID,
				HospDose = gridData[k].HospDose,
				HDUomDR = 1,	//��Ĭ�ϣ�������չ֮���ڸĶ�
				ItemID=gridData[k].PGIId,
				PGIArcimDR = gridData[k].OrderARCIMRowid||"",
				PGIDosage = gridData[k].OrderDoseQty,
				PGIDosageUomDR = gridData[k].OrderDoseUOMRowid,
				PGIFreqDR = gridData[k].OrderFreqRowid,
				PGIInstruc = gridData[k].OrderInstrRowid,
				PGIDuratDR = gridData[k].OrderDurRowid,
				PGIQty = gridData[k].OrderPackQty,
				PGIUomDR = gridData[k].OrderPackUOMRowid,
				PGILinkItem = gridData[k].OrderMasterSeqNo,
				PGINote = gridData[k].OrderDepProcNote,
				PGIPriorDR = gridData[k].OrderPriorRowid,
				PGISimpleDR = gridData[k].OrderLabSpec,
				PGIRemark = gridData[k].OrderPriorRemarks,
				PGIRecLoc = gridData[k].OrderRecDepRowid,
				PGIStage = gridData[k].OrderStageCode,
				PGIFlowRate = gridData[k].OrderSpeedFlowRate,
				PGIFlowRateDR = gridData[k].OrderFlowRateUnitRowId,
				PGISkinTest = gridData[k].OrderSkinTest,
				PGISkinAction = gridData[k].OrderActionRowid,
				PGITplGroupItem = gridData[k].TplGroupItemId,
				BSAUnit = gridData[k].BSAUnit,
				BSA = $.trim($("#BSA").val()),
				Formula = gridData[k].Formula,
				GFR = $.trim($("#GFR").val());
				
			if (PGIInstruc == "") {
				isExit=1,msg="�÷�����Ϊ�գ�"
				break;
			}
			if (PGIPriorDR == "") {
				isExit=1,msg="ҽ�����Ͳ���Ϊ�գ�"
				break;
			}
			if (PGIDuratDR == "") {
				isExit=1,msg="�Ƴ̲���Ϊ�գ�"
				break;
			}
			if (PGIQty == "") {
				isExit=1,msg="��������Ϊ�գ�"
				break;
			}
			if (PGIUomDR == "") {
				isExit=1,msg="������λ����Ϊ�գ�"
				break;
			}
			
		}
		
	}
	if (isExit==1) {
		$.messager.alert("��ʾ",msg,"warning")
		return false;
	}
	
	
	return true;
}

function GetATAry () {
	var ATAry = [];
	var auditLoc = PLObject.m_AuditLoc.getValue()||"";
	var auditDoc = PLObject.m_AuditDoc.getValue()||"";
	var status = "A";
	var appLoc = session['LOGON.CTLOCID'];
	var appDoc = session['LOGON.USERID'];
	ATAry.push(auditLoc,auditDoc,status,appLoc,appDoc);
	
	return ATAry;
	
}

function GetPDAry () {
	var PDAry = [];
	if (PLObject.v_Type!="CUR") {
		return PDAry;
	}
	var PDID = $.trim($("#PDID").val());
	var PLID = PLObject.v_PLID;
	var PSID = PLObject.v_PSID;
	var PatientDR = ServerObj.PatientID;
	var Adm = ServerObj.EpisodeID;
	var PDDate = $.trim($("#curPlanDate").val());
	var ONTime = $("#ontimeTD").find("input[type='radio']:checked").val();
	var DelayReason = $.trim($("#delayReason").val());
	var ToDate = "";
	var Height = $.trim($("#VS-Height").val());
	var Weight = $.trim($("#VS-Weight").val());
	var Temperature = $.trim($("#VS-Temperature").val());
	var Blood = $.trim($("#VS-BloodPressure").val());
	var Pulse = $.trim($("#VS-Pulse").val());
	var Oxygen = $.trim($("#VS-Oxygen").val());
	var ECOG = $.trim($("#VS-ECOG").val());
	var KQScore = $.trim($("#VS-KQ-Score").val());
	var DataSR = "";	//$.trim($("#VS-Data").val());
	var BSA = $.trim($("#BSA").val());
	var GFR = $.trim($("#GFR").val());
	var SC = $.trim($("#VS-SC").val());
	var GMisFill = $.trim($("#GMisFill").val());
	var PDExamNote = $.trim($("#LabExamNote").val());
	var PDPlanTime = $.trim($("#palnTime").val());
	var UpdateLoc = session['LOGON.CTLOCID'];
	var UpdateDoc = session['LOGON.USERID'];
	var auditLoc = PLObject.m_AuditLoc.getValue()||"";
	var auditDoc = PLObject.m_AuditDoc.getValue()||"";
	
	PDAry.push(PDID,PLID,PSID,PatientDR,Adm,PDDate,ONTime,DelayReason,ToDate,Height,Weight,Temperature,Blood,Pulse,Oxygen,ECOG,KQScore,DataSR,BSA,GFR,SC,GMisFill,PDExamNote,PDPlanTime,UpdateLoc,UpdateDoc,auditLoc,auditDoc);
	
	
	
	return PDAry;
}

function GetPLAry () {
	var PLAry = [];
	var PLID = $("#PLID").val();
	var PLName = $.trim($("#tpname").val());
	var PLPatientDR=ServerObj.PatientID;
	if (PLObject.v_Type!="CUR") {
		var PLTemplateDR=PLObject.v_TPID;
	} else {
		var PLTemplateDR = PLObject.v_C_TPID;
	}
	var PLOrderDep=session['LOGON.CTLOCID']
	var PLOrderUser=session['LOGON.USERID']
	var PLAdmDR=ServerObj.EpisodeID
	var PLNote=$.trim($("#planNote").val())
	//����״̬��Y(��Ч)��N(δ��Ч)��S(ֹͣ)
	var PLStatus="Y"	//Ĭ��������Ч
	var PLExamNote = $.trim($("#LabExamNote").val())
	
	PLAry.push(PLID,PLName,PLPatientDR,PLTemplateDR,PLOrderDep,PLOrderUser,PLAdmDR,PLNote,PLStatus,PLExamNote);
	
	return PLAry;
}

function GetPSAry () {
	var PSAry = [];
	var PSID = PLObject.v_PSID||"";
	var PSStage = PLObject.v_Stage;
	var PSAgreeForm = $("#agreeFormTD").find("input[type='radio']:checked").val();
	var PSHasGMis = $("#sensitiveTD").find("input[type='radio']:checked").val();
	var PSTreatType = $("#treatTD").find("input[type='radio']:checked").val();
	var PSEffect = $.trim($("#stageEffect").val());
	var PSTplStage = PLObject.v_TSID||"";
	var CancerStage = $.trim($("#CancerStage").val());
	var PSSC = $.trim($("#VS-SC").val());
	var GMisFill = $.trim($("#GMisFill").val());
	var OhterFill = $.trim($("#OhterFill").val());
	var PSPlanTime = $.trim($("#palnTime").val());
	PSAry.push(PSID,PSStage,PSAgreeForm,PSHasGMis,PSTreatType,PSEffect,PSTplStage,CancerStage,PSSC,GMisFill,OhterFill,PSPlanTime);
	
	return PSAry;
}


function GetPGAry (HDAry) {
	var PGAry = [];
	for (var j=1; j<=PLObject.v_Groups; j++) {
		var GroupAry = [],
			GroupInfo = "",
			id = "GroupGrid-"+j,
			PlanDateID = "PlanDate-"+j,
			DescID = "TPGDesc-"+j,
			TPGID = "TPGID-"+j,
			PGID_ID = "PGID-"+j,
			MainDrug_ID = "MainDrug-"+j,
			NoteID = "Note-"+j;
			
		var gridData = GetGirdData(id);
		var PGID = $("#"+PGID_ID).val();
		var PGStage = PLObject.v_Stage;
		var PGCode = j;
		var PGDesc = $("#"+DescID).text();
		var PGPlanDate = $("#"+PlanDateID).val();
		var PGNote = $.trim($("#"+NoteID).val());
		var PGTplGrop = $("#"+TPGID).val();
		var MainDrug = $("#"+MainDrug_ID).val();
		
		//��״̬��Y(��Ч)��N(����)��S(ֹͣ)
		var PGStatus = "Y"	//Ĭ����Ч
		GroupAry.push(PGID,PGCode,PGPlanDate,PGNote,PGTplGrop,PGStatus,MainDrug,PGDesc);
		GroupInfo = GroupAry.join(String.fromCharCode(1));
		var ItemStr = "";
		for (var k=0; k < gridData.length; k++) {
			var ItemAry=[],
				HDItem = "",
				HDID = gridData[k].HDID,
				HospDose = gridData[k].HospDose,
				HDUomDR = 1,	//��Ĭ�ϣ�������չ֮���ڸĶ�
				ItemID=gridData[k].PGIId,
				PGIArcimDR = gridData[k].OrderARCIMRowid||"",
				PGIDosage = gridData[k].OrderDoseQty,
				PGIDosageUomDR = gridData[k].OrderDoseUOMRowid,
				PGIFreqDR = gridData[k].OrderFreqRowid,
				PGIInstruc = gridData[k].OrderInstrRowid,
				PGIDuratDR = gridData[k].OrderDurRowid,
				PGIQty = gridData[k].OrderPackQty,
				PGIUomDR = gridData[k].OrderPackUOMRowid,
				PGILinkItem = gridData[k].OrderMasterSeqNo,
				PGINote = gridData[k].OrderDepProcNote,
				PGIPriorDR = gridData[k].OrderPriorRowid,
				PGISimpleDR = gridData[k].OrderLabSpec,
				PGIRemark = gridData[k].OrderPriorRemarks,
				PGIRecLoc = gridData[k].OrderRecDepRowid,
				PGIStage = gridData[k].OrderStageCode,
				PGIFlowRate = gridData[k].OrderSpeedFlowRate,
				PGIFlowRateDR = gridData[k].OrderFlowRateUnitRowId,
				PGISkinTest = gridData[k].OrderSkinTest,
				PGISkinAction = gridData[k].OrderActionRowid,
				PGITplGroupItem = gridData[k].TplGroupItemId,
				BSAUnit = gridData[k].BSAUnit,
				BSA = $.trim($("#BSA").val()),
				Formula = gridData[k].Formula,
				GFR = $.trim($("#GFR").val());
				Seqno = gridData[k].id;
				
			if (PGILinkItem != "") {
				//PGILinkItem = gridData[k].TplGroupItemId;
				//todo...
			}
			if (PGIArcimDR == "") {
				continue;
			}
			//console.log("SkinAction=================")
			
			//console.log(j,k,PGITplGroupItem,PGISkinAction)
			//console.log("=============================")
			ItemAry.push(ItemID,PGIArcimDR,PGIDosage,PGIDosageUomDR,PGIFreqDR,PGIInstruc,PGIDuratDR,PGIQty,PGIUomDR,PGILinkItem,PGINote,PGIPriorDR,PGISimpleDR,PGIRemark,PGIRecLoc,PGIStage,PGIFlowRate,PGIFlowRateDR,PGISkinTest,PGISkinAction,PGITplGroupItem,BSAUnit,BSA,Formula,GFR,Seqno);
			
			HDItem = HDID +  String.fromCharCode(1) + ServerObj.PatientID + String.fromCharCode(1) + ServerObj.EpisodeID + String.fromCharCode(1) + PGIArcimDR + String.fromCharCode(1) + HospDose + String.fromCharCode(1) + HDUomDR;
			
			HDAry.push(HDItem);
			
			var ItemInfo = ItemAry.join(String.fromCharCode(1));
			if (ItemStr == "") {
				ItemStr = ItemInfo;
			} else {
				ItemStr = ItemStr + String.fromCharCode(3) + ItemInfo
			}
			console.log(ItemInfo)
		}
		var GroupStr = GroupInfo + String.fromCharCode(2) + ItemStr;
		PGAry.push(GroupStr);
	}
	
	return PGAry;
}

function Del_PGItem (id,rowid) {
	var PGIID=GetCellData(id,rowid,"PGIId");
	if (PGIID=="") {
		return true;
	}
	var result = $cm({
		ClassName: "DHCDoc.Chemo.BS.Item",
		MethodName: "DeleteGroupItem",
		PGIID: PGIID
	},false);

	if(result==0){
		return true;
	}else{
		$.messager.alert("��ʾ","ɾ��ʧ�ܣ�","warning");
		return false;
	}

}

function Send_Handler () {
	var chkResult = checkData("Send")
	if (!chkResult) {
		return false;
	}
	
	//PL
	var PLAry = GetPLAry();
	
	//PS
	var PSAry = GetPSAry();
	
	//HD
	var HDAry = [];
	
	//PG
	var PGAry = GetPGAry(HDAry);
	
	//PD
	var PDAry = GetPDAry();
	
	$cm({
			ClassName: "DHCDoc.Chemo.BS.Plan",
			MethodName: "Save",
			PLAry: PLAry,
			PSAry: PSAry,
			PGAry: PGAry,
			HDAry: HDAry,
			PDAry: PDAry
		},function(result){
			if(result==1){
				$.messager.alert("��ʾ","���ͳɹ���","success");
				InitTree("cur-tree","CUR");
				return true;
			}else{
				$.messager.alert("��ʾ","����ʧ�ܣ�������룺"+result,"warning");
				return false;
			}
	});
}

function Save_Handler () {
	var chkResult = checkData()
	if (!chkResult) {
		return false;
	}
	//PL
	var PLAry = GetPLAry();
	
	//PS
	var PSAry = GetPSAry();
	
	//HD
	var HDAry = [];
	
	//PG
	var PGAry = GetPGAry(HDAry);
	
	//PD
	var PDAry = GetPDAry();
	
	$cm({
			ClassName: "DHCDoc.Chemo.BS.Plan",
			MethodName: "Save",
			PLAry: PLAry,
			PSAry: PSAry,
			PGAry: PGAry,
			HDAry: HDAry,
			PDAry: PDAry
		},function(result){
			if(result==1){
				$.messager.alert("��ʾ","����ɹ���","success");
				InitTree("cur-tree","CUR");
				if (PLObject.v_Target != "") {
					//$("#cur-tree").tree(select, PLObject.v_Target);
				}
				
				return true;
			}else{
				$.messager.alert("��ʾ","����ʧ�ܣ�","warning");
				return false;
			}
	});
	
	
}

function Calculate_Handler () {
	var BASFunc = PLObject.m_BSAFunc.getValue()||"";
	if (BASFunc == "") {
		$.messager.alert("��ʾ","����ѡ�����������㹫ʽ��","warning")
		return false;
	}
	var BodyHeight = $.trim($("#BodyHeight").val());
	var BodyWeight = $.trim($("#BodyWeight").val());
	var BMI = (BodyWeight/(BodyHeight*BodyHeight)).toFixed(2);  
	if (BASFunc == "XWS") {
		//0.0061����ߣ�cm��+0.0128������(kg)-0.1529
		var BSA = ((0.0061*100*BodyHeight) + (0.0128*BodyWeight) - 0.1529).toFixed(4);
	}
	$("#BMI").val(BMI);
	$("#BSA").val(BSA);
}


function Stop_Handler () {
	var PDStatus = $("#PDStatus").val();
	
	if ((PLObject.v_PDID=="")||(PLObject.v_PDID=="NO")) {
		$.messager.alert("��ʾ", "���ȱ���"+PLObject.v_NodeText+"���Ʒ�����", "info");
		return false;
	}
	if ((PDStatus == "U")||(PDStatus == "S")) {
		if (PDStatus == "S") {
			$.messager.alert("��ʾ", PLObject.v_NodeText+"�����Ѿ�ֹͣ�������ٴν���ֹͣ������", "info");
		} else {
			$.messager.alert("��ʾ", PLObject.v_NodeText+"�����Ѿ���ɣ������ٴν���ֹͣ������", "info");
		}
		
		return false;
	}
	$.messager.confirm("��ʾ", "ȷ��ֹͣ"+PLObject.v_NodeText+"���Ʒ�����",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.Chemo.BS.Date",
				MethodName:"Stop",
				UserID:session['LOGON.USERID'],
				PDID:PLObject.v_PDID,
				PatientID:ServerObj.PatientID,
				EpisodeID:ServerObj.EpisodeID
			}, function(result){
				if (result == 0) {
					$.messager.alert("��ʾ", "ֹͣ�ɹ���", "info");
					InitTree("cur-tree","CUR");
					return true;
				} else if (result == -134) {
					$.messager.alert("��ʾ", "���ȼ���Ƶ�ҽ��֮���ٽ���ֹͣ��", "info");
					return false;
				} else {
					$.messager.alert("��ʾ", "ֹͣʧ�ܣ�" + result , "info");
					return false;
				}
			});
		}
		
	});
	
	
	
}

function Submit_Handler () {
	if (PLObject.v_Type != "CUR") {
		if (PLObject.v_Type=="") {
			$.messager.alert("��ʾ","����ѡ�����ڣ�","warning");
			return false;
		}
		$.messager.alert("��ʾ","���ǵ�ǰ����������ˣ�","warning");
		return false;
	}
	
	
	var chkResult = checkData()
	if (!chkResult) {
		return false;
	}
	//PL
	var PLAry = GetPLAry();
	
	var PSAry = GetPSAry();
	
	//HD
	var HDAry = [];
	
	//PG
	var PGAry = GetPGAry(HDAry);
	
	//PD
	var PDAry = GetPDAry();
	
	if (ServerObj.PAAdmType == "IO") {
		var PlanDate = $("#otherDate").val();
	} else {
		//var PlanDate = $("#curPlanDate").val();
		var PlanDate = $("#otherDate").datebox("getValue")||"";
	}
	if (PlanDate=="") {
		$.messager.alert("��ʾ","��ѡ�������ڣ�","warning");
		return false;
	}
	
	/*
	//����Ƿ������
	var result = $cm({
		ClassName:"DHCDoc.Chemo.BS.Date",
		MethodName:"HasPass",
		PlanDate:PlanDate,
		PSID:PLObject.v_PSID,
		dataType:"text"
	},false);
	
	if (result==0) {
		$.messager.alert("��ʾ","��ѡ����ɻ��Ʒ�����ˣ�","warning");
		return false;
	}
	*/
	if (ServerObj.HasAcitve==1) {
		$.messager.alert("��ʾ","�Ѽ���˴λ��ƣ�","warning");
		return false;
	}
	//����Ƿ������Ч����
	var result = $cm({
		ClassName:"DHCDoc.Chemo.BS.DateApply",
		MethodName:"HasApply",
		PDID:PLObject.v_PDID,
		dataType:"text"
	},false);
	
	if (result==1) {
		$.messager.alert("��ʾ","�Ѽ���˴λ��ƣ�","warning");
		return false;
	}
	
	$cm({
			ClassName: "DHCDoc.Chemo.BS.Plan",
			MethodName: "Save",
			PLAry: PLAry,
			PSAry: PSAry,
			PGAry: PGAry,
			HDAry: HDAry,
			PDAry: PDAry
		},function(result){
			if(result==1){
			//$.messager.alert("��ʾ","����ɹ���","success");
			// InitTree("cur-tree","CUR");
				
			websys_showModal("hide");
			websys_showModal('options').CallBackFunc(PLObject.v_PSID,PlanDate);
			websys_showModal("close");	
		
				return true;
			}else{
				$.messager.alert("��ʾ","����ʧ�ܣ�","warning");
				return false;
			}
	});
	
	
}

//���
function Exam_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "dhcapp.inspectrs.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	//var URL = "dhcapp.seepatlis.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'�����Ϣ',
		maximizable:true,
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//Ժ������
function OtherHosp_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "emr.resource.pictureinformation.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		maximizable:true,
		iconCls: 'icon-w-add',
		title:'Ժ������',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//����
function Lab_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "dhcapp.seepatlis.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'������Ϣ',
		maximizable:true,
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//���Ӳ���
function MC_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	//var URL = "emr.record.browse.episode.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	var URL = "emr.browse.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'���Ӳ���',
		maximizable:true,
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//����
function NUR_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "nur.hisui.recordsBrowser.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'�����¼',
		maximizable:true,
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//�����б�
function ApplyList_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "chemo.bs.applylist.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'�����б�',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//�������
function BLDetail_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	//var URL = "nur.hisui.recordsBrowser.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	
	var lnk= "websys.chartbook.hisui.csp?"+"EpisodeID="+EpisodeID;	//DHC.Doctor.DHCEMRbrowse
	lnk = lnk +"&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookName=DHC.Doctor.DHCEMRbrowse&PatientBanner=dhcdoc.patinfo.banner.csp"
	
	websys_showModal({
		url:lnk,
		iconCls: 'icon-w-add',
		title:'�������',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	
	
	
	return false;
}

//����
function BL_Handler () {
	return false;
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "nur.hisui.recordsBrowser.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'�����¼',
		maximizable:true,
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

function CurOrder_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	//oeorder.opbillinfo.csp?PatientID=1&EpisodeID=1405&mradm=1405&OpenWinName=OPDocRecAdm
	var URL = "oeorder.opbillinfo.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+EpisodeID+"&OpenWinName="+"OPDocRecAdm";
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'����ҽ��',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

function HisOrder_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	//oeorder.opbillinfo.csp?PatientID=1&EpisodeID=1405&mradm=1405&OpenWinName=OPDocRecAdm
	var URL = "pha.out.v3.historyAdm.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'��ʷҽ��',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//�����¼�
function AES_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType,
		RegNo = ServerObj.RegNo;
	var URL = "dhcadv.reportquery.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType+"&OnlyShowPatReport="+1;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'�����¼�',
		maximizable:true,
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//����ȷ��
function GMisOK_Handler () {
	var PSID = PLObject.v_PSID||"";
	if (PSID == "") {
		return false;
	}
	
	var PSHasGMis = $("#sensitiveTD").find("input[type='radio']:checked").val();
	var GMisFill = $.trim($("#GMisFill").val());
	if (PSHasGMis==1) {
		if (GMisFill=="") {
			$.messager.alert("��ʾ","����д����ʷ��¼��","warning",function () {
				$("#GMisFill").focus();	
			})
			
			return false;
		}
	}
	
	var OKUser = session['LOGON.USERID'];
	var HasGMis = $("#sensitiveTD").find("input[type='radio']:checked").val();
	$cm({
			ClassName: "DHCDoc.Chemo.BS.Apply",
			MethodName: "GMisOK",
			OKUser: OKUser,
			PSID: PSID,
			HasGMis: HasGMis,
			GMisFill: GMisFill
		},function(result){
			if(result==0){
				InitTree("cur-tree","CUR");
				$.messager.alert("��ʾ","ȷ�ϳɹ���","warning");
				return true;
			}else{
				$.messager.alert("��ʾ","ȷ��ʧ�ܣ�","warning");
				return false;
			}
	});
	
}

//����ʷ
function GMis_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "dhcem.allergyenter.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'����ʷ',
		maximizable:true,
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
	
}

//֪��ͬ����
function AgreeForm_Handler () {
	
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	/*$cm({
			ClassName: "EMRservice.HISInterface.PatientInfoAssist",
			MethodName: "GetEMRInstanceID",
			argEpisodeID: EpisodeID,
			
		},function(result){
				if (result!=""){
					var URL = "emr.dhcemrprint.csp?InstanceId="+result;
					websys_showModal({
					url:URL,
					iconCls: 'icon-w-add',
					title:'֪��ͬ����',
					width:$(window).width()-100,height:$(window).height()-100
			})	
		}
	});
		
	PilotProWarning=tkMakeServerCall("web.PilotProject.DHCDocPilotProject","ifWarning"*/
	var result=tkMakeServerCall("EMRservice.HISInterface.PatientInfoAssist","GetEMRInstanceID",EpisodeID)
	if (result!=""){
			var URL = "emr.record.browse.browsform.editor.csp?EpisodeID="+EpisodeID+"&id="+result+"&Print=N&chartItemType=Multiple&pluginType=DOC";
			websys_showModal({
			url:URL,
			maximizable:true,
			iconCls: 'icon-w-add',
			title:'֪��ͬ����',
			width:$(window).width()-100,height:$(window).height()-100
			})
	}
	
	return false;
	
}

function AdjPlanDate_Handler () {
	if (PLObject.v_Type != "CUR") {
		if (PLObject.v_Type=="") {
			$.messager.alert("��ʾ","����ѡ�����ڣ�","warning");
			return false;
		}
		$.messager.alert("��ʾ","���ǵ�ǰ�������ܵ�����","warning");
		return false;
	}
	var AdjDateFrom = PLObject.v_NextDay;
	var AdjDateTo = $("#nexday").datebox("getValue")||"";
	if (AdjDateTo == "") {
		$.messager.alert("��ʾ","�´λ������ڲ���Ϊ�գ�","warning");
		return false;
	}
	$cm({
			ClassName: "DHCDoc.Chemo.BS.Apply",
			MethodName: "AdjustPlanDate",
			PSID: PLObject.v_PSID,
			AdjDateFrom: AdjDateFrom,
			AdjDateTo: AdjDateTo
		},function(result){
			if(result==0){
				InitTree("cur-tree","CUR");
				$.messager.alert("��ʾ","�����ɹ���","warning");
				return true;
			}else{
				$.messager.alert("��ʾ","����ʧ�ܣ�","warning");
				return false;
			}
	});
	
	
	
}

function Find_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
		//chemo.bs.audit.csp
		//chemo.bs.nurse.csp
	var URL = "chemo.bs.nurse.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		//maximizable:true,
		iconCls: 'icon-w-add',
		title:'���ߵ�ǰ���Ƶ�����',
		width:$(window).width()-100,height:$(window).height()-100
	})	
}

function Formula_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	
	var Height=$.trim($("#VS-Height").val());
	var Weight=$.trim($("#VS-Weight").val());
	var BSA=$.trim($("#BSA").val());
	var GFR=$.trim($("#GFR").val());
	var SC=$.trim($("#VS-SC").val());
	var IBW=$.trim($("#IBW").val());
	var Age=$.trim($("#Age").val());
	var Sex=$.trim($("#Sex").val());
	
	
	var VSData=Height+"^"+Weight+"^"+BSA+"^"+GFR+"^"+SC+"^"+IBW+"^"+Age+"^"+Sex;
	
	var URL = "chemo.bs.formula.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType+"&VSData="+VSData;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-calc',
		title:'���Ƽ�����',
		width:800,height:$(window).height()-100
	})	
}

function SC_UP_Handler(e) {
	var SC = $(this).val();
	var Age = $("#Age").val();
	var Sex = $("#Sex").val();
	var Weight = $("#VS-Weight").val(); 
	var GFR = CalcGFR(Age,Weight,SC,Sex)
	$("#GFR").val(GFR);
	
}


function autoSetGridWH(selector){
	
	setTimeout(function(){ 
		if (PLObject.v_Type == "CUR") {
			var newWidth = $(".toolbar-div").width()+2;
		} else {
			var newWidth = $(".search-table").width()-20;	
		}
		console.log(newWidth)
		$('.m-panel').panel('resize',{
			width: newWidth
		});
	}, 200);
	
	return false;
    setTimeout(function(){
		$("#gbox_"+selector).css("width","100%");
		
		$("#gbox_"+selector).css("width","100%");
		
		$("#gview_"+selector+" .ui-jqgrid-hdiv").css("width","100%");
		
		$("#gview_"+selector+" .ui-jqgrid-hbox").css("width","100%");
		
		$("#gview_"+selector+" .ui-jqgrid-bdiv").css("width","100%");
		
		
	}, 10);
    
}

function Resize_Handler() {
	for (var j=1; j<=PLObject.v_Groups; j++) {
		var id = "GroupGrid-"+j;
		autoSetGridWH(id);
		
		//$("#"+id).jqGrid('setGridWidth',$(window).width() - 30);
		// �߶��Զ���Ӧ
		//$(window).unbind("onresize");
		//$("#"+id).setGridHeight($(window).height() - 370); // grid_selector �� DIV �� ID
		//$(window).bind("onresize", this);	
	}
	
}
function FormulaRef_Handler() {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "chemo.bs.formula.ref.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-calc',
		title:'��ʽ',
		maximizable:true,
		width:$(window).width()-100,height:$(window).height()-100
	})		
}

function AdjDetail_HandleroLD () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "chemo.bs.adjustdetail.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'��������',
		maximizable:true,
		width:$(window).width()-100,height:$(window).height()-100
	})			
}

function AdjDetail_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType,
		PLID = PLObject.v_PLID;
		
	if (PLID=="") {
		return false;
	}
	var URL = "chemo.bs.adjustdetail.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType+"&PLID="+PLID
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'��������',
		maximizable:true,
		width:$(window).width()-100,height:$(window).height()-100
	})			
}

function OkPlan_Handler () {
	if (PLObject.v_Type != "CUR") {
		if (PLObject.v_Type=="") {
			$.messager.alert("��ʾ","����ѡ�����ڣ�","warning");
			return false;
		}
		$.messager.alert("��ʾ","���ǵ�ǰ����������ˣ�","warning");
		return false;
	}
	
	$.messager.confirm("��ʾ", "ȷ����ɵ�ǰ���Ʒ���ô��",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.Chemo.BS.Plan",
				MethodName:"OkChemoPlan",
				UserID:session['LOGON.USERID'],
				PLID:PLObject.v_PLID,
				LocID:session['LOGON.CTLOCID'],
				PatientID:ServerObj.PatientID,
				EpisodeID:ServerObj.EpisodeID
			}, function(result){
				if (result == 0) {
					$.messager.alert("��ʾ", "����ɹ���", "info");
					InitTree("history-tree","HIS")
					InitTree("cur-tree","CUR");
					return true;
				} else {
					$.messager.alert("��ʾ", "����ʧ�ܣ�" + result , "info");
					return false;
				}
			});
		}
		
	});
	
}

function SearchPlan_Handler () {
	InitTree("history-tree","HIS");
}
function SearchDep_Handler () {
	InitTree("dep-tree","DEP");
}
function SearchHosp_Handler () {
	InitTree("hosp-tree","HOSP");
}


function BSAUnitkeyuphandler (e) {
	
	try { var keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
	
	var rowid = "";
	var obj = websys_getSrcElement(e);
	var parObj = $(obj).closest('table');
	if (parObj.length>0) {
		var id = parObj.attr("id");
		if (obj.id.indexOf("_") > 0) {
			rowid = obj.id.split("_")[0];
		}
		var val = GetCellData(id,rowid,"BSAUnit");
		var newValue = val.substring(0, 1);
		var Formula = GetCellData(id,rowid,"Formula");
		if (Formula == "GFR") {
			//
			var temVal = GetCellData(id,rowid,"BSAUnit");
			if (temVal!="") {
				var GFR = $.trim($("#GFR").val());
				var Dosage = GFR*temVal;
				SetCellData(id, rowid, "OrderDoseQty", Dosage);
			} else {
				SetCellData(id, rowid, "OrderDoseQty", "");
			}
			
		} else if (Formula == "BSA") {
			var temVal = GetCellData(id,rowid,"BSAUnit");
			var InArcim = GetCellData(id,rowid,"OrderARCIMRowid");
			var BSA = $("#BSA").val();
			var Dosage = BSA*temVal;
			if (temVal!="") {
				
				var result = $cm({
					ClassName:"DHCDoc.Chemo.BS.Apply",
					MethodName:"HasOverLifeDose",
					InArcim:InArcim,
					BSAUnit:temVal,
					PatientID:ServerObj.PatientID,
					dataType:"text"
				},false);
				if (result==1) {
					//SetCellData(id, rowid, "BSAUnit", "");
					$.messager.alert("��ʾ","�������������","warning");
					SetCellData(id, rowid, "OrderDoseQty", Dosage);
					return false;
				} else {
					SetCellData(id, rowid, "OrderDoseQty", Dosage);
				}
				
			} else {
				SetCellData(id, rowid, "OrderDoseQty", "");
			}
			
		} else {
			//TODO
		}
		
		
		
	}
}

function OrderDoseQtykeyuphandler (e) {
	//QP 2020-07-01 ��������
	return false;
	try { var keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
	console.log("keycode: "+ keycode)
	var rowid = "";
	var obj = websys_getSrcElement(e);
	var parObj = $(obj).closest('table');
	if (parObj.length>0) {
		var id = parObj.attr("id");
		if (obj.id.indexOf("_") > 0) {
			rowid = obj.id.split("_")[0];
		}
		//����������ַ�����
		var val = $(this).val();
		var newValue = val.substring(0, val.length-1);
		console.log(val,newValue)
		if ( ((keycode!=190)&&(keycode>57)) ||(keycode<48)) {
			if (keycode==8) {
				$(this).val(val);
			} else {
				if (newValue=="") {
					$(this).val("");
				} else {
					$(this).val(newValue);
				}
			}
		} 
		
		//��������
		var Formula = GetCellData(id,rowid,"Formula");
		var val = GetCellData(id,rowid,"OrderDoseQty");
		var BSA = $.trim($("#BSA").val());
		var GFR = $.trim($("#GFR").val());
		if (val=="") {
			SetCellData(id, rowid, "BSAUnit", "");
			return false;
		}
		if (Formula=="BSA") {
			var newBSAUnit = BackBSADose(val,BSA);
			SetCellData(id, rowid, "BSAUnit", newBSAUnit);
			return false;
		}
		if (Formula=="GFR") {
			var newBSAUnit = BackGFRDose(val,GFR);
			SetCellData(id, rowid, "BSAUnit", newBSAUnit);
			/* 
			if ((newBSAUnit<4)||(newBSAUnit>7)) {
				SetCellData(id, rowid, "BSAUnit", "");
				$(this).val("")
			} else {
				SetCellData(id, rowid, "BSAUnit", newBSAUnit);
			} */
			return false;
		}
		
		
	}
	
}

//4-7����
function BSAUnitkeyuphandlerOld (e) {
	
	try { var keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
    //if (keycode == 45) { window.event.keyCode = 0; return websys_cancel(); }
	
	var rowid = "";
	var obj = websys_getSrcElement(e);
	var parObj = $(obj).closest('table');
	if (parObj.length>0) {
		var id = parObj.attr("id");
		if (obj.id.indexOf("_") > 0) {
			rowid = obj.id.split("_")[0];
		}
		var val = GetCellData(id,rowid,"BSAUnit");
		var newValue = val.substring(0, 1);
		var Formula = GetCellData(id,rowid,"Formula");
		if (Formula == "GFR") {
			if ((keycode<52)||(keycode>55)) {
				if (val == "") {
					SetCellData(id, rowid, "OrderDoseQty", "");
				}
				if (val>=10) {
					SetCellData(id, rowid, "BSAUnit", newValue);
				} else {
					SetCellData(id, rowid, "BSAUnit", "");
				}
				
				return false;
			} else {
				//�����ֵ��4-7֮��
				if (val>7) { //��λ��
					SetCellData(id, rowid, "BSAUnit", newValue);
				}
			}
			//
			var temVal = GetCellData(id,rowid,"BSAUnit");
			if (temVal!="") {
				var GFR = $.trim($("#GFR").val());
				var Dosage = GFR*temVal;
				SetCellData(id, rowid, "OrderDoseQty", Dosage);
			} else {
				SetCellData(id, rowid, "OrderDoseQty", "");
			}
			
		} else if (Formula == "BSA") {
			var temVal = GetCellData(id,rowid,"BSAUnit");
			var InArcim = GetCellData(id,rowid,"OrderARCIMRowid");
			var BSA = $("#BSA").val();
			var Dosage = BSA*temVal;
			if (temVal!="") {
				
				var result = $cm({
					ClassName:"DHCDoc.Chemo.BS.Apply",
					MethodName:"HasOverLifeDose",
					InArcim:InArcim,
					BSAUnit:temVal,
					PatientID:ServerObj.PatientID,
					dataType:"text"
				},false);
				if (result==1) {
					//SetCellData(id, rowid, "BSAUnit", "");
					$.messager.alert("��ʾ","�������������","warning");
					SetCellData(id, rowid, "OrderDoseQty", Dosage);
					return false;
				} else {
					SetCellData(id, rowid, "OrderDoseQty", Dosage);
				}
				
			} else {
				SetCellData(id, rowid, "OrderDoseQty", "");
			}
			
		} else {
			//TODO
		}
		
		
		
	}
}

function GroupTypechangehandler (e) {
	return false;
	var rowid = "";
    var obj = websys_getSrcElement(e);
	var parObj = $(obj).closest('table');
	if (parObj.length>0) {
		var id = parObj.attr("id")
		if (obj.id.indexOf("_") > 0) {
			rowid = obj.id.split("_")[0];
		}
		//var text = $(obj).find("option:selected").text();
		SetCellData(id,rowid, "GroupTypeId", obj.value);
		SetCellData(id,rowid, "GroupType", obj.value);
	}
}

function MainDrugchangehandler () {}
function Cancel_Handler () {}

function Gotop_Handler () {
	//document.getElementById("main-center").scrollTop = 0;
	$("#main-center").animate({scrollTop:0},200);
	
}


function Agree_Handler() {
	if ((ServerObj.PDAID=="")||(ServerObj.Type=="")) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	
	var PDAID = ServerObj.PDAID
	var LinkPDAID = ServerObj.LinkPDAID
	var Status=""
	if (ServerObj.Type=="KS") {
		Status="S"	
	} else {
		Status="Y"	
	}
	var mList=Status+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID'];
	
	$m({
		ClassName:"DHCDoc.Chemo.BS.Ext.Audit",
		MethodName:"Verify",
		PDAID:PDAID,
		Type:ServerObj.Type,
		mList: mList,
		LinkPDAID:LinkPDAID
	}, function(result){
		if (result == 0) {
			
			$.messager.alert("��ʾ", "ͬ��ɹ���", "info", function () {
				//parent.findConfig();
			})
			PCallBack();
		} else {
			var resultArr=result.split("^");
			var Msg = resultArr[1]||"ͬ��ʧ�ܣ�";
			$.messager.alert("��ʾ", Msg , "info");
			return false;
		}
	});
	
			
	
	
	
}
function Refuse_Handler() {
	if ((ServerObj.PDAID=="")||(ServerObj.Type=="")) {
		$.messager.alert("��ʾ", "��ѡ��һ�У�", "info");
		return false;
	}
	
	var PDAID = ServerObj.PDAID
	var LinkPDAID = ServerObj.LinkPDAID
	var URL = "chemo.bs.audit.refuse.csp?PDAID="+PDAID+"&Type="+ServerObj.Type+"&LinkPDAID="+LinkPDAID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'�ܾ�',
		width:570,height:500,
		CallBackFunc:Callback_Refuse
	})
}

function Callback_Refuse() {
	//websys_showModal('options').CallBackFunc();
	//parent.findConfig();	
	PCallBack();
}


