/**
* @author songchunli
* HISUI 护理计划通用配置主js
* NurseQuestionPlanComConfig.js
*/
var PageLogicObj = {
    m_MaxIndex: 0,
    editedrow: "null",
    _$ids:[],
    //QPCCExecuteNoteStr: ""
}

$(function () {
	$.extend($.fn.datagrid.defaults.editors, {
		checkbox: {//调用名称
	        init: function (container, options) {
		        //container 用于装载编辑器 options,提供编辑器初始参数
	            // 这里把一个 checkbox类型的输入控件添加到容器container中
	            var input = $('<input class="hisui-checkbox" type="checkbox" >').appendTo(container);
	            // 需要渲染成easyu提供的控件，需要时用传入options。
	            // 这里如果需要一个combobox，就可以 这样调用 input.combobox(options);
	            return input;
	         },
	         getValue: function (target) {
	            //datagrid 结束编辑模式，通过该方法返回编辑最终值
	            //这里如果用户勾选中checkbox返回Y否则返回N
	             return $(target).prop("checked") ? 'Y' : 'N';
	         },
	         setValue: function (target, value) {
	            //datagrid 进入编辑器模式，通过该方法为编辑赋值
	            //若用户传入Y则勾选编辑器
	             if (value=='Y')
	                 $(target).prop("checked", "checked")
	         },
	         resize: function (target, width) {
	            //列宽改变后调整编辑器宽度
	             var input = $(target);
	             if ($.boxModel == true) {
	                 input.width(width - (input.outerWidth() - input.width()));
	             } else {
	                 input.width(width);
	             }
	         }
	     }
	});
    InitHospList();  //--->init()
    InitStopEvaluationResultConfigTab();
    InitEvent();
    InitFormatKeywords();
    ResetDomSize(); 
    NurExecuteTrans();   
});
function InitEvent() {
    $("#BSave").click(SaveConfig);
    /*
    $("#QPCCOpenNurEvaluate_1").radio({
        onChecked: function (e, value) {
            $("#QPCCStopApplyToQuestion").checkbox("uncheck")
        }
    });    
    //2022.08.31 add
    $("#QPCCOpenNurEvaluate_2").radio({
        onChecked: function (e, value) {
            $("#QPCCStopApplyToQuestion").checkbox("check")
        }
    });    
    $("#QPCCStopApplyToQuestion").checkbox({
        onChecked: function (e, value) {
            $("#QPCCOpenNurEvaluate_2").radio("check")
        }
    });    
    // 需求 2922271
    $("#QPCCStopApplyToQuestion").checkbox({
        onUnchecked: function (e, value) {
            $("#QPCCOpenNurEvaluate_1").radio("check")
        }
    });
    */
    $("#QPCCUnUserFontColor,#QPCCStopFontColor").color({
        editable: false,
        width: 100
    });
    //2758853【护理计划配置】业务界面整合
    $("#QPCCLongTermInterventionColor,#QPCCTemporaryInterventionColor").color({
        editable: false,
        width: 100
    });
    // 显示隐藏 【默认天数】
    $("#QPCCOpenPlayDays_1").radio({
        onChecked: function (e, value) {
            $("#td_defaultdays").css({visibility:'visible'});
            
        }
    });
    $("#QPCCOpenPlayDays_2").radio({
        onChecked: function (e, value) {
            $("#td_defaultdays").css({visibility:'hidden'});
        }
    });
    //是否进行计划审核 显示隐藏【审核权限】

    $("#QPCCOpenNurPlanReview_1").radio({
        onChecked: function (e, value) {
            $("#td_NPRpermission").css({visibility:'visible'});
        }
    });
    $("#QPCCOpenNurPlanReview_2").radio({
        onChecked: function (e, value) {
            $("#td_NPRpermission").css({visibility:'hidden'});
            $("#QPCCOpenCancelNurPlanReview_2").radio("check");
            
        }
    });
    //是否允许撤销计划审核 显示隐藏【审核权限】
    $("#QPCCOpenCancelNurPlanReview_1").radio({
        onChecked: function (e, value) {
			$("#td_NPRCancelpermission").css({visibility:'visible'});
			 $("#QPCCOpenNurPlanReview_1").radio("check");            
        }
    });
    $("#QPCCOpenCancelNurPlanReview_2").radio({
        onChecked: function (e, value) {
            $("#td_NPRCancelpermission").css({visibility:'hidden'});            
        }
    });
    //是否允许撤销评价 显示隐藏【审核权限】
    $("#QPCCOpenCancelNurEvaluate_1").radio({
        onChecked: function (e, value) {
            $("#td_NPRCancelNurEvaPermission").css({visibility:'visible'});            
        }
    });
    $("#QPCCOpenCancelNurEvaluate_2").radio({
        onChecked: function (e, value) {
            $("#td_NPRCancelNurEvaPermission").css({visibility:'hidden'});            
        }
    });
    //护理计划单打印限制控制
    $("#QPCCNursePlanPrintStatusLimit_00").checkbox({
        onChecked: function (e, value) {
            $("#QPCCNursePlanPrintStatusLimit_01").checkbox("uncheck");
            $("#QPCCNursePlanPrintStatus_00").checkbox("check");
            $("#QPCCNursePlanPrintStatus_01").checkbox("check");
            $("#QPCCNursePlanPrintStatus_02").checkbox("check"); 
            $("#QPCCNursePlanPrintStatus_03").checkbox("check"); 
            $("#QPCCNursePlanPrintStatus_04").checkbox("uncheck");  
            $("#QPCCNursePlanPrintStatus_05").checkbox("uncheck");
            //护理计划单打印限制控制-->停止/评价配置     
            $("#QPCCOpenNurEvaluate_2").radio("check");	                   
        },
        onUnchecked: function (e, value) {
            $("#QPCCNursePlanPrintStatusLimit_01").checkbox("check");
            $("#QPCCNursePlanPrintStatus_00").checkbox("uncheck");
        }
    });
    $("#QPCCNursePlanPrintStatusLimit_01").checkbox({
        onChecked: function (e, value) {
            $("#QPCCNursePlanPrintStatusLimit_00").checkbox("uncheck");
            $("#QPCCNursePlanPrintStatus_00").checkbox("uncheck");
            $("#QPCCNursePlanPrintStatus_01").checkbox("uncheck");
            $("#QPCCNursePlanPrintStatus_02").checkbox("uncheck"); 
            $("#QPCCNursePlanPrintStatus_03").checkbox("uncheck"); 
            $("#QPCCNursePlanPrintStatus_04").checkbox("check"); 
            $("#QPCCNursePlanPrintStatus_05").checkbox("check"); 
            //护理计划单打印限制控制-->停止/评价配置    
            $("#QPCCOpenNurEvaluate_1").radio("check");	     
        },
        onUnchecked: function (e, value) {
            $("#QPCCNursePlanPrintStatusLimit_00").checkbox("check");
            $("#QPCCNursePlanPrintStatus_04").checkbox("uncheck");
        }
    });
    //停止/评价配置
    $("#QPCCOpenNurEvaluate_1").radio({
        onChecked: function (e, value) {	        
			$("#ApplyToQuestion").checkbox("check");			
			$("#ApplyToQuestion").attr("disabled", "");
			$("#ApplyToQuestionMeasure").checkbox("uncheck");
			$("#ApplyToQuestionMeasure").attr("disabled", "");
			//停止/评价配置-->护理计划单打印限制控制
			$("#QPCCNursePlanPrintStatusLimit_01").checkbox("check");
        }
    });
    $("#QPCCOpenNurEvaluate_2").radio({
        onChecked: function (e, value) {
	        $("#ApplyToQuestionMeasure").removeAttr("disabled");
			$("#ApplyToQuestion").checkbox("check");
			$("#ApplyToQuestion").attr("disabled", "");	
			//停止/评价配置-->护理计划单打印限制控制
			$("#QPCCNursePlanPrintStatusLimit_00").checkbox("check");
        }
    });
    //护嘱执行时转入病例格式
    $("#QPCCNurExecuteTransCommon_1").radio({
        onChecked: function (e, value) {
			$("#KW_NurTaskTransFormat").show();
            $("#QPCCNurTaskTransFormat").show();
           	if ($("#transtooltip").length>=1){
		        $("#transtooltip").hide();
		    }
        }
    });
    $("#QPCCNurExecuteTransCommon_2").radio({
        onChecked: function (e, value) {
	        var FormatHeight=$("#QPCCNurTaskTransFormat").height()+$("#KW_NurTaskTransFormat").height();
	        var FormatWidth=$("#QPCCNurTaskTransFormat").width();
	        
	        var html = '<textarea id="transtooltip" class="hisui-textbox textbox" style="width:'+FormatWidth+'px;height:'+FormatHeight+'px" >'+$g("护嘱执行时个性化转入病历格式取值:措施任务文书-文书配置-护理文书描述")+'</textarea>'
	        if ($("#transtooltip").length<=0){
		        $("#QPCCNurTaskTransFormat").after(html);
	        	$("#transtooltip").attr("disabled",true);
	        }else{
		        $("#transtooltip").show();
		    }
	        $("#KW_NurTaskTransFormat").hide();
            $("#QPCCNurTaskTransFormat").hide();

        }
    });    
	
   
    /*
	$("#QPCCNursePlanPrintStatus_00").checkbox({
        onUnchecked: function (e, value) {
            $("#QPCCNursePlanPrintStatusLimit_00").checkbox("uncheck");
        }
    });
   	$("#QPCCNursePlanPrintStatus_04").checkbox({
        onUnchecked: function (e, value) {
            $("#QPCCNursePlanPrintStatusLimit_01").checkbox("uncheck");
        }
    });
    */
    setTimeout(CascadeConfig,200);    
}
//获取停止/评价结果配置表_$id 并设置级联
function CascadeConfig(){
	PageLogicObj._$ids=[]
	var rows = $('#StopEvaluationResultConfigTab').datagrid("getRows");
	for (var i = 0; i < rows.length; i++) {
		var QPCCECode=rows[i].QPCCECode;
		//var _$id_01 = $("#QPCCEProcess_"+QPCCECode+"_01");
		//var _$id_02 = $("#QPCCEProcess_"+QPCCECode+"_02");		
		var _$id_1=$("#QPCCEOpenCopyQuestion_"+QPCCECode);
		var _$id_2=$("#QPCCEOpenFillOutcome_"+QPCCECode);
		var _$id_3=$("#QPCCEOpenReasonRequired_"+QPCCECode);
		//PageLogicObj._$ids.push(_$id_01,_$id_02,_$id_1,_$id_2,_$id_3);
		PageLogicObj._$ids.push(_$id_1,_$id_2,_$id_3);
		//样式 
		//if ((_$id_01.length > 0)&(_$id_02.length > 0)&(_$id_1.length > 0)&(_$id_2.length > 0)&(_$id_3.length > 0))
		if ((_$id_1.length > 0)&(_$id_2.length > 0)&(_$id_3.length > 0))
		{
			//_$id_01.checkbox();
		    //_$id_02.checkbox();
		    _$id_1.checkbox();
		    _$id_2.checkbox();
		    _$id_3.checkbox();
		}		
	}
	//级联显示设置
	PageLogicObj._$ids.forEach(function(_$id,index){
		/*
		if ((index%5==2)||(index%5==3)){
			if (!_$id.checkbox('getValue')){
				PageLogicObj._$ids[index+1].next().removeAttr("class");
				if (index%5==2) PageLogicObj._$ids[index+2].next().removeAttr("class");
			}
		}
		*/
		if ((index%3==0)||(index%3==1)){
			if (!_$id.checkbox('getValue')){
				PageLogicObj._$ids[index+1].next().removeAttr("class");
				if (index%3==0) PageLogicObj._$ids[index+2].next().removeAttr("class");
			}
		}
	});
	//设置级联
	PageLogicObj._$ids.forEach(function(_$id,index){
		/*
		if ((index%5==2)|| (index%5==3)){
			_$id.checkbox({
				onChecked: function (e, value) {
					var i = findindex(PageLogicObj._$ids,_$id)
					PageLogicObj._$ids[i+1].next().attr("class", "checkbox");
            		PageLogicObj._$ids[i+1].checkbox("uncheck");
				},
				onUnchecked:function (e, value) {
					var i = findindex(PageLogicObj._$ids,_$id)
		            PageLogicObj._$ids[i+1].next().removeAttr("class");
				},					
			});	
		}
		*/
		if ((index%3==0)||(index%3==1)){
			_$id.checkbox({
				onChecked: function (e, value) {
					var i = findindex(PageLogicObj._$ids,_$id)
					PageLogicObj._$ids[i+1].next().attr("class", "checkbox");
            		PageLogicObj._$ids[i+1].checkbox("uncheck");
				},
				onUnchecked:function (e, value) {
					var i = findindex(PageLogicObj._$ids,_$id)
		            PageLogicObj._$ids[i+1].next().removeAttr("class");
		            if(index%3==0){
			            PageLogicObj._$ids[i+2].next().removeAttr("class");
			        }

				},					
			});	
		}
		
	});
}
function findindex(arr, target) {
    var a = [];
    for(var i = 0; i < arr.length; i++){
        if(target == arr[i])
            a=i;
    }
    return a;
}

