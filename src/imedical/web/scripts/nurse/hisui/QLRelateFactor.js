/**
* @author songchunli
* HISUI 问题非相关因素配置主js
* QLRelateFactor.js
*/
var PageLogicObj={
	m_tabQLRelateFactorEdit:"",
	m_Index:0,
	m_SelQLRowIdStr:"",
	iframeflag:"0", //2758853【护理计划配置】业务界面整合  是否是iframe 界面  1：是； 0：否
	selectQueRowID:""
}
$(function(){
	//2758853【护理计划配置】业务界面整合
	var iframeflag=""
	if (window.parent.window.PageLogicObj){
		iframeflag=window.parent.window.PageLogicObj.iframeflag
	}
	if(iframeflag=="1"){
		PageLogicObj.iframeflag=iframeflag
		Init();		   			// iframe 界面
	}
	else if ((iframeflag== "")||(iframeflag=="0")){
		InitHospList();			// 正常界面
	}
	InitEvent();
});
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabQLRelateFactorList").datagrid("reload");
	});
 	$("#BAddQLRelateFactor").click(AddQLRelateFactorClick);
 	$("#BSaveQLRelateFactor").click(SaveQLRelateFactorClick);
 	$("#SearchDesc").keydown(SearchDescOnKeyDown);
 	$("#QLRelateFactorDesc").keydown(QLRelateFactorDescOnKeyDown);
 	$("#BCancel").click(function(){
	 	$("#QLRelateFactorEditWin").window('close');
	});
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_QLRelateFactor");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#SearchDesc").val("");
		$("#tabQLRelateFactorList").datagrid("reload");
		InitQuestion();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	InitQLRelateFactorListDataGrid();
	InitTip();
}
function InitTip(){
	var _content = "相关因素由用户定义,非自动来源于评估、体征、医嘱、诊断";
	$("#tip_Btn").popover({
		trigger:'hover',
		content:_content,
		style:'inverse',
		width:'300',
	});
}
function ReloadQLRelateFactorListDataGrid(rowID){
	$("#QLRelateFactorEditWin").window('close');
	$('#tabQLRelateFactorList').datagrid('reload',{KeyWord:"",SearchQuestionDR:rowID,HospID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())})	
	PageLogicObj.selectQueRowID=rowID

}

