/**
* @author songchunli
* HISUI ����ƻ�ͨ��������js
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
		checkbox: {//��������
	        init: function (container, options) {
		        //container ����װ�ر༭�� options,�ṩ�༭����ʼ����
	            // �����һ�� checkbox���͵�����ؼ���ӵ�����container��
	            var input = $('<input class="hisui-checkbox" type="checkbox" >').appendTo(container);
	            // ��Ҫ��Ⱦ��easyu�ṩ�Ŀؼ�����Ҫʱ�ô���options��
	            // ���������Ҫһ��combobox���Ϳ��� �������� input.combobox(options);
	            return input;
	         },
	         getValue: function (target) {
	            //datagrid �����༭ģʽ��ͨ���÷������ر༭����ֵ
	            //��������û���ѡ��checkbox����Y���򷵻�N
	             return $(target).prop("checked") ? 'Y' : 'N';
	         },
	         setValue: function (target, value) {
	            //datagrid ����༭��ģʽ��ͨ���÷���Ϊ�༭��ֵ
	            //���û�����Y��ѡ�༭��
	             if (value=='Y')
	                 $(target).prop("checked", "checked")
	         },
	         resize: function (target, width) {
	            //�п�ı������༭�����
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
    // ���� 2922271
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
    //2758853������ƻ����á�ҵ���������
    $("#QPCCLongTermInterventionColor,#QPCCTemporaryInterventionColor").color({
        editable: false,
        width: 100
    });
    // ��ʾ���� ��Ĭ��������
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
    //�Ƿ���мƻ���� ��ʾ���ء����Ȩ�ޡ�

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
    //�Ƿ��������ƻ���� ��ʾ���ء����Ȩ�ޡ�
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
    //�Ƿ����������� ��ʾ���ء����Ȩ�ޡ�
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
    //����ƻ�����ӡ���ƿ���
    $("#QPCCNursePlanPrintStatusLimit_00").checkbox({
        onChecked: function (e, value) {
            $("#QPCCNursePlanPrintStatusLimit_01").checkbox("uncheck");
            $("#QPCCNursePlanPrintStatus_00").checkbox("check");
            $("#QPCCNursePlanPrintStatus_01").checkbox("check");
            $("#QPCCNursePlanPrintStatus_02").checkbox("check"); 
            $("#QPCCNursePlanPrintStatus_03").checkbox("check"); 
            $("#QPCCNursePlanPrintStatus_04").checkbox("uncheck");  
            $("#QPCCNursePlanPrintStatus_05").checkbox("uncheck");
            //����ƻ�����ӡ���ƿ���-->ֹͣ/��������     
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
            //����ƻ�����ӡ���ƿ���-->ֹͣ/��������    
            $("#QPCCOpenNurEvaluate_1").radio("check");	     
        },
        onUnchecked: function (e, value) {
            $("#QPCCNursePlanPrintStatusLimit_00").checkbox("check");
            $("#QPCCNursePlanPrintStatus_04").checkbox("uncheck");
        }
    });
    //ֹͣ/��������
    $("#QPCCOpenNurEvaluate_1").radio({
        onChecked: function (e, value) {	        
			$("#ApplyToQuestion").checkbox("check");			
			$("#ApplyToQuestion").attr("disabled", "");
			$("#ApplyToQuestionMeasure").checkbox("uncheck");
			$("#ApplyToQuestionMeasure").attr("disabled", "");
			//ֹͣ/��������-->����ƻ�����ӡ���ƿ���
			$("#QPCCNursePlanPrintStatusLimit_01").checkbox("check");
        }
    });
    $("#QPCCOpenNurEvaluate_2").radio({
        onChecked: function (e, value) {
	        $("#ApplyToQuestionMeasure").removeAttr("disabled");
			$("#ApplyToQuestion").checkbox("check");
			$("#ApplyToQuestion").attr("disabled", "");	
			//ֹͣ/��������-->����ƻ�����ӡ���ƿ���
			$("#QPCCNursePlanPrintStatusLimit_00").checkbox("check");
        }
    });
    //����ִ��ʱת�벡����ʽ
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
	        
	        var html = '<textarea id="transtooltip" class="hisui-textbox textbox" style="width:'+FormatWidth+'px;height:'+FormatHeight+'px" >'+$g("����ִ��ʱ���Ի�ת�벡����ʽȡֵ:��ʩ��������-��������-������������")+'</textarea>'
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
//��ȡֹͣ/���۽�����ñ�_$id �����ü���
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
		//��ʽ 
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
	//������ʾ����
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
	//���ü���
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
	        //console.log("���->"+v.text);
	    },
        onUnselect:function(v){
	        //console.log("ȡ��ѡ��->"+v.text);
	        var str = "["+v.text+"]" 
	        deleteText($("#QPCCNurPlanTransFormat")[0],str)
	    },
        onSelect:function(v){
	        //console.log("ѡ��->"+v.text);
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
	  //������
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
// ��ʼ����������ִ��ʱ��������
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
	            // 2758853������ƻ����á�ҵ���������
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
	                //2758853������ƻ����á�ҵ���������
	                // Checkbox ��ѡϵ��
	                if ((item == "QPCCNurPlanPermission")||(item == "QPCCNurPlanReviewPermission")||
	                (item == "QPCCNPRCancelPermission")||(item == "QPCCNECancelPermission")){
		                // ���Ȩ��ϵ��		                
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
		                // ״̬ϵ�� 
						if (value.indexOf('^')>-1){
							var arr = value.split('^')
							for (i in arr){
								var _$id_code=$("#" + item + "_0"+arr[i].toString());
								if (_$id_code.length > 0) _$id_code.checkbox('check');
							}
						}	                
		            }else if ((item == "QPCCNursePlanPrintStatusLimit")||(item == "QPCCNursePlanPrintStatus")){
		                // ״̬ϵ�� 
						if (value.indexOf('^')>-1){
							var arr = value.split('^')
							for (i in arr){
								var _$id_code=$("#" + item + "_"+arr[i].toString());
								if (_$id_code.length > 0) _$id_code.checkbox('check');
							}
						}	                
		            }
	                else{
		                // �Ƿ�ϵ��		                
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
	                // Color ��ɫϵ��
                    _$id.color("setValue", value);
                }else if (item == "QPCCInterventionLimit") {
	                // Combobox������ϵ��
                    _$id.combobox("setValue", value);
                }  else {
	                // Textbox �ı���ϵ��
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
        text: '����',
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
                $.messager.confirm("��ʾ", "�����ڱ༭����")
            }
        }
    }, {
	    id:'RCSave',
        text: '����',
        iconCls: 'icon-save',
        //handler: SaveExecuteNoteConfig
        handler:SaveResultConfig

    }, {
	    id:'RCDelete',
        text: 'ɾ��',
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
			            $.messager.popover({ msg: 'ɾ���ɹ���', type: 'success' });
			        } else {
			            //$.messager.popover({ msg: 'ֹͣ/���۽������ ����ʧ�ܣ�' + rtn, type: 'error' });
			            $.messager.popover({ msg: 'ֹͣ/�������� ɾ��ʧ�ܣ�' , type: 'error' });
			        }
			    })
            } else {
                $.messager.popover({ msg: '��ѡ����Ҫɾ�����У�', type: 'error' });
                return false;
            }
        }
    }];

    var Columns = [[
    	{
            field: 'rowid',checkbox: 'true',
        },
		{
            field: 'QPCCECode', title: '����', width: 150,
            editor: { type: 'text', options: {} }
        },{
            //field: 'QPCCEDescription', title: '����', width: 150,
            field: 'QPCCEDescription', title: '����', width: 350,
            editor: { type: 'text', options: {} }
        },
        /*
        {
            field: 'QPCCEProcess', title: '��������', width: 200,
            editor: { type: 'combobox', options: {
	            data:ServerObj.QPCCEProcessTypeJson,
	            
	        } },
            formatter:function(value,row,index){
	            var id_01="QPCCEProcess_"+row.QPCCECode+"_01"
	            var id_02="QPCCEProcess_"+row.QPCCECode+"_02"
				if (value==""){		        	    
		        	return '<input class="hisui-checkbox" type="checkbox" label="����" id="'+id_01+'">'+
					       '<input class="hisui-checkbox" type="checkbox" label="ֹͣ" id="'+id_02+'">'

		        }else if(value=="Evaluate&Stop"){
		        	return '<input class="hisui-checkbox" type="checkbox" checked="true" label="����" id="'+id_01+'">'+
					       '<input class="hisui-checkbox" type="checkbox" checked="true" label="ֹͣ" id="'+id_02+'">'
			        
			    }else if(value=="Evaluate"){
		        	return '<input class="hisui-checkbox" type="checkbox" checked="true" label="����" id="'+id_01+'">'+
					       '<input class="hisui-checkbox" type="checkbox" label="ֹͣ" id="'+id_02+'">'
				    
				}
			    else if(value=="Stop"){
		        	return '<input class="hisui-checkbox" type="checkbox" label="����" id="'+id_01+'">'+
					       '<input class="hisui-checkbox" type="checkbox" checked="true" label="ֹͣ" id="'+id_02+'">'
				    
				}         
	        },

        },
        */
        {
            field: 'QPCCEOpenCopyQuestion', title: '�Ƿ�������', width: 150,
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
            field: 'QPCCEOpenFillOutcome', title: 'δ���������Ƿ���дת��', width: 200,
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
            field: 'QPCCEOpenReasonRequired', title: 'ת��ԭ�����', width: 150,
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
        nowrap:false,  /*�˴�Ϊfalse*/
        url : $URL+"?ClassName=CF.NUR.NIS.QPCommonConfigExt&QueryName=GetQPCCEData",
		onBeforeLoad:function(param){
			param = $.extend(param,{
				HospitalDR:$HUI.combogrid('#_HospList').getValue(),
				rows:999
			});				
		},
		onLoadSuccess:function(data){
			//���أ��Ժ�����û�
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
				$.messager.popover({msg: '���벻��Ϊ��!',type: 'error'});
				$(editors[0].target).focus();
				return false;
			};
			if(QPCCEDescription==""){
				$.messager.popover({msg: '��������Ϊ��!',type: 'error'});
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
            $.messager.popover({ msg: '����ɹ���', type: 'success' });
        } else {
            //$.messager.popover({ msg: 'ֹͣ/���۽������ ����ʧ�ܣ�' + rtn, type: 'error' });
            $.messager.popover({ msg: 'ֹͣ/�������� ����ʧ�ܣ�' , type: 'error' });
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
        text: '����',
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
                $.messager.confirm("��ʾ", "�����ڱ༭����")
            }
        }
    }, {
        text: '����',
        iconCls: 'icon-save',
        handler: SaveExecuteNoteConfig

    }, {
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function () {
            var rows = $('#ExecuteNoteConfigTab').datagrid("getSelections");
            if (rows.length > 0) {
                for (var i = (rows.length - 1); i >= 0; i--) {
                    var index = $('#ExecuteNoteConfigTab').datagrid("getRowIndex", rows[i]);
                    $('#ExecuteNoteConfigTab').datagrid("deleteRow", index);
                }
            } else {
                $.messager.popover({ msg: '��ѡ����Ҫɾ�����У�', type: 'error' });
                return false;
            }
        }
    }];
    var Columns = [[
        {
            field: 'ExecuteNoteDesc', title: '��ע', width: 150,
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
        loadMsg: '������..',
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
                $.messager.confirm("��ʾ", "�����ڱ༭����")
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
            $.messager.popover({ msg: '�� ' + (i + 1) + ' ��,��עΪ�գ�', type: 'error' });
            return false;
        }
        if (NodeNameArr[name]) {
            $.messager.popover({ msg: '�� ' + (i + 1) + ' ��,��ע ' + name + ' �ظ���', type: 'error' });
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
        text: '����',
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
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function () {
            var rows = $('#QuestionEvaluateResultTab').datagrid("getSelections");
            if (rows.length > 0) {
                for (var i = (rows.length - 1); i >= 0; i--) {
                    var index = $('#QuestionEvaluateResultTab').datagrid("getRowIndex", rows[i]);
                    $('#QuestionEvaluateResultTab').datagrid("deleteRow", index);
                }
            } else {
                $.messager.popover({ msg: '��ѡ����Ҫɾ�����У�', type: 'error' });
                return false;
            }
        }
    }];
    var Columns = [[
        {
            field: 'EvaluateResultCode', title: '����', width: 100,
            editor: { type: 'text', options: {} }
        },
        {
            field: 'EvaluateResultDesc', title: '����', width: 150,
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
        loadMsg: '������..',
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
	// �Ƿ������������ȼ�
    var QPCCOpenQuestionPriority = $("#QPCCOpenQuestionPriority_1").checkbox('getValue') ? "Y" : "N";
    // �Ƿ����÷������������
    var QPCCOpenQLRelateFactor = $("#QPCCOpenQLRelateFactor_1").checkbox('getValue') ? "Y" : "N";
    // �Ƿ���ʾ����Ŀ��
    var QPCCOpenQuestionTarget = $("#QPCCOpenQuestionTarget_1").checkbox('getValue') ? "Y" : "N";
    
  
    // �Ƿ���л����������
    var QPCCOpenNurEvaluateAudit = $("#QPCCOpenNurEvaluateAudit_1").checkbox('getValue')?"Y":"N";
    // ���������ڻ������� --2021.3.31 ȥ����ά��
    var QPCCCancelApplyToQuestion = $("#QPCCCancelApplyToQuestion").checkbox('getValue') ? "Y" : "N";
    // ���������ڻ���Ŀ��--2021.3.31 ȥ����ά��
    var QPCCCancelApplyToQuestionTarget = $("#QPCCCancelApplyToQuestionTarget").checkbox('getValue') ? "Y" : "N";
    // ���������ڷ������������--2021.3.31 ȥ����ά��
    var QPCCCancelApplyToQuestionRealateFactor = $("#QPCCCancelApplyToQuestionRealateFactor").checkbox('getValue') ? "Y" : "N";
    // �����쳣ԭ��
    var QPCCCancelReason = $.trim($("#QPCCCancelReason").val());
    // ����ԭ�����
    var QPCCCancelMustReason = $("#QPCCCancelMustReason").checkbox('getValue') ? "Y" : "N";
    if ((QPCCCancelMustReason == "Y") && (!QPCCCancelReason)) {
        $.messager.popover({ msg: '����ԭ�����ʱ�쳣ԭ����Ϊ��', type: 'error' });
        $("#QPCCCancelReason").focus();
        return false;
    }
    // ����������ɫ
    var QPCCCancelFontColor = ""; //$("#QPCCCancelFontColor").color("getValue") //.val();
    // ���������ڷ������������
    var QPCCUnUserApplyToQuestion = $("#QPCCUnUserApplyToQuestion").checkbox('getValue') ? "Y" : "N";
    // ���������ڻ����ʩ
    var QPCCUnUserApplyToQuestionMeasure = $("#QPCCUnUserApplyToQuestionMeasure").checkbox('getValue') ? "Y" : "N";
    // �����쳣ԭ��
    var QPCCUnUserReason = $.trim($("#QPCCUnUserReason").val());
    // ����ԭ�����
    var QPCCUnUserMustReason = $("#QPCCUnUserMustReason").checkbox('getValue') ? "Y" : "N";
    if ((QPCCUnUserMustReason == "Y") && (!QPCCUnUserReason)) {
        $.messager.popover({ msg: '����ԭ�����ʱ�쳣ԭ����Ϊ��', type: 'error' });
        $("#QPCCUnUserReason").focus();
        return false;
    }
    // ����������ɫ
    var QPCCUnUserFontColor = $("#QPCCUnUserFontColor").color("getValue"); //.val();
    // ֹͣ�쳣ԭ��
    var QPCCStopReason = $.trim($("#QPCCStopReason").val());
    // ֹͣԭ�����
    var QPCCStopMustReason = $("#QPCCStopMustReason").checkbox('getValue') ? "Y" : "N";
    if ((QPCCStopMustReason == "Y") && (!QPCCStopReason)) {
        $.messager.popover({ msg: 'ֹͣԭ�����ʱ�쳣ԭ����Ϊ��', type: 'error' });
        $("#QPCCStopReason").focus();
        return false;
    }
    // ֹͣ������ɫ
    var QPCCStopFontColor = $("#QPCCStopFontColor").color("getValue"); //.val();
    
    //SaveExecuteNoteConfig();
    // ���������ִ�б�ע,��"@"�ָ�
    //var QPCCExecuteNote = PageLogicObj.QPCCExecuteNoteStr;
    
    // ���۽��
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
            $.messager.popover({ msg: '�� ' + (i + 1) + ' ��,���۴���/��������Ϊ�գ�', type: 'error' });
            return false;
        }
        if (EvalCodeArr[code]) {
            $.messager.popover({ msg: '�� ' + (i + 1) + ' ��,���۴��� ' + code + ' �ظ���', type: 'error' });
            return false;
        }
        if (EvalCodeArr[name]) {
            $.messager.popover({ msg: '�� ' + (i + 1) + ' ��,�������� ' + name + ' �ظ���', type: 'error' });
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
        $.messager.popover({ msg: '���û�������ʱ,���۽��ά������Ϊ�գ�', type: 'error' });
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
    
    // �Ƿ�Ĭ�Ϲ�ѡת�뻤���¼
    var QPCCOpenNurTaskTrans = $("#QPCCOpenNurTaskTrans_1").checkbox('getValue') ? "Y" : "N";
    
    // �Ƿ�����ɾ����������
    var QPCCOpenDelNureTask = $("#QPCCOpenDelNureTask_1").checkbox('getValue') ? "Y" : "N";
    
    // �Ƿ���ʾ����ƻ��ƶ�ҳ����ʾ�������� --2021.7.26 add
    //var QPCCOpenTreatDays = $("#QPCCOpenTreatDays_1").checkbox('getValue') ? "Y" : "N";
    
    // �Ƿ�����������ƻ����������� --2021.9.1 add
    var QPCCOpenCancelNursePlan = $("#QPCCOpenCancelNursePlan_1").checkbox('getValue') ? "Y" : "N";
   
    // // �Ƿ������޸��ֶ���������ʱ��(��˵��) 2022.08.25 add
    var QPCCEditDateTime = $("#QPCCEditDateTime_1").checkbox('getValue') ? "Y" : "N";
	// ���������ڷ������������
    var QPCCUnUserApplyToQuestionRealateFactor = $("#QPCCUnUserApplyToQuestionRealateFactor").checkbox('getValue') ? "Y" : "N";
    // ���������ڻ���Ŀ��
    var QPCCUnUserApplyToQuestionTarget = $("#QPCCUnUserApplyToQuestionTarget").checkbox('getValue') ? "Y" : "N";
    // ҽԺID
    var Hospital = $HUI.combogrid('#_HospList').getValue();

	//2022.09.27 add
	//2758853������ƻ����á�ҵ���������
	//����ƻ��޸�Ȩ������
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
	
	// �Ƿ���ʾĿ��������
	var QPCCOpenPlayDays = $("#QPCCOpenPlayDays_1").checkbox('getValue') ? "Y" : "N";
	var QPCCDefaultPlayDays=""
	if (QPCCOpenPlayDays=="Y"){
		QPCCDefaultPlayDays=$("#QPCCDefaultPlayDays").val()
		//�ж��Ƿ�Ϊ���ָ�ʽ
		var r = /^\+?[1-9][0-9]*$/;����//������
		var flag = r.test(QPCCDefaultPlayDays);
		if ((QPCCDefaultPlayDays!="")&&(!flag)) {
			$.messager.popover({ msg: 'Ĭ����������д��������', type: 'error' });
			return
		}
	}
	// �Ƿ���мƻ����
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
	// �Ƿ��������ƻ����
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
	// �Ƿ����Զ����۱�ע
	var QPCCOpenNurSelfDefEvaluate = $("#QPCCOpenNurSelfDefEvaluate_1").checkbox('getValue') ? "Y" : "N";
	// �Ƿ�����������
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
	
	// �Ƿ������޸�����ʱ��
	var QPCCEvaluationEditDateTime = $("#QPCCEvaluationEditDateTime_1").checkbox('getValue') ? "Y" : "N";
	// ����ִ��Ĭ����ʾʱ�� 
	var QPCCInterventionShowTime = $("#QPCCInterventionShowTime_1").checkbox('getValue') ? "Now" : "Exe";
	// ��������ִ��ʱ��(���ڡ����ڡ����ڻ�����)
	var QPCCInterventionLimit=$("#QPCCInterventionLimit").combobox("getValue")
	// �ƻ�ִ��ʱ��(*)����
	var QPCCInterventionTime=$("#QPCCInterventionTime").val()
	var r = /^[0-9]+?$/;����//�Ǹ�����
	var flag = r.test(QPCCInterventionTime);
	if ((QPCCInterventionTime!="")&&(!flag)) {
		$.messager.popover({ msg: '�ƻ�ִ��ʱ������д������', type: 'error' });
		$("#QPCCInterventionTime").focus();
		return false;
	}	
	// ��������Ĭ�ϲ�ѯ״̬ ״̬��0��δֹͣ 1����ֹͣ 2���ѳ��� 3�������ϣ�
	var QPCCNursePlanSearchStatus=($("#QPCCNursePlanSearchStatus_00").checkbox('getValue')?"0":"")+"^"+
								  ($("#QPCCNursePlanSearchStatus_01").checkbox('getValue')?"1":"")+"^"+
								  ($("#QPCCNursePlanSearchStatus_02").checkbox('getValue')?"2":"")+"^"+
								  ($("#QPCCNursePlanSearchStatus_03").checkbox('getValue')?"3":"")
	
	// ����Ĭ�ϲ�ѯ״̬ (0��δ���� 1��������)
	var QPCCNurEvaluateSearchStatus=($("#QPCCNurEvaluateSearchStatus_00").checkbox('getValue')?"0":"")+"^"+
								    ($("#QPCCNurEvaluateSearchStatus_01").checkbox('getValue')?"1":"")
	

	// ������ѯĬ��ʱ������
	// ��ʼ����
	var QPCCInterventionStartDate=$("#QPCCInterventionStartDate").val();

	//�ж��Ƿ�Ϊ���ָ�ʽ
	var r1 = /^[0-9]+?$/;����//�Ǹ�����(������+0)
	var r2 =/^-[1-9]\d*$/;   //������  �������3086317
	var flag_1 = r1.test(QPCCInterventionStartDate)||r2.test(QPCCInterventionStartDate);
	if ((QPCCInterventionStartDate!="")&&(!flag_1)) {
		$.messager.popover({ msg: '��ʼ��������д������', type: 'error' });
		$("#QPCCInterventionStartDate").focus();
		return false;
	}	
	// ��ʼʱ��
	var QPCCInterventionStartTime=$("#QPCCInterventionStartTime").timespinner('getValue');
	// ��������
	var QPCCInterventionEndDate=$("#QPCCInterventionEndDate").val();
	var flag_2 = r1.test(QPCCInterventionEndDate)||r2.test(QPCCInterventionEndDate);
	if ((QPCCInterventionEndDate!="")&&(!flag_2)) {
		$.messager.popover({ msg: '������������д������', type: 'error' });
		$("#QPCCInterventionEndDate").focus();
		return false;
	}
	if ((QPCCInterventionStartDate!="")&&(QPCCInterventionEndDate!="")&&(QPCCInterventionEndDate<QPCCInterventionStartDate)) {
		$.messager.popover({ msg: '��������Ӧ��С�ڿ�ʼ���ڣ�', type: 'error' });
		$("#QPCCInterventionEndDate").focus();
		return false;
	}	
	// ����ʱ��
	var QPCCInterventionEndTime=$("#QPCCInterventionEndTime").timespinner('getValue');
	
	// ��������ɫ����

	// ��������ɫ����
	var QPCCLongTermInterventionColor = $("#QPCCLongTermInterventionColor").color("getValue");
	// ��������ɫ����
	var QPCCTemporaryInterventionColor = $("#QPCCTemporaryInterventionColor").color("getValue");
	// ����ƻ�����ӡ���ƿ���
	var QPCCNursePlanPrintStatusLimit=($("#QPCCNursePlanPrintStatusLimit_00").checkbox('getValue')?"00":"")+"^"+
								  ($("#QPCCNursePlanPrintStatusLimit_01").checkbox('getValue')?"01":"")+"^"+
								  ($("#QPCCNursePlanPrintStatusLimit_Limit").checkbox('getValue')?"Limit":"");
	// Ĭ�ϴ�ӡ��������
	var QPCCNursePlanPrintStatus= ($("#QPCCNursePlanPrintStatus_00").checkbox('getValue')?"00":"")+"^"+
								  ($("#QPCCNursePlanPrintStatus_01").checkbox('getValue')?"01":"")+"^"+
								  ($("#QPCCNursePlanPrintStatus_02").checkbox('getValue')?"02":"")+"^"+
								  ($("#QPCCNursePlanPrintStatus_03").checkbox('getValue')?"03":"")+"^"+
								  ($("#QPCCNursePlanPrintStatus_04").checkbox('getValue')?"04":"")+"^"+
								  ($("#QPCCNursePlanPrintStatus_05").checkbox('getValue')?"05":"");
	// 2023.02.09 add
	//����ƻ�ת�ƴ�ӡ����
	var QPCCNurPlanTransPrintRule = $("#QPCCNurPlanTransPrintRule_1").checkbox('getValue') ? "THIS" : "ALL";	
	//����ƻ���ӡģ��
	var QPCCNurPlanPrintTemplate=$("#QPCCNurPlanPrintTemplate").val()
	
	
	// �Ƿ���л������ۣ�����Ϊ����������������/ֹͣ���� ѡ������
    var QPCCOpenNurEvaluate = $("#QPCCOpenNurEvaluate_1").checkbox('getValue') ? "Y" : "N";
    if (QPCCOpenNurEvaluate=="N"){
	    // ֹͣ�����ڻ�������
	    var QPCCStopApplyToQuestion="Y"
	}else{
		var QPCCStopApplyToQuestion="N"
	}
    // ֹͣ�����ڻ����ʩ
    var ApplyToQuestionMeasure = $("#ApplyToQuestionMeasure").checkbox('getValue') ? "Y" : "N";
    if ((QPCCOpenNurEvaluate=="N")&&(ApplyToQuestionMeasure=="Y")){
		var QPCCStopApplyToQuestionMeasure ="Y"
    }else {
	    var QPCCStopApplyToQuestionMeasure ="N"
	}
	//ת��ԭ������ ��@�ָ�	
	var QPCCTransReason=$("#QPCCTransReason").val();
	
	// �ƻ��ύʱ�Ƿ�Ĭ�Ϲ�ѡת�뻤����
	var QPCCOpenNurPlanTrans = $("#QPCCOpenNurPlanTrans_1").checkbox('getValue') ? "Y" : "N";

	// ��������ʱ�Ƿ�Ĭ�Ϲ�ѡת�뻤����
	var QPCCOpenNurEvaluateTrans = $("#QPCCOpenNurEvaluateTrans_1").checkbox('getValue') ? "Y" : "N";

	// ����ֹͣʱ�Ƿ�Ĭ�Ϲ�ѡת�뻤���� 
	var QPCCOpenNurQuestionStopTrans = $("#QPCCOpenNurQuestionStopTrans_1").checkbox('getValue') ? "Y" : "N";

	// �ƻ��ύʱת�뻤���¼��ʽ
	var QPCCNurPlanTransFormat=$("#QPCCNurPlanTransFormat").val();
	
	// ����ִ��ʱת�뻤���¼��ʽ
	var QPCCNurTaskTransFormat=$("#QPCCNurTaskTransFormat").val();

	// ��������ʱת�뻤���¼��ʽ
	var QPCCNurEvaluateTransFormat=$("#QPCCNurEvaluateTransFormat").val();

	// ����ֹͣʱת�뻤���¼��ʽ
	var QPCCNurQuestionStopTransFormat=$("#QPCCNurQuestionStopTransFormat").val();

	// ����ִ��ʱ�Ƿ�Ĭ�Ϲ�ѡת�뻤����
	var QPCCOpenNurExecuteTrans = $("#QPCCOpenNurExecuteTrans_1").checkbox('getValue') ? "Y" : "N";
	// ɾ����������
	var QPCCDeleteRules=$("#QPCCDeleteRules_1").checkbox('getValue') ? "NotL" : ($("#QPCCDeleteRules_2").checkbox('getValue')?"TaskF":"EmrF");

	// �ƻ����û������� ���ͣ�0:�ؼ�����,1:һ������,2:��������,3:�������� ��
	var QPCCNursePlanPatientStatus=($("#QPCCNursePlanPatientStatus_00").checkbox('getValue')?"^0":"")+
								  ($("#QPCCNursePlanPatientStatus_01").checkbox('getValue')?"^1":"")+
								  ($("#QPCCNursePlanPatientStatus_02").checkbox('getValue')?"^2":"")+
								  ($("#QPCCNursePlanPatientStatus_03").checkbox('getValue')?"^3":"")
	/*
    // 2022.08.30 add
    if ((QPCCOpenNurEvaluate=="N")&&(QPCCStopApplyToQuestion=="N")){
	    if (QPCCOpenNurEvaluate=="N") $.messager.popover({ msg: '��ѡ����л������ۣ�', type: 'error' });
		if (QPCCStopApplyToQuestion=="N") $.messager.popover({ msg: '���ڼƻ��쳣���������й�ѡֹͣ�������⣡', type: 'error' });
		
        return false;
	}
	*/
	// ����ִ��ʱת�뻤���¼���ͣ�Y:ͨ�á�N:���Ի���
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
	        //$.messager.popover({ msg: '����ɹ���', type: 'success' });
		    //ֹͣ/���۽������(����)
		    setTimeout(SaveResultConfig,1000);
		    CascadeConfig();
        } else {
            $.messager.popover({ msg: '����ʧ�ܣ�' + rtn, type: 'error' });
        }
    })
}
function ResetDomSize() {
	var TabsWidth = $("#NurPlanTransTabs").width()
	$("#patientList").panel('resize', {
		width: TabsWidth-100
	});
}