function InitFormatKeywords(){
	$("#KW_NurPlanTransFormat").keywords({
        onClick:function(v){
	        //console.log("点击->"+v.text);
	    },
        onUnselect:function(v){
	        //console.log("取消选择->"+v.text);
	        var str = "["+v.text+"]" 
	        deleteText($("#QPCCNurPlanTransFormat")[0],str)
	    },
        onSelect:function(v){
	        //console.log("选择->"+v.text);
	       	var str = "["+v.text+"]" 
	       	if ($("#QPCCNurPlanTransFormat").val().indexOf(str) == -1){
		       	insertText($("#QPCCNurPlanTransFormat")[0],str)
	       	}
	    },
		items:ServerObj.DataSourceJson,
	});
	$("#KW_NurTaskTransFormat").keywords({
        onClick:function(v){
	    },
        onUnselect:function(v){
	        var str = "["+v.text+"]" 
	        deleteText($("#QPCCNurTaskTransFormat")[0],str)
	    },
        onSelect:function(v){
	       	var str = "["+v.text+"]" 
	       	if ($("#QPCCNurTaskTransFormat").val().indexOf(str) == -1){
		       	insertText($("#QPCCNurTaskTransFormat")[0],str)
	       	}
	    },
		items:ServerObj.DataSourceJson
	});

	$("#KW_NurEvaluateTransFormat").keywords({
        onClick:function(v){
	    },
        onUnselect:function(v){
	        var str = "["+v.text+"]" 
	        deleteText($("#QPCCNurEvaluateTransFormat")[0],str)
	    },
        onSelect:function(v){
	       	var str = "["+v.text+"]" 
	       	if ($("#QPCCNurEvaluateTransFormat").val().indexOf(str) == -1){
		       	insertText($("#QPCCNurEvaluateTransFormat")[0],str)
	       	}	        
	    },
		items:ServerObj.DataSourceJson
	});
	$("#KW_QuestionStopTransFormat").keywords({
        onClick:function(v){
	    },
        onUnselect:function(v){
	        var str = "["+v.text+"]" 
	        deleteText($("#QPCCNurQuestionStopTransFormat")[0],str)
	    },
        onSelect:function(v){
	       	var str = "["+v.text+"]" 
	       	if ($("#QPCCNurQuestionStopTransFormat").val().indexOf(str) == -1){
		       	insertText($("#QPCCNurQuestionStopTransFormat")[0],str)
	       	}		    },
		items:ServerObj.DataSourceJson
	});
}


function insertText(obj,str) {
  if (document.selection) {
    var sel = document.selection.createRange();
    sel.text = str;
  } else if (typeof obj.selectionStart === 'number' && typeof obj.selectionEnd === 'number') {
    var startPos = obj.selectionStart,
        endPos = obj.selectionEnd,
        cursorPos = startPos,
        tmpStr = obj.value;
    obj.value = tmpStr.substring(0, startPos) + str + tmpStr.substring(endPos, tmpStr.length);
    cursorPos += str.length;
    obj.selectionStart = obj.selectionEnd = cursorPos;
  } else {
    obj.value += str;
  }
}

function deleteText(obj,str) {
  if (document.selection) {
	  //兼容性
	  var TextRange=document.body.createTextRange();
	  if (TextRange.findText(str)){
		  TextRange.select();
	      var sel = document.selection.createRange();
	      sel.text = "";
	 }   
  } else if (typeof obj.selectionStart === 'number' && typeof obj.selectionEnd === 'number') {
    var tmpStr = obj.value;
    obj.value = tmpStr.replace(str,""); 
  } else {
    obj.value = "";
  }
}

