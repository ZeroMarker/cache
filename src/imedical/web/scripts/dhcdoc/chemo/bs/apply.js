/**
 * apply.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
PLObject = {
	//静态属性对象
	j_Global:{},
	//静态属性值
	j_BLChemoAuth:"",	//疑难病例权限
	j_IsDiffcultBL:"",	//是否为疑难病例
	j_ChemoAuth:"",		//化疗方案权限
	v_ComDateNum:0,		//日期框弹出个数，用于判断当前日期框是否弹出。
	
	v_Type: "",
	v_Target: "",	//当前树节点
	v_TotalStage:"", //总周期数
	v_Groups:0,		//周期总组数
	v_C_TPID: "",	//当前化疗单模板ID
	v_Stage:"",		//所选周期代码
	v_NextDay:"",	//下次化疗日期
	
	v_C_StageS: "",	//当前化疗单已保存的阶段串
	
	v_TPID:"",		//模板ID
	v_TSID: "",		//模板周期ID
	v_PLID: "",		//化疗单ID
	v_PSID: "",		//化疗周期ID
	v_PDID: "",		//所选日期方案ID
	v_NodeText: "",	//所选日期文本内容
	v_SelectDate: "",	//所选日期
	
	o_NAV:[],
	o_MObj: ""		//PLObject.o_MObj.PLName
}

$(function() {
	Init();
	InitEvent();
	PageHandle();
})

function Init(){
	InitPageGloabl();
	InitSearchBox();
	LoadBar(ServerObj.EpisodeID);
	InitTree("user-tree","USER")
	InitTree("dep-tree","DEP")
	InitTree("hosp-tree","HOSP")
	InitTree("history-tree","HIS")
	InitTree("cur-tree","CUR")
	InitCombox()
	//InitGroupHtml();
	//InitGrid();
	
}

//初始化静态属性对象
function InitPageGloabl() {
	var SessionStr = GetSessionStr();
	PLObject.j_Global = $cm({
		ClassName: "DHCDoc.Chemo.COM.CallMethod",
		MethodName: "GetPageGloabl",
		SessionStr: SessionStr,
		EpisodeID: ServerObj.EpisodeID
	},false);
	
	/*
	var PList = PagePList.split("^");
	PLObject.j_BLChemoAuth=PList[0];	
	PLObject.j_IsDiffcultBL=PList[1];	
	PLObject.j_ChemoAuth=PList[2];		
	*/
}
function InitEvent () {
	//$("#up").click(Add_Order_row)
	//$("#Del_btn").click(Delete_Order_row);
	$('#i-overtab').tabs({   
	    onSelect:function(title){  
		    LoadChemoApply(title);
	        LoadOverview(title);
	    }   
	});  
	$("#BLDetail").click(BLDetail_Handler)
	$("#OtherHosp").click(OtherHosp_Handler)
	$("#NodeCopy").click(NodeCopy_Handler)
	$("#PrintBtn").click(PrintBtn_Handler)
	$("#BackBtn").click(BackBtn_Handler)
	$("#MainDrugBtn").click(MainDrugBt_Handler)
	$("#Calculate").click(Calculate_Handler)
	$("#SaveAll").click(SaveAll_Handler)
	$("#Save").click(Save_Handler)
	$("#Stop").click(Stop_Handler)
	$("#Cancel").click(Cancel_Handler)
	$("#Submit").click(Submit_Handler)
	$("#Send").click(Send_Handler)
	$("#Find").click(Find_Handler)
	$("#Formula").click(Formula_Handler)
	$("#LinkRef").click(LinkRef_Handler)
	//
	$("#Exam").click(Exam_Handler)
	$("#Lab").click(Lab_Handler)
	//$("#GMisOK").click(GMisOK_Handler)
	$("#AgreeForm").click(AgreeForm_Handler)
	$("#GMis").click(GMis_Handler)
	
	$("#MC").click(MC_Handler)
	$("#NUR").click(NUR_Handler)
	$("#AES").click(AES_Handler)
	$("#BL").click(BL_Handler)
	//
	$("#CurOrder").click(CurOrder_Handler)
	$("#HisOrder").click(HisOrder_Handler)
	
	$("#ApplyList").click(ApplyList_Handler)
	
	//$("#AdjPlanDate").click(AdjPlanDate_Handler)
	$("#VS-SC").keyup(SC_UP_Handler);
	$("#FormulaRef").click(FormulaRef_Handler)
	$("#AdjDetail").click(AdjDetail_Handler)
	$("#OkPlan").click(OkPlan_Handler)
	//历史方案搜索
	$("#SearchPlan").click(SearchPlan_Handler)
	$("#s-content").bind('keypress',function(event){
    	if(event.keyCode == "13") {
	    	SearchPlan_Handler();
	    }
            
    });
    //用户模板搜索
    $("#SearchUser").click(SearchUser_Handler)
    $("#s-content-user").bind('keypress',function(event){
    	if(event.keyCode == "13") {
	    	SearchUser_Handler();
	    }
            
    });
    $("#s-content-userzy").checkbox({
		onChecked:function () {
			SearchUser_Handler();
		},onUnchecked:function () {
			SearchUser_Handler();
		}  
	})
    //科室模板搜索
    $("#SearchDep").click(SearchDep_Handler)
    $("#s-content-dep").bind('keypress',function(event){
    	if(event.keyCode == "13") {
	    	SearchDep_Handler();
	    }
            
    });
    $("#s-content-depzy").checkbox({
		onChecked:function () {
			SearchDep_Handler();
		},onUnchecked:function () {
			SearchDep_Handler();
		}  
	})
    //医院模板搜索
     $("#SearchHosp").click(SearchHosp_Handler)
     $("#s-content-hosp").bind('keypress',function(event){
    	if(event.keyCode == "13") {
	    	SearchHosp_Handler();
	    }
            
    });
	 $("#s-content-hospzy").checkbox({
		onChecked:function () {
			SearchHosp_Handler();
		},onUnchecked:function () {
			SearchHosp_Handler();
		}  
	})
	
	$("#CurCollapse").click(function () {
		$('#i-layout').layout('collapse','west'); 
	})
	$("#W-Collapse").click(function () {
		$('#w-layout').layout('collapse','south');
	})
	
	/*
	$("#GMisOK_New").checkbox({
		onChecked:function () {
			GMisOK_Handler()
		}
	})*/
	$("#Gotop").click(Gotop_Handler)
	$("#CollapseAll").click(CollapseAll_Handler)
	$("#ExpandAll").click(ExpandAll_Handler)
	//
	$('#i-layout').layout('panel', 'center').panel({
		onResize: function (w,h) { 
			Resize_Handler();	
		}
	});
	
	$("#i-delaytime").radio({
		onCheckChange:function (e,value) {
			if (value) {
				$("#delayReason").removeAttr("disabled")
			}else {
				$("#delayReason").attr("disabled","disabled").val("");
			}
		}
	})
	$("#i-otherType").radio({
		onCheckChange:function (e,value) {
			if (value) {
				$("#OhterFill").removeAttr("disabled")
			} else {
				$("#OhterFill").attr("disabled","disabled").val("");
			}
		}
	})
	
	/*$("#i-no-sensitive").radio({
		onCheckChange:function (e,value) {
			if (value) {
				$("#GMisFill").attr("disabled","disabled").val("");
			} else {
				$("#GMisFill").removeAttr("disabled")
			}
		}
	})*/
	
	$("#i-sensitive").radio({
		onCheckChange:function (e,value) {
			if (value) {
				$("#GMisFill").removeAttr("disabled")
			} else {
				$("#GMisFill").attr("disabled","disabled").val("");
			}
		}
	})
	$(window).resize(Resize_Handler);
	$(document.body).bind("keydown",BodykeydownHandler);
	
}
function PageHandle () {
	//doScroll();
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
	
	$("#Add_btn").click(function(){
		Add_Order_row(id,PLObject)
		Add_ChgReason(id,"ADD")
	})
	
	$("#Del_btn").click(function(){
		Delete_Order_row(id)
		
	})
	
	$("#StopOrder_btn").click(function(){
		StopOrder_Click(id)
	})
	
	$("#DrugNote_btn").click(function(){
		DrugNote_Click(id)
	})
	
	$("#Adj_btn").click(function(){
		Adj_Order_row(id)
		
	})
	$("#Link_btn").click(function(){
		var btnId = "Link_btn"
		Link_Order_row(btnId,id)
		
	})
	$("#Up_btn").click(function(){
		SortRowClick(id,"up")
		
	})
	$("#Down_btn").click(function(){
		SortRowClick(id,"down")
	})
	
	$("#ComDate_btn").click(function(){
		ComDateClick()
	})

	$("#PRNCOM_btn").click(function(){
		var Desc= $(this).text();
		var gID = $(this).attr("value");
		var gDesc = $(this).attr("desc");
		Arcos_btn_Handler(id,"PRNCOM",Desc,gID,gDesc)
	})
	$("#PRNGM_btn").click(function(){
		var Desc= $(this).text();
		var gID = $(this).attr("value");
		var gDesc = $(this).attr("desc");
		Arcos_btn_Handler(id,"PRNGM",Desc,gID,gDesc)
	})
	
	$("#OutDrug_btn").click(function(){
		var Desc= $(this).text();
		var gID = $(this).attr("value");
		var gDesc = $(this).attr("desc");
		Arcos_btn_Handler(id,"OUT",Desc,gID,gDesc)
		
	})

	$("#PRE_btn").click(function(){
		var Desc = $(this).text();
		var gID = $(this).attr("value");
		var gDesc = $(this).attr("desc");
		Arcos_btn_Handler(id,"PRE",Desc,gID,gDesc)
	})


	$("#POST_btn").click(function(){
		var Desc= $(this).text();
		var gID = $(this).attr("value");
		var gDesc = $(this).attr("desc");
		Arcos_btn_Handler(id,"POST",Desc,gID,gDesc)
	})
	
	$("#OTHER_btn").click(function(){
		var Desc= $(this).text();
		var gID = $(this).attr("value");
		var gDesc = $(this).attr("desc");
		Arcos_btn_Handler(id,"OTHER",Desc,gID,gDesc)
	})
	
	$("#PRES_btn").click(function(){
		var Desc= $(this).text();
		var gID = $(this).attr("value");
		var gDesc = $(this).attr("desc");
		Arcos_btn_Handler(id,"PRNS",Desc,gID,gDesc)
	})
}

