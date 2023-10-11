var PageApplyUpdateObj={
	PrintData:"",
	UserID:session['LOGON.USERID'],
	GroupID:session['LOGON.GROUPID'],
	CTLocID:session['LOGON.CTLOCID'],
	HospID:session['LOGON.HOSPID'],
	CureAppendItemListDataGrid:""
}
$(window).load(function(){
	InitInfo();
})
$(document).ready(function(){
	Init();
	InitEvent();
	PageHandle();
});

function Init(){
	InitItem();
	PageApplyUpdateObj.CureAppendItemListDataGrid=InitCureAppendItemList();
}

function InitEvent(){
	$('#btnSave').click(SaveCureApply);
	$('#btnPrint').click(function(){
		app_applyPrint.XML_PrintCureApply(ServerObj.DCARowId,PageApplyUpdateObj.PrintData);	
	}); 
	if(ServerObj.DCARowId!=""){
		$('#btnCancel').bind("click",function(){
			CancelApply(ServerObj.DCARowId);	
		}); 
	}
	
	$('#btnPatBody').click(function(){
		com_openwin.ShowPatBody(ServerObj.DCARowId,"Y")
	})
	document.onkeydown = Page_OnKeyDown;
}
function PageHandle(){
	var ItemWidth=0; //计算textarea的宽度=首日次数(元素td).innerWidth()+费用(label td).innerWidth()+费用(元素td).width()
	var jObj=$(".td-toCalWidth");
	for(var i=0;i<jObj.length;i++){
		ItemWidth+=$(jObj[i]).innerWidth();
	}
	ItemWidth=ItemWidth+$("#OrderPrice").width();
	$(".form-table textarea").width(ItemWidth+4);
	$("#ChronicDiag,#label_ChronicDiag").hide();
}

function InitInfo(){
	PageApplyUpdateObj.PrintData="";
	//加载患者信息条
	if(typeof InitPatInfoBanner){
		InitPatInfoBanner(ServerObj.EpisodeID); 
	}
	var DCARowId=ServerObj.DCARowId;
	if(DCARowId!=""){
		var CureInfo=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"GetCureApply",
			dataType:"text",
			'DCARowId':DCARowId,
		},false);
		if(CureInfo != ""){
			PageApplyUpdateObj.PrintData=CureInfo;
			var CureApplyArr="",CureApplyArr="";
			var TempArr=CureInfo.split(String.fromCharCode(1));
			DisableAllElement();
			DisplayCureInfo(TempArr[1],TempArr[2]);
			LoadCureAppendItemListData(DCARowId);
		}
	}	
}

function CancelApply(DCARowId){
	if(DCARowId!=""){
		$.messager.confirm('撤销',"确认要撤销该申请单吗",function(r){
			if (r){
				$.m({
					ClassName:"DHCDoc.DHCDocCure.Apply",
					MethodName:"CancelAppBroker",
					'DCARowId':DCARowId,
					'UserID':session['LOGON.USERID']
				},function testget(value){
					var Code=value.split("^")[0];
					var ErrMsg=value.split("^")[1];
					if(Code == "0"){
						$.messager.popover({msg: '撤销成功！',type:'success',timeout: 2000});
						//window.returnValue = true;
						websys_showModal('hide');
						if(websys_showModal('options') && websys_showModal('options').callbackFun){
							websys_showModal('options').callbackFun();
						}
						websys_showModal("close");
					}else{
						$.messager.alert("提示","撤销失败,"+ErrMsg,"warning");
						return false;
					}				
				});
			}
		})
	}else{
		$.messager.alert("提示","申请单信息获取错误","warning");
		return false;
	}
			
}

