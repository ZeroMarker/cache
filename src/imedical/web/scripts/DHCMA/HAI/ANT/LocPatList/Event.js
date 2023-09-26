//页面Event
function InitLocPatListWinEvent(obj){
	//页面初始化
	obj.LoadEvent = function(args){
		//查询按钮
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
	}
	
	//查询按钮
	obj.btnQuery_click = function(){		
		var tDateFrom=$('#dtDateFrom').datebox('getValue');
		var tDateTo=$('#dtDateTo').datebox('getValue');
		if ((tDateFrom!='')&&(tDateTo!='')) {
			var ret=Common_CompareDate(tDateFrom,tDateTo);
			if (ret>0) {
				$.messager.popover({msg: '开始日期不能大于结束日期！',type:'error',timeout: 1000})
				return;
			}
		} else {
			$.messager.popover({msg: '开始日期、结束日期不允许为空！',type:'error',timeout: 1000})
			return;
		}
		obj.gridLocPatListLoad();
	}
	
	//加载科室患者列表数据
	obj.gridLocPatListLoad = function(){
		obj.gridLocPatList.load({
			ClassName:'DHCHAI.ANTS.OrdAntiPatSrv',
			QueryName:'QryLocAntiPat',
			aDateFrom:$('#dtDateFrom').datebox('getValue'),
			aDateTo:$('#dtDateTo').datebox('getValue'),
			aLocDr:$.LOGON.LOCID,
			aAdmStatus: Common_CheckboxValue('chkAdmStatus'),
			aRegNo:$('#txtRegNo').val(),
			aMrNo:$('#txtMrNo').val(),
			aAntiMastDr:$('#cboAntiMast').combobox('getValue')
	    });
    }
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
				obj.gridLocPatListLoad();
			}
		});
	//上报按钮触发时间
	obj.btnReport_Click = function(aEpisodeID,aReportID,aOrdItemID,pindex){
		var strUrl = "./dhcma.hai.ant.report.csp?1=1"+
			"&EpisodeID=" + aEpisodeID + 
			"&ReportID=" + aReportID +
			"&OrdItemID=" + aOrdItemID +				   
			"&LocFlag=" + 1;
		
	    websys_showModal({
			url:strUrl,
			title:'碳青霉烯/替加环素类抗菌药物用药申请表',
			iconCls:'icon-w-epr',
	        originWindow:window,
			width:1340,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				var expander = $('#gridLocPatList').datagrid('getExpander',pindex);  //获取展开行
				if(expander.length && expander.hasClass('datagrid-row-collapse')){
					$('#gridLocPatList').datagrid('collapseRow',pindex); //折叠
					$('#gridLocPatList').datagrid('expandRow',pindex);   //展开			
					
					$('#gridAntiDrugList'+pindex).datagrid('reload');   //刷新	
				}	
			}
		});
	}
	
}