function InitHospList() {
    var hospComp = GenHospComp("Nur_IP_QPCommonConfig");
    hospComp.jdata.options.onSelect = function (e, t) {
        Init();
        $('#StopEvaluationResultConfigTab').datagrid('reload');
    }
    hospComp.jdata.options.onLoadSuccess = function (data) {
        Init();
    }
}
// 初始化护嘱限制执行时间下拉框
function InitInterventionLimit(){
    $("#QPCCInterventionLimit").combobox({
        data:ServerObj.InterventionLimitTypeJson,
        valueField:'value',
        textField:'text',
        mode: "local",
        /*
        onBeforeLoad:function(param){
            param = $.extend(param,{desc:param["q"],bizTable:"Nur_IP_EMRLinkItem",hospid:$HUI.combogrid('#_HospList').getValue()});
        },
        */
        formatter: function(row){
            var opts = $(this).combobox('options');
            return row[opts.textField];
        }
    })
}
function Init() {
	InitInterventionLimit();
    $.cm({
        ClassName: "CF.NUR.NIS.QPCommonConfig",
        MethodName: "getData",
        Hospital: $HUI.combogrid('#_HospList').getValue()
    }, function (ConfigJson) {
        for (var item in ConfigJson) {
            var value = ConfigJson[item];
            
            if ($("#" + item + "_1").length > 0) {
	            // 2758853【护理计划配置】业务界面整合
	            // $("#" + item + "_1") or $("#" + item + "_2")
                if (value == "Y") {
                    $("#" + item + "_1").radio('check');
                    if (item == "QPCCOpenPlayDays"){
	                    $("#td_defaultdays").css({visibility:'visible'});                   
	                }else if(item =="QPCCOpenNurPlanReview"){
		                $("#td_NPRpermission").css({visibility:'visible'});
		            }else if(item =="QPCCOpenCancelNurPlanReview"){
		                $("#td_NPRCancelpermission").css({visibility:'visible'});
		            }else if(item =="QPCCOpenCancelNurEvaluate"){
		                $("#td_NPRCancelNurEvaPermission").css({visibility:'visible'});
		            }
		            
                } else if(value == "N") {
                    $("#" + item + "_2").radio('check');
                    if (item == "QPCCOpenPlayDays"){
	                    $("#td_defaultdays").css({visibility:'hidden'});                    
	                }else if(item =="QPCCOpenNurPlanReview"){
		                $("#td_NPRpermission").css({visibility:'hidden'});
		            }else if(item =="QPCCOpenCancelNurPlanReview"){
		                $("#td_NPRCancelpermission").css({visibility:'hidden'});
		            }else if(item =="QPCCOpenCancelNurEvaluate"){
		                $("#td_NPRCancelNurEvaPermission").css({visibility:'hidden'});
		            }
                }else if(value == "Now") {
	                if (item == "QPCCInterventionShowTime"){
	                	$("#" + item + "_1").radio('check');
	                }
                }else if(value == "Exe") {
	                if (item == "QPCCInterventionShowTime"){
                    	$("#" + item + "_2").radio('check');
	                }
                }else if(value == "NotL") {
	                if (item == "QPCCDeleteRules"){
                    	$("#" + item + "_1").radio('check');
	                }
                }else if(value == "TaskF") {
	                if (item == "QPCCDeleteRules"){
                    	$("#" + item + "_2").radio('check');
	                }
                }else if(value == "EmrF") {
	                if (item == "QPCCDeleteRules"){
                    	$("#" + item + "_3").radio('check');
	                }
                }else if(value == "THIS") {
	                if (item == "QPCCNurPlanTransPrintRule"){
                    	$("#" + item + "_1").radio('check');
	                }
                }else if(value == "ALL") {
	                if (item == "QPCCNurPlanTransPrintRule"){
                    	$("#" + item + "_2").radio('check');
	                }
                }
            } else {
	            // $("#" + item) or $("#" + item + "_self") or $("#" + item + "_leader")or $("#" + item + "_00~05")
                if (item == "QPCCStopApplyToQuestionMeasure"){
	                if (value == "Y") {
		                $("#ApplyToQuestionMeasure").checkbox('check');
			        }
			    }                
                var _$id = $("#" + item);
                var _$id_self=$("#" + item+"_self");
		        var _$id_leader=$("#" + item+"_leader");
		        var _$id_0=$("#" + item+"_0"+"0");
                if (_$id.hasClass("hisui-checkbox")||_$id_self.hasClass("hisui-checkbox")||_$id_leader.hasClass("hisui-checkbox")||(_$id_0.hasClass("hisui-checkbox"))) {
	                //2758853【护理计划配置】业务界面整合
	                // Checkbox 多选系列
	                if ((item == "QPCCNurPlanPermission")||(item == "QPCCNurPlanReviewPermission")||
	                (item == "QPCCNPRCancelPermission")||(item == "QPCCNECancelPermission")){
		                // 审核权限系列		                
		                if (value == "") {
	                        _$id_self.checkbox('uncheck');
	                        _$id_leader.checkbox('uncheck');
	                    } else if(value == "S") {
		                    _$id_self.checkbox('check');
	                        _$id_leader.checkbox('uncheck');
	                    }else if(value == "L") {
		                    _$id_self.checkbox('uncheck');
	                        _$id_leader.checkbox('check');
	                    }else if(value == "S&L") {
		                    _$id_self.checkbox('check');
	                        _$id_leader.checkbox('check');
	                    }
	                }else if ((item == "QPCCNursePlanSearchStatus")||(item == "QPCCNurEvaluateSearchStatus")||(item == "QPCCNursePlanPatientStatus")){
		                // 状态系列 
						if (value.indexOf('^')>-1){
							var arr = value.split('^')
							for (i in arr){
								var _$id_code=$("#" + item + "_0"+arr[i].toString());
								if (_$id_code.length > 0) _$id_code.checkbox('check');
							}
						}	                
		            }else if ((item == "QPCCNursePlanPrintStatusLimit")||(item == "QPCCNursePlanPrintStatus")){
		                // 状态系列 
						if (value.indexOf('^')>-1){
							var arr = value.split('^')
							for (i in arr){
								var _$id_code=$("#" + item + "_"+arr[i].toString());
								if (_$id_code.length > 0) _$id_code.checkbox('check');
							}
						}	                
		            }
	                else{
		                // 是否系列		                
		                if (value == "Y") {
	                        _$id.radio('check');
	                    } else {
	                        _$id.radio('uncheck');
	                    }
		            }
                }
                /*
                else if (item == "QPCCQuestionEvaluateResult") {
                    InitQuestionEvaluateResultTab(value);
                }
                
                else if (item == "QPCCExecuteNote") {
                    InitExecuteNoteConfigTab(value);
                }
                */ 
                else if ((item == "QPCCUnUserFontColor") || (item == "QPCCStopFontColor") 
                || (item == "QPCCLongTermInterventionColor")||(item == "QPCCTemporaryInterventionColor")) {
	                // Color 颜色系列
                    _$id.color("setValue", value);
                }else if (item == "QPCCInterventionLimit") {
	                // Combobox下拉框系列
                    _$id.combobox("setValue", value);
                }  else {
	                // Textbox 文本框系列
                    _$id.val(value);
                	ServerObj.DataSourceJson.forEach(function(element, index) {
						if (value.indexOf("["+element.text+"]") != -1){
			                if (item == "QPCCNurPlanTransFormat"){
				                $("#KW_NurPlanTransFormat").keywords("switchById",element.id)
					        }else if(item == "QPCCNurTaskTransFormat"){
						        $("#KW_NurTaskTransFormat").keywords("switchById",element.id)						        
						    }else if(item == "QPCCNurEvaluateTransFormat"){
							    $("#KW_NurEvaluateTransFormat").keywords("switchById",element.id)							    
							}else if(item == "QPCCNurQuestionStopTransFormat"){
								$("#KW_QuestionStopTransFormat").keywords("switchById",element.id)								
							}							
						}
					})                    
                }
            }
        }
    });

}
function InitStopEvaluationResultConfigTab() {
    var ToolBar = [{
	    id:'RCAdd',
        text: '新增',
        iconCls: 'icon-add',
        handler: function () {
            if (PageLogicObj.editedrow == "null") {
                $('#StopEvaluationResultConfigTab').datagrid("appendRow", {
                    rowid:"",                    
                });
                var rows = $('#StopEvaluationResultConfigTab').datagrid("getRows");
                $('#StopEvaluationResultConfigTab').datagrid("beginEdit", rows.length - 1);
                var editors = $('#StopEvaluationResultConfigTab').datagrid('getEditors', rows.length - 1);
                $(editors[0].target).focus();
                PageLogicObj.editedrow = rows.length - 1;
                PageLogicObj.m_MaxIndex++;
            } else {
                $.messager.confirm("提示", "有正在编辑的行")
            }
        }
    }, {
	    id:'RCSave',
        text: '保存',
        iconCls: 'icon-save',
        //handler: SaveExecuteNoteConfig
        handler:SaveResultConfig

    }, {
	    id:'RCDelete',
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function () {
            var rows = $('#StopEvaluationResultConfigTab').datagrid("getSelections");
            if (rows.length > 0) {
	            var delrowids=[];
                for (var i = (rows.length - 1); i >= 0; i--) {
                    var index = $('#StopEvaluationResultConfigTab').datagrid("getRowIndex", rows[i]);
                    if (rows[i].rowid) delrowids.push(rows[i].rowid)
                    $('#StopEvaluationResultConfigTab').datagrid("deleteRow", index);
                }
                var rowids=delrowids.join('^');
			    $.m({
			        ClassName: "CF.NUR.NIS.QPCommonConfigExt",
			        MethodName: "DeleteQPCCE",
			        rowids: rowids,
			        Hospital: $HUI.combogrid('#_HospList').getValue()
			    }, function (rtn) {
			        if (rtn == 0) {
				        $('#StopEvaluationResultConfigTab').datagrid("reload");
				        setTimeout(CascadeConfig,200);
			            $.messager.popover({ msg: '删除成功！', type: 'success' });
			        } else {
			            //$.messager.popover({ msg: '停止/评价结果配置 保存失败！' + rtn, type: 'error' });
			            $.messager.popover({ msg: '停止/评价配置 删除失败！' , type: 'error' });
			        }
			    })
            } else {
                $.messager.popover({ msg: '请选择需要删除的行！', type: 'error' });
                return false;
            }
        }
    }];

    var Columns = [[
    	{
            field: 'rowid',checkbox: 'true',
        },
		{
            field: 'QPCCECode', title: '代码', width: 150,
            editor: { type: 'text', options: {} }
        },{
            //field: 'QPCCEDescription', title: '描述', width: 150,
            field: 'QPCCEDescription', title: '描述', width: 350,
            editor: { type: 'text', options: {} }
        },
        /*
        {
            field: 'QPCCEProcess', title: '适用流程', width: 200,
            editor: { type: 'combobox', options: {
	            data:ServerObj.QPCCEProcessTypeJson,
	            
	        } },
            formatter:function(value,row,index){
	            var id_01="QPCCEProcess_"+row.QPCCECode+"_01"
	            var id_02="QPCCEProcess_"+row.QPCCECode+"_02"
				if (value==""){		        	    
		        	return '<input class="hisui-checkbox" type="checkbox" label="评价" id="'+id_01+'">'+
					       '<input class="hisui-checkbox" type="checkbox" label="停止" id="'+id_02+'">'

		        }else if(value=="Evaluate&Stop"){
		        	return '<input class="hisui-checkbox" type="checkbox" checked="true" label="评价" id="'+id_01+'">'+
					       '<input class="hisui-checkbox" type="checkbox" checked="true" label="停止" id="'+id_02+'">'
			        
			    }else if(value=="Evaluate"){
		        	return '<input class="hisui-checkbox" type="checkbox" checked="true" label="评价" id="'+id_01+'">'+
					       '<input class="hisui-checkbox" type="checkbox" label="停止" id="'+id_02+'">'
				    
				}
			    else if(value=="Stop"){
		        	return '<input class="hisui-checkbox" type="checkbox" label="评价" id="'+id_01+'">'+
					       '<input class="hisui-checkbox" type="checkbox" checked="true" label="停止" id="'+id_02+'">'
				    
				}         
	        },

        },
        */
        {
            field: 'QPCCEOpenCopyQuestion', title: '是否复制问题', width: 150,
            editor: { type: 'checkbox', options: {} },
            formatter:function(value,row,index){
				if (value=="Y"){
	            	return '<input class="hisui-checkbox" type="checkbox" label="" checked="true" id="QPCCEOpenCopyQuestion_'+row.QPCCECode+'">'
					
				}
				else if(value=="N"){
	            	return '<input class="hisui-checkbox" type="checkbox" label="" id="QPCCEOpenCopyQuestion_'+row.QPCCECode+'">'
					
				}
						
	        }
        },{
            field: 'QPCCEOpenFillOutcome', title: '未复制问题是否填写转归', width: 200,
            editor: { type: 'checkbox', options: {}},
            formatter:function(value,row,index){
	            if (value=="Y"){
		            return '<input class="hisui-checkbox" type="checkbox" label="" checked="true" id="QPCCEOpenFillOutcome_'+row.QPCCECode+'">'
		        }
	            else if(value=="N"){
		            return '<input class="hisui-checkbox" type="checkbox" label="" id="QPCCEOpenFillOutcome_'+row.QPCCECode+'">'
		        }
	            
						
	        } 
        },{
            field: 'QPCCEOpenReasonRequired', title: '转归原因必填', width: 150,
            editor: { type: 'checkbox', options: {} },
            formatter:function(value,row,index){
	           	if (value=="Y"){	            
	           		return '<input class="hisui-checkbox" type="checkbox" label="" checked="true" id="QPCCEOpenReasonRequired_'+row.QPCCECode+'">'
				}
	            else if(value=="N"){	            
	            	return '<input class="hisui-checkbox" type="checkbox" label="" id="QPCCEOpenReasonRequired_'+row.QPCCECode+'">'
				}
						
	        }
        }
    ]];

    $('#StopEvaluationResultConfigTab').datagrid({
       	align:'center',
        columns: Columns,
        toolbar: ToolBar,   
        idField: "rowid",
        singleSelect: true,
        nowrap:false,  /*此处为false*/
        url : $URL+"?ClassName=CF.NUR.NIS.QPCommonConfigExt&QueryName=GetQPCCEData",
		onBeforeLoad:function(param){
			param = $.extend(param,{
				HospitalDR:$HUI.combogrid('#_HospList').getValue(),
				rows:999
			});				
		},
		onLoadSuccess:function(data){
			//隐藏，以后可配置化
			//$("#RCDelete").hide();
			//$("#RCAdd").hide();	
			
		}
    })
}

