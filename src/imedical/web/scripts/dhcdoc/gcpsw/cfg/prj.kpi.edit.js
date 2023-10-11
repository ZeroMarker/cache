/**
 * prj.kpi.edit.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */
$(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	InitPLObject();
	InitCombox();
	InitData()
	IntAdmDiadesc()
}

function InitEvent () {
	$("#save").click(saveHandler);
	$("#NoICDDiag").keyup(function(event){
		var keyCode = event.which || event.keyCode;
		if (keyCode==13) {
			var Desc=$(this).val(),
				ID = "NOICD";
			if (Desc=="") {
				return false;
			}
			var chk = CheckDiag();
			if (!chk) return false;
			
			if (PLObject.m_DianosListICD==""){
				PLObject.m_DianosListICD=Desc+"^"+ID;
			}else{
				PLObject.m_DianosListICD=PLObject.m_DianosListICD+"!"+Desc+"^"+ID;
			}
			SetDiagVal();
			IntDianosList();
			$(this).val("");
		}
	})
}

function PageHandle() {
	
}

function InitPLObject() {
	PLObject.m_Val="";
	PLObject.m_DianosListICD="";
}

function SetUOM(record) {
	if(typeof record == "undefined") {
		return
	}
	switch (record.code) {
		case "age":
			$("#uom").val("岁")
			break;
		case "height":
			$("#uom").val("cm")
			break;
		case "weight":
			$("#uom").val("kg")
			break;
		case "BMI":
			$("#uom").val("kg/m2")
			break;
		default:
			$("#uom").val("")
	}
		
}
function InitCombox() {
	PLObject.m_KPIType = $HUI.combobox("#kpitype", {
		url:$URL+"?ClassName=DHCDoc.GCPSW.CFG.KPIType&QueryName=QryKPIType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true,
		onSelect: function (record) {
			PLObject.m_KPI.clear();
			PLObject.m_Val="";
			SetToInput("#val");
			$("#val").removeAttr("disabled").val("");
			$("#MRDiaList").empty();
			$("#AdmDiadesc").lookup("disable")
			$("#NoICDDiag").attr("disabled","disabled")
			var url = $URL+"?ClassName=DHCDoc.GCPSW.CFG.KPI&QueryName=QryKPI&KTID="+record.id+"&ResultSetType=array";
			PLObject.m_KPI.reload(url)
		}
	});
	PLObject.m_KPI = $HUI.combobox("#kpi", {
		url:$URL+"?ClassName=DHCDoc.GCPSW.CFG.KPI&QueryName=QryKPI&ResultSetType=array",
		valueField:'id',
		textField:'name',
		blurValidValue:true,
		onSelect: function (record) {
			SetUOM(record)
			if (record.express!="") {
				var ExpArr = record.express.split("&");
				/*var QueryName = express.substring(express.lastIndexOf(".")+1);
				var len=express.length-QueryName.length-1
				var ClassName=express.substring(0,len);*/
				var ClassName = ExpArr[0],
					QueryName = ExpArr[1],
					ParaList = "",
					url = "";
				if (ExpArr.length==2) {
					url = $URL+"?ClassName="+ClassName+"&QueryName="+QueryName+"&ResultSetType=array";
				} else {
					var KTID = parseInt(record.id);
					ParaList="&"+ExpArr[2]+"="+KTID
					url = $URL+"?ClassName="+ClassName+"&QueryName="+QueryName+ParaList+"&ResultSetType=array";
				}
				
				var multiple = false;
				if (record.complex=="Y")  multiple=true;
				PLObject.m_Val = $HUI.combobox("#val", {
					url:url,
					valueField:'id',
					width:257,
					defaultFilter:4,
					multiple:multiple,
					textField:'desc',
					blurValidValue:true,
					onSelect: function (record) {
						//alert(record.id)
					}
				});
				SetToCombox("#val")
			} else {
				PLObject.m_Val="";
				SetToInput("#val");
				if (record.code.indexOf("Diag")>=0) {
					$("#val").attr("disabled","disabled")
					$("#AdmDiadesc").lookup("enable");
					$("#NoICDDiag").removeAttr("disabled")
				} else {
					$("#val").removeAttr("disabled")
					$("#AdmDiadesc").lookup("disable")
					$("#NoICDDiag").attr("disabled","disabled")
					}
			}
		}
	});
}

