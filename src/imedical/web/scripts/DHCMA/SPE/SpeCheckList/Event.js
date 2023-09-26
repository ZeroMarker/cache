//页面Event
function InitSpeCheckListWinEvent(obj){	
    
    obj.LoadEvent = function(args){ 
		//查询
		$('#btnQuery').on('click', function(){	
			obj.SpeCheckListLoad();
		});
		
		//登记号回车查询事件
		$('#txtRegNo').keydown(function (e) {
			var e = e || window.event;
			if (e.keyCode == 13) {
				RegNo=$('#txtRegNo').val().replace(/(^\s*)|(\s*$)/g, "");
				if ($.trim(RegNo)=="") return;
				var Reglength=RegNo.length
				for(var i=0;i<(10-Reglength);i++)
				{
					RegNo="0"+RegNo;
				}
				$('#txtRegNo').val(RegNo);
				obj.SpeCheckListLoad();
			}	
		});

		//姓名回车查询事件
		$('#txtPatName').keydown(function (e) {
			var e = e || window.event;
			if ($.trim($('#txtPatName').val())=="") return;
			if (e.keyCode == 13) {
				obj.SpeCheckListLoad();
			}
		});
		
		//状态选择事件
		$HUI.combobox("#cboQryStatus", {
			onSelect:function(){
				obj.SpeCheckListLoad();
			}
		});
		
		//科室选择事件
		$HUI.combobox("#cboLoc", {
			onSelect:function(){
				obj.SpeCheckListLoad();
			}
		});
		//患者类型选择事件
		$HUI.combobox("#cboPatType", {
			onSelect:function(){
				obj.SpeCheckListLoad();
			}
		});
    }
    
    obj.DisplaySpeCheckWin = function (SpeID,EpisodeID) {	 
		var strUrl = "./dhcma.spe.spemark.csp?1=1" + 
						"&SpeID=" + SpeID + 
						"&EpisodeID=" + EpisodeID + 
						"&OperTpCode=" + OperTpCode;
	     websys_showModal({
			url:strUrl,
			title:'标记特殊患者',
			iconCls:'icon-w-star',  
			//onBeforeClose:function(){alert('close')},
			dataRow:{SpeID:SpeID,EpisodeID:EpisodeID},   //？
	        originWindow:window,
			width:400,
			height:545
		});
    }
  
	obj.OpenSpeNewsWin =function(SpeID,EpisodeID) {		
	    var strUrl = "./dhcma.spe.spenews.csp?1=1" + 
						"&SpeID=" + SpeID + 
						"&OperTpCode=" + OperTpCode;
							   
        websys_showModal({
			url:strUrl,
			title:'消息列表',
			iconCls:'icon-w-msg',  
			onBeforeClose:function(){
				$('#SpeCheckList').datagrid('reload'); //刷新
			},
			dataRow:{SpeID:SpeID,EpisodeID:EpisodeID},   //？
	        originWindow:window,
			width:850,
			height:520
		});
   
    }
	
    obj.SpeCheckListLoad = function(){	
	    var DateFrom = $('#DateFrom').datebox('getValue');
		var DateTo = $('#DateTo').datebox('getValue');
		var QrySatatus = $('#cboQryStatus').combobox('getValue');
		if ((DateFrom == '')||(DateTo == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!",'info');
			return;
		}
		if (Common_CompareDate(DateFrom,DateTo)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!",'info');
			return;
		}
		if ($.trim(QrySatatus) =='') {
			$.messager.alert("提示","状态不允许为空，请选择状态!",'info');
			return;
		}
		obj.gridSpeCheckList.load({
		    ClassName:"DHCMed.SPEService.PatientsQry",
			QueryName:"QrySpeCheckList",		
			aQryStatus: $('#cboQryStatus').combobox('getValue'),
			aOperTpCode: OperTpCode,
			aHospID: $('#cboSSHosp').combobox('getValue'), 
			aDateFrom: $('#DateFrom').datebox('getValue'), 
			aDateTo: $('#DateTo').datebox('getValue'), 
			aPatType: $('#cboPatType').combobox('getValue'), 
			aLocID: $('#cboLoc').combobox('getValue'), 
			aRegNo:$('#txtRegNo').val(),
			aPatName:$('#txtPatName').val()	
	    });		       
    }
 
}