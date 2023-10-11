var PageApplyTreeObj={
	PrintData:"",
	UserID:session['LOGON.USERID'],
	GroupID:session['LOGON.GROUPID'],
	CTLocID:session['LOGON.CTLOCID'],
	HospID:session['LOGON.HOSPID'],
	CureAssFlag:"CureAss",
	CureApplyFlag:"CureApply",
	CureAppendItemListDataGrid:"",
	CureEntryItemListDataGrid:"",	
	CureApplyListDataGrid:"",	
	editAILRow:undefined,
	CureEntryItemListDataObj:{
		CureItem:[],
		Length:0,
	},
	selAppDataObj:{
		AppendItem:[],
		Length:0,	
	},
	selAILDataObj:{CureAppItemID:"",CureAppItemDesc:"",CureAppItemQty:"",CureAppItemRecLocID:"",CureAppItemRecLoc:"",RecLocStr:"",TotalPrice:"",Price:""},
	editEntryItemRow:undefined,
    MainSreenFlag:websys_getAppScreenIndex()				//双屏标识
}

$(window).load(function(){
	LoadCureAppendItemListData("");
	LoadCureEntryItemListData(PageApplyTreeObj.CureEntryItemListDataObj);
	CureApplyListDataGridLoad();
	if ((ServerObj.PracticeCureCount>0)&&(ServerObj.ParaType!="CureAdvise")){
		ShowPracticeOrder();
	}
	if (ServerObj.RecLocByLogonLocFlag==1) {
		$("#FindLocByLog").checkbox("setValue",true);
	}
	
	if(ServerObj.ParaType=="OEOrdEntryUpdate"){
    	DisableAllElement();
    }
})

$(document).ready(function(){
	Init();
	InitEvent();
	PageHandle();
});

function Init(){
	//初始化绑定医嘱列表
	PageApplyTreeObj.CureAppendItemListDataGrid=InitCureAppendItemList();
	//初始化选定待添加医嘱列表
	PageApplyTreeObj.CureEntryItemListDataGrid=InitCureEntryItemList();
	InitApplyOrAss();
	//初始化已申请列表
	PageApplyTreeObj.CureApplyListDataGrid=InitCureApplyList();
	if(ServerObj.ParaType!="OEOrdEntryUpdate"){
		//初始化左侧树
		InitCureItemTree("");
	}else{
		LoadCureEntryItemListDataFromEntry();
	}
	//非医嘱录入审核弹框,隐藏"关闭按钮"
	if (ServerObj.ParaType!="OEOrdEntryUpdate") {
		$('#btnClose').hide();
	}
	//初始化医嘱类型、频次、疗程、费别
	InitOtherCombo();
	//处理界面上医嘱的默认信息
	SetCureItemDefault();
	//加载患者信息条
	if(ServerObj.EpisodeID){
		if(typeof InitPatInfoBanner=='function'){
			InitPatInfoBanner(ServerObj.EpisodeID); 
		}
	}else{
		showPatientList();
	}
	if (PageApplyTreeObj.MainSreenFlag==0){
	    var Obj={PatientID:ServerObj.PatientID,EpisodeID:ServerObj.EpisodeID,mradm:ServerObj.mradm,PageShowFromWay:"ApplyEntry"};
		websys_emit("onOpenCureInterface",Obj);
	}
}

function InitEvent(){
	$('#btnAddItem').bind("click",function(){
		AddToEntryItemList("N",function(data){
			LoadCureEntryItemListData(data);
		});	
	});	
	$('#btnUpdateItem').bind("click",function(){
		AddToEntryItemList("U",function(data){
			LoadCureEntryItemListData(data);
		});	
	});	
	$('#btnClose').bind("click",function(){
		websys_showModal("options").CallBackFunc("");
	});
	$('#btnPatBody').click(function(){
		com_openwin.ShowPatBody(ServerObj.DCARowId,"Y")
	})
	
	$('#OrderDoseQty').bind("blur",function(){
		OrderDoseQtyChange();
	});	
	$('#OrderDoseQty').bind("keydown",function(){
		OrderDoseQtyKeydown();
	});	
	
	$('#OrderQty').bind("blur",function(){
		OrderQtyChange();
	});	
	$('#OrderQty').bind("keydown",function(){
		OrderQtyKeydown();
	});	
	
	$HUI.numberbox("#OrderFirstDayTimes",{
		onChange:function(n,o){
			OrderFirstDayTimesChange();
		}
	});	
	$('#OrderFirstDayTimes').bind("keydown",function(){
		OrderFirstDayTimesKeydown();
	});	
	$HUI.checkbox("#FindLocByLog",{
		onCheckChange:function(e,value){
			FindByLogDepClick();
		}	
	})
	$HUI.checkbox("#OrderOpenForAllHosp",{
		onCheckChange:function(e,value){
			FindByLogDepClick();
		}	
	})
	document.onkeydown = Page_OnKeyDown;
}

function PageHandle(){
	SetPanelWidth();
	
	$("#OrderFreq").lookup({});
	$("#OrderDur").lookup({});
	var RowStyleObj={};
    if (ServerObj.CurrentDischargeStatus == "B") {
	    $.extend(RowStyleObj, {OrderStartDate:true,OrderDate:true});
	}else{
	    if (!CheckDateTimeModifyFlag(ServerObj.ModifySttDateTimeAuthority,"")) {
		    $.extend(RowStyleObj, { OrderStartDate:false});
	    }
	    if (!CheckDateTimeModifyFlag(ServerObj.ModifyDateTimeAuthority,"")) {
		    $.extend(RowStyleObj, { OrderDate:false});
	    } 
    }  
    ChangeElementStyle(RowStyleObj);
	ChangeBtnStyle("N");
}

function SetPanelWidth(){
	var Warning="";
	if(ServerObj.DCARowId==""){
		if((typeof(ServerObj.ControlWarning)!='undefined')&&(ServerObj.ControlWarning!="0")){
			Warning=$g("提示信息:")+$g(ServerObj.ControlWarning);
			ResetItemStyle();
		}
	}
	
	var ItemWidth=0; //计算textarea的宽度=首日次数(元素td).innerWidth()+费用(label td).innerWidth()+费用(元素td).width()
	var jObj=$(".td-toCalWidth");
	for(var i=0;i<jObj.length;i++){
		ItemWidth+=$(jObj[i]).innerWidth();
	}
	ItemWidth=ItemWidth+$("#OrderPrice").width();
	$(".form-table textarea").width(ItemWidth);
	$(".form-table-copy textarea").width(ItemWidth);
	if(Warning!=""){
		Warning=$g("治疗申请单")+" <font style='font-weight:bold;color:red'>"+Warning+"</font>"
		$("#item_panel").panel({title: Warning})
	}
}

function InitApplyOrAss(){
	if($("#ApplyOrAss").length>0){
		var KeyWordsArr=[{text:'治疗申请',id:PageApplyTreeObj.CureApplyFlag,selected:true}]
		if(ServerObj.ParaType!="CureAdvise") {
			KeyWordsArr.push({text:'治疗评定',id:PageApplyTreeObj.CureAssFlag})
		}
		$("#ApplyOrAss").keywords({
		    singleSelect:true,
		    labelCls:'red',
		    items:KeyWordsArr,
		    onClick:function(o){
			    var CureItemRowid=$("#ItemRowid").val();
				if(CureItemRowid!=""){
					$.messager.confirm("提示", "存在待添加的申请信息,是否切换并清空?",
					function(r){
						if(r){
							ChangeOrderPriorStyle(o.id);
							Clear_Mes()
			    			LoadCureItemTree();
						}else{
							$("#"+o.id).removeClass("selected");
							if(o.id==PageApplyTreeObj.CureApplyFlag){
								$("#"+PageApplyTreeObj.CureAssFlag).addClass("selected");	
							}else{
								$("#"+PageApplyTreeObj.CureApplyFlag).addClass("selected");	
							} 
							return false;
						}	
					});
				}else{
					ChangeOrderPriorStyle(o.id);
					LoadCureItemTree();
				}
				
			}
		});	
	}
}

function ChangeOrderPriorStyle(oid){
	if(oid==PageApplyTreeObj.CureApplyFlag){
		ChangeElementStyle({OrderPrior:true});
	}else{
		ChangeElementStyle({OrderPrior:false});	
		var OrderPriorRowid=$HUI.combobox("#OrderPrior").getValue();
		if(ServerObj.ShortOrderPriorRowid!=OrderPriorRowid){
			$HUI.combobox("#OrderPrior").setValue(ServerObj.ShortOrderPriorRowid);
		}
	}	
}

function GetApplyOrAss(){
	var ApplyOrAss="";
	if($("#ApplyOrAss").length>0){
		var ApplyOrAssObj=$("#ApplyOrAss").keywords("getSelected");
		var ApplyOrAss=ApplyOrAssObj[0].id;
	}
	return ApplyOrAss;
}

function FindByLogDepClick(){
	var icode=$('#ItemRowid').val();
	if(icode!=""){
		SetOrderHiddenPara();
		OrderRecLocCombCreat(icode,""); 
		ResetAppendItemListData();
	}
}
function ResetAppendItemListData(){
	if ($("#btnAddItem").is(":visible")) {
		var DDCISRowid=$('#DDCISRowid').val();
		LoadCureAppendItemListData(DDCISRowid);
	}else{
		var row=PageApplyTreeObj.CureEntryItemListDataGrid.datagrid('getSelected');
		if(row){
			LoadCureAppendItemListData(row.DDCISRowid,row.CureItemSelAppendItemObj);
		}
	}
}

function OrderDoseQtyChange(){
	var OrderDoseQty = $HUI.numberbox("#OrderDoseQty").getValue();
    OrderDoseQty=eval(OrderDoseQty);
    SetPackQty("OrderDoseQtyChange");
}

function OrderDoseQtyKeydown(){
	try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
    try {
        if ((keycode == 13) || (keycode == 9)) {
            var OrderType = $("#OrderType").val();
            var OrderDoseQty = $HUI.numberbox("#OrderDoseQty").getValue();
            var OrderARCIMRowid = $("#ItemRowid").val();
            if (OrderARCIMRowid != "") {
                var OrderPHPrescType = $("#OrderPHPrescType").val();
                if (OrderPHPrescType != "4") {
                }else{
	            	$("#OrderFreq").focus();    
	            }
            }
            return websys_cancel();
        }
    } catch (e) {}	
}

function OrderFirstDayTimesChange(){
	var OrderFirstDayTimes = $HUI.numberbox("#OrderFirstDayTimes").getValue();
    OrderFirstDayTimes=eval(OrderFirstDayTimes);
    SetPackQty("OrderFirstDayTimesChange");
}

function OrderFirstDayTimesKeydown(){
	try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
    try {
        if ((keycode == 13) || (keycode == 9)) {
            OrderFirstDayTimesChange();
            return websys_cancel();
        }
    } catch (e) {}	
}

function OrderQtyKeydown(){
	try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
    try {
        if ((keycode == 13) || (keycode == 9)) {
	        OrderQtyChange()
        }
    }catch (e) {}	
}

function OrderQtyChange(){
	try {
        var OrderPackQty = $HUI.numberbox("#OrderQty").getValue();
        var OrderARCIMRowid = $("#ItemRowid").val();
        var OrderPriorRowid = $("#OrderPrior").combobox('getValue');

        if (OrderPackQty == "") { OrderPackQty = 0 }
        if(isNaN(OrderPackQty)){
	        OrderPackQty=0;
	    }
        if (OrderARCIMRowid != "") {
            var OrderPrice = GetRecPrice();
            var OrderSum = parseFloat(OrderPrice) * parseFloat(OrderPackQty);
            if (OrderPackQty == 0) {
                var BaseDoseQtySum = $("#OrderBaseQtySum").val();
                if((typeof(BaseDoseQtySum)=="undefined")||(BaseDoseQtySum=="")){
	            	  BaseDoseQtySum=1;  
	            }
                var OrderConFac = $("#OrderConFac").val();
                var OrderSum = (parseFloat(OrderPrice) / parseFloat(OrderConFac)) * parseFloat(BaseDoseQtySum);
            }
            OrderSum = OrderSum.toFixed(4);
            $("#OrderPrice").val(OrderSum);
        }
    } catch (e) {}	
}

function ChangeBtnStyle(value){
	if(value=="Y"){
		$("#btnAddItem").hide();
	    $("#btnUpdateItem").show();	
	}else{
		$("#btnUpdateItem").hide();
		if (ServerObj.ParaType!="OEOrdEntryUpdate") {
	    	$("#btnAddItem").show();
	    }else{
		    $("#btnAddItem").hide();
		}
	}
}

function SetCureItemDefault(){
	if(ServerObj.PAAdmType=="I"){
		$("#OrderDur").val(ServerObj.IPDefaultDur);
		$("#OrderDurRowid").val(ServerObj.IPDefaultDurRowId);
		$("#OrderDurFactor").val(ServerObj.IPDefaultDurFactor);
		$HUI.lookup("#OrderDur").disable();
	}
}
//-------------治疗申请树开始-------------------------

function InitCureItemTree(value){
	var para=GetConfigDataPara();
	var tbox=$HUI.tree("#CureItemTree",{
		url:"doccure.config.data.csp?action=cure&para="+para,
		checkbox:false,
		onlyLeafCheck:true,
		onDblClick:function(node){
			var value=node.eleid.replace(/\^/g,String.fromCharCode(4));
			if ((value=="")||(value==undefined)) return false;
			//CureItemTreeClick(value);//双击节点，加载医嘱信息及绑定医嘱列表
		},
		formatter:function(node){
			if (node.eleid=="") return node.text;
			else {
				if (+node.RealStock=="0"){
					return '<span style="color:red">'+node.text+'</span>';
				}else if (+node.RealStock=="-1"){
					return '<span style="color:#808080">'+node.text+'</span>';
				}else{
					return node.text;
				}
			}
		},
		onClick: function(node){
			var isLeaf=$(this).tree('isLeaf',node.target)
			if (!isLeaf){
				$(this).tree('toggle',node.target)
			}else{
				var curId=$(this).tree('getNode',node.target).id;
				var isChecked=false;
				var value=node.eleid.replace(/\^/g,String.fromCharCode(4));
				if ((value=="")||(value==undefined)) return false;
				CureItemTreeClick(value);//双击节点，加载医嘱信息及绑定医嘱列表
			}
		}
	});
}

function LoadCureItemTree(){
	if(ClearTree()){
		var para=GetConfigDataPara();
		var myurl="doccure.config.data.csp?action=cure&para="+encodeURIComponent(para);
		$('#CureItemTree').tree('options').url=myurl;
		$HUI.tree("#CureItemTree").reload();
	}
}

function GetConfigDataPara(){
	var QryDesc=$("#QryArcDesc").searchbox("getValue");
	var QueryAllFlag="N";
	if(ServerObj.ParaType=="CureAdvise"){
		QueryAllFlag="Y";	
	}
	var ApplyOrAss=GetApplyOrAss();
	var Para=ServerObj.EpisodeID+"^"+PageApplyTreeObj.UserID+"^"+PageApplyTreeObj.GroupID+"^"+PageApplyTreeObj.CTLocID+"^"+PageApplyTreeObj.HospID+"^"+QryDesc+"^^"+QueryAllFlag+"^"+ApplyOrAss;	
	return Para;
}