function InitData() {
	if (ServerObj.PKID!="") {
		$cm({
			ClassName:"DHCDoc.GCPSW.Model.PrjKPI",
			MethodName:"GetInfo",
			id: ServerObj.PKID
		},function(MObj){
			$("#uom").val(MObj.PKKPIUom)
			$("#note").val(MObj.PKNote)
			if (MObj.PKSection=="1") {
				$("#section").checkbox("check")
			} else {
				$("#section").checkbox("uncheck")
			}
			PLObject.m_KPIType.disable();
			PLObject.m_KPI.disable();
			PLObject.m_KPIType.select(MObj.PKType)
			setTimeout(function () {
				PLObject.m_KPI.select(MObj.PKKPI)
				if (!MObj.Express) {
					$("#val").val(MObj.PKVal)
				} else {
					PLObject.m_Val.setValues(MObj.PKVal.split(","))	//
				}
			},100)
			
			if (MObj.KPICode.indexOf("Diag")>=0) {
				$m({
					ClassName:"DHCDoc.GCPSW.CFG.Translate",
					MethodName:"DiagnosisInfo",
					ids:MObj.PKVal
				},function(res){	
					PLObject.m_DianosListICD=res;
					IntDianosList()
				});
			}
			
			
			
		});
	}
}

///诊断列表创建
function IntDianosList()
{
	$("#MRDiaList").empty();
	var panel=$("#MRDiaList");
	var InnerStr="";
	if (PLObject.m_DianosListICD!=""){
		var DianosListArry=PLObject.m_DianosListICD.split("!");
		for (var i=0;i<DianosListArry.length;i++){
			var Desc=DianosListArry[i].split("^")[0];
			var ICDDr=DianosListArry[i].split("^")[1];
		
			InnerStr=InnerStr+"<input name='ICDList' id=\""+ICDDr +"\" DescICD=\""+Desc+ "\" class='hisui-checkbox' data-options='checked:true' type='checkbox' label='"+Desc+"'>";
		}
	}
	panel.append(InnerStr);
	$HUI.checkbox($("input[name='ICDList']"),{onUnchecked:function(){DelDiangose()}});
}

function DelDiangose(){
	//去除列表中未选中的诊断
	var ObjInputs=$("input[name='ICDList']");
	debug(ObjInputs.length,"ObjInputs.length")
	var Str=""
    for (var i=0;i<ObjInputs.length;i++){
        var inputObj=ObjInputs[i];
        if (inputObj) {
	       // debug(inputObj,"inputObj")
	        if (inputObj.checked) {
		        var Desc=inputObj.getAttribute("DescICD");
		        var ICD=inputObj.id;
		        debug(ICD,"ICD")
		        if (Str==""){
			       Str=Desc+"^"+ICD
			    }else{
				   Str=Str+"!"+Desc+"^"+ICD;
			    }
		    } else {
			    $(inputObj).checkbox('setValue',false);
			}
	    } 
    }
    if (Str==""){
	      
	}
    //重新赋值
	PLObject.m_DianosListICD=Str;
	IntDianosList();
	SetDiagVal();
}

function IntAdmDiadesc(){
	//诊断
	 $("#AdmDiadesc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'desc',
        columns:[[  
            {field:'desc',title:'诊断名称',width:300,sortable:true},
			{field:'code',title:'code',width:120,sortable:true},
			{field:'HIDDEN',title:'HIDDEN',width:120,sortable:true,hidden:true}
        ]],
        pagination:true,
        disabled:true,
        panelWidth:500,
        panelHeight:410,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCMRDiagnos',QueryName: 'LookUpWithAlias'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
	       // var DiaType="0"
			//if ($HUI.checkbox("#DiaType").getValue()){
			//	DiaType="1";
			//}
			//param = $.extend(param,{desc:desc,ICDType:DiaType});
			param = $.extend(param,{desc:desc});
	    },onSelect:function(ind,item){
		    var chk=CheckDiag();
		    if (!chk) return false;
		    var DiaStatus="";
		    var DiaStatusId="";
            var Desc=item['desc'];
			var ID=item['HIDDEN'];
			if (PLObject.m_DianosListICD==""){
				PLObject.m_DianosListICD=Desc+"^"+ID;
			}else{
				PLObject.m_DianosListICD=PLObject.m_DianosListICD+"!"+Desc+"^"+ID;
			}
			//选择之后直接创建到列表	
			IntDianosList();
			SetDiagVal();
			$HUI.lookup("#AdmDiadesc").clear();
			$HUI.lookup("#AdmDiadesc").hidePanel();
		}
    });
}

