/**
* @author songchunli
* HISUI 中医护理计划-病种新增/修改主js
*/
var PageLogicObj={
	m_TCMDiseaseRecTableGrid:"",
	m_SymptomMethodTableGrid:"",
	m_SymptomTechTableGrid:"",
	m_SelTCMEffectTableIndex:"",
	m_DelTCMComSatisTechRecArr:[],
	m_NurseSignChg:0
}
$(function(){
	Init();
});
$(window).load(function() {
	$("#loading").hide();
})
function Init(){
	// 初始化护理效果评价
	InitTCMEffectTable();
	// 初始化护理依从性及满意度评价表格
	InitTCMComSatisTable();
	InitDivStatus();
	// 初始化页面默认数据
	SetPageDefaultData();
	InitEvent();
}
function InitEvent(){
	$("#ESRPreTreatScore").bind('keyup', function (e) {
		ESRTreatScoreChange($(e.target).val(),$("#ESRPostTreatScore").numberbox("getValue"));
	});
	$("#ESRPreTreatScore").bind('change', function (e) {
		ESRTreatScoreChange($(e.target).val(),$("#ESRPostTreatScore").numberbox("getValue"));
	});
	$("#ESRPostTreatScore").bind('keyup', function (e) {
		ESRTreatScoreChange($("#ESRPreTreatScore").numberbox("getValue"),$(e.target).val());
	});
	$("#ESRPostTreatScore").bind('change', function (e) {
		ESRTreatScoreChange($("#ESRPreTreatScore").numberbox("getValue"),$(e.target).val());
	});
	$("#BDiseaseSave").click(DiseaseSaveHandle);
	$("#CSRPrimaryNurse,#CSRSuperNurse,#FERNurse,#FERSuperNurse").bind("keyup",function(e){
		var key=websys_getKey(e);
		if (key==13) {
			if (PageLogicObj.m_NurseSignChg ==1){
				PageLogicObj.m_NurseSignChg=0;
				return false;
			}
			NurseSignatureChange(e);
		}
	}).bind('change', function (e) {
		if (PageLogicObj.m_NurseSignChg ==1){
			PageLogicObj.m_NurseSignChg=0;
			return false;
		}
		NurseSignatureChange(e);
	});
}
function InitDivStatus(){
	$("#ADL-div,#Death-div,#DISRBoneJointDisease-div,#DISRTreatMethod-div").hide();
	$("#DISRADLScore").val("");
	$("input[name='Death']").radio("uncheck");
	$("input[name='DISRBoneJointDisease']").checkbox("uncheck");
	$("div[id*='DISRTreatMethod']").remove();
	//$("input[name='DISRTreatMethod']").radio("uncheck");
}
function SetPageDefaultData(){
	$("#DISRDate,#FERCompleteDate").datebox("setValue",ServerObj.CurrentDate);
	$("#DISRTime,#FERCompleteTime").timespinner("setValue",GetCurTime());
	$("#FERTechnical").combobox("setValue","");
	$.cm({
	    ClassName : "Nur.TCM.Service.NursingPlan.NursePlanMake",
	    MethodName : "GetTCMDiseaseJson",
	    DisRecId : ServerObj.DisRecId,
	    EpisodeID : ServerObj.EpisodeID
	},function(dataJson){
		var itemData=dataJson["ItemData"];
		var gridData=dataJson["GridData"];
		if ((itemData.PatTCMDDiseaseInfo)&&(itemData.PatTCMDDiseaseInfo.DISRDiseaseDR)){
			DISRDiseaseSelect({"value":itemData.PatTCMDDiseaseInfo.DISRDiseaseDR});
		}
		for (item1 in itemData){
			var oneDataJson=itemData[item1];
			for (item2 in oneDataJson){
				if ($("input[name='"+item2+"']").length >0){
					if (oneDataJson[item2]){
						var _$input=$("input[name='"+item2+"']");
						for (i=0;i<_$input.length;i++){
							if ($(_$input[i]).hasClass('radio-f')){
								var inputVal=$(_$input[i]).attr("value");
								if (oneDataJson[item2]==inputVal){
									$(_$input[i]).radio("check");
								}
							}else if($(_$input[i]).hasClass('checkbox-f')){
								var inputVal=$(_$input[i]).attr("value");
								if (("^"+oneDataJson[item2]+"^").indexOf("^"+inputVal+"^")>=0){
									$(_$input[i]).checkbox("check");
								}
							}
						}
					}	
				}else{
					var _$id=$("#"+item2);
					if (_$id.length > 0){
						
						if (_$id.hasClass('datebox-f')){
							_$id.datebox("setValue",oneDataJson[item2]);
						}else if(_$id.hasClass('timespinner-f')){
							_$id.timespinner("setValue",oneDataJson[item2]);
						}else if (_$id.hasClass('combobox-f')){
							_$id.combobox("setValue",oneDataJson[item2]);
							if (item2=="DISRDiseaseDR"){
								if ($.hisui.indexOfArray(_$id.combobox("getData"),"value",oneDataJson[item2])<0){
									_$id.combobox("setText",oneDataJson[item2+"Desc"]);
								}
							}
						}else{
							if (("^CSRPrimaryNurse^CSRSuperNurse^FERNurse^FERSuperNurse^").indexOf("^"+item2+"^")>=0){
								_$id.attr("signaturefullval",oneDataJson[item2]);
								_$id.val(oneDataJson[item2+"Desc"]);
							}else{
								_$id.val(oneDataJson[item2]);
							}
							
						}
					}
				}
			}
		}
		for (tableId in gridData){
			$("#"+tableId).datagrid("loadData",gridData[tableId]);
		}
		if (ServerObj.DisRecId!=""){
			$("#DISRDiseaseDR").combobox("disable");
			$("#DISRDate").datebox("disable");
			$("#DISRTime").timespinner("disable");
		}
	});
}
function InitTCMEffectTable(){
	var ToolBar = [{
        text: '新增',
        iconCls: '	icon-add',
        handler: function() {
	        PageLogicObj.m_SelTCMEffectTableIndex="";
	        ShowTCMEffectWin("Add");
        }
    },{
        text: '修改',
        iconCls: 'icon-edit',
        handler: function() {
           var sel=$('#TCMEffectTable').datagrid("getSelected");
           if (!sel){
	           $.messager.popover({msg:'请选择护理效果评价记录！',type:'error'});
	           return false;
	       }
	       PageLogicObj.m_SelTCMEffectTableIndex=$('#TCMEffectTable').datagrid("getRowIndex",sel);
	       ShowTCMEffectWin("Update");
        }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {
	       DelTCMEffectData();
        }
    }];
	$("#TCMEffectTable").datagrid({
		border:false,
		nowrap:false,
		toolbar :ToolBar,
		idField:"Index",
		singleSelect:true,
		columns:[
			[
				{title:'主要症状',field:"ESRSymptomDesc",halign:'center',rowspan:2,width:160,wordBreak:"break-all"}	
				,{title:'主要辩证施护方法',field:"EffectMethodRecDescStr",halign:'center',rowspan:2,width:210,wordBreak:"break-all"}	
				,{title:'中医护理技术',field:"EffectTechRecDescStr",halign:'center',rowspan:2,width:240,wordBreak:"break-all"}
				,{title:'护理效果',halign:'center',colspan:4}
			],[
				{title:'治疗前',field:'ESRPreTreatScore',halign:'center',align:"center",width:75},
				{title:'治疗后',field:'ESRPostTreatScore',halign:'center',align:"center",width:75},
				{title:'得分',field:'ESRLastTreatScore',halign:'center',align:"center",width:75},
				{title:'效果评价',field:'ESREffectSymptomResultDesc',align:"center",halign:'center',width:75},
				{field:'ESREffectSymptomResult',hidden:true},
				{field:'ESRSymptomDR',hidden:true},
				{field:'EffectMainRecId',hidden:true},
				{field:'EffectMethodDescArr',hidden:true},
				{field:'EffectMethodIdArr',hidden:true},
				{field:'EffectMethodRecIdArr',hidden:true},
				{field:'EffectTechDescArr',hidden:true},
				{field:'EffectTechIdArr',hidden:true},
				{field:'EffectTechRecIdArr',hidden:true},
				{field:'ESRPreTreatDate',hidden:true},
				{field:'ESRPostTreatDate',hidden:true}
			]
		]
	});
}
function DelTCMEffectData(){
   var sel=$('#TCMEffectTable').datagrid("getSelected");
   if (!sel){
       $.messager.popover({msg:'请选择需要删除的护理效果评价记录！',type:'error'});
       return false;
   }
   var delIndex=$('#TCMEffectTable').datagrid("getRowIndex",sel);
   var EffectSymptomRecordId=sel["EffectSymptomRecordId"];
   var ETRTechDRObj={},ETRTechDescObj={};
   var rows=$('#TCMEffectTable').datagrid("getRows");
   for (var i=0;i<rows.length;i++){
		if (i == delIndex) continue;
		var EffectTechArr=rows[i]["EffectTechArr"];
		for (var j=0;j<EffectTechArr.length;j++){
			var ETRTechDR=EffectTechArr[j]["ETRTechDR"];
			var ETRTechDesc=EffectTechArr[j]["ETRTechDesc"];
			var DelEffectTechFlag=EffectTechArr[j]["DelEffectTechFlag"] || "";
			if (DelEffectTechFlag =="Y") continue;
			/*if (ETRTechDR){
				ETRTechDRObj[ETRTechDR]=ETRTechDesc;
			}else{
				ETRTechDescObj[ETRTechDesc]=ETRTechDesc;
			}*/
			ETRTechDescObj[ETRTechDesc]=ETRTechDesc;
		}
	}
	// 获取护理依从性及满意度评价表中需要删除的记录
	var TCMComSatisTechRecArr=[];
	var delTCMComSatisTableIndexArr=[];
	var rows=$('#TCMComSatisTable').datagrid("getRows");
	for (var i=rows.length-2;i>=0;i--){
		var CSTRTechDR=rows[i]["CSTRTechDR"];
		var CSTRTechDesc=rows[i]["CSTRTechDesc"];
		var TCMComSatisTechRecId=rows[i]["TCMComSatisTechRecId"];
		var DelRowFlag="N";
		/*if (CSTRTechDR){
			if (!ETRTechDRObj[CSTRTechDR]) DelRowFlag="Y";
		}else{
			if (!ETRTechDescObj[CSTRTechDesc]) DelRowFlag="Y";
		}*/
		if (!ETRTechDescObj[CSTRTechDesc]) DelRowFlag="Y";
		if (DelRowFlag=="Y"){
			if (TCMComSatisTechRecId){
				TCMComSatisTechRecArr.push(TCMComSatisTechRecId);
			}
			delTCMComSatisTableIndexArr.push(i);
		}
	}
	if ((EffectSymptomRecordId!="")||(TCMComSatisTechRecArr.length>0)){
		var rtn=$.cm({
			ClassName:"Nur.TCM.Service.NursingPlan.NursePlanMake",
			MethodName:"DelEffectSymptomRec",
			EffectSymptomRecordId:EffectSymptomRecordId,
			TCMComSatisTechRecArr:JSON.stringify(TCMComSatisTechRecArr)
		},false)
		if (rtn<0){
			$.messager.popover({msg: '删除失败！',type: 'error'});
			return false;
		}
	}
	$('#TCMEffectTable').datagrid("deleteRow",delIndex);
	for (var i=0;i<delTCMComSatisTableIndexArr.length;i++){
		$('#TCMComSatisTable').datagrid("deleteRow",i);	
	}
}
function ShowTCMEffectWin(OperType){
	var DISRDiseaseDR=$("#DISRDiseaseDR").combobox("getValue");
	if ((!DISRDiseaseDR)||((!ServerObj.DisRecId)&&($.hisui.indexOfArray($("#DISRDiseaseDR").combobox("getData"),"value",DISRDiseaseDR))<0)){
		$.messager.popover({msg: '请先选择病种！',type: 'error'});
		$("#DISRDiseaseDR").next('span').find('input').focus();
		return false;
	}
	$("#myEffectWin").show();
	var myWin = $HUI.dialog("#myEffectWin",{
		iconCls:(OperType=="Add")?"icon-w-add":"icon-w-edit",
		resizable:true,
		title:(OperType=="Add")?"新增":"修改",
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'保存',
			id:'save_btn',
			handler:function(){
				SaveEffectEditData();
			}
		},{
			text:'关闭',
			handler:function(){
				myWin.close();
			}
		}],
		onClose:function(){
			$("#ESRSymptomKW").empty();
			if (PageLogicObj.m_SymptomMethodTableGrid){
				$("#SymptomMethodTable,#SymptomTechTable").datagrid("uncheckAll").datagrid("loadData",{"rows":[],"total":0});
			}
		}
	});	
	if (PageLogicObj.m_SelTCMEffectTableIndex!==""){
		var rows=$('#TCMEffectTable').datagrid("getRows");
		var data=rows[PageLogicObj.m_SelTCMEffectTableIndex];
		var SymptomDR=data["ESRSymptomDR"];
		var SymptomDesc=data["ESRSymptomDesc"];
		$("#ESRSymptomKW").keywords({
			singleSelect:true,
	        onClick:function(v){
		        ESRSymptomKWSelChange(v.id);
		    },
	        items:[{
	            text:"主要症状",
	            type:"chapter",
	            items:[{"text":(SymptomDR=="")?"其他":SymptomDesc,"id":SymptomDR || "Other"}]
	        }]
	    }).keywords("select",SymptomDR || "Other");
	    //ESRSymptomKWSelChange(SymptomDR || "Other");
		if (!SymptomDR){
			$("#SymptomDesc_Other").val(SymptomDesc);
		}
		for (id in data){
			var _$id=$("#"+id);
			if (($("input[name='"+id+"']").length >0)&&(id!="Index")){
				$("input[name='"+id+"']").radio("uncheck");
				$("input[name='"+id+"'][value='"+data[id]+"']").radio("check");
			}else{
				if (_$id.length>0){
					if(_$id.hasClass('numberbox')){
						_$id.numberbox('setValue',data[id]);
					}else if(_$id.hasClass('datebox-f')){
						_$id.datebox('setValue',data[id]);
					}else{
						_$id.val(data[id]);
					}
				}
			}
		}
	}else{
		var itemArr=GetTCMKnowledgeJson(DISRDiseaseDR,"主要症状");
		var itemsArr=JSON.parse(JSON.stringify(itemArr).replace(/value/g, 'id'));
		itemsArr.push({"text":"其他","id":"Other"});
		var rows=$('#TCMEffectTable').datagrid("getRows");
		for (var i=itemsArr.length-1;i>=0;i--){
			var index=$.hisui.indexOfArray(rows,"ESRSymptomDR",itemsArr[i]["id"]);
			if (index>=0){
                itemsArr.splice(index,1);
			}
		}
		$("#ESRSymptomKW").keywords({
			singleSelect:true,
	        onClick:function(v){
		        ESRSymptomKWSelChange(v.id);
		    },
	        items:[{
	            text:"主要症状",
	            type:"chapter",
	            items:itemsArr
	        }]
	    });
		var column=$("#TCMEffectTable").datagrid("getColumnFields");
		for (index in column){
			var id=column[index];
			var _$id=$("#"+id);
			if ($("input[name='"+id+"']").length >0){
				$("input[name='"+id+"']").radio("uncheck");
			}else{
				if (_$id.length>0){
					if(_$id.hasClass('numberbox')){
						_$id.numberbox('setValue',"");
					}else if(_$id.hasClass('datebox-f')){
						_$id.datebox('setValue',ServerObj.CurrentDate);
					}else{
						_$id.val("");
					}
				}
			}
		}
	}
	ResizeEffectWinPanel();
}
function ResizeEffectWinPanel(){
	var _$panel=$("#SymptomMethodPanel,#SymptomTechPanel,#SymptomScorePanel");
	var KWHeight=$("#myEffectWin").height()-$("#ESRSymptomKW").parent().height();	
	var v=$("#ESRSymptomKW").keywords("getSelected");
	if (v.length >0){
		var ESRSymptomDR=v[0].id;
		if (ESRSymptomDR=="Other"){
			_$panel.parent().css("margin-top","5px");
			KWHeight = KWHeight -5;
		}else{
			_$panel.parent().css("margin-top","0");
		}
	}else{
		_$panel.parent().css("margin-top","0");
	}
	_$panel.panel('resize', {
	  	height:KWHeight - 51
	});
	if (PageLogicObj.m_SymptomMethodTableGrid){
		$("#SymptomMethodTable,#SymptomTechTable").datagrid("resize");
	}
}
function ESRSymptomKWSelChange(SymptomId){
	if (!PageLogicObj.m_SymptomMethodTableGrid){
		InitSymptomMethodTableGrid();
		InitSymptomTechTableGrid();	
	}else{
		PageLogicObj.m_SymptomMethodTableGrid.datagrid("uncheckAll");
		PageLogicObj.m_SymptomTechTableGrid.datagrid("uncheckAll");
	}
	var SymptomMethodTableGridData={"rows":[],"total":0},SymptomTechTableGridData={"rows":[],"total":0};
	if (PageLogicObj.m_SelTCMEffectTableIndex!==""){
		var rows=$('#TCMEffectTable').datagrid("getRows");
		var TCMEffectTableData=rows[PageLogicObj.m_SelTCMEffectTableIndex];
		var EffectMethodArr=$.extend(true, [], TCMEffectTableData["EffectMethodArr"]);
		var EffectTechArr=$.extend(true, [], TCMEffectTableData["EffectTechArr"]);
		if (SymptomId =="Other"){
			$("#ESRSymptomKW").append('<input class="textbox" id="SymptomDesc_Other" style="width:170px;margin:3px 0  0 5px;"/>');
			$("#SymptomDesc_Other").focus();
			var MethodArr=[];
			for (var i=0;i<5;i++){
				MethodArr.push({
					Index:i,
					MethodId:"",
					MethodDesc:(i<EffectMethodArr.length)?EffectMethodArr[i]["EMRMethodDesc"]:"",
					EffectMethodRecId:(i<EffectMethodArr.length)?EffectMethodArr[i]["EffectMethodRecId"]:"",
					SelEffectMethodFlag:((i<EffectMethodArr.length)&&(EffectMethodArr[i]["DelEffectMethodFlag"]!="Y"))?"Y":"N"
				});
			}
			SymptomMethodTableGridData={"rows":MethodArr,"total":MethodArr.length};
			
			var TechArr=[];
			for (var i=0;i<5;i++){
				TechArr.push({
					Index:i,
					TechId:"",
					TechDesc:(i<EffectTechArr.length)?EffectTechArr[i]["ETRTechDesc"]:"",
					TechCount:(i<EffectTechArr.length)?EffectTechArr[i]["ETRTechCount"]:"",
					TechDays:(i<EffectTechArr.length)?EffectTechArr[i]["ETRTechDays"]:"",
					EffectTechRecId:(i<EffectTechArr.length)?EffectTechArr[i]["EffectTechRecId"]:"",
					SelEffectTechFlag:((i<EffectTechArr.length)&&(EffectTechArr[i]["DelEffectTechFlag"]!="Y"))?"Y":"N"
				});
			}
			SymptomTechTableGridData={"rows":TechArr,"total":TechArr.length};
		}else{
			$("#SymptomDesc_Other").remove();
			var MethodJson=GetTCMKnowledgeJson(SymptomId,"主要辩证施护方法");
			var MethodArr=[];
			$.each(MethodJson, function(i, item) {
				var EffectMethodRecId="",SelEffectMethodFlag="N";
				var index=$.hisui.indexOfArray(EffectMethodArr,"EMRMethodDR",item["value"]);
				if (index>=0){
					EffectMethodRecId=EffectMethodArr[index]["EffectMethodRecId"];
					if (EffectMethodArr[index]["DelEffectMethodFlag"]!="Y"){
						SelEffectMethodFlag="Y";
					}
					EffectMethodArr.splice(index,1);
				}
				MethodArr.push({
					Index:i,
					MethodId:item["value"],
					MethodDesc:item["text"],
					EffectMethodRecId:EffectMethodRecId,
					SelEffectMethodFlag:SelEffectMethodFlag
				});
			});
			// 配置数据已删除此处仍需要显示
			var MaxLen=MethodArr.length;
			for (var i=0;i<EffectMethodArr.length;i++){
				MethodArr.push({
					Index:MaxLen,
					MethodId:EffectMethodArr[i]["EMRMethodDR"],
					MethodDesc:EffectMethodArr[i]["EMRMethodDesc"],
					EffectMethodRecId:EffectMethodArr[i]["EffectMethodRecId"],
					SelEffectMethodFlag:EffectMethodArr[i]["DelEffectMethodFlag"]=="Y"?"N":"Y"
				});
				MaxLen++;
			}
			SymptomMethodTableGridData={"rows":MethodArr,"total":MethodArr.length};
			
			var TechJson=GetTCMKnowledgeJson(SymptomId,"中医护理技术");
			var TechArr=[];
			$.each(TechJson, function(i, item) {
				var EffectTechRecId="",TechCount="",TechDays="",SelEffectTechFlag="";
				var index=$.hisui.indexOfArray(EffectTechArr,"ETRTechDR",item["value"]);
				if (index>=0){
					EffectTechRecId=EffectTechArr[index]["EffectTechRecId"];
					TechCount=EffectTechArr[index]["ETRTechCount"];
					TechDays=EffectTechArr[index]["ETRTechDays"];
					if (EffectTechArr[index]["DelEffectTechFlag"]!="Y"){
						SelEffectTechFlag="Y";
					}
					EffectTechArr.splice(index,1);
				}
				TechArr.push({
					Index:i,
					TechId:item["value"],
					TechDesc:item["text"],
					TechCount:TechCount,
					TechDays:TechDays,
					EffectTechRecId:EffectTechRecId,
					SelEffectTechFlag:SelEffectTechFlag
				});
			});
			var MaxLen=TechArr.length;
			for (var i=0;i<EffectTechArr.length;i++){
				TechArr.push({
					Index:MaxLen,
					TechId:EffectTechArr[i]["ETRTechDR"],
					TechDesc:EffectTechArr[i]["ETRTechDesc"],
					TechCount:EffectTechArr[i]["ETRTechCount"],
					TechDays:EffectTechArr[i]["ETRTechDays"],
					EffectTechRecId:EffectTechArr[i]["EffectTechRecId"],
					SelEffectTechFlag:EffectTechArr[i]["DelEffectTechFlag"]=="Y"?"N":"Y"
				});
				MaxLen++;
			}
			SymptomTechTableGridData={"rows":TechArr,"total":TechArr.length};
		}
	}else{
		if (SymptomId =="Other"){
			$("#ESRSymptomKW").append('<input class="textbox" id="SymptomDesc_Other" style="width:170px;margin:3px 0  0 5px;"/>');
			$("#SymptomDesc_Other").focus();
			var MethodArr=[];
			for (var i=0;i<5;i++){
				MethodArr.push({
					Index:i,
					MethodId:"",
					MethodDesc:"",
					EffectMethodRecId:""
				});
			}
			SymptomMethodTableGridData={"rows":MethodArr,"total":MethodArr.length};
			
			var TechArr=[];
			for (var i=0;i<5;i++){
				TechArr.push({
					Index:i,
					TechId:"",
					TechDesc:"",
					TechCount:"",
					TechDays:"",
					EffectTechRecId:""
				});
			}
			SymptomTechTableGridData={"rows":TechArr,"total":TechArr.length};
		}else{
			$("#SymptomDesc_Other").remove();
			var MethodJson=GetTCMKnowledgeJson(SymptomId,"主要辩证施护方法");
			var NewMethodArr=[];
			$.each(MethodJson, function(i, item) {
				NewMethodArr.push({
					Index:i,
					MethodId:item["value"],
					MethodDesc:item["text"],
					EffectMethodRecId:""
				});
			});
			SymptomMethodTableGridData={"rows":NewMethodArr,"total":NewMethodArr.length};
			var TechJson=GetTCMKnowledgeJson(SymptomId,"中医护理技术");
			var TechArr=[];
			$.each(TechJson, function(i, item) {
				TechArr.push({
					Index:i,
					TechId:item["value"],
					TechDesc:item["text"],
					TechCount:"",
					TechDays:"",
					EffectTechRecId:""
				});
			});
			SymptomTechTableGridData={"rows":TechArr,"total":TechArr.length};
		}
	}
	PageLogicObj.m_SymptomMethodTableGrid.datagrid("loadData",SymptomMethodTableGridData);
	PageLogicObj.m_SymptomTechTableGrid.datagrid("loadData",SymptomTechTableGridData);
	ResizeEffectWinPanel();
}
function InitSymptomMethodTableGrid(){
	PageLogicObj.m_SymptomMethodTableGrid=$("#SymptomMethodTable").datagrid({
		border:false,
		nowrap:false,
		height:$("#SymptomMethodPanel").height(),
		width:$("#SymptomMethodPanel").width(),
		idField:"Index",
		columns:[[
			{field:'Index',checkbox:true},
			{title:'主要辩证施护方法',field:'MethodDesc',width:190,wordBreak:"break-all",
				editor:{type:'text'}
			},
		]],
		onLoadSuccess:function(data){
			var v=$("#ESRSymptomKW").keywords("getSelected");
			if (v.length >0){
				var ESRSymptomDR=v[0].id;
				for (var i=0;i<data["rows"].length;i++){
					if (data["rows"][i].SelEffectMethodFlag=="Y"){
						$('#SymptomMethodTable').datagrid("selectRow",i);
					}
					if (ESRSymptomDR =="Other"){
						$("#SymptomMethodTable").datagrid("beginEdit",i);
					}					
				}
				//if (ESRSymptomDR=="Other") $("#SymptomTechTable").datagrid("hideColumn","Index");
			}
		}
	});
}
function InitSymptomTechTableGrid(){
	PageLogicObj.m_SymptomTechTableGrid=$("#SymptomTechTable").datagrid({
		border:false,
		nowrap:false,
		height:$("#SymptomTechPanel").height(),
		width:$("#SymptomTechPanel").width(),
		idField:"Index",
		fitColumns:true,
		columns:[[
			{field:'Index',checkbox:true},
			{title:'中医护理技术',field:'TechDesc',width:100,wordBreak:"break-all",
				editor:{type:'text'}
			},
			{title:'应用次数(次)',field:'TechCount',width:90,
				editor:{type:'numberbox'}
			},
			{title:'应用时间(天)',field:'TechDays',width:90,
				editor:{type:'numberbox'}
			}
		]],
		onCheck:function(rowIndex,rowData){
			$("#SymptomTechTable").datagrid("beginEdit",rowIndex);
			if (rowData["TechId"]){
				var ed = $('#SymptomTechTable').datagrid('getEditor', {index:rowIndex,field:'TechDesc'});
				$(ed.target).attr("disabled", true);
			}
		},
		onUncheck:function(rowIndex,rowData){
			if (rowData["EffectTechRecId"]){
				var eds=$("#SymptomTechTable").datagrid("getEditors",rowIndex);
				$('#SymptomTechTable').datagrid('updateRow',{
					index: rowIndex,
					row: {
						TechCount: rowData["TechCount"],
						TechDays: rowData["TechDays"]
					}
				}).datagrid("endEdit",rowIndex);				
			}else{
				var eds=$("#SymptomTechTable").datagrid("getEditors",rowIndex);
				for (var i=0;i<eds.length;i++){
					if (i==0){
						if (!rowData["TechId"]){
							$(eds[i].target).val("");
						}
					}else{
						$(eds[i].target).numberbox("setValue","");
					}
				}
			}
		},
		onLoadSuccess:function(data){
			var v=$("#ESRSymptomKW").keywords("getSelected");
			if (v.length >0){
				var ESRSymptomDR=v[0].id;
				for (var i=0;i<data["rows"].length;i++){
					if (data["rows"][i].SelEffectTechFlag=="Y"){
						$('#SymptomTechTable').datagrid("selectRow",i);
					}
					if (ESRSymptomDR =="Other"){
						$("#SymptomTechTable").datagrid("beginEdit",i);
					}				
				}
				//if (ESRSymptomDR=="Other") $("#SymptomTechTable").datagrid("hideColumn","Index");
			}
		}
	});
}
function SaveEffectEditData(){
	var SaveDataObj={};
	var reg = /^[+]{0,1}(\d+)$/; //大约等于0的正整数
	var v=$("#ESRSymptomKW").keywords("getSelected");
	if (v.length ==0){
		 $.messager.popover({msg:'请选择主要症状！',type:'error'});
	     return false;
	}
	var ESRSymptomDR=v[0].id;
	var ESRSymptomDesc=v[0].text;
	if (ESRSymptomDR =="Other"){
		ESRSymptomDR="";
		ESRSymptomDesc=$.trim($("#SymptomDesc_Other").val());
		if (!ESRSymptomDesc){
			$.messager.popover({msg:'主要症状为"其他"时，请输入自定义症状描述!',type:'error'});
			$("#SymptomDesc_Other").focus();
			return false;
		}
		var rows=$('#TCMEffectTable').datagrid("getRows");
		var index=$.hisui.indexOfArray(rows,"ESRSymptomDesc",ESRSymptomDesc);
		if (index>=0){
			if ((PageLogicObj.m_SelTCMEffectTableIndex=="")||((PageLogicObj.m_SelTCMEffectTableIndex!="")&&(index!=PageLogicObj.m_SelTCMEffectTableIndex))){
				$.messager.popover({msg:"自定义症状描述已存在！",type:'error'});
				$("#SymptomDesc_Other").focus();
				return false;
			}
		}
	}
	$.extend(SaveDataObj,{
		ESRSymptomDR:ESRSymptomDR,
		ESRSymptomDesc:ESRSymptomDesc
	});
	// 1. 获取 主要辩证施护方法表格数据
	var EffectMethodArr=[];
	var EffectMethodRecDescArr=[];
	var sels=$("#SymptomMethodTable").datagrid("getSelections");
	var rows=$("#SymptomMethodTable").datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		if (ESRSymptomDR ==""){
			var editors=$('#SymptomMethodTable').datagrid('getEditors',i);
			if (editors.length ==0) continue;
			var value=$.trim(editors[0].target.val());
			var EffectMethodRecId=rows[i]["EffectMethodRecId"];
			var DelEffectMethodFlag="N";
			if ((EffectMethodRecId)&&(!value)){
	     		DelEffectMethodFlag="Y"
			}
			if ((!EffectMethodRecId)&&(!value)) continue;
			EffectMethodArr.push({
				EMRMethodDR:"",
				EMRMethodDesc:value,
				EffectMethodRecId:EffectMethodRecId,
				DelEffectMethodFlag:DelEffectMethodFlag
			});
			if (value) {
				var index=$.hisui.indexOfArray(EffectMethodRecDescArr,value);
				if (index>=0){
					$.messager.popover({msg:"自定义主要辩证施护方法 "+value+" 重复！",type:'error'});
					return false;
				}
				EffectMethodRecDescArr.push(value);
			}
		}else{
			var DelEffectMethodFlag="N",selFlag="N";
			var EffectMethodRecId=rows[i]["EffectMethodRecId"];
			if (JSON.stringify(sels).indexOf(JSON.stringify(rows[i]))>=0){
				EffectMethodRecDescArr.push(rows[i]["MethodDesc"]);
				selFlag="Y";
			}else{
				var DelEffectMethodFlag="Y";
			}
			if ((!EffectMethodRecId)&&(selFlag=="N")) continue;
			EffectMethodArr.push({
				EMRMethodDR:rows[i]["MethodId"],
				EMRMethodDesc:rows[i]["MethodDesc"],
				EffectMethodRecId:EffectMethodRecId,
				DelEffectMethodFlag:DelEffectMethodFlag
			})
		}
	}
	if (EffectMethodRecDescArr.length==0){
		$.messager.popover({msg:'没有需要保存的主要辩证施护方法！',type:'error'});
	     return false;
	}
	$.extend(SaveDataObj,{
		EffectMethodArr:EffectMethodArr,
		EffectMethodRecDescStr:EffectMethodRecDescArr.join("、")
	});
	// 2. 获取 护理技术表格数据
	var NullValColumnArr=[];
	var NotValidateColumnArr=[];
	var reg1 = /^[0-9]*[1-9][0-9]*$/; //大于0的正整数
	var EffectTechArr=[];
	var EffectTechRecDescArr=[];
	var EffectTechDescArr=[];
	var sels=$("#SymptomTechTable").datagrid("getSelections");
	var rows=$("#SymptomTechTable").datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		if (ESRSymptomDR ==""){
			var editors=$('#SymptomTechTable').datagrid('getEditors',i);
			if (editors.length ==0) continue;
			var TechDesc=$.trim(editors[0].target.val());
			var TechCount=$.trim(editors[1].target.numberbox("getValue"));
			if ((TechDesc)&&(!TechCount)){
				NullValColumnArr.push("第"+(i+1)+"行应用次数");
			}else if ((TechCount)&&(!reg1.test(TechCount))){
				NotValidateColumnArr.push("第"+(i+1)+"行应用次数");
			}
			var TechDays=$.trim(editors[2].target.numberbox("getValue"));
			if ((TechDesc)&&(!TechDays)){
				NullValColumnArr.push("第"+(i+1)+"行应用时间");				
			}else if ((TechDays)&&(!reg1.test(TechDays))){
				NotValidateColumnArr.push("第"+(i+1)+"行应用时间");
			}
			var DelEffectTechFlag="N";
			var EffectTechRecId=rows[i]["EffectTechRecId"];
			if ((EffectTechRecId)&&(!TechDesc)){
	     		DelEffectTechFlag="Y";	
			}
			if ((!EffectTechRecId)&&(!TechDesc)) continue;
			EffectTechArr.push({
				ETRTechDR:"",
				ETRTechDesc:TechDesc,
				ETRTechCount:TechCount,
				ETRTechDays:TechDays,
				EffectTechRecId:EffectTechRecId,
				DelEffectTechFlag:DelEffectTechFlag
			})
			var index=$.hisui.indexOfArray(EffectTechDescArr,TechDesc);
			if (index>=0){
				$.messager.popover({msg:"自定义中医护理技术 "+TechDesc+" 重复！",type:'error'});
				return false;
			}
			EffectTechRecDescArr.push(TechDesc+": 应用次数"+TechCount+"次, 应用时间"+TechDays+"天");
			EffectTechDescArr.push(TechDesc);
		}else{
			var DelEffectTechFlag="N",selFlag="N";
			var EffectTechRecId=rows[i]["EffectTechRecId"];
			var ETRTechDR=rows[i]["TechId"];
			var ETRTechDesc=rows[i]["TechDesc"];
			var ETRTechCount=rows[i]["TechCount"];
			var ETRTechDays=rows[i]["TechDays"];
			if (JSON.stringify(sels).indexOf(JSON.stringify(rows[i]))>=0){
				var editors=$('#SymptomTechTable').datagrid('getEditors',i);
				var ETRTechCount=$.trim(editors[1].target.numberbox("getValue"));
				if (!ETRTechCount){
					NullValColumnArr.push("第"+(i+1)+"行应用次数");
				}else if ((ETRTechCount)&&(!reg1.test(ETRTechCount))){
					NotValidateColumnArr.push("第"+(i+1)+"行应用次数");
				}
				var ETRTechDays=$.trim(editors[2].target.numberbox("getValue"));
				if (!ETRTechDays){
					NullValColumnArr.push("第"+(i+1)+"行应用时间");				
				}else if ((ETRTechDays)&&(!reg1.test(ETRTechDays))){
					NotValidateColumnArr.push("第"+(i+1)+"行应用时间");
				}
				
				EffectTechRecDescArr.push(ETRTechDesc+": 应用次数"+ETRTechCount+"次, 应用时间"+ETRTechDays+"天");
				selFlag="Y";
			}else{
				var DelEffectTechFlag="Y";
			}
			if ((!EffectTechRecId)&&(selFlag=="N")) continue;			
			EffectTechArr.push({
				ETRTechDR:ETRTechDR,
				ETRTechDesc:ETRTechDesc,
				ETRTechCount:ETRTechCount,
				ETRTechDays:ETRTechDays,
				EffectTechRecId:EffectTechRecId,
				DelEffectTechFlag:DelEffectTechFlag
			})
		}
	}
	if (EffectTechRecDescArr.length==0){
		$.messager.popover({msg:'没有需要保存的中医护理技术！',type:'error'});
	    return false;
	}
	if (NullValColumnArr.length>0){
		$.messager.popover({msg:NullValColumnArr.join("、")+'不能为空!',type:'error'});
	    return false;
    }
    if (NotValidateColumnArr.length>0){
	    $.messager.popover({msg:NotValidateColumnArr.join("、")+'请输入大于0的正整数!',type:'error'});
	    return false;
	}
	$.extend(SaveDataObj,{
		EffectTechArr:EffectTechArr,
		EffectTechRecDescStr:EffectTechRecDescArr.join(";</br>"),
	});
	// 3.获取 效果评价-主要症状记录 Nur.TCM.EffectSymptomRecord 数据(保存症状评分和症状ID/自定义症状描述)
	var NotValidateArr=[];
	var _$input=$("#SymptomScorePanel tr td:not(.r-label) > input");
	for (var i=0;i<_$input.length;i++){
		var id=_$input[i].id;
		if (!id) continue;
		var _$id=$("#"+id);
		if(_$id.hasClass('radio-f')){
			var name=_$id.attr("name");
			var value=$("input[name='"+name+"']:checked").val();
			var id=name;
			if (value){
				SaveDataObj[name+"Desc"]=$("input[name='"+name+"']:checked")[0].id;
			}else{
				SaveDataObj[name+"Desc"]="";
			}
		}else if(_$id.hasClass('datebox-f')){
			var value=_$id.datebox("getValue");
		}else if(_$id.hasClass('numberbox')){
			var value=_$id.numberbox('getValue');
			if ((value)&&(!reg.test(value))){
				NotValidateArr.push($('label[for="' + id + '"]')[0].innerHTML);
			}
		}else{
			var value=$.trim(_$id.val());
		}
		SaveDataObj[id]=value;
	}
	if (NotValidateArr.length >0){
		$.messager.popover({msg:NotValidateArr.join("、")+"请输入大于等于0的正整数！",type:'error'});
	    return false;
	}
	//4.更新护理效果评价表格数据
	if (PageLogicObj.m_SelTCMEffectTableIndex!==""){
		$('#TCMEffectTable').datagrid('updateRow',{
			index: PageLogicObj.m_SelTCMEffectTableIndex,
			row: SaveDataObj
		});
	}else{
		$('#TCMEffectTable').datagrid('appendRow',SaveDataObj);
	}
	//5.更新护理依从性及满意度评价表格数据
	UpdateTCMComSatisTable();
	$("#myEffectWin").dialog("close");
}
function UpdateTCMComSatisTable(){
	var ComSatisTabIndex=0;
	var ETRTechDRObj={},ETRTechDescObj={};
	var rows=$('#TCMEffectTable').datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		var EffectTechArr=rows[i]["EffectTechArr"];
		for (var j=0;j<EffectTechArr.length;j++){
			var ETRTechDR=EffectTechArr[j]["ETRTechDR"];
			var ETRTechDesc=EffectTechArr[j]["ETRTechDesc"];
			var DelEffectTechFlag=EffectTechArr[j]["DelEffectTechFlag"] || "";
			if (DelEffectTechFlag =="Y") continue;
			/*if (ETRTechDR){
				ETRTechDRObj[ETRTechDR]=ETRTechDesc;
			}else{
				ETRTechDescObj[ETRTechDesc]=ETRTechDesc;
			}*/
			ETRTechDescObj[ETRTechDesc]=ETRTechDesc;
		}
	}
	// 获取护理依从性及满意度评价表中需要删除的记录
	var DelTCMComSatisTechRecArr=[]
	var rows=$('#TCMComSatisTable').datagrid("getRows");
	ComSatisTabIndex += rows.length;
	for (var i=rows.length-2;i>=0;i--){
		var CSTRTechDR=rows[i]["CSTRTechDR"];
		var CSTRTechDesc=rows[i]["CSTRTechDesc"];
		var TCMComSatisTechRecId=rows[i]["TCMComSatisTechRecId"];
		var DelRowFlag="N";
		/*if (CSTRTechDR){
			if (!ETRTechDRObj[CSTRTechDR]) DelRowFlag="Y";
		}else{
			if (!ETRTechDescObj[CSTRTechDesc]) DelRowFlag="Y";
		}*/
		if (!ETRTechDescObj[CSTRTechDesc]) DelRowFlag="Y";
		if (DelRowFlag=="Y"){
			if (TCMComSatisTechRecId){
				CSTR_DelFlag="Y"
				var delObj=$.extend(true, [], rows[i]);
				delObj["CSTRDelFlag"]="Y";
				DelTCMComSatisTechRecArr.push(delObj);
			}
			$('#TCMComSatisTable').datagrid("deleteRow",i);	
		}
	}
	ComSatisTabIndex += PageLogicObj.m_DelTCMComSatisTechRecArr.length;
	for (var i=0;i<PageLogicObj.m_DelTCMComSatisTechRecArr.length;i++){
		var CSTRTechDesc=PageLogicObj.m_DelTCMComSatisTechRecArr[i]["CSTRTechDesc"];
		var TCMComSatisTechRecId=PageLogicObj.m_DelTCMComSatisTechRecArr[i]["TCMComSatisTechRecId"];
		if (ETRTechDescObj[CSTRTechDesc]) {
			var newRowObj=$.extend(true, [], PageLogicObj.m_DelTCMComSatisTechRecArr[i]);
			newRowObj["CSTRDelFlag"]="";
			var rows=$('#TCMComSatisTable').datagrid("getRows");
			rows.splice(rows.length-1, 0, $.extend(true, [], newRowObj));
		}else{
			if (TCMComSatisTechRecId){
				DelTCMComSatisTechRecArr.push(PageLogicObj.m_DelTCMComSatisTechRecArr[i]);
			}
		}
	}
	PageLogicObj.m_DelTCMComSatisTechRecArr=DelTCMComSatisTechRecArr;
	
	var rows=$('#TCMComSatisTable').datagrid("getRows");
	//var newRows=$.extend(true, [], rows);
	for (item in ETRTechDRObj){
		var index=$.hisui.indexOfArray(rows,"CSTRTechDR",item);
		if (index<0){
			var newRowObj={
				CSTRComplyResult: "",
				CSTRComplyResultDesc: "部分依从",
				CSTRComplyResult_0: "",
				CSTRComplyResult_1: "",
				CSTRComplyResult_2: "",
				CSTRSatisfyResult: "",
				CSTRSatisfyResultDesc: "不满意",
				CSTRSatisfyResult_0: "",
				CSTRSatisfyResult_1: "",
				CSTRSatisfyResult_2: "",
				CSTRTechDR: "",
				CSTRTechDesc: ETRTechDRObj[item],
				Index: ComSatisTabIndex,
				TCMComSatisTechRecId: "",
				xm: "中医护理技术"
			}
			rows.splice(rows.length-1, 0, $.extend(true, [], newRowObj));
			ComSatisTabIndex++;
		}
	}
	for (item in ETRTechDescObj){
		var index=GetRepeatTechDescIndex(rows,item); //$.hisui.indexOfArray(rows,"CSTRTechDesc",item);
		if (index<0){
			var newRowObj={
				CSTRComplyResult: "",
				CSTRComplyResultDesc: "部分依从",
				CSTRComplyResult_0: "",
				CSTRComplyResult_1: "",
				CSTRComplyResult_2: "",
				CSTRSatisfyResult: "",
				CSTRSatisfyResultDesc: "不满意",
				CSTRSatisfyResult_0: "",
				CSTRSatisfyResult_1: "",
				CSTRSatisfyResult_2: "",
				CSTRTechDR: "",
				CSTRTechDesc: item,
				Index: ComSatisTabIndex,
				TCMComSatisTechRecId: "",
				xm: "中医护理技术"
			}
			rows.splice(rows.length-1, 0, newRowObj);
			ComSatisTabIndex++;
		}
	}
	$('#TCMComSatisTable').datagrid("loadData",rows);
}
function GetRepeatTechDescIndex(arr,TechDesc){
	var copyArr = $.extend(true, [], arr);
	var index=$.hisui.indexOfArray(copyArr,"CSTRTechDesc",TechDesc);
	if (index<0){
		return index;
	}else{
		if (arr["CSTRTechDR"]){
			copyArr.splice(copyArr,index);
			GetRepeatTechDescIndex(copyArr,TechDesc)
		}else{
			return index;
		}
	}
}
function InitTCMComSatisTable(){
	$("#TCMComSatisTable").datagrid({
		border:false,
		nowrap:false,
		idField:"Index",
		singleSelect:true,
		columns:[
			[
				{title:'评价项目',halign:'center',colspan:2}	
				,{title:'患者对护理依从性',halign:'center',colspan:3}	
				,{title:'患者对护理满意度',halign:'center',colspan:3}
			],[
				{title:'项目',field:'xm',halign:'center',width:100},
				{title:'子项',field:'CSTRTechDesc',halign:'center',width:350,wordBreak:"break-all"},
				{title:'依从',field:'CSTRComplyResult_0',halign:'center',width:75,align:"center",
					editor : {
                        type : 'icheckbox',
                        options : {
                            on : 'Y',
                            off : '',
                            onChecked:function(e,value){
	                            var index = getRowIndex(e.target);
	                            ChangeRowComplyResult(index,0);
	                            
	                        },
	                        onUnchecked:function(e,value){
		                        var index = getRowIndex(e.target);
	                            UpdateRowComplyResult(index,"");
	                        }
                        }
                    }
				},
				{title:'部分依从',field:'CSTRComplyResult_1',halign:'center',width:75,align:"center",
					editor : {
                        type : 'icheckbox',
                        options : {
                            on : 'Y',
                            off : '',
                            onChecked:function(e,value){
	                            var index = getRowIndex(e.target);
	                            ChangeRowComplyResult(index,1);
	                            
	                        },
	                        onUnchecked:function(e,value){
		                        var index = getRowIndex(e.target);
	                            UpdateRowComplyResult(index,"");
	                        }
                        }
                    }
				},
				{title:'不依从',field:'CSTRComplyResult_2',halign:'center',width:75,align:"center",
					editor : {
                        type : 'icheckbox',
                        options : {
                            on : 'Y',
                            off : '',
                            onChecked:function(e,value){
	                            var index = getRowIndex(e.target);
	                            ChangeRowComplyResult(index,2);
	                            
	                        },
	                        onUnchecked:function(e,value){
		                        var index = getRowIndex(e.target);
	                            UpdateRowComplyResult(index,"");
	                        }
                        }
                    }
				},
				{title:'满意',field:'CSTRSatisfyResult_0',halign:'center',width:75,align:"center",
					editor : {
                        type : 'icheckbox',
                        options : {
                            on : 'Y',
                            off : '',
                            onChecked:function(e,value){
	                            var index = getRowIndex(e.target);
	                            ChangeRowSatisfyResult(index,0);
	                            
	                        },
	                        onUnchecked:function(e,value){
		                        var index = getRowIndex(e.target);
	                            UpdateRowSatisfyResult(index,"");
	                        }
                        }
                    }
				},
				{title:'一般',field:'CSTRSatisfyResult_1',halign:'center',width:75,align:"center",
					editor : {
                        type : 'icheckbox',
                        options : {
                            on : 'Y',
                            off : '',
                            onChecked:function(e,value){
	                            var index = getRowIndex(e.target);
	                            ChangeRowSatisfyResult(index,1);
	                            
	                        },
	                        onUnchecked:function(e,value){
		                        var index = getRowIndex(e.target);
	                            UpdateRowSatisfyResult(index,"");
	                        }
                        }
                    }
				},
				{title:'不满意',field:'CSTRSatisfyResult_2',halign:'center',width:75,align:"center",
					editor : {
                        type : 'icheckbox',
                        options : {
                            on : 'Y',
                            off : '',
                            onChecked:function(e,value){
	                            var index = getRowIndex(e.target);
	                            ChangeRowSatisfyResult(index,2);
	                            
	                        },
	                        onUnchecked:function(e,value){
		                        var index = getRowIndex(e.target);
	                            UpdateRowSatisfyResult(index,"");
	                        }
                        }
                    }
				},
				//以下字段是保存时使用
				{field:'CSRSatisfyResult',hidden:true}, //健康指导满意度
				{field:'CSTRSatisfyResult',hidden:true}, //中医护理技术满意度
				{field:'CSTRComplyResult',hidden:true}, //中医护理技术依从性
				{field:'CSTRTechDR',hidden:true}, //中医护理技术ID
				//{field:'CSTRTechDesc',hidden:true}, //中医护理技术自定义描述
				{field:'TCMComSatisTechRecId',hidden:true}, //依从性及满意度-中医护理技术评价记录表ID
				{field:'ComSatisRecId',hidden:true}//依从性及满意度评价记录表(中医护理技术评价记录表父表)ID
			]
		],
		onLoadSuccess:function(data){
			if (data["rows"].length>2){
				$("#TCMComSatisTable").datagrid("mergeCells",{
					index:0,
					field:"xm",
					rowspan:(data["rows"].length-1)
				});
			}
			$("#TCMComSatisTable").datagrid("mergeCells",{
				index:((data["rows"].length-1)),
				field:"xm",
				colspan:2
			}).datagrid("mergeCells",{
				index:(data["rows"].length-1),
				field:"CSTRComplyResult_0",
				colspan:3
			});
			for (var i=0;i<data["rows"].length;i++){
				$("#TCMComSatisTable").datagrid("beginEdit",i);
			}
			var ed = $('#TCMComSatisTable').datagrid('getEditor', { index: (data["rows"].length-1), field: 'CSTRComplyResult_0' });
			$(ed.target).closest("div").hide();
			$(ed.target).closest("div").closest("td").css("background","#ddd").css("width","25.1%");
		}
	});
}
function DISRDiseaseSelect(rec){
	//根据病种获取对应的模板(待优化)
	InitDivStatus();
	var templStr=$.m({
	    ClassName : "Nur.TCM.Service.NursingPlan.NursePlanMake",
	    MethodName : "GetTCMDiseaseTempl",
	    DiseaseID : rec.value
	},false)
	if (templ!=""){
		for (var i=0;i<templStr.split("^").length;i++){
			var templ=templStr.split("^")[i];
			if (templ.indexOf("DISRTreatMethod")>=0){
				SetDISRTreatMethodDiv(templ);
			}else{
				$("#"+templ).show();
			}
		}
	}
	var html="";
	var dataJson=GetTCMKnowledgeJson(rec.value,"证候诊断");
	for (var i=0;i<dataJson.length;i++){
		html += "<input class='hisui-checkbox symptomdiagnos' type='checkbox' value='"+dataJson[i]["value"]+"' label='"+dataJson[i]["text"]+"' name='DISRSymptomDiagnos'/>"
	}
	$(".DISRSymptomDiagnos-div").html(html);
	$HUI.checkbox("input.symptomdiagnos",{});
}
function SetDISRTreatMethodDiv(templ){
	$("div[id*='DISRTreatMethod']").remove();
	var html="";
	if (templ=="DISRTreatMethod-div-1"){
		html += '<div id="DISRTreatMethod-div-1" style="display:inline-block;font-size:0;">'+
			'<label for="DISRTreatMethod" class="r-label">'+$g("治疗方法")+'</label>';
			for (var i=0;i<ServerObj.DISRTreatMethodJson.length;i++){
				var text=ServerObj.DISRTreatMethodJson[i]["text"].replace("治疗","");
				var value=ServerObj.DISRTreatMethodJson[i]["value"];
				if (text.indexOf("介入")>=0) continue
				html += '<input class="hisui-radio treatMethod-radio" type="radio" label="'+text+'" name="DISRTreatMethod" value="'+value+'">'
			}
		html += '</div>'
		$("#ADL-div").after(html);
	}else if(templ=="DISRTreatMethod-div-2"){
		html += '<div id="DISRTreatMethod-div-1" style="display:inline-block;font-size:0;">'+
			'<label for="DISRTreatMethod" class="r-label">'+$g("治疗方法")+'</label>';
			for (var i=0;i<ServerObj.DISRTreatMethodJson.length;i++){
				var text=ServerObj.DISRTreatMethodJson[i]["text"];
				var value=ServerObj.DISRTreatMethodJson[i]["value"];
				if (text.indexOf("介入")>=0) continue
				html += '<input class="hisui-radio treatMethod-radio" type="radio" label="'+text+'" name="DISRTreatMethod" value="'+value+'">'
			}
		html += '</div>'
		$("#Death-div").before(html);
	}else if(templ=="DISRTreatMethod-div-3"){
		html += '<div id="DISRTreatMethod-div-1" style="display:inline-block;font-size:0;">'+
			'<label for="DISRTreatMethod" class="r-label">'+$g("治疗方法")+'</label>';
			for (var i=0;i<ServerObj.DISRTreatMethodJson.length;i++){
				var text=ServerObj.DISRTreatMethodJson[i]["text"];
				var value=ServerObj.DISRTreatMethodJson[i]["value"];
				if (text.indexOf("手术")>=0) continue
				html += '<input class="hisui-radio treatMethod-radio" type="radio" label="'+text+'" name="DISRTreatMethod" value="'+value+'">'
			}
		html += '</div>'
		$("#Death-div").before(html);
	}else if(templ=="DISRTreatMethod-div-4"){
		html += '<div id="DISRTreatMethod-div-1" style="display:inline-block;font-size:0;">'+
			'<label for="DISRTreatMethod" class="r-label">'+$g("治疗方法")+'</label>';
			for (var i=0;i<ServerObj.DISRTreatMethodJson.length;i++){
				var text=ServerObj.DISRTreatMethodJson[i]["text"];
				var value=ServerObj.DISRTreatMethodJson[i]["value"];
				html += '<input class="hisui-radio treatMethod-radio" type="radio" label="'+text+'" name="DISRTreatMethod" value="'+value+'">'
			}
		html += '</div>'
		$("#Death-div").before(html);
	}
	$HUI.radio("input.treatMethod-radio",{});
	$("#"+templ).show();
}
function GetTCMKnowledgeJson(LastLevel,CurLevel){
	return $.cm({
	    ClassName : "Nur.TCM.Service.NursingPlan.NursePlanMake",
	    MethodName : "GetTCMKnowledgeJson",
	    LastLevel : LastLevel,
	    CurLevel :CurLevel
	},false)
	return dataJson;
}
function GetCurTime(){
   function p(s) {
	   return s < 10 ? '0' + s: s;
   }
   var myDate = new Date();
   var h=myDate.getHours();       //获取当前小时数(0-23)
   var m=myDate.getMinutes();     //获取当前分钟数(0-59)
   var s=myDate.getSeconds();  
   var nowTime=p(h)+':'+p(m)+":"+p(s);
   return nowTime;
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (dtseparator=="-") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (dtseparator=="/") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(dtseparator=="/"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function getRowIndex(target){
    var tr =  $(target).closest("tr.datagrid-row");
    return parseInt(tr.attr("datagrid-row-index"));               
}
function ChangeRowComplyResult(index,value){
	for (var i=0;i<3;i++){
		if (i==value) continue;
		var ed = $('#TCMComSatisTable').datagrid('getEditor', {index:index,field:"CSTRComplyResult_"+i});
		$(ed.target).checkbox("uncheck");
	}
	UpdateRowComplyResult(index,value);
}
function UpdateRowComplyResult(index,value){
	var rows =$('#TCMComSatisTable').datagrid("getRows");
	rows[index].CSTRComplyResult=value;
}
function ChangeRowSatisfyResult(index,value){
	for (var i=0;i<3;i++){
		if (i==value) continue;
		var ed = $('#TCMComSatisTable').datagrid('getEditor', {index:index,field:"CSTRSatisfyResult_"+i});
		$(ed.target).checkbox("uncheck");
	}
	UpdateRowSatisfyResult(index,value);
}
function UpdateRowSatisfyResult(index,value){
	var rows =$('#TCMComSatisTable').datagrid("getRows");
	if (index==(rows.length-1)){
		rows[index].CSRSatisfyResult=value;
	}else{
		rows[index].CSTRSatisfyResult=value;
	}
}
function ESRTreatScoreChange(PreScore,PostScore){
	var LastScore=(+PreScore)-(+PostScore);
	$("#ESRLastTreatScore").val(LastScore);
	if (LastScore>=3){
		var SymptomResult=0;
	}else if((LastScore<3)&&(LastScore>=2)){
		var SymptomResult=1;
	}else if((LastScore<2)&&(LastScore>0)){
		var SymptomResult=2;
	}else if(LastScore<=0){
		var SymptomResult=3;
	}
	$("input[name='ESREffectSymptomResult'][value='"+SymptomResult+"']").radio("check");
}
function DiseaseSaveHandle(){
	var SaveDataArr=[];
	//1.获取病种记录表保存信息
	var DiseaseObj={};
	var DISRDiseaseDR=$("#DISRDiseaseDR").combobox("getValue");
	if (!DISRDiseaseDR){
		$.messager.popover({msg:'请选择病种！',type:'error'});
		$('#DISRDiseaseDR').next('span').find('input').focus();
		return false;
	}else if ((!ServerObj.DisRecId)&&($.hisui.indexOfArray($("#DISRDiseaseDR").combobox("getData"),"value",DISRDiseaseDR)<0)){
		$.messager.popover({msg:'请在下拉框中选择病种！',type:'error'});
		$('#DISRDiseaseDR').next('span').find('input').focus();
		return false;
	}
	var DISRDate=$("#DISRDate").datebox("getValue");
	if (!DISRDate) {
		$.messager.popover({msg:'填写日期不能为空！',type:'error'});
		$('#DISRDate').next('span').find('input').focus();
		return false;
	}else{
		
	}
	var DISRTime=$("#DISRTime").timespinner("getValue");
	if (DISRTime==""){
		$.messager.popover({msg:"填写时间不能为空！",type:'error'});
		$('#DISRTime').focus();
		return false;
	}
	if (!IsValidTime(DISRTime)){
		$.messager.popover({msg:"填写时间格式不正确! 时:分:秒,如11:05:01",type:'error'});
		$('#DISRTime').next('span').find('input').focus();
		return false;
	}
	var DISRSymptomDiagnosArr=[];
	var _$SymptomDiagInput=$("input[name='DISRSymptomDiagnos']:checked");
	for (var i=0;i<_$SymptomDiagInput.length;i++){
		DISRSymptomDiagnosArr.push($(_$SymptomDiagInput[i]).val());
	}
	var DISRSymptomDiagnosDesc=$.trim($("#DISRSymptomDiagnosDesc").val());
	var DISRClinicalPathWay=$("input[name='DISRClinicalPathWay']:checked").val();
	var DISRADLScore="";
	if ($("#ADL-div").css("display") !='none'){
		DISRADLScore=$("#DISRADLScore").val();
	}
	var DISRTransInDate=$("#DISRTransInDate").datebox("getValue");
	var DISRTransOutDate=$("#DISRTransOutDate").datebox("getValue");
	var DISRTreatMethod=""
	if ($("#DISRTreatMethod-div").css("display") !='none'){
		DISRTreatMethod=$("input[name='DISRTreatMethod']:checked").val();
	}
	var DISRBoneJointDiseaseArr=[];
	if ($("#DISRBoneJointDisease-div").css("display") !='none'){
		var _$Input=$("input[name='DISRBoneJointDisease']:checked");
		for (var i=0;i<_$Input.length;i++){
			DISRBoneJointDiseaseArr.push($(_$Input[i]).val());
		}
	}
	$.extend(DiseaseObj,{
		UserID:session['LOGON.USERID'],
		EpisodeID:ServerObj.EpisodeID,
		DisRecId:ServerObj.DisRecId,
		DISRDiseaseDR:DISRDiseaseDR,
		DISRDate:DISRDate,
		DISRTime:DISRTime,
		DISRSymptomDiagnos:DISRSymptomDiagnosArr.join("^"),
		DISRSymptomDiagnosDesc:$.trim($("#DISRSymptomDiagnosDesc").val()),
		DISRDelFlag:"N",
		DISRLocDR:$("#DISRLocDR").val(),
		DISRWardDR:$("#DISRWardDR").val(),
		DISRClinicalPathWay:DISRClinicalPathWay,
		DISRADLScore:DISRADLScore,
		DISRTreatMethod:DISRTreatMethod,
		DISRDiagnosNumber:$("input[name='DISRDiagnosNumber']:checked").val(),
		DISRBoneJointDisease:DISRBoneJointDiseaseArr.join("^"),
		DISRTransInDate:DISRTransInDate,
		DISRTransOutDate:DISRTransOutDate
	});
	SaveDataArr.push(DiseaseObj);
	//2.获取护理效果评价保存数据
	var EffectMainRecordArr=[];
	var rows=$('#TCMEffectTable').datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		var EffectMainRecordObj={
			EffectMainRecId:rows[i]["EffectMainRecId"] //Nur.TCM.EffectMainRecord 效果评价记录主表ID
		}
		//2.1 获取主要症状记录表(Nur.TCM.EffectSymptomRecord)保存数据
		var EffectSymptomRecordObj={
			ESREffectSymptomResult:rows[i]["ESREffectSymptomResult"],
			ESRPreTreatDate: rows[i]["ESRPreTreatDate"],
			ESRPreTreatScore:rows[i]["ESRPreTreatScore"],
			ESRPostTreatDate:rows[i]["ESRPostTreatDate"],
			ESRPostTreatScore:rows[i]["ESRPostTreatScore"],
			ESRSymptomDR:rows[i]["ESRSymptomDR"],
			ESRSymptomDesc:rows[i]["ESRSymptomDesc"],
			ESREffectSymptomResult:rows[i]["ESREffectSymptomResult"],
			EffectSymptomRecordId:rows[i]["EffectSymptomRecordId"] //症状记录表ID
		};
		//2.2 获取主要辩证施护方法记录表(Nur.TCM.EffectMethodRecord)保存数据
		var EffectMethodRecordArr=[];
		var EffectMethodArr=rows[i]["EffectMethodArr"];
		for (var j=0;j<EffectMethodArr.length;j++){
			var EffectMethodRecordObj={
				EMREffectSymptomRecDR:rows[i]["EffectSymptomRecordId"], //症状记录表ID
				EMRMethodDesc:EffectMethodArr[j]["EMRMethodDesc"],
				EMRMethodDR:EffectMethodArr[j]["EMRMethodDR"],
				EffectMethodRecId:EffectMethodArr[j]["EffectMethodRecId"],
				EMRDelFlag:EffectMethodArr[j]["DelEffectMethodFlag"] || ""
			}
			EffectMethodRecordArr.push(EffectMethodRecordObj);
		}
		//2.3 获取中医护理技术记录表(Nur.TCM.EffectTechRecord)保存数据
		var EffectTechRecordArr=[];
		var EffectTechArr=rows[i]["EffectTechArr"];
		for (var j=0;j<EffectTechArr.length;j++){
			var EffectTechRecordObj={
				ETREffectSymptomRecDR:rows[i]["EffectSymptomRecordId"], //症状记录表ID
				ETRTechDR:EffectTechArr[j]["ETRTechDR"],
				ETRTechDesc:EffectTechArr[j]["ETRTechDesc"],
				ETRTechCount:EffectTechArr[j]["ETRTechCount"],
				ETRTechDays:EffectTechArr[j]["ETRTechDays"],
				EffectTechRecId:EffectTechArr[j]["EffectTechRecId"],
				ETRDelFlag:EffectTechArr[j]["DelEffectTechFlag"] || ""
			}
			EffectTechRecordArr.push(EffectTechRecordObj);
		}
		$.extend(EffectMainRecordObj,{
			EffectSymptomRecordData:EffectSymptomRecordObj,
			EffectMethodRecordData:EffectMethodRecordArr,
			EffectTechRecordData:EffectTechRecordArr
		});
		EffectMainRecordArr.push(EffectMainRecordObj);
	}
	SaveDataArr.push(EffectMainRecordArr);
	//3.获取依从性及满意度评价记录保存数据
	var ComSatisRecordRecordArr=[];
	var rows=$('#TCMComSatisTable').datagrid("getRows");
	//3.1 获取依从性及满意度评价记录表(Nur.TCM.ComSatisRecord)保存数据
	var CSRPrimaryNurse=$("#CSRPrimaryNurse").attr("signaturefullval") || "";
	var CSRSuperNurse=$("#CSRSuperNurse").attr("signaturefullval") || "";
	var ComSatisRecordObj={
		CSRSatisfyResult:rows[rows.length-1]["CSRSatisfyResult"],
		CSRPrimaryNurse:CSRPrimaryNurse,
		CSRSuperNurse:CSRSuperNurse,
		ComSatisRecId:rows[rows.length-1]["ComSatisRecId"]
	}
	ComSatisRecordRecordArr.push(ComSatisRecordObj);
	for (var i=0;i<rows.length-1;i++){
		// 3.2 获取依从性及满意度-中医护理技术评价记录表(Nur.TCM.ComSatisTechRecord)数据
		var EffectTechRecordObj={
			CSTRTechDR:"", //rows[i]["CSTRTechDR"],
			CSTRTechDesc:rows[i]["CSTRTechDesc"],
			CSTRComplyResult:rows[i]["CSTRComplyResult"],
			CSTRSatisfyResult:rows[i]["CSTRSatisfyResult"],
			ComSatisTechRecordId:rows[i]["TCMComSatisTechRecId"],
			ComSatisRecId:rows[rows.length-1]["ComSatisRecId"]
		}
		ComSatisRecordRecordArr.push(EffectTechRecordObj);
	}
	for (var i=0;i<PageLogicObj.m_DelTCMComSatisTechRecArr.length;i++){
		var EffectTechRecordObj={
			//CSTRTechDR:"",
			//CSTRTechDesc:PageLogicObj.m_DelTCMComSatisTechRecArr[i]["CSTRTechDesc"],
			//CSTRComplyResult:PageLogicObj.m_DelTCMComSatisTechRecArr[i]["CSTRComplyResult"],
			//CSTRSatisfyResult:PageLogicObj.m_DelTCMComSatisTechRecArr[i]["CSTRSatisfyResult"],
			ComSatisTechRecordId:PageLogicObj.m_DelTCMComSatisTechRecArr[i]["TCMComSatisTechRecId"],
			CSTRDelFlag:"Y",
			ComSatisRecId:rows[rows.length-1]["ComSatisRecId"]
		}
		ComSatisRecordRecordArr.push(EffectTechRecordObj);
	}
	//ComSatisRecordRecordArr=ComSatisRecordRecordArr.concat(PageLogicObj.m_DelTCMComSatisTechRecArr);
	SaveDataArr.push(ComSatisRecordRecordArr);
	//4.获取方案评价记录表(Nur.TCM.FinalEvalRecord)保存数据
	var FinalEvalRecordObj={};
	var FERNurse=$("#FERNurse").attr("signaturefullval") || "";
	var FERSuperNurse=$("#FERSuperNurse").attr("signaturefullval") || "";
	var FERCompleteDate=$("#FERCompleteDate").datebox("getValue");
	var FERCompleteTime=$("#FERCompleteTime").timespinner("getValue");
	if (!IsValidTime(FERCompleteTime)){
		$.messager.popover({msg:"完成时间格式不正确! 时:分:秒,如11:05:01",type:'error'});
		$('#FERCompleteTime').next('span').find('input').focus();
		return false;
	}
	$.extend(FinalEvalRecordObj,{
		FERUsefulnessResult:$("input[name='FERUsefulnessResult']:checked").val(),
		FERImproveSuggestion:$("#FERImproveSuggestion").val(),
		FERNurse:FERNurse,
		FERTechnical:$("#FERTechnical").combobox("getValue"),
		FERSuperNurse:FERSuperNurse,
		FERCompleteDate:FERCompleteDate,
		FERCompleteTime:FERCompleteTime,
		FinalEvalRecordId:$("#FinalEvalRecordId").val() || ""
	});
	SaveDataArr.push(FinalEvalRecordObj);
	$.cm({
		ClassName:"Nur.TCM.Service.NursingPlan.NursePlanMake",
		MethodName:"SaveTCMDisease",
		event:"SAVE",
		SaveDataArr:JSON.stringify(SaveDataArr)
	},function(rtn){
		if (rtn ==0) {
			PageLogicObj.m_DelTCMComSatisTechRecArr=[];
			$.messager.popover({msg: '保存成功！',type: 'success'});
			if (websys_showModal("options").CallBackFunc){
				websys_showModal("options").CallBackFunc();
			}
		}else{
			$.messager.popover({msg: '保存失败！',type: 'error'});
		}
	})
}
function IsValidTime(time){
	if (time.split(":").length==3){
		var TIME_FORMAT=/^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/;
	}else if(time.split(":").length==2){
		var TIME_FORMAT=/^(0\d{1}|1\d{1}|2[0-3]):([0-5]\d{1})$/;  
	}else{
		return false;
	}
	if(!TIME_FORMAT.test(time)) return false;
	return true;
}
function NurseSignatureChange(e){
	PageLogicObj.m_NurseSignChg=1;
	var id=e.target.id;
	var value=e.target.value;
	$.cm({
		ClassName:"Nur.TCM.Service.NursingPlan.NursePlanMake",
		MethodName:"getUserName",
		UserCode:value,
		DisplayFlag:1,
		HospitalID:session['LOGON.HOSPID']
	},function(rtn){
		if (rtn.status==-1){
			$.messager.popover({msg: rtn.msg,type: 'error'});
			$("#"+id).focus();
		}else{
			$("#"+id).val(rtn.data);
			$("#"+id).attr("signaturefullval",rtn.data+"*"+value.toUpperCase());
		}
	})
}