function ClearTree(){
    var tbox=$HUI.tree("#CureItemTree");
    var roots=tbox.getRoots();
    for (var i=roots.length-1;i>=0;i--){
	  var node = tbox.find(roots[i].id);
	  tbox.remove(node.target);
    }
    return true
}
//-------------治疗申请树结束-------------------------
//-------------治疗申请医嘱信息开始-----------------------
function GetOneCureItemObj(){
	var ItemObj={};
	var CureItemRowid=$("#ItemRowid").val();
	if(CureItemRowid==""){
		if(ServerObj.ParaType=="OEOrdEntryUpdate"){
			$.messager.alert("提示", "请从右侧待添加列表双击选择一项治疗申请医嘱.","warning");
			return ItemObj;
		}else{
			$.messager.alert("提示", "请从左侧树正确选择一项治疗申请医嘱.","warning");
			return ItemObj;
		}
	}
	var CureItemArcDesc=$("#OrderArcimDesc").val();
	var CureItemPrior=$("#OrderPrior").combobox('getText');
	var CureItemPriorRowid=$("#OrderPrior").combobox('getValue');
	var CureItemPriorRowid=CheckComboxSelData("OrderPrior",CureItemPriorRowid);
	
	var CureItemFreq = $("#OrderFreq").val();
	var CureItemFreqRowid = $("#OrderFreqRowid").val();
	var CureItemFreqInterval = $("#OrderFreqInterval").val();
	var CureItemFreqFactor = $("#OrderFreqFactor").val();
	var CureItemFreqDispTimeStr = $("#OrderFreqDispTimeStr").val();
	if ($("#OrderFreq").lookup('getText')=="") {
		var CureItemFreq="",CureItemFreqRowid="",CureItemFreqInterval="",CureItemFreqFactor=1,CureItemFreqDispTimeStr="";
	}
	var CureItemDurRowid = $("#OrderDurRowid").val();
	var CureItemDur=$("#OrderDur").val();
	var CureItemDurFactor=$("#OrderDurFactor").val();
	if ($("#OrderDur").lookup('getText')=="") {
		var CureItemDurRowid="",CureItemDur="",CureItemDurFactor=1;
	}
	var CureItemDoseQty = $HUI.numberbox("#OrderDoseQty").getValue();
	var CureItemDoseUOM = $("#OrderDoseUOM").combobox('getValue');
	var CureItemDoseUOMDesc = $("#OrderDoseUOM").combobox('getText');
	var CureItemDoseUOM=CheckComboxSelData("OrderDoseUOM",CureItemDoseUOM);
	var CureItemRecLoc = $("#OrderReLoc").combobox('getText');
	var CureItemRecLocRowid = $("#OrderReLoc").combobox('getValue');
	var CureItemRecLocRowid=CheckComboxSelData("OrderReLoc",CureItemRecLocRowid);
	
	var CureItemPackQty = $HUI.numberbox("#OrderQty").getValue();
	var CureItemPackUOM = $("#BillingUOM").combobox('getValue');
	var CureItemPackUOM=CheckComboxSelData("BillingUOM",CureItemPackUOM);
	var CureItemPackUOMDesc=$("#BillingUOM").combobox('getText');
	var CureItemBillType= $("#OrderBillType").combobox('getText');
	var CureItemBillTypeRowId = $("#OrderBillType").combobox('getValue');
	var CureItemBillTypeRowId=CheckComboxSelData("OrderBillType",CureItemBillTypeRowId);
	var CureItemPrice = $("#OrderPrice").val();
	var CureItemFirstDayTimes = "";
	var obj=$HUI.numberbox("#OrderFirstDayTimes");
	if(($('#OrderFirstDayTimes').length && $('#OrderFirstDayTimes').length>0)){CureItemFirstDayTimes=obj.getValue();}
	var CureItemApplyPlan = $("#ApplyPlan").val();
	var CureItemApplyRemark = $("#ApplyRemark").val();
	var OrderPHPrescType = $('#OrderPHPrescType').val();
	var OrderType = $('#OrderType').val();
	var OrderDoseStr = $('#OrderDoseStr').val();
	var DDCISRowid = $('#DDCISRowid').val();
	var CureItemConFac=$('#OrderConFac').val();
	var CureItemStartDate=$('#OrderStartDate').datetimebox("getValue");
	var CureItemEndDate=$('#OrderEndDate').datetimebox("getValue");
	var CureItemCoverMainIns=$("#CureItemCoverMainIns").checkbox('getValue');
	CureItemCoverMainIns=CureItemCoverMainIns?"Y":"N";
	var ChronicDiagDesc="",ChronicDiagCode="";
	if ($("#ChronicDiag").length>0){
		ChronicDiagDesc=$("#ChronicDiag").lookup("getText");
		ChronicDiagCode=GetChronicDiagCode();
	}
	if (ServerObj.InsurBillStr.indexOf("^"+CureItemBillTypeRowId+"^")==-1){
    	ChronicDiagCode="",ChronicDiagDesc="";
    }
    var CureItemAssScaleID=$('#CureAssScaleID').val();
	var CureItemSelAppendItemObj=GetSelAppendItemObj();
	var CureItemPOAInfo=$('#CureItemPOAInfo').val();
	var OrderHiddenPara=$('#CureItemHiddenPara').val();
	var CureItemAppendCount=CureItemSelAppendItemObj.Length;
	var ApplyOrAssFlag=true;
	var ApplyOrAss=GetApplyOrAss();
	if(ApplyOrAss==PageApplyTreeObj.CureAssFlag){
		ApplyOrAssFlag=false;
	}
	ItemObj={
		CureItemRowid:CureItemRowid,
		CureItemArcDesc:CureItemArcDesc,		
		OrderPHPrescType:OrderPHPrescType,
		CureItemConFac:CureItemConFac,
		OrderType:OrderType,
		OrderDoseStr:OrderDoseStr,
		CureItemPrior:CureItemPrior,
		CureItemPriorRowid:CureItemPriorRowid,
		CureItemFreq:CureItemFreq,
		CureItemFreqRowid:CureItemFreqRowid,
		CureItemFreqInterval:CureItemFreqInterval,
		CureItemFreqFactor:CureItemFreqFactor,
		CureItemFreqDispTimeStr:CureItemFreqDispTimeStr,
		CureItemDurRowid:CureItemDurRowid,
		CureItemDur:CureItemDur,
		CureItemDurFactor:CureItemDurFactor,
		CureItemDoseQty:CureItemDoseQty,
		CureItemDoseUOMDesc:CureItemDoseUOMDesc,
		CureItemDoseUOM:CureItemDoseUOM,
		CureItemRecLoc:CureItemRecLoc,
		CureItemRecLocRowid:CureItemRecLocRowid,
		CureItemPackQty:CureItemPackQty,
		CureItemPackUOMDesc:CureItemPackUOMDesc,
		CureItemPackUOM:CureItemPackUOM,
		CureItemBillType:CureItemBillType,
		CureItemPrice:CureItemPrice,
		CureItemStartDate:CureItemStartDate,
		CureItemEndDate:CureItemEndDate,
		CureItemBillTypeRowId:CureItemBillTypeRowId,
		CureItemFirstDayTimes:CureItemFirstDayTimes,
		CureItemApplyPlan:CureItemApplyPlan,
		CureItemApplyRemark:CureItemApplyRemark,
		CureItemCoverMainIns:CureItemCoverMainIns,
		DDCISRowid:DDCISRowid,
		ChronicDiagCode:ChronicDiagCode,
		ChronicDiagDesc:ChronicDiagDesc,
		CureItemHiddenPara:OrderHiddenPara,
		CureItemSelAppendItemObj:CureItemSelAppendItemObj,
		CureItemAppendCount:CureItemAppendCount,
		CureItemApplyOrAss:ApplyOrAssFlag, //true为申请，false为评定
		CureItemAssScaleID:CureItemAssScaleID,
		CureItemPOAInfo:CureItemPOAInfo //治疗部位/穴位选择信息
	}
	
	return ItemObj;
}
//添加治疗医嘱信息到待添加列表
//update:N 新增 U 更新
function AddToEntryItemList(update,callback){
	var CureItemObj=GetOneCureItemObj();
	if((CureItemObj.CureItemRowid=="")||(CureItemObj.CureItemRowid==undefined)){
		return false;	
	}
	new Promise(function(resolve,rejected){
		CheckBeforeAdd(CureItemObj,resolve);
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			if (!rtn) return false;
			if((typeof(CureItemObj.CureItemRowid)=="undefined")||(CureItemObj.CureItemRowid=="")){
				return false;
			}			
			if(update=="N"){
				var FindSameFlag=false;
				for (var i=0;i<PageApplyTreeObj.CureEntryItemListDataObj.Length;i++) {
					var tmpCureItemRowid=PageApplyTreeObj.CureEntryItemListDataObj.CureItem[i].CureItemRowid;
					if(CureItemObj.CureItemRowid==tmpCureItemRowid){
						FindSameFlag=true; //dhcsys_confirm($g("该治疗申请已经存在待添加列表,是否继续添加?"));
						break;	
					}
				}
				if(FindSameFlag){
					$.messager.confirm("提示",$g("该治疗申请已经存在待添加列表中,是否继续添加?"),function(r){
						if(r){
							resolve();	
						}else{
							return false;
						}	
					})
				}else{
					resolve();		
				}
			}else{
				resolve();	
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			//检查部位/穴位信息
			CheckPOA(CureItemObj,resolve);
		})
	}).then(function(CureItemObj){
		PageApplyTreeObj.CureEntryItemListDataObj.Length=PageApplyTreeObj.CureEntryItemListDataObj.Length+1;
		//新增则往数组里添加元素
		//修改则替换元素
		if(update=="N"){
			CureItemObj.CureItemSeqNo=PageApplyTreeObj.CureEntryItemListDataObj.Length;
			PageApplyTreeObj.CureEntryItemListDataObj.CureItem.push(CureItemObj);
		}else{
			var tmpobj=PageApplyTreeObj.CureEntryItemListDataObj;
			tmpobj.Length=tmpobj.Length-1;
			CureItemObj.CureItemSeqNo=tmpobj.CureItem[PageApplyTreeObj.editEntryItemRow].CureItemSeqNo;
			CureItemObj.OrderPracticePre=tmpobj.CureItem[PageApplyTreeObj.editEntryItemRow].OrderPracticePre;
			CureItemObj.CureItemOrderDate=tmpobj.CureItem[PageApplyTreeObj.editEntryItemRow].CureItemOrderDate;
			tmpobj.CureItem.splice(PageApplyTreeObj.editEntryItemRow,1,CureItemObj);
			
			$.extend(PageApplyTreeObj.CureEntryItemListDataObj,tmpobj);
		}
		var tmpobjJson=JSON.stringify(PageApplyTreeObj.CureEntryItemListDataObj);
		callback(PageApplyTreeObj.CureEntryItemListDataObj);
		Clear_Mes();
	})
}
function InitOtherCombo(){
	OrderFreqLookup();
	OrderIndurLookup();
	OrderPriorityCombCreat();
	OrderBillTypeCombCreat();
	//初始化慢病病种LookUp
    InitChronicDiagLookUp();
}
//医嘱类型
function OrderPriorityCombCreat(){
	if(ServerObj.OrderPriorStr!=""){
		var OrderPriorityArr=new Array();
		var ArrData = ServerObj.OrderPriorStr.split("^");
		for (var i = 0; i < ArrData.length; i++) {
			var ArrData1 = ArrData[i].split(String.fromCharCode(1))
			var value=ArrData1[0];
			var code=ArrData1[1];
			var desc=ArrData1[2];
			if((code!="NORM")&&(code!="S")){
				continue;
			}
			var defaultflag=0;	
			if(value==ServerObj.DefaultOrderPriorRowid){
				//defaultflag=1;	
			}
			if(code=="NORM"){
				defaultflag=1;	
			}
			var data = {"CombValue":value, "CombDesc":desc, "selected":defaultflag};
			OrderPriorityArr.push(data);
		}
		$HUI.combobox("#OrderPrior",{
			valueField:'CombValue',   
	    	textField:'CombDesc',
	    	data: OrderPriorityArr,
	    	editable:false,
	    	onLoadSuccess:function(data){
		    	var DefPrior="";
		    	for(var i=0;i<data.length;i++){
			    	if(data[i].selected==1){
				    	var DefPrior = data[i].CombValue;
				    	break;
				    }
			    }
			    if((DefPrior=="")&&(data.length==1)){
					DefPrior=data[0].CombValue;    
				}
		    	if(DefPrior!=""){$HUI.combobox("#OrderPrior").setValue(DefPrior);}
		    },onChange:function(){
			    if(ServerObj.ParaType!="OEOrdEntryUpdate"){
				    OrderPriorityChange({
						ResetReclocFlag:"Y"
					});
			    }
			}
		})	
	}
}
function OrderPriorityChange(ChangeStyleConfig){
	var ChangeStyleObj=$.extend({
			IsNotChangeQtyStyle:"",
			IsNotChangeQty:"",
			ResetReclocFlag:"",
			oid:"",
	},ChangeStyleConfig);
	if(ChangeStyleObj.oid!=""){
		var ApplyOrAss=ChangeStyleObj.oid;
	}else{
		var ApplyOrAss=GetApplyOrAss();
	}
	var itemrowid=$("#ItemRowid").val();
	if(ApplyOrAss==PageApplyTreeObj.CureAssFlag){
		var StyleConfigObj = {
			OrderPrior:false,
			OrderStartDate:false,
			OrderEndDate:false,
	        OrderDur: false,
	        OrderFreq: false,
	        OrderQty: false,
	        BillingUOM: false,
	        OrderDoseQty: false,
	        OrderDoseUOM: false,
	        OrderFirstDayTimes: false
	    }
		ChangeElementStyle(StyleConfigObj);	
		OrderRecLocCombCreat(itemrowid,"");
		return;
	}
			
	var PriorRowid=$("#OrderPrior").combobox('getValue');	
	var OrderFreqRowid = $("#OrderFreqRowid").val();
	var OrderType = $("#OrderType").val();
	var OrderPHPrescType = $("#OrderPHPrescType").val();
	var OrderDoseStr=$("#OrderDoseStr").val();
	var OrderDoseQty=$HUI.numberbox("#OrderDoseQty").getValue();
    if ((PriorRowid == ServerObj.LongOrderPriorRowid) && ((OrderFreqRowid == ServerObj.STFreqRowid) || (OrderFreqRowid == ServerObj.ONCEFreqRowid))) {
        ClearOrderFreq();
    }
    var StyleObj = {};
    if (ServerObj.PAAdmType == "I") {
        if (PriorRowid != ServerObj.LongOrderPriorRowid){
	        $('#OrderEndDate').datetimebox("setValue","");
	        if(((OrderFreqRowid != ServerObj.STFreqRowid) || (OrderFreqRowid == ServerObj.ONCEFreqRowid))
	       		&&(ServerObj.IPShortOrderPriorDefFreqID!="")) {
	            var myobj={
					OrderFreq:ServerObj.IPShortOrderPriorDefFreq,
					OrderFreqFactor:"1",
					OrderFreqInterval:"",
					OrderFreqRowid:ServerObj.IPShortOrderPriorDefFreqID,
					WeekFlag:"",
					FreeTimeFreqFlag:"",
					OrderFreqDispTimeStr:""
				}
				SetOrderFreq(myobj,ChangeStyleObj.IsNotChangeQty);
	        }
            $.extend(StyleObj, { OrderFirstDayTimes: false});
            SetCureItemDefault();
        }else{
            $.extend(StyleObj, { OrderFirstDayTimes: true}); 
            ClearOrderDur();
	    }
    }else{
	    if((OrderFreqRowid == ServerObj.STFreqRowid) || (OrderFreqRowid == ServerObj.ONCEFreqRowid)) {
            $.extend(StyleObj, { OrderDur: false});
	    }
	}
	
	new Promise(function(resolve,rejected){
		var OrderRecLocRowid = $("#OrderReLoc").combobox('getValue');
		var OrderRecLocRowid=CheckComboxSelData("OrderReLoc",OrderRecLocRowid);
		if(ChangeStyleObj.ResetReclocFlag=="Y"){
			OrderRecLocCombCreat(itemrowid,OrderRecLocRowid,resolve);
		}else{
			resolve(OrderRecLocRowid);
		}
	}).then(function(ret){
		var OrderRecLocRowid = ret;
		var ParamObj = {
			icode: itemrowid,
			OrderType: OrderType,
			OrderPHPrescType: OrderPHPrescType,
			OrderPriorRowid: PriorRowid,
			OrderFreqRowid: OrderFreqRowid,
			OrderRecLocRowid: OrderRecLocRowid,
			idoseqtystr:OrderDoseStr
	    }
	    var StyleConfigObj=GetStyleConfigObj(ParamObj);
	    $.extend(StyleObj, StyleConfigObj); 
		if(ChangeStyleObj.IsNotChangeQtyStyle!="Y"){
			if(!StyleObj.OrderDoseQty){
				$HUI.numberbox("#OrderDoseQty").setValue("");
			}
		}
		ChangeElementStyle(StyleObj);
		if(!StyleObj.OrderFirstDayTimes){
			com_Util.SetComboVal("OrderFirstDayTimes","");
		}else{
			SetOrderFirstDayTimes();	
		}
		var OrderPackQtyObj = ContrlOrderPackQty(ParamObj,ChangeStyleObj);
	    //if(ChangeStyleObj.IsNotChangeQtyStyle!="Y"){ChangeElementStyle(OrderPackQtyObj);}
	    ChangeElementStyle(OrderPackQtyObj);
	    ResetAppendItemListData();
	    var OrderDoseUOMRowid = $HUI.combobox("#OrderDoseUOM").getValue();
		var OrderPackUOMRowid = $HUI.combobox("#BillingUOM").getValue();
	    if (((ChangeStyleObj.IsNotChangeQtyStyle!="Y")||(StyleConfigObj.OrderDoseQty))&&((OrderDoseUOMRowid==""))&&(OrderPackUOMRowid!="")){
		    var OrderDoseStr=$.cm({
			    ClassName:"DHCDoc.DHCDocCure.Config",
			    MethodName:"GetDoseStr",
			    itemrowid:itemrowid,
			    PackUOMRowid:OrderPackUOMRowid,
			    dataType:"text"
			},false)
	    	OrderDoseUOMCombCreat(OrderDoseStr,"");
	    	$HUI.numberbox("#OrderDoseQty").setValue(OrderDoseQty);
	    }
	})
}

function ClearOrderFreq() {
    $("#OrderFreq").val("");
    $("#OrderFreqFactor").val("1");
    $("#OrderFreqInterval").val("");
    $("#OrderFreqRowid").val("");
    $("#OrderFreqDispTimeStr").val("");
}

function SetOrderFreq(obj,NotSetPackQty) {
	if(typeof(obj)!="undefined"){
		var OrderFreq=obj.OrderFreq;
		var OrdWeekFreqDispTimeStr=obj.OrderFreqDispTimeStr;
	    $("#OrderFreq").val(OrderFreq);
	    $("#OrderFreqFactor").val(obj.OrderFreqFactor);
	    $("#OrderFreqInterval").val(obj.OrderFreqInterval);
	    $("#OrderFreqRowid").val(obj.OrderFreqRowid);
	    $("#OrderFreqDispTimeStr").val(obj.OrderFreqDispTimeStr);
	    new Promise(function(resolve,rejected){
	    	FrequencySelectHandle(obj,resolve);
	    }).then(function(){
		    if(NotSetPackQty!="Y"){
			   SetPackQty("FrequencySelectHandle"); 
			}
	    })
	}
}
//频次
function OrderFreqLookup(){
	$("#OrderFreq").lookup({
		//width:130,
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'Desc',
        columns:[[  
           {field:'Desc',title:'频次名称',width:140,sortable:true},
           {field:'Code',title:'频次编码',width:120,sortable:true}
        ]],
        pagination:true,
        panelWidth:300,
        panelHeight:350,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderCommon',QueryName: 'LookUpFrequency'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
		    var OrderPriorRowid=$("#OrderPrior").combobox('getValue');	
			param = $.extend(param,{desc:desc,PAAdmType:ServerObj.PAAdmType,UserID:session["LOGON.USERID"],OrderPriorRowid:OrderPriorRowid});
	    },onSelect:function(ind,item){
		    var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			});
			FrequencyLookUpSelect(ItemArr.join("^"));
		},onHidePanel:function(){
			PageApplyTreeObj.LookupPanelIsShow=0;
		},onShowPanel:function(){
			PageApplyTreeObj.LookupPanelIsShow=1;
		},onBeforeShowPanel:function(){
			$(this).lookup('panel').panel('resize',{width:300});
		}
    });	
}
function FrequencyLookUpSelect(value){
	var Split_Value = value.split("^");
    var OrderFreq = Split_Value[0];
    var OrderFreqFactor = Split_Value[2];
    var OrderFreqInterval = Split_Value[3];
    var OrderFreqRowid = Split_Value[4];
    var OrderFreqDispTimeStr = Split_Value[5];
    var WeekFlag = Split_Value[6];
    var NoDelayExe = Split_Value[7];
    var FreeTimeFreqFlag = Split_Value[8];
    var OrderPriorRowid = $("#OrderPrior").combobox('getValue');	
    var OldPriorRowid = OrderPriorRowid
	
	var FreqObj={
		OrderFreq:OrderFreq,
		OrderFreqFactor:OrderFreqFactor,
		OrderFreqInterval:OrderFreqInterval,
		OrderFreqRowid:OrderFreqRowid,
		OrderFreqDispTimeStr:OrderFreqDispTimeStr,
		WeekFlag:WeekFlag,
		FreeTimeFreqFlag:FreeTimeFreqFlag
	}
	SetOrderFreq(FreqObj);
}

function FrequencySelectHandle(FreqObj,callBackFun){
	new Promise(function(resolve,rejected){
		var OrderFreqDispTimeStr="",FreqWeekDesc="";
		//周频次需要弹窗并重算医嘱开始时间
		if (FreqObj.WeekFlag=="Y"){
			new Promise(function(resolve,rejected){
				GetOrderFreqWeekStr(FreqObj.OrderFreqRowid,FreqObj.OrderFreqDispTimeStr,resolve);
			}).then(function(OrderFreqWeekInfo){
				var OrderFreqDispTimeStr=mPiece(OrderFreqWeekInfo, "^", 0);
				if (OrderFreqDispTimeStr==""){
					ClearOrderFreq()
		            $.messager.alert("警告","周频次请务必选择使用周数","warning");
		            return;
				}
				var OrderFreqWeekDesc=mPiece(OrderFreqWeekInfo, "^", 1);
				var CalOrderStartDateStr=mPiece(OrderFreqWeekInfo, "^", 2);
				$("#OrderFreqDispTimeStr").val(OrderFreqDispTimeStr);
				FreqObj.OrderFreq=FreqObj.OrderFreq+" "+OrderFreqWeekDesc;
				$("#OrderFreq").val(FreqObj.OrderFreq);
				$("#OrderStartDate").datetimebox("setValue",CalOrderStartDateStr);
				resolve();
			})
		}else if (FreqObj.FreeTimeFreqFlag=="Y"){
			(function(callBackFunExec){
				//不规则分发时间
			    new Promise(function(resolve,rejected){
					GetOrderFreqFreeTimeStr(FreqObj.OrderFreqRowid,FreqObj.OrderFreqDispTimeStr,resolve);
				}).then(function(OrderFreqFreeTimeInfo){
					var OrderFreqDispTimeStr=mPiece(OrderFreqFreeTimeInfo, "^", 0);
					if (OrderFreqDispTimeStr==""){
						ClearOrderFreq();
			            $.messager.alert("提示","不规则分发时间频次请务必选择分发时间!","warning");
			            return;
					}
					var OrderFreqFactor=OrderFreqDispTimeStr.split(String.fromCharCode(1)).length;
					var OrderFreqWeekDesc=mPiece(OrderFreqFreeTimeInfo, "^", 1);
					$("#OrderFreqDispTimeStr").val(OrderFreqDispTimeStr);
					FreqObj.OrderFreq=FreqObj.OrderFreq+" "+OrderFreqWeekDesc;
					$("#OrderFreq").val(FreqObj.OrderFreq);
					$("#OrderFreqFactor").val(OrderFreqFactor);
					callBackFunExec();
				})
			})(resolve);
		}else{
			$("#OrderFreqDispTimeStr").val(FreqObj.OrderFreqDispTimeStr);
			resolve();
		}
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if ((+FreqObj.OrderFreqInterval!="0")&&(ServerObj.PAAdmType != "I")){
		        var rtn=tkMakeServerCall("web.DHCDocOrderCommon", "GetFirstDurByWeekFreq", FreqObj.OrderFreqInterval, FreqObj.OrderFreqRowid);
		        var OrderDurRowid=rtn.split(",")[0];
		        var OrderDur=rtn.split(",")[1];
		        var OrderDurFactor=rtn.split(",")[3];
		        var CurrentOrderDurFactor=$("#OrderDurFactor").val();
		        if ((OrderDurRowid!="")&&((+CurrentOrderDurFactor)<(+OrderDurFactor))){
			        $("#OrderDur").val(OrderDur);
					$("#OrderDurRowid").val(OrderDurRowid);
					$("#OrderDurFactor").val(OrderDurFactor);
		        }
		    }
			SetOrderFirstDayTimes();
			FreqDurChange(FreqObj);
			resolve();
		})
	}).then(function(){
		callBackFun();
	})
}
function GetOrderFreqWeekStr(OrderFreqRowid,OrderFreqDispTimeStr,callBackFun){
	OrderFreqDispTimeStr=OrderFreqDispTimeStr.split(String.fromCharCode(1)).join("A");
	OrderFreqDispTimeStr=OrderFreqDispTimeStr.split(String.fromCharCode(2)).join("B");
	OrderFreqDispTimeStr=OrderFreqDispTimeStr.replace(/:/g,"C");
	websys_showModal({
		url:"doc.weekfreqselector.csp?OrderFreqDispTimeStr=" + OrderFreqDispTimeStr+"&OrderFreqRowid="+OrderFreqRowid,
		title:'周频次选择',
		width:300,height:410,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if (typeof result=="undefined"){
				result="";
			}
			callBackFun(result);
		}
	})
}
/**
* @description: 让用户选择不规则分发时间频次的分发时间并返回
* @param {String} 
* @return: {String} 
*/
function GetOrderFreqFreeTimeStr(OrderFreqRowid,OrderFreqDispTimeStr,callBackFun){
	var OrderFreqDispTimeStr=OrderFreqDispTimeStr.split(String.fromCharCode(1)).join("A");
	OrderFreqDispTimeStr=OrderFreqDispTimeStr.split(String.fromCharCode(2)).join("B");
	OrderFreqDispTimeStr=OrderFreqDispTimeStr.replace(/:/g,"C");
	websys_showModal({
		url:"dhcdoc.freq.disptime.csp?OrderFreqDispTimeStr=" + OrderFreqDispTimeStr+"&OrderFreqRowid="+OrderFreqRowid,
		title:'分发时间选择',
		width:370,height:410,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if (typeof result=="undefined"){
				result="";
			}
			callBackFun(result);
		}
	})
	
}
function FreqDurChange(obj)
{
	var OrderFreqRowid=obj.OrderFreqRowid;
	var StyleObj=GetSpecDurStyleByFreq(OrderFreqRowid);
	ChangeElementStyle(StyleObj);
}
function GetSpecDurStyleByFreq(OrderFreqRowid){
	var styleConfigObj = {}
	//ST即刻医嘱不允许录入其他疗程只能是1天
    if (ServerObj.PAAdmType != "I"){
        if (OrderFreqRowid == ServerObj.STFreqRowid || OrderFreqRowid == ServerObj.ONCEFreqRowid){
            var OneDayDur=ServerObj.OneDayDur;
            if (ServerObj.OneDayDur!=""){
                var OrderDurRowid=ServerObj.OneDayDur.split(",")[0];
                var OrderDur=ServerObj.OneDayDur.split(",")[1];
                var OrderDurFactor=ServerObj.OneDayDur.split(",")[3];
				var myobj={
					OrderDur:OrderDur,
					OrderDurRowid:OrderDurRowid,
					OrderDurFactor:OrderDurFactor,
				}
				SetOrderDur(myobj)	
                styleConfigObj = { OrderDur: false }
            }
        }else{
            var OrderARCIMRowid = $("#ItemRowid").val();
			if (OrderARCIMRowid!=""){
				var rtn=tkMakeServerCall("web.DHCDocOrderCommon","CanFrequenc",OrderARCIMRowid);
				if (rtn=="Y"){
					styleConfigObj = { OrderDur: true }
				}else{
					styleConfigObj = { OrderDur: false }
				}
			}
            
        }
    }
    return styleConfigObj;	
}

function ClearOrderDur(rowid) {
	$("#OrderDur").val("");
    $("#OrderDurFactor").val("1");
    $("#OrderDurRowid").val("");
}

function SetOrderDur(obj){
	if(typeof(obj)!="undefined"){
		$("#OrderDur").val(obj.OrderDur);
	    $("#OrderDurFactor").val(obj.OrderDurFactor);
	    $("#OrderDurRowid").val(obj.OrderDurRowid);	
	}
}
//疗程
function OrderIndurLookup(){
	$("#OrderDur").lookup({
		//width:120,
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'CTPCPDesc',
        columns:[[  
           {field:'CTPCPDesc',title:'疗程',width:140,sortable:true},
           {field:'CTPCPCode',title:'编码',width:120,sortable:true}
        ]],
        pagination:true,
        panelWidth:300,
        panelHeight:300,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderCommon',QueryName: 'LookUpDuration'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{desc:desc});
	    },onSelect:function(ind,item){
		    var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			});
			DurationLookUpSelect(ItemArr.join("^"));
		},onHidePanel:function(){
			PageApplyTreeObj.LookupPanelIsShow=0;
		},onShowPanel:function(){
			PageApplyTreeObj.LookupPanelIsShow=1;
		},onBeforeShowPanel:function(){
			$(this).lookup('panel').panel('resize',{width:300});
		}
    });	
}

function DurationLookUpSelect(value){
	var Split_Value = value.split("^");
	var OrderDur = unescape(Split_Value[1]);
    var OrderDurRowid = Split_Value[0];
    var OrderDurFactor = Split_Value[3];
    if (Split_Value.length == 5) { rowid = Split_Value[4] }
    var myobj={
		OrderDur:OrderDur,
		OrderDurRowid:OrderDurRowid,
		OrderDurFactor:OrderDurFactor,
	}
    SetOrderDur(myobj);
    SetPackQty("DurationLookUpSelect");
}

