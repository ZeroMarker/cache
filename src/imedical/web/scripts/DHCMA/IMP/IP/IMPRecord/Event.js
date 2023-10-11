//页面Event
function InitCCScreeningWinEvent(obj){	
    //弹出加载层
	function loadingWindow() {	
	    var left = ($(window).outerWidth(true)) / 2; 
		var top = ($(window).height() - 35) / 2; 
		var height = $(window).height() * 2; 
 		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height,opacity: .7,'z-index': 5000}).appendTo("#divScreen"); 
 		$("<div class=\"datagrid-mask-msg\"></div>").html($g('数据加载中,请稍候...')).appendTo("#divScreen").css({ display: "block", left: left, top: top }); 
	}
	
	//弹出加载层
	function loadingWindow2() {	
	    var left = ($(window).outerWidth(true)) / 2; 
		var top = ($(window).height() - 35) / 2; 
		var height = $(window).height() * 2; 
 		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height ,opacity: .7,'z-index': 5000}).appendTo("#divScreen"); 
 		$("<div class=\"datagrid-mask-msg\"></div>").html($g('数据同步中,请稍候...')).appendTo("#divScreen").css({ display: "block", left: left, top: top }); 
	}
	
	//取消加载层  
	function disLoadWindow() {
	    $(".datagrid-mask").remove();
	    $(".datagrid-mask-msg").remove();
	}
	
    obj.LoadEvent = function(args){ 	   
		if (LocFlag==1) {	//临床科室 
			obj.gridAdmInfo();   //加载临床科室患者明细
			obj.gridAdmInfoLoad();
			$('#divAccordion').accordion({
				onSelect:function(title,index){
					if (index==1){
						//obj.gridDutyList();  //加载责任患者列表
						//obj.gridDutyListLoad();
					}else{
						obj.gridAdmInfo();
						obj.gridAdmInfoLoad();
					}
				}
			});
		}
	    

		//更多按钮
		$('#btnMore').on('click', function(){ 	
			if ($(this).hasClass('expanded')){  //已经展开 隐藏
				$(this).removeClass('expanded');
				$("#btnMore")[0].innerText=$g('更多');
				$('#MSearchItem').css('display','none');
				if (LocFlag==1) {
					obj.gridAdmInfoLoad();        //重新加载临床科室患者明细
				}else {
					obj.gridLocInfLoad();         //加载感染科室疑似筛查汇总  
				}
			}else{
				$(this).addClass('expanded');
				$("#btnMore")[0].innerText=$g('隐藏');
				$('#MSearchItem').css('display','block');
				if (LocFlag==1) {
					obj.gridAdmInfoLoad();        //重新加载临床科室患者明细
				}else {
					obj.gridLocInfLoad();         //加载感染科室疑似筛查汇总  
				}
			}
		});
		
		
		//日期改变事件
		$('#aDateFrom').datebox({
			onChange: function(newValue, oldValue){
				var aDateTo = $('#aDateTo').datebox('getValue');
				
				if (Common_CompareDate(newValue,aDateTo)>0) {
					$HUI.tooltip("#DateTip",{
						content: $g('开始日期不能大于结束日期'),
						position:'bottom'
					}).show();
					return;
				}
				if (Common_CompareDate(newValue,Common_GetDate(new Date()))>0) {
					$HUI.tooltip("#DateTip",{
						content: $g('开始日期不能大于当前日期'),
						position:'bottom'
					}).show();
					
					return;
				}
				
				$HUI.tooltip("#DateTip").destroy();
				
				$('#divMain').empty();           //清空主区域内容
				$('#divNoResult').attr("style","display:block");
				$('#aPatName').val('');
				$('#aRegNo').val('');
				$('#aMrNo').val('');
				$('#aBed').val('');
					if (LocFlag==1) {
					obj.gridAdmInfoLoad();        //重新加载临床科室患者明细
				}else {
					obj.gridLocInfLoad();         //加载感染科室疑似筛查汇总  
				}        
			}
		});
		
		//病历浏览
		obj.btnEmrRecord_Click = function(EpisodeID,PatientID)
		{		
			debugger;
			//var url = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';
			var url= "./dhcma.imp.ip.impemrrecord.csp?1=1&EpisodeID=" + EpisodeID +"&PatientID="+PatientID ;		
			websys_showModal({
				url:url,
				title:$g('病历浏览'),
				iconCls:'icon-w-epr',
				closable:true,
				originWindow:window,
				width:window.screen.availWidth-40,
				height:window.screen.availHeight-80,
			});
			//showFullScreenDiag(url,"电子病历",1);
		};
		
		//日期改变事件
		$('#aDateTo').datebox({
			onChange: function(newValue, oldValue){
				var aDateFrom = $('#aDateFrom').datebox('getValue');
		       
				if (Common_CompareDate(aDateFrom,newValue)>0) {	
					$HUI.tooltip("#DateTip",{
						content: $g("开始日期不能大于结束日期"),
						position:'bottom',
						hideDelay: 1000
					}).show();
					return;
				}
				
				$HUI.tooltip("#DateTip").destroy();
				
				$('#divMain').empty();           //清空主区域内容
				$('#divNoResult').attr("style","display:block");
				$('#aPatName').val('');
				$('#aRegNo').val('');
				$('#aMrNo').val('');
				$('#aBed').val('');
				if (LocFlag==1) {
					obj.gridAdmInfoLoad();        //重新加载临床科室患者明细
				}else {
					obj.gridLocInfLoad();         //加载感染科室疑似筛查汇总  
				}         
			}
		});
		
		//姓名回车事件
		$('#aPatName').bind('keydown', function (e) {
			var theEvent = window.event || e;
			var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
			if (code == 13) {
				$('#divMain').empty();           //清空主区域内容
				$('#divNoResult').attr("style","display:block");
				$('#aRegNo').val('');
				$('#aMrNo').val('');
				$('#aBed').val('');
				if (LocFlag==1) {
					obj.gridAdmInfoLoad();        //重新加载临床科室患者明细
				}else {
					obj.gridLocInfLoad();         //加载感染科室疑似筛查汇总  
				}     
			}
		});
		
		//登记号回车事件
		$('#aRegNo').bind('keydown', function (e) {
			var theEvent = window.event || e;
			var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
			
			if (code == 13) {
				RegNo=$('#aRegNo').val().replace(/(^\s*)|(\s*$)/g, "");
				if ($.trim(RegNo)){
					var Reglength=RegNo.length;
					for(var i=0;i<(10-Reglength);i++){
						RegNo="0"+RegNo;
					}
				}
				$('#aRegNo').val(RegNo);
				$('#divMain').empty();           //清空主区域内容
				$('#divNoResult').attr("style","display:block");
				$('#aPatName').val('');
				$('#aMrNo').val('');
				$('#aBed').val('');
				if (LocFlag==1) {
					obj.gridAdmInfoLoad();        //重新加载临床科室患者明细
				}else {
					obj.gridLocInfLoad();         //加载感染科室疑似筛查汇总  
				}        
			}
		});
		
		//病案号回车事件
		$('#aMrNo').bind('keydown', function (e) {
			var theEvent = window.event || e;
			var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
			if (code == 13) {
				MrNo=$('#aMrNo').val().replace(/(^\s*)|(\s*$)/g, "");
			    if ($.trim(MrNo)){
					var Mrlength=MrNo.length;
					for(var i=0;i<(6-Mrlength);i++) {
						MrNo="0"+MrNo;
					}
				}
				$('#aMrNo').val(MrNo);
				$('#divMain').empty();           //清空主区域内容
				$('#divNoResult').attr("style","display:block");
				$('#aPatName').val('');
				$('#aRegNo').val('');
				$('#aBed').val('');
				if (LocFlag==1) {
					obj.gridAdmInfoLoad();        //重新加载临床科室患者明细
				}else {
					obj.gridLocInfLoad();         //加载感染科室疑似筛查汇总  
				}       
			}
		});
		
		//床号回车事件
		$('#aBed').bind('keydown', function (e) {
			var theEvent = window.event || e;
			var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
			if (code == 13) {
				$('#divMain').empty();           //清空主区域内容
				$('#divNoResult').attr("style","display:block");
				$('#aPatName').val('');
				$('#aRegNo').val('');
				$('#aMrNo').val('');
				if (LocFlag==1) {
					obj.gridAdmInfoLoad();        //重新加载临床科室患者明细
				}else {
					obj.gridLocInfLoad();         //加载感染科室疑似筛查汇总  
				}
			}
		});		
	}
	
	//加载临床科室患者明细
	obj.gridAdmInfoLoad = function(){
		var aDateType ="0";
		var aCategory = "";
		if(LocFlag==1){
			aDateType ="0";
			aCategory = "";
		}else{
			aDateType =$('#cboDateType').combobox('getValue');
			aCategory = $('#cboCategory').combobox('getValue');
		}
		var PatInfo = $('#aPatName').val()+"^"+$('#aRegNo').val()+"^"+$('#aMrNo').val()+"^"+$('#aBed').val();
		/**
		$cm ({
			ClassName:'DHCMA.IMP.IPS.IMPRecordSrv',
			QueryName:'QryRecordPatList',
			aDateFrom:$('#aDateFrom').datebox('getValue'), 
			aDateTo:$('#aDateTo').datebox('getValue'), 
			aLocID:session['LOGON.CTLOCID'],	//$.LOGON.LOCID,
			aPatInfo:PatInfo,
			aLocFlag:LocFlag,	
			page:1,      //可选项，页码，默认1			
			rows:999    //可选项，获取多少条数据，默认50
		},function(rs){
			$('#gridAdmInfo').datagrid('loadData', rs);				
		});
		**/
		$('#gridAdmInfo').datagrid('load',{
		    	ClassName:'DHCMA.IMP.IPS.IMPRecordSrv',
				QueryName:'QryRecordPatList',
				aDateFrom:$('#aDateFrom').datebox('getValue'), 
				aDateTo:$('#aDateTo').datebox('getValue'), 
				aLocID:session['LOGON.CTLOCID'],	//$.LOGON.LOCID,
				aPatInfo:PatInfo,
				aLocFlag:LocFlag,
				aCategory:aCategory,
				aDateType:aDateType	
			});		
    }
	
	
	//加载感染科室疑似筛查汇总
	obj.gridLocInfLoad = function(){
		var aDateType ="0";
		if(LocFlag==1){
			aDateType ="0"
		}else{
			aDateType =$('#cboDateType').combobox('getValue')
		}
		var PatInfo = $('#aPatName').val()+"^"+$('#aRegNo').val()+"^"+$('#aMrNo').val()+"^"+$('#aBed').val();
		//alert($('#cboHospital').combobox('getValue'));
		$cm({
			ClassName:"DHCMA.IMP.IPS.IMPRecordSrv",
			QueryName:"QryRecordLocList",
			aHospIDs:$('#cboHospital').combobox('getValue'), 
			aCategory:$('#cboCategory').combobox('getValue'), 
			aDateFrom:$('#aDateFrom').datebox('getValue'), 
			aDateTo:$('#aDateTo').datebox('getValue'), 
			aPatInfo:PatInfo,	
			aDateType:aDateType,		
			page:1,      //可选项，页码，默认1
			rows:999    //可选项，获取多少条数据，默认50
		},function(rs){
			$('#gridLocInf').datagrid('loadData', rs);
		});
	}
	
	obj.gridAdmInfo_onSelect= function (pindex,rindex,objAdm){	
		if ((pindex>-1)&&(rindex>-1)) {		
			$('#gridLocInf').datagrid('selectRow',pindex);  
		}
		if (!objAdm) return;
		$('#divMain').empty();
		
		loadingWindow();
		if (objAdm) {
			$('#divNoResult').attr("style","display:none");
			window.setTimeout(function () { 
				obj.BuildPatIfo(pindex,rindex,objAdm,0);  //加载单个病人信息
				disLoadWindow(); 
			}, 100); 
		}
	}
	
	obj.gridLocInf_onSelect= function (pindex,rindex,objLocInf){
		
		//清除明细表格选中行
		if (obj.gridLocAdmInfo) {
			obj.gridLocAdmInfo.clearSelections();
		}
		if (!objLocInf) return;
		$('#divMain').empty();
		var LocID = objLocInf.LocID;
		
		var PatInfo = $('#aPatName').val()+"^"+$('#aRegNo').val()+"^"+$('#aMrNo').val()+"^"+$('#aBed').val();
		obj.PatList = $cm({
			ClassName:'DHCHAI.IRS.CCScreeningSrv',
			QueryName:'QrySuRulePatList',
			aTypeFlag:'1',
			aDateFrom:$('#aDateFrom').datebox('getValue'), 
			aDateTo:$('#aDateTo').datebox('getValue'), 
			aLocID:LocID,
			aIsInf:1, 
			aPatInfo:PatInfo	
		},false);
		
		if (obj.PatList.total>0) {
			$('#divNoResult').attr("style","display:none");
		}else {
			$('#divNoResult').attr("style","display:block");
		}
		
		loadingWindow();
		window.setTimeout(function () {		
			for(var indPat = 0; indPat < obj.PatList.total; indPat++){
				var objAdm = obj.PatList.rows[indPat];
				if (!objAdm) continue;
			
				obj.BuildPatIfo(pindex,rindex,objAdm,1);  //加载科室汇总信息	
			}
			window.setTimeout(function (){
				disLoadWindow(); 
			}, 300); 	
		}, 100); 		
	}
	
	
 
}