function DisplayCureInfo(val,oval){
	var CureApplyArr=val.split("^");
	var CureApplyOtherArr=oval.split("^")
	var ArcimDesc="",OrderQty="",BillingUOM="",OrderReLoc="",ApplyStatus="",ApplyUser="",ApplyDate="";
	var ApplyDate="",ApplyRemarks="",ApplyPlan="";
	var ApplyNo="";
	if(CureApplyArr!=""){
		var ArcimDesc=CureApplyArr[0];
		var OrderQty=CureApplyArr[2];
		var BillingUOM=CureApplyArr[3];
		var OrderReLoc=CureApplyArr[4];
		var ApplyStatus=CureApplyArr[6];
		var ApplyUser=CureApplyArr[7];
		var ApplyDate=CureApplyArr[8];
		var ApplyRemarks=CureApplyArr[13];
		var ApplyPlan=CureApplyArr[14];	
		var OrderBillType=CureApplyArr[26];	
		var OrderPrice=CureApplyArr[16];	
		var DDCISRowid=CureApplyArr[28];	
		var ItemCatDesc=CureApplyArr[29];		
		var ApplyNo=CureApplyArr[30];		
		$("#OrderArcimDesc").val(ArcimDesc);
		$("#OrderQty").val(OrderQty);
		$("#ApplyStatus").val(ApplyStatus);
		$("#ApplyUser").val(ApplyUser);
		$("#ApplyDate").val(ApplyDate);
		$("#ApplyRemark").val(ApplyRemarks);
		$("#ApplyPlan").val(ApplyPlan);
		$("#OrderPrice").val(OrderPrice);
		$("#CureApplyNo").val(ApplyNo);
		$HUI.combobox("#OrderBillType").setValue(OrderBillType);
		$HUI.combobox("#BillingUOM").setValue(BillingUOM);
		$HUI.combobox("#OrderReLoc").setValue(OrderReLoc);
		InitCureItemTemp(DDCISRowid);
	}
	if(CureApplyOtherArr!=""){
		//s ret=OrderDoseQty_"^"_OrderDoseUnitID_"^"_OrderDoseUnit_"^"_PriorityDR_"^"_PriorityDesc
		//s ret=ret_"^"_PHFreqDr_"^"_PHFreqDesc1_"^"_instrDr_"^"_instrDesc1
		var OrderDoseQty=CureApplyOtherArr[0];
		var OrderDoseUnitID=CureApplyOtherArr[1];
		var OrderDoseUnit=CureApplyOtherArr[2];
		var PriorityDR=CureApplyOtherArr[3];
		var PriorityDesc=CureApplyOtherArr[4];
		var PHFreqDr=CureApplyOtherArr[5];
		var PHFreqDesc1=CureApplyOtherArr[6];
		var instrDr=CureApplyOtherArr[7];
		var instrDesc1=CureApplyOtherArr[8];
		var DuratDR=CureApplyOtherArr[9];
		var DuratDesc=CureApplyOtherArr[10];
		var StDate=CureApplyOtherArr[11];
		var FirstDayTimes=CureApplyOtherArr[12];
		var EndDate=CureApplyOtherArr[13];
		var CoverMainInsFlag=CureApplyOtherArr[15];
		$("#OrderDoseQty").val(OrderDoseQty);
		$("#OrderStartDate").datetimebox("setValue",StDate);
		$("#OrderEndDate").datetimebox("setValue",EndDate);
		$("#OrderFirstDayTimes").val(FirstDayTimes);
		$HUI.combobox("#OrderPrior").setValue(PriorityDesc);
		$HUI.combobox("#OrderDoseUOM").setValue(OrderDoseUnit);
		$("#OrderFreq").lookup("setText",PHFreqDesc1);
		$("#OrderDur").lookup("setText",DuratDesc);
		$HUI.checkbox("#CureItemCoverMainIns").setValue(false);
		if(CoverMainInsFlag=="Y"){
			$HUI.checkbox("#CureItemCoverMainIns").setValue(true);
		}
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
        CureItemCoverMainIns: false
    }
	ChangeElementStyle(StyleConfigObj);	
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
		if(className.indexOf("hisui-lookup")>=0){
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
function SaveCureApply()
{
    var DCARowId=ServerObj.DCARowId;
	var EpisodeID=ServerObj.EpisodeID;
	var ApplyPlan=$("#ApplyPlan").val();
	if (ApplyPlan==""){
		//$.messager.alert("提示","治疗方案不能为空");
		//return;
	}
	var ApplyRemark=$("#ApplyRemark").val();
	if((DCARowId!="")&&(DCARowId!=undefined)){
		$.m({
			ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"SaveCureApply",
			'DCARowId':DCARowId,
			'ApplyPlan':ApplyPlan,
			'ApplyRemark':ApplyRemark,
			'UserID':session['LOGON.USERID'],
		},function testget(value){
			if(value==0){
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				InitInfo();
			}else{
				$.messager.alert('提示','保存失败,错误代码:'+value);
			}	
		})
	}else{
		$.messager.alert('提示','获取治疗申请ID失败',"info");
	}
}

function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="ArcimDesc"){
			var CombValue=Data[i].ArcimRowID;
		 	var CombDesc=Data[i].ArcimDesc;
	     }else{
		    var CombValue=Data[i].CombValue  
		 	var CombDesc=Data[i].CombDesc
		 }
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}

function InitItem(){
	$("#OrderFreq").lookup({});
	$("#OrderDur").lookup({});
	ItemBillUOMCombCreat("") //整包装单位		
	DHCDocOrderRecLocCombCreat("","",0);
	DHCDocOrderBillTypeCombCreat();
	InitCureItemTemp("");
}