function SetPackQty(val) {
    var OrderARCIMRowid = $('#ItemRowid').val();
    if (OrderARCIMRowid == "") return true;
	var OrderPHPrescType=$('#OrderPHPrescType').val();
    var OrderType = $('#OrderType').val();
    var OrderConFac = $('#OrderConFac').val();
    var OrderPrice = $('#OrderPrice').val();;
    OrderPrice = OrderPrice.replace(/(^\s*)|(\s*$)/g, '');
    var retPrice = GetRecPrice()
    if (retPrice==undefined) retPrice="0^0^0^0^0";
    var ArrPrice = retPrice.split("^");
    var OrderPrice = ArrPrice[0];
    var OrderFirstDayTimes="";
    //if(ServerObj.ParaType=="I"){
	    OrderFirstDayTimes=$HUI.numberbox("#OrderFirstDayTimes").getValue();
	    if(OrderFirstDayTimes=="")SetOrderFirstDayTimes();
		//if(OrderFirstDayTimes=="")OrderFirstDayTimes=0;
		if(OrderFirstDayTimes) OrderFirstDayTimes=parseFloat(OrderFirstDayTimes);
    //}
	
    var OrderPriorRowid = $("#OrderPrior").combobox('getValue');
	var OrderDoseQty = $HUI.numberbox("#OrderDoseQty").getValue();
	var OrderDoseUOMRowid = $HUI.combobox("#OrderDoseUOM").getValue();
	var OrderFreqRowid = $('#OrderFreqRowid').val();
	var OrderDurRowid = $('#OrderDurRowid').val();
	var OrderPackQty = $HUI.numberbox("#OrderQty").getValue();
	var OrderPackUOMRowid = $HUI.combobox("#BillingUOM").getValue();	
    var OrderStartDate = $('#OrderStartDate').datetimebox("getValue");
    var OrderMultiDate = "";
	var OrderFreqDispTimeStr= $('#OrderFreqDispTimeStr').val();
	var OrderRecDepRowid = $("#OrderReLoc").combobox('getValue');
	//var OrderARCOSRowid= GetCellData(Row, "OrderARCOSRowid");
	//if ((OrderARCOSRowid!="")&&(+OrderPackQty!=0)){
	//	$.extend(SetPackQtyConfigObj, { IsNotNeedChangeFlag: "Y"});
	//}
	var OrderFreqTimeDoseStr="";
    /*
	后台获取数量、基本数量总数等计算值
	*/
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
		OrderFreqDispTimeStr:OrderFreqDispTimeStr,
		OrderFirstDayTimes:OrderFirstDayTimes,
		IsNotChangeFirstDayTimeFlag:"N",
		IsNotNeedChangeFlag:"N",
		OrderFreqTimeDoseStr:OrderFreqTimeDoseStr,
		OrderRecDepRowid:OrderRecDepRowid,
		SessionStr:GetSessionStr()
	};
	
	var OrdParamJson=JSON.stringify(OrdParamObj);
	var CalPackQtyJson = cspRunServerMethod(ServerObj.CalPackQtyMethod,OrdParamJson);
	var CalPackQtyObj=jQuery.parseJSON(CalPackQtyJson);
	//计算数量后进行前台脚本运行
	if ((typeof CalPackQtyObj.CallBackFunStr !="undefined")&&(CalPackQtyObj.CallBackFunStr !="")){
		var CallBackFunArr=CalPackQtyObj.CallBackFunStr.split(String.fromCharCode(2));
		for (var i = 0; i < CallBackFunArr.length; i++) {
			var SingleCallBackFun=CallBackFunArr[i];
			if (SingleCallBackFun=""){continue;}
			var CallBakFunCode=mPiece(SingleCallBackFun,"^",0)
			var CallBakFunParams=mPiece(SingleCallBackFun,"^",1)
			if (CallBakFunCode=="ReSetPackQty1"){
				var CallBakFunParamsArr=CallBakFunParams.split(";");
				if (dhcsys_confirm(CallBakFunParamsArr[0], false)) {
					var PackQty=CallBakFunParamsArr[1];
					var OrderSum=CallBakFunParamsArr[2];
					$.extend(CalPackQtyObj, { OrderPackQty: PackQty,OrderSum:OrderSum});
				}
			}else if (CallBakFunCode=="ReSetPackQty2"){
				var CallBakFunParamsArr=CallBakFunParams.split(";");
				if (dhcsys_confirm(CallBakFunParamsArr[0], false)) {
					var PackQty=CallBakFunParamsArr[1];
					var OrderSum=CallBakFunParamsArr[2];
					var BaseDoseQty=CallBakFunParamsArr[3];
					var BaseDoseQtySum=CallBakFunParamsArr[4];
					$.extend(CalPackQtyObj, { OrderPackQty: PackQty,OrderSum:OrderSum,OrderBaseQty:BaseDoseQty,OrderBaseQtySum:BaseDoseQtySum});
				}
			}
		}
	}
	
	if (typeof CalPackQtyObj.OrderPackQty !="undefined"){
		$HUI.numberbox("#OrderQty").setValue(CalPackQtyObj.OrderPackQty);
	}
	if (typeof CalPackQtyObj.OrderBaseQty !="undefined"){
		$("#OrderBaseQty").val(CalPackQtyObj.OrderBaseQty);
	}
	if (typeof CalPackQtyObj.OrderBaseQtySum !="undefined"){
		$("#OrderBaseQtySum").val(CalPackQtyObj.OrderBaseQtySum);
	}
	if (typeof CalPackQtyObj.OrderSum !="undefined"){
		$("#OrderPrice").val(CalPackQtyObj.OrderSum);
	}
    //CheckFreqAndPackQty(Row);
    if (OrderPriorRowid == ServerObj.LongOrderPriorRowid){
    	if (OrderPHPrescType == "4") {
            $HUI.numberbox("#OrderQty").setValue("");
        } else{
	    	if (OrderType!="R"){
			    var OrderPackQtyObj = document.getElementById("OrderPackQty");
			    if (OrderPackQtyObj && (OrderPackQtyObj.disabled == true)) {
				    $HUI.numberbox("#OrderQty").setValue("");
				}
	    	}
		}
	}
    return true;
}

function SetOrderFirstDayTimes() {
	var OrderARCIMRowid = $('#ItemRowid').val();
    var OrderPriorRowid = $("#OrderPrior").combobox('getValue');
    var OrderFreqRowid = $('#OrderFreqRowid').val();
    var OrderStartDate=$('#OrderStartDate').datetimebox("getValue");
	var OrderFreqDispTimeStr = $('#OrderFreqDispTimeStr').val();
	var LinkedMasterOrderPriorRowid="";
	var FirstDayTimes=cspRunServerMethod(ServerObj.GetOrderFirstDayTimesMethod,ServerObj.EpisodeID, OrderARCIMRowid, OrderFreqRowid, OrderPriorRowid, OrderStartDate, LinkedMasterOrderPriorRowid,OrderFreqDispTimeStr);
	var OrderFirstDayTimes=FirstDayTimes.split("^")[0];
	var Editable=FirstDayTimes.split("^")[1];
	com_Util.SetComboVal("OrderFirstDayTimes",OrderFirstDayTimes);
	if(Editable=='N'){
		ChangeElementStyle({OrderFirstDayTimes:false});
	}else{
		ChangeElementStyle({OrderFirstDayTimes:true});
	}
}

function GetRecPrice() {
    var OrderBillTypeRowid=$("#OrderBillType").combobox('getValue');
    var OrderARCIMRowid = $('#ItemRowid').val();
    var OrderOpenForAllHosp = "";
    var OrderPackUOMRowid = $HUI.combobox("#BillingUOM").getValue();
    if (OrderPackUOMRowid == "") return;
    var OrderRecDepRowid = $("#OrderReLoc").combobox('getValue');
    var LogonDep = "";FindRecLocByLogonLoc = 0;
    //if ($("#FindByLogDep").checkbox("getValue")){
	//    FindRecLocByLogonLoc=1;
	//}else{
	//	FindRecLocByLogonLoc = 0;
	//}
    if (FindRecLocByLogonLoc == "1") { LogonDep = session['LOGON.CTLOCID'] }
    var retPrice = cspRunServerMethod(ServerObj.GetOrderPriceConUomMethod, ServerObj.EpisodeID, OrderBillTypeRowid, LogonDep, OrderARCIMRowid, OrderOpenForAllHosp, OrderPackUOMRowid, OrderRecDepRowid);
    if (retPrice==undefined) retPrice="0^0^0^0^0";
    var ArrPrice = retPrice.split("^");
    var Price = ArrPrice[0];
    if (Price < 0) {
        $.messager.alert("警告",$g("此接收下无有效医嘱项,请切换接收科室或者联系相关人员处理"),"warning")
        websys_setfocus('OrderReLoc');
    }
    return retPrice
}
//费别
function OrderBillTypeCombCreat(){
	$HUI.combobox("#OrderBillType",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	data:JSON.parse(ServerObj.OrdBillTypeJson),
    	//url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=OrderBillType"+"&Inpute1="+ServerObj.EpisodeID+"&Inpute2="+""+"&ResultSetType=array",
    	onLoadSuccess:function(data){
	    	var DefBillType="";
	    	var DefInsuFlag="";
	    	for(var i=0;i<data.length;i++){
		    	if(data[i].selected==1){
			    	DefBillType = data[i].CombValue;
			    	DefInsuFlag = data[i].CombCode;
			    }
		    }
		    if((DefBillType=="")&&(data.length==1)){
				DefBillType=data[0].CombValue;    
				DefInsuFlag=data[0].CombCode;
			}
	    	if(DefBillType!=""){
		    	$HUI.combobox("#OrderBillType").setValue(DefBillType);
		    	SetCoverMainIns(DefInsuFlag)
		    }
	    },onSelect:function(record){
		    if((record!="undefined")&&(typeof record != "undefined")){
			    var InsuFlag=record["CombCode"];
			    SetCoverMainIns(InsuFlag)
				SetPackQty("OrderBillTypeCombCreat");	
		    }
		}
	})
}

function SetCoverMainIns(InsuFlag){
	var comobj=$HUI.combobox("#OrderBillType");
	if((typeof InsuFlag=='undefined')||(InsuFlag=="")){
		InsuFlag=$.cm({
			ClassName:"web.DHCDocOrderCommon",
			MethodName:"GetInsurFlag",
			BillType:comobj.getValue(),
			dataType:"text"
		},false)	
	}
	var ckobj=$HUI.checkbox("#CureItemCoverMainIns");
	if((ServerObj.CFAllConfirmInsurSYMM=="1")||(InsuFlag!="0")){
    	ckobj.setValue(true);
    }else{
	    ckobj.setValue(false);
	}
}

///加载医嘱信息及绑定医嘱列表
function CureItemTreeClick(val){
	if(val==""){
		return false	
	}
	var arr=val.split(String.fromCharCode(4));
	var itemrowid=arr[2];
	
	new Promise(function(resolve,rejected){
		CheckBeforeInitCureARCItem(itemrowid,resolve);
	}).then(function(){
		Clear_Mes();
		SetItemToForm(val);
	})
}

function SetItemToForm(val){
	var arr=val.split(String.fromCharCode(4));
	var Type=arr[0];
	var itemrowid=arr[2];
	var Baseuomdesc=arr[6];
	var FormDurRowid=arr[7];
	var OrderType=arr[8];
	var DDCISRowid=arr[17];
	var OrderPHPrescType=arr[18];
	var OrderDoseStr=arr[19];
	var itemdesc=arr[20];
	var DefDurStr=arr[21];
	var OrderConFac=arr[22];
	var ARCOSItemInfo=arr[24];
	var DefFreqStr=arr[25];
	var AssScaleID=arr[26];
	$('#ItemRowid').val(itemrowid);
	$('#OrderArcimDesc').val(itemdesc);
	$('#DDCISRowid').val(DDCISRowid);
	$('#OrderType').val(OrderType);
	$('#OrderPHPrescType').val(OrderPHPrescType);
	$('#OrderConFac').val(OrderConFac);
	$('#CureAssScaleID').val(AssScaleID);
	SetCoverMainIns()
	if(DefDurStr!=""){
		var OrderPriorRowid = $("#OrderPrior").combobox('getValue');
		if (OrderPriorRowid == ServerObj.LongOrderPriorRowid){
			ClearOrderDur();
		}else{
			var DefDurArr=DefDurStr.split("#");
			var mDurObj={
				OrderDur:DefDurArr[0],
				OrderDurRowid:DefDurArr[1],
				OrderDurFactor:DefDurArr[2],
			}
			SetOrderDur(mDurObj);
		}
	}
	if(DefFreqStr!=""){
		var DefFreqArr=DefFreqStr.split("#");
		var mFreqObj={
			OrderFreq:DefFreqArr[0],
			OrderFreqFactor:DefFreqArr[2],
			OrderFreqInterval:DefFreqArr[3],
			OrderFreqRowid:DefFreqArr[1],
			WeekFlag:DefFreqArr[4],
			FreeTimeFreqFlag:DefFreqArr[5],
			OrderFreqDispTimeStr:""
		}
		if (ServerObj.PAAdmType == "I") {
			var PriorRowid=$("#OrderPrior").combobox('getValue');
	        if (PriorRowid != ServerObj.LongOrderPriorRowid){
		        if((OrderFreqRowid != ServerObj.STFreqRowid) || (OrderFreqRowid == ServerObj.ONCEFreqRowid)) {
		            $.extend(mFreqObj, {
			            OrderFreq:ServerObj.ONCEFreq,
						OrderFreqFactor:"1",
						OrderFreqInterval:"",
						OrderFreqRowid:ServerObj.ONCEFreqRowid,
						WeekFlag:"",
						FreeTimeFreqFlag:"",
						OrderFreqDispTimeStr:""
		            });
		        }
	        }
	    }
	    var NotSetPackQty="Y";
		SetOrderFreq(mFreqObj,NotSetPackQty);
	}
	$('#OrderStartDate').datetimebox("setValue",ServerObj.CurrDateTime);
	SetOrderHiddenPara();
	OrderDoseUOMCombCreat(OrderDoseStr,"") //单次剂量单位
	new Promise(function(resolve,rejected){
		ItemBillUOMCombCreat(itemrowid,"",resolve) //整包装单位
	}).then(function(){
		return new Promise(function(resolve,rejected){
			OrderRecLocCombCreat(itemrowid,"",resolve); //接收科室
			//resolve()
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var ApplyOrAss=GetApplyOrAss();
			if(ApplyOrAss==PageApplyTreeObj.CureAssFlag){
				var OrderPriorRowid=$HUI.combobox("#OrderPrior").getValue();
				if(ServerObj.ShortOrderPriorRowid!=OrderPriorRowid){
					$HUI.combobox("#OrderPrior").setValue(ServerObj.ShortOrderPriorRowid);
				}else{
					OrderPriorityChange();
				}
			}else{
		    	OrderPriorityChange();
			}
		    ChangeBtnStyle("N");
			resolve()
		})	
	}).then(function(){
		return new Promise(function(resolve,rejected){
			SetPackQty("CureItemTreeClick");
			resolve()
		})	
		
	}).then(function(){
		InitCureItemTemp(DDCISRowid);
	    //加载绑定医嘱列表信息
	    LoadCureAppendItemListData(DDCISRowid);
	})
    
    /* if(GetApplyOrAss()){
    	LoadCureAppendItemListData(DDCISRowid);
    }else{
		LoadCureAppendItemListData("");
	} */  
}

/*
*value=false:不可编辑  
*value=true :可以编辑
*/
function GetStyleConfigObj(ParamObj) {
    var DefaultStyleConfigObj = {
	    OrderPrior: true,
        OrderDur: true,
        OrderFreq: true,
        OrderQty: true,
        BillingUOM: true,
        OrderDoseQty: true,
        OrderDoseUOM: true,
        OrderFirstDayTimes: false,
        OrderEndDate:false
    }
    var icode = ParamObj.icode;
    var OrderType = ParamObj.OrderType;
    var OrderPHPrescType = ParamObj.OrderPHPrescType;
    var OrderPriorRowid = $("#OrderPrior").combobox('getValue');	
    var OrderFreqRowid = $("#OrderFreqRowid").val();	
    var StyleConfigObj = {};
    var StyleConfigObj = DefaultStyleConfigObj;
    StyleConfigObj.OrderDur = false;
    StyleConfigObj.OrderFreq = false;
    if (OrderType != "R") {
        StyleConfigObj.OrderDoseUOM = false;
        /*
        非药品长期医嘱，如果没有单次剂量单位允许填写单次剂量
        非药品长期医嘱，无论有无频次，都能录入单次剂量
        */
        if (OrderPriorRowid == ServerObj.LongOrderPriorRowid){
            StyleConfigObj.OrderEndDate = true;
        }else{
			//if (ParamObj.idoseqtystr == "") {
			StyleConfigObj.OrderDoseQty = false;
			//}
			//StyleConfigObj.OrderDoseQty = false;
        }
        StyleConfigObj.OrderDur = false;
        StyleConfigObj.OrderQty = false;
        StyleConfigObj.BillingUOM = false
        //控制 非药品频次
        //在MedTrak的医生站配置中的【子类控制】->【录入频次非药品子类】中设定的医嘱子类
        if (OrderPHPrescType == "4") {
            if (ServerObj.PAAdmType != "I"){StyleConfigObj.OrderDur = true;}
	        StyleConfigObj.OrderFirstDayTimes=true;    
            StyleConfigObj.OrderFreq = true;
        }else{
	        StyleConfigObj.OrderDoseQty = false;
	        ClearOrderDur();
	        ClearOrderFreq();
        }
        //非药品长期医嘱，有频次不能录入数量，无频次可以录入数量
        //非药品长期医嘱无频次不能录入单次剂量
        if (OrderPriorRowid == ServerObj.LongOrderPriorRowid){
            //if (StyleConfigObj.OrderFreq==false){
	        if ((StyleConfigObj.OrderFreq==false)&&(OrderFreqRowid=="")){
                StyleConfigObj.OrderQty = true;
                StyleConfigObj.OrderDoseQty = false;
            }else{
	            StyleConfigObj.OrderFirstDayTimes=true;
                StyleConfigObj.OrderDoseQty = true;
            }
        }
        /*if (ServerObj.PAAdmType!="I") {
	        StyleConfigObj.OrderFirstDayTimes=true;
	    }*/
    } else {
		StyleConfigObj.OrderFirstDayTimes=true;
		if (OrderPriorRowid == ServerObj.LongOrderPriorRowid){
            StyleConfigObj.OrderEndDate = true;
        }
        //药品 频次
        StyleConfigObj.OrderFreq = true;
        if (ServerObj.PAAdmType != "I") {
            StyleConfigObj.OrderDur = true;
        } else {
            if (OrderPHPrescType == "3") {
                StyleConfigObj.OrderDur = true;
            } else {
                if ((OrderPriorRowid == ServerObj.LongOrderPriorRowid) || ((OrderPriorRowid == ServerObj.ShortOrderPriorRowid) && (ServerObj.PAAdmType == "I"))) {
                    StyleConfigObj.OrderDur = false;
                }
            }
        }
    }  
	var RtnStyleObj=GetSpecDurStyleByFreq(OrderFreqRowid);
	$.extend(StyleConfigObj,RtnStyleObj)
    if (ParamObj.IsHourItem == "1") {
        StyleConfigObj.OrderFreq = false;
        StyleConfigObj.OrderDur = false;
        StyleConfigObj.OrderInstr = false;
    }
    
    return StyleConfigObj
}

function ContrlOrderPackQty(ParamObj,ChangeStyleObj) {
    var OrderPackQtyObj = { OrderQty: true, BillingUOM: true };
    var PriorRowid=ParamObj.OrderPriorRowid;
    var OrderARCIMRowid=ParamObj.icode;
    var OrderRecDepRowid=ParamObj.OrderRecLocRowid;
    var OrderType=ParamObj.OrderType;
    var OrderPHPrescType=ParamObj.OrderPHPrescType;
    var OrderFreqRowid=ParamObj.OrderFreqRowid;
    if(((ServerObj.PAAdmType != "I")||((ServerObj.PAAdmType == "I")&&(IsLongPrior(PriorRowid))))
    &&((OrderPHPrescType=="4")||(OrderFreqRowid != "")))
    {
    	OrderPackQtyObj.BillingUOM = false;
    	OrderPackQtyObj.OrderQty = false;
    	OrderPackQtyObj.OrderDoseQty = true;
    }
    else if((ServerObj.PAAdmType == "I")&&(!IsLongPrior(PriorRowid))){
    	OrderPackQtyObj.BillingUOM = true;
    	OrderPackQtyObj.OrderQty = true;
    	OrderPackQtyObj.OrderDoseQty = false;
    }
	if (OrderARCIMRowid==""){
		return OrderPackQtyObj;
	}	
    var OrderMasterARCIMRowid="";
    var OrderVirtualtLong="";
    var ret = cspRunServerMethod(ServerObj.ContrlOrderPackQtyMethod, ServerObj.EpisodeID, PriorRowid, session['LOGON.CTLOCID'], OrderARCIMRowid, OrderMasterARCIMRowid, OrderRecDepRowid,OrderVirtualtLong);
	var OrderPackQtyStyle = mPiece(ret, "^", 0);
	var OrderPackUOMStyle = mPiece(ret, "^", 1);
	var SetOrderPackQtyValue = mPiece(ret, "^", 2);
	if (OrderPackQtyStyle=="0"){
		OrderPackQtyObj.OrderQty = false;
	}
	if (OrderPackUOMStyle=="0"){
		OrderPackQtyObj.BillingUOM = false;
	}
	if ((SetOrderPackQtyValue!="false")&&(SetOrderPackQtyValue!="true")){
		$HUI.numberbox("#OrderQty").setValue("");
	}
    return OrderPackQtyObj;
}

function CheckBeforeInitCureARCItem(icode,ExcFunc){
	new Promise(function(resolve,rejected){
		var PPRowId=getParam("PPRowId");
		var AdmReason=$("#OrderBillType").combobox('getValue');
		var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+PPRowId+"^"+AdmReason;
		var ErrObject=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"CheckBeforeInsert",
			'EpisodeID':ServerObj.EpisodeID,
			'ArcimRowid':icode,
			'ExpStr':ExpStr
		},false);
		if (ErrObject.ErrMsg != ""){
			if(ErrObject.ErrCode==0){
				$.messager.alert("提示",ErrObject.ErrMsg,"info");
			}else{
				$.messager.alert("提示",ErrObject.ErrMsg,"warning");
				return false;
			}
		}
		resolve();
	}).then(function(){
		return new Promise(function(resolve,rejected){
			(function(callBackFunExec){
				new Promise(function(resolve,rejected){
					CheckDiagnose(icode,resolve);
				}).then(function(rtn){
					if(rtn){
						callBackFunExec();
					}else{
						return false;	
					}
				});
			})(resolve);
		})
	}).then(function(){
		ExcFunc();
	})
	
}
function getParam(paramName){
    var paramValue = "";
    var isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=")>1){
        arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
        var i = 0;
        while (i < arrSource.length && !isFound){
            if (arrSource[i].indexOf("=") > 0){
                 if (arrSource[i].split("=")[0].toLowerCase()==paramName.toLowerCase()){
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                 }
            }
            i++;
        } 
    }
   return paramValue;
}
/// 验证病人是否允许开医嘱
function GetPatNotTakOrdMsgArc(icode){
	var ErrObject=$.cm({
		ClassName:"web.DHCAPPExaReport",
		MethodName:"GetPatNotTakOrdMsgArc",
		'EpisodeID':ServerObj.EpisodeID,
		'arcitemId':icode,
		'PPRowId': getParam("PPRowId"),
		'AdmReason':$("#OrderBillType").combobox('getValue')
	},false);
	return ErrObject;
}
function ResetItemStyle(){
	$('#btnAddItem').linkbutton("disable");
	$("#btnAddItem").unbind();
	DisableAllElement();
}

