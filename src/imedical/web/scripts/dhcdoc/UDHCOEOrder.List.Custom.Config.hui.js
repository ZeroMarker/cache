$(function(){
	//页面元素初始化
	PageHandle();
	//事件初始化
	InitEvent();
});
function PageHandle(){
	$HUI.combobox("#ViewIPDocPatInfoLayOut", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: eval("("+ServerObj.ViewIPDocPatInfoLayOutJson+")")
	 });
	
	
	$HUI.combobox("#ViewGroupSum_UserID", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: [{"id":1,"text":1},{"id":2,"text":2},{"id":3,"text":3},{"id":4,"text":4}]
	 });
	 /*
	 $HUI.combobox("#ViewOrderType", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: eval("("+ServerObj.ViewOrderTypeJson+")")
	 });
	 */
	 $HUI.combobox("#ViewOrderSort", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: eval("("+ServerObj.ViewOrderSortJson+")")
	 });
	 $HUI.combobox("#ViewLocDesc", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: eval("("+ServerObj.ViewLocDescJson+")")
	 });
	 $HUI.combobox("#ViewScopeDesc", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: eval("("+ServerObj.ViewScopeDescJson+")")
	 });
	 $HUI.combobox("#ViewNurderBill", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: eval("("+ServerObj.ViewNurderBillJson+")")
	 });
	 
	 if (ServerObj.GroupRowId!=""){
		 var Node="UIConfigObj_Group";
		 var SubNode=ServerObj.GroupRowId;
	 }else{
		 var Node="UIConfigObj";
		 var SubNode=session['LOGON.USERID']+'Z'+session['LOGON.GROUPID'];
	 }
	$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode1",
		Node:Node, SubNode:SubNode,
		dataType:"text"
	},function(UIConfigObj){
		if (UIConfigObj=="") var UIConfigObj="{}"
		var data = eval('(' + UIConfigObj + ')');
		$("#layoutConfig1").radio("setValue",data['layoutConfig1']=='true');
		$("#layoutConfig2").radio("setValue",data['layoutConfig2']=='true');
		$("#OrderPriorConfig1").radio("setValue",data['OrderPriorConfig1']=='true');
		$("#OrderPriorConfig2").radio("setValue",data['OrderPriorConfig2']=='true');
		$("#ShowList1").radio("setValue",data['ShowList1']);
		$("#ShowList2").radio("setValue",data['ShowList2']);
	  	$("#DefaultExpendList").radio("setValue",data['DefaultExpendList']=='true');
	  	$("#DefaultExpendTemplate").radio("setValue",data['DefaultExpendTemplate']=='true');
		$("#DefaultCloseList").radio("setValue",data['DefaultCloseList']);
	  	//$("#BigFont").radio("setValue",data['BigFont']);
	  	//$("#SmallFont").radio("setValue",data['SmallFont']);
	  	$("#ShowGridFootBar").radio("setValue",data['ShowGridFootBar']);
		$("#isEditCopyItem").switchbox("setValue",data['isEditCopyItem']=='true');
		$("#isSetTimeLog").switchbox("setValue",data['isSetTimeLog']=='true');
		if (data['DefaultPopTemplate']==true) {
			$("#DefaultPopTemplate").checkbox('setValue',true);
		}
		if (data['DefaultCMExpendTemplate']==true) {
			$("#DefaultCMExpendTempl").radio('setValue',true);
		}
		$("#DefaultCMCloseTempl").radio('setValue',data['DefaultCMCloseTemplate']=='true');
		$("#DefaultCurrentUser").radio("setValue",data['DefaultCurrentUser']=='true');
		$("#DefaultCurrentLoc").radio("setValue",data['DefaultCurrentLoc']=='true');
		$("#DefaultCurrentGourpe").radio("setValue",data['DefaultCurrentGourpe']=='true');
		$("#DefaultCurrentDocContor").radio("setValue",data['DefaultCurrentDocContor']=='true');
		if (data['DefaultExpendTemplateOnPopTemplate']==true) {
			$("#DefaultExpendTemplateOnPopTemplate").radio('setValue',true);
		}
		$("#DefaultLongOrderPrior").radio('setValue',data['DefaultLongOrderPrior']=='true');
		$("#DefaultShortOrderPrior").radio('setValue',data['DefaultShortOrderPrior']=='true');
		$("#DefaultOutOrderPrior").radio('setValue',data['DefaultOutOrderPrior']=='true');
		$("#execBarExecStNum").numberbox('setValue',data['execBarExecStNum']);
		$("#execBarExecEndNum").numberbox('setValue',data['execBarExecEndNum']);
		if(data["TemplateRegion"]){
			$('input[name="TemplateRegion"]#'+data["TemplateRegion"]).radio('setValue',true);
		}
		$('input[name="DefCollapseTemplate"]').checkbox('setValue',data['DefCollapseTemplate']=='on');
		if(data["DiagTemplateRegion"]){
			$('input[name="DiagTemplateRegion"]#'+data["DiagTemplateRegion"]).radio('setValue',true);
		}
		$('input[name="DefCollapseDiagTemplate"]').checkbox('setValue',data['DefCollapseDiagTemplate']=='on');

		$("#OrdListScale").slider('setValue',data['OrdListScale']||50);
		$("#OrdListWScale").slider('setValue',data['OrdListWScale']||20);
		$("#CNTempScale").slider('setValue',data['CNTempScale']||40);
		$("#CNTempWScale").slider('setValue',data['CNTempWScale']||20);
		if(data["CNTemplateRegion"]){
			$('input[name="CNTemplateRegion"]#'+data["CNTemplateRegion"]).radio('setValue',true);
		}
		$('input[name="CNDefCollapseTemplate"]').checkbox('setValue',data['CNDefCollapseTemplate']=='on');
	});
	$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode1",
		Node:"OPDefDisplayMoreContions", SubNode:SubNode,
		dataType:"text"
	},function(OPDefDisplayMoreContions){
		$("#OPDefDisplayMoreContions").switchbox("setValue",OPDefDisplayMoreContions==1?true:false);
	});
	if (ServerObj.GroupRowId!=""){
		 var Node="ViewGroupSum_Group";
		 var SubNode=ServerObj.GroupRowId;
	 }else{
		 var Node="ViewGroupSum_UserID";
		 var SubNode=session['LOGON.USERID']+'Z'+session['LOGON.GROUPID'];
	 }
	$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode1",
		Node:Node, SubNode:SubNode,
		dataType:"text"
	},function(ViewGroupSumUserID){
		if (ViewGroupSumUserID=="") ViewGroupSumUserID=4;
		$("#ViewGroupSum_UserID").combobox("select",ViewGroupSumUserID);
	});
	
	if (ServerObj.GroupRowId!=""){
		 var Node="IPHiddenAutoOrd_Group";
		 var SubNode=ServerObj.GroupRowId;
	 }else{
		 var Node="IPHiddenAutoOrd_User";
		 var SubNode=session['LOGON.USERID']+'Z'+session['LOGON.GROUPID'];
	 }
	$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode1",
		Node:Node, SubNode:SubNode,
		dataType:"text"
	},function(IPHiddenAutoOrd){
		IPHiddenAutoOrd=IPHiddenAutoOrd ==="true" ? true : false;
		$("#IPHiddenAutoOrd").switchbox("setValue",IPHiddenAutoOrd);
	});
	
	if (ServerObj.GroupRowId!=""){
		 var Node="execBarExecNum_Group";
		 var SubNode=ServerObj.GroupRowId;
	 }else{
		 var Node="execBarExecNum_User";
		 var SubNode=session['LOGON.USERID']+'Z'+session['LOGON.GROUPID'];
	 }
	 $.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode1",
		Node:Node, SubNode:SubNode,
		dataType:"text"
	},function(execBarExecNum){
		if (execBarExecNum.indexOf("-")>=0){
			var execBarExecNumArr=execBarExecNum.split("-");
			$("#execBarExecStNum").numberbox('setValue',execBarExecNumArr[0]);
			$("#execBarExecEndNum").numberbox('setValue',execBarExecNumArr[1]);
		}
	});
	$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode1",
		Node:"ExaSortByUseCount", SubNode:SubNode,
		dataType:"text"
	},function(val){
		$("#ExaSortByUseCount").checkbox('setValue',val==1?true:false);
	});
	$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode1",
		Node:"ExaPartSortByUseCount", SubNode:SubNode,
		dataType:"text"
	},function(val){
		$("#ExaPartSortByUseCount").checkbox('setValue',val==1?true:false);
	});
	
	$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode1",
		Node:"IPDefDisplayMoreContions", SubNode:SubNode,
		dataType:"text"
	},function(val){
		$("#IPDefDisplayMoreContions").switchbox("setValue",val==1?true:false);
	});
	
	if (ServerObj.GroupRowId=="") {
		InitWardCombo();
	}
}
function InitEvent(){
	$("#BSave").click(BSaveClickHandle);
	$("#BRestoreDefault").click(BRestoreDefaultClickHandle);
	$('input[name="TemplateRegion"]').radio({
		onChecked:function(e){
			$('input[name="DefCollapseTemplate"]').next().hide();
			var region=$(e.target).attr('id');
			if(['north','south'].indexOf(region)>-1){
				if(region=='north') $("#layoutConfig2").radio("setValue",true);
				else $("#layoutConfig1").radio("setValue",true);
				$('input[name="layoutConfig"]').radio('disable');
				$('input[name="Expend"]').radio('enable');
				$('#OrdListScale').slider('enable');
				$('#OrdListWScale').slider('disable');
				if(!$('input[name="Expend"]:checked').size()) $('#DefaultExpendList').radio('setValue',true);
			}else{
				$('input[name="layoutConfig"]').radio('enable');
				$('input[name="Expend"]').radio('disable').radio("setValue",false);
				$('#OrdListScale').slider('disable');
				$('#OrdListWScale').slider('enable');
				if(region=='window'){
					$('input[name="DefCollapseTemplate"]').next().show();
				}
			}
			$(e.target).radio('disable');
			$('input[name="TemplateRegion"]').not(e.target).radio('enable');
		}
	})
	$('input[name="DiagTemplateRegion"]').radio({
		onChecked:function(e){
			var region=$(e.target).attr('id');
			if(region=='window'){
				$('input[name="DefCollapseDiagTemplate"]').next().show();
			}else{
				$('input[name="DefCollapseDiagTemplate"]').next().hide();
			}
			$(e.target).radio('disable');
			$('input[name="DiagTemplateRegion"]').not(e.target).radio('enable');
		}
	});
	$('input[name="CNTemplateRegion"]').radio({
		onChecked:function(e){
			var region=$(e.target).attr('id');
			$('input[name="CNDefCollapseTemplate"]').next().hide();
			if(['north','south'].indexOf(region)>-1){
				$('#CNTempScale').slider('enable');
				$('#CNTempWScale').slider('disable');
			}else{
				$('#CNTempScale').slider('disable');
				$('#CNTempWScale').slider('enable');
				if(region=='window'){
					$('input[name="CNDefCollapseTemplate"]').next().show();
				}
			}
			$(e.target).radio('disable');
			$('input[name="CNTemplateRegion"]').not(e.target).radio('enable');
		}
	});
	$('input.hisui-slider').slider({
		onChange:function(val,oldVal){
			$(this).slider('options').oldVal=oldVal;
		},
		onComplete:function(val){
			var opts=$(this).slider('options');
			if(opts.disabled){
				$(this).slider('setValue',opts.oldVal);
			}
		}
	});
	document.onkeydown = Doc_OnKeyDown;
}
function Doc_OnKeyDown(e){
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
}
function BSaveClickHandle(){
	var execBarExecStNum=$.trim($("#execBarExecStNum").numberbox('getValue'));
	var execBarExecEndNum=$.trim($("#execBarExecEndNum").numberbox('getValue'));
	var regu = /^([1-9]\d*|[0]{1,1})$/;
	if ((execBarExecStNum!="")&&(!regu.test(execBarExecStNum))) {
		$.messager.alert("提示","执行日期查询范围只能为正整数!","info",function(){
			$("#execBarExecStNum").focus();
		});
		return false;
	}
	if ((execBarExecEndNum!="")&&(!regu.test(execBarExecEndNum))) {
		$.messager.alert("提示","执行日期查询范围只能为正整数!","info",function(){
			$("#execBarExecEndNum").focus();
		});
		return false;
	}
	var UserID=session['LOGON.USERID'];
	var HospId=session['LOGON.HOSPID'];
	$("#fUIConfig").form("submit",{
		url : "oeorder.oplistcustom.new.request.csp?action=Config_Set&UserID="+UserID+"&GroupID="+ServerObj.GroupRowId+"&LoginGroupRowId="+ServerObj.LoginGroupRowId+"&HospId="+HospId,
		onSubmit: function(param){
			var patSearchDefCon=$('input:radio[name="PatFind"]:checked').val()
			if (patSearchDefCon==undefined) patSearchDefCon="";
		    param.layoutConfig1=$("#layoutConfig1").radio('getValue')?true:false;
			param.layoutConfig2=$("#layoutConfig2").radio('getValue')?true:false;	
			param.OrderPriorConfig1=$("#OrderPriorConfig1").radio('getValue')?true:false;
			param.OrderPriorConfig2=$("#OrderPriorConfig2").radio('getValue')?true:false;	
			param.ShowList1=$("#ShowList1").radio('getValue')?true:false;
			param.ShowList2=$("#ShowList2").radio('getValue')?true:false;			
			param.DefaultExpendList=$("#DefaultExpendList").radio('getValue')?true:false;
			param.DefaultExpendTemplate=$("#DefaultExpendTemplate").radio('getValue')?true:false;
			//param.BigFont=$("#BigFont").radio('getValue')?true:false;
			//param.SmallFont=$("#SmallFont").radio('getValue')?true:false;
			param.ShowGridFootBar=$("#ShowGridFootBar").radio('getValue')?true:false;
			param.isEditCopyItem=$("#isEditCopyItem").switchbox('getValue')?true:false;
			param.DefaultCloseList=$("#DefaultCloseList").radio('getValue')?true:false;
			param.isSetTimeLog=$("#isSetTimeLog").switchbox('getValue')?true:false;
			param.PatSearchDefCon=patSearchDefCon;
			param.OrdListScale=$("#OrdListScale").slider('getValue');
			param.DefaultPopTemplate=$("#DefaultPopTemplate").checkbox('getValue')?true:false;
			param.DefaultExpendTemplateOnPopTemplate=$("#DefaultExpendTemplateOnPopTemplate").checkbox('getValue')?true:false;
			// 中成药列数据
			param.ViewGroupSum_UserID=$("#ViewGroupSum_UserID").combobox("getValue"); 
			param.DefaultCMExpendTemplate=$("#DefaultCMExpendTempl").radio('getValue')?true:false;
			param.DefaultCMCloseTemplate=$("#DefaultCMCloseTempl").radio('getValue')?true:false;
			//param.ViewOrderType=$("#ViewOrderType").combobox("getValue"); 
			param.ViewOrderSort=$("#ViewOrderSort").combobox("getValue"); 
			param.ViewLocDesc=$("#ViewLocDesc").combobox("getValue"); 
			param.ViewScopeDesc=$("#ViewScopeDesc").combobox("getValue"); 
			param.ViewNurderBill=$("#ViewNurderBill").combobox("getValue"); 
			param.DefaultCurrentUser=$("#DefaultCurrentUser").radio('getValue')?true:false;
			param.DefaultCurrentLoc=$("#DefaultCurrentLoc").radio('getValue')?true:false;
			param.DefaultCurrentGourpe=$("#DefaultCurrentGourpe").radio('getValue')?true:false;
			param.DefaultCurrentDocContor=$("#DefaultCurrentDocContor").radio('getValue')?true:false;
			param.DefaultLongOrderPrior=$("#DefaultLongOrderPrior").radio('getValue')?true:false;
			param.DefaultShortOrderPrior=$("#DefaultShortOrderPrior").radio('getValue')?true:false;
			param.DefaultOutOrderPrior=$("#DefaultOutOrderPrior").radio('getValue')?true:false;
			param.IPHiddenAutoOrd=$("#IPHiddenAutoOrd").switchbox('getValue')?true:false;
			
			if ((execBarExecStNum!="")&&(execBarExecEndNum!="")){
				param.execBarExecNum=execBarExecStNum+"-"+execBarExecEndNum;
			}else{
				param.execBarExecNum="";
			}
			if ($("#DefaultCurrentWard").length>0) {
				param.DefaultCurrentWard=$("#DefaultCurrentWard").combobox("getValue");
			}else{
				param.DefaultCurrentWard="";
			}
			param.ExaSortByUseCount=$("#ExaSortByUseCount").checkbox('getValue')?1:0;
			param.ExaPartSortByUseCount=$("#ExaPartSortByUseCount").checkbox('getValue')?1:0;
			param.OPDefDisplayMoreContions=$("#OPDefDisplayMoreContions").switchbox('getValue')?1:0;
			param.TemplateRegion=$("input[name='TemplateRegion']:checked").attr('id')||'';
			param.DiagTemplateRegion=$("input[name='DiagTemplateRegion']:checked").attr('id')||'';
			if ($("#ViewIPDocPatInfoLayOut").length>0) {
				param.ViewIPDocPatInfoLayOut=$("#ViewIPDocPatInfoLayOut").combobox("getValue");
			}else{
				param.ViewIPDocPatInfoLayOut="";
			}
			param.IPDefDisplayMoreContions=$("#IPDefDisplayMoreContions").switchbox('getValue')?1:0;
			param.OrdListWScale=$("#OrdListWScale").slider('getValue');
			param.CNTempScale=$("#CNTempScale").slider('getValue');
			param.CNTempWScale=$("#CNTempWScale").slider('getValue');
			param.CNTemplateRegion=$("input[name='CNTemplateRegion']:checked").attr('id')||'';
		},
		success:function(data){
			var data = eval('(' + data + ')');
			if (data.success) {
				$.messager.popover({msg: data.message,type:'success',timeout: 1000});
				/*$.messager.alert("提示",data.message,"info",function(){
					//刷新父窗口
					var Url=window.opener.location.href;
					if((Url.indexOf("copyOeoris")>0)||(Url.indexOf("copyTo")>0)){
						var HeadUrl=Url.split("?")[0];
						var BackUrl=Url.split("?")[1];
						var strArr=BackUrl.split("&");
					    var strArrNew=strArr.slice(0,strArr.length-2);
					    var NewStr=strArrNew.join("&")+"&copyOeoris=&copyTo=";
					    var Url=HeadUrl+"?"+NewStr;
					    window.opener.location.href = Url;
					}
					window.close();
				})*/
			}
		}
	});
}
function PopTemplateCheckChange(e,value){
	if (value){
		$("#DefaultExpendList").radio('check');
		$("#DefaultExpendList,#DefaultExpendTemplate,#DefaultCloseList").radio('disable');
	}else{
		$("#DefaultExpendList,#DefaultExpendTemplate,#DefaultCloseList").radio('enable');
		$("#DefaultExpendTemplateOnPopTemplate").checkbox('uncheck');
	}
}
function CheckDefExpandTmp(e,value){
	$("#DefaultPopTemplate").checkbox('check');
}
function tipFormatter(value){
	return value+"%";
}
function BRestoreDefaultClickHandle(){
	var UserID=session['LOGON.USERID'];
	var HospId=session['LOGON.HOSPID'];
	$("#fUIConfig").form("submit",{
		url : "oeorder.oplistcustom.new.request.csp?action=RestoreDefault&UserID="+UserID+"&GroupID="+ServerObj.GroupRowId+"&LoginGroupRowId="+ServerObj.LoginGroupRowId+"&HospId="+HospId,
		onSubmit: function(param){
		},
		success:function(data){
			var data = eval('(' + data + ')');
			if (data.success) {
				$.messager.alert("提示",data.message,"info",function(){
					window.location.reload();
				})
					
			}
		}
	});
}
//Desc: 初始化病区下拉框
function InitWardCombo()
{
	$('#DefaultCurrentWard').combobox({
		url:'../web.DHCDocInPatientListNew.cls?action=GetWardList&LocID=' + session['LOGON.CTLOCID'],    
		valueField:'LocID',    
		textField:'LocDesc',
		filter: function(q, row){
			q=q.toUpperCase();
			return (row["LocDesc"].toUpperCase().indexOf(q) >= 0)||(row["Alias"].toUpperCase().indexOf(q) >= 0);
		},
		onLoadSuccess:function(data){
			var SubNode=session['LOGON.USERID']+'Z'+session['LOGON.GROUPID'];
			$.cm({
				ClassName:"web.DHCDocConfig",
				MethodName:"GetConfigNode1",
				Node:"DefaultCurrentWard", SubNode:SubNode,
				dataType:"text"
			},function(WardId){
				$("#DefaultCurrentWard").combobox("select",WardId);
			});
		},
		onChange:function(newValue,oldValue){
			if (newValue=="") {
				$(this).combobox('setValue',"");
			}
		}
	});
}
