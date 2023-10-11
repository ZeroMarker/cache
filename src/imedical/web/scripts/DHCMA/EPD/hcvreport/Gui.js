function InitReportWin(){
	var obj = new Object();
	obj.ReportID = ReportID;
	/* 根据医生站传递的参数获取病人的基本信息，载入当前报告对应的表单项 */
	obj.LoadPatInfo = function() {
		var HCVPatInfo = ServerObj.HCVPatInfo.split('^');
		var PatientName = HCVPatInfo[2];
		var Sex = HCVPatInfo[3];
		var Age = HCVPatInfo[4];
	    var Birthday = HCVPatInfo[5];
	    $('#txtPatName').val(PatientName);
	    $('#txtPatSex').val(Sex);	            					// 性别
		$('#txtAge').val(Age);	            					// 年龄
		$('#dtBirthday').datebox('setValue',Birthday);
	}
	//加载下拉框等字典信息
	obj.LoadDicInfo = function() {
		//文化程度
		obj.cboEducation =Common_ComboToDic("cboEducation","HCVEducation");		
		//婚姻状况
		obj.cboMarrige =Common_ComboToDic("cboMarrige","HCVSexWed");		
		//个人月收入
	    obj.cboPerMonIncome = Common_ComboToDic("cboPerMonIncome","HCVPerMonIncome");   		
	    //医保类型    
	    obj.cboMedInsType = Common_ComboToDic("cboMedInsType","HCVMedInsType"); 
	    //首次抗体阳性实验室检测主要原因
	    obj.RadTestReason = RadioToDic("RadTestReason","HCVTestReason",4,"txtTestReason"); 
	    //首次抗体检测阳性方法
	    obj.cboTestMethod = Common_ComboToDic("cboTestMethod","HCVTestPosMethod"); 
	    //抗体复检方法
	    obj.cboRechMethod = Common_ComboToDic("cboRechMethod","HCVTestPosMethod"); 
	    //抗体复检结果
	    obj.cboResults = Common_ComboToDic("cboResults","HCVLabResult"); 
	    //转介结果
	    obj.cboReferResult = Common_ComboToDic("cboReferResult","HCVReferResult"); 
	    //未治疗原因
	    obj.RadUntreated = RadioToDic("RadUntreated","HCVUntreated",4,"txtUntreated"); 

	    //监听事件
	    obj.ListenEvent();
	}

    //加载监听事件
    obj.ListenEvent = function() {
	    //下拉框事件    医保类型
	    $HUI.combobox('#cboMedInsType', {
			onChange:function(newValue,oldValue){
				setTimeout(function(){	
					var Desc=$('#cboMedInsType').combobox('getText');
					if (Desc==$g("其他")){	
						$('#txtMedInsType').removeAttr("disabled");
		            }else{
			            $('#txtMedInsType').val('');
		                $('#txtMedInsType').attr('disabled','disabled');
		            }
	            },100);
			}
		});
		//转介结果
		$HUI.combobox('#cboReferResult', {
			onChange:function(newValue,oldValue){
				setTimeout(function(){	
				var Desc=$('#cboReferResult').combobox('getText');
					if (Desc==$g("到医院启动抗病毒治疗")){	
						//治疗日期可编辑
						$('#dtTreatmentDate').datebox('enable');
						//未治疗原因不可编辑
						$("[name='RadUntreated']").radio('setValue',false);					
						$("[name='RadUntreated']").radio('disable');					
		            } else if  (Desc==$g("到医院未启动抗病毒治疗")) {
						$("[name='RadUntreated']").radio('enable');					
						//治疗日期不可编辑
						$('#dtTreatmentDate').datebox('clear');
						$('#dtTreatmentDate').datebox('disable');
		            } else{
			            $('#dtTreatmentDate').datebox('clear');
		                $('#dtTreatmentDate').datebox('disable');
						$("[name='RadUntreated']").radio('setValue',false);					
						$("[name='RadUntreated']").radio('disable');					
		            }
	            },100);
			}
		});
		
		// ****************************** ↓↓↓ 单选框事件 
	    $HUI.radio("[name='RadTestReason']",{  	//首次抗体阳性实验室检测主要原因
	        onChecked:function(e,value){	      
	            var RadTestReason = $(e.target).attr("label"); //当前选中的值
	            if (RadTestReason==$g('其他')) {   
					$('#txtTestReason').removeAttr("disabled");
	            }else{
		            $('#txtTestReason').val('');
	                $('#txtTestReason').attr('disabled','disabled');
	            }
	        }
	    });
	    
	    $HUI.radio("[name='IsRecheck']",{  //未做抗体复检
	        onChecked:function(e,value){
	            var IsRecheck = $(e.target).val(); //当前选中的值
	            if (IsRecheck==0) {
		            //复检日期清空并设置不可编辑
		            $('#dtRecheckDate').datebox('setValue','');	  
	                $('#dtRecheckDate').datebox('disable');
	                //复检方法清空并设置不可选择
	                $('#cboRechMethod').combobox('clear'); 
					$('#cboRechMethod').combobox('disable');
	                //复检结果清空并设置不可选择
	                $('#cboResults').combobox('clear'); 
					$('#cboResults').combobox('disable');
	            } else {
		            //复检日期设置可编辑
	                $('#dtRecheckDate').datebox('enable');	
	                $('#cboRechMethod').combobox('enable');	     
	                $('#cboResults').combobox('enable');       
	            }
	        }
	    });

	    $HUI.radio("[name='IsCheck']",{  //未做采血
	        onChecked:function(e,value){
	            var IsCheck = $(e.target).val(); //当前选中的值
	            if (IsCheck==0) {
		            $('#dtBloodDate').datebox('setValue','');
	                $('#dtBloodDate').datebox('disable');
	            } else {
	                $('#dtBloodDate').datebox('enable');		            
	            }
	        }
	    });
	    
	    $HUI.radio("[name='IsRefer']",{  //未转介
	        onChecked:function(e,value){
	            var IsRefer = $(e.target).val(); //当前选中的值
	            if (IsRefer==0) {
		            //转介日期清空并不可编辑
		            $('#dtReferDate').datebox('setValue','');
	                $('#dtReferDate').datebox('disable');
	                //转介结果清空并设置不可选择
	                $('#cboReferResult').combobox('clear'); 
					$('#cboReferResult').combobox('disable');
					//治疗日期不可编辑
					$('#dtTreatmentDate').datebox('clear');
					$('#dtTreatmentDate').datebox('disable');
					//未治疗原因不可编辑
            		$('#RadUntreated').radio('disable');          
	            } else {
		            $('#dtReferDate').datebox('enable');
					$('#cboReferResult').combobox('enable');
	            }
	        }
	    });
	    
	    $HUI.radio("[name='RadNucleinRet']",{  //丙肝核酸检测结果（是阴性则填写病毒载量）
	        onChecked:function(e,value){
	            var RadNucleinRet = $(e.target).attr("label"); //当前选中的值
	            if (RadNucleinRet==$g('阳性')) {
					$('#txtNucleinRet').removeAttr("disabled");
	            }else{
		            $('#txtNucleinRet').val('');
	                $('#txtNucleinRet').attr('disabled','disabled');
	            }
	        }
	    });
	    	    
	    $HUI.radio("[name='RadUntreated']",{  //未治疗原因
	        onChecked:function(e,value){
	            var RadUntreated = $(e.target).attr("label"); //当前选中的值
	            if (RadUntreated==$g('其他')) {   
					$('#txtUntreated').removeAttr("disabled");
	            }else{
		            $('#txtUntreated').val('');
	                $('#txtUntreated').attr('disabled','disabled');
	            }
	        }
	    });
	    // ****************************** ↑↑↑ 单选框事件
    }
function RadioToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	var otxtResume = arguments[3];
	var strDicList =$m({
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicsByType",
		aType:DicType,
		aActive:1
	},false);
	
	var dicList = strDicList.split(String.fromCharCode(1));
    var len = dicList.length;
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
	var listHtml=""
	for (var index =0; index< count; index++) {
		var radlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < radlen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			var TempHTML = ""
			if (dicSubList[1]==$g("其他")){
				TempHTML +=  '<input id='+otxtResume+' style="margin:0px 0px 0px 10px;" class="textbox" disabled >'
			}
			listHtml += "<div style='float:left;width:"+per+";padding-top:10px;'><input id="+ItemCode+dicSubList[0]+" type='radio' class='hisui-radio' "+(dicSubList[0]==1? "checked='checked'":"")+" label="+dicSubList[1]+" name="+ItemCode+" value="+dicSubList[0]+">"+TempHTML+"</div>";
			
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
    $.parser.parse('#'+ItemCode);  //解析radio
}

    InitReportWinEvent(obj);
	obj.LoadEvent();
	return obj;

}