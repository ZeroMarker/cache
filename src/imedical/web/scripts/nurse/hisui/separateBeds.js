var docNurObj=websys_showModal('options').docNurObj;
var tempInfoArr=websys_showModal('options').tempInfo;
$(function() {
	initPageData();
	initEvent();
})
function initEvent(){
	$("#BSave").click(SaveClick);
	$("#BCancel").click(CancelClick);
	document.onkeydown = function enterHandler(event){
	     var inputs = $("input");    
	     var Code = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
	     if (Code == 13) {
	         for(var i=0;i<inputs.length;i++){
	            if(inputs[i].id == document.activeElement.id){    
	                i = i== (inputs.length - 1) ? -1 : i ;
	                var id=inputs[i+1].id;
	                if (id) $('#'+ inputs[i+1].id ).focus();
	                else  inputs[i+1].focus();
	                break;
	            }
	         }
	      }
	 }
}
function initPageData() {
	initMainDoc();
	initMainNurse();
	if (ServerObj.firstAssignBedFlag==1) {
		initTempInfoHtml();
	}
	var timeObj=getServerTime(1,dtseparator=='-'?3:4);
	$("#date").datebox("setValue",timeObj.date);
	$("#time").timespinner("setValue",timeObj.time);
}
function initMainDoc(){
	$("label[for=docList]").addClass(docNurObj.MainDocRequired=="Y"?"clsRequired":"");
	if (ServerObj.firstAssignBedFlag!=1) {
		if ((docNurObj.MainDocRequired=="Y")&&(docNurObj.MainNurseRequired=="N")){
			$("label[for=nurList]").css("padding-left","8px");
		}
	}
	var currLocID=$.cm({
		ClassName:"Nur.NIS.Service.Base.Patient",
		MethodName:"GetCurrLocID",
		EpisodeID:ServerObj.EpisodeID
	},false)
	var docData=$.cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		MethodName:"GetMainDoctors",
		locID:currLocID
	},false)
	$('#docList').combobox({
		multiple:docNurObj.MainDocMulti=="Y"?true:false,
		rowStyle:docNurObj.MainDocMulti=="Y"?"checkbox":"",
		disabled:false,
		blurValidValue:true,
		selectOnNavigation:true,
		valueField:'ID',
		textField:'name',
		data:docData,
		filter: function(q, row){
			var pyjp = getPinyin(row["name"]).toLowerCase();
			return (row["name"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(pyjp.toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},
		onLoadSuccess:function(){
			if (docNurObj.MainDocMulti=="Y"){
				if (docNurObj.mainDoctorID.length ==0){
					$('#fromMainDoc').combobox("setValues","");
				}else{
					$('#fromMainDoc').combobox("setValues",docNurObj.mainDoctorID);
				}
			}else{
				$('#docList').combobox("setValue",docNurObj.mainDoctorID[0]);
			}
		},
		onSelect:function(rec){
			if (docNurObj.MainDocMulti=="Y"){
				var selValArr=$('#docList').combobox("getValues");
				if (selValArr.length>=3){
					$('#docList').combobox("setValues",selValArr.slice(1,3))
				}
			}
		}
    });
}
function initMainNurse(){
	$("label[for=nurList]").addClass(docNurObj.MainNurseRequired=="Y"?"clsRequired":"");
	if (ServerObj.firstAssignBedFlag!=1) {
		if ((docNurObj.MainNurseRequired=="Y")&&(docNurObj.MainDocRequired=="N")){
			$("label[for=docList]").css("padding-left","8px");
		}
	}
	var nurData=$.cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		MethodName:"GetMainNurses",
		locID:session['LOGON.CTLOCID']
	},false)
	$('#nurList').combobox({
		multiple:docNurObj.MainNurseMulti=="Y"?true:false,
		rowStyle:docNurObj.MainNurseMulti=="Y"?"checkbox":"",
		disabled:false,
		blurValidValue:true,
		selectOnNavigation:true,
		valueField:'ID',
		textField:'name',
		data:nurData,
		filter: function(q, row){
			var pyjp = getPinyin(row["name"]).toLowerCase();
			return (row["name"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(pyjp.toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},
		onLoadSuccess:function(){
			if (docNurObj.MainNurseMulti=="Y"){
				if (docNurObj.mainNurseID.length ==0){
					$('#nurList').combobox("setValues","");
				}else{
					$('#nurList').combobox("setValues",docNurObj.mainNurseID);
				}
			}else{
				$('#nurList').combobox("setValue",docNurObj.mainNurseID[0]);
			}
		},
		onSelect:function(rec){
			if (docNurObj.MainNurseMulti=="Y"){
				var selValArr=$('#nurList').combobox("getValues");
				if (selValArr.length>=3){
					$('#nurList').combobox("setValues",selValArr.slice(1,3))
				}
			}
		}
    });
}
function initTempInfoHtml(){
	var html="";
	for (var i=0;i<tempInfoArr.length;i++){
		var code=tempInfoArr[i].code;
		var desc=tempInfoArr[i].desc;
		var select=tempInfoArr[i].select; //true 下拉框 (options)
		var arrangeBedShow=tempInfoArr[i].arrangeBedShow; //R 必填
		var symbol=tempInfoArr[i].symbol; //特殊符号
		var udFlag=tempInfoArr[i].udFlag; //体征项配置特殊值后是否支持自定义输入
		if (((i+1) % 2 !=0)) {
			html += "<tr>";
		}
		var labCls="";
		if (arrangeBedShow=="R") labCls="clsRequired"; 
		html += "<td class='r-label1'>"+
					"<label class='"+(arrangeBedShow=="R"?"clsRequired":"")+"' for='"+code+"'>"+desc+"</label>"+
				"</td>";
		if (select){ //可选/可录
			if (udFlag=="Y"){
				html += "<td><select id='"+code+"' class='hisui-combobox tempinfoCombo'>";
			}else{
				html += "<td><select id='"+code+"' class='hisui-combobox tempinfoCombo'  data-options='editable:false'>";
			}
			//html += "<td><select id='"+code+"' class='hisui-combobox tempinfoCombo'>";
			for (var j=0;j<tempInfoArr[i].options.length;j++){
				var optsVal=tempInfoArr[i].options[j];
				html += "<option value='"+optsVal+"'>"+optsVal+"</option>";  
			}
			html += "</select></td>";
		}else if(symbol){			
			html += "<td><select id='"+code+"' class='hisui-combobox tempinfoCombo'>";
			for (var j=0;j<tempInfoArr[i].symbol.length;j++){
				var optsVal=tempInfoArr[i].symbol[j];
				html += "<option value='"+optsVal+"'>"+optsVal+"</option>";  
			}
			html += "</select></td>";
		}else{
			
			html += "<td>"+
						"<input id='"+code+"' class='hisui-validatebox tempinfoInput textbox'>"+
					"</td>";
		}
		if (((i+1) % 2 ==0)||(i == (tempInfoArr.length-1))) {
			html += "</tr>";
		}
	}
	$("#BSave").parents("tr").before(html);
	$HUI.combobox($(".tempinfoCombo"),{
		onLoadSuccess:function(){
			$(this).combobox("select","");
		}
	});
	$HUI.validatebox($(".tempinfoInput"),{});
	var tableH=$(".firstAssignBedTable").height();
	var tableParentH=$(".firstAssignBedTable").parent().height();
	debugger;
	$(".firstAssignBedTable").css({"margin-top":(tableParentH - tableH - 2)/2});
}
function SaveClick(){
	var date=$("#date").datebox("getValue");
	var time=$("#time").timespinner("getValue");
	var docID=$("#docList").combobox("getValues").join(",");
	if ((docNurObj.MainDocRequired=="Y")&&(docID=="")){
		$.messager.popover({msg:'请在下拉框中选择主管医生',type:'error'});
		$('#docList').next('span').find('input').focus();
		return false;
	}
	var nurserID=$("#nurList").combobox("getValues").join(",");
	if ((docNurObj.MainNurseRequired=="Y")&&(nurserID=="")){
		$.messager.popover({msg:'请在下拉框中选择主管护士',type:'error'});
		$('#nurList').next('span').find('input').focus();
		return false;
	}
	// 首次分床获取体征项信息
	var inValisTempArr=[];
	var nullTempArr=[];
	var tempData = [];
	if (ServerObj.firstAssignBedFlag==1) {
		for (var i=0;i<tempInfoArr.length;i++){
		var code=tempInfoArr[i].code;
		var desc=tempInfoArr[i].desc;
		var select=tempInfoArr[i].select; //true 下拉框 (options)
		var arrangeBedShow=tempInfoArr[i].arrangeBedShow; //R 必填
		var symbol=tempInfoArr[i].symbol; //特殊符号
		var udFlag=tempInfoArr[i].udFlag; //体征项配置特殊值后是否支持自定义输入
		if (select) {
			var signsValue=$("#"+code).combobox("getValue");
			if ((udFlag=="Y")&&(signsValue=="")){
				signsValue=$("#"+code).combobox("getText");
			}
		}else if(symbol){
			var signsValue=$("#"+code).combobox("getText");
		}else{
			var signsValue=$.trim($("#"+code).val());
		}
		if ((signsValue =="")&&(arrangeBedShow=="R")) {
			nullTempArr.push(desc);
		}
		if (signsValue!="") {
			var inValidMsg=handleValidator(tempInfoArr[i],signsValue);
			if (inValidMsg!="") inValisTempArr.push(desc+inValidMsg);
		}
        tempData.push({ code: code, value: signsValue, time: time });
      }
      var errMsg="";
      if (nullTempArr.length>0) errMsg=nullTempArr.join("、")+" 未填写！";
      if (inValisTempArr.length>0) errMsg+=inValisTempArr.join("、");
      if (errMsg) {
	      $.messager.popover({msg:errMsg,type:'error'});
	      return false;
	  }
      tempData = JSON.stringify(tempData);
    }
	var rtn={
	    tempData:tempData,
        mainDocID:docID,
        mainNurseID:nurserID,
        date:date,
        time:time,
		result:true,
	}
	websys_showModal('options').CallBackFunc(rtn);
}
function CancelClick(){
	websys_showModal('options').CallBackFunc({result:false});
}
function handleValidator(data,val){
	var symbol=data.symbol; //特殊符号
	var udFlag=data.udFlag; //体征项配置特殊值后是否支持自定义输入
	if (data.select){
		if ($.inArray(val, data.options)>=0) return "";
		if ((udFlag!="Y")&&($.inArray(val, data.options)<0)){
			return "请在下拉框中选择特殊值！";
		}
	}else if(symbol){
		if ($.inArray(val, symbol)>=0) return "";
	}
	if (
        data.hasOwnProperty("errorValueLowTo") ||
        data.hasOwnProperty("errorValueHightFrom")
      ) {
        if (isNaN(val)) {
          return "请输入有效数字！";
        } else {
          if (
            data.hasOwnProperty("errorValueLowTo") &&
            val <= data.errorValueLowTo
          ) {
            return "值下限须大于" + data.errorValueLowTo;
          }
          if (
            data.hasOwnProperty("errorValueHightFrom") &&
            val >= data.errorValueHightFrom
          ) {
            return "值上限须小于" + data.errorValueHightFrom;
          }
        }
   }
   return "";
}