function Clear_Mes(){
	var ItemRowid=$('#ItemRowid').val();
	if(ItemRowid==""){return}
	
	$('#OrderArcimDesc').val("");
	$('#ItemRowid').val("");
	ClearOrderFreq();
	ClearOrderDur();
	$HUI.numberbox("#OrderDoseQty").setValue("");
	$HUI.combobox("#OrderDoseUOM").setValue("");
	$HUI.combobox("#OrderReLoc").setValue("");
	$HUI.numberbox("#OrderQty").setValue("");
	$HUI.combobox("#BillingUOM").setValue("");
	$HUI.combobox("#CureItemPlan").setValue("");
	$HUI.checkbox("#CureItemCoverMainIns").setValue(false);
	$('#ApplyPlan').val("");
	$('#ApplyRemark').val("");
	$("#OrderQty").attr("disabled",false);
	$('#OrderPrice').val("");
	com_Util.SetComboVal("OrderFirstDayTimes","");
	$('#CureApplyNo').val("");
	$('#CureAssScaleID').val("");
	$('#CureItemPOAInfo').val("");
	$('#OrderPHPrescType').val("");
	$('#OrderType').val("");
	$('#OrderDoseStr').val("");
	$('#OrderFreqDispTimeStr').val("");
	$('#OrderConFac').val("");
	$('#OrderStartDate').datetimebox("setValue","")
	$('#OrderEndDate').datetimebox("setValue","")
	LoadCureAppendItemListData("");

    $HUI.combobox("#OrderReLoc").clear();
    $HUI.combobox("#OrderDoseUOM").clear();
    $HUI.combobox("#ItemBillUOM").clear();
    $HUI.combobox("#CureItemPlan").clear();
    $HUI.combobox("#CureItemNote").clear();
    if ($("#ChronicDiag").length>0){
    	$HUI.lookup("#ChronicDiag").clear();
    }
    $('#CureItemHiddenPara').val("");
    
    /*$('table.form-table input[class*="hisui-combobox"]').combobox("clear");
    $('table.form-table input[type="hidden"]').val("");
    
    $('table.form-table-copy input[class*="hisui-combobox"]').combobox("clear");
    $('table.form-table-copy input[type="hidden"]').val("");
    */
}

function GetRecLocByLogonLoc(){
	var HiddenParaObj={};
	var OrderHiddenPara=$('#CureItemHiddenPara').val();	
	if(OrderHiddenPara!=""){
		HiddenParaObj=GetHiddenParaObj(OrderHiddenPara);
		var FindRecLocByLog=HiddenParaObj.FindRecLocByLog;
	}else{
		var FindRecLocByLog=$("#FindLocByLog").checkbox('getValue')?1:0;
	}
	var FindRecLocByLogonLoc = FindRecLocByLog==1?session['LOGON.CTLOCID']:"";
	return FindRecLocByLogonLoc;
}
function GetOrderOpenForAllHosp(){
	var OrderOpenForAllHosp=0;
	var HiddenParaObj={};
	var OrderHiddenPara=$('#CureItemHiddenPara').val();	
	if(OrderHiddenPara!=""){
		HiddenParaObj=GetHiddenParaObj(OrderHiddenPara);
		OrderOpenForAllHosp=HiddenParaObj.OpenForAllHosp;
	}else{
		if($("#OrderOpenForAllHosp").length>0){
			OrderOpenForAllHosp=$("#OrderOpenForAllHosp").checkbox("getValue")?1:0;
		}
	}
	return OrderOpenForAllHosp;
}

//接收科室
function OrderRecLocCombCreat(ArcimID,DefaultOrdRecLoc,CallBackFun,ReLocData){
	if(typeof ReLocData!="undefined" && ReLocData!=""){
		$HUI.combobox("#OrderReLoc").loadData(ReLocData);
		$HUI.combobox("#OrderReLoc").select(DefaultOrdRecLoc);
		if(typeof(CallBackFun)=="function"){
	    	CallBackFun(DefRecLoc);	
	    }
		return true	
	}
	var LogonDep = GetRecLocByLogonLoc();
	var OrderOpenForAllHosp = GetOrderOpenForAllHosp();
    var AssScaleID=$('#CureAssScaleID').val();
    var PriorityID=$HUI.combobox("#OrderPrior").getValue();
    var InputeExp=AssScaleID+"^"+OrderOpenForAllHosp;
	$HUI.combobox("#OrderReLoc",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=DHCDocOrderRecLoc"+"&Inpute1="+ArcimID+"&Inpute2="+DefaultOrdRecLoc+"&Inpute3="+PriorityID+"&Inpute4="+ServerObj.EpisodeID+"&Inpute5="+LogonDep+"&InputeExp="+InputeExp+"&ResultSetType=array",
    	onSelect:function(){
			SetPackQty("OrderRecLocCombCreat");	
		},onLoadSuccess:function(data){
			SetOrderHiddenPara({OrderReLocData:data});
	    	var DefRecLoc="";
	    	for(var i=0;i<data.length;i++){
		    	if(i==0){
			    	DefRecLoc = data[i].CombValue;	
			    }
		    	if(data[i].selected==1){
			    	DefRecLoc = data[i].CombValue;
			    	break;
			    }
		    }
		    //若接收科室只有一个，则默认选择，否则必须手动选择
		    /*if((DefRecLoc=="")&&(data.length==1)){
				DefRecLoc=data[0].CombValue;    
			}*/
	    	$HUI.combobox("#OrderReLoc").select(DefRecLoc);
	    	if(typeof(CallBackFun)=="function"){
		    	CallBackFun(DefRecLoc);	
		    }
	    }
	})
}

function CureItemPlanCombCreat(DDCISRowid){
	$HUI.combobox("#CureItemPlan",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=CureItemPlan&Inpute1="+DDCISRowid+"&Inpute2=P&Inpute3=&ResultSetType=array",
    	onLoadSuccess:function(data){
	    	$HUI.combobox("#CureItemPlan").setValue("");
	    },onSelect:function(record){
            /*var ID=record['CombValue'];
			var ret=$.cm({
				ClassName:"DHCDoc.DHCDocCure.CureItemSet",
				MethodName:"GetPlanDetailByID",
				dataType:"text",
				'DDCISPRowid':ID
			},false);*/
			var CombNote=record['CombNote'];
			if(CombNote!=""){
				$("#ApplyPlan").val(CombNote);
			}
		}
	})
}
function OrderDoseUOMCombCreat(DoseStr,DefUOM){
	//FormDoseQty_"#"_FormDoseUOMDesc_"#"_FormDoseUOMRowid_","_OrderDoseStr	
	var DoseArr=new Array();
	var Dem="#";
	var DefaultDoseQty = "";
    var DefaultDoseQtyUOM = "";
    var DefaultDoseUOMRowid = "";
	if(DoseStr!=""){
		var retArr=DoseStr.split(",")
		for(var i=0;i<retArr.length;i++){
			var value=retArr[i].split(Dem)[2];
			var desc=retArr[i].split(Dem)[1];
			if((DefaultDoseQty=="")||((DefUOM!="")&&(DefUOM==value))){
				DefaultDoseQty = retArr[i].split(Dem)[0];
		        DefaultDoseQtyUOM = desc;
		        DefaultDoseUOMRowid = value;
			}
			var onestr = {"CombValue":value, "CombDesc":desc};
			DoseArr.push(onestr);	
		}
	}
	$HUI.combobox("#OrderDoseUOM",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	data: DoseArr,
    	editable:false,
		onLoadSuccess:function(){
			$HUI.combobox("#OrderDoseUOM").setValue(DefaultDoseUOMRowid);
			$HUI.numberbox("#OrderDoseQty").setValue(DefaultDoseQty);
		},
		onSelect:function(){
			SetPackQty("OrderDoseUOMCombCreat");	
		}	
	})	
}
//整包装单位
function ItemBillUOMCombCreat(ArcimDr,PackUom,callBackFun)
{
	var Edit=true
	var INPut="N"
	var ChoseType=""
	$HUI.combobox("#BillingUOM",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	url:$URL+"?ClassName=web.UDHCFavItemNew&QueryName=CombListFind&CombName=ItemBillUOM&Inpute1="+INPut+"&Inpute2="+ArcimDr+"&Inpute3=&ResultSetType=array",
		onHidePanel:function(){
			 var SubDesc=$('#BillingUOM').combobox('getText')
			 if ((SubDesc!="")&&(SubDesc.indexOf("-")>0)){
				var SetDesc=SubDesc.split("-")[1]
				if (SetDesc==""){SetDesc=SubDesc}
				$('#BillingUOM').combobox('setText',SetDesc)	
			}
		},
		onSelect:function(){
			SetPackQty("ItemBillUOMCombCreat");	
		},onLoadSuccess:function(data){
			var DefBillUOM="";
	    	for(var i=0;i<data.length;i++){
		    	if(data[i].selected==1){
			    	var DefBillUOM = data[i].CombValue;
			    	break;
			    }
		    }
		    if((DefBillUOM=="")&&(data.length>0)){
				DefBillUOM=data[0].CombValue;    
			}
			if(PackUom!=""){DefBillUOM=PackUom}
	    	if(DefBillUOM!=""){$HUI.combobox("#BillingUOM").setValue(DefBillUOM);}
	    	if(typeof(callBackFun)=="function"){
		    	callBackFun();	
		    }
		}
	})
}
//-------------治疗申请附加医嘱信息开始----------------------
//初始化绑定医嘱列表
function InitCureAppendItemList(){
	var CureAppendItemListDataGrid=$('#CureAppendItemList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		checkOnSelect:true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"CureAppRowId",
		pageSize : 10,
		pageList : [10,20],
		columns :[[ 
				{field:'RowCheck',checkbox:true},     
				{field:'CureAppItemID',title:'',width:35,align:'left',hidden:true},   
				{field:'CureAppItemDesc',title:'绑定医嘱名称',width:150,align:'left'},   
				{field:'CureAppItemQty',title:'绑定数量',width:80,align:'left',
					editor : {
                    	type : 'numberbox',
                    	options:{
	                    	onChange:function(newValue,oldValue){
		                    	if((oldValue!="")&&(newValue!=oldValue)){
			                    	PageApplyTreeObj.selAILDataObj.CureAppItemQty=newValue;
			                    	var Price=parseFloat(PageApplyTreeObj.selAILDataObj.Price);
			                    	var TotalPrice=(parseFloat(newValue)*Price).toFixed(2);
			                    	if(isNaN(TotalPrice)){TotalPrice="";}
			                    	PageApplyTreeObj.selAILDataObj.TotalPrice=TotalPrice;
			                    	var ed=$("#CureAppendItemList").datagrid('getEditor',{index:PageApplyTreeObj.editAILRow,field:'TotalPrice'})
			                    	$(ed.target).val( PageApplyTreeObj.selAILDataObj.TotalPrice);
		                    	}
		                    }
                    	}
                    }
                },   
				{field:'CureAppItemRecLoc',title:'接收科室',width:100,align:'left',
					editor :{  
						type:'combobox',  
						options:{
							//url:$URL,
							valueField:'CombValue',
							textField:'CombDesc',
							//required:true,
							loadFilter: function(data){
								return data['rows'];
							},
							onSelect:function(option){
								if (option) {
									var ed=$("#CureAppendItemList").datagrid('getEditor',{index:PageApplyTreeObj.editAILRow,field:'CureAppItemRecLoc'});
									$(ed.target).combobox('setValue', option.CombValue);
									var ed=$("#CureAppendItemList").datagrid('getEditor',{index:PageApplyTreeObj.editAILRow,field:'CureAppItemRecLocID'});
									$(ed.target).val(option.CombValue); 
									PageApplyTreeObj.selAILDataObj.CureAppItemRecLoc=option.CombDesc;
									PageApplyTreeObj.selAILDataObj.CureAppItemRecLocID=option.CombValue;
								}
							},
							onChange:function(newValue,oldValue){
								if (newValue==""){
									PageApplyTreeObj.selAILDataObj.CureAppItemRecLoc="";
									PageApplyTreeObj.selAILDataObj.CureAppItemRecLocID="";
									//var obj=PageLogicObj.m_ResListDataGrid.datagrid('getEditor',{index:PageApplyTreeObj.editAILRow,field:'CureAppItemRecLoc'})
								}
							}
						 }
					  }	
     			},
				{field:'CureAppItemRecLocID',title:'',width:100,align:'left',hidden:true,editor:{type:'text'}},
				{field:'Price',title:'单价',width:60,align:'left',hidden:true},
				{field:'TotalPrice',title:'价格',width:60,align:'left',editor:{type:'textReadonly'}},
				{field:'RecLocStr',title:'',width:100,align:'left',hidden:true},
				{field:'CureAppItemType',title:'',width:100,align:'left',hidden:true},
				{field:'baseuom',title:'',width:100,align:'left',hidden:true},
				{field:'Baseuomdesc',title:'',width:100,align:'left',hidden:true},
				{field:'CureAppRowId',title:'',width:100,align:'left',hidden:true}
			 ]] ,
		onDblClickRow: function (rowIndex, rowData) {
			PageApplyTreeObj.CureAppendItemListDataGrid.datagrid("selectRow",rowIndex)
            CureAppendItemListDblClick(rowIndex, rowData)
        },
        /*onBeginEdit:function(rowIndex, rowData){
	        var obj=PageApplyTreeObj.CureAppendItemListDataGrid.datagrid('getEditor',{index:rowIndex,field:'CureAppItemRecLoc'})
			if(obj){
				var CareTarget=obj.target;
				CareTarget.combobox('clear');
				var url=$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=DHCDocOrderRecLoc"+"&Inpute1="+rowData.CureAppItemID+"&Inpute2="+rowData.CureAppItemRecLocID+"&Inpute3=1&Inpute4="+ServerObj.EpisodeID+"&Inpute5="+session['LOGON.CTLOCID']+"&Inpute6=N"+"&ResultSetType=array";
				CareTarget.combobox('reload',url);
				CareTarget.combobox("setValue",rowData.CureAppItemRecLocID);
				//$HUI.combobox
			}
	    },*/onAfterEdit: function (rowIndex, rowData, changes) {
	        rowData.CureAppItemRecLoc=PageApplyTreeObj.selAILDataObj.CureAppItemRecLoc;
	        rowData.TotalPrice=PageApplyTreeObj.selAILDataObj.TotalPrice;
	        $(this).datagrid('updateRow',{
				index:rowIndex,
				row:rowData
			});
			PageApplyTreeObj.selAILDataObj={CureAppItemID:"",CureAppItemDesc:"",CureAppItemQty:"",CureAppItemRecLocID:"",CureAppItemRecLoc:"",RecLocStr:"",TotalPrice:"",Price:""};
            PageApplyTreeObj.editAILRow = undefined;
        }
	});
	return CureAppendItemListDataGrid;
}
function LoadCureAppendItemListData(Rowid,itemobj){
	if(Rowid!=""){
		var LogonDep = GetRecLocByLogonLoc();
		var OpenForAllHosp = GetOrderOpenForAllHosp();
		var ProirityRowId=$HUI.combobox("#OrderPrior").getValue();
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.CureItemSet",
			QueryName:"FindCureItemAppendItem",
			DDCIAIRowid:Rowid,
			Episodeid:ServerObj.EpisodeID,
			CTLoc:LogonDep,
			ProirityRowId:ProirityRowId,
			OpenForAllHosp:OpenForAllHosp,
			Pagerows:PageApplyTreeObj.CureAppendItemListDataGrid.datagrid("options").pageSize,
			rows:99999
		},function(GridData){
			new Promise(function(resolve,rejected){
				PageApplyTreeObj.CureAppendItemListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData); 
				PageApplyTreeObj.CureAppendItemListDataGrid.datagrid("clearSelections");
				PageApplyTreeObj.CureAppendItemListDataGrid.datagrid("clearChecked");
				resolve(itemobj)
			}).then(function(obj){
				ReLoadCureAppendItemListData(obj);
				return websys_cancel()	
			})
		})
	}else{
		PageApplyTreeObj.CureAppendItemListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',{total: 0, rows: []});
		PageApplyTreeObj.CureAppendItemListDataGrid.datagrid("clearSelections");
		PageApplyTreeObj.CureAppendItemListDataGrid.datagrid("clearChecked");
	}
}

function CureAppendItemListDblClick(rowIndex, rowData, callBackFun){
	if (PageApplyTreeObj.editAILRow != undefined) { 
        PageApplyTreeObj.CureAppendItemListDataGrid.datagrid('endEdit', PageApplyTreeObj.editAILRow); 
    } 
    PageApplyTreeObj.CureAppendItemListDataGrid.datagrid('beginEdit', rowIndex); 
    PageApplyTreeObj.editAILRow = rowIndex; 
    $.extend(PageApplyTreeObj.selAILDataObj,rowData);
	if(rowData){
		var CureAppItemID=rowData.CureAppItemID;
		var DefaultOrdRecLoc=rowData.CureAppItemRecLocID;
		var RecLocStr=rowData.RecLocStr;
		var RecLocAry=RecLocStr.split("!");
		var myAry=new Array();
		for(var i=0;i<RecLocAry.length;i++){
			var myRecLoc=RecLocAry[i];
			var myRecLocAry=myRecLoc.split("^");
			var myRecLocID=myRecLocAry[1];
			var selected=false;
			if(myRecLocID==DefaultOrdRecLoc){
				selected=true;
			}
			var LocObj={
				CombDesc:myRecLocAry[0],
				CombValue:myRecLocAry[1],
				selected:selected,
				CombCode:myRecLocAry[3]
			}
			myAry.push(LocObj);
		}
		var DataObj={rows:myAry};
		var editors=PageApplyTreeObj.CureAppendItemListDataGrid.datagrid('getEditor',{index:rowIndex,field:'CureAppItemRecLoc'});
		$(editors.target).combobox({data:DataObj});	
		if(typeof callBackFun=='function'){
		    setTimeout(function(){callBackFun()},50);
		}
	}
	return
    ReloadItemAppendRecLoc(rowIndex,rowData.CureAppItemRecLocID);
}

function ReloadItemAppendRecLoc(index,DefaultOrdRecLoc){
	var itemid="";
	var rows=PageApplyTreeObj.CureAppendItemListDataGrid.datagrid("getSelected"); //.datagrid("selectRow",index)
	if(rows){
		itemid=rows.CureAppItemID;
		if(typeof(DefaultOrdRecLoc)=='undefined'){
			DefaultOrdRecLoc=rows.CureAppItemRecLocID;
		}
	}
	var LogonDep = GetRecLocByLogonLoc();
	var OpenForAllHosp = GetOrderOpenForAllHosp();
	var InputeExp="^"+OpenForAllHosp;
    var unitUrl=$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=DHCDocOrderRecLoc"+"&Inpute1="+itemid+"&Inpute2="+DefaultOrdRecLoc+"&Inpute3=1&Inpute4="+ServerObj.EpisodeID+"&Inpute5="+LogonDep+"&Inpute6=N&InputeExp="+InputeExp+"&rows=9999";
    var editors=PageApplyTreeObj.CureAppendItemListDataGrid.datagrid('getEditor',{index:index,field:'CureAppItemRecLoc'});
	$(editors.target).combobox('reload',unitUrl);	
}

function ReLoadCureAppendItemListData(data){
	if(typeof(data)=="undefined"){
		data={Length:0,AppendItem:[]}	
	}
	if(data.Length==0){
		return	
	}
	for (var i=0;i<data.Length;i++) {
		var CureAppRowId=data.AppendItem[i].CureAppRowId;
		PageApplyTreeObj.CureAppendItemListDataGrid.datagrid("selectRecord",CureAppRowId);
	}
	var rows=PageApplyTreeObj.CureAppendItemListDataGrid.datagrid("getSelections");
	if (rows.length > 0) {
		var Len=rows.length;
		if(Len>0){
			function UpdateRow(j){
				new Promise(function(resolve,rejected){
					var rowIndex = PageApplyTreeObj.CureAppendItemListDataGrid.datagrid('getRowIndex', rows[j]);
					PageApplyTreeObj.CureAppendItemListDataGrid.datagrid("beginEdit", rowIndex);
					CureAppendItemListDblClick(rowIndex,data.AppendItem[j],resolve);
				}).then(function(){
					return new Promise(function(resolve,rejected){
						var rowIndex = PageApplyTreeObj.CureAppendItemListDataGrid.datagrid('getRowIndex', rows[j]);
						var editors =PageApplyTreeObj.CureAppendItemListDataGrid.datagrid('getEditors', rowIndex);
						var value=data.AppendItem[j].CureAppItemQty;
						editors[0].target.numberbox("setValue", value);
						var value=data.AppendItem[j].CureAppItemRecLocID;
						//console.log(editors[1].target.combobox("getData"));
						editors[1].target.combobox("select", value);
						editors[2].target.val(value);
						PageApplyTreeObj.CureAppendItemListDataGrid.datagrid("endEdit", rowIndex);
						resolve();
					})
				}).then(function(){
					j++;
					if ( j < Len ) {
						 UpdateRow(j);
					}
				})
			}
			UpdateRow(0);
		}
	}	
}

