$(function(){
	InitHospList();
    $('#BSave').click(SaveOneAndOutOrdRecLocConfig)
	//选中子类 维护子类对应的接受科室
	$('#List_MedItemCat').click(LoadCatRecLoc);
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_OneAndOutOrderRecloc");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	//根据医嘱类型初始化默认接收科室  不走此规则的住院接受科室
	InitRecLoc();
	//加载子类列表
	LoadCatList("List_MedItemCat","");
	LoadRecLoc("List_RecLoc","");
}
function SaveOneAndOutOrdRecLocConfig()
{
	var RecLocStr="";
	var CatDr=$("#List_MedItemCat").find("option:selected").val();
	if(CatDr!=undefined){
	    var size = $("#List_RecLoc"+ " option").size();
	    if(size>0){
			$.each($("#List_RecLoc"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (RecLocStr=="") RecLocStr=svalue;
			  else RecLocStr=RecLocStr+"^"+svalue;
			})
	   }
	};
	var DefaultRecLocStr="";
	var size = $("#List_DefaultRecLoc"+ " option").size();
	if(size>0){
		$.each($("#List_DefaultRecLoc"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (DefaultRecLocStr=="") DefaultRecLocStr=svalue;
			  else DefaultRecLocStr=DefaultRecLocStr+"^"+svalue;
		})
	};
	var LocNoInStr="";
	var size = $("#List_LocNoInOutOrderCF"+ " option").size();
	if(size>0){
		$.each($("#List_LocNoInOutOrderCF"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (LocNoInStr=="") LocNoInStr=svalue;
			  else LocNoInStr=LocNoInStr+"^"+svalue;
		})
	};
	var OrderPrior=$("#Combo_OrdPrior").combobox('getValue');
	if (OrderPrior=="取药医嘱"){
		//保存子类对应的接收科室
		if(CatDr!=undefined){
			var value=$.m({ 
				ClassName:"web.DHCDocConfig", 
				MethodName:"SaveConfig1",
				Node:"OneOrderRecLoc",
				Node1:CatDr,
				NodeValue:RecLocStr,
				HospId:$HUI.combogrid('#_HospList').getValue()
			},false);
			if(value!="0"){
				$.messager.alert("提示", "保存取药医嘱接收科室,子类对应的接收科室失败!");	
				return false;				
			}
		}
		//保存默认接收科室
		var value=$.m({ 
			ClassName:"web.DHCDocConfig", 
			MethodName:"SaveConfig2",
			Node:"OneOrderDefaultRecLoc",
			NodeValue:DefaultRecLocStr,
			HospId:$HUI.combogrid('#_HospList').getValue()
		},false);
		if(value!="0"){
			$.messager.alert("提示", "保存取药医嘱接收科室,默认接收科室失败!");
			return false;								
		}
		//保存不走此规则的接受科室
		var value=$.m({ 
			ClassName:"web.DHCDocConfig", 
			MethodName:"SaveConfig2",
			Node:"LocNoInOneOrderCF",
			NodeValue:LocNoInStr,
			HospId:$HUI.combogrid('#_HospList').getValue()
		},false);
		if(value!="0"){
			$.messager.alert("提示", "保存取药医嘱接收科室,不走此规则的接受科室失败!");
			return false;				
		}
	}else{
		if(CatDr!=undefined){
			//保存子类对应的接收科室
			var value=$.m({ 
				ClassName:"web.DHCDocConfig", 
				MethodName:"SaveConfig1",
				Node:"OutOrderRecLoc",
				Node1:CatDr,
				NodeValue:RecLocStr,
				HospId:$HUI.combogrid('#_HospList').getValue()
			},false);
			if(value!="0"){
				$.messager.alert("提示", "保存出院带药医嘱接收科室,子类对应的接收科室失败!");	
				return false;				
			}
	   }
		//保存默认接收科室
		var value=$.m({ 
			ClassName:"web.DHCDocConfig", 
			MethodName:"SaveConfig2",
			Node:"OutOrderDefaultRecLoc",
			NodeValue:DefaultRecLocStr,
			HospId:$HUI.combogrid('#_HospList').getValue()
		},false);
		if(value!="0"){
			$.messager.alert("提示", "保存出院带药医嘱接收科室,默认接收科室失败!");
			return false;								
		}
		//保存不走此规则的接受科室
		var value=$.m({ 
			ClassName:"web.DHCDocConfig", 
			MethodName:"SaveConfig2",
			Node:"LocNoInOutOrderCF",
			NodeValue:LocNoInStr,
			HospId:$HUI.combogrid('#_HospList').getValue()
		},false);
		if(value!="0"){
			$.messager.alert("提示", "保存出院带药医嘱接收科室,不走此规则的接受科室失败!");
			return false;				
		}
	}
	$.messager.show({title:"提示",msg:"保存成功"});	
}
function LoadCatRecLoc()
{
	$("#List_RecLoc").empty(); 
	var OrderPrior=$("#Combo_OrdPrior").combobox('getValue');
	if (OrderPrior=="取药医嘱"){
		ReLoadRecLocByCat("List_RecLoc","OneOrderRecLoc");
	}else{
		ReLoadRecLocByCat("List_RecLoc","OutOrderRecLoc");
	};
};
function ReLoadRecLocByCat(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var CatDr=$("#List_MedItemCat").find("option:selected").val(); 
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.OneAndOutOrderRecLoc", 
		QueryName:"FindRecLocByCat",
		CatDr:CatDr,
		value:param2,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.CTLOCRowID + ">" + n.CTLOCDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]=="true"){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
	}
							
}
function InitRecLoc()
{
	var OrderPrior=$("#Combo_OrdPrior").combobox('getValue');
	if (OrderPrior=="取药医嘱"){
		LoadRecLoc("List_DefaultRecLoc","OneOrderDefaultRecLoc");
		LoadLocNoInOrderCF("List_LocNoInOutOrderCF","LocNoInOneOrderCF");
	}else{
		LoadRecLoc("List_DefaultRecLoc","OutOrderDefaultRecLoc");
		LoadLocNoInOrderCF("List_LocNoInOutOrderCF","LocNoInOutOrderCF");
	};
};
function LoadLocNoInOrderCF(param1,param2)
{
	$("#"+param1+"").find("option").remove();
  var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.OneAndOutOrderRecLoc", 
		QueryName:"FindIPLoc",
		value:param2,
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
   },false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.LocID + ">" + n.LocDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]=="true"){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
	}
};
function LoadRecLoc(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.DocConfig", 
		QueryName:"FindDep",
		value:param2//,
		//HospId:$HUI.combogrid('#_HospList').getValue()
    },false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
	    selectlist=selectlist+"^"+n.selected
        vlist += "<option value=" + n.CTLOCRowID + ">" + n.CTLOCDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
};
function LoadCatList(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.OneAndOutOrderRecLoc", 
		QueryName:"FindCatList",
		value:param2,
		HospId:$HUI.combogrid('#_HospList').getValue()
    },false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]=="true"){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
	}
							
};
function OrdPriorChange()
{
	$("#List_MedItemCat")[0].selectedIndex=-1;
	$("#List_LocNoInOutOrderCF").empty();
	$("#List_DefaultRecLoc").empty();
	$("#List_RecLoc").empty();
	InitRecLoc();
	LoadRecLoc("List_RecLoc","");
};