function SortRowClick(id, type){
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
	SelIds.sort(function(a, b){ return a - b; });	//升序
	debug(SelIds,"SelIds")
	var SelArcimIDs = {};
	
	var gridData = GetGirdData("GroupGrid");
	//debug(gridData,"gridData");
	$.each(SelIds, function (idx, val) {
		//var InArcimName = GetCellData(id,idx,"OrderName");
		//SelArcimIDs[InArcim]="";
		InArcim = gridData[val-1].OrderARCIMRowid||"";
		SelArcimIDs[InArcim]="1";
	})
	
	debug(SelArcimIDs,"SelArcimIDs");
	//
	for(var i = 0; i < SelIds.length; i++) {
	    //$('#'+id).setSelection(SelIds[i], false);
	}

	setTimeout(function ()  {
			
		var MinRowid=SelIds[0];
		var MaxRowid=parseInt(SelIds[SelIds.length-1]);
		var rowids = $('#'+id).getDataIDs().slice(0);	//得到所有的主键
		///将空行和已审核的行删除
		GetUnSaveRows(rowids,id);
		debug(rowids,"rowids")
		
		var EnableSort=true;
		var CheckStart=0;
		for (var i = 0; i<rowids.length; i++){
			//console.log(i,"-",rowids[i])
			var LoopIndex=$.inArray(rowids[i],SelIds);
			if (LoopIndex!=-1){
				CheckStart=1;
			}
			if ((CheckStart==1)&&(LoopIndex==-1)&&(parseInt(SelIds[SelIds.length-1])>parseInt(rowids[i]))){
				//console.log(CheckStart+": "+LoopIndex+"："+SelIds[SelIds.length-1]+"： "+ rowids[i])
				EnableSort=false;
				break;
			}
		}
		if (EnableSort==false){
			$.messager.alert("警告","请选择相邻的块进行移动!","warning");
			return false;
		}
		
		//return 
		var RecentlyRowid="";
		if (type=="up"){
			//先找到选择的医嘱项最近的一个医嘱行id
			for (var i = rowids.length-1; i >=0; i--) {
				if (parseInt(rowids[i])<parseInt(SelIds[0])){
					RecentlyRowid=rowids[i];
					break;
				}
			}
		}else{
			for (var i = 0; i <rowids.length; i++) {
				if (parseInt(rowids[i])>parseInt(SelIds[SelIds.length-1])){
					RecentlyRowid=rowids[i];
					break;
				}
			}
		}
		if (RecentlyRowid==""){return;}
		var RecentlyRowid=parseInt(RecentlyRowid)
		var RecentlyOrderMasterSeqNo=GetCellData(id,RecentlyRowid, "OrderMasterSeqNo");
		var RecentlyOrderSeqNo=GetCellData(id,RecentlyRowid, "id");
		var RecentlyLinkRowidList = ""
		if (RecentlyOrderMasterSeqNo!="") {	//成组医嘱
			RecentlyLinkRowidList=GetSeqNolist(id,RecentlyRowid);
		}
		debug(RecentlyRowid,"RecentlyRowid")
		debug(RecentlyLinkRowidList,"RecentlyLinkRowidList")
		//找到需要调整的行数据
		var NeedMoveRowids = new Array();
		
		for (var i = 0; i < rowids.length; i++) {
			var OrderMasterSeqNo = GetCellData(rowids[i], "OrderMasterSeqNo");
			var OrderSeqNo = GetCellData(rowids[i], "id");
			var OrderARCIMRowid = GetCellData(rowids[i], "OrderARCIMRowid");
			
			if (type=="down") {
				if (parseInt(rowids[i])<=MaxRowid) {
					continue;   
					var Index=$.inArray(rowids[i],RecentlyLinkRowidList);
					if (Index<0) {
						continue;
					}
				}
				if (parseInt(rowids[i])>RecentlyRowid) {
					var Index=$.inArray(rowids[i],RecentlyLinkRowidList);
					if (Index<0) {
						continue;
					}
				}
			} else {
				if (parseInt(rowids[i])>=MinRowid) {
					continue;   
					var Index=$.inArray(rowids[i],RecentlyLinkRowidList);
					if (Index<0) {
						continue;
					}
				}
				if (parseInt(rowids[i])<RecentlyRowid) {
					var Index=$.inArray(rowids[i],RecentlyLinkRowidList);
					if (Index<0) {
						continue;
					}
				}
			}
			
			NeedMoveRowids.push(rowids[i]);
		}
		if (NeedMoveRowids.length==0){return;}
		///这里获得了需要重拍的队列
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
				//前几个是需要向下移动的行
				if (i<=(NeedMoveRowids.length-1)){
					var cid = parseInt(curRowData["id"])+parseInt(SelIds.length);
				}else{
					var cid = curRowData["id"]=parseInt(curRowData["id"])-(NeedMoveRowids.length);
				}
				curRowData["id"] = cid;
				debug(cid,"cid")
			} else {
				//前几个是需要向上移动的行
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
		
		///这里获取到了需要编辑的行队列
		var SortList=MoveList.slice(0);
		SortList.sort(function(a, b){return a - b;});
		debug(SortList,"SortList")
		var SelectList=[],NoSelectList=[]
		$.each(SortList,function(i,rowid){
			debug(i,"SortList-i")
			debug(rowid,"SortList-rowid")
			//var NeedChangeData=DataArry[i];
			var NeedChangeData=DataArry[rowid-1];
			debug(NeedChangeData,"NeedChangeData")
			SetRowData(id,rowid,NeedChangeData,"");
			EditRowCommon(id,rowid);
			EndEditRow(id, rowid)
			
			var isCheck = $("#jqg_"+id+"_" + rowid).prop("checked")
			console.log(isCheck + "-----------------" + rowid);
			
			/*if (isCheck) {
				$("#"+id).setSelection(rowid, false);
				NoSelectList.push(rowid)
			} else {
				SelectList.push(rowid)
			}*/

			
			if (!SelArcimIDs[NeedChangeData.OrderARCIMRowid])  {
				//$("#"+id).setSelection(rowid,false);
				NoSelectList.push(rowid)
			} else {
				//$("#"+id).setSelection(rowid,true);
				SelectList.push(rowid)
			}
			/*
			var Status=$("#jqg_"+id+"_" + rowid).prop("checked")
			if (type=="up"){
				//前几个是
				if (i<SelIds.length){
					if (!Status) $("#"+id).setSelection(rowid,true);
				}else{
					if (Status) $("#"+id).setSelection(rowid,false);
				}
			}else{
				if (i < NeedMoveRowids.length) {
					//alert(i + ": " +rowid+": "+ Status)
					//if (!Status) $("#"+id).setSelection(rowid,true);
					if (Status) $("#"+id).setSelection(rowid,false);
				}else{
					//alert(Status)
					//if (Status) $("#"+id).setSelection(rowid,false);
					if (!Status) $("#"+id).setSelection(rowid,true);
				}
			}
			*/
		
		})

		setTimeout(function () {
			debug(SelectList,"SelectList")
			debug(NoSelectList,"NoSelectList")
			for (var i=0;i<SelectList.length;i++) {
				var isCheck = $("#jqg_"+id+"_" + SelectList[i]).prop("checked")
				if (!isCheck) $("#"+id).setSelection(SelectList[i], true);
			}
			for (var i=0;i<NoSelectList.length;i++) {
				var isCheck = $("#jqg_"+id+"_" + NoSelectList[i]).prop("checked")
				if (isCheck) $("#"+id).setSelection(NoSelectList[i], false);
			}
		}, 10);
		
		//Save_Handler(0,1,id)

	}, 10);
	
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

function Link_Order_row (btnId,id) {
	var ids = $('#'+id).jqGrid("getGridParam", "selarrrow");
	var BtnText=$("#"+btnId+" .l-btn-text")[0].innerText;
    if (BtnText.indexOf($g('结束关联')) != -1){
       	if (!ClearSeqNohandler(id)) return false;
        PageLogicObj.IsStartOrdSeqLink=0;
        PageLogicObj.StartMasterOrdSeq="";
        $("#"+btnId+" .l-btn-text")[0].innerText=$g("开始关联");
    }else{
       	if (!SetSeqNohandler(id)) {
	        PageLogicObj.IsStartOrdSeqLink="";
	        return false;
	    }
        PageLogicObj.IsStartOrdSeqLink=1;
        $("#"+btnId+" .l-btn-text")[0].innerText=$g("结束关联");
    }
    
}

function Adj_Order_row (id) {
	if (!PageLogicObj.FocusRowIndex) {
		return false;	
	}
	var Height=$.trim($("#VS-Height").val());
	var Weight=$.trim($("#VS-Weight").val());
	var BSA=$.trim($("#BSA").val());
	var GFR=$.trim($("#GFR").val());
	var SC=$.trim($("#VS-SC").val());
	var IBW=$.trim($("#IBW").val());
	var BSAUnitSTD = GetCellData(id,PageLogicObj.FocusRowIndex,"BSAUnitSTD");
	var Formula = GetCellData(id,PageLogicObj.FocusRowIndex,"Formula");
	var PGIId=GetCellData(id,PageLogicObj.FocusRowIndex,"PGIId");
	var ArcimDR=GetCellData(id,PageLogicObj.FocusRowIndex,"OrderARCIMRowid");
	
	var VSData=Height+"^"+Weight+"^"+BSA+"^"+GFR+"^"+SC+"^"+BSAUnitSTD+"^"+Formula+"^"+IBW;
	if ((PGIId=="")||(ArcimDR=="")) {
		$.messager.alert("提示","新增的药品请先保存在进行调整！","warning")
		return false;
	}
	var isEdit = GetEditStatus(id,PageLogicObj.FocusRowIndex);
	
	if (isEdit) {
		if (Formula=="") {
			$.messager.alert("提示","请先选择计算公式！","warning")
			return false;
		}
	
		var URL = "chemo.bs.adjust.csp?VSData="+VSData+"&PGIId="+PGIId+"&ArcimDR="+ArcimDR;
		websys_showModal({
			url:URL,
			closable:true,
			iconCls: 'icon-w-edit',
			title:'调整比例',
			width:650,height:680,
			CallBackFunc:function (BSAUnit,FinalDose) {
				SetCellData(id,PageLogicObj.FocusRowIndex,"BSAUnit",BSAUnit)
				SetCellData(id,PageLogicObj.FocusRowIndex,"OrderDoseQty",FinalDose)
			}
		})
	} else {
		$.messager.alert("提示","先进入编辑状态，再进行调整！","warning")
		return false;
	}
	
}
function Add_ChgReason (id, Action, ArcimDR,MainDrug) {
	MainDrug = MainDrug||"N"
	var closable = false;
	if (MainDrug == "N") {
		//closable = true;
	}
	var TPGID = "";
	var PGID = "";
	var PIID = "";
	var PSID = PLObject.o_MObj.PSID;
	if (Action=="ADD") {
		var closable = true;
	}
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		ArcimDR = ArcimDR||"";
	var URL = "chemo.bs.chgreason.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&ArcimDR="+ArcimDR+"&PGID="+PGID+"&Action="+Action+"&TPGID="+TPGID+"&PSID="+PSID;
	
	websys_showModal({
		url:URL,
		closable:closable,
		iconCls: 'icon-w-add',
		title:'化疗药品变更原因',
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
	searchbox("s-content-hosp", {
		width: 228,
		searcher: function (text) {
			SearchHosp_Handler(text)
		}
		//,placeholder: "请输入描述回车查询"
	});
	searchbox("s-content-dep", {
		width: 228,
		searcher: function (text) {
			SearchDep_Handler()
		}
		//,placeholder: "请输入描述回车查询"
	});
	searchbox("s-content-user", {
		width: 228,
		searcher: function (text) {
			SearchUser_Handler()
		}
		//,placeholder: "请输入描述回车查询"
	});
	searchbox("s-content", {
		width: 278,
		searcher: function (text) {
			SearchPlan_Handler()
		}
		//,placeholder: "请输入描述回车查询"
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
	
	
	
	PLObject.m_AuditLoc = $HUI.combobox("#AuditLoc", {
		url:$URL+"?ClassName=DHCDoc.Chemo.BS.Ext.Audit&QueryName=AuditLoc&InHosp="+session['LOGON.HOSPID']+"&InLoc="+session['LOGON.CTLOCID']+"&ResultSetType=array",
		valueField:'id',
		textField:'text',
		//value:9,
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
		textField:'text',
		blurValidValue:true
	});
	
	PLObject.m_TreatType = $HUI.combobox("#treatTypeID", {
		url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryTreatType&ResultSetType=array",
		valueField:'id',
		//value:"Default",
		textField:'text',
		blurValidValue:true
	});
	
}

function InitDateBox (PSID,SelectDate3) {
	return false;
	var now = new Date(SelectDate3);
	var now1 = new Date(SelectDate3);
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
	var result = $m({
		ClassName:"DHCDoc.Chemo.BS.Apply",
		MethodName:"BuildGroupShow",
		TSID:TSID,
		InType:InType,
		SelectDate:SelectDate
	}, false);
	
	var _$dom = $(result);
	$("#i-center").empty();
	$("#i-center").append(_$dom);
	InitUI(ID);
	InitPara(TSID,InType)
	InitGrid(TSID,InType,SelectDate);
		
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
		$("#InRemark").text("【"+$g("当前")+"】")
	} else if (PLObject.v_Type == "DEP") {
		$("#InRemark").text("【"+$g("科室")+"】")
	} else if (PLObject.v_Type == "USER") {
		$("#InRemark").text("【"+$g("用户")+"】")
	} else if (PLObject.v_Type == "HOSP") {
		$("#InRemark").text("【"+$g("院区")+"】")
	} else if (PLObject.v_Type == "HIS") {
		$("#InRemark").text("【"+$g("历史")+"】")
	} else {
		$("#InRemark").text("")
	}
}

function setTreeNodeSelected(ID) {
	var tmpObj = {
		"dep-tree":"",
		"hosp-tree":"",
		"user-tree":"",
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
function InitTree(ID,InType,TMP) {	
	//,InUser,InDep,InHosp,InPatientID,InAdm
	ID=ID||"",
	InType=InType||"",
	TMP=TMP||"",
	InUser=session['LOGON.USERID'],
	InDep=session['LOGON.CTLOCID'],
	InHosp=session['LOGON.HOSPID'],
	InAdm=ServerObj.EpisodeID,
	InPatientID=ServerObj.PatientID;
	var 
		InExt = GetSearchContent(InType);
	
	//参数初始化
	if (InType=="CUR") { 
		InitGlobalPara();
	}
	
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
		},
		onSelect: function(node){
			InitCombox();
			//debug(node,"node",1)
			//参数初始化
			InitGlobalPara();
			var target = node.target
			var isLeaf = $(this).tree('isLeaf', node.target);
			if (isLeaf) {
				var TSID = node.id.split("-")[0];
				var TPID = TSID.split("||")[0];
				//alert(TSID)
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
					InitDateBox(TSID,SelectDate3);
				} else if (InType=="HIS") {
					var SP = "^";
					SelectDate = node.Ext.split(SP)[0];
					SelectDate3 = node.Ext.split(SP)[1];
					PLObject.v_SelectDate = SelectDate;
					
					PLObject.v_PLID=TPID;
					PLObject.v_PSID=TSID;
					PLObject.v_TSID = TSID;
					PLObject.v_TPID = TPID;
				} else {
					PLObject.v_TSID = TSID;
					PLObject.v_TPID = TPID;
				}
				
				//if (TMP!="TMP") {
					InitMainDrug(TSID,InType);
					//alert(11)
					InitGroupHtml(TPID,InStage,InType,ID,TSID,SelectDate);
					InitStageInfo(TSID,InType,SelectDate);
					//
					//alert(222)
					CreateNavBar(TSID,InType)
					LoadOverview("")
				//}
			} else {
				setTreeNodeSelected(ID);
				ButtonSetting("disable");
				return false;	
			}
		},
		onContextMenu:function (e, node) {
			if ((InType!="CUR")||(node.code=="Plan")) {
				e.preventDefault();
				return true;
			}
			e.preventDefault();
			// 选择节点
			$('#'+ID).tree('select', node.target);
			// 显示上下文菜单																										
			$('#mm').menu('show', {
				left: e.pageX,
				top: e.pageY
			});

			
		},
		onBeforeSelect: function (node) {
			if (InType!="CUR") {
		        var isLeaf = $(this).tree('isLeaf', node.target);
		        if (!isLeaf){
	                return false;
	            }
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
			//return
			if (InType=="CUR")  { 
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
					//console.log("---START----")
					if (PLObject.v_Target == "") {
						///console.log("空："+idCheck)
						$(this).tree("select", n.target);
					} else {
						//console.log(PLObject.v_Target)
						var selectNode = $(this).tree('find', PLObject.v_Target);
						//console.log(selectNode.target)
						$(this).tree('select', selectNode.target);
						//$(this).tree("select", PLObject.v_Target);
					}
					//console.log("---END----")
				}
			}
			
			
		}

	});
}

function InitMainDrug(TSID,InType) {
	var PSID = PLObject.v_PSID||"";
	if (TSID == "") {
		return;
	}
	$cm({
			ClassName: "DHCDoc.Chemo.BS.Apply",
			MethodName: "GetMainDrug",
			PSID: TSID,
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
	//debug(PLObject.v_Groups,"InitGrid")
	if (PLObject.v_Groups ==0 ) {
		return false;
	}
	
	var id = "GroupGrid";
	DrawGrid(id,TSID,InType,SelectDate);
	InitGroupEvent(id);
	
	
	
}

function DrawGrid (id,TSID,InType,SelectDate) {
	//debug(SelectDate,"SelectDate")
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
			postData:{TSID:TSID,InType:InType,SelectDate:SelectDate,PatientID:ServerObj.PatientID,EpisodeID:ServerObj.EpisodeID,SessionStr:SessionStr},
			editurl:'clientArray',
			//autowidth:true,
			autoheight:true,
			shrinkToFit: false,
			border:false,
			height:GridHeight,	//500
			autoScroll: false,
			mtype:'POST',
			emptyrecords:'没有数据',
			viewrecords:true,
			loadtext:'数据加载中...',
			multiselect:true,//多选
			multiboxonly:true,
			rowNum:false,
			//rowList:[10,20,30],
			loadonce:false, //请求一次数据  本地分页
			//pager:'#Order_DataGrid_pagbar',
			//onPaging:uppage,		
			viewrecords: true,
			//sortorder: "desc",
			//caption:"医嘱录入",
			rownumbers:false,
			loadui:'enable',//disable禁用ajax执行提示；enable默认，当执行ajax请求时的提示； block启用Loading提示，但是阻止其他操作
			loadError:function(xhr,status,error){
				alert("oeorder.oplistcustom.show.js-err:"+status+","+error);
				//xhr：XMLHttpRequest 对象；status：错误类型，字符串类型；error：exception对象
			},
			//userDataOnFooter:true,
			//userdata: {totalinvoice:240.00, tax:40.00}, //返回的额外信息
			colNames:ListConfigObj.colNames,			
			colModel:ListConfigObj.colModel,			
			//footerrow: true,//分页上添加一行，用于显示统计信息					
			jsonReader: {
                    page: "page",
                    total: "total",
                    records: "records",
                    root: "data",
                    repeatitems: false,
                    id: "id"
            },
			prmNames:{
				page:"page",//表示请求页码的参数名称
				rows:"rows",//表示请求行数的参数名称
				sort:"sidx",//表示用于排序的列名的参数名称
				order:"sord",//表示采用的排序方式的参数名称
				search:"_search",//表示是否是搜索请求的参数名称
				nd:"nd",//表示已经发送请求的次数的参数名称
				id:"id",//表示当在编辑数据模块中发送数据时，使用的id的名称
				oper:"oper",//operation参数名称（我暂时还没用到）
				editoper:"edit",//当在edit模式中提交数据时，操作的名称request.getParameter("oper") 得到edit
				addoper:"add",//当在add模式中提交数据时，操作的名称request.getParameter("oper") 得到add
				deloper:"del",//当在delete模式中提交数据时，操作的名称request.getParameter("oper") 得到del
				subgridid:"id",//当点击以载入数据到子表时，传递的数据名称
				npage:null,
				totalrows:"totalrows" //表示需从Server得到总共多少行数据的参数名称，参见jqGrid选项中的rowTotal
			},
			
			ondblClickRow:function(rowid,iRow,iCol,e){
				if (InType=="CUR") {
					dbClick(id,rowid);
				}
			},
			
			onCellSelect:function(rowid,iCol,cellcontent,e){
				//单元格模拟双击事件，弹出日期选择框
				//console.log(PLObject.v_ComDateNum+": "+iCol)
				/*if (InType=="CUR") {
					if ((iCol==6)&&(PLObject.v_ComDateNum<1)) {
						PLObject.v_ComDateNum=1;
						setTimeout(function () {
							ComDateClick();
						},500)
					}
				}*/
			},
			onClickRow:function(rowIndex, rowData){
				//已经被beforeSelectRow禁止行选择操作
			},
			
			onSelectRow:function(rowid,status){	
				if (InType=="CUR") {
					SelectContrl(id,rowid,status)
				}
				//dbClick(id,rowid);
			},
			beforeSelectRow:function(rowid, e){	
				//if (InType=="CUR") {
					if ($.isNumeric(rowid) == true) {
						PageLogicObj.FocusRowIndex=rowid;
					}else{
						PageLogicObj.FocusRowIndex=0;
					}
					//$(this).jqGrid('resetSelection');
					return true;//false 禁止选择行操作
				//}
			},
			onRightClickRow:function(rowid,iRow,iCol,e){
				
			},
			formatCell: function (rowid, cellname, value, iRow, iCol){         
			},
			gridComplete:function(){
					//TSID,GroupCode,InType
					//$("#"+id).setGridParam().hideCol("LinkSymbol");
					/*$m({
							ClassName: "DHCDoc.Chemo.COM.Func2",
							MethodName: "IsMainDrugGroup",
							PSID: TSID,
							GroupCode: GroupCode,
							InType: InType
						},function(result){
							if(result==0){
								$("#"+id).setGridParam().hideCol("BSAUnit");
							}
					});*/
	
				$("#"+id).setGridParam().hideCol("LinkSymbol");
				//$(this).jqGrid('setFrozenColumns');//设置冻结列生效
			},
			loadComplete:function(){
				//Add_Order_row(id);
			}
							
	});
	
}
var OrderMasterChangeHandler=OrderSeqNokeydownhandler =xItem_lookuphandler=OrderDoseQtykeydownhandler =OrdDoseQtyFocusHandler =PHCINDesc_lookuphandler =InstrChangeHandler =InstrFocusHandler =PHCFRDesc_lookuphandler =FrequencyChangeHandler =FrequencyFocusHandler =PHCDUDesc_lookuphandler =DurationChangeHandler =DurationFocusHandler =OrderFirstDayTimeskeypresshandler = OrderFirstDayTimeschangehandler=OrderFirstDayTimesFocusHandler=OrderPricechangehandler =OrderPackQtykeydownhandler =OrderPackQtychangehandler =OrderSkinTestChangehandler  =OrderLabSpecchangehandler =InitDatePicker =OrderDate_changehandler =OEORISttDatchangehandler =OrderBillTypechangehandler =keypressisnumhandler =OrderSpeedFlowRate_changehandler =OrderNeedPIVAFlagChangehandler =OrderLocalInfusionQty_changehandler =ExceedReasonChange =OrderDIACatchangehandler =OrderMaterialBarcode_Keypresshandler =OrderMaterialBarcode_changehandler =OrdCateGoryChange =OrderOperationchangehandler =OrderInsurchangehandler =OrderEndDate_changehandler =OrderBodyPartchangehandler=AntUseReasonchangehandler=OrderSelfOMFlagChangehandler =OrderMKLightShow=CellDataPropertyChange 
= OrderPackQtyFocusHandler =OrderDocchangehandler =OrderVirtualtLongClickhandler=OrderDoseQtychangehandler
=function () {}

//计算公式
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

//附加说明
function OrderPriorRemarkschangehandler (e) {
	var rowid = "";
	var obj = websys_getSrcElement(e);
	var parObj = $(obj).closest('table');
	if (parObj.length>0) {
		var id = parObj.attr("id");
		if (obj.id.indexOf("_") > 0) {
			rowid = obj.id.split("_")[0];
		}
		//
		SetCellData(id, rowid, "OrderPriorRemarksRowId", obj.value);
	}
}

//流速单位
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

//医嘱阶段
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

//皮试备注
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
//接收科室
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

//剂量单位
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
		//alert(obj.value)
		SetPackQty(id,rowid)
	}
	
}