//����ִ��ʱת�벡����ʽ�����޸�
function NurExecuteTrans(){
	var QPCCNurExecuteTransCommon = $("#QPCCNurExecuteTransCommon_1").checkbox('getValue') ? "Y" : "N";
	if (QPCCNurExecuteTransCommon=="Y"){
		$("#KW_NurTaskTransFormat").style.visibility="visible";//��ʾ
		$("#QPCCNurTaskTransFormat").show();
		//InitFormatKeywords()
	}else{
		var FormatHeight=$("#QPCCNurTaskTransFormat").height()+$("#KW_NurPlanTransFormat").height();
        var FormatWidth=$("#QPCCNurTaskTransFormat").width();        
        var html = '<textarea id="transtooltip" class="hisui-textbox textbox" style="width:'+FormatWidth+'px;height:'+FormatHeight+'px" >'+$g("����ִ��ʱ���Ի�ת�벡����ʽȡֵ:��ʩ��������-��������-������������")+'</textarea>'
        if ($("#transtooltip").length<=0){
	        $("#QPCCNurTaskTransFormat").after(html);
        	$("#transtooltip").attr("disabled",true);
        }else{
	        $("#transtooltip").show();
	    }
        $("#KW_NurTaskTransFormat").style.visibility="hidden";//����
        $("#QPCCNurTaskTransFormat").hide();
	}
}