function InitQLRelateFactorListDataGrid(){
	var ToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() {
	            //2758853【护理计划配置】业务界面整合
	            $('#Question').combobox('reload');
	            if (PageLogicObj.iframeflag=="1"){		            
		           	var qrow =$(window.parent.$("#iframeQuestion"))[0].contentWindow.$("#tabQuestionList").datagrid("getSelected");
					if (!qrow){
						$.messager.popover({msg:'请选择一个护理问题！',type:'error'});
						return false;
					}
					if (!PageLogicObj.m_tabQLRelateFactorEdit) {
						InitEditWindow();
						InitQLRelateFactorEditWin();
					}
					$('#Question').combobox("select",qrow.rowID);
					$("#QuestionType").val(qrow.careTypeT);
					$("#QuestionCode").val(qrow.queCode);
					/*
					var row = $("#tabQLRelateFactorList").datagrid('getRows')[0];					
					if(row){
						SetQLRelateFactorRowData(row);						
					}else{
						$('#Question').combobox("select",qrow.rowID);
					}
					*/
					ResetQLRelateFactorEditWin();
					$("#QLRelateFactorEditWin").window('open');
					$("#QLRelateFactorDesc").focus();	            
		        }
	            else{            
		            if (!PageLogicObj.m_tabQLRelateFactorEdit) {
			            InitEditWindow();
			            InitQLRelateFactorEditWin();
			        }		        
		            $("#QLRelateFactorEditWin").window('open');
		            $("#Question").next('span').find('input').focus();
	            }
            }
        },{
            text: '修改',
            iconCls: 'icon-write-order',
            handler: function() {
	            InitQuestion();
	            var selected = $("#tabQLRelateFactorList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("提示","请选择需要修改的记录！");
					return false;
				}
				if (!PageLogicObj.m_tabQLRelateFactorEdit) {
					InitEditWindow();
					InitQLRelateFactorEditWin();
				}
				SetQLRelateFactorRowData(selected);
				ResetQLRelateFactorEditWin();
				$("#QLRelateFactorEditWin").window('open');
				$("#QLRelateFactorDesc").focus();
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var selected = $("#tabQLRelateFactorList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("提示","请选择一条记录！");
					return false;
				}
				$.messager.confirm('提示','确认删除该非评估相关因素吗？',function(r){   
					if (r){   
						$.m({
							ClassName:"CF.NUR.NIS.QLRelateFactor",
							MethodName:"Delete",
							QLRowIDStr:selected.QLRowIDStr,
							user:session['LOGON.USERID']
						},function (rtn){
							if(rtn == 0) {
								$.messager.popover({msg:'删除成功！',type:'success'});
								$("#tabQLRelateFactorList").datagrid("reload");
							} else {
								$.messager.alert('提示','修改失败！错误代码: '+ rtn , "info");
								return false;
							}	
						})
					}   
				});  
            }
        },'-',{
	        id:'QLRelateFactorCopy',
	        text: '复制',
			iconCls: 'icon-copy',
			handler: function(){
				var selected = $("#tabQLRelateFactorList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("提示","请选择需要复制的记录！");
					return false;
				}
				if (!PageLogicObj.m_tabQLRelateFactorEdit) {
					InitEditWindow();
					InitQLRelateFactorEditWin();
				}
				SetQLRelateFactorRowData(selected);
				PageLogicObj.m_SelQLRowIdStr="";
				$("#QLRelateFactorEditWin").window('open');
				$("#QLRelateFactorDesc").focus();
			}
	}];
	var Columns=[[    
		{ field: 'QuestionCode',title:'问题编码',width:120},
		{ field: 'Question', title: '护理问题',width:250,					
		  styler: function(value,row,index){
			  if (row.haveStopQue ==1){
				  return 'background-color:#F16E57;color:#FFFFFF;';
			  }
		}},
		{ field: 'RelateFactorDisPlay', title: '非评估相关因素',width:250}
    ]];
	$('#tabQLRelateFactorList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true,
		idField:"QuestionDR",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuetionRelateFactor&QueryName=GetQLRelateFactorList",
		onBeforeLoad:function(param){
			try{
				var qRowId=window.parent.window.iframeQuestion.PageLogicObj.m_SelRowId;
			}catch(err){
				qRowId=""
			}
			$('#tabQLRelateFactorList').datagrid("unselectAll");
			//param = $.extend(param,{KeyWord:$("#SearchDesc").val(),HospID:$HUI.combogrid('#_HospList').getValue()});
			//2758853【护理计划配置】业务界面整合
			param = $.extend(param,{KeyWord:$("#SearchDesc").val(),SearchQuestionDR:qRowId,HospID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		},
		onLoadSuccess:function(){
			//2758853【护理计划配置】业务界面整合
			$("#QLRelateFactorCopy").hide();
		}
	})
}
function InitQLRelateFactorEditWin(){
	InitQuestion();
	InittabQLRelateFactorEdit();
}
function InitQuestion(){
	$('#Question').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryQuestion&rows=99999&ResultSetType=array",
		valueField:'rowID',
		textField:'shortName',
		mode: "remote",
		onSelect:function(rec){
			if (rec) {
				$("#QuestionType").val(rec.careTypeT);
				$("#QuestionCode").val(rec.queCode);
				$("#QLRelateFactorDesc").focus();
			}
		},
		onBeforeLoad:function(param){
             //param = $.extend(param,{keyword:param["q"],hospitalID:$HUI.combogrid('#_HospList').getValue(),statusIn:1});
             //2758853【护理计划配置】业务界面整合
             param = $.extend(param,{keyword:param["q"],hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),statusIn:1});
        },
        onChange:function(newValue, oldValue){
	        if (!newValue) {
		        $("#QuestionType,#QuestionCode").val("");
		    }
	    },
	    loadFilter:function(data){
		    for (var i=0;i<data.length;i++){
			    var parentID=data[i].parentID;
			    if (parentID !="-1"){
				    var parentIndex=$.hisui.indexOfArray(data,"rowID",parentID);
				    if (parentIndex >=0) {
					     data.splice(parentIndex,1);
					}
				}
			}
			data = data.sort(compare("rowID"));
		    return data;
		}
	});
}
function compare(property) {
	return function(firstobj, secondobj){
		var  firstValue = firstobj[property];
	    var  secondValue = secondobj[property];
	    if ((firstValue)&&(secondValue)) {
		    return firstValue - secondValue ; //升序
	    }else{
		    return true;
	    }
	}
}
function InittabQLRelateFactorEdit(){
	var Columns=[[    
		{ field: 'RelateFactor', title: '非评估相关因素',width:390},
		{ field: 'Index', title: '操作',width:45,
			formatter:function(value,row,index){
				var d = "<a href='#' onclick='DeleteRow(this)'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/></a>";
				return d;
			}
		}
    ]];
	$('#tabQLRelateFactorEdit').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, 
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : true, 
		idField:"Index",
		columns :Columns
	})
}
function DeleteRow(target){
	var tr = $(target).closest('tr.datagrid-row');
	var index=parseInt(tr.attr('datagrid-row-index'));
	var rows=$('#tabQLRelateFactorEdit').datagrid('getRows');
	var QLRowID=rows[index].QLRowID;
	if (QLRowID) {
		$.m({
			ClassName:"CF.NUR.NIS.QLRelateFactor",
			MethodName:"Delete",
			QLRowIDStr:QLRowID,
			user:session['LOGON.USERID']
		},false)
		var selected = $("#tabQLRelateFactorList").datagrid("getSelected");
		var QLRowIDStr=selected.QLRowIDStr;
		var NewQLRowIDArr=new Array();
		for (var i=0;i<QLRowIDStr.split("^").length;i++){
			if (QLRowIDStr.split("^")[i] ==QLRowID) continue;
			NewQLRowIDArr.push(QLRowIDStr.split("^")[i]);
		}
		$('#tabQLRelateFactorList').datagrid('updateRow',{
			index: $("#tabQLRelateFactorList").datagrid("getRowIndex",selected),
			row: {
				QLRowIDStr: NewQLRowIDArr.join("^")
			}
		});
	}
	$('#tabQLRelateFactorEdit').datagrid('deleteRow', index);
}
function AddQLRelateFactorClick(){
	var QLRelateFactorDesc=$.trim($("#QLRelateFactorDesc").val());
	if (!QLRelateFactorDesc) {
		$.messager.alert("提示","请输入非评估相关因素！","info",function(){
			$("#QLRelateFactorDesc").focus();
		})
		return false;
	}
	$('#tabQLRelateFactorEdit').datagrid('appendRow',{
		RelateFactor: QLRelateFactorDesc,
		Index:PageLogicObj.m_Index++
	});
	$("#QLRelateFactorDesc").val("").focus();
}
function InitEditWindow(){
    $("#QLRelateFactorEditWin" ).window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
		   ClearQLRelateFactorWinData();
	   }
	});
}
function SaveQLRelateFactorClick(){
	var QuestionDr=$("#Question").combobox('getValue');
	var index=$.hisui.indexOfArray($('#Question').combobox("getData"),"rowID",QuestionDr);
	if (index < 0) {
		$.messager.alert('提示','请选择护理问题！'); 
		return false;
	}
	var rows=$('#tabQLRelateFactorEdit').datagrid('getRows');
	if (rows.length ==0) {
		$.messager.alert('提示','请先维护非评估相关因素！'); 
		return false;
	}
	var RelateFactorArr=new Array();
	for (var i=0; i<rows.length; i++){
		var QLRowID=rows[i].QLRowID;
		if ((QLRowID)&&(PageLogicObj.m_SelQLRowIdStr)) continue;
		var RelateFactor=rows[i].RelateFactor;
		RelateFactorArr.push(RelateFactor);
	}
	$.m({
		ClassName:"CF.NUR.NIS.QLRelateFactor",
		MethodName:"SaveQLRelateFactor",
		QLRowIdStr:PageLogicObj.m_SelQLRowIdStr,
		QuestionDr:QuestionDr,
		RelateFactorStr:RelateFactorArr.join(String.fromCharCode(13)),
		user:session['LOGON.USERID'],
		//HospDr:$HUI.combogrid('#_HospList').getValue()
		//2758853【护理计划配置】业务界面整合
		HospDr:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
	},function (rtn){
		if(rtn == 0) {
			$.messager.popover({msg:'保存成功！',type:'success'});
			if (PageLogicObj.m_SelQLRowIdStr) {
				$("#QLRelateFactorEditWin").window('close');
			}else{
				ClearQLRelateFactorWinData();
				$("#Question").next('span').find('input').focus();
				//需求序号3144009
				$("#QLRelateFactorEditWin").window('close');
			}
			$("#tabQLRelateFactorList").datagrid("reload");
		} else {
			$.messager.alert('提示','保存失败！错误代码: '+ rtn , "info");
			return false;
		}	
	})
}
function ClearQLRelateFactorWinData(){
	$('#Question').combobox('select','');
	$("#QLRelateFactorDesc").val("");
	$HUI.datagrid("#tabQLRelateFactorEdit").loadData([]);
	PageLogicObj.m_SelQLRowIdStr="";
	PageLogicObj.m_Index=0;
}
function SearchDescOnKeyDown(e){
	var key=websys_getKey(e);
	if (key==13){
		$("#tabQLRelateFactorList").datagrid("reload");
	}
}
function QLRelateFactorDescOnKeyDown(e){
	var key=websys_getKey(e);
	if (key==13){
		AddQLRelateFactorClick();
	}
}
function SetQLRelateFactorRowData(row){

	PageLogicObj.m_SelQLRowIdStr=row.QLRowIDStr;
	$('#Question').combobox("setValue",row.QuestionDR);
	$("#QuestionType").val(row.QuestionCareTypeT);
	$("#QuestionCode").val(row.QuestionCode);
	var RelateFactorStr=row.RelateFactorStr;
	var QLRowIDStr=row.QLRowIDStr;
	for (var i=0;i<RelateFactorStr.split(String.fromCharCode(13)).length;i++){
		$('#tabQLRelateFactorEdit').datagrid('appendRow',{
			RelateFactor: RelateFactorStr.split(String.fromCharCode(13))[i],
			Index:PageLogicObj.m_Index++,
			QLRowID:QLRowIDStr.split("^")[i]
		});
	}

}
//2758853【护理计划配置】业务界面整合
function ResetQLRelateFactorEditWin(){
	var innerHeight = window.innerHeight;
	var innerWidth= window.innerWidth;
	if (PageLogicObj.iframeflag=="1"){
		$("#QLRelateFactorEditWin").css({
			width:innerWidth,
			height:innerHeight-38
			
		});
    }
}