function SaveResultConfig(){
    var SaveDataArr = new Array() 
    var rows = $('#StopEvaluationResultConfigTab').datagrid("getRows");
    for (var i = 0; i < rows.length; i++) {		
		var rowid=rows[i].rowid
		if (rowid){
		    var QPCCECode=rows[i].QPCCECode
		    if (QPCCECode=="") QPCCECode=$('#QPCCECode').val()
		    var QPCCEDescription=rows[i].QPCCEDescription
		    var _$id_01 = $("#QPCCEProcess_"+rows[i].QPCCECode+"_01");
		    var _$id_02 = $("#QPCCEProcess_"+rows[i].QPCCECode+"_02");

			var QPCCEProcess= ""
			/*
		    if (_$id_01.checkbox('getValue')&& _$id_02.checkbox('getValue'))
			{
				QPCCEProcess="Evaluate&Stop"
			}
			else if (_$id_01.checkbox('getValue')&& !_$id_02.checkbox('getValue'))
			{
				QPCCEProcess="Evaluate"
			}
			else if (!_$id_01.checkbox('getValue')&& _$id_02.checkbox('getValue'))
			{
				QPCCEProcess="Stop"
			}
			*/
			var QPCCEOpenCopyQuestion=$("#QPCCEOpenCopyQuestion_"+rows[i].QPCCECode).checkbox('getValue') ? "Y" : "N";
		    var QPCCEOpenFillOutcome=$("#QPCCEOpenFillOutcome_"+rows[i].QPCCECode).checkbox('getValue') ? "Y" : "N";
		    var QPCCEOpenReasonRequired=$("#QPCCEOpenReasonRequired_"+rows[i].QPCCECode).checkbox('getValue') ? "Y" : "N";

		}else{
			var editors = $("#StopEvaluationResultConfigTab").datagrid('getEditors', i);
		    var QPCCECode=editors[0].target.val();
	    	var QPCCEDescription=editors[1].target.val();
	    	if(QPCCECode==""){
				$.messager.popover({msg: '代码不能为空!',type: 'error'});
				$(editors[0].target).focus();
				return false;
			};
			if(QPCCEDescription==""){
				$.messager.popover({msg: '描述不能为空!',type: 'error'});
				$(editors[1].target).focus();
				return false;
			};
			var QPCCEProcess= ""
			/*
			var QPCCEProcess=editors[2].target.combobox("getValue");
			var QPCCEOpenCopyQuestion=editors[3].target.checkbox("getValue") ? 'Y' : 'N';
			var QPCCEOpenFillOutcome=editors[4].target.checkbox("getValue") ? 'Y' : 'N';
			var QPCCEOpenReasonRequired=editors[5].target.checkbox("getValue") ? 'Y' : 'N';		
			*/
			var QPCCEOpenCopyQuestion=editors[2].target.checkbox("getValue") ? 'Y' : 'N';
			var QPCCEOpenFillOutcome=editors[3].target.checkbox("getValue") ? 'Y' : 'N';
			var QPCCEOpenReasonRequired=editors[4].target.checkbox("getValue") ? 'Y' : 'N';		
			
		}		    
	    var nodeobj={
		    rowid:rowid,
		    QPCCECode:QPCCECode,    
		    QPCCEDescription:QPCCEDescription,
		    QPCCEProcess:QPCCEProcess,
		    QPCCEOpenCopyQuestion:QPCCEOpenCopyQuestion,
		    QPCCEOpenFillOutcome:QPCCEOpenFillOutcome,
		    QPCCEOpenReasonRequired:QPCCEOpenReasonRequired	    
		}
		SaveDataArr.push(nodeobj);
    }
    var SaveDataJSON=JSON.stringify(SaveDataArr);
    $.m({
        ClassName: "CF.NUR.NIS.QPCommonConfigExt",
        MethodName: "SaveQPCCE",
        SaveDataJson: SaveDataJSON,
        Hospital: $HUI.combogrid('#_HospList').getValue()
    }, function (rtn) {
        if (rtn == 0) {
	        $('#StopEvaluationResultConfigTab').datagrid("reload");
	        setTimeout(CascadeConfig,200);
            $.messager.popover({ msg: '保存成功！', type: 'success' });
        } else {
            //$.messager.popover({ msg: '停止/评价结果配置 保存失败！' + rtn, type: 'error' });
            $.messager.popover({ msg: '停止/评价配置 保存失败！' , type: 'error' });
        }
    })
    PageLogicObj.editedrow = "null";    
}
/*
function InitExecuteNoteConfigTab(value) {
    var dataArr = new Array();
    if (value) {
        for (var k = 0; k < value.split("@").length; k++) {
            var onevalue = value.split("@")[k];
            dataArr.push({
                "index": k,
                "ExecuteNoteDesc": onevalue
            });
        }
    }
    PageLogicObj.m_MaxIndex = dataArr.length;
    var ToolBar = [{
        text: '新增',
        iconCls: 'icon-add',
        handler: function () {
            if (PageLogicObj.editedrow == "null") {
                $('#ExecuteNoteConfigTab').datagrid("appendRow", {
                    index: PageLogicObj.m_MaxIndex,
                    ExecuteNoteDesc: ""
                });
                var rows = $('#ExecuteNoteConfigTab').datagrid("getRows");
                $('#ExecuteNoteConfigTab').datagrid("beginEdit", rows.length - 1);
                var editors = $('#ExecuteNoteConfigTab').datagrid('getEditors', rows.length - 1);
                $(editors[0].target).focus();
                PageLogicObj.editedrow = rows.length - 1;
                PageLogicObj.m_MaxIndex++;
            } else {
                $.messager.confirm("提示", "有正在编辑的行")
            }
        }
    }, {
        text: '保存',
        iconCls: 'icon-save',
        handler: SaveExecuteNoteConfig

    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function () {
            var rows = $('#ExecuteNoteConfigTab').datagrid("getSelections");
            if (rows.length > 0) {
                for (var i = (rows.length - 1); i >= 0; i--) {
                    var index = $('#ExecuteNoteConfigTab').datagrid("getRowIndex", rows[i]);
                    $('#ExecuteNoteConfigTab').datagrid("deleteRow", index);
                }
            } else {
                $.messager.popover({ msg: '请选择需要删除的行！', type: 'error' });
                return false;
            }
        }
    }];
    var Columns = [[
        {
            field: 'ExecuteNoteDesc', title: '备注', width: 150,
            editor: { type: 'text', options: {} }
        }
    ]];
    $(".eval-tab").css("height", $(window).height() - 477); //507
    $('#ExecuteNoteConfigTab').datagrid({
        fit: true,
        width: 'auto',
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: true,
        autoRowHeight: false,
        loadMsg: '加载中..',
        pagination: false,
        rownumbers: true,
        idField: "index",
        columns: Columns,
        toolbar: ToolBar,
        data: dataArr,
        onDblClickRow: function (rowIndex, rowData) {
	        
            if (PageLogicObj.editedrow == "null") {
                $('#ExecuteNoteConfigTab').datagrid("beginEdit", rowIndex);
                PageLogicObj.editedrow = rowIndex;
            } else {
                $.messager.confirm("提示", "有正在编辑的行")
            }            
        }
    })
}
function SaveExecuteNoteConfig() {
    var QPCCExecuteNote = ""
    var NodeNameArr = new Array()
    var rows = $('#ExecuteNoteConfigTab').datagrid("getRows");
    for (var i = 0; i < rows.length; i++) {
        var editors = $('#ExecuteNoteConfigTab').datagrid('getEditors', i);
        if (editors.length > 0) {
            var name = $.trim(editors[0].target.val());
        } else {
            var name = rows[i].ExecuteNoteDesc;
        }
        if (!name) {
            $.messager.popover({ msg: '第 ' + (i + 1) + ' 行,备注为空！', type: 'error' });
            return false;
        }
        if (NodeNameArr[name]) {
            $.messager.popover({ msg: '第 ' + (i + 1) + ' 行,备注 ' + name + ' 重复！', type: 'error' });
            return false;
        }
        NodeNameArr[name] = 1;
        if (QPCCExecuteNote == "") QPCCExecuteNote = name;
        else QPCCExecuteNote = QPCCExecuteNote + "@" + name;
        $('#ExecuteNoteConfigTab').datagrid('updateRow', {
            index: i,
            row: {
                ExecuteNoteDesc: name
            }
        });
    }
    PageLogicObj.QPCCExecuteNoteStr = QPCCExecuteNote;
    PageLogicObj.editedrow = "null";
}

function InitQuestionEvaluateResultTab(value) {
    var dataArr = new Array();
    if (value) {
        for (var k = 0; k < value.split("@").length; k++) {
            var onevalue = value.split("@")[k];
            var code = onevalue.split(String.fromCharCode(13))[0];
            var name = onevalue.split(String.fromCharCode(13))[1];
            dataArr.push({
                "index": k,
                "EvaluateResultCode": code,
                "EvaluateResultDesc": name
            });
        }
    }
    PageLogicObj.m_MaxIndex = dataArr.length;
    var ToolBar = [{
        text: '新增',
        iconCls: '	icon-add',
        handler: function () {
            $('#QuestionEvaluateResultTab').datagrid("appendRow", {
                index: PageLogicObj.m_MaxIndex,
                EvaluateResultCode: "",
                EvaluateResultDesc: ""
            });
            var rows = $('#QuestionEvaluateResultTab').datagrid("getRows");
            $('#QuestionEvaluateResultTab').datagrid("beginEdit", rows.length - 1);
            var editors = $('#QuestionEvaluateResultTab').datagrid('getEditors', rows.length - 1);
            $(editors[0].target).focus();
            PageLogicObj.m_MaxIndex++;
        }
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function () {
            var rows = $('#QuestionEvaluateResultTab').datagrid("getSelections");
            if (rows.length > 0) {
                for (var i = (rows.length - 1); i >= 0; i--) {
                    var index = $('#QuestionEvaluateResultTab').datagrid("getRowIndex", rows[i]);
                    $('#QuestionEvaluateResultTab').datagrid("deleteRow", index);
                }
            } else {
                $.messager.popover({ msg: '请选择需要删除的行！', type: 'error' });
                return false;
            }
        }
    }];
    var Columns = [[
        {
            field: 'EvaluateResultCode', title: '代码', width: 100,
            editor: { type: 'text', options: {} }
        },
        {
            field: 'EvaluateResultDesc', title: '描述', width: 150,
            editor: { type: 'text', options: {} }
        }
    ]];
    $(".eval-tab").css("height", $(window).height() - 477); //507
    $('#QuestionEvaluateResultTab').datagrid({
        fit: true,
        width: 'auto',
        border: false,
        striped: true,
        singleSelect: false,
        fitColumns: true,
        autoRowHeight: false,
        loadMsg: '加载中..',
        pagination: false,
        rownumbers: true,
        idField: "index",
        columns: Columns,
        toolbar: ToolBar,
        data: dataArr,
        onDblClickRow: function (rowIndex, rowData) {
            $('#QuestionEvaluateResultTab').datagrid("beginEdit", rowIndex);
        }
    })
}
*/

