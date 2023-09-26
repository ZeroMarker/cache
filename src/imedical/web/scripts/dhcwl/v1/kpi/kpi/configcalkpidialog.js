
/**
*   Creator   : wk
*   CreatDate : 2018-05-03
*   Desc      : 计算指标配置规则以及维度配置界面
*/

$("#bracketsLeft,#bracketsRight,#addSign,#lessSign,#mulSign,#excSign,#backspaceSign,#cleanSign").click(function(e){
	var sign = e.target.innerText
	var calKPIRule = $("#calKPIRule").val();
	if (!calKPIRule) {
		return;
	}
	if(sign == "←"){
		var calKPIRule = calKPIRule.substr(0,calKPIRule.length-1);
		$("#calKPIRule").val(calKPIRule);
	}else if (sign == "C"){
		$("#calKPIRule").val("");
	}else{
		calKPIRule = calKPIRule + sign
		$("#calKPIRule").val(calKPIRule);
	}
	
})

/*--点击保存计算规则按钮--*/
$("#saveCalKPIRule").click(function(){
	var calKPIRule = $("#calKPIRule").val();
	$("#calRule").val(calKPIRule);
	$HUI.dialog("#kpiCalRuleDialog").close();
})


$("#calRuleButton").click(function(e){
	$("#calKPIRule").val("");
	/*--展示弹出框--*/
	$("#kpiCalRuleDialog").show();
	$HUI.dialog("#kpiCalRuleDialog",{
		resizable:true,
		modal:true,
		iconCls:'icon-w-config'
	});
	/*--弹出框中的指标表格--*/
	$HUI.datagrid("#kpiForSelectTable",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.KPI.KPIFunction',
			QueryName:'GetKPIListQuery',
		},
		striped:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,50,100],
		onDblClickRow:function(index,row){
			var kpiCode = row.kpiCode;
			var calKPIRule = $("#calKPIRule").val();
			if (calKPIRule != ""){
				var str = calKPIRule.charAt(calKPIRule.length - 1);
				if (str == ">"){
					myMsg("指标间需要选择运算符");
					return;
				}
			}
			calKPIRule = calKPIRule + "<" + kpiCode + ">"
			$("#calKPIRule").val(calKPIRule);
		}
	})
})


/*--点击计算指标维度按钮--*/
$("#sumDimButton").click(function(e){
	var aryKpiDatas=new Array();
	var kpiCodes = "";
	var kpiRuleObjForRule={};
	var calExp = $("#calRule").val();        //获取计算指标的规则
	if (!calExp){  
		return;
	}
	var calExpT=calExp.split('>');           //获取计算指标的规则中的指标编码
	for (var i=0;i<=calExpT.length-1;i++) {
		var code=calExpT[i].split('<')[1];
		if (code){
			//kpiRuleObjForRule[code] = {};
			kpiRuleObjForRule[code] = [];
			if (kpiCodes!="") kpiCodes=kpiCodes+",";
			kpiCodes=kpiCodes+code;
		}
	}
	if (!kpiCodes){
		return;
	}
	/*--显示弹窗--*/
	$("#dimSelectorDialog").show();
	$HUI.dialog("#dimSelectorDialog",{
		resizable:true,
		modal:true,
		iconCls:'icon-w-config'
	})
	//alert(kpiCodes);
	$("#calKPIListBox").val(kpiCodes);
	/*--展示树--*/
	$HUI.treegrid("#calKPIDimSelectTree",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction",
			QueryName:"GetKPIRuleTreeQuery",
			inputRule:kpiCodes,
			treeDeep:"kpiDim",
			rows:10000,
			page:1
		},
		toolbar:"#calKPIList",
		onCheckNode:function(row,checked){
			if (row){
				var type = row.type;
				if (type == "KPIDIM"){
					code = row.code;
					kpiNode = $("#calKPIDimSelectTree").treegrid("getParent",row.ID);
					kpiCode = kpiNode.code;
					if (checked){
						if (!kpiRuleObjForRule.hasOwnProperty(kpiCode)){
							//kpiRuleObjForRule[kpiCode] = {};
							kpiRuleObjForRule[kpiCode] = [];
						}
						if (!kpiRuleObjForRule[kpiCode].hasOwnProperty(code)){
							//kpiRuleObjForRule[kpiCode][code] = {};
							kpiRuleObjForRule[kpiCode].push(code);
						}
					}else{
						//delete kpiRuleObjForRule[kpiCode][code];
						kpiRuleObjForRule[kpiCode].remove(code);
					}
				}else if(type =="SECDIM"){
					code = row.code;
					kpiNode = $("#calKPIDimSelectTree").treegrid("getParent",row.ID);
					kpiCode = kpiNode.code;
					code = "$" + code;
					if (checked){
						if (!kpiRuleObjForRule.hasOwnProperty(kpiCode)){
							//kpiRuleObjForRule[kpiCode] = {};
							kpiRuleObjForRule[kpiCode] = [];
						}
						if (!kpiRuleObjForRule[kpiCode].hasOwnProperty(code)){
							//kpiRuleObjForRule[kpiCode][code] = {};
							kpiRuleObjForRule[kpiCode].push(code);
						}
					}else{
						//delete kpiRuleObjForRule[kpiCode][code];
						kpiRuleObjForRule[kpiCode].remove(code);
					}
				}
			}
			//var kpiCalRuleValue =  refreshKPIRule(kpiRuleObjForRule);
			var kpiCalRuleValue = refreshKPIRuleNew(kpiRuleObjForRule);
			$("#calKPIListBox").val(kpiCalRuleValue);
		}
	})
})

/*--点击计算指标确定按钮--*/
$("#defineButton").click(function(){
	var calDimValue = $("#calKPIListBox").val();
	$HUI.dialog("#dimSelectorDialog").close();
	$("#sumDim").val(calDimValue);
})