function Clear_Mes(){
	$HUI.combobox("#OrderReLoc").setValue("");
	$HUI.combobox("#BillingUOM").setValue("");
	$HUI.combobox("#CureItemPlan").setValue("");
	$('#ItemRowid').val("");
	$HUI.numberbox("#OrderQty").setValue("")
	$HUI.combobox("#BillingUOM").setValue("")
	$HUI.combobox("#OrderReLoc").setValue("")
	//$HUI.combobox("#OrderBillType").setValue("")
	$('#ApplyPlan').val("");
	$('#ApplyRemark').val("");
	$("#OrderQty").attr("disabled",false);
	$('#OrderPrice').val("");
	$('#CureApplyNo').val("");
	$('#ArcimDesc').val("");
}

//接收科室
function DHCDocOrderRecLocCombCreat(ArcimID,DefaultOrdRecLoc,DefaultFlag){
	//ServerObj.EpisodeID
	//session['LOGON.CTLOCID']
	$HUI.combobox("#OrderReLoc",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=DHCDocOrderRecLoc"+"&Inpute1="+ArcimID+"&Inpute2="+DefaultOrdRecLoc+"&Inpute3="+DefaultFlag+"&Inpute4="+ServerObj.EpisodeID+"&Inpute5="+session['LOGON.CTLOCID']+"&ResultSetType=array",
    	onChange:function(){
			//SetPrice();	
		},onLoadSuccess:function(data){
	    	var DefRecLoc="";
	    	for(var i=0;i<data.length;i++){
		    	if(data[i].selected==1){
			    	var DefRecLoc = data[i].CombValue;
			    	break;
			    }
		    }
		    //若接收科室只有一个，则默认选择，否则必须手动选择
		    if((DefRecLoc=="")&&(data.length==1)){
				DefRecLoc=data[0].CombValue;    
			}
	    	if(DefRecLoc!=""){$HUI.combobox("#OrderReLoc").setValue(DefRecLoc);}
	    }
	})
}

//费别
function DHCDocOrderBillTypeCombCreat(){
	$HUI.combobox("#OrderBillType",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=OrderBillType"+"&Inpute1="+ServerObj.EpisodeID+"&Inpute2="+""+"&ResultSetType=array",
    	onLoadSuccess:function(data){
	    	var DefBillType="";
	    	for(var i=0;i<data.length;i++){
		    	if(data[i].selected==1){
			    	var DefBillType = data[i].CombValue;
			    }
		    }
		    if((DefBillType=="")&&(data.length==1)){
				DefBillType=data[0].CombValue;    
			}
	    	if(DefBillType!=""){$HUI.combobox("#OrderBillType").setValue(DefBillType);}
	    },onChange:function(){
			//SetPrice();	
		}
	})
}

function InitCureItemTemp(DDCISRowid){
	CureItemPlanCombCreat(DDCISRowid);
	InitApplyRemark(DDCISRowid);
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
			var CombNote=record['CombNote'];
			if(CombNote!=""){
				$("#ApplyPlan").val(CombNote);
			}
		}
	})
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

//整包装单位
function ItemBillUOMCombCreat(ArcimDr)
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
		onChange:function(){
			//SetPrice();	
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
	    	if(DefBillUOM!=""){$HUI.combobox("#BillingUOM").setValue(DefBillUOM);}
		}
	})
}

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
				{field:'CureAppItemID',title:'',width:35,align:'left',hidden:true},   
				{field:'CureAppItemDesc',title:'绑定医嘱名称',width:150,align:'left'},   
				{field:'CureAppItemQty',title:'绑定数量',width:80,align:'left'},   
				{field:'CureAppItemRecLoc',title:'接收科室',width:100,align:'left'},
				{field:'CureAppItemRecLocID',title:'',width:100,align:'left',hidden:true,editor:{type:'text'}},
				{field:'Price',title:'单价',width:60,align:'left',hidden:true},
				{field:'TotalPrice',title:'价格',width:60,align:'left',editor:{type:'textReadonly'}},
				{field:'RecLocStr',title:'',width:100,align:'left',hidden:true},
				{field:'CureAppItemType',title:'',width:100,align:'left',hidden:true},
				{field:'baseuom',title:'',width:100,align:'left',hidden:true},
				{field:'Baseuomdesc',title:'',width:100,align:'left',hidden:true},
				{field:'CureAppRowId',title:'',width:100,align:'left',hidden:true}
			]]
	});
	return CureAppendItemListDataGrid;
}

function LoadCureAppendItemListData(Rowid){
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		QueryName:"FindCureItemAppendItem",
		DCARowId:Rowid,
		Episodeid:ServerObj.EpisodeID,
		SessionStr:com_Util.GetSessionStr(),
		Pagerows:PageApplyUpdateObj.CureAppendItemListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageApplyUpdateObj.CureAppendItemListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
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

function SetOrderFirstDayTimes(){}