function SaveConfig() {
	// 是否启用问题优先级
    var QPCCOpenQuestionPriority = $("#QPCCOpenQuestionPriority_1").checkbox('getValue') ? "Y" : "N";
    // 是否启用非评估相关因素
    var QPCCOpenQLRelateFactor = $("#QPCCOpenQLRelateFactor_1").checkbox('getValue') ? "Y" : "N";
    // 是否显示护理目标
    var QPCCOpenQuestionTarget = $("#QPCCOpenQuestionTarget_1").checkbox('getValue') ? "Y" : "N";
    
  
    // 是否进行护理评价审核
    var QPCCOpenNurEvaluateAudit = $("#QPCCOpenNurEvaluateAudit_1").checkbox('getValue')?"Y":"N";
    // 撤销适用于护理问题 --2021.3.31 去掉此维护
    var QPCCCancelApplyToQuestion = $("#QPCCCancelApplyToQuestion").checkbox('getValue') ? "Y" : "N";
    // 撤销适用于护理目标--2021.3.31 去掉此维护
    var QPCCCancelApplyToQuestionTarget = $("#QPCCCancelApplyToQuestionTarget").checkbox('getValue') ? "Y" : "N";
    // 撤销适用于非评估相关因素--2021.3.31 去掉此维护
    var QPCCCancelApplyToQuestionRealateFactor = $("#QPCCCancelApplyToQuestionRealateFactor").checkbox('getValue') ? "Y" : "N";
    // 撤销异常原因
    var QPCCCancelReason = $.trim($("#QPCCCancelReason").val());
    // 撤销原因必填
    var QPCCCancelMustReason = $("#QPCCCancelMustReason").checkbox('getValue') ? "Y" : "N";
    if ((QPCCCancelMustReason == "Y") && (!QPCCCancelReason)) {
        $.messager.popover({ msg: '撤销原因必填时异常原因不能为空', type: 'error' });
        $("#QPCCCancelReason").focus();
        return false;
    }
    // 撤销字体颜色
    var QPCCCancelFontColor = ""; //$("#QPCCCancelFontColor").color("getValue") //.val();
    // 作废适用于非评估相关因素
    var QPCCUnUserApplyToQuestion = $("#QPCCUnUserApplyToQuestion").checkbox('getValue') ? "Y" : "N";
    // 作废适用于护理措施
    var QPCCUnUserApplyToQuestionMeasure = $("#QPCCUnUserApplyToQuestionMeasure").checkbox('getValue') ? "Y" : "N";
    // 作废异常原因
    var QPCCUnUserReason = $.trim($("#QPCCUnUserReason").val());
    // 作废原因必填
    var QPCCUnUserMustReason = $("#QPCCUnUserMustReason").checkbox('getValue') ? "Y" : "N";
    if ((QPCCUnUserMustReason == "Y") && (!QPCCUnUserReason)) {
        $.messager.popover({ msg: '作废原因必填时异常原因不能为空', type: 'error' });
        $("#QPCCUnUserReason").focus();
        return false;
    }
    // 作废字体颜色
    var QPCCUnUserFontColor = $("#QPCCUnUserFontColor").color("getValue"); //.val();
    // 停止异常原因
    var QPCCStopReason = $.trim($("#QPCCStopReason").val());
    // 停止原因必填
    var QPCCStopMustReason = $("#QPCCStopMustReason").checkbox('getValue') ? "Y" : "N";
    if ((QPCCStopMustReason == "Y") && (!QPCCStopReason)) {
        $.messager.popover({ msg: '停止原因必填时异常原因不能为空', type: 'error' });
        $("#QPCCStopReason").focus();
        return false;
    }
    // 停止字体颜色
    var QPCCStopFontColor = $("#QPCCStopFontColor").color("getValue"); //.val();
    
    //SaveExecuteNoteConfig();
    // 护嘱任务的执行备注,以"@"分隔
    //var QPCCExecuteNote = PageLogicObj.QPCCExecuteNoteStr;
    
    // 评价结果
    var QPCCQuestionEvaluateResult = ""; //$.trim($("#QPCCQuestionEvaluateResult").val());
   
   /*
    var EvalCodeArr = new Array(), EvalNameArr = new Array();
    var rows = $('#QuestionEvaluateResultTab').datagrid("getRows");
    for (var i = 0; i < rows.length; i++) {
        var editors = $('#QuestionEvaluateResultTab').datagrid('getEditors', i);
        if (editors.length > 0) {
            var code = $.trim(editors[0].target.val());
            var name = $.trim(editors[1].target.val());
        } else {
            var code = rows[i].EvaluateResultCode;
            var name = rows[i].EvaluateResultDesc;
        }
        if ((!code) || (!name)) {
            $.messager.popover({ msg: '第 ' + (i + 1) + ' 行,评价代码/评价描述为空！', type: 'error' });
            return false;
        }
        if (EvalCodeArr[code]) {
            $.messager.popover({ msg: '第 ' + (i + 1) + ' 行,评价代码 ' + code + ' 重复！', type: 'error' });
            return false;
        }
        if (EvalCodeArr[name]) {
            $.messager.popover({ msg: '第 ' + (i + 1) + ' 行,评价描述 ' + name + ' 重复！', type: 'error' });
            return false;
        }
        EvalCodeArr[code] = 1;
        EvalNameArr[name] = 1;
      
        if (QPCCQuestionEvaluateResult == "") QPCCQuestionEvaluateResult = code + String.fromCharCode(13) + name;
        else QPCCQuestionEvaluateResult = QPCCQuestionEvaluateResult + "@" + code + String.fromCharCode(13) + name;
        $('#QuestionEvaluateResultTab').datagrid('updateRow', {
            index: i,
            row: {
                EvaluateResultCode: code,
                EvaluateResultDesc: name
            }
        });
    }    
    if ((!QPCCQuestionEvaluateResult) && (QPCCOpenNurEvaluate == "Y")) {
        $.messager.popover({ msg: '启用护理评价时,评价结果维护不能为空！', type: 'error' });
        return false;
    }
    */
    var rows = $('#StopEvaluationResultConfigTab').datagrid("getRows");
    for (var i = 0; i < rows.length; i++) {
	    var QPCCERowId=rows[i].rowid;
		var QPCCECode=rows[i].QPCCECode;
		var QPCCEDescription=rows[i].QPCCEDescription;
		if (QPCCQuestionEvaluateResult == "") QPCCQuestionEvaluateResult = QPCCECode + String.fromCharCode(13) + QPCCEDescription;
        else QPCCQuestionEvaluateResult = QPCCQuestionEvaluateResult + "@" + QPCCECode + String.fromCharCode(13) + QPCCEDescription;

	}
    
    // 是否默认勾选转入护理记录
    var QPCCOpenNurTaskTrans = $("#QPCCOpenNurTaskTrans_1").checkbox('getValue') ? "Y" : "N";
    
    // 是否允许删除护嘱任务
    var QPCCOpenDelNureTask = $("#QPCCOpenDelNureTask_1").checkbox('getValue') ? "Y" : "N";
    
    // 是否显示护理计划制定页面显示治疗天数 --2021.7.26 add
    //var QPCCOpenTreatDays = $("#QPCCOpenTreatDays_1").checkbox('getValue') ? "Y" : "N";
    
    // 是否允许撤销护理计划及护嘱任务 --2021.9.1 add
    var QPCCOpenCancelNursePlan = $("#QPCCOpenCancelNursePlan_1").checkbox('getValue') ? "Y" : "N";
   
    // // 是否允许修改手动新增问题时间(新说明) 2022.08.25 add
    var QPCCEditDateTime = $("#QPCCEditDateTime_1").checkbox('getValue') ? "Y" : "N";
	// 作废适用于非评估相关因素
    var QPCCUnUserApplyToQuestionRealateFactor = $("#QPCCUnUserApplyToQuestionRealateFactor").checkbox('getValue') ? "Y" : "N";
    // 作废适用于护理目标
    var QPCCUnUserApplyToQuestionTarget = $("#QPCCUnUserApplyToQuestionTarget").checkbox('getValue') ? "Y" : "N";
    // 医院ID
    var Hospital = $HUI.combogrid('#_HospList').getValue();

	//2022.09.27 add
	//2758853【护理计划配置】业务界面整合
	//护理计划修改权限限制
	var QPCCNurPlanPermission = "" ;
	if ($("#QPCCNurPlanPermission_self").checkbox('getValue')&& $("#QPCCNurPlanPermission_leader").checkbox('getValue'))
	{
		QPCCNurPlanPermission="S&L"
	}
	else if ($("#QPCCNurPlanPermission_self").checkbox('getValue')&& !$("#QPCCNurPlanPermission_leader").checkbox('getValue'))
	{
		QPCCNurPlanPermission="S"
	}
	else if (!$("#QPCCNurPlanPermission_self").checkbox('getValue')&& $("#QPCCNurPlanPermission_leader").checkbox('getValue'))
	{
		QPCCNurPlanPermission="L"
	}else{
		QPCCNurPlanPermission=""
	}
	
	// 是否显示目标达成天数
	var QPCCOpenPlayDays = $("#QPCCOpenPlayDays_1").checkbox('getValue') ? "Y" : "N";
	var QPCCDefaultPlayDays=""
	if (QPCCOpenPlayDays=="Y"){
		QPCCDefaultPlayDays=$("#QPCCDefaultPlayDays").val()
		//判断是否为数字格式
		var r = /^\+?[1-9][0-9]*$/;　　//正整数
		var flag = r.test(QPCCDefaultPlayDays);
		if ((QPCCDefaultPlayDays!="")&&(!flag)) {
			$.messager.popover({ msg: '默认天数请填写正整数！', type: 'error' });
			return
		}
	}
	// 是否进行计划审核
	var QPCCOpenNurPlanReview = $("#QPCCOpenNurPlanReview_1").checkbox('getValue') ? "Y" : "N";
	var QPCCNurPlanReviewPermission=""
	if (QPCCOpenNurPlanReview=="Y")
	{
		if ($("#QPCCNurPlanReviewPermission_self").checkbox('getValue')&& $("#QPCCNurPlanReviewPermission_leader").checkbox('getValue'))
		{
			QPCCNurPlanReviewPermission="S&L"
		}
		else if ($("#QPCCNurPlanReviewPermission_self").checkbox('getValue')&& !$("#QPCCNurPlanReviewPermission_leader").checkbox('getValue'))
		{
			QPCCNurPlanReviewPermission="S"
		}
		else if (!$("#QQPCCNurPlanReviewPermission_self").checkbox('getValue')&& $("#QPCCNurPlanReviewPermission_leader").checkbox('getValue'))
		{
			QPCCNurPlanReviewPermission="L"
		}
	}
	// 是否允许撤销计划审核
	var QPCCOpenCancelNurPlanReview = $("#QPCCOpenCancelNurPlanReview_1").checkbox('getValue') ? "Y" : "N";
	var QPCCNPRCancelPermission=""
	if (QPCCOpenCancelNurPlanReview=="Y")
	{
		if ($("#QPCCNPRCancelPermission_self").checkbox('getValue')&& $("#QPCCNPRCancelPermission_leader").checkbox('getValue'))
		{
			QPCCNPRCancelPermission="S&L"
		}
		else if ($("#QPCCNPRCancelPermission_self").checkbox('getValue')&& !$("#QPCCNPRCancelPermission_leader").checkbox('getValue'))
		{
			QPCCNPRCancelPermission="S"
		}
		else if (!$("#QPCCNPRCancelPermission_self").checkbox('getValue')&& $("#QPCCNPRCancelPermission_leader").checkbox('getValue'))
		{
			QPCCNPRCancelPermission="L"
		}
	}
	// 是否需自定评价备注
	var QPCCOpenNurSelfDefEvaluate = $("#QPCCOpenNurSelfDefEvaluate_1").checkbox('getValue') ? "Y" : "N";
	// 是否允许撤销评价
	var QPCCOpenCancelNurEvaluate = $("#QPCCOpenCancelNurEvaluate_1").checkbox('getValue') ? "Y" : "N";
	var QPCCNECancelPermission=""
	if (QPCCOpenCancelNurEvaluate=="Y")
	{
		if ($("#QPCCNECancelPermission_self").checkbox('getValue')&& $("#QPCCNECancelPermission_leader").checkbox('getValue'))
		{
			QPCCNECancelPermission="S&L"
		}
		else if ($("#QPCCNECancelPermission_self").checkbox('getValue')&& !$("#QPCCNECancelPermission_leader").checkbox('getValue'))
		{
			QPCCNECancelPermission="S"
		}
		else if (!$("#QPCCNECancelPermission_self").checkbox('getValue')&& $("#QPCCNECancelPermission_leader").checkbox('getValue'))
		{
			QPCCNECancelPermission="L"
		}
	}
	
	// 是否允许修改评价时间
	var QPCCEvaluationEditDateTime = $("#QPCCEvaluationEditDateTime_1").checkbox('getValue') ? "Y" : "N";
	// 护嘱执行默认显示时间 
	var QPCCInterventionShowTime = $("#QPCCInterventionShowTime_1").checkbox('getValue') ? "Now" : "Exe";
	// 护嘱限制执行时间(早于、晚于、早于或晚于)
	var QPCCInterventionLimit=$("#QPCCInterventionLimit").combobox("getValue")
	// 计划执行时间(*)分钟
	var QPCCInterventionTime=$("#QPCCInterventionTime").val()
	var r = /^[0-9]+?$/;　　//非负整数
	var flag = r.test(QPCCInterventionTime);
	if ((QPCCInterventionTime!="")&&(!flag)) {
		$.messager.popover({ msg: '计划执行时间请填写整数！', type: 'error' });
		$("#QPCCInterventionTime").focus();
		return false;
	}	
	// 护理问题默认查询状态 状态（0：未停止 1：已停止 2：已撤销 3：已作废）
	var QPCCNursePlanSearchStatus=($("#QPCCNursePlanSearchStatus_00").checkbox('getValue')?"0":"")+"^"+
								  ($("#QPCCNursePlanSearchStatus_01").checkbox('getValue')?"1":"")+"^"+
								  ($("#QPCCNursePlanSearchStatus_02").checkbox('getValue')?"2":"")+"^"+
								  ($("#QPCCNursePlanSearchStatus_03").checkbox('getValue')?"3":"")
	
	// 评价默认查询状态 (0：未评价 1：已评价)
	var QPCCNurEvaluateSearchStatus=($("#QPCCNurEvaluateSearchStatus_00").checkbox('getValue')?"0":"")+"^"+
								    ($("#QPCCNurEvaluateSearchStatus_01").checkbox('getValue')?"1":"")
	

	// 护嘱查询默认时间配置
	// 开始日期
	var QPCCInterventionStartDate=$("#QPCCInterventionStartDate").val();

	//判断是否为数字格式
	var r1 = /^[0-9]+?$/;　　//非负整数(正整数+0)
	var r2 =/^-[1-9]\d*$/;   //负整数  需求序号3086317
	var flag_1 = r1.test(QPCCInterventionStartDate)||r2.test(QPCCInterventionStartDate);
	if ((QPCCInterventionStartDate!="")&&(!flag_1)) {
		$.messager.popover({ msg: '开始日期请填写整数！', type: 'error' });
		$("#QPCCInterventionStartDate").focus();
		return false;
	}	
	// 开始时间
	var QPCCInterventionStartTime=$("#QPCCInterventionStartTime").timespinner('getValue');
	// 结束日期
	var QPCCInterventionEndDate=$("#QPCCInterventionEndDate").val();
	var flag_2 = r1.test(QPCCInterventionEndDate)||r2.test(QPCCInterventionEndDate);
	if ((QPCCInterventionEndDate!="")&&(!flag_2)) {
		$.messager.popover({ msg: '结束日期请填写整数！', type: 'error' });
		$("#QPCCInterventionEndDate").focus();
		return false;
	}
	if ((QPCCInterventionStartDate!="")&&(QPCCInterventionEndDate!="")&&(QPCCInterventionEndDate<QPCCInterventionStartDate)) {
		$.messager.popover({ msg: '结束日期应不小于开始日期！', type: 'error' });
		$("#QPCCInterventionEndDate").focus();
		return false;
	}	
	// 结束时间
	var QPCCInterventionEndTime=$("#QPCCInterventionEndTime").timespinner('getValue');
	
	// 护嘱背景色设置

	// 长嘱背景色设置
	var QPCCLongTermInterventionColor = $("#QPCCLongTermInterventionColor").color("getValue");
	// 临嘱背景色设置
	var QPCCTemporaryInterventionColor = $("#QPCCTemporaryInterventionColor").color("getValue");
	// 护理计划单打印限制控制
	var QPCCNursePlanPrintStatusLimit=($("#QPCCNursePlanPrintStatusLimit_00").checkbox('getValue')?"00":"")+"^"+
								  ($("#QPCCNursePlanPrintStatusLimit_01").checkbox('getValue')?"01":"")+"^"+
								  ($("#QPCCNursePlanPrintStatusLimit_Limit").checkbox('getValue')?"Limit":"");
	// 默认打印护理问题
	var QPCCNursePlanPrintStatus= ($("#QPCCNursePlanPrintStatus_00").checkbox('getValue')?"00":"")+"^"+
								  ($("#QPCCNursePlanPrintStatus_01").checkbox('getValue')?"01":"")+"^"+
								  ($("#QPCCNursePlanPrintStatus_02").checkbox('getValue')?"02":"")+"^"+
								  ($("#QPCCNursePlanPrintStatus_03").checkbox('getValue')?"03":"")+"^"+
								  ($("#QPCCNursePlanPrintStatus_04").checkbox('getValue')?"04":"")+"^"+
								  ($("#QPCCNursePlanPrintStatus_05").checkbox('getValue')?"05":"");
	// 2023.02.09 add
	//护理计划转科打印规则
	var QPCCNurPlanTransPrintRule = $("#QPCCNurPlanTransPrintRule_1").checkbox('getValue') ? "THIS" : "ALL";	
	//护理计划打印模板
	var QPCCNurPlanPrintTemplate=$("#QPCCNurPlanPrintTemplate").val()
	
	
	// 是否进行护理评价（调整为护理问题评价流程/停止流程 选择器）
    var QPCCOpenNurEvaluate = $("#QPCCOpenNurEvaluate_1").checkbox('getValue') ? "Y" : "N";
    if (QPCCOpenNurEvaluate=="N"){
	    // 停止适用于护理问题
	    var QPCCStopApplyToQuestion="Y"
	}else{
		var QPCCStopApplyToQuestion="N"
	}
    // 停止适用于护理措施
    var ApplyToQuestionMeasure = $("#ApplyToQuestionMeasure").checkbox('getValue') ? "Y" : "N";
    if ((QPCCOpenNurEvaluate=="N")&&(ApplyToQuestionMeasure=="Y")){
		var QPCCStopApplyToQuestionMeasure ="Y"
    }else {
	    var QPCCStopApplyToQuestionMeasure ="N"
	}
	//转归原因配置 以@分割	
	var QPCCTransReason=$("#QPCCTransReason").val();
	
	// 计划提交时是否默认勾选转入护理病历
	var QPCCOpenNurPlanTrans = $("#QPCCOpenNurPlanTrans_1").checkbox('getValue') ? "Y" : "N";

	// 问题评价时是否默认勾选转入护理病历
	var QPCCOpenNurEvaluateTrans = $("#QPCCOpenNurEvaluateTrans_1").checkbox('getValue') ? "Y" : "N";

	// 问题停止时是否默认勾选转入护理病历 
	var QPCCOpenNurQuestionStopTrans = $("#QPCCOpenNurQuestionStopTrans_1").checkbox('getValue') ? "Y" : "N";

	// 计划提交时转入护理记录格式
	var QPCCNurPlanTransFormat=$("#QPCCNurPlanTransFormat").val();
	
	// 护嘱执行时转入护理记录格式
	var QPCCNurTaskTransFormat=$("#QPCCNurTaskTransFormat").val();

	// 问题评价时转入护理记录格式
	var QPCCNurEvaluateTransFormat=$("#QPCCNurEvaluateTransFormat").val();

	// 问题停止时转入护理记录格式
	var QPCCNurQuestionStopTransFormat=$("#QPCCNurQuestionStopTransFormat").val();

	// 护嘱执行时是否默认勾选转入护理病历
	var QPCCOpenNurExecuteTrans = $("#QPCCOpenNurExecuteTrans_1").checkbox('getValue') ? "Y" : "N";
	// 删除规则配置
	var QPCCDeleteRules=$("#QPCCDeleteRules_1").checkbox('getValue') ? "NotL" : ($("#QPCCDeleteRules_2").checkbox('getValue')?"TaskF":"EmrF");

	// 计划启用患者类型 类型（0:特级护理,1:一级护理,2:二级护理,3:三级护理 ）
	var QPCCNursePlanPatientStatus=($("#QPCCNursePlanPatientStatus_00").checkbox('getValue')?"^0":"")+
								  ($("#QPCCNursePlanPatientStatus_01").checkbox('getValue')?"^1":"")+
								  ($("#QPCCNursePlanPatientStatus_02").checkbox('getValue')?"^2":"")+
								  ($("#QPCCNursePlanPatientStatus_03").checkbox('getValue')?"^3":"")
	/*
    // 2022.08.30 add
    if ((QPCCOpenNurEvaluate=="N")&&(QPCCStopApplyToQuestion=="N")){
	    if (QPCCOpenNurEvaluate=="N") $.messager.popover({ msg: '请选择进行护理评价！', type: 'error' });
		if (QPCCStopApplyToQuestion=="N") $.messager.popover({ msg: '请在计划异常操作配置中勾选停止护理问题！', type: 'error' });
		
        return false;
	}
	*/
	// 护嘱执行时转入护理记录类型（Y:通用、N:个性化）
	var QPCCNurExecuteTransCommon = $("#QPCCNurExecuteTransCommon_1").checkbox('getValue') ? "Y" : "N";
    var dataSaveObj = {
        QPCCOpenQuestionPriority: QPCCOpenQuestionPriority,
        QPCCOpenQLRelateFactor: QPCCOpenQLRelateFactor,
        QPCCOpenQuestionTarget: QPCCOpenQuestionTarget,
        QPCCOpenNurEvaluate: QPCCOpenNurEvaluate,
        QPCCOpenNurEvaluateAudit: QPCCOpenNurEvaluateAudit,
        QPCCCancelApplyToQuestion: QPCCCancelApplyToQuestion,
        QPCCCancelApplyToQuestionTarget: QPCCCancelApplyToQuestionTarget,
        QPCCCancelApplyToQuestionRealateFactor: QPCCCancelApplyToQuestionRealateFactor,
        QPCCCancelReason: QPCCCancelReason,
        QPCCCancelMustReason: QPCCCancelMustReason,
        QPCCCancelFontColor: QPCCCancelFontColor,
        QPCCUnUserApplyToQuestion: QPCCUnUserApplyToQuestion,
        QPCCUnUserApplyToQuestionMeasure: QPCCUnUserApplyToQuestionMeasure,
        QPCCUnUserReason: QPCCUnUserReason,
        QPCCUnUserMustReason: QPCCUnUserMustReason,
        QPCCUnUserFontColor: QPCCUnUserFontColor,
        QPCCStopApplyToQuestion: QPCCStopApplyToQuestion,
        QPCCStopApplyToQuestionMeasure: QPCCStopApplyToQuestionMeasure,
        QPCCStopReason: QPCCStopReason,
        QPCCStopMustReason: QPCCStopMustReason,
        QPCCStopFontColor: QPCCStopFontColor,
        QPCCQuestionEvaluateResult: QPCCQuestionEvaluateResult,
        QPCCHospitalDR: Hospital,
        QPCCOpenNurTaskTrans: QPCCOpenNurTaskTrans,
        QPCCOpenDelNureTask: QPCCOpenDelNureTask,
        QPCCUnUserApplyToQuestionRealateFactor: QPCCUnUserApplyToQuestionRealateFactor,
        QPCCUnUserApplyToQuestionTarget: QPCCUnUserApplyToQuestionTarget,
        QPCCTaskLimitHour: $("#QPCCTaskLimitHour").val(),
        //QPCCOpenTreatDays: QPCCOpenTreatDays,
        QPCCOpenCancelNursePlan: QPCCOpenCancelNursePlan,
        //QPCCExecuteNote: QPCCExecuteNote,
        QPCCEditDateTime:QPCCEditDateTime,
        //2022.09.27 add
        QPCCNurPlanPermission:QPCCNurPlanPermission,
        QPCCOpenPlayDays:QPCCOpenPlayDays,
        QPCCDefaultPlayDays:QPCCDefaultPlayDays,
        QPCCOpenNurPlanReview:QPCCOpenNurPlanReview,
        QPCCNurPlanReviewPermission:QPCCNurPlanReviewPermission,
        QPCCOpenCancelNurPlanReview:QPCCOpenCancelNurPlanReview,
        QPCCNPRCancelPermission:QPCCNPRCancelPermission,
        QPCCOpenNurSelfDefEvaluate:QPCCOpenNurSelfDefEvaluate,
        QPCCOpenCancelNurEvaluate:QPCCOpenCancelNurEvaluate,
        QPCCNECancelPermission:QPCCNECancelPermission,
        QPCCEvaluationEditDateTime:QPCCEvaluationEditDateTime,
        QPCCInterventionShowTime:QPCCInterventionShowTime,
        QPCCInterventionLimit:QPCCInterventionLimit,
        QPCCInterventionTime:QPCCInterventionTime,
        QPCCNursePlanSearchStatus:QPCCNursePlanSearchStatus,
        QPCCNurEvaluateSearchStatus:QPCCNurEvaluateSearchStatus,
        QPCCInterventionStartDate:QPCCInterventionStartDate,
        QPCCInterventionStartTime:QPCCInterventionStartTime,
        QPCCInterventionEndDate:QPCCInterventionEndDate,
        QPCCInterventionEndTime:QPCCInterventionEndTime,
        QPCCLongTermInterventionColor:QPCCLongTermInterventionColor,
        QPCCTemporaryInterventionColor:QPCCTemporaryInterventionColor,
        QPCCNursePlanPrintStatusLimit:QPCCNursePlanPrintStatusLimit,
        QPCCNursePlanPrintStatus:QPCCNursePlanPrintStatus,
        QPCCTransReason:QPCCTransReason,
        QPCCOpenNurPlanTrans:QPCCOpenNurPlanTrans,
		QPCCOpenNurEvaluateTrans:QPCCOpenNurEvaluateTrans,
		QPCCOpenNurQuestionStopTrans:QPCCOpenNurQuestionStopTrans,
		QPCCNurPlanTransFormat:QPCCNurPlanTransFormat,
		QPCCNurTaskTransFormat:QPCCNurTaskTransFormat,
		QPCCNurEvaluateTransFormat:QPCCNurEvaluateTransFormat,
		QPCCNurQuestionStopTransFormat:QPCCNurQuestionStopTransFormat,
		QPCCOpenNurExecuteTrans:QPCCOpenNurExecuteTrans,
		QPCCDeleteRules:QPCCDeleteRules,
		//2023-02-09 add
		QPCCNurPlanTransPrintRule:QPCCNurPlanTransPrintRule,
		QPCCNurPlanPrintTemplate:QPCCNurPlanPrintTemplate,
		QPCCNursePlanPatientStatus:QPCCNursePlanPatientStatus,
		QPCCNurExecuteTransCommon:QPCCNurExecuteTransCommon,
    }
    $.m({
        ClassName: "CF.NUR.NIS.QPCommonConfig",
        MethodName: "Save",
        SaveDataCongeriesJson: JSON.stringify(dataSaveObj),
        Hospital: Hospital
    }, function (rtn) {
        if (rtn == 0) {
	        //$.messager.popover({ msg: '保存成功！', type: 'success' });
		    //停止/评价结果配置(整体)
		    setTimeout(SaveResultConfig,1000);
		    CascadeConfig();
        } else {
            $.messager.popover({ msg: '保存失败！' + rtn, type: 'error' });
        }
    })
}
function ResetDomSize() {
	var TabsWidth = $("#NurPlanTransTabs").width()
	$("#patientList").panel('resize', {
		width: TabsWidth-100
	});
}

