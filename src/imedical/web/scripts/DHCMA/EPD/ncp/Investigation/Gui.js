$(function () {
	InitReportWin();
});

function InitReportWin(){
	var obj = new Object();
	obj.reportID = ReportID;
	obj.SatusCode = "";
	obj.CurrReport = null;
	obj.DelListSample = "";
	obj.SampleRowID = "";
    obj.SymPtomList = ServerObj.SymPtomList;
	obj.EpidemicList = ServerObj.EpidemicList;
	obj.EpdID = ServerObj.EpdID;
	
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    } 

	if (EpisodeID=="" || PatientID=="") {
		$.messager.alert($g("提示"), $g("患者信息不存在!"),'info');
		return;
	}
	if (obj.EpidemicList=="") {
		$.messager.alert($g("提示"), $g("患者没有有效的新冠肺炎相关传染病报告，请先填写传染病报告!"),'info');
		return;
	}

    //加载症状与体征
	obj.BuildSign = function() {
		$('#chkSymPtoms').append(obj.SymPtomList);
		$.parser.parse('#chkSymPtoms');
	}
    
    //加载字典
	obj.LoadDicInfo = function() {
  		//胸部Ｘ线检测是否有肺炎影像学特征
		obj.cboChestXray = Common_ComboToDic("cboChestXray","NCPTestResult","",session['LOGON.HOSPID']);
		//胸部CT检测是否有肺炎影像学特征
		obj.cboChestCT = Common_ComboToDic("cboChestCT","NCPTestResult","",session['LOGON.HOSPID']);
		 //特定职业
        obj.cboOccupation = Common_ComboToDic("cboOccupation","NCPOccupation","",session['LOGON.HOSPID']);
	    //旅居史    
        obj.cboTravelLive = Common_ComboToDic("cboTravelLive","NCPTravelLive","",session['LOGON.HOSPID']);
        //是否有聚集性发病
        obj.cboGather = Common_ComboToDic("cboGather","NCPIsKnow","",session['LOGON.HOSPID']);
	    //居住地点(村庄/居民楼)周围是否有农贸市场
        obj.cboMarket = Common_ComboToDic("cboMarket","NCPIsKnow","",session['LOGON.HOSPID']);
        //是否去过农贸市场
        obj.cboIsMarket = Common_ComboToDic("cboIsMarket","NCPIsKnow","",session['LOGON.HOSPID']);
        //农贸市场
        obj.cboMarketType = Common_ComboToDic("cboMarketType","NCPMarketType","",session['LOGON.HOSPID']);
        //并发症
	    obj.chkComplication = Common_CheckboxToDic("chkComplication","NCPComplication",4);  
	    //既往病史
	    obj.chkPreAnamnesis = Common_CheckboxToDic("chkPreAnamnesis","NCPPreAnamnesis",2);  
		//标本类型
		obj.cboSampleType = Common_ComboToDic("cboSampleType","NCPSampleType","",session['LOGON.HOSPID']);
		//检测结果
		obj.cboSampleResult = Common_ComboToDic("cboSampleResult","NCPLabResult","",session['LOGON.HOSPID']);		
		//加载监听事件
		obj.ListenEvent();
	}	

	obj.gridSample = $HUI.datagrid("#gridSampleInfo",{
		title:$g('实验室检测（标本采集与新型冠状病毒检测情况）'),
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		columns:[[
			{field:'SampleTypeDesc',title:'样本类型',width:'300'},
			{field:'SampleDate',title:'采样日期',width:'200'},
			{field:'SampleResultDesc',title:'检验结果',width:'300'}
		]],
		onSelect:function(rindex,rowData){
			if (obj.SampleRowID === rindex) {
				obj.SampleRowID="";
				obj.clearSampleData();  //清除选中行
			} else {
				obj.SampleRowID = rindex;
				obj.gridSample_rowclick();
			}	
		}
	});
	
	//加载监听事件
    obj.ListenEvent = function() {
	    //症状与体征
	    $HUI.checkbox("[name='chkSymPtoms']",{  
			onCheckChange:function(e,value){
				var SymPtoms = $(e.target).attr("label");   //当前选中的值
				if (SymPtoms==$g('发热')) {
					if(value==false){
						$('#txtTemperature').val("");
						$('#txtTemperature').attr('disabled','disabled');
					}else{
						$('#txtTemperature').removeAttr('disabled');
					}
				}	
				if (SymPtoms==$g('其他')) {
					if(value==false){
						$('#txtSymPtom').val("");
						$('#txtSymPtom').attr('disabled','disabled');
					}else{
						$('#txtSymPtom').removeAttr('disabled');
					}
				}			
			}
		});
		         
	    $HUI.checkbox("[name='chkComplication']",{  
			onCheckChange:function(e,value){
				var Complication = $(e.target).attr("label");   //当前选中的值
				if (Complication==$g('其他')) {
					if(value==false){
						$('#txtComplication').val("");
						$('#txtComplication').attr('disabled','disabled');
					}else{
						$('#txtComplication').removeAttr('disabled');
					}
				}			
			}
		});
        
	    $HUI.checkbox("[name='chkPreAnamnesis']",{  
			onCheckChange:function(e,value){
				var PreAnamnesis = $(e.target).attr("label");   //当前选中的值		
				if (PreAnamnesis==$g('无')) {
					if(value==false){
						$("[name='chkPreAnamnesis']").checkbox('enable');
					}else {
						$('#txtPreAnamnesis').val("");
						$("[name='chkPreAnamnesis']").checkbox('setValue',false);
						$("[name='chkPreAnamnesis']").checkbox('disable');
						$("[name='chkPreAnamnesis']:checked").checkbox('enable');
					}
				}
				if (PreAnamnesis==$g('其他')) {
					if(value==false){
						$('#txtPreAnamnesis').val("")
						$('#txtPreAnamnesis').attr('disabled','disabled');
					}else{
						$('#txtPreAnamnesis').removeAttr('disabled');
					}
				}			
			}
		});       	
    	
    	// ****************************** ↓↓↓ 单选框事件
	    $HUI.radio("[name='IsComplication']",{  //有无并发症
	        onChecked:function(e,value){
	            var IsComplication = $(e.target).val(); //当前选中的值
	            if (IsComplication==1) {
	                $("[name='chkComplication']").checkbox('enable');
	            }else{
	                $("[name='chkComplication']").checkbox('setValue',false);
	                $("[name='chkComplication']").checkbox('disable');
	            }
	        }
	    });
	    
		$HUI.radio("[name='IsBloodTest']",{ //血常规检查是否检测选项触发事件
	        onChecked:function(e,value){
	            var IsBloodTest = $(e.target).val(); //当前选中的值
	            if (IsBloodTest==1) { 
	                $('#dtBloodTestDate').datebox('enable');
	                $('#numWBC').removeAttr("disabled");
	                $('#numLymphocyte').removeAttr("disabled");
	                $('#numLymphocytePer').removeAttr("disabled");
	                $('#numNePer').removeAttr("disabled");
	            }else{
		            $('#dtBloodTestDate').datebox('clear');
	                $('#numWBC').val('');
	                $('#numLymphocyte').val('');
	                $('#numLymphocytePer').val('');
	                $('#numNePer').val('');
	                $('#dtBloodTestDate').datebox('disable');
	                $('#numWBC').attr('disabled','disabled');
	                $('#numLymphocyte').attr('disabled','disabled');
	                $('#numLymphocytePer').attr('disabled','disabled');
	                $('#numNePer').attr('disabled','disabled');
	            }
	        }
	    });
	    
	    $HUI.radio("[name='IsMedical']",{ //发病后是否就诊选项触发事件
	        onChecked:function(e,value){
	            var IsMedical = $(e.target).val(); //当前选中的值
	            if (IsMedical==1) { 
	                $('#dtFirstAdmDate').datebox('enable');
	                $('#txtAdmHospital').removeAttr("disabled");
	            }else{
		            $('#dtFirstAdmDate').datebox('clear');
		            $('#txtAdmHospital').val('');
	                $('#dtFirstAdmDate').datebox('disable');
	                $('#txtAdmHospital').attr('disabled','disabled');
	            }
	        }
	    });
	    $HUI.radio("[name='IsIsolated']",{ //是否隔离选项触发事件
	        onChecked:function(e,value){
	            var IsIsolated = $(e.target).val(); //当前选中的值
	            if (IsIsolated==1) { 
	                $('#dtIsolatedDate').datebox('enable');
	            }else{
		            $('#dtIsolatedDate').datebox('clear');
	                $('#dtIsolatedDate').datebox('disable');
	            }
	        }
	    });
	    $HUI.radio("[name='IsInHosp']",{ //是否住院选项触发事件
	        onChecked:function(e,value){
	            var IsInHosp = $(e.target).val(); //当前选中的值
	            if (IsInHosp==1) { 
	                $('#dtInHospDate').datebox('enable');
	             }else{
		            $('#dtInHospDate').datebox('clear');
	                $('#dtInHospDate').datebox('disable');
	            }
	        }
	    });
	    $HUI.radio("[name='IsInICU']",{ //是否收住ICU治疗选项触发事件
	        onChecked:function(e,value){
	            var IsInICU = $(e.target).val(); //当前选中的值
	            if (IsInICU==1) { 
	                $('#dtInICUDate').datebox('enable');
	           }else{
		            $('#dtInICUDate').datebox('clear');
	                $('#dtInICUDate').datebox('disable');
	             }
	        }
	    });
	    // ****************************** ↑↑↑ 单选框事件
	   
	    // ****************************** ↓↓↓ 下拉框事件
	    $HUI.combobox('#cboChestXray', {
			onSelect:function(rd){
				var Desc = rd.DicDesc;
				if (Desc==$g("有")){	
					$('#dtChestXrayDate').datebox('enable');
	            }else{
		            $('#dtChestXrayDate').datebox('clear');
	                $('#dtChestXrayDate').datebox('disable');
	            }
			}
		});
		$HUI.combobox('#cboChestCT', {
			onSelect:function(rd){
				var Desc = rd.DicDesc;
				if (Desc==$g("有")){	
					$('#dtChestCTDate').datebox('enable');
	            }else{
		            $('#dtChestCTDate').datebox('clear');
	                $('#dtChestCTDate').datebox('disable');
	            }
			}
		});
		$HUI.combobox('#cboOccupation', {
			onSelect:function(rd){
				var Desc = rd.DicDesc;
				if (Desc==$g("其他")){	
					$('#txtOccupation').removeAttr("disabled");
	            }else{
		            $('#txtOccupation').val('');
	                $('#txtOccupation').attr('disabled','disabled');
	            }
			}
		});
		$HUI.combobox('#cboMarket', {
			onSelect:function(rd){
				var Desc = rd.DicDesc;
				if (Desc==$g("是")){	
					$('#txtDistance').removeAttr('disabled');
	            }else{
		            $('#txtDistance').val('');
	                $('#txtDistance').attr('disabled','disabled');
	            }
			}
		});
		$HUI.combobox('#cboIsMarket', {
			onSelect:function(rd){
				var Desc = rd.DicDesc;
				if (Desc==$g("是")){	
					$('#cboMarketType').combobox('enable'); 
				}else{
					$('#cboMarketType').combobox('clear'); 
					$('#cboMarketType').combobox('disable');
				}
			}
		});
	    // ****************************** ↑↑↑ 下拉框事件
    }

	InitReportWinEvent(obj);
	obj.LoadEvent();
	return obj;

}