function CheckDiag () {
	if (PLObject.m_DianosListICD=="") return true;
	var DArr = PLObject.m_DianosListICD.split("!");
	if (DArr.length>=5) {
		$.messager.alert("提示","最多选择5个诊断！","warning")	
		return false;
	}
	
	return true;
	
}
function SetDiagVal() {
	var MList=[]
	if (PLObject.m_DianosListICD=="") {
		var mRtn = ""
	} else {
		var DArr = PLObject.m_DianosListICD.split("!");
		for(var i=0;i<DArr.length;i++) {
			var CArr=DArr[i].split("^")
			if (CArr[1] == "NOICD") {
				MList.push(CArr[0]);
			} else {
				MList.push(CArr[1]);
			}
			
		}
		var mRtn=MList.join(",")
	}
	

	$("#val").val(mRtn);
}

function InitDiagnosICDDescLookUp(id){
	/*var ClassName="web.DHCMRDiagnos"
	var QueryName="LookUpWithAlias"
	url = $URL+"?ClassName="+ClassName+"&QueryName="+QueryName+"&ResultSetType=array";
	PLObject.m_Val = $HUI.combobox("#val", {
					url:url,
					valueField:'id',
					width:257,
					textField:'desc',
					blurValidValue:true,
					onBeforeLoad:function(param){
						var desc=param['q'];
						param.desc= desc;
						//param.indesc= param[q];
					
					}
				});
				
	return */
	 $("#"+id).lookup({
	        url:$URL,
	        mode:'remote',
	        method:"Get",
	        idField:'HIDDEN',
	        textField:'desc',
	        columns:[[  
	           {field:'desc',title:'诊断名称',width:350,sortable:true},
	           {field:'code',title:'编码',width:120,sortable:true}
	        ]],
	        pagination:true,
	        panelWidth:500,
	        panelHeight:300,
	        isCombo:true,
	        minQueryLen:2,
	        delay:'500',
	        queryOnSameQueryString:true,
	        queryParams:{ClassName: 'web.DHCMRDiagnos',QueryName: 'LookUpWithAlias'},
	        onBeforeLoad:function(param){
		        var desc=param['q'];
		        if (desc=="") return false;
		        
				param = $.extend(param,{desc:desc});
		    },onSelect:function(ind,item){
			    var ItemArr=new Array();
			    $.each(item, function(key, val) {
					ItemArr.push(val);
				});
				
			}
	});
}
function saveHandler() {
	var KPITypeText=PLObject.m_KPIType.getText()||"";
	var KPITypeValue=PLObject.m_KPIType.getValue()||"";
	if (KPITypeValue=="") {
		$.messager.alert("提示","指标类型不能为空！","warning")
		return false;
	}
	var id = ServerObj.PKID;
	var PID = ServerObj.PID;
	var KPI = PLObject.m_KPI.getValue()||"";
	var section = $("#section").checkbox("getValue")?"1":"0";
	var val="";
	if (PLObject.m_Val=="") {
		val = $.trim($("#val").val());
	} else {
		val = PLObject.m_Val.getValues();
		if (KPITypeText.indexOf("检验")>=0) {
			if (val.length>5) {
				$.messager.alert("提示","检验筛选值不能超过5个！","warning")
				return false;
			}
		}
		val = val.join(",")
	}
	var uom = $.trim($("#uom").val());
	var note = $.trim($("#note").val());
	var user = GetSession("USER");
	
	if (KPI=="") {
		$.messager.alert("提示","指标不能为空！","warning")
		return false;
	}
	
	if (val=="") {
		$.messager.alert("提示","筛选值不能为空！","warning")
		return false;
	}
	
	var mList = id+"^"+KPI+"^"+section+"^"+val+"^"+uom+"^"+user+"^"+note;
	
	$m({
		ClassName:"DHCDoc.GCPSW.CFG.PrjKPI",
		MethodName:"Save",
		PID:PID,
		mList:mList
	}, function(result){
		if (parseInt(result) > 0) {
			$.messager.alert("提示", "保存成功！", "info", function () {
				parent.websys_showModal("hide");
				parent.websys_showModal('options').CallBackFunc();
				parent.websys_showModal("close");	
			});
		} else if (result == "-2") {
			$.messager.alert("提示", "配置已存在！", "warning");
			return false;
		} else {
			$.messager.alert("提示", "保存失败：" + result , "info");
			return false;
		}
	});
	
	
	
}