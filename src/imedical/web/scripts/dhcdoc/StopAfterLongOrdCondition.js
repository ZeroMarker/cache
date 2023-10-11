$(function(){
	if (ServerObj.type == "NeedDischgCond") {
		InitComboDischargeCondition();
		InitDischargeMethod();
	}
	$("#BSave").click(BSaveClickHandle);
	$("#BCancel").click(BCancelClickHandle);
	$('#LongOrdStopDate').datebox({
	    onHidePanel:function(){
		    setTip();
		}
	});
	$('#LongOrdStopTime').timespinner({
		onSpinUp:function(){
			setTip();
		},
		onSpinDown:function(){
			setTip();
		}
   });
   $('#LongOrdStopTime').bind('input propertychange', function() {
	   setTip();
   })
   SetLongOrdStopDateTime();
})
function SetLongOrdStopDateTime(){
	var paraObj=websys_showModal('options').paraObj;
	$("#LongOrdStopDate").datebox('setValue',paraObj.OrdItemArr[3]);
	$("#LongOrdStopTime").timespinner('setValue',paraObj.OrdItemArr[4]);
	if (paraObj.StartDateEnbale==false) {
		$("#LongOrdStopDate").datebox('disable');
		$("#LongOrdStopTime").timespinner('disable');
	}
	setTip();
}
function BSaveClickHandle(){
	var returnstr="";
	if (ServerObj.type == "NeedDischgCond") {
		var DischargeConditionRowId=$("#Combo_DischargeConditionSel").combobox('getValue');
		if(!DischargeConditionRowId){
			$.messager.alert("提示","请选择出院条件!");
			return false;	
		}
		var DischargeMethodID=$("#Combo_DischargeMethod").combobox('getValue');
		if(!DischargeMethodID){
			$.messager.alert("提示","请选择离院方式!");
			return false;	
		}
		var returnstr=DischargeConditionRowId+'!'+DischargeMethodID;
	}else if( ServerObj.type== "NeedDeathDate"){
		var DeathDate=$("#DeathDate").datebox('getValue');
		var DeathTime=$("#DeathTime").timespinner('getValue');
		if(DeathDate==""){
			$.messager.alert("提示","请填写死亡日期!","info",function(){
				$('#DeathDate').next('span').find('input').focus();
			});
			return false;	
		}
		if(DeathTime==""){
			$.messager.alert("提示","请填写死亡时间!","info",function(){
				$('#DeathTime').focus();
			});
			return false;	
		}
		var returnstr=DeathDate+"!"+DeathTime;
		var paraObj=websys_showModal('options').paraObj;
		var SessionStr = GetSessionStr();
		var cret=tkMakeServerCall("web.DHCOEOrdItem","CheckOrderDeathDateTime",returnstr,paraObj.OrdItemArr[0],SessionStr);
		var carr=cret.split("^");
		if (carr[0]!="0"){
			$.messager.alert("提示",carr[1]);
			return false;	
		}
	}
	var LongOrdStopDate=$("#LongOrdStopDate").datebox('getValue');
	var LongOrdStopTime=$("#LongOrdStopTime").timespinner('getValue');
	if(LongOrdStopDate==""){
		$.messager.alert("提示","请填写停长嘱日期!","info",function(){
			$('#LongOrdStopDate').next('span').find('input').focus();
		});
		return false;	
	}
	if(LongOrdStopTime==""){
		$.messager.alert("提示","请填写停长嘱时间!","info",function(){
			$('#LongOrdStopTime').focus();
		});
		return false;	
	}
	var paraObj=websys_showModal('options').paraObj;
	var OrdItemArr=paraObj.OrdItemArr;
	OrdItemArr[3]=LongOrdStopDate;
	OrdItemArr[4]=LongOrdStopTime
	if (paraObj.StartDateEnbale != false) {
		var rtn=$.cm({
		    ClassName:"web.DHCOEOrdItem",
		    MethodName:"CheckOrderDateTime",
		    Adm:paraObj.EpisodeID,
		    OrdItem:OrdItemArr.join("^"),
		    CheckExpStr:session['LOGON.CTLOCID'],
		    dataType:"text"
		},false)
		var rtnArr=rtn.split("^");
		if (rtnArr[0]<0) {
			$.messager.alert("提示",rtnArr[1]);
			return false;
		}
	}
	returnstr=returnstr+"^"+LongOrdStopDate+" "+LongOrdStopTime;
	if (websys_showModal('options').CallBackFunc) {
		websys_showModal('options').CallBackFunc(returnstr);
	}else{
		window.returnValue=returnstr;
		window.close();
	}
}
function InitComboDischargeCondition(param1)
{
	$("#Combo_DischargeConditionSel").combobox({      
    	valueField:'RowId',    
		textField:'Description',
		required:true,
		editable:false,
		url:"./dhcdoc.cure.query.combo.easyui.csp",
		onBeforeLoad:function(param){
			param.ClassName = 'web.DHCDocOrderEntry';
			param.QueryName = 'LookUpByLocationTypeNew';
			param.Arg1 ="";
			param.Arg2 ="I";
			param.ArgCnt =2;
		}  
	});
}
function InitDischargeMethod()
{
	$("#Combo_DischargeMethod").combobox({      
    	valueField:'ID',    
		textField:'CTDMDesc',
		required:true,
		editable:false,
		url:'DHCDoc.Util.Broker.cls',
		onBeforeLoad:function(param){
			param.ClassName = 'web.DHCDocOrderEntry';
			param.MethodName = 'GetDischargeMethod';
		}    
	});
}
function BCancelClickHandle(){
	if (websys_showModal('options').CallBackFunc) {
		websys_showModal('options').CallBackFunc(null);
	}else{
		window.returnValue=null;
		window.close();
	}
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.DateFormat==3){
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}else if(ServerObj.DateFormat==4){
		return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	}
}
function myparser(s){
	if (!s) return new Date();
	if (ServerObj.DateFormat==3){
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
		if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
			return new Date(y,m-1,d);
		} else {
			return new Date();
		}
	}else if(ServerObj.DateFormat==4){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
		if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
			return new Date(y,m-1,d);
		} else {
			return new Date();
		}
	}
}
function setTip(){
	var LongOrdStopDate=$("#LongOrdStopDate").datebox('getValue');
	var LongOrdStopTime=$("#LongOrdStopTime").timespinner('getValue');
	var tip=$g("将把所有长嘱停止至")+LongOrdStopDate+" "+LongOrdStopTime;
	if (ServerObj.DealExecStartOnZeroBySpecOrder=="1"){
		tip=tip+","+$g("并自动停止执行当日所有执行记录");
	}
	$("#tip").html(tip);
}