//获取已勾选的绑定医嘱信息
function GetSelAppendItemObj(){
	var ChronicDiagCode=GetChronicDiagCode();
	var CureItemSelAppendItemObj={
		AppendItem:[],
		Length:0,	
	}
	if (PageApplyTreeObj.editAILRow != undefined) { 
        PageApplyTreeObj.CureAppendItemListDataGrid.datagrid('endEdit', PageApplyTreeObj.editAILRow); 
    } 
	var SelAppObj=PageApplyTreeObj.CureAppendItemListDataGrid.datagrid("getChecked");
	CureItemSelAppendItemObj.Length=SelAppObj.length;
	for(var i=0;i<SelAppObj.length;i++){
		SelAppObj[i].ChronicDiagCode=ChronicDiagCode;
		CureItemSelAppendItemObj.AppendItem.push(SelAppObj[i])	
	}
	return CureItemSelAppendItemObj
}
//-------------治疗申请附加医嘱信息结束----------------------
//-------------治疗申请待添加到医嘱录入医嘱信息列表开始----------------------
function InitCureEntryItemList(){
	var mytoolbar = [
		{
	        text: '确认',
	        iconCls: 'icon-ok',
	        handler: function() {
				AddToOrderEntry();
	        }
	    }
	]
	if(ServerObj.ParaType!="OEOrdEntryUpdate"){
		mytoolbar.push({
	        text: '勾选删除',
	        iconCls: 'icon-cancel',
	        handler: function() {
				DeleteFromAppendList();
	        }
	    })
	}
	
	if(ServerObj.PAAdmType=="I"){
		if(ServerObj.ParaType!="CureAdvise"){
			var txt='实习生/建议医嘱列表';
		}else{
			var txt='建议医嘱列表';	
		}
		mytoolbar.push({
	        text: txt,
	        iconCls: 'icon-paper-submit',
	        handler: function() {
				ShowPracticeOrder();
	        }
	    })
	}else{
		mytoolbar.push({
	        text: '建议医嘱列表',
	        iconCls: 'icon-paper-submit',
	        handler: function() {
				ShowPracticeOrder();
	        }
	    })	
	}
	var CureEntryItemListDataGrid=$('#CureEntryItemList').datagrid({  
		fit : true,
		width : 'auto',
		url : '',
		border : false,
		striped : true,
		singleSelect : true,
		checkOnSelect:false,
		selectOnCheck:false,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		toolbar:mytoolbar,
		idField:"CureItemSeqNo",
		showPageList:false,  
		pageSize : 100,
		pageList : [20,50,100],
		columns :[[ 
			{field:'RowCheck',checkbox:true}, 
			{field:'CureItemSeqNo',title:'',width:35,align:'left',hidden:true},  
			{field:'CureItemPrior',title:'医嘱类型',width:80,align:'left'}, 	
			{field:'CureItemRowid',title:'医嘱项ID',width:35,align:'left',hidden:true},   
			{field:'CureItemArcDesc',title:'医嘱名称',width:130,align:'left',
				formatter:function(value,row,index){
					if (row.CureItemApplyOrAss==false){
						return "<span style='background:green;color:#fff;padding:4px 8px;border-radius:4px;display:inline-block;'>"+value+"</span>";
					}else{
						return value;
					}
				}
			},
			{field:'CureItemAppendCount',title:'已绑医嘱',width:80,align:'left',
				formatter:function(value,row,index){
					if ((value != "")&&(typeof value != "undefined")){
						return "<span style='background:red;color:#fff;font-size:20px;font-weight:bold;padding:4px 8px;border-radius:4px;display:inline-block;'>"+value+"</span>";
					}else{
						return value;
					}
				}
			},
			{field:'CureItemRecLoc',title:'接收科室',width:120,align:'left'},
			{field:'CureItemPrice',title:'费用',width:80,align:'left'}
		]],
		onDblClickRow:function(rowIndex, rowData){
			//PageApplyTreeObj.CureEntryItemListDataGrid.datagrid("clearChecked");
			//PageApplyTreeObj.editEntryItemRow=undefined;
	        //PageApplyTreeObj.CureEntryItemListDataGrid.datagrid("checkRow", rowIndex);
			//LoadCureItemDetail(rowData);
		},
		onSelect:function(rowIndex, rowData){
			if(ServerObj.ParaType=="OEOrdEntryUpdate"){
				//LoadCureItemDetail(rowData);
			}
			PageApplyTreeObj.editEntryItemRow=rowIndex;
			LoadCureItemDetail(rowData);
		},
		onBeforeSelect:function(rowIndex, rowData){
			if(PageApplyTreeObj.editEntryItemRow==rowIndex){
				//PageApplyTreeObj.CureEntryItemListDataGrid.datagrid('uncheckRow',rowIndex);
				PageApplyTreeObj.CureEntryItemListDataGrid.datagrid('unselectRow',rowIndex);
				PageApplyTreeObj.editEntryItemRow=undefined;
				return false;	
			}
		},
		onUnselect:function(rowIndex, rowData){
			PageApplyTreeObj.editEntryItemRow=undefined;
			Clear_Mes();
		}
	});
	return CureEntryItemListDataGrid;
}

function LoadCureItemDetail(SelObj){ //,callback
	new Promise(function(resolve,rejected){
		Clear_Mes();
		//var SelObj=PageApplyTreeObj.CureEntryItemListDataObj.CureItem[index];
		if((typeof(SelObj.CureItemRowid)=="undefined")||(SelObj.CureItemRowid=="")){
			return false;	
		}
		var CureItemHiddenPara=SelObj.CureItemHiddenPara;
		var HiddenParaObj=JSON.parse(CureItemHiddenPara);
		$('#OrderArcimDesc').val(SelObj.CureItemArcDesc);
		$('#ItemRowid').val(SelObj.CureItemRowid);
		$('#OrderPHPrescType').val(SelObj. OrderPHPrescType);
		$('#OrderType').val(SelObj.OrderType);
		$('#OrderConFac').val(SelObj.CureItemConFac);
		$('#DDCISRowid').val(SelObj.DDCISRowid);
		$('#CureAssScaleID').val(SelObj.CureItemAssScaleID);
		$('#CureItemPOAInfo').val(SelObj.CureItemPOAInfo);
		$('#CureItemHiddenPara').val(CureItemHiddenPara);
		com_Util.SetComboVal("OrderBillType",SelObj.CureItemBillTypeRowId,"","Y");
		var freqobj={
			OrderFreq:SelObj.CureItemFreq,
			OrderFreqFactor:SelObj.CureItemFreqFactor,
			OrderFreqInterval:SelObj.CureItemFreqInterval,
			OrderFreqRowid:SelObj.CureItemFreqRowid,
			OrderFreqDispTimeStr:SelObj.CureItemFreqDispTimeStr,
		}
		var NotSetPackQty="Y";
		SetOrderFreq(freqobj,NotSetPackQty);
		var durobj={
			OrderDur:SelObj.CureItemDur,
			OrderDurRowid:SelObj.CureItemDurRowid,
			OrderDurFactor:SelObj.CureItemDurFactor,
		}
		SetOrderDur(durobj);
		FreqDurChange(freqobj);
		OrderDoseUOMCombCreat(SelObj.OrderDoseStr,SelObj.CureItemDoseUOM);
		ItemBillUOMCombCreat(SelObj.CureItemRowid,SelObj.CureItemPackUOM);
	    OrderRecLocCombCreat(SelObj.CureItemRowid,SelObj.CureItemRecLocRowid,"",HiddenParaObj.OrderReLocData);
	    InitCureItemTemp(SelObj.DDCISRowid);
	    com_Util.SetComboVal("OrderPrior",SelObj.CureItemPriorRowid,"","Y");
	    $('#OrderDoseStr').val(SelObj.OrderDoseStr);
		$HUI.numberbox("#OrderDoseQty").setValue(SelObj.CureItemDoseQty);
		$HUI.combobox("#BillingUOM").select(SelObj.CureItemPackUOM);
		$HUI.combobox("#CureItemPlan").setValue("");
		$('#ApplyPlan').val(SelObj.CureItemApplyPlan);
		$('#ApplyRemark').val(SelObj.CureItemApplyRemark);
		$('#OrderStartDate').datetimebox("setValue",SelObj.CureItemStartDate);
		$('#OrderEndDate').datetimebox("setValue",SelObj.CureItemEndDate);
		var CureItemCoverMainIns=false;
		if(SelObj.CureItemCoverMainIns=="Y"){
			CureItemCoverMainIns=true;
		}
		$HUI.checkbox("#CureItemCoverMainIns").setValue(CureItemCoverMainIns);
	    //加载绑定医嘱列表信息 OrderPriorityChange方法中也会调用
	    //LoadCureAppendItemListData(SelObj.DDCISRowid,SelObj.CureItemSelAppendItemObj);	
	    ChangeBtnStyle("Y");
	    
	    com_Util.SetComboVal("OrderQty",SelObj.CureItemPackQty)
	    $('#OrderPrice').val(SelObj.CureItemPrice);
	    com_Util.SetComboVal("ChronicDiag",SelObj.ChronicDiagCode,SelObj.ChronicDiagDesc);
	    
	    resolve()
    }).then(function(){
		if(ServerObj.ParaType!="OEOrdEntryUpdate"){
			var oid=PageApplyTreeObj.CureApplyFlag;
			if(SelObj.CureItemAssScaleID!=""){
				oid=PageApplyTreeObj.CureAssFlag;
			}
		    OrderPriorityChange({
				IsNotChangeQtyStyle:"Y",
				IsNotChangeQty:"Y",
				oid:oid
			});
	    }else{
		    LoadCureAppendItemListData(SelObj.DDCISRowid,SelObj.CureItemSelAppendItemObj);
	    	DisableAllElement();
	    }
	    return true;
	}).then(function(){
		com_Util.SetComboVal("OrderFirstDayTimes",SelObj.CureItemFirstDayTimes);
	})
    return websys_cancel();
}

function AddToOrderEntry(){
	var Length=PageApplyTreeObj.CureEntryItemListDataObj.Length;
	if(Length<=0){
		$.messager.alert("提示", "请选择需要添加的治疗申请.","info");
		return false;
	}
	if (((ServerObj.PracticeFlag=="1")&&(ServerObj.PracticeDocOrderNeedVerify=="1"))
	||(ServerObj.CureAdviseInsertOrd=="0")){
		var AddFlag=InsertPriceAdd();
		if (AddFlag==true){
			PageApplyTreeObj.CureEntryItemListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',{total: 0, rows: []});
			PageApplyTreeObj.CureEntryItemListDataObj={
				CureItem:[],
				Length:0,
			}
			Clear_Mes();
			$.messager.popover({msg:"申请成功,请等待医师审核后确认.",type:"success",timeout:3000});
		}
		return true;
	}
	if(ServerObj.ParaType=="OEOrdEntry"){
		//若为医嘱录入[治疗申请]按钮弹出
		$.messager.confirm("提示","是否确认添加治疗申请医嘱到医嘱录入?",function(r){
			if(r){
				SetCopyData();	
			}	
		})
	}else if(ServerObj.ParaType=="OEOrdEntryUpdate"){
		//医嘱录入审核弹出
		$.messager.confirm("提示","是否确认?",function(r){
			if(r){
				SaveCureApply(ServerObj.ParaType);	
			}	
		})
	}else{
		//非医嘱录入弹出,菜单录入则走不同分支	
		$.messager.confirm("提示","是否确认添加治疗申请医嘱?",function(r){
			if(r){
				SaveCureApply(ServerObj.ParaType);	
			}	
		})
	}
}

function SetCopyData(){
	var Copyary=new Array();
	var DataObj=PageApplyTreeObj.CureEntryItemListDataObj;
	for (var i=0;i<DataObj.Length;i++){
		var data=DataObj.CureItem[i];
		var code=data.CureItemRowid;
		var CureItemArcDesc=data.CureItemArcDesc
		var OrderType=data.OrderType;
		var OrderPrior=data.CureItemPrior
		var OrderPriorRowid=data.CureItemPriorRowid;
		var OrderDoseQty=data.CureItemDoseQty;
		var OrderDoseUOM=data.CureItemDoseUOMDesc;
		var OrderDoseUOMRowid=data.CureItemDoseUOM;
		var OrderFreq=data.CureItemFreq;
		var OrderFreqRowid=data.CureItemFreqRowid;
		var OrderFreqFactor=data.CureItemFreqFactor;
		var OrderFreqInterval=data.CureItemFreqInterval;
		var CureItemFreqDispTimeStr=data.CureItemFreqDispTimeStr;
		var OrderInstr="";
		var OrderInstrRowid="";
		var OrderDur=data.CureItemDur;
		var OrderDurRowid=data.CureItemDurRowid;
		var OrderDurFactor=data.CureItemDurFactor;
		var OrderPackQty=data.CureItemPackQty;//data.OrderPackQty;
		if (OrderPackQty==" "){OrderPackQty=""}; 
		if (OrderPackQty!="") OrderPackQty=+OrderPackQty;
		var OrderPackUOM=data.CureItemPackUOMDesc;
		var OrderPackUOMRowid=data.CureItemPackUOM;
		var OrderSeqNo=(Copyary.length+1); //i+1;
		var OrderBodyPartLabel="";
		var OrderActionRowid="";
		var OrderAction="";
		var OrderSkinTest="";
		var OrderBillTypeRowId=data.CureItemBillTypeRowId;
		var OrderDepProcNote=data.CureItemApplyRemark;
		var ARCOSRowid="";
		var OrderNotifyClinician="";
		var OrdSpeedFlowRate="";
		var OrderFlowRateUnit="";
		var OrderFlowRateUnitdesc="";
		var CureItemRecLocRowid=data.CureItemRecLocRowid;
		var CureItemFirstDayTimes=data.CureItemFirstDayTimes;
		var CureItemAssScaleID=data.CureItemAssScaleID;
		var CureItemPOAInfo=data.CureItemPOAInfo;
		
		var MainDCARowID=CreateCureApply(code,CureItemRecLocRowid,data.CureItemApplyPlan,"",CureItemAssScaleID,CureItemPOAInfo);
		if(MainDCARowID==false){
			return false;	
		}
		var CureItemStartDate=data.CureItemStartDate;
		var CureItemEndDate=data.CureItemEndDate;
		var CureItemCoverMainIns=data.CureItemCoverMainIns;
		var OrderPracticePre=data.OrderPracticePre;
		if (typeof(OrderPracticePre)=="undefined") {
			OrderPracticePre="";
		}
		var HiddenParaObj=GetHiddenParaObj(data.CureItemHiddenPara);
		var OpenForAllHosp=HiddenParaObj.OpenForAllHosp;
		var FindRecLocByLog=HiddenParaObj.FindRecLocByLog;
		var Delim=String.fromCharCode(3);
		var CopyCureData=MainDCARowID+Delim+CureItemRecLocRowid+Delim+CureItemFirstDayTimes+Delim+CureItemFreqDispTimeStr+Delim+CureItemStartDate;
			CopyCureData=CopyCureData+Delim+CureItemEndDate+Delim+CureItemCoverMainIns+Delim+OrderPracticePre+Delim+OpenForAllHosp+Delim+FindRecLocByLog;
		
		var Delim=String.fromCharCode(1);	
		var ItemData=code+"!"+OrderSeqNo+"!"+OrderDoseQty+Delim+OrderDoseUOM+Delim+OrderDoseUOMRowid;
		ItemData=ItemData+"^"+OrderFreq+Delim+OrderFreqRowid+Delim+OrderFreqFactor+Delim+OrderFreqInterval;
		ItemData=ItemData+"^"+OrderInstr+Delim+OrderInstrRowid;
		ItemData=ItemData+"^"+OrderDur+Delim+OrderDurRowid+Delim+OrderDurFactor;
		ItemData=ItemData+"^"+OrderPackQty+Delim+OrderPackUOM+Delim+OrderPackUOMRowid;
		ItemData=ItemData+"^"+OrderPrior+Delim+OrderPriorRowid+Delim+"";
		ItemData=ItemData+"^"+"";
		ItemData=ItemData+"^^"+""+"^"+OrderDepProcNote+"^"+""+"^"+"";
		ItemData=ItemData+"^"+OrderNotifyClinician+"^^^";
		ItemData=ItemData+"^"+OrdSpeedFlowRate+Delim+OrderFlowRateUnitdesc+Delim+OrderFlowRateUnit;
		ItemData=ItemData+"^"+OrderBodyPartLabel;
		ItemData=ItemData+"^"+OrderActionRowid+"^"+OrderAction+"^"+OrderSkinTest;
		ItemData=ItemData+"!"+OrderType+"!"+OrderBillTypeRowId+"!"+"Order";
		ItemData=ItemData+"!"+""+"!"+""+"!"+"";
		ItemData=ItemData+"!"+CopyCureData;
		
		Copyary[Copyary.length]=ItemData;
		//绑定医嘱
		var AppendDataObj=DataObj.CureItem[i].CureItemSelAppendItemObj;
		for (var j=0;j<AppendDataObj.Length;j++){
			var appenddata=AppendDataObj.AppendItem[j];
			var code=appenddata.CureAppItemID;
			var OrderType=appenddata.CureAppItemType;
			var OrderPrior=data.CureItemPrior
			var OrderPriorRowid=data.CureItemPriorRowid;
			var OrderDoseQty="";
			var OrderDoseUOM="";
			var OrderDoseUOMRowid="";
			var OrderFreq=data.CureItemFreq;
			var OrderFreqRowid=data.CureItemFreqRowid;
			var OrderFreqFactor=data.CureItemFreqFactor;
			var OrderFreqInterval=data.CureItemFreqInterval;
			var OrderInstr="";
			var OrderInstrRowid="";
			var OrderDur=data.CureItemDur;
			var OrderDurRowid=data.CureItemDurRowid;
			var OrderDurFactor=data.CureItemDurFactor;
			var CureAppItemQty=appenddata.CureAppItemQty;
			if (CureAppItemQty==" "){CureAppItemQty=""}; 
			if (CureAppItemQty!="") CureAppItemQty=+CureAppItemQty;
			var OrderPackUOM=appenddata.Baseuomdesc;
			var OrderPackUOMRowid=appenddata.baseuom;
			var OrderSeqNo=(Copyary.length+1); //OrderSeqNo+"."+(j+1);
			var OrderBodyPartLabel="";
			var OrderActionRowid="";
			var OrderAction="";
			var OrderSkinTest="";
			var OrderBillTypeRowId=OrderBillTypeRowId;
			var OrderDepProcNote=data.CureItemApplyRemark;
			var ARCOSRowid="";
			var OrderNotifyClinician="";
			var OrdSpeedFlowRate="";
			var OrderFlowRateUnit="";
			var OrderFlowRateUnitdesc="";
			var CureAppItemRecLocID=appenddata.CureAppItemRecLocID;
			var CureItemFirstDayTimes=data.CureItemFirstDayTimes;
			var DCARowID=CreateCureApply(code,CureAppItemRecLocID,data.CureItemApplyPlan,"","");
			if(DCARowID==false){
				return false;	
			}
			if(isNull(DCARowID)){DCARowID="";}
			var DCARowID=DCARowID+"&"+MainDCARowID;
			var OrderPackQty="";
			var OrderPackUOMRowid=appenddata.baseuom;
			if((OrderPackUOMRowid=="")||(typeof(OrderPackUOMRowid)=='undefined')){
				var BillUOMStr=$.cm({
					ClassName:"web.DHCDocOrderCommon",
					MethodName:	"GetBillUOMStr",
					ArcimRowid:code,
					LocRowid:CureAppItemRecLocID,
					dataType:"text"
				},false)	
				if(BillUOMStr!=""){
					var BillUOMArr=BillUOMStr.split(String.fromCharCode(1));
					OrderPackUOMRowid=BillUOMArr[0];
				}
			}
			if (OrderType=="R") {
				OrderPackQty=CureAppItemQty;
			}else{
				if ((CureAppItemQty=="")||(!isNumber(CureAppItemQty))||(parseInt(CureAppItemQty)==0)){
					OrderPackQty=1;
				}else{
					OrderPackQty=CureAppItemQty
					if(OrderPriorRowid!=ServerObj.ShortOrderPriorRowid){
						OrderDoseQty=CureAppItemQty
						OrderPackQty=""
					}
				}
			}
			OrderQtySum=OrderPackQty;
			var OrderPracticePre=appenddata.OrderPracticePre;
			if (typeof(OrderPracticePre)=="undefined") {
				OrderPracticePre="";
			}
			var Delim=String.fromCharCode(3);
			var CopyCureData=DCARowID+Delim+CureAppItemRecLocID+Delim+CureItemFirstDayTimes+Delim+CureItemFreqDispTimeStr+Delim+CureItemStartDate;
				CopyCureData=CopyCureData+Delim+CureItemEndDate+Delim+CureItemCoverMainIns+Delim+OrderPracticePre+Delim+OpenForAllHosp+Delim+FindRecLocByLog;;
			
			var Delim=String.fromCharCode(1);
			var ItemData=code+"!"+OrderSeqNo+"!"+OrderDoseQty+Delim+OrderDoseUOM+Delim+OrderDoseUOMRowid;
			ItemData=ItemData+"^"+OrderFreq+Delim+OrderFreqRowid+Delim+OrderFreqFactor+Delim+OrderFreqInterval;
			ItemData=ItemData+"^"+OrderInstr+Delim+OrderInstrRowid;
			ItemData=ItemData+"^"+OrderDur+Delim+OrderDurRowid+Delim+OrderDurFactor;
			ItemData=ItemData+"^"+OrderPackQty+Delim+OrderPackUOM+Delim+OrderPackUOMRowid;
			ItemData=ItemData+"^"+OrderPrior+Delim+OrderPriorRowid+Delim+"";
			ItemData=ItemData+"^"+"";
			ItemData=ItemData+"^^"+""+"^"+OrderDepProcNote+"^"+""+"^"+"";
			ItemData=ItemData+"^"+OrderNotifyClinician+"^^^";
			ItemData=ItemData+"^"+OrdSpeedFlowRate+Delim+OrderFlowRateUnitdesc+Delim+OrderFlowRateUnit;
			ItemData=ItemData+"^"+OrderBodyPartLabel;
			ItemData=ItemData+"^"+OrderActionRowid+"^"+OrderAction+"^"+OrderSkinTest;
			ItemData=ItemData+"!"+OrderType+"!"+OrderBillTypeRowId+"!"+"Order";
			ItemData=ItemData+"!"+""+"!"+""+"!"+"";
			ItemData=ItemData+"!"+CopyCureData;
			Copyary[Copyary.length]=ItemData;
		}
	}
	//console.log(Copyary)
	
	if (Copyary.length!=0){
		websys_showModal("hide");
		websys_showModal('options').AddCopyItemToList(Copyary);
		websys_showModal("close");
	}
}

function CreateCureApply(ArcimID, ReLocId,ApplyPlan, ApplyRemark,AssScaleID,POAJson){
	if(typeof AssScaleID=="undefined"){AssScaleID=""}
	if(typeof POAJson=="undefined"){POAJson=""}
	var DCARowID="";
	var ret=$.cm({
		ClassName:"DHCDoc.DHCDocCure.ApplyTree",
		MethodName:"CreateCureApply",
		EpisodeID:ServerObj.EpisodeID,
		ArcimID:ArcimID,
		ReLocId:ReLocId,
		UserID:session['LOGON.USERID'],
		ApplyPlan:ApplyPlan,
		ApplyRemark:ApplyRemark,
		HospID:session['LOGON.HOSPID'],
		AssScaleID:AssScaleID,
		POAJson:POAJson,
		ExpStr:ServerObj.ParaType,
		dataType:"text"
	},false)
	
	if(ret=="100"){
		//100不需要生成申请单	
	}else{
		var success=ret.split("^")[0];
		if(success!=0){
			$.messager.alert("提示","生成治疗申请单失败","warning");
			return false;
		}
		var DCARowID=ret.split("^")[1];	
	}
	DCARowID=DCARowID+"#"+AssScaleID;
	return DCARowID;
}
function DeleteFromAppendList(){
	//var row=PageApplyTreeObj.CureEntryItemListDataGrid.datagrid('getSelected');
	var checkedRows=PageApplyTreeObj.CureEntryItemListDataGrid.datagrid('getChecked');
	if ((!checkedRows)||(checkedRows.length==0)){
		$.messager.alert("提示","请勾选需要删除的记录","warning");
		return false;
	}
	$.messager.confirm("提示","是否确认删除选中的治疗申请医嘱?",function(r){
		if(r){
			var keepListDataAry=[];
			var oldListDataAry=PageApplyTreeObj.CureEntryItemListDataObj.CureItem;
			for(k=0;k<oldListDataAry.length;k++){
				var removeFlag=false;
				for (var i in checkedRows) {
					var rowIndex = PageApplyTreeObj.CureEntryItemListDataGrid.datagrid('getRowIndex', checkedRows[i]);
					if(k==rowIndex){
						removeFlag=true;	
					};
					if(rowIndex==PageApplyTreeObj.editEntryItemRow){
						Clear_Mes();
						ChangeBtnStyle("N");
					}
				}
				if(!removeFlag)keepListDataAry.push(oldListDataAry[k]);
			}
			var keepListDataObj={
				Length:	keepListDataAry.length,
				CureItem: keepListDataAry
			}
			$.extend(PageApplyTreeObj.CureEntryItemListDataObj,keepListDataObj);
			LoadCureEntryItemListData(PageApplyTreeObj.CureEntryItemListDataObj,function(){
				PageApplyTreeObj.CureEntryItemListDataGrid.datagrid("clearChecked");	
			});
		}
	})
}