//数量单位
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

//医嘱类型
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
	var PGIId = GetCellData(id,rowid,"PGIId");
	if (PGIId=="") {
		InitGroupTypeLookup(id,rowid);
	} else {
		$("#"+rowid+"_GroupType").attr("disabled","disabled")
		
	}
	$("#"+rowid+"_OrderMasterSeqNo").attr("disabled","disabled")
	var OrderMasterSeqNo = GetCellData(id,rowid,"OrderMasterSeqNo");
	if (OrderMasterSeqNo!="") {
		if (OrderMasterSeqNo.indexOf(".")>=1) {
			$("#"+rowid+"_OrderDur").attr("disabled","disabled")
			$("#"+rowid+"_OrderFreq").attr("disabled","disabled")
			$("#"+rowid+"_OrderInstr").attr("disabled","disabled")
		}
	} 
	
	
}
function InitGroupTypeLookup (id,rowid) {
	$("#"+rowid+"_GroupType").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'CTPCPDesc',
        columns:[[  
           {field:'desc',title:'描述',width:210,sortable:true},
           {field:'code',title:'编码',width:50,sortable:true}
        ]],
        width:150,
        pagination:true,
        panelWidth:300,
        panelHeight:300,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.Chemo.COM.Qry',QueryName: 'QryGroupType'},
        onBeforeLoad:function(param){
	        //var desc=param['q'];
			param = $.extend(param,{PSID:PLObject.v_PSID});
	    }
		,onSelect:function(ind,item){
		    /* var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			}); */
			GroupTypeLookUpSelect(id,rowid,item);
		}
		
    });

}
function InitOrderDurLookup(id,rowid){
	//$("#"+id + " input[name='OrderDur']").lookup({
	$("#"+rowid+"_OrderDur").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'CTPCPDesc',
        columns:[[  
           {field:'CTPCPDesc',title:'疗程',width:130,sortable:true},
           {field:'CTPCPCode',title:'编码',width:130,sortable:true}
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
	
	//$("#"+id + " input[name='OrderFreq']").lookup({
	$("#"+rowid+"_OrderFreq").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'Desc',
        columns:[[  
           {field:'Desc',title:'频次名称',width:130,sortable:true},
           {field:'Code',title:'频次编码',width:130,sortable:true}
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
	        param = $.extend(param,{desc:desc,PAAdmType:ServerObj.PAAdmType});
	    }
	    /*,queryParams:{ClassName: 'web.DHCDocOrderCommon',QueryName: 'LookUpFrequency'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
		    //var OrderPriorRowid=GetCellData(rowid, "OrderPriorRowid");
		    var OrderPriorRowid=GetCellData(id,rowid,"OrderPriorRowid")
		    var OrderARCIMRowid=GetCellData(id,rowid,"OrderARCIMRowid");
			param = $.extend(param,{desc:desc,PAAdmType:ServerObj.PAAdmType,UserID:session["LOGON.USERID"],OrderPriorRowid:OrderPriorRowid,OrderARCIMRowid:OrderARCIMRowid,LocID:session['LOGON.CTLOCID']});
	    }*/
	    ,onSelect:function(ind,item){
		    /* var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			}); */
			FrequencyLookUpSelect(id,rowid,item);
		}
    });
}

function InitOrderInstrLookup(id,rowid){
	//$("#"+id + " input[name='OrderInstr']").lookup({
	$("#"+rowid+"_OrderInstr").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'Desc',
        columns:[[  
           {field:'Desc',title:'用法名称',width:130,sortable:true},
           {field:'Code',title:'用法编码',width:130,sortable:true}
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
	        param = $.extend(param,{instrdesc:desc,paadmtype:ServerObj.PAAdmType});
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
        url: $URL,
        mode: 'remote',
        method: "Get",
        idField: 'HIDDEN',
        textField: 'ARCIMDesc',
        columns:[[
           {field:'ARCIMDesc',title:'医嘱名称',width:450,sortable:true},
           {field:'subcatdesc',title:'子类',width:100,sortable:true},
           {field:'ItemPrice',title:'价格',width:80,sortable:true},
           {field:'BasicDrugFlag',title:'基本药物',width:90,sortable:true},
           {field:'billuom',title:'计价单位',width:90,sortable:true},
           {field:'StockQty',title:'库存数',width:80,sortable:true},
           {field:'StockQtyNew',title:'库存数',width:80,sortable:true},
           {field:'InsurClass',title:'医保类别',width:90,sortable:true},
           {field:'GenericName',title:'通用名',width:120,sortable:true},
           {field:'ResQty',title:'在途数',width:80,sortable:true},
           {field:'DerFeeRules',title:'收费规定',width:90,sortable:true},
           {field:'PackedQty',title:'打包数',width:80,sortable:true},
           {field:'InsurSelfPay',title:'自付比例',width:90,sortable:true},
           {field:'Recloc',title:'接收科室',width:100,sortable:true},
           {field:'arcimcode',title:'代码',width:90,sortable:true}
        ]],
        pagination: true,
        rownumbers: true,
        panelWidth: 1000,
        panelHeight: 330,
        pageSize: 20,
        pageList: [20, 50, 100],
        isCombo: true,
        minQueryLen: 2,
        delay: '200',
        queryOnSameQueryString: true,
        queryParams: {
          ClassName: 'web.DHCDocOrderEntry',
          QueryName: 'LookUpItem'
        },
        onBeforeLoad:function(param){
          var desc = param['q'];
          if (desc == "") return false;
          var
            CurLogonDep = session['LOGON.CTLOCID'],
            GroupID = session['LOGON.GROUPID'],
            UserRowId = session["LOGON.USERID"],
            catID = "",
            subCatID = "",
            OrdCatGrp = "",
            LogonDep =  "",
            P5 = "",
            P9 = "",
            P10 = "",
            OrdCatGrp = "",
            OrderPriorRowid = "";
          param = $.extend(param, {
            Item: desc,
            GroupID: GroupID,
            Category: "",
            SubCategory: "",
            TYPE: P5,
            OrderDepRowId: LogonDep,
            OrderPriorRowId: OrderPriorRowid,
            EpisodeID: ServerObj.EpisodeID,
            BillingGrp: P9,
            BillingSubGrp: P10,
            UserRowId: UserRowId,
            OrdCatGrp: OrdCatGrp,
            NonFormulary: "",
            Form: CurLogonDep,
            Strength: "",
            Route: ""
          });
  	    },
        onSelect:function (ind,item) {
          var ItemArr=new Array();
          $.each(item, function(key, val) {
          ItemArr.push(val);
          });
          OrderItemLookupSelect(id,rowid,ItemArr);
		    },
        selectRowRender:function(row){
          var OrderMsg="";
          if ((row)&&(row['Recloc'])) {
          	var INCIItemLocked=row["INCIItemLocked"];
          	var CFNotAutoChangeRecloc=0	//GlobalObj.CFNotAutoChangeRecloc;
          	if ((row['Recloc'].split("/").length==1)&&(INCIItemLocked!="Y")&&(CFNotAutoChangeRecloc==1)){
          		OrderMsg=row['Recloc']+":"+row['StockQty'];
          	}else{
          		var OrderDepRowId= "";
          		//if ($("#FindByLogDep").checkbox("getValue")){
          		//	OrderDepRowId= session['LOGON.CTLOCID'];
          		//}
          		OrderMsg = tkMakeServerCall("web.DHCDocOrderCommon", "GetOrderStockMsg", GlobalObj.EpisodeID,row['HIDDEN'],row['Recloc'],OrderDepRowId);
          	}
          }
          var innerHTML="<div style='height:100px;background:#FFFFFF'>";
          innerHTML=innerHTML+"<div style='width:1000px;color:red;font-size:18px;'>";
          innerHTML=innerHTML+OrderMsg;
          innerHTML=innerHTML+"</div>";
          innerHTML=innerHTML+"</div>";
          return innerHTML;
          
    		}

    });
}

function InitOrderNameLookupOld(id,rowid){ 
	//$("#"+id + " input[name='OrderName']").lookup({
	$("#"+rowid+"_OrderName").lookup({
		//name="OrderName"
        url:$URL,
        mode:'remote',
        method:"Get",
       idField:'ArcimDR',
        textField:'ArcimDesc',
        columns:[[  
            {field:'ArcimDesc',title:'名称',width:320,sortable:true},
		   {field:'stock',title:'库存',width:80,sortable:true},
		   //{field:'factor',title:'厂家',width:300,sortable:true},
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
			var HospID=session['LOGON.HOSPID'];
	        if (desc=="") return false;
			param = $.extend(param,{arcimdesc:desc,EpisodeID:EpisodeID,HospId:HospID});
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
	//var NeedAddItemCongeriesObj=new Array();
	if (ItemArr[3]!="ARCIM") {
		$.messager.alert("提示","不能录入医嘱套！","warning")
		return false;
	}
	var OrdCongeriesJson = GetOrdCongeriesJson(ItemArr[1]);
	var BaseParamJson = GetBaseParamJson(rowid);
	var ItemOrdsJson=GetItemOrdsJson();
	var RowDataJson=GetRowDataJson();
	var UserOptionsJson=GetUserOptionsJson();
	
	var ItemCongeries = cspRunServerMethod(GlobalObj.GetItemCongeriesToListMethod, OrdCongeriesJson,BaseParamJson,ItemOrdsJson,RowDataJson,UserOptionsJson);
	var ItemCongeriesObj=eval("("+ItemCongeries+")");
	AddItemDataToRow(id,rowid,ItemCongeriesObj)        
								
}

function OrderItemLookupSelectOld(id,rowid,ItemArr) {
	
	//Combox_DoseUOM(id,rowid,ItemArr[1])
	SetCellData(id,rowid,"OrderARCIMRowid",ItemArr[1])
	SetDosageUom(id,PageLogicObj.FocusRowIndex,ItemArr[1]);
	SetQtyUom(id,PageLogicObj.FocusRowIndex,ItemArr[1]);
	SetRecLoc(id,PageLogicObj.FocusRowIndex,ItemArr[1]);
}

function GroupTypeLookUpSelect(id,rowid,item) {
    SetCellData(id, rowid, "GroupType", item["desc"])
	SetCellData(id, rowid, "GroupTypeId", item["id"]);
		
}

function DurationLookUpSelect(id,rowid,item) {
    SetCellData(id, rowid, "OrderDur", item["CTPCPDesc"])
	SetCellData(id, rowid, "OrderDurRowid", item["HIDDEN"]);
	SetPackQty(id,rowid)
	SyncGL(id, rowid,"OrderDur",item)
		
}

function FrequencyLookUpSelect(id,rowid,item) {
	SetCellData(id, rowid, "OrderFreq", item["Desc"]);
    //SetCellData(id, rowid, "OrderFreqFactor", OrderFreqFactor);
    //SetCellData(id, rowid, "OrderFreqInterval", OrderFreqInterval);
    SetCellData(id, rowid, "OrderFreqRowid", item["HIDDEN2"]);
    SetPackQty(id,rowid);
    //SetFocusCell(rowid, "OrderInstr");
    SyncGL(id, rowid,"OrderFreq",item)
    
}

function InstrLookUpSelect(id,rowid,item) {
	
	SetCellData(id, rowid, "OrderInstr", item["Desc"]);
	SetCellData(id, rowid, "OrderInstrRowid", item["HIDDEN"]);
	SyncGL(id, rowid,"OrderInstr",item)
	SetPackQty(id,rowid)
	SetFocusCell(rowid, "OrderFreq");
						
}

function SyncGL(id,rowid,colName,item) {
	//var records = $('#'+id).getGridParam("records");
	var records = GetAllRowId(id);
    var NeedAry = [];
    var EditMasterSeqNo = GetCellData(id,rowid, "OrderMasterSeqNo");
    if (EditMasterSeqNo.indexOf(".")>=0) {
		EditMasterSeqNo = EditMasterSeqNo.split(".")[0];
	}
    //debugger;
    //console.log("rowid: "+rowid+": "+EditMasterSeqNo)
    //console.log(records)
    for (var i=0;i<records.length;i++) {
	    if (records[i]==rowid) {
			continue;    
		}
		var OrderMasterSeqNo = GetCellData(id,records[i], "OrderMasterSeqNo");
		//console.log("OrderMasterSeqNo: "+OrderMasterSeqNo+": "+records[i])
		if (OrderMasterSeqNo=="") continue; 
		if (OrderMasterSeqNo.indexOf(".")>=0) {
			OrderMasterSeqNo = OrderMasterSeqNo.split(".")[0];
		}
		
		if (OrderMasterSeqNo == EditMasterSeqNo) {
			NeedAry.push(records[i])
			
		
			if (colName == "OrderInstr") {
				//console.log(records[i])
				//console.log(item["Desc"])
				SetCellData(id, records[i], "OrderInstr", item["Desc"]);
				SetCellData(id, records[i], "OrderInstrRowid", item["HIDDEN"]);
			}
			if (colName == "OrderFreq") {
				SetCellData(id, records[i], "OrderFreq", item["Desc"]);
			    SetCellData(id, records[i], "OrderFreqRowid", item["HIDDEN2"]);
			}
			if (colName == "OrderDur") {
				SetCellData(id, records[i], "OrderDur", item["CTPCPDesc"]);
			    SetCellData(id, records[i], "OrderDurRowid", item["HIDDEN"]);
			}
		}
	
	}	
}

function SetDosageUom (id,rowid,arcim,isEdit) {
	isEdit=isEdit||""
	$m({
		ClassName:"DHCDoc.Chemo.COM.Func",
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
	var OrderRecDepRowid = GetCellData(id,rowid,"OrderRecDepRowid");
	$m({
		ClassName:"DHCDoc.Chemo.COM.Func",
		MethodName:"GetQtyUom",
		ArcimRowid:arcim,
		AdmType:ServerObj.PAAdmType,
		RecDepRowid:OrderRecDepRowid
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
		ClassName:"DHCDoc.Chemo.COM.Func",	//DHCDoc.Chemo.COM.Func
		MethodName:"GetRecLoc",
		EpisodeID:ServerObj.EpisodeID,
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

function SelectContrl (id,rowid,status) {
	var btnId = "Link_btn"
	
	if ($.isNumeric(rowid) == false) { return rowid }
    var stutas = $("#jqg_"+id+"_" + rowid).prop("checked");
    var OrderMasterSeqNo = GetCellData(id,rowid, "OrderMasterSeqNo");
    var rowids = GetAllRowId(id);
    
    if (OrderMasterSeqNo != "") {
	    var OrderMasterFlag = 1;	//默认主医嘱
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
		            	$("#"+btnId+" .l-btn-text")[0].innerText=$g("结束关联");
		            }else{
			            $("#"+btnId+" .l-btn-text")[0].innerText=$g("开始关联");
			        }
		        
			    }
			    
		    } else {
			    //子医嘱时
			    if (MasterSeqNo.indexOf(".")>=0) {
				    MasterSeqNo = MasterSeqNo.split(".")[0];
				}
		    	
		    	if (MasterSeqNo == OrderMasterSeqNo) {
					if ($("#jqg_"+id+"_" + rowids[i]).prop("checked") != stutas) {
						$("#"+id).setSelection(rowids[i], false);
					}
	               	if (stutas){
		            	$("#"+btnId+" .l-btn-text")[0].innerText=$g("结束关联");
		            }else{
			            $("#"+btnId+" .l-btn-text")[0].innerText=$g("开始关联");
			        }
		        
			    }
			    
			    
			}
        }
			
	} else {
		$("#"+btnId+" .l-btn-text")[0].innerText=$g("开始关联");
	}
    
    
    
}
//设置过敏史
function InitGMis() {
	var PSHasGMis = $("#sensitiveTD").find("input[type='radio']:checked").val()||"";
	if (PSHasGMis=="1") {
		$m({
			ClassName: "DHCDoc.Chemo.COM.CallMethod",
			MethodName: "QueryAllergyInfoStr",
			PatientID: ServerObj.PatientID,
		},function(MObj){
			$("#GMisFill").val(MObj)
		});
	}
		
	
}

//设置诊断
function InitDiagnosis() {
	$m({
		ClassName: "DHCDoc.Chemo.COM.CallMethod",
		MethodName: "GetAllDiagnosis",
		admid: ServerObj.EpisodeID,
	},function(MObj){
		$("#Diagnosis").val(MObj)
	});
	
		
	
}

//设置界面默认值
function InitStageInfo(TSID,InType,SelectDate) {
	SelectDate = SelectDate||"";
	
	var ConfigStr = $cm({
		ClassName:"DHCDoc.Chemo.COM.Func",
		MethodName:"GetClassPropertyList",
		Name:"DHCDoc.Chemo.Model.PlanInfo",
		ClsFlag:0,
		dataType:"text"
	},false);
	
	var ConfigAry = ConfigStr.split("^")
	var SessionStr=GetSessionStr();
	
	$cm({
		ClassName: "DHCDoc.Chemo.Model.PlanInfo",
		MethodName: "GetInfo",
		TSID: TSID,
		InType: InType,
		SelectDate:SelectDate,
		PatientID: ServerObj.PatientID,
		EpisodeID: ServerObj.EpisodeID,
		PAAdmType: ServerObj.PAAdmType,
		SessionStr:SessionStr
	},function(MObj){
		//debug(MObj,"MObj",1)
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
				$("#Save").linkbutton('disable');
				//$("#Send").linkbutton('enable');
				$("#Submit").linkbutton('disable');
				$("#Formula").linkbutton('enable');
				$("#Stop").linkbutton('disable');
				$("#Cancel").linkbutton('disable');
				$("#Find").linkbutton('enable');
				//$("#GMisOK").linkbutton('disable');
				$("#AdjPlanDate").linkbutton('enable');
				$("#OkPlan").linkbutton('enable');
				$("#AdjDetail").linkbutton('enable');	
			} else {
				$("#Save").linkbutton('enable');
				//$("#Send").linkbutton('enable');
				$("#Submit").linkbutton('enable');
				$("#Formula").linkbutton('enable');
				$("#Stop").linkbutton('enable');
				$("#Cancel").linkbutton('enable');
				$("#Find").linkbutton('enable');
				//$("#GMisOK").linkbutton('enable');
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
			$("#Cancel").linkbutton('disable');
			//$("#GMisOK").linkbutton('disable');
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
			$("#Cancel").linkbutton('disable');
			//$("#GMisOK").linkbutton('disable');
			$("#AdjPlanDate").linkbutton('disable');
			$("#OkPlan").linkbutton('disable');	
			$("#AdjDetail").linkbutton('disable');	
		}
		
	}
	/*
	//疑难病例权限控制
	if (PLObject.j_IsDiffcultBL!="") {	
		if (PLObject.j_BLChemoAuth=="N") {
			ButtonSetting("disable");
		}
	} else {
		//普通病历	
		if (PLObject.j_ChemoAuth == "N") {
			ButtonSetting("disable");
		} 
	}
	*/
	//alert(PLObject.j_Global.DischConfirmed)
	if (PLObject.j_Global.DischConfirmed=="Y") {
		ButtonSetting("disable");
	} else if (PLObject.j_Global.LimitTime!=0) {
		ButtonSetting("disable");
	} else {}
	
	if (MObj.IsSelfUser!=1) {
		ButtonSetting("disable");
	}
}

function ButtonSetting (ac) {
	$("#SaveAll").linkbutton(ac);
	$("#Save").linkbutton(ac);
	$("#Formula").linkbutton(ac);
	$("#Find").linkbutton(ac);
	$("#Send").linkbutton(ac);
	$("#Submit").linkbutton(ac);
	$("#Stop").linkbutton(ac);
	$("#Cancel").linkbutton(ac);
	//$("#GMisOK").linkbutton(ac);
	$("#AdjPlanDate").linkbutton(ac);
	$("#OkPlan").linkbutton(ac);
	$("#ApplyList").linkbutton(ac);
	$("#AdjDetail").linkbutton(ac);
	$("#ApplyList").linkbutton(ac);
	$("#BackBtn").linkbutton(ac);
	$("#PrintBtn").linkbutton(ac);
	
	
	
	
}
function SetPlanInfo (MObj,InType) {
	//
	PLObject.o_MObj = MObj;
	$("#PLID").val(MObj.PLID);
	PLObject.v_TotalStage = MObj.PLTotalStage;
	//$("#tip-1").text("every 21 days for "+ MObj.PLTotalStage +"  cycles");
	//$("#tip-2").text("每21天为一周期，连续用药"+MObj.PLTotalStage+"个周期");
		
	$("#tip-3").html(MObj.ChemoTitle)	
	//$("#tip-3").text(MObj.ChemoTitle)
	//
	if ((PLObject.v_Type =="CUR")||((PLObject.v_Type =="HIS"))) {
		$("#tpname").attr("disabled","disabled")
	} else {
		$("#tpname").removeAttr("disabled")
	}
	SetButton(MObj)
	var ExamNote="1）血常规：粒细胞计数：1.5×109，血小板：80×109，血红蛋白：90g/L \n"+
			"2）其他检查：转氨酶<2倍正常值上限，肾小球滤过率>60%。\n"+
			"3）心电图无特殊的禁忌。\n"+
			"4）心脏彩超EF>50%。";
		ExamNote = "";
		
	{
		
		if (MObj.IsEditDay1==1) {	//所选日期为当天
			$("#otherDate").datebox("enable");
			//$("#nexday").datebox("enable");
			$("#AdjPlanDate").linkbutton('enable');
		} else {
			$("#otherDate").datebox("disable");
			//$("#nexday").datebox("disable");
			$("#AdjPlanDate").linkbutton('disable');
		}
	}
	//公共赋值
	{
		$("#LabExamNote").val(ExamNote)
		$("#Diagnosis").val(MObj.PSDiagnosis)
		$("#admDoc").val(MObj.PDAdmDoc)
		//生命体征信息
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
		var GFR = CalcGFR(MObj.Age,MObj.Weight,MObj.SC,MObj.Sex);
		if (!isNaN(IBW)) $("#IBW").val(IBW);
		if (!isNaN(BSA)) $("#BSA").val(BSA);
		if (!isNaN(GFR)) $("#GFR").val(GFR);
		$("#treatTD").find("input").radio('uncheck');
		PLObject.m_TreatType.clear();
		$("#agreeFormTD").find("input[type='radio']").radio('uncheck');
		$("#sensitiveTD").find("input[type='radio']:checked").radio('uncheck');
		$("#ontimeTD").find("input[type='radio']").radio('uncheck');
		if (MObj.PSHasGMis!="") {
			$("#sensitiveTD").find("input[value='"+ MObj.PSHasGMis +"']").radio('check');
		}
		$("#GMisFill").val(MObj.GMisFill)
		
	}
	
	if ((InType == "CUR")||(InType == "HIS")) {
		$("#tpname").val(MObj.PLName);
		$("#tpstage").val(MObj.PSStage);
		$("#curPlanDate").val(MObj.PSDate);
		$("#otherDate").datebox("setValue",MObj.PSDate)
		$("#stageEffect").val(MObj.PSEffect)
		//$("#nexday").datebox("setValue",MObj.PSNextDate);
		PLObject.v_NextDay = MObj.PSNextDate;
		$("#day").val("Day"+MObj.PSDay)
		//if (MObj.PSGMisOK==1) $("#GMisOK_New").checkbox("check")
		//else $("#GMisOK_New").checkbox("uncheck")
		//MObj.PSDay
		//$("#tip-1").text("On Day "+1+" ，every 21 days for "+ MObj.PLTotalStage +"  cycles");
		//$("#tip-2").text("第"+1+"天用药，每21天为一周期，连续用药"+MObj.PLTotalStage+"个周期");
	
		if (MObj.PSTreatType!="") {
			PLObject.m_TreatType.setValue(MObj.PSTreatType)
		}
		if (MObj.PSTreatTypeNew!="") {
			$("#treatTD").find("input[value='"+ MObj.PSTreatTypeNew +"']").radio('check');
		}
		if (MObj.PSAgreeForm!="") {
			$("#agreeFormTD").find("input[value='"+ MObj.PSAgreeForm +"']").radio('check');
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
		$("#OhterFill").val(MObj.OtherFill)
		$("#PDStatus").val(MObj.PDStatus)
		PLObject.m_AuditDoc.setValue(MObj.PDNeedUser)
		if (MObj.PDNeedLoc!="") {
			PLObject.m_AuditLoc.setValue(MObj.PDNeedLoc)
		}
		PLObject.m_AuditDoc.enable();
		PLObject.m_AuditLoc.enable();
		$("#palnTime").val(MObj.PDPlanTime)
		
		if ((PLObject.o_MObj.PDStatus=="N")||(PLObject.o_MObj.PDStatus=="")) {
			PLObject.m_AuditDoc.enable();
			PLObject.m_AuditLoc.enable();
		} else {
			PLObject.m_AuditDoc.disable();
			PLObject.m_AuditLoc.disable();
		}
		
	} else {
		$("#tpname").val(MObj.TPName);
		$("#tpstage").val(MObj.TSStage);
		PLObject.m_AuditDoc.setValue("")
		PLObject.m_AuditLoc.setValue("")
		PLObject.m_AuditDoc.disable();
		PLObject.m_AuditLoc.disable();
		$("#delayReason,#palnTime,#OhterFill,#planNote,#stageEffect").val("")
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

function checkTPL () {
	var msg="";
	var gridData = GetGirdData("GroupGrid");
	for (var k=0; k < gridData.length; k++) {
		var PGIPriorDR = gridData[k].OrderPriorRowid,
			GroupType = gridData[k].GroupType,
			GroupTypeId = gridData[k].GroupTypeId,
			
			HospDose = gridData[k].HospDose,
			PGIDosage = gridData[k].OrderDoseQty,
			PGIQty = gridData[k].OrderPackQty;
		
		if (PLObject.v_Type != "CUR") {
			if (PGIPriorDR == "") {
				msg="该模板医嘱类型为空，请检查模板！"
				break;
			}
		} else {
			if (GroupTypeId == "") {
				msg="化疗组类型不能为空！"
				break;
			}
		}
		if (PGIDosage!="") {
			if (!isNumber(PGIDosage)) {
				msg="请输入正确的单次剂量！"
				break;
			}
		}
		if (PGIQty!="") {
			if (!isNumber(PGIQty)) {
				msg="请输入正确的数量！"
				break;
			}
		}
		if (HospDose!="") {
			if (!isNumber(HospDose)) {
				msg="请输入正确的外院剂量！"
				break;
			}
		}
		
	}
	if (msg!="") {
		$.messager.alert("提示",msg,"warning")
		return false;
	}
	return true;
}

function checkData (buttonType) {
	//return true;
	buttonType = buttonType||"";
	//console.log(PLObject)
	if (PLObject.v_Groups == 0) {
		$.messager.alert("提示","请先选择周期！","warning")
		return false;
	}
	
	if (PLObject.v_Type != "CUR") {
		
		if (PLObject.v_C_TPID != "" ) {
			if (PLObject.v_C_TPID != PLObject.v_TPID ) {
				$.messager.alert("提示","不同模板不能保存！","warning")
				return false;
			}
		}
	
		if (PLObject.v_C_StageS!="") {
			if (PLObject.v_C_StageS.indexOf(PLObject.v_Stage) >= 0 ) {
				$.messager.alert("提示","该模板阶段已经保存！","warning")
				return false;
			}
		}
	}
	
	var PLName = $.trim($("#tpname").val());
	
	if (PLName=="") {
		$.messager.alert("提示","化疗方案不能为空！","warning")
		return false;
	}
	//必填项控制
	var Diagnosis = $.trim($("#Diagnosis").val());
	var CancerStage = $.trim($("#CancerStage").val());
	var PSAgreeForm = $("#agreeFormTD").find("input[type='radio']:checked").val()||"";
	var PSTreatType = PLObject.m_TreatType.getValue()||"";
	var PSTreatTypeNew = $("#treatTD").find("input[type='radio']:checked").val()||"";
	var ONTime = $("#ontimeTD").find("input[type='radio']:checked").val()||"";
	var delayReason = $.trim($("#delayReason").val());
	var OhterFill = $.trim($("#OhterFill").val());
	//if (Diagnosis="") {
	if (Diagnosis=="") {
		if (PLObject.j_Global.OrderLimit != 1) {
			$.messager.alert("提示","没有诊断,请先录入!","info",function(){
				websys_showModal({
					url:"diagnosentry.v8.csp?PatientID=" + ServerObj.PatientID + "&EpisodeID=" + ServerObj.EpisodeID + "&mradm=" + ServerObj.MRAdm,
					title:'诊断录入',
					width:((top.screen.width - 100)),height:(top.screen.height - 120)
					,onClose:function(){
						//InitStageInfo(PLObject.v_PSID,PLObject.v_Type,PLObject.v_SelectDate);
						InitDiagnosis();
					}
				})
	    	})
	    	
			return false;
		}
	}
		
	if (PLObject.v_Type == "CUR") {
		if (ONTime=="") {
			$.messager.alert("提示","按时或推迟不能为空！","warning")
			return false;
		}
		if (ONTime==2) {
			if (delayReason=="") {
				$.messager.alert("提示","推迟化疗原因不能为空！","warning")
				return false;
			}
		}
		if (PSAgreeForm=="") {
			$.messager.alert("提示","知情同意书不能为空！","warning")
			return false;
		}
	
		if (CancerStage=="") {
			//$.messager.alert("提示","癌症分期不能为空！","warning")
			//return false;
		}
		if (PSTreatTypeNew=="") {
			$.messager.alert("提示","治疗类别不能为空！","warning")
			return false;
		} else {
			if ((PSTreatTypeNew=="5")&&(OhterFill=="")) {
				$.messager.alert("提示","请输入其他！","warning",function () {
					$("#OhterFill").focus()	
				})
				return false;
			}
		}
	}
	/*
	var auditLoc = PLObject.m_AuditLoc.getValue()||"";
	var auditDoc = PLObject.m_AuditDoc.getValue()||"";
	
	if (PLObject.v_Type == "CUR") {	
		if (auditLoc=="") {
			$.messager.alert("提示","审核科室不能为空！","warning")
			return false;
		}
		if (auditDoc=="") {
			$.messager.alert("提示","审核医生不能为空！","warning")
			return false;
		}
	}*/
	
	var PSHasGMis = $("#sensitiveTD").find("input[type='radio']:checked").val();
	var GMisFill = $.trim($("#GMisFill").val());
	if (PSHasGMis==1) {
		if (GMisFill=="") {
			$.messager.alert("提示","请填写过敏史记录！","warning",function () {
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
				$.messager.alert("提示","申请信息已经发送！","warning")
				return false;
			}
	
		}
		if (auditLoc=="") {
			$.messager.alert("提示","审核科室不能为空！","warning")
			return false;
		}
		if (auditDoc=="") {
			$.messager.alert("提示","审核医生不能为空！","warning")
			return false;
		}
		
	}
	var msg=""

	var GroupAry = [],
		GroupInfo = "",
		id = "GroupGrid";
	var gridData = GetGirdData(id);
	
	if (PLObject.v_Type == "CUR") {
		if (gridData.length == 0) {
			msg="没有化疗用药，请检查！"
		} 
		for (var k=0; k < gridData.length; k++) {
			var ItemAry=[],
				HDItem = "",
				HDID = gridData[k].HDID,
				HospDose = gridData[k].HospDose,
				HDUomDR = 1,	//先默认，后续扩展之后在改动
				ItemID=gridData[k].PGIId,
				PGIArcimDR = gridData[k].OrderARCIMRowid||"",
				OrderName = gridData[k].OrderName||"",
				PGIDosage = gridData[k].OrderDoseQty,
				PGIDosageUomDR = gridData[k].OrderDoseUOMRowid,
				OrderFreq = gridData[k].OrderFreq,
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
				GFR = $.trim($("#GFR").val()),
				GroupType = gridData[k].GroupType,
				GroupTypeId = gridData[k].GroupTypeId;
			var ExpStr=ServerObj.EpisodeID+"^"+session['LOGON.CTLOCID']+"^0"
			
			if (GroupType.indexOf("其他医嘱")<0) {
				if (GroupTypeId == "") {
					msg="化疗组类型不能为空！"
					break;
				}
				
				if (OrderFreq == "") {
					msg="频次不能为空！"
					break;
				}
				//alert(GroupType)
				if (GroupType.indexOf("PRN")>=0) {
					//alert(OrderFreq.toUpperCase())
					if (OrderFreq.toUpperCase().indexOf("PRN")<0) {
						//msg="【"+OrderName+"】频次不为Prn！"
						msg="RPN用药的频次不为Prn！"
						break;
					}
				}
				if (PGIDosage == "") {
					msg="单次剂量不能为空！"
					break;
				}
				
				if (PGIInstruc == "") {
					msg="用法不能为空！"
					break;
				}
				if (PGIPriorDR == "") {
					msg="医嘱类型不能为空！"
					break;
				}
				if (PGIDuratDR == "") {
					msg="疗程不能为空！"
					break;
				}
				if ((PGIQty == "")&&(ServerObj.PAAdmType!="I")) {
					msg="数量不能为空！"
					break;
				}
				if (PGIUomDR == "") {
					msg="数量单位不能为空！"
					break;
				}
				
				//判断库存
				/*var CheckStockEnough = $cm({
					ClassName:"DHCDoc.Chemo.COM.CallMethod",
					MethodName:"CheckStockEnough",
					arcim:PGIArcimDR,
					Qty:PGIQty,
					RecLoc:PGIRecLoc,
					Remark:PGIRemark,
					EpisodeID:ServerObj.EpisodeID,
					ExpStr:ExpStr,
					dataType:"text"
				},false);
				
				if (CheckStockEnough.split("^")[0]==0){
					msg=OrderName+gridData[k].OrderRecDep+"库存不足！"
					break;
					}*/
					
			}
		}
	}	
	
	if (msg!="") {
		$.messager.alert("提示",msg,"warning")
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
	var ONTime = $("#ontimeTD").find("input[type='radio']:checked").val()||"";
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
	var DataSR = ""	//$.trim($("#VS-Data").val());
	var BSA = $.trim($("#BSA").val());
	var GFR = $.trim($("#GFR").val());
	var SC = $.trim($("#VS-SC").val());
	var GMisFill = $.trim($("#GMisFill").val());
	var PDExamNote = $.trim($("#LabExamNote").val());
	var PDPlanTime = $.trim($("#palnTime").val());
	var UpdateLoc = session['LOGON.CTLOCID'];
	var UpdateDoc = session['LOGON.USERID'];
	var auditLoc = ""	//PLObject.m_AuditLoc.getValue()||"";
	var auditDoc = ""	//PLObject.m_AuditDoc.getValue()||"";
	var HasGMis = $("#sensitiveTD").find("input[type='radio']:checked").val()||"";
	
	PDAry.push(PDID,PLID,PSID,PatientDR,Adm,PDDate,ONTime,DelayReason,ToDate,Height,Weight,Temperature,Blood,Pulse,Oxygen,ECOG,KQScore,DataSR,BSA,GFR,SC,GMisFill,PDExamNote,PDPlanTime,UpdateLoc,UpdateDoc,auditLoc,auditDoc,HasGMis);
	
	
	
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
	//方案状态：Y(有效)、N(未生效)、S(停止)
	var PLStatus="Y"	//默认申请有效
	var PLExamNote = $.trim($("#LabExamNote").val())
	
	PLAry.push(PLID,PLName,PLPatientDR,PLTemplateDR,PLOrderDep,PLOrderUser,PLAdmDR,PLNote,PLStatus,PLExamNote);
	
	return PLAry;
}

function GetPSAry () {
	var PSAry = [];
	var PSID = PLObject.v_PSID||"";
	var PSStage = PLObject.v_Stage;
	var PSAgreeForm = $("#agreeFormTD").find("input[type='radio']:checked").val()||"";
	var PSHasGMis = $("#sensitiveTD").find("input[type='radio']:checked").val()||"";
	var PSTreatType = PLObject.m_TreatType.getValue()||"";
	var PSEffect = $.trim($("#stageEffect").val());
	var PSTplStage = PLObject.v_TSID||"";
	var CancerStage = $.trim($("#CancerStage").val());
	var PSSC = $.trim($("#VS-SC").val());
	var GMisFill = $.trim($("#GMisFill").val());
	var OhterFill = $.trim($("#OhterFill").val());
	var PSPlanTime = $.trim($("#palnTime").val());
	var ONTime = $("#ontimeTD").find("input[type='radio']:checked").val()||"";
	var DelayReason = $.trim($("#delayReason").val());
	var PSTreatTypeNew = $("#treatTD").find("input[type='radio']:checked").val()||"";
	
	PSAry.push(PSID,PSStage,PSAgreeForm,PSHasGMis,PSTreatType,PSEffect,PSTplStage,CancerStage,PSSC,GMisFill,OhterFill,PSPlanTime,ONTime,DelayReason,PSTreatTypeNew);
	
	return PSAry;
}


function GetPGAry (HDAry) {
	
	var PGAry = [],
		GroupInfo = "",
		id = "GroupGrid";
		
	var gridData = GetGirdData(id),
		gridDataObj = {};
	
	//按组整理数据
	for (var k=0; k < gridData.length; k++) {
		var 
			PGIArcimDR = gridData[k].OrderARCIMRowid||"",
			GroupTypeId = gridData[k].GroupTypeId;
			
		if ((PGIArcimDR == "")||(GroupTypeId == "")) {
			continue;
		}
		
		if(gridDataObj[GroupTypeId]) {
			gridDataObj[GroupTypeId].push(gridData[k]);
		} else {
			gridDataObj[GroupTypeId] = [];
			gridDataObj[GroupTypeId].push(gridData[k]);
		}
	}
	//debug(gridDataObj,"gridDataObj")
	//组织保存数据
	for (var key  in gridDataObj) {
        var GroupType = key,
			gridData = gridDataObj[key],
			ItemStr = "";
		var GroupAry = [];
		var PGID = "";
		var PGCode = "";
		var PGDesc = GroupType;
		var PGPlanDate = "";
		var PGNote = "";
		var PGTplGrop = "";
		var MainDrug = "";
		//组状态：Y(有效)、N(作废)、S(停止)
		var PGStatus = "Y"	//默认有效
		GroupAry.push(PGID,PGCode,PGPlanDate,PGNote,PGTplGrop,PGStatus,MainDrug,PGDesc);
		//console.log(PGDesc)
		GroupInfo = GroupAry.join(String.fromCharCode(1));
		debug(GroupAry,"GroupAry")
		debug(GroupInfo,"GroupInfo")
		for (var k=0; k < gridData.length; k++) {
			var ItemAry=[],
				HDItem = "",
				HDID = gridData[k].HDID,
				HospDose = gridData[k].HospDose,
				HDUomDR = 1,	//先默认，后续扩展之后在改动
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
				PGIRemark = gridData[k].OrderPriorRemarksRowId,
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
				GFR = $.trim($("#GFR").val()),
				Seqno = gridData[k].id,
				//GroupTypeId = gridData[k].GroupTypeId,
				MainDrug = gridData[k].MainDrug,
				ChemoDays = gridData[k].ChemoDays,
				BSAUnitSTD = gridData[k].BSAUnitSTD;
				
			ItemAry.push(ItemID,PGIArcimDR,PGIDosage,PGIDosageUomDR,PGIFreqDR,PGIInstruc,PGIDuratDR,PGIQty,PGIUomDR,PGILinkItem,PGINote,PGIPriorDR,PGISimpleDR,PGIRemark,PGIRecLoc,PGIStage,PGIFlowRate,PGIFlowRateDR,PGISkinTest,PGISkinAction,PGITplGroupItem,BSAUnit,BSA,Formula,GFR,Seqno,MainDrug,ChemoDays,BSAUnitSTD);
			
			HDItem = HDID +  String.fromCharCode(1) + ServerObj.PatientID + String.fromCharCode(1) + ServerObj.EpisodeID + String.fromCharCode(1) + PGIArcimDR + String.fromCharCode(1) + HospDose + String.fromCharCode(1) + HDUomDR;
			
			HDAry.push(HDItem);
			
			var ItemInfo = ItemAry.join(String.fromCharCode(1));
			if (ItemStr == "") {
				ItemStr = ItemInfo;
			} else {
				ItemStr = ItemStr + String.fromCharCode(3) + ItemInfo
			}
			
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
		$.messager.alert("提示","删除失败！","warning");
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
				$.messager.alert("提示","发送成功！","success");
				InitTree("cur-tree","CUR");
				return true;
			}else{
				$.messager.alert("提示","保存失败！错误代码："+result,"warning");
				return false;
			}
	});
}

function SaveAll_Handler () {
	Save_Handler (1)
}

function Save_Handler (AllFlag,SortFlag,id) {
	if (PLObject.v_Type=="") {
		$.messager.alert("提示","请先选择方案！","warning");
		return false;
	}
	
	AllFlag = AllFlag||0,
	SortFlag = SortFlag||0,
	id = id||"GroupGrid";
	var chkResult = checkTPL();
	if (!chkResult) {
		return false;
	}
	var PLName = $.trim($("#tpname").val());
	
	if (PLName=="") {
		$.messager.alert("提示","化疗方案名称不能为空！","warning")
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
	
	//console.log(PGAry)
	//return false;
	
	if (ServerObj.PAAdmType == "IO") {
		var PlanDate = $("#otherDate").val();
	} else {
		//var PlanDate = $("#curPlanDate").val();
		var PlanDate = $("#otherDate").datebox("getValue")||"";
	}
	if (PLObject.v_Type=="CUR") {
		if (PlanDate=="") {
			$.messager.alert("提示","请选择化疗日期！","warning");
			return false;
		}
	}
	
	$cm({
			ClassName: "DHCDoc.Chemo.BS.Plan",
			MethodName: "Save",
			InType:PLObject.v_Type,
			SelectDate:PLObject.v_SelectDate,
			PLAry: PLAry,
			PSAry: PSAry,
			PGAry: PGAry,
			HDAry: HDAry,
			PDAry: PDAry,
			ExtPara:0+"^"+ServerObj.PAAdmType+"^"+PlanDate+"^"+AllFlag
		},function(result){
			if(result==1){
				//$.messager.alert("提示","保存成功！","success");
				if (SortFlag==0) {
					$.messager.popover({
						msg: '暂存成功！',
						type:'success',
						style:{
							bottom:-document.body.scrollTop - document.documentElement.scrollTop+10, //显示到右下角
							right:10
						}
					});
					if (PLObject.v_Type!="CUR") {
						InitTree("cur-tree","CUR");
					
					} else {
						//
						InitTree("cur-tree","CUR","TMP");	
					}
					if (PLObject.v_Target != "") {
						//$("#cur-tree").tree(select, PLObject.v_Target);
					}
				} else {
					$("#"+id).trigger("reloadGrid");
				}
				return true;
			}else{
				$.messager.alert("提示","暂存失败！","warning");
				return false;
			}
	});
	
	
}

function MainDrugBt_Handler () {
	if (PLObject.v_Type!="CUR") {
		return false;	
	}
	var URL = "chemo.bs.maindrug.csp?PSID="+PLObject.v_PSID+"&InType="+PLObject.v_Type
		websys_showModal({
			url:URL,
			closable:true,
			iconCls: 'icon-w-edit',
			title:'主药信息',
			width:650,height:500,
			CallBackFunc:function () {
				InitMainDrug(PLObject.v_PSID,PLObject.v_Type);
			}
		})
}

function BackBtn_Handler () {
	
	if (PLObject.v_Type != "CUR") {
		if (PLObject.v_Type=="") {
			$.messager.alert("提示","请选择化疗方案！","warning");
			return false;
		}
	}
	
	
	$.messager.confirm("提示", "你确认要撤销么？",function (r) {
		if (r) {
			$m({
					ClassName: "DHCDoc.Chemo.BS.Ext.Plan",
					MethodName: "CancelChemoPlanNew",
					SelectDate:PLObject.v_SelectDate,
					PSID:PLObject.v_PSID,
					//PDAID:PDAID,
					//LinkPDAID:LinkPDAID,
					UserID: session['LOGON.USERID'],
					InLoc: session['LOGON.CTLOCID'],
					type:"text"
				},function(result){
					var resultArr = result.split("^")
					if(resultArr[0]==0){
						$.messager.alert("提示",resultArr[1],"warning");
						if (PLObject.v_Type!="CUR") {
							InitTree("cur-tree","CUR");
						
						} else {
							//
							InitTree("cur-tree","CUR","TMP");	
						}
				
						//findConfig();
						return false;
					}else{
						$.messager.alert("提示",resultArr[1],"warning");
						return false;
					}
			});
			
		}
		
	});
		
}
function PrintBtn_Handler () {
	if (PLObject.v_Type != "CUR") {
		if (PLObject.v_Type=="") {
			$.messager.alert("提示","请选择化疗方案！","warning");
			return false;
		}
	}
	
	/*
	var LocId = session['LOGON.CTLOCID'];
	var FindDate = PageLogicObj.m_SaveDate;
	var UserId = session['LOGON.USERID'];
	var FindPatWorkType = PageLogicObj.m_Type.getValue()||"";
	var FindPatNo = $.trim($("#i-patno").val());
	var selfLocFlag = $("#i-selfLoc").hasClass("selected");
	if (selfLocFlag) {
		UserId = "";
	}
	var BCType = GetBCType();
	if (BCType == "") {
		$.messager.alert('提示','请选择班次！' , "info");
		return false;
	}
	var FindBCType = BCType;
	var FindWard = PageLogicObj.m_ward.getValue()||"";
	var PrevFlag = $("#i-prevBC").switchbox("getValue")?0:1;
	
	var hasSave = $.cm({ 
		ClassName:"web.DHCDocPassWorkF1",
		MethodName:"HasSave", 
		dataType:"text",
		LocId:LocId,
		FindDate:FindDate,
		BCode:FindBCType
	},false);
	
	if (hasSave==0) {
		$.messager.alert('提示','请先保存班次信息！' , "info");
		return false;
	}
	
	var param = "LocId="+LocId+"&FindDate="+FindDate+"&UserId="+UserId+"&FindPatWorkType="+FindPatWorkType;
	param = param +"&FindPatNo="+FindPatNo+"&FindBCType="+FindBCType+"&FindWard="+FindWard+"&PrevFlag="+PrevFlag;
	*/
	var SessionStr=GetSessionStr()
	var param = "PSID="+PLObject.v_PSID+"&EpisodeID="+ServerObj.EpisodeID+"&PatientID="+ServerObj.PatientID+"&SelectDate="+PLObject.v_SelectDate+"&SessionStr="+SessionStr
	
	//alert(param)
	//websys_printview("DHCPassWork","isLodop=1&showPrintBtn=1&"+param,"width=830,height=660,top=20,left=100");
	websys_printout("DHCChemoPrint","isLodop=1&showPrintBtn=1&"+param,"width=830,height=660,top=20,left=100");
	
}

function NodeCopy_Handler () {
	var selected = $("#cur-tree").tree("getSelected");
	
	//debug(selected,"selected")
	if (selected.code == "Day") {
		$.messager.confirm("提示", "您确认复制天数么？",function (r) {
			if (r) {
				var URL = "chemo.bs.copyday.csp?PSID="+PLObject.v_PSID+"&CopyDate="+PLObject.v_SelectDate
				websys_showModal({
					url:URL,
					closable:true,
					iconCls: 'icon-w-edit',
					title:$g('复制天数'),
					width:620,height:500,
					CallBackFunc:function () {
						if (PLObject.v_Type!="CUR") {
							InitTree("cur-tree","CUR");
						} else {
							InitTree("cur-tree","CUR","TMP");	
						}
						return false;
					}
				})
			
			}
			
		})
		
		
	} else if (selected.code == "Stage") {
		var PSID = selected.id;
		if (PSID == "") {
			return false;
		}
		PSID = PSID.split("-")[0];
		debug(PSID,PSID)
		$.messager.confirm("提示", "您确认复制周期么？",function (r) {
			if (r) {
				$m({
					ClassName: "DHCDoc.Chemo.BS.Ext.Copy",
					MethodName: "CopyStage",
					PSID: PSID	//PLObject.v_PSID
				},function(result){
					if(result==1){
						$.messager.alert("提示","复制成功！","warning")
						if (PLObject.v_Type!="CUR") {
							InitTree("cur-tree","CUR");
						} else {
							InitTree("cur-tree","CUR","TMP");	
						}
						return false;
					} else {
						$.messager.alert("提示","复制失败！"+result,"warning");
						return false;
					}
				})
			}
			
		});
	
		
		
	} else {}
}

function Calculate_Handler () {
	var BASFunc = PLObject.m_BSAFunc.getValue()||"";
	if (BASFunc == "") {
		$.messager.alert("提示","请先选择体表面积计算公式！","warning")
		return false;
	}
	var BodyHeight = $.trim($("#BodyHeight").val());
	var BodyWeight = $.trim($("#BodyWeight").val());
	var BMI = (BodyWeight/(BodyHeight*BodyHeight)).toFixed(2);  
	if (BASFunc == "XWS") {
		//0.0061×身高（cm）+0.0128×体重(kg)-0.1529
		var BSA = ((0.0061*100*BodyHeight) + (0.0128*BodyWeight) - 0.1529).toFixed(4);
	}
	$("#BMI").val(BMI);
	$("#BSA").val(BSA);
}

function Cancel_HandlerOld () {
	var PDStatus = $("#PDStatus").val();
	
	if ((PLObject.v_PDID=="")||(PLObject.v_PDID=="NO")) {
		$.messager.alert("提示", "请先保存"+PLObject.v_NodeText+"化疗方案！", "info");
		return false;
	}
	if ((PDStatus == "U")||(PDStatus == "C")) {
		if (PDStatus == "C") {
			$.messager.alert("提示", PLObject.v_NodeText+"方案已经作废，不能再次进行停止操作！", "info");
		} else {
			$.messager.alert("提示", PLObject.v_NodeText+"方案已经完成，不能再次进行停止操作！", "info");
		}
		
		return false;
	}
	$.messager.confirm("提示", "确认作废"+PLObject.v_NodeText+"化疗方案？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.Chemo.BS.Date",
				MethodName:"Cancel",
				UserID:session['LOGON.USERID'],
				PDID:PLObject.v_PDID,
				PatientID:ServerObj.PatientID,
				EpisodeID:ServerObj.EpisodeID
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "作废成功！", "info");
					InitTree("cur-tree","CUR");
					return true;
				} else if (result == -144) {
					$.messager.alert("提示", "请先激活化疗单医嘱之后再进行停止！", "info");
					return false;
				} else {
					$.messager.alert("提示", "作废失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
	
}

function Stop_Handler () {
	var PDStatus = $("#PDStatus").val();
	
	
	if ((PLObject.v_PDID=="")||(PLObject.v_PDID=="NO")) {
		//$.messager.alert("提示", "请先保存"+PLObject.v_NodeText+"化疗方案！", "info");
		//return false;
		var PDAry = GetPDAry();
		$cm({
				ClassName: "DHCDoc.Chemo.BS.Date",
				MethodName: "SaveAndStop",
				PDAry: PDAry,
				UserID:session['LOGON.USERID'],	
				PatientID:ServerObj.PatientID,
				EpisodeID:ServerObj.EpisodeID
			},function(result){
				//alert(result)
				if(result==0){
					$.messager.alert("提示","停止成功！","success");
					InitTree("cur-tree","CUR");
					return true;
				}else{
					$.messager.alert("提示","停止失败！","warning");
					return false;
				}
		});
	
	
	} else {
		if ((PDStatus == "U")||(PDStatus == "S")) {
			if (PDStatus == "S") {
				$.messager.alert("提示", PLObject.v_NodeText+"方案已经停止，不能再次进行停止操作！", "info");
			} else {
				$.messager.alert("提示", PLObject.v_NodeText+"方案已经完成，不能再次进行停止操作！", "info");
			}
			
			return false;
		}
		$.messager.confirm("提示", "确认停止"+PLObject.v_NodeText+"化疗方案？",function (r) {
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
						$.messager.alert("提示", "停止成功！", "info");
						InitTree("cur-tree","CUR");
						return true;
					} else if (result == -149) {
						$.messager.alert("提示", "化疗方案已经发送申请，不能停止！", "info");
						return false;
					} else {
						$.messager.alert("提示", "停止失败：" + result , "info");
						return false;
					}
				});
			}
			
		});
	}
	
	
}

function Submit_Handler () {
	if (PLObject.v_Type != "CUR") {
		if (PLObject.v_Type=="") {
			$.messager.alert("提示","请先选择方案！","warning");
			return false;
		}
		$.messager.alert("提示","不是当前方案不能提交！","warning");
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
		$.messager.alert("提示","请选择化疗日期！","warning");
		return false;
	}
	
	/*
	//检查是否已审核
	var result = $cm({
		ClassName:"DHCDoc.Chemo.BS.Date",
		MethodName:"HasPass",
		PlanDate:PlanDate,
		PSID:PLObject.v_PSID,
		dataType:"text"
	},false);
	
	if (result==0) {
		$.messager.alert("提示","请选先完成化疗方案审核！","warning");
		return false;
	}
	*/
	if (ServerObj.HasAcitve==1) {
		$.messager.alert("提示","已激活此次化疗！","warning");
		return false;
	}
	
	//检查是否存在有效申请
	var result = $cm({
		ClassName:"DHCDoc.Chemo.BS.DateApply",
		MethodName:"HasApply",
		PDID:PLObject.v_PDID,
		dataType:"text"
	},false);
	
	if (result==1) {
		$.messager.alert("提示","已激活此次化疗！","warning");
		return false;
	}
	if (result==-1) {
		$.messager.alert("提示","方案已经停止！","warning");
		return false;
	}
	if (result==-2) {
		$.messager.alert("提示","方案已经完成！","warning");
		return false;
	}
	
	//单独判断库存
	var ExpStr=ServerObj.EpisodeID+"^"+session['LOGON.CTLOCID']+"^0"
	
	var SessionStr=GetSessionStr();
	var StockInfo = $cm({
		ClassName:"DHCDoc.Chemo.BS.Apply",
		MethodName:"GetAddToListArcimInfo",
		PSID:PLObject.v_PSID,
		PlanDate:PlanDate,
		ExtPara:"1"+String.fromCharCode(1)+ServerObj.EpisodeID+String.fromCharCode(1)+session['LOGON.CTLOCID']+String.fromCharCode(1)+SessionStr,
		AdmType:ServerObj.PAAdmType,
		dataType:"text"
	},false);
	var StockArr = StockInfo.split("^");
	if (StockArr[0]==0) {
		$.messager.alert("提示",StockArr[1],"warning");
		return false;
	}
	
	
	$m({
			ClassName: "DHCDoc.Chemo.BS.Plan",
			MethodName: "Save",
			InType:PLObject.v_Type,
			SelectDate:PLObject.v_SelectDate,
			PLAry: PLAry,
			PSAry: PSAry,
			PGAry: PGAry,
			HDAry: HDAry,
			PDAry: PDAry,
			ExtPara:0+"^"+ServerObj.PAAdmType+"^"+PlanDate
		},function(result){
			if (result.indexOf("^")<0) {
				if(result==1){
					//$.messager.alert("提示","保存成功！","success");
					// InitTree("cur-tree","CUR");
					$.messager.alert("温馨提示","请在医嘱界面点击【审核】！","info",function () {
						websys_showModal("hide");
						//alert(PLObject.v_PSID)
						//if (parent.websys_showModal('options').CallBackFunc) {
						websys_showModal('options').CallBackFunc(PLObject.v_PSID,PlanDate);
						
						
						websys_showModal("close");	
					});
					return true;
				} else if (result==-150) {
					$.messager.alert("提示","没有暂存状态的天数！","warning");
					return false;
				} else if (result==-152) {
					$.messager.alert("提示","请检查各暂存状态的必填项！","warning");
					return false;
				} else if (result==-153) {
					$.messager.alert("提示","不连续天数不允许保存！","warning");
					return false;
				} else{
					$.messager.alert("提示","保存失败！错误代码："+result,"warning");
					return false;
				}
			} else {
				//验证
				var resultArr = result.split("^");
				if (resultArr[0]!=0) {
					$.messager.alert("提示",resultArr[1],"warning");
					return false;
				} else {
					$.messager.alert("提示","验证出错！","warning");
					return false;
				}
			}
	});
	
	
}

function Gotop_Handler () {
	//document.getElementById("main-center").scrollTop = 0;
	$("#main-center").animate({scrollTop:0},200);
	
}

//检查
function Exam_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "dhcapp.inspectrs.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	//var URL = "dhcapp.seepatlis.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		maximizable:true,
		iconCls: 'icon-w-add',
		title:'检查信息',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//院外资料
function OtherHosp_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "emr.resource.pictureinformation.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		maximizable:true,
		iconCls: 'icon-w-add',
		title:'院外资料',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//检验
function Lab_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "dhcapp.seepatlis.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		maximizable:true,
		iconCls: 'icon-w-add',
		title:'检验信息',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//电子病历
function MC_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	//var URL = "emr.record.browse.episode.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	var URL = "emr.browse.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		maximizable:true,
		iconCls: 'icon-w-add',
		title:'病历',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//护理
function NUR_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "nur.hisui.recordsBrowser.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		maximizable:true,
		iconCls: 'icon-w-add',
		title:'护理记录',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//申请列表
function ApplyList_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "chemo.bs.applylist.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'申请列表',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//病历浏览
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
		title:'病历浏览',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	
	
	
	return false;
}

//病历
function BL_Handler () {
	return false;
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "nur.hisui.recordsBrowser.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'护理记录',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//
function CurOrder_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	//oeorder.opbillinfo.csp?PatientID=1&EpisodeID=1405&mradm=1405&OpenWinName=OPDocRecAdm
	var URL = "oeorder.opbillinfo.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+EpisodeID+"&OpenWinName="+"OPDocRecAdm";
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		title:'本次医嘱',
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
		title:'历史医嘱',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}


//不良事件
function AES_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType,
		RegNo = ServerObj.RegNo;
	var URL = "dhcadv.reportquery.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType+"&OnlyShowPatReport="+1;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-add',
		maximizable:true,
		title:'不良事件',
		width:$(window).width()-100,height:$(window).height()-100
	})	
	
	return false;
}

//过敏确认
function GMisOK_Handler () {
	var PSID = PLObject.v_PSID||"";
	if (PSID == "") {
		return false;
	}
	
	var PSHasGMis = $("#sensitiveTD").find("input[type='radio']:checked").val();
	if (typeof PSHasGMis == "undefined") {
		$.messager.alert("提示","请选择有无过敏史！","warning")
		return false;
	}
	var GMisFill = $.trim($("#GMisFill").val());
	if (PSHasGMis==1) {
		if (GMisFill=="") {
			$.messager.alert("提示","请填写过敏史记录！","warning",function () {
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
				//InitTree("cur-tree","CUR");
				$.messager.alert("提示","确认成功！","warning");
				return true;
			}else{
				$.messager.alert("提示","确认失败！","warning");
				return false;
			}
	});
	
}

//过敏史
function GMis_Handler () {
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
		//dhcdoc.allergyenter.csp
		//dhcem.allergyenter.csp
		//websys_showModal('options').CallBackFunc
	var URL = "dhcdoc.allergyenter.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType;
	if ('undefined'!==typeof websys_getMWToken){
		URL += "&MWToken="+websys_getMWToken()
	}
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+URL+"'></iframe>" ;
	
	createGMisModalDialog("GMIS_Modal", "过敏史", $(window).width()-100, $(window).height()-100, "icon-w-add","",$code,"")
	
	/*
	websys_showModal({
		url:URL,
		maximizable:true,
		iconCls: 'icon-w-add',
		title:'过敏史',
		width:$(window).width()-100,height:$(window).height()-100,
		onClose:function () {
			//刷新过敏史
			InitStageInfo(PLObject.v_PSID,PLObject.v_Type,PLObject.v_SelectDate);
			return false;
			
				
		}
	})	
	*/
	return false;
	
}

//知情同意书
function AgreeForm_Handler () {
	
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	//var result=tkMakeServerCall("EMRservice.HISInterface.PatientInfoAssist","GetEMRInstanceID",EpisodeID)
	
	var result = $cm({
		ClassName:"EMRservice.HISInterface.PatientInfoAssist",
		MethodName:"GetEMRInstanceID",
		argEpisodeID:EpisodeID,
		dataType:"text"
	},false);
	
	if (result!=""){
		var URL = "emr.record.browse.browsform.editor.csp?EpisodeID="+EpisodeID+"&id="+result+"&Print=N&chartItemType=Multiple&pluginType=DOC";
		websys_showModal({
			url:URL,
			iconCls: 'icon-w-add',
			title:'知情同意书',
			width:$(window).width()-100,height:$(window).height()-100
		})
	} else {
		$.messager.alert("提示","患者没有签署知情同意书！","warning");
		return false;
	}
	
	return false;
	
}

function AdjPlanDate_Handler () {
	if (PLObject.v_Type != "CUR") {
		if (PLObject.v_Type=="") {
			$.messager.alert("提示","请先选择周期！","warning");
			return false;
		}
		$.messager.alert("提示","不是当前方案不能调整！","warning");
		return false;
	}
	var AdjDateFrom = PLObject.v_NextDay;
	var AdjDateTo = $("#nexday").datebox("getValue")||"";
	if (AdjDateTo == "") {
		$.messager.alert("提示","下次化疗日期不能为空！","warning");
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
				$.messager.alert("提示","调整成功！","warning");
				return true;
			}else{
				$.messager.alert("提示","保存失败！","warning");
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
		title:'患者当前化疗单方案',
		width:$(window).width()-100,height:$(window).height()-100
	})	
}

function Formula_Handler () {
	var Height=$.trim($("#VS-Height").val());
	var Weight=$.trim($("#VS-Weight").val());
	var BSA=$.trim($("#BSA").val());
	var GFR=$.trim($("#GFR").val());
	var SC=$.trim($("#VS-SC").val());
	var IBW=$.trim($("#IBW").val());
	var Age=$.trim($("#Age").val());
	var Sex=$.trim($("#Sex").val());
	
	
	var VSData=Height+"^"+Weight+"^"+BSA+"^"+GFR+"^"+SC+"^"+IBW+"^"+Age+"^"+Sex;
	
	var PatientID = ServerObj.PatientID,
		EpisodeID = ServerObj.EpisodeID,
		PAAdmType = ServerObj.PAAdmType;
	var URL = "chemo.bs.formula.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PAAdmType="+PAAdmType+"&VSData="+VSData;
	websys_showModal({
		url:URL,
		modal:false,
		iconCls: 'icon-w-calc',
		title:'化疗计算器',
		left:($(window).width()-600),
		top:($(window).height()-450),
		width:550,height:400
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

function CollapseAll_Handler () {
	/*var roots = $("#hosp-tree").tree("getRoots");
	var roots2 = $("#dep-tree").tree("getRoots");
	for (i=0;i<roots.length;i++) {
		var node=roots[i]
		debug(node.target,"node.target")
		$("#hosp-tree").tree("toggle",node.target);
	}
	for (i=0;i<roots2.length;i++) {
		var node=roots2[i]
		debug(node.target,"node.target")
		$("#dep-tree").tree("toggle",node.target);
	}*/
	
	$("#hosp-tree").tree("collapseAll");
	$("#dep-tree").tree("collapseAll");
	$("#user-tree").tree("collapseAll");
	
}
function ExpandAll_Handler () {
	
	
	$("#hosp-tree").tree("expandAll");
	$("#dep-tree").tree("expandAll");
	$("#user-tree").tree("expandAll");
	
}
function Resize_Handler() {
	autoSetGridWH("GroupGrid");
	
	return false;
	for (var j=1; j<=PLObject.v_Groups; j++) {
		var id = "GroupGrid-"+j;
		autoSetGridWH(id);
		
		//$("#"+id).jqGrid('setGridWidth',$(window).width() - 30);
		// 高度自动适应
		//$(window).unbind("onresize");
		//$("#"+id).setGridHeight($(window).height() - 370); // grid_selector 是 DIV 的 ID
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
		title:'公式',
		maximizable:true,
		width:800,height:$(window).height()-100
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
		title:'调整过程',
		maximizable:true,
		width:$(window).width()-100,height:$(window).height()-100
	})			
}

//打开医嘱套界面
function Arcos_btn_Handler(id,DescCode,Desc,gID,gDesc) {
    var DW = $(window).width()-200,
    	DH = $(window).height() - 100;
	
    websys_showModal({
		//url:"doc.arcositemlist.hui.csp?EpisodeID=" + ServerObj.EpisodeID + "&ARCOSRowid=" + ARCOSRowid +"&nowOrderPrior=" +nowOrderPrior,
		url:"chemo.bs.arcos.csp?EpisodeID=" + ServerObj.EpisodeID+"&id="+id+"&DescCode="+DescCode+"&GID="+gID+"&GDesc="+gDesc,
		title:Desc,
		width:DW,
		height:DH,
		AddCopyItemToList:AddCopyItemToList
		
	});
			
}

function Cancel_Handler () {
	if (PLObject.v_Type != "CUR") {
		if (PLObject.v_Type=="") {
			$.messager.alert("提示","请选择化疗方案！","warning");	//请先选择周期下day！
			return false;
		}
	}
	
	//websys_showModal('options').DelChemoOrder(PLObject.v_PLID);
	//return false;
	//$.messager.confirm("提示", "删除方案后, 无法恢复 , 您确定要删除【"+PLObject.o_MObj.PLName+"】吗？",function (r) {
	$.messager.confirm("提示", "删除方案后, 无法恢复 , 您确定要删除吗？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.Chemo.BS.Plan",
				MethodName:"DelChemoPlan",
				UserID:session['LOGON.USERID'],
				PLID:PLObject.v_PLID,
				LocID:session['LOGON.CTLOCID'],
				PatientID:ServerObj.PatientID,
				EpisodeID:ServerObj.EpisodeID
			}, function(result){
				resultArr = result.split("^")
				if (resultArr[0] == 0) {
					//parent.Chmeo_Del();
					//websys_showModal('options').DelChemoOrder(PLObject.v_PLID);
					$.messager.alert("提示", "删除成功！", "info");
					//InitTree("history-tree","HIS")
					InitTree("cur-tree","CUR");
					ClearItem();
					return true;
				} else {
					$.messager.alert("提示", resultArr[1] , "info");
					return false;
				}
			});
		}
		
	});
	
}

function OkPlan_Handler () {
	if (PLObject.v_Type != "CUR") {
		if (PLObject.v_Type=="") {
			$.messager.alert("提示","请选择化疗方案！","warning");
			return false;
		}
		//$.messager.alert("提示","不是当前方案不能审核！","warning");
		//return false;
	}
	
	$.messager.confirm("提示", "确认完成当前化疗方案么？",function (r) {
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
					$.messager.alert("提示", "保存成功！", "info");
					InitTree("history-tree","HIS")
					InitTree("cur-tree","CUR");
					return true;
				} else {
					$.messager.alert("提示", "保存失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
	
}

function SearchPlan_Handler () {
	InitTree("history-tree","HIS");
}
function SearchUser_Handler () {
	InitTree("user-tree","USER");
}
function SearchDep_Handler () {
	InitTree("dep-tree","DEP");
}
function SearchHosp_Handler (text) {
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
		if (Formula == "GFR") {	//
			//
			var temVal = GetCellData(id,rowid,"BSAUnit");
			if (temVal!="") {
				var GFR = $.trim($("#GFR").val());
				//var Dosage = (GFR*temVal).toFixed(1);
				var Dosage = CalcGFRDose(temVal,GFR,1)
				SetCellData(id, rowid, "OrderDoseQty", Dosage);
			} else {
				SetCellData(id, rowid, "OrderDoseQty", "");
			}
			
		} else if (Formula == "BSA") {
			var temVal = GetCellData(id,rowid,"BSAUnit");
			var InArcim = GetCellData(id,rowid,"OrderARCIMRowid");
			var BSA = $("#BSA").val();
			var Dosage = (BSA*temVal).toFixed(1);
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
					$.messager.alert("提示","超过终身剂量！","warning");
					SetCellData(id, rowid, "OrderDoseQty", Dosage);
					return false;
				} else {
					SetCellData(id, rowid, "OrderDoseQty", Dosage);
				}
				
			} else {
				SetCellData(id, rowid, "OrderDoseQty", "");
			}
			
		} else if (Formula == "WGT") {
			var temVal = GetCellData(id,rowid,"BSAUnit");
			var Weight = $("#VS-Weight").val();
			var Dosage = (Weight*temVal).toFixed(1);
			if (temVal!="") {
				SetCellData(id, rowid, "OrderDoseQty", Dosage);
			} else {
				SetCellData(id, rowid, "OrderDoseQty", "");
			}
		} else {
			
		}
		
		SetPackQty(id,rowid)
		
	}
}

//单次剂量
function OrderDoseQtykeyuphandler (e) {
	
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
		//SetCellData(id, rowid, "OrderDoseUom", Dosage);
		
		//允许输入的字符控制
		var newValue = "";
		var val = $(this).val();
		if (val!="") {newValue = val.substring(0, val.length-1);}
		if ( ((keycode!=190)&&(keycode>57)) ||((keycode<48)&&(keycode!=8)) ) {
			$(this).val(newValue);
			return false;
		} else {
			if (keycode==8) {
				//$(this).val(newValue);
			}
			
		}
		
		SetPackQty(id,rowid)
	}
}
function OrderDoseQtykeyuphandlerOld (e) {
	//QP 2020-07-01 不做反推
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
		//允许输入的字符控制
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
		
		//联动控制
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

//4-7控制
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
				//输入的值在4-7之间
				if (val>7) { //两位数
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
					$.messager.alert("提示","超过终身剂量！","warning");
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

function AddCopyItemToList (id,ParaArr,GID,GDesc) {
	//debug(id,"AddCopyItemToList-id")
	//debug(code,"AddCopyItemToList-code")
	debug(ParaArr,"AddCopyItemToList-ParaArr")

	//删除当前最后一行空白行
    var CruRow = GetPreRowId(id);
    //debug(CruRow,"CruRow")
    if (CheckIsClear(id,CruRow) == true) {
        DeleteRow(id,CruRow);
    }
	var OrdArr = new Array();
	for (var i = 0,ArrLength = ParaArr.length; i < ArrLength; i++){
		OrdArr.push(ParaArr[i]);
	}
	var RowData = GetRowData(OrdArr);
	
	//debug(OrdArr,"OrdArr")
	//window.setTimeout(function(){
		//GetRowData(OrdArr,RowData);
	//}, 100);
	
	
	var MaxLinkNo = GetMaxLinkNo(id)
	
	//重新整理关联编号
	var NewLinkObj = {
		Max:parseInt(MaxLinkNo)
	};
	for (j=0; j<RowData.length; j++) {
		var cLinkNo = RowData[j].OrderMasterSeqNo
		if ((!cLinkNo)&&(cLinkNo!="")) {
			continue;
		}
		var intNum = cLinkNo,
			deciNum = "";
			
		if (cLinkNo.indexOf(".")>=0) {
			intNum = cLinkNo.split(".")[0],
			deciNum= cLinkNo.split(".")[1];
		} 
		if (!NewLinkObj[intNum]) {
			NewLinkObj[intNum] = parseInt(NewLinkObj["Max"])+1;
			NewLinkObj["Max"] = parseInt(NewLinkObj["Max"]) +1;
		} 
		if (deciNum!="") {
			RowData[j].OrderMasterSeqNo = NewLinkObj[intNum]+"."+deciNum;
		} else {
			RowData[j].OrderMasterSeqNo = NewLinkObj[intNum];
		}
	}	
	
	debug(RowData,"RowData")
	debug(NewLinkObj, "NewLinkObj");
	
	for (var k=0;k<RowData.length;k++) {
		var RowDataObj = RowData[k];
		//设置组类型
		RowDataObj.GroupType = GDesc;
		RowDataObj.GroupTypeId = GID;
		AddItemToList(id,RowDataObj);
	}
	return false;
}

function GetRowData(OrdArr){
	var RowData = [];
	for (var i = 0,ArrLength = OrdArr.length; i < ArrLength; i++) {
		var Para1Str=OrdArr[i];
		var para1Arr = Para1Str.split("!")
		var icode = para1Arr[0];
		var seqno = para1Arr[1];
		var Para = para1Arr[2];
		var ItemOrderType = para1Arr[3];
		var CopyBillTypeRowId = para1Arr[4];
		var RowDataObj=BuildItemData(icode,seqno,Para);
		RowData.push(RowDataObj);
		//var RtnObj = AddItemToList(id,RowDataObj);
	}
	return RowData;
}

function AddItemToList(id,RowDataObj) {
	//设置医嘱类型
	RowDataObj.OrderPriorRowid=PLObject.o_MObj.ShortOrderPriorRowid
	RowDataObj.OrderPrior=PLObject.o_MObj.ShortOrderPrior
	var rowid=GetAddRowid(id);
	debug(rowid,"AddItemToList-rowid");
	RowDataObj.id = rowid;
	debug(RowDataObj,"RowDataObj");
	rowid = Add_Order_row2(id,RowDataObj);
	
	return false;
					
}

function BuildItemData (icode,seqno,Para) {
	var InPara = Para.split("^"),
		C1 = String.fromCharCode(1);
	
	//debug(InPara,"InPara")
	
	var RowDataObj = $cm({
		ClassName:"DHCDoc.Chemo.Model.ArcosItem",
		MethodName:"GetInfo",
		Arcim: icode,
		LinkNo: seqno,
		Para: Para,
		PatientID:ServerObj.PatientID,
		EpisodeID:ServerObj.EpisodeID
	},false);
	//debug(RowDataObj,"RowDataObj")
	
	return RowDataObj;
}

function GetMaxLinkNo (id) {
	var Max=0;
	var gridData = GetGirdData(id);
	for (var k=0; k < gridData.length; k++) {
		var 
			PGIArcimDR = gridData[k].OrderARCIMRowid||"",
			PGILinkItem = gridData[k].OrderMasterSeqNo;
		
		if ((PGIArcimDR == "")||(PGILinkItem=="")) {
			continue;
		}
		if (PGILinkItem.indexOf(".")>=0) {
			PGILinkItem=PGILinkItem.split(".")[0]
		} 
		if (PGILinkItem>Max)  {
			Max = PGILinkItem;
		}
	}
	
	return Max;	
}

function SetPackQty(id,Row) {
    var OrderARCIMRowid = GetCellData(id, Row, "OrderARCIMRowid");
    if (OrderARCIMRowid == "") return true;
    var OrderPriorRowid = GetCellData(id, Row, "OrderPriorRowid");
	var OrderDoseQty = GetCellData(id, Row, "OrderDoseQty");
	
	var OrderDoseUOMRowid = GetCellData(id, Row, "OrderDoseUOMRowid");
	var OrderFreqRowid = GetCellData(id, Row, "OrderFreqRowid");
	var OrderDurRowid = GetCellData(id, Row, "OrderDurRowid");
	var OrderPackQty = GetCellData(id, Row, "OrderPackQty");
	var OrderPackUOMRowid = GetCellData(id,Row, "OrderPackUOMRowid");
    var OrderStartDate = ""
    var OrderMultiDate = ""
    var OrderPriorRemarks = "";
    var OrderPrice = 0
    var OrderRecDepRowid= GetCellData(id,Row, "OrderRecDepRowid");
	//alert(OrderDoseUOMRowid)
	var OrdParamObj={
		EpisodeID:ServerObj.EpisodeID,
		OrderPriorRowid:OrderPriorRowid,
		OrderARCIMRowid:OrderARCIMRowid,
		OrderDoseQty:OrderDoseQty,
		OrderDoseUOMRowid:OrderDoseUOMRowid,
		OrderFreqRowid:OrderFreqRowid,
		OrderDurRowid:OrderDurRowid,
		OrderPackQty:OrderPackQty,
		OrderPackUOMRowid:OrderPackUOMRowid,
		OrderStartDate:OrderStartDate,
		OrderMultiDate:OrderMultiDate,
		OrderPrice:OrderPrice,
		LinkedMasterOrderPriorRowid:"",
		OrderFreqDispTimeStr:"",
		OrderFirstDayTimes:"",
		IsNotChangeFirstDayTimeFlag:"",
		IsNotNeedChangeFlag:"",
		OrderFreqTimeDoseStr:"",
		
		OrderRecDepRowid:OrderRecDepRowid,
		SessionStr:GetSessionStr(),
		OrderMasterARCIMRowid:""
	};
	
	var OrdParamJson=JSON.stringify(OrdParamObj);
	
	var CalPackQtyJson = $cm({
		ClassName:"web.DHCOEOrdItemView",
		MethodName:"CalPackQty",
		OrdParamJson: OrdParamJson,
		dataType:"text"
	},false);
	//debug(OrdParamJson,"OrdParamJson")
	var CalPackQtyObj=jQuery.parseJSON(CalPackQtyJson);
	//debug(CalPackQtyObj,"CalPackQtyObj")
	//alert(CalPackQtyObj.OrderPackQty )
	//alert(typeof CalPackQtyObj)
	//debug(CalPackQtyObj.OrderPackQty, "OrderPackQty")
	if (typeof CalPackQtyObj.OrderPackQty !="undefined"){
		//alert("h: "+CalPackQtyObj.OrderPackQty)
		SetCellData(id,Row, "OrderPackQty", CalPackQtyObj.OrderPackQty);
	}
	
    return true;
}

//var test ='{"EpisodeID":"1067","OrderPriorRowid":"3","OrderARCIMRowid":"161||1","OrderDoseQty":"30","OrderDoseUOMRowid":"87","OrderFreqRowid":"14","OrderDurRowid":"1","OrderPackQty":"1","OrderPackUOMRowid":"2","OrderStartDate":"","OrderMultiDate":"","OrderPrice":0,"LinkedMasterOrderPriorRowid":"","OrderFreqDispTimeStr":"","OrderFirstDayTimes":"","IsNotChangeFirstDayTimeFlag":"","IsNotNeedChangeFlag":"","OrderFreqTimeDoseStr":"","OrderRecDepRowid":"19","SessionStr":"12213^28^4^2^undefined^20","OrderMasterARCIMRowid":""}'

function ComDateCallBack (ChemoDays,OrderMasterSeqNo) {
	var id = "GroupGrid"
	SetCellData(id,PageLogicObj.FocusRowIndex,"ChemoDays",ChemoDays);
	if (OrderMasterSeqNo!="") {
		OrderMasterSeqNo = parseInt(OrderMasterSeqNo);
	}
	
	var records = $('#'+id).getGridParam("records");
	for (var i = 1; i <= records; i++) {
		var linkNo = GetCellData(id,i,"OrderMasterSeqNo");
		linkNo  = parseInt(linkNo)
		if (linkNo == OrderMasterSeqNo) {
			SetCellData(id,i,"ChemoDays",ChemoDays);
		}
		
	}
	PLObject.v_ComDateNum=0;
	return false;
}
function ComDateClick () {
	//alert(111)
	var id = "GroupGrid"
	var ids = $('#'+id).jqGrid("getGridParam", "selarrrow");
    if (ids == null || ids.length > 1) {
        $.messager.alert("警告", "请选择一条记录！","warning");
        return;
    }
    
	PLObject.v_ComDateNum=1;
	if (!PageLogicObj.FocusRowIndex) {
		return false;	
	}
	if (ids.length==1) {
		PageLogicObj.FocusRowIndex = ids[0];
	}
	var PGIId = GetCellData(id,PageLogicObj.FocusRowIndex,"PGIId");
	var ArcimDR = GetCellData(id,PageLogicObj.FocusRowIndex,"OrderARCIMRowid");
	var ChemoDays = GetCellData(id,PageLogicObj.FocusRowIndex,"ChemoDays");
	var OrderMasterSeqNo = GetCellData(id,PageLogicObj.FocusRowIndex,"OrderMasterSeqNo");
	
	
	
	//if ((PGIId=="")||(ArcimDR=="")) {
	if ((ArcimDR=="")) {
		//$.messager.alert("提示","新增的药品请先保存在进行调整！","warning")
		return false;
	}
	var isEdit = GetEditStatus(id,PageLogicObj.FocusRowIndex);
	
	if (isEdit) {
		var URL = "chemo.bs.comdate.csp?ChemoDays="+ChemoDays+"&OrderMasterSeqNo="+OrderMasterSeqNo;
		/*
		websys_showModal({
			url:URL,
			closable:true,
			iconCls: 'icon-w-edit',
			title:'常用日期',
			width:300,height:350,
			onClose:function () {
				PLObject.v_ComDateNum=0;
			},
			CallBackFunc:function (ChemoDays) {
				SetCellData(id,PageLogicObj.FocusRowIndex,"ChemoDays",ChemoDays);
				if (OrderMasterSeqNo!="") {
					OrderMasterSeqNo = parseInt(OrderMasterSeqNo);
				}
				
				var records = $('#'+id).getGridParam("records");
				for (var i = 1; i <= records; i++) {
					var linkNo = GetCellData(id,i,"OrderMasterSeqNo");
					linkNo  = parseInt(linkNo)
					if (linkNo == OrderMasterSeqNo) {
						SetCellData(id,i,"ChemoDays",ChemoDays);
					}
					
				}
				return false;
			}
		})
		*/
                if ('undefined'!==typeof websys_getMWToken){
                        URL += "&MWToken="+websys_getMWToken()
                }
		var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+URL+"'></iframe>" ;
		createComDateModalDialog("ComDate_Modal", "常用日期", 300, 350, "icon-w-edit","",$code,"");
	} else {
		$.messager.alert("提示","先进入编辑状态，再进行调整！","warning")
		PLObject.v_ComDateNum=0;
		return false;
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


// 药品说明书
function DrugNote_Click() {
	
	/*
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		//选中一行
		var ids=$('#Order_DataGrid').jqGrid("getGridParam", "selarrrow"); 			
		if(ids==null || ids.length==0 || ids.length > 1) {  
			$.messager.alert("警告","请选择一条医嘱");  
			return;  
		}
		var OrderARCIMRowid = GetCellData(ids[0], "OrderARCIMRowid");
	}else{
		var OrderARCIMRowid=$("#"+FocusRowIndex+"_OrderARCIMID"+FocusGroupIndex+"").val();
	}
	if (typeof OrderARCIMRowid=="undefined" || OrderARCIMRowid==null || OrderARCIMRowid==""){
		$.messager.alert("警告","请选择一条医嘱");  
		return;  
	}
	var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",OrderARCIMRowid);
	var OrderARCIMCode=mPiece(ArcimInfo,"^",0);
	var OrderName=mPiece(ArcimInfo,"^",1);*/
	//alert(111)
	//HLYYYDTS_Click();
	
	if (!PageLogicObj.FocusRowIndex) {
		$.messager.alert("警告","请选择一条医嘱","warning");  
		return false;
		
	}
	var OrderARCIMRowid = GetCellData("GroupGrid",PageLogicObj.FocusRowIndex,"OrderARCIMRowid");
	if (OrderARCIMRowid=="") {
		return false;
	}
	//var OrderName = GetCellData("GroupGrid",PageLogicObj.FocusRowIndex,"OrderName");
	var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",OrderARCIMRowid);
	var OrderARCIMCode=mPiece(ArcimInfo,"^",0);
	var OrderName=mPiece(ArcimInfo,"^",1);
	PassFuncs.MKFuncs.MKYDTS(OrderARCIMCode,OrderName);
	
}

function Out_btn_Click () {
	
}

function StopOrder_Click() {
    var ids = $('#GroupGrid').jqGrid("getGridParam", "selarrrow");
    //debug(ids,"ids");
    if (ids == null || ids.length == 0) {
        $.messager.alert("警告", "请选择要中止的记录","warning");
        return;
    }
    //
    var mList=[];msg=""
    for (var i = 0; i < ids.length; i++) {
		var OeoriDR = GetCellData("GroupGrid",ids[i],"OeoriDR");
		if (OeoriDR=="") {
			var msg="所选记录不能进行中止！";
			break;	
		}
		mList.push(OeoriDR);		
    }
    if (msg!="") {
	    $.messager.alert("警告", msg,"warning");
        return false;
	}
	if (mList.length==0) {
		$.messager.alert("警告", "无满足中止的记录！","warning");
        return false;
	}
	/*
	var result = $cm({
		ClassName:"DHCDoc.Chemo.BS.Plan",
		MethodName:"HasOrderEqualI",
		OrderList:mList.join("^"),
		dataType:"text"
	},false);
	
	if (result==1) {
		$.messager.alert("警告", "所选记录未发药不能进行中止！","warning");
        return false;
	}*/
	//alert(mList.join(","))
	$.messager.confirm('确认对话框', '确定中止选中的记录吗？', function(r){
		if (r){
			$cm({
				ClassName: "DHCDoc.Chemo.BS.Plan",
				MethodName: "StopOrder",
				UserID: session['LOGON.USERID'],
				PatientID: ServerObj.PatientID,
				EpisodeID: ServerObj.EpisodeID,
				OrderList: mList.join("^")
			},function(result){
				if(result==0){
					$.messager.alert("提示","中止成功！","success");
					InitTree("cur-tree","CUR");
					return true;
				}else if (result==-1){
					$.messager.alert("提示","无满足中止的记录！","warning");
					return false;
				} else {
					$.messager.alert("提示","中止失败！错误代码："+result,"warning");
					return false;
				}
			});
			
			
		}
	})
    
}
//LinkRef
/**

dhcmdt.patemrque.csp  会诊申请引用界面
dhcem.patemrque.csp?&EpisodeID=647&PatientID=141&targetName=Attitude&TextValue=&Flag=1


**/

function LinkRef_Handler () {
	/*var PW = $(window.parent.window).width()-300;
	var PH = $(window.parent.window).height()-80;	//$(window).height()
	var PTH = $(top).height();
	var PatientID = ServerObj.PatientID,
	EpisodeID = ServerObj.EpisodeID;

	var URL = "dhcem.patemrque.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID;
	websys_showModal({
		url:URL,
		//id:"i-chemo",
		iconCls: 'icon-w-add',
		title:'引用',
		maximizable:true,
		//maximized:true,
		width:PW,height:PH
		//CallBackFunc:Chemo_ShowApply_Callback
	})*/
	
	
	var url="dhcem.patemrque.csp?&EpisodeID="+ServerObj.EpisodeID+"&PatientID="+ServerObj.PatientID+"&targetName=Attitude"+"&TextValue="; //+obj.text;
		window.parent.InsQuote = function (result) {
			websys_showModal("close");
			if (result){
				if ($("#LabExamNote").val() == ""){
					$("#LabExamNote").val(result);
				}else{
					$("#LabExamNote").val($("#LabExamNote").val()  +"\r\n"+ result);
				}
			}
		}
		websys_showModal({
			url:url,
			title:'引用',
			iconCls:'icon-w-edit',
			width:1300,height:600,
			CallBackFunc:function(result){
				websys_showModal("close");
				if (result){
					if ($("#LabExamNote").val() == ""){
						$("#LabExamNote").val(result.innertTexts);
					}else{
						$("#LabExamNote").val($("#LabExamNote").val()  +"\r\n"+ result.innertTexts);
					}
				}
			}
		});
	
	
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("VS-Height")>=0){
			$("#VS-Weight").focus();
		}
		if(SrcObj && SrcObj.id.indexOf("VS-Weight")>=0){
			$("#VS-Temperature").focus();
		}
		if(SrcObj && SrcObj.id.indexOf("VS-Temperature")>=0){
			$("#VS-BloodPressure").focus();
		}
		if(SrcObj && SrcObj.id.indexOf("VS-BloodPressure")>=0){
			$("#VS-Pulse").focus();
		}
		if(SrcObj && SrcObj.id.indexOf("VS-Pulse")>=0){
			$("#VS-Oxygen").focus();
		}
		if(SrcObj && SrcObj.id.indexOf("VS-Oxygen")>=0){
			$("#VS-ECOG").focus();
		}
		if(SrcObj && SrcObj.id.indexOf("VS-ECOG")>=0){
			$("#VS-KQ-Score").focus();
		}
		
		
		return true;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}

function ClearItem() {
	InitMainDrug("","");
	InitGroupHtml("","","","","","");
	InitStageInfo("","","");	
	$("#otherDate").datebox("setValue","");
	$("#day").val("");
}

function LoadOverview(title) {
	//getSelected
	//加载化疗总览界面
	title=title||"";
	if (title=="") {
		Selected = $('#i-overtab').tabs("getSelected");
		//var index = $('#i-overtab').tabs('getTabIndex',Selected);
		var title=Selected.panel('options').title
	}
	if (title!="化疗总览") {
		return ;
	}
	if ((PLObject.v_Type != "CUR")&&(PLObject.v_Type != "HIS")) {
		
	} else {
		var url = "chemo.bs.overview.csp?PSID="+PLObject.v_PSID;
		$("#OverviewFrame").attr("src",url);
	}
}

function LoadChemoApply() {
	//getSelected
	//加载化疗总览界面
	title=title||"";
	if (title=="") {
		Selected = $('#i-overtab').tabs("getSelected");
		//var index = $('#i-overtab').tabs('getTabIndex',Selected);
		var title=Selected.panel('options').title
	}
	if (title!="化疗单") {
		return ;
	}
	if ((PLObject.v_Type != "CUR")&&(PLObject.v_Type != "HIS")) {
		
	} else {
		if (PLObject.v_Type=="CUR") {
			InitTree("cur-tree","CUR");
		} else {
			//InitTree("history-tree","HIS")
		}
	}
}

function GetItemOrdsJson(){
	var ItemOrdsObj={
		Length:0,
		ItemOrds:[]	//行对象集合
	}
	var ItemOrdsJson=JSON.stringify(ItemOrdsObj);
	return ItemOrdsJson;
}

function GetOrdCongeriesJson(OrderARCIMRowid) {
	var OrdCongeriesObj = [{
		ItemDefaultRowId: "",
		OrderARCIMRowid: OrderARCIMRowid
	}]
	return JSON.stringify(OrdCongeriesObj);
}
function GetBaseParamJson(rowid) {
	//默认费别
    var OrderBillTypeRowid = "",
        OrderBillType = "";
    var response=$.cm({
		ClassName:"web.DHCDocOrderCommon",
		MethodName:"GetDefaultPrescriptType",
		dataType:"text",
		EpisodeID:GlobalObj.EpisodeID,
		PreBillTypeID:"",
		PreBillType:""
	},false);
	response=response.replace(/(^\s*)|(\s*$)/g, '');
    var DefaultPrescriptType = response.split('^')[0];
	OrderBillTypeRowid = DefaultPrescriptType.split(':')[0];
    OrderBillType = DefaultPrescriptType.split(':')[1];
    ServerObj.OrderBillTypeRowid = OrderBillTypeRowid
    ServerObj.OrderBillType = OrderBillType
    
	var PageDefaultOrderPriorStr=GlobalObj.ShortOrderPriorRowid+"^"+GlobalObj.ShortOrderPriorRowid+":临时医嘱"
	var GlobalDefaultOrderPriorRowid=GlobalObj.ShortOrderPriorRowid
	var SessionStr= GetSessionStr();
	
	var  BaseParamObj = {
		AddMethod: "data",
		Adm: ServerObj.EpisodeID,
		AnaesthesiaID: "",
		CopyType: "",
		GlobalDefaultOrderPriorRowid: GlobalDefaultOrderPriorRowid,
		PageDefaultOrderPriorStr:PageDefaultOrderPriorStr,
		ITMRowId: "",
		ItemDefaultRowId: "",
		LogonDep: "",
		MasterSeqNo: "",
		MaterialBarcode: "",
		OrderARCIMRowid: "",
		OrderARCOSRowid: "",
		OrderBillTypeRowid: OrderBillTypeRowid,
		OrderBodyPartLabel: "",
		OrderChronicDiagCode: "",
		OrderOpenForAllHosp: 0,
		OrderOperationCode: "",
		OrderPriorContrlConfig: "1",
		PPRowId: "",
		RelocRowID: "",
		SessionStr: SessionStr,
		VerifiedOrderObj: {
			LinkedMasterOrderFreDesc: "",
			LinkedMasterOrderFreFactor: "",
			LinkedMasterOrderFreInterval: "",
			LinkedMasterOrderFreRowId: "",
			LinkedMasterOrderName: "",
			LinkedMasterOrderPriorRowid: "",
			LinkedMasterOrderRowid: "",
			LinkedMasterOrderSeqNo: ""

		},
		isEditCopyItem: 0,
		rowid: rowid

	}
	return JSON.stringify(BaseParamObj);
}

function GetRowDataJson() {
	//开医嘱日期  OrderDate  2014-03-25 17:34:34
	var Currtime = GetCurr_time();
    var OrderStartDate = Currtime;
    var OrderEndDate = Currtime;
    var OrderDate = Currtime;
    
	var RowDataObj = {
		OrderActionRowid: "",
		OrderBillType: ServerObj.OrderBillType,
		OrderBillTypeRowid: ServerObj.OrderBillTypeRowid,
		OrderDIACat: " ",
		OrderDIACatRowId: "",
		OrderDate: OrderDate,
		OrderFlowRateUnit: "",
		OrderFlowRateUnitRowId: "",
		OrderLogDep: session['LOGON.CTLOCDESC'],
		OrderOperation: " ",
		OrderOperationCode: "",
		OrderPrior: GlobalObj.ShortOrderPriorRowid,
		OrderPriorRemarks: "",
		OrderPriorRemarksRowId: "",
		OrderPriorRowid: GlobalObj.ShortOrderPriorRowid,
		OrderPriorStr: GlobalObj.ShortOrderPriorRowid+":临时医嘱",
		OrderSpeedFlowRate: "",
		OrderStartDate: OrderDate,
		OrderUserAdd: session['LOGON.USERNAME'],
		OrderUserDep: session['LOGON.CTLOCDESC'],
		key: ""
	}	
	
	return JSON.stringify(RowDataObj);;
}

function GetUserOptionsJson() {
	var UserOptionsArr = [];
	return JSON.stringify(UserOptionsArr);
	
}

function AddItemDataToRow(id,rowid,ItemCongeriesObj) {
	var ItemToListDetailObj=ItemCongeriesObj[0];
	var 
		ErrCode = ItemToListDetailObj.ErrCode,
		ErrMsg = ItemToListDetailObj.ErrMsg,
		RowDataObj = ItemToListDetailObj.OrdListInfo;
	if (ErrCode == "-1") {
		$.messager.alert("提示",ErrMsg,"warning")
		return false;
	}
	//医嘱项ID
    SetCellData(id,rowid, "OrderARCIMRowid", RowDataObj.OrderARCIMRowid);
    SetCellData(id,rowid, "OrderName", RowDataObj.OrderName);
				        
	SetCellData(id,rowid, "OrderPrior", RowDataObj.OrderPriorRowid);
    SetCellData(id,rowid, "OrderPriorRowid", RowDataObj.OrderPriorRowid);
    SetCellData(id,rowid, "OrderPriorStr", RowDataObj.OrderPriorStr);
	
	//剂量单位
    SetColumnList(id,rowid, "OrderDoseUOM", RowDataObj.idoseqtystr)
    SetCellData(id,rowid, "OrderDoseQty", RowDataObj.OrderDoseQty);
    SetCellData(id,rowid, "OrderDoseUOM", RowDataObj.OrderDoseUOMRowid);
    SetCellData(id,rowid, "OrderDoseUOMRowid", RowDataObj.OrderDoseUOMRowid);
	//接受科室
	SetColumnList(id,rowid, "OrderRecDep", RowDataObj.CurrentRecLocStr);           
	//频次
    SetCellData(id,rowid, "OrderFreq", RowDataObj.OrderFreq);
    //$.messager.alert("警告",OrderFreq);
    SetCellData(id,rowid, "OrderFreqRowid", RowDataObj.OrderFreqRowid);
    SetCellData(id,rowid, "OrderFreqFactor", RowDataObj.OrderFreqFactor);
    SetCellData(id,rowid, "OrderFreqInterval", RowDataObj.OrderFreqInterval);
    SetCellData(id,rowid, "OrderFreqDispTimeStr", RowDataObj.OrderFreqDispTimeStr);
    //用法
    SetCellData(id,rowid, "OrderInstr", RowDataObj.OrderInstr);
    SetCellData(id,rowid, "OrderInstrRowid", RowDataObj.OrderInstrRowid);
    SetCellData(id,rowid, "OrderHiddenPara", RowDataObj.OrderHiddenPara);
    SetCellData(id,rowid, "OrderSerialNum", RowDataObj.OrderSerialNum);
	var OrderPriorRowid=GetCellData(rowid, "OrderPriorRowid");
	if ((GlobalObj.PAAdmType=="I")&&(OrderPriorRowid==GlobalObj.ShortOrderPriorRowid)&&(RowDataObj.OrderDurRowid=="")){
		SetCellData(id,rowid, "OrderDur", GlobalObj.IPDefaultDur);
        SetCellData(id,rowid, "OrderDurRowid", GlobalObj.IPDefaultDurRowId);
        SetCellData(id,rowid, "OrderDurFactor", GlobalObj.IPDefaultDurFactor);
	}else{
		//疗程
        SetCellData(id,rowid, "OrderDur", RowDataObj.OrderDur);
        SetCellData(id,rowid, "OrderDurRowid", RowDataObj.OrderDurRowid);
        SetCellData(id,rowid, "OrderDurFactor", RowDataObj.OrderDurFactor);
	}
	//数量
    SetCellData(id,rowid, "OrderPackQty", RowDataObj.OrderPackQty);
	
	SetColumnList(id,rowid, "OrderPackUOM", RowDataObj.OrderPackUOMStr);
	SetCellData(id,rowid, "OrderPackUOMStr", RowDataObj.OrderPackUOMStr);
    SetCellData(id,rowid, "OrderPackUOM", RowDataObj.OrderPackUOMRowid); //OrderPackUOM
    SetCellData(id,rowid, "OrderPackUOMRowid", RowDataObj.OrderPackUOMRowid);
	
	//流速
	SetCellData(id,rowid, "OrderSpeedFlowRate", RowDataObj.OrderSpeedFlowRate);
	SetCellData(id,rowid, "OrderFlowRateUnit", RowDataObj.OrderFlowRateUnitRowId);
	SetCellData(id,rowid, "OrderFlowRateUnitRowId", RowDataObj.OrderFlowRateUnitRowId);	
}