//护嘱执行时转入病例格式界面修改
function NurExecuteTrans(){
	var QPCCNurExecuteTransCommon = $("#QPCCNurExecuteTransCommon_1").checkbox('getValue') ? "Y" : "N";
	if (QPCCNurExecuteTransCommon=="Y"){
		$("#KW_NurTaskTransFormat").style.visibility="visible";//显示
		$("#QPCCNurTaskTransFormat").show();
		//InitFormatKeywords()
	}else{
		var FormatHeight=$("#QPCCNurTaskTransFormat").height()+$("#KW_NurPlanTransFormat").height();
        var FormatWidth=$("#QPCCNurTaskTransFormat").width();        
        var html = '<textarea id="transtooltip" class="hisui-textbox textbox" style="width:'+FormatWidth+'px;height:'+FormatHeight+'px" >'+$g("护嘱执行时个性化转入病历格式取值:措施任务文书-文书配置-护理文书描述")+'</textarea>'
        if ($("#transtooltip").length<=0){
	        $("#QPCCNurTaskTransFormat").after(html);
        	$("#transtooltip").attr("disabled",true);
        }else{
	        $("#transtooltip").show();
	    }
        $("#KW_NurTaskTransFormat").style.visibility="hidden";//隐藏
        $("#QPCCNurTaskTransFormat").hide();
	}
}