function LoadCureEntryItemListData(obj){
	var dataobj={
		rows:[],
		total:0,
		curPage:1	
	}
	dataobj.total=obj.Length;
	dataobj.rows=obj.CureItem;
	PageApplyTreeObj.CureEntryItemListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',dataobj); 
	if(typeof callBackFun == 'function'){
		callBackFun();	
	}else{
		PageApplyTreeObj.CureEntryItemListDataGrid.datagrid("clearSelections").datagrid("clearChecked");
	}
}
//-------------治疗申请待添加到医嘱录入医嘱信息列表结束----------------------

function CheckDiagnose(OrderARCIMRowid,callBackFun) {
	var OrdNeedMMDiag=0;
	if (OrderARCIMRowid!="") {
		var ItemCatRowid=tkMakeServerCall("web.DHCDocOrderCommon", "GetOrderSubCat", OrderARCIMRowid);
		if (ServerObj.OrdNeedMMDiagCat.indexOf("^"+ItemCatRowid+"^") >=0) {
			OrdNeedMMDiag=1;
		}
	}
	new Promise(function(resolve,rejected){
		if ((ServerObj.OrderLimit==1)||(ServerObj.PAADMMotherAdmId!="")||(ServerObj.PAAdmType=="H")) {
			resolve(true);
			return;
		}
		var NeedDiagnosFlag = 1,NoDiagnosMsg="";
		if (OrdNeedMMDiag == 1){
		    var Ret=tkMakeServerCall("web.DHCDocOrderEntry", "GetMMDiagnoseCount", ServerObj.mradm);
		    NoDiagnosMsg=$g("没有西医诊断,请先录入!");
		}else{
			//新门诊病历界面,录入诊断或删除诊断后未刷新医嘱录入界面,导致诊断数据取的错误
	    	var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMRDiagnoseCount", ServerObj.mradm);
	    	NoDiagnosMsg=$g("没有诊断,请先录入!");
        }
    	ServerObj.MRDiagnoseCount = Ret;
    	if ((ServerObj.MRDiagnoseCount == 0) && (NeedDiagnosFlag == 1)) {
	    	var iframeName = window.name
            if (iframeName == "") {
                //iframeName = window.parent.frames("oeordFrame").name
            }
            if ((iframeName == "oeordFrame")||(ServerObj.CareProvType != "DOCTOR")) {
                resolve(true);
            }else{
		    	(function(callBackFunExec){
				    new Promise(function(resolve,rejected){
						$.messager.alert("提示",NoDiagnosMsg,"info",function(){
							websys_showModal({
								url:"diagnosentry.v8.csp?PatientID=" + ServerObj.PatientID + "&EpisodeID=" + ServerObj.EpisodeID + "&mradm=" + ServerObj.mradm,
								title:$g('诊断录入'),
								//width:screen.availWidth-100,height:screen.availHeight-200, //((top.screen.width - 200)),height:(top.screen.height - 230),
								width:"95%",height:screen.availHeight-200,
                                onClose:function(){
									if (OrdNeedMMDiag == 1){
									    var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMMDiagnoseCount", ServerObj.mradm);
									}else{
								    	var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMRDiagnoseCount", ServerObj.mradm);
									}
						            ServerObj.MRDiagnoseCount = Ret;
						            if (Ret == 0) {
							            Ret = false;
							        }else{
								        Ret = true;
								    	ServerObj.CurrDateTime=$.cm({
											ClassName:"DHCDoc.DHCDocCure.Common",
											MethodName:"GetCurrendDateTime",
											EpisodeID:ServerObj.EpisodeID,
											dataType:"text"
										},false)
								    }
						            //$(this).parent().empty(); //基础平台已统一处理,无需单独处理
									resolve(Ret);
								}
							})
				    	})
					}).then(function(rtn){
						callBackFunExec(rtn);
					});
			    })(resolve);
            }
	    }else{
		    //存在诊断
		    resolve(true);
		}
	}).then(function(rtn){
		callBackFun(rtn);
	})
}

//住院急诊流管押金控制
function CheckDeposit(arcim) {
	var amount=$('#OrderPrice').val();
	if (ServerObj.VisitStatus=="P") return true;
    if (ServerObj.NotDoCheckDeposit==1) return true;
    if (ServerObj.SupplementMode==1){return true;}
    if ((ServerObj.PAAdmType != "I") && (ServerObj.GetStayStatusFlag != 1) && (ServerObj.GetStayStatusFlag != 2)) { return true }
    if (ServerObj.CheckIPDepositMethod != "") {
        var retDetail = cspRunServerMethod(ServerObj.CheckIPDepositMethod, ServerObj.EpisodeID, amount, "OE");
        if (retDetail != 0) {
            var retArray = retDetail.split("^");
            if (retArray[4] == 'C') {
                if (retArray[5] == 'N') {
                    $.messager.alert("提示",$g("押金余额不足") + retArray[0]+","+$g("无法申请"));
                    return false;
                } else {
                    if (arcim != "") {
                        var retDetail = cspRunServerMethod(ServerObj.CheckDepositOrderMethod, ServerObj.EpisodeID,retArray[2], arcim);
                        if (retDetail == 0) {
                            $.messager.alert("提示",$g("押金余额不足") + retArray[0]+","+$g("无法申请"));
                            return false;
                        }
                    }
                }
            }
        }
    }
    return true;
}

function isNull(obj){
    return obj === null;
}

function isNumber(objStr) {
    var strRef = "-1234567890.";
    for (i = 0; i < objStr.length; i++) {
        tempChar = objStr.substring(i, i + 1);
        if (strRef.indexOf(tempChar, 0) == -1) { return false; }
    }
    return true;
}

function mPiece(s1, sep, n) {
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length - 1) && (n >= 0)) return delimArray[n];
}
function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
	    var CombValue=Data[i].CombValue  
	 	var CombDesc=Data[i].CombDesc
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}

function ChangeElementStyle(StyleConfigObj) {
    for (var key in StyleConfigObj) {
        var name = key;
        var value = StyleConfigObj[key];
        if (value == undefined) { continue; }
        
        var className=$("#"+name).attr("class")
		if(typeof className =="undefined"){
			continue;
		}
		if((className.indexOf("hisui-lookup")>=0)||(className.indexOf("lookup-text")>=0)){
	        if (value == false) {
		        $("#" + name).lookup('disable');
		    }else{
			    $("#" + name).lookup('enable');
			}
        }else if(className.indexOf("hisui-combobox")>=0){
	        if (value == false) {
		        $HUI.combobox("#"+name).disable();  
		    }else{
			    $HUI.combobox("#"+name).enable();
			}
	    }else if(className.indexOf("hisui-datetimebox")>=0){
	        if (value == false) {
		        $HUI.datetimebox("#"+name).disable();  
		    }else{
			    $HUI.datetimebox("#"+name).enable();
			}
	    }else if(className.indexOf("hisui-checkbox")>=0){
	        if (value == false) {
		        $HUI.checkbox("#"+name).disable();  
		    }else{
			    $HUI.checkbox("#"+name).enable();
			}
	    }else{
            if (value == false) {
                $("#" + name).attr('disabled', true);
            } else if (value == true) {
                $("#" + name).attr('disabled', false);
            }
        }
	}
}

function Page_OnKeyDown(e){
	//防止在空白处敲退格键，界面自动回退到上一个界面
	if (!websys_cancelBackspace(e)) return false;
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
    if (e){
        var ctrlKeyFlag=e.ctrlKey;
    }else{
        var ctrlKeyFlag=window.event.ctrlKey;
    }
    if (ctrlKeyFlag){
        return false;
	}
}

$.extend($.fn.datagrid.defaults.editors, {
    textReadonly: {
        init: function (container, options) {
            var input = $('<input type="text" disabled "readonly" readonly="readonly" class="datagrid-editable-input">').appendTo(container);
            return input;
        },

        getValue: function (target) {
            return $(target).val();
        },

        setValue: function (target, value) {
            $(target).val(value);
        },

        resize: function (target, width) {
            var input = $(target);
            if ($.boxModel == true) {
                input.width(width - (input.outerWidth() - input.width()));
            } else {
                input.width(width);
            }
        }
    }
});

function CheckBeforeAdd(DataObj,callBackFun){
	var ArcDesc=DataObj.CureItemArcDesc;
	new Promise(function(resolve,rejected){
		//医嘱与特慢病是否匹配
		var NotChronicMatchMsg=ChkChronicOrdItm(DataObj);
		if (NotChronicMatchMsg!="") {
			$.messager.alert("提示",NotChronicMatchMsg);
			return;	
		}
		resolve();
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			CheckDiagnose(DataObj.CureItemRowid,resolve);
		})
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			if (!rtn) {
		        callBackFun(false);
			}else{
				resolve()	
			}
		})
		
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if(ServerObj.EpisodeID==""){
				$.messager.alert("提示",$g("就诊信息获取错误!"),"warning",function(){
					resolve(false);
				});
				return false;	
			}
			var ItemRowID=DataObj.CureItemRowid;
			if(ItemRowID==""){
				$.messager.alert("提示",ArcDesc+" "+$g("请选择一条治疗医嘱."),"warning",function(){
					resolve(false);
				});
				return false;	
			}
			if(!CheckDeposit(ItemRowID)){
				return false;		
			}
			var OrderPriorRowid=DataObj.CureItemPriorRowid;
			if(OrderPriorRowid==""){
				$.messager.alert("提示信息",ArcDesc+" "+$g("请选择医嘱类型."),"warning",function(){
					$("#OrderPrior").focus();
					resolve(false);
				});
				return false;
			}
			var OrderQty=DataObj.CureItemPackQty;
			if(OrderPriorRowid!=ServerObj.LongOrderPriorRowid){
				if(OrderQty==""){
					$.messager.alert("提示信息",ArcDesc+" "+$g("请填写数量."),"warning",function(){
						$("#OrderQty").focus();
						resolve(false);
					});
					return false;
				}
				
				var TmpOrderQty=parseFloat(OrderQty);
				if(TmpOrderQty<=0){
					$.messager.alert("提示信息",ArcDesc+" "+$g("数量请填写大于0整数."),"warning",function(){
						$("#OrderQty").focus();
						resolve(false);
					});
					return false;
				}
				var BillingUOMDr=DataObj.CureItemPackUOM;
				if(BillingUOMDr==""){
					$.messager.alert("提示信息",ArcDesc+" "+$g("请选择数量单位."),"warning",function(){
						$("#OrderQty").focus();
						resolve(false);
					});
					return false;
				}
				var objDur = document.getElementById("OrderDur");
		        if ((objDur) && ($("#OrderDur").attr("disabled")!="disabled")){ //(!objDur.disabled)
		        	var OrderDurRowid=DataObj.CureItemDurRowid;
					var OrderDur=DataObj.CureItemDur;
					if ((OrderDurRowid=="")||(OrderDur=="")){
						$.messager.alert("提示信息", ArcDesc+" "+$g("请选择疗程."),"warning",function(){
					        $("#OrderDur").focus();
					        resolve(false);
					    });
				        return false;
					}
				}
			}
			var OrderReLocDr=DataObj.CureItemRecLocRowid;
			if (OrderReLocDr==""){
				$.messager.alert("提示信息",ArcDesc+" "+$g("请选择接收科室."),"warning",function(){
					$("#OrderReLoc").focus();
					resolve(false);
				});
				return false;
			}
			var OrderBillTypeDr=DataObj.CureItemBillTypeRowId;
			if(OrderBillTypeDr==""){
				$.messager.alert("提示信息",ArcDesc+" "+$g("请选择费别."),"warning",function(){
					$("#OrderBillType").focus();
					resolve(false);
				});	
				return false;
			}
			var CureItemStartDate=DataObj.CureItemStartDate;
			if(CureItemStartDate==""){
				$.messager.alert("提示信息",ArcDesc+" "+$g("请选择开始日期."),"warning",function(){
					$("#OrderStartDate").focus();
					resolve(false);
				});
				return false;
			}
			var CureItemEndDate=DataObj.CureItemEndDate;
			if(CureItemEndDate!=""){
				var OrderStartDateMain = "",OrderStartTimeMain="",
		        OrderEndDateMain = "" ,OrderEndTimeMain="";
				var OrderStartDate = CureItemStartDate.replace(/(^\s*)|(\s*$)/g, '')
			    if (OrderStartDate != "") {
				    OrderStartDateMain = OrderStartDate.split(" ")[0];
				    OrderStartTimeMain = OrderStartDate.split(" ")[1];
				    OrderStartTimeMain=formateTime(OrderStartTimeMain);
				}
				var OrderEndDate = CureItemEndDate.replace(/(^\s*)|(\s*$)/g, '')
			    OrderEndDateMain = OrderEndDate.split(" ")[0];
			    OrderEndTimeMain = OrderEndDate.split(" ")[1];
			    OrderEndTimeMain=formateTime(OrderEndTimeMain);
				if (!CompareDate(OrderStartDateMain, OrderEndDateMain)){
				    $.messager.alert("警告", ArcDesc + " " +$g("医嘱结束日期不能小于医嘱开始日期"),"warning",function(){
						$("#OrderEndDate").focus();
						resolve(false);
					});
					return false;
				}
			    if ((OrderEndDateMain==OrderStartDateMain)&&(OrderStartTimeMain>OrderEndTimeMain)){
					$.messager.alert("警告", ArcDesc +" "+$g("医嘱结束时间不能小于医嘱开始时间"),"warning",function(){
						$("#OrderEndDate").focus();
						resolve(false);
					});
					return false;
				}
			}
			
			var OrderType=DataObj.OrderType;
			var OrderDoseQty=DataObj.CureItemDoseQty;
			var OrderFreqRowid=DataObj.CureItemFreqRowid;
			var OrderFreq=DataObj.CureItemFreq;
			var OrderDoseUOMRowid=DataObj.CureItemDoseUOM;
			var OrderDoseUOM=DataObj.CureItemDoseUOMDesc;
			var OrderDurRowid=DataObj.CureItemDurRowid;
			var OrderDur=DataObj.CureItemDur;
			
			var OrdItemArr=new Array();
			var OrdItem=ItemRowID+"^"+OrderType+"^"+OrderPriorRowid+"^"+OrderFreqRowid;
			OrdItemArr.push(OrdItem);
			if(OrderType=="R"){
			    if ((OrderDoseQty == '') || (parseFloat(OrderDoseQty) == 0) || (isNumber(OrderDoseQty) == false)) {
			        $.messager.alert("提示信息",ArcDesc +" "+$g("请正确填写单次剂量."),"warning",function(){
				        $("#OrderDoseQty").focus();
				        resolve(false);
				    });
			        return false;
			    }
				if(parseFloat(OrderDoseQty) < 0) {
			        $.messager.alert("提示信息",ArcDesc +" "+$g("剂量不能为负数."),"warning",function(){
				        $("#OrderDoseQty").focus();
				        resolve(false);
				    });
			        return false;
			    }
			    if ((OrderFreqRowid == '') || (OrderFreq == "")) {
			        $.messager.alert("提示信息", ArcDesc +" "+$g("请填写频次."), "warning", function() { 
			        	$("#OrderFreq").focus();
			        	resolve(false);
			        });
			        return false;
			    }

			    if (((OrderDoseUOMRowid == '') || (OrderDoseUOM == ""))) {
			        $.messager.alert("提示信息", ArcDesc +" "+$g("请选择剂量单位."), "warning", function() {
				        $("#OrderDoseUOM").focus();
				        resolve(false);
			        });
			        return false;
			    }
			    if (((OrderDurRowid == '') || (OrderDur == '')) && (OrderPriorRowid != ServerObj.LongOrderPriorRowid)) {
			        $.messager.alert("提示信息", ArcDesc + " "+$g("请选择疗程."), "warning", function() {
				        $("#OrderDur").focus();
				        resolve(false);
			        });
			        return false;
			    }	
			}
			var OrderFirstDayTimes=DataObj.CureItemFirstDayTimes;
			var OrderFreqFactor=DataObj.CureItemFreqFactor;
			if((OrderFreqFactor>0)&&(OrderFirstDayTimes!="")&&(OrderFreqFactor<parseInt(OrderFirstDayTimes))){
				$.messager.alert("提示信息", ArcDesc + " "+$g("首日医嘱执行次数超过频次最大数."), "warning", function() {
			        $("#OrderFirstDayTimes").focus();
			        resolve(false);
		        });
		        return false;	
			}
			var AppendDataObj=DataObj.CureItemSelAppendItemObj;
			if((!isNull(AppendDataObj))&&(typeof AppendDataObj!='undefined')){
				for (var j=0;j<AppendDataObj.Length;j++){
					var appenddata=AppendDataObj.AppendItem[j];
					var CureAppItemID=appenddata.CureAppItemID;
					var CureAppItemQty=appenddata.CureAppItemQty;
					var CureAppItemDesc=appenddata.CureAppItemDesc;
					var CureAppItemType=appenddata.CureAppItemType;
					var AppOrdItem=CureAppItemID+"^"+CureAppItemType+"^"+OrderPriorRowid+"^"+OrderFreqRowid+"^"+ItemRowID;
					OrdItemArr.push(AppOrdItem);
			
					if(CureAppItemQty==""){
						$.messager.alert("提示信息",CureAppItemDesc+ " "+$g("请填写数量."),"warning",function(){
							resolve(false);
						});
						return false;
					}
					
					var TmpCureAppItemQty=parseFloat(CureAppItemQty);
					if(TmpCureAppItemQty<=0){
						$.messager.alert("提示信息",CureAppItemDesc+ " "+$g("数量请填写大于0的整数."),"warning",function(){
							resolve(false);
						});
						return false;
					}
					var OrderReLocDr=appenddata.CureAppItemRecLocID;
					if (OrderReLocDr==""){
						$.messager.alert("提示信息",CureAppItemDesc+ " "+$g("请选择接收科室."),"warning",function(){
							resolve(false);
						});
						return false;
					}
				}
			}
			
			if(OrdItemArr.length>0){
				var OrdItemStr=OrdItemArr.join(String.fromCharCode(1));
				var PPRowId=getParam("PPRowId");
				var AdmReason=$("#OrderBillType").combobox('getValue');
				var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^"+PPRowId+"^"+AdmReason;
				var ExpStr=ExpStr+"^"+session['LOGON.LANGID']
				var ErrObject=$.cm({
					ClassName:"DHCDoc.DHCDocCure.ApplyTree",
					MethodName:"CheckNotDrugUpdate",
					Adm:ServerObj.EpisodeID,
					OrdItem:OrdItemStr,
					ExpStr:ExpStr
				},false)
				
				if (ErrObject.ErrMsg != ""){
					var SetFocusItem=ErrObject.SetFocusItem;
					if(ErrObject.ErrCode==0){
						$.messager.alert("提示",ErrObject.ErrMsg,"info");
					}else{
						$.messager.alert("提示",ErrObject.ErrMsg,"warning", function() {
							if(SetFocusItem!="" && typeof(SetFocusItem)!="undefined"){
					        	$("#"+SetFocusItem).focus();
							}
					        resolve(false);
				        });	
			        	return false;
					}
				}
			}
			
			resolve(true);
		})
	}).then(function(rtn){
		callBackFun(rtn);
	});
}

function formateTime(time){
	if (time=="") return time;
	if(time.split(":").length==2){
		time=time+":00";
	}
	var NewTime="";
	for (var timei=0;timei<time.split(":").length;timei++){
		var OneTime=time.split(":")[timei];
		if ((+OneTime<=9)&&(OneTime.length==1)) OneTime="0"+OneTime;
		if (NewTime=="") NewTime=OneTime;
		else NewTime=NewTime+":"+OneTime;
	}
	return NewTime.replace(/:/g,"");
}

function SaveCureApply(ParaType)
{
	var retobj=GetCureOrderItemStr();	
	var DCARowIDStr=retobj.DCARowIDStr;
	var OrderItemStr=retobj.OrderItemStr;
	if((OrderItemStr=="")&&(DCARowIDStr=="")){
		$.messager.alert('提示',$g("没有需要申请的治疗医嘱."),"info");
		return true;
	}
	//医嘱审核时
	if(ServerObj.ParaType=="OEOrdEntryUpdate"){
		var returnValue=DCARowIDStr+String.fromCharCode(3)+OrderItemStr;
		if ((websys_showModal('options'))&&(websys_showModal('options').CallBackFunc)) {
			websys_showModal('options').CallBackFunc(returnValue);
		}else{
			window.returnValue = returnValue;
			window.close();
		}
	}else{
		//独立菜单确认
		var UpdateObj={}
		new Promise(function(resolve,rejected){
			//检查医嘱锁
			var SessionStr=GetSessionStr();
			var InputObj={
				orderRow:"",
				EpisodeID:ServerObj.EpisodeID,
				EmConsultItm:"",
				SessionStr:SessionStr
			}
			Common_ControlObj.BeforeUpdate("checkOrderLock",InputObj,resolve);
		}).then(function(ret){
			return new Promise(function(resolve,rejected){
		    	if (!ret) {
			    	UpdateClickHandlerFinish();
		    		return websys_cancel();
		    	}
		    	//电子签名
				//CASignObj.CASignLogin(resolve,"OrderSave",false)
				var CAInputObj={
					callType:"OrderSave",
					isHeaderMenuOpen:false
				}
				Common_ControlObj.BeforeUpdate("CASignCheck",CAInputObj,resolve);
			})
		}).then(function(RtnObj){
			return new Promise(function(resolve,rejected){
		    	if (RtnObj.PassFlag == false) {
			    	UpdateClickHandlerFinish();
		    		return websys_cancel();
		    	} else{
			    	$.extend(UpdateObj, RtnObj.CAObj);
			    	resolve(true);
		    	}
			})
		}).then(function(ret){
			return new Promise(function(resolve,rejected){
				//统一第三方接口调用,参照医生站配置->外部接口测试->对外接口接入管理下的关联开启数据
				var myInputObj={
					EpisodeID:ServerObj.EpisodeID,
					PAAdmType:ServerObj.PAAdmType,
					OrderItemStr:OrderItemStr,
					CallBackFunc:resolve
				}
				Common_ControlObj.BeforeUpdate("Interface",myInputObj,resolve);
			})
		}).then(function(ret){
			return new Promise(function(resolve,rejected){
				if (ret==false || ret.SuccessFlag==false) {
					UpdateClickHandlerFinish();
					return websys_cancel();
				}else{
					if(ret.UpdateFlag){
						OrderItemStr=ret.UpdateOrderItemStr;	
					}
				}
		    	var CDSSInputObj={
					OrderItemStr:OrderItemStr,
					EpisodeID:ServerObj.EpisodeID
				}
				//CDSS事前预警
				Common_ControlObj.BeforeUpdate("CDSSCheck",CDSSInputObj,resolve);
			})
		}).then(function(ret){	
			if (!ret) {
				UpdateClickHandlerFinish();
		        return websys_cancel();
			}
			var ExpStr=ServerObj.PPRowId+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']+"^"+ServerObj.NotAdmTypeLimit;
			$.m({
				ClassName:"DHCDoc.DHCDocCure.ApplyTree",
				MethodName:"InsertCureApply",
				'EpisodeID':ServerObj.EpisodeID,
				'OrderStr':OrderItemStr,
				'USERID':session['LOGON.USERID'],
				'CTLOCID':session['LOGON.CTLOCID'],
				'GroupID':session['LOGON.GROUPID'],
				'ExpStr':ExpStr,
			},function testget(value){
				var success=value.split("!")[0];
				var msg=value.split("!")[1];
				if(success==0){
					PageApplyTreeObj.CureEntryItemListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',{total: 0, rows: []});
					PageApplyTreeObj.CureEntryItemListDataObj={
						CureItem:[],
						Length:0,
					}
					$.messager.popover({msg:"申请成功.",type:"success",timeout:2000});
					if (parent.UpdateTabsTilte) {
						parent.UpdateTabsTilte();
					}
					UpdateClickHandlerFinish();
					Clear_Mes();
					CureApplyListDataGridLoad();
					$.extend(UpdateObj,{
						OEOrdItemIDs:msg,
						EpisodeID:ServerObj.EpisodeID,
						PAAdmType:ServerObj.PAAdmType,
						LogonDoctorID:ServerObj.LogonDoctorID,
						SetArriveByOrder:ServerObj.SetArriveByOrder
					})
					Common_ControlObj.AfterUpdate("SynData",UpdateObj);   //数据同步【CA、CDSS、置到达】
					Common_ControlObj.AfterUpdate("Interface",UpdateObj);	//第三方接口调用
					/*
					if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, msg, "A");
					$.messager.alert('提示',$g("申请成功."),"info",function(){
						if (parent.UpdateTabsTilte) {
							parent.UpdateTabsTilte();
						}
						Clear_Mes();
						CureApplyListDataGridLoad();
						if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, msg, "A");
					});*/
					return true;
				}else{
					$.messager.alert('提示',msg,"warning");
					UpdateClickHandlerFinish();
					return false;
				}	
			})
		})
	}
}

function GetCureOrderItemStr(){
	var DataObj=PageApplyTreeObj.CureEntryItemListDataObj;
	//console.log(DataObj)
	var count=1;
	var OrderItemStr="";
	var DCARowIDStr="";
	for (var i=0;i<DataObj.Length;i++){
		var data=DataObj.CureItem[i];
		var oneobj=GetOneCureOrderItem(data,count);
		count=oneobj.count;
		if (DCARowIDStr == "") { DCARowIDStr = oneobj.DCARowIDStr} else { DCARowIDStr = DCARowIDStr + "@" + oneobj.DCARowIDStr }
		if (oneobj.OrderItemStr !="") {
			if (OrderItemStr == "") { OrderItemStr = oneobj.OrderItemStr } else { OrderItemStr = OrderItemStr + String.fromCharCode(1) + oneobj.OrderItemStr }
		}
	}
	return {
		DCARowIDStr:DCARowIDStr,
		OrderItemStr:OrderItemStr
	}	
}

function GetOneCureOrderItem(data,numval){
	//if(!CheckBeforeAdd(data)){
	//	return false;	
	//}
	var OrderItemStr="";
	var DCARowIDStr="";
	var OrderARCIMRowid=data.CureItemRowid;
	var OrderType=data.OrderType;
	var OrderPriorRowid=data.CureItemPriorRowid;
	var OrderStartDate=data.CureItemStartDate.split(" ")[0];
	var OrderStartTime=data.CureItemStartDate.split(" ")[1];
	var OrderEndDateStr=data.CureItemEndDate;
	var OrderEndDate = "";
    var OrderEndTime = "";
    if (OrderEndDateStr != "") {
        OrderEndDate = OrderEndDateStr.split(" ")[0];
        OrderEndTime = OrderEndDateStr.split(" ")[1];
    }
	var OrderPackQty=data.CureItemPackQty;
	var OrderPrice=data.CureItemPrice;
	var OrderRecDepRowid=data.CureItemRecLocRowid;
	var BillTypeRowid=data.CureItemBillTypeRowId;
	if (ServerObj.PPRowId!="") {
		if (ServerObj.PAAdmType == "I") {
	        if (ServerObj.CFIPPilotPatAdmReason != "") BillTypeRowid = ServerObj.CFIPPilotPatAdmReason;
	    } else {
	        if (ServerObj.CFPilotPatAdmReason != "") BillTypeRowid = ServerObj.CFPilotPatAdmReason;
	    }
    }
	var OrderDrugFormRowid="";
	var OrderDepProcNotes="";
	var OrderDoseQty=data.CureItemDoseQty;
	var OrderDoseUOMRowid=data.CureItemDoseUOM;
	var OrderQtySum=OrderPackQty; //???
	var OrderFreqRowid=data.CureItemFreqRowid;
	var OrderDurRowid=data.CureItemDurRowid;
	var OrderInstrRowid="";
	var PHPrescType=data.OrderPHPrescType;
	var OrderMasterSeqNo="";
	if(typeof(data.CureItemMasterSeqNo)!='undefined'){
		OrderMasterSeqNo=data.CureItemMasterSeqNo;	
	}
	var OrderSeqNo="";
	OrderSeqNo=numval;
	numval=numval+1;
	var OrderSkinTest="";
	var OrderPhSpecInstr="";
	var OrderCoverMainIns=data.CureItemCoverMainIns;
	var CureItemAssScaleID=data.CureItemAssScaleID;
	var CureItemPOAInfo=data.CureItemPOAInfo;
	var MainDCARowID=CreateCureApply(OrderARCIMRowid,OrderRecDepRowid,data.CureItemApplyPlan,data.CureItemApplyRemark,CureItemAssScaleID,CureItemPOAInfo);
	if(MainDCARowID==false){
		return false;	
	}
	if (data.CureItemOrderDate) {
		var OrderDate=data.CureItemOrderDate.split(" ")[0];
		var OrderTime=data.CureItemOrderDate.split(" ")[1];
	}else{
		var OrderDate=ServerObj.CurrDateTime.split(" ")[0];
		var OrderTime=ServerObj.CurrDateTime.split(" ")[1];
	}
	var OrderFirstDayTimes=data.CureItemFirstDayTimes;
	var OrderPackUOMRowid=data.CureItemPackUOM;
	var OrderFreqDispTimeStr=data.CureItemFreqDispTimeStr;
	var OrderFreqExpInfo=CalOrderFreqExpInfo(OrderFreqDispTimeStr);
	var OrderFreqWeekStr=mPiece(OrderFreqExpInfo, "^", 0);
	var OrderFreqFreeTimeStr=mPiece(OrderFreqExpInfo, "^", 1);
	//alert(data.CureItemSeqNo)
	var OrderFreqInfo=data.CureItemFreqFactor+"^"+data.CureItemFreqInterval+"^"+data.CureItemFreqDispTimeStr;
	var OrderStartDateStr=OrderStartDate+" "+OrderStartTime;
	var OrderInciRowid="";
	var OrderQtyInfo=GetOrderQtyInfo(OrderType,OrderDoseQty,OrderFreqInfo,data.CureItemDurFactor,OrderStartDateStr,OrderFirstDayTimes,OrderPackQty,OrderARCIMRowid)
	var OrderQtySum=mPiece(OrderQtyInfo, "^", 0)
	var OrderPackQty=mPiece(OrderQtyInfo, "^",1)
	var OrderFreqTimeDoseStr="";
	var OrderPracticePre=data.OrderPracticePre;
	if (typeof(OrderPracticePre)=="undefined") {
		OrderPracticePre="";
	}
	var ChronicDiagCode=data.ChronicDiagCode;
	//医嘱录入审核时,治疗医嘱不需要再插入一遍医嘱串
	if(ServerObj.ParaType!="OEOrdEntryUpdate"){
		OrderItem = OrderARCIMRowid + "^" + OrderType + "^" + OrderPriorRowid + "^" + OrderStartDate + "^" + OrderStartTime + "^" + OrderPackQty + "^" + OrderPrice;
        OrderItem = OrderItem + "^" + OrderRecDepRowid + "^" + BillTypeRowid + "^" + OrderDrugFormRowid + "^" + OrderDepProcNotes;
        OrderItem = OrderItem + "^" + OrderDoseQty + "^" + OrderDoseUOMRowid + "^" + OrderQtySum + "^" + OrderFreqRowid + "^" + OrderDurRowid + "^" + OrderInstrRowid;
        OrderItem = OrderItem + "^" + PHPrescType + "^" + OrderMasterSeqNo + "^" + OrderSeqNo + "^" + OrderSkinTest + "^" + OrderPhSpecInstr + "^" + OrderCoverMainIns;
        var OrderItemAry=OrderItem.split("^");
        OrderItemAry[25]=OrderEndDate;
        OrderItemAry[26]=OrderEndTime;
        OrderItemAry[32]=OrderFirstDayTimes;
        OrderItemAry[45]=OrderDate;
        OrderItemAry[46]=OrderTime;
        OrderItemAry[54]=OrderPackUOMRowid;
        OrderItemAry[55]=ServerObj.PPRowId;
        OrderItemAry[59]=MainDCARowID;
        OrderItemAry[66]=OrderFreqWeekStr;
        OrderItemAry[68]=OrderPracticePre;;
        OrderItemAry[69]=OrderFreqTimeDoseStr;
        OrderItemAry[81]=ChronicDiagCode;
        OrderItemAry[82]=OrderFreqFreeTimeStr;
        OrderItem = OrderItemAry.join("^");
		if (OrderItemStr == "") { OrderItemStr = OrderItem } else { OrderItemStr = OrderItemStr + String.fromCharCode(1) + OrderItem }
	}else{
		if (DCARowIDStr == "") { DCARowIDStr = MainDCARowID+"^"+data.CureItemSeqNo} 
		else { DCARowIDStr = DCARowIDStr + "@" + MainDCARowID+"^"+data.CureItemSeqNo }
	}

	//绑定医嘱
	var AppendMasterSeqNo=OrderSeqNo;
	if(OrderMasterSeqNo!=""){
		AppendMasterSeqNo=OrderMasterSeqNo;
	}
	var AppendDataObj=data.CureItemSelAppendItemObj;
	if((!isNull(AppendDataObj))&&(typeof AppendDataObj!='undefined')){
		for (var j=0;j<AppendDataObj.Length;j++){
			var appenddata=AppendDataObj.AppendItem[j];
			var OrderARCIMRowid=appenddata.CureAppItemID;
			var OrderType=appenddata.CureAppItemType;
			var OrderPriorRowid=data.CureItemPriorRowid;
			var OrderStartDate=OrderStartDate;
			var OrderStartTime=OrderStartTime;
			var CureAppItemQty=appenddata.CureAppItemQty;
			var OrderPrice=appenddata.Price;
			
			var OrderRecDepRowid=appenddata.CureAppItemRecLocID;
			var BillTypeRowid=data.CureItemBillTypeRowId;
			if (ServerObj.PPRowId!="") {
				if (ServerObj.PAAdmType == "I") {
					if (ServerObj.CFIPPilotPatAdmReason != "") BillTypeRowid = ServerObj.CFIPPilotPatAdmReason;
				} else {
					if (ServerObj.CFPilotPatAdmReason != "") BillTypeRowid = ServerObj.CFPilotPatAdmReason;
				}
			}
			var OrderDrugFormRowid="";
			var OrderDepProcNotes="";
			var OrderDoseQty="";
			var OrderDoseUOMRowid="";
			var OrderFreqRowid=data.CureItemFreqRowid;
			var OrderDurRowid=data.CureItemDurRowid;
			var OrderInstrRowid="";
			var PHPrescType="";
			var OrderMasterSeqNo=""; //AppendMasterSeqNo;
			var OrderSeqNo=numval;
			numval=numval+1;
			var OrderSkinTest="";
			var OrderPhSpecInstr="";
			var OrderCoverMainIns=data.CureItemCoverMainIns;
			var DCARowID=CreateCureApply(OrderARCIMRowid,OrderRecDepRowid,data.CureItemApplyPlan,data.CureItemApplyRemark,"");
			if(DCARowID==false){
				return false;	
			}
			if(isNull(DCARowID)){DCARowID="";}
			var DCARowID=DCARowID+"&"+MainDCARowID;
			var OrderFirstDayTimes=data.CureItemFirstDayTimes;
			var OrderPackUOMRowid=appenddata.baseuom;
			if((OrderPackUOMRowid=="")||(typeof(OrderPackUOMRowid)=='undefined')){
				var BillUOMStr=$.cm({
					ClassName:"web.DHCDocOrderCommon",
					MethodName:	"GetBillUOMStr",
					ArcimRowid:OrderARCIMRowid,
					LocRowid:OrderRecDepRowid,
					dataType:"text"
				},false)	
				if(BillUOMStr!=""){
					var BillUOMArr=BillUOMStr.split(String.fromCharCode(1));
					OrderPackUOMRowid=BillUOMArr[0];
				}
			}
			var OrderFreqDispTimeStr=data.CureItemFreqDispTimeStr;
			var OrderFreqExpInfo=CalOrderFreqExpInfo(OrderFreqDispTimeStr);
			var OrderFreqWeekStr=mPiece(OrderFreqExpInfo, "^", 0);
			var OrderFreqFreeTimeStr=mPiece(OrderFreqExpInfo, "^", 1);
			var OrderPackQty="";
			if (OrderType=="R") {
				OrderPackQty=CureAppItemQty;
			}else{
				if ((CureAppItemQty=="")||(!isNumber(CureAppItemQty))||(parseInt(CureAppItemQty)==0)){
					OrderPackQty=1;
				}else{
					OrderPackQty=CureAppItemQty
					if(OrderPriorRowid!=ServerObj.ShortOrderPriorRowid){
						OrderDoseQty=CureAppItemQty
						OrderPackQty=""
					}
				}
			}
			OrderQtySum=OrderPackQty
			var OrderFreqTimeDoseStr="";
			var ChronicDiagCode=data.ChronicDiagCode;
			OrderItem = OrderARCIMRowid + "^" + OrderType + "^" + OrderPriorRowid + "^" + OrderStartDate + "^" + OrderStartTime + "^" + OrderPackQty + "^" + OrderPrice;
	        OrderItem = OrderItem + "^" + OrderRecDepRowid + "^" + BillTypeRowid + "^" + OrderDrugFormRowid + "^" + OrderDepProcNotes;
	        OrderItem = OrderItem + "^" + OrderDoseQty + "^" + OrderDoseUOMRowid + "^" + OrderQtySum + "^" + OrderFreqRowid + "^" + OrderDurRowid + "^" + OrderInstrRowid;
	        OrderItem = OrderItem + "^" + PHPrescType + "^" + OrderMasterSeqNo + "^" + OrderSeqNo + "^" + OrderSkinTest + "^" + OrderPhSpecInstr + "^" + OrderCoverMainIns;
	        var OrderItemAry=OrderItem.split("^");
	        OrderItemAry[25]=OrderEndDate;
	        OrderItemAry[26]=OrderEndTime;
	        OrderItemAry[32]=OrderFirstDayTimes;
	        OrderItemAry[45]=OrderDate;
	        OrderItemAry[46]=OrderTime;
	        OrderItemAry[54]=OrderPackUOMRowid;
	        OrderItemAry[55]=ServerObj.PPRowId;
	        OrderItemAry[57]="CA";
	        OrderItemAry[59]=DCARowID;
	        OrderItemAry[66]=OrderFreqWeekStr;
	        OrderItemAry[68]=OrderPracticePre;
	        OrderItemAry[69]=OrderFreqTimeDoseStr;
	        OrderItemAry[81]=ChronicDiagCode;
	        OrderItemAry[82]=OrderFreqFreeTimeStr;
	        OrderItem = OrderItemAry.join("^");
	        if (OrderItemStr == "") { OrderItemStr = OrderItem } else { OrderItemStr = OrderItemStr + String.fromCharCode(1) + OrderItem }
		}
	}
	return {
		count:numval,
		DCARowIDStr:DCARowIDStr,
		OrderItemStr:OrderItemStr	
	}
}

function CalOrderFreqExpInfo(OrderFreqDispTimeStr)
{
	var OrderFreqWeekStr="",OrderFreqFreeTimeStr="";
	if (OrderFreqDispTimeStr==""){
		return OrderFreqWeekStr+"^"+OrderFreqFreeTimeStr;
	}
	var ArrData = OrderFreqDispTimeStr.split(String.fromCharCode(1));
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(2));
        var DispTime = ArrData1[0];
        var DispWeek = ArrData1[1];
        var PHCDTRowID = ArrData1[2];
        if (DispWeek!=""){
	        //周频次
	        if (OrderFreqWeekStr.indexOf(DispWeek)>=0){
		    	continue;
		    }
	        if (OrderFreqWeekStr==""){
		    	OrderFreqWeekStr=DispWeek; 
		    }else{
				OrderFreqWeekStr=OrderFreqWeekStr+"|"+DispWeek; 
			}
        }else if ((DispTime!="")&&(PHCDTRowID!="")){
	    	//不规则分发时间频次
	    	if (OrderFreqFreeTimeStr.indexOf(DispTime)>=0){
		    	continue;
		    }
			if (OrderFreqFreeTimeStr==""){
		    	OrderFreqFreeTimeStr=DispTime; 
		    }else{
				OrderFreqFreeTimeStr=OrderFreqFreeTimeStr+"|"+DispTime; 
			}
	    }
    }
    return OrderFreqWeekStr+"^"+OrderFreqFreeTimeStr;
}

function GetOrderQtyInfo(OrderType,OrderDoseQty,OrderFreqInfo,OrderDurFactor,OrderStartDateStr,OrderFirstDayTimes,OrderPackQty,OrderARCIMRowid){
	var OrderFreqFactor=mPiece(OrderFreqInfo, "^", 0);
	if (OrderFreqFactor == "") OrderFreqFactor = 1;
	var OrderFreqInterval=mPiece(OrderFreqInfo, "^", 1);
	var OrderFreqDispTimeStr=mPiece(OrderFreqInfo, "^", 2);
	var OrderQtySum = "";
	var InciInfo=$.cm({
		ClassName:"DHCDoc.DHCDocCure.ApplyTree",
		MethodName:"GetInciRowid",
		'ARCIMRowid':OrderARCIMRowid,
		dataType:"text",
	},false);
	OrderType=InciInfo.split("^")[0];
	var InciRowid=InciInfo.split("^")[1];
	if (OrderType == "R") {
		OrderDoseQty=OrderDoseQty.toString();
		var MulOrderDoseQty=0;
		if (OrderDoseQty.indexOf("-")>=0) {
			MulOrderDoseQty=1;
			var OneDayDoseQtySum=0;
			var OrdDoseQtyArry = new Array();
			for (var OrdDoseQtyIndex=0;OrdDoseQtyIndex<OrderDoseQty.split("-").length;OrdDoseQtyIndex++){
				var oneOrdDoseQty=OrderDoseQty.split("-")[OrdDoseQtyIndex];
				OrdDoseQtyArry[OrdDoseQtyIndex]=oneOrdDoseQty;
				OneDayDoseQtySum=parseFloat(OneDayDoseQtySum)+parseFloat(oneOrdDoseQty);
			}
			var FirstDayDoseQtySum=0;
			if (+OrderFirstDayTimes>0) {
				for (var FirstDayIndex=0;FirstDayIndex<OrderFirstDayTimes;FirstDayIndex++){
					var tmpindex=OrdDoseQtyArry.length-OrderFirstDayTimes+FirstDayIndex;
					FirstDayDoseQtySum=parseFloat(FirstDayDoseQtySum)+parseFloat(OrdDoseQtyArry[tmpindex]);
				}
			}else{
				FirstDayDoseQtySum=OneDayDoseQtySum;
			}
		}
		if (OrderFreqDispTimeStr!=""){
			var NumTimes = cspRunServerMethod(ServerObj.GetCountByFreqDispTimeMethod, OrderFreqDispTimeStr, OrderStartDateStr, OrderDurFactor,OrderFirstDayTimes);
			OrderQtySum = parseFloat(OrderDoseQty) * parseFloat(NumTimes);
		}else{
			if ((OrderFreqInterval != "") && (OrderFreqInterval != null)) {
				var convert = Number(OrderDurFactor) / Number(OrderFreqInterval)
				var fact = (Number(OrderDurFactor)) % (Number(OrderFreqInterval));
				if (fact > 0) {
					fact = 1;
				} else {
					fact = 0;
				}
				OrderDurFactor = Math.floor(convert) + fact;
				//周频次OrderFreqFactor应该都是1
				//OrderFreqFactor=1;
			}
			if (MulOrderDoseQty==1) {
				OrderQtySum=parseFloat(FirstDayDoseQtySum)+(parseFloat(OneDayDoseQtySum)*(parseFloat(OrderDurFactor)-1))
			}else{
				if((OrderFirstDayTimes>0)&&(GlobalObj.PAAdmType != "I")){
					NumTimes=parseFloat(OrderFreqFactor) * (parseFloat(OrderDurFactor)-1)+parseFloat(OrderFirstDayTimes);
				}else{
					NumTimes=parseFloat(OrderFreqFactor) * parseFloat(OrderDurFactor);
				}
				OrderQtySum = parseFloat(OrderDoseQty) * NumTimes;
			}
		}
		OrderQtySum = OrderQtySum.toFixed(4);
	} else {
		if ((OrderType == "L") && (OrderPackQty == "")) { OrderPackQty = 1 }
		OrderQtySum = OrderPackQty;
		if(OrderQtySum=="") OrderQtySum=OrderDoseQty;
		if ((InciRowid=="")||(ServerObj.PAAdmType == "I"))OrderPackQty = "";
	}
	return OrderQtySum+"^"+OrderPackQty;
}

function LoadCureEntryItemListDataFromEntry(){
	if(ServerObj.ARCIMStr!=""){
		var ARCIMArr=ServerObj.ARCIMStr.split("@");
		for(var i=0;i<ARCIMArr.length;i++){
			//var oneARCIMJsonObj=eval("("+ARCIMArr[i]+")");
			var oneARCIMJsonObj=JSON.parse(ARCIMArr[i]);
			var CureItemHiddenPara="";
			if(typeof oneARCIMJsonObj.CureItemHiddenPara != "undefined"){
				CureItemHiddenPara=JSON.stringify(oneARCIMJsonObj.CureItemHiddenPara);
			}
			
			var CureItemFreqDispTimeStr=oneARCIMJsonObj.CureItemFreqDispTimeStr;
			CureItemFreqDispTimeStr=CureItemFreqDispTimeStr.replace(/\^/g,String.fromCharCode(1));
			CureItemFreqDispTimeStr=CureItemFreqDispTimeStr.replace(/#/g,String.fromCharCode(2));
			var ItemObj={
				CureItemRowid:oneARCIMJsonObj.CureItemRowid,
				CureItemArcDesc:oneARCIMJsonObj.CureItemArcDesc,		
				OrderPHPrescType:oneARCIMJsonObj.OrderPHPrescType,
				CureItemConFac:oneARCIMJsonObj.CureItemConFac,
				OrderType:oneARCIMJsonObj.OrderType,
				OrderDoseStr:oneARCIMJsonObj.OrderDoseStr,
				CureItemPrior:oneARCIMJsonObj.CureItemPrior,
				CureItemPriorRowid:oneARCIMJsonObj.CureItemPriorRowid,
				CureItemFreq:oneARCIMJsonObj.CureItemFreq,
				CureItemFreqRowid:oneARCIMJsonObj.CureItemFreqRowid,
				CureItemFreqInterval:oneARCIMJsonObj.CureItemFreqInterval,
				CureItemFreqFactor:oneARCIMJsonObj.CureItemFreqFactor,
				CureItemFreqDispTimeStr:CureItemFreqDispTimeStr,
				CureItemDurRowid:oneARCIMJsonObj.CureItemDurRowid,
				CureItemDur:oneARCIMJsonObj.CureItemDur,
				CureItemDurFactor:oneARCIMJsonObj.CureItemDurFactor,
				CureItemDoseQty:oneARCIMJsonObj.CureItemDoseQty,
				CureItemDoseUOMDesc:oneARCIMJsonObj.CureItemDoseUOMDesc,
				CureItemDoseUOM:oneARCIMJsonObj.CureItemDoseUOM,
				CureItemRecLoc:oneARCIMJsonObj.CureItemRecLoc,
				CureItemRecLocRowid:oneARCIMJsonObj.CureItemRecLocRowid,
				CureItemPackQty:oneARCIMJsonObj.CureItemPackQty,
				CureItemPackUOMDesc:oneARCIMJsonObj.CureItemPackUOMDesc,
				CureItemPackUOM:oneARCIMJsonObj.CureItemPackUOM,
				CureItemBillType:oneARCIMJsonObj.CureItemBillType,
				CureItemPrice:oneARCIMJsonObj.CureItemPrice,
				CureItemStartDate:oneARCIMJsonObj.CureItemStartDate,
				CureItemEndDate:oneARCIMJsonObj.CureItemEndDate,
				CureItemBillTypeRowId:oneARCIMJsonObj.CureItemBillTypeRowId,
				CureItemFirstDayTimes:oneARCIMJsonObj.CureItemFirstDayTimes,
				CureItemApplyPlan:oneARCIMJsonObj.CureItemApplyPlan,
				CureItemApplyRemark:oneARCIMJsonObj.CureItemApplyRemark,
				CureItemCoverMainIns:oneARCIMJsonObj.CureItemCoverMainIns,
				CureItemSeqNo:oneARCIMJsonObj.CureItemSeqNo,
				DDCISRowid:oneARCIMJsonObj.DDCISRowid,
				CureOrderUserAdd:session['LOGON.USERNAME'],
				CureItemMasterSeqNo:oneARCIMJsonObj.CureItemMasterSeqNo,
				ChronicDiagCode:oneARCIMJsonObj.CureItemChronicDiagCode,
				ChronicDiagDesc:oneARCIMJsonObj.CureItemOrderChronicDiagDesc,
				CureItemOrderDate:oneARCIMJsonObj.CureItemOrderDate,
				CureItemApplyRemark:oneARCIMJsonObj.CureItemApplyRemark,
				CureItemHiddenPara:CureItemHiddenPara
			}
			PageApplyTreeObj.CureEntryItemListDataObj.Length=PageApplyTreeObj.CureEntryItemListDataObj.Length+1;
			PageApplyTreeObj.CureEntryItemListDataObj.CureItem.push(ItemObj)
		}
		LoadCureEntryItemListData(PageApplyTreeObj.CureEntryItemListDataObj);
		
	}
}

function DisableAllElement(){
	var StyleConfigObj = {
		OrderPrior:false,
		OrderReLoc:false,
		OrderBillType:false,
		OrderStartDate:false,
		OrderEndDate:false,
        OrderDur: false,
        OrderFreq: false,
        OrderQty: false,
        BillingUOM: false,
        OrderDoseQty: false,
        OrderDoseUOM: false,
        OrderFirstDayTimes: false,
        CureItemCoverMainIns: false,
        FindLocByLog: false
    }
	ChangeElementStyle(StyleConfigObj);	
}
///实习生审核医嘱
function InsertPriceAdd() {
	var DataArry=PageApplyTreeObj.CureEntryItemListDataObj;
	var InsertType="Cure";
	if(ServerObj.ParaType=="CureAdvise"){
		InsertType=ServerObj.ParaType;
	}
	for (var i = 0; i < DataArry.Length; i++) {
		var data=DataArry.CureItem[i];
		data.CureOrderUserAdd=session['LOGON.USERNAME'];
		data.CureOrderUserAddDr=session['LOGON.USERID'];
		data.CureAssScoreID=ServerObj.CureAssScoreID;
		var CureItemSelAppendItemObj=data.CureItemSelAppendItemObj;
		if (CureItemSelAppendItemObj) {
			for (var k=0;k<CureItemSelAppendItemObj.AppendItem.length;k++) {
				var RecLocStr=CureItemSelAppendItemObj.AppendItem[k].RecLocStr;
				if (RecLocStr!="") {
					//原科室串存在^会导致后台存储错乱
					RecLocStr=RecLocStr.replace(/\^/g,String.fromCharCode(1)).replace(/\!/g,String.fromCharCode(2)); 
					CureItemSelAppendItemObj.AppendItem[k].RecLocStr=RecLocStr;
				}
			}
		}
		
		var RowDataJson=JSON.stringify(data);
		var rtn = $.cm({
			ClassName:"web.DHCPracticeDocPreOrder",
			MethodName:"InsertPracticeOrder",
			Adm:ServerObj.EpisodeID,
			JsonStr:RowDataJson,
			PreUserID:session["LOGON.USERID"],
			InsertType:InsertType,
			dataType:"text",
			_headers:{'X-Accept-Tag':1}
		},false)
	}
	return true;
}
//展示实习生页面
function ShowPracticeOrder() {
	if(ServerObj.ParaType=="CureAdvise"){
		var mTitle="建议医嘱处理";
		var PageType=ServerObj.ParaType;
	}else{
		var mTitle="实习生/建议医嘱处理";
	    if(ServerObj.PAAdmType != "I"){
		    mTitle="建议医嘱处理";
		}
		var PageType="Cure^CureAdvise";
	}
    if(ServerObj.EpisodeID){
        websys_showModal({
			url:"ipdoc.practicedocpreorder.hui.csp?EpisodeID=" + ServerObj.EpisodeID +"&PageType="+PageType+"&CureAssScoreID="+ServerObj.CureAssScoreID,
			title:$g(mTitle),
			iconCls:"icon-w-list",
			//width:screen.availWidth-200,height:screen.availHeight-200,
            width:"95%",height:screen.availHeight-200,
			AddPracticeOrder:AddPracticeOrder,
			GetPreRowId:GetPreRowId,
			CheckIsClear:CheckIsClear
		});
    }
}
function AddPracticeOrder(PracticePreary,RowidStr){
	for (var i=0;i<PracticePreary.length;i++){
		ItemObj=PracticePreary[i];
		var ErrObject=GetPatNotTakOrdMsgArc(ItemObj.CureItemRowid);
		if (ErrObject.ErrMsg != ""){
			$.messager.alert("提示",ErrObject.ErrMsg);
			return false;
		}
		ItemObj.OrderPracticePre=RowidStr.split("^")[i];
		PageApplyTreeObj.CureEntryItemListDataObj.Length=PageApplyTreeObj.CureEntryItemListDataObj.Length+1;
		PageApplyTreeObj.CureEntryItemListDataObj.CureItem.push(ItemObj)
	}
	LoadCureEntryItemListData(PageApplyTreeObj.CureEntryItemListDataObj);
	
}
function GetPreRowId(){
	return "1"
}
function CheckIsClear(){
	return false;
}

//判断日期是否有修改权限
//1 科室设置不允许修改日期时间,医嘱项扩展设定允许跨日，需判断
//2 科室扩展允许修改，医嘱项允许修改 需判断
//3 科室设置允许修改，医嘱项扩展不允许，不需要判断
//4 科室设置不允许修改，医嘱项扩展不允许，不需要判断
//5 医嘱项扩展设定未维护，走科室权限
// true 需要判断 不需要判断
function CheckDateTimeModifyFlag(ModifyDateTimeAuthority,IsCanCrossDay){
	if (IsCanCrossDay=="N") {
		return false;
	}else if (IsCanCrossDay=="Y") {
		return true;
	}else{
		//未进行医嘱项扩展设定,走科室权限
		if (ModifyDateTimeAuthority!="1") return false;
	}
	return true;
}
function InitChronicDiagLookUp(){
	if ($("#ChronicDiag").length==0){return}
	$("#ChronicDiag").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Code',
        textField:'Desc',
        columns:[[  
       		{field:'Desc',title:'描述',width:130,sortable:true}
        	,{field:'Code',title:'编码',hidden:true}
        	,{field:'Type',title:'类型',width:80,sortable:true}
        ]],
        //width:120,
        pagination:true,
        panelWidth:300,
        panelHeight:300,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocQryOEOrder',QueryName: 'LookUpChronicDiag'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{desc:desc,EpisodeID:ServerObj.EpisodeID});
	    }
	});
	$("#ChronicDiag").keyup(function(){
		if ($(this).val()==""){
			$(this).lookup("setValue","").lookup("setText","");
		}
	});
}
function GetChronicDiagCode(){
	var CureItemBillTypeRowId = $("#OrderBillType").combobox('getValue');
	if (ServerObj.InsurBillStr.indexOf("^"+CureItemBillTypeRowId+"^")==-1){
    	return "";
    }
	var ChronicDiagCode="";
	if ($("#ChronicDiag").length>0){
		if ($("#ChronicDiag").lookup("getText")!=""){
			ChronicDiagCode=$("#ChronicDiag").lookup("getValue")
		}
	}
	if (typeof ChronicDiagCode=="undefined"){
		ChronicDiagCode="";
	}
	return ChronicDiagCode;
}
//验证医嘱与慢特病是否匹配
function ChkChronicOrdItm(CureItemObj){
	//var CureItemObj=GetOneCureItemObj();
	if((CureItemObj.CureItemRowid=="")||(CureItemObj.CureItemRowid==undefined)){
		return "";	
	}		
	var ChronicDiagCode=GetChronicDiagCode();
	if (ChronicDiagCode!="") {
		var sendArcimStr="";
		var CureItemRowid=CureItemObj.CureItemRowid;
		if (sendArcimStr=="") sendArcimStr=CureItemRowid;
		else  sendArcimStr=sendArcimStr+"^"+CureItemRowid;
		var CureItemSelAppendItemObj=CureItemObj.CureItemSelAppendItemObj;
		for (var index=0;index<CureItemSelAppendItemObj.AppendItem.length;index++){
			var CureAppItemID=CureItemSelAppendItemObj.AppendItem[index].CureAppItemID;
			sendArcimStr=sendArcimStr+"^"+CureAppItemID;
		}
		if (sendArcimStr=="") return "";
		var NotMatchMsg=$.cm({
			ClassName:"web.DHCAPPExaReport",
			MethodName:"ISChronicOrdItm",
			dataType:"text",
			AdmDr:ServerObj.EpisodeID,
			ChronicCode:ChronicDiagCode,
			sendArcimStr:sendArcimStr
		},false);
		return NotMatchMsg;
	}
	return "";
}


function InitCureApplyList(){
	if($('#CureApplyList').length==0){
		return
	}
	var mytoolbar = [
		{
	        text: '申请单打印',
	        iconCls: 'icon-print',
	        handler: function() {
		        var row=PageApplyTreeObj.CureApplyListDataGrid.datagrid("getSelected");
		        if(row){
			        var OrderStatusCode=row.OrderStatusCode;
			        if(OrderStatusCode!="V" && OrderStatusCode!="E"){
						$.messager.alert("提示",$g("非核实医嘱无法打印"),"warning");
						return false;
					}
			        var DCARowId=row.DCARowId;
			        var PrintData=$.cm({
						ClassName:"DHCDoc.DHCDocCure.Apply",
						MethodName:"GetCureApply",
						dataType:"text",
						'DCARowId':DCARowId
					},false); 
					if(PrintData==""){
						$.messager.alert("警告","未获取到需要打印的数据,申请单ID:"+DCARowId,"warning");
						return false;
					}
					app_applyPrint.XML_PrintCureApply(DCARowId,PrintData);	
		        }else{
			        $.messager.alert("警告","请选择一行需要打印的申请单记录","warning")
			    }
	        }
	    },{
	        text: '刷新',
	        iconCls: 'icon-reload',
	        handler: function() {
		        CureApplyListDataGridLoad();
	        }
	    },{
	        text: '部位图',
	        iconCls: 'icon-person',
	        handler: function() {
		        var row=PageApplyTreeObj.CureApplyListDataGrid.datagrid("getSelected");
		        if(row){
			        com_openwin.ShowPatBody(row.DCARowId);	
		        }else{
			        $.messager.alert("警告","请选择一条申请单记录","warning")
			    }
	        }
	    }
	]
	var CureApplyListDataGrid=$('#CureApplyList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		checkOnSelect:true,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=FindEMRCureApplyList&EpisodeID="+ServerObj.EpisodeID+"&rows=9999",
		loadMsg : '加载中..', 
		showPageList:false,  
		pagination : true,
		rownumbers : true,
		idField:"DCARowId",
		pageSize : 20,
		pageList : [10,20,50],
		toolbar : mytoolbar,
		columns :[[ 
			{field:'ApplyNo',title:'申请单号',width:110,align:'left', resizable: true},  
			{field:'ArcimDesc',title:'治疗项目',width:200,align:'left', resizable: true},
			{field:'OrdOtherInfo',title:'医嘱其他信息',width:120,align:'left', resizable: true},
			{field:'OrdQty',title:'数量',width:50,align:'left', resizable: true}, 
			{field:'OrdBillUOM',title:'单位',width:50,align:'left', resizable: true}, 
			{field:'OrdUnitPrice',title:'单价',width:50,align:'left', resizable: true}, 
			{field:'OrdPrice',title:'总金额',width:60,align:'left', resizable: true}, 
			{field:'ApplyAppedTimes',title:'已预约次数',width:80,align:'left', resizable: true},
			{field:'ApplyNoAppTimes',title:'未预约次数',width:80,align:'left', resizable: true},
			{field:'ApplyFinishTimes',title:'已治疗次数',width:80,align:'left', resizable: true},
			{field:'ApplyNoFinishTimes',title:'未治疗次数',width:80,align:'left', resizable: true},
			{field:'OrdBilled',title:'是否缴费',width:70,align:'left', resizable: true,
				formatter:function(value,row,index){
					if (value == "否"){
						return "<span class='fillspan-nobilled'>"+value+"</span>";
					}else{
						return "<span class='fillspan'>"+value+"</span>";
					}
				}
			},
			{field:'OrdReLoc',title:'接收科室',width:80,align:'left', resizable: true},   
			{field:'ApplyStatus',title:'申请状态',width:80,align:'left', resizable: true},
			{field:'ApplyUser',title:'申请医生',width:80,align:'left', resizable: true},
			{field:'ApplyDateTime',title:'申请时间',width:80,align:'left', resizable: true},
			{field:'OrderStatusCode',title:'OrderStatusCode',width:30,hidden:true},
			{field:'DCARowId',title:'DCARowId',width:30,hidden:true} 
		]]
	});
	return CureApplyListDataGrid;
}

function CureApplyListDataGridLoad(){
	if($('#CureApplyList').length==0){
		return
	}
	PageApplyTreeObj.CureApplyListDataGrid.datagrid("reload");
}

function IsLongPrior(OrderPriorRowId) {
    var ret = 0;
    if ((OrderPriorRowId == ServerObj.LongOrderPriorRowid) || (OrderPriorRowId == ServerObj.OMSOrderPriorRowid) || (OrderPriorRowId == ServerObj.OMCQZTOrderPriorRowid)) {
        ret = 1
    }
    return ret;
}

function CheckPOA(CureItemObj,callBackFun){
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID'];
	var CureItemPOAInfo=CureItemObj.CureItemPOAInfo;
	if(CureItemPOAInfo!=""){
		Open();
	}else{
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.BodySet",
			MethodName:"GetPOASetCount",
			DDCISRowid:CureItemObj.DDCISRowid,
			SessionStr:SessionStr,
			dataType:"text"
		},function(count){
			if(count>0){
				Open();
			}else{
				callBackFun(CureItemObj);	
			}
		})
	}
	function Open(){
		$.messager.confirm("提示", "存在附加部位信息,是否选择?",
			function(r){
				if(r){
					websys_showModal({
						url:"doccure.apply.part.hui.csp?DDCISRowid=" + CureItemObj.DDCISRowid+"&ItemPOAInfo=" + encodeURIComponent(CureItemObj.CureItemPOAInfo),
						title:$g("附加部位/穴位信息"),
						iconCls:"icon-w-plus",
						width:'85%',height:'90%',
						AddPOAInfo:function(rtn){
							if(rtn.length>0){
								CureItemObj.CureItemPOAInfo=rtn;
								//callBackFun(CureItemObj);
							}else{
								//callBackFun(CureItemObj);
							}	
						},
						onClose:function(){
							callBackFun(CureItemObj);
						}
					});
				}else{
					callBackFun(CureItemObj);
				}
			}
		)
	}
}

function InitApplyRemark(DDCISRowid){
	$HUI.combobox("#CureItemNote",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		//panelHeight:"auto",
		editable:false,
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=CureItemPlan&Inpute1="+DDCISRowid+"&Inpute2=N&Inpute3=&ResultSetType=array",
    	onLoadSuccess:function(data){
	    	$HUI.combobox(this).setValue("");
	    },onSelect:function(record){
		    var Remark=$("#ApplyRemark").val();
            var CombNote=record['CombNote'];
			if(CombNote!=""){
				if(Remark!=""){Remark=Remark+";"+CombNote;}
				else{Remark=CombNote;}
				$("#ApplyRemark").val(Remark);
			}
		},onAllSelectClick:function(e){
			var Remark=$("#ApplyRemark").val();
			var CombNote="";
			var arr = $(this).combobox("getValues");
			if(arr.length>0){
				var Data = $(this).combobox("getData");
				for(var i=0;i<Data.length;i++){
					var id=Data[i].CombValue; 
		    		var myNote=Data[i].CombNote; 
		    		if((myNote=="") || ($.hisui.indexOfArray(arr,id)<0)){continue}
		    		if(CombNote=="")CombNote= myNote;
		    		else CombNote=CombNote+";"+myNote;
				}
			}
			if(CombNote!=""){
				if(Remark!=""){Remark=Remark+";"+CombNote;}
				else{Remark=CombNote;}
				$("#ApplyRemark").val(Remark);
			}
		}
	})
}

function InitCureItemTemp(DDCISRowid){
	CureItemPlanCombCreat(DDCISRowid);
	InitApplyRemark(DDCISRowid);
}

function SetOrderHiddenPara(SetObj){
	var HiddenParaObj={};
	var OrderHiddenPara=$('#CureItemHiddenPara').val();	
	if(OrderHiddenPara!=""){
		HiddenParaObj=JSON.parse(OrderHiddenPara);
	}
	if(typeof(SetObj)=="object"){
		$.extend(HiddenParaObj,SetObj);
	}else{
		var FindRecLocByLog=$("#FindLocByLog").checkbox('getValue')?1:0;
		var OrderOpenForAllHosp=0;
		if($("#OrderOpenForAllHosp").length>0){
			OrderOpenForAllHosp=$("#OrderOpenForAllHosp").checkbox("getValue")?1:0;
		}
		$.extend(HiddenParaObj,{
			FindRecLocByLog:FindRecLocByLog,
			OpenForAllHosp:OrderOpenForAllHosp
		});
	}
	var OrderHiddenPara=JSON.stringify(HiddenParaObj);
	$('#CureItemHiddenPara').val(OrderHiddenPara);	
}
function GetHiddenParaObj(CureItemHiddenPara){
	var HiddenParaObj={
		FindRecLocByLog:"",
		OpenForAllHosp:"",
		OrderReLocData:""
	};
	if(CureItemHiddenPara!=""){
		$.extend(HiddenParaObj,JSON.parse(CureItemHiddenPara));
	}
	return HiddenParaObj;
}

window.onbeforeunload = DocumentUnloadHandler;
function DocumentUnloadHandler(){
	$.cm({
		ClassName:'web.DHCDocOrderCommon',
		MethodName:'OrderEntryClearLock',
		SessionStr:GetSessionStr(),
		type:'BEACON'
	});
}

//考虑到目前该界面的应用场景，并未实现切换患者的功能
function xhrRefresh(refreshArgs){
	return
	//双屏应用
	if (PageApplyTreeObj.MainSreenFlag==0){
	    var Obj={DCARowId:DCARowId,EpisodeID:ServerObj.EpisodeID,mradm:ServerObj.mradm};
		websys_emit("onOpenCureAppInfo",Obj);
	}
}
function showPatientList()
{
	var src="opdoc.patient.list.csp?NotShowBtnBar=Y";
	if(ServerObj.PAAdmType=='I'){
		src="inpatientlist.csp";
	}else if(ServerObj.PAAdmType=='E'){
		src="dhcem.patlist.csp";
	}
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='99%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	com_Util.createModalDialog("BookCreat","患者切换", 1300, 600,"icon-change-loc","",$code,"");
}
function switchPatient(PatientID,EpisodeID,mradm)
{
	com_Util.destroyDialog("BookCreat");
	var url="doccure.applytree.hui.csp?EpisodeID="+EpisodeID;
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	window.location.replace(url);
}

function UpdateClickHandlerFinish() {
	tkMakeServerCall("web.DHCDocOrderCommon","OrderEntryClearLock",GetSessionStr(),"User.OEOrder");
}